Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 918DECCF9E0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 14:47:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0B178E00AB; Fri, 24 Oct 2025 10:47:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E94388E0042; Fri, 24 Oct 2025 10:47:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D35598E00AB; Fri, 24 Oct 2025 10:47:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BD1258E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 10:47:54 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6A3201A0E79
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 14:47:54 +0000 (UTC)
X-FDA: 84033287268.04.C7702FE
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2B5F64000B
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 14:47:51 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=IKkdLumc
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761317272;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vqFLBMeCF7CFCbe19l4VmgAvbXXScMbZ2sOBRvHUFps=;
	b=rKQrMLxHNPkwV+sZ8mgcF4l9+MvmSdL/tjBWrCbnFvjr2ZuUHkC29tcUabSaz/gtD0LswF
	L7e4AutDzOUcFcsHyCmQXc8vG0+8LkZdTDR5Qd0tM58edt04eZMN+iQ0aeHqWK/EcVK0Ts
	Xi+Yg1DXPEyRWq9DFe8kZBC3JOQsaSg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761317272; a=rsa-sha256;
	cv=none;
	b=60eEiQeA21aAHXgm9k/AXZM/yv9jYeErYqAEXlq+shH2IJQYECo5Ro29PI+TLuT6WCxIMi
	S3qKPSOpQKcTGWSa1OlIW/OSYZ3q66lh6/9+K0z4RPS1eRhuu4e/8Epuf+6MN18jeIcgAq
	04/wV1m7Ju0Zx6wUpvUqSkrYNPi/oyU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=IKkdLumc;
	dmarc=none;
	spf=none (imf04.hostedemail.com: domain of BATV+b7f0eb53100f8146c054+8097+infradead.org+dwmw2@casper.srs.infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=BATV+b7f0eb53100f8146c054+8097+infradead.org+dwmw2@casper.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=vqFLBMeCF7CFCbe19l4VmgAvbXXScMbZ2sOBRvHUFps=; b=IKkdLumcFBTV2g740ImMBco/ao
	zTxg88/C31loa/DvTJsAtejfRX51CjAeJWW/3zhHVaucxjAb1/O5wdm4k5Y/ZxKoyWOYrr/9qTAt0
	mzxnbI3iirB6ReChD9/pYVynbQsaGsv0X/xel2wytNJG4Zm9FkbCx31Zuz752zr1TnJZU3ZxGFQm/
	WU7s1ljot4DDGAldGT2wRQUQt3+LwfS22Czh25yAnm1XNj5HnjGeVq5W57wjo5Zz2odUTmZiDYYAp
	UlKEch7rkUmGzu80YLM7Xt2Ws2NLsw3KhwANFV03LwYEzLJZp71LOGRBuz7HJgUhJ9CM8lYmRAvmM
	/cnTMOvw==;
Received: from [2001:8b0:10b:5:d8ad:45c0:47cf:4bed] (helo=u09cd745991455d.ant.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vCJ4w-00000003ExO-3GpU;
	Fri, 24 Oct 2025 14:47:44 +0000
Message-ID: <348e5f1c5a90e4ab0f14b4d997baf7169745bf04.camel@infradead.org>
Subject: Re: [PATCH v3 11/13] x86/xen: use lazy_mmu_state when
 context-switching
From: David Woodhouse <dwmw2@infradead.org>
To: David Hildenbrand <david@redhat.com>, Kevin Brodsky
 <kevin.brodsky@arm.com>,  linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Alexander Gordeev
 <agordeev@linux.ibm.com>,  Andreas Larsson <andreas@gaisler.com>, Andrew
 Morton <akpm@linux-foundation.org>, Boris Ostrovsky
 <boris.ostrovsky@oracle.com>, Borislav Petkov <bp@alien8.de>, Catalin
 Marinas <catalin.marinas@arm.com>, Christophe Leroy
 <christophe.leroy@csgroup.eu>,  Dave Hansen <dave.hansen@linux.intel.com>,
 "David S. Miller" <davem@davemloft.net>, "H. Peter Anvin" <hpa@zytor.com>,
 Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>,  Juergen
 Gross <jgross@suse.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Madhavan Srinivasan
 <maddy@linux.ibm.com>,  Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko
 <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, Nicholas Piggin
 <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>, Ryan Roberts
 <ryan.roberts@arm.com>, Suren Baghdasaryan <surenb@google.com>, Thomas
 Gleixner <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>, Will
 Deacon <will@kernel.org>, Yeoreum Yun <yeoreum.yun@arm.com>, 
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org, 
 sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org, x86@kernel.org
Date: Fri, 24 Oct 2025 15:47:43 +0100
In-Reply-To: <f0067f35-1048-4788-8401-f71d297f56f3@redhat.com>
References: <20251015082727.2395128-1-kevin.brodsky@arm.com>
	 <20251015082727.2395128-12-kevin.brodsky@arm.com>
	 <f0067f35-1048-4788-8401-f71d297f56f3@redhat.com>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-KCNFYCezFnaGZQ+WN2tw"
User-Agent: Evolution 3.52.3-0ubuntu1 
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Queue-Id: 2B5F64000B
X-Rspamd-Server: rspam02
X-Stat-Signature: 76s9idth5q6u5xb6m8b6on5dhnwcx6hx
X-HE-Tag: 1761317271-303623
X-HE-Meta: U2FsdGVkX18zOdLX4zi2iomLfwbvPJOopFfsl6Iue0SRwCR+gbFbfmPdng3GJhukla6NvCe1Dh9gNdoY/YCFTFOlnZjd+HOSFXMHcKrADjMybJDTyXw6wUfUNR+9WdLWAfF/CAteAT21FHfjumZB4gPD3eMmiIG8wgHKUnhG6NNv79EfT5AB3uDIoTODvG1ol48owjGcV6UI9KpOoch9O0YkX2cKTKgYXzhaOOiwclkB77lOSgUOsVWoILO4epxKlb47xk9CCYemQK32WOg2zaj2Bxk7Le/ZwayvPYrDa7n46xF610b7O2EejZqK+VoCvPi7oIEUumtH3NaQecFzgQ3KaiVFGrHL26Nth18m1iTTrBMguOV5DIeM8vMYL9ERk9utCddeC+bNygs0zqCkp4otBvtTRaQPIgpJiJLczsZcYzQ0Wmi3QP17DiipxJ3ws5IZ8DzO/an2XoF59kxpWlsOJxbdprNgQ/QulLiSyfMbeMotd+yy5BFSFlOeVHeiMpUP472IpwGx8C5to2ztCDWEMOI3AwCTueePpF49pwdzNavYCtgKqXtUD4+XvsavwtUMMQ62WG1JFb6+ex2T7eCveIePgwdh9UTdYNzL98UVtO1qMA5vHH9PCHR6Ankt8j59U4wge/cWVLDFupOK2f/+DdjbMLKVcG55Q0iJNFZncng0q0z05IIdy0TuyXk94WlWf3G8YB27OTevrHzyiyDQKt9MOYlsnZmku7761Q2c6S/XzYEHgN594rLOKwp0dptcVN61KTxE/gs9+HZI/auvX+swgFQ568eRkPfa8eJgBjGc0BpOH06snG/y2I/U/kZv60VGLppGUuSET2Hpmub861KReZUso1FrIOUOoGZzf/UtHr0RHuxDG/4x1B4Wy6z+AHFH0M7dAKYeto51V0KTDS15uD9P6YgHtsCpNzKhFzhjCscgunwkk+H7nIwu9Fjew3/MGVu6u8qs1bB
 Qu1sg8mu
 gDqPgROVZdsNT1mmaEkjAA+NcEyzoiEaxhthzkuUoa8WWcWJSBurwKHnXhC6dJQxdkqfveX1QbxaEWQOjScrqCirlee113FZKiePIIXuovNNRF8mLVH2VAOLvnSFVjpNPWOe4sHoRyxNlwFscB0ClxkPJaMTNoIRkI1hwKEZkSjPJQOd1YTGJfG8ebzM3wL07U/U0lwqUOb6eBFQ/KtMSy/vm65wYV2FXxP5Z6+8YOb3K5Ca1CqM/s+84f+QyLP252yksG7UCArgJXWpHZyKgFXXL/gL3V2ZYWEpozIHLYXc/MdsFa50AoF8OB+q4U+LcP1MmiJ9F0MfMCDIFmh0IUsnFACpoIfQdSko/cFX0eQYSweLi24G3+HLB2f2z0Z4vRrjeaTdMF4xSHY0+v/4vUY1mdk9HStgYxH25YKLbmHK+/7LK/jg4tJSDvjcJOpVTf+Z/3U7z/FInY6IQI1PORBNDzCu+taQyylRjeMlHj1HJ6OoGqH9+5MtCEkyoeAwjFx//g7xLdKFXf2WpJeJIeUMF5uM7GWqxvymoj7LcC10c2yw9LrNBmWXbPywiNau2sSsZelxyBzB+MKNXW574Pk5hQVfdXD0kHiE20s4e7040N/LAvZg3w0LhHZEYNBVpng4gJHavergT+stAB9OQyLUWMy9uoRCe3R5SFlRGctWVtGyLfHiOHXX81f9JRoRAczaQAcvSz+avu9FCaD9KcfcaanipbbWDHE7B
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--=-KCNFYCezFnaGZQ+WN2tw
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2025-10-23 at 22:06 +0200, David Hildenbrand wrote:
> On 15.10.25 10:27, Kevin Brodsky wrote:
> > We currently set a TIF flag when scheduling out a task that is in
> > lazy MMU mode, in order to restore it when the task is scheduled
> > again.
> >=20
> > The generic lazy_mmu layer now tracks whether a task is in lazy MMU
> > mode in task_struct::lazy_mmu_state. We can therefore check that
> > state when switching to the new task, instead of using a separate
> > TIF flag.
> >=20
> > Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
> > ---
>=20
>=20
> Looks ok to me, but I hope we get some confirmation from x86 / xen
> folks.


I know tglx has shouted at me in the past for precisely this reminder,
but you know you can test Xen guests under QEMU/KVM now and don't need
to actually run Xen? Has this been boot tested?

--=-KCNFYCezFnaGZQ+WN2tw
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
ggE3MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI1MTAyNDE0NDc0
M1owLwYJKoZIhvcNAQkEMSIEIOfSUBE+nGvcCdS59evaaEUM6X0l1dKQqIR2JuhOpcoFMGQGCSsG
AQQBgjcQBDFXMFUwQTELMAkGA1UEBhMCQVUxEDAOBgNVBAoTB1Zlcm9rZXkxIDAeBgNVBAMTF1Zl
cm9rZXkgU2VjdXJlIEVtYWlsIEcyAhAH5JEPagNRXYDiRPdlc1vgMGYGCyqGSIb3DQEJEAILMVeg
VTBBMQswCQYDVQQGEwJBVTEQMA4GA1UEChMHVmVyb2tleTEgMB4GA1UEAxMXVmVyb2tleSBTZWN1
cmUgRW1haWwgRzICEAfkkQ9qA1FdgOJE92VzW+AwDQYJKoZIhvcNAQEBBQAEggIAMciufJy9MYsd
WDeEJi4N/JtJvd8gDYSUyaj83ryN94rodLX7VsGJV0GMY0I5t4a1loCRKuIWocUO7VMyQndw4FMK
CD87Xv9h7CmQ6tnvJ3jx1pBPxCms8AMYDNO3psl26IMAf/pBtn2tK4o2ekbEydTz/HB5CU9eHPLV
6hrsUsiw9ELTG53GPQJx+au2JS59MKinh3d+fnIF1uaAksAwrSkko1T1ycGhO0JpoVqvNH18S8aL
lU1FZ6hXNw+0R/PrlIr7OgD2GxTw+5anbQS5kAAnRqarQ+T3tfm+Iv8kG8mJYVDmATySDmWyHl5V
ICeY/G1bGQxQkdmqVQb4uCHVMVVX60TdQa7YCnM3VEDG0WLBjXMmXSykmDUImZEAAxYuYx/fejHB
f6vXUJ6x33DqYjzS15hZExL2+alyKMf7Ib1A7i5kNgl84K4y4qsHU0Mm7ro71EXlbYYjgTR4FpoX
dMp+UqZDufv2snXQ5Hy0XHc0aEC2YIMr1gbWIYdJfsAqXf+B8z8F/snlrvMO0egz0MX2A3TJQxyO
++dEvJWyDBwCCn1+KreR8fCJQKqgZH1dpNtTLvcx1VM+WFzygiroB28JeYqGVmh6JdKQdCx9QJHU
zoV58DbEVN3gjtbuo/9SxAVum5oqvEguswdV/Lbw4vyZtoOXKhyzgxoNJajSsTsAAAAAAAA=


--=-KCNFYCezFnaGZQ+WN2tw--

