Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6407CC79FB9
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 11:04:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FF7C6B0092; Wed,  9 Sep 2026 07:04:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B0A56B0093; Wed,  9 Sep 2026 07:04:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19F636B0095; Wed,  9 Sep 2026 07:04:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E40C06B0092
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 07:04:15 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3C0EC140197
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 11:04:15 +0000 (UTC)
X-FDA: 85193939670.05.B91FD85
Received: from mail-yx1-f44.google.com (mail-yx1-f44.google.com [74.125.224.44])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5AD3EC000B
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 11:04:13 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KPpOFQ54;
	spf=pass (imf28.hostedemail.com: domain of ckoenig.leichtzumerken@gmail.com designates 74.125.224.44 as permitted sender) smtp.mailfrom=ckoenig.leichtzumerken@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788951853;
	b=n4ekGX/cqGj4gS4CDOcZHF6AvReIdpt3jv51IYjZwjDjzooXyzPZrETx6RLtV6BN9kH0dj
	YMkJtXrp3GX0r9zyiftn1FuB/Mtd7W4496Jtn+YUVyl8Z03IaMVxGqZhH+9WUIcG88dqal
	je5pCBjNdnP1QTR8t5DH8wa+SlN0btI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KPpOFQ54;
	spf=pass (imf28.hostedemail.com: domain of ckoenig.leichtzumerken@gmail.com designates 74.125.224.44 as permitted sender) smtp.mailfrom=ckoenig.leichtzumerken@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788951853;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yu6XBq0/lXnZ7cWMkDYqnoMO3CTujhBWMHDaaEEIfu8=;
	b=FWGSZKPav3NwVYlMnHdJRZraU9ognN92Ym99+gOSX4ABhn/JVHM4eIIpvevCgSPyUmiflf
	++DhbXQyjWy0u61fOFgd0hmW4jqOBhC6kM9Zw7DmCaIVDb7aKRVOde8AtqOjCoCEb+gf7h
	LS/cmYDyBztaQkjVfG85AS3gvs205kw=
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-66fb2fa79f2so4102036d50.0
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 04:04:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788951852; x=1789556652; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=yu6XBq0/lXnZ7cWMkDYqnoMO3CTujhBWMHDaaEEIfu8=;
        b=KPpOFQ544w/haIKXcQEF/pDOCbwmnG5r4pAn3wKPt6/1L9XvKRGjv7kL4KqtkpRp4w
         pl/tjDedTjCmkEhgh9gIhQThWcbxrcPCf94E2kdnDOAuOEP7KzdLSVrAC8sYFpNE82vy
         LM7rolrlXK2GMCIsCrzBMGGxJH5bY62pQy8KuLgMd1cPI14E+/c5U6DuczDDWExLUmAS
         9WNs/F1MAbzVbYvzcM+CfA3smIRGij513QgBdxFYC+6OIEk2A+V+GoOSrCAZnuAAnqrj
         hOUzT0PA6kG2H3z5EsIR2oMeqXobDE0MpAfO4Z3YhNPGCfmgT/IxXjougfQVUu6ykYP+
         J4sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788951852; x=1789556652;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yu6XBq0/lXnZ7cWMkDYqnoMO3CTujhBWMHDaaEEIfu8=;
        b=cCZY8ONQHB+IcUyhOz6e2jX7UN7pFivKiKLhBwUTT/snmYqmcAx5kt28BQRjNQ4EFr
         JVX5/heCbLNt7wmEUPZoyiYxuhe1Jw4wp1ma++UhklUvHLK4ufhfqZF4qrhTnSI7Obhv
         2hddL5s+/ssKgJG5pbXEWS1eDEJlqptnvMxxscRijLMDbS02mZ8MlVXe22Gr5EtKwu8o
         ciBBEnSnB9bv9FqXdDbW7UwSGmP8+ffS524j9b0I72PCRO4W1ThbTdmUjYnrIAhwj86i
         yBvDPYBQP1rdT5QiOlx5cA3csQNkU9yay1+KKDKyHg5YgDEwqElmwroFt7u5OYhS+0kd
         LFhA==
X-Forwarded-Encrypted: i=1; AKwUvByQ0tu3FRzFe2ksLIukMC6PwvM/Ow3X8P5Dn7U/Lh7SVIfAcKNLD3QstPkHN/Cr0L2JBaOtQBtFhQ==@kvack.org
X-Gm-Message-State: AFuF++na1PBVojs9LxbupHtS5T0tWw0tB3W/sM7Aed7m9WZ6VN1YvkM3
	JtskAbNJYTPe+Q+x7FdpjT/0QmBbOcnO7DeqvlLKmhO5foTVK6z3ntSG
