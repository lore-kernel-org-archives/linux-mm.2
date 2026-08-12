Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8BD9C5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 08:21:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3803D6B00C3; Wed, 12 Aug 2026 04:21:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 355AC6B00C5; Wed, 12 Aug 2026 04:21:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26BE16B00C6; Wed, 12 Aug 2026 04:21:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E3EE96B00C3
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 04:21:53 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 576F914031B
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 08:21:53 +0000 (UTC)
X-FDA: 85091924106.15.C27DC93
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf19.hostedemail.com (Postfix) with ESMTP id 91E771A0007
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 08:21:50 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=l0CAJctu;
	spf=none (imf19.hostedemail.com: domain of BATV+5bb66369c51ae59fd3c1+8389+infradead.org+dwmw2@casper.srs.infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=BATV+5bb66369c51ae59fd3c1+8389+infradead.org+dwmw2@casper.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786522911;
	b=NUWwSG7Wfxr7QfzU2QZr0cQjtAMA24qx+fNplDUkBxTIUwo4CBuvh7Pe6yT7yG/H3TyJAR
	nafPpUsNoP7/sHLs7CbnFXOu2/9coVslnsCrvkrnqq88Y/M0Disn3uaogMpf/m9/6vWRI3
	jM90f5gFWsuyQPMzFyFxd8biow6A6Pk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=l0CAJctu;
	spf=none (imf19.hostedemail.com: domain of BATV+5bb66369c51ae59fd3c1+8389+infradead.org+dwmw2@casper.srs.infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=BATV+5bb66369c51ae59fd3c1+8389+infradead.org+dwmw2@casper.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786522911;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yqsQWpue8B+DeLdaeK/eQIHORvq4af2g5lNUMfDd1YU=;
	b=jI9JwnqjdP3j9TLmVk7usA8WkZ5Xp9QLbkcoawGbu1+p/O3sP7sdfM4B/NZyjLfuufQpF8
	FKrESnhJRU2V8qpq5i7iQUfw1A8ygv7JSvWwAoRpdfe5NQAVPvqcR2PSq1nFra1S6rJWlu
	9kYxa9DiFOrOeO2TECQVOkde23OYahg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=yqsQWpue8B+DeLdaeK/eQIHORvq4af2g5lNUMfDd1YU=; b=l0CAJctuOB0yn9quwbmFXDYAfB
	f37VOzwtWsblKmfeAvXlTJPCISsYEI1/Oj+uLkkZdxZwAx8PZ92wgVRq/oXQV0Sn2+rki3UFnmOjr
	8dkV8pLczztgQNDnUD5q1gnjh/GNI4BL1Yp53y7fOA88JktLhWO/2be70t76wxXl9S1BMMi97NCeQ
	Jmjfoxh3GvbLIuI9KzXMbP7nrchA2OTXqB76BhzBKiDLsfDptimwMPzu2ZVtagyaGHukvk30vAO8a
	cti11HVRtrRFfqCp7YToEy+qamoivlx6KuG9acOyP6z2ZDjCUOdGafVQxTwek1nk07/QT5I6fDgr/
	/IIK55pQ==;
Received: from [2001:8b0:10b:5:a3a3:d97e:a004:df29] (helo=u09cd745991455d.ant.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wu4DS-00000001gj2-0vdX;
	Wed, 12 Aug 2026 08:21:38 +0000
Message-ID: <44c51ace9b0dc44b795f6f48c91cda440eed910b.camel@infradead.org>
Subject: Re: [PATCH] mm/mmu_notifier: Remove non_block_start/end() from
 notifier invocation
From: David Woodhouse <dwmw2@infradead.org>
To: Michal Hocko <mhocko@suse.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
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
Date: Wed, 12 Aug 2026 09:21:31 +0100
In-Reply-To: <anwraNIKJV8zwrNT@tiehlicka>
References: <a247c49dd61af1df7ddc4dcb1cccbcb36b04d9d5.camel@infradead.org>
	 <20260811135537.GC544626@ziepe.ca>
	 <1d669aca4ffee797b9c29215382444a5b23624b3.camel@infradead.org>
	 <20260811142730.GG544626@ziepe.ca>
	 <a552b227e18ddbb3fa1f2edf2d1cb30ee6ccff13.camel@infradead.org>
	 <20260811104229.72fdd928@gandalf.local.home>
	 <37b83b429b9f14ea6ad4ca1c13cc8e565ec09033.camel@infradead.org>
	 <anwraNIKJV8zwrNT@tiehlicka>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-v6PlrnGGcaejKBXWxyYj"
User-Agent: Evolution 3.60.3-0ubuntu1~ppa9~24.04 
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: 91E771A0007
X-Rspam-User: 
X-Stat-Signature: ffkw455ou9kkjgmzt1p4m18wwe5k5fo9
X-Rspamd-Server: rspam06
X-HE-Tag: 1786522910-759687
X-HE-Meta: U2FsdGVkX18zx+7up3gtdZC96yA2m/asjoobNuv+MBfE6CSKil6HjKpF9LvEsbBqFcNHfQ3XPTgXf/eAyt9tWIkSA5snK6VfwecH5ek7ER0oOOxlOpoErHQ1OuhD/HSwOa1EC/jNFcugfwi8f5d4dMc/dZ7WEuPR2s0FQizQWB9EBVfBoM93EqAiBIagT70BIxJWYRvUL68Fxx1wWje8JLDOn7B821AFKNl++SQiTkGKX75DJXdUDU+q0BkvNuctPsM/kferFJCY9z3G+xzNpj/ElLnpstjjxOAqnc7rinCynhzwY4hy/qWHD0xjzz7yQa2rDe8ksc6O70BxCnA0sVSek25b8rguGA6x3uToz54IYAJnWv8cCW7QbDl5XLmbqpsybqqH9sjpuTiP2A2huLyxKcUKd5iGNs0Y8xfbTR3Cgr1kXGWZlNauKGWU03BdIFb5UqEzUi0GPMP2WeWLx+PzIv1hRXd7euSRVStyKddFx1kWFgvQc2Vy1LE6665fKhtuB24DdRUZRU1Tm4X/rUlz2+lCLMZY9tWmpDtjEHgKIKg55FSp4RO4WKKH4gjjNwUn045DHjAQu3lOrcxCHo/rmSSDnjDiCfk3l1z2RJngNKcP8mcArFZ5ASUDL7CLIiJjrDKMQF1TY6thoqkumGg7g8qIhQ50JvMfJAUpf5O/UixOAvIoj+17FWQ+7UAssltZQh2zQnIE3kCVC6PrB8sEB2RBZOql1/vMYdSGjiaxADILmKWqyC5mQNWzOWCB9/OBPV4zzPZ4Q9ovOvb+Kmd1bALiyXIY9jkjvZMwW+NWPmds+Cmr6LRtImipbNVkhpIMTzJoh7A1vQgS+DX51dBT/7GS/L+V5DP6lDhXcb+kTJcyOta+TljBF1ElGWNvxf2jSAtMOcIPqrzxA8QfF8hgrWHpIPzFQ6EgWISS3XEe1d5TAXqnEmo8he15fn3QnP+bQvJOxZsFD7bwjIp
 qEWB2AUV
 g1MAfIBkzbsBzTKp+Ke7qyDFJQ2Zj8M6gMx4JNsruZti3y9byayVLOpTxQsMdwK4kw6/odqShKi1AV2Pz/fKLhYqPrJZuPSz0Gques5+aaoFe1NfJ5ve6gpr2j1oE2oLry8hiMk+biyI3jp3+dzgTMyekavj1oUPpuf5K05iEn0i0VuT7nkL5Umksc2FH72/sd2CDGhmWLfnuLd5U/ljztslxqTRVGMG/2zdTrZ6siVH+iS4cdWgbuEXkWHpztA3TsW4/9xvFQnspgPEAkG3F4CZIg0h6T7TrGR/5PPbQRBMZm9asTnuB31zdRPoC1ixsLs9w13ImEjC2wN2PNCRr0aS+PwdFn/MmFpOoO4vpZXUbxYszYZ8ecRAZhDNZG1/lhEfg0YD71nz6eFSrMxq4GRfydZOQuRdRBOYoJYg+M64dOoOlcPDhm0l3L+bHq/DR7CPbZHpeW5c95YQlJbEE2NjqZzTmNNbl4JWQBJobSNED3QQaZp5LXlYlDu+FDZpV0UGBGy2rDR7kwvw2yq+h+7RGrLRzlQqmz50T2gKS5Z9jq/hLtRj23sHdhZMTtAfof49lxKdbgpwv7VdMYUfeZZZ5a1j1jd9qnM6VLwuJHBQe6uzgrCT1wouXiSMpqnNs5821QPwibdZM2h/oeDoYezEvp69CwOltlu1vyBlZZVTP0IpKnvAKbvHHTflKxlN+AYeMdG0O4z0RXBf+F8xup6MActkJCBRSftsl8dXSKj6bK9cQrsUL9WLI0BiLrqWuvz+rdVY5oY5vWqyKR0UQ/TkRhEMMl2Iz/ICVUmj1lF7BcUlXc7d2YXcSdZQWOjlYpNN3R00vG4RxAVK0GOdRErwlDnEiIQdg53PIIobKjkBoMSc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--=-v6PlrnGGcaejKBXWxyYj
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2026-08-12 at 10:14 +0200, Michal Hocko wrote:
> On Tue 11-08-26 16:24:48, David Woodhouse wrote:
> [...]
> > I had a second reason for disabling the overzealous check too: to allow
> > SRCU grace periods within the notifier callbacks.
>=20
> Is there a way that srcu barrier could cause an indirect dependency on
> memory allocation? In other words what might block the scru to complete?

Not after https://lore.kernel.org/all/6eed3fe3461e9690b486ca98fa7563f60d394=
0ff.camel@infradead.org/


--=-v6PlrnGGcaejKBXWxyYj
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
EkqE5VYHSgr/oqQeSMk3JpsAAAAAAAA=


--=-v6PlrnGGcaejKBXWxyYj--

