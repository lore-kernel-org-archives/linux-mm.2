Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61DB8CD5BD1
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 07:22:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97C396B0005; Thu, 28 May 2026 03:22:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 905B66B0088; Thu, 28 May 2026 03:22:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CD9C6B008A; Thu, 28 May 2026 03:22:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 68AA36B0005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 03:22:47 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 08BA41A0759
	for <linux-mm@kvack.org>; Thu, 28 May 2026 07:22:47 +0000 (UTC)
X-FDA: 84815986374.20.145CC27
Received: from mail-dy1-f181.google.com (mail-dy1-f181.google.com [74.125.82.181])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1046EC0002
	for <linux-mm@kvack.org>; Thu, 28 May 2026 07:22:44 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TlT2qqKy;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf28.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.181 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779952965; a=rsa-sha256;
	cv=pass;
	b=pWQTwWOkEy6bZ5+J3hzG0ycLHQvUn4+vKGYxnBcJ3iO6x888N1mSaSxiNGtV9xjtncSHak
	TAqM7/dy44M5C5eJwIw+BPzx/8YpBGuwMFeaOa8A46ZXV8lBk/AdsJ3tBDY+qEJqxpkE/o
	kskUCgW60G4LSY4Y6iun6OTaZlFpDck=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TlT2qqKy;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf28.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.181 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779952965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NMnKlWxCY/+1GhRWPt544lPDFtnUff7dJFrRIxp1dWs=;
	b=j/Dt5bMuO+Hb+sqTJ7fQxyOeT2aw6Z0901fLpsJe4Ib/AyDi7//OUW9+wOvTs5oj1KIsKT
	4Fw30twX9S5QhZvp3LOqI/ePJ14mjjbkuKVXVhSTZEj0XOoITQWkJElGpnwvrKfiqzW2Nl
	jdvr44XO6z7tVn3h6jNALAptlvW6U7c=
Received: by mail-dy1-f181.google.com with SMTP id 5a478bee46e88-304d4e57d33so32564eec.3
        for <linux-mm@kvack.org>; Thu, 28 May 2026 00:22:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779952964; cv=none;
        d=google.com; s=arc-20240605;
        b=a6IeiixBu6zOHOtG2Y2s6F1m/NoZ8dPo6TCv8yBNbbjW2Yj13klscPiYWMQ1/ebQkT
         F/mZTyDSfcxQ5zCpnH5RRx7hfD2RT//oedlfDK0pbisIjGHxXKV4wLEvvMuenvMwCM5f
         ZfB8D+v42rLTpC71zCYrXHhv67/lHkwXQeyfrIzcOS7+2JMzgR903VES092VwwvdyofL
         kagBTAvoc1Mtz+j6BF9Yolh3EHdx7kk5kKYwG38ppVNAvpm3pktLn6Z4RmsvACi7u6iM
         0+pXGITnGg2T0y+4kAnHM59gTM5F+ZKL/lA2s/IPnPlx+96nwCmolaGqUS2Ff8rWdTlD
         tm6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=NMnKlWxCY/+1GhRWPt544lPDFtnUff7dJFrRIxp1dWs=;
        fh=djjaeGg6I2hqJYHnKaGaAoCb03662c7ogeZXOhz3pbM=;
        b=ACKa/5JW1JZGipSv5h24XXcUb8v11aGVRodEPNmf4AqVUEXr+DxYABM1DuCtl50PPt
         /75eNqwquAwsGoZR4oNwUN2KCC/p3G4ly5WH7smPhsBKMZr4s+N1V3fnY2s6Yi9HSi2G
         /YQJCAAxtptW9uUwMUefMlwVlRT1AhOwdo1tykk0r3K7o2K7JRL3tC5JnmpP4gN9NiDP
         1ZCRJaOoiAOrkhe6pstLs1i4AR0evpyC+q9VMQv8McsCOMfE7QA0Ev1FT8PsDuMwJtrw
         UMb50fRZTTvIW+qWEcW95n28aIbdxwn5Fwr9OG0dCbmGcrqkDbfrFNcHSun9+yKTleNe
         JQNg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779952964; x=1780557764; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NMnKlWxCY/+1GhRWPt544lPDFtnUff7dJFrRIxp1dWs=;
        b=TlT2qqKyuWYVSA2pqKuKx/6tfkn+mvO6skszthBafY2Jh18eXUVHK2lhbGSo4fjJqq
         StZaJKlTKQnil+gh0fOW7KEddVH/+zGFxKfmniOo0+fJ9VAFXiZWxxqiJzetqy58PKBj
         60OeDo0BfUnrvrXhkGNHPAtHHId/pUvUNrOthSS5iX0vNNuHrL95cRN7vjqq7+wdGAfX
         AUOItKC/RyTtamZ/ubmdQWSZS5HNEgv4TJJL8lIkhDr0b/xf9OUO7KeQumKaSvRDiNOC
         +FWHL+vVBvC8zHQ5k0OAHLFCjtPFpZKTXlWEfcO/XKq1m9GWOx9k0YWlxrhRq0JxrVnn
         7WTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779952964; x=1780557764;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NMnKlWxCY/+1GhRWPt544lPDFtnUff7dJFrRIxp1dWs=;
        b=SQvvwcAZLbntNuUDrr/eaoMz4PI1ijoi3uyR6ERLzaAq+35bPD4ApgUoFjIWCIQPCJ
         sZ+ImwVS9qBcOKYp6ZtkDeF2Oemv0iqv6KrejFeCHajKhuNXixmDNCrBNhsBC3We6WFb
         K1AgJF1ZQMCkO4WW52NkCPCAXSb221atjyZKGDvXprBs5GUYiB+G5HnD9Jms3+F8GahE
         9w5wOLlab/87nDSjcWKMHNviOBdqLVs+sjSDdmAv/iU9Ymbq+DmgieIBazlzTUS8U2PQ
         SPoAk3ltnn04mJ72N8cNLAKxeFT16zeVeVM82t3XlqPSTcugUS2/kjEcWbqpwxX1GkA7
         FQag==
