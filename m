Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2E5DF8A14D
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 09:44:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F9416B0093; Thu, 16 Apr 2026 05:44:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A3C86B0095; Thu, 16 Apr 2026 05:44:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFB946B0096; Thu, 16 Apr 2026 05:44:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E08E36B0093
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 05:44:13 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 27E8B8C452
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 09:44:13 +0000 (UTC)
X-FDA: 84663933186.30.BC2EE49
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 89514A0004
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 09:44:11 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=naarDjEy;
	spf=pass (imf15.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776332651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JrmV0E2FR5QIiwCjjUz4crYhfG5jwFca3BcKbwvfTbU=;
	b=YceL9v7fatXeD7e0Mw4NMjW6iN47O/yqi+eUonchTg5pTU8GGtnDLQUqxjpUBJO1fimY+Q
	bxzFUyop05d2gVjIbWHs/w95//jWrEHUPPdAOkb11QJJ2HtxilueNidbjA5GyiHD5v/wu7
	G2KQiijQ2MUXA3yabuxPuucgMZLfi5o=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=naarDjEy;
	spf=pass (imf15.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776332651; a=rsa-sha256;
	cv=none;
	b=AlR9uiagsm5ZyOt8e56FxCLVWSzvkbUF9fGgqoh/RJQlR5lkRNhLlDJJMsOdT8SDUIexLn
	4kOvRi+NpPpHm7VlLlGYLWnjz9b6J146WwKz43F+sTa0VcBToJwaotWObxfZ1dhJhE+8S7
	qEsNSEjZHuETEpRfz1TKllUbfozrkPU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E10EB60123;
	Thu, 16 Apr 2026 09:44:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A991C2BCAF;
	Thu, 16 Apr 2026 09:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776332650;
	bh=CPSWvjITVlDgLqJaNBJ4mUklmtrmxg+VXMXbQXCouI0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=naarDjEyGSJoW4LnTL4F2XkqZixsO54podpGe54idT5LI8xKd9lFol6POyM9EjwyS
	 HjZsccyA4hqkKhLkrYCnoqCfkUa0DlTmc/CeJnpiLKHlNmBtzxHFpZepRWmzlbGiSL
	 6Ne/oUuxTDNJgwK/UpkYdnUuJScKVNdxzdQSH8xVfbgM9t5Mu0SXmZQGKv+wfHLWUv
	 W8/alr94CH26BOTOvpFAhpeXQ77+8RXwF8KoNd5n8hPwv9JC7u88P/yzdtWlbJQ6zb
	 nV05JT4Q4zSuYVxFN9IExOz/LY9yI5Oi9bhQDEoX6kf1oZ3Owy6AgzcfwFij3w3tfJ
	 17PuGeGbNQdpg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Mike Rapoport <rppt@kernel.org>,
  =?utf-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>,
  Evangelos Petrongonas
 <epetron@amazon.de>,  Pasha Tatashin <pasha.tatashin@soleen.com>,
  Alexander Graf <graf@amazon.com>,  Samiullah Khawaja
 <skhawaja@google.com>,  kexec@lists.infradead.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org,  Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v7 2/3] kho: fix deferred init of kho scratch
In-Reply-To: <DFD0C0F5-F23B-44CA-B2C7-9D03F2397DCF@nvidia.com> (Zi Yan's
	message of "Tue, 07 Apr 2026 09:21:25 -0400")
References: <20260317141534.815634-3-mclapinski@google.com>
	<AD9E1B18-C813-480E-894C-FEEB51EE8A93@nvidia.com>
	<CAAi7L5dSOxXETv-bYs4hJ1SfixMBQXS4fmfKs3SzVvQ=yY7oSg@mail.gmail.com>
	<76559EF5-8740-4691-8776-0ADD1CCBF2A4@nvidia.com>
	<CAAi7L5ex+66qgFzRkLDbuOmC=cVrMyBctPZv6wd15n1rc2U9KQ@mail.gmail.com>
	<0D1F59C7-CA35-49C8-B341-32D8C7F4A345@nvidia.com>
	<CAAi7L5fvUPUqd3A4m6wubeYh90NH+S2KBRE1R8WKerBYhkU8kg@mail.gmail.com>
	<58A8B1B4-A73B-48D2-8492-A58A03634644@nvidia.com>
	<aburnbP64n9axmu_@kernel.org>
	<CAAi7L5evx8ta8BifNiGNfUoTiaBUsv4cgQRbm_15RoAfdKPcMw@mail.gmail.com>
	<acAAp4JaTGn_STBH@kernel.org> <2vxzwlyj9d0b.fsf@kernel.org>
	<DFD0C0F5-F23B-44CA-B2C7-9D03F2397DCF@nvidia.com>
Date: Thu, 16 Apr 2026 09:44:06 +0000
Message-ID: <2vxzjyu76xzt.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: mhmufp1p1hy1gfgpcjte5nxauebc7orp
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 89514A0004
X-HE-Tag: 1776332651-612403
X-HE-Meta: U2FsdGVkX1/9EkJyzGn8Hvy0zocJgI83ULDfp4VeooWbTvE1QI8TzUa7VannaevrqFuUzH8gHVSTtic9qNGpkssYfeW37Mrs9NjuOMfylgU7PlEiJpPp4RxusDj0gdLkerFTWOpw19U18Wj5Ya18LvBseBszSRCTnJTY9hkhLbfy01Ib1rhxlhdhNVsT13ROniwecXT2BEVEr2OMkNbysnQ9qUNzGrvI6CCqxRky1TGs9xBqaQAef80dyI/RDhdswOq/Z6s+355AbpdiIO2UJaLy/dysUT9LUskCtDA5SuEdNezr6M7zLPI7/VJSejdfJ60Lgr+2RfxYcVi2wuR4CGgjkHtLIgo7qdzjSl9JfOgo19+IuaaOTLs/jfbJ828v47og6SPZttg9YtPxQcPIQ8WPK7OBy/Voo4ZmqJIdE92K2hk4XcmOvFAi9Pl2iHl1FV2GAilASgZAAhlbwdCeEqNPzBx2qXiiT+cut/VbcJKIm2BeH2Q+O+1DPde2O8U1BHcX1gEEiP6iV18/aBmF3SJPrz9Wf9Z1L3gBnzvzoSbsooXf2TWalddQ0W+/3CVZE+8MWSB8dro7tLbCJ7wgy1zq6Qv8aVIwTi00SYOo3ZoTxxHN+DVnY8Egqlso/2J4a+LlKvVxIN0v7rd11zecY01tbXXzA0iSXgOmsDH9RSJbVooeuVQepKCrl7Nvzw27FEENsf59RovVriTYvv6FYK3wdKegOqoomXgemoaZ1W8/zjotMy94DMCty4dcF9RJ3EKE68bLQg94MBe9gwDnJ7r/kKDUjQ5/k2zzvveLOKTjIqS8RORJjg1MI0uXhouhKdhVdpMrhn+x/T9RfKJeumvxDBCn1z7ggDwSZgqxKRgXyLmNttv9gp8wZhY8HB6+67w28EoiyqUhOqwr2kbrb5pLelm3cuQhkufKqsJLYbQ3tQzM7hBU8aob9izLsa4OTiRAHMBx7PSSzDHRF6M
 4DtYzzb3
 KkR7C82b+nGaujdCP9KTjzClM7nPzC9fxGwE1SmPvjoGMdXvPILn+uG7sd+HYLv5nXRwMt6I+PO3U0xsd0xvqaR0HoyZs6N36qfWot+Li3Jk93Oqn6gIwJNXXTEEilKq15L83AOmpdVvnlSXj8N7WrOFqPqCyAzrHkAkGK7dFPb1S3W4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 07 2026, Zi Yan wrote:

> On 7 Apr 2026, at 8:21, Pratyush Yadav wrote:
[...]
>> Hmm, I don't like that how complex this is. It adds another layer of
>> complexity to the initialization of the migratetype, and you have to dig
>> through all the possible call sites to be sure that we catch all the
>> cases. Makes it harder to wrap your head around it. Plus, makes it more
>> likely for bugs to slip through if later refactors change some page init
>> flow.
>>
>> Is the cost to look through the scratch array really that bad? I would
>> suspect we'd have at most 4-6 per-node scratches, and one global one
>> lowmem. So I'd expect around 10 items to look through, and it will
>> probably be in the cache anyway.
>
> It is not only about the cost of going through the scratch array, but also
> about adding kho code to the generic init_pageblock_migratetype().
> This means all callers of init_pageblock_migratetype(), no matter if
> they are involved with kho or not, need to do the check. It is a good
> practice to do the check when necessary, otherwise, this catch-all check
> might hide some bugs in the future.

We can move the check to memmap init, so it will still be done for most
pageblocks I reckon. The only other callers I see are zone device and
CMA.

Anyway, I get your point and am fine with moving it out to memmap init
functions.

[...]

-- 
Regards,
Pratyush Yadav

