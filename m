Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B328CCFA02
	for <linux-mm@archiver.kernel.org>; Sun,  2 Nov 2025 17:17:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8CC98E0005; Sun,  2 Nov 2025 12:17:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D63278E0002; Sun,  2 Nov 2025 12:17:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C793F8E0005; Sun,  2 Nov 2025 12:17:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B2F208E0002
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 12:17:00 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 35DD04AB2A
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 17:17:00 +0000 (UTC)
X-FDA: 84066322200.24.13F6F0B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5AB8A180003
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 17:16:57 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="V03Vo1/d";
	spf=pass (imf24.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762103817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zNOgYikCqXVbzPcBHmhLjA8uKoTgMccbt06bdanviJQ=;
	b=vbRGMlggyKq59QDQSDgSG1T9bBsTgKjoVjMd7nJdLnSaDi1bEDv4PWoqnnNjAJqcgd1Aas
	JTPpg1dnm1VZbX0mh9yO/XkLONPqq6GaMTPKVqgP9eaf0WQp152p8KvSWxqN27r3XpNn+8
	77ZjnDp6XDSwlZbzjfPhepgZRqiCb0w=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="V03Vo1/d";
	spf=pass (imf24.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762103817; a=rsa-sha256;
	cv=none;
	b=Z3jZf/skT3YoxhN5+7FbuLSGqHDOWt8fOAENDbYdrzj9Azq9Vw9awQXP36eHZCCLNwxPH8
	ezKBJzIlOzB7WoJYjSCniRbMVqTJ5RU2W9OUhEmLq9H5puYkbThx7FMwKVpNIOAKgTkB0J
	HF1d+Cfj60Xk+wdtkBfQFUchCOYQrsQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 22C0A4419F;
	Sun,  2 Nov 2025 17:16:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BFA9C4CEFB;
	Sun,  2 Nov 2025 17:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762103816;
	bh=6J4RYbNE7xRGZGzVZmTnvJ17pocxZEQO9XjI2jSDlH8=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=V03Vo1/dFUnMI+5BbeSpvmGBru6UCgp+YG0p5jilNDNsgR6zk8AYE4Sblf2BQ/bmA
	 cwy3eyQaMO+EuVUbooSLshXM976UQjawj+Ks6mqjWBaUB+CAlbyIgVxwCdCMkAKxYp
	 /HBNlc5NLl4m/uj0f4TeVd72fT8gO0tmDfib3DZ5YBd3Om1uOIeawLXje9HbXc620U
	 kqnPHWsvnXiUA91+P8VXbtE0lge0OGtdlmuyh0rZHlqktQeWsNfJZUAXjNiD8QvVOy
	 YdufGRB2UCgVyoaJiWQvRy3FWCM4jD4Z+pQvl+iQSpogn0oQ+cs9QrXkDLFTviP1Ot
	 /EgcUFdL+Re7Q==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.phl.internal (Postfix) with ESMTP id 0463EF40066;
	Sun,  2 Nov 2025 12:16:53 -0500 (EST)
Received: from phl-imap-08 ([10.202.2.84])
  by phl-compute-04.internal (MEProxy); Sun, 02 Nov 2025 12:16:54 -0500
X-ME-Sender: <xms:BZIHaYuDYmBjtG7IxUKfvEjba2RKlTl6PZHc9IqGhy7j_jG9gMTxwg>
    <xme:BZIHaQS40zUxhPV_fDp3AqrkIE7bV3DYAqxEVG9VTMoSNhTnkeM8e4NmeRVOn9bh6
    C0ttUUKruiqlA23NausYNPjUtH2T_MmINiNR9Ge9obYEtgqTuQOXog>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddujeehkeefucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedfnfgvohhn
    ucftohhmrghnohhvshhkhidfuceolhgvohhnsehkvghrnhgvlhdrohhrgheqnecuggftrf
    grthhtvghrnhepjeevffelgfelvdfgvedvteelhefhvdffheegffekveelieevfeejteei
    leeuuedvnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomh
    eplhgvohhnodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduvdeftdehfeel
    keegqddvjeejleejjedvkedqlhgvohhnpeepkhgvrhhnvghlrdhorhhgsehlvghonhdrnh
    hupdhnsggprhgtphhtthhopeefgedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohep
    jhhorhhoseeksgihthgvshdrohhrghdprhgtphhtthhopegthhhrihhsthhirghnrdhkoh
    gvnhhighesrghmugdrtghomhdprhgtphhtthhopehrohgsihhnrdhmuhhrphhhhiesrghr
    mhdrtghomhdprhgtphhtthhopehlohhgrghnghesuggvlhhtrghtvggvrdgtohhmpdhrtg
    hpthhtohepsghhvghlghgrrghssehgohhoghhlvgdrtghomhdprhgtphhtthhopehkvghv
    ihhnrdhtihgrnhesihhnthgvlhdrtghomhdprhgtphhtthhopehvihhvvghkrdhkrghsih
    hrvgguugihsehinhhtvghlrdgtohhmpdhrtghpthhtoheprgigsghovgeskhgvrhhnvghl
    rdgukhdprhgtphhtthhopehguhhsthgrvhhorghrsheskhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:BZIHaR-tvJBh8-mgAOYUGdkn8s8kLulP-EWIIyk8S5GtuaFeBTZsdA>
    <xmx:BZIHaaYTJL4Te_4Fw1GF_JCGz90x2YjX8VH8icEpsxwlFdW8L1BOyw>
    <xmx:BZIHafTp-dL-74eqOB1FVVTeUq8Z5EEatKsfbiYGKBXPZYMUUjiokA>
    <xmx:BZIHaZkRSqwn6yV6mfCDZEPERqhJEoAAI8EBR8iho6RnbORQMwbAEA>
    <xmx:BZIHabI8zmEQV1j8o_hMlt7NB4IWeKKppSR-0yCNW9noFRUXSASJvZ-B>
Feedback-ID: i927946fb:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id AD0F62CE0067; Sun,  2 Nov 2025 12:16:53 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: A48325OsNhe3
Date: Sun, 02 Nov 2025 19:16:34 +0200
From: "Leon Romanovsky" <leon@kernel.org>
To: "Alex Williamson" <alex@shazbot.org>
Cc: "Bjorn Helgaas" <bhelgaas@google.com>,
 "Logan Gunthorpe" <logang@deltatee.com>, "Jens Axboe" <axboe@kernel.dk>,
 "Robin Murphy" <robin.murphy@arm.com>, "Joerg Roedel" <joro@8bytes.org>,
 "Will Deacon" <will@kernel.org>,
 "Marek Szyprowski" <m.szyprowski@samsung.com>,
 "Jason Gunthorpe" <jgg@ziepe.ca>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "Jonathan Corbet" <corbet@lwn.net>,
 "Sumit Semwal" <sumit.semwal@linaro.org>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 "Alex Williamson" <alex.williamson@redhat.com>,
 "Kees Cook" <kees@kernel.org>,
 "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 "Ankit Agrawal" <ankita@nvidia.com>, "Yishai Hadas" <yishaih@nvidia.com>,
 "Shameer Kolothum" <skolothumtho@nvidia.com>,
 "Kevin Tian" <kevin.tian@intel.com>,
 "Krishnakant Jaju" <kjaju@nvidia.com>, "Matt Ochs" <mochs@nvidia.com>,
 linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, iommu@lists.linux.dev, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-media@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
 kvm@vger.kernel.org, linux-hardening@vger.kernel.org,
 "Vivek Kasireddy" <vivek.kasireddy@intel.com>
Message-Id: <d757cbcb-866a-4af4-b4fd-0ba27f706e74@app.fastmail.com>
In-Reply-To: <20251102101158.6d2c36c6@shazbot.org>
References: <20251102-dmabuf-vfio-v6-0-d773cff0db9f@nvidia.com>
 <20251102-dmabuf-vfio-v6-10-d773cff0db9f@nvidia.com>
 <20251102080137.209aa567@shazbot.org> <20251102151253.GA50752@unreal>
 <20251102101158.6d2c36c6@shazbot.org>
Subject: Re: [PATCH v6 10/11] vfio/pci: Add dma-buf export support for MMIO regions
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5AB8A180003
X-Stat-Signature: mzzbi55zg31sr9g48mansgkhcrsukhm8
X-Rspam-User: 
X-HE-Tag: 1762103817-14282
X-HE-Meta: U2FsdGVkX19A3IGOjJvCH/7esZScsDsYxGOFDwDzme6iBkr6ojZojAn6U91dcJAzgAo6KfxFtXH2hBEE/v4+LdRI5hBblQUOFH1mBXrMQ2oEci4EWVLFXw6Qbkx+hzmdWfWaUzCEJTG1O4MoUFCgXKqyfCMaN7G+EbuWlUJYBhzdpxRkQavIZkrrGE2e9AqPML+NmcEfTXS1Ht8Pe+YDUcJUbBSB9utI5AWr86w3IL7vonNT8Y39OcS9ix+XtGW23by6pzhsvqnXXGGgrOoX7bhEoXWNwW5pTWBbRqhfq5MXGlr4nXxw4r8BKT4LovPhkFeGl9FiPKtXXUFf1qvKh9WCRII7uTTaFr4/VpTBLoQg5B+dv4+e+eKQZGSfe0UvHTNUtB+IZbyBbuTQo0iAuc+nXv4xRe3mUO3eh5TTU4bdOzWZ5tnaan1+LCB1faOoiI0Ts+8lvVsZYKselLM91ppZ+XifFRz81tN1WPh0usS+4CLjTG4PU4gyzpkY2Y+zKJ462mM04rQbw/sMZUVG6vplPSZoO9J/zW8KIyfCLCJqBxrqg8eQvdRK8E87ymQD91aRZEXl6Uo3Zzq3RqrRA+2yvdj8LFym0q3G1LsVFxPgo/LUg9IrugxTxbdFu/pHinNzp6tDssghTm3fhXXKKz4bgsuh9i/q1uHreH+X6LnogpQdlAtPelN6n8BP2/V4DVP0amTSJslQ4SiM9urJdPTpZ4fH2Y6teWcf8+VY2vrtqmR1KgI023ipNZDS2Un7CXU9MhVYjTA+f1PjjVWpq6ZWezffm4ZoUi4bhJ4D0yHTuez7QBE6v0vLksHBOSXK4OF/enjHc+KaAfOsCp7nWB/e20aGQPlcuNTUJLhDHM2arISKzQ/oS0kleeDOf8DJ2yUfmd1NCPxLAL6azRZ/vZxyKVKknXXAV+xEz6WIbEKcj6NNEqQSDUek+ErOOZQaFmFUrNWKAzPiwBjiCdh
 EVCqp9HS
 ut4Ion4e2RW0Nmui0BAs/+cvZ/xAzEnXDOawRmlLuBFKWyQWp/PV4Z5+qMB/CDQ8oMWht3C5UFtecu59iH6d54VI2xMLzwM8Bun0qjmB6ANe7fPUEcoYSSA/l4SSyUnY65+7KhI+71sp+htQWyYMAtur965LGGibIRy0f2sEzOc/areTQp5xwpVgtTcbe8+BDlbv86AvLjE8honQxOrFcpYAJajwsJvSb0E32
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On Sun, Nov 2, 2025, at 19:11, Alex Williamson wrote:
> On Sun, 2 Nov 2025 17:12:53 +0200
> Leon Romanovsky <leon@kernel.org> wrote:
>> On Sun, Nov 02, 2025 at 08:01:37AM -0700, Alex Williamson wrote: 
>> > We don't need the separate loop or flag, and adding it breaks the
>> > existing reverse list walk.  Thanks,  
>> 
>> Do you want me to send v7? I have a feeling that v6 is good to be merged.
>
> Let's hold off, if this ends up being the only fixup I can roll it in.
> Thanks,

Thanks 

>
> Alex
> 
>> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
>> index 24204893e221..51a3bcc26f8b 100644
>> --- a/drivers/vfio/pci/vfio_pci_core.c
>> +++ b/drivers/vfio/pci/vfio_pci_core.c
>> @@ -2403,7 +2403,6 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
>>                                       struct iommufd_ctx *iommufd_ctx)
>>  {
>>         struct vfio_pci_core_device *vdev;
>> -       bool restore_revoke = false;
>>         struct pci_dev *pdev;
>>         int ret;
>>  
>> @@ -2473,7 +2472,6 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
>>                 }
>>  
>>                 vfio_pci_dma_buf_move(vdev, true);
>> -               restore_revoke = true;
>>                 vfio_pci_zap_bars(vdev);
>>         }
>>  
>> @@ -2501,15 +2499,12 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
>>                                struct vfio_pci_core_device, vdev.dev_set_list);
>>  
>>  err_undo:
>> -       if (restore_revoke) {
>> -               list_for_each_entry(vdev, &dev_set->device_list, vdev.dev_set_list)
>> -                       if (__vfio_pci_memory_enabled(vdev))
>> -                               vfio_pci_dma_buf_move(vdev, false);
>> -       }
>> -
>>         list_for_each_entry_from_reverse(vdev, &dev_set->device_list,
>> -                                        vdev.dev_set_list)
>> +                                        vdev.dev_set_list) {
>> +               if (__vfio_pci_memory_enabled(vdev))
>> +                       vfio_pci_dma_buf_move(vdev, false);
>>                 up_write(&vdev->memory_lock);
>> +       }
>>  
>>         list_for_each_entry(vdev, &dev_set->device_list, vdev.dev_set_list)
>>                 pm_runtime_put(&vdev->pdev->dev);
>> 
>> 
>> > 
>> > Alex
>> >   
>>

