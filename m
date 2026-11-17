Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6798C606A323
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 10:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.a=rsa-sha256 header.s=1a1hai header.b=AM8wiTwT
Received: by kanga.kvack.org (Postfix)
	id 5CBD16B05B0; Tue, 17 Nov 2026 05:25:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57CEB6B05B2; Tue, 17 Nov 2026 05:25:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4440C6B05B3; Tue, 17 Nov 2026 05:25:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0B3C56B05B0
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 05:25:14 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5533B4039E
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:25:14 +0000 (UTC)
X-FDA: 85444228548.26.DD2FDFD
Received: from outbound.st.icloud.com (st-2005j-snip4-6.eps.apple.com [57.103.79.119])
	by imf03.hostedemail.com (Postfix) with ESMTP id 60E2F20006
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:25:12 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=AM8wiTwT;
	spf=pass (imf03.hostedemail.com: domain of m.harisawan@icloud.com designates 57.103.79.119 as permitted sender) smtp.mailfrom=m.harisawan@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794911112;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6HU+57MgwQIYqvbSD+KkyYtggnx7khmZi4J6g6F0SBM=;
	b=lSrZgaCVPxqjaxYh3NVdsnsovXVN1kwDQWVl6S0IslzJmGHy1a2LrOQv5OOZzQj7/KItxV
	GVk+wuqdPRM4eFFRFUghIEp2UsKSf79mewqbrqttB/OgLzetF1edp8wbj/gXrvujPPS75l
	R3m+HnZAiIQP33oSrVMXBs8efdMqMtI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794911112;
	b=osDBAkbIkLeczWq4JeldEnBnLHFZ0TnZrTQ+3Fi3/M90ewvVKloPjwsGQqYaMoKqNxUqyv
	WIrc0M9YMpKiBmJch+r9CAcUuMWO55GydmAWgkhKFNsgENSY0zmI05/5xUEGmekFDRBvfc
	8W012U96uMFVv7vWlBcPgrANMmp6KuA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=AM8wiTwT;
	spf=pass (imf03.hostedemail.com: domain of m.harisawan@icloud.com designates 57.103.79.119 as permitted sender) smtp.mailfrom=m.harisawan@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
Received: from outbound.st.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-1 (Postfix) with ESMTPS id 14D9B180018A;
	Tue, 17 Nov 2026 10:25:06 +0000 (UTC)
X-ICL-RepId: 01a1e909-f7b8-7aba-8bfe-4e3cb1e1c272
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1794911110; x=1826447110; bh=6HU+57MgwQIYqvbSD+KkyYtggnx7khmZi4J6g6F0SBM=; h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version:x-icloud-hme; b=AM8wiTwT2kgzq0qGpg9lrsxjguZZtieuJZW7JvrFoooosWMv4SMUEhU5xjGghdWM4MozLnOh3NBSKO7eNTNMdkUB/86jiSRtNTXBKiPFUmCnOr75qw6W1GzYJH1BPGqS0ebRk2y5q+HTiJYyTwuUM+naZFcKe74d1jMAjFAwwl1tmPxOn4krPsZe6+OtVXT4aGdGngwlvvQAc24ILE9bkggUMGYL0OTq1TShVeq4Cq48MmY3zwjq5nS+slv3mAIIEYQJGchLvPFx27SLmV/QH9bBZvNAGiblohpO7VDZJVKHkKl95Nb1ktzuF0NpwB+I0rikbnV5NMqJ7ENeYpVinw==
Received: from [100.126.217.91] (unknown [17.156.216.30])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-1 (Postfix) with ESMTPSA id E6CB41800185;
	Tue, 17 Nov 2026 10:24:59 +0000 (UTC)
From: Muhammad Haris Awan <m.harisawan@icloud.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Kees Cook <kees@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Liam R. Howlett <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
 K Prateek Nayak <kprateek.nayak@amd.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH] fork: mark memcpy() in dup_mm() with data_race()
Date: Tue, 17 Nov 2026 15:24:51 +0500
Message-ID: <179491109101.4015489.11185824873441987133@icloud.com>
In-Reply-To: <0b565b9c-1462-4fed-8836-9a7d08e4b861@kernel.org>
References: <179489519663.1444496.15875846661591982934@icloud.com>
 <0b565b9c-1462-4fed-8836-9a7d08e4b861@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Proofpoint-GUID: dLUepeR5kMZHEWKIZIgDJCajbB36wGcv
