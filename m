Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66F24C5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 14:06:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B843D6B0171; Wed, 12 Aug 2026 10:06:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B33D96B0172; Wed, 12 Aug 2026 10:06:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FD166B0173; Wed, 12 Aug 2026 10:06:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5E58E6B0171
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 10:06:01 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 93FBC1402E6
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 14:06:00 +0000 (UTC)
X-FDA: 85092791280.24.C5761C5
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf05.hostedemail.com (Postfix) with ESMTP id F170410000B
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 14:05:57 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=UAlMGq9+;
	spf=none (imf05.hostedemail.com: domain of BATV+5bb66369c51ae59fd3c1+8389+infradead.org+dwmw2@casper.srs.infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=BATV+5bb66369c51ae59fd3c1+8389+infradead.org+dwmw2@casper.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786543558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PrWmZ3F0DB4ZYJo69A2lp/wzcpXzL0zw6ysSVX/2nJ4=;
	b=W5SZldeyHTX54Mz7g7Y6Q6ah1ipQYAarYLp506Af8dcDSYw016lZAdWvtL2Com5OMBciVZ
	Xk6FCd/HAoAU7Y8YUNFbxk7HDsrBywrLlDIpnzQ8OJg4wlFaax/w6tPTvXBw19acQ3yp+I
	8LGA6zLdMOsg4/0fDNwElEKOTBhHB2o=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=UAlMGq9+;
	spf=none (imf05.hostedemail.com: domain of BATV+5bb66369c51ae59fd3c1+8389+infradead.org+dwmw2@casper.srs.infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=BATV+5bb66369c51ae59fd3c1+8389+infradead.org+dwmw2@casper.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786543558;
	b=8iuSizEv1M4LEOP1EZidPEeHX4Q0NCrACBkOucjjjUukXPH4qFoTCmP6Mn5DS8KMoLUHCa
	MEpEd8vLRUl0t7X4uJmSIMrcIutmJsEydQsw6IzueTgIg8LmYu116jAfPZkOEZgCzqcIaQ
	6kDw9/2p95X0GHbr+fJqydVBzuzR7tU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=PrWmZ3F0DB4ZYJo69A2lp/wzcpXzL0zw6ysSVX/2nJ4=; b=UAlMGq9+lxcuhZ7gZqi7pzhN3A
	9e9sVLC5+JDQdok6Yw5yh4lTNXzvAMej8j1X60hXURIUuo20aZJG5PUTz2dUSAcbpTTFhtpTMNNO4
	7qo4bU6fCpH8nsGlyauSzxLgwd3ggkqZLMVMlMr9V3zqDfRCzDofV+ge938PaUfoDclmxzM/O1kpC
	xgyGWbGW9a50BJh4P97z3WfUqqrN+Tx5ARkPdqBL+x76D26YV7r5zL78p1mPgvO4T6leOZ+1J9u6e
	rZWg9k1yFLXOd8EIPuyGzRH1wL+AUZvBsSUrM5PahfClqpPRVhqdDbUJ4lcvdiKLgwAMEqWuj/C3r
	zchDACJw==;
Received: from [2001:8b0:10b:5:a3a3:d97e:a004:df29] (helo=u09cd745991455d.ant.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wu9aX-000000025Ap-3nbE;
	Wed, 12 Aug 2026 14:05:51 +0000
Message-ID: <a48e6e7063122b22a8083bb0792984a204f316e6.camel@infradead.org>
Subject: Re: [PATCH] mm/mmu_notifier: Remove non_block_start/end() from
 notifier invocation
From: David Woodhouse <dwmw2@infradead.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Michal Hocko <mhocko@suse.com>, Steven Rostedt <rostedt@goodmis.org>, 
 Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
 <david@kernel.org>, Lorenzo Stoakes	 <ljs@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka	 <vbabka@kernel.org>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan	 <surenb@google.com>, Sebastian
 Andrzej Siewior <bigeasy@linutronix.de>,  Clark Williams
 <clrkwllms@kernel.org>, Simona Vetter <simona.vetter@ffwll.ch>,
 =?ISO-8859-1?Q?J=E9r=F4me?= Glisse <jglisse@redhat.com>, Christian
 =?ISO-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,  "Paul E. McKenney"	
 <paulmck@kernel.org>, Sean Christopherson <seanjc@google.com>, Paolo
 Bonzini	 <pbonzini@redhat.com>, linux-mm@kvack.org, kvm@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Date: Wed, 12 Aug 2026 15:05:43 +0100
In-Reply-To: <20260812134934.GC662699@ziepe.ca>
References: <20260811135537.GC544626@ziepe.ca>
	 <1d669aca4ffee797b9c29215382444a5b23624b3.camel@infradead.org>
	 <20260811142730.GG544626@ziepe.ca>
	 <a552b227e18ddbb3fa1f2edf2d1cb30ee6ccff13.camel@infradead.org>
	 <20260811104229.72fdd928@gandalf.local.home>
	 <37b83b429b9f14ea6ad4ca1c13cc8e565ec09033.camel@infradead.org>
	 <anwraNIKJV8zwrNT@tiehlicka>
	 <44c51ace9b0dc44b795f6f48c91cda440eed910b.camel@infradead.org>
	 <20260812122759.GA662699@ziepe.ca>
	 <c41c52f02f033ea980d4b5f9b8239d5e9411a03c.camel@infradead.org>
	 <20260812134934.GC662699@ziepe.ca>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-R1QKfS3KSQTZPPbu6wkC"
User-Agent: Evolution 3.60.3-0ubuntu1~ppa9~24.04 
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: F170410000B
X-Stat-Signature: 84uto8774njd4yzaju3kbocbixy8bnh8
X-Rspam-User: 
X-HE-Tag: 1786543557-480393
X-HE-Meta: U2FsdGVkX1//Z5VmF9aDKUWiyj2YVHzU2OCtzMnRoJ4WiJJ0lWWgWV10inLWUyl3oqlW0ynyKxNto+Dov03lcrgJZXA1OoY4PVic6CGiTR5sqV137/au7GZKqRPU9CebjtO47tNgAmOV37IRLVOPJc602QcETAdEPiRzGBbeJgfTUhVk3ch7VVPZ+LsoYcI9ZU+icxhTHPtRdlaYZhE9oXVkIc4r0PUgssGQg4c4qgD3x4k0dYznEgNv+z3EX+4Dq5WUmdjME85FISqCGuhPhL+JKAr1xI7Zg/8wzkWTe2q9TzfDOnCL1wibvq4S3OOyPFZ3e0x6Baor9aXEvGunZV5kwAYEyTTwKsOPPi3lrdfR4xZ7sTieFglsPjt/3OTC/wEhLkmXaVC/Fh3aqnPjwFS4A3Ks2mLF+vtUUkIZnt6TfQqVaKuprWcRVMBs8dX6rvxLV4SmaRbQUkFNN0JKzE9SJhvuLGfqZ6jL7AF2vVEHw/Hz0qJ853T646Tv1GknlX3td30tavRiHTl/3k25cNxgaOhvOVYXjqedw17jH/hXH6MATLl3GLBAs4TjBiW/5HTbNjNkoF0UafmEPgzTeMEY6f1avZgB6NVH/J9AClaP+H7CRo+DxNHHn9IkS3UFbnnzHUifWqJvGwSbCHpn7SRRz5H+GgMJN1Hfk1+UJoxIx6RsRZB9i2L128V5uHbkt/UqYZs7mwPE6YK/Bl9BgPW+eGAOzFm4y7S0xlObsqfjFOpigTZtUdHPGB26frPmMyXWNPO5DDgfvkWYUITUaGTIkmTojOvSpd+z37GKktyMuFD+puwJJFKZB/8XX9vTjvJwRNIW6ig/xUqpEnMcLExZX+uhPDPXFKq/ZJgQ0e8CGI4B1sEslu/wCLa2GMygPITSx2XXuII09e8s0ah0l51SUKQg+EhGfy3WsZd8rdXLPldkr2WwuN3Nfdcpk8wIhx4ZAgP5G8GJaN1zAxl
 aogM/ab/
 EE1JiBLu+5+t5EssJdbZ5T13GUolmC5rM9RA6BK1R/pkp36ascmBcnJUMTJxcYWRgabwZuN2C6qVLkDVdwolgzi+gCK3XILapAe8zFMdFzGcDrB4hki4wn/oxcFW3qz0jIEVor2z3xdLVE4l+xDutjEWeJHn960nNazVbPTZFeCHSEmsDrL6htTqK5DL3JWricHci9gjaWRNRrrSVu6DBVikDwvNbalg0X0+o5K85azyCoMYC2e0aq6Ohdf32EZIgSzcNIWLapBBQCFCUnhBOpqhJRXVvdFmb1BWwJjnAT3H/5YoRxpNsUIgdWm/LFuJuMgtxI6xz2Kk/AMGntMEf3CszdGbJgeBFxQnbrRrHyyCBHucs8kywkHrr91O45fuzY+RGnnB/hFwqh/yZyARHFCmSl86W6FmHtL2l/qnHYpKIAuiC/fhMsKnndfikJedmJT882h59u9epluuQ727uVykFis4IcV2t2/J3OhftuIx7QTbX1BmDEJ9p/sX3/DtJTPvWg7MuNV9O4UpUY3vjYizjUXgYsy2xY0CAS7+E7V2Ef9qI0EcCISY0ryRZnL3YBjuz15k0fxXrkKKyIIxHRjrpXZpkRN202IqoGOZG5D2gA1C4kqfVdqACkGmdyj94+uxiGG9pgr8kArzP9nTu48LiU5vCUhH/4pQYU43snCz3ODAa6OC40THlZssxw8XfQi2SsQ9f6GKyXiP2FG+3SGB3Tt/zTzjXanQkzIxRnlBj5XTc1m9E/btOJZVF7l7w1mpHVT6eohMhRGT2vswqu9V/xQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--=-R1QKfS3KSQTZPPbu6wkC
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2026-08-12 at 10:49 -0300, Jason Gunthorpe wrote:
> On Wed, Aug 12, 2026 at 02:46:08PM +0100, David Woodhouse wrote:
> > I hear you. I'm less sceptical, given the use case, but I'll certainly
> > concede that the universe is known for inventing better idiots.
> >=20
> > I'm certainly not averse to having a wrapper so that the read sections
> > don't just srcu_read_lock() directly, but also get a sanity check
> > (non_block_start? local_irq_save? what would it actually be? does it
> > have to be different for the hardirq vs. process-context invocations?)
> > for free.
> >=20
> > Or instead of a GPC-specific wrapper, do we make it a first-class SRCU
> > citizen, SRCU_READ_FLAVOR_ATOMIC? If it disables preemption, we'd know
> > that lock+unlock must happen on the *same* CPU, which could potentially
> > simplify my new try_synchronize_srcu() and/or allow for a *spinning*
> > grace period if we really do want that (although I'm unconvinced; it's
> > *latency* we care about here, and punting to the WQ when we *already*
> > have to wait is fair enough).
>=20
> These all seem like good ideas, then you don't need to touch the
> notifiers..

I'll rephrase that for my own understanding:

*If* we go all the way to building a whole SRCU flavour for this *and*
implementing a spin-only variant of srcu_synchronize() which is
tailored to the atomic-reader use case, *then* we don't need to remove
the non_block_{start,end} guards around the MMU notifiers, which are
basically never being called anyway and don't actually seem to protect
against any real bugs.

Yes?

--=-R1QKfS3KSQTZPPbu6wkC
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
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
FmDnGyWe6KbyV8SrFBP3KNUAAAAAAAA=


--=-R1QKfS3KSQTZPPbu6wkC--

