Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B6E3606A323
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 15:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=MmbldRwm;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=0OmouxRS;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=E/9UpYUc;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=K/lgFPbV
Received: by kanga.kvack.org (Postfix)
	id 46D776B05BF; Tue, 10 Nov 2026 10:37:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41D8E6B05C3; Tue, 10 Nov 2026 10:37:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30C9C6B05C4; Tue, 10 Nov 2026 10:37:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 074BD6B05BF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 10:37:43 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BF11014093A
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:37:41 +0000 (UTC)
X-FDA: 85419614322.12.F48E92D
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf13.hostedemail.com (Postfix) with ESMTP id 912B620005
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:37:39 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=MmbldRwm;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=0OmouxRS;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="E/9UpYUc";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="K/lgFPbV";
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf13.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794325059;
	b=iDWqnhxTdx5XSZRXoj6ud0z/AU+2inNVNziNqITlgHEQysH3gZpY/v4bkCRJsvqnhOU+wh
	G9nnXA/1xhJ6mAuEQYCFH2YWHs81j7qS+I/iConhPYyjSgu/bZtW7I9JQn9xXLHUHH/qCq
	P6ixeM9UM1Duq9dECC2V6YNERi7qe2I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794325059;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G+VenII0jwmOnGUQKiSusNuz5Q/gzWL632bcNCLluCo=;
	b=Ar4mb0bpjxsZJzY4H+xUWqyun9zy2Fib5OLtUw/2YrM725+b+IBbJ+Hjukw/X4/iXk47x0
	7+WExDp6Wl6Zjg07YeGVUANOEKDMSgBrEP5wRYYA4brekrvCR9q1+VsutBAPRbwP1zYr4g
	D1KwQZU+dgHfgEcXflyBeHJ+/V0UbwE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=MmbldRwm;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=0OmouxRS;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="E/9UpYUc";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="K/lgFPbV";
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf13.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id EC47D1F7F7;
	Tue, 10 Nov 2026 15:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794325058; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=G+VenII0jwmOnGUQKiSusNuz5Q/gzWL632bcNCLluCo=;
	b=MmbldRwm618/CVcGLyudixNM57fs9Hy5KWALkJOwvBDLpXlYCeUbMUVYw+8yP8pamNrQcq
	u7WQbIKlicPKYZl30TAsdt4DbWA8qMHRHjbDLCVtfyPE8slBiW3xkVehpBMfFHjVS2SG33
	xAZV4w75MAMkS5HkZd746kCuLZ97844=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794325058;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=G+VenII0jwmOnGUQKiSusNuz5Q/gzWL632bcNCLluCo=;
	b=0OmouxRSA2P/5DnrLBl79+irDVO1cTVam9A7eCmzSVUnAAAneE1YH/kPS1S3fXecrZ8z6E
	S5RuvbhWOzWzm7CA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794325057; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=G+VenII0jwmOnGUQKiSusNuz5Q/gzWL632bcNCLluCo=;
	b=E/9UpYUcUPN2KYwhM9o1Q2S+Tp2V1PDYc6WPgkpPC3LrDdVgtqzJa88akvAjxGyLhHDKbk
	3+7dqotNMsdQw/4aHBJ/8a6En57FMrVnxpEWgZ1CJ3JGlazdKG2V0SG7ftXYFxA4fsNKDM
	j0Phgn3rff7RSfE8OgDxAxJYkql4fp4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794325057;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=G+VenII0jwmOnGUQKiSusNuz5Q/gzWL632bcNCLluCo=;
	b=K/lgFPbVHQ3kryfHqIrpNfp/GfOPUOvpW92Ge7CQRRAXWavqjUdEKXl2MKrRgTFZJiF7bk
	YeCfbu94FkwKMaCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EAC6913479;
	Tue, 10 Nov 2026 15:37:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id eyAkLEA682qaawAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 10 Nov 2026 15:37:36 +0000
Date: Tue, 10 Nov 2026 15:37:35 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, "Kiryl Shutsemau (Meta)" <kas@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Seunghyun An <san55@wisc.edu>
Subject: Re: [PATCH] mm/vma: predicate vma_assert_stabilised() on
 CONFIG_DEBUG_VM
