Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23DECEC1EAD
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 12:24:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41E606B0005; Thu,  5 Feb 2026 07:24:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F58E6B0089; Thu,  5 Feb 2026 07:24:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 301C26B0096; Thu,  5 Feb 2026 07:24:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1BC856B0005
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 07:24:26 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C99C88BD97
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 12:24:25 +0000 (UTC)
X-FDA: 84410320890.27.06C8CB3
Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	by imf08.hostedemail.com (Postfix) with ESMTP id D7397160007
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 12:24:23 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dAompq3S;
	spf=pass (imf08.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.174 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770294263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZYfglyr8WBVX6WQ6sjuoZun+RCx3dM35uvyj1qgWTPs=;
	b=69LFhR0BG6ocnr3OJceRA7FZ65VuCdUJufC9SgyKpQSz5qAUoBVS18koFoW6c7G2hQ1JOI
	MwnP1qEPiyY6o3Ar7XG5YqYbgHXa3/oXRQiK66de9rBvXAUpbP7arAXMqBaywG2rBe8Gou
	9gL43GHLPl74xCVIWeDHwGtJady1gdc=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dAompq3S;
	spf=pass (imf08.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.174 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770294263; a=rsa-sha256;
	cv=pass;
	b=Gx28EnYi2fp94lYnYLZH5KETwh4YWt9HuxYRsB20MX3GcNDjfvhFOhTZRKlSTZYxPnYxLj
	bPXpoYVvjHuEkx1VeeUUayseuRcKvctbzqIHS46A30fB1mIsmjqCDShv5it+HGnFNOKAwL
	gWAi0FVscY8RFVFO1yVjN8H3pqoy8N0=
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-2b6a868ad45so84987eec.0
        for <linux-mm@kvack.org>; Thu, 05 Feb 2026 04:24:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770294262; cv=none;
        d=google.com; s=arc-20240605;
        b=jd8yyQCvw+u2oTGhRHymRVor9XEjjWhssio1TX61F84/yyf2oMPYb3+2lh5USAV7Xp
         eajLHXLwdY/vAIcbD6Zaj0lQF5GnxTkXMf2SVud54pF1ACX7m3J/OmOXoAjHr1BqI/xV
         7nSaq1p6bGD9tK+BpRdELNU7Mbe28B7R0R5DgWc/W5og4LMRxDNqhRtXqLda3lLzKmpN
         vjH2gd2WqmKXYBwe5I70CB7M1NK680us88f1xf8YvNk+haQTZdSxAypESsbOeuEfI/3s
         k4GFij4guPZV/eUuB26UfSKfVlbn2LpuPxfHsKlBzr1OtnHailmKFowIhhebH9S4+qCH
         HT+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ZYfglyr8WBVX6WQ6sjuoZun+RCx3dM35uvyj1qgWTPs=;
        fh=tFh7SzUs+79PFI7VdCAx0MpchlXQfo1mzmo/gcs+Ei0=;
        b=j46wb9BQMGy/ugz32IZokSpwoRBn1mwFtSeJ3CHvJRd5akYRv04jtYtzPjyplmznEM
         1hWSc8ReLc9sdYOuOT9CmWFJ6dlFSPjs/g563czTskupDLzaUMiJbxQ0gC/xcFPZZAsc
         ZyjdqSNdauhQMAhC5FFg5iOwEH5CWZ0nnR5Yh3C844hOIv+H2rjS8LS21wUhh0F7Lyvg
         QWo0v0MygiGJehRpjwy2sNVjmFRp0GS/VqZGrkXsyP0Y+ZL54jyJ+vE8bwSdbPDc0KNh
         nPUSzqbuhn4arlnveLuLhNWoYx8mfO1H3X85TTbgsJGSqtPzRvhtwc5vbbvvIeC2WpaH
         v7jg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770294262; x=1770899062; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZYfglyr8WBVX6WQ6sjuoZun+RCx3dM35uvyj1qgWTPs=;
        b=dAompq3SqYokD9hHHVuqfrynDHBu6E1Vx2SXl8RxGY1YlFafp6U+axxGuUUf4OTra8
         LJfAsZZnDkBBzkGaXTMih3m9U+plU6j7C+PwOQLVcbmCYaie96VfOx7ZW5M++jk3FB2e
         vOhRAJig2YfYPdQfSfN5wUrWc0P3dhM04nJAdmApqluCJ+AKfTPyZ5EvFgb4EIOQ8JAT
         g0eY0dzeKTqI5Wz+QMJXM8ZqwlgtP3Ay4jrCzm+d9PH7GYgK0ydZ9ZzSRI/zG6Zgh9Y9
         nEVzhqJtrDcsoinTVIYEM2W1OaTcFIYdbp50l5fyKbYK2jCQYje1baiPlgXORza712yR
         Qz3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770294262; x=1770899062;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZYfglyr8WBVX6WQ6sjuoZun+RCx3dM35uvyj1qgWTPs=;
        b=YG3X429M4AcZk0Y5ERhUrV3hmRVX1HabXdkLHo7PdYiUqq2BdntAA/hDR990KsG2Bs
         L/Xlma8kzMOlItQEmlL/0KMpUNOcEC6D4Fv0AzwlN23hETDBstRNciaFhB/jKD+Wk9PX
         StoGhUBIrGvZ7xkw5AgbYtjuYmSy/ffe329pwdSA15kuVjzpui3vXclngrMa3qLWS/0j
         vnLCQcUdqsJNH7Ed9wsyKWcE2yGY/AHjI9OD/IlftK1SOWmhI10JkM677mKYkrP8+fZq
         knKRk0qOLLmYJR5sysaGbRANJC1SelmNRjwdQzzDzes7734iWuP7T9GswnFSslgTJLpQ
         shvg==
X-Forwarded-Encrypted: i=1; AJvYcCWn0XkrLc/7HowTxD6YrFgdzNtDVZP68Vn8VxzLQ7pJbEsfjV2Qb33O3jThv7xyyS54RRE6X/IcPA==@kvack.org
X-Gm-Message-State: AOJu0YzS8kmqHBstjH0GbXDp0soYi4mD+i0Z22ObWHU9EkIYsBTY/MmU
	1WMl2j4fmhjYwJRuQ5FiJCtOkxh8hE59GscX9reKj4xgdDaum1vNYcXO/VRj6zZXKi4HHam/24b
	63desANZekp/uEHXrLsixiDeFIBsshVg=
X-Gm-Gg: AZuq6aKmtTK+WMYrT1K8e3/+GTV8gj5/kHjuzGy0csdUMKgrOfYwrPh9ziFNWqxyKSv
	E172rrpJ6GaL5/a8of8/0yi5t5FiFkgkYTe+vMJMyFMWTX5vc/jh5fQFxIlXVC9tIlxg8mcVIeP
	ABOxgzaLvOjwY1skmuseHpR6+xhPSb0+Pzk2FZKb0/MIFuYnW0nfLlSVZOAKEn4fa6AeOokVcgz
	/5VhdoSrldqqwA0Hcihpvyuc6+R5xfGf5YzRvB4o8FR96TWP5fpn5cs0LXfyIOLNPxwpXRJXV30
	wCFQqCIBxiD3CB69Mg+YsFOo/4Fty7UnSX4CfIy/OZbX6s6Z7shGA/Z6DAwSoulwEOnRdiT4iTX
	c/0Hps0cmqvKK
X-Received: by 2002:a05:7300:c29:b0:2b7:b88d:b75d with SMTP id
 5a478bee46e88-2b832743f4dmr1457533eec.0.1770294262402; Thu, 05 Feb 2026
 04:24:22 -0800 (PST)
MIME-Version: 1.0
References: <20260205-binder-tristate-v1-0-dfc947c35d35@google.com>
 <20260205-binder-tristate-v1-3-dfc947c35d35@google.com> <02801464-f4cb-4e38-8269-f8b9cf0a5965@lucifer.local>
 <21d90844-1cb1-46ab-a2bb-62f2478b7dfb@kernel.org> <ab63390c-9e75-4a45-9bf4-4ceb112ef07f@lucifer.local>
In-Reply-To: <ab63390c-9e75-4a45-9bf4-4ceb112ef07f@lucifer.local>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 5 Feb 2026 13:24:09 +0100
X-Gm-Features: AZwV_QjQOk6KBIhhGsJHJbikCfRdoq7wVHVjUzF565W0EbHofNdnPpSD4f5sZ4A
Message-ID: <CANiq72=ybFtqsh18zkC3e1iyR-RoffcL_ZDr-fU7SjzJiFERHw@mail.gmail.com>
Subject: Re: [PATCH 3/5] mm: export zap_page_range_single and list_lru_add/del
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "David Hildenbrand (arm)" <david@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Carlos Llamas <cmllamas@google.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Dave Chinner <david@fromorbit.com>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, kernel-team@android.com, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-mm@kvack.org, 
	rust-for-linux@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Stat-Signature: 7j85xox1qgg5wo66356cdbckgxrtuxfr
X-Rspam-User: 
X-Rspamd-Queue-Id: D7397160007
X-HE-Tag: 1770294263-180710
X-HE-Meta: U2FsdGVkX1+gFHgPv5DiJH0pGw61t9Fyw1NGACNMYaQGczZdQ53BWZu5EYoWw6wx5CNsEOgu2SYc/CFXgf4NuPh+Q8ZqelPEl4/REJ0bq95oMtDNQt97TkoGqJW2SkJs+QyJyDpkgCOTBRnRqmYYc29Jaej2lw8tO/4dHkbwmJPan4c5vYFP1BZEvCs6fZjIFWduKSxG+Q69+B0u14LdOigZT1qYVMu9HZ31ejkaFZqyVZaE/ZYcsTT33s+OXgkY+IO0PKheFdk16mpJSXl2VAAL44IddPSYySEdcha8uMF0rrtgcA+EPTz7YJeoBDmfj7YcRNyVjtU1UoblJp6P/nPgDLK1obe2jHx+NI9pBE5Ko8t56/3SIdpPHQhyjZCa7gYw6wqyKkOk6zEZIf14LxJpput5cxDPkpv/oby1Pul5Fbm7v5FY3eiBcweltRtIiQNemgF6GOh1wHA8X0S9c/fu+oWMfMSX8jVQQLv93iOJZhteqh8eznkYWuEhmhzaHwo4ZJR+KvNrWdlq+m8CjJRUOBHdRvfcz/w9TN/bS0kWlvKaQMdZ+VkVph6NiZQwqVIfCXnq76QjN6UGSwVPBX+fFfCG1WKeVkwh30Sn0sYmMKw2klaDHhV7kfTnnJZunRbqdZHFY4KtKgFRvv47cwj/rzNHdboFei0xub5mat4wBLQafkQMQZbHGIw6gilxNcqViaN/PJ3FeyrSs7cv+YkzCVBXTPdCOdCku0fEbCsnCuDqm1z/NwDMwg9JNtk1PzTlPeIsVAsQM03FW5CIh6dy9AgAm92ZdNIyxP0hiEVYiwDg28vjJyXFnmCdy7OokhUHhNYJdXKDxk4vvxQmSZ9vWPuWIN3otK0c4EqNzXGwho5iZveQsvi8lZl+mUAa6T3QUg88xDh/QeYPaPV0XNYjfn9KyDQZRnRBu2alnFiuhVYQ8h8L3wwqYYEWLVp6ZZCg/IDdOI9N9IuQnZy
 WSz+ocaz
 iho7bQtCuIrnf94DAyS/5BGVQhu1mT+d+PhBwdF+IBmreapBUQu65H4dA5Pe4BPRn+akXzhbUJ5t3BJ/JwbQszKnpA7JBtgI0kAxEujlm47n0LLykFDuP6lLvQ1/fbQovaD4CW0nIXU2baN1XrB/qpu/wV8ntdJ/Iv1cygHyUFViayn+AgSxQPIjuxppqeWxmDWI6UP+sSl/K/ftc4m7YbDDwAt8FU005yetqnVTp5h54QO48Ct/N6HlqxaVmlv+iL3FgBQdeKfnpKBmaU0SYR9c/W1BPIoaLRxgGSqcc6lWS/s86i/QIJ4iMUQJlJJ3NK8cLXuf7c9Z2wwzygKN4SwwXuC/DC3P773+Cjr98FF/66I0do6tVqeK9GhD7HN8vv0jafTm45ehQa2wqrLIZCCAYDEhI+iL5GtTbPjEVDP0+tgkCeKgMbTi0E74YHqtOsPLQdrLzca4Pymy8judiGy8WHXwir7IjMEA1iyt5fsWwkpcAaJ+fwh0aOKE8t7kVW/0X37EKBE/14yum4+OVu/NgFBB0Masm2w37KIP4Xh/Nl9+HwV+T/L+pDlvIM/mL4Zb2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 5, 2026 at 12:58=E2=80=AFPM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> What??
>
> Alice - can you confirm rust isn't exporting stuff that isn't explicitly =
marked
> EXPORT_SYMBOL*() for use by other rust modules?
>
> It's important we keep this in sync, otherwise rust is overriding kernel =
policy.

Currently, Rust GPL-exports every mangled symbol from the `kernel`
crate. To call something you would need to be a Rust caller (not C --
that is not supported at all, even if technically you could hack
something up) and the Rust API would then need to give you access to
it (i.e. you need to be able to pass the Rust language rules, e.g.
being public etc.).

In this case if we are talking about the `VmaRef` type, someone that
can get a reference to a value of that type could then call the
`zap_page_range_single` method. That in turns would try to call the C
one, but that one is not exported, right? So it should be fine.

In the future, for Rust, we may specify whether a particular crate
exports or not (and perhaps even allow to export non-GPL, but
originally it was decided to only export GPL stuff to be on the safe
side; and perhaps in certain namespaces etc.).

Cheers,
Miguel

