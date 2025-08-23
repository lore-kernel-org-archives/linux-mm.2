Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6D1DCA0EE4
	for <linux-mm@archiver.kernel.org>; Sat, 23 Aug 2025 17:07:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BE566B00B2; Sat, 23 Aug 2025 13:07:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96FB26B00B3; Sat, 23 Aug 2025 13:07:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 885896B00B5; Sat, 23 Aug 2025 13:07:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 784B76B00B2
	for <linux-mm@kvack.org>; Sat, 23 Aug 2025 13:07:07 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 361281A02A8
	for <linux-mm@kvack.org>; Sat, 23 Aug 2025 17:07:07 +0000 (UTC)
X-FDA: 83808652494.28.8895E57
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7A9F640007
	for <linux-mm@kvack.org>; Sat, 23 Aug 2025 17:07:05 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=LpYMMTV9;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755968825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qBwWq5lmFaFvwvC4oRY3NPUL5Nqmk+1Qt1RsSfXLUow=;
	b=f8I4vYPYLzkKBwm4l3l6Cai2S2X/yvM5jyBer9Sfqco3DwaiIqnpefvPpDE/OoMWTjSjsW
	MRmLBJiB5K510Vk6FXfL8dugioIF3qDdIBK1Btw0EI4hc9/I7lhIv+YmeU9BsjyrYfRp/o
	vxTdmFXcLn1dv2aCLzM/40RYph5Yqwc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=LpYMMTV9;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755968825; a=rsa-sha256;
	cv=none;
	b=hPr88oYJXXQf8H/LRlFYZb7bbPf3uX3inXhrvB0iF47+ILtr390CeTH/pAVQY1oZXX/4Vy
	hnvHOTC8nwu7MkoN/ZcgPyxonGpAAt//vTiHiisQaEbwrVqqFwNrkE9XjhSg4eZmdkARCW
	p54W8ZnBObD/BkfVH3nxTTwcqwlm6WA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 25A9E40518;
	Sat, 23 Aug 2025 17:07:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5EFAC4CEE7;
	Sat, 23 Aug 2025 17:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755968824;
	bh=zsnLpOJ+msRihUwNBF9a5KmdzajefwvuxfqUE283cp8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=LpYMMTV9QibwTHYmaRpvNBq+xiR0jSQM86DOFG9fPeqgQH1S5TinNmns1FwCAxM2L
	 lBqCmVK+wN156VaB0d9J4p2KYFnuEBpxaecgqzD9U7aTtp7KwuaZWGpREvoo6EKVMr
	 umTzZzvQOqT3Q5+ysFuXtoi9Ukf3QqwOSjxY7Nvk=
Date: Sat, 23 Aug 2025 10:07:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: syzbot <syzbot+49a796ed2c9709652f1e@syzkaller.appspotmail.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 pasha.tatashin@soleen.com, syzkaller-bugs@googlegroups.com, Andrew
 Donnellan <ajd@linux.ibm.com>
