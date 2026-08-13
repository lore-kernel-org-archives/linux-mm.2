Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DAE6C5CFDB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 07:55:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 746466B01FF; Thu, 13 Aug 2026 03:55:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71DEF6B0200; Thu, 13 Aug 2026 03:55:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65AAF6B0201; Thu, 13 Aug 2026 03:55:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 391966B01FF
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 03:55:21 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 704A51405B2
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 07:55:04 +0000 (UTC)
X-FDA: 85095485328.26.A0D36DC
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf21.hostedemail.com (Postfix) with ESMTP id D02021C0003
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 07:55:01 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=g+efvutL;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf21.hostedemail.com: domain of BATV+dce20e51c50ea6bf637d+8390+infradead.org+dwmw2@casper.srs.infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=BATV+dce20e51c50ea6bf637d+8390+infradead.org+dwmw2@casper.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786607702;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WOgwzjyAadVx0ZDU+mKs3DNtLoxxj6BgXSurYWlX1As=;
	b=vLI1BLaEMz3bgSyCiXFq1y3b5a0xHCmvBzqkTETtqZsG4QGKhCInYh9uMkFm35d/hOVQnP
	rbdkgaS7wAtYqd2ioHddzB6gKwGRohrY2UEE3iEYah27Ssw2VAcmZkyV9yHtp+BgpBmWBR
	JvgOBJ7XFfa/GAOyIigqqkCSQphjmH8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=g+efvutL;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf21.hostedemail.com: domain of BATV+dce20e51c50ea6bf637d+8390+infradead.org+dwmw2@casper.srs.infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=BATV+dce20e51c50ea6bf637d+8390+infradead.org+dwmw2@casper.srs.infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786607702;
	b=Tmt5ac0IbaugANGgp1+MRbpfYpJUVAkN2a3FCDpvUCZgZ9AmugGjqboJMoSWPrqt6uhkG1
	XHN8pzFaBSnyxiPI7WyjLNROP8BW2O5LxjtWnU/X4B3bMOrlFh8a99T0Xp/zpiRghKggr8
	zfvPT60sNbaYDmjnUti2NLajs7ljduA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=WOgwzjyAadVx0ZDU+mKs3DNtLoxxj6BgXSurYWlX1As=; b=g+efvutLBu0Z11e+6rIY9KEaKd
	hcaX6pPaaLyx+Q0rd21wj62nYtFYOgvPEmMKU95ziw4bz7VlCAlFvQ7B2tmzAZBQLy8IwHI4KuU8j
	PmIsO9RIL2sErIylofvKfWuZRGFic3FOj31XE5RuxQghpB9ezwhSgU937khc4fotkzGzDhh83Koxq
	d6DpqLwSL056QB5q0RBAh0AFAgLiKzUcIACfqJoYiUbeliLSIjgngItMfeuSltqBhznuDKr0u5sGo
	Ptgnsx4XC4OAyeMp4pJRUejR2NCacszBXSwNfopgFX1MUouA24+NyEFQuFVgQtkv9cb2REP4RVLoE
	C6gcQSUQ==;
