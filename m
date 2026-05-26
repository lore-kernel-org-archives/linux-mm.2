Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 158E4CD5BB1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 16:27:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FA5E6B00B9; Tue, 26 May 2026 12:27:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D0D06B00BB; Tue, 26 May 2026 12:27:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20D9C6B00BD; Tue, 26 May 2026 12:27:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 109EF6B00B9
	for <linux-mm@kvack.org>; Tue, 26 May 2026 12:27:59 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A797AA03C5
	for <linux-mm@kvack.org>; Tue, 26 May 2026 16:27:58 +0000 (UTC)
X-FDA: 84810102636.21.E3441EC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id DF69F10000A
	for <linux-mm@kvack.org>; Tue, 26 May 2026 16:27:56 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WCPBslFB;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779812877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uX6weQ63PycMa+NiIwkaE0lKXtL5D7cf5slQyEH4uVQ=;
	b=hX0DTVS9lH93Z3Iz4x3Ev+slzSaf74o/xlmsSaHQlU+Q4hPoXUSqLW5tHTbMjYKHx0d8k8
	2vPhDTHUinuRI1JIrZzbLnQoyOhHCYZQY0ax3jk10KI+2FyYLajoYirA5NSuo7KMRpVey3
	9nz2TZCtBLcoN4pdYBUuR1YE8XU0OFU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779812877; a=rsa-sha256;
	cv=none;
	b=UxnIuKUF69mpBGRex/952pBDvXxd1DOEurjnnT/x9qAWUv6OviswnZgVRZGPTqVTCbQo2V
	jbBwzVoWvKvbvPrAlioHzAHMt7o6Bow6k1BMgkeMRX//IYaKSJEpOeipu0CKAPE//sBWl5
	frpBi4i2hpDSpNy065H1A3GpesM0io4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WCPBslFB;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6B35B40764;
	Tue, 26 May 2026 16:27:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 289D31F000E9;
	Tue, 26 May 2026 16:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779812875;
	bh=uX6weQ63PycMa+NiIwkaE0lKXtL5D7cf5slQyEH4uVQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WCPBslFBHlD18xXQc3r4cfXRi6NRqMWZgpFMn1cIbrapYoU4c4gRwNK1+7uVsqGAy
	 60v2BCHvTRcdS1tVvGPbqfVfdwwcJp1FHFNfktx1fkX0Wbx1RZrVm0KBNermhINrKf
	 T9lX4lpoqb8ZTQ988HCILQXzmPKZjen7JnhZ0OVSRmfeZwap0kKaSy4gg8etm5udnf
	 udcU0Sgi7luz1Cc1OPvSW+2ubz9qCszQO2AwKg/qp69fZ72CdWGJzB5e9f6nHF0uBd
	 ldc80qXMC/DUvHJCNvAW1ArbfI1EfmFu9YdmZYAerVhlmQZOEcNqDEor/Ir+l9+s8j
	 e4sx9r+STyxUg==
