Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42D57C83F26
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 10:28:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7E4F8E0006; Tue, 29 Jul 2025 06:28:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A53D68E0001; Tue, 29 Jul 2025 06:28:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 990EB8E0006; Tue, 29 Jul 2025 06:28:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8B6F68E0001
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 06:28:48 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 09CDEBA155
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 10:28:48 +0000 (UTC)
X-FDA: 83716928736.21.5A4A30B
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf01.hostedemail.com (Postfix) with ESMTP id A568E40002
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 10:28:45 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="X/wEgvia"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753784926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a1SNTB3HV/Vkobm2cpRVdmqRXLm1fwnmhOsOUHtpies=;
	b=2RNUoVnYji4pSlAas1U06sFPXixjImYcwoHZgf1BKQewA7MXvwXKGN9Lori8K+ZZePEcdB
	eLrGorDFFS5iWtXdpZSryL1v8uAuf/lswLeZw4kzOTdymTG5a5cfaKljHxXnA306SEZ/+l
	NcmixkUlXf35O0+CegZOE8L3XCzFMWg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753784926; a=rsa-sha256;
	cv=none;
	b=sUiXFXnuPtYfOLfNH+Q8INczwVBLwEcjUCgTFlcyCy24fi2yVZjwc7IbExZnyfD3Te8lmn
	j9VYdK2TEcwV7NEIo9IJEUV0IT5xacJ3TuUltHCD1gPALmElsaA8ckNgQs2M41cPxR+0wV
	fMMfk7LZsRHbZ22plMmW8cTcxC0YBiw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="X/wEgvia";
	dmarc=none;
	spf=none (imf01.hostedemail.com: domain of BATV+273e513e9f10dcf314a0+8010+infradead.org+dwmw2@casper.srs.infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=BATV+273e513e9f10dcf314a0+8010+infradead.org+dwmw2@casper.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=a1SNTB3HV/Vkobm2cpRVdmqRXLm1fwnmhOsOUHtpies=; b=X/wEgviad7X8B4WGaQQbexYBrc
	b1nGIL2gA4D9I5hs5dtqSIA7AcPfjogKDHJBwQV2e406Tfl4YOGC2R/Qsw5+HJ8ludPBkG/YLf5Rn
	V9PvEEJN7FgrTkJkju7u3+R/W+IP2TWQitC+ucMDfRn9WScDVs4V1N3BGSUWnaVDWAkzpG3B6fU28
	3HUIFz11Jtxn/E8jZS6q1J1tQZkxom8KjLbFdH2pMO48R1mm/nVltyEG3+Yt/7Jp83xXzTrKsWMLn
	tUhC+wq9Oi0Bdm6UQxoNTW8j5GhvLhAV91RZufcfanE0kvJlPsJKXdtdWX5hS8tqNYvvoatQS2k1M
	7vC2OAow==;
Received: from 54-240-197-232.amazon.com ([54.240.197.232] helo=freeip.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ughZC-0000000B59l-2sVB;
	Tue, 29 Jul 2025 10:28:19 +0000
Message-ID: <1b955b6b9b49a7f03fae12d9b13b027822749527.camel@infradead.org>
Subject: Re: [PATCH] KVM: x86: Use gfn_to_pfn_cache for steal_time
From: David Woodhouse <dwmw2@infradead.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Carsten Stollmaier <stollmc@amazon.com>, Paolo Bonzini
 <pbonzini@redhat.com>,  Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
 <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin"
 <hpa@zytor.com>,  nh-open-source@amazon.com, Peter Xu <peterx@redhat.com>,
 Sebastian Biemueller <sbiemue@amazon.de>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org,  Matthew Wilcox <willy@infradead.org>, Andrew
 Morton <akpm@linux-foundation.org>, "linux-mm@kvack.org"
 <linux-mm@kvack.org>
Date: Tue, 29 Jul 2025 11:28:18 +0100
In-Reply-To: <b69ed9d08eb86a346a1d092575abe99512fa875a.camel@infradead.org>
References: <20240802114402.96669-1-stollmc@amazon.com>
	 <b40f244f50ce3a14d637fd1769a9b3f709b0842e.camel@infradead.org>
	 <Zr_tRjKgPtk-uHjq@google.com>
	 <b69ed9d08eb86a346a1d092575abe99512fa875a.camel@infradead.org>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-63LQhDGVG/7VLT4oj6Vn"
User-Agent: Evolution 3.52.3-0ubuntu1 
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: A568E40002
X-Stat-Signature: 37r31zo9tbum8rrg3f816mpzaogr3p4g
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753784925-362983
X-HE-Meta: U2FsdGVkX1+irxrwP2NMJfurSDtDpypQbrl4UVmgDzNz+LEXiQRPAIAFRcIX5DCNt1EIWpuqXcj1Hq7q4kfvwOew98/zc9IiWQbSOOKp6iD4qeRRkklXFA67P9+wQBCg8Ikk+bthomY73F74L5nSjymW9KxTqQ1ZPngjAGSHCWsWMxXWaay33mqmRGifPtdmxd10eS/84/sBHqPL+xuR1cS4S89GsVSgznkGP08GD4juELLcMeTqhhKcAsRCN9Ncql3NvKNNUbZ/mZQAur2n3CIEG2upwo8RmSM0ly1/1uibAFFOuxQxTWH4S74sUMA0acqXu5VDJtVIt1rgsp57CvYzhA+qE3u0Fgh0G30Czbe0iU0j9vMRsZP6KXZIR24QdMl6BoGN++yzt8/R8bAekGXBeFvijBBncngnfvlxoY1EP3KQFsPRuqEY+ueIQlfsQreUyM5mrpBvdPU6mvZ8nhNG308tKpPDVeJ4fAmZ5tYyDmV01pqJpf+VKPLNG4TSPU2EUWLVJWSV1MVaLN24xcuVKi4kr6AicQD48hSum0AGxWDCki1e8rNnHfuEmhEDvKqsaTkpm4bJEThVqTzFxAy+DzagAjkXT3z8DM+QUxZI8Ey9U4B8DkdC2jy2PFe5uVubM21hXub5jnaX0hp3NdC7hNaAKJ3+rtX2s4TKt4nBNKGOG2Sx3NZw2DqOCudkFcuEvy8AwlOqXvoz3oI83XvM+AjC9qzbYPUacyEYQd4+9WC5zRalKfiDFasa3jr4cHv8ouGYcAbAsqwMUbUegFXSL+cMKjOxE443KxHDbyAauMaYDKegv4aIXYOwmujG2ydvKtKC9DNCfnEPeCebdBOj70QbkiwNXl+gkbyaiux6x9WmKWsC3JjjaQkc69ZrPijGdrRe6UaeYwpp4tTxS/7eodlJ5WyxvE6S/aU+zeF7KEbc4VjBCjxa2TzjT2cpp6b1ph7dJTU4NmdpmtR
 9jDX0Jji
 7wUtTIbv8Pna2DsjT230YcfWRWZnzuLtAKp9qoVHBNwl7QD3/5uEC7v5BKa3lEKFD7377AXacIQq0l22xF/x27s/G1sHmrUNj4w6jLp2GsPQV8DiffPEvHqtHbWQTepeH/OUS7Nf+Ff+xFq6vrVD1fPygu8FzbV4NahU1k74rB6U+WBZ8NcM6i1sR4OVt3ELhd8VfvBqjgj9Yg0rwoDTeYxo8HUUs59VkPHCpzTu9+EAO7AmDWsjxUEbIUZXE9ccNXKImTJ7LxqE36T6yG9s8v+BT7K9bJNiJWZLns/6l9ry5OYmvgZ1zC5PruzS1yB5Ym44NZiMiay2FQlS0OnFvK0QUAEqphYVhTS/2yoZZ/wj8g4j9rqzU14CqPEMj5+1ICWV8xhIJg3MMjFx2iW5baewxcys0Ok5kEidnh/qSUo3ap6Ox5PeNiJzWDPFX/5Hlt4yLFcbOyfhy3HfeH2yebLkZC31/UlIY9GP+5PkmC5AUaRF8/popy+xzeK3ErZyh2XJGih46G/qdKWwve9PYmU/oA7f4LPCISCPM1TOKfs0v+LlW03gU7eFqhWOdlxa2pTRB36g+A7zmDxx5ih844/djiEdFKq3LnnMWGn81v7a/u3SA/4G2rFw3cqPXApfnC6V+7XdyvHB7XYvkjarEp9CYDql5ZzTJu91QeFZTjQfoYyRL37QjdzwuxjYNBgOqgd1uxDuvco/11VbEuoJFp8xu0nZktWGlv1leSn6xL3E+ATr9LRlTsOOeZ63CAxpkP3uzaCq3i6yDfWU05zPDX6mYRs21IOFNsKo8Ae0I/75PYTd1Om1mAhxeyH8TkB9r+Hbs
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--=-63LQhDGVG/7VLT4oj6Vn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2024-08-20 at 11:11 +0100, David Woodhouse wrote:
> On Fri, 2024-08-16 at 17:22 -0700, Sean Christopherson wrote:
> > On Fri, Aug 02, 2024, David Woodhouse wrote:
> > > On Fri, 2024-08-02 at 11:44 +0000, Carsten Stollmaier wrote:
> > > > On vcpu_run, before entering the guest, the update of the steal tim=
e
> > > > information causes a page-fault if the page is not present. In our
> > > > scenario, this gets handled by do_user_addr_fault and successively
> > > > handle_userfault since we have the region registered to that.
> > > >=20
> > > > handle_userfault uses TASK_INTERRUPTIBLE, so it is interruptible by
> > > > signals. do_user_addr_fault then busy-retries it if the pending sig=
nal
> > > > is non-fatal. This leads to contention of the mmap_lock.
> > >=20
> > > The busy-loop causes so much contention on mmap_lock that post-copy
> > > live migration fails to make progress, and is leading to failures. Ye=
s?
> > >=20
> > > > This patch replaces the use of gfn_to_hva_cache with gfn_to_pfn_cac=
he,
> > > > as gfn_to_pfn_cache ensures page presence for the memory access,
> > > > preventing the contention of the mmap_lock.
> > > >=20
> > > > Signed-off-by: Carsten Stollmaier <stollmc@amazon.com>
> > >=20
> > > Reviewed-by: David Woodhouse <dwmw@amazon.co.uk>
> > >=20
> > > I think this makes sense on its own, as it addresses the specific cas=
e
> > > where KVM is *likely* to be touching a userfaulted (guest) page. And =
it
> > > allows us to ditch yet another explicit asm exception handler.
> >=20
> > At the cost of using a gpc, which has its own complexities.
> >=20
> > But I don't understand why steal_time is special.=C2=A0 If the issue is=
 essentially
> > with handle_userfault(), can't this happen on any KVM uaccess?
>=20
> Theoretically, yes. The steal time is only special in that it happens
> so *often*, every time the vCPU is scheduled in.
>=20
> We should *also* address the general case, perhaps making by
> interruptible user access functions as discussed. But this solves the
> immediate issue which is being observed, *and* lets us ditch the last
> explicit asm exception handling in kvm/x86.c which is why I think it's
> worth doing anyway, even if there's an upcoming fix for the general
> case.

Gentle reader, there was *not* an upcoming fix for the general case,
and this is still an issue in real-world use cases... or would be, if
we hadn't been using Carsten's patch ever since he came up with it.

I still quite like the idea of interruptible user access, but nobody
seemed that excited by it, and as noted I think we should move steal
time to a GPC *anyway*.


--=-63LQhDGVG/7VLT4oj6Vn
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
ggE3MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI1MDcyOTEwMjgx
OFowLwYJKoZIhvcNAQkEMSIEIKjVqsM9uadD0MYiLX4KvDYXXQVpugd5AOrhRDAUOYd3MGQGCSsG
AQQBgjcQBDFXMFUwQTELMAkGA1UEBhMCQVUxEDAOBgNVBAoTB1Zlcm9rZXkxIDAeBgNVBAMTF1Zl
cm9rZXkgU2VjdXJlIEVtYWlsIEcyAhAH5JEPagNRXYDiRPdlc1vgMGYGCyqGSIb3DQEJEAILMVeg
VTBBMQswCQYDVQQGEwJBVTEQMA4GA1UEChMHVmVyb2tleTEgMB4GA1UEAxMXVmVyb2tleSBTZWN1
cmUgRW1haWwgRzICEAfkkQ9qA1FdgOJE92VzW+AwDQYJKoZIhvcNAQEBBQAEggIALFPQDwMFBidX
ChiuxAIv4VUhKRzoeBslU5xImz+9CyABS5pzv4j7AOuy3O4N8AXOEdlGDgNNWXc/bk2kR1z2iysW
aCs/F5Tq8peoMCvCqYSKiizqjyZOl8nFZHJi/nt81+g2JcQaPye+bvsC6VsBxCXyv7snAEQf6/aK
1+uyQD5/hePlFHqRr8ljR3+TOh2GaroJuO39+pZ5See/M5a+pyJP/eo1xppwEBS1JtoyfPHY4Edz
51QYN0vmO4+GrvnUQ6KFNFzSC+cUzQr4qgS/7K5TOb8pei4ZYfmzd8ehFiGoZ4Rp6yRYDgWZTDl/
ihnPt1A27OmvIOoKEXqg4VHM9n4QFw9m58x64AvPbevJPdeZxIXYwdfHqQ2wSsB3irGfcn2UlzAt
PlUVE0T7n9plpzz/dlRaPTYeIsZsmfM+IcY2ObYkqjBG4jvdJWlWnnBgN2dqF7qmE3Q+tOcL0NHF
ca3PzKLyZWMPW5RqaqfIsdyHx/DduSm68FiSc5YdmrtQVF7VLydDAi6H4CJWdM5ZCpm4JiAY6x7g
RTtnyAsAmqjEYmw/QHeqqls8U7JATx4ll9eRwm1xbghOtBRs1Xo/FSqvBVMhHxllLG74ogrJdIXr
UEgI6TQEAZ475iJ2d1Ab+bgVR6FnEOL7YvuhQf07yl9g8p2DM5inNW5AeDDQ77cAAAAAAAA=


--=-63LQhDGVG/7VLT4oj6Vn--

