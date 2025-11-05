Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8403CCFA0D
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 21:29:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA7C78E001C; Wed,  5 Nov 2025 16:29:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E58198E0002; Wed,  5 Nov 2025 16:29:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1F468E001C; Wed,  5 Nov 2025 16:29:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BE4FC8E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 16:29:22 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 659B4C04B2
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 21:29:22 +0000 (UTC)
X-FDA: 84077844564.01.7FBBB12
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	by imf15.hostedemail.com (Postfix) with ESMTP id 56E27A000C
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 21:29:20 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="T2ajH/uh";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of davidhildenbrandkernel@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=davidhildenbrandkernel@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762378160; a=rsa-sha256;
	cv=none;
	b=z6Sjv0E41z6vtMFspxSBNGVuU7Iy18MuajyQuZeoewg45oq0atilNMUFCGjc/EIIYSj5CH
	LLQyVRWSI9IJtJsTPaq1cDXWiAhcEr0upwQ7Iz5UUkBxj2o8RbMkohaRTRMXj7bZrLpQRh
	up2C0/7mEvSn1i/FJW9NM1O8F1Gtjms=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="T2ajH/uh";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of davidhildenbrandkernel@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=davidhildenbrandkernel@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762378160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6FXHSyf2tmThjEU70iMaM/iQ+kQ6AR9dxeHlynBInUg=;
	b=DXT7QQezeIuhTkvxQqQoYfJNM+/KVl3EkHHx9lse7+A15OZPPbZir7LuqZz/neCJdhZBzt
	67tkoyvpsXHuxZkKeQ2rj8p8XfkrQfzJLYbZ1zPjn0I0P1JCrs1JuyRxE8huhoOAQu7HwO
	G/cq3fP39Dou85r5UkGb+u7ScLDcqxI=
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-429bccca1e8so207189f8f.0
        for <linux-mm@kvack.org>; Wed, 05 Nov 2025 13:29:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762378159; x=1762982959; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6FXHSyf2tmThjEU70iMaM/iQ+kQ6AR9dxeHlynBInUg=;
        b=T2ajH/uhZOAZmrWYfbQWnPKuZQdMJ8YSZScJIxdQqzYR0+QNbKXiWGE54Qc4cfgvgG
         fUHtu/KnSrxpB9/N1TJEerJQ4WiFPWIB1srgVdwM1HtBckfsOXlzb8ipxYna16ydLWET
         d1zikMql4DR3nwUIqo2j1gddBVA+4X+L26GKVcg8Nycxge7AWs8UxBgqeFJ0Q7ImNFXj
         xTKzMpvlUI8Urps90P1flYGG5KwSmBbUJnVTWGh9x0Sz0qxxsq8jlzUDY+xRM2Xb2kRn
         oaO18xcN4uPrrKQF62Tg+RYf4vWQeI4W4zeP69E4sAYiocqeR2zYsNEaP7EWFLIUBOaO
         nbOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762378159; x=1762982959;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6FXHSyf2tmThjEU70iMaM/iQ+kQ6AR9dxeHlynBInUg=;
        b=OXkTmdgD3XqZkZH31gPxxSx9Uf4//+6D0yTyoidEJO+wVRIP9xvAPIUXGblPzBWZTs
         prbQqpSBoe1ApZIdYVqkuekFzDfKHO5yv85GycR2xV0ahP/8Js1NGCadPp9z0KILZnSO
         i0dB2cew+Z95mauwBaZHx/3Enf2zxTqoSs3IMY1r97+KqVJ5N+Ayv5B45JMUO2aoZNpS
         HSEVU3uJ2aNxPPy2wH2vu9gZJTe0Az/4bH7ITXKzFdkuoNQeYi5yyRIwfhvBy4w4caQC
         DX7EHGrxJK7D7wZZv3gOxGF4xvkHx5fiNW0IKDnIEdN/6fwsgBIv3aYJTdm5BmGgtn/c
         5O4A==
