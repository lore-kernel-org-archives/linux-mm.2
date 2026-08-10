Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37C5AC5AD7B
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 22:36:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6DEE6B008C; Mon, 10 Aug 2026 18:36:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D46176B0092; Mon, 10 Aug 2026 18:36:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5C8D6B0093; Mon, 10 Aug 2026 18:36:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9A8D16B008C
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 18:36:33 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1B3F61602E8
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 22:36:33 +0000 (UTC)
X-FDA: 85086820266.08.2BE8C94
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4A47C80012
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 22:36:31 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=BqER6ii8;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786401391;
	b=eqiNTN4bTxfgepbmAC3U7HUb4whuaeg6M+qcIALK0+zqNH6pHj+lxGFDUGU97Q4wUXIwnt
	Gl7LbLajXVIIHibiFUVst0Hoxp6tdGlbYOwOKy91aaRqPlvT3mykD8h1/DImK4WLckzCWP
	tcRdBOhxvLa4apOEXHnj/hXZhwgPOQQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=BqER6ii8;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786401391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sxvtq+dIwwU3yFI4tCujCyDFVlEgje+/ENJLI3Tg09c=;
	b=WfiW412gcxvSR0O3X44xMLzg5HP7Mi5QvPB4+kgPIPJf8P/nSFrLHwAbV3zmmaPd51TaH9
	ru3cSzKKJpzVhU/swsz0etaqa1xEFLIMTATm4JlWI7g15aMeGuGUbOnrmfhmC1QLWssBma
	lPX3AqAEBxy2el32mUl9ym0M9gPrQ0c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F2CEC41A17;
	Mon, 10 Aug 2026 22:36:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48F691F00A3A;
	Mon, 10 Aug 2026 22:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786401389;
	bh=Sxvtq+dIwwU3yFI4tCujCyDFVlEgje+/ENJLI3Tg09c=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=BqER6ii8rP6FRY/NkYYyEQucd0+AtYHZb1aVAv1nJaet7sjRY4DvKpaScwlj6hH70
	 STxclYdXzNPEPjz9DJj4oroJ6inTBGt7aZVWKnVRSYS5lKOnRsujg1sn4T7GmDL7k4
	 df3AjAXRo6tPZOQYDAS0DHAiNu8DU7i9Ij23zig8=
Date: Mon, 10 Aug 2026 15:36:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sourav Panda <souravpanda@google.com>
Cc: Muchun Song <muchun.song@linux.dev>, osalvador@suse.de,
 usama.arif@linux.dev, shakeel.butt@linux.dev, wangkefeng.wang@huawei.com,
 anshuman.khandual@arm.com, david@kernel.org, surenb@google.com,
 fvdl@google.com, gthelen@google.com, hannes@cmpxchg.org, riel@surriel.com,
 sj@kernel.org, vbabka@suse.cz, mhocko@suse.com, bjackman@google.com,
 zi.yan@sent.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] mm/hugetlb_cma: Fix null nodemask dereference in
 hugetlb_cma_alloc_frozen_folio
Message-Id: <20260810153628.c4049163bd92b5ce3d3d7d99@linux-foundation.org>
In-Reply-To: <CANruzcQ_1533umf4ym-t5EVm_WX5rrYtCbCqaTdvNr6EgOYR=w@mail.gmail.com>
References: <20260809043250.2917406-1-souravpanda@google.com>
	<E2FFA328-21B3-4E3D-8CB9-5638B4CB545B@linux.dev>
	<CANruzcSySUn_gLEh9kxwvatSCn4hizcy6v2BkcMe0Jb=HoUOSw@mail.gmail.com>
	<60440F8D-5EE8-4254-9057-5FAD09B5D1FF@linux.dev>
	<CANruzcQ_1533umf4ym-t5EVm_WX5rrYtCbCqaTdvNr6EgOYR=w@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4A47C80012
