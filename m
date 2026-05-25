Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D43DCCD5BB1
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 19:10:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C3346B0095; Mon, 25 May 2026 15:10:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14D2B6B0096; Mon, 25 May 2026 15:10:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0148E6B0099; Mon, 25 May 2026 15:10:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E17276B0095
	for <linux-mm@kvack.org>; Mon, 25 May 2026 15:10:46 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7E856A01CA
	for <linux-mm@kvack.org>; Mon, 25 May 2026 19:10:46 +0000 (UTC)
X-FDA: 84806884092.16.299051E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id D3BEE80010
	for <linux-mm@kvack.org>; Mon, 25 May 2026 19:10:44 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="bJyrtF7/";
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779736244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AVOvhANuc/qDLfDQ+IdQxPRPdA0dhJZiZGIRxYHlRHs=;
	b=akffwl2pXDjOQnWECoLh4Ulo4XMMvg9nqF+czyyJZziJAI5GEM/UqnO+Vgs9MFkUVRtJ21
	51/MC5FMzCb3Kxpxws9fi3N/FK2FErYUBcNsW5hMBCuLl1V94RUcZ6RhN9SjS4dRe0YDwO
	gl7/HWwKlj585sGk40boFsmkPwwhYIs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="bJyrtF7/";
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779736244; a=rsa-sha256;
	cv=none;
	b=YYhXNJEFVGmwWZ8rFweFnEicj3etZT2fFvel5q9bCFXoldrG/ro4kMpMthOFpPqR4aiTji
	J7yvLEH8vd35hK1o8x6yFM2asE4rn/J0GtlTT8nNyOjCX5P03lUteRc/CllT9sn/CeNz/x
	BlIWjseyauW5AHhB4EaWA2MdOjfTnng=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2134360008;
	Mon, 25 May 2026 19:10:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14C011F000E9;
	Mon, 25 May 2026 19:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779736243;
	bh=AVOvhANuc/qDLfDQ+IdQxPRPdA0dhJZiZGIRxYHlRHs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=bJyrtF7/OFk+pS/31wbvaD/xB7Rv/k9KDyiU6nymD22iIq9ByUeQhJMkhcoxZxBvF
	 T8XbpglCc0oyk5HIVB0rFQEQi4FYz25Tjhg9LazpnjtwnljsZVdPxfdkkBEpY4phyg
	 +1pQAolnanUVT5H5FyT1s9kkMj6evH1jJP7gJpiQ=
Date: Mon, 25 May 2026 12:10:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nico Pache <npache@redhat.com>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
 aarcange@redhat.com, anshuman.khandual@arm.com, apopple@nvidia.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com,
 catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net,
 dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com,
 gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, jack@suse.cz,
 jackmanb@google.com, jannh@google.com, jglisse@google.com,
 joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev,
 liam@infradead.org, ljs@kernel.org, mathieu.desnoyers@efficios.com,
 matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com,
 peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com,
 rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com,
 rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com,
 shivankg@amd.com, sunnanyong@huawei.com, surenb@google.com,
 thomas.hellstrom@linux.intel.com, tiwai@suse.de, usamaarif642@gmail.com,
 vbabka@suse.cz, vishal.moola@gmail.com, wangkefeng.wang@huawei.com,
 will@kernel.org, willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
Subject: Re: [PATCH mm-unstable v18 11/14] mm/khugepaged: Introduce mTHP
 collapse support
Message-Id: <20260525121041.2f2508a4f627c338cddd837a@linux-foundation.org>
In-Reply-To: <2b2cda8c-358a-4a5c-989c-ae42593ef2ea@redhat.com>
References: <20260522150009.121603-1-npache@redhat.com>
	<20260522150009.121603-12-npache@redhat.com>
	<2b2cda8c-358a-4a5c-989c-ae42593ef2ea@redhat.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 5wu8icppw7kd7k39djjzbzb7zz5s7kw8
