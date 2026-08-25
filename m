Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F772C61DBD
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 12:16:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 144F36B00B5; Tue, 25 Aug 2026 08:16:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CEAE6B00B6; Tue, 25 Aug 2026 08:16:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFF7C6B00B7; Tue, 25 Aug 2026 08:16:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C87956B00B5
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:16:07 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4D34E1C1945
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 12:16:07 +0000 (UTC)
X-FDA: 85139688774.16.896E706
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf28.hostedemail.com (Postfix) with ESMTP id AB5BCC0006
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 12:16:04 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=AEP41ken;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf28.hostedemail.com: domain of BATV+cac146c21b70fe15126d+8402+infradead.org+dwmw2@casper.srs.infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=BATV+cac146c21b70fe15126d+8402+infradead.org+dwmw2@casper.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787660165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=9p7y+E+D/SjHn25JlvUvrxE/y7pfSxgI5ej15JD3C0g=;
	b=ySaVyY3ggeVeVht6YWCCtD93/41RfLKWG2YeU2GaP/5qYItmfoqqlRbTuP6l4iCmGj1/w0
	DoxB4VgOer1TrbIegX8w97Ts/EVn1LhChKCNKENv47cNkDUa4JQAHnZgCEl0fFUN28ZwKU
	pA3I8guWeAwwe5ljEwdhRh+yBTYDcXU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=AEP41ken;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf28.hostedemail.com: domain of BATV+cac146c21b70fe15126d+8402+infradead.org+dwmw2@casper.srs.infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=BATV+cac146c21b70fe15126d+8402+infradead.org+dwmw2@casper.srs.infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787660165;
	b=gGXbdFG7eKMCG34CTFCiM8A+GoFvtZ0NtA73ZuiSnUC6JlyG0y+k3PH9hOCqxVvqFSAiRR
	C3uP2J57Y82D5D1QjgJ6d3jTcYt4zz6teM8LnJEz9F7kFg1tbp8/YdsmYW0VqyAnZe7jNI
	ZatZ2CcdBb8ZGV6JGg12RwX7vOtnuHQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:In-Reply-To:
	Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:
	Content-ID:Content-Description:References;
	bh=9p7y+E+D/SjHn25JlvUvrxE/y7pfSxgI5ej15JD3C0g=; b=AEP41kenDSqRjJ7IjFvig7dbaL
	cKI2XItfCOF6KZGlS2GHsaQ4hAO6FNG7JACji7JSOrPE1NgWtauTVDSMAkDW2H1+CgqovU+4aeLGj
	m9IZ31O7myNeAToYpcJovEmWXWe1oTHSD9HgRj1LkjdN4nz8iLZwhrP8/pkJDsnpTVh6jywpdDO9M
	keMDgIUkR2NGoprfFXarucTmNoDEsTHytmwaMCh1xMqPvwFA+7uaNrOyYNzTgFOq4v5vjqEkDln84
	7qfTMfWV7OvWJqYWVXUf7pK03K+qC35/lzBxw2/RDeuO/cNEW0amyeuB6s06elboSb3yByub6KcH0
	OGv7y9Qw==;
