Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18CB2606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 00:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=otZInzdJ
Received: by kanga.kvack.org (Postfix)
	id 9316F6B010C; Mon, 19 Oct 2026 20:36:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E2436B03C0; Mon, 19 Oct 2026 20:36:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D4916B03C2; Mon, 19 Oct 2026 20:36:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 505616B010C
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 20:36:57 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 805EAA83A1
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 00:36:56 +0000 (UTC)
X-FDA: 85341139632.27.9D9C514
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id EF8D240002
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 00:36:54 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=otZInzdJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792456615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tYLzgEFMLbU+10QLZBwGrlpV/UdgmwvgieWaGFdOtj0=;
	b=5vXboAJEnJGRta734yL4YVW0ZVu1bR7SRBi94jdV4GCTQgLgkpMEl8EX+1sr55jGGSHlxS
	itnfVs+EpoWXc4ifMg6Mqp45BF1z6j51Vainf0J0cztSzfk6SbFGk/Zyq0VZ3ASomMUhUT
	fwyIl2miPdmUq8M8XURVZjyg+hZ1RiI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=otZInzdJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792456615;
	b=hfUZ4ANoSb6XFh0VmfcKp1sMeB+g4nZxVO7p9EKif3nEw8LdRM99ZPwR1TELGzi0RNdqXE
	c8Y0ZU3ri7rDrvbyU0LvQIBYB/gyHIzGeLhVwyMo7nwJEzBmAIWZQef5tphw9Imyjpc5Bm
	+mJos3VqeVX2fI2JOrZaloSz/4kS06I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2AAD8408EE;
	Tue, 20 Oct 2026 00:36:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50D3C1F000C6;
	Tue, 20 Oct 2026 00:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792456614;
	bh=tYLzgEFMLbU+10QLZBwGrlpV/UdgmwvgieWaGFdOtj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=otZInzdJ0WqqGTrJUKQhZw7pVa7NMN17igKQC+9rr6tbJdzP51fDgHCFkWSl9LtZ8
	 fM8YmPLMMJ1yKftyPi2B8nEG2QZVpyCxJ/Pq9nXCGH3W377WSFxbn5KLkEAbz4vzX9
	 FMIVuIbgRapHFExU9ZkKgfor7qZLd4s862FaHTb7Vl71owzqXEJsDd+tmMmko5jv0s
	 H3IqK7C/hb3UEMRTu6t+JZbgh2U2VLdm0U+L370MeF4WXqHxh9I452ZMUaXSSY3Ah3
	 m7xrHUpoiXZ2nxhGQ8MCQGfRhzAULebfxudD25lHj1z4C2H8GVrZliOyF0uPKa5LI+
	 TWRMqqWS8u2lA==
From: SJ Park <sj@kernel.org>
To: "Gregory Price (Meta)" <gourry@gourry.net>
Cc: SJ Park <sj@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,
	hannes@cmpxchg.org,
	david@kernel.org,
	mhocko@kernel.org,
	ljs@kernel.org,
	dave@stgolabs.net,
	roman.gushchin@linux.dev,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/vmscan: reclaim every zone in per-node proactive reclaim
Date: Mon, 19 Oct 2026 17:36:45 -0700
Message-ID: <20261020003646.105993-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261019185002.3428594-1-gourry@gourry.net>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EF8D240002
X-Stat-Signature: bsfjpgdhybeqm3mp9q8fnscnskumsxbd
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792456614-209722
X-HE-Meta: U2FsdGVkX1/jg7/4nnhtfv+XNF1iITnTuUdF39EBiL3DvYaZKRDoEVjdcZPl537nmd1h2uA9Uw66Jg/AWsoPzyaoWX6sYacoUBbWsLENwP3neWAhukSP0aCGfdCGe0jEd7gSOuw+kgaVvG4DTUfSDWVH3Zy0+/ce9yGximnV54Vu7Kf24G1HM5yr4WPnBlYPV40I+9uGpRKZOpEdsIpgmuNofM733CdLUkJxunJbvT8+zc52tZvpCVg5Zb/LMA55jUZGr16MNp5brfIyRmuxzEOcecA3RchxNHcMIUMTLDc9KNuCV2BLpF/tZGR0Y0XWjCbU72NrVeh3tgfpkDrNiUXITrSmixUBGd06qjH6bV/J0PPrfjnLtlYz+APKCFbp3jzuAC/dlhSunocaezQUD66G63MX8QDLFpTEHXf0x1RQcRtFURWc0//uinDPZ2AjjMwaO3lpyU/W/sFWdoHVzlq6mLPKBh4knLFDZN+coryY6UrE1rrgOe5DREJJYaT5pcqQqRpKw690lbkoUUFHrHoT9Vnf22d7i5ldDhlEVivEWDMaQl+nmJpq8AuUotRkAwaqAURCMWhT2LtePWPOQ6kwxLhsXGT2n0EwUMkx3+N6Q+fN0DFZdTTYrPiad5psRk1AXLPwDjsi2AITh8zoDFL9ffkKu5FhJkZ8m7+EwOY8VO6H3ofwpFdzp65xnpCdD9DK6ceBbrccbKRfhBgvf7LQreIWTLTHvGFAP1XBtB+GAPZ3fTt/FL+gehXNrfJOwBV+1RadS4BskOTeQP+3PR6dQpffi6iIQUzq+3nMyThOEcOzVA84e7vrFhIcG4OW+Qn+wI+HwbO5DHhNIdKpY9tLlvWDcFAGP96vY5hC9B1ePQgmvzjy82eK0XcAhsMZXVvIHlwQGDCunYIi76qwRpKXApQI+xT+HQHMKW0KRFAqfxhHjLwEqtbY3ZrWScZqWlCMdaHCusjSvf+FQqb
 bTWEgQWZ
 qNLv8q681DwQXYppR5li9j3FmtZOowZjQ+1H5YeVYSdbRNyeLJres6h0O9cEeIOWZPRz32EkfAciAEsPEcHXsQwTfP1A+TCEGXJ7dTVJc05XvttM0L0D8y8WIL6Xm9A6jgg/9NZsoHNaE9ugjwm3w+8igsWnGuPqKi1zlzL6sOkgxeo05iKBUlzDysmOCA2PMk8Q8tMCn7tPoPVCKCZ5COrLLYtkAH4+XRmy229ocRnfn9984bJc8mbak8/Iz/hCypPyC0EDq9d8hTG/9jDDUHuT9SwVBv7WThhEH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 19 Oct 2026 14:50:02 -0400 "Gregory Price (Meta)" <gourry@gourry.net> wrote:

> user_proactive_reclaim() limits per-node reclaim to
> gfp_zone(GFP_KERNEL), which is ZONE_NORMAL. Proactive reclaim serves no
> allocation, but that limit makes shrink_node() skip every ZONE_MOVABLE
> folio, so writing to /sys/devices/system/node/nodeN/reclaim never
> reclaims a node's movable memory. A movable-only node, such as dax/kmem
> or hotplugged memory onlined movable, reclaims nothing and fails with
> -EAGAIN.
> 
> To reproduce, fill a movable-only node with clean page cache and write
> 200M to its nodeN/reclaim: the write fails with -EAGAIN and the page
> cache stays. The same write to a ZONE_NORMAL node frees 200MB.
> 
> Scan every zone, as memory.reclaim does.

Both the issue description and the fix make sense to me.

> 
> Fixes: b980077899ea4 ("mm: introduce per-node proactive reclaim interface")
> Cc: stable@vger.kernel.org
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

