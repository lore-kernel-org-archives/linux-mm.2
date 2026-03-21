Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5F771094474
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 13:34:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2036F6B00A6; Sat, 21 Mar 2026 09:34:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B5436B00B6; Sat, 21 Mar 2026 09:34:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A3C76B00B7; Sat, 21 Mar 2026 09:34:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ECF986B00A6
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 09:34:05 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 74B3113B27C
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 13:34:05 +0000 (UTC)
X-FDA: 84570163650.02.341FAF4
Received: from mail-dy1-f178.google.com (mail-dy1-f178.google.com [74.125.82.178])
	by imf10.hostedemail.com (Postfix) with ESMTP id 95CB3C0012
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 13:34:03 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IsGVMas2;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.178 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774100043;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sxNYvkoMi8SXclAI7J++tVk47zsDBqwMkV8+EwFN1W0=;
	b=nsgFN4v1deZZxrjZLKN11fmoS54q+784wHPIMASy+uhUt18fWaPBZ4EfMwpflg+6bTJC+q
	/hlhJ1wQmIeRH3jrRBSHoCLMmAJooQFjx/Rg1KGie1v+qzA0/mBq4Ax4RR/71Y01vJtPnp
	cq2GJ1aEISe11B+etjT1OXy9FgKZmJ8=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774100043; a=rsa-sha256;
	cv=pass;
	b=axiT1G5Owx0RUNKbCkRJtqEwAEaXio+t+cXBWx75EpGlEyPCD9GeDvbcgbShF8L1L61IYd
	nSpgUqno/bh0hKjjtRbXPHz99phN+RgF3sAnZV+x6vuS5BbMlVbtg3kfHyl6DVasDUtgAB
	nA5ugAgAkGCGM0sxqJ/IwKmPxX+ZYbs=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IsGVMas2;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.178 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-dy1-f178.google.com with SMTP id 5a478bee46e88-2c0fd9c62acso237522eec.1
        for <linux-mm@kvack.org>; Sat, 21 Mar 2026 06:34:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774100042; cv=none;
        d=google.com; s=arc-20240605;
        b=c1B699HbJW/UggMjxHieCUWUutU4JCIMUD0IgTtXRJiFEHku0AZfKG+A67A9mL2y6p
         tLj/UQic86XfzY/Si6+Lp6XZI0AdGwmJqzacgiTri7JF1vzwe0PaSfGgpaqgJUu5zjRO
         VuqcLN6hopf/9f3xAokTR9Z+Jgs6jryfUficLQXuY1cY8bnaBHsTXs0qZMxZZpR1lWQQ
         6qGiDp05/CwDXaYCs5rY0TiFCCrlg8FGqJBXHrX6nlgj5j1luPpzJC1k7DCTqrnMfseX
         fZc8QQQuiPPsKsuOL9axciISNZu6I3Xz5bgip/8NJ7zvU1/lSr4KnI2YAFxaYyxm95ID
         hyzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=sxNYvkoMi8SXclAI7J++tVk47zsDBqwMkV8+EwFN1W0=;
        fh=wU9fumQiWU479iR6JHsjQ3GOs+e7D0zO4Gtie0JxApA=;
        b=YPt49GWEdHaihRuny1yWJ3gPdTaJvhiVMuoFqO0H+22ivhILzvGdhgE8EDvCm7C0P5
         RvALpbT0aKCwKMo7PERM2SK3RfeHwb/w1NUsgFzrh2VnpgCQBkjMFQoqfHpiF9Tx/VcF
         GsunqdE8paJzPMabpRnuxN+iF300W6F3VVZz3OPsN7iaFudc8leuuMTUwWOItFyb1xCt
         CWByDw7RaQBvGANDRt+apIu6LY4j6PhAt7rgQaQnkf2JGIw7lBT7PJXFv1t1HYQBeOns
         7JN/OB+LH0pepwc37Pquk2f+TtgXift/Ko85I+k3LmhzaUpRhjtEIuYUYUFKELxVjUGf
         gQrA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774100042; x=1774704842; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sxNYvkoMi8SXclAI7J++tVk47zsDBqwMkV8+EwFN1W0=;
        b=IsGVMas2cvG7d6a3XmbWZ99l6SeGL9KZzleESq7QxcEJspvK0oH2ANGr8yy95XxTAF
         Zptd6Nqoidn8Rxu8OnMo+rhB5IUtbnp6NtEVOcy2X4RRUsA2xdYN5G3XEwuHd94DfDMA
         vrW7qMRE6fNK6iRL3s31NMpGJR+gXEW8XHB1e0xKW7C7zkiPJwPRIAVzeRh7Q8KcJZUI
         iVc+cdfLqbEkFWP5N9WChukdQogS+o2Xcds5BrGeEJbbS4ldxbAXuUUv5/9Q8uwMmknN
         Y5Vet/h7rvwD/jwGTl1UmGnlZX4vllWEjc3vNaO7YtnTODepONLtEw+7fA7Hg9wtCJHV
         HyUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774100042; x=1774704842;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sxNYvkoMi8SXclAI7J++tVk47zsDBqwMkV8+EwFN1W0=;
        b=r1dPH1flnF2c3Y0ZPr8QtSHLr7r+US0dkNm1yk1fYCSWyJyXaECUdygpNyEvoNWUOW
         Gaa+pk+Jfiaoz/Y+4MH3EPvl5neQQvfwcnENBOLP9nJ8Ym9yCMnFXSIeqaEk6cC2cc68
         AQIpkD1KE33ehyHsNYXhOjbl/xV0DfKBqZk1AmUkGvsymsQ6Kln20bVDN9Q/W4Enx5pR
         InIUb5Zs5G8O6Azgr2ARjMQ+UfYwD8Z1FBT/qTsfbcQPH+Fvcc34O+ujvXnwIk2O2G8Y
         wHZZobZ+vYjKMelnLVcK/ZAFgmEDYQWZxfE3zHD7eKCuS3XNMt4SSlQMwAavPzXBHUsE
         +tMg==
