Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5DF0C55ABA
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 20:39:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21BE76B009D; Tue,  4 Aug 2026 16:39:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A5786B00A0; Tue,  4 Aug 2026 16:39:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BB3E6B00A3; Tue,  4 Aug 2026 16:39:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D89686B009D
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 16:39:23 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 653F91402D9
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 20:39:23 +0000 (UTC)
X-FDA: 85064752206.28.EB5CEE3
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf15.hostedemail.com (Postfix) with ESMTP id AA676A000E
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 20:39:21 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=euCW8157;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of nico.pache@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=nico.pache@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785875961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QDbKl5sN3zXJvqM7Ow15pU9blcxmowwVHWM0164VX7w=;
	b=lktm935g1zV5i16APa0Ro6WTYNgPpPnjFbywepv5kYK45RktcbMjYNKXO5XtOniVZ3AEDe
	Ja24M+rA64ab1iL3dMS8lyRwGuKUlA7JcBXSgupfq09Iw1Yw6BNAY4v+Ww/p1zNKkijnmt
	GDFEe8D6Srok7LUxXXR3v9KP4iKmeBs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=euCW8157;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of nico.pache@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=nico.pache@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785875961;
	b=P8MjLnqrxUWPm+hbZSGxFkRABZdaIxOtt5GSw2AtPN08sJlS90U6HNEQY/swJaVCyT8sXh
	UwbiC+PW0PlxWoixJAfN6Bt0qXy9p5gRGS+kAfjuassJAUEDxYv2sjy2qEAy5Ao/OCGniI
	AnzC+JDwD0wNs6kkCRIEbl1EiooDLDs=
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785875960;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QDbKl5sN3zXJvqM7Ow15pU9blcxmowwVHWM0164VX7w=;
	b=euCW8157Phlxbjq2kMmBkksO1LKLxex4ud9vsGDKP5AMZjD/yvtDuIZjOhZQuwikKVgDSE
	Kj/QEJROAFmwWB0KqQG37PhwwsEvObd09rGtPQWHcnPdWufFeezHL1Qo2JQhhjeroKfkUM
	/PmqbxCKZKAgPW3c3dsuRuSiOeS27aw=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 2/4] selftests: mm: move
 gather_after_split_folio_orders() into vm_util.c file
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Nico Pache (Red Hat)" <nico.pache@linux.dev>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
 ziy@nvidia.com, liam@infradead.org, nico.pache@linux.dev, dev.jain@arm.com, 
 ryan.roberts@arm.com, baohua@kernel.org, lance.yang@linux.dev, 
 usama.arif@linux.dev, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <cb0697506337320d438bce15cdd3c4caccb914a1.1785564857.git.baolin.wang@linux.alibaba.com>
References: <cover.1785564857.git.baolin.wang@linux.alibaba.com>
 <cb0697506337320d438bce15cdd3c4caccb914a1.1785564857.git.baolin.wang@linux.alibaba.com>
Date: Tue, 04 Aug 2026 14:38:43 -0600
Message-Id: <178587592371.79283.4345132864382617741.b4-review@b4>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: AA676A000E
X-Stat-Signature: gdd9wky4k6hdfzc9ywezgh57owu8ed74
X-Rspam-User: 
X-HE-Tag: 1785875961-63444
X-HE-Meta: U2FsdGVkX18rHJql1NyyhlnjJAXYXq5xxO+jRknPiOa7f1gEk9qbCVET54B0nHTyLprqGVturZtFEXH/LY2FD+Mj7zcIRjtrBY6RwtF5GFLmD4PKJahH1IiSkaaAXLQEaYeQVONiwTA8ERn/fjofHClyE9OWfB7c0QH7Q0zQH4TsAvXYkf6HiGMaGALBIuoya3I1XLuEwx2Ayerpdlsxv6YwtTPInBOCRBK+8JDzNNShX/cwyww7vUARkgT/RdxuiAjKm6QQyJHCtSt18K7UtgQWRHAGuWVw/nveXHs+wp0AJlg/Bqvt5PLcxLq6MwNG4r68utsJ9THpnFgsJ3mFQuZf9uxFRpz/oHUQ0sOreowW/rtijYoMvyflVNU6kAtjPB88Jc5dOyzJSwXOsQly2bGV8fMuabkTL3fgFRGFuhbeKNHBIHbEh84HFAV31aVc2SdGIxxzwStMUadQKbylApCG92DOvlUKmNl1Sh3+CVxlXrtfH0hM0YwKj7zO95tKBdzdvDpCUFnzOUvfssUMOl5g0oCYVMsNkUuM4RK1LdjtRXXKi2XgSZshWgciNnZEDfvcZZ3/5QieULFg97ROP07YhFZ5NIiWG2fe+UPppP1bUKKLhYQvrqQOByiHw6JAIU/4LLGgIdRmyO+oxHhVmZ3TxIgocswoJ1+7jV/OYUPbSyRIYids35/UfNRaKgv8L/3XvdooOvXzcubkrrM9MwgwPZ0shHTyr4qz6TY5RluwftAbk/dQltpr2eJ/ALygQfCIbUcMJgEzRz9jeZiF4jwUmzDnLU3tvjhxv3inIYWjUH/U/mPukrXwosKtoG62vm7mIcmPQaMZDADkb+PVIX9+isjDz545Xqv/VGhKu9TK7iYvkuF0WWPbsFjNsRLAoI6sHJ1dunCGo//Skh+z3NEQzHjcxMm/4sQz21vbumM01rbeRfnGzDvbCr8xu99JEa9IuWfgSUXzgYtrLxj
 UHAuz7nr
 fnf8AqXyr+Sz18oIsd8zAqYAyggJkXUUevQzd+ZO/w39vZvGO5zAy2kR4y5dNuHonXnxeCpcYQJ/PnlBgAW7dVlDfN+CbgL8R9TgtZjyiWAlEGXGtxnCFgl8LKWZtTIAnt1kL18eoH6TUhz+H/f7pBruQ79JI9mRCsKchy4JvSs5d2fDrsBiNKckJcYolLE6un1oeni9zxXzFmV0PMmXohBcl/kYEtwNs6Nf6iEdUy8Tpi66cV3EOnXflLq0Z6YtL4eEkT8HFC0xBJPFSEVn/FJ+RVg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Move gather_after_split_folio_orders() to vm_util.c as a helper function
> in preparation for implementing checks for mTHP collapse. While we are
> at it, rename this function to indicate that it is not only used for
> large folio splits.
> 
> No functional changes.
> 
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>

LGTM!

Reviewed-by: Nico Pache (Red Hat) <nico.pache@linux.dev>

-- 
Nico Pache (Red Hat) <nico.pache@linux.dev>

