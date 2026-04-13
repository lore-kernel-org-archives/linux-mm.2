Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B5BDF34C62
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 15:30:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4CC16B008A; Mon, 13 Apr 2026 11:30:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFC896B0092; Mon, 13 Apr 2026 11:30:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B132B6B0093; Mon, 13 Apr 2026 11:30:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9E0E26B008A
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 11:30:12 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 48C09C12BE
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 15:30:12 +0000 (UTC)
X-FDA: 84653918664.24.1DFF911
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3D22B4001A
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 15:30:08 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=bfhbd2sL;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf07.hostedemail.com: domain of BATV+feefc7fe6e280d16f9a0+8268+infradead.org+dwmw2@desiato.srs.infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=BATV+feefc7fe6e280d16f9a0+8268+infradead.org+dwmw2@desiato.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776094210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A/tyFuZQFYTYsk5yepZic+9iJmMgnVldp43vNUqBGF8=;
	b=2fc5RojcuVcfQL2GId6OoBHuQCUp8VumznyqxwCN7KKpdrKlHTp8MnhwqmP43w5zOx1ivF
	vhauxAEyh8RvwbyABQtvjh9aSCs8OrX1QL5IPyW6O7/w1uyGc//IBwg4i1ogdogWNc3hsV
	ZItTi/wweJBFFSoETH1rn8kN1+vz188=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776094210; a=rsa-sha256;
	cv=none;
	b=ZsaBkq62n4LMsU78g9PL0T4njLnW3JgDLvTG6ljeLtr0RzuUhd8XIPucaULtL2yorNj8ff
	hFOZSEeNMjb8YdaR7QaIhQVPU+4ip9VgOs81hD8VKLoJ9OhBbENiNuYMOA8sQiPLb/s1KG
	GyCjF7ynV3zDbrykvCAj/LY8a5+v1JA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=bfhbd2sL;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf07.hostedemail.com: domain of BATV+feefc7fe6e280d16f9a0+8268+infradead.org+dwmw2@desiato.srs.infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=BATV+feefc7fe6e280d16f9a0+8268+infradead.org+dwmw2@desiato.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=A/tyFuZQFYTYsk5yepZic+9iJmMgnVldp43vNUqBGF8=; b=bfhbd2sL8t75c5rug3uBwuxg5P
	LuWR8p2uSlhmLvoC75s7TYMX1lfdHXhQNJF2OG0QXGhVA74ED4L05Ui2YgH9chIQJTBVRJcaDXkdQ
	PoO6uYPpDnqy8MenOCTFbkRMKQS78wCprJ3tkgPda8HAMffpT54zL852bGYOCnflkc2nDFvdBn0cR
	8vP+E7+2CaxiOsjddnC2m+sVdQvAC0f34xjQErQU8sm5+txqnL/HeNOtCoI1QzVGmD8hBCUOicCZO
	Sdtu+YLC1PADFf5yRRMpMGrKPzY0Wz8LlL1valPv8PoqQKRDiHRNlNkJrhES2TYrKiZoLqunJos/G
	lcviTgFA==;
Received: from [213.122.4.78] (helo=u09cd745991455d.ant.amazon.com)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wCJEX-0000000H2ae-13Uv;
	Mon, 13 Apr 2026 15:29:53 +0000
