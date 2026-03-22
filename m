Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 936BEFC72AD
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 12:48:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 901A36B008A; Sun, 22 Mar 2026 08:48:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B27F6B00A8; Sun, 22 Mar 2026 08:48:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EF356B00A9; Sun, 22 Mar 2026 08:48:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6D5566B008A
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 08:48:34 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E64D5140813
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 12:48:33 +0000 (UTC)
X-FDA: 84573677706.12.1379DE4
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2916D18000B
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 12:48:31 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=EqrpDvrt;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of 3HuW_aQkKCD0Zkhbdqxgkfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3HuW_aQkKCD0Zkhbdqxgkfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--aliceryhl.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774183712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qpx8itHUDRTfAnvxzR4PgzdVeXBjt9eZaf3iKVFScbk=;
	b=ced01qU9rKIJFTep4pJaiHtladHXSZAbCkaJXTgFjiu2TlwB/URrnxaJYZBfCGLwgD3bE6
	vGsSj6AWt5UtcVSJE6x99z3SXRrW9yPjDyly/Vhdu4IA6fqOF1WStDH+2kKm29EPYhsdre
	L+erSSAWlOgD8J41vX2t2ZoHo/GPUeQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774183712; a=rsa-sha256;
	cv=none;
	b=toFfMveqUqbX0KbRPX6r+20SqDYidIX07URnKXgTd/00oYn2ZNXuF03ppF6C3DHpyLbhC9
	S3oZQJQ2FOrQt8oP1+gl6g9/iq268TVV1zf8k73oZR2kdsoR/wK3Ou3XHd3DbSAPQ4DRcA
	6vB/djos9HnyC4NUJtgXGavIsKtrqbU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=EqrpDvrt;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of 3HuW_aQkKCD0Zkhbdqxgkfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3HuW_aQkKCD0Zkhbdqxgkfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--aliceryhl.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-486f830f4e4so29200965e9.1
        for <linux-mm@kvack.org>; Sun, 22 Mar 2026 05:48:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774183710; x=1774788510; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qpx8itHUDRTfAnvxzR4PgzdVeXBjt9eZaf3iKVFScbk=;
        b=EqrpDvrtwXArTUSxTnaWcEWddA/+qdmUl58llJBEhMQowQwdKebT6anrfhPa2HQWda
         NSzd3FzpDup+hIf9vRDgzCFikWSAN5DGwAD9G+moz4G/blj2XqBV0bWUzJfiSx3/bBYi
         QaAf34Nh7o8ozytM6V/vamAykJniMReqrKlBBYDgjXi1qCUoE9tVYnHlag6qpLaoasxm
         TVtndFkT+ZG5ONoloMRt8cckk9iM5EHTmdsGkSPdjszRZ+89IDk4/7Ho5P8T9erNHWta
         yAZPlcey32wsWocagkTjiY2KyDvS1q31s8mrQgv8Dka5aHwFpDGkvUPh6BM61W08LSML
         G8DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774183710; x=1774788510;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qpx8itHUDRTfAnvxzR4PgzdVeXBjt9eZaf3iKVFScbk=;
        b=RTC64M6UxrTJv9AncOUK42jGJEU6mzw+WLwSJSehoFSMvEQtGevr8L5BlZrhMbFWZe
         03AK5trNSQxbHjoXZtVwj//32qMclLseiuRSsjQWcPqhUhzGNygIrAf7xmdujplF5uut
         4qr/kyvEwFaXT9fCsJkmYd04nW/Lf3Gm1WmT9boqzqgSHGCMrnklN+HPC590kWKWPL5L
         yM2HIZb74ApGjZCaKdAry1aumBejGlwrrfRWL9N7Y9FSsUqwdnXf6idLSbQyyw+rvwbc
         WsMW7BLUKbc2hYYRCVLdxsDmzcoKRjFuX76Svp0fe49nD6Htu5aP9cwKcuqnCi6+oZYN
         p/fQ==
X-Forwarded-Encrypted: i=1; AJvYcCXywFNh5E35vCMdzDFsoQ9Bt8o84EKuM/ju0ixz/Chalmx9/VwZwgvXq8i98OYUQKD6TMJCOSasIw==@kvack.org
X-Gm-Message-State: AOJu0YxXQo3rlP4mAZQ6g5IZRVNr6oWkcBoZZCE4q2dHCMMvc8OFvyvD
	6xdXqLsOqMd9BZB7Kw+2HQTVP4KatERfznk4Ed/BdsgVFJglVy5OH/7u+Rb1HKRy2VVNU+UqoBG
	x65T18N3TDTAWXQPmZg==
X-Received: from wmma23.prod.google.com ([2002:a05:600c:2257:b0:485:3c21:d5f0])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:a69d:b0:487:288:1198 with SMTP id 5b1f17b1804b1-487028812b5mr62847955e9.22.1774183710349;
 Sun, 22 Mar 2026 05:48:30 -0700 (PDT)
