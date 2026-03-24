Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D5C4F532C4
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 06:50:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4659F6B0089; Tue, 24 Mar 2026 02:50:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 416686B008A; Tue, 24 Mar 2026 02:50:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 304B76B0092; Tue, 24 Mar 2026 02:50:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1AA5E6B0089
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 02:50:01 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B94E213CAFC
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 06:50:00 +0000 (UTC)
X-FDA: 84580031760.12.89085AC
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf12.hostedemail.com (Postfix) with ESMTP id DC2A44000B
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 06:49:58 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bLwt+ycY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774334998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9BtRgbo5SYoBF3YUHMOjmQ4qRhqYMdpWB9iGrbsQFLk=;
	b=y+Vtvd8h2yv/68zOtKT9/nnLquBa+aaZuLy3F+djZdj8grktAcuAFze0rAMLI0qsk1fzSz
	x5sIJg2zX2+j4B4WHyqKvd89IBFxVLE/YB3Beq8CyG+qs73DaQ1myjULGNuxgk4lJFypnc
	bcBXHDvY7Ef2OivkFb98SSSGagUmdc4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774334998; a=rsa-sha256;
	cv=none;
	b=u01SygTTWwdEmgc6foY8mHEmekiLmGVufZlhrjeQldRcmSNgqvngLKwVSqAOKot9wQ7TGJ
	S4t89w0MDlpaq7rN/CLos96VyH68Rm//8PU+T2XRg4Ge/CbaBXeFR1UA5HMkWumOa1daw4
	nYPPsavnGfgB6guqdxwLG1LJOxZrEBU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bLwt+ycY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2a8fba3f769so23139085ad.2
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:49:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774334998; x=1774939798; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9BtRgbo5SYoBF3YUHMOjmQ4qRhqYMdpWB9iGrbsQFLk=;
        b=bLwt+ycYh9oILsfFudf8CM3df3a40Qqu0rqyiFZ41Wj8f2OjayrPZ7+lnDurEVDvJd
         p+/sS4dxIXA2amuFcKLRusQoeeJq3Bl65pxDF4UEc6sce/GQlD2qJSrArN/2kguYI+Da
         9/Jc9lfJA3NJ91Pwv4hDMyx0ecToQ5rTjdcWccDxV449ce8Cn8EJcirpq4ITIm00DQkD
         qPtXCqsJlgUw2lraa5ZfXESIn3XUycllhPoxezHhCqHujSAQaI8OPSfqRDD2qjbkIjaN
         JY+I0SsysrHnO4sTczNREysTotFfWFU01qR9Gf8d1t2xFwEq0wXT1bhviZx+BnINVBIY
         jz5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774334998; x=1774939798;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9BtRgbo5SYoBF3YUHMOjmQ4qRhqYMdpWB9iGrbsQFLk=;
        b=ehKqUtHCASwd88bTDtsaBF8G0diaUT6vEBYANymfm3VFk2VAxAXBxRvbEqPXpeMovZ
         Iel1uzdKXfb3PV+miojWagyftcAVsCUMjsKaywDBO1qUWV0pok66+jon6hkZUdyjFmBB
         CoYGFjMnt7EanCHMcks4+25lmVY8YhJ0arUza6UmRKDsPQmMgu/BQPFVdzi5jQis7CBe
         V8KcC8IezNiqiNejJW2pyGoFJxy9mcQKKxQr7NYivbPjVpNuv36JPlcowQrTM2sybJ+d
         P4/71QGYp4lLfDUfZSdNuc/LvLIH5RUkyOwg6IwcrQM28Rva+0NBnOP9Dn+YRUtMxlZc
         ZblQ==
X-Forwarded-Encrypted: i=1; AJvYcCWQFNeiruS29ZO14FZxq1Se5GPsDkyPskjQpPQIrtkjr4Kjv7SXDbxrCTpwnAGclydeGXNezwyoBw==@kvack.org
X-Gm-Message-State: AOJu0YxKNTWd4z5BI3NQSlwqtGmxsixoV6y9Q4MFZQ5/GyAFhFPe+cyM
	BTiv7yHRk8LSNVC1s4QuhUmoaQyK39AjLO+q1Bw924gaL1CwDE6SKchk
X-Gm-Gg: ATEYQzzalvKcOabAePkHKT6stck1WGPf4GOunUdJjFP+yFsIuYJpYIEWGN1S7g/ig5M
	TEE8GFIiTjDMHF8R7mMTA2VcHlX9ko21lOOD5aQq6jQpbbIOfm1L8Bi76WGwU9wnuIzCvpTqejL
	21BzO1rT1+LUcTpfkoNL02yK1l/+suiwTctkVrmqoXr/KeESvHFkyMz413wNtI5mUxWsmJULB81
	B+ABJD34cssjR2Xzvg/pzT8CVXP5jWmVTAsowZiQPow6t6uNvGPU35KwrMTXT9L+zUYG6EZJwEE
	Y/1ZMbQDwLL/vZIET+gQ0/eMFa6eXdKYw8dwk90k2eNmIJN8B0jlFngIShUD6xq/MXzgG+kBl9x
	MwDvt8LyIU2rwiPyDTxtDKVwvoIYG/lyRLsHDFTIW5dBX2nMtc9VK8ZGnlBbYwDZ+kewOw3XCPs
	K592n68mDWuGQ44tqTq+qG/xuzJuGdV0HxguqCl6H4r8vagoCmUJor75R8jz5etarByiS0
X-Received: by 2002:a17:902:f70e:b0:2ae:478f:2ec with SMTP id d9443c01a7336-2b08277b109mr133450355ad.29.1774334997612;
        Mon, 23 Mar 2026 23:49:57 -0700 (PDT)
