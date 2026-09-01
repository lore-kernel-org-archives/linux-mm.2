Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28519C61DD6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 22:54:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 264006B0095; Tue,  1 Sep 2026 18:54:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EE2C6B0096; Tue,  1 Sep 2026 18:54:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B67B6B0098; Tue,  1 Sep 2026 18:54:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D16476B0095
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 18:54:02 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6158E140570
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 22:54:02 +0000 (UTC)
X-FDA: 85166697924.21.D8C99F4
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf08.hostedemail.com (Postfix) with ESMTP id 4A74516000E
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 22:53:59 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=jDWrOyPy;
	spf=none (imf08.hostedemail.com: domain of BATV+fcddca146e1c445db929+8409+infradead.org+dwmw2@casper.srs.infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=BATV+fcddca146e1c445db929+8409+infradead.org+dwmw2@casper.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788303240;
	b=jWKWk6AIm+/ZujgD6Bc7D7lDLueAyEiT3kuJLoK4eSSbyjRhcrX7j3i3+kgf4TmoGV9Mq/
	giGnNL45+aOUDmZVLZ++1BjJEQlrsS7M63oNFkp5HdmGIfcEHHVRjsAbFO4lgZxpxC8knY
	L1kFunYjmFqh1eSsOOCoKMfPywUjTEA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=jDWrOyPy;
	spf=none (imf08.hostedemail.com: domain of BATV+fcddca146e1c445db929+8409+infradead.org+dwmw2@casper.srs.infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=BATV+fcddca146e1c445db929+8409+infradead.org+dwmw2@casper.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788303240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QZ4SRhoz/1vFsTh9F518CyQRVF3nCqU7OfLuICgZ8tI=;
	b=hiFq8Gg52fuK9uI4s6YQwVrzmGY7MZUjLZv64KmidNa03RqKfgVyMR76q5cDSfCq9S5VgX
	p63o5p2gQPXGEaVOVS3D99KvFTR02E3poBavPT2mI8/Ue+ywwk6igGdzAQVdzvOaJUnPlj
	XSUmtXeNP5gj9h/z9pz9VyS8pihvGEU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=QZ4SRhoz/1vFsTh9F518CyQRVF3nCqU7OfLuICgZ8tI=; b=jDWrOyPyPYSijvGUkZiigBZs9l
	gZ3WIx24TQZKtFXc8UYXHc9Fh/2Ebf8lLWbH4XWOArxmHAzXSCefbZKxBYFvj4y4Msafw6nLqV7Xn
	+FD6ExFS0dh9zfsGtUL2vooqUnG5hsFsy9WzDWJ/95KRxTpG5jZVihDJsRmAahvJUgSlEOmejALi1
	8i5/mgOZA72lUyG0luVx0qYzZJqVdYXu4RI+/Gia2Us0bkh+bZDC6sPOkzGWgB04O4BTn8ZmsooH1
	EaM0tsGmme8Vuv4d682pO1gADrNe34m2TslxWpkJIHef5zsgQ9ois5g6Xj7PuMXJqdR1aDjv3gpFZ
	6kPvJzLA==;
Received: from [2001:8b0:10b:5:d943:510:b128:832d] (helo=u09cd745991455d.ant.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x1XMR-00000005tLS-3P1p;
	Tue, 01 Sep 2026 22:53:48 +0000
Message-ID: <19e2a25c50a551398dec060fe0e5d3720b027ad2.camel@infradead.org>
Subject: Re: [PATCH] mm/mmu_notifier: Remove non_block_start/end() from
 notifier invocation
From: David Woodhouse <dwmw2@infradead.org>
To: Sean Christopherson <seanjc@google.com>, "Paul E. McKenney"
	 <paulmck@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Michal Hocko <mhocko@suse.com>, Steven
 Rostedt <rostedt@goodmis.org>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand	 <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett"	 <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport	 <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Simona Vetter	
 <simona.vetter@ffwll.ch>, Jerome Glisse <jglisse@redhat.com>, Christian
 Koenig	 <christian.koenig@amd.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	linux-mm@kvack.org, kvm@vger.kernel.org, linux-rt-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Date: Tue, 01 Sep 2026 23:53:26 +0100
In-Reply-To: <apdW2edsT_ZKfuUR@google.com>
References: <69567965-48fd-48c5-abb6-0699d7f5bd16@paulmck-laptop>
	 <124af87fb49c267eeb26b8b4d952b9b1a5b3fb68.camel@infradead.org>
	 <9427a8e0-3ba6-4f31-a35d-54429bd7e071@paulmck-laptop>
	 <3d0463b6099d4fcde9a025a2f9e231d75303b61c.camel@infradead.org>
	 <b0be19e9-b0ae-48de-bef6-d905ee007c8a@paulmck-laptop>
	 <c39bda52f4c1573193aed39246f0d705755143fe.camel@infradead.org>
	 <90d91673-a912-439f-98ee-e43285294486@paulmck-laptop>
	 <8cd4aa65b1b499d4c614aa4cba445b6aeb89acf7.camel@infradead.org>
	 <apcjs83XSU4Eb9hm@google.com>
	 <e3197a0a-e167-4ea1-bbde-9c7f11f42198@paulmck-laptop>
	 <apdW2edsT_ZKfuUR@google.com>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-0CqYliZsQwF5rEce3NVr"
User-Agent: Evolution 3.60.3-0ubuntu1~ppa9~24.04 
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4A74516000E
X-Stat-Signature: fq3si95ef5ihti8kqxn94gemwdhw9hca
X-Rspam-User: 
X-HE-Tag: 1788303239-561135
X-HE-Meta: U2FsdGVkX192nmRNSbmgWTnKwuTkKRjiZ7lpKblLnsWJWGFhorxTKwkgj/qmNuE1qpiCEjMlFvE+6l2yNoXVAP27ADfzswNLabiXl8i8BVLywMngJaj8+BSYR4tIwQR/T0IjaJzULawnzDGvtKIHKEohrMbEgJF0HnjLlmDXfchHbnwwmnZWs2fnCauMXL4N5TopKu1PXYuUJ09Nyz+8254P5CVvvx9Iruld265kBUvDzBhdzB/L9uAc+5zH7bAqJluoqKyaiPUKJ5yYmiwofI+Bw1H85libM+BvcpPT1HtOBPC/RWR4LOpUzRCQZVldwieHSq21MEKsP4OvwuRXvWA1CR1oH0Mas5BMrQiPoq6LEfz5wS2qZk0Obpug1/BPOPumM6Yec+7obygi7MvKvqKjafHFYG8QXz78I/fusfgZAlIfTIy+z/ivO0C1wrOjTeoYVSKojDJi2xfe6Lxk2WshNI5FUZzS38fAdbx1q8+IU5SVPdtYA/LR+lOnCXWADwChJOITxLnJpT0z/5UOvHbY4c88fB3bfbT+glIY0rsoyDm3Y5dhiJnmUfateSUQM64564tyKLlbMRKH/P2UklnJnHAHoAgooSU4mpjdyWkWwLlrwr5/nnLMIddb5kuCWA+xW3jrFTiXG2tIlDb+35VLmk/zI3KOXnw5a0Ch/fZHzyOAogJUo7YIQzWmVZZBuZk3AgMh2RE2ifPKeBbqZ4HWA1s19HezE6CO51PqTKrybvr/f+rAuZFahXWePJPPwtpNu9RJh95sfPwx49NiQvgFq9QM+hbi3zOWOCeas4HI0FNnG3nqdutn4U5Y1f8VEFEeerS6VUJbTBM+s8N69Btq2hqXXJ8g/yuXlp27T6PDLJ0QYqNx2oBsvFhCHZJaSbeuS4ngZsJapGU1ROXJS7jR/suAS1KYU/6uFW2C8mVzWCoeJE/yEGm94T2F7DG7djn5hNYuADd5LuFak5U
 fx4zIcRt
 dU9MuMJlNAn7c5sZCKligWFMU0ymjUEPjG61h+x8oZx3ccVGCHc+gOodIbREAKWYHHQDrkGspAQs61E82Gq0oPZbEiXtqsU8Ez0iL9DNFnxVigaoZvrAssgQedWIuxxTd3ow7lBZ7MxyaYolFMsvLCuWM468sfyEpoQG5QcYLil40C6Mh4cnZbnYif+DyNhMK3NmV7E1O0xIuraP98syKOKNXyK2PDUYxU3ym8w11bFJQJsggSyFtIqwPI9kVttr79tQgUBQpNx1Z5QZAcSDGODq36P71p2kuLd0aVmqCjQEiRU20+dKTlAJlmjE8ddogyYQ9dh23uSxFGtevn+dpSJDr5IxxN81BSoAoxnGMMqfpaHT07W9C7Szb3iwWQiK8mNoOJII2wEQicZ+01D3nM1NTdYONUM6ijWRHq31lgWVYKs2tGCUWZkSwgBDV3IOSaMRn+fifgIXyoJNVJkknzxT8X/8/2AegHxPKZ1ZvI03bkdYzjS0CzZfmz5rosIZ7F32HuyFjZl/xu9cou8ELxXzAkT7V42bF1UPBQm4SCU2o7zSz1VD+rYj7CERRHVoatI/LTSdAsG4WnACbDYCQjx+m4aUp8YSEL/Z5jmsXHqrwEvyjtjRfGH1idFHAzgjckjoD+aXG3ndiiS/A+IAYoJWsNoxzuXpkmHzPE1vas1k+RFhjiS50kiOwRAPOK0hMOwwUvZxRX8qMssRsNXKuN68RBfr9PfKf1Xi22pnbxp/M1WbqGf0EjPML32P8P38Id9cr2Db9WZP9mFi4dPrso6I/2mCOfCeTRUtCnjzF62z72bFZcWOjck+Vx/gCYIeGo974
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--=-0CqYliZsQwF5rEce3NVr
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2026-09-01 at 15:51 -0700, Sean Christopherson wrote:
> On Tue, Sep 01, 2026, Paul E. McKenney wrote:
> > On Tue, Sep 01, 2026 at 12:12:51PM -0700, Sean Christopherson wrote:
> > > On Tue, Sep 01, 2026, David Woodhouse wrote:
> > > > On Mon, 2026-08-31 at 17:58 -0700, Paul E. McKenney wrote:
> > > > > On Fri, Aug 28, 2026 at 12:25:01AM +0100, David Woodhouse wrote:
> > > > >=20
> > > > >=20
> > > > > > =C2=A0 * 23f10e07aba3 srcu: Add try_synchronize_srcu() for call=
ers which can prove readers absent
> > > > >=20
> > > > > I do not intend to provide a separate API for this given the poss=
ibility
> > > > > of indefinite postponement.
> > > >=20
> > > > Makes sense. In that case, calling it internally from the 'right'
> > > > places becomes important, as the callers who care can't do so for
> > > > themselves.
> > > >=20
> > > > We discussed the fact that synchronize_srcu_expedited() will also w=
ant
> > > > to use the same fast path.
> > > >=20
> > > > I'm also looking back to Sean's call_srcu_expedited() patch from Ma=
rch:
> > > > https://lore.kernel.org/all/20260309193059.2244645-1-seanjc@google.=
com/
> > > >=20
> > > >=20
> > > > > Due to differences in how VMMs manage guest devices, and in the
> > > > > architecture being emulated by userspace, some updates trigger ca=
ll_srcu()
> > > > > with concurrent readers (i.e. while the VM is active), while othe=
rs occur
> > > > > without readers, e.g. when configuring devices during a pre-boot =
setup.
> > > > > For the later case (no concurrent readers), using the vanilla cal=
l_srcu()
> > > > > is problematic, as it can kick off a normal grace period (totally=
 fine for
> > > > > freeing the object) and effectively transfer the non-expedited gr=
ace period
> > > > > to the upcoming synchronize_srcu_expedited().
> > > >=20
> > > > So the offending path uses call_srcu() and triggers a normal GP, wh=
ile
> > > > the victim calls synchronize_srcu_expedited() and gets stuck behind
> > > > that non-expedited GP.
> > > >=20
> > > > Sean, if the victim is the "no concurrent readers" code path, as yo=
u
> > > > said above, do you think the fast path in the victim should suffice=
,
> > > > without the cost of an expedited GP for every bus registration?
> > >=20
> > > IIUC, you're asking if being able to use try_synchronize_srcu() for t=
he fast/happy
> > > of synchronize_srcu_expedited() (i.e. for kvm_swap_active_memslots()(=
)), even if
> > > there's an in-flight GP, would suffice for a fix of the regression in=
troduced by
> > > commit 7d9a0273c459 ("KVM: Avoid synchronize_srcu() in kvm_io_bus_reg=
ister_dev()").
> > >=20
> > > If my understanding is correct, then yes, that should work, and presu=
mably would
> > > be a notable improvement overall.
> >=20
> > Then we could abandon synchronize_rcu_atomic()?=C2=A0 That would not be=
 a
> > bad thing from my perspective.
> >=20
> > Just to be sure, please note that synchronize_rcu_expedited() can and
> > sometimes does sleep in order to avoid odd corner cases that could
> > otherwise pointlessly monopolize a CPU.
>=20
> I think one (or both) of us is confused.=C2=A0 I thought David was asking=
 if we could
> avoiding adding call_srcu_expedited(), because the proposed try_synchroni=
ze_srcu()
> would fix a regression related to KVM's use of synchronize_srcu_expedited=
().

Indeed. This is a *separate* problem, for which you had previously
proposed adding call_srcu_expedited(), but it looks like having
try_synchronize_scru() as a fast path of synchronize_srcu_expedited()
would suffice.

We do still need synchronize_srcu_atomic() for the MM notifier case for
which we originally built it.

> I don't think that has anything to do with non-sleepable RCU?=C2=A0 Or is=
 there a
> separate discussion and/or implicitations I don't understand?

I think the lack of 's' there was just a typo. This is synchronize_srcu_ato=
mic().

--=-0CqYliZsQwF5rEce3NVr
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
4SY+6565Vr1iodHKY+h/lLkAAAAAAAA=


--=-0CqYliZsQwF5rEce3NVr--

