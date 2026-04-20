Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E04BF557E4
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 08:36:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC8396B00E2; Mon, 20 Apr 2026 04:36:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9FEF6B00E3; Mon, 20 Apr 2026 04:36:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDE0A6B00E4; Mon, 20 Apr 2026 04:36:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CCB926B00E2
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 04:36:27 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 363B813BC98
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 08:36:27 +0000 (UTC)
X-FDA: 84678277614.13.AE0E0BB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 819FF1C0002
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 08:36:25 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OyNb3JVH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776674185; a=rsa-sha256;
	cv=none;
	b=gw3nqubAzyk6vt03yCITvHwrFa5y1A6DNIYeUL25v+9Yk6TZoEptJVDMnQNYOphhMoTZYh
	YgcVpHoPx0e9pDBhBIRxckbMxV1SnamuRfVJ8Ilrjs3KlHd+n1k/8YDKNhFxBFlXmLIT2U
	ZUdPhVMblNTHJ2pwHQGMpKVPdUmhhKs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OyNb3JVH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776674185;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VU1KE2XDGZG9ypBZarFY3mIw53EwZD6ELbSUCOSxzHA=;
	b=ymMzeoXd91s0etOYtHdgLHwVCcMJTGek5CEUQrbKw7pN9wBsvJXBSBGD88tt7Nke1UEO06
	vEFAVGoldWkhO5bWOHn+GZ6ITl+8DH6GBax+/Dm1Hm7p3A5Ai7CDoxN0pCBVn9/pgJ/FlG
	JOY1i0chSx4ByL11Re73CKZ5LVzEYyw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 549F141A41;
	Mon, 20 Apr 2026 08:36:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 775BFC19425;
	Mon, 20 Apr 2026 08:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776674184;
	bh=ZjSMC1+rQxb7tT18VaXKCGLg1fOlc/Ds+iviih6AekI=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=OyNb3JVH+N9z/VikAd0HqfX471mryIlcQzZylQwIHFI65x6mhe+7d+nG1yxGi/fuf
	 5c/DE8PeTOXC+JWdmg7y404PGdBuitmEf7920+6jRYRW2Y7wWvokr7u3Q5Nx5Fmqp+
	 LmMXQJzGZG6LUxWlaXkudra28vhaCjJ4cNuUU4/+7fEPWe7mBZi5VeDOeehMIklUqJ
	 JrZkqmYZqbv8he/E7QJ/7NiXc/A9e8+eaUyNt/iULeaNH/AEOBicAcnAPi0BZl1Ot/
	 WuyCAXJ2pPPNqvmfBUXtqWXZ2gaEcKzEQbzvtXAAAeWWdmuCtUr6eFmNyUbCNjGAXU
	 F7OkKfzODkn3Q==
Message-ID: <b5848615-c4f9-4d5c-9f17-2a8e63a5651f@kernel.org>
Date: Mon, 20 Apr 2026 10:36:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [mm?] KCSAN: data-race in mas_wr_store_entry /
 mtree_range_walk (2)
Content-Language: en-US
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 syzbot <syzbot+38a879f4a73497f2dfef@syzkaller.appspotmail.com>,
 akpm@linux-foundation.org, jannh@google.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, ljs@kernel.org, pfalcato@suse.de,
 syzkaller-bugs@googlegroups.com
References: <69e1f975.050a0220.1de265.0009.GAE@google.com>
 <twv35g3umuktagxixl7q4upjz6hxf2rkep2ophcwz2qzbschrf@dy7lcxu5wrly>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <twv35g3umuktagxixl7q4upjz6hxf2rkep2ophcwz2qzbschrf@dy7lcxu5wrly>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Stat-Signature: 6m8dexibkyucsxkbrzznm5u5n4d56aoy
