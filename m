Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A36C6FD5306
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 07:11:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDBCA6B0005; Fri, 27 Feb 2026 02:11:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C89776B0088; Fri, 27 Feb 2026 02:11:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B88256B0089; Fri, 27 Feb 2026 02:11:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9C0396B0005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 02:11:16 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 167E61B7780
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 07:11:16 +0000 (UTC)
X-FDA: 84489365352.06.0AABF14
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf04.hostedemail.com (Postfix) with ESMTP id 393004000B
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 07:11:14 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=dS+FyvoW;
	spf=pass (imf04.hostedemail.com: domain of rientjes@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772176274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uf6oqA11mcpn0AW+vKlVmJZSOPAGQueKk4G0rxmoUfY=;
	b=EdC+/25r/P1raKQzHJ0qQirwiOq7sxHmD9dEbHZ/fzdafcA6Ckob50ZEfnDtaO0nBqaeSv
	yEv/sdT9Bx0/GbZEnu2mv10f4T8tRW0Kjq2II0RCPe3qO3OnfKbHJhEyWbbwmxIp6Qka1h
	4XYEnvC2/yfniun9cknR4QGDTEQ3Vas=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772176274; a=rsa-sha256;
	cv=none;
	b=7bAzafW2pJQOMJJJHx5SVikk5IkZTg5idB6/wA5820k8NNNsMOyujHCqO+7dv3w6iSmOV+
	FWWQ9thbOZbXLGeHClAkSJnydZkWADhK1Rey9J4e0eyc9Q+fYhc43flFte5xWKkFXAow+s
	SrwhOu1ZfyVjapHCB7aTgTTfJL4cvPU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=dS+FyvoW;
	spf=pass (imf04.hostedemail.com: domain of rientjes@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2a964077671so59465ad.0
        for <linux-mm@kvack.org>; Thu, 26 Feb 2026 23:11:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772176273; x=1772781073; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uf6oqA11mcpn0AW+vKlVmJZSOPAGQueKk4G0rxmoUfY=;
        b=dS+FyvoWlBR2J4LN4JsfWvPG453eYJk4T4rRhi+tSjCZdtuVMLHIUYqRmgsxYWhV/o
         qfHgDXU8BQzGOkXH+pyg4cQRD2HZpsbuDkmGtGjlqbeAjEkeZOEIHAeX6e0LMFsgPpql
         e08Jz0GgYcnjYoTHIL/mwyyB2hnO773X7YbnfrvoI4YpV+kSvWTyyAMKd1C1Ibx+Cj+2
         rwKUCGu+fec1quusReC5kK9+Uzi6rAcrBzQTUehrUEAISFv3USv66d1JecadwPPm+GEg
         RC/41QmkmUlvzMJDyyyL+C1/aEXBH/tKbN4UE7cPiDfPF6QPkKfII6Gc7bZ2I+2I8b7A
         JbRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772176273; x=1772781073;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uf6oqA11mcpn0AW+vKlVmJZSOPAGQueKk4G0rxmoUfY=;
        b=FaaueE0jZZ7UnpAh/3KqZeHbPXmtM3k2W1Em1hX0U61iyk+2D4hx1upkI5lmkJ0QxR
         iIIw9KA56hTOOdATwDvgmzQkptFqaFqh643QtgdmuQe0P7+7oebtXfSJ7y+/uZGaNObO
         8IeV4OJjvQhCte42pXgif29vvAG5Mt4L7CsK/sN3jkqnmSywMW/J0Yz/DhywONccVN7t
         aAPTfDK6fjWqkO5p3WyZ+xnRM5HE1i4eJnT7oOjySQsCWXFIzE9BB1b4qy7hgCbMf26V
         n2WE5SNGtuNFWiLbfqwP+7whWn8PVw5Wb6YsTQsGIMULrnNs8uMYLIQ6A8bb+2DQa4JC
         o91Q==
X-Forwarded-Encrypted: i=1; AJvYcCVeSZ58qfrRP0ZqMjuho4cy6uuQ/wozRLYE8tRW1bgx9WyhiUv31AMWKDLhZV7o6ZkPtSEK9nAq1A==@kvack.org
X-Gm-Message-State: AOJu0YztGgX+UT0rRiADxcjBFvIcJezZCoCBKuzQocoejXoIaRfPIi48
	cZXIX0ihbcumSPjz+IzNHEwrCQETOw6usvFJzGejK4vsCLxcZhJblTM/KRMDDATxog==
X-Gm-Gg: ATEYQzwjkB3Up9FZlWnCalfed/6yiPD3qr/7hy2LH9SxUu8sx+62xPFaxdWOQTYL7IP
	KnEeBqRz8MD05k3/NMhwz6Dj9owIOdj0LnOR161hzeWlPMzuvjIEITASNzK+BehhCuEblHTJupE
	bURjTtWJdY4R+CPZ5aAOB06Cw31lARw8kYN8mGGPnfpFnJ95qd/O/pIkU3lXlD5cP+F9vcTHXPp
	ji1LHNChYV/+Jvt4HGVrq+BgkE/D0xc7NdXFGrOTLill0ez3Kv4QDHlajKuJfXUxkcsFVgOidIs
	W8Azuo0yp4/3uORtkTSKn38M67xI/yRaHD7oB0ZNgWFGiM3bO0Jdlz1LsZbkAuhlyEMpMQmr5Vv
	GsB134QwEEVSDEazQXPnyp/pnKTsguTRO8+ibQW+RpeWdmLg5lei1jdGCUJJoF3zn44dUpw1Liz
	V2j8IsxFUa+bW5I5nCmaTpxFRZ9WhtR781gzsZTNF8XpWEncfh/nJXRVNkzCRRF9GMA5t1JklXX
	rVAVE8w5W5D1C+DUY9gEHAGCVg4YmshewbAVSoo7iB7ahBXZhw=
X-Received: by 2002:a17:903:4b08:b0:271:9873:80d9 with SMTP id d9443c01a7336-2adff509edemr4003725ad.7.1772176272415;
        Thu, 26 Feb 2026 23:11:12 -0800 (PST)
Received: from [2a00:79e0:2eb0:8:9d0c:b43:ccc3:f5dc] ([2a00:79e0:2eb0:8:9d0c:b43:ccc3:f5dc])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2adfb6e261dsm45839455ad.83.2026.02.26.23.11.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Feb 2026 23:11:11 -0800 (PST)
Date: Thu, 26 Feb 2026 23:11:11 -0800 (PST)
From: David Rientjes <rientjes@google.com>
To: Kairui Song <ryncsn@gmail.com>, Michal Hocko <mhocko@suse.com>, 
    Shakeel Butt <shakeel.butt@linux.dev>
cc: lsf-pc@lists.linux-foundation.org, 
    Axel Rasmussen <axelrasmussen@google.com>, 
    Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
    linux-mm <linux-mm@kvack.org>
Subject: Re: [LSF/MM/BPF TOPIC] Improving MGLRU
In-Reply-To: <CAMgjq7BoekNjg-Ra3C8M7=8=75su38w=HD782T5E_cxyeCeH_g@mail.gmail.com>
Message-ID: <87c70313-64ce-fb3f-4b0a-8db0526b6c54@google.com>
References: <CAMgjq7BoekNjg-Ra3C8M7=8=75su38w=HD782T5E_cxyeCeH_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Queue-Id: 393004000B
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: kxf3qujaeryw56r8nyw4qso4pkbx81cd
X-HE-Tag: 1772176274-665846
X-HE-Meta: U2FsdGVkX19Rx6Y1BdlPO/yLhatL0pt5a8K9NMch04zsCobJnt+5QbNjtbWHKlOc3U4P8vjKSgsGlaV3CLC51AdcTyeEjAr4E8BdmAfSJDSSjBIxR8W1XhZrqS6vxtZvAgy8+uIQlIhbg5Z6dygdTImHsHt3KOKXDV+DoWXlQuiKywmldqU+lsSenaKPtFpdWNIc6MfCBpIKvVSQP0LMEIzlEgWONUiHcG3GQiHLF/ka0RqJy+IUujWluE9qtlUrIRd2iWZcDGheJYcKBAXJEi0RDNaVxv0qfA1QPL33PEDrFmp/oP4uum8drAJiCK1qNuNaEyfL6kyaNwrbsO9/gmxu/WKgMn6WM/cRFLzQfsdDatTLKvspNH3F5Fx847tKxusZgiisd78TrhA0nkLEfLrKPEJvNeSrYQ3k/Of2qK72+HU3H1RFF4gzeIYvM9Dkxbt3NQDd0vMSRE/vhQ3Hwc4KcaL3qDEuVC3mYKz2YW5PCbg3p0vZsvn5Ua5A1Ucn+ZRBtzucNwmTQYqo/L7yMQK2yR0tnpOleGW+adU++bCUC2bdrCnWa5LseYFeFV6XU+OWPSHgQFVHDDuBtD2SuzVenQBf2RmMd53big0WrV+CYOFqBb2UpQ28H4Qwq5IF+iUesR64W4XqXhP1KTdzfIu0dWREjbIcLGs2Lfd+N5gFv4xkHwEn5TaYtGO5Ll+EXbMjEOYNTJpmrl3HqpY7kAgjDPDgahneUs1ZhNQBCYzlb7cOa3JxYDTMaUxa/vEOUou7LpLOpTkiebxo51x/fmVzOAMsX0gSw5aPCvaSfpBOrBR0RC4TLKpc738AKwyYTaCZ3XX7qebKUboShrIjnd6cGEpvhP6D3W0W986ZSe8NKaZJfednKiEX2RShSVOPI30AMTKtoubEbgWCLhAbbVAk3xzYeGq/6NZ/zqOWdtBVtFdFvSN7Hbu0hTew7eQfZ+tclEGOygUs8jDHgc7
 53FxkwV/
 ZgyMdXFx8ne6dVJpnMUIfnSXqGcGn4ftp5uHsul4th4t+mGx304dXJ5h5yidu7uJc2w0hKzOfkiBBocy4AS9ELffnB73OY/dFKAuib7Znm9odRJeX0xNGre++0u71ZfvFQrKzNmqKsr0IXc9dTHSBBwxonA0/Guw1PgYEjKjotNQ9+8/fA/tuEE3aJ9KfxJKRBh9sLtBDHt4H1kuVboTf3Z7bI95JYquCfdcF/wv/Wyrw6DdKA+bEn40Q/1fRuO7kFYkqznLFs5d/okf64l3QQDYC/gGyoUKtvAV7+7RXznd1DP2GrhAW/BF2gWoC8IGHiKM0mbS68nLUQpjXhmywWdGSKG3/Tclsj3RfF5eIvGKfB/HOrZFmCYsVCg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 20 Feb 2026, Kairui Song wrote:

> Hi All,
> 
> Apologies I forgot to add the proper tag in the previous email so
> resending this.
> 
> MGLRU has been introduced in the mainline for years, but we still have two LRUs
> today. There are many reasons MGLRU is still not the only LRU implementation in
> the kernel.
> 
> And I've been looking at a few major issues here:
> 
> 1. Page flag usage: MGLRU uses many more flags (3+ more) than Active/Inactive
> LRU.
> 2. Regressions: MGLRU might cause regression, even though in many workloads it
> outperforms Active/Inactive by a lot.
> 3. Metrics: MGLRU makes some metrics work differently, for example: PSI,
> /proc/meminfo.
> 4. Some reclaim behavior is less controllable.
> 

I think this would be a very useful topic to discuss and I really like how 
this was framed in the context of what needs to be addressed so that MGLRU 
can be on a path to becoming the default implementation and we can 
eliminate two separate implementations.  Yes, MGLRU can form the basis of 
several extensions that are possible, like working set reporting, but its 
existence in the kernel shouldn't be based on future shiny features alone; 
I think priority number one should be ensuring that these issues, as well 
as others, are properly addressed with the goal of having a single unified 
implementation in the kernel that does not regress for end users.

One topic we can add here is oom handling with MGLRU, so adding in Michal 
and Shakeel.  MGLRU has working set protection to avoid thrashing by 
configuring min_ttl_ms in sysfs.  That can end up being very useful, and 
would probably be even more useful if there was a per-memcg version of it, 
but it doesn't work well for NUMA.  That's because we get a new oom kill 
context that is triggered from kswapd threads when aging is done, not by 
direct allocators like we're used to:

4167)	/*
4168)	 * The main goal is to OOM kill if every generation from all memcgs is
4169)	 * younger than min_ttl. However, another possibility is all memcgs are
4170)	 * either too small or below min.
4171)	 */
4172)	if (!reclaimable && mutex_trylock(&oom_lock)) {
4173)		struct oom_control oc = {
4174)			.gfp_mask = sc->gfp_mask,
4175)		};
4176) 
4177)		out_of_memory(&oc);
4178) 
4179)		mutex_unlock(&oom_lock);
4180)	}