Subject: Re: [syzbot] [mm?] kernel BUG in page_table_check_set
Message-Id: <20250823100703.0a0239d204ca2487363d2adf@linux-foundation.org>
In-Reply-To: <875xeeafgv.fsf@gmail.com>
References: <68a7ef20.050a0220.37038e.004d.GAE@google.com>
	<20250822181653.cd2024360870ef94cdb7db07@linux-foundation.org>
	<875xeeafgv.fsf@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 7A9F640007
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: um1gdisfmtdqymah9j5m1ck9ko7taq75
X-HE-Tag: 1755968825-116670
X-HE-Meta: U2FsdGVkX1/PdfkuJYX4kAL9W814BVxppvCNSuV8mo7gO6zOvVmQ69kwkaEEGi61vOE8KKEuLCbnQBq7tvYikoe1OmplGTET2DVcq2L6bJkvAkhihN+ZwExxlu/tqjQ4KJJIMfWeMZaijJoS9Pkmo6IFWsOFbxEz2I1R50EzLa+H+ZP23RYYpBlpAFm3xqqLxjj9PSGh78OkvyA+zIrWvgPgchUfpV9RJeR5czMD5+aqHrc7i0sY0VJpEvdjFKJp/4VK3S7ss0CUXes2sCOUkEJ3irc2hCYEOxVwMbH5uVDewZIpqNfohJUvo+dbRjVVmQHGoskP6MD8QHG4ERQTGirsXbpJ6eEM5fds3gjtw6b2fqDVeBkk9IIiMEHnSFBENBfEPeeyq81LCE205PN4yAqUHMCuUgak0bPeC/FZMcggat9gM3H99kW0kosqhH1KqlR9j4y/fKN2jURd1gfKTBjGA/x9BgoP+tf8474w69mYqTLxg9I/fAnmIeQqaAko6eH/ov8SFG2cLYKvdOhnGWLb+z5kbDschnIlkEBK+YxECwv/IWufjOSboqjWjOpgOmv5gVYX9umq7Wnzn5l5/oHbxWNDpX/seJk8M07kZJRZGTMlyxNck8uuAXc/kAg+TSwboPLmIjC0iWfZLblKjq5HIl7olT0brw//ABsaTadEo96RI629NHuJpVxPRb6diiMWqhylEDwtF68ILDuVHkq9It8hoSjt2M0tsYmVUTx9rxbPBTUCUarjA985i4MKH7QuCwNSf+DlDdvxcKx/FXVY8BZF8Ug2ybGMT85LLJ+Y7B7mI2h0PywYECmmGw8ERF7sygv6P2oToBbRnOBV7SGIv7VtoGHh1ye+NLwNSYLJuTy0tbSubtDJLxp5tRDBht+TgRsuhSbBSrrEbKSJFdWjs9wvZpXuyWtOhEMucyybllRGjt2SdEQITFujNf2LYTws00INw7h18KnjA/D
 P94MbSGc
 1FKlqh6Gv2HSAXNdNWqiYaY/IeV8YpPREafsgoSWrI847gnO8ouzKbsWiiTkGeFdxpP+f5BosGLH+KUJJSnId/MEEBRu4z/F1e0KyGkrKsEKasj0igzegJsKBhtUJoIgmyTO75mQDyELl3g754giPix1H5pAM+cj8+TmmZ+g6OKuJl9DPWxsXjlwCs5ZMtpNtatxM4A7vim5kLX1nGNRZIjyL/PdeVJ/qApV7zeicwh4zd37tSX9Ek1kE1k5mryF58kIk2yEyA352I1wm9aHfmAqVuNI3R2nANt9OevzOq+kUCEeqQYWjWeaPnhk/IRdvp7PQq9IzxB5khOLyF4XQb5pR4d/uFUfoBTYeV24yTgIdMYcVSfwiALxVGyaiyuNqSxopRdy5P0xVs4ribqrvgbo70LF5g2cQe7BOZRDHoGmYF9u89D/h1sJjGy0UGHUOH/BU6A2dSPpTbftgVJgWXmtegxnJzFm6twom39H60kdFOA2QLeed64eIoGlamxfYwbbCKlQtxPvRPj954NA5p0kd94McVV1ylk3FYwvzz+AtjnSU65MYLUKUTgMLMjHobOpDN06ZBvRNRHeUIsOpzgyZjdbr2N+CtmdWmrM8JyPIgiIR4puereKazwTXVY8IHih5PsjwIlX8HR0dlzoBgiZGTEthZDpnlwhMr0rCQK8T8a6bAZUIdkcfv5Wxf63PLz+WS62VmyzutHQHi4pKtXIxcZ85XmZWvEFO/1lseWVSyPe7azeGkXBcsnto3sjfJML7ErFAxblgpwuIj1Uty+6y4RnKqo0qc+gxJNDhe+OpCcg0PjPuJ0yoPC3OWDsGYvLMOLjdEmWJmRn445SYHyHA9v1zloFD/HgKd3FzNKfN4yr99At9ilasdVi48nTTvZGuiyXm+i8RsFePDJ8ec/2t/Bhr1ujyMBCrXDMiPNBhrazhHOWf5jV+L+7DpC4ezfbPop3RaR0rew+pNcfi6z4PHbPI
 FWmm8Mi2
 QxaRdgCIzf3UDmjiOLGXAS+4ZPDXVzkoqEkQHw8FUY41Ihw70EuQKQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 23 Aug 2025 08:53:28 +0530 Ritesh Harjani (IBM) <ritesh.list@gmail.com> wrote:

> Andrew Morton <akpm@linux-foundation.org> writes:
> 
> > On Thu, 21 Aug 2025 21:16:32 -0700 syzbot <syzbot+49a796ed2c9709652f1e@syzkaller.appspotmail.com> wrote:
> >
> >> Hello,
> >> 
> >> syzbot found the following issue on:
> >> 
> >> HEAD commit:    8f5ae30d69d7 Linux 6.17-rc1
> >> git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
> >> console output: https://syzkaller.appspot.com/x/log.txt?x=15f926f0580000
> >> kernel config:  https://syzkaller.appspot.com/x/.config?x=8c5ac3d8b8abfcb
> >> dashboard link: https://syzkaller.appspot.com/bug?extid=49a796ed2c9709652f1e
> >> compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
> >> userspace arch: arm64
> >> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15faa7a2580000
> >> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=144143bc580000
> >> 
> >> Downloadable assets:
> >> disk image: https://storage.googleapis.com/syzbot-assets/18a2e4bd0c4a/disk-8f5ae30d.raw.xz
> >> vmlinux: https://storage.googleapis.com/syzbot-assets/3b5395881b25/vmlinux-8f5ae30d.xz
> >> kernel image: https://storage.googleapis.com/syzbot-assets/e875f4e3b7ff/Image-8f5ae30d.gz.xz
> >> 
> >> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> >> Reported-by: syzbot+49a796ed2c9709652f1e@syzkaller.appspotmail.com
> >> 
> >> ------------[ cut here ]------------
> >> kernel BUG at mm/page_table_check.c:118!
> >
> > Thanks.
> >
> > Presumably due to the series "Support page table check on PowerPC". 
> 
> The syzbot triggered this on:
>  HEAD commit:    8f5ae30d69d7 Linux 6.17-rc1
>  git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
> 
> This tree does not have "Support page table check on PowerPC", correct?

Yep, sorry.

> Also, I guess Dev's change fixes this reported problem which could happen in
> this path: commit_anon_folio_batch() -> change_pte_range() ... 
> 
> [1]: https://lore.kernel.org/all/20250812060124.C9344C4CEF0@smtp.kernel.org/
> [2]: https://lore.kernel.org/all/68a80cc6.050a0220.3809a8.0002.GAE@google.com/

Cool.  Dev's fix is in 6.17-rc2 as cf1b80dc31a1.

#syz test git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git c17b750b3ad9

