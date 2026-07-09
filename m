Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53A05C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 01:09:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10CD66B0088; Wed,  8 Jul 2026 21:09:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BDEA6B008A; Wed,  8 Jul 2026 21:09:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC96A6B008C; Wed,  8 Jul 2026 21:09:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BFDBC6B0088
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 21:09:17 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0BCAA40369
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 01:09:17 +0000 (UTC)
X-FDA: 84967454754.01.16D2D9C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 715B02000E
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 01:09:15 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WgETxV6r;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783559355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0FaheSr3CaISFRxMibGkeH5Y3VBuv/2lrq9rBo3xqu0=;
	b=4ozsoPTUEZ8QnjV79DOOKly7HnescA6A2Ja+tXVveO6l0fAbrPev8UiKtvwE9XlbUbhwf5
	3LwWE2S2YE4Sfydzuojt4csUkQ2ZxKlPRaiC5k8L0ZgBBWuTi/g3HLF4+eICMlrAKv0WG1
	9jT2RMZqTLFh/eWTsp4/CzR2mXVx/8k=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WgETxV6r;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783559355;
	b=gLchm6+3DyxrtQ5SOthPd0F+SBFYmO3UcXrd8YAE/jfXrqrATIDyycyhG8q/U4nW/+Nwy8
	JpBOnPj5YmX4bSaEljuwBBlodaW2r2+L+seY7DLtvpfscuRdjdXGrlhdXeVFzcEkuSbNEZ
	98sj2RUdmMK2PPyHYsUs8kdfMYshq/4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C367D6001A;
	Thu,  9 Jul 2026 01:09:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 624BF1F000E9;
	Thu,  9 Jul 2026 01:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783559354;
	bh=0FaheSr3CaISFRxMibGkeH5Y3VBuv/2lrq9rBo3xqu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WgETxV6rAx1ERycUu6u9WCbqVuHl6Hyzu9meHjXRxKF7kESuWae2ehr3Ni/fyboBd
	 hQia3X+EkmD4sQoHev4N4l/hjKFzwapBPF6JhRoAe5gESXrTv3j3MugfUYB9ELt6G3
	 51/VYGBppnEoBIR0vMnEoyReilySCjg/AenrB0V0aHERBnX3wndIqm+/CMggKkmpg3
	 d4XLX1R04Lm7z+OeP5cqlM+r9tJTJk8s2ICMHDERD02tym2PGcKTCqzdNX5NJm8lY7
	 V8ePw67ZEQkXX879mQ6/3a0ww0bMW+JtMy9jm9eBtopzlnHVXeS0UCiAB39PLkpC/B
	 8bYG628vFSxSQ==
From: SJ Park <sj@kernel.org>
To: Hongfu Li <lihongfu@kylinos.cn>
Cc: SJ Park <sj@kernel.org>,
	jgg@ziepe.ca,
	leon@kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	hongfu.li@linux.dev
Subject: Re: [PATCH] selftests/mm: Fix memleak in migration benchmark
Date: Wed,  8 Jul 2026 18:09:05 -0700
Message-ID: <20260709010905.128451-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260708103705.840679-1-lihongfu@kylinos.cn>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 715B02000E
X-Stat-Signature: id6upyttrtxt757eje6qfxu8hbnt4aay
X-HE-Tag: 1783559355-948692
X-HE-Meta: U2FsdGVkX19ZskCCN4NHhP5r7jJuwPVPgRBNh55R8KBBifXJ+MoNtVRtb7yvrH/8MlbkOtY8szZ8db5+PMG/hvrQETvAkqjryfQA1wp/ly9hOHiCZgRhQ6wJDxSxcmSI80y1O915NoBtHESN3UZX/IIcJsF/ky3wGP8Bd+lysPvYyu56Rgpv64c2GGn2pFRVjy09Uzz6MAyhk/iV8NAhYVPL0ZcrXnTZn6coDykc0uKBJZPr2IQoTIlM6jFbFNlRjLBk+hbY2G1BZB/Hapbynt/cWF+cxxwptfkN1I+3IHGjG7EbkWqJI2UW2LVoYKMcZIPe3bdAKXN/o6IbzP//O0/Ik2K4l0x13zAu0u5l2JDFwNh2IgPpQzzygkf5gJtI8tqVwbXRQpEQVbsnLQbf2YblV9bItL4vrkmo2MSn12BNVR4fSrF8NPrC9bJ5+BNVQjMCv5z9gnVDnceedCJxO170pYMW8CT+6pYx6984zlKRJbZBxkyLUOWEo0Wu9/sRVEFtfs1XIVejQbpBCmrTFKWYJn4I3cjBbVezGwgFJIJ93AdceVylQNmr0EwnFLcpG6goQwoB1FkJHAypFkkfeOsXzWbA+KBYVgl29uSuiK1Gmq0tk3e9QBHAsnTdJFDPrqxi9ryEJboyWcvPqQ9e/68YTiGyla7w4DNZVdO/dYGt5u69x+wC/bcyAvYkEm3IJxc3ocomeOD+UnJZ8Te4jUiB2n5hcU7dzbPcR5+eHvxTvRri+sJtQPmvnQ0Bbw4hDer5kDuuzz+Fdin6RRiuO6jIj8yU9xACpkZu/fl00ekm1VgMoeY9NuNx4rDpwZjByjv34alHLDoE4s0yU+v97Vcz2iYZw61fOXTIBQxGmVy7dZcwd7R3y10IaivPRrOdUaDDqzv7YfiHnMLw3CG9hnKHg0IGd/5gJ1tRQMut76PXM7XaKPeeVACCqeGDQq9+0KNbL/hzc/7QdSt2uNl
 2LUCUu+c
 MmyzQ4cEMR9iVxzJ52itkFJ1LyISDCaJrgc77dvypC4Z4fw8P3Omngvw3fDGGOf0iY+HgP1lBOfRIEejWtqlBz1pUoCfHzDIZx7YjCclsijZDD0YikGwDfpQk5tu+8f5nTfeoqvgwyVkGNUo9g/iGeqWJC7wivYOPakjXJMMzvW7vHyqtsVb/1LZzMq1mE/+4dINgsrvs/dlefSg1+OAdhpLqPbZzHw6uw3FwWjoPOpQbEmw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  8 Jul 2026 18:37:05 +0800 Hongfu Li <lihongfu@kylinos.cn> wrote:

> Several early return paths in run_migration_benchmark() skip
> hmm_buffer_free(), leaking the buffer. Replace with a single cleanup
> label.

Looks good to me.

> 
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>

As David suggested, having Fixes: would be nice.  Seems 271a7b2e3c13
("selftests/mm/hmm-tests: new throughput tests including THP") could be the
one?

Reviewed-by: SJ Park <sj@kernel.org>

[...]
>  
>  	/* Cleanup */
> +cleanup:
>  	hmm_buffer_free(buffer);
> -	return 0;
> +	return ret;

A trivial nit.  I think '/* Cleanup */' doesn't really need to be stayed there,
as the 'cleanup:' label self-explains what it is doing here.


Thanks,
SJ

[...]

