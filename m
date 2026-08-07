Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48091C2A09B
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 14:27:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B0AC6B008A; Fri,  7 Aug 2026 10:27:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0883F6B0093; Fri,  7 Aug 2026 10:27:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE2C36B0095; Fri,  7 Aug 2026 10:27:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C61A56B008A
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 10:27:10 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 53822A1E3A
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 14:27:10 +0000 (UTC)
X-FDA: 85074700620.15.B94747F
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf15.hostedemail.com (Postfix) with ESMTP id 5B0ABA000E
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 14:27:08 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=XbjaN9Ix;
	spf=pass (imf15.hostedemail.com: domain of aliceryhl@google.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786112828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5ZT+nU5ePSOJIdlnBHHaxRDfRgbVL3I6dkvQIAl0+3M=;
	b=jenXx1AHYEO2BkQfx5In+JA0tFcvaV6w7M6J+Olf5L8IJrRuPSBVB6iv1ekqfG/0010JCn
	OlrHLGKaYoPzZ06JnXS0TVfntY6c2wB2+8AgXdHAq4lWLZPzROX5i3BQkYuLW2xuGrBYqN
	2hg3Tytk5r+igGGrsREhvWhRfKB6V1Q=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786112828;
	b=mCICL1Sd66HemCYj0KJ1t3+LtBACV5pUTaSWQcPSRgQnl4v99uEXKdMjL5sgODBRYIL+xp
	wAKp11Y23KL98Ktigbi5oYB2vel04PxL91Pak+uKdc8QO2hZd/ydYQOA8lKpHLOvgWN7pA
	Uh2E0gzb1qip+yYO9Jl0x1bS6G+DWzw=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=XbjaN9Ix;
	spf=pass (imf15.hostedemail.com: domain of aliceryhl@google.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4954df200ddso24355455e9.0
        for <linux-mm@kvack.org>; Fri, 07 Aug 2026 07:27:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786112827; cv=none;
        d=google.com; s=arc-20260327;
        b=fbE5/6kvSebx15XTKDcR/WZB3MyGDarjS4W+siJCNKlwLbmjMdBsNqqwDuZ5hRhzCy
         lBLEXBWSmbg3c8WjJsa6vnbyRUsV9rQy3ZpFlIv092AgXWlmYzu25TkFaui1MFfx4qaf
         rZk2fTpitq6zgr/cLCgtU/6Kw5Hwdu/GiV7HNPBSe/UbOcV9bGh6gRouYve7UIqnQ1Ql
         iHXN7LJF79IcCM6D0uuI1Ek9+fzq9xkvPTxWrGpGYsCsIMVUZIornmCy5BajjtDe3A1O
         yEVehygISLPTQkjyveS3OaK8NtRlMEzVvFG3kWJBwovXacm2RlpVgs4yHVMf7TUZP1xc
         uM/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5ZT+nU5ePSOJIdlnBHHaxRDfRgbVL3I6dkvQIAl0+3M=;
        fh=iHPXydCtoEJTvknFNdF56chlCd0WL0rH99UlN2tFJy0=;
        b=RkxmoO64AMN2wvhxgasrkFbdkBTJPxQQTCIbOvXHgpVHyeF+COCSAh65b+02Zju6W+
         yrqNequ5pt+FcOAyrjlHF6nSD69MNDBQ6nyZ37Gt7RSQthoETBRzwc9JWGQKRJrDsA+L
         bUhYAhrhMLp7jznAnTwHciYocjSr6nrCUp+MYHHbWxUVkPo4aBv5PMV+7yd76xzpigHM
         xg6qzWLdRoUZIkQ6w+Q3sIDJEimdO77JLOK4r68CafmXp/3arpC0N6NV4toKJiuNSUKR
         7Qa74jktOpuHd8KJkpKdm66OE2OW90GFvA15bHy9MN0cN2Jga00bNaB6axOmZx5cEA0h
         xilw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786112827; x=1786717627; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5ZT+nU5ePSOJIdlnBHHaxRDfRgbVL3I6dkvQIAl0+3M=;
        b=XbjaN9Ixryfco+IS7NnLZuxoDoZDQ8jHLRyaSX3l7lMLhuOz1vAI4NyyKryvPoOX/9
         0qmNmShZi9pSh8Qvw3p3AAtUE+LlrPqVg+sBclwn1Vi2pCVHz3js2+FTWvgLe71gh6iw
         bOUfVrHsI6xfeIYf+KGFTpbEbUBo8va40vG3kV8dcCPuDG0wA35A2kfwVCCAiuRGljhd
         I62H/cFWhpoBzA3/LWkj/yXF+9yR86wL2OtmqeR8heUV6/upjH2AS/3J2n2B9w01AFZP
         jHwkUfV6ggEBaTFOQnmbYiqtiribU9wux/mZOaeEsHpMhCTKESSawYJjj5IvWEKzSnZq
         mfpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786112827; x=1786717627;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5ZT+nU5ePSOJIdlnBHHaxRDfRgbVL3I6dkvQIAl0+3M=;
        b=NcVjCMWPCdSxdzq4xhQnhJW6cT09j4H6MMjJ9OhGkrNYIorfh6fg41MemN5L/KMmsa
         SXsL8qkO7m6hRTATQm6ohDvX3QN8ZhRA+yEGLt9/Z1kVgteBIx2oyM6Pk6ZX8XsqK07s
         KBRrmNQX/AmNT6Lzj7LxfkK5EPJTiAh78VXZQw/I9bqM5nDjs4mKdktbKOA3yuue0bG9
         noOXG16AA33PKGGVFMcUNvyt3cmoPdqws3xDWt7SYT3DjHap/Sn3BL0Gz8/txg/iJtBc
         fubDamoKw8J2qiBnGngFbOAfr0VzwFQiGjWbRqTcHje9VnHJuMwO9z4xz4lzgfQqu7OB
         yy2Q==
X-Forwarded-Encrypted: i=1; AHgh+RoPqAjvmcbSzBI/6r7n2pgd9BlmwN8fi8lGBhmtnm4asVVG1FvhHtCrZvpbxuCeLNbjLjTQAHg8mQ==@kvack.org
X-Gm-Message-State: AOJu0YzEIB3NvsIscCFPaU98RDp18+TVxZaWjbwIJF/KGtbYyqmZ7aV4
	SahcynRdEmhoDk6DjE464Qt2+JIszLjCM6Yd75+j6mOiDwa9k4+FRdVRNUJkysKrEl7iEAqZ6Wo
	Ro3/Hj2hHZSleTyYecHaEzj8Z/wklnYG0/+1AyCBd
X-Gm-Gg: AR+sD10Iw4NRIbh7v+ME0yaMWO+ZLgHcj5v7fflgt5YxRdSrfdueuDdruHh7RmgeygO
	b0GW4p/t7i5zjjvBpqdoy+AiZy+PBApjX2dKBReY3TpgjdKxoZQJrh+0/XeLK13xrzy0OP//sxZ
	Xj2EZjK848jGjebOEQaAY7MSIlLUypXVf1SOvMOcLphGhL4wRICTD8AXbyyWA6AMGmABeLxq4cC
	58LFAw02YseU03iksUyoSjMSFR6aqjN45DX/yV4nbfuo4w9v0T/CZbZJo4SjeT49jMR48qIWTmP
	Bl2xGlUZFSh1FhYS8lSImVkNppF0mHjQAu7ooRKEjaGY6ATlNau3HOpXsrGUVa4b9tEZ9NBJ6Oo
	1rSRkiTpCr/hwIXbjCYMRs/rK3WYXpcQ=
X-Received: by 2002:a05:600c:48aa:b0:498:ff3:71ed with SMTP id
 5b1f17b1804b1-4994e7e6e99mr211942655e9.17.1786112826205; Fri, 07 Aug 2026
 07:27:06 -0700 (PDT)
MIME-Version: 1.0
References: <20260806200548.3124802-1-surenb@google.com> <20260806200548.3124802-3-surenb@google.com>
In-Reply-To: <20260806200548.3124802-3-surenb@google.com>
From: Alice Ryhl <aliceryhl@google.com>
Date: Fri, 7 Aug 2026 16:26:54 +0200
X-Gm-Features: AUfX_mwSu3MvMCSzwZwIjnv1yD3ofSuLhSz__pDDowPm-PtIyEmCGX0-kA2AFSw
Message-ID: <CAH5fLghUGQFq-wsQpLDqvAdT1VviWPumCZHBg_qL9eMTh3GNFg@mail.gmail.com>
Subject: Re: [PATCH v4 2/5] binder: Make shrinker rely solely on per-VMA lock
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, dave.hansen@linux.intel.com, 
	Liam.Howlett@oracle.com, ljs@kernel.org, david@kernel.org, 
	willy@infradead.org, shakeel.butt@linux.dev, vbabka@kernel.org, 
	jannh@google.com, arve@android.com, cmllamas@google.com, christian@brauner.io, 
	tkjos@android.com, dsahern@kernel.org, davem@davemloft.net, 
	gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5B0ABA000E
X-Rspam-User: 
X-Stat-Signature: gt9zbtnro6abnfi8qq97ibgpttjdx555
X-HE-Tag: 1786112828-578682
X-HE-Meta: U2FsdGVkX18kIZhV4T5scAFgYrtwxJJ50TAxNeRqQ1nLbXwZmqsE0GrtzEWKJNvJzL3dpBQfDzgLJvKz0vM9Z5m/8Fi1z5kubqG2YsmsSDA97PnQnB0Jvk9L3wVrul7J2b+zSGRyYhT2eeRII3n5fCqchrKtmen3OqD5QS+dEnwQ3W10tqTdNQ5B9xiqBhzfH+duaQ2UBkPu479nbyaNPnReUjk2zMJ2HmBglRIaZpgkX3FsqKybZJcRqRc9RcIdLmZPGWBX2rJhz06OqPA0aqHRiB8HWq5HoRLLl4oGm2ajDWs8qawd1MkSHVgAg4AGhtyRmjqll9IEPHPeae1BavN5fEIZ9LTHe0oMByHv02PD8CYStoMbdVBSAIwtyvbnfn2iwSINJ0fMs50f/cXREuKtjfofycj+yPvLgq9zLngtHf+tMv8r3SgDfO1ghckTsJacaOuKRNsIMxwh8UpPLdpFMaZYunWbIR7aZZrC4pnhp6ljHnMhXq1IUarAhYMDLYjz7jWQj/hTYP/mlJcSW8uU56ZYuUwiOYlMFUFF+Id3nC0CwCIv9yxQAMYUbwfRV9K/8Ng+E6X3ECvSYCs4ouQwtnkhbYtPVQzJruzy8ftE1JbQdy4L11s70FD0hUrJOJa+GehoP4sXWrrb4RkLosxOyV+g3WsAINFhsu7a1PQGge6XI2acJ9rt+1rcqWsOum0DrBqUFROcPSfn2Aa4PJg1zIoYqQ9UCsulCR61HgxrBynod3Fi6QxOGExginJP5Xt7mpvP87CE+rN9Jh/pM6OyOZ/hVv6TdQFdp3WvJooXwIK7PmPl7WNHNV4wpFtiWvcJ73DDViKA21NDeDuignrFa8lWgVKr141C8T4O36nTAmDLCh2HT0tj2/xxDbQokafq5PsdNSIVui/KE73x2Od3vc6xJsoySGWTrUNjQr33wpcPFqIsxtxZ/3X5QvAl6dlF0jf2exmGcTx5dMA
 14c29Chf
 CuEcdvAmtZpT1XL7jAEDgrQXdLaZJzquDu95aX+5NSbRdvZEwSNP6w0iELEybL0guSuZEJIDOodXBW7OnZV7VpguyeyW7ZS9U4LEPWR1dgmZaBAJ8ZA8wOaeDm6lh7XvHfgtkyN3dU62PII6c/uQDcr8PHb2fNwuAcJxlkSExBZNXTJsL4Z3w1L4qI0Wp5LhsnQ1KSFvBVqcv/Ry/8y+ShbYZ0pX64ZqjzV+j/iaVPpHvyrBFFmyek4rMfQqs8k9ycdezIMnDy1AREqVtYFCYByqy/dqsb4uX+03sPXUVW8uAYJhGQsfR/vmyyMc77QsUTZirEF3UgPDE4RWTLW5aW6VcpgV+NKhmYE0H0OnR6hwX/Pk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 6, 2026 at 10:05=E2=80=AFPM Suren Baghdasaryan <surenb@google.c=
om> wrote:
>
> From: Dave Hansen <dave.hansen@linux.intel.com>
>
> tl;dr: lock_vma_under_rcu() is already a trylock. No need to do both
> it and mmap_read_trylock().
>
> Long Version:
>
> =3D=3D Background =3D=3D
>
> Historically, binder used an mmap_read_trylock() in its shrinker code.
> This ensures that reclaim is not blocked on an mmap_lock. Commit
> 95bc2d4a9020 ("binder: use per-vma lock in page reclaiming") added
> support for the per-VMA lock, but left mmap_read_trylock() as a
> fallback.
>
> This was presumably because the per-VMA locking can fail for several
> reasons and most (all?) lock_vma_under_rcu() callers have a fallback
> to mmap_read_trylock().
>
> =3D=3D Problem =3D=3D
>
> The fallback is not worth the complexity here. lock_vma_under_rcu() is
> essentially already a non-blocking trylock. The main reason it fails
> is also the reason mmap_read_trylock() fails: something is holding
> mmap_write_lock().
>
> The only remedy for a collision with mmap_write_lock() is to wait,
> which this code can not do. So the "fallback" after
> lock_vma_under_rcu() failure is not really a fallback: it is really
> likely to just be retrying in vain. That retry in an of itself isn't
> horrible. But it adds complexity.
>
> =3D=3D Solution =3D=3D
>
> Now that per-VMA locks are universally available, lock_vma_under_rcu()
> will not persistently fail. Rely on it alone and simplify the code.
> The removal of the fallback does not affect NOMMU case because binder
> driver depends on CONFIG_MMU.
>
> Full disclosure: I originally tried to do this with
> lock_vma_under_rcu_wait(), but it did not fit well with the mmap_lock
> trylock semantics. Claude caught this in a review and suggested the
> approach in this path. It seemed sane to me. So, Suggesed-by: Claude,
> I guess.
>
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>

