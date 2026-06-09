Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD372CD8CAA
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 14:11:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D876F6B008A; Tue,  9 Jun 2026 10:11:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D38486B0093; Tue,  9 Jun 2026 10:11:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C26366B0095; Tue,  9 Jun 2026 10:11:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B040B6B008A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 10:11:17 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 77E171C2CFA
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 14:11:17 +0000 (UTC)
X-FDA: 84860561394.05.716AD47
Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	by imf07.hostedemail.com (Postfix) with ESMTP id 71F094000E
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 14:11:15 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cmxoGMWM;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf07.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.175 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781014275;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nhjDW0OszKJAGtPcPLD3bV8YMBm1E7bkkVTPi52pFmI=;
	b=NsgynXHtoh2kKFH5vdWS3Kv6R8SanQQvKiwfuAFgC3XN+nl37K9aProTg7mqirVlO+BrjH
	bJhU8yT21ScqhosKtjpGW+alRwQhvIRVe9pmKE5tbdw1I5kB5FN6W9egMe3H0wyDQeJ8X3
	d48VbNbwGf3P2ZXw5wWsRUb+TrAQL2k=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cmxoGMWM;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf07.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.175 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781014275;
	b=6EY5YYDp5nu+dXism9jI3/GblKwIlLpuzCyrXCk4P99v4NosX1cJfoalgtWDZukujaDau9
	mmgLhlTRKg1FOJIO1qlMD5/CfNE7cUXzGXblSedHUEiDLT7WR2tPRHyXLkSCWD9p+bjR8F
	4ElwWgrc84jbyrW4s6EnKipk3i+SmmQ=
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-304f9bc869aso679089eec.2
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 07:11:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781014274; cv=none;
        d=google.com; s=arc-20240605;
        b=ht8k0EckWA7FTD/vik4jLALLrfU8PwPtrHGwf82rtycQs/h2+jFMUmM5r0ab5Ynmsl
         Wn24eA3CiRkhNg5KCgKBvsLob91qplavq7VYpHy6fWcg3rXxyKSMtr0bOsEX1jzwpmLp
         RTDWU/5wB8Y5rwhkYdeTWC6V2NwYvFEx3N3EJZm0hDcxuOmVYNE3VXITpNa0Ix15q/am
         OaVSsApejhrRftXEKn3P4Pw2V9hqy1KEk+3h496f8R0zQxaMkoL8frgS50MF3T8bLEhl
         pm2FvUA2fKQhUmJE7WoYyxw2rO0USKxUhafe30ig4mZee5rrYd7AXo1V4eX2kmMs8K4A
         deLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nhjDW0OszKJAGtPcPLD3bV8YMBm1E7bkkVTPi52pFmI=;
        fh=xzsWUNkiJObeYjhOdUIQdnwsrL92wi4fwAbH0Q0Mi1E=;
        b=X2M1Iks6bYvK/72wIdOUQpri9h3Qz4GIP+FJSXeGCPMVzN92zTsbe+H/r5KJL7TFhw
         ABYGS1WsIAPke6SavMX3X6JC8yXvgcOgdeYlIeBjX/Yz5XN489AGLOZQ4JSwK5fd8qF8
         NKqjKZ5jIEwHeFJgdFISON4N3elcEYm8jc8U5POi1EtdU4KyLrvKy1uuuuv2W17/YOAK
         NRXCht/fbNCIZshJf3zMufD/WvBfAz4ZGk9fMlD+7SSCOrYRqPBplRNqYB+P0NzKbcFa
         Nn6YbZGCXcmfDFQf5Lkukpb9RKmIrdREcOPtU7KIhBMefQL8drp4QocuSnX6cUJZMO21
         7wnA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781014274; x=1781619074; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nhjDW0OszKJAGtPcPLD3bV8YMBm1E7bkkVTPi52pFmI=;
        b=cmxoGMWMidzeNggNUbSTDHDXyJgwsDc2cAOTf98ynpSE5rOZp+ToaFm1ybSgGF7r9D
         cy0znMx/smyvYujH3M0LixfYKweI0cYz0RYZLnuhBpb0YwXHA48NfdCquioRhulJN5+5
         y2bMSJhS7Y9kaAyJgETFZvDyBNpi3FIbTWd3dSDrf+sOg+zWZ+X4KbK/Ozs1VCvqR6Pl
         3f8LsNTOtuMfKwAy25weJMv0jUgPDhj4AWgakRRQpwvVHYtQ+0xyZWlk4/qggd8deNlD
         9Cojx/VBEm6Fnv9u482s46yfTaSnP7VancrrHRZlCgCNxd3pI1Iz+FS8yXLIHPHISHsY
         ohgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781014274; x=1781619074;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nhjDW0OszKJAGtPcPLD3bV8YMBm1E7bkkVTPi52pFmI=;
        b=C4FqSs8gcBXjElRQkvFz+zG+lL+XCUyOp59YdcSINy8PqsdipkhsTD3dbMdIcHED/+
         lq/oEFzqc+Qf+qVINdPWm5/uDvUw6Px28ztM3WIeIpDHXk6FMAV8PU1VwE7RS3/6yN7L
         ViyNtEB4VpI7fFP1HNW8nDXpTz11MaRXKqkjJhuLRkUDOevaLTKv3Z/dahtKMqlzv/hB
         rzs5e3Cwc1tTRBiUm6US4+uz+ATZEEACQWUEKSbK18Rsr6bsxVOG0SVccgl9zSfJvkbQ
         +hz0jmf03qgiPMV8IstwNyRtPs2luTzMAKDTEkDOJHQtpQ1tLKbIxEN/ENQ0smapt4bh
         UmvA==
