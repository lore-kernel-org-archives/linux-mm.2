Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43076CA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 11:19:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A186F8E005A; Wed, 20 Aug 2025 07:19:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EFE48E0003; Wed, 20 Aug 2025 07:19:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DEE68E005A; Wed, 20 Aug 2025 07:19:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 764948E0003
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 07:19:48 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1BB015901D
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 11:19:48 +0000 (UTC)
X-FDA: 83796890856.27.18BE55D
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf28.hostedemail.com (Postfix) with ESMTP id 50F38C0008
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 11:19:45 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="OJVB5/KP";
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf28.hostedemail.com: domain of sunjunchao@bytedance.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755688786; a=rsa-sha256;
	cv=none;
	b=5tGkcXwMlYhW1/ZQDldzeN1t+0MeGkIXLT9VyffVr39+/0i+lfDvzNRLhXhHM7WZuWfowK
	RNmLd2amkOLy5u3ZWLpVPMUFDvwReUYKWaspPlgNgigq5tBrtRq1O2sA6nK+f89whZe5x7
	LESVOm7qoZIiXdWZj0XF47LkBebSD74=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="OJVB5/KP";
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf28.hostedemail.com: domain of sunjunchao@bytedance.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755688786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=8nzxfwrJ7tgF8TbO628wBC8gRICp1yIHaSa6RvJ5d0k=;
	b=SAQu0P+uzP4pUygIhNi9t5A5hC9rZ3D/20CqMYhTUHYrN3VcC0TWyyVmY9Vq/IbrvABaeO
	WFvT1sqYBGgoVJ/o5abT+sYZRg0GVmOBHcre8pucPIrGde/3CbhPMVhLCztvExchfuO37A
	y3IEqWMIyzQ78rW7Ri4W9ZT745Pm358=
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-32326e66dbaso4424257a91.3
        for <linux-mm@kvack.org>; Wed, 20 Aug 2025 04:19:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1755688784; x=1756293584; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8nzxfwrJ7tgF8TbO628wBC8gRICp1yIHaSa6RvJ5d0k=;
        b=OJVB5/KPk0AoW6j+4ckGSDZipRcF+j9LD/r05mmaXZdeyOjrtkal7i3oTt9CUWJYeY
         61Xi88XAMZevCuK+V7oSG/pb/bXz5z2mZaRvGmXdn7kXl2aQ5c9tSbqDobfX8cJ5vMrc
         e85xZJTema+e1t7aedL9f5Qp2Sc/faCbp1W/xXeofSYk8dVgW9f58UenAItDMTSfTLZ/
         i03qzyLZlgEhUie3A+nfQv60sGfDTU3bR+gWm2LiGZg9UXc12LrQHjSp9UIhgp7k3KQ2
         +LaicKOOLPaDRVivhaSfbI/OlCE9tTRpCx2Ue23LmXtpAzEc+xjZPQOHwtDNecvW1Tfg
         5aiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755688784; x=1756293584;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8nzxfwrJ7tgF8TbO628wBC8gRICp1yIHaSa6RvJ5d0k=;
        b=uVmCwwrS3wiOsNjB2z4xKepVTJkEuW1xtPUpaQ9Fqay79m3PHn5KkzwdZCSqSZP5lk
         py7EYIIFuc6fun9NyZ8cacVYlArUloLKOkq66WL+TG9OyDYI92AavazurB1FaTKsASWh
         fA9kEjI/USG24/Om1majA+OPT5FesENue1AU18r/bWPGD8cUtcTPrMznvTYtAjNqNgcS
         n5PPgSTApafMh4ykr4uhg3TyXMCgaToIK3sUpb5EY13QdqU7ycXcK8G5zC68H8IVQ+C8
         xoay53pygHUUcJ3F6LQwYOniwWa65y8U9OabEebBh8mSgiC3Mk2SX1vqbQaFY9CVML1f
         uvnA==
X-Forwarded-Encrypted: i=1; AJvYcCVafQ8AJUvdpQLM5QKMQRNW48eSLIeRNjrcn8a8nFbiRBJ3SvKWzoBMzD4wA3Bkca79VMmRzGKbCg==@kvack.org
X-Gm-Message-State: AOJu0YyKSqfHjuLE1MMg7w5u6l+1I6piBP9TbKG7ItSMfjyaTZWTVXVE
	pxgsKJcWV2ykZMFlIJBxHH87gh2vDjBn4TaqwFsqL+TFA6Z47bD66YBWoi9mRBChBmQ=
X-Gm-Gg: ASbGncvOuKuUcsNP6RZ2ZDKpjunNuqiKtUJqzNe//X8iQOVEnY0lESg4i7YJgvK8NIZ
	LxWmOX6fRsP/SR8F+vzFzPwONDC3SsNSa0sN4ynVSjEnCZW6bGdc2Q3PrUjrJCexvr4gr8zNM9W
	l0hycYg8xvkfoLDaxYnBB4Iig5P9ca9T8tlHegW2h/SqcMkBJlsO0RLGa4th03naRtHBDLP0ZMp
	/Zpo9KzVYfKK1ixZKCI9m0Ja74D47omU9p45cNfEUws4qGA1MmpARHuL/XtCQpSW24JjNDI/ZIT
	wgK/pL2dqMSYut1jqqLWmJ0vo4kajSrDk9YJJZFUTN/UUTNM5N3DPhoeDEY+I5WnXbJf/pppZUb
	drp8W5iuIFx1JSlShw+fNoFBR6x5/6QIiNENY+HCI2g==
