Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA95BC61DCB
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 23:18:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBDBF6B008C; Fri, 28 Aug 2026 19:18:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6E846B0092; Fri, 28 Aug 2026 19:18:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5D5C6B0095; Fri, 28 Aug 2026 19:18:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8BE926B008C
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 19:18:40 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 73EAFA0522
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 23:18:38 +0000 (UTC)
X-FDA: 85152244716.11.FB6B88D
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf20.hostedemail.com (Postfix) with ESMTP id 758B81C0003
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 23:18:35 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=YevmRlp7;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf20.hostedemail.com: domain of BATV+de67a59a32f6d1ab6349+8405+infradead.org+dwmw2@casper.srs.infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=BATV+de67a59a32f6d1ab6349+8405+infradead.org+dwmw2@casper.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787959116;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=hihRJ8iuSxuU8eVuGQI8DNgHFaTSUBfjYKtDHb3yM7M=;
	b=VFbyaZiw4u6jZqT6+MSKi2E2OLIH1msA5g/nowWVNokMJrUa9nIx3VEJ3NQTpYAOHQHDxw
	Na+IzQKR5cU6FEcYaTbdDhqU5vt2uzplPjTSWI24v+UZHCLQIEieSR/H3LYK/KHvVGY0DO
	UeigYlBHBX545LY6UVGRiJ76lSfIKY4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787959116;
	b=uxosMVgPLLghynxJmVCDPYB58riCodWxw2H0wTHGLo0gc3waR9m3LI8FdTIz1+9etHpen1
	z4wZ2tWV0KoEz+5VfYAELYH7sHNYpHOwtCYLepUGG0u9dylql++nsk6WfWJHphOl/VUPKd
	K7ciDi5F5+yBKALkmMjF7UVdK2OIAA0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=YevmRlp7;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf20.hostedemail.com: domain of BATV+de67a59a32f6d1ab6349+8405+infradead.org+dwmw2@casper.srs.infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=BATV+de67a59a32f6d1ab6349+8405+infradead.org+dwmw2@casper.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:In-Reply-To:
	Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:
	Content-ID:Content-Description:References;
	bh=hihRJ8iuSxuU8eVuGQI8DNgHFaTSUBfjYKtDHb3yM7M=; b=YevmRlp7VX0FvY4gNbWMsFN87s
	hTDwdqru4k5kHcOuCEY9loRxi83wVn/GGvvL8NukoZcCfgVaWrY2dA9pgi5OmRS6U72JFzsJ+jYFa
	UFBFdwBUzPqQYcsJsGiyy7oLn+36v0giB0m/dKmekEfZ7IdXwGH6cnQhZl9wS0BrP0OkBJ/eCBDw4
	zsVaGRYWQE2gW9IFV9mjBdm6+u8TH5z21d+0hXKmApRuXHxK8GqIjX+43Kh0grdPDDsDT+ObIb8KF
	R8RThyg+nyzTQ2sfCbLKA9esyGEwieltPNPuIBHCb4+7MSJmB0hBToiFs8Ue252AtUR6ewTbM537Q
	WGQsOPLA==;
