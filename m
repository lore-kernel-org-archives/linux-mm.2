Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C340C55822
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 20:39:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 109C96B0098; Tue,  4 Aug 2026 16:39:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BA296B009B; Tue,  4 Aug 2026 16:39:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC4A66B009D; Tue,  4 Aug 2026 16:39:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C7A966B0098
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 16:39:21 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 41BE6160274
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 20:39:21 +0000 (UTC)
X-FDA: 85064752122.05.81940A2
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf18.hostedemail.com (Postfix) with ESMTP id 56B0B1C0008
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 20:39:19 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=f3nv4YMD;
	spf=pass (imf18.hostedemail.com: domain of nico.pache@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=nico.pache@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785875959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QYfrqWB9UcNJ91M0SwCiE6Sf0hX+9MVTc3GmUaItWRg=;
	b=dtR+EG36ELX3JOIauKHhIgUXPK8plhuCtm6g1mcff5lcY+Ajld8CEEoDIc8e4QGHhc7rZG
	yTCaKpW3XFS7EeuFDsmpotEpuDX/VFqMNE7eNaTIYu+0tddHehG/YMNJ9CJzg3tDMlMA5u
	qVizfYi7ERe0+EkS2xT6+Dk6aHu+8g0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785875959;
	b=k5wJ9dMj2xNLmz+TqltWNu0W6S8Nmp61QumJjXIzGvT3C36leL0iOW9UF17+54inAimqaV
	9B1a6Kx0cOm/IcO5gRBm6AT99RjHoWCH6plapuBEL4ge0YTZV8PNha6dr9NnQ7a2PmY0vq
	IJsDYayGeQVsbH8GX/X5mL0CfpVynus=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=f3nv4YMD;
	spf=pass (imf18.hostedemail.com: domain of nico.pache@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=nico.pache@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785875957;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QYfrqWB9UcNJ91M0SwCiE6Sf0hX+9MVTc3GmUaItWRg=;
	b=f3nv4YMD5FA5QABWgLFS+PKTyVX29P0oqAU8AV5fC9d8Ru4z6oozCgqqJ853dAebWIwd+B
	hZg29qwWYnhMfkyVc/+e2pl07n5f384yDcjMK2MOKsKd7Z27IcJTO8ugK9F9fsuwmsTkcG
	vE4RTKKXNg8eaMZROu9xi/PPWCHtaxM=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 1/4] selftests: mm: extend the check_huge() to
 support mTHP check
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Nico Pache (Red Hat)" <nico.pache@linux.dev>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
 ziy@nvidia.com, liam@infradead.org, nico.pache@linux.dev, dev.jain@arm.com, 
 ryan.roberts@arm.com, baohua@kernel.org, lance.yang@linux.dev, 
 usama.arif@linux.dev, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <f2ad5bbe868dc7ed8642842ad2f9751a1ce79f70.1785564857.git.baolin.wang@linux.alibaba.com>
References: <cover.1785564857.git.baolin.wang@linux.alibaba.com>
 <f2ad5bbe868dc7ed8642842ad2f9751a1ce79f70.1785564857.git.baolin.wang@linux.alibaba.com>
Date: Tue, 04 Aug 2026 14:38:43 -0600
Message-Id: <178587592371.79283.9552373204791612099.b4-review@b4>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 56B0B1C0008
X-Rspam-User: 
X-Stat-Signature: zmp1xi1fhsrkup8wpimrgoqpynx8ksfn
X-HE-Tag: 1785875959-730764
X-HE-Meta: U2FsdGVkX1+FTbaUCzn473Gy4v1ytjmmlA304ZcmSS+Wk7JVdOIDk5Keiv+Ma79lXOkHAVZFUaUWh6TPp+jhk8oUWp0rUHKmpl+oY88n69G+T2nKIzPn6DREFWjobTXiT6jUuObUBIGgc51i+9KovRQ9xmS8h5qbj/gslN4kxVHwQx0wRg/J67y9VpP3B8PqEi6gC8YJYELqITbw6V7Dl1/RJNIMcCD8L0roUJfkedFejaLoabe6p8646I9ON6tgywUpCvfMAfqdoZ4gaZ2yekZQIYPY0Y3fxRIlaTkocOvvILHZWQXa6tXmgEkytk2BM5RkJ43nau/dx2g4DLXot+jyMuKM8sjuLT0IyxgBbjjVG7oMqX85KN6RigrqGi3T4qLKk5Vz7SO1ega9qfeoI7PIpEyTin/JGNneBTCVRfL2tX8c2ZIYV2oIQ8ZKvSN3pCgImkEdo2tEUbzyWKDdBHvUKPptVh20XUdry9Z9E/JyF/MATzqBn4PkP7Ezv3vW1M4BCElVErZ0nV66K22NEadNSDUrEN+UNqeSAqA9n2p5II//9x9Ef/EVil1Xkxt4Ekg5vHKbpXLeerjSRvGq5d2gFpsNLHUzGfzGmjqgMOcAFOcWMivOaLOoY/+0IYOb9Q6gaolZc2kp4KESgiwoZQ/5stMBcPtxFONASllxZTNoUjHy/QXqbPXmtRaYlfrhbQ/OCxolDBnl6tKkgy5yTwteAe2Hx+XcAUbTmg56fn++G3wbRnxL6HhCEhoiNgwvO21koldzCO5pBxzwBESUqwKiC08PnG9pHj1IGuvn1cxZ3hgW9nOaDw7B9lUYaPxFK85QxJH1qdaz8JFouzVbDgTZoSr9oP/JDoXqETuNiivh34oMiojAvxMJKEgSLL2htoHn4LGQgvO/SyibMSGxKTyDRqJqNSwGuXjDOjnXpNZ7zjp5+eKRPogb/nc+xL96iGjD9EKevkeMeFvbSvr
 7CcIITlC
 jKJKgNZ8fywyUViQZD9fyleHjcrdNZV8gaMzCVAFK2iIh3MbFS2oDxOmtfKuF36hhlW96HZcwKtfbkjyBQ9uQcoaH6ZpQCRNowmnK+Zjoq3sXnSJ25SfJ1SG6Yp09zCY2WNww7HeOISOMsd9x7CTa+u7eV3Dw9K4/D2HxI5MtxFwtcpzL4l7d6MJdZf4qC6qbx7JGvsql5F1gkII3NxN4Q5q8Ia/LQeWT+E5TMWF+vTwkJbxYxRkRbk4Nj9yjkLjn3iO/QiVONZYC82/GyiRCcjLxP3K/GP+18VrGji0Z1IwVgp1E4Q6mMKJ0JQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> To support checking for various sized mTHPs during mTHP collapse, extend the
> check_huge() function prototype to accept two new parameters specifying the
> address range and mTHP size, in preparation for the following patches.
> 
> No functional changes.
> 
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>

LGTM!

Reviewed-by: Nico Pache (Red Hat) <nico.pache@linux.dev>

-- 
Nico Pache (Red Hat) <nico.pache@linux.dev>