That obviously just calls into the oom killer without any context about 
*which* node we're trying to free memory on.  The worst case scenario is 
that we oom kill every process on a single node without ever freeing 
memory for kswapd's node.

So I doubt that anybody is using this to actively defend against thrashing 
today, at least on NUMA systems.

One way to address this would be to consider resident memory on the nodes 
included in oc->nodemask when making oom kill decisions and then 
initialize an empty nodemaks here, sets pgdat->node_id, and passes it in.  
But it should be part of a larger discussion about how we handle targeted 
oom killing on specific NUMA nodes that would be applicable for cpusets, 
mempolicies, etc.

For cpusets, for example, we only look at the eligibility of a thread to 
allocate on a node, not the amount of anticipated freeing from that node 
on oom kill.  We could trivially do the same thing here for MGLRU, but it 
would kinda suck to go around oom killing processes that only have a 
single page on your target node.  (But, hey, better than the status quo 
today here!)

So we should talk about node-targeted oom killing and how that would make 
sense so that we can wire it up here if min_ttl_ms is to be used for 
MGLRU, at least for NUMA systems.  It's a tricky problem in oom contexts 
to be able to get at the information, per thread, that you want to 
consider to determine eligiblity but perhaps even more of a tricky problem 
when you have that information about what heursitic you use to compare 
processes with lots of memory on the system vs lots of memory on the node.

Has this been considered before?  For kswapd induced oom killing like this 
to work, it would have to be solved.

