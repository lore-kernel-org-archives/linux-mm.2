Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F332C5AC67
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 02:36:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCBC56B0088; Tue, 11 Aug 2026 22:36:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA4186B0093; Tue, 11 Aug 2026 22:36:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB9836B0095; Tue, 11 Aug 2026 22:36:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A60476B0088
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 22:36:04 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3020F80296
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 02:36:04 +0000 (UTC)
X-FDA: 85091052648.19.35D3346
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	by imf30.hostedemail.com (Postfix) with ESMTP id C9CEE80004
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 02:36:00 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=ARchWuSN;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf30.hostedemail.com: domain of sh_def@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=sh_def@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786502162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E48rZGlJpEk2yaQSzI9zGHJcjap4/8TJxtr1yxQ2/gc=;
	b=GXFOxN26FYBD3p2e7Z3T/leLp4+15UnAadlKgS7aHobDcZCRDsdWmvi2g+Ftm8aNUavdTt
	SnAylg4JufZxTXtJ7Gre3XRmfWSQe0WLnt1XARGiDmtml+MK7W9jQKpimsaQH8pdCMzqvP
	qqeTO9irvAErFPGiK4ZTNPdxJZxUBvY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=ARchWuSN;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf30.hostedemail.com: domain of sh_def@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=sh_def@163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786502162;
	b=ordLWnBMfyECSFvkbq7ET1B5kH0wIwPX+TLO4guvSsfG49tNTidVDOEaSuybMNuO8ceEO+
	THu7vx38S0lnMgvGwhfWmzaLg04KFhzk+uecrqEpV6BIm2lYl8dSfZVUcP+nlgWMJwakFV
	Z/nv7dAXFUB0Bup5ndy67R4fILaDiPA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=E4
	8rZGlJpEk2yaQSzI9zGHJcjap4/8TJxtr1yxQ2/gc=; b=ARchWuSNwdfkWAW2QR
	tJYuU2WAYaKaGWuuc40APKEZ5fNTzTFIXZqKkLuRjKBqroKU26F8faeW9HImicA6
	Uzg6ZpwkWE35ZM4x6M/kG30vaHbfPqUa8qTfC6olbQOKwqDKeTT8Ez8e3hRKXn2J
	A/c1zLB2K7OSVGf0tPMFRP4Fo=
Received: from localhost (unknown [])
	by gzsmtp3 (Coremail) with SMTP id PigvCgD3vw_s23tqtHd3Mg--.32002S2;
	Wed, 12 Aug 2026 10:35:25 +0800 (CST)
From: Hui Su <sh_def@163.com>
To: akpm@linux-foundation.org
Cc: ryabinin.a.a@gmail.com,
	glider@google.com,
	andreyknvl@gmail.com,
	dvyukov@google.com,
	vincenzo.frascino@arm.com,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	sashiko-bot@kernel.org
Subject: Re: [PATCH] kasan: fix quarantine_size accounting during cache removal
Date: Wed, 12 Aug 2026 10:34:42 +0800
Message-ID: <20260812023441.2067480-2-sh_def@163.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260811182914.ed2cba4ef1a8a88335b9edab@linux-foundation.org>
References: <20260811182914.ed2cba4ef1a8a88335b9edab@linux-foundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PigvCgD3vw_s23tqtHd3Mg--.32002S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7WrWDur4DZF1kuryrCFyUKFg_yoW8AF43pa
	y7Jw13Cw1ktryxGFn7W3WrWr1rKrWrJas8J34furna9F1rGw1IqryfKrWjvFy3urs8XF4j
	qa4DGrn5CFy5GaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07Uov3nUUUUU=
