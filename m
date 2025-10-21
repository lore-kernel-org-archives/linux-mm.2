Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1BB4CCD1AF
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 15:47:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C6E98E0014; Tue, 21 Oct 2025 11:47:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 971878E0002; Tue, 21 Oct 2025 11:47:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83EC48E0014; Tue, 21 Oct 2025 11:47:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 668C08E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 11:47:26 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 31246486EC
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 15:47:26 +0000 (UTC)
X-FDA: 84022550892.04.BD5D0B5
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	by imf06.hostedemail.com (Postfix) with ESMTP id 019D518000C
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 15:47:23 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=YaJQxRVO;
	spf=pass (imf06.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.42 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761061644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r9YHz5AJsTnbPUUFUzOK0b5SHXphkm+yoYDBq4kn6CE=;
	b=Q99HkJFOc9xzzzphjpuTuG4goMSSNLRsroTg3U1fQA2S6T4Fs2LKtR0ZpzSMtICQOpkHyZ
	ZmFCjtoxCO+KfpDKglGW1L6cG6TSKq1trKAnCBdRtDJEhPhFVT5Y7DWL/wmvD/WT63F9fv
	WQAieNg4Eb9c1riZZEJW291FzoxzHew=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=YaJQxRVO;
	spf=pass (imf06.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.42 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761061644; a=rsa-sha256;
	cv=none;
	b=kEPYV9DmvBSt4OdizFTHLL2ENhTi7rfSfN5/MvLPMItpqjuZmPDJPv+NyrmQdVY/jZ8aUV
	JSDraoM62oIuLAfqxMQVPBcQcW8xFwN32mvS/xezvtQsOk/8ZXvhyBD7bu8I2TiMBr0AO0
	gYsu8QmYaKSeqYMzMYMNy34aSYCPuwc=
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-b3b3a6f4dd4so1094443966b.0
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 08:47:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1761061642; x=1761666442; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=r9YHz5AJsTnbPUUFUzOK0b5SHXphkm+yoYDBq4kn6CE=;
        b=YaJQxRVO5PJWwYw9WBhmhohDjgFx9EuOcMG+KTp9n0x4fr8u8ZJ5kZwYGgvMJ4sH4J
         2e6RHc1fWgnyGCiliF4fwd4Gv3Tzn0hRYqZQi7oX+tUR+80unw94CaKHllEDTakNvNs1
         2fiT/8MP5046gB3jXf1Z6mVFRhtl4CiZqOuc4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761061642; x=1761666442;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=r9YHz5AJsTnbPUUFUzOK0b5SHXphkm+yoYDBq4kn6CE=;
        b=NynUUzlJ5a+E5yfvl4On9YPH+OKdAljk4ax4bYkouJ6fphUAPOOt7Ulj2q570iE9W0
         XSAHaivfmWtB2hWDmeNx/CsR4cbO7/UMrHJcfvEtkWWkNkZbdPfFk383MQef3q8fu9kw
         axMQh/a/s+opEDKByimc57lg3mdqqgrs3HByhDELyeQnvBnNzwUOhOeoTs62pPnTwtkJ
         kU7VdHmNOJ45JkhJZTqOw+DH+QSykhmmpdNoGRjA4SYJm9H4ufmuLf+edfT/G2fEx2an
         NYdb64idBZKqmS1fFgwugjbLj+ekn1pc4aPV+Aw4VH9zUAVC42xbHZr+14/9pWuUY0eJ
         ++sA==
X-Forwarded-Encrypted: i=1; AJvYcCWs+U7OxkjUqRP7xTh1jE/w4SUElzQlNtOiSTGtJ6sN6RZqSzgRdxQqW3aUvBfQRJOdhkgsViRtew==@kvack.org
X-Gm-Message-State: AOJu0YylGSuP7GuNCrrhUKzPV3J3H6xhlTeX5yP3QDhtbAh5386qoxvS
	t6nfEAcltHszZjWYKH4mfWBs/sBxxNDfTRLus6iHXiUuf9uGQePH/v3EUsQQ4HVfjxqX+/tDol/
	riwSDhHE=
X-Gm-Gg: ASbGncuZSSZtA3MocmMaiSEnPpmZKQqW/oJRvKYPtOkrXUeVwV7w+O1dcbMbcG7Fxhy
	A1kt7s711Axfx5zaXnpxdbnk0FFjDFIxKDjnaOUSdLw8yt8H4qAXvhlTWRKnV66pVHWCI7gN/YH
	b5oj/BXm97MqvnrUhyWlL/4kD2bAjn3kX1Jr8IlOhJSlEF3Nf8tU+kU9forUXlnaVbf3mb1JfH2
	hh2dUvopQ6bqSbGsXM6hvtDaA5VWNiLRKmtoliZygKA4PlTXiVoXbb5cT9Z12Ns0P1rfHzBClDK
	0zwKkg+vIEL6JvaBY7hADou2V9rEFveTXJa/wN71aeUhQ+0Xw0MrbhO9svHyz9oVBrhkjo9g2JF
	FPx+m6xgYKa1lAhPW/I1rUA9xqghLniTKw9kNKxtHDa1cBrhJG5lHm1f0ulm1idbt4ocRUzMSSW
	iwoJaVOS0z1IrtE5zY+Nov+66YH1hI3V2OsnNcsfaOcF6w6BdfMg==
X-Google-Smtp-Source: AGHT+IGW9zaqepG7+lkatYgbIPPwFY2w3Vto84lAtKo9iwF3HUBGbVk7SGOBANcQaKcIeuroFOOcaA==
X-Received: by 2002:a17:907:7fa9:b0:b3d:7914:6bbd with SMTP id a640c23a62f3a-b647463a1famr1958451366b.22.1761061641862;
        Tue, 21 Oct 2025 08:47:21 -0700 (PDT)
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com. [209.85.208.44])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-63c48ab54b8sm9876368a12.11.2025.10.21.08.47.20
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 08:47:21 -0700 (PDT)
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-61feb87fe26so9304248a12.1
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 08:47:20 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXQrn9CbnCrt0i7cN2DRuObqNpqa4Sr4j8WRCJuMe7fm6JRpgyKZtUC60T5qPW68ZQrCToLOOmwzA==@kvack.org
X-Received: by 2002:a05:6402:26cc:b0:63c:1514:67cd with SMTP id
 4fb4d7f45d1cf-63c1f6da983mr16912137a12.17.1761061639455; Tue, 21 Oct 2025
 08:47:19 -0700 (PDT)
MIME-Version: 1.0
References: <20251017141536.577466-1-kirill@shutemov.name> <20251019215328.3b529dc78222787226bd4ffe@linux-foundation.org>
In-Reply-To: <20251019215328.3b529dc78222787226bd4ffe@linux-foundation.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 21 Oct 2025 05:47:01 -1000
X-Gmail-Original-Message-ID: <CAHk-=wh62OxWsL+msmks7=VdBJHz7HvRYoPDckkAEAwsgrmjew@mail.gmail.com>
X-Gm-Features: AS18NWAv_MfH5FLOB6ldL8Zj3hG-nJtcm__9IX9yFQBhtiHusUcNpFwx2FU0x0Q
Message-ID: <CAHk-=wh62OxWsL+msmks7=VdBJHz7HvRYoPDckkAEAwsgrmjew@mail.gmail.com>
Subject: Re: [PATCH] mm/filemap: Implement fast short reads
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kiryl Shutsemau <kirill@shutemov.name>, David Hildenbrand <david@redhat.com>, 
	Matthew Wilcox <willy@infradead.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kiryl Shutsemau <kas@kernel.org>, Suren Baghdasaryan <surenb@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 78c4ofwox654dzom3p6ashcfi6hpb1pc
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 019D518000C
X-HE-Tag: 1761061643-297365
X-HE-Meta: U2FsdGVkX1/QRkXq1B2TKONJgG+6K9W8ynttUbWDjREU3hsGC8lwr6Ul+Xg7vwq0cO2CQpitXGoAV18BIiFEIY3BHx82m0le4PgaK3dzdAqWwRH94ajeJklM/4+TlFeGqJRAhxdxPn11kTxURB7v4zVO2myzV0dx8YMSsE42F73FOjBhFvGvtbP3uGtzb2SBuw4XU8+B/QQ3hXnGxzjHZV6HfIfLyHjEom7UJNa4rRwk/YiQaQg+tPClJPvkA53b0JvBFZ4ynyxq/gN5tuTNvD7CcDy2EJKYV+LCIWLk0aS0WCr0xvbW2TInInZXHTWdCVWShCtbnrsQlSWxE4KlxWw8bwEbyaMVImgEe5+r6oJWQsLEgCyGRLs3H7L6k58ITxept+YuA5rOFhQVPPl45nUX7HD178oMbOLRg/WEQBIgTBBK1pxaCsN0iaNsVlZg86fw+DoSn5OxsTh5MlpnPIuXuEX5VwCcMsaCqL1dhv3UXSUlb5A0xlfKdw28jsTIFt+PkRtvCIYGPV2Ym45gRiTtBb1/mSRkP2WPBCccZwsFn8Rye1zb0kk1BKiDXoZPOynL1pgnG5p1Q4PvoGCTrq0+pUUGpsfqjd5j9DQryoecOULKCGxzd5vUtvSB+N7KhBco3OAxpmduYBvDI1O3l1ihfoxmJ8y2JuNB5BIQ2nhhhqEresCYimpRkb7kExUhUwY4iVhFAP07QggBjix3fCkIEsPPeqsA+Iakc0iCBwazSqKAzGyTH1CplGXqqrHz1eNhYecyXwDruDsyo6IyElS15YTVIH5PKCFuewduU3rnMFg5aO6aT+M1UaZm4h7g6R9hgCfbgpYbF6+O3dpYKNqOegPpfFKUDRM5jQ7hCLp6Hr3VO+FyPXGWxrHLNRdRzmpjr4xyE9yZbbOC20joaTw8Ql2UITPaKK9cUZiWQjVTWfS/QAJTQ8QvvdCBt4qJRWEAJ0tSYYo+2SClsxX
 MwEMyQOL
 AEjVJhKQkni2Igxeswa+uxGJUkbnc+UXbyV9jt6TPNQRJw8M5GzBWw9FpP0coJ/5iGh7P7TDG6P3DVN4hbK7rFBPYEH+IcIhZi4vdzxjMYg77RWn9wrwwMHgnNBOGlkZQf01baBVcQQwCn/mu0MJnMXt0Sp6HW7by15WHpuxFuN2pfTs207U1sa3OWbCPLas9h6en+lafFVhaV1bR0jQsT426uNEBA+GYrVCjixzTUTiD9pF6cfiHhjRuHDfZbe2zDzKdrgKfypNFzKO1bh0S6CLcQzOum25y+2PK2AVnak2qteh69SrBsrpDftLzIowoIs9ux97Ej81XLtO6+JIq2jES0yuJsFEXyyMVuDJFozmwvl75n+THLJ5N9VT2ABVat5gM4RX1b0V3i63INAOpjB9KU0Fbh6dfVP3ESe3w8uBjkirIczDjMQqAUaZ5P77r+PEKvYk68CxbZA9ty7V+vv971NhlAstSKLpfBVv8Tmg1aiXzG1AUQFVo6YhfREwoeKLh6rInEi24/dO5WQrgPFTe1g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 19 Oct 2025 at 18:53, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> Is there really no way to copy the dang thing straight out to
> userspace, skip the bouncing?

Sadly, no.

It's trivial to copy to user space in a RCU-protected region: just
disable page faults and it all works fine.

In fact, it works so fine that everything boots and it all looks
beautiful in profiles etc - ask me how I know.

But it's still wrong. The problem is that *after* you've copies things
away from the page cache, you need to check that the page cache
contents are still valid.

And it's not a problem to do that and just say "don't count the bytes
I just copied, and we'll copy over them later".

But while 99.999% of the time we *will* copy over them later, it's not
actually guaranteed. What migth happen is that after we've filled in
user space with the optimistically copied data, we figure out that the
page cache is no longer valid, and we go to the slow case, and two
problems may have happened:

 (a) the file got truncated in the meantime, and we just filled in
stale data (possibly zeroes) in a user space buffer, and we're
returning a smaller length than what we filled out.

Will user space care? Not realistically, no. But it's wrong, and some
user space *might* be using the buffer as a ring-buffer or something,
and assume that if we return 5 bytes from "read()", the subsequent
bytes are still valid from (previous) ring buffer fills.

But if we decide to ignore that issue (possibly with some "open()"
time flag to say "give me optimistic short reads, and I won't care),
we still have

 (b) the folio we copied from migth have been released and re-used for
something else

and this is fatal. We might have optimistically copied things that are
now security-sensitive and even if we return a short read - or
overwrite it - layer, user space should never have seen that data.

This (b) thing is solvable too, but requires that page cache releases
always would be RCU-delayed, and they aren't.

So both are "solvable", but they are very big and very separate solutions.

               Linus

