Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28B78CAC5B8
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 14:40:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29A528E0014; Mon,  6 Oct 2025 10:40:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 272278E0002; Mon,  6 Oct 2025 10:40:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AEEF8E0014; Mon,  6 Oct 2025 10:40:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0B8978E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 10:40:17 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 98444BA618
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 14:40:16 +0000 (UTC)
X-FDA: 83967949632.17.55DEB6D
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf20.hostedemail.com (Postfix) with ESMTP id A61571C000C
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 14:40:14 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NyM8eJug;
	spf=pass (imf20.hostedemail.com: domain of amir73il@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=amir73il@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759761614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EkR1H7X+TDjtCRI9KWYEwXGW5NBq3MyXaQ39Dh/nn3M=;
	b=4CT0rx7NP5RsC+s3ilvRJOGX1Jvmudjk5Ix6PA+pPDM9IRka3zYAybIU0QXqcMrTflmG0B
	bU6yewQyXqiNr8vXVQtBeH9Cg9kJQbWWI/lqmRBFWNSDW+7ylaOPudtiVad40GGH5I6OXo
	VH35yKAiad6sAftARAicjo2F9Oh81Xc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NyM8eJug;
	spf=pass (imf20.hostedemail.com: domain of amir73il@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=amir73il@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759761614; a=rsa-sha256;
	cv=none;
	b=WWSe3WYwCYidyqHqTIG4GPWNTTt/Li1nUVZ4LvWe/eOYXZjDVhbyDL+nhi5+ISa1b8Nzgv
	GJHV5k3QkODjYqWH/8pi5ds1zKWvbtxNmdUlkyTHzkyjNMLX2bWtHlHKhM9Jv2xrA46GIW
	M4pg1FAiiNJrSqKkTgBrsPHcHU5g/yA=
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-628f29d68ecso12401448a12.3
        for <linux-mm@kvack.org>; Mon, 06 Oct 2025 07:40:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759761613; x=1760366413; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EkR1H7X+TDjtCRI9KWYEwXGW5NBq3MyXaQ39Dh/nn3M=;
        b=NyM8eJugTI5EzFwlTvbqRrmzKfLdE1KQ+66U0yCEoEOGP7553G0Dwucp9mz4NExus7
         qtPIHr1dECw+xCYK1sG0KLFlQzqzuzLEaWSAb3aIKCzAixYlUOGtIBpY8TMy7VwKD0pW
         UKzAEvDIsFa3wMg/MPuT6PXChkFbUJ8s7SJNsPqCp/9MBiH4eMcjWN9gRh2Lq9ICE9ET
         Fp129EZM2Djd1F1SGCpMPOfr1txk0bKKYSfx7qqQSwnKX6YnTj7u2/9SnLdN4sA4ijb2
         FJ4H5j/Wrzv8wK5IMIU5KulzG13KtH/Tvj9NdYtD7QzKPZ+GhEyWLT+/CNZxGyaLe9Gv
         f+tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759761613; x=1760366413;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EkR1H7X+TDjtCRI9KWYEwXGW5NBq3MyXaQ39Dh/nn3M=;
        b=AyYVLvsuyB1w+zKNU66XoWgbW4eaw1Mf4dxGwGV25ZRjuhTmS9vEOFiaG4C2auWb4R
         nnMbQF4DSbOA4BKswIW9cMgLOu7Q0Shd8MXGmE/DSCueeOrN4EIy5AKrtfs44FGXQpq9
         8yh70mkMOxG1QAA6mCH+Lrt1KQh9oNiJaQb3y7cvtgyaIDCmZVtvIKPkFy3IzAPB+uFW
         7eNw+GorNYRilrMbZi7Oj+L3YzZto90RFZzV4QAd7wsprgCoVwUfNxe6/eDdCUJhZWbM
         1LPY0mngiQEjhD4MAbkAMz2d56+gp7ueuoRtQLCeYgP+fwS9GL3+LkCqGYd1BdeLOXGe
         yp+Q==
X-Forwarded-Encrypted: i=1; AJvYcCVEDMftxWoH660AGtQAtEGnpwDZKiG8Nt7Sjn/LJSYfTqJYvb8EOUlSy1sXL72IsaN75F0VrtruxQ==@kvack.org
X-Gm-Message-State: AOJu0Yw9AS82rK63rje2K86DUNpTBthVfGg9+HO1tIH5jO3RPCxCvvmK
	wcyCLdEthiykXX04x8/LPF+xK5j/duoHlkuhIAxsKBJn+4XjIBMI7RAa1beOMkZ8PDggQxLqM0E
	Qa5gzv/db2Zc7bci3EiCAu9cR+SRQ7b4=
X-Gm-Gg: ASbGncv9cv2t6kku9bt67IF/Ij+6CwsI7M+RH9zqxiBrqTgd5asNjm0Fvia2P7qddMh
	qKtDi4VSO2PQDhV/1e9LPxxKkdzLcWWtJg8WKtdsxsDBeOp+Tmp231y6Kn59Eu4PzRZyTCMCFs8
	6AaWP4vmmLAYp5HiOMFWgLo7u6akGf1z08rPb3eepJuAqAY/LgGS8ZgFv59ZsPWYp1GY2PMsxuG
	ChmAR6ch7QnWgWOL4qSE/+0VCzHrLmVwQ0FJNp/KPL9GAmXNXVseoIE03nlGpN39GRjfhxVOgyl
X-Google-Smtp-Source: AGHT+IG7l9FcW7nFH5wcnGqf94SKHFIJbD02eMTFgXIso7ems2/RZwPOGR76iL5Jz5L+CD+kbTGEfLyCiPawWH7oe0s=
X-Received: by 2002:a05:6402:520e:b0:634:8c41:c299 with SMTP id
 4fb4d7f45d1cf-6393491e788mr15011143a12.19.1759761612739; Mon, 06 Oct 2025
 07:40:12 -0700 (PDT)
MIME-Version: 1.0
References: <20251003155238.2147410-1-ryan.roberts@arm.com>
 <edc832b4-5f4c-4f26-a306-954d65ec2e85@redhat.com> <66251c3e-4970-4cac-a1fc-46749d2a727a@arm.com>
 <989c49fc-1f6f-4674-96e7-9f987ec490db@redhat.com>
In-Reply-To: <989c49fc-1f6f-4674-96e7-9f987ec490db@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 6 Oct 2025 16:40:00 +0200
X-Gm-Features: AS18NWBuQFyxsQau3P8JL_AyINiEL_Ybt3_UNKcM6OGOrGzarzlxxcIDC21sR04
Message-ID: <CAOQ4uxh+Mho71c93FNqcw=crw2H3yEs-uecWf4b6JMKYDTBCWQ@mail.gmail.com>
Subject: Re: [PATCH v1] fsnotify: Pass correct offset to fsnotify_mmap_perm()
To: David Hildenbrand <david@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org, Jan Kara <jack@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A61571C000C
X-Stat-Signature: bm4oey6m43fycxxegus7kf8x4c8fzunr
X-Rspam-User: 
X-HE-Tag: 1759761614-463788
X-HE-Meta: U2FsdGVkX1830Q8OiscXoeJzA2BGmZDBgZC9MyZTpIFJCc3qEAv/9vfnqJjqtKOytsrieM4gAR92N/Sjwgz1AK4GvuzuQbvMTlPtjAyhPwRONAG9v7HpI02WDfHwqGnScQo+LIUR6P3ZjkmxZ3Kav7dfeHN83F3EmqupVg7JqKZkqABevJiC+Qjtpo+KgzKSWz+pLT85F7wHnvEIAMoqo8PzsNg01nLB1mlFSlARnd2oZJx872RKheiT0c/+dMNBfgrXrCGZ1gdbwkkFxuJQmmJgFUcENRDazsd7qaS7B3fxZd5rbEMCYIeAiXI/PDx3NDOwBL21w/lzw4uwZmnEyay1We25vLqpidKSNgUITwgFFbmvRdnOcVSm/cHRbXzhl6f+s0owB5VSrZJ3B31Ry1pLCTlg8rMN+XAIeOLNkzw6t/8h0uhzqcTmCdm9sMwY2zJqmUCKmla5K9AhTQr5b/oT7JrEOAIpIJHqF/umKIK6ET7RmOYgsrHM3qm+WG/EswF5sZhgtUDLDsJc9vEzrFOn1Wc5qZRp3pLTcFzYfoFneJkToXGIakKmH0DL6VOPiMjj4yD+QnGXJRUBl6JgjEcKO0oDTwXZ0LoRHws2hmdpwFvL4PubQnLfhZfS8GNqMP9LUlzhKtAPrh8gyWqQo31dZMq0zL5e3eg+kzu4wlrBmej7pde0vN1h78GqmNaRUXR7aU4RbkrOMDYB6xeWcfzhTdNVqbCS9FakYVH9nLU4IYLW60HpW1aIKHRFiTjqg0poxQsGV0ablJLi5VL4gSEmXrUbUNInXOZetNn8RwSr3RKrL91xuWn1wsMQZsqa20frGu7o5pY3ScWa9B+P3psr9CeekMCm0Cg3InSpxhkn7vDY9HxP7AfqVADHk8uxSXwJ2aaXjhz6SRtbSw0ulfUPCE6STz3vgSyBMUdm7xHHr7Ikf4pChbV6Pn+m2uRB17/9KnXzzgveAxjv+97
 GLwF0st/
 zI1BHoGQALB8ysuG/EEzrM3/mmJPRIuXp+2A437u2KuTExSZ3nldcz3PCbuQRf3LrZiZBOjsIbH5ew8Qi6F7zLupGz4z1ZpMvEcZxdCI/+8PPoEzfrxyohsgQPhekMGMjtmPtalPvSGY4jW21Fc54R8DidJWft6IeRgkAIzKq9Zfl/NDQ3733xTX6X4WwiOJQTkq3RpVWNLpuDuAenSKNi86nY+fCD4C6dZIJoQlAJZD5oIr22iDDNajWlwgzm8DwzqWFFT+uBVJp+jY/8OTPGZUNIiDzqrnSXA/+/PQprgQzcVeHCA42oWv9hmvj2+bSTGwzIwd6iSpnEmaTA+F6Tzohked2TkCaSxYMtZ9+14Jbe38R4r6e/Fz1Znmp0qCt16i8aPN2PQ93ltXJzJlgA7NJ38JXLPeH7f/AhDu8JlmoO05LPtRg9q3O9eyS9elO6oaLIrbF23mcY9y7+APu96JpQSz8YVGk/6Ihob8ZKIb33aEzaLLeg4SP+d9Os5V5MfVt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 6, 2025 at 3:53=E2=80=AFPM David Hildenbrand <david@redhat.com>=
 wrote:
>
> On 06.10.25 14:14, Ryan Roberts wrote:
> > On 06/10/2025 12:36, David Hildenbrand wrote:
> >> On 03.10.25 17:52, Ryan Roberts wrote:
> >>> fsnotify_mmap_perm() requires a byte offset for the file about to be
> >>> mmap'ed. But it is called from vm_mmap_pgoff(), which has a page offs=
et.
> >>> Previously the conversion was done incorrectly so let's fix it, being
> >>> careful not to overflow on 32-bit platforms.
> >>>
> >>> Discovered during code review.
> >>>
> >>> Cc: <stable@vger.kernel.org>
> >>> Fixes: 066e053fe208 ("fsnotify: add pre-content hooks on mmap()")
> >>> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
> >>> ---
> >>> Applies against today's mm-unstable (aa05a436eca8).
> >>>
> >>
> >> Curious: is there some easy way to write a reproducer? Did you look in=
to that?
> >
> > I didn't; this was just a drive-by discovery.
> >
> > It looks like there are some fanotify tests in the filesystems selftest=
s; I
> > guess they could be extended to add a regression test?
> >
> > But FWIW, I think the kernel is just passing the ofset/length info off =
to user
> > space and isn't acting on it itself. So there is no kernel vulnerabilit=
y here.
>
> Right, I'm rather wondering if this could have been caught earlier and
> how we could have caught it earlier :)

Ha! you would have thought we either have no test for it or we test
only mmap with offset 0.

But we have LTP test fanotify24 which does mmap with offset page_sz*100
and indeed it prints the info and info says offset 0, only we do not verify=
 the
offset info in this test...

Will be fixed.

Thanks Ryan for being alert!
Amir.

