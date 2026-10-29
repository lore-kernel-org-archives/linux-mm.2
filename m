Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9004D60A2604
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 18:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cKAOazR5
Received: by kanga.kvack.org (Postfix)
	id AEBBC6B0641; Thu, 29 Oct 2026 14:43:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4CE16B0642; Thu, 29 Oct 2026 14:43:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93C876B0643; Thu, 29 Oct 2026 14:43:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7615B6B0641
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 14:43:50 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 05601C0445
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 18:43:50 +0000 (UTC)
X-FDA: 85376537820.30.47BC6FB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 64B5BA000B
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 18:43:48 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cKAOazR5;
	spf=pass (imf15.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793299428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LUhYckbXrX6yJppHSxsBYbUoZtW7rgRPk1KNQoVQYjg=;
	b=aLUu/mqDMwcioVDYqpan2sxiQ7O1cffkGi7vP0naTTI2xwmZy5mgrgKkArXt0yLp24+5zB
	I9oavUznIQdSVrn7vwwWLBJ+enYDDmhE4Et130GjCTqJnVTKszlSpn44kyFbm9XL47JlST
	N+6VcX4I2ip4tjQAd4Vcg8Jvgo7jpLc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cKAOazR5;
	spf=pass (imf15.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793299428;
	b=JOGaA5tipH5Cle5uM5bxl8ZKywvSO0yEHvMoFuyNkf1pDd/RvYMt/J/BFkdDLUoHxVv+cj
	JnvVg48v0KQ/MB4UoYOKHVi8n67HuWsT47KZClCVZT+fzitKdXl3HFs0LDsh8w8T72aXFs
	5w8uZ7Ye4WFjvy2Hq22QrtgwcVzLLvw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AE149412F2;
	Thu, 29 Oct 2026 18:43:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C92A91F031EC;
	Thu, 29 Oct 2026 18:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793299427;
	bh=LUhYckbXrX6yJppHSxsBYbUoZtW7rgRPk1KNQoVQYjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cKAOazR5Ti5pak3mzylgwtzMwkQDoVTrPhOJwB6klzUMHt106oPtPAAIU2dyGCT6/
	 JeyEWoPYCON/ePXou7ABNUGyt0veL3KY5jB9LDt5kHoV2aoVL5pIUW5hpKPSLX03gf
	 LsmekMj9SOJ+Zt3GhyZ2NvoS/1WOxX/FP/9HmjsGF7RtiGy4fu8qRuxn9deC54mCoj
	 ohxY8efFHWM1Zs+BkT5WUrebY9nG9SyY6y+VDj9mZziNQ3qt0pWBIRR+KKsvRjA4ZQ
	 e/DO7EwhuvI+aBZWVGcTitg4O2/sXVEMsWXUx2FSwIQXziJyXRnbUvYEgLWwaH3MqU
	 7vPoPf4GKxFKg==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 6.12.y] mm/damon/core: error damos_commit_quota_goal() for zero target_value
Date: Thu, 29 Oct 2026 14:43:19 -0400
Message-ID: <2026-10-29-1-daily-reply-0012-damon-zero-target-value-6-12@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261028010247.158237-1-sj@kernel.org>
References: <20261028010247.158237-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 64B5BA000B
X-Stat-Signature: jifsrbfkgh6dg4xwf4opb51bkexgfrbu
X-Rspam-User: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793299428-277714
X-HE-Meta: U2FsdGVkX19LReE5zN18npWgujxpBdr1L2lqNwOoxRa/BZu9kn0eAoC+Qstbmr2cPin5TyPx7Sk0sgsNeAaII1hiFwSc14bBd+kLJDP2hZSQ3exxsIdQv4l0fAF0isavIPfUD+QyOkHglMS7Fqs932ckY+MkZdRbon83yvkff0YnDEci1Ad1//GoQ/lq50GIP2iLr/fiCxQv4Ea3qBS+Umw5ces0x3uRtN4cQwjGxV0pHb2N28+6d5UOnI0+QNRPDES661nE8R4ETOMVb1g9MJGKdO7v2eCYpthuftVFpVRVEQvoA69kMyBCm3OqxptZaoHmJEfGfUCodD9PeReO48BbW6/ZnlTgNNquWTznphf0yTKndqHXd5Zr0KiaFrYS4EX0bhB8XkCMeumFsBDzHzFMmJBcESKtoCzMEpItrHGqpjKdS8i4QJ3XlftUrn6dNs8M7ChR9VrCpI8TwSzynHIsB/q7Q+0Zhdlfvcrhmb0GnBDSBqOWOZM8U2DtVSjcXn7990bvfB1w2619HLBBiGKmGaGrW9K/ijLKWK4gQZjIPjEOa2Cn8MwDGCwkAJrgaUteta1NaLOLkIakbb9SbRH/jdKt7dj2FBM70juN1rmgzuYzLayIwXQfub204E8vCE4Krkh8wpV9D6qTGblNqgCLQXifR2iQqNA6ssqb68tcxLkfKnRi9j4qU6qCRW2JEMP0W8TG+OClbaga8Q0Y1h1jbOjdDaOpD76hC+VMnyDe2S+zl0GICcpgENSdDaLtTUCAp8aHwxb3220JbNtNMs8jy3yky1yVPuoTjVORRrLBvEahUqAaDW5IbuCtxJnc2DvADCZr3A6B4ewNEiYzvBWO/D73j5Q8gRUanBNSD6k3Xm/L1JTjxLcH3Q6V6DCTYIA4eXMZ/2zT4gdF6gNThwtFgVDrfcOUYhj7AXceVeJhmGr1hWLt8nFatbDiYu0wvDhMrZy7wehdz9Q/P+a
 KSZR0aWC
 6WjoWsCMI+3KInAzfLyTOlhjgOmTUTR1wPer7CP0YgiASYL2Ql80G8Nxw8eUSHuVhq0/8kA4SIZgg0pH462e5hXOLkGvwFa7Si4rNZ+oY4uNm378sYVEvNiBJkDanjP9Ie8NuAvPzvQKswTeIlqOVXoEp7+4UFXKA9vJelqsSCB1oAjci5NjVS8dh3/AxaaV7QDflswJ+coEuDRNr2i9IyIA7bz873IveU2ziX/XV0qwyQuLGWKZywTuRYJ3KQjPYKkq+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> If a DAMOS scheme has a damos_quota_goal of zero target_value,
> damos_quota_goal() could trigger division-by-zero error.

Queued for 6.12, thanks.

-- 
Thanks,
Sasha

