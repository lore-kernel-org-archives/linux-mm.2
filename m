Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCAD6C55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 19:29:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25C376B007B; Wed,  5 Aug 2026 15:29:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20D366B0088; Wed,  5 Aug 2026 15:29:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FCB76B008A; Wed,  5 Aug 2026 15:29:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BF44B6B007B
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 15:29:57 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1B52114057A
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 19:29:57 +0000 (UTC)
X-FDA: 85068206034.17.09B7C50
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id DE5FC40009
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 19:29:54 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ddXl1mwi;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785958195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=elA1Ms4Gn/MoVQix4/8a+mH7M22rfFyFqVGiYAr4QAc=;
	b=aS/5ns1v7ES1zPYDRawosuz+YUQW/wqqDCzy0JF3lkaOEQttTwIYG17Jqwa8f1Ro+UoMFz
	2E/yy93eSZnRcmRTlZuWXUwdoNdAvzfGnuouhJr4PaF6EtidzzxvvrCDgDqyC5l9LPBx3M
	b8Q5G4lOYqk0ia51lTgbdjiH3ZN5kIw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ddXl1mwi;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785958195;
	b=LHHeONqPtknKVSfa+mkk+rCGjBwsvMqFjbNcnvFYUgO0Of1Idips9pxbrmaRvWXSRocXQ9
	32i1fM5VYbklHbbdYlbq4ngRmpaoI1BI/YT4aEOGdsLwC8H/R9iZ8J06joeWZASx44EMed
	HXGRGetJQ5ZVCRMR3HIz8Yxb6IAs6j0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9E48541896;
	Wed,  5 Aug 2026 19:29:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 354AB1F000E9;
	Wed,  5 Aug 2026 19:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785958193;
	bh=elA1Ms4Gn/MoVQix4/8a+mH7M22rfFyFqVGiYAr4QAc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ddXl1mwiNzIIB+yCm/bWxetoXBwryCujiM6Iar1NzfSxbqsd/zqXnVjuwPJPisVje
	 NMJlB97zWZ1OCO56xatydk1M6zkMUbL/opllmxgSpe09KzTORuRbnYiRosv2Db61/z
	 7c2PgcGWEk44csfDq2Sa9PQOD5jgEMsmlkAkQ51c=
Date: Wed, 5 Aug 2026 12:29:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: syzbot <syzbot+d2401aeb74cc84adba04@syzkaller.appspotmail.com>
Cc: hannes@cmpxchg.org, jackmanb@google.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, mhocko@suse.com, surenb@google.com,
 syzkaller-bugs@googlegroups.com, vbabka@kernel.org, ziy@nvidia.com,
 "Paul E. McKenney" <paulmck@kernel.org>
