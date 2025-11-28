Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA381CFD376
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 09:30:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CD126B0022; Fri, 28 Nov 2025 04:30:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07DC06B002C; Fri, 28 Nov 2025 04:30:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAEB56B0032; Fri, 28 Nov 2025 04:30:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D276A6B0022
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 04:30:24 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 750D5B9704
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 09:30:24 +0000 (UTC)
X-FDA: 84159495168.27.A392313
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id D057218001B
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 09:30:22 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qd2NiCXu;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764322222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+ODDrlAQRnUlkDU5Xm0RKmEYqJfWHRVMf+0l8T9h3sY=;
	b=3D6BVUtXnu0FO5l1sUO1K188QlNgsOTUMzRcbclxD12qkJqCoQYMUMw8Abm05oJAaNpwFG
	pm+p8AmKa+1Mz1ywCNU+CXy0PxU+JKAXtKupUX3OIPQg7FwCCFvTBCi3MDq23O1f4SJdaU
	K71o5rtuqVsGt5ZhrqTbHthhCNTNGlU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764322222; a=rsa-sha256;
	cv=none;
	b=Yxw/oHBo7hNU/Q2LKucUu7n63ZAMvkQ50uEFMThy2UUeV5DjvN5cftMLC7S6crIeHtTtql
	mU44hIMyAIH8WKZY+s8Gkv8PX9vzplO6zWujdcpBCzOUjVrEKj49YYsdYguIpA9dxhzrK8
	ozu9lrXjINZtENT8F5jOSyHCTmUgknI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qd2NiCXu;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 045DF60203;
	Fri, 28 Nov 2025 09:30:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19BA9C2BCB8;
	Fri, 28 Nov 2025 09:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764322221;
	bh=c+ju217X/Iu2Eyrw3ITJ5fQi1c/hHwxKC7muOjOFeAM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qd2NiCXui9tsiwdCYok4UcUDQqTMMHZ6dOVLI2a8Xq54o7qj/gy6iWGAmfeyWL5FA
	 AsOozZOa2wastuPtMQVwdg+nw8TUIggbbXDbFvAXxxuRXII5OylWbCEY0d0IK7wAWz
	 YWD+EnnPEc5wBSsoeAdM35iCQM2bQmQXYCl83xolfiOZLxpllI6bTnSbqXqKeSPA6y
	 JNgKKja898564OBPnGHhqQ5sySb/JvG6rdgJsmNB+YH5OWCZYPmzzCKCsmOfzJvWh4
	 UO4uKNdhhtpsauOOAJQyf34Zczo24r/NZ29e9HNiu1foo4xfKEQQKStJKSQcPQGtua
	 Yv3nsgTV78cFQ==
Message-ID: <beec5651-5c23-4f5e-a0a3-d1cc01a8490a@kernel.org>
Date: Fri, 28 Nov 2025 10:30:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/4] mm: Add support for unaccepted memory hotplug
To: Borislav Petkov <bp@alien8.de>, Kiryl Shutsemau <kas@kernel.org>
Cc: "Pratik R. Sampat" <prsampat@amd.com>, linux-mm@kvack.org,
 linux-coco@lists.linux.dev, linux-efi@vger.kernel.org, x86@kernel.org,
 linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
 dave.hansen@linux.intel.com, ardb@kernel.org, akpm@linux-foundation.org,
 osalvador@suse.de, thomas.lendacky@amd.com, michael.roth@amd.com
