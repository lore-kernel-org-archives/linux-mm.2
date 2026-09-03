Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77222C61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 08:01:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7887A6B00CC; Thu,  3 Sep 2026 04:01:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75ED56B00CF; Thu,  3 Sep 2026 04:01:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 675696B00D0; Thu,  3 Sep 2026 04:01:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 446456B00CC
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 04:01:02 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BCEA31C2151
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 08:01:01 +0000 (UTC)
X-FDA: 85171705122.23.85578FB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1DD4210000F
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 08:00:59 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KpyY2vGo;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788422460;
	b=djo6VQvd6DVmj9ZQ4x45FQLxJV/yTLisGkyvWJ6Bc/J1vLV2+EhKCz/sZYEtsjSHR/vK+D
	Yo+YqzI01+V7fN75UbOSMi/wB8UrbQD8bNXW/o2Bd8T5ADoJ9QS0Z1QIL0RXyHm5LW+5Xy
	rnIFCEk6sk0CH8zr0s9+9DePw+IFMBg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KpyY2vGo;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788422460;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M2tKzAHkjVFj+Hp+uJ12JWKe9IeyurdBa3HZH7DccxI=;
	b=Az0rwFSue7oaSCqUlqpVdg3o7wuZssUPvS5BsqibPOlfhn7SCnxe0Q9x5bUNsqWCm/ezMi
	WewPtUln4ALPhV+VwJUOEfoiagVUcZ+w/0nVJ7JC3x7oJQHmRX3NFwm3/vOi9b9AKOYR4c
	mQW3hP4/qWTJ9wYtRLFAk7+3KfbHZsU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E480E432F8;
	Thu,  3 Sep 2026 08:00:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FF231F000E9;
	Thu,  3 Sep 2026 08:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788422458;
	bh=M2tKzAHkjVFj+Hp+uJ12JWKe9IeyurdBa3HZH7DccxI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KpyY2vGohdTEJhVq0Pcd6fflmCfDGXd+0P4Ph5U+pQHnmiPJOS/98N22ACikgmUm9
	 lLiqfJpv1mBac2ThEc6n4soCluTWjzGBrKTYu8zswnY+R77RjeE6vfAkkMxrQfZwxi
	 EpM/8bf2ykCuvgKJwrKmDEtrWhBq+jKxqMqGhxPXtlSxfXr+m5ol0x3aRi9r2b8N6n
	 RH6Y7r35hy9d/3nR0GNJqfE8p3nIZKaAgcgAK6GfaSdgfTMHRzbOxgWYWFX+MDp2Ft
	 gN2PWe7DGVmVLWPcIACfvRZ5Y9ijeoJKHUKRcGNmb4tFoug9Safc8nGGE+2Eu4dDt2
	 ejvbzcigEK3uA==
Date: Thu, 3 Sep 2026 09:00:52 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: syzbot <syzbot+f12658786a4153df5113@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, jannh@google.com, kunwu.chan@gmail.com, 
	kunwu.chan@linux.dev, liam@infradead.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lixinhai.lxh@gmail.com, pfalcato@suse.de, stable@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, vbabka@kernel.org
Subject: Re: [syzbot] [mm?] WARNING in vma_set_pgoff
Message-ID: <apkpGnijB9Wwj8BO@gremlin>
References: <20260902185451.5ba1a829a15bb2799d121bd1@linux-foundation.org>
 <6a992326.e7659fcc.146146.0005.GAE@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a992326.e7659fcc.146146.0005.GAE@google.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1DD4210000F
