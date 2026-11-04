Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58579606A330
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 15:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=J04GpwmK
Received: by kanga.kvack.org (Postfix)
	id 6C6206B00EF; Wed,  4 Nov 2026 10:21:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 676DE6B05B2; Wed,  4 Nov 2026 10:21:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5654A6B05B4; Wed,  4 Nov 2026 10:21:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 335C76B00EF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 10:21:02 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C570D14076B
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 15:21:01 +0000 (UTC)
X-FDA: 85397799522.21.B66EEE5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id C1A2640013
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 15:20:59 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J04GpwmK;
	spf=pass (imf04.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793805659;
	b=2ZK9hH9q0tuW3UVxPU4g94iqrzvjGQxJ/hSjj7HGBM7ocavulXBevcdNuy/Wv6MjzF4H7n
	innCYqkmFT6X0wJNTgOFyKK5pJkFcBJgr+C33bdNZkYzk4Sx2bYZzI5ttkTMebdXvzP9n0
	WKQAzI5WtFHxkwwxTIpy2EBZbLL+i/g=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J04GpwmK;
	spf=pass (imf04.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793805659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kJ//CR0rNJB7v4/EWrk6Rgg5jN7w2KYrl2J7vZDJGZY=;
	b=aR2e6Z9wx0edfNwdkMN3LV2wjUEAGtYo969sgJi4kn0t+iffoj3oZh8I9QCfJG1ROSh0tE
	5iQLVG5Sw5UdgkhbRyAcRkT5+QNnOcFXZdGSqM+kEV2+CJ/zijGXN2N0SjBsMXW3IX2l9d
	8p4CE9Db1isU5DV5xiQoC5g2i/UIX3c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 33FCF407EC;
	Wed,  4 Nov 2026 15:20:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D97921F00919;
	Wed,  4 Nov 2026 15:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793805658;
	bh=kJ//CR0rNJB7v4/EWrk6Rgg5jN7w2KYrl2J7vZDJGZY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=J04GpwmKvwAvs5rvSq6YwT5Zq9je2GxUIiTrhVG2nBwZcdPfHjPQfInyEK880+tG1
	 wfkOfIVxeHWCezi8+24T/FuHWcz/MenvLN1yjdAWCXC2ZrjmfrTiZUJcVWGaYqItqX
	 HNEvdX6ssO5Bd5Y9pBuoM3uEqEv4B6EB6MR5ozg/OwrjyfE2G6NoaTFenz5GecG1fy
	 Z3HGwO3J755E9uCjFAWDfqCtB+33seQlaND6Miab8V8rbnvOD7Y3Wq6fC5/3i7/g3y
	 uy/6Ft2l/oJqLiMSM4D82qyRmP26bj6XroqOSTrEY73f/+vP5RL5C1pDGVj8cb/eaM
	 DXKMiygT229uQ==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.ams.internal (Postfix) with ESMTP id 577C3198003A;
	Wed,  4 Nov 2026 10:20:51 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Wed, 04 Nov 2026 10:20:55 -0500
X-ME-Sender: <xms:Uk3rasYNqcr0e7oX_N81eL0LZXGbBpMgeTVyguwhoWE1deuGbU8VRA>
    <xme:Uk3raqkRwJA3NCHdCd2e-3d3UsbBBd3_hWmmG-yaagIX-Kj_QLSPl46GRUdZjMXmd
    9egYpQCqDMYyaNxmKYvMlKUQybVmyetKPdMIXU-MOb4diUc1NZa-UGKAQ>
X-ME-Received: <xmr:Uk3rajF3y4JOG8Lz_bJnitNrMmWcxB_a1dEiDKLOgwUebEP4zXW8dXTCBG0>
X-ME-Proxy-Cause: dmFkZTFtxpiu2LP14cIYcyJ7X5qabzm2BzpkyynMyiWriFQOhwO4iOlilGAYuG72swqRJi
    Bz8ZzcQ02LzCtXShfIs8nQwvr70QyU4BQ3QGSMTor0iqq1/umFVKzuPdZvGyZHpuAWbgUk
    YtJYpDNQU5eGtxkWAafn6R00XepYhmon5wsUybRAp1fyx25PodgGzm5XnTdaZ8/m/W318m
    ueFHNJOCuNFrSnRbN0ljsfFnJhIFQ1CTjoWhk+jPLi5y1GCZF4hKgzXGkldAtCAQq2wM97
    9+7I0RiDOJ1Wn8GcLWLH9LY1cuCc5mxnJslpqjVhHYjF7KE/HVWL6z7MRT7MuPxGnS/eYj
    T29jPgd4eodMdNH4DcjlWcD14WrHarLiWrEOrqYlYVpu7KKm0ZWeANy+dECylIIuTFu7zy
    LTGcyz27eAnQByqLr1NdcAwSH4C/6Q4Bw7Ogwvph1gYdZ2MyCiBaNIH6FMK2y3o0f84Q3L
    p2xKs8qurGukJ22IwBPNoSfbzPpC/KCrGS4y2MDhjbX0uO8R1lWRLw5Qh9VCcyR9s65+qZ
    4KID4H9Y7zzBUjd4hNNMTPEGBXRHn1y5jVskNGYt0nAzzYpN4X2CTMXrDWclf4ZfOq2tgp
    viuCv95jefJTx+bdkT9rAn8PUT0PqPIMnfKlV4uWjYXWOLnG2GEbuK84Ba6A
X-ME-Proxy: <xmx:Uk3rahHKq18GiQZ3nyDskj6S66qC9l5zFlQ6NBrq42V8pWmtDTHxnw>
    <xmx:Uk3rakxgzWtRN7zjBavMjABxjpDUcgRkOH59QIjhgCPm_pfj6wLIXg>
    <xmx:Uk3raqTPchiT8nft2yn3Rv82synIhoZ_VU2xumyCcOXC-vhPUYonZQ>
    <xmx:Uk3raqp12uS3JTOm8qXzawV8IlzevdpwPwxlmD4GdeuBWbxDd4IM1Q>
    <xmx:Uk3raqvxVr0tfkuHZM52LGQpZuZBFJbugGo5z2yo_9nC6sElCg_8FRO6>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 4 Nov 2026 10:20:50 -0500 (EST)
Date: Wed, 4 Nov 2026 15:20:49 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, baoquan.he@linux.dev, 
	rppt@kernel.org, pasha.tatashin@soleen.com, pratyush@kernel.org, 
	ruirui.yang@linux.dev, corbet@lwn.net, skhan@linuxfoundation.org, rdunlap@infradead.org, 
	muchun.song@linux.dev, osalvador@suse.de, david@kernel.org, jbohac@suse.cz, 
	sourabhjain@linux.ibm.com, ruanjinjie@huawei.com, leitao@debian.org, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-mm@kvack.org, hannes@cmpxchg.org, riel@surriel.com, shakeel.butt@linux.dev, 
	kernel-team@meta.com
Subject: Re: [PATCH] mm/hugetlb: allow crashkernel to reuse hugetlb CMA memory
Message-ID: <autMHwldMudQOO3j@thinkstation>
References: <20261104142727.2894800-1-usama.arif@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261104142727.2894800-1-usama.arif@linux.dev>
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C1A2640013
X-Stat-Signature: 19ybew1m63oppj5mzcoxxp35ij17y8zy
X-Rspam-User: 
X-HE-Tag: 1793805659-684442
X-HE-Meta: U2FsdGVkX19WOqu/vI/ALOYdepLUSiCj+Et3AXDJfZPqe7Ksuk4SfbW2yfOie5AfxNspTCWwt02A88K0RsabdU0ofbVQw5TJLXtV+JVptU7wuRkx3OYCtfPlCXNrHcj5jb8P8vanhU3xngiGejs1SoLueHZQB7GbPqJYDivzRcYL+RbmyuX1OoiUo2Lxjpn7HRHy1s3TFxJR8S/63BG0eGVjCTvOlcA5WEHQclWJc7PbpxPpHFLAtV4ojdUb80vZkABo4aTgArt+JhtircXfnPzqGMdZKsk2EzNxk0COYAkUgIceMLbShAkP04UyRzSTJYdhZ+IwF5JIlBBBE1gap5AO5p5bCA2AuglJPyAf9CybPCZyE800EbqS61bhBxcpQyd5slqi7QPbfZY4ryHxaBrSJnJnenr8ydaTmHT8Ao6bz+RvoZ7ZKRzi2JInzXoyu1elhvL4FDXtAXCUvP8F21sTNvpIlqeyTS1cUZExCKzNmV+LA6JDzTs2J5PA8z+bH2m77T83SLOPc1hvMsyhjOTeAuzcRufkRn6zERnleWxfHz3U+OxP1uhBxR6JeDqr9Fj+iLbQl/Q6PPXAnEpXb73y41KJQjVKnjUJ4bBNUCnJ0omaaxO6WuGWq/mzNXRDn5lzVsNOGrK0sWOygEGMUKtxzhy59wbSUCtVSetUO8avMHz9EunCL9iutzEqH628qYzv/rwS1phoGN9LwX+HTno09DXwRMQKGzlbN5+ZEXssHqia9MRcPbGBp2+WAEgfX7dUcjINBButZ7OYdOh7a1dx/ANs/3NBurFSzVRA9Lq5nKqgSoOiONNNUuIS1IJD0FaJzzpkYh5x9QWxchpjGgHrZR/7vQ0WocJ3jDmLsnleqxqYrzcAC+MpHiqnm6A/OTgUHm1dYKSGbc0KwVeHatxkb80n1wtNlSIOpkasB+8Y4zZeBAICsnVhDZdR5SiPHPVQbAvrI8nSf7iMQxw
 3ZaeiBrx
 CpYuFh4IDPhmFCmJbZ9pv41x8RzQCGWiMenWfT2NNWbqqaTjD2LTZNj5xxibya4rEZlyj4R8EkfVIIal4SyxWJLq+USOPhoyWlSe1U4CLBzmHBjbdcn3/Dp5VSId3n21NULUH7hMPelkZl8/pH6gDpaSJYZc0Ns7gKEiNmYKAnV1n4quTaO8GsodS9sOdiadZa6PSzY3iIsk9e7iIxUGeD3roHUyNMMhYXMiuMx0AsOM8xtV7xO/Y1+qODBX0Fnp7AdGRkN12SX9Vefbi2LT50Cx+nQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 04, 2026 at 06:27:27AM -0800, Usama Arif wrote:
> Use a separate suffix to make the exclusion of existing HugeTLB
> allocations from the vmcore an explicit choice.

The crashkernel=size,cma documentation already says that pages allocated
from the range are not in the vmcore and that it should not be used if
dumping of userspace memory is intended. HugeTLB pages are userspace
memory. I don't see what a new suffix makes explicit that ",cma" does
not already.

Why not let crashkernel=size,cma take hugetlb CMA first and reserve a
dedicated area only for what hugetlb CMA does not cover? With
hugetlb_cma=6G crashkernel=2G,cma there would be no extra CMA at all.
With hugetlb_cma=2G crashkernel=4G,cma the crash kernel would reuse the
2G and a dedicated 2G area would be reserved for the rest. Either way,
nobody has to learn a new option.

The catch is ordering. reserve_crashkernel_cma() runs from setup_arch(),
but hugetlb_cma_reserve() runs later, from mm_core_init_early(). The arch
code could record the size and leave the reservation to generic code
right after hugetlb_cma_reserve(). That is still memblock time, so the
remainder can be declared there. An early_initcall is too late for that.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

