Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58F3ECDE007
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 07:03:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BCE96B00A0; Thu, 25 Jun 2026 03:03:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 194536B00A1; Thu, 25 Jun 2026 03:03:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AD906B00A3; Thu, 25 Jun 2026 03:03:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BF61B6B00A0
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 03:03:53 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0D49A1205B3
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:03:53 +0000 (UTC)
X-FDA: 84917545146.11.E4A6B66
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf12.hostedemail.com (Postfix) with ESMTP id 22D7C4000F
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:03:50 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mQOByaBx;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf12.hostedemail.com: domain of tabba@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782371031;
	b=QEoEwUJF+X5PE17cQORPzlX0nHflFiz6Tk0u/pSQnvKM9f5rln8T+izw3KSD5WG7M4IE/t
	RpBC6wuhXxX1hPixgAgn1OAwxBspjHXYEYXstnH3EhnYB1c3GJGZiRzrJLbPwaZvaVNrIV
	ZpYVyTRa/JxreHn9pW6HGbvHaJu05nQ=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782371031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cxrlZg8b53cTZGaXTuMmmJujU2vJAW9nQq1QLfM1210=;
	b=ZjNJAIszLO7JdBhOwJuLhC5iBGLRjGdbfw0cVomRZZb//uYoOy83gJ3Qxu/VzPxDL1kL62
	qUEmidGhRqDpauLviXuz6eqYD7YCA9oB2Ezl1Cv3ZjCbmeYnrqTj7ZOCvtdOsiOfXJsa0d
	IJtJ+F70X0tGycZbt5zQq2CZxFslTs0=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mQOByaBx;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf12.hostedemail.com: domain of tabba@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-5177d1ff061so135371cf.1
        for <linux-mm@kvack.org>; Thu, 25 Jun 2026 00:03:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782371030; cv=none;
        d=google.com; s=arc-20260327;
        b=E/5oHqE+nxIWjO2Awxd8II1B5mjqzGxULq1SSSor/rURL6mlVMNTw3xveBbm+/KDN1
         sETM+VNN9Xn2/GjhvrV14pgdZYMvwblvKQ6Avd/ZA8QOEx4VCNsI/163/y7R5lFLyffS
         elmi/JHXmxoigsRNC/k6zg87Hj1sO7Wa8pQloklkdJoPqGjoAatEaUmWNBht04H4RI7f
         8QStyofXSpLbxEqxAziAMMRatCe/loYs0uY6UJ3OPK9r9Yef6iZpPspUeosdUBrRMBOi
         ndxjMvLx0XTzk7OHdb98sf2OHSjUW02oYQ2HqESmPtZcFmyyKL4CLG5dC9z2Szbmt33B
         BnoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=cxrlZg8b53cTZGaXTuMmmJujU2vJAW9nQq1QLfM1210=;
        fh=dWe3kWuDg2LsD28htc5EkJXvHOspD1lLVtAoyGnveGg=;
        b=RGAVcZnjYfb7jHF4+7Mb8ruy4JB1tU9lTFwfIhLWi8ZNSkkWvuwfIX5bRmAoO2PiPE
         0yYmr4YfQQybFIbEF28WBTqi4PASZ2qrnj/g/KfQTx2te6jDtD7kiGNR8uq7LeDHAUf+
         GNmu+adQcukS36PtGlQ2wj4a15NBaY6O4jMmynIeLVewvnRkXHs3UAS2lVWceAR6384/
         d9AvYOjp1YlQq8YM4Sh0wyMcUsw4LTZSi0rIUX+aW+I2HNSOsvzZH6Sqsu/Vd4CyylBn
         oC4sb+DKZ6CHR3PUQ9IzKvMmDd9AcrEjgSRZxBZ13ayS/HKTYzq+bLAMJ1sVrUyctz19
         OHRw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782371030; x=1782975830; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cxrlZg8b53cTZGaXTuMmmJujU2vJAW9nQq1QLfM1210=;
        b=mQOByaBxPTIS4T1244bICrc0GPvdjb5kclYipdx6ANvTeD+SxxeFoyWTSwG0w2wv6f
         XCn5n7YhxJ7KKtD/RFCnaUCsE8AN004iIC6buR+XXkR0O1PTzVyWHGiGkF2oyIpPgjUO
         yY+IT9nv6CQRMAOZYUu4SMkROlNAv1cmRy+2I5eZTO6TwmP/BrMj00xLhKN3TemgyubG
         UlvnnahXTX82yN1a2UnbCGVb6LCgUVp7/NZQiMAFFWcw9ENjza5rfmC3JCAf/wM7jfB0
         7U8ESyfcZn6TqZotqr3ip/iiYhNCnPHexooBYBiaOQ1oQ37iIpGwGT0Wmq/+5fOd/Yh2
         Ht5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782371030; x=1782975830;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=cxrlZg8b53cTZGaXTuMmmJujU2vJAW9nQq1QLfM1210=;
        b=A4oFsGG5kJSn4/EP5nCQmU/L9flR7btyRgH8XfgxDs+JDy00Vq2/oMntQF6KcJqFhc
         epvgqQ4NAnJUe4dYJlbG0pRMBhwlMF67BTYnXDVutC8hQqtR8JYEy9mA4JwXOXGNTnRa
         re+9k9OG4azQGx1zjpcYUTtj/NY1hX4nyIf731rXRB4NhLsCiB3sLVPHXhdGZmHdebQH
         Xwot63PzRxXaAZiweSh1NtR2nRi8WViLyIcGgXWLy5X/uwyoqjld5Dwpsyej3OLH1z9Y
         29jLRiweQlbDkmMsFN1oXbl111X839V65eVaYbZZuaDbu8zCRQ9/TkYb7yqLr+gVJdGe
         EBFg==
