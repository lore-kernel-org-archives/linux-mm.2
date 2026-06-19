Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57650CD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 10:52:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BD586B008C; Fri, 19 Jun 2026 06:52:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26DED6B0092; Fri, 19 Jun 2026 06:52:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 138AF6B0093; Fri, 19 Jun 2026 06:52:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D8DCF6B008C
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 06:52:10 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 60EDD1203DF
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 10:52:10 +0000 (UTC)
X-FDA: 84896347620.04.CFB0DDF
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf08.hostedemail.com (Postfix) with ESMTP id 70261160003
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 10:52:08 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=LK6TZyfo;
	spf=pass (imf08.hostedemail.com: domain of tabba@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781866328;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qqrLJidqwZhWczfBA7HD/HFgW4vaG9cXUmJMg4P1TGM=;
	b=at5Ru9tvIcIjhQk3md/l246MSezZ6oJvya/fZVCMYknVC8fgSwdPqYX+rwdA5boHYDnHC2
	Js13jl3oFbsv5GWtjT1ad4oq838oeGUDiljIKKhmsxOPSIncYZqpvctxqzAumVMYuOKuEz
	YZdyJLh4Ov5cBc2l6BfLpvTKZzWNfCU=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781866328;
	b=nCqeZBG9nn1A2/Qiop/wts25vQ1JyUQxmOkRj5Ob31vbye/GRDDm/wS/1uYVeeweriyBeY
	pEdEOCt3YjMtiiW/ULvUlSrvz2Z1AigpIlBvBXFUgFQG/PLUJ38QkhPF+Yy2haLNya65kl
	UGYTzlZQ5OxorcpN9iisA8sME0k8P1Y=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=LK6TZyfo;
	spf=pass (imf08.hostedemail.com: domain of tabba@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-51765531803so233201cf.0
        for <linux-mm@kvack.org>; Fri, 19 Jun 2026 03:52:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781866327; cv=none;
        d=google.com; s=arc-20260327;
        b=U3ZwWiM1F/NNvou6E0+UHY/YMeI0dzbGo2Df1hA68syItyuEYLR+Tfi23Mmqdw8HR8
         PK6Pe/dv51uBdSvaoL3EOBi7kTFVhbDNnC/Varoe+dPxtX0DJJS7pItUCQlX2LXuDc9P
         XCkJQErpL4HsVv341nFuWGT3III/9yWcgKPlgdwNRAuRd+l+lJ4A8THVISB11jtBxaKJ
         da/0QL+GAa4JAXASQ284SE/mr9SObg2egyS7Iw43tC2gE2zBncvWaEVmcqAx3rAFQAQt
         9X1cRNiD+ZLf0fxUsZc22w0/CzgpgwvhbIgmdR8M+e1VLgozBpORdwi//b/pAAtxgnj7
         C5eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=qqrLJidqwZhWczfBA7HD/HFgW4vaG9cXUmJMg4P1TGM=;
        fh=sXgYsq4EzxiLsLuONfg1DMp3/B60g0iPlHoM+Be75YE=;
        b=jUyCYXk2D0A66cRKQ6kb6qoVIKinbrZRWRL2hz7LDOlUoQmYUwtmrIvAqilfT1ZHOF
         N/JZ9e3HaUEA3SgobmGxAYxqwq9qPROtJI5k6k8T7Wr073722AHWOhJL5njmYGUzGPuI
         bZikQv/evfa7t6reGRT+QHSiCyVVeVUuRkBjdlQLByr2KFBeAHLLYcJHupRrFvXDIxAs
         iq8FkWrPiD3mdn1DyoS0HPTn6EowssF7M118NYrfa2pCKz887nLTx1ejEDl+IfyokKjT
         uieuDA9bfhbvApbHPLZmDdNiDA1V9g89+x3jGS7K7Smar8NlkZ/UZnxCvqrRFEp9yJWV
         Lkmg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781866327; x=1782471127; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qqrLJidqwZhWczfBA7HD/HFgW4vaG9cXUmJMg4P1TGM=;
        b=LK6TZyfoYNqME+r4bgRcXzc+A7BF8VNfN2O6W9A/dPzcqQyR0pzkPfleV9b2OJkLpq
         7BME2MN2o38HRwYWq5reyOIoEmoL/Q1A7sN2Kazzi4mW+8A4Kfgf3NgvOd9CdfIrNkrI
         enfC9xUKaCqnpqEQu3WQjAicuLUKo1rOP1lPmFGcKnn8X/nVVua//CGnhtQ1QaMK2z2D
         u6rUg57J8vKJ7GMTzL585CnlnlrGfTLSR5VLtHwlEoBoBy+FukZo6CyIZfQVz9vfqYne
         LlNlUSN16EmB7TIVf3jRfq98U2VRqO3NrofP1wY47f9U0JZU8+6mOVWeKJHGMCCpLxEa
         OT6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781866327; x=1782471127;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=qqrLJidqwZhWczfBA7HD/HFgW4vaG9cXUmJMg4P1TGM=;
        b=kFCkvtuVdpvdpA4G/O6UHm277qgKIPUJXXM2cioCDv2Jn5JKxb8ISL+BA6FONAgpNP
         6fd1/9pgkQ9Qz26juNuPumuCx+1cbpgtv+t02wb192xJywwqphypJtR9mgEIpWmZ8M6c
         L9yDn1Fr9lRDSh8ukFrJlqjfP8GamJcSfzg1MdWz3x4lf42ISuBPEhHwBWxkTSsqmtDH
         XOVStt7BVAuMGG/DwCHD13JI3ALQteyFnlbrCJO2Oq+yXHeFoQ+H0lOK0lW7LQyDgvYz
         kTznSawWMZkfoqUDsSz3cnvb1HS22g6Yx+wPAXHxBwLkh1cya8qoIlGJ7qzjggiqHNiO
         CVQA==
X-Forwarded-Encrypted: i=1; AFNElJ/qV5Mwp24orkLBZUVq07pF8SSsBJDYvWa8u3PowH4k49HrJG5joqM0waQlHyIESjEn9bNCwnKtzg==@kvack.org
X-Gm-Message-State: AOJu0YzuPHedJYevZvnT66hizTUXmJ4sD0i5SGjNlfrnijNyTnA7jCU6
	MDryWFqRwVDlkIUWbhAwhheoG7xbyDYY8lp3di7kwtYCoPlafKCzAUtaroUUFU6RlZzzEOeBNiL
	1XSol2LzmCdnVf/e5f4ygVBk8X1dad4mHEqNE8qc9
X-Gm-Gg: AfdE7cl3qxb9p0Vam2PbzovF6fpimGmZSd3yC4qXThnOKzdQY+LMmfqUUVo5q5yL8R8
	3VCwgvbyxZ/xCLtQAQSLN30ntK64mG1yw/sYMYn7jrHSDh+ryJDaB1h4xXlrZtb+7I3wqB58x6f
	mrd9eu9tQEMFZPtUpSI1BLpsOWOYwJ+pS5CmTsRwOdDGG84/mLjKzCV5/k7WrpMIsHo5hZqmn+g
	4vZTk7GpmWEvu7SnY+igbxd4MomGj7PsoVLoKMZJx3ML+AbnjlLwfGxO3Hwk6YrxH2vkzLWfA==
X-Received: by 2002:ac8:5e0d:0:b0:50f:be7b:923a with SMTP id
 d75a77b69052e-519e890f9bfmr5827961cf.9.1781866326641; Fri, 19 Jun 2026
 03:52:06 -0700 (PDT)
MIME-Version: 1.0
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com> <20260618-gmem-inplace-conversion-v8-21-9d2959357853@google.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-21-9d2959357853@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 19 Jun 2026 11:51:29 +0100
X-Gm-Features: AVVi8Cf7maLTmO8Ms_Jrooo0n7Lq-o--etDJs7TRVCXqEuhsxAt-xpYkzSdEOcg
Message-ID: <CA+EHjTxOYWNeZ=2Atxn0iGQTOskR+Y3uiujWEOOfGLGcWadoUw@mail.gmail.com>
Subject: Re: [PATCH v8 21/46] KVM: guest_memfd: Zero page while getting pfn
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
	Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 70261160003
X-Stat-Signature: h4assh8x56jtuwjdtbzwqsar7pmpcxr5
X-HE-Tag: 1781866328-490171
X-HE-Meta: U2FsdGVkX1/KmX3YbXsvjE+zePilLNG48ru8nCNqmLmjiioBAGGPwcut5qa/iama7HXzytqC5DE5y7wu8DGNJXhMONptyNRT5DZFylhN8FGRQFe7R//aokRVHysQGYn5zXEwL1vSGAJRcM0pphbAT9kTBUQsPcJuXKtS5sj+BLg0YerzD7LAbhHiufCKeCoU+VcK7Ikuuq2ycanGKn6RYUgGQ/tEoDj8vsDMl/7v/h8KvV/yu57M9JJSgfr3zs/u3cXwKLmZBOuxm63CTl6h3P1/B2E9xEnZ0KNzeY1kB2XQlFah0adyToJN+8nxWG1mhT5d6TqWTYbI7zCL+Qp6+HDZZ3ArhDRRWNWA9xPErNunswdC2Up7a8xTT+12lquj0UiBdQQ/gICtiucYnLHLOYp0SAlFIelR1a+h5Oaj8C7xfHwkx7ngPhsFZSF8uH2P6xFHadZLSVc+dCMcFm/lCnhpmLuEvjSkFEtDJzMMkgkpF6CykPNhUDZMeUm71b96U7B7seMSUFFb2293j5ricK01ew3YjSTdHa1yFfdUqsoJ0cxhWAEIHoT2SxLlwz3uYaCAdbgoION8b3MQN5dyEQHOUc5+8Y1oa6zGszvbGyqz9a4QGkr7EChTF4st0/tdhDBSz6DSthK4ZhJ1yggNx8RWGRMB5ZvU/ec1cg8e+ULzjyIiLiJ/Lvv/IwoMwa5/go4LtGO1ISA8g2FgCRGh2kC1p1TC4JdPq0GDdiaDS1LHuH/RNITqO6DN2AXicrXubPjPXIJGz7i0GpvYBk+N8e6fV/rcYrbPb9woQo6EiVUQd3fd4vqkMEaC8Fbe7uFk8sRQ0JMUVklBxAD9btkL1wIHb9Idts8kHnrvQxC6PjFzTDLuqApEahPX18FwUNEVytzGKRf5tIDVQ6epSQA7gxDsNoL4DalAK2E0QgpFMcVbTYGM+YS5C2yqglibYDzfPfl2e4MBWUytz/p9pQP
 DIVlzOZL
 NYrsHGbBgx1jNEOJkgCgqZ/aj4PFjS8g8wO8iBNJbhZxGGy4x1OlgKWVSOVMrSXxlfYf1G2EnTv1ZjUCvA/ajVRFIaznHZtjLmDzq8ohTUeUzjTwzwPgH04OJjivY6aJqYrHIcBeRdV+e+LmuzIR5z9+MbV6axDqwd4/DTh5TUn4pI79wS8PKMt18cKmf++Fgncm41AaMfDEzCItHSurcE6ueAGmX+98PRXrsUw/32vq0egGpXZHtGUlm+Tv/RwJ3SMftnDZ8M5ZS0fIbAqWFDG8zq+s1yWLjDjnoai930drRdIiezH1hBaKq183+4AtL7kzyBRhHzYDK0LI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 19 Jun 2026 at 01:31, Ackerley Tng via B4 Relay
<devnull+ackerleytng.google.com@kernel.org> wrote:
>
> From: Ackerley Tng <ackerleytng@google.com>
>
> Move the folio initialization logic from kvm_gmem_get_pfn() into
> __kvm_gmem_get_pfn() to also zero pages if the page is to be used in
> kvm_gmem_populate().
>
> With in-place conversion, the existing data in a guest_memfd page can be
> populated into guest memory through platform-specific ioctls.
>
> Without first zeroing the page obtained using __kvm_gmem_get_pfn(), it
> might contain uninitialized host memory, which would leak to the guest if
> the populate completes.
>
> guest_memfd pages are zeroed at most once in the page's entire lifetime
> with guest_memfd, and that is tracked using the uptodate flag.
>
> Zeroing the page in __kvm_gmem_get_pfn() is chosen over zeroing in
> kvm_gmem_get_folio() since other flows, such as a future write() syscall,
> can get a page, write to the page and then set page uptodate without
> zeroing.
>
> This aligns with the concept of zeroing before first use - the other place
> where zeroing happens is in kvm_gmem_fault_user_mapping().
>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad
> ---
>  virt/kvm/guest_memfd.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 90bc1a26512b6..86c9f5b0863cb 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -1137,6 +1137,11 @@ static struct folio *__kvm_gmem_get_pfn(struct file *file,
>                 return ERR_PTR(-EHWPOISON);
>         }
>
> +       if (!folio_test_uptodate(folio)) {
> +               clear_highpage(folio_page(folio, 0));
> +               folio_mark_uptodate(folio);
> +       }
> +
>         *pfn = folio_file_pfn(folio, index);
>         if (max_order)
>                 *max_order = 0;
> @@ -1166,11 +1171,6 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>                 goto out;
>         }
>
> -       if (!folio_test_uptodate(folio)) {
> -               clear_highpage(folio_page(folio, 0));
> -               folio_mark_uptodate(folio);
> -       }
> -
>         if (kvm_gmem_is_private_mem(inode, index))
>                 r = kvm_gmem_prepare_folio(kvm, slot, gfn, folio);
>
>
> --
> 2.55.0.rc0.738.g0c8ab3ebcc-goog
>
>

