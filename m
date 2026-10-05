Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB415CA5FF1
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 02:20:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B5056B0088; Sun,  4 Oct 2026 22:20:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 465886B008C; Sun,  4 Oct 2026 22:20:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37BC36B0092; Sun,  4 Oct 2026 22:20:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 178516B0088
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 22:20:08 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 908451A0C4B
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 02:20:07 +0000 (UTC)
X-FDA: 85286967654.01.1511BD7
Received: from mta0.migadu.com (out-101.mta0.migadu.com [91.218.175.101])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4598820005
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 02:20:05 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=v6tUDCQR;
	spf=pass (imf13.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.101 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791166805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8nPpl7GLrPQQE/oDEXMZg1667cGdYmbsDVBweP7Qa0w=;
	b=o/1yFMWgdxlsecTg1eIibU96ImINb89ZTSkCCSSSCjNHKYT96D0QSjmU6LQLYPMnkl1J1P
	FmNMJ3DkSFbrHFuh+tFQnTvpA2bQ8ZAXJfeWEPWQMZcHZPnd99vKI4+MsGpcYVtfCTsuig
	ec53tDRqG2OukhKPgV5W5dngrnfj55A=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=v6tUDCQR;
	spf=pass (imf13.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.101 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791166805;
	b=C+qeYG6QEYT7ggjoBr4DrJfTQDLPGak0ReiSZ5wtbL37XS07aKi0pn+ph7FOzJkVWwgXfG
	uDSZF51r4IOo7BzzfLrh0Egp2FQ0gifS5JOe5/p8v4bHpYkoeDgWKcEAF9nzRq8dN6E8U2
	RYgW8MZU54n3a41O24zhVlkeVsWhgfQ=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=xKi0fX2xbV6KEgiTf5sK2JRYLQwgg8in4PK26lZnbGc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791166803; v=1; x=1791771603;
 b=v6tUDCQRHGh5I1Lz048HFXRrdxOwL96yS5k5fXchQCrRcTIfYe/JNgCgZ1tUOdC7H3JTYgwu
 cfRrnDLRZyK+XLjwuW+qqw/L51Ghk8BerzYpLvSAV69Am1oui+YoiGkZIjO14v/Wzk2ORMslPxD
 6hlfG46aRtefryzGLFvFdJYM=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 4cae8ba250b31cd8;
	Mon, 05 Oct 2026 02:20:02 +0000
X-Mizu-Trace-ID: 4cae8ba250b31cd8
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org
Cc: neganhat@gmail.com,
	david@kernel.org,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/gup: fix NULL pointer dereference in fixup_user_fault()
Date: Mon,  5 Oct 2026 10:19:57 +0800
Message-ID: <20261005021957.5254-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261004125601.c06953a6f0660df9859b0c2a@linux-foundation.org>
References: <20261004125601.c06953a6f0660df9859b0c2a@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: g1zizx6943kmgqdugoc9cpx4iaic1kaj
X-Rspamd-Queue-Id: 4598820005
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1791166805-277396
X-HE-Meta: U2FsdGVkX19d3AnihCCoAB3nAzwc1Eo+vBPGSzm6dfVpogBc2rKw3l/kGTc3SwvF7pwYwmjWvespgOU0YhaZOjBJKyj3NCl9TC74NmrIKySUTqA4p4xwKonBQ00jccB9Xr6+ww0ien/mBMwINRIDdfDV/TMquxTVKlo5aFkuMpr7sYfK/KvD5BEfBCZ3cQcs2bza1svWn1wIW9MhL9/fCSwV4HBQuABr31gTbPaHsVeAbYx3gctwVmB+xQrS4ezVtBCr5n8sqB3CIF8clCCwvcMF3qMNwxzYtxtXWXtbUQeQZhgF5/8rdqaoLVMDMVHbBe3Zxk7+VWi4isG5zbgn3EkJLT5rcE1XOCW3g3F/l7IdJL+e0IpajrfjYKJs8wNJ/Bn830+EP4Rhq15VNCZXeq30ohivYwRNvRwWftIco4mn2GXtOcHRHRErSTHqGv5EVSlj6IzwdAuKzMrM6zRKCfGTI6Hg4jNboMCBSk1yNJ0NFvio1O7G03jLffi71PTp4u0mvLzKE9dqkhH6iItWoxdB/8N3wm++jyxWfRBaP9fYHdGlX/7cL/au55zu0NFoje5qRaY1eDI/ZO3sARkE8vlvxQdmBPzObgKPo1D0tTHizfbg0hVEyBSkeJU2jq2F1itnc5GEYeXCZ7KLuElrkaketKIibxRjZICwyBmHv/qBC/rlraZvalgJDuhn8Tg5ty4mJn/Wd3etUb20uKJY3k5VfFpzLLF24p23S3J9hayZdQAMiEx/JVIxWDuP8Pa7ngv4S/xBof86R9Q5/MtRUuezwhazwmRAoOI7G0UGw2ozT7VGgqStwywylXVgeLsX/1fL9gUnRyXwuqUlrEBCBYwLjG/ew8SP8LOzUPHS34biQmEp5RlgvVgp5I6QqvqAx31gmz0FKhLb+M8iOWG3vLkSbPFR8VXVHXfTZxvguA8ibrOk1cUBGpSfxWBQBVB3yMqZxaMzCmKEw+J7jRH
 jrZ7Qwvg
 P2I41ym0s8pkC6LmDjD1kU6S/FlJG3szkmBVjP4QvqZAc31wr0+Dm8SQfew2jEnFknt/80cwConvt4Djy6VKiZzE9j1/qYy1qL723o42DYnrkWZkwkRggIHk8k3BH+J/9qLta7+Im88xHDDYQQ7k7fvPsbMGV5MMScJwJSTH3ynlE54o+v+FOgmMUXUrLaOSJ7zgNEuIVrhdZ8AaqYpt6GsbdsRnBa3709zLGuPe5mW7zAa8pti03QX4gXJZ6+USnzbj38TdrUOCEIBL378XKxXtvDGcxVdDkD4r2VBsDScK+wkzeFE9uVA4WNQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Sun, Oct 04, 2026 at 12:56:01PM -0700, Andrew Morton wrote:
>On Sun,  4 Oct 2026 02:48:46 +0700 Nguyen Duy Nhat Anh <neganhat@gmail.com> wrote:
>
>> In fixup_user_fault(), the 'unlocked' parameter is checked for NULL
>> early on, allowing callers to pass NULL if they do not track whether the
>> mmap lock was dropped.
>> 
>> However, if handle_mm_fault() returns VM_FAULT_COMPLETED, line 1597
>> dereferences 'unlocked' directly (*unlocked = true) without checking
>> if it is NULL. Callers like s390's pci_mmio.c pass NULL for 'unlocked',
>> leading to a kernel NULL pointer dereference when VM_FAULT_COMPLETED
>> occurs.
>> 
>> Fix this by checking if 'unlocked' is non-NULL before assigning to it.
>
>This code is too subtle so you aren't the first to attempt to "fix" it.
>
>The key hint is in the kerneldoc:
>
> * @unlocked:	did we unlock the mmap_lock while retrying, maybe NULL if caller
> *		does not allow retry. If NULL, the caller must guarantee
> *		that fault_flags does not contain FAULT_FLAG_ALLOW_RETRY.
>
>Trace through the
>FAULT_FLAG_ALLOW_RETRY/VM_FAULT_COMPLETED/VM_FAULT_RETRY logic
>to confirm that the null deref is a cant-happen.

IIUC, that's indeed a can't-happen :)

