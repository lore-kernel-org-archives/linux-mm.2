Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B38FCFF8875
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 10:05:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEAC86B008A; Wed, 29 Apr 2026 06:05:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E74AC6B008C; Wed, 29 Apr 2026 06:05:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D15956B0092; Wed, 29 Apr 2026 06:05:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BCDC86B008A
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 06:05:06 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0BC1840F08
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 09:38:56 +0000 (UTC)
X-FDA: 84711094272.07.E33E42C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 20A6B14000D
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 09:38:53 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gKiYX7b6;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777455534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VXk8ParAr7oBevUoyhDBW5r7N8Wp14Qz22GGZlUX5HE=;
	b=qoz2bBLCiTlCm27TqIWbWiR2bEKl80jRJe+OuqJ4FkO1WHiN5+3nZbaUEo13T6oVc5VnWu
	ksRDrZijk3cMXoM0RwP7PFDTpjVko9Y1Mir14sGAhSTT6DJ2Zoxc0GfDymF6U3RM9X0Bck
	/rJ0oqHTQhsjtQn7JngWvKL2IHRbQZo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777455534; a=rsa-sha256;
	cv=none;
	b=VF3eYuyDfh3rm6G11Jq47sQsSWHp5ZsKLPKyM/XayD4qTM8xUghPfht8ccExhcHu3MXGlr
	x5GQYns9z6svk1RePz6RrHezlx1FuKLhYXcypqeKuLJTULeLt3ghtxi+dWCwW/36eaujHt
	CPrYw1SOj9PuUBNT2PDlZ+J1ujdQsYU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gKiYX7b6;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B6C0841E61;
	Wed, 29 Apr 2026 09:38:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1183CC19425;
	Wed, 29 Apr 2026 09:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777455532;
	bh=UYLe+Qx25A8v7VB+wy7G+C+L2zGH6z6ujt+Hu+Js9H8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=gKiYX7b6+RorGZIiBdCqYmEa7Zz6HOBaHL5zOGCrGVQmwT+RLdEhDb8NVSyXluOcv
	 NO8JQ//p6OigMgATtXwl3SMPKssufasLmmA50SiBgT3m2YUtaCsPjdhKijmBPkOKYC
	 IMj8Vbgttha9sAlKcY0F9fgiklqvtX0pDTNMG8lrBEX5yqRgSEXvqIdIiBFGckBdIU
	 wWt9W6vtPkaBuz/Ewq/HZdY0+U17u4yfjfR6pUpmgf0N9M9ioWzW/yM2cieyKmUqEk
	 3Ms/Shg5vta/wND5c1sJvW1HbaOU5fS9X4qjMnhJUSCMmBS2nXMTpa4aO3A9epygBY
	 BYOX6DiKiMh9A==
Message-ID: <0a16c8dc-3155-4886-8aa1-2d7dd3e3e13a@kernel.org>
Date: Wed, 29 Apr 2026 11:38:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] mm/memory_hotplug: fix memory block reference leak
 on remove
To: Muchun Song <songmuchun@bytedance.com>, Oscar Salvador
 <osalvador@suse.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J . Wysocki" <rafael@kernel.org>, Danilo Krummrich
 <dakr@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Vishal Verma <vishal.l.verma@intel.com>,
 Ying Huang <huang.ying.caritas@gmail.com>, Dan Williams <djbw@kernel.org>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, linux-mm@kvack.org, linux-cxl@vger.kernel.org,
 driver-core@lists.linux.dev, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, muchun.song@linux.dev
References: <20260428085219.1316047-1-songmuchun@bytedance.com>
 <20260428085219.1316047-2-songmuchun@bytedance.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260428085219.1316047-2-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 20A6B14000D
