Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99844C5AC7C
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 10:40:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A248F6B007B; Fri,  7 Aug 2026 06:40:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D52D6B0088; Fri,  7 Aug 2026 06:40:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EB856B0095; Fri,  7 Aug 2026 06:40:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 662CB6B007B
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 06:40:56 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F15C01202CE
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 10:40:55 +0000 (UTC)
X-FDA: 85074130470.04.7E3FB79
Received: from mail-yx1-f53.google.com (mail-yx1-f53.google.com [74.125.224.53])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0706F18000F
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 10:40:53 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=D6P1xUt9;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of vladimirelitokarev@gmail.com designates 74.125.224.53 as permitted sender) smtp.mailfrom=vladimirelitokarev@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786099254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wc12/Ao6shflemkswZxNzDBhCRuexOAUcBu8f6qMz7M=;
	b=axgY5avyDSL/CrP0r1S0h1pmWNZh4uTylmvjQSEWD88jiE0IidTtvr9pSLb1vJbTx7W3Lu
	+d+oyTHmXsjPaa402k76mdlgbrA6tJlHlX0dx78ylw58RZ7f4joKmUUk+582Mgvs9y0ZI/
	UBNter55Wxuvcd65XhZlDx63EH/ICLo=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=D6P1xUt9;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of vladimirelitokarev@gmail.com designates 74.125.224.53 as permitted sender) smtp.mailfrom=vladimirelitokarev@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786099254;
	b=r71p1cPZA3frGDi8XA2Q90ZXnKcvYesqYzDmLZsafKn1frx6J37VrqPsUNcsOsuqKxPYeF
	Jt5t+pRU7TpBImDVTS+7JCWBGgtPhRFkUHoXCM6CFjw8pPORYVofbzYX4pfL1mCVEb211m
	WlJPIZCC+ZVhFsf/N0gwm62DFGqvw20=
Received: by mail-yx1-f53.google.com with SMTP id 956f58d0204a3-6689402c7bfso3679762d50.1
        for <linux-mm@kvack.org>; Fri, 07 Aug 2026 03:40:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786099253; cv=none;
        d=google.com; s=arc-20260327;
        b=Fqb8VgdYW7NMigHuG/Z48BgnA1rRwUVIQfMPx7E1r5Zq8N/Y8jURMPGkdnHCD/YxoN
         eRQpitSr21wz8dpNBr6t5QlfFdQdVxTo8n/6L8qS5CvnvKVcuoBuzhiOO9VZQH+D8erI
         8tF36GRaTM0GXauIHbdWuXm64FO73qE9YJA2q4MHI0XBYDE3IMHPrux9Lddh8yNT4LYZ
         UG+Wq+qZQkls1bp878UtMJ0tNBfTl0UV0GHsYjCNP8hY61+3M8os1Fnl1xGSSE+FVhuV
         SfE9ZDdV6pSfuXrFtHjpw+lAE4DucAeaAsPMCnqcyBN1vFQYqUOoYhl+T3hJKxjv3IoR
         LoVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=Wc12/Ao6shflemkswZxNzDBhCRuexOAUcBu8f6qMz7M=;
        fh=PG/odzDsi0N7WufblHXQTC6s5oKkRQH8+b8PB8vESbc=;
        b=pCGIDxlj80+3c6K8rkHN7PTbMrG+v0mKtv4xcWM/HmGbwaYTw5BV88ncEnmvy6WSKy
         u4+CQCjmo7OpVXVTsF1+BIWvzQfjEJ3Qt2x5FLc+HXT6A6nMHiDNN94masBSdTrY/JVB
         DsyxKWLKYV+13YBAj2ef2Ln0+6KpfbFSYlk0Tn2QfNdXIWiesFZ+TFBxPW8ZqWesFS6q
         oaocjeC0if6kcd9C4heW6rHIYvl+Wn613NerK8XJSxunD9vTA5SAha7uSBzMI4AdegSc
         TZui/pbr/yRp5pXoCk3TBFWKhsD5PAI1hrk+w29IXTWooA2AXNkGMVziQ0MxeN/T2bMu
         +rZQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786099253; x=1786704053; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Wc12/Ao6shflemkswZxNzDBhCRuexOAUcBu8f6qMz7M=;
        b=D6P1xUt9As1EtEWYXzpXRxDvDjgkbM1OA02FIj8bO5ZRQzy2aICYVvNSrtAO06lZXS
         BCxCYBBiCugAi3wDZdnvO9VYPswNPyO2G6XThHh43iX8hEN0j9QiFNsmmt0zwT5ivlR1
         Lbj6YSm3BmFBjdvlMlIJ9wVvNFUxm/Y36o/YPymPySruAUkUxLIp2C2dWKZ5z8SM678o
         WQesadk2BnBNVdVNLAtnvebgEAsY8ovy5a7ugleyyQwAuWE9SaceSvkULcUhmEE/wV/E
         vB2M1G8f0zmPJbP0inBQAsiH2secDGk7FfgDfZ20OdwPrzcbDj87gILel3DuER2iDh33
         sSWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786099253; x=1786704053;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Wc12/Ao6shflemkswZxNzDBhCRuexOAUcBu8f6qMz7M=;
        b=E1borM0ADkJSQ4yxyIfY162NrpDMGkUXhWtzsY/1AIZgNY8900ovRJvXCn8xQjx3pr
         PrpjoDTvGaVOhJi5n9OGpfTa1zaU5Qj1MaWOV4WfNBXgwl0ByOW4loo1jdwyM7uELUbY
         Uc5c/EpDXZhyGEjCB2sOB0A9TvLRmMJC5GODa8EjG4Dmc44S+OLMcagsGtJpOCUO+TTd
         Mc5zApFza8fyTDfThMN6GMT334b3VYRijXmKp7H0kj3GYehky636kw3eqRLSP6M1FaOZ
         nrRkH13Hsy8TKdy00WvVqXa5fbHNYztbHbTHkPTkVuGjfOn68a4wELXZ22lvtCbT5jRe
         xt7w==
