Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C653FC55164
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 16:16:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C8F16B0088; Thu, 30 Jul 2026 12:16:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 579D76B008A; Thu, 30 Jul 2026 12:16:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 490106B008C; Thu, 30 Jul 2026 12:16:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 245F26B0088
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 12:16:03 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8C1C7801CD
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 16:16:02 +0000 (UTC)
X-FDA: 85045944564.29.C982E95
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id CEFE6140008
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 16:16:00 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=TS8leGBx;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785428160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v4U8SW0YxWrww9IDw6fuGEu6zQ2HQAvAF1fb2z+mrWg=;
	b=uDmCjTx6ZVukPI526+2jBzegCZabdLfhDdptv7SgQycyD4UwhjHK39wwHkBdBJ3utIIhdN
	vEDHtPsYgEAULR8hDp1e/9UqmkwLqpr4qu5Cf+3MDVrX5WToCY24Fq0PgTTV0BbqtAbpfZ
	W6U17qevKsUdgGmv05ZzBFpi1LAbVLg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785428161;
	b=BiK9WH8RbQGCbvBa6lSRiscv9sWli8G5POC9qAOXZOHj46YlTUsyXNh0i/iUuYjVcwUb7y
	jCw4fLDa3qJzkNO8w+Gl+WaQklftMeT1KbUK1DEPIgvvePQjHRnLhZrs871+M3tHPY7bEj
	KlnXhvT83MeUizNLRgMScsVPM24Kutk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=TS8leGBx;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1FF6360A5A;
	Thu, 30 Jul 2026 16:16:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EB0D1F00ACF;
	Thu, 30 Jul 2026 16:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785428159;
	bh=v4U8SW0YxWrww9IDw6fuGEu6zQ2HQAvAF1fb2z+mrWg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=TS8leGBxEjN+OzJUFZz4SdEsyN4Xv4yZ1kByZqOl+cGkTUgTGz2XHpBPfiQCe99UM
	 Z+UlPp38Ws337aMaKUG2Ki0Pry/RvXWCMEDX0mgCSDMeWEke7N8C197/uLcM8N+akC
	 hKT+yjGkR63d7kkqqWlOPXcQioGfAT7t+xoLidLg=
Date: Thu, 30 Jul 2026 09:15:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Avi Weiss <thnkslprpt@gmail.com>, David Hildenbrand <david@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Soheil Hassas Yeganeh
 <soheil@google.com>, Arjun Roy <arjunroy@google.com>, Eric Dumazet
 <edumazet@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: return -ENOMEM for page-table allocation failure in
 insert_pages()
Message-Id: <20260730091558.12e3d9029002c87c1f00b4aa@linux-foundation.org>
In-Reply-To: <amr9zoSncZguF_uu@lucifer>
References: <20260730071323.964321-1-thnkslprpt@gmail.com>
	<amr9zoSncZguF_uu@lucifer>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CEFE6140008
X-Stat-Signature: 4ppaxfjh17tc5dfryj1uyxe5gtepng9c
X-Rspam-User: 
X-HE-Tag: 1785428160-646805
X-HE-Meta: U2FsdGVkX1/tpBhNlzAFEhxIE1B7a2wjqTqDMc7Um5c7rrf57261iHpdNCgz1D3BpnNw7OFOoXCAYkB7OGyUwtDUZ/mJcCK1skaoOxpUgsJpisjVhUYDp46kZayAp0jEtoz49utTr9yZB6qEx2JhfN4BPK8PeAP6Or9qgqSjThzU3viVzVvCRW+OIRZYS2fZtSR/hzX9ytJh063HZ2pVuiKHu0/GBLQtl7pjM9NO+agBTBSHn196MfegqK0oiiXBHpw7eGKRESJ24yS/9v3bUCIlCOjU68X/OB6GloKjGVmXdlOw10amx/6XVBBqhdctxcsuHdFR4hAvv3FuP8djHjfDUhToEhctonY1sduL8Eyn8pOsNlhIvh40fm+jYAabJY/KRmYFrUHXwbiLHDZCHWPGnaH8WKjJf3/j4KcwJX3osHkUEsbGnYWOFWo7y33WI1aNjUkI7quVWk2+dutzUXlcGL+3BeBD5kDlD5LoyCymzSwUGtTMMvE6Bu3TcLvCbFu3Uwvr9AWRPtvDueCw2MfhsSAs9zzWc9rHtVpmriCT+NxJmCVwfC5csN9wI9+wMwEG+vEUw9qtUjt2uLVkIiivcsa6N/ZqV5BzewCgxWVPIKkm/r9/6yPfgRsSwElLXy6X1hvZGrPN0JcJxFwZzejpgrSvl13jm0ylDXeDSvFKysXrE+i5481IofQsle8ddSdzHehtdJjnEIBREb0gNhUmi2ybqGU2ugne8II/BQ6PrXPRy+f5Ai9N2/JE3ieu07Ys6lGxW+qMzlwp9pMXZi0f9fDoRV4Sze/Uc8XGzBdkUfCstkaHCNpDNkClUHiyN7+7IIOx0/bV9/pWD1wTaqITmeWIEmBH+wcAre4nsW8HY6/qk/n91U40mrQudSXNhZ+eBrm6H+/DGqIzXrmwWeIygNqbVpk2KXY8JNoapdswtODQ3d7ic1hqcb77NFVwGf+D/V3BdKzVCy9d9kw
 Ny8VLhRx
 DI9je2TH6eZbypKoKqnC2SjNcdqQH9uwloZyEFKEww70yIfxk3+cncb84MLzcgVIXs9GsDL9Kepkjxd/KaVVIrL1oROw1+eTvehDeIe1DEFjFgb2Vu251jEXwAmy5BqjlbVeBSvckkIknpB+jaWXK2vs0k5PqRLuLs0dioLjbqZm+8WFv9RhydUEbvXk4pqhNLHnt+RF3FpQnQ3Q9GpCIOHs5HtCvr+d+kNvlnDBA0FeN4/0y0h69zYhpzQz66Rol84Du/ByMlqdphqxLg7VOsuhgSM/qcX0kSKxDwD7iHQ5Cn8JaWnEN+mzlH9npAzpnn7en
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 30 Jul 2026 08:42:49 +0100 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:

> 	pages_to_write_in_pmd = min_t(unsigned long,
> 		remaining_pages_total, PTRS_PER_PTE - pte_index(addr));
> 
> 	/* Allocate the PTE if necessary; takes PMD lock once only. */
> 	ret = -ENOMEM; <------------------------------ set it again?
> 	if (pte_alloc(mm, pmd))
> 		goto out;
> 
> The way this function is written is horrible in general, I hate 'preset default
> return value' as a pattern.

It used to be the preferred way because 

	ret = -ENOMEM;
	if (expr)
		goto out;

generated slightly better code than

	if (expr) {
		ret = -ENOMEM;
		goto out;
	}

Whether that is the case with current compilers I don't know.

