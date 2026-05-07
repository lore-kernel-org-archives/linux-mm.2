Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11C6CCD3427
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 12:48:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FC596B0005; Thu,  7 May 2026 08:48:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0ADCF6B008A; Thu,  7 May 2026 08:48:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F057B6B008C; Thu,  7 May 2026 08:48:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E13286B0005
	for <linux-mm@kvack.org>; Thu,  7 May 2026 08:48:43 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7CC3912031C
	for <linux-mm@kvack.org>; Thu,  7 May 2026 12:48:43 +0000 (UTC)
X-FDA: 84740602926.11.08DFC69
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf11.hostedemail.com (Postfix) with ESMTP id 72FF84000D
	for <linux-mm@kvack.org>; Thu,  7 May 2026 12:48:41 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qvfqq0Mr;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778158121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pSSRQxdxncErXCf+M8Abk9qqkUbDfMbi4JtFvztGRiI=;
	b=BX/gwmPgs6d52oKWyUNvrqNz7cqCkaaKgLHzAySDk/rOPBjBRPbHDksBZphWFqqjsTAbf/
	CVnWmSw7hD8gVQKzeLWaUyvcCGd4aEb27xVCdZ5vudYuWEKn8PJzG+wVETgGJ8eQQYh5v/
	I9e44yB5PoNqDTnAKmYN7zaV0vkmFH8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778158121; a=rsa-sha256;
	cv=none;
	b=JIN/Byi1M0E7d1T1yW6OIt1ts3ofXTRS8Oiv4YcjYcrus4jBD6NyuE3mYNpH6lJIeDL7Fo
	pv22E7fdloc8zV00Cc9rgG0YMHR1xf9xThvZ98KWx+KKQPxaeAkxCypBxixA39qQYW73qK
	2kS8rRzvDiMmKlME2YyaOS+vyFHEbzg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qvfqq0Mr;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778158118;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pSSRQxdxncErXCf+M8Abk9qqkUbDfMbi4JtFvztGRiI=;
	b=qvfqq0MrdFu3htA7X+3DVI9J1HnuCZPsjnH7d6qjDFNBVDjVLceHRm7h5Pi/HTENRr1KAO
	GRyWvfieSYK0eVhvrs+/NmN2z8p4SYTudIZTFlHTapyXKurKDPrHvMT7J5CFmBGp8vl/HO
	4tcRj1efiuk7XV//++Nf13mg5oiWCj0=
From: Lance Yang <lance.yang@linux.dev>
To: ziy@nvidia.com
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	willy@infradead.org,
	songliubraving@fb.com,
	clm@fb.com,
	dsterba@suse.com,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	jack@suse.cz,
	ljs@kernel.org,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v5 05/14] mm: remove READ_ONLY_THP_FOR_FS Kconfig option
Date: Thu,  7 May 2026 20:48:24 +0800
Message-Id: <20260507124824.96209-1-lance.yang@linux.dev>
In-Reply-To: <20260429153538.727855-1-ziy@nvidia.com>
References: <20260429153538.727855-1-ziy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 72FF84000D
X-Stat-Signature: cw5wx65p54u79phhqa55bz8ii8w8iwdb
X-Rspam-User: 
X-HE-Tag: 1778158121-420793
X-HE-Meta: U2FsdGVkX18qrkUqOkJkBviHFO7A9upsKwt1VW0a16kYOrLqedSZ0OVo1SPs7ljoXnGMPZzJUNzgQAMOV37jz359n12YheOYR/H6TmQgB+Bubo/HblpaA68L18H4kxC5fzEL1P1JSRsIG8X2lErLJ/W1DBVVZfFLbgoIZWkycGjzKBrGWxqnf7Vrm1myEq7SrII1ynM3fM7dVX5TwjJ3YYWafuQoKr5WTpmFZnWch6pXshOPrhpKrR+UGgqQqSYbAlJnNlmIpUKz2Bn1tMKPxnBcccYrkrgqPQMcHBbwoR+fwtwu9SCkQrM44ibqqIlgTBfgK5RX6vUsKXP/waGhSL8fZsxIONGzGNnvu+q5jYgtjsY2DL8km5KbO8pl49mrS//Egmct4LSNZWJGSpBY96liqCK1RUOt1eGhbkAEv+ju3fRCTdO28Lf9TBgQDr+S5Rm/6mXmUCc+jQ5SJJV8V5Ua1e1kBL3PBExfXENVQufXG61bASMXT3ZegR3PA9NE4WwL5nCjHLLSgOdUQho4NZmoLrHA48LvoWjSX5kechQ+TxIR0+XdQ4KCRKCJDXPvwNgPEjQoNiS33EUN38He74WDs7cSep34zYks1B8GQTEZZe+a7AxtC2qZrOawuxnuSYp+kOnz512UKshoT5PoSa95xu1+uIGCJDERDTOS7y9xXpLALVjlxtrb/iibvznoMxpEpIhisJeFIkgGQdGCsdrIlk4hTM/MglEXuAJXTLifBO1aBT9X0Ootpb1lnrohOQvpF/XR2foWHXgCFPkmTa+7rL77I+So45CfDvJPFFfKy4mwaKzd0b1oeoYK4UedpDzBViz+ViqRNBW4te/r2SgMbU5iyGl9KkriERLaE23jZnw+a3oDEvXRbh+xA7YhstFm9/m/AerMSdsPgPcKKN0Qn0ZHhlfnialOVCoZdy3qyQRNFsExWolwOqXfjsQOD3QJvKDNrgxAsLgD9DK
 zMZbFHKo
 g53QYGwB856zkpLOumiRwmVARbcawmXSAyIpdD7FDmgxqHvHbqCwH0BpW5cS31R3BTHgTJCSk0/OK6Gegka30SXovpS1IxSRtZg/ouSZ2mEheqBZCdyx521cHukGGRBsz+n2DoSiVWN4i2iyS4k8OUG9dtTzT16QJHNY5HPbJmXEzoW50I6lOW4n+04qYoZQWLuCgCOvts97P+2NOhg2/i1kiqdmtRC6CQSwGrJ1fzHdP0/UHroAfnfXCk2Gahph+eWGxJaCSWqPkJG/MW1Xd3OOqbw2AjstNlpe2CQLhGVEpMK4IkAacykczl7sQEWG674ytM42TDzOL0BU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Wed, Apr 29, 2026 at 11:35:28AM -0400, Zi Yan wrote:
>After removing READ_ONLY_THP_FOR_FS check in file_thp_enabled(),
>khugepaged and MADV_COLLAPSE can run on FSes with PMD THP pagecache
>support even without READ_ONLY_THP_FOR_FS enabled. Remove the Kconfig first
>so that no one can use READ_ONLY_THP_FOR_FS as upcoming commits remove
>mapping->nr_thps, which its safe guard mechanism relies on.
>
>Signed-off-by: Zi Yan <ziy@nvidia.com>
>Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
>Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>---

READ_ONLY_THP_FOR_FS lost its job now that mapping_pmd_folio_support()
does the gating ;)

LGTM.
Reviewed-by: Lance Yang <lance.yang@linux.dev>

