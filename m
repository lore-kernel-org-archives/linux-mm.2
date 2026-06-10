Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C687CD98C7
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 23:04:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3BD36B0093; Wed, 10 Jun 2026 19:04:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E14AF6B0095; Wed, 10 Jun 2026 19:04:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D020C6B0096; Wed, 10 Jun 2026 19:04:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C01A26B0093
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 19:04:21 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 886BB1C2936
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 23:04:21 +0000 (UTC)
X-FDA: 84865533522.21.64BD414
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf31.hostedemail.com (Postfix) with ESMTP id 8C9CB20002
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 23:04:19 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=P0s6PrGo;
	spf=pass (imf31.hostedemail.com: domain of dave.hansen@linux.intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=dave.hansen@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781132659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=yOedxWyBOuAVuqFRoW3f2unZT9r+44cMF9juxzQ3+kM=;
	b=G9qtKeiE3KRaoGmLosNpPr3jHJy8AxIGn6mlhbSK1zqQo8dQoANSR5owWbf6jDiKwgpiAo
	9PQKqyWvmdK+hWLPpV9hZyRPTK+6Q8lcMv9ZWnLAbVhsdL22v0mrq1I5eNCostFGHleql7
	fiK9XYiM6rMd9SeEwTzRICIRK9gUQdg=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=P0s6PrGo;
	spf=pass (imf31.hostedemail.com: domain of dave.hansen@linux.intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=dave.hansen@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781132659;
	b=i5KvoQCSiL7Nw3epi82Xnw2uL8XuZQ9I/gmIOKI+AqJasT42gz0mB7ch2DFzz1wzmtngJT
	c0Bpz7ZarGhnAET19x3gD0RE/1Rq6OTnKdgE++cy6BJmRxuERoQQMFlVrCS00p1tME3Xl2
	EfsxTR0TtY2ymVrF8EO7iclvSExpTMs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781132660; x=1812668660;
  h=subject:to:cc:from:date:references:in-reply-to:
   message-id;
  bh=e05wYXuo6Rnig5sVWE/a8UtaGwRE8fbO63Dp2L1ubI4=;
  b=P0s6PrGoOa/EoCZ02Fq4++Mmaa6Yl2ei2JS1LfTH4+EvhMdOUEuHck8S
   7At0ZJ/nM53yxS8GCUYfJEGQIJ7RtJ5A4RpdHIulJoeCmZdj/8tc8kARB
   m2oQ+hitWIRq9O9gCiHsIC1QDMMw41Bgh633CuEX56zuQeCCuzF4kZPtG
   l0yu7veZYLGQl+5Gu1Di5TUhV3Ycopjco2XOrr0MW0cQ4yNJ5mtnUY3mu
   4n8YPRYlIx1KC6kJ6T5b639sAdHl/XAabHPbR4wJN/P0sMF4FjghjkunA
   foVYhULgEKzSTAaLykoclQHcfrKIMatnAkebxBaWtJUES9fmXsU2uCWKQ
   g==;
X-CSE-ConnectionGUID: MRmIt6cmQkyd7wiEgRqesQ==
X-CSE-MsgGUID: dRnU0pX4SwC1klrM9r8p6w==
X-IronPort-AV: E=McAfee;i="6800,10657,11813"; a="81074120"
X-IronPort-AV: E=Sophos;i="6.24,197,1774335600"; 
   d="scan'208";a="81074120"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2026 16:04:18 -0700
X-CSE-ConnectionGUID: IfwMSswuQKeXR78Inw71jg==
X-CSE-MsgGUID: 2UPwDDKpRauG9v11yWy1NA==
X-ExtLoop1: 1
Received: from davehans-spike.ostc.intel.com (HELO localhost.localdomain) ([10.165.164.11])
  by fmviesa003.fm.intel.com with ESMTP; 10 Jun 2026 16:04:17 -0700
Subject: [PATCH v2 4/5] binder: Remove mmap_lock fallback
To: linux-kernel@vger.kernel.org
Cc: Dave Hansen <dave.hansen@linux.intel.com>, Alice Ryhl <aliceryhl@google.com>, Andrew Morton <akpm@linux-foundation.org>, Arve Hjønnevåg <arve@android.com>, Carlos Llamas <cmllamas@google.com>, Christian Brauner <christian@brauner.io>, David Ahern <dsahern@kernel.org>, "David S. Miller" <davem@davemloft.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-mm@kvack.org, Lorenzo Stoakes <ljs@kernel.org>, netdev@vger.kernel.org, Shakeel Butt <shakeel.butt@linux.dev>, Suren Baghdasaryan <surenb@google.com>, Todd Kjos <tkjos@android.com>, Vlastimil Babka <vbabka@kernel.org>
From: Dave Hansen <dave.hansen@linux.intel.com>
Date: Wed, 10 Jun 2026 16:04:17 -0700
References: <20260610230409.A44D29FA@davehans-spike.ostc.intel.com>
In-Reply-To: <20260610230409.A44D29FA@davehans-spike.ostc.intel.com>
Message-Id: <20260610230417.77D64DBB@davehans-spike.ostc.intel.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8C9CB20002
X-Stat-Signature: izst3mbrf8o6ocbgiki1597c1uc66aon
X-Rspam-User: 
X-HE-Tag: 1781132659-466822
X-HE-Meta: U2FsdGVkX1+dan5BjFBDi/9TZfFIlZYOCCCsv/wsiHcfcaNErBU8a1MnF7UWn+hPykjXadAldGRVZbe2kA6AlAl2MSgujScMfzaiCkM3vjQeYnR/4cWBmNjrND767nNgeP6YejH84KEYuIWIr6QdghrUQDGO/TdQTpX10TeAV6uCxmWefySS+eGfttgtulww0iAaXu4EQXEEFYogOP4xSXDhKtbjyQk9wgESv+U+qhmrkTKQ6D8am6A6y4MKVs+6siOr+/pVJgRE2qg9ezd8Az2Hj7lV7wGRGJA8uMCaxk8x28cM4gmbI36bqdx/Lbfm4alg/N2e1lsRvWV38UcB4lXPWZsBiVTNhATl/NvVdtGC467sI8r+GZb/YYpNZpzJcWosTtgbIkweqpdQI2A8alJ2/AwBBAZXwmDuhynrF1b4ALsRDs/ST4tk1JKBngam229Fv9tZIFyt83arvAi2eDEd1Zua3c1BZN6U4o+DZ3p6473ESPGtbdLBmDZIADKPYLKosLvMBjpCxjy+/4uDPgt0vl8enXeYLpcTtzgTwCxsJUoAxNSxqSilVr/tJkSWsxrf3ESFs3mun844qQnJCXXMjOBInqxUZQn9aL/rh7v6NkYOhfMa4Zfz/LGaKv5iM41Y5u7GN9a8NugbWVBR6mgpUM4770RxwjMUX2PD2ikmgA/Z34dbIDymhf5yTQRVyM7j+2r0udwyN6IQUZdOlM3AyvFbCoajaqsBppgBiQAAfxpeWFhXjfVLfzyV8zaAgtuh5rH69cPyyqxgAjRYgn5GT0BxkwfXKWOKfpdbrcsbCkEyaEzVX8O/DehbMEFThA/9Q8Ju+CyBCkJIDeyTocva7/2jWUMm/1Na5RfYkofNOoi4r7SaF9VPrpxGfMB9OYk6eY8czbjLyNL0HvBRruOJPy0APK8Ik1BIKbCHDcRUDhsXmLa1tZ4zLqsWPEa1TyOx5MABYGHmdwd0N7O
 rvKP4b3s
 BLvedRCcLkykGR/Y8H5CyLmDbSOhJagFHy3pMA4Li9pO4YZVous3E7mXyK2nfProQLYFUHXqE/jRtJevBaNU9ZaiIBmiK1NU+fkQyQdKa4Ti43HYjCxLcrEKcdTbhCwiQ1WyFXeBzO7HmUz3ZDAKNiYrdCWR8Ka4xRjCoHTRoacRzhSu0pVXaciFvnZE45gVw5KCjMoOq4T1d0hR+JxjSL2XXJSRYf04nLKspONEjeF69tUdbPcIFnqZ3AzhXfvSgevf5yMqo2Y9znicWGyiGI2/P8BmPwS7A7ZN0ePvOWTRY/asftz2fQ7zYNA2xw/cotAfJsZJHpo4CI1wvzC2etEI93y+8br/GWxL0TS3YlavtT1F2H12BZrZtwjSo1l5vl/Nv7aHQw0K3l/MvJ1JROdkY3wRAj+a8nZV6vd701xfi/ep9GTEY169N88J6ZnicfY4eStiZKvyVhrzhZTYo+mzzJkYN1M4NLLdmCQ7URRYL0gwQkV/o1LHhkU86Y6k/XRJ/wRyDjOrBvcZSosT1SDeH8NVU9zm5ziE3jnJITuWV3DEZWHJHrjjC/h2QhCP4+fxRVMiIPz2TCJUiJZJfTaoTXEJ/xLeyo1bqqSRqo4o4f/xwRzXRjGopfis7QD85+Kt9cXH2J80u3BHbKV2/GuFIFxufyztbzhWdryW31seNhhmhYCwhF9kXcjXcvZ5JvRsmJCBvdmaGStI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


From: Dave Hansen <dave.hansen@linux.intel.com>

Previously, the per-VMA locking could fail in the face of writers
which necessitate a fallback to mmap_lock. The new
vma_start_read_unlocked() will wait for writers instead of failing.

Use the new helper. Wait for writers. Remove the fallback to mmap_lock.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Acked-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-mm@kvack.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arve Hjønnevåg <arve@android.com>
Cc: Todd Kjos <tkjos@android.com>
Cc: Christian Brauner <christian@brauner.io>
Cc: Carlos Llamas <cmllamas@google.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: David Ahern <dsahern@kernel.org>
Cc: netdev@vger.kernel.org

---

 b/drivers/android/binder_alloc.c |   17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff -puN drivers/android/binder_alloc.c~binder-vma-waiter drivers/android/binder_alloc.c
--- a/drivers/android/binder_alloc.c~binder-vma-waiter	2026-06-10 15:57:56.419452721 -0700
+++ b/drivers/android/binder_alloc.c	2026-06-10 15:57:56.423452863 -0700
@@ -259,21 +259,14 @@ static int binder_page_insert(struct bin
 	struct vm_area_struct *vma;
 	int ret = -ESRCH;
 
-	/* attempt per-vma lock first */
-	vma = lock_vma_under_rcu(mm, addr);
-	if (vma) {
-		if (binder_alloc_is_mapped(alloc))
-			ret = vm_insert_page(vma, addr, page);
-		vma_end_read(vma);
+	vma = vma_start_read_unlocked(mm, addr);
+	if (!vma)
 		return ret;
-	}
 
-	/* fall back to mmap_lock */
-	mmap_read_lock(mm);
-	vma = vma_lookup(mm, addr);
-	if (vma && binder_alloc_is_mapped(alloc))
+	if (binder_alloc_is_mapped(alloc))
 		ret = vm_insert_page(vma, addr, page);
-	mmap_read_unlock(mm);
+
+	vma_end_read(vma);
 
 	return ret;
 }
_

