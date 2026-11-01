Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06AD0606A338
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 02:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=hcPhNunE
Received: by kanga.kvack.org (Postfix)
	id A264E6B05B7; Sat, 31 Oct 2026 22:13:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A060B6B05B8; Sat, 31 Oct 2026 22:13:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C61E6B05B8; Sat, 31 Oct 2026 22:13:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 711076B05B6
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 22:13:59 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4DF18120843
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 02:13:57 +0000 (UTC)
X-FDA: 85384929714.23.3252B05
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8F21C1C0004
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 02:13:55 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=hcPhNunE;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.181 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793499235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Eix5k5b+jwvTTGRDCXBmAoEN+puq/mJ3KZwbyS9PKSk=;
	b=KHd/EELKc1kZvxH/mTks2EmRupwt3+CRxbZAl1XnXVO1wZbV+ce6c0FeNtfzTiPF3g6tGT
	xg4ouNdNbbuMUpna/vhhDUCa59JDoqjRaXGj2SQAiUcCJdvQf/vCIbpgquO35+e4Or/Jru
	CFsUs/BywArb91EiedGjRf/ABPRLQEc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793499235;
	b=RnM3hJymJW+DdrTzwGd8ATv60KNsMGTMUCoApqzmFkYkKhxoZGsjE5dyBcZzMev2OYQsAP
	0ivafSlLvEBT1kSlPpcGu6Kx122uZzzPEvc4OUKP2vjqaJL1mlusJlpuvOfotU4vN0c6Kj
	sYgGttjkxXc9CR4BrOxSemRrx7YHKe0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=hcPhNunE;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.181 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-93f20b304c0so182776685a.3
        for <linux-mm@kvack.org>; Sat, 31 Oct 2026 19:13:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1793499235; x=1794104035; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Eix5k5b+jwvTTGRDCXBmAoEN+puq/mJ3KZwbyS9PKSk=;
        b=hcPhNunEJfRcOifNWdxuw3Y1dzD/RfUsgIxAzRQzdOiB8jt8AqY81945O4Z7yAxdNe
         5u994vdaSvm5HZiIP6skw3X/YWA+OYUGxt0daXHZ9Znc0WDYAsgeYQleKXadA/59at/1
         h/dcfbNAwGiE9u4iHuaqEDR6CBVewpsw4QUXx+PWQP2K0G7LV5l5NdhlJm1CSuNRdO4c
         +94c7kZIHV/84xBu+743fA8NGU02HsLUJG0W/RqIwsXd1CEmbeVnNccE+jVJJ+stsTMI
         OLq8BD4uEnwVPMmN09YyFkjnhCj4F+76cUzjQa2KcH0iKOfnH8M+QOlEeWnQvb8sliDC
         vyKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793499235; x=1794104035;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Eix5k5b+jwvTTGRDCXBmAoEN+puq/mJ3KZwbyS9PKSk=;
        b=QA4YmOlimTGVBpV4yZna+jSPRxPbqTAR4stCYDi3PI+EH6HMMEWtZJBHU8lYbYzW93
         oBJ282gwMT2Yse9kRoTi4ervirgQyKO2EAU1kU3XUvlJgMvdM8KFvIyyGlOJY4yVJtAI
         3IKBWXBSh+lTeBPIMvwpqCJS/xiKIJmTPVb6AZ7gAciNM9fK1iM9531e8kffzZCIPIz0
         L6jozLGkAd6vGXF2bHIvj12jYK061pyPIKBqCuwNTORdBeQbxEZCGWDx+3ZRdwo+5120
         QA98T3D+P09XBBJNDYMYkCMxdwVZxXF9BrdVKS18t8PwahCBvGkvJ70EnZ00ZDrAUWss
         jTDg==
X-Gm-Message-State: AFq9FYJGFHhHHqKmFIWsbUsjDB/VVtCCg8Uep9D8ChsouM11gDa4UThe
	PSlv2XYdjv/2adtN8uEYh5FpCzDJ+5HtslfadKRqWPNgW5R+LK0IIY0oT/PEQ+FuzbKwLUVUvts
	pPGSL
