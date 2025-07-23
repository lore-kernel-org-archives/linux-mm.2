Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E327C83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 08:58:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98CFB6B008A; Wed, 23 Jul 2025 04:58:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 964626B0093; Wed, 23 Jul 2025 04:58:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87A576B0095; Wed, 23 Jul 2025 04:58:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 724026B008A
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 04:58:18 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 348DE1605C8
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 08:58:18 +0000 (UTC)
X-FDA: 83694927876.17.95E6CB7
Received: from mail-internal.sh.cz (mail-internal.sh.cz [95.168.196.40])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3C839140010
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 08:58:16 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=cdn77.com header.s=dkim2019 header.b="aYZzS/O3";
	dmarc=pass (policy=quarantine) header.from=cdn77.com;
	spf=pass (imf09.hostedemail.com: domain of daniel.sedlak@cdn77.com designates 95.168.196.40 as permitted sender) smtp.mailfrom=daniel.sedlak@cdn77.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753261096; a=rsa-sha256;
	cv=none;
	b=MORWS0y3gLJ7I79rXB0DC0E0oSvTSUkbhTDCvoqW/bZwg12h2T76PkfUYqCIyrCErA0ZP0
	VCqeVaqm24ZVYnAu6pNOr0lmnbXX2SmheYY7wYrTVIpENX6BxzdWQQUTz3i5c062ned/vm
	5L6q3weiTayPCq2rwmlAfnDOFn2nrIU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=cdn77.com header.s=dkim2019 header.b="aYZzS/O3";
	dmarc=pass (policy=quarantine) header.from=cdn77.com;
	spf=pass (imf09.hostedemail.com: domain of daniel.sedlak@cdn77.com designates 95.168.196.40 as permitted sender) smtp.mailfrom=daniel.sedlak@cdn77.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753261096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qlvvdL23jI5cq5kK00WWJ2ZXbCbxmnFqWOhjy1ud0KM=;
	b=NGB3HoGiG7v+J31aJVKYSNQrPShILQS8xnNdbcQqdtD3vWfgDBd8wIWPSe5mkUQ5ph7MJA
	zXv5+xMtDdEaTIzzNTowX0+69TAtNSFhD5QemZBGXiDdtbs8qQKEPYzT6PFsNu3UexVlPq
	HFvXcEu+5rWpJsCNYClXQACa0iqFuQQ=
DKIM-Signature: a=rsa-sha256; t=1753261092; x=1753865892; s=dkim2019; d=cdn77.com; c=relaxed/relaxed; v=1; bh=qlvvdL23jI5cq5kK00WWJ2ZXbCbxmnFqWOhjy1ud0KM=; h=From:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References;
   b=aYZzS/O3GfR/K3vWLe49gCjzaBG7alC51w2ImiZpsGS1aYHJSPV7OOU7xdTJxvlrQ37+tm/yVdGPQjZ4BYwRncoiXfc/jTXXQATheYM3dRRtznNFPjEcKO8w3XqUVXJUQ0HDZOHhTbCoCumjS1QaEIoA72QUtvB3mRFfguAzfJY=
Received: from [10.0.5.28] ([95.168.203.222])
        by mail.sh.cz (14.1.0 build 16 ) with ASMTP (SSL) id 202507231058116534;
        Wed, 23 Jul 2025 10:58:11 +0200
Message-ID: <878ca484-a045-4abb-a5bd-7d5ae82607de@cdn77.com>
Date: Wed, 23 Jul 2025 10:58:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] memcg: expose socket memory pressure in a cgroup
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Shakeel Butt <shakeel.butt@linux.dev>
Cc: Kuniyuki Iwashima <kuniyu@google.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Neal Cardwell <ncardwell@google.com>, David Ahern <dsahern@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Yosry Ahmed <yosry.ahmed@linux.dev>, linux-mm@kvack.org,
 netdev@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org,
 Matyas Hurtik <matyas.hurtik@cdn77.com>
References: <20250722071146.48616-1-daniel.sedlak@cdn77.com>
 <ni4axiks6hvap3ixl6i23q7grjbki3akeea2xxzhdlkmrj5hpb@qt3vtmiayvpz>
 <telhuoj5bj5eskhicysxkblc4vr6qlcq3vx7pgi6p34g4zfwxw@6vm2r2hg3my4>
 <CAAVpQUBwS3DFs9BENNNgkKFcMtc7tjZBA0PZ-EZ0WY+dCw8hrA@mail.gmail.com>
 <4g63mbix4aut7ye7b7s4m5q7aewfxq542i2vygniow7l5a3zmd@bvis5wmifscy>
 <CAAVpQUCOwFksmo72p_nkr1uJMLRcRo1VAneADon9OxDLoRH0KA@mail.gmail.com>
 <jj5w7cpjjyzxasuweiz64jqqxcz23tm75ca22h3wvfj3u4aums@gnjarnf5gpgq>
 <yruvlyxyy6gsrf2hhtyja5hqnxi2fmdqr63twzxpjrxgffov32@l7gqvdxijs5c>