X-Forwarded-Encrypted: i=1; AHgh+Ro7hC9ymi8jRUz9tnbs2gcEk+oX1knYzptdVmecBD34670HvgWjXbZ81rE2+J3qkSBcrBumWfAoZg==@kvack.org
X-Gm-Message-State: AOJu0YzgI5QqGhuJ53KXIlGpTPzuOUSjAiyCgVBnyMpdjIYm7bJG5s+f
	4OOEGA8W+n4creo7q1F2cvzWUh1fVst9VZ5+kMI1s++OGQJn9fE9lt7XrP6wRcqBzhLD5R38wJk
	+mEJCWF3HPO9jL1BR++RyoesP841UwRF//m16GtI=
X-Gm-Gg: AR+sD10ExCdRrLXI4RrAMFVGDjZysuEU5k0aq7m088vYA5mk4SgHoNF9PiygE0q18zf
	pVl+KSRkhPGtbkV7JxqDgtPjysv8Fn+Tc1JDWhbKtxIEjC4wLs4XuVG2Ridgc7ir9zOihEMReFj
	8hskZ19kU0aUf3BlUYHEdqVB7koWzbnKr3JkeNNiqRFNVmjJ7Qpu+Bv72oJMyDM/j9khIxlo5Jr
	fKzrAXCC6Rmc8w2Wad81tBJMgEwETG57dawhGeIhQB3KLs/Pu7HpXyMB16jnoF8tsOfVzbGtCvH
	8FPjUZm29ZFAPsTJcsyLJddMCjAyndR8La6XogXlYu/e3SHv1NpR1xr0/pBYYCiIzgOfePr6vy0
	ZqOZYhG40fvLUbkP2rTQ=
X-Received: by 2002:a53:cb8c:0:b0:667:d3e3:1713 with SMTP id
 956f58d0204a3-6699a84b61fmr10679110d50.4.1786099253042; Fri, 07 Aug 2026
 03:40:53 -0700 (PDT)
MIME-Version: 1.0
References: <CAGBKPgOm8q-8_rwyRPEmSj8JXdh_GaK1Q8vpJ=j-+yA0SgcNQw@mail.gmail.com>
In-Reply-To: <CAGBKPgOm8q-8_rwyRPEmSj8JXdh_GaK1Q8vpJ=j-+yA0SgcNQw@mail.gmail.com>
From: vova tokarev <vladimirelitokarev@gmail.com>
Date: Fri, 7 Aug 2026 13:40:41 +0300
X-Gm-Features: AUfX_mycbxuhAHRaIJFgBgN__sLQ8AbjjwhOWHtuQ84dh9S6BXB7zx3i-vnTqGk
Message-ID: <CAGBKPgPPALX_5CQJAKUNjwi2fD28pBeS5pRuwQgePU93pOy8EA@mail.gmail.com>
Subject: Fwd: BadBunny: UFFDIO_COPY shmem killpriv bypass leading to local
 privilege escalation
