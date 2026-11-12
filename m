Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C685A606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 09:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Lk4fh6uh
Received: by kanga.kvack.org (Postfix)
	id E3FA26B05B1; Thu, 12 Nov 2026 04:23:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC9A76B05B2; Thu, 12 Nov 2026 04:23:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB8E26B05B3; Thu, 12 Nov 2026 04:23:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A52476B05B1
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 04:23:15 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4AE51404DE
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:23:15 +0000 (UTC)
X-FDA: 85425928350.30.EDD8ADF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id ACC4940009
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:23:13 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Lk4fh6uh;
	spf=pass (imf04.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794475393;
	b=DsH3G7lGZNfWz5Ku23II/f0UBGN5mt5vOqoagCSCaWeOTSdOKLmhx5cSfFGyFiidPcUdGJ
	yktHg38xRgqtQ43TY8bcn8pDREboeg4PnOMHzfR+zNJ2SebOK7i+mHbk3+nkIpTp1GuLuP
	WLY7abSRq6nUdzjuW/T26bxGYGHXsHo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Lk4fh6uh;
	spf=pass (imf04.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794475393;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=COtLWNA/6jmhBo0z5yMAfo9QrtLgCVfE5IORaIf3+y0=;
	b=L2DqZz1jFWpbeto3MvFlabUiuCNp48anu6Lj7MJDh+FyaeEdmPjqJLUpmtnp/jt0see4zD
	4WJGvVKUmLBVBcaiwPw10PITT+zOPP1KsPjSlF1bxXhcqE+gtTvX8hl0frhyEnfe+K8pYZ
	DvbjC/3bm2Wzy5WuuX5wfWiHZhKoXjA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4834D62CC0;
	Thu, 12 Nov 2026 09:23:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2ABF1F00A06;
	Thu, 12 Nov 2026 09:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794475393;
	bh=COtLWNA/6jmhBo0z5yMAfo9QrtLgCVfE5IORaIf3+y0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Lk4fh6uhvdQFKXLCzlATpBN3Z7PdfBoxwcNAdDbfcX1qP/wElnNrdjWUZD48uAeyb
	 PjVMHIs4sK62MoAvAI2wCoqHqu2Vu+GT95E6j8c+oMVVF6H7DLtby7fWvEcyeBOBTA
	 6f7sTCixJv60UN2HYBXcao3yokBrl6yPVJgAZ9JV0559s+ShUeWqOxHln3Hik44V/I
	 Vmes/612GaBJ9dMFCSU5okPkUc+9pcbWWSK8ZnLw4/rlSwcMyjGojguStEAkr73aUA
	 dFmyUa0tdm3HKAyF0LGo22Jy22nLTGiEsoEvlsXyC2PbiRvG1jQfJneKiY6SwS+zf6
	 ZKmQkzFwk+lEA==
Message-ID: <sashiko-outbox-210869@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] [RFC] instrumented.h: mark instrument_write non-const
Reply-To: sashiko-reviews@lists.linux.dev
To: "Arnd Bergmann" <arnd@kernel.org>, "Andrey Ryabinin" <ryabinin.a.a@gmail.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Marco Elver" <elver@google.com>, "Alexander
 Potapenko" <glider@google.com>
Cc: "Arnd Bergmann" <arnd@arndb.de>, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, "Sven Schnelle" <svens@linux.ibm.com>, "Andrey
 Konovalov" <andreyknvl@gmail.com>, "Dmitry Vyukov" <dvyukov@google.com>, "Vincenzo
 Frascino" <vincenzo.frascino@arm.com>, "Steffen Eiden" <seiden@linux.ibm.com>, "Aleksei
 Nikiforov" <aleksei.nikiforov@linux.ibm.com>, "Andreas Grapentin" <gra@linux.ibm.com>, "Finn
 Thain" <fthain@linux-m68k.org>, "Peter Zijlstra" <peterz@infradead.org>, "Anshuman
 Khandual" <anshuman.khandual@arm.com>, "David Hildenbrand" <david@kernel.org>, linux-s390@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org
In-Reply-To: <20261111092231.2027735-1-arnd@kernel.org>
References: <20261111092231.2027735-1-arnd@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 09:23:11 +0000
X-Stat-Signature: cycqyc45gmr6qosdd7imaxec85r7wa4g
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: ACC4940009
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794475393-662778
X-HE-Meta: U2FsdGVkX19e3F3ONFZjUFx/fDD2mxDoSGuCdUzcbyNDp3HXPWXIA63nVRP20eNAtxMovpVNtn/QvVcNbYY/0AKa48OUKJK5OBxzqF23V67Cv9/Yg/kUsOdfSWgkzO7MWrSzbQtGLTpvbX2h9Lsfdt1T45a2AWfwReYvtWNtZODdRw3K8iyInwZSXgghzNwiS2fFcDAQGIOygkIkQxgUOESijv08giiTRO/SyU8BexaUwXoYhN+yBe1UVlEEzl4TwilwtPKN5mYwXCMb7GNzSVOyC6ZmrGaxfiJa3gu3WspUGevz6dgf8Rlfp0sqF/nesm4a36xuaHyG87cfOLAtjGZph65stOUNEfiH6fyvRdmeAEN0hnVjxPOhK473NRqScbBtYiErb6ulFWN0BSSZbRMdZ+044dGItptb4a8YedkL8OzJi2C4s6/UQVUbmP4l1wZJnJSROVnpm6u5ZmxuHbP0M9bWYBYiY6y9bkkHq/QCHfUB6JahA4fl0Di49lF3SH5uM97wbS8/FqqJcIxDE/fBre0Q4mFX/a6iIPjNbOebUncD7RHJLYOno9O0PEz82eC+dh47qF4iFMPDugyP2IW26XsxXgpPYI+vAvOe+eg1LZy47aY51SFhoZ0YzlVw8HMvFyWQYndnhQDa/CPq4VmoJn0DRs+7kQemqD03qBE/GmIdxV9Fk3NMOSyagt6ZRU4WvgzW+qFpdHJeq+NUhCvuXkRfw7prhrWv8sJRYtMl1e5NfamItF3u+Lp98MUZwwhiqD5hNIppDBvvQO8ExlekxOWbtp4clo6iRUZL0wvmXCJ72DLWOkWJ9D3sbeIpRlb/uG7OZa880Gyqy9jQ5fZTh4ematWpokFQGkaoKc0obOcEDJ6ldJNsabgIjmB4P3HBIAyXhEhk9tzocEaF8LFLCxx3gkknlMuKvtLJi4Xnj3/mKEjXdjysrnmEyMIRWCUfaV38l7wt82zKB9T
 mWXouIpC
 QHbfeBw3gh+Pi3hhn0ATVhYVAxQBoPzbLE26qnlPj8NU+6CDymLsTf3QobIBBk76kr8l3NB+HLtODdd18wpG9VvIRQri0xv/oXbp6mA4WBrY5Dy1w3oRS5qy7oK0flgK06MHqY3S9Vxg7BmAs0ImnMa5k18ndD5jcjSl13bDbEsbHULPYtD3iRiotiVMjbU87EwLw9dcXsfTRURUmDVcHKJInr0g8cOADAgm++aMpTtmDDHHl1Xxdo7vPiYuIqaiz2pC+zeV8pEDxOjOs1hrGlRpIgnnSB1guTGooCsoTrWd5+FF+NHowZlPnJynqhGLnywG8ye0y7+b+WbROY3HhOoTJDXhy36D1mxHWFHM/eGbikC3hmEGbwvKn90oPXgccfx9otIb3KgNR9B44mrxRyP0ItPuul5axqnNoZ3pAuGFz4POPocw4blLhBZmwbJHtSJ3WoQLbDbVpMJTrgoII5aB8/mh8+m4jt3JXQivYdW8Y3HYfHED7LnxSfZ96WYzsWdqLwzP+iZuPy254dgIYJQlFkBUkmiBPlHYYOXBu9fNa5MviDvrqm5NmONodFVRwckl1lYXpYMdwpJ9YQg8QrqQX3Iy0uqGfecUNV9PduZHAQ5eMO0viSKVpvxVtoIW7nRT5ZlV7TCaZZrOucznHR5dph+QsEUuZ1XprsBhw1bZ8jiQ1iDoL19ciw+hdnLF5v8kbddZWvwfRUdTLMdg7q4KHFA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Low] kasan: instrument_read_write() hides uninitialized variables
  under KASAN
