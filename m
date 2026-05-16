Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E33F9CD343F
	for <linux-mm@archiver.kernel.org>; Sat, 16 May 2026 00:34:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 224706B0088; Fri, 15 May 2026 20:34:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D5056B008A; Fri, 15 May 2026 20:34:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EB4A6B008C; Fri, 15 May 2026 20:34:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F21526B0088
	for <linux-mm@kvack.org>; Fri, 15 May 2026 20:34:51 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4B5B540283
	for <linux-mm@kvack.org>; Sat, 16 May 2026 00:34:51 +0000 (UTC)
X-FDA: 84771412782.15.316F077
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 507F1100008
	for <linux-mm@kvack.org>; Sat, 16 May 2026 00:34:49 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Th5yLK7T;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778891689;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SSRLSiLHvsMTUqM1fqmcqAkSv54P3ERyzM0GK64mSL8=;
	b=wpJrkh8DLszIDKx80SJ6K5BmMDVog+gGW1NI1gGm+PXYBiqNBSNui64NfS1t1nMQt6CxIL
	e9J6H9r5fcKBGc39XpYr64celwEfJHSKFG68LvAnx0FYdTnFfUJ+VpNTlO8bVoQ33+Db4u
	bR3Sug8c153w88b1LGaHr66lAPG6EGI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778891689; a=rsa-sha256;
	cv=none;
	b=2So1y+atwqTaClhAzbizb1MCQNJIktHXkVmxmXpllad9jzLlX1UHdVGE3KWgxbbFV5/DRP
	qFnt6+FWA7qfIbFYAzQm0jBRhOrBWHZGI9Ztl7QyfLrHD6xis8p+apQw/DZuTzpbFWIP5J
	shHdO6zXRINYNj75XRKDHZqEVllFD9M=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Th5yLK7T;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2E9CE43FC0
	for <linux-mm@kvack.org>; Sat, 16 May 2026 00:34:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AE4FC2BCFB
	for <linux-mm@kvack.org>; Sat, 16 May 2026 00:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778891688;
	bh=AaDIO8BC97cLpVPVJV0rsfA2jZm/exIX/5ck6t/P5w8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Th5yLK7TygkPsoXwwPnv4VEIhusSe5RKU95JKLre7Olj08QRwn7X0DwQrg5qyDwXE
	 K3DCJajhqHgkYmFeazUp1JiyO+yHWB6wc4L+h47rmd1KGzj4BJaUgt57hCqz5Cq8he
	 K52chzK1QNZoD+B1cLFdzVdWnc6QXKDi4flHGqbBS66C2Fi1jfS26Ig7+Kmbc5/hOq
	 lHGvks39+cdWQOeX9wCz4c5Th100uomcyY1Lgs39fSn6kpBncLjJ21SpHB2RfYFwPz
	 fhZOhRwmmeywmh1OuDuuv+sQmSd5j/5VAIgX7j1Vu/Ql2izwQXanr65a54GOO45HZE
	 ky66epujdgPYA==
Received: by mail-yx1-f51.google.com with SMTP id 956f58d0204a3-6579254f996so545522d50.1
        for <linux-mm@kvack.org>; Fri, 15 May 2026 17:34:48 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9+f/dctKw8Y1NruS51vVq1xrNK7agEuknyB2+wlxagJ0/v4ptcIZwHNT/+msQBn5af4VAzCTSQGA==@kvack.org
X-Gm-Message-State: AOJu0Yy/CYlCqbN0KeHzAC3K64KxD/BY6gp4/VgUM/HmfnBKkI0FQYXk
	NOcDpRMj7L5xTgbWYzBr+Xw2GZztaSND0bB98xC9qvhtHfB2cQkO2Y4xVvTQUCoMvkv8+jvSRws
	c8AV1XsG/JgppoJfuWZVqV+1jFkL62+RcHDuE73SnrA==
X-Received: by 2002:a05:690e:4804:b0:65c:4a30:3040 with SMTP id
 956f58d0204a3-65e2286adf2mr4539193d50.51.1778891687329; Fri, 15 May 2026
 17:34:47 -0700 (PDT)
MIME-Version: 1.0
References: <20260512104201.716213-1-baoquan.he@linux.dev> <20260512104201.716213-3-baoquan.he@linux.dev>
 <agQM8YJgiMxGlI34@infradead.org> <agSZ3hZJTBAjgVOn@MiWiFi-R3L-srv>
 <aga9jI0gc_-yxeR8@infradead.org> <CACePvbWT_7bzzp7PBB6FfuHymsnTbzgYd=eFzBsBsbTcPzWnjw@mail.gmail.com>
