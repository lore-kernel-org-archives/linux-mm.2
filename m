Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79577D29FEB
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 10:55:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDE7F6B0005; Wed, 14 Jan 2026 05:55:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8CCD6B0088; Wed, 14 Jan 2026 05:55:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C74F86B0089; Wed, 14 Jan 2026 05:55:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B48A76B0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 05:55:30 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2BB911BBC3
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 10:55:30 +0000 (UTC)
X-FDA: 84330263220.21.3E66EBD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5FEE280007
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 10:55:28 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UFqFErqz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768388128; a=rsa-sha256;
	cv=none;
	b=EqRBAqV+96VtqcFOp4u0LN1zpK+3BGk4kB0qQiT1Kcl8ZY8yYZlZYwUwC97vXYGr69PAVN
	jhCCkGbZasC8fsVZZzwUdBWannwVpLnxOE0B1xMhBp6ONZce/5RsgXjYonKcS7sRWVzvA7
	jc1hDPAaV64ymR08sY7yosvNws3R9lI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UFqFErqz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768388128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GWsYTbEUqYTnBQebt8qIrjTRS0sJxZPKFd+c9faVrvg=;
	b=4gBQq/dT+Fjx7OgBKuXdZGX48XLr6XwP0xWmNhxo12miB/+COgHoLberQutNR+EupNWlGe
	7HzpGVOTnvys25+ItandgpvjqVYMRBNnguSK7IvWlm4QOKnOrihw3eIigqFQH5CbN2SCKW
	OLRfBap4IQjaQ9n/K85CzU39L8te0Nc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6538D403B9;
	Wed, 14 Jan 2026 10:55:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9F41C4CEF7;
	Wed, 14 Jan 2026 10:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768388127;
	bh=hIuzYS6a+N3lbpi7hIrLjsDBa5QpNFERvUevfsOEfh4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=UFqFErqzPJ9xHsMZc9dlgwx8hnhxKPXXPYUA7gEGkj+uw1ZDtSkdXfwehvBaAUol6
	 /waiG99gkQrkadIv8oSCIckIZblqs4CzJfSq1HCXsQYuoX/lPqgirgy1JXbyvF2jMp
	 yls+m+cGqpmVjJ1+5oLRmxDTJx4caD6F6XcJxGkgXJZqBk4sKs0U/zCZW+nlvJD3dc
	 2TmzI4xtK2riCIBJCO7FIdzuy5ipOvxHnUH3EiP66tjgWs7KYS2vxMt0pNJ2EbXS5q
	 CC2/9ogYjJtlFKGXCK6PAXDRVwgYd8IjzO3GXNqhfcRjF0tZ/1NnTW+EtjPa22nxTZ
	 Z0gLImtzc6lZA==
Message-ID: <3555385d-23de-492c-8192-a991f91d4343@kernel.org>
Date: Wed, 14 Jan 2026 11:55:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/8] dax/kmem: add sysfs interface for runtime hotplug
 state control
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
 kernel-team@meta.com, dan.j.williams@intel.com, vishal.l.verma@intel.com,
 dave.jiang@intel.com, mst@redhat.com, jasowang@redhat.com,
 xuanzhuo@linux.alibaba.com, eperezma@redhat.com, osalvador@suse.de,
 akpm@linux-foundation.org
