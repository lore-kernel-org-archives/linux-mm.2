Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9A8DC5DF7A
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 20:12:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D76726B010B; Mon, 17 Aug 2026 16:12:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4D846B010D; Mon, 17 Aug 2026 16:12:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C62F96B010F; Mon, 17 Aug 2026 16:12:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9F61F6B010B
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 16:12:10 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6539CA097F
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 20:12:09 +0000 (UTC)
X-FDA: 85111857978.18.83749A2
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by imf31.hostedemail.com (Postfix) with ESMTP id B23A420009
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 20:12:07 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uXaTne3Q;
	spf=pass (imf31.hostedemail.com: domain of 3FWuDagYKCFQE0w95y2AA270.yA8749GJ-886Hwy6.AD2@flex--seanjc.bounces.google.com designates 209.85.210.198 as permitted sender) smtp.mailfrom=3FWuDagYKCFQE0w95y2AA270.yA8749GJ-886Hwy6.AD2@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786997527;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N0+O1Vxdvyhj7pmjvbt8iDMZ8zrd75NX4nQ7WNMkzm4=;
	b=qzSW8M91ZCjcK8fqcdnbQr5KVXYMYEKtMRpQd43vJ6R/nH8G0yhRmssNlGsAKBRxFNuVrf
	IznGbfnIIEWn8rg0YoAme5o6wMNUibGirFD7ZtjShZI+ymCykoFD0iXx+tYOar7tjHNofa
	BHvRa2I813Jmy3ZYYwuGNFlrTirXff0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786997527;
	b=rMnQn5wjOV+Kn1ETg4ky8WK2heVi9+mpE7ullE5OFKfKYr/I0Yf0y5FtEq+02f8X1c5SJ9
	1CtnisryzAaQ6jcIcRsoruDYWthYLLmlr6KThskJjk40ccQEjb5Pt/qTcEQ2k1PDyW/lpk
	eNM6dyPCfCIEpz+zNggIm8TIZMR67OM=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uXaTne3Q;
	spf=pass (imf31.hostedemail.com: domain of 3FWuDagYKCFQE0w95y2AA270.yA8749GJ-886Hwy6.AD2@flex--seanjc.bounces.google.com designates 209.85.210.198 as permitted sender) smtp.mailfrom=3FWuDagYKCFQE0w95y2AA270.yA8749GJ-886Hwy6.AD2@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-84e13b57b2cso4513919b3a.1
        for <linux-mm@kvack.org>; Mon, 17 Aug 2026 13:12:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786997526; x=1787602326; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=N0+O1Vxdvyhj7pmjvbt8iDMZ8zrd75NX4nQ7WNMkzm4=;
        b=uXaTne3QHm0EvyhbgyIT+40Us9vuuJC+5Jc8JHffyw0noPQOORpd/dAVuDbfuPLzXf
         iyFj23EhA7mMprjkQ582uZOw8Oz3424iIftdcG86f05JS3VZXfkdw45ZH885rNgd1pUf
         UJJrzFY73yx3+8ucalv8x49Y/2ZhgWKVzWEhtILc+goppZ5l86DnPU9/Qielu1oiCNFy
         E7cHcaVjN8fYKZ887g5ziiVjTYLLXqdtq/6zWl8wjcAEHMzGOzyKWbIh5fKkoXIgLRE4
         Z0FmRfvb0qhrM08iDKOseqKYS8ayCr7lH9cV8NDu39ZcCvihqk11rcryU4TaxtbqFAyn
         6irw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786997526; x=1787602326;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=N0+O1Vxdvyhj7pmjvbt8iDMZ8zrd75NX4nQ7WNMkzm4=;
        b=DLp/DFDF4/WJqPN7+3MEMQ92vUs3DjG2ZtThuQS4djWpu8YQvd2AlwsVMCVrU9TVj1
         aIoPyvb2+y61NxAl6uxFF4rNcc6Q71TMq3na8TdohPTHilgQgSD7q++BsmKczO+nXg3+
         /+ICtevxNZT56f4M2QiYFqDkY6HjE7h1jeIZsta4XOa/s39nmUHFvahcrVRg7CHuKiX3
         nb4rlC0/6M/rc76tiKcbBztB/8hYkEkKLCVCtUaksB7QTObxD5d6rK8+cpktHAHFu/Oq
         cGpqPVdn4gdB2bfi6391u+zSavocy87MC6f0ob4EpbkSRIZ6+bmwHKDy1UbiKscpSWkN
         kx7g==
