Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31FA3CD8CA4
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 15:12:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D9C36B0093; Tue,  9 Jun 2026 11:12:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B1086B0095; Tue,  9 Jun 2026 11:12:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C7536B0096; Tue,  9 Jun 2026 11:12:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6DB386B0093
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 11:12:24 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 39B351C16C9
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:12:24 +0000 (UTC)
X-FDA: 84860715408.01.AFC5CA3
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5234114000F
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:12:22 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=gUnncuLA;
	spf=pass (imf26.hostedemail.com: domain of praan@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781017942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w6VKUC1VUaetCGs5JJDLFKtb8dO63YSohjJ7JwyYLsY=;
	b=F31AACZoFV7Cxj377KMp+bT/FOIiRAH6PS5sFUeWjcIFUnMTP4hDFTOm0Q/iYZYsN+Cayu
	oER95Y4tw3cakOviT8J9kytCRzbfZEBfDh5qQJipB0ZuflvEmsfsx54asEM+ATesF2DVGX
	kCE1X5Miq+yfhYs2urrj4tlPc4Hrpn4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=gUnncuLA;
	spf=pass (imf26.hostedemail.com: domain of praan@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781017942;
	b=nHDPbbR4P+jwxiAN/szgJca1TL4UrcHidEN3+qgT/MIEwj5i3fLFRAYyufkiCpGydPtpLw
	UHxJHiNFDScCpHqH0Dxs+81+h1gY6sT7uWEOD4Y175+HniYe1ZM+K8sOkjTOUHHzhE1wj0
	4r+cUY4eKCrDlkZDRb7M/nXpnRPEfTo=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2bf2d865383so465355ad.1
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 08:12:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781017941; x=1781622741; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=w6VKUC1VUaetCGs5JJDLFKtb8dO63YSohjJ7JwyYLsY=;
        b=gUnncuLAkzD3uBIqp0eYMLYT4bPs0KzsRoCdsWbqSrt3P5X5rei2V34MZXsvgadgsD
         Zd0kuXjM+HDLi7Pj1gt5/1xhnu0GTw3qnm1Kyn6fFRBANZr3ivb22JthdVdIjTa0qp5a
         A4gE90ghHLmUOXjo/LXJrP8jX+qdvUZfPe3QG3/zWvkCkYJgbheLIdxkDnqn/ve2RXXo
         LmFYx+imfC/1b+nmCZLn88hOHURfb8Gg/iQa7K1BSSAiebvqQzdBpJpaZaZGMgD2Vcx/
         77ct6Fdb/Ulu3xVKQtrbmwwkSq9btwJV6cNa9a0m/D1pgH2xM2NBVoXgmVx+P3Bsm6ow
         8yeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781017941; x=1781622741;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w6VKUC1VUaetCGs5JJDLFKtb8dO63YSohjJ7JwyYLsY=;
        b=NxgYzsqYrh8H5Jk8yjAzSoI5dqB1sVzOSyvosf4HKIvjsHTqEteWXOjzRZ1siFa0rg
         M5CX82We3zI8YP97aK1PNpgE2n2u/JjMwG9HzYczr1Uf2M9TOFzylw8R35w35ifbcdP+
         da+qt70zedh5qz56qfviWUxQfb/RdWMM4I2q51XhSkeNYtT+a0yMjxYTXkc1jZwiMBng
         ncWgQ2RiYIXjiyoHa4sNuem34R7Yo82+8Wk41kArzELE8XopMKFiXxWYmE4MYsZSdk5j
         Vv6amc+hdxYeTOdh5VYvFeJR/SZUmWr2UOGrciP+akUniUnActs5DYmOgGt9fqY3c1V3
         6wlA==
X-Forwarded-Encrypted: i=1; AFNElJ8e0vN86dZIXCKt/psXH5kpQnhYTKcppoMEZFFOw0oRpQeAytmlIkBVB/o6gXYKAxyt5tXNuiX9Gw==@kvack.org
X-Gm-Message-State: AOJu0YzR5W9mk0C3o7rvBQx5Lpe3VkiDwvCKC/KfukK1upVQKghE7QYe
	dMQByfA/zkdxfToIFhu+MlDu/ut7IpLu/8W0lrUsqiyJVT4mukYKVmPzj4k8FEdovA==
X-Gm-Gg: Acq92OGs7BbHfm+lZLSvnOmH8K3+5fQ7cHJyU3qR7TDdai2DiHqwbFtTFBtSSUAHEZX
	pEuwpUwMN1vVMqVL69xa9M8Yw2GSNER7hcrU4dmYc23zl6uEvnYBtSkNt/t+P2oZS4FN/mTZnZi
	mVGssj6ZNrIUwrx4fHnqZAkoP4AXk/k5Q0T/nzCp74MudnodbunhQz5ImAm14AjS1VVYLengMzA
	WfbxRdcasCpCChke78GHZf1rG+kOQF+buhL3kuZKLy6QOegTlPVz3NDASethn8irX3i5sGw66Ku
	8x8ybgtyS3XXVOpy3F/ehVGiN6BEFR6VcVyae0QoZy1q4ah/SovkE/0lB4adA67lIcS1VqympwJ
	DRrqqf6DI9fDNjOypaHa5OEDitAi5xBhfymwTi1U16ISC5uEueH+/6S882vWsKGoCEd1CZcNPAT
	/SR05EDFYJn8D/F/ZasXjx+S0StIzQSSOLcLgY3UdLZxb9Bdj16NzSXZw2bI8726zptv3qwTo=
X-Received: by 2002:a17:903:19ed:b0:2bf:3579:cdaa with SMTP id d9443c01a7336-2c1eb942782mr7408845ad.10.1781017940616;
        Tue, 09 Jun 2026 08:12:20 -0700 (PDT)
Received: from google.com (199.255.142.34.bc.googleusercontent.com. [34.142.255.199])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c16629d40asm208599735ad.64.2026.06.09.08.12.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 08:12:20 -0700 (PDT)
Date: Tue, 9 Jun 2026 15:12:11 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: David Matlack <dmatlack@google.com>, kexec@lists.infradead.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org,
	Adithya Jayachandran <ajayachandra@nvidia.com>,
	Alexander Graf <graf@amazon.com>,
	Alex Williamson <alex@shazbot.org>,
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>,
	Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>,
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>,
	Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v6 08/12] PCI: liveupdate: Inherit ACS flags in incoming
 preserved devices
Message-ID: <aigtS3UDdhUGp3m0@google.com>
References: <20260522202410.3104264-1-dmatlack@google.com>
 <20260522202410.3104264-9-dmatlack@google.com>
 <aiXWmR-ettxin4LC@google.com>
 <aiaeOVomxQZhoM3K@google.com>
 <20260608181640.GO1962447@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260608181640.GO1962447@nvidia.com>
X-Rspamd-Queue-Id: 5234114000F
X-Stat-Signature: 6u7my6xoqqah5b9wib31q8u1cywr15mp
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781017942-278049
X-HE-Meta: U2FsdGVkX19bPM9k3Wf5ctMTqozZGUdvrBCM8yyRpeBaf5KlGKGjuaUNEDvaDf3eGWsS8Olq/A+Q+nxU+mZm0kAOFiLjb4jAlpcSWgXUAzo4uE5TU4c4a3rDPO1JW/DZKa8O/RPYYRhKfVaxXflWLRYd8Ty7qJEzFLltEPffidVztOSq/dxkrzVlp6vIJx3EAPnUojcq1fiHIUi7FVULiY/WQUvPqKr5nwUm/Gqr6x6xqAyT6t2FQYlQ8GGozx5tjAIp4ihIWUUl9VeLi06lZxmnsoqAr3vk/YSLMPCsKpKF5ir3Ve4aGdRrKlu7ZKDdwGYeeknsi2/CkfP7eRyfmnreULy7a/zpo+poh1CECz3bzwEUKHVr3810O+pMtCObJFtazfLUu1tHrbt+ywYJ2oTfMoEOr3VCwLPhwmQFGOrV+lpe8WcLwwLm5O72LUd6wAOM0jV/gjJgzojYxr7JvIeldaNEm3dfsTGPm0lJHdaNo+8JBlYVkPc3JlpzILdPhfqbt4bFVfUVai0V8/lOgCbksbAaaVIgbO+rdBoGBV3ydeZTJ9IHWKEL0dPV/NJReFeiX8I29uP20zgqqfChl1Yfzvd+BWS6jDWN97vodddfS0lwzz5bIBcFa/nuq3X1ALyyPPPNz+/kgZqpLDgo0RkaAiRsl9zVo/7BisX/FbnJ7vmxd/lrDtkbeVu0FxdTlKH1NDp0JQLTsZ4YiYuGZbWLRJ/QyyNF5Dw5Xk/UBpyHxEbbdEDQkTX4kjxEpHOrsIPx5vkuTFO983M0wqKnxZatV5OKSykEXgWF45//v4y+w/4WzG/Ohxrlvp+I92wVuy5FtJs2mQ4Vo5UC8RkfgEq84vC9XCZMkpzGKz7OFpNT++vR9WsXCIwuRHf9SRKMVqGNI9BOCYlp0WJjv4+PRTScqZp7QHN4YPANZPQu4NdNEI1BDQ+HqViCjKYH6rLxaf777IuEzMoHoKPsoVR
 p6Hf17K6
 lt6UeviSExFXtELfmYtJQLIJk+oP0KTggfIE2D5N76C5XLJqUb83osFPlSQ+ZJSdGqBVx4DEv/pS1/fcx2TaIHqY0RxG9/SnUCENKWhP3T4nZXWcDuQyCBXh1GymMzSsb0lmym03h6jTq7bvCBagnlZttTRsyHMDqvZI1H/dWWypHJyXBcKHVooqAZ27b0dSVLzYB+IijLysQCosuqd2sxJBBV/x9JYuhRBYvE+zY8sUnMm119yE2YcQXKPSsWCBNltt5R7uZXndBncff8hgq7FUdB7x0JTuLTtB93tS23L8QiKHs+FagIV7HjpLpIPppUKtOWYwzdKdN6Be275+fKddZ8J3sPP247NRc+YswORA+g8k3nA4xY5l9HBugqWyEZGC3SBQIrxgHUAYCweQkA0EcxI+lZtlik55tDtyudwiy+fqS1nP01CnaXY7DuX6Y3zVf0+f56QmZgAQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 03:16:40PM -0300, Jason Gunthorpe wrote:
> On Mon, Jun 08, 2026 at 10:49:29AM +0000, Pranjal Shrivastava wrote:
> 
> > My point was that a FW exploit can meddle with the bitfields of the
> > ACS_CTRL to spoof and mis-report the ACS flags.
> 
> Devices can also ignore the ACS flags. I don't think this is an area
> where we should be worrying about devices being actively hostile.

I'm wondering what happens if we preserve IOMMU groups across a kexec,
but a switch's ACS capability is dropped or the ACS_RR bit gets cleared?
The incoming kernel assumes that it's the same ACS cap from the old one

Now, the incoming kernel restores the groups assuming they're still 
isolated, but the hardware no longer enforces it, silently allowing DMAs
& breaking isolation? 

Thanks,
Praan

