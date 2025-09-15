Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DC85CAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 15:58:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B46F68E000B; Mon, 15 Sep 2025 11:58:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF0548E0001; Mon, 15 Sep 2025 11:58:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DF458E000B; Mon, 15 Sep 2025 11:58:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 87D0E8E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 11:58:41 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3C3791606A1
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 15:58:41 +0000 (UTC)
X-FDA: 83891942442.03.0C681CB
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8F646140002
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 15:58:39 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="Jr0n/Wkb";
	spf=pass (imf23.hostedemail.com: domain of rientjes@google.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757951919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=k0g4OoEvxdlDb4NJg8OtNp6X6Rwb71NhohN1GOV4cTo=;
	b=pp3lFmb4+hMmLctubbF1scr+no49IsrOykEKPYvu71cefgloVxopwe+2yWLI2PERk4M3nq
	hxc3bxde3klSUKfIHSORGgjfn5f7CkSOxNIfmucJaM2e1hAZNi5rgCqKrO09ZXlObe1J7c
	ape33oGnwCUlAUjM6G6Nh+6JH2PHPO0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757951919; a=rsa-sha256;
	cv=none;
	b=hODL9hcWbm6tL3KF4+0Lh0iG/hBWVICydilxMSnxGBheAP4zpWQfMYapMYIc1EtEZd8lfu
	q6snu8i8Owwsc6tdwtePUOowYlDqQgkWn7Su69gmXnL75n+g2oKt6O11jvkh7UK/r+HaqS
	yRHseMjMeUtne3/GutWa4F6Ny1pmTkQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="Jr0n/Wkb";
	spf=pass (imf23.hostedemail.com: domain of rientjes@google.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-265f460ae7bso192625ad.0
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 08:58:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757951918; x=1758556718; darn=kvack.org;
        h=mime-version:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=k0g4OoEvxdlDb4NJg8OtNp6X6Rwb71NhohN1GOV4cTo=;
        b=Jr0n/WkbAOEBB2H95chIBAIa4ZVaotrjhGdxcxqItmRimhifjFGhZPbqqcafZ2k/kM
         Hle1d4BpjDNbBgbtWgtObu9uahsqutA7f+YrhJCfj+RvA7XNfUtjo3bZ5+ahd6gFw5xy
         L2oUoHP010BnaGTwChGXIMtlPqGQ7kIkMp79qGRSeVc53c+bn6o96Fmn3XeZzyFkv7ge
         9XPSH7LnfWV6FfEoHesiKw/QiMlnhtPxAxNN7VyWnwrUZwOJdYWWpXyoLrtFF+7ooA1q
         myvonMUtZ7jTllGYAH8iVtkULuntb/vcb90GLb2bxDM9H1SjmLkYWuhazblA+OlCundY
         OktQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757951918; x=1758556718;
        h=mime-version:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=k0g4OoEvxdlDb4NJg8OtNp6X6Rwb71NhohN1GOV4cTo=;
        b=Im1npSb9UVflpGp6JrXiJv2127VdLRmneYM7GagNiC2r8qYEhNu/r9ZRf7Q0Ro1uVw
         8QrVUskCjUNeKJAd063AU7GodqPeYl3m5Sv89uSHgIW+gBMW29BuUdb0yIyaHUqnrYKJ
         waAzS9lIZjpKJJcnp8yAvxDfDxXJU3mtfH788j/ryEbBHHHIdz8N7BwMs7VUqovVESVJ
         C2UTrrLu6vrkVR51cgj4Hu26gSxCpo7sJVjVQLacI1ZV2wZOdji7LjO2gVHkti6MKdth
         xOB0mP/kDsEAUCwEwAAveA8tPzKB/TKrV01X+vT+dyiFEeENrX7YkNdoEBUoX5cQQoTS
         3Grg==
X-Gm-Message-State: AOJu0YxabLH1FKispgcDiSyUFPGoAIfmWM9q1E6JMjJgWdOdBu0yqPVH
	u9ccRE4IGX1/uuuvuLzjDDgc81JPTqGF5h7CyX2YcBiPrV/n2/uYIfL6ybHB20oVfg==
X-Gm-Gg: ASbGncsuQJ61Vd06wyQDZSllSoLMMWIgGoyAd3S6yl2y6o2VnZ9bXM8DOGAY0pM3PLr
	S8V6WqNO8giSr1daeaYd8gTA7Kq7k7TO1mh3W9jK1F6Vh0bQ1swr7gemTQlsDnb11/2sV49K+wQ
	Cpv/b3nYjVenZGDbKzBhtyqGBex8gJHLGoKc/hsjCv28B7AkumPYzOqUFICFUxjW2cYeCOxnEV8
	Nhd0rylp+Pd/BdX9bAZNPHsO9JmjeKg86UJZjKkJ1oQjDzgFbZ3GeuZ4GhBaPtzXy4KYXD5Cieh
	z6j93Y7Tn/Rp2/QHiUFURPQNh/Tf4di86OUX0QXWQyopBSRleFHIZoZX7E3vHExd18qBl2srGed
	JZK2Qpjf3THNHejOrM82zGHvmy2GM0F69v0DSQNXebufN35UPTRZowa7AnOxPGd1roTFV4yASXY
	bFXup5ET0aP9/yQm8hrCinYPP99wqaQR7Md6IsIOqgj6C1SzRI/xuVL/Y=
X-Google-Smtp-Source: AGHT+IEfvIpPnkjoCCjtntBzhTF8v+RSBHyssC1kXhvHP8wWlYMzfjEiRn54ikZqUshcQv8+DOG0Pg==
X-Received: by 2002:a17:903:1a70:b0:264:f533:75cc with SMTP id d9443c01a7336-264f5337b2dmr4321315ad.0.1757951917870;
        Mon, 15 Sep 2025 08:58:37 -0700 (PDT)
Received: from [2a00:79e0:2eb0:8:2665:4fe2:6854:b9e1] ([2a00:79e0:2eb0:8:2665:4fe2:6854:b9e1])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b54b5568a82sm8266942a12.34.2025.09.15.08.58.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Sep 2025 08:58:36 -0700 (PDT)
Date: Mon, 15 Sep 2025 08:58:35 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: Amit Shah <amit@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
    Aneesh Kumar <AneeshKumar.KizhakeVeetil@arm.com>, 
    Christoph Lameter <cl@linux.com>, Dave Hansen <dave.hansen@intel.com>, 
    David Hildenbrand <david@redhat.com>, Davidlohr Bueso <dave@stgolabs.net>, 
    Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
    John Hubbard <jhubbard@nvidia.com>, Kirill Shutemov <k.shutemov@gmail.com>, 
    Matthew Wilcox <willy@infradead.org>, Mel Gorman <mel.gorman@gmail.com>, 
    Michal Hocko <mhocko@suse.com>, Mike Rapoport <mike.rapoport@gmail.com>, 
    Peter Xu <peterx@redhat.com>, Raghavendra K T <rkodsara@amd.com>, 
    "Rao, Bharata Bhasker" <bharata@amd.com>, Rik van Riel <riel@surriel.com>, 
    Roman Gushchin <roman.gushchin@linux.dev>, 
    Shakeel Butt <shakeel.butt@linux.dev>, Shivank Garg <shivankg@amd.com>, 
    Sterling Alexander <stalexan@redhat.com>, 
    Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>, 
    Vlastimil Babka <vbabka@suse.cz>, Yang Shi <shy828301@gmail.com>, 
    Zi Yan <ziy@nvidia.com>, Eugen Hristev <eugen.hristev@linaro.org>
cc: linux-mm@kvack.org
Subject: [Invitation] Linux MM Alignment Session on kmemdump on Wednesday
Message-ID: <426751f4-428b-ed01-509b-d13e719a2006@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: 719134qjmcanmpj9syya9xup4adcbt7d
X-Rspamd-Queue-Id: 8F646140002
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757951919-746150
X-HE-Meta: U2FsdGVkX18llq74ARiWMEAVymRlDN48XYF/4Y+DLT4YbpZkIyEi8CRotssJVws8x786t9VUlt0y5Sugsm2t+6bIXBc/+uEjlMve0XM3Dj5setXF/cw0Op4QvuMskSHH+xkA3CGEIeB5V954r7YUDBRHzq5K1AA72ICVmdBzgcTuwNMcO9OGoFMT9qnC6VSD87DqT4ugkYMqe2xOUHTT7R7M+SpFmEDbuIQc9mybHjAuirei+1pW09rcEYAB9ivdqjDVP3n8RcyNqKNpUoiqCBhnsx1dGbj3xJrLrgk3AO/J7szLZW7iHyZwqUFuU/e928g3O2WZDijv2JS+FVngG22WM9R21KEoDfnK94+ojxj2835YJHRCuczI6LBsnEMzX37bi36VU4Sqs72KrqaQlmpKwqyJN9ByJfTP7N4VcX8nYefuLRfwBfZLJwlGjBWbf+14IqrKOkYAOVx21fa6vyZguSIvqX26Trmxs8o1fPvsHooyzi/gPRFPcEbQITQSKqdGBF2fUzFtB5QXCSHfIYdBCPPiE/bpALWcmUjWZGALvLE2iUhb5eUTPKy36T8xiwSUQyj2sxrRj3Eg6YOd6vCiNlKqE6ZGtbJxa5UuiQOhVm4pjX6Os9iz1txOcabGEkU+rZPAarGuZ4v3UPTENipZLY7ko8i3Luk+9JDGZ+vq6B0bmOp1P+cVfGDWzUxwQkF2RyHB8Y8zWcf8WsPoGeO6skeOl4qfAEIQUMgDKli7fFRF5wj2pLocx/hh/mBw7EKqACIaPJgDcGK3oNl224NOPOKrNw8N+PklTu75PuUHc98tdoSIDF8Pf5Y97/7W0THCz9WfGrFZVz0d/R6pVx+YlTKtzEmgNvtMbTK7inTODkZN2kksklAsClBcStyIeqWl/UnZXSlVZOc/XzLxZqXte4MMHiywjSD4odlDCfBUDxUJ6RzNZOZvAEjF6BYY2ePEdTl5hcOTclxKysi
 YxPCnjZ8
 uL2D1vcmrY5ejD7DjvgEK6pZECKylMkP1L2MLbhqhsP0zg7sIPbHuLOHWxGhGzFerCp+ROnGbXml46d1l9cTrwd5EpBBvVgnCAKYv17rmnfNYyC1TeHJKMKe25CTtZOTY47J3XadobE6P3+ZBBkQxCE076SMZVN9J2yGTHy9AobpPWQF1NRwmHJvpBr6bTDzsybgrgdIhA+AnmeqtuqR6U3/iOV9M+oP6I/9PnDhDppIoAinEIMuROGU5BT5MdFMbQn5RiGt4ISG0pjtS1iG1i+9m1nYxZm+sDitFsoi4MA4kB+2SkJkgl94gmCKMu1xBJDipvB8SKXlj25naXqXfr8SaZlff9eW0P4kRvww2U9KFAtqp+/4b6QPWzmfKenaipKE037sEt5sDDXhOBsBcDrpH0DSGWdRkIv2vCp3qed59sjnFlVKsA1YflzBNnASDuwuxc0WrOwXU87r6DVqVOksGmXIV0qLGu+OwRESBMTAedbu/FjQ12pOO6FHy2PSy9TtLEJRJzOMXUOz4jLwV+IBhHw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi everybody,

We host a biweekly series, the Linux MM Alignment Session, on Wednesdays.
We'd like to invite MM developers to attend and will announce the topic
for the next instance on the Monday prior to the next meeting.

Our next Linux MM Alignment Session is scheduled for Wednesday.  The
details:

Wednesday, September 17 * 9:00 - 10:00am PDT (UTC-7)
https://meet.google.com/csb-wcds-xya
backup: https://tel.meet/csb-wcds-xya?pin=1301132214803
doc:
https://docs.google.com/document/d/1QQfZFPHa-pGEGf4A06cSqS0jdJwuZ8ro9JU5H0YSUQ0/view

This week's topic will be kmemdump led by Eugen Hristev.  See the latest
proposal at https://lwn.net/Articles/1031319/.

If anybody has ideas for future topics, please let me know and I'll try to 
organize them.  We'd love to have volunteers to lead future topics as well 
as requests for MM topics to be presented.

Looking forward to seeing all of you on Wednesday!

Time zones

PDT (UTC-7)		9:00am
MDT (UTC-6)		10:00am
CDT (UTC-5)		11:00am
EDT (UTC-4)		12:00pm
Rio de Janeiro (UTC-3)	1:00pm
London (UTC+1)		5:00pm
Berlin (UTC+2)		6:00pm
Jerusalem (UTC+3)	7:00pm
Moscow (UTC+3)		7:00pm
Dubai (UTC+4)		8:00pm
Mumbai (UTC+5:30)	9:30pm
Singapore (UTC+8)	12:00am Thursday
Beijing (UTC+8)		12:00am Thursday
Tokyo (UTC+9)		1:00am Thursday
Sydney (UTC+10)		2:00am Thursday
Auckland (UTC+12)	4:00am Thursday

