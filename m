Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7729E668A7
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 02:27:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17B056B0088; Fri, 19 Dec 2025 21:27:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 129D96B0089; Fri, 19 Dec 2025 21:27:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05F816B008A; Fri, 19 Dec 2025 21:27:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E91E96B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 21:27:22 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6E16B578B5
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 02:27:22 +0000 (UTC)
X-FDA: 84238262724.03.0C14875
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id C69F51C001F
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 02:27:20 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IrzcM2KH;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766197640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4rnguelEWNv5Ih9Q+7qnijz+O5cEepx0qnMtVSvKvTs=;
	b=Z/Rs6gUc+I63eoSC3+P6IoPODyxdWEwiSXw+d6hjlvI4RuM31L26Jonv6r25BIER+0LUvJ
	16XMCqCa9piYTX3rk9c7kkXGmqegywkVZEhQ2Oc/KIakIuCGUQzAyoOSN0Fl0VCb13mf2M
	IRXMkZPRUZUxlapgK9vVfOvS38jZ4WE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IrzcM2KH;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766197640; a=rsa-sha256;
	cv=none;
	b=6Kl7ELz+kFXVVKgRATWBPDsonueyBLjrQe8cKuMQqv4FOIo816nA44Bz5gTMD/yJRTZViw
	on0yU9AuRoghQGWrwa+1aUQ7OkJDcFRtcjW/7tNYbtOTr88Dfd8zYyjQCAmEjtRebo1frY
	U3feuzG/KWg0nMwYeK3ZXGm0MNI8MAs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7CBF34369E;
	Sat, 20 Dec 2025 02:27:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DC3AC4CEF1;
	Sat, 20 Dec 2025 02:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766197639;
	bh=kGYQ9sQGrJmw5xhgJhfVYrla+fi7LRDyqUXhc3HHRsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IrzcM2KHyj9Ju3CskhhsAw9To0uKSjYi1wjZTdGK9wS5K5i1JFdoAfsbyDZfu259L
	 5P1AGCF00hz2rsinf9lLKaDHrPtZuek89gOBbMBcvmV3F1uI94K3IHJk4uIU/N6QOi
	 yNc0BQjVKga2QlkWSDAkwFzly5RW40FpmNyQUtTM8P/WfhJSpGzx4DXIm+aocNDui+
	 y7gxjucEHDDk158bvgz79j/FcPWSzNaCeM/Idqns6UZqriQpBIqXrhs3HFqhEPW29X
	 TInFuPI8SMu2Kcna9sgVhLl/mDysocQ0AyhWaOuF2QA1TrQf0zPMXnJVtqym9GyOAL
	 zr+H0pSVqezHA==
From: SeongJae Park <sj@kernel.org>
To: klourencodev@gmail.com
Cc: SeongJae Park <sj@kernel.org>,
	linux-mm@kvack.org,
	akpm@linux-foundation.org,
	david@kernel.org
Subject: Re: [PATCH] mm: fix minor spelling mistakes in comments
Date: Fri, 19 Dec 2025 18:27:11 -0800
Message-ID: <20251220022712.43244-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251218150906.25042-1-klourencodev@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C69F51C001F
X-Stat-Signature: 9f5ppo1orfie5383e85t9z3mked79go4
X-HE-Tag: 1766197640-469330
X-HE-Meta: U2FsdGVkX19l06THhyYc8nxNBd+oYXx2I4DxNW74TXbkYDXYGpQ+G06RDD9i6t+LwLpS6h3xEwfUsWKJqEFS/cllq28dKx8MtUUgfVUbIlYZdDqvAk4hysYv29CS23kuybu8s89Mg13wa+xLhnNvjh2ayRO29CBn/8tTU7/lrzHmz2n1v1Z1p6SPxL9dXN7b0KHzHzf9EVQObDkUXnGMcRNTXGNFt+C2Pv5LCEagmZC2TwD15vQ9+xN4cu+NBcaHScwtQmR3AnSUM1+AiEC9jvnuNciGmj/oKPhiW1VoZAtLRPa6pEngztU7xFXmnK0VDjcGEXzRx+c+geKOEkWDVCnim5t/TovfEWnX8ANN9h7Dlh+3/jZPL/soCRxrd4BXOwh4+0aoYFcxBDsmqE6J737hiXn88BuUGngG5hp7cJJ/kyUSuZnpP2Q4bKxyUJJXwxJto28X9Hru2P27xki0JeRjE/CgtbcQZSKnfFbI5Di69jd0R3Q9SNqmKcrOFZBm+5CxRAMxXkfMjavMEg8ZghNtFy06YJVz8TR/gsWhUymJmkQFniIWeJwMEPquKLw11ofABZfuulO938msIjK2BWmOH9XAi5vo6ovysOeTW/iWnhZ2E+7oBeRmVwSd77332fa6Hvv4OYVLdbUXSIuuG49KPsoIMjW8jmqzA20NWydFzNyHiNgQa8wTHRo07YSt4So88SrgiNMGEye2X6MRH7mJobJnsN/2Osg6EWrtkLZAvnz6jIxhnCYTGXcUFYpxjn4r2PBIGZnW46mYgvj6+AhymayQvZDIZcV0lFI0H+gfC/hap1v+7bAQLlcJXeP5uFZzJN/lb88+U8zFJtYWw4v2BItsWaqwcKGVCsQwOhlPj3jbsFZz6a7qwa06Bte7fW4leaecT7YALfA5aab/PnMUx4Wf12InMhN+Um/KuDmei0aC/ywlB7+ZhS+Xf7rFAUtmSWpP5TOuc4nQZ/O
 WR8Gjcsx
 sgWR1O2yXhAQUSm0lREzm+gIlXdM/pBU2mXgMGSVt1awtO9VUSXxfJ4RyhvO/mUBXU8QlwELUORv0ZdJdD4Sq8VvlTLgH1dn0IgW0/EpSWYEOYnR5ABWtTt+qXa2CpwwxL2DjwMX5HknIN0SClVPGybeJDklClAaY5FTFw/RhZL1yMNTh+nvxAz/tozJoQBIMAC76VdjokWnpbFQAWktaTq060mhhvM5frbc1uOhA4AWwwfeU0wtLfmnAQNlkrAdIouz1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 18 Dec 2025 16:09:06 +0100 klourencodev@gmail.com wrote:

> From: Kevin Lourenco <klourencodev@gmail.com>
> 
> Correct several typos in comments across files in mm/
> 
> Signed-off-by: Kevin Lourenco <klourencodev@gmail.com>
> ---
[...]
> diff --git a/mm/vma.c b/mm/vma.c
> index fc90befd162f..bf62ac1c52ad 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -2909,8 +2909,8 @@ unsigned long unmapped_area(struct vm_unmapped_area_info *info)
>  	/*
>  	 * Adjust for the gap first so it doesn't interfere with the
>  	 * later alignment. The first step is the minimum needed to
> -	 * fulill the start gap, the next steps is the minimum to align
> -	 * that. It is the minimum needed to fulill both.
> +	 * fulfill the start gap, the next steps is the minimum to align
> +	 * that. It is the minimum needed to fulfill both.

Nit.  s/next steps is/next steps are/ ?

I'm not sure if that is really grammartically correct.  I'm just asking.  Even
if I'm correct, I wouldn't argue you have to fix it right now.  So please feel
free to ignore my comment.

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

