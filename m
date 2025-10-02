Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EB6ACAC5B8
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 16:01:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9292B8E0005; Thu,  2 Oct 2025 12:01:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 900C48E0002; Thu,  2 Oct 2025 12:01:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83D988E0005; Thu,  2 Oct 2025 12:01:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6FBD68E0002
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 12:01:08 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 105E111A581
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 16:01:08 +0000 (UTC)
X-FDA: 83953638216.15.ABD53B1
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf12.hostedemail.com (Postfix) with ESMTP id AD6BC4001E
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 16:01:05 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759420866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cVzBVoHAVfQ4ajMV7htNItrHQz5oq/+34VfarvtgP88=;
	b=tCjgCDGgoAehP1ctP4sPh/CJydAXbe42OksODRp40CyVDqTg26u4Q3ahGQ5eFZZV/1Mq+0
	d6DsuK6i1icP5qbvpCYUFhYv0kdkNL4F92CweiAlIqm4p6EqLuoqzZ1Miz9Nk2Tey5k52l
	YpPyecENtqhF71uA50nQGDn/qUwHvb4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759420866; a=rsa-sha256;
	cv=none;
	b=wkcU9DZDDk+w/lhb1Ma1ru9iofzOtD9+ODdxuh1a88MdM5t5JXFXVH7yPQugHqyQXW/RN8
	bL/vh/+XYxqBMhAiOKmKJgyOQUGQm4jYH8P106EfaUukdmnzftrThyCmmqnYClZm8Usg8P
	7Pd3wecEa2TFPNaKtpceb6oDb/cuKDs=
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4ccxN94xDqz67ww1;
	Fri,  3 Oct 2025 00:00:41 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 7E50E1400DB;
	Fri,  3 Oct 2025 00:01:02 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 2 Oct
 2025 17:01:00 +0100
Date: Thu, 2 Oct 2025 17:00:59 +0100
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Raghavendra K T <raghavendra.kt@amd.com>
CC: <AneeshKumar.KizhakeVeetil@arm.com>, <Michael.Day@amd.com>,
	<akpm@linux-foundation.org>, <bharata@amd.com>, <dave.hansen@intel.com>,
	<david@redhat.com>, <dongjoo.linux.dev@gmail.com>, <feng.tang@intel.com>,
	<gourry@gourry.net>, <hannes@cmpxchg.org>, <honggyu.kim@sk.com>,
	<hughd@google.com>, <jhubbard@nvidia.com>, <jon.grimm@amd.com>,
	<k.shutemov@gmail.com>, <kbusch@meta.com>, <kmanaouil.dev@gmail.com>,
	<leesuyeon0506@gmail.com>, <leillc@google.com>, <liam.howlett@oracle.com>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<mgorman@techsingularity.net>, <mingo@redhat.com>, <nadav.amit@gmail.com>,
	<nphamcs@gmail.com>, <peterz@infradead.org>, <riel@surriel.com>,
	<rientjes@google.com>, <rppt@kernel.org>, <santosh.shukla@amd.com>,
	<shivankg@amd.com>, <shy828301@gmail.com>, <sj@kernel.org>, <vbabka@suse.cz>,
	<weixugc@google.com>, <willy@infradead.org>, <ying.huang@linux.alibaba.com>,
	<ziy@nvidia.com>, <dave@stgolabs.net>, <yuanchu@google.com>,
	<kinseyho@google.com>, <hdanton@sina.com>, <harry.yoo@oracle.com>
Subject: Re: [RFC PATCH V3 04/17] mm/kscand: Add only hot pages to migration
 list
Message-ID: <20251002170059.00002045@huawei.com>
In-Reply-To: <20250814153307.1553061-5-raghavendra.kt@amd.com>
References: <20250814153307.1553061-1-raghavendra.kt@amd.com>
	<20250814153307.1553061-5-raghavendra.kt@amd.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.203.177.15]
