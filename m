Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 082E9CA101F
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 02:19:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FC2E6B0011; Wed, 10 Sep 2025 22:19:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D3C16B0012; Wed, 10 Sep 2025 22:19:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E9606B0022; Wed, 10 Sep 2025 22:19:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2961C6B0011
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 22:19:08 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D39C7C02BD
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 02:19:07 +0000 (UTC)
X-FDA: 83875361934.20.0A9F341
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3595C40003
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 02:19:05 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ryOsXRzF;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757557146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9iJlFzbILAxLebQ14ni7DV+EPZ00refaH7Yt9EIfsdY=;
	b=gtI7TgQX5Uf9p8Cb/QuenCpTxxdSNJZXpkyl2elgJhiMS/GrPtGGxhhi9bO10Ci3r4cYu6
	2zgvpQ6hNdTAsXSbW0DyEVyiyVPuWrAi6GyTMQ8eor/AlfVx+nMSqzjG9R9BtbE39UqQ70
	m7VERmdaVzECv3hUahHedEJomwlpL0U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757557146; a=rsa-sha256;
	cv=none;
	b=IAR9E9IwM2CmnpOje1BHYJpNsu0NyaTCki5nv38OhOIs6PMkZVuIM+9uPjB5XvfQBZnvlN
	sxfXGxCeCOjKMO2fVynyGCOTVOv2KcFz/iQim15dRM1pDRkqURSHjKPVA86xTXKNQQxWND
	h7UcdntVFtYo7pUI8HTce3cXL0nqqAY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ryOsXRzF;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B8B8D40944;
	Thu, 11 Sep 2025 02:19:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F7F5C4CEEB;
	Thu, 11 Sep 2025 02:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757557144;
	bh=un0La9+SwXf/lwBkFinbUrxU0FAkVuoKg+izmE1/S/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ryOsXRzFC7QzxzVSwJtSZRfmcuSmxU4AeCDUmF7MxrC7NhTVMRq3RNu6uZmkCHamX
	 N07Dxkf7Pee8pf0mAHeIQYrc5PXQQaJfu/ovxSTRXfOSttTQIZWCodvAq+5xB2av26
	 mK3DZNMAKpypAEmxvx3zxtfIICqxGnGnLez2TTya29rvCPHjfyczmgCpVZjVSvl6+y
	 mCJDE2n1K2I5MLLz9wDfr5G0UZ9WIAHOSkn+CUo+UcmYt+FpBzeuEbOwOSQkNB5Fe/
	 QcLeFWdNhhasIVYqB6lgjDeEPtriOEkppgDZ5V7S9Japy3mJAjKs2adNoqUL2L15jB
	 hwX96H2D6pm7Q==
From: SeongJae Park <sj@kernel.org>
To: Quanmin Yan <yanquanmin1@huawei.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wangkefeng.wang@huawei.com,
	zuoze1@huawei.com
Subject: Re: [PATCH 1/2] mm/damon/lru_sort: support addr_unit for DAMON_LRU_SORT
Date: Wed, 10 Sep 2025 19:19:01 -0700
Message-Id: <20250911021901.52580-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250910113221.1065764-2-yanquanmin1@huawei.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3595C40003
X-Stat-Signature: itcntdnrq761ddxrkoy6o9yzbcp9xtyp
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757557145-193345
X-HE-Meta: U2FsdGVkX181v83TCTIoTaYYY+ApoMlGOdY66Oe7w2+YHCU3uiNpT/EHPcqDkzliybJjPkTfZh/r6e2Z6UNRZjjpQJHaJXgkmVDi/+lmMhMLmmFkV7Rhrx7Az6GVwZf9I3aKPBTxXnmIlOlxNTo4I6qZ7UHDgwxZVbAO9qMegw/VKTrjUTX3n6gYnCZSE297OjsEqdw9GXgdKFEs6yF8TnQK7h4gpH6xO9SgLkNpdYK1oLB1Q9r7pqEdLQAQ1+0frWvuFDUqRA2uqpaT7lSZw3JSLMAo9KQqUuX17JVi4q2ngo1KPut8ijfacx1GMJ1WjHZxAMJKnl7106jS3X06s2aathd0K1zREfjO2rMmmjm4LxwbmcWRBFV/TSVIZbfWHO/j11QZgcVho/aQVbvfOmZ942RX/wNnofvCa8UKOWdZQJ13M0ZoZyUS8375HyBoQUBnzludLLo5UyIq8VKhwwF3m2gZDDhOgkUOV/4OBExtqO+V8Mn5rHcCMN7JZCQsJAu9HrCHCrpgvaBO6d7gCpnVvpa3pZxkkg2CMpGJ0ubgRAp44h5XZ0St2wxPoAGXBZh1hmiPNhHOMomFvDovWseAOIwZAhH9aZ6hxQLW7dcFPpK+bryzY5lCQzHspUBz4ugdj459LvLeSjRVmxxfrHo4oTl5lVkAkSGVjppj8tUteklRnsS66Sk4EpfS+aG67QAp2YSxlTNEAMkRGLX/3SxDXsfbqOvkW5wL18L/kvbM714+nu1Q1GyJeP8COI3s94zSGAdccLXF3OAT3WxY9b7foBY6a3dlq99Z1CvBoyJHs7RU1x4bBn2GXMgJeJGE7JXJU0oszwatt6PnS9jx/9Vp9pxPS5tC174cpATQrJM4d550bGCfCtOwV4vyAr74NYLUq0CLdsoGLNOGIn3GxGG4AZ+Xa0q/qbbn3z9FIrUFw1tjMUhlXDdiXoak+uOGXiUUU9eju02nr+ysoS0
 9HCPUPZ4
 Orgn79QvTzaBvF8I6CQ3kHMaNWuLJuipr9wguYj3y4M8NTkFtzF7pCXnkXvM2E5VUpGVBZENm1/djJCEQIvpUUjmJezn7UWZcejg38o2hZ0LQ85y0h8No4r7hYl0R3pGDhWw85hpTSCkDTTnQeL23O9aWmhaiGSM6CHME2rvT7BcNUexxYKnOjYdyiJpFL9OBjNRasIM4TUcXB/4kfOc6RGk3JFR4Q/j98zA1AHcCrggAgUGxNuP7SBECtv05pdrmiUk1rXcJjdGxapzFcAHPUVMEzYHmhGiJJZpdHNOvL+W4fOs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 10 Sep 2025 19:32:20 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:

> Implement a sysfs file to expose addr_unit for DAMON_LRU_SORT
> users. During parameter application, use the configured
> addr_unit parameter to perform the necessary initialization.
> Similar to the core layer, prevent setting addr_unit to zero.
> 
> It is worth noting that when monitor_region_start and
> monitor_region_end are unset (i.e., 0), their values will
> later be set to biggest_system_ram. At that point, addr_unit
> may not be the default value 1. Although we could divide the
> biggest_system_ram value by addr_unit, changing addr_unit
> without setting monitor_region_start/end should be considered
> a user misoperation. And biggest_system_ram is only within
> the 0~ULONG_MAX range, system can clearly work correctly with
> addr_unit=1. Therefore, if monitor_region_start/end are unset,
> always silently reset addr_unit to 1.

Sounds fair to me.

> 
> Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

