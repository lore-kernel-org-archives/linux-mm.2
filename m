Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B79B6C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 14:11:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A63E46B009E; Wed,  8 Jul 2026 10:11:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3A786B009F; Wed,  8 Jul 2026 10:11:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 929D66B00A0; Wed,  8 Jul 2026 10:11:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6BEA46B009E
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 10:11:41 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EAFF640191
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 14:11:40 +0000 (UTC)
X-FDA: 84965797560.24.3E14079
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 60EB380012
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 14:11:39 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lKK7qS3a;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783519899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oYNY6fayT8bgIf+rrVvdnnG8n7vDl1N8Udf7r3kCuck=;
	b=d5RTFTl4ryotzLgfaSeCRjJsVdIDBeD7Z+F1LluyzeJwASIgMGM4CD+sd3xUnlanalpw/1
	BTThxzo7JMAoguCwBZtRQ5Y9BxGPmeSbGxBAvpd1Hu/YD8jW6sxEmafLpm6R0n6aYw3f6P
	prO7tpYu0AgnfrTM/F/q0GEl0k77UjE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lKK7qS3a;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783519899;
	b=Thp8v4zymcJGes1EfgkQWW0yMeDpxAOPVbh9sCsXB/SRdlkuyjABEr+Sadiglz3aq0geUi
	2jeulqCnvj3tZnGiPYIVYl0v72ekpL+5tn9TMle2p/RHrzMVVYjwG+vitzaTrlR/RlSNFo
	HN0nxm8yMB2QJyhi1VuaK46zoqxkOXc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 04C196111A;
	Wed,  8 Jul 2026 14:11:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DF251F00A3D;
	Wed,  8 Jul 2026 14:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783519898;
	bh=oYNY6fayT8bgIf+rrVvdnnG8n7vDl1N8Udf7r3kCuck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lKK7qS3ayOUoGqbDi/TxN4vTUQ3c46MmEmzbBUj7+5tgh6t0FPyeD7sJH8+N+7eN6
	 n4VRIjKu06gOYUah6DD63yV3pxz98udRx98r2J2kng87LWbCrR47I66j5SxjUDON1z
	 /ifzB/LubUG0VxRxXXb6CxJ9N5VBoNo+xwWi5fjGMTBY6nz+Y/VCnmyHnQITS7R2YW
	 aM72WF9/KZrqnZYjlRNnfJd+gUJmkNOeiZYvX1AAjz7q83GOOCaC2OX/cF28RGnqWS
	 Ux9gp16W04ABGFXsAK6AGep466gRcm7OcBiQxxJ1dgSDMLpQ7LkwTVuWRJBrj2uuz4
	 +fExMa0KST6MA==
From: SJ Park <sj@kernel.org>
To: zjh <jiahuitry@outlook.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/damon: prevent migration fallback to non-target nodes
Date: Wed,  8 Jul 2026 07:11:33 -0700
Message-ID: <20260708141134.123360-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To:  <BY5PR02MB6642F4D1A8BA92BFF3A034B4B5FF2@BY5PR02MB6642.namprd02.prod.outlook.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 60EB380012
X-Stat-Signature: 7wp3itcx3smrakud3hy4ped5ywqyd5cn
X-HE-Tag: 1783519899-687712
X-HE-Meta: U2FsdGVkX1/M3XGJNd8GlSDX/XCFmkws7Qd2XnjmyMJp4lJnnyqC2wVT8f7mihT2dYMYJa2jBIXIyCYmb6oNpqhfeH2LiXlvwJBNs1HMf6LxqdCEDok/Ddk7CD/G3OPCg4nSD/Wi6d0TRDTOoiBRaxtLihtlRnsDfZA7/uhSkVHCxXKenzeb52iLNNTYuzfvWAJJ8rRER0kMk7ltrSuSUNCg8v4XyW9e8gTK0p/ABYCWGwO7y3vxCN0EMQ94ZjZkUF0BjbVaRb8I+Otpe6rmEczbOh9G228WEajicd3Wyh70fejvbBciPQvkDEEtlNtJxceQkXugF17FGoCkeLH68mGuCaneb5H36RgVqsj1i2ByDaZEwDgk09STCHyVcatOM5BISr55JHJlWsj3mWaeFYUXcGmb0vVjPnaocpZspJ5LdW7ImQnumnxIe/w9UjJMRfYcE3zBKk9S+8fCwWJJpFQqj/LYnFdnlTEy7HZbW46LjdyXJTRxOmxfOMlr6e2X3dAXMcX80Duvecn2VQPPAOurV4/v0vmsAfvhkb2lLT5q8nSdBkDyB6oBJZRnU6Lq1m1C9hVOLDrY3NiGY9Zei2pTB472ZmHT8oxPL+9WgDX5SuSi6vSbfWBv+LhdM7IGMwTEkGEqasoALKSh2rcwOmK81yMqMbJALg4+B6rww7T3Y/xvZhbRE60AoB1gu+5Q9tgxEByY82YjcUxGRk8SF4I2HGdWQbRn5GOwf/aVBaMrGUL0erruo6DnOeMlJkKsj7nvqeDs1SMgZExqLxXYr3fJNxEOsebFuyVoaYM4xcBN8uBVK1tjPchUE8CbHnPvCFcgBMWNL1rcRi4NPgpzWxtg8qwoUFH+P4FZfx0TgZKDdKC10Nqc0b/h0nZvDUrd4w/R9vwN9ADQI5T0lSdYEWzqhGjqLuSd0LDcnE1cAm6cjjhtWnA513qUtDXXGaUBEkPlaZ8gpBX5oEDEvVE
 QiQnBB4d
 wJO3575Hlj7/rDFYqAQPuRxTrqoMX01D+2NuMY/ABYY7452taYKCPmuXJ/v6XhI8tLg8eeXU3kPvkXWXZ6ojOzvVr9i73fjjNaKfrptYVZrqbW+fcNbF4QRxPFbPLaK8LIaoIxYEaDQMCvWxJaO/GKLl9ep9Zwh3hSxtTVLGcT+hE4d75IeAhOG0HvRx6h0NuCxXUgh+s/dMQlhSncQZpRCbWXgctvj3vGJC7J4/3mtu0p1IjWSuiBuJzCYL95rKawkLhd+ND9MLXETJ4hyDj9SSEhg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello jzh,

On Wed,  8 Jul 2026 01:07:54 -0700 zjh <jiahuitry@outlook.com> wrote:

> DAMOS_MIGRATE_{HOT,COLD} passes a target NUMA node to migrate_pages().
> But alloc_migration_target() treats mtc->nid as a preferred node unless
> __GFP_THISNODE is set.  Hence target allocation can fall back to another
> node, and migrate_pages() can report success without placing the folio on
> the requested target node.
> 
> Make DAMON migration target allocation strict by setting __GFP_THISNODE.
> This is consistent with alloc_misplaced_dst_folio() and
> alloc_demote_folio(), which also use __GFP_THISNODE for migrations to an
> explicit destination node.

Thank you for sharing this patch.  So this patch is introducing a small
behavioral change.  May I ask why you think the new behavior is better?  Have
you find some negative user impacts from the current behavior?

> 
> Signed-off-by: zjh <jiahuitry@outlook.com>

We as the kernel community disallow [1] anonymous patch submissions.  Is zjh
your preferred identity?  Also, it is not a strict rule, but we as the mm
community prefer using a formal name if that's ok.

[1] https://docs.kernel.org/process/submitting-patches.html#developer-s-certificate-of-origin-1-1


Thanks,
SJ

[...]

