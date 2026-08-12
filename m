Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C22DC5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 16:20:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62F846B0141; Wed, 12 Aug 2026 12:20:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 607386B014A; Wed, 12 Aug 2026 12:20:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F8426B0150; Wed, 12 Aug 2026 12:20:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2321D6B0141
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 12:20:56 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A9A43A29F7
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 16:20:55 +0000 (UTC)
X-FDA: 85093131270.30.0175013
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by imf17.hostedemail.com (Postfix) with ESMTP id E4F6440006
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 16:20:53 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=iKik+rXH;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of 3ZJ18agYKCOsfRNaWPTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--seanjc.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=3ZJ18agYKCOsfRNaWPTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--seanjc.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786551653;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CEQ391AoIELd5ZL0TGv9zp+VHLeiMTcHE3SJdOMg5/U=;
	b=o9You6XtMVcR44D+1yyn3alINLSFmEbXzKYlueGXvBFbgDuof4iYQH7MtqqZqzFBwb1bCb
	9HmACKHYuahyAvnmTi1gzXmTCh96fd3g9qPt4ZK+uci0w+80eEDuWjpjwyDVblMOMYlJ7A
	4CHyv6h4gL3KFoxr8mpydbBwVl5AQ7g=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=iKik+rXH;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of 3ZJ18agYKCOsfRNaWPTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--seanjc.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=3ZJ18agYKCOsfRNaWPTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--seanjc.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786551653;
	b=bPfhiIJ3UwmnziZJGVOalZdjQVzkro/08DFJYMgJzVrCnagdPTcKorxfF5F/fgdDYUOuNt
	YmvkRE5wt5j31bYnj4Bw8uN+QTVIlxE+akiK/MD5pAXcK6bdWUX7QNkhFScm4UvdS3sfLh
	+E89lOGm8Ag7e+mMX1T7gHVzS0QbeBw=
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-38ecc48b3c2so1909246a91.1
        for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:20:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786551652; x=1787156452; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=CEQ391AoIELd5ZL0TGv9zp+VHLeiMTcHE3SJdOMg5/U=;
        b=iKik+rXHADa7Q/w3PBgwYetLyGQM82NkQC3hr7BVMHrpEZQ9kLfPECzL9s20VFy4F9
         Q4MF3yQoQmnaOIQMbkm08buzo4ydwh2U0/BKKFfUyezNRbRnDopPKGxBA+S6qleqz/UH
         /lTwo0wVity9lstPNNTL3hLLL94ul0CcT73zlzHDnetYO9EHARqDYmmbN+flT+6JAMTD
         i72GQ0vUDDpJTdXTzcr+Bx0jisk8QdvBR0QEaBUPKxcVXenQEkEsf/wXbJPc8veaaXUY
         KPGPcwuf6rD3vkMdte1DSBLKFMhghHvGlEeqnBWFPmBsY9Hm76+0NqHv+6gN44dz8C10
         3S9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786551653; x=1787156453;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CEQ391AoIELd5ZL0TGv9zp+VHLeiMTcHE3SJdOMg5/U=;
        b=HZJejSBdYUl5ENOfyhIS4pEKYTjTIq+fVc3r5PcsEPXW+5iMFPViWsIO7rl0xwvWLd
         Yf2RSZn+EfMnBJXJSz2aCNhegCN2yVxo+jvzUDH20+ZVLwxmuC9Rk3HHA+DmnMEZdpyF
         1khnbPTKpr9T/u0+Gq/qZ/iJtUVH4DiUUKDLRb0qG66zEInD7XTRluv5nNY08g4eT0vf
         dceujhR8iM9mahNAo82EHmitOLqmvMeu4oiyPUDqiOrSGSLjlbEwrvzO2e4UXdyaRPA4
         zKBD0e/BRLMYb5z58cNjyf4KM0FU1EQZtDM31VPA3EKyfkjGXxzEdlvydfzt/+WcBThw
         tJyQ==
X-Forwarded-Encrypted: i=1; AHgh+RqLRTA5raSVzi3YB162CfhMQTdw+72C2rWJIvHNHsz2Z+1UmqFG4i7dxo6EEsoTsG/Iq5GCUyklEw==@kvack.org
X-Gm-Message-State: AOJu0YyYABispJKaeY6t/tGmZdppM/7/s/TrBsvnAGKYnkkn6OnmaCu2
	4QwIc72BlkeTu8XMyKOHRGTZT2Rl0+/5Wkm+TSfEz4zMggyjRxT5iixUIkFSX435aNqkhxko2xw
	QjZ1bQQ==
