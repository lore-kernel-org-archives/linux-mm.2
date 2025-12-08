Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99D63D1CDC6
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 02:22:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 725546B0005; Sun,  7 Dec 2025 21:22:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D6056B0007; Sun,  7 Dec 2025 21:22:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C4E06B0008; Sun,  7 Dec 2025 21:22:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4649C6B0005
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 21:22:03 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C255DBBF5A
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 02:22:02 +0000 (UTC)
X-FDA: 84194703684.26.81BFCE6
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf08.hostedemail.com (Postfix) with ESMTP id 9A0A716000D
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 02:22:00 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=google header.b=RZQzvqfD;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf08.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.51 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765160520; a=rsa-sha256;
	cv=none;
	b=GQczlOoiN++h4pnpQlEmD0LYN0rtCam0JB3NTGW89iLS1iVSnJd35A+zQ9uNnlmg8UdEcN
	P9nKA53OCeQrUsgb0RMioJ2cSVGddS1RTJakg07ELk/SaP0tqAsEHuEM4kF7CeV6DRP4v3
	tRqYyy+W1NgFZPeL6TPL78ATzXAV2AQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=google header.b=RZQzvqfD;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf08.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.51 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765160520;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W7Ny34kX+7pV2gTBJmZNlkjdHSh/Hj+/uXXhNu/zf30=;
	b=vZeUbH26RAaZ2idKlW9zmxNvOP/vvzGku8jGM1H0Ve6W0xn3dfL9UnbpuhnDN/fUpRE3Vy
	AqMZasNDwhCXcTTD5tPOnTsCzLyHk11rF2EmQj3uSrzwQGhArxee7+D+umCpwyamQfBSZh
	0Uao/ks5+UPT20vhkk+mWgBXolpEZug=
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-640c1fda178so6947456a12.1
        for <linux-mm@kvack.org>; Sun, 07 Dec 2025 18:22:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1765160518; x=1765765318; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=W7Ny34kX+7pV2gTBJmZNlkjdHSh/Hj+/uXXhNu/zf30=;
        b=RZQzvqfDpRyshBCXMIk+0hxYaCXAsOqcn+UDd35T06fqXTVnqTLUwvzq13StXtWyPp
         0mAna4JrYHTSsWVJFFOIu01CUBiLAN2YOhxTNnB8UWGkGdMfAiBPsIAbXJlo4LKL5k7+
         SusWIRDPN8rXR982SFNALTM1RUnBjFhvZzMYE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765160518; x=1765765318;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W7Ny34kX+7pV2gTBJmZNlkjdHSh/Hj+/uXXhNu/zf30=;
        b=KiHZKOcymO1pYG3dwEKi4nQrdhKlXGn9HZFLqNHKtsWd/q0SwpNDw+h8o78YuvxZT3
         +vU7JkNYeb0lKfoiEM2AuaI470kz5KEeP0Sp51/ZlA2Qpschj8BgAZiI3RQ+zTAQWIe7
         dro6Bk0UsFH6AOyV4721yTRkObFw+EPErkqiHbkpq9CP8H5bkNobqSAQIMOHN2p4yeaP
         wq8ItpuLG6YREem7Ryq0liNok0/BGIM5glJaJ6puGh3aUsRHF6K++2w8FjGpc64snDvi
         tKKAlLj4z1dO+DyCWkFuU8qnhLIx3szWPyZcp9QJR33wsTJVYic/ngh4KKlCIhWwxFrn
         TpOA==
X-Forwarded-Encrypted: i=1; AJvYcCX6i7CS3YnrEUtQu1ZYcYLKQx6agLnlLH/BFhHMcvWDWUL/QO6kFKKwuXbLH1WB2bvk852P3DmmPA==@kvack.org
X-Gm-Message-State: AOJu0Ywgf+0sbmerA1qAsj3EKOOagsdCclhO8mP249Rbs614GDfouTum
	t1vIga69N2xNBxhBUmroHMJFOciFvLphK/BAEZ0eWwW4dYkSJ/P+oMeOCfBNh3fu0FJXVxxGhwc
	s19s/LQ8=