To: akpm@linux-foundation.org
Cc: security@kernel.org, linux-mm@kvack.org
Content-Type: multipart/alternative; boundary="00000000000082e41d065872a32b"
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: m5qpgqibbfwyw6ad4ckswryn9nzb8g7m
X-Rspamd-Queue-Id: 0706F18000F
X-HE-Tag: 1786099253-168806
X-HE-Meta: U2FsdGVkX19oRnz3UqXaDYK58GzqA5ffdtT9Kp9AuIH/StFpriY9HfKzQcfC3ifvBo/G6jNhP5qhLq8YWf3wygwlhQhlWZd7ckDLHSqYkV2Rl/OO279US4bt/4JVZuz9GZkhtuCitYdjlC0KMMUsq8iLpvywtGsdBSGpDLqccw/lqdqycdjxr/+oLGoQ47bMeBPzchWVkpOWDBf6m8sftU0eNf9hysRe3XlHldqFndMAqa0ftXFHPix+kuJSkXFVnk5fAc+ngCbzqR/Tj+tiKrEDoIBiDozLBycxIkBdlQcX/KPE8XUkabDceS7mfUKKkk/Nv2L7de9/QlKkicyfBgLkiLAqOEZ7R9fhIoSI3oFGqKxverTLbJBsU0dRnyNk6Y8eOyuSEjG2I4qSLtYIMhvlMEjJ4Vt2/KDVty8aiu6CPPps2zfqUnmt9NrpfV/1l3WlwojGdixhwyn2HErKkxT5GcphsTvGsY983gnDrN1Ujflx6MQi3hvzH5C4CA2RAYd8PW0b6iZookE/mqPFnpZds9hYfkOaPu0Oi8TWx2f1k+ga81uxhGb6I++DjfEXOrAmUgWyTjIHSg0tImDaPOi1CdqiDY7pe267KGtZTWK6TBKiyssk6/sAH/YpCntq/3wTnEJ+X2cXn08yuhNoBdBhBqordE/91w5Jr8y0JB4fWiF7hfsunfdyfMtpE8CJpV6+KPtUyrFZ00NQcNYWRUIAQT0MbIJKWD1mmXyoXfFjGhudm6q5eoaWqmUfgplFf34pZ1f2I5wN4olGbrOmQ2UV2juXOTiu/alox6HjSWoqcOzXPT3/Gk+qESG0Ib7N81o1+/wilkDh8awZA34WhUWTz5NaHz2VTtA/mbLnlBdjK2CRjEB6YAhcVX0AIJftHTUD02fW1OHSCnvWjf0o6Gw8oqFXp1e/thI1rjftFuFylljldZ5j0khFY4OG9a3QsdEdn2VC4YzGOQddgyj
 I5jgC7qw
 179vhL1jqHDAcziycfD7Ws8YpjEQTD7ETJBKakWtRDgccVr+H9dAr3a/kTJUIjvpxIobBlZ/Lu5MaL1dylMYMiS3SB5E3Rs3aCTS3ZhdZXPSWtyeckLDg+nfS1VvdrSoh3vusQFkJsBVUIgDLf6N4Q3Le9GyGy/sqqNmJyVGkpZxQbiuQuTrUoFmYlV4dz4nF0MtE7bRwmebomfvixsRQkEE5Oa5H0HEoHVB3L3Bv/p3oc+TKU67rnSFHJUbxnHPnA8QBZw/hrFKZXaiZ2eTr5wIeo+Hg8rSmoGYq/HGItoaYoEeySbFburoGCjSYx07qNDXebswG1DzcWKclsOugrR9vkK7RdZ3cKMTBjj+dZGdk8SImGy/eqC1zdGcaKa4xxqaZotnhQBEMM7ZIjAbtmpANHXAT5sB1I9OR0P+WUr3LrQz3Svyi2iDFKbGorPl6xmZd/qg827EhHX1d6Iy0KFZ9dwWKXPo5CeZ9g9q5d/9r40M3e5m1sd+EBppw6gDrkKB8zeMpKJ13fnzEeZh36SJXTd8yzL3KJutwB8q2cTjMfketss7cpT55yf2XJcyQPeV0VjgZuguSRSeQwq2XtdDpqQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--00000000000082e41d065872a32b
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

