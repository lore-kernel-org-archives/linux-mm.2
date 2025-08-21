Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97E57CA0EFA
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 17:56:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A58B46B00A9; Thu, 21 Aug 2025 13:56:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A306E6B00B2; Thu, 21 Aug 2025 13:56:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 946506B00D1; Thu, 21 Aug 2025 13:56:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 814266B00A9
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 13:56:18 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3105E117DA9
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 17:56:18 +0000 (UTC)
X-FDA: 83801518836.10.7BF4CDD
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3FFBBC0015
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 17:56:16 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=2FPR+GiC;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=lokeshgidra@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755798976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7OaNKB4ZUL7yid73jmJTsnRphjsenr0Bd6ivArlhGHc=;
	b=EHXKOPA4xebMemzv5PKATa+/Z+nwHUQzczosx7Es0S9QDYIxvL7mG8G6V0SSHCn5ZWIJl5
	hQFawqYzX1NgCk6oslSSMnecacOxYQHFHH9SCFamGUnMRtvhjZrO+dDnX+OYN73CXHPpPc
	Gh4YX3KWeoEzl6xDMUTSJRdOKaPl0Hs=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=2FPR+GiC;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=lokeshgidra@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755798976; a=rsa-sha256;
	cv=none;
	b=BHLoBLI52FsEXbt3WPm0Asbm0McLwPoLoOByvoXplu4xpAfwfQLJagrqpbhiPw3DJWKoN1
	sCZuOZM1GTO+Xfhl0jnuvadolEvAWHTDz8XYwDHlfDFEc86RLLXT/AUDvETCXBB6rT/GyZ
	WgL1MaDDpY1AjjDkNUtfwBi/qhnsZEg=
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-618076f9545so1154a12.1
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 10:56:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755798974; x=1756403774; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7OaNKB4ZUL7yid73jmJTsnRphjsenr0Bd6ivArlhGHc=;
        b=2FPR+GiCmNO09eDJieFUDdOhOvRiVbpEMtpsYbI9OXgNh1G4UqZgJqEhYFfJVwKMWC
         1acRqh4+iRDQuPl8SaJT0y4PiXU/3k9vqV/NzlPNAKNpY+Q7e0WeY0ShCXQnJlZdMf6i
         5nbJfeB9SlDeBGwJCXFMHW4QrqVntMTzCKzBX12vCvH0LNOv2FhlSaaf1fF3owyEfLk1
         IIHNeXf1Q2WrX28ex0NU1+ksX+qZmjdRzdrUO3GMXxUkTCeURWhOInYL2y+etkJ8hTHL
         RsVLcJU4pikppXN3AaJLpi5/yBs2NyHnu9t9Z+EC7wlkuBZnmXvaA757dWzMcE2/pOjM
         MR6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755798974; x=1756403774;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7OaNKB4ZUL7yid73jmJTsnRphjsenr0Bd6ivArlhGHc=;
        b=jc1T4+ZH+7FPwBqAmV0sxEjeyZhS+4jSqx2JFKa4iuB/tq/BU+slMeZ+zl9hOvW8H7
         NAvh6qg1ptc34hTp+4XxFEmdQ0cxc32QGNYB3N2RzqXfn3iUkT7cNToiWHEOrK13giKB
         yWZFNq2XUFvLPEajaRHc7PRgd3RxcS2F8jNp2RelSt1oXfCa/3e2HY+AcGCgOTO+yiKL
         Ys+fiA4ezYQd1409yndy5hMUHwLq4JpfNtKVwYD0thi45aZQ/4Hkco9Ox3/jmfiYSQWi
         bAaKx+RAVJ0tO41DrSJWiVeeQwh6PXCXtimWV3z6cMYX+rLVN7hKHsDWdHvD6DcbUai3
         NH3w==
X-Forwarded-Encrypted: i=1; AJvYcCWp7OQnd66bkLa2eB5CS2rSLhK/fgdNvQXBefz3uuRBehNojPzVeHhhLtnmyNCbo8Kmaj8tfy6G/g==@kvack.org
X-Gm-Message-State: AOJu0YwH7oAjlB6CJmLsY2dRX1ct0wrPPK2RHsh3y+8VldNB29PlBi4A
	N1qMqmL/3QGR24ZrxJNPWlDnJGLLBNL+2X0fIii+mjrIdt39h9l0hgzghytCoXvKdHvIUn7kzbO
	DCVhOCfvcx+LqIThwi06VvavP41HfgVb+N0dRz7VR
X-Gm-Gg: ASbGncvAj6rM6fL4kUGDoroCMUkwNEZomsk+gIxfK98sD7aRTv1WFzNh5QYJ9mzVJ1x
	GhZHBTQ7yyAaPLasLm6bZqsW76/es/7v0vd6qBzLXAHsfgFhRjm2p/6H3xEhFb3FWCJ3//omSnq
	QHyUIOaYwsGHHkHrXxfMaKGz6LeUJ1JleGvUY1+kQpZq1SL9gqbO4ZiEy3KbKfN2Bu/Dk6OTM3n
	Bos9XT522zJGTD+20GkhJrjKUzi4D16ygKnjr8LO8UlNHJsu+HN6oo=
