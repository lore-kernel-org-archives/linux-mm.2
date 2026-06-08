Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77E4ECD6E79
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 19:46:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83D306B008A; Mon,  8 Jun 2026 15:46:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8144B6B008C; Mon,  8 Jun 2026 15:46:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DBB46B0092; Mon,  8 Jun 2026 15:46:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5A4BC6B008A
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 15:46:10 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 21E431C1B20
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 19:46:10 +0000 (UTC)
X-FDA: 84857776500.16.3341283
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf31.hostedemail.com (Postfix) with ESMTP id C1DCC20003
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 19:46:07 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FS5YNG4Q;
	spf=pass (imf31.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780947968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4XkshBTgN4Zv/gIvkBzsPSwBPTNRhn2JGaJhvMxMoi0=;
	b=QRoyF9DRl1Gn6NMS/S3xP49gjma+tkdJoh2rBaVCwc1tjyKvWgqNBn/BX7nQaB+JKcJnPN
	Xgq1Lioi3BkFUHwOJQMmNJZo4ZechmKT0YLPQZv2mrr86BFEWXexoeN3jJLQD6bfLp4fsg
	IAwg7AtuAYLGRtuhFdf5p8gUbLsf61E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780947968;
	b=WYTx7/xq3hT8zxlAzJHrcLl16apE4C/hbsRzyGhsUSd5g7r5hzIU3SMGrNug5Qoj5UMvQ+
	i7O+VrRkeTiC3Pj6D36DOF+h+HJhu7AeZ98DQBhOZK5wtQF6ikPLonn03rwD7LXfuBZQay
	ykgHs2IyGEgTF4oopTsxU78zjSP+2Cg=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FS5YNG4Q;
	spf=pass (imf31.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780947967;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4XkshBTgN4Zv/gIvkBzsPSwBPTNRhn2JGaJhvMxMoi0=;
	b=FS5YNG4Qzuw3CqdH6arVeFsPHaGB7GcowCDzkht35chflTX+gkcjieFFjaES+47cpBqC00
	iYUUlBuPUwTje/UWh76CG2joVF3fFmPRfkvpOlRwgonYSfWKnI2IUb/dB00M52Qx1/Ey7U
	MUOMf3lRNzmYkEOZqCv3P2vCXyzYxKc=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-35-Qpzkr4X9P8q2zmMhtoq9Lw-1; Mon, 08 Jun 2026 15:46:06 -0400
X-MC-Unique: Qpzkr4X9P8q2zmMhtoq9Lw-1
X-Mimecast-MFC-AGG-ID: Qpzkr4X9P8q2zmMhtoq9Lw_1780947965
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-490d3f03883so2495885e9.1
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 12:46:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780947965; x=1781552765;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4XkshBTgN4Zv/gIvkBzsPSwBPTNRhn2JGaJhvMxMoi0=;
        b=NegAcEBKjkUkEvI5p5Fk+sEgUGzRfCcFxmSXLktGKm/8F/6hoJUOP5qYb/d15TeXbL
         L9GNmfzffcZ6CybcNvtDWd/9fsAQJLuB14yfzXGOqngjW2Sz8KXaR+eCu3yscbn8FOHR
         78vqEQ4aNOWSLOhVnKYj58ONKwkt/VbIYK8KODMXPHKkeguZlSljXW/giheFrqiACBdE
         khCEqEPwhy/AiuI46A5tSdwcQRbrxEqoOBE9NAR1ffTS0vbyVVpsutd9jj9HXPT3qVfQ
         tid3xrCDt+XMjTQ4rIAH9nO0PMpKmUhjs8iwV1yFxKF+kpCNMbVOGUrp2NxwTQEylKsp
         ybJw==
X-Forwarded-Encrypted: i=1; AFNElJ/Dn+HPFJoLlYU8ut1k3cAuagWU0g9o6FMrCAPpLRxm9T2MLWQAN2qeHh1W9PCshJFq+XSlcDUirA==@kvack.org
X-Gm-Message-State: AOJu0YyuawGJoLQK5Yzw8UsYJMBnnccMhnYwpKzpizTrYIW70/SGE4Gl
	1xertt6UuCTOdn7aNtwQ6cUg7S3XdUGybyfoAxs3kXGte0VTFX2qs932kgx6yGOf6IrkGEWqL6y
	7JpDEm+GNbA5kEtINcuw9PvfbAvQv/oc7iNslVkw9FQNOMzXW0931
X-Gm-Gg: Acq92OGxI1AqaG2u7DG30KmOyEaaYQQP0nNZgwpXtfcI9lgnauLUFFGhnMrHD4QfGlE
	jBjYCG0V2EshXTXNnwrji321xGECtCnDidoxAxkCiZ1IpJWTy3NB9rxHJWnIFRcZCu614fdFpQ6
	m28KBBRG2/m09UQt1eeQ+MObMeHqKO9VaxOSzsvBp7kG8v42vJXqmlqFUFic+AsllgmpkT82DYa
	FJAKujA1OTA+D9fzGVJd53vEEFvfAV3m+FmqpA7k/kVqC/i69TpS+XhVs6Pq4QRfpmAAqI00i4P
	KQGJwT3aE6cCK7bU8YZ4Fj+IOeNPiZyh61qa5kxIKoNuz0LvD93EgYGmWFsLm1gejjkVe5c2n1O
	1MCq4yx1FrSwG+7nj7yQ6ookR7ZQy6t5g0Bv+U1klXm9Bp1GprCEXoQ==
X-Received: by 2002:a05:600c:468c:b0:490:469c:556b with SMTP id 5b1f17b1804b1-490c257c3c8mr290867745e9.12.1780947964643;
        Mon, 08 Jun 2026 12:46:04 -0700 (PDT)
X-Received: by 2002:a05:600c:468c:b0:490:469c:556b with SMTP id 5b1f17b1804b1-490c257c3c8mr290867255e9.12.1780947963943;
        Mon, 08 Jun 2026 12:46:03 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-85-71.inter.net.il. [80.230.85.71])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490bc3d663csm465687715e9.11.2026.06.08.12.45.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 12:46:03 -0700 (PDT)
Date: Mon, 8 Jun 2026 15:45:58 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Price <gourry@gourry.net>
Cc: Lorenzo Stoakes <ljs@kernel.org>, linux-kernel@vger.kernel.org,
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
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
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
Subject: Re: [PATCH v10 12/37] mm: use folio_zero_user for user pages in
 post_alloc_hook
Message-ID: <20260608154354-mutt-send-email-mst@kernel.org>
References: <cover.1780906288.git.mst@redhat.com>
 <f92f6f06e5804b4ea7f68b8664b7e69953b50f4e.1780906288.git.mst@redhat.com>
 <aiacZ6_7SG3nvVjM@lucifer>
 <aiblhJv_BvMn_8XY@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
In-Reply-To: <aiblhJv_BvMn_8XY@gourry-fedora-PF4VCD3F>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 1_7nWabrercSRmIroXHOt7KcwibiNYPugNrgaDTt_Wo_1780947965
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C1DCC20003
X-Stat-Signature: n91a5iifba8de4ataxikcq85fp988ozx
X-HE-Tag: 1780947967-759083
X-HE-Meta: U2FsdGVkX1+qPrabjtlv5cNgiHr7lGJeNQ/rUywpX/lMPcGmaVRnGqF5M7EGbAJQsdrct2bQMhzSQY9Tl1nY1y21mA7Lb5fNEBWkkkRNsH8RTxne97FaB28eXMK1XPGjmZjy4yUh/rb+k0hhOn6ThhLyjxuPqB1fQzOIO72dSn2gxCJG9nq4qwM9p7BwIvqfcPJmXFGDCjigpYsqSIKBJq3gccHzCX/puOkLdY9AJ9caqAgku2sz5sCpuAgrScGzGf5Nyfnpn2gvWT9EU3nveg893PAzEHEJ9OG2ZwLo+pkuWStrTdntpwpp2tvESU/yXpNMBkYqfHM/oRJFJcl4pMLH3t6xvDgWV0zbs/06GlqCo6oWLnxsjvmiHYRPSMq55n2TFUAHrFK7CW+F++l5nnx6o5yvLYjEVWtf6A9d/hLS2E98Jyuanpk66HpGRRREyNsM5ljWEcd+2Gc065AVGSFrJh4NF+oUU8YM59dhe/oqq/DHV8jdZEIAn2J/CiAGU8NN1VUPiIxm6QAu9FZcFNKx+Uj1yWWF6/SRo40eQAymxssYTmzZN4+WTr+UTxfwAwJbz4ILIi4JpQAq/itdGiurMGV3Maf6Mq1AR5YBFZQ33gmUjKsxq4/FHE4YxbGOmBraAmIcQXO4dGYkFrCHADR7pk5nrPraPE/Azq4TYn64D6uOC14CQqLdZIumG1Ay/JdKUu7jnu1vzbP4kARpWZvkP/5r8exTncuNLrBBBjekUuOi+/A4PDR5z7UbLe6m2G0EkSSeyFXDe/cTHab0vH9kf8OOytVm3KxSTZNnk0DYtP+Or0758r6z2nNsSqZHh2s/7rP9DGFoW0goMBIhEk9SDnK/VrEfC/ALdbYlDgL2YvK55uhZToNCL2zC4p5KMDac17zDIK9bpc0U5wEQrUzYWsflF72X/nGapkCvTtzxOo9ZDq6yriGnA0aFNCWNQxAiU3Li91f2PEL1+4v
 n0Bdlu8o
 r9UxYABdCmP8R9Aq2q99CqDkO++IvaOFqRFml5lC8waUy+8Ml5sWUciMvpgsCM1UMcwiLEVVyEJdCogNLEhhxeNvfQVW9LzZDX398bocHgUHYXwNFlTaEeRS5Fg5wTca+7OGPTP89Dtz7BPjmZYWfgMur70Q6BHb5QTdR1N6bz98SRIHCAFJn3Ap8lGSKAVlIIE2Z8UtFZgy5d5SdJTpp2fXpDGsG7Sx7oJqyjGWqt63/Xr1ixUB2/jPjNwd7oR5qRz96ZMN9/lr1ZoB1gAr5pMZ2mo7au+0CfSpFIkprM71cyRkr3znn92DphHiN32cu7WrcEiR3dpLc2uje/VdXYT3NHP8/bF9S0NUnLzX45mbweoa984RaJP1LO2IrgV8ip0h6kPHVEsbLRS1TxhdfXOdK5IQZThfpfqv3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 11:53:40AM -0400, Gregory Price wrote:
> On Mon, Jun 08, 2026 at 12:23:07PM +0100, Lorenzo Stoakes wrote:
> > On Mon, Jun 08, 2026 at 04:36:38AM -0400, Michael S. Tsirkin wrote:
> > 
> > > +			 * user_addr != USER_ADDR_NONE implies sleepable
> > > +			 * context (user page fault).
> > 
> > Can you safely assume that? Also inferring which context we are in from this
> > parameter seems risky.
> > 
> > It seems to me that you're now making it such that kernel developers:
> > 
> > - Have to know when and when not to specify a user address, and under what
> >   circumstances we might consider that to be mapped.
> > 
> > - Need to know to do this correctly for aliasing architectures or have silent
> >   correctness issues.
> > 
> > - Need to take context into account when specifying this.
> > 
> > We definitely need to find a simpler way to do this!
> >
> 
> This feedback was poked at in earlier versions.  There's a tension
> between keeping the old interface as-is, having explicit interfaces
> for something like this, and the state of a page inside the
> allocator vs outside.
> 
> Double-plus complicated by the fact that we're trying to reason about
> two allocators at once:  host and guest.
> 
> It seems it has gotten a bit more complicated since then (I missed this
> "sleepable context" bit, not sure if it was there on prior versions).
> 
> If `user_addr` is now implying anything other than exactly: "This needs
> to be zeroed / caches flushed", then this is bad.
> 
> ~Gregory

Well if you do folio_zero_user in a non sleepable context then things
are not going to work. So combining e.g. GFP_ATOMIC and GFP_ZERO and
user_addr all together is not a good idea.

You are saying it's bad? It's pretty fundamental to the idea of moving
zeroing into the allocator, I feel.

-- 
MST


