Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F15DFCAC5AE
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 15:29:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B57A8E0015; Wed, 24 Sep 2025 11:29:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58D3D8E000F; Wed, 24 Sep 2025 11:29:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A3B78E0015; Wed, 24 Sep 2025 11:29:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 399248E000F
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:29:19 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C219A1408A5
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:29:18 +0000 (UTC)
X-FDA: 83924527596.04.832FA4F
Received: from fra-out-003.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-003.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.72.182.33])
	by imf05.hostedemail.com (Postfix) with ESMTP id 433B4100017
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:29:16 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b="d/v0uJyX";
	spf=pass (imf05.hostedemail.com: domain of "prvs=355a74973=roypat@amazon.co.uk" designates 3.72.182.33 as permitted sender) smtp.mailfrom="prvs=355a74973=roypat@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758727756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xYwtDKmp/Zq0jOTCpG7R8cZcsQAosKrhHZ6MWIe4xuU=;
	b=H9JpZlAX7JgEC7MjunowgNEQHzYIQlzdeFzt/1eIJat1+0od8pQm8iwxoX7jl3F2IiRERk
	cJa1PaGDMBQljc39I/OlZu4GzI4FQk9weq/HN8dEJVxXP0sar7vMZFWXR9ffMbXjRrRWbX
	KdYaUR1GX6+3XavXE4eTa8IizKsH6vE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b="d/v0uJyX";
	spf=pass (imf05.hostedemail.com: domain of "prvs=355a74973=roypat@amazon.co.uk" designates 3.72.182.33 as permitted sender) smtp.mailfrom="prvs=355a74973=roypat@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758727756; a=rsa-sha256;
	cv=none;
	b=YhsHkbEqOhcnHK0nhMruCbQaIZXWyqUa+AJoerI2aihe4o57SoNuc6IRQKnt+lJwXri7Cb
	0WObBpokt9/FY2yq/U+mnWN5weIU2wK1ezuQsgUcUYMltgKqV4H23ibj+mQiF+JJNQNxRh
	4Yj2hLwTpLHGSnVeeOOcRz181hpdzyM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1758727756; x=1790263756;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xYwtDKmp/Zq0jOTCpG7R8cZcsQAosKrhHZ6MWIe4xuU=;
  b=d/v0uJyXQ/W/HUYtT07fNKGmTGeZg6bQzA0vkgNx5p3rB1FOYpPTowX4
   Pzf+OpbcF/9qsFVAQVk6/43ahglUyRjPReDg2KxlOBMu4EEQ0FeR6ys1k
   MVeWgRuufTvpbCaz8e2axeJXigANMMYWjg1eW90kTtQNW00I0Xgr0Ar4t
   LVpSekA5bgMlLg+Ak+t6zJSf4qgg4VxzoTm3z3cX8Fvn9ShLf9HINEAVM
   4iQN6J8Plg0H3miUkDQG8Z+EQHl/mz0AVm6SFJ6hqtmIlU/rnLV3aguT1
   jUUlQAYzvnXJGifE9Tme73jXeVnp07ECTwLAVxcRVAj0pmREN5Ck+Rqi3
   w==;
X-CSE-ConnectionGUID: H1Nwja16SO+mJPPrYIM6Uw==
X-CSE-MsgGUID: 6BUVeHZ3T1iQWbqFFphHSA==
X-IronPort-AV: E=Sophos;i="6.18,290,1751241600"; 
   d="scan'208";a="2615965"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-003.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2025 15:29:14 +0000
Received: from EX19MTAEUB002.ant.amazon.com [54.240.197.232:7826]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.45.166:2525] with esmtp (Farcaster)
 id f979d79c-010c-49b7-9e97-d5be296685f6; Wed, 24 Sep 2025 15:29:14 +0000 (UTC)
X-Farcaster-Flow-ID: f979d79c-010c-49b7-9e97-d5be296685f6
Received: from EX19D015EUB004.ant.amazon.com (10.252.51.13) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Wed, 24 Sep 2025 15:29:13 +0000
Received: from EX19D015EUB004.ant.amazon.com (10.252.51.13) by
 EX19D015EUB004.ant.amazon.com (10.252.51.13) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Wed, 24 Sep 2025 15:29:13 +0000
