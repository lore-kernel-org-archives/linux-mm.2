Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 468F9E67482
	for <linux-mm@archiver.kernel.org>; Sun, 21 Dec 2025 14:07:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24A346B0005; Sun, 21 Dec 2025 09:07:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F8356B0089; Sun, 21 Dec 2025 09:07:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F79E6B008A; Sun, 21 Dec 2025 09:07:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F21056B0005
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 09:07:22 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6574D8B348
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 14:07:22 +0000 (UTC)
X-FDA: 84243655524.20.941670C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id D1C644001A
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 14:07:20 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gHqp7gjk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of alx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=alx@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766326041; a=rsa-sha256;
	cv=none;
	b=bgMcVvlBwErqKV6mssMzAzQjPDhQ8Wj+fBOU1M/TjsJkcS2BhSRQ9zJDQP0g+SCuiWk5Rz
	R6x2+794UjyK4W4EvRI9zSDgVJyXI6UhUbRCmmv8oF6OOuMWi04aJTKzqr//COYAI2AC3g
	xHbyeVd/PJCXT14Zf98HqU/TV1Od7kE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gHqp7gjk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of alx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=alx@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766326041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Up3lzUA+b75W/MTwqu9jDsDOSOxImlh696tTADVHFQc=;
	b=eQSIrCGKd16tDF3pbGPk9+uUwW0Cea54dxfBszBaw1bt15UW40fQCvxtFEuIQu0VmvADuo
	8asGa8wV0eer7y1WrHkwefn1NKKjffGCySQxOxZXrF2QTY3KhMSRrUns7lpzQ5oUArykrL
	jJkKcm8lExT/w4RiPuhC7hc9LsvtbKE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 96C634001A;
	Sun, 21 Dec 2025 14:07:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4380C4CEFB;
	Sun, 21 Dec 2025 14:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766326039;
	bh=jlEdX7ss9VtYw9IGwQ7RQSOLbQ4LFNrQ1j0ktaihUNY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gHqp7gjkWAA3IRhr4XOpB+CAoGi+o5mE50OASMRNr+zINsr1xyhBmPj5knmVXnHNx
	 AkIhp55AzdFpzMR0XnIP/yTJA110Sufeas1dwO4fgIRJ9qX0e+Ahd1FPDyXmgHXlGs
	 SbK1SwxU4M+fPxM2DQZOaA3BbhIeebneE0NeqU2so9vB6yZdsRhSMkDdo1kIccw3jA
	 vU1Oy0jNy1LbrsAbEM3qvoO1kOD/e+tf9GD4xg222UUIQQKvFWYAT2ya+hl2y9O547
	 ZljF7U8TJpM8hyhdhfw1DZeLF5cB+FO4hS3uyXp7F8L+2C8uuhuIDnjO7iyg7vMmNd
	 KJx7q3eimBPxg==
Date: Sun, 21 Dec 2025 15:07:14 +0100
From: Alejandro Colomar <alx@kernel.org>
To: Kees Cook <kees@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Christopher Bazley <chris.bazley.wg14@gmail.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
	Marco Elver <elver@google.com>, Michal Hocko <mhocko@suse.com>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Jann Horn <jannh@google.com>, 
	"Maciej W. Rozycki" <macro@orcam.me.uk>
Subject: Re: [PATCH v5 4/4] mm: Use ARRAY_END() instead of open-coding it
Message-ID: <aUf6xwicMCxL28Yp@devuan>
References: <cover.1758806023.git.alx@kernel.org>
 <cover.1765406336.git.alx@kernel.org>
 <e7bde864b0394dd0946b5227c6afac7c05560654.1765406337.git.alx@kernel.org>
 <A17C0418-E304-43DF-A6AB-0F142D7B8764@kernel.org>
 <lo6fdczvfjb5q44euckxi5thjrply4wqk62ori4slz54ivdswj@3c234g733gzq>
 <202512101736.DE24BE89@keescook>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="aunnpwbmonbqjh5u"
