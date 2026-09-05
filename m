Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BF9BC624D3
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 11:49:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A6B76B0088; Sat,  5 Sep 2026 07:49:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67DDD6B008A; Sat,  5 Sep 2026 07:49:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 593EF6B008C; Sat,  5 Sep 2026 07:49:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 38DFE6B0088
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 07:49:42 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A12108032F
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 11:49:41 +0000 (UTC)
X-FDA: 85179538962.18.9F693A5
Received: from submarine.notk.org (submarine.notk.org [62.210.214.84])
	by imf03.hostedemail.com (Postfix) with ESMTP id B308420003
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 11:49:36 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=codewreck.org header.s=2 header.b=MRiP0p+A;
	spf=pass (imf03.hostedemail.com: domain of asmadeus@codewreck.org designates 62.210.214.84 as permitted sender) smtp.mailfrom=asmadeus@codewreck.org;
	dmarc=pass (policy=none) header.from=codewreck.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788608980;
	b=DJnUrUVHq7K5/woC3+KOCsAVOqefl/fEsG3zWYwTWLyFKQ+Pg2mEPTLCXu06U3dHg3RAS4
	jcERMv7R/1TRFI8P1iROedhHcEFqty0jkO4VOIYYq43kTrS+NsJa58EfsDaHoKSjTsK0Zu
	9SMOH96DDIF3mERjHzuCCaXO+vgIKts=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=codewreck.org header.s=2 header.b=MRiP0p+A;
	spf=pass (imf03.hostedemail.com: domain of asmadeus@codewreck.org designates 62.210.214.84 as permitted sender) smtp.mailfrom=asmadeus@codewreck.org;
	dmarc=pass (policy=none) header.from=codewreck.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788608980;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6Bu7zhBODPx9OVIj9kI9Cw1nNDBcCS9dXlz9GgaYwCk=;
	b=rNWSYuMenNxd+jz8n0iMlLTEMk0LF4eZdprQ7+wB3ivFL9N3zgqvevC2JLZm6s41uU85oA
	dMFjcF6zAP9mVjEQH40YHV0rak/yHor1WA8NQe0vjNFtbZj+NNYA3KbBlwBs9qZlzKc+N7
	A73nXax3UU35RAzKesjj453RvIYFdvQ=
Received: from gaia.codewreck.org (localhost [127.0.0.1])
	by submarine.notk.org (Postfix) with ESMTPS id EB42014C2D6;
	Sat,  5 Sep 2026 13:49:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org;
	s=2; t=1788608970;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6Bu7zhBODPx9OVIj9kI9Cw1nNDBcCS9dXlz9GgaYwCk=;
	b=MRiP0p+APtwWGq7nqcMTUXcXnX1Rp4Ot3CBYsNBuCSxEDHzaM37F3IZw7rUw7zihCjh19l
	IKEli+6W7tjafk9BZVuzO5RCsDb46aUQn0VOifmyYJXqj07Dh0YaBAgfvy4cMmotZxUc+6
	gur34LYPLAa0pJP4OulRrjRHanfS9sYO8tikO2hODNpfZsJ2w6nX3QZre7n4zB4sJpxVO7
	6p+3MJkGAILxtpSHRK3niKb+p+9zzn/DBBgPW0I7hvn1/aMaBuVcv6dj4bf/bQ8SDCM0Zj
	kpPQhAdanri4iEvqS2vR2vXhMnytBJ4tTo0nfqBJwFLeE7it5Msx3a2Er5/zRQ==
Received: from localhost (gaia.codewreck.org [local])
	by gaia.codewreck.org (OpenSMTPD) with ESMTPA id e27ca948;
	Sat, 5 Sep 2026 11:49:19 +0000 (UTC)
Date: Sat, 5 Sep 2026 20:49:04 +0900
From: Dominique Martinet <asmadeus@codewreck.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: gregkh@linuxfoundation.org, achill@achill.org,
	akpm@linux-foundation.org, broonie@kernel.org, conor@kernel.org,
	f.fainelli@gmail.com, hargar@microsoft.com, jonathanh@nvidia.com,
	linux-kernel@vger.kernel.org, linux@roeck-us.net,
	lkft-triage@lists.linaro.org, patches@kernelci.org,
	patches@lists.linux.dev, pavel@nabladev.com, rwarsow@gmx.de,
	shuah@kernel.org, sr@sladewatkins.com, stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com, torvalds@linux-foundation.org,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Rik van Riel <riel@surriel.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>,
	Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>,
	linux-mm@kvack.org, Russell King <linux@armlinux.org.uk>,
	linux-arm-kernel@lists.infradead.org,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-um@lists.infradead.org
Subject: Re: [PATCH 6.18 000/552] 6.18.50-rc1 review
Message-ID: <apwBsCGpUG69KdGc@codewreck.org>
References: <20260904045747.813364717@linuxfoundation.org>
 <20260905114111.124795-1-ojeda@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260905114111.124795-1-ojeda@kernel.org>
