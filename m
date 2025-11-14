Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C547CDE032
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 08:33:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4387C8E000B; Fri, 14 Nov 2025 03:33:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40FF78E0002; Fri, 14 Nov 2025 03:33:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34CA78E000B; Fri, 14 Nov 2025 03:33:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 263B88E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 03:33:19 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B18D41A02E6
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 08:33:18 +0000 (UTC)
X-FDA: 84108548076.10.398E75B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id ED5991C0007
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 08:33:16 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J1V0ndcd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763109197; a=rsa-sha256;
	cv=none;
	b=f70cQiG05gheVTPOmCZueZ5qeTaVfIpRkMhov+CTpgrDNvDJBJoQjLZrQG+9o1krI7+e5/
	mJCaIlGIC5qHVT09yi0z4F72h7D14wh0JvtWRguoN3VGJ6zADPUkwiMnttmBJpGvJqRwn7
	UB/SZR1F8iT21/qcdW6QwHkEMt31vB0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J1V0ndcd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763109197;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZHgVsRKpHmyQN72jyqA1Da8LZYB/Qa1wjoUWBMw50tU=;
	b=lMYk6hhtLD1Ql8JCpLh2N/+P1dpb2Mbf06tWAfIQGNsbYvf07JmIsf2XkQyBDdA+1t3DhR
	jbpH7tFc2GMzaGRPblvBXTP4+/7zUtcvXvrB6yLfGEbs0G1YtwRwvtMQCk1XtiEZQKyOB2
	ecG/yGNlziN4RrsnvUwUP4wH/jEDIo4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E9B17436D4;
	Fri, 14 Nov 2025 08:33:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74B3CC19424;
	Fri, 14 Nov 2025 08:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763109195;
	bh=PFl33I0QJqg/12ihlGpsei/r6GgKWpKb7KCY1L2LsGY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=J1V0ndcdbmJYb817ivKEItL2rF4KI8nAuQGaxTw7ZVBI+LbR1RTSstti1Fm4IzhiY
	 VzfYk8Q66tG3c7SGE97UTkwH3vaKsELxUkz/zws2peiK5UA1Hv1SiNOKxg5htGU06U
	 +WQSI9qwkp1O5BH8tny+ZmVb4Hu/cX/kdOuu8d2T8Y7gSxxKOqXTZwpf4CmJqkrpw9
	 96Iyf55ubQo0ob2h9TBcjn1gA4caqz1BqSB8e+NmevZZQ1Hmp7qgtvs9tB0asx5Xv/
	 86hCNcS3CvgtobtHS3+6a8vx98BPwizKfvVDfnY+2JjVhcvMFQcSyMejS7BqAmPQK4
	 w4/Cx+Y28i6Jg==
Message-ID: <95e27bd3-6ce7-46a3-81d5-0fc830908b10@kernel.org>
Date: Fri, 14 Nov 2025 09:33:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] gpu/drm/nouveau: fix return type in
 nouveau_dmem_migrate_to_ram()
To: Balbir Singh <balbirs@nvidia.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, dri-devel@lists.freedesktop.org
Cc: kernel test robot <lkp@intel.com>,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lyude Paul <lyude@redhat.com>,
 Danilo Krummrich <dakr@kernel.org>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Ralph Campbell <rcampbell@nvidia.com>,
 =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Francois Dugast <francois.dugast@intel.com>
