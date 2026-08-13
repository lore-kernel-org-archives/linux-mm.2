Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B3D6C5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 10:06:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71F476B024A; Thu, 13 Aug 2026 06:06:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F6B06B0251; Thu, 13 Aug 2026 06:06:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60D9F6B0253; Thu, 13 Aug 2026 06:06:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 379956B024A
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 06:06:18 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C4032A058E
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 10:06:17 +0000 (UTC)
X-FDA: 85095815994.17.28C4735
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf03.hostedemail.com (Postfix) with ESMTP id 358B720003
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 10:06:15 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=lYoeQgox;
	spf=none (imf03.hostedemail.com: domain of BATV+dce20e51c50ea6bf637d+8390+infradead.org+dwmw2@casper.srs.infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=BATV+dce20e51c50ea6bf637d+8390+infradead.org+dwmw2@casper.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786615575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2P8K0JgMNBWtXc57+p/ZgJ8iI2aes7ITu9MvY9vpDwc=;
	b=6GB58PeepU8bs+n+0IZFCId4znsDLy6/1pP8cX4jXLyLUm1ReP9HFJItWEVgi0WTU64PMj
	pdmTynFawlu7Z2zl+PF9R+OYYccyTHitbWGUKnQOC8koZfL5TrLHnBVi4TXz12aM5hBar+
	KOUSNsiLM3pF1y5YxtONEx4pc8bl740=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=lYoeQgox;
	spf=none (imf03.hostedemail.com: domain of BATV+dce20e51c50ea6bf637d+8390+infradead.org+dwmw2@casper.srs.infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=BATV+dce20e51c50ea6bf637d+8390+infradead.org+dwmw2@casper.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786615575;
	b=xZ8BqP87C+kgo1iJ73ESNiNj/wN1eqF/iSHwUajehmb4Wr8XJZ0Uwx9bZhwZ3wXn7VQF7Q
	RKA6u+e+3vL9nRwVPzAQvDd8KdvKC2UTNekL9AoV7sGS3hpOAu4kXJbTofi8tjr8zUx/c0
	WE5SEdDQ8lovz9FVJkRJHpYf9xaDYwI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=2P8K0JgMNBWtXc57+p/ZgJ8iI2aes7ITu9MvY9vpDwc=; b=lYoeQgoxMQigwx47UEVc6WIzz4
	4oU643SQexdZfiVUpykRAZ7MNcrVESCDDJcuQrDOGFfXkxI860fOLEG7n1pP4z+T3PMnVrbYyjQqk
	orepq91nz6X6fu304elvf5V6SCZUnHqkGGmn+r5sE/aFvZXcTrdnKR3hlAQXVweR2kuJIrx0WjoBr
	6vh9n/ayR75IORwnE1Ec9SdeUjKkZcaEEnhZhMNkCq/SCjtEWolUPWNHPmDqgGLB6bETdGoRrHp4O
	f7aoQfLTxknJ9t3iV1dA1D2uCIa9oFcpLCaNBLouPkGPaS4BTPsaL1CtigKuYYeXrFDg+6kN4wAB8
	BPhqYPZA==;
Received: from [2001:8b0:10b:5:9e94:e235:608c:ebeb] (helo=u09cd745991455d.ant.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wuSK6-00000003OqJ-1FPA;
	Thu, 13 Aug 2026 10:06:06 +0000
Message-ID: <8ba4860fec45afeaa305bcb011d732ef0da302d6.camel@infradead.org>
Subject: Re: [PATCH] mm/mmu_notifier: Remove non_block_start/end() from
 notifier invocation
From: David Woodhouse <dwmw2@infradead.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Michal Hocko <mhocko@suse.com>, Steven Rostedt <rostedt@goodmis.org>, 
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
Date: Thu, 13 Aug 2026 11:05:58 +0100
In-Reply-To: <9e65be44430e7d013fedf9a1626caba020ad6d94.camel@infradead.org>
References: <20260811142730.GG544626@ziepe.ca>
		 <a552b227e18ddbb3fa1f2edf2d1cb30ee6ccff13.camel@infradead.org>
		 <20260811104229.72fdd928@gandalf.local.home>
		 <37b83b429b9f14ea6ad4ca1c13cc8e565ec09033.camel@infradead.org>
		 <anwraNIKJV8zwrNT@tiehlicka>
		 <44c51ace9b0dc44b795f6f48c91cda440eed910b.camel@infradead.org>
		 <20260812122759.GA662699@ziepe.ca>
		 <c41c52f02f033ea980d4b5f9b8239d5e9411a03c.camel@infradead.org>
		 <20260812134934.GC662699@ziepe.ca>
		 <a48e6e7063122b22a8083bb0792984a204f316e6.camel@infradead.org>
		 <20260812142659.GD662699@ziepe.ca>
	 <9e65be44430e7d013fedf9a1626caba020ad6d94.camel@infradead.org>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-eOe2XJemHWfQW7ObkaU0"
User-Agent: Evolution 3.60.3-0ubuntu1~ppa9~24.04 
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: n8ppd7tu9z8drqnjto3am4begphkw7bu
X-Rspamd-Queue-Id: 358B720003
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786615575-75360
X-HE-Meta: U2FsdGVkX1+6Pufk2DoUkGjOexQWsiwswv/4R/Qp6MfihrBaLGMpxFl+zk1btgoiFuJPehtf1/Cvftgb287Fm85iVwTffDcXq+ttmoDnLvfV8XMKtoWSq52yQc9ld1bHVBe7F2ckybP7X1LFjsT7n/fJoEHf+YLikM2HbLih5AFFx98KzRLz+iKOP+yFdJiyZ7BFE3OdelArNsgpxJ1pkq03Izw4dXZg6nIavtEBEmNNoXleAhlfIdXcvjmZPS92CLjqXhRgmb+0Pavq+pGPir9T4/s23dX7v/TTnp/9ONYq8sJx/+8QSatyuawBCD0me3/D+POeb0Lw0HUjsTPBzlieuIWyrdUitAXBy6TaFijp2IxCZq++wl614+1YczE2MR6u24thJRjAwt8jRzP5WSBt8+oWSQgJX12CNV0chOueWisl92S7HYNFiq4WtROLUOGcgVeUSnrPIkLhY1iMRlnqP4ekYHNdxytcVqQ+1X8J25T4s45+NAOAkZd0MKy6ADv49ngrtXZUqD4ER2SUSMDRg1IWEzmDTM2dj4VsJduP9NG9QVrprEvFuv/jHsD+kIjxT84Wh3yXczaQ3E04U0u8R96Z9L5z3MUokaIx1zEwyS3m+EieeKpxhNqyWcUyUHJ7UrXb14ESUSjizQO12+wCwPBHWAiWo+mg/R0t/4CPRZe6PXUxG/UNGJ3YuG1jQ+FiMEMdL/CvBApJK/DJdzNNLvsGEcclqkysfrdA+JpdT9fDXUi4/8CzNWLr1kQlvp7Os/kGmimxhtAW9Bv9o1kHhUzHvgPhqOeQRJZ6ojJV9HdyRnIWZ1cuksZ55ABa3X0ibtQIEUI2LI6Id6e6z8w22vR+ROOeP1AlP7LLKppLiHK4G8pAZnNuiMl4Ja4wy2Up7EXSLgYt2OMEH6NNI5cN+tYFVJO2ZQZG8Xc1XQxO8N0/CSDCTY6oSDIjaIxN32s9e/E1cAI9Q25kqFD
 1DSxXEYh
 zm7osKthERFSd4xuOB5XRWSjZKYEAnMoOuLrPEpIH5ho3veszZetDu+GgC7jLNo8KFk11kh4nttJIOVvTuJnp+fEswe+kCZ0wvxsBdm95cq3LeDtvT1OdJ8mwF+l14hS3Vv+jD3qCgmIcLpVBewwJD+moEJUZvg/Gb2B79D9xDK6Iij06fj9hFLXYyIhpTDTSm+GXlyfPGVZSK7nQklMqQe2p587MsFiHzq+wEiOdXUrrcU6CJ4egYP80oW1p+8REc46eYd5PjZHR357u9V1LwnVw2vjC/9GRqlsZR7Q34L/fkX9CSR4WzpwAocDm0a0zjIgFb7vX0Liq7voVzNjnMJWl0Xak6NcdQf4mhDJ9XbfEMjrrxBh+dWAHbC5i7YMH3X4Avh4rpKzaKStxJDUhFG7OG8scygycPIpnYU0rcfprOuvQ9tTwLI+q7PFoFAmPavqnTQhKn9qUyi/E3jsHdU8Hu99pn8YU55MAB/QOLADktbWj6a+LzrSCDHkB0U4kqofM94t43QOf7nOZzLbaPKceU8HGGmp632A+PEG9kQdjvvq+unC1Y3Aa/eVn+STmqJbZzNVCcTNx4NAcSnaP9P1Ifzw7TMVY5WBGVumMxxHiXcv6HORj9PIFO2quEkE71eMaj96/F9z5sXoWHsRLCcabMNwx3j1qKr5l3HiclS5BD8KwfyN+r02ai4woAh6Tc2SxTdNUje+3OvxugoauyaXzHh9Kk1N+TEtBv/jIReGCYOaP5GNPiVSOAMhZSTNrJlmK7/+aBZWFVcjhixP4u7opDI+sFChAOAQi1nKhV3uWBTcJqE1jdlFLRF0Uxp63ULvf8m+3cwHld3lWIH+ZQ5hRISLarFr7xAsfXOIg7rrY+9E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--=-eOe2XJemHWfQW7ObkaU0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2026-08-12 at 15:38 +0100, David Woodhouse wrote:
> On Wed, 2026-08-12 at 11:26 -0300, Jason Gunthorpe wrote:
> > On Wed, Aug 12, 2026 at 03:05:43PM +0100, David Woodhouse wrote:
> > > the non_block_{start,end} guards around the MMU notifiers, which are
> > > basically never being called anyway and don't actually seem to protec=
t
> > > against any real bugs.
> >=20
> > If you think this blocked stuff is dead code then lets remove it, but
> > I'm pretty sure it is called and I remember seeing bug reports about
> > it being triggered in the wild. Vetter certainly added it because
> > their tests were actually triggering and they had bugs in their DRM
> > stack directly connected to this.
> >=20
> > It might not trigger for your hypervisor case but we aren't here just
> > to make only kvm work now are we?
>=20
> I'm sure there can be real-world use cases where it can trigger, but
> when I was *trying* to exercise the code path, to validate my belief
> (from source inspection) that even the plain spinlock would trigger the
> splat, I ended up having to hack the kernel to do so:
>=20
> https://lore.kernel.org/all/787aa26cf62dfd361eea8ed19f384fc517892501.came=
l@infradead.org/
>=20
> Perhaps in the past it was easier to trigger 'naturally'?

I did a bit more digging. On the one hand, I was wrong to claim that it
never triggers =E2=80=94 there *are* a handful of reports; of my searches t=
his
was probably the most fruitful:
https://lore.kernel.org/all/?q=3D%22non_block%3A+1%22

On the other hand, they are basically *all* false positives from the
point of view of what the check was actually trying to do. And in KVM.

It's causing more issues than it fixes. Including some bizarre MM
gymnastics: https://lore.kernel.org/all/amMZFqs1smKmMuj5@lucifer/

At this point I don't think I even *care* whether we manage to do the
atomic SRCU thing; I think this check should die *anyway*.

--=-eOe2XJemHWfQW7ObkaU0
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
5i0Yfu55bGt9qM5zRPcJmIkAAAAAAAA=


--=-eOe2XJemHWfQW7ObkaU0--

