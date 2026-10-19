Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFA51606AAE3
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 15:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hsXIhuWW
Received: by kanga.kvack.org (Postfix)
	id 163336B02D3; Mon, 19 Oct 2026 11:50:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13AED6B02D4; Mon, 19 Oct 2026 11:50:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0024D6B02D5; Mon, 19 Oct 2026 11:50:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CE4BE6B02D3
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 11:50:54 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E574F160782
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 15:50:53 +0000 (UTC)
X-FDA: 85339813986.30.54165EE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id F1A0F4000A
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 15:50:51 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hsXIhuWW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792425052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1tklyEFR6gzCJ5Mm0LyngFaJuzsqMluVwnmmNtY4Bjo=;
	b=K9Ejs4yh6tsD2CbkL5nQI5svQv4vgoEjBOWrwWemJUdshGnAdRfM7YV+13nWaRbDHJYKAY
	JbZHna0/8Xe5hwQmyI0FVfdugtO2kAEeJXniUgmfpQ29MC0Mi3u7E7EU+5Mbpy2BF1Q20x
	2WCynlXaAOutMMc9VZSJhfDEXD7Q/14=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hsXIhuWW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792425052;
	b=ekozpygSb/1zJ5V94HHPLljWt3wcf08WV7AWoLvlwNnc/maV2OiVZupQFgHaGOjNqxiCHm
	RPzO4YIg+mWrj+0ZDzFWrj8Grrnj+NBTS+izwoMb2vFlXbqws2HePNbqD1U2I0pIRwi7p5
	gw+39rOYab8zE8OJc+vLG4uUHFl6N5E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8825960DC2;
	Mon, 19 Oct 2026 15:50:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 777831F000CD;
	Mon, 19 Oct 2026 15:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792425051;
	bh=1tklyEFR6gzCJ5Mm0LyngFaJuzsqMluVwnmmNtY4Bjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hsXIhuWW5cj0PTnvYiQiB6X2pHdnoes0T9srZXVcGrGCLignDLmHgupnUcoAgQ6sL
	 zNEpP2bzdCxqRAzHHta6tZqeBuB/Ybnq7NpmSLKcyxol4ZNb5HZjMVH3Fi6HN2lIa8
	 RT6361ta0KFbAm1A7d4ohT1mxTZGqmPad99jfEOBeVsQPuMb5cqHMTV/F1S2gNpWn9
	 36gbsPRKMmo/fkjzpLprlWSRnqpI4UNcBnFS2ZcF2CKMRpSARaxRs88W2d25DKTwpP
	 bYwnV06hz7rhXb4KqmlQ97hCoZQGDTLCKj1DWLvkR47g5T1eFJyfX3ZzR4maur/kXM
	 c/oH0GAq61XAg==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.ams.internal (Postfix) with ESMTP id 4FBAE1980047;
	Mon, 19 Oct 2026 11:50:43 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Mon, 19 Oct 2026 11:50:47 -0400
X-ME-Sender: <xms:UjzWas8YaXxplGvXzipG6uI1sXsBInjXF9r8sbOdPBhU0BQ58KGbHA>
    <xme:UjzWarrZKeqH1_igCCu0ZWOb4ltgMBWO_uD6NCfB4eQHmLJ_7w40CKkJ7KAVxUelm
    -Zg5Paksq_0oHxs7iBvumCcbgOQrcy3BPyZhKTUsfsRTVe_jkGhP6-m>
X-ME-Received: <xmr:UjzWanLsrRLrWT2ZsFloo-00WxlBJ83FqnbM5-8y6hmXW3bX5miNo1uMnEk>
X-ME-Proxy-Cause: dmFkZTEfcY8Sedpzpe5Eju9n5oayhWKPyUV/WN4ORzd354gnHcUNRyDxnfDrVtF0Alji6y
    FwZ4Dnqmp2xFA5TRzvzZXvYk9IWIcIACK0GXlQFj7v3uEIoT3YE0GAecfgycvJObnsWgyU
    omy/lOe9Ul2f7WNFeSYzOhn9Xhyn3eRZ1/u1NlpfN8iOBPXkq7lLkPZY3eLvZtE4xL/1Z+
    12+yKL0HGegFnoIlCDAqs/SztneWlDn0ZvTxx6bOoXiDCEows+EqK1vqCcT2wFPXdzHPq0
    s7OKMwp4WgMV4JhSm776pUXmDzbWh34FJ6orb+IJbBIpKyqJoy5T7ZZsX3UOdwDn/V3zkn
    ciLaL3SK5aczqSEptHZ258YgE9enzFCIUpka6iwuWD4uOZeMrkBJzpGIh4KYoSTKKtrZvs
    4xlScy5Hvhm0g7xX4aojdn8ZeOHImmKyG4/X0NM0BEhBJZwbtMoljvktLExWcSAkjo8TeY
    M9ZgiJ4yApWw5S7yHaoM4S1qhuWXr76hmoCzlz/14P2STYv2JmsxWXbP8qgk3L+yEEfm4+
    3MerERvzt9ihX2Y+062QX7gG/Ixr1M6EPT/QUzWtcZAGVChJyuJxYkvUbIu8P8Xs/1zdh2
    jr3zr60rV2eRRKH1RKef8o1ShHXZiOm4tHdbt5LbIl8o+Sy3moybVLTrAMFg