- [Low] instrumented.h: inaccurate Fixes tag and RFC question in commit
  message
--

commit e49ee4fd80c81d953b77b9f3cd5a327db833a726
Author: Arnd Bergmann <arnd@arndb.de>

> instrumented.h: mark instrument_write non-const
>
> I got another instance of a -Wmaybe-uninitialized in ntfs, as this is
> the only place that enables the warning:
>
> In file included from include/asm-generic/rwonce.h:26,
>                  from fs/ntfs3/file.c:10:
> In function 'instrument_copy_from_user_before',
>     inlined from '_inline_copy_from_user' at include/linux/uaccess.h:184:=
2,
>     inlined from 'copy_from_user' at include/linux/uaccess.h:222:9,
>     inlined from 'ntfs_ioctl_fitrim' at fs/ntfs3/file.c:78:6,
>     inlined from 'ntfs_ioctl' at fs/ntfs3/file.c:246:10:
> include/linux/kasan-checks.h:38:27: error: 'range' may be used uninitiali=
zed [-Werror=3Dmaybe-uninitialized]
>    38 | #define kasan_check_write __kasan_check_write
> include/linux/instrumented.h:146:9: note: in expansion of macro 'kasan_ch=
eck_write'
>   146 |         kasan_check_write(to, n);
>       |         ^~~~~~~~~~~~~~~~~
> include/linux/kasan-checks.h: In function 'ntfs_ioctl':
> include/linux/kasan-checks.h:20:6: note: by argument 1 of type 'const vol=
atile void *' to '__kasan_check_write' declared here
>    20 | bool __kasan_check_write(const volatile void *p, unsigned int siz=
e);
>       |      ^~~~~~~~~~~~~~~~~~~
> fs/ntfs3/file.c:66:29: note: 'range' declared here
>    66 |         struct fstrim_range range;
>       |                             ^~~~~
>
> The problem here is that copy_from_user() is called on an uninitialized
> object, but the instrumentation passes the pointer into a function that
> takes a const object. gcc deduces that any access to that object is
> undefined behavior and warns about it.
>
> The only workaround I could come up with is to remove the 'const' keyword
> from these annotations, which of course is not great either, as the
> functions do not actually access the data at all.
>
> This also found incorrect 'const' annotations in
> arch/s390/include/asm/fpu-insn.h, which writes to those pointers.
>
> Any ideas?
>
> Fixes: 33b75c1d884e ("instrumented.h: allow instrumenting both sides of c=
opy_from_user()")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

[Severity: Low]
33b75c1d884e ("instrumented.h: allow instrumenting both sides of
copy_from_user()") only renamed instrument_copy_from_user() to
instrument_copy_from_user_before().  The const void *to parameter calling
kasan_check_write(to, n) was introduced in 36e4d4dd4fc4 ("include/linux: Add
instrumented.h infrastructure"), and __kasan_check_write(const volatile void
*p, ...) was introduced in 7d8ad890dad0 ("mm/kasan: introduce
__kasan_check_{read,write}").  Also, the "Any ideas?" question from the RFC=
 is
still in the commit message.

> diff --git a/include/linux/instrumented.h b/include/linux/instrumented.h
> index a1b4cf81adc2a..d28aa6b0aeb8c 100644
> --- a/include/linux/instrumented.h
> +++ b/include/linux/instrumented.h
> @@ -36,7 +36,7 @@ static __always_inline void instrument_read(const volat=
ile void *v, size_t size)
>   * Instrument a regular write access. The instrumentation should be inse=
rted
>   * before the actual write happens.
>   */
> -static __always_inline void instrument_write(const volatile void *v, siz=
e_t size)
> +static __always_inline void instrument_write(volatile void *v, size_t si=
ze)
>  {
>  	kasan_check_write(v, size);
>  	kcsan_check_write(v, size);
> @@ -50,7 +50,7 @@ static __always_inline void instrument_write(const vola=
tile void *v, size_t size
>   * Instrument a regular write access. The instrumentation should be inse=
rted
>   * before the actual write happens.
>   */
> -static __always_inline void instrument_read_write(const volatile void *v=
, size_t size)
> +static __always_inline void instrument_read_write(volatile void *v, size=
_t size)
>  {
>  	kasan_check_write(v, size);
>  	kcsan_check_read_write(v, size);
> @@ -92,7 +92,7 @@ static __always_inline void instrument_atomic_read(cons=
t volatile void *v, size_
>   * Instrument an atomic write access. The instrumentation should be inse=
rted
>   * before the actual write happens.
>   */
> -static __always_inline void instrument_atomic_write(const volatile void =
*v, size_t size)
> +static __always_inline void instrument_atomic_write(volatile void *v, si=
ze_t size)
>  {
>  	kasan_check_write(v, size);
>  	kcsan_check_atomic_write(v, size);
> @@ -107,7 +107,7 @@ static __always_inline void instrument_atomic_write(c=
onst volatile void *v, size
>   * Instrument an atomic read-write access. The instrumentation should be
>   * inserted before the actual write happens.
>   */
> -static __always_inline void instrument_atomic_read_write(const volatile =
void *v, size_t size)
> +static __always_inline void instrument_atomic_read_write(volatile void *=
v, size_t size)
>  {
>  	kasan_check_write(v, size);
>  	kcsan_check_atomic_read_write(v, size);

[ ... ]

> diff --git a/include/linux/kasan-checks.h b/include/linux/kasan-checks.h
> index 3d6d22a25bdc3..90b878b876f5c 100644
> --- a/include/linux/kasan-checks.h
> +++ b/include/linux/kasan-checks.h
> @@ -17,13 +17,13 @@
>   */
>  #if defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)
>  bool __kasan_check_read(const volatile void *p, unsigned int size);
> -bool __kasan_check_write(const volatile void *p, unsigned int size);
> +bool __kasan_check_write(volatile void *p, unsigned int size);

[Severity: Low]
Does removing const from __kasan_check_write() suppress legitimate
-Wuninitialized and -Wmaybe-uninitialized warnings for callers of
instrument_read_write() and instrument_atomic_read_write() when KASAN is
enabled?

When a local variable's address is passed to an external function taking a
non-const pointer, GCC assumes the call may initialize the object.  Because
instrument_read_write() and instrument_atomic_read_write() call
kasan_check_write(v, size) before kcsan_check_read_write(v, size) and before
the caller's read-modify-write operation (such as oldp in try_cmpxchg()),
uninitialized read-modify-write operands will be treated as initialized by
__kasan_check_write().

07a1a6562ce2 ("kcsan: Silence -Wmaybe-uninitialized when calling
__kcsan_check_access()") avoided the same fs/ntfs3/file.c warning for KCSAN=
 by
keeping const volatile void * on the external function and wrapping the
pointer in absolute_pointer() only in the write-only macros while leaving
read-write checks unwrapped.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111092231.2027=
735-1-arnd@kernel.org?part=3D1

