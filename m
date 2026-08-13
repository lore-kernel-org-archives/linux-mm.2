Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8FEBC5CFDB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 21:02:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C47B86B05C9; Thu, 13 Aug 2026 17:02:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C001F6B05CB; Thu, 13 Aug 2026 17:02:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE8356B05CC; Thu, 13 Aug 2026 17:02:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 87E306B05C9
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 17:02:01 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 969D61602D0
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 21:02:00 +0000 (UTC)
X-FDA: 85097468400.17.FE2700F
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8DBD920009
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 21:01:58 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=UQ7HJgHv;
	spf=pass (imf13.hostedemail.com: domain of ackerleytng@google.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786654918;
	b=CDfMsDRK9mj1SgjHETVRBWRxhREM5lUK39sDTbbNA55iLpchoyoPGB6DphOTTRdBtMTClL
	6pzbarIig1WBaycfCB4eGDgyCBy/j/v8qC3aPOQP+c2SrhR11a3g9dkBYNrX514Qs8HuV+
	q/P5aBLF+pDhzOxD+7DMAMQr2eP4rUI=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=UQ7HJgHv;
	spf=pass (imf13.hostedemail.com: domain of ackerleytng@google.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786654918;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ScWN871Op0fwwgzG1qLzviyqH/P4Azji6iscDLhHJjo=;
	b=fMATMaZLhFdWWm1JTkHcmkm2DHzWG2BHtEvWTK82BxFFqsc+L4sRFmbTnC2Mm/vJDN4wUJ
	urleLKVxeimL1cJIJmI1usXmc7aznSb2962sh2FT0Xp2JsoKaS/v4VIpKQBnJ98/t4nlV2
	SvOaQ8i6FS0rDU+Yiy0bZBV3h8FQhEI=
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-38e42560ebcso287258a91.1
        for <linux-mm@kvack.org>; Thu, 13 Aug 2026 14:01:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786654917; cv=none;
        d=google.com; s=arc-20260327;
        b=ENAMvBRfp0/FoXOxUZBrby/Ay/BALKAamCAoBzdTCVxwIo4VrBw1y7P970SzqmVLXH
         5Ob4I+RTvvuisEw3xFRuHMhVNeMOe2/TOsvfwZfIPH+tVpYLHQ8gFmdmDG0Z+Pd5ovwG
         AUTt1tj0YXT0s78oV6PVMtEAuKAMpMFJcYpRjJt0Ivf6eKFVco6ACsCmuuV0tAN9CXsI
         Z8W82ZBfJQBranm5tH7pCnH11SCk3+g4+vejgrU3WjM/GiUgg0+jnV8vFeuBan3kHSlc
         S6f/dSbcgQYkGjTz2PdV8pkebkrkHQIyw1BH3Ko68tcmg49OqhWasBcsCXVeMpXgiZHo
         giaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date
         :mime-version:references:in-reply-to:from:dkim-signature;
        bh=ScWN871Op0fwwgzG1qLzviyqH/P4Azji6iscDLhHJjo=;
        fh=NPZRecqoInv2ehcvPwT34T7v1YH6aUceek/n3yE+KdA=;
        b=d0ofowcw1o1O/iay07RT1lbTWm5xHtIajKW0O/f3CiLLv62b4HZScBbMd2o05+Yp4H
         QfKcpbJ1zIqvJE1Sw9Xb6b1JkRYPoITco9BGxsweoyhRG/vhpFqMcQ8yN314B0tVuU8S
         UuXxH2XB/4Pm+dTLepqE2ooueh9QvaTBznczZw+L7VX23QfDj+ndPObPGAwm9Zh2XG6u
         h61dUDb31+MFWURJY8hsm6dwUgISwwAsQGRD1S0jOZuyV6EAK8QiR1aq5Wbg4Zh+MbVs
         UPCr3CKqI0bkelgvfZ57Ybu3pcoVke0EE4gQ259dwVxMC9HdGaBMeYddf/yNtd0CCV6S
         VbzQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786654917; x=1787259717; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:mime-version:references:in-reply-to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ScWN871Op0fwwgzG1qLzviyqH/P4Azji6iscDLhHJjo=;
        b=UQ7HJgHvOqMzgEyaI3o/hbtsBuoafwPV12ovKXCRf9MzAS2LSNerJkxl60PrbDA0Ba
         F9xnTWQb+FER4OL0iOSTsCSheIhBwyE7MM2MjYaBOXgluIFlZryz+HXfkH9clw+KgA3h
         ZPSbNZ+Kk9QTYApvjX0PnSEGvMxua6dsy3Op9+IrysBgaP7ETgDFCaGKvK5Eq7Xej7E9
         dftTThus02FIiWAnFPS3rTStFyWpvs9kbJN2EoQk5bpjVBbdVH3VoWKnapgq8ZIySxHB
         d1cTMKosO87uHtEpfxV9OIe7z4nG59ypVPDr2Dk6zZCcwvwUQW++z8/o2xRjCuF6eJeR
         PYBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786654917; x=1787259717;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:mime-version:references:in-reply-to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ScWN871Op0fwwgzG1qLzviyqH/P4Azji6iscDLhHJjo=;
        b=SJBnu0UUtyrCo6rjTk1s3cBXjbe1AN7jNhZkCag5rtBtjB/Gs5mnfYmUTEHpeaa+Kg
         H69hGlJmjxLe1EDACUoZshVbKA4vFSaRqCdfEqMgBS4iw+OsuOA4brs4dnukZK1ed4y4
         DgBHZXKwcKHKD8vlFJW0db1FNKPXFczYjFNzNftCQLzyCfORrkbOTiIckFA59yrq+b/h
         JOXRP5Vd0oobN1VBFIPOtMKSepVkOOD9fMniEtzyuuOhYb+fD5nNzrmoZ8GFErP399cM
         RF75mM0lTIizkKSfbrE9lKeNe74H4guyPiIuf+j4uySjPP/1LNfgH7PPSJU5KIn389vj
         M7ow==
X-Forwarded-Encrypted: i=1; AHgh+RoFUOCnQcwRFYs+S+3dnh2n5NTzj1ZKRtlxZ7mDxRAZx1ZX91h6MIQpW+J7JdYOivSkujzTNnXADg==@kvack.org
X-Gm-Message-State: AOJu0YxHh1lYV/cMPVJdfXWPqB7Yu7487THuk5oOZxE8qaeLhvl9mYKR
	JL7npHRBv7SslviOaQapWPb+tIfRcIJkWkz5mm+r/z8mwD1WpszEvY/who5j2YBWPD89hReymFT
	SO41tkTBttFcCG9ksfWe563VaiiEj6qwmx1sZyXQ3
X-Gm-Gg: AR+sD12TkOxR8D1xhacHNMdElOKSCXxBG4bC2rW42zVQBaB3wA9T0em3kda7QWFdOqk
	CyGJzsg96sEZUqXZ7gyU7BgIMsErFVCmUuL2MQ6Hf62hqGcS5rOUMVUfSjFcmjV0YBSWX8IDw/m
	qwwiI5//eLUVT3ydZiUV5EhEt8OpsYiCkby4LOBJ2zms9vLoKnUHqNWWgvbVZoBkHHOML0Xo/g3
	Q5+dom9il8RuJ+2Cm1bkxpLRqk0ZZfj/5hgDiN8p1yoYDmoJWW260QCOGV8Et5v+AycWE/FBK7n
	NFm8Tk86i/7LpY8NIskIV+QIR3Gz89YRL6yJXeFGRcvHnYGK1aaJ52BWGUUMUdjof77vZz/cRXv
	k84FvkXpW2KukhZvRPwTczAHGxIrkVg==
X-Received: by 2002:a17:90b:3147:b0:38f:1a2e:6e56 with SMTP id
 98e67ed59e1d1-3933b8825fdmr709898a91.9.1786654916555; Thu, 13 Aug 2026
 14:01:56 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 13 Aug 2026 14:01:55 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 13 Aug 2026 14:01:55 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <an3o4h-E8mj6CUaM@google.com>
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
 <20260807-gmem-inplace-conversion-v10-12-2fc18ee6d3ba@google.com>
 <1ec08cd8-3072-4753-ad5e-cd34956647f8@linux.intel.com> <an3o4h-E8mj6CUaM@google.com>
MIME-Version: 1.0
Date: Thu, 13 Aug 2026 14:01:55 -0700
X-Gm-Features: AUfX_mxCp5gPchMRxL80fZacuO-M5ybDdte9e0UhxtiZjcdkxnSatGLDZOBypz0
Message-ID: <CAEvNRgGpCVCGVjc9jCt9Yr+XypF=71h6eBahkXNkrXhfrtGY+g@mail.gmail.com>
Subject: Re: [PATCH v10 12/41] KVM: guest_memfd: Call arch make_shared
 callback for to-shared conversion
To: Sean Christopherson <seanjc@google.com>, Binbin Wu <binbin.wu@linux.intel.com>
Cc: aik@amd.com, andrew.jones@linux.dev, brauner@kernel.org, 
	chao.p.peng@linux.intel.com, david@kernel.org, jmattson@google.com, 
	jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org, 
	pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com, 
	rientjes@google.com, shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
	willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
	forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
	aneesh.kumar@kernel.org, liam@infradead.org, 
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
	Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev, Fuad Tabba <fuad.tabba@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8DBD920009
X-Stat-Signature: 4jga3n97fptb4bzrasq81enwbdim41j7
X-HE-Tag: 1786654918-46338
X-HE-Meta: U2FsdGVkX1+nlLYMkShPOF1o4/t6tREk/FGp/mv4Z2OnfMyozuYGZ4iGKy/oSYlTVkZBRwSOWGJrJG34D5ZW5rze2fUELxwQaGqze7G3J26Xpk6gcq/pEYAT5jJK1edscjmQXxm7HlwGlrO+8f2MpFJpxcOCDDiln0gTOaX05HmUEB62R20z7TjqHiieBWO0uxiMCwuPDu++8ugUJsVt1Kk6lUcBLZ0NXQssfH1YZhLrrlPdV8efWQslSfMdS6A4B6SBNT+eCml0spSD3Fp/FB2TLZjE92X/JyOQb8Q9fKIgDkayJTqcuagcIoZBw4CuzszKjV1ORJ6dqOAR0FCCAIBralIr+r+DnI6bVTjHXJvJ5HuZyZ+60nPAOxqg+TIJZtXDMb+PR3mjmX5r+6wrCwtAAqTT3ZNaLAsT4+ystldRHzEPk7D/b06inz6r+dG87Uqp43Xs1rC0qOW/lSBkgglWeWirNRIuA4GBfKZmIxONSKW+UZbTMJ1fYPvMiJt8rj3QUaT5Vl4cOjukE8Pqn8+yCNNNRcwoHVS3bZF1YLNy18ghdVgRn3D78EMrXCR/BvMrb4aq00O0m3rPoY13XA3CTFHntlAKqzwZLI7jR+qb7AgglhNnk3YK2g1uwyH2ZWdYY7sXO8byhSCnr47JMIp7JjSs3OMtr4csXmv4oDV1QsyztPaKF9++pz5l9WU0LIeOkJBMhZYdON4Wr/C+xeUhfzOovZ4gxGHTP6DA8Ik92L960Zrhcr18MvoA9rI+ReyLsLpAbJG0srEfncKtfAGWsCQUiAYgDNm30SI2TidnM95BSJqKSgZakib3heVKRfx1GhSVmpThJg8qRehf77WmVpRhPfLOcj9BpOKHSxOtn5gJ093pCRY9xI7YZve2o4Pbd0f23qOyuEuy0grWh57606n2RfEc7dNzbVCVtRFQBzY2QKwP9A8EOnOCK82hk2Dc1w/1csLq7tZYJkm
 UOz0zUxK
 XfDG9ckyi20iBrrB/dyFYwt35u/2ZgZYw/hyfZbPc8rlRpjwmG2Ir9ZDvcCaV5NIzCztcFBZa2iLJu6TIKaYKnPpRpye7lZ8R/TuXmXXwmpazh0FoyuPW7RT3wpGB1QeuVc+RHvq8lAjEinF+SxNk1GcagkRHkt2BsKdocs654B0WZzxM5cgB6mSSZbmWe5HreqBSkT9oIwlzFtAsYFqLeP3KJW1YJinAZw/oaZN3Gv+sZkyrxpiP4X3M82EmLU5swNp5jW+TdIFq7WL4+fIb+DDFqwoouGh/t4VzJ9dT3amFBzNSFNZCCcKujfBwouwUXPy3uxfaik7/HGhtcB5qzKAuoXvftXDA6BLG53UkkMttvLfgsWXwIkAVm+F2g489aI1tnYgumnrYJW2611o3CrpIlPuGaRpU/24S
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sean Christopherson <seanjc@google.com> writes:

> On Thu, Aug 13, 2026, Binbin Wu wrote:
>> On 8/8/2026 5:52 AM, Ackerley Tng via B4 Relay wrote:
>> > +#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT
>> > +static void kvm_gmem_make_shared(struct inode *inode, pgoff_t start, =
pgoff_t end)
>> > +{
>> > +	struct folio_batch fbatch;
>> > +	pgoff_t next =3D start;
>> > +	int i;
>> > +
>> > +	folio_batch_init(&fbatch);
>> > +	while (filemap_get_folios(inode->i_mapping, &next, end - 1, &fbatch)=
) {
>> > +		for (i =3D 0; i < folio_batch_count(&fbatch); ++i) {
>> > +			struct folio *folio =3D fbatch.folios[i];
>> > +			pgoff_t start_index, end_index;
>> > +			kvm_pfn_t start_pfn;
>> > +			kvm_pfn_t nr_pages;
>> > +
>> > +			start_index =3D max(start, folio->index);
>> > +			end_index =3D min(end, folio_next_index(folio));
>> > +			/*
>> > +			 * end_index is either in folio or points to
>> > +			 * the first page of the next folio. Hence,
>> > +			 * all pages in range [start_index, end_index)
>> > +			 * are contiguous.
>> > +			 */
>> > +			start_pfn =3D folio_file_pfn(folio, start_index);
>> > +			nr_pages =3D end_index - start_index;
>> > +
>> > +			kvm_arch_gmem_make_shared(start_pfn, nr_pages);
>> > +		}
>> > +
>> > +		folio_batch_release(&fbatch);
>> > +		cond_resched();
>> > +	}
>> > +}
>> > +#else
>> > +static void kvm_gmem_make_shared(struct inode *inode, pgoff_t start, =
pgoff_t end) {}
>> > +#endif
>> > +
>> >  static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t sta=
rt,
>> >  				     size_t nr_pages, uint64_t attrs,
>> >  				     pgoff_t *err_index)
>> > @@ -599,7 +636,12 @@ static int __kvm_gmem_set_attributes(struct inode=
 *inode, pgoff_t start,
>> >
>> >  	filter =3D to_private ? KVM_FILTER_SHARED : KVM_FILTER_PRIVATE;
>> >  	kvm_gmem_invalidate_start(inode, start, end, filter);
>> > +
>> > +	if (!to_private)

Should I make this condition

	if (!to_private && kvm_x86_ops.gmem_make_shared)

instead?

Will that help?

>> > +		kvm_gmem_make_shared(inode, start, end);
>>
>> If both KVM_AMD_SEV and KVM_INTEL_TDX are enabled, HAVE_KVM_ARCH_GMEM_CO=
NVERT
>> will be enabled and the logic in kvm_gmem_make_shared() introduces unnec=
essary
>> overhead for TDX.
>> Not sure about CSPs, but in a standard distribution kernel, it's very li=
kely
>> that both are enabled, right=EF=BC=9F
>
> Yep.
>
>> Should kvm_gmem_make_shared() do some optimization or the overhead is re=
lative
>> small in the conversion to shared path so that the optimization is not w=
orth it?
>
> I assume it's relatively small, but it's probably a good idea to gets num=
bers so
> that we can make a semi-informed decision.  E.g. if processing 1GiB work =
of 4KiB
> folios is <100 cycles, I think we generally don't care.  But if it's more=
 like
> tens of microseconds, then I think we do care enough to optimize the walk=
ing for
> TDX.

