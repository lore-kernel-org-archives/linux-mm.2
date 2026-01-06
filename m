Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9137CCE9D53
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 15:24:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB1106B0005; Tue,  6 Jan 2026 10:24:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7B066B0095; Tue,  6 Jan 2026 10:24:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C916E6B009B; Tue,  6 Jan 2026 10:24:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B743C6B0005
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 10:24:30 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5028C57C20
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 15:24:30 +0000 (UTC)
X-FDA: 84301910700.10.6FE96A9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 72E72C0009
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 15:24:28 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YB6lzGB9;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767713068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lN6KQmcR1cPbtam6FHeJxWMZpj7fs7VQ7xs9r8TR33s=;
	b=xRxcgeYxm9MweiFWvW4OwhstF8s1VxWR8SgYHQHGtUm+pfMSR09BSGNMQ2cmhMmTqSgYib
	HuisI90pTFvRi3Sy8qjBn3rT4BVNj/whNih6gMnJhD6MBDfXL4lp2yYWfQHH2UgLRwNZD7
	ROnRnhoejVBNrAPcDOv8tXMJMWz1uXM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YB6lzGB9;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767713068; a=rsa-sha256;
	cv=none;
	b=kOv60rZexzVrWSPFNJTq6XK6RS3S76m/CobzS2rRI0aF6g1J3wPYN6397n7p+ht6Up4uh2
	CXrVcn/iJgQHJ4VAZa//0qjhKlpTXUusF/Jdk55s3a2gN/K2BEQJ3jG1QLsNKcmgHEnZd3
	ELNIzpFfnRr2Jjgbn2+HvgVijaZ7MKg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 764E843476;
	Tue,  6 Jan 2026 15:24:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59507C16AAE;
	Tue,  6 Jan 2026 15:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767713067;
	bh=EfBD7bh1FnOYX4P+xNvQx4E+q8Xm0urG3QJDAxoat3I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=YB6lzGB9yPROCeUmtjE1/+hDeCZy2joy8cazV0rTfo7VRK8rjoCttdnd2AkrBwN9o
	 99Xo7Y2Ad0TsI1xQobp79/nc9HAEWI6tQKLBjJA0RU0ukF2JviGhl2FAffbPB9imvD
	 9WQ9CQ+AXfGiLAArgSmPgePODtTgLJvKgTAmLKQXH7S981Ss81y2bHISN/53w/Cq1r
	 3m2yKs65Qr9vvt3+lKhMmNxvu49b0E9oDR9mQGcd27uijgLkXh6lO2ppYdG8hqUA0E
	 KHBtHp5ZKhZN2pI5sMo5pCSxkKf+fLkZvF/AhBd92G/5d7+BNCZf3Bw4NZfLZchrQ4
	 tLTxqgUEQOo4A==
Message-ID: <7f053290-6b9a-4d18-936e-0f28006c79c3@kernel.org>
Date: Tue, 6 Jan 2026 16:24:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] memory,memory_hotplug: allow restricting memory
 blocks to zone movable
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com, osalvador@suse.de,
 gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org,
 akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, hare@suse.de
References: <20260105203611.4079743-1-gourry@gourry.net>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20260105203611.4079743-1-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Stat-Signature: 5it3dc4ozih9e77hndpo7wemo8grfa3b
X-Rspam-User: 
X-Rspamd-Queue-Id: 72E72C0009
X-HE-Tag: 1767713068-684653
X-HE-Meta: U2FsdGVkX1/DWYnovuR6Lu7m76ljZKV+68VhCZd88oDzgIqQdzeQBMd7aAESTfR0eVKiCWWykMGUU6F+LuqWE9LFpgC49xWKacII0OGbF8DFNF09nnwnxrTNBEPeypEf72qnVfmjXY1PyeU6UhyT/yAsn5HJrESVTsOkGdGZH62Ylz8tKdMt4ZmSjka44zPQEg4lKIstgHuF7SZm3lotUHG7OiEEZ74wRqYYShmrK5/7d6/DrZNlzp9VD/xz31E5qcW1sNXz6ue4XBKNNCzw03uL6gZ+GwHBo6Ioj/BHSSo34KnErm7N+qFTtINoZZI2pds6QqCG16Vszka58HUtLgLaLBkOPPM9fejgj/33D3pPXKWc263czXeq48emNPKB10/vq4jv3Y3RPwfhTYr7hRDfFh715lZC4HcHL/sUFu7PS+fDXNbl6AMjdV792cpPAndXOCPc06xfxbUQGhh0WResqzQiaLbWYkba1yi8bnc190RmjzB/JT+BSgmRGyXpEYWYBqpCHIvw56EQxQqR9OhaFU4fN2Zikc+bdkA/QNbW4/q/iZ8hwVJ2imfNTAkbZOaWh8zMdpQgMnhDb/zpkqLcS+XH00SQ6sfHe+U7JrvOpcqdnTMI7Zj/0n5y5jhgLnE6oVC27mg1177K5keCxT1O89iemRRX1Tte/6YkHcY3PFfSmiCcCdwEVJFddgnolQ4G2FYprb5vgGfUMtZ3cBtIykUQPtVKL9BFvSUuN56yc5x9zmNZoyGAQZrud/dxJ8de3j9BVIAEdFN+uZf8joDLu++C+h4SWUxjW3QkiCiQqd9fq6BX7YRaDeFzS8DeL/sT7n37FpxH6rsH/OEPQ7g1JGPxu+05kMfoGx2sCWwIMoayW2foD0Qyoba5yU5am2HBpmCSiybM6rfnSRVFL27B5B6VFmFWaVU3ZLFU4G8L/QrRv6hjODwlZt5DojuLQf/mJ2O7HyxzgH4VEx7
 P/bigrpr
 lDintuXztSmpm8Roaa/ozUh5VUZ2u/fGuC6TaPG5jKLduDw3YYsD+czNceeYFnxAW9/TXTEhkXI4uEH0BbYrYS51EVirdu3N69ZRttDThfDuhWcmYI4nrjThYxdzg8A3JvuZhqyZM4efKtgrjOnSMGY76M+Ukkz7dFQYuwsUyqGGXVdsPPQxIPjp+dt8SwS7d9tgndJHngUtPGdVRS3Kk9OESWymvgQDqfBWuS60AwbuunIQvJLlK0UgGRlls2nifLXsqG7G/rXUbJVLbA5RMfK+blvFIOwgyXul4+8OZQT+a6arLUiPG2oL/JQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> +/*
> + * Restrict hotplugged memory blocks to ZONE_MOVABLE only.
> + *
> + * During offlining of hotplugged memory which was originally onlined
> + * as ZONE_MOVABLE, userland services may detect blocks going offline
> + * and automatically re-online them into ZONE_NORMAL or lower.  When
> + * this happens it may become permanently incapable of being removed.

If it's really only that, we could also look into simply making a 
re-online without a specific mode ("online") to use the previous mode.

We could glue that to the "contig-zones" policy only, to not affect 
"auto-movable".

That is, remember the zone to which it was previously onlined, and then 
simply re-online to that one.

-- 
Cheers

David

