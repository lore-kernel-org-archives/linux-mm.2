Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7492C606A330
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 02:23:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0D0D6B05B2; Wed, 25 Nov 2026 21:23:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABE1D6B05B3; Wed, 25 Nov 2026 21:23:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D3C26B05B4; Wed, 25 Nov 2026 21:23:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 208016B05B2
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 21:23:06 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 93DAEA8B58
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 02:23:05 +0000 (UTC)
X-FDA: 85475672730.08.DA26E08
Received: from mx1.zhaoxin.com (MX1.ZHAOXIN.COM [210.0.225.12])
	by imf09.hostedemail.com (Postfix) with ESMTP id 53C9C140005
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 02:23:02 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of jonaszhou-oc@zhaoxin.com designates 210.0.225.12 as permitted sender) smtp.mailfrom=jonaszhou-oc@zhaoxin.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795659783;
	b=C8rFj+096lfKsLPsF3hs2OK/b83nGCPFrTUeuZjICtRh+GdZOTo/NUQfc9AE0fn6xV7Poz
	gSfOHvuXq/TUQ2dsa20vu37nm3zaGtzMsZAw3sO1wj7Dc6kqbcxFwRIwiO6kz/slESjiWU
	VJT8UFSkMzhEEGsE/FPUcNzRsHn0XNQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795659783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ri8aUWGj+gFpVZhXpXUT8xBhhEuxSbbaiB3NQCc6Qlk=;
	b=2QJulanT1azNpPV9bH521y7ezCEGunUop+0BDiu7ipNPFiTkzys2FqqLLZ1LbEWZr7rjLs
	3KlZQyto05a9G9BEJmXlh1T2orAArQjecIVxKLvHbGksZ1Yrrk0Y1NV1nIa1BkHBDzz+O5
	kMdHvgBv6DKbzXLlKwx3zksFCMuBaXw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of jonaszhou-oc@zhaoxin.com designates 210.0.225.12 as permitted sender) smtp.mailfrom=jonaszhou-oc@zhaoxin.com
Received: from zhaoxin.com (unknown [127.0.0.1])
	by mx1.zhaoxin.com (MTA) with ESMTP id 4jZgLn52xjzbKS9Q;
	Thu, 26 Nov 2026 10:22:57 +0800 (CST)
Received: from zhaoxin.com (unknown [10.28.140.201])
	by mx1.zhaoxin.com (MTA) with ESMTP id 4jZgLl1JwQzbKS9Q;
	Thu, 26 Nov 2026 10:22:55 +0800 (CST)
Received: from zjh-os.zhaoxin.com (zjh-os.zhaoxin.com [10.28.44.129])
	by zhaoxin.com (8.30) with ESMTP0c6d7756cda0e14222fc074603a8512f
	Thu, 26 Nov 2026 10:22:54 +0800
X-Eyou-Smtpauth: jonaszhou-oc@zhaoxin.com
X-Eyou-EnvelopeSender: jonaszhou-oc@zhaoxin.com
X-Eyou-From: JonasZhou <jonaszhou-oc@zhaoxin.com>
From: "=?UTF-8?B?Sm9uYXNaaG91LW9j?=" <jonaszhou-oc@zhaoxin.com>
To: akpm@linux-foundation.org,
	Uladzislau Rezki <urezki@gmail.com>
Cc: JonasZhou <jonaszhou-oc@zhaoxin.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	jianhuizzzzz@gmail.com
Subject: Re: [PATCH] mm/vmalloc: avoid false sharing with drain_vmap_work
Date: Thu, 26 Nov 2026 10:22:48 +0800
Message-ID: <20261126022248.93889-1-jonaszhou-oc@zhaoxin.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260825104659.100134-1-jonaszhou-oc@zhaoxin.com>
References: <20260825104659.100134-1-jonaszhou-oc@zhaoxin.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Eyou-Sender: <jonaszhou-oc@zhaoxin.com>
X-Rspam-User:
X-Stat-Signature: 86f6kskr7ifycsw9hcf6zqsrg4q1eywj
X-Rspamd-Queue-Id: 53C9C140005
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,FROM_EXCESS_BASE64,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795659782-815303
X-HE-Meta: U2FsdGVkX18IWSbS5LdljohxZOzcNFGuyqLADoRRExhEGLW/E6KY0xQJz9NwPgq5IrmiLpdKfvt7sizO+EyhkjxRCDhf/oYEmshSscGrOQhXuAm09AXsgFWqotM8OAysh2unBizvieiZq8gt3LQFgzUFpFiR8v1zPPIhT8Hh9U6VvwJ7dr9i+vjLHlMTA1JrTSzyqDR5I/ya8If8dSvLoTYUZ2VXEPQjvKEJLUu8Vr4694ZOB6NW28wrTIrNYTPcxor+pY08I/o4HwdMZH3tuRly7boQZXZg7mDWkQQytxdyxcTSlBx30y5x7nhg5QIR918PWIr8gPM/GdiqM08EI0LMj2B0+K2k96iFeUppVhpWd+Awromn5f9YPDOu9ImD+g2Gcy2CN99VBFs+0xnRQvvPeeenKOGmkrnq5I3ENJLg+TEUdfsER7I+foz0XrsaYFmwVyqF6NPYo9+X8mIsGEAr3wGj74J4mcUgFLdsxa/JfbTTtYB3Va+VxybWhnGC1n1gbXm8ICGaqPf2mNW2yeAsdyPQRYSnLQ+uRBlkfAS0rr4FpB248yryVZ556Hw4ZZb/zhEv/KZHOBhBH1YkszjeVQdIM0LH7Jrgwse9FcHH/wTdfiTdkMmzbReyBxwgZzrbGQ7hL5Gyob/T/p1hNpcUuEN3gWmq0j2enEAJYiZKpt5uht9viCz1KKpNO/b4fZgTXzn+zmaumqONT7EFuoUuMsCxWSwup2bqE65rrjb7XQcZNILNciZoXXC+g9qfFz08YsmvWq4EN3ay6vcXQA2wPohw+Y+y6GECHLxLLWU64pFZczJByMA45C0ZPbRBsNv8WaF1xYzarIWBp4dX7YpGwMt273hLhh2SFjzRx1Ddpgs02wr4IixPhxG5LXaHnX8x4HYxH+5hMhS6OPegkZpW27Px7ge5yGjVmc3TN7i2W7pxo+dS1WOwc0ik4dXdAIOAfA/ozn6GyTMz38b
 aggSCS61
 DN3zbKF0hwUxPYmKtBPwmCXIphxUlF/V5jqagOCIKLk3WnCYa+5wUfqdV0AdblhcHbFa9/aSuDMs6Txt1aXF+daJ65hiJcIc+FqEd7cBV1eQNTF4SiGjw0x0+qRrQY6d0e2Ny76DGscQxCraD7io84fRolcE8DqSumMvAv/0Wf9DCoYc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Andrew and Uladzislau,

I see this patch is still in mm-unstable. Is it being considered for
the next merge window, or is there anything you need from me?

Thanks,
Jonas


