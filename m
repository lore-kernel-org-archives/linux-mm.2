Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90ABBCCFA00
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 04:44:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0B5C8E00DC; Mon,  3 Nov 2025 23:44:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E2B68E00E7; Mon,  3 Nov 2025 23:44:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 924D38E00DC; Mon,  3 Nov 2025 23:44:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 835C18E00DC
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 23:44:03 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E216B1A03DF
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 04:44:02 +0000 (UTC)
X-FDA: 84071682324.28.01D5747
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4B81940006
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 04:44:01 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FO018gDQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762231441; a=rsa-sha256;
	cv=none;
	b=4NlYWSbyM+CyJdfQ4RQM+YBMIFRw8onylY7+VG0rQAvPSgBvhgLFSi1nEpX5zp1NvGCjfJ
	LuCEkD8LxUyRpEmsg3oB2kwdFETfO4wBsHmm6XVp3Ghd1Jmu4I+fV7y971SI9YpWvU5c01
	sFYM38RyvjFG2LtCZKpk//6ffPVyHec=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FO018gDQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762231441;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JKIq0hBTK28JBFWuM0r6MFcOPWyW7jRewz2w2X78yrk=;
	b=InYoMkiL+4IemOvtiDmN2HW/La3zBkgJ8FDAegvq8nGLLLgjj2hl7iJBWLFJcmA7GNjkgB
	5eGulyAU4R6qUmjJWXpBG6Cc8ec8Pboiw/7Vqz9YMkUKYA24OUCFl/GfNzTgUvQRh8cAIb
	Q5tsa3IZN0XUqNzQsXN0CXhzZyrQryI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 120AA40823;
	Tue,  4 Nov 2025 04:44:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABBA8C4CEF7;
	Tue,  4 Nov 2025 04:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762231439;
	bh=Z7KhNXOenut48lwUMNJxE28x5klL4Yn07BEFFcrZ6AU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FO018gDQgELbLAGDo3eqXtRjD92b3sr3PGSg9THQONsaFkmA6Tlue5rZ9mf3aVHBT
	 w1O368gkXxt0RGr7MA/9k8PVxLl42w0K+DD+N+J5VoBTEdZ8bKKUu8QZ8FurUkGtJG
	 FQijL5pRksGIkEazCCzagCL58q4t2Uir0NZ2QC2bRJUV4o44ioLppqGP3xosrhX+sh
	 JEB2N+hO4w070VnyT4C6izrBDapDMgctzE383IaWLTDMye6cbJlc+Hn5gRh4ZHdAWf
	 mQm28XaZIoo+5ZJkRPqOjTRCz/GbuxI5IWAS6e5mxzYAaGAB/2iNxq8EN1EdPQFqd/
	 B4tnO9qrUdpBw==
