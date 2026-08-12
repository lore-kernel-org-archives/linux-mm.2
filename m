Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A675C5B572
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 13:46:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 666AF6B0281; Wed, 12 Aug 2026 09:46:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E0966B0292; Wed, 12 Aug 2026 09:46:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51D6C6B0293; Wed, 12 Aug 2026 09:46:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2AD5E6B0284
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:46:26 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id ACF4F8038D
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:46:25 +0000 (UTC)
X-FDA: 85092741930.12.71189B2
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf31.hostedemail.com (Postfix) with ESMTP id 5DA2720003
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:46:23 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=SjCc4uRC;
	spf=none (imf31.hostedemail.com: domain of BATV+5bb66369c51ae59fd3c1+8389+infradead.org+dwmw2@casper.srs.infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=BATV+5bb66369c51ae59fd3c1+8389+infradead.org+dwmw2@casper.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786542384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bCYYclSfRjhWt4hHcIoVE03AahFLbGrrBILx/n0UxMk=;
	b=HJ9JIGyjAJAKS+qZOTh9fOny1eFmN6iuh2IPD84YKLqCkutZkwvEIn/2nVGXZqPhRRYgyr
	GA8boyCtnRkJfb8XazuiH8yt4YERQxwKzHVV9jBhLxy7j/OalMeZWy0j813dBQoSMDntoH
	ycSacht0TjR/EzR6pzOZtBNGvBv6W+8=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=SjCc4uRC;
	spf=none (imf31.hostedemail.com: domain of BATV+5bb66369c51ae59fd3c1+8389+infradead.org+dwmw2@casper.srs.infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=BATV+5bb66369c51ae59fd3c1+8389+infradead.org+dwmw2@casper.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786542384;
	b=fdsIeryOKXuFx7u2FX/KGB9TYIrSDplcfWwvB4a05kTij8sT19sPdUcEPhEQU+WpGdPIHw
	l3+yb94YG3BGXAbaMVH3n5uMMeta5gJ8LO5Via0ZnsTAsGzmC8Sf7WppbSZzxcXGaMr5ed
	ODZlpaM54QGQbbKXIpJOERtwU0bssTI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=bCYYclSfRjhWt4hHcIoVE03AahFLbGrrBILx/n0UxMk=; b=SjCc4uRCFK/p5+0YoMXlFCpfLx
	NLtnTIkBF9OOAweUrQFJJ4nf65HVw+aa5eo0kq10MAVpjU6fq+Uax74XCGHb1+luKneBglHR4y+z3
	eY22ZDysZ7QlVtQhGHXNKIkhvT/ykLHahrng53dQyi+D4xjuB+wAd2oXeMQhkP3JjOHJheVpZ/cuJ
	bajyFX53jz22Lm5sgXYYsQ2XiYAxUZVt6OxV2l2m7x6aOwcQ0Moyh6xdNp1gEvf1D4Ev9jgtaq2A3
	0Cl7KZdvDli/uiAAzT84Y1VrW2fBsCvdhHpoutikwYbongb8wmmEVTRG9KpIdzVquNtcd6wqILOuV
	MtYbGA/g==;
Received: from [2001:8b0:10b:5:a3a3:d97e:a004:df29] (helo=u09cd745991455d.ant.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wu9Hb-000000023m5-3jHr;
	Wed, 12 Aug 2026 13:46:15 +0000
Message-ID: <c41c52f02f033ea980d4b5f9b8239d5e9411a03c.camel@infradead.org>
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
Date: Wed, 12 Aug 2026 14:46:08 +0100
In-Reply-To: <20260812122759.GA662699@ziepe.ca>
References: <a247c49dd61af1df7ddc4dcb1cccbcb36b04d9d5.camel@infradead.org>
	 <20260811135537.GC544626@ziepe.ca>
	 <1d669aca4ffee797b9c29215382444a5b23624b3.camel@infradead.org>
	 <20260811142730.GG544626@ziepe.ca>
	 <a552b227e18ddbb3fa1f2edf2d1cb30ee6ccff13.camel@infradead.org>
	 <20260811104229.72fdd928@gandalf.local.home>
	 <37b83b429b9f14ea6ad4ca1c13cc8e565ec09033.camel@infradead.org>
	 <anwraNIKJV8zwrNT@tiehlicka>
	 <44c51ace9b0dc44b795f6f48c91cda440eed910b.camel@infradead.org>
	 <20260812122759.GA662699@ziepe.ca>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-7FyFUaYUmO0qDCpcWr3C"
User-Agent: Evolution 3.60.3-0ubuntu1~ppa9~24.04 
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5DA2720003
X-Stat-Signature: rroa8kye7k188wjyqnyh8wkme4bbq17z
X-Rspam-User: 
X-HE-Tag: 1786542383-655956
X-HE-Meta: U2FsdGVkX18Y7RxJY8+Ulc2XdmhdW4ysQCpRPUKI8UUr6nIx13uMJhEH7AP4nAHGkk1jAcQsvZ+46Dr++vtKU9Pu48Ix8QNr3QCyKIYlMAr6gnnD3HdgkmE9UtcMxp+u3hsnCVN3KitjeMiQLBpWH3q+aeMxzC2S7dUDGEIkhGY0zlGiEdLBWjSf7Mg1f3VskeEsfC+fp4sWA6e5sv1IDC3Zh0FSDkW5z35oFk9CjidzlCg3wzmAvmOtoxC/Z4uDgNEPmn31MLvSkN8/15c4X1srLL4ibOn2/RgHxWgjzGPP2rLL0CHyS774JPK2XQGGo87cYK5e++224LVKMKF8iX8ki3GSgGKdgR25iGIwBXEOSudbW9ZtJ3N2S0MBy2yOI5SgY0ZzCv8ogezExnEDm+oAvAnS9AHQJpgAzXR2JJw3Q6ykAWkoEO9cO3ivO0GruYTA2g9J/RNMhAVuTNCd+lxMP4zzSGEPFEJxV3b0B40qFLXL5wYSahuUVmAV2K9DgKYQ/CrELgYglX0E65jhVvNUqOjlkJpyyn9cJU9gq/3cyZAremsfVzVzYl1U3JFE1hKsH1faOMufbiEhw5LnKUlUJ21qh5win6fS+lNXL9uR0+77ywzElcUGMEAG4WQEkBWEzDLvWpX5vKMfztuh+dRw36H44d5oGY6/A22N2UyXwAd5peHhVwB2h5lb9lwTHE1YqcK8p1wVP6/tjCODI7QSCOlhZxMlUuPepcHBcMVJGU1kCZWLJ3PFcJqSngih4ag0A8E+Kd+h/iodCWqd7Ji6kVZcaisir2bJ2+mxSdQOyVphTSoc8WXHYsdNhfpAXPB5aLo3hMEE73v7It5HU6QlsfskS/z91B8eu5vs1Y6SEw+JsrmIdlzPW2MPZCvdlyqIztbNQAQ/Shg8uwSPd1+hKMgJRV3jF+XU2blR49ZbJix9QazQ9Pn0zUfKs29hKFClcuUGgzoi7tn2YBK
 R4nLOrjy
 lbtSx5Rc212j7GrI+Zd2Pj6LbuphVWY92WWMexxyLv2BiFnpVYvtZMuJNlYIgRB4ERRzCzvlCy3mHGbRnLPM2AL2cnfNtg1NnsqTkvGkwODNMqivFLcqGZhdTVaYG5XNL8e5bRazHKcBzeoVyZU+H4VFkMNs/ENprlyvjfuPTPFEjAMx7TxX/6+MoYAb31UvqEa1poAQvFjqEpVPkv1HVO75/5A1R+xwlvfOKrhrx3pRUDfRCFAO/iOGkQ1wZS+1VYVrDkRbqXgy/d1SDoy/o0PPbycA84r11EbjJAofqTGZFx3D2uTuzSd1B247o0cSaZ9wwwRVUE5S3R9LE7bOjNsk3k/MjoPh86wW/xDACMGAusMHn0w86Qyb8UEpnVrsGr93tirRLcegWvaEP0qtzsN9pko/VsIr9SCmVIq7am0/PBD27GJHSwNe9Ni8p/Y1oHXDDMtkmJVd/m3uDQVJBhDsYieAFV9hHOBMmDJQHketOrqV1QdEy9oi60gRUhNSpDOtOZdotbV+yhxVk5udLhalEuPCXlfNkcKLghvmA2WvxyBzLMnJ9GfN73hbk0zziLPB9ZNysUU5kyB11Tfk+uZl/pI0kYSNfm3XOYpfXszq9OmcT5mUixkwHO7+vHs8lFJjeWIAjZS437oPF9CLMNnBRKSwivWZ8gpxecuUP6PlltJQKjCg75PoMOCLrsnzqmkijY3jKUA62RZwyy/7PGaCT+0nU5r5Ag0vbVu+JZL3EioLZgjAZuXiXIy/E5yI2OwylYAZt8zhlWpFavK+M5FseND4k9p4/HqEP2lwe5MWNtYYMMDm9XKmM9GNC+FsEBsDGavl1r+1KLgW2kd6uXko8ZqwcuUaoztKytrmat6HjwRU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--=-7FyFUaYUmO0qDCpcWr3C
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2026-08-12 at 09:27 -0300, Jason Gunthorpe wrote:
> On Wed, Aug 12, 2026 at 09:21:31AM +0100, David Woodhouse wrote:
> > On Wed, 2026-08-12 at 10:14 +0200, Michal Hocko wrote:
> > > On Tue 11-08-26 16:24:48, David Woodhouse wrote:
> > > [...]
> > > > I had a second reason for disabling the overzealous check too: to a=
llow
> > > > SRCU grace periods within the notifier callbacks.
> > >=20
> > > Is there a way that srcu barrier could cause an indirect dependency o=
n
> > > memory allocation? In other words what might block the scru to comple=
te?
> >=20
> > Not after https://lore.kernel.org/all/6eed3fe3461e9690b486ca98fa7563f60=
d3940ff.camel@infradead.org/
>=20
> The user of the SRCU might have a read side that wraps an allocate. In
> general it is not safe.

Sure, the *general* case of Sleepable RCU can do all kinds of stuff in
the read-side sections.

But in *this* case they were all read_lock_irqsave() thus far, and they
absolutely categorically do not.

> I'm skeptical that without special API and documentation the KVM
> special use of SRCU you've outlined will not remain working long term
> too..

I hear you. I'm less sceptical, given the use case, but I'll certainly
concede that the universe is known for inventing better idiots.

I'm certainly not averse to having a wrapper so that the read sections
don't just srcu_read_lock() directly, but also get a sanity check
(non_block_start? local_irq_save? what would it actually be? does it
have to be different for the hardirq vs. process-context invocations?)
for free.

Or instead of a GPC-specific wrapper, do we make it a first-class SRCU
citizen, SRCU_READ_FLAVOR_ATOMIC? If it disables preemption, we'd know
that lock+unlock must happen on the *same* CPU, which could potentially
simplify my new try_synchronize_srcu() and/or allow for a *spinning*
grace period if we really do want that (although I'm unconvinced; it's
*latency* we care about here, and punting to the WQ when we *already*
have to wait is fair enough).

Either way, I see that as a mostly cosmetic follow-on from the real
fixes I'm chasing here.

--=-7FyFUaYUmO0qDCpcWr3C
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
guy5ozsZ6WAn0xjnspSU9+QAAAAAAAA=


--=-7FyFUaYUmO0qDCpcWr3C--

