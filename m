Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77253C87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 16:37:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12F9C9000AE; Wed, 13 Aug 2025 12:37:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E0B8900088; Wed, 13 Aug 2025 12:37:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01D369000AE; Wed, 13 Aug 2025 12:37:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DFC08900088
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 12:37:01 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 675F582A7B
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 16:37:01 +0000 (UTC)
X-FDA: 83772288642.06.25613CC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id CFCA51A0002
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 16:36:59 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lqdQ51vO;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755103019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5YcOl3k0Mh8s8Kb1V3Q5LhHxFngXN6yc+Tslt93HoXw=;
	b=EPWUzm+eMTw2ehVz5NddqewwJZzM0bZIpdaF1f+31cIHBxlAhZy5sKHBzuLakqpVgHREXl
	W8Ehb6n6+znd2z/IsKnDYzhJ7tSnlC9jWx3TvTduQsNdzROwQw/vTTWKGIL2s+/Eotx+89
	ctjWWP2jheVX4MOzFCKjF/k7ps8L1BM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755103019; a=rsa-sha256;
	cv=none;
	b=SB4xo9l5sEgBurs33gB5Yg799+nNt1kjIRMSLv757fjLKb5wBWIT5hDwdxq3MgnnA+Aa8j
	AJ8hCygy+ZjdjcyaFGYE+KhsJ10Askna5LWPoEI32gL5UpeLOlc6u2kw+Utu3suus+Ez2B
	cXRrIWMCWe3DAGC7775v95RbBleAT0E=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lqdQ51vO;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3A258601E5;
	Wed, 13 Aug 2025 16:36:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCC22C4CEEB;
	Wed, 13 Aug 2025 16:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755103018;
	bh=cMS8Hw531No/ecCjZmNrRX5GaWy0pG4vbghgfaqFcvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lqdQ51vOVQzVtOZgfHpQ9GW6gLvBmeNIW82cKH9LWxO7iXj8+ReuaYfGOGrjpZCTg
	 p8V+8kf6aScbY7iwMar78t19reg5mgxStHYELRXZRuQDW5pVGXNNMlYY7R4b/dyMyT
	 X+TxHQUHAt1fNAdMi2wJXVfL/49DjyFHow/Z5T1UCl3jJLGO5FdZCdpIc6DZIaNJtv
	 pdBnWr8E5vNW/xKKfj43cnzFFHiiCCV/KDvA/eYc5zCbFpbtJOaiKis51thpreIwj/
	 ZWc3WnC7rONEDApukmvMDj/eCupGM3VnMKNkO6vit1NKZ6U+3dFkk/F0MK9/Q/SEam
	 GS1HPl4c2TOUw==
From: SeongJae Park <sj@kernel.org>
To: Quanmin Yan <yanquanmin1@huawei.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wangkefeng.wang@huawei.com,
	zuoze1@huawei.com
Subject: Re: [RFC PATCH -next 11/16] mm/damon: add addr_unit for DAMON_RECLAIM and LRU_SORT
Date: Wed, 13 Aug 2025 09:36:56 -0700
Message-Id: <20250813163656.5611-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250813050706.1564229-12-yanquanmin1@huawei.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CFCA51A0002
X-Stat-Signature: ha1egad84839ao4eu5jg7j69ha68ozor
X-HE-Tag: 1755103019-615054
X-HE-Meta: U2FsdGVkX1/F3j4eLputCAmgnIB09Nol7Rcx/mEkjKHqrxK+XuyUgEwB3uqbCWLD/kS9k1fC3L1ZWvclFnZsT+B5e5OvhUgHBe72nU1ppzQtKBTM8nqlqu7EGdTMZlw9ZQhkqdGHmr1mEY/FdqD20k7FooIaY3U0MZewsOfa+VdhUfIk9oaGyqxbuRevKVIprsN/4wdkhfyGG7p/Y+27keHyhJOSIX7Yd6AwDtR1ZXMFwMVFdiC1Z08WbNsOvx/kUOvQxFj6k1dGeEb43liimUMOCMi7TIf1xJWC7mPFsHUJ7Wxz8d3aJKm2YuGob2w9N9sI2VFMsSDIhsos5qZldrSf1JvovQOQN2su4QHZuBRS2F3VKXaeSahmvlqHOcglN0rARgvaAdwUdNsJVNMDGyl13yOuEVxIZxxugRm15hTW9OiekH+Ac0m68CRI861r+xf1BT0UImeKNA3WdNdf4sjQGHD3bLM4e9i+FsjpEIlp8RD+hiZiWLIUxOAzYkXYPt+BvOa55i0uSW0c1YX52wcn/Wpe/YAxW7YXn21ou2e5N1YrRt5mF17hMDP4kxB5N52t7uQCYG4s0m9o439f7Atf0rYCa9aVglMcDFUUgixDrUdIKKo7un8b13w3bHtW8Oha5wKlk830kuLvaynMTsP1Q3Vcf0N4NIogZ/GMAQ+M5zR4sqNykIHeu3gXVPGyfB3AU8dYfhZq6ThPssyIaBmzL5LmAJfW86x5G15ej3GtAcCXek5E71NQvPK4qy2yu8hsbPCd8SgcO9Q82vhMwcakPA9coPoJCH9qmT40oeKRYlX/xDnH8otZt9aM/G1jRSU77NY0uliJaknwxhkpiMFc6qy6BPMWoY9zgsYEheGpOKuylqWOkItUJ4X5oWD3TOp1slkehHVLaqhQDGW+eiBGHlVl4CR9l8By94RSxaCwXiQftwdqV3rtI2FpGBRKbdn+OOdSxQY/7VIiKm6
 R3kclbdQ
 lM/pYxd64HfUF0Mvhx5TcJgSBJE8aiS1Agj8LmwV7I3TfVAFisoaAMRiHeZOvk/ZAyEYdEMMv61HQQla9ruiZLYrPXphdNIfVH7POn0eZDOfCshuVWLaJubAq0cXCqNqoKC3mcbqBYam6ZsooQE3IHMF0sYaRTEHeXlfGJOkGYOxC5u+W+snzYW/ibOtfypvw44gG0eXj4kWu48DkKuCsJ45ZEl2+o1dGNhI+w5L/IJs1yczzd+6+2nrgQ2bxi6oXLsIlVW7s8IkDFU36+6pJmFVFvcXWJuSoUj7oJsfbWbLj5KQVpJ2u1FFuVg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 13 Aug 2025 13:07:01 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:

> In module DAMON_RECLAIM and DAMON_LRU_SORT, the damon_ctx is
> independent of the core, necessitating dedicated addr_unit
> integration for these features.
> Additionally, if the input monitor_region_start and monitor_region_end
> are both 0 while addr_unit is set to a non-zero valuethe default
> system RAM range should be divided by addr_unit.

Do you plan to, and need to use DAMON_RECLAIM and DAMON_LRU_SORT on LPAE-ARM32
environments?  Can't you use DAMON sysfs interface instead?  If need to use the
modules, this change looks good to me in high level.  But if not, I'd like to
skip this change, and wait until someone requests it.

I'll review the code change in depth after the above question is answered.


Thanks,
SJ

[...]