Content-Disposition: inline
In-Reply-To: <202512101736.DE24BE89@keescook>
X-Rspamd-Queue-Id: D1C644001A
X-Rspamd-Server: rspam03
X-Stat-Signature: eysasknifha8ud4z7mok3xi6cghmur6g
X-Rspam-User: 
X-HE-Tag: 1766326040-346994
X-HE-Meta: U2FsdGVkX1/jwlE95pDc6zu4rBQZV6Pd7ebdUxjYFyPqLWD6Bf0KDT9TKTgiNfJOIRCcJj9ZCZ0btZ5DXUQXjkNFl2pL8wII7gf5toZqSRrL4Gr7wA4ao47ZPhECwk/b0aJIu1i+CetZ5YVv4H0wFN5VwmsZ2ibQ1Z18yKxgBoKvQNbgu6TTD/DAp3br2ihKFxqg3Kc99vZoRhaTxh1RZ+1TohyEBgcpTFsJaZ19LId8BlrNuVnK0hcLjN2Z8LfdXgTNa9Gx+hM+40NXLW5KhIi07jIWPla00kiEdTUx0oVdYCKxUiZrMYTF3Yyx3BK+Pjxv5HovHDgW067nm5sEVeLq9vVMUp3oIXXsTZBcq8tV98K0OYhBDQvvky7TZkt8dJ2CP52I35Epm+jP+Fhqizeh8uHMNGx0LjiRmjG82pxSr0jO2WahTYxvZAq2DHLYRkUuFp4q7b9yoKqgNxPqgof9vLvLmwFmg9Pf2+UbH7rPvCBfl9iP71fknWRQujmBOpyK2SJLbyVZS+Nx0WIw23Lped3YRDXq1WldojTNBxqz/M2D7yrzclPPoFVQjZvoGE6JzMFTDCBFnjWJmVBajNH6o3Q3Ubfb2zd8bYe96e5c6Pm7HgnpgpK0vJJd8LTIej7dktct0ukKqEIY4VUlMoAZsimD48dhgHE2lh74c8Cb0GWb1kW8FDAwCTvrNRebZDcsycrnuyDjQqo8TpuEjOWOi+JiUHPJczHv9sItnAceTQuRNylpOkypXmFhNj1kdQ7t+dpsJIyu09wtLwCBiV2gUQX+QhJdgaa+7K1U6uxWpoblVuYxl/p25wDkS/wXRDAoiYOdkjPqV6wM1MY/4ZYXvMMomOnbcRi5I+lBre2AfMBNAsqAZZ2P23u4/TOlbmm0ERX9uF1ZhI4W8Y0YE9tP+lGjU5p98OnDwCa3OE3hCeQwFe2hXx0zhX14hMEvrpMJxfBqURB5GHdqkYq
 6bNBIzKt
 jTSdxH2TjWtTDtVdXYuA+Uv83Kfx4OZ/3L9WS1TKrhJZNmm3N3pFOiE57X/WyxO4xy5UJxLd4iKIiUNUJkk8KHbHrJrKjXpJcMu3/VeeGGpolVJ3Jud4o8EpNTF/fyGddLvyu2xZ+ONHyjis=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--aunnpwbmonbqjh5u
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
From: Alejandro Colomar <alx@kernel.org>
To: Kees Cook <kees@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Christopher Bazley <chris.bazley.wg14@gmail.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
	Marco Elver <elver@google.com>, Michal Hocko <mhocko@suse.com>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Jann Horn <jannh@google.com>, 
	"Maciej W. Rozycki" <macro@orcam.me.uk>
Subject: Re: [PATCH v5 4/4] mm: Use ARRAY_END() instead of open-coding it
Message-ID: <aUf6xwicMCxL28Yp@devuan>
References: <cover.1758806023.git.alx@kernel.org>
 <cover.1765406336.git.alx@kernel.org>
 <e7bde864b0394dd0946b5227c6afac7c05560654.1765406337.git.alx@kernel.org>
 <A17C0418-E304-43DF-A6AB-0F142D7B8764@kernel.org>
 <lo6fdczvfjb5q44euckxi5thjrply4wqk62ori4slz54ivdswj@3c234g733gzq>
 <202512101736.DE24BE89@keescook>
MIME-Version: 1.0
In-Reply-To: <202512101736.DE24BE89@keescook>

