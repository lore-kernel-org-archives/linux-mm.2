Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3D30FF60DC
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 07:43:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C8A76B008C; Tue, 31 Mar 2026 03:43:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A04C6B0098; Tue, 31 Mar 2026 03:43:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DD7C6B0099; Tue, 31 Mar 2026 03:43:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3EAE26B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 03:43:59 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D1238BD205
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 07:43:58 +0000 (UTC)
X-FDA: 84605569356.09.35323D5
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id 21E6DC0003
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 07:43:56 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=MT4Uyn0w;
	spf=pass (imf22.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.172 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774943037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/HPNsO0wO1Iku537jEWkDij///y2pRJHFFd2ZBoCiuU=;
	b=HPPB3FJMO3qJuGkEjxFxfF20s+qWgt60Q0L30H1AMxuBYTp609kikK/9q8Ne/cx/7QKADT
	oQB4wIue0510/XEtkIREu4BIuC1ZdAFNjDyCyu/waiweydeugpfm/K2uaM2CA5o19YfUZX
	NyXntgwwFOovBJBiduv/xSeKjiNHh3c=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=MT4Uyn0w;
	spf=pass (imf22.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.172 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774943037; a=rsa-sha256;
	cv=none;
	b=WDABL4X1P7aBCT3RxAn1Jx4LZboR1HDcVF88tc/MYoYZvMuuKAkT1N4rDvOVtzmUCzsOYM
	iORpMzV3dANsdy4uXlLwV0HqNp5LS89bGQhaKzRaQgXm14r27n0GKt1vj3x1zoshACWgCO
	UVstxHa+DWPnhR3WAfpr5k6Y0wh/Kbc=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2ad9516a653so23434545ad.0
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 00:43:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1774943036; x=1775547836; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/HPNsO0wO1Iku537jEWkDij///y2pRJHFFd2ZBoCiuU=;
        b=MT4Uyn0wuuULtWds26+fHod7zLlG/5f4qYKOPMYbEpJyctCHW2jn3JkelYafccgqMP
         Yzlk8S/LjYFC00uzQZ4lGx/6Wxc89fcbEv6vjik2cdgKwJNB4uVpiPVaN74Sv7Jz8WMQ
         Z0QtM5vac8l1j5G42tXcY8T0J3SCgQ5ElP/4U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774943036; x=1775547836;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/HPNsO0wO1Iku537jEWkDij///y2pRJHFFd2ZBoCiuU=;
        b=SHdSqGsRfSWOk+kbkSibR5jBRs50l6I+aIa0qVQPJXafuAeB8mCDw4BSFSaRjAOhd0
         pzL069Yp8GODivMov2752zs1wSD+4nmn9a3Oi78iJLPDefqeE/cEE390SrHU2hXS7zaS
         ZyrBPp8RMP8skFpwQlvMXxOzzbOswLf7/qzl82yEOwM596m/EIqxFEFTtEbPVJ728eq7
         8oy8IVDaxGMyf9w62ZA3NRpQaiSWM0jBnGZpuQdboZxZvnwmEtxJ5om5mc3JG/ayTQFR
         FXJyeHrnhdRQ29UrUBOi6BRU5UZX3z1EVp9WTmktLIQLou6ybVQTUvztYV8Kva7aLI/r
         BdPg==
X-Forwarded-Encrypted: i=1; AJvYcCVoO3j43qKlvHUyTCalZ6LkiX1JAVwwwT6va7VI42JReLuxm8NxdAXEYgO1DzH07/eEKNWtIco4wg==@kvack.org
X-Gm-Message-State: AOJu0Yx2IEwwNggI5pENlPnzfNSvdJtbrok0TiyTI6phCd0Ud7KrPuDg
	PHB/946jXlK91cMuo10hKnX7/0zwdDG1lAybXkXqsxNbdUWcWQRBcBDZhSxCMsPCow==
X-Gm-Gg: ATEYQzwCdnkNHENvgxCo2BqkMbmcHosViShWrWg87jPUtcJUcUxDmK+G6EQw86vMx9M
	vohg/4zQu/LaSzLPU8NCPOQA074hH6feAboAJKUTAF1dsuT2R0rSbL1iNx0x4qFhL5aZAaJAU7P
	bSkQV9wLEBANJ6AQ4d0vn4lE6uQ310JfeyyOvYyS5YEkjUlZ6I766Qz68IPyOfZDTe9giungHl0
	E3McKHtVgGGWiBIiZ0vFl9m64stQ2JA6Dof2VF1cmm1UV/dHV8fI6FgyvdB7uBex4goVrmrw0D3
	k90QItU87t79/CPnQZLy6sEY3dKZKJ8Mt/ba4sRKfrW4GHzZLxdljJpRUE6YCVM8DdadeoHLAIJ
	+mNk2suGu/JtXNbcKplG7py9JIvpXhe3NTSIq7/VS0YJnG9l/wp+pKYEE3ez1oqfn6lstGzS97D
	nDVMQsylQz5KebG6IaRUgjQEtR3aYf0OOf6R3EPt7jT7cRR04WaAy7owZTzp9sryg=
X-Received: by 2002:a17:902:cf10:b0:2b0:42fa:72eb with SMTP id d9443c01a7336-2b0cdd40321mr154096605ad.47.1774943036058;
        Tue, 31 Mar 2026 00:43:56 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:90ef:61f3:1679:56f5])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b242795195sm106127485ad.61.2026.03.31.00.43.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2026 00:43:55 -0700 (PDT)
