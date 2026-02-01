Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC1D1E7C6F9
	for <linux-mm@archiver.kernel.org>; Sun,  1 Feb 2026 02:09:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC52E6B0088; Sat, 31 Jan 2026 21:09:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D72966B0089; Sat, 31 Jan 2026 21:09:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7E706B008A; Sat, 31 Jan 2026 21:09:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BAB136B0088
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 21:09:56 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5CEF51B1E1D
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 02:09:56 +0000 (UTC)
X-FDA: 84394257192.20.DE81BA3
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf04.hostedemail.com (Postfix) with ESMTP id 64E4B40007
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 02:09:54 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=C9Cqjiro;
	spf=pass (imf04.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769911794;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WH9+VhZi02lAA39xreUK3oU8BE/RF3ammaD/BPdU02Y=;
	b=SEkQeK0JFqIc0RL27iflNdrcOuhph9vMcVFv5aJuMz6KOLuJvCWsFNDQ2xLSwnVLi8fBBa
	umlK16ExwHt8RT38cyM9v2KgImo8FBkvxpI9yEpdKwpcYFfMom6Sox9mSpiDPeP+3zTuPb
	reI3I8iOtUsxCXjKmocUfiQOhFJhwBs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=C9Cqjiro;
	spf=pass (imf04.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769911794; a=rsa-sha256;
	cv=none;
	b=MrcsAeGMrgJ6lor2Vho1e83onzvgC0PpXzbgGT1q/chanMiA2+CfHvN9wgHQj1JtBtdRfK
	11aRpi6IVQsAdmflfLo/BoJ9JaRJvnKcPD4NH2UcU5vnbaF61RRztsx6+nlX8osXYZZonT
	Zz6QKNAtbW8pSHSuh29HLkGLA/6VHhQ=
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b8837152db5so528140666b.0
        for <linux-mm@kvack.org>; Sat, 31 Jan 2026 18:09:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769911793; x=1770516593; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WH9+VhZi02lAA39xreUK3oU8BE/RF3ammaD/BPdU02Y=;
        b=C9CqjiropA1DfqYMH6B6iIxETjwlkVQhZ89C5c9Lx0mkNcclJbQQF/5LGh/d5goznK
         HbJI38h/ukm/yaJehaJYv4do0p5QLfdp4w7Naa0EXR8NAT6+BUlBwoMGKwpOYrDv0gb2
         onJ5Xxbwoj2G7AqytFFuV9l75w2WCEHed1MW+xFkbGCmF1Gz2urhy0WlwqHEyZsjQz2u
         y+OnHLAChtg+H2yChJRzP8wC2oxVQDjpzSi8pNDezeVcdbCeBrw2nVvcOuqI+u269MOQ
         IVNOBjOV4Nzyvd1dVTidIFTaockz0FnTWkwCAK5qeAjx1dinracWqFtNK/Jtb/joafD1
         b/aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769911793; x=1770516593;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WH9+VhZi02lAA39xreUK3oU8BE/RF3ammaD/BPdU02Y=;
        b=Md3SdI9gmszvpqIBK68XtW2OJvFE8/uHJJEiCS6zae0iXSjG1xc5+cKHcdNqBk+jqH
         Jmk2jalDEl8aFR4jcGSUtRH/C5k4O3YPxVUl+g25lNAo9hoMBetAaE+1E9/xKkEvPgNU
         pG2Q8ZHaPF7LXqoBNVELdDpWiIfUidcv0bpRLcE6t81WXrAVuvw1OQMAdSlBqGFWqjl/
         sd35oYYNQdXGCs7veFZiBLIzzCbnzGbbkUhumoA7nWyEKAanikHyPdEt0+/KrUn5ZdG2
         PFhICr3wPVXFpKANCF1meSVVDB7zsvvXZr/aKLCyKLlRInOzA4ZPkRUj4MBkSUUkF7Av
         JbYA==
X-Forwarded-Encrypted: i=1; AJvYcCXJ3Ap2vD5nz2PvUVzUio9kC4cB47tEoFDcTiX0fXHo3eCVD3RkVK4OIl1qtZVXDJuDIj0ozH6EPw==@kvack.org
X-Gm-Message-State: AOJu0YzRmwpHxF8KS+i3sNQf+jtdAl7efOvZiDs3K44NK1AQk1/OFJsU
	3opuA4rd1GiOlHzbLSELCalpC9WH7sYd+jhYTze8TNdnN4Wsn79AYEqG
X-Gm-Gg: AZuq6aJ9zxuW+SjcVgwkMK1JFO5TRK0MqqrAYdE6kiSCJgFOazwAFtvczXQv480ZwOE
	OHMtuFgfviWkQU6kt6/Xc9EEq27sG+TS6p2VnE11Zwtti2kPRXuNthVuIvfqdeRzt+9QvY5gVg8
	XhuOTwV1CLoz1JN1F0PZKyPAxN+nxAjuiDTLzBfINcU+RxSVBTng0dAS2UszGi9Z9zmkroFEL6a
	MlZ21zKBmUxd+FI/l4pfiq55wNuuJAvYzAstChkSZTcIwtcCtboe+PCdcoJWO9FHUtwqKjLEwCt
	fv++SHT57lIXgP8MOrWn+zVUHbkDwc42nCzqDXIrg12pBdIbm/LHNW95TaeLNOTkcNDuBLnd7re
	oBRAO4M7alab1ADjlsuvTh03nGTecmsCb40vfK6R68jks+Vy6fZZo5FELoHWwZ4Wh9jQh2zipey
	g9v2ZXUPRwhw==
X-Received: by 2002:a17:907:968c:b0:b7a:1be1:983 with SMTP id a640c23a62f3a-b8dff8071femr411615266b.63.1769911792464;
        Sat, 31 Jan 2026 18:09:52 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8df8465cb5sm388178666b.40.2026.01.31.18.09.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 31 Jan 2026 18:09:51 -0800 (PST)
Date: Sun, 1 Feb 2026 02:09:50 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Zi Yan <ziy@nvidia.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	david@kernel.org, lorenzo.stoakes@oracle.com, riel@surriel.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, harry.yoo@oracle.com,
	jannh@google.com, gavinguo@igalia.com,
	baolin.wang@linux.alibaba.com, linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/huge_memory: fix early failure try_to_migrate() when
 split huge pmd for shared thp
Message-ID: <20260201020950.p6aygkkiy4hxbi5r@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260130230058.11471-1-richard.weiyang@gmail.com>
 <178ADAB8-50AB-452F-B25F-6E145DEAA44C@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178ADAB8-50AB-452F-B25F-6E145DEAA44C@nvidia.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 64E4B40007
X-Stat-Signature: ftjzouhgyh9tkxtrbk7w4y55e33ednkm
X-Rspam-User: 
X-HE-Tag: 1769911794-661325
X-HE-Meta: U2FsdGVkX1+GrdRjhSEI6Je2HkJenxzz96k8sOSW77KEAI332wbUtZEAjzzSheanSOwvIc0DEOEJcxQPYO9VV9CMcRGUNn3G/zBqUVM8FPC+jrKccat7IB64TIalAvLrX13ouN4spC9CJznXEx6iBrCSpzBlcwScLinCMlEDUUzYJzsvtvRPsWmoCll33DRpFh3WxTHtIV4eClVTfp2nnC/Qu3DDhvM2Z/QnChqD0qwLRgQqOjLexBls95aFI6ljRi1AVZI+Cro70wPiuDaFetap/pO+C0Aap5ORu/eDM94e7koAwN38vUa9YjxfxSd1E0yfs2zUlYAZ3ku5GuqofFZviHLEMr8yAtDu4mkP+zkrZyImo+DpoJO1y2GaG9SNuUq+ilfppN6CQ5nPya01SqZBCP5Wkqt+aeDdFGieCWC00qcHKO0GG48Ke8uNOn7lbdDFj2Ik8DnrtxJhXqe7FLHOuyP//xEptXBstJJRqH+gzKcmVFc08r8S9Rv9j46Nc51WA8gDZnCcwxbzF/glAnudRBSq+U3xGN2cmP4KQ6tBHYNyVqKY/A0SOVS2SU59kPf9rgZTNUqnr7C4bYOc/YvrJxujQU7l9Me4az00wvTRbQVS3BymxvmbqWteGN+dQQVVIHqtbmP6fB/gvb0NtlA3xmM1BeYq45NaGyD0KBsssgfWirADVMdsooVLnUuu7P8Jc+h7O/FFvqGERlj6vCJSs4Hc9z33daoattCfs2tZGCfUxyROSvxQk13Q3wLApbw6yGYFcViMGxXXNUdfw6tKfTigxGaGgL+L48AX8QJMKCB4+IhaLubTkt6euNfWk85YNHr+76h50rHVm1sMbXr4KVzb1pIEE4jmkEZqHt3Z9qfRWajeLwdD5sfz0RWIj3lYVUzcdkcmNmO8tn5M1uhad883EkMYe9jM83f4o7h+xqdBVrDHdI5xXx9DooLZwVowC0Kbz8jP833rx1W
 g3j6HBi6
 Q4vwSArY6xTHKziW5CAntDaLZ/UzuM/FlUW84VSXZZ7pIsJp7lI7PKRImqJxnFCpvJTJxlvDQH9zTGuLUhPEHqULhcGNduMP5VaW0KifHkBtKjrDLX+4WM/bao3XmUH528VSy6+N1O42pljgCq3N+by55PupTqqwCmykiT6ajs8m79P+K2sWivxYmlNYp2+kikCMzSpFIEqoQykdDPhNxxdnHyVa+GPt+tJaNIhO2Ht50XEP81H84XJuCmgqTQWSgz0DgBCRJbLiib+K0YQ7DXan+VmVW5YKOSGhKKK322LZZWgBbc1LfAtWhqeSSPclaKWU0H7t98k4Gxc4Y4gS60lM7EpdUmBp13j+y7/ZcXNRY9uQCR5PLknJaC399b15UAehGLac2eqdl/m3sHN0uk93eUz3G+O5OIKmDkPStOmv/6xoGi/HK6r/TBIXH90bCCKt7fXpyu+e/jkAUH/dOPVEznnzvo6FazcNVrFF1sHnj6tYTLkwzVx0nYlnp1O+8QBiK2ipc6DJ7bTQfMa76OW1u34Bg8lVpnFIyP63mfh+TWBwWNIMqvHlBMb4f/fqGFglpJXMpGJqQMEmiF0NQBW03Rt+a5LwSLJ3Px7DhJxzKPmRxh0RZhgWikUA8GZQOJn5F9/HpnOMSiefT8SDytckj1W8YnMv/GjyCyzZBin2f1XaFPeKYaP5E4eYEcbTkMG7RYSEWCnjEhAZq9GaWqLsfwX1f0tlz9j1JXz4t01Dfd0vjRXgCLYbpPawiiMQQIXg39lF5l6kBga/XOolm8LLePualTWZmG0EIOrX8azxWu3lsRTYGCq3JwJkEG4WPOBjV7iiwjFS2AwQhu46Pam8tlZrgrttflMtvo93XYqcM8Bp6/FkLQvG7DIImsHG7hZpZaz6xyZz6Tk0KohXfbFQiU5rAU+9etrdbzg7etYkHSNHXMERwuaBBZc3Q9g1WwHUwObxK1h+DEuKCrToi7xeuZxyb
 5Qs7keDj
 3QLt6nL/GRkVFTB25jhjBw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 30, 2026 at 09:44:10PM -0500, Zi Yan wrote:
>On 30 Jan 2026, at 18:00, Wei Yang wrote:
>
>> Commit 60fbb14396d5 ("mm/huge_memory: adjust try_to_migrate_one() and
>> split_huge_pmd_locked()") return false unconditionally after
>> split_huge_pmd_locked() which may fail early during try_to_migrate() for
>> shared thp. This will lead to unexpected folio split failure.
>>
>> One way to reproduce:
>>
>>     Create an anonymous thp range and fork 512 children, so we have a
>>     thp shared mapped in 513 processes. Then trigger folio split with
>>     /sys/kernel/debug/split_huge_pages debugfs to split the thp folio to
>>     order 0.
>>
>> Without the above commit, we can successfully split to order 0.
>> With the above commit, the folio is still a large folio.
>>
>> The reason is the above commit return false after split pmd
>> unconditionally in the first process and break try_to_migrate().
>
>The reasoning looks good to me.
>
>>
>> The tricky thing in above reproduce method is current debugfs interface
>> leverage function split_huge_pages_pid(), which will iterate the whole
>> pmd range and do folio split on each base page address. This means it
>> will try 512 times, and each time split one pmd from pmd mapped to pte
>> mapped thp. If there are less than 512 shared mapped process,
>> the folio is still split successfully at last. But in real world, we
>> usually try it for once.
>>
>> This patch fixes this by removing the unconditional false return after
>> split_huge_pmd_locked(). Later, we may introduce a true fail early if
>> split_huge_pmd_locked() does fail.
>>
>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> Fixes: 60fbb14396d5 ("mm/huge_memory: adjust try_to_migrate_one() and split_huge_pmd_locked()")
>> Cc: Gavin Guo <gavinguo@igalia.com>
>> Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
>> Cc: Zi Yan <ziy@nvidia.com>
>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>> Cc: <stable@vger.kernel.org>
>> ---
>>  mm/rmap.c | 1 -
>>  1 file changed, 1 deletion(-)
>>
>> diff --git a/mm/rmap.c b/mm/rmap.c
>> index 618df3385c8b..eed971568d65 100644
>> --- a/mm/rmap.c
>> +++ b/mm/rmap.c
>> @@ -2448,7 +2448,6 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
>>  			if (flags & TTU_SPLIT_HUGE_PMD) {
>>  				split_huge_pmd_locked(vma, pvmw.address,
>>  						      pvmw.pmd, true);
>> -				ret = false;
>>  				page_vma_mapped_walk_done(&pvmw);
>>  				break;
>>  			}
>
>How about the patch below? It matches the pattern of set_pmd_migration_entry() below.
>Basically, continue if the operation is successful, break otherwise.
>
>diff --git a/mm/rmap.c b/mm/rmap.c
>index 618df3385c8b..83cc9d98533e 100644
>--- a/mm/rmap.c
>+++ b/mm/rmap.c
>@@ -2448,9 +2448,7 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
> 			if (flags & TTU_SPLIT_HUGE_PMD) {
> 				split_huge_pmd_locked(vma, pvmw.address,
> 						      pvmw.pmd, true);
>-				ret = false;
>-				page_vma_mapped_walk_done(&pvmw);
>-				break;
>+				continue;
> 			}

Per my understanding if @freeze is trur, split_huge_pmd_locked() may "fail" as
the comment says:

		 * Without "freeze", we'll simply split the PMD, propagating the
		 * PageAnonExclusive() flag for each PTE by setting it for
		 * each subpage -- no need to (temporarily) clear.
		 *
		 * With "freeze" we want to replace mapped pages by
		 * migration entries right away. This is only possible if we
		 * managed to clear PageAnonExclusive() -- see
		 * set_pmd_migration_entry().
		 *
		 * In case we cannot clear PageAnonExclusive(), split the PMD
		 * only and let try_to_migrate_one() fail later.

While currently we don't return the status of split_huge_pmd_locked() to
indicate whether it does replaced PMD with migration entries successfully. So
we are not sure this operation succeed.

Another difference from set_pmd_migration_entry() is split_huge_pmd_locked()
would change the page table from PMD mapped to PTE mapped.
page_vma_mapped_walk() can handle it now for (pvmw->pmd && !pvmw->pte), but I
am not sure this is what we expected. For example, in try_to_unmap_one(), we
use page_vma_mapped_walk_restart() after pmd splitted.

So I prefer just remove the "ret = false" for a fix. Not sure this is
reasonable to you.

I am thinking two things after this fix:

  * add one similar test in selftests
  * let split_huge_pmd_locked() return value to indicate freeze is degrade to
    !freeze, and fail early on try_to_migrate() like the thp migration branch

Look forward your opinion on whether it worth to do it.

> #ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
> 			pmdval = pmdp_get(pvmw.pmd);
>
>
>
>--
>Best Regards,
>Yan, Zi

-- 
Wei Yang
Help you, Help me