References: <20251125175753.1428857-1-prsampat@amd.com>
 <20251125175753.1428857-3-prsampat@amd.com>
 <66ylzwknm4ftd6utn3nqr63jmhl2ccvcdvyi5fechfnvmfxivu@37pckhjixayh>
 <20251126223127.GIaSd_v7juUkaW4RTA@fat_crate.local>
 <m3l6gcjmbabudtnqwv6w67t7iz2mpmbjyrpnmiq5k2iyargn5d@nyf2zzxx7yme>
 <20251127181233.GBaSiUkaLzwANS_6WT@fat_crate.local>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251127181233.GBaSiUkaLzwANS_6WT@fat_crate.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D057218001B
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: wn9gyrqta6qucf97rsmcej6oce7kn4nc
X-HE-Tag: 1764322222-450370
X-HE-Meta: U2FsdGVkX19ubsFbJXb0mOPih3BcgNZbV+9FlUpVgEgAeffrZqzuyqtEP/Xd7YYeSWy3SoA0Adxajui6iL3oxFX1AVFrqmMZZGKrS52K15c9VeJDJ7/sNtq3hQFOZU/WjLtcFSrOaTy26Iebwr3Dp8Xr3fOgxJ2kdhdwD/33TRN5ad25e5iCJ0vCFVRk/ZAneu/InZ9KhkESrt1d7baTdOiN2fPeGZBYi1l2jeoJE95K67xRJVRNB+pGQP6fIwtWif7t0iGaCeAyP6OxrUYW5p8sP1mvJy6L6xsku6GwibrFCmPJ6QuTYDFQmubX9D7TmZy4OMaxHAqtoBQjnIHxRVNlWpvQvYQdX5RiEAbpU5tBcaCxKWV1Vt+233xRnCWVqHCa/xdzFon/krCfKsSpxrvCbbgEre+qDDjzp5GbvYTcd6d+eWyLdA5AEFinBZH5OITY4GNT6vv026YkCXsWpTIb27486g0GdeSMBYLtOX7r/LHykUaNfXcZrLe8JaLsaevnKT1Dxe5Po4xaO6nrKLIjcL92+Liy1uNY08j9GvJpwGDLpZAXJwpJBJEoz9mVg8HaCU3fIxB5875CrO5sF4TsVNkyact0fLEFmbGdYiFC+AYIV/tNsJv8cyBOxygbYcaREj0ploL94wQej1w0WaeP9IhNRN7OvF2+XQ0Nb1zUMp7fc/6qBvGHsFUJTOdiVnp//rQYoEr+ROuLcv4GXzSGnt1eHj0g2pcBa43633iVCXrwmp9HaxoK37FLaTcmoxg/7MzwpjUhid9XUpkbtcb/QCiIipMlm2+wyeT5lrrILscnitGos/oE4dK5CmidOrVDldUmeIEgqw/1vXrKVIKstr/UT2wfuJIyfPjTxQvJZoG2O178HDh/lCVL0SjJy8jhL39QBgO3d8fLJgNgQX3ENjHJkRF5tXQmclX+zHNu8I7Cj5LrppC51yC8vSHM1gA1CK08WANcyXXk8G/
 irSViXQc
 pmqqTB1lgsYA2ULD5jwKMMrc8Nr5sKmXVS9Ow6mZ671szxA16QHsKrNqUEfGoFuqYnNbtx+UGpke0n2C23kxKW0OQ8H/rbd+IVH5K0xpvqtvJP7oEm2ux+563WBF9BgXHCELu/W9CX1Uvckjp3/p8/NEUYnUXncFSdR7iOkA3e2Envb16lG4LEj50XK3SFEPKv1evewQXOsivjOXdrw92y7tGDsG8rCsvDopKWR2F/hN9TSMqPCLAyzPDe5KtYmipcE1D
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/27/25 19:12, Borislav Petkov wrote:
> On Thu, Nov 27, 2025 at 05:35:57PM +0000, Kiryl Shutsemau wrote:
>>> ABI break for kexec? Is that a thing?
>>>
>>> Since when do we enforce ABI compatibility for kexec and where are we
>>> documenting that?
> 
> I'll take that as a "no".
> 
>> The whole purpose of kexec() is to switch between kernel versions. This
>> struct defines format we communicate information about unaccepted memory
>> between kernels. The mismatch will lead to boot failure.
>>
>> The structure is versioned. Ideally, we should know the format of the
>> structure the next kernel supports and act accordingly in the first
>> kernel. Like, we can accept all memory before kexec on mismatch.
> 
> None of that matters if you kexec the same kernels.
> 
> IOW, for some reason you want to be able to kexec different kernels. The
> question is why do we care?

kexecing the same kernel is typically used for kdump purposes.

kexecing different kernels is used for all sorts of things 
(live-upgrade, grub-emu come to mind). It's quite common to kexec 
different kernels, or maybe I misunderstood the question here?

-- 
Cheers

David