X-Rspamd-Queue-Id: D3BEE80010
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779736244-572383
X-HE-Meta: U2FsdGVkX1+XxbHIOsWnDpv+7l46EZw3fNNHJ1gBlnaia/szB/JeUbdOHCU8Z6e9sFupl7jPBfMcC0mOOokSrHOfiNXkEX4qbGxGCWnC7P1IBssM4sFMqVvChFZ4Wuxeh2fPrn0Ia2Uy5bUxZ+NoxTn8erwyGBbw3ayvKXkkIaZo3GnyTOSCeO0y4/kaKwHTkQLtzg4xVClbR0v6/hpO/Mq/nQ9KiMVQaRdsGoDLqv/WOEars2P2flJbSASt9pEkGFXNjDbICXRtfPlsTbIYngaHA2YDNetAdD3TBwY3uo2PU/VugUl5rFNjZ3Px8v6Eg72aGESqUzx44fjS0lCjKWS+wtTdFcTNnoEHrC4ZN2FNibbkD6G190IRzpYwkEbRrLjzsWKpjQX5bOFs69WfSXfZmvhvLR5ulrfSxdy0al0kqH9uhu/CaLjSNevc1gXYnZb8ejEEXGuyGYd903e7vLfX9dggHcSMiEUYQmcQqzRiimRQr4o/LOL2WIBnKPLgEy15ZoEeDfDygiRzFqxn4JXBgUJL0Dtj53kNJJRSLgDzyxvgvpK10i41W3XnDm45aE9Zo7C4keV8hq4G8jnW0MN5Mwh2ADktFhuqHcVa7UQim0I8F0UmRh6K7XEKpu+mGCZWjwGnQPs9CNx2mPR956+HBc2IMklP092FYzqR/bR1SnQVlfjSGEOJGjteYtC9RK+FnJA3NSJ4+Xr3GDNJXiHxTl8jonUAnM+KiV7jf+hjbOo/6rm2+9/Wn26jyIS0GtRDAKjrklR361sQRJqQRPR611cnerEc/a5wTqcK9OJDcHRiFgGpTi+BbrgR9WYkj76gE9VSZ2qeRcrnIPhdMO8/nSzkWjX0MlT7SEPo95nA0OeU1rMf4ilnYK+4GtYS1vKLhTHsoZNebpH1UUnOqB3e86vZbcw28r5jLomeiBV5/4VROIS53jS89Jy1tFQms9PBA5+My3p5LHnrPUi
 R5BCxzc4
 ISCe3/sStaXcL0w+PtufDUQcm2ZUSs2AZn4/HHgSBagrfKNFlAWM3R9D51vumLHASmjL3GHU8VHA+bS+8ufBRfFTbN9V4FgCRvF34/ExIAtRlY6XmuylV0S/er7zn2p8Isxj0/w20YWXI2rWD7r+sWXJ78kKWPk8lNF0ljw9SyGSt1BzigmKcGEhHqCqyU6aGwTDrb/tJcu8UxqgIwM1Y/W27JzA7JEaaBXj8CkmR88ZjUO9FaXsQPFnQ2fnxGCZVj4GWNkV27A4stDFslHIHsqVltQfX5K2+5+VoyrlxeI5sB/r5FlbwcR7mupC2WZ0PBmCTRr93YUDwitTd1vicI0g43BexXpoyd8B4QpEwvSx7w/c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 25 May 2026 08:15:53 -0600 Nico Pache <npache@redhat.com> wrote:

> Can you please append the following fixup that reverts one of the
> changes requested in V17. The issue with the change is described
> below.

OK.  fyi, what I received was badly mangled: wordwrapping, tabs messed
up, etc.

Here's my reconstruction:


Author: Nico Pache <npache@redhat.com>
Subject: fix potential use-after-free of vma in mthp_collapse()
Date:=A0Mon May 25 07:38:59 2026 -0600

Between V17 and v18, one reviewer (Wei) brought up that we are not doing
the uffd-armed check until deep in the collapse operation.  While not
functionally incorrect, it can lead to unnecessary work.

We optimized this by passing the vma variable to mthp_collapse() and using
the collapse_max_ptes_none() function to check the state of uffd-armed
preventing the wasted work later in the collapse.

mthp_collapse() is called after mmap_read_unlock(), so the vma pointer can
become stale.  Remove the vma parameter and pass NULL to
collapse_max_ptes_none() instead.

Link: https://lore.kernel.org/2b2cda8c-358a-4a5c-989c-ae42593ef2ea@redhat.c=
om
Signed-off-by: Nico Pache <npache@redhat.com>
...

 mm/khugepaged.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-introduce-mthp-collapse-support-fix
+++ a/mm/khugepaged.c
@@ -1502,9 +1502,9 @@ static unsigned int collapse_mthp_count_
  * If a collapse is permitted, we attempt to collapse the PTE range into a
  * mTHP.
  */
-static int mthp_collapse(struct mm_struct *mm, struct vm_area_struct *vma,
-		unsigned long address, int referenced, int unmapped,
-		struct collapse_control *cc, unsigned long enabled_orders)
+static int mthp_collapse(struct mm_struct *mm, unsigned long address,
+		int referenced, int unmapped, struct collapse_control *cc,
+		unsigned long enabled_orders)
 {
 	unsigned int nr_occupied_ptes, nr_ptes, max_ptes_none;
 	int collapsed =3D 0, stack_size =3D 0;
@@ -1524,7 +1524,7 @@ static int mthp_collapse(struct mm_struc
 		if (!test_bit(order, &enabled_orders))
 			goto next_order;
=20
-		max_ptes_none =3D collapse_max_ptes_none(cc, vma, order);
+		max_ptes_none =3D collapse_max_ptes_none(cc, NULL, order);
=20
 		nr_occupied_ptes =3D collapse_mthp_count_present(cc, offset,
 							       nr_ptes);
@@ -1749,7 +1749,7 @@ out_unmap:
 	if (result =3D=3D SCAN_SUCCEED) {
 		/* collapse_huge_page expects the lock to be dropped before calling */
 		mmap_read_unlock(mm);
-		nr_collapsed =3D mthp_collapse(mm, vma, start_addr, referenced,
+		nr_collapsed =3D mthp_collapse(mm, start_addr, referenced,
 					     unmapped, cc, enabled_orders);
 		/* mmap_lock was released above, set lock_dropped */
 		*lock_dropped =3D true;
_


