Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6AA2CAC5AC
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 09:24:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 461DA8E0008; Fri, 26 Sep 2025 05:24:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43A028E0001; Fri, 26 Sep 2025 05:24:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 376DD8E0008; Fri, 26 Sep 2025 05:24:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 277508E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 05:24:54 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B55A359D79
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 09:24:53 +0000 (UTC)
X-FDA: 83930866866.16.C515F1C
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf16.hostedemail.com (Postfix) with ESMTP id E2BFE180005
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 09:24:51 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758878692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=15qqzO1/4D/fXvObyf6lxUzcRGeGiwoHvTPaLubu2a8=;
	b=HxUcOf287132s9DOogEyyRjsPHTFBHcYw+ppZU9WY0bUnsHNB94HMBfski2x6WjDXs9QRG
	aPKEJIcmGiBchFY/89NwfUXEqsapyRQ9lgoIYa/ZwqybEa8zFP2u1Qn8SD3vofM5hbI18/
	/DxVwR52Tp+tZbSfP/h2oBYmBt+wMUg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758878692; a=rsa-sha256;
	cv=none;
	b=SnA9lZ4gscnVZkI4T4KIPz8rCbD2jmLpEQEUfdaevjZnG0MaDEXwY3XTvKOyenyOiiZl7R
	zCM7yQCRI4wgOGlvTpQTS3a5+j/orNU0dqPC1Ndfv++euIh/X1q5oHZdvYKiWDLWjRTzzg
	1gAni21kxO0cE7KSX5jTAuxs3P9KEn8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-46e2e6a708fso11199465e9.0
        for <linux-mm@kvack.org>; Fri, 26 Sep 2025 02:24:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758878690; x=1759483490;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=15qqzO1/4D/fXvObyf6lxUzcRGeGiwoHvTPaLubu2a8=;
        b=wNXX8/XoiZvsgaINqxi3Sul4yq2MtCLtlZ23GA5GpMgu/y32111ugvw2smEvLfdrzR
         s9dqlTby8hC9qpENIu51otCZcYPUq2TL0oD7ws62KsblGj4mtETCaSNeFq/XCS55QGfk
         TQ0zi+LHVlPD++eq8XOz0pVDPBzIIjZPtbDXFATRWq7K2cgARJ/DZLjClEE91da5zD1D
         qlJ62fj+U65HB+E+bev0AflVR3MIIRmH03AupwC1z65NRBLcMKAKC5dchdmduLvVmq+L
         4Xy0EC2Hh8ONstx1dMRt1hbzQLl9Ggn6cbovt2qniftS1JD2x5wSkPIUERVoTqvCMwz0
         WcGA==
X-Forwarded-Encrypted: i=1; AJvYcCVWQHMOW+9XAHdBiV9ToKGjmdHXkz3xA2Dh5GwXa2cPbEyjoKU6l8cA4NmPZFNAb0Hdfj5mi1qZow==@kvack.org
X-Gm-Message-State: AOJu0YxdyBE5/at/0E/P8eaQWVmmMIfRtIQv5RiuFzIQuVnasZJ3IhUf
	xH1fXFzp4l6V0UnGZSMhrTUrS0Cj5A4GvI9dHRdZM1Vdnz6YmkXhSvmP
X-Gm-Gg: ASbGncsI+M6iVH7y971QzD3FjyuqLsePimVWiUoY4qA5f5zVn513cH+RsjML68WGsXa
	1YrLCRTHNZUHIx/VbldDbQAMN2JyWGM/stX0z+kja7EpfA7EKhSb3JkWz8hFNgpMdX2AafX/P7S
	wlWVs5WS1ERAJYId9oRwNpxQussTmucn0N/DVZQLV4ObTL7P0nY59xbfRTEus7429uycMxPs95v
	yVws9SGzW4Ug6SKA9hOG44dYboEVPv64/iF5I9m37ZAomxyvVrj0y3PgrxeCUWieZWszW7C/xUW
	hCTHDNHOhJrz29fU7iw81UJgIQrzkG/uPb9o3zcNBxOFnRQVA0k63a092Ik7RuQQ2zSGgzDfGfm
	L/SjZVzo387/n0y8VEb9cKs0=
X-Google-Smtp-Source: AGHT+IG4jF+clSglFjlTRLQXXovvviBd+u8T240DwlX27xdVKmc4bcBJNd8Gdkqs1y2zUe90wtCrSg==
X-Received: by 2002:a05:600c:5491:b0:46e:345d:dfde with SMTP id 5b1f17b1804b1-46e345de049mr68882005e9.16.1758878690199;
        Fri, 26 Sep 2025 02:24:50 -0700 (PDT)
Received: from EBJ9932692.tcent.cn ([2a09:0:1:2::3086])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e2ab48b40sm108503725e9.19.2025.09.26.02.24.45
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 26 Sep 2025 02:24:49 -0700 (PDT)
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org
Cc: elver@google.com,
	Liam.Howlett@oracle.com,
	david@redhat.com,
	harry.yoo@oracle.com,
	jannh@google.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	riel@surriel.com,
	syzkaller-bugs@googlegroups.com,
	vbabka@suse.cz,
	syzbot+60192c8877d0bc92a92b@syzkaller.appspotmail.com,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH 1/1] mm: silence data-race in update_hiwater_rss