Received: from [2001:8b0:10b:5:d89b:13dc:754b:b035] (helo=u09cd745991455d.ant.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x05q4-0000000FatN-2J9y;
	Fri, 28 Aug 2026 23:18:25 +0000
Message-ID: <f00f921f585e474782a9e3266be686286dceb31b.camel@infradead.org>
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
Date: Sat, 29 Aug 2026 00:18:10 +0100
In-Reply-To: <c39bda52f4c1573193aed39246f0d705755143fe.camel@infradead.org>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-qsebqL35CcBDV7Zxr63X"
User-Agent: Evolution 3.60.3-0ubuntu1~ppa9~24.04 
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 758B81C0003
X-Stat-Signature: btehfiqrzzbuugpp8d47yo7tuhebb4m1
X-Rspam-User: 
X-HE-Tag: 1787959115-654555
X-HE-Meta: U2FsdGVkX18jm7li4K4WO5UhB1sU89xC8TyBLQ4YDj+dXxDqoItV0X8soeIONDa+5ifzma6VVWx3cFnXE+5ys0OJaqw4WJitXg/H/QxCGcYzGEITSf4yexAfyjJSmLcdvM26NwLJycVk+bDlPrPim+2rhNP9u47M8Ydly4JfK5PnGAJbb/LzCIYZYaTm9o7OlX2ML0mJxDOXTpnboDQ3skatzI5BC8kW/os70GNgnpLAy9iZpwmxVz6AyP/Hmh9NigsfD6K2KxbYHSSUn8HYDt9gvu2agbNZ/8+TRN3UE+CZc3e6IsZ6HQn9zf36fuNt7xYCIauR4+WbeWTURQtPNpPfm7W7d83X1AjEUC8z3a35I5mKH3uC8ThUiBNtcoHeSxa57mh7vKjghhgzvXbHfYcSzomn2V3e+uuIH3zz804uVhe85ceSr9jSr0epK4CKsqRmT0nrzwK+LuhogXOqQUrZR1POHlr94nCtCBfeH3A/Ot6zMkXVw8rlkOZEK7nAVZFegj1vtVr3rUjpBCbUOS9KCwh3/PcP/Z0CkaMsfF2FXfnVmTe3NtWL+uYWW63iAUNvBGm/WPsZR8GFdleNtvSqK8oTAdmbbotb6IHPtU3CR3u1vnxXERj58hz4NgSul6RgXhslwZdDg74PZEwrjEdSXB2Fp2yal899JCg/MgTLH9O2bemHgk8flmWnY4almNB8JOc7V8YKDAB42AgmJ4mluGN9yr6hygtw1l2Bk7b1US4GA7J2PYKyRUDU5Yljt1VrKWRqWxlmKphd4BPDORETdaMspocQOd+r+B4rB5fiopNPYWov5gv2Me9Zan+mU/o38yqXX4mIKYYaNvmtdo4eteywgw/mrMTYhd61xTr8qcGcqsfYnKBcKmJKH+jZEB6IJN38JYNzE+9X9CHhVvzvC9+0+AlLuLI7kCNvE0bf++3NkmSN6xuWnx5171vq5ENykLEZQuh1zRIgq12
 elZ6tmHk
 3NjISP9WGKdqhb04ndEZhUT73bAdr/Cu1hxgc4l9qKPaHn6ZG9tB/iOFb0bRNy4dnQLjwTPlHlXJrrE1DxHslUsfM1u1W2vbTCE/7QPCwpRWXn2J6Xqw6Fe2hSe4jkZ3EZvvectBAjOtnSGd3yGBLsvmzxRow3Ej4kWOEa8uouHM3OMdOXb4Buv0qe6EfXorr+I9ZZo6m3FxVrXIEhyPCXf1bG2k+x3XVIzME7DZyUmkcjXCIqRFOANG25w7NHdw75r0FoWYxdW33MKDNjQwGkbXe2cr4aYWdeC60vJz1lVosUTCiST5kq8G+fyF4IYQXveB5eK3VOcbP/AuJjpNbkRxyPQQjlbZLe4ZupBdzDQ26XYBejpTtz1E6U/bAl9JFziG+/Ez6R4I8i847UQCyodvMmJT4i7DjPFAxZHWSrs8V1OnYRB9S8LCSf33Tb0TUcv8Uk+QW+xonJmQoKaO7GAhDluAKfqQJ3MpugDMd9IGY8CCGV3Nvs5aWtaPfLqq+bEkHBlGyzlnudBStycsQgKVMnfH2o4O8SGgfsdS0h4IRbvmWY79kuVrtPejBxEk65Cpp3/L4MNnYxln+KQ7lfXSX3u+SR1cqX+DEtgGHglaBQL+UQ0HzZ8EwhSkvDxv/A4TFS6Dzaqyr9Ny6wuyL72C9JIESreRnQNOpNf3sjH3kKExYPTfvrIUwyRMv2FW60NX1pSXQnkYd7XwfN9oovXM22jm+RL9yezPuEiESM+/RWQ3pJNFHIYiihjhx1/8n0ezDymJho5eW8q9CCf9+Mgfn3Lst1ykBlUs37PwcvaGUEyylskWvcmT0mkIu7RZN/mvbgrAbvoyxpeI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--=-qsebqL35CcBDV7Zxr63X
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2026-08-28 at 00:25 +0100, David Woodhouse wrote:
> It's working; the latency numbers have been looking good in all of
> my RT/DYNAMIC and debug/prod-like permutations. Redoing on the very
> latest now...

Done, and unsurprisingly it didn't suddenly fall apart. I think we're
close (again, including the try_synchronize_srcu() part as I don't want
synchronize_srcu_atomic() without that fast path). Thank you for
working on this.

The GP latency never exceeded 1.6ms even with KASAN+lockdep on
PREEMPT_RT, and stayed under ~700=C2=B5s on production-like configs =E2=80=
=94 while
the rwlock it replaces gets to 3.9ms on RT and 15.7ms with the debug
options.=C2=A0Not that the grace period is the only thing we're optimising
for =E2=80=94 the read side also scales a lot better for concurrent access =
in
the Xen interrupt delivery case. And the guest-mode pinning fits nicely
into the RCU model as that's basically what KVM_GUEST_USES_PFN was
doing in the first place, even when the 'normal' path used the rwlock.

It has also soaked clean for 24h+ across three machines (ICX, GNR,
Milan; ~20h on PREEMPT_RT), with the syzbot reproducers plus nested VMX
and SVM guests taking madvise and memslot churn against their pinned
pages. My earlier tests on nested SVM were giving about a 20%
performance win on the L2 exit round trips.

I shall wait for the dust to settle on srcu_read_lock_atomic() et al,
and keep the rest of the conversion in the wings. Sean, do you want me
to repost it now to review the KVM parts properly?

https://git.infradead.org/?p=3Dusers/dwmw2/linux.git;a=3Dshortlog;h=3Drefs/=
heads/gpc-v3

    * ee0e24a0041b KVM: x86/mmu: Drop the rmap bit-spinlock entirely on PRE=
EMPT_RT (gpc-v3)
    * 51de7a793839 KVM: selftests: Add nested transition benchmark
    * 37c9400feec3 KVM: nSVM: Cache L1's IO permissions map pages
    * 1c10fdf9c46d KVM: nSVM: Cache L1's MSR permissions map pages
    * 7af4264346c2 KVM: nSVM: Use a gfn_to_pfn_cache for the vmcb12 page
    * de951cadb238 KVM: x86: Move nested GPC lock helpers to x86.h as kvm_g=
pc_lock_page()
    * f04543987d9f KVM: selftests: Add nested VMX APIC cache invalidation t=
est
    * 1b50353089d4 KVM: nVMX: Use pinned pfncache for L1 APIC virtualizatio=
n pages
    * 4ae1202ef919 KVM: nVMX: Implement cache for L1 MSR bitmap
    * 5102fb3c55fb KVM: x86: Post KVM_REQ_GET_NESTED_STATE_PAGES on memslot=
 updates
    * 47998916d89f KVM: pfncache: Return -EAGAIN for a lookup which hits an=
 invalid memslot
    * 2dab55238cd7 KVM: pfncache: Add guest-mode pinning (GUEST_USES_PFN su=
ccessor)
    * 9740a75db3d5 KVM: x86: Use gfn_to_pfn_cache for steal time / preempte=
d status
    * 3898f98ca5cd KVM: x86: Request the guest TLB flush from record_steal_=
time()
    * 0a06af648fa6 KVM: x86/xen: Don't dirty track "vCPU info" page
    * eef7b09e5b52 KVM: x86/xen: Explicitly tag "shared info" page as never=
 being dirty tracked
    * 99a7eae0266e KVM: x86/xen: Extract delivery of event to vCPU into a s=
eparate helper
    * f0162bb012fb KVM: pfncache: Use atomic SRCU for readers instead of a =
rwlock
    * 003716df6605 mm/mmu_notifier: Remove non_block_start/end() from notif=
ier invocation
    * 6d484ca99bc9 srcu: Try the inline no-readers proof first in synchroni=
ze_srcu_atomic()
    * 23f10e07aba3 srcu: Add try_synchronize_srcu() for callers which can p=
rove readers absent
    * 2a55908bb12d srcu: Keep a spare node array so srcu_gp_end() need not =
block in reclaim
    * cb117542cb92 srcu: Remove development pr_alert()s from synchronize_sr=
cu_atomic()
    *   02738b15e08c Merge remote-tracking branch 'rcu/dev' into gpc-v3
    |\
    | * 7b9f3a948136 torture: Allow specifying alternative ssh command to k=
vm-remote.sh (rcu/dev)
    | * cd71c7941b25 doc: RCU: Fix s/strategem/stratagem/ typo in Requireme=
nts.rst
    | * f1b2e15ef249 rcu: fix shrink budget underflow in lazy_rcu_shrink_sc=
an
    | * 8c9be6c76148 rcutorture: Synchronously wait for all rcu_torture_irq=
() callbacks to complete
    | * 48b4d9799efe rcu: Use IRQ_WORK_INIT_HARD for srcu's irq_work
    | * 260d0fdf6ea3 rcutorture: Fix divide-by-zero with fwd_progress_div=
=3D1
    | * 5d9c38fbf615 fixup! srcutiny: Add an atomic Tiny SRCU
    | * 7a263580788e fixup! srcutree: Add an atomic Tree SRCU
    | * c2225b77b028 srcu_tree: Disable preemption across synchronize_srcu_=
atomic()
    | * e56c969b6c7b rcutorture: Add support for testing synchronize_srcu_a=
tomic()
    | * 9a2e9996ccec srcutiny: Add an atomic Tiny SRCU
    | * 6cf65dd4d8fb srcutree: Add an atomic Tree SRCU
    | =E2=8B=AE  (older rcu/dev elided)
    * | dc14992a9abe KVM: pfncache: use a dedicated invalidation sequence f=
or cache refresh (xen-v3)
    * | a83533b07c67 KVM: x86/xen: Mark poll_evtchn accesses with READ_ONCE=
()/WRITE_ONCE()
    * | f578df3dda4e KVM: x86/xen: Take kvm->srcu in __kvm_xen_has_interrup=
t()
    * | 0e38de3983e6 KVM: x86/xen: Use atomic*() APIs instead of open coded=
 equivalents
    * | f6179ff87266 KVM: x86/xen: Use 32-bit atomics if vCPU's evtchn_pend=
ing_sel isn't aligned
    * | 9c3243ef9edb KVM: x86/xen: Use 32-bit locked bts for vcpu_info evtc=
hn_pending_sel
    * | 113a5ed7489f KVM: x86/xen: Enforce 4-byte alignment of vcpu_info re=
gistration
    * | 2505c393701c KVM: x86/xen: Latch shinfo mode in kvm_xen_schedop_pol=
l()
    * | 9dfe99cf7b45 KVM: x86/xen: Latch shinfo mode in kvm_xen_set_evtchn_=
fast()
    * | 59325fcde6db KVM: x86/xen: Rename max_evtchn_port() to kvm_max_evtc=
hn_port()
    * | 2d366afb5114 KVM: x86/xen: Introduce kvm_xen_has_64bit_shinfo() mac=
ro
    * | 2e26fc558ac9 KVM: x86/xen: Rename 'longmode' to 'is_64bit' in hyper=
call handling
    o |  (kvm/next: 76671054f9a1 Merge tag 'kvmarm-7.3' ...)

--=-qsebqL35CcBDV7Zxr63X
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
yu2qSIbXYDkp38cFgXVDQAMAAAAAAAA=


--=-qsebqL35CcBDV7Zxr63X--

