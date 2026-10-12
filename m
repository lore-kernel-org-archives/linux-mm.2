Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1A4BCA9ED0
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 10:07:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF2006B008A; Mon, 12 Oct 2026 06:07:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC8E46B008C; Mon, 12 Oct 2026 06:07:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B81F6B0096; Mon, 12 Oct 2026 06:07:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 71D1B6B008A
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 06:07:49 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 04BC1A0AA9
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 10:07:48 +0000 (UTC)
X-FDA: 85313547858.21.C29ACF4
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf24.hostedemail.com (Postfix) with ESMTP id EE22B180007
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 10:07:45 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=eMKIzSit;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf24.hostedemail.com: domain of BATV+b1d458fa1bbfebdbe676+8450+infradead.org+dwmw2@casper.srs.infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=BATV+b1d458fa1bbfebdbe676+8450+infradead.org+dwmw2@casper.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791799667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kyROt3Bx6V11cEXdf0N91aKogdU6p680Mn/KyRlYkFU=;
	b=UMDstO9Td7WBoUPBTZfXnR1BFkr/hQwAMKG4X+IY8vLmG9RB0y4jYkiVNt1JMWWkktsL2s
	5n2KNGbisXZBxmqBVULN/504TSBH5ycnwc9MGV9uyuarn3qggITDsoleYIvmPOEVISPHgI
	tyl6eliBsknt0vkgvxRQcNqR79bAjbM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=eMKIzSit;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf24.hostedemail.com: domain of BATV+b1d458fa1bbfebdbe676+8450+infradead.org+dwmw2@casper.srs.infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=BATV+b1d458fa1bbfebdbe676+8450+infradead.org+dwmw2@casper.srs.infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791799667;
	b=aCHCdpsdQMgwynWl8a0tvICgASsgDWjUtMwEgrDeffSXbUbxCfvm8M6MTIOiuZhc1ty+Fv
	FoYYQlHUZHt/Qj2BrtgFQpjmP14q7tbwfgm3cU4pRdRoJqsm1/unzU5MKO00Bj+3ASGrU2
	WLKUfIr0cBjJQdS05igaBZcWm33YwdQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=kyROt3Bx6V11cEXdf0N91aKogdU6p680Mn/KyRlYkFU=; b=eMKIzSit28C4iLChu2Q10ZsP6L
	Ay9iF2R2aI/sUnH8Ag1lVs1Q8u13JXurgjPhYySZ3aiwD0siGcav0x2GigO8aHyknUsj/4HURkpu7
	3zQccaV2F124+TlQ9os9PlP7Dk0oUQ8IEIWnLujBolBdWw/aEg5lzGGow5tR36WmOJwU5FAiH4fWS
	3dLC/CWDLsEZTO/Fu4s17tsepSVZKVa7il+zGBRl7f2leFyz1v/WY3hJTWsKKPRsQmAB8OpADbp8t
	U6nQIukO/PLhmZOtXcYceQTdMeGCETRmqImh+vN6EvMjVo9D1jTCr4ydaYeh0ef+nr94O0fYcr72V
	xQXPhJYg==;