X-Rspam-User: 
X-Stat-Signature: ricifsemhxeysqhayrwd5bwt6zcy4pt5
X-HE-Tag: 1777455533-457367
X-HE-Meta: U2FsdGVkX19E/2Iz9Pov4ISTFlF5qsadjvZANQ4WjZwy73cyTloAdNSGXJX22wcURXppxJJJ2+8TEBuJjNacycp7w1Tu5GMnpQClgaWISAojMZY/kY3uWIORYrTDxh9NKox92ayiaj3aq0Jrxt46laDGBK+cAxl9rJ5UINjECBpEB4+XPkdWeXL6kTbj8rYOJKAnjJe3QJxeQpyyg73I0k/MPMx48hqQH98VXO658vgRhOsjVEUqo1HWoua1IZeOOQmGh9Dg+3nyX9NEHXQSd9EaJROAowS07zoTLJAy0LgsRot7myGsSdDc04OUQkq0AmcGVubeMqFapvxBLFf1Ho82icyCbk53EjdsS6mQHtkYon/tja5qDiExAWAOhvW/cw0BLlAOySK7WDNQN74EuO/Y4eUDdrA1Lfpbpc+Rl+1keUHi5ZQnkFhiecvpftzORjILzmtJOED3Cs1KpZC5hzwJK5hBuD2LlX9u9Usf/qKJfAUsdjxjWq+G7ojQV3H3fH+/YSmqtS4p1+jNHOtWrD6Cb0mV1MYACj6WqVGHF5JPz/R5C1LvJBgnkpYEnpglThwQ0rc58EIZncwQpiSAbCSYXgnyh+ps3vZKDlOkGdJwVOHkOczXwvDkH70LnXRzoc49t6H6A7V7C44Taa+hw1fHqs5IJaZubw9bGE1DpnUMEhFUz20ARK1ZnpMBqvhL5SWjU0lULKk6YL+l2iP5edx+VZUv4TZbhuFUXBo25m740sxCOT9fGxE/NKgc0cJNlK8bpUedIoQlFaohGO93uDSeriN8H/mENrKUSJoPjmOF1hdpeNpq203HUL88m4RkYL0oUECqvZe5OG+wvED+eKwzT5UjRqf6fnYXVLuJyBT2FG75WDUTFu8ee3Vm8A2D0HeBMuKmeJG94n8c+n1QOOM+bnBqJzD+ico5vPX3kRh6o4GAwMoCDtRxpWHZ0X1oW26LoEPyy+UZClj6r9T
 kRVRHK7Q
 p/ovItphrV5ZSsXAOyy8IfWTMWMDGfoOv+RToSvP1m3HRMwG6zwUEVvzvI84Pr0URpOdnkudEnpZbrDRtxF0kSxOCf29luc6EvEvmtBrBReru9eMVOXs2Jef7LqIFfr5r/yK0AIdAHU/BPREVjDSJbHZNYHi5b5bBb20KxckYdS8xo3TQ+Qz0zME5QDK2NIxu5FJeyZCkclveEJOuSFTn8HLeqACieTiHgQZNDv5yKiYOxrDBbb9wGQctaujwFofNb8Tp+ggNlzhPEldVdF7KqNSj5DhFZVR+VYUDIWrmoUqW6+dx46CVp70CO9W3GHXT3mucDtzCuF/aqhaNcESW+k3Qqy2pRCQbbLVzBlFkS0V6uAd16lTV22dUsWTUYVvQDFCE1Iz8vkkPSni9xYRvpF6wX9lFSET1U9dY1sjjjRXtwMQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/28/26 10:52, Muchun Song wrote:
> remove_memory_blocks_and_altmaps() looks up each memory block with
> find_memory_block(), which acquires a reference to the memory block
> device.
> 
> That reference is never dropped on this path, resulting in a leaked
> device reference when removing memory blocks and their altmaps. Drop
> the reference after retrieving mem->altmap and clearing mem->altmap,
> before removing the memory block device.
> 
> Fixes: 6b8f0798b85a ("mm/memory_hotplug: split memmap_on_memory requests across memblocks")
> Cc: stable@vger.kernel.org
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Acked-by: Oscar Salvador <osalvador@suse.de>

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

