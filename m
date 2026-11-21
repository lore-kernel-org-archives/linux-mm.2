Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01C21606A333
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 15:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vcsNm+5F
Received: by kanga.kvack.org (Postfix)
	id DA5F76B05B1; Sat, 21 Nov 2026 10:38:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D56756B05B2; Sat, 21 Nov 2026 10:38:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C44456B05B3; Sat, 21 Nov 2026 10:38:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9E7EC6B05B1
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 10:38:09 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 249AB1A050E
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 15:38:09 +0000 (UTC)
X-FDA: 85459532298.21.097C2B9
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5A8B6120006
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 15:38:07 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=vcsNm+5F;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of kmehltretter@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795275487;
	b=RRZbSeh6Hv8GcUOjhnkdeOf3DAVHZxR7aPrdz3SZWlaRRBjkB4pyPBX1Vd5qodLtEdgOVM
	G1Hwc9sJsi1UmuhYgBSk3/VkZQ3YZrtV2c7GI6qsHZrMSvrAai+Du8vtz6wqtVT51p4S/D
	twSjYb6b4w/ce010on/C+bU0ThnWOX4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795275487;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BfoBaMoCCGI4vvuBFtM++JU7Un6qYx/YS0fsp6MCiU4=;
	b=j85QfYfMN2sZatmlV8KBcRekpBkdU6UFGMHxNZH6skUQb6VsPmobHYU33pFUfGykwAQre0
	oRdEgRM6RPo7gr1MPfyPpMPqipF5pGSKX9v37Xvx44YmOL1aHHaT3koEjkTIcTAgdyGaO5
	Hd3HdgwDHNlCFIGqX+sVCQ6h16Xo4HM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=vcsNm+5F;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of kmehltretter@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4bb70074ab2so18574695e9.0
        for <linux-mm@kvack.org>; Sat, 21 Nov 2026 07:38:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795275486; x=1795880286; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BfoBaMoCCGI4vvuBFtM++JU7Un6qYx/YS0fsp6MCiU4=;
        b=vcsNm+5FEJ/wTLm9iSIvjDYoEFErmWO4m1LSRINhLbeIDHfXHDNSmKXhowRXbYXsDm
         A0YMTVz3iMG9KdX8L8GUx4G0BBAyZaBNQ+2tnpz8h4K0aM1nVVKwHNEjY6SuX0RWC9IH
         mGCLIWAuq/7C2EhJWyYIm1Na7FGDcDbErzcPOYbMOeeaEgiPHOSTIZV8rYw6+/slGJEj
         hPWAF5bwjqKYQb/2nR/d/hHm1Ew0FGU4w//0/h0omLnQ7ZIFtiWqS8OR5so6IQReY6eG
         UOK/9XI/UY/jx9RB71QG/88idusKMwgqzV5y4Kvq9ZKD37qJXyA2+Rb/G+6l4lT/0Y4w
         FRaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795275486; x=1795880286;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=BfoBaMoCCGI4vvuBFtM++JU7Un6qYx/YS0fsp6MCiU4=;
        b=W8jCXSTKB0zNq7+80YLIv1kOs7YbKgZed9t/FjeJle16XdvPv3wIfSkkvd2Hgs/OeJ
         bRYE2l/bjowp/U7DjejUroDUXVG9XfTVrEhrn8f2zX935awDTz0B5Njgg3EtIVEfOxjX
         fpwZ8vw56BIPQDMXKBDoYoob77Ie+QHA12YpdYQwxejb9/+4+xZ+ChQ1BY1PZHbwDqX9
         lAHifFyu4tgSGNMR9ovbVceN376Bg7YOPIVsiEUC5o+K1MGUr1P81W9jJ13aEipV2UNG
         VgB9hdvBSA2PYGZBiQ50OVoPFAA1zvFSsXNhinFJEmtvMICcyGw3uYVXwTLvXug0pDIe
         BF/Q==
X-Forwarded-Encrypted: i=1; AL+hErEVIqnPPCkYwZi+lyWHRHU46G0QLTcTd9vwk6B6AeHMX254rVESOTNKV/WH/7zSVCckpz0ekamiJQ==@kvack.org
X-Gm-Message-State: APuU4Z9nOnwKQmLGTM5khBToJl0dYHm//TfDHJ4YeuU6oAA8txkqONXX
	j0veyiRULS92ZKgfCzJ+TIUI+QRrok6jhyfgAqnOrrN+VwGm0zf8oGx2