X-Gm-Gg: AYBFou0rwp++nxHgE5jTBCKX3ratK8d8QnmNZ9bSb+y3A9dd4XUHcQgoAmLYM6IxPcd
	i8YcsstqB+vCA4NyDfX1qwMY67J3dKSERHAAp6FBRYBvuOprpMOct1MzCVALPfvzCa/t8QS3Rhx
	uouNdxic7dbyXgdhiVihrYQ7e3dHq7QZ5QUn5C6LBEupNGzm0HXMIXVcF+qO3Dyfmv9MSZUf9az
	H48AYnGAli255JmIusf97g1EXGAhR90YiFlCGyU/vwlbG9cpyfOACHBUGJsOYpL3Bkfr5Xj0OWU
	GI8EqtC/OWx6WXUfuu33bVHuI/NMUPjSnpGlykZKM0ClhAu0wFikQQv2BPZAL0k+eQC01EkBDBa
	mq5oXPw7Mp5bM1R0j0djr/tO8eozZI9SYn0XIZ/Hl1X2yCYoU93n1m4iRaUzrEUadcTQLc8Pyd+
	ZXKbW3E94xEMxqUybxPCLV9iuRhLpaMw1xqDDpS5EU3bGwpGj5C91MwhN+xmWg8gVV3do6DUScZ
	T2wPLuauL8GezrQpId5KiT5dXH6
X-Received: by 2002:a05:690e:34f:b0:66d:2469:2518 with SMTP id 956f58d0204a3-66fb593f3e0mr8590219d50.13.1788951852153;
        Wed, 09 Sep 2026 04:04:12 -0700 (PDT)
Received: from [10.254.153.217] (munvpn.amd.com. [165.204.72.6])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91040694c35sm140718096d6.36.2026.09.09.04.04.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 09 Sep 2026 04:04:11 -0700 (PDT)
Message-ID: <2fd989b4-06ea-42e6-b18a-bc3ef2e069f5@gmail.com>
Date: Wed, 9 Sep 2026 13:04:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 08/12] dma-buf: heaps: Add debugfs support
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <ckoenig.leichtzumerken@gmail.com>
To: Thierry Reding <thierry.reding@kernel.org>, Rob Herring
 <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
 Conor Dooley <conor+dt@kernel.org>, Jonathan Hunter <jonathanh@nvidia.com>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 Sowjanya Komatineni <skomatineni@nvidia.com>,
 Luca Ceresoli <luca.ceresoli@bootlin.com>,
 Mikko Perttunen <mperttunen@nvidia.com>, Yury Norov <yury.norov@gmail.com>,
 Rasmus Villemoes <linux@rasmusvillemoes.dk>,
 Russell King <linux@armlinux.org.uk>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Marek Szyprowski <m.szyprowski@samsung.com>,
 Robin Murphy <robin.murphy@arm.com>, Sumit Semwal <sumit.semwal@linaro.org>,
 Benjamin Gaignard <benjamin.gaignard@collabora.com>,
 Brian Starkey <Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>,
 "T.J. Mercier" <tjmercier@google.com>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Chun Ng <chunn@nvidia.com>, Mark Rutland <mark.rutland@arm.com>,
 Saravana Kannan <saravanak@kernel.org>
Cc: Thierry Reding <thierry.reding@gmail.com>, devicetree@vger.kernel.org,
 linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-mm@kvack.org, iommu@lists.linux.dev, linaro-mm-sig@lists.linaro.org,
 linux-trace-kernel@vger.kernel.org, Thierry Reding <treding@nvidia.com>
References: <20260904-tegra-vpr-v6-0-79042cfa8de5@nvidia.com>
 <20260904-tegra-vpr-v6-8-79042cfa8de5@nvidia.com>
 <a77730b2-b5d6-49f9-a8ab-72eac4e241b6@amd.com>
