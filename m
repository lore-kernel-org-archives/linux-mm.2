Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24A96EE3682
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 13:34:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DC446B008A; Thu, 12 Feb 2026 08:34:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 589EC6B008C; Thu, 12 Feb 2026 08:34:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 441636B0092; Thu, 12 Feb 2026 08:34:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 367DA6B008A
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 08:34:37 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E6E6F138B2E
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 13:34:36 +0000 (UTC)
X-FDA: 84435899352.21.77726EA
Received: from mail-dy1-f172.google.com (mail-dy1-f172.google.com [74.125.82.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id E34EF10000C
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 13:34:34 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QHhnmPdn;
	spf=pass (imf05.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.172 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770903275;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yNMxoxwcI8k3TdcfCMBuTL3G2x/jekpsbWa9BEmFkO4=;
	b=CK3ji4k1lcwUuV1v1k02qbWYaG4Gh7v3iGjH0tr6+AvacPgo3EwrlIGdosmO+B6/rqUANL
	vnI3mO9AP/gW/cNlOy5GuwVaaM0AdbILv+m35PjLHQhEdavMjixZbXa2zf3ZwOg0hoDHKC
	kE8lZcyIT8y/mVciHMrHQDbMfvC8hy0=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QHhnmPdn;
	spf=pass (imf05.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.172 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770903275; a=rsa-sha256;
	cv=pass;
	b=JiFmqlerKO7tqNnq5/fgkF27vQMami1+06vqJ9vyMk1WMTPCNxP0an10Fey9kTFlqABsAX
	xVWHI+6V6TDHSMtkWFkqZRfJenOBU3FaZdVRcBJTaJjmLdWt160W+Ceaw7sVMf976GzHVI
	d4GZvHEVXL+IhbirGam7Kz+bkheRUTU=
Received: by mail-dy1-f172.google.com with SMTP id 5a478bee46e88-2ba85f77203so371980eec.1
        for <linux-mm@kvack.org>; Thu, 12 Feb 2026 05:34:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770903274; cv=none;
        d=google.com; s=arc-20240605;
        b=jvLSJRJPivOQ68jpzWK6d8TLK7KITkgqvDVxlhw5sBd3VQAK/2xfu3bzg1/zTyWyPM
         TQZos1wDB1aVF4xH4EJjlMoXJEZQitSo42kMK1bfwYOsV4n/4s4ZX4nn0ZlgzIqZkLKw
         O+Q+BqeQAukK3MQI3m4seSdWHAidSF34UbeVt4XrKpwUQWXXsEncm6uI62hsV4FqJ5VW
         9cTA8PxUgshLiLtO4LNv617Vvr4VX+E0bDEtt90xq7CDCZO+nx5BD59dj/JIoHNw1d+f
         qka9M7t1GHMuxw8/ICUQ2xFGkSEhy5LFxjHZ4vMJojygaqTl486ctjAenWgulcjb2ill
         p25w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=yNMxoxwcI8k3TdcfCMBuTL3G2x/jekpsbWa9BEmFkO4=;
        fh=4uPBjmk39yyiYGwVJ6ncFEV0UxtijOycdIqDRdSt9/A=;
        b=TpvmazHkpagbwWypuhdXYfHxLNdSPX98LzRFR6gSp0eH/VF0Zv1WCB8r+YS+Kbaqax
         5ot1kPOZ58iVvyQUMTZwFI3DGR8X0sjd9ymoWpVlvUqMWraDGOZLVFxqpVjJB2tP+RE1
         p59bBge5j5Mv8XMNJLG1RaDwuS5Ql54WjN/NjDlCLKV5JvEoMoyX0jwWhajsRR5LWuLJ
         AwFa1LVFePqX5dNRk5eiCHuqbrhqVH+Dqw6jV6Uc6OvZKS6J+VE6xnIb1Htj18zdnqeK
         N2hTBNDmIviTtSX7scnWXCVTxBmO55Z5kjPZCrX1BfxcadONQxaLgeNtKG0jhL8rW5Y7
         8cYw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770903274; x=1771508074; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yNMxoxwcI8k3TdcfCMBuTL3G2x/jekpsbWa9BEmFkO4=;
        b=QHhnmPdn8+2MLALzj6ZXJbccDJS4DZjdJxyiQJ3pA2opAN6GlIdvuGVFmoiZn3T3Og
         ibwhZYp1JoSLsJK9QguvTGgNSPJZFqzIyXx7vtnCCCkhS+TgPDo8DQNGYJsSSyhWMWWw
         B9fgP8KIw2FMvx1q9oXfOWqtRpMoSThAJLeuMFOqdjBu5S45NZB/gVne72k3ssL7RcUR
         5baMwSzmQNoLzD2Q83VztKP9Hv4aUr8SinBVkcE65jaBnM888FP2sTBHymktlpwXF3um
         5fzOWA6DS+KyQf+DVZWSpmVpDhx451q7OfucpKmp1ZMCWDDCjUAyxrjTlShoqq5cE3oz
         vRSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770903274; x=1771508074;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yNMxoxwcI8k3TdcfCMBuTL3G2x/jekpsbWa9BEmFkO4=;
        b=RybItLnvju3AuEJrPdpXFAXz/4blz7myV/0cp1s1yu7qJOI2/aK3FXfRZ9PQxbdSsu
         PCG3GQ5wha17NdfbuOwJF8z0gTy+UtBxRzJe4IfG1timnOHDRgCEI64iEtlPcKDtNFe1
         zOT9KqEJZFpYU5nLVjA/t9qQV4gHTJcmK4YTUzMTDGtL6A7tGjSd9c7jhfjbQFXdfWlE
         uHeuK/lVfy1BxGTfd43MQixxKgt9IkAU+zZG/GSvf4cfP1QBpG6C+/onFvcT8P6sV7V2
         g2iP85/kINMrJ6EVbjZYg/6sUoitQngqRrpWCB1L/Wx73GdO9gTSBO6NwlfMkU8W8RjU
         aoqA==
X-Forwarded-Encrypted: i=1; AJvYcCVeOnUYp47tIQdBxPBse9UTRe0qhPe0iD49Z3+yRASByEgaqaNeEQGg0epju0aQm+GFKAX7sJBoNw==@kvack.org
X-Gm-Message-State: AOJu0YxffW8S0/U7SHGE29yRIXPy5CcPPltMpHhJ1clWIA/OR+jDEdRh
	Z91cEulAgCbyLvUoQxj15n1p31EC54tVN6duE48b7WuXdZ4/lIpKidBzvHSsxi3VXu3HoSsyqRo
	4N0kodyq5aa7VVeMUT903JdE3XbRLV6M=
X-Gm-Gg: AZuq6aKUs224EfTNz1jE6m7w6THl9HOlKvHny79+NRCy9BvD+rhfdderbF1TAp7ydtk
	PInzodcGIFO5x5ap+MTz2DrSA+Jp8aRbQlD9mu+/lkdPwHcGORa8tIz/ZIgDHNWIrrhhNjv5dAt
	NZ/Z2zPh0i2Kcg17+6dpHWeTtjh5w+xrhFbH6ylF553sJgSsS43ohxJTRaI3Iyh0AJyjKGj2abq
	eP31tD63RLaIZT1phBXraR/9pLOzLTRj2ggl8/+QwFkAmUJAMgCl13YhVsxK56rO1vu1HYQs9Tm
	ygwaoHbC5IPzi/2ZKcrgF+OS9ojz5um4xyg0mKag94z+WbhF8Y+JzHt4IoF33ak/Z6qWcl3Iw7c
	4q9bID5LeQkngT/QmNKKtMEnKZMAi476awVs=
X-Received: by 2002:a05:7301:3c9b:b0:2b7:e929:856b with SMTP id
 5a478bee46e88-2baa8060a37mr597124eec.5.1770903273611; Thu, 12 Feb 2026
 05:34:33 -0800 (PST)
MIME-Version: 1.0
References: <20260209-xarray-entry-send-v3-0-f777c65b8ae2@kernel.org>
 <20260209-xarray-entry-send-v3-3-f777c65b8ae2@kernel.org> <q43rzzvpfh6ke74eyn3nypiek2ihaq6nat552asiobqge4vxmn@knwkb5dexnga>
 <87fr77viat.fsf@t14s.mail-host-address-is-not-set> <fU1FEYt6-SY0KlyJy4VClCr5j6P4d5-wukzc_9TkSDSBuQNlY26xyOIprMbHEVMv-H-nrAJ1iN_9tcfIXEI1iw==@protonmail.internalid>
 <gta2wjt4tkcvyu7g56gqyipiigbmbk2ca3biqzmxc2npch3rk7@ccwzwgnk7mcz>
 <87y0kytggx.fsf@kernel.org> <87v7g2tesf.fsf@kernel.org> <WXzdKn94ED_qqocwnFPMLL4sIamZUFw57nW-NMKpdYCWhxdCutPl_wcMwF_aTpQvsmt-9NUQZMy7OokH-lQ_2w==@protonmail.internalid>
 <CANiq72=n2=96dvcLXF05Ta4+h7CyUTQNn2b64U4j=VB0xO-0GQ@mail.gmail.com> <87pl6at9h3.fsf@kernel.org>
In-Reply-To: <87pl6at9h3.fsf@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 12 Feb 2026 14:34:21 +0100
X-Gm-Features: AZwV_QjGQXign6Um7FnKXJ_iFz2AuNQ5uOAIEDrUpQFsJbrnBBAxnyYX9wfkZeg
Message-ID: <CANiq72mPz3gcb7=4ONQbPasmjPeWq1Hd28ak_gzg+bgyHvL6ZQ@mail.gmail.com>
Subject: Re: [PATCH v3 03/12] rust: xarray: add `contains_index` method
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Tamir Duberstein <tamird@gmail.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, Daniel Gomez <da.gomez@kernel.org>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Stat-Signature: fxg3kbw6ao9sucdrsa9m8zw9z5uorocp
X-Rspamd-Queue-Id: E34EF10000C
X-Rspam-User: 
X-HE-Tag: 1770903274-45508
X-HE-Meta: U2FsdGVkX191zvCcBHA6ceoJSjqzaJc79uIePXHc8R2wqngoJJ5PT55ShleXwRt9gcdcj9eB/5htef4eDgUQ5QlwBXCAkKuBjjYmx1rd92B+wx88b0DwnH6YYdI63and6DuepTgQJu2L3+XJ7msgmNeUxndhMbE2uoR2NZvpNqMsqX48xL6PnGwQYrhQB3uN1/c8LNxX6u52ay6/dY8NSey/5gbz3dE0iWz60DjIe/sYmWyA9kzPMKV59odToreuncTInoZzUVov/0n6LkH2lTmPkh5QS9nwS/HStYbp1BNLAGWIbcLdctGCIPTmecnLkjpk9EGjfx5YSO0jFvKw3T7HFp4lq9HcVVFZ/BWd7rY+krAk547PvHPP+RKMrA4v7IoUJo0b0/qC2g4jMBsKWS6HQaDgQTdrstt1UgrXNNJkEoWDjoyA8mF5eX0sjVPlHWQ3zjJ+Eomu5b1s67cuBaSp36To3wsPBZzZM9J0jlV6yQajzPVSRgqlthXr2BT0ByEmTmU1NwA0RIzKhexTLd5RizJ2bNWv0auFcrVJifappstVCt3xm4Yox1PPcdTfdL/VX0r23Kme1ZQHeBX8dVbQsqAvbbuVDYcj9n/pouMgE22b2f5VBM/SisQlkIgpntmNSBD+B2Q1hK0VLh2ECLYULv/u+hg7teHxzQvN3d4Bcmp892fM3IhcGm3eFem0Yk9O8cz2tTlJBJb+sxdVORyL8zWmg2mqixtE2Gjpap1n82E6mLZkFHhLdxZWg5dLE9XzHn/X0N42c4AnELu/bR0n9aByRlL8hgFDZ2aJDFEs9qXLaV/8Jp65NTljtgHGGt/egAklPBgJnxflgLKx/8S/LqpCVck+laP3M+suyKw0gnNF8NSQo9OqebHamda7mUC36XTXl++y3mVw2z/5sORAW6/RZ/BWunNytXpiAJkFqfET5j9wzbZE9BXk9pw7qDgKZ1DVGKR8bMjIj4z
 7Aqs5EaP
 cRh1laf+PjcCDtjHJq9BwTC4VMJ6JClFWIhEcLCbTeu1ILyFXKGGm/WFELWOS33S5MWgZvW7tDmUhIiD3kFt1iq96fH3Uuj8MH50t76xlDIqXzzOCh9VqUKPSWSZxKrJi+f7X0ChB1XtRalyXSptbZxOT5eWt+LJwe12DIDvVJ3cZAfe44NzerszfYczOA0GJHxUOKTW72ChpESHKPe0D2he8SzVrIv6HEg4g+E1pWPWgYgDjQFVwPkJbsoZtvAZMaBlg106Gm7vj9XunCP6IYGCpqUlJOre3UMVAsuCrojnXFGJNdP7vTUD2XK4smUUClQ1U5nvDTikv+J3AfsZFqWpzyFZa6Omh/WeLV2NL19TUPFynBBdAV8087toYtm2u311dCM0aoEnnXhsZGnO/TICztCayESb4DlcqQJsclxR4EorLkKwHT/UEi1N/tEZVvoalNzaEvFy2cuylo6zVyr6S3mfwWmipL/ZpIa2zKXPLbslJA6teoVDaJMRJFBDmxiB2IsjeAcFfFYsF7tz4486r0Pbve6OVjytWoqOSzZPARg3HFmqmkdCMbAQ4V+8fH87Xbe0E4xQkA4xurguTSaFIgw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 12, 2026 at 1:47=E2=80=AFPM Andreas Hindborg <a.hindborg@kernel=
.org> wrote:
>
> Right. The devil is in the details. My point is that the analysis to
> support this was deemed to be too computationally expensive to roll out,
> but the intention is to achieve a similar analysis at some point in the
> future, via Polonius.

Yeah, that is fine, I just wanted to avoid confusion, because it
sounded like Rust broke (a lot of) existing code, which wouldn't have
been acceptable (for the kernel and many other projects).

Cheers,
Miguel