X-ClientProxiedBy: lhrpeml100009.china.huawei.com (7.191.174.83) To
 dubpeml100005.china.huawei.com (7.214.146.113)
X-Rspamd-Queue-Id: AD6BC4001E
X-Stat-Signature: o6nrk55ibfoa5ken5t3yqzp4rhjho8bu
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1759420865-158870
X-HE-Meta: U2FsdGVkX1+J/X5xZdJFMs9/icrsbLWwJ9M/4rbNeDr0p9ChHbjUVsr4SFERZUHpK7J2NwdNHy+C3oZ4qbs8WFTv2kAU84hDA5Or29f0fGzsLIZ2wXIn5zc+FpA/2kV5eeKPFpNzzGrv6bBs/2oAVMcTHOrr5wG/TO5cH61tevBRbAjISmO53KBseNT+pTAf2CZYbkSYoj191EcNOl+67iOJETLJvcHLbsfKieaH3/Sib7UyYO4fKTY1MUa/LdNAZ+ISMERdExtR1CV8tT5fD+aO4SMTP2Fvz5YkK8CNbYmLYVwsxpeNHhaX26s2LT2cfsTqyReHKXDbk+hyP1jCSQAwDwoABSg4xIVAIk4zAaHVJne1O9DY+VSMT7ksIVsl8zJaWQLyEjaMu0IV7u6IzzkmvUaydo0rpPPSf9AKanzopBX6bljIS3//USoJMJltq0ADwvgX6rXOKLzMbdaPlJhraymkJqAcNxUhC7YqFyVEuGDxlRnJ4Hbixjk8Ik9MZrDl5+tYKKDPCcpua32oH7QohAS/ExVI0MOjHPpmkYPsvoqf9g9quYTFWpioCCftC286nAdAHLDB4u45ElLKTsor6Ix0i9A9fq4SvEhIFhu5CBOilHJ/Lvl7ow2rEGQLtTTlSrsfKBFGz0S7ITVoY9f27/qYJ/oLRbwKmaZpb6coXJyJMSF/Am4lPPypjtJQCVucoR/QKjnt0nkV/1WKXEF7FlnFU0tyRLdjh/Sp3ml6RIX6ibQxtdFB3sclPyKfoO54FmSi/lV546xE/JEC3qXSM9LA4Bm+Yjd+rrsJajn0/4bKMVAqhgs90Nj2GebF8TCXP/4b4kiuY+eWp9buK9W/h4L5FTdTJG1d1PmWNkV1UJhjNbEixkOjywl8CmtKVUhtUzHDEtwBDZgryR4VVfpxD4/f5CPY0KNqhbGmO9pHSn6uQas6gU6J9upupa75nHVxbWb1wdOKTpyiVJX
 F7sZsGs5
 LeJguAb8qHkIKTDshMmwbwn38H+6A0UDnqtLMOnUIpjzZ9WV3j3aBjGziy/dve1a78mbVTYAvWIfqLXAsqrmKALpX0hnXex5VbFYhJ9H/M6M9ZoLK/Q/9o2kofuqTvvriCi2iEGxFblHQPqKd1iP8++1oy9DYRi/Zmy3v9EoDmr6vG/xI8z8pxdQrhYe1bk/n+ZjCUbhs9ewzFf545gARPxXK9ahadVhi9bkGYFaldUSRxruPwdHWfDAcLFslqKpe9HAEmsDaGFp1lqm1KLoiVuUpHsZaB5OlBE4CO13T+1SnNWRnDMOPAyRrNyE+FLW9/2oo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 14 Aug 2025 15:32:54 +0000
Raghavendra K T <raghavendra.kt@amd.com> wrote:

>  Previously all pages, accessed once are added.
> Improve it by adding those that are accessed second time.
> 
> This logic is closer to current NUMAB implementation
> of spotting hot pages.

Trivial but wrap patch description longer.  75 chars it typical.

> 
> Signed-off-by: Raghavendra K T <raghavendra.kt@amd.com>

