Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C4BECD8CA7
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 21:05:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECDB16B0005; Mon,  8 Jun 2026 17:05:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA4D36B0088; Mon,  8 Jun 2026 17:05:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBAB66B008A; Mon,  8 Jun 2026 17:05:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CC5166B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 17:05:00 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 866A1A02E6
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 21:05:00 +0000 (UTC)
X-FDA: 84857975160.03.D8BE63B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0229040005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 21:04:57 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="i20g3p/I";
	spf=pass (imf17.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780952698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CG7TX63y8ii7nF3o7st9M+h9AET+tnVYkN3+ZIy7R/k=;
	b=ocBxcyM+C1aif3zlLGxgj+e6jeI5VFZT6EvGrrJVaP6TXrcEFjCZbjCKSXlMmCRuzX4+T1
	zyN7Dpyf+Hm5hwzrnO+eGVfcsDwUemnmJUSthk7y7J0BQ+hFg0+MM+1HK4dkf4kvDe76OG
	aCMfR/xzE2ogYw/0GVnHBJ1wzJBksRg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780952698;
	b=QiNf68ypgcmKQ3CPjvko1Vc+gQd0KbCaxR3bwJIb7+UuYTaOxKpGvfsUiDJvwmZaRwXRXs
	AnDEZeFE4mKgdJNxNmjSVigYUH9U9B/KMHmf6XnSKpjVDDDKBSJHfYEkJ8K+4BSFni+Zfs
	9AJQtx4jW+II1Kwo37EpUsFX2Aab0yk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="i20g3p/I";
	spf=pass (imf17.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780952697;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CG7TX63y8ii7nF3o7st9M+h9AET+tnVYkN3+ZIy7R/k=;
	b=i20g3p/IoZTtiSpbfL7COtgsDcg3fw7/XCAy2eeGd9TkzRcurzwksnNj1ui9rVKFMf+llJ
	cprw9f4uYwdNLyIXH3EYX6GkwkA7d6GQvWNaV9pDH7mYgCjgELuBp1XXNW2F6xT9jkKzO+
	ot4dWX+M9eXvd2IpLzhBCcElzUHC4sE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-177-FrlQ8kNiOdmpItg97phXng-1; Mon, 08 Jun 2026 17:04:56 -0400
X-MC-Unique: FrlQ8kNiOdmpItg97phXng-1
X-Mimecast-MFC-AGG-ID: FrlQ8kNiOdmpItg97phXng_1780952695
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-45ef616db45so3821580f8f.2
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 14:04:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780952695; x=1781557495;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CG7TX63y8ii7nF3o7st9M+h9AET+tnVYkN3+ZIy7R/k=;
        b=Dv8dnj5k7+3di32C/+8MG/dF71AzGnWHHTCYzOx95QK5jKwo6T2WwNxnVtSeXZv4Lz
         GwZJJA3z8PBC/lO1OHARX1G/oE7FMjYE7WyRRPfE2l4dR3cgXK8rBhLNtmYnk14H7Wnc
         MP0mG95E8jTydH5gKUvLQ4TrdFl1YOB3jBf7Q8T79g80l+NbT/t2fpNGst8vG1Uy4N4U
         dw93lIkDrOUONO6Eg1u8pyribqepovZRa/3GsXs5KhK9tCMD5cv80oTT1WCsZX6aadJ1
         2+3hPOVttFk9gtIThFqra4lo2xCwfvAXL2JSA1zcPiotL1Djz9czOHQQi/u5iP4uVIX0
         5kcg==
X-Forwarded-Encrypted: i=1; AFNElJ8wAyjMi0yqbhvZQ5gUSY2v4jDoKjFp/wF4NumG6zrFbFcESpPVNqzUHWIywa7RrTyysGYh3vVljg==@kvack.org
X-Gm-Message-State: AOJu0Yxz1HybY3cujsE8ryMZTZduVy45rFe5Da8ZHv/sIsQ7DICSwnGL
	YQY+J/TbJK9z+sqa8vLuZsQamRd1HhMmOHR30nXNI97LRAlWnPKiOXEQRR9hig4bcMoB2MT7nqf
	5D2N73QJDDetfSZJXRCL1MHI3UjWdqBfrTClb396E/akPdEPfj6B5
X-Gm-Gg: Acq92OFJl5kHKQrYpQjQG4oJHZxrZP6YvEctmAdSHuJ+vFuBZm153XiJZinX9EgWFFR
	OtZ1ZuNEI6xL7zKRN9ZV/Qc/0zr+lSzqDWPv2ZCgUfMTe70wUHFUmjPLupxtZu5bpkvmmsO8YcG
	Wel1q3UAnN/EIkIAmT8W2Af9ubPheUmqifek/FzwboKgPbba1xxEeT70toNq0A1kvGCDuaOkPjs
	ca/BtombcDBgBJalODwGQXrmQKhm6/r4hCqrCE5KA9PwC5JrPGHNRD+iteHTKmo0Bep8nB9ehHv
	6PJdb7/9QzsuGlHloxmeTfBMC+VJ0dhaNakZDq03HvlAL/gUmjTNn8zvoPIk28XApdk6L6/Gntx
	9NDBezD84dY01OiH1Pik4E6H+B8ekXPzBgvKWU86ARGibJf6SzhhvwA==
X-Received: by 2002:a05:6000:46cd:b0:460:1492:4f0d with SMTP id ffacd0b85a97d-4603063c591mr17367259f8f.34.1780952694642;
        Mon, 08 Jun 2026 14:04:54 -0700 (PDT)
X-Received: by 2002:a05:6000:46cd:b0:460:1492:4f0d with SMTP id ffacd0b85a97d-4603063c591mr17367215f8f.34.1780952694170;
        Mon, 08 Jun 2026 14:04:54 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-85-71.inter.net.il. [80.230.85.71])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f351ac0sm100416244f8f.27.2026.06.08.14.04.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 14:04:53 -0700 (PDT)
Date: Mon, 8 Jun 2026 17:04:48 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Zi Yan <ziy@nvidia.com>
Cc: Gregory Price <gourry@gourry.net>, Matthew Wilcox <willy@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>, linux-kernel@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	virtualization@lists.linux.dev, linux-mm@kvack.org,
	Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v10 07/37] mm: thread user_addr through page allocator
 for cache-friendly zeroing
