Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D3ACD35165
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 16:33:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD5986B0088; Wed,  1 Apr 2026 12:33:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B86A16B0089; Wed,  1 Apr 2026 12:33:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9C156B008C; Wed,  1 Apr 2026 12:33:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9CCC66B0088
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 12:33:12 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 66001C9EC3
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 16:33:12 +0000 (UTC)
X-FDA: 84610531824.22.34A1BD3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 95A761C0009
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 16:33:10 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=XCm5TfGB;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775061190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cuuGLb+FVGiJ4+TSCbWyR4/81SD+C0auGpzNvzlRxg0=;
	b=7xeCgXU42e9S5dP5Te25AU5J3XIqXddjqSgDAgY+xXIVsKh+OmlowALXop8aKXDgdbymlH
	u0VpPATF9EL+k/wqiaIlCcOOJyZMtpAEVn1J/YcGRV9Pn4PRextNe6DW/X1KNpwzLNzK7H
	J3k2IVRPteVn96FmyXi3aQF4obuk30Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775061190; a=rsa-sha256;
	cv=none;
	b=jHQdG0TUEzWCq0aNl14RRiAmRTCHTsObCX6xTC3sQ+y+zyaWlOZkRB5gpZCCuE9CPJYvrT
	ZyfK/36BJS9zvp241YYBkuHBRTwvaIy1aRck7Qt9CIKWA+4Rmx9mMcaqxWn5qs6Ky/Dkp9
	4ytuav+fNMLZ29tH/Iel+uGNNwXS0vc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=XCm5TfGB;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 32A1B400FB;
	Wed,  1 Apr 2026 16:33:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE62AC4CEF7;
	Wed,  1 Apr 2026 16:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775061189;
	bh=CpXR9nt9c61PJDkkfpO3xexyQRNDtnOTUDGrui1/Y8o=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=XCm5TfGBy7rnkeVLgFrdJCNBCDZg1lntmtS0oVLe0ooeGPi8CBputtc1a3r8juteK
	 JmwIfDylvBzApJmjtdB6iWKFGJJQSST3qj4Ot4adg/1p6bjJwjst2OZdEuHl6U+YHS
	 CazdhFqSv09CkA75lBwQVW8oXI3TB1yhfqm1zrYE=
Date: Wed, 1 Apr 2026 09:33:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>, Muchun Song
 <songmuchun@bytedance.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Petr Tesarik
 <ptesarik@suse.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/sparse: fix BUILD_BUG_ON check for section map
 alignment
Message-Id: <20260401093308.6fe32f4de4bc15ee6495fa68@linux-foundation.org>
In-Reply-To: <1f8d0cd2-c990-4597-bf47-5a8217acc464@kernel.org>
References: <20260331113023.2068075-1-songmuchun@bytedance.com>
	<32789381-f860-4b60-a1e1-4c97f6ed08b1@kernel.org>
	<7C90E910-D229-4F60-A62D-E893A89D58F2@linux.dev>
	<1742503A-F912-4AB6-AAF6-6CDB06829024@linux.dev>
	<9fddd112-e304-4ce1-b3f0-a4b133fcb281@kernel.org>
	<EAD7BE29-7136-4A20-9CF8-1198EFB8C87D@linux.dev>
	<1f8d0cd2-c990-4597-bf47-5a8217acc464@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 95A761C0009
X-Stat-Signature: uew1ifpdifkjjk5i3ha8trkwywm9hhfo
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775061190-990699
X-HE-Meta: U2FsdGVkX18/hEMc1BTnr7k2u5GtGWTFJllroU31QeD7eekKMMWez+7pBFeh26LlcoiLm8v6I7/cgX/kMJ64U2q2ffxxq2UDcJWkQImWebhNiS1SEj+ZIi59BrBZodPzAltp8Mu9L0ntuqIqMfUvGuMQRSRNjHJnqVc9tn9Fn0F5KDRgBqhZ4f25tt4WtTRbpvfF83I4KecsHIqxgyI+S0tQfbX9u0gg30Tdbk9DoLzJILubuZ2sZC9zMAcJgvLPwGZ5UoQAJaMP0V1OpipD3sdnxmLu4zLen1nwgLZl4C1hRykg4lWpGqFsBgsbnqCvswhrlhvD0nBhThMGqPErd4hy8XJlT6+JGKiA8YT6del9ExZvKVbDxJs6mDNfQJDT6eiFmR7BjQwjHxTN/S0fr4Oz/qz2HYzKWooUWeM/QdFCug/jo/BQ5nkJ5eyVGdNdc2OKauxve+1b6gO9UZw2++dIZSYY8tkmQLNIiTlLKPOc4YQi59WGxpx7Z7cX4XB9vTgzhlzP8w744wPyBy7bvXAekcRtVq3AOEgk94iJ8X5i8EULy+yZZe0GycQ+qM0oF4rFI68x8rHaz5JOslrkaxuSd/MpecmiYd6ZI+cQexQuePyiM+CALyOY7dUtXrVM5CVAIfdUFxmuX6yQwidk6likXBl8cKDI9D2iUJdl3hmr4/ItUm4NlXEPX9/TNIsfHsxriCHioorHUGuReMuYSqTZvxGS9l4e3QBwPPjGo99Jr2rPGATBX4woeVdQLfE8fTyWg0mXMXIbU6twYPFGs6bh825eaiUPzkLRyOgAKJKZuuuQZHje4ZHWWhSZel58S8fwRPrWO03M0+odljpBIDpfZV5Xc2VnqjA3t5qtv89RmsaNhA/rXBotTGGtB2pPaa1YuWYZPUnsVQQUJ6OdbaKKxp55D3mG2HMdIzwEKcZ+ahmUCCho8S6f0rxOpv8Ifb+qLfZSUZyMU0/dbLW
 wwWKXYtU
 tR2tGCEkzPYSp6a07NYWBF34vAd54xzB1yAoDtcK9puV8a++6pE8E1hVvnxIBAZS8uLOoJTRNtfEGUSs4Wc/gHCgjqHTXDMZmgEL+dg7r2hYSO5rlRuQIezjOEY+/6JmmqyxiA1VqLeMpabJWIwrq0ujBNP2+1pxjSUfCRArHzGuJZmwcEfn0QaPy+kQJLT18lghFM3ly7sZoB17mY1kHudE0vfGnW2rc+BiXMq9Lx4eugiH4H9vEDxmkZlhxS/crUR2RHgKpVuz/5JOC09xS7yLJKYYn0g6666VlYjLmMQnLqe7i8LD2bbQV8jEvSRKJDrzOuzrBMTqTSurrDEEMs7pJug==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 1 Apr 2026 09:26:49 +0200 "David Hildenbrand (Arm)" <david@kernel.org> wrote:

> > My original motivation was simply that when I read this part of the code,
> > the comment felt a bit off to me, so I just fixed it casually. But if it
> > ends up creating the impression that "we might be supporting something
> > we don't," as you said, then I'm fine with dropping this patch.
> 
> Can you rework your patch to only simplify the comment, and to clarify
> that we always expect a single section to cover full pages?

And to fix the sh4-allnoconfig build breakage ;)

https://lkml.kernel.org/r/202604011400.OFLcOOmf-lkp@intel.com

I'll disappear this patch.

