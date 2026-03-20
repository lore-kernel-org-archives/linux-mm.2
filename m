Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5309108B902
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 11:41:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2CD96B0005; Fri, 20 Mar 2026 07:41:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DD956B0088; Fri, 20 Mar 2026 07:41:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CC3E6B008A; Fri, 20 Mar 2026 07:41:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7B8236B0005
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 07:41:10 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2EC4AB683D
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 11:41:10 +0000 (UTC)
X-FDA: 84566250300.02.82CBD4A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4F4A44000C
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 11:41:08 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BbSL0S09;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774006868;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IwzusTKZMjuTjx7KGN5o+AmlaRhHNTJYRt6qIwGXNYU=;
	b=q5uWrR9SaNbXJMndS3/APT7Jz8eTW9Qr82e8K0VZbHMRtcTK8QnFF4RghJrqVAtPCj6NJc
	1guWINCUrvPcJBcZ2T4StwyU3szC1xhJyqivghfgZOArJ2EXpSmQKFrUFnf9bh5W0przKD
	ATCx7rQ+z74phCxt6PH08Z4eNoTZph4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BbSL0S09;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774006868; a=rsa-sha256;
	cv=none;
	b=B2wsqskAre4nz0w+r/Jh0j2QGoTQZ1BAgQWZYAXzW2AwBDQUDhSZx8uKFQ2oJpfCOltJ/1
	/Dq4dpqR+5B+C/uuWKLGBhRAQAURcyeKl3k+kwiEUt30fHh00H2N/Q/Ivl6APzVPPqye82
	/rEfSFojjbfXkpYtOKQsbmMw3MdPPAo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 46C5243DE5;
	Fri, 20 Mar 2026 11:41:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F853C4CEF7;
	Fri, 20 Mar 2026 11:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774006867;
	bh=ZP22FKPvmoZEN2zvYQzJ4Q95BDfg0EI3zNhotznuaMM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=BbSL0S09gbjTOCH902eTaZWwFJxiLeFTOOB0ffYmk4eaCstJylLTx1t5vmQfw3sMW
	 FBMRq8KlvWpL9RknySCg/Y492McoR4jYgskaAyrGVYHIrcZ4eeFSNn0aQ8ypCGvgjG
	 lfg23tUFLhNdRJPXoTIUvDcwRh7KGTg/AsFBUXhM5zjomrWRfW4QWxwHpitwcXKeIA
	 jb4nm4inocCahiqGBS1wWaxnbzyMsjezBAX9clB6/D/XBeTHLT05CRFBfMgFru8tTx
	 WJiNRL4QO4VaqozpqEW6+ho4h+ACObKTjF3olxl/LyBzntH1TbNdMMD7mNhDBvQ6Fz
	 8YUWugdygI+SA==
Message-ID: <fac42585-ea97-4002-b35d-77a80d329103@kernel.org>
Date: Fri, 20 Mar 2026 12:41:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm: migrate: requeue destination folio on deferred
 split queue
To: Andrew Morton <akpm@linux-foundation.org>, SeongJae Park <sj@kernel.org>
Cc: Usama Arif <usama.arif@linux.dev>, npache@redhat.com, ziy@nvidia.com,
 willy@infradead.org, linux-mm@kvack.org, matthew.brost@intel.com,
 joshua.hahnjy@gmail.com, hannes@cmpxchg.org, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 richard.weiyang@gmail.com, stable@vger.kernel.org
References: <20260314154042.327ba957b1a8c10f64ae0169@linux-foundation.org>
 <20260315000555.76876-1-sj@kernel.org>
 <20260314172321.3ca062bb70e51fefa633a6fe@linux-foundation.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260314172321.3ca062bb70e51fefa633a6fe@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 4F4A44000C
