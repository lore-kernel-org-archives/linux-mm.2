Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C836FF885A
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 22:49:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A585E6B008A; Fri, 24 Apr 2026 18:49:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A09E86B008C; Fri, 24 Apr 2026 18:49:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F85B6B0092; Fri, 24 Apr 2026 18:49:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7DC666B008A
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 18:49:43 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1C06FC03ED
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 22:49:43 +0000 (UTC)
X-FDA: 84694943046.04.B53302E
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1AA7E40003
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 22:49:40 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Ye4tLA1C;
	spf=pass (imf04.hostedemail.com: domain of stevensd@google.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=stevensd@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777070981;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kP/oUlFBYXfwEL6YSX7iQvgbjoBWqLEtgewBXO/TG5Y=;
	b=5qrGAp2RUHAuFJJxr53amf9BN+ozC+9OtWtMTYB4lRI1pXbD1YJLSNl95r+Uj8wCXicEhG
	K59ssSRVHLBiYTHM8Xv5RpiRtj9nzWWl7PQtsL+QVqOojtjBTW0UAxWY3UTw7awmWPq8uP
	kbqc8/VDXSfmt0qYWJ3y8N+Yiir4k28=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Ye4tLA1C;
	spf=pass (imf04.hostedemail.com: domain of stevensd@google.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=stevensd@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777070981; a=rsa-sha256;
	cv=pass;
	b=6CRtQVo9BvoJx81NYLXo0sArCJPkDImluHwT50TDO7uIX2bORnKgz6UmYD7SSS/Kuleixz
	2LuqNNQ60qSDCf5KiG2mI+ALXhQvVp+nMVFBy5aZVHsH1v5Kf62kGM6Ma1VJ2+4BDZcOOX
	zz4GWT5UnQd0B8pI8RblTnqTHPSWfK8=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-671f1a0d0c5so76796a12.0
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 15:49:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777070979; cv=none;
        d=google.com; s=arc-20240605;
        b=bHMGJKMKpejBRLXwMty1arwSZNO9lORt9y1DOu0ViUEsUYlx7fu9D3Zv0WnnK2ln/9
         YcGamtLrMbXJiNGqggXFrqommcJwidc9hR4Sl1OsL9KkTPSZPMaQrBGSNqETB2hNhHqU
         Zw6H2ePm88DDCu3EqcQVKjixBriUBvJpmVC94zpVN1E4td66wiP2KYC4Az/0vzI6Jzpx
         HyqDojESr5ZFU7/Fy/KKookaiqToPoV416bsbu2qtloWkP9p965Qc8hdsmc9WnFWMV4u
         Ad9KWofEmmdk++jNyLtsHYqKxLSUK8RH8BHTVPo6txec+mKVVwvUjCpzQGjHsgg7hbY9
         Ikug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=kP/oUlFBYXfwEL6YSX7iQvgbjoBWqLEtgewBXO/TG5Y=;
        fh=IfDSf2vHUntk7+zI9vRdXkNPBITGnrjodYHCqFOKQSg=;
        b=Hu6nkfrQ2wE8TVnhnvZPclURqcmTs7C0XLcS/bxmjEQbmg1+CJm5JwpV/T7A+v2IYK
         WbTNP8GVgNZHVMFbt8i8iH+whRtxXedOEpyz6BOgYyWpAnmenXIotkNx2gsH+y3W7M2K
         d5yw38hpfo+oDGDYuXxqZfunhGl2lmYB4YO/4CVlF6WJfbanBlb3TWv9FN5ChKN2W9tC
         1pPNS9ws2eyfui9Rbd5XArGqKGP+s0UPY9eXAr1gacB4csSHLCM6Q0yFEylJwsx3qKPu
         IAY3RyjwIFzwnm2bP4zBNdXFuwQtQKbZ//lVjCtK66yk6WijclQ6llzUTiSQkWc9f/Gk
         /x+g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777070979; x=1777675779; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kP/oUlFBYXfwEL6YSX7iQvgbjoBWqLEtgewBXO/TG5Y=;
        b=Ye4tLA1Cl3DR7RvNseuWbu4IZ+yRq6dWV53vUS3GjQPV7tqIOKykf5ydUdjHapqEZo
         4H4jjAptCBN971/s5ARWxGPkVA6Y1aHYE8rpPF5uM1JOUYjyQLdm0Ut81EpL4eBnx+mk
         +y9S/XBobcCCk/XoNadnDrRbym8GChlDeVeSDUHwnQX5TzKMhVO7FlAeZME1LXKCDwyO
         8eU8F04W+hznQPBMIXEzf9NhdhcIuKyBnHiYR/WvmfhESCc/Fh22r7XGySyTGXCqGWc7
         QU68Ayp692zhsXQsz7sQNK/oYehufi1jlo9nNc0A6X0hCdvNZzZVcMx9tYuPTgvvB1cd
         Yh9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777070979; x=1777675779;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kP/oUlFBYXfwEL6YSX7iQvgbjoBWqLEtgewBXO/TG5Y=;
        b=bvc3uFnGbQJ8l1hNxEMqNVTCe08O76Dw+KEmqxMVyCDwvxkrK2JgJEcjWevlw3I4m0
         yT+5lTukwOQNdy9zqK94LdFX3XIYXl1ggqn3+JZjAhzgLISLHTZvG4I2BxguJF7okHXD
         2bDApfFCNplaKJaH7AmiD7QX3jSxdB1MPaDGe9pSeSEiKb/GVVU1BIzvSpS/ZrcebgrU
         urQaz/n3g/KofRbMhLRDCxd8rAxD+HKoP5xIrAw2zM6uvWhurnUX0rEHeti30BRIEGZQ
         s/rUFEiDP0rTk63c3hQsVwjEkj1rQ2CqeY+kh4PQSDovlDy2kOFXaXChqmXWocSDw7ZO
         J0SQ==
X-Forwarded-Encrypted: i=1; AFNElJ+0lWDFaCr/HRI2bObp0C7CcjvCYzQEecliK4d2s2ATgd6NHIsaj/WxK/2U9RNPau1LajXPNk5jYA==@kvack.org
X-Gm-Message-State: AOJu0YxK6MHk3DUU28h3EdeBG32nYFv0P4zzz8cB38y5co93Kp5DRwRq
	I8WmeHrpwMaUv/sNZ6CrJq/CLpPdMy8shLCR6xkzqhkqHnXUMG4GqTsjYbpkem86VoDB5P053b9
	cU4/UQDLDlt1p2ACyif6YjvVPckmWuQeNYwFXsqhs
X-Gm-Gg: AeBDiesWORxsmTB3S2VJNjGzN4CzBprtqeAW8WxMPBjVw+yLEEjur99OIBM+2b5+I8T
	04Xx+FmKp+poQTVzu1C1sy0jQQNnnTjHcA6xMt7EncbdYoOqrDI+IOQXsdzxBe/9aobOUkgGTjm
	UZZmg28BGOQ40LZ/1qcMM1MB00NQDZXASwLs9Us01xNbK5YYrd8v3kn51sruEJuy7vsuCdK0YPp
	XQzYghF59Yu97dUjc/DPP0fyDPGHjoo6ieqcLTZMM7wdXSdzI+eRDsAhS8f4g0QNwROhOwCS3IA
	t/ggHVDD//5U1DahyzMXtMF6vKLQKdIMEE6yQZPlQur3kJrAiC11sXVWt04Mh6MsK/OYcg==
X-Received: by 2002:a05:6402:a2c8:20b0:670:d5f0:2595 with SMTP id
 4fb4d7f45d1cf-6744f23adcamr157487a12.11.1777070978970; Fri, 24 Apr 2026
 15:49:38 -0700 (PDT)
MIME-Version: 1.0
References: <20260424191456.2679717-1-stevensd@google.com> <da9321ad-4198-494e-b9fa-30d69bd29be3@intel.com>
 <aevhw9xqz1pWA2Ow@plex> <8cd528ca-ff9d-4825-bf10-921ed19ec3c3@intel.com>
In-Reply-To: <8cd528ca-ff9d-4825-bf10-921ed19ec3c3@intel.com>
From: David Stevens <stevensd@google.com>
Date: Fri, 24 Apr 2026 15:49:26 -0700
X-Gm-Features: AQROBzDdgN7ANzHwGH_gVj1rQxf2PB6HxtyD5fRwTA4YlMaABKqW71NvT3hsUBU
Message-ID: <CAOiLmNFH2BS+BLGJ17EWV9WEjicKxAJZ75PxgaesubVN0CDZMQ@mail.gmail.com>
Subject: Re: [PATCH v2 00/13] Dynamic Kernel Stacks
To: Dave Hansen <dave.hansen@intel.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, Linus Walleij <linus.walleij@linaro.org>, 
	Will Deacon <willdeacon@google.com>, Quentin Perret <qperret@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Xin Li <xin@zytor.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Uladzislau Rezki <urezki@gmail.com>, Kees Cook <kees@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 1AA7E40003
X-Rspamd-Server: rspam06
X-Stat-Signature: ywu3kpdhyypsqaek97gar43ksb8haoud
X-HE-Tag: 1777070980-467496
X-HE-Meta: U2FsdGVkX1+5OBntMM44sDYxNu12DnRFuVJXiIvAFQS7USSZzo5tNeBJyWE/wGvYPKV5WKVnEdIGdQrnNeZu9V/3ynVqWBpEeHjuOttqGx78CyYvNEsxBAMiuTjWzGZJ6PNAzQyoMJR1Yx04qj9hxQMuaKkhzWCkErmC+lKRySZzAjqkUMpJDdXAKcSnvQFSK7oYsnUaWafizrOf/5HkyD480FbITuJKbdJKuKJpOBujjOBEpfSCE+5W/zxmVSoA7wqbh8YluCd9ir65q6tLNI8ZjkrT7dWVqtyu4L7f8s1j0McXGe42oFodrnbP9N5KvmxBtc49ijvjRhMSMV08DUpApFqtzx9u6WxkNRsv+bieEXdgm9bhrHSzGZsFPCyD4AtphdQ+kuDq8Zjje4Z1UlUUOxJiWLKkOWTRAIULVYHvADfpQ+FvAJ59c5qR9z7QKb3dv0n8o6tFACfvjS9t9l2qFkTrsZW581nbFr24tt+ZpD/oOVLUHnlTk8HmKYhOLDfWoCvzy0EkxRXwj3dRBHalcZ0DqUeOJAR3xxTH8K5Df4efcQOXYNJLt8azYXSKTu2CQExenmI/W5gfyEpWYxWu6VUOtFIiOW82n4G04icktKum28xuJ7l0FPOs0+pbkKrdYdHLAdgTgkGsu2xwAZhlzIKin/nkyzgxqmDCRUVgpf0/9Nko3u5xSBMtLOhEvlKRc2DfMKzorWnaeAbSptNT0+YUR9XT7vw7HZcLMr7lr4zy5rm/3MT4eHSikX2yiuC8PAZIG40uyyWaEdndXUSIXCWYVoUAhRzF9cD31gmvOGe6vu7V5i+h3BtruIjhAxRWyFBbiNYJ8Q3R1Cq/46NspwVzv+uP8sF5PedcHoARG7p1LmwTXrg8pFN90UAtLTO8srGi6INLS/GrVK4l7R47XwtXZ6zkDTeyK1zAb+UC4iGxfoud+vvyhB7uU9i2k/Y8nHrl6tnFpUp7H1i
 BuINnAxh
 93vnsJKV62BcgWNqWcC4HRG4SQuiuPK5gvcnM5BPKFc1+Xgxm9vl3+WJLxZbpntSgkKKeCUYldUchCNYjzGT8vLQ1ZIl49BNZqCQe+Bq9mSO6BaV2lrOu35bBTNbjfgcJay9RFGC1h3kS6PcSF2ZjD0qDpeI76ir6fgmGj3e/ugOYa/UTbVqBxKZVbpzkR0yMtmp4qH3gm0FCmX18V4bzzEdbWs6QCkrk9l52OUiApeN97GxV5fbn07FWNlqSuzvxlDr/KersCTTsvgs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24, 2026 at 3:21=E2=80=AFPM Dave Hansen <dave.hansen@intel.com>=
 wrote:
> On 4/24/26 14:35, Pasha Tatashin wrote:
> > On 04-24 12:41, Dave Hansen wrote:
> >> On 4/24/26 12:14, David Stevens wrote:
> >>> The question is then: is this approach something that is fundamentall=
y
> >>> untenable in the kernel
> >> Yes. Fundamentally untenable.
> >>
> >> Not allowing stack faults has been a wonderful simplification. It's on=
e
> >> of those things that just plain makes the kernel easier to maintain.
> >> Saving low single digits of system memory is not exactly making me eag=
er
> >> to go back to the harder-to-maintain days.
> >>
> >> I seriously doubt that this 1% is the lowest hanging fruit for memory
> >> bloat on these systems. =F0=9F=98=89
> > This true until, in a fleet of millions of machines, you encounter a
> > one-in-a-billion chance of a stack overflow. You are then forced to
> > double the statically allocated kernel stacks on every machine, paying =
a
> > memory tax even though 99.999..% of threads never exceed 4K. This
> > overhead accumulates to petabytes of wasted capacity.
>
> I don't disagree with you. But, at that point, you're picking your
> poison: bugs dynamic kernel stacks versus crashes from stack overflows.
>
> At some point, I might be able to be talked into dynamic stack as a
> FRED-only feature. But FRED isn't widespread enough to go to the trouble
> today. I'm sure the folks who want this also don't want to wait until
> all the devices in the field have FRED because that even *longer* off.

Why does this need to be FRED only? True, the lack of reentrancy with
IST stacks complicates a few situations. That adds some complexity
beyond what's needed for FRED-only support, but the additional
complexity doesn't really seem like a hard blocker, at least if we
accept the complexity of kernel stack faults for FRED.

-David

