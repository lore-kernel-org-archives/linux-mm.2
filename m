Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6576C606D808
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 11:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ionos.com header.i=@ionos.com header.a=rsa-sha256 header.s=google header.b=OWxLJqZ0
Received: by kanga.kvack.org (Postfix)
	id AAD516B05BC; Tue,  3 Nov 2026 06:37:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5DBF6B05BD; Tue,  3 Nov 2026 06:37:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94D796B05BE; Tue,  3 Nov 2026 06:37:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 656946B05BC
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 06:37:31 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DA5341603D8
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:37:30 +0000 (UTC)
X-FDA: 85393607460.26.13C4FF8
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf31.hostedemail.com (Postfix) with ESMTP id 2FC4F20002
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:37:30 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=OWxLJqZ0;
	spf=pass (imf31.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793705849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SwDDfs8eS2UrIyJ875nz0ilkf79JUl413gKXLxgd0/A=;
	b=rc08GUV+7VHRORZC5Gkm2vwmzlBYiHQDYvrte34bQYUbHA+NtLeYj9TBTNWGtoD1tViyHX
	mU/F9nPVzamgG1MQQRI4v2UloJNF1/csuv1ZgXUBkJY3nRQjyJBfb6kT2GgtlOqcFYQnKN
	QgOtAf7f9jPQ/kbBUV/GzjqaNTuTTgk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793705849;
	b=KYk4Wh8/GsceZfKVkKp2SJDTtZ88UC+SMHVvBuKzyhV8OnkBHtALH+ZjZ/s1+IY1SxujPv
	FOZWssiR7QcL8+1sCwV23wC0kz0YNDI3yiYyY1p7Y9hlEUNf+eAm0GqD8m/y204apJW+Mt
	VyDhKI8aHyWVIl+YJ+uasvZJ9xylUlk=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=OWxLJqZ0;
	spf=pass (imf31.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-48e20ed3b9dso3575898f8f.2
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 03:37:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1793705848; x=1794310648; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SwDDfs8eS2UrIyJ875nz0ilkf79JUl413gKXLxgd0/A=;
        b=OWxLJqZ0ew1aOCvVrqZUpI8KssLVET+FvwCUBMX/qajC6rddvrQp2qK8GGqlkme5kM
         11NOOqmo32PjPbfotQW4me3dQ3EMVF+AzmN8H0LORsnwaq3ZiM/7Owvl8EH6DGEMKHqf
         Aq0sBjsVga4nze2Kbd12KG5aB7VbliLNwKPNPATdvbVzh4rigVU5sXCokFEN5+oTkum8
         iGkV2KOWF6E4mISi7TVF/WYNB8tEZ3o1JI54D2YZk1rP2uyiuxEZkn+42zeYuQ6HtRwl
         2ccFmFDWJ49U/KSkPoqUt4bV6ZxeP74d0Bp3MPu9pkHrLatUrXB5WdZVyr+F3s5zWHgT
         aKtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793705848; x=1794310648;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=SwDDfs8eS2UrIyJ875nz0ilkf79JUl413gKXLxgd0/A=;
        b=lkcngqwchPKbSCoej7CAHswvIxb4sSgyBd5wjbYl23g2JHlAToXeCKm9eTnw9sb0zI
         jW7hE9t3LK3cmG7LRLEqgNiowfqNl5G9Vy8oBiugHEMH1adlutpaqtCiGDzk4PtkoqfG
         jcytmVb2B1CcGjUC7W1mRLibMDJcP1N7nfH7YvVsX+DZwCxBMiDEka5GchcKHGURmO5k
         LdsSye+a2uUvs7rf2mzpEnW0T8qfA5GIefNflOSvQEkThN18p5t+SjzJQ9+NEgI/YGYm
         lxb9+gufOxK54SB5qnSuvFVm2Z0X6TGZPN6xnTlmUZiWkyBmo/Ps6wryGdf0Ic3MQTke
         Sfqg==
X-Forwarded-Encrypted: i=1; AKwUvBxK9Pt/+q8MC+7twGThhEHP9bEcn4hjy9wGkjBqehPfntVq6QA958O8eaqLuNl1yQKIpRY60O4cHg==@kvack.org
X-Gm-Message-State: APuU4Z+gfa8FDhIBDpqPEMSeUKfqKRJWIG9vT9kufo2rKyg4m07cWtAo
	iuaC+xhNuYTIv80johYgE53xP2n3bg3VG6GRF0jSsTVT6HTQIA8mKfgt0QoIP2IQ640=
X-Gm-Gg: AYBFou3SFcuQxbWrMamBAgDGYQE7SgLderc5YQ2bhOe0aovd6gjFdpkBtrRJVQMTxsb
	3Xxti4ZMouhisQN+pKoVb1BOMiva5lJ6IhV908jpM+LxAugpTuFStdMJwrZB168fSyjukJnj6tm
	qDJTHstxsvQm4fUoB64YznXzNVLHu40rkWQFLD9zRmWSSxiK4qFl8yqtOr7FYD3BmwjV3o/MkVG
	UizflH1oKB/DIFg2TTxBqwL63k26PXLZ6M7B/DfdYgVBXnGN9F4/HvUTI4Z2SEjWp4qFUtCtqmM
	PbD7s/sWcR6bPIQ5ikuDIP1KRxluB3eKlvce5goHXNpgcKKMZs1JTLLN3V1/ezW/vEW5ck1sXC+
	h6H0CswrmRa0hts+ikv2QXKC1WfnRHJ+cjpoQ7tuOHElD8hj3rqMXeXD3a2/OYjqs+RyQ1GSefu
	43Uh+p1Qn0fw1sFuk9Ij5J472WoMZVgr/TIdFPRvwbPVpwXcoSEF1wjJd+BP/BWUAEYT8BPG8lE
	QccJs5VvlEH7qKFWAwS/NR2a8/Fvzsyp5+5IUWbcJnIepLF/keyEw+bYyAu/nkfKLvLsildqwQ6
	JERt7FkcgedZm7W0yqRCB/nB9mo0iXMU8iz4ZgQsa0IRg7XVbN2gtjYiaPLBAVE5IbRwPc5cVDr
	Aq0fcPJYJWAxVxe6wHmuHspfxzOrhnQ==
X-Received: by 2002:a05:6000:400a:b0:48e:4115:f3e8 with SMTP id ffacd0b85a97d-48e6e50096emr30315688f8f.27.1793705847639;
        Tue, 03 Nov 2026 03:37:27 -0800 (PST)
Received: from raven.intern.cm-ag (p200300dc6f04b700023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f04:b700:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b78f95sm23000997f8f.28.2026.11.03.03.37.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 03:37:26 -0800 (PST)
From: Max Kellermann <max.kellermann@ionos.com>
To: akpm@linux-foundation.org,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	hannes@cmpxchg.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	rcu@vger.kernel.org
Cc: Max Kellermann <max.kellermann@ionos.com>
Subject: [PATCH v2 4/5] mm/mglru: avoid redundant rotations of young memcgs
Date: Tue,  3 Nov 2026 12:37:09 +0100
Message-ID: <20261103113711.1832834-5-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261103113711.1832834-1-max.kellermann@ionos.com>
References: <20261103113711.1832834-1-max.kellermann@ionos.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: a37r7t9xodcw3dp8rumtma14wpcoy9fe
X-Rspamd-Queue-Id: 2FC4F20002
X-Rspam-User: 
X-HE-Tag: 1793705850-316093
X-HE-Meta: U2FsdGVkX1/gApcEk9kgg4LOBujZFXnp3AH5YG5Ge9N4M+AobQiXXduucKjc/+Ao8j4byLuFCYJlSHNtM+E/r7PBbeZR3cJYb8WfiwYj6BH2qrD/ot1QgznJfKqb/+lVijKGwpQQfYLOoHBLVEydnJOgyYVFYuqKHMVTBq2EUbLOmLj3jOAtWwQGsTSbpgtGJsq5uIydHUQ/uClJ50B13m7W7heZ9GdyrtB5VaoxjLMsTatUfb04V0egzVOiPyJiXmfcp972yUTrpjNC6v/EWrLyvL3fhzjuTYa5YT6e+imw4keY35wfR3sKXl6pdUG2qTieaXXPyS20V0fMJz+yqsL9e27/v+ur1OKJwZyrVS1kwbolHjIxSi2IiodzVE57gD3kHakpQ3RqfpTYfUV+JHfnqC6m28qewYgsCkbtMGHZ+04/X9bNqq9aZ72NTmE3DTkXinZkiEGO1Jsv47kbi+LuzKNS4oLRZSiyiRuAq5tVt9xQyHK0PtI2+T0bmzdprGrvQT9o8IE0HliPEchK3yd7T6SXpj6rVOBQprb3KVnVwjBwXpSgbhpLrWR7ZhrN07xjTv4eTWc7knOlEsc1SWgeeaggyBKelFB4clnh+vu4T5gUdkNXsfLNjIB3wTkkNVt/8FsCZKdsteV9rNMReviIz9hoWwLDbKRW8MxRjaAclABSq8XC5dfRISkTnwwwNyYblWtDzw5aJ111ybdGh9rXxgrdgAeehhs+BhYBP17xDCLuOJ2hmIbh47RL4NIxrX8MZMJmVIZO0rPXwIzgNJHRS+//FYZCrYl1p8O3fJpVtU3s5E7pZuWCS7D4hN8VH3yeNVbIUJuzuE8B2VfPzKSxZfgqd2Z9cFKF23fGeXbRclvB36Wn1njVs5+RWxOjOqrf8cmYBTXeAZelksrFoK1b+Ai/EX6OrnSnmCLHKkSpoDeccxGkxdXW2q4NxP7WZZzMKwI2czxwqv5Fk1c
 WHucdDz2
 aRAbEw6t6DYMb167dGonQrMt3k5dPsxhc5jC39fE4vhK2nWhY+R3O3+YcihMCvgeKQ/U5VC3MRRlCbRAo392+6+LlgU8hbQxpiTKeuSkUXmh3LOXCn5TsqRbGdFvduP+KB7guKOtEISV3/kpoM6R2AQ7YSdq+NlisX8u4+438RFHtKoxVXE7zicMtTDUdyUNkmlgupBzyX34CCDUrEhJpCJa8/ZG3gECk5+Knqw09HBJTIXFVTKtpYgUqgS6uMTeAkETEirxEaQeL3V1dZ8FkxdVvWDTaZhEtj0jigib+exSYupC+bQhLpCwbLSQlPyHhn/3SIVkJIDn2eyM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Concurrent reclaimers can request promotion after another reclaimer
has already moved a memcg into the young generation.  Requeueing it
into a random bin again adds list mutations without advancing the
old-generation scan.

Therefore, skip `MEMCG_LRU_YOUNG` when the memcg is already in the
default segment of the current young generation.

In my micro benchmark, this increases the request rate by 36% and
reduces the average duration of each write request by 27%.

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
---
 mm/vmscan.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 3075949bf641..899f756bd15b 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4620,6 +4620,14 @@ static void lru_gen_rotate_memcg(struct lruvec *lruvec, int op)
 	else
 		VM_WARN_ON_ONCE(true);
 
+	if (op == MEMCG_LRU_YOUNG && old == new && lruvec->lrugen.seg == seg)
+		/*
+		 * This memcg is already in the young generation and
+		 * reshuffling it again cannot help the scan of the
+		 * old generation.
+		 */
+		goto unlock;
+
 	WRITE_ONCE(lruvec->lrugen.seg, seg);
 	WRITE_ONCE(lruvec->lrugen.gen, new);
 
@@ -4633,6 +4641,7 @@ static void lru_gen_rotate_memcg(struct lruvec *lruvec, int op)
 	if (!pgdat->memcg_lru.nr_memcgs[old] && old == get_memcg_gen(pgdat->memcg_lru.seq))
 		WRITE_ONCE(pgdat->memcg_lru.seq, pgdat->memcg_lru.seq + 1);
 
+unlock:
 	spin_unlock_irqrestore(&pgdat->memcg_lru.lock, flags);
 }
 
-- 
2.53.0