Received: from [2001:8b0:10b:5:960:9a50:d6f3:b6b6] (helo=u09cd745991455d.ant.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wyq4G-000000093zy-2FZN;
	Tue, 25 Aug 2026 12:15:52 +0000
Message-ID: <11dcf5a87125451897982f728c1f65a5151987e4.camel@infradead.org>
Subject: Re: [PATCH] mm/mmu_notifier: Remove non_block_start/end() from
 notifier invocation
From: David Woodhouse <dwmw2@infradead.org>
To: "Paul E. McKenney" <paulmck@kernel.org>
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
Date: Tue, 25 Aug 2026 13:15:42 +0100
In-Reply-To: <333c4cdb-8f34-4e3f-a47f-961f47e089a0@paulmck-laptop>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-tQVYW8/OCQIWLSirSMeu"
User-Agent: Evolution 3.60.3-0ubuntu1~ppa9~24.04 
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: hybs5ugfnmkauaphekumxea14jsf461q
X-Rspamd-Queue-Id: AB5BCC0006
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787660164-950962
X-HE-Meta: U2FsdGVkX19b3GYxuk26XezY4aBL2FMN0c8pGraYvryBHhoJuRJAH43334zmTvT9nc6m77og6o8e7QQC8EQsc85EU1WZRzcXdDYY6dOz34c7y/iU2MiZ6kg73WXko3m+035EBUxIhWrxo5tht7vpUDrKHU5SHyDbuM1JfGY8tPu3cFXrgpz3rr8d/3a2TXfShu9JVca7Dik/pltpjPZ9A4j315YR+LddZmXSt7GrCp3qaS/enJQEqbw86p6Nfs0iOOtku86UQBtNcP8wbdBw4kLOrvbpFq3gMoxY5SpVMUpAZuVpp0j3nICRCQcvfje0XIbMdaw8rzgcAWRI6lFPJYQmGX0PmR46J4E1rbJNpm5YQ0SpJXlFDC/Ts6n2N54rJYXZAaTvdS6yw5jHo8UEu64UHRpJhKNHw2+NTeeHn676F45T5ePG0bc6/oKbA6oFoV0osjr5yrXxk/KM86EEC+isZ9mLOUkaz/IKZHxC4KSxPqAXkqDi9nloM8cQYCsRqBD6yyutTpQyGLsmW314OjmBuxCSw+3nRTki0lUbgcmSycIyoJ+4gzkigM6u01ZWbecfYpDcV/RA9b+cu2fa0W6sD4v5Z+lVA7pmgH4dXWGvhZOuFhO2irHXSvPOPawJI9KjTzd6g7dbjEGNO6uzC5qG8BMuxviNBtRFZZvWHxuE27aUGe/hPe5Svg6C5p71VZcSEqfeMvlNSvcQyL5DQw9zfj3z95XmwqQVasE5/aB9N9s5Gyo3AOdJewIrUQ7HtoRX8061lz/e6iaJiupb5/ZpK+5h8iFWB0ufkvKOPse0uz7ws6VuSuA6vg/hNqKDMMTj2MKMIPgE+tRrF+ZxdUb3L/Bj1wCkoHPEmOTA+AXtdYzW6eGTkOusV8K8CeprQYNB4SU0c22n3QyKySVCaPkTBwTYip0DVAZnt0uV0iuhev0j7qPczNNAlJdxtdMd6wXUsEej0B11jAji0Fj
 rgwTAj6W
 fuQAfh9snOu4JpXkFPIh4H8awDHOVvlxvhaLx/SIPTjj6RIn4qXsDes8853b+mSfz+oWZsA1dZjkpYZfHNu/gA7T3w1FoqAdM3Ro+Xz/WVk2GSlQre7pjiVbXztkmkGnV1UFTmRsk3cnb0e6WZ/KKw25rMsW6CKz9CM32gJtCPZHDArrzg2wqhqTIVr5qA8svXqAGIG4lv0w6WkzpXTKxmhtu56cU3aRFWnirwQ0Nwz/g9fjlveLzFa+jvEDUgcFi5ec2tLMVVldBiqowQ6LacNPlzDBqzroY5/kPK3LQXr6kiqomTLWSFJKNU2nLoF8I/2g06hB3VtiJv+/vA6S+w0l5FSjzxb1VTSa6yJqfXrhRJd6L7Lteko5VQbbWTh+Taa895uGJQr1jFtL65fBctVjj7npkCL6HCXptQk6R3zscCcsjxm3R8EeE3LkSYU7B9Q1sbLTExJEKyuhXEHqDm+ZdI+FndnBo4YWrwJFS56fy8XmVp2IQSn6/dA1RaXJL4yOif5me/Aqk0FsAqpu63e6TKltU0gBquvIMzW3UstoWHcsLCXO+VnN4ZADeVh1NLBw0HHENgRd8WMeItZBO2Z2cAnttXWBo8m2FGKaiMocssN9Prspj9e8+31f1Iey1V7EQgD2y2+9etHHOQqRKOxrjQ9Qi2iSmOkWliwfb2+WmZh8ERyU3jvm0GUMmRdVLlL/3D7OUZk8eXAOrscegE2wYiJxBw/J0u+fkOKWsi/FkknoAvzd9ZDOaBbSQNhkV6HtXnFTdtBf2mJtuluD246wfsRqdIx/NUwLuxt7XtVJbHHm6UpfQFNhjpV2+Hv+N22wtss01iyWsXc2p6PbI5ykovS4nqdYb3wBZm8k8rGbEPPs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--=-tQVYW8/OCQIWLSirSMeu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2026-08-21 at 10:38 -0700, Paul E. McKenney wrote:
> The current state is that if you invoke synchronize_srcu_atomic()
> from a given context, then srcu_read_lock_atomic() must be invoked
> from that same context, or a more strict one.
>
> So, for example, you can disable preemption across your invocation of
> synchronize_srcu_atomic(), but only if you also do so across the entire
> reader, starting before srcu_read_lock_atomic() and ending after the
> matching srcu_read_unlock_atomic().  Or you could instead disable
> interrupts across the entire SRCU reader.
>
> Does that work?

Yes, I think that should work; thanks. I don't think we *need* to
disable interrupts or even preemption for the KVM case, but I played
with it a bit to look at the tail latencies that Sean was concerned
about.

I converted the GPC series to use srcu_read_lock_atomic() and
synchronize_srcu_atomic()=C2=B9 and redid the same invalidation flood
testing: 8=C3=97 shinfo + 4=C3=97 vcpu_info reproducers on 128-way Ice Lake=
.

On its own it isn't much of a win for this use case AFAICT, but it does
work nicely when combined with the try_synchronize_srcu() thing that I
posted before=C2=B2.

I compared three variants: synchronize_srcu_atomic() as in your dev
branch; the same with try_synchronize_srcu() as an inline fast path
in front of the GP spin loop; and my previous try_synchronize_srcu()
+ synchronize_srcu_expedited() fallback for comparison. With
PREEMPT_DYNAMIC, and without all the KASAN and lockdep debugging I had
added for correctness checking:

                    avg     max
  atomic spin       8.0=C2=B5s   6.0ms
  try + atomic      3.6=C2=B5s   326=C2=B5s
  try + expedited   3.7=C2=B5s   4.4ms

The try fast path more than halves the average =E2=80=94 it skips
srcu_gp_start() and the flip-driven advance loop entirely for the
no-readers case, which is >99% of them here. It also seems to fix
a problem where synchronize_srcu_atomic() calls spend their time
queued behind *each other* =E2=80=94 atomic alone has no sub-4=C2=B5s drain=
s at
all, and 40% of its drains take 8-16=C2=B5s, presumably contending for
the driver role and waiting out each other's flip cycles. With the
try in front, only the genuinely-contended calls enter the GP spin
loop at all.

I was initially dubious about that 326=C2=B5s max =E2=80=94 the slow path i=
s still
just spinning like the atomic variant, just with two orders of
magnitude fewer entries into it, so perhaps it just didn't hit the same
p100 in my test runs. So I redid it with the try-failed slow path
instrumented separately, and it does seem to be real. Of ~5M drains,
3474 took the real GP slow path: avg 13.7=C2=B5s, max 326=C2=B5s, none over=
 a
millisecond =E2=80=94 and the *fast* path's max was 282=C2=B5s, so the wors=
t case is
something like interrupt noise, not the actual grace period. For
comparison, the expedited fallback was consistently producing drains
over 1ms (sleeping and waiting for the workqueue under a saturated
machine). There were about 100 such >1ms waits in each 300-second test
window (of about 60k fallbacks).

So the tail win over try+expedited is real, if we care about hundreds
of =C2=B5s vs single-digit ms. Which I think we do =E2=80=94 that's what br=
ings the
p100 to parity with the existing rwlock code (~330=C2=B5s on the same test)
while also scaling better on the readers and resolving the whole
PREEMPT_RT issue.

One thing I didn't expect: the try falls through to the slow path about
10=C3=97 less often in front of the atomic variant (0.07% of drains vs 0.5-
0.7% falling back to synchronize_srcu_expedited()). I suspected the
preempt-enabled readers in the latter, but rerunning that test with the
readers non-preemptible made no difference at all. So it's an effect of
the wait side itself somehow. It looks like the sleeping variant lets
the abusive invalidate/refresh cycle churn about twice as fast (11M
drains per window vs 5M), so the try observes readers in flight more
often? I'm not sure that higher throughput of the abusive test is the
metric we're here to measure though.

Could we put try_synchronize_srcu() at the front of
synchronize_srcu_atomic()? Without it, the atomic version is slower
than what I had before, across the board.

However...

Testing with my KASAN+lockdep kernels showed the p100 latency going up
to 200ms for the atomic version, while with try+expedited it was only
about 25ms (the same order of magnitude as the existing rwlock-based
implementation in the debug setup):

                    avg      max
  atomic spin       10.2=C2=B5s   172-212ms
  try + atomic      10.2=C2=B5s   173ms
  try + expedited   14.7=C2=B5s   25ms

Pinning the grace period driver with preempt_disable() didn't make a
difference. A sched_switch-instrumented run showed the >1ms tail is
bimodal: half the samples ~100% off-CPU (the *waiter* descheduled after
the wait was already over), and half genuinely on-CPU spinning and
waiting for readers.

So on a debug kernel under CPU saturation a spinning waiter has a much
worse worst case than a sleeping one; on a production-like kernel the
try+spin mode does seem to give a big win in the tail latencies that
Sean was concerned about. I think that's OK.

=C2=B9 https://git.infradead.org/?p=3Dusers/dwmw2/linux.git;a=3Dshortlog;h=
=3Drefs/heads/gpc-atomic-dev
=C2=B2 https://lore.kernel.org/all/05e5a29a95793651062dc5d165661b4d590f08ab=
.camel@infradead.org/

--=-tQVYW8/OCQIWLSirSMeu
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
whEQuAjjcikDEf96EeQgh8gAAAAAAAA=


--=-tQVYW8/OCQIWLSirSMeu--

