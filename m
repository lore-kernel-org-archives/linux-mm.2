Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E8DEC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 14:05:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 970586B00AF; Tue,  7 Jul 2026 10:05:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 946F76B00B5; Tue,  7 Jul 2026 10:05:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 884DE6B00B8; Tue,  7 Jul 2026 10:05:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5F1EA6B00AF
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 10:05:29 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D53C81C39FB
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 14:05:28 +0000 (UTC)
X-FDA: 84962153136.03.0214E8B
Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	by imf21.hostedemail.com (Postfix) with ESMTP id 608CB1C0014
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 14:05:26 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=mJPKBpcx;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf21.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783433127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rm1KNibCz+ERMVqGQLvzK/uPua2K5RXP/Arqnz8w2t0=;
	b=NDjBIJCQil41GUts6EpJngaGecKK6QKQdoBStH40+31yBpSZ9yP3J+koNiVMqnLtv7eqkC
	D1rPrv7RVjrUYXhlX4MPS5si0az/cOXEyS6anZiv+xWoROOK8s/1NP0hA6TRsYIZu+Otro
	Sh9gouZiXQXJ4cPUVwMde+zllXEWJ50=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=mJPKBpcx;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf21.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783433127;
	b=Oym3ytS7+/3Z5yjVcFuCqTDe+AS+Wt+WIjIoxcSASzJdH/dzxVHyEkik/+X6RmcuhUJCB5
	1T5YOVgJBM3+CFIlC81Nbl9+2GXU2yLZhHjgmKu+sMlAaQx9o5O9dl+FdRIMSRhuEPJzcO
	9j564i2xcP01pZqw/e0knVD9skrHKzU=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=rm1KNibCz+ERMVqGQLvzK/uPua2K5RXP/Arqnz8w2t0=;
	b=mJPKBpcxf9F2zQUNY1YAPwDjh84VLxG9DD0UipCOkKffqTF7mV1KnXhZMlTlmx9xOOdCtaMC3
	QlQyeTbwSLfO4/aKT4fx036hyhIlgMGxVUTr1eOp+Oyl6AAnVuzIMTOoYqxkHlALfXJBcBrvLHV
	A+zRKwOs4tBqIVq6Z+6ClaQ=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4gvjS50jGFzRhRF;
	Tue,  7 Jul 2026 21:56:05 +0800 (CST)
Received: from kwepemj100009.china.huawei.com (unknown [7.202.194.3])
	by mail.maildlp.com (Postfix) with ESMTPS id 56D774057F;
	Tue,  7 Jul 2026 22:05:17 +0800 (CST)
Received: from DESKTOP-A37P9LK.huawei.com (10.67.109.17) by
 kwepemj100009.china.huawei.com (7.202.194.3) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Tue, 7 Jul 2026 22:05:16 +0800
From: Xie Yuanbin <xieyuanbin1@huawei.com>
To: <ljs@kernel.org>, <akpm@linux-foundation.org>
CC: <david@kernel.org>, <liam@infradead.org>, <liaohua4@huawei.com>,
	<lilinjie8@huawei.com>, <linusw@kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux@armlinux.org.uk>, <mhocko@suse.com>,
	<rppt@kernel.org>, <sunnanyong@huawei.com>, <surenb@google.com>,
	<vbabka@kernel.org>, <xieyuanbin1@huawei.com>, <xiqi2@huawei.com>
