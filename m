Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DDB9CA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 11:26:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 519E86B00D8; Fri, 22 Aug 2025 07:26:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F1526B00D9; Fri, 22 Aug 2025 07:26:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E0086B00DC; Fri, 22 Aug 2025 07:26:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2704F6B00D8
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 07:26:42 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E620554E60
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 11:26:41 +0000 (UTC)
X-FDA: 83804165802.07.91C3A3C
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4125C40014
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 11:26:40 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=X+TVMW0v;
	spf=pass (imf27.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755862000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V4wnIhr7Fp6tVW1RFz7BAgUt4LWPfblWhtXcE7RFhfI=;
	b=Ptmq1qOBiHSjsP0ntYLXfkjUAhlRowZ/FC5kAAGr+zgvsZJMLb4kRjCKuSrkmpD2tyUekG
	ZMOQ1WpL18GLuIV4Vq/0XJDgnQGqAM5/B+ciCLucnV6R94vhQqlJ/fF/aOXr3rpK2gQZkY
	etHYcSCDxJlyoR5254JGBzuy7DH0IlQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=X+TVMW0v;
	spf=pass (imf27.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755862000; a=rsa-sha256;
	cv=none;
	b=jnMpANGL13hiJBPrN080Jh1san567XLxC7k9TWCBN7FBK/dWGxfjVwhJY2bTK5itiOQnnS
	rJI5U4ZNf3NSgc1jB10p/Rr2My/BW+RzgDolTABBgrYwoNsHm/lP8GL8gBsXqL5sBoylUI
	1JRSt6EHn+2pGioYtyM0DAinIEoB+p0=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2445813f6d1so3104805ad.2
        for <linux-mm@kvack.org>; Fri, 22 Aug 2025 04:26:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755861999; x=1756466799; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V4wnIhr7Fp6tVW1RFz7BAgUt4LWPfblWhtXcE7RFhfI=;
        b=X+TVMW0v2JfUgFh35FR5K7slfgNolVIdEmoiCVrJFfU4uUuZZvJivB1A0Nqd63b9vz
         bLsG85WPrmTnEDym6OClsdaboEdfUUd6qT+faQRCDELZ8Iv86iGfq7G52bk/hG63oEcx
         TJ+If0FjXFg1YBi5QOfRsWo2YEVrF602vodsisuhj56fuyyc6pWHowaqx3i07pexe7xB
         eGarFTujKkTkfPq/8Uqqb5jaR+8U6X4LhyShZL+GVg2OTV1nNINMSLN9KhtTZ47YvYTY
         /uTJmr3bJxxHGPYLHsyIIT6j2dlu1xrSNx68MeGYM5aA0PI78cnCjCjPvzldgTku1rTM
         K1gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755861999; x=1756466799;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V4wnIhr7Fp6tVW1RFz7BAgUt4LWPfblWhtXcE7RFhfI=;
        b=ctNYMlUHbyA0dxnbjtjtaPG4Lxnbk2nfGShitka8WmfZxjzyteou3SB2mvW/yyePku
         fVAY+FnOxy5OcPrd+XlYSqIXK28LyP3ezR3iKlf8X4P44OrY1X337icdLR7nbw4+C6lW
         JVC0L1UFAKlJ3Eamp1JzxgqQoyFak4KQUK/hRAbAEwYBMq4QiYO7za+YQ7pNL7ubv+fi
         JE6c+tveHDPJzRa+Epr6mlfm3c/Pn6f1EkQRyr57zCImMH/lzRx+gkFJMGvCZhE9TdLj
         2RXYJsXu1xZyLnHhugX2oJeUS/PVZtFb+4LcyCgrirgbNWeaBVIzi4uReb6eXh0phNXd
         We+w==
X-Forwarded-Encrypted: i=1; AJvYcCVHq+i4GXrwMu3WI086hXVXydEVJmUUwQ3nLk5ebNsHtdsYjHovbWq5Mj5yXq3pPI84Rqq/CyEVLQ==@kvack.org
X-Gm-Message-State: AOJu0Yxg1ScnEiT7YnhNOEuAXV8cEyC120ViYJ4lgUm0ljGUXoBsAIDL
	8oeY1d1ohS6MVecvHdc9qssEBYYpCLZrD3awy3TD7owes9PHAmMkZrKrbdgZ0lzkyDWj3q+dk8v
	1AloJnuonkwHg07trWRKUHmPMoPivCQA=
X-Gm-Gg: ASbGnctmtiP78CV+pkZNR3XAfJImXP+OOwMP8YKH2xiZNwIRrexMD6ZDqIZq2x9WMu1
	UM5XBoNgCZYGje0HKmeglG1OnDPRsTLu7+RXf1POw6xAh4F8jPYcTg6IoV9dXR0/YzRExH/2Yqk
	NSU3GaB5dH+ILPJZRQ/6VePMnKHEoQG903zxop/YsFudLH+2bEPInPZNBesz6M/Ip8eVcNJ8wO8
	cnuENJ4HGHldNzRURomQwTN2XcDyxXa3/7CAD1vcUY29MSyiHHcsZrPnKTrv9mYxeNCUwKzIVIU
	oMWgS0PF5XZTAOZNzLs7faYzFg==
X-Google-Smtp-Source: AGHT+IG7lTxmuhL62ZlvYH3P/Mu34+dY7fv3Q9ryPId3zBRUb9VRVWQdWMfwHCvijjEssnYIFiSuiqA20Ad2iN5Drgw=
X-Received: by 2002:a17:902:c409:b0:243:589d:148e with SMTP id
 d9443c01a7336-2462eeb1166mr17788305ad.5.1755861999001; Fri, 22 Aug 2025
 04:26:39 -0700 (PDT)
MIME-Version: 1.0
References: <20250819-maple-tree-v2-0-229b48657bab@google.com>
 <20250819-maple-tree-v2-2-229b48657bab@google.com> <DC6DC244ZIUL.304JSP7JFDE9Z@kernel.org>
 <aKRx8xsY8CpzbeEm@google.com> <DC6F7BN2L19O.1APQU9KWZV7H5@kernel.org>
 <CANiq72=xdryEKzo73-1vaBqGNNme2kRU0atP5PYOnOOXjNxZZg@mail.gmail.com> <DC8WOHIEAHQD.21VWTH8VI8QG5@kernel.org>
In-Reply-To: <DC8WOHIEAHQD.21VWTH8VI8QG5@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Fri, 22 Aug 2025 13:26:27 +0200
X-Gm-Features: Ac12FXz4tTB0ezj6BOGHpfVwiA6-Ww-CuEgl0dtOx4e2nF3EUki4Y7Epvx3OleQ
Message-ID: <CANiq72=ZZ7+tMi_XsRKunGAqm_v+kehFqzpEMMqm2qcTvzA9Mw@mail.gmail.com>
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
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4125C40014
X-Stat-Signature: wy7gdnrd15jhrgcjh7gxpf4rcmpte7c6
X-Rspam-User: 
X-HE-Tag: 1755862000-826736
X-HE-Meta: U2FsdGVkX19a92sMB5MkZthJ6VtDTZ7lUVZnj/ne15EQu+HuUd6SqmEv5/peJRXeZF50ZCK+64JQpgPoldX4rR42BCEdAyMt8tdmUGYIWX3pBP4rB4qLSLfVq5BzTjuCN8KbmTNaMLJuGSllshfoEjFN8ZVMg52xrSk4PHLvevtBFLnT2xT8+MQ11sfzneRepm7Zi9VQmPrm/PYN706mAqY3f9YpQjMVvVWurZlAAsx3OxdAm+MVX0/spmYlfH/SX4dfwnz8mfnZzfRa/6kh1noUr4LOWdxg15eG/MxF3WP/LLBFvwSuG4wb9MZos6sZCuK4vTt/hTPcMZCa0nAs7gpPbBsPRTP/puAMcAfKOW5yTRkwd2m3hAPKUBLaj6e6ZOkTmFgOs/cr3ArY6XisiYzcsbosnt4LkhMt6dw32uoYRqZrwLJuUJqZ+s0PUhRiwzhR7Mkyy+ABey2uU4/Q6WyZ/U2rhFB4GQ8u4YLZ+KhlwrLyzbSG3gxx6FnSA+s54prPSYG0rrMH81a0uvWwwrkRjDPZaPVOtaeywImnFdDRNRXJBAex2DbdWIu31cN8/9ywYvJXFN/nAojh19ZKOpMQNzTxk01tb+yhdowtdsBwVYBxSlB8gGEKq5ASnmswIG4/OveoediuY/KzR1tC8kwcHzBRxpEWGm28WzI+GDOhURY730TzmFFgCZfdmzciB1SAXSd/LUeFDWdI+NFLyJfe+wNf6C+ovGaN0BrFwMxewvg/NtVxqNZfaB/bk8z0iuNNugV+EjPPR+94yXzB+uMSb/ia8fU8NrNlmEV3I7+GKQM4WnhReZ9mmkpw2lILRs8zq8Vy6vgV+gqZlck1yBWsjnBdb56WZ3U9xntf8buoONvimvJlhimOwhJV6FzL4WWem9MGxLYsikDycGNUSqPJF6nVI4oKBtZw03OyWy1gs1MF+GY4BvMdARH39NdBNWVZaAbK5BE++pFvnrp
 LksBgFU9
 ZucU2lnWhtIQqwSy2T0F3GL42m+VV0NsT5R1A+65QhV3t8HV1Kne/eR4O9Jq/dJodl1KWM7wpCIBEldbatdmDWm7Q15kNEyPYAjQXQbqlnqlvYl71i5U1GwNdiGkWORLK+CfVsd0FOgLJ2S59aEoYH16eNw0A08hbR7MOB8Bc+sSThkM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 22, 2025 at 1:05=E2=80=AFPM Danilo Krummrich <dakr@kernel.org> =
wrote:
>
> We should probably check if we can get a clippy warning in place for this=
.

There is https://rust-lang.github.io/rust-clippy/master/index.html#unwrap_u=
sed,
which covers all cases.

> we could also write
>
>         assert!(tree
>             .insert(100, the_answer, GFP_KERNEL)
>             .is_err_and(|e| e.cause =3D=3D InsertErrorKind::Occupied));

If we want to use the Clippy lint, i.e. go hard on avoiding all kinds
of `unwrap()`s, then that is fine.

But I wouldn't do it just for the sake of avoiding a few
`unwrap_err()`s within `assert!`s -- I don't think there is going to
be a problem of having a lot of people concluding it is OK to panic
the kernel in general just because they see an `unwrap_err()` within
an `assert!` -- the `assert!` itself could be also understood as
panicking, after all, and we really don't want to ban `assert!`s on
examples.

Now, if we do get something else out of it, like enforcing no
`unwrap()`s (still bypassable with `allow` etc. if needed) and thus
removing a class of errors, then that sounds worthier to me.

Thanks!

Cheers,
Miguel

