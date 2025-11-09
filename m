Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84B10CCFA13
	for <linux-mm@archiver.kernel.org>; Sun,  9 Nov 2025 07:43:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEF1A8E0010; Sun,  9 Nov 2025 02:43:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC6478E0003; Sun,  9 Nov 2025 02:43:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C02CB8E0010; Sun,  9 Nov 2025 02:43:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AFE2A8E0003
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 02:43:27 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 60EBE16089E
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 07:43:27 +0000 (UTC)
X-FDA: 84090278454.06.D49BAB4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id D7C9F140003
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 07:43:25 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r6OYt0ud;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762674205; a=rsa-sha256;
	cv=none;
	b=H5IsfKf3hYfvaQHgJAAlSWMD+q9abn4NQ/a7F4/pGhAFOFR9B0RCAfcw0gYL4l2fC8+oDa
	pxKZGoHZITO8Op3gSv0MxfjIh337bi60hHT+Bf3J3g7X1cWPxYLl33AnBLZ9n7XJz73+F7
	uxuCdCXkIUy42qLnaHDId8APmJ9gbIs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r6OYt0ud;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762674205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o/BVp1/MAQ+SPXbhxJkd7GDhLzHSdL2c0IkoNf5OD1U=;
	b=XmzKyj8GecJNycNbBZw2j/CNxTrLyE/64SDF4xYYG2Kwz0dIrZFUvlbCKYY9TR0hzRjl8r
	7EViyE4PmslOGTGvgDFsKOUMXf8jI5xwk1FDXHSjqBvsZqmJCzi0NM33rXNkODA7RNcJx5
	Qqamhhc7EQ/Bzp2QKrC5KeD+gD8hqk8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2755B601AC;
	Sun,  9 Nov 2025 07:43:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B228C16AAE;
	Sun,  9 Nov 2025 07:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762674204;
	bh=MGV48XVq5NOkKwG2fIonqI+u6a72bE/vAAzrSsW3Z8I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=r6OYt0udCgq1im/weT5DxRld96EIWzlmImgUXLdANb5RuA9UvSmQ2haq6oO9mJbua
	 QoPASXj052Zw81+MCFX1gLo3qeF6BOVBMG0GwgLp/YUCM0No14l4L4ML1ofvnJ4pX6
	 e/qqDWOoqT7Tty5HSYNlGWG13mLcrJYheIAP43FqcfdI6wCUycAiB7OMn2a6hYP+MT
	 PI1XWlmkMUnf3d0eJg8eBbu8uZ1hD+lXUxsHdX8KQJ0kpjp+/Av+JQG7BPN0XqiZN1
	 1CiJbkzN7kGdnZWTTktylpGisbu7zCJ//ZdcYWhIJYH+/kvVJwsrCbl8Gmr6gMAo1v
	 Ccg3TDczcIGgg==
Date: Sun, 9 Nov 2025 09:43:17 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Huacai Chen <chenhuacai@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kevin Brodsky <kevin.brodsky@arm.com>, Jan Kara <jack@suse.cz>,
	linux-mm@kvack.org, Linux-Arch <linux-arch@vger.kernel.org>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH Resend] mm: Refine __{pgd,p4d,pud,pmd,pte}_alloc_one_*()
 about HIGHMEM
Message-ID: <aRBGFZW09oFxM4k5@kernel.org>
References: <20251107095922.3106390-1-chenhuacai@loongson.cn>
 <0fbcde0d-4fed-4aa6-b0bf-c4400b9b1cf5@app.fastmail.com>
 <aQ4jmguL-dwKea-N@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQ4jmguL-dwKea-N@fedora>
