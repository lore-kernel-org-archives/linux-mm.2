Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80AD9C87FC5
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 18:34:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00B528E00AB; Thu, 24 Jul 2025 14:34:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F23C38E007C; Thu, 24 Jul 2025 14:34:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E12F78E00AB; Thu, 24 Jul 2025 14:34:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CDAB68E007C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 14:34:47 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6EBDF113538
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 18:34:47 +0000 (UTC)
X-FDA: 83700009414.07.E895465
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8DDCD40002
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 18:34:45 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=Zz8vHLUc;
	spf=pass (imf11.hostedemail.com: domain of jeffxu@chromium.org designates 209.85.210.51 as permitted sender) smtp.mailfrom=jeffxu@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753382085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1hy19XYLYjogQ/4nZ2jE5q9A8m7TkG/b0NhBVuhbg9g=;
	b=eyQdpNjTYwEtQNvUDFk4qzVxFBl/Y+R5BXTgz0fW0Fnq8j8bJWFp2aQ08aJsnDs0aUJ6/c
	55mcbvCUzni/Cupj4lHEIla4daKMeVa3tx1n3Rrl893SZCq6j6NPQcCL89EUGR8alXj4Pn
	15xmrtXy99rwWrT/7FSIroNoIKmABCE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753382085; a=rsa-sha256;
	cv=none;
	b=79OTyy00slzy2KjWWLV5FAEsXVDL1F5kPqutFFWDtw93iyAqyC/7qd4hkb2Eza4nwOmbJ/
	t9dCxdTlwtm4G1kP0KuZD+wRQHk7AeFuTNY60Etn6fmlNnXnQOnGvNefDn89sw6dYThlhm
	dtjwTWr0sTGQWp2dFDrMeZ0KU2eI9hE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=Zz8vHLUc;
	spf=pass (imf11.hostedemail.com: domain of jeffxu@chromium.org designates 209.85.210.51 as permitted sender) smtp.mailfrom=jeffxu@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-73e5487c4d7so50710a34.0
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 11:34:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1753382084; x=1753986884; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1hy19XYLYjogQ/4nZ2jE5q9A8m7TkG/b0NhBVuhbg9g=;
        b=Zz8vHLUccPPDSGjv/vbUXDdqFc1arPiy0BTsjaFa2Qn5iDRJfbCykc41dqiKt7oVfE
         YsrtrHQrX9zaPRtoZMbiPl2lnTa9gkS2bAkinKoFiObKTHvr5NEE6j7asvP4QyQLnwVK
         l+jbygoeb3laczEZmYBl2fZ9WawTZrY/1oFF0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753382084; x=1753986884;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1hy19XYLYjogQ/4nZ2jE5q9A8m7TkG/b0NhBVuhbg9g=;
        b=TX+EJXUZHqWBxyDghSF/+Sc0iDiOh6pM1vk1FOgOspTPec5zEMx5Skwx0UBubCogVJ
         tbWempzuiRacKBnxJ8Xs//ovQIdeWMEgYP8hI4GQctHkgVhdxa6AINfLqRLtsLZ8IUJC
         jBR+Aczx49C7PUI9t9yVvLuCK4uuvlgA66H86UCO9vbD/AXAqcIzhv9LOHex5PqxACN4
         +wXzUl9E4hda5CQ4tAL1DufEmZOtUDhACEB7xHT38Dyo1OZ1Ls08AHFBZfFn0jF8gNpo
         G2eOSDcgvSEGFqcwv2qKYhVt0NQ5hy67YTZHGCLG2EShSqhqYdNnJ4dFe67DgZb9uF6Q
         DOVQ==
X-Forwarded-Encrypted: i=1; AJvYcCXQACjNBC4Y1VGTK/CXeOkZvoeF6gNlwLpsvqbTnkAQLsB2UQbykSvfzpb41dGD3RSlQ9W8zjWiQA==@kvack.org
X-Gm-Message-State: AOJu0Yz2M7IjSE0KWE0fS9KHYlA1GVT6F09Ay4vKDCgDfoidR+qbg5yQ
	env8yIcj+qTsCr9jT+stLTjDrhTUIDxlviyVIEHPBekQm+gavqtjNEFTA4mH3sta53SJAGKSsSV
	BQuNR61DkOSzUpDZlr/JMi/qoHsrwyntqQ9krvSR5
