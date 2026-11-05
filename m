Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59577606A32C
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 12:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RYGzJ9/p
Received: by kanga.kvack.org (Postfix)
	id 770016B05B2; Thu,  5 Nov 2026 07:59:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 748596B05B7; Thu,  5 Nov 2026 07:59:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63A226B05B8; Thu,  5 Nov 2026 07:59:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 44E966B05B2
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 07:59:43 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DB0ED140594
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:59:42 +0000 (UTC)
X-FDA: 85401072204.29.AD5386C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 413FE40005
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:59:41 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="RYGzJ9/p";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793883581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z/gziC0JLIrvCdp4GmTMosiOJuTAZ2fDyAiYOPUD65U=;
	b=L0VtkrXk1MDRKsesuLYcew1sA0xgSpckYOC2oDryVVqFM8LsU0X4oGeC8OzW863u2VtAur
	bOQYOmyz1ZKfeJkiQqPYsU1fEqcLotqOlAs1u7LKyIu/bSy+JrL+5AvNOCDNFMy/htf8s6
	HaBtzMN+9ykv+4LZzl1i8aOkoQR3ZFs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="RYGzJ9/p";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793883581;
	b=cauPwM6fv9z/4XtVSx78wLGdMNaOhCGoDU5zAJ7h7BeJZ6qYEBliZ/bZM/23arhQi0FCSc
	fWBRRascd2EbdA/G/DPJJlKYgYbRCKeSP4sXVveqYXQdhXKMSI5QFpipZHUmbHZ4evMTJ1
	Jr0LWkGHT/Twp7hGHyOFz/IJ4Y87tpE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7CDDC40572;
	Thu,  5 Nov 2026 12:59:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E19611F000C1;
	Thu,  5 Nov 2026 12:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793883580;
	bh=z/gziC0JLIrvCdp4GmTMosiOJuTAZ2fDyAiYOPUD65U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RYGzJ9/p0iFShU47y10rrIgFqPZdTiGgb9DmbgiqklepkrzDPFw2kBC9/2zqeWEUW
	 viaCxlogpvwX+3aCC0Sd8lUceLDljigJa9iLlCb9F10Yjlhj3iUQLny2d4YgsfoDa3
	 9/gwNyB3H1+V9zLO+cNJVvrzMZehr/KQStMXx3w7NBURr+o996im+MYc36G4g+NxEN
	 se/C/q0CTuMLefGDtpMkVF12OHR0TuBO1Ct6i9ir8QX5vXEXIKFI4HlBRW8n78msRp
	 hj62W4vFhO49wxFNmhDB+OVuLmD4BbTZ7PH5QxouxT1NQe2LKzMLX+QeyIgefcxJfB
	 DoRApwQsIJc5A==
Date: Thu, 5 Nov 2026 12:59:38 +0000
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Hao Li <hao.li@linux.dev>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Geert Uytterhoeven <geert@linux-m68k.org>, 
	Conor Dooley <conor@kernel.org>, Damien Le Moal <dlemoal@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Alexander Potapenko <glider@google.com>, 
	Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, kasan-dev@googlegroups.com
Subject: Re: [PATCH v3 01/10] slab, kunit: pin test slabs by an extra
 allocation
Message-ID: <auxzbxa40B6uLAyN@thinkstation>
References: <20261105-slub_tiny_rework-v3-0-0484ce59eabb@kernel.org>
 <20261105-slub_tiny_rework-v3-1-0484ce59eabb@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261105-slub_tiny_rework-v3-1-0484ce59eabb@kernel.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 413FE40005