Subject: Re: [syzbot] [mm?] INFO: rcu detected stall in khugepaged (3)
Message-Id: <20260805122952.6ae38af69a0457779cb44359@linux-foundation.org>
In-Reply-To: <6a727d6c.9511d2ce.1fc5b9.035e.GAE@google.com>
References: <6a727d6c.9511d2ce.1fc5b9.035e.GAE@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DE5FC40009
X-Stat-Signature: h1jc6owie9ybb9t8b41f8zs8tfpiso1k
X-Rspam-User: 
X-HE-Tag: 1785958194-365194
X-HE-Meta: U2FsdGVkX1+JxIyN2sJhqgLYtHMdfI+Qe0ZV/0byGr5Zic/ZW/v1ZyG2Q8EnLwsFF+jeGDHIab8mpqCCZyYUhEn3jMx4pr8C+G1DmVBKFi4pNKHEfn1FdPONjUuiBLt5mmxrYncC0nBfHk/SwU4+SejbgMg4pNcXWKoKg69IgXNZvLFBlsdUVwG5D1erDZXD3c9pAfVq9RlXyEhjJDeKdc8ec4zGM8xYSdBlImKIcwSrB+p+Xca5Y+oOcpmXXphcG4Ujh/yRz7/M8vtXawkqZ1bXRAOEWwKl6zxFPN745oiAeCdCyqzlS+dU4b9eYI9uZ5quvR6UsO2kgrrgVBSJlhxqSNGQUTb//YEoKbLDRJQARhb8ueXU1Q/VLFcQ63uZMhl1jiLbxRMyFp962uCoQ2eQlG3jbJjqlK7eNzRqME4W6N6KpJTtbFlFt4O9tBcCj/YRG2xFpp0E8eod/s+gNmfi9AfvRmT6X+vok/g53iQlv8Fk9CmBvz1KQCyJ3Ll8ukXdDSnOM+pPnZI78sT2abzmycc9gEK6p/SU3aU8X+P+pnZcJaNqG17HNJVySAwURsVoyPTOK3Yeh6l8Rc97Qt7Nlv1E5MRHn0tYVZMI83K+taYxyjYBoZCK6DtXVnXu29Y9ag9wGFZjnt83XsiP+MUz6pxvX8/iPf1smb8BzU4+ECAuJTXpZWQAY8yA2dvf7dkHdVHBFDYT1ce6gUT+hthz0GGHG8LhnHgXQOVohHp3hP1EpOg5wI9mZoH9RgAvlYOTz/SHQ6yRkiT9pE9IkPhXnC5Wxif92WcYikwXn8l6EL9+/ULwGdwOpJ4RPPk6Lv+wY3hUZF/nC8Rw5m11qAMKwXkjvSsQTl2N8KPJuVlQovA/Jfo6cyqdmhC2+fRrxJnCKrrF4CghICeskqJZQ5WVn5ZxhBcLdoSHhnOA4B1pyabK5K/LV8JwC2TRFf1lxkq173LGEIJ19WoabYu
 cCAQGHlq
 b68+jhwM0mhcxFxmyucNA0nlJP96h8LVMN58RDgcmDixhbGEom+Zb+snYRkcS3JYXwt2COINE3vtdOF0WHZxM3LfKGuXMdn52YX7zJb1s7knEtBaMQJyRGJdR0t1+EPZQK7g1FHyMfcYjDzFMKGEuHG97ii+QiXNtqi4pYpoxwFv2OKUYXJy8spQz+lKjrYUkkQJL4Y6WKo1Zxh35UwNmcsD4Mr/ByS4V0zav1NKZXtDSGigCe9a42YJb9AvHJ2G/T4YUOUZneLPrHyP0ZU5Lu837Giu/WP2MccT4oZQuUPkU8LDOu+TdUDxFyhMf+g53JQ9M5MOAXU8+uiQ+kb4uaq+wBYxM9JLDUlysYA5SbLJCtgT97ON/ZsD28JN111rtoz9Yf4J76Std3ZJfItTGgBfPFlG7zLEwW//uzpXAc/7aWziLWLVAijvPS7Nu5bpGLEZ0XsCOk9ZHaxr1zmXUCd7r6yXft2gP5sSQyAlvhovltP1Ttd3QxYBSYSN1A3v/auifqby+iXSxsapN7n8qfJ2M92chMwSS56f0CjPU7YfX5Br09YDu0fhPQElML9D/CAbq0cqknB73YlMpnvFz1Wr32ZMG6wZxr2AeKXWxFkHJz/uSjqX0SQaHvNUvjvBKLxFyLzmtfEenLZda1TpeJW6XnEVx7l+NLcViYWqgoAi0XBtI0wB5mxuhF+cRRN4Ohjb7gxbhs1p6t1YZegT1wioTyg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 04 Aug 2026 17:01:48 -0700 syzbot <syzbot+d2401aeb74cc84adba04@syzkaller.appspotmail.com> wrote:

> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    3708dd948844 Merge tag 'pm-7.2-rc6' of git://git.kernel.or..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=11ac703e580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=4e38b15c29e6a1d9
> dashboard link: https://syzkaller.appspot.com/bug?extid=d2401aeb74cc84adba04
> compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
> 
> Unfortunately, I don't have any reproducer for this issue yet.

Thanks.

Lazy optimists (ahem) paste this gunk into Gemini and ask "what the
heck just happened".  The results are often useful, but should be
treated with skepticism.  In this case I think it came usably close.

	https://share.gemini.google/vq4TLhTiLBih


tl;dr: khugepaged's collapse_scan_file() is taking too long and RCU got
starved.  I don't think khugepaged is doing anything wrong here,
per-se.  There's a lot of work to do and we're doing it.

An appropriate fix would be to take a break, let RCU do its thing then
get back to work.  But I don't think RCU offers interfaces for that?

collapse_scan_file()'s main loop has

		if (need_resched()) {
			xas_pause(&xas);
			cond_resched_rcu();
		}

but that won't help with the RCU stall detector(?).

I suggest that a suitable fix here would be to add the analogous

	if (rcu_i_need_to_take_a_break()) {
		rcu_read_unlock();
		rcu_take_a_break())	
		rcu_read_lock();
	}

(iirc rcu_read_unlock() does an rcu run, so rcu_take_a_break() isn't
needed here)

Paul, wdyt?