X-Forwarded-Encrypted: i=1; AFNElJ/AHZMPQPkhXyg2+fE/tAs6MAwJunW2M7nGFZOKecBkk0tg/cGOjpmN/w/yBVXuDLJ6jr/YP8Q/uQ==@kvack.org
X-Gm-Message-State: AOJu0Yw0YRzb1BhtbUxL4Arse5oFpcAlUJ+d1srx/IZzZZu9jsnbByuC
	EFrk3gkoadfOdNDfXz3VeR/w2f5xAQ0o3hpSbnzue0GR1yjXkOcqpBHC8+prHuziv1JFmRHLrAH
	THt7xJ6pzFGWqobCCmzwTsE9nB8aTQwk=
X-Gm-Gg: Acq92OH6QHsn6jyZk1PemWDAzqBOXXb4ixWVQstlpzRMFZQUth6SQ9A6OXAafmSRv1j
	i7BrzjXm8mnMLCwL2TxnwZrfewspcxmmgWs+0ElzLvHqKlvYVVMKtEgYBZo54/PpLmqmtMi5iml
	LgLjf7pVnmo8Y+eW08naBXWQ4uWwA5Rsav22oe5qigcBwdBQB90B8rf2Km+2lQpJVUnxCgmW1Lk
	e3YxO6Z3Ah5uliG0ektPzHLJ8L86Alq4LFHc1VM3zdECyOduDcHGWpMLRfZ+YpC6sJo04dfITGI
	sOxeDdhUsqyz3cuVQkEjfeMSl5PlzZYxmMQ3lEBHMrpzbRhROC6ngtoetn1Gar4vetOWb37mFBo
	drnfRXQjT3a/Yadj/wMFlpPpombnnx5oODvEipvj0Kf4b
X-Received: by 2002:a05:7300:1496:b0:304:8361:a8a7 with SMTP id
 5a478bee46e88-3048361af34mr3809620eec.4.1779952963671; Thu, 28 May 2026
 00:22:43 -0700 (PDT)
