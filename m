Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41E79CCA463
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 07:43:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C4106B008A; Sat, 17 Oct 2026 03:43:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 174F16B008C; Sat, 17 Oct 2026 03:43:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08B386B0092; Sat, 17 Oct 2026 03:43:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DC8D16B008A
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 03:43:16 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 62EED160264
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 07:43:15 +0000 (UTC)
X-FDA: 85331327550.30.F3AAA16
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0501C80006
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 07:43:11 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=bTUs22iq;
	spf=pass (imf30.hostedemail.com: domain of chengzhihao1@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=chengzhihao1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792222993;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Xa7wrZpzGbe9BZSoSeuK0FiGnGIBL2+6xHOdQnRNAQ=;
	b=Pe4JwiCbcBhrDbtBssjMYLf28QAKMAX2dx4bBA0PB2oKQ9tABAld70socD3a+HWS0f1Ijh
	wC3/8O5Xcvf3+ib7spzehltLajXiSSu1CR7PD2Jtb/iQY9YY8iF+arE7SswoWJ1CDVVwdx
	m5ZWjOoQvejmUIQjWbzUaRlmLalMqmM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792222993;
	b=5mW+kAMvRP4QGVeDHoMKsaYHF0z10Y/msVm0NpU1ETxL/rrCGijfetdgp3iJj1WSfFPERt
	p70ykrklG+Cl50FQ+RBp8f1E1aEGORHfvfvgxdMGA95HiVIdJIWa06ARIV96T2Yf43CkQ4
	wgA0JGid+WxIc7KyQeqQXCPKBkhJshA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=bTUs22iq;
	spf=pass (imf30.hostedemail.com: domain of chengzhihao1@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=chengzhihao1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=7Xa7wrZpzGbe9BZSoSeuK0FiGnGIBL2+6xHOdQnRNAQ=;
	b=bTUs22iqp5UbfqcN34dlQW0hyXCkj7jsdSLiCwtJ/Sqb6zcv/sL3UkABoANOlHV4e2rRfbDtQ
	KdJuFxM0q1yldyfqhBEuYM9Piwkkfrwl6SuIkBguAm9AjUSilKqI/wH3Lv+s2QHem5nzpONuDD/
	0/l4+xyy9StCYPN8VGC4Tn4=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4j6DLb6T7mz1T4LX;
	Sat, 17 Oct 2026 15:43:03 +0800 (CST)
Received: from whupemo200011.china.huawei.com (unknown [7.152.185.179])
	by mail.maildlp.com (Postfix) with ESMTPS id 144ED40537;
	Sat, 17 Oct 2026 15:43:06 +0800 (CST)
Received: from [10.174.178.46] (10.174.178.46) by
 whupemo200011.china.huawei.com (7.152.185.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Sat, 17 Oct 2026 15:43:04 +0800
Subject: Re: [PATCH] fs: rotate inodes whose page cache could not be dropped
To: Nikolaos Karaolidis <nick@karaolidis.com>, Christian Brauner
	<brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>
CC: Jan Kara <jack@suse.cz>, Mateusz Guzik <mjguzik@gmail.com>,
	<linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
References: <20261016102515.111285-1-nick@karaolidis.com>
From: Zhihao Cheng <chengzhihao1@huawei.com>
Message-ID: <5b74fceb-dc8d-21ad-d313-eba7a0009056@huawei.com>
Date: Sat, 17 Oct 2026 15:43:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20261016102515.111285-1-nick@karaolidis.com>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.46]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 whupemo200011.china.huawei.com (7.152.185.179)
X-Stat-Signature: 511tt6fbas39x9ama1zrcatnjdbq7cmy
X-Rspam-User: 
X-Rspamd-Queue-Id: 0501C80006
X-Rspamd-Server: rspam10
X-HE-Tag: 1792222991-218246
X-HE-Meta: U2FsdGVkX198CtXvkjqVpZF0sz78HSXXZg3auK/BarCl42nLGhLHrqeQsBf1oUND4IoOaRPNO3xaBaJg6+uvs8ES4eAfkRN3d/fx7rkm/w4N2p3gf/urK87LicXLPHKFA44sjYlrbRIdG/mGP2C7O80iie4hbo1yRzbSqFwyPNrUtKmI1ZrHTrDs7vagzCvYd+y//dZAXnpPUUrDPLWQaT7Dwqh40xtbg0/TPDcvVYWHv5bYMsXYlX0hQidYz+NnNcZ4FSGLDzrUsmDBdqFVzC14BKoa33N0HM98QjUFbVkmoMO5V6wchQvLJIDgWGptFTY3bIagxwI4UYHaSE7WIZMN/Cnv6YXJI83bd1w4Ks6/s0yWysPr6Qe12PfAGpNotfMcvSrtFFtbFEwzWoPtPgECSEj7Hf6ZdLEJ+4UogJfyRwJBf6Ikpbr7SqohFAjlQD2R+nZLOoCfFz9nigVl1ME7xIIna66B9plQ7YOtPUduzceiyBkZynlsBHkarrJGVqfg3OQpoYrYtxoyhBHt4jhsxT/GYm3LqJH4mSQQjZzgmwyUUs94BV+wogvENM/3KAr4y4qSJolQZCfhQtJxdk5siDHuOzGlNYFmmw5wPknvM3QWzJ6kqOc53e/hxp77lYGZNeuQndRhsOECxFQ9GtfIyBQ7C07n7boV1iiJGKwt9TzOFGwKtqidEjoRWMfg21qrgw3xUHcAQWQNA4pfxnBqEQAaO1j9pW/rJvUo3lNs8mEy6uRqs6naSKQYdzPmIH36mEVfWa7c/AP8GMNykwOay9iz0lveE5NV7j0qSdbg2YbzSUUhy0sTicCg5zJEhz+odkGtNwWn19+UR0I1n5layzIF9C+g7f/Ca5OgBtv7EhGa1o8I62U9Jj8mzZbwDwaeBJl5dxo9Ddd6VF3GW270XcalS+TGJt1mkzMM1dw6vJbizipPClouwA4RzzwMtLydVD2Ft6UwlqK/qSe
 fzdYrWrU
 VGAkUun06tG+g6QRh5SuTJTBLevHB33ArHUmJITgkQLVBvskdOPRqYbDLtR6n2nK163Pc22HZnt8HcFhDWcvDgoL0yT+bCvIamVpMIDUkmGd7MP6cbkx3J0IGa/Vdsa9j+21HEbUgvUR2d1nEcR7Gy0xJ3tP5Xo0dUR35fOUq642X8iLQjJTDHfd6aD6sm7Q06YOUZ53ZTN69EdXXKXUYSGf3oF1L5QhxiA4b8CyUv6V6VS12MlE2AugwBvE3swvo5PsNJ9hyHpVBfYxSbI40DSIgcCSm6WHE6uSEmnjFbDgEFfY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

ÔÚ 2026/10/16 18:25, Nikolaos Karaolidis Ð´µÀ:
> When inode_lru_isolate() drops the page cache of an unused inode, it
> has to unlock the list, so it returns LRU_RETRY and the walk restarts
> at the head of the list, where the inode still is. If
> invalidate_mapping_pages() could not empty the mapping, the restarted
> walk strips the same inode again, and so on until nr_to_walk runs out.
> Every walk of that list then ends on this inode, and nothing behind it
> is reclaimed for as long as its cache stays.
[...]
>   static void inode_wait_for_lru_isolating(struct inode *inode)
> @@ -981,7 +980,13 @@ static enum lru_status inode_lru_isolate(struct list_head *item,
>   		else
>   			__count_vm_events(PGINODESTEAL, reap);
>   		mm_account_reclaimed_pages(reap);
> +
> +		spin_lock(&inode->i_lock);
> +		/* The walk restarts here: don't retry leftovers right away */
> +		if (!mapping_empty(&inode->i_data))
> +			inode_state_set(inode, I_REFERENCED);
>   		inode_unpin_lru_isolating(inode);
> +		spin_unlock(&inode->i_lock);
>   		return LRU_RETRY;
>   	}

Hi Nikolaos,
I find a possible BUG_ON if this patch applied, details shown as:
    P1                          P2
prune_icache_sb
  lock(lru->lock)
  inode_lru_isolate
   if (!mapping_empty(&inode->i_data))
    unlock(lru->lock)
    spin_lock(&inode->i_lock)
    inode_state_set(inode, I_REFERENCED)
    inode_unpin_lru_isolating
    spin_unlock(&inode->i_lock)
                          unlink
                           iget_locked // find_inode_fast gets the inode
                           iput
                            iput_final
                             drop = 1
                             evict
                              BUG_ON(inode_state_read_once(inode) != 
(I_FREEING | I_CLEAR))  // inode state with I_REFERENCED

Could that be possible?

