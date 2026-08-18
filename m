Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E216BC5DF84
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 13:06:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D96466B018C; Tue, 18 Aug 2026 09:06:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6E2D6B018D; Tue, 18 Aug 2026 09:06:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAB436B018E; Tue, 18 Aug 2026 09:06:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AB46B6B018C
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 09:06:26 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4AFC61C001F
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 13:06:26 +0000 (UTC)
X-FDA: 85114413972.28.BFADA5D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id A22274000F
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 13:06:24 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mBPFVZoD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787058384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2FNlOtEne2BhEcu6Y7eW1kChoZuYnNWnX7RcE7P3Zb4=;
	b=O30eY73QcIpttBfE797XgTtPY6e/lC6OcPlKPwD5OpjP0915odwaHb0Z5WPrTyern6M1dO
	bFUOAT7BqQYnHpRf4AqKShQodLax4xNJF+Xp74HlXgd7zU6J+MwRgzc0Vx0wGKow/7IDjA
	YVWYccbspJCiI9pkpLouq6utHDCNS00=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mBPFVZoD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787058384;
	b=SU8/TCyHduOWKHxANoOqh0OAlcYogtDizIaeSaclJzvw+ltm+XdlpuMqQo1Gkf5xwLyDJT
	El3uy6nZU33CoVaiX3D+dOVHeeea0QQP7icaGdtaD3o2SQYT9SVxX4C2b86cekJwBWwske
	CZH8C9XRVV0Ujz+GAFpc7+GmxnLIi9s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BE9A54397B;
	Tue, 18 Aug 2026 13:06:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6129A1F000E9;
	Tue, 18 Aug 2026 13:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787058383;
	bh=2FNlOtEne2BhEcu6Y7eW1kChoZuYnNWnX7RcE7P3Zb4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mBPFVZoDG/SLvcTMfgNwPH9Cb2Oc/RS/O5Y/sOn89/7RKIcKsexMMbOI7UxhXJnw5
	 qgGYBl5SRQcgYW5bVdyIgSF5vZ+AsLxvFi7Bw6rdpnr/ZzKRPCflhzjdDMUqJVqyWe
	 h/U0C7iBuN2NGm2gP2ulaBTuLXGo7pOSlPZE1gR9T6Y7A6zeCf2otS9HOx68k9skLj
	 h6eLusz8CfDbnR+Cpr7JRYS/jzjTCr9mt6r1mgmIFE8H+Wwtaa/tMKo+3z4Q/3vpow
	 4lAC7OqmrogXiAuWgMbXdy7aXV0pKKuaSNvYoZmSyijUWr2su5VdioTWYzH+IIu/Xk
	 xCwck/ygS4rQQ==
Date: Tue, 18 Aug 2026 14:06:01 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: akpm@linux-foundation.org, david@kernel.org, nico.pache@linux.dev, 
	baolin.wang@linux.alibaba.com, baohua@kernel.org, dev.jain@arm.com, hughd@google.com, 
	lance.yang@linux.dev, liam@infradead.org, mhocko@suse.com, rppt@kernel.org, 
	ryan.roberts@arm.com, shuah@kernel.org, surenb@google.com, usama.arif@linux.dev, 
	vbabka@kernel.org, ziy@nvidia.com, usama.anjum@arm.com, agordeev@linux.ibm.com, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	jannh@google.com, willy@infradead.org, pfalcato@suse.de, rostedt@goodmis.org, 
	mhiramat@kernel.org, linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [RFC PATCH 00/57] mm/collapse: rebuild collapse on migration
 primitives
Message-ID: <aoQ77EcD3M2kjeya@lucifer>
References: <20260816224609.308019-1-kirill@shutemov.name>
 <aoLAly-oL2OAa4n8@lucifer>
 <aoLkMUtmzRVuv2Hx@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoLkMUtmzRVuv2Hx@thinkstation>
