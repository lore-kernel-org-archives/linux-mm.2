Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B09E3F34C5E
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 15:33:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28DAB6B0096; Mon, 13 Apr 2026 11:33:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 264786B0098; Mon, 13 Apr 2026 11:33:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17AAA6B0099; Mon, 13 Apr 2026 11:33:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 057256B0096
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 11:33:22 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C0A538A5CC
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 15:33:21 +0000 (UTC)
X-FDA: 84653926602.09.2C59389
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf21.hostedemail.com (Postfix) with ESMTP id 00AB31C0012
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 15:33:19 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=gvEodDXy;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf21.hostedemail.com: domain of BATV+feefc7fe6e280d16f9a0+8268+infradead.org+dwmw2@desiato.srs.infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=BATV+feefc7fe6e280d16f9a0+8268+infradead.org+dwmw2@desiato.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776094400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pMyc546A8Vk0VhSxh5jSMOtHszp9PyQiNzOlGW+Tlac=;
	b=PWlrGiAuy/ebRIBfPT75ZhNqR4IehwiKsYpU/fm8QAxa6iH6+RBhVjOeSVz0iqiGyCWGwg
	3nhIPnrn1cqizCfrVm+fs2mZ+kpjn8/XXHPsl/tnvv2VU1scrmV1E9zAa2xKt2LRMhxgCV
	bSEfvzobpoczYg1ThYJYrFjW+xzZDCY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776094400; a=rsa-sha256;
	cv=none;
	b=XVBbnXrOL9RBDIMadgB1gi38bWSUMpWKwybR1OFRZdwrTpsYCTHoWzIf0xiOa9mz82XUOG
	k0H+gMZgZWZ2KRIMQGiU1qpSsqo4qEs5l7IJFUeX95Ezu/Rk1yE9Welp0Pg3NDl9NIIQZG
	0CWatpevWVz87VVbHQvJiIRvCTb64Ig=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=gvEodDXy;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf21.hostedemail.com: domain of BATV+feefc7fe6e280d16f9a0+8268+infradead.org+dwmw2@desiato.srs.infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=BATV+feefc7fe6e280d16f9a0+8268+infradead.org+dwmw2@desiato.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=pMyc546A8Vk0VhSxh5jSMOtHszp9PyQiNzOlGW+Tlac=; b=gvEodDXyVRhr3ht5KLvvYUHruq
	Vr6/Nk8hYRocARm5fuOZlMoKF+85eiOOvk45UWaJEUhV71TuTffj9ccPPnvJsusON6fJc5Grsy5jI
	iNNAvdI28ex09hHo60SsASOsHG9j1//cpT5bdeKExgSUokyNtM/888qR2IIJJJn5k0YY4ZHvZ/iUY
	JYS9o9fm8cesNcUDQtQkHs5oojlgzNoY+sKaw+Kqth7jk3I7NtkAAk1lZIJtE46y3HsqbFIeXRzUn
	UNa7OJ6p8M3XCoCofzGj4msg6NLCmsGATi2zcxDsbslkmxZrkCEEoEdgUxSWU6wiTsaySOA61u8BB
	0y1VEngg==;
Received: from [213.122.4.78] (helo=u09cd745991455d.ant.amazon.com)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wCJHl-0000000H2um-3OE9;
	Mon, 13 Apr 2026 15:33:13 +0000
Message-ID: <7a48b636cb3146f4f7134c6d4fe42070ac2edb43.camel@infradead.org>
Subject: Re: [patch 15/38] ptp: ptp_vmclock: Replace get_cycles() usage
From: David Woodhouse <dwmw2@infradead.org>
To: Thomas Gleixner <tglx@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, x86@kernel.org, Lu Baolu
 <baolu.lu@linux.intel.com>, iommu@lists.linux.dev, Michael Grzeschik
 <m.grzeschik@pengutronix.de>, netdev@vger.kernel.org, 
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
Date: Mon, 13 Apr 2026 16:33:12 +0100
In-Reply-To: <20260410120318.592237447@kernel.org>
References: <20260410120044.031381086@kernel.org>
	 <20260410120318.592237447@kernel.org>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-vt+GQ8cE1r98bSrQsw7r"
