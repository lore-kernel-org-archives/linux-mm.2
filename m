Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E63CC88E5C
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 02:12:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35E1B6B0092; Sun, 13 Sep 2026 22:12:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30F8E6B0093; Sun, 13 Sep 2026 22:12:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 224726B0095; Sun, 13 Sep 2026 22:12:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F30566B0092
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 22:12:39 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B92171C3542
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 02:12:38 +0000 (UTC)
X-FDA: 85210743996.01.EC1E183
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3C7551C0006
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 02:12:35 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=U7JzSLSU;
	spf=pass (imf20.hostedemail.com: domain of xialonglong2025@163.com designates 117.135.210.4 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789351957;
	b=hJn1JwZ0dMHSS5mgd7tBEVVFQ3UjhZF1H6LnHb6iYdvzlF59/4w6WuPPwQGftdEyQ/4VnF
	+pNoCnepPGVQG9sFT/e8LJiL7bBYCTc0j/wAgelo9lqYxK7jpVeOBxb/siiL8jd0fMv//v
	aiDWzEEBRV5NG1FAwO/k+enw5Zhh8AQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=U7JzSLSU;
	spf=pass (imf20.hostedemail.com: domain of xialonglong2025@163.com designates 117.135.210.4 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789351957;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sdeYl8h25y043VDoiD5U1hUo6wVwRXOrX4A5k54W6Ec=;
	b=K/WdI1NcthHflzzPeb/8i2A6M9NLNVprjZxNbDwZOQ+6ryLC099Gn+KkMlkPt0f7hXLSL7
	o2hfBJ4PTYKGObygPHM9nuL6XNifikO8QqseBh4krOiCyRQtfeSPl5dNvcAJhN0wmatfIU
	tGolEPkw06MGk97pd0jtE7OZW1U6G6M=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=sd
	eYl8h25y043VDoiD5U1hUo6wVwRXOrX4A5k54W6Ec=; b=U7JzSLSUVAR6Ib/xOM
	k8/ua1exxaDxhbalFvh312C0n8AZ/OvtFAFBS50f3OMIj1ECawsqF8StD6tcrbNs
	Pl8q0X40oOtnTj7XiqHWyA1d2QzGox2MFwsiSK2RzOuqlRxgBIZzMRgkCfWIbfvd
	RTh6M9pys4DYwZ2W1wNcsTDh8=
Received: from VM-0-3-ubuntu.. (unknown [])
	by gzsmtp1 (Coremail) with SMTP id PCgvCgC3H5P+V6dqrpMqPA--.35395S2;
	Mon, 14 Sep 2026 10:12:15 +0800 (CST)
From: Longlong Xia <xialonglong2025@163.com>
To: xu.xin16@zte.com.cn
Cc: Longlong Xia <xialonglong2025@163.com>,
	david@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	vbabka@kernel.org,
	baohua@kernel.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	xialonglong@kylinos.cn
Subject: Re: [PATCH 4/4] mm/ksm: add find_mergeable_vma_locked() to use per-VMA locking
Date: Mon, 14 Sep 2026 10:09:42 +0800
Message-ID: <20260914020944.664339-1-xialonglong2025@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260911161333316ISAQaj9yJhmglKT5A9OnK@zte.com.cn>
References: <20260911160421076_KNXun8Mpp9Xj7fxHG0i7@zte.com.cn> <20260911161333316ISAQaj9yJhmglKT5A9OnK@zte.com.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PCgvCgC3H5P+V6dqrpMqPA--.35395S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7Wr1xKr1fJFWDJFWUAF4Dtwb_yoW3urXEkr
	ykCrn7G348AF4jkFsagr13uwn2ga4vy3W8J3yUtr1a934IvFy7uFs3ta45uFnxWayvvrZx
	KwnIqr4q9rn7ujkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7VUbiiSDUUUUU==
X-CM-SenderInfo: x0ldz0pqjo00rjsqjki6rwjhhfrp/xtbC2wCak2qnWAA6egAA3H
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3C7551C0006
X-Stat-Signature: xg4yc59heepapr8bber5izem1esxrjqo
X-HE-Tag: 1789351955-774613
X-HE-Meta: U2FsdGVkX1/bztlyCSzFq33eobRAa/nQSSivp0r/yeY7XV2IOBtNiVIs0pNmGua+6nMu8KiW81G5VisSNSvkvp3Sv+BKNeG1eBVgOryKpizNaalrNeSE+I6wmlp66ZXLZg3ID1Nx9VdOHG111ELCkVbCp7dL1+RUaSxOLhcfLPMF8keA5wcMEptC37hm6x+LOdGoTCTDfjp/rShIEZQ8wZDI8Q/+pkXqYh5GvSwSnblVufE9YSmq+QhZzxJpZRhOGtW8gAYP7SqGbTJvURKfw6QKCb34JAb8mo3bZy151xbW9UAHvXXYwCqztYt/f86rKOMITo6Dr6rfnhzhFGvY7r8mJp1xVeEYyJw/yY12vHLYj86shYhgrkXoLuZCqCLlHDMvswheU8BpaM2DmpNJ+mT7h35S7qCvLP5jR4J+t+NZBV8aOMDkhU6TbpMF8Cb2UfMPvSOi1L2Rn0RbEitDoALuUg6sNaJhTqm6AvNPb4W+HF7oGqgorMI9ieBHvAczWuQaJQhUDcm7aKkVDJlAUVjbpSi7tD+vzK04f5qFAuclj20ORw5UOUy/owmwsERuCrAk4kzRFK9wGlMOEVpraA/KXqTyWcaVa0RPn0k2R7iETfydLn4d//bxUZZldGJrApDYvAYPuIlyGGr18ipjtrnFS8svV0q57cWl/+JdG5WvUxdCbswt602ckTeS/YlpqYaqkJSz2UNi31K2LD5OcSY9JnMiZuBPYUkBJnu+gGBTmgQSyuCZPuCYMeIXxEiehsvqD35Aw0BJXiPq4/88LOlYiqEhkh5k49oPIAtxjC/puM4yL0KK+lrQE5L32ILyyCpzpSzfUtZvMwh4eYZZ0a6/lUIGg4R3O5aRHaTJ0rGWTQljRRy6GP/HosdrRPwaDbmVS+oPUJ9Zmc5DFq+MSECcfRhjPVUG1WumVYGU/eFvEik2c+wfOmZoh5n6cayh6n059WpprWmc2b+l3WF
 mq6PHsjo
 lbOsXUkrruiXLeE6HySGveyKpX9DbCs8FpZvHUaAVJRWj3PEnghg1a9m+aT/xx+Xf7NIWaNiNUGw2B8Gpx6Fuh40YJkhieBcGA9sl6noi04e0AtIfYurDIdcDWfjjKGvhZ36ESQCWIIBCqDsh2hmEsuxrWz87SPXOA16sNxqSWgtbEaFm1tJNRYo8DD9PuKzHzIlaT7ELomsdSlwEitDfh1DlFiiyOkpxAqM5ZviFCHj3lvnvEiA1fXY/G2oiPsLGlhzYweqblKUIrofuUs+xiO/+gpj19PJhiKf2cCywk97BugItyvrK+6WQwAWyfS1zGfjr48DTjA8Hkle1T7/oHNZzFg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Xin,

Thanks for working on this.

Patch 4 addresses the mmap_lock contention problem in
get_mergeable_page() that I reported in [1]. In that thread, David
suggested switching to per-VMA locking [2].

Could you please consider adding the following tags to the commit
message of patch 4/4 in the next revision?

Reported-by: Longlong Xia <xialonglong@kylinos.cn>
Suggested-by: David Hildenbrand <david@kernel.org>

It would also be helpful to reference the original discussion in the
commit message.

[1] https://lore.kernel.org/all/20260909023507.1408925-1-xialonglong2025@163.com/
[2] https://lore.kernel.org/all/91cf8129-d705-4ebd-b420-129bab7ed261@kernel.org/

If you think these tags are not appropriate, please feel free to
ignore this suggestion.

Thanks,
Longlong


