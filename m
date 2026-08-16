Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E371EC5B572
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 11:45:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B49F36B034A; Sun, 16 Aug 2026 07:45:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFAD96B034B; Sun, 16 Aug 2026 07:45:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A10E46B034D; Sun, 16 Aug 2026 07:45:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7F6BC6B034A
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 07:45:45 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8E38040536
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 11:45:43 +0000 (UTC)
X-FDA: 85106952966.30.B6E78EC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 05D7120002
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 11:45:41 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YlrNoNPA;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786880742;
	b=0PwgtY1bRaNb1oT6jvN6X8Tqbpe6nS2kTvl1i65TiSBT34Lna5J3bVQ4s3KLX50+THlmXa
	qlcNne+D5fNGjk0GBG8WeKy6A7k3smdG1BW1fvRzKNdxpopelH5kvCTKMddff0raxQduKX
	ttawnxo31FnDGPenxEZAPb+5KSj9C0E=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YlrNoNPA;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786880742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z5Z07mUsGsAyeSZLeKUE+Az4HKygAkcze1WfP72l0xc=;
	b=HavInRNx0J0DwR+40/b3xEru78m7xSJfekfQA2QrJJ8lKFPLBsuaY6XOHSMf4X/w5b0WYu
	hiaHY5VLG/Ch6pMO+S/wmw+T3+OybKJBMrF25S1vgyZWMnFvrjxpqaBHYBGzE7SeK3/Ibo
	NhxnzysEyFxBL651+D7jnbOha/fUSOs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 69D936001D;
	Sun, 16 Aug 2026 11:45:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 165281F000E9;
	Sun, 16 Aug 2026 11:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786880741;
	bh=z5Z07mUsGsAyeSZLeKUE+Az4HKygAkcze1WfP72l0xc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YlrNoNPA8AN3Xoky5IioB/GeOEnXfH0NQxMJtLg3RjDD87tR1yevuIe1bGhgQTd82
	 90OpNNV/IK4Hr4jalbWncXljjaQjLb08527bDul39nbENwXtPxzA5mmuMOb17xrtmq
	 GWft+uM3gFRzf/OzDKR6YxNiE6xInzGXXNwREC32BpvaExTQfXgNUb/9NIU5yShMW7
	 Vgct5Jm6WiTiXQtp2XagXDNz09VvHrWhhuq7bokj0DOGzCgNht9Hlki921i/AhO43/
	 t83r/mpBzo867TD87/umHbmHRBwlI5nz1qT6ZGuFDktMTSHW+vaoEeeogxc4VDKcCs
	 VJCiZnyV5oZJQ==
Date: Sun, 16 Aug 2026 14:45:34 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Foxie Flakey <foxieflakey@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org,
	peterx@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] userfaultfd: reset err to be 0 when move_pages_ptes
 succeeded
Message-ID: <aoGi3g9AlcG9EiyG@kernel.org>
References: <9c936a9f-ed27-e510-872f-5b3b8c680975@gmail.com>
 <aoF_qmSHiEgujaH5@kernel.org>
 <69522f38-7e5d-ebdf-d42e-11d822bce662@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69522f38-7e5d-ebdf-d42e-11d822bce662@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 05D7120002
