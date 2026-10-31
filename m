Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACBB3606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 15:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmx.com header.i=aros@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=j/nX8rSD
Received: by kanga.kvack.org (Postfix)
	id BE3926B05B2; Sat, 31 Oct 2026 11:19:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBB0B6B05B3; Sat, 31 Oct 2026 11:19:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A83036B05B4; Sat, 31 Oct 2026 11:19:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7ADFF6B05B2
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 11:19:17 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 016EEA09E4
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 15:19:16 +0000 (UTC)
X-FDA: 85383279912.30.130F7CC
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	by imf20.hostedemail.com (Postfix) with ESMTP id 09DFE1C0005
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 15:19:14 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmx.com header.s=s31663417 header.b="j/nX8rSD";
	spf=pass (imf20.hostedemail.com: domain of aros@gmx.com designates 212.227.17.20 as permitted sender) smtp.mailfrom=aros@gmx.com;
	dmarc=pass (policy=quarantine) header.from=gmx.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793459955;
	b=vj3PzTXpVvTsFitD2g4Dd0BbJfJzi2ilDNOcovnHRk4TADmDEmKFpjzwWQXo1qf8WOk5gW
	DgwyHFhsDde6a4m142ImKMVf1HM/LvwUX0fqWP6spQA6NGPzjG1PXxLo8B7XFh7hYmPaIm
	4sP0/nu4p4aAtD49U8RhWz2s0XQC9/o=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmx.com header.s=s31663417 header.b="j/nX8rSD";
	spf=pass (imf20.hostedemail.com: domain of aros@gmx.com designates 212.227.17.20 as permitted sender) smtp.mailfrom=aros@gmx.com;
	dmarc=pass (policy=quarantine) header.from=gmx.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793459955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=rGJRUWHVZc+GV1T2glbBDs4zn8y35bavghVZaNWEV38=;
	b=eoE2m+Tr6srRMaVck6VOXrJ8ggNOZyQEytFk3unoNcjP6IYo7EjhfYOQ36s+bgATlI7hG4
	X0Pz7etKjpFKL6pQhKpk6CW5eJLuGJGmWCr4WpMNpTy+Iojv2J6c08JnL+CupVp+U80zYQ
	TsCn0OjSiQVKbnCEQCTJbpGIrjcb5h0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1793459953; x=1794064753; i=aros@gmx.com;
	bh=rGJRUWHVZc+GV1T2glbBDs4zn8y35bavghVZaNWEV38=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:From:
	 Subject:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=j/nX8rSD4Mfw1iqyIRgS/twhxb1tk6Yv42LTcq/9lDMX1UDaSb26hAimO1JuhBuf
	 HOKn+3UhV0zlkP4pR7QcDehLRheVugtdceZYfAXlD+8OsW2HVzF4GFbiozYNYNRdd
	 EsVtzV1+1K9KKEJTyI/oW1gfKTZC0pkgO1XLVb+RE4uXN8ozIUtbTae37g+BJQnD9
	 uNxSjY1R5nH0zQPxJ3XlCbEZT69UQX0hIuI23B6UOqoWpcAYhYD11ugUgl1lkU+X4
	 dbKx6tmVFkuHTvR4CRRwpAkXq50QiKwia9H3c3IakxAyLs7fLDqVMclYQN/RAuIRl
	 8FnLYzw4THj3DJCVRA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1N9MpY-1wR89E3Sho-012l6H; Sat, 31
 Oct 2026 16:19:13 +0100
Message-ID: <b42192af-d9b6-4820-bff3-e3b6c6ce9bf2@gmx.com>
Date: Sat, 31 Oct 2026 15:19:08 +0000
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
To: d@ilvokhin.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, david@kernel.org
From: "Artem S. Tashkinov" <aros@gmx.com>
Subject: mm: tmpfs: huge=always Kconfig help understates severe space
 amplification
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:xPe759PgRxemlHDr55Fx082NlvzbE+Q1otpItHIcym3ZjYJ++Zn
 kZgmbtIF05SLsfsocZsjna0DWdPIacKvLbe+ghl3RzZZ6Xq45CI6Wlb5ZhE3Br0kURVWadz
 TGk5ukLRdKK/ys8rm8nIdTCOySWuZQmZt89jEXRgC4I/F48d7Wt7GdqCX64BUkob791e1Fm
 hNp4ZjW9xneUeKl1o4+eQ==
UI-OutboundReport: notjunk:1;M01:P0:Nlp4ASWUcvY=;x26xLF1PeZhZYQMlPGuzCfCutpf
 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
