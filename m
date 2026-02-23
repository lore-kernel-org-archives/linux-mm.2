Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76966EC1105
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 16:22:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6D246B0089; Mon, 23 Feb 2026 11:22:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD84F6B008A; Mon, 23 Feb 2026 11:22:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAFE86B0092; Mon, 23 Feb 2026 11:22:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 95BBB6B0089
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 11:22:44 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4613D139AC0
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 16:22:44 +0000 (UTC)
X-FDA: 84476239848.17.9F16140
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id 332FA2000B
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 16:22:42 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=UD0Q757a;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf13.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.172 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771863762; a=rsa-sha256;
	cv=none;
	b=MjpAgbXJEV30GHUGySocbdL2H76dYz45jOoc0szgLTOioIipDnszQ75epyYett4jQ3KCBZ
	9/MZR3wlWeF6mTXhK5ZzC945Pn4N9AEB6OAGuTA8CNINaILJ+hGLbkoRIawdaSHvLh8mop
	k5T7iVUui+f7Ama+jLA3NYmc/hF8QL0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=UD0Q757a;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf13.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.172 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771863762;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/ycxCWrwyhN+Wc3e1z7uOIm6Q5HGlQzORk9QGrhvwpg=;
	b=K3Dbgr620Yw3Jj6WlyXM8ucIxQryrENGWDgT4SgGifva76OCUxFm9VZwJ+sT/DvImjvdDk
	8rKEczxT0vfBAf3Hp4rDLTWOP5LaCzJCDmkyQrtNAmfGHNpLpvU92VnWVORt6VnuDreb+3
	a1sF6jRtjyYUnu+9NHlR6A3T/I4m11M=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-503347dea84so49393141cf.3
        for <linux-mm@kvack.org>; Mon, 23 Feb 2026 08:22:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1771863761; x=1772468561; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/ycxCWrwyhN+Wc3e1z7uOIm6Q5HGlQzORk9QGrhvwpg=;
        b=UD0Q757at28XQrHQsuicSxfmHv2ppbrd9zHbUONftfm8ofB8AMUl13Mse4zguoWJ51
         +NVqzghqdpBTbabc2HeBCIeiZ3jOKVlfQhwckY//cxTn9Hu254Cry97jpUpT1Xs6KPiz
         LkVeaiVDDyFGLAL8h9PmMK32fguIdKg6IrR4Bih1Z/goyh2eMH+uOPnWto2Q8seCMhMl
         Z7ndAq1iehb1hL+sxbNGsA0u21fvyLej2UzUwun9DvEty2xmtUgY8QbibQvMEK6d1GY8
         xCva/jsz8qxAM0+mhj+UtdGrSEjB8bKyIol7fW+6W6nck82sz4U+3bdeMVfW9MB3y2jR
         2kUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771863761; x=1772468561;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/ycxCWrwyhN+Wc3e1z7uOIm6Q5HGlQzORk9QGrhvwpg=;
        b=q3cOo2+o71gXoWCAVSJfJrg/mw6MCjkAuG003z0M65s4GlzUcFX5b/Zyk7m4Igu8OC
         WocN1+U/2zxPpus2696EDUD3d8G9aWi31WW9c9C+3gfYnnnZWmE4wFhYv1G7KtUM8lZp
         DQswzvNEwN1+VREqa4Ltkf06XvMXjo0eJHnQkTcDMyo7MiQ+L/UwNbZ3n+K2zecmMxTa
         xMMVFzKD0xw1nqazIZxGDg4T1ERi6A4txaqRmHsEsso+pJ+GUQFwryhQumAbxDMkXWgE
         bPIXVe7JJuwTJPSjlubh+osq5OgqPHd/D2nlwD4TYjiWqxXkfo4P/DZw1T/sHQ2fiOeW
         ApZw==
X-Gm-Message-State: AOJu0Yx7NY690XNv+pmOWcpcSUiF2bnhICHH9Jt7fugMMMqryuLpV+aS
	8SIUW9o4CJJsTs2/NjsNWjE7PLeie4obG4OBLQXoHpSkbEAWaQTorLGHIGm1Sm8Ihi0=