X-Forwarded-Encrypted: i=1; AJvYcCVvxoYPsChVeU0wYpL7GkOCOyYBWXRxnnexbbHKCPKixaHhcYaxsoZc/62v6s96DjA3w0GLxbYNew==@kvack.org
X-Gm-Message-State: AOJu0Yy+ttJnzD5uhuzDPvDdmwsfxGZqsUdLJJAAg4lj1PcbAVQ+Dy9t
	y37AFYw7OS1INIYa88ihS22ESBFZiqTghIBPbCNaDw38KeOrN3RU6js1
X-Gm-Gg: ASbGnctp9Wp20yfC9kuisOK53Cb6NivdDb79FTifBKHwbxzcY3LeKNA79ZYb9OdDopq
	yf0jM6DcTb6XpGulwfv1+kHFsM/Kiu9+z+cWmY4WIAb/pT9hB1+9sohKKZRxUoITLHZhepzjBsO
	84sx2lCXdvMvy5G33jntYG9JZiXBi8Nea436DtK4Tt5qxE97dlrd0f4Prp7zq17mlYXRfxEnSrH
	2D5QW9Ms/uqj0i3eO5uYRELVUWaFl+31g7gKoX4gXY3o7o4snmdo3IZTCGprg53g7wXfieUvGNy
	d4ri2kFoJ/7QPzcKiITirXv4ITpBJ/a/QyWOy333Gt69RfRy2yC80f9Z5YWwvGHyCkLwyhkPgX1
	mKhLojbyfFdav43434zTKtAWOqFVEoBZgbiJAG5f2cdxpDPqaXdQRZGOO6iBakCwTBDb+Fwic78
	OsxzF1UqEBOP+Pd79sQC8iRhJcNGGJG8Dlh/9B9ZjgM/fkh9F6+n0DVj6Vi+DpPqyJKmqwJSPx2
	eMf14vBMmBUOTP/jlfvlGitFJRG8ZA=
X-Google-Smtp-Source: AGHT+IFI9Wwvq/A5D0mlqZlN00u3cG6xT1eMWW/nCv3lLfCOJ9IihPCMHOqYjym3ZOcL+eAXbx3BBQ==
X-Received: by 2002:a05:6000:410a:b0:429:bbfa:2305 with SMTP id ffacd0b85a97d-429e330579dmr3946595f8f.35.1762378158606;
        Wed, 05 Nov 2025 13:29:18 -0800 (PST)
