Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37C3DC87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 16:50:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2C136B0088; Fri,  1 Aug 2025 12:50:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDB1F6B0089; Fri,  1 Aug 2025 12:50:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF1296B0095; Fri,  1 Aug 2025 12:50:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B03406B0088
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 12:50:46 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2CBC4C025C
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 16:50:46 +0000 (UTC)
X-FDA: 83728777692.14.502FB16
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 900411C0011
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 16:50:44 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qalISDDP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754067044; a=rsa-sha256;
	cv=none;
	b=bsTD5xAbJGPtx2hHbHIpC+/DYAzpju9Y4sFiWAiNhXk7tJ7quDRe93zR5lq3RoIDCGts8R
	0lqX/hkNZXjuZa5xyAKhj7Mx69TgxatC4Um5WmQ5jRSMUsBMG0viwh731jxvTlmQIcTVRY
	/TVlqM6+aXpKDk1lCARS5T9fiz0pc/A=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qalISDDP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754067044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+cRSFZPVpqjUZy22jiJxFdHn9qHmPb0CkkME5c4fmrw=;
	b=S5Ct/6MYoNXzqOiw2RP71BR7sM4hiRWq9BW5XZf3/moYTmVqs0DToSOqulYTeG0KSqckg1
	sfK21sODr2s3D7+Z+9qbFohYHNR84nhHP10NUyCHVCcBB4eNTjp8xP8Jfbw4xyIAa+PfUi
	8XFwviC3N5nGLZKQ6hMQ6j73LgQeiuQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DA5BD61132;
	Fri,  1 Aug 2025 16:50:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65E70C4CEE7;
	Fri,  1 Aug 2025 16:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754067043;
	bh=yCsTvSZ2uYa/j4iCTrOUQDgQlndbnppi7HrfEDho8dM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qalISDDP6/iAPrr19SGlBNPXQmhlSFAnk+oJd3w6ppesOlfJIP9wbLf10p2BTWmne
	 bUbzzB4ZsKmmAPEXeZozP8SEXMlJFzhZFYEcMK/3CxbN1QuWVS5faULBIt1uYVVLjy
	 d2+VaUPhhmmR+LGFeTSTQmmL0mk85TbsvHvYUsYrXTtXgA0YRMyFXe3PzJWJgCoqDI
	 sgwhDAE1aBo/JoTmG+fzAso59WIKpUy2u+M/hfJfDRJiDKL/RAxh6DSqKo0x3p5ocS
	 AS63BqAs13B+NHY7VCrdOkwrNFrlECoIFybYqww57rIXX4WcflVH1FGaJIcp8jT5Ze
	 LxxY2KZwNI8sQ==
From: SeongJae Park <sj@kernel.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Honggyu Kim <honggyu.kim@sk.com>,
	kernel_team@skhynix.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/damon: update expired description of damos_action
