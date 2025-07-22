Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A695C83F27
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 14:35:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F16956B00A4; Tue, 22 Jul 2025 10:35:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC7806B00AA; Tue, 22 Jul 2025 10:35:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDD7F6B00AE; Tue, 22 Jul 2025 10:35:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CA8996B00A4
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 10:35:55 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 84821B9663
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 14:35:55 +0000 (UTC)
X-FDA: 83692149870.21.E85E619
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf06.hostedemail.com (Postfix) with ESMTP id AC58818000E
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 14:35:53 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=mXbhlP8i;
	spf=pass (imf06.hostedemail.com: domain of 3yKF_aAYKCFUF1xA6z3BB381.zB985AHK-997Ixz7.BE3@flex--seanjc.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3yKF_aAYKCFUF1xA6z3BB381.zB985AHK-997Ixz7.BE3@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753194953;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KUCGvGmWdwg0m3EIpNIWNp9O4aLo9Fe5P7KfBDNlB2k=;
	b=HFGD8XxVtOP0hIFDhS93mp9UDNEq+ySUvFfbD5D8NGvx9fbqUk/ZqZR+jAb+qkogXgJYYH
	YMX7ZTl3bn9TvoFOj+V2ev7c3bnp7nnlUIzlaAlrL4mDn5Yb6V6EuB5qoBBl4AuuqJXUn6
	+NYjP4zot94IFVo9vk2QBcEbMLO37U0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753194953; a=rsa-sha256;
	cv=none;
	b=tcWllNRRhiKVfynGSL881urJ+wo3yCzPiNU24Ntk1qCkNGXC51/+qFp6WPYiqcqBU8PgUb
	bE94wQ0tHGTw1Hs5UkIl7cDenN52kVp8zqEWEHCfu6HGomp/6wKDwPfUKcpPhsAkF+6NRN
	krDPU4d0sqqwXbzR0iL/d2IbVKJnHN0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=mXbhlP8i;
	spf=pass (imf06.hostedemail.com: domain of 3yKF_aAYKCFUF1xA6z3BB381.zB985AHK-997Ixz7.BE3@flex--seanjc.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3yKF_aAYKCFUF1xA6z3BB381.zB985AHK-997Ixz7.BE3@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-235eefe6a8fso42452795ad.1
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 07:35:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753194952; x=1753799752; darn=kvack.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KUCGvGmWdwg0m3EIpNIWNp9O4aLo9Fe5P7KfBDNlB2k=;
        b=mXbhlP8iU6oU8iVv7Nh0MuDfzDQOmft+vnQ2FcsI8wA0NOgi5HEUjnhgQAf2kdNz+k
         XXAIEYrkiApe8cz9I104Y66yZmbuDShhb7DlRib6lNjIEI57cOfbkPgSOeoI8lVnj4t7
         khSFdmqxDFcX1W+ooR8An3/KtzUb+OEec5kfadvInleWtIfcH1gDyrvQBBXlQGomtxay
         874dsVjNRblCCvywBBYKdqWta7XRCHJhVgvag8AUCHYA34udWsc/68dE1KVuiWisMviy
         Rc5/nltxelp+Oe72ADlqD7upcqv8p+3j/6BinIeDADMYSi07joe7Tmj4vUweG5ADoubC
         8Eww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753194952; x=1753799752;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=KUCGvGmWdwg0m3EIpNIWNp9O4aLo9Fe5P7KfBDNlB2k=;
        b=VstDNcTMSdUC9JepCLf4kZUSu3hUozwRGgiGONtw8qP7WSSioqrniUq3vKHd/uFudH
         qvA9pmBERyrLnLox+5kCxQSXL0VfvySmTXr4wVdW09K0Q+owBeQlvmiv9SVP1ERHGxRz
         OE0vcNYcAHhTEb/XhUlcQYin4tpqNYHDMGUdO6J9tHZHgRX6E3HtueVGl54OhS9Yuyfg
         dfgL+AhrT+W3Cqy1DIJyrTTERz33z6GI9MuJeo3mKaKz8Yvj3hoX7y4+Y4ukmsU4nNHW
         lBi79vfWPM9bGcbSnTILiQsXM3Yn0HgjqQS2x1vHcTmEUj1dZ+jWuJ40kMqQTJTaGX98
         JbhQ==
X-Forwarded-Encrypted: i=1; AJvYcCU68IUWngvXnSwQG3d/KSm7HFL3Wx8l2FRi+sVgSuCSlGilOsG/7nICGh5gYkOB6PjHjdtAv+hcAw==@kvack.org
X-Gm-Message-State: AOJu0YxLbfruU3l8rm5k+j3ZEMiZW8SvTzS9A1KqpVkWklp6UWpKt3Q0
	U4zy+15pguDo9i5qmEgjmn6NSXabZxjRwUBkYWvWLbLJNosSHF4AqXh/JVevF8yD0RL0eWY+std
	jJAsWAw==
X-Google-Smtp-Source: AGHT+IHc8QcIoTZ0c4wrEcszME7DPaA+xp/Za1q86kov57qJSFV6RsvFN0CRYQMoGS6Gqfb6Seefy3gIDqU=
X-Received: from pjyr14.prod.google.com ([2002:a17:90a:e18e:b0:309:f831:28e0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ea0d:b0:23d:ed91:6142
 with SMTP id d9443c01a7336-23e3b84e93cmr215232985ad.42.1753194952414; Tue, 22
 Jul 2025 07:35:52 -0700 (PDT)
Date: Tue, 22 Jul 2025 07:35:50 -0700
In-Reply-To: <CAGtprH_r+eQjdi8q5LABz7LHEhK-xAMi4ciz83j3GnMm5EZRqQ@mail.gmail.com>
Mime-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com> <20250717162731.446579-15-tabba@google.com>
 <505a30a3-4c55-434c-86a5-f86d2e9dc78a@intel.com> <CAGtprH8swz6GjM57DBryDRD2c6VP=Ayg+dUh5MBK9cg1-YKCDg@mail.gmail.com>
 <aH5RxqcTXRnQbP5R@google.com> <1fe0f46a-152a-4b5b-99e2-2a74873dafdc@intel.com>
 <aH55BLkx7UkdeBfT@google.com> <CAGtprH8H2c=bK-7rA1wC1-9f=g8mK3PNXja54bucZ8DnWF7z3g@mail.gmail.com>
 <aH69a_CVJU0-P9wY@google.com> <CAGtprH_r+eQjdi8q5LABz7LHEhK-xAMi4ciz83j3GnMm5EZRqQ@mail.gmail.com>
Message-ID: <aH-hxiD2DwovFpqg@google.com>
Subject: Re: [PATCH v15 14/21] KVM: x86: Enable guest_memfd mmap for default
 VM type
From: Sean Christopherson <seanjc@google.com>
To: Vishal Annapurve <vannapurve@google.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	willy@infradead.org, akpm@linux-foundation.org, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, 
	dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: AC58818000E
X-Stat-Signature: yasjfftj5kxdeq443ekf577i4n1jow5t
X-Rspam-User: 
X-HE-Tag: 1753194953-216634
X-HE-Meta: U2FsdGVkX19/eCvTWwYNtR9XaGuBX0OWr3dgXmLDred4s+8UkltWbO9y3MCDHlfnukJy0UfQS3iCBVFVJmudGuXICwjntXjV06KtrWSbDnTcHbgLwTH/qKCPEl968UvyFG0to1jypWU15/1KGY1wYoU7wD69t+mvJGralgdxjn3KnVNgGc7msKn4qLynErrRJpOAJcQE37xnpMVjr9rNUAk33TZZ9nAxpRkLoBRavL2GqvUkMcEEbKvpUUWzL6nJlzGLuAxugvscqXmUNzIqAoyngtlR2xbXh78e97jw2fiG/nLqf6wQb/knM/s0cnJpDS9ujkZQxFsiaXd7Hq6PJWRSlAVcVw+tLMi3fiosyYe6KbAHAZpeN+WSdpuy+IRapveHEzVZorvZ8owkMMVodYgLJFD9pSo42U/fMrRAjsagW/VJtx1UgM44VOn343yDRvewUS0EtjVgqOV9UC3H3mk7FoG4cwF0HpH36hpvLWXN4WK2R2ayY3159F6qfeWZ0l+9lLqtHqT0qM2dxH1qfda597UV6UPRxHAQBjeVz/EQI1uYosgdlzDDlF2nuWaGAASJK45etfRy1RTJwZKgMx4Q+6HPP0bVphCVOp6xRCScV0XiRgHH5BxdjDYMPzxqTb0CGXZ+pwIKb0uY+j9EfX7uWKOjeGAOQZrz3wRLZV4M5/HIE9JqMowhuSICVeEx47Boe7k0YQ9MaqjtH71YdLwnBjydu7QIBvcnzyKfZEMqjqNzAIYZ13iyGQ+ccp8IQcS3/WzEQnOgjdnew6jXl9U7DIyHLo0dfVNfzzc9GzseB0euiZi5jfswUKgA92v0PIBZg+YhQMzecjDr9500uBWDTc5Gff4kV0eNZo2JVS6JzERwPtvmnomDt+7q/umX3Mi/dAF1ssiRJmz7lMuZAhp5Fw9OMaOZwj99+XJMJUJGPwizLd1RVVfiMENt/+lQm++mvE03lPpJCTJWR3P
 7jQyOW2A
 0Tv2HsuWD6luWkzwc1i3ZfokVmq199LtEaNhj/WSt6fwQ9QpajTm65XHKPx0JS9S1Bp4i26RbP8f7RnlayiYlWYg2e0I8UTWiXdbdcLtmsxUzZwM66gzSviVym/SzctZ8IaxJlO8kPW8k1Ts9qS0XakP11lpbfN419IM3mozOyxINhPzxtMJkShbOB0nDVHEtylOwm8rpB073eY0AnsHRKgzJOEhV28WKHk7sws4X6FNrseDzkllNQbcWWgZ3QdQWBKpJPXBKN3DHOTQO3V/tAoX6HiYv0v17oIt3aGlaHqT3dVVZOkRGnMbg7yiJ2/0yZ7BtQWGaMxmyqcdLu0OPDtBUiy4aX/0Fm58sO0HDauhoFetRMsffd+LbWVhAdM+XEu3BINgL/1H4g8hIWvqiNFYvH57dFEkN077i7w6rt1xM3BB9j1h1YRo8eQSCpXEwVZys3cf+3cZlwfbbNRzHOdlMM/i53EHPES+tQNMTG7X0b+kKJmEdCb6OUN8PFlFa20+ADMy0K1E1Zu5Fi+MGXehIJNivx8WGn3PjCWpMwEjVfL6HZK0UynENepulYPd85fWOUukjYUuf4I5vUOGstm/SqTIRzbaf05N/hRc1rbDwlBawQHiXfuj2b4xwRm6YdDPYPrssLimR8p5i01eurcckvMj0K2ARnzAuccn+fR1064AQZ66t9JLzdawfaG5orkP6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 21, 2025, Vishal Annapurve wrote:
> On Mon, Jul 21, 2025 at 3:21=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > On Mon, Jul 21, 2025, Vishal Annapurve wrote:
> > > On Mon, Jul 21, 2025 at 10:29=E2=80=AFAM Sean Christopherson <seanjc@=
google.com> wrote:
> > > >
> > > > >
> > > > > > > 2) KVM fetches shared faults through userspace page tables an=
d not
> > > > > > > guest_memfd directly.
> > > > > >
> > > > > > This is also irrelevant.  KVM _already_ supports resolving shar=
ed faults through
> > > > > > userspace page tables.  That support won't go away as KVM will =
always need/want
> > > > > > to support mapping VM_IO and/or VM_PFNMAP memory into the guest=
 (even for TDX).
> > >
> > > As a combination of [1] and [2], I believe we are saying that for
> > > memslots backed by mappable guest_memfd files, KVM will always serve
> > > both shared/private faults using kvm_gmem_get_pfn().
> >
> > No, KVM can't guarantee that with taking and holding mmap_lock across h=
va_to_pfn(),
> > and as I mentioned earlier in the thread, that's a non-starter for me.
>=20
> I think what you mean is that if KVM wants to enforce the behavior
> that VMAs passed by the userspace are backed by the same guest_memfd
> file as passed in the memslot then KVM will need to hold mmap_lock
> across hva_to_pfn() to verify that.

No, I'm talking about the case where userspace creates a memslot *without*
KVM_MEM_GUEST_MEMFD, but with userspace_addr pointing at a mmap()'d guest_m=
emfd
instance.  That is the scenario Xiaoyao brought up:

 : Actually, QEMU can use gmem with mmap support as the normal memory even
 : without passing the gmem fd to kvm_userspace_memory_region2.guest_memfd
 : on KVM_SET_USER_MEMORY_REGION2.
 :
 : ...
 :=20
 : However, it fails actually, because the kvm_arch_suports_gmem_mmap()
 : returns false for TDX VMs, which means userspace cannot allocate gmem
 : with mmap just for shared memory for TDX.

