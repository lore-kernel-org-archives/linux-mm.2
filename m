Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DB3CC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 04:38:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E7666B0088; Wed,  8 Jul 2026 00:38:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C0446B008A; Wed,  8 Jul 2026 00:38:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D5DF6B008C; Wed,  8 Jul 2026 00:38:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 24BC26B0088
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 00:38:11 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9FEAD168DB5
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 04:38:10 +0000 (UTC)
X-FDA: 84964352340.08.9A03E3E
Received: from smtp153-165.sina.com.cn (smtp153-165.sina.com.cn [61.135.153.165])
	by imf10.hostedemail.com (Postfix) with ESMTP id 39DFDC0009
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 04:38:05 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=YPewLFaf;
	dmarc=pass (policy=none) header.from=sina.com;
	spf=pass (imf10.hostedemail.com: domain of hdanton@sina.com designates 61.135.153.165 as permitted sender) smtp.mailfrom=hdanton@sina.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783485488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r+wlUDq1nscYlhIUXNgBLu+X4ifZCpDssrpKDtSdSeY=;
	b=5dK3VGBECB0c27I5+HfdLwDToos9MIwM5nzodHQuFc373RAB0N46OubX4S1yqgYVJbVZKC
	DNvJc6IO9LnLhlk77YwJgj1Y5gUvoJM2Gnvk1BcQyGqNCD6KjY+l10POwDK+hFColWTXPV
	D53K2rEwbhYOfiv28reJmryrL3yS1yA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=YPewLFaf;
	dmarc=pass (policy=none) header.from=sina.com;
	spf=pass (imf10.hostedemail.com: domain of hdanton@sina.com designates 61.135.153.165 as permitted sender) smtp.mailfrom=hdanton@sina.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783485488;
	b=Axpc8BgxprWEk1fBaYxsCNw+/A96DkaqvplfK9UNok0cpq1QUs3/tUJ8roM66IbtJLXGyh
	UTBpcq6M6J8npBcEAp4d6+Dnwn1EK9V/TusmxvWyrUdQ6wJtGPNRkZfGfmk5ESosX0roT7
	qvdvCSgv59K/TVlmZrUwgJ0lCAjy/TI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.com; s=201208; t=1783485486;
	bh=r+wlUDq1nscYlhIUXNgBLu+X4ifZCpDssrpKDtSdSeY=;
	h=From:Subject:Date:Message-ID;
	b=YPewLFafojYhmiNU1D2E0jYyEulZXtqNnAPiJyimYmyunc2B2VM3gn5CaaKEpwdYu
	 wrgbJzzGQieSnkWPb94pxqCbj12j7ZWpqOK0nSu4ywZ2fwLAGuErvL86yXg2eF0vdL
	 KbnD5ARxZBMTwQ3so5qNRVQlOyzE7ZjSJOf2IcwU=
X-SMAIL-HELO: localhost.localdomain
Received: from unknown (HELO localhost.localdomain)([114.249.62.144])
	by sina.com (10.54.253.32) with ESMTP
	id 6A4DD4260000448D; Wed, 8 Jul 2026 12:38:01 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
