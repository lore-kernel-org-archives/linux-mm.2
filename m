Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87EE2CCF9F0
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 16:50:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2098280020; Thu, 30 Oct 2025 12:50:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD19E280003; Thu, 30 Oct 2025 12:50:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B997A280020; Thu, 30 Oct 2025 12:50:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A441F280003
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 12:50:20 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5C2F8C0210
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 16:50:20 +0000 (UTC)
X-FDA: 84055368600.23.74B7A6E
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6179A180018
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 16:50:18 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PJczeBv8;
	spf=pass (imf24.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761843018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VVy8tbUD3Ds1T7QsmSlLfYhJ41rXLA290c2MjqkFJVg=;
	b=lwTj4zpXe9jyUVYMqOoUHW3ZQWpuyIk2OWu2iustHeuCBZct8HgYLw1cfRUL1cYGHlsFqB
	lggB90Qb+ZJzr76u7Dsx/SndHrojTC9d/xjFNgt2ddApdPgWTIPph7gN1ny6GnrC/C5f+7
	rbhcpvktnDRwjmjwS5A1dv0GT5iyhvU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PJczeBv8;
	spf=pass (imf24.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761843018; a=rsa-sha256;
	cv=none;
	b=XlAB7x2M9Lk+gDgHoN4gK7vBmnX8Yp7LJ59M+vtLKPPkWdQI30FD3MQF+NXr8roVHNvMcg
	flMN5F1kJPAa8evDztJV2RdaiP+4zP5DV4m+uiyLezuS0wHHABa2MVyqBHWwZ0rmiFzaMq
	xw0OzCdigf20uHu9phLzH+gr2oopGTk=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-27eca7297a7so1474175ad.1
        for <linux-mm@kvack.org>; Thu, 30 Oct 2025 09:50:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761843017; x=1762447817; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VVy8tbUD3Ds1T7QsmSlLfYhJ41rXLA290c2MjqkFJVg=;
        b=PJczeBv8k2EMpdsAf80u+0KD6aaci0ES1LjWndkDx8FHjIZCxOpXe/+ywylzWVR8Eu
         sksHEm7bpnatkMKWH2Ns627DsCumm23Kv56K9vxga3y8E9NTxC6/GY5zcvUncO81ObtX
         06fsmWv31YP6gc13CMXlQvWNqLswmv4i/LXldG2kImIf6JTJWOD2IPGJHSOg5XUC5KHo
         49dVbHxDXCwRrw1hLlZ7JFkXECYImsYmTf2qJfgTw2VkQ41MMjVhjebQC/1vQ9bESzt9
         FWErm5oFQwEjk3SMx4I9yxX3l6nzSItiNNjneaSDmt253oUovqFzopGg9I+NOs7m8Wnp
         RviA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761843017; x=1762447817;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VVy8tbUD3Ds1T7QsmSlLfYhJ41rXLA290c2MjqkFJVg=;
        b=E11PQAXyeAtHR5rorKt+xw/zhuHUk8i5js9CfyDJG4wDfgbxLhnhJR6DZIxUKivxXk
         wu4QFST3hT5o2KOUJUxjeavfB63IE57kdsuHY7kM+iLskSFIx5RHmU+bXo8yUpCLqn4v
         wpkPqfgSvU6bp7AXhW6XVtj+WDfKKFcIppZthJjmz06sRIL/SNcqqtIUg9oYYBgRR06u
         Jo/9xRV+LbeUGPvgmRF9wZrRmNqs1JvVGormUnaQEE70pDx/x3K5FYGge2DIJNOeaD9d
         i+1LSRi7KVFumlvmNYVD+BeAEk6fJfeVn7cQxDWTzt9xClKn2w5J4nUEotwyg5I336qd
         goLw==
X-Forwarded-Encrypted: i=1; AJvYcCWsufv9yXoDA9ggxIRVz78tzE9S7QUNyClEpq1URBSK1N8SiL73nyqNDZMwnJhTmHkOlrzsGtCjoA==@kvack.org
X-Gm-Message-State: AOJu0YywlY6HSpHqR4UIuGYmV1uSChEanSOYBIIFRPWgLXp9tI3fUre9
	q3uWckLAJqbgrHa7Q36jERHUhRa4x85yerUeVR7zIo4K9Uqjj5uMUKl7u+yn22tpiNYuZ1ElXih
	w9bJw7Ki9Hsr7i3TBn4cPyYG/mvNaGA0=
X-Gm-Gg: ASbGncu0bGB4tgJIhHwAjhvaWvnCBBk53MdGYosdrhXdjVPqfbxs0GEGb0BAkeeJjBl
	Po6sz/CtnWYITK9Q9GNL2nIav3ttKfcwbZb5fvFJLF3LlA8oiZL4r4368QCt9ylVKZXCgHLyr76
	2P0EOKehhxP/9wmjbDUA9xyxJpWu/4Y2T+603Jp3kBt0cwnr7BawOS94K5zDxZENKUWhRebsnGI
	N82Rl/aEMKYWqWG6dWisCEsOnMeRCZEl7vFRlefAejhRhjsm6ZPeYINo0gbJDtKe21RX/4fMOGs
	yVZ7jLutc11BKc7LNpal03iMhOFXlwSRX0eHDzRvlA7NDubSDEpEauDx7q6uadpvAAXMQ+r11h8
	0yKw=
X-Google-Smtp-Source: AGHT+IHIwOHRSXqelvV1Sdf63ytImuxsi6mN867ttFRk6bB9U4Bt6FvCqQWaRN3cWMuEbnRRwlVbLx8M4DZOhZxBczg=
X-Received: by 2002:a17:903:234e:b0:294:b58e:6580 with SMTP id
 d9443c01a7336-2951a545f7fmr2497775ad.10.1761843017022; Thu, 30 Oct 2025
 09:50:17 -0700 (PDT)
MIME-Version: 1.0
References: <20251001-unique-ref-v12-0-fa5c31f0c0c4@pm.me> <20251001-unique-ref-v12-2-fa5c31f0c0c4@pm.me>
 <87sef08mjk.fsf@t14s.mail-host-address-is-not-set>
In-Reply-To: <87sef08mjk.fsf@t14s.mail-host-address-is-not-set>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 30 Oct 2025 17:50:04 +0100
X-Gm-Features: AWmQ_bkaCQLlBdplFGaXs_s6rBEi5hnyY5mzRPNbjRg2sfBfQKwQOTLK3O0jQnQ
Message-ID: <CANiq72kuRNvovHK5r24kh23mo5wp2bpx-EjGMOyNBOF1YzukvA@mail.gmail.com>
Subject: Re: [PATCH v12 2/4] `AlwaysRefCounted` is renamed to `RefCounted`.
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Oliver Mangold <oliver.mangold@pm.me>, Miguel Ojeda <ojeda@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Benno Lossin <lossin@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dave Ertman <david.m.ertman@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Leon Romanovsky <leon@kernel.org>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
	Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Viresh Kumar <vireshk@kernel.org>, Nishanth Menon <nm@ti.com>, Stephen Boyd <sboyd@kernel.org>, 
	Bjorn Helgaas <bhelgaas@google.com>, =?UTF-8?Q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>, 
	Asahi Lina <lina+kernel@asahilina.net>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-pm@vger.kernel.org, linux-pci@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: txm7a8hk5pptoi8aaim8gkjorwt4773b
X-Rspamd-Queue-Id: 6179A180018
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761843018-404925
X-HE-Meta: U2FsdGVkX1+4vetD8BpWl758iQKdkY0JhQ6Ougl1KcgWGJEAEfF1oF2aFVJzUjI0MR9Uk3vSMM0ZrGNELEUxrXA5HXoy/T4TpstUP8v/dslvqRggHYUB4WJVnfO5Ak7tq4Xjwl/IAfPhKTZzKOC8AzG3k23Pz5VCZF9TImPr6rFTS41OOIo8+w8JYh/7Fo4rNGalRhgtKbVATbIJ12S88VVAtN3j5TpszLRISaTz/Zh31Q6yjj0PsqfZnHVfNHrDeFRuJdLFx3L39rQamDNqcRxCrzMK40HhK2NIKzNTVABUnMmvmaxTzkNKKLbLW2vz9eq8T2LPezaTapebbjrIacvVXpUC0xKyygiEJSg3JYS66ex+ZF4ZaegGcPMKIdloxBu/BwKlyYsBfLOpUnNRPoAvyaae0mlV+EXft0/f8lqW6nSznQW/Tfn86BYigBU+41ymGmVnP3D6tOkT4uq8aKFNR152qN6Qo4rN0Q2/dSnhIFU+XQ0plRxgmvuPFMlQAecWSzAM/YJp6DuA2TZgRycmnijhpCp9Dl0t1i9J2wUUer7Nx9Dk9nc+ZhPkbgLoztVlAaSQ0pa3NrBBljUJqR6IFJHxISDe3ATEVyh2476XOS0geyP+oOzZ2Nuq2xvi+stsriOdrue2lIQW1fahQvvPvSnXI7HuXlZ41JXi69OYMn/+Io84vOTHnuRDpyAXMzuvoMpwPwyZ9kbTOnmXJXq2FlMmT9nqSj4kKmyq3nFsiNY1hYKmCD5f/vo8DmmjGQdbDHWo9keObphc3LSw9s/A717OfkFBXRt4RKZc6JPZCrl2l+6K3KdDbw/EA+AwgqGZs3Hsl6sl5XlRaHLiJiyhksE/1TDAHSs7wLnPvdls3/7IeCwtBGDz/crazA2MXiI6DQGOnTaygsw8FpD6YHh5jNC8t4BAnRIWWe+G1UscOA3ZqbtxJRJdm1lwIuJSQOePaKHHTZuaqqABnUh
 daRJI3YG
 fxtIMlfgNtr2eHghkyvgGFxVFvz7unfagjs2pXSvNgwMpXJ9NU1iiQHFo9fAF3CnW9b3F7f8zTRlIUVZ0LZrF91JgoIGbS2g7gSQM1xk5kM1OMfWwHW5dxJ/8ifVUnZI+BdALB7I17a+ax1rFi1M0vmYSOA78xctG1TUKaMhIQlAHmGNaQHnmT+VkMrsMXe3A6MqI12ySQ6uBRDGDN6EYqYj9VzJCm7/qUqOGDH1fV7bQK0HB6Mln2F9OC3TIE1aLzyuXxrohM0mA1OMCjbHJs96L1erTnYdMDXwBHSV0Vy4oyBj0sJpHhV3+6ctJAtdvU8SjrfCACx/cuarkoqOC0P2j/s+zVyZJ5azllf6R6fQ1sSW6tARVszvhAzKZ0Y4s1rFQGK3bCY9kjsZ69gRfNANtrMf8SEbQ8PLUx+kkSWXUiCLeyDQu0aQK2Ulw6H0yyiAUbUPZAS1PYcXFe6ZlnsPbSHdL6dq6sKA4f4Tmzxt7j08=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 30, 2025 at 3:57=E2=80=AFPM Andreas Hindborg <a.hindborg@kernel=
.org> wrote:
>
> Since this patch touches so many moving parts of the rust tree, it is
> going to be a cat and mouse game regarding rebasing this thing. It also
> touches a lot if peoples code. I am not sure how something like this
> would merge. Do we need ACK from everyone @Miguel?

Yeah, any rename (or generally namespace/path change) is always
painful due to the flag day change, and thus ideally best avoided if
there is a practical way to do so (e.g. keeping the old name for a
while).

And, yeah, treewide changes generally need Acked-by's from the
relevant maintainers.

Cheers,
Miguel

