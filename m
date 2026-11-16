Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C096E606A323
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 18:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=JIYAQnIx
Received: by kanga.kvack.org (Postfix)
	id B7C926B05B1; Mon, 16 Nov 2026 13:14:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2C096B05B2; Mon, 16 Nov 2026 13:14:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D0B56B05B3; Mon, 16 Nov 2026 13:14:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7044D6B05B1
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 13:14:37 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CCDBE1601CF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 18:14:36 +0000 (UTC)
X-FDA: 85441782552.09.0430FB7
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf24.hostedemail.com (Postfix) with ESMTP id C1935180005
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 18:14:34 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=JIYAQnIx;
	spf=pass (imf24.hostedemail.com: domain of levinsasha928@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=levinsasha928@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794852874;
	b=OzYXvvlZBatT3aIT2OdNDQCm2LwVnB0EOs9mKoPkD739lUN29KTUbK4yA/tg8XDrk8tCO0
	io9BDW7fpaQWJISKTs+S+h7KOwSdhBS2LYr38jHG2n9zLCI69LsQEa1g9EeaDAvO5IhIps
	Z2DLY+1/K9ocpfKn0PgpExFY1Mf6dDs=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=JIYAQnIx;
	spf=pass (imf24.hostedemail.com: domain of levinsasha928@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=levinsasha928@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794852874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tbwNSvGvkZ6FGvVLTIjJxQ3bE6+PehswRYJGBnKvxtI=;
	b=sdZWezCRlP0/heJwjiqL/f/tHdRCsq5zvY09HN/ONU/r5aFidstCz+cG6dXBRqDMjsPXZm
	p53Dw9janYQCBBTHfAVcCLyGUbMOPwDinF4JxWRh3FQLRVGCDfXAYpVfmyh0c85r/I3Che
	LLx31GusvsQfwsjPLxvocfYOO0wBgM0=
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c50e9408873so117831866b.0
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 10:14:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794852873; cv=none;
        d=google.com; s=arc-20260327;
        b=nze3c6cqItPpI9TYkwumIpNMClgg4Y5npaEt2GgO5Y1JcpnJgSj9WNVRN8ovJsV9rC
         +8coq6CE/6a/QrTZS4PO2vKVbNSX664tDH3jBxL15PgkQxmroinA9CMoBhCQ9Nd3BBEm
         927L69mdwgD2XVbwLW8wzPvheCiFvUduzO6kvMVrKzCRRGIPTeFlDdhydCtwBzLwaTyc
         qBCMENYlaKtzIaU6BHf0z82YJ68fxwnKWPHtlRKCOC1mi6P5PVnJZKKIF8erkRqGDqUf
         X7hgvhXWGEAD2+oyA0GiFv6fqinpmpIgeJC684aJvvvysv7xK1D+92zS6zxTxLAVqvIY
         Z+Pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tbwNSvGvkZ6FGvVLTIjJxQ3bE6+PehswRYJGBnKvxtI=;
        fh=uaUwwYodRyEobXqAAO77HEQVajoeGXvjqCpyb0zHeKM=;
        b=K3xoTLFTnsQ7+EDoDXucX2Q2ikY8zVg7sk8Sd6xX2CSRQhtmso5LwvW2T2mzOm6nki
         9mZjfG3ZJZcNaEItpoQiic8ND3NrK6p3Ple+MNjt023pw1Wnk2md5q40yalpffTbBpWw
         3jjCdazh8E0Pm9PcGOkN0yDuXrTU+jbg6rDiBbuUruOJ5xtIBldv1NENPaOtD2dOxTBD
         Eu2xi8o95Y8u6vQm5vyoSQDt++a8/T1Y9FX7hl2/Tc7D2HspqpICQ80zLrCVO4OW2ZgJ
         EohmtleskTAqKSdZlpyN4uovsulvkFrVR1zcRjF6BPe36o2dnKGu4C9PaE5id4/4A53k
         IaPA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794852873; x=1795457673; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=tbwNSvGvkZ6FGvVLTIjJxQ3bE6+PehswRYJGBnKvxtI=;
        b=JIYAQnIx0JAXoosDJHutLeZc7xRFEIbfXCqMgubMIwkvzH1u2asnWL+Z73RxOthnfH
         q+NNfNQ7uJ1ucFuUexXojj8sfjxixAx4JAK4gRvJXyaudflTcOEWt0sRDnOsxDaFqYJx
         5d1F60oMDZXuEkCb9QW9pQvRNEL2+d0YmpNBHllsZgIYgzcixCfLitBczMm4BEEeR8wu
         NEhPgY42BZImFQthHooWo76sbzWlpxKzwKzrEjYuliBhEtJO/ySXYQq8xVIO8/S4KULU
         7D7w0WWVL1qpMAkK9XAyBclL/3Cw6Mym1lGu+XfeIikdVqfpEk1sqzLkarlhyjL6GIts
         MRig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794852873; x=1795457673;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tbwNSvGvkZ6FGvVLTIjJxQ3bE6+PehswRYJGBnKvxtI=;
        b=aH6PQGNhMXzXx6jsEN42UGEsLgGTjvqVEXJXKEP4GDsw2YQfjCpiMOjQNZg+oQyo64
         xoNyvKa5gc+8roiXRbd1LlzRMAFzYioG2h1Y5D91FnTX2/iAoM57COPF3qVdixjP/NC7
         wXYaXu0dPYNyc0SRU+ENcj16OV7zFT/dxyOsNAFCyS9Gy41bEEEgpTxZUuatUQXBya/p
         Dgvi6S4xdKMTzBku5FimvgRUa5JbGV2UIEYvrB3gvt9+9n40cPjH16X/5soXhbANfKio
         cOn9Zru9cbsmxB7IomqOYHmSHDT2QkWJ2ZWeaDCyECkTYK/t39SRGzARHPoPMlC0dDDz
         0QOw==
X-Forwarded-Encrypted: i=1; AL+hErEIqWU3pk3gntFJZZPyMuOIUoIuxFWKRas//1Kl77pvi4LNQh/VSgTFIPN8og6V+URh2X3gXMqX5w==@kvack.org
X-Gm-Message-State: APuU4Z8IyMOq68IMV8gEv4/0Ggr4ZJ3HOrJ74jGdKYEFHRRW3rXz0oGE
	boDLIwwsfxT7XwWdWmXHPXLaMnndVeyS8c2pRoNYFRJO8tKs1AGYn1XhKWJKJN6YmdW8tniflaA
	AE+q0k29MJ6I5MjIH/jO1xM2Z4SEeY/A=
X-Gm-Gg: AYBFou3Gvejzoue1mCzzYowfVoh8AD5sHsrJimS+Ax4I0SeUwewF+BLo34A9rSILtSg
	1j4sHxXZ85R3naoJbFa/QPW04jPJRckB4NgqtcPCbmXOzC4ccRkjet1JqNEL+/XsNTX0wdqcm14
	W6Dcwxi4q8P9XpDWQAQokuVRKgIleeOXCRBRKImJOZHUryJ5MMqUQfwEdn/LeSRNrZh5S5uW7qo
	g5xIr4wfYzLnq/H1XX+Fy8DcCivm9HwUaOMKlQWAopHk2h4OWYkQtXb1yY/i4yppfK8Q1ELkHnh
	1RylpAFu3aHhFm+vnZGHgX1UB/l6g0/ktq/wjwnnMG0IkyUteiFUJ155Npu/bmhe8gh3t/kAKat
	I/A5tsblDmnjTG5nMTpdcYRTArj/MBJ46ZniE0D3TjPbosXn8915VIY0OzzkchwtVI8h1rw==
X-Received: by 2002:a17:907:3ccc:b0:c49:a235:8e0c with SMTP id
 a640c23a62f3a-c509637e31dmr934233266b.22.1794852873007; Mon, 16 Nov 2026
 10:14:33 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261025164719.1831477-1-sashal@kernel.org>
In-Reply-To: <20261025164719.1831477-1-sashal@kernel.org>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Mon, 16 Nov 2026 13:14:19 -0500
X-Gm-Features: AclHuK9sfeiUUhkQOi4L3FtpqX1XWSWrAtRgGWBj0BPLzcNiTLpwmGT382OC52c
Message-ID: <CA+1xoqcxAsRij1j10TyhNX9JXNXNkdWO3sMaVRXCqYdEXi45fg@mail.gmail.com>
Subject: Re: [GIT PULL] Kernel API specification framework for v7.4
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kbuild@vger.kernel.org, linux-doc@vger.kernel.org, 
	Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, 
	Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nsc@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Mark Brown <broonie@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: C1935180005
X-Stat-Signature: qcmmju9o7fbsp1iir7rwynm6uoof9xtj
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-17.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794852874-135152
X-HE-Meta: U2FsdGVkX19KeOB0YhLmLR5ZYhVKCAzMcoYF4lCBX1PGEOAedaz7GQusonTPivnrApY6kz725SryjRd7/Gp2c7xqxBdwLgxzTMii3WCU+BxOgJvdrPHH16J5M3b1y2Z6xV1U1qYkvGOXLI8UGORMDvX5672PJ+LITw7L5IFUKH0V5Wwc2kyUjsCJdSSUFtIoAhXafdz2BriWujA1vGXETac5PqT8VivHD3gbEJkF2Ved9H7uyb4fD3cjyXhroTC+gc5VNZnHf+aSI0CQUzus1WIHCz8sYgqGC5f6qpD8PGYEY9AMtK1MYHctqNp95L0RI+c95tWkyRQFFyx9MZRn7uY78CgTs/+k/qpk9+bR7KtVlibWrgwcFDUlVZgMSyJLhfhoKNThK6JfmjuSU8QOJpetcY0prWotQ7VeoubY43V6sXsGtrLVcIU2teAKk1OHy6lmbB4EqfMDawXoptACec1+y9FrFqzlRFMIugI7bMsSj+e7PZVCFnQVo1BBkhiAjNo5PZv6qS+ETC9YHsDK2tH9RxkNy5ojrFZzaYJ0fYClPenVOD9gNuh+E1ppBbcEAa9BWDfzMX4r7RaDkdQ2itY9sd3vFmrkPHQlTBhPre6nzSyb5EUhlo4kNubIwT8+PEi7y7QEB5FonzKA7gVZUh8uNlUTpZBOvicO/Zf6jvrC9YFl/Rfga0ZQw7Eswg49urzDNQboL9BcSXrMgPIG/OXBqWyLKga39OaCI1pXYkXLRrX9WYFu1hdX7gSlGfVtqWw0sGblxPTpCIDPFydX/K0Vho838eq4QZx/EeNvqs4aOE993VLTDrMWmZwObTkqeatDJTRHD2EUMClEpWdckLija8azrK8BsBOaqJctc67wrYpgRw+v4J44BOnV5Uq62bO/I4ul/xFpxxGt/Sly6+kO3umuXqvNFiErPFF/MhP41i8qZXWKB07wSa9YpNXdCf/eBtjBdbJA2PI2nqO
 0NV4Ag5L
 xIbsGxlgRQSBDwIbsHX8fQBw284L+FvqKkaIVo5mBu5IsCo3IMrh6NEufsvqoUpYbBvDDGU1+YfI5pRkHPo2eji9qDy9do3ifl/QigY5uOYfczr7pS6T2kf+oU0QIon+h30AFda5wEFpN4Nw2EppWRlx3rplYRAe35xJa9WlpiP+Eh9J4ObpKO1N5sDyTJmb81uEfDm24IYUy21p6hBsQxR9qZ8oVsBn8MRDFDTUXzXazqbBMSUH3aDP3u0PjcReuYRpkwMCibqy38+qfMU0j6ZiS1hDIw4R3mwR/vxki/jNVxpTNooOHkEpZMfWSj91XgL0YU8V06nCwMsU7FRC7nbBpabQjuHrVMqCa01Ge5zMNcFqoi1dK1/kvS5zWIS5YA8x6qXoJnvLLFYcbVgOH4cUd8or0mJZZjb/U
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Ping?

On Sun, Oct 25, 2026 at 12:47=E2=80=AFPM Sasha Levin <sashal@kernel.org> wr=
ote:
>
> Hi Linus,
>
> Please consider pulling the kernel API specification framework. It has
> been discussed on the lists for over a year: five RFC rounds starting in
> June 2025, then v1 through v5 this year, the last on October 8:
>
>   https://lore.kernel.org/all/20261008084956.2911790-1-sashal@kernel.org/
>
> The branch has been in linux-next since next-20261009. I held off on
> sending this until the first week of the merge window was over, to let
> things calm down.
>
> There are two conflicts with what you already merged. linux-next resolved
> both the same way:
>
>  - Makefile: kbuild added '*.header-check' to the clean rule at the same
>    spot where this adds '*.apispec.h'. Keep both lines.
>
>  - fs/open.c: vfs added filp_close_sync() just above sys_close(), which i=
s
>    where this adds the sys_close() kerneldoc. Keep filp_close_sync(), the=
n
>    the new kerneldoc, then the existing "Careful here!" comment and
>    SYSCALL_DEFINE1(close).
>
> The following changes since commit a90ee4305c4a5df72c11b31dacfdc76e00fcf7=
8a:
>
>   Linux 7.3-rc6 (2026-10-04 13:45:25 -0700)
>
> are available in the Git repository at:
>
>   https://git.kernel.org/pub/scm/linux/kernel/git/sashal/kapi.git tags/ka=
pi-7.4
>
> for you to fetch changes up to ef777ef05ebcc5ea5393b4bd5af6fc3ad1b3aec9:
>
>   kernel/api: add syscall enter/exit tracepoints (2026-10-07 18:26:44 -04=
00)
>
> ----------------------------------------------------------------
> Kernel API specification framework for v7.4
>
> The contract of a kernel interface (which arguments are valid, which erro=
rs
> come back and why, what context it can be called from, what it locks and
> what it changes) only exists as prose in man pages and comments, which
> tools cannot check. This adds a way to write that contract down in a form
> that tools can consume, next to the code it describes.
>
> A spec is structured kerneldoc covering parameter types and constraints,
> return values and error codes, execution context, locking, signals,
> capabilities and side effects. At build time kernel-doc turns it into C
> data in a dedicated section of vmlinux. From there a spec can be:
>
>  - checked against syscall arguments and return values at runtime by
>    CONFIG_KAPI_RUNTIME_CHECKS, a DEBUG_KERNEL option for x86 and arches
>    without syscall wrappers; a call that violates its spec fails with
>    -EINVAL before the handler runs
>  - read as JSON from debugfs
>  - extracted from vmlinux, debugfs or the source with tools/kapi, which
>    emits JSON, RST or plain text
>  - followed with the kapi_syscall_enter/exit tracepoints
>
> The first specs cover open, close, read, write and madvise, with a KUnit
> suite and a selftest in tools/testing/selftests/kapi.
>
> Everything is behind CONFIG_KAPI_SPEC, which defaults to off. With it off
> the syscall definition macros expand as before, kernel-doc output is
> unchanged, and the only change to fs/ and mm/ is the kerneldoc text.
>
> ----------------------------------------------------------------
> Sasha Levin (11):
>       kernel/api: introduce kernel API specification framework
>       kernel/api: enable kerneldoc-based API specifications
>       kernel/api: add debugfs interface for kernel API specifications
>       tools/kapi: add kernel API specification extraction tool
>       kernel/api: add API specification for sys_open
>       kernel/api: add API specification for sys_close
>       kernel/api: add API specification for sys_read
>       kernel/api: add API specification for sys_write
>       kernel/api: add runtime verification selftest
>       kernel/api: add API specification for sys_madvise
>       kernel/api: add syscall enter/exit tracepoints
>
>  .gitignore                                       |    1 +
>  Documentation/dev-tools/index.rst                |    1 +
>  Documentation/dev-tools/kernel-api-spec.rst      |  648 +++++
>  MAINTAINERS                                      |   13 +
>  Makefile                                         |    1 +
>  arch/x86/include/asm/syscall_wrapper.h           |    3 +-
>  fs/open.c                                        |  557 ++++
>  fs/read_write.c                                  |  710 +++++
>  include/asm-generic/vmlinux.lds.h                |   14 +
>  include/linux/kapi_syscall.h                     |   35 +
>  include/linux/kernel_api_spec.h                  | 1226 ++++++++
>  include/linux/syscalls.h                         |   42 +-
>  include/trace/events/kapi.h                      |   74 +
>  init/Kconfig                                     |    2 +
>  kernel/Makefile                                  |    1 +
>  kernel/api/Kconfig                               |   74 +
>  kernel/api/Makefile                              |   13 +
>  kernel/api/internal.h                            |   25 +
>  kernel/api/kapi_debugfs.c                        |  553 ++++
>  kernel/api/kapi_kunit.c                          |  720 +++++
>  kernel/api/kernel_api_spec.c                     | 1470 ++++++++++
>  mm/madvise.c                                     |  549 ++++
>  scripts/Makefile.build                           |   26 +
>  tools/docs/kernel-doc                            |   12 +-
>  tools/kapi/.gitignore                            |    3 +
>  tools/kapi/Cargo.lock                            |  679 +++++
>  tools/kapi/Cargo.toml                            |   20 +
>  tools/kapi/Makefile                              |   33 +
>  tools/kapi/README.md                             |   33 +
>  tools/kapi/src/extractor/debugfs.rs              | 1704 +++++++++++
>  tools/kapi/src/extractor/kerneldoc_parser.rs     | 3335 ++++++++++++++++=
++++++
>  tools/kapi/src/extractor/mod.rs                  |  442 +++
>  tools/kapi/src/extractor/source_parser.rs        |  531 ++++
>  tools/kapi/src/extractor/vmlinux/binary_utils.rs |  461 +++
>  tools/kapi/src/extractor/vmlinux/mod.rs          | 1160 ++++++++
>  tools/kapi/src/formatter/json.rs                 |  659 +++++
>  tools/kapi/src/formatter/mod.rs                  |  220 ++
>  tools/kapi/src/formatter/plain.rs                |  679 +++++
>  tools/kapi/src/formatter/rst.rs                  |  802 ++++++
>  tools/kapi/src/main.rs                           |  123 +
>  tools/lib/python/kdoc/kdoc_apispec.py            | 1391 +++++++++
>  tools/lib/python/kdoc/kdoc_files.py              |   12 +-
>  tools/lib/python/kdoc/kdoc_parser.py             |  101 +-
>  tools/testing/selftests/Makefile                 |    1 +
>  tools/testing/selftests/kapi/.gitignore          |    2 +
>  tools/testing/selftests/kapi/Makefile            |    7 +
>  tools/testing/selftests/kapi/kapi_test_util.h    |   31 +
>  tools/testing/selftests/kapi/test_kapi.c         | 1163 ++++++++
>  48 files changed, 20350 insertions(+), 12 deletions(-)
>  create mode 100644 Documentation/dev-tools/kernel-api-spec.rst
>  create mode 100644 include/linux/kapi_syscall.h
>  create mode 100644 include/linux/kernel_api_spec.h
>  create mode 100644 include/trace/events/kapi.h
>  create mode 100644 kernel/api/Kconfig
>  create mode 100644 kernel/api/Makefile
>  create mode 100644 kernel/api/internal.h
>  create mode 100644 kernel/api/kapi_debugfs.c
>  create mode 100644 kernel/api/kapi_kunit.c
>  create mode 100644 kernel/api/kernel_api_spec.c
>  create mode 100644 tools/kapi/.gitignore
>  create mode 100644 tools/kapi/Cargo.lock
>  create mode 100644 tools/kapi/Cargo.toml
>  create mode 100644 tools/kapi/Makefile
>  create mode 100644 tools/kapi/README.md
>  create mode 100644 tools/kapi/src/extractor/debugfs.rs
>  create mode 100644 tools/kapi/src/extractor/kerneldoc_parser.rs
>  create mode 100644 tools/kapi/src/extractor/mod.rs
>  create mode 100644 tools/kapi/src/extractor/source_parser.rs
>  create mode 100644 tools/kapi/src/extractor/vmlinux/binary_utils.rs
>  create mode 100644 tools/kapi/src/extractor/vmlinux/mod.rs
>  create mode 100644 tools/kapi/src/formatter/json.rs
>  create mode 100644 tools/kapi/src/formatter/mod.rs
>  create mode 100644 tools/kapi/src/formatter/plain.rs
>  create mode 100644 tools/kapi/src/formatter/rst.rs
>  create mode 100644 tools/kapi/src/main.rs
>  create mode 100644 tools/lib/python/kdoc/kdoc_apispec.py
>  create mode 100644 tools/testing/selftests/kapi/.gitignore
>  create mode 100644 tools/testing/selftests/kapi/Makefile
>  create mode 100644 tools/testing/selftests/kapi/kapi_test_util.h
>  create mode 100644 tools/testing/selftests/kapi/test_kapi.c
>
> --
> Thanks,
> Sasha

