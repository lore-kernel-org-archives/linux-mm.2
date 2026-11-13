Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A11BB606A889
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 09:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Bbcq+flr
Received: by kanga.kvack.org (Postfix)
	id 9EB3B6B062C; Fri, 13 Nov 2026 04:12:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99C546B062F; Fri, 13 Nov 2026 04:12:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87BEA6B0632; Fri, 13 Nov 2026 04:12:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4E8516B062C
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 04:12:07 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C4606A7E6F
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 09:12:06 +0000 (UTC)
X-FDA: 85429529052.23.1DC8ABD
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4E6E6100007
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 09:12:04 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Bbcq+flr;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794561124;
	b=i4b+zu/8IBhgmSBeVMcP3YHt4ptMQ37d3oi0M/gYntP92NQxHHgn5SCyxefofmd66FUoKK
	Ksb+ytuYKJxTWwRvCQEQ12INEHH0q27f7Rw/Rnug7B4G9889snY1UH8peaQedNsXPkny5e
	b3/p+TawkecNPVC3Fe9M2kAq4RWe2/8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794561124;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l9qjP3EolVZNhFJ6yU6oKwddBCb6NF0vJywntTMZ9kE=;
	b=LNZXFwSYJApJEjyDZyyvxEYy4G+ZFBJkMgTITbtTuLzaceGn4Zfgn4+BXJ31yuwOjqP3gR
	mWHVpEknomzlEqO+Qz9Pu3x+1wB8WPArSbn7m4HxSOH/9X8BIdFjuXtTwg4NUJIZco0MCH
	Bm3OBKeupjIPISzF1KEd3CR66bhu6GM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Bbcq+flr;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794561123;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l9qjP3EolVZNhFJ6yU6oKwddBCb6NF0vJywntTMZ9kE=;
	b=Bbcq+flrN8v/wCVVGVAvLeQHYqeHKGAKvnYn2qguXzBp3Y11tHYrehbqA7hrqEWLYmYbrs
	Apvgyz+aHNgkFzXQSGg1f8nGbrsPSFLeLE/5lUlURaaFZ4825exN9Zg83Fic8FRjtdHuoo
	0PepzX+FKVqKyn7WLblblOXgl6J96iQ=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-171-7DGfCYW3MzyEBaBT69o43Q-1; Fri, 13 Nov 2026 04:12:01 -0500
X-MC-Unique: 7DGfCYW3MzyEBaBT69o43Q-1
X-Mimecast-MFC-AGG-ID: 7DGfCYW3MzyEBaBT69o43Q_1794561120
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-3ad36e654f1so7373721fa.3
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 01:12:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794561120; x=1795165920;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=l9qjP3EolVZNhFJ6yU6oKwddBCb6NF0vJywntTMZ9kE=;
        b=DSGv/4fgoNR61BvY6n90bRR42FORSarmUK+QqAe8VK6BEtpgYFSl129Fog5pvv6WCj
         OS23+3hAXMIvtyn57pb6v7Cu4giyxdIEYciseV/BwC+VclbnooQ22RLgXtE5yiB8FtWl
         pHXj9xLwqhrdhG5s4XPK3klPGqRtcEFp7ah2rTBHVrstekZ47XiiVY6WMITQZ7R2WA1G
         Smk6KrfrSKUwiyW/35RNpuS1jcJ4XQj6VoXELVN2EQ08HGK92J/9aP+A1I/HUSRQx6J+
         zMbw47Rr0gqzHw/W09v+nF9krNvPo8ty6/Jd8h/mVaHjTx9n7mbb1fxR/PCfGC2PIgEi
         sBrg==