Received: from EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a]) by
 EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a%3]) with mapi id
 15.02.2562.020; Wed, 24 Sep 2025 15:29:13 +0000
From: "Roy, Patrick" <roypat@amazon.co.uk>
To: "patrick.roy@campus.lmu.de" <patrick.roy@campus.lmu.de>
CC: "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "andrii@kernel.org"
	<andrii@kernel.org>, "ast@kernel.org" <ast@kernel.org>, "bp@alien8.de"
	<bp@alien8.de>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>, "corbet@lwn.net"
	<corbet@lwn.net>, "daniel@iogearbox.net" <daniel@iogearbox.net>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"david@redhat.com" <david@redhat.com>, "derekmn@amazon.co.uk"
	<derekmn@amazon.co.uk>, "eddyz87@gmail.com" <eddyz87@gmail.com>,
	"haoluo@google.com" <haoluo@google.com>, "hpa@zytor.com" <hpa@zytor.com>,
	"Thomson, Jack" <jackabt@amazon.co.uk>, "jannh@google.com"
	<jannh@google.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>, "jhubbard@nvidia.com"
	<jhubbard@nvidia.com>, "joey.gouly@arm.com" <joey.gouly@arm.com>,
	"john.fastabend@gmail.com" <john.fastabend@gmail.com>, "jolsa@kernel.org"
	<jolsa@kernel.org>, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
	"kpsingh@kernel.org" <kpsingh@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-kselftest@vger.kernel.org"
	<linux-kselftest@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>, "luto@kernel.org"
	<luto@kernel.org>, "martin.lau@linux.dev" <martin.lau@linux.dev>,
	"maz@kernel.org" <maz@kernel.org>, "mhocko@suse.com" <mhocko@suse.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"peterx@redhat.com" <peterx@redhat.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "pfalcato@suse.de" <pfalcato@suse.de>, "Roy, Patrick"
	<roypat@amazon.co.uk>, "rppt@kernel.org" <rppt@kernel.org>, "sdf@fomichev.me"
	<sdf@fomichev.me>, "seanjc@google.com" <seanjc@google.com>,
	"shuah@kernel.org" <shuah@kernel.org>, "song@kernel.org" <song@kernel.org>,
	"surenb@google.com" <surenb@google.com>, "suzuki.poulose@arm.com"
	<suzuki.poulose@arm.com>, "tabba@google.com" <tabba@google.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"will@kernel.org" <will@kernel.org>, "willy@infradead.org"
	<willy@infradead.org>, "x86@kernel.org" <x86@kernel.org>, "Cali, Marco"
	<xmarcalx@amazon.co.uk>, "yonghong.song@linux.dev" <yonghong.song@linux.dev>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>
