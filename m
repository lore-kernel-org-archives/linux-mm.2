Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A738C43458
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 04:30:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B09D6B0005; Sat, 11 Jul 2026 00:30:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 061A56B0088; Sat, 11 Jul 2026 00:30:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB9C76B008A; Sat, 11 Jul 2026 00:30:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CF7546B0005
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 00:30:52 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 634B61C3E7C
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 04:30:52 +0000 (UTC)
X-FDA: 84975220344.06.52F4624
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf05.hostedemail.com (Postfix) with ESMTP id 412FF100009
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 04:30:49 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=hxkH6wQ8;
	spf=pass (imf05.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783744250;
	b=BrpT4Bn1lrobchLfNRAJSWBdXUf+CEMY4SuMOXX1F89nehnpZd/HDrb7snzVixFFv/KeeG
	xtZ+dMyndrislqVyMph3FtoVK81u+dz1js/RZs9jNTHr8y1nYWDl4HzaQhEHZ0Nwgh85zj
	pLmoPxU/T/Z+NO7BlUquxyETc1PWYxg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=hxkH6wQ8;
	spf=pass (imf05.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783744250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i40M0n26D/c6f9fCElUXR+GcUKJsl/7kjtyXElmGveg=;
	b=BUCd5IQNvlksdoPTrM7Jy/oMxgcEhjYuc4v4srf/PEGUSuGbN9K7lwUwlR4kKRPCS0VRHa
	WcooaPn5XIoBjrg0wvU0SRIdXTAOE+NCZwXcJCT+EsA6DbKfvZaAkNxA9UQP2HpyCwpG2I
	vie94ybwQF7eYfYwz2/NoVoHR15Pae4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=i40M0n26D/c6f9fCElUXR+GcUKJsl/7kjtyXElmGveg=; b=hxkH6wQ80oK2NruateAZxX0nkq
	3vYZlH55iGxjGEavjF1ZiFi+lQ/HpSmORWf1KCJGJomk1Xa59R3Q0nJ5vUPDZ7B3rmbab9vfGcDSe
	gTNaJmKlxlUAEs0chSQd4upcoMgMhwqXzrlgC/x4tWA5Pul6iYJLLCyiz9Zf+DgJMTe6l+epX/Ijz
	KRbZgpFhA2Qde0wARjDsmCdtrvA5zCbDxN8VLMwVLCoYiAI87reHIs/nV2Iyf4jW1CxyPBHiYfqzb
	yJnWarGkmAbxk3/dzha1PtzcEixUqasb3512hpvyoYD0myjLnzsBiMf3SyhaAWHjuzRHR/PUveKg8
	qvs/PF1A==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wiPMP-00000008eDH-1RTT;
	Sat, 11 Jul 2026 04:30:41 +0000
Date: Sat, 11 Jul 2026 05:30:41 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: xu.xin16@zte.com.cn, akpm@linux-foundation.org, david@kernel.org,
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, baohua@kernel.org,
	lance.yang@linux.dev, usama.arif@linux.dev,
	chengming.zhou@linux.dev, qi.zheng@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, npache@redhat.com,
	ryan.roberts@arm.com, dev.jain@arm.com, wang.yaxin@zte.com.cn
Subject: Re: [PATCH] mm/mm_slot.h: add a helper function mm_slot_remove
Message-ID: <alHG8YMmPYZWrKQz@casper.infradead.org>
References: <20260710131536564mY9CDv7aP2dKPiLFXbrBv@zte.com.cn>
 <178368585772.363984.12871786869575753171.b4-review@b4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178368585772.363984.12871786869575753171.b4-review@b4>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 412FF100009
X-Stat-Signature: gumr3izupa4kfdhi9uezix33uujk673o
X-HE-Tag: 1783744249-183437
X-HE-Meta: U2FsdGVkX19EXMxWzYWdJ/R5byg1msrpepUAAQ+uzic3G6zc0TQNgufvWtmXUKrVuNxNPQNJvVzXR6fmEgte9/TbWaiehes5wJZLXKFJ2aU8S6qLZgXDI8yLf/nd9x7A2Dy6nTnNVLYWvGX5OKtk7OW9/uYEZlDKnAR9bdDEaFpAb2WEBqFKJVOH0jaEBkMKkCFrK4noVAgevfayGS1L8JW2WDWPYK7p1vAa/QTB2axT9P1XHJ/DU86luwuVJB6MD/4HcesmCokboixZyUounPn7y54w95dgJ/QB2feb3u0kt+7xJFG1u868dHt8Al1NOfd35cEFM3Ke66owkz3IZn4cH4WUWdWpU69zlpO5H0DoF9xHfmjopG1s/PSF2ThvMSvXYPpbhAZ3CujCegOIEQfvVdU5AJmFglQaNJIapJtEqEKxZNi3I3WYjULj18CNcijJpMHQVE+lyZ39QwKFbMZKcrZYi8ijpUDTERMw7DHlXUASYYGpp7assrf22xl1bCspFsJits5s0I/VX0jJbdfOlMW23UNcI1iC7YTsUL5Qld/4pqTuEeWlxp1SNKzmT57Pm3c3wvkLQZfvDzcE07hC63zvn4UswaECNxLI7vcyc2SSX2Oh1dl3hyJrH4r18HmjDAdvh6P3CziaScnmW02D4JkBLEjTYfxYgLohFFhRvjN6wsKIG54M8jAscilZvH2WCHMlRUAXLM3BDvC7f7ohT43Di87hKxTk8XQGHJnbBzOBxmG8i+hq759vo69d/YD16BQ7X8hQVzrazUI4jfYTr5j9GX9YpYiMEHm5P++ADHcad7kKx3vXhDQsV5XWPQZkbu86KnutwYhflrBvsvo4QnHaTX3HTzS9eTvoQisU5Pq7X5EOkQ4Rrn2XR+37OVnVXIfn00geObNpNMkeZ9TNdMbDbFjc+H/KBGQVInZooZXcTrW7x2mT+g2V9tQiurZv7nT7aQf+su3CtpQ
 HFBi1mOh
 ZXVJNmTgczoY6GII38gssqacWWyiM4Fzrw/Tdh1go7zB3TdGWhYjydKbXiYtQgnDr1Foi8iSvc2/XPe3mH8dw0IS2z2DAYeevn6m1div1xsqIS9A7dwhjNo13cPTAWlYoH1ZJKNPDqD0zd68psiVPQ6KNN+xzx0dBRa9bSQYMAzl/OyEX0PuJVIyxCdjFl77ZliLc2y39uAoMcLX5Ma3VsCYsi9GvMHtMWdFjz39MkKoK2+PNxeyY+RJ9QZCdrADBo9nm7pYSvhe19vruE9OHYZtY6sTAitK1JfoG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 01:17:37PM +0100, Lorenzo Stoakes wrote:
> In general it's fine but I want more :) see below.

... and these functions all need kernel-doc.
Not sure where to suggest that it be added to the Documentation/
Thoughts?

