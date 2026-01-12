Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBBAEC9EC94
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 14:24:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B9B16B0088; Mon, 12 Jan 2026 09:24:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 366D86B0089; Mon, 12 Jan 2026 09:24:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 265CF6B008A; Mon, 12 Jan 2026 09:24:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 151606B0088
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 09:24:12 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D37C813A8AB
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 14:24:11 +0000 (UTC)
X-FDA: 84323531502.02.A9239D0
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	by imf03.hostedemail.com (Postfix) with ESMTP id C5C0420008
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 14:24:09 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ZN2Ifp4P;
	spf=pass (imf03.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768227849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KUpRNxQojbrCXQgZvT64NRnUmgfWoa2X68MY1dWZwSQ=;
	b=y1jST6VX2JfGXMUmbxcQcQ5H3LpusjRZZGj2BqzmHZziAw/KzI7sEb5Ma27VPAVeturpfu
	b/h8RpyIF7wzjUOC1A+2XuYfGm1otxPjEHPUYjIzeKwfG2ZuKC2vn/oJ1Z5+0nbs970r5i
	v0sMvIa8YbPJYJt9UZ5P9xHh94RUi00=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ZN2Ifp4P;
	spf=pass (imf03.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768227849; a=rsa-sha256;
	cv=none;
	b=IZOe0OfDJjdt7wACsySdobR0sxNMrD+SdakTtsBvYZ1JUbfFszmJIaUG1MNhITleXEgzLK
	HJZLdbzhMmVL+wPP7MSNkra8z6h2f/wto7/r5NBNWUOR3G/GhkHs39BksVTsCmgLrQH1du
	6w/UO9MniVtHC9TS4HH6zfC2IYXKS5o=
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-8b2148ca40eso934667885a.1
        for <linux-mm@kvack.org>; Mon, 12 Jan 2026 06:24:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1768227849; x=1768832649; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KUpRNxQojbrCXQgZvT64NRnUmgfWoa2X68MY1dWZwSQ=;
        b=ZN2Ifp4PaeF/gqxhj9DQff/TGWXicjqARLsppxyC4toBlv1W2RcYRGlYhpqEjAO8IG
         vFD8qAZAS6nmQ69mN8e1jt2IcWtLDIfOFplD7EE2sJdL7+LNP1nlGdSZRLUPTmJWpKGY
         cnivty4q42xcGBOPmfPfGbMtg6THNUjdbxN/8oGwANPFI9jaFVt2t9ZF3aT8YVHoAbZv
         SOcZ6X2+nxGy97omX0QlU1xz5bOj5RQyWXCm/lrL/qVs2SRckhEF/0AhpzcqdnEzdc6p
         aRDQBpVJ6S1DhorjbdoGmOfJHGA8LuD5vwxANjsnBcHTKHhlDWXcI8xti67NwgR/j/fc
         xajg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768227849; x=1768832649;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KUpRNxQojbrCXQgZvT64NRnUmgfWoa2X68MY1dWZwSQ=;
        b=LONRBmPPypk132jDAbfOiw5YWSBDuMdp+CDhmyJ5W20ufYnA48eVLfxHmU9aSekLz5
         Dio/uxAa8lWbmJ335eU7x/C8pHXKyMpSkTHfqJi22SIcp7Tkm1T96oeLSOaq3ocH8qG7
         /Eeen7h+ZSdkZZGmzu0i+PuqSfhOe5RjF3Ied5OwhTaTqikL8hzhwlZEjCUCYGg04NtV
         f0tE3oWsdWFe8+062c9+LN2CYZrfZXlZv9WJDP4NDOeCP8KhDXyzbprXiT0e1ZpmIhq1
         egWnxQqWfeb+0wv0inkWXWl/GQybqz/mgAZFwwbGdMyfqE4pl7DZN3yrDHTgW5os6B+N
         /SQw==
X-Forwarded-Encrypted: i=1; AJvYcCWXtIA7RZ8TX3aNsw5UwGkukczzIe1hB/QxBbtApngU1H1eN1okd6POzG6n8uMOL+R7865ND/Tpqg==@kvack.org
X-Gm-Message-State: AOJu0YxbCVdpMAauWUPnN5XcOIhN+1fB8Qy/k+ZVL28HyW09d/c3Yex2
	l6CoNMMW+FaaxmR8Y2cyUp+uG6XbRlwna1XU6iIW3wC9k0cTun7uQtZdumemFckTs5GGl8azhLn
	dBtm8
X-Gm-Gg: AY/fxX4iQFkyAUsTcv/JbGao02qryhSle1FLtSWCRl8PRx1o05ly2RZia0IQkVxL2nm
	yJU2nNoko4B5NjBN6N9kQvifWRJEwFbUHax1q6LktwjuUGCU3DE9yxTROWtoqoNTKGvlsN0SGG5
	HB5kpi3lvlP3hzBeRDr/9run0L380kkref24RkQdnXZ7/E8fZ5vrqUkKIXXq73jkcaDBorVkUnZ
	QxzXhgREXOP5sOufdSq8sVnCLoUJrB98vZIVHQNe0truzKnJAI1E1R0wOcw60sCfkvhPNci+2pn
	PYuc2aBa2Eq1JZG1Qxge3PrJhAI+hFz9e3vV5wTLX4UP9mpyuYpCr3nf0EXJk/W3LADWbvbjYDh
	ImLn+qbtGJTAHtQeuRA2K1JDSU9OTFXWoaoB3YwF62wDWWdw1yCvHIUpnPAQTjcm6TJnZLjDdA5
	pLbS8/t+mBj7JoPj5NqLEmVuPHSDOsqcHiiLmBa3GHy89BCIuyNRUVue4UoceDXHwzxrRXyA==
X-Google-Smtp-Source: AGHT+IHAWBHy+dg+riyrEfJ+OU+PeLj8yeiOx2OVhwYE1GsKUe4fVZkvq5w3wunyjI1ecPg+bhn+jQ==
X-Received: by 2002:a05:620a:7088:b0:8b2:efb6:5d07 with SMTP id af79cd13be357-8c3893f2390mr2358703385a.48.1768227848740;
        Mon, 12 Jan 2026 06:24:08 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c37f4ccdf8sm1546816385a.23.2026.01.12.06.24.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 06:24:08 -0800 (PST)
Date: Mon, 12 Jan 2026 09:23:35 -0500
From: Gregory Price <gourry@gourry.net>
To: Hannes Reinecke <hare@suse.de>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com,
	osalvador@suse.de, gregkh@linuxfoundation.org, rafael@kernel.org,
	dakr@kernel.org, akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com
Subject: Re: [RFC PATCH] memory,memory_hotplug: allow restricting memory
 blocks to zone movable
Message-ID: <aWUD597aHXFXbwja@gourry-fedora-PF4VCD3F>
References: <aV0_SMq_I_R7ikF3@gourry-fedora-PF4VCD3F>
 <9575e042-39f4-4f01-80db-34aaaa9312e6@kernel.org>
 <aV1PQd3tyfSiH4xD@gourry-fedora-PF4VCD3F>
 <616f97b7-24e0-4134-a08d-5abaf07a8b09@kernel.org>
 <aV1pmeXP2pZ55g5i@gourry-fedora-PF4VCD3F>
 <fd21ebf7-d016-4729-8d23-a7c0f2a3d8c6@kernel.org>
 <20baab84-c8b0-4c46-a550-21b26b975d07@suse.de>
 <65c246bc-fb10-4cef-8163-3a55bd96f326@kernel.org>
 <aWEvuS95-7yP-Vc8@gourry-fedora-PF4VCD3F>
 <b1b4ce23-d02c-46ec-96fe-ada6ae0948c6@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b1b4ce23-d02c-46ec-96fe-ada6ae0948c6@suse.de>
X-Rspamd-Queue-Id: C5C0420008
X-Stat-Signature: e9oyguwzawmopk9q195wa36qpdijwgom
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768227849-817101
X-HE-Meta: U2FsdGVkX1/R0Faf/AMyP6nhwI+RUSEBTNos9C61mgDj1TQ/kdW4fpzuNFH2wfflIVQwRQpWlqih3IDiTrZkX1Md+U14lfUoGaMervBnv+OqcZ1c7JiDaNxNyTLr6j+BkTiqcPECcg07LRBr00zo7JbY+bpEpFiexjocTKOtab1NgTzdfOdB5a0Lfhy1Hcr7lYmwxJIvegVZJzUUILz7na+vDLsj8K1/LpujxifZrlkB1I+kG42+0Jfj8J4ThzDo+A1DZDsLZwiGAVAiULvmcNEezKhs3DXIm1HY620X74ndFmx/2S1dMS5l5FgJofN/TuNV88hjqgxTbCRmg67hAB3wMhi46SJwBVBeRweh9j/p3YGG6JaR9preLfCGmR8rskaB6sCBvP0y9CdA7eZlSfN3UbjLORsm2yLMk/QASALaNU9IpN8f9NeK6HKjph3DIRGerk9uwv85ugxRX1v85Ssgdrd+XdAPPn3kr5+YWkFzgfy6qV3TqpWIOqmuyJL0zkQqyJIYTDegh+eMsksYroWcbjEffAoscOisNotlGQtYvxoM6PuZrwjEQ0nqZL7rrHRzrpgXGSmHfcBa4nf2Kdu4t0ECmKRr+jGqxW5JNK6dXhtzFbmhlVJQ4mtn9CraDdRXeQGt5EmnU2VkhuXdl1JqyZHTjQze/trPjDeTSeRiyX50f+Kw7lstKMMxQHDgudSp+smvQpQEaQH5NfCZRNm0+q+ywCMsYrWkNpEolCJOx1FZFbqVhI8iZPZx9ECnQzN4JPUZieb/dltrai8MIjMcc79hNWYHFWm0uTkht2jk4C/6GGfFzpjPrqJ+WJVebNN61yXD/ttxIMGaT0ZL6DFpJciQEn0TVCdpFF3YvEZ+rAIJF8uNM/biCi9ASBgevpdXU897QKLMxbuQgZbOdkpH0KEVfCoKKVE+WDndiEf3qEgFDWiMMO5uqtIBwXovzmpWw5hD/+6JK7b+J15
 xLJGg91W
 heXaQNrUVp/pB/teuiMZpRA1QBFoXxtp2GatE+jVAiwkT2fd81ywIu0nx4q14fNUFXtjeJZSt2tViEPS6vvc5V5rHBGNyHyaiwP19IghSErvya+SDuPQRiyv/VEY+mYGB0wrKdW3vJOWLO71/DwQC05PvvF98R61VJSC8nvCiK21DyIi6csklKxGy/SGlOPM+jZmLzi54EwVtIpTJARKfYSqkxrdysfKFGrGwhYAqCDosWps92LarVjRp17BJvFfzJohcFR8w/3LQl3srARFvrD5KOjIBrJeSWsdcXZSCezMqQ3neV5cEjZdm5UXbYgJ1FKQAcSx5s7YSDJptynSK8/DPh04FFtq4UE0rDNgl2YyMLA8fTvhAByZXww==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 12, 2026 at 08:28:29AM +0100, Hannes Reinecke wrote:
> On 1/9/26 17:41, Gregory Price wrote:
> > On Thu, Jan 08, 2026 at 03:16:24PM +0100, David Hildenbrand (Red Hat) wrote:
> > > On 1/8/26 08:31, Hannes Reinecke wrote:
> > > > On 1/6/26 21:22, David Hildenbrand (Red Hat) wrote:
> > > > > On 1/6/26 20:59, Gregory Price wrote:
> > > 
> > 
> > I'm starting to think this issue is actually the result of bad patterns
> > in the cxl driver - namely using dax as a path to hotplug sysram.
> > 
> > I suppose either we need a `cxl/dax_region/remove` that handles the
> > whole operation in one go, or
> > 
> > we want `cxl/region/commit` to handle hot(un)plug as a single action.
> > 
> > tl;dr:  Split the dax use case from the sysram use case, and make a
> >          cxl sysram driver directly manage hotplug rather than use dax.
> > 
> 
> Well ... not sure.
> We are doing fine even currently during boot up; we can align policies
> and everything to ensure the system comes up with the 'correct' setting
> Things start to get iffy if one is reconfiguring memory to move from
> daxdev to system ram and vice versa.

Hang tight, i'll post an RFC this morning that shows the idea in code.

region0/memctl/hotplug
  - if not already hotplugged, creates the memory blocks
    unless MHP auto-online or new build config set, do not auto-online

region0/memctl/hotunplug
  - remove memory and hotunplug the blocks
    Done in a single action

region0/memctl/state
  - accepts [online, online_normal, offline]
    does the action on the entire memory region under the hotplug lock
    online - ZONE_MOVABLE
    online_normal - ZONE_NORMAL

I also added the memory event callback to prevent someone from onlining
in zone normal if the last online action was 'online'.  I've tested this
on QEMU and it works fine.

~Gregory

