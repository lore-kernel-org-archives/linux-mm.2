Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CE3EF506D3
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 13:30:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DCAF6B0291; Mon, 16 Mar 2026 09:30:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99D2B6B0292; Mon, 16 Mar 2026 09:30:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89F6F6B0293; Mon, 16 Mar 2026 09:30:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 76A186B0291
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 09:30:35 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0B3D58A848
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 13:30:35 +0000 (UTC)
X-FDA: 84552010830.24.5E6AF7B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id B606EC000A
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 13:30:32 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf22.hostedemail.com: domain of robin.murphy@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=robin.murphy@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773667833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5ZuqlSrxX8r0RJlIlalGnSaHgtTRi6oi0YhWSDJolTI=;
	b=UpYv53W1Pps+VF+aBmhZ+FoLB5zHq7RZnbkU2P9cMAZU8acFCSjJoROtbuG/flOIpRhnLT
	nukokFXC2/xvcdsJxR4y80IKeIeF2o/jvXVDP1JL6kbdvJW6u/tx+1T6QQAerHgfaRiK8l
	hYOD+wKxdR7EzLhgFu4E5Lj7UJDWq2Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773667833; a=rsa-sha256;
	cv=none;
	b=GFOXTfP2o+1OwOy/gHsFhK14yCxFoEHLFo3aoG5lFkqI0nFwjSSXvKAnU9cAqgW7Y7Hc3x
	t9itvdytWaMINCmgi2dY+UTD07Gx/k3i9y6jEKY+/KQ4kOW/ihaBqAbdcrd4FE8DoBZiDZ
	/Iu9EQ8IjW68AO/fYakCiz5k3iFsoFo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf22.hostedemail.com: domain of robin.murphy@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=robin.murphy@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 357291477;
	Mon, 16 Mar 2026 06:30:25 -0700 (PDT)
Received: from [10.57.61.116] (unknown [10.57.61.116])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9D4953F778;
	Mon, 16 Mar 2026 06:30:22 -0700 (PDT)
Message-ID: <2c7466f5-d952-4356-9b55-9d2ebb3471f2@arm.com>
Date: Mon, 16 Mar 2026 13:30:19 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 50/61] iommu: Prefer IS_ERR_OR_NULL over manual NULL check
To: Philipp Hahn <phahn-oss@avm.de>, amd-gfx@lists.freedesktop.org,
 apparmor@lists.ubuntu.com, bpf@vger.kernel.org, ceph-devel@vger.kernel.org,
 cocci@inria.fr, dm-devel@lists.linux.dev, dri-devel@lists.freedesktop.org,
 gfs2@lists.linux.dev, intel-gfx@lists.freedesktop.org,
 intel-wired-lan@lists.osuosl.org, iommu@lists.linux.dev,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-block@vger.kernel.org, linux-bluetooth@vger.kernel.org,
 linux-btrfs@vger.kernel.org, linux-cifs@vger.kernel.org,
 linux-clk@vger.kernel.org, linux-erofs@lists.ozlabs.org,
 linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-gpio@vger.kernel.org, linux-hyperv@vger.kernel.org,
 linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-mm@kvack.org,
 linux-modules@vger.kernel.org, linux-mtd@lists.infradead.org,
 linux-nfs@vger.kernel.org, linux-omap@vger.kernel.org,
 linux-phy@lists.infradead.org, linux-pm@vger.kernel.org,
 linux-rockchip@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, linux-sctp@vger.kernel.org,
 linux-security-module@vger.kernel.org, linux-sh@vger.kernel.org,
 linux-sound@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
 linux-trace-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
 linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
 ntfs3@lists.linux.dev, samba-technical@lists.samba.org,
 sched-ext@lists.linux.dev, target-devel@vger.kernel.org,
 tipc-discussion@lists.sourceforge.net, v9fs@lists.linux.dev
Cc: Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>
References: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>
 <20260310-b4-is_err_or_null-v1-50-bd63b656022d@avm.de>