X-Gm-Gg: ASbGncth0PVyfHHRue4YkUcJ2cyQGf0jwUQbcjhKUb6I9kOLmt5/UdDvFBblBZZCbRI
	zJt59P+//SgkfBus+y83ds8BQN5d2gebV/QUb+9etsT5ekVEL6VnmnzG5CB9dmgjRfQ03beDnoW
	zwwhYfPOaUFnkcwhHh56f5eTxiKzjbfdV6LmxTsdTGCLdHsuM7QdAsXxqsZQf5IX8a1AHoIgcbr
	PVhmiBV3zMGzGtJLScfK8rAgmLxJ3qwmhGf/DYdywRPEog=
X-Google-Smtp-Source: AGHT+IExCMgwSyyh6fZVQDIoYTaFuZdsE+zuKDoymTdwp+61+7Vy2vinFRkoIRfsms0/uxkszHE5F4pscxTm40rOS1c=
X-Received: by 2002:a05:6870:bb17:b0:2c1:5011:56e2 with SMTP id
 586e51a60fabf-306c6ebb4fcmr2003452fac.3.1753382084438; Thu, 24 Jul 2025
 11:34:44 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1752687069.git.lorenzo.stoakes@oracle.com> <d0e9b39c9d1abceb0ffac341c6fae96186c5d843.1752687069.git.lorenzo.stoakes@oracle.com>
In-Reply-To: <d0e9b39c9d1abceb0ffac341c6fae96186c5d843.1752687069.git.lorenzo.stoakes@oracle.com>
From: Jeff Xu <jeffxu@chromium.org>
Date: Thu, 24 Jul 2025 11:34:31 -0700
X-Gm-Features: Ac12FXzjuQzbVjnKfCaBaTm_N9qyhzxlzeAH9n1camAeM3s5LIPyo6jbvFBauj0
Message-ID: <CABi2SkXa2n+csjXgb0UWQFi-f5q2caazRkswAGY1LJ9N91m8UQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/5] mm/mseal: always define VM_SEALED
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	David Hildenbrand <david@redhat.com>, Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Kees Cook <kees@kernel.org>, linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 8DDCD40002
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: pqypwo6ryn5tdcqd65m8hww5afnfzm8p
X-HE-Tag: 1753382085-137226
X-HE-Meta: U2FsdGVkX18QsuoDMrn1E75h066VGiHSYL9sRnyWFCZeb9i2837e+P//ab9H/sWfqTi8aLik0Ok2e9Mfm22MVZuK8yI25pMqVOmLFOhjZR8G1c9CtE/KKV7bK1xgxZ7Vn7Ysrwz8I4j7zncZj9NkwoX3Q5czLndL4Ii/PxSxHu+vjNwVqJXlaqkwitczQC3DUZY0mEDQmd10mQ0jAp4gvYPJzl6q3cpn0+Z/HCXgPO5X932BsadMS2dolJwUasgKeJ6wA4plyQvl32qrxfXi3KRX0/if/1BtxM9nUX72D69atKkk49YOKguduynlk2oxHxYVrfkgfIM0RD/CfpjN36hEC2x5zf97RN170D6q3I7mkcPtiP5E2WsI9RGSqckDUvvoh1VYgMyG7nM63EbWNLymi80Vs6xHZ89iaensdIWXPOiUCqwlpWMfnYNAwnJ7p+Lf0AfzidhTRHuSlBEgAhTuHmzp89uPSLAtCeaiI+UKvRPfNQ6+yvyrXh1ArGQ81GcfGZR8gW5yCdPQIKP7w8BbuBi1CWzaS5kjQNOOfLi5YKI2COmvm0ly5bEC/Kwsun6cX1Oir9SZZaAoqB7M/ZSfQF/Whe2ttb2LnScCupBKHREhAaffdhP5XjbMfZdBugYuHzwgpBbkaWnOjBSlpJjo85qNdIRQ5gNe5g4kg+HpyCr101ObPXVjZqKkcHhOBTvIBrxzmV3HvfRfV3b3xhEcE6wanucOVncDdkh3IEBsU1Zrf7ZIhksjCyx7Gs2zwCgoshJIz/hNXPyR0jVnQUUHc+IUFoqHi2HYeQxYwwW7IXzWzsZBqUutxB0q9gwEZHazAeB3WVmtB/vyKgfCm525+Tlee+SzExX8NQLM/H0gSgh+PyHvEHzIGtd2HL3VpNZNCXmqCHIymgUj9T31PaDhHZE2unQ/0LdK2pJN36L6jsxeCKll8XFLBKS9f6PAyY1zc/w2RZ7M69YWWPB
 5CmIIOtX
 m/bfxMo1cigwB0JwaQ0Bnzfl1C8zQtTrn1EvYYASFwtDu4PgccH2rUGYPBiql6GeCv1jZP35IivDwoPKrblZY+K6/K11TBvj8+n/5dfoGTIz52ngzsSnXRHQ8fJWM8IT/gMKDucRjRFjYzg+DJisnHWW+t/xbO756FjD9oYl7+Fwb1U2UEr+rCj/GBARmL7uFvKgPEd/KV7jMyuoffXV+fLJgL6Zu6Bz9EXZsN092otjYjSuBv2y//foIK4HdZ2O//d0EFb+jbYj0RbamlPoY48SpUntlVZmpibj8CzHUKC5SvXLCE8v7MqsTrwomBBJLP91QTH5MLWDtSOm3QtA1/Lpc5eXhxugmlT+5UEBkBzIXs3ReArVeBh69YHjbLzviDILa
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Lorenzo,

