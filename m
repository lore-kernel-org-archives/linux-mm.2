Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBA541093170
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 03:39:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02F676B0095; Thu, 19 Mar 2026 23:39:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F229E6B009D; Thu, 19 Mar 2026 23:39:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E37836B009F; Thu, 19 Mar 2026 23:39:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D54F56B0095
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 23:39:49 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 268861DC90
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 03:39:49 +0000 (UTC)
X-FDA: 84565037298.08.CCAFD3C
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4543840009
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 03:39:47 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=l0G8ngy0;
	spf=pass (imf07.hostedemail.com: domain of bingjiao@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=bingjiao@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773977987;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P/YXk8VBR+UZp/m/PSuTOoFARBhxT4ayCpwB7zK7i+8=;
	b=aNW9yhOvvWyBSmCEnSRETd5VBlRdKzdtUNzyK0QMXVblkOvMS5qXFxVMbc264nvqvFrCf1
	zRjgcamBjU22VlKYyEm92VPWiLJQvS4fLmnPr0fLwAmmucb3ugJGfCEZYk/VXHKngp0bc3
	DzFaM95nF9upiKnMEs5TUm3zUt0NwAU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=l0G8ngy0;
	spf=pass (imf07.hostedemail.com: domain of bingjiao@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=bingjiao@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773977987; a=rsa-sha256;
	cv=none;
	b=LnYmY7Vmzn24M2GAwcnwnEPVwHCUA/FegMdUErTYJV1HvUVoTgJnno/lmCu2H4ky/iXYGh
	NFZ2W7lOPlF9VkgeodWE8lVu89EuLAMclve7LE6QUlfqpbXBdtXeZUFmuzaqGSOXzecNbi
	f//BhlRfkkl7SYCROQY5itp2+gXqvR0=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2b04c9e3eb7so47435ad.0
        for <linux-mm@kvack.org>; Thu, 19 Mar 2026 20:39:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773977986; x=1774582786; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=P/YXk8VBR+UZp/m/PSuTOoFARBhxT4ayCpwB7zK7i+8=;
        b=l0G8ngy0Smqt/9IsfMDKkmct29oYsVqiMns+4GZ0YznwCCZZ+EPLs8IRe5bXFh9QXF
         M54n/RxJRC1SAblEvsTbVRRAztbbDhRsnLEsrcrFKNaspTzud8+7rdaUoRQIHkiD6t9W
         9Z6H4k3hZsWQjemadJcW8S1K9ByzcxO7JJmA5K7TgsGvDCvkboojP2WaiXM0ijFESC7J
         aAnDvkFJWQb4WnBQolGWdvssGmHfeV1CsCaQ2J+J0NqsHQsB+Aa3jAG1McNTIbkh9OBk
         9FaQTnAQVaSAuHRaHl2DGEGmdocCKBSLXZBkVo6DZDaW2bjaCYn9E3kg3VvhUu8YuAgs
         VtZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773977986; x=1774582786;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P/YXk8VBR+UZp/m/PSuTOoFARBhxT4ayCpwB7zK7i+8=;
        b=IFUFpIFLG50ZiDI2J4UmTfiw+QFaz6kAdpRVbTzBJiqGraSwyU1VWmxofqpuOkiyJy
         qkMIbRXlPMYI//tpMeKhxwenF4nAiqBAfjpPWztFib+yEGPc7VXmGTilheL5HqmIYwJB
         WoeTYklJhFe+XEid41huEMjFUbcP1Hpu8ioDk5Jwwg1w0OYEqIQxy2AdVDTKUQyDwZUC
         z6fpgCSMA7QqlkqEF1cZonMbZayGODS1rnx5Q+2AZ1W4NdVxhXtwkKL9Zdy5u41f8YyU
         8hkJPCmDQDW1vmhivwPKlpq71PODDh2lZx1yLsAtWbllWTcOIwcWUkZ+cz+erQvMNmng
         eltw==
X-Forwarded-Encrypted: i=1; AJvYcCX2Oja+eYm7oi5SUExUHxV9K5V4514Ui8li/WCje9sYoA6BxHdGvHxOIPkrkgLwUGJQ/OKEo+Iiag==@kvack.org
X-Gm-Message-State: AOJu0YxbhNElw9SBmCarQnCSiulpjXuh0mAu+fefcriuwGE4hNcxOeTu
	j+2/fbZ8nh9zT5Qkp6dTgBAYBeCUeSFRBSG6AG60yrNdUkPpyS+/Ulg4XvWtqLV3Fw==
X-Gm-Gg: ATEYQzy/CTgkFYI4Es3j+i2Tkg612b5TU0shoI1vNPxbEa4bZVJaq0+nuInTwjq9hFJ
	LYjK/pXCHEmV4WxEUvva4jsHAM4J6UuaW9XhJgw68dFdyrYIczq2+0vjCJNcqnkTkGUeLmdZi1P
	o0ADg5NKaRwFGtEqYsYfk2w44mY1YqdEqJ2CJFArbsCb4IUeaWjV2IqoR+yOYVPMqnh09OtBspE
	f9Im+w8lX4zWmBjrT9KNXwDwaaZAkWqLpcznX964Zbdl90rLqvmwujix4tUGzVMsU8JOh1xjMfv
	xNUvA3K9N66KOCBPMpjeUvxo+SRmZbR1Cq4tLMKk0UC5/+sESfmSWHhsnr44JDTZliRHBJsp5zO
	KUme/MACGAo2MotscXQmUDXF1QjtVJxtWPGadc8f6ig90yuomLQqiKOQ5uwBKId7saaq0Fjk9Pb
	liRVWDOqgnK3jntJgJWkAqccoJsDY1fJUAg3ZqALetgnSPmp2ipalnjbCkFhHoYvvTwjy+m+MnC
	D0P
X-Received: by 2002:a17:902:f652:b0:297:f2a0:e564 with SMTP id d9443c01a7336-2b0836e92e2mr1101815ad.11.1773977985452;
        Thu, 19 Mar 2026 20:39:45 -0700 (PDT)
Received: from google.com (206.238.125.34.bc.googleusercontent.com. [34.125.238.206])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35bd412b73bsm502858a91.15.2026.03.19.20.39.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2026 20:39:44 -0700 (PDT)
Date: Fri, 20 Mar 2026 03:39:40 +0000
From: Bing Jiao <bingjiao@google.com>
To: Michal Hocko <mhocko@suse.com>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, baohua@kernel.org,
	bhe@redhat.com, cgroups@vger.kernel.org, chrisl@kernel.org,
	david@kernel.org, hannes@cmpxchg.org, joshua.hahnjy@gmail.com,
	kasong@tencent.com, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, ljs@kernel.org, muchun.song@linux.dev,
	nphamcs@gmail.com, rientjes@google.com, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, shikemeng@huaweicloud.com,
	weixugc@google.com, yosry@kernel.org, youngjun.park@lge.com,
	yuanchu@google.com, zhengqi.arch@bytedance.com
Subject: Re: [PATCH v3] mm/memcontrol: fix reclaim_options leak in
 try_charge_memcg()
Message-ID: <abzBfHzRndwjrGQY@google.com>
References: <20260318215629.2849052-1-bingjiao@google.com>
 <20260318221957.2979346-1-bingjiao@google.com>
 <abvB65BYCUDT9JF1@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abvB65BYCUDT9JF1@tiehlicka>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4543840009
X-Stat-Signature: cmby5es6jqns3aw7h3i4gzmuqam7se54
X-Rspam-User: 
X-HE-Tag: 1773977987-840434
X-HE-Meta: U2FsdGVkX188itkwnLtxGwg82NlRG+K8P6CsOu/RFNxBh9+FQAubBR6tEt9+WBcxAGJUledTRiqwONPifcHj6y4zx0kmeyJSHgWkERGDGlP5+lC5ZFbeoYqOKudg1Awan4dCN/MUr8XqRkCDvOzJvhZO6to2ihpfR3wqk7hac9NA3L6TuIKTGtN64DAmANqPdtTl+JTd7RGGrfqt9+4W1ytGlLp8qbuEIpxRPWmUU8lyC6V3OJs03hdA0F7uDTGfzd4hUK8gpmIHbC5BgzsnXYMB/buru0axvmj3ALRPJoiaXWu7QhVn1ThQQkEX2dBiiTmXvU8aEEHcTavKsWq7usWR7DgN7QX/qsOqUsfYilA2IEwq/i/PicgePfdhrCQA/waTR2Agk/H6IQeXssHx5R4Wib1tlr8kLntwt+XQoqhoFOsQeXyDITmC4DhVRymj6X+ah4gU4B5GLlk3G9e4Nx9czfcLwBTFXKjXVo22mKftWsGymnLILi0is2X1KESaUTKu/oUjqveyuiDJrisVM7n+1jCF9se7/c1FLicK2Zc/Cr4658zT0aB6K0jKO+MCsDEvX76mTnrFql3pN9thKpb42nQ3A7xjIC4mUNjAvn2I2VTEbvGU6FTzAy46GsQ4VUo7eW72OtuKu+Gn9ywKe+z+U+dec79+ajfV4TmL1oXt2cRUaJL5e/3tDPAPidICX9sn2pr23mUGuiPOJ/CFqtZkK2hy+k725WJv2uPUMjWPcn7VQH3l55BKJYyb7gIDgYCF2arcDT6P7SFe78XAD3VhJDwacKc+4mWgtUcEHwHNdViUa18q7+n+QADt08AhLAOMrzDBZechuTaMgEAi6MMXhIGwHVhjXACBuQsICbaaY9rz6nkpClhpMn19AmJZGl38OZ87LSWCdngUpStSCdqFJzwLdLo4gcH6X6/MgbQ3P79xCMqEUffHkSBinSg6jix9cdUolJxkTwbas6A
 NgQfPjYI
 9aI2Bbtbv3ZHn5xrYStX3YkdwymHx2Pt1TSndqMiuYKtwJscGl8Bm59BIvcVCMHekMr+YxrgJPHxRMQpIqwlUfZ542q5GOhq8rjFAiSEaXC+/k8z+vse7nYGU4UK2Mm5tnNY+fm/QwsOWq7Murr9HLKHNJPEEVPjIlJGmvHb7K+7nO2VlmeA4S8KCNjoFUIESkUVlOPZWbNpHsd7RmtPboaPZRFrG/86nmgp0cEf+L657y+yw2c4Wtf7lbCJVjomUadC8f113B3g5xrLv7oiei4D5vgSG2BV2Thlr5aBrFS8hJuV0tyrMYMFX4sYPeeHkinT7sxx3Y6bwGKyxaoNMM3iT888WTcdhoXyctMUdYKvXIUAbAm/cgwW3Zp9o6IR82wTc0k4xUjHE8ir/tMfkJrY/m5mYU5GJVeQcin9nxWqmf6d6otnmSZOQDZafevh5Fz3DrpB8Wg1BplpBLQJTTsWUHQ648wfWQFkx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 10:29:15AM +0100, Michal Hocko wrote:
> On Wed 18-03-26 22:19:46, Bing Jiao wrote:
> > In try_charge_memcg(), the 'reclaim_options' variable is initialized
> > once at the start of the function. However, the function contains a
> > retry loop. If reclaim_options were modified during an iteration
> > (e.g., by encountering a memsw limit), the modified state would
> > persist into subsequent retries.
> >
> > This leads to incorrect reclaim behavior. Specifically,
> > MEMCG_RECLAIM_MAY_SWAP is cleared when the combined memcg->memsw limit
> > is reached. After reclaimation attemps, a subsequent retry may
> > successfully charge memcg->memsw but fail on the memcg->memory charge.
> > In this case, swapping should be permitted, but the carried-over state
> > prevents it.
>
> Have you noticed this happening in practice or is this based on the code
> reading?

Hi, Michal, thanks for the ack.

This issue was identified during code reading, when I was analyzing
the memsw limit behavior in try_charge_memcg(); specifically how
retries are handled when demotion is disabled (the demotion patch
itself was dropped).

Best,
Bing

