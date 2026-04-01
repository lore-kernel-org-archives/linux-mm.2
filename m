Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1696D35157
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 08:06:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C39A26B0005; Wed,  1 Apr 2026 04:06:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC3776B0088; Wed,  1 Apr 2026 04:06:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8ABD6B0089; Wed,  1 Apr 2026 04:06:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 933B56B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 04:06:53 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F41318C0F2
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 08:06:52 +0000 (UTC)
X-FDA: 84609255906.29.0C6D548
Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
	by imf09.hostedemail.com (Postfix) with ESMTP id 25A95140007
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 08:06:50 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="YfDS+/IV";
	spf=pass (imf09.hostedemail.com: domain of devnexen@gmail.com designates 209.85.160.54 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="YfDS+/IV";
	spf=pass (imf09.hostedemail.com: domain of devnexen@gmail.com designates 209.85.160.54 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775030811; a=rsa-sha256;
	cv=pass;
	b=kg7wANHBa7+sZZzMfNgq9HWKCpImuzDoKNLcNFvynu/7TxZseHbId40FQeK2W6JlIbgv5G
	G1jwbmI+mLtYZJo7HCAU2G7jqfTqktVxFjCkzlthCvbI9IOIXViO8ZxqFvVzUtbFXK/huG
	kdVMeKPp0dQyqSkWJEOGUZwm1ueFkF4=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775030811;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+PyYJugKs3rrQS2rBLgo7U7gDQ88tBzfe12MYvvk/lY=;
	b=O4rAmHrzqW7EFd2+Q1jvXvcnaeBCpVH6yVfPSdthcoW9BOvqbjKNLirBn3QLOEDoUjnChg
	7h2rg5t3ZJYoyHrtRlW+XVQHLmLWNDAZYjMvthPyoQvo5tUfM9YIbj0ooMsX2pOZwYhpXb
	MeKqU6xGOb8dk9d68gI/eObrAx6qKZU=
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-41576c5c01cso4204365fac.3
        for <linux-mm@kvack.org>; Wed, 01 Apr 2026 01:06:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775030810; cv=none;
        d=google.com; s=arc-20240605;
        b=jIkuQL690G4UB/D+lWQHy45+SstVm86NwaA8xOsu98AzZJh+3GjobWsgsibG5uVTPQ
         ZrallMOJx8YzwzqxErzVl29vmk8HS7bNDGoyhFvUvWUJYxX1llS9jYz5tN8YEtcciRrR
         x9xBlVIBWse6Nusu/l820py5IBEFMNAoBTJPkqJ7qubQHhcvgYlDG4QJYd88/k+SIypt
         Pw4P+UTJwPBns9DCmBo2tugBnZRkJYgOE4TVVEXkACRj/3kR/L3Jmlk5kmqGc5Y69Dh2
         6Rq/6VPePkhjXCEKIPZiFBwHcF+IDqJTz5PE8jMUT74wVHQKk/BDDc+DHReMVgB6FGY/
         VE2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+PyYJugKs3rrQS2rBLgo7U7gDQ88tBzfe12MYvvk/lY=;
        fh=SE2g8xK1QAVNV5r43wM6LsI82r9ymCW2zR11ShlrZqI=;
        b=VAfOhmvbmdjL9pspwSEvnw1hnBEYGKcSS8seHYDma7YsfxkAyQ+Be1DvciYGfpwv4O
         t9T3L5zUTwtVrNtI6ppdiXZKyStBnOBddVpH4YIBRSWjL19y6Ok+OcbZN3BUazJrnd7r
         CCpadE5K5Jg4sb0+XEZPY5fDJ+Mt4bQT+E31HscO6mlMViY9EKPFqTO+QRObIIFP+uya
         61l5JWPPZaelhWr26lOcMSEf9GOMBRvAeoLSLwEbh/F2utXmVnxTLlibim7SH4Z7HvNa
         5B74MFIiP166NjeXz1KNYFurFc5Gp0uTB3Gz1j2miKmA753/yE7r6VakLb3Z66KNEcwl
         4Orw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775030810; x=1775635610; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+PyYJugKs3rrQS2rBLgo7U7gDQ88tBzfe12MYvvk/lY=;
        b=YfDS+/IV7Zb+1ixWSuK2MLD8STknOYqBzEIbfcm+8CBNTkjK7DS/PqXDBL0hrkaldb
         4BdMgZnLdmrYQhfF8gtYUqsQxHbhyCSVitYDHUEjQcWHHetWPKt3B+dL3xgrRR5CLLUx
         qZ0hvSkMLUpi423yniZWRhCJUsDi5g8TaAnxSWGcjAhp9vreBdj3HMSKIlPs86+KP/Gu
         0jaYEkKHipFYmw8HXrTvxJTUFZtQ8BbR9QpX9oGYAfm+gq6LePxZ4cIUHc4Zp9TwpAus
         gXB4mnPpoT5z6l4zQ5jfsdk1VUk2UxlTUQoK75bQ8wwiKWVvDLzQw874xUmxLN2Tis9A
         exow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775030810; x=1775635610;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+PyYJugKs3rrQS2rBLgo7U7gDQ88tBzfe12MYvvk/lY=;
        b=hmwqucw1gQ7SNEROTl4BiwbrMChHusRjfqn5ywksVvrDxs2M0YNQi1uhCnfWpsCQuY
         83GYuESZwq+jDexOZty4gbRqRT96RIQFBrx/ExxknLhUZiZY4lR7rMFeDC4J8C5sa8gI
         IhMl6HRRCWCyVZpoyWFQK9gRmlcmfO5OIK27UGIHPzdb1B792zmot73Wyd7sbeWhgeO1
         m39f4Mf7QXeHaYyf7ef9ytJOsCotKGRL6egQuvnZapfzSnRp7ZLugW8HbkldmJajz/PY
         pbyqfItGyVGF5WDfT7+B2x8BANmpWvs/G9ACDGB8Ts03tDlgrdHjbtBNRUJeqQRtZOwG
         QWwA==
X-Forwarded-Encrypted: i=1; AJvYcCVPL8pDm31EcuePMUXuoDmhPbrap2RYDCqv88w1HRLMTwDrT01PXgipMb5QGg/uJwd0efECdgSZoA==@kvack.org
X-Gm-Message-State: AOJu0YyTWUb1ygcuja3NZnaJamYua+PcvNxJbNlJtgk3bYUIDHsumkXG
	pRxkjV1Y7jknRF1RLbLa202Uf8Dxs1Z8RD7D4NFbMPVgrWD1ve7q5QSJ0xEW9g4r1hypwgDHvce
	F68nUu8ENTn/vmgnWtIw7Jw4FTC8kTgA=
X-Gm-Gg: ATEYQzznqECiBTbTHp7nCpFV6NFeNXdU5T5anjQ5Aa2Y8aygkRT6HR8rcKnsDMCAuHk
	iaa3Z9garTVPsYY8dzQubyt9ura4kVREL1vr+2vE8MOSqwqgYTLjG3q9J9eJJWFD7AS6yGT9B2A
	y5s6C5PTp7IUeTezjJcaHtglMsM/lWcKQuT3MljVtDtwnRi1K9E50nQybwrc/tfYf8nxf1tn+pa
	gPvpEKDOtLl+40uOsNyMyE4swXRlh9p/57SiyzB4cpuuOSUZ6r37WkUp22zrXoBgEgL+mWOi7Zq
	MGwQJZ09jqzxW1e0XmN0SBoXvg1mfTMbDfA2XX/vG3TxYOgV
X-Received: by 2002:a05:6870:b3ce:b0:3d4:6fba:31ff with SMTP id
 586e51a60fabf-422cfc2c2f3mr1745082fac.1.1775030810009; Wed, 01 Apr 2026
 01:06:50 -0700 (PDT)
MIME-Version: 1.0
References: <20260331134158.622084-1-devnexen@gmail.com> <20260331200148.cc0c95deaf070579a68af041@linux-foundation.org>
 <aczOCqrCx7Xd5HIF@kernel.org>
In-Reply-To: <aczOCqrCx7Xd5HIF@kernel.org>
From: David CARLIER <devnexen@gmail.com>
Date: Wed, 1 Apr 2026 09:06:36 +0100
X-Gm-Features: AQROBzAx55RdIwx7SOU_j9d2ER3AR4Ymgnzi50Xv3jf7c4PW3gDEB7WsCX7nXBU
Message-ID: <CA+XhMqzdQLZD4YWzyZfTwd_+sDnLqj24APqBRgum97_=8EcM2Q@mail.gmail.com>
Subject: Re: [PATCH v4] mm/userfaultfd: detect VMA replacement after copy
 retry in mfill_copy_folio_retry()
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 25A95140007
X-Stat-Signature: 6optfgiwnxcuwntu1ytiko8gre7igpeh
X-Rspam-User: 
X-HE-Tag: 1775030810-879077
X-HE-Meta: U2FsdGVkX19MSFB1+q7aQzyQoNcLnpxnCY/e39dxeZoickySdDXzfeQFfqp4RXfbDKh5+X/R+W3aKkn3Oph5Ntez4c/9PKU+C1XxygO6He2wBEpemI3GBZNDnruP7bqKizX/SsaOO22ZACJi63FrR/Cf9Y8HGmWrNVC7/iJn3ND1YwclwVSZAeU7K10emLiiqhTXM5wzbF9VjYiyeWu7p37Oom+EuBN4RD8R2wfT/Gs26k0cJmGWV3ZGkGmwmRumsf+Vs/l6FCI9adhV3TXg/mhYq1zv1wHQfCuBHRcgNsp+ffaQPJpdwYUglA00w6AHADEAGXIDWBccuWoJL4VRsIzeuBV4lde5EUyouhxVTeJLbd0fjeb8v6jTriS5aHlJfsQ05GUJCu3PTHP/JS/Veq8l+whX8A4E5quYzIxM8Kqf8XdeDC3IJaQNVdT4eBsPa5BMHddjP11NeT+pCGp0eSJCasNHamGnNnMQqqKV0koUecxWyoMk2vkzP/pdN5SLhVyO24S2KdX2uIVyqFYogqS1/5lDBso48v1SFH1tr/G+4VGAEfN6LwWwteQ3Yb4Il0SLVzXx59vYhz5/P8zBCvBWFXwpc7u/EjeTsd7owHW+bBHcTQaRsf4x/eGKtpRYvjuNxDQBZqc4WbP3Z2J7qEbB13U20XP/8Kb58F+S4ggjyB5Zmy6DEhqd8V+l7JJuTPZJdtSgAbwn7vnEzY7xiYlv5esJijJVYOSvbx7lM2y7TNmQfy5YY6Z1MH+RR8rH0Ay8eLJ7DtKP1RM3Tam0nEfNvRpkEepbmK92iA/K1SrMn8AyOKM9qx+yzANAiPD/+c+Ol2AAqvl17sDctG2rKpVQ/IsoJaFGmcaoCJuhkKsB/quqxk2gvyIyzOSKc4KYOlwglchA/pfoMPm0n9lrffXjcBgheja7Eh2cjJS7H/pGNBkBVT3EzJsC6pcofpAKZdXUcSot2NPXfHkFDFl
 QNjeY8p4
 bGoSiQxe8HVHkuK8szlpiHuM5zHO3I+4fB5MmcM0TGOaf24G1Y+a16v30YAxLEWJ7wRR4LdwGLxuvbzRvonVbT4WsheCvblysmFsRVi1mB0oQx38=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mike,

  On Tue, Apr 01, 2026 at 08:49:00AM +0300, Mike Rapoport wrote:
  > What does "folio allocated from the original VMA's backing store" exact=
ly
  > mean? Why is this a problem?

  Fair point, the commit message was vague here. What I meant is:

  mfill_atomic_pte_copy() captures ops =3D vma_uffd_ops(state->vma) and
  passes it to __mfill_atomic_pte(). There, ops->alloc_folio() allocates
  a folio for the original VMA's inode (e.g. a shmem folio for that
  specific shmem inode). Then mfill_copy_folio_retry() drops all locks for
  the copy_from_user retry. After mfill_get_vma() re-acquires them,
  state->vma may now point to a replacement VMA, but ops is still the
  stale pointer from before the drop.

  The code then calls ops->filemap_add(folio, state->vma, ...) which
  would insert a folio allocated for the old inode into the new VMA's
  backing store. If the VMA changed type entirely (e.g. shmem -> anon),
  ops->filemap_add could be operating on a VMA that has no business
  receiving this folio.

  > First, this a pre-existing and TBH quite theoretical bug and it was the=
re
  > since the very beginning, so it should not be added as a fixup for the
  > uffd+guestmemfd series.

  You're right. The race window (VMA replacement during the lock-dropped
  copy retry) existed in the original mcopy_atomic_pte() code long before
  the vm_uffd_ops refactoring. The Fixes tag pointing at 56a3706fd7f9 was
  wrong. I'll drop it and resend as a standalone fix against the original
  retry logic.

  > Second, I have reservations about vma_snapshot implementation. What
  > invariant does it exactly enforce?

  The invariant I was going for: "the folio we allocated is still
  compatible with the VMA we're about to install it into." Since
  alloc_folio() allocates from the VMA's backing file (inode), checking
  that vm_file is still the same after re-acquiring locks ensures the
  folio matches the inode. The vm_flags comparison was a secondary guard
  against permission/type changes during the window.

  That said, I can see the vma_snapshot abstraction is doing too much for
  what's really needed. Would a simpler approach work better =E2=80=94 just
  saving vm_file (with get_file/fput) before the drop and comparing it
  directly after re-acquiring? That makes the invariant explicit: "same
  backing file means the folio is valid for this VMA."

  Happy to rework along those lines, or if you have a different approach
  in mind I'm open to suggestions.

  > > I've fumbled the ball on your [2/2] unlikely() fix ;).  Please resend=
 that
  > > after -rc1.
  >
  > This one should go the same route IMO.

  Agreed, I'll resend both after -rc1.

