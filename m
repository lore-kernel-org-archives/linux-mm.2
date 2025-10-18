Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89FE9CCD199
	for <linux-mm@archiver.kernel.org>; Sat, 18 Oct 2025 03:12:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B445D8E0008; Fri, 17 Oct 2025 23:12:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF4CB8E0006; Fri, 17 Oct 2025 23:12:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E4118E0008; Fri, 17 Oct 2025 23:12:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 894438E0006
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 23:12:58 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2C97D855D5
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 03:12:58 +0000 (UTC)
X-FDA: 84009763236.22.944DDBD
Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	by imf15.hostedemail.com (Postfix) with ESMTP id 258C9A0002
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 03:12:54 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=khUUExDv;
	spf=pass (imf15.hostedemail.com: domain of yintirui@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=yintirui@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760757176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6JLd3+7eItXpa6oD4S9fDPBUWfNqHNd7yVeROhoYzhk=;
	b=NRTJkstxMMNJ/6+7E5N8f4lyFEmkAda+oiaBz6OS9iZMgFF7Yq3J5dnGDI7OX9bSsmX4We
	GFO78z/8BMtUYhkJEVWmRcI5+YC7HP5RgHOcmAzhPy47GWkH9cKivSkokPt6KUzBJxpGCw
	j/1f+Dq3hMvyJXRKmQBXIDJWAc3Zn54=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760757176; a=rsa-sha256;
	cv=none;
	b=YJd/HqLRErqU0/f6hApLjw3ij8KtnM/jUtA5dbhE7uyQbQriEeBKaAUi+FhPxyrk6HoJgu
	u5ejIQEFy/uZzQC8Nqipja2HFjrKxHSjWBx6wQlbHFIyVjJI10YAVLzGlGjy8YWqkjd1Pk
	i5sCde126Ka+Az+5wqa6O7502Va978E=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=khUUExDv;
	spf=pass (imf15.hostedemail.com: domain of yintirui@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=yintirui@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=6JLd3+7eItXpa6oD4S9fDPBUWfNqHNd7yVeROhoYzhk=;
	b=khUUExDvT3R13J+zlBDtTRqcrQXBaFr90ZDcRlnEcMH/93u0p26NoIbqZWt53NL4czY+SQBdo
	/OxEI0osb2yjgBCfCnle2Lszklq7b1TG2qRs3Ddkv2OFUvMv1V1DKYJFPSvhpEzZnt+OXMf3+KZ
	xaS7JvFzR4Tfv6rrLRXuY2U=
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4cpRZM2kr5zmV6y;
	Sat, 18 Oct 2025 11:12:27 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 4C2671A016C;
	Sat, 18 Oct 2025 11:12:49 +0800 (CST)
Received: from [10.174.179.35] (10.174.179.35) by
 kwepemr500001.china.huawei.com (7.202.194.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 18 Oct 2025 11:12:47 +0800
Message-ID: <c91878d6-f645-4fc0-abd3-f1ba4aef47cd@huawei.com>
Date: Sat, 18 Oct 2025 11:12:47 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 1/2] pgtable: add pte_clrhuge() implementation for
 arm64 and riscv
To: Matthew Wilcox <willy@infradead.org>
CC: <akpm@linux-foundation.org>, <david@redhat.com>,
	<lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, <vbabka@suse.cz>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>, <ziy@nvidia.com>,
	<baolin.wang@linux.alibaba.com>, <npache@redhat.com>, <ryan.roberts@arm.com>,
	<dev.jain@arm.com>, <baohua@kernel.org>, <catalin.marinas@arm.com>,
	<will@kernel.org>, <paul.walmsley@sifive.com>, <palmer@dabbelt.com>,
	<aou@eecs.berkeley.edu>, <alex@ghiti.fr>, <anshuman.khandual@arm.com>,
	<yangyicong@hisilicon.com>, <ardb@kernel.org>, <apopple@nvidia.com>,
	<samuel.holland@sifive.com>, <luxu.kernel@bytedance.com>,
	<abrestic@rivosinc.com>, <yongxuan.wang@sifive.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-riscv@lists.infradead.org>, <wangkefeng.wang@huawei.com>,
	<chenjun102@huawei.com>
References: <20251016112704.179280-1-yintirui@huawei.com>
 <20251016112704.179280-2-yintirui@huawei.com>
 <aPE36PlriswJWSKD@casper.infradead.org>
From: Yin Tirui <yintirui@huawei.com>
In-Reply-To: <aPE36PlriswJWSKD@casper.infradead.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.35]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Server: rspam05
X-Stat-Signature: nis1h7stci3ibcs7amannjggwdx7hupa
X-Rspam-User: 
X-Rspamd-Queue-Id: 258C9A0002
X-HE-Tag: 1760757174-563866
X-HE-Meta: U2FsdGVkX1+iJWMFbbCYiswNRtDdLvw7dkLXVqvBzHsBV0XcktEyJ1DUrLzDju14XD+w8rao7k1QrqUj5aA7LJH5aumUdIXT5R+hbBqaVL6FIxyMcacKOL9ghiA0DpUN50ucNJs3EcA594E9OX8Xvi24VeMPqNPNgEzr99dZnoKwbTSkC4XhhFU8Dv/vmtcbHDztwJ/UA4FaCefk6or3gUlJtAAqVt1F4Sv86zrGPqUMDB4UG8JDrz4bymuKi74UjadNTPnxK4UEKMOv61zEQoGbutCI16NrPEcleAO4YNrN9YD1vJ1Y6gEf8kcIxhCXqK6rOftTUIy1cGY4KZ6gnHKmUnR5+ACO+7OJEtF7mn5uYwvP1MD9nmIgl0oEnJ/fCTL/Z9tLyXjIlYtzyR+Tf0vd4YwRWyrooYwkJ486o+DwI7cbGEYNpDiTvFtoiueYePcp+DuKvx3Dny9R6BYvyvOF1VEpG3xMLMGMCl08XKbYh5yxBBf0y1YgiyHptsvr8J4VvmNfEx5cl4+RRYWI1JlQEhCMdDLBkF5nu3omDBTTt1EWIW5pstCj7XyTtQc22ZFZS8cet61NMj29dsSf5thJQL+0g5PrX52dk3oHTcyiCZNVGCty6QcEK8kPw0NBBbqxupLPI0g8pfNATGuU0riDQ5bSAQT32mpQy9ydNyLvDQjxqORkDcYHxQhtVz6DuOTxpG1310jfiew5qgFahQC4lfR69XyaBgKvRCKAgdXt2YmiYZnJcHRhi7ZEsqaOuTS/nowVJ0H9JaPWCKB4viRG5D2Ja9qjl0nhWnEia4l1JokNMvpqTmPNu+cFX20slwexDrYHtfFc8NMTGbQmzfVmaIjLhuT3vOlr7H22n1kuYtiQ/JiyDWotzr7OQXkY6nxRbzacsTButqS2tNerl8JcVX13RJ+zwizcps072Zd2qYAbZFhVjBeKrLmI8jNGNB7EolHvYRfABhkC+r4
 1+YXBA1K
 I1+S1pv5nXYxCfw+VCARIqt9wE0npwd8C38GmsKwxu9BU2R/pIvaeD6nSb2hithGRV8/AXUDAiv3m/Jm7eaQ5GneRVWFsrOrOV/33wqg6F8poDhSdK0/v8czo3rpVoR77i0JgYCDIdhadRrTPcaHk1mFtk7NrzF1o2bAmY0fd46CpOQFqj48uYaClySmi52XnJ010Qw24j2X2WPiZlFbm4waYlmWLG6yZwrjBlab9Qyfz1P+krAdxk3o/ij4j8zluEwKle7FS6PFCV0KSkL3SA+T/rtHmvA5qTM0hY1h8roYmu3fFB3m902FqjI0QQEyB+FyqJbYR0qQJvjQgGHcHn/mKCBI64C54sBzUJC0cLINOPG0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/17/2025 2:22 AM, Matthew Wilcox wrote:
> On Thu, Oct 16, 2025 at 07:27:03PM +0800, Yin Tirui wrote:
>> Add pte_clrhuge() helper function for architectures that enable
>> ARCH_SUPPORTS_HUGE_PFNMAP to clear huge page attributes from PTE
>> entries.
> 
> I really would prefer to see pte_clrhuge() removed first.  Otherwise
> this just goes onto the long list of "somebody should clean this up some
> day" and nobody ever will.
> 

Understood. I'm working on it.
-- 
Best regards,
Yin Tirui


