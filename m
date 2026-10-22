Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE3DF60A262D
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 13:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZpkohZ1h
Received: by kanga.kvack.org (Postfix)
	id BA92A6B093E; Thu, 22 Oct 2026 09:43:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B59216B0940; Thu, 22 Oct 2026 09:43:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A47EF6B0941; Thu, 22 Oct 2026 09:43:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7D4816B093E
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 09:43:47 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7ED991407E1
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 13:43:46 +0000 (UTC)
X-FDA: 85350380052.07.97F0642
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id E3AE41C0005
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 13:43:44 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZpkohZ1h;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792676624;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JfIOramtLWCfF2fj5VyatXzHdLxQiImQY8A2BeyheHw=;
	b=HZDiWStOlVGYpExtnvh0MgiwglCRPlx+XXyNTgr6aXGT17DjTpH3FlP6lCpt62XlZho6nd
	4SfJ70pDjy3R4d1qjRm26OiTTbTLmHDtOVv+pkUQOqLdWWnWgLbZn5g4g/DQYe+hLBPt8A
	Heux21b35KwDq4h4GWTFAjF2Aau2vpo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZpkohZ1h;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792676624;
	b=gQ4IOj54d+J7DzvwDA5UMolfcoHUOF/kbejhkgBYreHxMR4+J41P+hHh/DzhztqPvAxj/0
	LO/SQsFUyq2uvBKD5dwAb1Du/O4AkNh3KLBBiD4gZqtvmoGua7I3f03JGTAlloxgNhuaSI
	JjLFWFQQ8GnQMipBEhATJ0h2dYvcCF8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EB9DE413C0;
	Thu, 22 Oct 2026 13:43:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CCBE1F000C1;
	Thu, 22 Oct 2026 13:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792676623;
	bh=JfIOramtLWCfF2fj5VyatXzHdLxQiImQY8A2BeyheHw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZpkohZ1hNfp06ULQCWHIWTKxOV83W2+3xIQY1UqscDgT5MRTuhu1eFEeL8vRIaEFn
	 nosXBi8CF/TArGD8eh/Hs2tPaXOIQFYLQsmGzi214WeTI7DC+/L3m+Aodxdcd8kfru
	 yeWaSmesq4At99wK4HPA/poSxHJVwqtTGaxD7hiNj/9u2PoSIYipWwI7baxjKrEiyu
	 GfAo2oslWyMHRx1a83s4U2oMqZx1mn1KnP1wwMK70j89m/i9ILbcIWQQfwgqSpv0pq
	 UeI96x2EnbKp4Fo3HOc53l3fPmgxMK67NikaYIq8VSIPS5seS9as9HSCy2pzIgL39Z
	 Awkb9/8hyWz6g==
Date: Thu, 22 Oct 2026 14:43:42 +0100
From: Harry Yoo <harry@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Suren Baghdasaryan <surenb@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Muchun Song <muchun.song@linux.dev>, Hao Ge <hao.ge@linux.dev>, 
	Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Jason Xing <kerneljasonxing@gmail.com>, Willem de Bruijn <willemb@google.com>, 
	Mina Almasry <almasrymina@google.com>, =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Jiayuan Chen <jiayuan.chen@linux.dev>, netdev@vger.kernel.org
Subject: Re: [PATCH slab/for-next 05/14] net: skbuff: specify
 SLAB_MAY_ACCOUNT for skbuff_head_cache
Message-ID: <atoHqLrf70QSkn8F@thinkstation>
References: <20261021-memalloc-prof-dont-waste-slabobj-ext-metadata-v1-0-096800aa3330@kernel.org>
 <20261021-memalloc-prof-dont-waste-slabobj-ext-metadata-v1-5-096800aa3330@kernel.org>
 <20261021121941.4d8f8edf@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261021121941.4d8f8edf@kernel.org>
