Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4398C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 00:34:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D2286B00DF; Thu,  2 Jul 2026 20:34:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A9626B00E2; Thu,  2 Jul 2026 20:34:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8991D6B00E3; Thu,  2 Jul 2026 20:34:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 63E166B00DF
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:34:36 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5A8B0A01AA
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 16:18:17 +0000 (UTC)
X-FDA: 84944343834.26.81922D9
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf28.hostedemail.com (Postfix) with ESMTP id 748D3C0007
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 16:18:15 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZvFsPkNB;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783009095;
	b=76E5JeDcISVQ+J9QaibqmSkr4MFXfnTY/UU/a87YphHj3DJ8FBpDafmAHg/TUkcLnUXCbd
	p6vEiD1UpTjPR5c6ZiehT1Sgk4KAbjEPpsl00USDhfJ7ON48kUgcZXRMRHxO1L5ED1tIui
	hjhf0mTcu0B61Tt6CCGZv1brrzzHUv0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783009095;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nLm6wd6MZy34PotO0lu+sqiieTpRzFwK6t+5eDAyG2s=;
	b=nuO6HdlBFXPkwGN1I3jImWpRZSktsHtMOVY6PAx0/qvo/SSQ1MtALlh2E/pzmPH5q9Tetv
	6v3EtcyAooXHCPBS2pohwuf3t3sdEmf09xBg9clCJtVRUgXnl9LeK4gXrkkA/+y5DbEErL
	DXXAoexmzKKm+PBRV3KOB6T4CdPqu+g=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZvFsPkNB;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
Message-ID: <2f36a2da-0686-485f-b4b9-ae699bef4fd4@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783009091;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nLm6wd6MZy34PotO0lu+sqiieTpRzFwK6t+5eDAyG2s=;
	b=ZvFsPkNBnPpT/fXlkSqC4NvmGcAElqV1ItfaWxOxanuNMADXNea0vysO/aaC9fK20Fa/Nl
	/h+xkuVNERTD1ctetn6nlGPrMQ61CJ3XCqhhkVF860M2M509mqat5nuz+pZfFLHprM1shj
	DZ6Bs3Xsc4eQrpsCTRy6e4DCc3heh0Y=
Date: Fri, 3 Jul 2026 00:17:29 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 13/13] mm/mremap: convert mremap code to use vma_flags_t
Content-Language: en-US
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: akpm@linux-foundation.org, tsbogend@alpha.franken.de,
 maddy@linux.ibm.com, mpe@ellerman.id.au, maarten.lankhorst@linux.intel.com,
 mripard@kernel.org, tzimmermann@suse.de, airlied@gmail.com, simona@ffwll.ch,
 l.stach@pengutronix.de, inki.dae@samsung.com, sw0312.kim@samsung.com,
 kyungmin.park@samsung.com, krzk@kernel.org, peter.griffin@linaro.org,
 jani.nikula@linux.intel.com, joonas.lahtinen@linux.intel.com,
 rodrigo.vivi@intel.com, tursulin@ursulin.net, robin.clark@oss.qualcomm.com,
 lumag@kernel.org, lyude@redhat.com, dakr@kernel.org,
 tomi.valkeinen@ideasonboard.com, hjc@rock-chips.com, heiko@sntech.de,
 andy.yan@rock-chips.com, thierry.reding@kernel.org, mperttunen@nvidia.com,
 jonathanh@nvidia.com, kraxel@redhat.com, dmitry.osipenko@collabora.com,
 zack.rusin@broadcom.com, matthew.brost@intel.com,
 thomas.hellstrom@linux.intel.com, oleksandr_andrushchenko@epam.com,
 deller@gmx.de, bcrl@kvack.org, viro@zeniv.linux.org.uk, brauner@kernel.org,
 muchun.song@linux.dev, osalvador@suse.de, david@kernel.org, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, liam@infradead.org, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, hughd@google.com,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 jannh@google.com, pfalcato@suse.de, kees@kernel.org, perex@perex.cz,
 tiwai@suse.com, linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, dri-devel@lists.freedesktop.org,
 etnaviv@lists.freedesktop.org, linux-arm-kernel@lists.infradead.org,
 linux-samsung-soc@vger.kernel.org, intel-gfx@lists.freedesktop.org,
 linux-arm-msm@vger.kernel.org, freedreno@lists.freedesktop.org,
 nouveau@lists.freedesktop.org, linux-rockchip@lists.infradead.org,
 linux-tegra@vger.kernel.org, virtualization@lists.linux.dev,
 intel-xe@lists.freedesktop.org, xen-devel@lists.xenproject.org,
 linux-fbdev@vger.kernel.org, linux-aio@kvack.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-sound@vger.kernel.org
