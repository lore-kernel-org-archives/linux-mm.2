Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6736C79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 12:16:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3FC66B0095; Thu, 10 Sep 2026 08:16:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEFC16B0098; Thu, 10 Sep 2026 08:16:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADF236B0099; Thu, 10 Sep 2026 08:16:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 888666B0095
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 08:16:24 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2118D1604F4
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:16:24 +0000 (UTC)
X-FDA: 85197750288.18.3B7ACBF
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4178040008
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:16:22 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=rKBqZ8tB;
	spf=pass (imf07.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789042582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Js6Gt5g3o4scdYC3c+lYfMm1cuutEFMaoS+QMAyzj3s=;
	b=1lXE8rtvD+ftoDUqD86wBTWyLIpqhhlnxk0T7U2qgrDrONDcyuf4hT+k4TsjdZ9n9OVR/j
	+t5GZzrAJAGjlsnw3eHphn1qM9NzMat7ibEZkDUC0n7K8Tr78oZ32WhUrbXgV77H9nDXII
	SvX+KB7IxCRgId1LV06ppFce+4kG4DY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=rKBqZ8tB;
	spf=pass (imf07.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789042582;
	b=a0nsC160odMJe8Uxrc375K5J1hAklmjkLlaYnHTzFrOpsdMcf2lKJ02mvOhU+55iArMhcC
	txjCAWGLLW273i+9bvKvWTS+WvD5keqACRi/h9kcTfVXQYYgMicOV5B62609Vh1CnWE6jv
	x5PIaNin1m7d/3qPVh3zA9MhdJeZVWk=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 66177153B;
	Thu, 10 Sep 2026 05:16:17 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 93A343F7B4;
	Thu, 10 Sep 2026 05:16:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789042581; bh=WsjDDm3IHVIayP7lqsvN5IGMpOV0o7Dhan6Mz0Czqww=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rKBqZ8tBO5UMrN0IrTub/1n8Lwwds74nfqPxQ/OQ/OabGnJSIsqQmXDGZWavGtMEs
	 es+6uRxF9Hu4TaVVFyKAjUUjpjjLo8L+5dgrNO1/ek96yTDDYkgz+TIHm7wbwpQID6
	 KXjYDpYNpM8zzs5wmDMhPfRjtb04K3Qo6Qw7ohu0=
Date: Thu, 10 Sep 2026 13:16:14 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 3/3] kselftest: mm: introduce alloc_isolated_mem()
Message-ID: <aqKfjqa6ye2AOU5k@e129823.arm.com>
References: <20260907-fix_split-v5-0-822b810458bc@arm.com>
 <20260907-fix_split-v5-3-822b810458bc@arm.com>
 <5c05b620-7a2f-453d-9725-fed4f536a019@kernel.org>
 <aqKOVGECsCNtSMIV@e129823.arm.com>
 <d0b3ea99-e20b-4883-8fa3-67fdbf5b1ee4@kernel.org>
 <aqKS7CP67X4h6NiM@e129823.arm.com>
 <31418d0e-9745-4e8d-bc02-dbbd5cb9e193@kernel.org>
 <aqKU0-Gm4yh78F3V@e129823.arm.com>
 <d6f2e6b2-9dc9-4f02-be37-14329c1a6798@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d6f2e6b2-9dc9-4f02-be37-14329c1a6798@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4178040008
X-Stat-Signature: xhpgidr4rmdipxco7wjetgqa3tg3996p
X-Rspam-User: 
X-HE-Tag: 1789042582-94997
X-HE-Meta: U2FsdGVkX1+TEJQZ9eL9fmcrMBGSKqGupz6FVxWq9It799FeXOG9o/UyHeMdA4ThXFYznaTsQNojfRG6xfzpZE8+u9bM9JXZm+HO0rhW1PK5PSXRcHDqgVh1EXO3i72IDEIN/+5M6op2CcuQETc7H9dKGvcdfq3FnuZ4en1Z3dQ7mob/mkMeXza32g6bcdDTksEotZfAagUIekbEo2dkl3JtQ4x8gJuZS/PUnjgHZFZHL7gI8AUzq6fsbDIPeKYzmUny4H7pqp4k+EX2+bU008sv9euErUZyeRzAdAcDCVTDHLuda/i3PVpDX6qYwoZD6XJCjC7NqfVuh7tq2I+0sv+jGY5pHp0XXXvDG/fYAVp3NDWbE3a8zUgFsO9Xax3RZL6cR4nzd1nGj3vekncBRXOh2dGW/YAwmZAlZkmwLWlvg3VThSQrcAFZp9jVc2f1nJPcUld2xfWmvbiNftOl/wpcasA6zPXmOdw/ZLyI5zO/zDbIqM0AACTrf60CQayXdGm8UUupDpg145JysATfVQJbTvf2UNE97YK3UuCKfJMx+euhN+ZO/yDSEloehBLaOL9eH4EV1DhEKIaSxSUXja/IRnQrOxojXyI6DfoKjKBQ/Pe3E/6E9taMVpdWxzXwMZh+6ULadx+mZf4gYYBtLYREvTFFFutdLvcBDbxMpF+Ti6reMMK5AFXjv4D/R6ltZutoFKE3HPgXDesl+iZZMyxsw8mz7L/YVl9lDYTc8b8OVFebM7XDt6kbWrp+5lmAImTw7l7BUuhkd4CzSwTgd+fpF3WJctjlqQ+cxMvorMvAbq32sk7DHw3TiBo868tOqNlReHMpndt/Z1g418L0SWbA3PM4rR6/BPmLzVud9gLLbKS6ipEOdU9FA4O8rolDAKO5Ry83v6FnTBPcY8NbQAaDsHzgxZdH5pX+g8BYI8j+SsY+EieyCTpO//PlggS35YBfot6FCZ4K4SQVtXd
 kzCKoFPX
 K7l01tlIAeqHTxbkA0/9cpg0Kl6PKjZD2LKcCCvRU88uE1DXSrPwRi4StoDuUw1rzM7F61pv97N2/Jqq3kBRcYxTWhcxZeGOw4CnpJ0wOBL4RkodECA343a2kLs0+90totTPNrNDg64gEpSCF45omuWWN5JANUJXkUZKpA4/mINuXhN+b/ON1JqHYyoURmFlpigMMHpQKtzL1CtVwU1mEcJXRofmLHHLzzw80RBxaXLq4Yu6DjZhxrG+A+a9D0Z3LYGiRE96+lO+Y9nyLSnLSQH69vf7R3iPcfkcmHGlHCE7FD+DAnNeogv02QQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> On 9/10/26 13:30, Yeoreum Yun wrote:
> >> On 9/10/26 13:22, Yeoreum Yun wrote:
> >>>
> >>> As I mentioned in my previous reply, what I’m trying to prevent here is
> >>> a failure when checking, immediately after memory allocation,
> >>> that a specific vm_flag is not set.
> >>>
> >>> Yes, I agree that this could have been a problem even before
> >>> the internal changes to memalign(). An unwanted VMA merge could already
> >>> occur at the time of memory allocation.
> >>>
> >>> So what I’m trying to avoid is a test failure where, due to such an
> >>> unexpected VMA merge during allocation, the subsequent check that
> >>> a specific vm_flag is not present fails.
> >> Which is only a guard-region marker problem?
> > 
> > Yes. so if we remove ASSERT_FALSE(check_vmflag_guard(ptr)), TBH
> > we don't need this patch unless other usage comes up to prevent unwanted
> > VMA merge.
> > 
> > Would it be better to drop ASSERT_FALSE(check_vmflag_guard(ptr)) in
> > guard test?
> 
> I guess there is value in asserting that not all VMAs by accident start
> with an over-indication of maybe having guard pages, which is why Lorenzo
> added that check :)
> 
> But I think even alloc_isolated_mem() is wrong in that regard: if the
> original VMA gets merged, we could inherit the guard-marker, no?

