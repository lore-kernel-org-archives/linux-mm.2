Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34451C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 08:32:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D7646B00AD; Wed,  1 Jul 2026 04:32:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 061606B00AE; Wed,  1 Jul 2026 04:32:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E921E6B00AF; Wed,  1 Jul 2026 04:32:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B0D986B00AD
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 04:32:54 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3290A1C1F0C
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 08:32:54 +0000 (UTC)
X-FDA: 84939542268.18.764E1F2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 851CA40006
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 08:32:52 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ej/bhLV2";
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782894772;
	b=Cac+Kr/Mb//BO4BMJDl5wvHMBdLVfm+NCBpdJvB2ui2JsEN6zj/EczGmQ1eyi5eZQrhwMh
	nQz70kVQGSvIn8lmxUVyr+NDHd6TOP9k576OFa5i58kbdyIgV3hK75OEuj3Ae31OjZ4ld+
	rsypgpG1U0G7PRAa3wqkiEuXNh2635M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782894772;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BSy3cfzVUqyR4pBWzhZ0/b5cdJEuto21KG+Sw+YT5bM=;
	b=zHkJdXveGc/RAfBzrfGYZARXmMsDnUhWg7iv8tCxG2TdFgagtjbYEcorxY2zlv75C/S/es
	dMtbCFMdIEOtS2aNbVPRpt1g/ri6HA8DH49POv2mDSUCiQJRh+sHK77NZ+H5RQ4Q/NvV2+
	tN2Vf1GigYelKwgriSK5/vGxrRGI0os=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ej/bhLV2";
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0BF3A601D7;
	Wed,  1 Jul 2026 08:32:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B0531F00A3A;
	Wed,  1 Jul 2026 08:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782894771;
	bh=BSy3cfzVUqyR4pBWzhZ0/b5cdJEuto21KG+Sw+YT5bM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ej/bhLV2lC+xeGIQFxa6NbBX1bHdqFNVtfWMnPmcd3tYv3DiL3LK7f2SwmyHZrZem
	 l1q8F5oRB3cekt4CRrVDQIfP7q7Iov3PkmuyUSHpSKlltbx8Da2dndhdKb1ngitM4Q
	 C329B8cViplBVPzYmkkhMZEYcXhFm7rhGjuTImwRJ3abixHDXV0TaEoBkUeESuu702
	 NVFshKGSoc5Ux1bfta221QCZaPqbE8ZUibY6RO+yOcflQe8JjVfD3bo+rL1WnPF1XA
	 J2Zvrr90sP9a9KZvZPY3HHIj9zx0gEHnw4wenBVPv7HeFeQUZjPbHC4von+mCgp4au
	 3UZEX/6wxZPFw==
Message-ID: <d5d9c27d-6a7c-40c1-9273-09c9d5bd2a7e@kernel.org>
Date: Wed, 1 Jul 2026 10:32:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 06/10] mm/memory_hotplug: add
 offline_and_remove_memory_ranges()
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org
Cc: nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-cxl@vger.kernel.org, driver-core@lists.linux.dev,
 linux-kselftest@vger.kernel.org, kernel-team@meta.com, osalvador@suse.de,
 gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org,
 djbw@kernel.org, vishal.l.verma@intel.com, dave.jiang@intel.com,
 alison.schofield@intel.com, akpm@linux-foundation.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, shuah@kernel.org, iweiny@kernel.org,
 Smita.KoralahalliChannabasappa@amd.com, apopple@nvidia.com
References: <20260630211842.2252800-1-gourry@gourry.net>
 <20260630211842.2252800-7-gourry@gourry.net>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260630211842.2252800-7-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 851CA40006
