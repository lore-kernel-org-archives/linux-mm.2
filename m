Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF00EC5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 13:35:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4D426B0155; Wed, 12 Aug 2026 09:35:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFEC36B0157; Wed, 12 Aug 2026 09:35:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C5AB6B0158; Wed, 12 Aug 2026 09:35:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 67B7A6B0155
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:35:15 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7D788403DB
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:35:13 +0000 (UTC)
X-FDA: 85092713706.13.E664B51
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9BFA81C0007
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:35:11 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HKZioK9+;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf21.hostedemail.com: domain of tabba@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=tabba@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786541711;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=btatRIN/qVx6m6u+kKi9+q5rHWXBFe/go9/mpyrKKkA=;
	b=HSw9ia9aOSe2TRddqLkIKFSuLnftqFkQVtRTL/ZO8LjSAMvtDCC4XxES8acx3J1gPF11F2
	3uzMzVe1VVBIr8Z18Uq4/Lv0K7xmR4xjcljFKm1LTknajQCvC2EKnvuNEne6D475zyFxol
	l1pCAmQtEptYTXI5cbHksTFH9FztyNo=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HKZioK9+;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf21.hostedemail.com: domain of tabba@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=tabba@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786541711;
	b=h+OYXv4bLgAW41ZEqhyHp9LgrC4ij8nkz0bHKPzyr678mRzEKFAjXGrSMtuAnEKP2pPy1O
	p/R1aQ7u81gAkYNEyV+EJGz4Kp13YdmV61mVjavHRPSwplNcQ1eyluvZ/t/oaq73u9nogj
	iInPSuWgyQlYmQxTC4hfmDTSGmIggYc=
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-51c15a5b265so228201cf.0
        for <linux-mm@kvack.org>; Wed, 12 Aug 2026 06:35:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786541711; cv=none;
        d=google.com; s=arc-20260327;
        b=N5gbD3V+nLd6eknqvA9+vjECO7hFCg6PrDC15dvlyce2Smlj+ntOef6wRcPHirzpMl
         GIzl61N+xeUcEdgkNHO8uxd1sRXeZ1nunyM4q6+m7Lt2eSNkJ55asbOgDm29iq5PB8ah
         D7CbVUJtpx573AJBcWmrfSld83aExLeenW8AR0ox0LIywpdY3kMsSfaenfk+lt/Q34y4
         D8qOTYfi+EDjIpPQl9GLfjp9IPTmbKWoju1WlYSfjrSLXIzaae3vJgo/Kvq5GrvBCEJi
         JJpqWXeAFyTSaCLBROQykQ9kwkEbP2mzCw+IijCRO81qPFP7Pi375eN0COgLvNTWaEAA
         AeUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=btatRIN/qVx6m6u+kKi9+q5rHWXBFe/go9/mpyrKKkA=;
        fh=3rZWI6u+usR1glwJ3AIkOA+ewonmXM2Xdfh9uo1vr9Q=;
        b=gvSZOP259dAHgYggda+K+EAJXDSlVx3mvD0mn3rvMENsZOj0WRXveoieTiW3yuAhRj
         JELJ5SjZ21NckWmIsfR0NryNDL4iT/oBcJIt1vAxtv6HB4i0PZOluOqUFrsTPlmwQEaS
         JP4FKiziRIcjEyIXODbxnb4F6rA8yaDi1TIvUXKdbSCauOOVaDtmEzXSGm+jMF2Rsj06
         gAjJcwSIHHzy+Ygyb7hmnmY3ir6D/V34hWH3RlQNBO4kmd/D9iowrsW0WSvgN/uZhJ3q
         1ghN1M9s3gebjiiBHsWEeK064ZQkQVFFHxDjBxk1iHf413UZUP2W8USHv05oe93VIJF/
         pmqA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786541711; x=1787146511; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=btatRIN/qVx6m6u+kKi9+q5rHWXBFe/go9/mpyrKKkA=;
        b=HKZioK9+X/5tMtiNO6Pea02W8nSoiB4sZjS0geLb4cV+K/M+G4vuEQnEEtYxp1liZ8
         6FrsFtSeIQzATe6DiREuKqZwrxfGJydEybAXS9u36r7SPtQv2MJzifakzPDsx7Fw1k2z
         yMjXqZhPl8uwvzQFS3kIq83s8UFFtuM1j5vD6wzOaKMgUPp1YZT9nLH98NJr/+K3nSLc
         p6mQ2OVhvGNAnYjKiS1iMJKhEX+qs/KHPEkI3Qexi1upLVJALb9i7UD+w8Pf2MOfXm3g
         yt1kY0u7RzPEuSsiPt38fOhGwjwq1YiarVG+ri+R2s895dpG5ME2qC6zzrs+9qATXjfS
         vRHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786541711; x=1787146511;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=btatRIN/qVx6m6u+kKi9+q5rHWXBFe/go9/mpyrKKkA=;
        b=keVKE528A3ripIY2HpCTuQMg9XZjs7P8zFg9lhyP8hcZ5gp9BaACldKxkH7Q3mBPtN
         GmMk/Gn8bU5HJ+QxdEroFt8+FaY9o1M/TM6f5DsQLHFEOvWGNwLkGJ5cv8efCFFd1N6L
         8wpFcTjmywi4yx3jlZ7DlyMHZX4szRojWPoHbEirPlKBO7kplqehSIqkdHEUaJw1U851
         br4tudulOeBbRcw1fZSJz018pDAwoDqQrH5RbZKKGYpEnKrAGix5bt+CpI12pn3I47vi
         7bLTfC+KBXi77e4qldeUiqACXKDeTHCewwjsXinAWSUY9J2MyuOV5TP4lmAOUp8MJdoE
         H/Kg==
