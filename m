Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F13B8106F311
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 09:21:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D21E6B0092; Thu, 26 Mar 2026 05:21:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 583136B0093; Thu, 26 Mar 2026 05:21:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 499116B0095; Thu, 26 Mar 2026 05:21:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 395AF6B0092
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 05:21:34 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C3D5DBAB50
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:21:33 +0000 (UTC)
X-FDA: 84587671266.24.C79EDE3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 34CD2140009
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:21:32 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=X8uHhCcd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774516892; a=rsa-sha256;
	cv=none;
	b=dHwzrmzeeJWJwzSKRDRUy2l5PZVKVcKs7WE4a3wSj/HXti0ndX0G9WLOfJode+ouV6jYQ6
	QKQP0oaTPS3V9Mu7aBRZM1qeJPIi7jM+HQJVFmGTW+dkJQL61T6/NDHehuCGxRky5EowuG
	H3hiWiW3usVF54yILIOGsiAP/ORSfPM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=X8uHhCcd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774516892;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MYuekCXUqjfQ+c9UWZd2SZcEwt2H6mJeccuV6TJCdJk=;
	b=jY7IWRFOuZNuyW+1A4V0sELYFFdcRqMlzZOiJjKR6kewjaljK3t8saWhSVz/eVNPTiO6k2
	Z0pjEFkGBKKCHyRo9boOVl/Whiec5eNBij9zEPiwAF2grlCCTSO8YhtHc4tmDcZ3tUeoW+
	ykN48o0Wp5gncJ6eF1Tr6s+Gzy1/oyU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B264760103;
	Thu, 26 Mar 2026 09:21:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51FD2C19423;
	Thu, 26 Mar 2026 09:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774516891;
	bh=Irfd1dWVokwwTNpyGi/dp36i3kLufKB6DgUtTAqXdRY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=X8uHhCcddWNC2IfjOnRye9t3PX0WFxiaJdOtwE/AQYicekeENPkYDRSPp2r3Hi6pb
	 rO1k81Fhf7fRcd68dQjz+bk2+zYfg7ZnOYYaRJLIpCySJq5khmxTgmA5kaM2DFJCCb
	 cwTbA428S3Hymg31+a4ZpMDHam34d9Ohi7tvlGsBeMEeqh/tXTtZC3h/ec8knSRm4f
	 IAhdJRp/PHp9Ezy8M2iVaPxuWFBxNswefEVoB5HHbKSwYpzHttu6B+cnJ83vHHMTb4
	 M07DHYP/NdWebyFYWLnHshrfI6b+A7xdk1nr974KgQ1jaB/cKamszSTodpKo4oZ22x
	 9kqiXKIAjHpAw==
Date: Thu, 26 Mar 2026 09:21:23 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev, david@kernel.org, 
	ziy@nvidia.com, harry.yoo@oracle.com, yosry.ahmed@linux.dev, 
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com, 
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com, 
	lance.yang@linux.dev, bhe@redhat.com, usamaarif642@gmail.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>, 
	"Harry Yoo (Oracle)" <harry@kernel.org>
Subject: Re: [PATCH v2 4/4] mm: memcontrol: fix unexpected massive positive
 number in memcg_state_val_in_pages()
Message-ID: <a0bb6fee-a2f0-4742-a127-a4676ec59336@lucifer.local>
References: <cover.1774447069.git.zhengqi.arch@bytedance.com>
 <e19052a28a7b604c012bfdfc900fd09543976284.1774447069.git.zhengqi.arch@bytedance.com>
 <54c2b09c-84f8-4118-96a6-acc13ca2f245@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54c2b09c-84f8-4118-96a6-acc13ca2f245@lucifer.local>
X-Rspamd-Queue-Id: 34CD2140009
X-Stat-Signature: s8nrudmabh63d78gbf6psmck9ascbk9f
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774516892-582220
X-HE-Meta: U2FsdGVkX19RZ6uC5R7mTJsNaLpq8eA2Xdm7z1Q8CyOQYfQKvtx9PVxcPfT7cU9llE67SJGqSNTDNGGT0+ty/RgIwkuXhBxNTVxmLqJUHQ7shmqiCk3TAwSmnRE3eO1hma8dLeMbbIC4ffubw9aFXY00TIu1qak5ZFDxH+7MqvZtyoBMEHBYDqJ/vTj+JgvqcoHwd3zIZScKHyffyIckIQMFstw/tu4ETu5z5ZaTufyludpTjBR4vjA0Nt2GhrlVZKyUhKmgNhcpwswSCbwK2KXlEXHwGKAx6n7zUJvzTqc49t+Tm7NofCE5Ii1kQAiL9vYkH3zn0TRXq3obGKM/YLJUZmJPWY/X9UfcvOGU6rMQIKl1oat9IL7g9YXqxDW5eN7uP/duFXCNA+Cq+C54/X03PHA2cFCGrQ/3hDJ4K63VCVOp6oR6cU5uvsHVI4LRekMPMhL9wT1gRG+BVcLTGwEOsdt5x+Db+uaUDaNRayG3/uon1PBFsDO9Q5WyhYDdr/7pOslZcdpEWbKo9omhojKvGkCuCpc8qSCT5Yrj+xv67I25TA/WNK7lEpgZ8Aha7BNgItSNz86cnKcdMhbkRnximT3fuMW3knlDck6sXJxpncnfusAX5En/XPC0rzjjG4jCOQLGZJiYmV0Xy9pmJpqo77KlzhIr83qNPw9Na9vD20NMDkv0ayglwmhQTjXT9MIFkPyq52uKoAdIb/aDGE5CnYCaDkxSF7xIHxKEtHp5OlN0EhRCk6+HrpDzOCXuJAMd+nWmdncz6wBsCSCo/+5dHZpZEqUypfl5QDeXXXNb03UfqKYaoT+f+NM2um+saY/FGZLrWnb1dFlvlUvwmQtqXjxXaWgb5yyCjNvyx41NqbD9yxulPBj6P8IS32RUsnd9ikVM9PE+L+smooap8GuNC0H+Yw3WZNmEx9XLL89FV7EKE/4s1MjHhUD4nY5P3mY5WcFFyA9XsleI56H
 EadI6ge/
 pebx6RL950yMukyNrxoC3C8mmaxMiEshIEccljc2LwyvFf7dF3zm4yhF1uwK6F8YZlVbpBdq7mst4FGQMlLfsBhZocHzBmuNRRYCLGjGYaLMd0uBoCS46e00HiQF3HARvANi1ySJ125X3qugZnvLGPJc27NVIkbE9/ZHLEYTOR7wGMr13l759M8m1sBaZEyuyC9a5ZJldlxo6Sf2E65Osyeor0RalYN4V3g2neFMKCIVtgmMIJOjj5tZzRFMk0s9GimSTN6chcEZiFy4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 09:16:50AM +0000, Lorenzo Stoakes (Oracle) wrote:
> 	/* Get the absolute value of (val * unit / PAGE_SIZE). */
> 	res = mult_frac(abs(val), unit, PAGE_SIZE);
> 	/* Round up zero values. */
> 	res = res ?: 1;
> 	/* Retain sign. */
> 	return val < 0 ? -res : res;

(If you think the comments are too much, you can drop them, and the code
essentially spells it out anyway)

Cheers, Lorenzo

