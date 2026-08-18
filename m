Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33D07C5DF7D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 18:29:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 395D16B06E1; Tue, 18 Aug 2026 14:29:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31F5C6B06E3; Tue, 18 Aug 2026 14:29:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 212436B06E5; Tue, 18 Aug 2026 14:29:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E9A866B06E1
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:29:17 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 828F840136
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 18:29:17 +0000 (UTC)
X-FDA: 85115227554.19.FBCD75E
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf30.hostedemail.com (Postfix) with ESMTP id 86E748000C
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 18:29:14 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=dLzIFXGd;
	spf=none (imf30.hostedemail.com: domain of BATV+d2e1315c6d222a5d2c6e+8395+infradead.org+dwmw2@casper.srs.infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=BATV+d2e1315c6d222a5d2c6e+8395+infradead.org+dwmw2@casper.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787077755;
	b=NgQq7kQv6Yx+bsAj5ESemRLrJbzDf5yYPiGbnDqkwkTQ9FIsBd+Zs70pLqJXSpzB2JEfV8
	0g6ZoEnqR9x9Apjmluuoe9jNFJ5fsC8SjSlCjUch14goyDDYv2vv6I+WnVB1beZp6w0Nvs
	3z1Vo0AdtH41EmPmDoHqzAcXMwzJQcA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=dLzIFXGd;
	spf=none (imf30.hostedemail.com: domain of BATV+d2e1315c6d222a5d2c6e+8395+infradead.org+dwmw2@casper.srs.infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=BATV+d2e1315c6d222a5d2c6e+8395+infradead.org+dwmw2@casper.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787077755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sQEnP7bw3fUula7e4ixjASA+CGvRUFzLV5Gch+qdJ+w=;
	b=HEHh8qss83YZnB0hzrBhBBiyvdoIpkbk+iiwm0blio62If0own7GJkcUJL+7BjE4um9zRF
	GLw4QbEIkyoDYDXx3oVxrLqa7OyMH5EHFw7no58wzmbnDc5yDEtDeKWEFRDkii/iJ6ugfA
	1BZdsIrrlmfnhZm061jofgHBE5jnh7c=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=sQEnP7bw3fUula7e4ixjASA+CGvRUFzLV5Gch+qdJ+w=; b=dLzIFXGd4A2eFBRzKonNRbLQ9g
	mE8DVqAVVQI2gbA0hkOT0/+d+BWXHZYC11BfUpjmeV/sZ5jpifC8Q++yKnFi38BqCrV9TokDoN5+q
	e5eo5OifU6RLg2AQx74Tj/k8B64vxZj8PbnuW/wyTHmJuUEpUfCB7UIRcNrGNxSxPL5U0vYpOkOnU
	JKxBqTAGom8XbQznpi0xraEsFzvVcdGeNjtZTpmU87UvNxIJxxOaLi0fm1h6VHRpMrIpJGkYyegKU
	VnhnTVKhBjcULFZe3iOHQnIeC4pufl9NGLgUsGhToHHxk+WqOg/EhatrOE+TAzHw9uGSvekHmXYs4
	UaYmYxNw==;
Received: from [2001:8b0:10b:5:e1e9:2184:79c4:acd2] (helo=u09cd745991455d.ant.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wwOYa-0000000CRNj-3YZV;
	Tue, 18 Aug 2026 18:29:05 +0000
Message-ID: <058392901368b969b9c8f6f850b8959d5b5661d1.camel@infradead.org>
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
Date: Tue, 18 Aug 2026 19:28:55 +0100
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
	boundary="=-xcIsftZ5chiA7z22mZeL"
User-Agent: Evolution 3.60.3-0ubuntu1~ppa9~24.04 
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: 86E748000C
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: zbndoy8g3meaaz56p18my3q3zw5dh7fz
X-HE-Tag: 1787077754-636311
X-HE-Meta: U2FsdGVkX18dhxNLjjyjLJyni+3c0Olw5CZ5dSWrTCjKVn7v6bkElKCNgceZFRn7ahMqnQN9vm/w7UgzycYUKjouTr7lx/bGHD50v0Z67yUPrjsnK2YuGf35u44H+N994fY8FFgz5l9nVydx4S5A0BRVbAK3kRGSXqA8XOI9Fu1cq8dG+8FLaWk1l/50w9zyFPiBJ/po7pf12701r66jVwXFA2Z5ANnf5/AaOh8SEZbE9faemTYbvMJ8fYkIAjGwGYijFru1IBfbDBaw6yNbitLBSy756Ea09kjnbaTSkZQNM5VCYOUhP3Xhxr8diBHLBl27n9GVu9g/da17CewqfCn6UVHWIdVM8dwT3SiEBVhVYxhxhXRtgFEQvJ5To8Y64w9KczV0sUJQ66zPK5Arp41Xd9OtD+U3hpqpSHe6eAQjZDsKmvFgSzo9iG9sRST9xUCArroghoq2PiO97k8AfIWGMYDvHkMS+62ommzVWA4BMRU+pLKrkapxwN8Ubl8coL1oFRs1zrL0dJjTjek9kkEOfGp8Zh43km+WJU+mRRchIsFZ9UMEhD8VwQ3rp2Hbu6wF5ZlpGY0blEr0v3pTR6y5xIHCXWtlMdKv9opR1aMnrBpe7yEsZH61AfBpiekoshLgHLyaekmRdEbom1oZoSAXQORTowL+qMYRhaGSMDTojz8PXwMp1PuTK0Z7A7pqFE/j5IgbfEmimDIb3+JahIfa5ml9UnS481gZ81vWPwVyRHH8KpuM/jqd1Rk5jEQYTf0WjOypNjSWZtm3zb0JtBHS8IesAabt96ta0K4YUrumAUZR545ZDoH+D4l0vdNHx9dGYP03KqM3xgDz3EMy0v6N9jKVxpjIg4kcuRoilmt8p/1hETlEWgvGBx09P/Oav3tQi1XvQ7+OqSKipH49dLYPw9Vw8I/bkTO2m84ytGk4jBKo/epTJFiqI2qxg6x3FNPemBXgJPDuERmAg4A
 UorzZasf
 GrXBRFYFuA//he0C7QrJAxmToi/Dp+yd0PRuvbuQMSuAoWHiDdc7dFA613K3xJXY75H4jc3fBAkvFX+80KtG47yAtiPdxlxemCDbbZadZNHaLzXz0lIjqxvaJr+wKnKnms/F0mNxw/lkwzJMZRCsJYLfrx82RHA+MGvElaTCEuKnF99ff5pD6BIGz8Dl5Y11G/kdBFDoh4ioErDGFXEhDwxHNuKSLgBSHt4t4TfjMaPaiZG08Qz4BR0iTaLLEYQ2OxmEgoE60Sm38tO1K2SdEeGeMhPS/+EdfdevoDklBiyaZ8EKwlfUyjz5l+iW/e0fhnhg/WOe9GS6NT7GJm3ef80L3QBZ0vRjB56sM+YiIVtoCUsxw/GbpOewnfQN7JW3dFCJ15Dkk8oVxNKjCklVomSOCPIcTh/QVVYjfYuqZUjF1eB2/b8kTDm0yd/SkJfOfT5EB1nRlz7iUl82qAsaxd1MhIOjWl6sIBhxJDTE120sNMjFa93Md0udzUqKhBrwoTfWBV/NO2KLq9qHEMdIpZ90aweDw3mdRxjceJIn/tN4C3npgwQQ6YdRhczaJNEbp5qoxh4eMAoWj61BZZ2iVnWnMqdih+Is77A1S2OdPRwzKfrD4x/Da0kVVLC1KpETTqtGp0hH3iEg3PEImMn0qIyDNZHAgxGngqxGyHXg2DbehgIpu7FB2LkJKPhI6DR8r+uNdlfryl1cp6cl+I7/b12s12AUgGU2nQ3ccnjTxn/bpP4EnkqLjmy8suyF+07fRj/IsMPuBAonooWQ5LTewMUk/SJex/KX8QGDvTOR06li0KwxUOI5+nqqo9CI1N6nNScbTRdLZFzlS+8o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--=-xcIsftZ5chiA7z22mZeL
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

Yes, that works. Thanks.

> > Slightly orthogonally, what do you think of making
> > synchronize_srcu{_expedited,}() attempt try_synchronize_srcu() first
> > for an early return?
>=20
> No objections, but one thing at a time.

Ack.

--=-xcIsftZ5chiA7z22mZeL
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
N2ukwTng3elaTM7Jquv0xbwAAAAAAAA=


--=-xcIsftZ5chiA7z22mZeL--