X-Forwarded-Encrypted: i=1; AHgh+RpFOuKTb7t2Y1giWdzAJieKamC7RWpEQpCLNmB96JKLSdScroT1/j4bm3faPWBxNjr6cx0YJUvMzw==@kvack.org
X-Gm-Message-State: AOJu0YypnKvCzl2eWEbTIC71ugyKlvr+99GbDvNf/9mw+tS5AL1lwoAr
	CUECU/aXtEhgGoL1NFdWTBrISxa/sUldukB3dwplvHXB4R0rUcCw19IZTfXZ8wcH/V0UZVxV11B
	M5mnbVI9TaHPZ0TTI+UfXdv0FVX0fu7L8MnxT/XRY
X-Gm-Gg: AR+sD12Iv50kxpJfScJLO2lJ8lWdccsyxhusg3ghebl5Sw7GL/1G3pO4UeDhMNkE0/l
	OpGhK0rSCTF/VTCUT4Uvzvtcuqvbt5jFbzLJZLby+0ky/XHqHKx2jZp3bil7fwr8mhgxgftKcoy
	FdUlGhb/Z0z77DrmEkHyArdIVKBj88LStSIC5PCz+MFWkN0Gjr8J+CMSDt/NsMfRBORJCgUlLsn
	LpsRPz5zc7q4NFOlKpcrb/c3bDVagxB/+P1RcPwVvMxghmJ2m3dnvdfnAQkC5yGtDFaJEnip5P9
	NLoV7nVrRsysXgDMb+7B8Q824iByXTJORxw3d7WOnaXwkw==
X-Received: by 2002:a05:622a:e198:10b0:50f:af60:3496 with SMTP id
 d75a77b69052e-52d65464646mr13714571cf.1.1786541709957; Wed, 12 Aug 2026
 06:35:09 -0700 (PDT)
MIME-Version: 1.0
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com> <20260807-gmem-inplace-conversion-v10-1-2fc18ee6d3ba@google.com>
In-Reply-To: <20260807-gmem-inplace-conversion-v10-1-2fc18ee6d3ba@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 12 Aug 2026 15:34:32 +0200
X-Gm-Features: AUfX_mzDGNX5m7h-J9AcKRPzqX1cpxh6BaIQgAnDEV-ghyjmfpFsGGynIKZZ1iE
Message-ID: <CA+EHjTzkOQD0YddPUs=2=yThG6s3=jQR2xwm+CeAedjyFaANZA@mail.gmail.com>
Subject: Re: [PATCH v10 01/41] KVM: guest_memfd: Use kvm_mem_is_private() when
 populating guest_memfd memory
To: ackerleytng@google.com
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, willy@infradead.org, wyihan@google.com, 
	yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org, 
	suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
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
	linux-coco@lists.linux.dev, Xiaoyao Li <xiaoyao.li@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 3groogucybnqckgzwaee8cebg7zwcqoh
