Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25AEBC4452F
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 03:03:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9ADF6B0095; Mon, 20 Jul 2026 23:03:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D48EA6B00A2; Mon, 20 Jul 2026 23:03:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C61466B00AF; Mon, 20 Jul 2026 23:03:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9ECC76B0095
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 23:03:11 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 20CC38039B
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 03:03:11 +0000 (UTC)
X-FDA: 85011287382.28.C13E32B
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf15.hostedemail.com (Postfix) with ESMTP id F13A7A0003
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 03:03:08 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PE29k8HI;
	spf=pass (imf15.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784602989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DkNtIMp/J18eg4sorgjLzrufSFJYeDEgHsB8O5f8hAQ=;
	b=EwyY2130XSvMVmJZiuoA8FzmCFiAnjZlbGH9MxREMC/gyKoNovTdaBbAo8iyVulXO31MWE
	HkdaSkLpr9IXU8jFrkHN3HJHM8pcJOaTGUQJJz+CFXT7E2F1DNHg+cHehgrC5cQhamS7Z5
	UKYdD1d4CKrv8xWUvYNguHuj6fpk9Js=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784602989;
	b=CKFfKy3HvPNu/PsHpQXy4NxvVHhhsKllN+V2KycvZUdupRLEGVsi7M62sDBK3LpGESmONG
	/18CDF3EPPKedQGOnQbE0U6aVE/Oc7rcnevVxnUwYRKToUTeoBUXi0Mk3Od9QRIlVGcMcS
	e9+MUp61bUAZV/4wxNRem1MoqnomcVk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PE29k8HI;
	spf=pass (imf15.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784602987;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DkNtIMp/J18eg4sorgjLzrufSFJYeDEgHsB8O5f8hAQ=;
	b=PE29k8HIe0IR4YXQFpWOImBtnvek5ugSGWjkUKjRPLjllLb5vK/Bk+CO3/OkczdaQY5T+s
	z66Z68RuW3zWUo/7tDxpcTs8pgZLS4ZsdPtuToehqniFekHYW56FWRL3GRNYPMtksMBN6V
	+vTkqhjHDhLQFZXgAPirj29qKbavdFg=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH] hugetlb: make hugepage_put_subpool() tolerate NULL
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260720073841.1389354-1-chenyichong@uniontech.com>
Date: Tue, 21 Jul 2026 11:02:50 +0800
Cc: akpm@linux-foundation.org,
 osalvador@suse.de,
 david@kernel.org,
 mike.kravetz@oracle.com,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <98A020DC-5600-4BB9-A30E-86DABA5A9D5C@linux.dev>
References: <20260719225438.041287a56c87effe61796483@linux-foundation.org>
 <20260720073841.1389354-1-chenyichong@uniontech.com>
To: Yichong Chen <chenyichong@uniontech.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: F13A7A0003
X-Stat-Signature: b1q45z5zs3z7jx9ko31j6ewwp98tmcf6
X-Rspam-User: 
X-HE-Tag: 1784602988-903524
X-HE-Meta: U2FsdGVkX18cPvBlLQiB3uVGmg5TVgGYhAGSXXAOnXGKBZj8Ta75vAU81yQTC21xwW+v3/dK+gdYKgHDPFzR7vcZzjVRNLkojOmuxgBKQ57CdAsttQabUoqPlpr7Q6t0juvmTsKnmpU9rZo++fdF3kkodKuNnd2dkFZRNccmVrJzULhfLtEgHXKQbZPLSNfotlDAlO2mqSlM1p1CGNrK9XRlkOkK/NI8wXQKBZY05tjeJQHMAbI4Iz5n8R0g/WmPz+szTDZjGUnIIDlBIgcA7DYQHbX+mtfc2frmVyUVY1FqMpenQM8gplhHeSvN6eCUOLK22gCYyG7fQvWvG5BUYo7He4lvobFiuCDCGCVAQL6KuS4ilCdU76zLo66DPfANxw+2VaSwRiwcENAfECEL+iM4wcjN9GNn/m9XgQQJnggJF5v6orAMs6wYJetqrEcDYUE8CM/cYAfwSR9C9IqjRevMTpEwvkOgkfUrfl8CbnepURiVWs7xOnvQtWzl88rPHW8WL8fzJpRueY2I4wNqFIj0r5FhGG9Tht1o9yqpi4VxRBRvr4GXnAqYoZ3szYIsq37m7tMCAQHwC7oRnGZ9mPzLGBQne4kWUlW7vZ/65eO862Jm/lM7EAp96AczW1guSfmW28XtLJOGEN5mQ58jUI45MZqQmL/WsrOim6IP5tb/3CbpifMaJeAYMMEat/EgrAzLmOihaQpjnBzNnNH3tZGvNnuamLQZdJ0mFR+978WPBWgU2F+ll+iUS9E69iKhgU7u8E8kcAwYuaxwImdMFH0/6pL8tuVlggtxlEMU6H2rwyzIdc1enz8ZqGbzri3NQJ5l4zSuX1CaeP0QKiEMCGbgrVFTZv/cQ7vUh3rNFmkpjDDJxU/TcQOasOWvUTELl26K20nw8YEoPmnJ4gdrKSmpRHa/ZqdA/ctyvpJ1T2ICVZPNLj3VMjVlDouCjib2OQho7DSRi4m6HuD1RwC
 Pt2H4b9W
 IlWtXhedZaXVppckKmD65Ad1PnGITelAnVaHzAcnHeg8bpL5uELqUceiNvgu1RChaNsjrCfb/W6a2C5hvKK0+S07P+Dsh049NU18wTY1zyjT1VRBlzK/smaNRRWNb7t3Yp7U4W1XxAjCAdkVbvFISrbN0ZFRZ0WVQanZ/+FInWTaoA7T/KP+hhphh+4RrzJFScoUEoEojf3yfkaDA1cs0SmFmPntVCYMzQtYH6rVrOZ0TD9+goXeXcBds+U8SAXm9uAARay/uruQoVCar27UO2qdeDGA8DdEoXDAGgTLIaceFQmOBtT+6ILuLx9iuV86keXVhuiF0bZlj2SW6eqfpad/Chb0Bgx3yf0scSclw+PUKUN0zImUj5w3ML1JRHn+Y8390
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jul 20, 2026, at 15:38, Yichong Chen <chenyichong@uniontech.com> wrote:
> 
> Both callers of hugepage_put_subpool() check whether the subpool pointer
> is NULL before calling it.  Move the NULL check into
> hugepage_put_subpool() so callers can use the helper unconditionally.
> 
> This is a follow-up cleanup after using hugepage_put_subpool() from the
> hugetlbfs_fill_super() failure path.
> 
> Signed-off-by: Yichong Chen <chenyichong@uniontech.com>

Reviewed-by: Muchun Song <muchun.song@linux.dev>



