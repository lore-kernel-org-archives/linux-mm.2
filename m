Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF931C53219
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 03:46:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A546E6B009D; Tue, 28 Jul 2026 23:46:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2F626B00AA; Tue, 28 Jul 2026 23:46:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96BC56B00AB; Tue, 28 Jul 2026 23:46:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 72A616B009D
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 23:46:14 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DFA49C0560
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 03:46:13 +0000 (UTC)
X-FDA: 85040426226.25.A400CA3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1D7391A0006
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 03:46:11 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dMRmYAe9;
	spf=pass (imf19.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785296772;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9hCeIFdpiZGdMUyND76+nFTdqMQ1AhaFCYWKinOxaws=;
	b=gxxlo4LgdRfsosmR8KT8w/h/RD5CPZE9KCNL4yIu1o6g1wlEPZ7S/cFFWfGLKCIwRFsatZ
	VwV9wP6+O3X+aNnI07UoBCp5JWIOtMTULLMll1uQjbrOLEQjV0XASINjVmzMOkpt+RAsxF
	6x81E/i0/tgB09FsX40QDnRnNA2QlDE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dMRmYAe9;
	spf=pass (imf19.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785296772;
	b=bhbnlxzsI4/gq4T763INzA5qn87tqRc9CxTzNdanSF0TwT/unKwinqc9s7xcgRe6iVYGID
	xnKmOuLbpH68NHp7Se/fD8tWwljmNexmN1PcQXIR71iFkj104I51VqLLXRMBQKkImG3Lob
	cHUMnWJ27876WOqIoIYFR1VnrI7Yx68=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9148060A5E
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 03:46:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 488571F000E9
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 03:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785296771;
	bh=9hCeIFdpiZGdMUyND76+nFTdqMQ1AhaFCYWKinOxaws=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=dMRmYAe9PSokY48x6I7M3dDK7nXQfEJnBksN/UzmcwZWenaaIMXt6FKt1fjQEDMhC
	 hGvtY3teJTuNZ5/6ZMHptKw0VNgTtDyMlDPzUpx61rlKxRLwdwQsqwmyJLqF9vQEBN
	 MR1jrpdP2oYbcY1SpNCQnzHC9Qtyy+q0aeRb0a/ip2GN9EHMWW91C38xv2FpEVXLtC
	 niJ5gRr+fPJc/MM5a1DVscvZ1req/o7hpaK+4lMClIXt/FgGpvO6EhqlSxQlVkLU8b
	 d/9wrCXkYpchrXqcyIeqMHTSENMgQ5dl03ddVBUzHcfxUfigxDcS5ujmVhIYaCpVvh
	 SJYhY/gKChB5A==
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-930f72317a6so33680885a.3
        for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:46:11 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpKXysCXE7QsRX9OQAbATQKgTq99SXmF4le0iI4MHXlId3dxhFdO+yPf4swwv7X7fPpmd5tCxdWHg==@kvack.org
X-Gm-Message-State: AOJu0YxRjLK7++xjnvvdIF5orbXGXNW8Xe13VBnNM8lDSRVlT54E+SiB
	bQcgYbBpAaXTx/GQxo1MNuKdoSuEnKLKGdyYRmdtOfnCdd+a8yMlJdBgwWw59iHR8S2V2MshwWU
	UI6mRPejYZNZTV7MQ25qVwBTRTuIogt4=
X-Received: by 2002:a05:620a:258d:b0:92e:4867:95af with SMTP id
 af79cd13be357-9330264e639mr479318185a.73.1785296770680; Tue, 28 Jul 2026
 20:46:10 -0700 (PDT)
MIME-Version: 1.0
References: <20260715120813.3609949-3-jiangwen6@xiaomi.com> <20260721181729.305137-1-devnexen@gmail.com>
In-Reply-To: <20260721181729.305137-1-devnexen@gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Wed, 29 Jul 2026 11:45:59 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wWhvKA=BmPwCrGv06kq07QMP6CKES1mGUnx=HmiDPGLw@mail.gmail.com>
X-Gm-Features: AUfX_mxEu5tKUyNHmfuUECxYL_B8CLwg9_b_6o8Uh7pr6aO8ZRt_yR9G9xuE8h8
Message-ID: <CAGsJ_4wWhvKA=BmPwCrGv06kq07QMP6CKES1mGUnx=HmiDPGLw@mail.gmail.com>
Subject: Re: [PATCH v7 2/7] arm64/vmalloc: Allow arch_vmap_pte_range_map_size
 to batch multiple CONT_PTE
To: David Carlier <devnexen@gmail.com>
Cc: jiangwenxiaomi@gmail.com, dev.jain@arm.com, david@kernel.org, 
	urezki@gmail.com, linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1D7391A0006
X-Stat-Signature: mx48cmzzznpz3maquqi1xtiwaozu3qte
X-HE-Tag: 1785296771-946401
X-HE-Meta: U2FsdGVkX1+dfaKJp6SJH2pUWOWsudkiP1sTC0mbWWmluFmeNC5Cu0c5RPGFa0+raTXyiZW9Tde1DA5TvjbOQVRkD2rcShAEXmCo6Htk+1DMUMQPh0nilm+ZOYQH8DKaLN4sc2kb/d43vvMf65Cz/eOUCz0ugYQcPcZ2kvQaNEY4qTe242FksAoWQa30P2L+3/0DOm9IoZvYZkLMIQwok5RAx77TRYevo6blRjgWGuN3Id5pPSEfyzHkUgJNDZdS2u3kfxL2Y2cQCyKhjKdHGBx0k1JOGtCDQSKMm79W91NeE4GQxw/URzguwaMDTiJatEdmLxyTb6bO5UEesoq2ID/OiAqDRboQN/hOrqPLTUmJpfhnNlogic+5V8NQQqjHaOg9S/8xGX+WVkGNKU9ersa53HceIVoJmz/Zu28UXFYuh0mLkn/WM8/lcGFS+BEmXzfSmPh18ch9hmOGf6IH4UkeK1UhGcFkERjizjC9emDftcxw7LgEReQiROeQ51CPyYK+U1tkL2tiiaz4UNX5jrIVSaXATIX7wRDvUHK+kSTIGCdsa/0wNmH7pprduWrXUWLhYe6gE7Nll8wpgVcg3YIB4WlDUdh7F+2mwsT04Ji7ixhdt8r7lYwGt02LH4DAdgLb/PSmtuNA74qVvnhEHe/QJqGr/GCjZLfkrlDH/0uJgXXsrd2GaRmkpzKwge8CUkvGKY/EDPHOzFhKCcvWM5PSc0H31IMtX7EyWF6jdZBwBvOSDJyQAGtpQOQmQTr/mPpaYnD6sWb3zCoGz77w8gN5RAacgCOa035FLC+7vERr4s5ESfyfQlQPx7SOyv7nItGJvC29TC4A3WrN3xDxivMgD39lR3KO4kWWhlFEUGsq4ysBMmt/jO5lakZz5vzgNMUX/7q5U1ec4vQClDxt5bv1/zB72VP+RZRHl88DgmCVNtfxPE1OGZovrTGTOKVxu6UAfgnx2I8tkLNl89Z
 5F+AWSlI
 xwGvdargy64En5DHQbvQLt8zf03m0vOYEPxashG/7DpzfxkwoFwg22CoyxA1FcCy9jvI/KkEbmL3pTW/gPSuahhCBpkMq6XSo2TA/+IrkLMXEe6ldDJ1/Q2ktLS5jmy8AKYectIoM47ozk0IIKroPC+HbynQh+GyTDJ//rGaS63m6OnJiMC+gjLl8MaU0HiuqupN8VU6AzDIwCB1q09WcwruFbdUVcw9NSJLuhatf671YTIK30oYZWvWU1DSgFlNCPJU+MIs59vzJQRu89HXy7EAwGt1ajzpXZZOegBWBak4qrCeTvV8BDzT+qd/9g+INNKVqJ7Cwtf1BJoI72A1b88ldikwQLi9qnS4N
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 22, 2026 at 2:17=E2=80=AFAM David Carlier <devnexen@gmail.com> =
wrote:
>
> Barry, Wen - the returned span is capped at PMD_SIZE >> 1 but only
> checked for CONT_PTE_SIZE alignment. In the batched vmap() path pages
> are only contiguous within a naturally aligned block, so when a PMD
> boundary splits a batch the next region starts mid block and the span
> runs past the contiguous run - set_huge_pte_at() maps the wrong pages,
> tail of the array left unmapped, no warning.
>
> What do you think of clamping the span to the pfn physical alignment,
> like 8xx does:
>
>         while (!IS_ALIGNED(PFN_PHYS(pfn), size))
>                 size >>=3D 1;

Thanks, David.

I noticed that 8xx has simplified this to a simple

    if (!IS_ALIGNED(PFN_PHYS(pfn), size))

Could we do the same here?

diff --git a/arch/arm64/include/asm/vmalloc.h b/arch/arm64/include/asm/vmal=
loc.h
index d665f9d68742..a27101e24f76 100644
--- a/arch/arm64/include/asm/vmalloc.h
+++ b/arch/arm64/include/asm/vmalloc.h
@@ -46,6 +46,8 @@ static inline unsigned long
arch_vmap_pte_range_map_size(unsigned long addr,

        size =3D min3(end - addr, 1UL << max_page_shift, PMD_SIZE >> 1);
        size =3D rounddown_pow_of_two(size);
+       if (!IS_ALIGNED(PFN_PHYS(pfn), size) || size < CONT_PTE_SIZE)
+               return PAGE_SIZE;
        return size;
 }

>
> Cheers.

