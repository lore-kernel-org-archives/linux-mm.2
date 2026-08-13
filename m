Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 649D4C5CFEB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 07:24:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 561C16B03DE; Thu, 13 Aug 2026 03:24:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 511A86B03DF; Thu, 13 Aug 2026 03:24:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4281B6B03E0; Thu, 13 Aug 2026 03:24:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 151D66B03DE
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 03:24:26 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 856A0C058E
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 07:24:26 +0000 (UTC)
X-FDA: 85095408132.16.0ECB560
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5812120005
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 07:24:23 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=EckspUCc;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf03.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786605864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R4UvSlr/e9eoGGopeqb/bapePxUt4CWhbI/u+CqxUVY=;
	b=DQ3qRX5Jztcimhb67+tNr7JT0FE4M4JkdhXX8vfZIs5ck/UFF8G5TD70U2HqZaTHNWy8Wx
	zy8p99Tg+wgqbNgo5SbTme5O9g4ypV8LUf32co2WIWMI2fSlBchkb249/XMr5wQ6ge6A5H
	Upm31qmIJopiT5yWcAQ/9QfkVZvW+vA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=EckspUCc;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf03.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786605864;
	b=FnmQZ4EnyCXczGLy88dIZCBXmlfQiBSUQkysm26+/hLfuSUM9hiImYpyMZRIy0NTxlx961
	uM4OX1yRITBCOL9mXZC5Ph68+Rh9KOhsrMubEjfrEhr5992BE8fTojBHIJT5ieUDZtDkuV
	4mOkI5zVB2GrBTQRxvIMqLJyBJPMEFQ=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=R4UvSlr/e9eoGGopeqb/bapePxUt4CWhbI/u+CqxUVY=;
	b=EckspUCcfaT8u61q+vPelp66QF5qjUnLvqFqCWT6Lr3CWr8uYtqFSQbp+TsprGlLPiNvk6Pou
	5xDlKtLQnNmQPcCzDuRXhwamHebgRXZ45GmM28qGre5vUznr4Xej/CotQFojCAiFDkx0aNRvd/K
	3bGnC7qfLcCB93ILfnS4TDk=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4hLGmT6MvxzpSvB;
	Thu, 13 Aug 2026 15:13:29 +0800 (CST)
Received: from kwepemj100009.china.huawei.com (unknown [7.202.194.3])
	by mail.maildlp.com (Postfix) with ESMTPS id 22A4C4057F;
	Thu, 13 Aug 2026 15:24:15 +0800 (CST)
Received: from DESKTOP-A37P9LK.huawei.com (10.67.109.17) by
 kwepemj100009.china.huawei.com (7.202.194.3) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Thu, 13 Aug 2026 15:24:14 +0800
From: Xie Yuanbin <xieyuanbin1@huawei.com>
To: <david@kernel.org>
CC: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <bp@alien8.de>,
	<byungchul@sk.com>, <gourry@gourry.net>, <joshua.hahnjy@gmail.com>,
	<liam@infradead.org>, <liaohua4@huawei.com>, <lilinjie8@huawei.com>,
	<linmiaohe@huawei.com>, <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<ljs@kernel.org>, <matthew.brost@intel.com>, <mhocko@suse.com>,
	<nao.horiguchi@gmail.com>, <rakie.kim@sk.com>, <rppt@kernel.org>,
	<surenb@google.com>, <tony.luck@intel.com>, <vbabka@kernel.org>,
	<xieyuanbin1@huawei.com>, <ying.huang@linux.alibaba.com>, <ziy@nvidia.com>