Date: Sun, 22 Mar 2026 12:48:28 +0000
In-Reply-To: <03262674-2df0-40d8-b411-4735c6f43770@zohomail.in>
Mime-Version: 1.0
References: <20260317-vmalloc-shrink-v5-0-bbfbf54c5265@zohomail.in> <03262674-2df0-40d8-b411-4735c6f43770@zohomail.in>
Message-ID: <ab_lHPFszBj6zM67@google.com>
Subject: Re: [PATCH v5 0/3] mm/vmalloc: free unused pages on vrealloc() shrink
From: Alice Ryhl <aliceryhl@google.com>
To: Shivam Kalra <shivamkalra98@zohomail.in>
Cc: Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Danilo Krummrich <dakr@kernel.org>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2916D18000B
X-Stat-Signature: r7pdoyht7tugyny3ajbmdmxm8ysozipf
X-Rspam-User: 
X-HE-Tag: 1774183711-285273
X-HE-Meta: U2FsdGVkX1/rPbkgm3Xr8kb/VY6PMvADdTSzx9q0Wg1cUE1AUrWLWgiVnCfdm9TomPM9MZYAUJcACUh/BlMeiarLceH88dkdEPMlO3/lMLAwSrsF07tEXAVKKgFsrlTGeyg543Pi8AV4ugcHFBbKMFjiY4dafK57+zqBaU/pYf2pw7tyHIV/xK66rb35dq1NVjQBLgTDFg43QkxK7Qq56iSIAF9TOnYlYk7OfKbav9WOGQDAdGCmwIjdGgMxTcYS2Kfk6yf0UQWkZ1MEqjgtZD3vXsnx8LurLsInZJEF0Ge02LikbNp7uzbjBXoRKhEar7Uwi0DGmFi2EUNRy/Xly4QCOpL5oWriH5FgARvgCIEkZRzMYgU8ztc69BuXfaH8xuyhPAshGhQYghoBpswdrSmdxUlZYcQS4tuM75C6u7N5iK3URMv00SCCxbShiKE6Ngx0teBqKqshhYk/gm27NihEcYfqzrOKcinkr+kx1T27ujeV6oGvqv1KHNyGFMIE5SPlyc3ZUOwBeTlUsT1NMksFG7XIMWTOqABFAysm/pNGH92LNbq8zbo5iitb3oi+uEo7Jc5hPESe3fOJKzTbbg4iMRZQ4FyONB5hS0OmuU9GkYrdAX8bl+bxEsiT0s1HegEUnmPW03GCn/HI4qhAGiw15WiUix2tfnxPYSMJSHgPiGQeklFF7frR5I7ujfQkSXhj7DNTEL+YnPHDpXLW7ZvtJ9/k9qDCXVwGR59IWSmfziJI3kJMouwfuWjUDdIgK8r3eHjEVKDz91b89Rou1xgSfTCtSHR63F3CHfa/nqbGeKLwUcIdetyDQX9JZx5W7FZNkUTBMjgYxpOLJoBABrG8eqbzJTxVq7+HttaEykEgJrTlGwpuRXqJUKaqx5aRAgfxpjZ+AdMYYR7UHjD+ZmXVd+iCoXAwoallg6L0DcQ/mvPqenfNV3Qx340HohwwgrLQAsK256RKjziXMw0
 uADwXQ0H
 1NQ6bnM1uxDXuM4agm4uLin8jOt5IGlMmuclC1B16vc764/o6L8uCbpcSqUs4AwaN6AcMi33XuumwAeAgvLDlDOM718WoRN260zmPpZChvUK0wHITWMMUvpRdYd0mn7Aqn03+tunh4j8wFnqX+v0OJYOUM3Sv41zT6PFdiwZxt8akSBElFtYvktvJuhV5Sl5D9nJ/fORugqscZFdTe2fbDvoEIazXqLod3Nsp9CsW3fM/CaSLO8HtK5uI4s73yYTwhirkbjnp7ZF/UkPvK9jukZ5ErdI7TxUn+l/zoxM6MqgAeQLEEgipVTzDjF9HDzoVeWwXS64YAeO0Sn6uOcEizIo3QnSfeX+jxI4vR5BwxkuT0UaLu5enmRXu7gOJzuj3FHRTIPSLgy17UZe0GDH6ORHriCq3viUzoTIxgJ3i0c1PuMvCo0lBZplGrc9D1xfbsojhmSCjAvRNT3sFKknyGqx9T1XVz8OU4TnttiBb5ACvwBt9mGSrYEnxY9DW7UdpblWw5CgcTs0CcL0Pb4ZXyMnV4eJ/JxYXwGnodAWW+xYcttVnDoI9IW1WJWeV1EjLhuOHTgNQm5P6+MA4c3VYXpSVZOzQeKAic1oO0LX8FsPjK0U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Mar 21, 2026 at 01:45:35PM +0530, Shivam Kalra wrote:
> On 17/03/26 13:47, Shivam Kalra via B4 Relay wrote:
> 3. Fixing a /proc/vmallocinfo race condition
> `show_numa_info()` iterates over `v->nr_pages`. During a shrink,
> modifying `nr_pages` and NULL-ing out the page pointers concurrently
> could cause a reader to dereference a NULL page pointer.
> Plan: I'll update the reader to use `READ_ONCE(v->nr_pages)`, and have
> the shrink path do a `WRITE_ONCE(vm->nr_pages, new_nr_pages)` before
> freeing the pages. This guarantees that concurrent readers either see
> the old count with valid pages or the new, smaller count.

This doesn't fix the race. Consider this:

nr < vm->nr_pages == true
		vm->nr_pages = nr
		free vm->pages[nr]
page_to_nid(v->pages[nr]) // UAF

perhaps changing vm->nr_pages should happen under the vn->busy.lock
spinlock? show_numa_info() is called under that lock too.

Alice