From: SeongJae Park <sj@kernel.org>
To: Hui Zhu <hui.zhu@linux.dev>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@redhat.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Hui Zhu <zhuhui@kylinos.cn>
Subject: Re: [PATCH 0/2] mm/hugetlb: refactor sysfs/sysctl interfaces
Date: Mon,  3 Nov 2025 20:43:54 -0800
Message-ID: <20251104044355.94885-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1762156954.git.zhuhui@kylinos.cn>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4B81940006
X-Stat-Signature: hizif5a6cd9snp8idepygfioqbb3f6de
X-HE-Tag: 1762231441-346931
X-HE-Meta: U2FsdGVkX1/Jk6WPSuKO98Wj6ofw6gzhpmXG+QBTvZtECvFr9gr4fRETKexs7lowxPzhEQf9uyOP+61Fygxaele9HKrP4IKiw+3wANqj637E/pmyQethRS7SRdVfTLdAwBl55l8C8wbEHPPTUTR46yOXdOtvlpY3HPLmx3CS8knzcdy4C+tQL7JYe36Zf8XRYnZJO6pRmYes+uA+uAV8tA5NBUzl74LkKYxpPVVO2vsrYhpFgaho/Glg+dvcMISJ+6qBEwG/Umfa3cTh7S2QheXG0IFTezuKByWpumgG3qj5MDYZ5y1XE+07ZCT0bUZHaRHzbkDyWXJH//AAIqPRPhzReAoYyIM6KDypiucttqUl67w5LBl+nEJSh6QwLOtn+67Vsc4iFYRBCdzZi2TzLL9R9lXNoXjBLhkD/QDJXKWfy0TGpYefidgY0ECY7Lqsk0ay8znHsRmQTBGKIAig1JPVk1Jn4kZs4xLxohHbgRmDVbqGvjQHWPTMBd6fHUJt7iGy9LtshFubZJEI8FhSfoNcdsi+bkbFAN7WjWreUMEa9MX8ax4JO1sfYjzBDTB5jG0GzFGNz8rIFkbmfZl8bTtDGcs7SCgs6gYzm8RkZzkiv0vZHlvv6x5Om+AKKh/FRh29sJM2Wk07lawSBXkqcCCBdIQVWWR7nuiG3uNl3w6hrjJUsEsKbva+heXvFJdhyAh/qtHTfTH3I1bTGQ+UIaUt93QjZdqvHhNmadCuRLQizX90CLPAGo9tsKs+sxb/o6bpcu6g/bYheS8nJq2/6idrnoqkJDrf+mjLN9WuTB5KSpsCgv2Y1IIbY4+fmMQRQLq3DQurFP+INdotOdoIS95ZkmthlwSvV2+G7ndhzoExOzS7lrm6/sd4nwjtzv+ir2W4R3yRmHkGJQmHUPGBk4aOHipCRRAI7EdIH6MgXD2XgkVzW/uEhHi5NtAlvIwuy2O9Hfq9VwUIit0rKjy
 AJcfuWyQ
 RQG5HXMqPBhdkGJgwBFAmAcZea+mtD+AljbhmFldE1hb04ZvsHj5ovfawpVqVvK9w/BTgK2pSOpcPdZYgofc4kZ9Q7sKva59DyJiroJkBlZC/PMntwUUmNuirfs38227Mss+6yzyQRO6C8HLs+HXz+rYxB2ZlsjZpX4FiQ+dThqCw8XpRsJGO9Yystoa+q1d2f4CXbAVfXEQfJb4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  3 Nov 2025 16:22:07 +0800 Hui Zhu <hui.zhu@linux.dev> wrote:

> From: Hui Zhu <zhuhui@kylinos.cn>
> 
> The hugetlb.c file has grown significantly and become difficult to
> maintain. This patch series extracts the sysfs and sysctl interface
> code into separate dedicated files to improve code organization.
> 
> The refactoring includes:
> - Patch 1: Extract sysfs interface into mm/hugetlb_sysfs.c
> - Patch 2: Extract sysctl interface into mm/hugetlb_sysctl.c
> 
> No functional changes are introduced in this series. The code is moved
> as-is, with only minor formatting adjustments for code style
> consistency. This should make future maintenance and enhancements to
> the hugetlb subsystem easier.
> 
> Testing: The patch series has been compile-tested and maintains the
> same functionality as the original code.
> 
> Geliang Tang (1):
>   mm/hugetlb: extract sysfs into hugetlb_sysfs.c
> 
> Hui Zhu (1):
>   mm/hugetlb: extract sysctl into hugetlb_sysctl.c
> 
>  mm/Makefile           |   2 +-
>  mm/hugetlb.c          | 852 +-----------------------------------------
>  mm/hugetlb_internal.h | 116 ++++++
>  mm/hugetlb_sysctl.c   | 136 +++++++
>  mm/hugetlb_sysfs.c    | 632 +++++++++++++++++++++++++++++++
>  5 files changed, 894 insertions(+), 844 deletions(-)
>  create mode 100644 mm/hugetlb_internal.h
>  create mode 100644 mm/hugetlb_sysctl.c
>  create mode 100644 mm/hugetlb_sysfs.c

I think MAINTAINERS file should also be updated for the newly added files.


Thanks,
SJ

[...]

