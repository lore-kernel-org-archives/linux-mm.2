Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B3BCCD8C9D
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 14:08:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 386E86B0005; Mon,  8 Jun 2026 10:08:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 337D56B0088; Mon,  8 Jun 2026 10:08:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B12C6B008A; Mon,  8 Jun 2026 10:08:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0BE146B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 10:08:38 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C55CF1A0148
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 14:08:37 +0000 (UTC)
X-FDA: 84856925874.05.247CA76
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 56E0340004
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 14:08:35 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dJ2PxDlA;
	spf=pass (imf12.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780927715;
	b=Gsu4jFoOvoztQg1jn4xsGxIeSCFj+1yq3axBAMX8eod6KpTeS06s1aXpilhzozcm84rROp
	qND4cXKVbK6F9jRr+h8cUOiY8yikdu8jkg6bSKlqbnrqKDotwvArPc3kZ/eOQNgeni/3xx
	zmoxmRqKfUaxpV2Qsmq5nvx6okaP/n4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dJ2PxDlA;
	spf=pass (imf12.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780927715;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LB5rudO5SFykOh7GP1yRj9jRlO/AUIWutNzfIO1MaUA=;
	b=qn4TQ3E9EJia/mqrDhx6MtnwaOq/EpofJXZG/Cg9f+Lt/+3IXx4kgY23MUoSTQcipeQIdx
	Qf1dUwn/NuPgQrfPVbZbv2iD6uMv9W8AlxCz39DvA0nWibp4nuzD2hVtRzUoWkxpbzzmJE
	ZBTGrLGmwWCRAVa/IR+ua1n6QVRoByw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780927714;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LB5rudO5SFykOh7GP1yRj9jRlO/AUIWutNzfIO1MaUA=;
	b=dJ2PxDlAMrlEM5CtJER7hWxHdWZZuZeE5PLbeAFVbehhheeO7bwDWYCwY+0TYX9D4E9dBF
	eSan1FPv6gmFsOjgxo25XiKDLK5dlo6hNK4mnmMWEZANphDwCbeWtHwjyZj01MxzLwZ/ua
	k2w6834JzwKPeZoOH3GXvgagz4/2dRg=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-53-7LVSIBo5OhWBU5m7hnuR2Q-1; Mon, 08 Jun 2026 10:08:33 -0400
X-MC-Unique: 7LVSIBo5OhWBU5m7hnuR2Q-1
X-Mimecast-MFC-AGG-ID: 7LVSIBo5OhWBU5m7hnuR2Q_1780927712
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-46010392f89so4015236f8f.2
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 07:08:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780927712; x=1781532512;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LB5rudO5SFykOh7GP1yRj9jRlO/AUIWutNzfIO1MaUA=;
        b=evuqzp2TKDWxSd5urujwYmD6s3amz6uvLQUNT59PflDZPj8Pfewc/QLYdloUVUc17/
         2mCfZNqGlEZviTmHeT1i/aZ0uU11/Ci+LiLiADSqZ2/ehb3r93VmqyTjqXcT2Z35ypv8
         lA18KFgcGgHub5EdnUWqehNEXG3X6PHJVtwBI+Lg1Tvi+693VkV9/6qy0CDU3e0chYHx
         IsyFRRG5xtFYvStQpb/6GSZrXL+jWyZLBEV3kU1jEKFg6A0emNoxzLgram6yl0nUcBHm
         l+I6cPhtioSEzJs7bODZA1hzT30ZP70l7FzcL4QlCnjNZmh4NJkqVkNfi3gpTdHoon5n
         6T8g==
X-Forwarded-Encrypted: i=1; AFNElJ8E7voqrlqmYxUWVOXqkYnIIXnfNpHdlwFh+SQhEYjF9YjSHHJ13i2AIPadbVR8I1NTsxkXFeaqsw==@kvack.org
X-Gm-Message-State: AOJu0YwwgYQl2xpzzypj1HjszY0mSlrg1TXIilwXwNW954jG3lhSOr2S
	jCF0hBQUOjNuDZRK4kWf3K8QJOCAWSQlYAext7rwf3SBqs6GukztmppJr5uKUR9RE36P8pKjV9h
	hUZCR7QhsOOiKJMrykwX4CBfFvP3PNd2fsdE12UK6Mci2fBIzTxdX
X-Gm-Gg: Acq92OEvVUXcWmP5dMFEiJj8hW2XSifROv39Iq+lhMrTqmRwUP6TRV0WRRPk08Gf/XM
	nGxHId6emJrwjn2bMpkwtWQ9T3N0u1ePvACZ6CbmwIWhQOweg2nFdDMuvMHWkyJgY72am0GT9qV
	2yjSY4skl8qNvvWgGqXz1bJw/ZmFhu2K6GJk+C64qGqGtxbav4xQ5kui2d39MYnlJGJORKkd8Ar
	OFiWyF3eLy9m5uOHkYSWsknNf54EzIHwhmRG6HFXJxnGRrrraNGSLFlQZp7LcAO2V1UMVoyHfDT
	01PUoqvDM3Pjj2Kq4PRoGoopcnaXLvJ4NzdqglKRodCecFrpTR3oABPShHBUxGG95PXE0i6VH+T
	PzlkL1MeG/x7XGztapLSiA6s=
X-Received: by 2002:a05:600c:4e04:b0:490:cc1b:15c7 with SMTP id 5b1f17b1804b1-490cc1b1631mr114019775e9.30.1780927711870;
        Mon, 08 Jun 2026 07:08:31 -0700 (PDT)
X-Received: by 2002:a05:600c:4e04:b0:490:cc1b:15c7 with SMTP id 5b1f17b1804b1-490cc1b1631mr114017635e9.30.1780927710559;
        Mon, 08 Jun 2026 07:08:30 -0700 (PDT)
Received: from redhat.com ([185.16.164.67])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490bc3cc0f8sm396828465e9.8.2026.06.08.07.08.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 07:08:30 -0700 (PDT)
Date: Mon, 8 Jun 2026 10:08:25 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, linux-kernel@vger.kernel.org,
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
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
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
Subject: Re: [PATCH v10 24/37] mm: add put_page_zeroed and folio_put_zeroed
Message-ID: <20260608100602-mutt-send-email-mst@kernel.org>
References: <cover.1780906288.git.mst@redhat.com>
 <fef7ca7bbf591865defef658b0792b58494aaed5.1780906288.git.mst@redhat.com>
 <aiazXE8pUDeCmP7c@lucifer>
 <8ec82477-b497-466c-902b-82e108ae2b7b@kernel.org>
MIME-Version: 1.0
In-Reply-To: <8ec82477-b497-466c-902b-82e108ae2b7b@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: dYoLFSup4LLWW8TIzokGO7Q3ugagq7N2tvfxfB-cTUU_1780927712
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 56E0340004
X-Stat-Signature: pa58y4jkbtbshtsehs4i6ybii5ayx193
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780927715-50688
X-HE-Meta: U2FsdGVkX1+Sz8UfAJ5eXTicvwOiRwisZWBcxtt5KEI4mkd889kiZn0uh+Lk2VUmXepzX955USl99lZgPLIMvdBrufCaDMubL8EBCpWwXZv3I8lgy9ifKTOPdOqQYJKzhsCzXwYSZjGw4zzzLHHbRh+TWorWNSMPXGWzML/SZ2ab5fYO26V+ZuBgeIltBr5Gfr7ZvT3y1yTG6fsifmJv9xAQ4A8fc+qu6D4LnC7Rhei9PkxcydAD3oQYI35KicdmsK7iafBMk0KadITEziyAWJL1rYUCcRV9rWV0evmlqCadKLlx+u0HtN5YNX2sRKjgXuVEbdT1dR6TMZPS0VL6+u7zallAaHnivRH2NjKDDgnzdrqEc4meM+/+qQh+Xx2f7efsYpGCHQDtVaMVo5GP8iaXSlkx1GrsZiSsGEOzcb8nfFLZpjUmZOPYETAjE5w+ONHsN4KXLrfqJoFS50/NbSOigfARTkdJYXXlgcUR0ktkUCuwA+5UvmN18zAUaOOqlqxnOJSjGCbsg+1DY1KzleazBAvEZSSGWPrQ1UeMDAGMQRyXh5LRK4yMu/EMkEVdjdUKkW44TXsMxC5m6n1LKdgd+GNx16eZeAPe1bOuMyBopjsdchBJKjZtjwik5sARIAAczk7+D7bglGIcFWTCmCycRLOG8wYySqTn4HCNjDGSU74/lnZl+uCO+SZR+ffhY3QDoA6ZGFSp7VIcvjNcXWYf84zUwppn5Dqgns4gFr3rF/bNkvDtqngA+TybIm0rcU+mJyhghqV493q949SwHEdGD0D6NwJy4gSND/M1uoXutXcTC5DB3rlWGAVlLAmszRnLHxqfgKeCvQlIvLhB6MU6TCmMltzcFah3ooQtHxVlT8DIUXeg+qKnlPEC4PNAUm6uR8304cuBSyeT+rodw75G/ZRWwVUvbEf/gS8JJTD1Wdqz0T0b+5pQzAyv1F3gwbxUgIsT3CBga9hqJvI
 3sFRpBg8
 +hm5p5UcD64/nsU6yoLHmRdvd5ea1c0iXM3pwpUorKk4cVMmqJ6UanQ4yGBChDCLbifMC4xJX4esCffjkz2iYaa7arQwzP4KOg83ej9XbAR5I/EyUYcWFgO1s9qC1+vwPeWWYin94yOXv08dM/w0Y02McE3mi/bh4f9xSxJU1guQgiCQKk9G3X9ZkORs2dXGnj+6BL2H1eYSd2WQDv1CMApO0xNrbi7/LiqBlVQ3ZUdYCjuS93IVJCDl7fesvmfxMDBPbNMx19+4vmDsjpDSUP0xCj0yz9zxc8E4sNlKzhh8jREbvbtsuCL3ypaA1ftAYtJv056uhTGP9HU4MakCg1CAnbzRPHKWjOpa8BR2nsoF2h67hYXIO/UE1+CpPCGgG7QqHWR4kxhVeNPboZ5LJBKyP+jM3kc0eNJ/XFsjYDs1mvexxVOIaJRtqn/yBzedmjBIPj76t4agJz4aA6gteH/XzsfFzACn8r96Vs5CUUa+aqE0UO9w2pzNLMg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 02:46:34PM +0200, David Hildenbrand (Arm) wrote:
> On 6/8/26 14:25, Lorenzo Stoakes wrote:
> > On Mon, Jun 08, 2026 at 04:38:54AM -0400, Michael S. Tsirkin wrote:
> >> Add put_page_zeroed() / folio_put_zeroed() for callers that hold
> >> a reference to a page known to be zeroed.
> >>
> >> If this drops the last reference, the zeroed hint is
> >> propagated to the buddy allocator.  If someone else still holds a
> >> reference, the hint is simply lost - this is best-effort.
> >>
> >> This is useful for balloon drivers during deflation: the host
> >> has already zeroed the pages, and the balloon is typically the
> >> sole owner.  But if the page happens to be shared, silently
> >> dropping the hint is safe and avoids the need for callers to
> >> check the refcount.
> >>
> >> Note: put_page_zeroed uses folio_put_testzero() which only
> >> detects sole ownership at the instant of the atomic decrement.
> >> A concurrent reference holder (e.g. migration) means the hint
> >> is silently lost. This is by design: the zeroed hint is a
> >> performance optimization, not a correctness requirement.
> >> Losing it just means the next allocation re-zeroes the page.
> > 
> > Do not put comments about specific expected races like this in the commit
> > message but not in the code. Subtleties need to be called out.
> > 
> > The commit message also doesn't at all explain why PG_zeroed doesn't
> > suffice here.
> > 
> >>
> >> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> >> Assisted-by: Claude:claude-opus-4-6
> > 
> > I really don't understand why you have a 'zeroed' folio flag but need to
> > also have new API calls to detect that?
> > 
> > They're also HORRIBLY named. Zeroed as in what? Zero page? Huge zero page?
> > Memory zeroed by kernel? Pages that userland happen to have zeroed? Or host
> > VM zeroed?
> > 
> > Each are cases we address individually and relate to folios.
> > 
> > You absolutely fail to clarify _which one_ you mean, and provide absolutely
> > no documentation and add an exported mm API with no description.
> > 
> > This is just I think not something we want to add? Especially on something
> > so fundamental?
> 
> I raised previously that providing a folio helper is odd, and that I suggested
> that we defer this change.

Sadly it's a dependency actually - without it memcg failures would cause
repeated re-zeroing where previously it failed without zeroing.

It's the result of the whole GFP_ZERO idea.



> Maybe we'd want to add such an interface for frozen pages later (to be used by
> the balloon), but I don't think we want that for folios.
> 
> [1] https://lore.kernel.org/all/5f76af6e-9818-42ea-a305-c0fc1d920dca@kernel.org/
> 
> -- 
> Cheers,
> 
> David


