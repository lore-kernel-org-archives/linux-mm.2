Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB464C5DF9D
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 05:35:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 460BC6B008C; Thu, 27 Aug 2026 01:35:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4130B6B0092; Thu, 27 Aug 2026 01:35:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32A186B0095; Thu, 27 Aug 2026 01:35:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1185F6B008C
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 01:35:47 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5BA13C0293
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 05:35:46 +0000 (UTC)
X-FDA: 85145937492.12.3FDF1D9
Received: from mta0.migadu.com (out-42.mta0.migadu.com [91.218.175.42])
	by imf24.hostedemail.com (Postfix) with ESMTP id 12EF918000C
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 05:35:43 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BjEUT7ZE;
	spf=pass (imf24.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.42 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787808944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ix2ALydu1x2TJzcKfndh+/WS65VVtp3A24GQjy/mtmk=;
	b=dgAXojzTxcw5ahoxe5oc2obCNlFyj98DlzTLXMJIPPQVDtX0bDVi3vBUjlUfbU2TQjdc/k
	uDMP8rqyYMdSI5UIbW0xpW9mMV8HL0jwFC6IA2ZUMz+JmX/S0trt7ogF/oNRU1gDSrpnIn
	qYw1nywe5E4JZd8j1sILVNa6eAt0QN4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787808944;
	b=skFC8BCsxpPm8iGDyB/0am7qWbf+k4v4AoU5JXwCUReGkkfkJcQjXCOZlq4YLt6xEZ/Qsd
	C9eB2jixWPy8sU9IA4W78dTb7kKN2xbr8pUU4ZE5E0kOAXE1oHIMtxfi+6nkXFnFvE+IoK
	uDHc5DjEEPs7tzGLPBgGN+/NqSLCQJ8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BjEUT7ZE;
	spf=pass (imf24.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.42 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=CztYMdjLZpKGzEVJeG55tEt7ujyjlh1YgMpcAGn0CQY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787808942; v=1; x=1788413742;
 b=BjEUT7ZEdFGr0GuuzX2Aq3QNiG66AJw1b3UD17yr26kkLC+M9CRUg2ea0NIB3nDsLhhhlo6v
 DnaDOMFCuiB7XBP0lEn9+mS/UV/d5twgGWyxmC8dbmZd07Pp9hnsQh+dYNYZOikeQ3qcz8hcy5S
 B7alX2oz6uecfyWYFXvwOSX4=
X-Envelope-To: linux-mm@kvack.org
Received: from webmail.migadu.com (2001:41d0:303:fc7a::)
	by smtp.migadu.com with ESMTPS id 7b273cdc8630cbad;
	Thu, 27 Aug 2026 05:35:32 +0000
X-Mizu-Trace-ID: 7b273cdc8630cbad
X-Migadu-Flow: FLOW_OUT
MIME-Version: 1.0
Date: Thu, 27 Aug 2026 05:35:32 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Hui Zhu" <hui.zhu@linux.dev>
Message-ID: <f33eaa0c730feb9f598738ff79d98cb25b4b2bcd@linux.dev>
TLS-Required: No
Subject: Re: [PATCH] maple_tree: Annotate lockless pivot reads for KCSAN
To: "Liam R. Howlett" <liam@infradead.org>, "Andrew Morton"
 <akpm@linux-foundation.org>
Cc: "Alice Ryhl" <aliceryhl@google.com>, "Andrew Ballance"
 <andrewjballance@gmail.com>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, linux-kernel@vger.kernel.org,
 maple-tree@lists.infradead.org, linux-mm@kvack.org, "Hui Zhu"
 <zhuhui@kylinos.cn>
In-Reply-To: <kpzm3pcwxwnzk5kngcsfcybzst5jtyrdcphd3hcpmoc6dbtswq@atn5yddl23qx>
References: <20260826074430.1139325-1-hui.zhu@linux.dev>
 <20260826094147.42e1e71e91a5a537ced30a21@linux-foundation.org>
 <kpzm3pcwxwnzk5kngcsfcybzst5jtyrdcphd3hcpmoc6dbtswq@atn5yddl23qx>
X-Stat-Signature: wpihsy4aq18f3gx8kknce1uf5jz9u767
X-Rspamd-Queue-Id: 12EF918000C
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1787808943-805238
X-HE-Meta: U2FsdGVkX1/2IRQ4nvKvpgjeivMgHaaSdm13aCg8/hNeAhZ+m+tksVh9kkGP+DfqADxX0Fylayku8Gt5QVbMEZQIbNxZ/qANF+ueZ4nI6v8CHhUx7mItRAAzjo+v/jhAdMrsrWbERZJeakxhbKQKb6kX+kdQc4H8OgSfLheOCM0qMmiVQMrQOLGwYxp+NcMj32DYoZQ49EC+i63P7qLF5PTZUzk95oZfFL9mwj/1S3qliD7s9P+U7uPAOhf1k23uDI618JMSBF8cVjHbtdh1Kx0tjOTBkoUVqx3Oo9xLKIO/rgLv6mQLXwKjKjf/ltX8OObz9YuuerxxUXZWOrie8KEHjSSzG0kJFiTBY6x+WaZmG7ryrLB6pCLWOvcZiLdEhPQtPfn3Y8+c90ekm5FVwbpPte5INyiwRYHBxhFmvuebfvBcpdUA69nOCxH+2cHq6IFtcKNl9jMkUP96AVADCm/OcocMXgarWD3fwzwphHXK3e0ZXaYt4T9Tel3mQ72ApXMIwTzXp24sIVFUolj0QILiGc1dSiHmq5LGJolMRXbYBXEj/5dN/bDNtL5ykw1ARWY5WnJsD6y7ulCgh91hcLWN6kvRZKW9ejrnGNsJZnZ3+EJFbNYu9R4zbiaFv2mJoZBvzWjw29NvKi7UfKySpHqau0EjTSTslv7LPMCQMwCh49vLOqF6mKVef8X6PSJW5q5Ron207AXjkKnn7xhhNgTRV7x/fPCdHTbnSwCKQwBPD/yBVSO4QGDwHpvjoJkLebqC92WtnXkWELYUxrRwhh8W7HgZJUr5zbcwsoj1ixhP1oUMojzOQ8nTvbGjI6C8C+QIyyugT3gm9DW1znjjAUchte2XqdP3D6DL75iEX2h1uMlwrD9t6CYrZbB5jmay777Abr/G4jFBz/BCshtj2KS49xjMfU6RxdJDkQVOcNCylUhfj5myKhNdJQGZZ76pB3X8CwwC5MBu0QANKme
 wrZiKgWJ
 j4iZomRKDO7hIYEyB4iDronmOTE5Fh/K1ItluamB5jv60FpchNOF/oVJxvVNagORIyqD6QkSaRj/xXg/S7rR0VdSXcFW8542YBwvtM+q1yNA1kx/Z/FY+D2DOwl667FNv6FsOaOmtWkb8J7kcT9X3GQSewhyJQCRN88XWsTLuL27sXCgPpQD4DYr/d15YYy500rRivqmUGMC0NXnLpkVBpjMDfx07QpCv9TXHQKJBDaWp/bztDEhB4qEQnL3CIa8AhrtGDO983duaWkh199lf8S49IX2cfbhhHy2IzxEgMVxVmTNjCgqnrRODa/8HvExhtX4DSwqsIuLOBRvBHPmhKIZ9qp+w/p2ZUQwsOuacfeKraOu5t8Z8yzif2TlMMl12rypV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>=20
>=20On 26/08/26 09:41AM, Andrew Morton wrote:
>=20
>=20>=20
>=20> On Wed, 26 Aug 2026 15:44:30 +0800 "Hui Zhu" <hui.zhu@linux.dev> wr=
ote:
> >=20=20
>=20>  In RCU mode, replaced maple nodes are marked dead and freed via RC=
U
> >  after the new node has been published. Arming the RCU free writes
> >  node->rcu.next and node->rcu.func, which share storage with
> >  pivot[0] and pivot[1] (see struct maple_node), while lockless
> >  readers may still walk the dead node. These stores therefore race
> >  with the pivot loads performed by the walkers.
> >=20=20
>=20>  This is harmless: the writer marks the node dead with an smp_wmb()
> >  before arming the rcu_head, and the walkers re-check ma_dead_node()
> >  after reading the node and restart the walk when the node is dead,
> >  so any pivot read that raced with the rcu_head stores is discarded.
> >  KCSAN cannot see this protocol and reports the plain accesses, so
> >  annotate the lockless pivot reads with data_race() through a new
> >  ma_pivot_rcu() helper.
> >=20=20
>=20>  Found by fuzzing on a 6.6 kernel; the race still exists on
> >  mainline. No functional change intended.
> >=20=20
>=20>=20=20
>=20>  Thanks. AI review suggests that the patch is correct, but incomple=
te?
> >=20=20
>=20>  https://sashiko.dev/#/patchset/20260826074430.1139325-1-hui.zhu@li=
nux.dev
> >=20
>=20Yes, this is literally every read of numerous pivots on any reader th=
at
> would need something like this. Most code is shared with the writer
> side, so we'll have data_race() annotation where it is not needed there=
.
>=20
>=20I don't like the name of the function and I don't agree that it is wo=
rth
> doing, especially half of it. If you notice ma_ functions take a maple
> node as the first argument, but your new function takes an array pointe=
r
> in the node.
>=20
>=20The from address does not agree with the sign-off on the patch.
>=20
>=20I also don't think a benign race needs a Fixes tag?
>=20
>=20It might be worth looking at other ways to calm kcsans down such as t=
he
> type qualifier __data_racy, or maybe the makefile option.

Hi Liam,

__data_racy is defined as volatile for KCSAN kernels, so the qualifier
has to propagate to every access site: ma_pivots() would return a
volatile pointer, and all the "unsigned long *pivots" locals and helper
parameters in maple_tree.c (about 25 sites) would need the qualifier
too.
It also marks the whole pivot array as racy, while only pivot[0] and
pivot[1] actually overlap the rcu_head.

The Makefile option (KCSAN_SANITIZE_maple_tree.o :=3D n) is a one-liner,
but it disables KCSAN for the entire file, so any real data race
introduced in maple_tree.c later would go unnoticed.

Do you think one of these two is still the better choice, or should I
keep the current approach and fix the patch according to your review
comments?

Best,
Hui

>=20
>=20Thanks,
> Liam
>

