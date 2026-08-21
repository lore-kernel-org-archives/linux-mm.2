Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C08D9C5DF87
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 09:25:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9245A6B009B; Fri, 21 Aug 2026 05:24:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D54A6B009D; Fri, 21 Aug 2026 05:24:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C39D6B009F; Fri, 21 Aug 2026 05:24:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4E48E6B009B
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 05:24:59 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BE107C03A1
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 09:24:58 +0000 (UTC)
X-FDA: 85124742276.02.791F087
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	by imf22.hostedemail.com (Postfix) with ESMTP id E38CCC0004
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 09:24:56 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=BDCFZo6j;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf22.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787304297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xrvJ8t01wSuPVhMK2rhUOR81NuGr3NcfrpigUqOVjnE=;
	b=hjSCS2eKZ8136ejEAL3FNrqX5jbCExvnF840VY8YtFhhfbSX5wF3zaQg2p59i8bW+Huqwn
	Vj+PSml6Ss2oRvRzDUsg87NC00uRiJHrDwIXw7PXM749rJOmD2Y5sK/TohVyCJZ2vcsdjD
	jQkM+N06mPNUhvYN3Ic36XL7qNlhOsc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=BDCFZo6j;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf22.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787304297;
	b=IOb/rcE8/n5ZbrfeBf+J+1dBOWxBUqQHMcqtygJ17o1XVzpwRaZprHMRFS+MhkY8fHsAJv
	pynegfF1yZnljyLjCKSSgrZTweqtAeyPpzQsxfcRFqLYsLmlH/lBMrwLfJpYINymFHXyc5
	W/GpJun3ZxdFd6IYy2y4wd5ul1uEW+A=
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c197e7e4e94so152515466b.2
        for <linux-mm@kvack.org>; Fri, 21 Aug 2026 02:24:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787304295; x=1787909095; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xrvJ8t01wSuPVhMK2rhUOR81NuGr3NcfrpigUqOVjnE=;
        b=BDCFZo6jDYy6oUgLIZtZI/pJTspCYcxVnZxSqBlpCIVuiFDPiibbLWAancYJVlU79e
         zPmCOl/nga1f7C4TcNnE1SSlueoHX6a0/c9a/LeGiLhONFznZ2mxGAdj2SVQWjiofFVT
         kz1+G8L7951F39hq9/7iLEM6L8b06pJ8hAfEbUcvoU6JZdf5oq88qCK7KHwsuZCjba4K
         fF42DqjRovr+yrdg+MX/iZu97LgkskghLDfyFiO7+0fXIVgwLzm65FuvMjFY2ZqsDvaN
         KRztn1YPssbMgVrdiLGtg5Su4QrYZ5QMr64vAIdwHDQ4LA6GxTn1advdlozlLATY4hW8
         zcTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787304295; x=1787909095;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xrvJ8t01wSuPVhMK2rhUOR81NuGr3NcfrpigUqOVjnE=;
        b=ZyHVpFgs4vC9xWdPKYXULmZppVlhTtBQNZJmPXq7xtURvTo0m4k+wUuoh8HR4KXaN0
         rBosNXG9icpRV++tthRsQWozVemHgQE60Y9B6QTX2Rxsxc2Vp/6VbZ7nn47mFm+2hKPS
         q9BaTGN9S20ZbW7Vm2tTQBvgyolgEQi7+p39h1Fdig6Oi/Gm+x+6l7NdtEmMCbM/xA/g
         nLD8hI2OiXNPqV4ClJsYaBpQXPVCTBexSesi075AYbsA5pYv8zJFMlgxC5+T512XQioz
         zHG56mqCaTzhr/cBS26sBfhhI8sXMsEX8xG7bZZ0ST2E34Ahf2WRTmLxKYeWXSIU5E+n
         Uw7w==
X-Forwarded-Encrypted: i=1; AHgh+RrXl+KzcjBYh0wzA8WXfikvZbWf+cLJyDyMF+bYWq4/MvIPZjwLwNNnvcKX+VYkuSU7EylvKqs6iw==@kvack.org
X-Gm-Message-State: AFuF++l6O5hAKPDpz3hamtZjABsjcIMQ5KQwC9VrYjqqHENtmZNEl9yI
	cEop8X5+edxT3VNzt15297SazzTdtvCKH7rPsg4T6G4lBuWSast5h9TbPzQwYk45Dqg=
