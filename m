Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B819AE9A051
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 16:48:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 956E76B0005; Thu, 19 Feb 2026 11:48:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92E4E6B0089; Thu, 19 Feb 2026 11:48:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82DA26B008A; Thu, 19 Feb 2026 11:48:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6CE336B0005
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 11:48:57 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 164991A0602
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 16:48:57 +0000 (UTC)
X-FDA: 84461790714.19.1408C16
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	by imf30.hostedemail.com (Postfix) with ESMTP id E329A80018
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 16:48:54 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=kUIvUcPA;
	spf=pass (imf30.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.46 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771519735;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=65G8mP/xYjTbY1b2pofiS3hqU1fZWgjXleiQkFPRVvQ=;
	b=BK67R5eswFIbpc+oTFeguxL+nQ1yrVbBbstYEYl5ucl/y1yJFOikjYh4en9wQgloltRqYw
	neRfJeHAhTvY1opPg3HbYFwnnC4TBnicpWqvS9Z76Xlcg77472CrnGJw8t6X97/mU+8Nfg
	yUK3E+1WP/IgaYqJo0CzQrapXGr1HDY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=kUIvUcPA;
	spf=pass (imf30.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.46 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771519735; a=rsa-sha256;
	cv=none;
	b=niTTjglwKdi1MtA+PhL7lNJyJV7mN0xnrPxmYJNFusajGP21lqT4FDWn7TiNW+Ml+tIkue
	H5K+1J0g+jVMjhBZ6pp0qksEoUpz6YW9bGRVwnvJ+Maado2SLKn8qSp1OTR203QYCx1tSp
	QaCls49GNmuSCOY1tFY8OZ7gqEA8Jd0=
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-897002b7576so14426736d6.3
        for <linux-mm@kvack.org>; Thu, 19 Feb 2026 08:48:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1771519734; x=1772124534; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=65G8mP/xYjTbY1b2pofiS3hqU1fZWgjXleiQkFPRVvQ=;
        b=kUIvUcPA6xZqzbpM7rUkL8m3hIIJdyT1/mF24xeU6oVUfxzS11rYiP8EaoPkCJAqaq
         NkkRLuLUoT02d0ma2LCYUQGAmsYOKLSBs4yLRKk26KgplENLNYV2IHhVLDwtQgjPNiBn
         FUbieT1am6o6m5APdBJzlXZqa6oB3ODBQ7EaCYay0rengk9R/IVOHg2E72p6uSsRFvxX
         8SWYZPQiWi5VBxdqNg1sLsBXydghs2Jo8rcQps/VahTKFFn1Xg0PbQ0BmYIU5h/xxZ6X
         kIfv51e8cL4y/VJESx4lGBpi6Daemy7qP5Pk5cVrWsKvFA4wkYjAMK7ly2qisEZaEHlk
         Lupw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771519734; x=1772124534;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=65G8mP/xYjTbY1b2pofiS3hqU1fZWgjXleiQkFPRVvQ=;
        b=IqfjhKDYR5mlic9xdjlCZiPRdO9kCrv/kRFmLgCMkmNSMVWMrK+TG9q7zwfq3d+wp/
         yKc4wPtsRMLkbsetvlBT4RQAq2tsxPiZh8MITOuRYIQC3VbCkXw3dlPUCTpah/CQKZ2d
         6wNQ3Yfl/seRnDlPwNpbRHt82h/m4UZFGkPTVBNfSSr1RiHV4wFri9baIhityeoanHbE
         TTxMbsQlAnrC20sm26MQWzyjVow2ly+ylAT/bmha5LnHRIkffTgruvFHyPBXxuYZFKui
         8Msaeb7B5aoWwygB1XdkFjN2Vdnk9nWuKU7gtr/oP0wKfIpxgPneAFIrcRSjdpMl3hxi
         HunQ==
X-Forwarded-Encrypted: i=1; AJvYcCUpdQfbZ6EOCSDFNgq2RvyHEFrVzXm51iNTaVGJTHxwlkGH7P3vYDTVewUL9EG+Yq0JdMF0OC05tQ==@kvack.org
X-Gm-Message-State: AOJu0Yyip+mXTm1bquZZUDIulx8Y2E8pIs9Avj2ok8LakBRNO6QTweoD
	RkJFNUDevmTDOphRfRC26nha6Lx48be6gwpjbDtqp0pgoeyVBn8nhA52QmnZbYUX8UY=
X-Gm-Gg: AZuq6aLi0P93OsSyqsqocnWzxPvsrmhfunPg+nIcNru7DSsa9+PiZSGfrigs3INiXwx
	347e93GDfqG0UJYyQQJY94vRTXrTM+YkfEIRXhEKVzV+iZYEzrNWSLiwMWlzgImV+hyanz64MgL
	DBiQheiT915WJBEVrKU1DOqdSz83fS9gk+ieUAxqfu0HFpz+++7lcJvRsAvEesK9jpQMYjJccB0
	lboBi6uno6V+h9jgBEEWB8F8Uo9X7m2Y9sLlFT0hel1CA2jm3fLjTn6y9fmsytRbUkzEzEARp+m
	THgBwYmDX6FJ3J2pSuyGAgv+t8TBBvthBk+GFaU9WHTJ6sNQdKtDbfqMCn8kns7w59yDLHvf/1+
	qBjBQdhL98l9CmCYaoOV/uDLV/dqN9xAWUccyKMsKTJjele5Ih/YRljToeczG0mLwZMGZe3D9FZ
	Ft3/JaNFPjRdR7LA0g7ETw7A==
X-Received: by 2002:a05:6214:f21:b0:896:fdd6:4a8f with SMTP id 6a1803df08f44-89958123c4dmr86110976d6.69.1771519733814;
        Thu, 19 Feb 2026 08:48:53 -0800 (PST)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cb3e56abfesm1970656185a.42.2026.02.19.08.48.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Feb 2026 08:48:53 -0800 (PST)
Date: Thu, 19 Feb 2026 11:48:49 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Usama Arif <usama.arif@linux.dev>,
	"willy@infradead.org" <willy@infradead.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
	lsf-pc@lists.linux-foundation.org,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"riel@surriel.com" <riel@surriel.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>, Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Vlastimil Babka <vbabka@suse.cz>, Lance Yang <lance.yang@linux.dev>,
	Frank van der Linden <fvdl@google.com>
Subject: Re: [LSF/MM/BPF TOPIC] Beyond 2MB: Why Terabyte-Scale Machines Need
 1GB Transparent Huge Pages
Message-ID: <aZc-8dMBz1XCJI3n@cmpxchg.org>
References: <540c5c13-9cfb-44ea-b18f-8e4abff30a01@linux.dev>
 <3485c8c8-9bfc-4725-885a-626e79d0aebb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3485c8c8-9bfc-4725-885a-626e79d0aebb@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E329A80018
X-Stat-Signature: moz7569hz6jeecym1gtumpjh1d93joi8
X-HE-Tag: 1771519734-457792
X-HE-Meta: U2FsdGVkX18Q3OKJnDP4OOD664Gx+uxAUpwgmzc3s/g9FVLAXg1QiSvRnlXa1GHO02i6jGiWRqyYvDIhaG0wOJN+h828oPAI7BOgyPzs3V8fcgQi8gRKDoSk4/DNLpg3AnY731g8abyQOo7o3+aH1ODin9nXzq6G4WqkYEuBHNCbmmKnrdPiXqnFYMidfDHfzEwVXlANX3Ni2Znmpl14vlmSBQdthd5Cq1HbIWUwg/fDtn3Y+a8hnMPqYYd0yJhtFzGI+he0vATJgxIP2YCIEkjmKVZlhExDPw7KvXX5Kn564fENxCEV1GuOT34PvTGB/gcPR8pTMa9LT+JOGYKKB0egqUgJJcaZxetadTtOeAy7/tU/160H/5sQFTWBKPN6JQoLMOagpdVfUE6r0IBcspESMGERAQ765Itn4eRYsNjBUlg4u787fXPDd41amFYl/pgJsz9UgzkHTq6h+uRqx7kyiyG213olxWYdnqF5eECsc/nkQd383sjWOsx6cBvGml/aBqPGLAUfFUlnbegClxhCqFPX6mDSZG21ETnDFyJ4iRnezYGTUrO6cIBOcvHIxTQjcEMszwE7P3TmK4fyLE7in3KHb7j9/q7DOxcTeYLkCx8Rvm/H+1l7aWOS8VAWKnCCo43ZTgVOFpgNMO/Z8HZoWpzypqMj4CQvy4v0X9wsmw+vQ2M53qHYQY+0yBxL3qQKPrNcMfxqjXE23mQUQuUNKv8sHbkIvNNk7I7EfTubOuw2pTDJEuh88zfDnnQmFjfCb8ISMggBX6BfWH4KroP8A5QdRvQkX2W2jhWzF72peM8Qh/LhXj/tFt+Nj843v/63OF9z/53Ow1kEyl1Oar2xHmUdI0e2jm6KNK8bfMQZxxfLsYnBwpEYJ2vzvz95POzOqgzfWI8xNb5+tli/VfJZZt6Lh3YFqTy11go9SXiz79NeQY2bftqmFLLdZ/Q1SYXS3ZFwOgl0pY66qGB
 AO0mhAIq
 oa/3GLzpbLu16Yfx5an5J3GYXI2XZvfOt/pyUZZSWGEKEJiywgbuoUSCymfqe1MWSZUgmi1Pi0S5ySrJ36aogCxFeRaYelfsbPNOybAC/dm0qFo2W4Mij8n52Zk7TGCpvhAMrvnd9WZcIiqEdoLS+5no6b8l0fHftprHb/UjUiZlXIvpFWMWeQa6zn8yktX9/3aPQV0KBpADXTXbzjzQxDxdM+aABJnBe5E3qJMYRLMN6VrRU5H5o+GJH13Fos9OnOS/3u67F63qI9apNvFVDZiEfwa6eiVblE09GG72PCy/udfWWcLQFQUK6lFWNTCpqFLr0PbR2PD0Pck6C4aDctj2zIMnXUQKApsDmjLKBnvESoAzy0To9iHhfocefrqxN3kRWZEYMpdgwbKMI8CVnB1CYBwunpEeL/1ypQGgM3mbea/t2lNx61B9GzdaWfdvTwttG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 19, 2026 at 05:00:19PM +0100, David Hildenbrand (Arm) wrote:
> 
> > 
> > I see 1G THPs being opportunistically used ideally at the start of the application
> > or by the allocator (jemalloc/tcmalloc) when there is plenty of free memory
> > available and a greater chance of getting 1G THPs.
> > 
> > Splitting strategy
> > ==================
> > 
> > When PUD THP must be break -- for COW after fork, partial munmap, mprotect on
> > a subregion, or reclaim -- it splits directly from PUD to PTE level, converting
> > 1 PUD entry into 262,144 PTE entries. The ideal solution would be to split to
> > PMDs and only the necessary PMDs to PTEs. This is something that would hopefully
> > be possible with Davids proposal [3].
> 
> There once was this proposal where we would, instead of splitting a THP, 
> migrate all memory away instead. That means, instead of splitting the 1 
> GiB THP, you would instead return it to the page allocator where 
> somebody else could use it.

With TLB coalescing, there is benefit in preserving contiguity. If you
lop off the last 4k of a 2M-backed range, a split still gives you 511
contiguously mapped pfns that can be coalesced.

It would be unfortunate to lose that for pure virtual memory splits,
while there is no demand or no shortage of huge pages. But it might be
possible to do this lazily, e.g. when somebody has trouble getting a
larger page, scan the deferred split lists for candidates to migrate.

