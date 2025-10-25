Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 098E6CCF9E3
	for <linux-mm@archiver.kernel.org>; Sat, 25 Oct 2025 06:34:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 690B88E013E; Sat, 25 Oct 2025 02:34:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 667CC8E0135; Sat, 25 Oct 2025 02:34:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A4D78E013E; Sat, 25 Oct 2025 02:34:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4B8B68E0135
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 02:34:22 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E7D2A8969D
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 06:34:21 +0000 (UTC)
X-FDA: 84035672322.21.C093A6B
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4DB89A0006
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 06:34:17 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	spf=pass (imf15.hostedemail.com: domain of libaokun@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=libaokun@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761374060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sJPQP7o2P1zUzIFg5kKpIroyc7yHZ9f72lY2MSOC+a0=;
	b=dvqXAtyz52zf7dXvkeZXQzvLDw0rgyFB2HfHG9SIQoQai152ofvCXJFReYdiXcs3kPQQsK
	ouyafOZa90gERiRF+P/gNwHcP+X326r3LIYUL34dfFNOXPFQcPJSmwMXV0mjq7NA7C+r2m
	mNZiDoPh1qHS9vbSNtcU2LW9XOToqr4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761374060; a=rsa-sha256;
	cv=none;
	b=JiIYHskn9+MQM+nlIG7QCPDEC2KxBfvSRAKhIna1Xypy+yOCLv36hyNWA+gGt4xA3drIoD
	Nxdqm3u3eM/VtVpYF151i99z1vIKXEPYV4ZkUOk+9agEXy+hfpov2v/dbC3csXz4VvqnZN
	QynqR+bw9ZojladV5/DMuIk+Ag2zHaA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of libaokun@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=libaokun@huaweicloud.com;
	dmarc=none
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4ctqhp3jT8zKHLyn
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 14:33:14 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 68B7A1A1982
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 14:34:06 +0800 (CST)
Received: from [10.174.178.254] (unknown [10.174.178.254])
	by APP2 (Coremail) with SMTP id Syh0CgBXrUVdb_xoutIpBg--.48673S3;
	Sat, 25 Oct 2025 14:34:06 +0800 (CST)
Message-ID: <26839410-f131-4a7b-857e-c0c159981a83@huaweicloud.com>
Date: Sat, 25 Oct 2025 14:34:05 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Baokun Li <libaokun@huaweicloud.com>
Subject: Re: [PATCH 22/25] fs/buffer: prevent WARN_ON in
 __alloc_pages_slowpath() when BS > PS
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
Content-Language: en-GB
In-Reply-To: <aPxV6QnXu-OufSDH@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:Syh0CgBXrUVdb_xoutIpBg--.48673S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Kw4ktw47Kw13CF47Zr43Wrg_yoW8Jw4xpF
	WvkF1IqFykJr1kZF1kZw13JFyak3y8JF4UCay7t3sxuFn8Ja4agrsFk3WFkFySkryUAw10
	qFWxtrZ7u3ZxA37anT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvYb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS
	14v26r4a6rW5MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8
	ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
	0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_
	Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x07
	j4eHgUUUUU=
X-CM-SenderInfo: 5olet0hnxqqx5xdzvxpfor3voofrz/1tbiAgAMBWj7Ua9PfQABsV
X-Rspamd-Server: rspam05
X-Stat-Signature: qby8r3gb3mezfqekygtqa57knfifc1cg
X-Rspam-User: 
X-Rspamd-Queue-Id: 4DB89A0006
X-HE-Tag: 1761374057-511186
X-HE-Meta: U2FsdGVkX18njg2+cM5d4BM6WiOEGE1qEA0eysTV/y176lh1X2d1m+pohps8mpveoVmz7/MZBO2KYwlSdRE7i648iqDLa5gB48bE6kh5CoxShjxMgeL8+Wll6EPSk92Uj6nBrrUzzAIUjK77YFEWuGHbrMkKyViqJdDFWKQzKD3W0vHghSvEysU+dVCS8IWnr3Jc42MVr6nHaJ6RPmCC36l5nCOM/kIIRl6LDgfbF91wAwr6TSH6CHZWMFG+5TQ/J8P1CTNqAnglDYTynizD10e3ta8oe69SL+1uM1R9WfhOZxCwHQOxga9tQkPBOYlwv3hs4+/k+xzpoZUFPFrsn1uRyHSWtoqbZQB9Yf4qt4C0httL4s74A9lP6IGc5GOxkhA7NdOzf6pSDxDurVmlsx1Bq6bhCmu+YYfpS3N31AQGPF96pA3UZYwfw5eFH5vKd1hWfnF2wu2UrGAtkadhTglrmLA7Xauo+BzavOjVCRMDaXGVFQu6VUbRpve42Nw+ybWn9Vw2nuq0RngmElNbQb2lLTBrI9RLAB9lbwmdn1xJNfo4znZWQ3MI69ZETpN7RVQt5K0xzFm3PDHaTnpSvSBxlf/zPbeu7uA2Qp83XT7uA814NVjF4BFb0qGQmWpvUlyOrJrSPdqjz4irw82bkPfq7NBb/5MvV2TqVXN3fzX64LbfioVcRAxRWkDfEyV04nKMqc2ZhJ54mTfEJPMa4YdBIc53T8YMoi0jgMd+TCqwHrKiXObCMwAnQGvCr6zwPG/0NH7NTmu/eEVZAHPlWeJDNkTuOG9+o5WbWkmxUD4Anb97uBLNp37hQJf/k69LI1e4sdmj+ah3kmpoIPAsIqONETa9/ReVyFuqeIhnSiAzpwAE4DPqPj6kVf4EnC15i2uih7+7mALSgrxyDtcAm/uJK26RJqof3IdS3uMExIPSVyLI5CPs5/gBlk23ERJ3GWTShaMXiNIION+sdy/
 1R1WqBAU
 FKvIiCHJlvegBKM5TTeDVISvJCWTIVHNmUU1v+ee0N6Gte3dn0ObhZgdzILKCEeEtUbjbLkgI57ixMuUI96mowyTn+Om+NHtSkoQumYExXIa+qLqDCNYF28kwlZFak30wOcaL3X8aeJGagbnkESHRViRzrf9t4ktbxkDClTHJBJqybynREnQirI1mAuIIQYF0/aPS
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


