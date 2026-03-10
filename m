Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3928CFCC9A6
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 01:05:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6C4C6B008A; Mon,  9 Mar 2026 21:05:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E42B46B0093; Mon,  9 Mar 2026 21:05:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCFDE6B008A; Mon,  9 Mar 2026 21:05:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B2DCF6B0005
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 21:05:42 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6B4081603EC
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 01:05:42 +0000 (UTC)
X-FDA: 84528360924.10.3B0F555
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id CF711A0015
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 01:05:40 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IfiM1MsN;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773104740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7rAquPtPTIczA93CoUyMvoDJlpRSkVonq3WURizgyxg=;
	b=wmiRxphTfGj/0dCp510HsOxHNL5XmubCh5eR7QlyOxmIhN0v84uNhCPNNm9zxcz6AGCv/W
	4NDQ2JNu/z8DVBy+OwRWzb3DC23vzllKQ1t3jTVklDyvgoK2vDVnr5Pq78LdA+qOdMNNfI
	t+3ciU6TBQlZO7rhy3LnmESJsOFwOCk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IfiM1MsN;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773104740; a=rsa-sha256;
	cv=none;
	b=5B++5lJn8aZy/RKALWkaoM/WzSa26M3n1Sb2EAAxQMSISW8aitCIua+1LFalXe6cGUjjDG
	vc4/V9Z4PNuYnq4czsnkQWHM/GyZ4IhQwnc97N22uOEfVsh2gY+VUWCCgwpe43gFzuwdQi
	duP0KyIIq7UsAOFE6pthtqAVYBsHjRo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 500B960097;
	Tue, 10 Mar 2026 01:05:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B00F9C2BCAF;
	Tue, 10 Mar 2026 01:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773104740;
	bh=yTvCo+JXdygWDppuMY59cBuy+ffz+XijY5gZYAbrrfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IfiM1MsNSmm3WEADxWNf29ZgMu+jsFkfxsa2a2ZOxtfqhMDKNeD4ymTphfOlK8ULi
	 Gpmws3E34ovE+lMw5Jgqouj5gpLzn6WB3zijl+7gt0TWPOFXyY67xN0S07TzsULSrU
	 cPb1hp7ctCr8nL5HcRsvnTojy3TyNihgWh/Lqvod+yWvM/9Z2XwkqBcPHoOG9Vqm5d
	 dIdKAu5t9IBBqdnBVxMlE6Y4DQ/kVWYimUhqdXZT47ksdqKjTTp3FtttOtWBA7ds2j
	 4ycyG6DGB76YlDz+ureGMT/9Yfd71uJ40L3SmuZRl8JP48I3UjH0GIOeGotkXbA5Ce
	 YZ508Oi6fPOTA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
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
Subject: [PATCH 05/11] Docs/mm/damon/design: document the goal-based quota tuner selections
Date: Mon,  9 Mar 2026 18:05:21 -0700
Message-ID: <20260310010529.91162-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260310010529.91162-1-sj@kernel.org>
References: <20260310010529.91162-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: CF711A0015
X-Rspamd-Server: rspam08
X-Stat-Signature: ewt4965zkk48onwtwacpfpadhd67kchq
X-HE-Tag: 1773104740-934783
X-HE-Meta: U2FsdGVkX187eHdf/B6uPWVVaMbf6kGI4hnYuyXevAmEMuKbGEZZ4KHlSarcMoHgXZvdNswGmta4gMCm1Qs1kVD+2bRBUCVaJZqE+QRRXFVQ5S7cZuEECd7k9s+VEruLcXoFwezd452Ta1LAsWBnqV0NjH0YhFpQ2KLAtQ3NqHyDfUWbdiHYlCQo46SkW2naUXIhu2VD69BcoueeSXfH7g87fTZ3Qg/Sykx/INIAqrtJvYGnE3cMKKPQCKS6+zG6f0EF+D+myAkQZ+2png6Q+TEl9sZAGTCLMYhuFJB18NsscFsJO0PFshEXiJY4vwXVQpduxu7k7V6K7V1y/IhQPOMoxVipG4Y0T0WOnRb2v55tJ/02GcPoN6whbpfRRAFcupcaljQFuQclRUoqlpogofifX6Ycx98BaEA9cXSp1YMc7t7rAJQ7Zo+1m9Y+M8toCDImptxGrskO6elvCJw07xQlyWEgMIxpzWyr0vkVuYAsoVeNIHTADm4gvfEIAtZ1zkMP6mOrBrgZekdY+xj6O7X7twsJemOX3OEhOg9sqLQVT7PIAmjYrud5W6KINglj2BZ2uwBklGUa3EYOjHmdTFkgeTmFGpoXGIzXW4SC0hEYQa4NR5T8DyLOfc+YmdDOXz11Aip3lE2aGvK/8cZfto/6qySYYY/FcsmXV6Y1vC2+8Gudf45gpVWxZ2CSctAmvvIY2HBiVf0eYrGcSKsUUXkwPjAR268Rka03ZaJDqQyk6C0pdSUvVnthJGfmzOZy6ErBxfvmoLIT//b3FCfeIOY0sNOcNYsP7y6LJXzrmAr0gGfAWBvAsnCYWPNWayPqmm7+0VxqWA/LDDui78/ZZJO4B6iEb67jkqc0L/WOzqBlLbwC7kQ60mvIQiq/P/rD02mYUEKsXK3j9jJHJMSdMMFv8pMPJr+/4jQdlo+ah53Lw2vB2IRu6IZb7sop9laTuxz18+gfSrCwnGfVWzW
 uM3qpb/p
 V77oof5SY1fKvGVDJ3JIW+3jUkDDHdOMmIMFh2/6r14wdWRvHZbOexwu4Ezudw5GDDIIbQw99oZkrNXO9LIIehNl+mWvji1OxNP4qu+Fy/u8Fy/rPo+xWC+kBcjDHNqdbhcwD9+AQxcy094mwqXUct+cUd1o9RfjeMDUT+OWnXuQvTDQNv5zNOdphepe2h1a3hnH0mcFxPmgoQl27ZpwWeQ/U1gZI/yl3rS0OVZRBwMEpY5g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update the design document for the newly added goal-based quota tuner
selection feature.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index ac795f30519c5..29fff20b3c2a9 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -566,6 +566,18 @@ aggressiveness (the quota) of the corresponding scheme.  For example, if DAMOS
 is under achieving the goal, DAMOS automatically increases the quota.  If DAMOS
 is over achieving the goal, it decreases the quota.
 
+There are two such tuning algorithms that users can select as they need.
+
+- ``consist``: A proportional feedback loop based algorithm.  Tries to find an
+  optimum quota that should be consistently kept, to keep achieving the goal.
+  Useful for kernel-only operation on dynamic and long-running environments.
+  This is the default selection.  If unsure, use this.
+- ``temporal``: More straightforward algorithm.  Tries to achieve the goal as
+  fast as possible, using maximum allowed quota, but only for a temporal short
+  time.  When the quota is under-achieved, this algorithm keeps tuning quota to
+  a maximum allowed one.  Once the quota is [over]-achieved, this sets the
+  quota zero.  Useful for deterministic control required environments.
+
 The goal can be specified with five parameters, namely ``target_metric``,
 ``target_value``, ``current_value``, ``nid`` and ``path``.  The auto-tuning
 mechanism tries to make ``current_value`` of ``target_metric`` be same to
-- 
2.47.3

