Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDD9CD31A29
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 09:44:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F9B66B0005; Wed, 14 Jan 2026 04:44:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A7056B0088; Wed, 14 Jan 2026 04:44:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 389026B0089; Wed, 14 Jan 2026 04:44:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 240CC6B0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 04:44:19 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CABF61A041E
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 09:44:18 +0000 (UTC)
X-FDA: 84330083796.09.D38E987
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 03D09C0004
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 09:44:16 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Lb8DXlDB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768383857; a=rsa-sha256;
	cv=none;
	b=BX0isL2JjioDBZ7bGRR76bzZG23X0EdhJcGqlGNdw4j3v9eUPPOtV7UQa4msmPhIgXLJbQ
	Q+42//ZHZGSv5HwN4Dd5IQsEtfnJSJEftsnGCbsjXQSaxAcP/KU1DPUa5g12GOSttysUaF
	Jdv9sDXccLus6kzXj3P26gJa5CiVn1g=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Lb8DXlDB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768383857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Os+QQW4BwjqbACf1EPFVo2XU1wHQTJCI5jKKOW7APJo=;
	b=dpZnNoSc6C2bgrAW7g5H6pEoKZILC2N7ZM5pPqXK/Py4UCGCFg1D3zrCLOC/+FLgNq3E9k
	9LEThYFaw6e+lKIYddqUpGjB9aUgA+xwobipyXM8NMiXQokvR+a3X5jiEnvLPTJcEgvKGj
	KFHyMEHmcwLwsLbzT7ruowV/dIrEWvQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BAD2140551;
	Wed, 14 Jan 2026 09:44:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEF00C4CEF7;
	Wed, 14 Jan 2026 09:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768383855;
	bh=iFG9jtDkQciBd3kw8laIsCgUzSrLhIKKl8rol2z2xpc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Lb8DXlDBnFqO+NW+Rh1u7EkBWHwkcRnCeq9olTQtKhAQ4m1b7rQKQulcGGmLgmiPg
	 ANOxubQa8Qj1Lx4Uiq3ffkh9H+SgEQfPayen0wffEOzIOaFwOOPklamyu5uf9OZp2C
	 mFsWPAryCARv4exsUjU8yE835fhhhvWyKBDOY1QGLxZvbTOUQM8ANwAroIonltUXJY
	 FR1odw7cvxgh6UZZLFbiKglS4F778naUMuAQEPlENj8KARHm2sTb2cDh3QtKtrm22x
	 Wo5WKPX5XSgVvnyLY9eHw1iI5yjfhv9A0JhupiXtYl1H6cqt+nhL0OXG1f7lScO91A
	 oNlrXauO3pPsQ==
Message-ID: <d1938a63-839b-44a5-a68f-34ad290fef21@kernel.org>
Date: Wed, 14 Jan 2026 10:44:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 8/8] dax/kmem: add memory notifier to block external state
 changes
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
 kernel-team@meta.com, dan.j.williams@intel.com, vishal.l.verma@intel.com,
 dave.jiang@intel.com, mst@redhat.com, jasowang@redhat.com,
 xuanzhuo@linux.alibaba.com, eperezma@redhat.com, osalvador@suse.de,
 akpm@linux-foundation.org, Hannes Reinecke <hare@suse.de>
References: <20260114085201.3222597-1-gourry@gourry.net>
 <20260114085201.3222597-9-gourry@gourry.net>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20260114085201.3222597-9-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 03D09C0004