X-Proofpoint-ORIG-GUID: dLUepeR5kMZHEWKIZIgDJCajbB36wGcv
X-Authority-Info-Out: v=2.4 cv=bISDs/+Z c=1 sm=1 tr=0 ts=6afc2b85
 cx=c_apl:c_pps:t_out a=oyWFxbOnq+dmhQrAPgaJYA==:117
 a=oyWFxbOnq+dmhQrAPgaJYA==:17 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=x7bEGLp0ZPQA:10 a=2kFROKt5_e8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=EYaFdmsEC1CjpenOt5ir:22 a=5dLkQmbtQYkJk1E8iZFh:22 a=4JPYJV-aiw2Kicj_3zUA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE3MDA0MSBTYWx0ZWRfX/OdPMQ5kwIgE
 TuhCSlT+3ixpEUjyETkQMRHdmLgESeXzX332IgJa5uXhSPjwbVYx4/bX2x2SxPTlZkugPkDIxAh
 hIhGvRHYOLGPCdQaAqeMYybHsPbgD45iwudm4vplbdNBlb1kPaWv6s2uSYTgeo/iT6UWBo5I9iC
 lpA4BjXL9eolAIqInQMZsqEs0KprTBlu3AI0/B5HvxG9UiWoKYsQ6mk6IdOK8zUEOLHNnX00w5p
 WXqSnBTxn9Tmim8LzaC/E8XjdwNslvb+5PotXqMDCg37xQVTMzs8Zbf1X4pQlvCZg86o7FUbThU
 wQ1DS984QvvkkDRl5JWNwb//BMAkoAqm3RPIJLXWz2jxNmSxBbgOa23nniH5L0=
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE3MDA0MSBTYWx0ZWRfXw6Md+FSiYDc3
 8ijTF810kZOWVKMShm9pjt+qHDCOJhFeyC1cAOA7djBjRi7lO3pRWVOwfHr1F7ZIE8KczXtu34c
 Xd02MetYgufJf/Je/tAPrExnQZxfi/I=
