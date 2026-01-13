Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2C53D2D0EB
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 13:05:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 361396B0089; Tue, 13 Jan 2026 08:05:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EE416B008A; Tue, 13 Jan 2026 08:05:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F04D6B008C; Tue, 13 Jan 2026 08:05:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0C82A6B0089
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 08:05:01 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 995BA14013D
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 13:05:00 +0000 (UTC)
X-FDA: 84326960760.13.E96E293
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf15.hostedemail.com (Postfix) with ESMTP id C8E40A0003
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 13:04:58 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=fvvK8xWU;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf15.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768309499; a=rsa-sha256;
	cv=none;
	b=JupFEjLw4soWPLheFlm2D2Hs6h4BfjVyy+hkrXPx6YjMsWMzoz9cqFY+tN8+yWeXnQjJCZ
	seeXNgCikLC8bDQUOqdjtTpeTkbI/BnXezwNmfZ3ZR8dahK7TqIt/u1HQeHOnJ46wL+vUL
	DgBYHN7T7pXP7kAOEjBJ2cn0Bc6wP80=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=fvvK8xWU;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf15.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768309499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DxmC2pl6C99HyG7ZtcQQ6tBlfEFY9dcUww524xGSm2w=;
	b=KWqb93KcEnmxIvlJ5p/94Kbegf8ue1VFfXqBIb6pCCw5d9TNGXJLEa3F9/dzSVDkp+xOia
	1eHsKtsrOLU1Fo2iYiHzq0Ns9Gw88fmtRVv2hXfT52kMXfIFLnxtgfu/oD4c1r4GS3Y6pw
	C7+DasKeLyNUdk3UNB/sH6UdOespb3E=
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-432dc56951eso2550188f8f.0
        for <linux-mm@kvack.org>; Tue, 13 Jan 2026 05:04:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1768309497; x=1768914297; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DxmC2pl6C99HyG7ZtcQQ6tBlfEFY9dcUww524xGSm2w=;
        b=fvvK8xWU62VOrF4/+HrFqKvWmZjm6jlUva71vwmuKhtVMnJIaOBsWkScM793kwslnh
         mcESgBzHKACa1n9OC0m1qR3f41Lrd+kIryPC5V46+wbBjfLys7Q6ca1wyDVxuMNscOed
         ECYL3gAqjY3HFB462SU22xHGusEf7jlrim+XzKm4p1e7gl4LpnFgXjqsBhJ0YHwUaCfK
         PISsLA1v62TGBRMpy2T4ENrK/ACJ9dqvYRBYYDbXQebXeolw3V3Gbudp1Fe+2FCuJD/1
         WVKHWX7x+GznSXqXy2l1YN070irPFl+PmTFM6HQuwkcnngbWJfZlXuUn+ZNhCB3SV4IN
         7mIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768309497; x=1768914297;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DxmC2pl6C99HyG7ZtcQQ6tBlfEFY9dcUww524xGSm2w=;
        b=wcs3d8guMgPEnTqGyemkviHptHERRMzSiSjZ6k9zQXSP4TScrn9hqYzVjvEkqAb+WH
         3zWD8RXuRUnyPHsFJKGFe3M3KLBELXyBqjA1dHxTZW1450Ccl5hHyWK79ox4yB+S8OQK
         4wSnqwLRbfgocg7zMuWIbk2gYerUg23awJIPAKt8hOOA2pf3gzzmu5LzFRNqMQ2u0p7F
         Zw24eLfj+7AIJO/7DvvJTa2DgAdwa+f9aM23L/CD58gI5DQqtru9eoLY1G8G74LsGRq5
         BhNuvjEUBLVOk8k6wNgDvtGcbU+KaVfmMcU9hs05xixgvmZGbQ9uQJv//+qFK6nQqcLQ
         5+/g==
X-Forwarded-Encrypted: i=1; AJvYcCU6DtQAgxZd8r/U5i5XxmPejlNnM5GEMSUSRi+WFhQ4n9YeEl9qeNJ0u4WUQsUP97Z/bPCndrKHKA==@kvack.org
X-Gm-Message-State: AOJu0YyH9hZP5z++tfH2CEXP2KbbjlrfMPWzxbuhPVYWuPtnmg33SYE0
	vghHl3pyPvydprPO1msBk/jqFhvmPU761WDgYMXrBLg7upfk6ZsWs7vW92+YgOH+yrY=
X-Gm-Gg: AY/fxX50hQ5qvOIn+lLxQgJ0PkEI0b1W4rmMChbtx5lwDcmhB6PcrMmGXgU0MTvreLw
	Tx7F7+x7eslF9YLfP2M4LA+ITb2lgsX+8SW8xHIhGyKnUPzEDR6jCrxDYK5G2bK6jg6gFVqOvht
	XqPN7+mUu7ohkAAreZpfnDZAuavxMB+r3HoyOpWpxliSWbceAoEN/fNBzixncRyEgtRThgNmdSU
	XbReonop5d8TIuH77tHplYyseCUEUwHSVPWnu2RTDom4MBbnlA94rR8riBH9eCAuW+2jDOqjQYr
	XbQgAJxRSIr6UMztRkI3N9Jr+m7DnJCpxWbVHrRXTByS4ku2DtEQtS3gA+ANNABUPS1OqP6Pu8A
	P8kjrh5mWXIxZcb+QB3um13tepwMpnikeqJnOHK04pjU6rBWzjR0UXMM8J6w7pNKr7tXEiAiume
	VMXtq6ClsfmzT2wJUfoVqYk9vJ