Received: from KASONG-MC4 ([43.132.141.21])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b083655b45sm180639635ad.42.2026.03.23.23.49.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 23:49:57 -0700 (PDT)
Date: Tue, 24 Mar 2026 14:49:52 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Youngjun Park <youngjun.park@lge.com>
Cc: "Rafael J . Wysocki" <rafael@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Pavel Machek <pavel@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Usama Arif <usama.arif@linux.dev>, linux-pm@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v8 2/2] mm/swap: remove redundant swap device reference
 in alloc/free
Message-ID: <acIm_7vtj4XETdyP@KASONG-MC4>
References: <20260323160822.1409904-1-youngjun.park@lge.com>
 <20260323160822.1409904-3-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260323160822.1409904-3-youngjun.park@lge.com>
X-Rspamd-Queue-Id: DC2A44000B
X-Stat-Signature: 1ach5tspihnw3wkg8tquz5jx3g6oxzjc
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774334998-246407
X-HE-Meta: U2FsdGVkX1+Vd8rFltJXcUbfJsHRkzTekQszGzUR7y9uP384O42cCQJ/RHNZJDrbxlvaMintn7yZ0IqBytNJpI+0HBUmFgux9iVqsYfliMJdDPs6m7WmGKKqWh/6osQZ+a5vbGLMC2tH0nfcC495bNisZCkPLSV4v87TMrNrbB6w8EVD+i7HjFZ/bi9xPuTqUjoHY7q2mO85eU0/idVQLji7bZsJxZWj9n1oqXnZYytOFxLV4dv9ll5pNSxkjJMzw2ZPXOdHOrKlafZ0TdBEUOiiD3+FAFPBMmGezl9JqsZZ2qKLw1ZXC5K9+cXfyhvgVZemGWgBUt8mhlYVbWvoJmPRTVcT+U3XwBR/tgosHnSo4TrMaPkNPez0RVnsCWgdB7rlDUlul7K0knHwuibRxzXw1aO6Qd46Tw5sbxj7uVk5Zx7kGIcEjw1B+igWdfbBVNdAmoCDkDCDf+7NwMFUfujuYWst3sDG3OCiq6LzHK3uK3pk2P9kvgGRoL3MwdKk8kFHesZRjowfclNSVVDSI49pvQ941hbuW/pW3vH/rRYxAhwj9NeHJJZC0VneE2P0PwcMfOGG9H01mOBRtFXWvojuU4suuBK2yBMmpTMX3akwcBaSqMTI6kr7kZvMWaP+U4+5A+njlWIAviDrOvNm0slqYhtQ8CjeuHKUUyQ+F9wDfbJddbS6lIFRiRKC18x3baM1Zn9fvKwHA60pdmXICySlP9Sllx7xiSC4rNnfe2pLzYJUuymiaiDVWNyI7z1PucDg+A2owu/ZOrVouTQv8lqTCcHmuIfELRWShSkcjKcyCclpKegrc1krKVHnlwMfjkFVA5I8R4XEGkl9LtwvxI9tOw2oMZwxNwkNqey88rN6qXZaMLSN1iG0Yx9hecna0WvEDC7SYjBM3i9y+omsudbON4Kedo54cxNofj1bNL9tVermkBhzY5NLaAvx+DLlt1v3NzPaRuLzTbeJINy
 +H1KbqZd
 HfDMZ91li2XQPs8kQKrwR1p3iWwqa82wC/SwXm9zPPHeIZz07oER9K3q+FP9D/lDUz6wgVGSX6JcSctpOdVc7xocWf81n01JZz8hn+r36vpZnbDss8hmFIrrprsJa+tJjL6Ox7s3ySD1l//CpN1OwwrbDe66uqwVqpZyGu0aKIygzFZxaOTT0Ir0IwBqnzSjjCAnvV0SrzRfbO4vHlIrA+GQGQdFTQt4jOGWTQfZCIw/mV56GuNi8fAQ1jpR8zHqc+bGnFkfeZHVhRmoHSIysqPxJSuitwpmh3pL2MyiiB7XWMO8UzE75YO05JQWQtJ8JBLjKBA0ppdVHi4e56KbIeB1j/YopaN7td9s8Cj5+wIM5peOdpBYA6vqhwSdgM1+opr/s7ZJRvveptSWhgzo/3PhIPaiNADFozNZ+2Q4Q4S1/mOfiZXgT+FNXEDCUEdSYf/yn+Yuq4byrVvW28k6X17d54oTrh5UXUBwo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 24, 2026 at 01:08:22AM +0800, Youngjun Park wrote:
> In the previous commit, uswsusp was modified to pin the swap device
> when the swap type is determined, ensuring the device remains valid
> throughout the hibernation I/O path.
> 
> Therefore, it is no longer necessary to repeatedly get and put the swap
> device reference for each swap slot allocation and free operation.
> 
> For hibernation via the sysfs interface, user-space tasks are frozen
> before swap allocation begins, so swapoff cannot race with allocation.
> After resume, tasks remain frozen while swap slots are freed, so
> additional reference management is not required there either.
> 
> Remove the redundant swap device get/put operations from the
> hibernation swap allocation and free paths.
> 
> Also remove the SWP_WRITEOK check before allocation, as the cluster
> allocation logic already validates the swap device state.
> 
> Update function comments to document the caller's responsibility for
> ensuring swap device stability.
> 
> Signed-off-by: Youngjun Park <youngjun.park@lge.com>
> ---
>  mm/swapfile.c | 68 +++++++++++++++++++++++++++------------------------
>  1 file changed, 36 insertions(+), 32 deletions(-)

Thanks!

Reviewed-by: Kairui Song <kasong@tencent.com>

