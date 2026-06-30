Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 470ADC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 13:27:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 229906B00A8; Tue, 30 Jun 2026 09:27:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DA6F6B00B4; Tue, 30 Jun 2026 09:27:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A19F6B00B5; Tue, 30 Jun 2026 09:27:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D27DE6B00A8
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 09:27:10 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 63DD41C6913
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 13:27:10 +0000 (UTC)
X-FDA: 84936655020.23.D1C2D46
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf05.hostedemail.com (Postfix) with ESMTP id BA1F7100011
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 13:27:08 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=PvadUO76;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of 3KsRDagYKCBsJ51EA37FF7C5.3FDC9ELO-DDBM13B.FI7@flex--seanjc.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3KsRDagYKCBsJ51EA37FF7C5.3FDC9ELO-DDBM13B.FI7@flex--seanjc.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782826028;
	b=qxavwRyA8+Uc+OvOLyPljcmtc3yQJe86xaU2FxjITVO9Kg4YumQgHQu2o6Hxpn/GFk5dTr
	jyiU2oKkcFL7/iPdssHUWXygWetdME/133AxkLIrLQM+uHExKltvo64cX57twZX8ILvSl9
	3Yx+nM7vQaF3/AqfcOWDe+axdccPkQM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782826028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AhLYh/cBIA1fFqX5RYZRm50yWfU0LfaJB+fi+NtWOq0=;
	b=wrx9s7fHsJzIeg023Fxj7dil6QhvzK8c78IUQ+8Luhxlt3/4kcAxC19IBpP98n/oHvDIl4
	fodChkh33le0HcgD+tXDGZmS0zkXSqDlFVqupFsj6fXGiIRDrJ3tYOLfjDB8oCYBIUDPrp
	zswDbDSoy4CvEEH8SPpO1odX4Ck10ig=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=PvadUO76;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of 3KsRDagYKCBsJ51EA37FF7C5.3FDC9ELO-DDBM13B.FI7@flex--seanjc.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3KsRDagYKCBsJ51EA37FF7C5.3FDC9ELO-DDBM13B.FI7@flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-8478d2bea7cso597548b3a.1
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 06:27:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782826027; x=1783430827; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AhLYh/cBIA1fFqX5RYZRm50yWfU0LfaJB+fi+NtWOq0=;
        b=PvadUO76H1ye3Npczc0faPuvYi1qK8AjAa8FJnSrvDMbIFD+wQVazekhK9fLRQoVil
         pwrVwycYZHczIpbQEEJ7dOo093Wf6UZRxaIWdvKsLy2SauXsyViWPDiVMQkQns0u+q9c
         MB+bxSRIgU3MfsTXvqmTS3ecJxOLX79EBR4oCr/jOCje86PpXjdmsQuzxhYyPulYG65Y
         oRD5XOsj/dhUYMs3FF0jLsQnMmLxRl7E3IFie1CusZhcQbrD7B5Zu//MK0sWGZbvx6/3
         ekOqRe7NyNO2AttSvm7hYF4EMA9l9tOgoB2xMUIJ+mJt1gGMc+edVRYWeaaqGKjmCHy4
         2TUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782826027; x=1783430827;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AhLYh/cBIA1fFqX5RYZRm50yWfU0LfaJB+fi+NtWOq0=;
        b=BGv27mVhlMM0HfzO6PgwivONf4mq2n2PlU3zE/hnF8CW5BI8MfeK17KO51TlTU3dyJ
         jUi3UTItz8MGyzuQoJLSUXBmrunZ5n8ayLl7R2fKVfb9z1PqUmXv0kwhjd6Q6BxodVaj
         hzBkIRIjVszr415b4Qli9YYFNZ+LaLqvSD/wK3GkLHE4gR7o1YxjhZqYztHtIXlqcHOD
         oddKqdYsJc2AitIFMwhqI73M8z57BoSSIjIODCSZ1C9gam0trC5G1GCmAMZ+mdHgsgjv
         EC4xwptZmHDPh4MxQDJCngiTmYhx7NlHMR7V7wWM1LGOevBZKneaXqpplA1hpzBdtlZd
         5VdA==
