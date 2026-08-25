Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D823AC61DBD
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 17:06:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C19A66B0088; Tue, 25 Aug 2026 13:06:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF1136B008A; Tue, 25 Aug 2026 13:06:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2DB16B008C; Tue, 25 Aug 2026 13:06:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 857196B0088
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:06:18 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CD13912011A
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 17:06:17 +0000 (UTC)
X-FDA: 85140419994.23.70CC8FE
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf11.hostedemail.com (Postfix) with ESMTP id BE00F4000B
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 17:06:14 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ps2aNbDX;
	spf=none (imf11.hostedemail.com: domain of BATV+cac146c21b70fe15126d+8402+infradead.org+dwmw2@casper.srs.infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=BATV+cac146c21b70fe15126d+8402+infradead.org+dwmw2@casper.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787677576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UL8vgL8HowsGABI/g9ih3hUelJdS+/CWcso0YubRxOE=;
	b=KW6kW3S6HFKMQ7/YGWQOCiVIXopd3fNfJBSNEMaJcLEQ/mFpHJQAJ2eIQZMLnAa+l9Hxk6
	6Glwnr3OBuZ4bRK9yB0xV9z3V0FeZNKOa9+rPI5tHCfMPKDAYGjwf4prKN5FWtIO1f2jPE
	eG9V7H5YX/KwswY4wCZJ6giSjg71nUc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787677576;
	b=ExSYxHcYiD0/K2dIOwPS5zr1sILeUZnejJsNyUCr1QrwVEoJIWTcIl333e1QYMzzYtxIIZ
	aZa2HN8NFaNnFxqsvGSFJFjEytD4Du0kTY1aCqhoAlYgPx5pQr7pTY9IJgBUuqrfBFJ6I+
	CAemNVdIuo9rpcgLACWOfeofqWUEwSI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ps2aNbDX;
	spf=none (imf11.hostedemail.com: domain of BATV+cac146c21b70fe15126d+8402+infradead.org+dwmw2@casper.srs.infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=BATV+cac146c21b70fe15126d+8402+infradead.org+dwmw2@casper.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=UL8vgL8HowsGABI/g9ih3hUelJdS+/CWcso0YubRxOE=; b=ps2aNbDXHsXJMb273wBPNgUQK0
	saJSoDwk54DZ7exlviNcWg9KUN1I3sMmFHUlIF2j66HMUcyrvcgsK8fOrrv25EVoNOhsyJDGBdn7P
	g45Pw2Rbp1so1DbQFDkaZdYO6hEfbxcy8qribxy21pJmbdXiN5S1A9heEIc3pA/CKIJBJ/oqHfjNa
	qsBLZ+LqZ/NphE61zckmM1mRC3V3lBOVcLHefMnHV2fSL2y1C7o7Ujr/ecSNbpZQ8ZNfoZoIm1/rG
	J7F79x70IctsPujDH+bmHCXddrbbu80+1shVI4V8y/fOXYpxVLq2tqmWSUaeynrgXUjJ4t94Z7Ky2
	B4SWr7Vw==;
Received: from [2001:8b0:10b:5:faaa:2547:1b33:7d6f] (helo=u09cd745991455d.ant.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wyub6-00000009Qyg-2jcE;
	Tue, 25 Aug 2026 17:06:04 +0000
Message-ID: <124af87fb49c267eeb26b8b4d952b9b1a5b3fb68.camel@infradead.org>
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
 <clrkwllms@kernel.org>, Simona Vetter <simona.vetter@ffwll.ch>, Jerome
 Glisse <jglisse@redhat.com>,  Christian Koenig <christian.koenig@amd.com>,
 Paolo Bonzini <pbonzini@redhat.com>, linux-mm@kvack.org, 
	kvm@vger.kernel.org, linux-rt-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Date: Tue, 25 Aug 2026 18:05:54 +0100
In-Reply-To: <69567965-48fd-48c5-abb6-0699d7f5bd16@paulmck-laptop>
References: <333c4cdb-8f34-4e3f-a47f-961f47e089a0@paulmck-laptop>
	 <11dcf5a87125451897982f728c1f65a5151987e4.camel@infradead.org>
	 <69567965-48fd-48c5-abb6-0699d7f5bd16@paulmck-laptop>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-ihPDX9ElNbuDCnwxsKpA"
User-Agent: Evolution 3.60.3-0ubuntu1~ppa9~24.04 
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BE00F4000B
X-Stat-Signature: feuypxu3gkkg8ec69g3uk8ou7rss5guy
X-HE-Tag: 1787677574-772907
X-HE-Meta: U2FsdGVkX18vkUFozzncDHkwzxZ11BHf0rviZiVPiP8EBMvdSWUNL0wy8ic+LiVhwUaZJZNAP+KjCVOiVE6FD5lm5t4BbtkchZETD0TUoXBjApHGGrvy7QkowFUgNKQNtZQZv2pTbf0CES3laB1nkn5PSfMW/aMYleIo2NO62Ri9nObJNc3KddQJOYKykbK6Ov9Dx1ufk6Z+wV/LxEPmXbgzX9lcE1q8stj8t7xWTYLIw98wFuI4frBT5fdpbtP0DzBOQdbyN02seuBLhPp2MVbpxoDlRzF3SliliRIrsqATLqK2fbpXU5n+Pes9BbZLX0i/Vd6yvqSaJMRoGZW8dzs1PRBYMC1IA0awAUyL6zAAJ1llMsbKPijsqcypbHFZKHYYmSHIFtDdk/QiNE9Ae6+Sq7XhoyH04t7LPRn90KejPkKMh2qZHTx5+ifq06aYHtLKfzdBFaRAoEj9c0EUDdfFpuCuu1Ns07d0la0HT6o2yJ9bNF9ivvIh9xWrZGHCFzLEuayJNwF2LjhhHtMXDIXDOZ7cfex7rT/mi+F8wiBSy5Vjmivb360rEB6w/AtoBb5OdaCr1UJo367sJOO8+cTwcto9xZqxAgVgCxQZg6H7VOqY3kEzZjuNX7S2xVAB8S27opYllonnUlZi3jKiWQ47We12Y31lMmsVrwlI2R6R7KZfAPoAMtK8p6L8Ya6Qqxgt02C8kzy6kGGncn/OBhgeqfVlwjfKAfvJkldM5ODD4kG45FxpIuKcQurIuWMDeOjJby47OjSjCCtzfmrLzBRNSsxpycYJwEAuMa0DdOp7FtMm6O/IbJJBfKn5weK6tLmVQBNK8zz+PYSg8o6ZChThO4XiTthktq/bysHg1jgU8H37FQD30jmm1wO90OUMpWFr1+doTo8skw1FtyjDLcE8vfs3KCfsI3zZNtIMPzxyHFqs/ZBsqqru2bXlxm/b5A8upOWB3FniNI7doMA
 TTc2gpVM
 Y7xt5p8SEXAeFvr8Yn+loL/M7JaMaUMy6P7YLklOLuRJwonWv+ERW5Qz5hHWEQAWL5agODx7DhD14WSiC9kg89LM/Az4FP3xlJWCAnHKzZxoENOPYyu7kwFP4n72Hq3DytwRG4fLGRb9cKDzeM2t4oJXye6yL2AZKNvrCsYl1MmZawHF480Kz+FmVCKQPpXqs89l4FXVEnnQ2FZxOEiliFFgH5s1l69lenFKOPZooED/xMhFMdTCcMRZF4U8SeF+40y0Hyv/Pm8PFbgqFxtPOJTUHtm23KBt7GvlTwvuvH8iobTfKyCAkhk1ys8pJEtr89Zne8TuYQWS+P6lohayXgoJyfuGCfd/WQsqVprYw1g90pTYUpKGz9cJmxL5tvALuGBB/R88bkuRo+OHmxjoXYjDnfAkevp3x3rNYAcaS+KoIq8pastpwvcML5nGerqfSFSSjl2rpNKE92CmUzJQaFnWVSiueFh2ospiAzuUDJ4VMPOL9oXYvkfXhQH+5zrG6s7SFV8dKrK+9vlVkinRexjjkEYHfBGVAMxza51h4iUuA9z7375XRN7vYwdwOemedmygEw2kqzq1o1Bj3T49kHSmzT+FFmX/46ZmbhcSqzspZzVQSBvihX8jdSPyKXt1prfy2AYrm4/fX8tintm9Bq0gC+RDRxZQw12zhccenPCmRUqK+fJqf6RARKpOLVV/JntCLEUtFlO+9ML0UVWiqCNsaeSkHxw3E36AGoXJMjYpGcS3HdWte30bNmdS//7PI4bIrYYsrsPVKjTbsQZ8DTV+JodRZQ9vPqIAHEEqkCJHcnsg69WVlCC72whQ48Qtpqo98QRJwWBxUpp8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--=-ihPDX9ElNbuDCnwxsKpA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2026-08-25 at 09:47 -0700, Paul E. McKenney wrote:
>=20
> On the tail latencies...
>=20
> The easiest way to reduce them is to require that preemption be disabled
> across srcu_read_lock_atomic()/srcu_read_unlock_atomic() regions and
> across all calls to synchronize_srcu_atomic().=C2=A0 Without that, the pr=
oblem
> is that the scheduler does not know that the spinning is pointless,
> and we cannot use the blocking primitives that we could otherwise use
> to tell it what is going on.
>=20
> So, is it feasible to simply require preemption be disabled as called
> out above?

I'd experimented with disabling it around the GP driver loop in
synchronize_srcu_atomic() as seen in
https://git.infradead.org/?p=3Dusers/dwmw2/linux.git;a=3Dcommitdiff;h=3D071=
65e79340e
and that didn't seem to change anything (which seems reasonable, as
it's the *waiters* that were descheduled, not the threads driving the
actual GP). So your suggestion that we do it around the whole function
certainly makes sense too. I'll test it.

I do wonder if we're really doing the right thing here by selfishly
blocking preemption because we want a specific tail latency to remain
low in a contended system. Maybe we should allow preemption and trust
that the right thing will happen? Maybe the p100 isn't the right
benchmark to be chasing... I'm looking at it because Sean expressed
concerns about it, but it's not the only consideration.

I'll have another look, but right now I'm in the middle of rebasing
onto kvm/next and the whole nested story has fallen apart and I don't
know (yet) what broke... :)


--=-ihPDX9ElNbuDCnwxsKpA
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
YoVxpQpfPm0+KF5OrT7K7+wAAAAAAAA=


--=-ihPDX9ElNbuDCnwxsKpA--

