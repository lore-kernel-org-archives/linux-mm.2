Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DADBDC88E53
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 16:51:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3A3F6B008A; Fri, 11 Sep 2026 12:51:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE9B86B008C; Fri, 11 Sep 2026 12:51:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD7F56B0095; Fri, 11 Sep 2026 12:51:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B61356B008A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 12:51:19 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7EF39C018F
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 16:51:18 +0000 (UTC)
X-FDA: 85202071836.18.7A9DABA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id C4886100002
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 16:51:16 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nczUk29e;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789145476;
	b=Uwm/hHWVIlfXxO5wbBVI2Bhs173XosKm0oaB6AKXDKL/cSvkg9qL8RxmMP9Rhjs+YiwPan
	fyFX96ysuksD7IZDrrzHsxsxvd1wBuNTSF2RS4UuFR6dKGU0Ocz/ryzk490oWwXiO7H3CT
	2WQXo03+k6foYZrefr8FCHXqWMHT9VY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nczUk29e;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789145476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FIuUIH9isTF2HHo+P+QJvURJf4qaJeVb1iE/bkwd7nk=;
	b=Ic/v1YPi/UzgAc/XQ6CYOMJmqRa30s8P0GlJglwTnWoIVzbR9MfVJP2h9HXdw35ZKyOOWR
	Ay/iNuJIXMxA7E5kODzNGvqWFgol2uw+dePBsz1Pp3HtdC/T8DekbBXa+2JwNh5PxyXQIw
	mO2PyLqN0SUgWKWFdafj9gf0sEF4Wno=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 39F5660142;
	Fri, 11 Sep 2026 16:51:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A3651F00893;
	Fri, 11 Sep 2026 16:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789145475;
	bh=FIuUIH9isTF2HHo+P+QJvURJf4qaJeVb1iE/bkwd7nk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=nczUk29euAdvz2L3BTLjS0bNKun74bw7ORA45xw/m4AVviJN2Q4HnjsBYvazaceup
	 SOd1arR19e+0ZKxbH4WS0qXZkEX0pvQ+ZYLz8SwHKse5G2TCB1TpKj520EuVxuuyYX
	 fhedmKzyvIz/uMalRgHUsvjh5wW9VfvZj9LDwsafLrN8cCiJsfwV1+OByR/8Ygd8vJ
	 WXT9FhjXkgVfkvGy4oXiCr9eu+7PQ7Yz2n9Gfg9fJ46TXpxSBFss9gQkO/HtbjvRkW
	 dnmCMpjJZ7RLFz7ebBAwuflqwk0O0cBSQ2FPANbNaLx2pavCl3GLuU9AzlsgeGgsT7
	 F5qCXPdoY8OVQ==
Message-ID: <c09fb2ac-58b9-4b17-be2d-38bf7fa8fbb9@kernel.org>
Date: Fri, 11 Sep 2026 18:51:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 0/9] mm/huge_memory: refactor
 __split_huge_pmd_locked()
To: Yin Tirui <yintirui@gmail.com>, Andrew Morton
 <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc: Lorenzo Stoakes <ljs@kernel.org>, Dev Jain <dev.jain@arm.com>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Nico Pache <nico.pache@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, "Liam R . Howlett" <liam@infradead.org>,
 wangkefeng.wang@huawei.com, chenjun102@huawei.com,
 linux-kernel@vger.kernel.org
References: <cover.1787941780.git.yintirui@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <cover.1787941780.git.yintirui@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C4886100002
X-Stat-Signature: 7qxu3sfdn6trxoobg5dwoy5wefwabiny
X-HE-Tag: 1789145476-837014
X-HE-Meta: U2FsdGVkX19EUuj9J7ERCKEyjb1Bcw/LbwiwNlcPmp5vsKiWqcnUz1ebs8J/9Or3L9dCNbH2Q0BsmUkb1+gH1E8/xf8NjkUNlkBKVS4LRAXiFL6SjFNep6VweLReVUvwmUm6HJzwtxjqXDdRRpTkscSVamUt1EcKmErZ5NP94U54GhC6tB/vR8zE1yY67qaujTGMq3mZKhinxl/eopbSryZTPltZsUvQZhuzIYQitbebQr5uzHYeo98IvZT1VfanM4hgMI4e9dH6qTjSCm+rmHTKWJnLkLhAl3EAEka9LJ2MCVPgbgO+zIz7Zm21mje5tI6FTi4V+7d7GG4gMtT/HOAeH4HXfGErVo+pRutokKXZCCggxpPtjlDl7L/zhyIsdBGVxIrWExWPGo95CP6yWgxQZanWSu/ptlsnBCjnPREnvWaY7xZlBWhgOZjXwlP38ObbSvzaxxY767FPSWXZ/RjSiKOShw5EiOYrj3E2sjKSLvuN8REXEuzifUJLBJwPdQSOoQQTLeyuuvDzTtqAJL70U9ebhMAnJzvWMyjbxsRbGmbTfciYDirV2Qh8+UAMC85xj+Sdathl1t546iUN5kwe52QWmM/96c3DZIwcb6qFK/igSGU79VVX/ccjnuSJ6FLBQVtXSYUXNhIEDTk9tGij1cIr4nHhfTmiD3CKsv/7lPRvojM7GY3jXvPr1a9WTu1O5//Ux/33qE6AdvJIvOadzfIq+Iiajdh92pGaKgk4vXLTTEBoNVt9FvXIQdK+lpo8uQXXyyqZdh2fFbxtpSBtCdXZW4CPsBxvW6KA9RXnMQaxuFegHAUerjNyjpj/HD/xNl13BMuRthxhXDFCSSnno2iEKcn+FOwI0VCSGI3EXSvPnDKdMJt4MdHMMtMCzU2vggr6GdN1YVpiOgcBtJ9tYwMshMnRf29u65K0rDVYE3GlWdxampfUq1pJ7AqMjXI5nvXHFa2ZUyBQaH4
 gfPyz0px
 jeZv6MWlJ+m0tOJNb1d8EEP6JyVphLXRkHsC2h/ixltVCc7RUd6f8oR2QMh7M/20hQ1S/nyey58l12v5F5nyjIvRV/6GTJu21yYDcViaRik1tzM4BvyVRBaUtl5b3jgtpbFd828uiEazlIvsXo5MrA9itXGu6nubK4MVXpswE2NI17a62vr+chc/YIgjZlSPmy6rl4nEUY4w6Rruga/tyOVgVIkYtsgwH7qmZ2pN4zBeg4iKds0F1JGbkqFlwY/8q3SEL5EEm3dXeZrnHaOE7DbaicCSmer0xu3MuNzTTN1z7YthEWdGD0OhBOQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/28/26 20:33, Yin Tirui wrote:
> __split_huge_pmd_locked() currently decides from the VMA --
> vma_is_anonymous(), then vma_is_special_huge() -- before inspecting the PMD
> entry, so split and zap can classify the same PMD differently. The entry
> itself should decide. The function also mixes the present and non-present
> cases, resulting in duplicated code.
> 
> This series uses the PMD entry and its folio to decide how to handle each
> PMD, as zap_huge_pmd() does. It separates the present and non-present paths
> and moves their common work into helper functions. After this change,
> __split_huge_pmd_locked() only selects the appropriate helper.

I skimmed over some of the patches and there seems to be valuable cleanups in
there. As the MM list is right now extremely busy, I won't be able to review
this right now, so unfortunately this will have to wait.

-- 
Cheers,

David

