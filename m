Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17522CC6B2C
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 19:59:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A5396B0095; Wed, 14 Oct 2026 15:59:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27C996B0096; Wed, 14 Oct 2026 15:59:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 192676B0098; Wed, 14 Oct 2026 15:59:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E39596B0095
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 15:59:11 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 721E81206D6
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 19:59:11 +0000 (UTC)
X-FDA: 85322295702.08.9E06965
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id CC9E5180004
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 19:59:09 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gI3k8wat;
	spf=pass (imf06.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792007949;
	b=id0X61mJNwH0+02RlUv6Q7iEYI22K1aCtvUzIg3rQudVYC7KT86PNenEU7BH8d32Fgm4Ro
	F04OQGPbVGAto3lGCuk88FRlVubKBPyTNuedOPigDkg8pf/MWmxnQSrnWYqKFKrCfxs17i
	MRlfqet54UeRbLA0bkz1Sc+6BJ5XUHM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gI3k8wat;
	spf=pass (imf06.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792007949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pS/KNOJaK0AZwKUD/L/8m7QFZRj2fsRj82r/sdiQEWE=;
	b=HIAp4epP6bBVZmfvh41ZRmvQQv/B8Q3ly0ZdNiD1lgKW9nmlF9z01vBKBcICidRBYpLoQI
	VLEv9pSDqd0t3nG6V142ziHNof4XyqAF5aKX7swmRa9+0Qhb17/n6c5R04W0K8+q3LZz/k
	DB1ELUE6Ji/IGtZSZlCU+69h8tK3WTI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0F62D42AC0;
	Wed, 14 Oct 2026 19:59:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 783001F000C4;
	Wed, 14 Oct 2026 19:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792007948;
	bh=pS/KNOJaK0AZwKUD/L/8m7QFZRj2fsRj82r/sdiQEWE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gI3k8watXRl1bgsoF8D1kj8tgMgDHOarxvHetnoYH3vI0a0KBskOZLcuAS91+xD0B
	 E4ZW0IQ8Bd5pKfJJJL/VqPddPGXYuf0RsygIrATZNrc7GcgqqJ89q8npEBK3Bgnjq5
	 qocBMFEnvxYN8UxyOiDANY2jZeaMr7UME3Cfnzp3CoXDrCZdy4nYWJBdzAAcATTQ04
	 nGXbey6Pv+WCMyJ6TeLRfHXci52/YskTmy/K3PjXF+JjZRDBstnvgJYgMROPeucEg5
	 P7mZoDepEwAGp25Ibt/jdJqzkKSe8bcxjg88eQqZRyGmC2UsregIRaUdHwILSQA/Mk
	 zE244BSgVZOtA==
Date: Wed, 14 Oct 2026 20:59:06 +0100
From: Harry Yoo <harry@kernel.org>
To: Imre Kaloz <kaloz@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Jann Horn <jannh@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org, "Jose A . Perez de Azpillaga" <azpijr@gmail.com>
Subject: Re: [PATCH v2] mm/slab: sample slab_state once in
 kmem_cache_destroy()
Message-ID: <as_eaUXfCni0sofu@thinkstation>
References: <20261014150844.8536-1-kaloz@kernel.org>
 <as_MPz_gXzkuGqFq@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <as_MPz_gXzkuGqFq@thinkstation>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: CC9E5180004
X-Stat-Signature: djjek8pxs4a78goumfzezsciwubwqpbp
X-HE-Tag: 1792007949-760278
X-HE-Meta: U2FsdGVkX1/Vi7VvtSQWvt4attDDyWgRvab/i3cm8yiBj2mnV3NNDgmRE2mPzwfupWjUom2u9uOyveAwCazNDAF8y8kFQdEuctrbbvJ4CDH4BBr9vvm0TnpxuZN1b27XyC8lz+tLWiXfxo0c74Hu3m++AzBH77AACy6xUpz5z9RrFLp9QipIEFU+o2V2JLzwVvTJLlTEuJoGmC5jf7TyF9D2lk4oa/abLtrJ0KiCQAZSdTqUKhZqLT5b6Yv1sa8lDpw7GenY8CP/rl2wiCNGIYPkNT5knlvJipd7yiQzp+ZMUYJLtKcmi3ZIB1/fCc+JdYmDaX1ml9HF7nLALBodfKF1zQRXdBf64ZmtORHryw2jpE/XOyAcQK01Hno/yES1JD85kRKJ/89pVkwnWL0FelGQVNTkM/vWnhfNZpQCNobt0s5vmg6Zs03mb1xjhnEDUU4ccLIUNP23eq4JEEmTmduJAeQwDGEG+AJEMfNFC68B8pDd+lQ8VG1hTZYeLpXfVZFACUVVlZePF71qtwTndmg+gQHcSFh0UgcjrGQOa3cOrEa/qa25SZjHxtZl4fo6+uFZ74Ussd0uS22OYdpvIF6FSkyVFjojhcvPtJhh5y2ue0m3HGrLibVnWAQvVxoqK7x45lSADo1p0gWNUPCM+gNI/2ViBq4D/T+VDFC/cHAvbt/jxwXOrxyblqZgdj5ObMi/YJWLYPXeGKIssQ0crpILbDEcW9gh6fTJx3//pIiyZc8xf9NmL0EawffFqKg48mVNGH3qnIeckvp5deTW6ViC3tEZgqmJ1ZdJ8eo/v0HzjVaQN2+R/H0I3bMbPwKGR6n0Tirs91Tn7NSr+q3BxPYJ787umjDHFbBDS4u2/Z7ERwEQWesbhT0cF/mbTtZ2TNnLIAihw/ATQEhhMyktN+vrGPeOoPhxthCCW7QEPPQTo3Vi1F7FPXRVHBtaWXw0yGsJMTfcgqlmKDO8gMg
 brE9iQcZ
 NsnD6w/ik0np2b6h/W2AUphbyn3tE9oTWOpAwHZokwschiHSgF/QhUBC7JW8eayff9DhSCYq47M56kdhMINcsqHUNUE/PVXmkdRl0Oa60B4CsM6V40pMCmf7bIKGzQOceu0Y7bMcRIqszsEmlYWejp/mjtgXBKa4qTUVsfx2g4UYGHkIrtG3zjLvEK51wAUjgFlZd12QHsjuQxeKMCNjYzmtbEY/3e6Gk45qSYfwtfNktbmgP+9GN4NGssC0dCCOk5Q5M7QAsVQ9bgfyrzl0SxOiE4a7FVJ0MMs34yjsNu10undGHWLIepb3cfSeH+UqKyq59
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 14, 2026 at 08:46:56PM +0100, Harry Yoo wrote:
> On Wed, Oct 14, 2026 at 05:08:43PM +0200, Imre Kaloz wrote:
> 
> Looks good to me,
> Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>
> 
> I guess it's late to queue this to slab/for-next-fixes.
> Let's queue this to slab/for-next for 7.4-rc1.

I can already see this won't be a straightforward backport as
the code has changed a lot over the history.

Let's try best to minimize divergence from the mainline commit,
and let's backport to older kernels only when it can be reproduced
fairly easily.

-- 
Cheers,
Harry / Hyeonggon