X-Rspamd-Server: rspam06
X-Stat-Signature: siyp8xew6gzwtrzncyzrwi961uoc9z1b
X-Rspam-User: 
X-HE-Tag: 1768383856-60197
X-HE-Meta: U2FsdGVkX194S0qNOSNtdhPeKwCCpThgPldXx2bswK/e5n3AgBNXiZXVybyMbTlO0qgLwYO6uYbdySYDd0ABZu3zliIuiTUb8on0QreAt4ICLgkIfmO0DDNekggIOHZxQMcspLiRGuBCRvnwrllup+paG1ei6gmKy90Lh09HPWvPfHp0he8jESMeUo/ltDkleR4rWjcXTWToU4QaqGvOlEmF3qHUhzZz03mlneJGoka8pdonJbONTp0qrPtoIKKOj6YKqcb+CIwlj+kunKhYIxHC2SFBDpqIGxn9Z/tc4W+l9XDJskGwvwHJquTXW+ptI2xHUBFOngJ0b2NrpFNL+/bZjz9bbIXIbAFu5P2dERNWDwY4uV8aH5Xn7vwoxezAUEGRX+cn98CsxM/YyYu5YHr7NylhB+p6+TmzKM24eY/2xJCyp10adY7ody7zngdqBeWnqBUzQkkGLhz7Z5jD4hmpDYK5JPkmciQ22v5gPBeeY3pAn56ojG091ZsFivxc+6QssYAcVsPCsEfeIykmAfUDyzyxX2xQXc+Gysm9WtFvFR4h5iQJxMPuAiF1hFntaYlVLxl7fisqWRGxv1VUz7jrrcdTQ6xmXfKMN9Nj7T34IM/TbiCDvF9uQ9WmOnouVgaN90k8qolGPQG9qwXRudsWvXNZ9WAEFOFklchBnpK2N4JIP7UZhiGcd2TmVXdsTybrwEEBrAragqcHOhljbAkPbQHuNbLer3dHvF6lpzyDmT/Rk21xXT2bVu/6VrshBPO1LQznjX1BbUWdnLvLSnRt8dhJr7Ez2Wgl7ggCUuHe5x4Haybz8YT7eIC4TOYAr7Lq57V3OONsyqbQ1jwNrOF3QeFwJRUckfn77iQdXs2MELAFGOVM50jyZvpu8F7ijsE/xL4W0G2zioSl1suvzxBzejS1EoheF0ePe6/ieD7wd/niMtxGKE0E474Q7TB5Xlc8Y6XFBsE/TN90ZnM
 5D3E4p1U
 yt+3qr+tRGHHpCqppLeUzYOSCyxS1sZxpiuU4wz4QLdxOjriOmo4lhrT+N7EHLq314/sKPgFZVsPg01b/xbRf0y2GA+tuKlW9aoTU12aJCBYMgA+Valkutq2psEl8W3JAfvXmAB47CCr8oQgC45A4ddiWT2p7kEwQo+tp+RrJdqfmYS9gaf/G7b+aCw+M5NmkCqdTiKpssMFU5fwlBVTftsU420QyY8J/ssL+gGzM21C0dxMQBfmVA7GpnQ9EV6VFoulH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/14/26 09:52, Gregory Price wrote:
> Add a memory notifier to prevent external operations from changing the
> online/offline state of memory blocks managed by dax_kmem. This ensures
> state changes only occur through the driver's hotplug sysfs interface,
> providing consistent state tracking and preventing races with auto-online
> policies or direct memory block sysfs manipulation.
> 
> The notifier uses a transition protocol with memory barriers:
>    - Before initiating a state change, set target_state then in_transition
>    - Use a barrier to ensure target_state is visible before in_transition
>    - The notifier checks in_transition, then uses barrier before reading
>      target_state to ensure proper ordering on weakly-ordered architectures
> 
> The notifier callback:
>    - Returns NOTIFY_DONE for non-overlapping memory (not our concern)
>    - Returns NOTIFY_BAD if in_transition is false (block external ops)
>    - Validates the memory event matches target_state (MEM_GOING_ONLINE
>      for online operations, MEM_GOING_OFFLINE for offline/unplug)
>    - Returns NOTIFY_OK only for driver-initiated operations with matching
>      target_state
> 
> This prevents scenarios where:
>    - Auto-online policies re-online memory the driver is trying to offline

Is this still a problem when using offline_and_remove_memory() ?

>    - Users manually change memory state via /sys/devices/system/memory/

I don't see why we would want to care about that :)

>    - Other kernel subsystems interfere with driver-managed memory state
What do you have in mind?

Not sure if this functionality here is really needed when the driver 
does add+online and offline+remove in a single operation. So please 
elaborate :)

-- 
Cheers

David

