Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A867C61DBD
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 07:38:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F04376B0095; Wed, 26 Aug 2026 03:38:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDBFB6B0096; Wed, 26 Aug 2026 03:38:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCE3F6B0098; Wed, 26 Aug 2026 03:38:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A52AA6B0095
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 03:38:50 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2ACEEA366F
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 07:38:50 +0000 (UTC)
X-FDA: 85142618820.16.AC7AEF1
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf26.hostedemail.com (Postfix) with ESMTP id D3BFD140004
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 07:38:47 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=m++6N3rm;
	spf=none (imf26.hostedemail.com: domain of BATV+5265e229a833aecec1dc+8403+infradead.org+dwmw2@casper.srs.infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=BATV+5265e229a833aecec1dc+8403+infradead.org+dwmw2@casper.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787729928;
	b=q3Zk0AeW9r5jBVXpF9i02sDkniOV5UhuPJEjBNJ7IZNPj1pIIZA8BtUG/IUib2gsLgEhra
	ggnRBge5+6/4Tl+VXYw2Z3Lus0r9hGa8q1n3qb8SwIvZGERV195vIN5k0CjD4xbseJSDCc
	zjIccbjh4T6JCQ7IaawH21DLXPD7au4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=m++6N3rm;
	spf=none (imf26.hostedemail.com: domain of BATV+5265e229a833aecec1dc+8403+infradead.org+dwmw2@casper.srs.infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=BATV+5265e229a833aecec1dc+8403+infradead.org+dwmw2@casper.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787729928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8KDuBkXGCz+P6syp9QJ1MdTVjN8HtP6OLknPrQ0iOV8=;
	b=Ja9BgebUDZLYsw2ygCMgsG2f+Fp7G6fN9qxK9QDsYdTuqretXGh2FI8f8zbI+CkYWQmOrI
	0pMpX3dbnY67Wm3IGdlG+kBkN/nsGc0G00L8oWHJyukIYP+x8rIb9ze6PeqthyMOeDjiBG
	FzH3w1e0GkzA0I1PPjI+/vo+dPyL57s=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=8KDuBkXGCz+P6syp9QJ1MdTVjN8HtP6OLknPrQ0iOV8=; b=m++6N3rmB361/00HHqKVSkwG0Z
	nFdmyXLrW9Qxu2zNyNoxXmDkROjixacnZ0qdl2IBFSGD04GJqmctjoA9l5ESm3/5wOBsu0vF5q9o5
	SSbAbsZBbOeTjp5swtZKz2LkaatzGD3hPouJMNk3qCUyU9EZBTdIvFvsasF/pXbFER7xHI1vXVRFa
	qaUdvU0s3NrXl883qCDNdHlhxAbXNnNo7GpouUkTl1b3nQF3YN/7m5qs5uksgnbWDpBC9w0Gvihqq
	SsIFO3NnKT6u6Eg0bgU+/fXN3zcf8k/TclDxYU/I9r+/MaZ5uYG4fhy6zSrqXkry7BsR2SzglwUU+
	V3EeDTWQ==;
Received: from [2001:8b0:10b:5:faaa:2547:1b33:7d6f] (helo=u09cd745991455d.ant.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wz8DW-0000000AUWH-38NB;
	Wed, 26 Aug 2026 07:38:39 +0000
Message-ID: <da5ee56b7d082abfbb20f71be99a6885247e9811.camel@infradead.org>
Subject: Re: [PATCH] mm/mmu_notifier: Remove non_block_start/end() from
 notifier invocation
From: David Woodhouse <dwmw2@infradead.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>, "Paul E. McKenney"
	 <paulmck@kernel.org>
Cc: Sean Christopherson <seanjc@google.com>, Jason Gunthorpe <jgg@ziepe.ca>,
  Michal Hocko <mhocko@suse.com>, Steven Rostedt <rostedt@goodmis.org>,
 Andrew Morton	 <akpm@linux-foundation.org>, David Hildenbrand
 <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka	 <vbabka@kernel.org>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan	 <surenb@google.com>, Clark Williams
 <clrkwllms@kernel.org>, Simona Vetter	 <simona.vetter@ffwll.ch>, Jerome
 Glisse <jglisse@redhat.com>, Christian Koenig	 <christian.koenig@amd.com>,
 Paolo Bonzini <pbonzini@redhat.com>, 	linux-mm@kvack.org,
 kvm@vger.kernel.org, linux-rt-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Date: Wed, 26 Aug 2026 08:38:27 +0100
In-Reply-To: <20260826073233.T-KtFXmj@linutronix.de>
References: <333c4cdb-8f34-4e3f-a47f-961f47e089a0@paulmck-laptop>
	 <11dcf5a87125451897982f728c1f65a5151987e4.camel@infradead.org>
	 <69567965-48fd-48c5-abb6-0699d7f5bd16@paulmck-laptop>
	 <124af87fb49c267eeb26b8b4d952b9b1a5b3fb68.camel@infradead.org>
	 <9427a8e0-3ba6-4f31-a35d-54429bd7e071@paulmck-laptop>
	 <3d0463b6099d4fcde9a025a2f9e231d75303b61c.camel@infradead.org>
	 <b0be19e9-b0ae-48de-bef6-d905ee007c8a@paulmck-laptop>
	 <ao3z7Rtw2FROkVpy@google.com>
	 <d4f8ff92-08ac-4253-b647-f9e95c66698d@paulmck-laptop>
	 <20260826073233.T-KtFXmj@linutronix.de>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-xQ80iZVICoRkknB277yo"
User-Agent: Evolution 3.60.3-0ubuntu1~ppa9~24.04 
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D3BFD140004
X-Stat-Signature: ob88cojwrf19n9mrbpybwd8etnki3cmi
X-Rspam-User: 
X-HE-Tag: 1787729927-58250
X-HE-Meta: U2FsdGVkX18CFtIyaz1jaq5Y1+Y0Lm64wLqsmAfUs38z1juNObqsNJatbf6AIAeCgT99yQimSuQ0iBi4cLV0Et0gySF6axps6SYglgnRN8mqGvTkwVRw0VJ7vB8ZHjrBi6jFv7pvO7PnfCsuIbxK5XCAL4Bp9is2mMuigYcQaFtuZEHbawjCh8NjGDLVZEWzQch5aRcZ42E1lXYkn+8oDBXoVuhZEXR7D9IzIxbHmh4fkrYf68UEzLjOxVBcBUK78yVnzsryxSrQO1R9oFU69flFmfuuiMQZDH4vsu051+Di+9OyqqCHZTaQw/TvLc+CUbblgN7sXYsvI5RxehXz7h99EMeJ4EjnWexmyjGii1iyxpitMGwHHUWxc5K2ytPNXfeaWDX2/jAAbWAF+2c+oT6tXi6uMxMYSa89jxgfjO6OQyBMdFxNds1INHgR6WL/WrpkuZihD63Ix9VP/6vZ4YKmPRxSKhngHmF1MDwCUVvvStjXbHRbWhs7Kd/Fwp/Y+kI6nUVayMB15ahTaFnEEdbbdefx+SPg9YlFF7pTIWv/1OmXCjyjDwJZJ2ASp9NgXWR9j7wCiFHDD233Ke083xKZHB41tvZstAgmN9nDCkIbHrODNWkad1bvBCC5FDz6pBnRLMn+escG4nmjZLuDuJjeZaeWwa5O20HINd9M8yKv/MND+jY8gYoN0e+QuxKH2IoiZiB20ABZYh67w883zQVolX3uYbOj0+V6sAaJWj9gWEFe5HfvBDD0QLobwtZ6VEX4Bba3aXSru33ijPJWjGbGt0D0EfNmSfwGXN/cCMT4r9gP3S3KvNkE32VHOErlo3QVOlmwKNqThGZuUBYsFiStpCEbg86LThXrNaQcTMNPo2yEVI4WT4LwpZW1olErkChLrh2PTTD85JM6wXYV54aQxCUo8Wqwlx5/HW+OIsu7MCPwCAJ4erUZegGznkfcl85f63jAJSLz3ujaEAJ
 BLvBW/N7
 n1sA00fGKX2xEDpTNkmWBXfyqbRi1vnBC39xiBaGNkp/mgPB+UatT4/Nj8BwRUqK3mu1cP8jhD/rw5nmNcVHPj4C5ei9Knm2y5KaQjaqMx3VcMQnHxP9FH3ALu0XETIKb0cmS/fxlkVwpHnBGBKgSCVcA3R+EbFWSUz5mPJJpyruLEyMBuWe50RCbXEfRIA6UPio5+2fLqonFjKEZy5cDdjuaECckFMutHClyVW/bygVzfHF/PKBMM608hc3CdzGPfuPOMk5g12kPNuFWdeNwqn+GMgca67Uopg9mdz/z2WlrlRD+43GWVyADK7FnILuP2X4CcwDV2PEYPDyX26lgJptbugNMo08EaOxR5qn2PA7qX2uqU2gNyp0x5paNpzOU879/Udak8ORw/5CagtfZTCNfdOi2ZYmPVK015/zdpWdV1UyaLPq4IvulLP11YoBiM7m5pWWMJkmjJQ4qYMBzTw4jYU0P8IIqQ4dpcoTcewadF3ZeWCtT/0YV7EYesk6awtCpI0AZN+cc2y5zeHG4SUp2HCeGz4DIJVpmWfwx1yFLus6azkH2HgMmLv0l/gnLl4UT+6usymmwk61LUeOcd+TNA2RlJ4hZoRY/NbvlGffdZj34iATQhjvVpgyGo3vv1Ks8IXH74aTHBS0PHuInIkrAunB4Z6LjX6WqJdiaenLlPjaFp0gc2On5tllK6yVkCLSZQ02TiuP99awNiFPkfrxE7Mzgk0iwvfKBp1N2mWc/ODK4Tizxa24y9EERa56vGRkhWWrB0IZrKXPkHnxlQjiR1A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--=-xQ80iZVICoRkknB277yo
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2026-08-26 at 09:32 +0200, Sebastian Andrzej Siewior wrote:
> On 2026-08-25 13:51:14 [-0700], Paul E. McKenney wrote:
> > Very good, preemption disabling it is!=C2=A0 It is quite possible that =
the
> > PREEMPT_RT guys will need something else, but one thing at a time.
>=20
> This reminds me of classic RCU ;) It might work in this use case but I
> am afraid that other users might come along where it actually hurts.
> With PREEMPT LAZY the preemption within the read-section should
> hopefully be the exception.

Given the way that PREEMPT_RT treats other locks like spinlocks and
rwlocks =E2=80=94 turning them into sleeping locks =E2=80=94 I suspect it m=
akes most
sense, and is consistent, to also turn rcu_read_lock_atomic() and
synchronize_rcu_atomic() into plain rcu_read_lock() and
try_synchronize_srcu()+synchronize_scru_expedited().

--=-xQ80iZVICoRkknB277yo
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
hLyJpRRicw+O7rUygrrl/+QAAAAAAAA=


--=-xQ80iZVICoRkknB277yo--

