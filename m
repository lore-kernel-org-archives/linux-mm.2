Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12AF5C5B572
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 15:30:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 145106B00B4; Tue, 11 Aug 2026 11:30:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11C3D6B00B6; Tue, 11 Aug 2026 11:30:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 058716B00B7; Tue, 11 Aug 2026 11:30:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C82C46B00B4
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 11:30:09 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5CC57A28AB
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 15:30:09 +0000 (UTC)
X-FDA: 85089374538.20.483DF51
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf19.hostedemail.com (Postfix) with ESMTP id 4E5641A000E
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 15:30:07 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=XDpIbEZX;
	spf=none (imf19.hostedemail.com: domain of BATV+b6a5eba76e218a018a6a+8388+infradead.org+dwmw2@casper.srs.infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=BATV+b6a5eba76e218a018a6a+8388+infradead.org+dwmw2@casper.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786462207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v69tMEbn6TdI7GMX8fSZCsYKuZ8qp/AyfgKeIBf15oI=;
	b=Pg2W4cnTALhh8ZrkTKwH4xzlDyBZAE2KB12KlKTr2nsof2K4yzmK6j/sdSMHoIYJBXD8ot
	UpwaeID7C4ox0fzNOmTasACmqAQIXD6Omweu3CwMO2IM4BHQEqdEBRAF1tjxKxo8QfIMhu
	UTpylW3svI2kXa9D4YbARD0kItwpc64=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786462207;
	b=NPaYjDFMTMwWjxOTJ63MpbU3/w6XVC5j+QsqlVNwX11fSv6T/K3nyPiDIMBPvvhzprZuf+
	AvBGu/EcAEjVjvApP44mwyyqShqoKf0FLQTxBTifMgyfHqlWOzgrL3jCN1iVJ3PZL/u7V9
	bRe0i5pk+mOp4Enff8HrWLoo+1JlP0E=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=XDpIbEZX;
	spf=none (imf19.hostedemail.com: domain of BATV+b6a5eba76e218a018a6a+8388+infradead.org+dwmw2@casper.srs.infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=BATV+b6a5eba76e218a018a6a+8388+infradead.org+dwmw2@casper.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=v69tMEbn6TdI7GMX8fSZCsYKuZ8qp/AyfgKeIBf15oI=; b=XDpIbEZXlKwMomRt5l7KQzz8Xk
	mFtnDP8j13hEBdDsy6VM7i7sqKbejePcbacAL/SUmhj+SVh2uo7hDwN7kRm71iiX78F0IrJMBptQD
	fxLc/6d+ImACCijz5DlkjrUdn9+hxpblYN7mwhm/sS9KI8Vgy+Y53HZ6r6Gap7JwVuQoFGqJvUSAz
	Kl4qGv5esG327nWucn8ekCbaEYuFEzHoCmjzv0mcGvYknQVTMMpmu0c/TrGWMIw0s7xtaJGA551pb
	5np3GrLjHPE7dzp8slLd9t/c8PauZ7OQJQ+fjuTSOHwLR5k5lKeR7p9xCzVd71i8uzwX6FGIKB3hA
	xGXP4r2A==;
Received: from 54-240-197-235.amazon.com ([54.240.197.235] helo=u09cd745991455d.ant.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wtoQS-00000000cUQ-3E6F;
	Tue, 11 Aug 2026 15:30:00 +0000
Message-ID: <eac6f58590798a0bd96573d0ab15e0700937ec1d.camel@infradead.org>
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
Date: Tue, 11 Aug 2026 16:29:55 +0100
In-Reply-To: <20260811152435.GH544626@ziepe.ca>
References: <a247c49dd61af1df7ddc4dcb1cccbcb36b04d9d5.camel@infradead.org>
	 <20260811135537.GC544626@ziepe.ca>
	 <1d669aca4ffee797b9c29215382444a5b23624b3.camel@infradead.org>
	 <20260811142730.GG544626@ziepe.ca>
	 <15a7bd252a9aaeefe393f5609ec383ce2c61694a.camel@infradead.org>
	 <20260811152435.GH544626@ziepe.ca>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-lLdZloGm3DorjZJ7MBLc"
User-Agent: Evolution 3.60.3-0ubuntu1~ppa9~24.04 
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4E5641A000E
X-Stat-Signature: grsd9ui677zto5nkw1segkujbp1njegn
X-Rspam-User: 
X-HE-Tag: 1786462207-319801
X-HE-Meta: U2FsdGVkX19CiXp3ZtDWC45XEp1V9WQeh92ymH2OB2JcSCCiGLirMDXonFFjixlFJrYcB4aIKxCA6qZzN5CxZsXDRiUf85zKHjRy/W3n3KakJveGUfxgL17J4uCj6BQHHqKzpEj5zHfZaEC0R4duXuJoHVBO80qnrWaU63jpad6OODgNR7ZUSJYf6wyxjFLLdZnRpiUbumKNN8Oii03twwdONsChk9wwKCrglWTQSGUBPaaK0xbjojaiz7OUys/b56EyFyfnrzuA3Lf7wVdq0LZsKlhlos3PwOB+x8PlqxHUGmy7PSWIrxOvU8SOk1ksX1mDrwcvYn1ue3tfgpetk5403mUWBeZB0Z17tplfZHpb7s/fMZvWEsXfiA1zohZ0leObyZ/6mzKGNGhFlRLZcnJOuN9OM3vL4sSfTxto+rvzTS+gHpO5F61+Xapb/hyGs4fN0M4+yVqCPpv7+F8m2quwB+XR5qB0OWphzUIfvV/9zGEsL+fB7lji8PxCPapS/6APEDwW1Fdfq7WgqEi2TW15wcn94zk50J65LD3nV1eWRE9l3uEWiwFF02X2ePui+5fxqtlcyAXsXDwHNQJ0vFxINM1XsIA5MhHiR1WNrtLbXx/+clBce2yr5o/xswPHSImdmT6BxGymZHPtJaQv1HVOzmXrDOXCS26eAZExchP32x/HnctJ3fJ9sV9qSOUdfMVv2lst/tYwwlb4toClRjfRH9plSWZOla1QtnW8/6t6G2yWOpCLzoIzhT116Zfw/Q2tLNp3qPWXyhb4V4ipz3e2oYC/+08BcMzShMmDm1GUNgLxZaOubikmH15bx6Ib8gdlLXzFI7y9Y5w5X7M3b/73c6xMkmTj8bc9o49CdO6LAHKk6nk6BC/WQbU3dYtSV20VqNvu/ei4KU5t40IMjv3kA52UiCjcjj/swBNSfBikxL1wVWwqItk3QLA6hhDXNU/ZUltOUkjYqYbF8Fe
 xl7q6I2j
 NpUVE7j8F/2CiiwAqG3/KFGwvFspyoY9GhVS05NM0tuea8HaxeaWm00PIVHhtstSPXwXFLvqK3Xm1bSePlif2MVAjjWDHhtT7m7e1RGGZu5q1jCPkewvuje9hBZhBI58xMNlX8EkOuCqQA+S71t3sR5SXMWT/U2lFThtfCveSrSKqU8TqN8fhGa0w8V3RpS1DHIEt88o8NGdvipON+v024px8iVQdDo+YhpyZWc+YfxOFLg3KaVjNlpgWwEO5n9uVHySKpgBZbniALCQezUfn+UFc8fRtpWuV9f9RFvCTAOk7MX2rCd3eygahkq6HhEcCXyd0QxlWzK+7lEzz1zMq6jyyadIW6YZLHh8bTtp0sk0OayHAkCJFdxN8xEkhFgwVAOfWl5BfxK2LoCNx40Ybyz/YXJvJ/Co9IRsYSMAACG6jrn/lD0R23T8TZVx3i9lw4/R1k/uBcyiVH9XN0J7Dsu0cZMuO3PxeAQuQT/JmfNobykP8/ePnNKEm4k9ZNOEb3jMRtrw7yL2MGghUIFmAMh+bQLDwMrI00aeHZmUTLSOnBzrT4t2+TCRAQuxGB6WTXetGwr39WiOhc2OTS5PRc/RprM8iEsEdOEwh0egM4En9s0FIdbVOMgM2oDulogi0xtdDauMVqamsm/zNA3bOQxHiE5H0SW6L6MHE9MzuszBbQnsi+A300A0LOKjewJuLolflPheBR3vv3Q5g5bzXvqTf3XfKSxPDpYeX0FuVbm5Mh19HsEUXiil+XL0BCcYub7JrfFjqb7CQV3GcxeFpitbLVlHD7QujmlErTNpE3MHPgWUqnSgIz/9PDuPhcBT3ZueQQxn4/8t5OiIFiKRdipiyRw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--=-lLdZloGm3DorjZJ7MBLc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2026-08-11 at 12:24 -0300, Jason Gunthorpe wrote:
> It is documented to be like this, even if it is hard to test..

So don't change your documentation :)

> Even for normal blocking notifiers you should not be using
> synchronize_rcu().

This is SRCU not RCU, and the read-side sections are converted from
rwlocks and never had any allocations inside them anyway. But under RT,
rwlocks can spin too, which causes all kinds of fun and that's what
pushed us to look at SRCU... which actually performs a whole lot better
at scale too.

But that's a separate thread. If you have input on how KVM should and
should not be dealing with that issue, it would be welcome in the
context of the specific patches which are doing so...

--=-lLdZloGm3DorjZJ7MBLc
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
DF6Js9QTWm87d6yHwzxbPjwAAAAAAAA=


--=-lLdZloGm3DorjZJ7MBLc--

