Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6770EC982D8
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 14:25:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DB6D6B0088; Sun, 20 Sep 2026 10:25:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B3186B008A; Sun, 20 Sep 2026 10:25:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EF4F6B0093; Sun, 20 Sep 2026 10:25:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EF0BE6B0088
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 10:25:27 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 041B31C2890
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 14:25:25 +0000 (UTC)
X-FDA: 85234363452.11.4E05A13
Received: from outbound.st.icloud.com (st-2006a-snip4-11.eps.apple.com [57.103.76.181])
	by imf06.hostedemail.com (Postfix) with ESMTP id 177FC18000C
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 14:25:23 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=QsPb7t1m;
	spf=pass (imf06.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.76.181 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789914324;
	b=lS87wYOFaTW4c2YUnxMoSO77nc2ptBfP45fIrTMz6q/j+8K4P5vdK8lnUsKQtVv0BTpWeA
	uiMd9L/C/d2Epz/i2wtSPvKv0G/Fus/cf37VmL0d5ytLqehLvB3iShYas0yf7rjORm9BSk
	bZMLkT7ukflM//Knm7D/FvTKn7I9GQU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=QsPb7t1m;
	spf=pass (imf06.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.76.181 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789914324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=/aGXQmdJS7KdJOcSMq/QTimLokk6ifZyP8kn3JnRhoI=;
	b=S+Bhdlnu/IbKVodQ41IsvthwDDl916gLw6a/cW4jfLAU2YAPAc/aIhcTPQF1JLYWqJEajy
	hhoB0UJiZ4/2mxxlVNDB1HSGB3zCMJvrsTy8uuymCOCy4VpjMsuQ5Vu0ZWapn4/ALhugNL
	Ers56EdryZdUT1wDF1rJGsbzUI/b5Ng=
Received: from outbound.st.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-1a-60-percent-7 (Postfix) with ESMTPS id 7012618005BA;
	Sun, 20 Sep 2026 14:25:20 +0000 (UTC)
X-ICL-RepId: 01a0bf35-0db6-7e8a-8873-a940380b9cf1
X-ICL-Out-Info: HUtFAUMEWwJACUgBTUQeDx5WFlZNRAJCTQhKB0MGWQReCEsEQwFbEhVdRUkERxtXAlQXXQZSEnIZWhRcGFNFUR9UWFUJCgJRHFYNV0NUBF9QSxsOXABLWhVVFw4CQh9QH0wWV0NEHxwZWhRcGFNFUR9UWEMZRVZpQQtPHV0ZWxxCZFhXCQoCURxWDVdDVARfUFQRV1ALWQJCD0gKXwdGRB1KG1IDGhlXFlgbRwJFRkRBFEgeCFRbBhQOSVAPAF0DME0dXQ5SBUZeWhdeUxcfSwBcRVoOWwRHFA==
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1789914323; x=1792506323; bh=/aGXQmdJS7KdJOcSMq/QTimLokk6ifZyP8kn3JnRhoI=; h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:x-icloud-hme; b=QsPb7t1mVVpvVrCiLYhVVI01x5NXWpcpXjFBXh+PMhsMrDlu5GPTUeFZaB06NYcNj9DF2XWQNRMQO2QBTZd0/dCLY0J+K3BnSau5ZpnwuyARDDZLcghds4strDGK2tW66+QR5Ii7jPAzLhb8BttfoTHwJiojw97TFMfcDm5cTcZKW5b/88rOCN/UUBiWHF2cgZyf3QZJOnucijFWACmc2I+AXrc2GWQdFnIN5A4E2QgWbJwnT3ClL2V2e9fxobhLzjQ/i1PpHGYNqdtAljgUpFuxfg8dU08eJhbWYgrpI8fVptiv8dtnK9MjP43tTCYQ5yxAJ4eEEinnzZzOVwhnMg==
Received: from [127.0.0.1] (unknown [17.156.216.30])
	by p00-icloudmta-asmtp-us-east-1a-60-percent-7 (Postfix) with ESMTPSA id DD063180028A;
	Sun, 20 Sep 2026 14:25:13 +0000 (UTC)
From: Zhang Peng <zippermonkey@icloud.com>
Subject: [PATCH 0/4] mm/vmscan: refactor shrink_folio_list()
Date: Sun, 20 Sep 2026 22:24:13 +0800
Message-Id: <20260920-vmscan-refactor-v1-0-ec04d71cb761@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAI7sr2oC/yXM0QpAMBTG8VfRubayacKryMXMwVFGOyMl7264/
 PX1/S9g9IQMdXKBx4OYVhch0wTsZNyIgvpoUJkqskpW4ljYGic8DsaG1QvZ5ah1WZpBK4ivLS5
 0fsWm/c17N6MNbwbu+wFYYMt/cwAAAA==
X-Change-ID: 20260919-vmscan-refactor-1b3e5588af52
To: Andrew Morton <akpm@linux-foundation.org>, 
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
 Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Zhang Peng <bruzzhang@tencent.com>
X-Mailer: b4 0.16.0
X-Proofpoint-GUID: Pp_TAklIRdDoxsJKa3qFpIShYd1VUFJq
X-Proofpoint-ORIG-GUID: Pp_TAklIRdDoxsJKa3qFpIShYd1VUFJq
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIwMDIxMCBTYWx0ZWRfX2fDrlNzfFnBo
 rYEggZHiqtZjYbJRdNLwbEZnth5cQmeVaEGK97/dCWL0/8anKTbrHuit1APojiSe1xi0PUjRLUU
 upboS6K2JWyW08MajfKgIIA5zr9y6zuW4CRFNwd4aj2X805f4u0vjH1kvNmnhW+4ggNUK1+0pOR
 0FyzGWDZjNe2VbsPRHRvmdt93cBDrB/VkMqGpz23XeQSmOCvNzc34zY3PPvCDo0DXdgSIKtcIwf
 zv2ra1BfoRLXvf2iDxxDR6qGL53twrx3L73a5WVKHCApMZTxPZokmMftJQgIrr05RHH3LZSHTeN
 qBHv5v3y+0vBpZyTWjbERtS2u54vXNXc8tXwzwVekioCyPJcmZQgsHrL64EaXk=
X-Authority-Info-Out: v=2.4 cv=RrvI7SmK c=1 sm=1 tr=0 ts=6aafecd1
 cx=c_apl:c_pps:t_out a=oyWFxbOnq+dmhQrAPgaJYA==:117
 a=oyWFxbOnq+dmhQrAPgaJYA==:17 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10
 a=x7bEGLp0ZPQA:10 a=YE32fvk_ji8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=GvQkQWPkAAAA:8 a=CCUvzCZDDOCMfV_14LEA:9
 a=QEXdDO2ut3YA:10 a=J82S1U87d15UFHHUFZS8:22 a=J6hPbylVjWXjVQVODqME:22
X-JNJ: AAAAAAABwL4AaH1E1ATes9luJBLe3HgtTJASrFZxhazEFDFuM5fhRTEhRSQmH7kBn7XDI+oXuawgFrxIoKc18M2Ws7A1ituRTMlzOKdzURhcXNsWEn6zGaEkLdhHWmnV31J3bCJdF1R3NVDR+zW/CdUiVXfeKP3eUp7I3cw4tSJ78ppobWSPzmsTRjjBxN6fST1W+WP+MSTTV1/GNVcsBKj6GM/D6QjLPeJyDDbHscZxVIiJIf7UdmDB2ghj4HDsCDn4Fizr4cj5p6MeTBT2zjCa4+grA7+MbEvjlYoXOHwIMFAZwU5smB0t/9Shk4WYGDnLudHnShfgB3LR5uU+lH3OZyE7ttwoxt9I7FwuZZwSJrK9ArJbdUw9RiQDVnqCzA+scQYhoEikDM4N7YT1ezTmmlPx6KTXpagThhgeo3ykA5m7haNpcO2wtzLb4DbuWcbTRL1mWSv9y0AHyCuVSEJb5AXrtcjRgv1ozdIEAMQotsBG+Dg/xW7pp2cM18jDiHwbI2AnbTVWwD9yEsbOus4ef/0rf51EQ/2EHb/zCvu4+i/O4DYK79Q5t0DN+s8+qTRsdJf+sUcSX2JgqUuSfccwR20krKlpEldNJO6Y/25V+0NmOhLU3q8dcNbGO3h5uiObDR/N/zQGfOz4jlMJaXNGb1hx2mv6PjaWGNinx0csznUsegS0pHmjs/Vx9yzc4uLlKS9SrQGKnZRKoX8hlQuxKhYFUz0bFexjj1UkD9eT5DUbo7OirhPSrr5cobmW32szfrIcHMPMi+mPCvW9zIYpB0UCswnAG+BVXarqCEKYLCUnMYTUd1NZtGVCh6c5wiQdT8eTx/uthBUfa6H+G1+uOie7PbhqY+PQ1n5Y8Z6R/9R84IhwBUrhqqPWI3W0AIaYyE12lIUdqYypa5V9U4dpm1zG9aFd+Or8gVoMMX/eCVuaXW9yvc3rjzPUDNCWYOcBSr+N6MUOROtBIDuhSre
 WEpae3qQ
 0crRHKZZND0WcvAKGHWmg9yvhBRClf0TPyx0UWvcarx6rKOee7Y9L18gX4Ly6fDux10coQv/go/3m68tmNAqO4eVhYqGSdPqLoW7D1wYxgGE6qmVpFRW0JSLuYJkSeYJalyDbfmwJhfnqJCQtbBAzUOgnI9icWTqzGpRd9X8VHjhN9sQmvSLoC2a1e8uqlhjbPqoctGZlRut/FiLtmfZcSfoIGDB1BovSI2irmgEXkQLR02ojnA0auAjVGCOyGdDnQs4c6zQDq9VdVJX1zM2K9TYZQd/llikR8RP7OW1WRoBK36zHRmm8QL8UBQx/mMwCrVYCUYmwjMtvVeTkCqhgeP01r5+wwrxyL1iA56Ct7SFhgByWOiIUHuZxBJH+cl8BEXyn0wGkEVCwdJOzmcxQkHmLf4Xl6YiCb/PXto0Aesu/7QtJZlJmxvy5rMd515CpZH4HgMZ6b+GdX9OJiYG7gV28mJyeVCM=
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 177FC18000C
X-Stat-Signature: 8r7bk84qjawjxfzg5y7dt1icmggppizy
X-Rspam-User: 
X-HE-Tag: 1789914323-772192
X-HE-Meta: U2FsdGVkX1+n0hmTp4HKCpE//iGXJv/BKurM9jqC5Ho7+uTYlax5VkKAqZqKeovkD+dZhnx4+K4eFvnalE85d7PfN0F+V5l1QNvR6xYdO7ADbOqW2uV9uQE7TUbEBp1HskMdAde+8NG+YmCNHmG2GlwzI++iUlgIvvpXC9uPwmWHkpt/NYTyb9QRoOPr80+u5LFAiktvTv5ul0+Smcs5J+2ohLgngHR3CurE14L+jCUzAAWZXWjGl62Fk/PLsGoWk4ouEECeU1fwuPfNXG/euPhgU1bI3DIo8EN8Hpv7VPTWm8VUhRy3YlQGfDBEk3XemtupbY3zdKUdFxuAX8+R76QC+DEE0CSnTek+LGWe7YeIMDrdnfuFgAsjRznLnbj3Uf8tocHI32ZnJHg2cauv6BNwcY1eYLe/WqfqeyHwp/K2SnifU8LdoWb832LwB9ot7MGe186ylefCMf8KoKcKMiYQ20J5CVC1jjn8wvSkx+Gk0D/uFCW4jhvLj2piJ8tp6t+cuafJxgCNtkKKS2vcunc8U+xqhBfan7pYqVcam1AeFX8ZxiohBpHEtVssEIVrjnMcrEUcuCzf1kLsrPCufXTmqfKl7OorHMg4/4raQb+Jmx6S9d/JRofScKGfjPzVeQmVy4m4Sv+lUfab/35+CSk8Nd9Rc10n1uYqBGOXGv9AFcbrqa5SVv+u0IKlajoKQhXrHvrnXPdLLV/K5RN4pTxIqTOT5GVxIvxRJVKEE41g4pKxB4ZgrJHEXJ/BtyyJ4pWumuOd2P4TUT+N21ETK7j8zJw3MPfxi+74+i4N+ux2bzP68pjQYm8IigJoktlbjlpHFSqKreLq699YtlDZ+e3LM5k0dgama+btDTW77o7Fnzanx1PDiFejogZp9r4ezVY0V4n6HRQRzAGGY/3c+tBR+q+v15mguPKro3GhCJuIbTL03puGUG393qHt9zr2aSi3hKuXbXH1ahXGWVu
 X+YoZR/k
 otmJfoA53OmiYhGXWzDcr4lxYdpqBel2wG+WCM8ajRklWVaLJzBuOsJIBLFOUfDEW1+Im+NCbqIArijBgfTETAUlds3LdYHO2puODt0sohVXX+111qxAqwLy5bmrofeohfqXPXoe0T6WBPe8DIkUQ3sDTVH3K7KKYWoDyM28zEKQfxh3Y9fukYdcBnqvnByqKEIDH2AeGSEI2MN6bdZtgJONCZ9sOrh7ZJ2c+3ol8RwRU9gwQu5nBEWA1iTKliuXlJdz+oZauE5b7faI7Kwkq2BRUCpE3X7b5PGlu9VAz8DsK9Kec/rktkj8ygXoE/X6FVSoHVityIUeyFG9HkG25lvJzGSz4cEuPwSeoEMc6JRkRIGkNzjd6GI2EhIK7V8gmK8ZDKFMBz31w9qP5ZkUeuosWQYlkR4iduZ3f8BbHnKloDHjss0MLz91KwyGR+wxBOJ9BPgjcEvlTyL6JKA01RpSZKXZKcg9VBGUFeOmg0ITryNED/j3wxucA+UPr6AkIKgEPAXzzLeYEYOINAVkzefV2WKhH9xKY84n7N0JJyOvzBUdqz36syVaR+c28dbTX/hxexvckibXE65yVwXJTWrSgEA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

shrink_folio_list() has grown into a very long function whose body mixes
several independent concerns: folio activation, the pageout() dispatch
state machine, the unmap step, and the final freeing path.  The control
flow between them is expressed entirely through a chain of goto labels
(activate_locked, activate_locked_split, keep_locked, keep), which makes
it hard to see which decision each block actually reaches.

This series extracts four self-contained blocks into helpers, without
changing behaviour:

  Patch 1: the activation block at activate_locked, into
           folio_activate_locked().
  Patch 2: the freeing path (buffer release, lazyfree, __remove_mapping,
           folio_batch drain), into folio_try_reclaim_free().
  Patch 3: the pageout() dispatch state machine, into
           folio_try_pageout().
  Patch 4: the TTU setup and try_to_unmap() block, into
           folio_try_unmap().

Rather than returning a boolean, the extracted helpers return an explicit
result enum, so the reclaim decisions the caller has to make - activate,
keep, or reclaimed - stay visible at the call site instead of being
buried in the helper.  Where a folio may be returned either locked or
unlocked, the result also records which, so the caller does not have to
infer the lock state from an invisible internal decision.

This is preparation for batching the dirty TLB flush before pageout,
which needs to call the pageout path from a second place.  That change
will be posted separately once this cleanup has landed [1].

No functional change intended.

[1] https://lore.kernel.org/all/CAGsJ_4wrQRGjqavMzWgi2+PrRr1ztf4QRZEb6HKm02OF8nEBUQ@mail.gmail.com/

Suggested-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Zhang Peng <bruzzhang@tencent.com>
---
Zhang Peng (4):
      mm/vmscan: introduce folio_activate_locked() helper
      mm/vmscan: extract folio reclaim freeing from shrink_folio_list()
      mm/vmscan: extract folio pageout from shrink_folio_list()
      mm/vmscan: extract folio unmap logic into folio_try_unmap()

 mm/vmscan.c | 376 +++++++++++++++++++++++++++++++++++-------------------------
 1 file changed, 217 insertions(+), 159 deletions(-)
---
base-commit: 498ee28e5ec4727f829507c4a1bde3ab1b7704cd
change-id: 20260919-vmscan-refactor-1b3e5588af52

Best regards,
--  
bruzzhang <bruzzhang@tencent.com>


