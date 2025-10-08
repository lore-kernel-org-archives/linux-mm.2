Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E71BDCCA472
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 12:46:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4F648E000D; Wed,  8 Oct 2025 08:46:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D26D88E0002; Wed,  8 Oct 2025 08:46:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C63CD8E000D; Wed,  8 Oct 2025 08:46:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B64888E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 08:46:30 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AA8F787B92
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 12:46:29 +0000 (UTC)
X-FDA: 83974920498.02.A523EA0
Received: from mail-internal.sh.cz (mail-internal.sh.cz [95.168.196.40])
	by imf06.hostedemail.com (Postfix) with ESMTP id 39E8918000E
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 12:46:26 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=cdn77.com header.s=dkim2019 header.b=JDPCBdIo;
	dmarc=pass (policy=quarantine) header.from=cdn77.com;
	spf=pass (imf06.hostedemail.com: domain of matyas.hurtik@cdn77.com designates 95.168.196.40 as permitted sender) smtp.mailfrom=matyas.hurtik@cdn77.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759927587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YsJun95Wxhwf/ur9MneaPmQvhR6RH8R5auchgi1X7Ng=;
	b=p4OtEUzeIt8zB0KrC9OvnKZapWJutx8XccBG5+SOJO8YRguembRiPsnvwFjN50m9IVjmK/
	EkwCj8Yw9IYokEliLJjgjBm6WRARe8IndDjuuUMzo2sfADxf1AbT3LAS3fGCxZXTv5noN/
	2TXZJBoHbwVrO3vPs6pNzj9jBLsXZZI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759927587; a=rsa-sha256;
	cv=none;
	b=Zk0MfOPNM4jZe0RZNtC6tQEoa4aMaM8A2O/tC+dZpF9D2ztg/OehPga77dlLEfNsMtm14v
	NJVGuric3KAP+0cm0oZ3Qunkv9HnRTQ2Us5Q1g089b4b8O/hOk13Ai1FyuXYt4C860A5HC
	RkqGEnzSyMEku60AB71iDgsscRY5VoI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=cdn77.com header.s=dkim2019 header.b=JDPCBdIo;
	dmarc=pass (policy=quarantine) header.from=cdn77.com;
	spf=pass (imf06.hostedemail.com: domain of matyas.hurtik@cdn77.com designates 95.168.196.40 as permitted sender) smtp.mailfrom=matyas.hurtik@cdn77.com
DKIM-Signature: a=rsa-sha256; t=1759927585; x=1760532385; s=dkim2019; d=cdn77.com; c=relaxed/relaxed; v=1; bh=YsJun95Wxhwf/ur9MneaPmQvhR6RH8R5auchgi1X7Ng=; h=From:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References;
   b=JDPCBdIoNeGiQm2XgBrPzRm1JA4dH2d+wbkdxjyXuiLKON0wMnxiV3hSDcXJvM/cqQltBzkVLBC4+EwMbH2NBg5qdQMkMm0Oh3Hcc1dO3WWd10o9PIdC0aWRP2+3wrqy1lzVJtjk7gOa29oc1EEy+hOerDNGcGSMabahNOv1kZw=
Received: from [10.26.2.242] ([80.250.18.198])
        by mail.sh.cz (14.1.0 build 17 ) with ASMTP (SSL) id 202510081446246620;
        Wed, 08 Oct 2025 14:46:24 +0200
Message-ID: <6cbf24f6-bd05-45d0-9bc8-5369f3708d02@cdn77.com>
Date: Wed, 8 Oct 2025 14:46:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] memcg: expose socket memory pressure in a cgroup
To: Tejun Heo <tj@kernel.org>, Daniel Sedlak <daniel.sedlak@cdn77.com>
Cc: "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>, Neal Cardwell <ncardwell@google.com>,
 Kuniyuki Iwashima <kuniyu@google.com>, David Ahern <dsahern@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry.ahmed@linux.dev>,
 linux-mm@kvack.org, netdev@vger.kernel.org,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