References: <20251114012221.2634832-1-balbirs@nvidia.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251114012221.2634832-1-balbirs@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: ED5991C0007
X-Stat-Signature: nuxb9jcqo3w6sc59yh5ukgwapjsfrjtq
X-HE-Tag: 1763109196-982361
X-HE-Meta: U2FsdGVkX18O4WRlwA3zk9PQ0tcrQS/btJVsX4EBm7hAnG4dO101LBD9jGV/3d4on+hySsqwO3Fpk4aTgMnk3VXRQzhgybhj+BvpRJRlPDPWtvBpdaNso434PDERsarP2BQdCMCpa95HU+owIHxmfR8yW8G8aQ6apxEFSMyd366bhlhSuA84wxVToM0s1MHjSX1437j2Yu7KWvWDef26AZV7O8HorPsGrMGJpR/0jreKQdm2c5vRNcIwZRvCGKQRcCbvtHqnRLtEomrRU3lfOSFyydauywTumq1QD0uLHAQ11DEwpCjveg5iMWwXtVPhCw0G3LNftSbe1uWFvqK8c0OujSpNFdyDwnzkSeXGR90x+rchGJkkPBuP1Rxx6rHDltM+y5ln96zCJ4rI1Gf2OSYt+iZDBher9G5l2YlkNNSeH/pDRjY1623YwXXwJYLwNDBcLM3cvXp5oPQiXLc9mkOkrQpBPAvjlUkUM3W0yWByt24CBDYDRif+f8rZ1YuvtymAYJyFZ5ZTTJdCgckIpwDeDgPlsmOTAIipvZiY3IKeFmF3DxixDyCt56+MvOYH6nH5aMDPeAQCrv9c0z2TOKLCU8Rd3Mvx81+UnR2Eu8opuTaQuRUMpyNSbeipsn2zBOItrKiUqhn0874ED18+i0IfJirQnUJ7G34YHciDheTpr7BmG2r/+39iKEi7jLBuHMWWZE2By10mtXxdzr+tmSCW6+jX1PqXDbUXgUR+JpShZu2Ox5Oq5XLennJw0bG6384P4xvdK/zOTm8Vjjmn+EyGApEACw7kFAZP9/R4f/WC3FMJ5/NbJ3d8vnl/CeNMOQv6fz1LFhm1LgYtOkyzheHPVzBIfnXh7/7Xm4igNOOAEgvhgrjbvlmddEb9xArNyWr7CZNe1SNbiKgp5VExSg3dbfcsQviJux72gY9g7+9cx9SlXZsS3ZSaW5sHezSLJ8gYmCIwf+vVubm4+bC
 qee6QtmK
 F0yKe8mjAdQfSs8m9plZ1C9m1R/XE005pkj1HKX767rSNNCngAyHmpMDtNBAN+nzqnvwD88l3IlFzFDwWdc5NLAyNWHztu/KK2YK6pBeQBuaWwh49wBD2Ua926zUo/TC6ygQT2uqMjJb2SYheZD1hZqzZ3VY5OwUc5VpPZzBPHO0tXLJa4/kyjSyp/6XIu7Meakf4E9Tjo9Xe7WFTgWHn8yvGXmeUqqluRix+yhN1+T0nfePc7fGvAeDqD+Nta+ePJfGp8z+eNRjBDGfds83ulGf7YVOwv77t0P6EIU3zclB1GLFk9xlFwAzme3SFbdBM0h1Z52DfOUC+DVpJcNMlPEHt9Fw71bzytbAZFvU8rjPb/GAcju5i0JGiIq+6rA/4jcvQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14.11.25 02:22, Balbir Singh wrote:
> ret of type vm_fault_t is reused to capture the return value of
> nouveau_dmem_copy_folio(), which returns an int. Use a new variable
> err to fix the issue. The issue is not new, prior to this the function
> called was called nouveau_dmem_copy_one() and ret was used to capture
> it's value.
> 
> The bug does not cause a real issue at runtime, the value is used
> as a boolean to check if nouveau_dmem_copy_folio() succeeded or failed.
> The different types should not impact the execution of the code at
> runtime.
> 

Also, as commented previously, the prefix in the subject does not match 
existing norms. Take a look at

	git log --oneline drivers/gpu/drm/nouveau/nouveau_dmem.c

and note how it's commonly something along the lines of "drm/nouveau" or 
better "drm/nouveau/dmem".

The only patch that uses "gpu/drm/nouveau" is from you recently. In 
fact, there is no other patch in the codebase that uses that prefix.

-- 
Cheers

David