X-Rspamd-Server: rspam08
X-Stat-Signature: d17q66zmsifkoodjx496qat3i1oj3xh7
X-HE-Tag: 1774006868-153416
X-HE-Meta: U2FsdGVkX1/ysNtT/GaI/feI741IBQnyZtr2kPy7nhIStjV1ecXNDwgm0dJh95YZdj8hmRbJGxaaeEE+BBP8zxcKTnaZMFpMARreyAI0WNLIy0mX0vVzUfuinzKnAzJkJ3SjRF8MfYEiBuZkO+tdimVSb+7EHc+mN/XKG0W59h/nBF4kEocvLo0tz2zhbqoSoKZRWKpIwS5HgSGjA0QMhsMQLwnNx2AzFeoOhQdxb96JvE6zMXg76tKIdCLI4eIeOoad64paYPMdYYRC/idmMSycgWFcufHra6gpJPKJIh6753iA+4gEHAgWWNjqZzgXV3gg3LipNg3FtwbSJpiVQjFHa6kRzBWhULym//jDIf6rylikGen8u14d+53j/263OI6Rc/B7E/AZJLYK69L3XdH5iy4iwdYZXrBtWIk7P5DZBDmyvBCBRBUi51vHuGp00/w3+m3nn6h/5dpkYYmnbgdAqHUN4kt9E2jzYy2bqIgJuENJ8nos8/tWKYr2GKFIscJZUYydh+3xfkxW0VsgJNwlu0DWnJS24x7ubWWEoormSKRCMmMJCAWnRszn+O4FqTsngAP7lydVwdxqyn0UNKU/SWK9mSvkGvh2+zbErQ4fFAdJLIeIsUaYR4XMHyv7rCQ7GNxM18wXtlejsma01TLngU7p7nwXlR3t79DTkwvp2pml7emuTSxB4Mu1xFKL1CVNeU9mWyu9Aa2hYG68SeN/0irtClIgzhA2JGXDnPrVWLqpY/f7+FuaNcV9shUxSgLLfthzfbFl7Pm0thVtl4Khqa/+wgiXw4/hcv7MvwxQksBIjML3AHKSG1S0+dpm51pVP1Lw+NWzxgBgUrvV12zWlo3y8W42XsPD4vxOunVxhEziO1j8On60M5ZLgbaDAu7/cwZ1F1mNdAnHGLugpxuoVJmqaUT78U/R/m/Ty1UQZIRTKP/C73dQaCg7WPv49/COoCbGMdNi/fsuNl/
 AR0LURRU
 pvZriM/B3UEG+Kv+YxqKpBopahUHxAoIBwWh4pogwfpEe03sWjB0AQ/8sV9JJhcKNhLnaMHVehz/ae+4R0qVEAQAYweU8a86uLVJt/zDE3GZNrHa5Xe67UZVre0rPdk7juUHWPqh6C7mrJ+o8AT3n7shZxbEwItxhIIV8wTB8ZCaxRYK6VnklNkXssIbluGU6Kez//cimSniBlp87S8d3PVUVVIeul1O5XOVyUKVO6+4lysziaBBpPujfO7Y0uJVpCAn7u0h+2ZkKjPnGmPDLbK9Tj+S4NnTndKJLUlHdhLhNlRWaATf6wzcesAp5aScUHajLu7+rf0MYVMa9eYztXZQQTjfP+NShr3+o
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/15/26 01:23, Andrew Morton wrote:
> On Sat, 14 Mar 2026 17:05:54 -0700 SeongJae Park <sj@kernel.org> wrote:
> 
>>  Because THPs are
>> removed from the deferred_list, THP shinker cannot split the underutilized THPs
>> in time.  As a result, users will show less free memory than before.
> 
> That'll do, thanks ;)
> 
> Pasted, added cc:stable.  It's been there since 6.12 so I don't see a
> need to rush this in, so I won't move this into mm-hotfixes - it'll go
> into mainline for 7.1-rc1 after which -stable should pick it up.

Makes sense. I guess using the partially-mapped is only a slight
problem, because we usually try to split partially-mapped before migrating.

So it's mostly about over-allocated THPs (mostly 0) not getting scanned
and split+reclaimed after they were migrated.

Under memory pressure without swap, that might create a user-visible
problem, especially when many such THPs are migrated before being
scanned for zeropages that can be reclaimed.

-- 
Cheers,

David

