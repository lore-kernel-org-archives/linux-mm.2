Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D83F4C982D8
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 16:56:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7F516B0098; Fri, 18 Sep 2026 12:56:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D56D66B0099; Fri, 18 Sep 2026 12:56:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1EE06B009B; Fri, 18 Sep 2026 12:56:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9FA186B0098
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 12:56:34 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3A442160734
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:56:34 +0000 (UTC)
X-FDA: 85227486708.20.A9F6043
Received: from mail-qv2-f20.google.com (mail-qv2-f20.google.com [74.125.230.148])
	by imf21.hostedemail.com (Postfix) with ESMTP id 47D1B1C0005
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:56:32 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=N+IIfK98;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of ackerleytng@google.com designates 74.125.230.148 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789750592;
	b=Dsh1CHsjBxTFDdDnp53edXCr1/zq18Lw7xmNdOHbBDpjnnbhqfTnfSWQiHL8vFaTBHFlTK
	ijHMn79p6vswQQNvX9+ESa6DnkD3TMK5dQGJeORWVfxLVKm+qpu/9+uob6ZM7mcAxcXJWC
	9xKTdhA3rAPFEUft2J5b4iZYGySGcrs=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=N+IIfK98;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of ackerleytng@google.com designates 74.125.230.148 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789750592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/3hfhz8Hbq1oioh3pabRNXznpcstGu9TRDyQ4WeUxrU=;
	b=fpjRuH6zxLRsLMDyo6k7/Voj7k2cUZY8pktFjhofT4Itg8+fvMRH0L79p+/XouKgPfrYE1
	On6lQbzS0bjbC9RNETuH3z01C9rMUmn01Mc6mQmTsOugrmCm3ILJ0e6Ex9/MJe5ZJbensm
	/Z0Kqc5je4S4rNQxY7pjpeJpp/pk++Q=
Received: by mail-qv2-f20.google.com with SMTP id 6a1803df08f44-90cdfc9b6e4so10113746d6.3
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:56:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789750591; cv=none;
        d=google.com; s=arc-20260327;
        b=IDZ6gMvBHRIgPpnCM2Jc6ZnfOse2rx3SIZ0Od6CGusE3o9Xl1cNbRsndiFo/EFImst
         YE80KLBHzFHUz/klpTxjfPdZQlGzes09hBcUSNdro7/I/ubTsCEyA3gROK55WRvEKjyC
         5+S5GD8mMAvFcgkESC/L1RWfjlMAv5AqTpZNeOxWH1qzNnkTvy6+UgBXiI4ApG/JXqFH
         VszVu7RQyzTHqEKY/VobB2FJxOC+9HrP3P3bfkSzsQNnk99zMnwoiE0Q1A/ZXB5+ajL3
         S5fiY6xmOfXJudLD13QI8EK+xrC+WdlY06lBKRDzLnJG7A9DhJmyXZlw7tnm8OA4Hqe3
         yrVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=/3hfhz8Hbq1oioh3pabRNXznpcstGu9TRDyQ4WeUxrU=;
        fh=238qDe0nhcz4FqLsSzHN6yU5+Jmz8YRAL0Z5IwplP8A=;
        b=BO7nysey2SVf0ew1T8HqWvjWDPFFCaWbNr1595Rs0W/WgdE9N9JjpzvlOUg/vUq1Zo
         hXCoI+3m6UIlqsEGSBjnXfWe2ZsIqu8VY90DpE9Yq36C97QJi6TAPDWMcBpVbUn/k0l+
         IuVOh5ljJrjl3lTHV8tOYVvhXmIKdb5UUnzRlsC28nUIYnCSP566hljubOcyyIpX+yey
         HXfTZYc5p+CSuvv8+Ooc5dxDMeE1QdbfKox26Vimh61Y517I7btem6uGIq2dBoIfkijI
         J54OatUlwn/XhtRvchLmc/HP2QuJIIvsCJFp/h9VNGx+BEnW2YcjMIMdggiS3hB/BkSo
         G20Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789750591; x=1790355391; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/3hfhz8Hbq1oioh3pabRNXznpcstGu9TRDyQ4WeUxrU=;
        b=N+IIfK98l5SUeMWNJsn8pOPoT1p/gHp1EFXW4dNYdoAU3W4GoL4kIm2bFEnZB49qvI
         qMB1/F4bSJeM50auJZY9jjnjGuaYywIGttbC19Gw9FzKcX6ONJOtUQC2Afd9L55YOIVH
         LnwqZDZUe8v6qDq2IBoNOOvfANtEYSLvMeCMbpbf3RrJYrUDEQCUZsQt280lN2TJxAal
         GFDTfuz3hoaXM/krz6JTlLwVg6rA6ASvkB0Di+QUJKnAkfyr2o3y59Uyntm+85d4DXkz
         lrFmSpt3CY3Mx+9r21vhwn8FjoAY/a59AABcU4KIroLQOikZeP0D4JxbyT61ONmpUEY3
         CikA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789750591; x=1790355391;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/3hfhz8Hbq1oioh3pabRNXznpcstGu9TRDyQ4WeUxrU=;
        b=IglbSCXDdcEeIudsYANsMFMQLH9oLcsi7BEmUORrH6WyxL+Sokee/U+CASf+wIe4MH
         XbFS9FYh3IBT8fCk44Z4n8qwoa5NiMRJQwTi6Xc/6+LKbGXj9ytOHPbuv4FE7vqihe5Y
         SQMkvgEm1p/vmtWH8Mlvm6dcugGnAJnaewDdyBcdb8GTSwRQWXwvZaeZHj+pW5pkz8S/
         pAQ4EWnY6WU9zkiHWkdId8Ju1mF18LC8SmU+mX3BSLvUNrKA78XyL8DlkF43eC9NgDL2
         ByRm7lrg6GzG2f6mxCKqL0Pca0gmCyoWuD0R4OOOtGxkAf/YuxvdWm3XBuLCQwo/vBEi
         c8Xg==
