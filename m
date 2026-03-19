Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D63A107526C
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 07:22:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45A9C6B0416; Thu, 19 Mar 2026 03:22:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 432CC6B0418; Thu, 19 Mar 2026 03:22:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 348876B0419; Thu, 19 Mar 2026 03:22:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 233416B0416
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 03:22:57 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E3B401A03E6
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 07:22:56 +0000 (UTC)
X-FDA: 84561970752.03.CB5D966
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 214E780003
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 07:22:54 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="N/7v+bPw";
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773904975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HC2tqt3ndEbAW41NYAhPFbd6tpa/lOQKv9gO69TpWog=;
	b=zo9v6CQ0ye4UINp0Xz1jfQ5Qx0VoCjq+UCu/8Ia0j114FnqrGI/kvDYwwbaYdRUIY3wmE9
	Yfk/aDzqWzzHwREKEYIi6wb1rY2Qme/A5MJqRiULiUdQFhANbik1zd+/UVvoMXvRaddnKk
	zbQSkX51PclgrWwwxdcYiq//efzXipw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773904975; a=rsa-sha256;
	cv=none;
	b=qajXYam/0xCe7NnbOrWLbC/j51Y1ro5s/nZyZnxqTI1ibirLXpvBZWK2HcDPZuQ21VueDm
	iP6D9u2dgoNs7RHsE/IDw3Y+vPadprsv7cBk7LVLEvKYii9ptfnhwyk6R2DRtqQ3FajFs3
	l9DRLJIMDT9I7JMAMnsXPp+qH/OT/JM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="N/7v+bPw";
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 39234440D9;
	Thu, 19 Mar 2026 07:22:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E7D1C19424;
	Thu, 19 Mar 2026 07:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773904974;
	bh=8APT3xzzowj3H1BPyY4pqnRgysNng9Ci9Gf8mZR11jk=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=N/7v+bPw6brPpDF03HP7vlSS1nF5TZl1p3jhZ0YioAXqKqJ5ZXrd0q5eMeeWDSnmq
	 yPnvSi73rvqzbptqGrUvXzgV1PCApu5hGIFm3pygZoMyU/AilhxVbwYiBV1FWNjGmB
	 dbf0UvZjeZujb2krx+iXs70wXYWdJNrnMsPBEnhQehgJTBTOoeV77R4+yeURq1EaLG
	 kXCXGk0io/HC7Z+ggNwSI2odExPgFKsEbMT7+imvSeI/4TrKJZFWdjNM8zDSioRYWo
	 O1WmNrVfrRALQIWGqKT6IHrLRSJltatSz+jHgxGP2p9NkmRmAO/JPOQJE6bUtpk+Pq
	 hE90HTYFpWFQg==
Message-ID: <ede0988a-a031-4d8d-82c3-ed6f3de89e6d@kernel.org>
Date: Thu, 19 Mar 2026 08:22:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [mm?] kernel BUG in collapse_scan_file
To: syzbot <syzbot+8961cb270ae74b4129fb@syzkaller.appspotmail.com>,
 Liam.Howlett@oracle.com, akpm@linux-foundation.org, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, dev.jain@arm.com, lance.yang@linux.dev,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org,
 npache@redhat.com, ryan.roberts@arm.com, syzkaller-bugs@googlegroups.com,
 ziy@nvidia.com