X-Google-Smtp-Source: AGHT+IFVRVvBfVGiJbFfaLa/SK3Cvgemy51aTnB6Yc4MQ127iC8/HJ5Is7jFT8FdwiTWxhYGMok8W/PgES6NTiKSXRQ=
X-Received: by 2002:aa7:c717:0:b0:618:8198:de66 with SMTP id
 4fb4d7f45d1cf-61c1a3a823dmr2524a12.2.1755798974364; Thu, 21 Aug 2025 10:56:14
 -0700 (PDT)
MIME-Version: 1.0
References: <CA+EESO6dR5=4zaecmYqQqOX4702wwGSTX=4+Ani_Q9+o+WUnQA@mail.gmail.com>
 <CA+EESO6iqowMAOnBPJjERqZym_qvd6kx8BDMQG8+3xQSrNFytw@mail.gmail.com>
 <CAGsJ_4xccre0rz5zgRTA=NbFzF4FLS-ZUohgLFnfTGY9Jdequg@mail.gmail.com> <3133F0B4-4684-4EC7-81FC-BC12A430E4C2@nvidia.com>
In-Reply-To: <3133F0B4-4684-4EC7-81FC-BC12A430E4C2@nvidia.com>
From: Lokesh Gidra <lokeshgidra@google.com>
Date: Thu, 21 Aug 2025 10:56:02 -0700
X-Gm-Features: Ac12FXw91HcIA-HfMpgbMbkQ0W-eNhyjVh_auRuyvKiToz0-CS0TI7_uW_klo84
Message-ID: <CA+EESO7_-64GU5v1FTMXbemQixPX+xo6SGm8r0txohZJLs97cA@mail.gmail.com>
Subject: Re: [RFC] Unconditionally lock folios when calling rmap_walk()
To: Zi Yan <ziy@nvidia.com>
Cc: Barry Song <21cnbao@gmail.com>, "open list:MEMORY MANAGEMENT" <linux-mm@kvack.org>, Peter Xu <peterx@redhat.com>, 
	David Hildenbrand <david@redhat.com>, Suren Baghdasaryan <surenb@google.com>, 
	Kalesh Singh <kaleshsingh@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	android-mm <android-mm@google.com>, linux-kernel <linux-kernel@vger.kernel.org>, 
	Jann Horn <jannh@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3FFBBC0015
