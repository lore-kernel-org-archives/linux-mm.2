Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 601D4C44506
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 14:19:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D54086B00AF; Fri, 10 Jul 2026 10:19:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2BC86B00B0; Fri, 10 Jul 2026 10:19:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C40C96B00B2; Fri, 10 Jul 2026 10:19:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A51B76B00B0
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 10:19:09 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 40EF8120479
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:19:09 +0000 (UTC)
X-FDA: 84973074018.04.49CF01E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 42F7E1C0004
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:19:07 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=qFlaihad;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf18.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783693147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YGhxiQ2wHg/fmfhidZ4pixyfl1k6upbKB+lX0ueY5go=;
	b=xHmEiWk65ZqaGAmSVrxvoVcBcmjcDjKKLdpQm5LFoHhZvIByU+p/65qS+KqGe4Ck6EMe1m
	8vAHz6GML0KYPW8KJpiKAFgpmofb8Ex1EAhKb7QcZIhboeZdA5pWXHiQg/e7u1FBJ2DWE3
	MgOb7kZEZuPPsCPEKCiguGp1ktbCcxo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=qFlaihad;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf18.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783693147;
	b=j/3StJ+Y7z64ED5b39/oGLCfa5BaufMYW4gLGNvQE2tEnfiZJ33XyI0jVVwUhWmdclBLYp
	8WlEiYXkTY0WtS7yG3VKdPAuQyMTI/NsY9W2GNgOiXZKmKNyOzCNr0X1NBwkr9zaljbpzs
	vYcA7dow4OYK9GqIMeTUICd/NSug3ZI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9CB1C60051;
	Fri, 10 Jul 2026 14:19:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF0A51F000E9;
	Fri, 10 Jul 2026 14:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783693146;
	bh=YGhxiQ2wHg/fmfhidZ4pixyfl1k6upbKB+lX0ueY5go=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=qFlaihadj2osXgYoq5pgN81gSLfdraUFeTRyznRcKUEMTtPKCZrr9NmUkUTDtejqN
	 1W+OIAZkXybtMXrNqkqSVGJBlfSBX2JHHnZPWNVTGp4xhYQ/Tx7xjeY4yjRBed1+G7
	 q7az5F8YauhjZC+poa5Z/WLIzhcF1cqXxyNDRTZE=
Date: Fri, 10 Jul 2026 16:19:02 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Pavol Sakac <sakacpav@amazon.de>
Cc: "Rafael J . Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>, Tejun Heo <tj@kernel.org>,
	linux-kernel@vger.kernel.org, driver-core@lists.linux.dev,
	David Woodhouse <dwmw@amazon.co.uk>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	David Matlack <dmatlack@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Alexander Graf <graf@amazon.com>, linux-mm@kvack.org,
	kexec@lists.infradead.org, nh-open-source@amazon.com
Subject: Re: [RFC PATCH 09/14] iommu: lazy-populate iommu_group
 reserved_regions/type attrs
Message-ID: <2026071045-pushcart-duller-c3fa@gregkh>
References: <20260702174033.32116-1-sakacpav@amazon.de>
 <20260702175114.24659-1-sakacpav@amazon.de>
 <20260702175114.24659-5-sakacpav@amazon.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260702175114.24659-5-sakacpav@amazon.de>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 42F7E1C0004
