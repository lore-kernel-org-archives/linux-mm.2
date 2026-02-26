Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E4FBFD8FF4
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 18:22:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D9796B0156; Thu, 26 Feb 2026 13:22:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B1366B0158; Thu, 26 Feb 2026 13:22:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BD856B015B; Thu, 26 Feb 2026 13:22:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3800C6B0156
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 13:22:57 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B9E7E1A0307
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 18:22:56 +0000 (UTC)
X-FDA: 84487429152.22.86A5B5B
Received: from gentwo.org (gentwo.org [62.72.0.81])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0D134180005
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 18:22:54 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=efGiM6fL;
	spf=pass (imf06.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772130175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+StJ6bSt+9W6TUbjleFHsdNnyzNJCUdR/ufr8IQ3U3U=;
	b=la1Za33pWVTGVkLNs3MZdXx4LUigamnYIofqVGEiWlyH72Xsvs//Ypb5zASccyvYIOsqK8
	/gzdEiv/LtbjCBpUG8IqVHPz3V1/JUEzwTuNUBSVmLAZHSeXnSjCvaRHc44cQfSVTlkdhj
	FeTXGrB3/tOL9VJC5aTWKe9Lh87pvqg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=efGiM6fL;
	spf=pass (imf06.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772130175; a=rsa-sha256;
	cv=none;
	b=P5kUQr+5OqQigqKV9nFBVsQbrfUYzVo9YYN96DcKQlpB2T1it+3QS0a+Ghs8fTu0lCLeF7
	tS0rLZsFltXMjtqKiFvLHnfOcQokpuE2kufEYZuOswQieBPep0PcCywWXbGPp2bSf1FADz
	uIscp8bHdUeu8iVv/No++s6dpALdKRM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gentwo.org;
	s=default; t=1772128766;
	bh=+StJ6bSt+9W6TUbjleFHsdNnyzNJCUdR/ufr8IQ3U3U=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=efGiM6fLM8PJs/tFPaYL3iiDbsQuar7zZTJjEZ+Zn8gfukuIHLEP2ob4/BOfCyEC2
	 TUcfQsC80HMu9jT86HJb+XbZ9qixYCcm0FvcKwD38fYtewT7VX01GElPqWhj5XVnO/
	 DBYvusA0Rm/GcMnYRnzCWiVy6LJOCKHRIQBwYHEU=
Received: by gentwo.org (Postfix, from userid 1003)
	id 20350401EB; Thu, 26 Feb 2026 09:59:26 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTP id 1ABB3401AF;
	Thu, 26 Feb 2026 09:59:26 -0800 (PST)
Date: Thu, 26 Feb 2026 09:59:26 -0800 (PST)
From: "Christoph Lameter (Ampere)" <cl@gentwo.org>
To: Harry Yoo <harry.yoo@oracle.com>
cc: Alan Stern <stern@rowland.harvard.edu>, linux-mm@kvack.org, 
    Dmitry Vyukov <dvyukov@google.com>, lkmm@lists.linux.dev, 
    linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, 
    Joel Fernandes <joelagnelf@nvidia.com>, Daniel Lustig <dlustig@nvidia.com>, 
    Akira Yokosawa <akiyks@gmail.com>, "Paul E. McKenney" <paulmck@kernel.org>, 
    Luc Maranget <luc.maranget@inria.fr>, Jade Alglave <j.alglave@ucl.ac.uk>, 
    David Howells <dhowells@redhat.com>, Nicholas Piggin <npiggin@gmail.com>, 
    Boqun Feng <boqun@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
    Will Deacon <will@kernel.org>, Andrea Parri <parri.andrea@gmail.com>, 
    Pedro Falcato <pfalcato@suse.de>, Vlastimil Babka <vbabka@suse.cz>, 
    David Rientjes <rientjes@google.com>, 
    Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>, 
    Shakeel Butt <shakeel.butt@linux.dev>, 
    Venkat Rao Bagalkote <venkat88@linux.ibm.com>, 
    Mateusz Guzik <mjguzik@gmail.com>, Suren Baghdasaryan <surenb@google.com>, 
    Marco Elver <elver@google.com>
Subject: Re: [BUG] Memory ordering between kmalloc() and kfree()? it's
 confusing!
In-Reply-To: <aaByMLSAIJM8HdbO@hyeyoo>
Message-ID: <6c08b86f-461c-d484-8556-09e53072113f@gentwo.org>
References: <aZ_lJAqxh_hNGr_v@hyeyoo> <9dcd02b9-42da-455d-aa08-165e6ff0b921@rowland.harvard.edu> <aaByMLSAIJM8HdbO@hyeyoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0D134180005
X-Stat-Signature: m7pzbrxf6quq9ru9zh76eiowsrhit941
X-Rspam-User: 
X-HE-Tag: 1772130174-905791
X-HE-Meta: U2FsdGVkX1/LiFhfmJ1KpNyZ+Gnu6rga4ZPN7Cj27wonpUeMmH7c8jaKiB4SAw/bHaOVSffeKzkcvrBypPCu0o+zCXQmO4QzOGZ6jOsHuc8s2pMpXVsR+3OYwnYt01/6Vz4EWUUPj9wEEH9ddzMcpKEtYZh5+3ht41YZAE9ObX/fX2/H0Og7xlBDftY7CtUPkPffwGKcVtgUi94mfrTTVuprZ6kLV1QKLD8wTngNLV1wYKyWW0I2R57A7IBEF1kIGkGmzesnYiWPJQtxSDoiMVq8YtsnWLlzzhIGePm1KympQonZikWT4C5lA5KNAS1kmfWucYIvoK9HpODWBzha9ido2X8vb80+7HPaM0BxDCWUtf74MPHTEZChPTgcItrJJBeiNghF7UWE8/Gx+9PbpetyLPAGq2+tyKB+HX0nWhXiBkylkIbzOWRA/fpKUGOmZjg8Q9mJlJOK8fb+u/D6Mww9fBH/W0zkF0RYNXynmCsnW4G3kez8kXZv2wGC2ZKrg6rY7VUNI8npc24hvDpZbZS6uZxxkua8VxAaUrluUCttu+z6NjooVXW9AwPu9sum3sOHV79ZKzcRhBp8W9oTpu2TavV7ldoOz7+athyBrO85GkVMfWFt6NXnUoyszI9oeXKuFalRpoZK3TnooPe5HLfACda73urHwWR81CUkaULtjL0DPO8COQzZAEOLnonkTrxwh5X02HLKQFY6CVvQN0Cost8TeBF9x6C5ZPkhKnlkPXUyTy3M02LQfNlqFCZuTTAtgK/y+T36eA9Sd3dRMNUAZ0xrlayTTW1zDZTmpcBa47RfQ7xAsRKxZPGqxL09txgSn0K6LL2P4uAZKoI4PKqZfFcZUNWRUK2r7pX6BjuJbqV9yqujNvErxZmTrevmfIi/hv/y2/PC0F67laaZfoUi6PswyhTirlJvDuZfGz8BdscOgYBuDPWChrymMKLddgNgjAjhGbcdsIt7dcd
 KItheceH
 SOOKJGkyo2RSDZF1/tTj4DJl7Rv5k/ET6dVtgK4doWesxn0mXSU6XK5c3c7ll7pD5iBWFOCeJffSRfbrV6+3ejTTWBG0Ye04s8ApFkftqsdj8NDZKOZ1cK/guyKj98vxg3DTrui7R/Z+XVgw3WskW+gS87ajzfr+o3G8Zzt9n/KJwXojOachIzp5xsY4LmoZ6xyskdS4zpxJICLpjRlBecbujse7uPwRf9LGlwvxRGaT2UTCKb+GhyqJR6FGECOVGkmFwecOXhhbRZ7Qz7FzlA4rjY6+YkUaJITxDZQx1bk+W2XNS3AD9mXqnHTrdoOIrCxAmXD5Ts1PuePd7BnEi2W5fahT0x0FBaVzWIrV3d9KxreNqaRVECSk4buRtYcCeUFwB93YzDpQFrSB5uBE8zH96pTi7cIlwehppHyvokkE8pYc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 27 Feb 2026, Harry Yoo wrote:

> Ah, alloc/free slowpaths do use cmpxchg128 or spinlock and
> don't mess things up.
>
> But fastpath allocs/frees are served from percpu array that is protected
> by a local_lock. local_lock has a compiler barrier in it, but that's
> not enough.

Well if objects are coming from different folios then that is an issue.

The prior slub approach had no per cpu linked lists and restricted
allocations to the objects of a single page that was only used by a
specific cpu. locks were used when that page changed. There was no need
for further synchronization since accesses were known to only refer to a
single page frame and there was only one cpu accessing.