X-Forwarded-Encrypted: i=1; AHgh+Rqj5FD7DDGcDuxlCT/AH0+sm52TUDRVoptU/nijqn/lwvlw4hQRbwluKdWrnY75Wa4UDECCovAGfw==@kvack.org
X-Gm-Message-State: AOJu0Yz2kUVlK3SSflYvUj87MBRqIdYYkWNFJMILvGrZ4HFKM4mzr5Oq
	zPSE7Eg7MTtJzd7VLGrqEz0/QCubNc7c+AVdDGl3zFEFyTJiypFYVF/tPzCSnmmd9/FBj/DJS2P
	/luiu9w==
X-Received: from pfqy13.prod.google.com ([2002:aa7:9e0d:0:b0:845:ec34:5047])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1143:b0:845:ebe6:417d
 with SMTP id d2e1a72fcca58-847a8224797mr1270415b3a.24.1782826026676; Tue, 30
 Jun 2026 06:27:06 -0700 (PDT)
Date: Tue, 30 Jun 2026 06:27:06 -0700
In-Reply-To: <akMoFqj/8Af2i/Al@yzhao56-desk.sh.intel.com>
Mime-Version: 1.0
References: <ajpGxu2uQys+S2F8@yzhao56-desk.sh.intel.com> <ajxasFBzp_9KnQLq@google.com>
 <CAEvNRgG1nHipzw4=eBgwhvyXi8xYo7FQD_sy9Ax6FDf7YDu3Og@mail.gmail.com>
 <ajyRg3BwGu5dCfOn@yzhao56-desk.sh.intel.com> <CAEvNRgH5KOHoemnC9QOn_oK97=KeAH1XuX3ps36-pJ0Fn0aBHQ@mail.gmail.com>
 <aj3TGLGWT1kMFIVH@yzhao56-desk.sh.intel.com> <CAEvNRgHb6WmOha6Pct_Tn8Ucuov95L=fj5=2R9gcHfx=b2V_+A@mail.gmail.com>
 <akI9m02jgKAdi4gX@yzhao56-desk.sh.intel.com> <akMPZePBdwQlD74H@google.com> <akMoFqj/8Af2i/Al@yzhao56-desk.sh.intel.com>
Message-ID: <akPEKslqAhygyjhg@google.com>
Subject: Re: [PATCH v8 23/46] KVM: TDX: Make source page optional for KVM_TDX_INIT_MEM_REGION
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Ackerley Tng <ackerleytng@google.com>, "aik@amd.com" <aik@amd.com>, 
	"andrew.jones@linux.dev" <andrew.jones@linux.dev>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "brauner@kernel.org" <brauner@kernel.org>, 
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>, "david@kernel.org" <david@kernel.org>, 
	"jmattson@google.com" <jmattson@google.com>, "jthoughton@google.com" <jthoughton@google.com>, 
	"michael.roth@amd.com" <michael.roth@amd.com>, "oupton@kernel.org" <oupton@kernel.org>, 
	"pankaj.gupta@amd.com" <pankaj.gupta@amd.com>, "qperret@google.com" <qperret@google.com>, 
	Rick P Edgecombe <rick.p.edgecombe@intel.com>, "rientjes@google.com" <rientjes@google.com>, 
	"shivankg@amd.com" <shivankg@amd.com>, "steven.price@arm.com" <steven.price@arm.com>, 
	"tabba@google.com" <tabba@google.com>, "willy@infradead.org" <willy@infradead.org>, 
	"wyihan@google.com" <wyihan@google.com>, "forkloop@google.com" <forkloop@google.com>, 
	"pratyush@kernel.org" <pratyush@kernel.org>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, 
	"aneesh.kumar@kernel.org" <aneesh.kumar@kernel.org>, "liam@infradead.org" <liam@infradead.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	"x86@kernel.org" <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
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
	Vlastimil Babka <vbabka@kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BA1F7100011