It's been almost two months since I sent this report, and I haven't
heard back. I'd really appreciate any feedback when you get a chance.

I've rechecked both mainline master and stable 6.12.95 -- the
vulnerability remains unfixed in both trees:

1. mm/shmem.c: shmem_mfill_atomic_pte() (6.12) / shmem_mfill_filemap_add()
   (7.x) still adds pages to the page cache without calling file_modified()
   or __remove_privs(). Writing to a SUID binary on tmpfs via UFFDIO_COPY
   preserves the setuid bit.

2. mm/userfaultfd.c: I noticed commit 85668fda932a added retry state
   tracking on master, but MFILL_RETRY_STATE_VMA_FLAGS still does not
   include VMA_WRITE_BIT -- the mprotect TOCTOU remains exploitable.

This is a deterministic local privilege escalation (no race timing
needed for the killpriv bypass), affects every kernel since 4.11
(8+ years), and works on any system with userfaultfd + tmpfs (the
default on virtually all distributions).

I have a full working PoC that gets uid=3D0 from uid=3D1000 reliably.
Happy to provide any additional information if needed.

Thanks,
Vladimir


---------- Forwarded message ---------
From: vova tokarev <vladimirelitokarev@gmail.com>
Date: Tue, Jun 16, 2026 at 12:37=E2=80=AFPM
Subject: BadBunny: UFFDIO_COPY shmem killpriv bypass leading to local
privilege escalation
To: <security@kernel.org>


Hi,

I found a local privilege escalation (BadBunny) in the userfaultfd +
shmem subsystems that affects all Linux kernels from 4.11 to 7.1
(every major distribution: Ubuntu, Debian, Fedora, RHEL, SUSE, Arch,
Android, ChromeOS, and any system with CONFIG_USERFAULTFD=3Dy and a
tmpfs/shmem mount).

Two bugs are chained:

1. TOCTOU in UFFDIO_COPY retry path (mm/userfaultfd.c):
   mfill_retry_state_changed() does not re-validate VM_WRITE after
   dropping and re-acquiring the mmap lock in mfill_copy_folio_retry().
   A concurrent mprotect(PROT_READ) installs a writable PTE into a
   now-read-only VMA.

2. Missing killpriv in shmem UFFDIO_COPY (mm/shmem.c):
   shmem_mfill_filemap_add() adds pages to the shmem page cache
   without calling file_modified()/killpriv. This preserves SUID/SGID
   bits when file content is replaced via UFFDIO_COPY, unlike normal
   write() which strips them.

NOTE: The killpriv bypass (Bug 2) does not require
unprivileged userfaultfd and works even with vm.unprivileged_userfaultfd=3D=
0,
since UFFDIO_COPY on shmem is available to any process that can open
a tmpfs file O_RDWR and call userfaultfd with UFFD_USER_MODE_ONLY.

An unprivileged user can replace the content of a SUID-root binary on
tmpfs via UFFDIO_COPY while preserving its setuid permission, then
execute it to obtain root.

The attack is deterministic (no timing dependency for the killpriv
bypass), requires no heap spraying, and bypasses all modern kernel
mitigations (KASLR, SMEP, SMAP, CFI, PAC, heap hardening).

Affected versions: Linux 4.11+ (since shmem UFFDIO_COPY support,
    commit 4c27fe4c4c84 "userfaultfd: shmem: add shmem_mcopy_atomic_pte")
Confirmed on: 7.1.0 (aarch64)
Affected distros: All major distributions (Ubuntu, Debian, Fedora,
    RHEL, SUSE, Arch, Android, ChromeOS) that have CONFIG_USERFAULTFD=3Dy
    and tmpfs mounted (virtually all Linux systems)

Attached files:
  - bad_bunny.c                           Full LPE exploit (uid=3D1000 to
uid=3D0) Build: gcc -static -O2 -pthread
  - suidhelper.c                            Standalone SUID payload binary
Build: gcc -static -O2
  - uffdio_copy_lpe_report.md     Detailed writeup with root cause,