X-Forwarded-Encrypted: i=1; AKwUvBz0NWkehMxCO8QVNx6RY62NSzg9ddMKv6tMgtYmh3BngQ1NPPG2+aiJ7ruavZ7VbQiLUHpQmNt3qQ==@kvack.org
X-Gm-Message-State: AFuF++lvKGTXuyvDdw0HzL3W+znOdO8BSLBCEFjh+So4+f0upS6EAcw+
	/viLF6iSWN6CuGfx96BqwcnfjJA4/GL1+xlRyoZZII1FYPUkbFQMHAao3++UET6htsmVcs7cI7h
	d6zquA2T90ZDIpKLCbKI9zrqp8GfT0xzhcc2WzH10
X-Gm-Gg: AYBFou1+ddMsoeu3JSIUZ3ksVS2qSzpOvGwpsquD92PeQt7KTtLI3F+nsqZ5KLTTeDd
	I8ZlE1rHicbw4t9gVWffmdKpmZ6MPfh1YqpS2NW7YtHNQW2EP8PbmHN04H9grEHdGY8uT2OgUif
	wKuoH8TbWJLaIrBiAVxm/ZBnW6SbdCT4WPQgFm3lbhYAdy/5Jwbd195vLxnmDbiofaPIZ0LbAWZ
	C7ZmoVj4zW5POWNJ1Qtjg/nfuMK6WMu2g17KF0F0tXbE/50i6PVJroM2F7DbKcjWLsmfUm/wu9F
	UGPP23suucqwUS/yquNhMqlpVszG1r3Mh3hM9nHqjuBz5vDd2fu+wJG0lcmXibYbjT2JHlnzAeP
	prF7q8jNlSStdeQW4tpw11ut+pnuSinMyN4xnEP610g==
X-Received: by 2002:a05:6214:83cb:10b0:90e:94e5:79f8 with SMTP id
 6a1803df08f44-91254b3cc0fmr42995266d6.23.1789750590126; Fri, 18 Sep 2026
 09:56:30 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 18 Sep 2026 09:56:29 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 18 Sep 2026 09:56:29 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <aqw_uBIYig_uo5Eq@google.com>