On Wed, Jul 16, 2025 at 10:38=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> There is no reason to treat VM_SEALED in a special way, in each other cas=
e
> in which a VMA flag is unavailable due to configuration, we simply assign
> that flag to VM_NONE, so make VM_SEALED consistent with all other VMA
> flags in this respect.
>
Originally, I wanted to avoid using VM_NONE for VM_SEALED to catch
compiler errors in 32-bit builds. This would serve as a safeguard
against inadvertently using VM_SEALED in code paths shared between
32-bit and 64-bit architectures.

Take an example of show_smap_vma_flags [1] :

#ifdef CONFIG_64BIT
[ilog2(VM_SEALED)] =3D "sl",
#endif

If a developer forgets to add #ifdef CONFIG_64BIT, the build will fail
for 32-bit systems. With VM_SEALED redefined as VM_NONE, the problem
will go unnoticed.

This coding practice is more defensive and helps catch errors early
on. It seems that you're working on introducing VM_SEALED for 32-bit
systems. If that happens, we won't need this safeguard anymore. But
until then, is it OK to keep it in place?  That said, if VM_SEALED
support for 32-bit is coming really soon, we can merge this change,
however, perhaps you could update the description to explain why we're
removing this safeguard, i.e. due to 32-bit support will soon be in
place.

Link: https://elixir.bootlin.com/linux/v6.15.7/source/fs/proc/task_mmu.c#L1=
001
[1]

Thanks and regards,
-Jeff
> Additionally, use the next available bit for VM_SEALED, 42, rather than
> arbitrarily putting it at 63 and update the declaration to match all othe=
r
> VMA flags.
>
> No functional change intended.
>
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> Acked-by: David Hildenbrand <david@redhat.com>
> ---
>  include/linux/mm.h               | 6 ++++--
>  tools/testing/vma/vma_internal.h | 6 ++++--
>  2 files changed, 8 insertions(+), 4 deletions(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 805108d7bbc3..fbf2a1f7ffc6 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -414,8 +414,10 @@ extern unsigned int kobjsize(const void *objp);
>  #endif
>
>  #ifdef CONFIG_64BIT
> -/* VM is sealed, in vm_flags */
> -#define VM_SEALED      _BITUL(63)
> +#define VM_SEALED_BIT  42
> +#define VM_SEALED      BIT(VM_SEALED_BIT)
> +#else
> +#define VM_SEALED      VM_NONE
>  #endif
>
>  /* Bits set in the VMA until the stack is in its final location */
> diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_int=
ernal.h
> index 991022e9e0d3..0fe52fd6782b 100644
> --- a/tools/testing/vma/vma_internal.h
> +++ b/tools/testing/vma/vma_internal.h
> @@ -108,8 +108,10 @@ extern unsigned long dac_mmap_min_addr;
>  #define CAP_IPC_LOCK         14
>
>  #ifdef CONFIG_64BIT
> -/* VM is sealed, in vm_flags */
> -#define VM_SEALED      _BITUL(63)
> +#define VM_SEALED_BIT  42
> +#define VM_SEALED      BIT(VM_SEALED_BIT)
> +#else
> +#define VM_SEALED      VM_NONE
>  #endif
>
>  #define FIRST_USER_ADDRESS     0UL
> --
> 2.50.1
>

