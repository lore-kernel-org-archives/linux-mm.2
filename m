Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D9B2E66886
	for <linux-mm@archiver.kernel.org>; Sun, 21 Dec 2025 09:26:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 070916B00A9; Sun, 21 Dec 2025 04:26:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00BD16B00AB; Sun, 21 Dec 2025 04:26:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E39166B00AC; Sun, 21 Dec 2025 04:26:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D07266B00A9
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 04:26:11 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8A33A137AD5
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 09:26:11 +0000 (UTC)
X-FDA: 84242946942.27.8EED021
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id DD6C8140004
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 09:26:09 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FnDPGczr;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766309169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6FpJhxQY7O9d5B4kx8NRpuGa0bHRgyR0gCMwS529Gpc=;
	b=DtffgTDQjqeW0NuJTX4y/FEIUe6Q9sG3ol0FdGlsx4RCfztYDeGxnN0tBL3tGmvHmB0e2A
	GQEwsqI7sjGQYh7d0HCR5YW+8dK2w5L4ewS99EHAvxn6HAFXrzAkOY3IJk6/S+iB6xb7Ed
	8wmobJDPrWciRxRZO1HFaICEMuo26d8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766309169; a=rsa-sha256;
	cv=none;
	b=dQfuBUl6Q9UhKOaVLgwHWGQzMozYqmrAsYVA9K980ychbvOTHcHRIN7twsm7e8HN6BhY3n
	yhnxkhK25hdhrZQ/nGxiETMb4eB8McKQhvHVIisJGhdPcdHcbufoaJCjZ3TPZq48XFDnRe
	wqh9eiAFVaXSyXsH32AqyDRKmNP20nU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FnDPGczr;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2F42860007;
	Sun, 21 Dec 2025 09:26:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09984C4CEFB;
	Sun, 21 Dec 2025 09:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766309168;
	bh=esxjetLdFP/MAyCLymvsG8qIqlk3M0nhtMrWkyRPnwQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=FnDPGczrrw8oC7l9zuzJWIbFyrodhrnerdPmuBtB0HFe3DSaH4B/S0nHIv4IvZWHY
	 HvMCP8XblN1Z5nu3gVXIi7XDbMja0dstINHmLibZGbjsVgoHlAdNNOkZYbw/+8WAmV
	 lApjz5UCEugO3Ipe+/Dtt09ibNm3FKQDnKSQtx237eIsKPQvai/Ty/rZQG88mpc9in
	 K0sthxp+4ryjgiwfNuFMfqfEM6f99HCff17eATPsFyaX8qf6VrVIggPjiyKK8xcZ+f
	 P9mBPpYLliQrelgWNOl9Ldfubg2Pq7XmUyLWFQVVzYmdytJCf952OyYnwkVrGgEP8j
	 QQND0w+2LOcmA==
Message-ID: <ebe2b0e1-38fd-49be-bb10-af497abf78f7@kernel.org>
Date: Sun, 21 Dec 2025 10:26:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] MAINTAINERS: Notify the "Device Memory" community of
 memory hotplug changes
To: Dan Williams <dan.j.williams@intel.com>, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-cxl@vger.kernel.org,
 Oscar Salvador <osalvador@suse.de>, Davidlohr Bueso <dave@stgolabs.net>,
 Jonathan Cameron <jonathan.cameron@huawei.com>,
 Dave Jiang <dave.jiang@intel.com>,
 Alison Schofield <alison.schofield@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>,
 John Groves <John@Groves.net>
References: <20251220000327.3502994-1-dan.j.williams@intel.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251220000327.3502994-1-dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ywpjeb7sgun3qw99x93ci19o1qpua5eo
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DD6C8140004
X-Rspam-User: 
X-HE-Tag: 1766309169-444132
X-HE-Meta: U2FsdGVkX1+vX64BnedevUPY+YOjwN/MhAAoWTYUAnUrLHFhnXh0nffm3IEoTbGkw+/Un3xqPg3a0Ie/bOYnL97LM3Cm1pLvdKOZwhlEsQMrMbQ7fbnWp8+wNvcBQJiPvKuJ+VRzXxoKtT6XiAbZrT2OPh5wTJYKUHZ9hPuRXRBzdOCnq/dPggWbu7DXFUwCFGhLG6NeLKxhRGsV/WDgKfgkZyrYM/3F2lW37S0FFsTIzcsCOQjwg+CnjrQqAe6VIqFWFLo7/fvZWmTjVXGIa5QgDB1vjaHzoHDvgd08R+r/mNS8cEpUyEMh978TsXHDykScdMZRydz+22btcwh7yYwWTD85IkS6L1Gp3Kw76gPUS/i+6NVsaYbY1yBxLoC67mYYPI0m/8R4mHXr775bAQuI5onT5EbOSRLKBRns1/6TdykKad+EdR0eF3fMJnknsq6vfUz9xQC9OGk6h1imsiaBRDjTwBBlizOfWz7t8zyus1FpHhsmIMUTKPr7TbmHAJIKFM6D6GB9POJHtGkVdMV81/2WFvnbXMrmbdsRtqqEvV6KLZ5x2JBkEr1ZoG1TsTk0fKmTTYpeUIJGzILqCvXlaGLFU4aLQSN0/o/ML8bOfVFcMefZYiYFs3NPey3NiFKhvSU3WDtD8rZr6KFFsCQpwhwEGQ34fkS7W7eSXy+Nu6ilv3ePSUHlM9BLfLp+WN3Bb06u6VGD04DXXchD7UAb33vF87yTnCQnlAxBRUy86oQFAf9PWppubneG7wE3PEY5927ZJVNBBlmt792bQK7dhBMxARmG3hwKi/LSB0nczfhQ+g/MUxn8N22MLjGzrfYGa+csOkTZ8BTbG6MTtvSbx5VSt16ifSOgV90RGn6UYaY5LE8shW88Niv+qm8mI4EQuCYT12FuDF4CvBJW+8wspWsr75m2y/8HQKDArP+LdooGPJ/lc95ed+8rVuouyF+2me1MDtnWsWRyCFA
 1w2b3j5a
 6l8sqPPIZV+AOt9Dp6Y6co5q5S0Rb7AEoEeGlYdVGIUIBVPwsN9s/MVm2OIb4tI3JDVXoPi/jrx5VvMMlaLlxIEr7dPb5FTmg7WBEKPRMAU+oPOrlHKz/1u4/p/P6CHlyDkn5CO9p6dV5Sbh9+03pfhNaN+kUi6Okhn53IjLLTJN5oNTyp+G1LT3r4v/8OaHzo6aXavqJ7UHpOOvUphcPa48uQF5GqRFH81cLZgmTmUOOpiEnmlJmqCWsMJl9wnva9nfWMVtimccFfQGnk+0SeRPjzg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/20/25 01:03, Dan Williams wrote:
> The recent episode of a warning regression in memremap_pages() [1]
> highlights that relevant updates are being missed by folks that care about
> core ZONE_DEVICE changes. Yes, CXL folks should pay more attention to
> linux-mm@, but it also would not hurt to copy linux-cxl@, where most Device
> Memory folks hang out, on memory hotplug changes by default.

In general, that patch set went upstream too quickly. Quickly as in: 
more review should have been done. But here we are.

I reviewed that patch of that patch set but missed this change ...

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

