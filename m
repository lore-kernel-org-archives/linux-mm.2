Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9194CDB47F
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 08:47:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE13C6B0095; Thu, 25 Jun 2026 04:47:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB8426B0096; Thu, 25 Jun 2026 04:47:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 981E26B0098; Thu, 25 Jun 2026 04:47:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 70E4A6B0095
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 04:47:38 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EFE178FC9E
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 08:47:37 +0000 (UTC)
X-FDA: 84917806554.19.45E3253
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0FD4C14000B
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 08:47:35 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=AB6QFmYk;
	spf=pass (imf23.hostedemail.com: domain of tabba@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782377256;
	b=EOGO8010pgKQaWU9TVEDy25TS8GRWb06VLaIQhwr/K3Ei+zG69lLdzDx1bFaXWoTLo7a0A
	TC+87AacN97qjYQ8XNBTAoyKavFtPPzOwuIAqmtDZNi+axoBdPfHfrhI5ev+7tEKg/Yrsb
	fzKlKAW1hTJP79Eo5LvQUlYx8TJxCDc=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782377256;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L1P9iL5yW4BU9W6Dd1onnqzvZzuIUKT6XldZibc3Vyw=;
	b=Ri+nY1KuNLwJxvXs2eZkGvXDuRj1YHXDnEaOF031YXyB7ydNxL5/fNE0z/ybSBkHnk2ZZI
	qId+mAOk/NScHiQX6oVoV7S2Rrgoyd7o+CoFFYJ6XtybdkPxY7luoKZWgkckUOrfvLOcF0
	VY9XiNxvQGle8ieBEVSHCiquiQYpRjk=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=AB6QFmYk;
	spf=pass (imf23.hostedemail.com: domain of tabba@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-51765331535so153731cf.1
        for <linux-mm@kvack.org>; Thu, 25 Jun 2026 01:47:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782377255; cv=none;
        d=google.com; s=arc-20260327;
        b=q6C6vsbi2X5gKz86ftzBZi6OGGXqVVYc399BpglmvoB0kKmD++tfdCes2UbISexPgZ
         2j2s19PtD0qLzF0+majzPGWVQy9TNS7lFxlEjtD5se8f7jkBpnAMMUHw3PMwXMiVIxWe
         WmUl8ldaxIFh7oQu2mciGutGi8UlHZUEQ+R7Ty0y11ZBSeRqzIW05uPDa0031ag1krFY
         TS7PrEmIyPmP7piszhc2g2seAt4rCQXhUUUyD7vhzXSwbqVt2N3g7H8vsCmcdFQXFcZ9
         rHWqALTDXuHaxSc2Ab5pCO8ZmfAMjggs5R1Y7c+sK/hE+v4/zpSSPXlYsQwV489Gtvrf
         nY2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=L1P9iL5yW4BU9W6Dd1onnqzvZzuIUKT6XldZibc3Vyw=;
        fh=OPvqzZRYA6Pk2CcjmW+GYdszV5azx3qHDJH3bn4AFAw=;
        b=J3XNk7L3hip0fuZusJ+YT9XYSxY5TKXcVoVO5Ddi2WkpG4a08n/4sp27ZAbMx9BC2h
         buy5YE89s+0SSC5aPpX5i4mkd29G3JveLj3u2sE0vncwWcwqqAJUTAa0F+fhQSx3P2vA
         T31URzV4DOBFV78SXTDU5c24OhmGCtL87+44RJhgBwDUGICv6TNe3V4ekE1mMPxukVZy
         /rUdnebWeqW5tJEuphKYzs9XhxB1VB9zOe0FuxO23kZo1QwJNQC3PGIpH8D/V49FSjLK
         rfaA3FwFHVu78aGqg1bo4cMYNg4TykRdz6mGL2jq6KjKQeTdMs0graVWLehMip84eGVs
         gR9Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782377255; x=1782982055; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=L1P9iL5yW4BU9W6Dd1onnqzvZzuIUKT6XldZibc3Vyw=;
        b=AB6QFmYk9m4/5ZTPuqjD4qg34c+SYPCpehSvx2DSpF1ODN3uOHhUh3XNqFqTezEJ6g
         TDJKmqLialbfL3mC92CIc2RHN+5pYHXt+eENlR6CHT2khWquHSwYXmxHtSaiPXco33ir
         MjUskjAsbbe/NfEM05/rsQy6u8b0EgL/vMOuSHEE0/7t6u266W5GT3R73pzacGIuNVEt
         U93sZInXcvRQynN+Gzhb69BPnFyPek4d5EoQkEz4idO3iAbd5ADBPsAfK/YuFZn+XqaQ
         jp6SPQfcOygT2ABJx11vh+2eyf/HWV2m4MFwWu4nzmFTgGa7MuQYywM6aklvkCe8xc0n
         lvug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782377255; x=1782982055;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=L1P9iL5yW4BU9W6Dd1onnqzvZzuIUKT6XldZibc3Vyw=;
        b=PozO1wFJtBN86aj78D37Gw7OMatsW6jT34ITkfqvu63iUVgWfyYEUnBzh2nMUtZ9iZ
         nCjghvjMAegEz3sQUU1c1D9VyQdMelb5LNrzzV46nKqt9wayXRYng82cL86EGF903B4+
         i3x33F8ya0Z2UdQDHtp4fRqeJJbkhwLuUgi11bMIIxrsCtuBpSkD8+CWWXJYcnJwDgAZ
         EismwNJJyQJv2go7/xbFjR+pWbllTLW6NaNwmV0Uf3IWJyrFmynz7axkdx92ofx1PXV2
         ksF69jFTRNSK5vyEl3qu3cbeX2Xa7teiDEZdKx1majMgdO2zxfEafQsPUXPJidxB2Cnz
         3Vgg==
X-Forwarded-Encrypted: i=1; AFNElJ8FgPdCo7Ntp85tgVIIOM9eZoNbPxjiMaqVwBJ108E2PbuSGU5TBoLIzWa9DuDtRCKHlvXdflBfZQ==@kvack.org
X-Gm-Message-State: AOJu0YxF4kZfrOP8+CCce4oc2FM6lBNfe8H765m7FOqMne2IUJUKwulW
	CkQvXaws63iOhOn/qSEUP+yB1sJA/i7NzgM7eCEb5qSIZeVOutMdjBAv3nLoE8eCHmW71sZTAL6
	jH7I9x4ogAKTMXRC0voe/ylHs2SyhJ/EXiH2WVZsm
X-Gm-Gg: AfdE7clfpEQFSPu2PGhczGvtdHlqrk4akl9PWYCqoZ+lgY9YliNR0fBbOvKyHINs/66
	8LK5zgdGPI2UWuczgswh8PJZqnRLVKyYpgEhycZSqbYGcmT6T6H+aMJPTEptc1YL7Q9L8hsl+NK
	f3lzJiaG6wQX//EggPGhyVT6+SH8LZXhpv0r/JQkPSIhEhB/QTbkZ2Fem29l62DQl/yyZW44HJ2
	r3WlnPMbfdZNQSK/aRZpLjfGANswOw+uEEJ5fT9EQ1RGL/44G/NOwy6Hb0S+ByP2CV3sBoV2z42
	XuG32+Mc
X-Received: by 2002:a05:622a:250c:b0:516:d25f:f038 with SMTP id
 d75a77b69052e-51a6e9b48c8mr8613301cf.10.1782377254458; Thu, 25 Jun 2026
 01:47:34 -0700 (PDT)
MIME-Version: 1.0
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com> <20260618-gmem-inplace-conversion-v8-40-9d2959357853@google.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-40-9d2959357853@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 25 Jun 2026 09:46:57 +0100
X-Gm-Features: AVVi8CfgbrnQMIfXiVsNJJJ0xVsuAP4drBRXl96LSWEK0lsp_b9ZqLBB6cNHuVM
Message-ID: <CA+EHjTxw-28BpsSbPTyuhBEMSzzJa=AWMtrT6Bw=3P+SfBKvLA@mail.gmail.com>
Subject: Re: [PATCH v8 40/46] KVM: selftests: Reset shared memory after hole-punching
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
X-Stat-Signature: fhs8rn4u5mmad7uep5utzuuaysxyqf4e
X-Rspam-User: 
X-Rspamd-Queue-Id: 0FD4C14000B
X-Rspamd-Server: rspam02
X-HE-Tag: 1782377255-790094
X-HE-Meta: U2FsdGVkX18BpimHV0lHMMfnd2EmVLbiHjovlF7hKR76Hdkqvt+VsHNmlMeCL4yThDuM3ftvgo8wyO/r5zH8Bk3YvEaui13mnTmgA2VPpio0RvN4U3vx0iXS0CS75brLd5fC/HvFGy3NyYWFoJzfPRIJrCeAMvdVXXHCahIwQ+buDGLNcw1An+1Y6HXF5vfeeYr+N36Fa13gh+/WDPrVTS4DfLXdDEKKvdopYh3wVtZLtd6Njaq4v/oYx+l3SGUwDIx1z/sc6SMNmrfCev1TlGl5qCBIrLzfxzBKnA+9DOqFqZxOsEjDOrH010QpGGM3++fCEDS0NIWB9RSJT7ZRnIKLoamuKdz3xtP8oM+R5dlStiQXZiAj9t+abfCROtKBatIfKC1zTHkzfryE7a6Z6w2vxAbCy+iVJzVlUwuiD+R5z/V4NuOa0YoHioCtwehW/GiekZiO2f5/guh87buH0ZazQaQ2ZZbf0DcSSTTw9p3hvNxdnwdRGW2/XP9Y7DW4fd31i7RlyGianOokg+EHNROqDHXu+n1IsnmUFerewjwYpOwaiuk5x6oeGKdBoL3uSNoV90UbBla3A2h1/MEf3GueoIPoCWXAdTDMopFvYiqCG6UpsXbwA8NINw9xrnLj/FHcyHcUJg5BIWOYqq7q0NoghBnrwYHv8fcUBNFF+BXbroBKPEJla3iYFzkms2g5Shai0es44G4M3KJDrTXFlLsSaVr//qZsKIajtc8TuC+V95NlGPii3SVvwRzB7aeAQ8Pv1JDo+zzjghL3GFP+mOI7L+C/kPHsR3yPjtoyiMN4V7lq1xxupjyNSXTL32p/qv8O9gaU8zsVS4z9HvwsdymCBrNMaejUTdBhF1v8WfppCUE4+wRrxTeX9Z8jo9SDfIahtKugYlz8iXVTQcGAAc4el79Y0dEKcuTlag22exKHX0b17vTv3wj8IGq1NuBGuiggQHNf2JZWXpDTCTt
 Xt6DmkOj
 Yp1b16lbMEA1N9fy0H3S7TVNEdLOVAsV9yQshr9VzifmeIScA0YtzGBVa3saqieGjg64CYByxs3+PdB2LRt4PmcHy5WcsBk4+wpIFed7a4OpqCk0fz0cp11DIfQESXn+f5BHYGiDNHu7PL+GmYXB8dVOcGnsHcstsVroPwze5m0oIdHpAxRtV+0B+jV8GPKJIJ1+Y5ew1XOV0OvLJZKbAK+JbkDAemda0RIrhlaPNQBfJi38C7eyU+qwsLDx6lHGAsiDKrqDxytS6/jkcrj6hNL98+b65URjRj1O4
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
> private_mem_conversions_test used to reset the shared memory that was used
> for the test to an initial pattern at the end of each test iteration. Then,
> it would punch out the pages, which would zero memory.
>
> Without in-place conversion, the resetting would write shared memory, and
> hole-punching will zero private memory, hence resetting the test to the
> state at the beginning of the for loop.
>
> With in-place conversion, resetting writes memory as shared, and
> hole-punching zeroes the same physical memory, hence undoing the reset
> done before the hole punch.
>
> Move the resetting after the hole-punching, and reset the entire
> PER_CPU_DATA_SIZE instead of just the tested range.
>
> With in-place conversion, this zeroes and then resets the same physical
> memory. Without in-place conversion, the private memory is zeroed, and the
> shared memory is reset to init_p.
>
> This is sufficient since at each test stage, the memory is assumed to start
> as shared, and private memory is always assumed to start zeroed. Conversion
> zeroes memory, so the future test stages will work as expected.
>
> Fixes: 43f623f350ce1 ("KVM: selftests: Add x86-only selftest for private memory conversions")
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

> ---
>  tools/testing/selftests/kvm/x86/private_mem_conversions_test.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
> index 861baff201e78..289ad10063fca 100644
> --- a/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
> +++ b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
> @@ -202,15 +202,18 @@ static void guest_test_explicit_conversion(u64 base_gpa, bool do_fallocate)
>                 guest_sync_shared(gpa, size, p3, p4);
>                 memcmp_g(gpa, p4, size);
>
> -               /* Reset the shared memory back to the initial pattern. */
> -               memset((void *)gpa, init_p, size);
> -
>                 /*
>                  * Free (via PUNCH_HOLE) *all* private memory so that the next
>                  * iteration starts from a clean slate, e.g. with respect to
>                  * whether or not there are pages/folios in guest_mem.
>                  */
>                 guest_map_shared(base_gpa, PER_CPU_DATA_SIZE, true);
> +
> +               /*
> +                * Hole-punching above zeroed private memory. Reset shared
> +                * memory in preparation for the next GUEST_STAGE.
> +                */
> +               memset((void *)base_gpa, init_p, PER_CPU_DATA_SIZE);
>         }
>  }
>
>
> --
> 2.55.0.rc0.738.g0c8ab3ebcc-goog
>
>

