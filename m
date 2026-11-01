Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D690A606A324
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 17:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AeIt+nB/
Received: by kanga.kvack.org (Postfix)
	id BD8E86B05BB; Sun,  1 Nov 2026 12:04:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0D016B05B6; Sun,  1 Nov 2026 12:04:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D51E6B05BA; Sun,  1 Nov 2026 12:04:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5C4136B05B6
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 12:04:59 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B2D81C095B
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 17:04:58 +0000 (UTC)
X-FDA: 85387175076.20.F81928D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id B20F01C0010
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 17:04:56 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="AeIt+nB/";
	spf=pass (imf21.hostedemail.com: domain of devnull+vrilutza.gmail.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+vrilutza.gmail.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793552696;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jaNvTICrxB6ZQEsCT6rQeT4YxzmEYHhNdvsA+92xchk=;
	b=GpVGdMPfSxg68XtHKvZI1yLwQ090VOF1v9ZGOcsyK/BseW4T8dxihAlIIxRKtAvCBfMhPB
	VJt7LFTL5UUCC6SSf9kioyP6AuXdsA7op8AZ8754dCM8yTyDAkk/EEVKzo8RoRTZYqiJuM
	Z6PfxMyvmX4DzekBUr1IPrljBSyU+bI=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793552696;
	b=u/2Xb0iVVPg6bg406PGETUE9EjE+nLsz48TfCsSB2Tdrw14DMZZIIUewZLRvBpv/kkszgg
	apMY/9y1om9FQ03oV1eGQ3oif54U31MWJV/M85dclJqI9hSBmYzFV75YvpxTJpv1L0coNl
	g0BmNxsW8M6xPvmSp/TTEHnQgZGD8AA=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="AeIt+nB/";
	spf=pass (imf21.hostedemail.com: domain of devnull+vrilutza.gmail.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+vrilutza.gmail.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 43AFA601F8;
	Sun,  1 Nov 2026 17:04:56 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793552696;
	b=w092sqlrhiZMVihGoz/UO1ubiJCDDdh/MTLSc5i2Kp/NakQjOfzbm7/jmaaSmL+dQ1pj
	 Yambc+Hkdo1/1QC58lGxIE1w4a2t9Th3QSJoyw+kcGxwcCWJgMkyKAK3vKGDXd6wCtUEe
	 OZOIzJ4nKH3c8wVYCCd3LW1gmZnNS0/SBgNvc4WCROaQLE2EO8bRBJ6Now0x6Of6424vP
	 fViL8lW7eVfcIdiFi4d6MDv4wM06S4VnhifP02LuFpqyE0hJ4h7+LCwc9wfX8XZ4z5Z/S
	 Zrt5knujBBXjh2/LW5VkN4aEuKL02xC8UfLeluD6WFJ7BKi5oxDroFqsadrN1Fi00xA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793552696;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=jaNvTICrxB6ZQEsCT6rQeT4YxzmEYHhNdvsA+92xchk=;
	b=0/toclBpVbmWX6OxMQfE7RSpZaB8xVkCAxH+HQWHYK9gQF2C8bY9k7GPJUhZtoeRwM1P
	 DbHtwNrp0i3Bevp4Z/F1cI4Bz7uMVmWIwLVnQfJkL0XiyMYVGj2YA/bY7y2XvN2B6V9My
	 Ex0vaE6S/zHuVbzcv0qhD7oOJ6/d87YiPCHIQi04kqeZMfiws1TmYADNkLujaLKwxM3IJ
	 1P0X3+y5NURgM4537HtsZKGT61D3So5HzopwsLoQ2+bTfp0nHp+5cN/ANbDgsFbABovio
	 v7X12ELOfQJUZP7i4fBVHH1d5XYhVMClPgrnzTAsk+JMXPiXuUKpGDOodqMFQdn4h/A==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id BB5041F00A15;
	Sun,  1 Nov 2026 17:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793552695;
	bh=jaNvTICrxB6ZQEsCT6rQeT4YxzmEYHhNdvsA+92xchk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=AeIt+nB/z8mBm3H46VKVIg8qKaltx/qyuOTWtYLjPDXVasRaZ4oa+wVdrFdiWeFn4
	 HlzAAoynzqLDGcT6RYyffn/L+aL21Coi+TxYvXAqAFPzY1bn5jxQrKHfzAJz8yxL1E
	 DLl6I5V/39TtJFSd9xvoZgM8Niull69kVQTUnf0X87gkBCFQKnlpXsrkTTemE7YYZk
	 wpGiYZTZVtgN4YUOoBb+60BZquUWxoRmebSjI/EOqXN6nUmJiaekUq+U6XjIlbPfeZ
	 SEiCKvZbzgeJclrdn7PxAwFar8Eqn2PLFBk5eBSzyHJUqdMqw0+wxLaLpR/6qse9LU
	 H3odTY/aPiZkA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 3E25F4620F;
	Sun,  1 Nov 2026 17:04:53 +0000 (UTC)
From: Viorel Cernateanu via B4 Relay <devnull+vrilutza.gmail.com@kernel.org>
Date: Sun, 01 Nov 2026 19:04:39 +0200
Subject: [PATCH v2 4/4] x86/kmsan: Don't call instrumented code from
 kmsan_virt_addr_valid()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261101-kmsan-serie-v2-4-f97f66dc57ef@gmail.com>
References: <20261101-kmsan-serie-v2-0-f97f66dc57ef@gmail.com>
In-Reply-To: <20261101-kmsan-serie-v2-0-f97f66dc57ef@gmail.com>
To: Dave Hansen <dave.hansen@linux.intel.com>, 
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Alexander Potapenko <glider@google.com>, 
 Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>
Cc: Borislav Petkov <bp@suse.de>, linux-kernel@vger.kernel.org, 
 kasan-dev@googlegroups.com, linux-mm@kvack.org, 
 Ilya Leoshkevich <iii@linux.ibm.com>, 
 Viorel Cernateanu <vrilutza@gmail.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793552692; l=2610;
 i=vrilutza@gmail.com; s=lenovo-20261005; h=from:subject:message-id;
 bh=4lXdVBpJSiUWkUV4FYeTn6HuAjrb93rQ9oQKVwzlb6A=;
 b=o1OjIlZvUzgJ+zlmu7Rc0edi0aBd0UOWa/X09z9NOQ1Xbdz5UwRFALG2LG7nc3rQ/JH/tX7Ot
 u/YA3JxtV/ZB3DyUgm46sTQ12cCCQq2/9XlO0o6B9q31clwrM1b0+oi
X-Developer-Key: i=vrilutza@gmail.com; a=ed25519;
 pk=HttZd2ffphVYTK/pvlflateaij8E4SdPd6Y+xDQMqDU=
X-Endpoint-Received: by B4 Relay for vrilutza@gmail.com/lenovo-20261005
 with auth_id=1115
X-Original-From: Viorel Cernateanu <vrilutza@gmail.com>
Reply-To: vrilutza@gmail.com
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B20F01C0010
X-Stat-Signature: wh376z9ty3j4pdu5rsdnr6faar1hxhi4
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793552696-449177
X-HE-Meta: U2FsdGVkX1/7xFyodaIbsl9+LWpGpPViWxi1LGWY97gksohQ3MZg8B0BQOdDWpKNn18FrWIJZsBPnDDB5JpN05K9stamH7J/hl4FTN4XIlRB0mUWvi5Ry1FOHNA30j8uE8LZAXMhIe0WEeR6jyru8jVfmEMA8aqLK5vFO1CgkmTQBE4IWS6NS/Gq4uqrdeAvdzr/7pzwBaLfVqOJ2elqvTDVwO4U/ianA3xf+M7FLnlNXAm+tchgWFmtgL5NfW1dZo3QziG7W+jpptRCkJ/0YQjN13xW0AOt4v62CDoDs+CkMJUBaiGt1NM4i43LFvLHXBrr3koBE8nJbQYNLW23bCEoPm4fJw5ypnqeshYI2v5u+TMLid8kEBJJm3Ybc5wsTwIzfH8OSFnVn89a9PR0NHHcBJD3OMFH1fqoQsuJGigwSSU0eoOnFR+dEbGkBzuQvfbq8hyaY9AAQz21bGbobG8m0L2w7mCFY/QBmJ241wfEMH0LpkzBc+jnwn5OJ/b6vNPa1qydSKoAAdbhk/XFXtdVFry8nISBU6LUl7ZTogSYb9gFyDZj2YmGjI2i9KNl+4yJ81PRDnVgQdulfjSBTE6gpQ3zGgY/EJCkHdgt3XiKRvGwpw49UpEqrnClmNCBGI6ue1RqFu0I0hceCrCCt0RmHLlCh4Im4KJv61f97Tstb/DaxJWfVhTipCNlmUUOUB+iupD37XWqp0EJvhn0imI1TFtP7/7Y8tsLSD9/4zm/UnN+aWaQBI7nXUDmqUwiq6TRwol/6XICunkrtK5p4jD39qNL4xse/HjzBMR+yRc5C4H4HIRTW09fLpcl8AF3REYhuJ9BWQsvaY4/PlYXbTnPtnxJq3P+b3wH4GmP+sfihM1zRkNbJ/ZUMUYXPyfyvoFyGAFAWjYiYTVAIdjw9zEtyaE05bkmZhYrIT7dgO79JLkTFE2TCAxNaYMVQWn7wz+x1lJd/M0DJfrePsV
 QFKeAjtH
 UhoiJNVlSsKLS0S3me0eGQr048we/dr5Y8PC+Vl05ZZMvFFlL64slRKcu1JTUFq43FsRJG+JoEtZp+76W1Oy6jSIYEATD+Gj8bkR9mIBvsEQoT+3bgWonH45JYnfFA0w9zVPFAb4QL5yudsuax8ZcDOn43DpgBOZXToxswzi6qaa92J3c3UhWkRP/SUhq+UCb4Fm2GUhkrPmlqhAaOC8qjymPHFhYUcAXw0Ct2Tr3n5BjrN+xqzaCIKwaHmT3qUO8Ka87CU5YS3G9OG4+vzQH6XasUbupG5dzizfDTQJkgthI4F+SqycHgZ8iPoUnfXaHhkhH9KhUgEFrAjKKOzoeCTCiFuUDDboYp/wmu9XoCuKASnsFfip7MUWqoD0y0YTtWozUj5Q1rQgvNhoD+Iw1/hAXLITeu3qzTbx+IbGZzFqktLIZmpbPTcV/ydU3qWp4f2zgyptEfmZy2vbRvBfCb13ldg0kVWyBCemLv5VFi1ZV/y1ehO5JJdBFt3iiWGxjTY853912/+lgu5XeuzPs8A84+CuxYaHxRt+SZ9D4VHSuzWYMmvA9Pk7TgTWyHobXXJYptHyKrEb9HiXZpKIK8n934T8e60BryBECCOEJ8l0iLf0k1f46EfsihLEhuWCZAL64faiKWzPZvcmQ0MVSaYkW4A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Viorel Cernateanu <vrilutza@gmail.com>

With CONFIG_DEBUG_PREEMPT enabled, a KMSAN kernel hangs during boot
immediately after KMSAN is enabled.

kmsan_virt_addr_valid() calls preempt_disable() and pfn_valid(), which
in turn calls rcu_read_lock_sched(). With CONFIG_DEBUG_PREEMPT, these
paths call the instrumented preempt_count_add(). Its instrumentation
requests metadata and re-enters kmsan_virt_addr_valid(), causing
recursion.

Use preempt_disable_notrace() and __pfn_valid() to validate the PFN
without entering those instrumented helpers. Disabling preemption
provides the RCU-sched read-side protection required by __pfn_valid().

Use preempt_enable_no_resched_notrace() on exit to avoid both
instrumentation and a reschedule from the metadata lookup.

Fixes: f6564fce256a ("mm, kmsan: fix infinite recursion due to RCU critical section")
Link: https://lore.kernel.org/20240308043448.masllzeqwht45d4j@M910t
Suggested-by: Alexander Potapenko <glider@google.com>
Signed-off-by: Viorel Cernateanu <vrilutza@gmail.com>
---
 arch/x86/include/asm/kmsan.h | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/kmsan.h b/arch/x86/include/asm/kmsan.h
index c6715b2db0dc..e36df95439df 100644
--- a/arch/x86/include/asm/kmsan.h
+++ b/arch/x86/include/asm/kmsan.h
@@ -85,18 +85,21 @@ static inline bool kmsan_virt_addr_valid(void *addr)
 	}
 
 	/*
-	 * pfn_valid() relies on RCU, and may call into the scheduler on exiting
-	 * the critical section. However, this would result in recursion with
-	 * KMSAN. Therefore, disable preemption here, and re-enable preemption
-	 * below while suppressing reschedules to avoid recursion.
+	 * pfn_valid() takes rcu_read_lock_sched(), which can call instrumented
+	 * code (preempt_count_add() with CONFIG_DEBUG_PREEMPT, lock_acquire()
+	 * with CONFIG_DEBUG_LOCK_ALLOC). That code looks up metadata itself and
+	 * would recurse here. Disable preemption with the notrace helpers
+	 * instead, which keeps this an RCU-sched read-side critical section,
+	 * and re-enable it without a reschedule to avoid entering the scheduler
+	 * from the metadata lookup.
 	 *
 	 * Note, this sacrifices occasionally breaking scheduling guarantees.
 	 * Although, a kernel compiled with KMSAN has already given up on any
 	 * performance guarantees due to being heavily instrumented.
 	 */
-	preempt_disable();
-	ret = pfn_valid(x >> PAGE_SHIFT);
-	preempt_enable_no_resched();
+	preempt_disable_notrace();
+	ret = __pfn_valid(x >> PAGE_SHIFT);
+	preempt_enable_no_resched_notrace();
 
 	return ret;
 }

-- 
2.53.0



