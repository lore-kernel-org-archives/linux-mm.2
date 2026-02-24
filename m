Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1053E9B25B
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 12:22:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1781B6B0089; Tue, 24 Feb 2026 07:22:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FB8B6B008A; Tue, 24 Feb 2026 07:22:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1ED86B008C; Tue, 24 Feb 2026 07:22:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DA10E6B0089
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 07:22:42 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7A30D1A048A
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 12:22:42 +0000 (UTC)
X-FDA: 84479263764.06.1C8D4D9
Received: from mail-wm1-f65.google.com (mail-wm1-f65.google.com [209.85.128.65])
	by imf14.hostedemail.com (Postfix) with ESMTP id 61A52100002
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 12:22:40 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Mkwx1q53;
	spf=pass (imf14.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.65 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771935760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CITHtR2qBTJvAFbBU67H6Y2kGo1f8+Vk17lQYkH3FlM=;
	b=1zQIJgkht9hQg53H4WhOoWgQkm7s1T0zNHyEKg8mdpqQZBKGnkrSZHFe3bYwexacdVQppB
	EBW1fni4Hqq73fBx3jntCCm/3YnKYf0mpmkJJRiDx0E3B4BPD2kmx2I0C1jLrVjz+bSAl3
	9EIRsesZlws+JyTmevPkJeq+t+mOl6s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771935760; a=rsa-sha256;
	cv=none;
	b=jovlaNdoAH+9bVmgWi8vmuV4qCBaCXPOWh6gL7TXxdkaDB/xYhehuihJvSQ3M+t7sXVI7v
	44t0JOzfvUTjFgMJxmG1FQnnojPZ2PMoBW7aBBl/NSIr9gzzQ9pUfeM5YiGpcm7Nj7PcJQ
	bwL5Tj1GQ+9dQWdZxf8YR40PZU23KNg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Mkwx1q53;
	spf=pass (imf14.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.65 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wm1-f65.google.com with SMTP id 5b1f17b1804b1-483703e4b08so43440515e9.1
        for <linux-mm@kvack.org>; Tue, 24 Feb 2026 04:22:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1771935759; x=1772540559; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CITHtR2qBTJvAFbBU67H6Y2kGo1f8+Vk17lQYkH3FlM=;
        b=Mkwx1q53Yz1X7WiqVvs2AG0sojH0VlRReFQBidAq020CnwL5oN1cBaANj8ZvL7LCU1
         p1o9gudt8TFZU02PSG4a3EfnDTu3w17cJxckfVdxojxlHmBxIB8eFicU9yIKC0ZcNICn
         kuIy3lrFXymCZGq7QVHafprUMOtvomchIGH/IrS7Hi0ofFl+yOtF/utf4e4mi0KCHQAF
         NJP3P29mbzOJo8MeJ7OQLLiud+VGdZmlFI+9mq3CgNX5n4QBTAg7J7v6zXoAHg9Dr+OM
         k1SVJYUMTEIXolv9DYU+K/Q0fDN9HSnJ++X6Jbvmu/hafywQ1WJujuw/L3dtmNy2XN8z
         GHmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771935759; x=1772540559;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CITHtR2qBTJvAFbBU67H6Y2kGo1f8+Vk17lQYkH3FlM=;
        b=MbEHtv28KjCYe9JXgiZcAzpm8FBTBCImHfzVq/MZXhErXWqqmxkYfhYiXb9uusiVOW
         NhT5WA7BX3pFRy2o9T2Edm02ucNuGrSqpYWbN98Z1DKNA6KBl4YqvwoL89lQKM5n/lez
         KmNt/+FX51f6jqTb8BeaXLZM0enR5DKvf7NeHBYKLDDCLiXHvN32bj5mdR3CCDueIVrO
         M4Sp1Lk/Cm/LzckBCR4yZB46btF0ZGMjRXNwsNoecU4WQSpw3i+qRCiCDhD2mkMIGiSO
         9YUBPMvt9DEh4hWktIBiu4dcPARvd6d7QHNcL0u4Df5rssIPLJVMYIp8tVdTWY0bB6V2
         fvjQ==
X-Forwarded-Encrypted: i=1; AJvYcCWjttFXB/Zov403WVQ6WwvFPoWtTI2FjcJWevepUAXBnFv/y1mvDo05hH9EYPFCsTJNHn6bj5FJxw==@kvack.org
X-Gm-Message-State: AOJu0YyWxR7ceM7TGT/hKIYKzdRZWwdzYE+mdVxQ+YuVDE/h3FN3jwj6
	CnmcRVlSSmXxF3YQEaXxyNH+32UBh8Ay0FJ446gCLM8Hee04LMDKXClXl2QalgV0koY=
X-Gm-Gg: AZuq6aKBv5ghiDhZQS4DJ8f6YSbAr0PlwN9N4ODjQTyVUefWrZuDui3zSPPVWOrE5lN
	zLtSYk80ntja+x6YevMJxG2+LCH953sN1ZC4/cl8NBreD+UIoKj3JrHVlkmkzm5+aOt5ZHGMrsQ
	LFBQWlxd5qJvJ7meZ2FjjBrI83IjRmw3D9G4D1SiWFmvisZGSLeNFYpdXY9HxIdoMhgzfBErenL
	NmMFc+JfbLG9dxkHc3U8PJIwbzEctjGizPyeyH9ou5m+y72DHSUivPzoFew9dDrx3MV9PbjhfRg
	+xaz5PWrdT23xx12tkZSPPK6IWOj+hfRcNdVXOQnJ3jNNy88kAzvG0+kWN8rh2RI3meje4g/yqM
	nrIKtGYptRsndy/jytwHrX90No5vp8B7hwPFs4YPoqvcASfVjya+RKNALXtrX1Zgqjsc1QgJ4zE
	EiUqANbuNy7rDyQr0etGkkgPpBgheXfUw=
X-Received: by 2002:a05:600c:4e14:b0:475:ddad:c3a9 with SMTP id 5b1f17b1804b1-483a94d1479mr185540435e9.13.1771935758583;
        Tue, 24 Feb 2026 04:22:38 -0800 (PST)
Received: from localhost (109-81-84-7.rct.o2.cz. [109.81.84.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483b88f97acsm17442695e9.13.2026.02.24.04.22.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 04:22:38 -0800 (PST)
Date: Tue, 24 Feb 2026 13:22:36 +0100
From: Michal Hocko <mhocko@suse.com>
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, zkabelac@redhat.com,
	Matthew Sakai <msakai@redhat.com>, linux-mm@kvack.org,
	dm-devel@lists.linux.dev
Subject: Re: [PATCH] mm: allow __GFP_RETRY_MAYFAIL in vmalloc
Message-ID: <aZ2YDD_l5JN78DJC@tiehlicka>
References: <ff48283b-be21-7f9a-d616-e303a4a1ebe6@redhat.com>
 <aZykWyxLy34o7PKr@fedora>
 <32bd9bed-a939-69c4-696d-f7f9a5fe31d8@redhat.com>
 <aZzPwsBp-Z4XM58U@tiehlicka>
 <aZ2N9a4XgxnurOhz@pc636>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZ2N9a4XgxnurOhz@pc636>
X-Rspamd-Queue-Id: 61A52100002
X-Stat-Signature: 3h8yk81int9w5imdsr5zgmrkfntcj61r
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1771935760-657926
X-HE-Meta: U2FsdGVkX1/u+1m1s29P+7xQGrEcUkjr6fQ5TXouja22sEaxfBv3wYAJ0H49jMbHEOoO4U3rl+llSwjJEAGAzdWd3OSm05rKnmdsjhnheRVkq7LGbXNku903dkYPM8W4KwDj8Z2WIEO46sev/yRLZaTjgRIPS9K4YE4TmMA8j+RrP+gXjXixaBl9j/W5X9zbKWV/X2RmBuI6wpNJ3z6AYtDyzXuiVsELOeuK0j2OB73SaCdkqXrCou09Pxg3ndWlzqnoyZ/P0xEvoaALspG6VVjgzhCrdk4d/0wxgCu3hT8J4DIVa/yOaMfp1qQxCEFNoLw2bDPx7e4xWbjr0pAIeCM+YDgCKzrGCJ2WwHyIf4/gBR9M95ZuWC+X6YO4cLG9GFetyOwyxeOlXAuUTw20X1rAY/1pW2Y0pL4ltlIG07e3eZ3D+1nHnmIpBYb8WSXaj6uHXy4Nr0K0IyDZwCBym9It+LBhkW42cmPYA8NOjC9Ni+h7BRZbp4ro1h+wsL78xSEIteJAe6Bs5ZV0z3RgO5jvpaNbvdgiu9kYO1OwIODtmaD+vyNS8gZR8HjLmDw6Qa08PQ56uYviXVz2vkqbGWEPJkBLltzUJTvsWS1MrZjYJPVfqXo8AfTD0J9PAObB1Z3Kvoh7dbPYwAKBUqV5Job19nnT6N66nbdb2Yjf8+BALg9T62aUsSHOYD+FMQliVhf3/zJzcB4ja1ZKh3T/s3UhQkNT01Byxh42pckRVyU7UA9YFrSXUo2jPOmXKmRotKgRv3PxhTe5rBld5zWYbp/Fl8yg/NsCOBCvFHinyXltFi4yqRHHsCv6aPvhPeKlK7C+Qc8ELUVrzOH6/dTXDks1tFcngzETWLx49jZoWue8sCGqYarpKCMmjIJmNegn0rVbh7SI+7EMi8eAGTMkw2y8f5Xz4SAQvFMtG4OVjx/29PP0m6cZjImsWSbXYoTtU1JRyCfDm2hIYX5VKq+
 PMoc4c+O
 ze1NdCBPLUjqHmCsTYeGUWYbCM38YLl1Fphz+uN+6Ee+MsuLCXTtejvfwTYn/JHE8t2Xi3jEZ0xUjRoUXs/rFi/siCpRuf+SQb5+JcLCivaUTrAoZzKjTmdcwkyTGT7hzZtzKk8r+/lSzXJDT4xYO9sWUFSjPon1ALepbzUsglCA2UyOrbgOuDpNApUJveWhkpw44UWJgnrq5dGR+HvAA3y4Ol0CjOhEMQWWco/9McCV9W3d2m0DzcTiw+v8HXp/vB5DOMISokk/SH+M/rL+9jpasLlYVDrQnfp2Q2mZs4D/rkFrtctwHdxnweAGJAlb7wkfkan0dgISq5JAlxerNnyi7906J5e6Vrm6wK3IsXCmeSmCVBcpNVXWQN1dJXOC7A7Oy//yxf+aopCYlYLEDNqJ7/I0EYzhF/iKMxIPqi55OsicAHuE/nmcnnnvFrH+6j9gVuE73GD4tWpLYbEePx6pbtORFxeGcBz2v7eBrPQH9dx3l/ap3+Yu4qcWoN0GRBuBO6RKDjOvPLpJodixTdkPQF160XEf9Poa897kXco6o61WX0NhjannKyg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 24-02-26 12:39:33, Uladzislau Rezki wrote:
> On Mon, Feb 23, 2026 at 11:08:02PM +0100, Michal Hocko wrote:
> > On Mon 23-02-26 20:25:38, Mikulas Patocka wrote:
> > > 
> > > 
> > > On Mon, 23 Feb 2026, Vishal Moola (Oracle) wrote:
> > > 
> > > > On Thu, Feb 12, 2026 at 05:33:30PM +0100, Mikulas Patocka wrote:
> > > > > The commit 07003531e03c8 ("mm/vmalloc: warn on invalid vmalloc gfp
> > > > > flags") breaks the device mapper VDO target. The VDO target calls vmalloc
> > > > > with __GFP_RETRY_MAYFAIL and this flag is not in the mask of allowed
> > > > > flags.
> > > > > 
> > > > > There is no reason why vmalloc couldn't support __GFP_RETRY_MAYFAIL, so 
> > > > > let's add this flag to GFP_VMALLOC_SUPPORTED.
> > > > 
> > > > My only skepticism about this comes from the line in the
> > > > vmalloc_node_range() doc: 
> > > > "and %__GFP_RETRY_MAYFAIL are not supported."
> > > > 
> > > > I myself don't know why that may be. Could you elaborate on if/why the
> > > > doc is wrong please?
> > > 
> > > This statement was added by Michal Hocko in the commit 
> > > b7d90e7a5ea8d64e668d5685925900d33d3884d5. Michal, could you explain why do 
> > > you think that __GFP_RETRY_MAYFAIL is not supported?
> > 
> > The problem with __GFP_RETRY_MAYFAIL is that it cannot be fully
> > supported. While pages that back the allocation can be easily made aware
> > of this failure mode there are page table allocations which are
> > hardocded GFP_KERNEL and there is no sensible way to extend the API to
> > change that (as we have learned several time over years).
> > 
> > > The VDO module needs to allocate large amounts of memory and it doesn't 
> > > want to trigger the OOM killer (which would kill some innocent task and 
> > > wouldn't solve the out of memory condition at all), so I think that 
> > > __GFP_RETRY_MAYFAIL is appropriate.
> > 
> > Understood. But as said the very page table allocation could be the
> > trigger for the unwanted OOM. The same applies to __GFP_NORETRY
> > unfortunately as well. vmalloc has just recently gained support of
> > GFP_NOWAIT allocation mode, though. This will make the allocation
> > failure much more likely though so I am not entirely sure this is a
> > proper solution for your problem.
> >
> Yes, the page-table manipulation entries are hard-coded and it looks
> like it is the last path which is not wired properly with gfp-flags.
> 
> Since we grow PTEs and never release it might not be a big issue for
> the __GFP_RETRY_MAYFAIL usage. But it is still not valid in noted path.

One thing that we could do to improve __GFP_RETRY_MAYFAIL resp.
__GFP_NORETRY is to use NOWAIT allocation semantic for page table
allocations as those could be achieved by scoped allocation context.
This could cause pre-mature failure after the whole bunch of memory has
already been allocated for the backing pages but considering that page
table allocations should be more and more rare over system runtime it
might be just a reasonable workaround. WDYT?
-- 
Michal Hocko
SUSE Labs

