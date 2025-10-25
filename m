Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 331D2CCD1BF
	for <linux-mm@archiver.kernel.org>; Sat, 25 Oct 2025 07:01:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87FC08E013F; Sat, 25 Oct 2025 03:01:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 857C98E0135; Sat, 25 Oct 2025 03:01:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 793F88E013F; Sat, 25 Oct 2025 03:01:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6C51D8E0135
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 03:01:34 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C4F5D141077
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 07:01:33 +0000 (UTC)
X-FDA: 84035740866.04.547C3E6
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4EA5C40012
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 07:01:28 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	spf=pass (imf12.hostedemail.com: domain of yi.zhang@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=yi.zhang@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761375692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=txGEQDuwd3WJ/vax38ECHL1LoCT9mVqpWNzxrb/4EEM=;
	b=FR9y9uxVMisK1weUOYupfP8EDzPF69NftDCFRDWR5H28k5DB3HJmj0M8JnYLgYKeuHW+DT
	t3/4A7s7PgI7xhcB9Fuv60lrnLUvzsuYeGZyAvTfw2mFU72pihzUAszJWTcjj0UJFt7QbN
	8knOmUUwKHQGDZaAPcDF4ODurf9jpyY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of yi.zhang@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=yi.zhang@huaweicloud.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761375692; a=rsa-sha256;
	cv=none;
	b=2XDf7AlZBEsI78pjVLk069zOLEItPZXkDMGFSMG/oYGV7qL2gLxcFLaNmKMZ7g2c/aBknn
	DM6nqMNif89n2AerbsLnckKiBwkYtp2zCKyCsy8Mxal0ikmuehAOtIwQALHuVwXBfq1375
	R/w7TCyki/10u8BRVxmd0ya+NgFDLyY=
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4ctrJG5q0LzKHMWh
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 15:00:30 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id B56531A0AD3
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 15:01:22 +0800 (CST)
Received: from [10.174.178.152] (unknown [10.174.178.152])
	by APP2 (Coremail) with SMTP id Syh0CgBXrETAdfxomP4rBg--.46683S3;
	Sat, 25 Oct 2025 15:01:22 +0800 (CST)
Message-ID: <9e963efb-fe5b-477c-afaf-f0b0677648f8@huaweicloud.com>
Date: Sat, 25 Oct 2025 15:01:20 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 22/25] fs/buffer: prevent WARN_ON in
 __alloc_pages_slowpath() when BS > PS
To: Baokun Li <libaokun@huaweicloud.com>, Matthew Wilcox
 <willy@infradead.org>, "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
 jack@suse.cz, linux-kernel@vger.kernel.org, kernel@pankajraghav.com,
 mcgrof@kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 yangerkun@huawei.com, chengzhihao1@huawei.com, libaokun1@huawei.com
References: <20251025032221.2905818-1-libaokun@huaweicloud.com>
 <20251025032221.2905818-23-libaokun@huaweicloud.com>
 <aPxV6QnXu-OufSDH@casper.infradead.org>
 <adccaa99-ffbc-4fbf-9210-47932724c184@huaweicloud.com>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <adccaa99-ffbc-4fbf-9210-47932724c184@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:Syh0CgBXrETAdfxomP4rBg--.46683S3
X-Coremail-Antispam: 1UD129KBjvJXoW7WFWkCFWDXrW8JrWfCr17Jrb_yoW8Xw4UpF
	WkCF4xKFykJr1Du3W8Z3W5tFyaka1rWF4UCF4xt34fCF1qg343W39Fk3WFkFyayFW5A340
	qrWxtFZru3ZxA37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvjb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAaw2AF
	wI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
	xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43
	MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
	0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWU
	JVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUF1
	v3UUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/
