Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D01ECF506D6
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 14:02:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 477666B029E; Mon, 16 Mar 2026 10:02:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 462E86B02A0; Mon, 16 Mar 2026 10:02:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 365916B02A1; Mon, 16 Mar 2026 10:02:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 231316B029E
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 10:02:29 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D4D92C15FE
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 14:02:28 +0000 (UTC)
X-FDA: 84552091176.18.8AF41CD
Received: from mail-dy1-f177.google.com (mail-dy1-f177.google.com [74.125.82.177])
	by imf07.hostedemail.com (Postfix) with ESMTP id A881B4001A
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 14:02:26 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aw0xIRGT;
	spf=pass (imf07.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.177 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773669746;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cyyiNDptl98k8pZAyExFSCW/9thFIw3OK7mbtDKcMP4=;
	b=PaXEoV69qEz9V48fCFHzNfp80rsAWsMzocTWhSVqQK7FKQq5N5lUldM4FL8XR64llTjS/x
	HBfEZJRHVifdYpo8Osgdu+cdgzW0w7brpqZu8qDVxRqjvuS0OrXeND37p2NhsUCWcQbqFY
	jKbw4Ka4LEDnReCqbevJlb6jJbtkgug=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773669746; a=rsa-sha256;
	cv=pass;
	b=e+1GMDO7V6B1s3QvjwfqKrB/TFoviCpVaLBfNtsT6M8hp8JBUY74fuywAm61GvhbpzxvtK
	b2WXPAJvkDTjOWivM9kR2b1T37KNRC66rBG0hHkc1q0SekqBrAinfF+MT8zX21i5mmPUIr
	Uw9fZf6t2amJWKogc8FLR1MxQvwtGPA=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aw0xIRGT;
	spf=pass (imf07.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.177 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy1-f177.google.com with SMTP id 5a478bee46e88-2c0c7267500so27390eec.0
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 07:02:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773669745; cv=none;
        d=google.com; s=arc-20240605;
        b=UzmGW6SW5OVIkufqd1vWvP+P3YRlwJy6zwee3hMA4DMSIKOlfuvj27kOcRJ72ldBpc
         ZWyl4LDx1hjxC6Op38Wp8RPdzuAGUWqNpqKK2g0JGzr7Rt+y0ZsqoPsIeuyTHIH64f/V
         gV8ud2HG/RdnX60fL+rQ78EC5Ijx/09mHABnvXQoZmLCpPMGInkJDFmpF2pqIfn8kuHd
         J2O6qrEeG203a9NlNcby027+37xB9W4XQhZ5Wi7W01ZLfFpclVX13hZozYjGM+rhJwpe
         126BnJoH6oGWNI1SBIDYh/xvGl305A3vAgbPn3AIVqHLzQiksq/5yVTSL8PSIJMRBR5w
         ceCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=cyyiNDptl98k8pZAyExFSCW/9thFIw3OK7mbtDKcMP4=;
        fh=m9g9D39XYDsjbbxYmwDM8PL3q5C50nheP0uYH57TOj0=;
        b=eipE9iG2fw6/W9/A9W6WzLxw16PanN3+EZVe0KAsEghk5u39PewtDabnVas2rS+ThO
         gDTzwLAvHn+9kp2A/D3GrcZ1/AaQpfbcvQhCflcrFjOarx09wBhVbR94Ojd00ZCiQnL4
         fm32WVn0y5Vo5Nwsp+VvP+NOySd7rg5R9M9/uElQBqv7OGbyIiUGlSM6Ysw26uzPccs2
         t5T9avGjpLXm5XPI01bWqGu7ETa67S1YSK9i4Qx+braZGxDUTV0WKV2jD6Igxh2UOe4s
         ydG7hhQNzNmQoNUTdgdC3ZUUJavolb6aMlx2TAl69J7Aj3bWMiHK4uvPMPBEJhmGGRdF
         WadA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773669745; x=1774274545; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cyyiNDptl98k8pZAyExFSCW/9thFIw3OK7mbtDKcMP4=;
        b=aw0xIRGTO7xN8xDTemWS1mgBa3E2uouPaMCsWXWrj6/09QZiH6OC18ih+X68/AmWJQ
         gf35qvYhfijlGfqLgZNJWu53NGWc7JtAwVjPlYUfznWwJm1UM8NFeD0KwfWbxDpLd/zv
         PZDNvFbUFp+arxIn5QVs3ph5e+iPjZbVQLkKVr2SUkJMHn9oj6ey8UgZ/JE5bxvhwGOm
         rZQIlluPzKyhakKHIqglj3RZKbQFMkqNYecDxlNPZtFMHL/2RDEMYf797uUzFfn0Dw3s
         SZWj9VgXmhUGJkhWRbGug4n2DyK/XKvEpu9KGgVUEaWxtrsNdHVbnnn/0rxFS4DGlRAe
         Wtcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773669745; x=1774274545;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cyyiNDptl98k8pZAyExFSCW/9thFIw3OK7mbtDKcMP4=;
        b=iCQK48rZseNmRckWR0UYKaYnFU8qKPtoOBaRwaWr1G6AyQILxjbkZ9gdGwYNIHTlps
         MD65+JDzYnOJweefEGxuUy0pNNrInNb7wAmkyNjzk/nlrvRywxQFh4T5XHgK/H7Lo1V/
         /E9PYYDbrMf4F6jOcJ+cIqczLMO3PUoLccuHxOOxErWoULp8QWS1ueeB8XV3Y1bIM0YK
         KNNee6hXBNYS76vuUmaAvufKzj0r89yUH7yUdRlRSS9xKHZQD3/oJVFUimFVN6eQwEp9
         GkDo57aylbOVyLAiJb0P6bnez+jo/M4kVt07kJ/DGc7MIw+CSAYyWxGWl1FXzA7MgoUZ
         5s7w==
X-Forwarded-Encrypted: i=1; AJvYcCUw6gCYi6kD2LYDlKCGuTjQJd4zYIPeIdnzgtGOfEwuMJJXOPwyN0g+vuYXHmxNJYx9pDSsjX1jfA==@kvack.org
X-Gm-Message-State: AOJu0YxfYnrhkE4JJsVfgUlV+9qYndeWX4dFe5DLjTtKQIcbuOklGM9K
	TpFXDiLQy/EXKcFqIXMYOzoC4gqyCqKJ36WR9WSDEZiANKmj9Ql20k51bzmM6yfeO86rSzmJiU/
	yhIdSDj3bi5jN3u8I2lL42XsO9J2OV/Q=
X-Gm-Gg: ATEYQzyyATxpsgMJlGkec7o37hK3Tx5AuHo/EHBjPXt/uRt5zTCHEOQaITs2crli8PQ
	NPAiM6yDRU/AFWeJnTJOILjQ8/abeRioiXeASbclnpnfjnqJQHQL9u6lR5CojnwH4jsq2+t90RO
	rWjCzLgIlmIvfXm1CtgyXJSkCHVrKrl6buAAVAprn3U0lDJm27aFWgst4nj59QrTHW0FU0XMs6F
	PAeKSb91pSwsEcg+KDfLH9oQP741dRenFNE3UA6q+61VxM8JAzBgobHADFQ/tjt0cxwSv9geb3B
	7o9yvHi5UeX1Yu5rgBP7ML1aDzOeGxpu8HezwCUm9o0mDk4/dWMoyNFNs5sJNwjzmiLtSAUFkJv
	eL42f8K6dKAa8zXMcKxvEVhCIvr/I/ydJzg==
X-Received: by 2002:a05:7301:19ad:b0:2be:687:5dbc with SMTP id
 5a478bee46e88-2bea559164cmr2813360eec.6.1773669745095; Mon, 16 Mar 2026
 07:02:25 -0700 (PDT)
MIME-Version: 1.0
References: <20260216-rnull-v6-19-rc5-send-v1-0-de9a7af4b469@kernel.org>
 <20260216-rnull-v6-19-rc5-send-v1-15-de9a7af4b469@kernel.org>
 <Y7WTRL6v0WsR-DWju2vumM1EBu4KZgQzE0VJul7mK3pUwD6ba0UuQO8sclDzOaeLGGh9u3WG5iSKq9T3kQqH-Q==@protonmail.internalid>
 <abfe2LbhLzXiGCkA@google.com> <87cy13swpw.fsf@t14s.mail-host-address-is-not-set>
In-Reply-To: <87cy13swpw.fsf@t14s.mail-host-address-is-not-set>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 16 Mar 2026 15:02:12 +0100
X-Gm-Features: AaiRm52qARL449c2NWg6ctU1DYpJKWGFTyzYGuap71EBsFi63NYUf31noEiyOu8
Message-ID: <CANiq72n5+JadJUW-GO0cwQrq9eJW7cB3ZK7zx4J484RzjxmYEA@mail.gmail.com>
Subject: Re: [PATCH 15/79] block: rnull: add `use_per_node_hctx` config option
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Alice Ryhl <aliceryhl@google.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Jens Axboe <axboe@kernel.dk>, Miguel Ojeda <ojeda@kernel.org>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, FUJITA Tomonori <fujita.tomonori@gmail.com>, 
	Frederic Weisbecker <frederic@kernel.org>, Lyude Paul <lyude@redhat.com>, 
	Thomas Gleixner <tglx@kernel.org>, Anna-Maria Behnsen <anna-maria@linutronix.de>, 
	John Stultz <jstultz@google.com>, Stephen Boyd <sboyd@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	linux-block@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A881B4001A
X-Stat-Signature: 5j7n6du8e3g4jkhb6qey9pks7ahjhdzo
X-Rspam-User: 
X-HE-Tag: 1773669746-525539
X-HE-Meta: U2FsdGVkX1/TCH+0xG9kRwi0lM6mLAPvMemto9M1M5DitMbnvCRj2nHt+IBrMwj38pHJozxmqfn6baiHGWqkBhC4XSgp48Ckt3M8XsWfD6Yt3DPNK4PdkPVAHAXA1IvMMKLvWXUsyYDYFnxj0hOkjNKbxSAs0syO8p3L7rruwKYFvdsVOXlo0RWi/DNmF61qzAVr6VpRrtaadO+/IxISxWF/H4mF/PJcyZE0BwMWvNwPwOEcECjRtOmSx+yy90mX77UYsYtX4hBZkShDyRVl2lNonKJQmasZpOvXtwWezadHvNxu+oG18NLjdkFJlrG39e3KGxu4Qycn+9ivFGyRNhQiwTc//w61fUS8DMroUSQqm6KNIIZqoW007IUtf1TRGCqHNhVsbdXS+nwKs9fN370u/weOY7ei7nMsegrb/acgYXgjcYKzwe9x/ZlUc5l+Y+FS+NutAqPbVxwAEj+MuFSfruojuCd5EtOp5mAAHOC+6gvaCFq10/jayqzmJBFW+g5fXJkrJHwHnyf2i7F63xXrOtoenDrpjpXtbxhXKXABkx3zDJmIUfCCWn2MHb0gTQFTjVpGnshw9pPsFCk/x0fQ2xkZvoT8tpi48TGkoKEoC0Au5jrCXXfVCcECfYXPfh04F1mUx0nSBF/2xexl2Ov+jHlIsapkqSVuI+xV43Q2qzg1vJK9TJ6pisJbstmIyVKx3NTt8+MNoCUjtW8RwDAKVKz7NhL5dTKQ9lJcU9EfJIKBbm/duyOoI5P6eo9gZAYTLy+MIA3yW/RgDn6k+FhotIQaSfoTVrzM89J9EiaajVfDtQejf5BGmV5EtbOSH1VnIysWSS7AprMIxndbv4b4UfeqZ8/OBfLQTbFZxtAgadqTa6ko0KeAIe1wamYcAIiplLiIzmydYaa4NuhPf8wQk1xQz8vzUvFqktVdx41l5rXOpQmCXSmfhLtYNxP+ZHvO3aV7kGf/VSlsuqZ
 nJTiJ8bE
 j/it7b+j8PyYHoyTJ1Vo1x4i39AjWVbUcHbZo6QHOOtYQF9SFYUZyxRbBE4ZcbWlW0x/GE2eL46gmcp7ubQcyNzuL6hTGC+8fsUV35TkkfuJu2+wNj7ZuQJJ0ilabO/XcksO5uiHr0kcPesq6Lj4Ez1BlS4BTqA9jPGMOaCMCiKNNW8ixgKAFSPMbLpTs/6u7P7eZOWQpd+hFD5Uk9neWYhA9/eJ0SFho0mJq3ai2VROTe/zIbhpObSJWXTy+K9NoaptvSUQAvm4sd/xlWiCmIh525Z5j6RuPWRen6pRg3Ms8PLiTuwPyTTMJJT8gy4iwuMIDOyM7X3mda/z2tU9ejZTkH8LIp+f+3GWLnhMTHANxjtA0WmOhiIlWPVDbS6y0FHFwGK9rGs/6TsGOQiVTSYUDkAaJ1REVcyuLpFklFW0zqurZTpuwePmNQu9YZh4rLwX4kB56zqnQ3/Xq82gCbLb/4i5i6Zqw+mIAf4rdtt+KXhsqkFjyaV8eFZbpT9qqM8l3WTQaYz/eW+cw8joG20Dc/93w7lD0JWn1SpLUzxnlUiSyd8ECLzWjhT72N3XOriCarC8WecpUmr0LfjFzN3vwoIH4mCIoCPFkY9kc+/xjAVA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 16, 2026 at 2:58=E2=80=AFPM Andreas Hindborg <a.hindborg@kernel=
.org> wrote:
>
> This is intentional. The line gets too long if I pull it up, and I don't

Do you mean you don't want to go over the limit or, otherwise, that
something else complains?

i.e. the limit is not a hard requirement -- exceptions can be made
where reasonable (as long as `rustfmt` is clean), and moving the line
to an odd position doesn't sound worth it.

Cheers,
Miguel