Received: from 54-240-197-235.amazon.com ([54.240.197.235] helo=u09cd745991455d.ant.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xGCwD-00000004EQV-0ouL;
	Mon, 12 Oct 2026 10:07:21 +0000
Message-ID: <9160333dd2439b503d0d675fa085154bd373a9e2.camel@infradead.org>
Subject: Re: [RFC PATCH 0/9] mm: Memory providers for guest_memfd and iommufd
From: David Woodhouse <dwmw2@infradead.org>
To: Fred Griffoul <griffoul@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
  Sean Christopherson	 <seanjc@google.com>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton	 <oupton@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner	
 <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Jason Gunthorpe
 <jgg@ziepe.ca>,  Kevin Tian <kevin.tian@intel.com>, Joerg Roedel
 <joro@8bytes.org>, Will Deacon <will@kernel.org>,  Robin Murphy
 <robin.murphy@arm.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar
 <mingo@redhat.com>,  Borislav Petkov	 <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>, x86@kernel.org, "H . Peter Anvin"	
 <hpa@zytor.com>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan
 <shuah@kernel.org>,  "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Ackerley Tng <ackerleytng@google.com>, Lorenzo Stoakes <ljs@kernel.org>,
  "Liam R . Howlett"	 <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport	 <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko	 <mhocko@suse.com>, Joey Gouly
 <joey.gouly@arm.com>, Suzuki K Poulose	 <suzuki.poulose@arm.com>, Zenghui
 Yu <yuzenghui@huawei.com>, Steffen Eiden	 <seiden@linux.ibm.com>,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 	kvmarm@lists.linux.dev,
 iommu@lists.linux.dev, linux-fsdevel@vger.kernel.org, 	linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org
Date: Mon, 12 Oct 2026 11:07:19 +0100
In-Reply-To: <20261012095800.50250-1-griffoul@gmail.com>
References: <20260720111259.122911-1-dwmw2@infradead.org>
	 <20261006183235.16576-1-griffoul@gmail.com> <yq5ald8680t2.fsf@kernel.org>
	 <20261012095800.50250-1-griffoul@gmail.com>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-NGhcf2IBb+AIA0wX4/rS"
User-Agent: Evolution 3.62.0-0ubuntu1~ppa1~24.04 
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: EE22B180007
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: 97hqdp8rdxwoqisftafs553c8kz6i57d
X-HE-Tag: 1791799665-337056
X-HE-Meta: U2FsdGVkX18VYZr9MAdO5f+C2o/OpRHtKkkC/Mu9OEijWETEs+ZhKWJznq5zfylHnlAqGQqjEWL4vlG6dhy5sqgBv2Z/wKmkkmSJbayqwuMEwmZ88P0KHeCs/0j3y7KQ/PAL/QECoEketszfYAzb/BkU+wGHGmkUI5DhIvAt3qenp+VHeKpOqoyxu1b0fhNpkAKsmJuF+J3IIMduJ2nUKOobhRKryzGD+COOLjtx3rUCwlhS+NzjWGSwQFG/rnaIhBz67WJFcMJT0pfkh8c4VtzeMqp+c49xJNxq+nr1+4X2lPvgCF/jFP/Tsa9jhYyLsvx+U3GVRND+9OMf/wP3ukxQl0nPp6slr0DWBaFTUHXcG3pTcg+DgBzIyc/M9uYtSZ6E+h94YSZE+jZLwTLYg5kUg8c5DUFc6Mjtr6tGVgQQyuPujvy3BYcXLSokyNQ7fjmI9IPAzkxBdWevAbBo72TtIbyes1qQPzm4e5kUvGe+LF5xZRtL9xv6f5OnbDtaX1XOAWyOhwydNbHzCrpQz/PJNRo02t+znyv7lR4eolqPprzIPzts4mtJ9AmbzVtLJBWXFdzozcmRDl30MOdPkrGnGCRqfsBKVB41yKAr7HWZFMy5H0ukt7eAm6rG5z1UU9qFeX3WQhBgGt9wYdbk49x8pl/aPFj6GEpjUN079nb8ejkM/a1ckliHrZ+L5e5xqdNO6OK7YxDEwhv9qF5ubNSLk+sp7tLidzwO0xNKDrREisectdoscrQFdl2YaV0CKvA/SjXQZzPbUPTzdi0sjXXApg47e/hsbKGibJ6mf8rF2T+UYBn+lXmYxUi0gx3x0HLrejd7cwIQh8OYWwYpomBtOxxR3av7ct8X030IIGfo4nY1NHQ0pV5Ie29Q7wTK7Huu8pbKVURGdPGp0IcYtHtBDBCqhmRV5o+kUXdEDpKEgoyqhVumEC/nwPaLC6K270rK73N/lhI+Eofkamx
 7ljD4taR
 v5gAaWLvCsLksYN/xpxG92GcP+M5E+X6eNRFAnXxq+XwooAsV1mjnBFRE3geZV3+m3P704biSKP90r8w5EQC4T+0F0/UPBYaYbgs9mIEBv8c7Txzq6rpQnW27pWARN+K6isDsnBHx8wR8RRrk6paPSlRGZ2jFvmjmxMaZWlgBX29laG1w2CP1xQsPXiYXa301h9VOnmNT4Bb8TPDmRUFvqVS06fsmlkLpfmZR5nnpXff2EpxpHQ5LwalaNNOWljfDMLRj1Cv3boajGXFeTQM9AME6N5iRV4qg5JdAMy37tvkOsnM2n6FOAx/0D0xiOAbYjI6wqq+XRbeLHw98jeI98CwpMgloj6Y82dJ60UCcMUaHE9yeKBLn4xjIkCO1c/+po+3Sn1OaG1Knn0a6FOWsMrGlFdk8WEy+agj2kbWUu+mrQZ9Qo7m6VXckONzZnHLljIMUebQ4p5AB0h7q5E+I5Y+rnT49p0PJid4ZT3xQGknbE0zAJJasFm5nSVKhAAn0wNzwk7miZlyWTTY7ML6f3cg21vgsTxYdmP+efGaggL3BYzymhOKx9sxSSsM3ECzOrbWkyvNl6gQrkdsEBnH94Q6zpLAMO7QhdnUk5j49jhe7MZqwhkFtXrQEaKYzOf1SaKFyeHyVyD4Pwje+CYl82bN2crJicfbeBFKOgi8bpR97Hb2rb2GAicNw09kLtS5xwcuo8OzutTUjdEnoFFyq9Pu6l/WHz59bTh+uRn/P7lneRbTis3kJ3gnZ1f93tqE44nERWArD8ODMo6ez3VGtZaFXansxLcDR5on//ilwbG917uKDNigN3gN7OqcPU5MrRYegLvNY27su0mWpfM9tYCZx3w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--=-NGhcf2IBb+AIA0wX4/rS
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2026-10-12 at 09:58 +0000, Fred Griffoul wrote:
>=20
> I plan to change the revoke anyway, because iommufd must not leave the
> device with a hole: it should replace mappings in place instead of
> unmapping and remapping. Would that fit your case? I suspect it depends
> on locking, for example whether you have to revoke while holding
> memory_lock.

I was keeping that hack *entirely* separate from the guest_memfd work.

That's a quirk on the IOAS in iommufd: "whenever you unmap, put *this*
page in its place instead". It doesn't belong anywhere near what we're
doing here, ideally.

I even talked to Jason about it about it at LPC, and he didn't hurt me.
If we implement a hitless=C2=B9 REPLACE operation then the scratch-page end=
s
up being a fairly trivial thing to redirect UNMAP to REPLACE (the
tricksy detail being that it uses the *same* scratch page for every
IOVA in the range).

=C2=B9 why do we call it that? Shouldn't it be 'missless'?

--=-NGhcf2IBb+AIA0wX4/rS
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
N7U+jy2+38XGWwLhyGFNbowAAAAAAAA=


--=-NGhcf2IBb+AIA0wX4/rS--

