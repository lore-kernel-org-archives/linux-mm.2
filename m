Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD409C982DF
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 13:47:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B87C36B0096; Fri, 18 Sep 2026 09:47:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5EA36B0099; Fri, 18 Sep 2026 09:47:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A00546B009B; Fri, 18 Sep 2026 09:47:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7C29D6B0096
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:47:31 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BC946C061D
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 13:47:27 +0000 (UTC)
X-FDA: 85227010134.26.8411FDE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 21E974000F
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 13:47:25 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TFxgHBw5;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789739246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/62Itz9ZVEP0zggPXLCqWvGm+Y+VvQklNgINkbgT9M4=;
	b=y/vhrEFkKPyQS2Spny3jDWpHCRVHqKKIbssgb1U7J0lajMNYDy1Jh6UK7hNUeX4OGlyOOX
	OMO+SBv1Hp7j/1eKXEpy5LFcJVbF+K7PjJSntpqhtQbTmf/mmCKEglVwrejBxtdwxExy/I
	X2wePrM+lCjYXj0EdO5yDQEzCyX60cQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789739246;
	b=hQf0+HFEzm4h5BCNq/RKS2xf9gJdGAHaozDLGx1EMxcRb4OyY28RVNUc7OJxFlQsN7aM5S
	iI3Wa/Ogdv3MoDiIvV0K+18FAoFTRwgeINpp0o8KLbAPUhUf53usYVRPao71Ko5UPlTpUn
	YHnP7mymNan1oljmde2A215UxZwaHhQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TFxgHBw5;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 91855601EF;
	Fri, 18 Sep 2026 13:47:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DBDA1F000FF;
	Fri, 18 Sep 2026 13:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789739245;
	bh=/62Itz9ZVEP0zggPXLCqWvGm+Y+VvQklNgINkbgT9M4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TFxgHBw5WL1s4T0/X9Swei6eD4x4Z2OYGP+cC9STQoY8kz375zB/9zhqEA3d/XnAd
	 0wKyjB9TZGfdqdfVhbuSXnB/M+SI+XP58hhmyQ5E2V/ytQxA9s5nmP79DcU9zIqvq5
	 Dc7D3iDql6zv0Qhb/twW8G03PPJ/6mjh0Hp4UqdBh3iocoBvjP4TCbc2eSJ+IYYGMv
	 YJB29ic4HQny56fh+laAy9BrT631vFzEb+5TdeqIG/7k4s+/n9OaMchNPur7fs46el
	 FjK2YHZIIqfDcr9oGQQVnmqIBo5KrHcb1PP5ZUI0IDJL7/Kv/xNFsde0aojCvSHfT0
	 4RUrN4Q0AI1wA==
Date: Fri, 18 Sep 2026 14:47:12 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Jann Horn <jannh@google.com>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Youngjun Park <youngjun.park@lge.com>, Peter Xu <peterx@redhat.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/3] mm: update comments to refer to anon rmap rather
 than anon_vma
Message-ID: <aq0_uROeGtsyVJgU@gremlin>
References: <20260917-vma-is-faulted-v3-0-5c22314a72e7@kernel.org>
 <20260917-vma-is-faulted-v3-3-5c22314a72e7@kernel.org>
 <aq0dInU5aaJN_eMa@pedro-suse.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aq0dInU5aaJN_eMa@pedro-suse.lan>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 21E974000F
