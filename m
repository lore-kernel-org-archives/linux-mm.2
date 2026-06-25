Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C182ECDB47C
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 02:38:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89FC16B0088; Wed, 24 Jun 2026 22:38:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 851336B008A; Wed, 24 Jun 2026 22:38:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7692E6B0092; Wed, 24 Jun 2026 22:38:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 51F3F6B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 22:38:56 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BF9F61C5F53
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 02:38:55 +0000 (UTC)
X-FDA: 84916877430.16.C46A420
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 046D720009
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 02:38:53 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ni8ZUZgt;
	spf=pass (imf31.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782355134;
	b=mZ5VxvGfa/02yUn5ALvbOWUKDCShHKl24Jgut07F+JGUZVipwmZBE8R0AZ/THgeLu7DKne
	KkoO+pKcmeQ6f7930gY7zB8rSOAr6jZKatpqVRDeOaXDOUa3IKiybsK/2QLxZ1s5TEiJIA
	6R68XLFb1RLj61onfhBVJDmc7IHptyY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782355134;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E9YM8JWT/zV0dxkBylVBLEp6uyn1ZqPHz+BwASfANyM=;
	b=LzXemJZSIJ0N4HwpjUu+QM69nrdblJ/IcwvgTW2T8NFCw0NjAOG42INNH1fmwqD45h6zHZ
	BCeNIeGhYZxf0b9qWJ3CqzUzzFLHWXOEXVG6+BK27I+kof5lQGF3WkOPMiUlcyn0pSjjFc
	wLKxPpQ8CnagM2BRq6xWI3/U/Q7IA+g=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ni8ZUZgt;
	spf=pass (imf31.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 863AA60018;
	Thu, 25 Jun 2026 02:38:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5E9D1F000E9;
	Thu, 25 Jun 2026 02:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782355133;
	bh=E9YM8JWT/zV0dxkBylVBLEp6uyn1ZqPHz+BwASfANyM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ni8ZUZgt5tHbZ0pc9+RsSx30MPL0gODbCqF/so7MkjjjkryrP59rNFCxj5ZANDb1O
	 rnywv/3NlMpDO7w5x8EtKtfDfw0zs+RbYWY9Iwz5JbD15hkNQrX7+uevPxLzaBkiFK
	 HUPWLZSa44GnlCZ/U6sqYqJKqMcriX4IthM9ox4o=
Date: Wed, 24 Jun 2026 19:38:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Pedro Falcato <pfalcato@suse.de>, "David Hildenbrand (Arm)"
 <david@kernel.org>, Zi Yan <ziy@nvidia.com>, "Liam R. Howlett"
 <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka
 <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 <linux-mm@kvack.org>
Subject: Re: [PATCH v2 1/4] mm: mincore: use walk_page_range_vma() in
 do_mincore()
Message-Id: <20260624193852.2a1ac8a187978e4baa75f47e@linux-foundation.org>
In-Reply-To: <e7244b54-d794-4e46-88e7-69204da2b60d@huawei.com>
References: <20260618092845.3905740-1-wangkefeng.wang@huawei.com>
	<20260618092845.3905740-2-wangkefeng.wang@huawei.com>
	<ajPZlxq5z1hyo1kE@pedro-suse>
	<42e167b2-5676-45fd-8f3a-738d2f4f6623@huawei.com>
	<ajP9bQhmvR9OX0VE@pedro-suse>
	<e7244b54-d794-4e46-88e7-69204da2b60d@huawei.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 046D720009
X-Stat-Signature: i84hrewqu3ugss7x8sm8efum1rnc4fi7
X-HE-Tag: 1782355133-629224
X-HE-Meta: U2FsdGVkX19TpEaUFFTOyGpNWuo6SRkAHfz+gWyY7nEW8IYrOLIPpawcf0tCLDcw52yvQRH1hzeTHr1/7PaqvTZE5BJTBhxJjUNo3wZE0fbAIat9rBIPfA4lfqKP9kcdo/YlqbF3oONAsjSa2sd528ryRPqQMiZgLnsZ3zqIsAvPHTHN/KN7l3LkEgSEwFechejMSxNbKnPssKPLWQnK8eHJ6meDI8AwtT5eFOWJwtJYxO5M0CBnWTMQ7x7/3JLauCg5Kp8U71fAKJwF4gDJx0H2ZDX1J8hedL3mdJUxcpc9fQ8pJJw/w3qPXWu0ySVD/sn6b4B+I1ohgd2zPByRv4nrFimvPYXwnshQ7EimWpB+Yf0V6hNVPVTxDldFbotFS/Pam4YG3nXPE4FZ01fP1cfE8zFj/zDJ+gVPmLP0PexR4OlT8V9/1GIInkUbSmreLPxfdrhiWejeItrXEzU23BohCac4Y3/3iRiLqbSKZ3DxYSjsmh1pS9oYimhjNiXQv/RrkDHmNsjogK/ahz5l65yM1WqMK7MTPLkrZrH5yZPbwh6n0ZRob7izFjc4lCsPYEHxNooswK0Ib1LHEs/l7ff206gMWysBW0tcOu9HAVbMXpNHEM5FkmIBFNcSgmyYz/ADdSwpLZCbd1bnel0dhpYCyCbCcDzynmwTdM8ea6D56cCeZvqhG9IQQFbeVSVrLTfdTcDvdEg0fpjoUQAaaMXgg92xxbS7lgpJdZ75C2E1LE9fhlQPWQ3ZaQ5GaEMOqua0KCoeYL6SFd308SEp4m80q/t0jCqkvM0Jd7MGSKeWf4cOg9PaaZr67D+PgFI02cWJl34r7hKfQYsvsIuuCsQpnVoVvCJgKv8r+FYUg/B9n4ZFGf1tY0rovu/CdY0D2xb3oB6YOl8gm+fm0FheiEIIYSnjbbfKWPaDnNh+y8grtRqBQ9EGCporQ89e1bmOVpDGdvvCTDJQ1Csjl7o
 lFPdIQbG
 joPa95KTKqfTA++olU1uo9wGhpHd768Wq7QwtmysbICA/nL2srjSLEIPPHW6e/oR51cHlVbf2QF046OorERQLQI0lYmJXRVXUd3veYzPyhjzBhaRueuSS5wtDw6z8YDp9ehKOjX4tPed3DX8sc7n9GGh2OpRqHNhSCLbXFQlQaaJq/fkcHteNdD7TOum27C7OZWf5FBEEOx06eS/rBBeifaGLd8RXH8XMGKzA0VKVKeuXcyFyUYWXEeW9eRFuUGzssxeZcon8kCiJZ2RIMcOGyLFlVKMMhjfx+VFW8KCTKv9oDTVtigsLjMqeDPhMiXjhEYmgm4T+IWhHkOeNuhZ53LAShGRu85MDzLZvJMhJNG9bB8B0v6v83shQ1cz9TR7NJarA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 22 Jun 2026 11:23:11 +0800 Kefeng Wang <wangkefeng.wang@huawei.com> wrote:

> >>>> -	err = walk_page_range(vma->vm_mm, addr, end, &mincore_walk_ops, vec);
> >>>> +
> >>>> +	/*
> >>>> +	 * walk_page_range_vma() does not call walk_page_test(), which
> >>>> +	 * handles VM_PFNMAP VMA by invoking ->pte_hole() to skip the
> >>>> +	 * page table walk. Without this check, PFNMAP PTEs would be
> >>>> +	 * treated as present by mincore_pte_range(), changing the returned
> >>>> +	 * residency status from the historical "not resident" to "resident".
> >>>> +	 * Handle VM_PFNMAP explicitly to preserve the original behavior.
> >>>> +	 */
> > 
> > I would rather we amend this comment to something like:
> > 
> > 	/* mincore (historically) reports PFNMAP mappings as non-resident. */
> > 
> > because we don't need to explain internal differences in walk_page_range
> > functions in a random comment in mincore. And perhaps attempt a separate
> 
> Hope Andrew can fix the comments when pickup patches.

I added this:

--- a/mm/mincore.c~mm-mincore-use-walk_page_range_vma-in-do_mincore-fix
+++ a/mm/mincore.c
@@ -261,12 +261,7 @@ static long do_mincore(unsigned long add
 	}
 
 	/*
-	 * walk_page_range_vma() does not call walk_page_test(), which
-	 * handles VM_PFNMAP VMA by invoking ->pte_hole() to skip the
-	 * page table walk. Without this check, PFNMAP PTEs would be
-	 * treated as present by mincore_pte_range(), changing the returned
-	 * residency status from the historical "not resident" to "resident".
-	 * Handle VM_PFNMAP explicitly to preserve the original behavior.
+	 * mincore historically reports PFNMAP mappings as non-resident.
 	 */
 	if (vma->vm_flags & VM_PFNMAP) {
 		__mincore_unmapped_range(addr, end, vma, vec);
_


Sashiko is OK with your patchset, but it might have found four(!)
pre-existing issues:

	https://sashiko.dev/#/patchset/20260618092845.3905740-1-wangkefeng.wang@huawei.com

