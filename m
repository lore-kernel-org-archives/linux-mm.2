Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B08BCD4F24
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 11:45:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCB186B0005; Wed, 13 May 2026 07:45:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7B366B008A; Wed, 13 May 2026 07:45:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6B1E6B008C; Wed, 13 May 2026 07:45:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A92D76B0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 07:45:06 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 537101C0522
	for <linux-mm@kvack.org>; Wed, 13 May 2026 11:45:06 +0000 (UTC)
X-FDA: 84762215412.12.FD43D7C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 84611140002
	for <linux-mm@kvack.org>; Wed, 13 May 2026 11:45:04 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dsH5SUzP;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778672704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n4Jp5MiqHsfU/0wGgJ71T+uoHFyZzFF2BZUIwS/xnbc=;
	b=q1miYHPHDbko+NT5RBC/7b4Gtu3eLSPVRGRM7Rbatm3a/b+3FziHGYBRK5vrHwUCHbGe5F
	c+MT6cZm0Z+N0/FcLdysuqIc6srT9Jb28wXy6piH9p75X/scouquR3oj0Vj246+YdSI9zT
	A1QuYaSy0AK2s4JoIMFdUYxbmfjAazU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dsH5SUzP;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778672704; a=rsa-sha256;
	cv=none;
	b=KrtMVXRX+xR81yMzFrPCAi47ojTI1H1r576djeBdSaaVB6eVAhGAUAQuLaRVbDksVP7gId
	jNbmVflAXc/jDqp3cC8SB3aXxucuNhBHA0IWCg1dYYYkYek3KwSS3gQtlh7VaoCorW5QTp
	eMR/6YyOuqIrYG+xADYS3xYGQS3RA1Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5602543808;
	Wed, 13 May 2026 11:45:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B370C2BCB7;
	Wed, 13 May 2026 11:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778672703;
	bh=xeKjgFsKh2U+vCzVB99CQ8416HzcDOvoEENpGnYPc4A=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=dsH5SUzPgDHob1SA6hEhN3BHjfca8FM0rBsX8fSNPDZOrslpf3naZjnxtN71GBn2i
	 3CIgtiNa+0S0WaLNRULoJsFLUBk6sDuYlSlmOf1ZS7C+rSv7Dxu6nRcALtoT5JxKZq
	 dTF6mEJJSjb0CUdbOFyLf5FhW1c6d6D1Nc3YhCoT0kdpTZ36Au+FjOr/9G4qHxeg03
	 ewaRmwxa0jj8aEKWtuk1LcIfnNA3D6Ahkh2ShBBGmxZQGF18AMwQ+As3nnpQYLFEGn
	 CC2yBr2zCs4Rrb3lt/5xrfOL4ixVuU6vcMFSoHhPTLB4sJIoOn/Bur602OqR10h7ae
	 eddo+u8P0Leyg==
Message-ID: <1ddf6f68-4aff-4475-aa82-c2bf15c9706c@kernel.org>
Date: Wed, 13 May 2026 13:44:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [mm?] possible deadlock in gup_fast_fallback (3)
To: syzbot <syzbot+8edc46c9c781c802acf4@syzkaller.appspotmail.com>,
 akpm@linux-foundation.org, jgg@ziepe.ca, jhubbard@nvidia.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org,
 peterx@redhat.com, syzkaller-bugs@googlegroups.com
