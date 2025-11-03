Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 182E6CCF9F8
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 13:24:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D3CA8E007D; Mon,  3 Nov 2025 08:24:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 584178E005E; Mon,  3 Nov 2025 08:24:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 472648E007D; Mon,  3 Nov 2025 08:24:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 313D88E005E
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 08:24:14 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D54ADB5795
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 13:24:13 +0000 (UTC)
X-FDA: 84069364386.29.C4B9D30
Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1E2D44000E
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 13:24:10 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=XN2VxKRZ;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf12.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762176252; a=rsa-sha256;
	cv=none;
	b=3SXlOWsLDnP3HyCfF0Ib3l4W+IyMUxMEUjGfc61nsWSxRxtJpT8DhzM3i8B4viSVsHc8nP
	Wn8WUcyLHj1vbkEUYGadP6PV4cDxZaImIqN1BjxCrPN9dgGfk8GlndTQdjI0SZN5QUWG02
	SSZrdzj2kK9lz59MjBR7AD8ImK0ZAr0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=XN2VxKRZ;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf12.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762176252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mAK4GGZ6Wc0AlGtkULkNF5rra7UyoEYfK4R4QDVlWWY=;
	b=oISfPvMvrJYFJ+aa/z3lCY9KKmlZAChxVoGNwYszS4hZ93dX+/zKiLyLFOp53vd+enhrC3
	9SHUL3gXo36j/I9l6J4XIfIacm17u7M4GRNA73u7OgKBxNntffzFrmPw9SwyYxdxJeXQ35
	FGXpunrknN/2GCG/twC0/8Vhc8GCKKU=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=mAK4GGZ6Wc0AlGtkULkNF5rra7UyoEYfK4R4QDVlWWY=;
	b=XN2VxKRZ3crT5GYeeWcFkjt4OALy8Rp9wM7ylmTQFH7kUhZ88qzDVCE5n8pywkFL/nevUvLYE
	BwLJxMPgMSFxeY3ZRf2IwNogn4eKh8IPohQlk3UBi7gNesWUVZl/0GcQ6vIZC2tpJj5Zoi4FPnt
	npWYlwA07OCHYgkB/eN8ZX4=
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4d0XLt3rgWzRhQp;
	Mon,  3 Nov 2025 21:22:30 +0800 (CST)
Received: from kwepemj100009.china.huawei.com (unknown [7.202.194.3])
	by mail.maildlp.com (Postfix) with ESMTPS id 1D4CA180491;
	Mon,  3 Nov 2025 21:24:04 +0800 (CST)
Received: from DESKTOP-A37P9LK.huawei.com (10.67.109.17) by
 kwepemj100009.china.huawei.com (7.202.194.3) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 3 Nov 2025 21:24:03 +0800
From: Xie Yuanbin <xieyuanbin1@huawei.com>
To: <tglx@linutronix.de>, <david@redhat.com>, <mingo@redhat.com>,
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <hpa@zytor.com>,
	<akpm@linux-foundation.org>, <lorenzo.stoakes@oracle.com>,
	<Liam.Howlett@oracle.com>, <vbabka@suse.cz>, <rppt@kernel.org>,
	<surenb@google.com>, <mhocko@suse.com>, <linmiaohe@huawei.com>,
	<nao.horiguchi@gmail.com>, <luto@kernel.org>, <peterz@infradead.org>,
	<tony.luck@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-edac@vger.kernel.org>, <will@kernel.org>, <liaohua4@huawei.com>,
	<lilinjie8@huawei.com>, Xie Yuanbin <xieyuanbin1@huawei.com>
