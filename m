Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9047BCD37BE
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 02:50:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 028FC6B008A; Mon, 11 May 2026 22:50:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1BB16B008C; Mon, 11 May 2026 22:50:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE3B66B0092; Mon, 11 May 2026 22:50:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C6C146B008A
	for <linux-mm@kvack.org>; Mon, 11 May 2026 22:50:54 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 60DB61C0224
	for <linux-mm@kvack.org>; Tue, 12 May 2026 02:50:54 +0000 (UTC)
X-FDA: 84757240428.07.BC6FE16
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	by imf10.hostedemail.com (Postfix) with ESMTP id 78E4FC000B
	for <linux-mm@kvack.org>; Tue, 12 May 2026 02:50:52 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="oD2/ZUlW";
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.175 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778554252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SkMrOM/wJbu6CYfcf0w3cGY5A4GXI3y3nMw7LLmua6c=;
	b=rvKZjLkABFLbqzfBbg5xl0B9y113SE+S4h/JIPx7J0PolBSwpPiOayAa0bnDdeq3Puhqy3
	gm0r0lDaJnI6msEhTfVImZSEsIN13CCHg+VnXWIuRpUxz/96Dv+A+oYGv+aaW6UJYpUqAq
	dyjX7D0k+1fAWWnzFMzyLcwUXhvRsy8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="oD2/ZUlW";
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.175 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778554252; a=rsa-sha256;
	cv=none;
	b=polqw2EdmT4TmYC2eOGLakubuMJ6+achUiyzI8HLb44z34uDAyjReAKdhQa37kEvBO/xAC
	Be6bqap1BNRN0d3TFEEQ6IU84ejEne9YtKKDfPsLerkzhNvZcnhDqRscYd1JJhG0Cu23uo
	EVR7zwcFVdk9GOXr6iWR3pLG3XwiNfQ=
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-8f15e900586so256761385a.1
        for <linux-mm@kvack.org>; Mon, 11 May 2026 19:50:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1778554251; x=1779159051; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SkMrOM/wJbu6CYfcf0w3cGY5A4GXI3y3nMw7LLmua6c=;
        b=oD2/ZUlW+TjQNWeduSD/vLRaO6d/ANCIjhvQnyPkhl7/Nnqd/NPONfNcnL7bl92fzr
         /nX4xuz3kS9JJ7eHnO3RBGBpwk3OsHeYfvy+CirsveTW/mQ+37oPielBf8/iILSN/34Z
         TfntZXI7NghmefEKf/YvP7N9AQSfy6nBMGLwArQYmMieHpyYsQoAMj9YlZMm3+OVDV6S
         rxK8zWjlwWG7Ax6s5415z258QXaS4NViSkOy8LtsjjKFOL9yVbmzccNw/sekVm0Y+Cvg
         SArJC8zbv9ZgojcnceHCZ3MdImNcVmQVBMHy+Vh1UWHVDD3TXjIcvRLcg2qYO/yul1dM
         p2cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778554251; x=1779159051;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SkMrOM/wJbu6CYfcf0w3cGY5A4GXI3y3nMw7LLmua6c=;
        b=oAMuaGKOksDVdoP1zyNTjculdK1WGfgTOXfmsP44u3zEh98a3C4yvau7GgJAxkR8c0
         VNS3/fwBf8YKePghjbb796oWLkmog22zMSGtjCydU2v+Angy4s0pdJsC9Eml79jyS96y
         OEA9DKVZOs1eYB2MKD4tD2KQNVYAdtQs2OL9MBqrf8nJMrx6iQ+BRelri6Xevqlq3cCv
         DM/MSr9lPBfjinkuolbQ1TOQu29jmX2v51DBF+/U3OhSB7d2PqXRPeEXXTFrJF5Ji2Pr
         9zydGb1pCPUngkautXI7VXm+FARaZp4rtPOvhYFzefUGT0WJ7O49lstkTtPAKGnVhroo
         3Luw==
X-Forwarded-Encrypted: i=1; AFNElJ9bNCPD2QjPFtyQh/kOYTrKTfb2esR2F1+xxDKfAqkJRDximqOShSfC/nnjYhdDR4v7tldF9IYp6Q==@kvack.org
X-Gm-Message-State: AOJu0Ywc8CRVdHEofq+NEfc0WGxsBZS8x3QsVwixhDIW0SW1/RTi6aDL
	gRJGOeuW02BHsFpFMu07eKcX1/p4NKqkuhgFw05Te7XOL0Dg6BvdqkjDPJ/aToVG59U=
