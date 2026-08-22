Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7A1AC5B572
	for <linux-mm@archiver.kernel.org>; Sat, 22 Aug 2026 03:23:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 572D96B0095; Fri, 21 Aug 2026 23:23:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 522F96B009B; Fri, 21 Aug 2026 23:23:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 411E86B009D; Fri, 21 Aug 2026 23:23:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 175126B0095
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 23:23:56 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8B0081A02E3
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 03:23:55 +0000 (UTC)
X-FDA: 85127461230.19.13387A1
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	by imf11.hostedemail.com (Postfix) with ESMTP id BD26340003
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 03:23:53 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=R8Y56LT6;
	spf=pass (imf11.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787369033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j6UTc4WIdbDdRVopL640XLd67bSkxARSxTgQAdAaqQU=;
	b=RhC39BkdIE+JM6uiIHa75oXvAgpz/iPfLbLxR0UYd8SyQr/vW+fp5sTFKcTMhdWhLnuGbj
	1o2Nch/DEgqYmtBrsrFZUSi2ZXSnGSqjJLf6n62bQpS2NJrq6OisrwMMyJ2OSbmzjQtZrF
	QcsSMxQWVib/VQ83XoOM3l5IiS//ceY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787369033;
	b=l2+E1CJrE0UoaOIwXERQVeBlC9J2jegcC5BZ42VcRKiwprFDkskEOScYacdl4KV7uNM44m
	hji80ZPcRTdgzNR6TqFjiYtih061kZqfvx4nTzgIjwbxRqHCQ8nV+xI5t4wRvkaXV3hBF+
	8g5i8oLpbPIXV5f1cV/MWYZl/1lJ9sU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=R8Y56LT6;
	spf=pass (imf11.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-cbedf433a99so1612226a12.2
        for <linux-mm@kvack.org>; Fri, 21 Aug 2026 20:23:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787369032; x=1787973832; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=j6UTc4WIdbDdRVopL640XLd67bSkxARSxTgQAdAaqQU=;
        b=R8Y56LT6vB6qqoV6zlQaWDL8CBXdDvMAtc02NoxEdhvckoqrE1m6uCb9+G5N9Ufjbb
         jd1OmvZ0Qj8mq0TjslybrWzkIYOygjrxHXs2bVXgJEqbYu2R1ES19iCZ6qF6YebNlbYJ
         w0b+j0D7W6c7QW3/aE3i92yQYVn4LLZg7ZX7BnvZBLgatHExiFR6VR91HjSRTqPaJc7d
         PJSFguj9BvdTuKNL7Z7+xvx+OOo/7wiEGPw7f5nD4kANb/+RmnITcmhBr/NnzP0p1a1m
         YGCmq5NapRJOTUXg7VcYpR+c4JngXrl47IrSQbXQI/Maaikx3+/cdRGqPq+zCKBnzBWP
         w2IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787369032; x=1787973832;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=j6UTc4WIdbDdRVopL640XLd67bSkxARSxTgQAdAaqQU=;
        b=WW4w9TIs/PIThwKws9vlgYDOpQEi1ZgX6raciPOCLR+zPh6eG6sEkMClj/uqE3Z7Yu
         a8vDE7s9voYrbLYC0MeTUNVkyALgxXMJ4/+VDijfxw/fVXkFSof5Y7XekBxDtv15Gb0j
         diW0mZm+6alkBrfocXiaWNGuKGYKr+Kvp1mk8xOJpmGVL3rZQN/0EUKogyBqbE8fNnEs
         9MEuJzQnRRXjhuieKRsR0hq/TQGfx5OA4X6SLsJcJcFIbq+LpY4UtHmWa+3N4jF8UcvL
         J21yLFjx/9iyR93RWZ+34WuHEpA91O9n0Grn3HdWg1qCqKFPtDckGFUQsaOeCJlHFtMf
         ZRww==
X-Forwarded-Encrypted: i=1; AHgh+RqfVFLMrA30BI4tUQg84gsDv81ndxhnr/trQEqArES6gX04fJAB0/l3XA6ViqiQVz3BfkmiTGmm5Q==@kvack.org
X-Gm-Message-State: AFuF++m4CuXTyyBql9/9BPLpb1OT8q7U87IcKEJ2a2LdS17tcdRfjq6h
	LCKFyNxaLTZTiuCP4qnNzXqeLeqghJreZb+1DWk3lBL5Pufv5a0GqUMOEuwK8w==
X-Gm-Gg: AR+sD12S0oG5iPI/dxMR0UwUs6bgI2AIYgi8CcqTyojlcAzD5Cela9+GoRyJj/Aygon
	h7/nw6WcIlQeIRuYAaaCxO7DjnfsDasuGvxjry0iHLWLTZGW2iDzvLkHs1XkuGhqd2ETyXT0ynf
	IJ27SwtRc3HqfYYdBr3UJj3rdHEPYfNtUAvilCZhKnyPRpOD8p1MhQFK8DQdgDYdVihTLqsfGPp
	KCnLx0icmuXHoOqh+6rrwCNQyz2loO6wPXLqiCaEZTG3nw1GHIJ2qpfTqcr/Xf3+GJwcJ2V7pmK
	1ggJio5CUKJE8pOAYMoPmCtAwM2X/gcdiebO5hvS8Q4CESJZL9/Ll/dG0Obb8iCf8giwQ/YfhEB
	CQHQB4mWl5eeUNIqL8MrCxdqniGh+3b2uO8I1eQbbmZot5wAGXz+cJN+Il8DDEO+qkloyD6vfC+
	IjqmSefQSwLMZEuuLIITA0bIpnEdzpfalpZqcEarvxwRG7gwm/NQ8cYBw=
X-Received: by 2002:a17:90b:50c3:b0:395:5eec:b932 with SMTP id 98e67ed59e1d1-395c39e6433mr21359062a91.11.1787369032388;
        Fri, 21 Aug 2026 20:23:52 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-395e49b4060sm1152671a91.6.2026.08.21.20.23.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2026 20:23:51 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: Hongfu Li <hongfu.li@linux.dev>
Cc: Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexander Graf <graf@amazon.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Hongfu Li <lihongfu@kylinos.cn>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/memblock: simplify reserve_mem_init error handling
Date: Sat, 22 Aug 2026 12:23:23 +0900
Message-ID: <20260822032327.3548986-1-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260821033230.55210-1-hongfu.li@linux.dev>
References: <20260821033230.55210-1-hongfu.li@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: ig39hpuruis11ir186xgojpce6x1jjmg
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BD26340003
X-HE-Tag: 1787369033-364738
X-HE-Meta: U2FsdGVkX1/e8xVPMiPh0l/b9kNqGmFqUmZNCx4Nmr1Q7fRutnsrblwKZ2pLESGZBJiBWpRUTwxL30DQ46QJXRtPtN1r5qEv9YXsUSgIDdCus0OVo28PHAAdya74yhM5xNnwlxe/BmuJPZv1LNo/0vLxXnrKOGm6sldxhZ9eVNgQcMabGg1xFZh7qUsMkGjTRa7yrPyS+rrQtBGh23EvAIXFiMmO05vcG5VvGCxaJoxoZUnBaGPn5zvYONszdXs5nlbYNW0Va6oex3HH/5kvvAchnbbai+7/W910RrWkbv0pjcXrHNIYqe18nfV26uNKxln5Hlrl3T9ayNzPfcq+kLL5eNGIU/aDhMmQmnOc1+IwdiIK2J8AiiI/8GCrnCAdFyjfsi8WG44+AHJEf5Boo1JfNb7VKWqdL0zUpT3C9lLFYkXOT5tJtCfxAAgmjNeRQgSqC/8gjZ/+3YKka1/OF26AY24AkJxY8IpvIhg+/7qVt7z/A5K4Qiil0zTbZ0SgM719sx4nYgklI3Kx9qXofcjJFFXmvBxsEM3/jT/AVVQQBnHjKDY+f6gSaH2v2gYwuI6jq5Ub8SOoCZ+QnIrX/27Z8Xbg4rvITeiFmQh2M1g9dhanMVkX+cjhXDsou2TvueCHXQG0qn3bRt7T2piw2fe9aLrVmNIJRD75WBWPuAWyJun8B3c1IDztqRh1XIinCs9T2IBMIrOgdAX74hZtgEUQxAnHR3rDXO2KKAmL4ngcX2iDBP/4YRKJcWirBOi5/C/7zUW3gcoWNwIbmgS0RmTo7gWwa3f2bWJTqDXal/mEvBF1gce3B5mHRXolPH5JvhuufjG78aKT/MRZ5nDVE2xqnbO28d6mnx3m2QMlW3KtmvVlgw9XdbJX5DqYS1DZEyi7AlUtviWhSTer7mAD2ccAZ2cDd0E0s2yic/90orDRtz3vSfpc0kw/j6QA8BeyxS0z60eidQfyADpk9/n
 3rImWF/U
 kZRcdUIgly5JJu6vgQoVR/rWxZihNgfSIstxCc9X9d7QJJKEtggO2bWEvxVdQQIYRb2u2yPZFwJ7Egz/faye9yqnI/S3R2Z2qtEpwHTpw+D+Ema4r+pFOQIc7ETz7DPfZAoBbrh56CGJterVbTRYJOXxwd4FsqagBhGihHGRKN5a99Ka33v0hxXtIvQ2UF7qgMZZ5qQzD4cAOv21c5oX93d+QV29TRTUJ1fUKd/QiKwjAkzJVGsVLJyzTpMF7x8+5NRDD/3xe9SK9rgaZ7Gy6te5ZjxxBciBX88ZdkrwfThzShfpiNYuAFK02wdhHaCNfYIRJVfA4+Xe+bbTL8cqVSo1+Vx7coaN1noQUacbYjG34rJYVrq7i2qIHw98qTzwjG2/o3e1anlTvstebQxmrrUeXmuREHMpPesUNKouQbjMVMYPvINqpP6VsEZ5lBjiGq2kM8bHSPq+p8GncuysxqrkdUp6gel94X+BjF/Ieu4Sk91I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 21, 2026 at 11:32:30AM +0800, Hongfu Li wrote:
> Return prepare_kho_fdt() directly instead of assigning to a local and
> returning it on both success and failure paths.

Thanks for the patch, but the same change was already posted [1].
As mentioned in the cover letter, I can send it as a separate patch
if needed.

[1] https://lore.kernel.org/all/20260723184538.3888637-37-ekffu200098@gmail.com/

Best Regards,
Sang-Heon Jeon

