Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFA3CE9B371
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 12:32:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61FC76B0093; Mon,  2 Mar 2026 07:32:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E0D36B00A2; Mon,  2 Mar 2026 07:32:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F6D66B00AF; Mon,  2 Mar 2026 07:32:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 367256B0093
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 07:32:40 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 06DF71B8F74
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 12:32:40 +0000 (UTC)
X-FDA: 84501061680.11.69BB86E
Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0498E160004
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 12:32:37 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FH1vq+bm;
	spf=pass (imf08.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.175 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772454758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zQz0rPb0FHUXbzgHRy665O9Jasbnueaxd3e7FIEzeyU=;
	b=lyRdglEBU/zadcr0TtS+lS/LMLriK/OGG4k9T7qVH73lcivEIftxsFTsFRX09mgQ1Kopmn
	k202WjnQYet0GZ68JXYnzgvl7RTcp6niNuMLAewNXvY8hVveGxB3prO54S1ib4fwaro08n
	ShmhjKhT1sUBE+/dUlpF5R8c87oFZ1s=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FH1vq+bm;
	spf=pass (imf08.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.175 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772454758; a=rsa-sha256;
	cv=pass;
	b=h1BHGWLYeujXUbemu7D0LfBasNiCGtmO34m0G7979sZYkXG0jsUjmnc/eZSL9xxQSf+Bgi
	yg9HIoNVixVrL5qN70DyU3VUH6VakFuUtPR017/qDC07T0g4eWchkKcJw9WZU92tT60vhF
	SmRuW3jid4S1+ZJFiiVupH5b+qMqZzo=
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-2bda3b4318dso338076eec.1
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 04:32:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772454757; cv=none;
        d=google.com; s=arc-20240605;
        b=dvIGFvYqyxpCr7AJ5uM2ph6c8YUTGu44MPSmunLjTfhPQKYbQqJpKOv66ZpnxahzKr
         zUu16mBzKIBDKqFaXc8BIZIe7UYMdBjy3AIPZvOnR1aWd2Caw24cuMfs+D94uEcWVRQK
         Xad5s9x1WM3RsXT908UWBN9YPD4pyYv5emolDLXthOkmhuz/JyaGlAX3MKu9gqv332oP
         m+e/Hb6H659OKNVtvwxVS7Gq+GQAr03ohtbXbI8z1MrwEDQuTa5SO71cZK60SD6VjLcQ
         KXKbYIZ/SEe4g/74Ld8/h8pIFoopbw7quErjsw5Zjy3soiVOjnDs1A3XCLTiUvjQlZAp
         u3zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=zQz0rPb0FHUXbzgHRy665O9Jasbnueaxd3e7FIEzeyU=;
        fh=AdYFJdvLh2ZZSPqb99h/4mG5QaDI9xGacprxd5DOIIw=;
        b=D+7wdo5vpzplpdCg9GvC6Jbq+p/VfXiLK72t+KfmuxwLzdMsyCCu01DswoqlaJ84at
         bEZBUWTMcgsIRL4GyxDOpFxnXfrv799eyKm0wyWSSvP6E/GLnnCXzRZf+xNidabWUjeb
         qGAJUPn2/lVyOdsR3f3v5LFbyEyep8YxqpgeaPJBV4tnMT5dMRufspERJxrUOCBSYDBk
         YMPpWQM2f+3UpU5NQsfXR7gYXpAqUtBbT5kLqgnBXG5rMd3uaCQDEsRfdlzRqNnbCv9/
         CwvLqL2b5NytFJ7r71JymVonMI7OkDNO9G+l/sqi5XAqBkvLp+OjjXjveHOqWG2ljYnc
         k2gg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772454757; x=1773059557; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zQz0rPb0FHUXbzgHRy665O9Jasbnueaxd3e7FIEzeyU=;
        b=FH1vq+bmuRwfw/Nk+Tp0mqNUvxfoAeehk6aQHq8wGhZtlgwL72ICDdJv6gxXipgIOc
         8O+e8ax9rJwGD0mH+BP5gs/FenVodOKUFvSDVVIKVEif8FbIaHZw8RdMUaZ8KizMNItV
         EDezqcokT572/VyAjF0EUuMwOtMLDscQULnb/7S77///UA481EAuovSUkihdLRtjkr4N
         Z6c3ZJLK9531bT8TFYYHuWdYgqIApCqiKsEJ4YT5m/oCc+nbWzkSp3rtT0r9hUMGSEgi
         kjalwXStBzqYWOaWBBIyiow9UPhfnVirP9ng7eeXrnIHF5JdDW/ifsm/NCSYsA/gxfMf
         Nl9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772454757; x=1773059557;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zQz0rPb0FHUXbzgHRy665O9Jasbnueaxd3e7FIEzeyU=;
        b=gpUcJx/xVoGKSt+KFP7AeCnMujj9x/ozNZylQTsBTsk7j8xyXjuTI2JWULffz/02lW
         iCMQ7Bz7mgbNJW9RrwY11woszaqnjU/sZBuRmFmgKS4ySsrTwryVN6p+NjNGxi61r2gF
         gEJ995/VX3spts+4fgU2ZfT5MIgy9Ki4x2WmOTFsF08WuPMm4Jly9FYYo7drfLKjqK04
         EY0VJ24gaa76q8+wEN2ts/gB6Uzv2oVNGAmNr3V0CkkvGQiVi5rXOnjxmDm8rPqL4nfF
         V5ccuU2bwbWsGNoM2MLxNyCq/uCRVx1NF9mWxHDj7evf/tJoX2qPkqcMwJcyMDUTXCdG
         n9LQ==
X-Forwarded-Encrypted: i=1; AJvYcCV2AR0mmYEUVXnx9wR1+Qi5PQcdS33xoR3V71ejhFQnskzR4QGzpfPzaR8obtaHeQiaKhHpG7sq0A==@kvack.org
X-Gm-Message-State: AOJu0Yx5+Gim9EhxbcvGlYeOicUMEiKWPcD1Ugd9WUmPY0fsJPIk6doE
	xrIMc0d/TvnRE/hYJFswJh6T2coB+kIE61bmiPX78D6If3PpkxQxrIdw/L3bWYunQP6UiJf1ztf
	dsJQ/22ZB/jZ+2Hoa+quXadq9Zd2gDgE=
X-Gm-Gg: ATEYQzwxvJyMhWXYgFS2WweY7yRVm41wJfm1ILQe/bcfqDPXsacnO6cpplRQgCyKu2f
	tlWzLiMwWj0w0wdOTTXgIAAPPle7ztatrYIUjIAYUmwnEG9G5HZrGzqiuuIvpoznEJnFj5SkKqA
	c9+jueRRmmCtDlQ8nxrbEgEWGSSf08j5bqln1J4+5s8VmGj73WI49wySQL45gczoV5O3jVfC153
	vrrSox9jp+FH0NkSS9mFNdqJHgNxIRoDQc69YA/oiKUDAgioHQZKPvfPw67epO4Bb78guMlhtdr
	TJY5JZNTUC2AJyXpq736OlkrFSu/oxAzgaUa3nBJsmstwEONj6NOcw6gL1eXytF6CpFwQMPEUEY
	ytleeU/cfut33XzrcpJoVHHBZkNtP
X-Received: by 2002:a05:7301:128f:b0:2be:1946:8576 with SMTP id
 5a478bee46e88-2be19468a7cmr221836eec.4.1772454756603; Mon, 02 Mar 2026
 04:32:36 -0800 (PST)
MIME-Version: 1.0
References: <20260224-unique-ref-v16-0-c21afcb118d3@kernel.org>
 <20260224-unique-ref-v16-1-c21afcb118d3@kernel.org> <eeDADnWQGSX9PG7jNOEyh9Z-iXlTEy6eK8CZ-KE7UWlWo-TJy15t_R1SkLj-Zway00qMRKkb0xBdxADLH766dA==@protonmail.internalid>
 <DGRHAEM7OFBD.27RUUCHCRHI6K@garyguo.net> <87ldgbbjal.fsf@t14s.mail-host-address-is-not-set>
 <DGROXQD756OU.T2CRAPKA2HCB@garyguo.net> <DGRPNLWTEQJG.27A17T7HREAF4@kernel.org>
 <p7rsBPaYxHKSMFCYVUFY5hdI1H6jxHK0s7lxLQkqH4rylM6yS03Yt52SCjiTO5qBVUmc41ZHZ7XZ0_3w_U-O0g==@protonmail.internalid>
 <DGRQNTVD3N23.33347CYLKMKEH@garyguo.net> <87ikbebsx4.fsf@t14s.mail-host-address-is-not-set>
In-Reply-To: <87ikbebsx4.fsf@t14s.mail-host-address-is-not-set>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 2 Mar 2026 13:32:24 +0100
X-Gm-Features: AaiRm52T7cw5MIQan-WghpnUecgDLtb8HLJUgWIjNNPX7ugGbu9wZy-93BfirNw
Message-ID: <CANiq72k_c06P4_JVDCNmwu8SwCUP3UjofLCAsovBVzQi=fb6CA@mail.gmail.com>
Subject: Re: [PATCH v16 01/10] rust: alloc: add `KBox::into_nonnull`
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Gary Guo <gary@garyguo.net>, Benno Lossin <lossin@kernel.org>, Miguel Ojeda <ojeda@kernel.org>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Dave Ertman <david.m.ertman@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
	Leon Romanovsky <leon@kernel.org>, Paul Moore <paul@paul-moore.com>, Serge Hallyn <sergeh@kernel.org>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Igor Korotin <igor.korotin.linux@gmail.com>, 
	Daniel Almeida <daniel.almeida@collabora.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Viresh Kumar <vireshk@kernel.org>, Nishanth Menon <nm@ti.com>, 
	Stephen Boyd <sboyd@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, 
	=?UTF-8?Q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>, 
	Boqun Feng <boqun@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, Uladzislau Rezki <urezki@gmail.com>, 
	linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-security-module@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-pm@vger.kernel.org, linux-pci@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 544mk3sxaam6ftdmwyqy9ee6abddt7a8
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 0498E160004
X-HE-Tag: 1772454757-663162
X-HE-Meta: U2FsdGVkX1+qKjRxU39MiJ26gslCiPFNCNgecilZdpLDBP6CHlVg5iYJPYj8QmnuQvABBUJe9FoNwWHojhuCRTzsDFhP7QvSb4hSYAmJz951QTDlYaxoCSLA59jwW90xPxULOqgS8ggCkQ9iMGrG5m7CIJsulBp+XqCou9hTb4UXvOdQZ7GzEnLgGWLvM8vNTadbzDdBnzEAl5PfId/JKiB681LAnLNCXmGTOvAhLV9YCw1zAvtR3WxbsENOrp4EDGWcBnGCCtolCnRa18XAF2JiMcTxoti3H79hC4fvhLbYgp7bfe57IvsKSUHO1DgRzlaOuCLOGAWVq289H7NSh4JFg/VkhMa8B5qq6NQhDT3tJfAssD6KZCcTop8iHrUIV63kwmTsyxzgSqj0FkViUcllvSzI+/dw1pyBdvN1lT9EGCJe7ZOKomGXZAQ8nPHkWU4PUBUJj3GGGmg4gq5oxcjCvWR43wq4hAy2g+oUzgBeb7s6TlzFLMXAYJBqnMIfTMErGRpx1XeiLMAurKX6xdKokeVrleua3bImycsjNoEX9fDFjHfPBLy+MvPqSlNyY2EArghgRfA9ECv2gQkDvwLq4afyESQaN2SXunL7/VukZkTXDj/kR83EhLqkeJ0BhACc75sAdpPCtT9IXvQatTlW/lpupg5husJN1zTl2Wuddn4zE/HvabQcS31oYX0nRoVCJhFyorSBIhHHldRxIisrdakqFPqBKONHRTNvsXCrZ27TL/ZAQiY1PLt6OIGkTqleX/ApGd06apYCa2744usWzdsfHEJedLVCxOhFXJ3Wr86Ih0ln3B/9zLDqdzi+WAm3iKa/w4xd40a15gxF+PY08r63YrfAkIHV0u+L/zxoEmpDrMe2FiRYTOrgkmedDIr/1uf+W8dwSrmgxOb6vwjDfZJ5jQYHln6QetWe7zFzV6SAFJaaYnnyJsojAJFTJWnL7nL6+FoqFflh4Ra
 RsKytPKX
 Z1IDU/eaQdVs6gNbc/zP6sQiX2VhkPegDxQ3fc5a/YF84x1BKhWfxMs9w8jeEaETPTVmnkMfezeg0r00A/C3fAWoYSeREpYjr60heWACAlQ7Q1JNEwWaSAWuuYza7wT99t2NEo/tZEfgDiuzzEE3SBB9Acu1jW1C425+Wy2NlMcaOBs5zY2KTMnfjIJ9NBmCciYxgv4qZ+CjiS7I/YC7PnMGDrWmqXuNRTt0QPCqQq4Ty5JuxI4iK9Gpwj9NzyKhmWqZyhHMU2l7nTTrw9QtuL1BpYmIKkZQIvmA/6jfd15HkfUCUi+RSUNmQI6ag8c8akbRjUKGVCIzuQie23yLHM/KNJj5HHIvdKeSQtOrspFJx9o3BKjxpcIdYNHhap1ssvCvB46fKQxYokr6tcrkV8qFfauPnqyd4GHGeU/ysQXI9ZGLUNm6Km0gvniqdNeP4cyo9MI1W54XAVVedFqLGultyjuymXYaZUQPkbEtvCggzuatzFo1uBG2zpGBv1ffwjNjvnpAkjg+nwBgCp1Syf1D/6ItOJxzBrvgxy06YVx6B4TZcyM63D0Nv5xl/NtpoHe/j7pZOJG1tWa7ExfTJUdlQTJFlaMeFObySKdwXktErg/4hyu4tqrwsblW/+WZrhWgV2GA7+X1+IcYMl628luzU7A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 2, 2026 at 8:19=E2=80=AFAM Andreas Hindborg <a.hindborg@kernel.=
org> wrote:
>
> I was thinking something similar, in clippy or checkpatch.pl. If we
> should always have this attribute for small functions, we need to have a
> check.

No, as Gary said, we do not always want to have it.

So something trivial in `checkpatch.pl` or something like the existing
Clippy lint would have quite bad false positives (and even false
negatives, in the case of `checkpatch.pl`, depending on what logic you
are thinking about).

We would need cross-TU heuristics for this, because at the end of the
day what you are trying to say is "this function will end up being
trivial even if it may look like it doesn't before inlining
everything".

Cheers,
Miguel

