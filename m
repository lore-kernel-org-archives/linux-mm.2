Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 049B7C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 20:10:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0A086B00B2; Tue, 30 Jun 2026 16:10:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABA806B00B5; Tue, 30 Jun 2026 16:10:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D2496B00B6; Tue, 30 Jun 2026 16:10:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 737E56B00B2
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 16:10:15 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E84771683AE
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 20:10:14 +0000 (UTC)
X-FDA: 84937670748.26.D520396
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3DFA010000B
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 20:10:13 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=dZ+o9t6D;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782850213;
	b=Xn/qlwXGFDzszZXSS9o1fJxACHp8FQaIomv4z01owk1cHxOABSKiyRBVm9A41YmaqRpS7y
	CRjfaIwJrF+A/V8iyj6SO0ag+dnNmNXCBmdqNWIaF/QSighNytd0pyPZbIAoe7VNnwohIM
	pgVzxfaxpXb20NWSIwncxjdDXMM58Rg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782850213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D52+2NrsvcEJci+uMqHVsVt4ZToE+I4dK91ZEILJB6k=;
	b=inkZfwvO/OSDn702ZesP82S5l0ORSsUMyFWDKYbxJPt9X8K5xGIrphWjhElbAOBC+3VrCK
	nqzJTtZulYbMOAaL4TG1Cv/bgT3re55nV858X4Jonqdk2iqWK+88ZFYNDmqmyN4FBdw1cI
	yckawLjzKCCupIErGEdJAA96BmS8iqY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=dZ+o9t6D;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0CFAD43A9E;
	Tue, 30 Jun 2026 20:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACB6E1F000E9;
	Tue, 30 Jun 2026 20:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782850211;
	bh=D52+2NrsvcEJci+uMqHVsVt4ZToE+I4dK91ZEILJB6k=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=dZ+o9t6DDJKHyIRX2WaoXi4NNe9xsX7vYCLoKB4uLp11XUj4Ldgfs/WKRMmjWeKw7
	 Up2wOcLIqvM5xiRkw6Y5gpwvEqZULBU33VRAdKq1tzn2ILyjHl/c6uiDNZ6nK0HTs5
	 NZ2EzJwXVm5RPpn7XyXYfqSVP4VAhwul5J/QdR9E=
Date: Tue, 30 Jun 2026 13:10:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Longxing Li <coregee2000@gmail.com>
Cc: syzkaller@googlegroups.com, willy@infradead.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [Kernel Bug] KASAN: slab-use-after-free Read in
 filemap_free_folio
Message-Id: <20260630131011.67546c6e472150e22c3e7c7c@linux-foundation.org>
In-Reply-To: <CAHPqNmzacLWxDM4CSyEorgyh1tEyBfeOVr2gwUvUrtjZRCuh7A@mail.gmail.com>
References: <CAHPqNmyHRaGj0fn+2FvvaJYi4WYOVmai6XX3bRCwbAZoj_GwWg@mail.gmail.com>
	<CAHPqNmzacLWxDM4CSyEorgyh1tEyBfeOVr2gwUvUrtjZRCuh7A@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ostqpsir59wdsr7pdqq5cs7uzgoockuh
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3DFA010000B
X-HE-Tag: 1782850213-257141
X-HE-Meta: U2FsdGVkX18HANQSDXMrAHrjdWQ/ngdw4cNZfC52/ckqkmIdSA58c53oo6rQElzwcFR6y6YM2FN5k8de9td4/ruVnazbCLQpvcQGf9DS8yzkaUkRvlYxKcN7Xpb+8O0TZ0khR+r3CtP9Ao9AXLo5eWjYuyWqCw/UbxtDSJQITjhfqyphWu1mO2x+roz3CRjxZjWSK7TcY2bzyoCwfuIG+WQJynwpThT1XR/Api1uy2qBSjnLGcvaZkbEuUKhojf876rpNmMQ0RuPkJSgKXQUK8GGgX5RPRAobymOZNkkmqaa3oEXRNIAuVbFxWyUVcEsMKJjXbqddXI9A3jO4Al2y6gXcwntDQKuz8MilER9yRmOPmr7ybFn1zVw/jejFivB9M8R59TWGDNpzzF+fYPDlAkTVOraYBt4NeLw/RkMUQIQWJFUQ2DUUMLQmc6X2wZUs8hENiFGw1pDki0Q2UL1RwEoHLGHCZ9GyNMk3k70htXr+7juMmZhWTItWzGfxNyvivAYePNaCA2Qlg3KkaiXXlTFW3sq366+y8FEiWRPmtjYbbsKglcaJXjYpsRMj58esEB1Vwp3CkBUAdA4RTTDk0ZKlGo88r8iTdELwXvum9XhQozX2ErpGSfHiEyybau5p2n0h2HsybAwDLpRFtYWke1+OPQ3/H2Hlw85dQS/9P7rZLBHHYTKszkKvcAdVhJKBVK/n+xNfY5wOjo2MV57MBfm8A2slO8w4U73CveueC/nQ0nEJ7QlHOQrWITeJFuhCZKC7lT5OjPPNwNriGX5aGraeo5pkBHfuRgW+UDawORY92zGB8yzG4+t4mjrQk5t61CkmWemmRgX8CKWO+SsEcFvcK8powX3EZeGZ5DIGyqM4Uk0HJ4Ki7a0wmjEL0rpGTjBWvy5VbGu/R72j545C6i/lzKPXp3WnB9N+OnclA0sqnzCvcHV6kcTH2PMzwb9T6fRI8Tq9w+Dc+lL2vK
 iqNR8zGD
 woqRk+E3IT4iZZieFLfaTQEf8VBqtdmOe9WG2f17TZt4l9IO2xP5NtKRjvKNfK7FSM41n9a2uOC0xT/r3MlhL2xtN/4zI2bz685cM5qFCK3iT8VDR8rKuUGu4x4vCdNIiiJWQzanZqRrfVL9cCi1g2mbFCfwdPkruJuwza9zbOHmRZS8f9hJArJ/7N0dd3kJvNy0rgXl/huJPNZ3VT+WJRKTXKZG+fCgSnU3lQL147pyzprxjIdApDXD2+m6DC9an/G74uR7XWY2zealy1i0J8+fHV/CA1/o251DeJKckxqbUHNEKJQ4NSl0nxnam5KISF4P6hw3+5y8nRVik8tuVrDH4Pw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 30 Jun 2026 23:24:58 +0800 Longxing Li <coregee2000@gmail.com> wrote:

> Dear maintainers,
> 
> I'm trying to fix this issue.

Great, thanks.

> The bug analysis and patch fix are as follows.
> ========================================================
> Bug Summary
> 
> ext4_add_complete_io() queues i_rsv_conversion_work without holding an
> extra inode reference. If the inode is unlinked & evicted before the
> delayed work runs, ext4_do_flush_completed_IO() accesses a freed inode —
> use-after-free.

You omitted the ext4 developers!

	scripts/get_maintainer.pl -f --no-rolestats fs/ext4

is a good way to find them.

Also, your email client is converting tabs to spaces.


So please fix those things up and resend?

