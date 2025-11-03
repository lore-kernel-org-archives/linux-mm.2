Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B48C2CCFA03
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 07:55:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F8698E0034; Mon,  3 Nov 2025 02:55:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D05B8E002A; Mon,  3 Nov 2025 02:55:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 071058E0034; Mon,  3 Nov 2025 02:55:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E98038E002A
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 02:55:23 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BCE424AE9E
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 07:55:23 +0000 (UTC)
X-FDA: 84068535726.24.BC8F597
Received: from mail-ej1-f66.google.com (mail-ej1-f66.google.com [209.85.218.66])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6BC32140002
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 07:55:21 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=C9AwIaEZ;
	spf=pass (imf26.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.66 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762156521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LG+X9+YNounZx/yarpz5onoisOPc/oil7GLZG6w20qY=;
	b=Ob9Ku61HMktn/9RVLWolp6aujzYJO0JCOdigYIXBxlr9ATnGHMfuIFSzLpQWbX3GZ3jq8w
	XJCAfYij8cBFLtj43xbPAkmcyyziHAUjfGikEyhduoR9E5B+Z1QL4+3OPwYK20sq/M3Igb
	7t1D1ykyw98zPXTlTwpAw56V5bJ3CoA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=C9AwIaEZ;
	spf=pass (imf26.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.66 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762156521; a=rsa-sha256;
	cv=none;
	b=tokzwvO593ONahcygyCW3CfIj+ggzZiSP+YPcD3iXlV+NNSqnwB+UaIeODbvNRMvJC+Qxp
	/LcJrmLefPGIgBrsfQaoQKqnD8FpvehjIn9C5bW2go6RqXnU/Dpp+6egrEIWZ84e0D8diz
	hN+5+a/jwVm2WxNYbnL8c/UGPKRkNfo=
Received: by mail-ej1-f66.google.com with SMTP id a640c23a62f3a-b6d855ca585so775108766b.0
        for <linux-mm@kvack.org>; Sun, 02 Nov 2025 23:55:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762156520; x=1762761320; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LG+X9+YNounZx/yarpz5onoisOPc/oil7GLZG6w20qY=;
        b=C9AwIaEZeHD0rApo23a0xwDliy9nvtdW6UbZCsJ5kxodb9t7vhnt/B/l+FTgiWiyLr
         f6RjgdZdBsMxw8z7ooPVT/SUXJ3lMrmcDYmhYaHXfWoYiEkMOzkRSzqeBGTKi4UADu/H
         KHXw79WLJewp7RbUGrwlLWrtW9AlfyzhV3T+l3LWn8ipRDziJYmXIBAaIB4t2SPxqc3o
         xgw8PFknOJ3gmaPUW9P3Ko+VosGGmevAkPm4fYcZjY9a/AuH/+ue0K9dB6jaFZv02Cvq
         7VxYGpomDoDs6XLUVHWuiEzkEwdGjtWbf7Tqw4E8vSvq6aFtcqet78JrmWjeV4LOvDtg
         VaZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762156520; x=1762761320;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LG+X9+YNounZx/yarpz5onoisOPc/oil7GLZG6w20qY=;
        b=AhXxY30VFXI2WVpw/SXubHoHz6RHGuulN4P+etcKS1phvf+tNr1/YO+UdjDA1Bo+Ry
         UZPc8lc5/VXZuWfUwMt0wmln9OdgFhJH/ZsYCXwnIYQ2IX2K56wJoMsxW64/vRVDhyFb
         U4H18Xg5ju6bbf/6oZFiDSJL7YsFZ5FXBedVPKIgCsHnYXcpnZBN/xVo2gsdvdDvtzsv
         vuB83yf4u6vUVs++EyX4a+ZYy3+6UI6VICaOG9ybfWAEa/pYm49NwET51YO2uKJT99J9
         08/9rSOEmcG+qmPoCYL5yfxvY+nA8mJvZmpDNj4RoNQd0cc0PMbyMSNDcMd+Q7M1LTmJ
         ndEw==
X-Forwarded-Encrypted: i=1; AJvYcCXrIAIPtx/61pOzwHgluD9sF/EXawMr+KRb7HlKe4LFarykErYDfYq7C3GcYZxxUtzXT6eki2hafg==@kvack.org
X-Gm-Message-State: AOJu0YxCEN5NoIAEJSHFKM7mPqVDDFSXW0GFOlMp616Aok6NHX3t1luC
	lB3/0IYQvlsyv/NeZuDNSWrIIzMyR7v3m4cHgpVnFhxrWoaRsou/XYZAXXL9yTfSOSU=
X-Gm-Gg: ASbGnctbE1/+VG4s/v/e2bltFIUTx11/wKSoC2qRB2tTkGdJF3XIk51TKjs2o87hQL0
	kZOgWB/ngcEMHo/LjnDiDWZNihVkWwHrGQ0ZZLHNRgGjInNGuBvUxlpLlxcI+RzNy5MDZwnb25/
	+yPWcS3mj7xRE/3Emv0M3qEwk0p8iJOFTpfyoK4xSNkztKjRgHkigeoPXBPySHMQlg9K/OcmFRM
	IW25NP2l7pe5XI5qZnnau/PqL6Y2foMbRhvXAMqsa6fX/BAJo9vxZ3b5ZMnOsRv81xyNJmGaEKJ
	jmWcok/bPm1lRbOyVJxs6GLND4TWBkjdNGa380X8YHXSzV0f/91C7IhE48XvSNEPbJuUW3LL9wE
	ZO8s9rxwv1NoVYzIVbYI8CtwsYxRSEWPjLiU0+IMHXBMAJ5hOLWW18brEuL+6kEdmInXB6gnSnF
	1ODZVXpA8pAoI9YQ==
X-Google-Smtp-Source: AGHT+IHa4Xl7JZ3CIUpyYyBE5kztcOvpiHuJ7ZhJhBGD5U4E6YrSM5iAbrUgVG8kGis1gxqx4Ev4/Q==
X-Received: by 2002:a17:907:97cc:b0:b6d:7e04:7a24 with SMTP id a640c23a62f3a-b70705e7dedmr1240745066b.36.1762156517654;
        Sun, 02 Nov 2025 23:55:17 -0800 (PST)
Received: from localhost (109-81-31-109.rct.o2.cz. [109.81.31.109])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b7077d10664sm953717066b.74.2025.11.02.23.55.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Nov 2025 23:55:17 -0800 (PST)
Date: Mon, 3 Nov 2025 08:55:16 +0100
From: Michal Hocko <mhocko@suse.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, Vlastimil Babka <vbabka@suse.cz>,
	libaokun@huaweicloud.com, linux-mm@kvack.org,
	akpm@linux-foundation.org, surenb@google.com, jackmanb@google.com,
	hannes@cmpxchg.org, ziy@nvidia.com, jack@suse.cz,
	yi.zhang@huawei.com, yangerkun@huawei.com, libaokun1@huawei.com
Subject: Re: [PATCH RFC] mm: allow __GFP_NOFAIL allocation up to
 BLK_MAX_BLOCK_SIZE to support LBS
Message-ID: <aQhf5LJJMlvT-rrE@tiehlicka>
References: <20251031061350.2052509-1-libaokun@huaweicloud.com>
 <aQRkTKTm08lSJZZi@tiehlicka>
 <1ab71a9d-dc28-4fa0-8151-6e322728beae@suse.cz>
 <aQTHMI3t5mNXp0M1@casper.infradead.org>
 <fwm7tynepbnpq3db7u2fqrzmeq55gs5472r7wbggxmndap3k26@ngwgdcy26vxx>
 <qfo7raavlfupjqwbgl2mnmfvmn3z5oslnxcehorib3xjdgf4yo@bp76xmxplre7>
 <aQTb0NdyN3tU50ss@casper.infradead.org>
 <k6k5azen4otnvlc35hj5ak7dmz2gxbb4lrgdu7cirewotggnp2@55cywarovlvs>
 <aQTqELGGKCN3JTIm@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQTqELGGKCN3JTIm@casper.infradead.org>
X-Stat-Signature: ndp75tinxmo66bb48iaiout6b6fn99zk
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6BC32140002
X-HE-Tag: 1762156521-891510
X-HE-Meta: U2FsdGVkX1+o5KuPoqulNL6O9DQYlaSOgHDyawyY5KCs5TJQMWJXRRyn0MOo4j1o/uPEhq6wgT4I2lq6WGowTbuymC+9wNdniXf4Jpbuk7vPcIcW1GQrJq2osI/ehpYLJw4rHNhdwa8PJFr4ZBZLa9QaAsrh9pqj3/SK9o2b1s275wqkpNiLeJZMnn6I0hGIDcQYGxyF99AN+TAoGtBkViNlKQU3vw9y5L3i/weUib3rJRN1o0kLhI5oRsuB+0DNevum0diffUoTdGMcLe7eewtNypW3yZuL2PyunCh/EPT3q14K24BjWbzYaH0LvtS6EJpSGdS3UCaT9MtnocwhdHROrtEM/V1plmFCIcWUWb55uC1zHJeDXG4yKQajFVXjm+ePZiqWiIho+5yqZTDrYxUaxAxu62Rny8fjIYuQtw6uvu4zlgXgNz5A2nUt4LKpu4VYsmska2qkOphc0G6QG52aM0Fp/qw9DQhczFQ2QpYlb6nPJW0y9NC7fNhqSj/lul7FgV1AYNPk69fZ2TaMUqEmq7e+WSo2qLUk4oNT3XROFMffkBVZlu+Om1FUG18mhJ7tqcxNYTmzveZZlJkouBjlXm+JiCGwNzs7cewFrzbSCF0nBVUCA42Q5dqZZBlB0lWce8hRzdL06lMeUMwGZ0qcS3xMDSCGikkOCtd2sruEe5KBUDK/ypZgZeHe8XgCxQsivQ2MMz9jy2MIXOrJCKsCZHDNS86Ga9VYr9uQa1JxyU4bTCyHikgGm7irEBQfqfzlcjVWthpdXmNRZNnOb5mK0n9LkNl7sRP7Zff21wq5lfTTC/p/c+0gyf/rvakqWhq/kzaiOPJLhFiBjpGHk2cMhUQNvaazTEMam3rdgN1DaRWXOZzVRVNZyIz6CrNxqI5wY0v/Y0Zermqv/hRKDKJ4FH6AdrULYh+3cXb+Jss3rd7meF6BV/Wp+D4FJ1vWJ8cn/PzU1D7HsnRJiF0
 X8UcHgU0
 S4DsPPuc5a9nMX4vZTBynhRaLaxpz2OzPhKS6Sojb56GXBXYT+k/yzRV77MswguN/sYoa2D2p85Hbx5a4I3YSWD/HF23vLoS+NGN3/Lv8J3mWN9ad+M6wDzjKgzjH4+1JxPbOVa1DNFx1W3ijFysbwmVr3jfhPqhjeYW71k6FW1M9NqUf3MSMGCokTOmJrL9MCTKcdhICfXFLmrwNSJYlgrZq/CeMAK6+YCrpVXu6dliIwOXGVz8p9RCL1ABi2N15th7PBKyIIqEobXZhWREZlOYisDWp7n2kDhnNvdKTeuApY+yOAhDTW4J+eyh1p75NNXoB/4df8j19JUMkGGhhvFhUPp0Oiigo5stXZjrZ/4Leif8anDZqzrYi4RHjmYK9msTKOmKF9wivxcI9YQfEAF/YxTr+MxHlSov4ZGQofHlOFxbSTkAvkrApsM5rcDrfDHsFHSllRanyspUu/7WfYvDcltewNjg4WkoCzh+R9EUK/l9aw17I2QJOJzFFMBej3C5hegxCtvwch9c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 31-10-25 16:55:44, Matthew Wilcox wrote:
> On Fri, Oct 31, 2025 at 09:46:17AM -0700, Shakeel Butt wrote:
> > Now for the interface to allow NOFS+NOFAIL+higher_order, I think a new
> > (FS specific) gfp is fine but will require some maintenance to avoid
> > abuse.
> 
> I don't think a new GFP flag is the answer.  GFP_TRUST_ME_BRO just
> doesn't feel right.

Yeah, as usual a new gfp flag seems convenient except history has taught 
us this rarely works.

> > I am more interested in how to codify "you can reclaim one I've already
> > allocated". I have a different scenario where network stack keep
> > stealing memory from direct reclaimers and keeping them in reclaim for
> > long time. If we have some mechanism to allow reclaimers to get the
> > memory they have reclaimed (at least for some cases), I think that can
> > be used in both cases.
> 
> The only thing that comes to mind is putting pages freed by reclaim on
> a list in task_struct instead of sending them back to the allocator.
> Then the task can allocate from there and free up anything else it's
> reclaimed at some later point.  I don't think this is a good idea,
> but it's the only idea that comes to mind.

I have played with that idea years ago. Mostly to deal with direct
reclaim unfairness when some reclaimers were doing a lot of work on
behalf of everybody else. IIRC I have hit into different problems, like
reclaim throttling and over-reclaim.

Anyway, page allocator does respect GFP_NOFAIL even for high order
requests. The oom killer will be disabled for order-4 but as these will
likely be GFP_NOFS anyway then the order doesn't make much of a
difference. So these requests could really take long time to succeed but
I guess this will be generally understood. As the vmalloc fallback
doesn't seem to be a feasible option short (maybe even mid) term then
this is the only choice we have other than failing allocations and
seeing a lot of fs failures.

That being said I would much rather go and drop the order warning than
trying to invent some fine tuning based on usecase. We might need to
invent some OOM protection for order-3 nofail requests as OOM killer
could just make too much harm killing tasks without much of chance to
defragment memory. Let's deal with that once we see that happening.

-- 
Michal Hocko
SUSE Labs

