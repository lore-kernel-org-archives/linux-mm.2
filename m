Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C910F606A31E
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 16:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jnxrPTFL
Received: by kanga.kvack.org (Postfix)
	id EA7DA6B05B3; Thu, 29 Oct 2026 12:04:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7EE96B05B5; Thu, 29 Oct 2026 12:04:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBC916B05B6; Thu, 29 Oct 2026 12:04:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B9C4D6B05B3
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 12:04:13 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 317BA140481
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:04:13 +0000 (UTC)
X-FDA: 85376135586.23.F3D41B1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8F3F24000B
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:04:11 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jnxrPTFL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793289851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZEImV1bsETTOjzgBZOnqxSCBynlGZZgQGJAOsTFWdvs=;
	b=ikB0E3sB6U4EnOIexMlpPMXDqP5I3dwZRuZHlEXaesC0e2dUTOtDhrSM9dyB2BhTT+MaJf
	NVoYZ5oUdAB3pH2sQQZYwgs2tGHijzUwG9MBg47YD9DGtwChmrR3Go3RrLaPGNVwh+Njat
	X04BP5iHGnsH+qeE/6f1RJcJSkP8WNY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jnxrPTFL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793289851;
	b=1eFcnVJ7UnzvgOFewHYwXXzgH4Rg/la88XNZpE/UbVNbPlPfpMk6EzQy+6dXFk+Wi+3xFK
	RknbdfW7H78/EEaruphZ/0ZMwWYBePFuZugDq2g76B0o76J+XTW+fZlqOwIi7+CM8C6lju
	56V+60up6OWho9AyBbVaW1XWA09PPbY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 119E960267;
	Thu, 29 Oct 2026 16:04:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3F661F01825;
	Thu, 29 Oct 2026 16:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793289850;
	bh=ZEImV1bsETTOjzgBZOnqxSCBynlGZZgQGJAOsTFWdvs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jnxrPTFLrMh7lS0axSQZJeIw1zTZvkrB4+S47jC9dT5x4umfdVJ3i2j1TvejMOR6x
	 BJFAR5YKZQTHT3iLU2Tu5VK1VvJqRcy843wlOLG3Z1fBBUbb+Sb8OMOJ+sy17ax7qM
	 NltRB2210GdZxxK0PGcyACJf8fhMJz8/pycGtt04vTFUb3zOAGoHRlL2YNYLZjat8o
	 RQUIJrXMYd9hIkqrD0WWaKEMa4sLwnU2MY8440CDdUO06TgWx+Z/Zb40mTeygYUuB7
	 NPOO2yTNeL9ft5Z4lwHjTq9qykadh8pqrJ2e11rfB5l5aNCofsTVrL4FvwZVVsdt8S
	 vJsiCYCtj++fA==
Date: Thu, 29 Oct 2026 16:04:06 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Nickolai Zeldovich <nickolai@csail.mit.edu>
Cc: Matthew Wilcox <willy@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] xarray: clear the new head's parent before freeing
 the old head
Message-ID: <auNtjKLHZOo1awG1@gremlin>
References: <attzI4sj2Pagmvkd@casper.infradead.org>
 <20261027192014.844878-1-nickolai@csail.mit.edu>
 <auNdNjH4zo7OYbe-@gremlin>
 <CADGQE7EtDGs=g7p5=_m2LieLcEj-k4LyupOFWt96Aw9py-gYaw@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADGQE7EtDGs=g7p5=_m2LieLcEj-k4LyupOFWt96Aw9py-gYaw@mail.gmail.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8F3F24000B
