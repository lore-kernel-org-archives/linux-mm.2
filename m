Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA7F5606A326
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 13:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RS/KgQmr
Received: by kanga.kvack.org (Postfix)
	id 0318D6B05B1; Tue, 10 Nov 2026 08:56:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F24B06B05B2; Tue, 10 Nov 2026 08:56:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3B9A6B05B7; Tue, 10 Nov 2026 08:56:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C6AC56B05B1
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 08:56:09 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AE5481208CE
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 13:56:08 +0000 (UTC)
X-FDA: 85419358416.07.802FBA3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1A4F210000C
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 13:56:06 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="RS/KgQmr";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of dakr@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dakr@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794318967;
	b=1lf2feasNQlIFV9KSECigtHuwo6yUdqV6OBWBhM66OAFRrmp+kihjV+KhXhwWJp5ctQJ+i
	2RGodSD4Bk8pDt4iyNR1C+KpOypiGa74j7/0/1MueoEddPzOsNgCr03db2wzGrwtQPzODF
	rbz3L3UJa8RuZRMufQ4JzykCvk0CdwA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794318967;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CYVCeh2uxfSFPv0xirYoRVJZdsUpsEprYDSIaHZqDVA=;
	b=W5/QSDvae1DmWv0WWEUZo4R4P0wANc+GDJB7iUbKOBHteiXWHfWUU+SGKrETsEpFMbMYnY
	UAPOs7dgKEMBDV4RKSkYU6gOvJ4AX/4zpgQodgVfvi/HhzzRIz09fMyKGq2ZlQ2qm+goGV
	MbSXjrWqifVDqO9tvRO+37ieVlJCU9M=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="RS/KgQmr";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of dakr@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dakr@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9672A611D2;
	Tue, 10 Nov 2026 13:56:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1071A1F008A2;
	Tue, 10 Nov 2026 13:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794318966;
	bh=CYVCeh2uxfSFPv0xirYoRVJZdsUpsEprYDSIaHZqDVA=;
	h=Date:Subject:Cc:To:From:References:In-Reply-To;
	b=RS/KgQmrp7lZSEi/at8qJaBKjsWgevSSR/P1c2Md8EZ4Ws8jxuN7MBUCmivrhnkXi
	 Ydf7aVVhV144CSCsgoNm1GaUEvG+b3NLmswMuNMmnLeXLxmvFtK4awq4lyu9RwxdeR
	 YL8Mp6p/TAwvuWgaPyR/J2QiH9Vi7nLFE4FJrrqWE0CkEfJ8nQ7DdVYsHs9LCaHYbG
	 wTx8WLNKeLMnqdurRgbFtyLaN+YA/6kxi9pnFOLZkK66dC7xjuBsXcE5uo5im7BND4
	 bAsqIekTHgt2aYaMADFtiLaZhpHzghVH237B3qZzVI3mb73Wsa2Nu49S1Hcc0NpmOt
	 IxucmEX+5Wo9w==
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 10 Nov 2026 14:55:57 +0100
Message-Id: <DMRKZHFKVKZ8.1ZCH8L9CDK07D@kernel.org>
Subject: Re: [PATCH 0/4] MAINTAINERS: remove my reviewerships, add CREDITS
 entry for THP
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Miguel Ojeda" <ojeda@kernel.org>, "Alice
 Ryhl" <aliceryhl@google.com>, "Boqun Feng" <boqun@kernel.org>, "Gary Guo"
 <gary@garyguo.net>, =?utf-8?q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, "Benno Lossin" <lossin@kernel.org>, "Andreas
 Hindborg" <a.hindborg@kernel.org>, "Trevor Gross" <tmgross@umich.edu>,
 "Daniel Almeida" <daniel.almeida@collabora.com>, "Tamir Duberstein"
 <tamird@kernel.org>, "Alexandre Courbot" <acourbot@nvidia.com>,
 =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>, "Liam R. Howlett"
 <liam@infradead.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>, "Johannes Weiner" <hannes@cmpxchg.org>,
 "Qi Zheng" <qi.zheng@linux.dev>, "Shakeel Butt" <shakeel.butt@linux.dev>,
 "Uladzislau Rezki" <urezki@gmail.com>, "Zi Yan" <ziy@nvidia.com>, "Baolin
 Wang" <baolin.wang@linux.alibaba.com>, "Nico Pache" <nico.pache@linux.dev>,
 "Ryan Roberts" <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>,
 "Barry Song" <baohua@kernel.org>, "Lance Yang" <lance.yang@linux.dev>,
 "Usama Arif" <usama.arif@linux.dev>, "Kiryl Shutsemau" <kas@kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
 <rust-for-linux@vger.kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
From: "Danilo Krummrich" <dakr@kernel.org>
References: <20261110-drop-reviewerships-v1-0-07c2f06e8dfa@kernel.org>
 <e1b0d6b4-f7ec-44df-a9f0-0e3a3722a973@kernel.org>
