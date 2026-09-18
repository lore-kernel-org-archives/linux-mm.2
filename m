Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D237C982DA
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 10:16:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9398F6B008A; Fri, 18 Sep 2026 06:16:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 912076B008C; Fri, 18 Sep 2026 06:16:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84ECD6B009B; Fri, 18 Sep 2026 06:16:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 62D466B008A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 06:16:39 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9BA871205EC
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:16:38 +0000 (UTC)
X-FDA: 85226478876.16.EF675AE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 10E39140004
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:16:36 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cPNSou3I;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789726597;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IUDFRBGa2RG1qXFNOqbXn+eZ7VMhk9nNvTSQAVzvNNw=;
	b=CGDf6HDJRaZckeVMQoOZxbLD9Z4NnbFBbdb5gIUFhF/+f2kyKNmNINr9vLfNNd4ZKxRodo
	PnYwZnogCUoUOYFZYH3U2hBmAo98rLlh1UjeF+WFAKqzWdinbWw3MUln2yoEVq4aCi3oZQ
	zG4uEfA4URMocrpaBvU85MNS/XlxvhE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789726597;
	b=4z/U9tkMnKtpLPKRSty+SpaBKqsWyW6OvQ66Q2GPKSWD1+6vORM8g5XccLAHFt9/ZnZXrF
	1lg7jukAXrzASL/zAhR6NXibk16F+CWRDBwZ7fT2X8ZV2FQvHBcWUpCQ/l0UbKOu77JMgN
	TJsvLloVe7pcKVZgMnSVUwzxJMkaYAc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cPNSou3I;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9722160A5F;
	Fri, 18 Sep 2026 10:16:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F39531F000FF;
	Fri, 18 Sep 2026 10:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789726596;
	bh=IUDFRBGa2RG1qXFNOqbXn+eZ7VMhk9nNvTSQAVzvNNw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cPNSou3IuShNKs2wqjrBJbH6XQctu6cWqLaMc++I1FCOeysna31efy1k8r1o8USDO
	 2KqcArHiYXdTZ+TCjG/tGsBMKjgm0re02mhBVnEtqMPm6TY1HXd/oDObyk5RBwAemO
	 jATEzxTr7dl4SGEuYHCs0/sMh9/aDZWRxCUGgiAaKdBlebXVmL6UJvtC61NzE0id6H
	 jhaWLG2USeHwgB16NAE4AhrbRZEmLVBnc7w0vh5qLGmVn+sfh2LwhNAQzWtMCKSqyr
	 Mu6jRStNkeupLKN8zuiSxlhEUKsG9ytbHpOCM4iRwDSrdR9sKb4gq/5t73W9G3xoen
	 jXkRNjs+uULHQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 09/17] x86/crash: Fix massive out-of-bounds write on
 32-bit Highmem
Reply-To: sashiko-reviews@lists.linux.dev
To: ruirui.yang@linux.dev, rppt@kernel.org, bp@alien8.de, vishal.l.verma@intel.com, linux-arm-kernel@lists.infradead.org, yeoreum.yun@arm.com, chao.gao@intel.com, kernel@xen0n.name, tglx@kernel.org, takahiro.akashi@linaro.org, ritesh.list@gmail.com, hpa@zytor.com, sshegde@linux.ibm.com, kees@kernel.org, tangyouling@kylinos.cn, will@kernel.org, piliu@redhat.com, me@linux.beauty, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, maqianga@uniontech.com, gregkh@linuxfoundation.org, pasha.tatashin@soleen.com, npiggin@gmail.com, "Jinjie
 Ruan" <ruanjinjie@huawei.com>, thuth@redhat.com, maddy@linux.ibm.com, blum@kernel.org, chenhuacai@kernel.org, mpe@ellerman.id.au, sourabhjain@linux.ibm.com, zhangtianyang@loongson.cn, robh@kernel.org, graf@amazon.com, seanjc@google.com, hbathini@linux.ibm.com, guodongtai@kylinos.cn, rafael@kernel.org, adityag@linux.ibm.com, kas@kernel.org, gshan@redhat.com, coxu@redhat.com, jbouron@amazon.com, liukexin@kylinos.cn, driver-core@lists.linux.dev, mclapinski@google.com, eric.devolder@oracle.com, linuxppc-dev@lists.ozlabs.org, dakr@kernel.org, dave.hansen@linux.intel.com, mingo@redhat.com, ruanjinjie@huawei.com, akpm@linux-foundation.org, ardb@kernel.org, bgwin@google.com, linux-kernel@vger.kernel.org, james.morse@arm.com, lizhengyu3@huawei.com, baoquan.he@linux.dev, loongarch@lists.linux.dev, x86@kernel.org, palmer@rivosinc.com, pratyush@kernel.org, catalin.marinas@arm.com, leitao@debian.org, mark.rutland@arm.com, chleroy@kernel.org
Cc: kexec@lists.infradead.org
In-Reply-To: <20260918100442.3841135-10-ruanjinjie@huawei.com>
References: <20260918100442.3841135-1-ruanjinjie@huawei.com>
 <20260918100442.3841135-10-ruanjinjie@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 10:16:33 +0000
