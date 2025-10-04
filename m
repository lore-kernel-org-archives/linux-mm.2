Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BE53CAC5BB
	for <linux-mm@archiver.kernel.org>; Sat,  4 Oct 2025 09:39:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2E4C8E000C; Sat,  4 Oct 2025 05:39:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C05FF8E000B; Sat,  4 Oct 2025 05:39:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B42E68E000C; Sat,  4 Oct 2025 05:39:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A35B78E000B
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 05:39:31 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 337811A0967
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 09:39:31 +0000 (UTC)
X-FDA: 83959934142.18.ED8A464
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf04.hostedemail.com (Postfix) with ESMTP id 432154000D
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 09:39:29 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=gLxYlWyC;
	spf=pass (imf04.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759570769;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hwiOFMXp5UwwYIx996Mp0qUz+Rdrj5Emf55lrlBPTfM=;
	b=hSIBLCmG97UhVW4lgjOdtgvKey3rMGzKrrJ/fjhN54ymkq8iK0zn5bhvzhu81/SbIClf8h
	N52Ptkcmyp9BQJAQLln4DezCOhtIrb4bZcxJCT2GbG0CUYe8oR/NHB4hOZhXN5exlAmr1u
	s8yKcS8awRlzIRkJYTEc4NYVl/mle7Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759570769; a=rsa-sha256;
	cv=none;
	b=HyNhnVLK/Jllak4QH4P0iExWNUNRLLq0EZKWEDV50tTW+fzo2ONy0LSfr8qFc09QxCBOg2
	kf+rk2INhAR8wYHzo0rYJehCyVpzg7m3Asnf4XexlfUc4wzFGfYojuaApICgcZX+Dl6X+K
	slnn86GGJWw9iuBAiCLXGd6U8v5QWRM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=gLxYlWyC;
	spf=pass (imf04.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1759570767;
	bh=qisPUywAbG75IngeanB4QRWIZ3GHsT6vh+Z8ufjXF68=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=gLxYlWyCPWNrBp7a7jJiAVFHXUsoxmnDJmdwJfGbhsSLfVzaamN1+Mu/C/H4snDWv
	 1vTK+1BMDuhsEbugYcUo9aLzxlm42VZkwXqFLT3bA/aJ9ifD0kyjvLrOHOtOh04e9P
	 sdy/EHQa78XMogigp2dQMaWfhSDGX6I14G4AdzY+1AOqM2r5lH7flkL+VXh3Sxid++
	 oocuhJKL0AKYis3/uW2TF6YxxT1DJO4PZr+7BIjDIbD3ywew4RmJ2FwhEA6/RUfGVr
	 Pmrzr5DmT+7UMout1aiJSIUVfbzMhoUuH2kNEZ8iD6O2JkmfsiYw+uGsFXXe0wiAaK
	 +yWAZc6KypL0w==
Received: from [IPV6:2a01:e0a:5e3:6100:7aed:fe0e:8590:cbaa] (unknown [IPv6:2a01:e0a:5e3:6100:7aed:fe0e:8590:cbaa])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 4820A17E055D;
	Sat,  4 Oct 2025 11:39:26 +0200 (CEST)
Message-ID: <f9f92476-c218-40d0-bb45-382252e2f288@collabora.com>
Date: Sat, 4 Oct 2025 11:39:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/8] drm/panthor: Introduce huge tmpfs mount point option
To: Boris Brezillon <boris.brezillon@collabora.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin
 <tursulin@ursulin.net>, Rob Herring <robh@kernel.org>,
 Steven Price <steven.price@arm.com>, Liviu Dudau <liviu.dudau@arm.com>,
 Melissa Wen <mwen@igalia.com>, =?UTF-8?Q?Ma=C3=ADra_Canal?=
 <mcanal@igalia.com>, Hugh Dickins <hughd@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Andrew Morton <akpm@linux-foundation.org>, Al Viro
 <viro@zeniv.linux.org.uk>, =?UTF-8?Q?Miko=C5=82aj_Wasiak?=
 <mikolaj.wasiak@intel.com>, Christian Brauner <brauner@kernel.org>,
 Nitin Gote <nitin.r.gote@intel.com>, Andi Shyti
 <andi.shyti@linux.intel.com>, linux-kernel@vger.kernel.org,
 dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
 linux-mm@kvack.org, kernel@collabora.com
References: <20250929200316.18417-1-loic.molinari@collabora.com>
 <20250929200316.18417-7-loic.molinari@collabora.com>
 <20250930123416.4ff59b11@fedora>
 <d3b927b9-ddcb-492a-a72c-d42abbb11cff@collabora.com>
 <20250930185216.0219a542@fedora>
Content-Language: fr
From: =?UTF-8?Q?Lo=C3=AFc_Molinari?= <loic.molinari@collabora.com>
Organization: Collabora Ltd
In-Reply-To: <20250930185216.0219a542@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 432154000D
X-Stat-Signature: mbrmzg3ttopjqa9eswgtioscd3cjyiqb
X-Rspam-User: 
X-HE-Tag: 1759570769-506446
X-HE-Meta: U2FsdGVkX1/ZPVD66UGl2ZYowmHFYbTd3JtGrnNXriQOl5tYE/BrExz6W+8tB3qfoNWwB+uFhvSGjDAlBMnUxRX/GPk8Dwu31Rd85SYwQxmOChhaD0ZWazIH2BcYqMba4QXzRTe7jRyk4+DZW1+rcfrZwHzrCJAuL29hPWnbS+g5jwMaQRGc6lJxxqqCsyulnjaeMw6s4YzNEU/t+ag6MAAvzqoqap1W5XJtH8CyJLldudbTLqQ4w2QBGVeL4BoQ3FR4N41stLqHVyFyvhQtV3hDLzQedcX646PMh4I2B94dXs0IyhqmlROoYmFCv4NUY9ZcPrp5xj+qh3aFcdNHsvnyQw2l9698IC7EM8ShtwYNlkX2ZkImDrtp8i0r2AVufVkxIfY1JXlAGYh6WIGzEnbS24+YnpVTrQ+SVRaXnpwJhnq4nKceLq/66dks+EIFfYR3ddjHtGQLUikJ6CsAdoigqrZsRvu2+kFO/AGxiUePfigpNcb0GMvcVYAVEyYQdKiXqHuUPYiztxgn9Wd+8j+PwrhGeJyTV0QZQfujHpOH18MS+891b3Hx75IxpKSkqH07zQNo7qJLHbFmbPZsl8L2Gv6wVcS2nIJW6+9QlF1WLqSDJjhtqKX2T+a7Typp1gjW9RSZvWtL6fIMteVTLSvHUlMEnRT/tCLO1JlCWtc6N/TJC/h5Ra1y+meKh8Pw/Z/MO9Rv4fXvxORB+gQNTiVenVWogv2j5NCUoLujBWOo35bh/7SjzlGONdsWqYaBCgCCEuB44KfhYeZmnkbUZkisRkKyg+k8jai5SDZRJaOTx+pwEL+juTavJZGwvkiUMdwxK7qPe3yxGCfMiNv+hQQdi7uSNNtXvr2I16hpL3FjF5oUZgkJ5c0aCTJmGoG40y7dt2mv85Mf8wj6MQkVDuYN4FF5w0gjto80xDlCIzqjVxnc9a+OjrSvzhk8d+66O5zNDI2HmhGwyubR6x2
 Uouo+X2O
 7WWQ4Rbvmn0Ut/3BaLSUoMdZWvDYuPguabYdeH6fdHETij813SMdSLmg7ieUmnTeLXqqPz9Y00oH3/vhbXUc/PgVSXiyrZmY4CEXikOHc4QUG978YHZfmPICwgQOIh5qxWrkI21MHtwnathrxjqfg5XzmIc/K/jG+TRlWeB5mZ57uy6hBxZ4DCezUMTaap4+BpMKpHj1GPG7qd2n7Krp+yLdp0f7w/tiiTJz6zLE1VK9+cFAXc/j2KRpmg7c6CrwTt1H2GTrREUzSRt0HqUhNqsehIT2oS268W3cNhVDLPfJOYP8d+FyUMCIc3LNzdS66N+iQ0TQmonVsPZfvcX5QnrVMdlp68lRppeV8N9vKaSMXZjmXTub/j3kV9nIYGcW8k7NEaAIFkTmbTjkemWgiT/rV/J0sMj9ht6mJebbOYMGjd737vu1+pUG+oj418XBEGzBxUTQfUuu3eQc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 30/09/2025 18:52, Boris Brezillon wrote:
> On Tue, 30 Sep 2025 18:31:11 +0200
> Loïc Molinari <loic.molinari@collabora.com> wrote:
> 
>> On 30/09/2025 12:34, Boris Brezillon wrote:
>>> On Mon, 29 Sep 2025 22:03:14 +0200
>>> Loïc Molinari <loic.molinari@collabora.com> wrote:
>>>    
>>>> diff --git a/drivers/gpu/drm/panthor/panthor_device.h b/drivers/gpu/drm/panthor/panthor_device.h
>>>> index 4fc7cf2aeed5..54ca61567426 100644
>>>> --- a/drivers/gpu/drm/panthor/panthor_device.h
>>>> +++ b/drivers/gpu/drm/panthor/panthor_device.h
>>>> @@ -135,6 +135,9 @@ struct panthor_device {
>>>>    	/** @devfreq: Device frequency scaling management data. */
>>>>    	struct panthor_devfreq *devfreq;
>>>>    
>>>> +	/** @huge_mnt: tmpfs mount point with Transparent Hugepage enabled. */
>>>> +	struct vfsmount *huge_mnt;
>>>
>>> Now that we have a helper to create a huge mountpoint, wouldn't it
>>> make sense to have this field in drm_device instead of having each
>>> driver add a huge_mnt field to their <driver>_device object.
>>
>> Not sure this should be enforced for all DRM drivers since most of them
>> don't create separate huge mountpoints (only 4 for now including this
>> patchset) and I guess some maintainers might prefer to depend on the
>> sysfs interace to enable huge pages.
> 
> I'm not saying we should create the huge mountpoint by default, but if
> this is a generic helper, it makes sense to also manage this mountpoint
> internally. In the end, it'd be a small price to pay for drivers that
> don't need it (the size of a pointer in the drm_device object), and
> with this in place, driver wouldn't even have to call
> drm_gem_shmem_huge_mnt_free() manually (can be automated with a
> drmm_add_action_or_reset() calling kern_unmount() inside
> drm_gem_shmem_huge_mnt_create()).

Ok. I've just sent a v3 of the series with the huge vfsmount stored in 
the drm_device struct. This also allowed to get rid of some of the 
*_with_mnt helpers.

> 
>>
>>>> +
>>>>    	/** @unplug: Device unplug related fields. */
>>>>    	struct {
>>>>    		/** @lock: Lock used to serialize unplug operations. */
>>>    
>>
>> Loïc
> 

Loïc

