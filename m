Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D4A9E674BD
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 14:58:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F41316B0005; Mon, 22 Dec 2025 09:58:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0C286B008A; Mon, 22 Dec 2025 09:58:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E34DE6B008C; Mon, 22 Dec 2025 09:58:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D2CDE6B0005
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 09:58:56 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 811781A01FE
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 14:58:56 +0000 (UTC)
X-FDA: 84247414272.30.E5292DF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id C474B1C000B
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 14:58:54 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Sf8cvv97;
	spf=pass (imf21.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766415534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RI6wkzq9art1PUr+oZHEIShCAnFL/nfJWig5oY9a9H4=;
	b=GkGvuU34rlLwyvVIZnTGSF8lN7dTqokCCSAJygjB6zRHOiLrrC/SSk94mG047XVkka8oqT
	GTA4bn+MeXrK8xb/9QMXBvBH8+HKy8Ikjk5AcDjMU7tmJmAAfrLjRLmoTPq42B8cMjtJjW
	Mx2rponQu+8YEYdi05t35v3yNtztpHw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Sf8cvv97;
	spf=pass (imf21.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766415535; a=rsa-sha256;
	cv=none;
	b=TFRQ0fVYAo+t94G67sVUsSeF2MEN+RApiaCZXsj+8Q1RfdQdVrW7azmU3B3CyUYunNI14i
	weXAVY0c1FyUtTUqib2tydVvaMf3t1PDmUn6CelxiWVGuGShR0Zpd7w7rVR0SgptLMDZZ5
	l53Nz8yJX6SGRbmtYQbQFjBN0dRdVgE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E756740684;
	Mon, 22 Dec 2025 14:58:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95BA5C4CEF1;
	Mon, 22 Dec 2025 14:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766415533;
	bh=b4wwckHCSEHA9/WsH/82v8iyuGooOfYc2si289h0qdk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=Sf8cvv973Ocy86SIfrhCawHgAShUAwMSVQXJmWzuodPbT41k1EQD8ytVx625GsbjA
	 SW8CeuEhVcF9igA8P6YYwwKKILnQ4wtjZ9NJUZC8GVOJy1YFzowIKCHG9Wpke6Cd3p
	 4hlh6ZLKMflh9K4G4Fn2woo7rNi6d3jEcqdrNbRMhKV4lClYGgNb/eEA1oF9C9q53H
	 PjiLu8ZRc9IoV32IPqFBobyygCnl0aDln4g75qhv3K1GZNkghCwfXPs4qohTcHGSXW
	 Mqh2ghyKhw/orybk4h09OSXMzd0E0OMiPtbla5X7ljWCIHF1WJ1K2PrewNZlPqPMoN
	 ptWtwVifEgDeQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Mike Rapoport <rppt@kernel.org>,
  Andrew Morton <akpm@linux-foundation.org>,  David Hildenbrand
 <david@kernel.org>,  Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,  "Liam
 R. Howlett" <Liam.Howlett@oracle.com>,  Vlastimil Babka <vbabka@suse.cz>,
  Suren Baghdasaryan <surenb@google.com>,  Michal Hocko <mhocko@suse.com>,
  Jonathan Corbet <corbet@lwn.net>,  Thomas Gleixner <tglx@linutronix.de>,
  Ingo Molnar <mingo@redhat.com>,  Borislav Petkov <bp@alien8.de>,  Dave
 Hansen <dave.hansen@linux.intel.com>,  x86@kernel.org,  "H. Peter Anvin"
 <hpa@zytor.com>,  Muchun Song <muchun.song@linux.dev>,  Oscar Salvador
 <osalvador@suse.de>,  Alexander Graf <graf@amazon.com>,  David Matlack
 <dmatlack@google.com>,  David Rientjes <rientjes@google.com>,  Jason
 Gunthorpe <jgg@nvidia.com>,  Samiullah Khawaja <skhawaja@google.com>,
  Vipin Sharma <vipinsh@google.com>,  Zhu Yanjun <yanjun.zhu@linux.dev>,
  linux-kernel@vger.kernel.org,  linux-mm@kvack.org,
  linux-doc@vger.kernel.org,  kexec@lists.infradead.org
Subject: Re: [RFC PATCH 04/10] liveupdate: flb: allow getting FLB data in
 early boot
In-Reply-To: <CA+CK2bDWF6pbNQRkJFa+WcD1pwUOr3yQdrRUs-mgLWu5ght+7A@mail.gmail.com>
	(Pasha Tatashin's message of "Sat, 20 Dec 2025 10:11:34 -0500")
References: <20251206230222.853493-1-pratyush@kernel.org>
	<20251206230222.853493-5-pratyush@kernel.org>
	<CA+CK2bAV1y_LySjyj-wcn1cdSuVBdC+r+zQL7AQTY64nk3OxuQ@mail.gmail.com>
	<86wm2hj0ky.fsf@kernel.org>
	<CA+CK2bDWF6pbNQRkJFa+WcD1pwUOr3yQdrRUs-mgLWu5ght+7A@mail.gmail.com>
Date: Mon, 22 Dec 2025 23:58:43 +0900
Message-ID: <86o6nqd0m4.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: x477co7zyjo98qrzh8k8f57sn5u8gi9t
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C474B1C000B
X-HE-Tag: 1766415534-542529
X-HE-Meta: U2FsdGVkX1/QofVMjBkGlS3yocsxOvRJBBnpxetUa3Hu8bCabLhdH5kn0loEj1CkkpLIkRkdhZ0IeBClflGmNjcDZmRPS+uHNuPi8yrojFDnCCLN6HrcgCqK99j0DgAnshXr0y+BxV0FKkypEQZ+PnT6/dpP9GWRumxx4YPPTvZKdlZXYneFIHgMFPAUU/5J7zPhocb5fKkouktKNeT5wTwm2Z21Ojupd04vWNFsVCww/HOmwkCzfZKF7EaWnHUZCSAlGEU1B3qwpeJ2eDS2cCJmI/BQdogQiQ2odjO7eGFSoIKHITH2QaQPlEnkppQEWUqSkWx2U8M+c9MkGLnN7h6VLbacrj8WQvy8Rcs6pdm68dlt4gtZB8byzFsT+herj7plFiZd5o+bjjeqSR/7Hh+bcAg2cFf7i6LfcfLn/2O9tjFbaSJ2effcFL7yhAtdy3i5zAOOY2fyERzLG3MQkDd88mKZLRciCt9OxXpsNPi8Um3T6pSdEMIAjZoxMGeK5sQjdB+AHg7FaXayxAVM+NW/b3vJ6/ljL1MqnfLlVOxWhKD1Ct7Ky1LG8Pl1ExMH3TNFLThrATPIgpWanlImRXUfKKo9D/SOUi8euzGotiGM6rAEcwcPSojf54pKB2k0cPyjFFxN2sJV2+v2WcsLeubqqbiFtHRkmr5bqeYKkgzuLJiNj7Iq/w6gVyGlfAWdA//PGgM0c+KGGjjQdCGOfwyOv8qCqRVH+dQvHMe7KKmDlEEKSs2g0aviW6JeMNU0qOtCUldRGv7ur7GRC4+ff3uyS+9QwZQIeVL/WcZvDvMoEqafI7/ov5bk8lLR5QcFRrktttj9KhiIxI7+EQlNBdEzOIwz7jwPU3gHO/BxhGRGfMttiGkrLXmxg+SCunLp3OyWV5LWFRGTMoVVtznd7nYYcKVJhIykv91/hGDuW+3zZqTKo2Asroo+0LajvHq5ks+oteqJn/AOIGLxHhG
 xoilRAoW
 VCFP3DAq9zv1MdLbb0d3MSsKe7FBnKKpn3b/htWT+jigr1Gfp/odKbtck06uClr/D2v23p58YlsBfue1iN/ODJxG0+Mq+n9TYET1ejeT77jzTKg90Mi340OnY0DjXe14eMHj1uVzrhy+2qLUK39JObiGaNWdbUF8hWPLm5LUAyPqjn5E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Dec 20 2025, Pasha Tatashin wrote:

>> > [Follow-up from LPC discussion]
>> >
>> > This patch is not needed, you can use liveupdate_flb_get_incoming()
>> > directly in early boot. The main concern is that we take mutex in that
>> > function, but that I think is safe. The might_sleep() has the proper
>> > handling to be called early in boot, it has "system_state ==
>> > SYSTEM_BOOTING" check to silence warning during boot.
>>
>> Right. I will give it a try. For hugetlb, this works fine since it
>> doesn't really need to do much in FLB retrieve anyway, it just needs to
>> parse some data structures.
>>
>> If other subsystems end up needing a two-part retrieve, one in early
>> boot and one later, then I think it would be a good idea to model that
>> properly instead of leaving it up to the subsystem to manage it.
>>
>> Anyway, that isn't a real problem today so let's look at it when it does
>> show up.
>
> FLB has exactly one .retrieve() lifecycle event. Once called, the data
> is considered fully available and cached in private->incoming.obj.
>
> If a subsystem has a requirement where it needs a specific state
> available very early and other state available much later, the clean
> solution is simply to register two separate FLBs.

Hmm, that can work too. Anyway, let's figure that out when there is a
real use case. For now, the current FLB design works fine.

-- 
Regards,
Pratyush Yadav

