Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84288C9830E
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 20:39:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81B976B008C; Thu, 24 Sep 2026 16:39:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F30E6B0092; Thu, 24 Sep 2026 16:39:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7087E6B0093; Thu, 24 Sep 2026 16:39:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 43ADF6B008C
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 16:39:05 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C017F1404AC
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 20:39:04 +0000 (UTC)
X-FDA: 85249820208.22.03BDC69
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id C8DC618000B
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 20:39:02 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=emqREyn4;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790282342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g3/Vjmw6AiBw6tuZh2AYSDkj3bHoOgKQBCkzF2NfJ54=;
	b=l/yNUE7s36REv2NNagd2rqEjcbA8T2s+b5EDtO+G45YKOR3BwNaUBMJOCUlvFAodxn0N+2
	88crgmSZFuLMMhRs5Tl0EOLzwxUkWQn80IZQMPbELGGe/UTQGy7Dcv1gjMwNxXHR17BySf
	9SGIE1/h3kP1qHtViXFwDtA//pa9cSg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790282342;
	b=3imRFVWRnGSC2Tc0HlonyEv1oLm1oZKw2sfSxLdHKpH3BuSwSBlw7w1NnMNk565BLQuwWc
	iUPYZa2HtsCp9fCHBZ9Sn975N1vvfkk/6ZcnjS12WGBnJI0Z2aDhRA/MApbgtwDmQ8n6Uj
	4VDhkalSmHi5VFpFWlqqN2ZMHG60JLk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=emqREyn4;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 072B741A09;
	Thu, 24 Sep 2026 20:39:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D49291F000FF;
	Thu, 24 Sep 2026 20:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790282341;
	bh=g3/Vjmw6AiBw6tuZh2AYSDkj3bHoOgKQBCkzF2NfJ54=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=emqREyn4tLtzBpljIrz3ubDkpDtN6qKA1sOMtfc8UxvozMFYZBeFV6H5t8lpOpy3J
	 w71/N/7iJrmUe0QH8wQ6PBETHrMvKLpqUstwfihxPhDwSiYOsrgOdmiRZm6bPXiuAP
	 s5wisqMozcU1WsyripIX382HOEWkioO1knOEWxk1xBbjWLz7AynCQ9geEJzUs9Qy6k
	 QuCEh3ld6AAEHzUkRDUt3MLVlXLdM3q/PI8t7IM3+/6guOdTS1H2vtv62HgZaVG22v
	 BP++uAmyvk7PQjBEciJnDbM/uqIBP+qYiFcCZ2suGxY8mugbn8GC0vMqQfgL4ONMkA
	 9BxWj3+uOmWvA==
Message-ID: <b35ac185-e2c3-46dd-91c0-de9d348f0845@kernel.org>
Date: Thu, 24 Sep 2026 22:38:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 6/7] mm: use BIT() for change_protection() flags
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com,
 akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com,
 vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org,
 bsegall@google.com, mgorman@suse.de, vschneid@redhat.com,
 kprateek.nayak@amd.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev,
 kas@kernel.org, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, jannh@google.com, pfalcato@suse.de, hannes@cmpxchg.org,
 shy828301@gmail.com, raghavendra.kt@amd.com
References: <20260922182928.2199090-1-gourry@gourry.net>
 <20260922182928.2199090-7-gourry@gourry.net>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260922182928.2199090-7-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: btn49hekixiyp6wxuaeqe8kziodhd1hf
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C8DC618000B
X-HE-Tag: 1790282342-880606
X-HE-Meta: U2FsdGVkX1+1+sA88QVUiY72OCqXG2A3jUf8ua7INdnwrGjF9Duue77nLfTWfhFJlqbQSG6pVPWuw5krgqRemqVkskbwu99qxbdrUDbUg8m7CSocjw1ykdqFd7B2IqfCEOh1rfeKFwn8Pt13T5DF47OLxgeoqqPtos3Y3Ml+uMNtOvzQqiRmOPcQ2C72HSIcojFmR8+xZkwFtGErV0IdNkzOAo5GCLw3OsD83QphyYGHxzTSP5bq5lb7JdH+nTwzggBuYDIqRsldsgXsrj1phi/xidnSmo7H8sPhsDiwhsbBMesDio/8HELNAyt4nmAJjfObtDZqVWitabyg+ttWqeVIBViNkLVyQItk03pmV5nn47bUBl5KLif6/yu3e8TUnBC5MxMEJl82xrDPCu5VED75vag/+v+oiSoBp7mEIbaaxtkKQhrmPIhD6xGjaCSCxUWmaWOs3aUf9Ql4Z2rNDAlAiLwg7LB5ECbq9MNhvtfB78Irq6iUZjzO7a/oCzXXNUj8N9j1UEv59FALDHfOuA/rtrHYC+/omkw6lsm0BSDVKBwMmd7OylVlwfQ3UYSTACPViXzUxCuALa7VhRinzGLeVAD535s6ZD9EsFZVWEGQ5vOikJzC7SnB4eEY0MxuLRysV761tt7EPpsV8JZqcVrEOnzB+6aG1eq1nasaVnsBeMVPwBdicIVRj3avyWi5uJRkFOYr0NNlASoQMP1ANOJNKTzR7MOzHnzwY8mkxYVM3lydpROFEC9gMe56wi531/KWvF6niccQDc1lW0PoEZhJGflSmY9rcpgtdcs9pEvI0o1T0ZEjqo5UmSOsuDyuY72QwuH83xsJY0+zkaC3jKyqQvAV7RuvsS4bHF4O4EyHOAwQqP46b9GnphxgkSOxf5LuqjTYOyzrDOX/2na8/uR7WZHSG5Z9dOePjJAjVvQ0V4iwEHNmiTRmz/wwWSmV2TMnKCpEfomLAX/lUvG
 zQhBStTq
 1obqdVYQTHbjMrwIOZ5R9QOtwV2a99cWu7NANjerxaxfVK5NggreJBAmV+KSimOTpIe35tF4HEafror5jSA0O0+L2ozTr11xOUTJgaMJrkOXuJ8oIoUJFiGlPt5cgnvYgCoMkqyx6c042MdcBgIDjoGg9Jp2kylkocjpCstSr7fXCFh8ubg/Qyl7yOf4SwkIrZiYOPj1zIQbPrNRikff4OJEr0oAciwAMNgRXIAZhrjxIgN6XZKBukUyPv9KdcusDL69MOIpZHjD14USffTHu+8wX5Uc7hprgMC/D7GJfZaJgO+NmqHPGp6AiYRA/qGFCnAotlns6f0oKbOKNN5XP+osc3OclfipBff6cku9H1zMGm2zlp6YkFTwuY24iWGRQUskle3xD41FZfnswx2WJhui+3/qg4y8TKeUVCJkOgDK4LR0FNWRZg1wHXGxlLaZbcozoLQbOAcu91wSKGi5YbHU7Bw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/22/26 20:29, Gregory Price wrote:
> From: "Gregory Price (Meta)" <gourry@gourry.net>
> 
> The MM_CP_* flags are individual bits expressed as open-coded shifts.
> Use BIT() consistently for the complete block.
> 
> No functional change intended.
> 
> Suggested-by: David Hildenbrand <david@kernel.org>
> Link: https://lore.kernel.org/r/9b5e1573-6fd8-48a5-a274-a6e7ff83d2fe@kernel.org
> Assisted-by: LLM
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