X-Gm-Gg: AZuq6aJMs8P+kegirZBzbOLKLKsCoZDqCQBBqZXCE+yuSQcRep0LX05GItudCn4mrGy
	QsLZLq5DnOnFrrtnISugyfueftaA5fwPNZ6RhbQ/maxa4k+uybGuEeyE+gYOejOSCJeRp7fcQhw
	C4BXCchQJo3v94V097ALVGh1smwRjqo9ZcT1fG/UekzCxY1rEEhdIuCoWAmCiWp19L9L1PbkQIJ
	oRbeYp63NzhlftWAjyBc/xb5NdCkYaRqwx1gdX1iYW77/gtAyD+UPTWd2SwKNSjEnj0fCKJcVwz
	4lSI32bNyeqfN5J/xFhtHocZMqhZus18jSZliGhJqz8VhdI9Df0l9yzVS9mL56+kkmEkCWTzsvy
	hhQaDOvEocHAXPBbE0BxHoFkBnHrAmq0dDXF0k+D43WQJCJfLnaykPIFbYPjfP9HPZXtlmbeVP9
	JFl4UK1zPI9fuQH+/djqgM4Q==
X-Received: by 2002:a05:622a:1647:b0:502:f0fd:1837 with SMTP id d75a77b69052e-5070bcf94d5mr123459931cf.70.1771863760960;
        Mon, 23 Feb 2026 08:22:40 -0800 (PST)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5070d50c920sm73283081cf.7.2026.02.23.08.22.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 08:22:40 -0800 (PST)
Date: Mon, 23 Feb 2026 11:22:36 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>, Hugh Dickins <hughd@google.com>,
	Chris Li <chrisl@kernel.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Youngjun Park <youngjun.park@lge.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <zhengqi.arch@bytedance.com>, linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org, Kairui Song <kasong@tencent.com>
Subject: Re: [PATCH RFC 06/15] memcg, swap: reparent the swap entry on swapin
 if swapout cgroup is dead
Message-ID: <aZx-zFmQmC0zoWKs@cmpxchg.org>
References: <20260220-swap-table-p4-v1-0-104795d19815@tencent.com>
 <20260220-swap-table-p4-v1-6-104795d19815@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260220-swap-table-p4-v1-6-104795d19815@tencent.com>
X-Stat-Signature: 7sabbqokumh4ojrkkpgd5mq1cxbxurqk
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 332FA2000B
X-HE-Tag: 1771863762-241030
X-HE-Meta: U2FsdGVkX197AwmULFgYcIZxGcSC6WYjzhWE1IHkMGOVbQP/jWTkRsW/XQn/i3l2oT1WcAzWdN8CGUH9ldrkpcNciu00b1afl23u5jQsGBw9lxIhkgn4dOMfsGgOf8/kjaDMNEwAANhVcjx0i4tIMy0Uh2E90j1Zwj/0nRQt0OuofqyyO1ScOV7HBn+uJGJbUeBOIGNbm+L69EZ7VfbDzhPCPGp0Yft3YqlPAv5hvEsDGbABngsurxHDtOuVVMXKx8ygH76+TtpYIzxGMEnUpzzGkihsi1p9LitVwqqrXVWoXti0bILWwrZzk/yFwH0kpDYF8VmXOIj88LGPWxf4KuLpT7ER7jVpxnKBiHeNrkw+qLsbILvHtxB+tbAq9oXM9sbWFtUV7TejxudVY7mZk3riKSvSFeQSvq2EsJDd2FQqkO62YBmQ3iiEyAPYtj9T1V3TN5fBeR+MeBNr4DtP5xpoqhPIZ2lkqRKEvDjH2FzCnkhMbu7JKmn+OQWykwjh+D8Pn2ZcxJdBxfeCamOc3vuxlyV2qGGpD44ERTXDLVi/xz+c8yWlzbgfWUm92dDivCl7QUNQgc7qF8m8D1lIulyK2wh381jTk+WlnzQVkW3EFDHp3y7LikIcWM4KvgA33xJD5/w/n/r9X+yXlqoshsxG+uWNtKugyv4u6RbLv5+NcOPjdLrvv/pw47iLs68R/b7t3mDAFpGxi9FjMpEKGoHcB4pZe/yKBQuL5nYYade4Tp4K7Ht0CJw0g7awhIeErzoI8KpveNegpTS4fyhKP4vO1/SXPlx0JXRL4TeiRUL0YHoBSz8KqgUhqksX67JsMKfC+rdda/ZoFQs/5tQ7hP32btEvbveKBjdphOxXGvoRLIWO8DbM4w6HySxcvaDmxFBZOJ5Zci6K+TRrlrL6rX0tZF2674aORAl9CTlKupANHtY9+xQc0a9XOyHi+8PSfZsYZSgiiAsR2gHQCp1
 PnGalfzy
 Mt2hL/B1qwoAIMHohBsnG+1rz37eU2eK9ITN3dm5OY99bBnHKlgW7k84ILr/mMVqnSbzjaJEH2vA5cEw5H7SGPobaEYl6OXNcliDEnLU/7AVyhBuI6d6kDQbExxKrQO8bJ9xV51lvvKw+mriLl2VY38ccwyMdklP9lyFW8ntK7HPMqeMuEgSnQ7ATZD7QChBphf61F9Tf1fJc8q80qs0JDj5CroD0zWS13FfDZgjJxpbpUZWNwQ8HG0nIg10agaOUIean7dL6H9/cFTJuobFsLic4pBvamMouLqvG2NQfvc1azazmpRcf2JXyRoMtMDvpr9vQiIJ7RQD+d9uELR1kXNW2Sq9Ipt7ASRRyAiP8hSOFkeFkaKw168xfx9xKudKMu6ia1k/M6pHUNZtJIXtjWLkA1IFO8lYe25Jg87d+8XdptmyNcoQXpcCHsDmepPwkKJuJODa424oeGAzxqB8WOHZbejuaRpOrb5KFIjMMaYCP69Hnn85M9enIjwZnaWF5348Po098IQDzG4Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 20, 2026 at 07:42:07AM +0800, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> As a result this will always charge the swapin folio into the dead
