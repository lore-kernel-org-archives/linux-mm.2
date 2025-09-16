Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 977B2CAC599
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 15:28:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F18A18E0016; Tue, 16 Sep 2025 11:28:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF0878E0002; Tue, 16 Sep 2025 11:28:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E06828E0016; Tue, 16 Sep 2025 11:28:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CE9968E0002
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 11:28:42 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7328C118CC7
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 15:28:42 +0000 (UTC)
X-FDA: 83895495684.21.4522138
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	by imf24.hostedemail.com (Postfix) with ESMTP id 796B0180016
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 15:28:40 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fxUdDw1r;
	spf=pass (imf24.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.175 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758036520;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+lkVUCKscU4LdhT7ZZeIBczUpJ7bTCoNz2jaUueMz7Y=;
	b=q4YEtAfkSIa0ES3TGq2bo6jtc4Gufqj10AuxsVl7CnAG1JO3YmPQv72YkSxzD3zc0a9z8s
	X7rhbXahQKQUgLzLbw75DYWc7qzARR1YAvh1GALH/m8Z9IrOElU4S/5dwqXZPuAbIzpI47
	dM0FndvwkNhNXvlckX+B6IoSIsmENbA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fxUdDw1r;
	spf=pass (imf24.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.175 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758036520; a=rsa-sha256;
	cv=none;
	b=0M9FFMu64gaAQA6JicgRO9tzEpJ9zAUHZWigH/AdDVSY+Xe6qn5VblZ1hYE4Evy4QOHWXm
	hJCFs0L8RRIlFnBp9pNYSUrdjGW551sUVmYgqWfuRmNnWhjS0KOdx+ErcKNMCPs8IYfg15
	Hxxp7uoHlc6TO12aRPsq9ovsW3qv9Q0=
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-351f5cec42dso35004111fa.2
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 08:28:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758036519; x=1758641319; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+lkVUCKscU4LdhT7ZZeIBczUpJ7bTCoNz2jaUueMz7Y=;
        b=fxUdDw1rwS6gVwxiO2mxPjEXV/6y8MqXUgXqhiWx7yXYEIqukXAV4gIFYqLzRpIRCx
         2O+2CUXmeHlPNe0RjjYlxG0Tjipf4Nx79uWzGuL+S4D9/WQiohHe3SjyEpnnq0eOhtDK
         qJrAzBWm7lYXTK1AM8galG6Kh3BbLVAsfCCpXImKV1Fxhv/JGOffa/RDX5T6zPZTFYiX
         Tpoo9S+uu4rKhsu4ilRIUO/vjPeDcprP1qSVN/YAA5OovAz6KKqiQwDFkq8bUheWkgdk
         Q7bvgymNRUlVa0cAR/McfaNS/XHc3E38xJNE7Tc2nrag1cdI/ja/YVtwNuXSo9+8DBEy
         I1Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758036519; x=1758641319;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+lkVUCKscU4LdhT7ZZeIBczUpJ7bTCoNz2jaUueMz7Y=;
        b=jDPyVPCasmp7i7xqSXQUvYGTw2X+N01upbfUmDjFYLkJBZD8hLSw+EjYfZlpyHs+AK
         Zl1WyedzsK6XLXqopd77PdEQsbf2rCuEsqeu/1INE8obKOa2sXcFYYwztbB01+9Jxy//
         GM2dnv8zZsYJDDZYnsA+jIxLFOYtR3Yc9yqHanY5oLsDTVb4xt0SUuu2WXjtsyWeVyWu
         IV6CWioMqB9xhChyJq8rgaOH5s0xqraf11bcLbUxrOd7BN9rWzI/nL2G6jHED+x23xRW
         Hd2kMiwJDiCBgI3vOHW9QJMGMNIUmU1czA0zo3hAtouUKRShk7NN318pBxEsqwSyptxH
         E8Rw==
X-Forwarded-Encrypted: i=1; AJvYcCUqhtgw36QAIFscp5SDfsCcys4UfFu2dX0uHHQwYjLavazeJmQy7ZhFsMFZAdiuV/a5sofHPRunnA==@kvack.org
X-Gm-Message-State: AOJu0YzEocoofqeELf183E0THbIrpyfrR2SeJj7jFVomtXJaDoPRsizq
	xa9DqTIOunPI90hMyYlH/noAdGfnWX8Ok8JiuwflXSEXDqfP5l8qhcpc
X-Gm-Gg: ASbGncuTVcZxsML6G6PManPIKYucAlnpr1WxISfM/8Ef88GGYlIVXvOT5NsttD5ltFr
	a1kN56hUi4itdZIyaY6YC9uIEtMvIyW8bTkEpO1ktPqyVeTMDpA6FE/NRLB06xMZwMbGxYgCPoq
	yPLwTzJzu+h0OmlwElStIZ+nEOMryR3stAIxdr3PFlwtY5zqmXXVgSsiGoK41POS4bTBtD28RKx
	5cavHvQLNph6Y8bdQAEAFey1JGFc1KZVLBvh1+0Qc0STS0zKfNU5LdbX+sIZDBz0+sT245vGBME
	lg80NY04btg2CRapA7DMCdABUfQ2UPlfy5L7Z1yzH+v7V7CeJizqzZSuOwK0ZWQrBQ==
X-Google-Smtp-Source: AGHT+IGt7r2a+wXhhK7ipCX/Lf94HHFiWDEXgmqdygMMJMgy5MAxoYQRX0uAJHvkbWQZEpkCgmb1uA==
X-Received: by 2002:a05:6512:24cc:10b0:55f:701f:92f with SMTP id 2adb3069b0e04-5704a106293mr4503294e87.19.1758036518466;
        Tue, 16 Sep 2025 08:28:38 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-56e5c692daesm4540326e87.26.2025.09.16.08.28.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 08:28:37 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Tue, 16 Sep 2025 17:28:36 +0200
To: Michal Hocko <mhocko@suse.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 04/10] mm/vmalloc: Avoid cond_resched() when blocking
 is not permitted
Message-ID: <aMmCJOJFMTuCXH3m@milan>
References: <20250915134041.151462-1-urezki@gmail.com>
 <20250915134041.151462-5-urezki@gmail.com>
 <aMhIv3HfRMyjlSec@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMhIv3HfRMyjlSec@tiehlicka>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 796B0180016
X-Stat-Signature: pydmbomnas7c6j5dduxpa4m3y6xb3z7j
X-HE-Tag: 1758036520-896345
X-HE-Meta: U2FsdGVkX1+OZPw0LAbtSKo2cD0L1GS5k7qcndzqrA9+gFqSx/gkINYk455fkeN6Bvw8M4IbLrUWDwQQJQLd33uVMzOsTHJA1DqfjYGhl5+b72tMc8q11Sg1+jK4gUFnmRB6BDoiaF9Pt9kboLRMms0BAannQWDtpBFvOjMCAlMDAP2YN1ObQ3d/fzCABkfusvRx4S83l5MgTpdxPWLntK3Dfja8wzmf25+KDECPJIbVqw43OmpY/Q+3uIVWN4xH7wjz55vikAbYcen1lLj1dbZcZ1sfu/DwnUaHJxIbCMG5mawLbaxtW6tF5F81cvURUiIMTac/ivmnyKzFwHbZFW81jd9T+LuCAlgJcl5G+xgzaDJrcU12ocUNKy3eWl5nYlaOyPs+wexD8AEwPNovMknpraRM7w6CvVqyYYAMEPqp2Gz0K4FIZg5/7GpqXns0+0Cy4PKHZ7JwQQk2PeBHVBl2YUAz3INGMYSdZEmnQ2IkutElrjcT9IRh1NSyH0HPlarZfhsaMDDcsEUWzimX4gi3ccAu02Gl/9p3ygwNukBYu3q5u361s7BP11gTAdYNSi4QxoX7Y2NBcV/I8ACIid5Q3GFw9bvVwuVBi5r1rZq4UTm2BuqMvn3YZSb2UrzNKvPIen2zgF/ZDtwnIRMTDUW6/Q+1smSbRwx0LZgSMc9uEe9Tvp/dbUKZNJsYD4XAfjC8zH+B47ahu3qylxGRmt6xqyDn15OvK0PNmYHbLlkWO9c+V0oiaObLukmh0SFa7bhHfIKuiLpEeGYX6+d1xS6E70Eq4940R7YtzZDG/i0h0ZPIE6YjzO7LzEmfPdhw/swQRlFHgqjAVrUyDr7ssRpoki+G6eoD7RLQ+n9Uejw4DjD/Thxr/JCwA1XMVA5Cyvin2RBJt2dbSkn9TWl5wNPiDGQSp4Sr31MiZyVCIU4XIHFlsqrAWOiXEevSuzU3oPwM3rql3/e8Vj6uXIC
 3q6488ql
 9Cz/34wfrepeHkLXsjf39irMilmJQHh5r6BbRIKCtQ30o8ohWPkCpIhRhZK6Orj6o9i5suIv6Vv/ulzh/nbVgpJ3byfpq9TPSQ+oExuPubcx9sCNXwHzFGLvg5/+NNhgwHW8ZASgKtwzIcFuFzNxXQvL9LNW+rcnpxwKa9Wv5SsnybbOyUnS1DxjauDEz2Pg76DBI4VMCMr0Y1MC7ezT/ZjRCtrpZSBf6e4cUYZoG5gnNfzSKhjek44AwweBIl/fQWTwEyAu3z8vBvafn8axeVy1fRYxLQyVvr+nnh5Fmm5njFDYTdjfKcli5n0L2LwK3L/Bl2luLlcuidcv3HJE0XWHbYBJ6xYix9A1j09w0UZtyacZcgOqwzZFY0EhdWmztLJodFdVp93Hep5BH42qTcRh1nrYpXZy6rV0Cmwbby4KrCa5ObgmJ/mk/tGjwBmukAgHGQFrEP7Mj8dsQI0OWyIq10nPiYivTsIKJLoyLgaXNWFMmCl0YXKCdijnNWhEzzAeMTgH7L/SoRJw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 15, 2025 at 07:11:27PM +0200, Michal Hocko wrote:
> On Mon 15-09-25 15:40:34, Uladzislau Rezki wrote:
> > vm_area_alloc_pages() contains the only voluntary reschedule points
> > along vmalloc() allocation path. They are needed to ensure forward
> > progress on PREEMPT_NONE kernels under contention for vmap metadata
> > (e.g. alloc_vmap_area()).
> > 
> > However, yielding should only be done if the given GFP flags allow
> > blocking. This patch avoids calling cond_resched() when allocation
> > context is non-blocking(GFP_ATOMIC, GFP_NOWAIT).
> 
> We do have cond_resched in the page allocator path, right?
> So unless I am missing something we can safely drope these. I thought we
> have discused this already.
> 
Yes, we discussed this. I did some test with dropped cond_resched() for
!PREEMPT kernel and i can trigger soft-lockups under really heavy stress
load.

I prefer to keep them so far for consistency. I need some time to
investigate it more. As i noted in commit message, the vmalloc()
path only has those two resched points. Probably i need to move
them into another place later.

As for page-allocator, it is in a slow path which i do not hit in
my stress-setup.

--
Uladzislau Rezki

