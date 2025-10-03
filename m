Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24300CCA471
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 17:50:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 822C48E0010; Fri,  3 Oct 2025 13:49:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D2268E000A; Fri,  3 Oct 2025 13:49:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E7C48E0010; Fri,  3 Oct 2025 13:49:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5DF0A8E000A
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 13:49:59 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0DA47140844
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 17:49:59 +0000 (UTC)
X-FDA: 83957541318.28.BD364D9
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf24.hostedemail.com (Postfix) with ESMTP id D2FE4180013
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 17:49:56 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=V8cxYUPQ;
	spf=pass (imf24.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.46 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759513797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q9orV9k2QtGkHNb6/9Ad2/oxrPioscR2g9iCU7VwezY=;
	b=YkAYA/Ebo3eimuYGDcCC1mZbmoO4TSej3qidJsiAQvpJgWLs5ZWphAPSM8wEXhdrAeFaWz
	FEtbUuE6IlIFW9K5xbn9cKDeZ6+bGI5FTeI28qLZKTFwWvJxi6gY8lZbzNzhHIF48wR1uW
	1c2M4R5DdQ9D5rM0FdHOYGe/ORPscq8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759513797; a=rsa-sha256;
	cv=none;
	b=OdPYve2l28SnqPxDtrqoYEJTFzUcGiRqR1ZfzUns7VTKDHHNvAdY3ivgZ3o0iTKCvJN8lY
	AET+n6k6l5S0CNRc20MkMtz3mnj+NMxiF6S9dZ4wnjlg9lOv20WtsBQ4lVYvQxr5gMyyAH
	Ly+4YAQbpcZPRuGbJZRhWQQbwCRhF3I=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=V8cxYUPQ;
	spf=pass (imf24.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.46 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b4539dddd99so187930066b.1
        for <linux-mm@kvack.org>; Fri, 03 Oct 2025 10:49:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1759513795; x=1760118595; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Q9orV9k2QtGkHNb6/9Ad2/oxrPioscR2g9iCU7VwezY=;
        b=V8cxYUPQHpn8PX+Y3IuZ7xOZbfZj2YQ4Ctr0A2piItOUur6Ve3GOUyL9Pi7E4bBONK
         7y6clZPwdget8MNqz/Gb3u8rcP2QUv2Y2yJyj28EF7a2TRATo6t45vYrhdIrSq0vKAbM
         pBaQhyDZo+pH3nZiv/3pqzXDWyJGxdVG0fyTU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759513795; x=1760118595;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Q9orV9k2QtGkHNb6/9Ad2/oxrPioscR2g9iCU7VwezY=;
        b=gWtMnIuUDWDrND+YlKmqzhavK9U2bF1BDoFrpSbzIDy53HyixS/xMZKsIuFuowc/qu
         lXry2D+2sl9iweM4LxtBaP5IU/UcP5cNexO1kY1T636w5sUZ00HeoL2c/BZrXYfUmCnJ
         uayuuEYUGrYFonog1EcgDPzBmmMJ1ez45sDgCo+T7dnXbtE/euHaI6s4DUZcqygyMCj+
         3uwDphgic5T2nutNqRxaQKDvky24bDbWduL1QRYs4+0VNJZn3uKaotyaFwHrtT6p5zDB
         RcpdIzcC3vO8gKSapflf594A/mY1dcSbTjVUsayndAL+8GSZmrSEApK+Vj38295d2vQA
         1Rzw==
X-Forwarded-Encrypted: i=1; AJvYcCVMdxpM03EGsE2lsZwjkah7ZkE7wCCjza+8cVP6uiFWyMAdIuOUeo/+6LvagBbICSHf8tW8dx5JAg==@kvack.org
X-Gm-Message-State: AOJu0Yw8b5muDEHY4q33AFpP/AqRiXlTM76fvRQ9sKHZOBHXyn+qR1Sn
	q+wDmBsyHKdcXq0pvQYL10Js3eCW9vFph3aRwj0zRUWyc9vhegNq6m7IHmYIeLMdZdwvD93ASnm
	dZRjn4+w=
X-Gm-Gg: ASbGnct2ngaOXJZ2EPQsORxyr95wHC4C0zOUiNKzs/s3RJxnHduOpAYMc9Mi4RnNHEZ
	FitnLYW5RsUhvc7gxt5lNf6LEPLm3BaXwdbssshREWFBcYKY9WIzfMntLKR3bZAKlH4UbqBw2V2
	oy4dKbR1Q2W2D63yjxYhc6PpoUjBHbU9OSFkO3HrYZ9OU4jaew2PcoIcYtpAV6ULhPO2UPBGTtV
	AELaiIx22j2QJBZHe/IfrSfRqAPYk5WbOM3u4idQtN4PqDxg8DQwNoAE7eERZeIlRCvUykkyL7D
	xY1uTjyv2iZcTS8ayHaQ3/tpuWvfuvvp5cIM+lliWVuLyb1PTkFVp3mNzB5kX4wZr6dF4hQxeXz
	MqBjcDaor91BtAZV4arpAZ1v2gkYNtj4JSTw/LHQFcxQ/6j7QYro1dMYtIGi3tn38lI8X/nl4Us
	DgVVgCSiZyA51Rte3sjAg0
X-Google-Smtp-Source: AGHT+IEwqhXrFfVZDy0hjbwFtgbt0f7ya3d42rnaFAmcApkaYgjf/lHdpUYzPe2FPv7pR9M2xBNcXg==
X-Received: by 2002:a17:907:3f21:b0:afe:b311:a274 with SMTP id a640c23a62f3a-b49c2c5e006mr461997366b.46.1759513795046;
        Fri, 03 Oct 2025 10:49:55 -0700 (PDT)
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com. [209.85.208.50])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b4869c4dea9sm496841166b.73.2025.10.03.10.49.53
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Oct 2025 10:49:53 -0700 (PDT)
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-637e74e9104so1464531a12.1
        for <linux-mm@kvack.org>; Fri, 03 Oct 2025 10:49:53 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUDTvP1uB1Exy58fQDQ5L51sco2VK3oX3NyBB6KvIO4Meb7XmpKODiuY/pS5uiM5gE3wT7+a0JC+A==@kvack.org
X-Received: by 2002:a17:907:2da6:b0:b2b:59b5:ae38 with SMTP id
 a640c23a62f3a-b49c2761ad2mr539453966b.40.1759513793496; Fri, 03 Oct 2025
 10:49:53 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wj00-nGmXEkxY=-=Z_qP6kiGUziSFvxHJ9N-cLWry5zpA@mail.gmail.com>
 <flg637pjmcnxqpgmsgo5yvikwznak2rl4il2srddcui2564br5@zmpwmxibahw2>
 <CAHk-=wgy=oOSu+A3cMfVhBK66zdFsstDV3cgVO-=RF4cJ2bZ+A@mail.gmail.com>
 <CAHk-=whThZaXqDdum21SEWXjKQXmBcFN8E5zStX8W-EMEhAFdQ@mail.gmail.com> <a3nryktlvr6raisphhw56mdkvff6zr5athu2bsyiotrtkjchf3@z6rdwygtybft>
In-Reply-To: <a3nryktlvr6raisphhw56mdkvff6zr5athu2bsyiotrtkjchf3@z6rdwygtybft>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 3 Oct 2025 10:49:36 -0700
X-Gmail-Original-Message-ID: <CAHk-=wg-eq7s8UMogFCS8OJQt9hwajwKP6kzW88avbx+4JXhcA@mail.gmail.com>
X-Gm-Features: AS18NWCpojVY7tU6AsAPUiLSKBtubBWu3EjIOwDVnCZAtdMF_HXaZNsW5pD-5Yc
Message-ID: <CAHk-=wg-eq7s8UMogFCS8OJQt9hwajwKP6kzW88avbx+4JXhcA@mail.gmail.com>
Subject: Re: Optimizing small reads
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Matthew Wilcox <willy@infradead.org>, Luis Chamberlain <mcgrof@kernel.org>, 
	Linux-MM <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: yhouja1o473ukmjapd57acp89stss11b
X-Rspam-User: 
X-Rspamd-Queue-Id: D2FE4180013
X-Rspamd-Server: rspam10
X-HE-Tag: 1759513796-952365
X-HE-Meta: U2FsdGVkX1+V8GStIS8nC1drqhOBjTcB/7VFd5WiuvvR3/T+kbrX1zReV/fjx2pWhcNCbuHbbU9B4DjvwCVwNshJ8iFtWPJ8iswcJc3oHZUPPuWc8qevi7YObFEtfmeUlRhOk4Vt9EoAxjY97BIPa3CWqBz9UiE0JhOZRl+1KyPYVSIOJDhcfEbOISkynpKa15NivBS1teqW0jYNlF4i6f0d9LeJi4uUUI+8YuNowcW1hKMH+Ls/iieUzBNYWmr2OwckU/EnHzuEVQ+XWweRCshDTQE8mBTl9rIUj2XuZLkazkRJmBCAo3uy2AR1I05pCjBRYFcxv6vqJxsVKfdgMUvAr1zIt3ih2ULeIHMOL65cnmtPPKlhGhMyLYyVBF26U5EkHiz4mm7CFUUWbUX1lSfWhQtJKtiONV/R/AFZAx73pfS3yJ0/JDYJLp8SJS6jHl8vesB8+Wr9EyvkYUB15CTHJWcwMNqvnBRGU0AdTnNta7iRvMApYJ+oHMJuCVoLG91qYTPFFDv9SlYBPvyJOszqRDAA46SVVwWvCGwYcd4Ox47CSUEFm0O93RiP8jReINmGhU11QI3CPoFIRaBN2ekykX/R45Vr228lr21PKnHT6HLA1P7xfQtyMGGrr1IpmTekqi7C9PiGiNWUHclXbd4upGOqxG6rcu9o9c/pTGu5Do8edrJl2C5YqizZjhSdyyNj/OU5pFlZyfQPde2qdYNGekSZ5zwjaE9dV3HTKJIfVID08J0Bwo7+xbVXlxvqVt8SL2df63T8pCeuKnIa6KfkKAKXZdej6mJ3G2mhfegBJKSFLyfCFeJUaBZ5ASUluujtxofbFmS2NSIdeQclsPzqv6gZsj/Hg16+4DNdGr9PbQ4Ia16UewOK7vpITSBL4lI1tWTpC2J0aNL7Lnd0NVzWl1JmOiR9lL92DHQ3wI2b6LrRz1Ktm4OJWyfdKdxqcmy2BgQ47GZ+4wJPk1H
 TxssO1xU
 /LqzRa2URI/MbkXGFabJNHkFTm5NgTZa2QKy1jMSyVeyuJOZshH6zw6SRNhnt7E16V0V+gwnRWHQP4TLe1seuIxkdk04GWqG9FBqj5Uh0kkyrgT2MwZJ/+UEVEIE8NTJvPkPbVd2eaW5ERMwQb1/QdgO7m8yF2L3KulVOOvYd6U6Q3Yg9rI2cFoJ/GErMswzuKlgOuCWJ+hvs4RmK6THfzODRrufMX2r1m38jTYAYjiRCYkb9uji6m0GCxIw5kRMd9wDAnjGZdg5qlKwLpDL93hERBVRU4D6aX1l9VZfjwgXe4fgCxKlmncrJJFMTg3QpOdx8uHpKBoLQAwmz1gKz3r49d7INbFmp6DrKhFcYNublr93ahLky30x0q73ZBVZeVE3Xzo4IC+gN6Trp4WGviCAhbEdnqLxQaGT/65k4c0AxwfgQ1kY0LGkx9P7v4uz4uLm9/1+5e38U3Ck3Za8x7+vNjlevRRs5NEkWIWOj1//a5ERsmz5JRzaY50xnZy413LSF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 3 Oct 2025 at 10:23, Kiryl Shutsemau <kirill@shutemov.name> wrote:
>
> We would need a new barriers to serialize the sequence number against
> removing folio from the tree, but it should be okay.

Oh, I'd just use our existing <linux/seqlock.h> infrastructure, and
then those helpers all do the proper memory barriers..

I'd love it if somebody took a look. I'm definitely not going to spend
any more time on this during the merge window...

Back to vfs merges for me,

              Linus