X-Forwarded-Encrypted: i=1; AJvYcCWR5gXww27JZOA3MNe02xkaJDtL0GlUx6G3SudS8Xe+4Ukc6TVjiD7slxodxRZQqxxG976cxQruZA==@kvack.org
X-Gm-Message-State: AOJu0Yw7zyFI8yAiCagx5iV6rnvWQhsxgjbu7JbTFSnTflSlR+wBpIhW
	EnJFcX6t36v02f+0OVt9P+/ZEjhdlMrrdSdS5a99dWedDhAINGsZoY3MWFPK0rYDdL7KaWvCOjs
	NXRUc2cK6dLVloPdk/+WsHLeAE7Wc8yI=
X-Gm-Gg: ATEYQzxowR6oir/+TWggLMT7xBqvaE5Nv5Z5emWzgls8GrI4u4vqPZ6sechhrzAAMGD
	hTgvnqak/0B4A8Iz++VuYG/pjmKS6fPXWSrG3yaBo5U04pKpoh6TtRiQYhAhUbZnYLpvvZMcWq5
	4Ip2kNDAmLBer0UlUsletd0VyuvZr4WTB2aSrngS43gGYqLpVAp1UflTzxRHuBqFxEsKOo1oHwk
	dCNWWpE9PQw1cz88gcUBu7I2JX1aXJbNSHV1em7y/0Q8fm34DzRjOeI13INWW0W0LOWRnf9VRqF
	RnJR9fGU4E+T6wi+Gu5iDuT0LZ6vneU5T9xO9HMZf3jJAmAe2OnuqP4Bc2xvPgE/xu749w03Eg0
	LUOTiGZueG9DtyO0q8VZ0unY=
X-Received: by 2002:a05:7300:4306:b0:2b6:f2d5:2923 with SMTP id
 5a478bee46e88-2c1098861afmr1462939eec.7.1774100042177; Sat, 21 Mar 2026
 06:34:02 -0700 (PDT)
MIME-Version: 1.0
References: <1f94cf47-9898-405d-bdf2-29e21cd87528@nvidia.com> <87ldfmtfk7.fsf@linux.dev>
In-Reply-To: <87ldfmtfk7.fsf@linux.dev>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sat, 21 Mar 2026 14:33:49 +0100
X-Gm-Features: AaiRm537phjdHidGVAf1007v_8W_3H-qjtaFgpcsDGtT1PP8A_h_Ukclbw-WOxo
Message-ID: <CANiq72=HYHj4ZhFWqTJk3DhVEoOqFKah6yA9ROfC+Z797SwUZw@mail.gmail.com>
Subject: Re: Sashiko.dev for Rust for Linux
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: John Hubbard <jhubbard@nvidia.com>, Miguel Ojeda <ojeda@kernel.org>, 
	"rust-for-linux@vger.kernel.org" <rust-for-linux@vger.kernel.org>, Alexandre Courbot <acourbot@nvidia.com>, 
	Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Jason Gunthorpe <jgg@nvidia.com>, Leon Romanovsky <leonro@nvidia.com>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 95CB3C0012