X-Rspam-User: 
X-Rspamd-Queue-Id: 819FF1C0002
X-HE-Tag: 1776674185-827371
X-HE-Meta: U2FsdGVkX19I5gG/XLge5LiH44bfMjZOfEvR2xtnV9aTmDa/4bMc1V5/uKwQQwIe5q0qWaU61RBZqTDqI0aRvVymgw585Gy8+Tn0PqeenrJEvqYvw32vR99P0HP9Npl7KxkDpjh9lcrifbEpkS6oHQI3Ll7kkgXtdMMQMnlZj7cXYTo+6U4iRPSFIiX14CK7v2UrS9k4unEktziwQJaBUGIdvVkQ5nf5KMD8pucA2tatBLDkr+FnGBTnenWElDGEhxaUd/PoSXCe4MTOxHmNhtrEHX4Ree9IU56v8JkAqKSElcu95Xc/sCgDvy7qYWV2zqzPk5foLzHFJKzIRLm2u9/UUGO9VzEOWdEkAE7KpbPOWZnwj0q0Bu1bXB9Wk+0NGLjqVDxjnQwVT4CbcS94kwGGci7gZiMXQhybHvvnzVq6QAI6MVpAMSdjiezr/fLDkFM5VDFcpYiUM9YYH0PQdgI+kYb6tbi/rLmE4b+C3xOjPxc3Dsdaop9dFv9E527sQ+qc0CCdrry+eae6j2dK4vbKmPR6FvGU3IV7muIPXXwXkf0wDCEtrz/5EkR9Fsgg4D+ZtPt29kgbXvP9xhWCLu0QY9zdz8i70c1lrjP3d7ze5S9mwHqITceILzQONB92FS8j8XHgjjdqyssYiDYOAFldlHYCJiZxPYm2puUD7ermpHusGmRdRD1IB9EmMmHcQRj6F2+vOZUv8Qp+QbRf6cjswFrWXe+PloKjZtsqkcmBQ8ax929YUPej273a19RB5f9R9LKPhNHX9e/ZDu0JKofSEgr9EfPibeBGXhWJ+y0ijW0ZgBWOA/CvYSAZigZ5FmcX6dW4A3WmY1fI/lVfPbdfvlqtOLgV5qLlu+I7/f3Ygyrk861ldl5OiACKnoDGEa9samF8VCf3+aRKT2i2q5lKObcsXHD7Ih5RbI/tlqIVAurZc5XPnIB0T64UWrN5GE5bH+KlOOGHjqG2zlp
 h6iYiTxr
 JPcU5hjFXfRsLjY7VDwZI1xbNCM3vcHiGHvH93Z0tpgfK1OZWWUmbmERKSzsD+TmlzGLWNcO2rInH+qc1qp9eSHvmLyMwbaRsX2dvn6AAoEbPa126IvBo3asbxKxPdlbgkqwgSf34kKfGiDPGhu5nt8EA5f9iueFNNJypWa7KsaOsiGr0gI738qxPrqAwMRViuAim/UyR5s65eXs9hL7jJhy7U/buBrRiLZ/4LAeBp5wm5YbynzL0FpIol9NA9Sn0XL3CkVPQjMwLiGG7TFsNi5XDMAsMfoj0CLNsE8OiNxZvONvY6w2CW/tl/sTSayaKgmAPjpudta5YDXU8/U7n0DIUb5QQBnu7x4yjFletYMU5vjFamo3ELaGXGed2EqfTvzgfnpDn/gju0rhTyzKs3UKbaHnqWVHcZWnqsfLVFfuJbxAE+C3hNUgsLowz/H3vEKzx7WQPtgnV8BNCLh3fnT5Qay6ckOvEm27WupYBxEYK3aEk+DREuTtps2MZDSrBfpfQUNWLDrR0jYOWUxE9ySQqJHfhbfZoYOdtfWl8pwOykPsj4lcH6qSRZichGEYwezxtRJbjMNHy9Z0f6tmgCUB5bDBtc8fBs9oYLeoz5O9dVWM127gKr0hAWjm4dGqqvHjdkZLZjovPM/8c7NmLayjiTxrNmfpHFAVr8rZF8Kv+TmiJMWbt3fnE2cLf1PHjp0Xi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/18/26 01:50, Liam R. Howlett wrote:
> * syzbot <syzbot+38a879f4a73497f2dfef@syzkaller.appspotmail.com> [260417 05:12]:
>> Hello,
>> 
>> syzbot found the following issue on:
>> 
>> HEAD commit:    1d51b370a0f8 Merge tag 'jfs-7.1' of github.com:kleikamp/li..
>> git tree:       upstream
>> console output: https://syzkaller.appspot.com/x/log.txt?x=117dc4ce580000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=7f207c4b1fbf85a3
>> dashboard link: https://syzkaller.appspot.com/bug?extid=38a879f4a73497f2dfef
>> compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
>> 
>> Unfortunately, I don't have any reproducer for this issue yet.
> 
> ... and you won't.  This will work unless we tear aligned unsigned long
> writes/reads.

Note I think the reproducer here means code that will trigger that KCSAN
alert deterministically (as opposed to fuzzing), not something that would
depend on whether the alert is pointing to a "real" problem.