Date: Fri, 26 Sep 2025 17:24:26 +0800
Message-ID: <20250926092426.43312-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E2BFE180005
X-Stat-Signature: 5zpkjtxwdmepc8ccpryr5hu58qyxipsp
X-Rspam-User: 
X-HE-Tag: 1758878691-877028
X-HE-Meta: U2FsdGVkX1+z3qj4wcoAmCNVWS5itKjB+ZjJlGSimIIGCcZ/5jcrPhjNsGyIelssODO/oOO5IlZ7EubpkqyCd1dx16sO3liRs6/LyVCoco0hJ8+vK8DCH/Kc8O7hJxtmnqioxv9QqQVebywsa6h78X866gPLr3u853oHnTAzsm9biGOhbwcrJjW/v3fZuV+pJdpdqAiA85x4nb177/rYMFI2lNE3TgmCMiBoAnCRJjHNpYsCluGBOtMs+WlJ7dPRC9QkM5ed88eN3kVIDi4JkdFLD9jzLyh11ddPZQCgjFNlMhBiBR9yd7++84GaROJIeSUh93SBTsYNexW3/ocsjeWmfFNfU/trojj3UFxzHiBV8Vd6zZu9jjE2xASTbwJI8V9C5/cARPOOI9UsB304YutZ85mxTSDtC78GV6CJz7uzww1Sl5AIEH2E8qfd/fMzYwL5N77k8mwiFMTvZKUIswQEkJrzLzGLK5bxWytwXuZk2X/M3Tyivi8qDvgnPIPKJC0VM3nYw4G2CWCtLTwj6fneDUBLY74D+9kGdKOVw+fyDs7oW5puDJ4dssGI9Ob4nZuwRhjL+2LxNibmr/M88Qs0uEuzwWZBlAnpvg0hOQ6fBWTPOdq7rA9QveZCdzdRlAu8VRW4Q2ArRobpXc53kXB4ZOfJIi6Ixvcf9Me4VxoBMcv5iIGCK6TrdZr+BiYVeLp+iPICQNrEE+RNEJxFtmOnSFplwAHjLalYHDsewW8nP17d4NOC9sPAKZ6hKJ94TOAqhg4nNEA0DD5t8olPC0k09TbjeeBuv5Fla3F1ALFZTcdiFIUZmyAgI0L+M40xqgXSw4PIJPtOgZKXQKQdSsGYW4wlJK+Pn6KI7j/ZY/SLaGGo5EdTKLuCr+xAywuhRHW2hI93rI9Mb8kvQ3TtPMi/FFE+iF2AAzyOKk5RsXcPJcBmtxr7CcHincS0qHfMXb5OYGt5Co8zT8P75pT
 nTwzt/wX
 sDlKx2i8Rk1aSJsvl0FnT84DUVCT1KQ/VNP29Ihx5HCkytUTqEWCok7WXhdH/4RGcViX0qJ0s9rpxLfsLHejZu9AANGPFsExkdRoD7NII3CVYWxQvC3FTHwGT9r9dRrz2cmd6dQV3zDi+J4Eid0mExOI/KSsxcFR7JDa7fODa9qgjBLbxEfXVo//mxBFfnno72cLpCv6VZZ5hPGSktnZGy4UdLcYVTbuyTIx2t0YwzE1MZQMsrYId2BTG5ff2zvsZt5CVEct9Knn5lsvvJVeJJ1bqkz02s+GSgbI8NShP7FeI+6OYSMGNrN6gZgepfANCodNL7C2XobFpF4/GI2K29o65eBKMuRq/A6AASAcvymLCHdaVCXTOCXGOg75hCOjugfw/xDjr9uDNq9Wx3+2A6vd9mILN1I+1N5TsdFqDixPa6+5zpJvedK2kSBeMbK7jGBMatu55VRO0Gzbr0A8XHwYr/zqHtaa3mpJgorqKYAp8wr23VGsonwUhwjU+7EDsz1jZyOryR2UjnEK8WuYEvwF/S9970iYZ9kESQgizd2jsxdWq0rRiASVIy944CCX7UDy6dy43kdkU3eQLofbKHNCRRgVm/eXN9zJ8uTkoPZ8y36mneIgg0KHx80ZmVHnzRihKeYAYaNg+nYcAPGoUvAQ7TDAEpAo/j1R0cWQv/mibNP0G8+Zr9dRm9ShXnqH8JApC/6To8KcTszag8Din6DlkaIBAnYx7WYfj7Ci0Y/AkRdo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <lance.yang@linux.dev>

KCSAN reports a data race on mm_cluster.hiwater_rss, which can be accessed
concurrently from various paths like page migration and memory unmapping
without synchronization.

Since hiwater_rss is a statistical field for accounting purposes, this data
race is benign. Annotate both the read and write accesses with data_race()
to make KCSAN happy.

Reported-by: syzbot+60192c8877d0bc92a92b@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-mm/68d6364e.050a0220.3390a8.000d.GAE@google.com
Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
 include/linux/mm.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 6b6c6980f46c..dd93335e3a13 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2757,7 +2757,7 @@ static inline void update_hiwater_rss(struct mm_struct *mm)
 	unsigned long _rss = get_mm_rss(mm);
 
 	if (data_race(mm->hiwater_rss) < _rss)
-		(mm)->hiwater_rss = _rss;
+		data_race(mm->hiwater_rss = _rss);
 }
 
 static inline void update_hiwater_vm(struct mm_struct *mm)
-- 
2.49.0


