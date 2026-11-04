Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FB6F606A326
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 12:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=b4/4svk5
Received: by kanga.kvack.org (Postfix)
	id 43E676B00EF; Wed,  4 Nov 2026 07:19:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EEB66B05B1; Wed,  4 Nov 2026 07:19:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 305086B05B6; Wed,  4 Nov 2026 07:19:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0F6EB6B00EF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 07:19:28 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9868C1406C4
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 12:19:27 +0000 (UTC)
X-FDA: 85397341974.26.B2EEE1C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 020C5140009
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 12:19:25 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="b4/4svk5";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793794766;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qimrld6Qquu3/RsDXXsu/ihBQCwzuzT0jn+pZL1CadM=;
	b=rX+W1/t0TIPT5fMDHNK+gyhVRh4p1U5NUeW+RCl0/vaUT40Cm5jQGD7vS8PufYLQrSmAfO
	aGUPojSaT2UPMmTeEy9xw0cIz1VYKVu+hZMBlQNo4ddxfn9hrQ2AsxOcjIhAlVOt9Ftr/V
	PX0BGLrICCh0YEbgpzbzxsQTc2RN9IQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="b4/4svk5";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793794766;
	b=kh2qdVBSawlBTUt5KtoUrBQ4dikEsKQDBhw6OB7y7baxagETTsBoH2MgjCSfWtKfhytR/y
	YuwV0s386DlqC6hob8443dIvjVoy2oEihdyiHY8v8biJO3o+fYnHdqUTYfbfc6Qjq3JdEq
	o9h5ifrU5ya1J0bHkK4S6/wyekSQXew=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 82D4D60F0E;
	Wed,  4 Nov 2026 12:19:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1B771F0093A;
	Wed,  4 Nov 2026 12:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793794765;
	bh=qimrld6Qquu3/RsDXXsu/ihBQCwzuzT0jn+pZL1CadM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=b4/4svk5xILGPqtP0/hwSWfdCQyIEn7TvGLMRqs6SVM2qgtnJStNRGARXPHXsGO/W
	 JbY1D+VPYxoXvMZmIlWgfmJ3yVe14wVT6w08BHZTT4TgPKvw/xJlozDoibhyjndx5x
	 z6/QCycXlGIj4lV7LBOdScLxYtYkgITbtLogDDXqe8DG5AMY7YzqQCdY4pGVg7g77k
	 z/L8LNVlOQn9lueTtR6Dxl3fqSQa5pLTzmcN+FTmzmE3uDIAmpHRv/xNTC3PE6CQ6w
	 CPexOQidh7O5eMEfOFfg8ShJFNeW13SLdMLDCd0GA+SVTueP6vY/QYGWfRBvh9XvTx
	 byUQEBEzPkFxA==
From: Pratyush Yadav <pratyush@kernel.org>
To: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Mike Rapoport <rppt@kernel.org>,
  Andrew Morton <akpm@linux-foundation.org>,  Kees Cook <kees@kernel.org>,
  Alexander Graf <graf@amazon.com>,  Changyuan Lyu <changyuanl@google.com>,
  Tony Luck <tony.luck@intel.com>,  "Guilherme G. Piccoli"
 <gpiccoli@igalia.com>,  linux-mm@kvack.org,  linux-kernel@vger.kernel.org,
  Pasha Tatashin <pasha.tatashin@soleen.com>,  kexec@lists.infradead.org
Subject: Re: [RFC PATCH 0/2] memblock: keep reserve_mem regions out of KHO
 bootmem
