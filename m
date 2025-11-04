Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87783CCF9E3
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 13:29:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2AA48E013D; Tue,  4 Nov 2025 08:29:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D02838E0124; Tue,  4 Nov 2025 08:29:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3F1B8E013D; Tue,  4 Nov 2025 08:29:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B4C558E0124
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 08:29:37 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5E57B58EFB
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 13:29:37 +0000 (UTC)
X-FDA: 84073006794.11.3CFAE44
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	by imf26.hostedemail.com (Postfix) with ESMTP id 67468140002
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 13:29:34 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=vAARjTmh;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf26.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762262975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UDPk3iLG0eDrVTCl9rDky3CFQfLdclSTPbN3316Yf1M=;
	b=iSUGxOp6X7Me4/M+Ms5D6GFwGYp21ZbY3c0GiwUaY4eoedmWB8Rfz76CbRBeQECEC1wRW8
	slWMMq3hABqeOpuTzjwkJKyB8lANhMHK2uOq0kRpJxtu3Flc2QLIFDF7y6gzDVwnLxgUGc
	5pRo2JPb349k3e1MnZxfHCMSPug1EsI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762262975; a=rsa-sha256;
	cv=none;
	b=77s30FmlLHU6n9wnAInfRD8+oK2y2hFIszYkPZQF8cdUxlp5vEKol++1DijxZ3IQV5yLEk
	LGoft5fRARPhyVUIRXpOgJnrioUWUTECVgrXiZi31wcEGnXpRnRwuJb0vNqH6omaZoIQ4a
	dg8aReO/v5K9IjexQI78WAubzHbONRo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=vAARjTmh;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf26.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=UDPk3iLG0eDrVTCl9rDky3CFQfLdclSTPbN3316Yf1M=;
	b=vAARjTmhfdkMTg6kz24QdHijPIzqbQ709o2YuMI1IBCJCeK2ZHFk/2liIjNFLYAXJVkkEAx0Y
	xTrC+GpliI935FQmjp15aAkcUUwmlqDSM0id/87/I2Cq5JBapzunB2Ej1GR/LrgArjfBi2ZPLc+
	BPD9TGkcpKcpR4aKMQFU0Ig=
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4d18R40VY6z1T4G2;
	Tue,  4 Nov 2025 21:28:16 +0800 (CST)
Received: from kwepemj100009.china.huawei.com (unknown [7.202.194.3])
	by mail.maildlp.com (Postfix) with ESMTPS id 754D11800B4;
	Tue,  4 Nov 2025 21:29:28 +0800 (CST)
Received: from DESKTOP-A37P9LK.huawei.com (10.67.109.17) by
 kwepemj100009.china.huawei.com (7.202.194.3) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 4 Nov 2025 21:29:27 +0800
From: Xie Yuanbin <xieyuanbin1@huawei.com>
To: <david@redhat.com>, <dave.hansen@intel.com>, <bp@alien8.de>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <dave.hansen@linux.intel.com>,
	<hpa@zytor.com>, <akpm@linux-foundation.org>, <lorenzo.stoakes@oracle.com>,
	<Liam.Howlett@oracle.com>, <vbabka@suse.cz>, <rppt@kernel.org>,
	<surenb@google.com>, <mhocko@suse.com>, <linmiaohe@huawei.com>,
	<nao.horiguchi@gmail.com>, <luto@kernel.org>, <peterz@infradead.org>,
	<tony.luck@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-edac@vger.kernel.org>, <will@kernel.org>, <liaohua4@huawei.com>,
	<lilinjie8@huawei.com>, Xie Yuanbin <xieyuanbin1@huawei.com>