Date: Tue, 31 Mar 2026 16:43:50 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Qu Wenruo <wqu@suse.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Minchan Kim <minchan@kernel.org>, 
	Brian Geffon <bgeffon@google.com>, linux-block@vger.kernel.org, linux-mm@kvack.org, 
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2] zram: do not forget to endio for partial discard
 requests
Message-ID: <act7DBWOwe42i38Z@google.com>
References: <20260331073737.774503-1-senozhatsky@chromium.org>
 <c2a593e1-cbde-46bb-a32a-c9db38c62801@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c2a593e1-cbde-46bb-a32a-c9db38c62801@suse.com>
X-Rspam-User: 
X-Stat-Signature: c8o47a45tcw7fmscctu1am3n1qqg8ksh
X-Rspamd-Queue-Id: 21E6DC0003
X-Rspamd-Server: rspam09
X-HE-Tag: 1774943036-487947
X-HE-Meta: U2FsdGVkX1+AVLUPF9vtOrewD9ZT1J9Cv/8cGeo3WZsR5vWH7ksZq5omKAMWz6oOIUm1JNeez/j8Mf6e8sB6v3P3HlRoBGem0+PzBq4OpTW4hVnzZ8zroU/36NEXeITPKiKjPjQLKo8t5+ZFzMdCBhSKMSo+geCsF9CHEccKa2BktL1j1D8eOOHZcrwTmCXpDogZ3aheDtc4vESn40a8z918bL5/IBrGB23fejiPNP2JjwSDEh+gl0Z8021OKnmPj5bOb0oORhQQmaRq/GjaNdf7JbELKInPz3vUibUPLN6zqElkJ6mD1IHiqf/nu1ZVDuiZmbCTFWTUZz1meNiGYE0G+DkH6XBJBoPKD5tUC6RnJZZfwDGfn2A2W3aUrIsIy9za9H/YIhTrAAlxrb3UEhGwqtOzvddsoprtQoEAv/bZm7GgQk6vrejfzfe/wuGjBwccZadkAhsI9RdfMJU1PvxjsNMm47puX1YWX553it7RpjZpEc7DTXn0lNajQs7zjZzTI6nWTCqjlocEVEiYpryenk5iqHKon0w65Fd+QtbT9fI1I8NXwxHpGqz/WIOnw3ynbyBRPyE4zCunraG49xW7cnQtAx3whTaomP+LOsvs6E0C0ibVqhctA+nOzi7aczfmB8LoheXHUolZ1sh0ZZJvUB9x6mJeCrFVFStlEZmb8u0TVp5Fr6AqlTk1+wGHGOru9wlrekvu32zktb34eaj6tsKTzfXVJ+BTm8zXp1WvwiJZDBNr4RzrbG4zSrW7Dh+8CuGesOyHsYbgO9cigSehe+nD+dWLpPAwC+tj7/7Zh6whqYNjNnwLDyhMqh3tSZVYk+r2m05aF5QgxQ5nc1zxuMOlRl2F0IO0U2ehYgbRPI7BHGkGrmuGqOqUmvAFvT8D7EKql+jD9NCoofdshwH9MxWseDfrZ/lmGcWI5h+KOTBwYE4JjINk175JdxmhzWL23b0mGVs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/03/31 18:10), Qu Wenruo wrote:
> And forgot to mention, I'm just a messenger who also did the triage.
> 
> The original reporter is Avinesh Kumar <avinesh.kumar@suse.com>, who noticed
> a test failure from LTP runs.

Cc-ed Avinesh on the v3.

