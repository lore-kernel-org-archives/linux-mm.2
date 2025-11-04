Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED535CCFA03
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 02:20:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 049F58E00D8; Mon,  3 Nov 2025 21:20:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 021738E0058; Mon,  3 Nov 2025 21:20:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA14E8E00D8; Mon,  3 Nov 2025 21:20:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D80F48E0058
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 21:20:28 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 290B04A5E9
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 02:20:28 +0000 (UTC)
X-FDA: 84071320536.04.B501A15
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1B8AF180004
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 02:20:24 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=5fMGUL4C;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf16.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762222826; a=rsa-sha256;
	cv=none;
	b=mjDvhA8bH/Rk2hxeogrC0Ngq0HfJiYJWtHBGNbAoTu3q5motNUudeOxJB40nvTrXQ6NRUv
	ZLOO37py36YNgK1AYKd0FG1jbpciXnJjFshmtLXJnz9+fbKmbctY52rYkC3OYqn/bTmsS5
	SGg2/i0rAXKRW0fAGXuT0V/Vi+R/S7o=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=5fMGUL4C;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf16.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762222826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O828h5KICt+CxEvVNrcn2W18GSriC+FVfgyjhNIRBsY=;
	b=r3B2d6rn63OtAuicGt8lkAz9COPcDyErBg0Yz9yA3e03PxEPiJmw9IVX+w8FkkidvgD5fP
	Fqe93jLtO+rZ9hpNYWeizH6D8Jk3lYOzlAFnKBm+QF6mwoP4wfL5b1oYNfgSjV/mVTXldm
	aCym+ZWXXpot+V2Bc7LfLnB22/DgdGY=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=O828h5KICt+CxEvVNrcn2W18GSriC+FVfgyjhNIRBsY=;
	b=5fMGUL4CG0GbPCEQ4BfyTgfKq4Ur/10j59cFtq9svQdXjZTp9AZzzHnkhKDxUA/Z+nz85/WGa
	Jqwqdq0yj/8xwLLhytz3ljGEjlJLp6ncQsyIK922sHW2FyT4x9GKoVcPaGWjxmJ5MvzyUzp2dGM
	rtM9uLvdOsk3pXu/4rOTkuk=
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4d0sZg1WYhzpT1F;
	Tue,  4 Nov 2025 10:18:51 +0800 (CST)
Received: from kwepemj100009.china.huawei.com (unknown [7.202.194.3])
	by mail.maildlp.com (Postfix) with ESMTPS id A3984180B5A;
	Tue,  4 Nov 2025 10:20:19 +0800 (CST)
Received: from DESKTOP-A37P9LK.huawei.com (10.67.109.17) by
 kwepemj100009.china.huawei.com (7.202.194.3) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 4 Nov 2025 10:20:18 +0800
From: Xie Yuanbin <xieyuanbin1@huawei.com>
To: <bp@alien8.de>, <david@redhat.com>
CC: <Liam.Howlett@oracle.com>, <akpm@linux-foundation.org>,
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>, <liaohua4@huawei.com>,
	<lilinjie8@huawei.com>, <linmiaohe@huawei.com>, <linux-edac@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<lorenzo.stoakes@oracle.com>, <luto@kernel.org>, <mhocko@suse.com>,
	<mingo@redhat.com>, <nao.horiguchi@gmail.com>, <peterz@infradead.org>,
	<rppt@kernel.org>, <surenb@google.com>, <tglx@linutronix.de>,
	<tony.luck@intel.com>, <vbabka@suse.cz>, <will@kernel.org>, <x86@kernel.org>,
	<xieyuanbin1@huawei.com>