X-Stat-Signature: qudtkhem1nfxnujrb7rjpyi84wramf8p
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1786401391-591073
X-HE-Meta: U2FsdGVkX19SgAMn6XaKSs55yEqyN8odeld34BYAFchYF/MYYsG4vllIsShSO7hkw5+C5iwr+dEzkt5gwQD0B2lQ4EmPfZ46AF7gVOceeFNsHtCL6i2YUSZ0qBULIjnfi0ZagmzASCCyF9v0ofRtuXJbvX3BcqAKTo1vXewkg7ds7zQrMb8nTqZkDEpBbw0sK8wfcgVA4JDNLL89o71kPIb5sNx1XaMMeJbtaCkyeiSY6yd+OMCunfZtw/IWONa3Ek44MfUzfhHbSc6NhwNHipM7/0kYFswzcJyrAjPiABhY4mUqAGiksHSaQeyODVZBDBLcOygH139VThRxUMbCWsQ+3nBaTjXQRQG2WIf4sP0s9gwTyebHNgXzOkclmHi4WWVpBXwe+7o4Ri7895WUbPaKgoBTPmV/BzwdQ45wLlK3purwRDk3jDHNbHrPaKS27YTaJvSaPl0XMKmz1ftveBy1WxdyVis1fRLK+FNj/aDfh/tJ87CUUpYNHopRTcRrq2YnkiUUpQuF0IzZx1SEBOjz4TZotlqblQ7fE89uIGM/sn+CvYdR8T2xJKz28hUOU2OD+G22acjheLehgwczof+YIlKHUYvh3RqVmDY05lRTngU/Xvv/TeyoUPHO+z6zFQ1TD9N5Ox8aEnp2GOPl/h8isGRZO72a0NtZKXURslcV6cWu5ERuZnwR8xpB4fN5ewvj3PuRDluismiJfgT1p7xNBEhtjSu9hhd7ZJkNjyuxScpXIIo9ueHL8pEzPp81p6NE7p3F0O4whaFprXiE8PC7Q8w8A49hg/L47mI1tpUwIphz0M10c8At3OLBkNovAHyXKpD22OTUKxpZ8cWYr0WJeOjSRS76gKtFh4pXOiBRus2+Fm6NMdfYVFWcizTjH9AuSwgftdsR4dvDXTIH+ekOrwpkSQiliiiKdW+z59XAWe4A+mNUmzdsZhgGmClS2sc1AtOGkirM1wWoRkK
 twUiWI88
 0MSAZaE7pRfil0iNsNithw63ffhCPCiCsEnWquFHOXV7lJUeZRrnrAeAQbou6kbONAlnEWeJ2dawz9SErPKRzROUiZbXx4B2STpWP5U+DJAdUpQVMucwLiuuvCSLtEj+owJdSdKrHzLXtYuuBOENpDolX68lMpu0y9M14LOuZbQGjsrLIm1iie5tuXuTtvZZ0aDJe0oF1RL2ObLXK2wdqb8krRN8GBzxtLuaQnguMzzAliOk9AY/aLWQhVKVeRgnoCU9+yeCB2pN/2bhzsvZf/R+GBliSl8MnRZfj28KraCSDJe36ajB31IPHSFklhIyc3NrL0foSbCUtWXmwQ3jdA3h7oKblPUBUd8QYwuzOuLpt51A9/zgB48TSOhPhy5bXwrTF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 9 Aug 2026 23:39:22 -0700 Sourav Panda <souravpanda@google.com> wrote:

> > That way, we can remove the 'if (!page)' check here.
> 
> Sure thing! Thanks! I shall send this tomorrow noon (PST) since I am
> OOO starting Thursday.

Sashiko said a thing - I don't think it reported this against previous
iterations:
	https://sashiko.dev/#/patchset/20260726072935.3513996-1-souravpanda@google.com

I'll add this v4->v5 update to mm-hotfixes-unstable, assuming it gets
us a bit closer to the final version.

--- a/mm/hugetlb_cma.c~mm-hugetlb_cma-fix-null-nodemask-dereference-in-hugetlb_cma_alloc_frozen_folio-v5
+++ a/mm/hugetlb_cma.c
@@ -3,6 +3,7 @@
 #include <linux/mm.h>
 #include <linux/cma.h>
 #include <linux/compiler.h>
+#include <linux/cpuset.h>
 #include <linux/mm_inline.h>
 
 #include <asm/page.h>
@@ -30,12 +31,21 @@ struct folio *hugetlb_cma_alloc_frozen_f
 	int node;
 	struct folio *folio;
 	struct page *page = NULL;
+	nodemask_t local_node_mask;
 
 	if (!hugetlb_cma_size)
 		return NULL;
 
-	if (!nodemask)
-		nodemask = &node_states[N_MEMORY];
+	if (!nodemask) {
+		unsigned int cpuset_mems_cookie;
+
+		do {
+			cpuset_mems_cookie = read_mems_allowed_begin();
+			local_node_mask = cpuset_current_mems_allowed;
+		} while (read_mems_allowed_retry(cpuset_mems_cookie));
+
+		nodemask = &local_node_mask;
+	}
 
 	if (hugetlb_cma[nid] && node_isset(nid, *nodemask))
 		page = cma_alloc_frozen_compound(hugetlb_cma[nid], order);
_


