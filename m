Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49E17CD5BD1
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 01:50:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CAD66B0005; Thu, 28 May 2026 21:50:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 354776B0088; Thu, 28 May 2026 21:50:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21C0D6B008A; Thu, 28 May 2026 21:50:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0C8E76B0005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 21:50:43 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A83E01C0CFA
	for <linux-mm@kvack.org>; Fri, 29 May 2026 01:50:42 +0000 (UTC)
X-FDA: 84818778324.22.34679C4
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf03.hostedemail.com (Postfix) with ESMTP id D7DFC20004
	for <linux-mm@kvack.org>; Fri, 29 May 2026 01:50:40 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Tnn4D1AZ;
	spf=pass (imf03.hostedemail.com: domain of wyihan@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=wyihan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780019440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m9cgyM3T45VB0R0AJ+i6AIRCS6VXeh3YG0DOWXJUVS8=;
	b=OW7cZiW0MioyWe7AGTpjQFi/1ykgn8+jAAisOJpRvQ4yPG0799Nqgwzo4jmj8U7upt6ylR
	AjISuYULp1ElPj5q4AFhl0QMA6MA8S3/htfKlwZad6E2kis6pyhi6tKUmJ9IRu4AGZPetP
	TOC2ngHx+jmYRm40Q7tbns8AZpZyF0c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780019440; a=rsa-sha256;
	cv=none;
	b=ZflPAULqKQlr39bQ/zxiTYex6ZeaMAUsdVNrKJZZdmlngIIz685I5wGNejxZ3u+hk2yNxb
	qPmqLJCwsUgI4jwgLPRGcmD19wbQ16+jbmGYRVKVLj27ZTGJxjCvUk0fH9liW/evTZUVfk
	17xz85TJIL1iM7bZChpV6DuMlnyVYdo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Tnn4D1AZ;
	spf=pass (imf03.hostedemail.com: domain of wyihan@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=wyihan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2bf22c18ad3so755ad.0
        for <linux-mm@kvack.org>; Thu, 28 May 2026 18:50:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780019440; x=1780624240; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=m9cgyM3T45VB0R0AJ+i6AIRCS6VXeh3YG0DOWXJUVS8=;
        b=Tnn4D1AZx62cv3lYfR/n0f1nR8LPbP8QhCf+juKaS4ZzwjsQzdRmJyFvpFDT33sy+T
         IKxTiKK8u15LPNa5JPv7hg7bWG6zaw3QHh3kNf+/EwYlnpN00cHw9ggF+wfxTqb7Q2o5
         LW6WjPr/7uj/dArK3kXxHWqHipIoQQ1oR5F6Fo1/WWJDcTewL/2JZXKhO1Jq5MkKpmcl
         yWywNLhxoetonyz2ymHelJezON5buoSTLfnrGOd34fZCb29a6AKHx0LBR5X8CprCX1Oh
         5hM1YD9DkEHx0rNo60YMaTxCbka9ssLN1H+E2oV31rWgqNb8LMJvZfYnALt5gNoS2AUm
         VcLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780019440; x=1780624240;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m9cgyM3T45VB0R0AJ+i6AIRCS6VXeh3YG0DOWXJUVS8=;
        b=ZvLZOzKnpkZR290j6706Iero8iGfQt4CwfAhfu6QtMx3lX+eZy1n2qqhx29lY7n3Q1
         9uV2bW5VCDbLgdMB6aAk6NzdxhnpeX7lI4YgO+KOuoX2/AAGXy6Rpq/VTmshtXYWzrg5
         yb7AHYHgCxk+pCHOOLR57Oo/HlGnR4kC3iPJswPxvYS2F07iA7dLOypcBfUiCpmvuH0F
         efJz+opn1MzjZIK/wrRhN17ZvZRLIDoCs1jqZuchaztjYshN6Ra+fdjEeN3GTK9nOtqq
         byhWpId/pMEzG05QS8ECvRRB07iIC9GKoxa7fe9zYnEEzCheVZZGmL9i4XM0dpMEG/Bd
         7ekQ==
X-Forwarded-Encrypted: i=1; AFNElJ99ypZ0SRu3NjM5HHbNo5y1x3CYMhIJF7GDB+XV9aQgWqGm0AiBeGzItiZcHgCvdQ5Xu4uGgwa3SQ==@kvack.org
X-Gm-Message-State: AOJu0YzQXvjb7gDQ2V9JXC4W/fIQZVWc9766P5Ajl4TJe0a5BV8GlBg3
	ajc6ZMovnYrGWo58dF/PCYAQPYQ6mSERJNQbHCdozwKEtobs+ByQjmyLwyVhsGaDZw==
X-Gm-Gg: Acq92OGzax6dFs0eWNUOJBuPcZilFRBmShpdDOzWv7PrWWTSD12WiUty+2awBSxS3XL
	/zl2iqEzPKujDGyHG71CvKez7z9lOtMk09Zt06DnL0Ya/00adHJq9ie+6y0MSOeRAifno8qxiHj
	pjY4zfo3w7bzpDSd0xxFYfjsyU3S2GAuNAkDO+9G+SeqmU5oWsMROrP1WeHJJISO7d+TKxvlJF6
	8eOyiEXJ9QBQASoLYrRfnui8C35NrvkZRXvCTGoQF2q8zcp8atyOH++pFSdrt68MSjS2Q/TShUk
	XOHGgc3DS1+GuXnWgcjFHm32zYDtI+3l/p/eK/fGfMmKCMDp6evrdmatyrMDwbLoD8FhPH5dATF
	Xv8nTm8yj5+tTCs0lEFA4NodNmU6p6v32sTXUIYB443ZwtEU5zwyQiGZoFJjTPBC3WlV7nqjI20
	C2/F5Dq8Jy0xRocaxWeBOkATwSW1GjwsrL80g6o+SWhsu+wVEHiTd/vdKECGB+W/YknvI=
X-Received: by 2002:a17:903:2f87:b0:2bd:7e8e:ad56 with SMTP id d9443c01a7336-2bf20bb1260mr880215ad.6.1780019438855;
        Thu, 28 May 2026 18:50:38 -0700 (PDT)
Received: from google.com (230.0.127.34.bc.googleusercontent.com. [34.127.0.230])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84214b000ebsm103770b3a.11.2026.05.28.18.50.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2026 18:50:38 -0700 (PDT)
Date: Fri, 29 May 2026 01:50:34 +0000
From: Lisa Wang <wyihan@google.com>
To: Miaohe Lin <linmiaohe@huawei.com>
Cc: rientjes@google.com, seanjc@google.com, ackerleytng@google.com,
	vannapurve@google.com, michael.roth@amd.com, jiaqiyan@google.com,
	tabba@google.com, dave.hansen@linux.intel.com,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH RFC v2 6/7] KVM: selftests: Add memory failure tests in
 guest_memfd_test
Message-ID: <ahjw6l7uznZ2bYfz@google.com>
References: <20260319-memory-failure-mf-delayed-fix-rfc-v2-v2-0-92c596402a7a@google.com>
 <20260319-memory-failure-mf-delayed-fix-rfc-v2-v2-6-92c596402a7a@google.com>
 <149c954e-dfe1-6bdd-295c-792642a9d915@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <149c954e-dfe1-6bdd-295c-792642a9d915@huawei.com>
X-Rspamd-Server: rspam11
X-Stat-Signature: i345mg8d65dthe8irmfm8rw347osrfij
X-Rspamd-Queue-Id: D7DFC20004
X-Rspam-User: 
X-HE-Tag: 1780019440-455926
X-HE-Meta: U2FsdGVkX1/kyOpPhDuozDxN6kpl+F1hnyhU2Y+HaNmHsmSRjLatr6uwJdTYjCy2VhawjTekmxWHlE+IghMFiH/ASVMbLYUkFwPfptqAmq27yB/2Y+BgCxjLjMRaT0tyX+KJKfvxBMrxBBrkfFuPXZLJ9qsbqkAD1+PJy9NMqeI5o/eA6vRGu+ceUg0jHdznG6IUpn0k1YP6CIYZW0f9OPWgxM2tKn8YHQEMyMD7C07fVOL/htMiw0qJxQAPmc8inKHA8grU088yJOA261tf08BV949iAoFtghbxS2rwfiQ3sWqYHX5sqSYaztKj/XPgZ5pJN2W5OxBqwGC4fIKwZoyTgzADxb7uEFDPi+v3yFXwsRShUgxPMvDsLCJJ7H0ElWQVj6ApZR4JXO0QO12Z+Z60ADHPy1G67MZ2tMj0gT5hExhRTu+LRaGtn5rE+0Zl+ZSIgN97V0zB+FWK27kqs0yudW6xXv/NrejtwFRe3FufXSr2syB5heL3Vb86qs62jQyjNCh+LX7xCjF7Sh/gV9Wk8AS8SNP7781BPrlvTlNU62j0zO7N/63ryMpj9AWWIkMswNpmDPAsAlGiJbUzYQ8JEWL3BGEmVAl2xw9cyi1GSdVMmhjKZ1B46elTa9g8f+75AnAAlS1lcz/Jkv/rm2Lr0Ow1KgmJpPKT7fFug10lWekaaqmQrSF24BIUMhzdiMEjqRijlFjBqPtfoSeLnTzMGSATGj9dFvcUdVDFssM/09dAybTNEHkzkcJQwXOVZQVmkrps8Xg54wEiPcddiuTJmtyMA8TBEsQ5eqzXuxeLUSYAtdoJYw6uIGk+KIG/XBBj1a0lKkZ0IBjsvEfKhTHdbSInwbOLZlr+QQaZQqhuisIinSwAiSEjbW7xf8C70dc1u5Qj0RD5nkfjEz3hzs+4MFxCxb0d0FBTz7UeuB2tkWKM33xOUxtwitDyCHvmiUcXUGWjvn308usK8+7
 iTYkNRhR
 dyJ3ave3wxxcrbwwGpyNoAAVjrUuvoz8TnuK4NsX3Z17yq3EXuORuOjXUxWoM1y64bsbeK5tD5LMr+PFEKNZ3Nz680PdpFW2Iy6bonf7740obOaUqmm/fq27DK6u+Nr51M3HVQo9btDGsoO3vJQ4dksq20z50kfrlCQkIGz7phxbMygxUrrouZAn0VKiIhOagnD2uWdrbdsf/8mxa5SReXpxNd/2uEd6yPUJI0VLZt3Af7dBtYlzPaI4gJbILN1gL4jhJfyGhZPUH77fn04/DDlBjOcl51f0QIezYWV35XGJZAvyvVldyTPBYcMd5zbBAaNm+XdcMx2kUcvpSVSwbwSzlzROLwIraFzvpwLrysYuuDdiZ/ScVKaXINhR7dpO+1kLzOLZjclE6wvyd2BRnYGXNCxUoLykTkToYWX6o4gqS+PtciW+UUgKceML8QtSTG7e4/8h7ddys7wl2bIH7Cog7/g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 30, 2026 at 03:20:15PM +0800, Miaohe Lin wrote:
> On 2026/3/20 7:30, Lisa Wang wrote:
> > After modifying truncate_error_folio(), we expect memory_failure() will
> > return 0 instead of MF_FAILED. Also, we want to make sure memory_failure()
> > signaling function is same.
> > 
> > Test that memory_failure() returns 0 for guest_memfd, where
> > .error_remove_folio() is handled by not actually truncating, and returning
> > MF_DELAYED.
> > 
> > In addition, test that SIGBUS signaling behavior is not changed before
> > and after this modification.
> > 
> > There are two kinds of guest memory failure injections - madvise or
> > debugfs. When memory failure is injected using madvise, the
> > MF_ACTION_REQUIRED flag is set, and the page is mapped and dirty, the
> > process should get a SIGBUS. When memory is failure is injected using
> > debugfs, the KILL_EARLY machine check memory corruption kill policy is
> > set, and the page is mapped and dirty, the process should get a SIGBUS.
> > 
> > Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> > Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> > Signed-off-by: Lisa Wang <wyihan@google.com>
> 
> Should we add a testcase for hugetlbfs? It seems hugetlbfs_error_remove_folio() behaves same as shmem.

I agree that it would be more consistent to modify
hugetlbfs_error_remove_folio() to return MF_DELAYED and update
me_huge_page() to align with me_pagecache_clean().

However, I prefer to let this patch series focus on the
me_pagecache_clean() path (affecting shmem, guest_memfd and generic
pagecache), because the hugepage memory failure test is not working now
(hugetlb-read-hwpoison.c). Commit 66802526298e changed madvise()
behavior to always force-deliver a SIGBUS to the calling process if it
has the poisoned dirty page mapped. Aligning HugeTLB would require us to
fix this part together.

To keep this series focused, I would like to handle the HugeTLB
alignment in the follow-up series. Would you be okay with this approach?

> Thanks.
> .

