Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 442C3606A330
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 15:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Gjy216fU
Received: by kanga.kvack.org (Postfix)
	id 4FB236B05B1; Tue, 17 Nov 2026 10:35:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D9C56B05B2; Tue, 17 Nov 2026 10:35:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E87D6B05BC; Tue, 17 Nov 2026 10:35:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 24E286B05B1
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:35:41 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AEA38A8070
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 15:35:40 +0000 (UTC)
X-FDA: 85445010840.18.56391E6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1BEE314000D
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 15:35:38 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Gjy216fU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794929739;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ELJIm6lhttTjycsb10kvfPy2zAiQZ1koJX28BayYPoo=;
	b=uvtLVrA2Rhl6jSeO1A9gAaVzFFfqADQSC05NYI4NY8K1B4xQJcaLKdYNJ+YGjTltWRTxOH
	BYLTNgGiYmNtUP47TitGYwII+0nUcBvVrawiNNhlrINEiIahG4shDMcDkOITVZvn0jB0om
	WR750t0faaDjjEgwuu0cdvP80arXLW4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Gjy216fU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794929739;
	b=mlsGTLC3rLEEvAQvoWjR7r4dZ5VIdjoheIyPBAMa1n0QQxSrmtQ0dtuDiypHuKmqLZ0aSM
	OiG7cm8C2AgEvNGRP6ZGDkOrSP98k2fKSqcx1zSYN6o9GW6sSllPPyb/kg9msRi/u+dyDa
	jnrcr6BSuCWn1g/8nUWj/b2dq8WtOtw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 588C260E87;
	Tue, 17 Nov 2026 15:35:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26DC71F000C4;
	Tue, 17 Nov 2026 15:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794929738;
	bh=ELJIm6lhttTjycsb10kvfPy2zAiQZ1koJX28BayYPoo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=Gjy216fUZNGD3yQdI+Uehx/94ckIhB71hpnfAE/TwX77hKNYh7ZxHFGnWd/CpdRTE
	 +NBD/byRDYwL961hDWv4FBOGSkhBYakuv9Yw5LKP+wS5BHkOAVfWkQMVv6oHF1p34v
	 5ixOOVMz/QSBpbUMp4yMQxTsAcLQVkxQ3Dq02JmVAdo/VMuWdy2y2O6/OT1Ij6dccP
	 1ldK9PhCVJkUIRU3Gd4FvTcgyqX+ACy05ea555OpIyF4USEQn17AneqZL4NoLnObqG
	 6DZ+IEHCw6JYk7NDqQkoJKxkMrV9HZSPljz7LTWG5Dm5qWA3MuNc12/o0HgInhkf3Y
	 i5UwP28sulVEw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,  Mike Rapoport
 <rppt@kernel.org>,  Alexander Graf <graf@amazon.com>,  Jonathan Corbet
 <corbet@lwn.net>,  Shuah Khan <skhan@linuxfoundation.org>,  Randy Dunlap
 <rdunlap@infradead.org>,  Andrew Morton <akpm@linux-foundation.org>,
  Tarun Sahu <tarunsahu@google.com>,  David Matlack <dmatlack@google.com>,
  Samiullah Khawaja <skhawaja@google.com>,  kexec@lists.infradead.org,
  linux-mm@kvack.org,  linux-doc@vger.kernel.org,
  linux-kernel@vger.kernel.org,  linux-kselftest@vger.kernel.org