Message-ID: <avM6Iyu3_0Mb2w27@pedro-suse.tail5790ac.ts.net>
References: <20261110-vma-fixup-debug-asserts-v1-1-0b2e0680cd7e@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110-vma-fixup-debug-asserts-v1-1-0b2e0680cd7e@kernel.org>
X-Spam-Level: 
X-Spam-Score: -13.30
X-Rspamd-Queue-Id: 912B620005
X-Rspamd-Server: rspam12
X-Stat-Signature: 8aprk4antk6jyx1rafip4f5w4ur9z5te
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794325059-730336
X-HE-Meta: U2FsdGVkX1/3qlWDp+0i28yg0TRAQU30nq6tD1NBmJKpV9rSTIdq98pPR8yERsa6DJp6qGjh+MUbzn2ncfQKtamtsv+PMpbu+FVv8CLSNYtQIzkbwIFyG6gbfpRGNqojwBsZl4Eq5aX39DkJweZUcZeBRjQ6PMQ7viFK4QNOzOKiZs7JJLZ8C2GhkJDmCHdcStLNIfiDJax8p8y0rWf9Xp7nQ2PBBxQatyJxpx5ykuEcNqLND0LH1IbOYaPLh7L92FgCZHp4PLfU1tGSmrpFeGZ8UTopR4ndLX6xbrUxbX1Ph8t4m6Zd1fG6NC5F/Z4JOTwahlpI9ADYdAmEPkchV4NTm8riOlvP+KkOANT6xe8swTME5tbia9F86X29aSz6DN2srN99wMCIuJ8nMvdeLaaXno8PJh/8ndK3UQfxrUp+CdYJswrrnVBuiFRFjAU0JqEaTf7cvntv6AE1f/x0amFHdWcp/GBEzqnM+vPh8ERp84kKyDG0BmqHkY4u8k9H51mHERnDRlcf+xqlsY5Qk1haGQTbcVas424tNqZKLL6BPwzNkgVwFS1oNCow3reOIJ4KhZsCPSC1XK4vhEcK9rxMPddqyefdSku3Yi1HbZLAFkag9B/nDaSu0Hi1tDiLxvQ9SjJmU0hWBoTZsIVKOlk06YToN0TlZyeu+pLBxdAMG1Ht4D+tt+jGYwXtX5Ma1oI5axNtyzKCkovJ8NOu3HW8HulZ0qwHxEN+hqBHrJCKeBzqse4n0oZvMl4LirDnLTRIAj/rl1OEa1R2GBAwcNuY8tHG+z+JZbRHZkbHxGQ6nK3QMFWwsMUZEuI947YLOVugAGLhlINRz/95Ei0VaVyzKu11ZyR8iTo2B36fzcUJ6kSDQuVEW+M5Zu1FkC/IKqFoV0TsxmL6WYGZJ2suhAeOm+X84m6VC/BZ2bV+ovKZNJwvBT5yDfWbtxG93a9NV35z20pQR0ykg9kp7b5
 vEnKzVul
 ZBt5V+GfqX15dXk3XmxpaCs0mUe+A76tfBHnkjyIhQOG1/oxhqbZuwhc6TQtIEf/cGO4MfNONdiYPlxvDjJ4FcLp0VZZcET8ZXC3p00VBJsPCvPUhwtlF8ik8GSTtMtMvhq1fZmvq2CalkDZhgHPgyQYh852AZFg36ci1oznqc4PDgQ0ZLmQb/Jqjps4eQGpicpq0A+oQTj5vAmzsca+MRqnRnHeMEyOIpd/94Gt8QSR6RCREFl9r2aveGE7t68wVoY4lHDa8M1ycHzsvAxVG2qgdwMuCAJAIxftmfPZE1iPwqiAXYOG8VDzag9SUkwYooCicwx1YUJ0M2zvbPp0kV/X9/LMjhue+wjfe1TTeEWG/iJ1nhxMzH3BAP3CmRsPi1wKH5JcKifHZHGTeSqIyK//LGU6YuEqRGeWUEL4carq8zeSOPn144zZoy6sZ4OzhCejckahBMSwngK8J24SqgRK9OS/WPObPKOT5mRObm06SSfY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 03:10:40PM +0000, Lorenzo Stoakes (ARM) wrote:
> I introduced commit 17fd82c3abe0 ("mm/vma: add and use
> vma_assert_stabilised()") with the intent of picking up programmatic bugs
> when debugging mm code, but kept the general practice of asserting even
> when CONFIG_DEBUG_VM is not set in line with existing code.
> 
> However, it turns out doing so can cause performance regressions,
> especially when asserted in vma_has_anon_rmap() which is referenced in a
> number of hotpaths.
> 
> Since the intent was always a debug-only assertion, explicitly check for
> CONFIG_DEBUG_VM and do not assert if it isn't set.
> 
> Really all of the assert paths need to be predicated on this, but start
> with this one only, out of caution.
> 
> Additionally, since a detached VMA is trivially stabilised (nothing to
> stabilise against), check for this case at the outset, and update
> vma_has_anon_rmap() to not explicitly need to check for this.
> 
> This also, importantly, avoids reading any VMA fields if CONFIG_DEBUG_VM is
> not set.
> 
> Target the commit which introduced vma_has_anon_rmap() for the fix, as this
> is where the issue started manifesting in practice.
> 
> Fixes: 38564710f443 ("mm: implement and use vma_has_anon_rmap(), silence KCSAN")
> Reported-by: Seunghyun An <san55@wisc.edu>
> Closes: https://lore.kernel.org/linux-mm/20261110000002.1834454-1-san55@wisc.edu/
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

