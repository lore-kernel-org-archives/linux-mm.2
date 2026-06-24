Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3135CDB479
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 19:55:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 731926B0088; Wed, 24 Jun 2026 15:55:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E2276B008A; Wed, 24 Jun 2026 15:55:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 584946B008C; Wed, 24 Jun 2026 15:55:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2BB2A6B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 15:55:15 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AA69E403F7
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 19:55:14 +0000 (UTC)
X-FDA: 84915860148.04.141E055
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf17.hostedemail.com (Postfix) with ESMTP id B18CC4000B
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 19:55:12 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=hUTQbP6y;
	spf=pass (imf17.hostedemail.com: domain of tabba@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782330912;
	b=6xOdBxw1GY1A9+8iaJWyjECyx56ef7k5M9YR4JcCoYvp1eJIRDlrjMfAfSS84vdbafy8Nq
	8lkwpKnws2QYXnlrqyCVHMFZhFBGyHmCZ56wLzF9UkIAc+9ZU/GHs8Ruxk6/5bJcSy0erZ
	09xiVPyFQD0R1NmQ6jAqOTeEHjY1SYc=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782330912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CJJECXfHWYzxy9+jrHC2YkFB6UtBZdMEUotYUUXmsS8=;
	b=dxeidNupRyVgLEAXrQfUnbdsnzeYy4/48Jzp5ylemmY6OBXJfSetRLjOc0aJApEodjLTt1
	YhAnei+Y5sRJAb3xeaZWjOOvNL+ruw4sBkaxzPX2C17lfmCcSn5gBeJshd6+hWZamwRK4c
	2JFEbmAQbqdhOW3EI5fSl1g7x/+FtWI=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=hUTQbP6y;
	spf=pass (imf17.hostedemail.com: domain of tabba@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-519ed52bcc6so61281cf.0
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 12:55:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782330912; cv=none;
        d=google.com; s=arc-20260327;
        b=nBb8KvdQwiTzNXX+XEj2HuK3CPqg+5qsMgfErOT8Ei8rYKvEFmzzjWvrlo4i9kQzKW
         nTSPgaXaJnlkrqsRshacJfs47HBEpBTvdF2EtWmIJ71Nl4Bp8lj6QtqK74sjGlRcyhX7
         6Pf8FbGSag+tUhpGH+2y0KoVZJM1DZeSZ29G4FX2ZR0b8+efcpTYjavz73n3C+4QD+1r
         8Pia9k24lUfcQvbCADFUTWBVv/5EdVoIeiJB2dBPKZ+mrQkMUNCsDl6ik87dlG8SJ/Y/
         UrDIkAsk2O7SoSyvgC8gxCcvl8KIv5P96dvOL51s6I9zjh/VE9BK+OkVv31Zx0jLZ2ap
         VvQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=CJJECXfHWYzxy9+jrHC2YkFB6UtBZdMEUotYUUXmsS8=;
        fh=9wpPFCOiip6ENyrQad/3gfHcaXExDnUgrapvjH0+q20=;
        b=ijKLI2D4nEF/d/jhW0OT7PR/QEfFJ9z9D3Qk6uMbQQx4hgejNKDbUbeM9TTGHZ/Pob
         BOKlKmx0xrz5q8SIsJwDMTMXIJpxKL52drgJ6DOMFmTpyELrw/W6vmX+YerBTx3SK5Ow
         dor8+YShT/4VevK2EhvzZth2VzU8MSetF6xo5TB3KU+/lvXII1ie8oaFVILEpF0Z/KZC
         f1SxrxffvfdWOLY9mo99ULbQ2SeuDOqDPaOVLo8dFUQwn8aAcVkXwI6PWWC9wBJKkAcH
         uNirITLiaeyFJQijYj/jPKb5UvOXuCxJ3VWWllJNlYtwYjP7s3eXpU1Q0pJthJ2IxWEu
         VL7w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782330912; x=1782935712; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CJJECXfHWYzxy9+jrHC2YkFB6UtBZdMEUotYUUXmsS8=;
        b=hUTQbP6yxWrCHNQ7ZT7cND0J99uJpScTcG/T/2k6ihBc9gsZQBUaPUKzYNtwDQpgEW
         H1/Tb3eVNisu3RC2D44sGt+R36b+GGTsLbdLk5cgnhIBgaOKomhLwvAAV/fhCRQ/y8pp
         Su+gPmCAEu9KbH/vtzoysk72bEEkcCrjSp/JQXLHrsKBKljkJu+/0LZLq3ydL62kOhHW
         GXD34WHtmhD76wTZAPqB7BUhS0moVr4LcqnCiJVCkUuzGThjSPgU1soNg3hpHL6CKo3l
         1Fojk+Yvr/aHNyOW+Iy0jq9O71WX4HuiwSxjb12fwD2g5qZRMhtf7Jrn0BADYN85owal
         j3eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782330912; x=1782935712;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=CJJECXfHWYzxy9+jrHC2YkFB6UtBZdMEUotYUUXmsS8=;
        b=WH4fbDE0i8AyE+r/nfTXceViuZujPH7ab9FVUdC+YfaVOpRJOlerS5lIk88NreQ16Q
         kbt/rlqQCwWc7X2TbW9HuaKs7svvagWnw6027HiQI+QajvxWL3DqEs4I8/OQxTZqG0em
         /Nez68OJIYGl1dPouDvMgq028pAOUYMPU+fTRiDZvukD0WF+2+jCtjZuz2PoutaFZiEq
         pwKl6orpZoqz3Mfgdyz3mkexZwbNw/cDJBV51maiktBCIznfuoRpRY9pZjKtC5Cm3W6E
         +qz/Q/IUqU0D1tcAXeLe0cHaq1FZhcjlLdqV4gNh9hGOtgjcygzbDYalZPkgfOb8yZk+
         xaKA==
X-Forwarded-Encrypted: i=1; AFNElJ+GjVEJWQIdRYG+R8fHwpqqr27ixloi21veknHkPOtjQKTeGj1OWOdLjxSEmyH+v1JbCpy10Z3v3Q==@kvack.org
X-Gm-Message-State: AOJu0YxX4CBAWc27gLvJOA1obzvEY0iIbl6XCG3qEtUrArboAvqV9mhn
	F9N0T9O1qjO8A32VhdZ6DwH1oUz48XPu+LJC1Ik1wuMjr/I+JcQc/k1+syZ3MDqmJBFOwb0V8VY
	+hKzGO2X7/Fib7PHYRKwRinMQzZKd8LolJX8Bi1fL
X-Gm-Gg: AfdE7cmMDo7lyS9mulL01Q0XvgPVOHtej5968cIfImjd0whr8/SiySO60ttvORgyiIm
	kGXs8mFo6v+bTE86Pl+9ME585yES6932f4KEYF9dRTIA5nrnwPOuYJtag84I32X4lFBGePLGHp1
	Dq15GLhg/pmHRjYiT7kSTOswEt4j9UlfuMSung6eWE4/pt+caYTryrnSycVLEAiK83rK1M7FfMA
	462xYf1WGye9WpnGMXvUtf7VlfCfeyAB0vHv1tiRx08qw7dwXLuwVnUlsiwLikh/DO37q6jWQ==
X-Received: by 2002:a05:622a:64a:b0:519:df4f:6c93 with SMTP id
 d75a77b69052e-51a6ebb200dmr1920671cf.20.1782330909527; Wed, 24 Jun 2026
 12:55:09 -0700 (PDT)
MIME-Version: 1.0
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com> <20260618-gmem-inplace-conversion-v8-32-9d2959357853@google.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-32-9d2959357853@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 24 Jun 2026 20:55:00 +0100
X-Gm-Features: AVVi8CdkNL-Bi4CuQeJBlP58vmddsTQ61Xm1xaJ4QXqFxTKdTVP42Qqva81y8NQ
Message-ID: <CA+EHjTwJYQmg6oTU49ObF5fQCThghn+TMau=g5zUP8w_KLuiKQ@mail.gmail.com>
Subject: Re: [PATCH v8 32/46] KVM: selftests: Test conversion flow when INIT_SHARED
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
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B18CC4000B
X-Stat-Signature: 3sdnocun68qyzsfut6jxg8mzhj6k4f58
X-HE-Tag: 1782330912-43260
X-HE-Meta: U2FsdGVkX19Sjo8TvudCEwc1pV4/bBAWjkxaGeT2aQ14QUgg2/En93194/WgyjJW0w0ucohBjh4oZOlDZsBGyOe8PHwK7IPi18OVg1d333wUYnotYJvXn5Iy8WmF25sh9nc1bQdTgyoWVBKdkTjBG3OEsENjnUEunDR4Qq6/gfeHg0kIc3J5pfLR8APkUBWQeuG5iu5t9q0l5g3+hwf1HKVNvB1R3UHMRRQI/mgrYwlDl8IYnFFRK6CzurujsZAXbOYA4niEeQrZsC8wSTDnz5d96peTUpUbV8xn20VFdvR0uMPNC41SYEPlyZsWwwI0ARjbJg3vnE8frPpvY5Gs+sOUvPyDO9oncOrpsaN8OXdugnVZdfDYCFMw8uoll7duQmu7TteTkY1nso/tMeuqiqi0bilQD9HiTZu3q8Gz0ywO1gfHTGBx2TBWxtDHRlRD2JBJQBWFBszHVdUENpPZhwNTc+7mCEqK3Qhf1lZMyV88VvmQJEgV9Norm54xCC1gzQBP+72W0vXEB13+p35JfFTlvX/ApQ4OYzRZTIPBkQJtrunnTv1DQJTLerDIsJtii1y//UogrReVWtfeBy7W+Pa8BTRhQ0otkASl+7ZmsFmHJzaQYlYdieeDUB+a8MpdnMnbJLPJflrjfUE95AVGoiaXUDOApQMtRVyU6movzQCEI3WODQO3d6iMmIKDIpPkuNLaYWciUNGn9FfQbUBVSsfsK2v6eTWMiCbgDopIb2dKXP6fekpdq3cIuT7ah0FHODh42Y2A6mT3ui+Y0gBYSyAgJFjM/guzX0RKnpfDc/mKkhjFGo9VD5dCCQc7lvGJwZVdd8CxXzPVfo75YsCcmUsMG9/yfDFpnH6XTQCWz2X+QL10hmFfjxCKZBSh9kHyrkStzBsQspsw0oSH+mWexYrdBVQXlj1Ezjnezjt7XwgovMkhO+tcyCZtw6Hk6bGhnJ8a32tVvWsDbrhAjzz
 Qu6KoPqu
 FhfidUXIfVPy58PbYYbuJ+5njnP6oVrVwJTe+j39dK0EZdWRfyyiVOTpSvfpguyJ2M8TaGheutlKJEYe2ZWRLfDvPCmhxf/nB7BcAld8a+CN5aOn31r1jmWVieUiCoD8RuMfnzD9Jw289IHnxFjLi5gCFBuRhqkGCPQNOempSCtJiNtye3xsFLzSQgJ0iJ4Ye+qAEHb2uUj4om+nIArCQaFabOo1nIIbozIyuPLuvxXrV3CrTdaFrvhVS/ssT/bsOqkuJA5t/DfBd6jKP7N8Cag1782kVOOChIvBV0LZm5vKInuc5LfFWZD6aDSY2+HaOtKwzqQHi8/lr6Zk=
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
> Add a test case to verify that conversions between private and shared
> memory work correctly when the memory is initially created as shared.
>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

> ---
>  .../testing/selftests/kvm/x86/guest_memfd_conversions_test.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>
> diff --git a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
> index 8e09e241723e5..5b070d3374eae 100644
> --- a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
> +++ b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
> @@ -95,6 +95,12 @@ static void __gmem_conversions_##test(test_data_t *t, int nr_pages)          \
>  #define GMEM_CONVERSION_TEST_INIT_PRIVATE(test)                                        \
>         __GMEM_CONVERSION_TEST_INIT_PRIVATE(test, 1)
>
> +#define __GMEM_CONVERSION_TEST_INIT_SHARED(test, __nr_pages)                   \
> +       GMEM_CONVERSION_TEST(test, __nr_pages, GUEST_MEMFD_FLAG_INIT_SHARED)
> +
> +#define GMEM_CONVERSION_TEST_INIT_SHARED(test)                                 \
> +       __GMEM_CONVERSION_TEST_INIT_SHARED(test, 1)
> +
>  struct guest_check_data {
>         void *mem;
>         char expected_val;
> @@ -186,6 +192,12 @@ GMEM_CONVERSION_TEST_INIT_PRIVATE(init_private)
>         test_convert_to_private(t, 0, 'C', 'E');
>  }
>
> +GMEM_CONVERSION_TEST_INIT_SHARED(init_shared)
> +{
> +       test_shared(t, 0, 0, 'A', 'B');
> +       test_convert_to_private(t, 0, 'B', 'C');
> +       test_convert_to_shared(t, 0, 'C', 'D', 'E');
> +}
>
>  int main(int argc, char *argv[])
>  {
>
> --
> 2.55.0.rc0.738.g0c8ab3ebcc-goog
>
>

