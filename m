Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34A9DD0D167
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 18:39:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95FD26B0092; Wed,  7 Jan 2026 13:39:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90E2E6B0093; Wed,  7 Jan 2026 13:39:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80CE06B0095; Wed,  7 Jan 2026 13:39:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 672A86B0092
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 13:39:26 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C795B58F3C
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 18:39:25 +0000 (UTC)
X-FDA: 84306030690.23.DE404A1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0A6624000D
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 18:39:23 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Lx1k2W2D;
	spf=pass (imf01.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767811164; a=rsa-sha256;
	cv=none;
	b=rjnIog+FwFJkatGFsougjwaiG1Sf9l9b8VwAP5WJY8C3jOwflo+fkguqUnUOHkoLLRcXZ1
	aolkVSlWcKRBwTx/Oln/lcEX8D8Wy7tjd9ZSTTue8j9iedvMPiqEDQkGRteQCNcXFKoUhT
	za+BwQs7kSiGlee7epz5ejHUBL29bJ8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Lx1k2W2D;
	spf=pass (imf01.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767811164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HZ+ASXxjJq3HQNlR1WjX5Ev7rAWiSoVSXt9p1ueicow=;
	b=PZ3G/RU+jDqEuEeKeC5WijdjQVwy2w9+Jo3DpBWXYUzpUrimocybgV8wcQtwoGqfPQ8M7/
	tXnDoso4rQLzzSgEKkTWl/rWTDnu2zu1Yim1awSI63WKkfoCWvV9NG3QB1FP/jBvQiV3fK
	o76WijF8YoBaf0TdUiwAt9vACL87Vu0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0BD3943A5A;
	Wed,  7 Jan 2026 18:39:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34FEFC4CEF1;
	Wed,  7 Jan 2026 18:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767811162;
	bh=4J7KTOT18lJOzYWjZaZSS6ner7TYXBxdXcN8uDVCY88=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Lx1k2W2Dd75oVE7Dn4CXcOGRzlsRKvc+MG7y6I/NfXCat8whjuZ54Fxi3c2C3NjDS
	 xrGbvbE6/DQvme+EUn9XcgWIjn6viNRGsky8ydH7pKFXEYpXrvgHz8qKI3Espwy9+U
	 HSotqibivDiP38fyad4q0UPHjqIsnKoOryj7JudTqYVJC7BxjgtOn4ASrUCNdinz1S
	 lPlKy1Awxc5UpyA5L+Secsh/eRYbc+zeVaYv3lGKv8eMf3Rh+bQGUKiBe6VkBT29ES
	 bXuqX0pdo/PCSQ+1urDV5SD7QSbdZvh/gcbIt0ubLWYk5fVQIrOBb2GJNFkwj00/sz
	 DCWzW/jZAjvog==
Date: Wed, 7 Jan 2026 18:39:17 +0000
From: Mark Brown <broonie@kernel.org>
To: Claudiu Beznea <claudiu.beznea@tuxon.dev>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Oscar Salvador <osalvador@suse.de>,
	Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
	sidhartha.kumar@oracle.com, jane.chu@oracle.com,
	Zi Yan <ziy@nvidia.com>, Vlastimil Babka <vbabka@suse.cz>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v5 mm-new 0/6] mm: hugetlb: allocate frozen gigantic folio
Message-ID: <13ad5888-2d53-40c8-9269-22bc6001754a@sirena.org.uk>
References: <20251230072422.265265-1-wangkefeng.wang@huawei.com>
 <4211be25-3fc0-4395-9b24-a5ff0b3caa34@tuxon.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="KMRMKbz+d4ZZOhL0"
Content-Disposition: inline
In-Reply-To: <4211be25-3fc0-4395-9b24-a5ff0b3caa34@tuxon.dev>
X-Cookie: Keep out of reach of children.
X-Rspam-User: 
X-Rspamd-Queue-Id: 0A6624000D
X-Rspamd-Server: rspam04
X-Stat-Signature: p9x7kees6udo3gmogway77o3jgeuwi8b
X-HE-Tag: 1767811163-263014
X-HE-Meta: U2FsdGVkX18h7BOVMF6ciX+5FAfzIbrKU420kG34segEP+RyY6MWEVhyCcIS8v//iunKS2vSRqcLPh6mizOFg6mDpkKPZfx/LVVQVn5Pwa1rMpeKrsQz+/E0JeqdTPeuXpGwMRgx3YEcRD5ewj+a0NISZyPu6u4FPJxOMnsZcE9iMyXyRdHbDyNXwfbpROwcrZmIeUVHAy+im4eeYpOqae7jGWXnlpNluZK3949ggQbtF/6Jaynrh4ZJkJla6pIyu6rMI2Pb427QPApUVtzEocHUItiH70kE5Ylp9Ke3u9U3YOM9gG4vPFuo6+31Hq/cR6DCbWuwH2Ei9qW6htYpXcgbOcP924Tl5fgNe24vCDdaLDQ1hfSj2TpywYAh7uTmrsRehq+QvMRMYEbpeR/uOzq3JYgLA1sH5TiUIQKJIZuNcOQQzLmpm7nwsXamgOqEFu6qGglqBxj8RQW5BGjlhV9E7OPVTovic81RGux2oEPk+PCOLnxBj04lmp2VnIyYguAiSO/7sI0HRnruj8a5BwRuew5RiQKQCNSJntzdiQG6A3xB28E/WaUzxw7r/V9lS43CyhL7+Bs/jB3EGPDjNubqn25I0VsxvYVbtvEUVfkg2g8DdW9nuuu9ceslHkfLFDdpLj4tKcbLoanFzmwSD01dijhr1DG3vIGn+mLsNztCG27S1yw9G+u4CPPgHnjH5tJG+HG4sxzdoD9/1gDF9gwNKtxQtvfhlDwbkKlGU5iO7TfuNzThLi/dEJ7BLgTbc2t2szQEyhBo/eP+bsNKas6iFWV2UvNlzrfHHhKYlpnYVP9qVv6B3ceT3QY7CbavL+j1O5msdzo9QKZkPZ4Xv/825PiUvNmuxz+OoBC4kgDLJuxPurGk5/k2PbX6JUwGnaMGs7uoOt2wqXrkDE6maNmTykHipuMgZfhu6gFZqgXS30CytL94qRkCiCjFd57IsKuPDXXiEdmjmUKsw+K
 kl17oTsh
 THn9gdVnFPpdXb7SF/CqcE76w9le2iSpyFywGy4Rpec+TFhvVJTQxTZiBzkj8RNyQk4f7qUfMUi6hefDdnTHb7/ZIEyI+pqpjOxvvXxVNF694tqZv3nGeyg2lsLdycVW5NAoQKcfbze/sLGZshS0xZAbn1RJXMCA8JX0Fd2GzRDRST3gxBXV/WXdR4x9pQH+/yfSAyQnllfkf0ksu8mMs7kFKiLNBPiJWL28dqhhAGZeVevysPr/CusON2rC4NirGteWUSOwYfyAgDNlUmVpExySyvIU+gAv3T9gT6SDbVs2EoQG/NnZMihb4zSFI2WeipL2uVRN+vyYeflIyd3r8CVuPNsI56KkFYQ6OgEYC2xgiwl8WnszWcbYvA8IEbVVL/0CUMcEOVxz2FOkxFN5JaUFHfR/aFRtmhITEZhDU5uQURTVbGhnLS30SstN9iMaRINE6hBi5hJpiU9U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--KMRMKbz+d4ZZOhL0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 07, 2026 at 07:31:30PM +0200, Claudiu Beznea wrote:
> On 12/30/25 09:24, Kefeng Wang wrote:

> > Introduce alloc_contig_frozen_pages() and cma_alloc_frozen_compound()
> > which avoid atomic operation about page refcount, and then convert to
> > allocate frozen gigantic folio by the new helpers in hugetlb to cleanup
> > the alloc_gigantic_folio().
>=20
> I'm seeing the following issues on the Renesas RZ/G3S SoC when doing susp=
end
> to idle:
>=20
> [  129.636729] Unable to handle kernel paging request at virtual address
> dead000000000108
> [  129.644674] Mem abort info:
> [  129.647456]   ESR =3D 0x0000000096000044

This is also introducing OOMs when doing at least audio tests (I don't
think these are super relevant) on Raspberry Pi 3B+ running NFS root
(probably more relevant):

[   64.064256] Unable to handle kernel paging request at virtual address ff=
fffdffc1000000

=2E..

[   64.087583] Call trace:
[   64.087586]  kmem_cache_free+0x88/0x434 (P)
[   64.087598]  skb_free_head+0x9c/0xb8
[   64.087608]  skb_release_data+0x120/0x174
[   64.087615]  __kfree_skb+0x2c/0x44
[   64.087622]  tcp_data_queue+0x948/0xe50

Full log:

   https://lava.sirena.org.uk/scheduler/job/2341856#L1721

Bisection identifies:

[fb9a328d30400dbc8b2ea5a57daeb28bedac398b] mm: cma: add cma_alloc_frozen{_c=
ompound}()

as being the comit that introduces the issue.  Bisect log with links to
further test runs:

# bad: [f96074c6d01d8a5e9e2fccd0bba5f2ed654c1f2d] Add linux-next specific f=
iles for 20260107
# good: [20dcabcbe843d74f3f6d2c8b5a4bd14443997697] Merge branch 'for-linux-=
next-fixes' of https://gitlab.freedesktop.org/drm/misc/kernel.git
# good: [75d208bddcca55ec31481420fbb4d6c9703ba195] spi: stm32: avoid __mayb=
e_unused and use pm_ptr
# good: [04b61513dfe40f80f0dcc795003637b510522b3c] ASoC: SDCA: Replace use =
of system_wq with system_dfl_wq
# good: [9bf0bd7bdea6c402007ffb784dd0c0f704aa2310] ASoC: nau8821: Sort #inc=
lude directives
# good: [52ddc0106c77ff0eacf07b309833ae6e6a4e8587] ASoC: es8328: Remove dup=
licate DAPM routes
# good: [96d337436fe0921177a6090aeb5bb214753654fc] spi: dt-bindings: at91: =
add microchip,lan9691-spi
# good: [4c5e6d5b31bc623d89185d551681ab91cfd037c9] ASoC: codecs: ES8389: Up=
date clock configuration
# good: [211243b69533e968cc6f0259fb80ffee02fbe0ca] firmware: cs_dsp: test_b=
in: Add tests for offsets > 0xffff
# good: [420739112e95c9bb286b4e87875706925970abd3] ASoC: rt5575: Add the co=
dec driver for the ALC5575
# good: [25abdc151a448a17d500ea9468ce32582c479faa] ASoC: rt1320: fix the re=
mainder calculation of r0 value
# good: [284853affe73fe1ca9786bd52b934eb9d420a942] ASoC: rt1320: fix size_t=
 format string
# good: [45e9066f3a487e9e26b842644364d045af054775] ASoC: Intel: avs: replac=
e strcmp with sysfs_streq
# good: [0f698d742f628d02ab2a222f8cf5f793443865d0] spi: bcm63xx-hsspi: add =
support for 1-2-2 read ops
# good: [8db50f0fa43efe8799fd40b872dcdd39a90d7549] ASoC: rt1320: fix the wa=
rning the string may be truncated
# good: [b0655377aa5a410df02d89170c20141a1a5bbc28] rust: regulator: replace=
 `kernel::c_str!` with C-Strings
# good: [c6bca73d699cfe00d3419566fdb2a45e112f44b0] ASoC: rt1320: Fix retry =
checking in rt1320_rae_load()
# good: [4ab48cc63e15cb619d641d1edf9a15a0a98875b2] ASoC: qcom: audioreach: =
Constify function arguments
# good: [a2a631830deb382a3d27b6f52b2d654a3e6bb427] ASoC: qcom: Constify APR=
/GPR result structs
# good: [99a3ef1e81cd1775bc1f8cc2ad188b1fc755d5cd] ASoC: SDCA: Add ASoC jac=
k hookup in class driver
# good: [32a708ba5db50cf928a1f1b2039ceef33de2c286] regulator: Add rt8092 su=
pport
# good: [7a8447fc71a09000cee5a2372b6efde45735d2c8] ASoC: codecs: wcd939x-sd=
w: use devres for regmap allocation
# good: [b39ef93a2e5b5f4289a3486d8a94a09a1e6a4c67] spi: stm32: perform smal=
l transfer in polling mode
# good: [3622dc47a4b13e0ec86358c7b54a0b33bfcaa03c] ASoC: codec: rt286: Use =
devm_request_threaded_irq to manage IRQ lifetime and fix smatch warning
# good: [2a28b5240f2b328495c6565d277f438dbc583d61] ASoC: SOF: ipc4-control:=
 Add support for generic bytes control
# good: [7f7b350e4a65446f5d52ea8ae99e12eac8a972db] spi: stm32-qspi: Remove =
unneeded semicolon
# good: [f764645cb85a8b8f58067289cdfed28f6c1cdf49] ASoC: codecs: tas2780: t=
idyup format check in tas2780_set_fmt()
# good: [02e7af5b6423d2dbf82f852572f2fa8c00aafb19] ASoC: Intel: sof_rt5682:=
 add tas2563 speaker amp support
# good: [9a6bc0a406608e2520f18d996483c9d2e4a9fb27] ASoC: codecs: ES8326: Ad=
d kcontrol for DRE
# good: [29c8c00d9f9db5fb659b6f05f9e8964afc13f3e2] spi: add driver for NXP =
XSPI controller
# good: [1303c2903889b01d581083ed92e439e7544dd3e5] MAINTAINERS: Add MAINTAI=
NERS entry for the ATCSPI200 SPI controller driver
# good: [524ee559948d8d079b13466e70fa741f909699c0] ASoC: SOF: Intel: hda: O=
nly check SSP MCLK mask in case of IPC3
# good: [f25c7d709b93602ee9a08eba522808a18e1f5d56] ASoC: SOF: Intel: pci-nv=
l: Set on_demand_dsp_boot for NVL-S
# good: [f4acea9eef704607d1a950909ce3a52a770d6be2] spi: dt-bindings: st,stm=
32-spi: add 'power-domains' property
# good: [fee876b2ec75dcc18fdea154eae1f5bf14d82659] spi: stm32-qspi: Simplif=
y SMIE interrupt test
# good: [b884e34994ca41f7b7819f3c41b78ff494787b27] spi: spi-fsl-lpspi: conv=
ert min_t() to simple min()
# good: [0bb160c92ad400c692984763996b758458adea17] ASoC: qcom: Minor readab=
ility improve with new lines
# good: [81acbdc51bbbec822a1525481f2f70677c47aee0] ASoC: sdw-mockup: Drop d=
ummy remove function
# good: [03d281f384768610bf90697bce9e35d3d596de77] rust: regulator: add __r=
ust_helper to helpers
# good: [ba9b28652c75b07383e267328f1759195d5430f7] spi: imx: enable DMA mod=
e for target operation
# good: [9e92c559d49d6fb903af17a31a469aac51b1766d] regulator: max77675: Add=
 MAX77675 regulator driver
# good: [124f6155f3d97b0e33f178c10a5138a42c8fd207] ASoC: renesas: rz-ssi: A=
dd support for 32 bits sample width
# good: [aa30193af8873b3ccfd70a4275336ab6cbd4e5e6] ASoC: Intel: catpt: Drop=
 superfluous space in PCM code
# good: [e39011184f23de3d04ca8e80b4df76c9047b4026] ASoC: SDCA: functions: F=
ix confusing cleanup.h syntax
# good: [fa08b566860bca8ebf9300090b85174c34de7ca5] spi: rzv2h-rspi: add sup=
port for DMA mode
# good: [6c177775dcc5e70a64ddf4ee842c66af498f2c7c] Merge branch 'next/drive=
rs' into for-next
git bisect start 'f96074c6d01d8a5e9e2fccd0bba5f2ed654c1f2d' '20dcabcbe843d7=
4f3f6d2c8b5a4bd14443997697' '75d208bddcca55ec31481420fbb4d6c9703ba195' '04b=
61513dfe40f80f0dcc795003637b510522b3c' '9bf0bd7bdea6c402007ffb784dd0c0f704a=
a2310' '52ddc0106c77ff0eacf07b309833ae6e6a4e8587' '96d337436fe0921177a6090a=
eb5bb214753654fc' '4c5e6d5b31bc623d89185d551681ab91cfd037c9' '211243b69533e=
968cc6f0259fb80ffee02fbe0ca' '420739112e95c9bb286b4e87875706925970abd3' '25=
abdc151a448a17d500ea9468ce32582c479faa' '284853affe73fe1ca9786bd52b934eb9d4=
20a942' '45e9066f3a487e9e26b842644364d045af054775' '0f698d742f628d02ab2a222=
f8cf5f793443865d0' '8db50f0fa43efe8799fd40b872dcdd39a90d7549' 'b0655377aa5a=
410df02d89170c20141a1a5bbc28' 'c6bca73d699cfe00d3419566fdb2a45e112f44b0' '4=
ab48cc63e15cb619d641d1edf9a15a0a98875b2' 'a2a631830deb382a3d27b6f52b2d654a3=
e6bb427' '99a3ef1e81cd1775bc1f8cc2ad188b1fc755d5cd' '32a708ba5db50cf928a1f1=
b2039ceef33de2c286' '7a8447fc71a09000cee5a2372b6efde45735d2c8' 'b39ef93a2e5=
b5f4289a3486d8a94a09a1e6a4c67' '3622dc47a4b13e0ec86358c7b54a0b33bfcaa03c' '=
2a28b5240f2b328495c6565d277f438dbc583d61' '7f7b350e4a65446f5d52ea8ae99e12ea=
c8a972db' 'f764645cb85a8b8f58067289cdfed28f6c1cdf49' '02e7af5b6423d2dbf82f8=
52572f2fa8c00aafb19' '9a6bc0a406608e2520f18d996483c9d2e4a9fb27' '29c8c00d9f=
9db5fb659b6f05f9e8964afc13f3e2' '1303c2903889b01d581083ed92e439e7544dd3e5' =
'524ee559948d8d079b13466e70fa741f909699c0' 'f25c7d709b93602ee9a08eba522808a=
18e1f5d56' 'f4acea9eef704607d1a950909ce3a52a770d6be2' 'fee876b2ec75dcc18fde=
a154eae1f5bf14d82659' 'b884e34994ca41f7b7819f3c41b78ff494787b27' '0bb160c92=
ad400c692984763996b758458adea17' '81acbdc51bbbec822a1525481f2f70677c47aee0'=
 '03d281f384768610bf90697bce9e35d3d596de77' 'ba9b28652c75b07383e267328f1759=
195d5430f7' '9e92c559d49d6fb903af17a31a469aac51b1766d' '124f6155f3d97b0e33f=
178c10a5138a42c8fd207' 'aa30193af8873b3ccfd70a4275336ab6cbd4e5e6' 'e3901118=
4f23de3d04ca8e80b4df76c9047b4026' 'fa08b566860bca8ebf9300090b85174c34de7ca5=
' '6c177775dcc5e70a64ddf4ee842c66af498f2c7c'
# test job: [75d208bddcca55ec31481420fbb4d6c9703ba195] https://lava.sirena.=
org.uk/scheduler/job/2337459
# test job: [04b61513dfe40f80f0dcc795003637b510522b3c] https://lava.sirena.=
org.uk/scheduler/job/2337698
# test job: [9bf0bd7bdea6c402007ffb784dd0c0f704aa2310] https://lava.sirena.=
org.uk/scheduler/job/2331109
# test job: [52ddc0106c77ff0eacf07b309833ae6e6a4e8587] https://lava.sirena.=
org.uk/scheduler/job/2331449
# test job: [96d337436fe0921177a6090aeb5bb214753654fc] https://lava.sirena.=
org.uk/scheduler/job/2330452
# test job: [4c5e6d5b31bc623d89185d551681ab91cfd037c9] https://lava.sirena.=
org.uk/scheduler/job/2331888
# test job: [211243b69533e968cc6f0259fb80ffee02fbe0ca] https://lava.sirena.=
org.uk/scheduler/job/2330732
# test job: [420739112e95c9bb286b4e87875706925970abd3] https://lava.sirena.=
org.uk/scheduler/job/2331724
# test job: [25abdc151a448a17d500ea9468ce32582c479faa] https://lava.sirena.=
org.uk/scheduler/job/2307411
# test job: [284853affe73fe1ca9786bd52b934eb9d420a942] https://lava.sirena.=
org.uk/scheduler/job/2298008
# test job: [45e9066f3a487e9e26b842644364d045af054775] https://lava.sirena.=
org.uk/scheduler/job/2295689
# test job: [0f698d742f628d02ab2a222f8cf5f793443865d0] https://lava.sirena.=
org.uk/scheduler/job/2295186
# test job: [8db50f0fa43efe8799fd40b872dcdd39a90d7549] https://lava.sirena.=
org.uk/scheduler/job/2292094
# test job: [b0655377aa5a410df02d89170c20141a1a5bbc28] https://lava.sirena.=
org.uk/scheduler/job/2291691
# test job: [c6bca73d699cfe00d3419566fdb2a45e112f44b0] https://lava.sirena.=
org.uk/scheduler/job/2290187
# test job: [4ab48cc63e15cb619d641d1edf9a15a0a98875b2] https://lava.sirena.=
org.uk/scheduler/job/2290923
# test job: [a2a631830deb382a3d27b6f52b2d654a3e6bb427] https://lava.sirena.=
org.uk/scheduler/job/2281809
# test job: [99a3ef1e81cd1775bc1f8cc2ad188b1fc755d5cd] https://lava.sirena.=
org.uk/scheduler/job/2290873
# test job: [32a708ba5db50cf928a1f1b2039ceef33de2c286] https://lava.sirena.=
org.uk/scheduler/job/2279418
# test job: [7a8447fc71a09000cee5a2372b6efde45735d2c8] https://lava.sirena.=
org.uk/scheduler/job/2271746
# test job: [b39ef93a2e5b5f4289a3486d8a94a09a1e6a4c67] https://lava.sirena.=
org.uk/scheduler/job/2269621
# test job: [3622dc47a4b13e0ec86358c7b54a0b33bfcaa03c] https://lava.sirena.=
org.uk/scheduler/job/2268671
# test job: [2a28b5240f2b328495c6565d277f438dbc583d61] https://lava.sirena.=
org.uk/scheduler/job/2266226
# test job: [7f7b350e4a65446f5d52ea8ae99e12eac8a972db] https://lava.sirena.=
org.uk/scheduler/job/2263933
# test job: [f764645cb85a8b8f58067289cdfed28f6c1cdf49] https://lava.sirena.=
org.uk/scheduler/job/2264479
# test job: [02e7af5b6423d2dbf82f852572f2fa8c00aafb19] https://lava.sirena.=
org.uk/scheduler/job/2262695
# test job: [9a6bc0a406608e2520f18d996483c9d2e4a9fb27] https://lava.sirena.=
org.uk/scheduler/job/2264395
# test job: [29c8c00d9f9db5fb659b6f05f9e8964afc13f3e2] https://lava.sirena.=
org.uk/scheduler/job/2264013
# test job: [1303c2903889b01d581083ed92e439e7544dd3e5] https://lava.sirena.=
org.uk/scheduler/job/2263454
# test job: [524ee559948d8d079b13466e70fa741f909699c0] https://lava.sirena.=
org.uk/scheduler/job/2243928
# test job: [f25c7d709b93602ee9a08eba522808a18e1f5d56] https://lava.sirena.=
org.uk/scheduler/job/2244095
# test job: [f4acea9eef704607d1a950909ce3a52a770d6be2] https://lava.sirena.=
org.uk/scheduler/job/2243878
# test job: [fee876b2ec75dcc18fdea154eae1f5bf14d82659] https://lava.sirena.=
org.uk/scheduler/job/2231258
# test job: [b884e34994ca41f7b7819f3c41b78ff494787b27] https://lava.sirena.=
org.uk/scheduler/job/2232599
# test job: [0bb160c92ad400c692984763996b758458adea17] https://lava.sirena.=
org.uk/scheduler/job/2233069
# test job: [81acbdc51bbbec822a1525481f2f70677c47aee0] https://lava.sirena.=
org.uk/scheduler/job/2232790
# test job: [03d281f384768610bf90697bce9e35d3d596de77] https://lava.sirena.=
org.uk/scheduler/job/2231108
# test job: [ba9b28652c75b07383e267328f1759195d5430f7] https://lava.sirena.=
org.uk/scheduler/job/2231415
# test job: [9e92c559d49d6fb903af17a31a469aac51b1766d] https://lava.sirena.=
org.uk/scheduler/job/2232475
# test job: [124f6155f3d97b0e33f178c10a5138a42c8fd207] https://lava.sirena.=
org.uk/scheduler/job/2232888
# test job: [aa30193af8873b3ccfd70a4275336ab6cbd4e5e6] https://lava.sirena.=
org.uk/scheduler/job/2232739
# test job: [e39011184f23de3d04ca8e80b4df76c9047b4026] https://lava.sirena.=
org.uk/scheduler/job/2232438
# test job: [fa08b566860bca8ebf9300090b85174c34de7ca5] https://lava.sirena.=
org.uk/scheduler/job/2232925
# test job: [6c177775dcc5e70a64ddf4ee842c66af498f2c7c] https://lava.sirena.=
org.uk/scheduler/job/2203261
# test job: [f96074c6d01d8a5e9e2fccd0bba5f2ed654c1f2d] https://lava.sirena.=
org.uk/scheduler/job/2341856
# bad: [f96074c6d01d8a5e9e2fccd0bba5f2ed654c1f2d] Add linux-next specific f=
iles for 20260107
git bisect bad f96074c6d01d8a5e9e2fccd0bba5f2ed654c1f2d
# test job: [2fdca3c405e768b297c7833abd381798ec67c12f] https://lava.sirena.=
org.uk/scheduler/job/2342141
# bad: [2fdca3c405e768b297c7833abd381798ec67c12f] Merge branch 'libcrypto-n=
ext' of https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git
git bisect bad 2fdca3c405e768b297c7833abd381798ec67c12f
# test job: [711e711d9a1413a312c4e529460dc6359d7a2e21] https://lava.sirena.=
org.uk/scheduler/job/2342498
# bad: [711e711d9a1413a312c4e529460dc6359d7a2e21] Merge branch 'next' of ht=
tps://git.kernel.org/pub/scm/linux/kernel/git/jenswi/linux-tee.git
git bisect bad 711e711d9a1413a312c4e529460dc6359d7a2e21
# test job: [eeebc729d8edff51c7d53a8da80ab694fb00ec59] https://lava.sirena.=
org.uk/scheduler/job/2342751
# bad: [eeebc729d8edff51c7d53a8da80ab694fb00ec59] Merge branch 'soc_fsl' of=
 https://git.kernel.org/pub/scm/linux/kernel/git/chleroy/linux.git
git bisect bad eeebc729d8edff51c7d53a8da80ab694fb00ec59
# test job: [99f5256ce0398314379c4d43f960bb05c6a68e86] https://lava.sirena.=
org.uk/scheduler/job/2343002
# bad: [99f5256ce0398314379c4d43f960bb05c6a68e86] Merge branch 'mm-unstable=
' of https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
git bisect bad 99f5256ce0398314379c4d43f960bb05c6a68e86
# test job: [0d560834ac1e15bda48c3df99397479d584ad49a] https://lava.sirena.=
org.uk/scheduler/job/2343255
# good: [0d560834ac1e15bda48c3df99397479d584ad49a] mm, swap: never bypass t=
he swap cache even for SWP_SYNCHRONOUS_IO
git bisect good 0d560834ac1e15bda48c3df99397479d584ad49a
# test job: [f7722c416c0d4fc2183170daf0703cd7a18fb1e2] https://lava.sirena.=
org.uk/scheduler/job/2343380
# good: [f7722c416c0d4fc2183170daf0703cd7a18fb1e2] mm/damon/tests/core-kuni=
t: verify the 'age' field in damon_test_split_at()
git bisect good f7722c416c0d4fc2183170daf0703cd7a18fb1e2
# test job: [af14267376cc7aea8183a2b01efe5458768652d5] https://lava.sirena.=
org.uk/scheduler/job/2343575
# bad: [af14267376cc7aea8183a2b01efe5458768652d5] mips: introduce arch_zone=
_limits_init()
git bisect bad af14267376cc7aea8183a2b01efe5458768652d5
# test job: [bb25558519874e266399381588490c1d1ffae133] https://lava.sirena.=
org.uk/scheduler/job/2343772
# bad: [bb25558519874e266399381588490c1d1ffae133] mm: hugetlb: allocate fro=
zen pages for gigantic allocation
git bisect bad bb25558519874e266399381588490c1d1ffae133
# test job: [8c670157c80aa96182795e801ea542a20aff86f1] https://lava.sirena.=
org.uk/scheduler/job/2343923
# good: [8c670157c80aa96182795e801ea542a20aff86f1] mm/damon/tests/core-kuni=
t: remove a redundant test case and add a new test case in damos_test_commi=
t_quota_goal()
git bisect good 8c670157c80aa96182795e801ea542a20aff86f1
# test job: [d0a464d968a308259b9dc5af39c1059a83c0524d] https://lava.sirena.=
org.uk/scheduler/job/2343979
# good: [d0a464d968a308259b9dc5af39c1059a83c0524d] mm: cma: kill cma_pages_=
valid()
git bisect good d0a464d968a308259b9dc5af39c1059a83c0524d
# test job: [fb9a328d30400dbc8b2ea5a57daeb28bedac398b] https://lava.sirena.=
org.uk/scheduler/job/2344132
# bad: [fb9a328d30400dbc8b2ea5a57daeb28bedac398b] mm: cma: add cma_alloc_fr=
ozen{_compound}()
git bisect bad fb9a328d30400dbc8b2ea5a57daeb28bedac398b
# test job: [c619019d04ad8de96657cd0c8f1251ac14944338] https://lava.sirena.=
org.uk/scheduler/job/2344251
# good: [c619019d04ad8de96657cd0c8f1251ac14944338] mm: page_alloc: add allo=
c_contig_frozen_{range,pages}()
git bisect good c619019d04ad8de96657cd0c8f1251ac14944338
# first bad commit: [fb9a328d30400dbc8b2ea5a57daeb28bedac398b] mm: cma: add=
 cma_alloc_frozen{_compound}()

--KMRMKbz+d4ZZOhL0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmleqFQACgkQJNaLcl1U
h9DEqAf+Jodohg/szTzF3BxqycNpfSnU5OD+fyt24SVwhsf5LXXktdximn/brYLW
bci23CQlCcclkJrijy/NH+03BAWILiPgUT5I1dSzsnUQ1e/p3KKc5zCswUXjh4Nr
slZ1toaQ8JVnSkMGpZBvSK+EWz0tXtbnG9LF5bt/Pek2YEDe5NFM1d0ILRpUOcij
5hlf+H/yb+O/3TfpEudj+SUE2ENZgI4vjTWaZfxUS1Ii+sEIR4cL+qnyRvZiO5bq
QCiTBWK31mz3rUz7CyqTMceUZXl556qnSRZEkAq+i6LkWQ0cQdC3dNWi9yGAIXQ0
uLVycV76nA1oLW0fUJ6Ybl/scTmGgA==
=8Siy
-----END PGP SIGNATURE-----

--KMRMKbz+d4ZZOhL0--