Content-Language: en-US
From: Daniel Sedlak <daniel.sedlak@cdn77.com>
In-Reply-To: <yruvlyxyy6gsrf2hhtyja5hqnxi2fmdqr63twzxpjrxgffov32@l7gqvdxijs5c>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CTCH: RefID="str=0001.0A002105.6880A424.003C,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0"; Spam="Unknown"; VOD="Unknown"
X-Rspamd-Queue-Id: 3C839140010
X-Stat-Signature: tq7ba4665mjfentfiqd4csak474e18kf
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753261096-896807
X-HE-Meta: U2FsdGVkX1/24GfFdNrJipc7/iTtKv52DTChboDh//LztPQ46NcZAM0plzDKKZiLxPtNXtjcUZVehjGs2hjFA8va/IZC2lVkenzxHc97y5m9JwHNTabKkoy2qNOt/K45i6guZKMjrL8f3Jz66cdYSAq0J17laWt96YnMmvNdHtGq4rJJMyH3LVBpL6iV+HRRF08+EM+ANz/hMLMllKV9OQNuYa/YP4Jw9QRyASFfEHdhCzvgS5O6n39ZYJXFTWrPcpLnu+OLSIeKB+jiWUqWFxtYMS31NEDrf9uhxA/J9xDbDo+dlEZJZ9S7k0Y6+Q5H0SCGQt/LNZf1x7NA2Ha8PuozrzsNYCkY0rt9Gow1BjD/dHAKqr6v5ZumyMCFQoxNERNTLavsfSlsad9gFkHqkJud/honvJ8JqGHO656iBFQnkOO13YjuLFswrwrBywdEeZOEZT1B11GAIp6n5SVndI1WYs0wFlpUZjPR3KU7FUDEPCyZ9yffn61TolR/khjQ5G/ClG/+y2cjpJLdQlZZ1SgaMg8CDyQ6neInHa0p+I1+S3N1AbF4h3FQxSFQUDL2RfZeHyEX5iF2XVSycBCHbUUFpbAa7sfn26CecYS5unmk04trAblZPRf6ZVAd717X7IsRi2nWc3gq9Nn8+No2WTplaE4/WWOYHg+pcawm7OejFTev4CzKQL4sIP32z/YqpPwqwn5838q+dDSZxeqOZkdMP9dVje4y4UGaalAysPpKDQVCz0TAPz3dwm9SM2gnTFvYg3LQ2sVuMnR8GsZwAulxPqsox6CDmowZm9yEEgR4G+kSmMzVP2tdyKjhlSWm7BRjgoniSl5W/NB3QMlVIQMtLgU+Wwm3PfDfRaMHNJxB4Xce9FEGyhJweUa7gy/dkC5mBW1HtzYmFbG0WDNO3BZts7L09nMf1h7h0XIVRd4sCWtf2O48Al8nbLRMFoxw3GgO4xjxh5GBdaklMco
 F0xtizQ+
 6850NwAXNKc3GtafZkTo8f258LTzIbUMBAjb+nv1En7CgqLswXO81rD7tYNkQj9cGSfJ99cnDVZXFEywc3Rp/eI1Y4QPnMPAI/LLrN6WPGUd1dezPsH/6yWresYFegP5trjJVsdBC/uT1a+2PxqKAMkt2anG++o47VO2u1fEA+aYmCeMQ0/I53OoWCz/6MSRPMDlP8koihT26AP+mwxsg4Dogl0wezr1L4tHh3Vh1H1vwL8M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/23/25 10:38 AM, Michal Koutný wrote:
> On Tue, Jul 22, 2025 at 01:11:05PM -0700, Shakeel Butt <shakeel.butt@linux.dev> wrote:
>>>> 1 second is the current implementation and it can be more if the memcg
>>>> remains in memory pressure. Regarding usefullness I think the periodic
>>>> stat collectors (like cadvisor or Google's internal borglet+rumbo) would
>>>> be interested in scraping this interface.
>>>
>>> I think the cumulative counter suggested above is better at least.
>>
>> It is tied to the underlying implementation. If we decide to use, for
>> example, PSI in future, what should this interface show?
> 
> Actually, if it was exposed as cummulative time under pressure (not
> cummulative events), that's quite similar to PSI.

I think overall the cumulative counter is better than just signaling 1 
or 0, but it lacks the time information (if not scraped periodically). 
In addition, it may oscillate between under_pressure=true/false rather 
quickly so the cumulative counter would catch this.

To me, introducing the new PSI for sockets (like for CPU, IO, memory), 
would be slightly better than cumulative counter because PSI can have 
the timing information without frequent periodic scrapes. So it may help 
with live debugs.

However, if we were to just add a new counter to the memory.stat in each 
cgroup, then it would be easier to do so?