Subject: Re: [PATCH 1/2] x86/mm: support memory-failure on 32-bits with SPARSEMEM
Date: Tue, 4 Nov 2025 10:20:14 +0800
Message-ID: <20251104022014.7716-1-xieyuanbin1@huawei.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251103123920.GCaQiieAtEGz1nspWZ@fat_crate.local>
References: <20251103123920.GCaQiieAtEGz1nspWZ@fat_crate.local>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.67.109.17]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemj100009.china.huawei.com (7.202.194.3)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1B8AF180004
X-Stat-Signature: d9x5biob6nbfiixjojipsr3noikymwpe
X-HE-Tag: 1762222824-121443
X-HE-Meta: U2FsdGVkX1/iA5GriMYUjG0F6tqU2ldM9N8VcFiCPH4Q96Q18xgHL4T75r0X67htQwxmU2BX3wgQk5qiu83RaO6fgKTrYUmhFEIuKBgQX15zY9UcrXXGkKhRdYwZUJqvJHIAwX6MBRLGKIkM9wpjCXzMBwUIjgzWXnE7S2mvGNy4BQz5ML/CSQQyMpVXWhp8nlZRa17qaqQoMNMQ3A71EQkA56GGaAaOmLvsaQH+sk30vDfwmdpC487mc09Spi86lZoMj8oZHbhEHWiNWl/i1bCVieYlcShgE3uIef/SQUYRF+aY97RVu60NfChIO5CDXTP4Wv2VYmBXaZ9v1xekUEPZV3v8Kq/bchGFAiLV2k/7b30+Bprabcolu0Dp/3YOXjN5hYu0lJkD3NYhIrm1x0DK4e0vN1NeZyoE715HyOnAwQyF9vnKKkpqgevp4RU0yXd1JeUBYBcJnO3b6ujuxJRiCm5/6isuzJNZJVPV8VfgNFuUfxnUiN2rKKqw8AKXElDDHMRwTN1yK+DQokdte6/MjTaO1Gfh8xNt0y8HFzIDMy5OKVD90ntfFmSjlmDtJJO7/Ja4mZKHyFItP9uLLy8SfgUu03npE5jTdbnCBoD1QLgXbII7lj7eiTAYHA2o88TtCaUGQHjx1f2FN2suXBb2uE7/Qw41fKfd59uaHSYUa+QrKDdBcLCCztj2Y9L609/Je3WA/pBKZQuzr6PQ0cGS4cbZ21Nj9JVoyp+9oo9Y4Iq3Mipb2nrY1mmFf8vvc6/R8LH8GI9ftNBO9vUxTxxl1V6avfTwFB/kyqmt066V30hkT5q31/spGdIL9QvGOaTnsF1CrNE3bb1ZdqmACdEbvzCQbupWTtHDKS9BdFGLmIIfidoUDODGmSLs7BCLZ/VtZARNeAjXh6xRDVfdKgaQjlYM4N4X1bzHlBuifEJVk1JMckIDibwfiBNuDQcTbZJSpJ1mKNKTIwfyvWo
 DzppRIbT
 HFDpu9j4NZ8qf0ZH/4vCNyfsbVSLo3LwgMzsJghI3t0ZdQCZ/hrLa0hHZqGQpr/GE57SAwHOi5TDh1KQjw7xCM4KxuQ+AtREZ+ToKeQbFhXNDAESdEivcL+qMM9TUIqqJLQADhlAyCg6gwZEDtjkyXyrJh+VHAO9Jc4F2NzR41NEXCUr12qOXoX91LdIPzvayBPjkVngvoQ/uK6tKccV/Klv0T9fQacH3vdfA5dcitLYEKpNHfUErX2ILziRIOThlATRMm7poG0hhK3Oy06LYVKZxW21OMSE7bX0ZAbXDAOmsjCrUETzKdXGL7uWovhFGUwK8dB2Rdjy6qz7s3KJqFqfgJg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 3 Nov 2025 13:39:20 +0100, Borislav Petkov wrote:
>On Mon, Nov 03, 2025 at 01:15:58PM +0100, David Hildenbrand wrote:
>> I rather wonder whether the memory-tracing code should live in a
>> memory-failure.h instead.
>
> Yah, move it pls. It doesn't belong there.

Okay, I will try it in V2 patches.

I'm not very familiar with the implementation of trace.
A trace/events/memory-failure.h file should be added, and:
```c
#define CREATE_TRACE_POINTS
#include <trace/events/memory-failure.h>
```
should be added in memory-failure.c, right?

If I have made any mistakes, please point them out. Thanks!

Xie Yuanbin

