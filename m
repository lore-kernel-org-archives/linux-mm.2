Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 440F4FEFB51
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 20:55:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFEC16B00EC; Fri, 27 Feb 2026 15:55:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC9826B00F1; Fri, 27 Feb 2026 15:55:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D57E6B00F4; Fri, 27 Feb 2026 15:55:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8BA226B00EC
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 15:55:52 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 49F8C1CD09
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 20:55:52 +0000 (UTC)
X-FDA: 84491443344.14.1FC3E7D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8D288160002
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 20:55:50 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ec5EmqEi;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772225750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K1dV7IQF0lx0xSPLL7n4bBmqvEJE0UbLW/Io7tN0R4k=;
	b=QhRE8gBK1YpEpuewneNX+m/2hns8jWXRx0WnsbOXq1ZwjiPnrOcODaMfR6YpPCnc8SEGMR
	iiWbqQPH30RNz3asSXbZY0fc6eVwBCWDOl5SlJcxCgLt4JSA9xktVZr8E8vSqIVZaJe1hi
	YrDFzpIOV9+UF+lfiMTJ9ty56owTKqo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ec5EmqEi;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772225750; a=rsa-sha256;
	cv=none;
	b=VBE1YAQbcAHN1X98qN2M+Hk1iER7+OEoAxKxNLmwNZ9Yi4zkNwnj07TVamwKE5CtewBE/b
	jdOmealj8gx/IXMZJSo1Z8ELdpAtKZJqiFYAl7hkCpi0459hR0bsmD6JwCKWNBL3Dz07CZ
	mA1tLHGx6FiHk37uLfw4vg46JBjHMSA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F2FBD6013F;
	Fri, 27 Feb 2026 20:55:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71F6CC2BC9E;
	Fri, 27 Feb 2026 20:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772225749;
	bh=RcLgvWL4EWw0I9N2SCEA7PiWOjdOzlqk9NEbntyOnoc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ec5EmqEi8Tuh9mTsaLR2NyeFZLdI9fBDmozhfEZ4YpGe2RFN2Iyl61G2P5gtlxp3y
	 VTn8OXE3D/Lm/yvrWsIKkTSDETCKnR9MU1VlqG/AbVWvH6JssNSLT2ZuNF2lvdzJJl
	 Ony94uN9+P6ItRlZD0y0VZZMFuLOUSip3ayAhmQXfc6+c2MPRqsMR5nJCUSseJjHCw
	 s1dpzIhmQJsCsqbsPU/z4cgaHimb+rB72zF7FBAVtCWy153opI7bU7Xa16mHsMTG4Z
	 Xxunnz2J25EbvKNvep0Ylb+cyXxLf8CUUmfUw1r3cAq+/A+4ghhKTzGg1e7lBk2fEM
	 38QyluppoKojw==
Message-ID: <74f0b99f-5184-448f-a5b0-fb8c827028ee@kernel.org>
Date: Fri, 27 Feb 2026 21:55:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] perf/events: Replace READ_ONCE() with standard pgtable
 accessors