X-Gm-Gg: AR+sD13141KRZrAs+cw2q08TYhB7dlzHpFKngD2YxqwaiED8o0m6Od86N0uuwDSe6ua
	rWNaZiDcOlZMuL+ycWEJqwYvSxdlUxhBxQV0/effNIyMuHjZXCBzFnMUmh2nXVXNIjNnFZbarsc
	GqXejMLKwwWeqqtJWwSHmcfcYcpq+V0FRabQgViYur8m567trGYov+elYUbfidfGFHMNUAH+YAi
	eN4mzzIJ+8G4TIeQAfPHPBVsxUQJpQE+HWnSBTWZXelZCw0qBpy7BCYWtAKagjhk6djCnVypxUs
	vHDAoEcGIgwGjDwazfXVrs4h4/BvONMhv/ItSQARaDxNYpkvz37AGqb/qSYYXdbGcMzUb9Vkss7
	47/Miv6X1MDQ4BTeJJw5cQ+KnWPTA8KQ+vF6S/2sLECuYLJjJLc9Cw+MEsHmn8qlWxYIeYtocQw
	ao29QVInQSTJdYjVwSnz22owGPFu5hODhFGPN7c9uivIARiopx8fOLMU+h0SUeZgHSFHke3MydL
	K8l1Lxoe4Hi
X-Received: by 2002:a17:907:9495:b0:c24:7cb5:d617 with SMTP id a640c23a62f3a-c247cb5d969mr246787766b.1.1787304295516;
        Fri, 21 Aug 2026 02:24:55 -0700 (PDT)
Received: from localhost (109-81-81-112.rct.o2.cz. [109.81.81.112])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c24591e037dsm385915066b.52.2026.08.21.02.24.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2026 02:24:55 -0700 (PDT)
Date: Fri, 21 Aug 2026 11:24:54 +0200
From: Michal Hocko <mhocko@suse.com>
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [RFC PATCH 0/4] mm/vmscan: honour node reclaim limits per type
Message-ID: <aogZZsXwCyOXISaw@tiehlicka>
References: <20260821081741.1340277-1-ridong.chen@linux.dev>
 <aogMyu5R_DZRqp2J@tiehlicka>
 <f45848da-9569-453f-b0c0-8aa984e1976d@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f45848da-9569-453f-b0c0-8aa984e1976d@linux.dev>
X-Rspam-User: 
X-Rspamd-Queue-Id: E38CCC0004
X-Rspamd-Server: rspam07
X-Stat-Signature: nranxakegx7is331t1yr8ngtsd5aoi56
X-HE-Tag: 1787304296-661076
X-HE-Meta: U2FsdGVkX1/Jw71/l+WLTK+7DKH1WKMhLjMWYMIf7x1B2f1PHjp9eDBTMdm3Rz8yrPd0QolbZYDScDO4ES4Xt0sLBupmHCPfv5rgHt5gZBjC+FacOqiXZafLOqdXwE21g4DmDdXLifXPoVucOjy1kjqkJ6h2jvk+shgLpvsoU7c9jqg5K5H1ej6qmSSotETwVhN8/KxDo+J43vyCri7eWMLe6dx7eP+mhrgire0x1HtSfNjQSD4rd44ghEscjDx+THHBBAx8TrCqbJWMXR+ME8hfSQjUyvJnLHXges60TBlTVhmbOGJqq970geww0Au1Lh2+fXkQ/45x+23Ermlj+0f32KGe8raP0mw2y/kLJTnUDnGRi54U+2wtNwaMbDB9wiEBX1IRRJdgvSsZD0C+EbeLzvR+L5jMob6IEnQg6Xg+H0Z/1hbihHrL2oV99NLYy6EDaOjl9HENA0tQIMudheQZahxqXK58clr4cXMexC3uB5MGL7LoZ0MDGX86fO0xt4hZf5elPOCtcKOqhBK41aFWAwrJsilHMCFeX9gQ2hr+A5ChcBAFlwrupI3yDetKqdkqjJzskIu6rx9JbrlxJZuRrJUia/5ayQLSpykT8j0nUPgNBwgpid3Kt5M249IHyFfjPeSne9tJJDfRu8SSnjuIam38tIdbgp4gRykNtfa0ZhRGpjf1eB/Q0VfJcfBMeJ+l0naZeCru8OPUBg/vMjKBOLI8inF2hu5SCAT264QTdS6U4lcDUyU2QKN1FXPoH1eakPrYv9A/GtD6L4xHO7l5WWS5MtDoAhjNxH1AM0+4JDkFU3yIEvI8z0eszKDJ1exL6iO4q8ZP1VJQXtaPy3ZlIkTJ/suoVGfHoD1aUizkBc1mkwFH+d7i4HBm12BytW4snQca58tQ0BKxrOhzPbfgCINIJKVwnlkaMIqbLpK19JUjt/Xn7HS1Lmyr2fgmBusZ2FHl8Luym9EYiRb
 T86/2o1M
 lg0rKaEPTPGwdVqMS3O60On6JRR1rZzUDpmkz3Cn11AgIHyqLcbNWyQKazqD423GvrsUKgEqW1f1Qn+zgMdQA6PfdBtZ5ON/hcfUClVaqUOSe5nWNxYitU18yEcHxQUWLII+SxTPHyEVNroJsczOcueR5Bm8s1e5ztVAacTV/ToWbmchb6jzM4uAw50Dr9Mb1eiTRzf56L1cP2dKzKvuuBc7Y4/Dac7rSJu5FiqHHk0rBAj41IeUvywpnK8ddpqkCQFFZ6+dZMIV1V/4Zip7OybmfquFPxqfHB2NhWaE5cgnR+nmjkQutTT97ZULp6Btxu+CcLsBv3J+GI1of8g511TELN2QO2vQR5fDlqjE0rUyCIK/cPLBs9shlW05xuJs2cevh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 21-08-26 17:07:32, Ridong Chen wrote:
> 
> 
> On 8/21/2026 4:31 PM, Michal Hocko wrote:
> > On Fri 21-08-26 16:17:37, Ridong Chen wrote:
> > > From: Ridong Chen <chenridong@xiaomi.com>
> > > 
> > > min_unmapped_pages and min_slab_pages are documented as per-type limits,
> > > but node reclaim treats them as one combined gate: once either is
> > > exceeded, shrink_node() reclaims slab, file and anon together and pushes
> > > the other type below its limit. Per-node proactive reclaim reuses the
> > > same gate and fares worse -- with page cache and slab both under their
> > > limits it reclaims nothing and returns -EAGAIN on an anon-heavy node [1].
> > > 
> > > This series gates each type separately via two scan_control flags
> > > (skip_slab_reclaim, skip_file_reclaim) set only on the node reclaim path,
> > > drops the combined gate, and extends node_reclaim()'s early bail to check
> > > anon. The flags default to zero, so kswapd, direct, memcg and drop_caches
> > > are unaffected.
> > 
> > You are explaining what but missing the most important part _Why_ do we
> > need to have this addressed? Is this just addressing Sashiko review
> > refernced below? Is there any real usecase where the current behavior
> > matters?
> > 
> 
> Hi Michal,
> 
> Thank you for your reply. I should have made the background much clearer.
> 
> Yes, the original issue comes from Sashiko's review. Sashiko found that
> proactive reclaim fails to reclaim memory when the node's unmapped file or
> slab pages are below the minimum thresholds, even though there is plenty of
> anonymous memory available.
> 
> After further discussion, we realized that min_unmapped_pages and
> min_slab_pages may not be used correctly. Apart from the issue above, there
> are other problems as mentioned by Barry in [2]:
> 
> Even when page cache is below min_unmapped_pages, it may still be reclaimed
> as long as slab is sufficient. Similarly, slab may still be reclaimed even
> when it is below min_slab_pages.
> 
> node_reclaim() cannot reclaim anonymous pages if both page cache and slab
> are below their respective thresholds, even when there is plenty of
> anonymous memory available.
> 
> To address these issues, I am sending this series to facilitate discussion.
> Your feedback would be greatly appreciated.

Those interfaces are relicts from the distant past same as the node
reclaim. I wouldn't bother fixing those unless there is a real usecase.
Pro-active per node reclaim is a different thing and we should probably
divorce it from those min_$foo counters altogether (if they are not
yet).

Same as checkpatch.pl, shashiko is giving you hints and you shouldn't
simply follow them without a deeper considerations. Consider that there
is review capacity required for any patch posted. We do not want to
waste that scarce resource.

-- 
Michal Hocko
SUSE Labs