X-Gm-Gg: AZFdTZeHVSU7FTVtj5CFbif+QaAOjwhT5v8/TlS81bn5bM7LY1R4H9N4e5Z9qsWYp0G
	5HESHMwjLCQBow4KE7CPxnyKeVhhsXHhqcoPWRkVTQgvkDpBz1avsWSDwIfoZS3Dn7+Gth2rqfv
	7epZ5cwWldSCrSR1zQduO1ynRHxY28NsRkEFL4s8YXgN6z46u1RiWnxyzkiVs/AFkHgJ/rlR/B3
	3kUD37nTR4Epbqwbkp9C3GrBjwXu7uMBDHqlfaUfUyMjQk2vXpTEJWzqvPln5jFf52eKPcWbUks
	3YocI/mC/fYbIVOx1GztZ1iReTeFs+Rwu7gMUqWy5bH4QgFOyr611jyvf9XL6acLw0YxoklyRlr
	p/dEhxSUeg/875LDW9+Yuev1rcAneW2nraf1TrpDAhcDKdwMTNedBbqkr1u5sGszuKyI4ZLHW3W
	1hNtTzdLbxtBx6tRXOyq3eI9/hJUkdotwT/N77n9wAJ4zKfPjiUjhPARLV8M9itsfxxzjrpRjxJ
	TV6dCq/1lpk1Z+aRxxoxWERBrYENW2h5xVgNoHW4q36HwljgjSiuKPIOS2jcpoPkYeDMG4aK53o
	UpQ/L7cQLdxWmFE0S+Lw8pzwxkFE/1JBGEQGmxX3tBuzu9CmUgEfOVUCSVWIx0DfuaZNNL2r37g
	IxU6V0owxYUSeuhPkh6mUT+77PGZczmVbXtfOh7dueIZyJB9XvmDj54no1TMlOzzTVKKOGoBL8q
	cJqJTvmPpTkiUahe4ZCsQNvQpsezPp5d25
