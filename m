Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA2E6F34C5C
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 15:23:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38F1F6B008A; Mon, 13 Apr 2026 11:23:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33FD36B0092; Mon, 13 Apr 2026 11:23:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22E726B0093; Mon, 13 Apr 2026 11:23:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 149B96B008A
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 11:23:23 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7B10BE0254
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 15:23:22 +0000 (UTC)
X-FDA: 84653901444.29.4B41DD0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 789164000E
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 15:23:20 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BYE59FG1;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776093800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U25vXKCXO+P8CY7sL91HkCf92SFOKw78XaaPa5Ow0yM=;
	b=ICQq2Xf37A8JY8whpoKq7xFbNjQWYc90TQ/Nk2vwpVB1j7oq0Xk1+GVVA7r88UqnXMI1TV
	SpZqedVNuCq/wvQSFvIyZ66zUoUw/n5DQoRxhn+Y7Wl6BjwGocQNcM3PbQwcqB0b4a+e5M
	NU1+cX06bZKZNV3oAfowsjFwipPi/7k=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BYE59FG1;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776093800; a=rsa-sha256;
	cv=none;
	b=LFf5r8alHzOMkJHmF4TiaYpXNX4sC6NfjTb9h+JIBUR/FXPuI1TRQCfC+2e6Kpj7oTYDwB
	eq4hwBKCapWRN3NSmLjVE3rFk1w1CADQCwQrqzm/wsFKv9yXrjPY+bneKiHOLwxjmrKXBX
	ofNt6HdsD2qhhGP3+U3k2stdzi0GvBQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 86F5E442D3;
	Mon, 13 Apr 2026 15:23:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28BDEC2BCB0;
	Mon, 13 Apr 2026 15:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776093799;
	bh=S45XMgptda56IsZAs7DVd5a3LNMAqRWpvRwu+DHIPGQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=BYE59FG1YQ0pT8LVUF+tv5zY7dYAb5xA9h6J7NT7HBj1dnAg7HpvrDCSEqlonD57R
	 8HpbASIbg3q2rlDrHvQFz4aruyuJhmFLSxnSEFDPXQ0Vqbu8Q54XmzXM4D75mnM0JZ
	 zOwruWwCr4X7vE07w18nFeU25jDCX/DuSX2K+fg0Pi6bBenTPwbEPpLhrbHaL0OZ1t
	 pYUoSRvSbdhax38dFAUgo4xR+x2eGlzUFsw0qE5DkqmJhu3MoMoAODwwQ+8wXPbsl9
	 +V+Q0rzeYQnoRWRQKcKIfBJd+9XzRZ9seOmCt2SmRaAzZfTCNPl5iZosMNoZ8dmXrB
	 OBn7uKUVLvJXQ==
Message-ID: <3a4166db-fd04-4a9a-a25a-a7b6d149b97f@kernel.org>
Date: Mon, 13 Apr 2026 17:23:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/8] dax: plumb hotplug online_type through dax
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org,
 vishal.l.verma@intel.com, dave.jiang@intel.com, akpm@linux-foundation.org,
 osalvador@suse.de
Cc: dan.j.williams@intel.com, ljs@kernel.org, Liam.Howlett@oracle.com,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org, kernel-team@meta.com
References: <20260321150404.3288786-1-gourry@gourry.net>
 <20260321150404.3288786-7-gourry@gourry.net>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260321150404.3288786-7-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 789164000E
