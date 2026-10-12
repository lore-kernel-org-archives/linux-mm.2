Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C6AFCA9EC5
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 12:12:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7727C6B00A0; Mon, 12 Oct 2026 08:12:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 722C76B00A1; Mon, 12 Oct 2026 08:12:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 610AC6B00A2; Mon, 12 Oct 2026 08:12:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 397B76B00A0
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 08:12:14 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A36D4A8502
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 12:12:13 +0000 (UTC)
X-FDA: 85313861346.10.D09F998
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	by imf31.hostedemail.com (Postfix) with ESMTP id E214920002
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 12:12:11 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LG3tXiTW;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791807131;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HXzuiMJ36ZCZAWHYj2sp9+WXJHPzDv250qRANNhGqJQ=;
	b=LtV+5k+NCEW5e+J2uWPUZODPrQ/2Ea4l3umjDP7NPtoPd6+VrB46kskD8WnTDDesuOV7pk
	5AutZyqBCjQiD7cXsPcXj1b4ViZWsuAJ+awRUnR6UBCIdnd66uWw8l4PjDAUFStY76ep7I
	wGjEuV71Pyex1gBk3CuHAEda02uZDmQ=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LG3tXiTW;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791807131;
	b=ydZ55izgJuGThSx2EW2lJNBP6xM/InZUTtOa/pOzefY6Mx0qIvxSU9nhiRScdStK7MkBFB
	Zyf+oOZ/2WBnrDQRxhtymWzG0TWN/MmHXFRHIBEeL/ZkkURNWZ3JlP5AzLaK6eSrWz3iT5
	B//xft6SxeKky4Hn/+1npwbXiCRB0eo=
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-48870973bddso1086229f8f.1
        for <linux-mm@kvack.org>; Mon, 12 Oct 2026 05:12:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791807130; x=1792411930; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=HXzuiMJ36ZCZAWHYj2sp9+WXJHPzDv250qRANNhGqJQ=;
        b=LG3tXiTWttyNr4Km+3/+KPgBAtUZcED6rpACLwvqwj+ezZ2atSiXIH0t3KSvVFCOHr
         Hn0zsogmKVNgloS9SegLaAyQOkutzdM7+tFn4fAnh9AXgIrhLgWO1eIcSInVc+QCJsMJ
         ncjJ35w7f6DYymop7Bh4Tr/F79G+cCIFio7EKgg0vPBKpJtxugbzTJL4re963UAeSvOD
         IUThv/6pgEOT8B72e4V+YYr4M65P4EYFgnQiF2X0cNlzjW0rKh3mnC1nAAsbEFGnj449
         oIE4/yEMihONgEN6zHwyRMzCeh+6OwYSmZgT8oPRQfJ+5mfCesOZ00Rw3IB9Y32v0ZD+
         D6QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791807130; x=1792411930;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HXzuiMJ36ZCZAWHYj2sp9+WXJHPzDv250qRANNhGqJQ=;
        b=I95+7X/K+m/yPKR3QdgeerO4hrihLuRR0jAnusT+ENfRmdt9e3X0NG5RCAwT+QIzdS
         yePR1o6y4zzMtoqdzc4diN/ntZwrMMVY9NKQ1gyFbsLjRuCUQwV9MvPBX3GSW97M09aB
         NqaajzQqFJzkBDuS++nlyoYKqO0wgP2vkqtBGrlGra1rU/HaOgsLMfbEwm7+zFRqJ3nb
         CPjSHDhfHLp5Tm7qYBlXZLr7LjzeQIfri8aWD0oN5TLG9jyxQaREQtUFv4sJStEZO4Ie
         QUQ+dU0dadJlIZ8OI9/dt1I4DVz4f3bHlwb92HvvCRihfkaN7GHIPMUo37wFiKiGyYMr
         dgVA==
X-Gm-Message-State: AFq9FYLZzQMsWbvpuCUGLzl24aVTGl+8SLTOYjkcMVwd/enlIqpS+Tg7
	iJci085ou3zP6ByNbQZ/3l8JIXaPrqBFkqegYav5OsW89lube/V91YZw
