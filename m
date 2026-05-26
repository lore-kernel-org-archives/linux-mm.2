Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C09BFCD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 13:40:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EACE06B00CF; Tue, 26 May 2026 09:40:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E84D96B00D1; Tue, 26 May 2026 09:40:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D73496B00D3; Tue, 26 May 2026 09:40:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C63496B00CF
	for <linux-mm@kvack.org>; Tue, 26 May 2026 09:40:34 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 668441403DB
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:40:34 +0000 (UTC)
X-FDA: 84809680788.02.466A082
Received: from mail-dy1-f178.google.com (mail-dy1-f178.google.com [74.125.82.178])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4FA0F14000E
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:40:32 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=C2fS2a8w;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf09.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.178 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779802832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WKrFN0bQRu9gfOMs5pJYKzklMZbwjQgz6+P0DJa82gQ=;
	b=qN3Rds73iPuHqMKFwGIVAgOZqh0xZ/te0LvrOHSYMFvvaForZ8gC7R7ckE004sRZTU6pvF
	gLw/W+ncG0Nlq5/m6yhJszrIBVwhqimxVHWEPgouJe2tLf8lTCEQk+M3aooj1HxLgeLbi+
	V3j/rn69VhJ3If3izXIrxxtycFk01n8=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=C2fS2a8w;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf09.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.178 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779802832; a=rsa-sha256;
	cv=pass;
	b=ficIhuQfGbXLpD+gRma9pdNxM3TrDtOhj1yx/RV99RHGq9aJ3ckRIPhiXAWm6fEYp+HHC1
	uDv0OOZ+0wNmh6UY3Yl8Sj0v3WPkATpj79dmq09YIcuOofTLjm8F3qCIh3mKpMwo2NJjsT
	xkCb+bSIT1MI08JXE5OCS5Wiz4eQUm0=
Received: by mail-dy1-f178.google.com with SMTP id 5a478bee46e88-2f6e6a0a215so900113eec.2
        for <linux-mm@kvack.org>; Tue, 26 May 2026 06:40:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779802831; cv=none;
        d=google.com; s=arc-20240605;
        b=EA/kl8bkWjjcLL2RVhBPvlS4kzftGftW3xFQwyc85BMItng6/kpOq7Nvgx7ENjJLiV
         SBoe2YeYDmoOYPHTUxoGNkv4isdhGogYI0GqFaPfPMlfq1yXzW2GFoCYNGyqs4w7juW2
         Odj400dE2sB9i5oPn7+h6LbxhnKlTsvnfNrZKiF85OXchSsHOcX+k5lZMlysUJgty9c9
         Im+B01siVWoY3MrnwW0eYvCQHhmS240tilTh17ZBEMSvYy0iM7y8/vJFsE3V/4MGlUw1
         uA48vMIT07DowGmyZ885rILPuzyud8B90vaFEAfrSu+K2PGlw09/EE2/rPBSkHFWjoGG
         bBSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WKrFN0bQRu9gfOMs5pJYKzklMZbwjQgz6+P0DJa82gQ=;
        fh=+JvXonEDaMDQDfbOHoiwKuUkQVpPjaPJwc3lShDs/Vs=;
        b=WPCoYF/fjlg1y2dwNIBRUHP6pW4HHJZSjn86H3DROjpqhXNYJOZ1JiPjoS/oCVYkF7
         BJ2T+6FfPhHkcfQgLyWP7teq1qUfDVCSrSOXG1quORfIo//9oufduaHN9GulB70KFvUV
         LUy0wi82IvY2SS3qQI5udoxS1v9KNOUeAAWg2FG5VZIgVrPu9psK08qGXHo1JxAtaNxo
         d2kmdh254JWuNp+AuDSx8OOlr04BQUy3OyoJbxanSmfMkf9zIzrngCvVkGRYbaCL/vQY
         VyEiAsUYkQwjAjKe1c9u5OJgwWmT0Wb+SQZPmBIMW+ZCMu3wrqjkO4VkdBhPbW00+BEH
         lcHg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779802831; x=1780407631; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WKrFN0bQRu9gfOMs5pJYKzklMZbwjQgz6+P0DJa82gQ=;
        b=C2fS2a8wD64TxPWFHHfHBJAHM39B5Vhn4kRfeHtaBF7ATIxG70u6pFn/LkWSmsaGAD
         Au+vsnnz/WKpRsppc8f7sTW2bQTMWEJgVsCKm9TzPviCl+4MWXMpyGWUiRq3F4uzIMC4
         xwxJfI1Dw1773trEgFA15BWXFSkN8BPorsEAoaYZB/bTVbMD5QCIUHi0G/0Tw7NB5xFp
         BeEPgkDejw2Ej5H1tJz1vX1sTTHY84vqNik5l/A8MXEEMb3TZn3ihOmnN0f9Oiuw7MfZ
         tlgCcbT1dxS4PKfSwyz8zS3UaFeaAy0PkBo0LQ4kRHIrHYOI3KJ1S56Dr+8uTjIXO2Cf
         /cZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779802831; x=1780407631;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WKrFN0bQRu9gfOMs5pJYKzklMZbwjQgz6+P0DJa82gQ=;
        b=LfgFR4pps9t/o1cAbW3K7STQWdPaNwaNXHzBF43MskHTlaOFkbgdmxCVpIkDI+GTZD
         BLhVGSAcpLlp+5XyMy0V574AodOv3Ad9YQHvCk/7bGjB3X1EPhikhVtdRp9GkVwXKXGQ
         5gGxMpWedOd5SjPXp+F06Qj0e3SO2ScgnlT5GZufHJa63sXOC0dUECmUGot2wyflJOiv
         9OlujqeU4/Ai0InU4CsHB5SxrgypI617Vabrdgqvek1bbn/9RWuwDYVW6nGA269PbZ/h
         pKna4ksL0hW/Y2E3duKl6IA5G07gc27cvckr3nAxYTtdH/BYbqPbmy+iVUd4FW0qOn+4
         A/xg==
