Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04A51CCD1BF
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 07:02:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BE8C8E0017; Wed, 22 Oct 2025 03:02:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5963E8E0002; Wed, 22 Oct 2025 03:02:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D2BB8E0017; Wed, 22 Oct 2025 03:02:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3959A8E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 03:02:06 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D477C1407C9
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 07:02:05 +0000 (UTC)
X-FDA: 84024855810.19.3E696D1
Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	by imf13.hostedemail.com (Postfix) with ESMTP id E49C52000D
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 07:02:02 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=hLYeRF9L;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf13.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761116524; a=rsa-sha256;
	cv=none;
	b=4tiRVw/vemU0Qvm9kOxj77voi+0pEcySpZbM8OErpxEjVrcIvIw4L+DLcNzKFX6rM4r4By
	vAHB1m1JpliiY8ZWV/eF6+VyvHWGy/IrWECljjXiEv5LofY3/6lHTiaO8RJeeq2YQOhXtc
	gx8EHttlEF1oMMzyjstUH2WxKaXc2qs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=hLYeRF9L;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf13.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761116524;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EHRP3uMAXDZCSqG6N+1vlxdAszjhwtbW5deaNWABMWQ=;
	b=s33JtNU7yhXIMBO0mn8UEpl9d81R3HpJJMJaF9IlrYrzaduZGlh0kR7qrzIddJxkTBk9Fn
	RdFnSNa2giUmXIWQ8//XBe5aFUgIHJHlQ+0KMdJcx9fbVBD3Mps50Eh1HEEvsiYgalkwRA
	z81tjmgcgfTFpMi60yjtn/pNCeEbqT4=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=EHRP3uMAXDZCSqG6N+1vlxdAszjhwtbW5deaNWABMWQ=;
	b=hLYeRF9L/tbm9BwldRUCM0HeZZginJ4h9+WkMWqRPxsH4LOMDzdz4E90zWmQoRNClMEbzpw6P
	HhjKSYDkRwZ2uCj7ymzFT6szIKGDFnNRZM+ap2hGY40M4HwKRxDqZ/Ya2/Isgg0s0kqfxqwWzTv
	pfyvUnykgL7dyh/ykueDH9I=
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4cs0Ss0Xn4zmV66;
	Wed, 22 Oct 2025 15:01:33 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 8B80A18001B;
	Wed, 22 Oct 2025 15:01:57 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 22 Oct 2025 15:01:57 +0800
Received: from [10.173.125.37] (10.173.125.37) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 22 Oct 2025 15:01:49 +0800
Subject: Re: [PATCH v3] mm/huge_memory: do not change split_huge_page*()
 target order silently.
To: Zi Yan <ziy@nvidia.com>
CC: <akpm@linux-foundation.org>, <mcgrof@kernel.org>,
	<nao.horiguchi@gmail.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett"
	<Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, Ryan Roberts
	<ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, "Matthew Wilcox
 (Oracle)" <willy@infradead.org>, Wei Yang <richard.weiyang@gmail.com>,
	<linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <stable@vger.kernel.org>, Pankaj Raghav
	<p.raghav@samsung.com>, <david@redhat.com>, <jane.chu@oracle.com>,
	<kernel@pankajraghav.com>,
	<syzbot+e6367ea2fdab6ed46056@syzkaller.appspotmail.com>,
	<syzkaller-bugs@googlegroups.com>