References: <6a0321a3.050a0220.106bf4.0005.GAE@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <6a0321a3.050a0220.106bf4.0005.GAE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 84611140002
X-Stat-Signature: 8zg5p6n6wud66gd1gs1wzsbanebdzmic
X-HE-Tag: 1778672704-98522
X-HE-Meta: U2FsdGVkX1+ipB9Droxz5vdaVGZvAVSWdL1b3EQEHvs0PUt0kQdzeqot2EIIg/KLh6CgMWdZQlbrfheFsAMImmxhUqzjk8s4N48ouMC3ihsxVLBo0KkOaA2DipYoRPH+MDCKSgeVODVuGL0PedHwt4EJbxDYBG/L5z0La/Hgnb1HqY8Xwiy+wbk82qv+I9T5DELuvYYDWcNj7ZkPVj9gd6+4JcRwO30dfIqAPQVypekrJ7pYYqilubhIoCEDlS0Q7sR3tzLaqxA5mifa5eCSegHQghWLXC7bvif7qzHofjuo1e5gsKhmG3Z049oZVcC7mGHKYx9rIiIiXm84mUEOPW4CL4BL2ysRM80ChQB3AeP+UkXOq8I8TmDoSnmFqeW16mBk4owXWuAZzKTVQzZDygdpWpEHDN9EexK3TOoZAHKC9hQikpOlmljrluYyQF8pKR3VqPrlOLDL3zhYrqF586mMQxpOdDi+sPbhRldpXCr3hqRLuzqtDlswpXOmPw3Jn3os3XXurOfTiDb4f7suqsjkC2uLNxn2yWvPlACo7pvE4znEoP3UWFqRbXpDwb+OXrwUxIRlVIjGuHM0qRmpLWqgyOHsbMTMQtHco33yYByIlxP33PJ7fW1pJmnF91plW1oYnlEuB17qb0QSD0z8dh3++0gCStW24G526My4P2wdbS2c39UIvwqCMNqNzL5qS96lRyb34yNujJncdrRASsEb+B7GgaseIq9nt74WWBDmHWJDai72apnORv1w2w5dgllbYd9MZA/VDXKucpaxMCsfABGyCP3DKgm1JxyRPVFf4qYXs7gOATTmL74eU3zEg9vkZo4go7X6ZvAJwCUzHKN/xele4iH7wz0p/nKbJhi7F7UQJr73GR23zQa84zo8zcgtV9nKl7uwDdNfCQGjmbN1c93klcZXELoKyi8uTzL/ZiRRKTPJ+V2tbE0dNbe3+H6/OvUK4uNb/x25U2h
 vaIRBFSh
 lzegEdctRW8jnXJLqGil7tOJhvj1OtSmOim5fU//FrAya5USYrCbCic+kcxxtVTMDyEO6aDghswrgrjaZqcza3uK4PjRWNa6AJQWh0DMbYCqBXMsqXri9TWo73LnuOThq4y0y9sLcGl3lTYq5W2fMFtdmTmn0OHvdedh2+kO1GFaZ5Ts6krRb0k4Y6g5SHdVbOOO2uUCXKgBVhzH51txuI3gWRcMUEkUf1DBMosYRVU/elsmNPvGCqkdEkjCU15QKHMeWWmxS7VNOr2j76qQ0mH99Xb/em9H7rc+ZowC72XyHLyCRGo6dsTP9w+Njcp0237U35+GD5HD8Ram8PTGtwmSpIOPct3jIvoBRj10KRnXBH1/7XIoALphb0PxxwS/EqcwqmM/N1AfNOFGcAehrkonabUrs14PQA8lUhynZiLLUxgiND69BjyCojUDKlUC3T4H5prl3jpPzrLIpzveGSJxW8f8s50aBNCKIwHwTnfAL2s/vC079z8IaaHnl9XlEdnAaKuh77DHvbSzjZnwJqD4wgdEigm3ekEK+HOo0UknoJKhLsMvVuRpiVJYxO0FytXAcOcJqss289cfq6gSmxu3gFaIdAG59FXFws5dKpw2Bs8WJaGlrzi4wPdlkaUNi1ONRu3X7K2//qcZ74mpRXEKuPoPMlT79TgHqkFDFP0kXohNHhArj2fayi+Pe+iUpje1GtypIPVeR6z8IQmBuJxCfDtUovs5YOYrory/Ragz6h7o27Ccq5v/z1pjrn+f3OPLgdTyFwcBWXw9PF+1LpF+uCx7GMvUdRJhAtxeWpjPwTOXQZsn8JdhrtdbuUTXZhv4TZ/IhxG3meIFm5mo2kWrXQCnVeto1YVANZt54dUFWH6kZ6gOxmEuSu1BGW8INx6cz0HLpxlNJfIKVHzulFWh/2SpuPJdAU1RDNUWevrk19ZUttw+WWQEl72AFzmuXVbW8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/12/26 14:48, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    63751099502d Merge branch 'net-mlx5-steering-misc-enhancem..
> git tree:       net-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=1714fbce580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=f2b487b72ffad035
> dashboard link: https://syzkaller.appspot.com/bug?extid=8edc46c9c781c802acf4
> compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/1f8de738e2f8/disk-63751099.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/ae6cfb0d3b70/vmlinux-63751099.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/f00e218e1a55/bzImage-63751099.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+8edc46c9c781c802acf4@syzkaller.appspotmail.com
> 
> ======================================================
> WARNING: possible circular locking dependency detected
> syzkaller #0 Not tainted
> ------------------------------------------------------
> syz.4.2801/16593 is trying to acquire lock:
> ffff88802ae527f8 (&mm->mmap_lock){++++}-{4:4}, at: gup_fast_fallback+0x20d/0x20d0 mm/gup.c:3193
> 
> but task is already holding lock:
> ffff888055ac9d60 (sk_lock-AF_INET6){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1713 [inline]
> ffff888055ac9d60 (sk_lock-AF_INET6){+.+.}-{0:0}, at: tls_sw_sendmsg+0x15d/0x2430 net/tls/tls_sw.c:1291
> 
> which lock already depends on the new lock.

I don't know what going on here, but I know for sure that GUP is not to blame ;)

-- 
Cheers,

David

