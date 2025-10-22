Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F20ECCD195
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 03:58:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 734FC8E000F; Tue, 21 Oct 2025 23:58:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E49C8E0002; Tue, 21 Oct 2025 23:58:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D3B18E000F; Tue, 21 Oct 2025 23:58:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4A1238E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 23:58:52 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D9A631DF6A4
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 03:58:51 +0000 (UTC)
X-FDA: 84024394062.24.3C6F0D7
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	by imf19.hostedemail.com (Postfix) with ESMTP id 07D131A000A
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 03:58:48 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=hEgpd6Jw;
	spf=pass (imf19.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761105530; a=rsa-sha256;
	cv=none;
	b=BkVI/lNhPDj5BWvM5jayBLB9LvLhVWVvS6V66aKpIXyTQwKDsQYi+lzr396163J1bWnsnl
	iAgAR+glm1SrYPsF75zRpJnz+0V6L3B5IWnqrGVofIARIQ8Pa46/O2jZ7WhqEA0XBm1X2y
	bkSOnMnxgbVH7pjcT7Ptzz+y1mpT+1Q=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=hEgpd6Jw;
	spf=pass (imf19.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761105530;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=km+g0XPH4yDDwLqQ/6BpIJliLoLcAkSlxXyzmPgqKOY=;
	b=eA6Qs9ZWJ8B+DjMkdByS4siEs+gw7trdB3pK2uWgCUDaLchcp6Ypy6bPNVXEmd8ZQdGyGO
	s2XymAxbWVkvD9WsgMmONVmLffrbSYzMJEF0NTOTtlInh3BpDaPa3yuuH7CJhqbNc95u58
	yHjUZdhrck5laGffjWeRTOBzu5ovb1k=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=km+g0XPH4yDDwLqQ/6BpIJliLoLcAkSlxXyzmPgqKOY=;
	b=hEgpd6JwJZ9quWIenfHDoy8zHH1ttczMOU8UzFAFadDe/tw5k8si5ua5TPmAOYpWIWbDBeUYg
	kpi6IRBrHAwfVRscLYxugeW6yhGaVr6NTN63WUwwypBSiV8YywDevppMYx4VTaYhlNDNBpAX1S3
	Nm0SURSZqZT7deMLCWopl/Q=
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4crwPR6f9PzLlVs;
	Wed, 22 Oct 2025 11:58:19 +0800 (CST)
Received: from kwepemj100009.china.huawei.com (unknown [7.202.194.3])
	by mail.maildlp.com (Postfix) with ESMTPS id 5D710140155;
	Wed, 22 Oct 2025 11:58:44 +0800 (CST)
Received: from DESKTOP-A37P9LK.huawei.com (10.67.109.17) by
 kwepemj100009.china.huawei.com (7.202.194.3) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 22 Oct 2025 11:58:43 +0800
From: Xie Yuanbin <xieyuanbin1@huawei.com>
To: <linux@armlinux.org.uk>, <akpm@linux-foundation.org>, <david@redhat.com>,
	<lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, <vbabka@suse.cz>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<linmiaohe@huawei.com>, <nao.horiguchi@gmail.com>,
	<rmk+kernel@armlinux.org.uk>, <ardb@kernel.org>, <nathan@kernel.org>,
	<ebiggers@kernel.org>, <arnd@arndb.de>, <rostedt@goodmis.org>,
	<kees@kernel.org>, <dave@vasilevsky.ca>, <peterz@infradead.org>
CC: <will@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <liaohua4@huawei.com>,
	<lilinjie8@huawei.com>, <xieyuanbin1@huawei.com>
Subject: Re: [RFC PATCH 1/2] ARM: mm: support memory-failure
Date: Wed, 22 Oct 2025 11:58:37 +0800
Message-ID: <20251022035837.1915-1-xieyuanbin1@huawei.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250922021453.3939-1-xieyuanbin1@huawei.com>
References: <20250922021453.3939-1-xieyuanbin1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.67.109.17]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemj100009.china.huawei.com (7.202.194.3)
X-Rspam-User: 
X-Stat-Signature: pf8ehxz8363ibr6gg4ixudajwa6aq8ug
X-Rspamd-Queue-Id: 07D131A000A
X-Rspamd-Server: rspam09
X-HE-Tag: 1761105528-411957
X-HE-Meta: U2FsdGVkX19sWC2jRkvvSq2xsID8jlsnFGaeDEuS7NPhplALrGw9/OJ338zq3jrg8muSZbnYnnkjGRT2GotuzJk8M/8e6BJLiFoceFGHw8CKPfKl82Rl+mj5pa55Dv/Umu5GvmU+2CoVf6iMx+pvYXG1BdDVLr6xf4Zn3eMlb2bwdJm5ZHS+TOI2RFSjun+55TSDsi9wsVh+jawitUtYRcYnYa8fDCjdUMNatPFZGDDMjN1eSehmHly+AX9BnaaRqhhKW7oOeXbLOPGY6Fjm/FaM03DHrRO8RBzX/z30kxJzB3mdfHQ7y18RV+QHk2pb4W/bsgX7Qxd4nz9w7I3aACwMxrOVFFdvURoZEzM3AUWk73kYukpKMV7cnC6pFcR9w7IYzyGQYuzZttyKzDoogIRDzp+lkRAmxw7g9RQcG6mdagrO+rczHkLxa+Jyqk7mK7s8A91vXiCwlaXaaJxgNp0ltlQm1FiMltcM9UIoFsFsJ1SeM37ZCMcZ0DX4dqKtq33bS28Cba3UWX/dPDWERqfn3KXKnqoTvf6C+LB7rmpk1RJq8aKRmd9VmDeuIM4jd2kzq2SsVQXX1lUCE2J3v4uVd2uSI1gQjR3/wavWzCZNbJeb5/uo9GG+8ePYvk5TPd3sFHeCwEwcDjjnAuciS4aP2pB1mo4DQGQYzWB13Es1W+pSRMezShbq1zpG7pBGyPXeCqfgBJ1zN8f/n/tUw1CDx5Sov9uvN5c9eCk19WUVLehe0tEpz86tFXRQ7imkjzYSzNTPxFY70H8CsOrmqLPHVPzB0hFoKnIOErIn4nQLCoJgvr+JK3Nojvd8jKHG5++uYeIaQhUqx/+MvlR8HA5Uip9EUmrd+ezJEnQmquJK/FY58xxGpIIztsJ69l+AbPEC28yT7LM0mTFUdo7JJeh8G4GRVj373tApGLevXFGyJQfL0ys70EzqBYE3EmZdhNRtLDpjV2iOVmKYRFR
 cHn2WaLO
 IBd+ou6BVkfuhwqWg4kju1o6Dw+jy6mdFHV2mlI+Lg3P74ctLKPGYJCvizIKeeZnreXbGXqIimffRhgb7T9DFXlzgF/qVYtSdo9QmsCrkZBA7UVelsfGoMY9YMfGnGXiBX50ZqNGlqdgE/bUmK4FxmTnwQjZZO8DeoQFz/MoiwvkHkaxfiqQXFaAzZalEJwx1FQmdgJg9KaepFvCB7POAywWEgrtLUi41IgclqjvyrWeks9XNMzLPtstS9HdQU2XEwWW6hSogMtAbTvXkgJBeH9HtPZRy+hq3dxl2ocWbF2eAMuUXCjGWRfNxgEacU7aqTBQOMME6KzBcoGXqs6ayr0l+cgWyMY2A8FojAeR9Bh/arP0ozMhhrAu3i86ZoUOAflrx8pyrdqNZ14lh+WL7/AXpAAbVG/uC/fDA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello

These patches seem to have not been discussed for a month.
Does anyone have any other opinions?

https://lore.kernel.org/all/20250923041005.9831-1-xieyuanbin1@huawei.com/t/#u

Xie Yuanbin