References: <380f761d35a3faa4370f8b3f92e3d4af3d4c7110.1782760670.git.ljs@kernel.org>
 <20260702134947.25189-1-lance.yang@linux.dev> <akaJx8Zt8kazlrjq@lucifer>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <akaJx8Zt8kazlrjq@lucifer>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 748D3C0007
X-Stat-Signature: nz5k9113qkhp45yfysmsuty67hic5cwk
X-Rspam-User: 
X-HE-Tag: 1783009095-507028
X-HE-Meta: U2FsdGVkX18CqcMgPxBizBVFdCdk8e3VxkvNxhCdiKypTx8WVQFID7Wc12DmS5pbu/Jz32SuXkRG+HT5t0ejA5kTcNqs0OzL4MTV6bVFg9/EcyIuca4Yd4+ZO0hZf3MkoEMed3rtLiwYE4xVq+qYJdTRrS14xGVZKw0WGBf6g3r3vjITyt8U7FdPkivADHE4gl4TAt6BYfO8yVz3TCoiWCdjyvUwLBX49LscsSIhmTHZhgJtHuP8qdpgrfijrYF/XZe0mkMM0iiJCEr4R6zKCDhDYDRLoYeYCuawIyIGT0rhrPOEjskpAJOnHqmtoeM6d4iGXXIM8QYGI/lpb+J5YMErdG9+z3u2n7g1+imBLDxzUq3Y3TvXLtsyb23UnjDvdz/Ij48lX1DF2Xm6IltcdUZn1hIjAdKmI293v97fxC9htsibbJ6JtQgToT8Jzc4MJXpGHAr1pB8r7sfojeGB86YPqP8aZJSllrJ09zwZnQKxqYTOMm0UHFfIvBGX+H2ruuqehC/MoL4s6AIXrvNtzwuayjgCqkxzn+1Olpg85vaSc2GMk+utc63BTs/2M0v5fXs56eVCWHp12aBkFmXylObh/UlwWS25zvVmzyqNplM77aVUQWAzI34+9tTH+Ck/x+0KociifYXsZYXrFv01UNWJbUx3ErZgcp/fprxvEl+oBLdrlJCeStKxrCuZK4nNZ7fe8t71m/A+J9PEezLXZbeZ0ZQATCzD+CWX+AtHERCDcCx6Jxt2+5GQ/edqGCR2wqdZbibkoDOhYdp6uYwf3w0eb8xfLSXZJdhS3FNOrGmInDP4tx7MnJWd6lvoY00Btjf+Oi9pyUtwz9iIHsa6LFc5Crt9b/SwPBwqPmKdUPGjFbVZtL81CJ3UCQW8nOPIrUt5t/ipJaJjoWNmaRq9lrNpxWM0WewO7KI05YgbQCWO+vWMFTwHbhyvmtzIaopKjHVYtzRaTHl12Q1Rm33
 Z7u/u5J3
 BrNyodzZJGrTlN9VD5J/B1cDgcrEVHZg/86KiShxhBjG6OPQqOj0Zrf/5Hl/toOfVIqQug9N4cX9oMc9+vbb+OejzRpcD2aE52OcnC8DPsLAsDpKBABy2mIaEIszE/5GdvbCcPZDtXWCoj/G/pwqmelKnDlSHO5TrNTFVWrQTHk/A2ra3yf8c4858CkywHDVgqZstVO0uJzdymu1hA89Vevu9yuMUyaDaCkqIDgPwSr8B6a0FHscXHPXbHI58PkkPfsmEI0g1EbgJIH1yJLHI1UaAsg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/7/3 00:07, Lorenzo Stoakes wrote:
> On Thu, Jul 02, 2026 at 09:49:47PM +0800, Lance Yang wrote:
>>
>> On Mon, Jun 29, 2026 at 08:25:36PM +0100, Lorenzo Stoakes wrote:
>>> Replace use of the legacy vm_flags_t flags with vma_flags_t values
>>> throughout the mremap logic.
>>>
>>> Additionally update comments to reflect the changes to be consistent.
>>>
>>> No functional change intended.
>>>
>>> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
>>> ---
>>
>> The vm_flags_set() cases below spell out vma_start_write(), but the
>> vm_flags_clear() cases don't?
> 
> Yep as I said elsewhere, implicitly taking the lock is terrible and me doing
> this is completely on purpose to get rid of that :)
> 
> But I haven't been clear enough clearly, so I should put the argument as to why
> that's ok in the commit message.
> 
> Will do so on respin.

Makes sense, thanks for spelling it out! A short changelog note
should clear it up for me :D

[...]

