Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A461EF3D5E8
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 08:28:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C43CD6B0092; Mon, 30 Mar 2026 04:28:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF4786B0095; Mon, 30 Mar 2026 04:28:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B09D16B0096; Mon, 30 Mar 2026 04:28:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9C3666B0092
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 04:28:39 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 45039C2722
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 08:28:39 +0000 (UTC)
X-FDA: 84602053158.02.D5762A5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id D18BA100012
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 08:28:37 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="d/4p3R1G";
	spf=pass (imf05.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774859317; a=rsa-sha256;
	cv=none;
	b=5mgqw/Rd5u6FIBeO7n/dxpzJn9s9YmYclDKlCqFpK0WJnHWMLNLE+cxo6D9CCX1OTY2BbJ
	sXvF1lrQyK6YC041zXupr9QK7bbzB0EHPMA2u9ZDaPJ8boGvacv90GHnhqFcI/eHyfq3Q1
	+NMxeZXrHK5yRv8jrq8nj95z2I4C4c8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774859317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IgzYuhSzyXKBp0U5+kJhOKAm1JU0AhVD9r0q+WW9T/M=;
	b=a0NLWkgyfC/O86B/H5Z+tvw5c928A+X/adYudfcpt6cpvvZZaJHQpOEjLnUpMtsiSfB5Fg
	FaC0PJ1AY3eqH2FRbJJNgeDYQ/NMKC4uKR14NB0t57Swrhk+mBfmljJ/F8j8rEkbkI+WyF
	ulPCTJL1gOyrfo9l06J5MYRmvt+CC/k=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="d/4p3R1G";
	spf=pass (imf05.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5D0E7600AC;
	Mon, 30 Mar 2026 08:28:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA442C4CEF7;
	Mon, 30 Mar 2026 08:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774859317;
	bh=YDpASFjQCOTzlfzy12YCa/9uHlCwjv7msQ8S/X88ue8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=d/4p3R1GMvblqdxQVSK1PTCXpFz/7tDlceet4ZrIV8tf0mn/u3mVVLnjdsL5VDrh8
	 jo3fLS04eUYvcFZqmLfdBtf8MD13Em2sZsUK/kIkkmZTG3+7aiIzS/UI6Y5tBGBSGU
	 mbxJ/yTEEPYeL+Ogvyrj5JupUu6gMrqge6alNhL4LEAO244nAvln3SOP3R8ORZKHlS
	 4GlR2Fy7HQJOm/nF28b1zWSSJkVBt7ggPkenY/PcYUD0VwlX3aPTq2eE1DE6YjSHMn
	 HQGY8/7/1+1bo+L5gRrzVqmuRkWbx6agXcgCsgzPnlg4FtWg7uN99jtUPCBEPpVabu
	 qbgzTBbfK+lTw==
Date: Mon, 30 Mar 2026 17:28:34 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Hao Li <hao.li@linux.dev>
Cc: david@kernel.org, osalvador@suse.de, akpm@linux-foundation.org,
	vbabka@suse.cz, joshua.hahnjy@gmail.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org
Subject: Re: [PATCH v2] mm/memory_hotplug: maintain N_NORMAL_MEMORY during
 hotplug
Message-ID: <aco0MtqpysMXMZdy@hyeyoo>
References: <20260330035941.518186-1-hao.li@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260330035941.518186-1-hao.li@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D18BA100012
X-Stat-Signature: bfmft4wzunq1xukhsqm181ts9uebiqz3
X-HE-Tag: 1774859317-695563
X-HE-Meta: U2FsdGVkX1/MTN/hczr0pGRWeKSE09/x4kbyT34rZmfcxAVZZw2vEMawDYTkrjTvjqL7uk43BW9LhjeLqJDgYW5PRhU78ja/RFCoRvauVZCmhg+iuMAQghrpbUdwFXqEq70vri3S6E/q2jZ8a03GCFyVEZhvAs/muk8vAli63lYUxiS8YBMPplyFc20wuFbmyfS7ueK1bHPHHQwhcOTbTkL4GexdojfOjF2/lo9M1dwx/yefh3OZFOYR8Y5rLgXb2Y4Ijc8F4LIeuZZHCHhvMkmVd8vfXE04oeMKG88m56aZLjQA7CqOdj6KCIOpxH48wCRLJgMCjEscLXFOMAERn0Sm7d8pHPEsQXuJexhn0jhRTrEK4NCt2nf3m5Cxt6gnUCejOEUURlMM81oPlQWyr5lVoVYapA1qMgSvSJaKP4rF+qQdeRfTIEBCkY5O8mioi2OyuMAryL6sQ73UGgnA5krqh+DY2EztNZVo8QY6SVGqmdGpedV3RHDFKaGgpYBkVuNiXWPgDQivFaavAGukRDdckL873jAdlYKkKIJQJLIokjf9gB0l1USou4bLioEm+/5hocvopkTtFgv86p30oQ3Coj6QAZcqL1iZJn5JIQfyLjQOhn6OIVhyOXmhSHqozBzXlixZFy/5rM5EiCmyA+SOpm8B0VssToz5scKKW4NBW94SyBpWTINB3D+QYZ5HYF64kJLuBGIliyQCLWgJUs4ARGDLBwjn9Slf4V50+3vWNqcVkSU/17FU0nhbsRll+BJ8Rou4cLiX3Rn5vYIo7lyocbpjxh9VvWmCnZIdKhfLTCumbWkaQuZC+4IuzKuuOnnWVLiZ4lNme4ygibPkY4ZRDkzYs17OvEtCFRKKorxgmRkilI/nLliUyxc3vS3Nk00d9LfaswDtQRFFCjCzCSf2KtzLfT3rpt82Eg6D1zrr2a2eZclO+gDKvU15mv58i2wB6ejm3dzFKQgeeUm
 Je0Bjr/W
 mQCdxaIjc1tbwrHJb0xPNLXqSBTKJ3TqjHSZW1kNGPQSMwfPF64I1fxLpJIdqNkwTgOW4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 30, 2026 at 11:57:49AM +0800, Hao Li wrote:
> N_NORMAL_MEMORY is initialized from zone population at boot, but memory
> hotplug currently only updates N_MEMORY. As a result, a node that gains
> normal memory via hotplug can remain invisible to users iterating over
> N_NORMAL_MEMORY, while a node that loses its last normal memory can stay
> incorrectly marked as such.
> 
> Restore N_NORMAL_MEMORY maintenance directly in online_pages() and
> offline_pages(). Set the bit when a node that currently lacks normal
> memory onlines pages into a zone <= ZONE_NORMAL, and clear it when
> offlining removes the last present pages from zones <= ZONE_NORMAL.
> 
> This restores the intended semantics without bringing back the old
> status_change_nid_normal notifier plumbing which was removed in
> 8d2882a8edb8.
> 
> Current users that benefit include list_lru, zswap, nfsd filecache,
> hugetlb_cgroup, and has_normal_memory sysfs reporting.
> 
> Fixes: 8d2882a8edb8 ("mm,memory_hotplug: remove status_change_nid_normal and update documentation")

The Fixes: tag indeed looks correct to me.

By the way, MM needs an explicit Cc: stable@vger.kernel.org for backporting.

Since this commit was introduced in v6.17 and we have v6.18 as LTS,
this should to be backported to v6.18.

> Signed-off-by: Hao Li <hao.li@linux.dev>
> ---

Otherwise looks good to me,
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

-- 
Cheers,
Harry / Hyeonggon

