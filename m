Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6D0C109C029
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 14:54:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 326936B0095; Wed, 25 Mar 2026 10:54:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FDF86B0096; Wed, 25 Mar 2026 10:54:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2151B6B0098; Wed, 25 Mar 2026 10:54:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 101636B0095
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 10:54:09 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A40E913BD64
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:54:08 +0000 (UTC)
X-FDA: 84584880576.27.D4BF8C0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id E4F67C0010
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:54:06 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ajhMjt4F;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774450446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9yBFBc6nhgECLvWUQvqBo5IN9HtcEWLWVeM4IzOvHwo=;
	b=BL8xNl/twvsY7xWO3WC7rUIJGWpjCmSwRrpn+ZAKqMVj+TEBOr13GegikDYQgVNvEFiSxM
	JxEMu9gbUyjp3ugrcj8QuzJYj3Pful8ctHMa/A7EJD0pDdrLMFcfSShWr6zcHuLmmKDLa3
	wKZWsWroU5jE5A9K4NBBGNjKMHYhPtk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774450446; a=rsa-sha256;
	cv=none;
	b=pqNVFXccLa1qahXWNLEz2scssUfWOXkLqwja11nqkKIZvCRFkDmbLdUY7ER2ql9fTV3StF
	aZuBuFCLdw36J3zWzMNwtTOVYWSpcvaERSec8stZKZvCHUqd9cWxeGL3dBKGAhduf8QT0P
	wFpD/aWcQuv82ZgKaB/04dwE9QAPv3A=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ajhMjt4F;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 52471600C4;
	Wed, 25 Mar 2026 14:54:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BF16C19423;
	Wed, 25 Mar 2026 14:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774450446;
	bh=TiRQ+ZcNteLWEUlMa6hmUHy0u948Jpn7nl6mHJvJZCI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ajhMjt4F8x+ODWSbHiXFeyWWdrBdaJxTCOvvjL1SP39YyW5LQhd9wvr7N2eUOKi81
	 OsgMUE7Zussx+3+FQ97CDrgeQbjHeQyKj3aTVi+Pckj8fMIsvUkLh8eISNttCcVrWi
	 Ca0a6NN47jr8f3CUhJK0M9DUGftG2RNM/0e9ej3uQofL36KzGOsq3f8fteiicrAd5z
	 M18luba1Q/LCWZT2vHqhanqMpCcW4KTkgGi+FF9Ff1hVN9ic6G+Ipw8uVlrtAanNgv
	 yaG1oCvT5YvnZT6ja8CJBOY9zOuNqF6sHNdLbPAPs7op9VaHpL9vsow8xP4h+kkexE
	 HbzU8nChO3WhQ==
Message-ID: <27b1b602-129f-4bc5-a553-386e8d1f5d90@kernel.org>
Date: Wed, 25 Mar 2026 15:53:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/migrate: rename PAGE_ migration flags to FOLIO_
To: Zi Yan <ziy@nvidia.com>, "Garg, Shivank" <shivankg@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, willy@infradead.org,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260324114720.864478-2-shivankg@amd.com>
 <54398FC0-2F68-410C-B9C4-2802810C119B@nvidia.com>
 <41cd005e-3702-4c67-8d32-0c09274194e9@amd.com>
 <cb383f3f-b74c-41a8-a77d-d00e93b7fe94@kernel.org>
 <f844a2ce-105e-4002-a106-b936ddd98a99@amd.com>
 <857B5E73-94AC-41B9-A3BE-953E59A5DB40@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <857B5E73-94AC-41B9-A3BE-953E59A5DB40@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: rwpxthub9k87r3gebg6a5pafk37n486n
