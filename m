Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7742CCA0EFA
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 01:40:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7B76280005; Thu, 21 Aug 2025 21:40:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A05578E0056; Thu, 21 Aug 2025 21:40:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A594280005; Thu, 21 Aug 2025 21:40:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 742718E0056
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 21:40:18 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 069FE1DCBB8
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 01:40:18 +0000 (UTC)
X-FDA: 83802688116.18.450F75C
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	by imf09.hostedemail.com (Postfix) with ESMTP id 25B51140007
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 01:40:15 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XreOOAaX;
	spf=pass (imf09.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755826816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ni6Z7mL9inLQaWqt2DzvZGnzCjSdsFYDFox6Egj9d/U=;
	b=FQXBBZsid3utYZDP59DON0pBNaSnt38bbFZ0K0E/YI/cm22WUlqcJOKpfpG7sP/W+gvGwd
	kJq1SJMeHu9UlNJDYYg7QlglcE1hL+CtqM7gbJgzy7FizM+de+1qallz9nPznwLA3syQqa
	K8HDPCUhceL3DizrTAXyUWnYCO5i6dA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755826816; a=rsa-sha256;
	cv=none;
	b=sukVApl0jHINMdZtFUpHF12Qw3VO81piS8ZC5vdMDgm8vmq7i0gJtIsDxR2/zVqXkSnpGy
	WjnEmolgyzzC6MEL52uhOTYOVIZqX+rNlUw1TgFwTt67NUaPdZjWfJLEQejHi6Wxn06c9c
	w+QiP5f6ZqgfcnuXSM/xh5lLiJre1Bc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XreOOAaX;
	spf=pass (imf09.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-32326e71c08so201198a91.3
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 18:40:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755826815; x=1756431615; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ni6Z7mL9inLQaWqt2DzvZGnzCjSdsFYDFox6Egj9d/U=;
        b=XreOOAaXAF0B481BVVTBU7Q1bioR1i1PnBDQ4ANdU2ol0COvKw3veMHVGW4+ifSwx/
         wK08i1uD33oQQttzkLX337Nb0vJpsouO/6MemRAIbR8SWlpWATyseH2US4Bg5t0U0Vwq
         9T+LXeeS0E1C/X7s4x+vhDbHf/4L3c2dVPo4FjWYh0HyRBbLGlPiLUxKLcB2BzJHxAf4
         ewP2CLhexuumAXbokHM+rF9Y1mMJo+ndzy6Yekb1QQiaxHn/710zkpVt2Qf3fEEx+9Qs
         LCJsiJXE9DO/ys9gZWNnYquOzPWzhYJfqUOhaqHJlqaK+XM0WMOqQFxMpcUesJsGvAf+
         Z56w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755826815; x=1756431615;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ni6Z7mL9inLQaWqt2DzvZGnzCjSdsFYDFox6Egj9d/U=;
        b=V0W0OL69RdClGIIG2sDDHNB6cX/zot43EIf9R9399Wam38+uvTh38P7knN1mPOpmNR
         mra/QQVU0G1zJMoc+2XYkNvtroV7UngbOtNMhX5WQcOuLg7+9wt9fA7EImHA75WCwfoV
         sFv2P84goE4zBI7H/jVh2fONcp8mkkivnxRkLdzLBX21M35vcG4+qfrQLrgLpuwQQybf
         CXSmg9/RUcQjTVH3HFdx2jpNNl0swxq+66qmpn0MVLem23kS+pCSS+WfQMRFUM6Fnh0q
         77HERMkXzvKeTUnlBGUaOrnzyT+Qs4zKl7K6mP/F1bZNZVF3fA32Ub6v8bU93dr4L4Ww
         Qxxw==
X-Forwarded-Encrypted: i=1; AJvYcCUJjoda4kCqVCBw73eTVNiwVGct1P/Ffb7T+94fSai14Y3VAXRzr5BLPeXdcM/dizUjPnq9x/bwiA==@kvack.org
X-Gm-Message-State: AOJu0YzPXb1/4L/pIvLlorfBhcJdRnG9Qf4vl7PHCaxtLF5EwdGrEu8P
	rw8ZpNmzsI/WG9/ajQTaKZfRXc6EGc427mWZEK9cJMhALTF0gjKIDekT6NFLzPUcu/n0vuu9qU4
	b42bYzGGdJhHvouLf+5R9GNbZkv7csdY=
X-Gm-Gg: ASbGncuxVEuwXrUs72qPeY6ud27ewpDLBHVaC/pKISwcQLPnXpJ9vu4pH+Ba5He9R3T
	VAvFV5/AB8RHYwJmso7MWuDa4T89f2A2Nf2LxHbc1SFT1LK6peXkedHeohaZ6zwb+9X5R80+WYq
	UfO03DAqctod8F8Vnz2yMuAaua9vQrqhXLMbAJzaLa89Uwk8rENhwANWsmDvo+eWPY0/qM193x5
	X6G5PHpxqpAFe6RRnJUFoyWSmrqRdG8pN4oX3v+5OgOLMwatktobSaGjz55Ti+XFXGIOjjrsOAT
	skruAd57tFMryT199JL+riOMtA==
X-Google-Smtp-Source: AGHT+IGJfjvbg5f97Jik1nNzoPIGbFOufW2fVMHSl2U4znNLEKqymjptXZhYoHsZvjFTunwLS/s15gkeUO7vy4IkVVo=
X-Received: by 2002:a17:90b:38c3:b0:324:f96b:de32 with SMTP id
 98e67ed59e1d1-32515e41284mr1053607a91.1.1755826814921; Thu, 21 Aug 2025
 18:40:14 -0700 (PDT)
MIME-Version: 1.0
References: <20250819-maple-tree-v2-0-229b48657bab@google.com>
 <20250819-maple-tree-v2-2-229b48657bab@google.com> <DC6DC244ZIUL.304JSP7JFDE9Z@kernel.org>
 <aKRx8xsY8CpzbeEm@google.com> <DC6F7BN2L19O.1APQU9KWZV7H5@kernel.org>
In-Reply-To: <DC6F7BN2L19O.1APQU9KWZV7H5@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Fri, 22 Aug 2025 03:40:03 +0200
X-Gm-Features: Ac12FXymQfbLuMTcENTyCTqgnDSUXby9v6Bd3nxwMkPNwiF_YHAWlzVCd5UEEHs
Message-ID: <CANiq72=xdryEKzo73-1vaBqGNNme2kRU0atP5PYOnOOXjNxZZg@mail.gmail.com>
Subject: Re: [PATCH v2 2/5] rust: maple_tree: add MapleTree
To: Danilo Krummrich <dakr@kernel.org>
Cc: Alice Ryhl <aliceryhl@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Andrew Ballance <andrewjballance@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, linux-kernel@vger.kernel.org, 
	maple-tree@lists.infradead.org, rust-for-linux@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 25B51140007
X-Stat-Signature: eoyn31h17q8y1reuowepgnai6cibcdik
X-Rspam-User: 
X-HE-Tag: 1755826815-492910
X-HE-Meta: U2FsdGVkX1/o7CbGwxROenCFfv7H7kK1nQmZPcMfXzyCw85/oH0yEikx0dsBEpvWxZAiwRwcSHefDZb9sCHLguwboCKFxohbYxIbrauKMEv28QV+RWM045hh+04lHN6sYdbcGFRkAFSp2h2xD91LGZd9vPqHhs5P3vPCkgEgyPtXVqMu0um9zBXz519I9jMV36SmG5B//V83hV74OI/16EbCKt/0d0qx/HaxmMwN8xLxj05JU2DUi2SbD1Y+9Ki0TG1xtA1jMqsHBsv+7YwgSs8t9RMQ8PvtCgYZWliF3IIgUVCgKE5l+bg8qUUi9NEBZTB9IcU3FHVFLYjTKErZQvy22V3mChocHFA8Px6fw9sNoQD/WJLWb6P8zqzW1JORyY2JTQPcEga36zRSupDpnGC5ECCMgcmRcvCLqE11VCrnNysAuQ73yy0WTjZf5f9fDUwm6tbfZPDkWpi2SsVTu4oKSEN9NEHBPAP7Pu8gsdyeOMyS7OG3FFDDXQyXyX8AQaM2800oZzEULuJT945LzbhJRKcqPKndviEhJWjTl56jiQ2/yq+mQzMfsCoJbP0/Nv+WerWITn9hbGJ1dIr2vdOXWgZfDQqC9zQL8lnIp6MxR2F+3FllsOXXSYgczVfiQtIZnHMl6OUODxAZ8TmBXrU5HABkRw8pkYQfvooirqYQGfVKxU3mg3mYi1YPjoccPvJUmRFkNAFPMhfxMXRJlZQAkEvmj0aK8XJ90Tfnn9TnA7Hh6BTSZgxvj3Wc9/F7k7Whm+1MxIc4yVpJVAnhJHODkXWg4ZHXiHL2crwzQKPR/ouNRYqHcuTfDeM8Ze1fOtaeIhuLVBWchpDbZqAT32LYP4f8gekYEJdEB/RpQPbKgwkJn7OS49ilsKwQQSHEk8nbOoztYRjac/wEyz2UBqs2gPUe7zisXL+DcobzMFwWCtPM1TKTppBMOWYWMfTodqXkEeH/HRIoZggYXeN
 0kPLTiRo
 NWJ06YkOHEdy/waRGOgtT4IZYgNKVz8TMH/BEqGplyHU7u2KxnNajAW9lNKByZOvjzJSVCWAsgUZNR0nF6+eatoxEwGan3U1aV+jyIQFLvXE/dxCC9Y+oOqb04iDKblzLsJNQu5fh1Fc+ARKTNjEF3po66La6UwCwUiaeRXRVUkOYHUGbc+JGwSkG5M2kb2GLdN/h9YGFDFf7vCZ3NC8dtDzfy3DiIsGaPqUfyPPSPLsCO/tdPH+wx+zRp2UkGioc+7RVi4NtCuA1DAaeWtNTz9lQF7SkgLpAJYHpTRU5To3bvrdAVkT8PUV0NIV+wbJQ5TkkCF8bOJZ44uNXJzdJWgP1pYKQ8d3KkDb/CPxgNK6HjZNidjyWi2AlkqUjjLgoCqJQmlQ1o41NuQeP4u21b78io7vueV6z1bElUSAOzSi1ZxoM3BcgSOMioI5H9aneF12lp+81uZMz87nEJAkFYd0t0M+OZM3o2lktRY1R4QJN1BXZUy0nRSgyx6Wd0BWsssP2acD0bK9xltgLK4ayTGyblg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 19, 2025 at 2:58=E2=80=AFPM Danilo Krummrich <dakr@kernel.org> =
wrote:
>
> I'd just
>
>         assert!(tree.insert(100, the_answer, GFP_KERNEL).is_err());
>
> and if you want to test that the error you'd expect is actually returned,=
 I'd
> suggest a regular kunit test, rather than a doc-test.
>
> I think doc-tests should mostly illustrate idiomatic usage, especially no=
w that
> we have good and easily accessible kunit support.
>
> I say "mostly" because I think tests to the degree of where they stay wit=
hin
> reasonable bounds of illustrating idiomatic usage are fine of course.

I agree that we should try to show idiomatic code as much as possible.
At the same time, sometimes it is instructive to show in an example
where a concrete error would be returned (if the error is documented,
i.e. not an implementation detail).

So I think that, as long as it is clear the call/line is "broken" on
purpose (i.e. as long as it is clear it is not real code) -- for
instance because it is within an `assert!` and/or has a comment to
that effect -- then it should be fine and that allows us to have those
instructive lines too.

So, as a rule of thumb, probably we don't want to show `unwrap()`s in
examples if the code could have been written "properly" instead, but
`unwrap_err()`s (i.e. error ones) within an `assert!` are likely fine
if the example would be better with it.

Cheers,
Miguel