Date: Tue, 26 May 2026 17:27:52 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Takahiro Itazuri <itazur@amazon.com>
Cc: seanjc@google.com, Liam.Howlett@oracle.com, ackerleytng@google.com, 
	agordeev@linux.ibm.com, ajones@ventanamicro.com, akpm@linux-foundation.org, 
	alex@ghiti.fr, andrii@kernel.org, aou@eecs.berkeley.edu, ast@kernel.org, 
	baolu.lu@linux.intel.com, borntraeger@linux.ibm.com, bp@alien8.de, bpf@vger.kernel.org, 
	catalin.marinas@arm.com, chenhuacai@kernel.org, corbet@lwn.net, coxu@redhat.com, 
	daniel@iogearbox.net, dave.hansen@linux.intel.com, david@kernel.org, 
	derekmn@amazon.com, dev.jain@arm.com, eddyz87@gmail.com, 
	gerald.schaefer@linux.ibm.com, gor@linux.ibm.com, haoluo@google.com, hca@linux.ibm.com, 
	hpa@zytor.com, itazur@amazon.co.uk, jackabt@amazon.co.uk, jackmanb@google.com, 
	jannh@google.com, jgg@ziepe.ca, jgross@suse.com, jhubbard@nvidia.com, 
	jiayuan.chen@shopee.com, jmattson@google.com, joey.gouly@arm.com, 
	john.fastabend@gmail.com, jolsa@kernel.org, jthoughton@google.com, kalyazin@amazon.co.uk, 
	kas@kernel.org, kernel@xen0n.name, kpsingh@kernel.org, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, lenb@kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, linux-pm@vger.kernel.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, loongarch@lists.linux.dev, 
	lorenzo.stoakes@oracle.com, luto@kernel.org, maobibo@loongson.cn, martin.lau@linux.dev, 
	maz@kernel.org, mhocko@suse.com, mingo@redhat.com, mlevitsk@redhat.com, 
	nikita.kalyazin@linux.dev, oupton@kernel.org, palmer@dabbelt.com, patrick.roy@linux.dev, 
	pavel@kernel.org, pbonzini@redhat.com, peterx@redhat.com, peterz@infradead.org, 
	pfalcato@suse.de, pjw@kernel.org, prsampat@amd.com, rafael@kernel.org, 
	riel@surriel.com, rppt@kernel.org, ryan.roberts@arm.com, sdf@fomichev.me, 
	shijie@os.amperecomputing.com, skhan@linuxfoundation.org, song@kernel.org, surenb@google.com, 
	suzuki.poulose@arm.com, svens@linux.ibm.com, tabba@google.com, tglx@kernel.org, 
	thuth@redhat.com, urezki@gmail.com, vannapurve@google.com, vbabka@kernel.org, 
	will@kernel.org, willy@infradead.org, wu.fei9@sanechips.com.cn, x86@kernel.org, 
	yang@os.amperecomputing.com, yangyicong@hisilicon.com, yonghong.song@linux.dev, 
	yosry@kernel.org, yu-cheng.yu@intel.com, yuzenghui@huawei.com, 
	zhengqi.arch@bytedance.com
Subject: Re: [PATCH v12 00/16] Direct Map Removal Support for guest_memfd
Message-ID: <ahXJoHNoeCcaupzN@lucifer>
References: <aeennZlV60k81OBf@google.com>
 <20260506080753.14517-1-itazur@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260506080753.14517-1-itazur@amazon.com>
