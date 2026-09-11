Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDC5CC88E4D
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 10:28:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEFC66B0092; Fri, 11 Sep 2026 06:28:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC7026B0093; Fri, 11 Sep 2026 06:28:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDF976B0095; Fri, 11 Sep 2026 06:28:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9ADF66B0092
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 06:28:02 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 28ED0A3E6A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 10:28:02 +0000 (UTC)
X-FDA: 85201106004.19.737CB12
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf18.hostedemail.com (Postfix) with ESMTP id 41DCD1C0007
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 10:27:59 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=awBDxQON;
	spf=none (imf18.hostedemail.com: domain of BATV+01a8612c2d92d3fbdbce+8419+infradead.org+dwmw2@casper.srs.infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=BATV+01a8612c2d92d3fbdbce+8419+infradead.org+dwmw2@casper.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789122480;
	b=clWO2xPslhtAhA8EpJ1TDXtaOgkCYleWg3Oyi3QynSJpQgnFrvVeByYm+DXLxJ+EOyG//W
	RRbxWil1mu4x1iJ8PsOz/rQDRV6CBm9srtDP3qynumd/1k4pw7oL+HVpQQN685efiUIC+2
	dR7IRwFRBN+lCuLYtf6BPI7uLvSJMIA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=awBDxQON;
	spf=none (imf18.hostedemail.com: domain of BATV+01a8612c2d92d3fbdbce+8419+infradead.org+dwmw2@casper.srs.infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=BATV+01a8612c2d92d3fbdbce+8419+infradead.org+dwmw2@casper.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789122480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/uqwzRJTgHPHPNS19expObzWKV7+uMZqV0B7nMbLp50=;
	b=NXw+slNCUMZ8u16JeHOR3uROtm7ne2DtuIPZP/g9npXd4qPfcKjCVfiIJm82qU0FBeyB6s
	ktsmnmaOl92PINiY2K2KtUSxs+zZ7ZCn1dVUrT1iy9tRnTRc9dvDCOQJ6GeIY91SkD31v8
	M2uon60qhbWv3Miylz97mUOjyyqYThc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=/uqwzRJTgHPHPNS19expObzWKV7+uMZqV0B7nMbLp50=; b=awBDxQONGsVuBjfiZW9ON4mv6F
	LbIeWGC9Sa8HztQtmcFMntbWaM8gHVQdZ2/PUELcpbY9289SkCm+LC+n7tpPczl35MIgqI/b9Aa8H
	lXudemm+DWmpAjdkMH/HnmknMDPuq2+qwiPH+iUqZ3IfRbnz8Ae801grYNbOHSPigEO2GPvNs1K5q
	ZTVW9vJGR9UctsDszUr/nqI+DlO92es2lmPKQTmL4uw2urE/MuExs2nQ1507wG0kCCvuxI5VsRPY/
	fN/uGoRinATuRpjYVdFE7krDH7uB3bNBRdz/kvEcxcfpRhgSV2/ojiASCH3CgeApFOr5vGEZ4r231
	zls1gNMg==;
Received: from [2001:8b0:10b:5:a10:bfc:a858:f6d3] (helo=u09cd745991455d.ant.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x4yTv-0000000AyTl-08CV;
	Fri, 11 Sep 2026 10:27:43 +0000
Message-ID: <2f1316389d0555418b5793d4eaf7ff3e81d5fe94.camel@infradead.org>
Subject: Re: [RFC PATCH 0/3] liveupdate: Move to feature flags for LUO and
 memfd ABI compatibility
From: David Woodhouse <dwmw2@infradead.org>
To: Jason Gunthorpe <jgg@nvidia.com>, Sean Christopherson <seanjc@google.com>
Cc: David Matlack <dmatlack@google.com>, Logan Odell
 <loganodell@google.com>, 	arnd@arndb.de, pasha.tatashin@soleen.com,
 rppt@kernel.org, pratyush@kernel.org, 	graf@amazon.com,
 akpm@linux-foundation.org, pbonzini@redhat.com, maz@kernel.org, 
	oupton@kernel.org, bhelgaas@google.com, alex@shazbot.org,
 kevin.tian@intel.com, 	baolu.lu@linux.intel.com, joro@8bytes.org,
 will@kernel.org, robin.murphy@arm.com, 	linux-arch@vger.kernel.org,
 linux-kernel@vger.kernel.org, 	kexec@lists.infradead.org,
 linux-mm@kvack.org, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-pci@vger.kernel.org, iommu@lists.linux.dev
Date: Fri, 11 Sep 2026 11:27:12 +0100
In-Reply-To: <20260910225728.GB857650@nvidia.com>
References: <20260904160009.GV4157646@nvidia.com>
	 <aptFFYqcSiBdMLE8@google.com> <20260905012403.GX4157646@nvidia.com>
	 <aqIAtOoew-_6jw29@google.com> <20260910143448.GD3968357@nvidia.com>
	 <aqLOWkuVKccR-I7W@google.com> <20260910171210.GF3968357@nvidia.com>
	 <aqMgjXfTJ8u3n7Kj@google.com> <20260910221832.GH3968357@nvidia.com>
	 <aqMyXE-fD-UN6w5L@google.com> <20260910225728.GB857650@nvidia.com>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-VIsjdpm5lmlGU2eWiQEf"
User-Agent: Evolution 3.60.3-0ubuntu1~ppa10~24.04 
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 41DCD1C0007
X-Stat-Signature: 3yc8k8yogky9z5pydkzpm7fb93tbuyr6
X-HE-Tag: 1789122479-226272
X-HE-Meta: U2FsdGVkX1/Th6qMzcMq7GBw4mDduCO9tGEs5Sw0zqiF1tYYsNyO84W/CI4zBJ9rJcpJ9SIxvHKPbm18bpjxm5Ufi/QPAiPY9LUzDoQRsjX+8b7TjOUCDdHWYVquujOboy8bcR573rwH3aWgWZ0Ozb7UYmDvkPZZSnYeC/w/pZuigXgehU7dJp5c+dvHi0DySIRopAFcMxNF186wb8uorc5cIyVexNKXX7Ds+NaQ9YEqwgSFolqbTDbhhhB/F8uwzRf38Yq+mtrIUi8yRg6P6Y5ZEXeDi3QrbyLs7BQJWIoj0/PLmlU+3rGpb1iSPB6WKgSnNmEGr/MWfvdLm/VR4uA9rSw4lAt85dHeGErXCjqFEesxWciHcFYMMsjOzSJF3Bvsf/vmHsgA6L/IASkt3Dji5MCPWTK8/npqp6p1zbZACw8+yQea9Tgx/V9kvvIkhtji2AjqsFeGQURuPd5PugEEid8D3bEKjtSuOfBKuTozyrNkuVo/Cc1GEC8Cx93R9g8sLCGqC5qvyaRti6RYOAiEg/zcSuRqvAocVNvtI0RX+FpwW99aLchA7nAVOQYfTIY2Pzs2PEhq9YScOXY8FTiAB3CjTViTfBOolLzSH/t6Jb9vIHoygqCPpxM6QRXrqciVZW9N7uN0xMShKz44t0P4BfMCM3s8DSvTC6FseryfgRxxXy1YpxjJ+EwnHQ9+tUkA2VyHVy1YbUp8+3I1LmataoHdCkouQkrzrkyD3JUSh/E4KLfallbQxS6ym/9QpKtQh6tnIkj/2s3TA57h9wHRzULym3ZSQCb4fPbfMwWmDFpnixreutfgBhQ8ir7gpdU9oDBSuGbIVYSnNazxOu2Dp4I6YKniXK3lZHILGIB3isYZUWx+ewyb3bXdQyEr3VBzkmpc19/6KhH/dfP3vUeW7Lhu0GI2dJiJPhF9RVGsmjelPs2YlL2vGptx1V6OMDVgRe6V+OxxJD2mtWE
 wu6yCXfR
 M5JAGjYLj9/0Wq5eicAT7tT2fp95cFi7eyJsSezGRa9zBGEAA7DYadfAievMsAsnUBSeE+Hngzc3Di1bSjKKgyuZsLZ5xOC9vEKaRpvOkZ9hzCr7Feel6Pe93aTkn9CUXYu2CQZEWWwNkyox7OqNlBy55xauC8LQ7kQp4MG5JpXpdcpWQchUQQGNzYm3s6AcgWmoWUWbs+4IWaAxpertnHztIpPGABoPVeHtJ8qw1TKGLTRElSau5wuCl/PJeAzwp9r5F59y6GXmEG52rveNUEVwataOZr/qcj57S5fJLdu+r7UWYrS3I5vS30QULPWFxFTo9+BB8w6MFF5DBsJE961kmMEtx7tTkDPbSLIkI80UFltMwQS63M1G0YdmMXUsitnTP3ZBzKGoZQNqiMxrdVwRB2dryVZAkAEDqucOYAyVauPiAM/5uas1sG/mDyRonroSSndEzwenjOXLJYXcmqDjQ9OKRWxw9ML4wl+uSNE5bjovDSSAA8WVJgJWHUPeqmXzhmzj28J/G+HcXyfxr3ur26fD1d8uLkm0UnaRV4uaotDB4GClZbe8Cf6F6/YnIRCRBIrU0NpMTwCzpnS3BfV+g5rM146Q1WLprzP8BvkUDGGDV6M0TWlb4RY0P3s2v3qSsHKaIdCnHF3ytQlW2I0g/v+g+B5gmfOGEeoT5IrJvqfQhha4lE/8TY+wqAcubNQyLImouLxMUytYpLH2zAOe2HVAUrxBm4Q1v
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--=-VIsjdpm5lmlGU2eWiQEf
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2026-09-10 at 19:57 -0300, Jason Gunthorpe wrote:
> On Thu, Sep 10, 2026 at 03:42:36PM -0700, Sean Christopherson wrote:
> > On Thu, Sep 10, 2026, Jason Gunthorpe wrote:
> > > Sean's initial email was asking for strict never-break ABI compatabil=
ity
> > > rules on top, and that is what I've been reacting to.
> >=20
> > No, I was never asking for that.=C2=A0 I think we just have a different=
 interpretation
> > of ABI, or rather are talking about different pieces of ABI.
> >=20
> > I am still asking for never-break serialization format compatibility, i=
.e. the
> > more literal save/restore ABI.=C2=A0 I'm not asking for full backwards/=
forwards
> > compatibility across all kernels version, i.e. the higher level "kernel=
" ABI.
> >=20
> > To phrase things differently: I am a-ok if kernels are inherently incom=
patible
> > because they fundamentally operate differently and/or support different=
 features.
> > I am not ok if we end up with incompatible kernels because the save/res=
tore
> > interfaces and payloads are poorly designed, lack abstraction, etc.=C2=
=A0=20
>=20
> I can more agree with this, it is mostly what I thought we'd end up
> doing anyhow with version numbers and growing the structs not
> replacing them.
>=20
> So you still end up with a version label (string I guess?) because we
> can break it from time to time, just the version should have the
> feature mechanism layered under it? I'm fine with that

Seems reasonable. I'd note that downgrade support *is* important though.

So where possible, those new features which are inherently incompatible
should be opt-out. That way the admin can disable them when first
upgrading to a new kernel version, and enable them only in a
*subsequent* update, once that new kernel version has actually rolled
out successfully.

Again, it's OK if we sometimes can't manage that, but not if it happens
just because of poor design, as Sean said above.

The thing that *really* concerns me here though, is latency. When we
pause guests and kexec underneath them, every *millisecond* is
perceived as steal time. I worry that we're designing handover
protocols to look *pretty*, and not necessarily go *fast* enough.

I'd really love to see these patch series come in with benchmarks.



--=-VIsjdpm5lmlGU2eWiQEf
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
7LVegH1aoogU39HiVN3Dp10AAAAAAAA=


--=-VIsjdpm5lmlGU2eWiQEf--

