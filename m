Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87C29FED3C9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 13:58:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB07F6B0098; Fri, 24 Apr 2026 09:58:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E617B6B009D; Fri, 24 Apr 2026 09:58:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D76F66B00A4; Fri, 24 Apr 2026 09:58:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C6E396B0098
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 09:58:33 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 633871C0061
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 13:58:33 +0000 (UTC)
X-FDA: 84693604506.11.C8BACB4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9CB84100003
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 13:58:31 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Xvi5Gf8h;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777039111; a=rsa-sha256;
	cv=none;
	b=ZZBwmH8L38+3TV9hXLAf02AyuFivlJ1sdtzBacbrql4ZROyn8QOZM5PWbqeZvYRej1RF1n
	wZP9jRLivq1oQv8ph1e/LbfnFB/u5IYgk60jsmWvjLJ2CSHxLpkKBjxLceeWLdgXy0+TTI
	91UsLE/yJ0XiQM3c4QFkUkZ2NzW/9fI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Xvi5Gf8h;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777039111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IbE810U9umlb22xp0VvXTCRRR6Jr4Q+hl2Gco/ki9X4=;
	b=vv6pAfaBLzrVMvzq7Byv8gOFEWX/MHFnW7yscJAGZu3k4h/5NSYCbDfo6LN1VkCH+C5JZ8
	ikbLRVNEC0vlFRzsYJ2ZX5hj7xYStH24XPEONfRN8mhpBr7iPDNLvYYf+Tm3QLKYx5deTp
	+Ew7NHf3ddsA1uGajjExnDOnwWe0GVU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A3E5743949;
	Fri, 24 Apr 2026 13:58:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C889FC19425;
	Fri, 24 Apr 2026 13:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777039110;
	bh=7bYInwWM/h/4FMogzkF1bwJ652LCJHGiLjOkNtEaby0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Xvi5Gf8hVFpC//5R97FD88BNYz+MVhLRmFvxc2exXUXhHSYrE47STNlM4pTLte5C2
	 4Y2JwJd0HTqYkBYWh7rT3liPSPKqyF9JVXR1PIXqxRe65zpj4AU+LVVVYIJolPxKQY
	 HpFryOs/E9bEWySudkVDCIHCe+HL4B9dEhazWpiI=
Date: Fri, 24 Apr 2026 06:58:28 -0700
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
 Liam.Howlett@oracle.com, ljs@kernel.org, mathieu.desnoyers@efficios.com,
 matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com,
 peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com,
 rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com,
 rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com,
 shivankg@amd.com, sunnanyong@huawei.com, surenb@google.com,
 thomas.hellstrom@linux.intel.com, tiwai@suse.de, usamaarif642@gmail.com,
 vbabka@suse.cz, vishal.moola@gmail.com, wangkefeng.wang@huawei.com,
 will@kernel.org, willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
Subject: Re: [PATCH 7.2 v16 00/13] khugepaged: mTHP support
Message-Id: <20260424065828.031775921990de37f83a2468@linux-foundation.org>
In-Reply-To: <20260419185750.260784-1-npache@redhat.com>
References: <20260419185750.260784-1-npache@redhat.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Stat-Signature: azt51qjeacbtgf8xoagnitbu9sb5q3bg
X-Rspam-User: 
X-Rspamd-Queue-Id: 9CB84100003
X-HE-Tag: 1777039111-691580
X-HE-Meta: U2FsdGVkX19vQwkB2CJJBZCMu0ZoEdDCxSjYFAOOpbIdRw3OXQA8sTvR9EN8ZsAOB+E0sxCwGhyrrnn8/efelQQz5jJE0xiLNa0pzzXsgurE7jbpLsIC24Ud4W8xdGK8sEjNm4QkAyJ7ixcwnTfRnw2j5p+vlJd+2f93AMkdSiX1S4/ZKilJlSTiIVjXCeFJhyGKMYCDVEdb9dpzxJ7aFvBgXw13ECHtQqPrsIwLQLET2Xl0c5P0f67LLMi6khm6qED6Rjy2pZzQEVVX/oQBE9YHuL9Y2GZ+N6916yLDTwYW3fdJtAnfLbdx+PiB+xkM+iVVxdO0xR8W+ENmZk8psPsPS0Nm7mHNDbbDFPGwbnCbTDc675HRmvzm9HecafcrZHnc/D9U5hNuA3g4ZeegDp9hEOw0VsSzFL5Kbywhrl4k7uP+Od3MPvFWXdDvs8cLHEL3pNY9jtH8TCIlBceBlUJc6cnycAcY8F3qormpaly2mXzuY32GLmiDt9JfymuvjqhSMxZySRiBvTqYuqheWI2NJIOIXYNlgKyj10cGu9Nw6wfgiokPiGUvbteD9g2NxXJ5KXTYv3hYwQEUdifKPWOTE8QVuWCYVRCFBGYbDLplmhRwmgiHyZi71ng6gS+AfSthEm3MEq28md13V+Q0c07HTnqcRKr0TCG/G2n7l6dID3W8WNNzscl/WcwCnfd/c7GqfRwNUuX3FnKPH+vUbZWlANoMGvxIymAnbCrF8JVp7tHbevDoFeqXmLOQyaeeyOZaxeSDqUe95swLKN+xVN0c4ki9o5WtCT5p0xqaUq/dR/6L3pA2dWhna/sN8V/hqv1HIm5aGi7x+nITx3nonuljBDaxccvx6jpBwv6Oeeuckh+PQN6CPNan4/Mpk/OWWcpqrdgUAyGkT+SPXxDcXnVwq+ot0ywpWJgtSRhZRmq9j+WXzOT3UWA+C4OC2FHeJOuuyxv+ymipM29/+jI
 nQ5cOmol
 mtOBnU90CrSJ+7o3P+Ud6eaDdhz//po0E9P5WQ6pdmIPBDeJEJ1P/eNXGHjw86gyUZFIxQOIwBvebUl+JUWKDK+YPq6LPU77/Riq+Pidk0+W9w/Yl4+bBJmb41IBefqL3reboq1lp4NfO5tgneOdfd9ATlzHOqexKxF1BRjxIU7DOQT+p6iEsN9y77mpYxfDwFo8khr8EdyzPK2IX3zEOZ5n5YiHgwKB2OM31Iq2PmsnMTaSyX3+GnQ5Ar1zmBOZIDtVKC1OayiDCEcjm0SYso9D/mHokdy2uWsT+0NldD0BzPjdVqHm+oLi+aROplAlXbJ/KjZhaXUAdIVC0JOMQiJ3h4Ph6Ks+7qT0EdHgbbBUBaQNLlobPgKxZWpQsbE5V6+pbqAChTiWpBq7IQdUixXjQqA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 19 Apr 2026 12:57:37 -0600 Nico Pache <npache@redhat.com> wrote:

> The following series provides khugepaged with the capability to collapse
> anonymous memory regions to mTHPs.

Lots of stuff here:
	https://sashiko.dev/#/patchset/20260419185750.260784-1-npache@redhat.com

It's going to take some time.  Hopefully worthwhile.

As always, it's useful to hear about the usefulness of the AI review.