Subject: Re: [PATCH 1/2] x86/mm: support memory-failure on 32-bits with SPARSEMEM
Date: Mon, 3 Nov 2025 21:23:58 +0800
Message-ID: <20251103132358.79766-1-xieyuanbin1@huawei.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <5ace86cc-0b2d-4306-8bc1-dfc34cccef1a@redhat.com>
References: <5ace86cc-0b2d-4306-8bc1-dfc34cccef1a@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.67.109.17]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemj100009.china.huawei.com (7.202.194.3)
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1E2D44000E
X-Stat-Signature: esikncxxphrhm1ewrgezj9fjtg3f5ezs
X-HE-Tag: 1762176250-185255
X-HE-Meta: U2FsdGVkX1+AWZdFbcizK7Sg3PBOKT1OySJzNIfvCpEC0OEzzeJSaw6JWjPXyfzsPx3xHH2zRr+CA5+ifPx3P3dVeABc/fhaCOl0bTvS1jF/LjZG43VE6Q7Ru/O6Xb40ZCAcmgPscZztHwy2c7iwQJYPZ9c7xtJOnvv3pls0FnBeG0iesib81a1mCCgylns/Qgyun3kRE61tWfwPNVBHf3Xo4Y7TPOwhO+ijOC9lrhGjt0qZQHIGyfJKRimH7L1yWscQLv9xLgJqYBRu0LtpFy6RtEFiPQc7DZ9A9COfe6Z5QSdMmawX7s9DOjpM6bOH7BjcyJkVNcclLt14OYYISDBYWIQvY+lR6cf7gav5REFUUvr32CJUmYdOVBieOe/4OLug00LQTNSoMwiQJzCloOpF6BW/tMbUqWkXxijx5ds6d4ZAh5D9pun4x8c1GzirYcX5Z6v6d1O0IEGJhOtTHWeXIETJlZgCAQao1wHbQ5ZOxUGHaB7StlMh6nW7CE8dguVOAtN8Y+V9sAegJLJB3MiHtDwLvDJgtIROdUGLl2qGh6e5/wL0Xsj4se7SWtKaBjZ0aKhuMj47sLL/E6zdljuAwE7GMnLhLxfpTaVnZXdkO4+/GvqXypE+wFkyd/k4QcSUVbQJVDKyDRccRWXlQVFt4REk4PSUW7sMA0CvAbZlJhR5ClQhx3l/aLFTFeiRn6PAKGr1CFJ9msGKTmRJ2Kff+y9JbQHEhV76nomBiUtzbekuzPz3nGg+D2JcFSnkgjK4aXeVu4V1Yj9FB20BePwWTrby9oX7+7N+L54QhmG/0tS+oXi8vx2sGhvtgtbf/32CWudIQeeCyNN52hioRK3BHydKtYpq+/DYogUDS0+vokhUOnfLjES2gWwt6CYuu5gKGmJVgJADgcBBCxaZxXCoZRT/qQ4wELLhJGGQ3Qqo5gpD+Gp1luu38Z6ZqYo97FNrNMlTliboktCUcIm
 1yfL6aX+
 0J/v95ZbzWdUHh0qFfz0eNXWhoerfiYRuRznmJnQP9rnSsskBYB6yztF+3S7mPfGfIKDtGDEsvk1xkxnt5vAUQNOZkQODE/8pPcTJ1rqwn3yDCz5gkkz8Nj+B/qx8fYEFaB2f3jmRpo0TAyUYkSzPFh0YfX7lHJaNTSu4vyEuiGsgFCRUK05joHHURrFPQOkp4OLV45Oq4m2qMKHnnqFtKYIlfA2gmQNFw4h4YPY15qboXEYCEI+vxBkhd7no1WMKo4Qo+01rRP89mvwHVCLdoATp46CfJ4dYONa7VYaiyTZY4XM/XkXfn3I3nAV1dcVqvEl+UQXqWmImuPGgK/7w21LH3Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 3 Nov 2025 13:08:38 +0100, David Hildenbrand wrote:
>> The historical commit d949f36f1865c60239d4 ("x86: Fix hwpoison code
>> related build failure on 32-bit NUMAQ"), disabled x86_32's
>> memory-failure when SPARSEMEM is enabled, because the number of
>> page-flags are insufficient.
>> 
>> The commit 09022bc196d23484a7a5 ("mm: remove PG_error") removes a
>> page flag, so memory-failure can now be enable now.
>
> In the meantime, we added PG_dropbehind

Okay, I completely understand now.

For historical versions, MEMORY_FAILURE cannot be enabled with x86_32 &&
SPARSEMEM because the number of page-flags are insufficient. At least it
has been so from 5.10.x to 6.9.x.

The commit 46df8e73a4a3f1445f2a ("mm: free up PG_slab") from 6.10-rc1
remove a flag that allows MEMORY_FAILURE to be enabled from here on.

The commit 09022bc196d23484a7a5 ("mm: remove PG_error") from 6.12-rc1
remove another flag.

The commit cceba6f7e46c48deca43 ("mm: add PG_dropbehind folio flag") from
6.14-rc1 add a flag, but MEMORY_FAILURE can still be enabled.

At least for the current version, memory-failure can be safely enabled.
The number of pageflags reaches its maximum value under the following
conditions: HIGHMEM && SPARSEMEM && X86_PAE && X86_PAT. In this case, if
MEMORY_FAILURE is enabled, the number of pageflags just reached the limit
of 32.

I will update the V2 patch to describe it.

> Cheers
>
> David / dhildenb

Thanks!

Xie Yuanbin

