Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63A03606B474
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 18:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=sPFc3Tk/
Received: by kanga.kvack.org (Postfix)
	id 2EABC6B05B0; Wed, 28 Oct 2026 14:12:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29A986B05B1; Wed, 28 Oct 2026 14:12:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1646E6B05B2; Wed, 28 Oct 2026 14:12:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BF3196B05B0
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 14:12:27 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2B8E8A01BD
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 18:12:27 +0000 (UTC)
X-FDA: 85372829934.06.02F3DFF
Received: from mail-yx1-f41.google.com (mail-yx1-f41.google.com [74.125.224.41])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2E309180004
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 18:12:25 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="sPFc3Tk/";
	spf=pass (imf24.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 74.125.224.41 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793211145;
	b=wiiyusVWK6hlUaJ9kY3WoMEe6vbQTClU7MBhpAuWXyjeUQM2sI5zCxgU0C4VWgwnUC536S
	ZsSVNYzuanTVVJv9YEIx0vK3uCl6Am/FnZuH2FpKq123zrHVjGPjLNJOnJHJvYB/dsA7k7
	8JFtekczv1YHQF6u7bmamrxdZM9weIo=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="sPFc3Tk/";
	spf=pass (imf24.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 74.125.224.41 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793211145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p/wxxGxoBJyhbGLsecA52KNGsy8WsqvTWX50Wr5bw0M=;
	b=npWiHhtsLBKi3osydixrk7vEyoYElgjU2nCkUELVy6PgZBiAMQdbQigeQjkS04fJQ0teXQ
	FHgO8DYVC8AjWNozRYBDPi4tJr2PFeC5ODcKTpl8OY4BSrPm8RlVvzx13EZNZ0pesOHN0f
	Ji79LJy0Gxmhs75j8CDkrOocR9FPaTo=
Received: by mail-yx1-f41.google.com with SMTP id 956f58d0204a3-67a3f1730ceso240908d50.0
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:12:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793211144; cv=none;
        d=google.com; s=arc-20260327;
        b=il7+lMoygI4iFfFqhRVRpazUXKgs/7nhcALavsrYz0c5dl7mApBK4M+8BZlOdlbxYC
         MFDlyBSJXcXq+zlQBOW0whb2WFqsRv9juFeXqPiYiPCIQVKvJp5sjPxLXaqIVgcYv39Z
         iGaNUizw910phf65xQ/hWiv2S0QzquNt44Num1pcwlou4CBlERjepizRu2qHv11/tPhv
         984B7ewe5VwnXPhbukC3k8MIc9ks0Yl3maHH+qt8SV9m8qd0wXY1WZYz3gCrdrl/6X7w
         HNg9QmOdT3ryG58U9taLa13sMdVj43MNAxqgCoEsqw6H6JuMvT4SWsBXLDKANQf7v3L1
         9h0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=p/wxxGxoBJyhbGLsecA52KNGsy8WsqvTWX50Wr5bw0M=;
        fh=uxC79eBPkB6+XsDgbPIEkfZ3VW70zGJ49ji1BFCaglg=;
        b=nBCE1LqSiV2mCiJV1cA2VZs6WIh7mOD7zxvQOI+J1+HtlmVo4V60NjTf+pw0wRM6Fk
         ySZnyGopt4zYSx9QDGACRswK8AakBgm5hMOnzyXeTflAmemHSyyLrFIqQVe5Sd97j5F8
         oT1+t67LJmzIRVBWwU7/NuGeLCNV3RvCl0BT66wEMQfEmMZXizpr7gA4ZwXldao8y/hV
         HEYjzPYWImgZ25DAvGLf+Kbil+A2UBoYJYknwfclq9x9/yAndp9Fq4hThV065LG6r7SO
         5h9uDVIANjVf2kSjB0fwtZWjYpC2lgvzf1JYsNwcx+WjSqUF/oeMFbO3JdIzNKCHxMsq
         bBZA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793211144; x=1793815944; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=p/wxxGxoBJyhbGLsecA52KNGsy8WsqvTWX50Wr5bw0M=;
        b=sPFc3Tk/lGuZyNL0/7uRDPbSh9423WRdWBbREbE+sDV51/EmK5PfynIBOsj+x0TYt4
         zRHNAqsGkYJgVtpweogv0dZB/3AozPTgby5a+uP6or2tQ7m9dg6Fjp0BevUFKvUeQEiP
         IA3rfkEN7Di++bqRs31+Xw6CZU4yKXFERe09200D/Y2DFN9xp/KtWOVRdNRKCv5QYLZz
         eY+RoKdU99V4dUCTw2tpOrMb8aBx6uYKHZfp/7+ORkdpKpVruAepSF3EVsnlGMuYuLxT
         63DUxR7/E5VTvhtewYm/vs2KRWPzokrViXr8aHVYVSlmB/dlchXk2yHJ0jmqc/uDyB/P
         0xMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793211144; x=1793815944;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=p/wxxGxoBJyhbGLsecA52KNGsy8WsqvTWX50Wr5bw0M=;
        b=nsy7doEDi5UUcBHcqUkg/vlmb5F5CHs35JsRMbXgPAn0/XS2HL+p7WuCggcy4MmDYo
         7vQzVmwkL4v/6pOyYgBxCFWBHt7s3yhBEOroib4Fus6AZ/jhSUZVdWwcz2vI9qT0QN2O
         B9RRigNFKXQHt31mtLhd5ajHSxgcItJ6TVJwj2S9zQso0OjJD+HVuZ942zM20M4Qu2Ge
         vqAG9D4PY2GKm/2O7B+n/FxcEPfn3qKvdygU0d8wgR8AJzIp7tx//ay3rcghJ1Y2ecWI
         INNk9XBHJ8RQw0tsL1NpyRdgcjmXqQXi4Bf19kJ59bYNxg3C82wbfJK0I5nVPTgqchwS
         +Aug==
X-Forwarded-Encrypted: i=1; AKwUvBwbq3do5wmTQfpB3auiBrbU3gQGdmsxGSUHg1BbslID5sFis8rcyUZUtdRiiXHoHS+/ewEio/A77g==@kvack.org
X-Gm-Message-State: AFq9FYJjWiBrWm3igo3MVBPN7J17lQLMB117Lv77CBJDvpKmbm5+6hYP
	a4zTT6eRbGRC1mH+vh2fGFfXcrLVdQwLxbgosZEUkLiaLnBHVYjP4dyNPwfRhHAT4H8+CgUqAOb
	sjT1H+N67HXXY1NQYQg15G56iif/IJck=
X-Gm-Gg: AYBFou30EJnaVrtuhLZTJG9a8VXXpdRkKPJllJdtJl0T7v/mbHHvetrmR4Eg3oprucs
	B4tARGZzZ+NJjOWV5xZkQFTlsNQxBAgyOqdwm1SOQ+d68Vya6IeTWmS3YyZ1bjWz75UfnW5vSzr
	DsNoTX4F5Z/ZpkS5CxtBus5l80NIRwbYrxbiMDvsoL56oVMXFFOcAAg6uBZhotAbbZnEEf49idV
	/SEFDeIW1A9tEH49JgRK7I85Tom7AEr/QlslJCb0O2Zua4C9KUIobW0PHJ171jno+M64FitNnHV
	cGVzlVr7YhdKyNXysz90Xbk0E8pzhwxBY7QpeHq3mbygxd+E24qmiliierpQEZ/T8OcNZrmjVSG
	wdPoQxao3oPOJq/BYtOFlR84X2sAc9SiB+B8=
X-Received: by 2002:a05:690e:a4e:b0:675:6f06:5642 with SMTP id
 956f58d0204a3-67a7b9945d2mr4650525d50.1.1793211144098; Wed, 28 Oct 2026
 11:12:24 -0700 (PDT)
Received: from 95991385052 named unknown by gmailapi.google.com with HTTPREST;
 Wed, 28 Oct 2026 11:12:22 -0700
Received: from 95991385052 named unknown by gmailapi.google.com with HTTPREST;
 Wed, 28 Oct 2026 11:12:22 -0700
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
In-Reply-To: <20261023-bug-word-at-a-time-zeropad-kasan-v2-1-be0ecfbae847@gmail.com>
References: <20261023-bug-word-at-a-time-zeropad-kasan-v2-0-be0ecfbae847@gmail.com>
 <20261023-bug-word-at-a-time-zeropad-kasan-v2-1-be0ecfbae847@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Date: Wed, 28 Oct 2026 11:12:22 -0700
X-Gm-Features: AclHuK-o5YV67AfwlA9WNsjqOxV_ScugEYWYzUg986KltKOOqPQjM_oQFfVaIog
Message-ID: <CAPAsAGyEUL1fj2-1=NGBDDO-z47cOHmcFDFexY9T_1_1LCMQJQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] word-at-a-time: check the first byte in load_unaligned_zeropad()
To: Qiliang Yuan <odys.yuan@gmail.com>, Russell King <linux@armlinux.org.uk>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
	Shrikanth Hegde <sshegde@linux.ibm.com>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>, Marco Elver <elver@google.com>, 
	Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-arm-kernel@lists.infradead.org, Kees Cook <kees@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	Peter Collingbourne <peter@pcc.me.uk>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 2E309180004
X-Stat-Signature: zuuygxkcghdfd5jhpton4gj7hbdmqbjc
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793211145-277137
X-HE-Meta: U2FsdGVkX1/Ngtjn1Eh8GnRGNsmb5W7586s9jz5HS7Gh8m9/7IBRgFJQWhGP9wSYXToTpNtFrXtkPUDWV0jkmkSm6yhTobm/lhjuMAX3w7P7HRfdMz0MJ6o6D4LEoF/YNWfUI1nzch/WG0qeGySd+KHHcOu/1MR1aP+DJMDUZtLMchjYbIq6sJS7/gZALaN/4GHVsTfE++mtDMHjv/ko4uy16zERLOpnGiNby2MxfhjJOfA1qT7XkQwxW+zNWpZXq/8X+qi8EVl4lYX8zGaW4XFhw5z64QjCT+E7tfdSRxrzpUc0RCCxzVoJlC2hgYG1etfHMk4iyWheBQncyFw/Gr7hOWwnj1lj0o8ITKNns1eF3jriSDCHkQ/Jjt4NvwrTwTdIWFao6ewIu2yk/CFISjflV58H+ffOhSdVHL2L2IvAIMlLQkyedf0Wb4jKE/n0j+ZE2L2YZzdQGWHla5VPjBT/Nc/LXdkzWpugiTRaYxpJ2pilMqZJfU3Bc0106V4CCksuGeWC9NovFqZ8aLOdQhZYH3oF+i/yxqsfENkVJ1AV/yLxngH1/A6KXrfoSG9nOtwpCAbLfwiQYkH0EYXRez584cvQ8wAmrkNUzS6f4jm/jsvMJ3ngs7kdQj4pV502VATIqgEEaBPPm372Po3cTGtPs/soExEoYsEMfMALQrFiVk0rjZEHoz+BItPcSwTU8uuUQPND9Cc7j73l62cgQRHwr4N9XoJBObRwQLcomjMy8Ryqp5zoJfMhsJaFwI+pHqVAY22p+TcTABi3urG/IG9wzBcU6+clGXMpZPNJWvHXwO+r1XD+c9z60TR/0Hj1MRSNBT+Md6EuxKZzJezEiyJbGcShMZIaptFVE1FKAYZVSLFMdkycbXyPKeC/RGngyvlu9Frms6nca8FJGscWqrRbPUcHFQCaunUx4Z7jodIiNOxrsNvJXZ7saqFdULcN4NxbezomHF5lG2dB5ch
 pgGnTkyz
 rdpdssYNDysqJin4AU9LyHuklSWyGG0zdjtJtYWlaf7kZ19CzpKGdzQRIod9MlW7iBTb314sFU5en1RQC6LiQqa3CVLCJceVM/QBuswvH7PxpdI2OecudkZ9EOcxhV00q2hkgLNMXQ+5ew1/GtFH1ll9f9hFAdm4R0ohQQLcAG2ZobCJPvH47RCOqnOwxuO/X4FqnshgMWJI12da4nJyXLihksGxP4Tg8cGJ0SCa7k07Ulc84HOLJizfoG8FTMsZuZRUDpHKUuCJ/EBPRayjn3W5QfJPU7ZWyAcRSRBI3ScsR0xWZXMYF8bNm+10hFbqbJQYuCbua+BQ8o9YAzd6WPcSO4tyBpk1wVO4LyQ3RtUugw7GRI5pBcjT8TyJb0OOpiFswS2Pyv0zXJ2n2csC4I4oO9tlPXARNyjWgy/xhr73naa+0eiBEbCE6Nn0fqROH1tzmT2XRG/0IQwUFqO249e7he/OAIICTjutdh0iS60IxSAhLPoXn4QldQd9rQ6yNc3rFmCPNUP6XHOMy6uQPAI9Y5rCV/HCwwa4H9XRXFGfUkRh2QLmctMQtahBvizDUwlYbZzS1Ccd5vUXZFgUsTD083GP6axcUKDhzvKbMz1NbZsGt3Zj8gwbgSQ0DPzVDtah41YBDsj42S5ZMvKBItKZpSg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Qiliang Yuan <odys.yuan@gmail.com> writes:

> load_unaligned_zeropad() reads a word that may run into an unmapped
> page and recovers through an exception fixup. It does the word loads of
> sized_strscpy() and of the name compare in dentry_string_cmp(), path
> components in hash_name() and hashlen_string(), and the trailing bytes
> in x86's csum_partial().
>
> It is inline assembly on every architecture that implements it, so
> KASAN and KCSAN never see these loads, while read_word_at_a_time() at
> least checks the first byte of each word. A use-after-free or
> out-of-bounds read of a name handed to path lookup goes unreported, and
> so does strscpy() reading from a bad source, which the kasan_strings
> KUnit case expects to be reported. On x86_64 with generic KASAN:
>
>   KASAN and string KUnit suites      failures
>                                   before    after
>   CONFIG_FORTIFY_SOURCE=n              1        0
>   CONFIG_FORTIFY_SOURCE=y              1        0
>
> Check the first byte with instrument_read() at the start of
> load_unaligned_zeropad() on every architecture, as read_word_at_a_time()
> does. All callers only load a word whose first byte belongs to the
> string or buffer they read, so the check does not flag their intended
> reads past the end. Add a no-op instrument_read() for the powerpc
> selftest that builds the header in user space.
>
> Suggested-by: Peter Collingbourne <peter@pcc.me.uk>
> Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
> Reviewed-by: Marco Elver <elver@google.com>
> ---

Reviewed-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>

