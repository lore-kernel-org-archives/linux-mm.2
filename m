Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 529CDE83EE3
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 07:17:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AD116B0005; Wed,  4 Feb 2026 02:17:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55B186B0089; Wed,  4 Feb 2026 02:17:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43C796B008A; Wed,  4 Feb 2026 02:17:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2FC416B0005
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 02:17:18 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 954628C35C
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 07:17:17 +0000 (UTC)
X-FDA: 84405918114.11.241DA54
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id C3FED18000D
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 07:17:15 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="alX5ja/r";
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770189435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AAxmt40kl0VIpwi9JbEN/Ah5tUAvcuCP/zKdNUhvruY=;
	b=cQj/jq/uDcYQQdrOWHnYA99hbCz1Cc09kPrsJeMDxd00KkaMGXgQL3sJrS+N7/+8XE2myf
	w2EAl3ujaUIBp7p9NsfjFRBuz0oeilCs2sjSVBuo762ZqNjJXkc9wGk5tQZMBDYOg8qk2n
	J0cmwsTNwqUEBmdf/giTj1mB11A3dQA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="alX5ja/r";
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770189435; a=rsa-sha256;
	cv=none;
	b=n3j0s5cWS54C+Iuz1DYoKSU76JkuiPCP8EvQ94Hvl7yuUohoDWvZhkh31/EgdrXlIM6R7s
	5lC7tYpDCiz6MjX5KPlJstzM0Ip8vMgm+UOAJx0oTAtupMpxJPTo34IU0yr5Z2UUX7LeUB
	PtGGg1hT2wMos5B42WHkTikVFO7Yc3k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 92C8141766;
	Wed,  4 Feb 2026 07:17:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4028CC4CEF7;
	Wed,  4 Feb 2026 07:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770189434;
	bh=PbpHINPIxKlo9HPoQQXP6SMwz/+sggXsDbHwfHXEEkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=alX5ja/rxhvf5yBZcCNXHG6rAaG5VEkuC40wnmWvqMN6tM20LdqGLTogEH39uhSgK
	 H/Q9S7C8aF1gsQKYdz1rjlPs0uHp8T5ZY1vGAiHOEhZtXr3O3jM9ytNzuozft2XdPj
	 CFnhrg65NijjL3rspj1ZmBNWZzWV2ACtewNPl+b0+SXsRupHsfoLW1jd/c/dm9vmX7
	 Z96d40SD/Ob8bq89SOm6B2UEOncXijT9pARMFVg6wnaOLyw4sqAnFwSxtCEyuk5+vV
	 LpKs3AxRrLThnBl1CCr6m7V7lSwiF3Bc2jZXElLj9ZO6REzoVMBVZM03dkLzYR5dke
	 VQphjGTIq7o7Q==
From: SeongJae Park <sj@kernel.org>
To: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
Cc: SeongJae Park <sj@kernel.org>,
	artem.kuzin@huawei.com,
	stepanov.anatoly@huawei.com,
	wangkefeng.wang@huawei.com,
	yanquanmin1@huawei.com,
	zuoze1@huawei.com,
	damon@lists.linux.dev,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v1 0/4] mm/damon: Support hot application detections