X-SMAIL-MID: 1043304457391
X-SMAIL-UIID: 0C5A6D398708443A93150E628A0CDE48-20260708-123801-1
From: Hillf Danton <hdanton@sina.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: tao <tao.wangtao@honor.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH v2 00/13] mm: rework anon_vma and remove anon_vma_chain
Date: Wed,  8 Jul 2026 12:37:49 +0800
Message-ID: <20260708043751.421-1-hdanton@sina.com>
In-Reply-To: <08c001ab-320f-4676-830b-8e4ba6a05dee@kernel.org>
References: <20260707063308.29176-1-tao.wangtao@honor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 39DFDC0009
X-Stat-Signature: e3z1nywke4myccrrydxtnd7yr1qnyzb7
X-HE-Tag: 1783485485-480630
X-HE-Meta: U2FsdGVkX19HsAPYct4Vu1NpVo15I7JFeolImthwUp6irMDmrIYj1n2Nu2uP++BO/cTgrsiLpU+XC6WKEnaamgSf7dtiPGVzMUBWHKN2TadhngkGOFGBKlpBQiEKPW90ybWL+6GEmaRnEJT4mbGKVWHFdAsfJ26ySX6SM4y0dueE8AqPR2gNqre4eYSsiADzxZBC956A8s+Oojt3qXnoW01q7C1BlEOBXU4f5rcfwsVEYswzm1vyLGdLTrMQOyPPsd5VtMNGsq1iDb+QuezrGDHh055lR/I32iTPXyWf4WKHcDGaLMfd1t4wPXn7PRs1WbPc9U3nhSvmSLG4hILjuTso5j945h+I7inAHFlFbcJzs0oZHDB8XJDD0KDenyy1i6I2In9E6LNRpEjXB8pCVgVuhPq+MHn146Lr4TicVYB1+qMl0LmT0Y9rNEX9rP7sXAmUxibPOWaFM/mUXdzhedZYDs2mV7yck4o87bZMFHaWKFGKmTINLaU8BAIbRrPE+/sFlkBt2mkBEaX8OVm3sSJm3lZJ2crKx6UvmhLJqHLr1ZQQs1StGX0KnmbzESocU5HbrlfrQA89ZH71TH1NxcKlBXlvKgtFfyXwFb1td27EX68Dbc9vH17EaBwp+GbnY2E7DAAw2dCzA7wqiGz0GykOSIEdyiIr/8U0TC/D2qB8qWTa9GT5+c/mZIwqLVfpNPz1TbftNGCQVaXSLxRCrpBxOJnPHcCwgI418pW/bD5zKAjdqmBB/2tv29EyCeH6+KKdMCKtETGVkZCeNixQh1RDM66IrIWfw2MK1kfF9vQT96ZeA3J7m8i5AxSveb7HfSpmJfmofEddBocq8bJrJJYmZB95/qy1LexofeWaWQ+SqSZbKivsMtZiV4bwJ4G2wgV9FeFcLTYVpjYFyh71gSahqPx5OTO7CZvyx+fcIqDXM9wFvR+xWAUVqPRYY1nzdMUVDo7PgkXaDHkyxgP
 6vQw5jPL
 b3flJlN6HmqxADnzjiiaGyVfB0K7Ze62t5VAGJn8wswVyd+mghN3MOnplolxInan2MhyAqt4g6SIqB+0QatHdo/5XCaOblIclyYANVkdFxwiwJPrbkiimBxqMazLO+4MpGzS0fkd3V1WivJl/jFn0eXLgHYgQAxlFO/t4fY78dE2he5EKRMMYf4Vq3HC9RPsQhpE7FPgX3Rj+YhDgHVN9qWOfzZPAlKuVd/F6D/JUyOPEC/Wh7PCl++/JXUwRQU0eRb9SPsbFO2butbHFqo6rSK77KN0NK/QC/a/ID+nK8m5M6JWfwRFlEons5UGj0g88hTcSpN6RA8KXq5oFvJbcJa5Gkuo8mU3KKfudTKtUXmu4jEnKZPxxGLBYZSq8JlEzA/G67RgyJ/XAinl7ZM3/C0ZpoUT4KowoKsd5XqkrMX7T2QWbV0kVMvKK4Zg2NCyz/mfiEss9IIAwjDI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 7 Jul 2026 09:01:04 +0200 "David Hildenbrand (Arm)" wrote:
> On 7/7/26 08:32, tao wrote:
> > Hi all,
> > 
> > Since v1 was relatively complex and difficult to extend, this version
> > adopts a simpler anon_vma implementation approach.
> 
> I really hate to repeat myself, but you seemed to have missed my main point [1]
> 
> "Lorenzo has been hard at work exploring various design options (and I'm afraid
> he might be one of the 3 people on this planet that understand anon_vma in full
> detail), so I suggest we wait for a redesign proposal from him and see if that
> is doable?"
> 
Given that no numabalance could land upstream without horse racing [2], what
prevents Lorenzo from becoming another (scarlet? raven black?) lipstick given mglru?

> [1] https://lore.kernel.org/all/70377626-500d-46f2-a3f5-a0d2914ce365@kernel.org/
> 
[2] Subject: Re: [PATCH 00/35] AutoNUMA alpha14
https://lore.kernel.org/lkml/CA+55aFxpD+LsE+aNvDJtz9sGsGMvdusisgOY3Csbzyx1mEqW-w@mail.gmail.com/

> -- 
> Cheers,
> 
> David

