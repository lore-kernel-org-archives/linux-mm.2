Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E5BCCA0EE4
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 05:33:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BACDA90025D; Sat, 16 Aug 2025 01:33:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B84CC900256; Sat, 16 Aug 2025 01:33:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC13A90025D; Sat, 16 Aug 2025 01:33:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9D158900256
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 01:33:00 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0F3B61A038D
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 05:33:00 +0000 (UTC)
X-FDA: 83781501720.06.C3CE8D3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 683478000C
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 05:32:58 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=jevQ0cpI;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755322378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=40/Ku1IVsDg5CX4JpZHdSTkz4DhC4ZPnuHd8yIfZR5Y=;
	b=YOpCrjEDMuYZwMYYELKKmILckB+BSJyGxOXUl1yWBOs2UnihqAyxEhwuiAMUlDJurphL/x
	HGxl60+ldso3H61uFo/YvOpBdaPBN1EVQWUSTFHrsYnF0c3P/+uj1s1YxYwoAcGNYQLHWz
	UXWwc2PmSWKEjfqhTzjktxIadBT2p6A=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=jevQ0cpI;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755322378; a=rsa-sha256;
	cv=none;
	b=wUbcJzqXYmUqACx+BQpwLKaT4HuMGCVeZJdgy3cVvqrhWsr7+css+G9V6RXNbpC6LCQV2u
	wyD0s6+PMr2DgGQ31rajTUJfJCfyKOCNwwbbo5i2MgH5EI3AuCUnfrXLxLGIQjd9h0e/zT
	oCKnXEs5GMqxRQ7aMo1P41QFtc4GBYA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 668AB6141C;
	Sat, 16 Aug 2025 05:32:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF153C4CEEF;
	Sat, 16 Aug 2025 05:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755322377;
	bh=X7O1jVKovpwhLjSTwmeZcxswY/N3bjAaHeRDsMVRDag=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=jevQ0cpIKyiUMzImRBWj1P+2mNroXv7SJjyDPeyGcWpDY0PtiUhOccUUjkw37HCbo
	 0ZMnLMa4HUaVl0E1dvHSk6Eob7iSkd1+jgHli0wNMVkNK/paSYHC3HX5d5YDF2YvlW
	 6WyUttO9FK0ihtopVxsp2hq6TqYmtEACRZKSQFtk=
Date: Fri, 15 Aug 2025 22:32:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie
 <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Yu Zhao
 <yuzhao@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: mark MGLRU as maintained
Message-Id: <20250815223256.111f6ce04da3528fdf19ae84@linux-foundation.org>
In-Reply-To: <22qegz4vktquv22nome6csd4vngvwcaeydoyg3ttqoal5vum27@knjvryszxbdm>
References: <20250815215914.3671925-1-axelrasmussen@google.com>
	<7a46f7jwlwgkbdjvbxjaalrrdamgtxkptmytllhkr2qv4ovbge@nbugfzavwh5w>
	<CAJHvVchYa-vUcQo92awyHE663n-iMsLK31o+1FKrMvdLMAuUOg@mail.gmail.com>
	<22qegz4vktquv22nome6csd4vngvwcaeydoyg3ttqoal5vum27@knjvryszxbdm>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: jg8zkwuukkt99p4q3373j98mtdj9zprh
X-Rspam-User: 
X-Rspamd-Queue-Id: 683478000C
X-Rspamd-Server: rspam01
X-HE-Tag: 1755322378-865553
X-HE-Meta: U2FsdGVkX1/B+RMflsGwg+iuNl45YwU9Bi/Yh5W28MxtjBlFRfTDDMGGooXOnrmYOKuS1O9rc/vPpOmoHuLjORTIuX2bczWhVSiafFc1tF3WX7wI/wdx4kfa3MGpBzl8gsKD7cA2oSqNsSosXTmOsepIuqHCTL1Ks70lx53l5eF9T7O7rULwIvXYqLPgY9QpyXF0JCzuUsMdBpKvzzdi/KrC/41kyl4hi4y5muyypKA+UVj1NeCBR48isn+mwuXTZQq4y2bhEiwG6me7QWxQdlC3uuJ6nIr22BufXt/TAuOs2YFNl0se0KwawEYv3sgB48TQROBqXSAtK+MkJajTJDqi9C4IrPY8nU9HIFbSxYas/BLNcgiFiD64HGYANJBhu4X0D8LqghXFk3hdJvqf3ZKtH63Zy5VNe4Uconhi2ajAKVmvyo3fF4/PaGAOKuROP9OM5v5S1bVTpioV1WH+HxvJyBNn5e8oaIMtmWjroeT4WKvIprlTQ/F7R82ttcgZMnDBjXE3zs/x7I7uD5hYMvSk0mXlUv/m7ckBqrPVhHx+REj+BUgnIvrw5iNkhuyUb3v0+jqyjpu0apXC0B5MKczatXDU7MBTVLYyNZMpbXOuuNDbEp1hOlTtxvXnbpwnSpTmzY794hjpaRc71qyRF0q/4tJqZx7SerbcvwqBdWwVyE5DyW7Vu2jIKuhQ6okXguLEMFzBmX5FKIq7o10EBbS5EataiC+ZxdhOPDCdQG6MyPdibDYTUZza0cxizVsfgU1JWvQQGh2YpriSRNONlx+QIjBLL4upnWo9KtkAbbDGRQ2umy6lX9L4nlq0c2lfc5EGs8q9s9c9FBQrQa9ky682XJf6Pupyzn0hPT7HViYY/IWDwvVlj623W0IaTjNUuH/TnmdRc2IZY7lCh6XuR7OkwraTY8AZqM59/jsPUZlZmnQGAEJVd+bcjAGlh+/ClGziOuIKovO/kN3uEAE
 aJpce2RZ
 R2cggD13NCxwEZDm3ssGR7LFRsTMkgpE4ILi7TdxM2Dk7bvroLvTA9XEEZ6vJrO3lx9EQN4I/sA8iE48sW1+sOovToBh+AvcSUMUkUTkleQil7GtnwgZzvV7do4QN1ZKFOCtbqdJxNerPKSNDyAvruWn8Wr1SbYfUnvKjg2Q0b6Q7wqT1PfHkBRpamSqXCPR6nSHFCZ/ebgG0XZrnsOjvG6dC5v5f1Adt/2DmXqgg1oUaGIoB3FznbYIrlJI9fZWV/nGglaTY8yPafIKvG6XZUq2mVKg04vYvog8lsbtJHGIMQiNCT5giw4GAqg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 15 Aug 2025 17:08:59 -0700 Shakeel Butt <shakeel.butt@linux.dev> wrote:

> > > > +MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU)
> > >
> > > Why not just add yourselves (and the missing files) to the existing
> > > reclaim section? Eventually we want a single reclaim solution, so why
> > > not start with single reviewer section?
> > 
> > Sure, I can see the argument for that.
> > 
> > I suppose the case against would be, perhaps the folks already listed
> > in the RECLAIM section don't want to additionally get e-mail for the
> > extra files listed in this patch? (Perhaps mostly the MGLRU
> > documentation, the rest of them aren't necessarily MGLRU specific.)
> > 
> > I don't have a strong preference either way, I think mostly I'd be
> > interested to know Andrew's or the other reviewers' preference. Note
> > Lorenzo suggested a separate MGLRU section here:
> > https://lkml.org/lkml/2025/8/14/271
> > 
> 
> I would not be too worried about folks getting emails for MGLRU. Anyways
> whatever Andrew decides is fine with me.

We all like lots of emails, don't we?

I don't know, the main thing is to get it in there - we can fine-tune
things later if desired.