Received: from [2001:8b0:10b:5:9e94:e235:608c:ebeb] (helo=u09cd745991455d.ant.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wuQH6-00000003E9a-0Faw;
	Thu, 13 Aug 2026 07:54:52 +0000
Message-ID: <5f6a0669f319951462c2aae3a50d595983a42e4c.camel@infradead.org>
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
Date: Thu, 13 Aug 2026 08:54:44 +0100
In-Reply-To: <b736237c-64ee-4eb2-8201-5685a3853844@paulmck-laptop>
References: <44c51ace9b0dc44b795f6f48c91cda440eed910b.camel@infradead.org>
	 <20260812122759.GA662699@ziepe.ca>
	 <c41c52f02f033ea980d4b5f9b8239d5e9411a03c.camel@infradead.org>
	 <20260812134934.GC662699@ziepe.ca>
	 <a48e6e7063122b22a8083bb0792984a204f316e6.camel@infradead.org>
	 <fb87f673bf290cad133d113dbb0750a7752b9d30.camel@infradead.org>
	 <a94b75e8b9b1d2191f365c0f4275fd5082332df5.camel@infradead.org>
	 <d0692500893f303906fba1d7d596eb59a07a806a.camel@infradead.org>
	 <anydY25Cl78l1HfU@google.com>
	 <932DB129-1794-4855-A61E-F4C2B54B1EE6@infradead.org>
	 <b736237c-64ee-4eb2-8201-5685a3853844@paulmck-laptop>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-IX+4oJh5LTlmEhkCvzNP"
User-Agent: Evolution 3.60.3-0ubuntu1~ppa9~24.04 
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: D02021C0003
X-Stat-Signature: b386esj915ksogn8nam3gbckhmzpguq9
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786607701-691104
X-HE-Meta: U2FsdGVkX18npvhBUentv0FB3Qr6zokhxoCr/PZxKKx5NfqWDxZ0B4/VV51UkneW5HBIhAL2mpGqtWcvL8wPd7MPULDJ30oxB/PJyIOuYYAOdLRKn+hTDYG4RRuRBsO2os0ARRNcyNGzlZnfuDhCySSahE7lVYey0nPowlOusmu8QIO5qM7JpMUwvtyT1GHiOCPfJv+Pl9IWBz4E3DCxiPN21QJiqJTbUPUWZnaHgBXudkwid5gJUuQSNB8gtCDDN6VofFOIc17u+ebsbykmU3neH2UQ/P7zngZLczBESzAFEg+udcBj86A4VzqbCwBhN5yDmZhTDQOYH6g5zkZ8/8nRwCofw2Bwc54VclZ4PC0rQEj1bYfoLf1/Zc/WDjYVytdadMHsybBPwzQruy3mxayngMPByu9znEkPJCdWPaZ7+n6TGUwB8/6aTNnrkXecG/xk0+iQICwx3gtU4YAjY57aOrBQHw5vMZySuNboTBaTGyPLGqp0bavrGOX7m+ZRZLlxh0q575V+uQZuLsqcyfrRCU9w8UUE0X6gNZh++TTDvcXXVJEKbb1+jzYKjIICxXCCReWeG7DzmUitgW7Ptr9d0Br3mvnH68fa8FzH6mrzcoVvQEm3LxdUzq9JqI4RwMBQ5CWs2rwnqMvI3g2b3hrlRiXuzQQFn9qTeUbmGBDzOML5781HVyudjye85AjxVYv+Te9a0JZ/uxGwHf6m8CAxPr/+R0PDPktd07FlK7lcW/L1xTs/Mdk5LBqBpbckAvKnmynS3A/6PH/4W7hpXWHDeXnDw7VeAImW6BliYLHg2PZ6HQenVNVyjLVBrqfElH5uxu/HLP7StBHWfbpu7/JqvVHuKFuh3QbAYT1Oh9G/3FZEUP/IDXTIc+ttJD54aVgbjsmavEX5ywOrM8sKgymiPS/XGuHW7PDNGJSI/NdgmcT/wvH7FY9aUiYT4++zYC92rXeOY9Qs44xPJ4d
 AR4gAFpU
 7bWutr2Bfz+c9ieUgTmNff7kt6AngypcuBtNFcHpMqv+Xdn4n2ce5kOwqbbTsEr/B9o14dog/JajZcDgwYGWULKeYdFDJ5hn181mH6ytDAlllJsKKirNgHnXO2DBTXed78ZGvy39iKiz0lslqG30aAbe10d/uboRNtk1nRz06NBRs02BeUvHrfBNaQOZLACoaaX/TbpMTGVITmWApb77DTiTzIY71R1A4pwArAbZJiauhrL8Jsa27TFIqkpbS0Vo5DqKVkvA941AZpCkmkFY0sqfq0iW3RmkwKBEcE2VgND77Nk2eP4eRgRfqtGu/glGM8jpNyaAErB/DXl/+ebLbvBvaPf1i9DaG4eWzW16lwkPvsAj6obbIb5S1+PYnG3iq71VNMdwnszZkgyMPWcQf9ojGDG/m1luMzl2inHfgYN5lAhgZAjFG/QJN5onE+iMLALJvs8crz6ZQWX0yArPvI9PT3RmyDYZPxP/TVppzoZRaKh7ChoDtFL2OLmRPLSiBeznB0aHfgPTMbVnX5bhIBX4E/+Qi2mvQ1zog4MbTtQ8LpaiZ2YBO5WNbmNZL+O1u5ecvVDIkaC1ACpbwvmp311IhPAwM/UJrWGuw10qowCKEsjAZ6O75lStt1z6dtqNCI0FcBTnJoT/y1CZ7dLf3Ey57AtUV7kUwKyR99v7sFRI3g7bhjtKyj7fhnC0evdRD+p2p2cM2Owb2yaF+tuW2gaveOD4eL8F5Aa/B0vUttyEM/TOdrbWxxz5sNVrHtQ9/Ae6ZpEra14Rp8rv7Z8QOhUHVkSXslx0P+vBiieEPEurtA9kS+lDkhk8xYh2GCdkcK+/j8B4E6vvsP52mdOErHWcC18xOqVzhBlKa6GvJQs4rU//yqLcr71Kih5ihuWiEMbOu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--=-IX+4oJh5LTlmEhkCvzNP
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2026-08-12 at 14:38 -0700, Paul E. McKenney wrote:
> If not, please let me know, and I will put together that does the
> job.

If you're working on that, I assume it'd need the readers to be known-
atomic. So if any of the read-side SRCU_READ_FLAVOR_ATOMIC thing I
already threw together is useful, you can find it in my tree at
https://git.infradead.org/?p=3Dusers/dwmw2/linux.git;a=3Dshortlog;h=3Drefs/=
heads/srcu-atomic

Slightly orthogonally, what do you think of making
synchronize_srcu{_expedited,}() attempt try_synchronize_srcu() first
for an early return?

--=-IX+4oJh5LTlmEhkCvzNP
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
NDA5NlNIQTM4NDIwMjRDQTEuY3J0MA0GCSqGSIb3DQEBCwUAA4ICAQChxpuuHVw93mze9jmueUFV
BJNzvOzZlazrt0AiW1H7TlYQutgKVXPNSEyz8s4k+WsRSjjlQMOiZerfwPEV6lo9336I0uNd+ffc
Rf8gbjiPTiVT+gX9GD1V5AguRgtsJn/H3A6M0dlzhI3J1jsOG9/+xPloHPzy7sPn5rNkntB/VTnv
Bix4IfUy3ScOu2vnLX0gnwP3EknfdEUvq9+kdkEEBDz7dGqQo3EuhXZoW9CHF2GM0sOpO/cuNQh2
JzA+to3smTES7sJXYuRrt5GomCRYvtIrRiYGMalFp+z6Jw/843lEIIpNNvpWVfx5Mbawkl+wWG8k
0IK3rF7FtbNa0it8/s288G/AEHvfsDIQYFmRLlo2LNMxxREkZO/1Qq8GHUsX/602Fi0u88I3uh5w
bOEIeG32NzBKTKBOjdjpiUrdCA676dyaIFt967CUtnUvFti8bqGA2pe/u7pjIANthqMBAlcnY5B6
ff2mbdD8BBLItgb4HyUOCVawzy1hc+UR2tglySwYroWeohfoG6afjesGigsl2JmnhaZ9Z0vanF74
vFEOOmuaq7VamuLEPFQtJM4olmipOW6CzrLcFz6J/6yAecEG3P1ZDoy08eSHvM40MAUgpwGa/w6o
9ALHQXda/c4TJvAylfHQ6wqArzAuV1pfWldwy7IOBMtKqzQBXQ4dSDGCBCAwggQcAgEBMHYwYjEL
MAkGA1UEBhMCVVMxFzAVBgNVBAoTDkRpZ2lDZXJ0LCBJbmMuMTowOAYDVQQDEzFEaWdpQ2VydCBB
c3N1cmVkIEcyIFNNSU1FIFJTQTQwOTYgU0hBMzg0IDIwMjQgQ0ExAhADNSi2uzJskfEdOMo4hV0g
MA0GCWCGSAFlAwQCAQUAoIIBezAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJ
BTEPFw0yNjA4MTMwNzU0NDRaMC8GCSqGSIb3DQEJBDEiBCDtJuTHvT2Zc/J6Gm21HYHItsVMesLu
3n8JRdy8t3O3bjCBhQYJKwYBBAGCNxAEMXgwdjBiMQswCQYDVQQGEwJVUzEXMBUGA1UEChMORGln
aUNlcnQsIEluYy4xOjA4BgNVBAMTMURpZ2lDZXJ0IEFzc3VyZWQgRzIgU01JTUUgUlNBNDA5NiBT
SEEzODQgMjAyNCBDQTECEAM1KLa7MmyR8R04yjiFXSAwgYcGCyqGSIb3DQEJEAILMXigdjBiMQsw
CQYDVQQGEwJVUzEXMBUGA1UEChMORGlnaUNlcnQsIEluYy4xOjA4BgNVBAMTMURpZ2lDZXJ0IEFz
c3VyZWQgRzIgU01JTUUgUlNBNDA5NiBTSEEzODQgMjAyNCBDQTECEAM1KLa7MmyR8R04yjiFXSAw
DQYJKoZIhvcNAQEBBQAEggIA2amh8d05CJFBa+oefkoAlTCzSV97JJVC3odXjBXqX1tQrF6TezsI
ln11pE2LiudcgaYXhRj++EiXkEGqgCRwIka8VRisRNfJaJqVILBuMW4DZPFWSmEDjLjgd40OOuvK
8jbULZuL9OZ/Q2QjJvZMlKRQbNs1x2Jnsw8bpYS7m4hQdCjpe+NRh7zniOySPc4ZZpHxDd4uehra
ISTHXQLyu17WcwJC+PRoaQSharph3BSjPIe8np0++AD7IlBAWebAltfvW6Mldvgjd6fxhpze87Al
AypGSgK82TlPHr8L3katnJWd7fl5uLUof3HeoBPjFUIdKLQcQdLGoKt2fcsBZMEcJZ8lTMlGYoiY
sImjE5sItA2LjzGNsT19KPvc3DaQ+LvA9KSpuDCl2UNiNAty9F3ywixMZtLGyi90SUkAw90MNaYW
mWs6YViDfSkqBfZpBgpa7O/Tju41ZFu8AGuL9kVV/wPoTYaMbd/iRLNp6zdBodXm7Uo+y6D4qjGx
xPXtRUz5fG+hCQDMc3juRhvbM7tUFSArf7LJl7U28LhWeFmDIhlHK0HjIMsHWDUyYUdBRYg4f6Xf
M7OOdZRMGZc8EoV0qbaQ1GC/Bliq4w0lluQ/dIdFo0VqZ/m9rMJVFNlFjIibxloapsxpYT+stKP7
YnYMhjeVkakI0g+6uHd4F6YAAAAAAAA=


--=-IX+4oJh5LTlmEhkCvzNP--

