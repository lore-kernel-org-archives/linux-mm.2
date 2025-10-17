Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12BF6CCD195
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 18:20:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38A768E0012; Fri, 17 Oct 2025 14:20:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33A9E8E0006; Fri, 17 Oct 2025 14:20:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 229AE8E0012; Fri, 17 Oct 2025 14:20:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0A4468E0006
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 14:20:18 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 835334D1F2
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 18:20:17 +0000 (UTC)
X-FDA: 84008420874.07.B1F7D43
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id EFAD1C0016
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 18:20:15 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Vwq2wUjl;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760725215; a=rsa-sha256;
	cv=none;
	b=GM1JIo/BZFo75v+0L9JFBkVdyBJvbRMPq1m7/8ZlIJGKMEPzmNNwV4vMfxnUmNNmDoHqLt
	/C7EpZRv6RLoXw5uMcqnJgGikwE3p22DpIEan/3dp3xIRzR7Ec0xRoDBStFCkX7HXPZXJh
	er0qW7JG2uyzoMW+0jzNxyIvPP7CPQk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Vwq2wUjl;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760725215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AM67p9xsM/ybJDetY9mA0SRKrMHwMnPpNPBtQIGWPaY=;
	b=p6dlQa8CIHrOCsep5KLhRG7JpoYj1rV3K8PvG1vBINlS1NhyyrqrbAwnNTcyLLRqIXLe0h
	J6+07xdFp9hOYa2q9TVQby/t+hPJQx3qB8bGyWuYk2e9ryfde88Y95L87XWbcPFpVxisYm
	VNcpECw5YS5EWw3wMYuoUQN5eiifuek=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5F8C464831;
	Fri, 17 Oct 2025 18:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB6BBC4CEE7;
	Fri, 17 Oct 2025 18:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760725215;
	bh=N7DJTkgdFq2cVtwSeDRgEDmegzhxtatOlmC9hFsx/jU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vwq2wUjlPQJ305VOVK2SUdxUZv760Gg2pHU/yKSLZwbT+CW2S4XSTDxOuK8fXDRd4
	 GsPNGXzw6fKokxPiVFRR1goVQ7VTX6Ah5i9z1BDLQceUOCTibvomTJpiiP6ZLr2du6
	 S02vW7CQLJ/YgK5IYYldYJghS+ADZYHw4qzM/x4bXsQjDoGj0fM3F58xYTGd6fCHlo
	 ksPaoup8k/GOIAZOh1+ew70+l/6K2YIuE7q/7mw3go4kCoHUzMGrYYmlwKU5rIQH2N
	 7qPAXa9d1qjFJ8KwKrDUqRrfYw+lrT+zsecq9IcP5ZhBo/wyMIfCFRKwe9v7th2hUP
	 CUZYfpRtzAsfA==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH v2 03/10] mm/damon/core: implement DAMOS_QUOTA_NODE_MEMCG_USED_BP