Content-Language: en-US
In-Reply-To: <a77730b2-b5d6-49f9-a8ab-72eac4e241b6@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5AD3EC000B
X-Stat-Signature: 8ihqca9we5zkadakmehaa1o16r1qz3sf
X-HE-Tag: 1788951853-229117
X-HE-Meta: U2FsdGVkX1+OuVLGT7S4IONrkGV/yR3ZcbRFrmeJXpzibpGg3IYf4WVeI+uohKKpAx+Y6OxfQFdyJ4rVu8/fZU8ITJa18HyOYtLEqfapTbgswxiABEDsLrgjPQTdlbUyWYPELBsu6OLW2Tb7xW1DQvsPi1u3u+QGM3BKHb0TnwWdtjLCikLsURxE0nTYj8O4msFglByeBitfXto9cqhXHlpJ2U+7aAZ27g4/1DhHeCNRXORh+xaC63YWJ622nFHgTd1cDJvYh628qTDdRKmF+3AQLNUiSOe+9DWyaQ+flfqhBiI/qKZw3QtILXrjezIOJJuyr9yb/r1sbL35DGU/QE6HnRvMJypyiQM6NfNvv+f4fEzwUnW+8eLYOMHeW/fii/KGO+Y355l0eym+Ptzya/JJz2/oCwA7xkrXGYja0pBeY8TrTCrT/+GfZxDtNbnxeJRwEKmogEVvvGvzDmfLSyU+jrzy566uFo9aIilZSMMvnshwL24JZzT38Zl3JvHe9i/aINBxRkjB2TXNte0YWcnQzpYAkh6S4BuUXIFIrbusR6iPzqahOQVhVlezbO8CzTZtqZQsmN8ER9dzVNV9GRrXmUSRtzXg9nQ9etQRCzkVriu0NO86UtxuJBmAZg+AmQyV9V/Mym1H6JXLAHotBAEy8PiadwZ1ziGCBu97PEdGS2phU/0hoWoNJdyLdTq7W0sXsO6AfJ+xNVOXS5jKt93Q6PRnXQS3CwWMiaXP6NROc1vEgCYsrsJ1BJT99ycJmxjltrJMWaAq+VEqL0mKqekbsK0sGrIOa6zV5lrXeAJBumLx5aA8QTpX/sg9EPgzUUBMo/YGRIVpm4j2AQyPcsHUciYCNdJXfMHfJGoel6iKuFOyeP0a8bnxE3NcDHlX6krRppnYw+WnS7zSH8rUTc97ben+d/oa+RxfmzJv9jfEDzRKmm5Bz80XDGrnPCrV4SxE6Wziq02E0lXYLtW
 h9HXbjsf
 Rhzy0x+YgaQ3fKGOSoRrKsH9Kt3XIB5gvxRhAGATBIkQfLMy7qoibhaYEQbucrpQXe2Q44nfGt9QyF07k73Ip0FssFYSIEkocbWH16174+2Gf0SXTS1VQZkH7L+NZm8XjQEiav2JoRNMGFkHGmLXrzmlBM3lyr/lOK76zo6HWyEV59fxRiITbQgPzPcQ9+VrTT7+OJ0ZwoWpuPNWV5zZZ+qMW9aEN63hdyqi37OsctRLsWiSEGhgcNRI9NTqz/JmoQ5WenUBrLcHRS+MV56ufvsWwUIHdhLD4Nr1itFJtc5if6HuL6i30GtTKvWTQmyvVLjcTXqcyVyB5nUi149dhuI0X8s3Uny+bGCmCu1qqVRHq3a0YtMCQ6j114Tu0rnWNB3PB2f5LuEbxcpnceSUHFOrOgYDvmdDwQi/f5asI5KfhXC78l4JI9TCW1JW+lNmYphsVgm0968gqs5HU1k/NY9Tz12I3/+eYRG/go2qH9O8+6k/vGq2VEDRBIXZoGY1lr2d1BorKmffHTAIur+hjMs/AB/G0AMQB16SGiDtyjsqKVzzSjxR0AWBr5R3IQr/cpKR0h1nXKic1EFetCci5uwPc9VOz4ff/gp/729OgbT/aGWkjaOJXD8lstPlTHp+sZfX8ZSq0QpCUbjG/eJH4qlLpPC14DlUek5BQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since AMDs mail servers blocked me from sending this out, here once more from my gmail account.

Regards,
Christian.