Subject: Re: [PATCH v7 00/12] Direct Map Removal Support for guest_memfd
Thread-Topic: [PATCH v7 00/12] Direct Map Removal Support for guest_memfd
Thread-Index: AQHcLWf7p6lrgf1yqEyGzQxUogXjVw==
Date: Wed, 24 Sep 2025 15:29:13 +0000
Message-ID: <20250924152912.11563-1-roypat@amazon.co.uk>
References: <20250924151101.2225820-1-patrick.roy@campus.lmu.de>
In-Reply-To: <20250924151101.2225820-1-patrick.roy@campus.lmu.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [172.19.88.180]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Rspamd-Queue-Id: 433B4100017
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 3auerjw9zyhs6y9cj1rryskpwo5ecpyr
X-HE-Tag: 1758727756-933767
X-HE-Meta: U2FsdGVkX1+HrVehh7QQOYG+lUFF3xNPL0xbLhmQF4hiYba94v6Nv44cMcvv/AZa/ngexsR+RXSEMZXJhRm2fiAo8IMLNrADw/7dbgpXZskUZig+/1jYLag2+1RD4o9fMarfX3QYd92hs6YgeLlt25z5bFZOlDHb83Oky42YD21jYFhXCK6NgZGxwlLSSAF7eeNE4lBYvOszt5oe1QycTZzPhFXy2eL66JJPaC9+xt7v0Nti3ayGar2GMyWmyFsCYw/pmVDnrhBA0d/kx6YD7cSD2IBdeAL7kZH2mn7Lrny4QXNtACYq7FG+1/QYHj75PJqhVUbXk3qNmQaujSci632X55Ry9PZPAXGUrEt2N6R98JUpLRlZdrJESoTUJgUbETxRFzWMvbwfj0LUFE/KXxqs3hUYwHP6RrUNhqOBWhk1VtplWRU6HG5UlBCv1u3akc8FaJSLAFQwSjCJXrXcIG9tjvbspqVpgOE+fD4kx6aDmLieF7GnoD/ISDDr54Qbqb27IvOAkhLCNuP9VcjVA6qzGLmNv6yS9lYgY/EwFy1b8d1msXbVm4UFqiO1SIKPPZo0UCKYJiBbEW5BdZZwpvzs67nAoAvhMiInFIKgdlOgYEf7+MuKGGe5UsdKP+CBqrqopWnkmMOZgZ8uebDFZzh2rtmYYBRUpMDvX/kJb6NbRbefpR0/X3P51D4PmIwpll4Ke4biELpgH6WLgOlJt3KTK0xPEoPwS3QATMIpC1Bq71f4SrbmEW+V8oHdt5CMtJAFifu/lj2N2c+Dx1YHFINnc4v45kwXaWsRPqPxuLTM1Zkv56DX9L69+uQnGwpM5q+3GypaW5qoQ1t2UBvtA406j0UGJoFRz8YXEzotPFNe6JBRcenQ9G/kCCqIANqd+KiZ42Z4DvT3oy/SKcl/MFGNQRbvL681autS/wJ71oBSEspyKjSGlLUXPP32VkIbKXw0x/envG+KeV2WEHf
 pkTUU15M
 teJNPPjs8GPPRh2Y3HOcYDaeG3UV7MHP91Q+k8gFaO/4g2bOiAhjmGNkM0elTNMbA6n2A5V43m8irMLGr4Uaa4V2S35dfMWKW62ZyYZFIOy4oJ98RGNsAhhEnN/mMAgWgZ/7vYDZoQhdgEKLSO+P2vRBipNkMLMlLqvTxGhJnKU5GHVvLS8YFX7n+mue9K/yWAzx1zupkxeDmP1mrtwVI0sDdpv6TukJjk9mjSWj1W/BCHMENtUsFghNOk/nuToimRSwWXbCqfhiSUDRbEMGndS8mzvYZNaLN1sjP9KWBTbJalUsn079PJqXUphTW8KmOhaJgv1VnI0sB9swcvAfLYG3X4VnorUfGWJAHcBFbkJSvXo/6SnkDGLieaLtLYAJPPJ+5zYFSaz+2OjEm1ADcOtapO9CVWo8mvV02OqXf5/jrVKWyB13KamENbA5Ah6yp3cXMV/dhgfqE+r7aEDvZ4jgicO+fyE0D5A8Ln0xl9FEloVEX9tsEdb9Kib832QCFRPT49cIbqtVz7/pxKPIWAMVqk64qGuAHE7418IAFK273Ja9apjs1j8GB0viIqJHy81ufRyzv6LMphxVp1nPf0sEmZ4eRIRPWqLMu1SRsJnZWePSooKKV1S8AkahYVMj/+F6xFS1EIjmV9uhaDISvoAUnghrhqaQkUTT/LYdVWxLTL4SRSHyDz7U0CfVxy+iINCbD8WDTIYMmd/53isC6Ps0kwiW+e+wzeG079FKATNqkjF2pAFmRJcmiJzsOaiu7ZgjSQqMIqU+t+AHAwvriO3JMitwkmdzJjRjnskv9OomiS9dGoZxjV3NN2NKInpqZ1E2/xH6H0whJNvs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

_sigh_=0A=
=0A=
I tried to submit this iteration from a personal email, because amazon's ma=
il=0A=
server was scrambling the "From" header and I couldn't figure out why (and =
also=0A=
because I am leaving Amazon next month and wanted replies to go into an inb=
ox=0A=
to which I'll continue to have access). And then after posting the first 4=
=0A=
emails I hit "daily mail quota exceeded", and had to submit the rest of the=
=0A=
patch series from the amazon email anyway. Sorry about the resulting mess (=
i=0A=
think the threading got slightly messed up as a result of this). I'll somet=
hing=0A=
else out for the next iteration.=0A=
=0A=

