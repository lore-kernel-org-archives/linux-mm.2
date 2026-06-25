Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6672CDB47F
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 08:05:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5AB06B0088; Thu, 25 Jun 2026 04:05:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A32576B008A; Thu, 25 Jun 2026 04:05:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9499B6B0092; Thu, 25 Jun 2026 04:05:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 70FBD6B0088
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 04:05:56 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0305A1C33FF
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 08:05:55 +0000 (UTC)
X-FDA: 84917701512.03.124E18E
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2874E1C0007
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 08:05:53 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ImAcsCH7;
	spf=pass (imf21.hostedemail.com: domain of tabba@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782374754;
	b=cyM6X1NAE/puVpMZD6nXxqha39wTu3stIiOaiib2X2UzsPykubzgTt6estDYj3j0VmQe3S
	4wYf594S3sfPnRAuwrt7pPnFX4jBGY/qlBB9e9bCcSHTwU2X18ohBKd0VZC14rAN7ws3ne
	R0VKfQd0FtKsC74tSm5KMHjnNGIWupY=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782374754;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9LjtIzZk3vxrXZVAwqdL1YMS08SLuDbLYjQh10VCn/I=;
	b=BtsfzMk1C7+fjHCG3LTR4qbmivtpWEE2q8n8V3NloB4LjktGxBhGpJRWahN90D0nMYbkMB
	flUyQh3fsw0yfsvaMvbsV8fPuNDpEX2nPw0muBPIRTHq8HEuWRsUN0YDbJ/jP9oR5DgRxk
	l9kVkmAqMmAClykh+TKjtLo3gCNL/s4=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ImAcsCH7;
	spf=pass (imf21.hostedemail.com: domain of tabba@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-51765331535so141261cf.1
        for <linux-mm@kvack.org>; Thu, 25 Jun 2026 01:05:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782374753; cv=none;
        d=google.com; s=arc-20260327;
        b=AmEh2o1Cp9mdqBuQ3aYUuQ8vdLPkdr51N3RgHSna/DjOgU3/0GnX+A9hkWA0fhfrVp
         +4WhKo4GlPFdBmD4ZW2O5AyF77nGP2+hW6i1+IVpMXYHyqtw7OdFEM08havkJfHdZVC4
         oVWEXdCMDalqv/ciGrvL0oD71Fj3jEU9qJSqU2avrEcan4dSsNMdA9EgA0JbbAkbt77a
         1ZmWeNB0HIZ7jVtsa2pkAzqcHAP63v4rgi8aNV1MP/EY9dTyGXIErjObzU3KnQus+dYX
         M6Hwm5GS/+9Z8s8iPGrxIT3BQ2zS2si8qjDSToDZlbqocMvpZdENYa7+YlmRU6J5O9oV
         ys1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=9LjtIzZk3vxrXZVAwqdL1YMS08SLuDbLYjQh10VCn/I=;
        fh=TrPBbpfbvgpIRcCKhet/2Axaj++FmjJBO1zTa2ToeN8=;
        b=ckRqmf4Yzvn4j2/X3MUST7cQtLBB5cGTnFzlwr5H7nKaD+lsEPlDTfKDJgMp1GfT10
         /RKdvEH4mEz8vE1rDQJs07Li3NDApn/iuSFh2EPyRN02iuZfWnH6PY0cj3/6mQyF6NVV
         QEj5oTpbxhaNGV9Os58qruYjW+TuGKgZdMFijKEp+j+x3ErnqNji0cP6uEv78ZLqs1Iy
         amII6vWcMy2SolCsK2e/73XZc3q2lJ7RInGps7m6Nd+aRdtB/obAqbAZZecfRlYlKwJe
         lOueWeZOsPVY8Bdx6rX/8d37xncxXg1iD7iHMEcfDfcOaVveonYunXgspNqY73/nVYzn
         fwPA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782374753; x=1782979553; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9LjtIzZk3vxrXZVAwqdL1YMS08SLuDbLYjQh10VCn/I=;
        b=ImAcsCH7xFxUKUB1TF86s3uVBN0CB0gMpPsn9sGau/58fnCmr7Gj1/MAInGY44wKOu
         znTQASV25Or/QXZfxKgcVmx6MpC4O3DLfSxMFuaU1LsgOTEvOqq33kwbnY+1ycXVjKRy
         RjN6uTbCHqhHPpLkp2/HPmmLF/347rMVbvJQJW/jjx+d1nFWPvRJB/f6cLapCexI5MiL
         Wjutj+vuH7jyXcunSpOnABO6reTPaaTZH2/1cN0Kaq441fhu+ml5PeKGD0J4tH51/K/K
         YUchiTQIuk/mAkhlvFdkpcxdE3bgnoZ8WBLPDdQeDdL9n1UT1DXeuu+RTKzFe31U0ZGF
         /OWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782374753; x=1782979553;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=9LjtIzZk3vxrXZVAwqdL1YMS08SLuDbLYjQh10VCn/I=;
        b=HGQclCT0WJqlRNGSPHAMKBitgXqSGfOWLkvH33b8Y454V5Idqf9Ci2WQKRHFRLeaje
         FuamWVdWBZf6x1TUxjJonrnUmmYjq5T03zS0lvWm2Ar5oN7OUpatT3QFwot/i7OzcQbX
         KeQAWF4g/aTqOTGxvahA4GBOhUShlNeGsXuJMmofNBGELtStsHdShoPG7iZuqS8PCwP+
         wjAfgfL373duCfZVHyNkGBW1qjLaQ2nM9Yeq5bPh2hALibwFnOcHVmA9JS389hPboMTl
         RigI6HKu60BXH7/X5PIdVN/XkLRwL8QeS9zsAQwbtLWjqJgs88iLLmyU9WFRV3GZk/B6
         Ns4A==
X-Forwarded-Encrypted: i=1; AFNElJ9awgC6zrf3jFAV5WzBfwDEN5N9XoiDhdXCpVSaZun29peUawjmzptDnD8WFK04RFLBczrpNN4fmg==@kvack.org
X-Gm-Message-State: AOJu0YxDkcdCmgJ0uI9hH8s8Rzoq/17g3GJOLshV2jftlMcelQu5jVv8
	RA6EL76znaKPsciJ6Tfqcusgajvc0s6VLM6TMECn/n25be5tzMAucoYhKIZcSadhv89YllNkksK
	6WaU3AiipJ1/sU2gR1ruUW7bS18LQBuZ4irp48B5y
X-Gm-Gg: AfdE7ckstGrlHQVoOJVXM5M9PQWWwsLqPJ22Gy5wVFg9MXEwuPDgdUBE9+bb1D5DhkX
	wQIwu5945wt9FDcH+VX/L1endBuDZFpq1ju7uh0YeVFRwn1kZQwEWuOhS6/lprwlImDPZaaVOGc
	nygb+SqdbeYDNHWckNgT1EnDSHSKcHztyJFzKshKNgbociB0BTx7fILqGWz9MO23h/fMYr/8w+8
	hutfwD9tbaI/9XfwiPwGRIsutR/4gRVtgLj1ljO5HtEj9EQBEX+HjreCzdEM4RufbC7urScbA==
X-Received: by 2002:a05:622a:4d99:b0:516:4f62:85ec with SMTP id
 d75a77b69052e-51a7097cdf7mr5787961cf.17.1782374752598; Thu, 25 Jun 2026
 01:05:52 -0700 (PDT)
MIME-Version: 1.0
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com> <20260618-gmem-inplace-conversion-v8-39-9d2959357853@google.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-39-9d2959357853@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 25 Jun 2026 09:04:00 +0100
X-Gm-Features: AVVi8CcBY4t5giF0-A9bP1HPllgz1zAJhj3Ny1-iABTQtlbD2BJIIQOiCS34wl4
Message-ID: <CA+EHjTxtL+usjD5XWzrEXegSAt-JD_SjH9MG1S6aOy8sWYf67g@mail.gmail.com>
Subject: Re: [PATCH v8 39/46] KVM: selftests: Test conversion with elevated
 page refcount
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
X-Stat-Signature: nraeza9f5j1om8gc76kyjzoto8zi6qtg
X-Rspam-User: 
X-Rspamd-Queue-Id: 2874E1C0007
X-Rspamd-Server: rspam02
X-HE-Tag: 1782374753-24049
X-HE-Meta: U2FsdGVkX1+VNRc7UNUPgJNMzgNbWIsMCxS3gUaRGYqSPmf8yBxEWkK8Ev9z6FXD9l7fr2bT0/B0WhyTACBYcsqAWvV4okeVhI7avGReBlFoCRtyeYcZbRMOnmhMu/O+3xia488PRlWhnJHIo8B81uy9cJ1ZWySX4pkuM1DSeCXjewpINMXvwgS6Jiw7pTiVDxrMrndBfTZt6xagHUeat5b5OZjRboqAP4BYKZf9n545lGH156vjjSGIEp1o6IZ474UyLKEANaV4OU/ExQtoIBorWfDBRIHRWlJYFXXnj85xCrKHPKzTGqVaIrosGqQW/6bLV7ooo0u+d8Qts4OgeloTmziUuVK9tVQ240CkgZQghx6lcmhNLkO70PsNwrb2GchbqxDSTdyhA7C4FGFHuPB9FAlzKSSXav+H1GyDBgwwzSzyKm6pXydbGFxxlkO/e31Q1gn/HBYpL5rfXH5ZHaayOWOPmtL0O9iaAVSJMOc8mK1tILGNMSaRmA3si5gmk/3heoma7b4e035gqKhYO6+F5MBGcKFkeJl2B1x92G5s5o9rpGrVisY/cfQme/D4YnZxjec3qPeRMTdVJCqj9fqb2m1T2EmrnczuuV9FZyPYy/JbVbafDXpUxq0Orzn79D/fAMs3vNdQU3w4vfMzu40rMcKZGHxi18Efsf1JHJIXm2LVIaDeJsSWJCU/Tdmml8tpRMAS3DhPkasrmgCppSJ97KdEY72cbvdYLd4OLtuuFb/zaFWjf/xO+4EBTCXANe0MdUhi+AgJddZvwOgnRx+YOSaHNA1hFc6zsFA8s1ABCKukUs7suto3XrYOSYt9TqW5gwTB18cs3BIXReG5zA4krAJji3DknKOAeQd6cVMx2WO8a5MJEbhMu70w2zk37butLdW9A4I5qKqUEaSLXDLldpAoh+NgPp2sjsYKAnOMzkkley6/y+z5/hrvVIMLB6gYl0ApTjUEIewW0lC
 qGmG70aQ
 APWbpVL85keSScaz5ANAHVkC0wwYInmM9/HIIohmU45BHW1eIYLfKALvrykawUz23e6aF68RitIV4NSA6BVdbvDAtj5EpcmUbNq6guIiSWMhWCPX6KpGAmHBuN69476v3/KBwFOxgnoQVctvPyPdQA/TKvywkOnt3d/DtbWUqQ/ibue08J4iVJjk9UeAFmAui88nmNI9yAaJsQgg/IcHt55gKK5JhDwR9fMK1sNFd1sh/qWpg2CIlrgkwSQ3NEYE72ZF1lwRnEhwkOkL3XYKnb48XGUHeggpEVv1S
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
> Add a selftest to verify that converting a shared guest_memfd page to a
> private page fails if the page has an elevated reference count.
>
> When KVM converts a shared page to a private one, it expects the page to
> have a reference count equal to the reference counts taken by the
> filemap. If another kernel subsystem holds a reference to the page, the
> conversion must be aborted.
>
> The test asserts that both bulk and single-page conversion attempts
> correctly fail with EAGAIN for the pinned page. After the page is unpinned,
> the test verifies that subsequent conversions succeed.
>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Not sure Sashiko's concern is worth it.

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

> ---
>  .../kvm/x86/guest_memfd_conversions_test.c         | 56 ++++++++++++++++++++++
>  1 file changed, 56 insertions(+)
>
> diff --git a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
> index 99b0023609670..4ebbd29029526 100644
> --- a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
> +++ b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
> @@ -441,6 +441,62 @@ GMEM_CONVERSION_TEST_INIT_SHARED(forked_accesses)
>  #undef TEST_STATE_AWAIT
>  }
>
> +static void test_convert_to_private_fails(test_data_t *t, u64 pgoff,
> +                                         size_t nr_pages,
> +                                         u64 expected_error_offset)
> +{
> +       /* +1 to make it anything but expected_error_offset. */
> +       u64 error_offset = expected_error_offset + 1;
> +       u64 offset = pgoff * page_size;
> +       int ret;
> +
> +       do {
> +               ret = __gmem_set_private(t->gmem_fd, offset,
> +                                        nr_pages * page_size, &error_offset);
> +       } while (ret == -1 && errno == EINTR);
> +       TEST_ASSERT(ret == -1 && errno == EAGAIN,
> +                   "Wanted EAGAIN on page %lu, got %d (ret = %d)", pgoff,
> +                   errno, ret);
> +       TEST_ASSERT_EQ(error_offset, expected_error_offset);
> +}
> +
> +GMEM_CONVERSION_MULTIPAGE_TEST_INIT_SHARED(elevated_refcount, 4)
> +{
> +       int i;
> +
> +       pin_pages(t->mem + test_page * page_size, page_size);
> +
> +       for (i = 0; i < nr_pages; i++)
> +               test_shared(t, i, 0, 'A', 'B');
> +
> +       /*
> +        * Converting in bulk should fail as long any page in the range has
> +        * unexpected refcounts.
> +        */
> +       test_convert_to_private_fails(t, 0, nr_pages, test_page * page_size);
> +
> +       for (i = 0; i < nr_pages; i++) {
> +               /*
> +                * Converting page-wise should also fail as long any page in the
> +                * range has unexpected refcounts.
> +                */
> +               if (i == test_page)
> +                       test_convert_to_private_fails(t, i, 1, test_page * page_size);
> +               else
> +                       test_convert_to_private(t, i, 'B', 'C');
> +       }
> +
> +       unpin_pages();
> +
> +       gmem_set_private(t->gmem_fd, 0, nr_pages * page_size);
> +
> +       for (i = 0; i < nr_pages; i++) {
> +               char expected = i == test_page ? 'B' : 'C';
> +
> +               test_private(t, i, expected, 'D');
> +       }
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