X-Stat-Signature: e7k6qjfdr6zyxwgamu5wasezyrpwbyiu
X-Rspam-User: 
X-HE-Tag: 1789739245-264514
X-HE-Meta: U2FsdGVkX19raCPsMOnF2HVGmdjFI8afZOv3+TTokc3NCc7Lhsb8RXOqqgRG0jml3q7oQxiNzcfZ2ICRaFZRDSQXqDLdq2A3U0jzWsj7YtVyuTZT/JVqmHCHK6blaeRn1mhvPkNkqqONRfqqkSAQjq70bEIDn9kIaU3sZNQ6P50CoT4u0/d5CtN+cnmYGSXT0Ksrx0dQynmZt9nWyix1cP7+s/LFQHJQfDyQyGj2A34qT1OHeSSNik/hXkfvo/TneQ7cjI9rh0MzI2vrRmAYckgWAwxz+IQQ4vAprtT8HhGJyBBHUYqma75L5mDsSWXUax/X938FcqtaKaRt0IN3dVGwxROEbeoaTs+KfiZ+3klOHWwl+pIpJnHC6y/wICzrc4sMfEz3CYVb8Nd0d1ewUiAAXXBaW4It6l4GlAnhclJrkY6eVEREGGenNfSIF/lkY+bxpcALUtLjNWq+9teeylM7wRD6olfTUYVXown39d9OMai2UOFhwxjxkPUxqAiFsSNRJNmYorHMpPq9aztjSGMaERzhtNSqt0K6NMPWiZ21TA0eGkG0r+JLWWHtbfamH0SOMPwCkFFRiIWqd8HWvQWfZwHddez6SQ5lzCGUQMjHKCzefXx2WKNFnTQxXNoHpfFHZf6sjye+eYO32zOHKu0Z3SeGGBe5yO8zrDoVYo7AVKAgh2Llf8SQb1hOQ8K103RxozIQJJ1c3470pGBRUHmKhhsjFBcZKRcpdyO2qdS95rCZVo2VOyfRVFvye1R98OlN6i6qKEqCMMCfd67VCWO1L/K13S8K8WEtdeVNqO/6VccQ6LJrCviwPDRqwtydHRf30aVc8pNSY9GhjRB2Fq0GrZakQIoQt6Fd3cxzJ0y5giRl0LXxVET147anzAlVl6mfr715ctB0hNwL/IBeSJtmqKpBjlAshhgBPbl57pq3btjWjWqDBzSyIOGsGbm5KuiEYm3FVTNOlwLvpg+
 ZjFMw84b
 scP8oNTc0a99fM31DN9CXf68533XAnHyZvl23A0AFzKy3GLoPhBs6pIeJsojlWnxAIZDrJmlkdnsJs24j+UUXcadjgnZoC9MnMJgeC4aU9SEviMtd70Vn7TU1iSlW/Oq2dRd9zzms/9Yx4bKovgzrGdhuLAbpFbjM15GHR/7dHzHJzjg1EWCOu/HiqLiYqRG2yE9N5iTOm1khyZ1DBk4YvErhTFKeWXF9lza/LssIq6aH70XU2cHiTnKGTLSsSxLPt8NHQhZqFrvqVdFYj1jjp1xyNqgkF5Ui5UbRntDLH6Hy1rMlb+V4c0I1XRszZ6zv5jofs3cbqZje9lEeNB7KGXr66Z6gU1aVsEtuBdL2Hm9zoRy/63pBRUbEhfD48Sj8iTlf8Ie2maK1FKI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 18, 2026 at 12:31:50PM +0100, Pedro Falcato wrote:
> On Thu, Sep 17, 2026 at 08:47:43PM +0100, Lorenzo Stoakes (ARM) wrote:
> > Now that vma_has_anon_rmap() abstracts whether a VMA has an anonymous
> > reverse mapping, remove references to anon_vma and instead reference the
> > anon rmap.
>
> Hmm, I guess this is where we figure out if "drop the anon rmap" or "insert the
> anon rmap" or "iterate anon rmaps" makes sense, language wise.

 Insert: vma->anon_vma = <something>
   Drop: vma->anon_vma = NULL
Iterate: iterate over vma->anon_vma

So I think reasonable-ish.

>
> Wouldn't the rmap be the map itself (e.g the current cursed
> anon-vma-anon-vma-chain structure, or in the Glorious Future your remap
> tracking tree)?

A reverse mapping is the folio -> vma mapping so a VMA can possess it or
not.

And the glorious future (TM) will have to track whether this state exists or
not.

In any case, if we change our minds on the naming, we can change it again very
easily in the future :)

>
>
> >
> > The anon_vma is an implementation detail and should be treated as such.
> >
> > Do not update mm/rmap.c which implements the anon_vma mechanism as it is
> > reasonable to directly reference it there.
> >
> > No functional change intended.
> >
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>
> Anyway, you're the native speaker here, so I'll let you decide:

I'm a native speaker compromising on the name I'd actually like to have ;)

is the least-worst alternative right now I think!

>
> Acked-by: Pedro Falcato <pfalcato@suse.de>

Thanks!

>
> Thank you for the series!
>
> --
> Pedro

--
Cheers, Lorenzo