Date: Fri, 17 Oct 2025 11:20:03 -0700
Message-ID: <20251017182006.124211-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251009212042.60084-4-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: dxw5hz3p5wekzfbd39pyj79eoincq8xj
X-Rspamd-Queue-Id: EFAD1C0016
X-Rspamd-Server: rspam09
X-HE-Tag: 1760725215-11440
X-HE-Meta: U2FsdGVkX18fmsbF1k2eoW9LHBksbJECVKQy4MbAPQb6/DWO6mG9G+k8sHTDg5J/F48pRgykHAoC7nf/ORQiodbJ+dFfOXN4I8QmhNpSJAAhej8ju9cJ/jL9grcpcO239KF4B7BP9Y1CY27Wt2lcVE20y/iGfuXK1fsFxAeut9O4Vhuy9Rj3vsF0s2Vxmd4o3+Tv+X0WhzR7BwiCYy0bfd05XSBZz8lJyquudstltLVu5LCm8UYYTpy/iEV7fyDcnd6Q6tPccMJivraiLI+5q/bty4TzHRHIONaMmmcaqVfgwqMo+n+pQT4ik4k8a4/LrBEVMPoFsUwJF9t0XRZmpq+TOyhq+6w0ZKhH1cDdOrviKpRr4bxvxLhVEynETvCBddouBnRTa6ndNIaYv/v/CGoj4wLQthiBVzMUHm1IHX3W+Val0FZ5sAg3yGySnWaS8vFCuO1fWrOtZuK7QZbue0QqgTPzisyLKpR30TxC6IiSdGsTYOibEaHlLe2PTT11uNi8ZqheWHUBsq+74Zwf6ajxkOymEW2p7yZTOE9OMM/8GVriUwP0P5DRB2oKAVqUkT9goZCxrz3W/5BurMSp+OBB0mAaugfrtfih6BcqzO/YPt+FoQ/gc4Lcw2DjBq6MQ1tF0D0ySRr35kcJbp8yGJuC27fqbZEFDfoaR0ai/KdvE43EMZviwHx6wBcRzXyq/FJq8AZKjaztlCK/hUfT5CAeE2khQWsmMIpzCENs5+bg4aL7o8SHrh4J2ju8nmuD9f/NHEAm91oNPp0Ocy8EoO7B8LbEGqfKqNot3qsod6Bt6grec3pH/53D2QAGtWd6F2FTeZp8QvYQZ++l6rMsGCuWnR7DgaVED7/CLcF5x0NXMyf6d3bbjT+6R5EEpeDzkmxcQnQBPbS989Cxd+ej1+UnbyuXDMReDE+F7o9ChoAF/2VtSTkirWcHzKBnvtJZGn+eIqXcqoJLYhatJF2
 yrw5gjP4
 b4YgOUMFbUd6IjE6cbhIl9XhvkFme+3MRYWAi+aNPMH7ea1RLgsKRv+/GS4XuDW5cYZXuohaYSvywyog8PYq3b2+mN66F7efLvpwUAASMfVHXZYtCbzE1e1TNmnd1TkN14ft9/EDXCwZw82IQElGINiBSROFmYnAIeFIAbDRglvdHb0bqvOF+9LdUFE72tv5p8X7aG2Auf5YnD2m6QdywCuCyAB5tBegKGbQoi2VzDrM8BGg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  9 Oct 2025 14:20:35 -0700 SeongJae Park <sj@kernel.org> wrote:

> Implement the handling of the new DAMOS quota goal metric for per-memcg
> per-node memory usage, namely DAMOS_QUOTA_NODE_MEMCG_USED_BP.  The
> metric value is calculated as the sum of active/inactive anon/file pages
> of the given cgroup for a given NUMA node.
> 
> Signed-off-by: SeongJae Park <sj@kernel.org>
> ---
>  mm/damon/core.c | 38 ++++++++++++++++++++++++++++++++++++++
>  1 file changed, 38 insertions(+)
> 
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index 93848b4c6944..1eacf78aa358 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
[...]
> @@ -2058,6 +2093,9 @@ static void damos_set_quota_goal_current_value(struct damos_quota_goal *goal)
>  	case DAMOS_QUOTA_NODE_MEM_FREE_BP:
>  		goal->current_value = damos_get_node_mem_bp(goal);
>  		break;
> +	case DAMOS_QUOTA_NODE_MEMCG_USED_BP:
> +		goal->current_value = damos_get_node_memcg_used_bp(goal);
> +		break;
>  	default:
>  		break;
>  	}
> -- 
> 2.39.5

In addition to damos_set_quota_goal_current_value(), this patch should also
update damos_commit_quota_goal_union(), like below.  I will add that on the
next spin.

--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -825,6 +825,10 @@ static void damos_commit_quota_goal_union(
        case DAMOS_QUOTA_NODE_MEM_FREE_BP:
                dst->nid = src->nid;
                break;
+       case DAMOS_QUOTA_NODE_MEMCG_USED_BP:
+               dst->nid = src->nid;
+               dst->memcg_id = src->memcg_id;
+               break;
        default:
                break;
        }


Thanks,
SJ