From: Robin Murphy <robin.murphy@arm.com>
Content-Language: en-GB
In-Reply-To: <20260310-b4-is_err_or_null-v1-50-bd63b656022d@avm.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B606EC000A
X-Stat-Signature: mts7be8jq8y4by7x3w69hztc6zk4snqx
X-Rspam-User: 
X-HE-Tag: 1773667832-858558
X-HE-Meta: U2FsdGVkX197hWwpgr5H4uIkWLjQZEZqrIfidFMyS7GmxcawuGM+PPn1s2Z3AgB6BMdELzAiKM9bTCELygZZPZiOb5k6RQRlUG4pWC4rqwJiKuCgzqGtfpwTXKpLeDdfl4gwB4HIKUixt3qtFcV58KHBZsC07dNbsolIW3h3dt7RyBhquxfoYXPzBMsg4mjyXoVus7xqew2bjuO7G/IZv7IFBDyqJFDs5oBehOndodxYGco7Y+yABgLQ6mdLTK2XA2OmvSIg8VQboBJrEqqSyLz2U7qodkxkM+XNmxB+lmcfYqQKK5tGf56VkyxMSze/s4ePq6ETYSnM2tmcLKj9oFIWA7+UgZAnmTJ4KpREEfNN52eYqdROkNBimHyi7jI6LawpTuerWIWnycEktwcazv3wIwKAvO9oZpuGf7657xXzaz+MRnP3EGh75/1g3TooRvU0r2eVfTOhsmyhFv2+cATv98dv5C6StYj68Ywm1mYfK0wOHcV83NlmQTYiLguBZlLLmC06v0TlS8n67XOiFn+JCvMStYAi8CEfK4rpbelyrVMAtbmeuQ6b2dRsun9GuribxGAPvXWQlqoDzvAtCGcRGxTLsprU8nu6G1IRgs/XvBAtjmQbyxdtgJ2XuUr1VZk1sh7GokLgbadXRp2cXXVz/slkio041K89tCtke1+rDYhJQLFVTpceX2ZCx2EZCbmlokoJpoB+YSt8QpkkOmVxDLHnLuvnI7gNRj20kdU0IPmIub1hbd3hTQh/qcigOXfRljIeytU4LVXqLGIfReK6lB3XE00AtGaB+CG8YcsaTsdEYrNB3Amvodp91jZl2TxeWR9q1EjOgoPXeFz+dvreYWjHMGNzidh5pfbaSYan93igdCqEoHHAM8ZkP7GhjqXzjLNIIThQLiBeTepXPtsvfLiQ++dfI6w7Ud2AqJ8BbpVG0HPRJUDlqJ8xkk6dUCzlnhBBdmJxfyrwdZx
 6bWHO3Yl
 jFL+SzfMI5Z/Bjpm7/OqgMF/cJvQDH8GbicfsVWUOVdzonYweuzmo6hXni6UOt/ewbxKwj0gUSvxthTQMVwsV6Fym7DfrDjwQEwmgQkZeR/J9GwZ6AIZ7jYdcCqhqwnXzGrOXoNDOjRp6/7O5aP3OCzMmp0flWPi1grUz2pS92QeNMeT4aDP2hSoNnlt5p99+viZgaQ2ucCDORZvKEnpwsExU441jyPbKDVXaG9yBzJDYyW7evGuBlTKGYshMQLduFQTTw1jYOSmPu4wulIMuVivvRwdji+mzSIOM3cjacT6fCCZzDNR30ff4zDp3m+r7SSUWi1SmV/HS83PKjoVOoEX4ksjKQvMiHHwtL9uEZeQhXfIo7FgTUBQC6g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-03-10 11:49 am, Philipp Hahn wrote:
> Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
> check.

AFAICS it doesn't look possible for the argument to be anything other 
than valid at both callsites, so *both* conditions here seem in fact to 
be entirely redundant.

> Change generated with coccinelle.

Please use coccinelle responsibly. Mechanical changes are great for 
scripted API updates, but for cleanup, whilst it's ideal for *finding* 
areas of code that are worth looking at, the code then wants actually 
looking at, in its whole context, because meaningful cleanup often goes 
deeper than trivial replacement.

In particular, anywhere IS_ERR_OR_NULL() is genuinely relevant is 
usually a sign of bad interface design, so if you're looking at this 
then you really should be looking first and foremost to remove any 
checks that are already unnecessary, and for the remainder, to see if 
the thing being checked can be improved to not mix the two different 
styles. That would be constructive and (usually) welcome cleanup. Simply 
churning a bunch of code with this ugly macro that's arguably less 
readable than what it replaces, not so much.

Thanks,
Robin.

> To: Joerg Roedel <joro@8bytes.org>
> To: Will Deacon <will@kernel.org>
> To: Robin Murphy <robin.murphy@arm.com>
> Cc: iommu@lists.linux.dev
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
> ---
>   drivers/iommu/omap-iommu.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/iommu/omap-iommu.c b/drivers/iommu/omap-iommu.c
> index 8231d7d6bb6a9202025643639a6b28e6faa84659..500a42b57a997696ff37c76f028a717ab71d01f9 100644
> --- a/drivers/iommu/omap-iommu.c
> +++ b/drivers/iommu/omap-iommu.c
> @@ -881,7 +881,7 @@ static int omap_iommu_attach(struct omap_iommu *obj, u32 *iopgd)
>    **/
>   static void omap_iommu_detach(struct omap_iommu *obj)
>   {
> -	if (!obj || IS_ERR(obj))
> +	if (IS_ERR_OR_NULL(obj))
>   		return;
>   
>   	spin_lock(&obj->iommu_lock);
> 


