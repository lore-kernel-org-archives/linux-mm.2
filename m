Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BDA4C624DB
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 23:49:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 385E96B00AC; Sat,  5 Sep 2026 19:49:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35E0D6B00B5; Sat,  5 Sep 2026 19:49:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29AE46B00B6; Sat,  5 Sep 2026 19:49:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 021AE6B00AC
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 19:49:51 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E559C80426
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 23:49:49 +0000 (UTC)
X-FDA: 85181353698.08.4F4EBA8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2C56C20002
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 23:49:48 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=W4Q8SsX0;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788652188;
	b=mR0SSxcC7vCPCMf3Ne+/guHaujyDX/pUDTiTM1ZzJ1ZBYKkpigTnV8rhrNor7lmq7blLiB
	jfwyf8Z/tyj8A5oUPbdsth/i2FOoPLpbiEwmH1RFfkTisr6hzIRDmkx/GtgtNNe6sxPbu2
	1KBT0hx+qNEeDGQpe/+AJw3TSDqnwt4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=W4Q8SsX0;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788652188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p14q8RLb24PxaMUYcK7wccluqPq4Jq34o6+JYyS8wt0=;
	b=wVlrp52SwOpIGoq5TBqC4mrFqkPXKaI/y56kXriNJyvKBUMRuoLzSoTz/kblqe56Y4oqjF
	SF/DS905pwxAX620FPU88hrup/Fx6puwLDvNhhtArmkHp7l/KUkGAKYZOieWHawekwz29g
	yI6JtF+NKLSPVClyrBDMQj/xHOPO3R8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A315360AB1;
	Sat,  5 Sep 2026 23:49:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0744E1F00A3A;
	Sat,  5 Sep 2026 23:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788652187;
	bh=p14q8RLb24PxaMUYcK7wccluqPq4Jq34o6+JYyS8wt0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=W4Q8SsX0rX3ZIF72rGvSAwiSKnpfIGVQQvms336X/+gNpc4Mp7DVvMswijn/SoNTW
	 g8TmYkJzVCGpYbORmVgzL9oCzgB+fKi0WXJigxzSF+8rIcPXYcvcixX2TvW3yfI1IT
	 mixVVFWqFWGf7wp8It8g5Q2fKu1lijAYbSbgESgI=
Date: Sat, 5 Sep 2026 16:49:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Stevens <stevensd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, Lorenzo
 Stoakes <ljs@kernel.org>, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v2] memcg: Don't call schedule_work when no spinning is
 allowed
Message-Id: <20260905164946.ff22c7cf24445057dadc89a6@linux-foundation.org>
In-Reply-To: <20260904173145.2028377-1-stevensd@google.com>
References: <20260904173145.2028377-1-stevensd@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: wz6hkebd9w7d8zhyuryd4ah5atz347dh
X-Rspamd-Queue-Id: 2C56C20002
X-Rspamd-Server: rspam06
X-HE-Tag: 1788652188-866443
X-HE-Meta: U2FsdGVkX19emK4MxPH8i07SKNHKYjazF58uC8fLL4EKB92iWr8HAyTqVQBtR+FMUt4Tpr4CvQFXE+HwcEYoRGO5rOFgCSGrKA/8HP0l/8yePyZzEUEuM0RoSxZc2RG6kJBlrC3rE9yMHWbO7F5oq6U/fsYyk0SbYk2WQlINtBPB96bTQcLowvycijdYlJC5o4saE2pr4QOSq95apxMNi18XuZbnwGE9m6Xf95ZEHTqwjvWRbKA5VKWt2ZZdz5jS139h0K1nNciyrN8HpSTBG5nqVexgsA8ORZ9fb0gC9Fe1dRhf5nt5SfrG5Y8d6L2FldAP1ADu96gTjGc8s5E9285ZTriQW1vp+ytztjMVXON1l+iJtzwl945m3wt+VIK2To3OCV8IXRW0r6tNDbA3kKsKtG4xZM0cDwM5NYwiyTp29ovqPwb/eEPyG5ceKRM06yRTDptSUWflNyNz3W/ewvG+8d5WD0w8tiRjOx33RP72ubAih9SYYqLQoTYE0wq8wlpmpnMUGHQTQmsrDQ+TdsLJjBI9DIpOCvhwTaqQdjXz/eNsOQQdGsX8wiP+zZANhK9Ox++yG7gRhYctqdhPxOQGjUL1GbjEdNUycd+GlYkdqQIqgcWNr+KUweDOKDSfF+DI5y9dNLaEpZcGC+VPzXVcO6p04X4ZxlvqURTKPLcMV+gB4lv5cjYGBvITxvyzQ/KnMUHWKi/tEYadqni9xsVFe4Gs4jkHJpLl5lHD67wDdxw4PzWd+ES+Pvk6UtbegfeJTo2BVl3LDulXbCCsIpM01ugkW68nu4N8n9MRN3ku2JldNROXX4/pbxl+xfjroxlffrSyZag21BfG1vOslkMr9Y6oqLW4ehNbco+ZCZPqiTXJGrP4sDjyBLPLKKz/Lob5fbaENYY04sMCEiJLswq5Q6bYjgoO7fzJHD0ZiLAp+rGYTmw4K1G+xYWAPSJ7IgVAmBRXHvB5O4OWPly
 NgqvlwVW
 Ymgse9uzxHfVIEk4m7r//AO1DYCQzHtjxZiLrMHRnVu4GeMAvUd0dAmsg6AVDNmfkZCTK8Rb1sOMO5crJz6wkxw378s5FtTxOjzAGOpmrT+yILfx3wN6R4L9blaMrdywpcIv/9x1D3jHSkzOI8u4RH8ARG1xY0vMc+1UmqKpplLgfMSUwUOYOhNJHSBvQjQFFhxlwWfqaAwLvreD2g8eLeUPQrAsXT2BzS+o8F8njsENj5GqvBF7jkyZcJRTfXwQrmv+Pdn6x7N2enjHw+MEJI+XqGJHTm+2DxDgP08ecUm+/53IR4IIid7HQqYm35ElPT6JK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  4 Sep 2026 10:31:45 -0700 David Stevens <stevensd@google.com> wrote:

> Memcg charging can be done from any context, but calling schedule_work()
> isn't safe from an NMI. If memory.high is breached from a context where
> spinning isn't allowed, use irq_work to schedule the reclaim work.
> 
> Fixes: 3ac4638a734a ("memcg: make memcg_rstat_updated nmi safe")

Thanks.

To fill in the desirable statement of user impact, I pasted this from
the v1 thread:

: Found this via code inspection.  I spent a little bit trying to trigger it
: for real, but the only way I managed was by writing a hacky driver absuing
: alloc_pages_nolock().



