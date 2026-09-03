Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A2DFC624D6
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 14:32:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 155E56B009B; Thu,  3 Sep 2026 10:32:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12D806B009D; Thu,  3 Sep 2026 10:32:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE9786B009E; Thu,  3 Sep 2026 10:32:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D02D36B009B
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 10:32:47 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5293880478
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 14:32:47 +0000 (UTC)
X-FDA: 85172692374.05.43BBDF7
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4D1C640015
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 14:32:45 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VlMNp9si;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of zhangbo0325@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788445965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IacDR4V7VVo1kImUhwmBbgo6FNMbqfDdRV7nbWQPWqI=;
	b=C/zRqqPceurJMs1ZqSbk60w1go3W64l9qTHML+nZy2041pLAKlEeglPK3puYejJ+ZrNvTE
	yA/VH/aBcMdQIz7xP4q2AYcvFtwfnQ6Inu97fPPWgSGOipno1u65M/ER3qSWSeRNmkbQRY
	nDkOXljpSwpAJmXS7h6l69WOx445e5s=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VlMNp9si;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of zhangbo0325@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788445965;
	b=CAEF7nIDpDYawq052bF3XoV+gmnZU+fB8zZuKPLhgp9t32Qq/S9jMcqw0B30BT8LchS8VQ
	mYpcrwtGAkCRnwpGME/7W3Obg28ByHTOEOMpRJInEhlbHzerdjW8Xh58+dKies1ftgDACG
	s3Xb14hcBeXsXUjRw6RpCGv7CEpoTuo=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-8557c3f270eso1502790b3a.3
        for <linux-mm@kvack.org>; Thu, 03 Sep 2026 07:32:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788445964; x=1789050764; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IacDR4V7VVo1kImUhwmBbgo6FNMbqfDdRV7nbWQPWqI=;
        b=VlMNp9si6qq3C4eZJwTsbYsCO+ZTlcq9JC6Xo0EL/VPGSrul6hRRPllz0Z3l5pMgwS
         nbzZOA8b42tny/lbF+prZYeBCOW9K/hwrGBzF+CRcYs+dOBVKNh9sX2qsFoMdzCvL0kb
         rVAQl6IHEs4cn8lhMmth26/7wUnE51JAQ+yPbObVebtHbK+DePlpCP8b025U3ayGh/qi
         +r+FhOONgsxsZsfo7aUwNccybX60NviNRjrys1NC8znN1oJrzlu8z9i09QTwBtvQSrf0
         S2LJ/xSdqYz1XQW7HQXGPjRscOh4VQTGRRPQNF7CXFa2CRPxzMl7t7bhOcusQHoOk9zf
         4y2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788445964; x=1789050764;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=IacDR4V7VVo1kImUhwmBbgo6FNMbqfDdRV7nbWQPWqI=;
        b=obzM5XR1L7o7j1QYGnh3DSyTK7Yc88lZ/CtoAIXJw5yxbNsbgbCbmU+dzRSXnGJwM+
         XqdGnom8sxKeYB1FGpXqMJWh9jfimIS/Qd9CSXmlsGmmPBWxVpKawsuK/tzCZiR7VFLc
         rAflJcVSZsE2MtxORhokD09bBB8gWhUpMwpdjjlilbGPyIjl766PRUZxYBz1btjWmv88
         Uxn0nkA1zIPbbD2wowHK/PjIlpk+A6p7e2B/30IuxAcdRkhqz3KzWLWttCbAos68Gs8A
         SRgtWA3DgaMxcayJc5hUFKqk8KMLf6kbjvTzndzq68BPoxJ0buZiak8Il0KYTZp0kaeU
         5u8A==
X-Forwarded-Encrypted: i=1; AKwUvBxp7a+8bYahp/X+awSEulQrVFiXFshkIhQbRk6VW+vo7Dj5K033anTh6tnyHPc2Xouw4sMAtmGjWg==@kvack.org
X-Gm-Message-State: AFuF++lCObMtirJYEHRiT4DXJ0vu8COxCDqjNXIfjT+7p0v/qtP5aBMB
	L0/mOuXIXRYtEmrMne+xFQgOyEz3H0BBYIXBOoH4+OdBlnwbD9Cx39G8
X-Gm-Gg: AYBFou3oPCEFaSXXQwLDVEcfjI9alMtMVwBQctFrCOLi9cGjUWA3Y3BJfgYgArir7EH
	NGYLJBZqutioQzYF37CA27ad2xaOkYBblrktJ0fhJD3fnfs2tfYhBKg2RowRMk8EFuizC1avNXb
	6ztj27Z8RV/ENF6evWGSkU3HpImdiRdudiK+JqROXy6UsE2ePoph2x5huHXPfh//yJyyJwifG0J
	jg2HmFlMhVo83XjeJFWZv53lbBaC/U4/1X+HPZzhwlrH3SZ5lfc8dyZfr74FcdDXuIkUEeNLOIZ
	9p/hFB+x+r/ZlqnelpUBxGG3tPgfHJGL3cOzhO3o0RD7ky5nXQSbMP0/pAUBi8/ky1tjmk8gkur
	XSdp4YhjqZxZDVJuGcBsAgcU7BY2Z4cz0TqZazEuacd3JSmONdnm9J5YUSzUOSYVkzH58U0O8sC
	ViCtRBJ1vzYSVT0a3SHFcKjyLkXF97uQThWy6vOwZJVVuQh9BPQxTjbCjJvglbdXqHW4pXqNaLp
	ZxFBw==