X-Rspam-User: 
X-Stat-Signature: e6s5so71ayejr4w56obdgfw4gqfizik6
X-Rspamd-Queue-Id: B308420003
X-Rspamd-Server: rspam06
X-HE-Tag: 1788608976-179794
X-HE-Meta: U2FsdGVkX1+CnYDdb81VxyzwK8AHFPlcuJmJp24yFwmYmVaXSFPEPOdKLMUpwtp2xEakNstGVMAKOP5Br8uN06xOes6FK2Q+MZTbu2VJNe0Csc+ON8tjetHO+Mf9GQIYnJ86sk/m4brWcYIyfK3mc5zOuIwnsZu0k5oEurq9Cb6qmpAQv3FFK3/cPOTu6vS2vJv5how0foCiHPHbkkSRhH+icoB6v3DcpqQZ+o7wWc6CoD/yTEiA3jiCYU+CuxoGcppSr+GXgcc0DMaaome8lmkxsU9nw0DONI8kn63zjhkPIDlRi0irHnb8duGos2zH5hmMhjZ1oIAfEVrDuEOFfg6qsFmpfvwViuhDCs9ST91lQeuMhOrtz74Bg8jGg9TsPDdZZJ3ZZHyhTqbAtbCABQOnxRdA7Eo4eDF1glsJKc/9twxYLbLUtN3Rp2+0QpMtauhKyZGdF7ijnJifr5+rbEaBtnw7QB+uOmOWV9z5lrsL8HF5Qi3CbZmxc/APHMFuMomJJgEybxcC06FNhx8ZABreQ+GhoxhCSzsakXs45YseQZwnOou/IEx9xft/puW7T1SVqaL5OqC8/YJ3hsZDkDL8VBAtatOfFRmklYiRYZbej8+inXUzoStyA0tY4ojR16Uax71qjsu2FQ/R4nOWdvUco0rd01PC13eSREIssxm8sRsvhgxWjY6X0J39RIkKjMMCKMa7vwed4mRJU2J6ZK+zSic/HltxuKoRG5Ua81Zu5Omrq/sMxLOCv7B68wHyJ9rXRCYaejQgesLUepkgEZDVlzezqaT8HnWAhxkUb1rDJG5mqwzwc9JUp7Kvu8YK2/7nk3+3TudEW0ZxJ5bhopIvT2IgzGr+e1lb63KLPijacHssRoOp3I19yvzpgF3BvEEgRaDvu8yG53hb3Ide+XADfyr80PjvQt/sL0nyJaRY72qR6gZDpXl95ZQjft5lZkNirMdplxvyl1KUPvv
 cMxRyV0K
 lSbWNt46/I3z7LFWq2j+d0Bhv5SzK2okwIt/Upy4gdGoloCW7AWresQGJzwFDcmxUuBWnTkgx59ps8Ha3kKXK9HJLN0SWgJ65ZFit3mno7Fh2M9gLu+3pGQdiAC+CuyyQGXzFXi2C6HQ9mVDJR42+W9wucTV9OdXuVWdMlB19b30q+LVWoUsHzKwnh3Zb0FG5ThNZg2n8y8KAsLNhfUc4mQTLVsNLMUCg7zhlCpaIxmOZ09HLyjkVbk5QpaNcyCh7QX9yU+zRjxvJgExObv2oKdW6iJXlRoQzkUD7LivZ2Dc+CP80MovXxllUXtJRY/svG4NkczOt4AVnzqcd19g9qxC9dcARDvXnBiWopfT7QPo/EdkvJd2q2muKM2Ek/MWSfjM1pxhlQTJmFnTCYevJ34aZ5zWXZo7UkKFhqWJzYMdru7OJxcMKN3SERQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Miguel Ojeda wrote on Sat, Sep 05, 2026 at 01:41:11PM +0200:
> I see the same arm32 build issue:
> 
>     mm/page_vma_mapped.c:110:11: error: call to undeclared function 'huge_ptep_get'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
>       110 |                 ptent = huge_ptep_get(pvmw->vma->vm_mm, pvmw->address,
>           |                         ^
> 
> In addition, in UML (x86_64) there is also nearby:
> 
>     mm/page_vma_mapped.c:110:9: error: assigning to 'pte_t' from incompatible type 'int'
>       110 |                 ptent = huge_ptep_get(pvmw->vma->vm_mm, pvmw->address,
>           |                       ^ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>       111 |                                       pvmw->pte);
>           |                                       ~~~~~~~~~~

See this 6.12 thread[1] for this build failure (I didn't check but
assume it is the same, that missing commit only made it 7.3-rc1 but was
also backported to the 7.2 tree, which also explains 7.2 didn't build
fail)
---
This builds on master because this commit:
f5407e9b697c ("mm/rmap: use huge_ptep_get() in try_to_unmap_one()")
added a function declaration in linux/hugetlb.h !CONFIG_HUGETLB_PAGE
code:
```
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 817b8b4223fa..95b1b6ee1f96 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -1270,6 +1270,8 @@ static inline void hugetlb_count_sub(long l, struct mm_struct *mm)
 {
 }
 
+pte_t huge_ptep_get(struct mm_struct *mm, unsigned long addr, pte_t *ptep);
+
 static inline pte_t huge_ptep_clear_flush(struct vm_area_struct *vma,
 					 unsigned long addr, pte_t *ptep)
 {
```

The rest of that commit isn't applicable, so we either need to roll that
change in 'mm/migrate: use huge_ptep_get() in remove_migration_pte()' or
add it separately (or drop that commit)
---

[1] https://lore.kernel.org/r/apq_s8mFJJPzoIdo@codewreck.org

-- 
Dominique

