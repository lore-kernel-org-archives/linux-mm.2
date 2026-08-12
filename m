Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53EB7C5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 08:14:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 545D06B0095; Wed, 12 Aug 2026 04:14:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51CE76B00BC; Wed, 12 Aug 2026 04:14:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45A066B00BD; Wed, 12 Aug 2026 04:14:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 15C126B0095
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 04:14:38 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9860E1A032A
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 08:14:37 +0000 (UTC)
X-FDA: 85091905794.11.4DED89F
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf03.hostedemail.com (Postfix) with ESMTP id A2B4A20002
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 08:14:35 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=YCIqaSic;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf03.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786522475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cm73Go05IhY67+bcf6pjgSkL6qSZACbfB1rQ4knSZqE=;
	b=0j7pMlEKmqCFe+5QZolRnRTOoJJIgSDc6cbMDyRk+e/lFqRJqU3537d0gIPsO3aplBYZW6
	weGdeN6LtvyDZ/maGLew4jhccbi52H1Ks3fLNngnizTf67oXhEUXTLrgJyb5t1XT+st/g0
	SU7KGgVKbDT1QRUz3gsEg7Mg/fbU46A=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=YCIqaSic;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf03.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786522475;
	b=RSMxzv/sxlfNux5WLYlVWZLcJ5zqzKyq3h6DSvFjfVyV1IZm08F0ER5otJLTMTNQVRdKsD
	dzNRJNNexGWaAnybs1E8ZP/dcxLKhMJREEXrj1vatP2mTw8XROJPf0orB+8BZvJ+Hvy6IZ
	KWdWdilONRNSbq8R/JdCzMlpiDsZacA=
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-47c2b362ee2so519143f8f.1
        for <linux-mm@kvack.org>; Wed, 12 Aug 2026 01:14:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1786522474; x=1787127274; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Cm73Go05IhY67+bcf6pjgSkL6qSZACbfB1rQ4knSZqE=;
        b=YCIqaSicNCpMfjJ4dLVK1Ko+sObx9lAGQQFB0Dacb9aOnXXPj2lE1qg47+mi6JgjHy
         8g5Yu++Ai206inD7RQ491Ox2W/xhsDwdb3CqqdgudH5jXqI72H6WmHjqPrIpa7FVD/eF
         ZeGcRxhPAr/RCWsKYQmVNdcI69Tpmjs3kmAxuZzQ9upKdKpNZerPO3AQU12Ga+qTm1QD
         IL1kiIAbLgl9Ik9tM4LrVzyV1moZoqViqFyvUJuktYtfZ1va7BeiYJEpe3z4bD0e0/iw
         9jxRidCbRIQJ7bxYzvyQ1ewgJFylYBu92bOPSyHPW6eKEcYK3zxWyyyFEEbf7tJui9qh
         4xWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786522474; x=1787127274;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Cm73Go05IhY67+bcf6pjgSkL6qSZACbfB1rQ4knSZqE=;
        b=QlYZsHMpE3o5eSpq3o759mvUqQZAJ2L51uX9zJA/LxJMKfl8HLUTsAMxBqC/jbOWn4
         xvcqxyllYZZCkN3iLv8JCh8nAGbtwCjv1UO9jDs1V6lG8xlWBsb6bh5NeyoxtSqhgRh9
         892OcVh7W1GtiNld2LHLYEGWOgWS/AgoAFbYgEX/3STK2UljFGEF/Zo2N7yTbxKSO2LH
         nkkoz+7d+JtgTWK77tLsBfI32p85rBe188f34cqZT/2w8yeFTDLMKEmP5zsZMTHpoyt0
         OExV03Z20HmoBIoqa7SCMveiW8H6PgqZIA+WpHL0p5oI0rv0tchmU5t8UFiAGE93u3Vs
         EGow==
X-Forwarded-Encrypted: i=1; AHgh+RpvczETmk29Iol3q8VgB6Dq05U6zYwzHnpmT1siF227lpj90xAysmQ9BUT3U1fzh+wppNlkFsPE6Q==@kvack.org
X-Gm-Message-State: AOJu0Yz7x8tdJFlDHRBdgM/akir+lJDzL07UkVBq/Hcu61C2kRVRIRrP
	t+LLm61DWEjU3/SGl/NdX5MR5aDxNYFXuSkSpPCyIFRtzXAfbBmohxCdVCpf1e/TplI=
X-Gm-Gg: AR+sD13o5OT+1tLxto8KyPz/Pkro4n0wsT1eWU378k/+enycBsMwAaiQBZoxK1xMscU
	OvlTSTAlE46gIr7rd2PKFaMUeyx0PLVmgY+awuOztMJW3u4MS/TDxqIySahciHCebAWse2EN5TM
	X0g8jBrB1KqVPQi2+elf23RbMgjSlEdfKjj8YrO8Xnx3/eJn6ptiluBjLqXoZ9a7rQZRTjqc40V
	1194pZXnEZKmEE+H1HVlM1ia8lL32CuFXS5shK81jIpD6QPrPsaFCtzWnkHwgUR4EGWF47gakUa
	SDswIvYfDGTbGzTtf/DO3XEePobmPqmPCcuKCSngeN+9dKCY+N38WdJs+VV5GYQpG13roCWz6X9
	R3h46jDCtJqiE9mH8BTzAKK6AorigisGQNaHJNcTQ+lT6QnwQqxKtQG4GzOScwF4cM+COubPeUN
	9//q+jemYqn+WsVeYFAXj6cBWWEYOiv/QfgasJD9HVhFQYiQ3HMBVm+0j+O7dMNJu9O9Ooy38=