X-Gm-Gg: AYBFou1h9LdyAO7L4S2ZfZUGrcSZMZDY3rzm1QCmLGk2H1qj9YW5fJJhDHdbCng22bF
	H22hVsF3H5DONpxQXPSBcFt4BDyYT8Gn77cu3SEwg7rKIxVmlfk6c6HgErHcOu8G91u/CcFL2OR
	iVuGMdbkbiNNSgjwpEupFMipZlaYmJx52FBl5I5lZ9As73aO7Kx6gWvcZ+xrtaIlPP55P3h4uWv
	eiYipc4hyeLbPr6bQpkOpKoLh+fCB5NCHul7c/8j/C2/ZnUEXT1x1JNWZLnLWCA9n1nNgSQ6Mwf
	vw6qIPMHuYOMhrfpCyv0tS3FYzk6Q/NztEJ9he3Euqp9Ab5DJVxNdRpAEwxcCR1cX5hpURXcW1f
	2+OfxbKl4OZbEg00pJTB3rXKW4pv6mP+gdeaVjVIFiPONOsuT3aSstEs1l/fP0hf+9eB9PF+Y3F
	B8HaWcnjFyY9NNOJ7NTLyQXUsk8EWUpYsWTH+v1OSpgjY133RFGeqbI1JttBYM3kzYTy850zHMR
	fGkVOWeWLCyj+caXJfcJHY/OzBvPzmnnHsXoBnEqbYkGQKS1c0omo9hQ0CdqxNJ6xsbdaKiIgQS
	zuo9ARB+HK6HP1FjmHxYjfhUkEBbi9x2EkQph1PiHNeYs/cwd4k6s1yL2U7/0OLeuJPiZz8mvTv
	2B4oJiAQ9qQ==
X-Received: by 2002:a05:620a:17a3:b0:93e:6a4b:3ea6 with SMTP id af79cd13be357-94421659b40mr1079691685a.24.1793499234785;
        Sat, 31 Oct 2026 19:13:54 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-94425858552sm498131985a.18.2026.10.31.19.13.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2026 19:13:54 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-trace-kernel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,
	rientjes@google.com,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	muchun.song@linux.dev,
	osalvador@suse.de,
	gourry@gourry.net,
	ziy@nvidia.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	bigeasy@linutronix.de,
	clrkwllms@kernel.org,
	nathan@kernel.org,
	ndesaulniers@google.com,
	morbo@google.com,
	justinstitt@google.com,
	Bessel.Wang@huawei.com,
	jiang.liu@huawei.com,
	mgorman@techsingularity.net,
	anshuman.khandual@arm.com,
	stable@vger.kernel.org
