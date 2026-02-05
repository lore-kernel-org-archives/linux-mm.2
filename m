Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4BA5EA7945
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 02:59:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA5A96B0005; Wed,  4 Feb 2026 21:59:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B539B6B0088; Wed,  4 Feb 2026 21:59:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A35866B0089; Wed,  4 Feb 2026 21:59:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8EB736B0005
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 21:59:40 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3B8EFB87C7
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 02:59:40 +0000 (UTC)
X-FDA: 84408897720.16.C4FBDC9
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf12.hostedemail.com (Postfix) with ESMTP id 274FD4000C
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 02:59:37 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WcUPuY7p;
	spf=pass (imf12.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770260378;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Xk0CQGxo+dLLTG7hkwaZpo/ZD3J9X7WGXohQku4MYc=;
	b=eEbPHiLoTHH5MM9QpvWyTIeMIkRx2jxnscPs/phUKnulVdm4rUTFZcIvAVXiG5w9HGNwsn
	63UY8vz4RDqrEJYA+4hIByUVcQZcxejLoYYXf+QiymeTtp7KZMAE1lwBtTnI44nfdabadM
	7Y71vnu4EiDHzrcRfBJml8WKEi0FB8Q=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WcUPuY7p;
	spf=pass (imf12.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770260378; a=rsa-sha256;
	cv=none;
	b=qpeeOB0TMX3LVXQwdyETMfgDZ6Iefbb+u89JeoJGPA83h7kJDwRw79ymMVAumHZ2O3ba7k
	jeVUGWPRp2gHCubk4cntspCFBE7DA0+TRn69eshyFXzp/sNgyLDB4GoaSHSaVQ1rRT6S4K
	2oXU+RSHY9OZXqDhB9Fe/N6fdCVqXDE=
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-659428faa2bso826268a12.0
        for <linux-mm@kvack.org>; Wed, 04 Feb 2026 18:59:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770260376; x=1770865176; darn=kvack.org;
        h=user-agent:in-reply-to:content-transfer-encoding
         :content-disposition:mime-version:references:reply-to:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7Xk0CQGxo+dLLTG7hkwaZpo/ZD3J9X7WGXohQku4MYc=;
        b=WcUPuY7pv4hjFNmTfOWbdSJSJ3d8OWUiqH69BfccbPGcbaoYlpze3e0KMYp1qmvyvX
         V+qvkXe/gp3K5QWjueQr4ByGaJCgJV6H0Xvv13uE9/C2rCY+J/paMD+14PBTd9IkgYuL
         F5xzBywb/im4MHopCwARCYzm1EkTTsk4Kcz2j5aIHObKEOKYGHanol4tB/hwkvup9ZpC
         WWbVAx9Cul+A0zLTxvOS6o27J1Lb4eXTCpENF2V8jIeT6+SkYw2S177X1L7bv1zAL8mL
         gLHymhBxu/FZFrYuOmQZIOILkauJXUuKW2FE75e0soFA/LWtdYnThlDvvgOeBwEtrasS
         3KQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770260376; x=1770865176;
        h=user-agent:in-reply-to:content-transfer-encoding
         :content-disposition:mime-version:references:reply-to:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7Xk0CQGxo+dLLTG7hkwaZpo/ZD3J9X7WGXohQku4MYc=;
        b=tEOQ6WxRGbPud2IlTtVHMLlTHjReNC4Bzw+G/+UNPcIs4wyYzyymZkf72JulFhveBW
         vS8OZQCVh2CluCqOA5eh4rkhcIktRpsshYhQXOZXyQgvJIMsPaheo0fuOaCgRjsrESHJ
         S68WZEQ6Q6j21yfcnloxh/A+ET06V8GlC1cDnME5/V0ptPSPbXQWcfvXaufWP9dy8PCJ
         aQpFXPcnyBu3XT9gZ72UQMUJ4bmTVvFNeRIQKyGaFFfBdhSQzjoKfPcaZ10WCpEVLdzF
         L0ncFH8BBe9Y55TLe9CNH2xbL4dlL5ZG+3JMD9nHOdiJ+Y1+dbi48hn1Ivyqh3bx2HFV
         qYAA==
X-Forwarded-Encrypted: i=1; AJvYcCUwFbG9VQbqsm101MLWB55RHJ0E4P04Q99vbgfQk3FtXcSGls+IRcnGrmnkg6aXsTe5G7+jcmZXdQ==@kvack.org
X-Gm-Message-State: AOJu0Ywts+yuBvmByM+0MqhJZgU7orPofq1Jk2lKVcZA2Ip1W1C8+Tah
	zgtSEq7Sze5bSsNUoa6tXmHl+QfP+LB19tMMxIJyQSFTYZxZpvmOK+bL
X-Gm-Gg: AZuq6aKTd33FR2F8Y9pFNmB4ACbZmMuV/JJ/1w83Zfy0rIzOZEjhAbadPH/e1iqNN4G
	GIj8zYwRysq3P8V4ul6tPLseN220UAjKZ6XsTug+FpUqO8mNOvuylqK7QMSV5toZThHsf4rXDb9
	uxRQoxAf7M+roLEIb2PSwbkQS3n42VQ0tKH3YFbL3m58yN6h0eeN48lji2ccaYYrBux4gNGLYOW
	jZk29v6osyl8WBtSEWK2XKsAfvccTq4NjF13P2mYP3u5cuwxacl/YeocbxWwAD6YbNuN1nXGo4b
	eHv5QyMbG1FW6iRszPyo+BSzsPvan5+837kWYH/CNWJkPMi7sJ/nfXmvUNbxaqt5Y4aIKo7TE5+
	YxweYWNPnvdwl57HGyMTmPchL5HrFI6lC2CBk/1Ki8Lue35J5nsQMfHxWsU9fxr/wI1qFLfkT/n
	rb32giQhd1IQ==
X-Received: by 2002:a05:6402:1445:b0:64d:2889:cf42 with SMTP id 4fb4d7f45d1cf-65949bb6e2emr2943802a12.2.1770260376191;
        Wed, 04 Feb 2026 18:59:36 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6594a216abasm1700370a12.19.2026.02.04.18.59.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 04 Feb 2026 18:59:34 -0800 (PST)
Date: Thu, 5 Feb 2026 02:59:33 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: "David Hildenbrand (arm)" <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>, Wei Yang <richard.weiyang@gmail.com>,
	akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
	riel@surriel.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	harry.yoo@oracle.com, jannh@google.com, gavinguo@igalia.com,
	baolin.wang@linux.alibaba.com, linux-mm@kvack.org,
	Lance Yang <lance.yang@linux.dev>, stable@vger.kernel.org
Subject: Re: [Patch v2] mm/huge_memory: fix early failure try_to_migrate()
 when split huge pmd for shared thp
Message-ID: <20260205025933.6fzalv6demj7tpfs@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260204004219.6524-1-richard.weiyang@gmail.com>
 <d3f4456d-f2e1-4d8f-aa92-77ccd1606d59@kernel.org>
 <E4DA2E02-DE3B-4D26-A427-5D53FCA36A58@nvidia.com>
 <df86ccfd-68a5-416e-81cc-02858e395b70@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <df86ccfd-68a5-416e-81cc-02858e395b70@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: chpkxwiz6gaot8ztuihz69pusoqsxxep
X-Rspamd-Queue-Id: 274FD4000C
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770260377-494603
X-HE-Meta: U2FsdGVkX18UI+ETd0zvNjusZzAuus/sZqsa6Y5Fp248pPiurRBSMTDHDYv5aBBEpmic/0AFJEI4m4gbN26+yWIxmDlADaqgFkqLcYo53p4y1mwWqSWpHQY89QKpxJLoGG9lxTQO1lt0XlF1mRVXZ7Y+XRin8mJeDt+dbpPc9yr36pstvGd72QrFYMJ5JYrafYblCWnf/gQIOB9gpSwG30TNOyuIFhmKGr9OnuAQcFcVBHZfnwKzNYavd+pBQXrN3Qzu9565pyzMFtxuQXE7Blid4RyuwTT76jWZuJjiJxew6cDFZ+rPBKjMu+go6U159o2OYQC71lHA1QhkbBWBeDWvp+zPNaqcja9zYf/1FamTBWcvL9PfH9FD0E7UUCAXZFnSXsTsQZ6rQNc6zHtbrtInwrbfnkioRZKCE763SQeEPjTXU/j+7jcPr7edCQ+ouh56uDR/7PyvGwc9Q0HcNyGzMYweE5jVINHIHiM5mV0HU6g24UE5XO5QPSCusQp07rBwkvIh1C8jIoheaixHcnkCpxfHgdk0ihF73kNjcn7GLMXIdHLnodSZoOnsr1HPaKdwtLTcJUU489HgvC7dJZbJIr+PdAtVwJ84E9u7CAShtGcmKfmT8BZEDrlEyk2sKXr18M5GQ19sJ0hMwUl8ZjkvW9eaUgFq2tv+tI3aeXaxINW1aqertCJnw2Nxgwotrd9V86RKlreqyxrRjnaGnoNQz4oT2FvhSZ3jJS+V8qaLvRLjpbIQEsqnbu8AykIXH2f1aSFJJk2bxKmi8M1HB2CTguGkVbdDBe0cwBdFuMU1bsuWWzAk/UuhlIqr6ws8ohyTG73tkM5btVr/lE9x8OyTGniFwVC/QMge0jWgsSzfzDms/eUDrp+6QRH+AA3wFG7HhnkoFC+uQ8cKC23mq/Nb4zkZtBNhTDqmW4tXQUQQAtyFrjmmlvIKTShq6nYGBf6TaLiFo0jX3xuky2C
 7GA3NwBi
 adHELuo+2VCIh9jq0Hx2ZpUMhYWVo3b5lKfBtrNqwBecuXb3wjSRhVMzNKZaa9f1+QanjH9+yjS3sngtqCYZjh8dr0S5BQmQpVplc4XJBGVDDxpyr85Jx1sfb7bSeVGwZuVyPtsNVd0KBzGGLtRm9tFEgwc6Osqk3z5jEkjH3yeq5z23UfjIpCjteTg8Eg85qdCsdus5CaWp+TyuNie5V9GXjAt/bMJqjmmsGEfN8zOYglMjgr3HI6J90NwlaBA6kEj3T8WfOEvi6xq0LsUe15SV7gtL4AcbwUgpwxwKxtJ2Sr15/HZKxXDfwGq6+Ef2vobXnjLLYnT1Hzo0HJMyiI5WJgo/sQU/rTUhOQmqMdD5r8OIMnC+t9voX8QsVvESavqPVJIBuHXlTivBrMSIExpOlZFZZofpxtjfrE6/49RwSR0/VavVwnZ1vtfndhcP5+D7hY/zXqc0E2ewmNIftBnK4HyCVkqtbNewaUWGVQ4VJTMfyUY78hYDR4ghCRqLFMzBZrF5rjA/eCrAtau5ZFRGKQcBwdb3xL0H6AGzER/sgRONx1tU9ad4po7DbSBqvFSL4nJh4vn0VqzxMFONfgnrXL73vTzxNEW83WV7YtcBQyzH5Fc2U+0KRHvWIOjOas/he1OAwo92lnotRw4oJ25Kgvu1Os79zjlqXrWuxo6C9Xbxcza7XLsM2AlcDHLaoV411WQ3Dugt5y4532jRRxNE0/m1OKZR+CzQWcWWh80Omw2Qw6aOzlyXQ82Bz4SV530jVs0x5+YxJ0LT0JiuCW+YCDSG0cfGsASVaIYy2SrA7SGkULZQp9wwd3m/CT1ygj3PTPluyKIgbtjaqQZlGDxKXZkskVguz5DzdYVSYqFXVvFw1InvgOfvDK4tzqtvVha1CFRfKmC40A4vjoeyoa4qmqzBYyrp5CBuk68xDSkzOUe+KTGrOqHGZxfZOJeTfxeEjHB9fn4tKD3+wnZxocYj74LKm
 zTBHc2fs
 CdyfWbt16Xy8KmG8N6cs4N5FjVR2v1uebkxHtXA1vtA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 04, 2026 at 09:43:42PM +0100, David Hildenbrand (arm) wrote:
>On 2/4/26 21:02, Zi Yan wrote:
>> On 4 Feb 2026, at 14:36, David Hildenbrand (arm) wrote:
>> 
>> > Sorry for the late reply. I saw that I was CCed in v1 but I am only now catching up with mails ... slowly but steadily.
>> > 
>> > > Without the above commit, we can successfully split to order 0.
>> > > With the above commit, the folio is still a large folio.
>> > > 
>> > > The reason is the above commit return false after split pmd
>> > > unconditionally in the first process and break try_to_migrate().
>> > > 
>> > > The tricky thing in above reproduce method is current debugfs interface
>> > > leverage function split_huge_pages_pid(), which will iterate the whole
>> > > pmd range and do folio split on each base page address. This means it
>> > > will try 512 times, and each time split one pmd from pmd mapped to pte
>> > > mapped thp. If there are less than 512 shared mapped process,
>> > > the folio is still split successfully at last. But in real world, we
>> > > usually try it for once.
>> > 
>> > Ah, that explains magic number 513.
>> > 
>> > > 
>> > > This patch fixes this by restart page_vma_mapped_walk() after
>> > > split_huge_pmd_locked(). Because split_huge_pmd_locked() may fall back to
>> > > (freeze = false) if folio_try_share_anon_rmap_pmd() fails and the PMD is
>> > > just split instead of split to migration entry.
>> > 
>> > Right, but folio_try_share_anon_rmap_pmd() should never fail on the folios that have already been shared? (above you write that it is shared with 512 children)
>> > 
>> > The only case where  folio_try_share_anon_rmap_pmd() could fail would be if the folio would not be shared, and there would only be a single PMD then, so there is nothing you can do -> abort.
>> > 
>> > Returning "false" from try_to_migrate_one() is the real issue, as it makes rmap_walk_anon() to just stop -> abort the walk.
>> > 
>> > 
>> > So I suspect v1 was actually sufficient, or what am I missing where the restart would actually be required?
>> 
>> The explanation is not for the shared case mentioned above. It is for unshared
>> folio. If an unshared folio’s PAE cannot be cleared, try_to_migrate_one() return
>> true, indicating a success.

Thanks Zi Yan for the explanation.

>
>Oh. You mean that should be something like
>
>"This patch fixes this by restart page_vma_mapped_walk() after
>split_huge_pmd_locked(). We cannot simply return "true" to fix the problem,
>as that would affect another case:
>split_huge_pmd_locked()->folio_try_share_anon_rmap_pmd() can failed and leave
>the folio mapped through PTEs; we would return "true" from
>try_to_migrate_one() in that case as well. While that is mostly harmless, we
>could end up walking the rmap, wasting some cycles.".
>

Change log is updated accordingly.

>
>> Yeah, since it is an unshared folio, the return
>> value of try_to_migrate_one() does not matter. This fix makes try_to_migrate_one()
>> return false.
>
>Right, it's not really problematic. We could end up walking the rmap and burn
>some cycles.
>
>> 
>> > 
>> > 
>> > (maybe we should get rid of the usage of booleans here at some point, an enum like abort/continue would have been much clearer)
>> > 
>> > > Restart
>> > > page_vma_mapped_walk() and let try_to_migrate_one() try on each PTE
>> > > again and fail try_to_migrate() early if it fails.
>> > > 
>> > > Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> > > Fixes: 60fbb14396d5 ("mm/huge_memory: adjust try_to_migrate_one() and split_huge_pmd_locked()")
>> > > Cc: Gavin Guo <gavinguo@igalia.com>
>> > > Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
>> > > Cc: Zi Yan <ziy@nvidia.com>
>> > > Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>> > > Cc: Lance Yang <lance.yang@linux.dev>
>> > > Cc: <stable@vger.kernel.org>
>> > > 
>> > > ---
>> > > v2:
>> > >     * restart page_vma_mapped_walk() after split_huge_pmd_locked()
>> > > ---
>> > >    mm/rmap.c | 11 ++++++++---
>> > >    1 file changed, 8 insertions(+), 3 deletions(-)
>> > > 
>> > > diff --git a/mm/rmap.c b/mm/rmap.c
>> > > index 618df3385c8b..5b853ec8901d 100644
>> > > --- a/mm/rmap.c
>> > > +++ b/mm/rmap.c
>> > > @@ -2446,11 +2446,16 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
>> > >    			__maybe_unused pmd_t pmdval;
>> > >     			if (flags & TTU_SPLIT_HUGE_PMD) {
>> > > +				/*
>> > > +				 * After split_huge_pmd_locked(), restart the
>> > > +				 * walk to detect PageAnonExclusive handling
>> > > +				 * failure in __split_huge_pmd_locked().
>> > > +				 */
>> > >    				split_huge_pmd_locked(vma, pvmw.address,
>> > >    						      pvmw.pmd, true);
>> > > -				ret = false;
>> > > -				page_vma_mapped_walk_done(&pvmw);
>> > > -				break;
>> > > +				flags &= ~TTU_SPLIT_HUGE_PMD;
>> > > +				page_vma_mapped_walk_restart(&pvmw);
>> > > +				continue;
>> > >    			}
>> > 
>> > The change looks more consistent to what we have in try_to_unmap().
>> > 
>> > But the explanation above is not quite right I think. And consequently the comment above as well.
>> > 
>> > PAE being set implies "single PMD" -> unshared.
>> 
>> The commit message might be improved with some additional context. The comment
>> above pairs with the comment in __split_huge_pmd_locked()
>> “In case we cannot clear PageAnonExclusive(), split the PMD
>> only and let try_to_migrate_one() fail later”. What is problem with it?
>
>With your explanation it's much clearer, thanks.
>
>I'd remove some details from the comments about PAE like:
>
>"split_huge_pmd_locked() might leave the folio mapped through PTEs. Retry the
>walk so we can detect this scenario and properly abort the walk."
>

Comment is updated accordingly.

>
>With some clarifications along those lines
>
>Acked-by: David Hildenbrand (arm) <david@kernel.org>
>
>-- 
>Cheers,
>
>David

-- 
Wei Yang
Help you, Help me