In-Reply-To: <CACePvbWT_7bzzp7PBB6FfuHymsnTbzgYd=eFzBsBsbTcPzWnjw@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Fri, 15 May 2026 17:34:35 -0700
X-Gmail-Original-Message-ID: <CACePvbU+whuB2G=kiQuRwJNaET+L982b-pETq-Y+qJ0Aq_kStg@mail.gmail.com>
X-Gm-Features: AVHnY4IpP_s1S-1sPOKiRJTdf9L-BXWKoK90C8XP2PmS4Lbxj91WLnBbhE8O9aQ
Message-ID: <CACePvbU+whuB2G=kiQuRwJNaET+L982b-pETq-Y+qJ0Aq_kStg@mail.gmail.com>
Subject: Re: [PATCH v6 2/3] mm/swap: use swap_ops to register swap device's methods
To: Christoph Hellwig <hch@infradead.org>
Cc: Baoquan He <baoquan.he@linux.dev>, linux-mm@kvack.org, akpm@linux-foundation.org, 
	usama.arif@linux.dev, baohua@kernel.org, kasong@tencent.com, 
	nphamcs@gmail.com, shikemeng@huaweicloud.com, youngjun.park@lge.com, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 507F1100008
X-Stat-Signature: mkt1c4bozjjd5mk3gpyzcr5feiqjezi5
X-Rspam-User: 
X-HE-Tag: 1778891689-416542
X-HE-Meta: U2FsdGVkX1+nvHHA1jYqaZA3xh32iT/df4Pm51vyYNuRt/Q8bsXpy4F0mtmn+icGvkpTx322NZWOUq1C7bsyFZ2oArx0ayZEJblMeJMg94JXsLTVm8zHfIkh0A1B5dUnYsG2CsaGyv2rTA4K2RDkunnaxXIY1bV1SYj7Hm23nM7kiGnHSDFVS15X6ernd/pHXtq/Os5scBmLe68E1BYSDri4DAy87+SLR8KL9Vw2KP+DamER5ckvggnBdtD3XpxfK+ldvXsgcQSSjHnxnB2WGs1HAlS8tDUBG0oxkK2EtisBlDaT+I+iOq5YFmbZq/VXAtCOFeAZBFhk/sa/zmmaMxPYCYXmKJLWj2Ab4oIMTWgjLa1FltkJM5qArehbp041eAWNnlX3iqb57E0g+iaRQphSFnv8Rix9VJvCu2nRR5x//FUZCoj/TISYIbsjMEycClCDcxlH9I1d4K1LqrtbuUkInrSFdHmmcjW6eisVQF+B0GY3QpGbG3qyK6GDCp2oaLUWw6+xQinAzLt3sKqz2tKvu321W92IuAIP+HYRFAQx3CKqcg9q0SWvldAIrS9UffbJpWvaAccHB5siaon2pYodlPT61XwPCFeub/sPxdyvUk1nMG79frw3ImR8UjQ+u7qi1YVjyuWQlwRl9eMJEsbP2sPtTpqR84axUNF9Rc9TZn5AD2ksTvcDpPROgavXZ4bTeMnj74iCZvQyWBBu0KkDD9LwOBtCkj6OC7UUUzbXl8DmxUnRqG0TnrIyIgx+7g1zDZDHTBrkBvzW4dUlmwKq2U1RDLggWuBg9UhgWbc1DM+JWrYiQ+zMU9lABGZU1fGg12rSmdgi4+ZT7zHT8Z8dmhSrV26XFdwTyxq7iYSYSkHEyBFAW/khdU4Enh8cFAadpFbZqGqqR4+J80YNjNCEfLFFjwSgm2vSAoTFh9H/iU1kXrIMHTeBY1Ay1T4LjW+SXyL90FCWsXDMp2P
 IKGaAk+a
 X1KRkh1Lk5ZQKDumCnVX2rV9KNqvqiDfvavxmFys3Gcpsu9RtWAqHM5aRmDyRnQWaPGZ7zxEnnKdPgq0kWoGmi/CbglyW2p/1AzSgNCyIUJ4SCBiZjtdK7k/TGUWqPWcbaGo2Q1w67PzvKz2gBDr+PYArNFE2ztZeH8DGQWlOrIHJmEnbZ2TrMHkMciTDrbauvTX4bqaiFqw+HmFZt68C3VJ5V76zfrtbKimpurZ5SOnTQYByWwoKvClZDcAdOex3x+VaBUskgegpz18Iq8rFpSvNlN45dPh7N0nbd4Pm1mTDQ7vjhBNhkrWJwKPbgsE/UBc70Vyogztu9o4hoaEvWgQsIjMXb7HLJ8Du
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 15, 2026 at 2:31=E2=80=AFPM Chris Li <chrisl@kernel.org> wrote:
> >
> > I've been looking at this a bit more, and I think it is going very
> > much in the wrong direction.  I've started drafting a version that
> > moves block to the same model as fs to build up multi-folio bios,
> > which actually allows for a clean abstraction.
>
> That is for the swapin_readahead() where multiple folios can be read
> in one batch, right? I assume It should not impact the swap out path.
> Curious to see what you have in mind. The swap_vma_readahead()  can
> hit more than one swap device. The current swap_ops is per swap device
> so your multi-folio bios will likely stay in the core swap layer. I
> will take a look at your new implementation; hopefully, the swap_ops
> can adapt to that as well.

Never mind that; I just saw your swap batching series. I will reply there.

Chris