X-Gm-Gg: AYBFou2ijl+eVBhaQOLhATF0bLCicoSUM2gRcDFYPF3gjFEUQK+wywvc4ubxVb7Do2v
	w0suH0wP49Z8fOhknvbt4nkHSkYHIUWnTQsxKdflpYHb0IqY7JOVx8Cc9ow5RRM32zKatFRKXAB
	PO3gKgyUTRJeQyIWHuWc2EjsKjMoECmkELkyLFIVpjii+4t3NW3G5snnsLXmtDqDEZjSGIPoN/7
	9ADt/lQnkhXZArM3//r6aPbdyhwn1Cqlj850aE/itCtrCMsxkX+uZmqvHADcwLEhp+4tBufq+yK
	Sa3HtGC8UFe5arcjscS+ZrtMOjB4q7WCGDxWtgCWjUeUDuZuLuXvgnk2mhPDpgU1tXgb5q9Yg+f
	JK/xWydw2h9qzbbv1usJ785uQGKkxAlKu9uyDU3QBmSDs5n9bPTisamtwWeH692DI3cC7rY/1Qa
	MlJwpWyP6owqQsxrn6Op0bPgTRtJZuz+XuLFz5DEVxIk32BphPODviJuuxiNU=
X-Received: by 2002:a5d:5e88:0:b0:48d:bafc:a3f6 with SMTP id ffacd0b85a97d-48dbafca4a1mr17578909f8f.0.1791807130183;
        Mon, 12 Oct 2026 05:12:10 -0700 (PDT)
Received: from gmail.com ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48db9ac02cfsm18206754f8f.39.2026.10.12.05.12.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 05:12:09 -0700 (PDT)
Date: Mon, 12 Oct 2026 14:12:07 +0200
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
To: Zenghui Yu <zenghui.yu@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	akpm@linux-foundation.org, rppt@kernel.org, peterx@redhat.com, david@kernel.org, 
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, surenb@google.com, 
	mhocko@suse.com
Subject: Re: [PATCH] selftests/mm: fix uffd move-pmd test crash on 64K base
 page systems
