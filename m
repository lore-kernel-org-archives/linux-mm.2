Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E8F7606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 12:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hwcttIRx
Received: by kanga.kvack.org (Postfix)
	id 6E54A6B00EF; Wed, 18 Nov 2026 07:09:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 696166B05B0; Wed, 18 Nov 2026 07:09:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AC226B05B1; Wed, 18 Nov 2026 07:09:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 39C6A6B00EF
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 07:09:52 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CBD161A072B
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 12:09:51 +0000 (UTC)
X-FDA: 85448120982.22.DAFB951
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 38FE840011
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 12:09:50 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hwcttIRx;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795003790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SliBFCiuXH8Pgow6ev+m+UUcW7KKoAdntnZ69kSC5B4=;
	b=XBEJRZpZcJiEAZZYMslI07MvtNzBrhby4ZdJLyFQTiCOJQjJjk3q6NvdHBsjn3R66cXfsY
	Q01OuYtoT8GDxHESocZ20++SmIVoqVS7MwfrSIIkCk4q+gpnsX1jRgGR5g0LUuglRXSCKe
	OzlGApA/9vmzQxdILyqEpjrzTxm22y8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795003790;
	b=CLNy+9lwmnPaKfX0kGH8aj4RJX9Ljrdo2GlbEcseO6hPiU2KWt1qWDp+96PoCML53xl64F
	i+PT2+ahTUuYVuJhVIfp6GRhrSzRPdvUsbPpmbre2b8QQyWqhY3xbd1cbDoCNKktqwvUB3
	cC30X0v6CEm1uIM9wvi/BvtD4YJumdo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hwcttIRx;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5DB1062147;
	Wed, 18 Nov 2026 12:09:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41E211F000C4;
	Wed, 18 Nov 2026 12:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795003789;
	bh=SliBFCiuXH8Pgow6ev+m+UUcW7KKoAdntnZ69kSC5B4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hwcttIRxEQ1d1U3aHdQFf28Y+Uv3ujPjGBD0ZSyiDaBYZwWSqybmPkExviI/gmtzS
	 2LUq+hcBLdDzdAfi9g23PAnLNhT+XIii/UxXrWSAy+8yO6EosQghwxAs1GF9aUiylq
	 OE8cb4hVk3SSC64YKsrhu9W4m6ggDvwcL5XKQf4AnISxcpWa9yiwW1ag6BHJSV1WEI
	 GCL36KN5QwPMbrjr0ei8RuvPjdmBavysaHvFl949vtdU4I0MS09W7Qw9wmVcEV3PHU
	 vkw9q5O3gl1fURldMP0lwI3TDBq8df/xB4eVm2i5+0B6xNRfVjGMWwCpKXhPSc9cum
	 nVV2++OnkoMHA==