reproduction steps, and suggested fix
  - badbunny_demo.mp4             PoC demo clip

The PoC (bad_bunny.c) sets up a SUID target on tmpfs, drops to
uid=3D1000, uses UFFDIO_COPY to replace the binary content with
suidhelper (which does setuid(0) + execve("/bin/sh")), and executes
it to get uid=3D0 euid=3D0 gid=3D0 egid=3D0. No physical hardware needed.

Suggested fix: Add file_modified() call in shmem_mfill_filemap_add()
to strip SUID/SGID on content modification, matching the normal write
path behavior.

Thank you,
Vladimir Tokarev

--00000000000082e41d065872a32b
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail-ii gmail-gt gmail-adO" id=3D"gmail-:3r=
s" style=3D"direction:ltr;margin:8px 0px 0px;padding:0px;font-size:0.875rem=
;overflow-x:hidden;font-family:&quot;Google Sans&quot;,Roboto,RobotoDraft,H=
elvetica,Arial,sans-serif"><div class=3D"gmail-a3s gmail-aiL" id=3D"gmail-:=
3rr" style=3D"direction:ltr;font-style:normal;font-variant:normal;font-size=
-adjust:none;font-kerning:auto;font-feature-settings:normal;font-stretch:no=
rmal;font-size:small;line-height:1.5;font-family:Arial,Helvetica,sans-serif=
;overflow:auto hidden"><div id=3D"gmail-avWBGd-3720"><div dir=3D"ltr">Hi,<b=
r><span class=3D"gmail-im" style=3D"color:inherit"><br>It&#39;s been almost=
 two months since I sent this report, and I haven&#39;t<br>heard back. I&#3=
9;d really appreciate any feedback when you get a chance.<br><br>I&#39;ve r=
echecked both mainline master and stable 6.12.95 -- the<br>vulnerability re=
mains unfixed in both trees:<br><br>1. mm/shmem.c: shmem_mfill_atomic_pte()=
 (6.12) / shmem_mfill_filemap_add()<br>=C2=A0 =C2=A0(7.x) still adds pages =
to the page cache without calling file_modified()<br>=C2=A0 =C2=A0or __remo=
ve_privs(). Writing to a SUID binary on tmpfs via UFFDIO_COPY<br>=C2=A0 =C2=
=A0preserves the setuid bit.<br><br>2. mm/userfaultfd.c: I noticed commit 8=
5668fda932a added retry state<br>=C2=A0 =C2=A0tracking on master, but MFILL=
_RETRY_STATE_VMA_FLAGS still does not<br>=C2=A0 =C2=A0include VMA_WRITE_BIT=
 -- the mprotect TOCTOU remains exploitable.<br><br>This is a deterministic=
 local privilege escalation (no race timing<br>needed for the killpriv bypa=
ss), affects every kernel since 4.11<br>(8+ years), and works on any system=
 with userfaultfd + tmpfs (the<br>default on virtually all distributions).<=
br><br></span>I have a full working PoC that gets uid=3D0 from uid=3D1000 r=
eliably.<br>Happy to provide any additional information if needed.<br><br>T=
hanks,<br>Vladimir</div></div></div></div><div class=3D"gmail-hq gmail-gt" =
id=3D"gmail-:1tr" style=3D"font-size:0.875rem;margin:15px 0px;clear:both;fo=
nt-family:&quot;Google Sans&quot;,Roboto,RobotoDraft,Helvetica,Arial,sans-s=
erif"></div><br class=3D"gmail-Apple-interchange-newline"><br><div class=3D=
"gmail_quote gmail_quote_container"><div dir=3D"ltr" class=3D"gmail_attr">-=
--------- Forwarded message ---------<br>From: <strong class=3D"gmail_sende=
rname" dir=3D"auto">vova tokarev</strong> <span dir=3D"auto">&lt;<a href=3D=
"mailto:vladimirelitokarev@gmail.com">vladimirelitokarev@gmail.com</a>&gt;<=
/span><br>Date: Tue, Jun 16, 2026 at 12:37=E2=80=AFPM<br>Subject: BadBunny:=
 UFFDIO_COPY shmem killpriv bypass leading to local privilege escalation<br=
