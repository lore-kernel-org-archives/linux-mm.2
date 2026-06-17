Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E300CD98E2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 04:16:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9B746B00A5; Wed, 17 Jun 2026 00:16:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E253F6B00A6; Wed, 17 Jun 2026 00:16:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEDD56B00A7; Wed, 17 Jun 2026 00:16:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A46416B00A5
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 00:16:52 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DF1341C19FE
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 04:16:51 +0000 (UTC)
X-FDA: 84888093822.13.6CFD8D0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3FD2E40009
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 04:16:50 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XR4slr6o;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781669810;
	b=AEYM4wMYrFuvck33mqKcXAdDDtqtT10ZM+k/1hBnbGeJSBhCRQC/l4tjbf8jV/a8HlJCVN
	RwgJwSYSJo4AOBR/8g83JJmeHzJG3cDvmR72DWRON2QUABovEPANb1MQwcoWSIviC+85nc
	SEDj+T7RxSww1J0gh3c7IbIysHR1n0c=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XR4slr6o;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781669810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tiKJc09+Au+978hFowqG63MFLKZDfeER8N/YPJqE24k=;
	b=D7yqV+0NCnf/XfTEvBgq/AZV8iq4CkOthO5A5ww8Uf0aIc2c0vHlUXk4/yT3drHLhAI+JB
	dAkzR6S1g8sO+YVQPXzb9H9nzCPDG5z9HV2GnCs1Tbfx4vJUuYMvLs/XayL2AbeEUNHkx8
	pbpkTGs8IFGVc8XE64J5B8FaIuW4zBI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B4169600AA;
	Wed, 17 Jun 2026 04:16:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA7E71F000E9;
	Wed, 17 Jun 2026 04:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781669809;
	bh=tiKJc09+Au+978hFowqG63MFLKZDfeER8N/YPJqE24k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XR4slr6oIM/4HGPtUYAvNhCMBhNVu5AHFtM31LZ7OCbylLFjgdfu1Owanf/JiQEVm
	 cB23DEV0Y6MaGS0IAD+QPYEqrqbFWyItzIF/UmUrH4QN47sj2S+kdXZjtoRcnpZ71s
	 SB4Oc+zrv+mxLiQKh7B6I8rqWcfhiUXV3ly82CbTTvHQB01riDy2m5hr+HJMj3Y64q
	 LS7vzHhVjqIexOsTjGMwNc8WISzKZsGAPk+eNh2qBK5k3MnlKDv1e3sh19ODDR69ri
	 bwAI298I6Sq3o7N/+SGef54woPOizqgbK9jTvwg0XldwUFhAsar6TU6FZhuRJBanhx
	 RsTowlofvAiXA==
From: SeongJae Park <sj@kernel.org>
To: gutierrez.asier@huawei-partners.com
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
Subject: Re: [PATCH v1 3/3] mm/damon/sysfs: support hugepage_mem_bp quota goal metric
Date: Tue, 16 Jun 2026 21:16:38 -0700
Message-ID: <20260617041639.99030-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260616150316.580819-4-gutierrez.asier@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3FD2E40009
X-Stat-Signature: 8defat81nmxk9x96rfme9gjxzffppn1d
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781669810-788792
X-HE-Meta: U2FsdGVkX1/l18Ic3IBx15b1UdzLyQBUyBywL+J5/pxZiTRDDqqCqOp5AnAGSuVN4CmNalOjstufbO7b5M51noS/kZuQSp08IeNmL/7Ubbzb+sncZi1rNyfAe24b/fRoNF+hkHEyM3WY3T5HkPE1iSjXhvQPzbktAkT7AHCbAq9hM7sAp1/5jfXFIFUtp5Hszzm+3unyF7MvZXaCyYB1BHEDkVKh2uPn0p1CBkiM+GlQJExwOae5kCJR2ey894ImyOQjh6Agia7EutsjpM02yget+sNynud3JsTPF42hrihXlF4svgmiOuaI6rYmk+ZfeQ0R3FtkxS9W+/qA3v0Ov6mPyLAOC8N9fKXBCu/BYp+XqRfk7S9Ztt2GfbXLlNMTnIn3m2laF14HKV52c2RedSriFIWDG1CDStuUmp98/h0X/zPEdMK2xzcOMMoWEvBWuwpguyKFG1OumSekWAXsUMVjQqYoQqzd9njn5RLj38EyaUnMImCOj7aWi5VsRC6bTuSVxJ0EFYPJN7R1WnxTNHrPFmyiRTxlcrdwMzyMrfc/o0BXSzDVoJAMkX2NKQjTfMr0lijCbnSzPfhs5kHrkEPUpn1L0G9vu9NrAsHbqChQMIimc/7viswzZGaJ5Lt49G0hGeoD1ZNzjnJquxufxmMpCbe0//k9EnHm8aspVq4e114vIFVoDbicKleT+GrTQh3yV86saexMsD5Or4aB1dwCqCeA0brVw2R3wFVQAj7BO3HdWMC6CqxrtrnNe1SdHHbFgD1zfweIvejeJtXMmBYu/sXFq4nsszxMT3zDMpUVbtSMnHzzyNZ2fcVBjAH1+rBByK7E1nxuNYmt2zbVkl2HEQ4qqits0VjoVQxksc/Rq8rrZrGz/x8XchXSC+3JVML6XUN3l3iyhLeWUyuEdXqZpOm1wWL0Q1vhzc3ZNJAwvk8fKbvmO+hmEkCA+joLXSlCbUTrvzcHx/Gvg6y
 F6zS0Tme
 zgZzj8hVzl+vfpkW0W5Lym2D0GqJUgkL/Xvg7hlq9/dnvgZ/1Kb12cKmuOGyReDLPL8DW9Zn68e49093oiAVafd4QN0nrPwz3OQIZn85XlcY1UUvEZ3zM3jX5dMel/4rAHKS5z6+TxQJhZxnIow4EgjaL6FOqDoEaFG1kL180ycgtcdW3jTLaXxI81oeNu2qciS3ss4Nr2jxlGy/3q+raQPc9CPS4L1bW41TdQIhgyalf/hahKfKq0Ov0Xjpd5aeToEgCQgap/iJicDsReGHgnxsZSR732S+Zj3NGPK/OpwXXpzjGk0+wJ8pEKWDsy6vPiVhyeJjtQhcDf14RR4h1Wiggig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 16 Jun 2026 15:03:16 +0000 <gutierrez.asier@huawei-partners.com> wrote:

> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> 
> DAMOS has a new autotune policy metric: DAMOS_QUOTA_HUGEPAGE_MEM_BP.
> This patch exposes DAMOS_QUOTA_HUGEPAGE_MEM_BP through sysfs.
> 
> Add the "hugepage_mem_bp" to the sysfs-schemes interface.
> 
> Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