X-Stat-Signature: mt9ardjw3f6iw6wfna18fhu9p3jxebib
X-Rspamd-Server: rspam06
X-HE-Tag: 1776093800-460996
X-HE-Meta: U2FsdGVkX18iaEwPrzsvK/j/9VfClr7TWceYhAQEpwgFS64OUxChyNKLX0JHaXB04DfgZvW0QbRv7WAy3b0l8HItHz4l4euWUSWXzzQxakkHeVXNZ+zcqHcWkqZVmc3aJIV/6H8sFZsuHVaXKqc0JI7MObxiWymFellNAK7LeAMuf3GGp7POUyKsKPIDuFK+67c0gW2TJS1izkjDmASBX8BquCG3YHyJ98+YB94WOtD+cTwZTf7TYKVlSdlZec0PpUtFlYgL6Ic8rVVKA7aItMJdzHrDcEfVIMiw0BFSx6rHmOOSDS2+r3jU4ITxiJ+WZj3V1L8vGZlrerknzg/dPVsTOuZnctfjIQNCTD8DaAVRas32HvzaonbRGPJBMChwe2m5729fQPxY9S78mEgeSiAEHfDlL0PnGqjfkcdMDJPziD4PvwDA8jz9DKzTt7VH6Tgdj5KnATav5EDN32w1lth2rut/gPP6p6J3GhJouPOxUBCTCxLDPfVSM4ZWMDh6qvanpE9lu5ImBc7dAbEYnpCUeiVnmkZuvIVbLnarTX7/XTrDN+mO5PBmM9LtbX1yNReqrfo+hpOH2PbQYCSn9x24xUisA23g8aTjbN7a6Nm8sFlBbELoGWFzw7VzwMYSB6iYRCDb/3nYk2jf9pe1w/ZHfJPO/MrGvB83qlY9kUQYmpRmBaVGTZltfEFv1A2Hx3Km7fHscf2Ln2XF5loqSHmMacJtf2B4iFMDjaVA64MbPrJZft28C80nZyaiODxw9tNuvWB4zh1RXGTsqEByDnf6a284KgQWG0qC98CuozoBLw4CCAQld1NgcGl3htjSfmBF7WW1sOjKbqi6+6tSZ8+xyJmMl3+RhjijL/fnj9bwg29ydDkmm4u9yF8gF1eABE/n1MZrf1ej/2OSLYabg9Z6ADEPE/LHT6Jg6DK0ponEMvMrwrQeVd4Cxsm4h9Uds6qSjqdeXmvP7CC6vPo
 B4yo3roR
 Rwx4sQa78Bpc725CS6pfjKl6WdHiNjrRwAJjdSu3VtjChV++hf4RTn/8Dq7chw5ffrLVIQQL7NaY5qC/aWdINEXU7ZCu7tr9fe4vhl9+Gm5Nz5EQOKc2d1I4SkgnL78IPOi1pZd8WDvEBWyuVaWs0X4N5XeQSO0t6Em4j6lvfDvz0Rmb+o+T5VG/1e0A08rDJAOF92od1MJHE+mMLvoiftrDFyh5potyU53Oni6VOWyq/T7HNguLZeMe1zmmxAsq5aamgOv/6FstzMJCrW2weuLEoCBZC/tpBkVOQf8bDcMh0xbPTyviWYi8/HxR1ektUT8q2BPd8yMrPpiYp1DtTaQ/r9Uzaza8mhTbkawZNSTqx5wuC4OrGw8wXvbDdINMxxG9JZJyamAOlgoU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/21/26 16:04, Gregory Price wrote:
> There is no way for drivers leveraging dax_kmem to plumb through a
> preferred auto-online policy - the system default policy is forced.
> 
> Add 'enum mmop' field to DAX device creation path to allow drivers
> to specify an auto-online policy when using the kmem driver.
> 
> Current callers initialize online_type to mhp_get_default_online_type()
> to retain backward compatibility and to make explicit to the drivers
> what is actually happening underneath.
> 
> No functional changes to existing callers.
> 
> Cc:David Hildenbrand <david@kernel.org>
> Signed-off-by: Gregory Price <gourry@gourry.net>
> ---

[...]

>  
>  	return PTR_ERR_OR_ZERO(devm_create_dev_dax(&data));
> diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
> index 798f389df992..d4c34b2e3766 100644
> --- a/drivers/dax/kmem.c
> +++ b/drivers/dax/kmem.c
> @@ -16,6 +16,11 @@
>  #include "dax-private.h"
>  #include "bus.h"
>  
> +/* Internal function exported only to kmem module */
> +extern int __add_memory_driver_managed(int nid, u64 start, u64 size,
> +				       const char *resource_name,
> +				       mhp_t mhp_flags, enum mmop online_type);

This should just go to the memory_hotplug.h header.

The EXPORT will make sure that only supported modules can use this.

> +
>  /* Memory resource name used for add_memory_driver_managed(). */
>  static const char *kmem_name;
>  /* Set if any memory will remain added when the driver will be unloaded. */
> @@ -49,6 +54,7 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
>  	struct dax_kmem_data *data;
>  	struct memory_dev_type *mtype;
>  	int i, rc, mapped = 0;
> +	enum mmop online_type;
>  	mhp_t mhp_flags;
>  	int numa_node;
>  	int adist = MEMTIER_DEFAULT_LOWTIER_ADISTANCE;
> @@ -111,6 +117,8 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
>  		goto err_reg_mgid;
>  	data->mgid = rc;
>  
> +	online_type = dev_dax->online_type;

Do you need the temporary variable?



-- 
Cheers,

David