>To:  &lt;<a href=3D"mailto:security@kernel.org">security@kernel.org</a>&gt=
;<br></div><br><br><div dir=3D"ltr">Hi,<br><br>I found a local privilege es=
calation (BadBunny) in the userfaultfd +<br>shmem subsystems that affects a=
ll Linux kernels from 4.11 to 7.1<br>(every major distribution: Ubuntu, Deb=
ian, Fedora, RHEL, SUSE, Arch,<br>Android, ChromeOS, and any system with CO=
NFIG_USERFAULTFD=3Dy and a<br>tmpfs/shmem mount). <br><br>Two bugs are chai=
ned:<br><br>1. TOCTOU in UFFDIO_COPY retry path (mm/userfaultfd.c):<br>=C2=
=A0 =C2=A0mfill_retry_state_changed() does not re-validate VM_WRITE after<b=
r>=C2=A0 =C2=A0dropping and re-acquiring the mmap lock in mfill_copy_folio_=
retry().<br>=C2=A0 =C2=A0A concurrent mprotect(PROT_READ) installs a writab=
le PTE into a<br>=C2=A0 =C2=A0now-read-only VMA.<br><br>2. Missing killpriv=
 in shmem UFFDIO_COPY (mm/shmem.c):<br>=C2=A0 =C2=A0shmem_mfill_filemap_add=
() adds pages to the shmem page cache<br>=C2=A0 =C2=A0without calling file_=
modified()/killpriv. This preserves SUID/SGID<br>=C2=A0 =C2=A0bits when fil=
e content is replaced via UFFDIO_COPY, unlike normal<br>=C2=A0 =C2=A0write(=
) which strips them.<br><br>NOTE: The killpriv bypass (Bug 2) does not requ=
ire<br>unprivileged userfaultfd and works even with vm.unprivileged_userfau=
ltfd=3D0,<br>since UFFDIO_COPY on shmem is available to any process that ca=
n open<br>a tmpfs file O_RDWR and call userfaultfd with UFFD_USER_MODE_ONLY=
.<br><br>An unprivileged user can replace the content of a SUID-root binary=
 on<br>tmpfs via UFFDIO_COPY while preserving its setuid permission, then<b=
r>execute it to obtain root.<br><br>The attack is deterministic (no timing =
dependency for the killpriv<br>bypass), requires no heap spraying, and bypa=
sses all modern kernel<br>mitigations (KASLR, SMEP, SMAP, CFI, PAC, heap ha=
rdening).<br><br>Affected versions: Linux 4.11+ (since shmem UFFDIO_COPY su=
pport,<br>=C2=A0 =C2=A0 commit 4c27fe4c4c84 &quot;userfaultfd: shmem: add s=
hmem_mcopy_atomic_pte&quot;)<br>Confirmed on: 7.1.0 (aarch64)<br>Affected d=
istros: All major distributions (Ubuntu, Debian, Fedora,<br>=C2=A0 =C2=A0 R=
HEL, SUSE, Arch, Android, ChromeOS) that have CONFIG_USERFAULTFD=3Dy<br>=C2=
=A0 =C2=A0 and tmpfs mounted (virtually all Linux systems)<br><br>Attached =
files:<br>=C2=A0 - bad_bunny.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Full LPE exploit (uid=
=3D1000 to uid=3D0) Build: gcc -static -O2 -pthread<br>=C2=A0 - suidhelper.=
c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 Standalone SUID payload binary Build: gcc -static =
-O2<div>=C2=A0 - uffdio_copy_lpe_report.md =C2=A0 =C2=A0 Detailed writeup w=
ith root cause, reproduction steps, and suggested fix<br>=C2=A0 - badbunny_=
demo.mp4=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0PoC demo clip<br><b=
r>The PoC (bad_bunny.c) sets up a SUID target on tmpfs, drops to<br>uid=3D1=
000, uses UFFDIO_COPY to replace the binary content with<br>suidhelper (whi=
ch does setuid(0) + execve(&quot;/bin/sh&quot;)), and executes<br>it to get=
 uid=3D0 euid=3D0 gid=3D0 egid=3D0. No physical hardware needed.<br><br>Sug=
gested fix: Add file_modified() call in shmem_mfill_filemap_add()<br>to str=
ip SUID/SGID on content modification, matching the normal write<br>path beh=
avior.<br><br>Thank you,<br>Vladimir Tokarev<br></div></div>
</div></div>

--00000000000082e41d065872a32b--