Subject: Re: [PATCH] mm/Kconfig: allow user to select MIGRATION if MEMORY_FAILURE is enabled
Date: Thu, 13 Aug 2026 15:23:44 +0800
Message-ID: <20260813072344.112797-1-xieyuanbin1@huawei.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <0dc4a8da-b2e1-4eaf-bea7-070b38d6952c@kernel.org>
References: <0dc4a8da-b2e1-4eaf-bea7-070b38d6952c@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.67.109.17]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemj100009.china.huawei.com (7.202.194.3)
X-Rspamd-Queue-Id: 5812120005
X-Stat-Signature: f1fx3apup4erkekp88896wtfjwo1ttup
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786605863-265520
X-HE-Meta: U2FsdGVkX18VuSHrKy/JIJHgoe586Zkr49y3K5ftJHMMnlf3TsPvH47b7eenmt/NFRP6chHX1+ydVyF8vUVh6YTXJs+gzWxHyH+ll2jYOabQ723/UOP4a4DZRc4d8mhSQUZzxuwnK5MwzDk8iQ2/Bl7iTzhZszHcoq68MH4Imk4fIFOYA/H9Mj+FA8TW56epNnsB2HRLIlvL/g/xCfqJEQNMYI7HdUwCDT7cechOlLeTsY/o0TDIJ426zBbCBE8bNp9ai+E6x6Lt4HamAzNRTXTcln28QZTXPSJVwXRS0QL0lMggXFjRZYmEy+nOkEjCRK/W0sCLV/uz7LF5FHjCPtK3fSZZtVWwImozCBV0YWBlvuN4u6bMQP171DTBxb3+dN6MlOj4D/TKL3kmS0xJYRWkJoDKa+NbOa8iUh1lTMkKqAGj7340TEwE+TPRatwxymuoUHv2R0Wk15vwAkOp7MCxvCPRVxesuPYjcUj4TJig76uo8iEeJDYhv+QWfGiUTE/4wSLg9GrpxU1c1DV/GIqA435hMv21GPnKEY4OVLMUdB/fi8l8aExl+Ltj1J2FqEDYhUYXGdR8BP1Dj8wYySditCMe3jNCNYT3/4X5TELNLkUE6dC4L/9Xj3FnZ1EvmoWmjymbGW+3gVxBOpz5ajbmIU6daYCRQtevaaRC9fPdA+iWZ+7Cur5Yp4p4A4uxzlC+N5YRGj9bqIPVz3hS/JA7bMbyHGkavnjIZ2KKvubkZ045WME9agn/E6R/mOPozieR4h94ICSZgvv22Aq6NGBjDO8iz/KDl0OuSxm7AUM26Q+qRHwv4Qb2nZzqNkwURFoh2dWJbAnSjzQc2gtPGyBnIrOClgWEjJCjS08hGuiKfjzNxxdSktcTKmIe0VyFWkqvrN9JK54fTXcE7w1dNqwHwycafg2MEBm/1dp4z1h9xUY4Xhf1UyazP1DmWEOhTKjNqf0MI8GWuaHBy4x
 2MxG4KwL
 1TGI/bZ2cBC2hzBiW10GcgzV57JHWdM7W+qgGpyRoZYXKfVNVd+t9X066UuGMkm7Mtlp09WGTWPXtPLvYRCxf+5hHuqFy55eF7gWt0YhdumqpjtwNss72ywXd7NMHJcywZPjjDx1mNf+POTJJ/ea2wIbM6qkctOMMnXLpXL6qBCBU/tYKeFcC6E3UfR72ghG/2/v0/Fjku2De7SdBfE8WkMpxSq6qn939I8rkKubbXKIql+DnjjyAU5vx5BVqkX8sX9GmaD4oQMhpNF+oZhTBftz7IzkPDdevTZLACOaYAill75uqnuSpWjCXRgYtHD1SNZX1ZtlpTvRK9CYpWwfeTc8HmaChj7xKQ892a3sP4EK6/YmT6Zdn+g+IubXU/0hcD0xdZZVou/8ppbQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 13 Aug 2026 09:06:07 +0200, David Hildenbrand wrote:
> Why add a new config option?

I think this provides more flexibility in configuration, when:
	CONFIG_COMPACTION=n
	CONFIG_MEMORY_HOTREMOVE=n
	CONFIG_NUMA_MIGRATION=n
	CONFIG_CMA=n
	CONFIG_MEMORY_FAILURE=y
Users can choose whether to enable migration, just like what commit
6ebf98d71f9b509e833e ("mm: introduce CONFIG_NUMA_MIGRATION and simplify
CONFIG_MIGRATION") done. However, it does add a new config, which may
confuse the users...

I think that just making MEMORY_FAILURE select MIGRATION is also a very
good solution, and I respect the maintainers' opinion.

