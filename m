Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36336106B53C
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 13:44:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D8EF6B0092; Wed, 25 Mar 2026 09:44:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 889716B0093; Wed, 25 Mar 2026 09:44:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79FDF6B0095; Wed, 25 Mar 2026 09:44:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6B5956B0092
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:44:16 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 175838C704
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 13:44:16 +0000 (UTC)
X-FDA: 84584704512.17.5C9313F
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0B1C218000E
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 13:44:13 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=UfIDY7G3;
	spf=pass (imf06.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774446254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TapOjIwj1TsGSLZK0gfpvDJXqGAOWqxpwVwmgsAXV/Q=;
	b=4TmNsFArUIF4o3Dk9GmkuT+ZzVWHzQVXlYRPoC6fypK6ddOMncb72kp0c+zco6BpwQ7Lmn
	WY+dKk7N1tHAu737H/+97Iv4XWzroJntT2n//wHInR2xJ5RfFfT/4aFSBAC68IvGuD88RZ
	NCM39pdwtCsg0AZDz2C2TjjGgD6SfWc=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=UfIDY7G3;
	spf=pass (imf06.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774446254; a=rsa-sha256;
	cv=pass;
	b=ETmLrj/zp4Hh+Kny1SYQMP2+aP/5xiNy4BKwCU8eqKjM//gHUH1JcHYTfzN31+pbQbCEBM
	lSHr11HrhybzbxUimMBY5zDNGZ2N65ad56gfU3OlEZ/G5y9rlEqYXP+FmWoEJ3crTqXfqq
	vUFtJ/wmtfDNkaHIe29vv8DyooSWDWY=
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6694d00e01bso4614990a12.3
        for <linux-mm@kvack.org>; Wed, 25 Mar 2026 06:44:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774446252; cv=none;
        d=google.com; s=arc-20240605;
        b=isRvY6um5BwN+ysGVVuPqYKzOy6BIm8gKvxFREm91KQ2gWdF2oMFKxCCDK8C0NgIsC
         hMXjGadlqxcv36O+ocADVJ0sK9YYxaDp9elwTD++n6YbSZpYsuMAFW80aX90VnhZ3QT6
         SFuYfn4UIMLye59M1yiRg9V4hLSbgNdEx7E4vDbizAyHam5VRFY3iZ5TZxuzUWCnIrIV
         P65Z0Ep4SUA0AXKvMhGBVdpXjkBAghQFnNvVM/mFU+XoSvZUfFxsbhVdvHSPhCisucH2
         /vNCyL52uNHivuz62m0zwmVOdImVOlkRNEP6LErixuggemyrH9yz6h2NRGJnfAlbk0UB
         AW8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=TapOjIwj1TsGSLZK0gfpvDJXqGAOWqxpwVwmgsAXV/Q=;
        fh=cEM3bzwBYgvR0+wT10DviUnghqFpCHzKJxftZ+QragY=;
        b=MdN2slfLXiMrajPY8TGS5/BolOePKSU7SDk2jrXd5K8Lf3p9hO9G8j+B1GBBnaAV3k
         55cXd60hZ2bbPhX344y0+cd2/GMqSMRC7gZMlwJPO0U+0Ud6ZHIxzixbefC2YgzSLDSZ
         5tYAYsle53iQVtcyy74u4+0rhABe8qyP6JC/3m1b9+Zsmsg1pnnHiQOyOyFSpwNrPHLQ
         z1R8OXDegOybiTotNuD/xTtvXGVjRfsCFmKiDvZGwQoPuSzu63zcf2jlTIs/YXdOLWp0
         KwcDqWyX7KlP/3FfvAYbjDXVHc4JhkuNMZRMRZC1s78BRy6dYo9JATE9gZZ4uy6hcLuT
         jxoA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1774446252; x=1775051052; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TapOjIwj1TsGSLZK0gfpvDJXqGAOWqxpwVwmgsAXV/Q=;
        b=UfIDY7G3phoOZ/uPTJqRsXQQmPaEQpAvuP3z6RbtnwErWz/cSXoBP7mfX4iqs0RUee
         kbTdo0KLyOpjCaSMuPdFDdlbiH+I5kotRVDNNYLCwcYfBZfbEbentu+bIXhelTKtjzwp
         TjJ5deOJiRWTxW/8Fd/BeubMafPZQjEwtSE9jiUSs4DV7cyO5/hS7WSVViORlFHAaBS4
         btY/P3H+8PlJHA2q4614yuTBhJN+fBqceg5c2P5Muhak2p8hgQxsWSRS3dgakWMrfZ1A
         USYSs7lr6nbaL3K6k67mN0cPISu+8YKF43/u7/QANjsZseoXo6WhPGPeo0iqUIb6/VVr
         CCTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774446252; x=1775051052;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TapOjIwj1TsGSLZK0gfpvDJXqGAOWqxpwVwmgsAXV/Q=;
        b=RpvZLhihtdH4qmnLLc+SYKrQa0j1NdyhTmjlBNR7MhI81AIsApqZry7A43qR+w12dk
         Ecu+u9bEo562+aQaroCPSJOjsZrDLXbd7F3MRXBvRsBFpNSebVU2Jg1JBtSgpNfFRz+7
         ii68bJHG4Dba9qpIs/vWypkib2FASFNQXuV0He6uiNJKX8bIBZtN033x3/sWblRKWDNS
         e+o3ECS4bCbMw+ehIbvnKYht6S8xDkrdIMHmxYUCogXKJp9KE+VtYTPeH4az4F/PO3Xr
         TUcdfU03kGj0vqqTIrcY212TtMgjx0SXPWDhhWnW4FtsyOsYmrixxEFMA9NF762JVtKv
         Y60Q==
X-Forwarded-Encrypted: i=1; AJvYcCU7YTqHNRpVLxiX4CDcazDI+UKw2cWfreK9e3ujJn8tTZAtS2WOKOHEO3nMzaJP/1dLbWPfIgf8gQ==@kvack.org
X-Gm-Message-State: AOJu0YzxbluqxA9Y/OQkYfaokU5PsCqmcV+e42FW5e1dp0mE0kUweac0
	lP0+No2y/Yy9fXukZDPrRPgRn7+G4iY5w3EDZUkLaoQ5Rt15L9s+sqz4xixYMRJLzujpm6kIYY4
	VyEPnE+jGCa3Y8dlbpch6W94gMP8mQmKzr+BoFOJrJqZKB4AvMVe6
X-Gm-Gg: ATEYQzze/c8/lpzDU0EhetZ2RkVYbEx7unqGyDqHk3wdeTxI3o9ugNuiKz9sYnFE1fJ
	NwbNoq7yiHj3etR5tody+0xN398b34QehSWWfe1C4JFYXLsjFZ5qtfl9CKqPPiGgNZ7bpAvoR0M
	FKz+5Mcc98+LVkI5vEW8Zr0rVC60zuipv/edBla2ms3BpzIrpxsmM5rpM2r73DtZUVpWAEJ668d
	yvMBfK6sW0Y4+97pXE+yuFJIqm/rBsOiCK1IXQB10ejmAq2NMty6vHrJP2Z0lzIIpTPOQpmlnys
	SOTvB5bOLBQLtjCprpqKaQVuwktzyOKMYiIWbw==
X-Received: by 2002:a05:6402:a0c9:b0:665:f31:3197 with SMTP id
 4fb4d7f45d1cf-66a82618799mr2159634a12.1.1774446252549; Wed, 25 Mar 2026
 06:44:12 -0700 (PDT)
MIME-Version: 1.0
References: <20260318141637.1870220-10-pasha.tatashin@soleen.com>
 <20260318141637.1870220-13-pasha.tatashin@soleen.com> <CALzav=fhwP1Wv9YjFTXoinX7R3rX-P0igvLbftBh+sZrL3dySg@mail.gmail.com>
 <CA+CK2bCU=4XQQJ_-3HrhbENBNWoDf=ZzHpp66nZaPxGUAU=U9g@mail.gmail.com> <CALzav=eGYJAFH+yhoMH76rM3U8L-_H12=UsvaN1v8hgn8BPhiQ@mail.gmail.com>
In-Reply-To: <CALzav=eGYJAFH+yhoMH76rM3U8L-_H12=UsvaN1v8hgn8BPhiQ@mail.gmail.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Wed, 25 Mar 2026 09:43:36 -0400
X-Gm-Features: AQROBzCGVro8mnRJ-PwPD4HmmgP9vCHLR9Lg_vIGgZGsGCUNHj1erJVQBcgghtU
Message-ID: <CA+CK2bBnob53mGx_Pbxn+hp7R2mm63kA_H=AFkNu5UfB_8aO4w@mail.gmail.com>
Subject: Re: [PATCH v2 3/8] liveupdate: Remove file handler module refcounting
To: David Matlack <dmatlack@google.com>
Cc: rppt@kernel.org, akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, pratyush@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 0B1C218000E
X-Stat-Signature: 1zhtoyymzod5ugnjrajgga58fynechhn
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774446253-529692
X-HE-Meta: U2FsdGVkX1+0CVEIwLJjq8y8+yINpCzKz8BNxcNyktuu4E15U67LfDMuWzOzzmLnECnc8U/xvED6eAeF9ehv2McOoibGON2CIXwUjvRvicOtlKdTp4B0GTERD3KGCAgf+MwG3je92HWsZajiYvfXQ5fgh3ae9U7A2woSnRrug3Flkindsc7X4yXESrLFv81zp3nzIN1qAkPmQuJa4edBnt8e3WkxyY8Woxs27sdBApK7LQ9mVP89Fok2r0t/zJMiVvy52wV9KskZfyCLVfCLsKkLI04bh6g7sCcRTD4NjqnYzvF1YeJeXwp+0vu/M4jMNLc1YoDQPRDDhMMBhsmetlSp7gfGbxul6yXpExgTeEOlGRC9xnv9jC03HsG79StLFqWnCZcjbSXguTh1JbZiyGi/Rz1a3/uQBcA5Lppdcsqcm+QqdwBAKFyCptbIX8AYeD4h7Ku93pzUSH/Fl88KE1QDOZR26lwUnDo3HGAwM39WcRgaevYDdkSevwL0w876180kWTv8w5t/LIsJ3E/0qadxAgJPbTTMwTMLcBauQQduvMTCMgGlHFy8Etfjs3eQuXbP6s4vCTvvTLiINiABe1Q94wNTitpRMu5C1ICw0YmctbDaEgspAdfzGzFM7+1+BXc4htCfmtniLp8QBXo07JI8V6z6Ule9/kwmMTtVbJTPcUnlOImRjgMzdMzQ/E4O2t7fg+Uq9Jj3aqhrnFP/MOhhL25UODo8oXLIJ0A7SMLrWuckKYQ3fML0ssa5h/+cMaBoS243Dbl5EbJPUUOGllaLbDA5gWLwYxJDNkWROeL0DhZ/qcQ6KBsijvUgoWF19pv0H/WXYbhgjulsQ19Vi7cY/fBOOJAtk7uL7zshkliCeU89v3GGHDRMOb7KQj/cruTXCLSlY++VJ3k+9hspywsINptmziQuwpL98zBbgxv2uxKu2FGdmk2jZsm6gAj3EXVwoZbwUSy/xDUdpFY
 zL8gx38y
 /UH8SZ78LEY+b78r+cu49HhohIhYcgknQ7dLbDNTvLmnwu+0FBKOgPKVGzn2RIhVK1fIBJPNDYaJTO+kuu/VYTY2F5tk2vnFjlNnBHl1Hi5OCVrDiIN9QZER8XjWd4AxrlZGrnffb5g/BdnihPsorFYhRtL84oFNi+9duAOUXF+bEhtlZv5ULd97c5ag4eNh7pkrIjnB6IoKVBAt0GA5Utu1hxWkT0IDRYcjSX0LR5T4s5ugeh4R3dzNJYtP9/zc+m7NynRuiKJlcyewSg3LcX6Fad8fgxmGTK3gxcMJWKuWlhmtSiJ1EzQPZCfaPHpJXiklT2sfM9GIj9xMVI4Ly5U3Xxg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 9:15=E2=80=AFAM David Matlack <dmatlack@google.com>=
 wrote:
>
> On Tue, Mar 24, 2026 at 7:49=E2=80=AFPM Pasha Tatashin
> <pasha.tatashin@soleen.com> wrote:
> >
> > On Tue, Mar 24, 2026 at 5:24=E2=80=AFPM David Matlack <dmatlack@google.=
com> wrote:
> > >
> > > On Wed, Mar 18, 2026 at 7:17=E2=80=AFAM Pasha Tatashin
> > > <pasha.tatashin@soleen.com> wrote:
> > > >
> > > > File handlers do not need to pin modules indefinitely or during act=
ive
> > > > live update sessions. The VFS 'struct file' pins the file handler's=
 module
> > > > via f_op->owner during active sessions, making dynamic reference co=
unting
> > > > unnecessary for handlers.
> > > >
> > > > When a file is preserved, the live update core obtains a 'struct fi=
le'
> > > > via fdget(). As long as the file is kept open within the live updat=
e
> > > > session, the module is pinned by the VFS and cannot be unloaded.
> > >
> > > After invoking the file handler's retrieve(), LUO should probably
> > > check that the created file's owner matches the file handler's owner,
> > > since this scheme relies on that being true.
> > >
> > > If there is a mismatch, LUO can put the file that was just created,
> > > log a warning, and return an error up to the user.
> >
> > Is there a reason why taking a file handler module reference is
> > problematic for vfio or iommu? Could we take it while files are
> > present in incoming or outgoing sessions? Overall, it is because it
> > cover corener cases such as if the file struct owner is the same as
> > LUO file handler and also this approach covers the deserialziation
> > side nicely.
>
> I see no problem with LUO taking a reference to the file handle module
> owner while a file associated with it is preserved in an incoming or
> outgoing session.
>
> And I realized that VFIO can have different owners for the file (vfio
> module) and file handler (vfio-pci module), as it is currently
> implemented. It should still be safe to rely on the file reference,
> but explicitly taking a reference to the file handler would be simpler
> to reason about. So I am ok with going back to what you had in v1 [1].

Great, I will include this in v3, together with Sami's suggestion for
lock simplifications.

Pasha

>
> [1] https://lore.kernel.org/lkml/20260317025049.494931-4-pasha.tatashin@s=
oleen.com/