Subject: Re: [PATCH v3 1/2] ARM: mm: fix use-after-free in __do_user_fault() under CONFIG_DEBUG_USER
Date: Tue, 7 Jul 2026 22:04:05 +0800
Message-ID: <20260707140405.85568-1-xieyuanbin1@huawei.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <akz8aZUW23rpyrLO@lucifer>
References: <akz8aZUW23rpyrLO@lucifer>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.67.109.17]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemj100009.china.huawei.com (7.202.194.3)
X-Rspamd-Queue-Id: 608CB1C0014
X-Stat-Signature: kdjgfmyio8bbrgch4gabxdxx5yjh3g78
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783433126-307189
X-HE-Meta: U2FsdGVkX18VPq8yQdCRYOLM2+4DrnbfKQ8DaOHQjuYMvUIFCxlkwTxX/NceKiPJB+bRuSwo1QfjieZstrSwtWn5ELnjxwQFx0DHmTAm7XrjcALeZ+W6MdiX/32RV9GuLvOQQqs5rkCOgtYZxzu+KHpncAJCFX7UcD6pTUfqbmsvqFkt1rxRR+55mUF6JfgwojWH01sX2s+QcTWPophGCnUofKaSSWZnvf9KKjG/S3PyuKXdxWsHV7NrcdsGbEQN4dK0s73nnOIn2xNmDmEByx7MH0u6HmdzuLsQc7Y0QGw/ZXvyz8hYPHXgpPV/oAZZKUX1XN567E4xVAVGhUl6eTDJnQtdT+nkeya/KtNAz2b2Ar+1sJ0HVs/+KTZjGa0ywLODxwV1ARpzlbJvAZAhNa13Rp3mjYmAlFDI9fsk4X80GgreUK/DPaPXFC0ZiFoUee8nF8ryV1BD4uVuYSzVfNlppEQB2IXMQsT29ybH6nNkU/x+4cfqFPk5J3qxUIgzTP1CCDPQC8rERbdr4qPBUaO/bmRhkwhEIFfNMbxaVz0Cfwo+W0O7+xvG33wF5mAYFh3r04RphF/TyfwnQdke7aOYA2nE5TkONWl/99USTS6hsZIHqQA3KVRkfv5781Yczpqv2SBpZRJVMooa2Bv9+SllVqOJD+ZfH8snPmoK5TiBf69V8hsWKn1jA+UB4ivLWbW/9oQGDABS1Xit/sigp0xkuDRvavu8n8pnA44pnxJgodFKf+JJJjJC0tr+5J8f+hppL5n49i0Lq3Owsf4awdD5xVJkKv73zHERjsa0gl8bBjANN7iQjuhPHIMSNoIc2ISvfC1hXL0MxRxss36F2DQOsVMuedhVcFRXZ/R5VJ7IgPJRIZZorJkwqNK601UNlqOc1jeY9of0IQlKv1dsf3hzXuWm3yi2DxpqtbXMz1xjsGsgz2CEfVyNboD6MrnApogkXllcZ/OM534Fs6N
 PQkjI85h
 XqvotQzWo6Ye95fEY7UUby6gtKbF36F0BaKk3hzXfPq+PBXAoWJAW8QtsGHfeOakmlKrdVTGT5Wk58+bQ7hlMCWhfwAHeaRrW9QKi/Fy54q/PSeAIPZ0KhTd+AXQGkrxpqRJMzDCS6iAdfwtGYXMKi63LpVlD82SI/yw+y50VY07erp1jToznn+KrVboNhOgprepZAkn1EmToSRsuVKC63CTxOQ3ere+lKZax44KgpH4zpWx1FzzDCFzVmO+D2+U3WksgdPsmWfHFnaJPgZAz6Q7wCnPeLy3X1qg+fkwyYrBg7WxHENtha5daVeUqSiEKWGVr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 7 Jul 2026 14:20:19 +0100, Lorenzo Stoakes wrote:
> Well the whole reason you're faulting here might be because a userland process
> did that right? The page tables should tell you (presumably on ARM32 :)
>
> And I hate to repeat myself, maybe you didn't read the whole thread but... just
> use mmap_write_lock(), this isn't necessary?
>
> What is this trying to achieve?
>
> You're not in a hotpath, why are you bothering to conditionally take/not take
> the lock?

I think it is not the same thing as the previous discussion regarding
which locks are needed for `show_pte()`.

Now, for this bug, we have two places that need to be fixed:
1. __do_user_fault()->show_pte();
2. do_DataAbort()->show_pte();

For the first one, it must be a user fault, the judgment of
user_mode(regs) can be omitted.

For the second one, it may be a user fault or a kernel fault. If it is
a kernel fault, it also means that this is a kernel oops.

For kernel oops, according to Russell's opinion, we do not need to fix
this bug, which means we do not need to acquire any locks, because the
kernel may die soon. However, show_pte() still needs to be retained
because it is useful for debugging the kernel.

For user faults, we need to fix it:
1. For user space addr (addr < TASK_SIZE), we need to acquire
   current->mm's write lock, before show_pte(), I understand it now.
2. For kernel space addr (addr >= TASK_SIZE), maybe we can omit
   show_pte()? After all, user-mode programs can access any kernel address
   to trigger user faults, but we dump the page tables of kernel
   addresses, would that be inappropriate,
   (e.g., posing potential security risks)?

