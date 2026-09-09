Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA314C79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 15:32:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4AB56B008A; Wed,  9 Sep 2026 11:32:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD5436B008C; Wed,  9 Sep 2026 11:32:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C75B36B0093; Wed,  9 Sep 2026 11:32:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A24D76B008A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 11:32:56 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 33E558026A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 15:32:56 +0000 (UTC)
X-FDA: 85194616752.29.1B47AEC
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	by imf27.hostedemail.com (Postfix) with ESMTP id 30D3840002
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 15:32:53 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=JO6gItSL;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of ackerleytng@google.com designates 209.85.219.50 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=JO6gItSL;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of ackerleytng@google.com designates 209.85.219.50 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788967974;
	b=3TvNpC/fjxlPJOfHti6T1NdkyNiBVgrC1toYAPoqEphnQnQ3T3HfqmmUJEedwVhJuoBbKF
	4tlsrP+MQTV6bhvhLrMXzRX3yzLdv6mZ/ApMHyND6ZCRmVEDdd8MMtIZIm8DR4YavjeJAk
	s0TGQrCic8AlH/JuYlpKH9x91EwlrPI=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788967974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+0yQ0IytrFR+cprTV6f0ILvHwq0HfsKregN1JLnR5qc=;
	b=wfRSKp/R3NqIq9WDK4sxXh+toMzWK5YLH4Q3pYKFzvzINAof7BCBgRT79qAYcSWGDyIa/m
	ObDNlMa7uCNIGVjrqwXB3qvDAi4DPpcmgNxFkr2K4KDJyfLSkQ/KKupoZnC9pTFlVAxC9g
	xLwdktIiA27bDAMOmvXBpRzKZxWLP2w=
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-90cd8e45460so81834336d6.1
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 08:32:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788967973; cv=none;
        d=google.com; s=arc-20260327;
        b=KpSGvpY/IsNxJZWJihKbq6lvOOalJe+PhP9OzEqUSiDP6Gq/IeveFGOz7Sg7TKK6F8
         ldZ5+HonDU1yRy8qpN2VQbGBbggZF8d+ZKNI2+OUp3Pb6IIp/gF2jGWAkQ3x8tzv13j5
         uPw5jF1KIxgxINPy9rO9y7l9bYNXiIUnQSMreSiE78IKgstfn9m+yFTTykqWLCJeb45g
         CVGI1mFL9QOaVZd8V8trGOF1GwrI43U7bHA/N4I/dnAdvbUDm5BsltwGd9bjomHsVKFB
         3PEe/5OyL1DPBAZe9QTEc4cdDg0TfnslDRENqndypLLqD0uZZJXbysqjW/6GIZJMjxyU
         9+7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=+0yQ0IytrFR+cprTV6f0ILvHwq0HfsKregN1JLnR5qc=;
        fh=zCmBelc1OA5t2OBR0ejfFQXQqcF/XR8ibdRand797UQ=;
        b=FGCiZ3My22kTFwoh74jGmCkfMBp5+qLO/N4KHEWhe5kpcxrT8Mq08IiFf/L4hgDpzM
         GT1PJbnnqzt+XJu71x1PghRrwqFbFtnRNdD07gAgvS9a/WmV0tGUPPptToHsQjEPkVz1
         BuwawwYGY45FTIwg+/Nz/OaJfrJ1hm0ID0AxCK5SrpUJ4EDOYUzOl/BK1rcH7V9gdFo0
         OgDCmHBugZicyVf2p0RLsndnbe8e8sBg0XJMbRRMr76wv1UFhJuvOWEBlFW6uDTLSjdt
         IjocLqchqyU29kpmOPrpxWVAnBgHygLCJDr3HuCo3JUrZhhZAKInIlXWjo3nAXI4/65f
         1xcA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788967973; x=1789572773; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+0yQ0IytrFR+cprTV6f0ILvHwq0HfsKregN1JLnR5qc=;
        b=JO6gItSLzj8nW/SU40vxZ9mzCkkyQscgCDJKFIwSKvpOqxjmUbNyvCY4/qZD9ksaBf
         BGrf4MrAozk3nyA+CwEbk2rAUGeghFGa23b8kYni+cVibzFkDg9W6dgsJGClhoZx+YX5
         /OWFFo2tSTVnmSMoDQC2p/ho5n7IqRKFIbTmspoVMxtNTii1YKBio2QXjOfC9OYcerLI
         LkIazYaNnjlGwLbLyeoAt9wgiyMOKA2AOLFauevoxHEftKg9C4AezLSq3+aRJi8W4r/i
         vVT4HViX7vLfDFzae3PtDBfCLZzHiF8FZKUOM1l74v0a1cpa4OZQ5F3nL7rL0BVOWLVi
         ysnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788967973; x=1789572773;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+0yQ0IytrFR+cprTV6f0ILvHwq0HfsKregN1JLnR5qc=;
        b=mzZhuOve083rN3mqtdUsj9yvYiq1oiC//Zd0eTIEZypLoBRQGoSPRO4Kh8nV4MuZOW
         TlgPl5P/2vlAJUBiPoUIX7XuvT/bsniVTneEa+8n7/kDGcIgJaz+w0uCulZh2iZ+rkJB
         K1+Rp9m3sq1zm/drgMmj3Ik6wD3VFyhzhihydgdvu8+bWkawtRiLWNv89rBrefRrmA63
         McXzkeQ/nzjof+D/98khfTMZGmvOpos8SmjwltG3xq0UOwEdQBXh9gEh5ToP9KqOFPkN
         CSYlzaNhRBw74pJm5cxbAUJQt2M9LesKCp1fUhAdHvsLpFtgpxjY4OENdB2a+OmV2cFS
         WdNg==
