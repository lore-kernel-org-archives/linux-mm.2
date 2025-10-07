Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04CCFCCA476
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 23:30:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31DFB8E0009; Tue,  7 Oct 2025 19:30:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CF298E0005; Tue,  7 Oct 2025 19:30:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BD1A8E0009; Tue,  7 Oct 2025 19:30:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0AA7B8E0005
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 19:30:42 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 925DB1A016A
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 23:30:41 +0000 (UTC)
X-FDA: 83972915082.28.26B62F3
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6BD224000F
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 23:30:39 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=AyijmtK7;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.42 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759879839;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rh8ozCfyhmaZ3ik2fPfPADB3YdiPuymeBZjBZkPgUH4=;
	b=xgNmmCloSzOg1I/rqpEStkxsDuvNMuTJ2MyUClPJBevprltyueJI2nwF7y0gEC1Fwi664t
	ohowBJsJ8VRhofXg98wuYs2k1sBY0qPIn5hdyy4d22BnDuwH8MrU5EecBcqDT+CuDoyVQP
	XKr/9LYqqUIjF9cGFge+X2AZ9rp1e7Q=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=AyijmtK7;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.42 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759879839; a=rsa-sha256;
	cv=none;
	b=ACydAAk5+MweIcW+YLKSiRqTMk1yLEWKivAgHbkm/K5oF3cTNFlAvPDhSFS9MundaQhBg3
	zO9/6aAg7W7sozLieHSIBi2hsnWjvarMFcxmT453vbwE8DvwLoB9s+qN34Jprzdr7nnj7+
	9m2HWyBOLQN6Ic6ONjJ50lftadcu0n8=
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-62fa062a1abso12701061a12.2
        for <linux-mm@kvack.org>; Tue, 07 Oct 2025 16:30:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1759879837; x=1760484637; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=rh8ozCfyhmaZ3ik2fPfPADB3YdiPuymeBZjBZkPgUH4=;
        b=AyijmtK7fbPkb5JVotGvNxTbexYK/SIXKiyBEAuQHhkvrrf033fvpqlWjz+TfzrX0a
         dHhcPbRK2fZDT7hNrNCgNgQUeZlA7PC4GzW6pFE/fWzVsQNw8sKW4dqCo5h8mhaNMldI
         v9ZK3SDIH7qrfgJ3EJHwucljIkOHVn4FYrMiw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759879837; x=1760484637;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rh8ozCfyhmaZ3ik2fPfPADB3YdiPuymeBZjBZkPgUH4=;
        b=O29kY0DdVhkt1q/8dVvPol6Max6RYbCK67CqYXsUWmdaHpGTDdlPfd0cjKf0n8PUIp
         48vjw3nLGtHwO4x2Lu+wJcp/ObZRKvgcmR151pWHncqHflNSuQPYPshr8Zhst4TbXYZg
         BUksIXheL/qkMnQNLO8f7ls23NVVE2Yd8iz0Pr+3EIQTmQ0fKtPfWeEiR0ZQFWTifNtL
         t+N6RKg6kZREUf6nZxvREjXZrcht5rxPoYmCJR2Bn8AvZOnNAZwpUyfCjG4dvFBEsjm5
         qHsu6yIC7lUoYqZIQYA30voj9faf2ck1ZrThXrngnVPO7vyOxg7X5t87FiPhiGWqbEQu
         IbNQ==
X-Forwarded-Encrypted: i=1; AJvYcCV5KNczWR3vGeLNdI+64N5HQEzYY5SpYGWhOI4EBa5b8CF7z8keQTI7huykARQXYItLE33o2OiT7A==@kvack.org
X-Gm-Message-State: AOJu0YwD7n2ey7GO7JQchbBJElIgSw523o+O6HpJ3hvYC73HTKTDV78B
	gTw0oohNYEHOfFlZEGzaN7aR+RJN9NJOXBVOMvoM9wqUqhECiPI3jUwDJBBQNHGwiz3oi7fuIrg
	Ns2PCUiU=
X-Gm-Gg: ASbGncu+mGRXj3XS8RaFfTRx+4+Xzpu8XIYO/z+aORX298zxg7e7x0PmEuQOB2EjTyA
	Me28wJdApHiAIPRizLPRd9GvQ1QHDzp7PGbks0KW8z8BoJZ7oKZBiwGV8LTS4vCUDqBImpuMzaz
	QqJtXuEBhWfzJA5caWn4y3CKX5+/lHeYDVfbux+RuuLMXC5BT+gie11Ec5f9pKxhmWDj4daYw5q
	vqBuc+JxdYDeJ6gL85HjkuwRXueLjYNwXg5bnwmCjX1L8WB7Kxr+bM4zFSfrHQRNoFsJH7LOnO1
	jlnjOyUXL7bxxNfDTq4OX2H/A11/okvPtgPJPIW/qhv+9zWUhe0kRBf/pTT/JppcITRdcOTzDkq
	V4DBvmnDmbj6g9KBIMgU51o8zCn5z1E2j3lSXZKmh6CtzNxLb4xm+zUilzf0ixXDx8StbQZCY+c
	J8ykFxhqCqReT7Xmz5d+DV
