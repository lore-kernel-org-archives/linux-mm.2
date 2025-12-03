Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5138D1266D
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 09:09:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D65F36B0062; Wed,  3 Dec 2025 04:09:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3D826B007B; Wed,  3 Dec 2025 04:09:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7A5F6B008C; Wed,  3 Dec 2025 04:09:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B75F66B0062
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 04:09:04 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7723CBA376
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 09:09:04 +0000 (UTC)
X-FDA: 84177585408.25.F202843
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id D125520012
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 09:09:02 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mz1okwY4;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764752942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g0Wz6vo/OWMFDPj5WqxbSMUMize9aPvl1lvtkJQdD0I=;
	b=krqxCQp3VTiNCaQA61MX5W1UfqJE71FhtNdJ886Mg0lLfyWsfAck5K5nf4U71OopUS0FJ+
	XDy0DARzU6jJHPcqPz2BpZZnJSwcfFgQT2TnciJPO0E1edM7fqPU/lOYPL6TPF48/li61K
	cxWU1M7qe3b2+pGXeBXAT8GeZg+rxmk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764752942; a=rsa-sha256;
	cv=none;
	b=ReRc6GObJSfULl8e5OH26K7Rd/bdzZXXjReYpDh4nQQHh0jZ/Ha1gHAC9vGgcxcABXhSar
	a8XiP1qBzeF+YjkxyF/fobyjO/UDeTr9VCPel+0rY5dUpFtsnE5gApEsiI7GXm487JtFa/
	zAXIKu5bDOQEhc+O83Fj9Z/HdLkMjjU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mz1okwY4;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5F3A160172;
	Wed,  3 Dec 2025 09:09:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A5E5C4CEFB;
	Wed,  3 Dec 2025 09:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764752942;
	bh=DGboUdc02G+DpViZWqGDqlr+OdnJvgeqDqzt2njLLJw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=mz1okwY43bzv4DlTzIIKufOUolxcKo3ZlDf9oXnl1kBfxRtkyXPKPPB8dmRVvkLpf
	 +Lm59YXef5cp3XRt5HQ4vjYd89/HqujIOYEW49KRIpAthAMQTFAKjHsvBWun107H2N
	 CqrYLOn74KV2z6hkqT6S2Lz0mYXwnhWjCSKjDla0/V0TNhSQYzXvpGzRBDekyeKYfx
	 3FMgFXtSK92YfW6brdHJGMPsffQr/elM8Zjk3iN6MqNDrp2QlZylNNUyC51eVKIlk1
	 E2USKfQeaNffNCSlkMIl7LWnFQEZCqMXbICtx5pDR51CwlAkTIIK6fD8Wp9DF/zVCy
	 TtKn60RSOuYmQ==
Message-ID: <9de2f7e2-a202-499d-8858-6936beb251d9@kernel.org>
Date: Wed, 3 Dec 2025 10:08:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_alloc: make percpu_pagelist_high_fraction reads
 lock-free
To: Gregory Price <gourry@gourry.net>
Cc: Michal Hocko <mhocko@suse.com>, Andrew Morton
 <akpm@linux-foundation.org>, Aboorva Devarajan <aboorvad@linux.ibm.com>,
 vbabka@suse.cz, surenb@google.com, jackmanb@google.com, hannes@cmpxchg.org,
 ziy@nvidia.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Oscar Salvador <OSalvador@suse.com>, Juan Yescas <jyescas@google.com>
References: <20251201060009.1420792-1-aboorvad@linux.ibm.com>
 <20251201094112.07eb1e588b6da2ee70c4641d@linux-foundation.org>
 <aS_0bgCs2qE0y1bJ@tiehlicka> <aS_2Z6ROtrxLQcRN@gourry-fedora-PF4VCD3F>
 <aS_4E2H5aJmSvWF7@tiehlicka>
 <47a8b4d5-f4d2-4772-b1b2-ee96bc21e742@kernel.org>
 <aS_8ndgdVbffPYGN@gourry-fedora-PF4VCD3F>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <aS_8ndgdVbffPYGN@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: D125520012