On 9/4/26 15:00, Christian König wrote:
> On 9/4/26 12:44, Thierry Reding wrote:
>> From: Thierry Reding <treding@nvidia.com>
>>
>> Add a callback to struct dma_heap_ops that heap providers can implement
>> to show information about the state of the heap in debugfs. A top-level
>> directory named "dma_heap" is created in debugfs and individual files
>> will be named after the heaps.
>>
>> Reviewed-by: Maxime Ripard <mripard@kernel.org>
>> Signed-off-by: Thierry Reding <treding@nvidia.com>
> 
> One minimal nit pick below, with that taken care of Reviewed-by: Christian König <christian.koenig@amd.com>.
> 
>> ---
>> Changes in v5:
>> - fix failure handling during debugfs root directory creation
>> - add more cleanup to the newly introduced dma_heap_exit()
>> ---
>>  drivers/dma-buf/dma-heap.c | 52 ++++++++++++++++++++++++++++++++++++++++++++++
>>  include/linux/dma-heap.h   |  2 ++
>>  2 files changed, 54 insertions(+)
>>
>> diff --git a/drivers/dma-buf/dma-heap.c b/drivers/dma-buf/dma-heap.c
>> index 8a6c2b6e0cc6..65c80dac6500 100644
>> --- a/drivers/dma-buf/dma-heap.c
>> +++ b/drivers/dma-buf/dma-heap.c
>> @@ -7,6 +7,7 @@
>>   */
>>  
>>  #include <linux/cdev.h>
>> +#include <linux/debugfs.h>
>>  #include <linux/device.h>
>>  #include <linux/dma-buf.h>
>>  #include <linux/dma-heap.h>
>> @@ -225,6 +226,40 @@ const char *dma_heap_get_name(struct dma_heap *heap)
>>  }
>>  EXPORT_SYMBOL_NS_GPL(dma_heap_get_name, "DMA_BUF_HEAP");
>>  
>> +#ifdef CONFIG_DEBUG_FS
>> +static int dma_heap_debug_show(struct seq_file *s, void *unused)
>> +{
>> +	struct dma_heap *heap = s->private;
>> +	int err = 0;
>> +
>> +	if (heap->ops && heap->ops->show)
>> +		err = heap->ops->show(s, heap);
>> +
>> +	return err;
>> +}
>> +DEFINE_SHOW_ATTRIBUTE(dma_heap_debug);
>> +
>> +static struct dentry *dma_heap_debugfs_dir;
>> +
>> +static void dma_heap_init_debugfs(void)
>> +{
>> +	dma_heap_debugfs_dir = debugfs_create_dir("dma_heap", NULL);
>> +}
>> +
>> +static void dma_heap_exit_debugfs(void)
>> +{
>> +	debugfs_remove_recursive(dma_heap_debugfs_dir);
>> +}
>> +#else
>> +static void dma_heap_init_debugfs(void)
>> +{
>> +}
>> +
>> +static void dma_heap_exit_debugfs(void)
>> +{
>> +}
>> +#endif
>> +
>>  /**
>>   * dma_heap_add - adds a heap to dmabuf heaps
>>   * @exp_info: information needed to register this heap
>> @@ -299,6 +334,13 @@ struct dma_heap *dma_heap_add(const struct dma_heap_export_info *exp_info)
>>  
>>  	/* Add heap to the list */
>>  	list_add(&heap->list, &heap_list);
>> +
>> +#ifdef CONFIG_DEBUG_FS
>> +	if (heap->ops && heap->ops->show)
>> +		debugfs_create_file(heap->name, 0444, dma_heap_debugfs_dir,
>> +				    heap, &dma_heap_debug_fops);
>> +#endif
>> +
>>  	mutex_unlock(&heap_list_lock);
>>  
>>  	return heap;
>> @@ -335,6 +377,16 @@ static int dma_heap_init(void)
>>  	}
>>  	dma_heap_class->devnode = dma_heap_devnode;
>>  
>> +	dma_heap_init_debugfs();
>> +
>>  	return 0;
>>  }
>>  subsys_initcall(dma_heap_init);
>> +
>> +static void __exit dma_heap_exit(void)
>> +{
>> +	dma_heap_exit_debugfs();
>> +	class_destroy(dma_heap_class);
>> +	unregister_chrdev_region(dma_heap_devt, NUM_HEAP_MINORS);
>> +}
>> +__exitcall(dma_heap_exit);
>> diff --git a/include/linux/dma-heap.h b/include/linux/dma-heap.h
>> index 648328a64b27..1c9bed1f4dde 100644
>> --- a/include/linux/dma-heap.h
>> +++ b/include/linux/dma-heap.h
>> @@ -12,6 +12,7 @@
>>  #include <linux/types.h>
>>  
>>  struct dma_heap;
>> +struct seq_file;
>>  
>>  /**
>>   * struct dma_heap_ops - ops to operate on a given heap
>> @@ -24,6 +25,7 @@ struct dma_heap_ops {
>>  				    unsigned long len,
>>  				    u32 fd_flags,
>>  				    u64 heap_flags);
>> +	int (*show)(struct seq_file *s, struct dma_heap *heap);
> 
> I found it good coding practice for objects ops pointer tables to have the object the function works with as first parameter.
> 
> Absolutely not a must have, but just looks a little bit more consistent.
> 
> Regards,
> Christian.
> 
>>  };
>>  
>>  /**
>>
> 