Subject: [PATCH v5 05/12] mm/mmzone: read the zoneref slot once in zonelist_zone()
Date: Sat, 31 Oct 2026 22:13:33 -0400
Message-ID: <20261101021340.2251928-6-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261101021340.2251928-1-gourry@gourry.net>
References: <20261101021340.2251928-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8F21C1C0004
X-Stat-Signature: 1h19a83nhebc6fj558f3g4baazm1xmu5
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793499235-547576
X-HE-Meta: U2FsdGVkX18MrTIbG3HpF3nz4KLf99CVjbVXMpKD4QJjHswRal/uTwQu1ICNn77R3rRvvqb2wKnwKuAuBO8IzDtl15W6sXTbaHNNAV888+eWw89La4ZL6heLiOVy/Kgepz9VzlM7Ea3ul+gXB/EsLC+vuUvROEhWnQgAqgS4iqAacA8kqdmWC7rqpcnGIQLfcvbspveIZmkJef1HFq3fj74BBMBRL+qdBy6JoVQY27+/GVr2o/eLAw7EDAxRCX7LcNcD3gKESj70OkkqrstrlwWojXYn/pDob5TxSkJcpTaFePcUWbpk4NDx1dLSfUmUSNGqj47C0W28QdTATHsyFtvGPk6brmI63B1suZ92+Znyc9Reglw/b6ELz5qBTz/9DUsn+SHeF65hW7E8JcpYnevbPsgN4yE4Hj6aNnHOF+82Z71EAAQFnmNeVUha3rMWgQdLR+3hmnEJIBbYA5wcjXbANT2x+F3nfZyCF3viHTRoasc6c1JpxEob89ZRtTfc53IM/N/pjCb3iW6UJ4geoBzau2qD0d+XfV82PkqPsPeQVa2Kde/jwPP4F8bgNgVCfcmJW2+BU34kCKZwpPQ6L0DwNzCS4RVtL0T0eeEgiB2dJQ+YTGYVd9si0wNi15UQjpMf3ppFMw9T/tRA10cVZAdC97+E09MmNm+RVSFvnxe2bLgklsVoF/Tg2la6TjSsy07ceUdKvNwAjHmXsa+HzRyM+1ZOlTBGci0d1RrrOzhd6AlzoFppX6WXS6i/0idQxp08zwBPdCUrBlhSJGdOkaVDAVqWwpxioyZaQau5mWnWZTVUu1PTPcUxpCWD+F7t7NgpXzidaCbj/3VnUV6R03L9zd8MFkP8i3Co8DdiZzChLysIsCVmi9RSa+Ncs+e2MoImAox8ueVfrLq8v7w7Hl8eLCRvzQ+wNhCm23H5mn8QchDjL/50gwaBvHTDvK4X0VsChbeZ3psCCL1/tqI
 SVP+mitL
 UGTPIT7zhyrJvu/DU1UjR1y8uj95o3hZOa+n5Y8owuxoEulR1NH8ooNgXPWM4AZIc57bTx+IfSZFHLM5WX9KhQ+a+64248xeSK0LCOALmhWcVdy6XuIFvhlMPr3xMhObsRyZBc9VuC7F8nmnr71fIZsX7qFCaGfZkrgJ5ADW0j+dGHRsF+8OG8kt2tevXgqcx0Q/RlurwJlbGrC9UuC2ksf0qzr7C2+0tWarFqK13/NQQp2U+IYYDZZY9L6QUknhaJEP4z6x7MCZIE5IexVuCZZMe5hBFDkTmnQrIUyRMAp5oC4e3n6X6P9vB33MBfT52p4TrYMawajiShXlJhE+L2nanGoRZg8WnkAOzIVp1LK6D/3TOSH903aaf+PJFGANygBvKiJzPdzDqxdQ9Qr2GDLM0sEmT8jXNBAupBTyYEFUc1+BaCbPeLj5VN5VRIXUTu62s
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Memory hotplug rebuilds zonelists in place while allocations walk them,
so a zoneref slot can change between two loads of it.

zonelist_zone() loads the slot with a plain access.  The compiler may
load it again later instead of keeping the zone it already read, so a
caller can check one zone and then use another, or the NULL terminator.

Use READ_ONCE().  Callers that take a zone from a slot and keep using
it, such as get_page_from_freelist() with ac->preferred_zoneref, need
that single load.

Fixes: 11cd8638c37f ("mm, page_alloc: remove stop_machine from build_all_zonelists")
Cc: stable@vger.kernel.org
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 include/linux/mmzone.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index ecd1ebd49756..4bc2318ac37f 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1855,7 +1855,8 @@ extern struct zone *next_zone(struct zone *zone);
 
 static inline struct zone *zonelist_zone(struct zoneref *zoneref)
 {
-	return zoneref->zone;
+	/* Memory hotplug rewrites zonelists in place. */
+	return READ_ONCE(zoneref->zone);
 }
 
 static inline int zonelist_zone_idx(const struct zoneref *zoneref)
-- 
2.56.0


