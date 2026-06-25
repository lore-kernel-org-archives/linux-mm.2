Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67AB7CDE001
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 12:04:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 584296B0131; Thu, 25 Jun 2026 08:04:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55B206B0132; Thu, 25 Jun 2026 08:04:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44C726B0133; Thu, 25 Jun 2026 08:04:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 20C366B0131
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 08:04:54 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 925241205F1
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 12:04:53 +0000 (UTC)
X-FDA: 84918303666.05.49F3441
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id CE23B4000D
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 12:04:51 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gDjx6JUX;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782389091;
	b=77rIEHG9I9Nu2Yo93DEdRFv2aybujeij1/ffYyMJmrcYKYy8r1C6bxJ/e2TXole3QPECKH
	4gtSVsEIwGSxcShCMlDRTgeD3wzIoPYvCQbqAWf5Ms6ATK42irlMrlgjn4EwqNhp++RvR8
	8JO5BElIq4WruB6P1ji6QChcw+X6SPc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782389091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wYp3f6nJ4mhsWHU1zeYufcd4i+BqeIgNIKCT5UZeKqE=;
	b=ruldybjLJQxS+umdkfTzgT+ZD6poOXLHloBvVQ1HZuif/DfHuHFLnf1DfZ/V4eNAUlaFYz
	V0hTfyxM7uAvHDutco1mMxSYEig0gKPLOxhweSrJChAraAhafsQNQQZv7UwP6Zp02mNiMh
	xrnh4FHxb/QIKOgYce8QdEr+gPAHNSU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gDjx6JUX;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4A584600C3;
	Thu, 25 Jun 2026 12:04:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8CFE1F000E9;
	Thu, 25 Jun 2026 12:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782389091;
	bh=wYp3f6nJ4mhsWHU1zeYufcd4i+BqeIgNIKCT5UZeKqE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=gDjx6JUX5vHCl3jJU75gq2Qv8StmXRad8Wf5mkcgcT9gOz+Tu72jqJDw/YY3tWFE/
	 rm1dIXEtfBavqy0B02DGiEgOel7MnfW7Mh3AQbRDMOHCjh1eAR5aAflWCX8YNDmU/e
	 VfM55sQhYDGH8tyJI3uh6B8LyzYczxcLqjK2WUfQRT/I4Zmlz5X9/+ue0eOjHgYXjI
	 uYlcwXHYJxipCr2bFM/Df5hsclSn67xHWQ8yu/9ENJsX6+BvgYP1yw8H8fDVRghkn8
	 RGr6K/bm15rahwvAVBDrkZYbC13Y533qNplm19BpHpr2ELDKiyEPy20x1tonlGVZYh
	 mnEuZUO9GD5AA==
Message-ID: <fc62528f-99a8-4759-9880-d56077a0f6ec@kernel.org>
Date: Thu, 25 Jun 2026 14:04:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/5] mm: move mirrored memory overlap checking to the
 outer loop
To: Yuan Liu <yuan1.liu@intel.com>, Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Wei Yang <richard.weiyang@gmail.com>
Cc: linux-mm@kvack.org, Yong Hu <yong.hu@intel.com>,
 Nanhai Zou <nanhai.zou@intel.com>, Tim Chen <tim.c.chen@linux.intel.com>,
 Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Yu C Chen <yu.c.chen@intel.com>,
 Pan Deng <pan.deng@intel.com>, Tianyou Li <tianyou.li@intel.com>,
 Chen Zhang <zhangchen.kidd@jd.com>, Jason Zeng <jason.zeng@intel.com>,
 linux-kernel@vger.kernel.org
References: <20260520093457.3719960-1-yuan1.liu@intel.com>
 <20260520093457.3719960-2-yuan1.liu@intel.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260520093457.3719960-2-yuan1.liu@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: yztyydmzhzb5tamp6sbdhp9qmrxtsuwy