X-Originating-IP: [183.192.100.171]
X-CM-SenderInfo: xvkbvvri6rljoofrz/xtbCwg+rC2p72+-PcgAA31
X-Rspam-User: 
X-Stat-Signature: oyhnaib7zsh1t1oft6mymy3r5enirjtc
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C9CEE80004
X-HE-Tag: 1786502160-364253
X-HE-Meta: U2FsdGVkX1/iqaw4N0pRDR13v2pcp/EaoWzo4dZPzlVxe0NZLfZwY/PQZgXqxjZSJC0Vr5wBHZCjXWyz6GKnTgDxik/JhMIlB5DEP0GVdFN1Py0gPDJmL5sxzHY3YxDSjkswuddlP8cTui7z5+3xnas0Ng9RPAIt9xYgJMGTKwUykTfQ2eqP9XbQ8Stif18wfdLrXYMD+T0T2VbIZzjAbdJjR0gaqFrKOXAzrRy1xt6Fp8OpepqXUKQSlPo/bBt/1ndWiX7IULCTSKXkLCUs0hKZJmc9NV2HsW6ddbSWxO9urBWfX0JX/cpNJS473g7PlVTbb45JrXmB8nEJ+o57MGDSDZdbvDmjFccBvhMlIgGAbCcI+Jyat03pAUVxvrSj6tr9+mYJ/E9m05pLyrEbUCl/hLw1qrB7SvGZBFByNssFzcTLt0o6Tnqv4rG5hVkqLiHiN90fhWIlPZw9Y94yDiup2h+7fFmHhbhlQWNhMW3vjY3+DZQ+LNo6Jb2N2hyqvHKD4x9EnKL7XnRUsd7Atu61sOJfHu/EBMHppZL7a9OtCKhZHDwMebEwBXplmA0E9vJb1s3faPq+fWDKBeHwTBTLhFre+c69zZpCi5DwgNSEDZbACjH6xJERqsiXqAj1ZG4643uuLjY9fLHkqk/qk+PJRqoGej6Bk4q7k6anJRi5Ph9NOEfqoQg8QvGRmjI3+bcNYd8jAYma8Z1qC3Z8rJdqyrR5ky01VLRteMtyfHTPjPN2Xex5KtRlmxltRz4BYw6zlX2q4mONgkR5c8KVK4Mm4zt7xItPOA/uCgV9+PxH62sOdoe00VwhLsYLxa2Aeg4oGKKCWc9/toT+1bbKt0ztjxZ1kb733uSu5+wQ6Diqwie+3CDptZyYyjtoh/McZYaF+NS4CBcj1sSir43cm6IukPRsuI7rxgFYN3gPlnvf0vBPgxfx4OyjOltSuA5abiKFkzueeCLoQgPd3kS
 jJUTWYUG
 XvgVZhZeaKdshmuhU5P0rPHgz80YGwL4nIXeBO36YON2vOuZl5Txa8ZTRaFv6+4HGNXPG4nR2CVa4S7WFo9hBYhT8C466rAM1bQ/mXW4zmtCPauB0q22BkfeONAjmlIpmEKVHmjimud2V8m8er/r23LRSTOU0iGezarN4BTgbwENb4MJ7p5eWdo5/wuHuJYXc8UzPkPqk8SJDzmp8BZQvrRDPd2ac+dZP8PGFDZrTPVNgrto9Hu0kzAC5BpxmHlfFdlkN7phDz7/ARThMJo+wbAmBqPtc4VrP/w98skQ3WEkvah+d+IQODe+GF07UQtpixuW2DO9sAXQ5wB29k7Y25ywOv6WVg0JCIoQqIVa7IOrZy/Wigcx+v+JBNF5AvPQ0F9vbk2O4lNJTEqg9/rCLGKw0OSmyCNY8ENtlfFaeK67fR5IK4v/DgfD6xvrAcDrRoCrfS5oz554IAdjpZtL5HWyy5wlBaNU1YoAaaPGs8Dl8AZGbbWTR6vkdRU+pu3atqlhkUJzBnF9mcFVXIDK7ALLHLOYeEgnkn2aZNGmAIm7r9LfF6JGOXUrW6SfHXObL8ForpSWhvxH0gzWJ3wcJni1242xjvm12Bt3iWfaF6/k3yHU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > quarantine_size tracks the total number of bytes stored in
> > global_quarantine[]. It is incremented when per-CPU quarantine objects
> > are moved into the global quarantine and decremented when a global
> > batch is evicted by kasan_quarantine_reduce().
> >
> > kasan_quarantine_remove_cache() also removes objects from the global
> > quarantine. qlist_move_cache() rebuilds the source batch and updates
> > its .bytes field, but quarantine_size is not adjusted accordingly.
> >
> > As a result, quarantine_size remains over-counted by the size of the
> > removed objects. The stale accounting accumulates across cache removals.
> > Once the inflated value exceeds quarantine_max_size,
> > kasan_quarantine_reduce() can evict a batch even though the actual
> > number of bytes in global_quarantine[] is still below
> > quarantine_max_size, shortening the quarantine window.
> >
> > Fix the accounting by recording each batch's size before
> > qlist_move_cache() and subtracting the number of bytes actually removed
> > from quarantine_size while holding quarantine_lock.
> >
> > A KUnit reproducer used during testing observed the over-count grow by
> > 4698864 bytes after one kasan_quarantine_remove_cache() call with the
> > fix reverted. With this change applied, the over-count did not grow.
> >
> 
> Thanks.
> 
> > @@ -365,9 +365,14 @@ void kasan_quarantine_remove_cache(struct kmem_cache *cache)
> 
> Sashiko might have found an unrelated pre-existing bug in here.
> 
> 	https://sashiko.dev/#/patchset/20260811073332.1351893-1-sh_def@163.com

Thanks for pointing this out.

The issue found by Sashiko was fixed by a previous patch:
https://lore.kernel.org/lkml/20260808031459.3032812-1-sh_def@163.com/


