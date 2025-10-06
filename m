Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3728DCCA470
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 16:55:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C0788E000A; Mon,  6 Oct 2025 12:55:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 771A38E0002; Mon,  6 Oct 2025 12:55:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65FC88E000A; Mon,  6 Oct 2025 12:55:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4E2388E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 12:55:22 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CE13F59973
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 16:55:21 +0000 (UTC)
X-FDA: 83968290042.08.B73C85B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3BF0720011
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 16:55:20 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dy3gP9+H;
	spf=pass (imf03.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759769720; a=rsa-sha256;
	cv=none;
	b=jOW7m6o39d4jtXh3tsaNjBonQ4OXIWyHGMcgN4LOLRa6AB02j7jV8sTzEvdTAl5lt+YVbv
	MLWlD+nX0kFs3JQUiqbC7J0Xy32SO3NcPYs9ewHpyF5q4lrVv5gJyVbzlhjrNz/0YjXE1V
	6NSkNFJNxr9JO62Qi1kJmFJIXFduNEY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dy3gP9+H;
	spf=pass (imf03.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759769720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vj7sOPjyprwfoc6fhRyUFtUgPPZEr7K+4ylmESoRr24=;
	b=7Ke2Am0AKYdaeFOqfqdCk0It95y07Xjjq7X6t2ogliEqd0S0ZZLlWbD6L1jb/ngEgBeF81
	VkshTlDmyfXlPUrmBAfrlK7fkmbvfMhFjzxUto7xlVybXJfqbCKD8O9Yd7Eh1WBE+poJPv
	jpTkEu54dQhFWzSVDZxMv+zn0Gxwk90=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0A04E4550F;
	Mon,  6 Oct 2025 16:55:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 802ACC4CEF5;
	Mon,  6 Oct 2025 16:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759769718;
	bh=bNOBRpWkDT6nydzMvQKW3RR7QOwbofZoWQJVye/UKJQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=dy3gP9+Hu4E5xMMiiXrOi1KBJQZnMJOFX+Pw/lPzRsL0eNwziUiawbI2RN3scxHdq
	 WtJQGLnrydwWN9OOe/90A84/2kWEo0S4RiuX4WyzxNemOjxh6of1Wv7pVq0CaWf/EB
	 wi+SmriVpfAZTAO7qSUiuVlh0u6er0wRoTJX5+ocBvXSi9zDVFA790ikivH8XcP0Vy
	 r+zc6grPhvf4IDJJvxb6hsddNYo13M0fB1zfLNvFdMXMRPZ/CaXs0qgP342leLMR4k
	 Vz2vEmfRVbrBiBUwqweVTMGK941+ZHMntFuSxcxOxERuspsdMX2JyW8vD5zXXW3A1T
	 kfnmY1JabGz0w==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: pratyush@kernel.org,  jasonmiu@google.com,  graf@amazon.com,
  changyuanl@google.com,  rppt@kernel.org,  dmatlack@google.com,
  rientjes@google.com,  corbet@lwn.net,  rdunlap@infradead.org,
  ilpo.jarvinen@linux.intel.com,  kanie@linux.alibaba.com,
  ojeda@kernel.org,  aliceryhl@google.com,  masahiroy@kernel.org,
  akpm@linux-foundation.org,  tj@kernel.org,  yoann.congal@smile.fr,
  mmaurer@google.com,  roman.gushchin@linux.dev,  chenridong@huawei.com,
  axboe@kernel.dk,  mark.rutland@arm.com,  jannh@google.com,
  vincent.guittot@linaro.org,  hannes@cmpxchg.org,
  dan.j.williams@intel.com,  david@redhat.com,  joel.granados@kernel.org,
  rostedt@goodmis.org,  anna.schumaker@oracle.com,  song@kernel.org,
  zhangguopeng@kylinos.cn,  linux@weissschuh.net,
  linux-kernel@vger.kernel.org,  linux-doc@vger.kernel.org,
  linux-mm@kvack.org,  gregkh@linuxfoundation.org,  tglx@linutronix.de,
  mingo@redhat.com,  bp@alien8.de,  dave.hansen@linux.intel.com,
  x86@kernel.org,  hpa@zytor.com,  rafael@kernel.org,  dakr@kernel.org,
  bartosz.golaszewski@linaro.org,  cw00.choi@samsung.com,
  myungjoo.ham@samsung.com,  yesanishhere@gmail.com,
  Jonathan.Cameron@huawei.com,  quic_zijuhu@quicinc.com,
  aleksander.lobakin@intel.com,  ira.weiny@intel.com,
  andriy.shevchenko@linux.intel.com,  leon@kernel.org,  lukas@wunner.de,
  bhelgaas@google.com,  wagi@kernel.org,  djeffery@redhat.com,
  stuart.w.hayes@gmail.com,  lennart@poettering.net,  brauner@kernel.org,
  linux-api@vger.kernel.org,  linux-fsdevel@vger.kernel.org,
  saeedm@nvidia.com,  ajayachandra@nvidia.com,  jgg@nvidia.com,
  parav@nvidia.com,  leonro@nvidia.com,  witu@nvidia.com,
  hughd@google.com,  skhawaja@google.com,  chrisl@kernel.org,
  steven.sistare@oracle.com
Subject: Re: [PATCH v4 02/30] kho: make debugfs interface optional
In-Reply-To: <20250929010321.3462457-3-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Mon, 29 Sep 2025 01:02:53 +0000")
References: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
	<20250929010321.3462457-3-pasha.tatashin@soleen.com>
Date: Mon, 06 Oct 2025 18:55:08 +0200
Message-ID: <mafs0y0ponf6b.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Stat-Signature: 7hxn17oxb4xgnj7rtk8ks75odkkawe4a
X-Rspamd-Queue-Id: 3BF0720011
X-Rspamd-Server: rspam09
X-HE-Tag: 1759769720-176472
X-HE-Meta: U2FsdGVkX1/PuxWKTZK9jKx04HrwXVugvo+6U06Pzo/uBdg8EiUuoPy5VY1xeV6Z1s3NJ18xjN40E/ZA0/X8iIPbVJYwIxJI1iu/zNjdyPeLKK/4JMvYj9EwB5gf/JzRJRIC7yAUfa4UgG+6wmUUkiHqBPhXzWRWKxqd6fEYhd9efPhtYsvewelDOZFyGLl5nuvY088BuwncJBQYC189aHIldb/O/Px4AO50xLpNstdaiartZSK0EcGTQsp4blozN4NqOvqKC3G057SDNAqhBMJmSDgARhcJpZ11S+RDP/Y4UhEJwgPg/Ucm9g0VjTV2bKNzEeoCXxKr3vMVk10u0CmCSPTQPkLWW4oQhXa6oHhWs16TeiMwcA2homoXEarqz3H6/RQSLJ1s5a0O5nvsugTGohmspbMOhiS1kMBhJxYbVlE4yUxD+XFZY8MEZmWcp/gqgEPxoHjgp51sSq5PUTwqB+y7NMBzIP5B5kzKdHok1ArDKEPdSqLwJOI/Uay5p/lZmPS/QWxoDH8RcrDB6y12cCnI+/1BYAf1cGtW1IeoxWmiudqyB1lQzSwDMXGe0l5U7K/y6Szr9trLlaoRtaXBMi2ypIMVkioc5nJlNzcNNOGldDaDv+YV66YH52MVSoQGiT2DMrYxUTrTEQjPi5f25z6uvgSGQLCZt1UIkyhXUfu4VXF6+payWzC9WbKUJFLwHr6mLsoVmZfEPmaDawyojbmL1Q6XQNTLzzkPGxCtolGVDlnenOYJKvDJ3TryYHNRaUOyNCax8axfelNK26DY6fQ69JZ/DhE4afXawBWDw40sdPDT0oOpPRdwnZbrMqv55/h5ejfGy4RkxOkMVddZow7TGcp0m1g6EOewALIiVVfsYmA0gFjPt47rVR3aM84rWxdYu6FnVv7wJdwjgodsZelO2gxmeZL4+tQmI8Tp/onk4EMQrEgXWxWE8hp3/QGqAwgw8QYfBYloBfQ
 l7g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Pasha,

On Mon, Sep 29 2025, Pasha Tatashin wrote:

> Currently, KHO is controlled via debugfs interface, but once LUO is
> introduced, it can control KHO, and the debug interface becomes
> optional.
>
> Add a separate config CONFIG_KEXEC_HANDOVER_DEBUG that enables
> the debugfs interface, and allows to inspect the tree.
>
> Move all debugfs related code to a new file to keep the .c files
> clear of ifdefs.
>
> Co-developed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
[...]
> @@ -662,36 +660,24 @@ static void __init kho_reserve_scratch(void)
>  	kho_enable = false;
>  }
>  
> -struct fdt_debugfs {
> -	struct list_head list;
> -	struct debugfs_blob_wrapper wrapper;
> -	struct dentry *file;
> +struct kho_out {
> +	struct blocking_notifier_head chain_head;
> +	struct mutex lock; /* protects KHO FDT finalization */
> +	struct kho_serialization ser;
> +	bool finalized;
> +	struct kho_debugfs dbg;
>  };
>  
> -static int kho_debugfs_fdt_add(struct list_head *list, struct dentry *dir,
> -			       const char *name, const void *fdt)
> -{
> -	struct fdt_debugfs *f;
> -	struct dentry *file;
> -
> -	f = kmalloc(sizeof(*f), GFP_KERNEL);
> -	if (!f)
> -		return -ENOMEM;
> -
> -	f->wrapper.data = (void *)fdt;
> -	f->wrapper.size = fdt_totalsize(fdt);
> -
> -	file = debugfs_create_blob(name, 0400, dir, &f->wrapper);
> -	if (IS_ERR(file)) {
> -		kfree(f);
> -		return PTR_ERR(file);
> -	}
> -
> -	f->file = file;
> -	list_add(&f->list, list);
> -
> -	return 0;
> -}
> +static struct kho_out kho_out = {
> +	.chain_head = BLOCKING_NOTIFIER_INIT(kho_out.chain_head),
> +	.lock = __MUTEX_INITIALIZER(kho_out.lock),
> +	.ser = {
> +		.track = {
> +			.orders = XARRAY_INIT(kho_out.ser.track.orders, 0),
> +		},
> +	},
> +	.finalized = false,
> +};

There is already one definition for struct kho_out and a static struct
kho_out early in the file. This is a second declaration and definition.
And I was super confused when I saw patch 3 since it seemed to be making
unrelated changes to this struct (and removing an instance of this,
which should be done in this patch instead). In fact, this patch doesn't
even build due to this problem. I think some patch massaging is needed
to fix this all up.

>  
>  /**
>   * kho_add_subtree - record the physical address of a sub FDT in KHO root tree.
[...]

-- 
Regards,
Pratyush Yadav