X-Stat-Signature: ocgqotohqbwnsj9iojk7f5863t31d9ig
X-HE-Tag: 1786880741-373251
X-HE-Meta: U2FsdGVkX19R83m0Chr8IirGuCdpFohcHyrkCd0D9bTXYabkuGCipPCgzoXKEA0jeXofyZOL3sC8LVjQXfrNZr6XoZtQUPQWAgurfr0aOI0/fmSCcdpo7cGtpcm/IMsrMUS+ZW92eyA5zq6QsSVfWjg3qThQODzgXHCm4DueAj1aZCg4Ug18MiQPfL1tDwTAdz76VBGfVMf8iT34JC5GD/1TwB5dI2H6Ja4znCCM9j9BFncZS4BzNViBYWOleqlhnV3DohmMgRYoXkXs6alS5h+1u1CBCFzcYfqTyZPeArQ+v1nMKJA3uEGmXluW6nz4xNAxJ3Wq8YDY0dd+/xuIc+zWnsp48eQ9PYIrx5wml/IoSvthnK//PqliUnbcealYPcmBqmR3CooLD7AJ2MNgKZU5kDkhcQUzqjuurZ+PAZ46iSCxBft6WOTj4vHSofF9URAVWB5k5VOO8iJ2twL6+oc8wWFrFUZLvNwHZqMky20FlWEYbbExAu7NubN47kJsRoJKCCTlHSliPqwuBgxvM3pBKvx7U8Efdlfv7I+vHba04Bzk+hlFIg3uYJ4xGv99Dpm9wKgaPNPPxUNm9coF3lF/ap6mDmCdC91vE3pvFTuKtkuJYYjd2Q5Bsj/251E+u1XOEvDbchlqKEZZfMQygxLPI08/Smuze0/fHSjagenEaFHOfueIxnMnTedVAn1sbwx8qkDwli6fx59mQpcY1YqcA9jywRMpfJsy248InliWCbPrm1E5BS8U9D5uREEqc4Aa7KlHMz8iMGcWX5kG/RHcRFDiGzrjVhnKMSq00pkae/QVXQ+Y8/ch9S2DwKxWWH79DkaJu2agwIKN6XJlVl04punftBczTYHGV5DWFZPlmT84AFRvLogAaer9AO4SXXOhCODmCcHWjxLrk9o2yJ22u1K5IuLVanRorJ9NHOYUYSGqO+/YinDz6KOPJENxfvOirdbrbzcTefS78q1
 mNDzTH9o
 v6kGRYYZW1W6ThLry32zkM0qzhiDNhiyi9f9vNIU5ot7qPYiEgtVUNonMu366DgRDwJb2AE6Y9srkILQB90Kk3gLvu33MM3lBcbRqNAPBd63RoViGhIJAR9aL96IHduFEWsM6Mp1NoTTZT1MBRiUju1SVYQX4r2X3xfafhMzNobeKtvBomT530FABCAFcWuRbdLmEaVWdrsHDT6v6ebk9u6C3O4lGpd7gaqBPbXADEBIrm5pHdrP3tCviJ9vqHj70StmQ4qca/OWVqCy+YTxHuNHGkNQY3fhdqswm57A9KR4hbQQlhFgBKtEw7r/nZ47HARwU4cYx8IkJrxyzS5vJcsdvQnyqn1X3+rhaU480iNfe9uGhwq5+U21gGiivvmn6dlru
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 16, 2026 at 04:41:07PM +0700, Foxie Flakey wrote:
> On Sun, 16 Aug 2026, Mike Rapoport wrote:
> 
> > (adding Suren)
> >
> > On Sat, Aug 15, 2026 at 05:42:12PM +0700, Foxie Flakey wrote:
> > >
> > > Fixes: 50944692052b ("userfaultfd: opportunistic TLB-flush batching for present pages in MOVE")
> > > Signed-off-by: Foxie Flakey <foxieflakey@gmail.com>
> >
> > Is Foxie Flakey your real name?
> > Signed-off-by should be using a known identity (sorry, no anonymous contributions.)
> 
> Thanks for response. Sorry, no. A question, by "known identity" there is it
> means my real/legal name? because I have read a document about Signed-off-by
> and because on internet I'm known as Foxie Flakey in multiple places, I
> thought its fine.

It does not have to be the legal name, but we do prefer real/preferred
names over nicknames:

CNCF's clarification on DCO explains it well:
https://github.com/cncf/foundation/blob/659fd32c86dc/dco-guidelines.md
 

-- 
Sincerely yours,
Mike.

