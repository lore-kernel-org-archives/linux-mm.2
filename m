Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4A98C61DF0
	for <linux-mm@archiver.kernel.org>; Sun, 22 Feb 2026 00:50:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E80FB6B0088; Sat, 21 Feb 2026 19:50:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5EFB6B0089; Sat, 21 Feb 2026 19:50:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6AF36B008A; Sat, 21 Feb 2026 19:50:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C563B6B0088
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 19:50:24 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5D9541B5C46
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 00:50:24 +0000 (UTC)
X-FDA: 84470261568.14.BB8B759
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf21.hostedemail.com (Postfix) with ESMTP id 55B2E1C0004
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 00:50:22 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SD67AAxR;
	spf=pass (imf21.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771721422;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YOsZ7e+n4Df/rAkGWvwEqzAHF8yQZV7IIGzEvzqRKR4=;
	b=wROOmWXsrBuau8bUztVOKN0cer+yBiwqp59sPrnKGiTLyQvnCJvS0Rr4X6aD9VsoJw4gXA
	xzs3mbRHL832+nWgLYOVpcCvW3d9KyG6senGfvlr3ScRdElZRJyoqxvLeEEXODUX6XJxIb
	5AVnFq6c5T7sNP8AKnkeazdLgJCBW/I=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SD67AAxR;
	spf=pass (imf21.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771721422; a=rsa-sha256;
	cv=none;
	b=cB31wUg0RMmSfxSIwIzz+mlgnoIoyAdN2j5YrU2tWiDlrqDmCLfd/R1utUnrTNz2Ikgw1i
	u6j1WatUitN6kL9ClxncRG+jeIadrPfrPQIvdrEEvdHSfSaSZ0MdEoQHCoK0fjWOA1zadl
	qNKW7n5tUzuU8m+01g9PKc29qyz276w=
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-65a36c8bcabso5272684a12.1
        for <linux-mm@kvack.org>; Sat, 21 Feb 2026 16:50:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771721421; x=1772326221; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YOsZ7e+n4Df/rAkGWvwEqzAHF8yQZV7IIGzEvzqRKR4=;
        b=SD67AAxRqk/rkCZWKkJGo449RlrHE5ss2H3/n8QCsSWKEJ5TfsAuZ59tLuXenBkpUX
         M3iUJv3nevMwLVRawWW76h3SOsyQ0uiZC4IuIR98y12Cn2fjHQ8UM5Zq/TZF/mqWAJiD
         Oio4AC/ur9vdGjtvTYNDaHpbNjJtploUjwRCh1A0d+cv0XGTJ2TZCji9Gx6u7mzLDgyD
         d1UEhEgFBDhksrKOmWycdoppoyyQTKmLMhJTdOFC/nAiRZ8W5z4pzIvNB+oWYEpe2Mco
         eLmIP/X1aSBAtz44qCet7tJbTrvub7x/sq/IWiZA4sAwSXON7HLVF/1trBrboZ6MpQte
         Xalg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771721421; x=1772326221;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YOsZ7e+n4Df/rAkGWvwEqzAHF8yQZV7IIGzEvzqRKR4=;
        b=emN0cIb4mJuHEy4GSvi1rjycZj8sCLFbf7cCJITXqBr4Viakyc3DwwIDc8UUh+GidE
         kdibSvJqWXpC9JLxon23nw+EpifsbQQcG1Hea5Fcg4wbOSTcvrAVuqYzQKKc53uDsWgo
         Rf8GTQrSsTLWrf9AO2TYTylkBUnv64z7eh40MHiys/flbVKfQg5ug4EnkZT9CZ9g9duu
         zaLfYbuT33s1HjiTnROM976fnClc1iAEGuDbxhTPFMODHNrGDvsITixRGhDwA1gj5Gtf
         QCeuwBn/2ukBBMZlsFDa0Wh212ZDm1YXzwNwoaZ3jMZJby2d3NPN0TN62CqxGxXv0o7V
         HYAg==
X-Forwarded-Encrypted: i=1; AJvYcCVtbLCBPYVcPISmvziD893+PeAhJiIEH67XTdHQfRTMbRYdUWXfeN+M+lnwk2nv0OuhoKUFe0OEgg==@kvack.org
X-Gm-Message-State: AOJu0Yxj9jLTwxPvXEk2YcWMVFeXY9P+L4bX+diaR/H4oTjVvw4zQmfV
	69FnsuOV42H/ARrhglxpqtKYIAGjjJQKGUU7CmjtQ9djuDqszJoVUbdb
X-Gm-Gg: AZuq6aL5CYRcLmtDa1pdjAaAFYK/H3pfAOOSd7Hhpt3k6zHR98xnCMTyeXg7PCJB0A7
	m9r3W6x5AQioiBeDmX0/qygkpxll6u3XKTnurnr6L4sgBpCyJdg9qYSfnDgdMKjswM/UBzGt93L
	pgg994AnfeF77ZJRUZIB5r6/iPxWDtqlfSgMN4+qWcEADDB3+AqBT1WtMPFxnMbW0ZzzyA3V7wI
	LISnFHEBMsSaRR+ME/1WNd/ETYYLXw45Yjm0tQB9z0xP2S4C9MlqupC3ybmXwtkOcIvptKAPaHu
	/wKH42OvkJDZ6cMnwaDMxzX0pOelTRDLgoH/B81jeVXdUvFbePFujtGzRCO6wXIke04UZ7YNcbQ
	T0vNevaYPkeRgsu6L8D82z/56eG84y4/nQE4Ne2asqYd8lcAV5ixeHd2xy0OriM/+tx5Vv4WdLH
	FR1kyw7y8UAZBDQmMa5VurNQ==
X-Received: by 2002:a17:907:1b05:b0:b8e:fe3c:2264 with SMTP id a640c23a62f3a-b9081b81c72mr294266366b.41.1771721420552;
        Sat, 21 Feb 2026 16:50:20 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b9084c5de72sm157083866b.12.2026.02.21.16.50.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 21 Feb 2026 16:50:19 -0800 (PST)
Date: Sun, 22 Feb 2026 00:50:18 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, akpm@linux-foundation.org,
	david@kernel.org, riel@surriel.com, Liam.Howlett@oracle.com,
	vbabka@suse.cz, harry.yoo@oracle.com, jannh@google.com,
	gavinguo@igalia.com, baolin.wang@linux.alibaba.com, ziy@nvidia.com,
	linux-mm@kvack.org, Lance Yang <lance.yang@linux.dev>,
	stable@vger.kernel.org
Subject: Re: [Patch v3] mm/huge_memory: fix early failure try_to_migrate()
 when split huge pmd for shared thp
Message-ID: <20260222005018.r4xum26tfxgnnvys@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260205033113.30724-1-richard.weiyang@gmail.com>
 <fbd6c31f-7f35-4986-86e3-76bf8963433d@lucifer.local>
 <20260210032304.j4k5izweewouabqb@master>
 <20260213132027.wm75sh6trz7n24kd@master>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260213132027.wm75sh6trz7n24kd@master>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: ie1wcw9p419sn6bekdqf1uwafbe5ncdr
X-Rspam-User: 
X-Rspamd-Queue-Id: 55B2E1C0004
X-Rspamd-Server: rspam01
X-HE-Tag: 1771721422-520717
X-HE-Meta: U2FsdGVkX18fmdgjizn1Qhc6MNINmoB5qBxzuEtslTa7KzSgOza3ktFlx/5ncgoHp4OxSJccUsgXHB2+OoBfMyxUzeQiYgIrbSd2nH01GWj5+elRE6gjnxU2B93qyCVqmLqemXyto3JBqDTBItv6ugsgs+EnAuv4s/V+Acd7EBWI/ZbDgTSaBU2MMAbBnvdgFJg8IpxKhiWB0p3+RGtlIRjzqcdid+l8hDTx3MbUUN7ly5YYtH68Ztdx19u0JqpGcvcQHEYF2kQ2aP8jFHqR/aPMRHC4qk3zSZdKqhluZzr7ziCo8vb3hDQKPnebgIeruZr2AlQLO9s8xJKGee8XbGhBMUatMgo4wTZyLXGaIrWxyaZ+E5asJhoaM5+2lQOYdo/raWJZpDUqM2bxqzYurrkQF9yNFknopNbgaNASxtx16Nab2Fc3f/KQtUlvPQoyuSkw6le+mDB38kS3lTFpPWnJpaunbTtYDMv8PkFsMn4vS4eyN4nKzVynB9nnAtPoAZqMBN5sjhtjIt+w5pmdRlBflOQbFDv61kdm1XdPIx943GYbZ3zp5t5eFdzhklee5b5B9BCldfBCT/aQpfBhKaTrvKIl9kUzB76saI7ndms5zcP3e8MmhKjpkxVeM0y9o7kNgZJNNRaEqqq+DOfD7dPd+Dvl37dVTtvaLPsgmwNVx17fPKI0rg/TqVSJY3vrZTZAsVI9/VU3jgnXE+Hlcj1EK/3AfAd3r5X2pPkarr94pJCMEu3xx+se3sPrT9RQ/ghepWoLZp68+OP0AePpJ+QoxjfwJgsHVsZ60PxTvrSxdO7q+6s/sItyJPMPOq2dz+U0Vu+071KPJ8JaIOvpCfSjYCmwxGg1wm6Rv4tMrsHvOq3/siljT935+Zze1QLC5a6T+1+FRa4tpsuS0S3oxDPyK2A2X+IvuEaC6ld9jxDscUGhZlu5SWEUhgUyWTFKFc8F/Q1PS+HhUqGtgh9
 Z69sDb/s
 dkPxLtrIhGgjBZWNG8KN0yk/mQXE6MFZTVarw+Mu0NmBgAVMT4oL3R6kCJXqaJ69huW+oLmaV/aJ8Di9+Z61iBawRTCfVVH9KGhiEEiC71uS1IrgtBtFc2nR6xJ3+wKW7n8D9qOyW5vslpyPvkcSJyEIAkmZYCaE4Ybh/XwrmQ1cKqEBm4Cp9MwfIkqzImkirnel8vNKtrhKrTisXZHiSG8DrocMdiIseoOVVjgubICBxcHQ+bcAx5o1HcdXA28jI5TgjUtaqPPCdy7Rwiql9FRSzuY5ZHdRc8CCoefTz3+bhA7fKrhcyLiO0STF22eXCgsvsnKf6MLdEsRskNHqOzj027g95LAc0YzeZEHZNzBB3zfQPPBQ1gjeh3r3C7kAcqC+l7UnbtDBcWU9ken01gOy4oeWHkg9PMgjfI0Moy8Mj8kmOcys4w7s5lk2udZ4uHb6xnDOqP12WmObvdjgwaKWGl59wgZhhAOcMMSm3KtjUEG7lQbh6OhqfUeB9AN1b/0U3hojh4v7Cp+fDFVBRrJLgTzNMKrB7Yo0PZCJvBlOG8rxrd+vnCEuckbfT2hD+fXbwvfmNP73jYwGVmnLHccrKo/ASL1ziE70wGsr9+Qy4dgdYEvl34DSsplYlasQHgCR91cAcnYRKPWrb6yxC8/YgMpC3KgcDnVCNz35pg8yR5HBotvjWHUqZEy3mu4yRm1pDwe3ZxGAuUtyOEOJ4CAtoSGGiEgUVXK6EgT/FTlWaMQntuM5ND1Fmzzo2wl5m1WrnZc7euNyUiOHkQ18AP5GK5a753QRduIq/AaRUS4cTDSarujJqHApxE1W8bLYK/bTJQfoS8CyT3ziPnqCWXvrnuQHpudeBKL+ZaAgCdqxNrHnA8pdzkuUbyXi1F5F/VuyG1lqBLc+3U4/QKdXGy8jgWP3mRdOr3GdJPeAS7uUNw6hH8YnNKDgRYoih/hwid2KYLvIcMKiFaN8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 13, 2026 at 01:20:27PM +0000, Wei Yang wrote:
>On Tue, Feb 10, 2026 at 03:23:04AM +0000, Wei Yang wrote:
>>On Mon, Feb 09, 2026 at 05:08:16PM +0000, Lorenzo Stoakes wrote:
>>>On Thu, Feb 05, 2026 at 03:31:13AM +0000, Wei Yang wrote:
>>>> Commit 60fbb14396d5 ("mm/huge_memory: adjust try_to_migrate_one() and
>>>> split_huge_pmd_locked()") return false unconditionally after
>>>> split_huge_pmd_locked() which may fail early during try_to_migrate() for
>>>> shared thp. This will lead to unexpected folio split failure.
>>>
>>>I think this could be put more clearly. 'When splitting a PMD THP migration
>>>entry in try_to_migrate_one() in a rmap walk invoked by try_to_migrate() when
>>
>>split_huge_pmd_locked() could split a PMD THP migration entry, but here we
>>expect a PMD THP normal entry.
>>
>>>TTU_SPLIT_HUGE_PMD is specified.' or something like that.
>>>
>>>>
>>>> One way to reproduce:
>>>>
>>>>     Create an anonymous thp range and fork 512 children, so we have a
>>>>     thp shared mapped in 513 processes. Then trigger folio split with
>>>>     /sys/kernel/debug/split_huge_pages debugfs to split the thp folio to
>>>>     order 0.
>>>
>>>I think you should explain the issue before the repro. This is just confusing
>>>things. Mention the repro _afterwards_.
>>>
>>
>>OK, will move afterwards.
>>
>>>>
>>>> Without the above commit, we can successfully split to order 0.
>>>> With the above commit, the folio is still a large folio.
>>>>
>>>> The reason is the above commit return false after split pmd
>>>
>>>This sentence doesn't really make sense. Returns false where? And under what
>>>circumstances?
>>>
>>>I'm having to look through 60fbb14396d5 to understand this which isn't a good
>>>sign.
>>>
>>>'This patch adjusted try_to_migrate_one() to, when a PMD-mapped THP migration
>>
>>I am afraid the original intention of commit 60fbb14396d5 is not just for
>>migration entry.
>>
>>>entry is found, and TTU_SPLIT_HUGE_PMD is specified (for example, via
>>>unmap_folio()), exit the walk and return false unconditionally'.
>>>
>>>> unconditionally in the first process and break try_to_migrate().
>>>>
>>>> On memory pressure or failure, we would try to reclaim unused memory or
>>>> limit bad memory after folio split. If failed to split it, we will leave
>>>
>>>Limit bad memory? What does that mean? Also should be If '_we_' or '_it_' or
>>>something like that.
>>>
>>
>>What I want to mean is in memory_failure() we use try_to_split_thp_page() and
>>the PG_has_hwpoisoned bit is only set in the after-split folio contains
>>@split_at.
>>
>>>> some more memory unusable than expected.
>>>
>>>'We will leave some more memory unusable than expected' is super unclear.
>>>
>>>You mean we will fail to migrate THP entries at the PTE level?
>>>
>>
>>No. 
>>
>>Hmm... I would like to clarify before continue.
>>
>>This fix is not to fix migration case. This is to fix folio split for a shared
>>mapped PMD THP. Current folio split leverage migration entry during split
>>anonymous folio. So the action here is not to migrate it.
>>
>>I am a little lost here.
>>
>>>Can we say this instead please?
>>>
>
>Hi, Lorenzo
>
>I am not sure understand you correctly. If not, please let me know.
>
>>>>
>>>> The tricky thing in above reproduce method is current debugfs interface
>>>> leverage function split_huge_pages_pid(), which will iterate the whole
>>>> pmd range and do folio split on each base page address. This means it
>>>> will try 512 times, and each time split one pmd from pmd mapped to pte
>>>> mapped thp. If there are less than 512 shared mapped process,
>>>> the folio is still split successfully at last. But in real world, we
>>>> usually try it for once.
>>>
>>>This whole sentence could be dropped I think I don't think it adds anything.
>>>
>>>And you're really confusing the issue by dwelling on this I think.
>>>
>
>It is intended to explain why the reproduce method should fork 512 child. In
>case it is not helpful, I will drop it.
>
>>>You need to restart the walk in this case in order for the PTEs to be correctly
>>>handled right?
>>>
>>>Can you explain why we can't just essentially revert 60fbb14396d5? Or at least
>>>the bit that did this change?
>
>Commit 60fbb14396d5 removed some duplicated check covered by
>page_vma_mapped_walk(), so just reverting it may not good?
>
>You mean a sentence like above is preferred in commit msg?
>
>>>
>>>Also is unmap_folio() the only caller with TTU_SPLIT_HUGE_PMD as the comment
>>>that was deleted by 60fbb14396d5 implied? Or are there others? If it is, please
>>>mention the commit msg.
>>>
>
>Currently there are two core users of TTU_SPLIT_HUGE_PMD:
>
>  * try_to_unmap_one()
>  * try_to_migrate_one()
>
>And another two indirect user by calling try_to_unmap():
>
>  * try_folio_split_or_unmap()
>  * shrink_folio_list()
>
>try_to_unmap_one() doesn't fail early, so only try_to_migrate_one() is
>affected.
>
>So you prefer some description like above to be added in commit msg?
>
>>>
>>>>
>>>> This patch fixes this by restart page_vma_mapped_walk() after
>>>> split_huge_pmd_locked(). We cannot simply return "true" to fix the
>>>> problem, as that would affect another case:
>>>
>>>I mean how would it fix the problem to incorrectly have it return true when the
>>>walk had not in fact completed?
>>>
>>>I'm not sure why you're dwelling on this idea in the commit msg?
>>>
>>>> split_huge_pmd_locked()->folio_try_share_anon_rmap_pmd() can failed and
>>>> leave the folio mapped through PTEs; we would return "true" from
>>>> try_to_migrate_one() in that case as well. While that is mostly
>>>> harmless, we could end up walking the rmap, wasting some cycles.
>>>
>>>I mean I think we can just drop this whole paragraph no?
>>>
>
>I had an original explanation in [1], which is not clear.
>Then David proposed this version in [2], which looks good to me. So I took it
>in v3.
>
>If this is not necessary, I am ok to drop it.
>
>[1]: http://lkml.kernel.org/r/20260204004219.6524-1-richard.weiyang@gmail.com
>[2]: http://lkml.kernel.org/r/df86ccfd-68a5-416e-81cc-02858e395b70@kernel.org
>

Hi, Lorenzo

I am not certain on how you prefer the commit msg, would you mind taking a
look at my question when you have time slot? So I could prepare next version.

Thanks a lot.

>>>You might think I'm being picky about the commit msg here, but as is I find it
>>>pretty much incomprehensible and that's not helpful if we have to go back and
>>>read this in future.
>>>
>>
>>Never mind.
>>
>>A clearer and comprehensive change log is helpful for all. And my English is
>>not native language, so your suggestion helps a lot.
>>
>>>>
>>>> Fixes: 60fbb14396d5 ("mm/huge_memory: adjust try_to_migrate_one() and split_huge_pmd_locked()")
>>>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>>>> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>>>> Reviewed-by: Zi Yan <ziy@nvidia.com>
>>>> Tested-by: Lance Yang <lance.yang@linux.dev>
>>>> Reviewed-by: Lance Yang <lance.yang@linux.dev>
>>>> Reviewed-by: Gavin Guo <gavinguo@igalia.com>
>>>> Acked-by: David Hildenbrand (arm) <david@kernel.org>
>>>> Cc: Gavin Guo <gavinguo@igalia.com>
>>>> Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
>>>> Cc: Zi Yan <ziy@nvidia.com>
>>>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>>>> Cc: Lance Yang <lance.yang@linux.dev>
>>>> Cc: <stable@vger.kernel.org>
>>>>
>>>> ---
>>>> v3:
>>>>   * gather RB
>>>>   * adjust the commit log and comment per David
>>>
>>>Clearly not enough :)
>>>
>>>>   * add userspace-visible runtime effect in change log
>>>
>>>Which one was that?
>>>
>>>> v2:
>>>>   * restart page_vma_mapped_walk() after split_huge_pmd_locked()
>>>> ---
>>>>  mm/rmap.c | 12 +++++++++---
>>>>  1 file changed, 9 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/mm/rmap.c b/mm/rmap.c
>>>> index 618df3385c8b..1041a64b8e6b 100644
>>>> --- a/mm/rmap.c
>>>> +++ b/mm/rmap.c
>>>> @@ -2446,11 +2446,17 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
>>>>  			__maybe_unused pmd_t pmdval;
>>>>
>>>>  			if (flags & TTU_SPLIT_HUGE_PMD) {
>>>> +				/*
>>>> +				 * split_huge_pmd_locked() might leave the
>>>> +				 * folio mapped through PTEs. Retry the walk
>>>> +				 * so we can detect this scenario and properly
>>>> +				 * abort the walk.
>>>> +				 */
>>>
>>>This comment is a lot clearer than the commit msg :)
>>>
>>>>  				split_huge_pmd_locked(vma, pvmw.address,
>>>>  						      pvmw.pmd, true);
>>>> -				ret = false;
>>>> -				page_vma_mapped_walk_done(&pvmw);
>>>> -				break;
>>>> +				flags &= ~TTU_SPLIT_HUGE_PMD;
>>>> +				page_vma_mapped_walk_restart(&pvmw);
>>>> +				continue;
>>>
>>>This logic does lok reasonable.
>>>
>>>>  			}
>>>>  #ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
>>>>  			pmdval = pmdp_get(pvmw.pmd);
>>>> --
>>>> 2.34.1
>>>>
>>>
>>>Cheers, Lorenzo
>>
>>-- 
>>Wei Yang
>>Help you, Help me
>
>-- 
>Wei Yang
>Help you, Help me

-- 
Wei Yang
Help you, Help me

