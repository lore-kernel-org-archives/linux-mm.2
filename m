Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67B0D60A261F
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 18:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cjarjlCU
Received: by kanga.kvack.org (Postfix)
	id 8A0066B0642; Thu, 29 Oct 2026 14:43:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8501C6B0643; Thu, 29 Oct 2026 14:43:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7186F6B0644; Thu, 29 Oct 2026 14:43:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 540546B0642
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 14:43:55 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D56B6A80A3
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 18:43:54 +0000 (UTC)
X-FDA: 85376537988.21.D8A2212
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 42E3314000D
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 18:43:53 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cjarjlCU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793299433;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZsmWCtfkjSUIpjrO1t+mOBHz9egmsCMYiQyBvXpggqE=;
	b=XUW7q7dSW1xv5ddX+lpVX15dLHC0ZxOhzc/W9zoRUU806VSXxpCwZg0Rsk8zNrKNdygv5t
	DnRWz6/ykjKBo/JuaWL+FcGL75b4jV6AKrGxhKfNVCYX3Lc8q2xRvtNBsj6buJooMDxBl1
	gHDFMkiDdq7JP98q8qTOjwaoJ1JDcuY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cjarjlCU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793299433;
	b=LEOh4Fd1SXT1N8bLqte4vwdQ/1anEm3pRmGcZtdF8g7CcDYyRv1BmYiPDFZ2yx6OUMjZp5
	gWiFt0woZCmVccvDqUSk0g5P50VhQyh2LshHcK6YwAGZkcroxa1OP7Lc0WrYx1kEID/zvt
	lQcObGSk6z43R6717tDFyqa0Kp/+QDI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8F90540B1A;
	Thu, 29 Oct 2026 18:43:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD6A91F031F2;
	Thu, 29 Oct 2026 18:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793299432;
	bh=ZsmWCtfkjSUIpjrO1t+mOBHz9egmsCMYiQyBvXpggqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cjarjlCUJ4uQLQXdiYDh7cqeH/4JdoxApwHcNdOL8aSwUsm/h60OhTyUcHrf6oTA1
	 XxfxzNNH8wY5GHzAuCxiWVYGztMLLTIX/qcQA+ZEsmyai6ie0pBMtpF0NOVWRP3Syk
	 bPHJMTn6wQ1YmVoP6GbMd8sKx7CuDHrn+bLZ+BoXR6yKHEvCuPSniML9R/hqfx2qZl
	 ZWUzzaZIOs7MizUOvEhw37ff1tRnZ2PWiwzSoYQc6JP0j73INjyEeTI4bg0oSX1pml
	 jBRqzk+v5gxKx816lsUvdDbVUlJyFy/+eq6hGJnv2KDgbUVHeMgxaI6rfrbppj3W4f
	 WMIBiAEfgEu9w==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 6.12.y 0/2] mm/damon/sysfs: fix pid leaks from wrong error handlings
Date: Thu, 29 Oct 2026 14:43:22 -0400
Message-ID: <2026-10-29-1-daily-reply-0015-damon-pid-leaks-6-12@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261028141150.160711-1-sj@kernel.org>
References: <20261028141150.160711-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 42E3314000D
X-Stat-Signature: 9jinrhzfjim9njce56a4bj4qfqyzzeap
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793299433-729507
X-HE-Meta: U2FsdGVkX1/bQ+m7ZbHU6WuQVGCBvmXpQ/f1rbuJl+tDFGl4mKQ63/OVPTaK9Uui9a7gbjqrvp/sEOmv+e/vC0aX7l02k+86seS4B1BEmy00/U97IbByB+3Bdv0bWMrXO+QO3SnOSGW9f4/0jkkaaS+ZLAFN+nXJDF1uc/UMZ8FPRqrk2T8MnJDs2YCTz9lnl3UEs3PO0DzUPZ+l/FzSnOpXm/wT9Orlams9ugH7va7JT93S1I6Qe9iH/4IK1cerkuLGmaVnXCbYpESHu0uaa8TCN4yhxRTqob8YUxzGD4l+jPeK6QvaWQCwXLU9EkCMfFVjCp78T5tsThl3rDbko53ArXjUfDUE4pt8S6QOU46boALLz660PAdBDiIwWrMm0oUmAfTtHSQIjAftec6NOS3cQw7sbYlTT952wCkEJ+L196NPNiI9mTewkpcQF/Z1r3k1l9DG4rS0/NHkuG2RJUg8w9Mkz1rut8YvhIAFvfzGVTLApqEMbIZMsHF7vTyx8JGk01q3XYkhrGYJNHF0gKuXhQPunNgDo1sv/kMK0smgNC1HEP+xVLB69AKKJ8rMZ8kbH8I4Qbbjx/GujjzodeBYG8eo8Xu9Y+gn2WxWTqFEBqKA/X1znUtfcfxdO6tpl/BsbeRSphqgNj0ybFLu0FEXEBqWgN03Qj8WvYQAt13BQ/jJeFjqorxyTyKDpt8g1oEg3I+xXR5vCSG3Fi8iIUu0eAir5aV1MzEyH23fdAi0wGnJYMNRJOGQpWc1mBb5Xhq7ANKQ88J0AncJDlCTaAlkrF+RLmPnEGMJiuvGZVQCl0wIljzKNqfSIg6XC5Zx7A029togo/Cbv/Cx5wwgdCyy7RoFq4wpwgJxp59fQYQqZLizLfT0p2PrkWLfGW/VvQTzdfQ0Wjysiedrb5cHmmzR1BP/GtVc+La4HfGrAgURpctopxQZGrokGKYMTWw62TaRx5CE13kF4aKR/m3
 JqnTJJlG
 /Uq+XyS85J0fNrAt8tqvyk5IoRRFTpk3+VC0BXbLyTQPESvgzh2C+0zsS0eYVBkAQ83Mzm2MGWC+qOMDyXQ/t/poBuppOifTLCnGKSdpbOzj4Y4mvTucs8diTf5r1U3290bMnzmuc/+VdvGMKFbfDxBRoCk4pdMa4e9McxlMWy/sW90UtXrA2BFssviVKXyBTEJU3DsrZiRpB7gs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> DAMON sysfs interface can leak pids due to wrong error handlings.  The
> issue in the mainline has been fixed with code refactoring.

Queued the series for 6.12, thanks.

-- 
Thanks,
Sasha

