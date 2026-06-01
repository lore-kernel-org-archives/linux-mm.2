Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23A5FCD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 15:50:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F2EE6B043B; Mon,  1 Jun 2026 11:50:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A3F66B043D; Mon,  1 Jun 2026 11:50:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4932A6B043E; Mon,  1 Jun 2026 11:50:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 337626B043B
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 11:50:23 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D33B78ABF9
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 15:50:22 +0000 (UTC)
X-FDA: 84831780684.30.0FC0586
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	by imf20.hostedemail.com (Postfix) with ESMTP id 988401C000B
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 15:50:20 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=VaxTE2p0;
	spf=pass (imf20.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.42 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780329020;
	b=75XMoakJvgH4Kr2mxSisy//z5pt0FXHY/9NTn78ttKmW8ZGE05+ZF4yf0TQ7sVQPMdQqNt
	SZ4DZnXi5WBuIgYCZBDyV8ZUWKwhdQXMM4QdYnErKdssnHw9LM9vPty6ht34wCkKcURBHI
	8VBqr04K63hDWSmtoImKwonqYVDcxi8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=VaxTE2p0;
	spf=pass (imf20.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.42 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780329020;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pJkQdYMeeClMSzcCqfeyFg/QAKx7SzNPdhAZ0oh+sp4=;
	b=17/H+CYtlXj6PTblhsBR293HIzyRAFsH9rLulRz+Ok/V5WLWRIbQiwYUc6sQH63Ax0gwcQ
	AuNYUGSrKQel+m1CKi95Tn0KPzqnAxBjiBqWmQfn1zYV8rXbYun71Vgkt19Nb/9kdhpQNz
	Vldirr0zc7jK2rwpMwYNyTWAl/EQqpc=
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-bed4cc46252so178056766b.3
        for <linux-mm@kvack.org>; Mon, 01 Jun 2026 08:50:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1780329019; x=1780933819; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=pJkQdYMeeClMSzcCqfeyFg/QAKx7SzNPdhAZ0oh+sp4=;
        b=VaxTE2p0kpOkvJcplMronR84FMvPFEIeqK3Xfh2O0CXNK0p9MwRuMyFZUsYpENaJX6
         HxZFT5E71PMLrlAhlfDAOwd+WYSnXev6Funnl/lpbPeviFJnztXqZWu8JUTMGefjfbtc
         7TIDi4au+EtliFb6BWQW5FF+BHFOLlHXUb9+M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780329019; x=1780933819;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pJkQdYMeeClMSzcCqfeyFg/QAKx7SzNPdhAZ0oh+sp4=;
        b=aXe6wUDYcIOuocabBQAdhsWd9r5HFBUjbF/yyBIJqm2wELPpkvqm3I7An3teq06BNu
         r0WrBCcvHOfzM2ZUTvL/VzDbGgFmEG6h6GllMMZQOKcB0roZY5BhomMa55QmLk8n5UyH
         No9VgZi/lwU8UAuMpt1jG+xDXfj7RxE7zhjmKfkJXURw6bQ+M4wtuS6+PdXBP5+Eurl6
         kQkWYp3UfdPxem6jJSVxsOQYGto+CS+fx/52MUt5/X2FkdNv1EC8nlaiZbs9I4AL2WEC
         ospNvG1VUTEz9kxkVbHbuOZXtJj0PWayfc2zH6W3soOAnrsfSDYZdt+0bPFYsE7ES25P
         npEw==
X-Forwarded-Encrypted: i=1; AFNElJ9B0YKBdLAOvVCf6ynz4W8cQRYMoM/8lVH+Xc+bZEIDda2jMaJ/qxA/TprphFtTR3fqFlc7L2vAGw==@kvack.org
X-Gm-Message-State: AOJu0YxHJLD3lJn/4JijmahhtGrm6a5RPB8i1pE6jGI/ttR2bnp4ndE2
	jvk3OwNnHqCcI2MmnL+MlrSY7O4u4QQnsY9iHdIzRW28D1butyoItuO94UGUad3hXmuTTGWCKL4
	0E9DmJ0g=
X-Gm-Gg: Acq92OGHOtuLIcrnTGUDYAw3wJatuHV8xgqJvlyRa4tI1NzbQFmPnOTWLuZ30QOqbXf
	xepIcOMvyPa1AsCCkzBHt1DoTh4XBk6HiNaQlFojav1wCo3nqghtq3eCgn4e2GngDAP4NfrLUxV
	IGO1Neo8cX/ZRfxtXfE1QdokK77c4ZiJVm9B3epnsGfg/Hpmz2IMYq+7YPe2X6WHGbDvsjCrMjh
	C92iF6Y8E2K+QjYxS4o03aAF0C18eZDmOUzmuLVECRlcGCfdSESMuQr7UB4PTxJWvUDpp8lfPTJ
	1blF+kWBQyE08uUS5OhKvnhhFiz99h8rDgOX/KbBOQJef/uzdnTOLL7njncGz4T0p/ZUcQehDAG
	OCCxkBI5W0p+d0w4BmoInC4AUAOdpXEVwxcOXSZ9lnzCTbsgvEoeJUs5MN9Ozbwn3QW4O5zuyAG
	DwoS51/FiAYhZYRQu7eVzRt6iMAkVFR0/0k/JmKKQLlkB3DKqgGHAxP9oPq2ro4+KbbdjxJf/yI
	XtltqQXAtY=
X-Received: by 2002:a17:907:7f8f:b0:bed:6e53:bb16 with SMTP id a640c23a62f3a-bed6e53c9e9mr330322166b.43.1780329018907;
        Mon, 01 Jun 2026 08:50:18 -0700 (PDT)
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com. [209.85.208.54])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-be9d2de536dsm350242666b.15.2026.06.01.08.50.17
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Jun 2026 08:50:17 -0700 (PDT)
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-68c19f1f3ceso4804561a12.2
        for <linux-mm@kvack.org>; Mon, 01 Jun 2026 08:50:17 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ98LBA4EwoDJFq4SqyKzGivLEdQ8+kly3uqlpCzGCn54igS2dslL+jotsr42UaZoTiUrkf6Oxx1kw==@kvack.org
X-Received: by 2002:a17:906:2929:b0:bec:203f:7466 with SMTP id
 a640c23a62f3a-bec203f7742mr316403166b.8.1780329017245; Mon, 01 Jun 2026
 08:50:17 -0700 (PDT)
MIME-Version: 1.0
References: <20260531010107.1953702-1-safinaskar@gmail.com>
 <CALCETrW__=8mSusayfXG7UFCfue5BGbx+vqESj1d9wqOfX4s8w@mail.gmail.com> <ah2nBAdsE5vVJ2PL@casper.infradead.org>
In-Reply-To: <ah2nBAdsE5vVJ2PL@casper.infradead.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 1 Jun 2026 08:50:00 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiFuud0Nn3B9YpTWyQja08TeXVk2AB-aAkmVXyigOagbQ@mail.gmail.com>
X-Gm-Features: AVHnY4JDfRzuLw7CK_4gSBHmXbq5FWvfpfspaVnl7J1jkuJC1SncFOzqHbctZiE
Message-ID: <CAHk-=wiFuud0Nn3B9YpTWyQja08TeXVk2AB-aAkmVXyigOagbQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
To: Matthew Wilcox <willy@infradead.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Askar Safin <safinaskar@gmail.com>, 
	linux-fsdevel@vger.kernel.org, Christian Brauner <brauner@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-api@vger.kernel.org, netdev@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, David Howells <dhowells@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Pedro Falcato <pfalcato@suse.de>, Miklos Szeredi <miklos@szeredi.hu>, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 988401C000B
X-Stat-Signature: nxzjxckeiu4fjcosbppqgd8p8tn5e68d
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780329020-659457
X-HE-Meta: U2FsdGVkX19HaUgTwGG8TrSMiD46zT01BdggwRTkJxcOXn8rD0kh1WPTDSBrExDHl83KAoBx+H4dMmk+qxjzF01nenSWZheBDKfvK48hJp3O3SybMSIlJ2LcACEzP4FaRLVMrt9iRVPaw5PjoqLOkKCt1SHWrADOIpexsmt9f46o5Gd01HrO4+P2b3KjTzkWBh7NAOcLoKr2GmcqvlryDPEFwwdarkYGM3fzj+6ZLQ6nO8NG11DC4fKKiQmWrGBPYkxJeWUCVIWi/HmwV6Njus5DEtvSFYnR1MpLxkfmbKsk4DWlSH3/ZXVEEWxK3bMVUh0zGtLzQgsi03Yf6eZdSUlLu7uoMfxt9lEkfxP81+jmdULYK6ts3XI7AGC7JIMmZSZ8t7pHgXxw76TXtiaRlhHe0VJ7y6h6qWwDY6ia8qLmlJS1yw0+Gj18UXQ/BE8hEm6YKg8hCPYKhjJnSGgxTBNfr5ZUccqi+2Yr8DuaT/hnNmqyEIiLwt1yNRW08zt9NNfQwKYOd4y0LCpLAeQ7mxZzIMlLrUp1YHF/ElFDqQVCwdOPECJPMSJZqKJ+tsEHhzJD+GLOC4/XkJJUObm0i5nj+9qqbkz9EiqRPbAS+KOl+1Q700MsUhOfUWZaarTEYijpdpqTJG2NJPOpt9COs3swB5bDXm75LL039O/QrtLAqK4GbToiWohYeYtwpBXYDtxYla4hcCfPv30qlBJrkEkYOjl6mqxozUG99b3Qr0a42N9m10NRgx5KFjcFh3jgIcWCjI6T+zBC0VHsFqVJ9ikGnFsI3ii4tSLeNNSgdqc+ERk05EpZMqDdjg/fsID1M5VAdp64HWjvx/lfDwJg2fqezL/gbLgFvSxXorKc4KaB9E7H54gNapnaXNSUtyFIPMrS1YUz8H4hTfj8XL6ZEOJq/Mhux7+QOjTKUxGpgPC1VF9rHEag2PV4pLKiZYmSEWWFdYlJTvcBIirNywN
 Ljd6Z3sy
 zXZhx4BfSNAe2Q1hE0QxL4oT4aGK8ocFRK3hZuMIhysqqj+kEwMGOfT8AOWKabW1/s9jyhHxd0SMkO9awMugwQ0tvRL21MDoX9NiaidJIApRTc9rE+iwbvS3attcpfPtHFwlp3PHYKwliR0nWK43g/B7fUpSoiSo6aEMQzMSJr+bCDA9HXKmlNxwz5niKySJ9E40Xv2F5gqh6kVdBkceOWAtQ9oC98Z7xakA9Op+MigR5INtOhQ+iCPXabXtiCWcrcMiJ5U1Bz/eSCRlvQ//NZUJhz4XioGunFJOQT6/6WhmfI4I/IXiZ4a8EWppzxowgaH88V1E6jFEqYm8owmPXun/01TDo9cNhMUr1ENTKeunDuA2/6H09pC7MSEdNp1BFOSOnmLy0djrr29xAxzmZlfTatjFeW5CpgOM/buerJe+95PtYIDRG8UGEDIHnVIz4noMLnYYgXZzjKHRFtiy8zr/pmaV4eKJXa9/yxSK9+nMdepT/4byC+5SSzdw5MTG9a0OUZV6nBDISunNaSbKfGYDytBsXSa7rWw9fisLEA3ZbGOsZOgHIpgB5uALTiSn8YVqsgJmErJV+F7O7LtMQ5nbpcWvFWDfKgbxKfzxG2ou8G8dpn8wfovn7ZkhHFDnKopCKPL7KJObRI44Abz+ORLMmCQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 1 Jun 2026 at 08:36, Matthew Wilcox <willy@infradead.org> wrote:
>
> Can we review this series properly?

Well, since it pretty much is what I suggested a few years ago, I
certainly won't NAK it.

And the patches looked very straightforward to me. Just the final
diffstat is worth quoting again because that certainly doesn't look
problematic:

  7 files changed, 33 insertions(+), 204 deletions(-)

and it removes that GIFT flag that was truly disgusting.

So I'm certainly ok with it from a "looking at the patch" standpoint.
I didn't _test_ it. I don't have any workload that might remotely
care.

I did a quick scan on debian code search for vmsplice, and after ten
pages of entries that weren't actually *using* it but had lists of
system calls, I grew bored. So there are likely users, but I don't
know what they are and how much they care. It *might* be a big
performance issue somewhere. Unlikely, but...

         Linus

