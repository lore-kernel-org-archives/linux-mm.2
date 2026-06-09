Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C061CD8C85
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 06:35:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6A276B0005; Tue,  9 Jun 2026 02:35:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1A9B6B0088; Tue,  9 Jun 2026 02:35:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A091B6B008A; Tue,  9 Jun 2026 02:35:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8D5E96B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 02:35:03 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 39A7EC1BE6
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 06:35:03 +0000 (UTC)
X-FDA: 84859411686.10.FFAFA70
Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6A7734000D
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 06:34:58 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="XpLfG/h8";
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf27.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780986901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I89KtEaT7df8OSytUsfnuJ9NdkGMGWdnduwTEcuYKfU=;
	b=JOM6ziTLA6XVDUnZzRs/87Fvrau2bTf3LDVO3eKkqbU7HIsCfluncI/wYfJyx/z5ukaFTe
	mHtJqjohe8wevykhm66hmwywyBEkP+Rw9JmHfeM84Zb8iBwq/Ygp4bYb1UmlKPLpwkQHnd
	ckw1MuA8d6EvGdAUtUJqfSuCrnNLl9g=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="XpLfG/h8";
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf27.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780986901;
	b=yJ8S96p8q+vUXRMfaHWFJ8S6zWRWFEhxkvlOGt6UpUuwESl1lJDLbgD55WPsrcvU+Ln2AD
	F6UEIPNvvKY5jQDsJ0i4jtROPqsyJPvhJa4mnRB57DSiNyW8V/7U+Mva+ZENsPeut0/vxh
	6Za2o+7faa4E5a1ssWpSocwTLE+S63I=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=I89KtEaT7df8OSytUsfnuJ9NdkGMGWdnduwTEcuYKfU=;
	b=XpLfG/h8VOTC6DoZc/A5deHFrg8CMyUcUuJrRjSSJLx/xRJREyG5OUYnaPMCcXfptpAE32VzO
	P8Xk2pkuhNz0jgtUD0ttT+MTCb6xAAjLy24GfWDPWphsDJy9NzMR179Tv8wl8TZBAVob+9kfG30
	peiJZz4F91NJqOUtvjfkVR4=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4gZJpr5QslznTc6;
	Tue,  9 Jun 2026 14:27:00 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 7F52B40539;
	Tue,  9 Jun 2026 14:34:50 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 9 Jun 2026 14:34:50 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 9 Jun 2026 14:34:48 +0800
Subject: Re: [PATCH v5 2/4] mm/memory-failure: set has_hwpoisoned flags on
 dissolved HugeTLB folio
To: Jiaqi Yan <jiaqiyan@google.com>
CC: <osalvador@suse.de>, <lorenzo.stoakes@oracle.com>, <jackmanb@google.com>,
	<hannes@cmpxchg.org>, <nao.horiguchi@gmail.com>, <david@kernel.org>,
	<william.roche@oracle.com>, <tony.luck@intel.com>,
	<wangkefeng.wang@huawei.com>, <jane.chu@oracle.com>,
	<akpm@linux-foundation.org>, <muchun.song@linux.dev>, <liam@infradead.org>,
	<rientjes@google.com>, <duenwen@google.com>, <jthoughton@google.com>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <vbabka@suse.cz>,
	<rppt@kernel.org>, <shuah@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>, <boudewijn@delta-utec.com>, <ljs@kernel.org>,
	<osalvador@kernel.org>, <ziy@nvidia.com>, <harry.yoo@oracle.com>,
	<willy@infradead.org>
References: <20260531055829.3636554-1-jiaqiyan@google.com>
 <20260531055829.3636554-3-jiaqiyan@google.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <7bc9d2fa-48ca-9fff-65fd-87875310db1c@huawei.com>