Hi Kees, Andrew,

On Wed, Dec 10, 2025 at 05:37:13PM -0800, Kees Cook wrote:
> > > Are there other open-coded instances that could be replaced? This see=
ms like a great task for a coccinelle script.
> >=20
> > There are many, but I wanted to keep them out of this initial patch set,
> > to make it easy to apply.  When this one is applied, I could work on a
> > second round that replaces more of them with coccinelle.  This is just
> > for showing that this is beneficial, and to make sure that you ask for
> > more.  :)
> >=20
> > Also, it's easier if there are few maintainers that would block an
> > initial patch set.  If restrict the patch set to a few files, I don't
> > have to deal with many of them.  Once I get used to this, I'll deal with
> > all of them.
>=20
> Sounds good!

Now that the first patch set has been merged, I'm working on a second
round.

I've written a semantic patch:

	$ cat src/spatch/array_end.sp=20
	@@
	expression a;
	@@

	- a + ARRAY_SIZE(a)
	+ ARRAY_END(a)

	@@
	expression a;
	@@

	- ARRAY_SIZE(a) + a
	+ ARRAY_END(a)

	@@
	expression a;
	@@

	- &a[0] + ARRAY_SIZE(a)
	+ ARRAY_END(a)

	@@
	expression a;
	@@

	- ARRAY_SIZE(a) + &a[0]
	+ ARRAY_END(a)

	@@
	expression a;
	@@

	- &a[ARRAY_SIZE(a)]
	+ ARRAY_END(a)

Apart from the cases covered by this semantic patch, I've found one case
which needs manual intervention (I don't know if a semantic patch can
handle this case):

	diff --git i/fs/proc/base.c w/fs/proc/base.c
	index c5114e9a0323..e99c8cad49c3 100644
	--- i/fs/proc/base.c
	+++ w/fs/proc/base.c
	@@ -2876,7 +2876,7 @@ static struct dentry *proc_##LSM##_attr_dir_lookup(s=
