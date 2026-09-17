Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B59BBC982CF
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 11:33:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91FBB6B008C; Thu, 17 Sep 2026 07:33:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8839F6B0093; Thu, 17 Sep 2026 07:33:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74AC66B0096; Thu, 17 Sep 2026 07:33:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5B5B46B008C
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 07:33:40 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E127E402F7
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 11:33:39 +0000 (UTC)
X-FDA: 85223044158.05.E7164E8
Received: from mail-qk2-f43.google.com (mail-qk2-f43.google.com [74.125.230.235])
	by imf03.hostedemail.com (Postfix) with ESMTP id 298B420009
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 11:33:38 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=k5PCiy8T;
	spf=pass (imf03.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.235 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789644818;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eIBTGr6fLUbIiBkos+EvpyvMIrPaTb53KdjrzQhoa/M=;
	b=HU6wifZit7J5hdHED9008JhF/At4Isg/bE19x4wfbJrWORt4+K9rSWk/7GTWaWhZvzUzK+
	4o0uiLVxLrQIw+pmREUc+tq+Uky+XFUprZBGAj80ziYbVMY2PNj5CKDvIDivfi7uQQLF/a
	WhLpCrcrRl/cRleGYT0lkj+RZ71NxMI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=k5PCiy8T;
	spf=pass (imf03.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.235 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789644818;
	b=kjOqXjNlZ+mwWD1JhrTnmYpAmR9kGcmZ8c0iDb5Kjnh+bwdAA3djJuAw8AhW3fd35rgPtt
	Yq8OpfJg4w6ZNQSQVEkkzxCiiwo3gQoBM+fZ68Zd9wV9g5SYRfhKdSelILQN2/PzxKsNUd
	x8VyWC3HR7INKomAtApX3VYzDjP2XT0=
Received: by mail-qk2-f43.google.com with SMTP id af79cd13be357-939109fafd7so55657685a.2
        for <linux-mm@kvack.org>; Thu, 17 Sep 2026 04:33:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1789644817; x=1790249617; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=eIBTGr6fLUbIiBkos+EvpyvMIrPaTb53KdjrzQhoa/M=;
        b=k5PCiy8Tl/kzIVahk49gRlWL01gGh9nFEp7Q5fk8xC9RTOZn8JHGRDqoNxXO7ZrbG+
         XHAz04+6MspOyOmm+znU0RcYyHZUHo+muIVXP4AtQh7qmbyN/RIwjwNFLxDLPT2JQ1ro
         flqfLaDet0pfBIEed1v2MVBNNP26Ykro9CIUSOc+I5a+fgwe4ZXipZ7S8tN9d0FVnDDb
         o/FcbcHPdJRyiVLM07hv5f2ijOA8bQolgcPrja9iw2A5PL1U39v2ipl7Wwl0QwRybyRQ
         p4zekiFiNlZ+TW7MjF5Yl0TbbcvLYEb+zjPzy/Lt7dIn2VgOdnEl1cS0ur+qzz5PsF2F
         B0Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789644817; x=1790249617;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eIBTGr6fLUbIiBkos+EvpyvMIrPaTb53KdjrzQhoa/M=;
        b=jhxajLK+oDnRKHGmqQkKZnJ4dr5KfzbL+kkamzMMX8pfcHAP8aLqvb77ZynPXjm09x
         KPh2siV0k6wcLgj4Bpo2PBuDddAucppjplMLmvDUG4sL/21NgYpwFEBAQ89yohSOmjzU
         QY2lLhGDSG8HulSD6iqTipqm3JqY+bNH4y19gULHW6nW+TwO1AtvRNJXLTpaeKCdEQOj
         30rn71S8R8BRBiuPNZRHh1q1XFWaPpjG4SpJRHKC8s++J65sL44/B507CpCe48W7nqfZ
         hGTP+EtwIy8ZQFA8QK1jer5c5RVlctjBUjTPbXSF+iyETquOcd/YR2CboNQUq68v6Qjf
         G87A==
X-Gm-Message-State: AFuF++mHCUP5hxI3F3pqKh/BGzI4c4QQUvsHBIOqvzFTB+rrW5mtmUPb
	MRkUkCQ6z+ES+XBC0Z0qSfeOZBCynJefETHviyzDsRYHtSQxPgBDdZCUDHr4+IBWhdQ=
X-Gm-Gg: AYBFou0XrF3Y4CeUgANa/pCvU4To5WXqypsIh1lcf8l4bfarsMLYKpdWmlClihMqIMm
	N0s6RtE4ePRScR3JEzHZNDdyuYPCroItD+ltqqnidSiI+3ZZI41bUjNNM0Jo1adzedzE8ENC0nY
	mNcVY88aXhv+N6c7pIKhyok1fBga50kaKRcKFEoYwtBwXtZSSw17rQqt+P/rNNuYfhK3MjyBip+
	sicoAi4EBtYzKhfAL1hezqJcskSnqj9L8+WR3lWNh6BNNp1HgVPvkfQoiGurA1hMbwt9ualLk7V
	rDuYzXzoZLvD3BN5dh1N2jtFXRyZ6SmUB8uvYgk1rcr2ddZZE97D5aEID7U7XsrDhU3A+ekl7+b
	LvD6Y8k+t57oXKK/co/pRzUrT84iIPnFy7KE1do9kH4iK5tIDbLTloAEGJexl2DxsAVXUrx+U1x
	Ibt3IbvfT1fWcbhGMd8KdrrifPzb6cQZmuPR1EHfBxkTO6W5Y3Bx9y1FH3QdJdbK61Rl3G2fyDA
	TMW3YKPOYAYdzf9+wk8xZAZcnXDKZ9XrqlS5F8NYLA3JYW5TINofR3TXqd1TzPShg==
X-Received: by 2002:a05:620a:2846:b0:93a:c69:69d6 with SMTP id af79cd13be357-93bb79414ccmr1075893985a.43.1789644817199;
        Thu, 17 Sep 2026 04:33:37 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93bb4eb5e59sm421092285a.1.2026.09.17.04.33.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2026 04:33:36 -0700 (PDT)
Date: Thu, 17 Sep 2026 07:33:34 -0400
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	akpm@linux-foundation.org, ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com, urezki@gmail.com, chenwandun@huawei.com
Subject: Re: [PATCH 2/2] mm/mempolicy: stop copying the nodemask in the
 interleave paths
Message-ID: <aqvP7WIzYSzK4cyN@gourry-fedora-PF4VCD3F>
References: <20260829015943.1258774-1-gourry@gourry.net>
 <20260829015943.1258774-3-gourry@gourry.net>
 <d7f162eb-4214-456c-9d1b-a8623da61b45@kernel.org>
 <aqq_yv-cQvzuxr5D@gourry-fedora-PF4VCD3F>
 <7eb8f4c0-6e14-4f91-a3b9-77e82f76ed00@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7eb8f4c0-6e14-4f91-a3b9-77e82f76ed00@kernel.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 298B420009
X-Stat-Signature: puqyejkbm8homyq5xrh8d8itkj4ihuhu
X-Rspam-User: 
X-HE-Tag: 1789644818-824889
X-HE-Meta: U2FsdGVkX18vZ6hbf+u7Alrr4ZqyYuc9y9PhwbsL+ccqTpZ2La2D/fhxcNjge9gwu01WZ7jAQ4i8qP8lpkK/eixK+6xtlysiV8vINLMMH1v7rr4rZ8WPevCjV7wbwfN9v42UVa2Nj0ce54ivkU21h0VLEpWKQt78rYBu67gUSqAQrVI6Kj3c+BegfjmBwnpsqdyqM8GkrnoZznZpCPXLkE6/kkh2nKHUoCZjGZV5xE5SNw7mJorIkgPEQh3nC9VrD4zyBHssK2TM9injdzPAt2BDyn62UfH3l3GMltYuJ3hoZwrEmFIdjlXU03Jj4c3I8/qnsw5uo174grppY0PXhU7yqba7RvrTP++h+raSHOsfngFrsHQVX1rN2ZllhhhXkWiPPVzpCecNzEWoPhWiA27oHZCl9l9f6OfgAHB3zs/Bv+uI2AYl8Zvjs3SIpLwwlM5VKVZX+CqLxuVI0NgxDrQdmVqeF+FRNLTLVDdrmzGH+XTqJffj/Sl/YZrgLJbqMAhfndwj2wkzaBIkpD7sGql5Nqughxs6ivMw0SlFrWjUYJyF0q3Y1zh6T3nyrPRLoBlcJlMGkoNiIGmVKzfqcBwvZR+A1OAXQw28EEhgpcZhYQdtu5uT4MAU74bKJgfntq/m+UKuUottQGpx6GxX3/hqHovYsnbLpfKWR/RhUry5eI2O0IWK4DXCaslMCNlqTS1JlMtmCs5tVQFWXGYyIlC2lxNFVB+HtFFSnw28nwFzIttnsPgU+azv41sn70tilh/tRF7lo339kSN6nr1EqyHfr1WAd90M+CGkZRTDnX5ZQhC6XgzKw48dCIwzMTSPKCGTjC1rpUKbU6sMhMvolBLanNxgJft2kJRiqYQmSSTklj7oFADzHDRkIRiDD9/r6O3qWM9j7UEFJ8OwSnWJJNW9HcTsmTGeUnSFaE7+VD2HDW7tn8J7T5u/cA5312lJEcKGzDvxOuLD+ShoUlD
 3Xq1vzBN
 P2Dmy2B2Frs9opCFkY3c7lQMuF9R6U8MyC0pewSSqi1pkdAFIFvDldMPlSuzWMmOfAef8QMTG8lF6uzmf8U7xjJLCxfUBJWnEjLwknDkgx93s/yfzpM9RsMRdtZdDqsv225DQT5ZZRnsBjJ0Bu3IomZM4hxB4ocPd8WCYO+iCkgtbHf0kQQzFtnzwCjW3M/4vL9vDQT+4jWHogjKNMnU8M9vCjp78KffeRk1mbpKghLBZnlZBn1pmA2FLlS85A+jU0HfJ2GgtWfqg8I2jb8ZPpSmOyqKVmFBZ7EyFs5DABJ/zsklcFIuRmhXA9wmmW1btB2ClTXLcc9U47rd7GiRlL+aFb4MErc7HPx0zEp+Eu9oWnxcE8uOf/CsfirXL/uvRP19WpttcDkWofAFwwFaxCZFJkw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 17, 2026 at 11:49:52AM +0200, David Hildenbrand (Arm) wrote:
> > RCU stabilizes the weights and makes accessing them safe. RCU doesn't
> > help us with the node bitmasks themselves (we were using a cpuset cookie
> > to stabilize them to take a copy - but we're killin that here).
> 
> Ah, my memory comes back. So confusing.
> 

mempolicy is nothing if not confusing.

> A resend is probably easiest when modifying the commit message.
> 

ack, will spin it today.

