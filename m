Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21F20C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 14:34:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8D0C6B007B; Mon, 27 Jul 2026 10:34:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D16F36B008A; Mon, 27 Jul 2026 10:34:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C05566B0088; Mon, 27 Jul 2026 10:34:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 966776B009F
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 10:34:40 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1A34A4076C
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:34:40 +0000 (UTC)
X-FDA: 85034802720.06.8A72BCF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 673F2180014
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:34:38 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g35nxHXI;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785162878;
	b=cHszQp+L7KIuzHXbpvTBnLPmJLIM3loj6h8fisdte8Yc/L1jgGo8BltITATDKL2Z4LMh1+
	b8+nt1dXu70X8ogmeNcE7FGgKKps55ND1huAqhhKa0qvvrDDc0Iajo5jvf4ZDUnDVPBWg+
	PsRTALw5AFTvb7O4PHQS91JztK41KI8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g35nxHXI;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785162878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P4JHLF6Mi/GxghJ2fQ1a+xylYvWRq6tTrCeZSqHjYps=;
	b=ZOaZeh5bNYP3fXhpvBe152WutV8dx6P/kZEWYSokk6m81V3GhM6cjNhiSJ3QZySjKu/wAP
	esgsUVU6WBK5DEYeYNeTehNMsdBYoqhp8FXoFRrOmglbOFwVy4PLCgqUf5EWPZR6g4T+GZ
	N0OqdBs+ARs2z+vnXgOJcd0IF2+eFjI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8EFFB41FB1;
	Mon, 27 Jul 2026 14:34:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF4D71F000E9;
	Mon, 27 Jul 2026 14:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785162877;
	bh=P4JHLF6Mi/GxghJ2fQ1a+xylYvWRq6tTrCeZSqHjYps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g35nxHXIiFLFQgEgbWd4pLcZOp4ymxKryP53wty2vXI874BrAsD8HlPn0xA5bYRKp
	 gTWhh9b0MK/Jwk/9RJhcgLuVhvfZM6MdcNiat7ejv8F3Zx0iDOvmQFwDVm+vUu83vz
	 g13dzTIaKm4MxrXVehBPvPONqDq1gndNg9t541sthDeKoMF9t5BQ/tM6LaL+k/3D5T
	 vurPNtrjzmUDgADKZr3j0vqLiQ+q1RF+6Kbh0/YFHWVqISde4TJ3Jia4LcfC14K0bZ
	 w5oDTGoxnGZ/bKDaNY53/5dJXxh807K8xIlyXIV+15XNF2xD8f1bu6nWso4n73FiSq
	 6SWzILuaBG9uQ==