Date: Tue,  3 Feb 2026 23:17:11 -0800
Message-ID: <20260204071712.16325-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <af4f3e15-a306-4728-b5bf-1deaa700c99b@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C3FED18000D
X-Stat-Signature: uw9mzbtg9uesirs5pots5ojmjg7x4bnm
X-Rspam-User: 
X-HE-Tag: 1770189435-864659
X-HE-Meta: U2FsdGVkX19yZ0c65JkTqGrHMBnG3GC1CoYKxtzz5KKzO6frLu3viuW+RW3ln8/MWjQyHhcLXeHd8p7tydwuR9KJn7DVwdHMPGKUG/W84NxEIHAmLM+NJkR1gRqO7fefnZZSKTH5gFdlCQ+w3GDt7O/MXoBa+bl72tf4D7YwvCEB/EW+sBAEXP32qU8ZGd+WdIWJSGOVQPCgg4qxXegJWXBpketBrADKXY+h2HUAaFSKtfPHz25VkQvwfJDI8uwD7iSh1AMaLIohrYgEZER/bBBbyqTE+S9gD6w58qMUEn0Ws9JBUImlzKf7gxk8l2yC3gcmnd2mGiWxKpQGhbw3NDiscm3pBjEe4Adr9Qf7YvdwiNOREa+CHCRxOQeOgs7Wf5JoukrEsjBnNFNNE1P6bIiZfSFpn3zWNMA94j0TeOa/KeIQ/QrIdzzLHEjWbWv434hGoozu7MiyKiztXcYjJ18Hrd+bJWCq6GDqL6ReIix90t9jlYycKKH4w7VcGO21SwTypWSm3GSKXDlgy2LyUtLoHQAsrcRw1x+G8hRjX3HpQZGT4XqDLuD0pihLilk7sHKO2+7qgrj7gYVIvVyx6hJKcK4GkWJawip32y1YXxv6aU6kqR+de1WIbdR7gam/qZQbHk7dbRnhKL0KoPi8aIgWhSZXVZVluCHZccArVOqxo+7X0Eq7wjkN0B8eYxF6dAy60jM5wJs62B6gD022zwYXTd7pFk4jVGvn2mL3w67sFJH1VUsZIDsybQ2O2IoRp2ZAopiGnZBAAZtOl4o3kIWIV+CNl7n2MskWNhmrSx1jpku5Cc2+DbzdOjcqrH6h4e8CVXsjXGKN6INhw4VjAwQKzYDFGGp/jEMGJhWVpjSrFyJcrIskWcxiSwjVcTDbII0huJt3KITCePivazsqpec7dqGSLMQuirgSulIxBww4XFznUNF2KoxF8qqr+YuP08fQL330vctfj43i45L
 tlnPcZ3d
 rEmOF3/yqtYAuHHx8YoPKO6OzKqAuUUoUsBRgVf7Y+eMcWDuk3gUMhsVTT8EXskPr7cZHebsr0Hh8LNVfa5tk/xM5u+xw5lBI50mjnTtCrvMbw4sx9kq732s6/cNSrYDe/2hKhXB0ySWC1LKGW8cBgnp8tFZ6t1iwqF1PkgGR8P0KWu7ryl4BkAI2KoD7NqtOFzvKU0PEDSRL0X0ey2QcY7cBLoFMwv1t8UAoT5M6+gJ7P6jtRIn6J5Yq7GOVC7gnGpkFBcYVh6clZEU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 3 Feb 2026 17:25:11 +0300 Gutierrez Asier <gutierrez.asier@huawei-partners.com> wrote:

> SeongJae,
> 
> Thanks a lot for all the useful feedback.

The pleasure is mine! :)

> 
> One thing that I was not sure about while working on this patch set
> is whether to have an external new module or adding the logic to 
> damon core. I mean, the hot application detecting can be useful for
> all other modules and can improve DAMON performance.

All exising non-sample DAMON modules are working for the physical address
space.  I hence finding no many opportunities to bring benefits of hot
application detection to those.

I agree the hot applications detection could be useful in general and creative
DAMON use cases for virtual address spaces.  Implementing the feature in DAMON
core layer and exposing it via DAMON sysfs interface will help such use cases.
But it seems not straightforward to imagine how the sysfs interface can be
extended for the feature.

So, I think it would better to be implemented inside the new module at the
moment.  Later, if we end up having more modules that use the feature, we could
move it to the modules-common or the core.  If we further find a good way to
integrate that with sysfs interface, definitely it could go to core.

From this point, however, I realize the feature can also be implemented in the
user sapce in a pretty straightforward way.  Have you considered that?

> What do you think?
> My implementation was module based because I tried to avoid changes
> to DAMON core for the RFC.

If there is a good reason to implement that not in the user space but the
kernel space, as I mentioned above, it seems the module is the right place to
me.


Thanks,
SJ

[...]

