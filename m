Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4270D606A33E
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 14:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bTQamDpG
Received: by kanga.kvack.org (Postfix)
	id 504786B05CB; Thu, 12 Nov 2026 09:46:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DBAB6B05CD; Thu, 12 Nov 2026 09:46:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F13F6B05D2; Thu, 12 Nov 2026 09:46:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 177FB6B05CB
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:46:56 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A50BCC05E9
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:46:55 +0000 (UTC)
X-FDA: 85426743990.27.B75400D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id AADC540003
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:46:53 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bTQamDpG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794494813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6YweJ4ATSwAQpdC3B4Lj/lC1Mz6y+Skt6vUq+MxWglk=;
	b=bdRAaCiHQC9HlqS4Y/78lDj+AUiqO8DwwlZ3r44bmhKvZc78R2QLXboVvGd18iwbZOsC65
	VFZDahze6IwIYxuvmepMHkvo8Zi0twIPESB21CGQQ+xiSttUdOMAFqdzKPo58kYmiHO3MG
	a5grng3brnAdPKxtHlZsLzf0kHqzOjc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bTQamDpG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794494813;
	b=7qSApkKzGzIX7WFOJJxBgGFeWojTUK8gms6BANnYIfCEPTukap8DBl0regcR845WV85hwK
	EPR0JmJph8uUoZ9TDA3fkqH2d7BSGrL3ZCFROYgu3NV8o6ORGeoEzH7xhaJRR5MqKQLgO3
	mH+py5SNtKY7GRqUEH1XVVr/u4fmu5M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C64EE45904;
	Thu, 12 Nov 2026 14:46:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00FE11F00A08;
	Thu, 12 Nov 2026 14:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794494812;
	bh=6YweJ4ATSwAQpdC3B4Lj/lC1Mz6y+Skt6vUq+MxWglk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bTQamDpGyMVV2YlIgDlfQjG/7pUPOU4QeYaMTeXznWGJXoiS7thfxwzGVRpGzm9iE
	 8Uwirs5X9SIBjpT7kPq3KwVzKRZ8wfKiCZlPDd3U0Iu40ai166PKHxgS+jVshYnOhb
	 fNawnjkGUvZzp9vZaSG1SM9CxqySvd6ii5g5klVF7XuMt4pRXuXA9FxosJ7uFsco+V
	 l2KzibLUym83vzjNnU2UwvPnCRu6H7q38NOjWr3L0TEeL+u0xCgGuz0O8IsX/hZiBC
	 GfwGytMoxz4TL4A9oQvMs33xr9oLcTx/CJQk4x3wWrDC3z9JrbuHOrsz6RrRF0XBEp
	 KLJPI4JyuYGsQ==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.ams.internal (Postfix) with ESMTP id 8F361198003A;
	Thu, 12 Nov 2026 09:46:41 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Thu, 12 Nov 2026 09:46:48 -0500
X-ME-Sender: <xms:UdH1ahpGL7jUPQjkAJRl2JhIaeaGv8tVQ9u6odzUqHPBriRGKQGDJQ>
    <xme:UdH1ahM7OXB0snsMeUK5nrOtiIHoVLQbZBwXBuMbhrqbmw3f71-kFPxpQtHLEZvu6
    oUin6n0C6URjJMIF2bPybPHEczYghBtQigBW_DzRFJhl6a6h5UXfII>
X-ME-Received: <xmr:UdH1avgQkuuFdq9uQ9SCs9qSpEBoDeprsnjzqhAR-9vUxe64so3jh43n8hk>
X-ME-Proxy-Cause: dmFkZTFZXCPOdpgoG7Sn06VYsFtSSOVX4LvRR+IZONGtpob6pMpAAKO/67brjXXiKC/yqt
    PCnhbCbvHUOoVYCNT4kVjuveGw+dXvIprFD/YACgqbtnel/TmFMV6qGskDYUa0P8h3Od75
    wrI/nnPxoscSdAEJx1gJYLeSoSvZIyEQFlDGL5x+GpMb1jaNZHzRlgCV+E3Cu8RgWJK+9e
    BsDvN+pM4I2WWFu/gxlAAso9/LyfSk55MURq7DRxPKfBR2AVy6mcitcvb8EC1zSjecqXVf
    g8U8l32ogRWuJQCndXaeCOZwVCIK7+RsqRc8uDYNYEtot18m3Tu+IX07SgfKp5VRUjIyKq
    j4kRNug8fCs72e2RK9boHuMIh2JZ2XGBklGuD+2DcGj8tYzVQHHJKtbfASFUEPwIHpjkku
    ddqC/C4SI0gyTEpk8FijU2gaINJFeT694ExXq6/ngFUlw3HIIY6+v7r73xIaxSms06tpPO
    nGsI30IFUeVVAVDvEK5+uPDFKoT3d9REgtvDz81UtDvHituV7gsg+SWaOEuojwNplJ7/Tm
    ZJ0jfo/LKbuo4HKiPIt5GP+SpqH9xe5udyuOJJ05B1Zk28PZ5NEzrTNwbYVTLi1kDLBMg7
    FPj3L2omtFfHnSqwIyGqJobSo5ulLYr3DB3ZddEHBuAgoVg1iuVmNWmOxWhw