Received: from ?IPV6:2003:d8:2f30:b00:cea9:dee:d607:41d? (p200300d82f300b00cea90deed607041d.dip0.t-ipconnect.de. [2003:d8:2f30:b00:cea9:dee:d607:41d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429eb403747sm874380f8f.4.2025.11.05.13.29.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Nov 2025 13:29:17 -0800 (PST)
Message-ID: <bc94d739-d66f-4cd6-a3f2-68938cfd08c1@gmail.com>
Date: Wed, 5 Nov 2025 22:29:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/16] mm: introduce leaf entry type and use to simplify
 leaf entry logic
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Gregory Price <gourry@gourry.net>, Matthew Wilcox <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Peter Xu <peterx@redhat.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Arnd Bergmann <arnd@arndb.de>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, Vlastimil Babka <vbabka@suse.cz>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>,
 SeongJae Park <sj@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 Leon Romanovsky <leon@kernel.org>, Xu Xin <xu.xin16@zte.com.cn>,
 Chengming Zhou <chengming.zhou@linux.dev>, Jann Horn <jannh@google.com>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, Pedro Falcato <pfalcato@suse.de>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, Rik van Riel <riel@surriel.com>,
 Harry Yoo <harry.yoo@oracle.com>, Hugh Dickins <hughd@google.com>,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-arch@vger.kernel.org, damon@lists.linux.dev
References: <cover.1762171281.git.lorenzo.stoakes@oracle.com>
 <2c75a316f1b91a502fad718de9b1bb151aafe717.1762171281.git.lorenzo.stoakes@oracle.com>
 <aQugI-F_Jig41FR9@casper.infradead.org>
 <aQukruJP6CyG7UNx@gourry-fedora-PF4VCD3F>
 <373a0e43-c9bf-4b5b-8d39-4f71684ef883@lucifer.local>
 <aQus_MNi2gFyY_pL@gourry-fedora-PF4VCD3F>
 <fb718e69-8827-4226-8ab4-38d80ee07043@lucifer.local>
 <7f507cb7-f6aa-4f52-b0b5-8f0f27905122@gmail.com>
 <2d1f420e-c391-487d-a3cc-536eb62f3518@lucifer.local>
 <563246df-cca4-4d21-bad0-7269ab5a419c@gmail.com>
 <52dd0c85-9e06-4cb2-a9f9-71662922cba9@lucifer.local>
From: "David Hildenbrand (Red Hat)" <davidhildenbrandkernel@gmail.com>
Content-Language: en-US
In-Reply-To: <52dd0c85-9e06-4cb2-a9f9-71662922cba9@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 56E27A000C
X-Stat-Signature: qr4ugkz8bq88zfyt1eu9ofn8t7dos5yo
X-HE-Tag: 1762378160-954615
X-HE-Meta: U2FsdGVkX1/fKFOswidzvya5/EnrajMV+UBCoIQpz/oM+Aa0btoO1ReK2xVk4iR2Bgs+VB2DYopVF0EwYzb98k2DNG9yzV7HU3YjrM2E3+KPROQn1JpX1QNdfhgClwwfUiYlL/pTc87Agbxb+xMrx13F4k80YnVKiiDRF5mB989esnbUFOkwjYy/l0JKcZ2b+9v4P0fnI/jU8+7v+LpKpZLn2RaR9AC+zo7Fsw8OkL88G8VTjc6bePmyiNnQgdKJVGBMKAB+WfLb5E8HcaAIVqWu/vbjr4TmaoMqLgzcVMIHrKGLGMWFQhZ4iuS7S8MPCN1Fmf19vNTNpKxtHmAW2o4Vgae/cuc9McaRG9eTwvELcvwLYlSin8R7xMZg1UiEuNnr0XxOOwADr4xE4+oRGRnb0J6OPoolmxYBeJrBgxKd0cd9VJgzmNlvCwg+omdP2DL8IhUskXyxj5rwqGhBRsMFl65W/M2oIj7AkRcKCBfvoONqPwkWnVeYkpX4SuRzEDVSNQ9ECxRWk3x8dN/6S8zDdnBYzzowbPZLRvCxMBsMGCIx97Hl0acbVSilydsOPGlvs2dBVb+huDMcUL4icFPG5M6AIqRK1L0M+VC3m9Eeh+joKSUM3IgqI+6paqC8bE1HKoA7OyV0zqdNvHnFyRb8zLWd7FYtyG/NqHhbnZO21FqSBJl5xf7AkhSc4hC5mX4HXezI3zlYGMG+CJMbfuZ+V+3nM3O20gDp3MswQelcVSlkLGH5/z/nJXZ30UYvFSS4HrUGHFPxzj30oWRJPMuxq7Kod20ejSSQysWIeagLddJ+cCQvqbl8jFdngFuJ5bK8FVZf3XMnQYAX/YWr52OOB7HjM/SmPvKSW4AAKuERvhaVw50AMxfDdaa7txttOkOqJs2/wtMfZAVi7F3kqIUSfGtNA9HEYA4kUUq6qRRRb/a0YAZiQ/iN+EKD+BWmXifi7fJZBnUyDY2bZPG
 f0+BGkwb
 BN/VwoHRn8tUESACuhdrryTpHswXIut2yFdk8W7DhNaGwquPryJpvo8XJ+M3OFTKcgkpzar4ZoSsLBcDn5VCoybZlgZcuF56EzKegAYhw9cLwpptOLTKIPKbCkiByjyMyUiE3pgoLapaMYwDQDbk0FrfDfZhkx5WU3ny4bvCgFHWsk7vKO1+s0WJCRUs/MZiy/04H04CT9TpucVNFIGs7sLPBmtZIppoeSuwwxiGI9SeIQdgcIwW3gufZZyhnMIA9VqIknmrpQmsivavOYkMqY5l4y13Z0vL6Ld5qB+cwa1U30X+AHaWKMstzCFUhl06p+02ICTpS3CH2ZqTsvFsCQ5pxfFqlo8anonNNL/3lhLxOsq4qE6Uj4wWwd3wjH2AzlRnXAOW9PBgUjMKp1ibFLpM4P6hoXyncHVBwD5clFQC5n92lSEyOweSNHU/r2wUnBK7Krj/fZ+Zasx+1UFvSUbm1wfBT2mmYm5IbFJqHagbGc8Mtob2KLXMUE1DJ5Y8VKDQ9Lzee+8rdyfy9C45j3THWmjQbNO9oS31y2ykYpUmL/f0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05.11.25 22:24, Lorenzo Stoakes wrote:
> On Wed, Nov 05, 2025 at 10:15:51PM +0100, David Hildenbrand (Red Hat) wrote:
>> On 05.11.25 22:08, Lorenzo Stoakes wrote:
>>> On Wed, Nov 05, 2025 at 09:11:45PM +0100, David Hildenbrand (Red Hat) wrote:
>>>> On 05.11.25 21:05, Lorenzo Stoakes wrote:
>>>>> On Wed, Nov 05, 2025 at 03:01:00PM -0500, Gregory Price wrote:
>>>>>> On Wed, Nov 05, 2025 at 07:52:36PM +0000, Lorenzo Stoakes wrote:
>>>>>>> On Wed, Nov 05, 2025 at 02:25:34PM -0500, Gregory Price wrote:
>>>>>>>> On Wed, Nov 05, 2025 at 07:06:11PM +0000, Matthew Wilcox wrote:
>>>>>>> I thought about doing this but it doesn't really work as the type is
>>>>>>> _abstracted_ from the architecture-specific value, _and_ we use what is
>>>>>>> currently the swp_type field to identify what this is.
>>>>>>>
>>>>>>> So we would lose the architecture-specific information that any 'hardware leaf'
>>>>>>> entry would require and not be able to reliably identify it without losing bits.
>>>>>>>
>>>>>>> Trying to preserve the value _and_ correctly identify it as a present entry
>>>>>>> would be difficult.
>>>>>>>
>>>>>>> And I _really_ didn't want to go on a deep dive through all the architectures to
>>>>>>> see if we could encode it differently to allow for this.
>>>>>>>
>>>>>>> Rather I think it's better to differentiate between s/w + h/w leaf entries.
>>>>>>>
>>>>>>
>>>>>> Reasonable - names are hard, but just about anything will be better than swp_entry.
>>>>>>
>>>>>> SWE / sw_entry seems perfectly reasonable.
>>>>>
>>>>> I'm not a lover of 'sw' in there it's just... eye-stabby. Is that a word?
>>>>>
>>>>> I am quite fond of my suggested soft_leaf_t, softleaf_xxx()
>>>>
>>>> We do have soft_dirty.
>>>>
>>>> It will get interesting with pte_swp_soft_dirty() :)
>>>
>>> Hmm but that's literally a swap entry, and is used against an actual PTE entry
>>> not an abstracted s/w leaf entry so I doubt that'd require renaming on any
>>> level.
>>
>> It's used on migration entries as well. Just like pte_swp_uffd_wp().
>>
>> So, it's ... tricky :)
>>
>> But maybe I am missing your point (my brain is exhausted from uffd code)
> 
> We'd either not rename it or rename it to something like pte_is_uffd_wp(). So
> it's not even so relevant.

We do have pte_uffd_wp() for present ptes.

> 
> We'd probably call that something like pte_is_soft_dirty() in the soft dirty
> case. The 'swp' part of that is pretty redundant.

We do have pte_soft_dirty() for present ptes.

So we'd need some indication that these are for softleaf entries (where 
the bit positions will differ).

> 
> If people were insistent on having softleaf in there we could call it
> pte_softleaf_is_soft_dirty() which isn't qutie so bad. But I'd not want to put
> softleaf in there anyway.
> 
> sw_entry or sw_leaf or sw_leaf_entry would all have the same weirdness.
> 
> I want it to be something that is readable + not hideous to look at but still
> clear as to what it's referring too. Softleaf covers all of that off... :)

I think you misunderstood me: I have nothing against softleaf, I was 
rather saying that we already use the "soft" terminology elsewhere 
(soft_dirt), so it's not too crazy.


