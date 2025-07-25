Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43ADCC87FCC
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 00:45:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C548E8E00D0; Thu, 24 Jul 2025 20:45:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C14D08E007C; Thu, 24 Jul 2025 20:45:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B524C8E00D0; Thu, 24 Jul 2025 20:45:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A51368E007C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 20:45:04 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 52E0F1A0333
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 00:45:04 +0000 (UTC)
X-FDA: 83700942528.21.4D19AA9
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf10.hostedemail.com (Postfix) with ESMTP id 9949CC0004
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 00:45:02 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Mx4P75kK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of tj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753404302; a=rsa-sha256;
	cv=none;
	b=xZIcUWnUslwprcoom8JvXQ43m/0r/JaeFjEbP+atNZ3cfpv+T0Wqs2tz8pKAS94UNJpP8n
	aqjTuP4q6hYweS6SmMPjdCjnCQw0gHQDA0Hua86knzv9d9SDogt6EdgSKPKDULjThpsdc+
	D7Fa/PmUHRR43+f/6HnWptjckCwKbG0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Mx4P75kK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of tj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753404302;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gE99b4ZnSyea/VzCZeIPyKJzK2bS7p039WOOhhlx08g=;
	b=8d01vWTivFti0jz9JD8FSEFNpFm3YNiXgzkgxrFM6cDm1ibXrOZwtBcVjtbjFYplVJ5j6o
	ofB9OJz9LRgktnq9pxyfkH86V8lxNblNwX3ejAIT/08zWZtLkEDFHdyhNsT20I1xRDiQz4
	jY6asIP6p2iHCdqXZYx5mEK+uzwSrX4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 5FC375C6956;
	Fri, 25 Jul 2025 00:45:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBA47C4CEED;
	Fri, 25 Jul 2025 00:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753404301;
	bh=dvzxxFO1gaX+9xGTWwgKBCgV2b2CxVSK7tOnwNJFUio=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Mx4P75kKdF2V/aTgUjzyLBGy6f2MxQkesu7J3yxq3vEfAcB7ES6M60ybBRTtdBoS/
	 jolS/1xxvErQtFnIo0OQZVGIMAEjrOal3WiqWUDZP6BbIWS/Ila/lyf2dC2nSf/Gbj
	 rq8WPXzQ3J5oTC62KScmoUJoOOZOcXtNfQOCRDNghJKTyrwUPsfByokTTShdldhSI6
	 ECrRz2veukkxssSq5AZPpWLseG8RxnO6UYjaU1lOpUkmRmGCHJFftVhjulI39Eh4fj
	 9neuKi7uot7S9R4FfwgtPHW9x2iGksCBRuTYjcBfB3adZMD8a1hBTI2Ym4HkHU7y9e
	 l6dOJgW1jksGA==
Date: Thu, 24 Jul 2025 14:44:59 -1000
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
Message-ID: <aILTi2-iZ1ge3D8n@slm.duckdns.org>
References: <ni4axiks6hvap3ixl6i23q7grjbki3akeea2xxzhdlkmrj5hpb@qt3vtmiayvpz>
 <telhuoj5bj5eskhicysxkblc4vr6qlcq3vx7pgi6p34g4zfwxw@6vm2r2hg3my4>
 <CAAVpQUBwS3DFs9BENNNgkKFcMtc7tjZBA0PZ-EZ0WY+dCw8hrA@mail.gmail.com>
 <4g63mbix4aut7ye7b7s4m5q7aewfxq542i2vygniow7l5a3zmd@bvis5wmifscy>
 <CAAVpQUCOwFksmo72p_nkr1uJMLRcRo1VAneADon9OxDLoRH0KA@mail.gmail.com>
 <jj5w7cpjjyzxasuweiz64jqqxcz23tm75ca22h3wvfj3u4aums@gnjarnf5gpgq>
 <yruvlyxyy6gsrf2hhtyja5hqnxi2fmdqr63twzxpjrxgffov32@l7gqvdxijs5c>
 <878ca484-a045-4abb-a5bd-7d5ae82607de@cdn77.com>
 <irvyenjca4czrxfew4c7nc23luo5ybgdw3lquq7aoadmhmfu6h@h4mx532ls26h>
 <486bfabc-386c-4fdc-8903-d56ce207951f@cdn77.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <486bfabc-386c-4fdc-8903-d56ce207951f@cdn77.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9949CC0004