X-Stat-Signature: dkm6apmcy67z1zumgbwch6ome6t5bcfu
X-Rspam-User: 
X-HE-Tag: 1755798976-218493
X-HE-Meta: U2FsdGVkX193lCAJrIihQzfoFDjiHMM7cpFU1c12HxZ9r5qp0W0eXub+prVKyshWgEfN29iO271k9kI8jQZWBSFpZH9j2P/6HSaPGS6fR8fG5Xs2fPT1vCAeR6MePV3REIBAtOrn36FIFjHd9UgHWQrXUSjhQooN9ode5jI8goTtJR6MmwUTYtJB26xRdqWTD3tThH5RE/hqdVE4XFJu8CCEGtIXgpPiUKyBB7N5x4wHA5RxnERNfeO3/2fc7rcfhRrx9QOpalOJTcCe2M3IpJqK+qNMqnV+LM+waTf9LXYihkp/voM5MyvQ5Dbl3s9QQtE/zD7UI5G/PsaJkNn2fWNCBm/8wvG2V4XEVzpzuO8FNIVi0FMwdX0SWzGgDk59U90y5Q4QEQ3RYq/V/rLZZ7OxZ4pxuNrKRW7IiWVBvspZDZ59U/q21zx2JliywqyXEl1EGnBD2D3Al34zUNHrC+cqg7GFS8PgQLLPu46XoPAmXjSvLl5pVH+VUoOQ7QisiOo68hbfebw3arWnQxY4rSCmabyu7FhiZkC6RVWYyyTTg5RcUUuBlLAVkVzWDQ+BHREVf9zU8KbRUZJRSMVjJiRuR0EGYlL+PDBMFoe4HksJBFcMM57blEOPaErRxpQVlWt1807yotgPJt7TKa5st7u/ovXDh+MeZgjZ11e/l4be61py2Ubh2JBobd/PLv5V6Uj0lOSs7Rqq8vSZ3bBabgdks9J1Hz5Ggkk1U66g9Nvxa+ORwvmLXYKWQ8eIO1ru7SNoyCAD8Lt3SR25hWeFdwPWEMiK8msc03afqB1mxQW01xgor2yeEvt6sHnUE4YA7MWt9h8NrBR5JmNImMvy8Clr6M2L3CscL04oz2HbcdCzL8A3iYr81FfuT2Lj5VWkVrqAWEBRc54gXv9u/kuLEhnvjsXAcjtYfqzi60hFsRjGS1wuuk8RH04X416nTVbqjtVLykXD3i5BdygESqs
 V13YASXZ
 +4i13Rjjk1nAeqj4IPDHoru0Q5LLx7fadX6CsSTZa+GFcduX2N0/1TpMY1IDD7aZzcM/qAOl5vc+6fJg12svM+31FIJyUQEPt/Tq5CeuHs+Ccb8zjeJWmiCqi8NVbxdpKi0hrgeDuoXOAo2fHH7ejkTWk10mhqSNbnF0jvReA/C4LcElHnlbQs6+nFjQs8UlA9KBvDPnNDkwp5pNgTRJi+HoZOnEy02RYB/vduFXlRuikOxq7PxwOGgK+HAxiKmWxCmf/B9RLudrPHVhLI8A8XssyMA4teZ32EZrF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

 (

On Thu, Aug 21, 2025 at 9:14=E2=80=AFAM Zi Yan <ziy@nvidia.com> wrote:
>
> On 21 Aug 2025, at 8:01, Barry Song wrote:
>
> > On Thu, Aug 21, 2025 at 12:29=E2=80=AFPM Lokesh Gidra <lokeshgidra@goog=
le.com> wrote:
> >>
> >> Adding linux-mm mailing list. Mistakenly used the wrong email address.
> >>
> >> On Wed, Aug 20, 2025 at 9:23=E2=80=AFPM Lokesh Gidra <lokeshgidra@goog=
le.com> wrote:
> >>>
> >>> Hi all,
> >>>
> >>> Currently, some callers of rmap_walk() conditionally avoid try-lockin=
g
> >>> non-ksm anon folios. This necessitates serialization through anon_vma
> >>> write-lock when folio->mapping and/or folio->index (fields involved i=
n
> >>> rmap_walk()) are to be updated. This hurts scalability due to coarse
> >>> granularity of the lock. For instance, when multiple threads invoke
> >>> userfaultfd=E2=80=99s MOVE ioctl simultaneously to move distinct page=
s from
> >>> the same src VMA, they all contend for the corresponding anon_vma=E2=
=80=99s
> >>> lock. Field traces for arm64 android devices reveal over 30ms of
> >>> uninterruptible sleep in the main UI thread, leading to janky user
> >>> interactions.
> >>>
> >>> Among all rmap_walk() callers that don=E2=80=99t lock anon folios,
> >>> folio_referenced() is the most critical (others are
> >>> page_idle_clear_pte_refs(), damon_folio_young(), and
> >>> damon_folio_mkold()). The relevant code in folio_referenced() is:
> >>>
> >>> if (!is_locked && (!folio_test_anon(folio) || folio_test_ksm(folio)))=
 {
> >>>         we_locked =3D folio_trylock(folio);
> >>>         if (!we_locked)
> >>>                 return 1;
> >>> }
>
> This seems to be legacy code from commit 5ad6468801d2 ("ksm: let shared p=
ages be
> swappable"). From the commit log, the lock is used to protect KSM stable
> tree from concurrent modification.
>
It seems like the conditional locking of file page/folio was added in
a 2004 commit  edcc56dc6a7c758c ("maplock: kill page_map_lock"). Later
in the commit you mentioned locking was also added for KSM, and now
only non-KSM anon folios are left :-)

> >>>
> >>> It=E2=80=99s unclear why locking anon_vma (when updating folio->mappi=
ng) is
> >>> beneficial over locking the folio here. It=E2=80=99s in the reclaim p=
ath, so
> >>> should not be a critical path that necessitates some special
> >>> treatment, unless I=E2=80=99m missing something.
>
> The decision was made before the first git commit 1da177e4c3f4 based on
> git history. Maybe it is time to revisit it and improve it.
>
>
> >>>
> >>> Therefore, I propose simplifying the locking mechanism by
> >>> unconditionally try-locking the folio in such cases. This helps avoid
> >>> locking anon_vma when updating folio->mapping, which, for instance,
> >>> will help eliminate the uninterruptible sleep observed in the field
> >>> traces mentioned earlier. Furthermore, it enables us to simplify the
> >>> code in folio_lock_anon_vma_read() by removing the re-check to ensure
> >>> that the field hasn=E2=80=99t changed under us.
> >
> > Thanks, I=E2=80=99m personally quite interested in this topic and will =
take a
> > closer look as well. Beyond this one userfaultfd move, we=E2=80=99ve ob=
served
> > severe anon_vma lock contention between fork, unmap (process exit), and
> > memory reclamation. This has caused noticeable UI stutters, especially
> > when many VMAs share the same anon_vma root.
> >
> > Thanks
> > Barry
>
>
> --
> Best Regards,
> Yan, Zi