X-Google-Smtp-Source: AGHT+IFDp+oQlv/0Q/A7/4baOQAwYfujcstAPbmMtif5cwe4FhwyrJsEGhnc01bdJasIBQ+A45Febw==
X-Received: by 2002:a17:90b:5187:b0:323:7e80:881a with SMTP id 98e67ed59e1d1-324e1489895mr3679710a91.37.1755688783865;
        Wed, 20 Aug 2025 04:19:43 -0700 (PDT)
Received: from localhost ([106.38.226.108])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-324422a8bb2sm2827379a91.0.2025.08.20.04.19.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Aug 2025 04:19:43 -0700 (PDT)
From: Julian Sun <sunjunchao@bytedance.com>
To: linux-fsdevel@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org
Cc: viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	jack@suse.cz,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	axboe@kernel.dk,
	tj@kernel.org
Subject: [PATCH 0/3] memcg, writeback: Don't wait writeback completion
Date: Wed, 20 Aug 2025 19:19:37 +0800
Message-Id: <20250820111940.4105766-1-sunjunchao@bytedance.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 50F38C0008
X-Stat-Signature: afqdgu1agkfnji5d8nwwyghi5beogwxd
X-HE-Tag: 1755688785-289725
X-HE-Meta: U2FsdGVkX1/xhuLmzyLJAfYJ5TyTDpAY5BSn3+wZ2i/DmXcin31h8cZIYvBx1JS5U0/Af+/b/0p3il/rHWfkKnB/J6NqAcpdPLc2/ovOPRbirKq6dOl4qP9XPuyIt0xBWGgM5K1bfGqbNCKrY0Xw2urt+cBgES7qoBqX1lnOwAsyEdnZ1UdLqq3g3qlF/jszL7HmOkAwRsHlX93jDNP7hshc6BbK7I4AaTlN6G1JibSyEzmD4a0/Jr8Qkmdx6tfMjJrXt/LZy4Wkggq8pnXcZsxkVAaShOm03v+RQVUJLHb3NVY7H5BQKrpmYCQL+bCivRZltTv2heKaelUDdqXO4sCCGAc0EtoYmhLXsdziWHYRJm2omrJCw+aCEntzQpMDwWfS/RgRBWhBzZ5IlBnwzknc2d1rcfljOHK0P+9iGlDoMMOIEhv7dnpUVMb27awbPa/wMnoGuvaB6Otd6jsWDTB73Hq7C45KH8s9tFrjfqWTmx8dJa0qjHTa+t/Btd5DquYmTPCl4f/Bkg9mQW3dMearBXVdp+18t/haIWU+2K62lzigoQj6BUHcglaR28TGh4kSMidxcNsdm8Q5xAATOGOZM55YDBgtyw7WmDlXQ6v3uDVcwhf1qDz3ap0HRblF8PaHYyxkguomDqitEowVEVUsSZWvghmmwZwyRmbiCx1D8MMCVXCpR+wbJDAcaT8iQCH4TPEGMRmDVCPbMcEH3kEIbot54lFNPD8yYn7EE/S+Ril0LvqWlJlkJo1iWv9UmA78cD1iJ39iLvawusmwPQ369PNsSCZpOSqCnsyw7mk5PXnG5/zC7JWK5qEFs7+gSeG1q8acrFIPzSzgJGf0T1bYi0Ab1bCDeWZ0tPMbDCNDyjNgFxHD2HQWhr8XS2kdQvaw1e/FOj4LAJoWs9+Gmd/BNfHBz4n7xYGJhW9cxzrvmIvBYWfu+oFYbTfC2hLjbcgLVcOdzvxDLcbMFZk
 6m6BrB7k
 qV+/8VZaqENfz6cZHh/oXbCXZXPo+zkQA23PQ8T2G1ZL2r9UzEs543KIzh0NWHAGDXZGBdI7aCN+FzvSYePJi5FqVN6lAkt+RJXAUWxcNdSsgQiZLtBk+S3qNOlKbMe9/R5WgVayO2XpYxgbscGGVmXs4625nKT81fu/S1OKRNWsm2kLp/n/L5ye/RxzeNL9IgYYbLv6jheJIRPQ0TwxYdWVufRrRWddLjf8KYdQwY/HacGdepW0MBAIownilDF/8Wea74koBOr7lTPIVWmJ77i7nTeIEjXqriBLEyp+SO7aOoUvJn8JkQyoWSNLjL28d9MwWAGjsaGzMUOT9UgTA/qTgpxe+SYadVMNVenR+OKf44Tqe1zcY3y+pKg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch series aims to eliminate task hangs in mem_cgroup_css_free() 
caused by calling wb_wait_for_completion(). 
This is because there may be a large number of writeback tasks in the 
foreign memcg, involving millions of pages, and the situation is 
exacerbated by WBT rate limiting—potentially leading to task hangs 
lasting several hours.

Patch 1 is preparatory work and involves no functional changes.
Patch 2 implements the automatic release of wb_completion.
Patch 3 removes wb_wait_for_completion() from mem_cgroup_css_free().


Julian Sun (3):
  writeback: Rename wb_writeback_work->auto_free to free_work.
  writeback: Add wb_writeback_work->free_done
  memcg: Don't wait writeback completion when release memcg.

 fs/fs-writeback.c                | 22 ++++++++++++++--------
 include/linux/backing-dev-defs.h |  6 ++++++
 include/linux/memcontrol.h       |  2 +-
 mm/memcontrol.c                  | 29 ++++++++++++++++++++---------
 4 files changed, 41 insertions(+), 18 deletions(-)

-- 
2.20.1


