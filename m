Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1C71C624DB
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 08:20:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5B0E6B008C; Sat,  5 Sep 2026 04:20:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0BEC6B0092; Sat,  5 Sep 2026 04:20:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A21706B0095; Sat,  5 Sep 2026 04:20:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 876B26B008C
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 04:20:34 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8BC23A027A
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 08:20:32 +0000 (UTC)
X-FDA: 85179011904.28.164E8D2
Received: from mta1.migadu.com (out-185.mta1.migadu.com [95.215.58.185])
	by imf31.hostedemail.com (Postfix) with ESMTP id 7EF4620006
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 08:20:30 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eRFP6sxP;
	spf=pass (imf31.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.185 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788596430;
	b=Y1264tdVLYzkPDwDHQ1QYRkoGV+zNkjawfCaGQtbNpamkjxPuLKcQNUWAFl348BV9XKnRh
	FS1ye+jrp0W7MSFJi2a5pm+hVlaWPS8pBdZvRhn5rPfzcEg9soKlGov9RQ5ULKGrwS6tzA
	EyhjBLqkQrS3kOkQ7gbJqUFO13c/iAw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788596430;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RP0mewtQAGjElsgzWQyDMeAFMgZ/vTm011baf6TDx3M=;
	b=i8gFXruYR6R7A2EjZwe34lni24nWd0C09MunrpOkzXzf1iL0y7uMapu1JnPpm2uMeABSwp
	n0shrmfhroecWbCAFAafHEQqjI6oC2Lbz72hM7iVrzxDpQVdFIQ2tHv5v+/4b7BVcoGlxM
	Cq9mBgargfXhNRf64GUha8iKFDop5tc=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eRFP6sxP;
	spf=pass (imf31.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.185 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=cWv2OsYaUjRAleYfGIeSk6xvjxd4wSnUJO1edGPXAD0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788596425; v=1; x=1789201225;
 b=eRFP6sxPPLpgbhV8dG1hNPvNGTIDyVLscWBweIU4MY7TGr3rVByYSjJWzQeElZJ1A5cnKEMU
 MljvWnEG9iOiWFchjz+NG5QTvPXVZE+AfB5a2svRHALYRiFB9Zp4ejIFcDYAta9+yIwPEo+cHq/
 Ru3OeDg7EL+S8tgGIfpfeqUw=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 1b4d3cf39591adcd;
	Sat, 05 Sep 2026 08:20:25 +0000
X-Mizu-Trace-ID: 1b4d3cf39591adcd
X-Migadu-Flow: FLOW_OUT
Message-ID: <1143901c-5036-4b79-8135-21ce57075136@linux.dev>
Date: Sat, 5 Sep 2026 16:20:16 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/11] mm/sparse-vmemmap: set section order for device DAX
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Jonathan Corbet <corbet@lwn.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-doc@vger.kernel.org,
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <chleroy@kernel.org>, Randy Dunlap <rdunlap@infradead.org>
References: <20260831075342.57563-1-songmuchun@bytedance.com>
 <20260831075342.57563-6-songmuchun@bytedance.com>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260831075342.57563-6-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7EF4620006
X-Stat-Signature: es5eue5b4asxrqhu5wfojmdydjz744yn
X-HE-Tag: 1788596430-837117
X-HE-Meta: U2FsdGVkX1/mytKNFWnhozTLSH8/tXnr9RJUJuzor/06md96rLi8TBK3PBlvZOO65j3LOCNpsS5quaLaf0LbQfur/e+h8yxVx5XDNCclwEHwCTWkyuH3P1IigqHgx85aHa8mUNz157IqxeY+GQTwtRr7TJmy1gdgbygB/mMqg9yGfJ43h8hPKcdZw4RWpldpTeUhZ3myaTCIV3biSUuyZ7L5Ag9aEVR8G/TOJfmHhNDEvOAnMBAuDEiHCD0ppswfbaQLcNfp4DtxQStc+sYqqk4xZ5PpQgJwfwKgY6lZd1pRvyAM651S3pdQFNm2yzgGs5aVU9CihunWzPCGO8zayGP+gcs+9nLfOD0uF5ZvgONLFFRwCh4Dq3Y06MI7Xzk6686a6QDGA9TEi77pP0KqMN3gGyh6xlDplT+9h5X2sCAQMUs7t2bG48HlID7hPd/UuY9HD5bhXW2oEvdFdgFYFz9muOuLuGbXSv6cTM9LvtLlslL4SMbmrWkYH7NHUZsKb5xYx4hZSPoKrJd+kGPFee75oNNWhdDnsayBOcUC5iQpvmr5bzlPbilXPnETxy8s3g1iUXewD7YlWglPw7tsmRq9ZQiDWUS9MMtGd2UB0y/A0JwBd4GvQ2doTEw4ESWeY4/zFwqI9hQsSI2mQohua+a0aQln0CTIb/nzVk/LYdQ2sfnDDmLqJnucBc1EfmifeFJW+Ys/YNKT3nS+c9E6kFUKYG6rWbW8OXe8AcB20390xS67qz11/PeWhInxyIRbDFzkrrgzTvVpAGYdrZezXtJoReOGZB16IW0a6KSSOTJRKa8t46cO9oGpCTFeFm7E7XCATHI3vqaGujlnam6dUvJNlNH5PFslix+ep5Bm5A57h24tgkBiADZ18PIm4u0IUdGQSL2xuy4JFjPaalkvVTFIHue+uQlKADes/GJHyX6EADCsLaQH4kY1Y9Lw9RiZ6CWBeOXSp6VJ5c+0c8N
 frKy3c5U
 Ab51pNmX1w3OnWJYEsvxc2LzZHq5Zin3FEmkuqgy/3NiwEp87IirAFfqw84zEIP6zXf8tMa4EhJRIYvP1HMvq1xXaDjsS0KW1N0NU/wPrms93fbu/27N26YTUBAyqQvEtO1p5Dw0s1FQ1f9m9Y9U76ToiUyzMVe0gaWXUdrQAhQc16K5GhdSjziSYb+B8OJy0Gt73wnf0jkoTSjcjZQauXLOufJJ8zC7qbtn+f707QAlJLJeNmAY3S156E+FYRCW3lSJe65QP7TW9TWfbz4Es+tLR5tMAEcd8GOI0YZNeQDyuZUU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Muchun,

On 8/31/26 3:53 PM, Muchun Song wrote:
> Device DAX can use vmemmap optimization only when a full section is
> populated with a compound-page geometry. Record that geometry in the
> section order before populating the section, so later vmemmap accounting
> and population decisions can use the section state directly.
> 
> Clear the section order when the section becomes empty again. Also reject
> partial additions to a section that already has optimized vmemmap mappings,
> because a section cannot safely mix optimized and ordinary vmemmap layouts.

Perhaps we should explain why they cannot be safely mixed.

> 
> Partial additions continue to use ordinary vmemmap population, so they do
> not save vmemmap memory. Such additions are uncommon, and the lost saving
> is negligible.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
>   mm/mm_init.c        | 13 ++++---------
>   mm/sparse-vmemmap.c | 16 ++++++++++++----
>   2 files changed, 16 insertions(+), 13 deletions(-)
> 

Also, the issue sashiko reported looks like it was pre-existing, not
introduced by this patch. So:

Acked-by: Qi Zheng <qi.zheng@linux.dev>

Thanks,
Qi