Message-ID: <aa07b2a812255473ca6f1ca0c872a983ee24728e.camel@infradead.org>
Subject: Re: [patch 10/38] arcnet: Remove function timing code
From: David Woodhouse <dwmw2@infradead.org>
To: Thomas Gleixner <tglx@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Cc: Michael Grzeschik <m.grzeschik@pengutronix.de>, netdev@vger.kernel.org, 
 Arnd Bergmann <arnd@arndb.de>, x86@kernel.org, Lu Baolu
 <baolu.lu@linux.intel.com>,  iommu@lists.linux.dev,
 linux-wireless@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
 linux-crypto@vger.kernel.org, Vlastimil Babka <vbabka@kernel.org>,
 linux-mm@kvack.org, Bernie Thompson <bernie@plugable.com>, 
 linux-fbdev@vger.kernel.org, Theodore Tso <tytso@mit.edu>, 
 linux-ext4@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>, Marco Elver <elver@google.com>, Dmitry
 Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com, Andrey Ryabinin
 <ryabinin.a.a@gmail.com>, Thomas Sailer <t.sailer@alumni.ethz.ch>, 
 linux-hams@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>, Richard
 Henderson <richard.henderson@linaro.org>, linux-alpha@vger.kernel.org,
 Russell King <linux@armlinux.org.uk>, linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Huacai Chen
 <chenhuacai@kernel.org>,  loongarch@lists.linux.dev, Geert Uytterhoeven
 <geert@linux-m68k.org>,  linux-m68k@lists.linux-m68k.org, Dinh Nguyen
 <dinguyen@kernel.org>, Jonas Bonn <jonas@southpole.se>,
 linux-openrisc@vger.kernel.org, Helge Deller <deller@gmx.de>, 
 linux-parisc@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>, 
 linuxppc-dev@lists.ozlabs.org, Paul Walmsley <pjw@kernel.org>, 
 linux-riscv@lists.infradead.org, Heiko Carstens <hca@linux.ibm.com>, 
 linux-s390@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, 
 sparclinux@vger.kernel.org
Date: Mon, 13 Apr 2026 16:29:51 +0100
In-Reply-To: <20260410120318.253872322@kernel.org>
References: <20260410120044.031381086@kernel.org>
	 <20260410120318.253872322@kernel.org>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-kGTl9uf920QcQo+U2JVg"
