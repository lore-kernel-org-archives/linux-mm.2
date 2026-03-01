Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85BE6FD006F
	for <linux-mm@archiver.kernel.org>; Sun,  1 Mar 2026 21:16:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56F196B0088; Sun,  1 Mar 2026 16:16:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 550F16B0089; Sun,  1 Mar 2026 16:16:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4869E6B008A; Sun,  1 Mar 2026 16:16:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3A3F66B0088
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 16:16:23 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BF3C21607E7
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 21:16:22 +0000 (UTC)
X-FDA: 84498752604.12.94198F8
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf18.hostedemail.com (Postfix) with ESMTP id 91C671C0008
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 21:16:20 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=google header.b=XampiQsv;
	spf=pass (imf18.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.41 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772399780;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UMj1NdQkAnKFH4G8ljf+51uucnucuf2WschJdcW3ewc=;
	b=EkUz0hXlorQ0KdlHvz9Ao+zqeK5ovw5fnqXS/eNu5mwAXHKEVcZVZys9SbgcIqSjuos7vk
	SuZNhpyL5pjxufoE0qxMtpNyBtDVls7J8gyrBc53GtF/tUiQ1xqeEwJnhXYppzYlt5u0Bg
	bjrhDq8MIODUX6Ps8Fs2+6nYF9vXzmg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772399780; a=rsa-sha256;
	cv=none;
	b=xoNYnKEqUS8E9/AbsHlol66eRv7yiL+XbVDt+4ELbVNGAvt0C0eWPWitxCJz9sIrWYRQj9
	6nJryU41N2fXlWuGBRHeFFpvKPdL3thgMNt6TBdJxS6EUuin9FxYqMnya0SgyIz41vWTSc
	oHvYCRwsXXcCYWLQ5hlcYVkj4AJ7rEM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=google header.b=XampiQsv;
	spf=pass (imf18.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.41 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-65c0d2f5fe1so7655744a12.3
        for <linux-mm@kvack.org>; Sun, 01 Mar 2026 13:16:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1772399779; x=1773004579; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=UMj1NdQkAnKFH4G8ljf+51uucnucuf2WschJdcW3ewc=;
        b=XampiQsvD9tcr+/IjmJNl213miu/DVm0DYul3QFKqCHk9rc09oisSZOGtpDB0KTK4H
         Tq7J74LIh6Ti72ZB+3pxU0wPG3g6MS1mj1qGrc+6l0APvs0/eOcDrkkK1klRskTc0gsm
         XwgbXy/EKz/a7HS8bIghZzSH7SkLCefY/f7Ok=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772399779; x=1773004579;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UMj1NdQkAnKFH4G8ljf+51uucnucuf2WschJdcW3ewc=;
        b=GbBhOm08UX79TI0gM7A9IBcLgl4nNBftgXlLXqukuNqC6KHqMLa0pGe0G08yj00SNB
         nTJcNs1h1F2bOOvUgimm/TChmm43TFpU+Sl3gtYVBFxLGzpobFKNKQEpDnd4mLRntgWk
         CAzg19UPQVlRxxvm1YP2519UOqvzdPVWQ384OEij0CkHKTSOYcj8VNRDJfIh26yL8NeD
         JZBhMhS1dfpGFWNZcllqk5m8UFK4KX+1eRynSRW7z33K7KdLolpPIuzr9XKLEqC5yeGm
         miBbeVx3Vanl16CmRgEiEkhvGuaRxBjQKzn7jQjYfy1BCj8K1N7kYehP/9swevjhA1ar
         nU9Q==
X-Forwarded-Encrypted: i=1; AJvYcCWNA5wyJqd5XrJdn6IxsNWNTorjGmR+U+uWBC7f2w/XD30n87u9woaBbgiSWvKBvSqGTHrfUZqDew==@kvack.org
X-Gm-Message-State: AOJu0Yx+B+8QJTMfbRXtKlP8KmZwEuS2yJDA/aBHTNv9e9ZKbwbFFNdM
	K1z9eCGG8ojQc0n030Hh9UjSOfxZOG3LXcbuxn5JiwLjcdWYVj/HiIy60RW/aJwo33BNa4KWclE
	706LuQd16aw==
X-Gm-Gg: ATEYQzztRUI4Sp8xAeRwilperCS0NtRtaUbMbHvzCLAe/h7RI5cmCjS72f6oXdvNroe
	1ppQXz+zNOg2uh2t/zFFbfq3hWbmVmPaG5gIJD/upOJtLyGkQuimPM3mHv8V4OhKnE/5un2B9IW
	9UfOu3U45kHW/uPEnvN5JsgkYrakpnw+OCPX3QWWjzbmT5VgDp32+ZTXGUgpE+C9hlqdo1Mt3E7
	Z5ER9aE+baarkcB4+ARSGlrIppnVUz2KCL2cDpu2dgtU0i7TQv5apZ5uZr0vdH4FSZeA0iQb+5Q
	1EP7zDq9jjbeU3cA/9QDjfkV3Bryc/oma8LFkGMD5+59TtfTBLQ+UQYwV+pLkDGA4Uze+j9QxHZ
	JRBnhAq/ZrQWykM3zCe+RvH2nHPqvgWgExksGQH6u69gUH0gqF1nLtunKFSmUCQR9P4lWYKJEBm
	fw7NTgM5ptni4gqUAd5B3rXp29hHjwJYysrW3odl3+2Veyx29PIv+p74f43M9Wm108Ffe5OFw=
X-Received: by 2002:a17:906:3489:b0:b93:5e04:a74b with SMTP id a640c23a62f3a-b937651554amr533876466b.31.1772399778536;
        Sun, 01 Mar 2026 13:16:18 -0800 (PST)
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com. [209.85.208.42])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b935aead96bsm402125366b.51.2026.03.01.13.16.17
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Mar 2026 13:16:18 -0800 (PST)
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-65f9763e8d1so7384022a12.1
        for <linux-mm@kvack.org>; Sun, 01 Mar 2026 13:16:17 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWLjNK6P52Npe6hVDWh8OzRidAUQp+ztZu6xkuVj8Ho7tQLJIwtufF6vHR/AZqP4JG+9f8yEuEofA==@kvack.org
X-Received: by 2002:a17:907:3ea4:b0:b8d:c595:828 with SMTP id
 a640c23a62f3a-b937638a1b7mr696704166b.14.1772399777518; Sun, 01 Mar 2026
 13:16:17 -0800 (PST)
MIME-Version: 1.0
References: <cover.1772120327.git.gladyshev.ilya1@h-partners.com>
 <20260228141941.f6fec687aae9d80a161387f4@linux-foundation.org>
 <CAHk-=wgfs7KqS8pD8F9F9yC8jwSgQtmifytbmmXVfz9xXrQzuw@mail.gmail.com>
 <CAHk-=wgOxtAFf5XeYTcoUHSpWfMrgZaXKc_hrmqt6yKBdr=3Zw@mail.gmail.com> <m73zmq6jbdzqmxdjgnmfmd5h4w5a2khur7we3e64r357o32hfj@mvwcqgnuhzqh>
In-Reply-To: <m73zmq6jbdzqmxdjgnmfmd5h4w5a2khur7we3e64r357o32hfj@mvwcqgnuhzqh>
From: Linus Torvalds <torvalds@linuxfoundation.org>
Date: Sun, 1 Mar 2026 13:16:01 -0800
X-Gmail-Original-Message-ID: <CAHk-=whWnAqw+2YZ=LHs5C6ecGSLqgi+DxtJJ_p06rZsnosVKA@mail.gmail.com>
X-Gm-Features: AaiRm5130nQ4dJ2yvhpRtMsKd9eASFSLE84mzBSKaMmz7N0KtcGUPfWjVgBJQYA
Message-ID: <CAHk-=whWnAqw+2YZ=LHs5C6ecGSLqgi+DxtJJ_p06rZsnosVKA@mail.gmail.com>
Subject: Re: [PATCH 0/1] mm: improve folio refcount scalability
To: Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Gladyshev Ilya <gladyshev.ilya1@h-partners.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>, Harry Yoo <harry.yoo@oracle.com>, 
	Matthew Wilcox <willy@infradead.org>, Yu Zhao <yuzhao@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Gorbunov Ivan <gorbunov.ivan@h-partners.com>, Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Kiryl Shutsemau <kirill@shutemov.name>, 
	Dave Chinner <david@fromorbit.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: 131gzjqbttbrroopq9chqastpaqsye6i
X-Rspamd-Queue-Id: 91C671C0008
X-Rspamd-Server: rspam03
X-HE-Tag: 1772399780-237120
X-HE-Meta: U2FsdGVkX1/XhlVVm7iO7syESy9b8PcwHJD4zjfvYLax9nhSqU0sfqFs0HrhGguA/Oeh3U21OYoLmLzWw4SWrdB+r+ujno+Kq9CzLx6+nn1PNxLmYJQGRm37H1aQP7C8CgI7uI08EYNX7zijpgJh8cy+Z/v5XPYIqjIyoL73WRMGzJJS277Tj/ahtIPQfVL6/9tSRPYVu2oJily8UL2MnMopxPuRGyChpEMFcIk5Xt+qbdrxkoLUDFwAMiXUF4VgHzYWHUD7vjY6h/4W2ysINveDitkY50wj6BS9dcKfO6uBQv1K5/0Db0t57obrkZBjRxnCLFwFbqh8dID56wQFU3ttn/CyUEgN7eQsaXnWGLuvkLDqfDh1EO+lFAAsPytffcEwNk2ltvopB2UsbKKDhGNgYaCLEB6sM+ezVZIp0JE47UKZeVMUgzjnuQ7RTglA/HkoPYNmiNlpyEmUH4aUKT9mj/QMT0gprAHb9tdCwYOsIYTFgCdPhVNUCuuI4P06grUZmk6YmfVWn1fZZ2FAM2++Ibm3fFf0g1fDsTYFjLf7m4WhFUoaLNugTLQ/yxUcC71Na74tU0OfuSZmJxMEtX0F1e65/ByDRfAhBz9RcF1gWNXVMJXxjSKsLd28X+1VndzHVpW8sQZ0+lsrwjhUUSqnYkNMD6udQcbcLMPMpS5Nh7CRf979Wn56JUZvFzzRLJdMBZGE3EZK3TuSwaCPgMmf4zOoQb/1kX4p0xKYGkdd57DVaWg3JrUc/+idzDQmsWqu+iWdsIsEJ9oqFQpNs0tWBzSJGU500ou0ER1byqZItPI7pt/zd30hBZC8QZcNJ8Sak7oYK11BV1VusQfdEz6ra9YlOvMBQPb18EyvppoJaNGLgs1/1lVMG/mKwjJFx1h8cAPG1YzC39Be6wCgDck5mF91ucwdIbyXbLcXrEzdVIDHJMmLI5fQ3vF4zME6t6BZ2MCxv1DM7pg4MWP
 Zh8sgGYw
 3wwLBLlAVxjfjobZCZQ+kfH05rNVLLJloe4N/r/hFWgbRyNJMZZ57aFnekaUOC91MdRpFuwg6/qwYIM4nTuwGE/MBr45pwjvstjYLY81rwnoggcGNDqUWxr3hK8HF47FxK3oTVTOyIXhN8W5/MMsae2xWj1nQ2ctU1RXB29cTTk+xP4rCHrVDhrHm+4mYYQcUbLg/WE675+kF8XazwhlGhgZbbOZqVlNTyd0NfwaI1VPDKzXa2GFlTsiywV1jj9I2l5aDA5It0C/m4WAMphRRKYheS1/f4uf0XbW0kldnYuYGW0Jn5IZ5Te2BYQZorQX2y2COe2xBg0QaDHHOvroT8ebu4d/XpvPicP+D27V2HijZREo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 1 Mar 2026 at 12:26, Pedro Falcato <pfalcato@suse.de> wrote:
>
> Here we can see that the optimistic cmpxchg still can't match the xadd/lock addl
> performance in single-thread, and degrades quickly and worse than straight up
> cmpxchg under load (perhaps presumably because of the cmpxchg miss).

Ok, thanks for doing the numbers. I'm (obviously) a bit surprised at
how badly cmpxchg does - it used to be noticeably worse than "lock
add" even for the non-contention case, but I thought that had long
since been fixed.

Clearly that's just not the case - and I had just been overly
optimistic that the "first cmpxchg failed,  but second one gets the
value without losing the cacheline in between" would work reliably.

Ho humm. Maybe that "locked" flag is the best we can do.

             Linus

