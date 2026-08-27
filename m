Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72342C61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 23:25:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28AAC6B0088; Thu, 27 Aug 2026 19:25:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23C4B6B008A; Thu, 27 Aug 2026 19:25:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 129FE6B008C; Thu, 27 Aug 2026 19:25:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D33856B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 19:25:28 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3FA66A0228
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 23:25:28 +0000 (UTC)
X-FDA: 85148633136.17.2DDA87F
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2012A40005
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 23:25:24 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=dvG50Ew1;
	spf=none (imf17.hostedemail.com: domain of BATV+c1916d6ed4e4ead05afb+8404+infradead.org+dwmw2@casper.srs.infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=BATV+c1916d6ed4e4ead05afb+8404+infradead.org+dwmw2@casper.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787873126;
	b=LdnutQMq2TA/CzrtdotuUvkUyHlyeXvuTINu4dr2bAAsYSxQ8bbfwXiZtafo7PKFZJ1h8+
	C/zJxhUiWMrk8rIIP6apXR7upN1hXAoN1mthdU5PWLLOVHgWoJUS8EGJMJ/7ed1ul59T2o
	+cL8Fl/cCVbg/ZhelK9Uee/xsJDe3o8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787873126;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1c3iG134Q9W/Fl8cKzlQDrUCGOgD3nxqoTYTVTZPXKA=;
	b=DU4aDBsuddX+V/37Y2Vtw/dvw+n2DGyU/AgMLaTnk1q29UsTwAHTFrK1nTnQpLnQdGZQSu
	Ig/xsHpKtZlITFyTGpRdHSenCyXbI8qSnn+ABrDIGjZPin0n3YUpMe64V1P3mNrpAZVzey
	xtAw1ZoZsDatkErTgpJ+1oZfGKbHSM4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=dvG50Ew1;
	spf=none (imf17.hostedemail.com: domain of BATV+c1916d6ed4e4ead05afb+8404+infradead.org+dwmw2@casper.srs.infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=BATV+c1916d6ed4e4ead05afb+8404+infradead.org+dwmw2@casper.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=1c3iG134Q9W/Fl8cKzlQDrUCGOgD3nxqoTYTVTZPXKA=; b=dvG50Ew1Manp3j2VbHcDC+lP9j
	b+cgn86ihF4KAt5AKE871FiyUw71S4CVxZvyiyBaKIU/qaQYRO308QksgzsmMa9i5s857n75V3CK7
	L/KiwNajSjpf46oYIlbta0fnLlMa+oI5Dd52KMEQ8e8bJtfBeXTGsCsCor7CzjruMSOYGF1Ys4TOg
	l9JwXjMxpgvDxY1BZ3Sfo/QkS6MtblgujWyQqVrLrfv1VR70ae+yOebong4gH3cWWGW3i+X56e+ad
	zys4zKV3DihgarYHpdQp3J6f39vPbU20bA8RlYBx/dYwypOJOwdyp2SWW83ucPfRHOdzowgdoxLWL
	nPNTQbHQ==;
Received: from [2001:8b0:10b:5:c5bc:77fb:75d5:ffaf] (helo=u09cd745991455d.ant.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wzjT7-0000000Ddf8-3XPa;
	Thu, 27 Aug 2026 23:25:14 +0000
Message-ID: <c39bda52f4c1573193aed39246f0d705755143fe.camel@infradead.org>
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
Date: Fri, 28 Aug 2026 00:25:01 +0100
In-Reply-To: <b0be19e9-b0ae-48de-bef6-d905ee007c8a@paulmck-laptop>
References: <333c4cdb-8f34-4e3f-a47f-961f47e089a0@paulmck-laptop>
	 <11dcf5a87125451897982f728c1f65a5151987e4.camel@infradead.org>
	 <69567965-48fd-48c5-abb6-0699d7f5bd16@paulmck-laptop>
	 <124af87fb49c267eeb26b8b4d952b9b1a5b3fb68.camel@infradead.org>
	 <9427a8e0-3ba6-4f31-a35d-54429bd7e071@paulmck-laptop>
	 <3d0463b6099d4fcde9a025a2f9e231d75303b61c.camel@infradead.org>
	 <b0be19e9-b0ae-48de-bef6-d905ee007c8a@paulmck-laptop>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-4qjmHOoyy117wguiDY5A"
User-Agent: Evolution 3.60.3-0ubuntu1~ppa9~24.04 
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2012A40005
X-Stat-Signature: yhx1ibe6o4m1pdwbcry3o3kr7ibutdab
X-HE-Tag: 1787873124-900954
X-HE-Meta: U2FsdGVkX18A43E1xBIVsMC6UD9d1nnwqgE3isTxmvNQPQmHYZsA0862wMUYe6uVG17u4N5VoGdHMbdpzfI/Po/u2k+QJYzcmioehgJaOmN1QQGRoX5fKere2pZb57Bd/9qZ2Y6ndOGnKIzffS99aZVGqrYcruVmKZfBjskuqLasljI2hLKi8gEgKrhRBd+6+2PzWznEV0vwokRtytlHWMv8vkogeuYPwYGL5qwqFno3OlSqh6vZnNCgVlIIfMsCmwVmC3eDXFQxwasqNE1RSwgdEinKDiDNwRXs235VPJodCCgASp91eKV4mRljf48m3nzhB8jtrF3yfY28CU+t3UT4Oo6AzWLAOmF/L29qjyP+AKOASs5NopHUWeE/FCicMQhVBP9mdcK0/amFySVmt0lZ9SdOhk6KZJyCphMrCZJNXpqF/41ldQ36sRuU0XnOZQ+l9keVPKDlAiy4rfTa+FZSUVaSelee9JJ4sVNOlA9qlmmcS5J2NDDijhhpToeVg98ONeirMDjb19uLQwwqu9Ax1L3q+pcJu2CyBof48yP58iuNjDkmM9YBRAJNcq2ST7EE5ykIjJFH45N3og3SD5gxonGUknxPwmVVa4XG4aIfj8MfQeMsVQhjINc19cM0IqU11vFDw2C6mNP5NA+jNebCC9yBVXwHevhCbYP21T0BDXokL6uXPEgPMe5DwTVSLmbmWB9mQJHtduT0ybgyTgmcf4W0HcebC0gja3Pa2d4rpbjy4WMwKiUdZye/35Nub7v6ZY2diY6CHvPdU3Q30Cd9da6ZpYKvr1gRHTFhdtQexQphNxKGU5NIaaigdzlcCELlTLa/AXDlonBQj4b0OjDb5V/1uF/JJbLZ5GeGLyf6URnAcRTIWMhNCdejqFQcZRnH2ss3HJuEif6Fowzf+skK6rkiKs9C7/b9XhrYjSiqeqoRl9OPByElMqp0FxFN3vuldR3T5mhoQTLXDBG
 0i0GJw/A
 Ax3oBysUmh6Z8M52cGLq4FVRtZRAXBy4qWoaqLWXnKeH5DKoYqkj8un6ZuEtfRlaNW8luHUt34txbonASsHvSolAjjrV4N5J70LL4zyLck9AradgRNNkFesDJBgn5MGkfUD6dcd+DOfDuEhyZt3Eqvc4bElQwQ7Ip8HBPcNUkx8gtwK6QroY3dPFwT+PXuxuCNy1yyVcuQHXqpkjAD9JYEd8Z8x0v8owD1Cwyl/fGsE3CoLSxfx7qTWXSpmjw1Flf+2x7ZcFj2NJz4Fis8MQfEUWB8Q6P4p6VU4txYUK5SHWkC7MCv9WzM6cGw5ACv2eCB/mDBnlC/buMXu1+umOJIsXD/2wP5cWoBCiMGqgMW/TPurW3vazpslKOAVMCtn3V3ChfOFNqCFS0vlRe0LolR4RNv1g9jbVassZoyLqVqAN0XRFjnyCuwaySnmc0QQg03JflxKy7wWTEPK/wp83dJsnqnAUhxw213PmbeEhSV7QhR9J3JSa0HbWr7jX2NXPiohQtpFfzb4Lcs1gCmgMneZd3mSdYIudbetFMKfNfuGdXhyL3k3DseJjiT0sl3+eLl0g73vR1kVtZnFfkwG+vdESKfYnVIhi0uIPrseBMog9ket1uwDCt/JJPirGQ1SstaTmUCFFPTi4oxrWm1UfdfkdNJGn3244vqSyMCtQdoR9Nn7IfwKO+lpjh3gCzis/xebC8y+Og4Q2EpCHJoiefYluWUpOu/fiswUkwleoquMaDgnYpXFKS4Jaf0eK3QYq8y3no0AdusLvT+BNhSE+hNZL0lASJ0lTjIOpFDJWGurOEkNZ6FllmtGSMcYH1POAmM3Us1wW+vBocsp0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--=-4qjmHOoyy117wguiDY5A
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2026-08-25 at 11:16 -0700, Paul E. McKenney wrote:
> =C2=A0
> > > Suppose that there is only one CPU, or, alternatively, that one of th=
e
> > > atomic SRCU readers is pinned to the same CPU occupied by the (higher
> > > priority) task running synchronize_srcu_atomic().=C2=A0 In this case,=
 the
> > > call to synchronize_srcu_atomic() uselessly burns CPU time until its
> > > priority decays, real-time throttling kicks in, or in some configurat=
ions,
> > > maybe never.
> >=20
> > I certainly have no problem with a blanket preempt_disable() around
> > both sides for algorithmic reasons. As long as we aren't *just* doing
> > it for the selfish reasons I described.=20
>=20
> Suppose I simply disable preemption in srcu_read_lock_atomic(),
> enable it in srcu_read_unlock_atomic(), and disable it internally to
> synchronize_srcu_atomic()?=C2=A0 It might be against all RCU tradition,
> but might also be easier to use.=C2=A0 ;-)

Which indeed you have done in commit c2225b77b028 "srcu_tree: Disable
preemption across synchronize_srcu_atomic()" so I've dropped that hack
from my side. The important RCU patches remaining in my tree are the
addition of try_synchronize_srcu() and then using it as the fast path
of synchronize_srcu_atomic(). I've stopped bothering to test *without*
those.

Since it looks like I have successfully nerd-sniped you with the srcu-
atomic concept, I've reworked my tree to convert directly to that
rather than first converting to SRCU and then to atomic in a later
incremental commit.

This is what I'm now testing, in=20
https://git.infradead.org/?p=3Dusers/dwmw2/linux.git;a=3Dshortlog;h=3Drefs/=
heads/gpc-v3

It's working; the latency numbers have been looking good in all of my
RT/DYNAMIC and debug/prod-like permutations. Redoing on the very latest
now...

  * 1ccf7ba90f8b KVM: x86/mmu: Take mmu_lock for the lockless aging walk on=
 PREEMPT_RT (gpc-v3)
  * 51de7a793839 KVM: selftests: Add nested transition benchmark
  * 37c9400feec3 KVM: nSVM: Cache L1's IO permissions map pages
  * 1c10fdf9c46d KVM: nSVM: Cache L1's MSR permissions map pages
  * 7af4264346c2 KVM: nSVM: Use a gfn_to_pfn_cache for the vmcb12 page
  * de951cadb238 KVM: x86: Move nested GPC lock helpers to x86.h as kvm_gpc=
_lock_page()
  * f04543987d9f KVM: selftests: Add nested VMX APIC cache invalidation tes=
t
  * 1b50353089d4 KVM: nVMX: Use pinned pfncache for L1 APIC virtualization =
pages
  * 4ae1202ef919 KVM: nVMX: Implement cache for L1 MSR bitmap
  * 5102fb3c55fb KVM: x86: Post KVM_REQ_GET_NESTED_STATE_PAGES on memslot u=
pdates
  * 47998916d89f KVM: pfncache: Return -EAGAIN for a lookup which hits an i=
nvalid memslot
  * 2dab55238cd7 KVM: pfncache: Add guest-mode pinning (GUEST_USES_PFN succ=
essor)
  * 9740a75db3d5 KVM: x86: Use gfn_to_pfn_cache for steal time / preempted =
status
  * 3898f98ca5cd KVM: x86: Request the guest TLB flush from record_steal_ti=
me()
  * 0a06af648fa6 KVM: x86/xen: Don't dirty track "vCPU info" page
  * eef7b09e5b52 KVM: x86/xen: Explicitly tag "shared info" page as never b=
eing dirty tracked
  * 99a7eae0266e KVM: x86/xen: Extract delivery of event to vCPU into a sep=
arate helper
  * f0162bb012fb KVM: pfncache: Use atomic SRCU for readers instead of a rw=
lock
  * 003716df6605 mm/mmu_notifier: Remove non_block_start/end() from notifie=
r invocation
  * 6d484ca99bc9 srcu: Try the inline no-readers proof first in synchronize=
_srcu_atomic()
  * 23f10e07aba3 srcu: Add try_synchronize_srcu() for callers which can pro=
ve readers absent
  * 2a55908bb12d srcu: Keep a spare node array so srcu_gp_end() need not bl=
ock in reclaim
  * cb117542cb92 srcu: Remove development pr_alert()s from synchronize_srcu=
_atomic()
  *   02738b15e08c Merge remote-tracking branch 'rcu/dev' into gpc-v3
  |\
  | * 7b9f3a948136 torture: Allow specifying alternative ssh command to kvm=
-remote.sh (rcu/dev)
  | * cd71c7941b25 doc: RCU: Fix s/strategem/stratagem/ typo in Requirement=
s.rst
  | * f1b2e15ef249 rcu: fix shrink budget underflow in lazy_rcu_shrink_scan
  | * 8c9be6c76148 rcutorture: Synchronously wait for all rcu_torture_irq()=
 callbacks to complete
  | * 48b4d9799efe rcu: Use IRQ_WORK_INIT_HARD for srcu's irq_work
  | * 260d0fdf6ea3 rcutorture: Fix divide-by-zero with fwd_progress_div=3D1
  | * 5d9c38fbf615 fixup! srcutiny: Add an atomic Tiny SRCU
  | * 7a263580788e fixup! srcutree: Add an atomic Tree SRCU
  | * c2225b77b028 srcu_tree: Disable preemption across synchronize_srcu_at=
omic()
  | * e56c969b6c7b rcutorture: Add support for testing synchronize_srcu_ato=
mic()
  | * 9a2e9996ccec srcutiny: Add an atomic Tiny SRCU
  | * 6cf65dd4d8fb srcutree: Add an atomic Tree SRCU
  | =E2=8B=AE  (older rcu/dev elided)
  * | dc14992a9abe KVM: pfncache: use a dedicated invalidation sequence for=
 cache refresh (xen-v3)
  * | a83533b07c67 KVM: x86/xen: Mark poll_evtchn accesses with READ_ONCE()=
/WRITE_ONCE()
  * | f578df3dda4e KVM: x86/xen: Take kvm->srcu in __kvm_xen_has_interrupt(=
)
  * | 0e38de3983e6 KVM: x86/xen: Use atomic*() APIs instead of open coded e=
quivalents
  * | f6179ff87266 KVM: x86/xen: Use 32-bit atomics if vCPU's evtchn_pendin=
g_sel isn't aligned
  * | 9c3243ef9edb KVM: x86/xen: Use 32-bit locked bts for vcpu_info evtchn=
_pending_sel
  * | 113a5ed7489f KVM: x86/xen: Enforce 4-byte alignment of vcpu_info regi=
stration
  * | 2505c393701c KVM: x86/xen: Latch shinfo mode in kvm_xen_schedop_poll(=
)
  * | 9dfe99cf7b45 KVM: x86/xen: Latch shinfo mode in kvm_xen_set_evtchn_fa=
st()
  * | 59325fcde6db KVM: x86/xen: Rename max_evtchn_port() to kvm_max_evtchn=
_port()
  * | 2d366afb5114 KVM: x86/xen: Introduce kvm_xen_has_64bit_shinfo() macro
  * | 2e26fc558ac9 KVM: x86/xen: Rename 'longmode' to 'is_64bit' in hyperca=
ll handling
  o |  (kvm/next: 76671054f9a1 Merge tag 'kvmarm-7.3' ...)

--=-4qjmHOoyy117wguiDY5A
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
UGU1XTNayRaNqua5TERfZj4AAAAAAAA=


--=-4qjmHOoyy117wguiDY5A--