X-ME-Proxy: <xmx:UdH1anSuIXUCB0mZYpoiTtzk9D5vNJQY2WyL_6xOVXXY_1_7K2tQYQ>
    <xmx:UdH1avWiYN6nhjeXMunCKXAjjz_PgW4CnuGRIdT_7Rp3DAyZucq8Ng>
    <xmx:UdH1ap482GbXSt_Cej7PhQkdzn9CopUhK6PaZyDjBgviMlsGbv7GXQ>
    <xmx:UdH1aq8G5E7g7yv1IM7uzeTJkytrcfZkJmB6vvtNuEzUug0B1zLedg>
    <xmx:UdH1ahn4tNaiOyi6IckarLgDd3PwKQQdiZ2nevXMjGI65FM5QHh4nrOR>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 12 Nov 2026 09:46:40 -0500 (EST)
Date: Thu, 12 Nov 2026 14:46:39 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Linus Torvalds <torvalds@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Jan Kara <jack@suse.cz>, Hugh Dickins <hughd@google.com>, 
	Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Harry Yoo <harry@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Oscar Salvador <osalvador@suse.de>, "Liam R. Howlett" <liam@infradead.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
	Luis Chamberlain <mcgrof@kernel.org>, Ilya Gladyshev <ilya.gladyshev@linux.dev>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, linux-mm@kvack.org, kernel-team@meta.com
Subject: Re: [RFC PATCH v2 08/18] mm/compaction: free the migrated folios
 that wait for a grace period
Message-ID: <avXQtaMRRsSNAJcT@thinkstation>
References: <20261104130118.2507513-1-kas@kernel.org>
 <20261104130118.2507513-9-kas@kernel.org>
 <sashiko-outbox-199101@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <sashiko-outbox-199101@kernel.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: AADC540003
X-Stat-Signature: uqc83kqi1drib61rehz86tumope4rbkj
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794494813-305588
X-HE-Meta: U2FsdGVkX18+aUqmskQJsooCw5FX1KZ5AYWZjqkDpVLgkhrRSrnk46EXQ2GhuV3uFDGnvbBlTSu+jtzNt08syz/g+tbnuMmaXIXZmOI/fX4jK1dlteAuzKT8LIv+YeZmEv9SCLNMXHtHTyTKEuISmZjMJU00UspYdFSFZTF9NnGgFTKhyTEvcPINVrbRhZ+NJxGgSK3aqGY2u2tg9eucDMQOxQpE25rvqBkaJQQqvJYxl1FSVhHSIeCihftKwk2eLMahdHLOHpYI9Bal+pSeqOw3ddIzrjzbPbE5+EyIqE5TmUoQ88Py8VaJe1uq/oSE3AF3G5I00Mg0ozpYmliGYq4+yN+FP9WmaRCXzGW8RZh0xXbHLlLJ36ivViY/pBsF40GvV7fkL4MKAgmFvRx6VAlAX6cRLXgYrTN6ErtyIfaXg1S9aq8V1T+LtlCLc1rybcPEr663cqNZfaY80idplrCmFq7HTsijbkyf6S/sYXbr2G7QTm0qFhTx4pj4C+g5ueWfGX15NfdFP4ZpagDng8jMU8qtH+/EbK+Ngkf1UDyVZ9whsuRZY8T77Oj/NnXNaiCveAxiHh6CCWgNZruKNUhgdJUXQfTWAQ0a+VWQpvprKIiqnMWu+pewD61NIRcJN5VFjT/QCFEAR6kNepHfD8HYYyykFgzhoCkQa9/FHn9YMCI/oKG0wU5R76I1HbvVPRw+/AB1r16z+1/gx+dzbpnmz/aDac4HB1+d1lf1qmnKDM/dDEHNKEfFbEvw734a41ZPuIdi7k7Fuuk9aEp/acWMAg95UfExq8ERunOKlrhOtG0pcDhjjLeRJ0j9RcJ/3StqJ8yao/9XlzUB9dwOjo4cekMf11HaNQntDzoSyrR5ptJ3w1HNL3Kyj4sC/FwgXGs8aS83EazcJ3elcBqwoNGDABYxQaLyB5ZTFXfdwr/L1q0CU/Z4lDaAcjn7jX1izm2fVLgrgVirF3ENRr/
 fWGhm3Ft
 7jnrHctkUi48je/hhA/2Dz5fhQrOTvnJc6KfZYlu/gS9knGUaX2Zc6drDHKASDWaFE5U/h+LIDAH66qCJXHSMVBI+RLxMJvO4Y7JDdbTbh9jjqJAUPB6YaXR6PUSdyoKMK1zyyaW1DKe1plOq2Z8gQ0kO/tSfMokkvVq/NxUKxn5ZP6Q/IStzZPPFWkaJLUUEmUeB9FJ3wu9LpOn1ZydRJ7n4qmhW5VNSPdzaBnD2TgHVzUQ037HTwgdzkBmDPqNNYsaY3KGNBNrN4ei/C3WBAAVkrq4f0QX8/isf30QGi0VSzq3WwkgWEhiyJKH7w19CChQBcBCIhNEqDUMusvMRXgYM1SQLNkdCfNwZ8LmswLwtI6Kcupj0fMktpg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 05, 2026 at 01:03:39PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Medium] mm/compaction: compact_zone() misses pages captured in rcu_free_drain()

The capture check misses the same spot without this series:
lru_add_drain_cpu_zone() frees the migrated-from pages from the per-cpu
lists there and can capture the block just the same.

If it is worth fixing, it is a separate compaction patch.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

