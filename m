Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01362D39008
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 19:05:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 620D26B008A; Wed, 14 Jan 2026 14:05:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CE056B008C; Wed, 14 Jan 2026 14:05:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DA556B0092; Wed, 14 Jan 2026 14:05:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 39DA56B008A
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 14:05:15 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0359D5991C
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 19:05:14 +0000 (UTC)
X-FDA: 84331497390.20.35991B1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 452CF80012
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 19:05:13 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TBE16hKH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768417513; a=rsa-sha256;
	cv=none;
	b=42m6UEQnR6s5GfOv2MH1xFaMdk2Oihhedtt0IEHAWBQin7Eqmx7T+lDxPfk1bmMtT+5Mx1
	j19byQ+0YXHEtOIdahBS3mGN/yQlrA6hc4X9LGerSgG6XM/l89Za5kqO0ZHXj0xJrlvx0A
	E2h82YypprB7sqasz6KZjMOUnHvnWLk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TBE16hKH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768417513;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+EXMu8fVYrjqzrdjaSOI10qKA87dcHyKFOPIbUS4EPg=;
	b=ZJipa5fp1Fe8u3LHS4ETzuegdM7kr52qQBHYvAanafVH3MD3bn4u3MF3e1sNeAb+LffouP
	abHtxfjFR+BlkEWVBckQnhAOpfHHB+e7OBIeW+rx0hMcCy110gtHL4PfIX8iAyR3vTYt1Y
	bLh89F97vuDyYdSULqRQJN1DpM1UE8k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 512A24407C;
	Wed, 14 Jan 2026 19:05:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10075C4CEF7;
	Wed, 14 Jan 2026 19:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768417512;
	bh=2QKYOyEjrfuxHKVNPGX4pgerNIQSPvRZMBbE7X+COHs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=TBE16hKH5B1htBPywslXb3uE1G9s3+1zukbdGdlVTRKU9+GHpwxCGNVyD1rJDG1sM
	 ypztzWs0yTDPqUuo7+Okx21fYvpOZtelOEspY4N6lXkNszYpELSMVN38Q1hHI8MSlq
	 FWHgj/wokP9nwQNMeJQ63AH6rS9qTMdQjX6jVx0AybrqYwcB7BIuXADDiJ7tPTDnuW
	 LD2sI+eUuTnrqfONFyvw7KdIaO48b21ooICSQyR5GtdjgqDLPDB7z9CMO4L4pV9iVS
	 ob5xMRHaDy6gwcsXgZYz/BGOHmAhKuXjDI6lXx7WxrfA2J8nUuvjDRp69QFrjmNZ4g
	 Otpd4WLe8rG2A==
From: Pratyush Yadav <pratyush@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Alexander Graf <graf@amazon.com>,
  Mike Rapoport <rppt@kernel.org>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  linux-kernel@vger.kernel.org,
  kexec@lists.infradead.org,  linux-mm@kvack.org,  usamaarif642@gmail.com,
  rmikey@meta.com,  clm@fb.com,  riel@surriel.com,  kernel-team@meta.com