X-Forwarded-Encrypted: i=1; AFNElJ/WWiWIda2NJBejpWXzFbWlkaGyQWacpmz2FD3mcse2JZmjy0avfYadRvFbxEtIdNR3/GqICtBhyw==@kvack.org
X-Gm-Message-State: AOJu0YwVoECfe4MP2JyiSFE9bXqccgPvZhWNlAY5n9sCjCVfK4U9CZGA
	dOgkkqEIfOPWy0A7+xW8HKSevWduFspZcmekquFgH7IC9g4wml36i7YDRkpm5fsGz/7p735zeuh
	Pnz5zgLuIZPjyxs7QAC4bx8klIP0QuNo=
X-Gm-Gg: Acq92OGv1XSgKEZrsawInAtAf6Q12MY7iTdkBUScqkz2/jjOGKhh4rxJoavEMWA0Cu6
	ACwjd+7XoivpR1Kvmr9x1/qnSNtHlE9zW+YjZVVXwPKeQkYiV9Ysr3p9MtyuQ8cJGXN8DGXJ22A
	mVPtoQERCKCBuS2yLIlWASWZGkz3frT3p300Ou0bzw7kZFTGZ35oFBqrQN7xoQuAG2GADoiuj8l
	9HY+qQL3VUhk7bt1FZyI2DgMq1iKLJNNYRjBpKUXEIiTZcZXz+96NtiVaCvHoPg44lCssHCplua
	w7KUahJ3qcHapSkg8WScdQ/9/t9EqWvnmN/gtw8y2fD540My2an6aKGJlf+/dfOu0YeiEupzyvr
	k09QyQLQdDH7+NXO4A1505D3IL5/3nAamsg==
X-Received: by 2002:a05:693c:3749:b0:304:8860:74d6 with SMTP id
 5a478bee46e88-3077b21ea10mr6213247eec.1.1781014274135; Tue, 09 Jun 2026
 07:11:14 -0700 (PDT)
MIME-Version: 1.0
References: <20260604-unique-ref-v17-0-7b4c3d2930b9@kernel.org>
In-Reply-To: <20260604-unique-ref-v17-0-7b4c3d2930b9@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 9 Jun 2026 16:11:01 +0200
X-Gm-Features: AVVi8CfNPwpEZxw0N5nqXBfBlOCze0ATuinL6YIsUVP51KJlhLB9xVsEvEDqHhw
Message-ID: <CANiq72nkYJnztntLzB5jNwi_oRY+V7UMpf6AuKM07aGH9FwPdg@mail.gmail.com>
Subject: Re: [PATCH v17 00/10] rust: add `Ownable` trait and `Owned` type
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dave Ertman <david.m.ertman@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Leon Romanovsky <leon@kernel.org>, Paul Moore <paul@paul-moore.com>, 
	Serge Hallyn <sergeh@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Daniel Almeida <daniel.almeida@collabora.com>, Viresh Kumar <vireshk@kernel.org>, 
	Nishanth Menon <nm@ti.com>, Stephen Boyd <sboyd@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, 
	=?UTF-8?Q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>, 
	Boqun Feng <boqun@kernel.org>, Uladzislau Rezki <urezki@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Igor Korotin <igor.korotin@linux.dev>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, 
	linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-security-module@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-pm@vger.kernel.org, linux-pci@vger.kernel.org, 
	driver-core@lists.linux.dev, Asahi Lina <lina+kernel@asahilina.net>, 
	Oliver Mangold <oliver.mangold@pm.me>, Viresh Kumar <viresh.kumar@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 71F094000E