X-Stat-Signature: xts46bqib3nt4p7wfn3at67m4zgbwags
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793289851-738290
X-HE-Meta: U2FsdGVkX19erSlEm0QUCecgcyXvmTGvkKzcz18CvgoeFvyK5f0ZjVrfTD7NP0GrawBk8bt/f/kyhZFoc5I/UkiobtN66v2BqeBSuKToDrImj7CbVMRi/0PPG4RPAgv0zZAN8U1vQbeeqJHCbmDJ9TbqVlKt6UuPALRY9J7mSKWoDOsd1o0zWI+61RFM5p6KjGViO5KxA4g1Wzywhz+QYzH6r7Ps/tlS4+HMEwZ1/alQIfsmwxo/yrUpl2zDlU5yUVMXQypN0UO86l/VnVQX4CxlBlUNWvMerPv/rSKl6fO6EN7MB0HEILaOyuDcnjI5u/dOy0D8jHTkBx62jRQtFkyw1A2CwjZ3VFGAqj0kZg2Q55cvl/ISoIGHfcalBkwCMnXuhE/t7FTzDESw6SbrKd9xfJObEg0Jvo7KLeZLAVv12hDyaMpg0/hueZ5Dp4Akl7CNimzWvawrXRwgme8cHDLadrQvnLVS2jQ2Jy7x89fxV6Yoo3DY81H3oHjRN8mYZIRM6Hvi5QkZohqnUynuhygV3oqWaSu9SHnxdHMQrItotJ2oYwkKyUrCcNfTEZW1BdWa6tHDoGMhcB77zAzqtQQGmmB9nDshUvX1ZNh6/I81Q3OWSc0sZCyT/PzcEslCvF43gsxBkcdkRRp/r9p613FmD//uyVqDDgEcVtEhoh3lWGA9mPiSRA0OOsV2QM5HyCPXZABYVofZcJTBIiy86o99sWniej5r+6XYg5SVIjQ6ZPhM81knHIpfREZAHukrtctib/DyKxmopNQRJiFAAV4ifL+SfPRPP4QQkBnpCtuGmKEKhi8XfW4n4a9HxVI4SeJHdeKwhO077mnF/e2H5Beu+0rvAECB0jybHKksvbRCNslywSemKmicBWO45JCXGb4Uk3ecI2XkaseWlnWe2aHFmbwCwM7Vuz9ZZBlWBOF4sMbRpGL+Gb+dahTL5rcXFBDV5ScxDRVGYgZDOM0
 vIvwleOI
 p8uwRHLdVY4QvcTamhnk02yHMe4SWbAc8fAhtI3xJkONI7zwifO7OkoEKCArOjlnLDu7i6UXxZLxB7nYo9QYbpYX+87ghmbBMBoM+RsRCR4XUIPqaCcNPyxYT2J2E1nYFSF4albCwO/6VL76yrXFLvmzQjnAKtpcRAUradn4axD+YtZfFPcaM4orAaG2iaLefsHA+RCfEzhayqAgoITF0kBkMxGfgoIo8I/TJXBn91pxaVD0rTTCdQRxv7oJheQ1/6vholWOtXo6tN5s1Tojt421uNuDIIfVVBDnEODjJw1wTiqQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 29, 2026 at 11:50:37AM -0400, Nickolai Zeldovich wrote:
> Hi Lorenzo,
>
> On Thu, Oct 29, 2026 at 11:03 AM Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
> > It's pretty 101, but please don't send new revisions in-reply-to older
> > revisions or feedback [0].
>
> Understood, will do.  (I was thinking that applied more to
> multi-series patches, which indeed gets unwieldy.)

In general in mm and mm-adjacent we prefer not. I think this might vary by
subsystem, but it gets buried easily in even single patches, so best to default
to not I think.

>
> > Also, if somebody replies to you, reply back. You, not your LLM.
>
> Indeed, I've been replying personally, though in a few cases I sent
> the response in the notes of the v2 patch, in an attempt to send less
> mail to lkml.

OK appreciated!

>
> For context, I use an LLM to write Lean proofs of correctness, which
> seems useful for cases where the patch is non-trivial (e.g., [2]).

Ack, this seems to be a trend. And obviously we're not against LLM usage, as I'm
sure you're aware, this is about rate-limiting that's all.

Also use of lean seems like a nice way of bounding LLMs in a way that makes them
less likely to go awry, I didn't know people were already using that for the
kernel, so that's interesting!

>
> > Also, you are flooding the kernel with patches, 5 series across 5
> > subsystems over 2 hrs:
> >
> > https://lore.kernel.org/all/?q=f%3Anickolai%40csail.mit.edu
> >
> > I already asked you once to stop doing this [1]. You've carried on.
> > [...]
> > I'm sure you're acting in good faith, so can I please ask you to engage
> > with maintainers instead of ignoring us and treating our time as valueless?
>
> Sorry about that.  I'm happy to send bug reports with clear userspace
> reproducers, instead of patches, for any bugs that seem particularly
> significant.  I'll also get in touch with the relevant maintainers to
> see what, if anything, might be useful to them, rather than sending
> individual issues/patches.

In general the bug reports are welcome, just space them out a bit, or if you
have a bunch for a subsystem, contact maintainers ahead of time.

I know you've generally only sent a few-per-subsystem, but in general this is
about managing workload.

Right now the biggest issue with AI submissions is volume-of-submission
vs. review resource. The former can grow exponentially, the latter very much not
:)

>
> Nickolai.
>
> [2] https://lore.kernel.org/lkml/20261027125210.843589-1-nickolai@csail.mit.edu/

--
Cheers, Lorenzo

