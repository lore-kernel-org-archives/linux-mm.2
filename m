Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1D0FC88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 22:26:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7EC96B0092; Tue, 15 Sep 2026 18:26:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E30CA6B0093; Tue, 15 Sep 2026 18:26:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D47086B0095; Tue, 15 Sep 2026 18:26:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B39316B0092
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 18:26:49 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B645A1A0589
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 22:26:48 +0000 (UTC)
X-FDA: 85217432496.27.B77F552
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	by imf27.hostedemail.com (Postfix) with ESMTP id 933B34000B
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 22:26:45 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=VVeBrPjA;
	spf=pass (imf27.hostedemail.com: domain of xialonglong2025@163.com designates 117.135.210.2 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789511207;
	b=Jy/lq2RwcpwTn2zF+1AZ06EzjlMfDkTsQLTWdItl82GtDP1r+qN1eaAA6AYd4WWz3ufbtu
	9ZEQQeozxcOv3yqTYhS2Hel8LpyvJxuHHDPPEOTVArLQSO2Jx30CZt5ET1tT8ya4896YVQ
	+tgQdOb0uLUoZGgvjNXEFPwPtiaqFm0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=VVeBrPjA;
	spf=pass (imf27.hostedemail.com: domain of xialonglong2025@163.com designates 117.135.210.2 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789511207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bmYgvLBj+2fhN6x9AYnMb/kQHcFNBrYAQBS80G1+HZk=;
	b=BGVwFqFRbPf/tlCQTU2fFgz6XSMQaR8EslmXnmUWFF33yeQH/jOV9kSajZBSqTB7EV7Ci+
	gjKtxA5flHLNCurIP05Y8B9nS+9wMlAftE0X3j7f9GVfDZtnrqo5gNJfvqy2tvmC0UA/n4
	8B7DxpjfguiZrghjA1AC3mjxSy7vMrM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=bm
	YgvLBj+2fhN6x9AYnMb/kQHcFNBrYAQBS80G1+HZk=; b=VVeBrPjADv8axBo0bk
	jPpFYmA817kRL1EPemb5uHEuQBMSQvgOiQdkvMbtghKXYsFvo6JUYuN0p36YiL1u
	CJ+HOCuucVWVTVtqIDoSR4gcQs26wmEX/PTKuWLGhN0C5uPm1NAuQj3IOwoCe8/h
	jVS6KMzV3FGmkMh7bZyzYNe7k=
Received: from VM-0-3-ubuntu.. (unknown [])
	by gzga-smtp-mtada-g0-3 (Coremail) with SMTP id _____wDnt0z6xalq3CS+Aw--.61588S2;
	Wed, 16 Sep 2026 06:26:03 +0800 (CST)
From: Longlong Xia <xialonglong2025@163.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: Longlong Xia <xialonglong2025@163.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	Longlong Xia <xialonglong@kylinos.cn>,
	David Hildenbrand <david@kernel.org>,
	Xu Xin <xu.xin@linux.dev>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/14] mm/ksm: merge-path cleanups and folio conversion
Date: Wed, 16 Sep 2026 06:25:43 +0800
Message-ID: <20260915222545.5683-1-xialonglong2025@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <aql2wPergPKdfzU8@casper.infradead.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDnt0z6xalq3CS+Aw--.61588S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjTRQ_-BUUUUU
X-CM-SenderInfo: x0ldz0pqjo00rjsqjki6rwjhhfrp/xtbC3Bu0rWqpxfthtAAA32
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 933B34000B
X-Stat-Signature: 1ho4aak19c3mnc3yckyefseth8pfozwg
X-Rspam-User: 
X-HE-Tag: 1789511205-913689
X-HE-Meta: U2FsdGVkX1+l0pUHfTA3Eumq1sRstK0JLSUIHu/52msV2aM6VNqfA5u6z1SfvS+8qObJY+MSxWqR8W9aFg4TF3vOZrvl5Cowi3KTg5xywgQo0IkaQXPD1rVk26CvuRIhanC3LPcpWGWjPmhFbgiCRMHxEC2G8otS5FuJvLL+31f5omi4WLyny6IgSxN2kZIKgRqVLWlB0YMawlTrZ2W041BWDOlpWBCJ3d3Vm7oil5LucfZwpp1BOsPYsFZQcVNYOda+8hTdbncqwug7d5GNbJkX6Rtvsf/yVlPGIzMzIgcX3qy9HJOeo7NqgtJTvaGWRB2F0zZVs6M//GhkumqaZggxhLmSbT1RrBK+uzd24AOZa6K8R055v8KM38G9sg6J42brlTjNnhXr66YEFMQdwQTQn8Swwu3jWulJUME0bylDNies86y7oskj093PQg8vpDUcHMiJLFX0vZOr8gceGTvQMU1jJAw3uzTM7pCSd0z8HtKkki5USf9tp6fKCTpo361j7NsqW45BF0tc4L1+sO7B1UCYFAztlhj6fomFFtrGEDvAQSmHCHpdGKPamcIm+TvXMeZBaaGUvKodKLcpIPT8oGg8pwFCj/LRNTrVV7yB//9fr+9GfJpo6n0JYU88makjWWMQNUOj/+nAyX4Ymem420dq9WX1C9ODoUkXg0guFOdKRANLSD8HbWWE31Gr1xZPs6G+P+RAA0/QZWvTQk3H6V1JhJInTbDoKVp6KwjPsGbLh/MbyZnLhHT2O9HKvv3t4FlQugwfgOkN7/MrQXABeqvXIFxe579e+wAWTbz4m/RK6Loftsj28DwTTEm4RnApsfb/PwrRtDncKqrR5ziucsTXc2XYlOLCDXfEUGkFiNtv/O94t4mh+QcoL/mrolC/BtAKab563ZltNe/KIdsmPyy20RHWe2cxEnBAnl97k5xKfnoDpQ2fZnBLvIlDYJfxW9o+iYmrsw8LoQF
 ryl9d7kg
 qwQmWUn7kkDhcVqRzPOAzgpnvC7wmIHP030jtH57vXiYEjetyH+LCM2PMzAOQv23RSM7Pr3leFQ+SFm7rQyyN3ZUc4P1UkxrvOh8ysxiwz+rM5W3tBnWTHnJEOGRrivaxKCP5y95+qVlJB65EdMObvcE0QIZ1hJpdK5VGBTH8CJHtK5revwaDOr3fSZjDVAflvbItr0cEsgKU/BLCL+AqYAu+wCj4EHu6Q+DaCqiWJaLHulkZUKTFkFZWEy8FV0ZTUO75GupknC2OLhQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks for the review. You are right that I did not justify the
page/folio boundary clearly enough.

Patches 11-13 only avoid converting the target page back to a folio and
provide no functional or performance benefit by themselves.

I will separate the independent cleanups and drop or rework 11-13 after
getting guidance from the KSM maintainers. I also found a NULL/bisectability
issue in v1 patch 12, which I will fix before any follow-up.

Thanks,
Longlong