X-Rspamd-Queue-Id: E3AE41C0005
X-Stat-Signature: 8w8zau8d7ddpwycoh5tzc1mg3osetfug
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792676624-370672
X-HE-Meta: U2FsdGVkX1+LdUXkFxF4UUHefFuL29sq5RAnD6GyTdANPm6U7TFp5oC3TlD2k0AigpRh1mdkWfyJpiGUuGmZQjoDCqi2GFdUyv2yznLtHGkvXiLXkjCuVK0hLDMNZgJnLcUIsJcmPlZfc7x39gJVE945lyEIF1gYfsnD8+kkRM19N9z2mpcg1p1LkmiY+qlXWW4nUBqezJikjfk1Lb15A+dHd9biOOY/nLmbDDKdFpA9afkG8flS61DI95c0A3N6zhRGqKg8p7EnUMAy7/sEoxd/9BwVLYpMWRH7ZzKrso1vI+bB27y9m+ovWvCLr8L4E3tMFDk/Ncu1leEE5EhfsE8XszHu1AaJQ4ff59SmGEspguk0Oo+r485+ImQrzvZ8SSvtKOOiCGZgVo/ROQ1Q5fEsDx9pJuEhAjQ74SITvh45zv8gSFExAL/0FT0dBrSHNhfaMnwjC1SU6VkaelTYfPcf0g7YYp6c+ryXiffw9Kgf3NA5RbHJEPqP5coebbmQ0QhitEvEWnFHRf3HwOWeIC5QmY6+PX8Vr7Eo6oef+WCMsMTtdOcvrojxsNxU6U4lINQfFNKZTm3EUUwIRacL8C51eUBFPlm2hI4HePfjEb0lDrtkEJuMeX1PaqH5Hr68KSfjBpG6F4NgkiKzo68wSHLHWvNjnkfjHC0ch2gXGdeoWXa/asukJHXeIKx/iXtcLHyNcg6JNrETtzG/io7YIK798de3pNwY9UQScs83rMC0Z/P+gdiWbYtjJ7izE3XrfgLySrOQ49sjDao/2b8Q1sPSPE7jYX/N0Y3eTXfZqVkFrIMVdPVQycsYmqyWGj5boRxFuTz/oFkuN5dX37v3iTle2xcPo6D8m+bIihL2DdVWjT151L0ylgeZCaNvlWDikGjd2uCI+unfbE2hr7o+VPNx7lJKddQ7rE+Bx7fpQO2ULQ7fU9a1Unv8RvJYzxFYwxvl4jE6J1BY3Yp09z8
 BcfNBi1i
 7nxaDiUpOuPSIB2qrRLvwH+wxftp2dxx+S+ZX/oyxS78MGlzfTkbUF2YiZNMHUOTM4lIeyBRAvATouRd2LzyyziAao8b5/mfKfzxgBqASxKwgPTQHoITupdILAHjtjJbsPHlrzoPq+C6b8shA1/Sbt7O1QwbeN/n24j/scchN9s61/z0SRfvCh4H4/lVrnK/5WjEUsXN28F8eC1E8OTT9B3DlZb4B4rJ0K6MwwYZfsXTXj6GHkYRm/qPqEzLtDZGPSMypK64wNH3DVIaYQ1JQX/KcWV88TG2SJ1kKxYNhLxeArYA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Jakub,

On Wed, Oct 21, 2026 at 12:19:41PM -0700, Jakub Kicinski wrote:
> On Wed, 21 Oct 2026 12:46:46 +0100 Harry Yoo (Meta) wrote:
> > AF_UNIX sets sk->sk_allocation to GFP_KERNEL_ACCOUNT, so skbs can be
> > allocated from skbuff_head_cache with __GFP_ACCOUNT. Specify
> > SLAB_MAY_ACCOUNT when the object may be charged to a memcg.
> > __GFP_ACCOUNT without SLAB_MAY_ACCOUNT will not be allowed.
> 
> Could you please skip this for the first batch and resend
> later to net-next?

Apologies. Wasn't keen to the net-next development process.

I can resubmit later, but hmm, actually, do you mind if we let it go
through slab/for-next with Acked-by: from networking folks?

It's only few lines of change and it'll create a lot of dependency for
pull requests if each patch goes through each subsystem's tree...

Thanks!

-- 
Cheers,
Harry / Hyeonggon