X-Stat-Signature: oec545y11awdyy9y36rffkknp1emqbbo
X-HE-Tag: 1782894772-737791
X-HE-Meta: U2FsdGVkX1+VQVsKBXJfJ4niNLlJ/L8UZ8oyluR3x959kEqKB+/n8W02MjFv48PrcPnuMfGK+0tqudoehedOu/F1NCNzlaGDs0V+lLZsLLuPlGneiBMySxGn/4zX5BX+83QmA9y1TZX/mb17AUfQM0E3bzt4Ogy04fxb5g1xDpfcVnYLIo6RBYfk7Qn/SPa/q6zeBdJ81HNCiNee9xgRhd8INvfGvDrIDD1MoXd/nA/Uth+WSao4IWgmTnd/vF1zkKoGe7Vql7xE+z+y0F5QRUtpZ8sNmEkeHsgX0zNTuo+9hOaWClKWPdmbGKj+zIz+lTb2y44x2MpKfm4e4A3v7AffWRQsomlVPoRhUKfnvzw5kVDcQaB/WZW1vNHwP5YhcaNIX6bEDNVaDwHqYFZplJ/MMaafrETzlfrl356eAajqRb1h4Gitf3s1jQpjUQG02MMDrDShct0X8MVXI1rFCXfW6OtJs8KIuj+J7vHIX50bqkX2yukdzx/vItpMRk74RGUQ34flCgTRHR+EhOE0RbocW4eP/xcYu035Fm+Xq1qW5cDDr3vRjnqYHbawHJ2BABFBtlSt9FFasXKMoZRb2Aw3pkJQbL3joujtwYnKYSmsN7YE41aKMyjZ0hy9vSTNhRf0TKDxPae1Wr6wxy0/yE/SlheYPbmfEfeF9SU96jarVG187oJtY5g4p84rVbqvYoJW3L+sA7uNw2pnQt+hO3ZacbfPxBP/sSfUlsL/UHFBeVAsFv86EVpyiS8iJbo3mT5q75PpuDJbXjJimu3SvhsVKQQgDI12QWeqFwut3LoE2/MxKQP6RLXzpb+15Nxo+Aecc5DzPpd4Z9RTKQqDzlizTYmLV6fQLp0jhhWn+K4HlsNJx8LIjtqwV12cP9Fs8zZEjuz/Nlk7XcajeEIa/NOO5GrStR6tTL/EH5HAHiKaribTpFa/389uM62GV+7BLMpK+nC2V/SiWtvGTaU
 4ZCAJF5W
 3xerRhrqfh7mJPKux2JkzOiSoVnsBvTDcC5NfaxwcGGBbCplVqiDPtlAtq7TbmC11+G4eW8nXMiTC67B1JWfz6aCchTIFDPBEMmrmRV8EPq1v5EkDUsgVIFkeYpg2ipBWaGLR3/YV8SDUte218dPiok4Mda6L2fXTPXVd+MQ2kEP96ghDlrgopr2DLXuQ2y5zUGeeGCVRFoMtM+XHUFKJ0QhI9Q1qBZihqeIBl3UFzwHfB19V/qpAeb8bcL8zaeo3vMJzrK4XWY9PAJiuZ3KHoTotGCmv8dMsm4blc41V7OpU9ot2evvHVKI9n/LyNmUKdPXnMopd2Lxs8OjIE7UUUbS+EUZPm8+nVPJb/3B9S/ciGD+IqyN0Tt3fUFdmM0tedZxvSMizFa8CxNU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/30/26 23:18, Gregory Price wrote:
> offline_and_remove_memory() handles a single contiguous range.
> 
> Callers that manage a device composed of several ranges (dax/kmem)
> currently have to call it in a loop, which gives up atomicity.
> 
> In addition to pushing rollback logic into the driver, the lack
> of atomicity creates a race condition between system daemons trying
> to manage the same resource:
> 
>    - Manager 1:  Offlines memory blocks.    Removes device.
>                                         ^^^^
>    - Manager 2:  Detects offline memory blocks, re-onlines them.
> 
> Add offline_and_remove_memory_ranges(), which takes an array of ranges
> and processes them as one operation under a single lock_device_hotplug():
> 
>   - Phase 1 offlines every block of every range.
>   - Phase 2 removes the ranges only if all ranges are offline.
>   - If any offline fails, the whole operation is reverted.
> 
> This gives callers all-or-nothing semantics for the offline step, so a
> failed or interrupted unplug leaves the device in a consistent state.
> 
> This also resolves the battling managers race - the second manager's
> operation simply fails when the block is destroyed / cannot be onlined.
> 
> offline_and_remove_memory() becomes a thin wrapper that passes its single
> range to the new helper, so the offline/rollback logic lives in one place.
> 
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Gregory Price <gourry@gourry.net>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