X-Forwarded-Encrypted: i=1; AL+hErFGnuQeZfYolcdnoCwrFvst3qx8IbXOfE4eV/J6MoA3HnqY1p87eGMGglt0566iiTl71NVbU+GXxw==@kvack.org
X-Gm-Message-State: APuU4Z/SjYzxOKdPr51Ph49UoSB8oKJdbv/MGso8KhGLW2qYdFiJu0iF
	tu8QTNvVjvb8k7n3xKZNVtOWlJPy9MXv0Vz1hs8ERGlJBQ899FFzao5afe/PLlJ0dEYRsvVkXbk
	qwSk7HzcyTW5pOtYuXeKVtrKHCB/4E1VLKXWTnku+2VHrNtshmkI=
X-Gm-Gg: AYBFou15DdhhvW4+zokUkL5fN0RGItu8SSTjqXTJB0fN5D5f2mcT5ydA2x6TsLCPvoQ
	BKqVUg0BzDbCM+xqWyAT4Z843TR1TS2HqXsC6H8RPf3t3g2NwrVb9GlO3uKLpN81/v8qvgLLfas
	DX8p0mymD1FUx4cau2mhSFvZyNcH0vZBjLmkzmaST6G072Vuil/gv5shnRo6YWXpVD4CJtR0tcK
	s+CVxknnnS6Vi9gTm1NZ9/yf3JBJMnL+ahTjdsWF7QVsetUqfEifgNwpeo95Gt0C0vtAHka2vK0
	zvmzpCMlsW/bOL2SA2t5Pf8tM/Xa5eQLtOqAWN+WFyPavXkZ69/xiP/64r03g3RH5og85aiXGml
	5XkJVpd/TpqMPclo5PS72PslPN+ARmeJ5ht0uZFcvO3psbc5RqT+P6oAwZzQDSRKIZZBfb40G4Z
	AZjCv3
X-Received: by 2002:a05:651c:a347:b0:3ad:f8cc:390 with SMTP id 38308e7fff4ca-3ae2b4bc3f1mr7065871fa.11.1794561120254;
        Fri, 13 Nov 2026 01:12:00 -0800 (PST)
X-Received: by 2002:a05:651c:a347:b0:3ad:f8cc:390 with SMTP id 38308e7fff4ca-3ae2b4bc3f1mr7065831fa.11.1794561119826;
        Fri, 13 Nov 2026 01:11:59 -0800 (PST)
Received: from [192.168.1.86] (89-27-86-246.bb.dnainternet.fi. [89.27.86.246])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3ae2b76a91fsm6490801fa.8.2026.11.13.01.11.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Nov 2026 01:11:58 -0800 (PST)
Message-ID: <2ad4f730-0656-4b2e-8cbb-4aaae44de1cd@redhat.com>
Date: Fri, 13 Nov 2026 11:11:57 +0200
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 00/12] migrate on fault for device pages
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>, linux-mm@kvack.org,
 dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org,
 linux-kernel@vger.kernel.org, David Hildenbrand <david@kernel.org>,
 Leon Romanovsky <leonro@nvidia.com>, Alistair Popple <apopple@nvidia.com>,
 Balbir Singh <balbirs@nvidia.com>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@suse.cz>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Lyude Paul <lyude@redhat.com>,
 Danilo Krummrich <dakr@kernel.org>