X-Forwarded-Encrypted: i=1; AFNElJ+kSQ0MrnSMFwb8Ul1fORx3/Qhpwvhn2zPH/f0NRTiBq6//ke1iv3AyhrrIfqH3AqnwJgWdI7T48w==@kvack.org
X-Gm-Message-State: AOJu0YzSEhdPxk8bFuqaCsiu/6rqfV/9XraBxMq+aOsCi4StK0Z3YoFq
	uGd8o5J+C7Axv4uj0+pWXDE5ytM4bnX3lRkhZetzYgr4skaS5V3LrndfIwICKRYEEeY9/72VgPv
	SFIpBHL1MUEcK49CbUwf6lQHzZaN/zJY=
X-Gm-Gg: Acq92OFMi+r26atkOaxo2ByqOoswk7nSSim11UjwpZvWOpU5hG1qtSRtiJ4l9awwqVa
	N6AP061GkM1Nap3vy7qoJgu+jYBzBut/ONmSlplWmPYDqArsTewMb3NV8iR102aKRcX7krwFEj5
	de/qrkWxs8iIoEWf6o4N6T1c6iDb+8a1td5eDsw13K7FOMHu08+B0FdcUD30K0MkuYNb5zwGsCz
	H84r12rotw4V0DbhMIHTfrS/9Pzh/dfxVLjYSxX8pra4eiSwPh5cWkfK6RGklBmBB/5cEdYffbm
	12mHcYpAEqv6zQs85aXQDRdl6yM3kp9WP/vqPI4XztIT0/9THCwyoYThFiSfWsJBji9wUW7nERD
	V+kgM3MMUsLt3wL6l+gldXAM2/4uzJaOEtA==
X-Received: by 2002:a05:7300:3255:b0:2e6:b55a:76ca with SMTP id
 5a478bee46e88-30448d4e2fbmr3950265eec.0.1779802830932; Tue, 26 May 2026
 06:40:30 -0700 (PDT)
