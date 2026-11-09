Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A2C7606A330
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 16:21:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 815FE6B05B9; Mon,  9 Nov 2026 11:21:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C6F06B05BB; Mon,  9 Nov 2026 11:21:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B4FB6B05BD; Mon,  9 Nov 2026 11:21:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 46B226B05B9
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 11:21:58 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 12E2416072C
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 16:21:56 +0000 (UTC)
X-FDA: 85416097032.25.02AAD64
Received: from spam01.hygon.cn (unknown [101.204.27.37])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1B47C2000B
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 16:21:49 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of qiuzhiteng@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=qiuzhiteng@hygon.cn;
	dmarc=pass (policy=none) header.from=hygon.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794241314;
	b=ZHuvDq9q7J9wzfA0YmN2+gZzwPhkcY2OAp0jfWoY1E0cbtW60B2XiTcAQGJvO1WIlJ/doF
	FNRajqapPS7cBGKlXTfg771wXrY1tuQTGMAjJTCAHp/M6d1nu8vIGvsGGEPmca5Iw+uXN9
	kCnzVF6ecXvqEhRaWQVmWq5TMzk93nU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of qiuzhiteng@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=qiuzhiteng@hygon.cn;
	dmarc=pass (policy=none) header.from=hygon.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794241314;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vlZurDDigGHjYkkA/PXHS60MT5TGboV/T4DV42PDNWY=;
	b=l0yA3BgY9RdjRqYCY8phbQjlWk1JfsB++5qdJQfqy2aqjt/SWl/z8Bynnfm0R8HcTe99Lm
	mwYCAkKRUapWOqS035yAdBAT2Wo1LYy7OSvULsCLYPeL9vwL0+monCfZRNn/R1us4uNHTM
	hxaufqbCXcvT7SQv/GhP/XH1TRz9XPk=
Received: from maildlp2.hygon.cn (unknown [127.0.0.1])
	by spam01.hygon.cn (Postfix) with ESMTP id 4jNZmR4N3QzB98Xp;
	Tue, 10 Nov 2026 00:21:43 +0800 (CST)
Received: from maildlp2.hygon.cn (unknown [172.23.18.61])
	by spam01.hygon.cn (Postfix) with ESMTP id 4jNZmP54n0zB98Xp;
	Tue, 10 Nov 2026 00:21:41 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp2.hygon.cn (Postfix) with ESMTPS id C5AEC30A6439;
	Tue, 10 Nov 2026 00:20:57 +0800 (CST)
Received: from ws.local (172.25.64.90) by cncheex04.Hygon.cn (172.23.18.114)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Tue, 10 Nov
 2026 00:21:42 +0800
From: Zhiteng Qiu <qiuzhiteng@hygon.cn>
To: David Hildenbrand <david@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Ying Huang
	<ying.huang@linux.alibaba.com>, Zi Yan <ziy@nvidia.com>, Matthew Brost
	<matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul
 Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, Alistair Popple
	<apopple@nvidia.com>, Xin Hao <xhao@linux.alibaba.com>, Dave Hansen
	<dave.hansen@linux.intel.com>, Yuan Zhong <zhongyuan@hygon.cn>, Shifei Ge
	<geshifei@hygon.cn>, Jianyong Wu <wujianyong@hygon.cn>, Shijie Huang
	<huangsj@hygon.cn>, Yibin Liu <liuyibin@hygon.cn>, Fengyu Wang
	<wangfengyu@hygon.cn>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] mm/migrate: don't batch the TLB flush when there is
 nothing to batch
Date: Tue, 10 Nov 2026 00:18:16 +0800
Message-ID: <20261110001816.2186986-1-qiuzhiteng@hygon.cn>
In-Reply-To: <ef12d685-d111-4a6f-b72a-77bbd1369548@kernel.org>
References: <20261106041628.1177963-1-qiuzhiteng@hygon.cn>
 <20261107143456.1590658-1-qiuzhiteng@hygon.cn>
 <20261109122915.2150586-1-qiuzhiteng@hygon.cn>
 <ef12d685-d111-4a6f-b72a-77bbd1369548@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: cncheex05.Hygon.cn (172.23.18.115) To cncheex04.Hygon.cn
 (172.23.18.114)
