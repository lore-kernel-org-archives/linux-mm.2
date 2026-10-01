Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B72DCA5FCB
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 13:08:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2519E6B0088; Thu,  1 Oct 2026 09:08:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DCAB6B008A; Thu,  1 Oct 2026 09:08:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A4546B008C; Thu,  1 Oct 2026 09:08:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D38006B0088
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 09:08:15 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 45DE2C0404
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 13:08:15 +0000 (UTC)
X-FDA: 85274085750.01.9EEBD86
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf13.hostedemail.com (Postfix) with ESMTP id A686C20007
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 13:08:12 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=nUPlma9X;
	spf=none (imf13.hostedemail.com: domain of BATV+b225c3dd680a63b396be+8439+infradead.org+dwmw2@casper.srs.infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=BATV+b225c3dd680a63b396be+8439+infradead.org+dwmw2@casper.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790860093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NQbZZznD2FdL+dsSLxIV1m7QSEEUiXKj9hpXUNyjtqs=;
	b=QizDulXaS0vW/tHLm+PX3++ok1fmyJ729seXcsatY/7/SpmOaVz8Hj8O28s3pICD8bvf8I
	W0jE8hsCvlzttPgUmgfoHaKgBWGIzVgk8YeZe87UUINCbKJcROzMQyNM2q/gQpXRabZWuA
	d05oFKgc4Anq0W7j61OHSaJzLxI/H98=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=nUPlma9X;
	spf=none (imf13.hostedemail.com: domain of BATV+b225c3dd680a63b396be+8439+infradead.org+dwmw2@casper.srs.infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=BATV+b225c3dd680a63b396be+8439+infradead.org+dwmw2@casper.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790860093;
	b=Lp89MfbOSDLRr7vizD7s8NRnczEAKdFbGn29u6dVLzW6ys03ZRv9mXXzbqjqmwRZXpE5jd
	SX/E4amVZhgaCFpqbtSl8hCF67hrS9rbI9vrua5coiXhSIl7agy4eh7VcXdWA+V3Rl+aJd
	nkOnqPf5yxc5iRVoMlwb2OBsU7VutV4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=NQbZZznD2FdL+dsSLxIV1m7QSEEUiXKj9hpXUNyjtqs=; b=nUPlma9XuLsAC5/fvmFRVmRSKF
	eXkcRVUYB1R6vII5bc84ncJFKD258tg9X4/97v8y/S0GYi0PMffs4uCoGYH6vbTxacUTPpy5MEOML
	25If5oKvkstbG7QJG1xLeiGfjA+wNL0d4Wp7Wi6AqKNBlPKdRURD7OtcaltOlJ4oWNC9WjHJ2VryL
	793R9x1CqVLVlXQDefC+PgTgCCL6gj9JL/RaL7yvukpdmEKtglkESI7vegayygsJ6xpAkJd8VaMh8
	9RFSLeSORd1Q/uFn8wDO6SXl+x4qC1109VbJ2dfjWGdVFsibGTEJ2/enXPzV3PsHgAwdWGYvs1b7u
	uEe+sXGQ==;
Received: from 54-240-197-228.amazon.com ([54.240.197.228] helo=edge-m3-r3-161.e-iad51.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xCGVi-00000007YSm-1Ylt;
	Thu, 01 Oct 2026 13:07:42 +0000
Message-ID: <9292b27b8f48c515bee3246cf3b3a60762302186.camel@infradead.org>
Subject: Re: [PATCH RFC 01/17] mm: shmem: Implement guest_memfd provider
 operations for tmpfs
From: David Woodhouse <dwmw2@infradead.org>
To: ackerleytng@google.com, Hugh Dickins <hughd@google.com>, Baolin Wang	
 <baolin.wang@linux.alibaba.com>, Andrew Morton <akpm@linux-foundation.org>,
  Sean Christopherson	 <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, David Hildenbrand	 <david@kernel.org>, Jonathan
 Corbet <corbet@lwn.net>, Shuah Khan	 <skhan@linuxfoundation.org>, Randy
 Dunlap <rdunlap@infradead.org>, Shuah Khan	 <shuah@kernel.org>,
 vannapurve@google.com, erdemaktas@google.com, 	jxgao@google.com,
 rientjes@google.com, fvdl@google.com, jthoughton@google.com, 
	tarunsahu@google.com, pratyush@kernel.org, fuad.tabba@linux.dev, Gregory
 Price	 <gourry@gourry.net>, yan.y.zhao@intel.com, michael.roth@amd.com, 
	suzuki.poulose@arm.com, Christian Brauner <brauner@kernel.org>, Jason
 Gunthorpe	 <jgg@ziepe.ca>, Nicolin Chen <nicolinc@nvidia.com>, Xu Yilun	
 <yilun.xu@linux.intel.com>, aik@amd.com, aneesh.kumar@kernel.org, Vlastimil
 Babka	 <vbabka@kernel.org>, Fred Griffoul <fgriffo@amazon.co.uk>, Connor
 Williamson	 <connordw@amazon.com>
Cc: kernel-team@android.com, kernel-team@meta.com,
 linux-kernel@vger.kernel.org, 	linux-mm@kvack.org, kvm@vger.kernel.org,
 linux-doc@vger.kernel.org, 	linux-kselftest@vger.kernel.org
Date: Thu, 01 Oct 2026 14:07:40 +0100
In-Reply-To: <20260925-gmem-tmpfs-backend-v1-1-d36159822d18@google.com>
References: <20260925-gmem-tmpfs-backend-v1-0-d36159822d18@google.com>
	 <20260925-gmem-tmpfs-backend-v1-1-d36159822d18@google.com>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-s3MK8W8btbMwTiyek4QL"
User-Agent: Evolution 3.62.0-0ubuntu1~ppa1~24.04 
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A686C20007
X-Rspam-User: 
X-Stat-Signature: w8175eqbxengfpchykw9iy4o7y9np93f
X-HE-Tag: 1790860092-50960
X-HE-Meta: U2FsdGVkX19HdYORo6QDXXKej+ap0c3tlHKyjXSveNi2MZrDVPsaHjWITb5I6ior3dk8+RPvzF01EIo7GSZMygcHu4TN0dx76D/tHHmbjky6UC2Ldb/bH5r/SaPgooqthBH3dsqrvYSYV6tAn+6X9ULzReiM3Q35v1Lsg7yaK4xOFH708tr3kdPns3Na/KL5OnlHT8xmmc6tKMAQbOHt1i6Ao5XSlQKRp4X2Pugs+crugQ6qh7Z6afLsEQJet4yb0FxA7p//HZkMeniJ7cZ+NjfNQ2OnvMnbrThNd3LvOKUvKS9HZf0kufDXoX4xPpfcqFNDeg+tN1qg80NkEKX4NFX/p46W2i3HXHo5CA1vJWo7RBu8U2SmA0nnY52eQTW+nAxm/x7eJIVQKs0GE1bAGjyFSdWey1d2WJcH0BIVjBmicXSzkUoqj8Or2i/OWcz+iu5tdqYYDLJ+WZNHhkyqsOB9lMFL6eH+x1UZC/3Mc3J7BxfpyrbmOTXWqz3NdkCyJbuGbELJo9aaE8aAHkDxIQq/b6QBMH3fwU5fohNb99UU8AoeSjFbxkLkpzU1pui79rWRGq3HEHZt0uZdyE7ChNpidvYZoEoUE1x3eTwI8wUI4p2Fdj4cMUTnPgz+PgqBnytkqWfWXF3OTUMQ99VIq8kxJu3qyxRiJwocfLxgB7iLXBeWaDLUIQ1fQ2FYpUJOOmqHE4oPAEJbTbOwLS9Kt4Mdch4xxm5IKKChufZAYXJExPOv3VepIaDiH6SF3KeWwhdorc402KEU+MIZDLqslFxVI+VKx8FIzPEK4JRKcr8eKlD7hRapoa0tvrNVbY+lBw64iA9fSgfNoREWNAFvZa+HajqZjy/PnS266nSHrKYo2DlP1mzMWgNgm+CEeV0GrEXdgaJnBudoCXPO86wgDrANYth57YCzlfjT57/HCKMHIXSduLo6laVUtzldm2R4/OZMm2W/IVEdsNtOgdJ
 3IoU3jYY
 nsU6A6rDgqxLXjQy3MY5ZWJFLWbDeltdZWvOKDUylAjfdmh8FMzdMwV+mOieYq5AGrnckhLkP/o7+biPUCoBlPUr4nNHLXFTvPLthreawGdzxduZpLgFNbbtxkZ68C6l2j93yfePtoom97HlivjcIjT/Jgz6uJ9iji5ZLnGUB9N/TTpQxD2UWBSTNKrrIOLinFsTZyR/HnEkv6wzzOiEjgF95T7hqE4lJz40o+ioZgoKx2xE+M1WqbP5WBmwF3OF9AZiXXJ4qTkrwmQfAvfKibydz/9cTNBOslxvEx7mp7NLG/pPxSiJd+ECiy1U9S2vyh74N1rqNPwzYsUC20aDotOIp4+VuODPB7lhWbrjW1ttGkFyLZOJyERlvsGBGNmmzmCtRtFH9Inxm8p7caAi5TQZZGLEgCFi1na/wUhagGgRwP5+iIcjBwXavum5sg7KoTb6XteM5wAiNV9GrQdsxHYl4FXWGUBahQIdaqP73IZKHYG2RrT9h3KzorqA0TytGPUxiyLFrYkOuKMIyqFR+bWypsucizevRc7nJRfNZ5HR2Z4xmp6t3nem83yzrrzRW4TN+6vbycEJXS04TmP5KuE9SZ6OLY6lVD31gCcnKXqrAZ21LbYYTKcjPJBYtzvRaXEwaciXU5sDrvhPiwZ7OelHHpMtNZT11PFXGA4fH895+yB41oh1M6tpHyDAX0vEIO/QRiFUo4Eo9RBZLRZhhvkgny7jd0Pds/yB9FXsTn3dcmrutMcjgG5YQutg3/Ags/lgPobfO0Dby+CzsYQJueopBzPH9HBsO4nwaoiF4MXPgOt5tYOFZxHDABEkBxWaygn0mdVckRsyrng+fKQcrxYZVxg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--=-s3MK8W8btbMwTiyek4QL
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2026-09-25 at 17:50 -0700, Ackerley Tng via B4 Relay wrote:
>=20
> @@ -130,6 +131,9 @@ struct super_operations {
> =C2=A0
> =C2=A0	/* Report a filesystem error */
> =C2=A0	void (*report_error)(const struct fserror_event *event);
> +#ifdef CONFIG_KVM_GUEST_MEMFD
> +	const struct guest_memfd_provider_operations *gmem_provider_ops;
> +#endif
> =C2=A0};
> =C2=A0
> =C2=A0struct super_block {

I think I'd prefer the memory provider ops *not* to explicitly mention
KVM or guest_memfd.=20

It is *just* a provider of memory. It manages its own address space,
and gives you the PFN (or folio, if you must) for a given range of its
address space on request. Perhaps with a 'nowait' flag to allow for
asynchronous operation (expecting its caller to try again without that
flag from a context where it *does* want to wait).

It will also want to manage *permissions* for that memory (read-only,
probably shared/private too?). And *revocation* when it wants a page
back.

The *consumers* of this memory provider API will include KVM/guestmemfd
and IOMMUFD. The latter *might* be through masquerading as dmabuf, or
IOMMUFD might treat memory providers as a first class citizen and be
taught to consume them directly.

But let's try to keep the interface, its implementations, and its
consumers cleanly separated.

--=-s3MK8W8btbMwTiyek4QL
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
51df9OWCP+h1s2JCUrfiMhkAAAAAAAA=


--=-s3MK8W8btbMwTiyek4QL--

