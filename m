Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54699C61DB9
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 21:18:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 672476B008C; Tue, 25 Aug 2026 17:18:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 623506B0092; Tue, 25 Aug 2026 17:18:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53AA96B0095; Tue, 25 Aug 2026 17:18:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 301436B008C
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 17:18:23 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A5BDCC0199
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 21:18:22 +0000 (UTC)
X-FDA: 85141055244.01.221E31D
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by imf29.hostedemail.com (Postfix) with ESMTP id F41F712000C
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 21:18:20 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=hM2GbUIV;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of 3mwaOagYKCDwqcYlhaemmejc.amkjglsv-kkitYai.mpe@flex--seanjc.bounces.google.com designates 209.85.215.199 as permitted sender) smtp.mailfrom=3mwaOagYKCDwqcYlhaemmejc.amkjglsv-kkitYai.mpe@flex--seanjc.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787692701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=96v/IU+xqfPxFBmAPsTHt7ENr2LiLEu2VL8xEjm4RVc=;
	b=gqmvXkcgh0UbpYOemn/zLZvQqcs803ZyvouwU52xQJPnNyf6j8pBu32B0t4GhVN29zLKPG
	/mKRxFEVHChzAQDlJn8XJC6ZZnPf1FxIz9EyekxDLJzYPcK0PX+aqxJkeTc0lvFdkW7JBT
	OCBHRqmvcG/N/jU+mPvOxfErPUUezw4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=hM2GbUIV;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of 3mwaOagYKCDwqcYlhaemmejc.amkjglsv-kkitYai.mpe@flex--seanjc.bounces.google.com designates 209.85.215.199 as permitted sender) smtp.mailfrom=3mwaOagYKCDwqcYlhaemmejc.amkjglsv-kkitYai.mpe@flex--seanjc.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787692701;
	b=qlCgcUUoefDZBGnZMx4EBH1Kdqglk3RuKrblfGURiziqXL+Kycq4RmATu3tCwK9N0tvkPj
	foNNsEGNMDm5Ry+Pp849D4vnFB3UFJc8Qlr3EX3tOQ3O9gA75YKMHh040fz1SnwMCh3XA5
	sXdic5hwmU03BZGMWN7zAa2x0dUFEQM=
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cc1b8088202so188758a12.3
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 14:18:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787692700; x=1788297500; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=96v/IU+xqfPxFBmAPsTHt7ENr2LiLEu2VL8xEjm4RVc=;
        b=hM2GbUIVK2RBkAUTPWigLOvQhEtJ304ZoUZzhom17pZKPnPp0w81kmMusgYi5c77fe
         34bKjG5/LdssQxxoIcnlJY1wRxrwyf23lKDen8iezNkJXgUZoM5WFaOw1e3sbbTbyUU+
         QM+EzfgtNuK4arABbiScJjnCrWwhwdBynwpI3yh20n+uG/s5YqwlUX73VyCiy1vPVPNN
         FzqzJO1BtpdVQ7OaGVc8mB0Iz6PPJBrILPpbCCmhNCwPYSnDUf3HUDXnXcf+5M9g1i0+
         p9v7+gWSxSCoDQ9J/QgndIDAuRX0ruLjmDPR9Ng501yRxhGR1+tnUl8M405WdJqtcqkk
         23/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787692700; x=1788297500;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=96v/IU+xqfPxFBmAPsTHt7ENr2LiLEu2VL8xEjm4RVc=;
        b=f5wObK2Tc1G+42+VL0TI+W24DXa61+lhqn6QzCfbfYzDM9KeiR+ntrDKxcytTyhUiW
         EFE69+gCGDooqzP9dqSLGSPeBaCEeMATM4lvWph1Q/5byLH3imRuHW/l5Nr9J9mLat4D
         QMSRxGAmzlUiyjDS41pCYNflGWFuN2V5MMO7LOi+EgMOhL9dOPIgH29G81IlgqwBMVW6
         CXsx0QtI2Z7/gX/fnHlSGVFgFpL/WNUD0OCPjMbw0zBDk+yS9IDpz+8VKPiu84BGvyR4
         QzjdvOnV0EAwQkLsKrS7IF78Lap0Jl8j5B+e3w6Csg7I2OvCbHl+RoH7T2ZxDHgPUvpo
         jWUw==
X-Forwarded-Encrypted: i=1; AHgh+RpihESCB4roX8cz8ANNZ4KlrQ56Ah71NYhqBkxtgGED43rBaCKu+hzV3G4z/zcL1Xpdrkmp251y1A==@kvack.org
X-Gm-Message-State: AFuF++lzq30kXtdIIlecJ8/015DgPcyULtADQxgG82uHzNxsqkunE5PH
	lqjHKiidbR6pBq4WiL4deO7766Rz9wqbHvPO3TOCdJW9twjh0HYHLi90yqgd1e4gwfDH4XhwKIK
	MkefwmQ==
X-Received: from pgp16-n2.prod.google.com ([2002:a05:6a02:62d0:20b0:c86:5f41:8c94])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:2290:b0:3cc:3d08:da3e
 with SMTP id adf61e73a8af0-3cf76286186mr2809631637.2.1787692699334; Tue, 25
 Aug 2026 14:18:19 -0700 (PDT)
