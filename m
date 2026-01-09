Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99B17D232E3
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 06:13:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 079EA6B0088; Fri,  9 Jan 2026 01:13:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05BB56B0089; Fri,  9 Jan 2026 01:13:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9FEA6B008A; Fri,  9 Jan 2026 01:13:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D767D6B0088
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 01:13:58 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7C642B8920
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 06:13:58 +0000 (UTC)
X-FDA: 84311409756.02.FE274DD
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf07.hostedemail.com (Postfix) with ESMTP id B502740009
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 06:13:56 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=xOfWxdtU;
	spf=pass (imf07.hostedemail.com: domain of bingjiao@google.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=bingjiao@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767939236;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nys0Vr5kzC40Tsia9AyrmiWODO98psXZK0lJxHgb7BQ=;
	b=ORcR9eBMxwN6meeuR2MMHHD1Pve+shjfpfpqXmO76D+JcR4k7s8IqLH9fJnONJueNYRuRz
	NtI6Jq/XkVoYuASuVxV1DKSHN0iNIpEoqYj3lZ2AwccVx+RE8h13kbtejLdZafPnmFBAWL
	U+Pul4m2J/R0zSjkudRoGa1lRoLagio=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=xOfWxdtU;
	spf=pass (imf07.hostedemail.com: domain of bingjiao@google.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=bingjiao@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767939236; a=rsa-sha256;
	cv=none;
	b=KS/FirklqGtq7vD9+4TRoq0rWx+5+X8+uLLfxfujMS9xBzUmXX+R+jMvG1Rq3U0OHglrjJ
	HyRtQ3JKfUw0KqVjCql+Q9LHyD8o1ckLrnvB3rdMxmV/ZSzMPH2fpt9GZsdaa0u2CHYElh
	0r3Ii0C0uR1WCx3rl6th2yrQ0DPrp+Y=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-29f02651fccso46275ad.0
        for <linux-mm@kvack.org>; Thu, 08 Jan 2026 22:13:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767939235; x=1768544035; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Nys0Vr5kzC40Tsia9AyrmiWODO98psXZK0lJxHgb7BQ=;
        b=xOfWxdtUfNn+b/ItCgGF1xtSDI+Bgtw2sImHeG33Y2R+h330ynahgl0+umqjEMAIbW
         Shf9yDtdg7Djvpwh+OZXlplXlyv1NOQ4UIZO5gfUZMpiu5njks9y2mZ3QNiwcbBgNneT
         k8Rt6halZO+SnTM/8FEhPl7p9KtYdLtfLb+GKo5/r/vdzgk413L3RtHTPFyHHhRVbXO0
         57Yv4UsNHJJykRzfNGjp8Uv389UBBFPeNYajMiKipVl1zdFJn6Pxgq58hXZKrZXyva3n
         ak2hgUfwNNPSMH0ry1sJKtuE3Xyws0ZuzFvz/an48Uo1VPoHm8sO8EcDENiXxMG5T8B7
         tZyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767939235; x=1768544035;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Nys0Vr5kzC40Tsia9AyrmiWODO98psXZK0lJxHgb7BQ=;
        b=r9Yk/RFxrKG2rEXX5mncIfhY4xIzsCH46UrUQZMVDaZWeZnwnb9EpgO86sClcI4NLw
         9QM/Rc2vAjRt+rBap9icBTZ6M4L14dOjzmctR7pR1hpKkB6P7h8AtmaaH/c8PyiXyBX4
         TU59BAFhsK5ed/9U6AsvxAJGU7X3Hs92Rrl0lreoPCo00I2YFGVTApbRFUblTD0zMeks
         KkVZo5u1Emwo/S9v9B4Pi+Vmhq8sRWpnJcv27bewRqrCT06f8ZHU5+81P1PA4UTlqHbS
         /xWmRFuubpTbQV0wieL/LqGjkBfdN+ztowl33auzDOgAkyd/e+DkWmcdtTWqOu5nh1Ju
         QsUw==
X-Gm-Message-State: AOJu0Yy8QEaZfDJ395+OOkKSysjZVovkHUdUamImxVj7HN4mAZolY+eC
	colZLiZbYMz0FHuXs2uC9Io175kk46BVfC3GpWXJ0pSsS8/VOi/E1jucftGb/lQVxAMDyrU39oY
	kacVpiQ==
X-Gm-Gg: AY/fxX6+pX5D5aH9XAODrgNyviswQeSgDUOTvi9cFnqi1wo0td/drQMTly5tWzAyfXl
	xMN9hrR3Na6kzypITNyv1p0dmaIHfDLny6jwebfTSQjoj3Ge1QkBi4N5IQYGPFbwd55ItnxbxOC
	7CJuRX9sYZJPD8tnQBuNTt9lHbKrjtJxIP5J8NFjkhMqXPaSm1CkOEPB8ZIzylgJ3ofGflbCqvH
	RqIWq/EM66e+qUZYJB/P+O34ZudOCozcjJeQbKUlOFTtpHPsJ33BHWf7qweh4Am3x/uNTnZgd/O
	0OE0GnOs4EV/1Yn0p41OZDH6gfgPphzewo7DI+wdrukzdybZE/QX7lnYkOK81UC0u/iWkp7yfdM
	c/haUSyAuPNHkyx+uBAxR1NS0JijRfO+YWrfxQlJyyr5r0VM/ZI9wqs2CQpm0fsRJM1q3YDPoG7
	bXnzsePkaM57NfSTOrOQktFrBVSJ82gRJxTR3P5WGg2ovf1pk7ecdp
X-Received: by 2002:a17:902:f786:b0:294:d42c:ca0f with SMTP id d9443c01a7336-2a409a4dc29mr2088965ad.2.1767939234904;
        Thu, 08 Jan 2026 22:13:54 -0800 (PST)
Received: from google.com (248.132.125.34.bc.googleusercontent.com. [34.125.132.248])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a3e3cb2c5bsm96212385ad.58.2026.01.08.22.13.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jan 2026 22:13:54 -0800 (PST)
Date: Fri, 9 Jan 2026 06:13:49 +0000
From: Bing Jiao <bingjiao@google.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] mm/vmscan: fix uninitialized variable in
 demote_folio_list()
Message-ID: <aWCcndUyHO61f_do@google.com>
References: <20260109055937.3739860-1-bingjiao@google.com>
 <20260109060622.3742262-1-bingjiao@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260109060622.3742262-1-bingjiao@google.com>
X-Rspamd-Queue-Id: B502740009
X-Stat-Signature: 5t5igp96h7fh8fgfwwstfh3i7pkf5mf8
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1767939236-940063
X-HE-Meta: U2FsdGVkX19/EFf1bjy8+IWdPX3iGe4llMsplAsszugig3Loti1eywF84Z14O1rVLQAL1svAKEn9cs4owLKJctmrZXBxlzlHNsTVtx1Pv9Cn78cIkWadvWD8GhgODOCmRZPrvcJzoiTY6FJtaHDWL/2H9KgCBnq3meD6QNs4ohPhFvTkV10ummvCMkxteG7EG4cSTuWYBDw69VKtMWaq3Zue4/eo4noS1F7boeQ0MnN3QcAMw1J/hvTlTRFtosV/Vz60OoacFEmkadwbfuPfrx/6HPdKGU2BjxqUpr5/OmWyu5wxNxk56AqZmA9hcHVdibkmzdjISd5MKjV+66SgPBBdGDHJD45trFiTx6EKujNA4qQGsJFQWOPkSEMDV21GpUV6gRjPwQQaiJ4E+0g24Qc89DWHom72RvrYb1JkArJNWGA8ap1O4YUOQl1VSowCrYqjaFTct2SCDl3Tl/DP9WpnaCpRnxyKM6Eqez77skQ4PD4zvDz9zMvz3dO8r1dgiU4fbn9SrOzNmcsENtx4XJIH8SybqF74svzK9US+8c9FCdD5YaIYXK6xaQtb7wacnDbvzBe4ej2dzMGiJGORmNZFaK8zB3W55mOeiqSs5xfMukOF/cyniu7BrypCpCqcraiiLsP+28DHEf4SW495LR7M9btqQCPl+bdib5HSjuKbSY98+6tmJPHh0qbvEkuWSRYFWimU/D9wKcYMJ/qmVAeQxl0sL9L2WC8Wxcw94OslfjKZ6ORNWwtk2e7Qxq7eV2Hwmi7Uw3NeAIhGWAdPcbyQGyR+OixqP6nW4YM8vcZ5/GTnfFKeHkwHlTnBe+PxR+bxN4YlgjemnPj99zznN5PzchZxmEzek03O6D30McxYTbY0pKttiWs0+VNuezyAiQsfe8ERgkJk+g0TLpgwRjfFzk6X5YRrV9YV2b2FRyY/YT87HrQ0FrR/atIkZa6AJxxEDcdFVjZPyy3pKvi
 ZxOLFaiL
 SnDNsExKIzY0Xg7tca++Y+jxvFDVVmEJUduI1f2S292EjTFc6HO9SfZWTS8S9CXCrAm46djg5tABiahrF3mdxD6pPAZCYG4LEU6tOtSbckmeKxM8WOCZrnJCLARRVdn4P20Nm6Zpp5tCLc/mvUFHn6yysX/4B0HG7AVAUNL/MQNYb7bohJ+RLuvpecZo+BGc0myXn3Gj7BuTnoHsc4d+Umk9L+ocrGYbPmzGjuDlqalrhnOto7l4udre5ImOkkbusmSNdiPP59L5BmkXmljXLeZc3ioKnui6/QDwtNMa5huH2njpATk89+tn6luuTHKlBfA5RWaFrnoHfWWChw6XitYnn3lk/6ybGiM8YSCSELvLgIEu5yaJvGzVDzkSoQFvW/fwF8Y44wTz/Di726iKJVhtv/+zKrAnROOhDpa1iiE0fUWkyxfoL/xn37q65eCHU3RHu
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 09, 2026 at 06:06:21AM +0000, Bing Jiao wrote:
> Commit d92027a5f30a6c ("mm/vmscan: select the closest preferred node in
> demote_folio_list()") refactored the selection logic for demotion target
> nodes. However, it removed the initial assignment of 'target_nid' while
> leaving a premature check for 'NUMA_NO_NODE' in place.
>
> Since 'target_nid' is now assigned further down in the function based on
> preferred and allowed node masks, the initial check at line 1046 is
> redundant.
>
> Remove the redundant check to resolve the compiler warning.
>
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202601091037.vUSHeJCH-lkp@intel.com/
> Fixes: d92027a5f30a6c ("mm/vmscan: select the closest preferred node in demote_folio_list()")
> Signed-off-by: Bing Jiao <bingjiao@google.com>
> ---
>  mm/vmscan.c | 4 ----
>  1 file changed, 4 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 213ee75b3306..590ab3ec1998 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1044,10 +1044,6 @@ static unsigned int demote_folio_list(struct list_head *demote_folios,
>  	if (list_empty(demote_folios))
>  		return 0;
>
> -	if (target_nid == NUMA_NO_NODE)
> -		/* No lower-tier nodes or nodes were hot-unplugged. */
> -		return 0;
> -
>  	node_get_allowed_targets(pgdat, &allowed_mask);
>  	mem_cgroup_node_filter_allowed(memcg, &allowed_mask);
>  	if (nodes_empty(allowed_mask))
> --

Hi Andrew,

Sorry for bother you again in my patch series.

The fix is a simple removal of a redundant, premature check that
was using 'target_nid' before its new initialization point, which
is reported by the kernel test.

I am not sure whether it is a good idead to send a standalone patch
to fix it. Maybe it is likely easier to process.
However, if you would like replace the series Commit d92027a5f30a6c
("mm/vmscan: select the closest preferred node in demote_folio_list()")
entirely to keep the versioning consistent, I can send an v8 version.

Thanks for your time on this patch series.

Best regards,
Bing Jiao