X-Gm-Gg: Acq92OE6k7ogZdhJaFYjurOdY/xlAepDgjw0AyVZlRGE8rj8i+PDhvOQVUtfuXpmzrp
	/SnYgGl+uZ+pzrEDoe3UXLGvJXjJZ0qKUyfDLuKf68pI8wqQIqrjWgbQ00uITL9shT/RYqaqklZ
	jKeCNj6Dx8uDe7gdEk958RUy4eSMtnEVg+QucHSc1T7gDVjVdPELhxElOkGYHT7bcSqpjF03COU
	1EQo8aG8PcXX5DY72Ju2EVATpbrNZsu5CY2Qgv/Mz03C1rk21ZLxMXKWGRsCUqsjiTGqTSL/lGY
	20sxmE39R6Vq+b10uPmPlmQOrng82dlRj5afzDKiKwH7So+UqiVmtO4djsp+DETGkMtfHmAzrAH
	fqQGVj6M1QL+RJi1Vv6Yz7i77QDlcMJ2VW0hqSrvhDL9iW6G2we9EcYGtGwgJ2sfSFgnWsIxb7R
	urrBJ3OjzhNkUSbsazSh7acJ8F5BRNJKjCYT0TlZDLgXfTObVBIN8H/ihCblD3YlAtCLmJ5kuFi
	hcgQF8nL0HU
X-Received: by 2002:a05:620a:44c7:b0:8cd:b61f:2f48 with SMTP id af79cd13be357-904d64ea04amr4159360985a.42.1778554251519;
        Mon, 11 May 2026 19:50:51 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-100-36-248-188.washdc.fios.verizon.net. [100.36.248.188])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-907b9772b87sm1195078585a.5.2026.05.11.19.50.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 19:50:51 -0700 (PDT)
Date: Mon, 11 May 2026 22:50:48 -0400
From: Gregory Price <gourry@gourry.net>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
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
	Andrea Arcangeli <aarcange@redhat.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>
Subject: Re: [PATCH resend v6 03/30] mm: thread user_addr through page
 allocator for cache-friendly zeroing
Message-ID: <agKViOG_YQci0ffN@gourry-fedora-PF4VCD3F>
References: <cover.1778489843.git.mst@redhat.com>
 <9b53972f4854c1064b92cefc464f51949afeb83f.1778489843.git.mst@redhat.com>
 <agH3wceKcPNmixCj@gourry-fedora-PF4VCD3F>
 <20260511114853-mutt-send-email-mst@kernel.org>
 <agIJOkLhTOsvJs1-@gourry-fedora-PF4VCD3F>
 <20260511175032-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511175032-mutt-send-email-mst@kernel.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 78E4FC000B