Date: Wed, 18 Nov 2026 12:09:44 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>, mm-commits@vger.kernel.org
Subject: Re: Using In-reply-to: <patch posting> in mm-commits mails?
Message-ID: <av2UtIIP202zN2jJ@gremlin>
References: <9ba54069-3dc4-422f-8cf6-f81cb806e999@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9ba54069-3dc4-422f-8cf6-f81cb806e999@kernel.org>
X-Stat-Signature: ccace5tzw8cncqbsucas64ao1qbj19jz
X-Rspam-User: 
X-Rspamd-Queue-Id: 38FE840011
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1795003790-786655
X-HE-Meta: U2FsdGVkX1/k0cY+zOV0JxM5c8YsSOvYibeRxEUfiHZo9bISTmWd8l6/VE0s49CAsR1fQFsDKY17hTVDCwnr9WE8NGtzxp/s6R57/fukqn68sHkiTExl6U4XtJN8jXTAsNCEYyFKudSkrtYc6BtIF29qXHTvUpVQU+h06KTjN6ZZjIiAxqehD5Pcp6ozDjEdZfFn+QMraE02mChfFnE5X6EBK6CGyJCeDGCQjJ+1k+KjAV4kq61qNTpKbL7MFYdoV0UqnvEYTDcpJm+8fLfv5dEcTDQiLpUNgXGJ6PtA+NJgEanQDtXa59zTmXQhjDlhFl/ZrLVE7AFypo/lemcjsML32l54dG1k8F0FVDpSPGiIPgPXXmbd3nr1ugqxpRUEF6GG9sLXTrAJnmgn6IMUfnyKWPOqe1YILPy1qXm/ezI/1KbE9m04XE9SAtHq3W+/w+iKSjgrs9byNZri+AjSJUckxGXaoxm3BUOgElkQ2ZnZYBePsC0RZScICZ10nlJPQXYThQ9BY+88S0pKLR022QRvKUIlPM+vhR4m2kGtwDAivRTLuVeO3f/b/pAchw7cd3ZVqfkHi7CIhKCnBNuneeEufU4pJw8pnqwQNVT2IVD/VPilbZTa1JCo0TMOXfpqB6uYTBIzNzxhkI9hFG1ezFVxhZ5WnbiApEYljbZwXtjWBqBh7oZNVUgny/udHMvHYFokacqW4zXDtMplZM4DmgBb3bHRr08GStjoMSfWRCCcZ4g5rtGogwbbpN38PyFaQQSx+b/FypD7mTJXOnbVdac1csbCiEeTepDz2yXZbh29ar9pN3UuxBqK95GVmifdkO1QWKDw4QWU3ABcK1aVSXYEd/WapQslxGeDOkZIvVZWvG2+gCdYWspGHnmf8I93jzTzrJ0ss9ibNQut0cTpFyITFW0vrvmHXQTfux/JQthBeyWotXF7soF1ii8MAL7QAvtaHpv2UryVCy4W90J
 3sMzyK/S
 lzXlJYXukHBv257WwvLfZgPJvi3TsmjNTHnIMkVuI3TgmC8tYtdFXrsiOcx9FmsjyQtPWUGV+Wm90CbEedZC09FLo7NzLHqdoESaMkMITIL+umLIBAZbhquzWZCJXkuPdFc5pDHn5Hm5e9qDBG4Bg7BiC1H+LIzPeVWz9I0CafBH/0bL1i1yvUhwQkKrfWKTPmGYEnlgLNzIgfQilHbER4UpyCutcme7S3TAMxKwHUmIjhGhzUYLs/yR61Ly80VqhXwSM9VplKZfra/hHOxaQaoMtVp2V/tDbdfK1LeXP5+evvz951HqZYpK8siex/fjwU7Q/w9yg4Q8RrU9ozD2BTO8/ArS+cGramhcW3Z+sv/blHzHtWn9kM0FpvL0Eo85qs8mRjkMkyPYsxTVqaWdy8ggaquD2qe7d1REVnnKYO0YA3zHFNHFhvrgiYQEd2syaFNcD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 18, 2026 at 11:21:47AM +0100, Vlastimil Babka (SUSE) wrote:
> Hi Andrew,
>
> during some chat with Lorenzo, it occured me that it could be useful if your
> mm-commit mails (addition, merging to mm-stable, drop etc.) were replies to
> the respective patch postings, which would put them next to the patches in
> everyone's inboxes. I think Lorenzo started to doing that on his receive
> side with postprocessing.

Ack to confirm I had claude schlopp me something to do that and it's already
extremely useful - let's me see at glance if a patch/series has been taken, etc.

Especially useful in neomutt set up to show emails hierarchically.

>
> While I haven't checked your scripts, I naively imagine it shouldn't be hard
> to add that In-reply-to: <msgid> header. You already have the msgid for the
>
> Link: https://lore.kernel.org/<msgid>
>
> part. Maybe it's tricky when there are more Link:'s than the patch posting
> itself. But actually after Linus initially hated these automatic Link:
> additions, he later settled on the Link: https://patch.msgid.link/ template
> as acceptable to him. It's sort of documented in
> Documentation/process/maintainer-tip.rst too. So changing to use that
> template should allow to easily grab the right msgid to reply to even for
> later actions on the patch, than the initial addition.

Should be straightforward I think?

>
> Thoughs?
> Thanks,
> Vlastimil

--
Cheers, Lorenzo

