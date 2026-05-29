Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22E65CD6E43
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 01:19:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBE2A6B0005; Thu, 28 May 2026 21:19:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E967C6B0088; Thu, 28 May 2026 21:19:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DABD96B008A; Thu, 28 May 2026 21:19:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CB0B06B0005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 21:19:44 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 24A0E95557
	for <linux-mm@kvack.org>; Fri, 29 May 2026 01:19:44 +0000 (UTC)
X-FDA: 84818700288.06.7D4C084
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7266FA0005
	for <linux-mm@kvack.org>; Fri, 29 May 2026 01:19:42 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nLzj7OCG;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780017582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ozq/Ru3FRyhUKHioj+TdgdTtFgDpQkgRBP9R3Cod/9Y=;
	b=BZHWYMOJ/wOVG5cY+aSlWfVyhDLZ/AYRYT1s7EtdcbIeJHvfsU8qF2+NrhCVsr0wy8u8kx
	FCp2gF02+yA8JJVmIX0NrL+nXrYXEWTHEcab5SbrbZu+KatWBPqEL2YaLuBNTqIiHLN9cd
	RGsveIPBYWimFugtEx5erNcl+bC4h4U=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nLzj7OCG;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780017582; a=rsa-sha256;
	cv=none;
	b=LWs97mkCLB5ancnfLL5jbUxme52rPdY/c46lP3O7jbhLL2QcA7BcYUU5UinX0Wg/s3sIHD
	Mqa7Pz7G+Q4uNrP1czFt9E1hgIJH7zqEupN0momDfkyK6ht7XGrZwiLbdKX4YhLFP8Xfua
	2G4xbQ2eI8RdUZ3f69zsoB8IAQ//1V8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4D70943F42;
	Fri, 29 May 2026 01:19:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1AE21F000E9;
	Fri, 29 May 2026 01:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780017581;
	bh=Ozq/Ru3FRyhUKHioj+TdgdTtFgDpQkgRBP9R3Cod/9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nLzj7OCGbAYQphViYclXtHITMmaEevm6G40K5z5oGF8OxchRHxEKKiPboc7ARFeiq
	 E1aWmqls8XpEIW6+93ygxdQGIXL8Q3EjpR/7xVLB710yIvO6tcTx/KKn/wAc24xA/X
	 aEq1Yv9XwNS5lbmC1lexYYQDitbtWDngkVPHuUYbjpsuscfMfP5YssJ60G/ZzVSFYv
	 GMF4sAAQO96eKev9xxg6btXLcKm8b5oGv4CzFzICSsALDvTntxaScC/kNvmBua7NUz
	 RJDFb4/OeQx7kYsv9aD/BiNTS9Ar5294YKFIq/uV+B7z4ijcE2KS6aRrt4W+WAIob2
	 zz7a/yt8o2Xyw==
From: SeongJae Park <sj@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	rppt@kernel.org,
	peterx@redhat.com,
	david@kernel.org,
	ljs@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	Liam.Howlett@oracle.com,
	ziy@nvidia.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	seanjc@google.com,
	pbonzini@redhat.com,
	jthoughton@google.com,
	aarcange@redhat.com,
	usama.arif@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kvm@vger.kernel.org,
	kernel-team@meta.com,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: Re: [PATCH v5 09/18] mm: add MM_CP_UFFD_RWP change_protection() flag