X-Stat-Signature: s5fhdnt8eumbisyxfipckodw6ezmedcc
X-Rspam-User: 
X-HE-Tag: 1783693147-723089
X-HE-Meta: U2FsdGVkX1/rUlPZ/4oDb5anCDmq+N7dP6vnBEV9yztRJ9jyjkQsRY+VwQBn6nTpo/ai7Hv/dSRuy5FdRiGTcpvMdyR2Lm7DBcCgwhfUoyBINeaZRgNzgypiJmtFv1wAArpxhE0hQtnIZumhlp659heunquffTXJTDq9sSaFEqbVPRoLAiQcFRxcfRFJ3mMqrf9je/4MYKCPp9sAp6e0XpbaVA62igu0CCZL/1YH07TBV4Aqh4sGe3F7YeJU/lraegflSjQzQsjRIr+ATpGT/WH0WucGMngf1Da2ak+RN6Qt7c/JtH40BdPd/3edASpbVYGpx0Fytu3z0CKxT7uyHU6d5iM7iVEo3nJtoDTpU9VIb2zWlsM1IyR/saV1v8uhcrMZkUxHo1XUgbTbSS87uc1vEvoKFf+Q5u+HgWySvh8+yhtzB5e60M4mYauSDORT9e/DMWphjV9xxiCrRg4ItV0BTPG9a+QLsejIQm2fk+DDPyNCwOMO1Lm27kwekajfem4RM3VZxMKZy1WzbyiLwSSu5D8+4XLUwauRDQgLfrea0jGES0v6XVHnM13oV690HTNeRT8a6ayu9/vWO6kz3XoJhSyjocShfZYRmtXYNF2Br0v8uspTt5MeuN0cxWh4Ooutka0/1xZ02WkZmFr4YDgaD+TUml2iYjtLjpmPFRHaK8BaGXS1mkRSmPsGS77YEZ0VK/im+5H2xxugAQGClmLBfBmo7VJ1Wa5OqSxQOgc4QbJwwljGYjeW9VhobZPUxeYq0m9EFcfMI9ItKyLPDt4WNI+6yI+RAXFk5ISn3RU+lId4iJLvx5eJjMw9jUvkCvgsYTMS6w6hYPLjWUu8sUsFUrVTxRS7e2IsuTdRgHzGAsYQEXOWhX7nGgUS7ZkD2Z1kJ0wMw914UKk/94IDHhpx/hwHeQimo/dhYHj8JTAGcyN02HM6HhF7f71EkOwTITe/JPS80ZV0IganwUQ
 bWmLmTCC
 vKXfVr/5UKnfwAWVOdycxSvgkwAe3v+Bf1PgusUO8e9JzaDl2JtWAkUiGLK/BGqjzoaSmsE1W1J4wzg1lK/w6pAVT4aWk3pxzkFh7BS9PMtEhYPQAY6XYA3NN/jhho9Oo9rp+14yU9NyAoA6Yif3zFDLIQFXT3GEPvBDhL2cXQb2D+U8ukqBTu9FhfKOHV4zmwq8NE0bZB2Pk7ctV1XZClQ2hs6YQQ+PfDggI2o5M9q5Xk7/vqPex5yJWlLPBBpJaA5D9XBhv/Lk/Se5rKDoucp5vwlpFihZ3F8Sgl0XVm0FkYAlAUrlCCTkCxMkFngqAvc6tuIAzrdv/UVX1C85KxW1a6YFEPZ+ClyBr4b5+bKSJlRFTMLGmn80Rhg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 02, 2026 at 07:51:09PM +0200, Pavol Sakac wrote:
> +	/*
> +	 * Defer reserved_regions and type - both are read only on
> +	 * VFIO/iommufd ioctl paths, so let the populate callbacks
> +	 * materialise them on demand.
> +	 *
> +	 * KERNFS_LAZY MUST be set before kobject_create_and_add("devices"),
> +	 * which calls kernfs_inc_rev() on this kobject's directory and
> +	 * would otherwise leave a stale negative dentry cached for a
> +	 * missing reserved_regions/type child.  WARN_ON because
> +	 * iommu_group_alloc() controls all group kobjects directly.
> +	 */
> +	WARN_ON(kernfs_set_lazy(group->kobj.sd));

You just crashed the kernel, that's not nice :(

>  	group->devices_kobj = kobject_create_and_add("devices", &group->kobj);
>  	if (!group->devices_kobj) {
>  		kobject_put(&group->kobj); /* triggers .release & free */
> @@ -1091,19 +1210,6 @@ struct iommu_group *iommu_group_alloc(void)
>  	 */
>  	kobject_put(&group->kobj);
>  
> -	ret = iommu_group_create_file(group,
> -				      &iommu_group_attr_reserved_regions);
> -	if (ret) {
> -		kobject_put(group->devices_kobj);
> -		return ERR_PTR(ret);
> -	}
> -
> -	ret = iommu_group_create_file(group, &iommu_group_attr_type);
> -	if (ret) {
> -		kobject_put(group->devices_kobj);
> -		return ERR_PTR(ret);
> -	}

Why isn't the driver core creating these properly on its own today?
These calls should not have to be done.  Also, what's up with the "raw"
kobject?  That's not ok, this is circumventing the driver core in a way
that is not going to work out at all (as you are finding here...)

thanks,

greg k-h

