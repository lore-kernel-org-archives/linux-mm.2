Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72622CDB479
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 03:26:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 171166B0092; Wed, 24 Jun 2026 23:26:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1220F6B0093; Wed, 24 Jun 2026 23:26:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 039BA6B0095; Wed, 24 Jun 2026 23:26:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D067F6B0092
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 23:26:10 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5A0FB40570
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 03:26:10 +0000 (UTC)
X-FDA: 84916996500.05.E9CC398
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id C2FB9180006
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 03:26:08 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QAgsbcar;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782357968;
	b=FPY9wDa8XuLpmHk/sfzh6XhdnMK4a9L2ucEXYTvMrGb8SjdcNBIkWp6DoMSYB8d9dGImvA
	m8JMu/xZkvstxl/4OvvQnRo+zB9HoT6Ljj6Mv2sGW9CX3dV88/b1O4Qv6110GjQ/BRo0DP
	jGuv1Awz2jBFNh2VquyRyQBTHWF/aMM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782357968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6Y0Q3/528bgziQiUg/dWP+Ff0XKFOhQqC+1UMtwPYFc=;
	b=GrIgnDVi4A9OJ4VKDzg2wuKW2AJksH3Ot7VNpb9ZKf+TAWovaj38kYPcLVVEcKHd0EzJLO
	sl1obUhmjEjf3QBGk9pSwz+asWn2xqH+jLZwJYJ1OZ9fYjcOOttTSttu2/xDy35j/JdhYB
	vQ0jLm+drHp9/704PhbXWbiPSJ/mu2o=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QAgsbcar;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EF14D43BB9;
	Thu, 25 Jun 2026 03:26:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 127A51F00A3A;
	Thu, 25 Jun 2026 03:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782357967;
	bh=6Y0Q3/528bgziQiUg/dWP+Ff0XKFOhQqC+1UMtwPYFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QAgsbcarZi2mB4JbypJL0I+wFSuZpNpkogQ0RAipzEmz+kddIFeTTo6qKnJMXoQUo
	 OvueY+43IsnOveBFmd4LN7ZDRBhIzTD6W7nVmX/RzQhv5FUZmN27OE4TfaST1mq54J
	 hCMcQTo0jpE5TS8ppHDq95ufQkvAF83DuZJmXyOMW44/0Rihc0d8nleSsNh0feLErC
	 ChCURU/HYtBbVxB02eLw3mGit3nJRKCDggGj4AYaJFzkGYzDDLygxOs2d7U5hO2HY3
	 PkqPmCff+RIhXQNhMxBolTEe77uhIL1zw98aOeNAuzs0UsU3e4WRge09bcuverNi6u
	 9chcrz1wCyJ2A==
From: SeongJae Park <sj@kernel.org>
To: Yu Qin <qin.yuA@h3c.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/damon/paddr: remove folio_put from damon_pa_invalid_damos_folio
Date: Wed, 24 Jun 2026 20:25:52 -0700
Message-ID: <20260625032552.97468-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260625012201.2937854-1-qin.yuA@h3c.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: ar3zhn8t8ie73ffdpnosnjpyphmksa3d
X-Rspamd-Queue-Id: C2FB9180006
X-Rspamd-Server: rspam06
X-HE-Tag: 1782357968-520899
X-HE-Meta: U2FsdGVkX1/WN5bOqqUmwzt6PLwj5GGqRIQbKVWa2IIE2usHnVoCjLgmXIR54UeLki5w15ZjRhVRzY+/fr8fd1aU14xbpXVuXZhrfpQBRPW0PY01oGRA310WgMdLai/mpfTgiiPsTCW4/6fhVkmyo7PWumeqG4wxM9NyYvcVoC3BlpHt/WXZMy2WDLKAkyQsq5vViH2hQbg36AoWFBQgun7X6ePu+7YmjvLZj8ULgk7M4VqAeMcyieYoiTrHdsWkswjLC6rxd9KzXjoiIsJ6DGjmNNA0k/GVQLezzJlk20oE89f5xHR+aAXahMSRC6s5pbcjsg0U38q1qM7wAvimQ+x6pTxANH9TXP2RLQtELwH7AzZjw5Cm+QEVWNDfSm/IK8LGEHKggeBs7oVamZoClA2YLtrQUgdlcSCPz6d5BXm6/Nxj9he3BerEDVEcAjFqIpoUNhK3BfMA0UldHwB3uFS2aR1rNhMtyd3GQ02lXfUWEldTOzjWqGvahFVXoGiHTlrRIcXaKiMm1HvdAIXCwluAos8jHSv4saPMqvc9rW6BevKn50ZQ3WQOt1u0h/py0pBxIyqmNtmfBURY+8DZrms5aeyZCR1+daFCY4l58Xt7fSmNFGYgCM1CsGeiefcnccWJz6QEzDAAwSQoUs+5oAljtanKJLH4oWcCMpEen6AB+iBQAEHmTtJZVjNMvyHL/cQowWxwv2AkVKR1zMA9rO/wsfE8MEz6fRxMPIqGp3h7F5WYU0GtYXU0OpbKJlFeuAb/A4CgKNAVNGLZ5/+vMAgvHOibKlLa+fmDXko2BlyPvC4qVgTlKUqgjI575O/lUxzoPZOQJAsf7sPCOHeKvtF0zzEo0B7+W+LnEB0mhIyYRZxbUsF0G3Cd3u+zlQNuvkpvR/Hj4oaPrFu5h5qlncJIhEKJDwUU3kZnH8WRLDzF4x8+kD3sz8VQQOjtvw0Vxyup0oKqEZyUFJfONzw
 115JZHKa
 MGeyZlIAjw93m5/LxTu0JuxnxCPuvZ/jOt9YoYKWb+7r430YsrPJnmb+C2IVrbqJskx0Qp7EesgFxiWWuOnQJcMkYe/6xXrsiozfBgapqU0EFlEscFTZx5q9mbi6b/rQhlmOIFiTrn/xa61jhEhRUiiRvWVRE7O2dgjwXq1gx2q9MeZRXjbpr6BaRp5ES4cI3FQGVYuPVvX1YL+5wjsCxKOvvHUxoc8H7sGIzqMi3hgOvEFom0L2AazGZdqDX8t5imMdaLXNKixcqWzyuFv2jyLZX5uDddDA18Tji8lQae4ylA7Ttb9lEZE99BsLF6x2CK2ER
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Yu,


On Thu, 25 Jun 2026 09:22:01 +0800 Yu Qin <qin.yuA@h3c.com> wrote:

> This boolean function called folio_put() implicitly. Remove the put and let
> callers handle it explicitly, making the get/put pair more clear.

Thank you for this patch.  I agree explicit get/put pair could look clearer for
some people.  But, to some perspectives, doing NULL check and putting a folio
that already determined as invalid may look awkward.  Given the fact tht NULL
check was already done inside the validity checck, doing the NULL check again
makes it even look inefficient.

Maybe just a matter of taste, but my taste is unfortunately closer to the
second perspective.


Thanks,
SJ

[...]

