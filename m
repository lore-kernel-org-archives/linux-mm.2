Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A93ACCD183
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 00:31:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BA488E0037; Thu,  9 Oct 2025 20:31:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98CFF8E0002; Thu,  9 Oct 2025 20:31:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C8088E0037; Thu,  9 Oct 2025 20:31:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7C8208E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 20:31:49 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E2BA91A0117
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 00:31:48 +0000 (UTC)
X-FDA: 83980326696.14.16BE515
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1815F2000D
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 00:31:46 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=S2eQDno7;
	spf=pass (imf03.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760056307;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=COasMxXbWmot2wCffZuh9uIQ26pwWVgYk3t1yThZc98=;
	b=5SZRlRdkRxp6YDzX37akpmBF+FdHswMgAJWzeyFenqR1C7Zzadtsz0B34UE2ZKdQXsZUpg
	QGeiS1fJXdORU4b+bqagAwW6vsXVG8WEZp6HZsZKK3Oth4lzZJ3CTo2poouQePipItxrzL
	f63je6fNpmgdfuSQFGo68ZczqNXnRqE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=S2eQDno7;
	spf=pass (imf03.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760056307; a=rsa-sha256;
	cv=none;
	b=qCVZXerP1ttt0jauakxQynJyuPi1k98Dq0d3ceEDjyXJ29aQv2uOnxg+uZXH7dLpmWLcg0
	Gkg7m/mRZZvTzIq+roU7p58DCoMcvISv5wS8ZCt+QBPNgOdf0UmXZ66DmdnUHxmc54ih1e
	1/jMn2sCkuGJEZYsXE4UN6UYXA88tL8=
Date: Thu, 9 Oct 2025 17:31:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760056303;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=COasMxXbWmot2wCffZuh9uIQ26pwWVgYk3t1yThZc98=;
	b=S2eQDno76eTArUZfcQ2wbw6L8HWA9gvcez0w3/XygcjzYbmQfmoI79GIBR2MpII72YuGw6
	NntkcfDJ4LnqXWnuqFasZl+1BMpwhm7vQkoBi+2sBOtv/h4DRLMUbFupVGsOGS3iXCT14K
	YwxUK24370qM7mip7NG2Tt2N4B/+pbQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Usama Arif <usamaarif642@gmail.com>
Cc: muchun.song@linux.dev, osalvador@suse.de, david@redhat.com, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, hannes@cmpxchg.org, riel@surriel.com, 
	kas@kernel.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 1/2] mm/hugetlb: create hstate_is_gigantic_no_runtime
 helper
Message-ID: <zo3ieot5a3n2qw3kv5iuzkrt4g3kbrkzrwtdlcshxk2n2ubbqc@yl7dqssisnfy>
References: <20251009172433.4158118-1-usamaarif642@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251009172433.4158118-1-usamaarif642@gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 8wph3x1oqf53gddqq87qfo6zjma5n8ts
X-Rspamd-Queue-Id: 1815F2000D
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760056306-505627
X-HE-Meta: U2FsdGVkX18SxT91jJ5ywVn5t5EdSW6T4CUXLE8UqWHdDDPY0azz7n4SKtYvG45ebdMYbU7mPD+KlXHPTYvfaxMG9eJzn2HHsFYilBgrqgVu60bjIYSM0PuPE7IOFlm/DqybpplNleLzwvYtRsSzzAyf8GCqsJIdl0v5Ps8Ag2oF4R5Zgtsv6BUOJ6MXMKx64X400yujAETZR5f9iUv0IJrgVIZ1XrdXkZ/GeX1sTeWvIhafYHYfUxDR1TBgiJSPA0yJVKKXgQfC+qiEpAkObqLGQpju98BeuooGn3ybqwfqw+ipfyw4xXdBIZMGp+3c33Mp/3d46igJLb7JjHwVVro3jwvsPQPlQtwhkaNb+LBCb654A6K4sLO4Q1Z8XFmXoZLFxxwW/a9JZGhx6Z0jlpRDZSDAstfbARbzl0U0V+FCYrKrsOEm7RTrNGjodq8iIhe6cU5aW/RfHyEBz2/xR71rKcSCYpw4I1LF+ItOoUrYMAI1gbIDYbvnlJxRKG6WdxrFWLZMLKGPcrTNap4gQxZwVo9IV1YMp0Z1ABUShXlYID9sntqBmGE3EkBd2J5yvJYBDAgGVeRAdhYZAMX0Ubc1rpYEmpHiUIcdKkxqp50IqcfGUa0ffvsi1VV+HFnhAnhxZVHo/Syw6LHkDFpfosHOfV4sPN3v+tEJ1gz8SZBw2wa53BklR66GoelVZu7RPT4ua4KyuKSslGWK5BNxMwgs2QOic5k5Ssdm1wj74QwGXpYxVjwUDp0bzdUKjJPB2+csRuNR0+p8w6pHKJXzwSnLErXtaAcjMrTpvWbBPI0SDIodBMV8XWfeURXji7xuo1xB8Rsu8LXbM0dyc+bVb9TiB6gBcGPcyn9bnhnvn2oqPEKgIfKtvhEDRBakOp5j3JhzU9y9OqwVUMwVBefFAr0VwqOLPaLdxpXdRlCMyeNBBpiE8ulBFVLMEunLkyNbI0zOGx7q/yRqAtGDuNy
 O/KFKJN5
 QQ9wSvOqHT9lIqYr+4oIOCfirMKTEYynHW/kfBfSRsvCSfGiftDLgcTIE5096hJnjkENX8OzCSaa5ciPlg1rOWcATMBm3AW3lSa2FN+5WZu0xbEjUwBxkG1VZAs92PLZ77A93hkGP0mE0s1QPjcfZUmtMfeOnIyVkwkySs/Qtl23wwg/+pPWTiSKdV8OERg7PshX6ROxKAIi5g4dVKNKJaM+bJScSkmVtzIIVE50KdIcIhjPcT052JmRgaNurTFQ5fYfkcwmvlCDOm9tummfswez1Htsy54a/y6q1kFW1DhO5NqiISQez7ux0brZJaQv+WLMCr3agk2YmQ2osq2TjfAUeWeKB2EjDjYxB5v0OIXijgjjPDi1HuwIsXQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 09, 2025 at 06:24:30PM +0100, Usama Arif wrote:
> This is a common condition used to skip operations that cannot
> be performed on gigantic pages when runtime support is disabled.
> This helper is introduced as the condition will exist even more
> when allowing "overcommit" of gigantic hugepages.
> No functional change intended with this patch.
> 
> Suggested-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Usama Arif <usamaarif642@gmail.com>

Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>