X-Forwarded-Encrypted: i=1; AKwUvBzFvpqo8eaB71iv/67jBHWi1iBuslTcqacdb6TlHW1ms22MlQef7Xo3GIs1KzZc1aUlXnOiukRUBg==@kvack.org
X-Gm-Message-State: AFuF++lwD9i4diTMBcD+LdPY4zaoGXMiW2M/Y1UJYoJjVeOqWqAUWqJ/
	KSQcY9J4omu0YVG9hlrUt6qqYu30qjev8KP6Fhfrz/DJNQlIegK9IfWdFDFESqzMsv7cD6S/A1f
	JyWSgLo5QGgyGAQbzHtAV15Tw3j3uXI6AB86Bl33T
X-Gm-Gg: AYBFou29r2KRs7WEEMZdhKskzY45e/fI54XmRa2xtZtxTTYrFB4CAgOfFSlNCoCE9tk
	/kovyLOtQLUyMDJTOrEG5Jz6eCov5vG3MMonNOF/wwODxvh6PaaNkTGqmCGLrmroaIMMJ/pzOID
	B1fMz3P9GbzDRTBGMd0zDlxJq0XFzXZERsOG0nSqVUAQ2u/UWvE5oRbERaGUFP4GK0xyDFYVVmp
	y0ngm0rgzLCYvEb1MkxKskpWwuVIdOJGnPVDWsB9eqSf2Lv/XTdNGSNDlJLtw4gtyoD7ap6BF9S
	VanbKq/P2/Zx7vkqBfCvJglJgh8XXfZKDM7IwMTPFes0SK1O9Ly9lJn2WN9t2r79oZXZP934IH5
	D9Xn6USXwGDOzgt/gX9UzUw==
X-Received: by 2002:ad4:5ce3:0:b0:910:7076:b681 with SMTP id
 6a1803df08f44-9107076bb36mr33516746d6.2.1788967971471; Wed, 09 Sep 2026
 08:32:51 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 9 Sep 2026 08:32:50 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 9 Sep 2026 08:32:50 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <apcY5b2o5k04XffH@google.com>
References: <20260830-gmem-inplace-conversion-v12-0-85e5fd25252a@google.com>
 <20260830-gmem-inplace-conversion-v12-23-85e5fd25252a@google.com>
 <CA+EHjTzALzghuG5J-LFuG5pXJ4WgEfrMHgwkMHnq1U-D6yS7Pg@mail.gmail.com> <apcY5b2o5k04XffH@google.com>