X-Rspamd-Queue-Id: 9BFA81C0007
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786541711-721939
X-HE-Meta: U2FsdGVkX18P58xmkhy6lWyjCj9sM8OhbdJ/ODN5Ztt23pzeeMCNQLjT3r0epsuPdtSlCksbHS/Grl810JgDJbB3dXDTv+9GwjPWXaUe9ho0oXFIe1wsMh2kFlJ1VTFasWnNSrRImRSNh+cSfg+pw9uUZTGGN9LCAhPqmQUtRWet9RBVtdmqKM7Iv+iVopv3p6dRDkjD8nyh1gGOfDRoKROoiYlOOoc+szRYqglJ7IIvD6K4TA3+v4hdSeeJq4XtMoSWqWsklShNnT2Z+/8xsFXIivCY6EYCmccMbigzZ7F/vK3fR7QuYAZEgUVoOqkO0uPIs1vc3NI8htEkwqDt2otWkxLjx9MbPcQq9PddQ+c4/l0Nc1LDrzZNLDTAguNVhtFR1XGTTCpWCCoy4/qcGm7+tn8BjIUhxpgsvLMe6jb5yyFI5GX3GgGdmCfTHk26LxLtTk0+n8dkHlt7C6Ap/vdrXeangRDssw6+Og38lSczeDaeXqNkXPR+xBNV7IiLPLMW/4BiwLX+J2F+0DCt2eOJ7K7zNqUYe6/QiNgEaF7m58guOLgUffZQTLVW9GVTIcb9JMB/wqTBGZChlWWFnF8B5QruzF4sVgXbGXe+eY5A1S3D7YuQMDsgYKVs86xwZBfxMY/0yqdBteA/bRFtgV0ugnc551+9ziRnLtpGmYDVUm/rMH6O6BtD5rvKPrVmpGCNsG9XTcOHpzD1AMheJCDM2uuq6JARqkY7Ukhfwt7zTt2idkRMMXcn3Gv3HU7FhVUakCk0UBWDJSTWqzU7mPE7yTjeVr7ElorA3loDuCfLhaK4vVPkKxsv5mb10xxi65Q9c+Utxq3iBRYhHyjuoXVVpt29BDbupeGskAQlSe7DucLkeE7To68Jd9hR4SRq3246FfMTCVAUZeng7URb+rMDeAL60hJXD6c6yPPK5W6LPhrxV9iPmO78ZgH8QIYlFM4dXuh66t4BvcCROK8
 m9m+ffLo
 MKzrzPd2LTpn9BHCbT6N01GDuJkwAhxuieZMITmVoJu5dKNBvjofguglBYboJ7STFuzHz57IoAXBq8yOnU0lcvygWPnoqOXK8eKdJxNiDOqoojX0yWu/8Sf3Jrb9LN/0GYoPrRihAfbW/3e/yjwbn3G5U9KeYw4xmHU2m3vqgCBclTLROMz6mlAaEqunC+/zGaFBdgudegJliSgK+eShB/KFV8kQOqxLOkUcrTIzq4P8EetcZVG5uCyQBlhdy4adCB9TblqenSH12MdtUhlji5Xz/2HIIfjcs5sqWiObeaZWdKyET9fIl9y4Zlkr1SGreA01xjelaTkys1fpqlFJiBhsorhAAug6qmgO7/vMonhvQeOc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 7 Aug 2026 at 23:52, Ackerley Tng via B4 Relay
<devnull+ackerleytng.google.com@kernel.org> wrote:
>
> From: Sean Christopherson <seanjc@google.com>
>
> Using kvm_mem_is_private() when populating guest_memfd instead of using an
> open coded equivalent.  In addition to simplifying the populate code *now*,
> this avoids the need to provide a range-based gmem lookup API in the future
> as well.
>
> No functional change intended.
>
> Suggested-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad
> ---
>  virt/kvm/guest_memfd.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index b596486d184ca..a11cf6dc785da 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -811,9 +811,7 @@ static long __kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot *slot,
>
>         folio_unlock(folio);
>
> -       if (!kvm_range_has_memory_attributes(kvm, gfn, gfn + 1,
> -                                            KVM_MEMORY_ATTRIBUTE_PRIVATE,
> -                                            KVM_MEMORY_ATTRIBUTE_PRIVATE)) {
> +       if (!kvm_mem_is_private(kvm, gfn)) {
>                 ret = -EINVAL;
>                 goto out_put_folio;
>         }
>
> --
> 2.55.0.654.g21b8a5bc05-goog
>
>

