Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D446606A31D
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 20:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=PKyab/Tx
Received: by kanga.kvack.org (Postfix)
	id 650B16B07B9; Wed, 21 Oct 2026 16:59:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 627F96B07BA; Wed, 21 Oct 2026 16:59:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5654C6B07BB; Wed, 21 Oct 2026 16:59:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2C2D26B07B9
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 16:59:21 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 921001606A2
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 20:59:20 +0000 (UTC)
X-FDA: 85347848880.14.082F124
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by imf04.hostedemail.com (Postfix) with ESMTP id D6F8640008
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 20:59:18 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="PKyab/Tx";
	spf=pass (imf04.hostedemail.com: domain of 3pSfZagcKCLYjdqdqWjckkcha.Ykihejqt-iigrWYg.knc@flex--nhuhuan.bounces.google.com designates 74.125.82.200 as permitted sender) smtp.mailfrom=3pSfZagcKCLYjdqdqWjckkcha.Ykihejqt-iigrWYg.knc@flex--nhuhuan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792616358;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sc3hIjuqm2HqdSWjRIWRDLuVUuAq4OcILp/mjVvlhDk=;
	b=3U5lshhyshDZThBiNMSsTEGF5T6GTGDMFLKMf85D2BZboWTG4sHCY9feAPddH96qE8pLUN
	1cmzLA5aGHL+bIzwLrmmnuF753Ala4Z8NidNf7hi2R9NL133hp2XIc5VlLZ6Rk4Z6ajhlm
	UvrXYZh6TnlC8yDhqQyLhbtdQdSEbHM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="PKyab/Tx";
	spf=pass (imf04.hostedemail.com: domain of 3pSfZagcKCLYjdqdqWjckkcha.Ykihejqt-iigrWYg.knc@flex--nhuhuan.bounces.google.com designates 74.125.82.200 as permitted sender) smtp.mailfrom=3pSfZagcKCLYjdqdqWjckkcha.Ykihejqt-iigrWYg.knc@flex--nhuhuan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792616358;
	b=J6XSUC5yrbo3rGnabvAKi2cUaXGEKFqFSAA6iMK+ovz09XVS2nMViAcXEdyqBCeALl5lGC
	AvVHAPVBUtwH6XnRqckI8nmlsjueOWc5TD2cf4yuX5PUeI7yM15AvOydNPfXgCbly0hRGV
	Q3JHGhWlTl3j/me6zXqPfxj19Bjn5fQ=
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-341eff9e381so2904030eec.1
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 13:59:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792616358; x=1793221158; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sc3hIjuqm2HqdSWjRIWRDLuVUuAq4OcILp/mjVvlhDk=;
        b=PKyab/TxPAn/fzqUQ+huNzX59s7I4xBZJSNHZxSX5xJdyqGa7QL+3ExBaySDZwXCV4
         rq3tVtSTmGz3YKvPu3SSHTyQm4fNMGzYuHvDLTuWUhRN1mA3fdMtII7NRBLnmTzbkSQ6
         MDipXJE5EWKAy0ph8h92S4i1DItOi7OMCkHqUdN53Ai/wWDyzRi0nuNC3s9zlEBa/j8S
         rjZNZ0yh2ERewhaMHjF9fpoEeHI1VqWIJ0qFwAaUBobwMCL2ulZfl+f3qmS4YjBYTR+y
         AWE94h8SpbwdQziY4v4K7Fky5sWcdqUXxrKThXPcMzuudweevrrqAhfCWcgLchz4ZHu9
         zrXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792616358; x=1793221158;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sc3hIjuqm2HqdSWjRIWRDLuVUuAq4OcILp/mjVvlhDk=;
        b=zmQVSmWoeYsuXky1GEC1JXaG9rYMIem5snCSiHJtXnqZOBVRfCDT7AknvU53My+4s6
         JszXRVkmkQCzl7bnSZoKvf+Ge81lffoTbLLjL/qRvzlAPrD+eHEk2d1kXQ9wysuTGVwq
         Z+PYu+ZOjKdt5QOfbJ54/DGeCPd6oekB/kITqoqPb6mKe6RIrB+bLfVTNhT09pRJHN3C
         rzNRQ4NUXJH0pCrwF4YwX5KbLMrJlSPaWlXY4mTSh/1BfsYGa2ewosC9GmcbnoKoK1v/
         RLnxY0GyjzSSqqXRItULZFQqUjiFdbYrt4inwyBXWmAdtkRkAwQOC3VfqyoAfauEtWZA
         U9kQ==
X-Forwarded-Encrypted: i=1; AKwUvBw+pLtbjI7+GMOp+SEDVajRkJNzcAiuSQyxiiE8b5udXXfp7TYb90v2DJu7uw2PxjG4qG3Jr32HfA==@kvack.org
X-Gm-Message-State: AFq9FYKH8Ow/bhCO8K2WHzq6jqZuwbUaTJ3DBiVqF07O4s0XVcmuDLqR
	67H5OV0ax/rZTqLwgz6fgrv+prRLWGsuI2m9fgPnn4qMO/DE1WV0AZRhSQnpXlCeeqhajgSwD+9
	xekRDMSjr2A==