MIME-Version: 1.0
Date: Wed, 9 Sep 2026 08:32:50 -0700
X-Gm-Features: AcwNN1UUq4SnqnO43s4JocxnzO6yIsHxwMjPp5Qjf0-uaaWqzT0IH1RML9MbcC4
Message-ID: <CAEvNRgHm6AbbUUayS=Smck_41CrQ7yXYCN5soFOYZ6N-YqtXNQ@mail.gmail.com>
Subject: Re: [PATCH v12 23/45] KVM: Let userspace disable per-VM mem
 attributes, enable per-gmem attributes
To: Sean Christopherson <seanjc@google.com>, Fuad Tabba <fuad.tabba@linux.dev>
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, willy@infradead.org, wyihan@google.com, 
	yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org, 
	suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
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
	Randy Dunlap <rdunlap@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-coco@lists.linux.dev, 
	Xiaoyao Li <xiaoyao.li@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 30D3840002
X-Stat-Signature: txdjke1tgho5jpsjks84gsrtea5kxkb3
X-Rspamd-Server: rspam01
X-HE-Tag: 1788967973-489693
X-HE-Meta: U2FsdGVkX19FkVq8Wcf31uCI9sWS9LkDidlMijFA9JnLtgUkPU3PSiM6Va53FrWCfOJZ8cDwleiY0dS2Ot/va7ZDEHPvILodLFO5h+lhPH8nKXR9Z56CXHJxPJ1o3f8IMm4vhZutLT+E7KOHqekFYh2MQuKZ4LaVJPM55hyc4KmHL/ZkN6zZIVCq1owMypl0UoFjIYQPDxLIV1HPpzuNIZZYz8nvDQqSEUyGhtxdmVSRxo8XHMl5hF/rZzR3hRMEUN9YhsY+muIZR0RvAn5Xtb251MvvSGPZjeOMxWTnPfxJ3BCBFU8i1IYvLJ+PaMAKU1ZSPWUsjfnAID1igeMhF/B/ti+DtHYgqxUDMIPK7OFlMcvdfJgWWC2dF+hYRinIuFNRqW3cgdUU13+UbCKcvwQQY6Tgu8l8PpxVaj3JvwJp6rf6eQExJrPKcCGuqklylzhWfPbKlXs+JTcdbF3kcLCNEtInnzkYx8XFrOMsw7f2cvD9BEx7CA2FCFyxxgC7h8uRffATGPxdSMT5srMHQA4duvwnleqJLCJWQ2OiXNK+rBfdYrKwFpBR0NIxgHgHYgV8/4zCFYjtCkAfXv9JK4+6r5HEDJcMoPqYJy1GEah9neGnzH6kUZulcpB+9WadloQT2+CJqfYjk04vSyCO2Jx6NRsxEXuJJetRYx4thI+hs9J1heu+yzf3vTQqPJjKEwEMBC7wlnBEXUolr07POnjJ5cIu+5HRFM5tBDP3OcyTWIc/Sm/o/0Dhf1Jne5+9HmM0OJ5knFBGgh+QpSA2mwNnTt5T8zHj2AKX7edyJw3xc8PwJg3Hj6Ix8FeYOm6Dk1s6/kCOEQK1pN/+oz9cp1n3ggQ7+O5u4neEqDN7sryaFCnDay+UWrGSv5gZ5KursYQJmq4VtLgxSakEmtP3+O4qqj+I2+ScYGyfL5/8pWWax1FAYAENbJaXz+qwvEcrj70+A+KwUnN1nqZDECR
 v7asx09y
 W3EBpI65MqNKLuerjMyN9s2LnE7PaCtuN5nIdOXg4vesHywhIhE0dLcicnef6ybB9WsZwnMGbfhV/NENPnHWC3bfeOezpXEHkFbmrdbpcT701/z08Vs//szuQCjV4giVocNprHkK4fA4EDMoFsXR5Lze2REZh0ecM6WECnZKpBZot3MCjl/NIXLTpzC2WQa99bHecxQjXgujRvgiQs/h0uG7JyDdVn5mVgeHJBa91aWmBKKmjXbYwben6qWeCj3hUTTVRZOA9LZ+PHkjHTkiT4VnPLmJvsuXxDa/ZpeSZN4FRwi9tP1pMhFgu+/QALc5wTAKCfN77vkA3A1K01UDfuceIjw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sean Christopherson <seanjc@google.com> writes:

> On Tue, Sep 01, 2026, Fuad Tabba wrote:
>> Hi Sean, Ackerley,
>>
>> On Mon, 31 Aug 2026 at 01:25, Ackerley Tng via B4 Relay
>> <devnull+ackerleytng.google.com@kernel.org> wrote:
>> ...
>> > +       kvm.gmem_in_place_conversion=
>> > +                       [KVM] Controls whether KVM enables in-place conversion
>> > +                       support for guest_memfd and tracks the private/shared
>> > +                       state of memory per guest_memfd instead of per VM.
>> > +
>> > +                       If enabled, KVM enables the KVM_SET_MEMORY_ATTRIBUTES2
>> > +                       ioctl on guest_memfd file descriptors and disables the
>> > +                       legacy VM-scoped KVM_SET_MEMORY_ATTRIBUTES ioctl for
>> > +                       private memory state tracking. Only the
>> > +                       KVM_MEMORY_ATTRIBUTE_PRIVATE attribute moves to
>> > +                       per-guest_memfd tracking; other attributes remain
>> > +                       per-VM.
>> > +
>> > +                       This parameter toggles KVM's in-place conversion
>> > +                       capability support. Whether a VMM uses separate backends
>> > +                       or out-of-place memory management is determined by
>> > +                       userspace VMM design.
>> > +
>> > +                       Note, this parameter is only available when
>> > +                       CONFIG_KVM_VM_MEMORY_ATTRIBUTES=y. When
>> > +                       CONFIG_KVM_VM_MEMORY_ATTRIBUTES is not set, in-place
>> > +                       conversion is unconditionally enabled.
>> > +
>> > +                       Default is Y (on).
>>
>> The parameter is only settable when CONFIG_KVM_VM_MEMORY_ATTRIBUTES=y, and
>> in that config gmem_in_place_conversion initialises to
>> !IS_ENABLED(CONFIG_KVM_VM_MEMORY_ATTRIBUTES), i.e. N, not Y. Is the doc line
>> wrong, or is N-by-default not what was intended here?
>
> The doc is wrong.  The intent is to maintain backwards compatibility with existing
> deployments if KVM_VM_MEMORY_ATTRIBUTES=y.
>

Thanks Fuad! I got confused, gmem_in_place_conversion the variable
defaults to true (because CONFIG_KVM_VM_MEMORY_ATTRIBUTES is by default
not set), but if the parameter exists, CONFIG_KVM_VM_MEMORY_ATTRIBUTES
must be set and so the parameter defaults to N.

Will fix in the next revision.

>> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>> > index 05c518c9b8078..929fd3e1a01e6 100644
>> > --- a/virt/kvm/kvm_main.c
>> > +++ b/virt/kvm/kvm_main.c
>> > @@ -103,7 +103,10 @@ static bool __ro_after_init allow_unsafe_mappings;
>> >  module_param(allow_unsafe_mappings, bool, 0444);
>> >
>> >  #ifdef kvm_arch_has_private_mem
>> > -bool __ro_after_init gmem_in_place_conversion = false;
>> > +bool __ro_after_init gmem_in_place_conversion = !IS_ENABLED(CONFIG_KVM_VM_MEMORY_ATTRIBUTES);
>> > +#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
>> > +module_param(gmem_in_place_conversion, bool, 0444);
>> > +#endif
>> >  EXPORT_SYMBOL_FOR_KVM_INTERNAL(gmem_in_place_conversion);
>> >  #endif

