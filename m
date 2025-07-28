Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2DC2C87FCE
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 09:04:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B2536B0092; Mon, 28 Jul 2025 05:04:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08E736B0093; Mon, 28 Jul 2025 05:04:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE27D6B0095; Mon, 28 Jul 2025 05:04:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E013F6B0092
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 05:04:18 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 67748B6DDC
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 09:04:18 +0000 (UTC)
X-FDA: 83713086996.11.97ACC1C
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6145614000E
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 09:04:16 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=IBJlhAKj;
	spf=pass (imf09.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753693456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S68O6AzwEdKLqEq8namz/L+It2W3CWex5pQxYxKgojs=;
	b=X7/BzhyRMr2oFSGc7n31bhrqZRfb0SxLkWNWT9mGhiD+H8Y12j6L/NRiTh5Do/cQG69BMd
	1UmsaZ8J+9KPnJUin5hjsyUmXT9vFk3Aj2npE/W3gEgBwA2L/y+TGHPaRN+GcX41GYk7jZ
	w3vQ46DK4m3pMQk17j5ans2Etj7MjDI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753693456; a=rsa-sha256;
	cv=none;
	b=Pxk7MML0fIdYAF2GP1L1+RrGm0dJtOxZBP/M4CmnD5wknAZMzKEFCI/OCgTA4EHR9mkHm9
	GHNM/zSWkJQHiNkSeIHqGe3vxw7jrPmfNHiGL8ka+nP3W4A6pFKGP43DdMUxB9Q7whtZUw
	9M3+rV5FFcDon2qitm11j4gmZ7vgZ88=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=IBJlhAKj;
	spf=pass (imf09.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-ae6f8d3bcd4so816160866b.1
        for <linux-mm@kvack.org>; Mon, 28 Jul 2025 02:04:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1753693455; x=1754298255; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=S68O6AzwEdKLqEq8namz/L+It2W3CWex5pQxYxKgojs=;
        b=IBJlhAKj8x8Cy7f1HJ1/mzWSeYmscWFUQR8tLQf+edodLdgQZaEiiHCHtgqgm7Msz5
         Bd3yVeeIz2JfwAt5y/lr8kxs7gmqGSGk2P/rOIPiHGLhkiGj3zw2o3V/VOYZvb9XjBX3
         mdunq+U+Mc57h73R1Osk1spvD2hlJIRyhy+nwgPB9J0HIRzIb7A4aGIeN1fZA32Sw7/z
         YSgckof82ak0jFn3tHdWs7+9pylWGbxhEvxZzFqRFu9Jezrup7LCvSu7S28adE6uZC8j
         u8zAcAZkis5DX+IAryT4pAzjMXmGG9c4MOKEg+aTL1/BE0dIF9cG9M+VhERgJZBXRCY7
         pMAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753693455; x=1754298255;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S68O6AzwEdKLqEq8namz/L+It2W3CWex5pQxYxKgojs=;
        b=IRW7W4OQhh2uGRPS+DnzTsukg/IzGPN4nGTIPpVGWWSMibAnNUjtjxhFcy96RXm6Cl
         Rc8CLPLA2YBsjO3B0ZDYI4nxPd3KVtqAvDIA2J6Z92hmayb9zngpYMfvV9RBZwJnu5oC
         LqyB9m3XK0F35HFP+I5NblDqMVIQTPVQyUOwB4a36y/NH1hLZkyZQyefFEoPpelW+TIk
         xEEy6PldCy50wSU3t5feOWAgxDByph7RBVn0RuLyxKoV/Mm91ArOMH2BYzYYZ2/Zklpy
         UAtJGQ5l9PewkGGkVduMRIceGThTnpyjknWvUtZNOPiE+bwilK0P6QuaGnCQ1opY8j3j
         rsbQ==
X-Forwarded-Encrypted: i=1; AJvYcCVBuq0uoyDZ7yNIErO1BlWrrqDPgAXst66TKB9nuu77CYvikcX/wyW0w1gTK39y5S2lukMDYaxU1g==@kvack.org
X-Gm-Message-State: AOJu0YyRzSw8fpNt9zLjcpOSktvA5PKC0RtfMtF9TSFzWksBUpRPVaXV
	/yDLmMd286g9DXP4Qcww/qA3nhZQDcYYZm+1kTVMatSEKwoh9Q3c3sZ+E32bAaXpCXc=
X-Gm-Gg: ASbGncu66BTEhd96i2HWaBkaoGeVpBWrrocLkFBO91E880biadMWTdMV5OsQWgwTGDm
	K80z/cBzC3Tv2h8U+tIR/GViT6BGppX8aY1a0hwvDk1YPGzjK4cn+DsdEsPlXQlSM7pP8WkBqsC
	tUAh0Ru5vIDcobOb242IFjups00erPOCH2yxzioRk4xDhsS3Afe7oOfigqImnyOwoDxaaSb06Lr
	9zVYO7/6LbvB1N1L5EtmuC3kn5xZWZzFfIFuU83kyk6NBVpxR9EcA9Mr5S2AGgPfbZAw0xs9/9K
	Z+O2a988LmmDghA/p+QxvIJdhrg8HKHYMAr/+xKyy5Z8Hk/ZNmmd/jORZojR/Ij7FEaDwVQWzDl
	bQwlhmESziw8DO+rJjcDOlOwWgRDwb0aK4W8=
X-Google-Smtp-Source: AGHT+IEzh/qHTBwjwxEhORlk/lRtm1Z2u7uAFeJXCmfVLX4GecccD/ls2PXjMoHMCkKaDwgZUeZLtQ==
X-Received: by 2002:a17:907:3f03:b0:ad5:42bd:dfab with SMTP id a640c23a62f3a-af6191eedbamr1150118566b.30.1753693454544;
        Mon, 28 Jul 2025 02:04:14 -0700 (PDT)
Received: from localhost (109-81-20-172.rct.o2.cz. [109.81.20.172])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-af635aea689sm393941666b.125.2025.07.28.02.04.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jul 2025 02:04:14 -0700 (PDT)
Date: Mon, 28 Jul 2025 11:04:13 +0200
From: Michal Hocko <mhocko@suse.com>
To: David Hildenbrand <david@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Hannes Reinecke <hare@kernel.org>
Subject: Re: [RFC] Disable auto_movable_ratio for selfhosted memmap
Message-ID: <aIc9DQ1PwsbiOQwc@tiehlicka>
References: <aIcxs2nk3RNWWbD6@localhost.localdomain>
 <aIc5XxgkbAwF6wqE@tiehlicka>
 <2f24e725-cddb-41c5-ba87-783930efb2aa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2f24e725-cddb-41c5-ba87-783930efb2aa@redhat.com>
X-Rspamd-Queue-Id: 6145614000E
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: pfijz3pstfbdackkms4o6z3bxmeosd37
X-HE-Tag: 1753693456-677546
X-HE-Meta: U2FsdGVkX18Cyk5GjGfdc4+puBQ5G14M/NNAED7+nmMsDxBnvAMAmhPsVS3PRqJYHWWP0X8LX0kuQWGfE7WQAIqHcBm+22oyEZ9m6FkV3YrrovT6KHZOvPkx7I1d04cUbsdwow694JcxPQ6L1MlD0sEgDZbIRcHW9sz4+w9pVBpaY1CMlHGvPWYQJQkJ6l4bwp8oqYpt8nVv/R1d62TKLsQNps2Vs+zaZi8oh1PvU1X50lzgjbS0z1hnkBoRw8bnqZiVG4GJrCveZW4Dmksvu3Z4qaTqTokrP7N+cDyY32LvQ2vYtCqSKBOwu0z0FKEHu8CzgJrWktOvJw6QlzxVOlKQfDtGQIA1B4cCYXmk+T330Ao/rHAJkKddwGCnLpIczd5CVUfGlcC43N9Q9GgzxSz6NPcPhAkEtgAfHdBUAn+5EbRnDQO8uX+APO/70WQAmjmj60T3SQTzRAh/Q4dRi3k7ylS/pl8YG4NNKNiz4M17M3RCilV/kzKKRA5GYI4lR5bohBmC4hAHQR+6X1rNJ0qTd7AB2TMSz1lqsIdPHwrKzZfMy3WrMD+C6BuxKJUH4h2dhaVD9PtzaweIDbMlg94tftum5I7kaylLU6rAhBVHV+V04WHNs25UWrkv2dgYg50LF8XziMMu7ypsDXRjw7u/P0blCu3y6K7W2a4ebTHua20HG4/Kot5h8Jsm4MHSaUGebBLzXwL6rdrk2EF1Uruq9+u7IIakpfLw4X1mJCr/cfGqynTeR6K0K9LHNWoB+a7iPlO1TU7vXiXHMPWv1A6CBkNiHFXtHHAxtaCLyPvH/nhuwpnkv912vYdTM2OHxcMSQ2Q2yL1FH0mo1Vn0RryVHzZ0xBZ7horgmULNNVtoNI1xgoTZx8B+nAUw9QkGuLKDb14/NMJ9kj8gTxUXbuV6YtzKCEXobFOWPBrthF6vHNw0UenD+2XF5nEmPajeNCHdYIe9rDchs1J7+6f
 pouzhNeo
 UEM8BGo0SVbKp6J6LP1A9VB3jRGqvzbGv3HtL+hihaKFnpHYYJarCifoHBZUh/sm2i3WqyJSPOITye8QoJHOUa4GX/Syl/VVvi52uknD/LIv6ZiS8IWcCDDwdZnTzjgSQWxQm6RkjKWlBf71RSb6CO/qHp9+9gOUiPS95aLEczhOa4w0x6S8+n3UTWxxEWLAwTvhYPWqG5DODV1U8qUlevo+HsdPkSOrUynJLzBlvRb4eUJgpu5XoN3kcXL1gl8H2Hm84Aah+m29wqAWVPG4fjWyI8zPMDFl6203ugurbxe8kOgBm5lskCs7lFiJtmZNgK3TTsMx3mC3wsQEuhgt+9/Kjd6S/Om8S/BXyo93IQ8pnSWM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 28-07-25 10:53:08, David Hildenbrand wrote:
> On 28.07.25 10:48, Michal Hocko wrote:
> > On Mon 28-07-25 10:15:47, Oscar Salvador wrote:
> > > Hi,
> > > 
> > > Currently, we have several mechanisms to pick a zone for the new memory we are
> > > onlining.
> > > Eventually, we will land on zone_for_pfn_range() which will pick the zone.
> > > 
> > > Two of these mechanisms are 'movable_node' and 'auto-movable' policy.
> > > The former will put every single hotpluggled memory in ZONE_MOVABLE
> > > (unless we can keep zones contiguous by not doing so), while the latter
> > > will put it in ZONA_MOVABLE IFF we are within the established ratio
> > > MOVABLE:KERNEL.
> > > 
> > > It seems, the later doesn't play well with CXL memory where CXL cards hold really
> > > large amounts of memory, making the ratio fail, and since CXL cards must be removed
> > > as a unit, it can't be done if any memory block fell within
> > > !ZONE_MOVABLE zone.
> > 
> > I suspect this is just an example of how our existing memory hotplug
> > interface based on memory blocks is just suoptimal and it doesn't fit
> > new usecases. We should start thinking about how a new v2 api should
> > look like. I am not sure how that should look like but I believe we
> > should be able to express a "device" as whole rather than having a very
> > loosely bound generic memblocks. Anyway this is likely for a longer
> > discussion and a long term plan rather than addressing this particular
> > issue.
> 
> We have that concept with memory groups in the kernel already.

I must have missed that. I will have a look, thanks! Do we have any
documentation for that? Memory group is an overloaded term in the
kernel.

> In dax/kmem we register a static memory group. It will be considered one
> union.

But we still do export those memory blocks and let udev or whoever act
on those right? If that is the case then ....

[...] 

> daxctl wants to online memory itself. We want to keep that memory offline
> from a kernel perspective and let daxctl handle it in this case.
> 
> We have that problem in RHEL where we currently require user space to
> disable udev rules so daxctl "can win".

... this is the result. Those shouldn't really race. If udev is suppose
to see the device then only in its entirity so regular memory block
based onlining rules shouldn't even see that memory. Or am I completely
missing the picture?
-- 
Michal Hocko
SUSE Labs