X-Stat-Signature: pfkjo9rejyy8k6ztofjx3xkiqthr1akx
X-HE-Tag: 1753404302-27861
X-HE-Meta: U2FsdGVkX18WqOSNKSSConrOHGSnuvKHGeyG4HwgsCvZk7JeGJTal2Gfnm7Takwfuq5IxnWFd5Yvin9n+vmABN6czoO9JcA2YfUDMYeSmI6C6epbgHNHw8FuOtlKDKxuH3B+IUyaYhGe08YwPJeueklATOqPbmjxGxpRmdjCCagne5VfBFDrQe9vBpqJ+OGt91Rpv5fHTDOAsnzVXKECzjGzpWZ+rmJJL2RgRSts4B7pD0mobsRBPsebMFasntgsUcE4jFdMJpelEe8fc63p8+O4ObVAtwFKiffI1Fkrt4YT5WPBi4SKpn3ficUAZpeyn83GVFR79RPGm3Ls2zcmVCjZzT1D4hDU5SSOrggC9ip963K9mZfUovkJhlwOpn1CvNVIaTUT5FIKWKef8V4cIvH2baY5vFqyFbHC1isWPIzjAZQTyQqT9REJS3Bts6AL/gX1ogwVwKtgmMFHutXudunqmDqX/3+/ndpxYX0AqhHmLFcdNtX/mex5nTaoHM6Je66xLd67l5ex+TTNP2mBAhhuccEy2lZW8zC1Pk0kSRIOdeOv0of5asx3n99BhS+AyC0nIag5c5m+DSLso8Z4xAFfbxnQIfp5tW6eAHFMxNFTx5uC6j6YniRfx7cBNqFPZsxZv13MxDhmgv+Nrlebc/9DAUYRu7H475jGM0LPqLhcasGHOlLcYQ0mNdJzPjeMm8I2PV06YDJTg9jmdHxf0OWQFL4EZNF7jdWTy1C4xZGz2Pb7c8Bf3Ey3I/t24NoJlvVL3gHIEslJE8CC+62KCWR/xYg0wfhu+R6HfK5UJiguVysRE61bUj7xy0GSYw5B7B+9bAlpLYTC5tgTd7Q2qEzRIyh7gJ79Z+ZUh2RxeuHGGFQJE8Hd5x+awlry41qgPA7FUAsfx1+V91s5Werg6pZ2U3A9zHCtLCvNqXozj1Bnet9uxinggrlTqGydC5pfLrnPnK74jeCwUwS2Mfg
 v/MqJvDQ
 9kHud61slbEpbciKiyvnRKHgk/A5PydEF7GrpGYmrEkFiZL6IzWhrPcOTMUspiOnSJPXupcxuZzQ2UoXUnbvzQSF+I2p+L1lLVV/H95Q1Mohx1psY+fe2govZZbyJz/mRGjdPx0DSIFpD1xCZTNmVC/VskB47+bGnhrmOvU6QDzIQPmF81RLm6HigCdDkQXcVrbCDGjFf4ncP3/TR98WAI67L4A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 24, 2025 at 10:43:27AM +0200, Daniel Sedlak wrote:
...
> Currently, we know the following information:
> 
> - we know when the pressure starts
> - and we know when the pressure ends if not rearmed (start time + HZ)
> 
> From that, we should be able to calculate a similar triplet to the pressure
> endpoints in the cgroups (cpu|io|memory|irq).pressure. That is, how much %
> of time on average was spent under pressure for avg10, avg60, avg300 i.e.
> average pressure over the past 10 seconds, 60 seconds, and 300 seconds,
> respectively. (+ total time spent under pressure)

Let's just add the cumulative duration that socket pressure was present.

Thanks.

-- 
tejun