X-Gm-Gg: ASbGncuObTIbZrHRYOMaKMWJsKAMY+saKgwnv5Mu8HDGF5SBWgAwEf9JCPjjINxQHrN
	gg8HEQ+HfWZ86jsIT4qtGKssKC127ENBLTX3sSWkbzBnAyyk7U9tN67WBqIQK5mZ98bKzJFD+7x
	ckzpHtG/fFPTn/mWZCYJUZLPx6Rzl+m4jw/oH2dNAJUkJL1birExUCt9IpkF1GAxQJLH3iqF+gZ
	x3wJ8eumJeYrAasY4XIoRr+7+qhSYhSw1pwEAt0ix5xVMR4cL1Q3tkOg1F6rtgIlgUTbU4/yPSu
	t4bNocNhhpJHT3YnTb5430LQH731b+An+YHxVRWKdBFi3vwfqP61UfaEW8ail9gCZB0E+KEgwmG
	rgPZc1msXi7apGGwZzkFVDelVgWlr1tLXvjgFktFyiufptP7H2elV44rnQOJEKnpmJ/ftz6U2Mm
	9qVmhlzdjEy52PCAp1v7n3DGlduWVBo6T/wgB9+Y5pgKU+l1nSgNBXq5OM9VU=
X-Google-Smtp-Source: AGHT+IFDeruh7QX4A2JAyorM38jkRspbezESjm3CB0t6mPutFaXNhnccnKoocDjjzFsxeqFfE9pGQw==
X-Received: by 2002:a17:907:3e11:b0:b73:7f1c:b8d8 with SMTP id a640c23a62f3a-b7a23bc1d44mr660952266b.0.1765160518515;
        Sun, 07 Dec 2025 18:21:58 -0800 (PST)
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com. [209.85.208.41])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b79f445967fsm976850366b.10.2025.12.07.18.21.56
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Dec 2025 18:21:56 -0800 (PST)
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-640c1fda178so6947398a12.1
        for <linux-mm@kvack.org>; Sun, 07 Dec 2025 18:21:56 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCULSUErK0RPkEMHut4QqcBReAdhAP6ier+uCyXVB/yPV6JUNsypW6zTwyuOJ5Ic95yrzgGk3JmIHw==@kvack.org
X-Received: by 2002:a05:6402:90d:b0:640:a9b1:870b with SMTP id
 4fb4d7f45d1cf-6491a3fefffmr4880149a12.14.1765160516078; Sun, 07 Dec 2025
 18:21:56 -0800 (PST)
MIME-Version: 1.0
References: <20251206111533.f1b18ce84d0854b5f6d86a8f@linux-foundation.org>
 <CAHk-=wgG3xqJn1=SVw-npsdwCRtyY=sYbLa7HFkmj_Q0U=vdHQ@mail.gmail.com> <5e5e24eb-6af9-464c-ab1e-f9ee55a05a24@linux.alibaba.com>
In-Reply-To: <5e5e24eb-6af9-464c-ab1e-f9ee55a05a24@linux.alibaba.com>
From: Linus Torvalds <torvalds@linuxfoundation.org>
Date: Mon, 8 Dec 2025 11:21:39 +0900
X-Gmail-Original-Message-ID: <CAHk-=wgvMBRrcR=DzsRKcLdZpmg-kJz49D1CzafjrWj+BzAGiQ@mail.gmail.com>
X-Gm-Features: AQt7F2pA7YIn5OZVITJ1bBw8kF53abcL2dtB4SE1NWrGI8hCS8MOKvzfGAZKktE
Message-ID: <CAHk-=wgvMBRrcR=DzsRKcLdZpmg-kJz49D1CzafjrWj+BzAGiQ@mail.gmail.com>
Subject: Re: [GIT PULL] non-MM updates for 6.19-rc1
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Dmitry Antipov <dmantipov@yandex.ru>, 
	Heming Zhao <heming.zhao@suse.com>, Mark Fasheh <mark@fasheh.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, mm-commits@vger.kernel.org, 
	Pasha Tatashin <pasha.tatashin@soleen.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9A0A716000D