X-Stat-Signature: 18xeru53mp9hn8fnbhyctto9twd9p6tj
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 09DFE1C0005
X-Rspam-User: 
X-HE-Tag: 1793459954-178000
X-HE-Meta: U2FsdGVkX18et0/J9ZdXmMdJ6ccQRWhXEOTtXXcw3+oLxd4EZO5qeFq6AY557MAfV174Swe4BEcKoyWnZ1/xqzw8d0b4ucdEC3CbeP7DMaDQok7pK78DCfoD8v1745QdTO4ANgweVK4VzVT1J16dnJvnxUarQ83fJ3GKiI+0izGDgJSo58urrOhtGX6O9c6IVnyixvYKYIkooQ140wDMRZCTtx6ggKnCUheFP+C6uuKetAF+yJu0L1j7SWX/8+WV5NkVeh3zp9ni6CT+T1B0PIdRjXIqDLHM0xLUMR4OMC3SyNrQ3rpExFpw2Twt0VYOIdDGBZFhybAT9LdZobDs6HJtaLQD27UFho53p9ysajDXQWkqGLv5EPEe6J/f1TmnTnxk8brAdXyfrZBJhIwnNgLd6oh1/rjFrVrqs5KFSHiqyxS5ziiUMCJwC1gzecz9+/lbXSkI4DnGTLSFuZIki9qJkqH+uvqxIlDHkZjoqbMMy9FZAI+28yMtq0Vs2GNMgqZXdM0xI26drcufSMSvckL3zttNFptueDZUU6ocRRODZaU/O747O6aarB1/d76UMc6fdB6v925A583z0wPSiB8CW1iYOVqnnU33RjLSIKT0HIazKFarcMlmzZWBECpY1XUWKIL5QEDkF4wJkfZIRmN1ixYu0XFuL19nAJQYMhbj46ja8FpXJrSNNdjh8p3zC9tVJO6nW556nA1CwjzSSK6KeJrVgtHe9FETWTehwWJfhG5erdy43gzIjYVWB8EAnM5esjeU4M8OxKTwQkR03CmGYQ85bsahhwPqIebYkrFaNiUE1wsPkJcaKJjyTlcyv4soeKRv7+NLlkoHoFJluwDTVvuEZ4zjWDBqP9Kv8u/+tTNr4uYHeHKFtQi9HKEzH0n+7umD2jIFlUc2Nd7vqhtAzr7LYQIbl2sunjFXMQXOY3g/CKtU94Bew/XODIKXce2fQ8jWxZ622ujEjZa
 kn20Keqw
 y82hHq4sG8xiD78lW0a/DkWAzyDpucif5ohIGYgyvtVVYjzdUP32FcVzSNIdArV5AWtKrHF1d8+uDn5o6GTCTijD7O/Ed17Y3cWmlLJiyElnfiDJhar2joS6rRRdf2dr0jMk/m8w2TBuUDCTQqYLtKd2PN3M3R3rPJ/1m34fbArpxF4L2elKMrp9ywkW0e/TwJ8FG3u3Dmjag97SkPMPKuD4xIKTK5DaQXhWDxCbfL+YdvXP3mQCR5nUL6ayFttVL8gFlLg7dntVwb/3zhIE3GNs4ea/at1vPL1I5PF2HR4lyaxYGxSVQf6rHB3cX9jgoSt5l
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Dmitry,

I'd like to raise a documentation issue with the Kconfig option=20
introduced by your patch:

     mm: shmem/tmpfs hugepage defaults config choice

Specifically, CONFIG_TRANSPARENT_HUGEPAGE_TMPFS_HUGE_ALWAYS.

The help text currently says:

     Always attempt to allocate hugepage for tmpfs mount, can
     increase the memory footprint of applications without a
     guaranteed benefit but it will work automatically for all
     applications.

I believe this substantially understates the potential consequences of=20
selecting this option, particularly on general-purpose systems where=20
/tmp is mounted as tmpfs.

I recently encountered the following situation while extracting a Fedora=
=20
filesystem tree under /tmp on an x86-64 system running Linux 7.3.

The tmpfs mount had huge=3Dalways enabled.

     $ df -hT /tmp/Fedora
     Filesystem  Type   Size  Used  Avail  Use%
     tmpfs       tmpfs   48G   47G   925M   99%

     $ du -sh /tmp/Fedora/usr
     45G     /tmp/Fedora/usr

     $ du -sh --apparent-size /tmp/Fedora/usr
     1.4G    /tmp/Fedora/usr

Even more strikingly:

     $ du -sh /tmp/Fedora/usr/share/man/man3
     7.5G    /tmp/Fedora/usr/share/man/man3

     $ du -sh --apparent-size /tmp/Fedora/usr/share/man/man3
     7.8M    /tmp/Fedora/usr/share/man/man3

Thus, a directory containing just 7.8 MiB of apparent file data occupied=
=20
approximately 7.5 GiB of allocated space.

The overall tree occupied approximately 45 GiB despite containing only=20
1.4 GiB of apparent file data.

This is consistent with severe allocation amplification caused by=20
transparent huge pages, although I have not yet established the exact=20
breakdown of huge-page allocations and other tmpfs overhead.

The problem with the existing Kconfig help is not that it fails to=20
mention additional memory consumption. It does mention that.

The problem is that "can increase the memory footprint" gives no=20
indication of the magnitude involved, nor does it explain the workloads=20
most likely to suffer.

A kernel builder selecting "always" may reasonably expect better=20
performance at the cost of somewhat higher memory consumption. The help=20
does not adequately warn that workloads involving many small files can=20
experience extreme space amplification, potentially exhausting a tmpfs=20
filesystem containing relatively little actual data.

There is also an important distinction between enabling transparent huge=
=20
pages for selected workloads and making huge-page allocation the default=
=20
policy for all tmpfs mounts.

I suggest expanding the Kconfig help text to explicitly mention:

- The potential for very large allocation overhead with small files.
- The risk of exhausting tmpfs space far sooner than apparent file sizes=
=20
would suggest.
- The fact that selecting "always" is not a universal performance=20
optimisation.
- The availability of "never", "within_size", and "advise" as=20
alternative policies.

For example, the help might say:

     Always attempt hugepage allocation for tmpfs mounts.

     WARNING: This policy can substantially increase memory and
     tmpfs space consumption, particularly for workloads creating
     large numbers of small files. Allocated space may greatly
     exceed apparent file sizes, potentially exhausting tmpfs
     capacity even when relatively little file data is stored.

     This setting does not guarantee improved performance and
     should only be selected when its memory overhead is
     understood and acceptable for the intended workload.

     Consider "never", "within_size", or "advise" for
     general-purpose systems.

I appreciate that the upstream default remains "never". My concern is=20
specifically that the help text does not adequately communicate the=20
consequences of explicitly selecting "always".

A more prominent warning would help kernel builders make an informed=20
choice and avoid potentially severe memory consumption surprises.

Regards,
Artem