> cgroup's parent cgroup, and ensure folio->swap belongs to folio_memcg.
> This only affects some uncommon behavior if we move the process between
> memcg.
> 
> When a process that previously swapped some memory is moved to another
> cgroup, and the cgroup where the swap occurred is dead, folios for
> swap in of old swap entries will be charged into the new cgroup.
> Combined with the lazy freeing of swap cache, this leads to a strange
> situation where the folio->swap entry belongs to a cgroup that is not
> folio->memcg.
> 
> Swapin from dead zombie memcg might be rare in practise, cgroups are
> offlined only after the workload in it is gone, which requires zapping
> the page table first, and releases all swap entries. Shmem is
> a bit different, but shmem always has swap count == 1, and force
> releases the swap cache. So, for shmem charging into the new memcg and
> release entry does look more sensible.
> 
> However, to make things easier to understand for an RFC, let's just
> always charge to the parent cgroup if the leaf cgroup is dead. This may
> not be the best design, but it makes the following work much easier to
> demonstrate.
> 
> For a better solution, we can later:
> 
> - Dynamically allocate a swap cluster trampoline cgroup table
>   (ci->memcg_table) and use that for zombie swapin only. Which is
>   actually OK and may not cause a mess in the code level, since the
>   incoming swap table compaction will require table expansion on swap-in
>   as well.
> 
> - Just tolerate a 2-byte per slot overhead all the time, which is also
>   acceptable.
> 
> - Limit the charge to parent behavior to only one situation: when the
>   swap count > 2 and the process is migrated to another cgroup after
>   swapout, these entries. This is even more rare to see in practice, I
>   think.
> 
> For reference, the memory ownership model of cgroup v2:
> 
> """
> A memory area is charged to the cgroup which instantiated it and stays
> charged to the cgroup until the area is released.  Migrating a process
> to a different cgroup doesn't move the memory usages that it
> instantiated while in the previous cgroup to the new cgroup.
> 
> A memory area may be used by processes belonging to different cgroups.
> To which cgroup the area will be charged is in-deterministic; however,
> over time, the memory area is likely to end up in a cgroup which has
> enough memory allowance to avoid high reclaim pressure.
> 
> If a cgroup sweeps a considerable amount of memory which is expected
> to be accessed repeatedly by other cgroups, it may make sense to use
> POSIX_FADV_DONTNEED to relinquish the ownership of memory areas
> belonging to the affected files to ensure correct memory ownership.
> """
> 
> So I think all of the solutions mentioned above, including this commit,
> are not wrong.
> 
> Signed-off-by: Kairui Song <kasong@tencent.com>

Those semantics look good to me. I think it's better than the status
quo, actually.

