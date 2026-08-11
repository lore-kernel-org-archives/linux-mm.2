Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35411C5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 15:15:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D79B6B0093; Tue, 11 Aug 2026 11:15:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AF106B0095; Tue, 11 Aug 2026 11:15:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EC0F6B0096; Tue, 11 Aug 2026 11:15:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E920A6B0093
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 11:15:50 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7F7994047F
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 15:15:50 +0000 (UTC)
X-FDA: 85089338460.07.4225C42
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf19.hostedemail.com (Postfix) with ESMTP id C84F01A0011
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 15:15:47 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=H947BBtV;
	spf=none (imf19.hostedemail.com: domain of BATV+b6a5eba76e218a018a6a+8388+infradead.org+dwmw2@casper.srs.infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=BATV+b6a5eba76e218a018a6a+8388+infradead.org+dwmw2@casper.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786461348;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C4RWnSF6pJocX9NMcFqt2uafs65fwJq5zPBTs39HC3s=;
	b=6Db0jDharTRnMO31VBnZJOITSOmHirpJJukoJoAls20ZTCS5m6f9PAU5SvlcYSsDnGn0z1
	QXvpy//ur9Jd2YCdSDPb0jeMdyKlmsPAvFZsrHTb8EiRCbrUkh8auTxWVBxjgqOuWAv/kJ
	ZBimJOqRCjTM83hHkj8LxlcL3GRzH6o=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=H947BBtV;
	spf=none (imf19.hostedemail.com: domain of BATV+b6a5eba76e218a018a6a+8388+infradead.org+dwmw2@casper.srs.infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=BATV+b6a5eba76e218a018a6a+8388+infradead.org+dwmw2@casper.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786461348;
	b=VE4ugex4Gl0m3jdC3MAJJMXZF0+GwlcOr/EzuoFc8hiEtAwBjjzdEkRxL745cS2rw5Jvlg
	Biw2dC/xZfKzCi1sOhgcJwxKytPJwY0pcgIER4gaUb4dPzC0Tdf5mvaQIsghwUbypfjOG+
	X1yBpnAqmQvicCBECwM1jG1Ogl+sIAg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=C4RWnSF6pJocX9NMcFqt2uafs65fwJq5zPBTs39HC3s=; b=H947BBtVIb356xo9emf3WFAVJl
	ngDIFHjIM7+hYs+yDpUteCH4o+J9gpAGQ06trB4FA+Y5jjnlWCz1AgHHj35Exo3O4+slHIIh2IrJv
	T6eD5/iJ0A15Pie9CQb5wD4kvLfcGkxfPomlAuUD3qD9j7HXnSAzdkEixnuzjdDGt876T5Ojc4qzv
	4DQuwOMWUXe70vyzgac3u7Qz45nTL696hHoHwfTuHN8YusGWiYlPVYiFGelXW7nzXvrcrMyTFxe+w
	Azmlf0rLQHD9m47kzyfn2UXx3f6aD7Abm5YqfJxg4+8xPvklPk3Oykog3yn0cyWiULWuoKWgKXRuG
	kCtmRRzg==;
Received: from 54-240-197-227.amazon.com ([54.240.197.227] helo=u09cd745991455d.ant.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wtoCc-00000000bZt-0DXt;
	Tue, 11 Aug 2026 15:15:42 +0000
Message-ID: <15a7bd252a9aaeefe393f5609ec383ce2c61694a.camel@infradead.org>
Subject: Re: [PATCH] mm/mmu_notifier: Remove non_block_start/end() from
 notifier invocation
From: David Woodhouse <dwmw2@infradead.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand	
 <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"	
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport	
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko	
 <mhocko@suse.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark
 Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 Simona Vetter	 <simona.vetter@ffwll.ch>, =?ISO-8859-1?Q?J=E9r=F4me?= Glisse
	 <jglisse@redhat.com>, Christian =?ISO-8859-1?Q?K=F6nig?=	
 <christian.koenig@amd.com>, "Paul E. McKenney" <paulmck@kernel.org>, Sean
 Christopherson <seanjc@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 linux-mm@kvack.org, kvm@vger.kernel.org, 	linux-rt-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org
Date: Tue, 11 Aug 2026 16:15:36 +0100
In-Reply-To: <20260811142730.GG544626@ziepe.ca>
References: <a247c49dd61af1df7ddc4dcb1cccbcb36b04d9d5.camel@infradead.org>
	 <20260811135537.GC544626@ziepe.ca>
	 <1d669aca4ffee797b9c29215382444a5b23624b3.camel@infradead.org>
	 <20260811142730.GG544626@ziepe.ca>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-WFxnxPwVJgC0hcJstHel"
User-Agent: Evolution 3.60.3-0ubuntu1~ppa9~24.04 
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: xujdw4qwbw3ioq6s4eckxuggtr797nus
X-Rspamd-Queue-Id: C84F01A0011
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1786461347-752104
X-HE-Meta: U2FsdGVkX1/f+Xm2DQFpQRYSKYLoWoxeiQT1HKMXgfLOW/NWQ73TTsuOspLmrWnD1pWM91gYyL9fGTLjFrKgdW7ikyWXQ0FcfbZ8FvL/RfxrC3Ip8WvNNmEDn9GZTWKHmMXD0PcWmFsQ5PpRyI5s7g8C4hYj3th3JOtyGmrTQ8e91NDzZLFcD1ZmCjQ0XYttcDxI4O4pe/umBfusUnA3tzWozyFlNkdlYgZs7yfdLbzpZD+sC7tyRGLDoQ+F+pv2qZvHeYn9SsY+M9pMgVc3Z4WiQnVCaVMCFrh5gZlfSOnjpFA2mzvqwMJdC3gDPiHPLC5UPANg0QOapUO5Lp81vRfkEWP5brXFp2jsvjGnPdScBY+9mRhbBAUQj4kw8LZ51RyUUIuki+Lya8iQBLcwTW/waRS4pjOP2C/gpUOeEoGkpmXnP02gDY6VSUTjBZzDPGNQn8y5iifEPhHlall7JLbt4MwCmC7bXCYJ2rxut98KVAjU4JBW6rNTbZj+6wpEjSdQPqrgH8kOqPA5yY/3HuJtdcDslxjPjyFMgq44nIC2YeAAty0BBdwHVlmZtYfaTu7zIbO3D/FEMnIgdRjr/pS4ctY1kjlTLpeAo91xiPrUQJXgFYd1ONl2dAquK3jHAQDq0bAIZ5MzDfLu9irSwaudza/11RiwMNcrKcA2kBdFaGxg4+bxl+kjDIhz6Sksn6rhhpN1aYU8B8aovql0arpnClgLThZ4xfk+3nzyywjLpw201PjtF8eH/HxSm5fxnGfkcBwat8StI1eKcq6IqhQzhGiKfCIe4QhMLGOBNNS7bsP6mgeXfcvIasLQShX67y0Bv6vLeiF8K30c5tcSyVaGOq6cE3h/awbHj4ipmtMos6OsTj3rWvC+xlF3sZ81t/f9JKCIL++yW16BiWlRkRJ1jYrRyyFAS21NxfD2BE9lr1KVaU4DLmrEYpucb7iCvX4TWGkYx3CIWY+7/vL
 uuRUHfs7
 D4DE9HzPV1HQTn3CMgOQ4fE6iVHidkiyeFCf0MHsCVMNydeIpRQTs9KHZXXnLPXtOS3anrskQoEJjuXAkEUQzqv11RvHAI2QIDMC6Tpneluj8OI2/PQiG6emicLWWP50Qqf/NWs5lZ7M2ix2DQixUYq60C4WBOIwFZMxoCTkbMAMP2+L62s58b0QjcY3Px3O6mJZupHvh8P0vClFulPr+B2GaFTSyEPE1ErsfMqdZ0FjpY78GbeoZgfl4BdZbZn26WUwdnjDjjd60Gpnxwyv9NkPFzNxho/gH2s05E9JzJaeSr57EY5+5t756Qx6qidjX3UcoUED2dqipNQuEpI/UahWftA5uKPHsHH42trDG3XLd7PqJy1QTk26TkLJaRP6vNXrSKbj4XUtRuxbYyBSxVz9kpHcp8Hp8IUGoq9G3MBulrwAVoTmIK1fvKvJakkft0KJhk3p4gocJfJQp7k36k756piXxcN0/WLd4ApIugoPqkASsWYSeKSu5qx90I+pxVaPt3Vn7NxAfB9qSnTBsraA29vdDzqIf91zHWl45/FNpLNpcfJyJ9qFvGQ/Va/6KIIiDpQeg9htaaCtNkb8EqI1USZw0+jl3/lDDSHrSAFmkm/VNKzFgzd4I5IMtyvr4rWNsup0De62MQfDKQh09Qf/WLFr4M5wrE4LVVAtqpzuCSMSuoa0p3TK3ynnvidCo1rwRr/j1h8vVbTrDWb73tR6qxoGUZXoVSiRgWjBQAkHsUN99NM+evkaZ4s9pCr2WfTISDRdPrRtUyD2syyYuUUvRvCmA7A2AECpYG3jRxZjsOhskK7ViZajY4TLvUSu2qg8rUfRXPqhxWlJOZ5RvxBFuKQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--=-WFxnxPwVJgC0hcJstHel
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2026-08-11 at 11:27 -0300, Jason Gunthorpe wrote:
>=20
> The unstated secondary purprose of the atomic context is to force the
> driver implementors to make sane choices that don't degrade the MM
> spectacularly.

You realise it only does this is in the OOM handler context when the
normal death of the process takes too long, and I literally had to hack
the kernel to even get the splat to trigger in the first place, right?

I don't think it's keeping your driver authors honest... :)

--=-WFxnxPwVJgC0hcJstHel
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCCE8Ew
ggWvMIIEl6ADAgECAhANkOKMSmGXhF5eMl0rsRhvMA0GCSqGSIb3DQEBDAUAMGUxCzAJBgNVBAYT
AlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xJDAi
BgNVBAMTG0RpZ2lDZXJ0IEFzc3VyZWQgSUQgUm9vdCBHMjAeFw0yNDAzMTMwMDAwMDBaFw0zNDAz
MTIyMzU5NTlaMGIxCzAJBgNVBAYTAlVTMRcwFQYDVQQKEw5EaWdpQ2VydCwgSW5jLjE6MDgGA1UE
AxMxRGlnaUNlcnQgQXNzdXJlZCBHMiBTTUlNRSBSU0E0MDk2IFNIQTM4NCAyMDI0IENBMTCCAiIw
DQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAOfSIeC0vv1xPQ+dgSxbIIrkaru6skAWJYaGFzmv
q4Kq+2wU2jxhcWlJg/JeP5jEkq/LM3pn5aaLao79j+XRmS7J1ZpJKUODJVoM4s9MQJhTMvo4qS5Z
S64g6QR7Obkz3I1Lr3aWeSBmDDEyzue+NKtuWZ1Cxy3RdXo/w5HgRc3l2AercOM3Gt1XonTzEtTb
Z/Hwc0Sn9Gz8RmGRK6Ka4hVDl8q/2l110KaV233Kh5etP0csXS8MIMdVRfRu3sc5hp13DG7lCKzK
72a2GEpI8Wpl26G6I1/LMzz/98T+FqjTqxsdquk7Cj7m2vKGLW1BorpQH7WFGPdJQXJe1hfbfiZA
CcVdCtl4nAacFacmsiArZBfX7AQGL7isvHUwwYFEtcApyGW4p2Lt+t8nvU0CANA6BHOpOz1xOP8W
mAESbUriIjyuTUf3fJ9oDNCurVqhASMJCDaWI3lYX/QAoiAzt6akqbbZxo2ujW7mGGqc0KxqE2cs
h2T79v7pC8aUtHBfwNrTR19GnZVxE0eQ7ViIQhR6mpSaUQFA9sG+cmD2G8TnCgYsLa0q8De6F61a
CBevQGHNzrbZ3JAMneveYg/Jy1XxQHDRcvrMfWKe0jjcWbdKYlaGVPm5V1ILwYz7Yv5ewo3NUrxI
GJiywe9qPhuJSDZs7VehTuI0FxGIsgKzVjgbAgMBAAGjggFcMIIBWDASBgNVHRMBAf8ECDAGAQH/
AgEAMB0GA1UdDgQWBBT3m6JO05fF9DQPQw6Bhc6RkzKv+TAfBgNVHSMEGDAWgBTOw0q5mVXyuNtg
v6l+vVa1lzan1jAOBgNVHQ8BAf8EBAMCAYYwHQYDVR0lBBYwFAYIKwYBBQUHAwQGCCsGAQUFBwMC
MHkGCCsGAQUFBwEBBG0wazAkBggrBgEFBQcwAYYYaHR0cDovL29jc3AuZGlnaWNlcnQuY29tMEMG
CCsGAQUFBzAChjdodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20vRGlnaUNlcnRBc3N1cmVkSURS
b290RzIuY3J0MEUGA1UdHwQ+MDwwOqA4oDaGNGh0dHA6Ly9jcmwzLmRpZ2ljZXJ0LmNvbS9EaWdp
Q2VydEFzc3VyZWRJRFJvb3RHMi5jcmwwEQYDVR0gBAowCDAGBgRVHSAAMA0GCSqGSIb3DQEBDAUA
A4IBAQA+b8Uw53sDspdZgukU+qzLyyHkcjlxGGhHlP+zrmDLKm1wEFvCRS2pili3Hy67i8N4N5NU
vw5Rg6kv3lxb9S9Rktxk43k+tvm68pl7OxQE55ZjVY87P0lUPGwEqOOwLLyH02ZQcsfq5p5LrOH9
0JvmvZ1yy73HS+VpDAqOlytE0NSvTIRqFFkKQGQwfjvtql9YflujuNNvJztjBaHKYZsnNSg+J38o
jYq4TP3pSg3UdVH0PncVjPQyqxC9xef5Xae92Kbkzol3x7Nel3A1bwAkalrDMspvTHvey6LfiBks
FIqviTnoy7fgjaRAJgHS+RXx/cmuRd3rUAclSVVrYu8RMIIHAzCCBOugAwIBAgIQAzUotrsybJHx
HTjKOIVdIDANBgkqhkiG9w0BAQsFADBiMQswCQYDVQQGEwJVUzEXMBUGA1UEChMORGlnaUNlcnQs
IEluYy4xOjA4BgNVBAMTMURpZ2lDZXJ0IEFzc3VyZWQgRzIgU01JTUUgUlNBNDA5NiBTSEEzODQg
MjAyNCBDQTEwHhcNMjYwNzE4MDAwMDAwWhcNMjgwMTA0MjM1OTU5WjAeMRwwGgYDVQQDDBNkd213
MkBpbmZyYWRlYWQub3JnMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEA2pYux73kdbYX
sWF8f1u6DJP91qcqaZetsyfPkZk0B+MmXmAEv0kVes5n15V2mbDThOnpoPFly0UugQO9JYqLfrtD
tKD5yL58fgrDB9Dw+LQikgrHafl6YSCds5AvUu/8hw2J6noKrcOLJpKlKn9Fl/4IB9Q3JIdLx5aa
EtTqMalIPqHFOlgrJ7s+aua8xbB8YQ9ahqYBXWRJNv3P/2b1DYtdrz1oqZPE3CcB8Pc6Gf2a1Tcm
6TAgtEx7Cf1BFcrsrMz7TWHmGQITieNb2r9UYWSc2Gp+GtYFNJCgT0JJXKUBIauPMKBLteYrL8Fo
ff/uY44dC/mDWjdCP/5x0qelPQjlBvWdHL5zvBTOj06rJ0m3HNI/hnIcDh0Qu2j9reb9rLVcdym6
bWmBM4uDEB8Zv9Ph0KTBFSy1IosyakuD1j1Os30EzjGfbi0EUXIvnOcYbTBAbM5UAzrxEHMhBvoX
Pvnx+OyvjJmc9tWxTX6AcSz+m40esbT17URBeZS18afgieiikm5TynlUYP1LciR3hSgGVzvGXnKO
02VDFR5itGWdRKZ2W5wIShNfWfhSa0D0K5UdIDt5Qc7sjzwK1Yb1sY5Tu0uA5mhIS82q1ov83uxB
sFkriNnhGv/M1NCDVLBiOMsHu73qUM+yKmgKLwF9Hfn9WI25glbAMI4S5r3hYzcCAwEAAaOCAfcw
ggHzMB8GA1UdIwQYMBaAFPebok7Tl8X0NA9DDoGFzpGTMq/5MB0GA1UdDgQWBBRcYhqbcGzn1jrT
JOZaB8O7qllDpzAwBgNVHREEKTAngRNkd213MkBpbmZyYWRlYWQub3JngRBkYXZpZEB3b29kaG91
LnNlMBQGA1UdIAQNMAswCQYHZ4EMAQUBAjAOBgNVHQ8BAf8EBAMCBeAwHQYDVR0lBBYwFAYIKwYB
BQUHAwIGCCsGAQUFBwMEMIGpBgNVHR8EgaEwgZ4wTaBLoEmGR2h0dHA6Ly9jcmwzLmRpZ2ljZXJ0
LmNvbS9EaWdpQ2VydEFzc3VyZWRHMlNNSU1FUlNBNDA5NlNIQTM4NDIwMjRDQTEuY3JsME2gS6BJ
hkdodHRwOi8vY3JsNC5kaWdpY2VydC5jb20vRGlnaUNlcnRBc3N1cmVkRzJTTUlNRVJTQTQwOTZT
SEEzODQyMDI0Q0ExLmNybDCBjQYIKwYBBQUHAQEEgYAwfjAkBggrBgEFBQcwAYYYaHR0cDovL29j
c3AuZGlnaWNlcnQuY29tMFYGCCsGAQUFBzAChkpodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20v
RGlnaUNlcnRBc3N1cmVkRzJTTUlNRVJTQTQwOTZTSEEzODQyMDI0Q0ExLmNydDANBgkqhkiG9w0B
AQsFAAOCAgEAocabrh1cPd5s3vY5rnlBVQSTc7zs2ZWs67dAIltR+05WELrYClVzzUhMs/LOJPlr
EUo45UDDomXq38DxFepaPd9+iNLjXfn33EX/IG44j04lU/oF/Rg9VeQILkYLbCZ/x9wOjNHZc4SN
ydY7Dhvf/sT5aBz88u7D5+azZJ7Qf1U57wYseCH1Mt0nDrtr5y19IJ8D9xJJ33RFL6vfpHZBBAQ8
+3RqkKNxLoV2aFvQhxdhjNLDqTv3LjUIdicwPraN7JkxEu7CV2Lka7eRqJgkWL7SK0YmBjGpRafs
+icP/ON5RCCKTTb6VlX8eTG2sJJfsFhvJNCCt6xexbWzWtIrfP7NvPBvwBB737AyEGBZkS5aNizT
McURJGTv9UKvBh1LF/+tNhYtLvPCN7oecGzhCHht9jcwSkygTo3Y6YlK3QgOu+ncmiBbfeuwlLZ1
LxbYvG6hgNqXv7u6YyADbYajAQJXJ2OQen39pm3Q/AQSyLYG+B8lDglWsM8tYXPlEdrYJcksGK6F
nqIX6Bumn43rBooLJdiZp4WmfWdL2pxe+LxRDjprmqu1WprixDxULSTOKJZoqTlugs6y3Bc+if+s
gHnBBtz9WQ6MtPHkh7zONDAFIKcBmv8OqPQCx0F3Wv3OEybwMpXx0OsKgK8wLldaX1pXcMuyDgTL
Sqs0AV0OHUgwggcDMIIE66ADAgECAhADNSi2uzJskfEdOMo4hV0gMA0GCSqGSIb3DQEBCwUAMGIx
CzAJBgNVBAYTAlVTMRcwFQYDVQQKEw5EaWdpQ2VydCwgSW5jLjE6MDgGA1UEAxMxRGlnaUNlcnQg
QXNzdXJlZCBHMiBTTUlNRSBSU0E0MDk2IFNIQTM4NCAyMDI0IENBMTAeFw0yNjA3MTgwMDAwMDBa
Fw0yODAxMDQyMzU5NTlaMB4xHDAaBgNVBAMME2R3bXcyQGluZnJhZGVhZC5vcmcwggIiMA0GCSqG
SIb3DQEBAQUAA4ICDwAwggIKAoICAQDali7HveR1thexYXx/W7oMk/3Wpyppl62zJ8+RmTQH4yZe
YAS/SRV6zmfXlXaZsNOE6emg8WXLRS6BA70liot+u0O0oPnIvnx+CsMH0PD4tCKSCsdp+XphIJ2z
kC9S7/yHDYnqegqtw4smkqUqf0WX/ggH1Dckh0vHlpoS1OoxqUg+ocU6WCsnuz5q5rzFsHxhD1qG
pgFdZEk2/c//ZvUNi12vPWipk8TcJwHw9zoZ/ZrVNybpMCC0THsJ/UEVyuyszPtNYeYZAhOJ41va
v1RhZJzYan4a1gU0kKBPQklcpQEhq48woEu15isvwWh9/+5jjh0L+YNaN0I//nHSp6U9COUG9Z0c
vnO8FM6PTqsnSbcc0j+GchwOHRC7aP2t5v2stVx3KbptaYEzi4MQHxm/0+HQpMEVLLUiizJqS4PW
PU6zfQTOMZ9uLQRRci+c5xhtMEBszlQDOvEQcyEG+hc++fH47K+MmZz21bFNfoBxLP6bjR6xtPXt
REF5lLXxp+CJ6KKSblPKeVRg/UtyJHeFKAZXO8Zeco7TZUMVHmK0ZZ1EpnZbnAhKE19Z+FJrQPQr
lR0gO3lBzuyPPArVhvWxjlO7S4DmaEhLzarWi/ze7EGwWSuI2eEa/8zU0INUsGI4ywe7vepQz7Iq
aAovAX0d+f1YjbmCVsAwjhLmveFjNwIDAQABo4IB9zCCAfMwHwYDVR0jBBgwFoAU95uiTtOXxfQ0
D0MOgYXOkZMyr/kwHQYDVR0OBBYEFFxiGptwbOfWOtMk5loHw7uqWUOnMDAGA1UdEQQpMCeBE2R3
bXcyQGluZnJhZGVhZC5vcmeBEGRhdmlkQHdvb2Rob3Uuc2UwFAYDVR0gBA0wCzAJBgdngQwBBQEC
MA4GA1UdDwEB/wQEAwIF4DAdBgNVHSUEFjAUBggrBgEFBQcDAgYIKwYBBQUHAwQwgakGA1UdHwSB
oTCBnjBNoEugSYZHaHR0cDovL2NybDMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0QXNzdXJlZEcyU01J
TUVSU0E0MDk2U0hBMzg0MjAyNENBMS5jcmwwTaBLoEmGR2h0dHA6Ly9jcmw0LmRpZ2ljZXJ0LmNv
bS9EaWdpQ2VydEFzc3VyZWRHMlNNSU1FUlNBNDA5NlNIQTM4NDIwMjRDQTEuY3JsMIGNBggrBgEF
BQcBAQSBgDB+MCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5kaWdpY2VydC5jb20wVgYIKwYBBQUH
MAKGSmh0dHA6Ly9jYWNlcnRzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydEFzc3VyZWRHMlNNSU1FUlNB
NDA5NlNIQTM4NDIwMjRDQTEuY3J0MA0GCSqGSIb3DQEBCwUAA4ICAQChxpuuHVw93mze9jmueUFV
BJNzvOzZlazrt0AiW1H7TlYQutgKVXPNSEyz8s4k+WsRSjjlQMOiZerfwPEV6lo9336I0uNd+ffc
Rf8gbjiPTiVT+gX9GD1V5AguRgtsJn/H3A6M0dlzhI3J1jsOG9/+xPloHPzy7sPn5rNkntB/VTnv
Bix4IfUy3ScOu2vnLX0gnwP3EknfdEUvq9+kdkEEBDz7dGqQo3EuhXZoW9CHF2GM0sOpO/cuNQh2
JzA+to3smTES7sJXYuRrt5GomCRYvtIrRiYGMalFp+z6Jw/843lEIIpNNvpWVfx5Mbawkl+wWG8k
0IK3rF7FtbNa0it8/s288G/AEHvfsDIQYFmRLlo2LNMxxREkZO/1Qq8GHUsX/602Fi0u88I3uh5w
bOEIeG32NzBKTKBOjdjpiUrdCA676dyaIFt967CUtnUvFti8bqGA2pe/u7pjIANthqMBAlcnY5B6
ff2mbdD8BBLItgb4HyUOCVawzy1hc+UR2tglySwYroWeohfoG6afjesGigsl2JmnhaZ9Z0vanF74
vFEOOmuaq7VamuLEPFQtJM4olmipOW6CzrLcFz6J/6yAecEG3P1ZDoy08eSHvM40MAUgpwGa/w6o
9ALHQXda/c4TJvAylfHQ6wqArzAuV1pfWldwy7IOBMtKqzQBXQ4dSDGCBCAwggQcAgEBMHYwYjEL
MAkGA1UEBhMCVVMxFzAVBgNVBAoTDkRpZ2lDZXJ0LCBJbmMuMTowOAYDVQQDEzFEaWdpQ2VydCBB
c3N1cmVkIEcyIFNNSU1FIFJTQTQwOTYgU0hBMzg0IDIwMjQgQ0ExAhADNSi2uzJskfEdOMo4hV0g
MA0GCWCGSAFlAwQCAQUAoIIBezAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJ
BTEPFw0yNjA4MTExNTE1MzZaMC8GCSqGSIb3DQEJBDEiBCCGC0WJRXY7PYEAlnEH0yVhLWn+fEn6
X/b+GftjuotHkTCBhQYJKwYBBAGCNxAEMXgwdjBiMQswCQYDVQQGEwJVUzEXMBUGA1UEChMORGln
aUNlcnQsIEluYy4xOjA4BgNVBAMTMURpZ2lDZXJ0IEFzc3VyZWQgRzIgU01JTUUgUlNBNDA5NiBT
SEEzODQgMjAyNCBDQTECEAM1KLa7MmyR8R04yjiFXSAwgYcGCyqGSIb3DQEJEAILMXigdjBiMQsw
CQYDVQQGEwJVUzEXMBUGA1UEChMORGlnaUNlcnQsIEluYy4xOjA4BgNVBAMTMURpZ2lDZXJ0IEFz
c3VyZWQgRzIgU01JTUUgUlNBNDA5NiBTSEEzODQgMjAyNCBDQTECEAM1KLa7MmyR8R04yjiFXSAw
DQYJKoZIhvcNAQEBBQAEggIApuv0Ydd589jmG3v331qIovU30+UU72MT7PdR1Y1ecMGCp8oQSo0Z
Ru7LjcMRokmYRJACIzrDIrnL/wjUwqMXx0tLvZe/lnMCXTYLA0FjQQqdHccm1SH9hSgte+qrPRLf
Bn3DyarJEavR5noDvAQZlZ5+3oQF2LlyxxqIntMnS4AJhmJbUFbWxRI6PxwiRtjf0PwVlilpGOFF
6aXLCnREbX8kjH/uhPUOLe5xWS+yhOVwN8pGYeQNXRATz78TjqA0yxvk3N1B+AfuqDPB8AG5N14r
z2cR1nX49Na/hRbb53pZjIPIIq5pv0nSW8u3bixMkVFGboEhQV/P9bYeI6bgCImLjBpBexIkMKzt
T0WTskwgNYiliN8FLqDfuX13sAscb0R3mc3Q2DeAve0OTjNOkmUG/smKbOg+6dlUmHtzv/u8PekH
9UTcYWINkqdak6pU+DusCJ8TCE3ZHMMkjsmBjwNrIPlpw7AsBA68cr9FvZdeN0ZWJAU4eij2xpiO
AbLV0Y2p+JZ5tYsSNmQfhOnfwBcXV4vb3MwtwYngX7HOE5WV1uI16SUM4T7mppX4EaF7JRlptkwS
bf0HlUouoUoMnXdSyRWDPlxxCGv1SxxSkkOe+GEv0nfupskclLDE5dSx4ufmV071bgH20xN8DxOw
XkTb/vmzqTdrJ6HZM3OQC48AAAAAAAA=


--=-WFxnxPwVJgC0hcJstHel--