Subject: Re: [PATCH v2 2/2] kexec: history: track kexec boot counter
In-Reply-To: <w542cckfixvgo6pvepdg6itaera6qlq75pemqvpah7us6c7yxa@6vm7ebxd6ala>
	(Breno Leitao's message of "Tue, 6 Jan 2026 03:04:28 -0800")
References: <20260102-kho-v2-0-1747b1a3a1d6@debian.org>
	<20260102-kho-v2-2-1747b1a3a1d6@debian.org> <86o6nb7oi1.fsf@kernel.org>
	<w542cckfixvgo6pvepdg6itaera6qlq75pemqvpah7us6c7yxa@6vm7ebxd6ala>
Date: Wed, 14 Jan 2026 19:05:08 +0000
Message-ID: <2vxza4yghv6j.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 452CF80012
X-Rspamd-Server: rspam06
X-Stat-Signature: ct6c7bkpjaoieehqdr1t8acrjszsw4qi
X-Rspam-User: 
X-HE-Tag: 1768417513-870143
X-HE-Meta: U2FsdGVkX1+5dRBzGXk/bRcy4DIsm3OKrF+Q5pa4FeyUPojGPSnWf0RIN2qn2cJfnNGi8CKC4o+1r8LdDjRScXRW0JfY11bWXxtqD59DreHgX6jx60HEp2bCWUtYLy3X11mFgKe07hED8kZ0YsqJ/ltnvMyxOCFTu8fOyEIzjxk2bHyUsf3yz/soR7eZdyBuUjoUs64H4uNfedj5nAcCapfGcybX3d/03/sxW+50pNG9enzozOkDcqwB1aJfjymT9w+O1ken0T+36kJlxbvPiV98jSF44Gj00TzQLjcvp8VGdOv5XIFXisUhUuIjjotbDMp/iQmo2szQU3c3WdxQ5uBjhD371nVkNVdlszUeSHryN7QqqflZVj7RVWSPnzEyQvCYrtMOMqV47D+PsW9iWtsi6634O+vngPPkW8R2iRPazdTFvZeCAqBFl4SpHmv8opzngtOBikW2caeZeheib8jn97YiMxOWhlkrVE2sgxuj2gEYQkJly26Bjqoi2loaF2mqYS3UGxxuDp1QH4tXihfk16+9coT+muunjd+RmleS3oW3CwyWzJUhzuJJvFd8BKLMzqlkL5fDu5yKpmxNQjLBTc0TtTmhVrV3HReniPuGhz+aKbxf9FNeyckjj99tz3pjAhlMoUt+OHV6/zwlLmiLTtC2BKt3SM3a3gXY5UvSyavlfgSSPmSvsynQy8GGaZPz7y4WIWHaZl6jfG9Rj6QkqABK0DnpSfpF+QgLDGnJXbn0bTbpDkIbnnNlxwZb1L7pzAEAFyYq39JBrXtt6SZ/23Hz+R16M0P926y6hUIjY+dLLQCK6VXzyJcZNdnOiHlx5U4zY3sPZTC3g9SSXy5Uxd775zHZLveRoWpRscQkO++qQja2zmvhf8eE9u3gXv3jKeb46pKS0LbtLreh/7AQPGVlNxL10tblGj+CqAqiAujELhYqb2XPadAiksUw4rx6gdXUeGkMPWsjtRp
 W0baZ8Kp
 W5LtF5Vo7KFrbjrv0Vswjh4rqGeRrbDGHU06e/V0WqqyGfsRGvwvp8MzBqZxjeLZBLY67k5djAjvdKonT42HcOlrjXVjrofOze4GfooLnab78iDIqsWFSghzQ9wLX84Lnkyj9eDJxgEAyvipb5rmUVIspzV9aZBjbbXak0Ajxy2yE/MI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 06 2026, Breno Leitao wrote:

> On Fri, Jan 02, 2026 at 09:23:18PM +0100, Pratyush Yadav wrote:
>> On Fri, Jan 02 2026, Breno Leitao wrote:
>> 
>> > Track and display the number of kexec boots since the last cold reboot
>> 
>> Nit: this does not track kexec boots, it tracks KHO boots. None of this
>> can work on normal kexec boots. Can you please update the wording to
>> make that clear?
>> 
>> > when CONFIG_KEXEC_HISTORY is enabled.
>> >
>> > This extends the previous kernel release tracking feature by adding
>> > a counter that increments with each kexec boot. The counter provides
>> > visibility into the kexec chain depth, which is useful for understanding
>> > boot history in production environments.
>> >
>> > Add a new property, "kexec-count" in KHO FDT alongside the existing
>> > "previous-release" property. The counter is:
>> >
>> >  - Initialized to 0 when kho_in is instantiated.
>> >  - Incremented by 1 on each subsequent kexec.
>> >  - Printed alongside the previous kernel release version.
>> >
>> > The counter is stored as a 32-bit unsigned integer in FDT format and is
>> > only active when CONFIG_KEXEC_HISTORY is enabled.
>> 
>> We have such a counter for LUO as well from the properly
>> "liveupdate-number". If you're using LUO, why can't you use that counter
>> directly?
>> 
>> If you're not using LUO, I'm curious, what's your use case? Right now
>> KHO only supports reserve-mem outside of LUO. Is that what you plan to
>> use?
>> 
>> Also, do we want to keep both counters independently? Or do we have one
>> and drop the other? Pasha, what do you think?
>
> In fact, I do not have plan to use LUO right now. My goal is to pass the
> kexec release from kernel to another, and for that I am using KHO to
> pass this information.

Oh, cool. Nice to see other use cases for KHO.

>
> That said, I am planning to use KHO as the infrastructure to pass the
> kernel version from one kernel to another.
>
> Given that I don't think this "feature" should depend on LUO, maybe the
> counters should be independent (?!)

If you aren't using LUO then you certainly can't use its counter. But
LUo users are all KHO users. So perhaps we can get away with removing
the LUO one and moving it to KHO?

-- 
Regards,
Pratyush Yadav