In-Reply-To: <70686061-787c-4c99-ba5b-ff982c8cc2ad@gmail.com> (Jose A. Perez
	de Azpillaga's message of "Wed, 4 Nov 2026 11:50:02 +0100")
References: <20261021211058.83483-1-azpijr@gmail.com>
	<2vxzqzhhg8l3.fsf@kernel.org>
	<32dd1f28-db55-4674-99bc-74d9d3ab25db@gmail.com>
	<70686061-787c-4c99-ba5b-ff982c8cc2ad@gmail.com>
Date: Wed, 04 Nov 2026 13:19:21 +0100
Message-ID: <2vxzfqxglrg6.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 020C5140009
X-Stat-Signature: 9t4p6zfo1zrhrd4juo3c6sh6qp1en3oe
X-Rspam-User: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793794765-990917
X-HE-Meta: U2FsdGVkX19iuXcGgVuti4cL76GLDCOQkCWwgvTIaj0z3WOrP2/Ll0DZQ+QacUVBXprOORFGCHaFo2BLDNFp4oANA+oVTr0k4yCZT4h0wYkcT1hx739MfSi+88Zpe60ySdNxDltXVVgUbYPveueW0rAYRHBH5J/Vgh5xzT+sJlsu3HsgbGu8BaHiFxGqtdv22GCduLIOdoXEPzyHuJNWfCYes0dS+C2LQk6darHmwDaYaTfmAWrS57VgmkJbYfmO9yk0XxoXPWrdw8h+/2rOPmRSsu/XJvuGSsqPuI0M4jT/QmAl1e/indWVov0F9P/75MpURTttbhUYuYCagO9VCF8jcOI383PnM4nW2FlOULR/8FLgtnbAUbWNUXFw3H3xpG94O5NvgBiB7klvTgwE7GvjJaZuxD9G7Wj0rJ7aX7yposlWtW+go9owZv3Mztv0QVifndsMJm4v4NgLOclnqwGbRwAhP1Btzv4qNyRLfi6kMUYSZik9GzU2lw1gqbOUJgG5QlWHsnHlX5CTuQ02du1z3Liw34u9ffUnLlF/QobU0/QbXhpx5eem6GsiJfJcqXlwz1fuLuNodrw+4eZbMAjI9YUli5cj5DJyEGuYGL5+hQPWmqfvB7RZZsgklU21GnaMYy7z0X+ItAL78mp7HqX9gaBrO7uy78pttmgon3EoxtfqHcTwsm6062lWv64oJlccYi17WWOcPot8C8c9ZDwthdzDH/LvC+P4HylQzfI2We/fSbEqosBsUPrWi0Mm/daYij4jOjG2YWJeJkN546wD4llRgeCZc1CRXtBdZxPPwlo34+TZuVKPny+VZyAMHnDki8OSQr/xXE9H8iN6r0j8P2+HbP4HgRO8QzOP4HpRWnHHEDoljpVpSLbfBeziIqJKh3ilN6Yz9DA0U+ISnm145sq0wV8wwZoQ/Vxwv+TjaCYebd+9VVQtJChB/sk6efBDsp6fUo+GtDO/dIO
 ypQLbH/Z
 eGHbj4lpcTWFi3qk8dd0PUzXXfVsTUlIH3G+5aT7CYUuOwm6w9eOotctyvIrE7Y1g/y4dVGwG9IY24zCshRWeBg9Gz6f0yECShGokGUaPszoO8+jgXOPt8ynWLMG5F1e6RNJ10/G3SyCG4M0lLOoYMNDRfxK1l0yZbin84jEe3elSwpSrH08LbUxVoBz4dUGSu0BtDYLJC/6mslJHWh1bX6NeBXGH5GuVSe/h7QyGcPyyyn5s+vRo3Kb12IAmO9Eu6nRM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 04 2026, Jose A. Perez de Azpillaga wrote:

> On 10/22/26 10:16 PM, Jose A. Perez de Azpillaga wrote:
>> On 10/22/26 3:37 PM, Pratyush Yadav wrote:
>>> On Wed, Oct 21 2026, Jose A. Perez de Azpillaga wrote:
>>>
>>>> On a KHO boot, a reserve_mem= region that can't be revived (new name,
>>>> size or alignment) can be allocated from KHO bootmem, which the next
>>>> kernel boots out of. With CONFIG_KEXEC_HANDOVER_DEBUG preserving it
>>>> fails; without it, the next kernel's memmap ends up on top of it.
>>> What's your use-case? Why are you adding new reserve_mem regions after
>>> cold boot? I'd rather avoid making purely theoretical fixes.
>> 
>> I don't have one, I found it through the TODO. a different reserve_mem=
>> in the cmdline passed to kexec is enough to hit it.

If there was a use case, I wouldn't mind fixing it. But I'd rather not
add code we don't have a use case for.

>> 
>> if it isn't meant to work across a live update, would you rather have
>> reserve_mem() fail on KHO boot when it can't revive the region?

This sounds good I think.

>> 
>
> ping, I can send a v2 either way.

-- 
Regards,
Pratyush Yadav