References: <69bba3c0.050a0220.227207.002b.GAE@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <69bba3c0.050a0220.227207.002b.GAE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 1tcazwdc9f833xgh71kiu68n6wcputfk
X-Rspam-User: 
X-Rspamd-Queue-Id: 214E780003
X-Rspamd-Server: rspam12
X-HE-Tag: 1773904974-174642
X-HE-Meta: U2FsdGVkX1/EJl3W3afBhqrDycAxxaNr9KrmNcNPw/g1y4idhm0Fwn6yRhadpjXJDvjeGqEKjc6m1+/+MBxPZp+kQTJjxuE4vYNqel619VAyyAnm9PTH4vBqTcb86QsSMKBRJyYr7cWU4pGWupLa00vu9idm4/DcOvlMHQyCfcE2IaFsUbY3DcFTpFhK47sTPI2dJgDXZ7daPKvihOd0vanHVGPiItFUef24rlL6F2pp9ob75qY72ZrbyZOtMshXl4ciJ9pxurAj0TNgtluZQ/uq5CJ7OD3HyJyO7Zq2D0Ew/LFmxS44ud1q3t989rEq9rXc8JrKOEJDQreI59nnVM4qxsHfEkS64ycXkHkyNXcYvhwkRCqCcSKOluIlMkNp6KHvuf6h/OHQIhjUl7WxgiT6VZtUqM3kglKhkRtZZ/BvCE7P175OBX1EvqvLy2zP6WOLuKTStjxU4iEqsz+vZsUo+vqitbULJ64QmKS6kx4c11ARUF1Jeg5/IwFI42rD7ODeeNh5Mp4JYi4YtF0bjCCyaoZAcI3/xzp3DugWrt5i8uP6YR0pIU4KAEEKQ66BsEUQD228YgMKSfG1q8ACpc9Re3+VO468DnAQmrQOynkF+PSDfaZ5wqipSGCjjnbLe1AoKYVPkwBAKmLydC1extuewLA+/DUTMTdpyEMq+f7bcLRVCUhd6e6osrCem4xC8Xmo8k/3FKDaQ3hv8B2tZwmUtbupliaeWVGhApurZNPLicbuVv4nH/PEu1a9f4bCMuPMHg7lWbJuOz/g3dBNP59a3uv40o5fZr4N4WRc8pNC1KT4Zh1UKMqFKxCuUeQdCqMAjDfu/3STS1OcfgIIiNb1AjzairoBUfPTFFsatCUPPDuoTUCzD98VY/tMF5WFhyALibfNqCKa+W1wx3wILNUZ1cTNUZJxUO9PqT+vcdFgQT3Y1b0sxUufLHhf4/QmPS1o7uTeZrj7O4d4EFz
 5b3QYGua
 qfjMY+wd0PXQrNzMaHKzeiJZsqFhp0jGIW0JoLLnh30w07nacLs+NmoqzM1kCt5aoh3DV2Jiuu+f5BT95kUMvZLHH+LT7pMuoVF96Jy+/a9eBa8W796fRXae8e+c6zsrlxwLLhzlzSfTe6KXyr1/KoiVPlI30jElMyxPQA6RctAtINj5lRxbw52HQzQ2984TMZ/KXTt3DrjOb/K8aG/x2D07nA04tLsgRZIbBKe7E/xOZylDBvzNEpPCcZSbGm9AGP+Q5Z+a8IQPFsv3idGIWjkXE1bWgPt6b5VFnPZxbZ+aZ52LxJxRFnvTBSHVbtF6ZeQ5WLtw1VLQG2Gh1oWK6gUZUDWEW+H1Ds8VKC1bVtKaD9dq+g0goC7FoZ79za7dDkfQ5aaaCBvwbDtN5JOq74yQvqtf5UsDylODv8/G4AmBHXHqcdJ+wfVT/KVkeLgcrQ8QkBBUWZkRdbVuT0YN43dliPgZUklBIyyV9IAqZgUItEtPqypZ53pKZiX7viNmdxXIgo64kOBN5kWKWx2e+kDzuH1AtsN7AgviHbb5japqShQvxtXshQVNW331kTdWXS2tAinyysHt44JerjqB2sUt9fGzpi2qMbQ+/mOo32xcRaUNcCEpmjUda3QBP4XaysjZOegwSTDna4mJ50wc1NEdxfmdF07tXhK36GVfztWwMXS/GV/ldM0lpPf2+dKzHdCZ8/mrTKVyXWpOyHYKLjR9phr3M6P2VGb+2o2/YpD1laqScA5bHp4Jf4gAU/UURxjUZX5dykW6Vjr15nAO40Pkv0yICamQZL9C4x0v5LQdMH9/bfHm9GnpBY6haHoDjqUq9DtS1fgNIqcpL+o6XmN/f1Ppdk2iNyuoI/UPJJ625D+7GMA1w+32gFi6TDXHHKHJmM36mmpq7aOhutb5Nel4u2F5PDOHaUVisgWH6ZU5rLE5c4FAlQoVVWLWsPYkO0BaX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/19/26 08:20, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    95c541ddfb08 Add linux-next specific files for 20260316
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=15ccc216580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=ed431987028345c6
> dashboard link: https://syzkaller.appspot.com/bug?extid=8961cb270ae74b4129fb
> compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12f778da580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12cc006a580000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/c40f27ad73d8/disk-95c541dd.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/bd811888f684/vmlinux-95c541dd.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/3b72363d7dbd/bzImage-95c541dd.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+8961cb270ae74b4129fb@syzkaller.appspotmail.com

@Nico, maybe related to your changes?
-- 
Cheers,

David