truct inode *dir, \
	 { \
		return proc_pident_lookup(dir, dentry, \
					  LSM##_attr_dir_stuff, \
	-                                 LSM##_attr_dir_stuff + ARRAY_SIZE(LSM##_=
attr_dir_stuff)); \
	+                                 ARRAY_END(LSM##_attr_dir_stuff)); \
	 } \
	 \
	 static const struct inode_operations proc_##LSM##_attr_dir_inode_ops =3D =
{ \

Anyway, I made sure there's only one of these.  There are no similar
cases in the kernel.

Here's a summary of what the semantic patch finds:

 arch/arm/kernel/hibernate.c                               | 2 +-
 arch/arm/kernel/reboot.c                                  | 2 +-
 arch/arm/mach-omap1/clock_data.c                          | 2 +-
 arch/arm64/kvm/sys_regs.c                                 | 2 +-
 arch/mips/fw/sni/sniprom.c                                | 2 +-
 arch/mips/include/asm/sgiarcs.h                           | 2 +-
 arch/riscv/purgatory/purgatory.c                          | 2 +-
 arch/s390/purgatory/purgatory.c                           | 2 +-
 arch/x86/kernel/cpu/hypervisor.c                          | 2 +-
 arch/x86/purgatory/purgatory.c                            | 2 +-
 block/bio.c                                               | 2 +-
 crypto/adiantum.c                                         | 2 +-
 drivers/base/regmap/regmap-spi-avmm.c                     | 2 +-
 drivers/cpufreq/sa1110-cpufreq.c                          | 2 +-
 drivers/firmware/efi/libstub/vsprintf.c                   | 2 +-
 drivers/gpu/drm/i915/selftests/i915_vma.c                 | 2 +-
 drivers/gpu/drm/xe/xe_guc_ads.c                           | 2 +-
 drivers/md/bcache/btree.c                                 | 6 +++---
 drivers/md/bcache/util.h                                  | 2 +-
 drivers/md/dm-raid.c                                      | 6 +++---
 drivers/mtd/devices/mtd_dataflash.c                       | 2 +-
 drivers/net/ethernet/marvell/mvneta.c                     | 2 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c           | 2 +-
 drivers/net/ethernet/sfc/falcon/nic.c                     | 8 ++++----
 drivers/net/ethernet/sfc/nic.c                            | 8 ++++----
 drivers/net/ethernet/sfc/siena/nic.c                      | 8 ++++----
 drivers/net/wireless/intel/iwlwifi/mei/net.c              | 4 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c         | 3 +--
 drivers/tty/serial/msm_serial.c                           | 2 +-
 fs/erofs/zdata.c                                          | 4 ++--
 fs/proc/base.c                                            | 6 +++---
 fs/proc/namespaces.c                                      | 2 +-
 kernel/bpf/log.c                                          | 2 +-
 lib/crypto/tests/hash-test-template.h                     | 4 ++--
 mm/kmemleak.c                                             | 2 +-
 mm/memcontrol-v1.c                                        | 4 ++--
 net/ipv4/tcp_input.c                                      | 4 ++--
 tools/bpf/bpftool/tracelog.c                              | 2 +-
 tools/testing/selftests/bpf/prog_tests/select_reuseport.c | 4 ++--
 tools/testing/selftests/bpf/prog_tests/sk_lookup.c        | 8 ++++----
 tools/testing/selftests/bpf/prog_tests/sockmap_listen.c   | 8 ++++----
 tools/testing/selftests/bpf/prog_tests/sockmap_redir.c    | 8 ++++----
 42 files changed, 72 insertions(+), 73 deletions(-)

I applied the semantic patch as

            $ time find * -type f \
            | grep '\.[ch]$' \
            | xargs grep -l ARRAY_SIZE \
            | xargs grep -L '^#define ARRAY_END' \
            | xargs grep -l \
		-e '+ *ARRAY_SIZE' \
		-e 'ARRAY_SIZE(.*) *+' \
		-e '&.*ARRAY_SIZE' \
            | xargs spatch --sp-file ~/src/spatch/array_end.sp --in-place;

How should I proceed with this?  Should I send separate patches for each
subtree?  Or should I just send the semantic patch and let maintainers
run it?  Or should I senda big patch?

Also, I don't know if all of those files are able to use
include/linux/array_size.h.  Do tools/ need a separate definition?


Have a lovely day!
Alex

--=20
<https://www.alejandro-colomar.es>

--aunnpwbmonbqjh5u
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmlH/xIACgkQ64mZXMKQ
wqmWvQ//ZWWq8so/sNRMW71qo2vyQxrd4nLS7/rjS7CXtXQw5FTHU/p3XvJ6S36w
050CAxDfXwMXJX8KEsmSCacpjSJTBlLjSuLpONrrV6KxvQDvW9KLttmADaPrX6Jc
A/qwu7qbvBUgaZPrJxmSw5EhfY+EYwDa10nbRcvpHR2mO8F9COjF8hhCzEIUJq8l
khcOpjbqNQbp8zGjGH+oT8VhmlQqWMn2wobsG5dholavIzciybJ+edCKCAmm1uj7
8NZOlodce5uH34aPcA+eVpFMXjpIkG7F4Z/pjsHU9MRwVhXkGXF27D2f1Xm/doLK
MJ+ueTyemJHlqzFjR6rTsaV14S2q7KW6PtxNkNJpozITeaNOAocRHrsx6Uk5TGwa
EcmT24OEijm4TMqpKJg4ReIwRgtnfIwmG25eE/lj/ljyrosrMTDFGCP7y26RJfnS
wHvigwb45laEKPeviBI353/XOogjUG6++Y6QSEKyW0EQFXaFQtAHP8KkHISxn/We
VyDNgoxJOY4Eq4DyC51xXOFHwLBGu42z0JDFLFt96NMXz9HkjR/3qvhu6BPn2BAZ
pxdodRVLaYV9FKo6ELXWrfc8LSSEHgrI5VlrLQbRtCz9jWdQssr4RvDwPaFN/WRg
CQOKiyrQau6SJZs2eliW5Zw3ctglGNAdMPgyIEAZkv53wW6CAzQ=
=+7F0
-----END PGP SIGNATURE-----

--aunnpwbmonbqjh5u--

