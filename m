Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8B53CD4F47
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 17:42:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D894D6B0005; Sun, 17 May 2026 13:42:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3A3C6B0088; Sun, 17 May 2026 13:42:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C50486B008C; Sun, 17 May 2026 13:42:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B27BD6B0005
	for <linux-mm@kvack.org>; Sun, 17 May 2026 13:42:44 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7BFBC160E39
	for <linux-mm@kvack.org>; Sun, 17 May 2026 17:42:44 +0000 (UTC)
X-FDA: 84777631848.26.36D457C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id E7F0020007
	for <linux-mm@kvack.org>; Sun, 17 May 2026 17:42:42 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KkaJhxGY;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779039763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=91Sdm5vMO8CD2BIlnghBNxIwZL3qlYOBoem7YIXuUqI=;
	b=C3gUDKjpvyQTmmTI+/kz8KTAGWjubVb+o8NeXFvbg5qAgakBnEYXf/KAUmC9q7G2NjQiwn
	T5Lyn9Q5XYd9pjXW4YxsI8xXos9qWaFdXnP4mjf4j+CxHu7TWiW7umb3ngJOBgPme0+vvy
	xz0wTkRkzuQznQY+lODPrlzwXFJBvOM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779039763; a=rsa-sha256;
	cv=none;
	b=7rkBi8JqybKGYzXphCQWXH3GKWeczaqb72RqP6QILMz5uouT8369BkUac6V1un7OBxl3En
	Yai6luvO/HYdyktSoXjqQ1FOho+/VuwF5zyimMV+sTse6xO8bw1Rbzvaxr5fJRb3EH3jJL
	SAHa+KLIUFRsfLUuSReb4K/yKA7TAqw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KkaJhxGY;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4CAFF60125;
	Sun, 17 May 2026 17:42:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DACFC2BCB0;
	Sun, 17 May 2026 17:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779039762;
	bh=mIIt+rPrya9rA0KovBDgwi0sHwBa4TedHEoMg1kEOwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KkaJhxGYX7lgZ9F9mKGUyhfhH7wkdWbaD0WNwKVI1tx6HVzkLhKss6TJSc8gFRxzA
	 pB40KUWixstWeCK1cjYCyYvDOzTPzBAp/oaoU7/GP2499OW9W3dGaTXR6nSVSAlKUt
	 Qp6JbD1ge0AX2m3ZTwRGfzS567WKH+j2gxlheV3priVgBwI8HH5k7vYLwRxpVdtj5M
	 cUo2mJVsjMzK1jgKQkpaO9jy9kt029Re1ns/B0LzQUUPUt5RIs39y0j+8K5FlJyT11
	 ttZTh1VsqGnsCOSFM9hmaHLURZRg2SFcsE1uAXDtmsVTmfa4MZHdejBGKzI8+LJMvr
	 hxtr/YrWi7d3A==
