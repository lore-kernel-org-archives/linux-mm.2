Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEA7910F3DED
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 17:35:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2417D6B008C; Sat, 28 Mar 2026 13:35:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F1396B0096; Sat, 28 Mar 2026 13:35:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E1B26B0098; Sat, 28 Mar 2026 13:35:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EDC2E6B008C
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 13:35:08 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B827AE0265
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 17:35:08 +0000 (UTC)
X-FDA: 84596172696.18.9313C7C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2144E20002
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 17:35:06 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kOGGzvOo;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774719307;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lHCjFbgH+96y2t0s/QdF+ohU8TIM/SNsVJ/Hh+xQt2Q=;
	b=clvjVyJRWzI+J0ztFS++OqKuJII5sbH9kXJcLBVZL6B1Jqyt35dOrO476uYrM8wgWsfHnd
	NWycWWREsM/sovEmirAOaGF6z+1FRA6qbAhvemsZzf/prLWLGmjVw/p9V/pv2SNnD/HaiT
	zKgIhTF2t32bnBa8jCk9zo5JfPel9SQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774719307; a=rsa-sha256;
	cv=none;
	b=4wSNmPtsXEU4iJHyPmRh5nZxJ1WoEIIujQx4gGGWguY+E7nEJ7uwwzyutvNer2nmRGhlcO
	r99NzOH+fFoBdKCeuH60LcydroszJBcEWMIe4ogwBZ6g4vRbhmS6DfXl9qqP4YdDhx7iw7
	88RmEt0iI+wPmITF4Cfkkaxkwv0mWts=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kOGGzvOo;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9EC1860018;
	Sat, 28 Mar 2026 17:35:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07A52C4CEF7;
	Sat, 28 Mar 2026 17:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774719306;
	bh=biVWiq4oiHUokf5prmGi2zOm6O46A0l0CX4IkwN2tRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kOGGzvOo8hbG6EbtYhDMaVUFzGmyJ6JWXrCoc3aaQOQFqf9X9qHT6HgXFG/VNAsaT
	 1DvUIsGr1Z+d+S883n6XOxsp1EkeSXiqNt9X13Qf2fHHxD2fzDAoJFaxkCXAG9taNT
	 CIBGwDULN+McIOhrhfzQ4lcnsRMecirlhxJOwnYgBgfRPLpVsfSRNc8MjC3PeNxTrY
	 HbZqzTlUm43lsUuJyeg9wdgKQTAkbizl78h+OsPD2THijoHZZc3s/EKT7Wi6opVNJB
	 FnTCf3Z7hbA7Qbu1/zLspDkVkY8rl1YOnmMmxYuxsmkPLnQp+N62RjpSLAa1DoIEzH
	 xr3KrbbxZ7uCw==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	"# 6 . 0 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [RFC PATCH 2/2] Docs/admin-guide/mm/damon/lru_sort: warn commit_inputs vs param updates race