References: <20251017013630.139907-1-ziy@nvidia.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <73c5557a-bc84-e1aa-d5d0-ad0ae57b55bb@huawei.com>
Date: Wed, 22 Oct 2025 15:01:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20251017013630.139907-1-ziy@nvidia.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.125.37]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E49C52000D
X-Stat-Signature: yeewe8656juj1byrh7bx7hgw1awhqqf1
X-HE-Tag: 1761116522-402666
X-HE-Meta: U2FsdGVkX193FPWA/jsNNQG3JyKD26opn+7iLbbQtH9vXfHkAdZCWf+qBcwLiaYtW7yG0zFYZLVBe9doNIAE4C+6xxNrTVX8LsAAArWHzrsQ8wsuIb8Nj/pNvLi+IPV3vJ4M+RibR9zRqVqtFqA6BDPbPbnaJi+w3kgmglkCKCXO73qXQUVRekIzaumjyvhDgyCvpEajyh5Yo5erGe6N4WCcGd4J7D2uSYrmYVYSitq3rhc54wQfxH1tbmaxdIBWMLVIhH8lVR1SrRPCumwelzKq9IDqoXGq3SSEOMVvtd5j+M31gE7gezkYWVQY91zVafV1v1FDa9KfuX2pe//KLBL0TybyrwdugCDqh1cz8G2jTskWpYvFZRz5FzZAheeDSn+NHOQ6hbAyqLrgP+SmotUU/NMs6ZbAPW3t//95Yra8WKGx9Flh0hdI98dSF6OyYwWhgFwbiJ57ywb224nrxtk1zbxO1z6rZccssZAjgD14Ldb7DCIbhhWYii+j3bI5WS64GaWMKT9mLbohk2u3teEGZVuqNRoCgb4hOo4gwX83fAGAeN36zjX4cMRxJ/FX6/SwGCTpnYZChlO9Kl81vNGAujhcw4coYiaj7rPbUb3zVu+DnOy/1gOWjLIeSs4siNP7GvLyP+cA9D5IQVJIUGYclFvmqHARpQjF3ELBxVClSY2gAqx8gZdGlMZaULUc5HISeVZWlJty/dyHFz5bRjB25kmjJUrmd+O1cppanRdbLf3OY4p0IyldNZHb2xKX9iBvmMWNehkZuIEZ22h1CSRvVaknd8zcOtJL3jz5pRXD4Kv825Pz9GY69fn8woNNdh+KbkJuO4mjPClDYRVaVr1rgYatARJFh0udW4XTvHoJswUd6T9Aj7PgkM/TyJJIL33XSARNL9ihcfW8421mZZlD6nmK5uQ/ddBl0bNxLriZylRAqFjNXb2VrbeXz2EwF8TtoJ29qSVIeUEgHmz
 bjN8IDWn
 0KmJLokkNBbXOJQtQ88pnUGp4NsN34u4T8dTZ9C+Uy5SjslxEfnyUPV47jpUti+3jQYHqpt5vCMTKVftsZPrxyRBc/tSPwuAjCq+MBNjVqdPhcBBmzAewPLguUPsTAWjPqU/hiMVvqiHM2+y4VMSAN7nIdCsASzDZIZIW8mTFzrVZPc6XmRHohBeUvr59P+MHmCBcLJAfjmctByEYLkXWjMzLdcnEIASoEQ2wsTeZnPmshULcxJEGiTs0EsP0iEUbFTlWI6+v5nuDPzXPBzWKrNHtqAvAiKQXjMS1QN2J0CjE8Zj2EJzoDlaUwEdv080oQUKrDZR2zwb+SPX728WtrKoTnNZxArS3eXyqa2kf1qtCQQROm84mtkVI2PyezzRmy9qZI6S3ZYpq/NkFpaoBRGBfE1zFpcU+CMWzGpAkojulZ3sYzne8PFTo5XKPtErAMTrRZAf1TkcVABx8VQNTmaOcJ5oTRrsPdkjYtVc4xq7K1nwq9PuNocND7CJ9UxNZQKR+1KNhr0wNyzU/SW8/xJ9GLzgvZmKC4kBz+fMXBg56EmLIWXCZuZSpdgA5PHiIWEcDDrkt6k+roDrg2xYjJQvNLu5+CkzOOvEIkptidJSFPqo86fkpNkHXNg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025/10/17 9:36, Zi Yan wrote:
> Page cache folios from a file system that support large block size (LBS)
> can have minimal folio order greater than 0, thus a high order folio might
> not be able to be split down to order-0. Commit e220917fa507 ("mm: split a
> folio in minimum folio order chunks") bumps the target order of
> split_huge_page*() to the minimum allowed order when splitting a LBS folio.
> This causes confusion for some split_huge_page*() callers like memory
> failure handling code, since they expect after-split folios all have
> order-0 when split succeeds but in reality get min_order_for_split() order
> folios and give warnings.
> 
> Fix it by failing a split if the folio cannot be split to the target order.
> Rename try_folio_split() to try_folio_split_to_order() to reflect the added
> new_order parameter. Remove its unused list parameter.
> 
> Fixes: e220917fa507 ("mm: split a folio in minimum folio order chunks")
> [The test poisons LBS folios, which cannot be split to order-0 folios, and
> also tries to poison all memory. The non split LBS folios take more memory
> than the test anticipated, leading to OOM. The patch fixed the kernel
> warning and the test needs some change to avoid OOM.]
> Reported-by: syzbot+e6367ea2fdab6ed46056@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/all/68d2c943.a70a0220.1b52b.02b3.GAE@google.com/
> Cc: stable@vger.kernel.org
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
> Reviewed-by: Pankaj Raghav <p.raghav@samsung.com>
> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

Thanks for your patch. LGTM.

Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>

Thanks.
.