Date: Tue, 9 Jun 2026 14:34:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20260531055829.3636554-3-jiaqiyan@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6A7734000D
X-Stat-Signature: gjbwdm8115u9mgsornodktbx7qy6dyua
X-Rspam-User: 
X-HE-Tag: 1780986898-30341
X-HE-Meta: U2FsdGVkX1+928wlgppZoEPLIXpVysWlj75qTVvsbIk2bC2yhPAuIhd+gFa2rrH8ZNcJFbqOWI0zRykD0YOvWEkr9k8nJPW7MgFDruYriRnfAQyCCRohEz++VTpytJtSELP1dFABkHJpe12pBUKT+p2gUtPaHZ6HnJpM7sGCkOGqLAd9qrowpqYkItf2cwzpD6uWDya9e5cL2BDQ4pjvGNZ7mbiKnLZE4kogxExfuikfAfbPYaSsuI4kjkWPDg0cxs1PuZrXw5NDAkjOPY6fEln0mmi+GGoKlx5xCw4SPcs5Ns8NyaXs0zhC6uDX754H1Q9yqaBPMAJ6qRE9xORuCZTuBhBeVL4Nu0W2xnLRX+Szhv39sGw9eYMqnvv4iP2sxtBqQQzQdide0HzhlNDUajvbNDqOWu+QIdptOiscGz7WQNX8ufj7oFiE7SiQFDuGRYaamnOGUw13aID2eUUjnTQQWnJnhgigeyHGVJ7zs6Lov+8ml19vZWdWxJJo/pKzFSngUcLsra+Yq6NreQXy1hjZE3ow3Dig3ds1jdS/ASwfjPE08Ox765O0q3JF9GtxaZDiTiuD1bELro9czXjjCVpVvE9NYNQyTqYInTGZ0tB3zzwDIKmhryqHO4qNT8QvblFIVbXVfoBTxIdBEa+VMl+X+qyh/cuWnyijhUDTiKWl55v52rwUU3ODHRjMrmqyt+nmuc30BEnizlQlIq3KPXk4Af6QOISqnn7caxx3WZaAXmBAQQZZwKCPq1dV27TxpKS+97NucAYGYw+XyzEIw6AWHHQ1OK0TAd1fX0kJZ+Sz/fEmS53f2vZL656CBXJZ8+4MR83h5+X3s8i2Ve0I8VxTGjAajjgOD/tSJr/xGOBsG2lgW19/2lodqiIX3l83q3UHh6LK/vCkdsPbDaXREKTOyUU0/mIDwdok5pIRAIT8Qqy6fumpfKZv8I6fPvfi77TFgD4ARstiq+NPZCh
 brp99LK9
 lHjNftrHsIvLsOybuALmKtAsM7ilpr+kOISJgOKD9a15USJycMenulQZmPfnnIFouGwiVRnaCW0oFJiX/aN4WkSiHIylqPSTqCa28zLlQv3ddBp1o5khWKNhrafkCQwP92qs58Wl0ijJpYb1Dbw2YIdZ0+q3gL/cKCzIpS/9ZegN71Otf6o1R3cyb2d6vQlw8XO0YLbJAgHSJFAABmWt1refNWlMtm5kpWKPe3aVFYjw1MuaFHs2tyDngWTqRAWNG0DMn8K9AgmqGZSzjFC68ls5i/j2ifpVk0fdUxM8snpVAZORiKT3koQ8EchwP/wy7veYBMmF7bx80JqLdEAcGa91HMDRjsJQX23AmoxvNTQcuywsjVABhXKzyJSu9xY+S06WeJAqxd4l3QQVnuUWcsXvp5RjXfyb0dLW+n0rTCwcXvJ0gBAn9LhHn7L2VcmBgTAYF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/5/31 13:58, Jiaqi Yan wrote:
> When a free HWPoison HugeTLB folio is dissolved, it becomes
> non-HugeTLB and is released to buddy allocator as a high-order
> folio.
> 
> Set has_hwpoisoned flags on the high-order folio so that buddy
> allocator can tell that it contains certain HWPoison page(s),
> and can handle it specially with free_has_hwpoisoned().
> 
> Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>

Acked-by: Miaohe Lin <linmiaohe@huawei.com>

Thanks.
.


