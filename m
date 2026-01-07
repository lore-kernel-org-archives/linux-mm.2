Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C774D0D170
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 20:06:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 616DE6B0088; Wed,  7 Jan 2026 15:06:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D8096B0092; Wed,  7 Jan 2026 15:06:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5007E6B0093; Wed,  7 Jan 2026 15:06:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 413EC6B0088
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 15:06:13 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9E065C1F99
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 20:06:12 +0000 (UTC)
X-FDA: 84306249384.21.140DC0A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id E101C160006
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 20:06:10 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=NLgidEHi;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767816371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EwMlOW1qKxxvV5bc1w16z1ObHGTogQbAMXT6/ogSqck=;
	b=nqh5loigN1qCPGLGTx4Qbiu7EUOvOK3u6z/nrOwTSY07gAwdB8AvP5rra1mTAGyrUmoHJs
	IN46YaEqLsphxzTTQ1QNE6L9btnCs+46kH7Oe0u9lB8NNMGP8CAh/hN51/QunvOLcMlEb+
	8ZkMdsrj5t77xLRf1dVTBBqGhbYIwSA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=NLgidEHi;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767816371; a=rsa-sha256;
	cv=none;
	b=5mq9Yi/aCAXsgLJZOrXI0fFcKLHiaROmSHX9t/c7pTzvx54M0/ctrSGm/j2EauJz2DhHY/
	2ZbjjuSrZ8C31CVaL++U6PBVoUvZnuUMvZ6UuOO1lPN2K/cDQXPM8lC3m+ORVj6e0hKr6F
	hrc2GLRDM0lh620t2m+Kk8u5lZd4sHo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1714B6001A;
	Wed,  7 Jan 2026 20:06:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 247ACC4CEF1;
	Wed,  7 Jan 2026 20:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767816369;
	bh=9PIBpB6BT7c2Nly9VamIDqbclUvTqGBanLECbpOqsZU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=NLgidEHia+ljn45TqKKiaI1PqrlkMihQySUaXwHidlJUJPZNGsTIZWluKWXqqW0JD
	 pyxhlCbST+uZv3N70zgjUhz9hGOVY0eKuj6ZXXiv5xVYcKWEmySRYVNQZVYzawb7RK
	 0/qFXzfy9W/GNVAvifH3407hbK+RS4rtYOs+DkSg=
Date: Wed, 7 Jan 2026 12:06:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jordan Niethe <jniethe@nvidia.com>
Cc: linux-mm@kvack.org, balbirs@nvidia.com, matthew.brost@intel.com,
 linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
 david@redhat.com, ziy@nvidia.com, apopple@nvidia.com,
 lorenzo.stoakes@oracle.com, lyude@redhat.com, dakr@kernel.org,
 airlied@gmail.com, simona@ffwll.ch, rcampbell@nvidia.com,
 mpenttil@redhat.com, jgg@nvidia.com, willy@infradead.org,
 linuxppc-dev@lists.ozlabs.org, intel-xe@lists.freedesktop.org,
 jgg@ziepe.ca, Felix.Kuehling@amd.com
Subject: Re: [PATCH v2 00/11] Remove device private pages from physical
 address space
