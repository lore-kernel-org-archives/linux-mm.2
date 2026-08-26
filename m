Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1FA6C61DB9
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 00:27:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D22B6B008C; Tue, 25 Aug 2026 20:27:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 983176B0092; Tue, 25 Aug 2026 20:27:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8993A6B0095; Tue, 25 Aug 2026 20:27:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6D1BD6B008C
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 20:27:04 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 02331C01A1
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 00:27:03 +0000 (UTC)
X-FDA: 85141530768.07.AB31959
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 676AF1C0004
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 00:27:02 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iLnrmaqP;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787704022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4h+AxUzp2+TOGJRdtBIJ00M+Vd7ZziIXgCInJnTM0Zs=;
	b=Wge/t7behXf+CJX/CoAui7EQR0PIrj/oeQ6ucHl3SEIDUjruTj/5p+NQJJNDEDz6gi4Rvf
	3NbsyaAyOhutKf3Dnd1bQgcrqfEWP4SuiFy/QocTzZMu2lyOBn0MfR72bma7oFx0TJeOkW
	WiGP8UOWqgwOS+M8BapMhKPkzEWtIL4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787704022;
	b=2dJlTwgM/AEWgee3BY65YfPlluwGAdznkv35Q9b0s09pEVjTcn25LPHM6cZXlWfpdfPHsT
	GlGfNpsRykwj7NFNhjqlXrHtbWeKeZ4KJHIoGBLKd9h6QImt8CfIXZ53Trvdf37qnmbUCs
	q1v1rvWguFkjklLO/U9UhyDu4khKGF8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iLnrmaqP;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A2B464085A;
	Wed, 26 Aug 2026 00:27:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2935B1F000E9;
	Wed, 26 Aug 2026 00:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787704021;
	bh=4h+AxUzp2+TOGJRdtBIJ00M+Vd7ZziIXgCInJnTM0Zs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iLnrmaqPaMVaX1hKJ9rKgIeV1a5LuC3WUfy15gV6bSJa2uP3q/SWYDUn5kP2YIDg1
	 SfJCZaXBmpU93AQ0rpKOcTO/83CO41Ug2UnbE0GR+evgElw4WOjp1fEjshTMmdKGAF
	 4286/ruaV8xRheVOlRsFkPvSj0QPaiJPAY3Fza8roKJwOAloMlcmeggeaOL5nY8v5a
	 QZ0XWoms9DXeGHmyUshhCTwo4LEXKhVeMbICb6LJrNl+Imk+rfVTWV8+Xaqu2n0hZp
	 50kIgU5fuhesy7atB8CPkyAF00BQjkon7+Ew+eRE9O/CncWpycE2+KoXG8fANh4SHz
	 KkKE8LVXE+ucw==
From: SJ Park <sj@kernel.org>
To: Hongfu Li <hongfu.li@linux.dev>
Cc: SJ Park <sj@kernel.org>,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	akpm@linux-foundation.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Hongfu Li <lihongfu@kylinos.cn>
Subject: Re: [PATCH] mm/memcontrol: remove unused memcg parameter in calculate_high_delay()
Date: Tue, 25 Aug 2026 17:26:48 -0700
Message-ID: <20260826002649.64994-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260825120153.1405-1-hongfu.li@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ciwizx5wofufnbhkniocu9utts18izuz
X-Rspamd-Queue-Id: 676AF1C0004
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1787704022-851087
X-HE-Meta: U2FsdGVkX1+xii1e3/WSAKeyB1qAD7v6jeKwkjJzvkGlY1Ufb0sNp/aS81sY6G06bIV3FcsxgMi1SzB7O+2AecgSo3uk0MQBFvjB+aH1GSWMHtPIBpHGMkZlFAwMPuZ6yPvKBPqI790rLj3KBCHCS2TlkNqVTbaMy9mp0vJIgxr8TZTbdX/o/f/1O6Cs5kLWT8rKuSkbwem1vKjXbBUWCCKxS043Hw0jaKBXL4iIq3MbZ55geY9pK6TJZZjuX9twA7e1Qo27+9ru2n2WOt3N9uzl0NguJW0CpB6mCuSBJhO8B2RUPSYqnJYgEJyxvsciscDkg40NfOXQS6p84Wo12YV7PPEjvIpPb8DKFex7rDp2gk8UZXcnm8mXsVbiRuDUye8v3YHUoohcWUiDRNDL0zmCuXM87YxWaDdkObe5HJZRez7VPRVVMrlkttcDSzER8mYJFTyw7OyewJvMKFbSbslc9GD++YSmdQ7TcD+R75EXPfkinE3wCIvWsqqV64g0w/o+wc50XqY/lDQ/3NymsjuJAOw8ZEfQ8+rDfZSJZVpHbUfVu49iQiuWLdUnoU5bZtWhFjIW9iBb89dbTjU8besfBGW9nlUT19WE1mGUFX+yyjyvgWWZN+PPNHh9dRLVz4+lUctOuV4qqbndJwEqF3oNIr0/ByIatyjaJTe3MvSkOqia805UuHA5Ab4yCqI/gdcEZLMaO9dD7SWDDQPiYeMPj/5flpQo+brjApUPEkaUClGFmOtJKdE8x68IJE0TCP7trDSnGlvPz8O5P4p2OZZP4nqAWgzThYMrRhz53IV5wxlWgdzDfcl2UnUwhH8QbUIFU6I54Z9gmA1MXjPB2EKE4ZHGt0dCRqmvAXtI+zhRFdZ0WX6tPcJFKvg6TCehdMpcd8i9cte8uCgC8ZrO9eujfOV4kLzjyV0UZYoC3agFwcp3Pe88wIuaf4K3O10Oor/PBZB4TUJo/GXoPul
 e40Elb5l
 qKhtsF/12aChuKi9hOqmTcn9Hz4RXXk/g2OtFLIz1z8K8XwBH62ELvoK+bPwFrIbuw/0V4eS27/qcjyH+Kdy9KHqclGnv9d9MO7PQhbXNVDm/hXCoC306Q0wHnpYT0ojgSd0amQAUJqos4/RacB8XYK8oGwRKinqaRighkdTnHjZPmu6w1tm/Xc1haj0F9Grl3md66BI5SvqtRcQUMl8cc26XAb4KugKpxD+kSb4AC8eGRuXLIip6TjVguzD8wc5efbI3YekHhI34II9PnJNyJXSlyO5OpKZ+I0YBANDdCMUcZM89h2x4hd0rp0vOJ5vBlqnE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 25 Aug 2026 20:01:53 +0800 Hongfu Li <hongfu.li@linux.dev> wrote:

> From: Hongfu Li <lihongfu@kylinos.cn>
> 
> The memcg argument of calculate_high_delay() is never referenced in
> its function body. The delay calculation only depends on nr_pages
> and max_overage, and both callers have already obtained max_overage
> from the same memcg.
> 
> Drop this unused parameter and update the two call sites inside
> __mem_cgroup_handle_over_high().

Looks good cleanup to me.

> 
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