X-Forwarded-Encrypted: i=1; AFNElJ8V8ux6vfm9ItlUijl7+i4JzppE4OIx0rnKG9E5t1Om2M8J1eq96XxwFqSPPoewZ866bQ7gblXHCQ==@kvack.org
X-Gm-Message-State: AOJu0Ywse743vHt6B2VxacNZs/YIUrtojp6goP7yUPq62r3vxBh4IPr2
	7ObddP7ib2NoAU6V6bvFkvm1JZq+SBlE8B2iheVuO4BdjXfpl8tct/oWV8xjwiTQODIf8jdZuBM
	h1ysHnR4MpImStJAx1yl6dk2A2KYfVOjVm+wFFcv6
X-Gm-Gg: AfdE7cnOL1Qzjgb1yiXmC5jA+uNVeHq7EqkdbJev+kTfGELdtbS/ghGwE9vLg3ykk5H
	n+wDOvKHA0pnaXgqBsFPWuADee6trucZLSrpmXUAbjdHL1dnH2U4MikZm0xrB4NIJxJNuRgBHYI
	L297krZD9jzqursB+9gqGgs7ZfEZj2YtzVpN54TygxXwWLvNv9DTqH6wAyjVoaNcjaVP51waV/T
	j4eu/9CckJxaQfIkBM+uYVnzSMpCkBM0y9yBFmHJCnXcDucG3/H4GX47FQVZQ1kMU3XHxO0Lw==
X-Received: by 2002:ac8:5913:0:b0:50f:b69a:f4a8 with SMTP id
 d75a77b69052e-51a709566ddmr4167481cf.7.1782371029299; Thu, 25 Jun 2026
 00:03:49 -0700 (PDT)
