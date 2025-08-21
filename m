Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 457E5CA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 10:31:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB2108E0016; Thu, 21 Aug 2025 06:31:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C89A98E0003; Thu, 21 Aug 2025 06:31:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC7238E0016; Thu, 21 Aug 2025 06:31:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AB0EB8E0003
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 06:31:33 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5D545B84E5
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 10:31:33 +0000 (UTC)
X-FDA: 83800398066.11.CD42AE7
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7EBAEA0017
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 10:31:31 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mbRggUby;
	spf=pass (imf15.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755772291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=913Rz1D2vRcGEtURPFrrhnXSizcosdo+3hWGTRcSM8I=;
	b=X7szKI98pUB9PTLviunBt77IhEsuQ8l24gGCnPx+45++PCPXkn32rtRBkrUBQ0QTdyTB3G
	WcmSBmEF7zhEpdBoHAt/bBcUaBBrgUD5hwUWXI2jZCZimdIxHFEU1jqcM4gsEvdzfw+2rG
	RmHNNVy5o7TgQf3cTCJsY57g63FkAc0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mbRggUby;
	spf=pass (imf15.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755772291; a=rsa-sha256;
	cv=none;
	b=e6TDSeTxStPyY6RFeuPga+aQiUq9yPoZnI/zyjPQo3oM+8em6eqW7kajtGdXmFo408wOHf
	B4d1D0pB/7Qa6iPlrI/M76N2wJhW55yvFI2vGt/LQcZ9TuMqcGTWFwE373mTtxYFmwHJWs
	1MRWj/u/HUra9YWnqjXdiSrbE9/D7xw=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-24457f3d233so1455035ad.0
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 03:31:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755772290; x=1756377090; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=913Rz1D2vRcGEtURPFrrhnXSizcosdo+3hWGTRcSM8I=;
        b=mbRggUbynVVPCESkU1Sji8c97u/Rn3zAWhSsGES0Lv/qJAfja90e/eXesUNyoEHAhV
         Qood4J0ZnnJTxJ6BXtHZHPSnfwg7a2Whx0uBECVPCvOJDaeheDnc8RBXtkgE2PoB75Li
         xkI9/pNXgW6BM2H0JcWNcqsu5H8Ud2BnzLWZylrauqSMD2Uu5aP//DJ1jjqrC0VIObl+
         ECRRWoVNFSVaWZpNIgfW7lPfDE8XAr51dxJl98MDtPey8pT1eH+YkkhmAf07fs0vokyv
         NLXM2mc7vKI3ZfJRFRduFQitIkxT3OaCiKsqF2SMIfThfh/C0y+T00muwhoZPTKCOJOv
         jb9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755772290; x=1756377090;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=913Rz1D2vRcGEtURPFrrhnXSizcosdo+3hWGTRcSM8I=;
        b=OltHkdxe0rDw000oP9zIl5vC1qDsKDmPVho6wr+arbBISfO/BBRGkjOVVRqf5P4j7r
         jgm6pFp5vGKn5o8ZVNsqdgoy+FDvR3mSeFMtByzlaWdsxT0AnFJ3LhRrJm9mWHcV9uUv
         sz+Tj1xaXCBh/5pSBxz0OZThxZFv+I/OQOmPVnf1H/K24RepU2FXLqUxent1acpezC5K
         v48Bgr+mKMqzt0kfhVQj2m4lwLuQvsSY620xRDF3+9FVE9Nu6Dry83SdZf9wi+Rqn5qM
         uJ2OkKm7deVi4Id/qL2Z/jRWMHVNBGs9UyvKItOZ96pSilMKJvBnED39I6NG2Hnbrxq3
         5lMg==
X-Forwarded-Encrypted: i=1; AJvYcCXytQ4gDCOaM51URce6wx9uyiG71x4k8ycS5WPmZEnRWSLJ9f4RLzbJkq9PTuX1dUgUIIYxskylkg==@kvack.org
X-Gm-Message-State: AOJu0YxtuLIluN+wVSYgSroDRBkmJkxIexpoTnyWc32LXbqsA3doAP1d
	bo4V8cxNvP9ER3MBGYxWr0wlekGPzxlQak5edwK8jbe3CIzXdo3zQNakEy0udla3sFDLVUUkfvO
	FSCIx+IHNs/9DMEprktJVAOQNvDl0l4o=
X-Gm-Gg: ASbGncv+GjxIo9sG7XZzTfrPomHAkmAztzdSXZJSNzqcnftGgeB42/ozqLHmaErWHcD
	CnhWpGWUkn1ceOtB/X/Wp+O9r9izLuSDjKZTyw4BL+cdtgNvaPP3PJG2/1Ij6P8MmYM4njbSZWh
	NN6/bL4XqWkJ6rMkBgUW/YP7mSFWoERhZyxM9JyrJDoCOW2lmXXQd0tDwZtD6QWKKB2CfbPPq0J
	ZcWQJbbpe2LHEXatZ4=
X-Google-Smtp-Source: AGHT+IEjm0pT1tYKH4wdQFS+4SLVyM2EzMLuRZ4+YtmFOUPkssVGEQdTiYEF5APh7HBsvfeJHB94RTHEn016hNWb+Uk=
X-Received: by 2002:a17:902:fc47:b0:23f:fd0e:e5c0 with SMTP id
 d9443c01a7336-245ff86b777mr14664805ad.9.1755772290139; Thu, 21 Aug 2025
 03:31:30 -0700 (PDT)
MIME-Version: 1.0
References: <20250812132712.61007-1-baptiste.lepers@gmail.com>
 <20250820162927.34201cfb395ec7319b15920a@linux-foundation.org> <CAH5fLghx7K1fsdx15VsaTT1i3DRQD8zH2Yd-sEwumiByefTVAQ@mail.gmail.com>
In-Reply-To: <CAH5fLghx7K1fsdx15VsaTT1i3DRQD8zH2Yd-sEwumiByefTVAQ@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 21 Aug 2025 12:31:18 +0200
X-Gm-Features: Ac12FXxLCRtkAiXZ0gKUbVmOrCcrysG0-2smcnGVwz7_v545hEOcpz9rG47jg8I
Message-ID: <CANiq72k1o7bi9tE0tQxaiu39_Drbvz3bPNXibeCightzEuDjWg@mail.gmail.com>
Subject: Re: [PATCH] rust: mm: Mark VmaNew as transparent
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Baptiste Lepers <baptiste.lepers@gmail.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, Jann Horn <jannh@google.com>, 
	linux-mm@kvack.org, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Alice Ryhl <aliceryhl@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7EBAEA0017
X-Stat-Signature: g1catwkdkb3smcbjzhk9bmodhc9rxo5e
X-Rspam-User: 
X-HE-Tag: 1755772291-159266
X-HE-Meta: U2FsdGVkX192BXAdAWJmunztAbfdQki2VjK56dz5rOfRLkHZ5jqOTB5374Xw8RAsJRzWvLsugW/meUGjoCXxKYzxim5y2hQy+4DRyzMyGPhwRJ1Ic0c/1To/E71eSekmqe4YBQM4hbzSvd5JY6TG2P5pKZZAb1Ebasa+Ozi1wl+f1OjV69KKnvZoo4K+W1rR2Z8yJoced+/sMnlTEnMimvZDan5xTwHRxR5PobhA7ygXSGSBINAckTq0CpvQE4QEM1Pdr3bDBsRWelNuD61Df3EGy6PcgpBdbsWChqG3pVSiyD2BXtfVv6Z6RmA7AX3eU6LKwyfTHLVnP7uex+iSoZZLfjcvdb1VEyurq8r//+fOMMLPIz5Dbt3vry2OOumpZ4j9P9pOU+t9HZBcN6DXg9FQ5h9tEsvu1VDvm4sjIJB4CwWKo9N9wFenEpOTVF7lNkK6BuqWxaVJHviC1bDQ6v3OV5m1YVhAA6Qx9IDfRo5VLINVwFtFertu3UqA6bPzpwUVc1GdoYDN7wPmYgPW8uZ1ikmGvvgL5bIaJ1cTaEfoqSlrKsQiLmMk5RX7u6uiAOAsHM0x9VVupGRqDCcW1TsLYnfSMVI2QSyo8Arz1HATG+395Co3iMNTVTWffm4bJBWwwUeqxMFvJk+xZKU/o7VrNl10TUHHJ1AFOu1Rq4h4oinElyD0B4Jjzo8xnZH+cNM6hTedq7XP+QQ5USqHmrSUQ20/G6OHfib55RedhNIvl6wcQ7X98bNcjFpAF1EbRnueN4Ld19l3I3D39WE/oR4/yHYGku9oFpJ0koXyeCQOnmmJzJP3bENMk+tY5mb1JeTt+ITLd4GUojalP0JFhpQBpQxIVZG7HuLEyneJnsA764kc7UgHsdnuTY6hkB+jvV2EDpIJBhhvcZmJwRc+tSQc513chpTbfEVvKDwCyyxTYhdnk/fT1NwQaco9wDUzlomtgEM8zyfCKvC8xIs
 CSKA+Q7T
 ROc3pUvWOoq2Sd3MFnghTsZYXOlSNWRj8gKrEHRruxvCjGk2OtKeRccPfGALYWdmFNstWYOmct+ClxICdIRLvEYMP+wRwoZHTKN9xUm+CBjZ7f0SMOeBE2I+VktliT/wUz7AdtgtisfeQP0LDNmBjJ+PRrbTTEZba8xnQs4W5f8RvdFdj7z1HqT5k+wKyLaVcke7WrSeA/pFOim07TxcaLfPBtwKhyJEn8hIXX/+kGc1zgmWU3UrGfhSP6LAAILEqBcbZ7tjEa43QoJ7NQXABo6hwjQhLp3ZkM0OalbRKdASpFgRGo2Vzym3Q6RyguCniwBeDQjGcOMtkCgcQ77NjHr6FIVNXDnQkPXl6OEQvZJ7YT/6m+1Cf5dsSqPbFMJQRR8aakInxf3sOXq733MZrIqJCe+L7yfppoM+xgVZoT2GTS6XIY2Ce2soIUn4iLpOkIF3b0rh7+SORzg7ccLVACS26rHNcCDxVPw0H7n9r5QvmxGE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 21, 2025 at 11:45=E2=80=AFAM Alice Ryhl <aliceryhl@google.com> =
wrote:
>
> seen many things get backported when they are incorrect even if it
> works in practice, so that is why I suggested to backport it anyway.

To clarify: "incorrect" here means in the stable kernel, i.e. not the
backported patch.

Andrew: in the past, I was quite conservative in what I would mark as
Cc: stable for Rust, but after discussing a few past cases with the
current stable kernel team and/or being requested to add the tag, I am
nowadays way more optimistic in tagging. Some backports would not pass
the stated rules in principle, but they still wanted them.

For instance, I tag even Clippy cleanups (so far, since it seems
doable to keep it clean with the amount of code we have).
Nevertheless, I still skip the tag when I really feel there is no
point, and let their scripts pick them up if they really, really want
them.

For this particular case, since we support several compiler versions
nowadays, I would have just tagged it if it had went through my
branch. There is also little risk whether it gets backported or not.

I hope that gives some context.

Cheers,
Miguel

