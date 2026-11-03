Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB008606A33B
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 11:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ionos.com header.i=@ionos.com header.a=rsa-sha256 header.s=google header.b=gHW4SUQN
Received: by kanga.kvack.org (Postfix)
	id DE13C6B05BD; Tue,  3 Nov 2026 06:37:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D92856B05BE; Tue,  3 Nov 2026 06:37:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE5946B05BF; Tue,  3 Nov 2026 06:37:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8DA046B05BD
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 06:37:33 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1C0E2403CD
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:37:33 +0000 (UTC)
X-FDA: 85393607586.04.B2666D2
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf14.hostedemail.com (Postfix) with ESMTP id 38E7C10000C
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:37:31 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=gHW4SUQN;
	spf=pass (imf14.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793705851;
	b=uST1YlMzAv9mPJyd/nmOj5vYWdEzLQs7aWc1To5JZTRmJJOVzU2lhiy2cMhH4KYH0eokE5
	Ax+/uiEtNX48SkipHRvsHkLjz56q+huAoamSoinQKyjt3Y/EwzYuMirSMnyVo+ECW/jKUI
	jneCAbwOAtojThWy/Wva1DFDHYiYTpc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=gHW4SUQN;
	spf=pass (imf14.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793705851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IsKP26C+4uK+emKCr1xcjNZltVUV41qm/vZF8BC5G1Y=;
	b=uaHOR7RI0Q1xKYfrng57G6DPtS0oi+rC3rF99meq0KVykAJ+Y/9sRxmsVJPsBRZTJPizGn
	onNahCpQSkHbzqI1tmmHoVora9ss39dsMOVYY8DLTjproWG8Dj5Zuic5l7eNnNhVBrbpa8
	yYwGTkbLliYIl1zI10TIB2banlSY7ss=
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-48afbd2c386so2350931f8f.3
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 03:37:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1793705850; x=1794310650; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IsKP26C+4uK+emKCr1xcjNZltVUV41qm/vZF8BC5G1Y=;
        b=gHW4SUQNxYQHCKGVFiEz8H0TpFtmDWpow4PW94iEAeQMjbcN1Q3K6N/vgMGjz7KlSY
         0WYMAr7FhMAIqnsNoTQew1YMBUpJle+IzOm6SkKyNX2nFq5JMWyM1AJtMJYClTFKQJwo
         N+EtxzmqYWewyF1l7TwRHO4jbd6T0X5xiIWJUpW2xp7vUQcj+dCR3lKwqJtO5ECPg9ob
         24squE7mpweRGJbHME9xAW6XXHI06ft0iy5iI4DXIqVkfhYvcxWSeVEax+f1utX7zy/P
         mYP/lbgBu1Ph5wg4Uz3gnPkVoeEuj27ffI0qDdYuRKfFjOJLng+FgkxU10ejwWmFZlWM
         225A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793705850; x=1794310650;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=IsKP26C+4uK+emKCr1xcjNZltVUV41qm/vZF8BC5G1Y=;
        b=NSz45mMU4kKS2j0H/4VfF9hlNfybIo5O879NEEWca2doOZkq1nJamTlwNL+UaAZVf/
         yJMlS+53De2GTjzUdoGcRsZbxSN2szM7cGwRphauZOmuPqUd6KEvC2iQ5yfiE5SVwarl
         6LXERCqQ0B2KApvMFL2FlWzR00sCIJ0EeD3HkstUmongkJc3sqvm8hcR2GGlfchOvUJN
         51/VLYUDlu5FDQcAd+YPA7nZqwWDZZ0qiezPYpjQhR1gyGshh9kEE32shP0YKQdiYZtX
         fsfkJLd0mvTsLCeipgl6j0Hx1+8r3Nvw7zop/fXsGkSR2Z46o3dmO2jZ+7yrmkako4jA
         vYeA==
X-Forwarded-Encrypted: i=1; AKwUvByMvNl+Dgj9WyycPb0l/2OidoU6haR0V2YzbiCWSmOpl5Yz/m86E6bZe19ywMn3OuZ0o1cOrYE6Kg==@kvack.org
X-Gm-Message-State: APuU4Z8lA3OQdMFiFdK4nBgazFAoAvWaJJ0M5aq9baFrLlIgernRXNTg
	PuyuT8ZulSw6ExJGRP4RPHVCwg5gXD800A7FgBP+KbGZumR0A6DVldLyMKdbrNSxLXk=
X-Gm-Gg: AYBFou355LgERaDQ8dIA6WTve+7e1PWQmxRsjxwcjp7MQD8HCO7V2X5KR6/gclBTe0V
	sfypDQzNve4d+DUpPTxqVqve+Qdc+99GrQ7o10Ae1aOcpJBHy54OhBzNVbiD397O7UW2YUVZMEC
	TGIJO7/eN3K1vq+x4OPZOxCtIDWh/V57utrHLnqCvtQyyFYAzEAd0PeqazdPmDkJKIm3F2gRQlF
	LYH7lEjp3CxuMjYTZ0U4IDKiNu9bFCrBIuIhSoMWQ3vyoCeZd5a66XoNM9qP2zgOCaNoYfjr6ag
	lyogx432pX21dSM+bFdH3hpKZ1dVZzJQpnNxggrCpsFdLMnWIYFGj3H1gbyx/IWuO8GkHv8mdpf
	ogCfFk2l46uPwfQ73Vu+oFS6GrnBymizMAKO3TwJ0ttkH06dGfwWyWBL7c4qrLfqwj2dxfgGH/Z
	vJmVXvy0YFIDrXcxQ5ZIu4z7V/CgAPnayn3d4atb/wXM9hd/5hiPGRLqqD+LOWdouA4K3V0doYg
	61C9Dr0Jw+4MiePWJKT3m2MGY+uD4wEjr2mmAPS35ir//B+NDBzfRs+g61LHSatc7wBn6ldXakA
	de3A3/8KaZNlLRL328VYseTHk+bezSxj8J3akEZ7HAr2voyxJ1c8604r3qMfAeCwraxotgcBidt
	vT1ubIAG3NCy+mAaLF9CEtv0JiLCpsw==
X-Received: by 2002:a05:6000:240e:b0:48e:76ab:78f7 with SMTP id ffacd0b85a97d-48e76ab7f2bmr21607663f8f.20.1793705849795;
        Tue, 03 Nov 2026 03:37:29 -0800 (PST)
Received: from raven.intern.cm-ag (p200300dc6f04b700023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f04:b700:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b78f95sm23000997f8f.28.2026.11.03.03.37.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 03:37:28 -0800 (PST)
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
Subject: [PATCH v2 5/5] mm/mglru: reschedule between memcg reclaim attempts
Date: Tue,  3 Nov 2026 12:37:10 +0100
Message-ID: <20261103113711.1832834-6-max.kellermann@ionos.com>
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
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 38E7C10000C
X-Stat-Signature: pg8dfgafc3fp34w9s9tx9o9iqgqyqtpb
X-Rspam-User: 
X-HE-Tag: 1793705851-51665
X-HE-Meta: U2FsdGVkX1/xXHVITl/pRgDUVrBC2jltzHVpmN97NjaCYwSG/JCmm01wBy25ZTpVBQISusQYY0047nENf7zJDtxEvIKy3pyAihAkKMTNChRe0pQPBVVeCkeD/PgBULjJCHFG/ENPiGNRMCZwp+a07IHpehSJ55aX+99rj8E874ZiYGsPmbXQpjjAeRwt2G4SAQC342PwgCl8nDmUhe9gX5tvAkSJLwTxFYpwG1U9zU4i7Z+R5Kw+h48Y1BZYe97Mhmqq2lxiHFn/oRsc2qixmQhVuTvPiy+rjlqLVSbnBWJhT1xVIXDj09M+nDaruE+G+ScMqGKC2qIWUeFXCRGC+J0BryPR990Vzlwmfg/agIFfsyX8+Jtv+RzdW2QUNp/41tufNk2o2yoHU2JiJyQmltmtwPoYMEsjLM1xsOFvqYKMZnT0uk+4RY6YCor524iKOBwayHqKYICTWUGrrCAS3TCPFWqMKq/u32Mkgs6qqH8U8uKRAOi1fMbFchRC1qgxTrfIqd9MOdy8UR28rQDZ62JxtM+eXP5a4pE+TMFr2J2hthz0fzPGhx1Y/OlXe1a9/wMVZu4nftBK+T2TzSMVNmkC1rM4EELcCH8mVvA6iA/mqFQAvld7dEUW5Qw6x0uc3jv++vF3o+cirjGROOugUENLbfjhzxrmG4JtudR9IFgkGtank3/zQzM+kzl4kLyvwxogZCvHVrWfHXlzUuSibVgOf9dSJCbxdQExv2QvygiyJ6zUiWwE0EXIQpJBJ7ZkMnZj+DrXyGjoRxwcGg9aMBqxcGzcqz+gpy3ZPzkPLFcTceIn3771bBZDdaaDBvXPyQa92oPtBdeEiYs4STx9ReFwa4YeHmk49snDACYgTFHwz+o5Uee1ZVEcCAjFRhjrrFSvFkj38wAs+c5kedGXriT3WtTVlvob5ZzGXtJBgdG29zM1SWKqvzbLQSm3AZnY02ULooezO8HOWcZ9oBr
 IhDE5SRz
 A/EUwmiD1ixb5uECSjta5FqdjN0ktPJ2aPePxOKsDJ0ONYJ8hFgsTuL4EY/EPDEYKoJL0BEobW5gqgMhi6+3lkwAKkMU8J63IzXnRZsEiB4REnst8QvNlKlhL5BjeXCXBwrQFyDVefAQrAiqKnqdrZlbX5gcpl5Mw3MQUAlLWgKRlVe5hkF7Tv27ScfF4F40ZwyzWE1UVBjkr1ZmCiGjof5tWFjK0uceenlZiFdSGgQxCf6tVkaGEDbLdrQIpamxTpJJBJk88evIGe0u/oJnCNMLUrjJOdX1ZjdZX1cI1/s2gv85iC4NavgI/1dlBVqUPuy9+Ayx5uCd6+0TF106VT1yklg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

shrink_one() can return immediately for empty or protected memcgs, and
try_to_shrink_lruvec() can break out before reaching its
cond_resched().  A scan through many memcgs can repeatedly rotate
entries without giving other runnable tasks a scheduling opportunity.

Call cond_resched_tasks_rcu_qs() (as the existing shrink_lruvec() loop
does) after shrink_one(), while the memcg reference still pins the
cursor and before reacquiring the RCU read lock.  Also call it between
bins and nulls-marker retries, covering scans that skip every entry.

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
---
 mm/vmscan.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 899f756bd15b..5dc5e698e243 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -5395,6 +5395,9 @@ static void shrink_many(struct pglist_data *pgdat, struct scan_control *sc)
 	gen = get_memcg_gen(READ_ONCE(pgdat->memcg_lru.seq));
 	bin = first_bin = get_random_u32_below(MEMCG_NR_BINS);
 restart:
+	/* Yield between bins/retries that contain only skipped entries. */
+	cond_resched_tasks_rcu_qs();
+
 	op = 0;
 	memcg = NULL;
 
@@ -5425,6 +5428,14 @@ static void shrink_many(struct pglist_data *pgdat, struct scan_control *sc)
 
 		op = shrink_one(lruvec, sc);
 
+		/*
+		 * Empty or protected memcgs can bypass the
+		 * rescheduling points in page reclaim.  The memcg
+		 * reference pins our cursor while we yield outside
+		 * the RCU read-side critical section.
+		 */
+		cond_resched_tasks_rcu_qs();
+
 		rcu_read_lock();
 
 		if (should_abort_scan(lruvec, sc))
-- 
2.53.0


