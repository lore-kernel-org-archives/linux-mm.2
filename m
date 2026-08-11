Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B022C5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 14:33:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87BF26B008C; Tue, 11 Aug 2026 10:33:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82C876B0092; Tue, 11 Aug 2026 10:33:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71E306B0093; Tue, 11 Aug 2026 10:33:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4BB0A6B008C
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 10:33:35 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B44B9A0491
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 14:33:34 +0000 (UTC)
X-FDA: 85089231948.07.C05902D
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf25.hostedemail.com (Postfix) with ESMTP id 14AE3A0006
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 14:33:31 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=U8vD7xKK;
	spf=none (imf25.hostedemail.com: domain of BATV+b6a5eba76e218a018a6a+8388+infradead.org+dwmw2@casper.srs.infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=BATV+b6a5eba76e218a018a6a+8388+infradead.org+dwmw2@casper.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786458813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FAYxpQdIh+vJP1qsFeVnIiJhh0aBAnKwuv+RLgg9Zuw=;
	b=awAs1mnF5EG38fMnqJFWG4gmC84t5Ksuq1gYXX61TIRbNBlMNstT0u0OiiFEEMJKfBv7vY
	jeHEHSHPGlLiemK06nkv1KV9iaZKTfg7hyulKir4/NcDl8O1v48vSMRZOAQzYQoWXb/SoT
	pK+usy/B5MO5gDeIAMyE4u7w/WnC/v8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=U8vD7xKK;
	spf=none (imf25.hostedemail.com: domain of BATV+b6a5eba76e218a018a6a+8388+infradead.org+dwmw2@casper.srs.infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=BATV+b6a5eba76e218a018a6a+8388+infradead.org+dwmw2@casper.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786458813;
	b=npYK7WoybixGp0LcgVqFzBHRTQv+g/BQPlMfUOf8zLXpMHmGYOdi7sYm2yLluukdHJIEc/
	UHzzkzXy5LzKgKNoiXvL85JrrKFHXurRb1/0xrADR2PZAGYRlTu+Gbq5DIx6y08xikhb9U
	NRWqcE10uw7dmG6pyRlAVtVA/KFEI70=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=FAYxpQdIh+vJP1qsFeVnIiJhh0aBAnKwuv+RLgg9Zuw=; b=U8vD7xKKFSgWCCcsHaT6YYpER7
	b6mvejgUsElDTeQgGV4lcYpP6dZSYhCXuCAxU0H71fVrdZnGbQJJWgcrHsdqjP+3QaQKg+hWaiW8s
	nUPt4Kq+MD3iTlTYKQrzpKvIHgFEAbmmpcNDDnrpo39jEjwHdM0OcskihzmpqzEfzjwxvSWHWkbWA
	ieYPp6qeko/MIHpjstW/kJreVHy/yfIL5XB9V5Ojemo0V1SwQ88Q9TAKYkC4HlG5OWPF8aj1V33jk
	atpJzQ5Cm6DzH8+oyYR91SPQlF9VLWG1KtO8WSXK3xhftBlMl+r+f21UCfGJdxvxPfJCql6Dd0NTc
	A2fOHN+g==;
Received: from 54-240-197-235.amazon.com ([54.240.197.235] helo=u09cd745991455d.ant.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wtnXg-00000000Yjh-0aN6;
	Tue, 11 Aug 2026 14:33:24 +0000
Message-ID: <a552b227e18ddbb3fa1f2edf2d1cb30ee6ccff13.camel@infradead.org>
Subject: Re: [PATCH] mm/mmu_notifier: Remove non_block_start/end() from
 notifier invocation
From: David Woodhouse <dwmw2@infradead.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand	
 <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"	
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport	
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko	
 <mhocko@suse.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark
 Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 Simona Vetter	 <simona.vetter@ffwll.ch>, =?ISO-8859-1?Q?J=E9r=F4me?= Glisse
	 <jglisse@redhat.com>, Christian =?ISO-8859-1?Q?K=F6nig?=	
 <christian.koenig@amd.com>, "Paul E. McKenney" <paulmck@kernel.org>, Sean
 Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 linux-mm@kvack.org, kvm@vger.kernel.org, 	linux-rt-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org
Date: Tue, 11 Aug 2026 15:33:18 +0100
In-Reply-To: <20260811142730.GG544626@ziepe.ca>
References: <a247c49dd61af1df7ddc4dcb1cccbcb36b04d9d5.camel@infradead.org>
	 <20260811135537.GC544626@ziepe.ca>
	 <1d669aca4ffee797b9c29215382444a5b23624b3.camel@infradead.org>
	 <20260811142730.GG544626@ziepe.ca>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-g2qywzoOicc1Tl34UQiF"
User-Agent: Evolution 3.60.3-0ubuntu1~ppa9~24.04 
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 14AE3A0006
X-Stat-Signature: ch8zinh5u4qh9gj6xhe5pmf1uz8o4cci
X-HE-Tag: 1786458811-821684
X-HE-Meta: U2FsdGVkX18ehn08EB2jVNMl6GoKVqKj77IQFaeik+Rs3fjbv1Gd0ZX2qrcn3IsIoEtSxgjHwRz6m8IXckXxWH042LiorQcEX4uR3mxV07vveMWbm1UYkYBCkQ61kw7nhVBiGo3AJWLC5WGGEnjFU0AnATk4k+tA3ydoovSdeSEOMtJuADUkGG1l5Zv0QOONd9mM4Gi8r1lpHLpY8zIk7oOuthrAl5QOP7PrR2+VUDeK4idfgseR5gA2yLBPX2HOdOEY01KK4ZEsrOLxP0J+gSMdhXdZK/W9W7T75r8kAX47lxJYRdbC3WTLBF8AQCZwcIPxmRZ1aD282xYKNiJuA4ecqkqMQ7VDXpgbnR5Uu1vPucjsMLsLqPbbPNQJhtjm5GQfkMkbushmb6kXFREhIE3/90yXeQAs9OTr6thgv/2HsiUjpvNag48jWR0a/p4p3tj7XjPVn8iPwHqPxlrz9ksejCpihHmGumRRLdHWrueddzk+FrGpriiQbaQHJmAtSfAIsax2oANsntPKi7PGnTciq0EUiPXY//ZEckQiJ9SyfZuF7LyJnq0RjCAoPlR8HiGRitUISn1JBa3zjILTObFepa6Did4hzR9GKTAIhmQB4ojCcrxPaCBBYj6YqBC/nGS4cu4ZfeaNDcPTJsTDKNQT0S7LUtvaM/MXsQ3CFCVilaFP+RFAn8/XBp0Gu1wgj1JvzLuzu4kjzar7kktPI5JEtc1PQiRbtmrSahNjcyFxA/cFRs3fIRgoQYcrGglDw1xbuCRAgf2k93CREumUcm2i5neTUwAzk9QRkBcGsl9TVu3xGg/i868jr82a5QZ6r0haAikZldw8JAEJWbQ+kRHYCUIQHgRJFOzMoUTUEJc12brzzlab48WDIUzNIVdRbcgYacuIEA6l/pmGHF8gW1McZk1RI/UvMsrBdCKl/Ol0HXOAn8h5qAUPs0uWyMNzgiN1+qxqUZg59ywddiy
 N7LAF0s4
 r+NQOvO3/FDw5wSIe9I6bIDKlFZkAttAxG8MgMTOvXDC/sH0FkqDKDSOq3XXfc25B+98jrvudYRofviTSkRf9CWdNvLYEnaKtfUKPheXtA6HlVe7oZ0GIMFmiYz3p/3/7vQSuDnpg+CC8izESbiQRtxrlXcStBCGLy0mTb2Lzj4lSmZ/0Vg2cXFXBYkaADWbWuV0+GVmCcN+5fmnfPThz2H6+R6dMuns11Fjspj1wNebXsnWWHpFjziO9IJKvcVs9zHIvytV33FOFRsy1+bU78xEKzdtOs2/dVeRP8/wCUpRGzqtw78zoJ8WYXDSSjdiCB0v3TLmWkOoXhoJNkzNFyVjXJSRN76TWy7SQCPlaIDRgYf2Ybd9/YTx7XklRSf+7XiVmhyqHy+1noJQ/GPIVl7IfDqnvT1cY7iK6qF/NEz1SsWX3l4/b5TJ0Rhrz/eUipAC4/cH9ngCR4pST2hHhKbhqQ8hPpcGYrvZayhwo28nimhnnIdWBLZdqZwYOG1HNqVXOMYKG/u8b7KcxgORyenLS7+8S6+68wBfoOtFw6GVpLUFiok3EoyhAPB3CTXg6MAx9L80AevFfyiYbTUynI4UXqv81Cre6irmOFK/dNXt5gKae7hYpfxVb+W6m+V0QrNVpVJj52J89GKsdTfk5/sPl73FIcCDAFKpQhJgrSUwAsrX54YnBZeU6kiyBh4IbPSpRasmnlEIieqqz2198TSA/dtdaatSpUTdLpjv0/JRK0jl0c8BTR3GDx/9fc0iMuHGGY/ebJmt8Z0kqPCfeSXaQ7rART7dryE8rRdgzdrMl9kKMVHYxrmHuOPZndgwwS0NuzW7aqZcCQEoBL+XPXOWeshXJSIjIJH4pCuAB+Q63TgCaA5cbaQ+6SVO/BSbed8vclDNc4EwlUC58TDGxO8BxDSLT00O7baya5u2Ljbh5emc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--=-g2qywzoOicc1Tl34UQiF
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

(Correcting Sean's email address)

On Tue, 2026-08-11 at 11:27 -0300, Jason Gunthorpe wrote:
> On Tue, Aug 11, 2026 at 03:21:35PM +0100, David Woodhouse wrote:
> > > > =C2=A0- On PREEMPT_RT, spinning locks become sleeping locks, and pe=
rfectly
> > > > =C2=A0=C2=A0 legitimate spinlock/rwlock usage in notifier implement=
ations (e.g.
> > > > =C2=A0=C2=A0 KVM's mn_invalidate_lock and gfn_to_pfn_cache locks) t=
riggers the
> > > > =C2=A0=C2=A0 splat despite having no allocator dependency whatsoeve=
r. This is
> > > > =C2=A0=C2=A0 reproducible today on a PREEMPT_RT kernel: KVM takes
> > > > =C2=A0=C2=A0 kvm->mn_invalidate_lock in kvm_mmu_notifier_invalidate=
_range_start(),
> > > > =C2=A0=C2=A0 and if the OOM reaper reaps a KVM process the result i=
s a "BUG:
> > > > =C2=A0=C2=A0 sleeping function called from invalid context" from
> > > > =C2=A0=C2=A0 rt_spin_lock().
> > >=20
> > > I don't know anything about PREEEMPT_RT, but this seems like an issue
> > > with RT if a traditionally atomic safe functions are now triggering
> > > might sleep failures?
> >=20
> > I can sympathise with that point of view. In fact I've spent the last
> > couple of years mostly ignoring this "problem" and just blaming RT for
> > doing exactly that, but I don't think we can really get away with it
> > any more.
> >=20
> > cf. https://lore.kernel.org/all/787aa26cf62dfd361eea8ed19f384fc51789250=
1.camel@infradead.org/
>=20
> If might_sleep doesn't work sanely at all in preempt_rt then just
> globally turn it off?

Turn might_sleep off? Or PREEMPT_RT? :)

The RT maintainers are on this thread if you want to pick either of
those fights... that was not the course of action I chose to take.

> > > > =C2=A0- A notifier implementation may legitimately need to wait for=
 an RCU
> > > > =C2=A0=C2=A0 grace period before allowing the caller to proceed wit=
h unmapping
> > >=20
> > > That's not allowed. We really want to forbid that, it is not an
> > > acceptable way to implement a driver using these APIs due to
> > > performance.
> >=20
> > Speak for yourself. For the KVM gfn-to-pfn-cache the performance scales
> > *much* better with RCU than with explicit locking:
> > https://lore.kernel.org/all/8f41cb82b7c99d5a3d1dda016e4841326b4d8a52.ca=
mel@infradead.org/
>=20
> At the cost of completely destroying the mm shootdown performance with
> 1s RCU grace period waits every mm operation. No thanks.

I feel like we're not talking about the same things here.

The KVM patch which this enables does *not* behave as you have
described. Have you looked at it?

Nobody's suggesting that we force any *other* MMU notifiers to do
anything that they don't do today.

--=-g2qywzoOicc1Tl34UQiF
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
dFWfa6Y11jGhSG16mmk98rsAAAAAAAA=


--=-g2qywzoOicc1Tl34UQiF--

