Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15982CCD1BF
	for <linux-mm@archiver.kernel.org>; Sat, 25 Oct 2025 06:33:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE1488E013D; Sat, 25 Oct 2025 02:33:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB85C8E0135; Sat, 25 Oct 2025 02:33:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF57E8E013D; Sat, 25 Oct 2025 02:33:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BFC408E0135
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 02:33:20 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 60260C10A5
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 06:33:20 +0000 (UTC)
X-FDA: 84035669760.08.C0D105D
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0918B20005
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 06:33:13 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	spf=pass (imf03.hostedemail.com: domain of libaokun@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=libaokun@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761373998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sJPQP7o2P1zUzIFg5kKpIroyc7yHZ9f72lY2MSOC+a0=;
	b=kFOGkXzEx/qor3md3rSNc49t5S4EnXD8d6JZlUOl+7dCh1x0TiQ6GOt1AbdH8Ji5RdeFuW
	AiawLXumDSGfM0OuSnTRX0oMfVC2W60cJc1nyvQnbmuouqnvj5IzxxPs5KhgP33YKTciFU
	10BHxAAviKuKoIemhuXXnzLRsjEy6Ps=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of libaokun@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=libaokun@huaweicloud.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761373998; a=rsa-sha256;
	cv=none;
	b=FPKoxnRA22MGvmdOJr4DyXJ9NpDOTR0HbQ5h8APs5FduiTpixRTaK/QF6axIgaIPzm1OW0
	6qC6riEtPNRTj+2gMlKakmqrRL9xNkhUTVxMrdUTFPK2h53JakrPbzBnhz4TvbDkn7vCUC
	qFxf5S1Ms4UkR4bfBcdV8YTc2+vhloU=
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4ctqgY16ZZzYQtn7
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 14:32:09 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 079F81A0F86
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 14:33:08 +0800 (CST)
Received: from [10.174.178.254] (unknown [10.174.178.254])
	by APP2 (Coremail) with SMTP id Syh0CgBnvUUWb_xojropBg--.48200S3;
	Sat, 25 Oct 2025 14:33:07 +0800 (CST)
Message-ID: <adccaa99-ffbc-4fbf-9210-47932724c184@huaweicloud.com>
Date: Sat, 25 Oct 2025 14:32:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 22/25] fs/buffer: prevent WARN_ON in
 __alloc_pages_slowpath() when BS > PS
Content-Language: en-GB
To: Matthew Wilcox <willy@infradead.org>, "Darrick J. Wong"
 <djwong@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
 jack@suse.cz, linux-kernel@vger.kernel.org, kernel@pankajraghav.com,
 mcgrof@kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 yi.zhang@huawei.com, yangerkun@huawei.com, chengzhihao1@huawei.com,
 libaokun1@huawei.com
References: <20251025032221.2905818-1-libaokun@huaweicloud.com>
 <20251025032221.2905818-23-libaokun@huaweicloud.com>
 <aPxV6QnXu-OufSDH@casper.infradead.org>
From: Baokun Li <libaokun@huaweicloud.com>
X-Mozilla-Draft-Info: internal/draft; vcard=0; receipt=0; DSN=0; uuencode=0;
 attachmentreminder=0; deliveryformat=1
X-Identity-Key: id2
Fcc: imap://libaokun%40huaweicloud.com@cnp3.mail02.huawei.com/Sent
In-Reply-To: <aPxV6QnXu-OufSDH@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:Syh0CgBnvUUWb_xojropBg--.48200S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Kw4ktw47Kw13CF47Zr43Wrg_yoW8Jw4xpF
	WvkF1IqFykJr1kZF1kZw13JFyak3y8JF4UCay7t3sxuFn8Ja4agrsFk3WFkFySkryUAw10
	qFWxtrZ7u3ZxA37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvYb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS
	14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8
	ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
	0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_
	Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x07
	UG-eOUUUUU=
