Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B944BCD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 12:03:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0740D6B0088; Mon, 11 May 2026 08:03:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04CA26B00B7; Mon, 11 May 2026 08:03:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECB996B00C8; Mon, 11 May 2026 08:03:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DD0ED6B0088
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:03:11 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 86005160727
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:03:11 +0000 (UTC)
X-FDA: 84755003382.16.1268454
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id C32C11A0008
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:03:09 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n+IEkTUw;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778500989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K2cSGUbDM69QKpXi4xMkyw8dKrVy2xgJUWWL++iJgGY=;
	b=40ra5+rgH5Oy0kQyvSSaaokYraxlcT8WTtY6ngzeFjWoQhfChYAs2DzbqHwqV1AcKZ5pzq
	ar1PVza9K8jYoLQlJWV41zUTbVS9ZzwneA1+NnhhtxUAJteeGa0RgJvectNMFXeTQfqgCR
	1BmBZmMbffDK8yr0aUSVK1QI+WyHk/M=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n+IEkTUw;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778500989; a=rsa-sha256;
	cv=none;
	b=AvDxSXcyoIvcRu6D3fEumDK6I+S+LiSgpuuXQVeeK9F8764oF48PHl3GSOSCu7PWxi1fzG
	R/PgtHqsrVZdWhi/5lg1BV5XdXl5tiiUV3RgDNksGal8vs2Z6mDekYEgPYym6AMemJdT7M
	GxNLGcY5NtHj5anMRObKWXhKXeHwpV4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3BD3E600CB;
	Mon, 11 May 2026 12:03:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7824DC2BCB0;
	Mon, 11 May 2026 12:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778500988;
	bh=K2cSGUbDM69QKpXi4xMkyw8dKrVy2xgJUWWL++iJgGY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=n+IEkTUwP0wrUv05NL7Ahl0pQgaOk4dtvH2w53rhq/A9VvIHcerkiRTLBuJ/+R1Hn
	 UGy1flLZBOVXDPuzpRWtEmZPS9KmHZdEOkmiCLklhIDn0Yec9EJrIkGZlO2aQ5Vs1j
	 2X5DB9vZFWXJ/0pSfZ4cP5DykGm6AkRmmtbm42ErehGP/GZhSJnrlveZR2U6t2XZwa
	 Js6iFhuUIioZStL4AFzCmXBhTD2Yp+0CirI6kpvp8Ky11O+HmgIeYF79jTz43mfkXD
	 0whWKVi+qr8WzB6ZnBxPxgHHztHdIR8u6OaT8qSsAu3anCIDc5871c4kab6R+dHOva
	 dxlUbU3tH6WgQ==
Date: Mon, 11 May 2026 13:03:04 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, hughd@google.com, willy@infradead.org, 
	ziy@nvidia.com, david@kernel.org, lance.yang@linux.dev, 
	wangkefeng.wang@huawei.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Revert "tmpfs: don't enable large folios if not
 supported"
Message-ID: <agHFZkeeCx5OEAu-@lucifer>
References: <b2c7deee259a94b0d00a7c320d8d24d2c421f761.1776908112.git.baolin.wang@linux.alibaba.com>
 <afnKLEIaUd5A22ls@lucifer>
 <afnKpTo4cwh9LtPU@lucifer>
 <b496c241-006f-41ea-a398-0e0b7c7e8472@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b496c241-006f-41ea-a398-0e0b7c7e8472@linux.alibaba.com>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C32C11A0008
X-Stat-Signature: fi3d1ipgit6bh7s43r8zryci6rn5gu37
X-HE-Tag: 1778500989-299483
X-HE-Meta: U2FsdGVkX1/WLBIuSlMoKQsgDIKueJdoQAZP3/TTi5bWrooz5KT733eV79sqRCaT44o8zeIsUgksPU10D9M2sWt5CZDHJfjPBKxI6kjpO9vsY47prTA4/ATswPo1w07VIfoqNPOa4oKSQ7zjHK6hfRwHo/EsuPkBxZI3WEYxpbclR4CSf0keAXntgvR5GfQFUW0BrHJNSIsfSM81E0o+p+25aljXJp7n4BQJeaCUkQ8H7bR6bP9d0DGUdAWGhV0xpPJoaRma3ckrreWUtwOtrpraID7JDqf+x9IYs6E48loVGenGFMVUccsqMTfG2VwoyL6oVVerJSQz/lREACcnZFdXUUIjht70uScc+2ezO+xn3Ozcy0knCUuowAFu2jsGu/ZOu8L1qs4t6dOlf0F8ejxObxNJ93BSQ2clfP4owe0CyJ9pncgmAi4HTYJvvZXwgUGtyfXM8Z/vgwjcr/DmvFpcOBRTqyS7wzRlvsWvmK1E2VbHVo/liAseWrtoyVwJVZzGKhVoG9vSft3r3QcV0XWSe/URoh6L7lX66P1a84V6aYt1ASj98v6i5FWJxObkaOpo+yLCv6jSufD0j9US7NciQweCKGEtetCmnzbBiYUl3zahzaJZdPc1UoODRaz+fBV7HUPN7VKV6ELV462ivylcJr3jzMXnZR8rKTcKs2Yf5XnVxT5PfYx0FbDRi0I/3z9IwGEekCEN/EEuvoO809G/Q5EhG1VZ5rAeH/cKumewoYTaRXEgMg+0h0Y6WAV6WAbt1ZbViYumFDpUdx77hUeClyYyq39CYJU0oc9G311F4oLwgt6yhvJzqjw8NcDrKW/nAJ4JVUzlTFIKhqvcmq5IcvSM//Vq1OS4K+rd5n/4eiejImSAmqO7UKvk1XS0wOxTqqnRDMMYA8f3/e/efps3IqI1BkBEQZeOrVvs/aJGvzIplmd4vPkjFvN6uywzn7Y9O9yqcXWXZh37VGb
 6ycR8mTF
 p/4Qi9CFFKZ2gm2XOZmevtqT9IdaNijRyW/U+7RoECiVicpckfdPk7Gmba3abxETGAo3ZcbeWrP6DBVl8fFAaZ8+OfHXO1sCW5vjsmlU/k/HuGwDZrzLk216EWhOQjmc6qQFgx0KkIrlmOsE7VdmJCpxJJE+a+UbnMK8pAMnYUVsAKLjnO6H6pXMHx22/lRGOxFWJgOwSLHvS4I392s9KLvxji63XWeQuDZ3L1cfdNkdmbtbVUYWOKaq+njgONx8UghwXrYcOa5QSP1exuOhyenC1xw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 06, 2026 at 04:58:20PM +0800, Baolin Wang wrote:
>
>
> On 5/5/26 6:47 PM, Lorenzo Stoakes wrote:
> > On Tue, May 05, 2026 at 11:46:11AM +0100, Lorenzo Stoakes wrote:
> > > Acked-by: Lorenzo Stoakes <ljs@kernel.org>
> > >
> > > As David asked, should we have a Fixes tag? What about cc: stable?
>
> Sure. But this fix tag depends on the commit 665575cff098b, so the fixes tag
> should be:
>
> Fixes: 5a90c155defa ("tmpfs: don't enable large folios if not supported")
> Depends-on: 665575cff098b ("filemap: move prefaulting out of hot write
> path").

Oh is Depends-on a tag? Wasn't aware of it :>)

>
> I don't think we need to cc stable, as it doesn't appear to cause any
> serious issues currently.

Ack ok!

Cheers, Lorenzo