MIME-Version: 1.0
References: <20260523-is-vmalloc-addr-build-fix-v1-1-73c919440c41@zohomail.in>
In-Reply-To: <20260523-is-vmalloc-addr-build-fix-v1-1-73c919440c41@zohomail.in>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 26 May 2026 15:40:17 +0200
X-Gm-Features: AVHnY4JY3BERx0GWS8ietVYuqgpvN7Ck7UFpC3ku9nW4ZHWYohQhxxbwfYTlApo
Message-ID: <CANiq72kJL9gqQS1Kcv5gVY_95WA61cC0xqx1JU8vsHYUsi3RAg@mail.gmail.com>
Subject: Re: [PATCH] rust: helpers: add is_vmalloc_addr wrapper for NOMMU builds
To: shivamkalra98@zohomail.in, Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kernel test robot <lkp@intel.com>, Linux-MM <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 11i5xgqn43dsqgr8q7b1sdgamqzf68zy
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4FA0F14000E
X-HE-Tag: 1779802832-174837
X-HE-Meta: U2FsdGVkX19gP/m42JjtgmARhwKUpkzuYsdsf13u0+LdNP/YmQau3clZeV02v1oNyUaUW7sf/d19W1fzoAvp2JhVvwrqtzC4g8+5ASl52UInEp93dXSB1l5yjQYxzO9ObYEzDwKITRML4nzL5XQ+3oUXAoqTNcuiPO+xpuH8TVCVmG2QPuQZTSekHBVrjVzTmxdlaWQESUjgYz3antgTCWL3NVZOmymD5WPo93Q2QDxoDG2Yv0u7Qsq4AGKPVgSxk3CsPP4E7mc2o0kpL26SgMFr9xpW60YIqNWPTkBTHI7TTfrfqgebViuARNZ8+YvQNX+BdR2yaeYwrnblOs7sT9Hr830hvUlUV9tTUZFhicjX92fhxR5k8J1BzQLARK7HY8VSIOcys0K68790p+2kwDNM2ZPcOHBovbPnXuvR88cn1IUyygGX8yY59nyXj1nHgZJzxJmnDO5r9rcumt8i0Hay+9ZrtvarQzAbKxwsvF81dyPeYorZNA2Nqp4GHCs08cBykNmuR1m7UbPohOXldy6TkuflYLc8b5B7+4QKFx3RNRkwFGZYftTLFtmbeLNjX6IRYVNnJE20lLEr+AGvm2EpXfbWcaUyWYEjO+Jcgruu0AAx0aYSHT6mD5oTtv6pPVwoGkkcU8RJOsFZl9Lt0kMlbPXQBDgnQVHypfZg5XaRajIXWxV3UUu6wD2+LeXdIFDN6/A2ugRdOuJGB3QCX5fsZGhGOTdrYmM1J7v2srgcA7IIsBc63gLxCLjyXHNoNkaMhY3Mo3dSoNqQR0JcVFyFw0F1DhGT665YaKY4mHd9s0hky9hXDK/+gx7bPWtACvfmGieivAAsM2xP2P0LsBc1BE0HdRecMI6cllaR0f/vd02tsRnjHfv9yz9d30uJZxLxbPAdGRyvdXreLTnL027rDrHmm83u4A94/CHyIlxFKZo5lbVcsA/IzSNtyIcTEydePX4iPhEFRZYGUjl
 KADEiRr6
 1Gipf9bmbeRptgMrPMG/uicPN6pZ+LGae1DKkZjDItcVHA98waLiS02xK4/NQhIHphWMZz+MM6MZ07RqDTY3//e7EsZyEkfIBC2FsKR07XLooYXhP8Ed+X0iUB6T29bWbTWL1RWL6D3Xc32pfhM0RRgpDCzkOH7KxAs3zZZUy4j9bFXJtczkTD9sb4Z2Dn+1nsIgHm1ZYqrz4Yb710AFo+HuI4ByWlOufXbbJnZ7FAyRIlQoNZ8dJOrE69YCXYs5yovO1VB/94C0Jh655S8raCi/FQCGdbCjvQrQMOoU2RQN0EfVwtAAMtYlccMM8IHLcTdQlb8ty1EK9lLRNaZ1PgOgJry3FU75VreAgjexJ1XL3CGZgly1ErzCyP2I78nsTAHAkva/lKnb34PohGHkkcHriliBhK5C752CaawIy9kKVoUMM7s5PTTou031oslQsZZbpYIRWs3qyJg36pZfsEnTIgs9uW21EU0OUE7s9eQp5xyRuA9tH71Tb5V+Wihfb0VRklQayr6baETswl1+Wx0WW7+1Xe1Ay8CC9PXZDqTPrxvajls9cICBll8gxkqQHRjjshZ8JYZQyBbswWH2QdESl24XTMn7UHE1DligEpgEP9NM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026 at 8:54=E2=80=AFPM Shivam Kalra via B4 Relay
<devnull+shivamkalra98.zohomail.in@kernel.org> wrote:
>
> From: Shivam Kalra <shivamkalra98@zohomail.in>
>
> Commit 47ac2a4b5cd8 ("rust: kvec: implement shrink_to for KVVec")
> introduced a call to bindings::is_vmalloc_addr(). However, this
> fails to compile on architectures where CONFIG_MMU is disabled,
> resulting in the following build error:
>
>     error[E0425]: cannot find function is_vmalloc_addr in crate bindings
>
> When CONFIG_MMU is not set, is_vmalloc_addr() is defined as a
> static inline function in <linux/mm.h> that unconditionally
> returns false. Because bindgen skips static inline functions
> when generating bindings, the symbol is completely missing from
> the Rust bindings crate.
>
> Fix this by providing a C helper wrapper, rust_helper_is_vmalloc_addr(),
> in rust/helpers/vmalloc.c. This ensures the function is reliably
> exposed to Rust regardless of the MMU configuration. On NOMMU builds,
> this allows KVVec::shrink_to() to successfully compile and correctly
> route all allocations through the kmalloc realloc path.
>
> Fixes: 47ac2a4b5cd8 ("rust: kvec: implement shrink_to for KVVec")
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202605220811.LRplxeBR-lkp@i=
ntel.com/
> Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>

I can take this in my `rust-fixes` PR unless mm/akpm plans to do so.

Cc'ing akpm, Lorenzo, Liam and linux-mm, by the way.

Thanks!

Cheers,
Miguel