Date: Thu, 28 May 2026 18:19:34 -0700
Message-ID: <20260529011935.8433-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260526130509.2748441-10-kirill@shutemov.name>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: xscnb3xubcoefsi69b9emksezfdbz8o6
X-Rspam-User: 
X-Rspamd-Queue-Id: 7266FA0005
X-HE-Tag: 1780017582-887657
X-HE-Meta: U2FsdGVkX19Ocw39HTCrmWBWfp+UM1o+d45IYkl8aAHq3RahXuHCJH/OLv01biw74lllyu+5iulfSfvW7n6CHrcz2+ZLGpNp4/NyoTD6NDrQuoit3T/VNfan7yRtgp80R6ckg31Ag33EHfMZe/vtO06LgMoguGLbAmOPtX3wrrhqB4PaRLQ8d9k+8fyaTg0TC3WI5E8BTbntXNzy13ESBItuzqZggKelIF7Mj98Em/7yZfJW9lpYIXHG5wfYE2/MEQnIMC8U0BnQu6KjMkcBRFLieKpA5iLBEwhQ615zMdLA3ebAE0q7cL14Trzg6pAfb25vb3A0/WoGBar4mcqCWm/i5hFayQJPLUnfrlAtChBFXNyzVKx8m4GZlGXNdonsTFu/ShVyzKWSCyz4k1DNLsnVo5Re5LRyJ+wtlA8LoDUCQvrGwMy+EiXgBpBhfW7+Zt9aDm5IQOT/9A6T0iUeVTRxRbt5WKPtYgeI+IKDE0SCOdQFCgwm+Av3tlAPVvVVQim7lnLHoz7ALOGwDFwqGjhlW+QQYxfbgPay3+VKg7OYRqWxqzfoxytQyeQzdWM/XyMB8KRPMr2Xzzfn4zqUNeVfdWI6cEYxpXB0FKAxt140WEA7Vf26y35QZYTDd9Au2ewwi3Kgah5Yi+gHGGRoRbHnw7lFoiGrwYhg8Xx+Sp9B9bkeFeUh5kzohIa2YjlsqubG/43cXOuOjKlApelkTplP/35pLXhPmAy+Yf2U02Fid/vFOUQghtgJpvNnxArtjNXvNwBwfVshe4diy/PqBLmjhxMZ7jxTtOdX82OOK2beW+pRBOt7Ejwv+DKRpd/fM06SClzzXq20cMa4sHqQLErRL4te++uK/n9Ut6CYrslHc0XXRHB+lJtwTMGlfLeg+PMdWYk+O2FbHJjypvgPqk8ea8l1U9tMPYyN0R7oiSlY/ag+eC0A1ATQTqT8hk+pVNvYC3sgJ6Fi37IT0Bp
 3wt2Y/m7
 lv6bBANAKGuokoHb0vXPmcT0X4jZ/Vq0UWkUdYqjPdLYoxsPA6P+6MHxT0zAKyqXPTy3W2QjSOHcBfsrEzXvnYyOm49VmOPMXtOm3+dLyEGNp/3/jTwC2psDDqyfypb5PwVMzytSUmy/PeA/x4f4lHYhrlfkv0jGG5HbSzn1SFFmRrRSyng3Kxl57pOEolZ1QvABpZCdtmNoTKhhO66+ZsGCvhOQMp5mv4uAVrXH/IaLswXr30N4Au5F28+vtuaGW98nJ2GjwJmCuHXHnakP8pDGjhinQjfUfktmX0rpBL5TGMM3lI2kN6AuYI6au/RRL6YpgABygeyk6cdA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 26 May 2026 14:04:57 +0100 Kiryl Shutsemau <kirill@shutemov.name> wrote:

> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> Preparatory patch. Add the change_protection() primitive that
> userfaultfd RWP will use.
> 
> An RWP-protected PTE is PAGE_NONE with the uffd PTE bit set. The
> PROT_NONE half makes the CPU fault on any access; the uffd bit
> distinguishes an RWP fault from a plain mprotect(PROT_NONE) or NUMA
> hinting fault. MM_CP_UFFD_WP and MM_CP_UFFD_RWP share the same PTE
> bit, so the two cannot be used together on the same range.
> 
> Two new change_protection() flags:
> 
>   MM_CP_UFFD_RWP            install PAGE_NONE and set the uffd bit
>   MM_CP_UFFD_RWP_RESOLVE    restore vma->vm_page_prot, clear the uffd bit
> 
> Both are wired through change_pte_range(), change_huge_pmd(), and
> hugetlb_change_protection() so anon, shmem, THP, and hugetlb all
> share the same semantics.
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> Assisted-by: Claude:claude-opus-4-6
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Reviewed-by: SeongJae Park <sj@kernel.org>

> ---
>  include/linux/mm.h            |  5 ++++
>  include/linux/userfaultfd_k.h |  1 -
>  mm/huge_memory.c              | 30 +++++++++++++----------
>  mm/hugetlb.c                  | 25 ++++++++++++++-----
>  mm/mprotect.c                 | 46 +++++++++++++++++++++++++++--------
>  5 files changed, 77 insertions(+), 30 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 6499cfb61dc4..f79801816f32 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -3297,6 +3297,11 @@ int get_cmdline(struct task_struct *task, char *buffer, int buflen);
>  #define  MM_CP_UFFD_WP_RESOLVE             (1UL << 3) /* Resolve wp */
>  #define  MM_CP_UFFD_WP_ALL                 (MM_CP_UFFD_WP | \
>  					    MM_CP_UFFD_WP_RESOLVE)
> +/* Whether this change is for uffd RWP */
> +#define  MM_CP_UFFD_RWP                    (1UL << 4) /* do rwp */
> +#define  MM_CP_UFFD_RWP_RESOLVE            (1UL << 5) /* resolve rwp */
> +#define  MM_CP_UFFD_RWP_ALL                (MM_CP_UFFD_RWP | \
> +					    MM_CP_UFFD_RWP_RESOLVE)
>  
>  bool can_change_pte_writable(struct vm_area_struct *vma, unsigned long addr,
>  			     pte_t pte);
> diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
> index 0aef628514df..564eb2aac321 100644
> --- a/include/linux/userfaultfd_k.h
> +++ b/include/linux/userfaultfd_k.h
> @@ -361,7 +361,6 @@ static inline bool userfaultfd_huge_pmd_wp(struct vm_area_struct *vma,
>  	return false;
>  }
>  
> -

Nice cleanup.


Thanks,
SJ

[...]