From: SJ Park <sj@kernel.org>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	Jiayuan Chen <jiayuan.chen@shopee.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH 2/2] mm/damon/sysfs-schemes: report the number of tried regions
Date: Mon, 27 Jul 2026 07:34:33 -0700
Message-ID: <20260727143433.85732-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260727095429.143527-2-jiayuan.chen@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 673F2180014
X-Stat-Signature: 37casusg6ukzy9upiw34p1qtaoe6g3c8
X-Rspam-User: 
X-HE-Tag: 1785162878-327324
X-HE-Meta: U2FsdGVkX19zIiPztmLWVJu07GZoTaGiw0A6Squscfei6Q3eXKFukOXmViYVn2DDiw0wPhPNiFhUMx0PHmEXrDSKhYVjtt0w12NZ6lj8dx46bx9GauRGx0B30iLp6piJ4/ywSAkz9rBC2XTEUE3N5plbbcfSAVxaFlrv+vKgZM+ozkIduEY4Egr+O2PybQk4jvjlKSDm/3uZqPOqU01YNh3msuyK/qPTNhwc6Fo0Ptjb/5MDGGG4mpOh1kQjKeDfZr1SN2ofus8sVQOj8h9iQ8rKIMojBR1q0AXzryYFBY+bWJYadI/1CYiOa4LS+MNpdTqiEm67VGbGdLh1sNi0hfYXvOkJskb/vAwbMeg0kNQyP9A7fMEN0XmweZ/ezP4s79MAUxR2OF0DtZv5JhgVzi6baMercj/xzhJ7AaMwSyI2jnhCJZAWie+nEzTkRtxv3rNtGC4iUD8YnivfpWsp0mt7JU/ArVN7HP/h4+rm70UlwhWnnznYiQcbCNS6BwZuK6YNHrVMY6lsXCt7AIPchBMld+7xzrCfnZPUICN+GLJlqpcdblsa1g5mmtd4fQyr2ph8NmSuisnPk0IkN3DslWwtprYzC2aROIgL1/UtXULXsNsXn49hG/e36FgRlQY/XuFvbwOIuxTmeoEpGdxqAQ2ampGLuJzsBWYFqXcXASdieLxUsX27KdK6NaY4r6tJaOeZPYBPgC2rCf2g6uvWuMNZoCTQi/pb5ZvArsvWeUzt+EFkC0wdaQhIXxnwtqZKt1CmgSea9vtEtVUPZyUdzTvhXxK7vxHATqrYacsSxd1GHmRQhKTPewILtZkOwcHUbWWxUV60QcyBpES0UhXlal+zsoWGC5ipYPxY6H80ExkoWqFdgkRfXg+hQRPT1gg9dadzo716gdC9Y7sJzCcQWQJQqXSgTTFeSDDHHDoPcayxzxUtsxw5YWAAocNGv1fxsBYOASUVr9vdQUWp+eY
 JL71v7w5
 /KJWQeHD+fz0Mw9EreTgrLyRLmr4RGZ2AJbOJaQnRFXq26SDCQRB7gNjcpm5taU5cu+pORQy4QQf+Y9E92+UmVYAMd3tGLrMW3Upvvbk1knVk4NoI5dE+CwKDBC7sUkKIooa5JD/Sn19CtAeVdmFjt4d4lr5y5TWSTqGhQ4clZWswuH+U0Mvs0gMcDhvfm40ohDr940V3ywd1OizcPoHfPET36rrEy5egUbcdWlzV/QHj3souERGEjvOOu1Fk3S6DCLzHSIi+iK+ZaWY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Jiayuan,

On Mon, 27 Jul 2026 17:54:23 +0800 Jiayuan Chen <jiayuan.chen@linux.dev> wrote:

> From: Jiayuan Chen <jiayuan.chen@shopee.com>
> 
> The 'tried_regions' directory of each DAMON sysfs scheme exposes the memory
> regions that the scheme's action has been tried to be applied to, as
> per-region subdirectories.  It also has a 'total_bytes' file that reports
> the total size of those regions without materializing the per-region
> subdirectories, so that users can cheaply retrieve the aggregated result.
> 
> The number of the tried regions is another useful aggregated metric.  When
> the scheme's access pattern is not restrictive, it approximates the number
> of the adaptive monitoring regions of the context, which users may want to
> watch, e.g., to see how well the monitoring is refined under a given
> max_nr_regions, or to feed fleet wide access pattern dashboards.
> Retrieving it currently requires materializing all the per-region
> subdirectories (via writing 'update_schemes_tried_regions') and counting
> them, which is unnecessarily expensive for users that only need the count.

I agree the number can be useful.

> 
> Add a 'nr_regions' file to the 'tried_regions' directory.  Like
> 'total_bytes', it is updated by both 'update_schemes_tried_bytes' and
> 'update_schemes_tried_regions', so it can be read as a lightweight counter
> without materializing the per-region subdirectories.

You could also get a similar information from DAMOS stat, specifically via
nr_tried stat.  Have you considered using that?

I'm holding reviewing detail before this high level discussion is done.


Thanks,
SJ

[...]