Date: Tue, 25 Aug 2026 14:18:18 -0700
In-Reply-To: <CAEvNRgFhjbgC9Ng1qviPx4oE=qihUwiBcsYOgJG3yOU-nLG1hQ@mail.gmail.com>
Mime-Version: 1.0
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
 <20260807-gmem-inplace-conversion-v10-7-2fc18ee6d3ba@google.com>
 <a410cca6-0776-44af-8353-9b7375e2fd4e@intel.com> <CAEvNRgGvxMus6pp=xuDYOumH3Ge4oi0=YKjTaFykFHwXuzRDwg@mail.gmail.com>
 <54d1bd0e-c27a-4033-ab97-02cd9579a620@intel.com> <CAEvNRgFhjbgC9Ng1qviPx4oE=qihUwiBcsYOgJG3yOU-nLG1hQ@mail.gmail.com>
Message-ID: <ao4Gmn5tSZMhl_nX@google.com>
Subject: Re: [PATCH v10 07/41] KVM: guest_memfd: Stub in ability to enable
 in-place shared<=>private conversion
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, aik@amd.com, andrew.jones@linux.dev, 
	binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com, 
	david@kernel.org, jmattson@google.com, jthoughton@google.com, 
	michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	shivankg@amd.com, steven.price@arm.com, tabba@google.com, willy@infradead.org, 
	wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
	pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
	liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
	Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: F41F712000C
X-Stat-Signature: qr6z5zkt333w4yssjipu5gtreo7hkpc3
X-Rspam-User: 
X-HE-Tag: 1787692700-341580
X-HE-Meta: U2FsdGVkX1/uEjONlv21LVu76HBsmSCc+t8igg3xYyWBomxjLEaLmMajlYOSpaGPtY/jYVmkfiAwUijhEZPbvPPipe+AaUWMBUEEmUmhCmnUZvQDRqjTZI6hfAHd7Dgx60vTgMeO3PUBvYjH2seCCvzuybmwwBiUtxsky7Kqq4nD/MDDVuAe+b0r9ZA1+/o6hd//MntjIXzBQniN1YLSo5lhG7BYOlagmnZBZd8VfZV6ytjKUeRYSsU08YuEcuzZ0nOMldaJVNzX+rjE8XUUiZQ0pq4/BvjHTF3m+Do/hBBKhEATUDIPFs8jOAgewDENESCR84wjEwkzw6IjFitvMrr4U2r4JDnW9a86E3+cCHkars+LJn1/I3cQusOlbA+YLayJ5ywKwko2DMsp0ryBNSOmP7e5yFc3GPOn1D9NKCCydb3RU4SkqKEtLfcL5Y05eC/+e5jNp0ReMk+icoBs4A/LB+jRkjvC9wVIKlp7NJy6GMAeavUpEPMnUhfjdJhGmuPiBwD+cYdoLi9MEaPrXKYDS4yqBK1RYj+4L3stT5xc1aTzAdQQSAAdzHh31nwQ0pcgM1tqt8gJed62w3RL8boGA0o2+jxE7jQkGtD5vHgBr/DKvH5tVauGE+vkryCdPqJQmd4kmzNGijJQaxoahLG0Cy/UeyfJ2PqaAL+OuRNiZ3zdVrm7zlHJyGakSMC6RmZAx8egnRL93beJRVTY5A7xU9OV+cTB1qZC63cjoOkaPsws4FG3vhbAzQVa53pqdeaL4y/Nr0UrlejC0+3VkDYDP29GX+brcNTH2ZNEnj9ump0erC/Ss5RWkdpkRbZ7993CELfDHYekeEdwLa9PvP1oCB8cOaWpoquOB9wQ91VoXfYtgn2TC0X6eqBu7Z9x/62xZO4uBWNphq9E36jlWJEiOnulKddg4I6yIGr2q7dmfEqhY7Mjt+a0cYer/AepEus9bl4folURuOcqvIz
 IxVbWfmX
 e+0Y2wu7ZNjvHMJmGoFqyOiU3pbNubIVt7qu5PO8EmwlzpScIUuPEZ1JSLcfo1vDbNJX1Rfq0wxOybA2tnn1GT/mHfJ95yY9g8LSIzKaXQk8mbexGSw8PDrx0TtlNAp+F6oUp7/jigUCKIB7ZmjdRz3Q5Q4uxHVWWGU7Oy22Kl6IdzfTZdkY+Hy3F90gDM+aB8KxoLXr+HW7uqBAEf/5edOoua/2HazGIJCtxu2U/cBGoTuavm8S7mdov/PWN9YB7KbAxszmDHiHpnumYuvy1ChA6OxgNg2gLjtgIeUgrW9ApyzOjBF////fI75+IakKg+K+Iv17qNr4gfX1Wc1OCSSpOWV52H45rEd4NJfl3kOq06388L5j1nWlBHM8rCvs8bnEIgZg6osHBkYBTtoB8bCU1SVhzTkXId9cqapGXqOj5TxgYVBC83oOequvGfRbOBFfcp1rFQA2Qo9adArh+Ql8qnX/kuVAAUs21KRDn0d6wvJyCYRxTtK1GtnK/B9uN8Q2UK1iA0hyPjxHSpUb8O75lWt9sgP6GkYxRDu3P+435NmHG1o83pGCj+pXQmPDmoQ0yovsQ0aBK/xdL1lBcAKZnpTghuC/GLotqYT5OmYvp9CNh5dFxUtTSHbrzJcubZgdr+Ze52oiO3MxpYUPbwF8H33KtrEsiJ+9f5kwF5btP0ZN2/LTWo3HSIYB1r9JAfDPv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 24, 2026, Ackerley Tng wrote:
> Xiaoyao Li <xiaoyao.li@intel.com> writes:
> >> 			KVM_SET_MEMORY_ATTRIBUTES2 ioctl on guest_memfd file
> >> 			descriptors and disables the legacy VM-scoped
> >> 			KVM_SET_MEMORY_ATTRIBUTES ioctl for private memory state
> >> 			tracking. Only the KVM_MEMORY_ATTRIBUTE_PRIVATE
> >> 			attribute moves to per-guest_memfd tracking; other
> >> 			attributes remain per-VM.
> >>
> >> 			This parameter toggles KVM's in-place conversion
> >> 			capability support.
> >
> > I start to think that the term "in-place conversion" seems to read
> > inaccurate. I think it is describing the shared/private conversion of a
> > gfn, and in-place means when a gfn is converted between shared/private,
> > the backend comes from the same gmem page, thus in-place. But KVM
> > doesn't enforce the "in-place".
> >
> > If "in-place conversion" describes the shared/private conversion of a
> > gmem page, then "in-place" is redundant because the conversion a
> > specific gmem page is always in-place.
> 
> Hmm, a few people have raised something related to this
> gmem_in_place_conversion module param's naming: Xiaoyao, Yan, David, and
> Sean's response is generally that it is confusing, but can't find a
> better way out. The main consideration around module param naming is
> that it should be named for the benefit of the admin. We want some name
> that admins can understand at a high level (for some definition of "high
> level") what this does.

Executive decision: use gmem_in_place_conversion.  I hear (and largely agree with)
the complaints that it's imperfect, but I don't think it's feasible to find a name
that can perfectly describe the nuances while still being somewhat succint and
intuitive.  I.e. gmem_in_place_conversion isn't perfect, but everything else I've
seen is much worse.

I'll make sure to call out that gmem_in_place_conversion is imperfect in the pull
request, to give Paolo a chance to veto my executive decision.

> Do you have a proposal to resolve your concern, considering naming,
> documentation, comments, code, etc?
> 
> >>                       Whether a VMM uses separate backends
> >> 			or out-of-place memory management is determined by
> >> 			userspace VMM design.
> >>
> >> 			Note, this parameter is only available when
> >> 			CONFIG_KVM_VM_MEMORY_ATTRIBUTES=y. When
> >> 			CONFIG_KVM_VM_MEMORY_ATTRIBUTES is not set, in-place
> >> 			conversion is unconditionally enabled.
> >>
> >> 			Default is Y (on).
> >
> > I'm looking at the doc of KVM_SET_USER_MEMORY_REGION2, which reads
> >
> > # When mapping a gfn into the guest, KVM selects shared vs. private, i.e consumes
> > # userspace_addr vs. guest_memfd, based on the gfn's KVM_MEMORY_ATTRIBUTE_PRIVATE
> > # state.  At VM creation time, all memory is shared, i.e. the PRIVATE attribute
> > # is '0' for all gfns.  Userspace can control whether memory is shared/private by
> > # toggling KVM_MEMORY_ATTRIBUTE_PRIVATE via KVM_SET_MEMORY_ATTRIBUTES as needed.
> 
> I'm not sure how this snippet from the documentation connects with what
> you'd like changed.

It's flat out wrong once in-place conversion lands, because it assumes PRIVATE
is tracked per-VM.  Something like this?

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 4eb7e75a7473..c9769e5e7329 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6383,9 +6383,12 @@ on-demand.
 
 When mapping a gfn into the guest, KVM selects shared vs. private, i.e consumes
 userspace_addr vs. guest_memfd, based on the gfn's KVM_MEMORY_ATTRIBUTE_PRIVATE
-state.  At VM creation time, all memory is shared, i.e. the PRIVATE attribute
-is '0' for all gfns.  Userspace can control whether memory is shared/private by
+state.  If in-place conversion is disabled, i.e. PRIVATE is tracked per-VM,
+then at VM creation time, all memory is shared, i.e. the PRIVATE attribute is
+'0' for all gfns.  Userspace can control whether memory is shared/private by
 toggling KVM_MEMORY_ATTRIBUTE_PRIVATE via KVM_SET_MEMORY_ATTRIBUTES as needed.
+If in-place conversion is enabled, then the starting PRIVATE vs. SHARED state
+of a gfn is determined by the relevant guest_memfd instance.
 
 S390:
 ^^^^^