X-Stat-Signature: dmfpnphb8xyeosny6ffdu3wxuwd79rda
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4EA5C40012
X-HE-Tag: 1761375688-631814
X-HE-Meta: U2FsdGVkX19sK4r9wnZl0+adhCNHU/G7N28lO1kGCBCBtU958dDaLACgnqHQVpZ2/enMqxsmzY38EbapFTShfdnRk/hfl7pXuJ/U0cmiyG97Bc45vSA5kIRO8fGKwNlhwuUCbsQxaNgY+HXhjz7aKNJOkVIpmYrnGKWoGqmB2kfgZEd+kLnpICzmm/7MYyAp7oWP3TCH8yTPH/KSOtlzsrd214S6yQwWpMQq+MSLeswkhkYg3z32ldJFvfpd8cMT3LUHsnS4Lsni/LO2LMMVQDIdMlxdgTO7mewB3cIXEQlJKqBv9yZtDPH6+ziuXAh7xRGPwkw/l1nDsH8xP/vtMzwAqNwHLWtg4eBOBiTsF6m/oeHub1As7XATgu1SkHKMhgdAPGb4/MCiqyHgTJVyZ4zQ8ECkNlIY/CvDpb+20rOmf9axbKHUEexMZ9g7jcuCw0ACKzxWnZWf1IFXFgazgthqLA5JaJiKM76UbqycA4rz9uGOpzuIsSvoPteezUWW9GeI5L9mDYoR8p4z5fXXm6k39W8PYbkXV+EYP+t6uYOr265kcvoSFyzloGtyjONV67ZI0HnFZeP2rG4sVyZTqPmzoHhwAFehQbuQlGNhRA9VrUHASQzm7sjFpKKgbdC/y5xwh1sYzstEgRPS2iVmb3jbToK3DgIyfs2PueduheIEIRl3YJu9/ESGFEcGgYtgtFU7QNqDdjImz9f5eZYom2hdfPtxR6tMOfbB5fgcW8b/IvcMpZmlCZBPxHDWwI5oLg+lN7t0qn7g8ccSyBk/2MCpg2H2eQjG+59BMzAkV8w5EmwrnWr7C52V4XdkaqSkFEmnKC3xqFWTOc9HTRSi++nFC/qdc4Hm8AhYYr+r5ET9n0JApLDzyJaiDH++1re1Aafw+dceF+SL9tzYt8BhRTSKXg4MX2BwUuY6sy80Ha7F3XZKjhpAx9QhdhgcUs5k1xh8xt4Pa+lq/1e2G0k
 sKG+4JOv
 RcqdUBNu9ZaOVXvqWHD4XLYR1BwNWPb+4nW84HAWaTMLIvLY728W3pevrbDtYoG92cAXZN2Tekvvb85/Im0wefr6aGtP3CQjjfVlpQcHFRzW9Cd2TWRBoceX5NJ7EyFxE3Crw45liV0qm7mpdtw7bttlRIbYKBumfo4Y2U7MmFxo1d9kqalvW3CVNyGlsoC3/LmSy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/25/2025 2:32 PM, Baokun Li wrote:
> On 2025-10-25 12:45, Matthew Wilcox wrote:
>> On Sat, Oct 25, 2025 at 11:22:18AM +0800, libaokun@huaweicloud.com wrote:
>>> +	while (1) {
>>> +		folio = __filemap_get_folio(mapping, index, fgp_flags,
>>> +					    gfp & ~__GFP_NOFAIL);
>>> +		if (!IS_ERR(folio) || !(gfp & __GFP_NOFAIL))
>>> +			return folio;
>>> +
>>> +		if (PTR_ERR(folio) != -ENOMEM && PTR_ERR(folio) != -EAGAIN)
>>> +			return folio;
>>> +
>>> +		memalloc_retry_wait(gfp);
>>> +	}
>> No, absolutely not.  We're not having open-coded GFP_NOFAIL semantics.
>> The right way forward is for ext4 to use iomap, not for buffer heads
>> to support large block sizes.
> 
> ext4 only calls getblk_unmovable or __getblk when reading critical
> metadata. Both of these functions set __GFP_NOFAIL to ensure that
> metadata reads do not fail due to memory pressure.
> 
> Both functions eventually call grow_dev_folio(), which is why we
> handle the __GFP_NOFAIL logic there. xfs_buf_alloc_backing_mem()
> has similar logic, but XFS manages its own metadata, allowing it
> to use vmalloc for memory allocation.
> 
> ext4 Direct I/O has already switched to iomap, and patches to
> support iomap for Buffered I/O are currently under iteration.
> 
> But as far as I know, iomap does not support metadata, and XFS does not
> use iomap to read metadata either.
> 
> Am I missing something here?
> 

AFAIK, Unless ext4 also manages metadata on its own, like XFS does,
instead of using the bdev buffer head interface. However, this is
currently difficult to achieve.

Best Regards,
Yi.