References: <20261103061629.972669-1-mpenttil@redhat.com>
 <avWpWBl1nPcRVmpQ@raptor> <79f33ab0-2e43-4efb-94d0-addaf40745ec@redhat.com>
 <avXoJSGh5xjGFgod@raptor> <20261112164752.GA3692174@nvidia.com>
 <ec4431f1-e70d-477c-b09a-eedc35d97691@redhat.com>
 <20261112162738.d689b46268e077ac06f41d91@linux-foundation.org>
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
In-Reply-To: <20261112162738.d689b46268e077ac06f41d91@linux-foundation.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: vHqQz2jmlaDZLLRDFpqnxs3zDXibQVE733w6aU6Y1zw_1794561120
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4E6E6100007
X-Rspamd-Server: rspam12
X-Stat-Signature: wafr7nikdsj46qa3fan3bk7t5dumijn7
X-Rspam-User:
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794561124-314243
X-HE-Meta: U2FsdGVkX19RN6Bod1DFHBrD3WsP4tlkhJyxqfq8AvzKE6jBoJmWztVwxvdYwF/qxuWvHPAgR62teZuy8trF7+G92LXh4zlsOh1mrBAdL7hah5jh9RwD73WxXt3of86LQqPl0KIdPrbe0YblzOXW0EF7BA2EU9wL18Zwue2B1RawnR2a9Wem5CdG4eNnz5ormzlqSVFP84IzOxluPutGBwhH5o/bDCDYsbv6uuK4m9NknY7Gt7VutiqT3fjF+PwARfkW1Fwm8OZuSYfd0wKprIr6X9s3yQXNxG5WKPybkA1Fe+8laO2zH1vNyGxwHqdsnaa4PbdozHDTj9UcR/ZV7Jd9645DD1TA9JD6tO8/0DPW5b6yPNV5AQmCUmWfznTlA+2VEvflmwYqJO6y+iV9+sEAW0A3yUT5Boas1BAMh9A4HK33OYyWM3zS799qzwfV3VQ4G1sggs3uJ0PpDsd52UF4H6fEtFIkuCRVbUfCUk384XMZKtRmAY40YyTa/fRHfMGScPK0hd3574GMgTr8PLOwzZ0qMMrsePCFkmzJK4lZ1DTtxUgg+qOnWnIOe4GPzs8VWKZ935nt87EngxN5P59WJEeP6oe0gNRnJ82O+fm/z+hqTxvCQ0ySl7rH7mRRNys29yvrdSTv66VhJWUWg7LJJE2hTMczGneAIIg6D5FDWscjT+SyzojbxcX6EFcD3V/YO76KsvOWDZG0hPEtvlO/PLl0VW8PdRm0JEtN7kqhgnROkyTQabKi7VOi3UvDBroHJ61eTlC8V8iekJ9QxFu80TMP8d3CaLY6Ue/9n2JvJ7fUF0AO6L7tbrMmo7Sj5HwSx3danLeoGoDmf/90m0vV2lkr9f3J6X+wcvLRAHQT0jpeFvTRYsA9z19oOCMmfgNV3yDndPRdEfxvhHgkcDKme0cmR2VCBX8wwu2PGO5xoAIUGAwqlqvBpviptVn89B9kfc4P5BWnYEsjym/
 /S5sKZJk
 zYPwWDpbcGmrsrRGs4gkt9SJsjZD0joZxO7XTmEwTac6SDkOE6Er5+7P7V+A9xGzTBazRQaNx1NcYI+Hc19T66g6UaNfmbBh9Tvw6uFWzosRxA01F2LXEP5Cn6sUyGUkE1OQbJWJoncYXJg8MvuQWTb5Dt7oY3gN78M+Yv9rWWgS3/PiPgmDXkiDyEXTCovlOhU9sLCc/k6zUgw7rLKxo52YKEfhV8hPOCgWB/H4kXLJnmCWOJWYZm1nnBYAzlDJLRn2e52Hn9vZZtE/szlXIO9JtfOJ8zU7R0tHWTqDpK+VNtID7df2O0nC2BinCseiCKjFc+sSSgnvRFFT1OD3ne55V9IGzeqCBSM8iZIMRwCEgwv2wvF5fKnw1kIUP3UmsLquwtREs0UYFrCvi0MbnmJyVzDXEZuQOD/vN4RQHQU3+ayXnsTb2aksNeGjvmB9b1yKC5HcUUnYYDGvY5ECTrb6YTS0N37VAGCwZ9DO8DQR7S0XOtKDRvituDSIYVyhPvdnh1wNq3Mf5P//MY4+fCuoMgTUsOwJAMh3D2JDzLjFlEw36qtttZwPwuog1wUuQ1/7R
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/13/26 02:27, Andrew Morton wrote:

> On Thu, 12 Nov 2026 19:01:58 +0200 Mika Penttilä <mpenttil@redhat.com> wrote:
>
>> On 11/12/26 18:47, Jason Gunthorpe wrote:
>>> On Thu, Nov 12, 2026 at 04:24:05PM +0000, Alexandru Elisei wrote:
>>>> Hi Mika,
>>>>
>>>> On Thu, Nov 12, 2026 at 04:00:09PM +0200, Mika Penttilä wrote:
>>>>> Hi Alexandru!
>>>>>
>>>>> On 11/12/26 13:56, Alexandru Elisei wrote:
>>>>>> Hi Mika,
>>>>>>
>>>>>> I want to help getting this series merged, and I've been familiarizing myself
>>>>>> with hmm and device migration, please bare with me if the questions I'm asking
>>>>>> are obvious or downright silly.
>>>>> Thanks for the interest and willing to help! I am preparing a v18 of the
>>>>> series and plan to post it early next week.
>>>> The series is big, and as far as I can tell the MM people are hard at work
>>>> reviewing bug fixes. It might be better to wait a while, to give people a
>>>> chance to have a look? I know that if I see a series being reposted often,
>>>> I am less inclined to review the patches since probably a new iteration
>>>> will be posted soon. But I can only speak for myself, you know best.
>>> It is at v17 and it is still getting high severity sashiko errors
>> v14 was first that sashiko managed to review. There was a regression in
>> last posting, but also false potsitives, and sashiko reports same issue
>> then 3-4 times, so the reality is not that bad. 
> Pining for the days when all we had to deal with was checkpatch.  

Yeah.. running sashiko locally now. Interesting enough, refactoring the
series (end result being the same) made most of the "high errors" disappear.


> Mika, afaict the entire patchset is a performance optimization, yet you
> say "I don't have a benchmark showing a gain".

No not a performance optimization as is, in the latest cover I explain it:

"The main goal of this patchset is to provide a new feature,
migrate efficiently on fault, and not directly improve performance
of current migrate_vma_setup() (which is now routed thru
hmm_range_fault()) callers."

The "efficiently" is wrong word, I should say "in one walk".  In the
beginning of the cover, I explain the benefits of having one walk. Also,
I think it is sensible to have one implementation for it in HMM, instead
of each driver trying to do something similar.

We don't currently have in kernel the capability to do migrate on fault
in one walk, so I can't show a performance gain with a simple apples to
apples test.

Also :

"the selftests show that there is at least no regression for
current migrate_vma_setup() callers."

So the test is to show there is no regression still for current callers
(X86-64), not to show if there would be gains.

>
> Recipients look at patchsets wondering "why should I spend time on
> this", especially in these times.  It's best to answer this question
> right there in the first sentence of the [0/N].  That means numbers,
> and the better they are, the more attention the patchset will get.
>
>>  Documentation/mm/hmm.rst               |   45 +
>>  drivers/gpu/drm/nouveau/nouveau_dmem.c |  402 ++++++++-
>>  drivers/gpu/drm/nouveau/nouveau_dmem.h |   12 +
>>  drivers/gpu/drm/nouveau/nouveau_svm.c  |  155 ++--
>>  drivers/gpu/drm/nouveau/nouveau_svm.h  |    5 +
>>  include/linux/hmm.h                    |   51 +-
>>  include/linux/migrate.h                |   59 +-
>>  lib/test_hmm.c                         |  174 +++-
>>  lib/test_hmm_uapi.h                    |   21 +-
>>  mm/Kconfig                             |    1 +
>>  mm/hmm.c                               | 1075 ++++++++++++++++++++++--
>>  mm/migrate_device.c                    |  618 +++-----------
>>  tools/testing/selftests/mm/hmm-tests.c |   56 ++
>>  13 files changed, 1984 insertions(+), 690 deletions(-)
> also, yikes!

Yeah, the nouveau made the numbers bigger - but we have a real user!

--Mika



