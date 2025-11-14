Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68FBDCEACD2
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 22:07:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C73948E0021; Fri, 14 Nov 2025 17:07:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C24D08E0005; Fri, 14 Nov 2025 17:07:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B669F8E0021; Fri, 14 Nov 2025 17:07:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A573B8E0005
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 17:07:23 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 52D334D558
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 22:07:23 +0000 (UTC)
X-FDA: 84110599566.23.1D10289
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5C4A510000C
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 22:07:21 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=fJSQ19f4;
	spf=pass (imf14.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763158041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NsPGYF2w3uxO5rL5MOHM8fulZ8/BOxWbrIXWlML1778=;
	b=5f9NQqi4OfGQQq6uhrDHxe/7cDoISl7zZL9Vd9kM+7qzpYWOn9V1Z+VH2FQtULQoNcdFXL
	JHx7OfMqGy1/Fb2bIA9r7L+f7VNgqR5mJRvBx/uDzYPcxcB3R3o5Rdoz2uDb514qSd3Cx0
	fATDuqoGNQtsWD+7VA9CpSZU/0UYB6Q=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=fJSQ19f4;
	spf=pass (imf14.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763158041; a=rsa-sha256;
	cv=none;
	b=y0pEuqDMpj1hYu27VxtpkUiab4dpCitDMVtDk/4mZC/bc0RDjmySOntwi2lfc4yZLxmiY9
	S8YjqrdFybA58DFzxE4+tDiu7s6lPDobURpsGkRSYusS/T5/N9KgegqTLotyI3mHb/w1pZ
	QxbCCvH01kkA7yYDBxzFOF0oUT5w+bk=
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-64080ccf749so3523659a12.2
        for <linux-mm@kvack.org>; Fri, 14 Nov 2025 14:07:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763158040; x=1763762840; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NsPGYF2w3uxO5rL5MOHM8fulZ8/BOxWbrIXWlML1778=;
        b=fJSQ19f4/mPynm3qWtj19ULjDMhNPmqrzxrUP9eHCKktkNkaTAiyIA6Nd4WtTMck40
         Sq1o8BygDjXs8/OW3aAZ1T4487bW3I+1xpU2R6X2E9LX2U8Lh94kgHCOBG6/ncmYjo7G
         UEgQyeGCfMefcobH8z+NMwEqpj8FxDCxu4zGSwtMts7+2PxSoDev7VVTlsOUufW0X7Rp
         6bulIhGmUnbNulp9Gv+QtN5Ac7i4U6eKmthCeJkPxlMvA0NgLQln6jRgjNBCKjujZew3
         wi64zuQg8Vr/l3ZyvzSS4bizHjxBMHR/aFzZDuYFga6sML8jL2VYYDysUj+HCKvC2nTF
         q01g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763158040; x=1763762840;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NsPGYF2w3uxO5rL5MOHM8fulZ8/BOxWbrIXWlML1778=;
        b=sMSqjzielF/Hw8nrRbEpmnm6NlH/lph7/57k5cUlw/TCvRqrv+Up2QzGPdhNJ0MjEV
         JMz6oMHhohoheePI+bVULy5a80w9nO5qvVc06GPRsvgkXhAiVRVvaRpkxPa/Uc7/8EH7
         FPdkZf7Bfj8AjJnrV+urhawPA7GkV62gxvmnmYG/cU9aLXmDlVVxxV5J6gn/qlNIkpYP
         tOkLwqwxcnCoV2CwFm5+9vLOb0w4N6KR6tekYjEBY5laTHoTQSmazpHJx8uExId6y80/
         jDmBUyqM26lZm1r1Yet3pISDxuezSKiID3XQvktN0bU3ErQ9s8iy1QK8c6hXom2uQixB
         i17Q==
X-Forwarded-Encrypted: i=1; AJvYcCWmUCHIuDNkTYiepCuTL+t7pdmsLy9hNkrBBZMx/DNcukxryJCRwZClFLcGaYT0V2r1GvaB5gcQzQ==@kvack.org
X-Gm-Message-State: AOJu0Yy2/9XS5g4qn/J3xSwIubcoq5HAEDGdvq6fzYz/WTgMulVIurU1
	XV51C7PFOPiBiHc4jtC3ady2phRmVUpd1Tf/T1yM3slE2zeAeZO9am2x9Mgig9g2kWjnzNL70jq
	xrmRHtpQUNjb+2rLnOJd496DSP0HxUAundWbPRs3KDA==
X-Gm-Gg: ASbGncuFWpxf9kTZE63aqJYIwXGW8FjGYj+lxCozhuisyabs17ffwKNEHk6ZeCcZpoX
	kGxTVXEMbgVl382pQs3QwnYu+HT3T9ffxZihh0Db4EdWs6lU5m0sl6kqEIbqBkMmEC/NgXbvyZ+
	SVWxwvQH2t9SsCA6QgpQpkV+/7SCrnu9shpc1QHj+5/kvIvOfXcP0VA3crN89WUZ962uoJL4GpH
	BvPEcIx6svG8pL+oZaRUDMEK0hlgTbACBRBeFoPaUx/pswg8V9rj+GvDCxmnrOV/Oh6
X-Google-Smtp-Source: AGHT+IGFFZxrMCPmeJDXNHicMreqnciEQvXQFLNeLQFPskn+jhYADDIQoofuIRZMtOTmH83ub483KykN+dONJWKkP+U=
X-Received: by 2002:a05:6402:2710:b0:640:c454:e9 with SMTP id
 4fb4d7f45d1cf-64350e1120fmr4061156a12.4.1763158039593; Fri, 14 Nov 2025
 14:07:19 -0800 (PST)
MIME-Version: 1.0
References: <20251114190002.3311679-1-pasha.tatashin@soleen.com>
 <20251114134434.5375d085a6bdc1671351f243@linux-foundation.org> <CA+CK2bB2O4Z6iaBMZ8G1paxdH4gywDvVsD6MtxHJW_mtS7hG7Q@mail.gmail.com>
In-Reply-To: <CA+CK2bB2O4Z6iaBMZ8G1paxdH4gywDvVsD6MtxHJW_mtS7hG7Q@mail.gmail.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Fri, 14 Nov 2025 17:06:42 -0500
X-Gm-Features: AWmQ_bmztZ2aQAhXiPYW2w94nYRhCiX3lNmPSLyIjD-mYwCHE5AQJdQs-jg1R5U
Message-ID: <CA+CK2bD4vr2tZpKaGqOZBhP+DMZYYm3EB_0ToyFDduZDMWhXxw@mail.gmail.com>
Subject: Re: [PATCH v2 00/13] kho: simplify state machine and enable dynamic updates
To: Andrew Morton <akpm@linux-foundation.org>
Cc: bhe@redhat.com, rppt@kernel.org, jasonmiu@google.com, arnd@arndb.de, 
	coxu@redhat.com, dave@vasilevsky.ca, ebiggers@google.com, graf@amazon.com, 
	kees@kernel.org, linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 5C4A510000C
X-Stat-Signature: qhstr3j7m9877ga655f9rmmsfonbj5of
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763158041-806992
X-HE-Meta: U2FsdGVkX19Z5FgpPLa7EtN+yqMHkZyMPlV9XnWh6VF45d/cYCDAnJMZvBZFc3gq+VDN3dNGziVirfZMMfHybyaUWKOfTdQInOWk8EfiBcxYGZFMtrlWvhnDhM9wk4GwRqtmeN7EHoipLakm1FdgEgk61gkfNAhjJb3TW1stgK4LN4utta0Fd2G7S6vW2B76GOtrwz9U1jv0Vx4FNImeAE3Irqjnr1Nd4vypozz5SbnyUBtU/5HLc68rOwTgiyiL1qCMbH3peTChMsLu4vJsVUVQNMUdoy2hFj9U+ntuffrOgJ7cGCfItlC7cDokZIwLPYqZHIs/a1XqGm4oOp6Ml7wRX6YMOZBLhTvuiAfoy9T10BeHnW0fCma4JegbVyzfwMaaQBcpqsPjGyEPPnPmR9n/rxPNs+x0uNkwbuVljz0xdNk0jUrdbLrKFCKYhzbz7yZRmg75cTSNz1lMDGlDmfWbqVhE5jnif0mBA9Nk8Jc6UaN5CCs5hqCowG5UEYq6WqEGbvorUyLRgnnDtu0Ou9d3/Ius7DiXquVIzdZpkWOY+d4l2WzYsBEsPqDGrm6lhHUJY7CKRq4OmO+HU9rGTw2F2XtY9tTkg1a0mThxCWQTjzEti66PfQqFdUzXNATAtaGJQYHDYAKvPUgZWI/XlE+fv6hr7Rh6etlegxrgk0IcqSlOg1hUwct8/iqbQeBEJsFi24qP4CyuMUf2G2MGUpL9qMpdmmTXMb90nXFNthrVF3j6dXCXa8sGx+23VMww1d3XOmL6O8bux5AzQwrpxoqNAUte3qfkrRR6BwTCRPYBDmIcs3F2KqdUCWohpvjEMP4J77J9V5O8Ab3/TOMaRrx5V2D/pLJi3rVCE4TF5B5PzWUyRnxnQUzloZgB4ltKU+1TB6pHIPPlHEV4sUZaOhwMSTqfuMQEJNGlCB/NB9x/7M/gfoFgPxHvRPFNbMBxjPwI+Zl2QlFcN4K7D7k
 9bPP5gck
 3ZsqT1axE7rxzFCjyIjBWduYDeJi7or1uek9Fxe2n/c+YXV1R/PV1l6ZJha+1XPBkA6O034VtymXO5bDliYbGlEqy2TACXD5DziwRLK2dGWkf3mHK5z5wVPAoKwpCHhERegr24XgQLWDDA7WDwdRTyyTza/7nX8cCk3JVdYFm1BqnaXylvEkpLPYXeMQ8H8qe2QFiysb7T2v8OeyF+D15Ub/a2CLF4pG/qz/34JFvueQL7i4ewnFqXd6W8wTrJ301T4RltkxKp9NLlJKeSAZvCpIwJxHlZWs4dFtvFLflMU2cH7c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 14, 2025 at 5:00=E2=80=AFPM Pasha Tatashin
<pasha.tatashin@soleen.com> wrote:
>
> On Fri, Nov 14, 2025 at 4:44=E2=80=AFPM Andrew Morton <akpm@linux-foundat=
ion.org> wrote:
> >
> > On Fri, 14 Nov 2025 13:59:49 -0500 Pasha Tatashin <pasha.tatashin@solee=
n.com> wrote:
> >
> > > Andrew: This series applies against mm-nonmm-unstable, but should
> > > go right before LUOv5, i.e. on top of:
> > > "liveupdate: kho: use %pe format specifier for error pointer printing=
"
> > >
> > > Changelog v2:
> > > - Addressed comments from Mike and Pratyush
> > > - Added Review-bys.
> > >
> > > It also replaces the following patches, that once applied should be
> > > dropped from mm-nonmm-unstable:
> > > "liveupdate: kho: when live update add KHO image during kexec load"
> > > "liveupdate: Kconfig: make debugfs optional"
> > > "kho: enable KHO by default"
> > >
> > > This patch series refactors the Kexec Handover subsystem to transitio=
n
> > > from a rigid, state-locked model to a dynamic, re-entrant architectur=
e.
> > > It also introduces usability improvements.
> >
> > OK.

Also, with this series, kho_unpreserve_folio() returns void, and LUOv5
requires two small fixes where this function is used:

1. fixup for mm: "memfd_luo: allow preserving memfd"
diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
index e366de627264..ba435590d2cf 100644
--- a/mm/memfd_luo.c
+++ b/mm/memfd_luo.c
@@ -138,7 +138,7 @@ static struct memfd_luo_folio_ser
*memfd_luo_preserve_folios(struct file *file,
 err_unpreserve:
        i--;
        for (; i >=3D 0; i--)
-               WARN_ON_ONCE(kho_unpreserve_folio(folios[i]));
+               kho_unpreserve_folio(folios[i]);
        vfree(pfolios);
 err_unpin:
        unpin_folios(folios, nr_folios);
@@ -170,7 +170,7 @@ static void memfd_luo_unpreserve_folios(void *fdt,
struct memfd_luo_folio_ser *p

                folio =3D pfn_folio(PRESERVED_FOLIO_PFN(pfolio->foliodesc))=
;

-               WARN_ON_ONCE(kho_unpreserve_folio(folio));
+               kho_unpreserve_folio(folio);
                unpin_folio(folio);
        }

2. Fixup for liveupdate: luo_core: integrate with KHO:

diff --git a/kernel/liveupdate/luo_core.c b/kernel/liveupdate/luo_core.c
index 29a094ee225c..f0bc3ee0a10b 100644
--- a/kernel/liveupdate/luo_core.c
+++ b/kernel/liveupdate/luo_core.c
@@ -305,7 +305,7 @@ void luo_free_unpreserve(void *mem, size_t size)
                return;

        folio =3D virt_to_folio(mem);
-       WARN_ON_ONCE(kho_unpreserve_folio(folio));
+       kho_unpreserve_folio(folio);
        folio_put(folio);
 }


> >
> > Where are we with the series "Live Update Orchestrator, v5"?
>
> I am working on LUOv6, it is going to be an incremental update with
> much smaller delta compared to v4->v5, addressing all the comments
> collected so far. I plan to send it out this weekend.
>
> Thank you,
> Pasha
>
> > I'm seeing a couple of review comments which I plan to circle back on:
> >
> > https://lkml.kernel.org/r/aROZi043lxtegqWE@kernel.org
> > https://lkml.kernel.org/r/mafs0ms4tajcs.fsf@kernel.org
> > and a comment from yourself against
> > liveupdate-luo_core-integrate-with-kho.patch which indicates that you
> > plan to update that patch?