X-Google-Smtp-Source: AGHT+IHYXSfKeSyIbDj42AJBJmOhERkm4DTvIbdJkdpUx9cQfI7l/3M79m07YpjVsO6HUGzDbyppzw==
X-Received: by 2002:a05:6000:2912:b0:433:42d1:f71f with SMTP id ffacd0b85a97d-43342d1f736mr7036326f8f.38.1768309497141;
        Tue, 13 Jan 2026 05:04:57 -0800 (PST)
Received: from localhost (109-81-19-111.rct.o2.cz. [109.81.19.111])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432bd5fe67csm44077240f8f.40.2026.01.13.05.04.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jan 2026 05:04:56 -0800 (PST)
Date: Tue, 13 Jan 2026 14:04:55 +0100
From: Michal Hocko <mhocko@suse.com>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev, david@kernel.org,
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com,
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	chenridong@huaweicloud.com, mkoutny@suse.com,
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com,
	apais@linux.microsoft.com, lance.yang@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v2 00/28] Eliminate Dying Memory Cgroup
Message-ID: <aWZC9zfTaBvtAJ0B@tiehlicka>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <aWUDXtsdnk0gFueK@tiehlicka>
 <7c47ff99-4626-46ec-b2f1-f236cdc4ced1@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c47ff99-4626-46ec-b2f1-f236cdc4ced1@linux.dev>
X-Rspamd-Queue-Id: C8E40A0003
X-Rspamd-Server: rspam06
X-Stat-Signature: d3g6p37xj8enqeg47oupkgwam3pafpjh
X-Rspam-User: 
X-HE-Tag: 1768309498-798944
X-HE-Meta: U2FsdGVkX1+MM/7UxaBh8OZcluqSTmKzbaBopwGFNIROwJHLxtJpNyeAOEhnd2bjfcJ7fKi1ugfcyBkkDfu/lsp1+48GlFJBwqKxlxVu6aqjJKtPHu3Xs/fdSBnSus3nIdFMglYqvyKGmKs+1w/Xh2VsTD26A5umGnLJ8LoQ0Hr4d9lvkB/p3rVjks8JORr3OIddJAYKubX9vN6t/RDbC4Ct7oul/qaAGBx1q5uR515bRrNGj7zseoILvYzhJqH4kXkPMyl10avFjLBiZ6zjg4QNiJ2FyV586TsshAcSBUvgOrVhc1JwT6QKbHIbXRk5e56x8QYBj0JfRAFwPOzBCFNdHhvu4J64En5KT61sbKSu+9nWmzciuTnqYofcPchpS8h2aJeKl7P/6Fx3mon0lajwRB7s/e3NdO50oCQVDtBDDSUfLRL+BsJ21ij+hX7u+Vplvuy6IKsBUAaAgl58D/VBW7kwIAWYw8lRvYgRH49/phI44j9TCqTAynBf14NL27QlehKrimM9Z8OKNCWHfyt+Pjzhs2us9uWZxB2lTjKv/tDqXjOrHpRcl2jpZwg+YjytDgYfLVFp6+izzhRWWv03xY+5rhi65sjgpNPAJRvq9TsbqJEt6jYE6S9uX53cx28dv0jMyWuyDeWEn1OYV8yVNoluoQe78zH5KPqqsX/M7MwcqJ81EPbdIt3476/5oJ6QYH/VoSAkt5a6J3g2ljn1NfBSwfLMajmOHUiSCr4igX6hy2qthVcLoBqfJYNs5v4wBiUwfn8BPAcZ8xQ9g/bEEKEaPvPDKYTdVeFIhkzpV/1QjraYEEixDIgiyxbgOTH1fg3kNNGsFPVWc76CihkoVBOj44ez2YdeOWwS/0E6exi1uxjHCzMA0H6SR753HFv4HWGGWctaoUvsOTwKMSvYujNiUNULJX8palnjTYIW97Z7ZOiN0thlDUSjBEO1wb+hjcwERo9mUpNQYIZ
 I9DKiAR/
 xft/e9EIfUCgdjpKOzAFjluepHQxj06xk7woMwA8lwb+hTEuF/2AZ2ZGdaw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 13-01-26 10:34:08, Qi Zheng wrote:
> Hi Michal,
> 
> On 1/12/26 10:21 PM, Michal Hocko wrote:
> > I can see that Johannes, Shakeel and others have done a review and also
> > suggested some minor improvements/modifications. Are you planning to
> 
> Yes. I'm working on them (mainly non-hierarchical stats issue reported
> by Yosry Ahmed).
> 
> > consolidate those and repost anytime soon?
> 
> I'm testing it locally and will try to release v3 this week.

Great. I will wait for the v3 then.

Thanks!
-- 
Michal Hocko
SUSE Labs