X-Received: from dlbdx6.prod.google.com ([2002:a05:7022:e06:b0:16c:bd18:1ee2])
 (user=nhuhuan job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7023:a8b:b0:143:72b1:9004
 with SMTP id a92af1059eb24-190a87a3b70mr4075424c88.45.1792616357026; Wed, 21
 Oct 2026 13:59:17 -0700 (PDT)
Date: Wed, 21 Oct 2026 13:59:16 -0700
In-Reply-To: <7e998cd5-57e0-432b-a8e0-676a5b773436@kernel.org>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <7e998cd5-57e0-432b-a8e0-676a5b773436@kernel.org>
X-Mailer: git-send-email 2.56.0.218.g1ec904b173-goog
Message-ID: <20261021205916.584370-1-nhuhuan@google.com>
Subject: Re: Path forward for Virtualized Swap?
From: Huan Nguyen <nhuhuan@google.com>
To: david@kernel.org
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, cgroups@vger.kernel.org, 
	chengming.zhou@linux.dev, chrisl@kernel.org, corbet@lwn.net, 
	gourry@gourry.net, hannes@cmpxchg.org, haowenchao22@gmail.com, 
	hughd@google.com, joshua.hahnjy@gmail.com, kernel-team@meta.com, 
	kunwu.chan@linux.dev, liam@infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, 
	mhocko@kernel.org, mkoutny@suse.com, muchun.song@linux.dev, nphamcs@gmail.com, 
	qi.zheng@linux.dev, riel@surriel.com, roman.gushchin@linux.dev, 
	rppt@kernel.org, ryncsn@gmail.com, shakeel.butt@linux.dev, 
	shikemeng@huaweicloud.com, skhan@linuxfoundation.org, surenb@google.com, 
	tj@kernel.org, vbabka@kernel.org, weixugc@google.com, yosry@kernel.org, 
	youngjun.park@lge.com, yuanchu@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D6F8640008
X-Stat-Signature: jdh7hiyhffrzyr5bjyncwocuo5uu38f5
X-Rspam-User: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792616358-370331
X-HE-Meta: U2FsdGVkX1+JVv/8FFYaWnApd2scgqFU15GH0O25QDlrJHqYsCH+29KjUkGWaa/KNW6gTCyiz1jILap/hBOxklT6XyUOcJHb02CFHg0ZMfZXtCdRv2o0VqA0Koaw6qI9R1dsvISyAywwjw4XeLY6Xucak5n6oeUwWA0sHItnHzeg1epcRmBKTQ04JEoQpIr7Vzb0Iix4hpqd+WMgPvdVJAVoc+NRppzfy8UoqIPVOgc6PrJ+SfSNC7NnluSK7JpnqSZbs/twmLqL5MmUvt315Zh0IQfliiYsUzsR3Nt/ANIFOx3Bssb+rDBJK2zm7RBmZEsOK+r7AXnf1m3ez3Yu/zc4JnvOdr+B6Ylkr6cnihpqOJbxNny/oSnt65C/hiFg68WjfZNk0IoEcH0kOXZ9cA1NqnHSj6bsuMOHDfv0iWj6FfWp9R1aPdrEoIwlUdQF2VGuy+rkoBIhXh7eydfBE6FLeguT+nmwJBUzU8syzhYe6Nc2MkfkB2bwKMF3coqwwrqorQS6Gd2dZV1AQF1Bsd146z0Q2IbSl7KxDghO6BrkPTUdD/aSyLiashkFxTnDLFzT1aYfq2rcEXw1zTpTz21TENISYtsRWxsyHw00VuAFuPFuvIind0ldocd6nutj6B2y0Ic7EG10SI+9B63msdW7vWtVz0CRXWmte/BsJVRP2iODbevkG1dS9CWs2NctyuwT5aFXfI6cwCm/I1HRx/C7OdDIFEOfnRSa6kVAN42xh7tdJs8oSBPkmu908QT1KXSr17FkVfObKek4vohDY8aPObDtWC5u9f1BjDhxI82OkzIYhFEONdg6yUkcqh9KkFXp51hVIti3+NYM06jKsSUu96EepAU/O03Sk4O9iONQWJ50fC2vkYgmwPEUQ8xctyXb2mHTVQRxAk7V+2BlNC6jaqYTzysd9NZLcwGInPNdBX5d9pVE/bU38SWinZfgNHd9SfMSU03XdLNWccE
 avrJFxRI
 JoupBv9xGF3be+uLLxt3o5mYg/3hToxu3+UIRA0lJOpTQJTskOxXdXYCO9lBF7KHaH9WQ9WyTgtn8XyAfij0M9DXekeQ8ckLDIbFW7s7I3vaKbXZ1mvnjQfE0FtRVV5P7XPpOJ+0EVvdCzDB4vu9AZB3JfaqcoGgrmwqOnEiCH7JdhxwOTh6/iJd+hApxzogj4Y/MRiwNPHU1ADLLbZJSk8wSDshIvVXuYkJbKPuM61l+zD3lrUh+CEBwXdxQCHZvjqWyYdTtExBgx9/ceGT+1dF0Eb+0S9vwKMt93JPCsB4y7DyHBgLIS8rg8dMqD2RZxaQkzK7TPt4hprPyMGWLVVBzHyyHpzyfwtKNkE8IumtQlRjPnkyCRDOo+G6wBgj0DND+ybEbI+pa3W2ZmyGri5sskr89XA1fgmSm7uLluf08a8foW36FaU/5hFPHTZNEDNezWunUTATlc3BYIUCjo1siI0/toAtaLdZBOWGjz0932nIrdPKGW1GhMC+OpdWK0/mNkjfOYq+0DdD6zJPcvbWJSnqDA7FZus5goD23zXENwl6sA9f0kOMoyyAHv9GHPgtfKHk1/fMdGluJbinmP4xXQg1I8sYb61E9kArPxbc3c28sNFsfXaAyj560ak5XUCNfVRyZOM5MJSq/rj/VkcoBol1jmZWIr6a3l8QjOTczl6hv3hGAK4xVZQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi David,

I'd like to join this discussion as well.
Could you please loop me in on the meeting invite?

Best,
Huan

