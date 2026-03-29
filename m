Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AFC1F3D60A
	for <linux-mm@archiver.kernel.org>; Sun, 29 Mar 2026 15:33:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0B256B009B; Sun, 29 Mar 2026 11:33:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABBC36B009D; Sun, 29 Mar 2026 11:33:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F8E06B009E; Sun, 29 Mar 2026 11:33:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8A1416B009B
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 11:33:52 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id ED2758BA45
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 15:33:51 +0000 (UTC)
X-FDA: 84599495862.08.E9190B1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 4FEC2160003
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 15:33:50 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PKlaSMtr;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774798430; a=rsa-sha256;
	cv=none;
	b=zHGeelJgffRgeuRl0hcoE7qO2ZLvBwhQeDPWpwd3k7MOYEMdExGGo6nDrcYX+3X0m5zu4F
	s7nVK+BAuLproQ5erbVTUOwJfHziRMru2d0HSd2AKxu4CvW9f1IQkyuuk7hUyTMuY+np/g
	xs0ng62sPCgRp5oANqaL8a6rZSdpPcg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774798430;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CQpsATJo9rVSE5rH9KJl9ZT2m2ZZjhJOHbT7VxnZt+Y=;
	b=wX7edrp+O+8P5eUjmOfhVb9PpFbjFRyVz2B/GA2dlYRTyhQJ1DADoQTLb3Yd6kNz8lVenv
	RwItkM3Wm3Bf8SToraEhUm5e7Xw1pkdEw3uXS7dbETBlb1KBfIJS43Sgz8kVITlX003f+7
	3DBbZr9rQhTaOhh/QUyue2NTGY+ce6E=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PKlaSMtr;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 768AD60054;
	Sun, 29 Mar 2026 15:33:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06A57C116C6;
	Sun, 29 Mar 2026 15:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774798429;
	bh=UQZPnV7y0W6fAjqQLaYQLOo7olw+e+13QhFuEevENgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PKlaSMtraqBGZgzWHbvU99LPd9sjizXZe0IhKXcSdp1fbif3Si1gLR1s/HtZgkQXd
	 l30rRvOe7odaVZ7xKzGkprRRMsSc8D0sizhMjPmmy5gj2Nj7ifMf+spoDIoDmVRzoG
	 mJX8+WPxU3UsV0zlWpX42U2xcXYy/CkHMcx4x+wd7IH/1rWV7tWQ8kE/aizrrIRu5T
	 ZVfVvUulLdddbFk+VIMaqDa5EvPk9ktDhmjJyRSbTL14FtnNley89Ve+deB7O5JSCT
	 L8xWt/q4qdaLCCY3MHE1Yu6BXwnWi7/pfJZRJ7d0yO5HQyajtNA0PPS5YasnhVlVdZ
	 Mhy6YSWGHkqag==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"# 6 . 16 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko status) [PATCH 0/2] mm/damon/core: validate damos_quota_goal->nid
Date: Sun, 29 Mar 2026 08:33:45 -0700
Message-ID: <20260329153346.46881-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260329043902.46163-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4FEC2160003
X-Stat-Signature: u48atk6atmhfjz4ds9f8qafk8mz3zzdi
X-HE-Tag: 1774798430-195262
X-HE-Meta: U2FsdGVkX1+i04tYwK6SBQvIL2nMVvnOCatOwXd/VhUcvbSJrnHBxAoEs0Nuamruf7o4c0M0fG5ozGk7oWwD2ndvKjqLIMsx2YLaG1E8zMC4oP8yY5wzH2i9xIEfnUL7AZ6UaQVjP3pO6Okp6xaNpCvwsZKveXDRMajFJkzySUcBHINRVvwLekEzigedYA/Tdr//DYMMOsLZL/X6jZUq8qNM02vBVJTx6DQVqLmRaYUbYO8dn7ixZyAgRBJd36rDWuonzfX8u6mzcOAYoP0N4c8ef3FXkphmgfgm0y5w9o1s1rCRQc3WTr4HeQXDoRXUwa50Jp7N1ss8hLXP8XbGC7luypjuDJeid4xB/JsHdZOsydnKsDHmUU01BFk+1lWXFYi2lD7aJUVkLPlxZVfbZil+2oY0BwjHXwf/AecnutxhPZAg98ul2jSZoR6MVW3Vols0oXzImtKuGwsdaB67xXNL+gm1Z+V3Tkydwxw95EwfcxQdRSc6zpkDMYEFJWGZWbtBykgEI86Cq111oZdVwpTqyijdKjmfzvXB8ZvfifqhIAUofcLIz6um62ZOCtRX8f16pkdO+A/kF8WmltgymWz3z782HKdJ0O/xB7uCNwd1GvjsVjy+Skpqn7DYMiLTiLBXQ3hvhy1ZxJ6SKj5l7j0sv114BRXTongVvouDf31t4dWC4oAMzVd8F0+acRNkvSXcGDxbLlNhHNFPQrST7CLDEjjU59DdqYQcXPQbYW8lec4tj6tYK3UWCBrhlJzhyp5BqQewl1paPm7N5jJfUr6inFusrSXVPBGxvFqv5FsbjMCzumDmx7TEpi+Or0j2nWirabcz3JkRxKf+DYRfErxUBrXPzcw1HDRuYiCTGe8+7HmUtx8HNGbJPU2bSpVbQwDrvkJxBkrTHTuCQXa1/OAAlXLs/bRGHjttsha74Nlxm5L4D7zk1faJPRXUWZckpM/POgzg0YWS8O4nV9l
 v5U97/jJ
 K6KIf32EdCh/yi/0UfKZx61Ekdl+SHF++PwbepVtxks4Ck9owm7GzuzC7o4oEvelNDxyuhiUIJ2WSOVIczp3MjUvfN7gP5pn0zvKQawkqEh75NjkclPwJATsREHKIJ6LsdsU3K1BC/6DQQ2OJFAsvMqKOF95bas/37Xftft8CPeC+IQSqJS90Xx5dWQ3PQrL/rbdiXWqnHj0N5mpSji5WwmcewBVNLfN3udqXchwO0N3cubCu+x+kb/KQIaQapdobXx75vLWj0UcjucnT4T3PKFo/GpcV5EmwF7riIl80g1P6nbK14ihWAPPeRRm4DjFyTu75xeCHskbh9WSGupMkYkih0DcEyFV9se74bvTbnT7QTPU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Forwarding sashiko.dev review status for this thread.

# review url: https://sashiko.dev/#/patchset/20260329043902.46163-1-sj@kernel.org

- [PATCH 1/2] mm/damon/core: validate damos_quota_goal->nid for node_mem_{used,free}_bp
  - status: Reviewed
  - review: ISSUES MAY FOUND
- [PATCH 2/2] mm/damon/core: validate damos_quota_goal->nid for node_memcg_{used,free}_bp
  - status: Reviewed
  - review: ISSUES MAY FOUND

# hkml [1] generated a draft of this mail.  It can be regenerated
# using below command:
#
#     hkml patch sashiko_dev --thread_status --for_forwarding \
#             20260329043902.46163-1-sj@kernel.org
#
# [1] https://github.com/sjp38/hackermail

Sent using hkml (https://github.com/sjp38/hackermail)