References: <b91dbfae-20f1-4b9f-a25b-4397afae80f9@kernel.org>
 <16ffff40-4ef0-4312-a700-348603f05c0c@kernel.org> <CAEvNRgGW_VHmT82q+bUqHh_5G2Z9sUF1jJOTiVN4Z8_cA9A50g@mail.gmail.com>
 <aqw_uBIYig_uo5Eq@google.com>
MIME-Version: 1.0
Date: Fri, 18 Sep 2026 09:56:29 -0700
X-Gm-Features: AcwNN1X5D8x79th8tANMR24DjHce_J2gDtrs-KgBIrDOaE8qCS7M_N_lTAQKK6Y
Message-ID: <CAEvNRgGXi0U1gWY_m5aa5fW66fAXnU+3jw2sov3eykDzodvrvQ@mail.gmail.com>
Subject: Re: [Invitation] bi-weekly guest_memfd upstream call on 2026-09-17
To: Sean Christopherson <seanjc@google.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	KVM <kvm@vger.kernel.org>, amit@infradead.org, aneeshkumar.kizhakeveetil@arm.com, 
	ashish.kalra@amd.com, dwmw2@infradead.org, eberman@quicinc.com, 
	fvdl@google.com, gshan@redhat.com, jackmanb@google.com, jackyli@google.com, 
	jthoughton@google.com, kalyazin@amazon.com, kas@kernel.org, 
	kevinloughlin@google.com, liruxin@google.com, michael.day@amd.com, 
	michael.roth@amd.com, mike.rapoport@gmail.com, mvaralar@redhat.com, 
	pankaj.gupta@amd.com, papaluri@amd.com, patrick.roy@linux.dev, 
	Peter Xu <peterx@redhat.com>, pheragu@quicinc.com, pkondeti@qti.qualcomm.com, 
	prty@google.com, psalian@google.com, qinkun@google.com, shan.gavin@gmail.com, 
	shivankg@amd.com, sidtelang@google.com, suzuki.poulose@arm.com, 
	tabba@google.com, tatashin@google.com, vannapurve@google.com, vbabka@suse.com, 
	wyihan@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 47D1B1C0005
