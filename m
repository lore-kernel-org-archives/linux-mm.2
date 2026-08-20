Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98C58C5DF81
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 14:43:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52CB66B009D; Thu, 20 Aug 2026 10:43:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 504936B009F; Thu, 20 Aug 2026 10:43:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 441CD6B00A2; Thu, 20 Aug 2026 10:43:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0FD026B009D
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 10:43:25 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 84B77A1F6E
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 14:43:24 +0000 (UTC)
X-FDA: 85121915928.15.238342E
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf10.hostedemail.com (Postfix) with ESMTP id BEB44C0004
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 14:43:21 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=i1JnGMfI;
	spf=none (imf10.hostedemail.com: domain of BATV+79dde780bc9caf9b17d7+8397+infradead.org+dwmw2@casper.srs.infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=BATV+79dde780bc9caf9b17d7+8397+infradead.org+dwmw2@casper.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787237002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4SDgz10pMi8kGfCeX16I5v/bsZUY/gLL2WdWTUz1FzQ=;
	b=goa5kBfWM0Ld48OqRipZToBk7UjA+r3k6rhj6wnaAA98zKaSUqwIryqXLj8RYvW663ycia
	6tG42dODdjPchT7onb/HQXzS9dP/Rga7wLm0O9HWrHg6qZ2rpf9cAKw4xh5HY/8e/rX2/4
	yI2gHf5VVruR4rCcwpZdkg8GadlvrQo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787237002;
	b=Jv9mFYGtB4EDCR2W09nu35sXsCiVm7Vd9TqgwGy+w3EV6pHPQIoXbrvnd79LnkTdHGIS5p
	m0qqWI/u4ZLdj8LTtTCVNWUCGPo+jTiLp5KnokCbY+qdgrWywMgOokL6SpM6MM0E2AtLgH
	jkhJIm5LyS4oT0q3c/aqdmkccqGVpy0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=i1JnGMfI;
	spf=none (imf10.hostedemail.com: domain of BATV+79dde780bc9caf9b17d7+8397+infradead.org+dwmw2@casper.srs.infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=BATV+79dde780bc9caf9b17d7+8397+infradead.org+dwmw2@casper.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=4SDgz10pMi8kGfCeX16I5v/bsZUY/gLL2WdWTUz1FzQ=; b=i1JnGMfI1mjtg7j0bYX+EscmFR
	NEOxajAYh5VWGns9iujouK6WsYayTJKWiPKIuTVFd8VX5jrYV7FG7418kynZbX51KgU17PcWW/ZVJ
	S1Tk2qadeU90OLXTfOLM6jmZBjnL9Wuh+BG3WKGt3IvTao2Gfr4+8kyxBLTFSsgvRzi4UMX0sxLBw
	mWKiJUvnnhEIVDo+tcZ1qUseVHIeLdSKDPrjQ10hi1tS7+Vn3DN82I1vzSuWgWrVjF0s8e8nBR31I
	JzWpelu5vO7yXkPgPPhj45qSliFZb6sFgeJXAL6aFR2BdseY5Ar7LUEWgRYW5aHK747hhTAkponHT
	u1F7Dz4w==;
Received: from [2001:8b0:10b:5:606e:77cd:9db3:6c5c] (helo=u09cd745991455d.ant.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wx3z7-0000000FpDx-2nqt;
	Thu, 20 Aug 2026 14:43:13 +0000
Message-ID: <a17c8d33102c49c74a64fb62d402b315ba950577.camel@infradead.org>
Subject: Re: [PATCH] mm/mmu_notifier: Remove non_block_start/end() from
 notifier invocation
From: David Woodhouse <dwmw2@infradead.org>
To: paulmck@kernel.org
Cc: Sean Christopherson <seanjc@google.com>, Jason Gunthorpe <jgg@ziepe.ca>,
  Michal Hocko <mhocko@suse.com>, Steven Rostedt <rostedt@goodmis.org>,
 Andrew Morton	 <akpm@linux-foundation.org>, David Hildenbrand
 <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka	 <vbabka@kernel.org>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan	 <surenb@google.com>, Sebastian
 Andrzej Siewior <bigeasy@linutronix.de>,  Clark Williams
 <clrkwllms@kernel.org>, Simona Vetter <simona.vetter@ffwll.ch>,
 =?ISO-8859-1?Q?J=E9r=F4me?= Glisse <jglisse@redhat.com>, Christian
 =?ISO-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,  Paolo Bonzini
 <pbonzini@redhat.com>, linux-mm@kvack.org, kvm@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, 	linux-kernel@vger.kernel.org
Date: Thu, 20 Aug 2026 15:43:01 +0100
In-Reply-To: <49df45c6-4d0e-483a-8acc-0ace7f9a6484@paulmck-laptop>
References: <c41c52f02f033ea980d4b5f9b8239d5e9411a03c.camel@infradead.org>
	 <20260812134934.GC662699@ziepe.ca>
	 <a48e6e7063122b22a8083bb0792984a204f316e6.camel@infradead.org>
	 <fb87f673bf290cad133d113dbb0750a7752b9d30.camel@infradead.org>
	 <a94b75e8b9b1d2191f365c0f4275fd5082332df5.camel@infradead.org>
	 <d0692500893f303906fba1d7d596eb59a07a806a.camel@infradead.org>
	 <anydY25Cl78l1HfU@google.com>
	 <932DB129-1794-4855-A61E-F4C2B54B1EE6@infradead.org>
	 <b736237c-64ee-4eb2-8201-5685a3853844@paulmck-laptop>
	 <5f6a0669f319951462c2aae3a50d595983a42e4c.camel@infradead.org>
	 <49df45c6-4d0e-483a-8acc-0ace7f9a6484@paulmck-laptop>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-1EY2myuxlQvpkMHs1RVA"
User-Agent: Evolution 3.60.3-0ubuntu1~ppa9~24.04 
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Stat-Signature: uuiuf9pncpe1wmx9xcumn3denaddkpxn
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BEB44C0004
X-HE-Tag: 1787237001-786386
X-HE-Meta: U2FsdGVkX18dQYgS75ietlM6DDgKylvH/OOTgNmldtbKeO/QJTItJDVvPY8vo97uTU7bCwGlROrSvRWw0YvzzH1Ho6dxlh4X656L6Qv/aRJtzkGHAWJxQggd2KQhN72iHhIHmMislbRv4OkNIhQprJ7jBxX5PYauAptcuyizQPQCBWyKtRT3YyMTnrcriCn25mUqK2IgdRGkYueXVVSRT4UJWBgKi21tMyngqnWLt7rBISCTEoEGOiOCq6XEVTXBnyUijr7NWObgPEpFF64IRCSE0DPQ7Q0D70PbPbpjAkqQUBTp/krf7yk+yCgzOwUcQcsk2VQOFKHhkNKUjyEK6phMGiEW/YfLgJ4OJQBjyBBjUjrGfLP3LlKzO+LW3ndR9WGdN/8CrMv8j5uCTIG2dJkjdQHTemovBgwZSWPuaEsm8cIl/8F2gZ17HVRkkcgPhnk3rW3DCzZNfhu7jeFU4efqhzCxBNW+4boQ0feP/X7pGqoMvg4np993+YLOtljdFc67WL4XG3JMrAELkGFVqTuv2qzcztn8NjcbN/oWp6z2QC39bQeGlwKjtL7eARiMguiDQ8eL00/g+9gdRTYL143f4dK4fReb5OjzXlAlHlKC+Ix9jNnIFM4msrHchgVCTVvuhURq0PqlJm2MAdxgo5az8xwIfiuTy8mY1sYq/JZTBZTPmleRj86PgB4SZZse2y8PvKmt8bl63TBPvZ8IRNRc/YM944OMQsWdc1IEiqin6GPd7iZ2R27ETmFgfkVy3FpEHsD4qdF/NJFGcOb+Q/V4c+TPOxhDbwaEBhsrIU0yKJV+aR6CeGwS5rJYoDnQG9UZTjtP2Z96BQnD9nbLhrQ4lTVoUxkqvi3ccDWl0WuQxC+9Aho6E/7oD+WhACPefKhZMQsWH/X6HqHBsvCsZZYhPdU12geQYsXJbBcmV/w1CunmHkc4XTQvWn4BLBjmB/Zg206FC5wtdv7OonX
 rynkLj2n
 18WO9qvjng5bEH3AOrhLAWKsgtUoJrsjxkqicG8QO7v87Jpmu8uJARfSt50MF/YhEn2YIgxE31xr2W20d3k+xf4C2SzxlBiYkseMt61V2Achk7aPPsKAyNrQ/TCv9SSI+aU0EiSvRQN6/oAcAyCC9j4BQPEAXR3KMMbXBE0qFEKJxhmxM4vrW/K9XtIQhjO0e9zh7N/LUVeI+X/JaPFhSjhdAQFfegiUEyCMiNCm+x9cTa+EEj1pv5Oy2FMmFpvkr1G1j8+Aehb5UnwEyqNGrZjydCgJ6G/zKQbTbOjTEjvUQuxbiduNgxnLIpZ8bqlYb7nV27WvJLlV/9w/swfkfiIJx7qZ6Qpvz2TxUE9CIfY5lA/5OoRHVUopBr1yMteWHXReY4WpJcfCPN7V3t9ZHrY0HLAwJcQUUtgvKrj6YjuPdN+AUDF7RxMLSQbiEO6Ge33vjw7qqmYcIRB9fpknNxVqmY4eqJtsECaNk44Q5mm+Zql4MT77+TWCsaXJquO50gzI9n9ksi3f4CZjVch/TYa+2RwgzB3TkDWq2j6nAIrFVv2gy2/Rj6PiuIBv8Np1sLQ2VUG6kpp/CwkpTSNkPfjaZi0ZjTO0oLNAUqBIODN1OGcXSXVaEe6H5RENe0szep7+t8XEHgO1HuptmmHMHFT0ofakBjkuZPywlFWW21GzwdErPj8BCVwBi25oevszxsLXwdH5iJ2QohiDjknXf4I9gnhfX0s6N3ERXI+geM4p+DoV3UbxxVQJOs6U3GSAVz+0zV/K454NjJmzigjwXMFOWirzpWMylRikHtmz0v91QPPowc7jhQaDND/jao8B4uRTpaX5FCtnPwvKUbaQEHtf2M7mKONRqvaQNDQ1nBFDV43M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--=-1EY2myuxlQvpkMHs1RVA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2026-08-18 at 11:18 -0700, Paul E. McKenney wrote:
> On Thu, Aug 13, 2026 at 08:54:44AM +0100, David Woodhouse wrote:
> > On Wed, 2026-08-12 at 14:38 -0700, Paul E. McKenney wrote:
> > > If not, please let me know, and I will put together that does the
> > > job.
> >=20
> > If you're working on that, I assume it'd need the readers to be known-
> > atomic. So if any of the read-side SRCU_READ_FLAVOR_ATOMIC thing I
> > already threw together is useful, you can find it in my tree at
> > https://git.infradead.org/?p=3Dusers/dwmw2/linux.git;a=3Dshortlog;h=3Dr=
efs/heads/srcu-atomic
>=20
> Thank you, happy to steal pieces of that with attribution.=C2=A0 ;-)
>=20
> My current plan says that if you have an atomic SRCU on which you
> use srcu_read_lock_atomic() and srcu_read_unlock_atomic(), you only
> ever get to use synchronize_srcu_atomic(), never synchronize_srcu(),
> synchronize_srcu_expedited(), or call_srcu().=C2=A0 Does that work for yo=
u?

I just said this elsewhere in the thread=C2=B9 but I don't necessarily
expect you to be following that. So to bring it back here...

My mental model for srcu_read_lock_atomic() was that it was always
atomic, even on RT =E2=80=94 it was basically equivalent to a raw spinlock.

In fact I think it would be OK for it to be equivalent to a *plain*
spinlock =E2=80=94 i.e. atomic on non-RT, but might sleep on RT.

When I wrote that previous email I was thinking that might end up being
additional complexity in your implementation, but as I type this I
guess it could be as simple as falling back to the normal non-atomic
case for RT?

=C2=B9 https://lore.kernel.org/all/448c5c0128b08ab98d175ae1099ff4d4874e49b3=
.camel@infradead.org/

--=-1EY2myuxlQvpkMHs1RVA
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
j9A0j1Jn5ycWWB0qWmJr7hkAAAAAAAA=


--=-1EY2myuxlQvpkMHs1RVA--