X-ME-Proxy: <xmx:UjzWag2nrMBiBp4mlK9_Ir0PiiNluPyJXZO4HJytHTBQeoAtapKu0Q>
    <xmx:UjzWag7h7bJWxybYjWYlm3ke8BwyrXuLS3qcZHceyvKUdrzDDfvR7Q>
    <xmx:UjzWauOg48uChbEoCOpDwRAH-d8ahHPMAOzQIm1zcvkGaaR5AE2lbA>
    <xmx:UjzWakK4lkDbmwm-rOmWK-bmvHauC5bAOuFZwPpunuoyY0t2-8HEyg>
    <xmx:UjzWapq27qqMqn2japDn8szkR0NKrbTuk5ifZtw_7yBQEUVdalmiFhCi>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 19 Oct 2026 11:50:41 -0400 (EDT)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Hugh Dickins <hughd@google.com>,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	"Liam R . Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Harry Yoo <harry@kernel.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Ilya Gladyshev <ilya.gladyshev@linux.dev>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	kernel-team@meta.com
Subject: [RFC PATCH 13/18] mm/filemap: store the end of a read in f_ra only when it changes
Date: Mon, 19 Oct 2026 16:49:06 +0100
Message-ID: <20261019154913.1765974-14-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261019154913.1765974-1-kas@kernel.org>
References: <20261019154913.1765974-1-kas@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: F1A0F4000A
X-Stat-Signature: j5ej5dwo4maoyws6prt48sw4ta4jczmj
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	RCVD_IN_DNSWL_BLOCKED,RCVD_IN_ZEN_BLOCKED_OPENDNS,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792425051-997923
X-HE-Meta: U2FsdGVkX19WUCeKnIdfiq7QFcfvwNi3nQwiQ/KxmT0FVhI/Tu4RecEuOIWzVS6Rra0foRb4D/pIP1UwpeM4TLHBdhiJtRNPGXKa95eblwLui90TEhyGUeLBRgsxUBUHBUeENsaBVQrtnaeW5i7rzRTK3xAUOuhfMotsUX6A6dDFmrnOcNKHTmDJ3uZzyqFAA+Ce/qwFpzsk2RJbRB5Qew1pF/+cp9NAJKeL251W5unqgXxZrTLXraGPGaofiAotrmuNMbe62hsITvK9/6dNSNK1BntjbmXPvo0HBkMAgT0Ej1vlCn52HH6D3MuJBOtk/EJEKGfRulI7xVj5OP+YxJcjjw4QydBXN584X4zsC3qAtwwk40EIG5Z+zOgNGwjACGvB4FcAB73TiLWL7s8q4uEJm1BkuaZOx9k65mEx55vo6450jpgT0Iw11t1mLBYF/13ZXX71B98qxLn0rEtCzFeTWY/p6tY/Dxm+WRF8jtF/qddaAlifOowKbWPFqtEgf8vEJ7qODYIC1VgBsMALrpe+O1ZmTlDnpx2c9yZtV0lwKzurmhDqxEOj4HRXUPCaIZGVWzTv8F/QmnAfW3z4RnjwHTOFwYdHFkUMxv3ZsFNT/vC8QbbLbNg1pbmZ6RxsSZ2ip0Ooh2MvB6Fr6dPc092hcchFm5HsickF5j+z5Py41spt/Czr9hXke6ilTtwOI8c1QdIpdVJ+A0MEaHrJULhDttwFJdwcpaejYOWDui+o9xeBu22UA7wmnoLNu/KiLAKXElOyaF6XWtVPH9loA8tCLoM1nrDhur9+wJntB6O/GFOsWVpSjxerQ1WgABsW8+kfcV+KDtvHJy4baJBd8CRPpfCWM0tI1dERtV3qe86XXElVlbKy19pAcftmnTgcC2Iib6QPDTLqG7r1kJfO1jr7/dKt7Ty2WuqNm08HJT+OBKb6sCa4PGsg5JxQ/ezCc63+b1MbHk/8hoLS9OL
 UsQYW4Vz
 JsBmJI23jqpTuxdwlqXs7Yrq7vw7WC///qfDpmRbtNJTLHg5I+Cm9NYHfzdBFuFYCnyD6w1lKIjGjPUhdZDYJFKeJ53js1keL16xH09Uv1DC0PMgs8a2gqiKi7J/lPUpWKtllZiRonHOmN0Jntw0wY9tVPsC3rW6WLm6kTBpQ3pHcIHBUPRRHY2yZJ3Ts6+OIIMScISQKA1Q+pUetjjxiu9ErFgB1rw2Hqiu2LLht25QxY9GiigspY78Z5GqUEqSxrCuO/CjplZQ8B7N5BlHDhu6QVSamL5Blam9SENgqZvKcIu8e76kOaWlX5KjA+XeEwIK4YeNIYx7bL5BZhgk3oSazMrZAtT74aCjucF3oPmSkTJBfjXjMzVAgILW0vHui3vmvIPpARQWpPXvLaT7FYdgaDQAPqkxpIqpD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

filemap_read() writes the end of every read to file->f_ra.prev_pos.
Threads that read through one open file all write that cache line, on
every read.  The value often stays the same, as for reads that start at
the same offset each time.

Store it only when it changes.

Assisted-by: LLM
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/filemap.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 53ec92279977..960d53b61d4b 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2941,7 +2941,9 @@ ssize_t filemap_read(struct kiocb *iocb, struct iov_iter *iter,
 	} while (iov_iter_count(iter) && iocb->ki_pos < isize && !error);
 
 	file_accessed(filp);
-	ra->prev_pos = last_pos;
+	/* Readers sharing the file would bounce the line for nothing */
+	if (ra->prev_pos != last_pos)
+		ra->prev_pos = last_pos;
 	return already_read ? already_read : error;
 }
 EXPORT_SYMBOL_GPL(filemap_read);
-- 
2.54.0


