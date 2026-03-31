Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73273109B468
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 13:18:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B66606B0092; Tue, 31 Mar 2026 09:18:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B17316B0095; Tue, 31 Mar 2026 09:18:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2D566B0096; Tue, 31 Mar 2026 09:18:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8E12E6B0092
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:18:00 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 28292C3D23
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 13:18:00 +0000 (UTC)
X-FDA: 84606411120.06.ADB05B4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 36154A000B
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 13:17:58 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Zf5cKfGW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774963078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oQsMOZDk10HjuVfhX4TeooXiXH2Z/rcubUgiihqPTRQ=;
	b=FIZ75X70U2nLncjVm3+BZvUiSCEZyoqLksW79mrxIftQvf/2PiugCLNM77d76+kXPR9q61
	FKS+Kt1p+XQOGAzVJOhg+5wSI9mFVxshjVVw+bv3eHQEY8l24UZRFkB5p73dH2vVIOgNtH
	HXsglyRuQDSiMvBrWbrCESPcJWoPWkU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774963078; a=rsa-sha256;
	cv=none;
	b=TU+pgWxnqTahO6CD1XjJzO9pgfAWKY/g5T/iwxH1RwULIBSUtnUeKtBVSyexlQyJ6keH8A
	7YQQIkZMyscIlhWqjDFHKTJxfBueA+YryPlLKdXNSrYgU+ndQ/n6tBo9xHkQ+/Pfkw9GOC
	Ls4IWwpv01CJKHH3Yat+16Gsg4Xvtz0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Zf5cKfGW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D2F8D43C8E;
	Tue, 31 Mar 2026 13:17:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C820C2BC9E;
	Tue, 31 Mar 2026 13:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774963076;
	bh=9/wL842FQNl5t5l6MMhBMfdn5Lvjunxe4vuLlr8hJfQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Zf5cKfGW9vvYM2vUhoO0CKRsoNI5IBCF4kJNwkRx6R7fqSlBM7Dd8ECBY1x4gycHD
	 be1Sk1Wiyo8Ike7Bq7urt3CZ/aBkjRcxNL2ajpZXECrABPh+QQj8hi3pKDsW7s/66r
	 vKcgUpfo6ye9SqtNWfk2So46EUeeXmYRLIfnNt5IfnTo2XoaVS3yQE2gzoYPzHnm9G
	 8GG4+5uEKaa3FcUgYyg44/wRZ/Xz7bTkoii1pKGRNJ1n3D5FBpVBK82f3Y3EclyJ8j
	 m1l9EutWnh1AkjM//qTB7H6hl6J23EVv9G9kObOWof8RQJSmb/9XY8ZhkJhGDp3AgE
	 7vDI0KxZWh7kA==
Date: Tue, 31 Mar 2026 14:17:50 +0100
From: Mark Brown <broonie@kernel.org>
To: Anthony Yznaga <anthony.yznaga@oracle.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, akpm@linux-foundation.org,
	david@kernel.org, ljs@kernel.org, Liam.Howlett@oracle.com,
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com, jannh@google.com, pfalcato@suse.de,
	Jason@zx2c4.com, shuah@kernel.org
Subject: Re: [PATCH v2 2/2] selftests/mm: verify droppable mappings cannot be
 locked
Message-ID: <52bec9ea-5627-4ea2-8f27-f1729957fa47@sirena.org.uk>
References: <20260310155821.17869-1-anthony.yznaga@oracle.com>
 <20260310155821.17869-2-anthony.yznaga@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="xUgacxsbd/IMhxBH"