X-Rspamd-Queue-Id: D7C9F140003
X-Rspamd-Server: rspam07
X-Stat-Signature: zh9gbob7ayurxfi9grxwts7r7h7rauzp
X-Rspam-User: 
X-HE-Tag: 1762674205-789881
X-HE-Meta: U2FsdGVkX1/l5ecqAfzBbUuPJ8rCdI6gWRQjbu/YIzh+oPJDhNBr7vi+02+ayZSEvkXzWmOmFZbvI2hJSGcQGH/hR6fXJUevkCQyYnutfuKTbUy14H4Mk/k5Xg+WltK6/kKD6hdzv0pV5LKtGrZiPNf3HOCWxeligbbBzt9cSZg7Hrno3Rnkq+blVe3wKzBtt9gVYQ5VlNFpAXhyiYhrKGImV+sRze7acfszPYrork30gJ43ceS3rjz5JXs/ixp+umXIbVENM6cBp+2XNsvy46blaNRfAQkOXVdm1h599HaOUl7qZ9XtoeRxxvqmyCEzAYIxSITuFTMYb9jjvRb8FpKev2fnjWA3pTCnYUO7E2XZshze85lWIzTh8JDArP5h2KNyW1sBnnUFSghEqIz3EIKJ6k6Hhd0qBSm2Txt2W+NYpmVTtqCc4VsU2rn7UEOv+pU7NiHiuUD8Rji3bOcIIPwkJwebFeu8lL7uGTRLk6mGXQoaQFTXIsk9y8j8FO6EU+YFog91GpX+osRgCZdTKVqMTHd17x0CHruFhUy19pAwN0M1cuYcv/nCMWjsFL5n56pj8lBB2gevxUranGiaesvEiAIhZbIj7gMUvqtYPMoELD3EqTCvhYqWUvy4GoalxinHMZpA+LtbDRmAWRGRuhCCt7jBOiaCnf27RlY5q/jHpCAw+uMzCEikIPtvb/vYqs+iLjis0LfeLGyrW7TAgDHKaQlIe4QmhfdIj77xcEjKHMn6v6V4PnbFqo4X5PPkqPKQhm6eF4KcB8rtSQIJwfwvMK4B/aIAZXE2F6ES716DPrvb7yygLc0h7CQTVGZMM37Q4X1itDad/fREQTc2QwuRJ10KDw+/h66sYqDAei7JDkSmMFkuVLwyJ0ndK0bXFs70Jvu0QBHvyGJfEnia0/0QgjseZBVRN8QI6u1VtAMoAPe1G6Nvx3yrgTdvXkFCcS2C+2+piRk1T1yFxoz
 AuFQF4ma
 L7ke/hsr9dYm9O1P9p755qlUgNhDnnq4+J2o93AT6/Muh7p7i6f+TCoC1tdwsPAb1U4lpKLZ/6V9725zmq3aLq6VGnRM6xr84CF9BadrrMRv02QIxQUekUddmbMThFFmnWoF5xyZXI/ACQ2FqLcPQhJmvixBvJi76bF5O7itn5lCWZm+3ueEHJlQnVwk+mcZQc7hIXPxmtqufBSVVR9rozd5lNalrEJpwj43PaO+tw1yZ4ZINqiSoDlVJ5UMJBiu1FrFyn1CRMj+Ns867P6jLKCjttqk7t2/6oAq6qRJhQCxLTx4gtBxJAXo9WhgDBuVmm/iCKo6t7tULjPMyPMjrvSjvC0kDqpdY9l9YeQbGEzYtxEW6CND/wRzh6Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 07, 2025 at 08:51:38AM -0800, Vishal Moola (Oracle) wrote:
> +Cc: Mike
> 
> On Fri, Nov 07, 2025 at 12:21:38PM +0100, Arnd Bergmann wrote:
> > On Fri, Nov 7, 2025, at 10:59, Huacai Chen wrote:
> > > __{pgd,p4d,pud,pmd,pte}_alloc_one_*() always allocate pages with GFP
> > > flag GFP_PGTABLE_KERNEL/GFP_PGTABLE_USER. These two macros are defined
> > > as follows:
> > >
> > >  #define GFP_PGTABLE_KERNEL	(GFP_KERNEL | __GFP_ZERO)
> > >  #define GFP_PGTABLE_USER	(GFP_PGTABLE_KERNEL | __GFP_ACCOUNT)
> > >
> > > There is no __GFP_HIGHMEM in them, so we needn't to clear __GFP_HIGHMEM
> > > explicitly.
> > >
> > > Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
> > > ---
> > > Resend because the lines begin with # was eaten by git.
> > 
> > Thanks for your patch, this is an area I've also started
> > looking at, with the intention to reduce the references
> > to __GFO_HIGHMEM to the minimum we need for supporting the
> > remaining platforms that need to use highmem somewhere.
> 
> Yay! Thanks for doing that, I like less highmem :)
> 
> > I'm not sure what the reason is for your patch, I assume
> > this is meant purely as a cleanup, correct? Are you looking
> > at a wider set of related cleanups, or did you just notice
> > this one instance?
> > 
> > Note that for the moment, the 32-bit arm __pte_alloc_one() function
> > still passes __GFP_HIGHMEM when CONFIG_HIGHPTE is set, though
> > I would like to remove that code path. Unless we remove
> > that at the same time, this should probably be explained in your
> > patch description.
> 
> Skimming the functions, __pte_alloc_one_kernel() doesn't get passed in
> a gfp, while __pte_alloc_one() does. IOW I __pte_alloc_one_kernel()
> cares about architecture gfp, while the latter does care - so they are
> 2 very different cases.

__pte_alloc_one() has gfp parameter to accommodate CONFIG_HIGHPTE that x86
used to have until quite recently and arm still has.
 
> Might be helpful to explain, although I don't think it matters much.
> 
> I've cc-ed Mike, he might have more useful opinions these functions.
> 

-- 
Sincerely yours,
Mike.

