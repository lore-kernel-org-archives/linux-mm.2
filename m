Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 184F1C5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 14:45:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3956B6B008C; Mon, 24 Aug 2026 10:45:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3457A6B0092; Mon, 24 Aug 2026 10:45:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 235706B0095; Mon, 24 Aug 2026 10:45:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EBC4E6B008C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 10:45:51 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7DF7080167
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 14:45:51 +0000 (UTC)
X-FDA: 85136437302.19.6AFC8A6
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	by imf31.hostedemail.com (Postfix) with ESMTP id 7F8FA20009
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 14:45:49 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=GWr5oeJw;
	spf=pass (imf31.hostedemail.com: domain of ackerleytng@google.com designates 209.85.219.49 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787582749;
	b=p1mRnpAEagNQfwEAahyvWHaQmmka+T443tmyz/Fnxa3II33sKQ0ITndqMJ0vBVvzmBARIr
	VcBHGDJMvQHrrrcB5OeLtY5v65msSzNFRzSHXMe6it92GTajpO+qUgXIBP2MALs67bnllU
	wpwjL5XX6RUN1qGdChqM+lib4RKbIz0=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=GWr5oeJw;
	spf=pass (imf31.hostedemail.com: domain of ackerleytng@google.com designates 209.85.219.49 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787582749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=skkP3oMbeet6bj4bc4/M8i6L8abYIXvlg1WGbPCJGYM=;
	b=h1TRcnUYbmsEjchUpue4T+bx386yvUsaEaKshTT1m+mM+18kpNMh71+iN/KGv8L1eCH+KS
	FtaoAgOsi2dQchkadux1GEt6XflbSxI+y+Q8hOaDo1OGuprGk/AvaJc9GriXSeeQtfL6iI
	cKHoVVy6WnI78st7WgeiRn8BZh2Zqg8=
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-90a6b298889so28908446d6.3
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 07:45:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787582748; cv=none;
        d=google.com; s=arc-20260327;
        b=dPgwaun9lfl2Ww8new+v+y13qa7B42jBn3x2DHuubnSieUqMLDdO3n8zobtHni4n+w
         sssZk0PYYhw4QAf3cl/wERo8/zs2YIa/cQGog/kvUIKVzAgJQtU8NusbjRNiNCwMLttc
         F31dLg72QUVRq9wATHrLgEqGdtTHyydaPQ1gzZQGF73HSfjNXEeycTm5jdgWybMtR89b
         W26wybzba+fl2vpo0WJigWmDFJ28zC155QvXkxdHdS5svVSXZNiditGKjXOVTwVhfK1T
         eMP6gC1wDwha1paLkGGM1VHyBEcDS1Beew+IgCliBb/C0znJOmeSnbu9+Y2yArDt6nFg
         BT2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=skkP3oMbeet6bj4bc4/M8i6L8abYIXvlg1WGbPCJGYM=;
        fh=kXOrzzt2Ty+VDzmfYIiJ4V3h51rvUZfoO6UFt/awYk4=;
        b=rgOS5Xry8olt1B0Xg0P9tCK8exPYaru4/H4eOGokFnBL6i/QnzSQIkakIMA/TYCs1G
         OFpMJOpUS/raUDke2wBce3KCEyagy/cM7EAWzhynKep8YJid4iMhukNffp67wY/M+xqB
         GfPo00Y5ujxtCNOmwModiT2TPKsd3VsTA/0KXV4dTngnxotOUzuVqJDjoNGrkBUJ6iSm
         5BqMpgvvj3AD+0VnyPicKlv/b7BY6+lXky9Q/S/Z9/4IlGrsgE2dkBncoDPBbE3sOV7V
         eXut+gOBWzfci0RTNiL9jxbcyocZXUFDilm7ppL+vKxdDPdp6O9H//n5oEMUdmFgoAHa
         Mnwg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787582748; x=1788187548; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=skkP3oMbeet6bj4bc4/M8i6L8abYIXvlg1WGbPCJGYM=;
        b=GWr5oeJwga+RZNMvzEuVcXOduPYHSsUnGqXGb1PH2T77w6F7Lby+uk+yvv0BgCRpRQ
         bmavOO10xPBGEOUshO+7u4Qlv9cotM84lkAHcgmn+eUMDN+gKxqhtE/q9750CK4cp7j7
         qXIC5Iy7xTkm1FdAE1kyVASAzenVteSGXDQC7FHSNG3rcAQ2zK4eqW8FRwpHX8YMSdJi
         NfSN7nPx6BkJ2yOfUrhoZmCGN8m9Uw6UtPsyGm+be7DnpPvaXW/xevUWjsiP+iLJwL7n
         ATv+NLPbKUJuxgNbRjlQOH0+HDsDVE5BwWT6hzZXVJupJAw5LKtHgQrQKUnSszQthcMu
         xQ1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787582748; x=1788187548;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=skkP3oMbeet6bj4bc4/M8i6L8abYIXvlg1WGbPCJGYM=;
        b=CRgDf+xcWqs+UgvmxbnvUghulNkrcOt5X8Btu4y9fM0ACEDRBEt/ks+k8qfpLiux8M
         4M9BFSh7iwskKozbvGLLY8s5LuCAfoCEK9nJU/PO9KsNVNEmHfCC0VDFy+QBysj6kBOg
         MOnpGn7DnOib/E/XpaU6RfCZPl+bJPsGmOCZycngz51C/tOXkX+3akfnrR2hcOssbcHp
         obdcqXGDZikD9h0U7FbCle86qq4jW7eF4okZvrc6PZ18vsc0orzxEvD74rgwE47kSrQU
         2HV51LrrafnF98R0tN6tSf4P2tvrsMUEHHmJgi2ENbGZBA3NJtB2SONacbXEB9YXLgGk
         NMXw==
X-Forwarded-Encrypted: i=1; AHgh+RpTmiVjBww5qt9wS71xCgzuIBiGYlo4SzARitZsNvb4H/Igbxdmn307PXKaCEjrcUrFjPww3c0RQg==@kvack.org
X-Gm-Message-State: AFuF++mpWBjSpgfIMdTrLX9DMeiVTJ6FFBhygKuJmeJtSSJUIwJbZKn6
	GrPwSqqd8ZWoZK3GevaKjBtTchXAvBIWERnF8aUnZP2IkoH7LgZs0uIvXT9O6n83FbY7Zn36UAg
	5jxbjAG9/5hJA7yVMQJCDs/gKYokwedxM8UDl5YCY
X-Gm-Gg: AR+sD10V14IUNAWhqPaZLXofWA5o8ltTx8T65hbe9YT0OnmrWhqUTMqkq4YSbrwlL15
	hH+DvOo5pkCWvk6k753bRdSANRCDxsr5/6VtamKfdKhQSC28a3Le1+1k59E55qdX8YAc3r9bnVw
	YkK85M6QusvtqMWx4UQoaiDlgE/rwlHTjW1Ubwe+iCWYsrvXMSKfKCwNO/Be8keDlZVBCi6nOsi
	hhO9A6NeUACzBfrWLAa+IlKePCnw2rnuLTuD0NOMzTXXuosEUifFUE8FyZ6rulvaSChq8ejC8gm
	5Kuasf0jiXYnYj+8eQ6eBYMOM1Q1V1UA2Mu1UcAozRlgEODfWdNZ1ZvM5tmPNKgLYjjmkB6BL9m
	/7MY=
X-Received: by 2002:a05:6214:246a:b0:908:2369:df1c with SMTP id
 6a1803df08f44-90c8f9f6e2amr182627906d6.20.1787582747578; Mon, 24 Aug 2026
 07:45:47 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 24 Aug 2026 07:45:46 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 24 Aug 2026 07:45:46 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <a410cca6-0776-44af-8353-9b7375e2fd4e@intel.com>
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
 <20260807-gmem-inplace-conversion-v10-7-2fc18ee6d3ba@google.com> <a410cca6-0776-44af-8353-9b7375e2fd4e@intel.com>
MIME-Version: 1.0
Date: Mon, 24 Aug 2026 07:45:46 -0700
X-Gm-Features: AcwNN1X5oDcPBaq55pm-MNepv-y7g9QlVSIhzW239c93dbXJQTRPUD7hBagIvPo
Message-ID: <CAEvNRgGvxMus6pp=xuDYOumH3Ge4oi0=YKjTaFykFHwXuzRDwg@mail.gmail.com>
Subject: Re: [PATCH v10 07/41] KVM: guest_memfd: Stub in ability to enable
 in-place shared<=>private conversion
To: Xiaoyao Li <xiaoyao.li@intel.com>, aik@amd.com, andrew.jones@linux.dev, 
	binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com, 
	david@kernel.org, jmattson@google.com, jthoughton@google.com, 
	michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	shivankg@amd.com, steven.price@arm.com, tabba@google.com, willy@infradead.org, 
	wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
	pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
	liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
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
	Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7F8FA20009
X-Stat-Signature: im7k19jxdiemfprwf163z31yqmi14sk5
X-HE-Tag: 1787582749-235616
X-HE-Meta: U2FsdGVkX18eqv8EWcC+KlYqs1xQzrz5uEsR/Qgp/v40/Oq+703phKs1U7KyDMhHX7a+5XavqcSa3DmCMjJ+tk543iTokpaxrOpJk5wj1raYshWin6CIpTyVpZQMC2pRj3jyklKe4uMD31HjkmgZrsHznjroxp9uYSy9IjXOglzF/g8VvI33P+Q4VZWxQAzzLZxqAdNztl5qhF/vNH6kX4bG5Rlc7l6Q/XQweWMnc1BhvYZPRav+KnPvfNI0MuUkBgwyJb7Gx1+IPhg+4H+IJj2OHHlImEobowUHWHrvEJcdIZmCXWvpJTiKJYoEjrKFGbOSIKTt29LMA5n81UOF/9fe3cQtLfG8so33fKYIAGD7cP57IsZuAyDtKpqA8TQNP/qgXGP/wiwDeQNHKU08OaUZXPZhjbIU2IOglUTDfjFAeOSwKk6iWCZD2Tk5vdf0DQGX+Bw3jcA7lI/R9cx8A4hlrNjgl7bTq9LesiIqQELG/EzwBjHCly3AkI7FryUfK2CIIX2Q8AMKMzC6jVm24QsjpINWled1MDlislvx9Q0xP+EyIbwZ/eYPMO2GcTckw2qyg0q52bK2itv3vBbFrN79RBAb/ECmfEWJc71lzs7tJz6sFsXdQakmFPmKGq0peaEKSYLU8DBUJ8KJKVupQfS+fbJocuf27UqcnAlt+EIHFyoy8gHJ/yMiC73uTWlfMkHVvariYVEIJF+FQuRl+u9a9t90k1XB+qskIG33ZN9E2uiCWkYlp11fg8yUnzZUpifnkwHPGtwMj/92miuxPDsf4l28gNSXCgHXncne+KuD6OgU0d5GBX+45IYOr5ybzw58jlZBH5hFtZDhWZ/giIC55tY3zJ+NmsqkiJ5zeu6l6Ld65uvEM2AcnyiahEkooS8Ea/pqiecY3lmBAmTjlItWFgAktjU3MeGkwvUObpTSiLFeo0RB6qFhoFgF9A8OeQhblIu4T2mfc0+1VSR
 vcvH3Gjx
 7HyfZ260O//03buHXYLuCVqnXRoXKzq1zOyv0Pi6MvBDCkdWBLjlQc8EbsK2lLaNKFCqP+JM0PddIqNvVP22t+0KMhvHPgKPU0/+zuWxH4VxZB1NKWNbCN4egau+UNEy4Zuk0cXydUzNJu5g5jcHt1rrwAu6lxlUkO8i9bUXkrqePesI6c0BaQP5/3Ukbe4tgohqKs2JlQt3GLWSby75gCSaNopZjt8M/nhmg6eSPRXKpgnj7bZyvVJmMb56rC4Ent7BigMUO8NbiKsx3iqAMBtis9gSNyx9Q0125rjI61nP2wZvnqCznU/IBXSnMrApq8rt5AUtorYnZPFD5hLhkI4m06+nATmZDZj3ZDizN93CC67BTlxI2Pkg2tHcpmuU4iufEyrJ6QLhfG4w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Xiaoyao Li <xiaoyao.li@intel.com> writes:

> On 8/8/2026 5:52 AM, Ackerley Tng via B4 Relay wrote:
>> From: Sean Christopherson <seanjc@google.com>
>>
>> Stub in global variable to enable in-place guest_memfd private<=>shared
>> memory conversion, which will eventually be exposed to userspace via a
>> module param, and wire up the __kvm_mem_is_private() static call to the
>> guest_memfd version when in-place conversion is enabled, i.e. when gmem is
>> the sole authority on private vs. shared memory.
>
> I find this patch changes the default memory type for a @gfn.
>
> - When memory attribute is tracked per-VM, the default memory type is
> always shared.
>
> - when gmem_in_place_conversion is true,
>    - if the @gfn has no memslot, or the memslot where the @gfn locates
>      doesn't have gmem bound, the default memory type is shared,
>    - otherwise, the default memory type is determined by the
>      GUEST_MEMFD_FLAG_INIT_SHARED flag.
>
> I think we should document this change.
>

In a way it's not really a "change" since gmem_in_place_conversion is
set up as false in this patch.

When it is enabled in a later patch, another way to see it is that the
default remains "shared unless defined as private".

Before:

+ no memslot, or memslot not bound to gmem => shared
+ memory is shared unless VM ioctl used to make gfn private.

After:

+ no memslot, or memslot not bound to gmem => still shared
+ otherwise, ask gmem about status, which I think is already captured in
  the module param concept.
    + The very usage of gmem (without INIT_SHARED) is defining memory as
      private, I think that is already documented elsewhere when
      INIT_SHARED was introduced, that now the default is private.

So in summary, I feel that this has already been documented in various
places. I'll also add the following in v11's "KVM: Let userspace disable
per-VM mem attributes, enable per-gmem attributes", in
Documentation/admin-guide/kernel-parameters.txt:

	kvm.gmem_in_place_conversion=
			[KVM] Controls whether KVM enables in-place conversion
			support for guest_memfd and tracks the private/shared
			state of memory per guest_memfd instead of per VM.

			If enabled (the default), KVM enables the
			KVM_SET_MEMORY_ATTRIBUTES2 ioctl on guest_memfd file
			descriptors and disables the legacy VM-scoped
			KVM_SET_MEMORY_ATTRIBUTES ioctl for private memory state
			tracking. Only the KVM_MEMORY_ATTRIBUTE_PRIVATE
			attribute moves to per-guest_memfd tracking; other
			attributes remain per-VM.

			This parameter toggles KVM's in-place conversion
			capability support. Whether a VMM uses separate backends
			or out-of-place memory management is determined by
			userspace VMM design.

			Note, this parameter is only available when
			CONFIG_KVM_VM_MEMORY_ATTRIBUTES=y. When
			CONFIG_KVM_VM_MEMORY_ATTRIBUTES is not set, in-place
			conversion is unconditionally enabled.

			Default is Y (on).


>>
>> [...snip...]
>>