X-Stat-Signature: df3qb56bqyewfg6h7697ytybethhnz9h
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1B47C2000B
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794241309-889616
X-HE-Meta: U2FsdGVkX19AnzRwjqoDRm/SyqQCdqSP12uu7un90Dfz5F9KQAi2GkxBBW6DeKXyw++pdUyb+9hl9RUypJ3zclt+Iw9gpNmW7H46HzwUGNKz3KiA1rIBjmPpCjrMTfEQURmuG7bPbqIXUGBf/oxvl665qFNXQQIdFBwbaqVQOv1imUgudQhjLssUI79OERCC0bkv0GFugVZ4sW4AJMs6L8BJM2ofDgn/iNqdOrRenzhrrMbIgcHqY4gqq7faAaWGjWeTsgmkWxHbENSei9s7/l17Q94vAsmlUCa8Xu1gy/fKoLyV1QRCQq8AXHATpkCDAc/M+cJJU36APx3R8C6KDZdtocbJw+HG9bdIKDYQqrm+X3Qwd/094LJqpZOELmECSEcslRcjk3tP9fnWUof42MHGJQadpHNORMby75lPoptUOquepJLgMJv+Gllkc1MMnQeXUsu73NvIA0rB1C65ghOaPY4SdlbTD6GMWUPGaPX6+iWK6M0MEVtW+gWKp130kFxv9IOudwEUaD3ouIWQ7oYjd18pZDqH0Kg5p5lPYbmu/WTA2liSI+0YZ58AmJtMsxqx2BNvRKerQ0lN7X3c1QE5X0HwnpiuniZL+QfdQMj3577+a/lMmJg0U3E2pChTHTepBmT7FwFvG3YXmspzk2h2o5DCFc6+1g9MBI+5CSHnnEHdfp5sZXoocaYxYng8Rs491o7cVKqD3rRozDTWMBJmaFv4xXdo+8Vh0zOxavPlwc6To2rXIwnTxbLW81OyvfNvUi6Npi9pmuYs4/LCWj1zuwIUD8M9gu3pizUZGVtuprX8hYjrI9XjfOprK278e8rC5qxury4sV/CQQR/K9bPS6zfYOPqYjR5N64inCTbIQf9Izvpca1l2tjr3jap95cpT0ig2mErid7P/tc6HNNpwei1mYqScSiClSNz2hBXqbfoLFCQLZtcQ078C/4sl9waBb0mUDUmY2zDR6fK
 Qciix0lM
 2/umFKrpFP1536Zzh/qoZLVCu+CzQTzztosLEX3Pb7bx34/Ht/bmUzN9Ql4nkFkKnPfc6LOO911IHbv8gxNqeXTNF5ctqWgn4mQXWMcqCXC6dAR9mkBhgq0gf1jWmQwBKRTjVw+jlaFn0wTmZJZs59Kh+V8oOn/tLlKFuEcBZf5bZga8pAvwDhrkjMKbcNpqCE7/kMniQbJ7G6U3Oj6ydHu+RDtxbRh13i4tpBtQHAcnAYL6skLYDmtsun1y/vLJXhRba310np4zCSbuBBtG53RmBpg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/9/26 14:07, David Hildenbrand (Arm) wrote:
> For the future, please don't send new revisions in reply to old revisions.

Sorry about that. I'll send the next revision as a new thread.

> Is there no way to avoid that boolean?

[...]

> This is all information the caller could provide, and the caller could just
> provide the TTU flag then instead of passing a new "bool".
>
> Also, likely this check can be put into a separate helper function.

Agreed. I'll move the decision into a helper called from
migrate_pages_batch() and pass the resulting flags to
migrate_folio_unmap().

> I am not quite happy about the folio_mapcount() check, though: as soon as we
> optimize try_to_unmap() to batch better for large folios, it would be just plain
> wrong.

That makes sense. A large folio's mapcount alone would not tell us
how many separate flushes are needed once its PTEs can be handled
in a batch.

Would it make sense to restrict the optimization to a single,
singly mapped small folio and keep batching for all large folios,
as in the scope of v2? The changelog performance numbers were
measured with the v2 check. Or do you have a different direction
in mind?

Moving the check to the caller would read the mapcount before
locking the folio. My understanding is that a concurrent change
could only affect which flush path is chosen, and both paths are
correct. Please let me know if I'm missing a concurrency concern.

Ying, since you suggested using folio_mapcount(), would you be
comfortable with limiting the optimization to small folios?

Zi, limiting it to small folios would also bring back
folio_maybe_mapped_shared(), as you suggested on v2, and I'll
shorten the comment there too. Sorry for not answering your review
of v2 before sending v3.

Thanks,
Zhiteng