MIME-Version: 1.0
References: <20260523-is-vmalloc-addr-build-fix-v1-1-73c919440c41@zohomail.in>
In-Reply-To: <20260523-is-vmalloc-addr-build-fix-v1-1-73c919440c41@zohomail.in>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 28 May 2026 09:22:31 +0200
X-Gm-Features: AVHnY4I6oIW3zBw9jPnRTR4wEl8EOAz2Ezw6z0v81WcoSkqQ_LyCTT5fYHJi5Ik
Message-ID: <CANiq72=pTmG8qkdqXj7vw7e4QTzccjaz8ny38iL_9V_ramLHAw@mail.gmail.com>
Subject: Re: [PATCH] rust: helpers: add is_vmalloc_addr wrapper for NOMMU builds
To: shivamkalra98@zohomail.in, Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Linux-MM <linux-mm@kvack.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1046EC0002
X-Stat-Signature: zehmcycxx4dr8thowu5arpasmmeghypq
X-HE-Tag: 1779952964-140483
X-HE-Meta: U2FsdGVkX18h4dPB6J0i4MHrHcniEOmLyuLCnFRUieYfLtz2M0vr+P/7E/r+stCkwpvnsxwYmUJsM5TmGD+0BbHe7VMB5IC4eVcT5BjwBfxESwveeXQIEvMN8+aQhVO5MdZSFqKktUV83HwPS+1kESz4OvoP6OZB9pSLktSB4eiT6OwG73o6f+ZcalmYkMAAPOYUDhi49kBtqXMBgAn7vf8eyPJ9eKaMXOg3bgBa1G8JSwBo9mCdK1Uru21JdiAa5kG96gcFACv5A1no7LuEfkzdCmTczrtL79+FLrOQHbkQIqILOfqfJbUdkMw8NZFpmeMl3Mztg9SyQaqjWrxX5cYRbQy0zKW20XtzSGQZCyOopkAiRzz9Lz0g747nrvVxy/+CbdNb782q2KCfCWwe+cjBxLyS8/FosaAOuzbqaUvuqm2q3DOVkr1f7Yg+pmYSwgqQ5C/hntFP4cqBsjHN+skCcMTn26ddZGXnNjQW5DHd2e+NbA52JVoADHgEWFEZoyPTvaEtiU9aAXeSQugjA3B1FXXw892LDb3mQT4SRmb98a28Uxwtiecunn34NFcaTS3HpGc6WHIyXELsj1hGsxVSEmtiXUSgY7HD3uPgt1dqm5Ffcm5gPcrfuGtpX0Uuc2/tIJjjl8xACiZ2BqE/Bp1ffwrlKj00BTEJVHWUTrSB8MFt1gJsQK9AUVvG/c3KDY7BzsRaeyoOIsA+hmaVQKbkPjfqtyZbjUAa97aYE+AIcWcQH0wfF57frHRImcVOYn27ME1bn+1OqpBpYS4Zx1IQ7L8Gus3FQBtVPaHf1eAQXoULAjmg4RVO/5Dc2e603OzkrnzN+W0idHVx9AXLaKeJd0QcfpfnIlRQ8p3ct2rCFn+opniTpvNMDzYggUVCkDFsN+THKqG8ppyS/nu7Zx0g4e0Pds8koBp2jPev7Rt8RfoC/6KjALh5Pg6Af2TlyGHWSUC079goaAU4LxG
 CWwX0Sqd
 Tg5FpHAlU41LsMvqvu3XzSm1ELa2OFfGFGYoPoxbX56Rax093Dd4KFreLXqezFfdydsr3jJanD2zNh/YRJYb4j5xILb1RL/anWIpk9ko0KTPhptxcGdg2E5isqjCqu6RFt2Jx5PKrKwgKr+ceEwwVqMRG+HaG7jO2Pv/0bTCIUfzw+3u6f8rHEZxi0GAIgzMWfbtV6FHr05QwQB9o3qfY6P4fDFkeCudLQ5v6jgkv/9dkjOqNaK7CQZGECQGRiVFOGa1L9hc6OsEwg8V/u6gCiS7xppqUTYuiBeVv0XGDhcZmw2Uu/eTWnhXRvBvw5fuReNu3D3oMvD4t9bTErUIburChfI4XXrmi/IcLl0fpXtLUeknv3IfNJIznN6sqZBBQb1xzFme9G3kE30zqtiX3ijLfxMQKUD50dI3oU7H2QAJQxOaATxR1+dLEVfCDqRnSpShnhQtDuslG0qab8FXKTLjNyJ2VY4YiK/HGrdHkO6KPgBsFXLb37B55ifkobJoKCTIWB4ZrAf1fTxqE9Jk1HX1kMDlAmYlywRsl5R9lAKwtiCq8ixFj6mkLZ/NLRmyd3ZpfHzdbpymnTmim+QNxkVU95gT09g3oqSwXLEqpgbHSGII=
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

Applied to `rust-fixes` -- thanks everyone!

    [ Pasted exact compiler output and expanded it. - Miguel ]

The compiler output did not seem to be an exact copy paste for some
reason (at least from my testing when reproducing the issue), so I
updated the compiler output.

Cheers,
Miguel