Message-ID: <20260608170348-mutt-send-email-mst@kernel.org>
References: <cover.1780906288.git.mst@redhat.com>
 <50d410b47fe3f45327783e05bd306d5eaab75e65.1780906288.git.mst@redhat.com>
 <aiaUDTeHDA45ZXFS@lucifer>
 <aiagMc9Ng_AE_adh@lucifer>
 <aia93IzhTgi1vGi6@casper.infradead.org>
 <aicfERTP3H6AndOs@gourry-fedora-PF4VCD3F>
 <D1CF67EF-2CF1-45F8-9265-70A528C1CB01@nvidia.com>
 <20260608163257-mutt-send-email-mst@kernel.org>
 <BD0C8760-BC10-4BF0-9EE3-9B0DAF0D977A@nvidia.com>
MIME-Version: 1.0
In-Reply-To: <BD0C8760-BC10-4BF0-9EE3-9B0DAF0D977A@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: WCZHXbsCKz0nooowUg3JWRSY-ssY8ms0xO5K-ZOL1wE_1780952695
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0229040005
X-Stat-Signature: b8r5iidmq4k5mggw5rchjkoic4j871gt
X-HE-Tag: 1780952697-798265
X-HE-Meta: U2FsdGVkX19lg5Zb1fi+HSHNKtOJxZeUUhVt35LuvnzJnREX6ezIM/arsVPbxBZTvA5lpOeHy/LyL/g2NUgqNdzO4upLU4KwYmsTsLkm2YjtGvhJl/rLqA//gLILEeXuPMfJOY4Cxfb/bq3AA/fvfc7qqgMvuRtuv30fWZwbW0KaxICeclqv3cAFTWbySXj2U5Vhh8A9zJVCWc63GARxDIesC7U68BFfbarMnSf45nojSphf6YL+xHa08NKNx/48A0yYZFdR1v2eG/h5VOXZZh/5HHLNJinHWL93CBGOiinClqUT6VrfZjCc7WWcf3NXcIOVxuy4UZG2vZHS1JXQReTlcfDe0RBXN0chvcWO0JqXJgAMjlgT/+kAOiAW41OpxB+cnp+cSMbl6t/+owWBujGeIEzgfSrBMWWfyRqj8uqcG7UScpCBurI4z9we68ksnEzEzQcDfg4ZmsEaHjt4p7qqRvTnWzzXvIG1hePlAO+N81GxQtYyXYu+XOhpiCECe/IJOCGYf0hBH5R/1NbGe+QpHpLjwRKjVxKN45/IE+tsjzDpoKkIcIz8EC1b1e5vgozgk8TuqvrgnMp+VRZZ7/C44Cq1/rzcK7x4KkzcW64Gjad0Ghsw0VLh9duc6Lr0U59vivNqDj3ilwYlGFNNYwk7ZSS1PJUJL5NnbMG9yw6NZOoEhtP3AZDhd9/V8E8Xe2sUZ2i16XLGtaLj+m/6czSXAZnWfFJJ3N4xwwbqh9guCAi1o2XqYF3UnAGtlnSsYK694jumZPLFWlUK2k/8ZHNoZJqCksW68u87V6+qCljFnLvmnoybNHB64Se41o8k/mBHHMR6ygTv38kNUq3X6MXKwNhsaLvJlYn9A2NvNtR9WP4KrcCYrgp76FJx+/ENj5p/g82gNIZOARwU53j6nMdSNXYizXpkGGuKffyoqHU0dMln/L9jj/hWSmH6B8XlfklYgjYk9V5TRXFvqaz
 Bq8U+Rq6
 RwSSQmTsgfRV0SlmZSNahgvdyTFxvYL3dJbAgBNimbW8slAxaaA9RZa+s1/7kUYSybC4bSd199oagn9i1Kd68B6sNM5SGL8NeHMYYA5R6TET3BjtNuzM2iczoDeoTJy+X+tqvl2u8jayDT2sIMCI1BlsVghgd47vf63J1wYRHTpRe/8cCsRpU1I0/v5+QU/QHJdbtH1kze+NvLQ/X7D8PlMq/omS5+z64dYqPYMG70SV7hHkomOqWk4qmyUwgpY049SCggX4TjFD1FTXHF7phGumVphl7Src/mgs+CCzw1IN+PaEAYG7fb4EcNzVVlEARMQCQCrAQJ+0cti+IDxvGRY/ZVAVZd38ZrE0A18i6o9EKL5QTxpoVCc3+0aJJjuubvLKSJUsgZEOefEw0m3hgVx5CrFz06w/yxkSk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 04:40:15PM -0400, Zi Yan wrote:
> On 8 Jun 2026, at 16:33, Michael S. Tsirkin wrote:
> 
> > On Mon, Jun 08, 2026 at 04:21:08PM -0400, Zi Yan wrote:
> >> On 8 Jun 2026, at 15:59, Gregory Price wrote:
> >>
> >>> On Mon, Jun 08, 2026 at 02:04:28PM +0100, Matthew Wilcox wrote:
> >>>> On Mon, Jun 08, 2026 at 12:06:35PM +0100, Lorenzo Stoakes wrote:
> >>>>> But instead of overloading user_addr to indicate all kinds of things, instead
> >>>>> make life easier by actually breaking things out.
> >>>>>
> >>>>> Like:
> >>>>>
> >>>>> enum alloc_context_type {
> >>>>> 	KERNEL_ALLOCATION,
> >>>>> 	USER_MAPPED_ALLOCATION,
> >>>>> 	USER_UNMAPPED_ALLOCATION, // Maybe? Do we ever?
> >>>>> 	/* Perhaps some other states we want to encode? */
> >>>>> };
> >>>>>
> >>>>> struct alloc_context {
> >>>>> 	...
> >>>>>
> >>>>> 	enum alloc_context_type type;
> >>>>> 	unsigned long user_addr; // Only set if type == USER_ALLOCATION
> >>>>>
> >>>>> 	// Maybe something suggesting context or whether we init before in some
> >>>>> 	// cases?
> >>>>> };
> >>>>
> >>>> Ugh, please, no.  As I suggested last time I commented on this
> >>>> trainwreck of a series, lift the zeroing functionality from
> >>>> alloc_frozen_pages() into its callers.
> >>>
> >>> This sort of just implies writing the "alloc_frozen_zeroed_pages()"
> >>> wrapper that does the zeroing at the end before return, and then killing
> >>> the post hook nonsense associated with it in the first place.
> >>
> >> This means it is going to be a multi-step optimization. This is probably
> >> step 1.
> >>
> >>>
> >>> None of this resolves the user address annoyance which is needed on some
> >>> archs for cache flushing.  Whether anyone agrees that the page allocator
> >>> should be responsible for this particular operation - open debate.
> >>
> >> This is probably step 2. But does the virtio use case apply to these
> >> archs? Does the performance matter for them? If not, maybe this part can
> >> be left as a TODO.
> >>
> >>
> >> Best Regards,
> >> Yan, Zi
> >
> > I doubt it. But I don't get what's proposed, the code that we
> > have to modify is arch independent?
> 
> Change user_alloc_needs_zeroing() to only check address aliasing even
> if that can cause double zeroing for virtio.
> 
> Best Regards,
> Yan, Zi

Ah. I started with exactly that in v1/v2. It's a simple approach.

But mm maintainers said no, user_alloc_needs_zeroing is a hack and
I must not add to it.

-- 
MST