X-Rspamd-Queue-Id: A22274000F
X-Stat-Signature: taqepitnoz6q89tp7ku97ua1gesjd68b
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787058384-726397
X-HE-Meta: U2FsdGVkX184J5ICwUwI7X1Aq+BHT0AR62KRDYzWaa6qDDb2/MGkB4QCW9rNl+OLB2lOBE0fUbosb9ljYjL9Agdrvrkt49ULngm6XSnRSLIpbmDG5KqnoTixlUEF973+lcZWiCg37mgcAKc3lOdKQqmFl4uG6YA3xJ0Nhw0WbXllVr89R893nM7L21eRxzsaWI6lOCU5S0fukJNvyeGG2wGtUQXzqFEH2fLXK4/W05HfpdL+PObu1ONIEQqit2IXpuT1o9PcG8G9lv1TSzOI3Vx41C6lQRDti1UbhkUViT5xVFflVDWYxjw4j3Ihix1z4wH/4W11Bj9BKTqRmLbSftEnvsRhXYwTBGJvBJ1y94lwc+2sDFCvW2PUqaPa0lDzOSXFE0OHf/Qyvep8u+gzRxjw39ji1gd2ia/tO3M5DPZhHmS9sDWdNmKEwHPH1ZWiR5V8HKaIIQESDi2tdM4p/UjrQmlf4u2bMvZfRTs6R1Cw2jUrcJRWglDORe04fJJQ1zmTJLNivkrFlUSeXYEJkCUduYEFUbyN0eAEV/9lCAtgJfXMyWoBYvG6xMitkyyNc/gLIolsCzD66bg7O/7Y8Pr5pk0KtG9Fm3yWjIlWCW2kdGvgZOLhpnOblOrvBUZRptXSi14Mqj8AqXO8XTo5LNXQBvRzA+pxbmdRlIqY6xfFHgZhl6dCBlu4qSxPJU9PmkUZE+X5DoiYw0C2TbHVBh7pnqrkGOzM+3mt8THG8cRbr48R9WIRtcv4zKZyBaZr6E0te8PK0coT2FtewWWPOkqYDzoJ3WgCbl6bJH42DffwvsUBiLgMWoxxFUNaJRLbbH6IAN3z7oHqIb4IHWXbWPkuW+SIXD9DXWGKtna4gBKWyTwUzVA0I0xDApIAf73LIelBt09jyMS1BuEmRelzhkWY2DU0NVfwC5elHd1Mm7YZGmXiKfu9qTuU13c5KfhPqKRS8AZOnKdYRhQLSiQ
 96bWYosH
 BLnaYDmqv5E4T4bm5D7cKJhSyt+WQB1nb7NY+Kzj1sR7jGua6XNMIiuKBWNIjbM8hIFOPRJSh9oH5BS26SLyjb/k61ooXCTQZPdyDkag0Hi7YhcIVqUobkO/JgWUxzbFH8aC9zCCVjaUob1wgCLyaH+h9uztRG7mShOhS6J02uaEWDY4c2xuzCBk2mRxTwsv0EDXFuzlxW+ts5y4/7KOEmEjNRqH6508mCl33pi5MgoJmP3dRP8ktdwew8GqYVM+Mp0/4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

(I'll reply to the rest of this later)

On Mon, Aug 17, 2026 at 02:38:44PM +0100, Kiryl Shutsemau wrote:
> David and I talked about this at LSF/MM.  I can give it a try if it fits
> your idea of "feature freeze" -- and if it doesn't collide with the series
> you have in flight, in which case I'd rather go after yours than around it.

Whether intended or not you sound rather like you are trying to override me
in favour of my co-maintainer here and it's... not helpful.

David and I co-maintain THP together, are in constant communication, and
have a great working relationship :)

IOW - if one of us states a position on the sub(sub?)system - then take
that to be the actual position.

I have poured what must be hundreds of hours now into THP maintainership -
it's by far my biggest workload on the maintenance front, by far the most
painful and by far the most thankless.

I do it because I care about mm a great deal and am, frankly, driven by a
desire to see THP turn from a flaming trash pile of a code base with
confusing semantics and many, many broken parts into something that serves
the community's needs with far less maintenance burden.

Looking over your series it seems some of the patches works in this
direction (great!), but much else of it fundamentally changes key
behaviour.

So it's just a question of deferring the latter until we get to a sane
point with the former.

I keep talking about this stuff because companies are motivated by wanting
to solve their problems (understandably) but if nobody pushes back then THP
will continue to be a series of changes lumped on top of one another adding
more and more technical debt.

--
Cheers, Lorenzo