X-Rspamd-Queue-Id: E4F67C0010
X-Rspam-User: 
X-HE-Tag: 1774450446-251010
X-HE-Meta: U2FsdGVkX186gAzrbaxIfm/4OsZZ72OEIk6x0CwOCfFn3iKPis7M0bUb67edK6h4j5ErLEEsED0HDCUak5zh2YDUP+7eo05gGSfYQaBYqkUeqXJqhuo1WoGV8VI0Tg+/JmKmIIDD4qQN/CU5YlbtOVskpm1snKin4oTq+7WHPHv2LBDR8DPzKB85Oc/2WBFXP3kJrwqjnnOq67W9wk/6TIBjnerK6DDpF/84yFY3mhI7MBKxIzH8Clf7/fjBXcArOLN+lEtoR04R1JKmjN3NhLx+L5uLQHZ7qF5JyiXEHiQmPR146unoRbPFc2tJVrzfp3KRa4mZ5bb8JFR6u39p7IPW57STLFPLeznPK5aAEL+LyW9UloMoBGTKaGu164id0GyCnqEJpaHjasE0rvlAOlIvWxhKJ5lmIG2rnNhT+0Qc9FCrZqyBGJljhcpz4+ZmVuKudrcSWtgFn6Hb1OHqZsa3vkrGGNKfPt5ReJvEWn4VUAbwutfE+pIufI/KkMBIlv+FlS/xZrfySTfVKIy1a1nNylbyd3iC0VD11/usDRZbdID9YXwaacur+sm+floT/zoWw4NSqHb9GAG3YNBLzOaTVfR1026t5VjODmv/p2VgrAJT7WzpEcW/h1yqVCltoDF8Fy8/tZjsxFVQKF+FuwAgDc5fbDkA6ALKsMVF1GpqqQILl2Gsb8ExR1rsB6sLSgQU/cdM9pE9wXMkJ+oD0FWnLbyEvPl6wAh6emeeWEv5jtikO1PNtnRrwsYRDT0kiZgGPCZOM90ApwfN9Ip4putOwTGLcOrqfC45sz1SMoTRoKEa2sxK2l2kG/zJx3grbtMp4OIv8RHMftT/VTWf0aaLwTrqfAyqJgMxVCjxSre1RQ6Ni253ygUgKcpc0xlm6pPO26Ly2VnCCdU1IefWyFu8wkzV8jd32pd89UlJkcLnxqWEtrBikZ/zHAGaZlulUkbUafKzpSDUtZbcejo
 Jj8CvgjO
 09Gv0EVhcCQk655sxerbvwCxDIn8zYJd2/18ne9dNzXSJiOYJRj2xuxZrkXQrh00IRjGVNxJcSveMJGW9zIH4WgbW+/v91NY1wfv7ijgyu1qpAezIRr824PGh0sa7HNdrzVbIefjythvUlBjyEqrutezXZG/zjSzz+8Dz3K4YG/1yvPv07Cfri+i2BlH5dvGRhzBzsVa7vl/EffVwd9tYvSZ/nI4Hc4yr2FriTao/ESen3/ZieXLNLgP90h/6sNSyFEfxYmLP1fx2yPhMSHzqXedzlAxJPyYyIhvsy5QMZmDaGJnQ1/d8fWT/0FDu8EWbZuOhjOQrjO/Qzzvs225XeY8WiPPLaL6vI1g1R4cTdoobSDu56HHNiePJEg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/25/26 15:21, Zi Yan wrote:
> On 25 Mar 2026, at 7:04, Garg, Shivank wrote:
> 
>> On 3/25/2026 2:55 PM, David Hildenbrand (Arm) wrote:
>>>
>>>
>>> Isn't folio_change_private() part of the
>>> folio_attach_private()/folio_detach_private() interface that has
>>> completely different semantics?
>>>
>>> "The page must previously have had data attached and the data must be
>>> detached before the folio will be freed."
>>>
>>> (btw, that comment should refer to pages)
>>>
>>> So I would not use folio_change_private(). An accidental
>>> folio_attach_private() / folio_detach_private() would be rather undesired.
> 
> Hi David,

Hi,

> 
> In terms of folio_change_private(), I did not think it is related to
> folio_{attach,detach}_private(), since the latter change folio refcount during
> the operation. If folio_change_private() is related to attach/detach,
> I imagine it would check folio refcount before touches ->private. But
> that is my interpretation.

I mean, given that

a) It's located in pagemap.h in between folio_attach_private() and
folio_detach_private()

b) It clearly states that "The page must previously have had data
attached and the data must be detached before the folio will be freed."

This is the wrong API to use?

Sure, it sets folio->private but in different context.

I can spot one user in mm/hugetlb.c, that likely also should not be
using this API, because there likely was no previous attach/detach.

> 
> BTW, do you know why we have set_page_private() but no folio_set_private()?
> I would suggest folio_set_private() if it exists.

folio_set_private() sets ... PG_private. :)

folio_test_private() checks PG_private and folio_get_private() returns
page->private.

A cursed interface.

What we should likely do is:

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 3944b51ebac6..702cb2c0bc0e 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -426,6 +426,7 @@ struct folio {
                        union {
                                void *private;
                                swp_entry_t swap;
+                               unsigned long migrate_info;
                        };
                        atomic_t _mapcount;
                        atomic_t _refcount;

And not using folio->private in the first place. Just like we did for swap.

-- 
Cheers,

David