True. I overlooked guard bit is sticky.

> 
> Maybe the following would be good enough?
> 
> diff --git a/tools/testing/selftests/mm/guard-regions.c b/tools/testing/selftests/mm/guard-regions.c
> index 5c8ec3ca75d7d..791bf6a68b9e6 100644
> --- a/tools/testing/selftests/mm/guard-regions.c
> +++ b/tools/testing/selftests/mm/guard-regions.c
> @@ -2257,10 +2257,20 @@ TEST_F(guard_regions, smaps)
>         char *ptr, *ptr2;
>         int i;
> 
> -       /* Map a region. */
> -       ptr = mmap_(self, variant, NULL, 10 * page_size, PROT_READ | PROT_WRITE, 0, 0);
> +       /* Reserve a 10 page region with 1 page space to both sides. */
> +       ptr = mmap_(self, variant, NULL, 12 * page_size, PROT_NONE, 0, 0);
>         ASSERT_NE(ptr, MAP_FAILED);
> 
> +       /* Map a new region that is guaranteed to not get merged in any way. */
> +       ptr = mmap_(self, variant | MAP_FIXED, ptr + pagesize, 10 * page_size,
> +                   PROT_READ | PROT_WRITE, 0, 0);
> +       ASSERT_EQ(ptr, ptr + pagesize);
> +
> +       /* Clean up the excess pages left and right. */
> +       munmap(ptr, pagesize);
> +       munmap(ptr + 11, pagesize);
> +       ptr + = pagesize;
> +
>         /* We shouldn't yet see a guard flag. */
>         ASSERT_FALSE(check_vmflag_guard(ptr));
> 
> -- 
> Cheers,

It's enough but alloc_isolated_mem() could be modified to allocate with
PROT_NONE first and then change the prot.

It seems whether make a helper or testcase should write the code
properly in case of unwanted VMA merge.

IMHO, instead of testcase write them all, it would be better to use
helper (but in guard-region.c, might need to wrapper function, munmap_()
like mmap_()).

-- 
Sincerely,
Yeoreum Yun

