Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0F18103E2FC
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 02:05:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1963B6B0088; Wed, 11 Mar 2026 22:05:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 144AE6B0089; Wed, 11 Mar 2026 22:05:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 050336B008A; Wed, 11 Mar 2026 22:04:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E6D4F6B0088
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 22:04:59 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6CBA41C9FC
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 02:04:59 +0000 (UTC)
X-FDA: 84535767918.05.ED7590E
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf10.hostedemail.com (Postfix) with ESMTP id 72DE2C000A
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 02:04:57 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FfRHNx3V;
	spf=pass (imf10.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773281097;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ynAFUJJtII0mylZNYRwUKR0xXIdbuRFV4B/tKmZAGC8=;
	b=Y3OGNpFDH1J7IWErFnqSv3LjChV6HYmbINJh0HGSYtP2V2Iycah3QZLMQ4Sy67PVu+bbay
	s1eFg4uE42cnXnz7eZ5Y34u6MN5lW4yuLs1s7RpwtZjMo5HC1iYPejd/OYdABX+Bl8ZMse
	uhp7ydKToWJIhixI4sc64RYDb/ce/OY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FfRHNx3V;
	spf=pass (imf10.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773281097; a=rsa-sha256;
	cv=none;
	b=jISqa9PGse/3Jk2MLzrUVSZmMGCgcaZf4hywLdKZWusYY5a00xSXl9CFvNaVoiu8o9WHVa
	d5r29DL+X6arsf4u6Zu3GFudbuKu+dcgQsMZE8BjtMUoKDQVcfNZt+ff1JPJFEezwDFBz/
	y3HdF3KuGMX+aQDVEbIXG6f0iKkFhns=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-48534b59cf3so3930535e9.2
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 19:04:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773281096; x=1773885896; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ynAFUJJtII0mylZNYRwUKR0xXIdbuRFV4B/tKmZAGC8=;
        b=FfRHNx3Vq4RYJMs+5aQviey0DHvORJa/WFLhcjscboPZHThJ+E61owYnfxaPBLz0Bc
         +KobsxgWN4rGAvap/6dHvAKYp3m93NVXwIWWMuI0nDTW5/6R8GYpUfeiAeg4vJkTWGOd
         7gkAQYWM6KpqgtAUBT8mqAnOt+MbIblH/FWfQSci7SQbmTTktlP/ZsiLZ64eYkjD4ltk
         n2BjzURXrnYY0fR9y6cDJLLTr5QFkwrEvRJ8zH0oVspy0i68oK5B5PzavuMdf2WB3Psp
         4bWJ+ynmt13bMZkE2H307vdh4iwHbBOCLnB39CqgyuXG1sg7it4hPf0DL7YtwMn53FgD
         GTZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773281096; x=1773885896;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ynAFUJJtII0mylZNYRwUKR0xXIdbuRFV4B/tKmZAGC8=;
        b=kyIxtRxu/YJCNBUPlKojTrocyo5OG7KwhoMYwiQz+/3TSsK/NyPxbnMzn4Sw+sRDAG
         AAQ2JfZh09LgUQage3qflcEtV6BeNsxT3y59LXg8+jLivWC8DpSP3ZGXviS910lrfM0z
         6PvJjmJe2Hvj/0cQz9pSn9NyzapXOb1V4r4TdfeuyPkJ7WSylKn6gGeSACr3vjjrNZ36
         cl5zCyvNXQJz46rUnkpVFeLiKl2XTziKdSrY/uKJFOQnkktV8FDsKF8yNzZE1zUHwsKq
         re4dBIOCn0cVeK9QxjzJ7GqFOT50yknQZJyMa89/cT4en0Mof2RXeGmjYKr5HYGqT2yX
         bU6Q==
X-Forwarded-Encrypted: i=1; AJvYcCUkv3H5WeHCS+t1Gw+j6BHegSfTPIjt3KoVR1IIPlMAsadMYjE/CYnvk47Y3Wsb/Lpbm+xBMmBdVw==@kvack.org
X-Gm-Message-State: AOJu0YxToGiPQEzQROlMsSHqVQbmZAT7Fn9DfzRJBRA+QMEzRiGHlsWR
	P/fAofS8wOOcdV4jH29Xc00A5jMTqKaMfhYQ/yZtapNKFp5SDD2OxqUD
X-Gm-Gg: ATEYQzzSvdgZ1xMcXu6N0dtRZ4eoZgQQGHKJVRUermGTmpLp7CFC0suQsKpwJG6AXgb
	7fKKbX+5Kuy/M+oXdZWTXrnNH24WU+YfJ+UoT6E1aw9woWLYH5a2OyIuUHWGHXq9vNvOScAZGey
	tLPqw8VY9p6HI3CO5pjB621tHk3/lr9XTagQbllW6Ghw3M8xQQjCsV5d6Q2oElkjgFw6HpL7HGy
	SdQMm6cnNe+d9ETnSVH356/m8aN7ehtmq9Hy0Bn3qf9BwEdHukIWBk2MUFEaLpJ6fSXdCNIZVof
	7DPQ0gSEB3aIBfQkBZBSfwNcsp874Fp9U3vOvV2AveeNYHyLd+iUGqXPnQBA0D7dJLY7XnG2+cm
	pQXWjT8oACEoqNzec2NDqVdb/FAlhXim089v/nQu2yUiuCiVmkLKBr71FoL2G1M8IeHJY2RWDA6
	gxJiGCiSbxz5TmTO1AEY1xUhrbSW/Y7fv/
X-Received: by 2002:a05:600c:6297:b0:485:3ca4:4ef4 with SMTP id 5b1f17b1804b1-4854b0bb5d2mr78741805e9.9.1773281095548;
        Wed, 11 Mar 2026 19:04:55 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4854b0c2961sm29489225e9.15.2026.03.11.19.04.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 11 Mar 2026 19:04:55 -0700 (PDT)
Date: Thu, 12 Mar 2026 02:04:54 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Nico Pache <npache@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, aarcange@redhat.com,
	akpm@linux-foundation.org, anshuman.khandual@arm.com,
	apopple@nvidia.com, baohua@kernel.org,
	baolin.wang@linux.alibaba.com, byungchul@sk.com,
	catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net,
	dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com,
	gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com,
	jackmanb@google.com, jack@suse.cz, jannh@google.com,
	jglisse@google.com, joshua.hahnjy@gmail.com, kas@kernel.org,
	lance.yang@linux.dev, Liam.Howlett@oracle.com,
	lorenzo.stoakes@oracle.com, mathieu.desnoyers@efficios.com,
	matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com,
	peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com,
	raquini@redhat.com, rdunlap@infradead.org,
	richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org,
	rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com,
	sunnanyong@huawei.com, surenb@google.com,
	thomas.hellstrom@linux.intel.com, tiwai@suse.de,
	usamaarif642@gmail.com, vbabka@suse.cz, vishal.moola@gmail.com,
	wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org,
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com,
	ziy@nvidia.com, zokeefe@google.com
Subject: Re: [PATCH mm-unstable v3 5/5] mm/khugepaged: unify khugepaged and
 madv_collapse with collapse_single_pmd()
Message-ID: <20260312020454.qpwjldisaqcstjer@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260311211315.450947-1-npache@redhat.com>
 <20260311211315.450947-6-npache@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260311211315.450947-6-npache@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Queue-Id: 72DE2C000A
X-Stat-Signature: tfm6zyrdqotdtbj1d4xuzitp5d11mgtb
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773281097-758732
X-HE-Meta: U2FsdGVkX18JBEINDVwnH+eH0yGOXazlEdu6RMBvN7d0zlITvUcuERnR/y2Cq+TMwxbKKS1K5ci9nhy20BSbiP7wLZmLPm1O5wrnuv0Kxq6EKDdvO7bJaZsnNArpy30hRXnOjdRQGSZP5XG5kCJnFyVCjSSEs5nzhhGb541Ne0rXccJoGGOGznsy1+o9bElg7d22tzpPvPeIUs3IYHE96DKBsQMUgOXXMTSP5BBTSKiHqVpzNwmj0g70tGsHghxNxPUDZi85HTwooE3J1ZaKucLAMnJmgYFoIy2o/vK3nltTiA8njqVsQ4y5DGqNXJ8uIsBp4FTgHQdHmtMlgn+4EfWCSsHdmdw4I2r67/R2tZxnIjvYufDnPEMlaKlqCzpGvHFgX7t5UBl78DqRkAAS2jqvyUi9jkO3uoJ4INsJGvpZ4D7jZPevMDus4+hs+6EFZv5s+H/yVpb6sYDOYsAsPee0/fjmzaaCrM/mUHB2YBkq9B7LqwK/OeuGI/swAHrVAehyZbGw/GJZoKpI65XqvULoQXE6deP+9mlmNGNr6jghn4fQVTfXItTNqvfvLrkGTFs4DYNJ+Sqstms+vr9AdjvGcym57nZJviyd7swYeiCts3zzs0OPyaTAo2EceUzekqSEiCNz/bOemQwbilaYyccKk3OLVnvChlDjDcJkKKHJmzpDZlv9uQy5zR8EqrucKwaddBkwpieUUaXL/cZl/j1DEyRII9VujVjYQaQ+I/VuzH83KzcHNlK0ja14Vg9cNJpSHXgNJ0iFqFLP1k/rh89ZaSjAnpUkhrlmNXiMGZMD3nR5Js+kiNJNz3NheAvC46ZtC4L2qXgrBunOaf1g5S5vbOgR/HlybRP9yu3nX/3FKa3FeY2eFkgC3v5v2xmmDNcmZZ1yuNPBDDEu4cHsr8SPeRHO13TUgAuJfkvYq212q/zx2R2EXTZL+s8tA0RRXnMnPP52C8Ct36yiAEB
 JUExMhhm
 mcwZX+VplkBe91UW4yxLQDMD+H0NFQSw2nWq3xbeLAzPyegRFfUzyxmJLBjIhXVsD/HVvbxB31+aDQkYjUkFKAC9/hRuMO96sl8wWUQk4B52AO9nqcINf3BL5AOEl6zlmDorXC0HP2izpcSouUujRTq3jWfs0/jw8ctUfA5ufxZH/ypZEFba0BpSPavGYkBZ2Nkftw0vv8FO0h6mrDKZRLKJv5HVmU69tfTuZIIGWvHbk81YSTywwlQS75H0elBKuxi/umEuRi+0y6pqQxrgcYoVYQIEAX8B1hJXZ2tdDXT9kdjkbEq50C/7Lj1X2LzEWXHzJV/JMMX/MHbZrK1hbBmScapRtDiNlQI979l7L2NueNgxllFoaymexURSnFrZpiVbEHwFPRjhweEFrn9xNgCVWOpAmPZgrkIXC3N/iYagbL9P0RjC6E61OmgvUW3SCJP668lhsIIelFxe3fxY9hmXqRBDYM26bgWbyUdkS4P3OGNUfjNgypvQSZsFOzy29Xbofq2AsugawtpMketCVDT3P/1/DNJuiTxIS+Z8++nDoqR7gbE9dmsEP8UEdt1v2ag68QCObasqN/9PnOAydGK2rRHphUO33h2xLYasANM7OWp1Z9ph90WPOApVx84oAFE5ieE1zx3ghzs1Nf1vr/vIrQAKLXR/yvbMAQWZ3a0h3g+/1E5DM1XySFuTvhjc77oJSMHjsrIHn4puVR6WYSrJSUxc/7AHHJhV1ZfsjNLkf7U7AEBbIqzMoqyeDnb7QTCU9XESA9Hh/v6LZVpf7eyZvQ3tfaIkoi3sf3yI2Mww3RHN/D3m6I1dvCcweM8jMRSRVqf5ITq4SmqknPKJtvTZb+Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 11, 2026 at 03:13:15PM -0600, Nico Pache wrote:
[..]
>@@ -2823,46 +2855,20 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
> 			hend = min(hend, vma->vm_end & HPAGE_PMD_MASK);
> 		}
> 		mmap_assert_locked(mm);
>-		if (!vma_is_anonymous(vma)) {
>-			struct file *file = get_file(vma->vm_file);
>-			pgoff_t pgoff = linear_page_index(vma, addr);
> 
>-			mmap_read_unlock(mm);
>-			mmap_locked = false;
>-			*lock_dropped = true;
>-			result = collapse_scan_file(mm, addr, file, pgoff, cc);
>-
>-			if (result == SCAN_PAGE_DIRTY_OR_WRITEBACK && !triggered_wb &&
>-			    mapping_can_writeback(file->f_mapping)) {
>-				loff_t lstart = (loff_t)pgoff << PAGE_SHIFT;
>-				loff_t lend = lstart + HPAGE_PMD_SIZE - 1;
>+		result = collapse_single_pmd(addr, vma, &mmap_locked, cc);
> 
>-				filemap_write_and_wait_range(file->f_mapping, lstart, lend);
>-				triggered_wb = true;
>-				fput(file);
>-				goto retry;
>-			}
>-			fput(file);
>-		} else {
>-			result = collapse_scan_pmd(mm, vma, addr, &mmap_locked, cc);
>-		}
> 		if (!mmap_locked)
> 			*lock_dropped = true;
> 
>-handle_result:
> 		switch (result) {
> 		case SCAN_SUCCEED:
> 		case SCAN_PMD_MAPPED:
> 			++thps;
> 			break;
>-		case SCAN_PTE_MAPPED_HUGEPAGE:
>-			BUG_ON(mmap_locked);
>-			mmap_read_lock(mm);
>-			result = try_collapse_pte_mapped_thp(mm, addr, true);
>-			mmap_read_unlock(mm);
>-			goto handle_result;
> 		/* Whitelisted set of results where continuing OK */
> 		case SCAN_NO_PTE_TABLE:
>+		case SCAN_PTE_MAPPED_HUGEPAGE:

It looks we won't have this case after refactor?

Current code flow is like this:

  result = collapse_single_pmd()
      result = collapse_scan_file()
          result = collapse_file()

      if (result == SCAN_PTE_MAPPED_HUGEPAGE) {            --- (1)
          result = SCAN_ANY_PROCESS;
	  or 
	  result = try_collapse_pte_mapped_thp();
      }

Only collapse_scan_file() and collapse_file() may return
SCAN_PTE_MAPPED_HUGEPAGE, and then handled in (1). After this, result is set
to another value to indicate whether we collapse it or not.

So I am afraid we don't expect to see SCAN_PTE_MAPPED_HUGEPAGE here. Do I miss
something?

> 		case SCAN_PTE_NON_PRESENT:
> 		case SCAN_PTE_UFFD_WP:
> 		case SCAN_LACK_REFERENCED_PAGE:
>-- 
>2.53.0
>

-- 
Wei Yang
Help you, Help me

