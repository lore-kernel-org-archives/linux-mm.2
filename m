Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93D08C44532
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 16:23:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 565376B00BA; Wed, 22 Jul 2026 12:23:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53BAA6B00BB; Wed, 22 Jul 2026 12:23:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 478B96B00BC; Wed, 22 Jul 2026 12:23:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 207916B00BA
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 12:23:22 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9BAC080221
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 16:23:21 +0000 (UTC)
X-FDA: 85016932602.08.8BD547F
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2EB4E40007
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 16:23:19 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=SHDr2IuF;
	spf=pass (imf12.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.171 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784737399;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yUYDuHaewZql8DoYUinIt0gVkuOzRDMB1129ESkkAws=;
	b=gmwg5q1rRWbsL7K41XSWtRnWKxyrbL5xPbM9qKMgbF33Uae8OwPokmpX5tL255nYNb9VYI
	AOJbIwSZsAzNUoxYB7Q4yP7eoG7Mdn6B0sXsiVbqG48scZzHPugZ93d2juf7956hODTO74
	WAIvmaeNMDH57e7hQIvFWbFsH9wDnsc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=SHDr2IuF;
	spf=pass (imf12.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.171 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784737399;
	b=fow1EGha7HZkAO1ur2qA5z6qCSnKx51W0s+HhoAiQp8NtPGF9bjLM0q54r46TWSrZLA7hR
	IhWbEw+FnxuQ1dncJyAvWtqP26xbpnUPLGewH+59DUj5kBDCFohb8Ywg9Af+m0kfoyDIJD
	pIHr4mJHXYP/pd+C+yL/pnEhkca4vh4=
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-51a868b6962so146542471cf.2
        for <linux-mm@kvack.org>; Wed, 22 Jul 2026 09:23:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784737398; x=1785342198; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=yUYDuHaewZql8DoYUinIt0gVkuOzRDMB1129ESkkAws=;
        b=SHDr2IuFj4t69QFi0Pkkj0jp9096fucd0NQjXvOcdNfeQA98FRLMQwWSwlHur+Iv8E
         bEOklYu/sgRI37ENC3D2iRK0H7W7XufWjd8z7Jk8VM77B249iZQtU1jJ0RYBy/LKPS/l
         VlAPShOSYF65MBRyPVWcIC0/Zu6yNDDlBbmjVtp7H2SLapo8A0EXWygv53Z5Zh00uUHx
         EKAdrPeSjNc+EaW6XAsHiUQjlibJjP6L+/w9BHZn385rg8kfd8gx9U5Kk4w9sISgZ7CR
         93pzG8Quvu6PI/zOwM2OwPJQzAx46RJumhThhI2RBAoMxc/HtIZ4AmZ+Qfbacj/tra4s
         AraA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784737398; x=1785342198;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yUYDuHaewZql8DoYUinIt0gVkuOzRDMB1129ESkkAws=;
        b=nf74w5xdEZkry9JoA61rf7z9FU76Mz5+bzhJSOeVGWmTqwzxLLKji3S6G08OtF7x3k
         VFnHvYlQwrEi+i97YcjwMLq83ecKLFhSfw2CGKxR5R9Ck3Qth6IQtfUVMKp7FkAIaJVd
         yyb7IikrkdPQcLG59pDhLXUbXdvPDBTK15DZuyqI6FLvCUowyHpon0qgyWyk03zWuU10
         wd4YhA+bF0ms862Lvwhjd+/3WX0Crb+rinwj+PgagJlXAivkOjiF+vEUHnNqmYFhV0O8
         v7gzOOPH6PIg1EJGPs2joyV5/4KR0QO6kX7uRxAjiXxcL5WlFZnF6Ncih4LHbOn0UW9q
         99/g==
X-Forwarded-Encrypted: i=1; AHgh+Rok6uCj0zuicdEH+BxFTRYxi/kfVQ3R6QosEARtEatfCvJOGLiOEcFSOLG536SjP5X5zJpAoqOLiw==@kvack.org
X-Gm-Message-State: AOJu0Yy9JWinhrLGdQJunzPtAeQdpBPwLunDpMr1d0RJyx7oMmM6Vryh
	DPCK96KlI45GsdiqSvLIuXlw+cZn/dOYJ+ti9TLCjOkwFBgEzZxOJH/IjqoubLjFb4w=
X-Gm-Gg: AR+sD11LZHxz6+HV9USu7gtFS/vVwqcZcGa8qbzH8O5FypcTpXkvjIhJEBCIET2e2AL
	9V4/6LiKuZsq5PsYR5T3PHJh0nLu952wUyLF8TtmwrA7KQCB/4DFj8dweCtIx1qV9jXaxhswm9n
	YhDiqTO8HxB1mUU0ZmBtkFgRASr7MzWMuMWZE66gvnKWgJFh1T88RdN0OjSSmweWyefKxEkT5+J
	ZtnEEy5CGfqYXUocwj0aG4rK5/N4dH0obzixi8rmy5FaU65rW2hvzBHc2RNqfW3dwozQAzDOa2B
	ntvUIwFoRczRlNJSSuF9fLN3y4MoQyPeSXdYYly+PzgT1zfnzf7whC9yTO6/SPfNvEr/DLVwPDK
	AHJiJII5IFP/sCfHYNyUtgb6YdfacnWquG0l9DO6hb0rSx2nO8Rd0iJzKlO58EOnoEaOv1Kl0H8
	p27643je7jtpQ664KThFQPhQiS+pVXGRKxsOrQIhhTYhvahe5WFG+Gmg3xlw==
X-Received: by 2002:a05:622a:2c8:b0:517:9570:c1bd with SMTP id d75a77b69052e-5213cec8dd6mr228741971cf.25.1784737388008;
        Wed, 22 Jul 2026 09:23:08 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-527d3d3e121sm18278841cf.29.2026.07.22.09.23.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 09:23:07 -0700 (PDT)
Date: Wed, 22 Jul 2026 12:23:02 -0400
From: Gregory Price <gourry@gourry.net>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R . Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/4] mm: compaction: support non-movable compaction
 for pageblock requests
Message-ID: <amDuDmioLFUD2aO9@gourry-fedora-PF4VCD3F>
References: <20260722150006.3848560-1-hannes@cmpxchg.org>
 <20260722150006.3848560-3-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260722150006.3848560-3-hannes@cmpxchg.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2EB4E40007
X-Stat-Signature: byqn9ufq3wni7arx6pbum994z16y5ote
X-HE-Tag: 1784737399-579161
X-HE-Meta: U2FsdGVkX19PZGb79lrkUl8htaRMuqAWTHvKO9Glli4XJP/mx8qZO0eOO7HziEuToeQ0DtabKijj1khwwcqG0itQhGM3K15DRkBznASfZDFdNyeM60HdramL9JZ50Of4yEweHo5fGlWEWHMW8ApY+2u06+RHvDR5JQNmyUVfsqhFMj1Mdud7EpzPUIBpPvLu/4Qki6xIDrdIYu/yEdzdj8umbUYpi0jyh5poUah6r/x5NV2ncsUJkaSDcDcSmDQ6EYeC7RAQFBkFqUt281aAB9B4/+6wADk7Vk0wnddEw+ZnK46gHO7lYpfVJiBVvjbBbyGqjTXKCCMaV8Y8jvX+qcboJLljzioHbmdp8JiXKMUsoY6qCwwVFYEtZ/zktJP4x1N9YKMnM2sGajJE4oGnO8+ZfaQcHs7Q3FyL9LAQDXiBedFqAhw/FmaJ1fkvzOZ+aNPjSsNLtbIp2XRKG79F0cbE9Cpdlf8NWsjQcq/3vquO8t5NpCkZYuWvPx02nDHU5PAhFyLCPuixtaMQfYhwZVYO8dginJ8HDLhUG/0zO8oj0NbOHH6JgjETDSDLWaHOZ8pchGR5oB+OvQoR75GTyuRVdRcz0lhHs5E284/9fj8p2dh8d2VkDAB5gjhKBSQhUqv7cYRG5s36dS41oJ572QR+KN/y8cKRqyZthkKF97z3frRABO6UXvlRgwYF/qA1WmX8k8C2AT+mpDz1ndfoitRRuwwwUhiMwVI7NQ9YLwGOMoC64tAKmktVr8j1pLoHJ3IFAiitOhG3LnGPorrpT0ZA4QUBbsUJVjBoOyU7ME7NT5vdfeFr5P2wyZEByce8IIcM5SRUhn/NtLeFzxwbhwkkk4Hz+Gb4VcVAVdpf+Crld6hnnAJr9wo0SfoYkEqDJf/k4zhuAdTtc+fJLF908mJOIBrTsmNwQlv3VIx41PLtnlb2meWIBFhAdNaRS/N4boV4XnW29OsfCm2oAVx
 qlxuelsv
 kGcYhXOS2vV6ciafjwGEjyCIqtab3Gn+qaX3P8FDQq6+QjLXlojOSsF4O2hlJvFzem9l2J8oDIdaGSNQcEHZbcZ1m/US8e3ZAuteLmMuRxpRuomqRv/kNXc+hGamgMvO+1Zc9tNso6H9Z0Hb0AfddNp0Z45v/OwOOrmgT4cXCFXcFLYm32sMWH0fxOArz12Qm0MWOv5V2QVIyVkscMJDerzbR0x97pXzGvG4FFWoi+jXcFyVHl89rvwLXf2LW8mArd1x9SHQ2qOrKhjUAF1umCA6CjXgN/QKberpz0/QcRBM1736LMtJnFWgJ1bTv0eu+nfrdnPDJwRlD89US+yk9vPG2xrNxG4Xye4QMbbg0e1+7cK32x3/PgqkRxDHgphGbiMQ8y8eMoRVOVcEYyHQRY+PSEciykUftLd6t/eGffCuodX0KeMGZXfZgmg6vfaw0dhOoBa7tXNIXy/LnF+8oivkTkw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 22, 2026 at 10:56:45AM -0400, Johannes Weiner wrote:
> While trying to fix a reclaim storm in defrag_mode, I noticed that
> non-movable direct compaction is extremely inefficient.
> 
> When searching for space to evacuate, compaction only allows blocks of
> the same type as the incoming request. This is to prevent migratetype
> pollution, where a small non-movable request frees space in a movable
> block and provokes the allocator to fall back and pollute it.
> 
> This protection is reasonable on one hand, but the downside is that it
> makes non-movable direct compaction nearly useless: if we get the type
> annotations right, by definition there aren't any movable pages inside
> the non-movable blocks it is allowed to scan.
> 
> With defrag_mode, the goal is the production of whole blocks, which
> are essentially type neutral: __rmqueue_claim() will convert them
> wholesale on alloc. This makes type mixing and pollution a non-issue.
> 
> Fix the pollution gates to take the requested order into account, and
> allow whole-block requests to scan blocks of other types.
> 
> The only exception is CMA blocks. That type is sticky and these blocks
> cannot be claimed to other types. Continue to be strict with them, and
> allow only explicit ALLOC_CMA requests and kcompactd to evacuate them.
> 
> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

The CMA interaction took a second to grok but this makes sense.

Reviewed-by: Gregory Price <gourry@gourry.net>


