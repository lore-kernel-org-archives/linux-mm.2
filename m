Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76363CA6015
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 02:55:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54F326B008A; Thu,  8 Oct 2026 22:55:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D7E96B008C; Thu,  8 Oct 2026 22:55:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EE406B0092; Thu,  8 Oct 2026 22:55:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 181A16B008A
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 22:55:37 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1D9021C2536
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 02:55:35 +0000 (UTC)
X-FDA: 85301572230.11.A9D07F7
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf16.hostedemail.com (Postfix) with ESMTP id ECDFE180002
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 02:55:31 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	spf=pass (imf16.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791514533;
	b=7tpeBIBUyzlgtXfALfkEaybgESMI7kC0hxyyDDVkm7Wuh5GwYj+zIHsXf+wtz5Oubx3yIz
	8dwFZdufkFStSKXi2AfSTThzNNv49AXf2QJaMKSQmND1HeldP6OErC6QHTWDb9imUwgUDD
	XCfJuV0j+eVQu0ZnkQCEHo1X/yxZ5RE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791514533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A2Jn+JsLXKmFWLs2UHptA0poBei/0hha+vNqv0LEbz4=;
	b=7DEvrofKuDewhjFWBTitkew/vTR8sjDXQnL2RxByhgz4BdxiU6bUIFJ2LC/Y+ogSjus6VA
	5QQGmA0nBWkL/+Scwl1UW+Cff3QKFNzCyPW1P1UDjjpHvHlmE9gtFXxT6Za+U7LyIpS9C0
	WgGTkgJ2MjVdW1LQqIJSrfZ9i9FDkF0=
X-UUID: de843150c38c11f19a56ed5b684f684d-20261009
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:df38e0fa-42d6-4b4e-b220-42dbd4841ba5,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.19,REQID:df38e0fa-42d6-4b4e-b220-42dbd4841ba5,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:7db8b62,CLOUDID:7fa12509e2d68185632cecef8499b55a,BulkI
	D:261009105525E3EMKDQM,BulkQuantity:0,SF:17|19|38|64|66|78|80|81|82|83|102
	|127|841|865|898,TC:nil,Content:0|15|50|99,EDM:-3,IP:-2,URL:99|1,File:nil,
	RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,D
	KP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: de843150c38c11f19a56ed5b684f684d-20261009
X-User: lienze@kylinos.cn
Received: from [192.168.111.179] [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lienze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 138785289; Fri, 09 Oct 2026 10:55:22 +0800
Message-ID: <da938bc5-b0fc-443a-bad4-1a6e7e1cf41d@kylinos.cn>
Date: Fri, 9 Oct 2026 10:54:59 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/damon: fix typo and grammar
To: Manuel Ebner <manuelebnerli@mailbox.org>, SJ Park <sj@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: "Adrian Huang (Lenovo)" <adrianhuang0701@gmail.com>,
 damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261008162010.4010682-2-manuelebnerli@mailbox.org>
Content-Language: en-US
From: Enze Li <lienze@kylinos.cn>
In-Reply-To: <20261008162010.4010682-2-manuelebnerli@mailbox.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: ECDFE180002
X-Rspam-User: 
X-Stat-Signature: psfkhco85fdd1cbwtmou39z3okki41qp
X-HE-Tag: 1791514531-641437
X-HE-Meta: U2FsdGVkX18/VI+07JDtqWEaKIPx+cpMTSmVdj0twsjGjKSA7/YULxdDcKQgCtkRN9+JG8+a8PKRRhc0xl/ZhliHKmZ8ti0/tYsUsn0B4ybYPHcvsGeO2ud3LS7z44QeWuHjgA0YTRna5JUJ5e4bRrr+H5GXd3qUvA8TUhWphA8ayy4tgja30Rugv3PFQ2eeNJIZBowph/ROWVD5CbwuSmsab+s+sQyXQvX+wUYg0M0nXTOsRKz13hbdx0bt2yL+nPK+6uaLb/0I3hSo4LIVW9J6rp6DFfhV6Q//lSCLooy7dW5PoD878dNWghAqo7hrbAM57JZW9FiCn01qkXSxEPERvlAFEE8sfvlYxGEIGrZFknywInhY/GJ0NZ/VW2dTwr0Q4Y+MVTNk5XRwLesbikSUBIsOvhNgboKr9glYoyeFmhDs31tV8ql99rrNuR5ahNQF7T2cqWTDeL2pO997y0qGfkNpPMRzQD6kjyV3xI/vRO9zRZf8BNW4anYEKYB31sszQ+OBi++K1Qdt2zulNS9IkM7GNLXTn0JMx4tdvBcUW8H1zwzXeA2mKvPDL7Xx1wpyStBxwOoruYMWQC8FKgxmFZw9ni7GEFFjMGNdrAendfu4F3Z5aWteCZ18evVIQUFYn5xbmy1lqccsCm0u8drYM5PQnW76iliBvgD3xbHbgPBywRFnXzFxRbFtGgARnuBn577Tc7UgOQeJoOkb1+D9WOtsLRUS+zWjGDsfFsnfzcpolxBkere0W6J3CAkqO08wuyv3Niit38gEBQcbzpHm3jiQ2tXlmIII0Mww5QKMvo9RyNHvpm8p8cdVDqhMjubR5RatuNVI5PgO5L0dZ4tfO+YC118kIaQNtxHyEyCjKXXxUFoBpenlTpXC5ECUYYv3R2KLESQw3VxNdGM6B5fwvYfWCwQmdb9s5l1RJgsipxk4w689ZFzeWOIEwWYsG8o36VOeR5MX31yhYC7
 ncoH+PoA
 zDUdASD/VoMtmvvwMGxCw0ZwpKO4MTAqvILqHgf/89+U8h8TAlP9/rz+0VJ1dTyKLl5huNnO5AJZdj8z30ubYHAf79x4RRxH+RV6C2hdiIbgTtgq6AXXqlTazL0Vr5RG+l2D9nYNyxOLsQlVzm3VxgQ2J5i7ZzJKqm/T/pSFagRNEG8ER1FgCjWXKpQi7FB1NbpB2u+zH5/DkTJ4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Manuel,

On 10/9/26 12:20 AM, Manuel Ebner wrote:
> DAMON_RCLAIM -> DAMON_RECLAIM
> set as -> set to
> 
> Signed-off-by: Manuel Ebner <manuelebnerli@mailbox.org>
> CC: Adrian Huang (Lenovo) <adrianhuang0701@gmail.com>
> ---
> I hope I got the right git-tree. somehow there's 'damon/next'
> and 'damon/next/damon/next'
> The other patches will take a couple more days.

Thanks for fixing these, Manuel!

Your patch applies cleanly on top of the mm-new branch, so the git-tree
is fine for this one.  For future DAMON patches, please base them on
Andrew Morton's mm-new branch:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git (mm-new)

For more details, see here [1].

[1]
https://www.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#damon-maintainer-entry-profile

Reviewed-by: Enze Li <lienze@kylinos.cn>

Thanks,
Enze

<..>