X-Stat-Signature: u6kyy4gug4r8hzswq7g5qmzy8upqpzh8
X-Rspam-User: 
X-HE-Tag: 1774100043-809120
X-HE-Meta: U2FsdGVkX1809rZhOLx5XflK03z+4i/bdq82v0mvSye3IsoXucNaOOzkWifKlv6r11/AHeZuDqDu6KS2vpgAd5LeAyr+x2kUcJotx6AyySbxXKYU+A+Fakdh0hd5r+9rL2gUw7cRitX9fbvP8tw558X5CDmS3c1hKTyW9I2Uh2kWy6GNdStuuAjlhfphEKq251QJWezHKpxFc7hSOcD9uOXIFo866Y02qC07HvUBZYyEnFXsX6dZSH4noJ41byANEGmaiIFFT8DkWD/35CPfCE5xNZk76NOGbO+u6fJEVXVIxJKpRqOLK4+bKlxMZwipCoop4eWqDvIE21AiQw1smgsi7QmGliz+zk8KGKO+O+dV+3S4hpM6y0C5MC5v/BfwzrbMs7PGTiVT0RScY27loS5RQQRbKgeE6a1X5FoxqAi60JVHNI1jX5KOHGSWRYPm2qt9GmlGeuhGzHqDAznDe3S80HNVMKQhdTswvTQ/Hsa968m01Ja6Anjx/pyGmSLY+GCEZDGyhw3+8KO5HYhBmgf9x4D1r/nEM2e9InObWY3vug+wED5qnfiAmGSWIvJXPh46l6VZrlWGvRC6X5ex83R/KJOj3FU8qlo37gO/mNASuHq2WkbDvd0KISoSGjJbBmrr4asjcEEOklK9ilA8lN/pcuSHrLU96+M05ntw1VxvK21EN3laXEkyGb4h5t0dDVKCFB5B/fnqoeFdydbPp31thXf2q1LGI79KCWHW731hrs17SmrFS97fZ9pmcIvnxHwU3ivI01an9P+HFXufN4ba+YGM3pyXj6jFMJPl1U9KAD98xXX2fKcDGLgt66iOqgRxEAnZug+bqTki8MPtIcXx3qEPGcrAQ4ske1eZzFD67xfoBBvS/qkF34GJSKf11wbnPQYUJ8EF/cN48afL84fZMpZnP3SHNcl+bxQeGHXytdYrI5elDfa/u5kdaZKFE7/gBHTLPJsi+SV3BsQ
 t4FAKObH
 qtAFzcy6/Xv1iaJ1bMRgZ6k1H12AHQwgnrqANo5rQc61CxaovBB/j73N/EymSUIEjCj2hKy4uy8elXQyVx8UeB4fMzMZd7+HdlK7Ab6NrK3ZzTQ2HZw+V+lVnYvPJIRos1yjv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 20, 2026 at 9:24=E2=80=AFPM Roman Gushchin <roman.gushchin@linu=
x.dev> wrote:
>
> Yes, I'm going to add rust-for-linux (will appear ~tomorrow), but a
> bunch of patchsets which cc'ed lkml have already been reviewed, please,
> take a look.

I see the list there:

  https://sashiko.dev/#/?list=3Dorg.kernel.vger.rust-for-linux

I have just added a link to it from rust-for-linux.com (in the menu
bar, where I keep many links to resources etc.), and announced it in
our Zulip and the mailing list (I guess this thread is short enough
that could have served the purpose too).

> We don't need any rules/skills to get *some* reviews, but we certainly
> might need some prompts to get *better* reviews, both in terms of bug
> discovery and false positives. If you'll master something, I'm more than
> happy to give it a try.

Yeah, we should definitely add some context (and possibly skills like
Coccinelle for Rust to match the recently merged Coccinelle one
eventually).

I see Gary already replied -- I was going to mention that he has been
playing around with it for some days indeed!

Thanks a lot!

Cheers,
Miguel

