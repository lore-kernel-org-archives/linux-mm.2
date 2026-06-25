Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20B1FCDB47C
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 00:10:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78B3B6B0092; Wed, 24 Jun 2026 20:10:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73BF76B0093; Wed, 24 Jun 2026 20:10:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6793D6B0095; Wed, 24 Jun 2026 20:10:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 440B66B0092
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 20:10:30 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A83F54024F
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 00:10:29 +0000 (UTC)
X-FDA: 84916503378.30.0026B61
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 161AB20002
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 00:10:27 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h4Qoor1r;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782346228;
	b=QjO9jPzKfx+AhpBahhGigvvNtv1F20ZNJ/W06LWjf5DfTKSogBfdCYUChG0boeTqbxrf59
	PZoKdowcq/MPdSlGXixsEByJE9m0hYJBIJjuJzh9NHoeljBEuEfd5h6v5/a7tESWm0qA8r
	EiUdp5Tf3wAbnO5fJqieFDvE7ZnQrl8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782346228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oYYvJ1fa11WriUAAkZ3OTeyNq8CrXyDcpAuJQKIWx9g=;
	b=UNGxv3YvlGOUWIh14Wf1FKuvVl+DYOSVqKxHmC71O0wXUVNZ2RveQS4TS4d4zSL8DI7xuF
	CRhqp+6SX4M8hLNwpf1y7E1bMG2urHfqKsPX+Z7b6CsS3r8mZYO+qMbaSWBaEj+IEyx0ok
	wumsgaUAmTiT6sP5UX/Q7hx1ozR/PnY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h4Qoor1r;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 399AF40980;
	Thu, 25 Jun 2026 00:10:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 894D51F000E9;
	Thu, 25 Jun 2026 00:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782346227;
	bh=oYYvJ1fa11WriUAAkZ3OTeyNq8CrXyDcpAuJQKIWx9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h4Qoor1rOXUgchWCRCHn6zSHUBT8buGsfoJOrRb7VQzL6lvYkx+LVK3DRIQ9vb63e
	 DRsNpY1jz62QQ7gG+DVARZMw23a/AHoO3n+WejIWZyADMyk9m8qt+4vW318o+aHSxc
	 QXZCMgYgvkThofQp3qiM5XK+4ZZdda8iN06dNoBRqBbaWgQRQfkBXHa1Bfmn93EcNK
	 re14wKrEXF3Y5AfsS1pC/hCgs02RgFrnY6+wuAZCxMc2CF4tNIesY57EERgjPUpJUx
	 /+3jZbApi4wbupzv5rg6Qk6aANHsn7EG1PF8qA8f9uZvBCFooS6E6Dc2o6eZ9JOuWW
	 q6suOjpnVX2XQ==
From: SeongJae Park <sj@kernel.org>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	cgroups@vger.kernel.org,
	linux-kernel@kvger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH] mm/memcontrol: remove unused for_each_mem_cgroup macro and cleanup
Date: Wed, 24 Jun 2026 17:10:16 -0700
Message-ID: <20260625001018.95717-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260624183700.1152742-1-joshua.hahnjy@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 161AB20002
X-Rspam-User: 
X-Stat-Signature: ix1zimrzhjreywncj4pj5ensq8pjoy1p
X-HE-Tag: 1782346227-775430
X-HE-Meta: U2FsdGVkX1/d/lZu7FiZVf3tQUo9fOSXkHtAedvVqEGLX+OmQlbWBJriV6+h7zaDy2oNrtNCsCIdX7kAM3QQJt/R27sUDrL7GjUry31cjp9UzGM7y0DSs1dRFOck5Vw5MjWAyFYSeDZr14rhLaGZlvy256uvINoiZS8zqrr4gB+2GV465Z5mS6KHCLiXkD+NtXzZXBgKyUZJIFFBDgwm6EVoI2oTCoNx4nuIrm9ezi2lOxLCRPvt8tthrPp0Z/8u763+RMZGexw8i0wHJpMz0fb9maJIO5lWHOZidjPbp5R4gaFBMHWu1sDqLmAU9ZgOH8FhdhqnVRYQOQOngdRanU8bFqQ8h0aPEVhOI8GEtcRainlp27BQYaIMITYZBDobAOJzRlcdoTtbntYf+xuruUcMfJ0dvtaZLOjvppYZkOc42jsOXSlUgVBgiXDHobfX4x3zjuisMUiV2C6Cxyf5Qf7csBoM1NUJ9vGGOm9qcR5dvMjRVjdyJ90uTZZLNgVnmoLvZyDTSVBkQ9WMn1YdDwCNHk9DyhAEqyMBlKY0Vu239kfPrWba9WCm1WnmqGXZiCMhKlJSu6wEBU4k9oqsa9MxYDTftp92fGvGmxAkxQrQXjTlBvqDwJul/0bDa069d6MwrevQ39fyt18n2DcVZhjjjlejhf1BNZn0aXlZSkhN5zxb48i+ijwtPBypDYzw5H4VfTJT4b/gGH8/jrJIW0M6at+ayQloZ9FfgM0o0HgqmVVPgpNCECHdfe6MFMTNl1XvPMgwsCbj0w/ghEkZUFRxaEyM5VMTXx4fvY9OHJbYGQ4tsecacj4AiapjoMBAzpPLz+slWGBOY7M8LSnYWOB+FDnnAeapu7tFkqmZT5Dnu7ZiC3eFgFjHo0z3eSBxIwRQW0N4P3S9W0daBMYVGoOCgAlJL8zODiWRLET8REu613hyVmDHvoExygWoWA1hKQ0zTT+dkb1tzzwgTQ1
 gEQBCuu6
 X25sV/HTw3OR590NcogdT9prujIAElFFgY5eF+GEOKk7r/3qbHtZH5leUhwADChI7NzMJ9v7NAg2vMb5DvSpkZJsD2z7TijZbvM4Ajna/871vCFG7NwzrsRIHcgLNqbSSdbbUlQn1yf5UR5AKTSnp6wT/ro1mD88BEjAfDCsDcx1cBDQfH5ooGioFzYVHz5L/bCUOWCPQXU/+vWjlBgTSqINHl3G7vsKVe2Hd+ByY3CMzmAlx/86N3dqnSyA+bqRDV7gb9FXZCvdTtIBp3k8JpJsHMoeIxzOzojNtT1LpsR6pFSQDQ7/iJCfHjnmdJ+k+i5jBmh/4i/pDcTR6Pdhk0lysLJ6AO2wHLj2x0ZR8tzy04RgWdFX+657TO2WUC+Bm0z9iqovdaSKhJU0xyCct7wRTIw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 24 Jun 2026 11:36:59 -0700 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:

> Commit 7e1c0d6f58207 ("memcg: switch lruvec stats to rstat") removed the
> last caller of for_each_mem_cgroup back in 2021, and there have not been
> any new callers since. Remove the macro.
> 
> A comment in mem_cgroup_css_online has also been out of date since 2021,
> when 2bfd36374edd9 ("mm: vmscan: consolidate shrinker_maps handling
> code") open-coded the for_each_mem_cgroup iterator. Update the comment.
> 
> Finally, 99430ab8b804c ("mm: introduce BPF kfuncs to access memcg
> statistics and events") added a second declaration for memcg_events to
> include/linux/memcontrol.h, duplicating the one in mm/memcontrol-v1.h.
> Let's clean that up too.
> 
> No functional changes intended.

Nice cleanup, thank you!

> 
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

