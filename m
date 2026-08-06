Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C3A6C56208
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 17:03:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 264E46B007B; Thu,  6 Aug 2026 13:03:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 215CE6B0092; Thu,  6 Aug 2026 13:03:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 108826B0093; Thu,  6 Aug 2026 13:03:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D097A6B007B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 13:03:29 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4868F40141
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 17:03:29 +0000 (UTC)
X-FDA: 85071465738.29.3025D76
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf25.hostedemail.com (Postfix) with ESMTP id 789BEA0007
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 17:03:27 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=OpPVWvS3;
	spf=pass (imf25.hostedemail.com: domain of gourry@gourry.net designates 209.85.210.180 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786035807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jTcIYdDJrbFYM8SM/eR5/FInV0ODp6bCP4uR1qvvuCk=;
	b=fhYuNFXGiLJNjjXBMavDXHxmSFFenNvaJBr4/3GPRFrsFhD5Xt4xwbQ94ApnlMKlVcjARG
	wmiNYnBk65H5XhMLwK8uoSyTJqpmVlHNOfmiFS47WxZLRO7AB+hnKvnPtePDjQCZZl4J62
	cUCmqC+g1DXRLpz3UFTFDMvLALON7d8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786035807;
	b=WLVD1DRcho+1SoWpGwjNWDg2bfxAiruZZ1EorXAUupgMJZMjNdySPwFt+rR8cEC9bhC0es
	k+/ti2OTgbSMsMYVclr5VHmdnyFjLKRUxoXOpkwRWIkAZtglmWcR9GBozgc1Lzms9Yld+j
	YDEYyfIwk6BnewYhhVcxmaWdAqwMpf4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=OpPVWvS3;
	spf=pass (imf25.hostedemail.com: domain of gourry@gourry.net designates 209.85.210.180 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-8486672f03cso3034427b3a.0
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 10:03:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1786035806; x=1786640606; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jTcIYdDJrbFYM8SM/eR5/FInV0ODp6bCP4uR1qvvuCk=;
        b=OpPVWvS3oKqTrq+YpqBv47PT5lj+HX7qTGaezaZMxeAjqbchlhs5tJBAVTxme8LuTN
         ZQ3qmX1Mevwxiac8a+vdKTifCFVKkYIqIs8yLJN8hpq0bpguoQvXvA81+LeOvICFnvAQ
         KaCRoSeYlZHoxEjCcFsvlphfmK452CripbtbMzyMbpqxf/dUPmLFL0wAEql0SHwcBydZ
         S+M3ByabCKXVntchbe+I5G08tuCSJ2WMNNlY/ZY/aVIC7c4NjRe5/5jX8dLaEIj7DxaH
         B/CO1gB63dG/u4jkRTzplgfVDJe1oWUUOT75YDROtQfTidPg94SUEMPgPVrH+fddQvy+
         vbLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786035806; x=1786640606;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jTcIYdDJrbFYM8SM/eR5/FInV0ODp6bCP4uR1qvvuCk=;
        b=FKKy3h3Pl/BJ/rlLuRIyq9lGgjO9OeKsV9Rut5mNScFgDZ10kiJ6W4nXGQkidzPzcl
         Rz9gJ8soF5wEDYau5MIUcXy+O+muf0IkOBYtcNhjLBGRspO/9DHeSKFyoBLXK2s0dt6l
         46w1MexO6BoodB95dCFY8iUtnZj9vbW6Vl66LJXK6OG8jTLoCdSkbeDkkU/t7HP5NdzQ
         ELS/4ZEJHUkG5Itykj6WJf7SiAogxtD6JDx8p7Vg+jGBYQ3Uf+otra5FqafRULKWBbd+
         +cZzlBwYakOBVtmknBdQQC1msI4V6/dmStP0uErstV86KdKsaEavhByHZtZCdQ6Wl62/
         8jig==
X-Gm-Message-State: AOJu0YxusQmS55W5wqwURAosPfMTzZvKtup9xVOQpiFPR5Ca6NEpsd7p
	eN/457/zPUL19u6Aj7fb+oVDaf9aeheCKUpVYHJoEmYUG/oFD4IYtG+IT7Fpg/94iss=
X-Gm-Gg: AR+sD11i9LsGS6GiE1TkUSIuSwEf1c/rdmDk7+xMH0/nFrKMoo6LCoJDp0hgpk8/0Mv
	+h+g8XskyeX0/oaGbzFnGUfkfAXenE39qbTy8ZiTOj8ZKIfftB2UGEHuAfJgVUSs8bFEsEVKzjH
	f2pi5qtbqheruSRODB35vKUsmuB0MQJ39AtGjNjq9CAHx8Ik5Xj9g6/kdN8t6JodhlwuBaKUMRx
	B3BMPj365GrMsX97oTSwfAkv9js59sa4Wh4SdiF75bjYnIaYd3ymDAzMVaVrAo1gkyT1Qtw/5tv
	rOlWjVMvOFkCtOd0E2b/+oODW8CVUfjuZtZs9Go5PqALBhEFn1BeaKO4mYn41qMqCN6grGRZ2G3
	bYk8i6cdkWZ1j2iVMv1MWS77Aw+7gHSSEu+X6R1FTC/GB+zAub1IExHnTVJqEC1kow59Mc5CRca
	TiMx9zUQ4pEDTGmtXU2X18Zfs4tqOJBmVsBYagLiej+Wly33ZCH0dun1vJ026OEgoR
X-Received: by 2002:a05:6a00:2ea8:b0:848:4c0c:9482 with SMTP id d2e1a72fcca58-84f2e0cc746mr17400031b3a.35.1786035804907;
        Thu, 06 Aug 2026 10:03:24 -0700 (PDT)
Received: from fedora ([2607:fb91:201f:cebc:3a68:390a:144e:1b87])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84f453bb24csm1745790b3a.24.2026.08.06.10.03.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 10:03:24 -0700 (PDT)
Date: Thu, 6 Aug 2026 12:03:19 -0500
From: Gregory Price <gourry@gourry.net>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: linux-mm@kvack.org, damon@lists.linux.dev, linux-kernel@vger.kernel.org,
	kernel-team@meta.com, sj@kernel.org, akpm@linux-foundation.org,
	david@kernel.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	liam@infradead.org, npache@redhat.com, ryan.roberts@arm.com,
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
	usama.arif@linux.dev, vbabka@kernel.org, jannh@google.com,
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
	byungchul@sk.com, ying.huang@linux.alibaba.com, apopple@nvidia.com,
	stable@vger.kernel.org
Subject: Re: [PATCH 2/4] mm/huge_memory: skip zone device folios in
 madvise_free_huge_pmd()
Message-ID: <anS-V-k61246FkkS@fedora>
References: <20260728194714.3713735-1-gourry@gourry.net>
 <20260728194714.3713735-3-gourry@gourry.net>
 <anSOvqN1_Hs190xi@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anSOvqN1_Hs190xi@lucifer>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 789BEA0007
X-Stat-Signature: ya8ijby4pfmfjohgpst87gjd16cr6awc
X-HE-Tag: 1786035807-250045
X-HE-Meta: U2FsdGVkX18UvXKMNrlISfbzonUmUCmkBI3LWTC49PBUsLONTl26NkxiBY3PoDCdF0o4qzE/sef80RAHrBQJBba8Iw9to6hlvMP5PKpWZ623cdu0BLMR61eRFaso59nHF1gBt9kVGzPp+Z6S2x0ALzJnAGENl8uFWGujXPXuPd/e4ReuyKtjpFrNWZjEqkT5bgAEMKUn/5QlYYUewlLnvJ29UIpCBirClZ/80zpdFGhQYHdqu7VvkWWWV+F0rM9g4QuRZ/srpmXSVzHOWtv+iTvy/X97kAKiNlKJf/hdsPLwLATRFFFETwYkSRzyMD11TbKpscylws4UMTpygFLAtj5NnfATtuoQ8losKKmORX0GT/iBfvQkzRwRB4kcYXWjipJR+t34NXd7MTwHa3lzM3Ovc1VZ0TGoieaxH0tos4F5CBG+GmEmEmgc8NlvthMy019k0i6hhgW+tKqj/ysMC4n/Dpbdbeosz4CC2RNkWuNMbytgMnxGK2eK9X/ls9FZG1gVo4J1ZL+B/JtwqRspnI1HT55mxEt5P6lIjQOsiejppi28URfs0HHo/fRijYHMbLqBp+CpzrA92HAx3Syyr8FN6eDDtTm/gwlZNoRZUQDTZJRWT9tdt6lXL4hK91dLcnhANDzQI8BoxpEZkQHWcCbwC3VJu7jtguk3tJQep6FQylMGh/Xk+zC1rwxvBgdP+UQMaeU3hVbPg4iRX3SBPNZ2reCDTB+DyiaAyNjgpdzV2Yd8m9+CtYEP6HIyZmr/Ie6rqOB9rkUjVzXxlmTJaUwGfg9izrXlZA6UC5fCyfvufn9ccKp63v+GlnGOQ6QLwiNHrtAbetJ8EBn2YO59EsW/X32Kvw6BZfVr/VMC4hU9EwagasUfY0dbZf1rddUkmZV1GjHJRFzFNRfENEOczL4FInh0XwKyTLKF98zpXOJxGC2TwS78jXcaPAH94yuDcQMq32rbu97mdGqF55v
 x/rIvWhM
 OZLs/Yp2XINomiA+X4pch3hhydh5ndzTitl3A/sJmPcw4LhwQFymJ8iD9xio0Rfyfc8uTooR7k8JfK2luG/2d2OL97od4YQBizQkxhTirfvVYZqT5HB04HPzs2T/y7OTanyKYk1d4uo4Iglz45f5FUDEstFX25sjzVmu9d412Fd7BgPfOFUnos7RdL0qoXGue2xZvEHG0SoynUArDWZ97UTUiEZW9UUiSddyhqdr2kFZ02l9lfLhnmjXl+s3y9rG1WCcHELto6KO8DpeyIQK7d9WEpichowTXeuOcVXCwzaM2W6C3s+hNxgUbC8gcHzZr4YsC7hdzAOv4i8kDlAblDeBTYSnONvbXZ9RIT6+cq2sHKlzz4KjaVjC7IDC1yvt7e4oW0SFYKEAHFp35TfXkdCtcuemTS+rLE9cHm8lK5MboW19BQFjVYaNwGhNwNnN9iU6CFwBCmm8mNwzdYw+gn8PMQgVE1wFatznh/zmr5IPbRS/YMVtB6qG1Pg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 06, 2026 at 02:59:22PM +0100, Lorenzo Stoakes (ARM) wrote:
> I kinda wish he had some generalised folio handler like:
> 
> 	struct folio_ops {
> 		int (*handle_empty_entry)(void *priv);
> 		int (*handle_normal_folio)(void *priv, struct folio *folio);
> 		int (*handle_softleaf_pte_entry)(void *priv, const pte_t *ptep);
> 		int (*handle_zone_folio)(void *priv, struct folio *folio);
> 		...
> 	};
> 
> Or I don't know an equivalent type of thing, as we keep having these same
> patterns emerge in mm that are duplicated in a million places with slight
> variations... :)
> 
> I wonder if C is expressive enough to get us to something sane though.
> 

This is functionally folio->pgmap except it's not generalized and it
causes us pain :[

I briefly took a forray into moving pgmap to be node-scope, and that
works decently, but first i'm just trying to clena up what i can for
zone device.

Anyway, i get what you're getting at here, and that would be nice.

> > Fixes: 368076f52ebe ("mm/huge_memory: add device-private THP support to PMD operations")
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> 
> Anyway LGTM so:
> 
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>

many thanks :]