X-Google-Smtp-Source: AGHT+IHSymqAkeFylguYiKUNmdArbDOTtaxDfCszc/YiLlh0cVlK29zpNaWADxSkaajLMCj5MoDO0w==
X-Received: by 2002:a17:907:86a6:b0:b2d:d73:de59 with SMTP id a640c23a62f3a-b50aa69da30mr155465866b.9.1759879837630;
        Tue, 07 Oct 2025 16:30:37 -0700 (PDT)
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com. [209.85.208.45])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b4c83adec08sm798455466b.56.2025.10.07.16.30.36
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Oct 2025 16:30:37 -0700 (PDT)
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-637e74e92easo11536524a12.3
        for <linux-mm@kvack.org>; Tue, 07 Oct 2025 16:30:36 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCX/hhuIz9wlBfDA8w9hZEMWGlvmSa8fE2AqCajROkE3znBrBxsHYPhP5MedL+ekJfBh7X049MWYbg==@kvack.org
X-Received: by 2002:a05:6402:40cd:b0:639:dbe7:37e4 with SMTP id
 4fb4d7f45d1cf-639dbe73c97mr263633a12.25.1759879836643; Tue, 07 Oct 2025
 16:30:36 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wj00-nGmXEkxY=-=Z_qP6kiGUziSFvxHJ9N-cLWry5zpA@mail.gmail.com>
 <flg637pjmcnxqpgmsgo5yvikwznak2rl4il2srddcui2564br5@zmpwmxibahw2>
 <CAHk-=wgy=oOSu+A3cMfVhBK66zdFsstDV3cgVO-=RF4cJ2bZ+A@mail.gmail.com>
 <CAHk-=whThZaXqDdum21SEWXjKQXmBcFN8E5zStX8W-EMEhAFdQ@mail.gmail.com>
 <a3nryktlvr6raisphhw56mdkvff6zr5athu2bsyiotrtkjchf3@z6rdwygtybft>
 <CAHk-=wg-eq7s8UMogFCS8OJQt9hwajwKP6kzW88avbx+4JXhcA@mail.gmail.com>
 <4bjh23pk56gtnhutt4i46magq74zx3nlkuo4ym2tkn54rv4gjl@rhxb6t6ncewp>
 <CAHk-=wi4Cma0HL2DVLWRrvte5NDpcb2A6VZNwUc0riBr2=7TXw@mail.gmail.com>
 <5zq4qlllkr7zlif3dohwuraa7rukykkuu6khifumnwoltcijfc@po27djfyqbka>
 <CAHk-=wjDvkQ9H9kEv-wWKTzdBsnCWpwgnvkaknv4rjSdLErG0g@mail.gmail.com>
 <CAHk-=wiTqdaadro3ACg6vJWtazNn6sKyLuHHMn=1va2+DVPafw@mail.gmail.com> <CAHk-=wgzXWxG=PCmi_NQ6Z50_EXAL9vGHQSGMNAVkK4ooqOLiA@mail.gmail.com>
In-Reply-To: <CAHk-=wgzXWxG=PCmi_NQ6Z50_EXAL9vGHQSGMNAVkK4ooqOLiA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 7 Oct 2025 16:30:20 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgbQ-aS3U7gCg=qc9mzoZXaS_o+pKVOLs75_aEn9H_scw@mail.gmail.com>
X-Gm-Features: AS18NWA9Q8bImiOINU0aBi7Bh8WTXoi67-A8OJXyv8c9c55rYcgKothlbnB8krQ
Message-ID: <CAHk-=wgbQ-aS3U7gCg=qc9mzoZXaS_o+pKVOLs75_aEn9H_scw@mail.gmail.com>
Subject: Re: Optimizing small reads
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Matthew Wilcox <willy@infradead.org>, Luis Chamberlain <mcgrof@kernel.org>, 
	Linux-MM <linux-mm@kvack.org>, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 6BD224000F
