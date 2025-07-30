Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EA75C87FCA
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 00:15:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89B836B007B; Tue, 29 Jul 2025 20:15:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84C4A6B0089; Tue, 29 Jul 2025 20:15:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73B266B008A; Tue, 29 Jul 2025 20:15:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 60F0A6B007B
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 20:15:48 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DE4421D9427
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 00:15:47 +0000 (UTC)
X-FDA: 83719012734.04.D530A3D
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4863940005
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 00:15:46 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FxtYG9E2;
	spf=pass (imf12.hostedemail.com: domain of tj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753834546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qtYAXr3+9Jq+HdHeCQog+zNzargoNh7EAO9QXbzgNLo=;
	b=KJjcm5Y/qWXBKyRpDBZbVOOEwqoN0Jo4RnAv8CWaldp51MYke4qUY8y18v9Izc83eGtnju
	cVwnWio5KEvOOAKYBvTXvLHCfKjmLeREO9CICDctRf62xBCY0h+vr1ThFgGxcFJZdkiyoy
	8j13zz7AmjXSl2l1PM+anp45dGms8FY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FxtYG9E2;
	spf=pass (imf12.hostedemail.com: domain of tj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753834546; a=rsa-sha256;
	cv=none;
	b=VHkFDYRehpeF1ja6bQp8vIXIN+3OHn4fp89Vjph7S+FR6PNRhc8W6UN9XoJr0nXumEp2oJ
	O2Vm3kojKVlQGMQGT20OfmTXd1kp29ZFNe4sMMnDAK1ymf8N620H3FS4QtLvdLn/Duhssv
	R9238t8wOAWFckapsVZkjZZO5Pe8s7o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 4C05B5C4D5E;
	Wed, 30 Jul 2025 00:15:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1E35C4CEEF;
	Wed, 30 Jul 2025 00:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753834545;
	bh=/IL8wmq+lOfAOx4ojeLTp4+XN3Okds+fOFj21+eklGM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FxtYG9E23WOEWELbkklCmxuL7KIqwx5IVWa0qXcWHnsLD3l40Y8GiejBlbRH+pmfx
	 ajucUIRd+AQxoF6UrKLR4jozCnIS2AcobpcoOxG5ev1G1fj8CpgFQD7BF779tBSNDH
	 RkloEKhmTdoI32GKc3sUaSf60Iz5LSzpg5/pawFHn0go0rgZ4oiEU4/U70TIQXajlM
	 LPVojjAkJz3EQFiAdYmRbv6BCyCXl0Lv3Y46tI6uDDwTDISfbK1NTqEN62+TYCSOhg
	 7x1B++x/mku8g5a5/CIafTpkyeh3UDn6xYIHpOR2VKozK1SghUKPDLhMg8Z10RxemJ
	 Dze+B39NhWoNA==
Date: Tue, 29 Jul 2025 14:15:43 -1000
From: Tejun Heo <tj@kernel.org>
To: Daniel Sedlak <daniel.sedlak@cdn77.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Neal Cardwell <ncardwell@google.com>,
	David Ahern <dsahern@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>, linux-mm@kvack.org,
	netdev@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org,
	Matyas Hurtik <matyas.hurtik@cdn77.com>
Subject: Re: [PATCH v3] memcg: expose socket memory pressure in a cgroup
Message-ID: <aIlkLxDMT6keDJAC@slm.duckdns.org>
References: <CAAVpQUBwS3DFs9BENNNgkKFcMtc7tjZBA0PZ-EZ0WY+dCw8hrA@mail.gmail.com>
 <4g63mbix4aut7ye7b7s4m5q7aewfxq542i2vygniow7l5a3zmd@bvis5wmifscy>
 <CAAVpQUCOwFksmo72p_nkr1uJMLRcRo1VAneADon9OxDLoRH0KA@mail.gmail.com>
 <jj5w7cpjjyzxasuweiz64jqqxcz23tm75ca22h3wvfj3u4aums@gnjarnf5gpgq>
 <yruvlyxyy6gsrf2hhtyja5hqnxi2fmdqr63twzxpjrxgffov32@l7gqvdxijs5c>
 <878ca484-a045-4abb-a5bd-7d5ae82607de@cdn77.com>
 <irvyenjca4czrxfew4c7nc23luo5ybgdw3lquq7aoadmhmfu6h@h4mx532ls26h>
 <486bfabc-386c-4fdc-8903-d56ce207951f@cdn77.com>
 <aILTi2-iZ1ge3D8n@slm.duckdns.org>
 <924a8a12-ed89-45e5-900d-6d937108ec3e@cdn77.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <924a8a12-ed89-45e5-900d-6d937108ec3e@cdn77.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 4863940005
X-Rspamd-Server: rspam06
X-Stat-Signature: tfwaxgffayuupm8ifktgi39emxm8sbi9
X-HE-Tag: 1753834546-884497
X-HE-Meta: U2FsdGVkX19oO67Q9U4AWGnzzTIO34Ye1oUkmAw4HQh2vUK98SuqY4euGf9UuTKYaEqSJsHYy5gVMCE/eMzqbXbpAFWLzEm6H8yWtVI55A90Yg7PPusZtnCCU8gLoq8UqhSGhTqTAo1qy3pgiXaAsPqZpM3iPqM3+Q78vA724OkUt4nGuz6F+lTENpgCAGtAupYh+l3IB5jOl0QVUA19OS3fyfs/JDmzb4T2zUkq1/WekoI5n7QhWqJAAJ5GwgE/0IOes1Dt00QfaA7MBX4aXDOQsLGAHU8PAohsfJLzmlynR2iI0x/YHrQqU2Zsjv/mXPFrofbby8nu4ERkfJI8PfftwmU8hxK+THdAMc3898KWeCaBuxGY4yldaVeuwMBLgQqbsoAsCulQgR2ww1/L6phfAJ9Z+pPNq0xuRP/1LEvg2qZVg6B3tIGx58JIPerqUbMAN82yKpXd0wOwhqS+ZdPdjPjWJP8zIYdyyNvhu/AYZzm4p6I58OIrFozsx1/LohJ4fkkYOr/pLYo5KaiXU8SzeWopVpocHf0SY/G3rLQActzTpo6WOPVpfhcX0l4NZp5ay10vD/wjr0g66j8HmEYS5x7A78+RiiynY45IgBTp7GMgButPifWRrwb+BhX/Nxvalv7FenKS/3qvw58Udf6PGjTf7uPXfM2GqL90GyHGPsNJgfzIG4nAVosRGEopvoVLw3I5/g6FEypjqXJsOCikglWzQlkEmuwVVEC4xtcbf6rFgp2ZxIna77Tf+0esGc344/eBtwyJgPueOmneRTnKVgLOUxBaVnZgZh5qLa72Eyd3gXGJRPmQFKgaUpTANoKpMMbCflrjCm9Ro1pfju5yjHomTE9K2eLmRxX03XW+PPAE7HV385h030/+8ilPQl7tGBg2omRlx7/IFDAQpnISZ0DFr7aLgfiqClx95j1ZXX+OpVSs5HEgnN17j0cmBFvXvrDCcaFT+DuIID4
 /mkhG1cf
 XkWQ14hzGuvTImsAFZU+O3cilu5HGezkIa7yUAnvohzEsXKWxVJ1ZtqEvclOvPHeBoajKl7virEsUVAaEwY4Ph0LhtRLZBx2URdL1vcmiktBWhm6uglHbrur9uFg5NS9pQ7WrU19bIE+g9JL10MzD6Uzx0SziehMPYpIaxInn5qJOM9S5b5V+b93suT71N7d1G6sXixcKYKtczqDl5+3Zn1EQTw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 28, 2025 at 01:29:29PM +0200, Daniel Sedlak wrote:
...
> Ok, I will send it as v4, if no other objections are made. In which units
> the duration should be? Milliseconds? It can also be microseconds, which are
> now used in (cpu|io|memory|irq).pressure files.

Yes, microseconds.

Thanks.

-- 
tejun