X-Rspam-User: 
X-Stat-Signature: gq7xpu4ct3x8z9ftzc3iw67soyohaygw
X-HE-Tag: 1782826028-755737
X-HE-Meta: U2FsdGVkX19Lk94wPeriVKtMWVa+n8sK0PyGrbggmpUoUsCgaS8nPLIYmxg8yq8UXix0lZhsGUzV3egDQHi3AfgzTwDZj7PkyPw+6KwACBmy7KLp0rQpDhGZsS6ao6zK2W187hVEBd7KUWh3SYExYW9RpstHs64UeZULl6GOlk5QZpakw1l32vQVpceEbkrcel6XolgzIlIPC90wjcipFsFENSQY/z5ME/LKov5KlJMV0yZzkacywu0WyBe/AwbhAFOgh1ruZK2rJU838uCsLclH3UTbTEPAXaTL0KCOcCrLhM78tdTgA0A/l9YIMcjGYpbnDX9cVoYokfVSdWuAO0qrxi7VE46lFvlJaUKmvMO5tT+YGRZGlDzW5xG9d+YaZ1uFz0SXAt95cHFX9T40nGv6WO+6seTNi6oq+Nd2bZBts5CgjMc/bcvG79q+PYllrWEt9X0mYVHDvz2AoVSn/Y77kWrguDKRo/+7qDSXPVaHCs7GrlK3nRfu9ZJqKsLVHh8U758ljrCEpQCGDipViyCp2k3bXvFb19sVoge09scLJ1zlgyJbuQJCpWOwxWIWHpM+jmJtamBW0w6mmzY0mWpemEkQM6akUBF0Lc+iU5IufDoPPviwXF9o6X+AAxPLHbbWO008YSn3hUYxNTpS4d6dAtvsCUp44Dz524XfrIx81tpT5GX0CTLk0TAowu/N4OB3iODIE9JczE6VI7ngdozgIzCEOZVKU8QPfAZa99PUJtqwW4UPtO35aKhGgdkO9gbxbABjpx+1mfPm9f6/QVuKTicllaRjcO5BoeXOlL0ATODIdV2AhEMniDjlGC6oa7ONfgLwLgNP8dS9EmWgX59sGuTT/Xx5Q5wP4RzSZQLbIeaQxoXxTURphEIn0FlsxYT+Y+EBQnW2KMcm3XErCU/GfXuBkbbMII9cGSa68ZBshK45jZljvRb5ITdY4IG/zME33Z4Mpv+YAWhXakt
 lp11jmsx
 TwTvemVPk9S7WJoDZva6bLPuZtD0k0QGp+4ZWBXuD8E4698hu9CAzoym4UDBvWY0d5qCBdtFXEyzaECGzJLhcBrUgs1HRZdN/g5rHJOwmXEC0BfphDo0CGmlbfdDLc8/Bn9sKBe4+r87wnfOKJO7TYLY+1ej5rn7q9B4AtXICF+cR3hlHDqz8+iqU2xz/lt4qrpGktbZj1tr/7ocdKohl8/ZJgnpgElvZ2D7/Z96D6GH7rlJDiMoiyhUSQGa43wsg83rCKSyZVC1cEbm3M2XkpWHAxwxDweu+DOWP5ZivIw6kvB0OGpMsJXzKaJEbioD4hPkh6IknDJm644VD9Jmxtf1fkKZuX0Pn78f6cTGdibYelYYeo3XKD7+hvjgFUPI9fHw4Q3yuWHJQxTDPi+iTup3IGrPqeF489/HakBBUvnmcyFCL0hUSyeSOEs6Vw7Va9YUydLctdWZUGHS0UH3dwL5VY5u1pnBaYV+2Q/nqmYA28YtQgIkuWbcLMI3d1234BaZi/97fmPlgvgTGx4qTzrrdhr1OzpQHJE5gTcWl9ZZDrmqzzCPSxsLXlrZemMVyU+iaWXP1+Nu47z0FIEYOLhSftzPpp5h/8MFvmUSSIHkStVI78rQhnk/CxoMzIG7lveLhwIkU+fl2t8eXRRSKRWXTfoVT8G47LC253Kn7jpF4GbLCjCrv30WJbtDG3dZUqg+9fr1ou661IIA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 30, 2026, Yan Zhao wrote:
> On Tue, Jun 30, 2026 at 08:35:49AM +0800, Sean Christopherson wrote:
> > Gah, I thought I had sent this out this morning, long before Ackerley's response.
> > But I got distracted by a meeting and forgot to get back to this... *sigh*
> > 
> > Sending what I already wrote, even though there's a lot of overlap with Ackerley's
> > mail.
> > 
> > On Mon, Jun 29, 2026, Yan Zhao wrote:
> > > On Fri, Jun 26, 2026 at 08:28:32AM -0700, Ackerley Tng wrote:
> > > > Yan Zhao <yan.y.zhao@intel.com> writes:
> > > > > But if a user configures 0 uaddr as valid, writes to it, and then passes 0 as
> > > > > source_addr(not from gmem), I'm not sure if it's good for the kernel to silently
> > > > > treat 0 uaddr as an identifier for in-place copy from the private PFN in gmem.
> > > > >
> > > > 
> > > > I'd say the original uAPI perhaps just didn't document 0 as an
> > > > unsupported uaddr. Given that commit 2a62345b3052 already merged, uAPI
> > > > was perhaps accidentally changed and no customer complained, I think we
> > > > can move forward with 0 as an invalid src_address? I wouldn't think
> > > > anyone relies on 0 intentionally being a valid address.
> > > > 
> > > > I could document that, if it helps?
> > > What about just documenting that 0 is an unsupported uaddr which will be
> > > re-purposed as an indicator to use the target pfn as the source, regardless of
> > > whether gmem_in_place_conversion is true? i.e.,
> > > 
> > > if (!src_page) 
> > > 	src_page = pfn_to_page(pfn);
> > 
> > Because KVM can't generally use the target page as the source without in-place
> > conversion, it's not supported today, and out-of-place conversion is being
> > deprecated.
> By "out-of-place conversion", do you mean using per-VM memory attribute
> conversion?

Yep, I couldn't come up with a better description.

> > > I don't get why the two scenarios should be treated differently:
> > > 1. gmem_in_place_conversion==true, shared memory is not from gmem 
> > > 2. gmem_in_place_conversion==false, shared memory is not from gmem
> > > 
> > > In both case, a 0 uaddr could be mapped to a valid page not from gmem.
> > 
> > That's immaterial.  KVM's ABI (that we're solidifying) is that an address of '0'
> > for the source means NULL.  The fact that userspace could have a valid mapping
> > at virtual address '0' is irrelevant.
> So, I'm wondering if we can document that 0 uaddr could always mean using target
> PFN.

I would document it as saying "no source page", and then state that a source page
is required if in-place conversion isn't enabled/supported/allowed.

> i.e., for both scenarios 1 and 2, al long as 0 uaddr is specified, we always
> use target PFN as source for in-place add.
> 
> > Again, just because something is technically possible doesn't mean it needs to
> > be supported by every piece of KVM's uAPI.
> > 
> > > So why not update the uAPI to handle both cases consistently? :)
> > 
> > Because retroactively adding support for out-of-place conversion is pointless
> > (requires a userspace update for a feature that's being deprecated), KVM can't
> > generally support using the source for out-of-place conversion (it's effectively
> > an obscure zero-page optimization), and IMO rejecting the out-of-place conversion
> > scenario is valuable for KVM developers, e.g. to help newcomers understand what
> > exactly is and isn't possible.
> Ok. You mean per-VM memory attribute is deprecating, and source page from !gmem
> backend is also deprecating, so we don't want to change uAPI for scenarios under
> gmem_in_place_conversion==false. Right?

Right.

> 
> > Side topic, isn't TDX broken if target page has already been added to the TD?
> > IIUC, kvm_tdp_mmu_map_private_pfn() will be a glorified nop due to the page
> > already having a valid S-EPT mapping, and so KVM will incorrectly allow a double
> Not sure if my understand out-of-place conversion correctly.
> Given target PFNs and GFNs are not duplicated, what would cause double add? :)

I was working through what would happen if userspace did KVM_TDX_INIT_MEM_REGION
on the same target page multiple times.

> 
> > add.  Ahhh, no, because KVM will return RET_PF_SPURIOUS and
> > kvm_tdp_mmu_map_private_pfn() will then return -EIO.
> My asking was if we could document uaddr always means using target PFN, since
> TDX's in-place add does not rely on gmem in-place conversion.

Yeah, I was on a tangent, ignore everything from "Side topic" on.