Subject: Re: [RFC PATCH 0/5] KHO map
In-Reply-To: <2vxzwlqbfxtf.fsf@kernel.org> (Pratyush Yadav's message of "Tue,
	17 Nov 2026 13:26:52 +0100")
References: <20261116134013.1636689-1-pratyush@kernel.org>
	<179486913878.127049.11178890384802388709.b4-review@b4>
	<2vxzwlqbfxtf.fsf@kernel.org>
Date: Tue, 17 Nov 2026 16:35:33 +0100
Message-ID: <2vxzpkw3fp2y.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: p7x175fzzmodwmrgj4oqyqzxyy8wrxou
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1BEE314000D
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794929738-627691
X-HE-Meta: U2FsdGVkX1/LDqVqIny6MqR4J8jkuMsCJdhUvewefM82cxC+lo7GaZC6wHxLcgpb81fY9Jk0XC3sTtPOPusmKDUFEVINpM6cAkJ3t4vVDGCRcN3JMLcGnRSZhC35NbHMu8yBQcV/O236DofQp0uKSITWDUQhrJCCHHRbJ6vWCrXyNszTAdtn1x0hqE8Z/NXW3Ju6p/bQ7GB2yrjrNwi/AElHRyJhYmuSK6Q+z3RPykJws9lY4fHGlRxZoTQqyODAUji+GWkJ0Jdc4O4TNb1W8dIAekwFATH7uBsyrKbJiGx7AEk7cr74a/I3W3Ak68/VgQScOExB+cmRPCKrjxEcBBRz7NgH+B2TdyBjvOqWS4tnRmb7AZiWixHU7rnEML02gtC9IgaPgfK3nydvYK0/Et3bOKmI9ZbBwuj++ddYY+Plt/ywCexUhh9+N4AkPuTwNeLNPogwpUoCacA9UVuVVV6mriMthXWrfafddQOuN6O3T3L5TjXbP3xKWZfE0KukoIphgg0LNZ1QE8IiVYXJf2yqdwF+mZ+2u5fev8qiEunjQJi96IHd5DoFi++LiC/WYAhDJLpwIb8+bsQMfS96Ruq5WhV87EjJoPFRSq+K22a9oNrIeuJJzIdfB8c+nV6Dwig0piMHVv0ewkpyppp72DvdTdCzad1gpT71M5kQzqqnmcQT8+c2soFNkji+hzwrOcFmkL4jN9O0hBazgJ4utnXhg2Ht7/EehVBKM99GawPj7HcH9atXfVsXfks/IgfJiju4V74h6HvGJ5RT3CdObrLAKbpkbBEvM0zkMcsDNad7HY1Tz1xhd35DYvs93HjkbAf3dSP8pUrPZ3bYSyNKbg/kL/6XWPH4DNaKBPLMoXqU1KVEcItAa31la7jtx6ZL0YLr93eq3FPzkyNSu//DZP0qFdSPbdnrnvSgxYEQcLAUHVLvyRP+TlbMclWzES+TJiQ/QAWfs3k90OkBfcn
 uIfD/vG7
 p0EI2M/AwNX2vyoc2XLCGu9bncz3tqM5V9t7mCxUjV6uY1CJyPkcQR2wpOEzJWEdoQmbc6VcGCPcmQpwWdN11AJ2DExb0qEuNdz31okJucxn52S8UzqISMYKjlYQLfjyLF3lO5EUK9vcZr7P2Xf9+Q5AwryZrSJuscMzqbNgB81cstHMXRynz1JKN7DiMs7hCCb7zKtWcx/oa6/SqdiQEPcVJgw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 17 2026, Pratyush Yadav wrote:

> On Mon, Nov 16 2026, Pasha Tatashin wrote:
[...]
>> Instead of caller-chosen depth, the tree should grow (and shrink?)
>> dynamically bottom-up based on the widest key.
>>
>> Plus, with bit 0 tagging leaf values, 2M entries can be stored directly 
>> at L1 and 1G at L2 (on 4K pages). Even for huge memfds, the pgoff space 
>> is much smaller than 64 bits, so in practice the tree stays tiny in 
>> depth.
>
> I think it is a good idea to allow dynamic depth in the ABI, but I am
> not sure if we should deal with the automatic resizing just yet. How
> about we start with making callers specify the depth (max index/pgoff)
> up-front for now? The ABI stays the same, so we can add support for
> dynamic resizing later if needed.
>
> The reason for this is to keep things simpler to begin with. That said,
> I don't have a _strong_ opinion about this, so if you insist, I can add
> dynamic resizing from the get go.

I take this back. I went and looked at how xarray does it, and it is
pretty elegant. I thought some sort of rebalancing would be needed, but
all that is needed is to add a level above the root tree, and demote it
to a subtree. Similarly, for pruning, the subtree at index 0 can be
promoted if all other slots of the root are free.

So I'll add dynamic sizing and reparenting logic in v2.

-- 
Regards,
Pratyush Yadav

