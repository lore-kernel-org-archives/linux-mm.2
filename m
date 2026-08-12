Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2DEBC5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 10:25:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D0476B00C7; Wed, 12 Aug 2026 06:25:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9817D6B00C9; Wed, 12 Aug 2026 06:25:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 871036B00CA; Wed, 12 Aug 2026 06:25:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 581C26B00C7
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 06:25:44 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C7798140240
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 10:25:43 +0000 (UTC)
X-FDA: 85092236166.26.B52F492
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf31.hostedemail.com (Postfix) with ESMTP id 337B620008
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 10:25:41 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=hHQb3SpH;
	spf=none (imf31.hostedemail.com: domain of BATV+5bb66369c51ae59fd3c1+8389+infradead.org+dwmw2@casper.srs.infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=BATV+5bb66369c51ae59fd3c1+8389+infradead.org+dwmw2@casper.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786530341;
	b=aVH/8mT7G+eFPrRBsW4eCVXsH99LzskANARIF8uw4o9cHqdyaeapnMO7EVH6/RgtPKLNDE
	J76w85mTOhExCN0Mmwsg6KSoDDi8F0AbPC9/qqN3JEqct0f1rRe1dmAHwdqmzynY/CMol0
	h3MhszNMk885DNmDAjvDD4cBLL2D2RE=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=hHQb3SpH;
	spf=none (imf31.hostedemail.com: domain of BATV+5bb66369c51ae59fd3c1+8389+infradead.org+dwmw2@casper.srs.infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=BATV+5bb66369c51ae59fd3c1+8389+infradead.org+dwmw2@casper.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786530341;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qT4aUyzIVYG8Bky4lQK/o2VBOXuIf9zFYmN3VQ1e1tM=;
	b=ejIFJ+iZAKstXisRt+JmjFzHvVFoO+H43CKPVGY+Wv84uyw8tQfJUKxKgjoPcj9bwWGols
	lVDJxF2fQiZO5LmeFRWuBGMUj9KgYnvI51r3qgLtu6hXT9oltnggJwt0ZOP2JE3u/RU3ug
	Ml0J74gKVeGsH+z7Ec80P/+uqU6WbWw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=qT4aUyzIVYG8Bky4lQK/o2VBOXuIf9zFYmN3VQ1e1tM=; b=hHQb3SpHuDnTdX5EjBmXQhnxul
	6b00h2r+ULTfMChXF01xeoFD1CFjREK59wjuCcaOYEnCkTt/6fCg0nTx/utQqLhi9klV4g8yFXfBq
	W3KCOwCDs281C5i3gvbEU90aKaFSxhOBb3G0W8Dl8nC/R8XtF/5i+/xELbj4wbHuXr5IiDLcB6gWD
	g7yj9gHNUNB3es4jPXWOP5cHh+aJj3xP7mJJgu8QAe8Vwc/Dclmc2309aCbsgyV4b74VaceyiLd2M
	tzt05dNGgJTx4iqEn+ykoo4ukTYTBytGxrgb7chclk+CCoL8DegfAcUxoAF9oRpZzh51Q0S1t/gEI
	zkMNiJwA==;
Received: from [2001:8b0:10b:5:a3a3:d97e:a004:df29] (helo=u09cd745991455d.ant.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wu69K-00000001ojO-10Sp;
	Wed, 12 Aug 2026 10:25:32 +0000
Message-ID: <79df7151bd6537170865d96b9292c3396cc1f25f.camel@infradead.org>
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
Date: Wed, 12 Aug 2026 11:25:24 +0100
In-Reply-To: <824a27d101d5b2e2a8a53fb81f5e4ecf15140a1f.camel@infradead.org>
References: <20260811162423.GL544626@ziepe.ca>
		 <f33571137d2e3973e440d09c7602edaebe08b714.camel@infradead.org>
		 <20260811172627.GN544626@ziepe.ca>
		 <B25708F5-8425-4075-8D95-5E2A00C933DF@infradead.org>
		 <20260811181915.GO544626@ziepe.ca> <anuAq2s4mtyw4_Ql@google.com>
		 <CABgObfYR+vXBuSm3v5jbbZL8vF=XnocFAnjumdShgXBzod-HCQ@mail.gmail.com>
		 <27f2326dc66d6341174c0e510aa518a1297b66ae.camel@infradead.org>
		 <anuo_OxfvJbQnn71@google.com>
	 <824a27d101d5b2e2a8a53fb81f5e4ecf15140a1f.camel@infradead.org>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-WNiqyaGL6zVHN6X6pSKP"
User-Agent: Evolution 3.60.3-0ubuntu1~ppa9~24.04 
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 337B620008
X-Stat-Signature: reh489fi1d9wu3tyqw9dfasrnmjwxpyp
X-HE-Tag: 1786530341-418471
X-HE-Meta: U2FsdGVkX1/++QduoMbXxSAPNo6OxQ9WL2RJvsalWuHeDOoTYM4j7RLn5TCfUhnu9iV+OFAPuID0lr8/J0d8fvvTLhhkkPEla3X8+MIIMVO7ohwLzLtZvfY4Rdso38o5ddpSpocJwcUG9UnBkMoA/Ul5tCt3yr19N4bXH47ms6122+Sirf8w+5QV2S4oOGZbE7nl9m7Z4xqIF2Z+pxxhGp6TQiBeSj0r6/fKrjraTZqf70BGm4bPiChd6rdJGzMwfpch4TxwdmCNvvNMWpnJCDUSIBh1lKodKQ+tZ5b0dZWC5aIQCEdgISjgLA3MHYO5lM3jfRdDV5F89miw7RJ0ION0LnmZx0zBfgrhuHoYuMu+Y0BnP0o42s9OiXLExqnuMsTCfchLJmpgzOF836V1zaz95nguK42T7lazH0Ghyypd31gd+vNjdh5O+xOZ75UvXJuwDyi7m2dysMG/mepgLABXwsNqsT7qxug0JQPB6LqTB77ztIjL4ag+oSxWm0ybVgyBGKydKpfpiNE/bSO42rSbxAYMXagHVX5wugUKm3anFxORebWkWfJRZaYb3eCjxFXGDPK4Osld4zBALRGzVJAXsq3V9ijGf0XqsrtghOCG0576Mn8BPj8nPCknDwKSDOkyewrOu5ryeQZjreFqebf73RZmLBnW/bnLD3aFLiWj9/g62ItTgqZxoEjPkkeKlQHZoFMJ0/609S1+m42+RcF4/EScM27yZqZOIxMvMUrhXGBw1b0pelUtFANDlUfe/i5B/1E11ttB9BrNHWPb4y7RtizwwZdpVug++m/qxDPiP3RU79CmY6vaunbTkGJ3gtBcg+sd/4e2H0b9uZva8iXUFMCUeFp91WBX+DM9mZZTP8jaltZhtAN1NBZtKG08eJMUjFCddKi5MJ4dkFj7A8CXK5j//UehT66Re8gG/rGsvuMbGPOjn9g1oJoBhwSiwDcJ6lfh377KDQkwVdp
 AtdNe2Zb
 JLjMoOUaEz/7/79aTF5RPBhKvWwcf5nbz9vz3g/8yzE4hl+lXAQI5NFVx9X+q23WJ2E/PS8h2RBxeKjAokjvwQfW2GtTNSUG9YVgM6BXvq/Xo9P3VwKZmOr4rNiS64Q/Pi0Amgjybp2jYMXKnvKG31Be0QlutSvwZBK9Oo48jyL6bjJLmJgqx+74OBJpNNJSBvZPVPOUjxWys7Ys/4eE/OuMIzFwKLVlbrOZizmb0/LhNBLEuaEDFdWUVLN/peDouE1M+OwuE57d5H5zeSxxbMh//yz+Ud8dA1vNWm2ek9GPwp4XrljypAcK2PeGEXjV4iRSiAvmtnssXmSxju90OqVK9CVBb+nwaoe43Rm7tz3xGM+5ZroOAP2/8r/06cCFrFO0mpSyTr1nCWIPmTsKwT03N+Yn2uOm3BVokVajEv2C+VXe2J+hq86Q5qg6JsfB87/xrx2CrqwVskJa4THxtfdnL2nrCXxXUICYZBU92lBm71G1fUxR0fzVSZFRWgWRlfkpz2Ie8+6gXs8HWgsdpKg3e1GOGj3Rx3InstzgKX6ivqZt6kf8VR8OLJuwBJUJ0GbD21Cn5kHGrLMk/L7M8iyszKqMtEWFM8ZswX7FlX/tKlMac/OLj8X8uqxHBhGS8xpZHTAuoWfQJY9bGMv7x8u2jAqzCOEJuSYOFLQn+4wUjlYvnNTky0p9psdixYKabkuSpcgU1peqpo/skeoEqggrNJp/MF2tzUVS2etcdST+72XXFHeLu106fvWAq78KfNTutbsi737XJcW8Y2Fq6ndjFxAvkzoS/R7jSXs0cKASRE1eCS8qvUOHmhKhbl/SiKd3X
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--=-WNiqyaGL6zVHN6X6pSKP
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2026-08-12 at 00:50 +0100, David Woodhouse wrote:
> On Tue, 2026-08-11 at 15:58 -0700, Sean Christopherson wrote:
> > =C2=A0SRCU is
> > fantastic infrastructure, but I genuinely think it's not the right fit =
here,
> > especially since we'll likely need a different solution for in-guest re=
aders
> > anyways.

Actually I think it fits quite nicely into the GPC SRCU model. We add a
GUEST_USING_GPC flag to the gpc->state atomic. A vCPU which is going to
use the GPC in guest mode will do an atomic cmpxchg to set
GUEST_USING_GPC while the GPC_VALID flag is still set.

And then in the flush side, *exactly* the same loop which already sets
'cleared' when a cache has GPC_VALID, will also spot that
GUEST_USING_GPC and add the corresponding vCPU to the bitmask of vCPUs
to be kicked.

It's a perfect fit.

In fact, we could observe that the GUEST_USES_GPC concept has *always*
been closer to the RCU model of "readers do as they like; the writer
has to wait until they're done".

It was mixing that with rwlock that was odd.

> The cases where we have to hold the host physical address *during* the
> time we enter guest mode to run a vCPU were never covered by the rwlock
> either.
>=20
> Fred's patches which reinstate that GUEST_USES_GPC mode are kicking the
> vCPU from the invalidate_start handler, just as the original
> implementation did. However the locking (or RCU) for the in-kernel
> users ends up changing, I don't see the in-guest part changing.
>=20
> Unless you're imagining some scheme which could handle both? But the
> in-kernel readers are *brief* and will always go away on their own,
> while the in-guest needs to be kicked; they are opposites.

Honestly, if we're going to start re-inventing concurrency primitives
just because "SRCU *can* be used badly", even though we weren't *going*
to use SRCU badly in this case... maybe I should revisit my starting
assumption when I first started digging into this, which was that
"nobody wants a raw_rwlock_t as a workaround to the RT issues".

And if we want to invent new primitives, because that's *always* a
barrel of laughs, maybe we *could* try to build something really
dedicated to this use case...

Since every access is at least tenuously associated with *a* vCPU, we
could have a spinlock per vCPU and each read side takes "its own" while
the flush side takes all of them in turn, one at a time. That probably
only needs one such spinlock per vCPU (not per-GPC per-vCPU).

But maybe we can handle the GUEST_USES_GPC mode too... instead of a
spinlock, have an atomic_t of the number of readers, with a high bit
indicating that it's in-guest.... but honestly, I just don't want to.

SRCU is *fine* here. Let's not overcomplicate things.

> > > I get it. RCU is a versatile tool, and in *some* cases the *Sleepable=
*
> > > variant of RCU gets used in ways which would cause grace period laten=
cies
> > > which are thoroughly unacceptable in an MMU notifier callback.
> > >=20
> > > But in the specific case of a dedicated kvm->gpc_srcu whose only
> > > readers are tiny snippets of code that until today were always run wi=
th
> > > rwlock_irqsave? That is *not* Jason's worst-case bugbear. It's fine.
> >=20
> > I agree it's more than likely fine for your use case, I'm not convinced=
 it'll be
> > fine for use cases that heavily overcommit memory, or do NUMA balancing=
, or (close
> > your eyes) enable KSM.
> >=20
> > E.g. it doesn't take all that much for even a single expedited sync to =
generate
> > a delay of 20ms.
> > https://lore.kernel.org/all/20260309193059.2244645-1-seanjc@google.com
>=20
> That looks to me like a pathological case where KVM is trying to use a
> single srcu_struct in two different modes, and getting sad when they
> conflict. That would never be the case for the separate gpc_srcu.
>=20
> I've been playing with the soak tests, running in parallel with a load
> of about 140, with KASAN/lockdep/etc enabled.
>=20
> I also implemented that thing I suggested: a try_synchronize_srcu()
> which doesn't even use the waitqueue when it can trivially determine
> that it doesn't need to wait.
>=20
> Even when we're stressing invalidation vs readers, it ends up taking
> the fast path in about 99% of cases, taking around 4-16=C2=B5s for those;
> 32-128=C2=B5s when it does need to call srcu_synchronize_expedited().
>=20
> It goes above 8ms in 4.4ppm of cases, with the p100 outlier being
> 17.6ms. My gut tells me we'd see those occasional outliers even with
> the rwlock at this load, but I'm going to kick that test off and answer
> that definitively in the morning.

That one crashed (reminding us that I was actually doing this to fix
*bugs* not just chase the last bits of performance). A rerun this
morning shows a p100 latency of ~11ms for the rwlock case too.

I redid the tests to also track the costs of the *other* thing that=20
the KVM mmu_notifier does; poking pages out of the EPT and kicking
vCPUs. The p100 there was only about 2=C2=BDms for both EPT and shadow
paging mode. I wasn't able to test with ATS+PASID capable devices,
which I suspect would have led to larger numbers :)

Really, I just don't think Jason's tail-latency bugbear is actually
anything to be scared of. It's not new, and it's not dramatically
different.=20

--=-WNiqyaGL6zVHN6X6pSKP
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
BTEPFw0yNjA4MTIxMDI1MjRaMC8GCSqGSIb3DQEJBDEiBCBUzbnhMma/oB7tAYJgpZB4wRTdpT7S
64NxMcrTE1BkEDCBhQYJKwYBBAGCNxAEMXgwdjBiMQswCQYDVQQGEwJVUzEXMBUGA1UEChMORGln
aUNlcnQsIEluYy4xOjA4BgNVBAMTMURpZ2lDZXJ0IEFzc3VyZWQgRzIgU01JTUUgUlNBNDA5NiBT
SEEzODQgMjAyNCBDQTECEAM1KLa7MmyR8R04yjiFXSAwgYcGCyqGSIb3DQEJEAILMXigdjBiMQsw
CQYDVQQGEwJVUzEXMBUGA1UEChMORGlnaUNlcnQsIEluYy4xOjA4BgNVBAMTMURpZ2lDZXJ0IEFz
c3VyZWQgRzIgU01JTUUgUlNBNDA5NiBTSEEzODQgMjAyNCBDQTECEAM1KLa7MmyR8R04yjiFXSAw
DQYJKoZIhvcNAQEBBQAEggIASbZx0Tk5pBqdgnK+Kf05HS8KEfDfYXJJUQcBClTXCYE2J+0+ySXN
r8CubEEuTGowZkNV3N57aUyP14MA8gFQa7+UbxfVmb5YfCtqFXnASFzJ/xuiVZR6SyRSWnw0Y0Ui
7TfZACl+Yfprppk8vGkSCa0A4OfXbDbJ43jIVWIuEwjDHxWMROSMMjTomdWLqVtHxs4udRO49uRK
q970HOCrBWQefPd0Qgy/erqMxeZ+6MzIlF5aMvPzx5VbCDpeMuqgFhWY3nmWIDzMvpFIyRhYvQ81
KWdyoWvn00ZvT7kdtKRQV0BIt7t0ulJGdCn5axYc7cCwVuyGIfuloyd7UleAmpHnmlMwitFO8qNL
IPUW4vLn0esf1Oqbx5MMd3G7ooVwJ5Kh59/4k9V2CTCGxdGJ5q78kV8BepzHEkSuwcltJ8A9Xget
gBcGh9szKs7Fw4UC/0OcbHddfqachMFSjOd3fwXwlNYAloxdOssGlVfM09mtU3xXeSnAJbahBmpR
4ynoBhRL1MAcBAQcZktjXywPJwFDKMCt8vmuDpLtTxz2Op08+ukGEotVkizS5Ol1EzJbfuJWr/JY
FHogCnjVez8v2ty2KmENBf2+XROu0jW8LZyKdEQgyxvtRsOZrZ7U0WtLv/+eLW1N83A2GCT6keXu
+0iOqMwQOWvNGjB6LCEXGxsAAAAAAAA=


--=-WNiqyaGL6zVHN6X6pSKP--

