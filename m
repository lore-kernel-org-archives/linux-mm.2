Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADD36CD6E45
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 05:37:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20AB36B0005; Fri, 29 May 2026 01:37:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 193256B0095; Fri, 29 May 2026 01:37:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0823C6B0096; Fri, 29 May 2026 01:37:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E84CF6B0005
	for <linux-mm@kvack.org>; Fri, 29 May 2026 01:37:38 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AB4AB140BBA
	for <linux-mm@kvack.org>; Fri, 29 May 2026 05:37:38 +0000 (UTC)
X-FDA: 84819350196.26.B9A9258
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf20.hostedemail.com (Postfix) with ESMTP id 10A281C000B
	for <linux-mm@kvack.org>; Fri, 29 May 2026 05:37:36 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ndaCXlcS;
	spf=pass (imf20.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780033057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9VASAwgiYpw4DqJgbzJssFNBsWa2yfmiHUKRKx8zKLs=;
	b=VRieCPys9e8fpTV0fRw9LfuU/zb6T2QA44KWQaolpknLhsNtPo9zqw4m4HaUc9qkaWwWmX
	40etdi0TK5YwMthtAxoj/s+N+ID8kWzTk6LjQrtmmWgSTr29HcHrZy6uYA8qCaGqPRLkA5
	li+2Cca0yflxLmAeebPKCqmeAJZhj6g=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ndaCXlcS;
	spf=pass (imf20.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780033057; a=rsa-sha256;
	cv=none;
	b=oGu4PFFTAJnXwght4O9mz8N9J7vzBUpnlEQ2rzTf5YYSWp/JSLQMrc9q3AX9e881QHoMSv
	cQNWMW2EpDfqBlmakPonD6Vh+6L2zBkubkETZCmLacYZhbpVn4x6FoTLATHi3tl6WGwcAs
	o1eJBcRB8fhyhi4iTSrOa99Qp5GagDQ=
Date: Thu, 28 May 2026 22:37:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780033053;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9VASAwgiYpw4DqJgbzJssFNBsWa2yfmiHUKRKx8zKLs=;
	b=ndaCXlcSrs2qiNtCkoEJhocDDYeE4i4kCxOw0RNtDG96zSe/UUWHtr6Yx87BFrCNh0Y2y0
	OmmxwdymUPELGhUAkguhoO+iHyfsuTTPCOV27CQIE844BJxAWftn/r4YffBFYsRhj6HwZY
	wSLrq68kQjMb3rJOFF+9Ptk6J1Gj2C8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
	Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
	David Stevens <stevensd@google.com>, Chen Ridong <chenridong@huaweicloud.com>, 
	Leno Hou <lenohou@gmail.com>, Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Kalesh Singh <kaleshsingh@google.com>, Suren Baghdasaryan <surenb@google.com>, 
	Chris Li <chrisl@kernel.org>, Vernon Yang <vernon2gm@gmail.com>, linux-kernel@vger.kernel.org, 
	Kairui Song <ryncsn@gmail.com>, Qi Zheng <qi.zheng@linux.dev>
Subject: Re: [PATCH v7 02/15] mm/mglru: rename variables related to aging and
 rotation
Message-ID: <ahkl9PXrbgb9QyiL@linux.dev>
References: <20260428-mglru-reclaim-v7-0-02fabb92dc43@tencent.com>
 <20260428-mglru-reclaim-v7-2-02fabb92dc43@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260428-mglru-reclaim-v7-2-02fabb92dc43@tencent.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 10A281C000B
X-Stat-Signature: tobrmcagzce99gtmesfk7hdsqyini14p
X-HE-Tag: 1780033056-843757
X-HE-Meta: U2FsdGVkX18vyi24O3PPYydeUDOOa0b09Is7eoqLy+pbwoEsidL+cWgJ2AXp6uDLU0B9KuW0k8Fm01YmtTXcDsBTmNf7JB/7TDuT8CXp2WbS9rFq64O5uAtVpoJOwGYp0Jk9e1hMhhJE3ftKyg1qBlxzVZ3sbteHXRoY4CeiM/417EMx84LBvxVXClTBabty+ckNRvBeIHhIlmucBz/4VDHznOwmht8EIRbzS4MEdkn8Egv59yNQJ138BnFtNA3xHs8GF1mGF4Y6UbVpt8WqJJ6YyCKthUkYnHuLQbj3sV9HWRbx9peFuly+OuO11xinOZKNSxmcOMHVEXqnroVo+Bh/lCybfi6lS4jBUMqWa6g9RgdYiQGrETZsM2FIPXmTh4/dYR4oljy+E5OiFQl866qbnk41Lqh2CLc8hu1VQzebw8PfMWwc28eMqoXejsKB/HqFlC9vJKGzFfaDEexzevI0o06qPITUrtX8nGOgRiCLFbkTZH0PXJ4t6dKJakXTFcEo0YNjU2YxoY0BP9FOWC5QuS5D+2bcc+IfZPSZyrg36rZHdNdYEF4dSCVASUerTn6GvABgC7u3DJersb9g/JP/fKNEvTLYZyxoH/VL9SXwZiSupWrjt8GHVw+8pWApTwXz5627kdezO8unTaKUcmvGuLvWwE+drn5NqXDHr+us2IC+E2ESsBrW5Tr6rPMYFgO6/V2f8H6gMVc4YtZi9S6VIcMmKJDTF90V6YZPRuLNazzOPt31/2thXYNvWrBonj83zp/0ZyihMbNNpgB6qOa7+zwq51+49f3xgOgAluaQIa5zzqiRq/v3mYBefegSY67LjXvpp4xgPE/X8P5+4+7/0X/yxoNIXrCc5XeAafOlD4obmVZc3MkY+DZAq+6E7zuDly+l4lY0SGjsacNJBQpWkGvQHJqffYpLJBoeofmihKRGdhnadUpJFlp/WRhPUkf9s7Lw+21ocaEUv34
 9T+2EKDr
 S6+eIQS3ukl/6VtlMTo0sFT0AJfGRaJW0a/YB0Q+npV7GZ6d3k68VOpb18JE+DV7csT44ftlF7WtVV3PQIHinUUeNgAvYubbXoOz2Yv52ElcXQ5ncihL8vxnycJkk5Bhpvn3WRqoUBpUnB05Cgwozp1yZ5Qsm96Qel44T+zQXt9X/OV49PZZYpqX7z4AC8kRu5BQ/UCwGTvWamW6+3k+zCVgAMNhsPXFUSJu9Ta3x6kABZ18XntJDXcgUuTGBUkWVdY3M6ggrUr/w8wur4rV3NsrN1+bsJAn49++gmHv60yO24ePUXWTJ/zPjTo7dms+1+JsKyl8lFvb+/ZuvlmmE6PMVjtB9o9cYrH58C6xS6FewyE9qH/poKHf7/7EZF6fKYm7NtD9UTluFa8I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 28, 2026 at 02:06:53AM +0800, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> The current variable name isn't helpful.  Make the variable names more
> meaningful.
> 
> Only naming change, no behavior change.
> 
> Suggested-by: Barry Song <baohua@kernel.org>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Reviewed-by: Chen Ridong <chenridong@huaweicloud.com>
> Reviewed-by: Barry Song <baohua@kernel.org>
> Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

