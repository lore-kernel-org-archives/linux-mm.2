Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88D2CD59D84
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 18:33:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 794226B0006; Fri, 12 Dec 2025 13:33:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 744906B0007; Fri, 12 Dec 2025 13:33:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 632F56B0008; Fri, 12 Dec 2025 13:33:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 518076B0006
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 13:33:24 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F397889037
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 18:33:23 +0000 (UTC)
X-FDA: 84211666686.25.1EF696E
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0D9E5A000E
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 18:33:21 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=BRHLd+A2;
	spf=pass (imf15.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765564402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eUSGmEJqTzYByGnUlGU1GkRTgZG6xNYZQ+XlXEoFmO0=;
	b=2mEnC2EPEB6TR/D1HdmkYSz2mSgcSwTdqEz+SD+63jq+9J1MiYxiFUflcLEGeD26stgaFg
	Qx3wabSs6S4GH3m/dZ9aC5t9G91ILd31TeAfDKDfh3872KmLoNKYp9tdvXzbtsCwnn9cP8
	fVox84nKnddBmsB+XMEih3uT2jhWlis=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=BRHLd+A2;
	spf=pass (imf15.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765564402; a=rsa-sha256;
	cv=none;
	b=IaEh/n66iWwJND+k6RbtQ7xF60L0tRUJLyvtgRGZEWDTIrrrA63R7+K7dBt1G4d+ok/h+z
	RJP/r06blPVEB4TW05TNqIw5CzokZVHgdXM7KBz4b9dX6DXf3rR9Y3kAyQlrPhbZxsZCGB
	iO/3m6J3EUFWJStVvU5E/nYqBe1YcYU=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-298145fe27eso22059275ad.1
        for <linux-mm@kvack.org>; Fri, 12 Dec 2025 10:33:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1765564401; x=1766169201; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=eUSGmEJqTzYByGnUlGU1GkRTgZG6xNYZQ+XlXEoFmO0=;
        b=BRHLd+A20Djvk0t/PTIymTj1G5Glrz+WYGRhgzzHf7qbHtwRE/uO7p3mZ5mFq0S9z9
         XI7u+h8LCB5UEjkdgpc9iA5Ux35bVTre0hKVAflIJUYV037O1ZxyaSkdswx2wkAlyq60
         cV2w1ThBTzo2Us73gXEr9kfuGOqDAc8W41casb9CaVZ+e60AZUsQkCPSl1UaK5qthqOu
         FTjXZOhQUY1Wr/FB0Jxdywf+3GwKRDIC9gRhrmGKuwJvnrKvVGV7WVwRhYoC31vq7PWt
         hI4PFHOxMmb4//lKHogDKhEdDLlOXq6y3LO9jHmIppdjqireMdDnCvqkkMo6cP2gWu0n
         QdCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765564401; x=1766169201;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eUSGmEJqTzYByGnUlGU1GkRTgZG6xNYZQ+XlXEoFmO0=;
        b=GxUgRmainqF5vIMyPyTwdn7bQIE4bXUOvtJzVY2rvgV6qeUbW+gXUAic2Yk5uzANtG
         vjDcpX+qGYvvZAYEFnLj6dYIgDpprmR0sN+HEs6wp3Vbry59WtOiVlkTIISQIi3Omsb2
         cs/iDh5Yirc9HoAua6DjHZvvbgDPdI/P5hTmgnn0OfQ5mvQGCsL22bAYrh4T0280fEy0
         J1TN1gnBwUvYBay1mNEMMfH0pU9N2E/3CnGD1xQ78SJmkx1byyh9IWn74sm72kQ4smbK
         xYGtiB+GyVwiUfRIVrUyO3RGfq4yQliPTHqIf/uRygVz1UsFTMgng0/QwRk24nhHn6pY
         tSXQ==
X-Forwarded-Encrypted: i=1; AJvYcCX1g+yKyOO2rOBhPVDolI7YaE+l5uEQWqk8dPCMw137gy++tM9CGuAfVq9d0TUdZqPAeADZ7CkaZQ==@kvack.org
X-Gm-Message-State: AOJu0YxGVfLoYD7zDqCLOeqTkVzdcq47zmmE3tCOq3OU4GiTc/f6fmNX
	Bct+F6xAk6g8Q+pqXJ6oMKZtjtidyVQaddbX7WjXVv2rKCWzYrL7oh6zlt63oQ7Nju0=
X-Gm-Gg: AY/fxX6zLhKdlPMRkOJqDhpH3q6hfS81R1NwQqMjE7nwdI60vWn5TzvVNV94EIZNayg
	wi9fLA7/aN2yh383JL4bTRmYWSjUno7uB0RZM7SGlpCOtiNg30NqUCLcWVIC+Pi+7RSWYLSygCs
	KOE5agDkWH4lsAc4em1ELXOnEjDJLN74bRxNmMf2eqdqseOianLYFdRkQn4nhKSt5cqYAxiamNO
	Hr8r2dQq9j9hIQuPvePzrHWfa+Pz3Ge/fUOHtso8NLeKcuBspDH4OnEfggatr+cXHupKhUf+Tpc
	dR5P7c3xSFvzqPz9XOK05SAiPNjM8KxHJHh2CXZWbfRyV5EyBjROTorPGbT6mUqR2gL2t6VhgJt
	0i3uqX+9C+UvrB/SZiFTLJ6fuKvoRpQ3d1uO/QcpvFbmbk9KRP4fbve2mXqoQ6iJIBCuB1CUIHK
	wV3V+KGcGJCmikAKDP5RYr
X-Google-Smtp-Source: AGHT+IFtnl41QfJeu3IJ/uV+L4EiFBX8zP0ux5EampS/J9pJIP4sBjIMESLAF9z1UPcxbBQKr8xzaw==
X-Received: by 2002:a17:903:22cc:b0:29f:2456:8cde with SMTP id d9443c01a7336-29f245690bdmr29337135ad.4.1765564400511;
        Fri, 12 Dec 2025 10:33:20 -0800 (PST)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29eea04b7bdsm59970265ad.85.2025.12.12.10.33.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Dec 2025 10:33:20 -0800 (PST)
Date: Fri, 12 Dec 2025 10:33:16 -0800
From: Deepak Gupta <debug@rivosinc.com>
To: Paul Walmsley <pjw@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Conor Dooley <conor@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Christian Brauner <brauner@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Eric Biederman <ebiederm@xmission.com>, Kees Cook <kees@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>,
	Jann Horn <jannh@google.com>, Conor Dooley <conor+dt@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
	Benno Lossin <lossin@kernel.org>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-riscv@lists.infradead.org, devicetree@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org, alistair.francis@wdc.com,
	richard.henderson@linaro.org, jim.shu@sifive.com,
	Andy Chiu <andybnac@gmail.com>, kito.cheng@sifive.com,
	charlie@rivosinc.com, atishp@rivosinc.com, evan@rivosinc.com,
	cleger@rivosinc.com, alexghiti@rivosinc.com,
	samitolvanen@google.com, broonie@kernel.org,
	rick.p.edgecombe@intel.com, rust-for-linux@vger.kernel.org,
	Zong Li <zong.li@sifive.com>, David Hildenbrand <david@redhat.com>,
	Andreas Korb <andreas.korb@aisec.fraunhofer.de>,
	Valentin Haudiquet <valentin.haudiquet@canonical.com>,
	Charles Mirabile <cmirabil@redhat.com>
Subject: Re: [PATCH v26 00/28] riscv control-flow integrity for usermode
Message-ID: <aTxf7IGlkGLgHgI2@debug.ba.rivosinc.com>
References: <20251211-v5_user_cfi_series-v26-0-f0f419e81ac0@rivosinc.com>
 <e052745b-6bf0-c2a3-21b2-5ecd8b04ec70@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <e052745b-6bf0-c2a3-21b2-5ecd8b04ec70@kernel.org>
X-Rspamd-Server: rspam02
X-Stat-Signature: uecbumijhfwcamrfnhirdg8kg3gboh84
X-Rspam-User: 
X-Rspamd-Queue-Id: 0D9E5A000E
X-HE-Tag: 1765564401-621346
X-HE-Meta: U2FsdGVkX18iCoCALFEZ/+oWxYKN07Egd0EFkgGUrce/AAZMhKNyR0rHE3MVFxw1NY9jtOgB0BA0S2ORu9ODLTt6+/TEshZotsUbddls5q5o8sI8d13czaFQycsB6JYMow8x3QnpS1BnfhEvvsA2il/6XvWg5qdUzGdkoVLDF5aRNZEFqJbExHjqY3VT3RG+/sIkFD12cpGtQ6Yxxe22sf9Ub/9L/xkA00vPfgsdZCO/pUH66JWi3Og3cRtbK2Pyz7Ohrh99dtf82cOIRAaVyC+UmD/HGgFuYTofFEWR+ntiwjZPYnfu5ss9DedL8M4vhTkrBlgqlc4DsHx0vqxmguuFsIOPLvWVua9aI0D0OvrS21EANbhW0PPHcoT2bslD/zYFWYjEqrVZkDNSZnI9W/VCBx7bh9xlY80b0CNznkDDB9k6qB+fNfYWnuYWwXV4eRbxzYR1u7w/Vbu9D+vmJtclY+0OxBRafPeTEOrnN9MZ1B/BrQHyGs8/YBUBwN/iRcq6dc79dAna9ejWKZjB+9GT2VUeQZ7nDIor9Juvok4Zfpj2iZPR4t8SBRMkLla0ky/QH0h8LII3EeNO9Ymoo+Qns+Wknt+z9AQQUrVvBsSwCogaRRHZgwQB9b6fa8T22IUfhwDXUPZJtg86Zo2xXsCCUFj01dXYhPhOjgvuI3bxhxNbmFma2sf37Ev6K17yo75zEkZZpU7cZ4e0p2rEcv+gYS0PbEISRNe03ZmOy/4dvXfVIBg+zX+rrweQtRgjjHex/SAy+Z+0Qm8fJ4eMOJhNr2OPerthYC1b7Si8/cAE7cTRpQItn8kWmnHiIt+gJWxmxgArmv87tYhTT/zymxIWuWvhbWh93KgNw8F3yshQNsNer4JOuv5vwIS5ph9NoIBa5rDav8BelDygHDLoYZ11OcTCVvYmMQgyRKRzPpaMN1UHgRAHaeDXy1dJYEXUM29CZ4xz0oI0c1xlGE8
 1dv2xAJb
 /GMLiwWFZP+43qrJTVDQ9C/NA7zduopiM0aip9e318XlvkjISBh0j29CVcLkNhfM99zs5nrjWDYIHRSfdfMVlC3EKrVpMENA5NHKjbuVoYNMovCs2Qsw09ThDOqn1oTxEL0hEwKW+oWhSkO3y0O6IioFxYNd46diCFZnfaJ0gl4RT/rlTxLImhDGSr6TMbsnIT+Zp4wkGuSH7aNrU1yExitXHy0wA7N0Nl++Bg4VJ7tY+GxidrgyBpSlhASWRBt+PJkIqjsrMD1uyseyvJwsUYSsmbST99H8fiIACUVDQRGjNkqTg+Ljatf9Xz9Bgwn375L2njKbuLUvACN7hSzVgRBFiJoKl/7LReZ8nN/ayQmIAXLQX9RsB3yhU746n3/zpeJu48dUDn31BEk0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 12, 2025 at 01:30:29AM -0700, Paul Walmsley wrote:
>On Thu, 11 Dec 2025, Deepak Gupta via B4 Relay wrote:
>
>> v26: CONFIG_RISCV_USER_CFI depends on CONFIG_MMU (dependency of shadow stack
>> on MMU). Used b4 to pick tags, apparantly it messed up some tag picks. Fixing it
>
>Deepak: I'm now (at least) the third person to tell you to stop resending
>this entire series over and over again.

To be very honest I also feel very bad doing and DOSing the lists. Sorry to you
and everyone else.

But I have been sitting on this patch series for last 3-4 merge windows with
patches being exactly same/similar. So I have been a little more than desperate
to get it in.

I really haven't had any meaningful feedback on patch series except stalling
just before each merge window for reasons which really shouldn't stall its
merge. Sure that's the nature of open source development and it's maintainer's
call at the end of the day. And I am new to this. I'll improve.

>
>First, a modified version of the CFI v23 series was ALREADY SITTING IN
>LINUX-NEXT.  So there's no reason you should be resending the entire
>series, UNLESS your intention for me is to drop the entire existing series
>and wait for another merge window.
>
>Second: when someone asks you questions about an individual patch, and you
>want to answer those questions, it's NOT GOOD for you to resend the entire
>28 series as the response!  You are DDOSing a bunch of lists and E-mail
>inboxes.  Just answer the question in a single E-mail.  If you want to
>update a single patch, just send that one patch.

Noted. I wasn't sure about it. I'll explicitly ask next time if you want me to
send another one.

>
>If you don't start paying attention to these rules then people are going
>to start ignoring you -- at best! -- and it's going to give the entire
>community a bad reputation.

Even before this, this patch series has been ignored largely. I don't know
how to get attention. All I wanted was either feedback or get it in. And as I
said I've been desparate to get it in. Also as I said, I'll improve.

>
>Please acknowledge that you understand this,

ACKed.

>
>
>- Paul