From: SeongJae Park <sj@kernel.org>
To: Sakurai Shun <ssh1326@icloud.com>
Cc: SeongJae Park <sj@kernel.org>,
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
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 RESEND] design: fix typos in design.rst
Date: Sun, 17 May 2026 10:42:32 -0700
Message-ID: <20260517174233.1595-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260517073433.3015-1-ssh1326@icloud.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E7F0020007
X-Rspam-User: 
X-Stat-Signature: jpzu7b3rhbrgo61ic57bk5wjsyo464t9
X-HE-Tag: 1779039762-898942
X-HE-Meta: U2FsdGVkX1/rsbyeZnCJlXfSNMwM2+18IYU8Aq2/s2or03BvD1JWHIc8CHmLfMKXgJbenxun/RybBvuzmdq2hOxvLqf0arqs9VlWIvNdp3zZsQUEz8XID9+kwl2ORYeooMq5N749/9l9nJ/LBmMZjUPXLjdR9jpOc1teeYyvsiUJu6zlLKXlsRyKoQEek5mPNrPOdZQZ9C/pLM2OfvxLaT1/hOWly0P4iaEN06WOFx3CTljn/+7d5pLpbOTI5e2GBjTi6I769hq3sSabuwCQ1sl3dy60I9QjiRYoZ6k/lpWH+bz2xyS/5EvMVrdzynR7a5HQjncFygk3CJzi63lCgdchRZDGbgwK4J48wvsGcdMxoOpbrRjpKkeP3r/hxbN4BXcaPbxyPD5Rd3Zk9d0J13dxXddp64OMISN2K6i5KB/vpCPn4rMrJeQZMGbzC4XlWR0vqgUzxcVi29BBAfBqE4wqFyPc0RduuQsS87S/0EjZSqXvj30V3KEYuoAkSfrshkYTFFQuK7xWXEm2M0avXTfi2tFMfucZp0vGf665bve5QDDCjrsTFKasVFfNwuNcwFidSV5Z+NLL64gG8VyNARIn83/vgo/ODKNbTfLp09oh6EjjhYJafYdL8ct99P0c+05jTccC8kWC8uUVDIIc6k78lzMFD3dIlCYs/qct+F2Hy9I6EQ/ERsTKBiRQSE7abKFnwDanFzCb8amgJL4jg3TxTD0wLZlt6+K7B49G4jdLe1WnCf8g21VJCdUDE5mzzyJaSn+3Fuh9aC1/cnN1nTfPh1iy68rz5TG9t0w1MfekXhZ3LWOeURz4PUHIY3tqommT6Nkg7BCuVnBq7IPHI5dU91a/sIspSTsRYQcaZPPtlJxRxK7xov0m/sXlw/aLjIUFFlpZgN2B5Dq2pM1JQn0LSEEmt+qmbFlXO2lxCjUpa+e4GLijIa6tVixt9p+xNIrgQUHw5U5JwtfvuLR
 nhDf5ER7
 1EmMuH4+C+xyMOWiGbnt4v3gnisdq+STfXCs+Dl/TRqRmI0GFiRHYQWdtLCmITX/FS/dG/Xv07Htmmm28E6atATp+nQsBmz6wXiizrv99OvxcTRXeTSfOAtchwaVB7eL7BxuMJ4ji2nu+v2VeI7LawXNiUvc7HwDwA59/iUw0QOvG1UsA5HSV0ZTNgF7H+DasrZUSVv6PHlpdfcstK8ELMg3PhcoLhV73dBkpgIBZk/4nWeeN/WEAs5FvAXPnbvmNKcXwlPl9LLgXWXgyuknwcHf/NQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Sakurai,


Thank you for sending v2 of this patch!

As I commented [1] to the previous version, let's use 'Docs/mm/damon/design:'
as the prefix of the subject, e.g., "Docs/mm/damon/design: fix three typos"

On Sun, 17 May 2026 16:34:26 +0900 Sakurai Shun <ssh1326@icloud.com> wrote:

> L140: "unsinged" -> "unsigned"
> L371: "sampleing" -> "sampling"
> L387: "multipled" -> "multiplied"
> 
> Signed-off-by: Sakurai Shun <ssh1326@icloud.com>

Assuming the subject prefix suggestion is accepted,

Reviewed-by: SeongJae Park <sj@kernel.org>

If you willing to, please send v3 with the change.  But please do so after
giving time (say, one day?) for others to further comment.

Unless you object to the subject prefix change suggestion, Andrew might pick
this after making the subject line change on his own.  I will also pick this
with my subject line change suggestion on my tree (damon/next), and repost it
for mm.git inclusion if it seems Andrew will not do so.

So, assuming you are ok with my subject line change suggestion, no more work
from your side is needed (unless you willing to do some).  Thank you for your
contribution, Sakurai :)

> ---

Also, from the next time, please add patch changelog here [2].


[1] https://lore.kernel.org/20260516170847.146524-1-sj@kernel.org
[2] https://docs.kernel.org/process/submitting-patches.html#commentary


Thanks,
SJ

[...]