X-Stat-Signature: cbdwqdg9uxgchjhpxszpembw9nqunzjn
X-Rspam-User: 
X-HE-Tag: 1781014275-997000
X-HE-Meta: U2FsdGVkX1+rYEYG44U8mXTKF2t66y4oqcHBNV2oqZwEbvGQizq5ZbGkwQER2AwYI6C9+cfqdM3/0ztI4eA0v1UzIGnc6RIhG5fgZla8A70ywiukmjt/mUGwOdaCIGhcJsZ/SIc/UbN/CDH45ur7F165IDLh2XSk4NP4vShzahkK1JpWSubP3tpb+BLOUHFFUUztG2PkIeD3osU36X9/te1Hqce1ktrXxyIL4jtQqsEtZ+weCB35PVrCwk9Y362bIpx8CFm8/4IuQFbabRzB2ZGCgvDS3LGXXmNL/bYnCKNReW6htW67eXTY5HDrevnFr28wpzgucE+PveGPq1o2jx583F3L62D231jMC+aXvEve0eSWXGyBRW/NWbQPw3Boce0decEYXt0iU1doz6HCB2lzd070f7xyeXJMCBg/C5tUpXU7r3KnWLPAlq7/bvQhnYjATXIw5UIR60FQIs6mVl+fS8+kdmHdNuzFeV9aiEcU7byhvex0h5PJaNjjiG6AgX7/uFAcQVG4zJiXWLJNTvbPcUCfnyVP+XbbJOHFeXbvp9FxTXqst6p0dx/kr/7uTRuGK1W06cCHhqhqjNQcWhYy6t3l4i7ot4s995T1uTD5MJsQrrRf57n/x7BMpZjjxB4/z/MrKYO2KbeZR39972MTcELO3cIaWR4e7zPidKgkuIypfCwow2WWQhTVcVd0/ndwD8hvvOHtvrq51FFAD/l5oYRGJ/CKR9BXU/EBq7A2QJCh1HCeyjAToRKtWTAbZPIuda1pGI50LnqJTBbbAeQ7MDkMSXBS//LYQIY0T/nxi+TNmAoy9mwez4iFLume9d0A+JzLIU4EeQ49fRliEKAsPROD2zlFvHC3AFPlcjVQpGTs1xealM9vL8w1+9Wyfrj2XSR8lLIYtswqog319aHq2hRouYv+frnTvK82rMAQ9JMHG6yax4xAfOiaOIQo/7mLMbQnENCeqTJXsuA
 t4UrcCKC
 XPqqIEpdmOAOGqNBxfACnfD0jGRPxex/oiqgauWnUXOH9ZwL/dNU731sIFrVRL0zlq+CCrBpgwP9N0vkKTNa7Hhx1zduqPnhp5EX0uDRfIVyDdgOYw6dRkY2Vk/qwAwEMtB5HJHHhPKmeOq32sa6Z/c3y4ayE7B7+AhbGGlPsYACvYlu+Yi7H9K8kFgvc8SbwFlRAsywSQttGzVaFIAUS4DO8hbhTBSvRBtGtbjELxDujDKMCNz8mCr8oYoh4Ardxvv9slSVndEQ2eKl0ALC6TC8ratzeD7W2jIP0tVORonZZT+t6F3fMMI+p6JDhHLD1Ixko9MPBxyppyGh503pINNKG4uWDbTJu/XIrSrMp4jxPWutJAwFh2euwu/vde/rK9tZeFsqlu74Edc81UqN5nOnmkccymEA1lGwbZxxhkuGD6EPqy1eGPcy6oDBU98rqvDSqhb4CjEzo18+GSDjSa93+373M/UibmfoxPNzHk0VxaGBpY/NaZR4v5Sga2H709cdGIvHgAT2izOM9sQXR/DnkKXvkhVlQ6NzBQD9s9T3kGk25tUFxSUIawkuwWaY5leKSPpHUhqEegkUCRdfasrfxk5fTTh1RaC2osNDRVcP77eO/p/A3oiOw0A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 4, 2026 at 10:13=E2=80=AFPM Andreas Hindborg <a.hindborg@kernel=
.org> wrote:
>
>       rust: page: update formatting of `use` statements
>       rust: aref: update formatting of use statements

Applied these to `rust-next` to get them out of the way already since
I have another similar one for `str` I am applying too -- thanks!

    [ Picked from larger series and reworded. - Miguel ]

Cheers,
Miguel