X-Rspamd-Queue-Id: CE23B4000D
X-Rspamd-Server: rspam06
X-HE-Tag: 1782389091-873590
X-HE-Meta: U2FsdGVkX1/2tetT6k6tcb42GTMbMf/dtGn+naRBnwCI9rKfBK0Q/Wmj35SDZ7tqxHAJGm3ntjpuFKLajdhc9ao8R8jAvQ7vuHFCqW5ylIfAZONDuSQEqppwF21yoNmt7gHS6RsY5qHtRnhJn5Ysuf4LJCfI5a+A9xtv3rDUZxM9gxeEAFKLPuqxC6xTrOGCLvbWUyqs7rGm0IPekmtwAJLxWcdOzGqP4azHsJLE75/UzK/VrXrMigbuN0agM7pHpfYit0HuGpjdNBabhIPTplZe7IM+428z6MUAdesiOMb+3LprXhrzfIiqR0zCjBQjEtEsVs2/2GsYiLFGUNKPL2GNvP+q4MTpbF4qakqtQUYizYsNSR6xUZ72oerVYUtHrF6+sGCB79g1FT9xHVw5Hn04cGKrSxHdujlfQuF+PTJaqXoomh3h+XKJcUD4t635+zMfdlngfT+wzeGc2m3Gfw/xXmIPaj69b1dRFTDdVa3Jp/as6ZD5hcvJ/h2y3j5qHqh1sO5/4rbQJQGo/U4F9eeF6ZQc35ut7O5N6BHb61e4SzZhh6kPKu4a6LJFKocEkDLXzZpt0QR5C9wfq57JCYVQHrQAiztdMRUmqQHBpyveet436bxeOAnRTt+RLSIQgcuO9VSlt9kMByvpKN1zcVt0WzrGa14syrvETFuprRHTC15xb4z9+AaGVwk7p9GVFZ586u5NR4XTXV05WdPPpm5mHRChN7/nypJTCfKeXb3C0LowBccs10B6s2SDyJsmCmXfzWQiaselvbXsdd/71e1ssahSy57G8XSqNDrF5rQElUmRz+qppH/wWlL3eddww6cnlo8et6NZsGhk/SVTMafv+FTskfp0X0W0zZHw62VDH2qLvGpfR+Db59iVy4h7HVO8+xO9EynTGPtiII/mdO/lCTPuePRKcVHpxvaEnZlHGmnQGJh+qu/Z45Yg0RhVOcx5OtKo7qBizS4PYd3
 VJKYHAcf
 uKQ0s4e20KI90QP00kTElJMRPr/r8r6NFHAyofpW2GpoY//mwrDjn0gywI6aOJXQ7irbDluRBp0YeogzS7lxNqFdY2tPRVk31qwuxcMYVGeeZhPDyTSQHp0VWJaTeuKVNP7qzSwRNI8VtfJWoooD4VIbHfnacTp6nz49EwOODFgjoHpVXv+LF2MeIxbPcKrvbujkH0DMV9noVzwwqNZKTAmqltKjey/MQpLsR8wH83DfI8xu8KDCOAFJnEeKVm1zdJHKxzMMDyZzlOH0gnhWmg1Uu3dFJQ1x+qFXmeLhvUk5lutX2TGu0L52nNtlLIp+aFjCLrWbbnoluYmJO2n63QDuEgZRAv4E6H1w+IrybSTCAyCbcbYWVhjGlYwqXojpuWkH8OuYMUmVyn7akR9QK1DALNA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/20/26 11:34, Yuan Liu wrote:
> Move the overlap memmap initialization check from memmap_init_range()
> to memmap_init(), and replace the per-PFN check with a memblock-based
> check.
> 
> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
> Reviewed-by: Jason Zeng <jason.zeng@intel.com>
> Signed-off-by: Yuan Liu <yuan1.liu@intel.com>
> ---

IIRC, with the patch from Mike+Wei this patch here should no longer be required,
right?

https://lore.kernel.org/r/20260625073941.145014-1-rppt@kernel.org

-- 
Cheers,

David