X-Rspamd-Server: rspam11
X-Stat-Signature: dngwxk5krgu6d1zk5ok6hwwiprax8jrd
X-Rspamd-Queue-Id: DF69F10000A
X-Rspam-User: 
X-HE-Tag: 1779812876-712079
X-HE-Meta: U2FsdGVkX1/QujJPmWVFcoDokqBb7C4CxZPR5CsAbWs6uL5p5t0jXMsC1nTTc8MUtsWwFmgl4Aksmq4sBGYjcT8tC+mOQgrLAwj5PjDfduMFazWFOPhX5eQar9Ihmvx7HCHwpPHgHYMthHN9QSFkcKOxiim/VBVTIfJfvuMtB13E7xr+0xxapiaMcwdhRwF4MmYu8BZAPf6taZwICHz/dMdlQFjaxI24KkAOnvl6ZvhIcOM0lZK2wcJclOQQGpwwdYa/wc6xbBPUE8FSmq4OfbponUJsDX6WW4nv2aPKd+gCQPPCbIx7VslgNPhoUpNHPG8r2dU3ZTVL0VySLeMJWgm048h/Ybsn90dy7X9feceFDAyXWuwJoxrafwm9ae00jbvxeRS79uqBMpBgXHHCIO41J2q9rdxlNv4ZLvLsjnZNtGahLcA0Pv5qE4V3QTuuCFB9ajFQd6KsnA293QTXvVrWCJvfWB4bx/+X8MayMXtN5ZNjEht7LdHkRbfnq5r9vQ0fji0lpaYBXL0Udeb405uQusSKz353dBjXgbASyg/LkvuEM1U9qEOeZbgdl55uJA05KUMb5Qfu1bys2UPpPYGXE6id3zyDDUTRSe9pgt2AdETpLcPU1Qgg/JyBqPYGAIubU35XT+w0RfCIDV6ILLkVkXrong37/3A5pi+qQGzpC0qgRFYyHNAZTZ2CJ1N4WiaznjTPhOeI4Tz9aFHsv8u6fv911TqU6PXMiH6+7xjIjt0diH12P2z0k7rS5EZvSslbtC7121uqk7jFry2HwE9UY0cPHviG7vFlBdVKJBIn/HthrZfrb7wao2fR3Fzbpzoc7HAf0WeiZdX4TOI0Ndjt+K6ZjfBYZ2NcNxbW4BD5EbtKUI0NhcnmcY3MFULKKQHJwlS/+y825LUIxafZo826TnittlIC19JjyJuT8jeCI5DewoKvcqJGOZoccBtY7oK1LrB1W5Y9fyIzRA+
 /STAiDzs
 aqceS/tTqwZqJfWAKCK0FTMmzJtAAYWySgeU+7dpjNgYWkur/QbEMngbV60B2T8l2KnqPJDa2lSVDSXOnaKKPxGrre69JmfhFM4Fr2ih4MQlUbqCO3wmXBJgdihiOmvkpKtdtodZr5DQjUMGJoROm6oDkht8fw3TBRf91qU5EYrCOjc89J50yPLiFHt5e5VggYImHSucyaYhthnCkXqVM+DoA3FEBZ3ib4uOeJiAVdehJFrJnLDda1vWHL4VGQQZtheTwH/8AcmIE3Rs/wSgCM0lHP36kSJwUbfKkfnSYtZgUxQRbZq8iehQZfWEoBzF3Smpz1S529TnNQ/R2gZXdOV+z3oO9woQra64d2O8yy79WOccVwjndl/NVPBQ9K8TEVlBf5EMlaV4DJ1g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 06, 2026 at 08:07:52AM +0000, Takahiro Itazuri wrote:
> Hi Lorenzo and Sean,
>
> Apologies for the delayed reply — Nikita is leaving Amazon, and I'm
> taking over this series going forward. Thanks for your patience.

Hey,

Thanks for letting us know! And thanks to Nikita for all his work, will
keep an eye out for the respin!

Cheers, Lorenzo

>
> On Tue, Apr 21, 2026 at 01:40:00PM +0000, Lorenzo Stoakes wrote:
> > Hm, given this touches a fair bit of mm, I wonder if we shouldn't try to do this
> > through the mm tree?
>
> On Tue, Apr 21, 2026 at 04:36:00PM +0000, Sean Christopherson wrote:
> > Yeah, when the time comes, the mm pieces definitely need to go through the mm
> > tree.  Ideally, I think this would be merged in two separate parts, with all mm
> > changes going through the mm tree, and then the KVM changes through the KVM tree
> > using a stable topic branch/tag from Andrew.
>
> Thanks for the guidance. The split makes sense to me; I'm planning to
> follow this approach with patches 1-6 (mm) going through the mm tree
> and patches 7-16 (KVM) through the KVM tree on top of a stable
> branch/tag from mm. I'll confirm the exact boundary and coordination
> details as I prepare the repost.
>
> On Tue, Apr 21, 2026 at 01:40:00PM +0000, Lorenzo Stoakes wrote:
> > In any case, we definitely need a rebase on something not-next :) if not mm then
> > Linus's tree at least maybe?
> >
> > I'm seeing a lot of conflicts against mm-unstable, it can't b4 shazam even patch
> > 1 and in Linus's tree it's failing at an mm patch (mm: introduce
> > AS_NO_DIRECT_MAP).
>
> I'll rebase onto v7.1-rc1 and resolve the conflicts as part of the split.
>
> Takahiro
>