MIME-Version: 1.0
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com> <20260618-gmem-inplace-conversion-v8-35-9d2959357853@google.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-35-9d2959357853@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 25 Jun 2026 08:03:12 +0100
X-Gm-Features: AVVi8Ccml7uePn0yWr7psf-IlIIJeOhhOzFV38YDt7BElEVA1ysUJR_9AnFc0ro
Message-ID: <CA+EHjTynteewQUd4VTobSypO=oFObYSBLZ_xyK-CGNSRNcrViQ@mail.gmail.com>
Subject: Re: [PATCH v8 35/46] KVM: selftests: Convert with allocated folios in
 different layouts
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
X-Stat-Signature: b7s99p7k9wjxfko9kj8kqezjurm8f1dd
X-Rspamd-Queue-Id: 22D7C4000F
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782371030-83364
X-HE-Meta: U2FsdGVkX18HVzzQ+LPu1piUvPFqj4iHL8BQ6EZpK5CAwrmp/SHRdZ4ePQiXzzQzmJVcglHL8azeXd/ApHTYLRz1MnZWAiCM00DojU1gGquIYJg5LuqalmQo2baPBrwt7XVoPYdjwcSEfOTBDKfThDQP+vJLkaehhAy5dMSOUeWbNIOiJ4l981W4hE1WhmOJY5IJ1QOBGGcKFgPbH4I9CF85iHATPFzUTe7RSfwlnSSumOrb2FIEqlqA5Iy308pdh0fxm9mupc0CHKrnRTRhT1jxfEiqBDoPZWYfAJcoyFDGzkq3deyF2+dOGJITM6/wI1ZTc23NhvJGYDrx+EANAtYpNC+RR4msmOGUNVSRL4SrSGsoWc6xyvumgyQL4tG5Cd5OOF7Nq/adg1siZKJlmAgrI8kA2WoSbTrEo+rKhNRlmfMOk8Ix6rp2G3FpCaaI1QWHcXBSHRIiVr0HC5TGPveJRvrP8Uv/Ve8mK4ronBB36bF3kDH5uaxo3S6D+Q6KVNpX3cnvjl5+uBpooVyTIg66XGu+6ZIdmRCAKbKtu138LzBGHkNBeKpVzeke4PtALARqQzZI7a3Nf/HGbEZuEtcs1dJJvfTq7nPnf57fkmUyFumaPjNvezi+m6h3ayZlQJT+sV3ChdmXcq9bE/mWsvSx623HWoky+090lZqawr0Tctd/BiyftcK4Vkop+UqPJKzmileaauWp2KDWCf50A0DOnbbR8JuhGsup26SvkX/mLJgNlf1Vut6Fei3L1PYmvbhnTyT7i3nnkgcF6AIlLmSgyA9axbmhlhTlG2y/pndcT4M6o3YGYldLSermUKTrgup4CnX2J+cq4TKrcF6OlZQzwar3jxxGJ/uJGyS+ICA5PZcda5rwvnX9xDr0detkoDh0BX7XlX9fLVKuXJd8MeL94gNDamqsuectvKE9MThcMAID2mJdcYODQbiXTC+D2rb4E7dOAFbZCyN/U/D
 a8DNdqGb
 ha/HqCVF07Tyj8Bku8zvN9/f0vNgnWKn58fav3g+UWe3fNFM6PnoqxYsg0u3kiRI6gVGMtREV8w5rmPFXdC4ValrwEHUMfv4ZQB0SZDZhqQWo4p9SZ9UhTRW5wJBll0FgqQrEp64TP4lpAcYyoK+ASqmiIKRdtewaTyeOTQWybJZhzJl1IQmJ261+MpcwXBJZxo1QflHsqEtp21aRm2mKT47MsdF508+OVHMUL0eyWk7fEL5/7seVoDz5wWdZvnyzS77O6JhSA9eWW+RPx6HfhCMQXAPCTo1xVdjF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 19 Jun 2026 at 01:32, Ackerley Tng via B4 Relay
<devnull+ackerleytng.google.com@kernel.org> wrote:
>
> From: Ackerley Tng <ackerleytng@google.com>
>
> Add a guest_memfd selftest to verify that memory conversions work
> correctly with allocated folios in different layouts.
>
> By iterating through which pages are initially faulted, the test covers
> various layouts of contiguous allocated and unallocated regions, exercising
> conversion with different range layouts.
>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

> ---
>  .../kvm/x86/guest_memfd_conversions_test.c         | 30 ++++++++++++++++++++++
>  1 file changed, 30 insertions(+)
>
> diff --git a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
> index b43ac196330f1..0b024fb7227f0 100644
> --- a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
> +++ b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
> @@ -279,6 +279,36 @@ GMEM_CONVERSION_TEST_INIT_PRIVATE(before_allocation_private)
>         test_convert_to_shared(t, 0, 0, 'A', 'B');
>  }
>
> +/*
> + * Test that when some of the folios in the conversion range are allocated,
> + * conversion requests are handled correctly in guest_memfd.  Vary the ranges
> + * allocated before conversion, using test_page, to cover various layouts of
> + * contiguous allocated and unallocated regions.
> + */
> +GMEM_CONVERSION_MULTIPAGE_TEST_INIT_SHARED(unallocated_folios, 8)
> +{
> +       const int second_page_to_fault = 4;
> +       int i;
> +
> +       /*
> +        * Fault 2 of the pages to test filemap range operations except when
> +        * test_page == second_page_to_fault.
> +        */
> +       host_do_rmw(t->mem, test_page, 0, 'A');
> +       if (test_page != second_page_to_fault)
> +               host_do_rmw(t->mem, second_page_to_fault, 0, 'A');
> +
> +       gmem_set_private(t->gmem_fd, 0, nr_pages * page_size);
> +       for (i = 0; i < nr_pages; ++i) {
> +               char expected = (i == test_page || i == second_page_to_fault) ? 'A' : 0;
> +
> +               test_private(t, i, expected, 'B');
> +       }
> +
> +       for (i = 0; i < nr_pages; ++i)
> +               test_convert_to_shared(t, i, 'B', 'C', 'D');
> +}
> +
>  int main(int argc, char *argv[])
>  {
>         TEST_REQUIRE(kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SW_PROTECTED_VM));
>
> --
> 2.55.0.rc0.738.g0c8ab3ebcc-goog
>
>

