Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF5D6C5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 04:52:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D94736B090C; Mon, 17 Aug 2026 00:52:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1DD66B090D; Mon, 17 Aug 2026 00:52:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE5F56B090E; Mon, 17 Aug 2026 00:52:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8903B6B090C
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 00:52:31 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 13190160643
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 04:52:31 +0000 (UTC)
X-FDA: 85109540502.13.C31CB6A
Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4E3A1180008
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 04:52:29 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JT6UYzn6;
	spf=pass (imf24.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.44 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786942349;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lXCFBr15COi95qp1EsFgIG/0N/CfzI8VoEXN2Vn844Q=;
	b=UZdq3ahDH0Dm1wgpZG8++YG0EKWbrH3MKcIvIMG9sOcH3mR693IdWr5fet6SnTwpYzV0+z
	uapRzZlY+161CoiOQes3Jp7gZjzLIKTuYpALV5M3KlHWnnuDoAgn0XAmQBVrv8P/6coRqW
	ePWeydPPpQuPHq2qipMGDcNj5zgnstw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786942349;
	b=MaCXEVGEOvFQq+AxEP98dlO/P2iObClm6bpsB8FaMpgShllDxmsxkwYlJfXRIaBcECbsHM
	JnTM44pvwS3Jd/FG/R+GM7LLuKeARddnOz3uS1na6cMjOZ7iITslHX+/TViz7fDJXt12Zf
	F4GUF6TX56ra2dQIh62RnHrjFNiO1ik=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JT6UYzn6;
	spf=pass (imf24.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.44 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-448b69cfc6dso1989601fac.3
        for <linux-mm@kvack.org>; Sun, 16 Aug 2026 21:52:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786942348; x=1787547148; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lXCFBr15COi95qp1EsFgIG/0N/CfzI8VoEXN2Vn844Q=;
        b=JT6UYzn6oeUWt0Vhl6pR20IfA8TrLJZnkYdeEfD07/rni/sQbkUJMx/Z0skNd0/EIN
         vYKYtdTIUWsq4gcL08SEi8YC1UR2esKgYfIsflSpLywv3WHj7Z1H3Ole0/2eKHcjxT7q
         aEpoYFVNBFJ6JR6q7Clos0SXiyKaxOxq2kDx0vo7shCWeN/LEwrdRMDH4qP1TRaVOOac
         Q8o+w/prm12CW020sgWehuBd8nwMgVBKkKapjRah+GV0WaW/Et067Bvatr3fcmrA8IYM
         z8qwuIH2ma5/+D6VQ3f1czymyG+RgsinzJIN9C70O40Kd81954JzoxDvk7Tww/hA5jTG
         qIuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786942348; x=1787547148;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=lXCFBr15COi95qp1EsFgIG/0N/CfzI8VoEXN2Vn844Q=;
        b=L1slvIvsm463TpDAdPCKSi9yJKhs9Pice5hOaFAyJ3bwYB1tHlhwbrJtXopAdwUxpC
         kkxT5YjVhaZz9GSRpTUn2GAtpNwtwE5LXO1muUTPOKC/Ec2JJyWX57nLfUID9Uxqx1Ov
         mVVkAZ0U1PLenvXax/f/BYG2UT59EbfW8WVKxSFse4wNipZtfX7MSrOl9K5z9c/gviYJ
         l19zyFyVU1t1Y3by7HlgYkzaSITXYzHikVtEHIDfS7pECcwO5URcagBEwr7vguYcgXKI
         7xhtd3yGV0a0n7+IavEWpzvJTWnsaxzWlFtrmiS2+p9XTM5QEEvLz0XGLiNvv9a1MZ7u
         b1Qw==
X-Forwarded-Encrypted: i=1; AHgh+RqFp2Dag0NtQTbqfYYMyl2haJqUaf++Aq8weY0RZPyE1+9D+J6xgg5QfaxJrCKmeuu2bdJXr878Pg==@kvack.org
X-Gm-Message-State: AOJu0YwF01fnzTsknxp+a0koJ1EBXju7oER4Bxxi3NZXJ42GBCOAFkIR
	HzRnwn9JU2bM8q+wk5zbk5sL0+FyLFgGm0yata9Wnoj0urya3hqmPKQr
X-Gm-Gg: AR+sD11NA8f+FW/vPK6jrCilEuBOBGLKmvVWEIvFpy2nZXm1GVgmNNcjSUl1EkRDih2
	ni9WkV7DYBYd/IhAerCuaqcxsm+sTY8cUslUigmJv8khHZyk4Qv/4YSiUeZ3b/g5WOmvpwW84RD
	iqGCU7QbLqqCqQ1S6+FvmycCmB+f+0f4G1GDWZ061GKzjRJIcHQUv+WoEvGrsaqJT+U+UA8co/z
	kGxzS9Xw0OYEDrOGAoQvbpnIiQjvG9VDLLeSKD/SgH/LknmIphjJCcItJ6YQiWu5lgEyliP4z+D
	dRxEdMesjcYgaQLvtvVp68jR6eRjNEbFAEhuyA/GzZGotpIV6EAHrtHxo7qqwi2sZKeAh08OmtV
	3VjpccOP5o2VgvZUXPcIWlJBR6alChgwLj6DTtgG0F66ivTDFeGh89j1732YRNpwsID37SSERbK
	ujsxY2caz4sYNJNW+3uZ2GLCHBrEbV2ycmOlhWTH0/CTTXy8BdnWBEQ9Rv+f9NECLwAP5t9AvHu
	gz0G94+metKbWWhzhb2e7Uzr+APRVDYyQ==
X-Received: by 2002:a05:6871:680c:b0:448:c6ce:9617 with SMTP id 586e51a60fabf-45e91ce96b6mr18797832fac.5.1786942348251;
        Sun, 16 Aug 2026 21:52:28 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:a::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-45f22aea368sm300381fac.5.2026.08.16.21.52.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Aug 2026 21:52:27 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Gregory Price <gourry@gourry.net>
Cc: Rakie Kim <rakie.kim@sk.com>,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	byungchul@sk.com,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	dave@stgolabs.net,
	jic23@kernel.org,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	harry@kernel.org,
	kernel_team@skhynix.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com
Subject: Re: [PATCH 0/4] mm/mempolicy: introduce package-aware weighted interleave
Date: Sun, 16 Aug 2026 21:52:24 -0700
Message-ID: <20260817045225.1807518-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <aoJY53BJztPQYumw@gourry-fedora-PF4VCD3F>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: hm14tzjk7f8yoimrwdsrry6k3b8yywwy
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4E3A1180008
X-HE-Tag: 1786942349-680488
X-HE-Meta: U2FsdGVkX1/tyZv6dOs0NPFIatC/Ttl6H6NEaCAVHpLcWPHljTwyzykXn4oVLUNRO8jrXnYnE3wn6AGHk9HzTPLL/BRBA7HM8GXOpL3gd1SZ4997t2mh3H5NA1NC16FxhVVE7E1wH7tCp1dTXU062dc2OLr1OfyNnAxIB1dOXl9lMe5Hv2/YyAq9M3Vo8Tus3XXLb6lNghIR9YeR4MP+wXjqntYkAhXRvzZPL7fgFaiQRQzQIHppvrTXylj33GJK4rUcGbkn1T7pHwT6HkKRKUv+wTyPqXor+SoSKZ2WiKwfF63muWwqceNwDgD5wl2errsILCg8QaxV60kSuzfRCr0prrrZyyTb1N/Gpi3mkw6d3zKkFZxFv+Nl2mQiwWBUKmBByDZTn5TPKlZMlDMclLHmewoaTdchSqKpysneTUQYEbBeUQHm1cwTYpYLSGTQMAQcV45+Gl6KwKfeQ/IfG1rXiMCDiyDBgxjtTVtlmu17j2d6oFY21bY76R+D+IJbB7WqFJYcAblGvH0ot7p0/t7EkEKbW6xCjTDCFIK/txUogqOkoV5Xxe5uTy5YQVquLVIXJII6VT1oQiwCGbsn+y3EZjRsLgMHk03q7oIzw3/Hh2X4AAP7s077UX/Nq009BmEazcOzwrI7GKKRpWQAo6DyHMIsxAMBz0dCcI2UNiz4C/ip2kQf2/JwBROLX8b6WybVmuYnD+s3yVaiDABx6d4IHkpdwb4judLMyDtkhhMbCoiudMGUF7+xI4N167F5kcWj6ZawYt9eat/mpRHKcWJaHtTxI5Rfh3uw+xpJwdqAQI3jul8dlxvlGwcFa81BR2WPz0n5f5fs7f43CGHWHk2iKMhXhoqeaaJy+uf4ahpe+bOQhgsuiTJZiwWerPSqQVwJvw+6MGagUKS04zM5H5mimOQtJl6Zvh0dnwdZ0dwnigZtVf3iIKg/Npfj6p+xZTTNi5B3BxNPLfz5aLG
 STooHW0l
 Z6TbDuowEAbabI2NJyyM8p8EmdHrnath6HIVW58QLe4Cq7lpvKa2a95Cu6/obyEYcUSdKj/O6024BHLLnrfapA9/5b1bgt2cNMlwGJTZn6UjDl4anZyeIHBwETh4z6yiZKBpv7QJXl5upFJU5OahRk8g5lklkySy8reFYwW0gmOw/VeQfSsK0dDFT8kv+oNwBStOnp/ejnwgf8JKhZnSfxx1QTnwdfWQWvDNesGiUe/eQe+Q54dzmoQFt3QYcI7zOzZk0Gpo4iVU2wbbeYELDAectm+wHyS/L6Ub+YkTEmTjWhne78ubQOxBrDGMv6bmmPrBoXxdxOtfZZ0BACwMHhCbpsC/5X+xSXn1evBXlQViJOX1hrAc3yMiVNYlTCG0eS+/n1UXBIYnWUDV1UMFVErGYeVV/Honxq1TmIXbQOX9ia731Dzlje/pwuyHlRGoAfHU+BTcfcYFOj+00WHac0buUjd0+HB0CnXNE4q9aPH0dtoezJJ/NFX4bisjTsnPtzTg/tiCaMEdNOqQ2o70LrZNZInDtxshDIPlx/pUz05n6xElauRCNc257uvjnBhXsDYFHNi2VaPvMgbJYBiHE6VcXy9Sl5x/iy0wAuk+VPAvtJxU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 16 Aug 2026 20:46:16 -0400 Gregory Price <gourry@gourry.net> wrote:

> On Thu, Aug 13, 2026 at 03:23:48PM +0900, Rakie Kim wrote:
> > On Wed, 12 Aug 2026 22:37:06 -0400 Gregory Price <gourry@gourry.net> wrote:
> > 
> > The cpuset.mems = 0,2 you describe is the node set of package 0, so
> > the tasks in that cgroup use node0 and node2 wherever they run.
> > 
> 
> I think you are over-complicating the explanation and that's making it
> hard for folks to reason about this.
> 
> My best understanding here is for multi-socket systems, weighted
> interleave as-designed is inherently sub-optimal for scaled workloads
> that utilize multi-socket ("package") memory resources (DRAM, CXL...)

I was thinking about this and I think Gregory is right here.

I wonder how much of the framing around this series can be preserved /
simplified if we just say "prevent tasks from allocating memory
cross-socket".

I also wonder if instead of limiting this to weighted interleave,
this can sit on top of other mpols and just nodemasks against
cross-socket nodes.

> I think there is also an assumption that total memory utilization is
> less than the total capacity - otherwise some of the assumptions here
> break, but that comes with the general weighted interleave story.
> 
> I'm getting back from vacation, I will take a closer look this week.

I am also out on vacation this week : -)
I'll take a closer look along with the code next week as well.

Thanks, Rakie and Gregory!
Joshua

