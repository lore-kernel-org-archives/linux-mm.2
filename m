Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFE52C88E4D
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 18:04:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8A826B0093; Fri, 11 Sep 2026 14:04:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C62A06B0095; Fri, 11 Sep 2026 14:04:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B51DB6B0096; Fri, 11 Sep 2026 14:04:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 98D006B0093
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 14:04:16 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 22A821402FD
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 18:04:16 +0000 (UTC)
X-FDA: 85202255712.14.82510B1
Received: from mail-yx2-f13.google.com (mail-yx2-f13.google.com [74.125.224.141])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1FD0D180006
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 18:04:13 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=krlzqKNx;
	spf=pass (imf24.hostedemail.com: domain of ackerleytng@google.com designates 74.125.224.141 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789149854;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7vv9o4OWee1pnKi5CCaT/T/8GgHGqw9lOYuHZfnosco=;
	b=tcjwegC1C9J+HPvRMC1aWkwTfThb5wTlwV/t+aSY+UC5nu1IM5gvWEzFkG28Blz5sJ1Ca/
	9alXSjPi05ujk78IrwHEfesAW/a5ri3GX2vJTqr4/2Xr+TTfQFCYuLkmYiT16Sqjv6LnZ0
	QZLd6F8+ZGIO0r6LIfaG3R1Turk2Gds=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789149854;
	b=X5nceLO/QFDFoI2FHHwK+5xFUFc+6Yfn2mLE0F54i0LhcSNG2bZ0XvVnN6LTWgrbybhT57
	q82kOO/04z5gKmvwKOLh5JCFqfoEymXTD3qaGkOEic/idsdzLA92D366epRUXepPC/Y9Z1
	phnokmvKveBURe2oFOGc/m/DIP99Pjw=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=krlzqKNx;
	spf=pass (imf24.hostedemail.com: domain of ackerleytng@google.com designates 74.125.224.141 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-yx2-f13.google.com with SMTP id 956f58d0204a3-66e4ab201ebso31854d50.3
        for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:04:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789149853; cv=none;
        d=google.com; s=arc-20260327;
        b=L4Hw5sFf6HrSAQ9TBiCCRLXXIn37vX+MjJYhuyJcAOGlNFfe0FQPQ0iXtyyEP4MMTV
         /LAAmCbG41sLBKWm59bk6iZimdjD+zCejH+MlU3LbNIJ0mvdU4X9027XSOBzLzpQPRXP
         eyf3g+cUgNJps5z2qBYik0SqkA3VXdMPg+kk1EEBvm/sFzCh03JgRWKQc2G1GLvJhBbm
         A+g8cmdbG4SyA6Dgf3wikbbZ6K3A2xeIFKJYu4q9j/EU6dvYbDTDptZrYluamqgVANR0
         nQFQfivu8EF4hfMlSkSFbNs4EcCr8pX8cSPTwhA/e009wYh3FNKw2htl92jB6J/Nh951
         juUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=7vv9o4OWee1pnKi5CCaT/T/8GgHGqw9lOYuHZfnosco=;
        fh=wczUtcPX3SRt0ookLF0fbOwJOqyRZ5pkbuYg+3T3KX4=;
        b=AdQCOJXCuC3nRv+fQzFbvgocQl0gsMu2zAmPjNyDXqFwW9VJ1hW0vTUAgVWbYq8NVN
         2DxQXEe4GJb6qJBgWfcawjJ6e04kEidwpC9sDvjhQZa2HBfmjaE5ROGc3Ug1RgUFvQrr
         9QOan69VjRTIkkS/JylzDiXOu0ZjJycF5EjykWR9/bssxVYj5nqge5dOAX9EngK2za17
         W8e2XcBh+4f3+zCEYhElJiYAYvEbLuL+mWrGeLhsC87xWsKIhH/PqxC4WBGGIlQnyo78
         dU0KFkmlQpDi+Danv90RtDYEou20NzJ4oTISBShBo4LwtGY+f3sDN57UdNmGmPkHAA67
         RfmQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789149853; x=1789754653; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7vv9o4OWee1pnKi5CCaT/T/8GgHGqw9lOYuHZfnosco=;
        b=krlzqKNxhny3LqL9aGzKMCxqrxma4Sx00yo/D8mx0Q6TjgyB5v4MjhrBs4ROD4aSUF
         5KJ8TTUjHQHy0Ci5Mr7Ctlk1aGNYjCviDd8DGt2aQzD/WyHCbFTMVMGNVBMYywzIIWTV
         kZ63yJFe749ggxZSbusnhYOUbmAtLw4kjvb4Z86RnxNgPWOXVpwC62N7w2zorRhKKjTO
         Kw3rwUNe6yTaGlFBAVBW6nLz7mMfFzN2Z3HeMt5cViAk9B4CQF0EDTl8FyM1THdp49GK
         6RMfCuhadr8IE5USvTqaDTtSv5WtTzMEt40yBRIeVGp8/n4k0zz+eTS31umqto3Uv7XF
         ktTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789149853; x=1789754653;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7vv9o4OWee1pnKi5CCaT/T/8GgHGqw9lOYuHZfnosco=;
        b=JkZTTbP28jrWaE0n44aG1ieo4Zhp3odtUAOekUVNp14ItBCZT7bHCdxwEmCx/sULrq
         et4nQiPVCCF+7mvk17rj5ePy1vaH2nJm6dugN/L56kFcjkgbwM9ydqHU78kKb9eSnpoZ
         E6BwzXEwWGBt5lz9FdI0dJC7LV10xd9TQMozAzjD2vl4Zv+G3ftG4sHfOvQp1JUMXxXB
         kr1wvwLSRY+i/UD9K/WyCVd30yrP5S9xLyRlkKTdInTOT7xBLdog0WyuC6VBU2OIEQCY
         JmWvQdkJ3nkaz/eRM+A36zC/w5v5GgcRfgwhWn1/syX6O4GO7PHbLZI/ksMFEU3gieJ1
         Tm5A==
X-Forwarded-Encrypted: i=1; AKwUvBy4zTVHVhguqh5opAwQCFwccH9ez6Nkl0ULRzAiocizAgdPRO/qj3x4B6DsXUd9KeCe18CG1KSUHw==@kvack.org
X-Gm-Message-State: AFuF++nzzzSYfs+PYs+a6KaYQSKa5WA6yAtr/ZjStVzLM9cgrsj6Kcrv
	GlH3enWcg5OocBVkKrS8blcO7SaRq/SUa8m+ooTAPRD3QR7XmxTRUKTkA6MsRzabnQzKbKb+D85
	AyAsFtDlP9mwIYtoTectOofrlsommrYz9f8sdWiUO
X-Gm-Gg: AYBFou00h4VPyRUGrf7xn98+1WNFJv65wUiKGvguilMK59AgPL9avOH+XnttYlVHGD7
	XoqLawM1mbJi9Wnj0Tv2XexgHG36EzkauX2jlh8qjbv9noPHQ1rITM1MvTD9Qf2/v5uF3KWxID9
	A18pNBFg4QTC8tu/zmaT2SRZGaJeeIeXB2rh1js43+Us3ti2Oi+Jodez4M+w1CVIlQY4pYAPx5c
	pC4OnR1ofXqfPD2yGJHRV33qWwrZfoddrswItifSX6dVl3YAQelwe9l10q8Ij5z6gEIXBsuhT10
	dbbIPLuUHnQJJbKH9qPpFXMbusq8Nwi5fsRLy9v/zKOnqp6mp6PahZPN4a5oWka/ESkXKDj0ZjI
	SQ1XvVAoJ5Zgd1p4BCGRvqQWpiSBeezJ/OgAR6xLeOQ==
X-Received: by 2002:a05:690e:1341:b0:66f:c1bc:87eb with SMTP id
 956f58d0204a3-671249f425bmr1974723d50.68.1789149852145; Fri, 11 Sep 2026
 11:04:12 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 11 Sep 2026 11:04:11 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 11 Sep 2026 11:04:11 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260901180713.4185641-1-dmatlack@google.com>
References: <20260901180713.4185641-1-dmatlack@google.com>
MIME-Version: 1.0
Date: Fri, 11 Sep 2026 11:04:11 -0700
X-Gm-Features: AcwNN1VDqbMSWzZBtW5WvtCjBXts_71wkcwIE-pv_51Ep9lT2w25BfsfGqo2_lU
Message-ID: <CAEvNRgEs82CVTL_CUn=Ovrwvt86U1dxzr8psWGu=nk98ZH6Esw@mail.gmail.com>
Subject: Re: [RFC PATCH 0/5] liveupdate: LIVEUPDATE_SESSION_RETRIEVE_INTO_FD
To: David Matlack <dmatlack@google.com>, kexec@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <shuah@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: yxqisubdoeiqkh94ofineayodf3mc9pg
X-Rspam-User: 
X-Rspamd-Queue-Id: 1FD0D180006
X-Rspamd-Server: rspam03
X-HE-Tag: 1789149853-729219
X-HE-Meta: U2FsdGVkX1/U0iECXf9bcV0f0pCnaaLXBBIgBjitfEPF3Fp/AFtby+yDxhB2vAPeO3ddc5cuj0xX/iRwe8IF3yMn7kAbrTsOh8m9OoHWMD1O/KnaroO9OmXD8tImOrb85ijby9QtkGdeWjTDjfHtvaK0lj8mPXsj58sDB7Zo8G2bLXMR0EMZd3Y3/5J5iFNv0PAySH+CUdRWjvsKeUuNOIGH5OW5cwPWCILkGxR2Bb6NEY4cgog27c9I7MP0QqkPOfyA9vZZEyIzhw8uO+0+L+B6ubAtIGv/+bxBV0DuJ7/lsCU8BjBqKWrG6kXXoXef1PCDejJ5ZcJWhJ51N5Dh5uYoFyrSv6hYQ5GjsygQIojVK8xaNYGh1imNkanyt5P8+f1i6zRezkvx442ObGp9n51m8CzwFu4/+1ORlAYHzYdeVQPYLaGHmTkliychsD+QMUBEyXyLdhw5aoinsLZbBIXBlTzoHlIgCIWFrCZmc3ddqw3aEUykhdSjAaw+0S0QVbNPE3Fp5LLTjEN0IqtbsUvYgcsNLmzOpKt1OCkh0eMo9WChVAKbrz4QGH/J0xENluHCKO7RqBP+wnzaHinStYwgQ2mCAkDrC+azUhIyoAyahslOJ7bs8N6vPQg45FC5TyhF0NVmtOFbxyNIPuMWw+3SkMPlWWBgJkVc9mgGLGagNaec7uahTArfLPXGOdoxeZACFg/e5Ag60Dqt3dbxkBT1x43aiR024NIHFkhWgBF28ohzkaSH0YWMYPAh9GKRRRCb0X0KwGgJNCUlLCOMu91S2xTGfsDJJonqfxDwgImDxcYqM4hkO245XfSenLOzeIQqEbfmaMpF18oq/AwcuwNAakQxDK9ixVkcmAhJciexBOnxie9TTHTWZMLlwGp8HcwB9IJ0mW8cTaaIFxPQM1G+AE8r1ZMi0S5NoQEYOMkX0Fp3fKB26Jw2lySRTYLOltHt38zG2gO4evKmhLm
 M3zLZP3u
 wduBRPJcok2H6XmY5hulmxCDfyhiNkLyh+pgaOjoU3O8HxbSqjutZqpFf69tZAFLpAeLZnTOUnTgtsoLFjW8xsII9/Zc2k2JLk7gM8fk1JFCcrbKDvUtFA9ByOYzjBYRXo38sh3y+FrZHUM1nZOGashEIc9I5znZCwxn64Jx9rOSL8dL7ZtYmF6ETSeOOhCK2y33AW65+smZ2nnaVYZsLfRHeiyBCYrl30jgjG445roJq7KOzkukL6kRd/dFL3rMGiaf6Npl6Q3ynusJemR9rDIF7RYJrZTBoxY4vSjj+qKS1z0Oz5hpVvN9A8q7vj0Ujc2x32+X5mD3rkS/fay5WSPUVbsFr/se6ZL7QvCHxZAr/MlOdZ6Q+YWOdEQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

David Matlack <dmatlack@google.com> writes:

> This series adds support for LIVEUPDATE_SESSION_RETRIEVE_INTO_FD, a new
> UAPI to enable preserved files to be restored into a userspace-provided
> file instead of a kernel-allocated file, and uses this to support
> preserving tmpfs files in-place without any changes to the LUO ABI.
>

I'm interested in the idea of retrieving folios into an fd for a
different reason, I'm exploring handling over ownership physical memory
to a guest_memfd.

> The Live Update Orchestrator (LUO) API currently explicitly returns a
> new struct file for every preserved file during retrieve() (e.g. via
> memfd_alloc_file()). This then forces userspace to use anonymous memfds
> for all in-memory files it wants to preserve. This works reasonably well
> for VM guest memory but does not work well for other types of files that
> userspace may want to preserve (e.g. in-memory logs, binaries,
> configuration files, etc.).
>

Does this assume that VM guest memory is usually provided using
anonymous memfds?

More generally, is the problem that there isn't a simple way to
implement retrieval into anything other than anonymous memfds?

> Preserving entire tmpfs mounts in-place would require a large amount of
> kernel support and would effectively make tmpfs an ABI, which is a
> non-starter (or so I hear). Instead, we can delegate the reconstruction
> of the tmpfs mounts (directory structure, permissions, etc.) post-kexec
> to userspace. The kernel just needs to preserve the contents of tmpfs
> files and provide userspace a mechanism to restore those contents back
> into a specific file on the filesystem after the kexec. Hence,
> LIVEUPDATE_SESSION_RETRIEVE_INTO_FD.
>

Suppose pre-kexec, the data was in a tmpfs file (and fd), how would the
preservation work? Would the user have to

1. Transfer the data from tmpfs fd -> anonymous fd
2. Preserve from anonymous fd
3. kexec
4. Set up the tmpfs fd
5. Retrieve into the tmpfs fd

> An alternative approach to restoring data to a named file would be
> supporting a zero-copy sendfile() that can be used to convert named
> tmpfs files to/from memfds across the kexec. But this poses significant
> challenges on the *preserve* side since the preserved file might still
> be actively in use. The benefit of the retrieve-into approach introduced
> in this series is that it does not require dealing with two different
> files. There is only ever one file that owns the preserved memory.
>

Would it be more symmetric if the process is

1. Transfer the data from tmpfs fd -> anonymous fd
2. Preserve from anonymous fd
3. kexec
4. Retrieve into anonymous fd
5. Transfer the data from anonymous fd -> tmpfs fd

As to the exact details of "transfer", I think the best we could do
would be some kind of move from one fd's page cache to the other fd's
page cache?

Is the goal of the transfer to avoid any memcpy and fully transfer
ownership (so, not just by increasing folio refcounts?)

> By leaving file and metadata allocation purely in the purview of
> userspace, programs can create the target files where they want, with
> the names and security permissions they desire, before directing the
> kernel to restore the preserved folios into them.
>
> Currently, only tmpfs shmem files are allowed as valid target receptors.
> Attempting to target populated files, or anything other than an empty
> shmem file, will trigger -EINVAL. HugeTLBfs files could be supported in
> the future.
>

Is this basically that at some point, all in-memory filesystems' fds can
support transfers?

>
> [...snip...]
>

