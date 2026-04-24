Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1549FFED3CB
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 13:28:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AA356B00A6; Fri, 24 Apr 2026 09:28:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55B286B00A7; Fri, 24 Apr 2026 09:28:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 471626B00AC; Fri, 24 Apr 2026 09:28:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2FF926B00A6
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 09:28:50 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D2A071A0117
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 13:28:49 +0000 (UTC)
X-FDA: 84693529578.02.394CD37
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 040344001A
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 13:28:47 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=KGGRP124;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777037328;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qsWK+TjyndiLJrM/1Ax0rEy6rcy2Ueeghe9fP4d/LoM=;
	b=CgeWLgfftTkjRBC+BdfosgJK2xsA9WRa5xCgIHU3xcgRjYqxZay6vNQo87SZo8Jv2izWIz
	go/EtkSzxpbuofvqWmdJwMU4w3+cXW2/SnlFrKXn0AjtkaHA2WYcBBk8CW5NPBrZclcmiC
	ChOmaVEbkpuJILLrTlKyrKBysNaTsF4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=KGGRP124;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777037328; a=rsa-sha256;
	cv=none;
	b=Z9VO8ajOdsPqrVdxg/UGo8wFZ5RYUPXAkbxXS3Lpbx6Mkk3N/Y4AVEhrnvKj79GA8s2rIN
	/Hv3gVXg6YPsPM+SlN1DH5gux1WliKZszLOE14cSuidoY/cYUoteroR1BNqvceW1no5lPx
	adhK5LaKCZwLh3scztrnqu7d5QXiFzM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D4A22416BE;
	Fri, 24 Apr 2026 13:28:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23438C19425;
	Fri, 24 Apr 2026 13:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777037326;
	bh=IhfgqdqsMepvSbnRCEvYdIExQH0XA0VhU82KOe48pfw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=KGGRP124jq93G6t3s0LoBErg/++C25uWv3WaS28c2d0dr5EjZRdlcn9rJmIVD7sS6
	 1dR/yjWyOG34MN9YAW26tHjJ/ff7TDLMAHmqoCKOwecvaobKO9MkU//t5h0X437qCS
	 KlPDQXKOfqBYKs6oJfrZ35BbV3cC6/mWvwlDk75c=
Date: Fri, 24 Apr 2026 06:28:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Breno Leitao <leitao@debian.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan
 <skhan@linuxfoundation.org>, David Hildenbrand <david@kernel.org>, Lorenzo
 Stoakes <ljs@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah
 Khan <shuah@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
 kernel-team@meta.com
Subject: Re: [PATCH v5 0/4] mm/memory-failure: add panic option for
 unrecoverable pages