X-CM-SenderInfo: 5olet0hnxqqx5xdzvxpfor3voofrz/1tbiAQAMBWj7UbRPggABsy
X-Rspam-User: 
X-Rspamd-Queue-Id: 0918B20005
X-Rspamd-Server: rspam03
X-Stat-Signature: qby8r3gb3mezfqekygtqa57knfifc1cg
X-HE-Tag: 1761373993-321075
X-HE-Meta: U2FsdGVkX1938/2nmQ0xrehgO4oAx8ePLf06Jcc+PTvwI4/gi+A54mBIHJijC9xny3NEJ0daQLNSMxAdH9XCbxiZcxc4GaR5e1zB57rlOEHUovYfOVOuJ6tNFcp2pORSu4hkKDJfNxG/t0K2dvn9+OqpBRJckagAbIhbSTcwL0GcG7MfGJG+BXpjLwKsdEoxVjojwdNd2UiQtBwFNBjzlARvTtS/zJZ2lpWuZfgiiOFwDS3vrPKy8tQ8x5zz/6XZEePvXtucPGnVK8Ea4nLL7CBxdi89yH354YPVRfOIY2SlhACTRtkSoNRztFJvRpJJGZQ2V3kBMgt1VnEkla69rZLvQprZ1X5R6ypoN+sBK4bY7zJAF21xYeDGPSpFtwbm7PGD/31eWxWfFFf8GWra3DDGrUhJqxnApKYwTCWe168l6uI9u4huiydF8CaGjptAlUm7gHKWGB35/X4BkgILMM1BXkyQjp4Xh6GWFQu59KP+PVGcWS759WMq3gumwKlUk8PDWqigh7AstyWSw7mj7veEO87CS7NcnaMRRCVfiKQaQPRvyP7olfesrWoHtrsL8rqdFhzRhp6GV6HfdOhEFh5CM9uywbEl/zRpxY/fTgBPq3W2tIUwiKg6zevLeduJHogoJZ5vPRHbXfdKfUeBtVU7sCAI92VhkpjVb/GYF7foTwXqUGjfc5zUIV0qI80iIVzTjvEmpMPUCRmmZ5vbfRuxzAAqytA1ryoxXNHc32VWe00HOovLHWXVlBivQfRK/LwI+lTkYn6sY37Sjsq/SPzfPyZS3A8ouZr62WL0esUBQt86dwbVRxUIzv4dkzIayDVa+DF5tFK9+hFX5N/+pdnaYifk3YPmPcLAPy++OThSCBnA4gBhasrUPjEdrMBz67/bTNMvYEZUMDRvF5+UABBtErw3piyg/mfSfmAG1RCy6DIeJcTt/+ZJga8kcp5zjOny+eoakmDhCS4bB4D
 Ga2Lobn8
 cBG7gQTnIFAG6+F13nO9NIIoeB/OeAM9oaOnzJiyXPIt18brhgjuZF8lg7DXyx/Fv+gIr8m16B+td8tx05COsYSpTDc0P0y0rW7ht2mP4lFmiAoFfB8ngAYnc5suLM1rAKXVreQMT/dARs5GN+fr0MzISmX/CyVRcVko3oAksoi15g6Yc3//lbSQW6nFJXqucISyS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-10-25 12:45, Matthew Wilcox wrote:
> On Sat, Oct 25, 2025 at 11:22:18AM +0800, libaokun@huaweicloud.com wrote:
>> +	while (1) {
>> +		folio = __filemap_get_folio(mapping, index, fgp_flags,
>> +					    gfp & ~__GFP_NOFAIL);
>> +		if (!IS_ERR(folio) || !(gfp & __GFP_NOFAIL))
>> +			return folio;
>> +
>> +		if (PTR_ERR(folio) != -ENOMEM && PTR_ERR(folio) != -EAGAIN)
>> +			return folio;
>> +
>> +		memalloc_retry_wait(gfp);
>> +	}
> No, absolutely not.  We're not having open-coded GFP_NOFAIL semantics.
> The right way forward is for ext4 to use iomap, not for buffer heads
> to support large block sizes.

ext4 only calls getblk_unmovable or __getblk when reading critical
metadata. Both of these functions set __GFP_NOFAIL to ensure that
metadata reads do not fail due to memory pressure.

Both functions eventually call grow_dev_folio(), which is why we
handle the __GFP_NOFAIL logic there. xfs_buf_alloc_backing_mem()
has similar logic, but XFS manages its own metadata, allowing it
to use vmalloc for memory allocation.

ext4 Direct I/O has already switched to iomap, and patches to
support iomap for Buffered I/O are currently under iteration.

But as far as I know, iomap does not support metadata, and XFS does not
use iomap to read metadata either.

Am I missing something here?


-- 
With Best Regards,
Baokun Li