X-Stat-Signature: u568bbfktn8xewuyfssfejxokpoufitj
X-HE-Tag: 1764752942-757314
X-HE-Meta: U2FsdGVkX1/Gr11eF60iGFGY7L8QSfH7g8FKtPW3Rc+d2mvQu7gNiuyK3lfMLv0JFbTMIoSQO9s2o6Ui8FEQLdsT1L07TIm1E8tjZ0nx+P8uFRUXAPVEKEIMLrCZkFnWnpHGtdysnno7XXWDVEMP4gDTVLQyn2j6EsklPLfMwY3kr5i6z86blvhLFoR2kpwYG52297A+tzLlXs0RjNi2FrPsJ95Te/mqsKPlUiP/UtUxL8iGFaczmn7ZvuoCCxszBMxLFRspE9Q77kApjJUfUYOlZ/giIrgdahfqmmVq34O4Fy3+Ym00oU+44iCy8kmIwxyPYR/0+0IDvl0BnR2H+Jtgb5FY6U0iK1pVHahHHB6+UlzVPBRmw6jV92edWj+pQKWSFwmDxjn9xdvGq3XvbbL4eDz4bWnvDKfqsptIcEnQ5y2dkQCvbU67P50gEYQq7FuLraKdg8lMNhJ4tYDyPArQGM9NXZVHDjkWTKNDYhH0XJudT/L6jLrOxRuyfa2k4F0DSuBs+4GHt6a+/p03XbHzgO5KI66t3GTS6pyuMkI9l61o8SBhbMq2f8nLs+D2l/SZ1Ph/1kZSJ6udTbrV/kfLpqNzR9IlMbx227bHj0NK47JvPKH9WRriXpTtCTTW35/XuDPn++BcztJp+MGMcrZF3/o/qOz7xw7MGEzKbJtqg4mTlD4oi3XSz68FqYB5u802iGS/bKLPen4rbmVJyEan2+7wvt7qrSClKJ9t2TzbBgKhxsZMWfa+5n8A+Umdi/FZW2hqkpQI4AvWfL7BOX/MWkjUOPRF3VFVazLxgxivsoWgCIoXmVyx3eagwfGBlV2qE/bd1wSLY/TGKXcB5vnnhD2T9cBzIESf2v/N3t1xMbQhHutLY1tPxTI7huh4JyPEaqgjyRiZwfgqMI+eoz/HgpEkkjwNZEz5oarV1yRZlHmqKb1OAwUj9WQOFVuvLqAlENRNHyL8aUC1/jN
 OpIoUxOJ
 2iJJ46xL0E/5eRDQ5sjxew+QDr97rFN3Zu/6FGocwcrQVmK/EF1o7zaOWZVq01LHFxw8eo0Y0bcgqYxVqGejNzskeRpDHAAfx8vOVIr3PCPqZUcJSKm0o2IoRnnQT3qF8LI+WOYwjBFryRQcBdRGweJV6Do45+n+Uh9gpEH9Bw3mhCTlath9nsWPtDrBYXl10Z+ufZMvHJfc7cGTFXNG0sEyOwGiV/UlQuVaWUTxketXcuJLtixTMlurK4NEtuSkP/moEFBrkTvvyXqtjkgdkMZH4csl3Wp3F5GS4nN2gxTJW6J0XaW038m1N9NaH114OB2jocpSrxXaGFFNzVxL6MJ4DVh45uzGEJvNvaMoE6nGAaUWKQhb55gSLZ8kVO503eOtZJUswo28h2TU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/3/25 10:02, Gregory Price wrote:
> On Wed, Dec 03, 2025 at 09:51:52AM +0100, David Hildenbrand (Red Hat) wrote:
>> On 12/3/25 09:42, Michal Hocko wrote:
>>>> 		if (!ret) {
>>>> 			/*
>>>> 			 * TODO: fatal migration failures should bail
>>>> 			 * out
>>>> 			 */
>>>> 			do_migrate_range(pfn, end_pfn);
>>>> 		}
>>>> ...
>>>>
>>>> Maybe it's time to implement the bail out?
>>>
>>> That would be great but can we tell transient from permanent migration
>>> failures? Maybe long term pins could be treated as permanent failure.
>>
>> Did we try offline a ZONE_MOVABLE block or a ZONE_NORMAL block? In case of
>> ZONE_MOABLE, bailing out is not really the right thing to do.
>>
> 
> My transient failure (although i'm not sure it was actually transient, i
> killed it and retried after a few minutes and it succeeded immediately)
> was on a ZONE_MOVABLE block.

Okay, so that one should not bail out. Longterm pinnins must never end 
up on such memory, and if it happens, we have to identify why and fix it.

We have this known problem of "stream of short-term pinnings" that can 
temporarily turn memory effectively unmovable. Juan will talk about that 
at LPC [1].

We have another set of problematic cases (vmsplice(), fuse) but I would 
assume that these are not the cases you are hitting.

So not sure what exact problem you were hitting.

[1] https://lpc.events/event/19/contributions/2144/

> 
> Kind of suggested to me there was some bad condition the resolved once I
> took a second to release the lock and try again.

Hard to tell I'm afraid. Do you still have the dump_folio() calls we 
print when migration fails?

-- 
Cheers

David

