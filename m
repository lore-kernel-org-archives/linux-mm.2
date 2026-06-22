Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C03F1CD98F2
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 20:23:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 309626B0005; Mon, 22 Jun 2026 16:23:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BB526B008A; Mon, 22 Jun 2026 16:23:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A9406B008C; Mon, 22 Jun 2026 16:23:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CD90F6B0005
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 16:23:53 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 07B1EC1566
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 20:23:53 +0000 (UTC)
X-FDA: 84908674746.04.FCC81DB
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	by imf21.hostedemail.com (Postfix) with ESMTP id A17681C0006
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 20:23:50 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=cER8Xk3f;
	spf=pass (imf21.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.53 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782159831;
	b=1jAZ19CETy+6Y7vCfSBeIOw9/gmVKp3r3F5Au3Y3juFKSDSbIPULsETWo81rzYFE44pE2x
	j51swLF4FxU2dTLZ7b07wKzpG0l/JKcI/v0bOd4Tbl1ea9HrxWTiRdwA97VvnUB98FxRRp
	yH9Ote7lgxgrZFU0EI4Ig06CpaxrxJo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782159831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DmKAzXUWgr5Z6Z1mBVW0DXpsiSegxpV2RCsb4MGdO1I=;
	b=wALoXCBzOQp+z33XuP9/sWbwONFWk3lSkaTZlWktjtvjzS0B19R9fyCIH5jzjtFWOfKYri
	A0QeBo+vHhD7bP0uA/cC4VOgiIsqW+BdLM+PbLvbXZ3M/OCrJpa7dSnHKVyiMLUqZJDCGF
	tM2lBLYD9TL7vqJJdbky/qtyFu00T0o=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=cER8Xk3f;
	spf=pass (imf21.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.53 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-8dcd895a4c0so57517066d6.3
        for <linux-mm@kvack.org>; Mon, 22 Jun 2026 13:23:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1782159829; x=1782764629; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DmKAzXUWgr5Z6Z1mBVW0DXpsiSegxpV2RCsb4MGdO1I=;
        b=cER8Xk3fzf1Nf/zRGpm+I7OeQqDcB8dpRDfd+z+5uteHR+ucGb6hW7GXuQJANgaME3
         xhsrSZHkRPgyfxy5lyHDjm2dVDM6UvnrTJmR/o0HUhJKbgfIJcE7DDwf5Gow450U6efZ
         qp/RL2nim01RbwFBhft3q2wB4uCHzExqc4Jml+7MD9Ihcs5Dudihq47eh68iP5iGWx4X
         eldHhNSipbSapjYtwAHaRrNkotRrD95sycZ+tSet5VzlG1ctwH4x/wzo/JTUVhsia1tp
         Ubp9geHbRiBUJjcp0NpYw/W169jacgHpQRrIsghsCnKYbmq3Esrlr0zeldb3SELQAQcQ
         2BPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782159829; x=1782764629;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DmKAzXUWgr5Z6Z1mBVW0DXpsiSegxpV2RCsb4MGdO1I=;
        b=b/WJqbp+aW82MhTzy6Z2eHtSulLKW4e6+EH9fkkcAnrfAfDaBd6ez0iJr770DlGWH/
         c2fh+T4O1wie7mCW6iuF2/U6PI+mdEOazXOXGkdYHkgwauOJHmerKdbvNPih12RzYyGS
         yzoVOji/IoZ23lOWpT+iV29PXUZd1y2Evi1qXcFaaAxyOxP5SZ/d0wQo5JmsY4WhbSB5
         BUaryDKHcEcIfGz+vZoFAuEAUa3adPNMLIpfdmhv5235G8oOP/K89k6zMfad58RiTyXw
         8NGlg7Euuyd7RFfU7Z6mZ9g4Yfn6ytqIEhA+XowR4MtO8wsgAujCXFDARourkqLaAu0W
         3zUw==
X-Forwarded-Encrypted: i=1; AHgh+RpvlxskLQjWb3s29QXFHZF9FVtCEgm62uxaeuLsn9oii7fM5UGzMB2COE0hHBXJ/IiqgmSzkXG5lQ==@kvack.org
X-Gm-Message-State: AOJu0Yy0j/TY91amJggxvo6FfUsvOmzFgxqYITxcoLZSqBEeAk0Hy9aK
	jPV5yPuIFyBndkyeqyBBwsT+gqZyE6THsek97Wucant9EmZZKeyINGosk+yoN5dUpn0=
X-Gm-Gg: AfdE7ckUQYGKfR0mv29KC/lOt6aAjdUkU2+5pYJ/Xm079pFfmMbpl94DjjgS2QJ+AP5
	TJY4ZPGfd5me+tWn9QOfqBFRfdEoZX7sNiu1ZJvH+zwVcuCZAuJwAcCubkb88yI3iDnURd1PVFq
	o7r9GP/uUMbUVr7eIX4KIXLr0Lnt//E8qqnjhJ3uWNSlv1f7ezu5xr6xfK19TWy33qq/CBihtFC
	RklnjETjvLtDch4IB01BT8QJjqvy4kObo/EBi9d7HDnIP/SItt6DmZ5plja5qorEAvcBPEqIvqL
	zI/qXNmkGSGfshFT/0KtjQzhAenxaqyFILdk0qKVLxSbpELp25On9f1VC586gs2PyWpgZot49T2
	ydUXVoqoxo1y0kPa8hbzALrw9wCyWAfiHAxTHK/1xCEcqRhDeq+KUZP2vH7egBqhGRa7rTkBidQ
	dQzbQQJu/CZuw=
X-Received: by 2002:a05:6214:3314:b0:8c9:cb98:5fb1 with SMTP id 6a1803df08f44-8de3f78e4f3mr241102106d6.12.1782159829411;
        Mon, 22 Jun 2026 13:23:49 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8df81cde319sm105792376d6.31.2026.06.22.13.23.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2026 13:23:48 -0700 (PDT)
Date: Mon, 22 Jun 2026 16:23:44 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Jiaqi Yan <jiaqiyan@google.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH hotfix] mm/compaction: handle free_pages_prepare()
 properly in compaction_free()
Message-ID: <ajmZ0IPORONQ_Vs4@cmpxchg.org>
References: <20260622-handle_free_pages_prepare_in_compaction_free-v1-1-fcf3b14abcf7@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260622-handle_free_pages_prepare_in_compaction_free-v1-1-fcf3b14abcf7@nvidia.com>
X-Stat-Signature: dg8pbwrdwgk9yfwe6bccn8dbfq8skio1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A17681C0006
X-HE-Tag: 1782159830-572926
X-HE-Meta: U2FsdGVkX18IDguT3PMArh+9FjpPthnQm5Ash0OuV86elQOowRXdQ6xYl3ta+GFu4rOI+9RQybsAp6N6DfOOznyNKbf6pZ4zjLzJBbxwhxCYNEK4xZA+CWtSU57xhOTFeoY0zKXIo08iW5CF4yCTYZ1zE9uXj36umUxKbyFdU6JCckIssDWRIIMo9bPXHE3ACsIKGpb2SYGUeVHLQGmFpwsqkqGHGLarRg/5z0FXbjpI4898eMTPYjnSjtpmJS5yL6CTRHHXEQzXJUbdfaqVOoE1dgRrt+4sIz6G18fIH52QtXT+P9skY5vZNE6TfP6Sd4nN6nkIM8p3Pt0lnBWn3z9nSm/T5RDIs1SziPVvoTUcwfHVSojcwUSunwZiYMfRslMw2fCYfX6YOcxOiVpLS2NaHbUFBjmoa42OOB1XdUA133+pmyt/1mfm2s+pyf9jjcKKrNxILy9SGTS3P8EP2zg0VM1LvdhSKvhnzs580lRZ+iHQoI9ruUdyYuu8sxFk5Goy8wuLGwEZgNL9JLO+hCd2ichvMqHat0dFHMx/2p/YCnQ0sr0hWhrMw47FUIcYpJV6rH2qSQUstzymtxY7lqp6nkZcewZmptxL22MVMlZpye6F11IaxbdhaaUph5rf1rAVVP0xlORZ567migEqJBojal1wmn4sUvJsKdjjVItok4WgfTaw65GCrv3hfVUFyZTg1res+hpEqfvVNiBRQEBF3gkjk4KvwBNRuh2CDt5j7rFYJiJDzFBXq+ZNQFK4tdea6m5ctlCfi9G1LVv83Bnw0ZKOt6XFDrZGsncHPocpuBCOs/OX6GAjRRyIkHdt5eLQJ+6qlxUk/DWwbfgP7omfmzsDxOcscJIlYGaBOIbTj7IfceZ4Sq+QyFoCHeSWNocwZ8jyjUvf+f1Rz4L09CbvFoU/o62VnAwDFX9RtgwWeSux7B3gS5KDcpzhIXWoUiR9/mkYbCYJXsvjhqK
 2SYFgVeH
 BRxkV0mbvNkpWzDXheIo9WBmwMTeUcjbcvB/ymRIwpje2nVaP43qpyidJRCFb0W5EyF6MyPwF/psOXE751JcVNBOnBqE9d4gzC1jBP8R7aCxPLO1d9DT1r66mVBleLvzv/NOFI+wQUlB4ElppsnDcjJyT//XdxbVq3rqg4+QA4f+6IgbXlPXp3NmF0Kc3yrR3Uueq+FyQTrbOoXOBXp9soXZWp1HnQp2OchTXNBKthIzaHOzd7g20pFa6e/I5TiUrgWkPb/VYKa4gO81nFX/DsMBPh80aE1yYamuI0fRwNeMAFMRhz0cm55EagW48HbgIt14zfLwLk3MydrXujLIorz9wg6NHUBLjLRGmjpFbh7iHpRgAMs7o/zBKLbeuJREOyzDrh4LbGbZnb5RRVMwST7ni/huFEoJLJw333WsrL9Dg7PAVf7kxl3SXtn7eDaH63NQ5A75SBLEudXu1OA3LY3POEjoMeJSOOMU9SFuYwZOM083YWxtkMl57Z/dx+2mNDu6E5bTJxJJtJ2m32sIwyU8uSw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 22, 2026 at 11:30:42AM -0400, Zi Yan wrote:
> free_pages_prepare() can fail but compaction_free() does not handle the
> failure case. Failed pages should not be added back to cc->freepages for
> future use, since they can be either PageHWPoison or free_page_is_bad()
> and might cause data corruption.
> 
> Fixes: 733aea0b3a7bb ("mm/compaction: add support for >0 order folio memory compaction.")
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> Cc: stable@vger.kernel.org

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