X-Forwarded-Encrypted: i=1; AHgh+RpnyD5qUzdoWhHM6AVeKyuTAGaQoytC1OEXGS32sEOWlz2kAAdZCVksQ7H1NhOElqr2gBoXWy3/SQ==@kvack.org
X-Gm-Message-State: AOJu0YxhE5/BUE8cQzj8Mcx7jYjMh/sCEQazd0o6eufIDcsdEhlYQiHu
	WLsql77YsDN9GkpEVydsE/dhBLsEAQiULEBRl6dHpuf+MyuEo+0cYFWBCyMvWcJqrB7AfRH4qRO
	Huacy1g==
X-Received: from pgmp38.prod.google.com ([2002:a63:1e66:0:b0:cbe:e160:452d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:23c1:b0:847:968d:b101
 with SMTP id d2e1a72fcca58-851b88ce701mr2522658b3a.21.1786997525814; Mon, 17
 Aug 2026 13:12:05 -0700 (PDT)
Date: Mon, 17 Aug 2026 13:12:05 -0700
In-Reply-To: <aoKnmW9St5zCoTD3@yzhao56-desk.sh.intel.com>
Mime-Version: 1.0
References: <CAEvNRgFzRj_=GVy8T4P8ehhQjYomYxkngzwtKBF0iEL0Cv6fuQ@mail.gmail.com>
 <anp1I64K0KeyQuyo@yzhao56-desk.sh.intel.com> <CAEvNRgFWcndQKJE_q+ZATFZEMYd=6uRLygozLvg7L77bPX0cEQ@mail.gmail.com>
 <anqqKH6kuwpvuwp9@yzhao56-desk.sh.intel.com> <CAEvNRgGWDY_fxbyBM-5sMdYMevMe0HzVP9kbC1cCGLE_dV=_Gw@mail.gmail.com>
 <a71d4fccdffd1f6a12332ddd18fa812542ea2118.camel@intel.com>
 <CAEvNRgHxda6XK_XqWaqqVnA7oW=Fhp_C5gF4vNcL+-HfwfXMqQ@mail.gmail.com>
 <0c80b9b0e13e3ab2cbe4f9eaf4a02ebba25a7001.camel@intel.com>
 <an5RJYTwlYeym--O@google.com> <aoKnmW9St5zCoTD3@yzhao56-desk.sh.intel.com>
Message-ID: <aoNrFX9yLfsM7KQI@google.com>
Subject: Re: [PATCH v10 11/41] KVM: guest_memfd: Ensure pages are not in use
 before conversion
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Rick P Edgecombe <rick.p.edgecombe@intel.com>, 
	"ackerleytng@google.com" <ackerleytng@google.com>, "david@kernel.org" <david@kernel.org>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "steven.price@arm.com" <steven.price@arm.com>, 
	"peterx@redhat.com" <peterx@redhat.com>, "forkloop@google.com" <forkloop@google.com>, 
	"tabba@google.com" <tabba@google.com>, 
	"linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	Vishal Annapurve <vannapurve@google.com>, "willy@infradead.org" <willy@infradead.org>, 
	"tglx@kernel.org" <tglx@kernel.org>, "wyihan@google.com" <wyihan@google.com>, 
	"pratyush@kernel.org" <pratyush@kernel.org>, "aik@amd.com" <aik@amd.com>, 
	"jmattson@google.com" <jmattson@google.com>, "aneesh.kumar@kernel.org" <aneesh.kumar@kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "rientjes@google.com" <rientjes@google.com>, 
	"andrew.jones@linux.dev" <andrew.jones@linux.dev>, 
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, "chrisl@kernel.org" <chrisl@kernel.org>, 
	"shakeel.butt@linux.dev" <shakeel.butt@linux.dev>, 
	"mathieu.desnoyers@efficios.com" <mathieu.desnoyers@efficios.com>, "oupton@kernel.org" <oupton@kernel.org>, 
	"mhiramat@kernel.org" <mhiramat@kernel.org>, "baohua@kernel.org" <baohua@kernel.org>, 
	"tarunsahu@google.com" <tarunsahu@google.com>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "jhubbard@nvidia.com" <jhubbard@nvidia.com>, 
	"jgg@ziepe.ca" <jgg@ziepe.ca>, "jthoughton@google.com" <jthoughton@google.com>, 
	"yuanchu@google.com" <yuanchu@google.com>, "hpa@zytor.com" <hpa@zytor.com>, 
	"shikemeng@huaweicloud.com" <shikemeng@huaweicloud.com>, "nphamcs@gmail.com" <nphamcs@gmail.com>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "shivankg@amd.com" <shivankg@amd.com>, 
	"shuah@kernel.org" <shuah@kernel.org>, "youngjun.park@lge.com" <youngjun.park@lge.com>, 
	"kasong@tencent.com" <kasong@tencent.com>, "pankaj.gupta@amd.com" <pankaj.gupta@amd.com>, 
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, 
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"vbabka@kernel.org" <vbabka@kernel.org>, "weixugc@google.com" <weixugc@google.com>, 
	"michael.roth@amd.com" <michael.roth@amd.com>, "rostedt@goodmis.org" <rostedt@goodmis.org>, 
	"mingo@redhat.com" <mingo@redhat.com>, "qperret@google.com" <qperret@google.com>, 
	"brauner@kernel.org" <brauner@kernel.org>, "bp@alien8.de" <bp@alien8.de>, 
	"baoquan.he@linux.dev" <baoquan.he@linux.dev>, "corbet@lwn.net" <corbet@lwn.net>, 
	"skhan@linuxfoundation.org" <skhan@linuxfoundation.org>, "liam@infradead.org" <liam@infradead.org>, 
	"axelrasmussen@google.com" <axelrasmussen@google.com>, "kas@kernel.org" <kas@kernel.org>, 
	"qi.zheng@linux.dev" <qi.zheng@linux.dev>, "linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: text/plain; charset="us-ascii"
X-Rspam-User: 
X-Stat-Signature: cttwick6yaei946dutnbp9bhss9nn6k5
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B23A420009
X-HE-Tag: 1786997527-724514
X-HE-Meta: U2FsdGVkX19mzxTThBAaNXcVTGBGevIsCZ/uN+wbdL6T0qyDjxpYDa3+AEOQCYSccpNRd13tQmJuChsz74baSAU9knzh9fgc79sxf0PiH/7+tO2xlcQ+sIn6Mm2seyTQbkEl8UcMCw84KtoMTVv7yDzYbvVssPvThdLjnx0YX2tuDVbKmJOzH289R7VPIZgj6z6fyA4eXG0PKGmqZhs+jQhkNBn8ZX8eK5fR5IC/eGSMVNqo1yChtx5wmzn2QvO7PKYVHpWDAGMYDNIJjmeIpNdwqDHXC1CcySHdoGCE885JYgGGbOs83qVdFrpjKh/U1C9NQ5vhbQLK6mbNdFMgbBuuSf/T6cECNRt16QDy/JTXZue68XqjtxHdF6l6veq6VU/6BUELq8+iiC3B3OR88TpzV8av/1deBXYDiyyjmhCO1l1rSDEnVEHXVRTxfA9uz3OEW7WI8IJ++SF7c7t7ptTqtb+LkovNuUpylRFn36+Z0RtCsUlIrQ+EKMoTE6MvY1FBiKeR0QUK+hDhRmCN4tf+UO1a+2H6eoG23avb0wgtljK/2E1XSuK8OO8s0taLMgCyejh4pJA/CiaVrx3a5iRDTBSiytAmdMwWFmFzw9pT6GsyBeXRlxDX5YKb7gANuzFh4dN8AeBwEQ31hQ1ml5XNhtOev8c104OI2KpuNMs/IGgAUc+fICeBRO5YVVcjMBfu67pAdTq0ExyKc7pgGzpPIV6qKiAzgqsnbdi5sJ9j9Ui5qcDkdy7oO0AkcRpNfmfBi0S1j6uw73MCkbd3/niYa4pHVg87XAYtszDVBhtTq6FcI0mu2SlL75zAVAcLCgsPhqDPPErdOHXTeOlCpORt0fn36rmuRMGib6lroSkJZVOmyDWLotqdpk8IH1J01UxjGeyMEBzu/MWmhvd3S8AEJobe3Dhe16Imc+lugw0wYY1VEZOBzEzvTtcFxQHX5dOzxfEKV04Q3hj3d0Y
 JqYZGGKQ
 7oR6tNzopKVhjdxlSCiHn03dIIGuOVFGPYTlHuDoOcdzk9Cz4jA5o20csUZ5Enht+qdSFb258RIoX8wUP5i/x8Idc/HUT3e70NE/BmfhCpwWU6xh75Hx4m/gOj9b3mvf5SHAUuNU6DcBiRhHKnPCHK7zXvhu9TNCWwXd7AJgFppKjSzOCeB7ofEmsmymuoY10Ghu3CMmMdAy7LsTsI9mMJo7djLMkkqwmoT0E0SE2hjKYbGMhHkxuXMGVBpGVgOmJ3Aa8w6EBKh0GOqJ9jx3ZlYAQagXNxifqrSkKdyjw0FJH76+yAYE+SwRqKTUX+cORCqATyzkhT/CZgsukWQF/kHVXDKDZPgQuReHxmysJ6T2C0JhILtpP2iVVPhHVpqRUptzLAvm75lLL/+Y9mQXqfRQd+S3uLQsweXqgIvjmVACQ6WYqHmBarslmhCWiHYVHXyWBkPfKoHc2p775cJP4p4uiGV8kReJzbCDglZ4nomIVgeIJsuIViURVuoPNxJy3xWZvfJyxYoefDWOH8WJAJ0eDI5+XWugfDyHhOHlW/+R82fGyHKbpCep+zIWsPTez4YYc7Dm6qD1ZCLyNHDDGanj3jKgj6taPFU78eq8ePz2dQxetlZfDnxws+vXnfyt1Q+ziaO4TOtlDpvR9+ZWW9oipnqq7K4bt1V/CoBtA/uZJcYkBcUp5OjQHPG9yEuXGzG/A7aPEOmhFIiv9KoltRM7a4w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 17, 2026, Yan Zhao wrote:
> On Thu, Aug 13, 2026 at 04:20:05PM -0700, Sean Christopherson wrote:
> > On Thu, Aug 13, 2026, Rick P Edgecombe wrote:
> > > > > nicely so we actually just run an old branch's TDX selftests against newer
> > > > > kernels. So the branch is a bit of a pile, and not really suitable for sharing.
> > > > > We plan to clean it and upstream it when the path clears. So it would really
> > > > > help to get those basic ones upstream. We remain happy to help, so please let us
> > > > > know.
> > > > 
> > > > I guess at this point I'm hoping y'all and Sean are okay that this
> > > > conversions series merges, and we let this stress test failure be
> > > > handled later. I'll be around to fix things :)
> > > > 
> > > > I'd say the line of sight to fixing this would be when the KVM MMU only
> > > > gets PFNs (and no pages at all) from guest_memfd.
> > > 
> > > Hmm, I think we shouldn't upstream a uABI that we don't have line of sight to
> > > making robust. So it would be good to settle this thread at least.
> > 
> > This isn't uABI.  You're talking about hitting a race condition between one task
> Hmm. Perhaps it is not a uABI issue, since users are allowed to retry. However,
> it is hard to convince me that it makes sense to require users to retry a
> private-to-shared conversion before a GFN has ever been mapped, given that a
> retry is not required when the GFN is currently in use by the guest.
> 
> > converting a page and another faulting in the same page.  An NMI, SMI, or IRQ at
> > just the right/wrong time, especially on a preemptible kernel, could lead to the
> > same test failures, even if KVM drops the refcount "immediately".
> Could you elaborate on how an NMI, SMI, or IRQ at just the right/wrong time
> could lead to the same test failures?

Ah, sorry, my bad.  I was speed reading and missed that the key to your suggested
"*page = NULL" change was that the reference was put _before_
filemap_invalidate_unlock_shared(), i.e. before dropping
the invalidate lock and thus before __kvm_gmem_set_attributes() will walk the
folios to look for outstanding references.  I was thinking that putting the
reference right away was just shrinking the timing window, but putting the
reference while still holding the invalidate lock closes the window entirely.

So, I take back what I said about this not being ABI, and about this not blocking
in-place conversion.  It most definitely affects ABI, and so needs to be addressed
before merging in-place conversion.  The only question is if we want to commit to
guaranteeing that conversion will succeed in this scenario, or if we want to take
the easy way out and formally document that conversion can fail with EAGAIN at any
time, even if userspace has never mmap()'d the memory in question.

I'm leaning pretty strongly towards guaranteeing conversion will succeed.  We'll
still need to document the EAGAIN behavior, but IMO there's a massive difference
between conversion failing if there's a lingering reference acquired via a VMA,
conversion failing because a vCPU page fault raced with conversion.  E.g. being
able to assert success in a very curated test, as the stress test presumably does,
would be extremely valuable for helping detect/prevent edge case bugs.

The argument against guaranteeing success is that we might make our future lives
harder, e.g. if it turns out there are legitimate, hard-to-solve edge cases.  But
I'm ok with that risk, as it seems highly unlikely to be problematic in practice,
and there is real benefit to guaranteeing success.

> > As for in-place conversion, this is not a blocker.
> Sorry. I didn't intend to block in-place conversion.

LOL, what we intend and what happens aren't always the same. :-)

> I encountered this issue during testing, so reported it.

Thanks for doing so!  I'd *much* rather sort these issues out *before* merging
code, even if it means delaying the merge by a bit.