X-Rspam-User: 
X-Stat-Signature: na4476qmuhzhri69qxezbtqgnkiyfjyn
X-HE-Tag: 1778554252-619656
X-HE-Meta: U2FsdGVkX19YiMdt0S2Y/B2R4WRxR5eOl9P1Qc9B/yi6jfCuB7O8+/9ELcWWFqSTsp0QbKDrd67fbI4nikwA72GZeq5jKBlVpOTLn+/G72P6zQrVrfGFfBWD6W6YXvoU3pJJXlmA2uKAeM3KASpf3tS25QDgzkYguGJqhgLwZq5HsU9Ec00j8lQJLLO6i6stFm5FXs4Ndx3MDWAyNsggeH8Pm7zAXQyoqoehC/kVlmURVKc9fhrmPviSV/aA7Mhml2l4ZotjMn2VzVKPRaxdehMN852Cir32N29e5UyhLbqoygJ9jO4Tjbq0puzmiRXnkFyhbAp4OFNxKpPAw5Ab/uNXHzCO5ulPeV7ndBCfk4VsvGR0JFO666qRZiUqJuuZLSd/vIqXJzWhqdOF7aM2HLly4ZLOBJWyuBkNnlBRjdOH0vT855luOnRvZL2/3BtPv7T+CA5OhlKpCSgSdpCl0Ep4AgF1yrDlH0KaoBAYCb/e4HsVvFsPlEz1jxSIUXhG3el9ijwuILuuKL7MBeSEKpLr9vzNQJOVqa3B7sCCZMExEw5+Mn88/BA4rzSpK9ZVH07ubtKqcPqVO0xBc8TWm7S4UsT7MjN6FAa7Mj4mQTW1YA2/Hf7B2zdwkF8b+nGdrN6VKWTg773Ta+/VjqEFDuWQC8V7p0j3dDK754FaNfd9U9DIE+iW1FEvD7JqZzIHkBa9b7Ipd3KRTZRZJkasCET9uCpEuVUnCdHBYmItf0uKESQDa8Q5FYxo7SduutGff/gx/vBzru0eyoFaePZ4j0MfYKHyKHbqJHcS3K4f5yo5zdXkOLBM3MCGUp4+k2fcTM67/GzIVgiDOEIpmbDQiYEEYSKJjXb5scdEP92U+CIhLTkc4wd6WoiYCE35lnrjLTnRfZoDFdTyfA7YJiWMtrc4m5BkKhIgvI1Sth+lKWP9o8C19wiaQE+tvwYYHjf6pCEsv3R7WstWB01uF15
 Epj2mZ02
 QTfqna31M8uSdxEihpu6ggrFhhJ7aMdpekJAPx0DgdaVumhC1ZF4qARXW2JJWQW1nI0LvBc+GR805/W4XjwMn7tvc5U72cMWi6PwLxiV7HVp+LogTkchKb1ndTvQXE3PdNMruwEEZvqA/rQXEhQzO04gUePPDKXInYop4+TajRyWHkk4XdKQgLV/GnGRP1moPqDj/6u2qcZRL8QlLkY1uJdtl/H+6K7HPglrPShgYG8G2fh56g+antBjzelirirIY4m/in9zc2TTIkG6PpQ/G1hjedXuB97J1Ad/rP3wsNunyJVx1+EuoF893ASymvSdO6a56rzDM7Zh2I8tY/JxoLaC7Y7dQHzgszTq4/uFYTcI6Kb2E/uuOf68uT+SXcGTdFzd1AodPyvnJBa2BHkrkGAG+mSitaI4pZn7Jc1UlrMnfjYxs+R6Q3TsVkduaqgavyU5nqinq3+tI3K75TT9pGQcf+7/AsJewXEv+VTtC4KsZRE3j8F1DvSxKiWG2/1tBd3BtevzdjbrAArMfm2qVhLJVW+l0zWwdkfvj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 05:59:23PM -0400, Michael S. Tsirkin wrote:
> On Mon, May 11, 2026 at 12:52:10PM -0400, Gregory Price wrote:
> > On Mon, May 11, 2026 at 11:55:40AM -0400, Michael S. Tsirkin wrote:
> > > On Mon, May 11, 2026 at 11:37:37AM -0400, Gregory Price wrote:
> > > > On Mon, May 11, 2026 at 05:01:55AM -0400, Michael S. Tsirkin wrote:
> > > > 
> > > > > +/*
> > > > > + * Sentinel for user_addr: indicates a non-user allocation.
> > > > > + * Cannot use 0 because address 0 is a valid userspace mapping.
> > > > > + */
> > > > > +#define USER_ADDR_NONE	((unsigned long)-1)
> > > > 
> > > > Ehm, hm.  Does -1 hold as a non-user address across all architectures?
> > > > 
> > > > What about in linear addressing / no VM mode?
> > > 
> > > this is used on a fault. I don't think there are any faults then?
> > > But maybe FAULT_ADDR_NONE would be clearer.
> > >
> > 
> > Meh, naming here is less relevant than the sentinel correctness.
> > 
> > My only concern is really whether -1 could end up being a valid address
> > in some horrid future timeline and this all going belly up.
> > 
> > Is why I asked about whether this is correct on all architectures.
> 
> I think the answer is yes: on all architectures Linux supports, the last
> page of the address space is never a valid user mapping. The kernel
> enforces this -- mmap will not create a mapping whose end wraps past -1.
> 
>   if (addr > TASK_SIZE - len)
>       return -ENOMEM;
> 
> 
> So the maximum vm_end = addr + len <= TASK_SIZE.
> On every architecture TASK_SIZE <= (unsigned long)-1, so vm_end can
> never wrap around to 0 and address -1 can never be within any
> VMA.
> 

That is worth documenting at least in the changelog if not the comment
with the define there's a clue if anything ever changes.

~Gregory