Content-Disposition: inline
In-Reply-To: <20260310155821.17869-2-anthony.yznaga@oracle.com>
X-Cookie: Do not write below this line.
X-Rspamd-Queue-Id: 36154A000B
X-Stat-Signature: shx71i9ui4xocm3gtijeqq35ocfg9n1g
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774963078-311308
X-HE-Meta: U2FsdGVkX1+pnjU+dbqkQY7ZZ0niMYh80C9bbYQd+JbcCyIIkwt1m9CflrmkYBSwMWfkiV7vjcYxIr7qv0CioT4xnBX7/j29pZazKbOcjhRFGjmnpv4hyvYCQaoxEaRx/m+6xZ8ueLWvvdBilx6HZn42pTwQrWhQqWANe2bCpgVmokzOlVXXmI8NBICR2ywwPg1ZMRVsZbGzYOsLy6L1//sxywqqDCSkMmhvZGdzdpHVAvSYJMuTkN/ctc9LOFtypzC+iDiZ31XMVUhwGQMavZaa8zm+3kggS6CrpAgShO/4/ygo9KSC9W2BVasG69ijNrZjDPLgh+2lBAjlwLmkMY/sxhGrxcNTEDFoPXI7UsFK8rR7vCqhFDOSEygtL6bifR/5Hn/95CvW3KabZzWT20u5BDYGKQyh52rFacXL5h/+A1lJubyXf6ccdGjJYOh6Ku4xD2V6CFw/tzqvckHWxbeKy1XcJ2TSkMA+MNqXcVM9HdN4aZHlpACWA14+gaFLJ6RQmJ/WBMazk7m/L+E7v0FqyRFQgGLRRM4x4LagCnXuJTxFNeAdsULOrlbBEj2Mm/XIgV5Dzsr4C3wdRl9ULOcd6TMi9b6PO2kEWwWChlSD3LIn6hUIyjKvMXgUBqx4V5unfSuosqdFZA3NVM/MHCsS+9yKzc1x+JgeztcbYoIaBMyHWSzN321voioBWHtn1boF7U47Zt5m8iY77UIWOaIlb8QO63YvRvVGNF5Mpd2bPGq3F+a8LV8yYzpRFn30NtGCMH0QjP9dRpTcZ4lpmIoe8/1Es7BwSRN6JGI8MZU63osY9eT8LoDcHJn5KSxW8EOTpXmjV7MJUkG/xAmYVZxhPSWBUePvnMI4tThuxRDncanmiZe9sCj5gOwwsLmTCeGDD8OzcEcI4ACObihIWBQXgNdQwkSmZpSJVYFoWKW+SI1QEAplcS2N4CmDg97RKiYpsWjvLenFX1Zh/Wt
 zowVZOaF
 oiNaiSFJKZs3p8Muq+kkKONW2bpv2097RJ7/9kxFsfNpyC0a5hwCxg+rW7G0aekZF+TZU299sFayXd07nHwDvBMSSqWXrxffWK9wzD95cm5j7hQuqUNz0UR7B0nlpW6ZbpQ9jwYeIKZ3J40WtJOX3sV+Phl1Jno1ZVmPUqg5RVaApqr/IXFX0/b6iy6vuBEugXpCQ4RojtIYuJcS+0k53UuZbbQTdfRQxDI0qY5wFEg5+HxMvUAd75w4A/EwCKXaF1Ok7Be81zc/QPjW8nylrEC5A8b3551SVdUEOwKjALBdmExylQVeouDqY3VDWtKL5vCuCV/MymPsBpRNJ3WArWTuVkZNRZVAKOxR8c+SS0zpwT4u0lFm7Z0HHelu+KsbLoJhfjchk8Xack+tSmF3SNX+aAFsKtZ+F8klhVgNouNK4Q5yYsZgJ0YZ9PJI7qtXC0JCyNHrUhqG14p/R8D91+XvDEVBwxrh2X0+c
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--xUgacxsbd/IMhxBH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 10, 2026 at 08:58:21AM -0700, Anthony Yznaga wrote:

> Verify that a mapping created with MAP_DROPPABLE cannot be locked
> via mlock(), and that it will not be locked if it's created after
> mlockall(MCL_FUTURE).

I'm seeing a regression in -next on 32 bit arm which bisects to this
patch:

# # ----------------------
# # running ./mlock2-tests
# # ----------------------
# # TAP version 13
# # 1..15
# # ok 1 test_mlock_lock: Locked
# # ok 2 test_mlock_lock: Unlocked
# # ok 3 test_mlock_onfault: VMA marked for lock on fault
# # ok 4 VMA open lock after fault
# # ok 5 test_munlockall0: Locked memory area
# # ok 6 test_munlockall0: No locked memory
# # ok 7 test_munlockall1: VMA marked for lock on fault
# # ok 8 test_munlockall1: Unlocked
# # ok 9 test_munlockall1: Locked
# # ok 10 test_munlockall1: No locked memory
# # ok 11 VMA with present pages is not marked lock on fault
# # ok 12 test_vma_management call_mlock 1
# # ok 13 test_vma_management call_mlock 0
# # Bail out! mmap error: Unknown error 524# Planned tests !=3D run tests (=
15 !=3D 13)
# # # Totals: pass:13 fail:0 xfail:0 xpass:0 skip:0 error:0
# # [FAIL]
# not ok 2 mlock2-tests # exit=3D1

Full log:

   https://lava.sirena.org.uk/scheduler/job/2617389#L2426

Previously the end of that test looked like:

# # ok 12 test_vma_management call_mlock 1
# # ok 13 test_vma_management call_mlock 0
# # # Totals: pass:13 fail:0 xfail:0 xpass:0 skip:0 error:0

The new tests do:

> +/*
> + * Droppable memory should not be lockable.
> + */
> +static void test_mlock_droppable(void)
> +{
> +	char *map;
> +	unsigned long page_size =3D getpagesize();
> +
> +	/*
> +	 * Ensure MCL_FUTURE is not set.
> +	 */
> +	if (mlockall(MCL_CURRENT))
> +		ksft_exit_fail_msg("mlockall(MCL_CURRENT): %s\n", strerror(errno));
> +	if (munlockall())
> +		ksft_exit_fail_msg("munlockall() %s\n", strerror(errno));
> +
> +	map =3D mmap(NULL, 2 * page_size, PROT_READ | PROT_WRITE,
> +		   MAP_ANONYMOUS | MAP_DROPPABLE, -1, 0);
> +	if (map =3D=3D MAP_FAILED)
> +		ksft_exit_fail_msg("mmap error: %s", strerror(errno));

All these failures which cause the entire test program to immediately
die seem exceessively strong...

Full bisect log:

# bad: [cf7c3c02fdd0dfccf4d6611714273dcb538af2cb] Add linux-next specific f=
iles for 20260330
# good: [a010730e610019b6d010ec43ce737cb59a37809d] Merge branch 'for-linux-=
next-fixes' of https://gitlab.freedesktop.org/drm/misc/kernel.git
# good: [9be71d462c33b1a00acfa4ab8f0f5332ed592817] firmware: cs_dsp: Simpli=
fy suppressing log messages during KUnit testing
# good: [7b3f8db159f710d432c4edc024fcefa9e62e8b4b] ASoC: fsl_xcvr: add bitc=
ount and timestamp controls
# good: [8fc5c7895185d1119ae76b509892a1d14e0bd483] ASoC: wm_adsp: Combine s=
ome similar code in firmware file search
# good: [981b080a79724738882b0af1c5bb7ade30d94f24] spi: fsl-qspi: Use reini=
t_completion() for repeated operations
# good: [ed0313223ce6514dbd39c049e25f702980d7e3cc] ASoC: codecs: wcd9335: R=
emove potential undefined behavior in wcd9335_slimbus_irq()
# good: [97af961568c8682c44506c9ad4b26c8a5455ec1d] ASoC: cs35l56: Put OTP r=
egister defines in correct address order
# good: [0a208adefecb287d22321054470d4619cb303839] ASoC: cs42l43: Add suppo=
rt for the B variant
# good: [a8075ada4a341ce58ebf8bef0188cefe6c2f6487] ASoC: ti: davinci-mcasp:=
 improve aux_div selection for mid-range dividers
# good: [aa3d0c93a333182e887426366a4f3e5f06ee0d83] regulator: max20411: sho=
w failure on register
# good: [b1ef855c62601ed4de2c4b0ff75a075877e3dac8] regmap: Simplify devres =
handling
# good: [e7662bced2e98ffa2c572126677deb9cf55d43b3] regcache: Move HW readba=
ck after cache initialisation
# good: [ef0b4783afc211a4b120e72b5a57f3d0340a9981] ASoC: cs35l56: KUnit tes=
ts for reading speaker ID from host GPIOs
# good: [96f06d055ca03d1dfb5830fd07ff6eadbd66264c] spi: dt-bindings: mpfs-s=
pi: remove clock-names
# good: [2adac914c72b6cb5aba2612f49050c82aecd498e] ASoC: cs35l56-test: Add =
test cases without onchip pulls defined
# good: [f48e7a246a567e3764112e2463274c479d95cd96] ASoC: soc-core: Use guar=
d()/scoped_guard() for mutex lock
# good: [9891b52ba12e9d5fed5901b6b5f6e0cdcd424390] regcache: Factor out reg=
cache_hw_exit() helper
# good: [e84141846decb77d2826e553318a608b256804e5] regulator: pf9453: Allow=
 shared IRQ
# good: [9ab637ac5d3826606947f4e861107da958eda324] regcache: Amend printf()=
 specifiers when printing registers
# good: [34b4fc44e4f904fbb81335d53163ffdcb0180000] ASoC: soc_sdw_utils: rem=
ove index from sdca codec name
# good: [da37bfe76b5b4ccc01ed8132215098e20d78e5f3] ASoC: cs42xx8: add error=
 checks for constraints in TDM mode
# good: [d3b693a13b39bce16e284e1c737874966b3a96de] spi: spi-mem: clean up k=
ernel-doc in spi-mem.h
# good: [06dba254de95b16e7793224d29daa5195de2e581] ASoC: dt-bindings: nvidi=
a,tegra-audio-max9808x: document additional board pins
# good: [1696fad8b259a2d46e51cd6e17e4bcdbe02279fa] ASoC: sti: use managed r=
egmap_field allocations
# good: [17c6bf433742e0c1ff5ce175145877c0194e4a7a] ASoC: cs35l45: Hibernate=
 wm_adsp on runtime suspend
# good: [2974aa42e6696a1d95b727d677dc01a71af5b998] ASoC: remove snd_soc_pcm=
_subclass
# good: [501efdcb3b3ab099fc0ce2f6e668b1c4095dd476] ASoC: SDCA: Pull the Q7.=
8 volume helpers out of soc-ops
# good: [d90c0f78379454d51a428e312ac6db573060185c] regulator: cpcap-regulat=
or: add support for Mot regulators
# good: [5c74a008ffc62fc57a041602b4517519c8bf9436] firmware: cs_dsp: Mark K=
Unit test suites KUNIT_SPEED_SLOW
# good: [260c3fff1fefc570d8f23e87953e181d7d248861] ASoC: cs-amp-lib-test: S=
top including platform_device.h
# good: [7c12f6ead4672cb08b74e6f6115eb04dca8ccfa4] spi: tegra210-quad: Add =
runtime autosuspend support
# good: [37983fad7f3ef296fa0504c8e945987459dc5487] regmap: define cleanup h=
elper for regmap_field
# good: [e02902dd493bf9c9b05353c761737ac514ad7a5c] spi: add devm_spi_new_an=
cillary_device()
# good: [ada32396f90951e12465224c04742607ca56a982] ASoC: SDCA: Add CS47L47 =
to class driver
# good: [507a071d9868cb60e4e76f8a06fc8eb014f59ae4] spi: pxa2xx: use min() i=
nstead of min_t()
# good: [5ebc20921b7fff9feb44de465448e17a382c9965] ASoC: tas2552: Allow aud=
io enable GPIO to sleep
# good: [fed6e5084894373d76270cad4a32eb6479ad8247] spi: atcspi200: Remove r=
edundant assignment to .owner
# good: [c2bcf62ca75c541ec4297e6ff02a68ddc2e02029] regcache: Split regcache=
_count_cacheable_registers() helper
# good: [171b3663f33e1efdc97f5112f49be10b47b20fa8] ASoC: codecs: aw88261: A=
dd firmware-name support
# good: [bf122191473e26a8f195308b1ba924c98424c8e1] ASoC: rt5677-spi: Add SP=
I device ID matching table
# good: [fbb4c52ccdcb4a612d2b7f800aa57090eeee16d7] regulator: spacemit-p1: =
Update supply names
# good: [0556bb42a84ee391a2145ddba86756f9747bc27f] regulator: pf0900: Make =
regu_irqs variable static const
# good: [d075cef4af6327a5de4bee7bf77591e3201e54f4] ASoC: simple-card-utils:=
 add sysclk ordering support
# good: [78dfbd4ad0be9f51de7b9a19388809254aeccd26] ASoC: Add quirk for Leco=
o Bellator N176
git bisect start 'cf7c3c02fdd0dfccf4d6611714273dcb538af2cb' 'a010730e610019=
b6d010ec43ce737cb59a37809d' '9be71d462c33b1a00acfa4ab8f0f5332ed592817' '7b3=
f8db159f710d432c4edc024fcefa9e62e8b4b' '8fc5c7895185d1119ae76b509892a1d14e0=
bd483' '981b080a79724738882b0af1c5bb7ade30d94f24' 'ed0313223ce6514dbd39c049=
e25f702980d7e3cc' '97af961568c8682c44506c9ad4b26c8a5455ec1d' '0a208adefecb2=
87d22321054470d4619cb303839' 'a8075ada4a341ce58ebf8bef0188cefe6c2f6487' 'aa=
3d0c93a333182e887426366a4f3e5f06ee0d83' 'b1ef855c62601ed4de2c4b0ff75a075877=
e3dac8' 'e7662bced2e98ffa2c572126677deb9cf55d43b3' 'ef0b4783afc211a4b120e72=
b5a57f3d0340a9981' '96f06d055ca03d1dfb5830fd07ff6eadbd66264c' '2adac914c72b=
6cb5aba2612f49050c82aecd498e' 'f48e7a246a567e3764112e2463274c479d95cd96' '9=
891b52ba12e9d5fed5901b6b5f6e0cdcd424390' 'e84141846decb77d2826e553318a608b2=
56804e5' '9ab637ac5d3826606947f4e861107da958eda324' '34b4fc44e4f904fbb81335=
d53163ffdcb0180000' 'da37bfe76b5b4ccc01ed8132215098e20d78e5f3' 'd3b693a13b3=
9bce16e284e1c737874966b3a96de' '06dba254de95b16e7793224d29daa5195de2e581' '=
1696fad8b259a2d46e51cd6e17e4bcdbe02279fa' '17c6bf433742e0c1ff5ce175145877c0=
194e4a7a' '2974aa42e6696a1d95b727d677dc01a71af5b998' '501efdcb3b3ab099fc0ce=
2f6e668b1c4095dd476' 'd90c0f78379454d51a428e312ac6db573060185c' '5c74a008ff=
c62fc57a041602b4517519c8bf9436' '260c3fff1fefc570d8f23e87953e181d7d248861' =
'7c12f6ead4672cb08b74e6f6115eb04dca8ccfa4' '37983fad7f3ef296fa0504c8e945987=
459dc5487' 'e02902dd493bf9c9b05353c761737ac514ad7a5c' 'ada32396f90951e12465=
224c04742607ca56a982' '507a071d9868cb60e4e76f8a06fc8eb014f59ae4' '5ebc20921=
b7fff9feb44de465448e17a382c9965' 'fed6e5084894373d76270cad4a32eb6479ad8247'=
 'c2bcf62ca75c541ec4297e6ff02a68ddc2e02029' '171b3663f33e1efdc97f5112f49be1=
0b47b20fa8' 'bf122191473e26a8f195308b1ba924c98424c8e1' 'fbb4c52ccdcb4a612d2=
b7f800aa57090eeee16d7' '0556bb42a84ee391a2145ddba86756f9747bc27f' 'd075cef4=
af6327a5de4bee7bf77591e3201e54f4' '78dfbd4ad0be9f51de7b9a19388809254aeccd26'
# test job: [9be71d462c33b1a00acfa4ab8f0f5332ed592817] https://lava.sirena.=
org.uk/scheduler/job/2548958
# test job: [7b3f8db159f710d432c4edc024fcefa9e62e8b4b] https://lava.sirena.=
org.uk/scheduler/job/2548203
# test job: [8fc5c7895185d1119ae76b509892a1d14e0bd483] https://lava.sirena.=
org.uk/scheduler/job/2548813
# test job: [981b080a79724738882b0af1c5bb7ade30d94f24] https://lava.sirena.=
org.uk/scheduler/job/2545034
# test job: [ed0313223ce6514dbd39c049e25f702980d7e3cc] https://lava.sirena.=
org.uk/scheduler/job/2544912
# test job: [97af961568c8682c44506c9ad4b26c8a5455ec1d] https://lava.sirena.=
org.uk/scheduler/job/2543844
# test job: [0a208adefecb287d22321054470d4619cb303839] https://lava.sirena.=
org.uk/scheduler/job/2542900
# test job: [a8075ada4a341ce58ebf8bef0188cefe6c2f6487] https://lava.sirena.=
org.uk/scheduler/job/2541074
# test job: [aa3d0c93a333182e887426366a4f3e5f06ee0d83] https://lava.sirena.=
org.uk/scheduler/job/2531465
# test job: [b1ef855c62601ed4de2c4b0ff75a075877e3dac8] https://lava.sirena.=
org.uk/scheduler/job/2531932
# test job: [e7662bced2e98ffa2c572126677deb9cf55d43b3] https://lava.sirena.=
org.uk/scheduler/job/2530760
# test job: [ef0b4783afc211a4b120e72b5a57f3d0340a9981] https://lava.sirena.=
org.uk/scheduler/job/2530588
# test job: [96f06d055ca03d1dfb5830fd07ff6eadbd66264c] https://lava.sirena.=
org.uk/scheduler/job/2523395
# test job: [2adac914c72b6cb5aba2612f49050c82aecd498e] https://lava.sirena.=
org.uk/scheduler/job/2523858
# test job: [f48e7a246a567e3764112e2463274c479d95cd96] https://lava.sirena.=
org.uk/scheduler/job/2522175
# test job: [9891b52ba12e9d5fed5901b6b5f6e0cdcd424390] https://lava.sirena.=
org.uk/scheduler/job/2522227
# test job: [e84141846decb77d2826e553318a608b256804e5] https://lava.sirena.=
org.uk/scheduler/job/2516954
# test job: [9ab637ac5d3826606947f4e861107da958eda324] https://lava.sirena.=
org.uk/scheduler/job/2516270
# test job: [34b4fc44e4f904fbb81335d53163ffdcb0180000] https://lava.sirena.=
org.uk/scheduler/job/2513176
# test job: [da37bfe76b5b4ccc01ed8132215098e20d78e5f3] https://lava.sirena.=
org.uk/scheduler/job/2511945
# test job: [d3b693a13b39bce16e284e1c737874966b3a96de] https://lava.sirena.=
org.uk/scheduler/job/2511939
# test job: [06dba254de95b16e7793224d29daa5195de2e581] https://lava.sirena.=
org.uk/scheduler/job/2513148
# test job: [1696fad8b259a2d46e51cd6e17e4bcdbe02279fa] https://lava.sirena.=
org.uk/scheduler/job/2513461
# test job: [17c6bf433742e0c1ff5ce175145877c0194e4a7a] https://lava.sirena.=
org.uk/scheduler/job/2513372
# test job: [2974aa42e6696a1d95b727d677dc01a71af5b998] https://lava.sirena.=
org.uk/scheduler/job/2502064
# test job: [501efdcb3b3ab099fc0ce2f6e668b1c4095dd476] https://lava.sirena.=
org.uk/scheduler/job/2500515
# test job: [d90c0f78379454d51a428e312ac6db573060185c] https://lava.sirena.=
org.uk/scheduler/job/2500276
# test job: [5c74a008ffc62fc57a041602b4517519c8bf9436] https://lava.sirena.=
org.uk/scheduler/job/2496475
# test job: [260c3fff1fefc570d8f23e87953e181d7d248861] https://lava.sirena.=
org.uk/scheduler/job/2494070
# test job: [7c12f6ead4672cb08b74e6f6115eb04dca8ccfa4] https://lava.sirena.=
org.uk/scheduler/job/2488642
# test job: [37983fad7f3ef296fa0504c8e945987459dc5487] https://lava.sirena.=
org.uk/scheduler/job/2489226
# test job: [e02902dd493bf9c9b05353c761737ac514ad7a5c] https://lava.sirena.=
org.uk/scheduler/job/2489635
# test job: [ada32396f90951e12465224c04742607ca56a982] https://lava.sirena.=
org.uk/scheduler/job/2489222
# test job: [507a071d9868cb60e4e76f8a06fc8eb014f59ae4] https://lava.sirena.=
org.uk/scheduler/job/2486412
# test job: [5ebc20921b7fff9feb44de465448e17a382c9965] https://lava.sirena.=
org.uk/scheduler/job/2485223
# test job: [fed6e5084894373d76270cad4a32eb6479ad8247] https://lava.sirena.=
org.uk/scheduler/job/2484612
# test job: [c2bcf62ca75c541ec4297e6ff02a68ddc2e02029] https://lava.sirena.=
org.uk/scheduler/job/2482354
# test job: [171b3663f33e1efdc97f5112f49be10b47b20fa8] https://lava.sirena.=
org.uk/scheduler/job/2483216
# test job: [bf122191473e26a8f195308b1ba924c98424c8e1] https://lava.sirena.=
org.uk/scheduler/job/2483327
# test job: [fbb4c52ccdcb4a612d2b7f800aa57090eeee16d7] https://lava.sirena.=
org.uk/scheduler/job/2482378
# test job: [0556bb42a84ee391a2145ddba86756f9747bc27f] https://lava.sirena.=
org.uk/scheduler/job/2482373
# test job: [d075cef4af6327a5de4bee7bf77591e3201e54f4] https://lava.sirena.=
org.uk/scheduler/job/2482695
# test job: [78dfbd4ad0be9f51de7b9a19388809254aeccd26] https://lava.sirena.=
org.uk/scheduler/job/2482880
# test job: [cf7c3c02fdd0dfccf4d6611714273dcb538af2cb] https://lava.sirena.=
org.uk/scheduler/job/2617389
# bad: [cf7c3c02fdd0dfccf4d6611714273dcb538af2cb] Add linux-next specific f=
iles for 20260330
git bisect bad cf7c3c02fdd0dfccf4d6611714273dcb538af2cb
# test job: [38b3953f6750a4200d3b37a5bfbee8370fdbd504] https://lava.sirena.=
org.uk/scheduler/job/2617530
# bad: [38b3953f6750a4200d3b37a5bfbee8370fdbd504] Merge branch 'main' of ht=
tps://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git
git bisect bad 38b3953f6750a4200d3b37a5bfbee8370fdbd504
# test job: [a4fb128b640bfc9a123150836109eba580ad1209] https://lava.sirena.=
org.uk/scheduler/job/2617626
# bad: [a4fb128b640bfc9a123150836109eba580ad1209] Merge branch 'xtensa-for-=
next' of https://github.com/jcmvbkbc/linux-xtensa.git
git bisect bad a4fb128b640bfc9a123150836109eba580ad1209
# test job: [1da8729e2823f81c215a5e08191f3bbc64da48a7] https://lava.sirena.=
org.uk/scheduler/job/2617703
# bad: [1da8729e2823f81c215a5e08191f3bbc64da48a7] Merge branch 'soc_fsl' of=
 https://git.kernel.org/pub/scm/linux/kernel/git/chleroy/linux.git
git bisect bad 1da8729e2823f81c215a5e08191f3bbc64da48a7
# test job: [fd706c02d6ce8331b3979ab082653aa2dda6f820] https://lava.sirena.=
org.uk/scheduler/job/2617851
# bad: [fd706c02d6ce8331b3979ab082653aa2dda6f820] Merge branch 'mm-unstable=
' of https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
git bisect bad fd706c02d6ce8331b3979ab082653aa2dda6f820
# test job: [d1bebf23909c97a1d31422b62493c7c70cfafa06] https://lava.sirena.=
org.uk/scheduler/job/2617901
# bad: [d1bebf23909c97a1d31422b62493c7c70cfafa06] mm: prepare to move subse=
ction_map_init() to mm/sparse-vmemmap.c
git bisect bad d1bebf23909c97a1d31422b62493c7c70cfafa06
# test job: [4bcefc23862b988ce7a9fe7dcba2f6ab0c9b5fa7] https://lava.sirena.=
org.uk/scheduler/job/2618076
# good: [4bcefc23862b988ce7a9fe7dcba2f6ab0c9b5fa7] mm/vmalloc: fix incorrec=
t size reporting on allocation failure
git bisect good 4bcefc23862b988ce7a9fe7dcba2f6ab0c9b5fa7
# test job: [798a6c72ebedf11da7b46e21b458f39d7787aba7] https://lava.sirena.=
org.uk/scheduler/job/2618272
# good: [798a6c72ebedf11da7b46e21b458f39d7787aba7] Docs/admin-guide/mm/damn=
/lru_sort: fix intervals autotune parameter name
git bisect good 798a6c72ebedf11da7b46e21b458f39d7787aba7
# test job: [75af4a7b19c295127790e42469e1863148795c26] https://lava.sirena.=
org.uk/scheduler/job/2618319
# bad: [75af4a7b19c295127790e42469e1863148795c26] selftests/mm: pagemap_ioc=
tl: remove hungarian notation
git bisect bad 75af4a7b19c295127790e42469e1863148795c26
# test job: [6235dbcce97f5b164efe6725dc6002b646943e1d] https://lava.sirena.=
org.uk/scheduler/job/2618397
# bad: [6235dbcce97f5b164efe6725dc6002b646943e1d] selftests/mm: verify drop=
pable mappings cannot be locked
git bisect bad 6235dbcce97f5b164efe6725dc6002b646943e1d
# test job: [c0fbc73a20da662edc4d603ed3d4b80503b55478] https://lava.sirena.=
org.uk/scheduler/job/2618493
# good: [c0fbc73a20da662edc4d603ed3d4b80503b55478] kho: make sure preservat=
ions do not span multiple NUMA nodes
git bisect good c0fbc73a20da662edc4d603ed3d4b80503b55478
# test job: [e2b717936d1a3f6b1f179fd03ce8e6a8f4ebc6ee] https://lava.sirena.=
org.uk/scheduler/job/2618533
# good: [e2b717936d1a3f6b1f179fd03ce8e6a8f4ebc6ee] zram: drop ->num_active_=
comps
git bisect good e2b717936d1a3f6b1f179fd03ce8e6a8f4ebc6ee
# test job: [4fd453f1644669bdd79177da31c29d32353d57f7] https://lava.sirena.=
org.uk/scheduler/job/2618566
# good: [4fd453f1644669bdd79177da31c29d32353d57f7] zram: remove chained rec=
ompression
git bisect good 4fd453f1644669bdd79177da31c29d32353d57f7
# test job: [5435ba164b0dd162e1a2fb47ab2d3f5cd70905f9] https://lava.sirena.=
org.uk/scheduler/job/2618612
# good: [5435ba164b0dd162e1a2fb47ab2d3f5cd70905f9] mm: prevent droppable ma=
ppings from being locked
git bisect good 5435ba164b0dd162e1a2fb47ab2d3f5cd70905f9
# first bad commit: [6235dbcce97f5b164efe6725dc6002b646943e1d] selftests/mm=
: verify droppable mappings cannot be locked

--xUgacxsbd/IMhxBH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmnLyX0ACgkQJNaLcl1U
h9BIzAf+N0UTBlyL76jU4iSe8Cwvs4WM0VJJ7LSTqOVzywwC2b4x3w4ocDRAcsWl
K7R6BsuSM2XBwwUSB7eZnsXrY2od589ZvdtKFxrArNTDgK+qs1cipBM3V4fYmktw
sR3cRJdDHvkTN6ySwMR9/gHmYgcOZWuLPLk1cv3m4ugb30r/307IOa0L4MVUg50J
2lE3tWPnX8Svnc1ur5enfoHsZezLpOGdMJEVZNLyoOqQInAnwSKfS29oaZFzobt9
DIFY7legcASdYfOyNiKLRZn/cpE1fHjpQFc+jXUxocmuI8zSlG5L8qsoVMRUwpyl
skRScQL6ZD4wsUQprw8YKC8DFJHslA==
=T6SO
-----END PGP SIGNATURE-----

--xUgacxsbd/IMhxBH--