X-Stat-Signature: xjo8t34hsg85symsjs4i795kgozgeasx
X-Rspam-User: 
X-HE-Tag: 1765160520-655355
X-HE-Meta: U2FsdGVkX19cv5frRENXGULZeM9COUXjZA9/Wz7WmNxNJaJRi4bvjs13MetGA7zrGeJIw6+QjugCxhREuT+i7RKSUeczNgYzkSLkbPecHf5VOAmM6Qer17Al8F27tv5HKFatER1x7YIPba/QHOiXPsOxKv28ApdcnepEBOrFCf7e4M6RanO9gMCKJtWxH2uJQOWyVAJyZA+GKD11oQcdQka9QA9cdCsIEZCGsSooCzotT3w+1QhLkM0roajiagewLXK00YnYc7jVwdf4vNlRosoBJX0UFmHKy+GPw8oaFl/mORAkNsYOfGMiv7Q3JZ9OdTSQrgY6/j+JKHnvwidO0BNG43mXpyzTwrQ5QI0+CkUWaNsjjfOWATMJc6Da7nypInn+WCjV1hW++enrIwRrfqqqe3iWGyfbT+/M4x9ItnA7lpvKTtYGFmhLY1I7l9mpyIr5PO1WL+vUDabNawU8T5oFYpgUtvtnG3ArwGbRRg/VY9B00Yn8p/FjoLyZTZKwC1iHZambyTW+TpCPjgkv31yYL3JzPXxMb5LnojNaUwtYvLtNbCWESK9iUfNzZePI79ViHxaG/jWyvg73AIGYCtG3nqwUyEzgcLXt2FzV/SizQ7yxZ/W/sNucXeSYpgH0O9Hg4NxyjQgd/K2a97XPqdxxW9Mk5ENnS36ZA3mf+yuw9LVaXtQOzsbaifKWgemsxuiof7W7+WBCk2I5Q9h8DbTHyGQhfa3mYXp/G8M0F1bFtAQWCZw13SzT7geADYc7dmIvtMYCY7AEHM5gqIW/x7V24/1/NO8MIT4CqZyW25xsPN0YwFCtFdrTZIArE4CwKp+8ayf8kXRW5a5NlGe6epuJ7wh+HvzOe1yYqn4bN6IkkrEjRGJW42MZMZT/KLC8blsX6/IrUPPhheN1bKdK3x5E3u7Gz7k4xHozxdtNEuXjgaSpCLCvEcvTqa7jpdQOU7jdV7yT2UDhnypfKoq
 NYCSCgBP
 2FGzIJZs04CwDnZSyHbARqvWuicTOlilHCfSjVfODVcUlJBb3L5s7I28exeb6PoKWbbToO71ypf5Zi4A3KtgRYL07rIcxwF4H+dszcVdkQ4AFEJDYNeAxp2A0GCF60i7NprnweqKrSEghh8GU/JFOhSbuDgHnYKfVJajekESrftC4mS8WLFGN98ViBrr7hQatiNOcbd1G52wehFDhR3BkWMW/G1jb3xQZTDr72B9VlmfHZeaht626cL30wSwOfbHcHMepUZTc9jUfqGxVNYjbwjrpJlr+RfVG9G7fRwhMPXAWJIxpdyfzvU8DBvJNTWSnmE/DLMfqOaklzJL+8rA3dW8kmD4lv7/2ZUwCeGt/1BnXNM05VmuWqOQ4Au3WWJBr3jsLk9iypX9gq17RPgq53nqedbBUjM/sFLOjukKhrZqA5fdksDQ+oQ53vM4fEihMTPHoujZB474KW9O2ObzFRq0Uj1gYFcLnnjDl/tRWosWA2dtDO0wyE0l4ptRFtjpHk8Q3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 8 Dec 2025 at 10:11, Joseph Qi <joseph.qi@linux.alibaba.com> wrote:
>
> On 2025/12/7 07:40, Linus Torvalds wrote:
> >
> > See commit c06c303832ec ("ocfs2: fix xattr array entry __counted_by
> > error") which simply makes the 'last' pointer point to the actual last
> > entry, rather than point to one _past_ the last entry.
>
> It looks fine to me.
> Sorry for the noise and thank you for pointing out my mistake.

Note that if my fix is correct, the mistake is most certainly not
yours and goes all the way back to 2009, and commit 0fe9b66c65f3
("ocfs2: Add preserve to reflink").

But I would really love to have somebody who knows that code go
through it, and see if my fix actually is the right thing to do.

               Linus

