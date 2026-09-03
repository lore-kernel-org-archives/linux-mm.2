Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9537AC61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 09:36:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 633736B00A1; Thu,  3 Sep 2026 05:36:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60B196B00AD; Thu,  3 Sep 2026 05:36:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 548396B00B3; Thu,  3 Sep 2026 05:36:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3172D6B00A1
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 05:36:38 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A4C6F1C21C3
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 09:36:37 +0000 (UTC)
X-FDA: 85171946034.23.F725D9F
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	by imf01.hostedemail.com (Postfix) with ESMTP id 683D540003
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 09:36:34 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=F7oM450Y;
	spf=pass (imf01.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788428196;
	b=bBBZ1eFrDahSqc7ncb75/YauZ91Q+uI1HirdrXYJy/gSyeZ26fc5HoVhT6yHvRXeygj5rW
	ri81EYFpHFuaGliEL+qBRMBBLuGdklq1odIi2OPf98xnqBLQFB8AbT9lx5wS2LFLcPsE4J
	y+WZ13O7Mcw1yZmDEK8xMHT9uUN5V0A=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=F7oM450Y;
	spf=pass (imf01.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788428196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZHXlcVNuqjzxvDs6KIJk1EVwoe1MLOPuPzurkmabzMM=;
	b=TUZN/GWWmPcWoPD/1NQVFzClOdVNEMi9IDil6OcZX3Blvl5a9U82nhffjrwM7aRwLISAL+
	cZwUE81A0D7a6ZvgLeNpbRI5Lqhm4IotRGDwDxL9oHOtHSd4qihjAjg5HrpJNmJYdtY1tC
	ArDb7tFyZOUGrVoFU2urLwSjFAbf6Vo=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788428191; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=ZHXlcVNuqjzxvDs6KIJk1EVwoe1MLOPuPzurkmabzMM=;
	b=F7oM450Y1nR2sK+4gsSohHqT5m7E7aUEg3m7cDJ7vtmG9w/YEM8z5H+r7VX17IgLQkHDylnis8x2ahCyxYWUJIV8sMNFogRMojKaTF6v9NiaFRmuG+0Ii8z44jbFOepT3AmC1ZjziTJu6Ipe908dHL9/XFUVkfvup5Xujz25zt0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=22;SR=0;TI=SMTPD_---0XAFZ.Pr_1788428189;
Received: from 30.74.144.116(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XAFZ.Pr_1788428189 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 03 Sep 2026 17:36:30 +0800
Message-ID: <0b983d89-1fc3-47df-9dd0-5a945f05d65c@linux.alibaba.com>
Date: Thu, 3 Sep 2026 17:36:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/7] mm/mglru: separate folio generation update from
 LRU accounting
To: "Barry Song (Xiaomi)" <baohua@kernel.org>, akpm@linux-foundation.org,
 linux-mm@kvack.org
Cc: axelrasmussen@google.com, baoquan.he@linux.dev, chenridong@xiaomi.com,
 david@kernel.org, hannes@cmpxchg.org, kasong@tencent.com,
 lianux.mm@gmail.com, linux-kernel@vger.kernel.org, ljs@kernel.org,
 lyugaofei@xiaomi.com, mhocko@kernel.org, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, stevensd@chromium.org, wangzicheng@honor.com,
 weixugc@google.com, yuanchu@google.com, zhangbo56@xiaomi.com,
 Xueyuan Chen <xueyuan.chen21@gmail.com>
References: <20260901232421.40157-1-baohua@kernel.org>
 <20260901232421.40157-2-baohua@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260901232421.40157-2-baohua@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: df7mwdz3zspm6ptk8g15aosbtehf6sbn
X-Rspamd-Queue-Id: 683D540003
X-Rspamd-Server: rspam06
X-HE-Tag: 1788428194-520201
X-HE-Meta: U2FsdGVkX19dshqYrQXLdW92z/k9nY1Q+LuJf9kjeEtqCljPeSx8AiHrhgPgTFcdoG54ufSuKkvOdu5tBkiNNYvJReejHFiPNHHtfunssPJSTGaVOgNlKxqOydNHFGuahmowOK+IMdoUH9mdBQ76yp7kker1twjIZMf63z3IYS784w/b2Y0MBOcDpAh4iYz2tvHv70UlvJhM2q37CvDNlonSldwmJceWHtb0QoZJm09gV29CpNv0+Aa8wCKnlK7uLIueFU+PnCJ/Kek5cQ0Q9+60+yjSXOK44nwhYXfpHVWvrpHehEnQdn3mn0ou6AAWUVbjHDszvnheYCCGVk5GOxtmjk3LW8VCUSNRrUzCvKfsdruVsIW0oIOHY6F1J0RIfjMQEa4vez2cPJnC9HRKd1GxqavRdnfryJZc+UpRvkcwojZQ/1pDLCGHamrbTdd+BbR6xHtnoy84zcwOUCo7i9qxN6lI6kg61UgsVqlPUMdBR2ilm+I3iPvy/xAWbB0GtIUTkxByOvDADulLz9Auzo2Brt8TiCBSFbAuiYfg0EIRiuDg0VJzGK+/uBYr/rGPeAkXCKot+4Hba/XgnZJtKPKbVKhI6hGSmKV5A/K/zxZaReqNkz4bAwGA5NpwKeugBuD1kGYIyDTI2XZAuvAuOhf+mId6/HxNdwOS79Bzy0PmAbTyor94ZFkpgekcAPnQzkZTUzw6zekApvUGJPatysytBAXqNgqFehEqDy4BN8tBc2sVI/27u2gZbu6/dSSAwuOyzWxDCxAYtJR2pDIGyo1F0mqk09CGoQ3UH06IXOVgC5GRIUqyRfP3Ev/DiJtAg6ZMQzytbj4VYp0GHSUJo2IZ//CPszm4RjRiYWI087Z1aFqf0ndJpW/giKKIvW9zdqjoBYmCQgyZAABbnF8u9GGiMtwmDxX3w2utUR/pqvolye+JKage6hl4VrwUwlKLuS8E5xmYZ0DAoo4vXfP
 7IiF72n0
 sh7X8D6JxYJnClkcRfJVWslKWu41fEKDi5dWlCEAkEyGjmQ7a9oyZd2QKGq8bOrnlU1XSYC3ee5GxqNOp/nnL42qLJTI100ljX8phcFcv5kuQN1xuKHLswoJxRCBzZu2zbhFS9xR/9FtEIWIiBG2AiWRaNFHzf90I+EIJGem11cb1yy7wBIiHkZZ5peYRxK154lWaNUtJU6j+Ul9dp33ABr/TfqSAfbe6decxaadnyugmlU+i+kBt8O0YjtNC0Hk7bRWqM1tC3AEZ3ERWD5gYYE93TPHoOk8XGgbj9TRIWdlBLyIPySUYCBNXenkCbAQI8cTgMdEtENru083FAwg+U2GbFe4TStsxgOTzF2Fan6OAp3pqNYHvPC/U/gvt+ZZ7+o+aDJwetbGYwx5ys+t+v/eHoV0fU3XYHg33jid9YvzFjJQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/2/26 7:24 AM, Barry Song (Xiaomi) wrote:
> folio_inc_gen() currently updates both the folio's generation and the
> LRU size accounting. This makes it difficult to batch the LRU size updates
> when moving multiple folios.
> 
> Extract the generation update into __folio_inc_gen(), which only updates
> the folio's generation and reports whether the generation was actually
> increased. Keep folio_inc_gen() as the wrapper that performs the LRU size
> accounting when needed.
> 
> This separates the per-folio generation update from LRU accounting and
> allows the latter to be batched by subsequent changes.
> 
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> Reviewed-by: Lian Wang <lianux.mm@gmail.com>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

