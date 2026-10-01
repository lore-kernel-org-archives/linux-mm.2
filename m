Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD9A1CA5FD4
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 15:48:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDCC46B008A; Thu,  1 Oct 2026 11:48:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB4ED6B008C; Thu,  1 Oct 2026 11:48:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCA956B0092; Thu,  1 Oct 2026 11:48:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A93216B008A
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 11:48:21 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4F4B6A6F8D
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 15:48:21 +0000 (UTC)
X-FDA: 85274489202.03.D0413F5
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf20.hostedemail.com (Postfix) with ESMTP id A28D21C0008
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 15:48:18 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=qs28909k;
	spf=none (imf20.hostedemail.com: domain of BATV+b225c3dd680a63b396be+8439+infradead.org+dwmw2@casper.srs.infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=BATV+b225c3dd680a63b396be+8439+infradead.org+dwmw2@casper.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790869699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kmEqUwXEJkWWUbJHHfJD9dJskjTM3fcR4I3pOHDr+J0=;
	b=zoOC111miMArVrQ1ZAtoYbL6jyCuAy3DVKkUf991vmjoQIPs+69zbuaXXwDGA5tWe5ueEc
	h75l/NvnXeq9+EjlSeTjuFXU/TGGjiU0aC9dJTtzPohwuiVhQvqxh3GyB5azhTNYnXbFkc
	171kzpT/ZJTmaz7NKHqN1ULVipgy9C4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=qs28909k;
	spf=none (imf20.hostedemail.com: domain of BATV+b225c3dd680a63b396be+8439+infradead.org+dwmw2@casper.srs.infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=BATV+b225c3dd680a63b396be+8439+infradead.org+dwmw2@casper.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790869699;
	b=SU5dxVBk8PjppbU2fT7c8arGBiFOHIBYwVFcUJZ3ZfJvR2sEgMTkEH7insCk/J3TP3aR4E
	LIkkTRJUsgmIly1NdN8vo6uKFRMJuKLOFB0nfETAvEmCU8d7bAiHFkY9JHJOeV949ZmksY
	vAI65YMb9UIh5I0OEPWHp79lBL2k4yI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=kmEqUwXEJkWWUbJHHfJD9dJskjTM3fcR4I3pOHDr+J0=; b=qs28909kqyuCxCdckzMYyShkFA
	//cwVTbvY3txQHhej/1+7MTxYGX6zyVRHAknLjloY/prYwcjCGhsDdsTzhCG1Go5GgGGeoLIXVGa8
	jGtszfmJKBqmzWzr6Jiqb3kdivsIBykt7Lg+f6unBblpTzRP/G+Yw9sQFEN0qvvpvwH38btGI2s0o
	qIe1QRAUIITtDHqea8wVG9erHljuvHXZzfJWan0CE8RtLtpZnJv9r/CZCIeNIjzrsD0IsPbuqXHyY
	uekXC+inq2ot94Zkli4wFk6HalzDhIY8vYXa9CNRs6QdagX1gnuixRXa1wr9AGy182rkezrayO+tF
	w/TOeQ0g==;
Received: from 54-240-197-238.amazon.com ([54.240.197.238] helo=u09cd745991455d.ant.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xCJ0m-00000008Otc-311F;
	Thu, 01 Oct 2026 15:47:56 +0000
Message-ID: <ba82487d2fe70e762a06e42a9474299d1a501ed7.camel@infradead.org>
Subject: Re: [PATCH RFC 01/17] mm: shmem: Implement guest_memfd provider
 operations for tmpfs
From: David Woodhouse <dwmw2@infradead.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, Fred Griffoul <fgriffo@amazon.co.uk>, 
 Connor Williamson <connordw@amazon.com>
Cc: ackerleytng@google.com, Hugh Dickins <hughd@google.com>, Baolin Wang	
 <baolin.wang@linux.alibaba.com>, Andrew Morton <akpm@linux-foundation.org>,
  Sean Christopherson	 <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, David Hildenbrand	 <david@kernel.org>, Jonathan
 Corbet <corbet@lwn.net>, Shuah Khan	 <skhan@linuxfoundation.org>, Randy
 Dunlap <rdunlap@infradead.org>, Shuah Khan	 <shuah@kernel.org>,
 vannapurve@google.com, erdemaktas@google.com, 	jxgao@google.com,
 rientjes@google.com, fvdl@google.com, jthoughton@google.com, 
	tarunsahu@google.com, pratyush@kernel.org, fuad.tabba@linux.dev, Gregory
 Price	 <gourry@gourry.net>, yan.y.zhao@intel.com, michael.roth@amd.com, 
	suzuki.poulose@arm.com, Christian Brauner <brauner@kernel.org>, Nicolin
 Chen	 <nicolinc@nvidia.com>, Xu Yilun <yilun.xu@linux.intel.com>,
 aik@amd.com, 	aneesh.kumar@kernel.org, Vlastimil Babka <vbabka@kernel.org>,
 Fred Griffoul	 <fgriffo@amazon.co.uk>, Connor Williamson
 <connordw@amazon.com>, 	kernel-team@android.com, kernel-team@meta.com,
 linux-kernel@vger.kernel.org, 	linux-mm@kvack.org, kvm@vger.kernel.org,
 linux-doc@vger.kernel.org, 	linux-kselftest@vger.kernel.org
Date: Thu, 01 Oct 2026 16:47:54 +0100
In-Reply-To: <20261001141743.GB3019323@ziepe.ca>
References: <20260925-gmem-tmpfs-backend-v1-0-d36159822d18@google.com>
	 <20260925-gmem-tmpfs-backend-v1-1-d36159822d18@google.com>
	 <9292b27b8f48c515bee3246cf3b3a60762302186.camel@infradead.org>
	 <20261001141743.GB3019323@ziepe.ca>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-wgLUfkqFCbNdgB5koHEh"
User-Agent: Evolution 3.62.0-0ubuntu1~ppa1~24.04 
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A28D21C0008
X-Stat-Signature: caz1zjhc66okn44f6enhfp867dxucdyp
X-Rspam-User: 
X-HE-Tag: 1790869698-35295
X-HE-Meta: U2FsdGVkX1/TD1c4jduXmalVRoNPJgpI0W6+yhE4zQtFkKwHoQ5RCQiuReeVbpmsX2lho3VW9EEEMPGn5iFlVEEjwPK2/+kjzMVGuvjoBn+YPa4B4ePS3SBgwJ9HpIqMBhRYTYSJb/7A/Z34yrnWI9UiFMgSh2Uy44FZlF1AYszZIRaUtSj4gpUQ8mWRMuV4N/yq118Q9ekdUIu6NaI7xrCvIP9TbNwn50I9yHW5+FOhqFKnvVj/PP+m1DChjB9XYU3Rw2ZhgwZE9ECvnY8SXf/hGO60ehviUXALnFDXwtGLoK7z+JrW+o7burUbwyFfeABfUCNb4r7dO4CktSzp8SWzc9UWQNo5U4TlLtTlXE5AwCb9Q94KdBMJJD+rjJVAS+Pd+UHIPYG9e4L4Qoy7Jgfjc0kQe18rKT78o/sQUoulN1vsmKG1g79ouK6lpQEJHchUhCLB2/eW42a1aHiEVBEdPlAtLHKzBu+IdFG76+wwYMje4qns/aqmPxPUNnYSIC/UaQpWMTBqT805UJQnClft8uRv+YQbLJJ1cvuPJHui9olv5tom6AfmTYpdlPfOun/EN5DnA9OkVRi2hgn2+t3QNsdfn+U6cN4WL1akYteApGNQhXw0MSedwnJKCcdgF2JB/0UvtMWPxEoUey+LJ5uuVJiT37ZOCQntDGEL7s+28EC2nxU3U4xNKiDyatpYJn6qerAr4uOCOCRDr8qeXLNSGMUgm3IgoSmIQMRNjCJazgqV/KV1lHuQ7+pei3Nf6WSYg5NO6t2pExipJ/UWyD5qpT2TwJGT3b0Ax//LV274/zi0tcFzgNHx+jYPwWb88h+KQmzks56gou+KimyElrNavDfYuyVW4hpWrinEcIX/eBDFNF8Q1UiNpKJ4iLBFq6DY9Hb0GN1q9CrbeCoIySYwFNLnu1lU4VS+pFNcp9CcwgJzny/O6mjHU3Lr9dlZHAgUkRxJJgAsuWlAQ4a
 SzlcDSiD
 IStx8jwCLK/aTciRkltMhM6+6i+Ai5M0FlzYMAN5ohpUZDWHeQ5/5r9e/1rRs2S/iEQ9Uc7s+/xya/bCABcZQ3QI66QNqODzGri5iibsM1XIxS74RGl2fvMun2YkZ/B5MTp/PiraGLi7KUWSJpRB+w/Vp0IznyHhde5jtNhbM6ekXpIcTJg9CM7jjzg2aSeAyguXhweb9+Jg9JOlrBVVNjKsO6/OSrMtdkKSueqH4o78AfjebelaS8A1PddMPFXfxcgFaQPtheJrMExRJoM2bmuXzkZt7AxFrz8WVls8cI/ttiMxGgavE2tEYmagjSi464Nmm/+ybfOFe27lUQY8V5V/mlHTsqS7agRmae/pClYMi1nV08Co/OONS1WzqVbKWzFY7QRoYCtVzGegYzfOvt+zc2kjI9C5jCMR3yPuRCrxIrvfq9PcFOmix+e4BLqGE9CABwFlSqbo77zgF1OC53sGfZ28NkKbwxgWZxwjRzNqrdKEFpA55Mx2VB1Eq58zlMD8I8mUVABj4BhkpwmABTAD2VTKqqZLwB04maTXjGq+ViLkt6eEVKabin2vCzA+/0+pAGP8JThLtCVSdjkmcYlrDGBWS6OIihtIHWdrTva6HYPjK1immdUSSMWgqgKHQBY7Y/aLzZd03dcoLcTMLQBTduSbqZk2JyE0paM7x3uG/HpKHBrGPJt3GQuw6ZQET66BIxkgN4PcLrwT0xUgB99QokGnFbIOOW5icOAl/W77c7EeG4UKkfQu8f9fnwTSwb2zUNRGVw7IichbkqLu8VCP2TM3zRBXy8BicOEVtysAVfpehW1ARZHVEHlBDHoHz1TX8h9wgS2gNjtf0uVQaqVtaeqINJ/8Pm7cla9qR+ufnSEN4NrqVJD9+3Lz14ZY2JUyllsHrbyAjc4rAGQwW9PpiycUXPy5JVJM9kYvZaRhBHFSF9yD4a+UtSDBFQyjXld1U
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--=-wgLUfkqFCbNdgB5koHEh
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2026-10-01 at 11:17 -0300, Jason Gunthorpe wrote:
> On Thu, Oct 01, 2026 at 02:07:40PM +0100, David Woodhouse wrote:
> > The *consumers* of this memory provider API will include KVM/guestmemfd
> > and IOMMUFD. The latter *might* be through masquerading as dmabuf, or
> > IOMMUFD might treat memory providers as a first class citizen and be
> > taught to consume them directly.
>=20
> If we are reinventing a dmabuf improved for these use cases then lets
> just use it directly.


Yes, that's literally what my series is doing at the moment.

> It would be nice if it could handle MMIO and "cachable MMIO" as well.

As opposed to just MMIO vs. RAM as implemented in the prototype in
https://git.infradead.org/?p=3Dusers/dwmw2/linux.git;a=3Dcommitdiff;h=3Da7c=
a2d8859036 ?

I think Fred has a cleaner version of that about ready to post as the
next version of my series.

--=-wgLUfkqFCbNdgB5koHEh
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
jgfJ6qKeRjOY746ailEcz4sAAAAAAAA=


--=-wgLUfkqFCbNdgB5koHEh--