X-Stat-Signature: 79ftm6sx8cinar48ga9bn1htaa7cr8n8
X-HE-Tag: 1789750592-69777
X-HE-Meta: U2FsdGVkX1/oBNwURrI9L27EV1QEXcaVmPmx7BmHFiABgDW5uxyFtyhYFTXT4DbaqAl98rMvmoEvK3BGvg21675qt7yxWt0FxMnebflqXG9taICOKsOT2tn8amFhaSEfP+6TpkGYUQvwWUhgGfJVzIrqSwJ7Evao3TtucHclpayd1H0UyBzp9+P7iZH+SYzf8OzB9zPlvzU77nRqWaf2VJhu7b6Rc7gxtrDHQc9RSmvl3tO2MVmZ3vl0B0R1OXbVVnkobwcTm8djyyNX4I5GXfALJuGoS8cgsocAdLlXmkEqo9oXNin0U2j9lAZqwPPhQooq7noYFrnPO2CaUHiI0BJH0vTCnGvE/yq7Bp+hufQPb1e49nfDsrXtigYk05Pu5+HHjcdrx06sDa92Ys8zeMsxte1cHjM18T/naewNyKOP9xYL9ss8SgqIf6tiRVSY8JY74Q3UmUtDDB5wH6J050GVMAF7ru4i+h/GYjpxOEfRbqP3iyRKg/bBvzwnxvPdkyZ4sKFy/Lk+kg5eJD4Zep84hBnaWBOvjHL88SFHj+BxDK53qsi2QZGxwl5aoMXWJ5EWIOFUFYLFXx360FfFRFbxNCyaXAmCrPXpRGKmNnOberWbHueMaGi7G3AK7v3VXo7qmcEGDXGxAjCCoQqTJr7nAXbRjD7ByQwOVpiyXmPd44JbVatjOvoHA0MOx/BqbC3YJ1HdNUofo+MJid8wxhJ9DfmsLoy/r0C996m0U92fMo77h5ravboiOmmfM+d7ormTWPXKNyO5AcGIpAr2+CnCO6emj/So/fBpM4OcSOs1DxyHnp7DGmUNKaMk38efVkEQuQHEJ1QLHgyq5U/afesaADPbvnBFJbzYA8xCSobSRpKGO1xqU6TJsPllLRZkOIRc6SJZlm6crigzTywCYJKSEHZkqSlWZyn72FyD52oeiCi66w82xsit0LzESsZ3JBIsBStjDd25sbVN8Vd
 PxcgeE3S
 chW7CCcjDug+1XlwZQ4lgMk0nq9WxEMJtSaL8IGRa2HolMemHjpBsUALY66x+3CcM4pk42YqOSyx0tZGef30Oi5OxEyFx12kZuKYBnkUnlXJPfihSOKklvY/2rD5JZUmHHc330w20IRddkYZzMtP9ijjbgl0EyUJp96FN5hSNY8Fmjnu/Z5Nl3ggswVN6dTOosvTDzi+fh4szYHEmreD6R7XsIh5/f+d3CJpyRXWToERQHcPnjJZPfSOq1sMWhWnfz1nDFLyyBhIbz6CyQd2tD0VV52/nudnIN8X4q9tmHAJGlEm8HoCqVczgqF79V5qXcRhHoJNTE1sv7V5h3lcGNapakFw0QP8tc91nb2NbUZc/S1i/KXjOCRj2NiRv6GRrYbhyb/KTTSGjwqjeSP1p0vkyPUH8xOA5u7jJ1cGeEReQViVd5i0HgfvwcFaC1uTa5Beqg8UyTF4HcfbfyJCu3rO2xrjWfWTqkQqde5DVYCsP60Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sean Christopherson <seanjc@google.com> writes:

> On Thu, Sep 17, 2026, Ackerley Tng wrote:
>> At the call Sean suggested mirroring the RMM's tracking in KVM, but that
>> sounds quite arch-specific and it's like doing arch-specific validation
>> within KVM.
>
> I suggested "mirroring" the tracking in KVM arm64, not in guest_memfd.
>
> E.g. put a structure in arm64's kvm_vcpu_arch with a list_head object, then insert
> into a per-VM list store in kvm_arch on a conversion request.  But before inserting,
> walk the list to see if there are conflicting requests, and if so, reject the new
> request.
>
> Then on KVM_RUN, if a vCPU has an outstanding request, verify the gmem page exists,
> is in the correct state, and is mapped into the guest (or at least, is known to the
> RMM?).  If any steps fail, exit to userspace with -EFAULT + KVM_EXIT_MEMORY_FAULT.
>
> The downside to such a simplistic implementation is that it'll require a per-VM
> lock to serialize the requests.  If the contention ends up being too painful, e.g.
> because there are usage patterns where guests due batched conversions across many
> vCPUs, then KVM could use a more sophisticated approach as needed.  E.g. shard the
> tracking+locking at 1GiB or something?
>

Perhaps naive question: What if, in the complete_userspace_io handler,
RMI_RTT_SET_RIPAS reads the vcpu_run struct and passes on exactly what
userspace said was handled? (Make the vcpu_run struct for
KVM_EXIT_MEMORY_FAULT bidirectional.)

Is the issue context switches? If the vcpu continuing the vcpu_run is
not the same vcpu that exited?

Perhaps userspace can track conversion requests, like on
KVM_EXIT_MEMORY_FAULT, save the request as <TOKEN>. Then any CPU can
take the token and do the conversion with guest_memfd, associate results
with <TOKEN>. Then on continuing the given vCPU associated with <TOKEN>,
pick up the results for that token and continue.

With that, all races and errors are for the guest/RMM/userspace to
report and handle.


>> p.s. Fuad, for pKVM you also mentioned that you'll need to check if the
>> guest had requested for conversion first? This might be the same/similar
>> problem.