User-Agent: Evolution 3.52.3-0ubuntu1.1 
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: 3D22B4001A
X-Stat-Signature: y3ko4mrnmtqfz9jszb17sxuquyu9q3xq
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1776094208-318894
X-HE-Meta: U2FsdGVkX19m3rNtc/NFA4T64blaxciAZfd1B9udqWOVlVbGiV2NiFrCIxDGkai+QLxwScwK7AyLEB5Aa8fy5kP8rrUfKNIjMQyP6VJY3XLWEujkDEUUaQDVFsHCCB5muL1fjbF7DtVFKLUTxlPp3vHnP8oz7bpQ9OUFr+gMLHnRRcASf2Si4pv4MWiAWU4X9JIvuQZ3PpOpPKzCDDb7uZ0qBzRkGVkP/WqOr+YAVfymYHEk4f39YKCwV4Fl4MakODPRG3C7nJhUhBBuKQlKgqeq7bu4ZXJN+a53js+DrPJ6nSrjQuKVEOUM7DMljMHPfBhgOQ3/I64Pu8GNxma7X/AYouGCJfozZXOIU2NMQMU9Ho4ZIO5XnQPbEjg6aNuzxCWc2rP/ejDhAtDMAAgH+I7koIzEMeuPc4n/KvoAhEcIK4TYDzCsWMuux47Tyhu/8IS2AfLNVRedHNtlmfq7KCYyVCKwQ9DwwD84FK3taUpjAobfIv8jmli01fnh8ct929nGbMGr/xGU0Q8YafECIiHYE6SJqj8sc2MRHspAXIRKZYFJtFc+VwlgPZbu6tXBPd0qaTdKPLIo0gKDlVvf09nM/4qByIUjzUbkMtO/FH8qdbxlxh8F3ReNJnLuyqp9n7PsvZ1f6L/L2EL1K840o3m6ig/uWF6iO77l2QQoxIxFEXldhppTnlw3FhYbt5XwFFxYp+BGHpAtX6SIC0bW1yC4MEjiNOhkTEDAJPUmAXg01lINN4K0t5xZJmWt5ss6h5vQWazIgF27lxZUVOrOBsA0Sr/27aTIAzvIT4YoM8w1N4bvErpnPuSMvZBYQ5f1NSPD9Q4SFA3uUzwVsvpoXbvTAVZDSeYrFNwIGlOjKG61TPhzmVnpDgG55v4jyFJxH6gAFF/b4wNjU6110/rTIc0YvlajZXsQaxZK0hFw2mekZvz9tK3I/6Mms0RZqZmmkmZpKum4R258/Nuqb93
 epOwYRjQ
 HTuwXsZNV3yGIa7Q061Ih5TvjyNUQTOToRryFX0qHO2XLH2hQCXWxe/NizxaDvDV9NWzNPtNVS9EA0wr7XfLI0Ox4iyIdFnFy4jqgFYsTbOn/Sav4etdqk5jNpXzdj0ZFLx6/2ESTn4TLEdo/+R9yJZKGFqRhwyhdvNvgaJpFSHqflAPgehtHspAeVlCZ/kDwlkDAgM+j8vrnzBQRXvYPf7cTPwsG5/yQjB65JqOYV6PXA2UH1JlEqpRgw2UoHYjyU8uLHSKDaQZiUKoo7uFX0wvYYjZLLrE8IpoC9lMbck7czi1YaIAwqUy2o405k1Ef8zvoeCkAms9Htofbpvy72DrWOE7NnbFxerHHneMbhjv9ZKcVBpIUBH44nLXgXy2aPgcM8h8sTjUkAD3PgAHFZCkNCsP9sXPF2ICiojdvBmfuzNaxHy6hNje4V1U0n/mUCXLT4xR6ZbVminiYgUQL40BvAHHzRg2ii2xivDNxGUPCTqB5yyUDgouc9j6c8571OVJ6nL+ckMOPl04XRXw/QhiHEsKV6leh6rtClk36I9DKcJ6MM8DNoBeH1y6sETbf4/mKduiBvgSgtITsdsbnI24EQzBCiK8kLoVNlBUkZ17SoTNkWUwu96YNVJxK+THqtTf7GMLerzkLWvFlAAy7A/y4QvfVxWWG6h5gPXkLs8loJtEzHrHtKJOAslEyPtUZqCcITI/SkREOnHsF++A7P9fzKkz2VFJ97h8bRtkgnWGqSQbW1SdOqGT6M58QidiCNi00UKqeRPV12+PS6K/okoUzPzoQOyB/haKGdZX4Ewt0827J1iEZhdpyApskIxY2BEOV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--=-kGTl9uf920QcQo+U2JVg
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2026-04-10 at 14:19 +0200, Thomas Gleixner wrote:
> ARCNET is a museums piece and the function timing can be done with
> ftrace. Remove the cruft.
>=20
> Signed-off-by: Thomas Gleixner <tglx@kernel.org>
> Cc: Michael Grzeschik <m.grzeschik@pengutronix.de>
> Cc: netdev@vger.kernel.org
> ---
> =C2=A0drivers/net/arcnet/arc-rimi.c=C2=A0 |=C2=A0=C2=A0=C2=A0 4 ++--
> =C2=A0drivers/net/arcnet/arcdevice.h |=C2=A0=C2=A0 20 +------------------=
-
> =C2=A0drivers/net/arcnet/com20020.c=C2=A0 |=C2=A0=C2=A0=C2=A0 6 ++----
> =C2=A0drivers/net/arcnet/com90io.c=C2=A0=C2=A0 |=C2=A0=C2=A0=C2=A0 6 ++--=
--
> =C2=A0drivers/net/arcnet/com90xx.c=C2=A0=C2=A0 |=C2=A0=C2=A0=C2=A0 4 ++--
> =C2=A05 files changed, 9 insertions(+), 31 deletions(-)

Acked-by: David Woodhouse <dwmw2@infradead.org>

By coincidence, I took the last of my ARCNET cards to the tip just this
morning...