X-Received: by 2002:a05:6000:4607:b0:47f:9283:1fb3 with SMTP id ffacd0b85a97d-48152775015mr4164525f8f.0.1786522474169;
        Wed, 12 Aug 2026 01:14:34 -0700 (PDT)
Received: from localhost (109-81-23-83.rct.o2.cz. [109.81.23.83])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48150bf5f0esm4963432f8f.4.2026.08.12.01.14.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 01:14:33 -0700 (PDT)
Date: Wed, 12 Aug 2026 10:14:32 +0200
From: Michal Hocko <mhocko@suse.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Jason Gunthorpe <jgg@ziepe.ca>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	=?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, linux-mm@kvack.org,
	kvm@vger.kernel.org, linux-rt-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/mmu_notifier: Remove non_block_start/end() from
 notifier invocation
Message-ID: <anwraNIKJV8zwrNT@tiehlicka>
References: <a247c49dd61af1df7ddc4dcb1cccbcb36b04d9d5.camel@infradead.org>
 <20260811135537.GC544626@ziepe.ca>
 <1d669aca4ffee797b9c29215382444a5b23624b3.camel@infradead.org>
 <20260811142730.GG544626@ziepe.ca>
 <a552b227e18ddbb3fa1f2edf2d1cb30ee6ccff13.camel@infradead.org>
 <20260811104229.72fdd928@gandalf.local.home>
 <37b83b429b9f14ea6ad4ca1c13cc8e565ec09033.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37b83b429b9f14ea6ad4ca1c13cc8e565ec09033.camel@infradead.org>
X-Stat-Signature: fy137mogzj6mxwpy31pdb5fkgai3c8bs
X-Rspamd-Queue-Id: A2B4A20002
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786522475-905803
X-HE-Meta: U2FsdGVkX1/Hu2GjVxctGkyTlRV6HgRqxmsaQ5Wu2th7nynLSMHqa/DSw3BO+wxqTK4/9E0MNG1RtfBgRNrTObha+91L4XbyhjZlbG3NiJJAFPHtSPX3ttDwlD9WwrfvBzOjiuohwS7CLI+Tk1cbePimkfYeNeGCOGC2V8Yw3z0PFHHSoulHjezbN8hrCQHiFJVHOALXfvWdz8P91eMIfnpfCi28iR4Hb6kEYvI9V6yqqlaf18XqMWUNPfJ13ur3wF+RN7J1O4mTsSNVaewrWmQG+LXv6FdDHHCfVvJCHHNmnzhSKifUqEVcyIBxVjz/UQGGRa9kZZW/ocmrpTQngn+HGJcfAEE81kue7WMviyylvZVNJuaLYDiX8ovK3jZeNalYNIXxgYoorD1lf7cidb5Y5myeBGQj7XNRJtDLU+gNNb9RKZ6kWVtdkbDqK45g1S6DuajzXyCNEs8CZ3lIT4b55yQ4V5/pehwJg42I/gAZPWqyySU8Hdr6nkADhRG6xEDAWxuqqzI/kQYOv2gb/IXmqR2s48ai5ykf93NpOY4zUBMtPlhT0upHmw6pwg38VQUcLV7TWeSmEXBCct8hIt8hrtzqr3sDPqBUEkVsA8oBQgVfQTR72CByFb1IXZzf4KsVO4pxAS2YrTmt0rYz4RVoDGstBRPkp3zA1OSFvP2xnqIv7HktEejVulj9mBmAGf8rgdRvPyOcZhECLb4Njkes5jiSNTVBQNUopdoG0EJ/x/szDkPhtdpsjjKwdyKZKMlEjCoC+yF1c4Xw3pQdmRmqvHpAdwzC60G0u0zlmK7DnO7sXw9LtY03MkOsVM3V8YtXb5ehm6r1Kn452s5o26/s6JSwKJFvIn51s64bLjLhnHMl/sMAKOPKRkSgeSFtG4NC5+2IsALrN41o+AUomHagy3lrhNTVA8EKCcvNH0IKaSDSGWZBgh73/bWFLWR3k0zqkl7SngwigTDyyGg
 HaQpAGt0
 ek3T9IBdq8Ha22PR+Ae+5vsfy9ZGnwpqrb67bmzBpeP4st7/mHzbBvp0LtSXI+KMD8tR55BzP31acM2od4HxZl2O5PKF9M5PXLtK0I08VK3bmMO4a22/2VPvi2CH3KHETRw50dndf49Sztzmj7GcTBFahaIXH8RFWGe0eFbR3Zs9R2IAhIB+3MjRdo8MBYA9wYC9B5TOuhhG5HNMExthOzA0fOyXrgZZP93fxEOyRi0wPBOONUPfnlCvsjv+aXCBAf8hIbekIVnsq4cKErof/wTKeN0Q/46H7TRz7ofuW3uCozlAyZmRInuLbUoTd9Pw08W/BtBPtimHexGgB3Cd+XvkzRXY9sPSMRiuAZG95xecaJO9+78Zzw4095ABq3wg1hXLzT4HoIUPtXUQf+PNP+q2xpQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 11-08-26 16:24:48, David Woodhouse wrote:
[...]
> I had a second reason for disabling the overzealous check too: to allow
> SRCU grace periods within the notifier callbacks.

Is there a way that srcu barrier could cause an indirect dependency on
memory allocation? In other words what might block the scru to complete?

-- 
Michal Hocko
SUSE Labs

