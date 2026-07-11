Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 876EEC44501
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 08:13:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3493B6B0005; Sat, 11 Jul 2026 04:13:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D2BA6B0088; Sat, 11 Jul 2026 04:13:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19AAE6B008A; Sat, 11 Jul 2026 04:13:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E95376B0005
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 04:13:32 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 658291C3B7D
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 08:13:32 +0000 (UTC)
X-FDA: 84975781464.20.E83B882
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf04.hostedemail.com (Postfix) with ESMTP id 37B3B40002
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 08:13:28 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=xw9nzOU5;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf04.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783757610;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RivUc5YUXnOdUgRz0a+Ib/89lZt+K/9x14yXx6ELMXI=;
	b=vfjOVjkKlL7MSEH4WCEHYd05JMN/XQb+J2UVbqR80YBoynfssUXi49VIkbOFmSPtckm09s
	WZVkEoKWU5TiVhryF7TSk8sAWiengk7b4164j5vVaiRNFywzAlwJKwtCTgohYXy336yCGy
	m2QebP+4m/ttCgnVG59efrE6olJK9Zw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=xw9nzOU5;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf04.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783757610;
	b=SNTKoNSpInmYsPmIaJRMasOnIAC8P+Il5fYnJ3+NABPVefaOvSeWPRWCbEU546ln9zeUZI
	/pgJqGAqbNjUS+ns0FyDzCkr5h25xssRazabdehQuW9jIy1T8waLq0dKW0syEWJOdVsRkc
	4nCTt75Vfzw3ud2TBcHQWOQ4Wmt5Pco=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=RivUc5YUXnOdUgRz0a+Ib/89lZt+K/9x14yXx6ELMXI=;
	b=xw9nzOU534pfyhWOzj9pKap8q4607bkkToe3Ipnkb6QWR+MDZTi9e3O/H+gkxG0muwtB62cmy
	590BeUAhjDQbde2s0E8aqoxW1fmQ4KWS6jkFNgDjFuif9yo4slxZHN8h5FhDdby0SSxkWEGjE0z
	aOQke9SiLgZeI4qAHKPdblw=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4gy1S444tjz1prLT;
	Sat, 11 Jul 2026 16:04:04 +0800 (CST)
Received: from kwepemj100009.china.huawei.com (unknown [7.202.194.3])
	by mail.maildlp.com (Postfix) with ESMTPS id 647634057D;
	Sat, 11 Jul 2026 16:13:22 +0800 (CST)
Received: from DESKTOP-A37P9LK.huawei.com (10.67.109.17) by
 kwepemj100009.china.huawei.com (7.202.194.3) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Sat, 11 Jul 2026 16:13:21 +0800
From: Xie Yuanbin <xieyuanbin1@huawei.com>
To: <ljs@kernel.org>, <linux@armlinux.org.uk>
CC: <akpm@linux-foundation.org>, <david@kernel.org>, <liam@infradead.org>,
	<liaohua4@huawei.com>, <lilinjie8@huawei.com>, <linusw@kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <mhocko@suse.com>, <rppt@kernel.org>,
	<sunnanyong@huawei.com>, <surenb@google.com>, <vbabka@kernel.org>,
	<wangkefeng.wang@huawei.com>, <xieyuanbin1@huawei.com>, <xiqi2@huawei.com>
Subject: Re: [PATCH v3 1/2] ARM: mm: fix use-after-free in __do_user_fault() under CONFIG_DEBUG_USER
Date: Sat, 11 Jul 2026 16:13:03 +0800
Message-ID: <20260711081303.5472-1-xieyuanbin1@huawei.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <alH4-zEWkSDK5EvK@lucifer>
References: <alH4-zEWkSDK5EvK@lucifer>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.67.109.17]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemj100009.china.huawei.com (7.202.194.3)
X-Stat-Signature: u7iox93xt7qau8pwiponh1hh77fuq8pu
X-Rspamd-Queue-Id: 37B3B40002
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783757608-261028
X-HE-Meta: U2FsdGVkX18sc4fa+HiWRKc/8W366Ssxa7w2jpAe2fLdWfhmahi1WShYZYZW/ZhSbtd6KgX6xZODk29cfIA5fO80+XPNSCO8rtvWxJURa0VVUgt4v8W7sLEdKiOEIxBDmwL4qfTyO00h4vDUaYJcOK9Ckq4eGd6XeAocyioDhKuItglVMzERwoh1NAJYksK/lU/MRn0fI5uupqlHqsFtfRW/iz7e7QN+UrsTdMe7OpkM7PrQgztcn11z9JT8pd0vE80Vp4UEsZJ4UiSYDioS4/39FyU+av0oeIUUspGJE/if3JDgvKOY7ETUEwb6A44toW9q3iVscC3zoJFqdl/z+AxMGcK4DdMehBXd1ZRCWyjEdwN1hQkLqBjmBcqAc0TInx9xp9IV4X2NUVD0G29t5nyqmJXT2EH9IqOO1hqQyn53qtMX6HoBPrjW84pmyg05ZoQPF5GoQzGb1DHyKsdTJ/3ytoNDClDSWnuLgf7AhDMD+wrD7Cb1Qffb8M0mDUPE7Rb5IuunVwnF6/ZQuUWcM1TCtXiegGIEemSOK69OC5MxYrkOShBlyIo3hBpntOKqfpv/g71ZcexMWcGfkh4oN8ccAhdINfFmXtBrDKdc/tRu13DarnVox2baWKwvGKfTwBxsN039gpOGuOg8mJC1JjWgHnzOpx+P1m0hYvy7WaXt7drS6tuMMukpWr8+idm0rfRUIkIgFeKoRS7Ee+/2XSW3D1vR9jlwmt8UOWF4cH+HZGJLResPykm0SPrgdA8T9beH3UqdL3yqWkZ+LF551ilrBEudIvfmTkVyNgm2q17dT7f92JdwNctx7Nn1tEFdZkKhOO4seTQ6Rot/ZS9e8UeRsBt4RK80rrtlmY8wIPlggltWVIixsErpHVyOztBMzuxfcj3xshcCgU3zGHP0LgsV0LuczAlILyYtRiiVPgr1f2GG2Js1ingNeHMQoLlT3aWYeb4GahPU+vzgO8A
 6Fxwhv1p
 hPKHtkaljh8fxulZaAfA8ukvDGkCenZXW/3d7yPFMGA3ftOkqKkI5ooytQL+greqhMrJMWi2UJPYpow7ho180+I/onZOmPmRSkFAcBpjniyRONhaIPMpaMvNOSN0Uhy4FP25w+WinmaX33GJJON1M8e73A56VYZXSEvSSe/pLNFbZD1Ncu4h9jU7yrGJSBR0bTTdKgojs/270SmzvkrFebMwxv+CA7CnNWfX3LAsW53QRyVFsfw1Os/lMNAJmfnO6355WhXN3polEtms/xAXI5fzJN3/nMj7B0KDAHPW4M7Ck9OGDnhOMGXqt99hA9hXPDxHS4eKWaf1GxF8Z12HJ0fMpmw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 11 Jul 2026 09:05:03 +0100, Lorenzo Stoakes wrote:
> OK given arm32 can't do any of the stuff that makes kernel faults an issue, and
> if it's certain you can't deadlock on mmap write lock for VMA or non-VMA ranges
> on user fault, then no need for the mmap write trylock, and just take the mmap
> write lock unconditionally for user faults, and no lock for kernel faults I
> guess?

Yes, that's exactly what I think. We are waiting for ARM's maintainer Russell King
to confirm, and then we will send out the new patch. :)