User-Agent: Evolution 3.52.3-0ubuntu1.1 
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: 00AB31C0012
X-Stat-Signature: 1tuwkpktadwn3dbaizr5spwfjmrsg3ro
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1776094399-201699
X-HE-Meta: U2FsdGVkX1+lOY/XLyNVUppgZglYLLYq2yGeiBMTz1qEeFoo4Q1ZQ1B/lD1aFJMCdhmDPgqYPNS6niF0ZFwb9fE/nh69llZmQcBLB4lcIJRcNayTxx9ZMpcDqwtDFDRWsycWhFGDsEvCKmSgqyAJNZNZs8MQRNo77YOk9pMH6O4nSUC6c8vWIwOuBnG86DkKavPjjmf1nvExcGZcnnHlukbbPFY/he/VdrL02b8xkfiBH38boCeQxOU29qJ8wdlWI1dIoN4x2V66v2O6wrE3QF1UT82ph2XJFAZ78RVI+0arK6M1bU2zEWuGk8NFRIuKHi7qjFQ2iU/oP0mBxtIPTdJLe8xP5M/hNQdayOx1hlbbCrFdHfOFVAEkcNd7x8WxdmYvmaihk9a4B3wq/tnvKMUUt0ggrlNVlMLolXw18dbF8mofb3WjyFxA1vYZePEqaIgFL+1T0+9MgTQuB6Lht2CpyvJ2cuBzuOSE7hKZLs7sQOK/0JwmMf1e6k+jnCT38xcYsfYsGFnULSVk9o4pcYrQu3JWJoleUh/Fh+GLxYFLBV5Zbs5KApclLZDJsNPlvgIH5+tAI1rC0B1gC4fddcPiR6PXadd/YcEAH8NWVpIQZdteTihn0fQAETyjf09Znmknk1kkx+yDaIQnZ0S1/k3R+l097U+K63UA7z9pbJnTbuQw/nBFmuwMFJHLot1WH7RWuf1PB+0lRuKcsQBEs5Z3x9C1Bmhm1SlIJ0NJk58dme0HXuZbt1Z07WQNShgtqjHVQlApTa8HkzF6N5NNj7aTW6+GktrKksnVcJxhEfHAJGXr6nj0TgsqMLctD1mK0byhtjnf3aRBsVb8M7OkI5hHg7S4Gv/UoNZu2eCqLW9+XnPejuo3tNeZdGr6iYgEADx+Ok2rAflth+Qe4ZHIgAg/V0J6ZKKz0zbmpG3dzlndoG7MrABql8ruL8I2KgFYtNS6uiVFzJSG9EGiKIk
 DmwgMEeI
 +kJxk0snRYbIg8gzcl9T5zBbVu+R7zdzPF/oGDBnsxFgnKA+T3V9rYCy/MZh+JAYFcJ28fPmDcIp4VRTNtSY5RiCbhBWJ9aQsCh+gOZW9w55fSwgr+LQzCk9aiMfmeZMNrb2+4aH02kil+mC+sIJRNyIePf9T8uD3bbvupOW2AzO9El3noTNqJi46vB+mDGxQrAUI0PgmK/rjbjhGGuuV4NhxD+813ikHDUWjxlFqdTp7rP2LPiT5VRnzqtZ+ugaavZ4VsvSrAZd1/MsIAly8D8BFWo4QHgbKKpbogtW5E2ecBZzMqL9STq5HtNjUTm3VzQkPEKgmE2y+BCBFfbIZTRG8qVpN2KX4LdZYGSEdOPmsQqZoKndYOfDlmfHj3MBoZv/kEmJP9WwxBwU6vC1uUYTrUrwFcmFI2Twk8xbRAxPD0sHmqFdhT4RdJEsU/ha1CMqHr2pADgB0b0rRRT8gPwaGTM3JeEQzKXpFdc+8L//R8dU/NgmTS1I6O+1lknM+eaJr+OsRB2HmAqOMdVx6pQdrHzsOV+M1GaTRiuP2RRjcYiNW7BvpG4oBoxcZyW5BGQi2d3ALTsDESSga3C9jpdUPVN/ePMp1USAnYMc4h4Somq5pO+3igQb6XYuQBsX7a6R8S4Ir3eZSv11W+Ms87bk3aDe8+OkI6REZMOpcYQ/hgPgGPeSPKil9mYA7r0lIwsWGsx/JijabN+jfZSbaLl/Gi5+z45hVu34fL/UHJ3ZlUVIGfC83EHZTrKxTiQRLlSUJ+CNY3/CSxmJghxKG7DcQf9PZ/zqP+KkrwqKF86nWSl2d76tPKYROHC9tbxQ7OfALZcxPc/pWRDdj1tfYHSvdjD5T8r3G9t/iwFzr9o5iaxtt9Dn483x4byrFJXeZAxDVOlpuLiWw0JE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--=-vt+GQ8cE1r98bSrQsw7r
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2026-04-10 at 14:19 +0200, Thomas Gleixner wrote:
> get_cycles() is not really well defined and similar to other usaage of th=
e
> underlying hardware CPU counters the PTP vmclock should use an explicit
> interface as well.
>=20
> Implement ptp_vmclock_read_cpu_counter() in arm64 and x86 and simplify th=
e
> Kconfig selection while at it.
>=20
> No functional change.
>=20
> Signed-off-by: Thomas Gleixner <tglx@kernel.org>
> Cc: David Woodhouse <dwmw2@infradead.org>

