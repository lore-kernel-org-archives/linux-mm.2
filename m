Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DBCECCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 09:32:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2E778E001A; Mon, 10 Nov 2025 04:32:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADE6C8E0002; Mon, 10 Nov 2025 04:32:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1B978E001A; Mon, 10 Nov 2025 04:32:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 91AD98E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 04:32:10 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2CEF212D3EE
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 09:32:10 +0000 (UTC)
X-FDA: 84094181220.17.54F1D41
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf08.hostedemail.com (Postfix) with ESMTP id 29C6E16000C
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 09:32:07 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ghppzoIr;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762767128; a=rsa-sha256;
	cv=none;
	b=AVGSQ9VTm0Y69PzyHicW/yTH4Z+Odaek3Yn8p0VrhEbpaW/mu2snT9nSHNJ8FwbSWhly7B
	wP+eRYE6w4jqwPl/sPYhEaIfWaMr/gRe0ZFZLq3tjdFEUiN/OUlquxdzvCHJG+2yfquOtS
	cjVf35Wuguz42/9T5m7kjuIFCD0fCbs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ghppzoIr;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762767128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2ClMFlGw+3oW+Mx09+T/4s8CBInH2qbgvOkap9Vt6M8=;
	b=A51vMIRdeC7TDcRr2hG0lQtijMzkSf4TcEo3sDpxzg1gTLDtzi93ZB6enLGUDFQ+ujkqbv
	iaQwYwDjEC9ndFr2QAL+Eva6D1S2NmSdqy2nxi8iYwjTxDdDXqIuJ7ewkbzqtLZVJJDALS
	SHu6ARFN0rGNg2+li16IKt7TM0RVPns=
Message-ID: <b3f05987-74d9-4e6e-a18d-31e64c92337e@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762767125;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2ClMFlGw+3oW+Mx09+T/4s8CBInH2qbgvOkap9Vt6M8=;
	b=ghppzoIr9fx6cD8ZMfCbFqa2KZA907YF/YA668q73DyyK8bg2shk1VN85RWbYu0Kpyi5Vb
	6sblyfDy7g/nARJGFPlCAaj3C5TbcF1ndDGoSWRerKBQGaRhUdXAlTefbbfVdYs4x7suy+
	s/7TalOfMqKoUWP1tamsbc7gZXJJSYw=
Date: Mon, 10 Nov 2025 17:31:48 +0800
MIME-Version: 1.0
Subject: Re: [syzbot ci] Re: mm/hugetlb: fix possible deadlock in
 __hugetlb_zap_begin
Content-Language: en-US
To: syzbot ci <syzbot+ci5a676d3d210999ee@syzkaller.appspotmail.com>
Cc: syzbot@lists.linux.dev, osalvador@suse.de,
 syzbot@syzkaller.appspotmail.com, linux-kernel@vger.kernel.org,
 david@redhat.com, akpm@linux-foundation.org,
 syzkaller-bugs@googlegroups.com, linux-mm@kvack.org, muchun.song@linux.dev
References: <6911ad38.a70a0220.22f260.00dc.GAE@google.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <6911ad38.a70a0220.22f260.00dc.GAE@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 29C6E16000C
X-Stat-Signature: cwti5911zciwdjma1p57jker3131zj6o
X-HE-Tag: 1762767127-956823
X-HE-Meta: U2FsdGVkX19wwvGs2qd+wtd5PFdQ0XohdnjmA3rkE8ePrbANVz/WGI08XpfRCB0DPvesIzhgXpzC0Ray1PWGLpqn4eJaVp9PZc2Uq0VAU8ylTW1vf7QzbiOhZyjqQR5WM7Ft3cnqVA6MOqqGk9Xd50vHSK1X3moBYuAF14v28oWRXk1JLhLUzyI/YNkpD9kW0KMEZoanVVEUvNQZsCKCVdnK8fcoYi7dGvUgailzpT8Z0YxQEiHztB9VuN+82nKaNdvuM3g0KRF73Jg1cPXzRDh5eFGEPG5kxYa4tSrvo+B5kqghZo3F+ETgUhfhapkSRz2bBB+Vk7HuixYO2OTDKNHOb4Fk5CiFxptNEhmrDpcNIMANmlVoeQvWiohMcCxmVopu0dfJhKcOZbHVDTgSGkj/SlfXxRL/bgXgMGdFXgEw5MGSST1r4DUAN2ZI9WFAT8YaDqyNrTL54m6Wr6xD7NfXwHMQzlB6ec54dZ4Xx7Js/YDCT9uUgaihvxi2l7m5S65UXPCmLHc1FjnW5ytuq8mnpIMjLaBDoPuF3a5lEMGsSoz37/ejd7YiD4J1KDYcOcgw7W0lJmBVwgYs13HoQH9i+NQYO1tyDJqnlhtYmONqg0pP0H2WVJAnh/vHd2yIwlYc0q/y8oYYo/ySYzrN9afxGNZ4M5D5xeu4vcEznRBpabiqBgolQ3mFr0a1RfBcc/8FrIY+JmuSNxOUMdlqUY53jRB5/Xy+gPHLUDAM4hhy9rlcQp3w3j0Q37vUd4jihWvMk7FwM46JKDFgz3nG5TYWrnzv6EaDe6KIL+j+C5viDDtVF1LUa6eh2/XAM4WMas1UkiVMBlDM84R4eL5Ah5DEUOyvLOHMnuIQEgrUuhah/OdlJp/JBt0rtPRgavCjZ/U5gu2fJqoR1HU97eHNwXSkV29FVfF/Izkz4Z913LVkU803tEh/aAlVJFldH6TZwAznz3MGk96NU8MAbuI
 6kSUaWb1
 vhyg5beBueZHIyTGDXlWzQRhZYjcYx2FiUuldLVrZhzXigUmW0jmGUHQCQS/xpw4MSwJaIYVzdGTxAtNlb4wwuyGnHnuUaASj7ZDd1aQdbYfZ2JCmCPEeodx3lMqsaHx+mbkusYircAtsX3ZC6nt1fmhFjnlWcoNKtzhPHgWDXHkqzpwVHfECPxE1ZBfpIqVbSakFhQpksn/G4qYAckhTwfAePoJuHEDc9j3NoJ1Vn2/Q7G0x4O3NqRy/IySiVnUjQ6Itl03thmL3F+LBVbPRj6HYnf/9etEF3JRtSAE47inxeubHuCH4wmXs+gSP0WsRuf3yovftLGpEcMUtThcVrLX0brAAwpF6e75tPG2D7zSqV3Je3EMbfTjfTQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/11/10 17:15, syzbot ci wrote:
> syzbot ci has tested the following series
> 
> [v1] mm/hugetlb: fix possible deadlock in __hugetlb_zap_begin
> https://lore.kernel.org/all/20251110051421.29436-1-lance.yang@linux.dev
> * [PATCH 1/1] mm/hugetlb: fix possible deadlock in __hugetlb_zap_begin
> 
> and found the following issues:
> * possible deadlock in move_hugetlb_page_tables
> * possible deadlock in remove_inode_hugepages
> * possible deadlock in unmap_vmas

Oops, this fix was incomplete, as other code paths with the reverse locking
order still exist, leading to the deadlocks reported by syzbot ...

Let me take a closer look ...