X-Received: by 2002:a05:600c:5309:b0:4bb:62d5:4ab1 with SMTP id 5b1f17b1804b1-4bb88924a5bmr152319025e9.33.1795275485728;
        Sat, 21 Nov 2026 07:38:05 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a02-3100-aeb0-6801-ad74-bca0-dc5f-7242.310.pool.telefonica.de. [2a02:3100:aeb0:6801:ad74:bca0:dc5f:7242])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb884b7515sm254688665e9.13.2026.11.21.07.38.04
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 21 Nov 2026 07:38:05 -0800 (PST)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: "Xu Xin (vivo)" <xu.xin@linux.dev>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Donet Tom <donettom@linux.ibm.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2 1/3] mm/ksm: do not inherit ksm_zero_pages counter or PTE markers on fork
Date: Sat, 21 Nov 2026 16:37:51 +0100
Message-Id: <20261121153751.90695-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20261120074359.41019-1-xu.xin@linux.dev>
References: <20261120074230.40269-1-xu.xin@linux.dev> <20261120074359.41019-1-xu.xin@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: kcux6nh6jh6fnpsb4qmwasis19ukkimn
X-Rspamd-Queue-Id: 5A8B6120006
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam02
X-Rspam-User:
X-HE-Tag: 1795275487-810929
X-HE-Meta: U2FsdGVkX18gBez2n21O+r5gZmYy2ylni2oRGNS5fCjI+Znn9no2HTRPvf1ZS6tB8HaV0RWym+leBewK/6rQzq/NuoEoVMEIwpF+0Ew3F/s1b+P6HCb5lOlaErqSpqi+nX2PpbO3cEH5RMXuQZf53hHQy+pT0h4aMKutF3P3Zpp8fomOEfDKYnJkysewn8Rzdpfwwr5rs9wNFUOrDnXXiqR7acB7w9zKaZR2HJqdGpDzy9xco5udHDBvzF9zxHVh6SLEtJijtQaQC6hDNCWKdCwy/DNiRx9kLPq1lo6shnwsqkA58tH/PYfb0l5ULnWWkFpK/Vz+yM0tLrh+Km5pWmzYa8qPNTllWu3q26py6NrXv8p+jIbegdHwT7rfL/UH7tWIH+I7nFtajvnhc/iVqSEiUhRJM5nDHugaffTYp+wr+V6xMHtfIzesKkFoIn9Htyc6Nwd+rd+sUrlSoPEjB2OgdzgnS6v7XNN2AOJYEfWsYX2eKNZwQ/kiCuM9F8spWejt8gBm/7x/63XLdayAFgPhE1km3dHPb8QwHUg1DXoZzyWBkZz6TKKlfQYfRe3SgPARhDbfpDH/VHtvhX4M3IBK+vebhCzJM14d5fHNWiVRjLEhM8vxyajKQuxtLk2xLur2sRDWKbtDVcTrjvXtM/FNSnih1k5f7AgwiqWnHhkSuRB8CPx91QFlPELYXA5kywJQABmwv6oqe/sfQxFtOLPV8Tqd8JX89ubppzdh5Hh3r4WhaC44We6oo+q/vqNG7SHUInUcOtFi8m3kJdohfGH/dOccqa6aEC8hK8Vzfg8b7W2yYOFISxjogjVRV4nb9umcLKn0i12geX0N/AXy/OOACZ76OHnUDSAXozbaVXtdRxD+UjzLfgG5z1wrl6ZYS86YJ14o8exvF/igK0xHJpxRP4uD8UNXB/XZr34Qo35V5KQ3pD+UtHzitBpG/laTibV3FE8yVEUtdIZAI53
 ZTn36Hh4
 yzknT2921D1R59a+GxkUoAreYEu9Gj4mELAldDqbc/YETKV6yjHPaowasRhv1WGSJt7dGwQgEzTWph8YTdxpkCBMNrHpahQ2hsHf68gyEX7oPZ5c0j33BTIzFE7KTE93odH68CnF4oHGEfzrszkVQQIn+TtHJZPUquZ1+xx242FpQVV8NpIQJz7PoDx2mwMWgGaAEgDL5fbN22jtMyBlvDufaLp4/gnQ5CJCkVTuTYWnKg3A+suAqd9WoXVNQENh324JlgFCcon/EA6HZEdUPAm48axy55ab6Q37BjQjIopXFQUr35a/5VS1msmNF5vPPtZkVp0O5R033M5TmUKzKqc6XsE70EpuO28qR+/Pz48Hb5uLn23QmkAV2p8MJOOj2TepNccxQHdaQiS/XLQRd+ewfmAiDM3tJs2rNmVo9/HlJcLLTL0Z0jaQqq7AMiwmmji/vTQ2PufVOz11hI7ZGVreRJHbX4LYg97VRWLV4DnjiGr0AjRwvdAx3fOxHILZALWQH6qWG8vIeLDITcBZAvGMHEwZmRdUMli/AK5X5+hnyd7CBnKeLinp/kIImqsp/j5eDjVnmfrO/XU9Drrx31C2yPR/RcJnX1uZLZAk7McWnQdP9OKYfh3R6cePKPHl/GD6YaM5Pa93SmhfFRhVC60zbC6GTgEewodbM83YJRtU9pLHoCv7iGJ99WA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 20 Nov 2026 15:43:59 +0800, Xu Xin (vivo) wrote:
> With the marker cleared, ksm_might_unmap_zero_page() will not
> decrement the counters on child exit, MADV_UNMERGEABLE in the child
> will not unnecessarily unshare inherited zero pages, and the global
> counter remains untouched.

Confirmed on mm-everything 758802f13004 with the smart-scan v4 series.
A test merged 1024 zero pages with use_zero_pages=1 and forked. Without
this patch, the child started with ksm_zero_pages=1024, the global
counter doubled, and MADV_UNMERGEABLE in the child allocated new pages.
With it, none of this happens.

The new check from 3/3 fails without this patch and passes with it, at
the default ksmd settings. Both tests gave the same results on x86-64,
i386, arm64, arm, riscv64, s390x, ppc64le, ppc64, ppc32, mips64el,
mipsel, sparc64, alpha, parisc, m68k and sh4 in QEMU.

Tested-by: Karl Mehltretter <kmehltretter@gmail.com>

Thanks,
Karl

