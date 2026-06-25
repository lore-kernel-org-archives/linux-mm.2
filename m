Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85A63CDB466
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 07:04:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31F1B6B00C9; Thu, 25 Jun 2026 03:04:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F5C46B00CA; Thu, 25 Jun 2026 03:04:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20CB06B00CB; Thu, 25 Jun 2026 03:04:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E5B836B00C9
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 03:04:31 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5663C167606
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:04:31 +0000 (UTC)
X-FDA: 84917546742.10.FE52002
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf01.hostedemail.com (Postfix) with ESMTP id 674C240004
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:04:29 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=fo3cVnni;
	spf=pass (imf01.hostedemail.com: domain of tabba@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782371069;
	b=d1zQMk07/N5bqeX/ZLaEEOCViWDCkhWrwEZUoD15lPPmj/7qZuQgNhWrLhbWDW9SampB4p
	qR4y072GseUXynhdns6vgUUZJvOcZyW1WmGWpIXWiEldDW6oZPj+r2V9ScvI1p8I7Ia3Xh
	G+3Lcy95ibKTrIPgZpqmCVWnCpEfPnA=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782371069;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EviLczuyy1yyIrBaIYV/LFmo2BGtZCvU6IS38nnd4b4=;
	b=riu9BN4SWt2lbH7+x6zvqkGTT/el+nAyH1D/lw1lEBocEy6pDV0RfJGdy5+7m74y0W2U9U
	PypK23Y+sGwsg3MRJqg7LVCcvrMZO9qx7eoZJ8qoquyqJjzYa1dGDfRjvQtxT7+DOQyrqA
	h4HljJIIGQ+oLlDlTb+3bkRkffFsNX8=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=fo3cVnni;
	spf=pass (imf01.hostedemail.com: domain of tabba@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-519ed52bcc6so182541cf.0
        for <linux-mm@kvack.org>; Thu, 25 Jun 2026 00:04:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782371068; cv=none;
        d=google.com; s=arc-20260327;
        b=lT4uC35lgiJftT/ESm3egvhFbdi17i7IFLH0BDTa7pfEHWKjrnHLmSqdcusBO/8/CW
         zRnk+34X2tNF43TYn9YolzVv/hJGmYzw+cMGwutUYXf8lYOK8OowZlRNq0x4iHeIxtXJ
         TKIMTEfvpCmXJa1fQYczTSvtyqkdQM0SBck90sBmfzf3W175jmDKddjJiRUnOlmoxxaS
         20GFEjJC4uvDpSoEh15ioFmjFY0FddEqzwCdQz6nDWFGm+zyirCNFoPGT/1rtai+01Rx
         0GlEVrzjyHilYnMBHvQFpEQL1eufOeecszNeF9JM01ruxVGXoZ8jzta5hvrb21boVtiN
         ihAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=EviLczuyy1yyIrBaIYV/LFmo2BGtZCvU6IS38nnd4b4=;
        fh=lxmMdWdM3/lu36vfCkuuzRnM40UWUstgpU57sErOhyk=;
        b=gAtiWs5UHSb5+SvjggveQx0ii1FrJmKK7lLQSZ3zdeoUeaPoqKf/oqvtUuQIMpRu6g
         deN20yKrvXFZDPLedSh9a4TheWrN9RMGrEbdAqKm5RaYAJtoSWetG30+bJxq/ksR1/7u
         yzB2g9IY/DLYsonzH9OqEwhiRwzvfT/Tkt0LHirtzRS0qOxIIYGgzEUTG5jhQ7b3xjjr
         PRz3lPEyMR3qhtOayC6o2QF3xXIMngNe11oXQaWBefoxd98neIHVw18H/LDy5oq5Syna
         ySaLK0QwCBk/w4ea7gY7oIe8JbMY6Ms5X0vy0gT/vixwGvfVvztthhezLHtG8dH+empn
         FEng==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782371068; x=1782975868; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EviLczuyy1yyIrBaIYV/LFmo2BGtZCvU6IS38nnd4b4=;
        b=fo3cVnniXv4qis1reMiCguSdaXlC5cJlZFa1M//1k3bny0ijIibUKhTb5iNf3fo/Xq
         d/SHnk0jmixsC33uWYRai6UUYuuHBwnBFJUA+lDOP7HeHCoCYirypPdmP4aS/oJe6Feq
         TenkN+3C/t5iaiAGwqqaUsGyasE7Hncq1ovC5dyTm1iFeK1NsHIFqKaqaVXOcuKZ2Me7
         XmIZa9IV6PJxlzBI9539knx9e1EnJ5y1uGk8YQrs/SzNKgy8LUM/6drf15XC9ZJ+rwWr
         Uhxq0m9rilzyqyQlhlU10nmTnNGWzjWd+5qiiIeqvvj0ELPyOdJFnJwoJo/nBTD+/B3i
         Qljg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782371068; x=1782975868;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=EviLczuyy1yyIrBaIYV/LFmo2BGtZCvU6IS38nnd4b4=;
        b=EomlyE0oGg89KiN556Wh4LthS2pnhYfHTK3BXVF6M5LETsNcEdui8n5e4jdKzHWHdB
         jkXNykH1mnqQFra14yHhC5lgpErbYERy62eSIoObRiMgmgR0Qc/WNbu/mI/fL9yXa8kJ
         pI+xl+l8AmX0V2wShiIQ8EvxgmljFFWLiGZrvE5mOmejVch52WEHcIsMn9NE7TR4/en3
         PgZUzy7Ixj1OkuPukEQqngu4RBCTRWmlsQ2gkTsGl1XGQ2cNTsL+Cv46ki8vD5WmTC3e
         NaHrtyd7ApNV8+Ebv3Xw0FKGZd2YqDDVsVdvUYzqKGzoDJa9vB1GHuEPpqKkmzHxMEqw
         2ulQ==
X-Forwarded-Encrypted: i=1; AFNElJ8vG7GsteZfmxgSbX1c4xtso9aDl2NjhUrVsQUx4C2pnqmOWkziTMPqgdmIs2ythSp1EDuHHBNqLQ==@kvack.org
X-Gm-Message-State: AOJu0YzpbHtcF2z7SOgvXm8WqJL55EpLC/i2uLdA5ZtuADgm02yOVa4g
	Vy5K8p97Li4nk/QgdzCtqcV1Sb+E3ZPZDGWjCsyQgOEM9WCqMv//YWVbCZJ7J+HWvCT4Y8nk4Dx
	GE8L5HRcu0+OUKAB5kyfQPAcYGrg58pC2kZ+WCWdw
X-Gm-Gg: AfdE7cnkV/6PCary0N5BJ/wbz/xoXq58cX12QjqxjC6mRRKpOQuk6nTrl0TAwCB/ZSi
	HWlC4tvXVUIaT+jpR+ZQmGriVyMtwpjnJHYaqXL+7919ReM735ldcHHZFKBtbKq39ogTPW3NL1l
	tXIDxTZXZa6SZ4TobJURwEDmdk1mv2SqsEXhS4G2iHUF/eLDim7KWiCSjQKZIrOO1nMRhMSHORm
	3VhSgrNbkb4KN1q+yxNsaKCO/P8qm6B0I/XonPxyDT+xoRFTFp+7V1fbokrOim9V/iwD169Kw==
X-Received: by 2002:ac8:5a88:0:b0:519:b655:235 with SMTP id
 d75a77b69052e-51a703faaaamr4395391cf.3.1782371067208; Thu, 25 Jun 2026
 00:04:27 -0700 (PDT)
MIME-Version: 1.0
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com> <20260618-gmem-inplace-conversion-v8-36-9d2959357853@google.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-36-9d2959357853@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 25 Jun 2026 08:03:50 +0100
X-Gm-Features: AVVi8CfPiivQ2jTF4C4b2T4SW03MiAlvIrJh5OdhMlg3bv2FAUX7zsWQXsWcZEs
Message-ID: <CA+EHjTzFUayXCh2SBe7Nwu7YEO3aUmL1Fo1hE_v8OvUw7MWO6w@mail.gmail.com>
Subject: Re: [PATCH v8 36/46] KVM: selftests: Test that truncation does not
 change shared/private status
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
X-Stat-Signature: bs7ezphbc8x4un1tgsrqt1r75su1uabm
X-Rspamd-Queue-Id: 674C240004
X-Rspamd-Server: rspam06
X-HE-Tag: 1782371069-775249
X-HE-Meta: U2FsdGVkX1/RY8J31RsZXMHING+5yFEeDb6owy46cgzdOGv0M3AHSX9CteN8LaLgXTkC6kjFiWgEa2fLzumJ0mc8yMrs0HLNK7TSN2c4czTfk44otCZ3vwuJ6zvGOQQ4bzss19XREVpjtnITvG6+OHaB7KNKCQN2Cmj18AVYM5i7jGnclUbHd/uwm9d07HJlNDvOb7nFKFV9Fy7s6Ngzvmy8qeNAlTJ8jqXDa8ej6IEHzp6JwWFq93IbJUvDYq1f8NeLuOxGJtB2fxdx/cVBnOSckrrY+bCfNYlPvt8XawxWF9LT4x7kq/xHV10ANTibdiiRW37OnWeBsA+xyA9rsddSn32qS8lB7+0PQNIoEtqAyvLVErCJvEnHIIwbfDYqx3El3UbJxBEJAUuwvJeTt3CVa2YQbuRuiqFA1j7UOFtFG3Z/CWdEmg1l7HsjWSHvqxtKnPw0wkhSZ+iUd7hAmdXMBaXJm5epApdcV6Y3kIguJB+lsro6D3D1l1qmsan50WQkIDImCmY17O6Vxzmmk8BqZskI7o3pNKxjfq5VcqK1dDb+hcrd2D9i4AEjcUcOXpJa1N1FoJ70oE+lnc2zDNPxBFaUW3kjAKMveIcysJb1uUTMI2Wcti6R9X2sr++kAxEdMdHBzCiJhTl6ujR2rKrnwBd9UF4bEMz7fm1xXZy+3rSDUZkjshgg9WJTUaiNDGxvx7J9stxao4XI0eKxEPCzqmWc+e7fjfUPxD55EksEWvs8RpkwBkO7wyeQ2VVS56mUjROvkW3PWL9jQ8MWHFfz19vU/+kbq+Ahy5rLJkp1veg3aXVOu4EcPL/YONXVYz5B1KI4Ez/I5PriTfnq4xkQI2km894Zxl2bkpabK30IeqHPTicwd7+SerZYrmZnkLvu+QJ9SRFb9CDShju1NJhR9LnXxt9CwKMFagAPHdAfcRq8wEnuuVO/1BPFmyxj33A6T2dPBjycVaobT2B
 Y1mew2Kd
 xetfAfWKDrC15jtoiAeTVjQxV2myY5rninmFu4N0sXDD2Fv+wkFFAGwydTLQZg8lIBl4TqNSociwfI/fXO9Lhw9PjZnf3KJIzMmYAmeNG21kkrbbzXOaYKAAqDnjNV6BRA7nDYLMXXGnnfbHSVV52RSbSBdbjjQ75mU3xe3JXvqp9KSMaG+7iWKlcF2pRNtwpPvqwjx1gUDds2KyePhb+LRAoWUKavJn7T1L/CtIAzBbcPOLZGPczKQSgh+xXnKpKyWXZO6PZeKWHJsQHfxvZLEj7rUkLOUS5yCki
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
> Add a test to verify that deallocating a page in a guest memfd region via
> fallocate() with FALLOC_FL_PUNCH_HOLE does not alter the shared or private
> status of the corresponding memory range.
>
> When a page backing a guest memfd mapping is deallocated, e.g., by punching
> a hole or truncating the file, and then subsequently faulted back in, the
> new page must inherit the correct shared/private status tracked by
> guest_memfd.
>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

> ---
>  .../selftests/kvm/x86/guest_memfd_conversions_test.c       | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
>
> diff --git a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
> index 0b024fb7227f0..f03af2c46426f 100644
> --- a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
> +++ b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
> @@ -10,6 +10,7 @@
>  #include <linux/sizes.h>
>
>  #include "kvm_util.h"
> +#include "kvm_syscalls.h"
>  #include "kselftest_harness.h"
>  #include "test_util.h"
>  #include "ucall_common.h"
> @@ -309,6 +310,19 @@ GMEM_CONVERSION_MULTIPAGE_TEST_INIT_SHARED(unallocated_folios, 8)
>                 test_convert_to_shared(t, i, 'B', 'C', 'D');
>  }
>
> +/* Truncation should not affect shared/private status. */
> +GMEM_CONVERSION_TEST_INIT_SHARED(truncate)
> +{
> +       host_do_rmw(t->mem, 0, 0, 'A');
> +       kvm_fallocate(t->gmem_fd, FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE, 0, page_size);
> +       host_do_rmw(t->mem, 0, 0, 'A');
> +
> +       test_convert_to_private(t, 0, 'A', 'B');
> +
> +       kvm_fallocate(t->gmem_fd, FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE, 0, page_size);
> +       test_private(t, 0, 0, 'A');
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