Message-Id: <20260918101633.F39531F000FF@smtp.kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 10E39140004
X-Stat-Signature: gpqwtqjmbwg3u9n343hmsj9bxfmbu6gt
X-HE-Tag: 1789726596-929027
X-HE-Meta: U2FsdGVkX1/0M+M0IylSFIP/xg0/RsfByaHEJRuQO8w0z+Fugw3gpOyX3XlXsZKC7ue2+peTcOkO6iBvJ68NBv/o7FeFOL2cnOMwJLWEFeuPupop1DI+jG2HGOE5x6f1Fz7vzIagNiZv/M1bUs7gd6tn+SabkT5Zw041cW2JQ3R2vCN646+Lcz9ZlQRmFoEsuTYMrlPL6daDoJjfx7vGrT9p+s2+rEzVJbCv9FtPoYiSKSpp4XyFfFP6wNHXVR5KnwZYR+d5qpAx8/ZIcfOA/wOt43q+p5JndrDNsB3XCh6FZ2YdvxCLlGQOQHoi56KocfDjpdTGRhmWpz4X/2mwIGVfsoHBae81Aq1gNOUTd6kWEXiAyF8dnHa2sy26Joqx6koab6qqNHl4cBJUlbCmFX7L1jfPFNk/9sNs8DWWvlBS9Z885l2yzCNVmQfiU0eYXCuz/y2NMyRrJcegNjg86yaJD62NNa+oUTWxGiKhpiVs8QqrdR68ddY+2NZBrUkIr74MmRHcewsZCLt2hOfCqSw9UmYHqF69pXAbF/nZehj0udxjtc/fHl7JjQJ5gApTEzQVlEnmMLQ/eCIU8k7NrbYGZl1ElfpsPMAkhUZh7ikOM8x8BQ6h5f/aBXdddia1ooQ7GTqo29hjysgYoTpa7lp/1VDPfFzI3mg6BIJ/Jon5wB7i0C2rEN1NWScGn8NK4COVfz/KQAHrG+r0JBMMcrPPPgD6j8/1XvECBCWx3bPN1KrrtMM36C8KSE56LRivM2R6HZ2eWzvUgCXIT7MTVOXC+I9jI+xC3YvywbsZ5O9uWVY6vU8o8KO0IcXwC+sW6bq7ZNwtHSVDlUbTdXjy87vmBKZNhfR2eVfFF+F7nVMrlZnwlNojTZkmZ7Zv0aZMyNsAiamTh+/ZjozFKIj1Qw7WC/WF9Mt8e7MHUbXh/yY7sv2sESwI7yiKk1dMp9Xj/hRceuVHGBi8x8JCD9m
 OiD+qNDt
 DRXfbrErP7NDYU/H4X9z3bNQq27qbKUHTrfTw3S0PJvhUIxxST94hkVqXUE8xX0Yypkduu1pkyE3ywHES7My136UVUM/lYy0qyS5d47CTmEwAgFGEVBlWwxlsDaKHtvMAGTa2TBxjVAwlyWBC/YXdCMNjQPZT6gsEnYyoi+cUv6G8wn9VKi6VlsuLcYWYDgnN6tLeU7bAuszFYRjU/FsQLbAbJqXGAqURxfc/1j6sPfoZ7FxDn9HhRMIoq9EljU3sDBkK4C8pbQqmsU+od1QAoXctKGebAirQ/clmfjjMCDskO5Ox2yiI9bKMSb8vTKWLc+nMvJsB19tGoXB8NgFZ0vCl5PkvimcHHM8lgceFmkqlMymzw5Rw3wDGFlZaQJTqkTSNTA7cvtwiImdfJ4ro/wLJjD9NuBZcqfOQ90NA26CRfQY7px6kLkOS9A4xu5kq5dropCFsraWTQXXZCy4zaltbuVjD0jKpDVeG35XS4i/1XJmp7VXzpDbXI6pGNXhAvAKhcTs8tv1I67Z8MZYmVWUuiLYNPnDEZ1+/LxQqsaTTJvd7RVIWCxZ92PHsF5i8iXxFIwpT4GLpHdI+yjN770qT9mBvfTZjtptb9mbPqIKQKeAM9fJZPEjW8KELDZIFRg7Rsyk8BdHCw0g42gGpNyzTpQdFjfyr7MT8ZaZpmUI408IJOmufUA11jMbX+6NsMR6DLzdAG5PIPoRtl2ydFydm+zX04KXCJArc482fAjbvjUuYHnGtK/SoWsryZb7sq3cY0apNZNsd7EKbnPg7IghQO4tHZHqaUWBwPtkMJFO9K7tPqPi7MXHFKlfQgtNq+2SwD5EBZXbdJWka4IAfjUHB/4wnZjTS231uuGjop6V7q0cCso7GRJyFI2NBYLF+iAe6kL9gbwdY/9lACLJ7zMEZmzdZ1ROVJrpEEaVjLIFDD4I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> On 32-bit x86 systems with HIGHMEM, kmap_local_page() only maps a single
> 4KB page. However, the elfcorehdr segment can span several pages (up to
> hundreds of kilobytes).
>=20
> The original code blindly copies 'elfsz' bytes at once via
> memcpy_flushcache(), overwriting adjacent fixmap entries or critical
> virtual addresses.
>=20
> Fix this by copying the new elfcorehdr page by page.
>=20
> Cc: Thomas Gleixner <tglx@kernel.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> Cc: Vishal Verma <vishal.l.verma@intel.com>
> Cc: Baoquan He <baoquan.he@linux.dev>
> Cc: Chao Gao <chao.gao@intel.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Eric DeVolder <eric.devolder@oracle.com>
> Cc: Hari Bathini <hbathini@linux.ibm.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Sourabh Jain <sourabhjain@linux.ibm.com>
> Cc: stable@vger.kernel.org
> Fixes: ea53ad9cf73b ("x86/crash: add x86 crash hotplug support")
> Link: https://sashiko.dev/#/patchset/20260907125404.922123-1-ruanjinjie%4=
0huawei.com
> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260918100442.3841=
135-1-ruanjinjie@huawei.com?part=3D9


