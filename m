Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B74BFC982D7
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 00:50:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADCCC6B00DD; Fri, 18 Sep 2026 20:50:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A66EC6B00DE; Fri, 18 Sep 2026 20:50:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 909816B00DF; Fri, 18 Sep 2026 20:50:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 722226B00DD
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:50:47 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D645E14010B
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 00:50:46 +0000 (UTC)
X-FDA: 85228681692.25.E7212C4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 373EDA0007
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 00:50:45 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OWiegJOT;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789779045;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b1tw2IOdATgIAgeOtOU6aYsEKazCC4468v0MK6zfWn8=;
	b=eRVHOoq1bNYxMEp0k7jICdQ4lr4m+O7Kozcon8T8oXUbIJsyB2kii8+yDF8Cbgw0JvXxLG
	59tHPSLk8lBi4Y3ptNXNb0IExkkUh6lD764BJdgVkG0HtRGXuIzcuzXkqumCDJRwYk65Hi
	4gSWMHt/pWWOJ+1JBDSceWgIBN7sI9w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789779045;
	b=UUAs0YOYM5bf9+5Xu2clX2tmt4nQc+1Z3nJ33Rh8LY+s+PT091P5QNZI/UlMl37x38xtdP
	d5vYAypLP9FypAkYqJh4htq08atZLjm88Bxwa/pe4nxRz1AMAFNbGg7BVqLkSqo4JLKsez
	OscXQwfHTTkpayjYT5i505FBM8BXaBY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OWiegJOT;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5E20B43D26;
	Sat, 19 Sep 2026 00:50:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79DE61F000FF;
	Sat, 19 Sep 2026 00:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789779044;
	bh=b1tw2IOdATgIAgeOtOU6aYsEKazCC4468v0MK6zfWn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OWiegJOT1477KjdFWhk3YWWOb8Ji4XwOajTwo+QzhXmIeDeigdMcClxq8G7x4Z2Oc
	 rzKQTSyW0MOe2pDyHt1AotVNoYDH9Mzy1Bex5xwq5xb+Zx0z0b/MFvQAvMdyyOYDy9
	 D+bnKsVZxc8Ytl9ZuAUxlxHbWYPrtoVfbUY9uQI8eHCbeQN/MRJSmXhnVQQ5GgiPb2
	 VgG9W2qD//8bh0MfSJ8dSmReZaQnCEHGfsGxKzxQSlCNfRg2n73EPplJLIpSQuCE6Z
	 rQAEI8jNCb3zIiRgkoK1Yv4mmDwEXHxn5bfHY6hov+wysyw7XcQzM2M2V57O5PK30j
	 C5HqY5aFpZkCA==
From: SJ Park <sj@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: SJ Park <sj@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH 2/3] MAINTAINERS: move memory tiering under MEMORY MANAGEMENT - NUMA PLACEMENT
Date: Fri, 18 Sep 2026 17:50:36 -0700
Message-ID: <20260919005036.87201-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260918-maintainers-mempolicy-v1-2-9a94cac6d135@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 373EDA0007
X-Stat-Signature: mgskka9tkfntoaoksz63stam17y9ceuw
X-Rspam-User: 
X-HE-Tag: 1789779045-476840
X-HE-Meta: U2FsdGVkX1/w8qjD6JNwp83+9OL48VOaQvit6oXycdI5Qm7kIwYc3pYZeDtgAKj7FqROPX7Z+yGDR60NRspcQ7uduA4lxzRnVVFbJWBUUU1NdbkBEQvrrILHfWaylivfB5xlcNWkziramYFgKl6g9hzgF0tDmtJ2JDk2+fmnmYb75+hpktiwvzcWaxM0JOOwLJ5vPU+ZBiWPCsfhVHhKBEaX1ln/wIBLIdMPLVtaWIsbxZt8+awqg6Jp6qUdT6PWuOOAApj9RCj4H2Lqh5Sw50nBB7XG8wjVmh7E1E+xoZOwXBx7odXYty2154SlzQOOe/p5U3gP15n8VlHDu94eAO4PrUs7VCdcnEhh4Ye0EyDLLGEMTzSQDqQ8LuFcXBDIjgEk7CsVGBCfsO7XLd5aGcQ7o+qQZcQaqImzLIzsTM8zBieGjQbcZFKeoYbojobc55kZueClCgr+QubDeJCTg2xIlhXGsnhrxUt179s3XyrRF+n/qan1wxJc2Bp6flTimRi49SWti4Z75jQ5IB836rVk1pNFgDBCh34rqJNv58nN4yROBxzCpRBPAde4kq90BXUlTViGg7/ilz1BlV3aVZ0d2zmn4gjfUCCO8+0Nzd/eOBSqBgcLFYdS6j2bcS/ClllmQBkyZxA9EJuBLTYWSTEZQy3u2XDC7iEzsntvc4lNzNB2fSXAySBnhgltMjAxwVvY1fx8UdmmsUbr/ItZ0Hn9EV8JYI5mugo5sVR7HZ2ug7OJTg3XRNgXTXuatgfWkJ/u476/jp9bt4KsQYwR6xxRo/gYhFZauceHrJ0Dwy1h+aced4pE8dH5Av9Sbrbhzz8W5g2JuxiLbrBOir83XsrCByyTd4i7pFIArmL+xyY7JThWoobOQaOBG71JqSbBa9fAQrWBm9aLU2Huu3kY7eWZFqw5NT/vG2TWkuCKeoHFewO66GGLTS3ln6DR7XyMStoHN4Y/s6rNEzTC79a
 pUdcSxAu
 /Mj53EVqDqA8cfDIB34XuK0iHkGRK0MN91G2OB643gOulM1TnjBk5SFso4g5oHRKH8M7kOzW3zsUlsMN8X9X5sSdXq2trn6MyIeIIw3UyMkcLKOU7lISTtTtbm9m079KnN1KHNTEQjd+MzR5Yj83AavQaAvH61Fnzbg3YXh7PXVXYunsVu/JS7e2+QqR1iRDYqIfacWLj9LmfsAVHTypaPSjoIvMJs20EhPR9KS3KQkNqYcFUZCqTHoBItW1CeXEaoDVq9VQX3XDZxiNE00oiroSy4ZOkonNTHiar2hCPbn8nR9islajMLwcuJQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 18 Sep 2026 18:34:25 +0200 "David Hildenbrand (Arm)" <david@kernel.org> wrote:

> NUMA PLACEMENT is a better place for memory tiering.

I agree that's a good placement :)

> 
> My best guess is that existing MISC reviewers are not that interested in
> memory tiering, so don't carry any over.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-byt: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

