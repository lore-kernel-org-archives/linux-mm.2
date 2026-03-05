Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08BB2F33A68
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 14:05:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5BEA6B008C; Thu,  5 Mar 2026 09:05:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9BB86B0093; Thu,  5 Mar 2026 09:05:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C72B6B0095; Thu,  5 Mar 2026 09:05:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8BA846B008C
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 09:05:32 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 54B11B67AF
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 14:05:32 +0000 (UTC)
X-FDA: 84512182104.22.7F66FA3
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf21.hostedemail.com (Postfix) with ESMTP id 693E71C0008
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 14:05:30 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=DTNOn1z7
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772719530;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=HatgIhadXj1VMsSnMoyCYYLbIZ1AJxKhxIBxuKK6mH8=;
	b=Qr/25zlSRR7Ug84TLamDNK0ogwCOKHZf4i46cVICjwIduGfVEAykrfp/BYkSCvOide2gRB
	gyEpwfQLO1aSUAe8Xt4HmRV+g0fHnZ5ECqKtG+cI3vOmLfeMqosgT2abZUbXDr9T9cdEX/
	8DyJxje+bN7cZtXFqi2bCdd56k+k1Wc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=DTNOn1z7;
	spf=none (imf21.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772719530; a=rsa-sha256;
	cv=none;
	b=ay0XIVVejzJOp3Bnt7AZuAJ9L8OaTaXzgW1Ssvp8pahgw9bxMRBVG2MUo7JQ1oR8Vm+EYm
	MJFlUBMhbhsRCiOzVpwacz09yns7cPQhCorpyOe7hHWk8kV+BxUnZUw+YEqchttbuuHb+n
	fxxxWA5eRtUjAh/8Ljgg1Wg+5J3OTKU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:Message-Id:Date:Subject:From:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=HatgIhadXj1VMsSnMoyCYYLbIZ1AJxKhxIBxuKK6mH8=; b=DTNOn1z7R+pM6ugH3I4JrZ83YZ
	v01xrdSFjTJUFYF2Ev9lwQz+/aa8MCh2Ie/W0yRx1h7EYoFfojDybwxkFYcj30TDFhFmr4/51bF0r
	071/U+YxB4aBBnqL5rysICdEtepBqYEn3bSU0LOBxCnvKQVw5Jq0QdOJIdUtqoATY67vV5EDYXv9J
	YPPQxCFq4UG7ndp9I+i4BQEJPgDzq1jb8S7a+XMd9Rhg6Lo5e4c7/lSVMGVVy4YPPMFCuxnZvzEqf
	zVREIbXOH04k2QjWR08zCdxzmTG/TjndJoJFgvcvJ3IM5saljo0M61uRTBSeVefdJivXM7VzCmIh7
	37U7r99g==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1vy9KF-00GmP8-C4; Thu, 05 Mar 2026 14:05:16 +0000
From: Breno Leitao <leitao@debian.org>
Subject: [PATCH v2 0/3] mm: thp: reduce unnecessary start_stop_khugepaged()
 calls
Date: Thu, 05 Mar 2026 06:04:52 -0800
Message-Id: <20260305-thp_logs-v2-0-96b3ad795894@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAIWNqWkC/0WNQQqDMBBFrxJmbcqY1KCueo8iJZpRpxQjiQ0t4
 t2LltLlh/ffWyFSYIpQixUCJY7sJ6iFygR0o50GkuygFqBQGdSo5TLOt4cfosSicqYtsTfOQCZ
 gDtTz61Bdm++Oz/ZO3bL/d2LkuPjwPlop37mf9vzXplyiLCrUpcpLqwp9cdSynU4+DNBs2/YBH
 8MItLMAAAA=
X-Change-ID: 20260303-thp_logs-059d6b80f6d6
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 usamaarif642@gmail.com, kas@kernel.org, kernel-team@meta.com, 
 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
 Breno Leitao <leitao@debian.org>
X-Mailer: b4 0.15-dev-363b9
X-Developer-Signature: v=1; a=openpgp-sha256; l=2379; i=leitao@debian.org;
 h=from:subject:message-id; bh=dETmve0+UJCejeKyu16roe5rQRkryNOyhWapzFF7E2E=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpqY2Vkl/DNtd39cc3cRY+sFSAqTq60raX81JBZ
 JNEYsnI7UCJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaamNlQAKCRA1o5Of/Hh3
 bTUQD/0To3gZ32OsAW8GddzP6TEi6KT42deZzMsmr65OEUF2GKP+WwY239Oo8wpVpn4uSXa61pK
 fsUFxVK9iuFWWjoT8LKEhcWIjsVlmZFA/seTm8HGmq9Xm3O6ljiX3g8v15j0/WYqT2dwzX/r5RF
 fWkaf5oAlzPcgo/CHgnASFbegEchV2jsx1i7I64Gc8MPV/eRvShz9/wfBZzlM2dNV20nqQSPOQy
 1AbJkZGCe5a4ICrV7RH6bQMIRhEzyBT8W+xsRcYUk92yd4uJyFYXwcvniw2uis59Xf/KGb6lfgt
 i2B4NtXrNDcPGNRu+8ToOVTbrS/Bc6pPs+AaP0AH/MNU0gFl45YNZtEKAkAkDKvOikXlw46Ui8r
 MitaksI0YReCYLCa6BjfELvD3Nqf2IWWssaxr5/g7wSOyNIupw8VgTquYoMjqfoUX3FtOBlbOgJ
 bIuApEexWt7SPydEwbHKZ4Qfq+IAFIVlxwa8foD1itVeeI3Kxl9nUmReYywYMUUbflvInW4CUgK
 yfBniAyz2G4yfWqqknKjUmiajJ4D2TZKdZYU0Y25d/2nkWb9SYR6YdqaG3TXBpXhG0LDnQ53Fme
 dSA3XpRmowY11OMchPbhZvAIFNuq53/uaAOoPa69J5UzgeG3Qml6hVeAuMRmi/duxk7F+gcZAK6
 c4uPtFvy9O8OUww==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 693E71C0008
X-Stat-Signature: qsnz6pgaenamxhzfo9takz68baecyhsk
X-Rspam-User: 
X-HE-Tag: 1772719530-9563
X-HE-Meta: U2FsdGVkX19Pu7J1WrMo1xsTE236RhSKl9Ft6FUbCUbHA02WUwjlGyDTbMkd3Yqo2EGsywtq4pYVAXYqitYvIs1MJA+cjnlpb0pUbMlitP5EWAN9FuoIRsmCZ6SLT07UbN7E21K3vGyDldRwx1zDwoV9Qk5qCN+EDgOCnGt6ZrkTwjzBbVJi5yL2H8v/vgPy2BlJM+5AHVNT+HtYgLZJJbBRJW0RIjhgWN9pprBcm6gB8BYkV86aWd237RyOna03oS8oiFHqNcfmMBu0XzdVPp+eU7TsgswIo3jXK3jYb9rVZSlQzuKlC1TH04qkhzcc1315/ZX8yKO2UDqxkW45PDmY8jKLgt1T+cV/WgKbc27Xux6tEjMCCo5FxcHDKN7wXcB64SorTW7z0Z+vMyXxJMQ4y26feYjKd/7z3gL8lFLi5Y1z5rTSgJHTaEAuG0YJyZyvwxMFLwJhbB4UIgPkNITfFKsCB/RsHkCSjbk22TxTIRuqCvOlAwjpl+BPjec+C7yidLhhPCMKkPDEXsbo5qFmVhkFwe7++wEQl4a8zx+AKSWEKe96A/M+OWuy5iLi+tpKl2BnXPfCIc3ymXEMc76LMbsWFJIb3meGRlJvu5o9qt+RQUwCW0dkQiV0q7YDg5OM950mRotVGUbPSHFLZmXOJ1oFGk/c8ul31rT2uClcAgST1+/JKoyoC3BOalWbvGzXjOup79SAg3iVhg4D/p0jeu0prFXCB53llJC6U97ep73Jbnfz4YFWsHf7FpT2gaDxmgIS3CQtnPCc+iSgiUjDHQp4Hqu3uH5ldDrVdbuVP+HBK5uV56HZ1vd2BE31BVVUemhhhquYsI0AjQjyH1m+YUzSEm6356UBcLIMlZODFnOMQmubelKinUidpck14bffgpL5KW8rUOpomxCnE3guRe+4HmMz9f8Oy/9wfpDnyTbX3m9VW+hyfEMKtFDDMMoiMn2MK9TRm88Gj5h
 9WT82x58
 2w7yio5YbRwLUMoyOUmRso/ElSv+8WstKrsSP1XWEq1k8otGTo0cR93vWcyVxVNgZhJwW6iwS0iKcHPgG5oqKDExArUIBnOX8tJNwtPcTPs+jXn6HJwRw3x8f1Iu1wu39sZspxqtcS2DK0oCICNvXDmTrAscglWYg9eved93ObX8y1d6N5aQCiweVgshLL5juFzIBmtsUr3gxhYQWoZf24zBCki3+oNI1Tt4Guy9RSXPQtoDXwtzq3jCylGZEPoDvqaFI2YpwXXy3dDJXLmTw3O5eVg26M41ocTrU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Writing to /sys/kernel/mm/transparent_hugepage/enabled causes
start_stop_khugepaged() called independent of any change.
start_stop_khugepaged() SPAMs the printk ring buffer overflow with the
exact same message, even when nothing changes.

For instance, if you have a custom vm.min_free_kbytes, just touching
/sys/kernel/mm/transparent_hugepage/enabled causes a printk message.
Example:

      # sysctl -w vm.min_free_kbytes=112382
      # for i in $(seq 100); do echo never > /sys/kernel/mm/transparent_hugepage/enabled ; done

and you have 100 WARN messages like the following, which is pretty dull:

      khugepaged: min_free_kbytes is not updated to 112381 because user defined value 112382 is preferred

A similar message shows up when setting thp to "always":

      # for i in $(seq 100); do
      #       echo 1024 > /proc/sys/vm/min_free_kbytes
      #       echo always > /sys/kernel/mm/transparent_hugepage/enabled
      # done

And then, we have 100 messages like:

      khugepaged: raising min_free_kbytes from 1024 to 67584 to help transparent hugepage allocations

This is more common when you have a configuration management system that
writes the THP configuration without an extra read, assuming that
nothing will happen if there is no change in the configuration, but it
prints these annoying messages.

For instance, at Meta's fleet, ~10K servers were producing 3.5M of
these messages per day.

Fix this by making the sysfs _store helpers a no-op if there is no state
change.

This version is heavily based on Lorezo's suggestion on V1.

---
Changes in v2:
- V2 is heavily based on Lorenzo and Kiryl feedback on v1.
- Link to v1: https://patch.msgid.link/20260304-thp_logs-v1-0-59038218a253@debian.org

---
Breno Leitao (3):
      mm: khugepaged: export set_recommended_min_free_kbytes()
      mm: huge_memory: refactor anon_enabled_store() with change_anon_orders()
      mm: huge_memory: refactor enabled_store() with change_enabled()

 include/linux/khugepaged.h |   1 +
 mm/huge_memory.c           | 135 +++++++++++++++++++++++++++++----------------
 mm/khugepaged.c            |   2 +-
 3 files changed, 90 insertions(+), 48 deletions(-)
---
base-commit: 9dd5012f78d699f7a6051583dc53adeb401e28f0
change-id: 20260303-thp_logs-059d6b80f6d6

Best regards,
--  
Breno Leitao <leitao@debian.org>