Date: Fri,  1 Aug 2025 09:50:41 -0700
Message-Id: <20250801165041.8350-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <CABFDxMHamJ0m8Nq1L-4WNz4OwLaLVQdwV=X4_ZpK7Vd+RSTHVA@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 900411C0011
X-Stat-Signature: cihyskrbebrfwwym9uh86mcys5ygjpjk
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754067044-43625
X-HE-Meta: U2FsdGVkX18mlo1m1LCF4vh4FUwUJKw/hZjYv40/FwUGBKLkyAbxYuPoVENwQuCEzoE/R+uWWKFF+rkikjXuqqr1i+fSomxPpOlJT22rvcFNbPhcSsl4XQ2dnCTb2gcEFI9CNb9fl2PzK1lu950aH7zoa2d9BC9VkQ0msOIVeEziG2b1E32/9bnNfZcxUzNJymIWeyTvN/oKOVNNgqZaHK4wRUe2NMami+9fGbBk3kFgUcLJDmfiiopzSdUWUeyjI8paz/fdoG/77UdkOfBo3UQ9rG3JWCKRWA1Upt9zIbAoK+W1aJeHv5NkslN99g+5M3NvZku0H5GNFCrVkf78VG854iH2M0ae0g+LmBnxEL2xa0B/WJUxIWbVES93W11e3cdIE5wSL8AHWTh0jvKnJJMda1IMSs4JJdWWy8VsAE/fixQuIZIVLcd2y4Hw/WA5hect5b1cAxRuPhYDaHbYOl/pkrxvBuAk2itxVbZ9ZwpEo05MmDL+AKKfPrC/fNCcMwxeZSSIwSbmp9Nom03y64VyrRJLs/t643Iy52IIq/M0KPOeus1GU6ouGSj7BOc2Z6MTrSP4T4zY0ioLhwX29/+TnyefEG7f80djNC9ZSEG3uABqTNES78gUPiwYAXsOiWhUpXRn97CnPhNRNGrTvImqO/nnavPf9PuPpiE9ZSqJC02lKgZI39xsIqS2EaUnUgcTT40D6M+cFsDW7iqjFuIidi2rGvmxDecoVVsymHzXxtDd2sW7kw2gQXLm8DScglrPL9ayIpxEBNRfGUeVCS50A45SnYwoKthg76baAna2v4YXLZMkVrQYGJHIR8YnF6iH1SJFCly3OXgigjRul6jCbcIT2IMaRUGBSXCtEm9fMcO0vgLGKbC8GKLbRJpCda9lNyqZjOpLg6sptriKGebh6c+WauIz2uQ1tUEcoSBrd3YRYxIVh4ARyLEgl9axyediPCryWTFiOZkHe7z
 IH43hVSD
 wque7ihO1b/OuY/CHT1oKGAqIztdJVx+Foajf08UOr+Eck/lhh3iXFnksDr2TV8q44BidrL47LHXkwkkdLjq+ASI4dIy9ZcXug4MfDOuCWvsQRGG7eotHcYdRdvphCDnSGaQzBtaekprtmNe6sElTbYyxLz4zju68Ee2j7cKCzohSPGfK5PrDc1TLywoCKLuHlxH3DxMLaq+UmaA3yNx7f8bvkX0aeJ662q3j76gMUjLd4+HUdZ5HdkVwyRHfbWilzs7+SrmkqgUb0lGbgTfaoRJsDBrf4cZV6r8lGqQtz42fSL6QhaQe8mjeYRgV5sQZKVZdbzNBqr8esdFRwKTzAWc2uqvZU79xfSVloBBuaKi9bbS/0cIWcjgi+Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 2 Aug 2025 01:11:09 +0900 Sang-Heon Jeon <ekffu200098@gmail.com> wrote:

> Hi, Honggyu
> 
> On Fri, Aug 1, 2025 at 8:35 PM Honggyu Kim <honggyu.kim@sk.com> wrote:
> >
> > Hi Sang-Heon and SeongJae,
> >
> > On 8/1/2025 2:58 AM, SeongJae Park wrote:
> > > Hello Sang-Heon,
> > >
> > > On Thu, 31 Jul 2025 22:22:30 +0900 Sang-Heon Jeon <ekffu200098@gmail.com> wrote:
> > >
> > >> Nowadays, damos operation actions support more various operation set.
> > >> But comments(also, generated documentation) doesn't updated.
> > >> So, fix the comments with current support status.
[...]
> > >> diff --git a/include/linux/damon.h b/include/linux/damon.h
[...]
> > >>    * @DAMOS_WILLNEED:  Call ``madvise()`` for the region with MADV_WILLNEED.
> > >>    * @DAMOS_COLD:              Call ``madvise()`` for the region with MADV_COLD.
> > >> - * @DAMOS_PAGEOUT:   Call ``madvise()`` for the region with MADV_PAGEOUT.
> > >> + * @DAMOS_PAGEOUT:   Reclaim the region.
> > >
> > > Nice!
> >
> > But doesn't it make confusion about whether this pages out to disk or does
> > demotion to the lower tier memory?  It's because PAGEOUT action doesn't do
> > demotion, but it looks "reclaim" includes pageout and demotion together in my
> > understanding since /sys/kernel/mm/numa/demotion_enabled was introduced.

To my understanding, DAMOS_PAGEOUT can also do demotion when demotion_enabled
is set.  Am I missing something?

> 
> My intention was just to synchronize with the Design documentation.
> 
> So how about changing the description to `Page out the region`, Would
> this be also confusing?
> I feel like it would be clearer than using word "reclaim"

In my opinion, "reclaim" is good.


Thanks,
SJ

[...]