In-Reply-To: <e1b0d6b4-f7ec-44df-a9f0-0e3a3722a973@kernel.org>
X-Rspamd-Queue-Id: 1A4F210000C
X-Rspamd-Server: rspam12
X-Stat-Signature: bpkqerqa3xtdmdnzynrf89bq9qiiofmk
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794318966-132467
X-HE-Meta: U2FsdGVkX184wkMMnHZiXH8owryK1+lMjizE4VydoCKHeGvpN3Xdw+nIP4V+fDAlOye6oBtodkvI9hL9XlfVFm7/7f0ZDLWJEAQu2uxyuwsdIyGpwRcn+aIY8d/crELHG3GmC+uZNICrdO/TcFsRUSPYRbPoqpGbowXdMyVfnDqxLoQXqou3Tb/WX9c/DU6m37IC1dXH85mgonAGVyN6Fm3xsICU5d6qoRRIKrt2HrJu9aW7iU5peaEqk5rc5/pEBKs9qLFgYpqDlbsAZZ/MNJ6rpXyyF/PAIlHBMQtd1AREm0nyNR813EA9+8ej16Ynm8yeS86Dtqd1JeaDsOd5CHFN/+YRnbM+dkvKYvEh3EfS1xe8+CpM6d5wbTzT6uT82qYiSqavw0mbUBU46ccZnaVU0Wg9CiYJ7cBPHexF8JJntCE6cutCRnqyQWAdmMc+1yS5rVdtKpGUBnUCwnr6SXnuoj2h1u7kPLAvi0a5FBJzN60XBlG75oR2ZHZ+i2k+0RniEWM2/LKh2emdjGIs1sv5dEprJxkdKzIMw+EiZeMje2uJVry081RHGmvVXLGoVQ0QF9rGxqHwXb7rgLRmmpXZ9IHn1aHSgU5K7ErRtAF7kDdRVYVegohTkcJeYuhTi1Hfu83Pihru7PvvoUf667YCkuBC8JLxlatxLKwG59Dbj+uZYVEz1FC9v9Ma/Sm2Xbll1aCt5BHhKFF+P/DCy8g5iaM4o01GvIs1jVr8PNhvsdecmKEQML0Iu7LqydpYYJ5750NjapjsBg3kWNY1a5Utj2HBmrP1jhEWYqO84WX6aRo2ex7JLGdSFV255HtownP3lLZpejTPgK0Wfb2q9MGigrOnaX4iETg2NccJ4MVWqz4IVnS73yXBqqQi3sehIhtIoIb8OK3eoWBm1h/Rg0JmN7XTVQz7/Z2KFhbE5tIOlxuC71tnSKhVgmB2Jq6tNCT6wFSMXia3PbA0TyM
 bo5hg7av
 zdTrIe4aHIMZWjjl33A8aZnAmC/Dys5sWjvsKDBxsX9UMgYNhI0FK7Qb/kDFPn7t7x2+BS2KOUgTgxRGL1B521Pbj6bCKwvDWfbktq79ZWBDaO8ZSEu7+NEQBDNo4pTF2esmbsRfVzUEWypKiOTyXLl5o88r0+BGe3FhrT7Vzc24ZxvPtKX/7M5qe0iY69/elGMjlhzO835om7TnIi80rJdF46mUmpBSjZbHVPTRcJJhZ8jFDTv+LabFnVaNN9DwfxertDIwXx90p752VxFQk6HNldtUJVYFhtxrrJ1T+Tj7wlcmKxXPmDhjfDgMqFFenUxwnwh55hZ5HNGzf2sPZk0rn9jSeU37Hng2mzGGYcUR/KLO6eBv5jkkd7d4Ziw9ksXlt4eCkREQgWj4daDvQIOzmHXgpJ9vhhRXxumB+aX3A/C9ZcIzz5rJc9hlMSTPpOyf9VSNAogeMJRU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue Nov 10, 2026 at 1:06 PM CET, David Hildenbrand (Arm) wrote:
> On 11/10/26 13:03, Lorenzo Stoakes (ARM) wrote:
>> Given the current throughput in the kernel resulting from AI-generated
>> series, I unfortunately lack the bandwidth to generally be able to offer
>> review except in those areas I maintain.
>>=20
>> I have separated the patches into areas maintained by David, Andrew, and
>> Alice + Danilo, so each can take the patches relevant to the subsystems,
>> for convenience.
>>=20
>> Apologies for doing this, but given the current trends I'd like to do
>> something to make my inbox a little more manageable :)
>
> Yeah, it's crazy.
>
> Thanks a lot man!

Thanks Lorenzo!

> Andrew can just queue the whole series I guess.

Acked-by: Danilo Krummrich <dakr@kernel.org>