X-Received: by 2002:a05:6a00:4408:b0:857:4dea:e2fe with SMTP id d2e1a72fcca58-85ed8ed8414mr20058383b3a.13.1788445962694;
        Thu, 03 Sep 2026 07:32:42 -0700 (PDT)
Received: from zhangbo56-PC.mioffice.cn ([43.224.245.235])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-85dc11f80bbsm2941802b3a.57.2026.09.03.07.32.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 07:32:41 -0700 (PDT)
From: Bo Zhang <zhangbo0325@gmail.com>
X-Google-Original-From: Bo Zhang <zhangbo56@xiaomi.com>
To: akpm@linux-foundation.org,
	vbabka@kernel.org,
	david@kernel.org
Cc: surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	ljs@kernel.org,
	liam@infradead.org,
	rppt@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	kasong@tencent.com,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	zhaonanzhe@xiaomi.com,
	lipengfei28@xiaomi.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 3/4] mm: compaction: don't skip proactive compaction for non-costly mTHP
Date: Thu,  3 Sep 2026 22:32:21 +0800
Message-Id: <20260903143221.4108871-1-zhangbo56@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260825043833.2659350-4-zhangbo56@xiaomi.com>
References: <20260825043833.2659350-4-zhangbo56@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 17uq918pb3gobtmu9ri9e4w3qg8sbtc4
X-Rspamd-Queue-Id: 4D1C640015
X-HE-Tag: 1788445965-700258
X-HE-Meta: U2FsdGVkX1+jkLskMOJSARv24Vq3FyaJjnZzO+XED1JDD4hq2e/YA0L89ORgO1KDWdmtjupNVZtssD4vxzqL05CLCUetdt/B8lAi7jQCEwjW3kUki0dpbhHTN4VTO+ThfrbqrdhCqqaMOGe6sKHP3ZKh5PzuOykJXpbeNx2IlctvNpYtmGE9TOyMwgO2n9bDyGjuAUSCwBTHJHDd/fqYJM6Ce95onOh/9G6MSOMHdz5i1qvTP4ZsJvwRXk6uC0/il7F/t2eyWZ+k549I1y4mF0tBmPlymbpvk8svIJpW8mLsT8XdxWU7nxctH3jhk5ntqRfN01o9rwooY2A29rc8bWtGSi8MXE/oeaZfaOkoSBy6tndxTAiF3Zs7WwVnLpwiBguDIBSNhSLFoK0NJbJ+2+Julah9DX5m9qXXB624hakIRqsWSCcSqjuQdSlY1RPNAhHDlZsktiVeSsVMCCHTvbEvIes6gThqSUKDy9G4fXEQbHhS23cFoH9R644L8gxkB/4we1JejH8cCj8xvFrf3uqTk0/XIu6AlzIAXjg2+EBvbV+qMBe6zAzeUPo4eVGGl9yCTVrw2yU90XhCU2BZsIgc4ydWF/MaVH6XaoaZM4aUq+/qTU/dd5QsZYgsaAWO9kBsim2ci5AASLCdclpmBn75aQUHD8TdJlM8b65UBnkq9QXq98WES3RSnBHJlZMMU6sWuhxi064BOQRdaAsqWh1x9ybMNbdkRNIwN6j5DmwZpSKF3aysRGANcGttKsTJIpk2yu0PzC0WnSu3JGX+OghgEb47m6cNbF6AYknGLWM3cND6A5KQHrJnrXjVkTprLsqAIeRs8TOqukDHb8ApBo1Uvke+ZBheKLWi/weBM4FJ6rSTXaTHz4TMCIf1OUBX64V+eJqY+ThKdSH2OuQDbW7G2BOYUgzmBFdo1Z9ffh08+1uTigQqKu9etC9vFEaGic37FYmdjbqLFM0a6Qy
 F5xY6Jeo
 yosUs4aITErVo+qCxt7IdxYLslIzqsgrBcdac1nckDDKH7S7Z4LIF3WWtUoaI9EWG5eX1b6JGApZY1lBr3FG8UW7i3sSIr9gbli6a7pL+6adjO+Z6sS+hycK3qfyjT1tAJCqKE6P1WExTToV7UJ21pBKont+DGKyaXsBELdw/2AsAVeWDgOu+W3owWajM3V37eLvfXU8oL3UxEnFmxUCWQO4v2V58rS4QvKkzFNK1OjKkK3Bqph54H4eVYG7tGcGtVDUyA82STVZ34AqIcLxp/FkQVNYDRb/8xU/ORQnAmRiboYMVdfKFCyvTGMh1g/re6TcEq9kcn17P5mQ0iB0pcxKHY1nnaPzxgKZ0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks for the review.

Sashiko says

"Does this change miss an entry condition check in
should_proactive_compact_node() in the same file? If kswapd is already
active when kcompactd evaluates whether to start,
should_proactive_compact_node() still unconditionally aborts ... Could this
prevent proactive compaction from even starting for non-costly orders,
defeating the updated mid-flight check entirely?"

You're right. I only relaxed the mid-flight check in __compact_finished(),
but should_proactive_compact_node() still bails out unconditionally when
kswapd is running, so for non-costly mTHP orders proactive compaction never
even starts and my change has no effect in the common case (kswapd running
under memory pressure).

In v2 I'll apply the same non-costly condition at the entry check:

	if (!sysctl_compaction_proactiveness)
		return false;
	if (costly && kswapd_is_running(pgdat))
		return false;

so the entry and mid-flight checks stay consistent.

Bo