Message-Id: <20260424062845.fd3d9acd12489f15bec7e72f@linux-foundation.org>
In-Reply-To: <20260424-ecc_panic-v5-0-a35f4b50425c@debian.org>
References: <20260424-ecc_panic-v5-0-a35f4b50425c@debian.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 040344001A
X-Stat-Signature: xen5jrrcm5sf8xyodjkpdt16od58q87i
X-HE-Tag: 1777037327-89424
X-HE-Meta: U2FsdGVkX1+81x2Xi9ddtqQ29PQ7BzxLQF+rvgXvfDX/P+h+kETOjQRar86lmTG1HN150E58GEcR7+yi9BfZrR5TmdkBKpVCYs/XqSdhWYaKys13Gudk+Nxfj5qhj168Xax1uSp/1Wko9eRPoJ4SroA22JUlu3AhZV9chFRjrr6hfyK7E6m/N/CQKdGMX3R91DykczJQkRvAEt9adyJSDxgk53YHgGeD6JMfJpFoQEskv5WpC1ucmIvAAjcza61HTMGStlLmn90YDusbQQcIgrJxLkmS+i0oPGjAwUZfou8LYCMIIGkRypl6ohJZd+dl/+cbU9IlnFyr3ZHRVdKHYKznIovsgHH19m+V5Bbciw6SETlSucBXR7zhFp1GcmypoWzZ87loBV51gDzqGGyD8iPWCu5uXOmSgpc9PSDsX7Vl5NF+ELTGkTrrFoLXOxAcz1LfaJFKj63uLvnGes3gC4rKmSWYRLDaNRc1NZh8GsVcRY5v/vY8vmXaWz58ZJj6yDi3PpB1+ESphlTbP6jSFS7wbR4OLR2Evd7jvmlH2LZh/AtIQgtQ1treAJCmgf5hqpl2iSUzpXrGjjxaf5Ftxe74KsKZLhm+LcxJxCVc3yHNHwbgq47u3Ipb+aSn8iC7NHbUwJKHdMao/n75mqtZ0208X1mOm4V4wI4F8SbkHWjSPkC4WXzhNttdM1vkMoD0KxBl6dWJRFjtQYFkKF5v0FhcO0HtKD/WSXWyLIQ8Kujtqm23aBnwxWbeyNG7QrIIYVoUWWjaJ9VkkUnTgoXvwjrwTwDQrUp18UMPGDx97UGmk5HHEmh9sclv1sBJqJm9dbGsWGQAu/3Dm0f/uJ2QkOohC5A/D/5AVYbvv7gw1x/P2cfN06ICPz8xrc/IK3C+hQ1wnlEmU6kkBuT3zjiHysol1aYGtoBl1GQc4+r2PsDlD8KofEmwz98jzF3vDjTx8QriVMqHDfdaJdkgG3g
 31KFOfm6
 7w/n/KkiEc3H3gY8mLeCHMqZzJ/oCJvg22bwfChQ2tz/INagsqwtu1P9yXSI3KtUWbEN+WIp7do9qLF0r7qHp1/6mBVTkl7oQSvyrBWKvqPvTGgzkOfQpLbUXN1X3aOXuVdA72RB7qzUjcGpeLoToL/2abjALJ97DpFLLfW2MovAoGppx75L+FJoXOnzDkNQxkOrqn37sYjzn62YCpxuCGb5PP/HX0M4upBWvizMls9dheKV7IBQEDGROB/XVGwHrKoPN2U6JaDGy7uQqfUwTC3EefOkeb+/xIGWen63kRyX1NBlus1UnbZCW5W6eF7bnvQUc7RhmpGtfWc9I2sbBb6bVP9YgH/1j5D893Le4BzU9+3YvX+HTLZ6eRMoP+PBSnonItlw4UMrKP7IzIGmDXudJDw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 24 Apr 2026 05:23:58 -0700 Breno Leitao <leitao@debian.org> wrote:

> When the memory failure handler encounters an in-use kernel page that it
> cannot recover (slab, page tables, kernel stacks, vmalloc, etc.), it
> currently logs the error as "Ignored" and continues operation.
> 
> This leaves corrupted data accessible to the kernel, which will inevitably
> cause either silent data corruption or a delayed crash when the poisoned memory
> is next accessed.
> 
> This is a common problem on large fleets. We frequently observe multi-bit ECC
> errors hitting kernel slab pages, where memory_failure() fails to recover them
> and the system crashes later at an unrelated code path, making root cause
> analysis unnecessarily difficult.
> 
> Here is one specific example from production on an arm64 server: a multi-bit
> ECC error hit a dentry cache slab page, memory_failure() failed to recover it
> (slab pages are not supported by the hwpoison recovery mechanism), and 67
> seconds later d_lookup() accessed the poisoned cache line causing
> a synchronous external abort:
> 
>     [88690.479680] [Hardware Error]: error_type: 3, multi-bit ECC
>     [88690.498473] Memory failure: 0x40272d: unhandlable page.
>     [88690.498619] Memory failure: 0x40272d: recovery action for
>                    get hwpoison page: Ignored
>     ...
>     [88757.847126] Internal error: synchronous external abort:
>                    0000000096000410 [#1] SMP
>     [88758.061075] pc : d_lookup+0x5c/0x220
> 
> This series adds a new sysctl vm.panic_on_unrecoverable_memory_failure
> (default 0) that, when enabled, panics immediately on unrecoverable
> memory failures. This provides a clean crash dump at the time of the
> error, which is far more useful for diagnosis than a random crash later
> at an unrelated code path.

Sashiko is asking things:
	https://sashiko.dev/#/patchset/20260424-ecc_panic-v5-0-a35f4b50425c@debian.org

