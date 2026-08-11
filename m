Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DC38C5AC67
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 23:51:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B51BE6B0092; Tue, 11 Aug 2026 19:51:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B285E6B0093; Tue, 11 Aug 2026 19:51:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3E9D6B0095; Tue, 11 Aug 2026 19:51:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6E2F66B0092
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 19:51:04 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6E873A022A
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 23:51:02 +0000 (UTC)
X-FDA: 85090636764.15.BEE5772
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf26.hostedemail.com (Postfix) with ESMTP id E7CE4140009
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 23:50:59 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=W4riWIHV;
	spf=none (imf26.hostedemail.com: domain of BATV+b6a5eba76e218a018a6a+8388+infradead.org+dwmw2@casper.srs.infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=BATV+b6a5eba76e218a018a6a+8388+infradead.org+dwmw2@casper.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786492260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X6z8WtcQ8fRb1sPFOhslEpIfiG2DhcUo5AcbjKY8Mto=;
	b=co0m5DWDn22iqaR1zLEXsroasAwpZN1OtaUIUNW2REc1GPVWOAIHy3C4cfkgST6hk+zXNE
	TXuZYkRsZ+KL0lp0hon4cYF2KejvZCyABMlRB1wG3U7qyOoQxPAMVH+QOcoI1vnHxVN9IE
	xqu7Z2sQzFaLCxkh4OXZGzJDNdG49E8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786492260;
	b=TAQoHqs8P6HoHoXR2V6ho5YLxQuDBHNnSQQplarvAyAflJHfT8GBfdpChpDM8JRmepV27p
	RueuWVYDe7ywNNxr5BidbIxrMTceKetOLy4fGK7U/OzVS7HnFB5JCMG1CgQb8x82YXTSno
	uFX2Us9WG1IeBkczTFnM7s7A/kLrUm0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=W4riWIHV;
	spf=none (imf26.hostedemail.com: domain of BATV+b6a5eba76e218a018a6a+8388+infradead.org+dwmw2@casper.srs.infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=BATV+b6a5eba76e218a018a6a+8388+infradead.org+dwmw2@casper.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=X6z8WtcQ8fRb1sPFOhslEpIfiG2DhcUo5AcbjKY8Mto=; b=W4riWIHVlWm2ZoE6rOjhMk2wx6
	LP/MTtuI/K464dDWegq9HibCorv3ga70sENvp5lJTWPDuxcYBNWlNQOUEYxY3eGuFqssISgHeG+Bb
	aOeJWADrrfI+sB48b/T1XSRzlWj7ysnlEich+Z+7G/Bkrs8UqmtusI+0rwEyuQ+wJX++fnxS5i8CB
	i9z8pfVTCAjovhdqlCuI3oRfYNqASkx0OFJVF5cCPUdUVWalVbu+ll123jgh/T28do2MVLPZynJrg
	rXzkgabL5ZKRAwdWDgVKsofw5fmlwWn9QYwkKpgkACkKvNOLazcuOsWw2dmZA6DEFwqh0Qq+HPMaR
	39Pa7Hjg==;
Received: from [2001:8b0:10b:5:e09:5b1f:c111:693d] (helo=u09cd745991455d.ant.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wtwFA-00000001A5d-3ZSe;
	Tue, 11 Aug 2026 23:50:53 +0000
Message-ID: <824a27d101d5b2e2a8a53fb81f5e4ecf15140a1f.camel@infradead.org>
Subject: Re: [PATCH] mm/mmu_notifier: Remove non_block_start/end() from
 notifier invocation
From: David Woodhouse <dwmw2@infradead.org>
To: Sean Christopherson <seanjc@google.com>, Fred Griffoul
	 <fgriffo@amazon.co.uk>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	akpm@linux-foundation.org, david@kernel.org, mhocko@suse.com,
 rostedt@goodmis.org, 	bigeasy@linutronix.de, simona.vetter@ffwll.ch,
 jglisse@redhat.com, 	christian.koenig@amd.com, paulmck@kernel.org,
 linux-mm@kvack.org, 	kvm@vger.kernel.org, linux-rt-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Date: Wed, 12 Aug 2026 00:50:47 +0100
In-Reply-To: <anuo_OxfvJbQnn71@google.com>
References: <20260811162423.GL544626@ziepe.ca>
	 <f33571137d2e3973e440d09c7602edaebe08b714.camel@infradead.org>
	 <20260811172627.GN544626@ziepe.ca>
	 <B25708F5-8425-4075-8D95-5E2A00C933DF@infradead.org>
	 <20260811181915.GO544626@ziepe.ca> <anuAq2s4mtyw4_Ql@google.com>
	 <CABgObfYR+vXBuSm3v5jbbZL8vF=XnocFAnjumdShgXBzod-HCQ@mail.gmail.com>
	 <27f2326dc66d6341174c0e510aa518a1297b66ae.camel@infradead.org>
	 <anuo_OxfvJbQnn71@google.com>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-PJmlfMzue/hQTdEXciz4"
User-Agent: Evolution 3.60.3-0ubuntu1~ppa9~24.04 
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Stat-Signature: yp8gp9fy5myadxqhqfsn1bpkcd331ojn
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E7CE4140009
X-HE-Tag: 1786492259-580294
X-HE-Meta: U2FsdGVkX1/43WE6LU2cn92YQpn5H79ABe02qY5Zd1Bv8WW7iY1E6C/lwd70Ldp1ixB4BzmXDQ1HWbeEm0eKlpSLGu+n9hv6ASpPnDQtQwWEclhtmXQdVTjotCVYfMnYH3B3Wn+I7lS0XjJhZG1TJyuBQIKolpIVVxt7iOpL4G3N3vdTdh6PqgIE4Y8BGzPRUal+QM0grq8Kv2jZmwtD98FomaaXaHjCT5/J2HWBo3UjT3cEv6JEAN0gOr9RvWMXwxO4NVhHPdL6WSi10HEE9EZA0NEUHMrUvTUJsgBrPv4xs4Yd+WVJ3WDC2h4Y3OMiESVY9nURFDs4z4sVdxQEeuxREvnMWWFMQs0uUq/ETFE7Ia2SZmgkpAgj9l7yz/7nE/tiMdHo67PIJab4pRTx1obVXgDMQVC5hoTcqD2GeNa6JM0Y/RN+0JWmMIC41sxqGWMDo698YhIUog76G13q1tds9aqQz3tSMpuEOHwJ2upi2np2ZkvyyPHTwWxq/RJvDEiT5ZFRuU5jnrjWakJ7yABzMb591ObpgVh7BlPdkcFEXPHbti5DHZE6kOIvcAiXrGMeM5VBjEy7izKK6OUWpiBXIlGS6gbUkS65EyHrSfsnEKgzkxer2FvCjOS75UwOrBwUdhgvkgoTbswH7EizMyrPAS1lAJpIViTcx2/XQLxGZepajHhvqJRPuUN+LuSG9ZfzcHEvZiJwG7u5PXeaxkQm7ODRcJrsSbzbvqlYBM7BFJ22vxOsik0d0I9DpCAykQWqepc34j01dpJj3UcS3BuYUGTHsAeSyyZUFu/SRTX9B/Gl68i3OKaUfjlnHnhXT+Zd8xSroefB4tBPBQOvbISVHCAhW529JNcE+ec2iHAQfVjPnuOGteigqmaRchuxLbEaqyQ36AcXqyF58Stf9NMXthZawTbAPmCmARUjuSBlf4pzg1CgRRdXixx2MncmXQSiXVDkl5cZ+LOJFJF
 o5qor4Vn
 85y1l8Yy9ona4aJECbPLjZezjrqVpZ1ab8jtUuMhvWhdAD7mF4e/OyAiHqgHNbhcfN0VKVKv2gMNc1XsVRjPhXxVTfYmckRsrY0zvIeR/10JTba9XaJoeZz96EyKZM0436bCPhhPAprCH9hlJchJiJM2BxsTZLIX65h3RJXxBfSSr60KtzyhQf76DZ/txHX+lkCH4ws6LSRSvEx3t7qSyfMyfMc8Uq0vTyBhKWeHPLKgPDpi9OK1S83y02s6ow1Drzl5vqI59Dixmr/2ijmRcVZlv5gQkuoQkCKxA5qwD8FhjS4rhdH4ZhLELUFKd+0Q4id83/V0AyvCSqTeEo7NqfdPtSIH5qRG+/RYlPMo5pk2cMynJ3HqJgUp+gqwZRjZsahp2qNh6qbeqsNbZvOuigL1yrYKrND/ulkhix1NYrWQz1mq/rdCF19NsXAPfwjDU8jQgSyzr35KVSjQKoXXUVXo7NPIUlRRlEiQoP6HHPvkf5DX5AymZ+5FTw4t80HaFKCIv1mlLS2otVBF+cziZ3oafvh118nFLtV3zTDO02t6gwIKxiBC7eU8Otul5ZovyxeyQ3DF57zmrvY+5pdBVzdon/2UesS9DjugYTsaPOmNSzAmXCa1qSGUpfKlylO5wNVUB/TPuzkNSP3tiaTyECZt8zbF6SUTsW/nuwlIojcvxGqehaSkJwHjzMHRlO5PWCJ7U8tTzsn+Vbvs1dueqh8ZJlTDGtuk5ZsajpeWVJbFD9XIjA9FoNgV8lHlpITZVNBXvflc+TTQadnN28Hl0rgScdrPlnnjiUzoTVsMAnNUdQQ8uFCREqPsdCoLWtdtJe+LW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--=-PJmlfMzue/hQTdEXciz4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2026-08-11 at 15:58 -0700, Sean Christopherson wrote:
> On Tue, Aug 11, 2026, David Woodhouse wrote:
> > On Tue, 2026-08-11 at 22:21 +0200, Paolo Bonzini wrote:
> > >=20
> > > for_each_present_cpu(cpu)
> > > =C2=A0=C2=A0=C2=A0 if (per_cpu(kvm_gpc_reader, cpu) =3D=3D gpc)
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 cpumask_set_cpu(cpu, gpc_r=
eaders);
> > > __kvm_kick_many_cpus(cpus, wait);
> >=20
> >=20
> > I'm literally sitting here watching you reinvent what SRCU already does=
.
>=20
> The problem, for me at least, is that SRCU does this and a _lot_ more.
>=20
> > Which, again, is *fine* given the behaviour of *these* read-side sectio=
ns.
>=20
> Well, yeah.=C2=A0 Why use a nailgun to put a nail into the wall to hang a=
 picture
> frame? (other than the indisputable fact that power tools are fun).=C2=A0

It's not a nailgun, it's a drill. And in this analogy, my observation
that it works absolutely fine for us with *these* SRCU read-side users
... is equivalent to finding the torque setting that lets you put it
into screwdriver mode.

Power tools *are* fun. But I try to avoid buying a new one when I
already have one that does the job correctly with care.


>  SRCU is
> fantastic infrastructure, but I genuinely think it's not the right fit he=
re,
> especially since we'll likely need a different solution for in-guest read=
ers
> anyways.

The cases where we have to hold the host physical address *during* the
time we enter guest mode to run a vCPU were never covered by the rwlock
either.

Fred's patches which reinstate that GUEST_USES_GPC mode are kicking the
vCPU from the invalidate_start handler, just as the original
implementation did. However the locking (or RCU) for the in-kernel
users ends up changing, I don't see the in-guest part changing.

Unless you're imagining some scheme which could handle both? But the
in-kernel readers are *brief* and will always go away on their own,
while the in-guest needs to be kicked; they are opposites.

> > I get it. RCU is a versatile tool, and in *some* cases the *Sleepable*
> > variant of RCU gets used in ways which would cause grace period latenci=
es
> > which are thoroughly unacceptable in an MMU notifier callback.
> >=20
> > But in the specific case of a dedicated kvm->gpc_srcu whose only
> > readers are tiny snippets of code that until today were always run with
> > rwlock_irqsave? That is *not* Jason's worst-case bugbear. It's fine.
>=20
> I agree it's more than likely fine for your use case, I'm not convinced i=
t'll be
> fine for use cases that heavily overcommit memory, or do NUMA balancing, =
or (close
> your eyes) enable KSM.
>=20
> E.g. it doesn't take all that much for even a single expedited sync to ge=
nerate
> a delay of 20ms.
> https://lore.kernel.org/all/20260309193059.2244645-1-seanjc@google.com

That looks to me like a pathological case where KVM is trying to use a
single srcu_struct in two different modes, and getting sad when they
conflict. That would never be the case for the separate gpc_srcu.

I've been playing with the soak tests, running in parallel with a load
of about 140, with KASAN/lockdep/etc enabled.

I also implemented that thing I suggested: a try_synchronize_srcu()
which doesn't even use the waitqueue when it can trivially determine
that it doesn't need to wait.

Even when we're stressing invalidation vs readers, it ends up taking
the fast path in about 99% of cases, taking around 4-16=C2=B5s for those;
32-128=C2=B5s when it does need to call srcu_synchronize_expedited().

It goes above 8ms in 4.4ppm of cases, with the p100 outlier being
17.6ms. My gut tells me we'd see those occasional outliers even with
the rwlock at this load, but I'm going to kick that test off and answer
that definitively in the morning.





--=-PJmlfMzue/hQTdEXciz4
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
Nhkj9foqGsfBdWPDPcxV5+gAAAAAAAA=


--=-PJmlfMzue/hQTdEXciz4--