X-Stat-Signature: 5x657nt6xmbbaf9r6e5yetoayeffwbz6
X-Rspam-User: 
X-HE-Tag: 1788422459-760032
X-HE-Meta: U2FsdGVkX19e2Zt38rQxq9FmvSdPtZJMPJrRm7dKJadpAJJSMcAUUaJJyWdnSW+NqVPAn7PN1lxXEscK887DPMqgeUEr52ZUy40oD91NL7VZfQTLwaL/gvfjIM+eKMTNzCtkW0+6DwX4taKLef1byATw9FJz37LtCiTacQ7x4uFLwYnPBdTDJ+NRknFioTF38v43IxSdHrBAuW0MpVTbRn5XiGbs3e8ImXCM4hoU/dBMW04SCQFRHLqbJDeBSkIpM7nBYvKS/OjOjyLaOmOjkbWmB2T8yjQOcQCNU68g5tJt7EB38wonnE3WseTwTAs+lVn5s4e5DqCxwojAF3Cbqx7mhye4xS46sskoCKxGQusd90eUzdOsZPeWYTYtQOIk4BsDJpJAVYbQIQXwTZrO/hiyDoyWH9SBOhBFlI073qXSWIqwHpUSfMN3igjqwDsWE7HyXM2eas3wRlQMyC66stbVVpNjEucdKxNf3amDcrh5d1m/vw4A259MhXe1sh6z5lqiwRHecnFA0j5/kHipHi+lsvBtlqMYxKpwB7Etnt7SODYTACHfpvAJLmf+9ceHRg28YztrLQpx6AYgyXneHlB0bxvBK2JjHzlYJf7zQN8ajGmvgufkBPhkI4LZY31oH7k2uEEL3cQrb+qF1EcTmK5Io5Go9MjY/Fkia0ISBcgC4jYflmmjnQKXHK7w6olHV3mkPbo7pOSF8Ow4poAkUUgXSnC9cmxaqhhBXHTjygBPqh33LxDyEYzyzwfTWynvPPtqnpNvh2zOd1hNX2apgPAT5xc1Lhyp3hrdRnLWawj0WgB+k2KEwFynQQHL3gRKnBx7FYbRIVew71ntfA0jNCTbGLVjIM4WArdETpXYLwH7X+A+mjDwR5EJbZgguaNDMsab8bxEN7Pt9W4Tu7ouc860s82gQ2V5tnuih91vwcWj94myT4xPbvtOT7jN03r8dj2Now8fK6CQE2CYY3k
 tpQAUjS1
 kyaDfZeylGI4XH9weCNUfmIFZv3IlFi48ZYyRG8tLnKCin1mATNFTeJbC8a6PJRqF+F2r0+UWgY0HY4NwsLGF4YiGeOxFSq9W/D/KmiQDXe+9ACQ8a2f/VurSHVsqZBfJimXFduZCY0rKcgrzgVZPkQtleFL+PWDy0SNNCQiSurQfb40LiNjmKjW/TdP1K7K0EALLLa65lzEXKE4sj3gajigS0EqLwhRziSq8LxWGlLw3VG19LaKL8RbLGB4WqEFJcEXYsZ41MPvhZ4qw3QS0cpwaVQrUlo5w0iecEePz4Rqcl5M4hS9n4XWrSL/qw7TTXjCNJTGy4NyYdMXaZS25Gilyg6T4Sm7SZsBAd2wVTC3Ef4sLCKVPGBc5aWFVlZ/7X5F+y8uRL3MeMkUsJBd8+b+UmOuHny5BNV+0D+/x4p4FJcDJ7oatgF6+9TaadmGkhgLEVG/i/U+CNL4vCSWVkoXXk+LlhnZ7x0HV2ns2ZNUYF5/EDqkcYq4a5Y7+qk53CmRYdT4lQ2gkE6QWWwWY3n+lGRBDj2rx7sK7cAHzHjuOH/Hx/pnkP0anH+1/AyrS9tPsBzy7Y6+dWJQ7Dgw40BQaSKZa0Ba4nX+zyRx+1YaLFw+J8JIo82VH+dcisc2Bb1jQcy4Bb7IlfK/lrUmQ+XCGtjGLZwk5Vf32kvUDG+gnE729cwACHYHCd/4RSHSg19tCcJZ4WXjSG40=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 03, 2026 at 12:35:02AM -0700, syzbot wrote:
> Hello,
>
> syzbot has tested the proposed patch and the reproducer did not trigger any issue:
>
> Reported-by: syzbot+f12658786a4153df5113@syzkaller.appspotmail.com
> Tested-by: syzbot+f12658786a4153df5113@syzkaller.appspotmail.com

I suppose we can sling this on the patch Andrew? :)

I did mark the 2nd one dup I'm not sure why we're seeing another duplicate.

>
> Tested on:
>
> commit:         940de590 Merge tag 'hardening-v7.3-rc2' of git://git.k..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=147d1f79580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=5e4e3a0e188a497e
> dashboard link: https://syzkaller.appspot.com/bug?extid=f12658786a4153df5113
> compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
> userspace arch: i386
> patch:          https://syzkaller.appspot.com/x/patch.diff?x=16b190f9580000
>
> Note: testing is done by a robot and is best-effort only.

--
Cheers, Lorenzo

