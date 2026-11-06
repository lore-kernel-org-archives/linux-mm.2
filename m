Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D140606A32C
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 13:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=owu+eBld
Received: by kanga.kvack.org (Postfix)
	id 767216B05B4; Fri,  6 Nov 2026 08:26:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 717336B05B5; Fri,  6 Nov 2026 08:26:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DF0B6B05B7; Fri,  6 Nov 2026 08:26:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3E6706B05B4
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 08:26:14 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7A1EF1A0DEE
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 13:26:12 +0000 (UTC)
X-FDA: 85404767784.14.E3F8A59
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf19.hostedemail.com (Postfix) with ESMTP id A78F81A0008
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 13:26:10 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=owu+eBld;
	spf=pass (imf19.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793971570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bo79EhOtJtgULvq7bZxVFopW/hSbKrx4G7ruhOSax3w=;
	b=aLBF+gbtdsmmZPHxX57mQYX8zokh980R8D2WCRQPE+FMdfw5IjmxX5fbYihNrmQnDKwrmq
	xZRfNvhDDU6kLbacVXegqB4EClvpgOMcR1Z/7sunhOe7n0ijd+P9rPKtHlWsgS8PRUf4Va
	bRPxBE5438xd7nEKEoxbcIsfduD3MNI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793971570;
	b=WZybK4K5vOc27rJtPpqvoiyXW2XpjT11hGeU5/+WIiWiB1FzYk+j29uC5lGsXpTRIAlBZh
	HM/FBOkjhB3Ju6Xq7NJqXNVhiGJHE6WNPph90x+gmzE8YILTs3g+uXSX7OU7IbmQmRsoZh
	W8ohAPJag6IsJb0jkmaWuLKWlroxhmg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=owu+eBld;
	spf=pass (imf19.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-3b0d0b80fb9so375911a91.1
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 05:26:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793971569; x=1794576369; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Bo79EhOtJtgULvq7bZxVFopW/hSbKrx4G7ruhOSax3w=;
        b=owu+eBlddxfyJulBFWOOmoQWEiCNw8vW7CgZm3jbWxugdk6+P5yal/LghMxUlK4wKI
         NH/pGlWxpg39RNxxrESzobTGj6ou44ZzTT7yzgT+lSyT89pzWNlEQZnPnom1t0REdxpL
         iRRKhVksTrzt1+Ci6M4m1UjiA+LR6WgoD+2HrJjKTk3pE1FkqJMdOE0/ne69//IIzF2Q
         I9g3OgbgGRhzV1dlhQwRGrr9zWvRXcM0iuJHGQopo1HPZpJkiTzSM+F1ekaRsdASISgS
         r1Pu29rg/tn2f2Yzv8pXtiYd3AVsQArEuU8AeXS1G3SJWXJuC1tR+N0IA4MoXq/RU3sa
         iSmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793971569; x=1794576369;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Bo79EhOtJtgULvq7bZxVFopW/hSbKrx4G7ruhOSax3w=;
        b=FukfNqEILR9cEC2oYmDn20AKSBnUZ9kQ3AIYslnqKwVo9miBEbH3PflPCCQwhv4tgp
         QK/YCr5+SjDO+roYmfTQUJ1sqyYk2bqh7mF/2t92p/mm6n1qZtzVl24feyIgYYJxZepG
         s47G9tfhrMc3SGZSnUzIAtiQv03aikJ/KWlEIR86LsMHVQIgYODIUI70/o8XCndh7rPw
         /YavVPA+svvqnijuAlMPb/kmZeQQMh/7X/nlDhE5aos1r2/ebPI7v6/HmZt5uMuAlDQy
         8560YVVVJid++kzS7w8fzhNtQp2zXQZy24ymUoEaBEEF3I7QE3/UJf8YqGOYOAbQ4J2A
         S2QA==
X-Forwarded-Encrypted: i=1; AL+hErFjDMAWojfHjOc6Cb+Suw9+CFTypl2t+PwZjHZjaJ4t0z6VhJCI8RBVuDs0VWWrFc31D5iq5Pxo/g==@kvack.org
X-Gm-Message-State: APuU4Z9nu76K6sQsAL6DY4cVbmxzM9zchijJrK5MeeG+TQgMYO5ww/jI
	T9Js/QHgKaEpahGz/Gk9/16UzTmxDTkXr/UtnO6/+hNjoZb5BQ0yGYFp
X-Gm-Gg: AYBFou3mXgySDktqycFXS8ZPtvSmz6vNJcfpUaRy3Gi5Hf9A1REUIccBBHC9XKIKAos
	l7CvoGRemYhIUBifkv053V660QzyE+JvE/W8FkyQmUI2weWmcXAXFrjJfvZTuk7T8flT328s5qb
	cfmcVn0B9SXwwJCCI/53d082jJNC8ys3N+8617x0F8Cfo6R7xyA+yyRXuMhPBuSketG00N1URSB
	1IRLU7/7O4nTffA7AXL9fL9BEn7oxakMRQQAaP75OPFecVAn5Y1IjmA41dgc98K+lyzMQv+uRwb
	cDTGpc6OAGF0C2pgyOS62cR0k0l9Ee5M0CNFGmnAOPpdLYdoTMS8x1AjVWwh1/dr2TQbUwDTxiX
	GcTjx4mOS/QHwDnDIFEBsyixT3Yigu2SDpWaCeRjfatjmxkVFauDtu7w+XCiUl79FZ5bz+Z9cJ/
	H18UJYmUCRnKwJbiLYNjMx4uWtKEjAMT9o3KDQKai5zdC6/BrT73atg4iT5yir7+3+7Jf0xDp62
	vYe2naDQmr5IXqEhDigUnlB2hP7Nuge1sETUvl4oPcCTU3ps0yuttYQsFY7ZAEL6yb7+VAZYhs9
	/FvlvsRWXS4CvM6XKEzNmqDTCHybGuluHaSSogA/zt0=
X-Received: by 2002:a17:90b:3811:b0:3b0:9976:c1c6 with SMTP id 98e67ed59e1d1-3b0db7019d5mr2378131a91.66.1793971569437;
        Fri, 06 Nov 2026 05:26:09 -0800 (PST)
Received: from localhost.localdomain ([240e:b8f:1df9:a600:c693:b19f:ada0:748])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b0b323a1fdsm7888529a91.5.2026.11.06.05.26.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 05:26:09 -0800 (PST)
Date: Fri, 6 Nov 2026 21:26:01 +0800
From: Vernon Yang <vernon2gm@gmail.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] mm/khugepaged: release contended mmap read lock
 after scanning enough VMAs
Message-ID: <798cd192-9ec2-4f37-9cba-44db275a269c@gmail.com>
References: <20261105-khugepaged-latency-fix-v2-0-4384bbfe4606@kernel.org>
 <20261105-khugepaged-latency-fix-v2-3-4384bbfe4606@kernel.org>
 <au3CUJO9zBMHLx-B@gremlin>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <au3CUJO9zBMHLx-B@gremlin>
X-Stat-Signature: fedyuyf6zmpbuemzkaifc7z9w3bqms5b
X-Rspamd-Queue-Id: A78F81A0008
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793971570-594088
X-HE-Meta: U2FsdGVkX19/LZoNB8Rzo8HEBv7c+RmEdJQZi40NFdjSJE80nhL+yK6yyVSPRPvCZ1VtUQNpJ9F6BjnSuiynqzL58iWUMTteUije7KO11v06b61QJ+d+24x/LultntHUNzA0ZuotzDlMCAMfcNonOoDy5c7vKvBeFY5vwhYmd6Iv8ptmF7tUW940dtwrtYKBO59iz284QigBsBkSYl0TXjR/rpdq/5+GfrHNg6MPaYqPXhS41A0JnYjqA3NNz7kGMcuKio/aPPST/oGs/A31RhlbrKrX8wdmmZjF6EEkp8esbBUn3tGxC1eJTC5Y6Z+nbsDwHRzUAwmigk9AaqaFh/F8uSYvaG9p9V0WQfmzCSmI7xss7ZdUiWh20z4brSE9auyD01T0hQZZk+/7cvMc3Hsd07Lyg4xDA4dbfYgyqoKeioo0BJ6ttG7HnU7LUy6EhjP2QvBJnR81gec9uw3CputJ7MS/1YImF4z0EoeTWWpjKoLsmTRKSB0lDVPcBcNr/cQZgQFRz5zerWxr4X4NM8iaKZlmznbIVGH5REASPPqf3ic3fwvaEaagrTW/F9itL2qbFSwkYzzJnIx32496FDBOehAf8ugdOZIXU6biLDNssJNhCBmSJVSdj8AZWsQmbfjEAEle+e2D0P18cYlg13/4G6fjPFvbh21iFH1GgbRNi+K7YwuGqLdwseq6WWpBCyyluq3JUtfSS1uLqshDU9r0OEp6P6I/lLxCbt/JsuPYuAILK1WIsvv8r3q5xc7GC4bdU8PxRQaXeYDQq0VMpdCtCDnrMgBLKg4HsFRsJ64GMfXwAtutfeW0AUMgmTOYLn5xpCvIjRPLcTvKMh6F7/HQdbL5bBAjeTwSv0b/G74haEgqAVczg9QSCmtVyYoIkacMdrhI/RXcFr6WZCTxfhxFzbmR7iZGWnUmltt8Sq7+RRsw4bdRNmEJeZ3Ee76pA81wV8is+OTAYuWmsko
 gekImwti
 iRaj5qYy//po/46a9TMpzazH1+PWizLf0qy98jwscUKpep+AfLPEnLsyOplB3tX44VN0rADaEAcF0Uto4IkLyIju4j/m4xZVxBBXktP7sr295wlWrWotQX7ZUTUI0eUzSB/cG7Y1IXtzAESDAtzyOYTgGPIiVftEYP0xe30xCq99WUSGJZ7Q1NAOlm7s0tfxE2wlcdOQwRoG9Xd6rmMc3Xl/DIRUV25kKADSwZfyPEfNf6MJJz9eg6WCUyqw3D7nh3ZIzCxqUhmtEjv1hachkoAmoms/GWm40t21L9TH+VcN48abBZQgtQrmeB+ECQkC4TXqq+cwvojCQek8NvkDCGzoes6O/+xyQRt+mYgZhG2kEwo/xJTUTZs7BwCKARhr01wevZPcjISUCAXpHcluF4MBKlzBYHjJFdUs5GT9jW6DZDcwIlP2aPb7DWQTGHu9vMDugACSn/JcMdxNRq5osdKtLFmsfElskvF9a
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 06, 2026 at 12:07:53PM +0000, Lorenzo Stoakes (ARM) wrote:
> On reflection, I think this would be better implemented as something like:
>
> static void collapse_scan_mm_slot(unsigned int progress_max, ...)
> {
> 	unsigned int long lock_start = jiffies;
> 	...
>   	for_each_vma(vmi, vma) {
> 		...
>                 if (time_after(jiffies, lock_start) && mmap_lock_is_contended(mm)) {
>                         mmap_read_unlock(mm);
>                         cond_resched();
>                         mmap_read_lock(mm);
>                         lock_start = jiffies;
>                         vma_iter_set(&vmi, mm_slot->address);
>                         continue;
>                 }
> 	}
> }
>
> Which avoids magic numbers, and means if we hold the lock for 1-10ms (depending
> on HZ), which is a long time in the kernel to hold a lock, AND the lock is
> contended, we drop/reacquire.

Looks good to me. Is the test result of this solution the same as the
current one?

--
Cheers,
Vernon