References: <20251007125056.115379-1-daniel.sedlak@cdn77.com>
 <aOVxrwQ8MHbaRk6J@slm.duckdns.org>
Content-Language: en-US, cs
From: Matyas Hurtik <matyas.hurtik@cdn77.com>
In-Reply-To: <aOVxrwQ8MHbaRk6J@slm.duckdns.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CTCH: RefID="str=0001.0A2D0331.68E65D20.0068,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0"; Spam="Unknown"; VOD="Unknown"
X-Rspam-User: 
X-Rspamd-Queue-Id: 39E8918000E
X-Rspamd-Server: rspam02
X-Stat-Signature: gbh96si5gq8bettn6z9sadeaetqzudmc
X-HE-Tag: 1759927586-985548
X-HE-Meta: U2FsdGVkX1/oA/LlcgiSKUGiLBZVEid4mLvZbWZ6GVWNFAFp+QKTysBXTbL3p8v8E0e8Uqy+vDwipSMBXh1lR6ZMRV+HznZAfrqzjHStpng31xZoWwMKrMeP6uIaz2uV1AfMqZWYkPTKBJkcGY46vEjga79nvhlDwkbwXO859fqggl9eoDbL8S6AyJey46DC/p0+K4ZwjJaWlYXH53Qr1obGKrnnL4HTN3oPYrN2QiO1ZL0BYl+7jOTcPy2Oi3sHIR+iC3VcFKOXsdUMdN6BgxosdboSSanAGWagY1EPBi5kOvBHdn+csoEMin3k+raLqiWcuFvicDm5T7F7b5E8vGMqFtApG2/ys+6jDvCAfp4BtUbhb22/LeHQc20+TqUq9FOvrANg0qES0Bx+N2+q4RbeIIivWaotIZBWnleZ53mo9y5DhlvplwLyoaXz1pN03RUld5z4qxjombjVHUXJez0tR57xyRjqBZvsQEKj2IAV1yzgB31iNK4WyHV7cPmvyFIpUwifm9BooLYNyFSHCbu5YTs3GKymFfntIm00/tl4KGUm7Pd5PjcRugprU41p/4L0yk+powzmA+wMr3k/s8TpiTroQ9At9ByWZA2+ETqwkFPjRVywas4F90Z0wOxGImWKCjz3XK+Tpry0itV7c7IX+Pw9VZkK3ykfeXBEwoN5/gjQPJes6YgXpk2v4lm0gloDcEzC5ozUk7WGX7RIzr+HdoOJsFLr7I5LFblO4FwyG2tx5CFJq9KeAI4pFYLXPfAxMGdABP9VtCVsVrNgh39VhGBQ2kaz+kIEU81h45rRbOfoPWueHO/KpkJYAdYsbEZEJRbUzHKij5GfE3JpcnLm1yfFbLt4fH5HNFk15Xa3IEqw/XDBHtq5ZfUWXHKKPDbQEeN+9UDe/ouTRDSI80m8kNQR9mZEDIZgvv3yhl4UQxcysFTSwuEAwHjVncMPCKpwJKYLhu2vrcMTIwf
 gKBuXNvA
 bCskdf79EkOZvt8YbdMlo0V4MGu2wt/yPqntNPEbq3polAC5/3uOo3c/Jxqs1GtMvu+FFeYd9VYzkBrRvJE6ClBZHg4uLhQx+rQPvZZh6gU20oZg46XBtwruemPwu+RszZB2D3tUWB3pFGUj4UgeO1cR8Ma4vP4Kyv+/i7eVXwzwhMbkGFNktf6ej9vLLu5dtasLA+bwHVrqssm2EXapIVdvoTKJC04Ki4n63at3XgwoNDfU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,
> I'm not against going 1) but let's not do a separate file for this. Can't
> you do memory.stat.local?

I can't find memory.stat.local, so should we create it and add the 
counter as an entry there?


Regarding the code, is there anything you would like us to improve? I 
had to rewrite it a bit

because of the recent changes.


Thanks,

Matyas