Message-ID: <aszHXQY7_lHOXKPp@gmail.com>
References: <20261011163527.95988-1-zenghui.yu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261011163527.95988-1-zenghui.yu@linux.dev>
X-Rspamd-Queue-Id: E214920002
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: un7ifsupc3ws73687nywt89n1f5ibi4m
X-HE-Tag: 1791807131-752543
X-HE-Meta: U2FsdGVkX18EZ14W3YBH/p7my/GtIiW7CVQdoT82a9zoCP8iY1MjyvYm4o20J8m8HQ0yzPBQ7o7ms3z9m+zGy7Yg4ue/ebabMGgJY8k7m+/Ub+BAwBEdNNrl1nM1EZqPR+pib/MlN7L89bSwJ/7ik4p3C2CSrkJ35pSI1kNw9G34p043g19y+Pq3BMLoPmkfpOM+ioGd0U5woRKq/0bqb55iE0P4ZG/TaXFlNE706rVKKym2PIw2GTba6QrHjBEU2cSDb/GNakeKwRhVuFZpWwbNw9T85fFfbAByZtefcHuxcCOcpvHvdTh/AQu0ud4CGHwQxY/WKharOjnicgwc/QGGJRvvjex92oAABUGFejpXUoW4um/BT+TeBiqJUp/cPxWQ8xpM1wo7JPy9h82LNBpIYrETebuot/J9A+fFl+xmYSiMz95q0bpwFwOUZSxYID3L/KmuYphlZPrYPHChj1K6h2VXDw/3hA0BSzxM+cHrI6XuCCD0We0Q+3oKiD7aWjh3Bsa/61etAEOcX0zB8gAJHSbq4kVpnGX037QCZ2QeVXBCcQYbhWZJpcMazfZUkJKf81o8CGqhUhBOGFcVVgKwPG2FTxU+ItZUQAj/rIimBTE5fqjhyLEFCQwHF1VR+OuHBbsHs9g17Ziha2jhcHnDxPs+C/ky7LZRBY/IUu8HKqwszmWjJZGFopFL/6bfmfjo1CwDs5KpVzGNdUOnc7/0mfF+8eoHPpRhHgZkg/5XWg/jBIVJKs18Pg2HiEf4VVw1Zh18hktSV/thlX+O+YsVHJm5DBb6IwI3U1A8uGaPBQH3xqhCLanX2uuyI3yTe8v6T2lrACeHZTmBgJGyL40TV3ItUyPSIGYvbqoN3ePcgpNJ0SSCf5+yCN5swNVCCJff5l4w4ZmEDQsHIXr8zbLp+75oHzJ/cAmu1g2y/kW1ib/zqK1ypll4Rr0p4YRmxnZrWB+8//1fvJEn+6e
 c+fMUceK
 NLWb26bLwGVN9d/YCQFhDFN/nC/LALTh1e8L+mscE6YtTayHomSHnYVJC7qCkfdUltIUbjTfxUo8q7ZfpDjNBP9Q4znHuUllKwS98c61CFzE+zBZOoFTl1mAUuGcIwl/03Cebg6AGOdJfIfbdaZL1nS/Nmw0awrt/PvOhRdJkSJz+A8nvOhBzgeaZruFpBt5V2l/qnc0nX1munXTg2wCNSOR/Vt98WDxR3nDmQrr7ZNoCNVgkveysVWLhmxF3xdUgD5v3/hNmDsvxzhMquxuzA5VKCRNMMIfknEU8XSodbSME527EQTcHXDXI1nfsqF/FCdcvNCwR4qSabLrOqAdvSgMPboN4sTsH6dHA7FvwJcYUBR0aW8qE7IYBMkIw61JXqk43wYebIFjns2mkyMopF7Ko/kseDNBv1qyC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 12, 2026 at 12:35:27AM +0800, Zenghui Yu wrote:
> From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
> 
> uffd_move_pmd_test()/uffd_move_test_common() splits the test area into
> chunks of chunk_size and moves them one by one.  On arm64 with 64K base
> pages the chunk_size (read_pmd_pagesize()) is 512MB, which is larger than
> the whole 32MB (UFFD_TEST_MEM_SIZE) test area:
> 
>   step_count = nr_pages / (chunk_size / page_size) == 0
> 
> Because chunk_size > page_size, the test then aligns both areas up to
> 512MB, which points far outside of the 32MB mappings, and decrements
> step_count, which underflows to ULONG_MAX.  The verification loop then
> runs away and the first dereference of area_src faults with a SIGSEGV.
> 
> Skip the test when a single chunk cannot fit into the test area.
> 
> Fixes: a2bf6a9ca805 ("selftests/mm: add UFFDIO_MOVE ioctl test")
> Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
> ---
>  tools/testing/selftests/mm/uffd-unit-tests.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/tools/testing/selftests/mm/uffd-unit-tests.c b/tools/testing/selftests/mm/uffd-unit-tests.c
> index ef9b3956bdcf..2a97ba1d6feb 100644
> --- a/tools/testing/selftests/mm/uffd-unit-tests.c
> +++ b/tools/testing/selftests/mm/uffd-unit-tests.c
> @@ -1937,6 +1937,11 @@ uffd_move_test_common(uffd_global_test_opts_t *gopts,
>  
>  	args.gopts = gopts;
>  
> +	if (chunk_size > gopts->nr_pages * gopts->page_size) {
> +		uffd_test_skip("chunk size does not fit in the test area");
> +		return;
> +	}
> +
>  	/* Prevent source pages from being mapped more than once */
>  	if (madvise(gopts->area_src, gopts->nr_pages * gopts->page_size, MADV_DONTFORK))
>  		err("madvise(MADV_DONTFORK) failure");
> -- 
> 2.53.0
> 
> 

LGTM.

Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

-- 
cheers,
jose a. p-a

