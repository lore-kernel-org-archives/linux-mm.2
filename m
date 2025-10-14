Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CAA3CCD187
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 11:34:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D67FA8E00CB; Tue, 14 Oct 2025 07:34:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D186F8E000D; Tue, 14 Oct 2025 07:34:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C07E68E00CB; Tue, 14 Oct 2025 07:34:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AF3C58E000D
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 07:34:10 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 775D0BBCD4
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 11:34:10 +0000 (UTC)
X-FDA: 83996511060.07.2A7E95B
Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	by imf22.hostedemail.com (Postfix) with ESMTP id A166CC0012
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 11:34:07 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=DQJnwFNR;
	spf=pass (imf22.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760441648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=JdNMLRv0GjIEMWCtgcQ7HoIeyMuAmO8DRMnhGuBJI2k=;
	b=DXoZkajeIEsUyxgDDkE6ZvNA7iE+AAcZ+A6cCBZHW6fzjoxzWR9vlGFAvJlE2L53HwxfS7
	7VRBaycIeb3I6SQjHQbEVYvAIbx6hAVysiNeOc+vQ9OZgwRZKZQzdlq5bdOXL8VDRxu38O
	n8vWxf4tvg3D3WQUgT7VAhqvFBDzD0U=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=DQJnwFNR;
	spf=pass (imf22.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760441648; a=rsa-sha256;
	cv=none;
	b=s+CHMDCgNKXSwdnNcXCtJ7Rm8BotOAf04UUNhuE5LX+W1pUg2YwovVuyCw1MPK0OkmuxDY
	8mcM1LIS9SkiVQGMg62mEBePMsKMDaLXvgWYhgOlagM5pKEnDQM/4YaVjs/WS+1Ysz+HB8
	PSHBKrmGJeLA7B6gdabcY8qld3CXiF0=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=JdNMLRv0GjIEMWCtgcQ7HoIeyMuAmO8DRMnhGuBJI2k=;
	b=DQJnwFNRJfNd40hx7ZBKkbw3+eW1X2/B0fkQf4Jo5A/Vl5OPOo8Z2/uwINUFqPlp5UK7v8/S5
	HaJIxL/tLJ35eHGfacaESI+lT/zQ55qhTkTSCHE3kvEaL3SRuLcyUafvdDIjaE8vdwEyhuRHmmv
	12k3QR9AHQia2DTPxdIimHA=
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4cmBtZ2hmczRhS7;
	Tue, 14 Oct 2025 19:33:42 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 48002180B66;
	Tue, 14 Oct 2025 19:34:02 +0800 (CST)
Received: from localhost.localdomain (10.50.87.83) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 14 Oct 2025 19:34:01 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	<linux-mm@kvack.org>
CC: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan
 Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	<Liam.Howlett@oracle.com>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH v2 0/3] mm: some optimizations for prot numa
Date: Tue, 14 Oct 2025 19:33:46 +0800
Message-ID: <20251014113349.2618158-1-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Stat-Signature: o65gk3oor77zi38nhf8aqo7okyuj1i1a
X-Rspamd-Queue-Id: A166CC0012
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760441647-917541
X-HE-Meta: U2FsdGVkX19zCHKEotaFbNaXnHNmNYBezliQAwblnXnPlLDetazf3ucLrbNnX32F/3E9b3G+CutHPc7EYrzhOOtlbjaw25R4bI+3WhTcRmsvJAOElWqhjuRUVO18IefdMgQYb577Y/s6kZpVUxdV+kdKE25AzGMxA4m5cO6J45jbVrP7sVrjA6Tqt66CNU7yqSLZw2fuzk3CkJv0Qy2zgrjmk+EgWZ6hOnR4dy1gpmieEESn1zNgfZhKFX0LefaXkectzjqvvKICIj38ha9URKHLCCfFxZLHGaNUbqlftIxOYQIwxz8FondAijWq8aPf2MbBNVmhzG3s57i8BsBpqrpyn51Tt9bfQGLk6ktXfHoveIWyg9PDhuDV+Z2Eaxp5bQGAKMfCqx4/+UmiA2h279O/gosqziUzjCOlM8ERINj6y0XqMUNLYNvYFFjlv0QrEhaUMi2hC9/fehh9Vlxm1UIMBWo/o6IFVgri/tCVMiEVQxm2wvVCpW+4KyfYzC1dLXfIgUoSBaF3sn80CQfZBoHeL9MnZT8jTWtJwK83tKBT5dbBYLXIXCClVDDfyveHvmStYLzhOvZcEvx905GA8Uj7r+z/CAuHHXN5H3CpgxqZjBZ3vwCoCP2msfk9EqPDyzPYxLE/gyhidDvelvA1aFT9jVIaSQi4D0F2M4eRfQx2zO0ATcvk4P5uDS+TYYpzUiFoXMEGBG7LhYgYpnLqhSSfBNJQ7MGZat/P6teLAUOtFRuqdynlgoWVl4z9+w0qnLhnhDvOMQtQWXDpj2SKbIa6GBSTVhpXYKlDKu3V8Vwde+Vj8/PxSDdX6li7mggV47qgVCXuTwu5+oYUR5AldLpOYcX3w8e4gicu8SwsYC84UslwmZWrjp/UFvrdcO3IBIxkGhsso0awRqONBGAEpTjH6Kf+M7Qs3UolmFwKLn2dQTF1IqKyxklq8ZwvEtb+3h6nRgWM5NoqQfkpkPE
 yKGlKVpZ
 cIqUALSil4EUx14VStXuzPdTDzy9jJSs5KQJRYhgv5SQsC+hSovNS32EjKXRBEGjgT3ewHTvn9zSNeJfi0w4A3G/0Zsw4H2eGWf046MTCN2vSjWcakCRgZT4llZ/uL+vMZzeCoXkmof7joOyDyrrjjGI9ASwXOFSrb1R0cI+GSxAxSoLfVFnD6jGdkEn1+RXDi+ivpwNFpFXJuSQWL3LOI5C/jeWLc1BcIKxR3OqjJNhGh2J3ZgmYz8JMu31xcTs+hYMvn3fw5j91grhe83Zj/W0woCsVJfNpYWgH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

v2
- update comments for pte_protnone() in patch2
- rename prot_numa_skip() to folio_skip_prot_numa() and
  cleanup it a bit
- add RB/ACK

Kefeng Wang (3):
  mm: mprotect: always skip dma pinned folio in prot_numa_skip()
  mm: mprotect: avoid unnecessary struct page accessing if
    pte_protnone()
  mm: huge_memory: use folio_skip_prot_numa() for pmd folio

 mm/huge_memory.c | 21 ++++++----------
 mm/internal.h    |  2 ++
 mm/mprotect.c    | 63 +++++++++++++++++++++---------------------------
 3 files changed, 36 insertions(+), 50 deletions(-)

-- 
2.27.0


