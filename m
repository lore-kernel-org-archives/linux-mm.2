Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6678CDB47F
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 06:58:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 498816B00BA; Thu, 25 Jun 2026 02:58:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46FD76B00C0; Thu, 25 Jun 2026 02:58:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 313A76B00C2; Thu, 25 Jun 2026 02:58:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 050316B00BA
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 02:58:40 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 66D881205A8
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 06:58:40 +0000 (UTC)
X-FDA: 84917532000.22.51C1909
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7B3C640007
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 06:58:38 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cXmsuxbW;
	spf=pass (imf11.hostedemail.com: domain of tabba@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782370718;
	b=cCXkG+ihab3n56AgQ28JAbGLjYu6CWqPM+JbEMVe3mZCgoghb0rZjz3ZaxDjNmniucOHwH
	eziu4UuRVr67D2EBLGfK8oMZ81Jr8EDggVyvOOo42Df9kKKEwUSOrlHl0H1euicQzH9bEn
	4XgVLjV5nzWk/tqmUflWVJP7JYzcRms=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782370718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KdGqwRZEoBZlGth5crGGDiriD2nf5vVEe54PRH1YZ7s=;
	b=Nzbu15v2HP69mbgxcWU7l45ykMX5QysJy7QomWLSKMbvjGQYGJpgwitjY041NBdl7d+1DU
	MXzYlLjWOlKoGAsWtd7JEgOBcANmUJQH4L2ZKEq23gH32viu7gZFg17MN3EcIVehsvqZjR
	64g9IBf9XnrL2zlHqzXWHf3xH6bo34w=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cXmsuxbW;
	spf=pass (imf11.hostedemail.com: domain of tabba@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-519ed52bcc6so180361cf.0
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 23:58:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782370717; cv=none;
        d=google.com; s=arc-20260327;
        b=QHp0LXopmyUAn43MGHfr60aiTssNiJx7HKCbQMcPzKVmpaqxkjEFliayiaveAb6KJP
         bXYWtfTnGYa9X8BcnP/Ua90gPoU0fNQysTuZuuqpprhn3bYri4TjNDxlaH3l3tsG5REy
         zFJ25hWDYH6ilvyZTvOmPA2Ruv76TRpo0zdzCQe1xDAXYlSiNVs3A3H9ZMFj9umpZjEE
         W5XSWEFTZIK/7Im+p8z2m8ffX/GVQv9cJB428k1ICE9fUxs2fJ/2AOYllOX7iJ71R5Ou
         1nr4ln8H6lEevF5qRffc8MMdKUgxLZNI49OLiPRIN2ZagqImjp56pURhXO87engEoL//
         LCXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=KdGqwRZEoBZlGth5crGGDiriD2nf5vVEe54PRH1YZ7s=;
        fh=sGsnZM3p6FbG/2ffuYnsvxB+R7HAt95HFpDnk1LO8AM=;
        b=fQVzBOhLJ7tISFcXjJhA9CHPZuFt/cLbAuad/O7VC6qWv/n3+NzJ4ohFghVN4qirbb
         wJ4HJt/wWpGpc5j/qktrzpH5JKQNaPTXYIJceQr17KUFBCTFIOjViyz0fHr5yBjRuG+8
         H4DovYhA9Ecun8ndikMFv6kOwszyj8RPOGeN53ymwzz/UaO8EXWQTZdzffZGTarPJbvL
         Y/WHDyLYIovAChvOhDHnhJZ5QJnvuVqj1+OQnlLOSWWK9QMrRkl7pK3k1UQ0tN/tqheV
         FGamyhOioxYhSiXLXPtl09lk9faCavv3JskGs8kohxNqJq6tFDe5QV93Vh4gLwDih+e2
         3f3A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782370717; x=1782975517; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KdGqwRZEoBZlGth5crGGDiriD2nf5vVEe54PRH1YZ7s=;
        b=cXmsuxbWQs3OUujZJdlmKFwv7w8HPoraoDAnzDfu5uAVMpigf0XtqG0QkRwZyXinoC
         dcB/YwbIqmdozpjLOpF/95Q+5wqX1c/8tUWWYkyDJQcIitcttrVoPNAY1U/GBtu8FYvp
         zXuQi9St5bwAKwSR9GO8JMy9iuQX6XkhOHF0B+RCFRnE9A1F9sSmO3TIKonfE77P88MY
         We3L7SAJpQffgh/y2ZCDfOtwnI1ttrMNg+lzxCCwpebr45chStsLbn31MVpkuZDqtzxn
         IsBlBXxl886Inz+hgTYlLrQQGCwy4thyh9+iNgc7lcO2rLRpTH0UqFdPLbJO27x2rp4T
         p6oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782370717; x=1782975517;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=KdGqwRZEoBZlGth5crGGDiriD2nf5vVEe54PRH1YZ7s=;
        b=T6A9nS1oem/Slf7ZC86AT0oECFavdFNAk56QzPmsETz1QS4jBuzkIIQgqMC3lnm8y4
         JdK7Y+yl2fI0o86m/WsL5yHTkydzFCz0W8vlHvfqCkHPefbx9e0nYJWiTWLDqr1tKfH6
         7Uiy3CN1UDnl2sF496OBbX8QJup+G6Bh/LsoWZ2FzxyKOHVvOEAs+m/STsqXQLbakFee
         pdh7ZUX8VaL4a8gNVZXjKarnoWg/sCVKc0wXUeaQC/ldoizuEwkFqG2NwC/C392V3dMn
         4ckEZhiQ6fzwJgxIYQptvJpMESKfH2tEXPQ3C2esX3827WML/72RPQKG8rhcgjM2l9Lz
         rJ3w==
X-Forwarded-Encrypted: i=1; AFNElJ8/GhC9JKpSOmVE9dYxWWnzuB/bG/1PJnMqQ/X7dMIn3xgr8VGA6c3Hex5iGOLuKZ+7YU0rKih3Gw==@kvack.org
X-Gm-Message-State: AOJu0Ywu1AqQe8X7WpHVzw4xBSIMn4vxpeHjbspo1RmsKcY4V2fJWPsC
	5Ys1Tjx+eEzHugShSLzujkg0Vf9dZ1wxFE/jDRR/lSiYqF6MASUmY6FNIBeVqV5HK+yE7aPxFnP
	ppWZLnih64+LFt1Hc5LYsEGFMicNxFDOW8rSA4hGq
X-Gm-Gg: AfdE7cnQ8SuGlofhwExl6Yb5+gQ+LKr9QKPe7mCE9oFhRXI9FferMnIjUHvUlu5Z1u9
	06CKpB1Z8m0iCpp6kW/HhigJS/f+0zLgH6IRTntqAq6rXGYjnZSFUPjqP34X4KnCt1aqhYBU/ZI
	YewwG/jLZdwpzAhiDtwwlzHukCER87joFt+x84tqB9aD4xvG1mYV3ekgOsN8Zlz8XTfZIQ24TXg
	cTUPsDZJHObOxHo+4hp3uJX/1OtJMr4Qt+oYU1rcJpQ8RLQMrRSt9SY4eYaKvh53umauwaZbA==
X-Received: by 2002:a05:622a:586:b0:519:f8a0:16b4 with SMTP id
 d75a77b69052e-51a6eafc644mr6248791cf.14.1782370716783; Wed, 24 Jun 2026
 23:58:36 -0700 (PDT)
MIME-Version: 1.0
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com> <20260618-gmem-inplace-conversion-v8-33-9d2959357853@google.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-33-9d2959357853@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 25 Jun 2026 07:57:59 +0100
X-Gm-Features: AVVi8CdlUqqm7utRrODu0hzmedC063K0MES5T7_EuttwZUvfcmHiCBLx6crELI8
Message-ID: <CA+EHjTw=-yzY+SLvLFwJx+73OeYcBmT3YHYQmuf9=fx_KoebmQ@mail.gmail.com>
Subject: Re: [PATCH v8 33/46] KVM: selftests: Test conversion precision in guest_memfd
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
X-Stat-Signature: 85tksycmkfjuzfps6nb8bna6xh18r7m6
X-Rspam-User: 
X-Rspamd-Queue-Id: 7B3C640007
X-Rspamd-Server: rspam02
X-HE-Tag: 1782370718-862332
X-HE-Meta: U2FsdGVkX18PlAv20CPBshxxhG5a/F4Ju2FdgilifPySQC4V8Szk97EMwP1u645QJAImDyfyf9rcMPNLoQ96EObJIO1jU1pxZzTkeaIyDPsHmAfaCQZ7+tXecF1y2Dk9ogw+XfYoOjqef/G6e8Fpeq4luuCuiO5JGvPwtPD70mAL3rT70j2S1E1/sgdlD6j6wEV0/8UhLdbsOVNiIoK2mPGX1t2avauY1Thx+58R8BXXAb+stR7xktfHtCSKPm8gKvhhuFOgDZQLEK42MeMz3YfgFuwUtdoICUGncQ2Ob6BFgUnFoIYWmsINzhh8r6DDizoXWCMoI9gNSLoSukyMOCJkqzQ/g3QxA3lY+VhlhklprZmDhZGrU+fR3ZugJgcZJwR1m2gY0hTe8S6SzqaE6fxhXjiAVdg9aqmpA7Y3zr3I53ijSjGHHymSZ+rMYCLKn4kJuG7Y9/8f+hTnQ01eHJAyTe9MqBPTvii913PK6u/X8eSgWYAFJJsHN0ex4hAjOYZ8D2OeMB/6G7bzVeIjlGiJ6bd+954XmsZjn+8eyQBlMdwSC2ABjQUtmNsMbTFSahYiJuKsfRfCxdyAvIuy3n/7N+gEpTijs6CT7Q3MJjaM7jlVkuxtrU/B8zzusrlgvktUpqGO99TnwTAT7+Mn71WU8SF2XImNt6tb0IsWZd3ca316PFgCulyV/aCBAt8uUUJw6a1N1ii88r1R6CSF9AZwgxpYVltLIVt6bYweAZSYDfRLDgbgpSENwGAo+NiZ7GCSvemflLm+c8oq3JVnNmsf8VTQRFOHeye73SL+wVfqY1JoYLxJOjUajbdhlwRFvqStcEe0StPDE+Xhg1AkzKi3tsdXGkCa6+07O0df5BTL6QPOVGW0pu+kyN+OcRqfaSLilNh2k0ryplLaW4aMDIuis0SUGKeUYAstYzv2EIpu/2sJkJbp3tRYxk0qll5M2t/OIADMRnGsOQ+TLCi
 V/JMZx/l
 vhXqzSAd9kJkis/ZGV/kCzLh/us6MGI8aKl84TG4XbVbAnoISj9YBUdA2w8uwtzEeUrkS3uKUYZgPlrRKsx2PXiLzG0JnCN4/sXiXyauxr3DEcyEeJ4YYhwH+Pxy2d4kc9ajCE8sC2NqM62s/up2soVV8j3uhkdqIKaJkqA8MVInRKU7lBy7FYEvsDjq0YylMKFA/o+/calV/X69yYYQPDh998MtQZ10mUpAxYiYr+lU5OdiCzYMohc7aU+5+piGiCYqX/Tv2GpuyZ0d53auYR7xlLw0jAJOlKp0ICzOwq3ljw1cVVuqrT8DcsQCkvE6BBx/kc1Cd0d2COgU=
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
> The existing guest_memfd conversion tests only use single-page memory
> regions. This provides no coverage for multi-page guest_memfd objects,
> specifically whether KVM correctly handles the page index for conversion
> operations. An incorrect implementation could, for example, always operate
> on the first page regardless of the index provided.
>
> Add a new test case to verify that conversions between private and shared
> memory correctly target the specified page within a multi-page guest_memfd.
>
> This test also verifies the precision of memory conversions by converting a
> single page an then iterating through all other pages ensure they remain in
> their original state.
>
> To support this test, add a new GMEM_CONVERSION_MULTIPAGE_TEST_INIT_SHARED
> macro that handles setting up and tearing down the VM for each page
> iteration. The teardown logic is adjusted to prevent a double-free in this
> new scenario.
>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad


> ---
>  .../kvm/x86/guest_memfd_conversions_test.c         | 66 ++++++++++++++++++++++
>  1 file changed, 66 insertions(+)
>
> diff --git a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
> index 5b070d3374eae..8e17d5c08aeb8 100644
> --- a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
> +++ b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
> @@ -61,8 +61,13 @@ static void gmem_conversions_do_setup(test_data_t *t, int nr_pages,
>
>  static void gmem_conversions_do_teardown(test_data_t *t)
>  {
> +       /* Use NULL to avoid second free in FIXTURE_TEARDOWN (multipage tests). */
> +       if (!t->vcpu)
> +               return;
> +
>         /* No need to close gmem_fd, it's owned by the VM structure. */
>         kvm_vm_free(t->vcpu->vm);
> +       t->vcpu = NULL;
>  }
>
>  FIXTURE_TEARDOWN(gmem_conversions)
> @@ -101,6 +106,29 @@ static void __gmem_conversions_##test(test_data_t *t, int nr_pages)                \
>  #define GMEM_CONVERSION_TEST_INIT_SHARED(test)                                 \
>         __GMEM_CONVERSION_TEST_INIT_SHARED(test, 1)
>
> +/*
> + * Repeats test over nr_pages in a guest_memfd of size nr_pages, providing each
> + * test iteration with test_page, the index of the page under test in
> + * guest_memfd. test_page takes values 0..(nr_pages - 1) inclusive.
> + */
> +#define GMEM_CONVERSION_MULTIPAGE_TEST_INIT_SHARED(test, __nr_pages)           \
> +static void __gmem_conversions_multipage_##test(test_data_t *t, int nr_pages,  \
> +                                               const int test_page);           \
> +                                                                               \
> +TEST_F(gmem_conversions, test)                                                 \
> +{                                                                              \
> +       const u64 flags = GUEST_MEMFD_FLAG_MMAP | GUEST_MEMFD_FLAG_INIT_SHARED; \
> +       int i;                                                                  \
> +                                                                               \
> +       for (i = 0; i < __nr_pages; ++i) {                                      \
> +               gmem_conversions_do_setup(self, __nr_pages, flags);             \
> +               __gmem_conversions_multipage_##test(self, __nr_pages, i);       \
> +               gmem_conversions_do_teardown(self);                             \
> +       }                                                                       \
> +}                                                                              \
> +static void __gmem_conversions_multipage_##test(test_data_t *t, int nr_pages,  \
> +                                               const int test_page)
> +
>  struct guest_check_data {
>         void *mem;
>         char expected_val;
> @@ -199,6 +227,44 @@ GMEM_CONVERSION_TEST_INIT_SHARED(init_shared)
>         test_convert_to_shared(t, 0, 'C', 'D', 'E');
>  }
>
> +GMEM_CONVERSION_MULTIPAGE_TEST_INIT_SHARED(indexing, 4)
> +{
> +       int i;
> +
> +       /* Get a char that varies with both i and n. */
> +#define combine(x, n) ((x << 4) + (n))
> +#define i_(n) (combine(i, n))
> +#define t_(n) (combine(test_page, n))
> +
> +       /*
> +        * Start with the highest index, to catch any errors when, perhaps, the
> +        * first page is returned even for the last index.
> +        */
> +       for (i = nr_pages - 1; i >= 0; --i)
> +               test_shared(t, i, 0, i_(0), i_(2));
> +
> +       test_convert_to_private(t, test_page, t_(2), t_(3));
> +
> +       for (i = 0; i < nr_pages; ++i) {
> +               if (i == test_page)
> +                       test_private(t, test_page, t_(3), t_(4));
> +               else
> +                       test_shared(t, i, i_(2), i_(3), i_(4));
> +       }
> +
> +       test_convert_to_shared(t, test_page, t_(4), t_(5), t_(6));
> +
> +       for (i = 0; i < nr_pages; ++i) {
> +               char expected = i == test_page ? t_(6) : i_(4);
> +
> +               test_shared(t, i, expected, i_(7), i_(8));
> +       }
> +
> +#undef t_
> +#undef i_
> +#undef combine
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