X-Rspamd-Server: rspam03
X-Stat-Signature: j3ttz76sqw7d5zweu7i7esn56985xoh3
X-HE-Tag: 1759879839-139090
X-HE-Meta: U2FsdGVkX19MU0DhOyBy4sS+axfEcHDTa4MRPWs/xic+szMjIl0ePi2EWu1G7EMnf9NIO6FdAkhg4dXALbHlGIHAoAA8tb1Zc1ECk62xV6L1+/dfEqTEnb8nKc0db0dD5FwWF2GDbbHnBtsdyINLwUMvcFePsvM8H5brjiq1egWkmt03Cru71Zgy396ih0V/LHqEe7qqSlJ8iuGY8MyC4pZTfFNBdv2hTthgMhxKJjtOxOOtRFW1CrUm1eKKQmjFJcxFU54r/dmfcKLUw/7VMV+YbQDj4JmkJR1V2LfZplrSstqt/e6/SaW/yk9NhV9MAt5UN6JBk1uF6VXT2ePYvde+Swq3JbO60IJ7jT3s1PmWm1A+yGuzre/f5J3HODecx09w0O/EcSxZtkmcEs5nDcPf7xsaxzVNFUzsFh3tpVzSVsQwncFdhCys1A74TX3tQt8y//idUU3mKYDVgnSEE3xAA2kvtNGqI/6MszPZ7AmZGwFXXzFwsWe0YUnlbT9R5plr6DWTIOG4b/KaInHAYeBHPiOfBOX5+A2Vo0Ce4vSA1+W1jyBRNAMp6M+Jz7MirDUCVg+XOi+qUXj3YJ5LyK+ATXlAhgQ4tGP310OjEr+bdSvYfrUAjKHx/qzcyageYSr6DOiDZJ6g+zfV13Vjdt4oj4BwhUidKleo4eCujdBoc9wwYu1zwaQq0HOoEnKlZ8VyPwHLR8VOlnfIEef7lACdTrSinzHuAVkp3gzeKJMZianCFSuLD4quFkdgaeqUdyizvoJdhdERGqYgphl6FGEG75m0tUhoIqLC1LjRG/oW9gUYCE1Z4Fx9H/KwSif1TtUUIQFrcPzvtzQ5l/ofGd74YHoMifU73VMfUUXkfN9+gTX6cHFTviDubU4erkxwVVkkQtoG3/jk7T/9dV2tD87gkwKUdwrARsL6K3SOlu73E2gaYqOpd5wlhTjpef4eq1rwbnFomp7PeAqeiWt
 mFg5VxcI
 OHIN8xb4VyxRVN+zyODR8aWOx5+ab1obGg2RR5FVbCA4O8PyjNzgzli/oN559ZMVHNRJ5z6XU4YsgTXNutzO1+G41KRnpZjCbz/R/wWZOGPerInb/IbPR8HHl8ch8DO9TOQbr3Mq5gCsjx8I6NbEbNf0e5+zd4jIrzH4RGdQ5w5VFGZUjaw5/S8AIi+ehwa1mXs/h9r55Eal3Pt8fvDbB4uCwwa9/5n5XZ9SjcWrIDCfOVPQ5s+FZSkvCl1ae0TfBOaaycsJtw93eYNdg47vUJ4PtwSUttUbykI4xIl/zANadu/RbQpdgZUEYUoAf/A512/b3Xqrti1jxkElyzcaWgs8gEBJ3jYELvlqHz9Hx8gYSLeCRPvX5a0H6XBLUyURTFW6NMfyNWDDNf1dOW9Cly+vkSzKqyBD1akT50f7ERmLff2yP9knRJMwzvzO2oYbJXrQ0UV7eOMdm2Ko4U/LoSRL0QoRsn9hQtmFkOzHFpWaOn/Jjd+6vXFcVITel39wYIUiB5UufnBdKVyG0fiN2ysLfsA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 7 Oct 2025 at 15:54, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> So here's the slightly fixed patch that actually does boot - and that
> I'm running right now. But I wouldn't call it exactly "tested".
>
> Caveat patchor.

From a quick look at profiles, the major issue is that clac/stac is
very expensive on the machine I'm testing this on, and that makes the
looping over smaller copies unnecessarily costly.

And the iov_iter overhead is quite costly too.

Both would be fixed by instead of just checking the iov_iter_count(),
we should likely check just the first iov_iter entry, and make sure
it's a user space iterator.

Then we'd be able to use the usual - and *much* cheaper -
user_access_begin/end() and unsafe_copy_to_user() functions, and do
the iter update at the end outside the loop.

Anyway, this all feels fairly easily fixable and not some difficult
fundamental issue, but it just requires being careful and getting the
small details right. Not difficult, just "care needed".

But even without that, and in this simplistic form, this should
*scale* beautifully, because all the overheads are purely CPU-local.
So it does avoid the whole atomic page reference stuff etc
synchronization.

                  Linus