Date: Sat, 28 Mar 2026 10:35:04 -0700
Message-ID: <20260328173504.53129-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260328172415.49940-3-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2144E20002
X-Stat-Signature: 1a3psbd7r59mf5mgon5mcpgwcy8tf7wd
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774719306-977421
X-HE-Meta: U2FsdGVkX1+CVH9XMylR+XeGCOPuW98u8tzk5OnXu3v82S061IJfD3Ee66GV/Oq2Wuxc77YKtjqO/KbdPx51ERVrzbuy+6JjDlh5l6kLi980sPNjIAuNwplMV9Xbd/Z72P5H2rhg2yzKhIZXqjrlJvTeGaes6vPbSiKg4UYfR3WL2VL2ZkCvZyXfvbSj5pCa9OY8Vhleue0h3z7cGwnk9MWsLMEKHB2Api1ly8ACKr+UjmWaGNayEpQmV7WhVQ/RhaU8wL893EnXcTRrPTHvB+oPOBcbZN+fJHotCHsVtBDgeXVrgVx4vko+HjxFkagkUbqxTUyD/bNHTrZ1AuUSgqCpGG5ZjLT2qlOw4PHP2c91s+TCB37bquHKxyEUII1M2ApRRK76mPyzDfs0hO3pdQVXtyFiIsYCdcHVANi1ZtkfU+EBVM7taUziGyKvFhwtSohANSkz6iq1WppIXUF9e9gxqBBdndXFsnkstsCC4xgbdFafPBqxmnORiDcmi43/wtkJPz0LTIX3t+p1uUiwYVk/fuvMyaK634OhkRN1ydBXhKvUmILPGO6QY37WSGGjCcSG8uKIrfZyy4w3YrEWAlVFHr2w1Z9aMl2Vujbo8OtLK9RzI+tZ86HTcDTSxwixoMIeCTG9yBvkIeLcHq604qP6C+yNUqTF5JaqP3Lv0vrwpiCRRY19yO1KhKOvD12wLGd12dt2767cLAIC+JRycCq2ey8gHMswy26ZiejfH2hud+oR+ZJtLt6B3qH1JL7f0kPfR7mdpFgEKvmbVxS8fR9y6fg+Ss97q4M1S8TWj3kr/hRjS2MlKbdkPYIkN+ymgWsd6C3efGlUGtzpXIzuKkCS6cke4QD9BjaRiZGHnsgzIYkCoJm3jo/PvkdDtf22xeO5yBniZV+PLskhIvplRyltTNaOlfXbb+g49VVUZi9EpDpN914OAQ2le3exNtOIj3DnAEKhe7rJIF9Zi8M
 ffUg+aJN
 v8CGh1gNICftIg5GUxkhKxHogFv3WkZseiWwCUOvBp4l5/uppmHf0JPA0D0CkJHPpFBOKj0d24pkEAfJ5BdTdZe4vpEI72sDaL/rMg8NUCq2hY2oxKJIDwua7C1XJzY+88Txlp2aSnyqIff783PuC2Gq/QoerjRuub9xMg6fCPQizQGbITuOP9cl911qzHTL+578WL/18xVIv9YMZTyuw4m0XIe+ORTtV6T9nAY8tGWGcsItVGr0Wv1E7PZ29UsLTINmjy+s0K/XPXIkQ19wg7p2MWLrEmMhKpHVPXLe/fFDS/N7ErpugQ8WiBLC3iJ1bFZBslV04UuPKlqWqTCGKAvfqE9rURKF1RpCwKBmlczlSTVeCe92w1Rv/NFovEGpklVu3MF4XVt9ol4Bu6LrNPuB997123XGa/A8eNBfsmZ3cFnE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Forwarding Sashiko review for doing discussions via mails.

# review url: https://sashiko.dev/#/patchset/20260328172415.49940-3-sj@kernel.org
# start of sashiko.dev inline review
commit 0a9a055d4225a92c337c76fef97bfcdca5d9508f
Author: SeongJae Park <sj@kernel.org>
Docs/admin-guide/mm/damon/lru_sort: warn commit_inputs vs param updates race

This patch adds documentation warning users about a data race in DAMON_LRU_SORT
when modifying module parameters while the kdamond thread is reading them. It
states that violating this rule can cause undefined behavior in the kernel.

Link: https://lore.kernel.org/20260319161620.189392-2-objecting@objecting.org

> diff --git a/Documentation/admin-guide/mm/damon/lru_sort.rst b/Documentation/admin-guide/mm/damon/lru_sort.rst
> index a7dea7c75a9b..3eaa3786c8ab 100644
> --- a/Documentation/admin-guide/mm/damon/lru_sort.rst
> +++ b/Documentation/admin-guide/mm/damon/lru_sort.rst
> @@ -79,6 +79,10 @@ of parametrs except ``enabled`` again.  Once the re-reading is done, this
>  parameter is set as ``N``.  If invalid parameters are found while the
>  re-reading, DAMON_LRU_SORT will be disabled.
>  
> +Once ``Y`` is written to this parametr, the user must not write to any
                                  ^^^^^^^^

This isn't a bug, but there is a typo here (parametr).

> +parameters until reading ``commit_inputs`` again returns ``N``.  If users
> +violate this rule, the kernel can do undefined behaviors.
                                        ^^^^^^^^^^^^^^^^^^^

Should this data race be fixed in the kernel code itself rather than just
documented?

The kernel generally should not exhibit undefined behavior, memory corruption,
or crashes due to concurrent sysfs or module parameter writes, even if those
writes are restricted to root users. Could the underlying code be updated
with proper synchronization to safely handle concurrent updates instead?

> +
>  active_mem_bp
>  -------------
>  


# end of sashiko.dev inline review
# review url: https://sashiko.dev/#/patchset/20260328172415.49940-3-sj@kernel.org
#
# hkml [1] generated a draft of this mail.  It can be regenerated
# using below command:
#
#     hkml patch sashiko_dev --for_forwarding \
#             20260328172415.49940-3-sj@kernel.org
#
# [1] https://github.com/sjp38/hackermail

Sent using hkml (https://github.com/sjp38/hackermail)