Acked-by: David Woodhouse <dwmw@amazon.co.uk>

Although I might follow up with a change to make this...

> +static inline u64 ptp_vmclock_read_cpu_counter(void)
> +{
> +	return cpu_feature_enabled(X86_FEATURE_TSC) ? rdtsc() : 0;
> +}
> +

... depend on TSC_RELIABLE=C2=B9, since if the guest doesn't believe that i=
t
is, then the guest shouldn't be trying to use it as the basis for
precise timing.

=C2=B9 (Or... one of the other zoo of TSC flags for the gradually reducing
brokenness over the years...)

--=-vt+GQ8cE1r98bSrQsw7r
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
ggE3MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI2MDQxMzE1MzMx
MlowLwYJKoZIhvcNAQkEMSIEINhM0B01ygaCz6Xe0qE2NJYaKBfHsATydjMA4/6Wd4kYMGQGCSsG
AQQBgjcQBDFXMFUwQTELMAkGA1UEBhMCQVUxEDAOBgNVBAoTB1Zlcm9rZXkxIDAeBgNVBAMTF1Zl
cm9rZXkgU2VjdXJlIEVtYWlsIEcyAhAH5JEPagNRXYDiRPdlc1vgMGYGCyqGSIb3DQEJEAILMVeg
VTBBMQswCQYDVQQGEwJBVTEQMA4GA1UEChMHVmVyb2tleTEgMB4GA1UEAxMXVmVyb2tleSBTZWN1
cmUgRW1haWwgRzICEAfkkQ9qA1FdgOJE92VzW+AwDQYJKoZIhvcNAQEBBQAEggIAPYfq/9mmd2s1
SP00p3hmk+X0WHZfkinMkii2h4lyVacxXwjoSGz8t80VTtFXokPrNGmGsYArmww2/rp2kj+/Tv5G
XXj04By7oFvcWZcv2ehQjgcnWXEG18Dafmh1E3ex6fNQlKS01kTelj7gzlUuq5WHZWL3834SA80P
ycGZ1cFYLKrMHDHiR1ojUZbK226biYdF+3CITBRUH+85ncmQSJgKEB0hg76bNY+FrcuOqK4r9z2/
PiptBoGJP4Q3UiXzXL4HpKBjHw7gx2nunSkEUUNyz9jLn+KcfUI5YmtecSlY8WbD17I+qPOlgJL9
YHgpFL0zB0tzC9LuYFhVj9avlC4wi9Lcy7vcq8FKbQlepK7K3T9INa2xGQ6MKaOFRX7TgfnMARbl
bRhvZ825233jpAPSdlet42tjpXXxw0D1JNWWCFZq3ittr5uj23ozIePJ6uBH0omp2DEM5kBhFAGC
DNsqsmx7AKJ3NlZGmvR/IESk+AAvXHPXRjS/accB3/y56R7/gYbjv7gLhOXxr4INAnrsrb5w7z0d
97lJiQhmYkR0+QRzLN66f6R0pYPixVACLMzcASk8IUr3sgtALCeoVmXWe0UzNbqhx8r6WCBVaHgO
OygxmWQEtvOdDNB9gmza2s3JOTNNKHDHGJPsXwq64B3ty5nq7n89MMET0ooGW5sAAAAAAAA=


--=-vt+GQ8cE1r98bSrQsw7r--