References: <20260114085201.3222597-1-gourry@gourry.net>
 <20260114085201.3222597-8-gourry@gourry.net>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20260114085201.3222597-8-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: j61xe1pkeydo5o46p6heqkyejetswmop
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5FEE280007
X-HE-Tag: 1768388128-923316
X-HE-Meta: U2FsdGVkX18kNXeLF5aMcUtDZ7VpyQ4ytjvOOcD/4B8UAYZGlMh1sPOQX3hv79LJAmJJQE0chssgPTvb6Jx46idWYPe2diZc9NeClIo783trB0VusVFNHp8a2+zsIFGpx51+NmN8sevlkpBUU9+Z/655UGcWIdypQvIoQH8kCcpeh48G6Ld6ReAv3zwtTgKPWGvbnX84g73UWvOi99I2ALKjvgkEvDkrm8Z6ulYhR9oy+4TiAhGc/lO4YF1OpeUkPNr02CbsZQtHetj1SfY6/rzTFmAXl1MNpCoEqLkHnt8/n5KNR16bN+x4GXEcdKZyzDoV9D7RuPOXKyQYPSOpMH0kqeBG+JUbwnst0Me24sYxWTF8BIYEzybK0svWxHm53DuhqSZXTFwl7R4SR8JetigMUpbEhuULBKHIlblMSSNYoEvfxhtPMAIZmkqZVMu8QqWlSZ+UB1APsU8rFfJk1cmC7tmSDz+2obZeob8p5LCWPiJxo8cd6EdM3eQML2VAJPB1wufnfCOj71/pDtu0CCGzqK6wkfoy/GOqDzM5RrBmFACwn0cOyftFBza0V+kYuNLjes5IVvUPBz7ouw/fksCW1Bia5L8jOre39cO2VBHonWOWsb/5FOgd6xy3cVqQpaM5lPM0VwcUPNnMjXHoleklU+IXDIdPN068Nuf/x1yv6EKzELYmiKyFugze9auUq2cknj6ENIehYHlJJkEWzx6XZo5ljnDr6txVpLYbY2+hGWdOrEFfhr2H67iaixYuKoAQHUsuAP+TV73vbRVaU05Gs2HsORnziXC/RAGE66vlWzKUc3qtbsfrnGXvx+CW7t5ot7qHYM923VzvubjEJByZiWC6odne7rCcgmfeOc8DkQ0IbLmaROlT1M7Ei8rTZ050DVRyqEdl7kl1DQacxok6khzL8SQAoXTd5AVYpwQFN2Fn/k+GB/s0YhVT4p29PQBW5W623S1+MLSEf1I
 H97OoktH
 kNcLj3k/1zcrzb15P9TEjwkOeoBp5pD/P12nvc8Box3x1HVGDejIju+8M3VWZjRt/oLoxYoRHamI9kYJl6Lo43Up7UbPeZT9+2m/P1oSRN029uKN7++4CcwaFw7f6GHu5dFeR5BNVidJIbYMFFekRSRBzt4SeFq5n5lAyVgIBgs8j+mdf/17YUCJ5I0OGKsH1wtSVCL+gFgW3EM2DeCYLju7NsyG7J/QW0iTU0c1VMWaHHgnT7/Dng3L8nfNKQZguUfE2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/14/26 09:51, Gregory Price wrote:
> The dax kmem driver currently onlines memory automatically during
> probe using the system's default online policy but provides no way
> to control or query the memory state at runtime. Users cannot change
> the online type after probe, and there's no atomic way to offline and
> remove memory blocks together.
> 
> Add a new 'hotplug' sysfs attribute that allows userspace to control
> and query the memory state. The interface supports the following states:
> 
>    - "offline": memory is added but not online
>    - "online": memory is online as normal system RAM
>    - "online_movable": memory is online in ZONE_MOVABLE
>    - "unplug": memory is offlined and removed
> 
> The initial state after probe uses MMOP_SYSTEM_DEFAULT to preserve
> backwards compatibility - existing systems with auto-online policies
> will continue to work as before.
> 
> The state machine enforces valid transitions:
>    - From offline: can transition to online, online_movable, or unplug
>    - From online/online_movable: can transition to offline or unplug
>    - Cannot switch directly between online and online_movable

Do we have to support these transitions right from the start?

What are the use cases for adding memory as offline and then onlining 
it, and why do we have to support that through this interface?

It would be a lot simpler if we would only allow

 >    - "offline": memory is added but not online
 >    - "online": memory is online as normal system RAM
 >    - "online_movable": memory is online in ZONE_MOVABLE
 >    - "unplug": memory is offlined and removed

That is, transitioning from offline to online or vice versa fails with 
-ENOSUPP. User space can do that itself through sysfs and if there is 
ever a good use case we can extend this interface here to allow it.

Or is there a good use case that really requires this?

-- 
Cheers

David

