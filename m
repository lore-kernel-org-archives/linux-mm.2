Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29068606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 08:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=emjy8tAd
Received: by kanga.kvack.org (Postfix)
	id 476EA6B064D; Tue, 24 Nov 2026 03:58:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4283B6B064F; Tue, 24 Nov 2026 03:58:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EFE66B0650; Tue, 24 Nov 2026 03:58:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 053266B064D
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 03:58:31 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 150AD1C44C5
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:58:31 +0000 (UTC)
X-FDA: 85469411622.13.A529E06
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5A3732000A
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:58:29 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=emjy8tAd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795510709;
	b=nwdvUInr2zBMgom/oR9xGXApnZC967VPsbsRnmxCd3AGwSEadZLduMMAiil5ukxPDCDKMD
	FWD3vrUXwRESVvxbYh70ht4Ev3QhnkZXkSCWCKmiaYDAurR29JJ+Tn79VnouegjzYieSCW
	+RPNBLD4Igw+LMu401XtLjJjLihyOYU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795510709;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CQi6hoontomE15bKEUcwScQR8pAG9bqNClfmENXV8oY=;
	b=RznNY5lgBBrhOg2U5QQ7Y6H1WRXrKqSJSnE94yqCuUUZzndnw/AqDpeBCWbjWLfraAMIHJ
	easMh8ypZItLspNXQnGWfdQoQFZlkbCmbdkPcJ0+3ASLHMS+9vnHGrurutWDVCNWMWi1Oo
	O3z/tMeqp/qLBulLgc5mQ16GREwfdps=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=emjy8tAd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D73456021F;
	Tue, 24 Nov 2026 08:58:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 463B21F01565;
	Tue, 24 Nov 2026 08:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795510708;
	bh=CQi6hoontomE15bKEUcwScQR8pAG9bqNClfmENXV8oY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=emjy8tAdwKD4yxcwMD6fg4GmIvmlHGr8Orc8OYl5PT3gXO0VJpjQEiQG8uW/DIKH1
	 zR6hkD8w296aViWjJ1F07LPDrNKqMwQd6YSf++heu7Bf2uh1SvC0J0Hg8vticjmQuR
	 Uz82fgdyye11tgq13Y23tFMwDMq7Yqi7bd+5VOVexuBy/mt42ufjIqEwwkvjvU9vg2
	 X4h8dLQFNh+HTkRjSHDZDWLmt4AljDrjpjswqUK9mW1BMSSdU8SfTBe7P00mO334M1
	 jvzHfnOUyYnMm9KGuhCrK8VpletGVW3SND6OLWNng/LWjN8mAjvnnUATeMjSuOVkVz
	 7ej8vBseMTy+w==
Message-ID: <3027f79f-aaa3-4208-86d8-e6f01a8e62ea@kernel.org>
Date: Tue, 24 Nov 2026 09:58:18 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/4] powerpc/spufs: consider vm_pgoff in
 spufs_mem_mmap_access()
To: Madhavan Srinivasan <maddy@linux.ibm.com>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Andrew Morton <akpm@linux-foundation.org>, Willy Tarreau <w@1wt.eu>,
 Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin
 <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Chris Wilson <chris@chris-wilson.co.uk>,
 Matthew Auld <matthew.auld@intel.com>, Michael Ellerman
 <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Shrikanth Hegde <sshegde@linux.ibm.com>, Rik van Riel <riel@redhat.com>,
 Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
 linuxppc-dev@lists.ozlabs.org, stable@vger.kernel.org
References: <20261122-access_shite-v2-0-808d8d2aa700@kernel.org>
 <20261122-access_shite-v2-3-808d8d2aa700@kernel.org>
 <a4b839a8-b710-4dc7-8b48-847d0526070b@linux.ibm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <a4b839a8-b710-4dc7-8b48-847d0526070b@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 5A3732000A