X-Received: from pjbbb8.prod.google.com ([2002:a17:90b:88:b0:38f:dee9:ffd9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:57c6:b0:37f:c22a:c188
 with SMTP id 98e67ed59e1d1-39301285e89mr7098236a91.4.1786551652307; Wed, 12
 Aug 2026 09:20:52 -0700 (PDT)
Date: Wed, 12 Aug 2026 09:20:51 -0700
In-Reply-To: <d0692500893f303906fba1d7d596eb59a07a806a.camel@infradead.org>
Mime-Version: 1.0
References: <37b83b429b9f14ea6ad4ca1c13cc8e565ec09033.camel@infradead.org>
 <anwraNIKJV8zwrNT@tiehlicka> <44c51ace9b0dc44b795f6f48c91cda440eed910b.camel@infradead.org>
 <20260812122759.GA662699@ziepe.ca> <c41c52f02f033ea980d4b5f9b8239d5e9411a03c.camel@infradead.org>
 <20260812134934.GC662699@ziepe.ca> <a48e6e7063122b22a8083bb0792984a204f316e6.camel@infradead.org>
 <fb87f673bf290cad133d113dbb0750a7752b9d30.camel@infradead.org>
 <a94b75e8b9b1d2191f365c0f4275fd5082332df5.camel@infradead.org> <d0692500893f303906fba1d7d596eb59a07a806a.camel@infradead.org>
Message-ID: <anydY25Cl78l1HfU@google.com>
Subject: Re: [PATCH] mm/mmu_notifier: Remove non_block_start/end() from
 notifier invocation
From: Sean Christopherson <seanjc@google.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Michal Hocko <mhocko@suse.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, 
	Simona Vetter <simona.vetter@ffwll.ch>, 
	"=?utf-8?B?SsOpcsO0bWU=?= Glisse" <jglisse@redhat.com>, 
	"Christian =?utf-8?B?S8O2bmln?=" <christian.koenig@amd.com>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-mm@kvack.org, kvm@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
X-Rspam-User: 
X-Rspamd-Queue-Id: E4F6440006
X-Rspamd-Server: rspam07
X-Stat-Signature: kibi8pbr3x3p5yeyrh8txb6ye9uezfws
X-HE-Tag: 1786551653-717802
X-HE-Meta: U2FsdGVkX1+1mSmaDWYcfRaOdt/POuYRvlrC+SFiJiXIiq2fayz3bLLk7SyeLKrQ4oKTJNOaCfPLPIm0di3yqkzrr8sC3NlINBmfRXyxmLhVGQ6KT8Dsj0aho+SkpXrKNtYG0rHASzUnKZtR3r8VMrzLlJRM+qq892x8KjxpKUK09hLDp3Ke76kSHAQFAfu2Bo6UFvJ74G4Fx2h9BF0GB1QYtTydbGWvLfDEA11rrkNg+KZjeUSMemMxUo88ualYw91HobwKfimqFgadbnXk5Qbimz7nKGSr2Qded4z2FjlLsp++3SBtSyDnY9oO2PttdhKI1QUtpzVAJR7vE2pBqTtpl9O7sosLRTQWPs1f5V8m87rBcRDQctvJRu0oLe01OD+9S5KL4aO65d6SRqJCco9y+ZniYuzpu8+cSMBu7aGK1lsw3KeShw/8MpKCTnMt0s2GqlQ9y2X9igLYsncx0qkT7v/xbMnafa6fhp0wTdRKqTyjPEuI4DueEhMw/eBB9c3j0R9ilnpK+e755M/VszsF7mkA/cs7KOPWSfSZU6h1Fd0ziRql8tgb6PjuNmEvpJEchz3qeWaJCKm90iTUwhGp5nM2m3SQto/u+R/4W49RRtMZWqADLWpIc8yDciMPhMN+BkmTC6xENugMT6rtzkJN+BE2u1dis/svBkbH0K9wGxTnEpqQReOwO0Qm9moYwQYftXfdZzV512x77+m/fv1/LFKAkM9MI3qkDs11kWJ8IGow0Hzsocs6PrOnLA7VwXDKP6SF0wbSuTAiW59y1B9AqfmfqnEA9GQR6F8U7J253XIlyPOHBtLOKPhsV94RkXTm15DanDhtfR1HEX6aEeIgW1AC7fIO0GjkcqT1yMlbVVHaJPpMUxpUUsoWpph+lRr2KN3oefrNI1z0++RYFKLmoeAKcYxf3wUAeIz7mfxGSkbLFQBZnvFBDlSOy6p92Bru9v9Vcn9V9duLBGy
 KYhiF+Cn
 PCwReTIg/kw+Wjy40J5CdK6anSL9PJ9FVW56Kig3Hw3aLO67hR/gXuB1qgvXOLKf2KwGc/fg47h9XLW9/kfqscdILrm3+Gj/YXMy5+K7KJDODlmF/hD4ASk2NM4nK0OXwnMnoIpnFSoakNmcKuWJC8Zv89tfjXFtMb6J53KlU+bj++/5BJlWd9BcdwFZvm1QKxvaxAik15vMi8Tmajb9VJLdsi4fXtWhUA7Hb/8wN9WRItleqnFyjZaFhsPZS/0cnGBKqLOvjbV0G4RX/30KH2+OUx5TAFE+JX1m7cQnDOpRZGlD44pxNlXqkyOH4i6BafQ/Uf5xOPY+8LR2S2PR9pihFjYMd7dEVSHd0n7xXHdsUlNH/cUWRoJuhyxsnOfMotzP992m/fZ2FxMPFkB6EHz0mH/GcCyqKBuU6+4ubzOznKfLpCy3D9crvG8AAdfJsPIHkQFNV80hp/OzWcPWyVjSYO2aqjga5IZv4ipcTSYDk4uhL2BSmAkE4/OrbFbxybOkO6U6GWCScXdistuwORQ61R04YkT34SqA4VM66hZaKPFVbDUtp4TcIz7qXHjR/hDUBHPxYkmJp+puMNsQHdDEo1J0M6WWcaW9Z+CuOd12qooGJztJDkrJI48cZBxIEc4+Da4drF+gfkZrwGT3UwraazVR7Do16MhWzi2TkG7n8/gnzOz6hEsDK9dm54w9weEjvPEu7SpXJMclEYuUrz3JUYA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

T24gV2VkLCBBdWcgMTIsIDIwMjYsIERhdmlkIFdvb2Rob3VzZSB3cm90ZToKPiBPbiBXZWQsIDIw
MjYtMDgtMTIgYXQgMTY6MDMgKzAxMDAsIERhdmlkIFdvb2Rob3VzZSB3cm90ZToKPiA+IE9uIFdl
ZCwgMjAyNi0wOC0xMiBhdCAxNTozNCArMDEwMCwgRGF2aWQgV29vZGhvdXNlIHdyb3RlOgo+ID4g
PiBPbiBXZWQsIDIwMjYtMDgtMTIgYXQgMTU6MDUgKzAxMDAsIERhdmlkIFdvb2Rob3VzZSB3cm90
ZToKPiA+ID4gPiBJJ2xsIHJlcGhyYXNlIHRoYXQgZm9yIG15IG93biB1bmRlcnN0YW5kaW5nOgo+
ID4gPiA+IAo+ID4gPiA+ICpJZiogd2UgZ28gYWxsIHRoZSB3YXkgdG8gYnVpbGRpbmcgYSB3aG9s
ZSBTUkNVIGZsYXZvdXIgZm9yIHRoaXMgKmFuZCoKPiA+ID4gPiBpbXBsZW1lbnRpbmcgYSBzcGlu
LW9ubHkgdmFyaWFudCBvZiBzcmN1X3N5bmNocm9uaXplKCkgd2hpY2ggaXMKPiA+ID4gPiB0YWls
b3JlZCB0byB0aGUgYXRvbWljLXJlYWRlciB1c2UgY2FzZSwgKnRoZW4qIHdlIGRvbid0IG5lZWQg
dG8gcmVtb3ZlCj4gPiA+ID4gdGhlIG5vbl9ibG9ja197c3RhcnQsZW5kfSBndWFyZHMgYXJvdW5k
IHRoZSBNTVUgbm90aWZpZXJzLCB3aGljaCBhcmUKPiA+ID4gPiBiYXNpY2FsbHkgbmV2ZXIgYmVp
bmcgY2FsbGVkIGFueXdheSBhbmQgZG9uJ3QgYWN0dWFsbHkgc2VlbSB0byBwcm90ZWN0Cj4gPiA+
ID4gYWdhaW5zdCBhbnkgcmVhbCBidWdzLgo+ID4gPiA+IAo+ID4gPiA+IFllcz8KPiA+ID4gCj4g
PiA+IEZXSVcgaXQgbG9va3Mgc29tZXRoaW5nIGxpa2UgdGhpcy4gSSdsbCB0aHJvdyBpdCBpbnRv
IG15IHRvcnR1cmUgYW5kCj4gPiA+IGxhdGVuY3kgdGVzdHMsIGFuZCB3ZSBjYW4gc2VlIHdoYXQg
UGF1bCB0aGlua3Mgb2YgaXQuIEknbSBzdGlsbCB1dHRlcmx5Cj4gPiA+IHVuY29udmluY2VkIGl0
J3MgbmVlZGVkLCBidXQgSSBjb25jZWRlIGl0IGhhcyBpdHMgZ29vZCBwb2ludHMuCj4gPiAKPiA+
IFRoaXMgc2xpZ2h0bHkgcmVmYWN0b3JlZCB2ZXJzaW9uIGlzIHRoZSBvbmUgdGhhdCdzIGFjdHVh
bGx5IGdvaW5nIGludG8KPiA+IG15IHRvcnR1cmUgdGVzdHMuLi4KPiAKPiBXZWxsLCBpdCBzdXJ2
aXZlZCBmaXJzdCBjb250YWN0LCBhbmQgaXQncyBkb2luZyB0aGUgc29hayB0ZXN0aW5nIG5vdy4K
PiAKPiBUaGUgYXZlcmFnZSBpcyBiYXNpY2FsbHkgbm8gYmV0dGVyIHRoYW4gdGhlIHRyeV9zeW5j
aHJvbml6ZV9zcmN1KCkKPiBjYXNlLCB1bnN1cnByaXNpbmdseSDigJQgYXMgKmJvdGgqIG9mIHRo
ZW0ganVzdCBvYnNlcnZlIHRoYXQgdGhlcmUgYXJlIG5vCj4gcmVhZGVycyBhbmQgcHJvY2VlZCBp
bW1lZGlhdGVseSwgaW4gYXQgbGVhc3QgOTklIG9mIGNhc2VzLgo+IAo+IExpa2UgdGhlIGV4aXN0
aW5nIHJ3bG9jayBjYXNlLCBpdCBzdGlsbCBtYW5hZ2VzIGRvdWJsZS1kaWdpdCBwMTAwCj4gbGF0
ZW5jeSBldmVuIHdoZW4gdGhvdWdoICpkb2Vzbid0KiBhY3R1YWxseSBzbGVlcC4KPiAKPiBJIGRv
bid0ICpoYXRlKiBpdCwgYnV0IEkgZG8gcXVlc3Rpb24gdGhlIGJlbmVmaXQgb2YgaXQgb3ZlciB0
cnktZmlyc3QuCgpGV0lXLCB0aGUgbWF4IGxhdGVuY3kgYW5kID44bXMgbnVtYmVycyBhcmUgdmVy
eSBhcHBlYWxpbmcgdG8gbWUsIGFzIG15IGNvbmNlcm5zCndpdGggdXNpbmcgU1JDVSBhcmUgYWxs
IGFib3V0IHRoZSB0YWlsIGxhdGVuY2llcy4KCkJ1dCBJJ20gb2J2aW91c2x5IG5vdCB0aGUgb25l
IHdobydkIGJlIHNhZGRsZWQgd2l0aCBtYWludGFpbmluZyB0aGUgY29kZSwgc28gSSdtCm1vcmUg
dGhhbiBhIGxpdHRsZSBiaWFzZWQgdG93YXJkcyBjaG9vc2luZyB0aGUgbW9yZSBjb21wbGV4IHZl
cnNpb24uCgo+IEFnYWluLCBJJ2xsIGRlZmVyIHRvIFBhdWwsIGJ1dCBwZXJzb25hbGx5IEknZCB3
YW50IHRvIHNlZSBhIG1vcmUKPiBjb21wZWxsaW5nIHVzZSBjYXNlIGZvciBpdC4KPiAKPiAgIOKU
jOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUrOKUgOKUgOKU
gOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKU
rOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKU
gOKUrOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKU
gOKUgOKUgOKUgOKUkAo+ICAg4pSCICAgICAgICAgICAgICAg4pSCICAgICAgZXhwZWRpdGVkICAg
ICAg4pSCICAgICB0cnktZmlyc3QgICAgIOKUgiAgICAgICBhdG9taWMgICAgICAgIOKUggo+ICAg
4pSc4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pS84pSA4pSA
4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA
4pS84pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA
4pSA4pS84pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA
4pSA4pSA4pSA4pSA4pSkCj4gICDilIIgbWVkaWFuIGRyYWluICDilIIgMzItMTI4wrVzICAgICAg
ICAgICAg4pSCIDQtMTbCtXMgICAgICAgICAgICDilIIgNC0xNsK1cyAgICAgICAgICAgICAg4pSC
Cj4gICDilJzilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilLzi
lIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDi
lIDilIDilLzilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDi
lIDilIDilIDilLzilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDi
lIDilIDilIDilIDilIDilIDilKQKPiAgIOKUgiBhdmcgICAgICAgICAgIOKUgiAxMTjCtXMgICAg
ICAgICAgICAgICDilIIgMTMuOMK1cyAgICAgICAgICAgIOKUgiAxMi4zwrVzICAgICAgICAgICAg
ICDilIIKPiAgIOKUnOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKU
gOKUvOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKU
gOKUgOKUgOKUgOKUvOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKU
gOKUgOKUgOKUgOKUgOKUvOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKU
gOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUpAo+ICAg4pSCID4xbXMgICAgICAgICAg4pSCIH45NTBw
cG0gICAgICAgICAgICAg4pSCIH45OTBwcG0gICAgICAgICAgIOKUgiA4MzhwcG0gICAgICAgICAg
ICAgIOKUggo+ICAg4pSc4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA
4pSA4pS84pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA
4pSA4pSA4pSA4pSA4pS84pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA
4pSA4pSA4pSA4pSA4pSA4pS84pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA
4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSkCj4gICDilIIgPjhtcyAgICAgICAgICDilIIgNDJw
cG0gICAgICAgICAgICAgICDilIIgNC40cHBtICAgICAgICAgICAg4pSCIDAuMTBwcG0gICAgICAg
ICAgICAg4pSCCj4gICDilJzilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDi
lIDilIDilLzilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDi
lIDilIDilIDilIDilIDilLzilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDi
lIDilIDilIDilIDilIDilIDilLzilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDi
lIDilIDilIDilIDilIDilIDilIDilIDilIDilKQKPiAgIOKUgiBtYXggICAgICAgICAgIOKUgiAz
My42bXMgICAgICAgICAgICAgIOKUgiAxNy42bXMgICAgICAgICAgICDilIIgMTAuMjVtcyAgICAg
ICAgICAgICDilIIKPiAgIOKUnOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKU
gOKUgOKUgOKUvOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKU
gOKUgOKUgOKUgOKUgOKUgOKUvOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKU
gOKUgOKUgOKUgOKUgOKUgOKUgOKUvOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKU
gOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUpAo+ICAg4pSCIGZhbGxiYWNrIHJhdGUg4pSC
IOKAlCAgICAgICAgICAgICAgICAgICDilIIgMS4yJSAgICAgICAgICAgICAg4pSCIDAlICAgICAg
ICAgICAgICAgICAg4pSCCj4gICDilJzilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDi
lIDilIDilIDilIDilLzilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDi
lIDilIDilIDilIDilIDilIDilIDilLzilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDi
lIDilIDilIDilIDilIDilIDilIDilIDilLzilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDi
lIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilKQKPiAgIOKUgiBzYW1wbGUgICAgICAg
IOKUgiAzMi42TSBkcmFpbnMsIDEwbWluIOKUgiA0MU0gZHJhaW5zLCAxMG1pbiDilIIgNDAuNU0g
ZHJhaW5zLCAxMG1pbiDilIIKPiAgIOKUlOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKU
gOKUgOKUgOKUgOKUgOKUtOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKU
gOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUtOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKU
gOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUtOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKU
gOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUmAo=

