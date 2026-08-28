Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1D6AC61DB9
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 05:29:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18E986B0098; Fri, 28 Aug 2026 01:29:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16C0B6B0099; Fri, 28 Aug 2026 01:29:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 054BA6B009B; Fri, 28 Aug 2026 01:29:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DB29E6B0098
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 01:29:00 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4792680360
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 05:29:00 +0000 (UTC)
X-FDA: 85149549240.15.22D740C
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf26.hostedemail.com (Postfix) with ESMTP id 885D5140006
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 05:28:58 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YzzTl+M1;
	spf=pass (imf26.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787894938;
	b=ENINoZxYUo8RO3EUEanCZFT9AEpkQYj4nUjCmvM+phxwHVN79GxQK0rrDTE4sZ8t/NaZCt
	G/5XKSa0ybkFOvsOV00CkwC2Hop3F/Ubfnihlz/Nok1f+AMCpyJvWzwMlN4rRwjq/eMkaK
	9CphEkIQ8zENWvcfObCdLf2B7RCKKwE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YzzTl+M1;
	spf=pass (imf26.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787894938;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qL8bPsC0Bxb6J/ZsIWsNrLSKD39Bdrje+tlXzQLxk3M=;
	b=tS8R50Mrp73WE8fkNpjAMQ3MgGKMXlbMDsBJORkGs/y8NdCCC6vL1rjhZN5mE9t8H25i0H
	F2BzImekz89py8wYYvl87aBDkTcrU0o8Da1DicW0cAUCCdx09jHcqQIKvl0X43fJx2MHvW
	/0jaOzyRPxSC/l4OwhSnmsffrXpijfE=
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-39647aa9d52so644627a91.0
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 22:28:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787894937; x=1788499737; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qL8bPsC0Bxb6J/ZsIWsNrLSKD39Bdrje+tlXzQLxk3M=;
        b=YzzTl+M19/rRbJk4xXKUO5IyXyyaUjtRIUc5Ejnw9cxHdfF8X3KETXb185XHtfd/Wl
         aVsld6g2EcfsXRu/KNQUuTsipmKpwIpP3JUXoXuC0EcT+XFHxQx1G7bDhDCx8FOZailc
         h2Bzr2TvsXzOk4Y1MQVIB5gn0JDrIpzA5A4Z1dBBKFXRAeFhauKDaDKJADbYJ7W1ErSl
         1MAy+OXFWQbB1+DioPvuhOtgdo8ECPOIJcRTNO0+ktx/G1yIg9KIeXt71sUx7EGgKMyG
         X804SKtN4ZzIVp7HPeOvQGEFpw+Bdfl7jShd1PrdVo8GDnQl+qUDdfE59z41z3VNMHq8
         5zZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787894937; x=1788499737;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=qL8bPsC0Bxb6J/ZsIWsNrLSKD39Bdrje+tlXzQLxk3M=;
        b=Zgg+aWI3ehBJnt7Qy2jLyukgwFWlJ+CNcILV2U8xFooQRtmJLYB7A8cschkqiq8GwK
         Yj/nMjb+Q3JYjWD5hfvnF4Y4IaRVQ6gLig5MlU8ceUoAgAtG5AkET3X+16AFULWftgZk
         +yQQqnkLi4djIFfqW1hvFc3TmoM8b6qTHzmHVBI3bEYbqVYLWOh9+7/4lfMsyJj9E3YM
         CSZRP10/eK/jsNaBLa/RlMKSg2d7H3jdUtqIPYgT0N/fa78D64g5UumSRvxA8ph7QcqA
         4hHpg92VGbrV0FEAevgXYGn/o8WxxIEsarup22D5L0o2rCxJXWOXLpZr9cEBqKOstBqT
         xtIA==
X-Gm-Message-State: AFuF++kboT6J7uPQxrwjc0SAmQBPS5DoQJbn6joe4K5gqb2+9yEQAkdL
	UJkBvFtBCtyvAhWyHuH1jmhCFCAWYP+OiYVqVuyqvbE+7qpn90YrLDSO
X-Gm-Gg: AR+sD10/Uca0kHsONBaZis+TMA5e+lCG8GcxFVEDyreVr+sRdwWws0ebuqU5owK6APH
	xhR5mAerWLAWJeSN8eOCs97cHqFowRozqEcUtXF+677z8enweeeo1fD4WIU09R+3nUzIph+9Lxl
	tWQUce0CRBZFxWGqOlixQzzm0JPYR/FEi4p68U5wwIY3txCDtiOw3Gk6rQ/PNUiOBBTKkKR+ahM
	N0zYlaRXP3E8QKw4Xe46EhvHutK0VPdIkzIjIjzwqv/GTtR83Ne0ITr+1FstOA2xdjPzotO6+VO
	Bkd37E1rqWtW4uQpwpPJf57NTcbOeE3dN0WPmvy5/QppK4rrv7yntPulajoD2+t/KzNud8nnx5Q
	aWjpSqxThO2vRc0/HFmCsk6YT1xE2q6VGEJj64X5jmjcBfthw8Cq8Jb/B/MGflEbGW9Q30O/bvu
	yKc6IRECCiiZ/xvK+Swr/cUZMInsVKkyIPAYFhJ9KLJW7gDF5KZh6iySDQ9VCKrNreQJVSUUxfe
	EtsaJ/mEv2EsUMqXoF1mxl7eGlD
X-Received: by 2002:a17:90b:1a92:b0:384:927f:3db9 with SMTP id 98e67ed59e1d1-396d0d35e02mr4591519a91.1.1787894937355;
        Thu, 27 Aug 2026 22:28:57 -0700 (PDT)
Received: from localhost.localdomain (vmi2317720.contaboserver.net. [84.247.152.65])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-396dda7eb6bsm1070263a91.8.2026.08.27.22.28.47
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 27 Aug 2026 22:28:57 -0700 (PDT)
From: Lian Wang <lianux.mm@gmail.com>
To: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Cc: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Chris Li <chrisl@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ridong Chen <ridong.chen@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Yu Zhao <yuzhao@google.com>,
	Zi Yan <ziy@nvidia.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Kairui Song <ryncsn@gmail.com>,
	Kairui Song <kasong@tencent.com>
Subject: Re: [PATCH v3 4/6] mm/mglru: move max_seq read into walk_update_folio
Date: Fri, 28 Aug 2026 13:28:12 +0800
Message-ID: <20260828052834.52775-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260826-mglru-flags-cleanup-v3-4-d9f1c75549c8@tencent.com>
References: <20260826-mglru-flags-cleanup-v3-0-d9f1c75549c8@tencent.com> <20260826-mglru-flags-cleanup-v3-4-d9f1c75549c8@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 885D5140006
X-Stat-Signature: mxdr8nub7du9tcoxtrjg5uqr17gfazhu
X-HE-Tag: 1787894938-787502
X-HE-Meta: U2FsdGVkX19ZmdQXn47pU/+J8tSpISaIyhKAvajzg+wr+q5Zk2RzyDOZ9ljjv3dMvydev6hidadDEd/E7X3uCU/sNZr3FzVtH/XUJRN0fziBOxa6NDamfibg8gNk+bkLa4Cs0aEbEvF3Tq3vRnS9aT6/1dyRxHM4xu+n8j3xjE+4UsSKWKHw5WeZGa+mumJTx9ziBxJgHwdtH/ZzhpIh5BG2eI9IyUmAtU8MygtlJ+fxZYQBkZS5t6TIRCB6iVrkdy+2pyQuSAY/B/KGOzuRArVWDQusnYVdy/B7dEf+CkNGxhDgxrxnvEiE8WSM5eHlzWwZ8mHE/btmZRktW99TgddM7jBSFqsyIDTqvVKrXQKLjIejGUDhgO98kCPQIRuxCTwuQgnvOi2fkxYLXvwUjtlKl9ZFkkuY7LTLmjCXQKeati2/i4P8NUXsHt7EsMXkp5Wv20Cox9ZZUovf1BrFnVXFq77OZicWUaiBCYrYEHJLCwwYjL0/gdsiy5hNYREy66tNr3xiYtt+emHcKL4U/FGcz2hhJGXSQ6c0BESFlssvngogO/2hBZyf127Hu9BUU8QuhG1Hh2jwZ6JgnhlBzb9Dt3AZZQL0i3XKzDXrfoxvZ8TyZl4b5cURTdCa7J4xiH6hYH1gYzc9iaCa9zdBwHjR+f+tMl2ZxERtwJ6aI3D78Gn1H3SERKnRcCUYImI2pZTNvAZnYZ2SsbNpfNO72AR4qyeiyuNLxUCSvKZWSP/6UQl8vIAFXocSsdYLeJrA4bIdN+kqZLWMc3VHrsjGuqp0zAo0UumG5PMA2QbXNKJ7Db/DgZDHj8F6DN3fJEh2pxf8R2+PHQxhxO0O5jrz0FpXf/Dm6w5bzHc8yovX/H00wRTieK4lKxi35fjP/+5JhUASOuSCVvSPS56zJITYWg1pw0mxcvR7nFxMf7quzzF/bHi/XyWSOw5o1wVvpT3lhN2Q9DQXqgz3tUPHc8d
 h5tBRQ7F
 s2JCRzOyktdsKNTogtlHFJiWWK74VD6ltw2Tue1P/0oExnBBqdHrWYZMi/gqJ1iyBQCVuyuoBxhsGGj8EJ/t5BQ9Oxc6gpixyzqNxSQ1gfzx2alGC2hzREvWZfC8sC+gudwl3+lIpCdsAx31JvfEaXXm0n9zqIZ2yGY8bcvsAh67idK2IG6fTmDjEafviVzEe2pHMnSKsicyUq6r1tEIfNHmLQUOGaBJv8tEibEjfYlYBKcnlOqfK+bNSUAeydA5Efo/kM4gtMDVL/zmFkWvP/h3dNz593CTmlFBybDuHPqk0JL5Wy5fyXSWnxrbHk3bg4HTjFbwffu9D56+mFEr3N3tiDu/66bEvjhTeT1Erq/B4A1pRbdciRe2Y0MsvJG59Xi2LQ8dAJMSV0th4rvVm1brQ/ZQuhOjBBoPdcZd6+Y2NdrXiDmPE/sS018KtUbQ6NRehN6sp8MyVMBgKj15hsXIpcBWpidRhuG3mYwZ5+h/ZMbRvjbu0DPVPpnkoJTmCngLcQuKY51dyyqw/NOGCTCuCFZQJindtwl0gy105n3EfBEqFQK5UaWZldtaYGNgxcLahpLnd8nqXCsL/sepETdQQCRjiDlRIalCc1RGMw4abNK5APjQO/uL1ZPwElfPJq6qV/qhISjiYeLbu7hbHaQR6AA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> The max_seq read now happens once per folio update rather than once
> per walk range, so folios always get promoted to the current youngest
> generation.

Reviewed-by: Lian Wang <lianux.mm@gmail.com>