Message-Id: <20260107120608.5ccd2cc7e4227d2e80028bd9@linux-foundation.org>
In-Reply-To: <20260107091823.68974-1-jniethe@nvidia.com>
References: <20260107091823.68974-1-jniethe@nvidia.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E101C160006
X-Stat-Signature: 96sqgog979ofpj68ti3qcqk9d96bsu5g
X-Rspam-User: 
X-HE-Tag: 1767816370-194421
X-HE-Meta: U2FsdGVkX1+/s4XEw/BJ0TWZbYhAR31DGKJmjWIyAVX5C075veJDB8yFMRGVVeT3hMj5f7GG47aXsyFMMa/MhlA+jdljg3gcGKF0p2iq+a1TTpCE1b4791T8n2//XgTRWXCaGs6XvXJ66C7yTD2qAYkH9bItEHyPU+mJtoYz44tj0/om3WKigSKNX1MOK7x5P3JfvBryKB3mvT/P4eNMB1SkTHCuhWBhlJ1b9wpzQpAhx3b3aTfUZGDz2lmA8tIufDW7kIqityE6ShxU5CiMnlgrBE80C+LfLdE6OAWQaM177WTqdoM9sZ5HfwcQi88m9OCI7+RzFwJrfbYigi6c+Y296Wq/JHFycNmFXi75IIGB0l8t+qthLWA0CW1PSw5wKfAynKYe4JutByCRSceDc7C18tS7n2qbU5CEb+G7D6wOcuEp1iamhv0TX/xnhpFVTxXqdBk6TnWhY/v51RlTfSWDyMC4+tzRqgGkRb23gy/uCIVFlCBTzDQ448KPy2dKCYr5eqijANVt12KD2A8Nhh3Tm+Jw5KUudVVBLsanmgkn/USw9wYBv6/vo43SdlFFSAdRRAU9+aHJ36XxANLqGM1y8sgFogikgxkdccsJzVLkpUyPlhVNkuan0Qsc1oMtIi7yz9bzafC2DnPljCwRyAxEAb8Y53cldd7gwVL+Es3P5rk8MavSH9PZo8/XGeTlDGmu/qaq0CL6kscDZtPOlYeAn3IKmFnR1MGKhSgotky3fMrHMPL+oT45DhxRrYEwunn4I8NRP/txiuO70nT6a8Se3vfYjob2AL7XYPgleUpsKWc65MqQ4C63XKEflKhwj5lnROcEqaTa1z6F9kPC1hWvTFyZFcfJu3PDkv93faU5kgm98Nu9fk3BmzD/xDEZGO4EREALAA8xtlco94d8CFaF25y1IF3XhWobZyL2IVfbWu+7K+tbenzobWFS+07A1OD/FfxnO9gqDBFfDS3
 hLbW6Vez
 Ub3hZr0h/v0uqyozXzZIFXtZ6DwUaD8nA/77g52xHdS8UzLn4g0iPQ7aoovlbgPVsUd6CezAtO1ySjG6GMMX91BNXLNGSvKGqzNskT0lenvwrMgdE3jAOdh6NtCxnxOvKK/L1yIuiAZujlXJ8Qt+UtQ8cc14ubfqBIx/u1AIwbVmBctbz07qGxA8S9fTPdzDdkUlTo2mN3/aQP5OE5MpDLxnnSgslaEaCn4wartzh8c6OhVIna/Y6yREFi2XzoPx13/7oTLMr3s+8xwh/46qZT/5TeA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  7 Jan 2026 20:18:12 +1100 Jordan Niethe <jniethe@nvidia.com> wrote:

> Today, when creating these device private struct pages, the first step
> is to use request_free_mem_region() to get a range of physical address
> space large enough to represent the devices memory. This allocated
> physical address range is then remapped as device private memory using
> memremap_pages.

Welcome to Linux MM.  That's a heck of an opening salvo ;)

> Needing allocation of physical address space has some problems:
> 
>   1) There may be insufficient physical address space to represent the
>      device memory. KASLR reducing the physical address space and VM
>      configurations with limited physical address space increase the
>      likelihood of hitting this especially as device memory increases. This
>      has been observed to prevent device private from being initialized.  
> 
>   2) Attempting to add the device private pages to the linear map at
>      addresses beyond the actual physical memory causes issues on
>      architectures like aarch64  - meaning the feature does not work there [0].

Can you better help us understand the seriousness of these problems? 
How much are our users really hurting from this?

> Seeking opinions on using the mpfns like this or if a new type would be
> preferred.

Whose opinions?  IOW, can you suggest who you'd like to see review this
work?

> 
> * NOTE: I will need help in testing the driver changes *
> 

Again, please name names ;)  I'm not afraid to prod.


I'm reluctant to add this to mm.git's development/testing branches at
this time.  Your advice on when you think we're ready for that step
would be valuable, thanks.