To: Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, linux-perf-users@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260227062744.2215491-1-anshuman.khandual@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260227062744.2215491-1-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 8D288160002
X-Rspamd-Server: rspam08
X-Stat-Signature: 933qog3wgerrfo1eoeogaimnxd4mwrjq
X-HE-Tag: 1772225750-655149
X-HE-Meta: U2FsdGVkX1/xaF44OM0NFXSMZviZPaGh2rq3bIv6dD/QR1SijwT2bkZPWjNwvBfaXaZDeku41xp29M+2SiVut8kh64vRzd4vIDhqPqefyYEsPjOaVTwHepEZCuHME6z3gw2DiTf0t55WijxIn+ad6l8FCNiPnahscBCNrVi8UqU4n3GYyC/pFGCI9RazCm/8Z0uY8cbrmmSjvAfMjEp4SrOHrtBI30P5T4eVUbHKZjvKR/tPhBGPnzNk9GZ0GFvkUMTXscB0/9YnuAVol4cLTrc3NmhilJDzwO6dI+KnY7Pk162gn7mDDeKvw3scqFsJCrYgQSNKd5MsQ1i0dQHlxE9s6A0DhKY+hOQe08la68cT6gxeFWBzT7MGqaeSSsujztlduwnEphqtuf0I70/OIPaw+iVQbQ7+ZXCIAuwXpbEQ9rm+WR/ipfVxhh3pUz4eKUdJnRI3h05oy0LhtRCLTPgVXI4HjOoUJpaFGaJz8z9Fg7CHYYd23TJQ47Z77CyCx/7vxIoaRA7a+pHAzR29gutXH2zyerdWeIUGYIAqbVOrymtU1wY+6Qw3q0/m0+6S9obW5CDcyHg0Mo9TvS4ZHqu8JeQDsuggeawERrwAP/9UwjbNtpJNLtPwUOuNEc282spmU1c0fHfJvFGrZvod376NNcaUe6NG5guDDtGxR6VjzmDCABHl6RMa8KiZZ+u6p0NC1HVvZZVdz6Rhpn0s5TrW9WKiwJ9E+nHNcy3MBhmRsLGzhY8xixe1zZAZEsHvby7TGB2QxW83wpFYPRVqB8+n9eczwL3QmWZwmAXHuZW0lFy2PhTGPdXMLU89p9pN3Rdx6yi9UCozjjXrWlf1luBPLKsYzpDNXTeLbmOVEIB7SBaPyvBXCyF2Nkq8dTaymA+4gmfDt9H616V74cZtNV8qgVDuA69D8ffxWww/p2PLwq9AehKwlhNZKtLRVfBMG0FklooaUxT2ow1SydI
 irrNuYUC
 lw74si77aixgCjZ6iIYHeljORDx/bOO8UC7vTrivXbyJd0W4ZwrwrPWj6I8YM4iudqIZFV0JMaUh4wTidvL5I7msz5bOeOO5hH1umxTAdt7DzveSAI9obCM9syEh53KHV38vaqhR2i0dT7xAtzFTfZrvGEkEtQl/X0BrxCA+9D7f5mMPu4rRJFK4/JvXpBMhqnX5RaRzz9tjLpijQIJQppIU/OtqMg6aUO5Er4BW0ZaiOSicR/Zxq4QB/VWQsk03cx34TtVJZnGoMfq0g1UCs1NCEMhWL3/H/XAtz50RJ1qnlp8UPph6nG90y86Mi3EPPhX81tuisDRRI7qmJSkyabc6SZELeXmRYf/SS3Y8T85TURTniaQ/OSmxzKydf1HdfA7BW8UvsGuBV0vBwo/3R1OByT1aKIsw8u2o4mnJ5QV6UY2Uy+pLESHshdHb5CA/9IZoZuNQvHGu5eQIwwrcgZXT33tdFVYuz2GhVGu7ZV9Vimj06Dk882WJwDTEVpmi0W4dLAh+TkgwSuCXRL2TuGSNcQnmI1JhaNB4tLANJwCiDDi8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/27/26 07:27, Anshuman Khandual wrote:
> Replace raw READ_ONCE() dereferences of pgtable entries with corresponding
> standard page table accessors pxdp_get() in perf_get_pgtable_size(). These
> accessors default to READ_ONCE() on platforms that don't override them. So
> there is no functional change on such platforms.
> 
> However arm64 platform is being extended to support 128 bit page tables via
> a new architecture feature i.e FEAT_D128 in which case READ_ONCE() will not
> provide required single copy atomic access for 128 bit page table entries.
> Although pxdp_get() accessors can later be overridden on arm64 platform to
> extend required single copy atomicity support on 128 bit entries.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: linux-perf-users@vger.kernel.org
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