X-Stat-Signature: bkzj55pa6h89bwmd79xqebj9f9q4nece
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793883581-354356
X-HE-Meta: U2FsdGVkX19hVJC0LSA5p+BRLC7IaLilZD+G22cMyQwll5X1ZsTD4uvGdEYbc9++SxwIfIYwRW6AXKL92VlpEUQYeK0UhGJhL4whLixZsqvP2ZJzdqyzbcfUj+L96fLjUheLY/6MqH8I7TsH+002WN+0uHa81Pkpqy4VJTR8w3qc0jinjyaUOuiz6ye+O4i2TcJ+ECV3rYpn4PQdL5PeLpTYHXRiUB4bZT7n+UgdbQughCFW4DhpWSSa/GdU8vCh6pLtP067MyHN9AIULQUx0TXMD4gr26nELqxFCKAyHULJ3ge9NZ2oijGkgtCiReC9TcWuDewq38O33JNLKSp+R5tMLXGjqW0QHkBlFUB1beiZkCmxlz8ecHnHxHrnykR9+gg9Aetot2lB91p38mPHlBWoiXRbj4Tw4yxfctihoM2x7H8EwQxNPV1saiEfn1NhqrG2AD5WmJi+FOAv7wU9RlZ5IXljDEZmHaDkia3q0X/zqTE914SPe4ZnO4LpRs5FG3b6YIcJ2uAz1M2U4NHdqDiVivAsKtLAoJaMmSw2ZsOFgsp1PtO6PAk3TfscStt16A8Ragm/FN0N+FwwFuwtahRXn/zCCqWUX5Fzl1TAHXZHjIyeTMMqi1vrDLEZujOBd2E2eFNbORPZ8YE1nHt15BLuECGrOxlF0oaO78L0MBDvylcub3TFSYCnie9rNOFEI75fLa74AZ0EQr3DiCu3+RTF5Y0PVoRcFh0G3ynaTjskh6JEoLIS0Vw+S4SvpC0iixCaSPqXAhjuSld3Kbhtv4RNVONzoUaqutjK+tnNCyB0gcfKMZ3fSJJVU7AH9uVRcm+ztysZd9hx9XmXh7Evbv29welFddeqmE7xgwDuDqBtAtqIuSXb21GLBQwEqhK4zzppUCKr7KNkUDUfS53MvRVWbtSEm16AuRBiR25tVR/IDQkydxgouSeDTngmfcVS+IwnHXiua9k/xb5Kw2S
 1XY3hpgf
 azAjXCRxMKvBYLc1QD1LY/LMrwoS0AAV990M3655Olf1zfuawcgQ+Tz9J7NHJMr+2xt7f84z/w+WOHrSZvCN5Aae6SMExh8VBjdviqcYqVe3iS+WJJ1d/JPlf1VbqIJ62f+fatH3HXnsKjJKlrwGp69LWDlMM73TpsE2VeA1H+LzMUGyEeL0Oxk1zV/GwaA9Hj98C2umKioR2fUzhPU7zNNdLmEk7ecirWEAkSnLleTmrNblexZhNtIg1nLZt9cHD2YJAIH9Lkm3ZUypR+btO3PL5ykZH1niGXLAafjq+IW0XSZ+uCh7LUiM0fz0sPY7DfTMIlSuDildNR+TZBdKwzulqdWaKhRV1qqhG+G2PjQU6u1vwZmBYFWlanUVSy2Gv3ioh/smYAFNP4vMPp0QZb5SIONipbj/Dr5rf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 05, 2026 at 09:43:50AM +0100, Vlastimil Babka (SUSE) wrote:
> Several of slab kunit tests allocate and free a single object from the
> test cache, perform intentional UAF actions and validation, while
> expecting the empty slab to stay on the partial list.
> 
> This subtly relies on non-zero s->min_partial. It currently compile-time
> defaults to a non-zero value, but in theory a sysfs write racing with
> the kunit test could change it.

> More importantly, the upcoming
> CONFIG_SLUB_TINY changes will make it possible to run the kunit tests
> with s->min_partial being a compile-time zero, which means the tests
> will now do unintended UAF writes on the page allocator level, and also
> report failures, as flagged by sashiko [1].

Makes sense.
 
> To prevent this in a robust way, add an extra object allocation to the
> tests, that will prevent the slab being freed. Use migrate_disable() to
> prevent migration to a different NUMA node, which would place the
> allocation to a different slab.
>
> [1] https://sashiko.dev/#/patchset/20261024-slub_tiny_rework-v2-0-bf1419ab5ffd@kernel.org?part=8
> 
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---

Looks good to me,
Acked-by: Harry Yoo (Meta) <harry@kernel.org>

-- 
Cheers,
Harry / Hyeonggon

