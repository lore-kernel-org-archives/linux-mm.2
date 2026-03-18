Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BCDD1077612
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 20:13:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7900F6B030F; Wed, 18 Mar 2026 16:13:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 741006B0310; Wed, 18 Mar 2026 16:13:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6566F6B0311; Wed, 18 Mar 2026 16:13:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 53EC26B030F
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 16:13:09 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 000F0B6391
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 20:13:08 +0000 (UTC)
X-FDA: 84560282856.16.CF7B859
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0C57E18000C
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 20:13:06 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BfTCnSMq;
	spf=pass (imf16.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773864787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8S68DA/9ME5Lv59GmMoHWUV46BnyFgsIWC59IN4av2k=;
	b=V0dQo98XBx+h+DsCPWHRRn4CNWNKv8dvKMWH29YIEvIyNOsEcLJY9h+fvOXOETUEkvdqCS
	rgnNREX4Z3cJMr0TAQ8Tu6/YlKrBEvXlKO20NgduylGJeToa8ZeZtHu9wRYU+1DCXteKsj
	0GIV70mGjNb3xVDmFN6rjQvRiIq1p/4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BfTCnSMq;
	spf=pass (imf16.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773864787; a=rsa-sha256;
	cv=none;
	b=m2fovnuujmaQJ7rQsrQ7Pp35gnYyunCVV5LR6SaiozkL7cSwwZ4Kji59saka1hg8PZPfIQ
	flLPlHE37EWSHc7zGAvdVSLfR6Lv7PtFKHFnV/HClbXEZiha8KyMzJ3nuo1+6tMiYehw2A
	17uIkevveXed3P+RKgXwBtjMsKCl/Hg=
Date: Wed, 18 Mar 2026 13:12:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773864784;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8S68DA/9ME5Lv59GmMoHWUV46BnyFgsIWC59IN4av2k=;
	b=BfTCnSMqJYyl4URiq5AlrUuWV/Z0vub4mgczj/BcqbocIUs2nytukQZMA/lejIMPfjwDTF
	GGv8kiQsCohZhRGkdCkKOFTFNiL31rSqDWWXSkAOKalq7KLpLHSI1klibeZd71D9QX9j3u
	bN3b3HZ14/I8SWIIKL8Rh8LR0rUJzNg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, Zi Yan <ziy@nvidia.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Dave Chinner <david@fromorbit.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/7] mm: list_lru: lock_list_lru_of_memcg() cannot
 return NULL if !skip_empty
Message-ID: <absHLnVKCSUO_noT@linux.dev>
References: <20260318200352.1039011-1-hannes@cmpxchg.org>
 <20260318200352.1039011-2-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260318200352.1039011-2-hannes@cmpxchg.org>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 79a56ngr1jfg9sopyxrwz8qyu1tqe78z
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 0C57E18000C
X-HE-Tag: 1773864786-705323
X-HE-Meta: U2FsdGVkX18ID44wwxPSeOaolAAWqiTBS80EtdCugllwCzqIMVbuIcEXc2hYCCZQ7WjSJi/GV506DMoewEMnJCuUCdGm0ooZy78LQDF+Pu78ZJyHA41AJG265/XB5cbcV4iupqwvCSPNt3bGzFq1Hb35o+pKoJRPMcX1VLryqHP7+IluGTHJYu5aK+9U/Kxha9MwvjIFMzKcdOznRfgxXk5trcJpzZDtlhNblxEVEEfPjU4dLzQ5QiNHW2PnHdqFXVWZM1fY1ymFQbvywozP8nTwUtB0B2NCWwcKEuAdpworUb3EQWuF4HgpRZgkWjyR9xPuJWVptFMyfhhtwVE9NJUyDY5uSHZi/cVzdtOoH3ZrLWwbtnfs1V+UI/NsW3NtXEWbzsKx7Ui2rd24Rw+nqDUHT3ZlV712/9L7NPhmXeggJkO5jJG/J3zC9f7yXgFtNMwzbomZ5tBfkOB88DiBFwAfxbyFhoAyOX/b2Ry39i4Hd2haKZTRy3ZZw2KMaCmN57jGTvXeW7OI9GlyvG7qR+DKcEht/OifsxRrTvVxzd0lxEUhX5e9/kQZFUmF67GQgxzfKJeFCZu6xUs2ri/XcmzPsd+NcEjGM5Ig6hwUeEjnPMDt+VF7WW/0SzacUN9i75zpDG8GP6RM2vElmMBSp5pF36KbXI+Ms0odeHkh7jnrHvKolCg9aBqOYWegoHb1dMbSnGE/b1q/QDnc3mZl9BlnLZAXqT04OMWoT7nGVD+o95Pr0yCSprjC4FkV+j2y0sBkTVCCS+44Z0qJbA2JFuLTMAsY4Z/WDLQO3UeuvdbiVPzN1whGye+PJYNOx7PHLFfRNZCelS518/16zwgLS0bRTViOIDRWEDyEuspEPG3iw7cy7mcqjnimVW/efy4UXXWw1Ghk+B+lk4ufAEonyRhReIriaFB2SXhm8wmFJSbEj6F1oylCwq8T5rykccbzTR0owsBqECWcjuf8hOL
 UY+D2GHP
 3lW8qx1Ehddzbu/JhlnSWOccZfl0+t4w1itI9lEpWJyMjwuk4v38szb+WAg+W3LWwY/6EKG9KxJUELxK77613UPpWeOrQgPdWoUshYp3AxcfyABw/agsmIdX+h58Jra/VPH7WqyRNAhLKmkxpBAu52Qz3JbOcKjnhNaGRZ260365opl1eYCNWKCttNx95/X3zr1E5MWaz4m0MT5cLdBLPpP+YMX4njFpazh5lL3BbeAWMpq3PIUKLSHA3pb0jCGV6JYcATtroM6zNrRMBoVP5o7gjF4ZmsbYMg0DzJViLPAzrwNcHn2kdUJJvgTdvY0+8I29xZb840c5qF4JohJ6UstozrIziBUnYh82jLeayxBDxyMJR6sNhHeTBQG+bgY8mCf5L
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 18, 2026 at 03:53:19PM -0400, Johannes Weiner wrote:
> skip_empty is only for the shrinker to abort and skip a list that's
> empty or whose cgroup is being deleted.
> 
> For list additions and deletions, the cgroup hierarchy is walked
> upwards until a valid list_lru head is found, or it will fall back to
> the node list. Acquiring the lock won't fail. Remove the NULL checks
> in those callers.
> 
> Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