X-JNJ: AAAAAAABHYM+2uoVCH3FWr2d6COnBYmqzXEJ9EdGxFXkaqgX8h0Elg7IKTgfa9d7SkY+Eb
 Gs1vkcPuAsrxpNoTdivFvSLKa9KAsYjzkkP6XrNeworQKUBwXrI6d3frYKk5Oab197zGRb
 Y8AGDROudb5WqF6e6mzFIfvDAYy6JHvWgZVgw1itAPNh8oGmU2AxH+mnxNICT7e4Sb3hGW
 5aaojbQr5cNd2xrY5vRIwD0KKgZFQoV9ZOkhCAYQd1U5jG7txzW0Z2UrafE+HJ8Xoo47WI
 zh14Nz+gVqxTrNDddQ76x0hDN+4kbJrk+s/LIDjjTJA4PE09PgYo8DeRMBWtLy+sBNHIYM
 dalCl5nTxKlC/ctwlOqTiVTV8xGMyNmHXFB5AH4CR8TgJqoCY6mo/w0Cs9Z18JjZ+6k33K
 KL5Y7FF1umXQOc1NxNBE5MvaHHywx9OANDUK/D3+K/WjfP43/N0iW5uRJJEJqMsGrDR1su
 ge2BQuR51Ejcvhk71cFSzQ6j6MdhxKTX2WSKs6XX/orYdxHYuX2asYKlELnhtwOpiEVGn1
 17glkDiYRq3hvP63HhX3Ar1dlwqj8xQ3vZF8XowRX1Sg0Ag2clFepbYae20LugpmTpuh3l
 gYqn3l18rScJZMWxfnskJVUxYw3Cta585ZUzKz/q+Mtz1L/roQHAZebxtxJ5iEpnZlklkj
 BrmcCkGR9FOhZEpcdpxhpAPO0wS5/GcqjIkzj6JkXNraeahAeNIBko8Pze/f/OkiLepssW
 F9e5mCv+DQ9/aG0CC20917u6RgyXvuvQeTV4bSC6McEzndL8xVLGM5dFLwMKhzjn+baHwC
 dHDFah+vO9iO3uBsk3x14NJKi3qYSrhirXBYne2lXBYSHhQyeuBDI4XXTGJ6F8V5gC+55z
 WVNEOk/mwO1bSBKqQx4ymGApYDtlWdGBCircbCB2h2oJge4id27xUJ86p4ocO1dyoI3IcF
 oYX9v53iEmT+W5pJU4O0Zxb8OMwoo9ZK7ab+tBuzPhDS0Ahm+Mp/5lOmecKMTFm6hDp9P4
 kqO0ZKb4VkunioE5+RSd6+B2fchJxYKQJEczHtznJZp4ojcp7gBnd+bHE1yQPYy1RmsCfe
 VaWENMKuP+JhSa4Pu/6Df50yXqzsFuywHJE0vpPST+2YJiDak1REX8v0zdl+BjiVBjLmHa
 3l47K/zH2uRnPiUAzox2ipm5kNP7MhnwKpxMoHDBL8/KxPxwxjmxo9lVZw37xGS2ORv+wJ
 riuNvxv8KLOjYEsuNI3/NWfJ3JT/dQ3WKx1QO8D26pRgSW2Aznl2tUNye4OJFIOmesVPzH
 f8kgEw6QGet70wegw21nJUQ9/kQpU5YpVSr522RR/ED7FtesZIUypJv4tRHXBPfHUyJ+Rn
 Je6Nbl8ES1UTOPp1PfH5TLZ9PkJpLmDIMlRRv8Z9sOJdiAho3Qo34rLYbDqr6a5G920szW
 Kz5XKxDQv3xCEeIu1cedvHTImb+nTiQ2u3oAaP2jqqE6c3gZEgLp/qpHjL7j700DRdi14r
 /ZiMfRQY
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 60E2F20006
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: 7osd574em5txxhooxa7cdooghhpprwx1
X-HE-Tag: 1794911112-691367
X-HE-Meta: U2FsdGVkX18nyZBE7ORE9odb+kOVQPg1cjA06ndbqI3cxyi1qVKi3b2MIXdS02fhMHB3vBuJwIGle78CAOVBZI6Px8+p6A19wqpDoDWHmJDXXXuUogyzGRvqMg92QwhGMdWKiS1EHm17//np8DRPgKcBWXt48trFYV+LUw2dvN6/BQm62mpD67G58nY/74nubg0eLiVp23gZwpg++/A2KLOrV1qMkJDUPETQDJx/jHRU41jv8Gb2UXuHSOZjCm9HMFUef/qSpMRI4kVGStMHmMBzkA+vBut4l17XmEdhwoFL18iwVEf/9VOrPZjJ3bDGbKWJuXmfJ1NjHExi5OY5oqY71ADdyuVQXOSEVZGxIbL1feAot0ZrfyLrqpMtw+hAkB3E8FD75szgi1vkqlpre5cqVMIDMmWlNvYKMkXmZlIY9pNcpOu8xAlJqlV8DEBLhqCe98q65cPtrM3jpAdGQ7dWV9qHYp6c6LIq3NOGGtsJT1rWmP7+Wz2DchuPqWMgp58lcPP5VdLaGCBmes1d3i9CoEqwMdR2Kx9R32dtXnsx1VF2SSAPevDKjNcLA7TVuummL7oNiJaGWicetsrtOpnl+tNNCyltVSS3WblDtJ4e0EQsWmKKUb+2a5D2tuFRTFg4yl0qBMuKQvIYxHlhc6dqDOH8DCAAyW2hLHOGexsA2PDQuUwZiev8XAjj2/bWl+iBdvfMZJ91q74rTxhbpq/s+Vm05rdPPFJCfWMNB/jY5ApFnBQAz5RDUGD9/ZoBODUrGbhsdomokd20QPvLodVOqqGRdfoXANhZCVKJq7A/G3/+QAZvyeVaX/l3gveta5tqel4OmVaB0VAG8jlSDmwXCo2PEM95Ujy5mJxnwqOUtXsbKaUYlswDoVKMG8L1fBaDNybzBjG8o4cIHtub2RmGeFLYuAm3qN/o+TMJCWSCm7pf+XQvqiNhsdny13htwclb/3iKrB2pw7Pgx1o
 h3sCj6dB
 1vshtenDUk31AxAnkaYkwW4BweHaRaAMdX5qLkL+cB+fKIdv2uIE+IuXqgNGAmGeObQ7PLu+wFPm/1XONnwLYbXrXCLTN3C5r4ZCF7P5DIBD4kdz+8QpnbDbptscQHxHwyP0sxrVTV9DbdoB5xtBDfK3zE0xvL4CSwUu7+VzQOC14fFs4pFc9T6zKDwg5HhZm6doD2Et1X7AYPtnsk+ulCTOjQpkT8Me8UmXfWaz1lPvC6SF27XpMxUJQBG4reaIx4qVTkhTRNqpvTvtua7zJY7yLCjqsA5a9c/k0n8XsNbacxd88VaGmJInEGsZOdKobmHqO+ywIiP8ysvi6PgT/WX6uvDSP6xl6dLJcG6LjdqMqjuCXgvs2UziH+HMVjH0NqljGsY1nvTBvFlI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi David,

Reclaim isn't touching the new mm being initialized (which isn't added to
mm_list->fifo until lru_gen_add_mm() at the end of copy_process()).

The KCSAN read is on oldmm inside dup_mm()'s memcpy(mm, oldmm, sizeof(*mm)):
oldmm is an already-live mm sitting on mm_list->fifo, so when an adjacent
exiting mm calls lru_gen_del_mm(), list_del_init() updates
oldmm->lru_gen.list.next/.prev under mm_list->lock.

Since oldmm is live, lru_gen_del_mm() has to update those list pointers.
The alternatives in dup_mm() would be taking mm_list->lock (plus
mmlist_lock) during fork, or avoiding copying oldmm->lru_gen / oldmm->mmlist
(awkward because struct mm_struct uses __randomize_layout). Wrapping the
memcpy() in data_race() avoids locking on fork and matches dup_vma() in
mm/vma_init.c.

Thanks,
Muhammad Haris Awan