--=-kGTl9uf920QcQo+U2JVg
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCCD9Aw
ggSOMIIDdqADAgECAhAOmiw0ECVD4cWj5DqVrT9PMA0GCSqGSIb3DQEBCwUAMGUxCzAJBgNVBAYT
AlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xJDAi
BgNVBAMTG0RpZ2lDZXJ0IEFzc3VyZWQgSUQgUm9vdCBDQTAeFw0yNDAxMzAwMDAwMDBaFw0zMTEx
MDkyMzU5NTlaMEExCzAJBgNVBAYTAkFVMRAwDgYDVQQKEwdWZXJva2V5MSAwHgYDVQQDExdWZXJv
a2V5IFNlY3VyZSBFbWFpbCBHMjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMjvgLKj
jfhCFqxYyRiW8g3cNFAvltDbK5AzcOaR7yVzVGadr4YcCVxjKrEJOgi7WEOH8rUgCNB5cTD8N/Et
GfZI+LGqSv0YtNa54T9D1AWJy08ZKkWvfGGIXN9UFAPMJ6OLLH/UUEgFa+7KlrEvMUupDFGnnR06
aDJAwtycb8yXtILj+TvfhLFhafxroXrflspavejQkEiHjNjtHnwbZ+o43g0/yxjwnarGI3kgcak7
nnI9/8Lqpq79tLHYwLajotwLiGTB71AGN5xK+tzB+D4eN9lXayrjcszgbOv2ZCgzExQUAIt98mre
8EggKs9mwtEuKAhYBIP/0K6WsoMnQCcCAwEAAaOCAVwwggFYMBIGA1UdEwEB/wQIMAYBAf8CAQAw
HQYDVR0OBBYEFIlICOogTndrhuWByNfhjWSEf/xwMB8GA1UdIwQYMBaAFEXroq/0ksuCMS1Ri6en
IZ3zbcgPMA4GA1UdDwEB/wQEAwIBhjAdBgNVHSUEFjAUBggrBgEFBQcDBAYIKwYBBQUHAwIweQYI
KwYBBQUHAQEEbTBrMCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5kaWdpY2VydC5jb20wQwYIKwYB
BQUHMAKGN2h0dHA6Ly9jYWNlcnRzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydEFzc3VyZWRJRFJvb3RD
QS5jcnQwRQYDVR0fBD4wPDA6oDigNoY0aHR0cDovL2NybDMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0
QXNzdXJlZElEUm9vdENBLmNybDARBgNVHSAECjAIMAYGBFUdIAAwDQYJKoZIhvcNAQELBQADggEB
ACiagCqvNVxOfSd0uYfJMiZsOEBXAKIR/kpqRp2YCfrP4Tz7fJogYN4fxNAw7iy/bPZcvpVCfe/H
/CCcp3alXL0I8M/rnEnRlv8ItY4MEF+2T/MkdXI3u1vHy3ua8SxBM8eT9LBQokHZxGUX51cE0kwa
uEOZ+PonVIOnMjuLp29kcNOVnzf8DGKiek+cT51FvGRjV6LbaxXOm2P47/aiaXrDD5O0RF5SiPo6
xD1/ClkCETyyEAE5LRJlXtx288R598koyFcwCSXijeVcRvBB1cNOLEbg7RMSw1AGq14fNe2cH1HG
W7xyduY/ydQt6gv5r21mDOQ5SaZSWC/ZRfLDuEYwggWbMIIEg6ADAgECAhAH5JEPagNRXYDiRPdl
c1vgMA0GCSqGSIb3DQEBCwUAMEExCzAJBgNVBAYTAkFVMRAwDgYDVQQKEwdWZXJva2V5MSAwHgYD
VQQDExdWZXJva2V5IFNlY3VyZSBFbWFpbCBHMjAeFw0yNDEyMzAwMDAwMDBaFw0yODAxMDQyMzU5
NTlaMB4xHDAaBgNVBAMME2R3bXcyQGluZnJhZGVhZC5vcmcwggIiMA0GCSqGSIb3DQEBAQUAA4IC
DwAwggIKAoICAQDali7HveR1thexYXx/W7oMk/3Wpyppl62zJ8+RmTQH4yZeYAS/SRV6zmfXlXaZ
sNOE6emg8WXLRS6BA70liot+u0O0oPnIvnx+CsMH0PD4tCKSCsdp+XphIJ2zkC9S7/yHDYnqegqt
w4smkqUqf0WX/ggH1Dckh0vHlpoS1OoxqUg+ocU6WCsnuz5q5rzFsHxhD1qGpgFdZEk2/c//ZvUN
i12vPWipk8TcJwHw9zoZ/ZrVNybpMCC0THsJ/UEVyuyszPtNYeYZAhOJ41vav1RhZJzYan4a1gU0
kKBPQklcpQEhq48woEu15isvwWh9/+5jjh0L+YNaN0I//nHSp6U9COUG9Z0cvnO8FM6PTqsnSbcc
0j+GchwOHRC7aP2t5v2stVx3KbptaYEzi4MQHxm/0+HQpMEVLLUiizJqS4PWPU6zfQTOMZ9uLQRR
ci+c5xhtMEBszlQDOvEQcyEG+hc++fH47K+MmZz21bFNfoBxLP6bjR6xtPXtREF5lLXxp+CJ6KKS
blPKeVRg/UtyJHeFKAZXO8Zeco7TZUMVHmK0ZZ1EpnZbnAhKE19Z+FJrQPQrlR0gO3lBzuyPPArV
hvWxjlO7S4DmaEhLzarWi/ze7EGwWSuI2eEa/8zU0INUsGI4ywe7vepQz7IqaAovAX0d+f1YjbmC
VsAwjhLmveFjNwIDAQABo4IBsDCCAawwHwYDVR0jBBgwFoAUiUgI6iBOd2uG5YHI1+GNZIR//HAw
HQYDVR0OBBYEFFxiGptwbOfWOtMk5loHw7uqWUOnMDAGA1UdEQQpMCeBE2R3bXcyQGluZnJhZGVh
ZC5vcmeBEGRhdmlkQHdvb2Rob3Uuc2UwFAYDVR0gBA0wCzAJBgdngQwBBQEBMA4GA1UdDwEB/wQE
AwIF4DAdBgNVHSUEFjAUBggrBgEFBQcDAgYIKwYBBQUHAwQwewYDVR0fBHQwcjA3oDWgM4YxaHR0
cDovL2NybDMuZGlnaWNlcnQuY29tL1Zlcm9rZXlTZWN1cmVFbWFpbEcyLmNybDA3oDWgM4YxaHR0
cDovL2NybDQuZGlnaWNlcnQuY29tL1Zlcm9rZXlTZWN1cmVFbWFpbEcyLmNybDB2BggrBgEFBQcB
AQRqMGgwJAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmRpZ2ljZXJ0LmNvbTBABggrBgEFBQcwAoY0
aHR0cDovL2NhY2VydHMuZGlnaWNlcnQuY29tL1Zlcm9rZXlTZWN1cmVFbWFpbEcyLmNydDANBgkq
hkiG9w0BAQsFAAOCAQEAQXc4FPiPLRnTDvmOABEzkIumojfZAe5SlnuQoeFUfi+LsWCKiB8Uextv
iBAvboKhLuN6eG/NC6WOzOCppn4mkQxRkOdLNThwMHW0d19jrZFEKtEG/epZ/hw/DdScTuZ2m7im
8ppItAT6GXD3aPhXkXnJpC/zTs85uNSQR64cEcBFjjoQDuSsTeJ5DAWf8EMyhMuD8pcbqx5kRvyt
JPsWBQzv1Dsdv2LDPLNd/JUKhHSgr7nbUr4+aAP2PHTXGcEBh8lTeYea9p4d5k969pe0OHYMV5aL
xERqTagmSetuIwolkAuBCzA9vulg8Y49Nz2zrpUGfKGOD0FMqenYxdJHgDCCBZswggSDoAMCAQIC
EAfkkQ9qA1FdgOJE92VzW+AwDQYJKoZIhvcNAQELBQAwQTELMAkGA1UEBhMCQVUxEDAOBgNVBAoT
B1Zlcm9rZXkxIDAeBgNVBAMTF1Zlcm9rZXkgU2VjdXJlIEVtYWlsIEcyMB4XDTI0MTIzMDAwMDAw
MFoXDTI4MDEwNDIzNTk1OVowHjEcMBoGA1UEAwwTZHdtdzJAaW5mcmFkZWFkLm9yZzCCAiIwDQYJ
KoZIhvcNAQEBBQADggIPADCCAgoCggIBANqWLse95HW2F7FhfH9bugyT/danKmmXrbMnz5GZNAfj
Jl5gBL9JFXrOZ9eVdpmw04Tp6aDxZctFLoEDvSWKi367Q7Sg+ci+fH4KwwfQ8Pi0IpIKx2n5emEg
nbOQL1Lv/IcNiep6Cq3DiyaSpSp/RZf+CAfUNySHS8eWmhLU6jGpSD6hxTpYKye7PmrmvMWwfGEP
WoamAV1kSTb9z/9m9Q2LXa89aKmTxNwnAfD3Ohn9mtU3JukwILRMewn9QRXK7KzM+01h5hkCE4nj
W9q/VGFknNhqfhrWBTSQoE9CSVylASGrjzCgS7XmKy/BaH3/7mOOHQv5g1o3Qj/+cdKnpT0I5Qb1
nRy+c7wUzo9OqydJtxzSP4ZyHA4dELto/a3m/ay1XHcpum1pgTOLgxAfGb/T4dCkwRUstSKLMmpL
g9Y9TrN9BM4xn24tBFFyL5znGG0wQGzOVAM68RBzIQb6Fz758fjsr4yZnPbVsU1+gHEs/puNHrG0
9e1EQXmUtfGn4InoopJuU8p5VGD9S3Ikd4UoBlc7xl5yjtNlQxUeYrRlnUSmdlucCEoTX1n4UmtA
9CuVHSA7eUHO7I88CtWG9bGOU7tLgOZoSEvNqtaL/N7sQbBZK4jZ4Rr/zNTQg1SwYjjLB7u96lDP
sipoCi8BfR35/ViNuYJWwDCOEua94WM3AgMBAAGjggGwMIIBrDAfBgNVHSMEGDAWgBSJSAjqIE53
a4blgcjX4Y1khH/8cDAdBgNVHQ4EFgQUXGIam3Bs59Y60yTmWgfDu6pZQ6cwMAYDVR0RBCkwJ4ET
ZHdtdzJAaW5mcmFkZWFkLm9yZ4EQZGF2aWRAd29vZGhvdS5zZTAUBgNVHSAEDTALMAkGB2eBDAEF
AQEwDgYDVR0PAQH/BAQDAgXgMB0GA1UdJQQWMBQGCCsGAQUFBwMCBggrBgEFBQcDBDB7BgNVHR8E
dDByMDegNaAzhjFodHRwOi8vY3JsMy5kaWdpY2VydC5jb20vVmVyb2tleVNlY3VyZUVtYWlsRzIu
Y3JsMDegNaAzhjFodHRwOi8vY3JsNC5kaWdpY2VydC5jb20vVmVyb2tleVNlY3VyZUVtYWlsRzIu
Y3JsMHYGCCsGAQUFBwEBBGowaDAkBggrBgEFBQcwAYYYaHR0cDovL29jc3AuZGlnaWNlcnQuY29t
MEAGCCsGAQUFBzAChjRodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20vVmVyb2tleVNlY3VyZUVt
YWlsRzIuY3J0MA0GCSqGSIb3DQEBCwUAA4IBAQBBdzgU+I8tGdMO+Y4AETOQi6aiN9kB7lKWe5Ch
4VR+L4uxYIqIHxR7G2+IEC9ugqEu43p4b80LpY7M4KmmfiaRDFGQ50s1OHAwdbR3X2OtkUQq0Qb9
6ln+HD8N1JxO5nabuKbymki0BPoZcPdo+FeRecmkL/NOzzm41JBHrhwRwEWOOhAO5KxN4nkMBZ/w
QzKEy4PylxurHmRG/K0k+xYFDO/UOx2/YsM8s138lQqEdKCvudtSvj5oA/Y8dNcZwQGHyVN5h5r2
nh3mT3r2l7Q4dgxXlovERGpNqCZJ624jCiWQC4ELMD2+6WDxjj03PbOulQZ8oY4PQUyp6djF0keA
MYIDuzCCA7cCAQEwVTBBMQswCQYDVQQGEwJBVTEQMA4GA1UEChMHVmVyb2tleTEgMB4GA1UEAxMX
VmVyb2tleSBTZWN1cmUgRW1haWwgRzICEAfkkQ9qA1FdgOJE92VzW+AwDQYJYIZIAWUDBAIBBQCg
ggE3MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI2MDQxMzE1Mjk1
MVowLwYJKoZIhvcNAQkEMSIEICWq9Tw93kgoeMQ9F5qJ+YhMr6w729C1ImFtgihFCjxfMGQGCSsG
AQQBgjcQBDFXMFUwQTELMAkGA1UEBhMCQVUxEDAOBgNVBAoTB1Zlcm9rZXkxIDAeBgNVBAMTF1Zl
cm9rZXkgU2VjdXJlIEVtYWlsIEcyAhAH5JEPagNRXYDiRPdlc1vgMGYGCyqGSIb3DQEJEAILMVeg
VTBBMQswCQYDVQQGEwJBVTEQMA4GA1UEChMHVmVyb2tleTEgMB4GA1UEAxMXVmVyb2tleSBTZWN1
cmUgRW1haWwgRzICEAfkkQ9qA1FdgOJE92VzW+AwDQYJKoZIhvcNAQEBBQAEggIAF2v1t0NNvA9R
Y/eA55NxK3TZMe94oxYBqcXF6qRUkayrUgndnrU8aJ75/Bj1TvINyOboZfKk/49c2w/wZOyOUE0L
wvFeYUHN7taPRGCYmiRRxay6cRI7P01GTAg4BTI9mhaxjDMwqRmzK6U7kMbVk6ZZpUOcQDAhZqME
RRSEeosxUsKBXWhUcKwwISnwfMCHpG0VrrcywSvheGipfYrl0r/+SUFpCDbktajsPhO8lPbtMKAX
XExpwh88BCI+A1+hevVUd276InlzNOYd2CawQelqvMX2Ym/VGcG+AoSKWBSH5fhczq4rbBBsqmFD
cbEGxUY96DOmPLHR1qNvcYvY6itLYE8H7kdovxHZ1P6pqX2EiflVkHBNz2aMu5WOHoFEitdFuO/K
aTXwJFmhjaEvv6DOL4pVkHSJPfyUxqbqXgDlRFts5KF18nX4+QZklgshL936nLvpUz5asDSFoMQs
UVUSfGa0oL6jPEimso9TAX0xs2+CDPcBXpUXhVtFd2mQ6OlRr4Fr7vgOS+9CCv3t0qrMAo45K9qa
dYdET4QgaVe3hthkoRcSHu0A8r3bt7d3+ZmaIko2iRbuZL1r6dhNFgJ36vhGv0/1ErQoPUaNaQuC
g/fGaJ5ARXfMWiOfXQPMQ9V/v8woxotz8SbH1TtMDXr4BJhlw5Va4uX0SpA0+fwAAAAAAAA=


--=-kGTl9uf920QcQo+U2JVg--

