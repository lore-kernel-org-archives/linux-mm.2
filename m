Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A94AFCD6E56
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 11:25:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05B146B008C; Wed,  3 Jun 2026 07:25:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00C066B0092; Wed,  3 Jun 2026 07:25:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3CBB6B0093; Wed,  3 Jun 2026 07:25:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D2A466B008C
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 07:25:19 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 81CD81C084F
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 11:25:19 +0000 (UTC)
X-FDA: 84838370358.26.84A5A3F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8F894180006
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 11:25:17 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=exw4XYzJ;
	spf=pass (imf24.hostedemail.com: domain of ardb@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ardb@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780485917;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ej/A4bAeP3GRRv4aBL4VdTQbInf6PAP5PBV1hqxuGeU=;
	b=C9y8TAUjeEcuiyLcb1ugV8Uuu/lPxwZD8Tc6qQeJRA/2ira8faugjGQKkppFE8uZQTHths
	A+J64QmOhk6sfGOn1ZNXwXHbzeF5VfLnvMPSxdtcOxLjJbqZ8URr8GowX3vmnWqMYCZoZE
	Qc04e6eix/13Ea3QXhInnSXU6moclCY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780485917;
	b=KffFw4WBpVFFMrVmQY9+v2vnMnlhbQVDR78xHftugmYyd9jv5QTLrN9c9nJrnen6AMshrm
	cp7inwtljU0lkoUm7bVkS2Js6yYE2fBKjwZR3zNaP+w9SHweJhcK/Xtra3cyiKRlh3+SQQ
	FvI8Vdy3bUkL/9u2Bvcxxfej1KSg+/A=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=exw4XYzJ;
	spf=pass (imf24.hostedemail.com: domain of ardb@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ardb@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0069F60052;
	Wed,  3 Jun 2026 11:25:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FEB01F00893;
	Wed,  3 Jun 2026 11:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780485916;
	bh=Ej/A4bAeP3GRRv4aBL4VdTQbInf6PAP5PBV1hqxuGeU=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=exw4XYzJHNx8NPTpD1SzdOEOLUIA0xbYO2jphTnpVII8b31Q/9zoA+W2Rvg/yhsRJ
	 rEc/sWlhy60ka7H0KxygsKKzTfK2eoV1T3KYgDO6PTRuKF9q3CHlxXeAxdewT+ecHQ
	 NBSd91h0blVNopV1S8MSD25RQBFS7xz5PlvkBpwHruhFkJ3FpKkcFYAWPIuu7rzfF6
	 x+OGEki1CCoDqkOh1nrN5UKDwOjNctAtNOzcuXJvxl7TfG6lbZBxvDoShpMpgqqsJm
	 3gltOvlx5FPE7bceYtY1n+j09Xo/ig1esnSx7M+rmwf6cTja4OnJ8sQgCh4Xrx7MK9
	 Q3cwykG/gR1EA==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 35B68F40070;
	Wed,  3 Jun 2026 07:25:15 -0400 (EDT)
Received: from phl-imap-05 ([10.202.2.95])
  by phl-compute-01.internal (MEProxy); Wed, 03 Jun 2026 07:25:15 -0400
X-ME-Sender: <xms:Gw8ganjrXz0JQ4a20pZ2keYgLL966sZB7ggcBghyxiZjOST0pbGkzg>
    <xme:Gw8gau3lk00GKn5Y2in9l7RFhymSP38WEHp3EMZII2yHEoKx7m9e2_O1ItUdjYSaY
    4mktIanZvMpp4BxKaVX3h41Qzq6CxeF-i3QeDrzyNPiZLrjovwMNSo>
X-ME-Proxy-Cause: dmFkZTGk07hpe1NCwTVIzfP2HgIVR+mhM9tsG3G5fFNmt40ZyD0SKBCj9VlPFNEJ/mKYg+
    yn9XCnk7DMqqvKhYAonBnb+EiK7yyt6XwsAKFP1NRUIxeRopUJbCzFAEtgdZwZ2syq6mLt
    hIc8ns+tGdiT78GcOIddkRPvwXakkAXz6AaOGjfod1A73n2hhP0S+irMK6MY6pmOGSphLV
    9LSrur6d22T4VrRb0o5gM+dJx+HdoAtQGS5mxYoTkKVSFjuFyOM+kuaRmHmk5SGbsP2X5U
    zTfs5UQKk93YP1gI0iWsago6o9Zae+QmHbKuHZObMf4rdXX8pu80r92+oAHgcVeIlkcQDt
    0QoJr48G7g3k7Axy3vrUiaTuSSNl5Y+BBkBWhf7/BIuAoakZ1dJtZrM+QYGf6QD0T7M/C0
    ueKDXo5EQVNDoS+0A/91fYorYH01AUmS/P8O4XOQS5akirZ4o6R39OVDG5ahWkb2lF336H
    YbIyD0BajwqJNC5uYkvP7UDCRsQcdeI+orDmIIjHhBz6YSpbphRyIkD91JJ5F8fMl9IFqF
    a0YT3rtTfzLsSqiNI66DGkElA3Hc8cBk3YfeNWCCudJjd2gSSl3qVSUppja1jEfUb97L0h
    hPAd/USZemqekfo8KMLkrAbpwvAtpzbyCrEKM6liYSn40sbEKKE762X7+RKw
X-ME-Proxy: <xmx:Gw8gakVtaCK4ce7TGaafgWSRTK9aFbX2O3RU4WUOTM8sVh_nx1Wfeg>
    <xmx:Gw8gaqOLByCdyD78lmI0iP9F3j-yUw1MG1v484Rm7MAoLd2u5zohIQ>
    <xmx:Gw8gasfLsOXv2iWZ1GY4UgCbbbl1MSvSRNMh5lEG4-5iDY27pvISJw>
    <xmx:Gw8gapw04dbEZ-YaSVuDJ6MnkCD0rEgcBTKMEm-QTUsw0wXutnCBoA>
    <xmx:Gw8gatgq8miMnJmGvsy1x2eDW6BAFtzhVAqxtdrb0sGgeFGbLROK63AZ>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 0E8AE182007E; Wed,  3 Jun 2026 07:25:14 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
Date: Wed, 03 Jun 2026 13:24:53 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Will Deacon" <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org,
 "Ard Biesheuvel" <ardb+git@google.com>,
 "Catalin Marinas" <catalin.marinas@arm.com>, kernel-team@android.com,
 linux-kernel@vger.kernel.org, "Mark Rutland" <mark.rutland@arm.com>,
 "Ryan Roberts" <ryan.roberts@arm.com>,
 "Anshuman Khandual" <anshuman.khandual@arm.com>,
 "Kevin Brodsky" <kevin.brodsky@arm.com>, "Liz Prucka" <lizprucka@google.com>,
 "Seth Jenkins" <sethjenkins@google.com>, "Kees Cook" <kees@kernel.org>,
 "Mike Rapoport" <rppt@kernel.org>, "David Hildenbrand" <david@kernel.org>,
 "Andrew Morton" <akpm@linux-foundation.org>, "Jann Horn" <jannh@google.com>,
 linux-mm@kvack.org, linux-hardening@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-sh@vger.kernel.org, maz@kernel.org
Message-Id: <d5186071-55dc-42b4-9e5a-b279a6ca1384@app.fastmail.com>
In-Reply-To: <aiAOaYwPlGEG6FML@willie-the-truck>
References: <20260529150150.1670604-17-ardb+git@google.com>
 <178041415770.4024555.11336437584927054639.b4-ty@kernel.org>
 <2c7929d4-6622-475d-af1b-bcd0cd997cd3@app.fastmail.com>
 <aiAOaYwPlGEG6FML@willie-the-truck>
Subject: Re: [PATCH v7 00/15] arm64: Unmap linear alias of kernel data/bss
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 8F894180006
X-Rspam-User: 
X-Stat-Signature: eckf43edgtbgywyxykrgs5rnbsjxzdar
X-Rspamd-Server: rspam08
X-HE-Tag: 1780485917-697246
X-HE-Meta: U2FsdGVkX187lAVjvnCRfvsVKxkjDx/ALHLKaOu0l5FaZV+bBDZc2tUTQyEqSonyve+/PlocGa/7eQRLCoXFiM1O5Z9I2m6TIRL1bJe8GyMl7R2FeXmse/phMxzjP9Zg+b7/Fs422o2VzSUvX0BfgZWrEJvB+hSvhXEDjS6WPeC6UDEhT4ZXPK3Ejb1b6q6FNUrshIGxCPCmih9t3D0RYIhBoZNSbj0IZuYIA35c6s13ekBC67eiskIzLySm2VJ7/jgRxokGk1mASYLhcvvsz3+dxHKnVIN6I81LqfxXDVH7t2fT1CkGraEuFR2GDWpTDOaDCwphIVc7/HMfXTiitU801BQ5ZD+DYJI8PQmy8l5T3sVvqu/RNrKDxw4t3xIXVSTR24DTseUsq+aZP/JctwCqkwOsL990aFtWlspdnSDPo+skgpCs0KYeCmNfjzOxqKG5XlP17Pt3YiP59P9ll9cY4FAknt0O6KDZH+YcoBpQ03brmvF7hmFSOq/AWv4gK9JDIKV5qefJrjGm7BcqBeEjWSQN0inDOAeyera73i7i9F01yAwacBqNPmqooVNrEcjVRXDzhx6NWfQzllvCrILZW1HDkE1L5EA4LRwIoLWUawQPEZ3dOaUv+4JeJH35VMjXFfavuhNqL2Yv+4a4aMqIPYKQLlC4Zt0MaP7rM3WXSirnMWqLWyVPPYzSiHdbV1lscGSfwgNH76b1+7ySbqsu+bGmMMXtqyG9hJYUuucJ4zChq9yF1SGlVl/72VeDn4T8Tf7Sz6JmSN0oROSwfo2L+gVsMMc7tT/f+8NjekfAnGLNZL3O72qhgNNj40idXXHG7v94YfGgoGKT5dWaJz9BwL0sbnOBFRCoDihGiFIvNsJkTmWisuMq1IjpFqk8EhFE82BR3psRemidC1fmSW3INUwp6O1vUa61ojIZXdoGRRUMYqxc1VyUdtbfqWDiHVXws4AY8crVkFakOoS
 pc0l4yjD
 S6SsKLnUCpVJKOTWHOyiqrTWogZjBIy+BDso+j45eIzAyHxswiM4pYfyEDG/ZyWtrN7cCLj4gsZJtBbY3qZvUSPuh+xLxgLImX1aps8WFIAzRemf0sr8oWWHbrmQfzWn4v+sQxP27juufbpFGW8VNv49caQcbOUUUvrvj0L61G8ztkIP94I5J4Y+bmf9fUvEfXFjszlHjR/wNfaoM/D+Gy5RPIRfXMEcFPKXeobhZ4f8C/eNQb0Exxuz80ageN8YuuxnhyRwhx0m92dYD2egtB0f7H55I4vbcJtI2nZDGV/xXjvvmvJK8v43Bs+CqedxhmXwhE/eQSyle5+9P7oDemRZ3jsfHXYdtn6G+7K2I4m5scFINlVV2nEa6KK5zVIU6hGwUkQiZ2kkrc3lElSMgFAZpklqEs1prxdbhCVrjVZknAxUIszf6GnCiuSPl/L5RAFrcQtynxuEPuz+TsofKU0qPq8bg/u5IU6Zqot0i6nhZCpyMyMAuUHJ4Ft1lmyYVe7fK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On Wed, 3 Jun 2026, at 13:22, Will Deacon wrote:
> On Wed, Jun 03, 2026 at 10:57:49AM +0200, Ard Biesheuvel wrote:
>> (cc Marc)
>> 
>> On Tue, 2 Jun 2026, at 22:34, Will Deacon wrote:
>> > On Fri, 29 May 2026 17:01:51 +0200, Ard Biesheuvel wrote:
>> >> One of the reasons the lack of randomization of the linear map on arm64
>> >> is considered problematic is the fact that bootloaders adhering to the
>> >> original arm64 boot protocol (i.e., a substantial fraction of all
>> >> Android phones) may place the kernel at the base of DRAM, and therefore
>> >> at the base of the non-randomized linear map. This puts a writable alias
>> >> of the kernel's data and bss regions at a predictable location, removing
>> >> the need for an attacker to guess where KASLR mapped the kernel.
>> >> 
>> >> [...]
>> >
>> > It would've been nice to hear from the ppc folks on patch 11, but I've
>> > picked it up on the assumption that they'll love the negative diff stat.
>> > Worst case, we can drop/revert stuff if they have late objections.
>> >
>> 
>> Thanks.
>> 
>> There is a de facto ack from Michael Ellerman in the Link:, which is why
>> I included it.
>> 
>> Note that Sashiko found an issue with KVM+MTE, where a read-only mapping
>> of the zero page in the linear map may result in issues:
>> 
>> """
>> Does moving the zero page to .rodata (or unmapping/read-only mapping its
>> linear alias) expose a guest-to-host denial of service with KVM and MTE?
>> When an MTE-enabled KVM guest reads an unmapped memory address, KVM handles
>> the stage-2 fault by mapping the host's shared zero page. KVM will then
>> call sanitise_mte_tags() in arch/arm64/kvm/mmu.c.
>> Since the PG_mte_tagged flag is never set on the zero page, KVM's
>> try_page_mte_tagging() succeeds, and it calls mte_clear_page_tags().
>> This executes the STGM instruction using the zero page's linear map alias.
>> If this alias is read-only or unmapped, won't the STGM instruction trigger
>> a synchronous permission fault or translation fault in EL1, causing a host
>> kernel panic?
>> """
>> 
>> Marc seems to think it is legit, so I came up with the following (I'll send
>> it out separately with another pair of tweaks):
>
> Thanks, it also looks like we're getting some early WARN_ON()s firing in
> CI from split_kernel_leaf_mapping() after applying your changes:
>
> https://s3.amazonaws.com/arr-cki-prod-trusted-artifacts/trusted-artifacts/2571596185/test_aarch64/14662134813/artifacts/jobwatch/logs/recipes/21399931/tasks/219104268/results/1007729692/logs/journalctl.log
>

OK I'll investigate