X-Stat-Signature: ccoy6hrt5dznf9148jzff8oebbhtsjnr
X-Rspam-User:
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam06
X-HE-Tag: 1795510709-392066
X-HE-Meta: U2FsdGVkX1+UhxIeX6Cq7pkOw8P8fsYrFrgd7ZWz+n9IJU44WTEZddpZR9mtLwPE3yjtU35vyInZgz5cXsmUnozSOQVg42+vZNjN37Bi02QKof+YzcUq1b4fX+1uuk9asFrtSwO3l61L5J9WCbrgjggWaOPLL+QJJdwa8U/WDBc/uBirqXI76Yfep+KYW7nk3s6Uh8jZBzEcHcnMoJyULK58vM/fFmCnak8m++KfyimcAzmLSl8PR5sqh+PNP7Tb9ToL/beQSzUxPM1MTRA9wTvfzRlC4LzFa8WF/8o9GrmGtA7S4rLz+86WbeyWXfLbYtzQUGQD1Puyg0g5JoGsYEqYRiQQoGhVvx1/eID3TtUcHgmKC2rs7bw8szYUKfzHSWuNei9oP29mtu+R6LJvG4vDnx0Hw7n7ApOIkgWGb140G52S5+HSozp5aKS+CNFQJe0tfJ3vz9Ung6ARI5/QgjoapV1hRHMc8vjWhs3m0M14BX8Mlob78+cyWiOxGcqylirtBvCHvRdxbtKr8E8ZQTxQTH1katue0x8VYRd8oZk9CAI0a4MsJeu0D3DtjweNgZ+xMo+obzTI6+GK4Idj79zjWD1P9OCe9zZePH6OFPVesnUv4Hs6Wk4fUIcOYWKvNvHpotnoS5pDPMHFCFLRuXdQ5V6t6vsgTQ8YxPXU7PzytIc7FLL4KKUB8NJGDFG+qOO6znD9USJNtbBVhaOnIL+ZrQMAtcVvIla3tcvxkgo8zJ6rIfdU9bH/RL5LmH1JMM0UHjYPOdbDP7JBYMOtUTMfnOSCEJHYnKdN8+8VBuJyT6o31Y0v8z7tVcstyoSBoPujp5PXX0vb8Hpumay4iWkvypWRdyfisFnUzbYtYgdjs1B3H12aspBAm7H78BI7td1iddhXx9utjDcamOlBDCaTm06TOH1iAmZyRjE9Vi3Vabi5IKY8vM4OnXUx8RUns6lhdn5Pma/6NgOgYV0
 YY75hMUC
 Drsv0m8ZdFgoxoEnbDP8LvIV2U3Fqq8OqjeGmR2N4LRnig0NWVDnaDl7O14abSSker90x9SrthO8q4C7/QRObc4t+KeyRSzSFSAh1fO1q5cdSqKKfEFSPhQ8zLfUzvRlqnveDx9i+SVTcpr/L05fLPbCTYO2J8Lo1/RLSDDl1x4/Jg8nINTKGedjg+k3fdbA+MrLJ80pwE18x6+/XHwrA55WyFv6XDlGY+90brs22UsAZIJHhg/JgQOG78Slf4JM1qm4ZEfhJXETT9J0t5xSeWqwYkwAMr/kWGS/8v6u2wh2bO7xbZcWlfSOK936E9R2LwtcBe3yy+QOLWuoo3LExYovZhejEj7ImedZpkd8qPkVqJ4TTDMNz2qYOWvANwshsNBvSQ5EWwKZy6PTuXDRFqzChADUbPUur9DBsa9gorWqLyEwTF83kkIYJ5pJN+K/2vM8f1bVx/fOUgVAso5+SLUqMkBjsy1LZvIutETsItbF9S+5gdLWtKA1lGFQs+n+RrA6h0w5fd1ab05a2bb7nZryeSU2pgXG4QQ3mmDDJmj6Vj0TwFXvzIt0ZKdRrtL+oiItEEk4wiJq1QLHkdpLwYfwFnJhp7TYgQ1vsb5bnwtyRH1y66hzXWqXo4Jj+U6EILb6ZTw89bkouM66sUyeIBk1qd3IpU4KGCgiABZDK51kLz1U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/24/26 09:41, Madhavan Srinivasan wrote:
> 
> On 11/22/26 11:25 PM, David Hildenbrand (Arm) wrote:
>> spufs_mem_mmap_access() calculates the local store offset relative to the
>> start of the VMA and ignores vm_pgoff. After VMA splits, debugger reads and
>> writes access the wrong part of the local store. Mappings created with a
>> nonzero file offset have the same problem.
>>
>> Properly take the vm_pgoff into account, just like spufs_mem_mmap_fault()
>> already does.
> minor nit:
> 
> subject can be
> "powerpc/spufs: Fix local store offset calculation in 
> spufs_mem_mmap_access()"

Ack!

> 
> rest looks fine to me.
> Acked-by: Madhavan Srinivasan <maddy@linux.ibm.com>

Thanks!

-- 
Cheers,

David