Subject: Re: [PATCH v2 0/2] x86/mm: support memory-failure on 32-bits with SPARSEMEM
Date: Tue, 4 Nov 2025 21:29:23 +0800
Message-ID: <20251104132923.145332-1-xieyuanbin1@huawei.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <1b316667-470b-4e1a-9c18-e42571e4769c@kernel.org>
References: <1b316667-470b-4e1a-9c18-e42571e4769c@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.67.109.17]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemj100009.china.huawei.com (7.202.194.3)
X-Stat-Signature: zfzbfiqrmraei6axo7sh41euw5ngozdp
X-Rspam-User: 
X-Rspamd-Queue-Id: 67468140002
X-Rspamd-Server: rspam10
X-HE-Tag: 1762262974-36351
X-HE-Meta: U2FsdGVkX18QX84kohQCiiI0Myi6bRAtx4Sq8dtCM8GKYQiq8wEJvefF5RMSisa1t6Bv3CIJ/CtJC+EPclDezkmydOjDG9focaaVLCVcouTeAe9X4aAGj5TpuImVIt2vAsKxTSoSP0afj9DKJhyJ8XhVYtYOINb1GVbXIGXZ2wbusn6rjM8EWE9v8wB1QboNRCTIe6XjMKCr7orEEWbE7YxvdgwdiQbfK13oesftboCOMzqIgXRnxcaNPutRhszNqVf3LnDMYYjbGTF+XS4X8fLc2hJrpSGvDsp5tlD8sBea0Yf30uFacH239ZavHshXzo69ZIFsx2cjhDSXBX78ryzNI70PvdD4GpUbwZyJKVNHPe9+IzMYytQuInucUtDVTeNc1p8acTD2HfYXQzBPeQyDoT1oxIwo7E4u97QmEKovua4VlXiqzUyvAkOreoynf4Zap1YLrk/1AeDTBWUhttHX2wL2W0P2Uf9O/a4am1/RtCjCZsr6+P50wfag4ndpDHi/2nIH/khEW32SYDnUz6n2xdkoC+4ak4AykmUv5GDrpxWLuM1vzGvkmU33+Ka3lz/Jet705K4LBYn38xH6G3ZsFpqt/rVBUS8Tmb9k8KLKa3zPSu3wwco+wJ43qHel/HoERPgimzl3P+4J3seC/DnP5Fx5wotjh2g8P3hbT/iG612OPKG7I5qF+LLSCvI8D0HtNRxurm4OAdfpuLOAWfV+w9WA1Ac4qtW0qeowa6h2JY8DSdrD0BRLoEwFiaFAFlQEkMGVKFUXvbysMciz+sWYupQcz9BUvdxbS3bf5zJ6ZNxlt3Ej8qA7fPdt9r65ngz9mxzKLbHbX1PHFqwoWa06hc1PxKdkpnDb+521askgekW+n49InNFwAcBb2eEUgx+8ia5BbLidF1zgwTuleIBVewvU69ykizrXjTyI46qJ1F6kiteapfEj79zmeYaqp7cOj2XPXK4f6OQa5vF
 /Nltc1fI
 lz/4wKAexH8HOEUhKQtmCLaIFyp+KJepuvuIMo+j/bt592Fywh5xtxA5pqNtRq89IoYQIAnzN13wnNZZiSWnMnJYMkoDyaACGbCnHB8SimZCzAR6hEueKMFvAHgHoglv5YTP9PQsIrjKoKZ5oHnf7sx1l3pjG+QMUpSUbEoc0vots+qHS2VhpmNrtp+qyyDfJypud1M8/SjSqiTg5NSYla7SFmGFZgXXxnXTwsF5XG7EaBsQF7MJY57uOhj3ZexrIuqrQhw7wZ+f1asceZpDXyxzaG1b5uhgsKXmkxirV1jvCZu3UFxi6FdJs3k/7wxyKsQsnfdElA5hCe2zz+ytthQKKng==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> This is a pretty generic description of MCEs.
>
> I think what we are missing is: who runs 32bit OSes on MCE-capable 
> hardware (or VMs?) and needs this to work.
>
> What's the use case?

Now, let me try to explain it. From what I understand, it mainly comes
from two aspects:
1. Although almost all new CPUs are 64-bit, there are still many existing
32-bit x86 devices in uses.
2. On some embedded devices, in order to save memory overhead, even with
64-bit CPU hardware, a 32-bit kernel may still be used. You might wonder
why embedded devices need SPARSEMEM. This is because the MEMORY_HOTPLUG
feature depends on SPARSEMEM, not necessarily SPARSEMEM itself.

All of the above devices, the memory-failure feature may be used to
provide reliable memory errors handling, and to minimize service
interruptions as much as possible.

> Cheers
>
> David

Thanks!

Xie Yuanbin

