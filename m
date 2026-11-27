Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06866606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 20:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MmqyPwPB
Received: by kanga.kvack.org (Postfix)
	id 7A72E6B05B4; Fri, 27 Nov 2026 15:12:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 708B56B05B5; Fri, 27 Nov 2026 15:12:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D1036B05B6; Fri, 27 Nov 2026 15:12:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 328576B05B4
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 15:12:48 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 22C0F804D0
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 20:12:47 +0000 (UTC)
X-FDA: 85481997174.13.EF50A46
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5BAB24000F
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 20:12:45 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MmqyPwPB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795810365;
	b=liW8LIrOwNoUGR0nhKuJ+ynKK8bfge92sDnsZy09IPTtOszW7xAAmc98R6zAzvvUX4CzXn
	u+FYxCMxD7K0x9ubtMC9T5mQdsZcBy/IkxNGJak7Db7qwGOFfFlAljVQmaLGrUObH938HM
	ZB/fSjw7703tXE08AMqYniFAyj80uZo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795810365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iWHH1eS1AYYU4zFf0vBwy2i6v/2UwahO8vVO1074qDo=;
	b=rhlVRB5asq9KrnvzFye0sE4mOdWaMv9kJuQ7NydByG7E/WvtwlTmk3TjF5aaTHPHsP67UM
	JETbeo+WpKTuYxmCjv7QeJVpV7M5ICKG8+3YxYjcTIdysKn6T7LmWtjohycItfdL3W96oa
	FppO6vzUZRBKAbNBDfKiuYcpnOJeL3g=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MmqyPwPB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F0ECE620B4;
	Fri, 27 Nov 2026 20:12:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 605921F00898;
	Fri, 27 Nov 2026 20:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795810364;
	bh=iWHH1eS1AYYU4zFf0vBwy2i6v/2UwahO8vVO1074qDo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=MmqyPwPBxuH4KFetP3KoUyJuRlpPpebr9NLFx05QU6dle19QXSZcfpDL1G86i4Nfz
	 2L/EDXoNvqIr6I6jMeS5ouhbF9whO5td4SXMbJWdM8PTpbmRXNfWlYqmE3Ecp07jWb
	 mhRctWegQr8NpojL3RaS4AMp6aYf4l3T2EMFLPM+vcp422YVMttQiK8kH+6YtgvwLM
	 0qqroaqE1kPzwBv5X9/Wn1DdI4yDLAFiYhXvavvUX9r+CbVUTbu6HdtzfDLFPlycS/
	 bcOV1Jd57dvsLhqd7P5gHG7NegsJVPcLRx6eGQaqKKVvajg9GdD1YK2lCc5z85GgrQ
	 TtVhRBxq8UdTQ==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Fri, 27 Nov 2026 21:12:32 +0100
Subject: [PATCH 3/4] mm/slab: keep caches that drop debug flags unmergeable
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261127-slab-ai-fixes-v1-3-cf13b6be6692@kernel.org>
References: <20261127-slab-ai-fixes-v1-0-cf13b6be6692@kernel.org>
In-Reply-To: <20261127-slab-ai-fixes-v1-0-cf13b6be6692@kernel.org>
To: Harry Yoo <harry@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
 Chris Mason <mason@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5BAB24000F
X-Stat-Signature: kg63y3bwppmfxd9e85kbntndo79jpmb4
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795810365-793598
X-HE-Meta: U2FsdGVkX1+abnNdi6cbEOiSRccLE49BwweV+gcS3PZdd1o8T3Jrz0rIPAeLC8mdfSlTXN7DPmJZCTLd7ZHAkA4PiVqE0Y82VIQ8YA8Y+krpm7RJOCuzsKyDsZthZmCzyNbMGosTEDkIQPY0Rzc+Zihm+j64tYRw4yj6ewffGVgdOy3oG96xENGTlTKMynOhw1T3/RugaIEihY1iNCJ3ACSsKy365x24PLmAojLMlMIe7iYiADc+5vGuwHoR6NhlwkvvOt+9Hj66UQh6KmHz8GCVmQSz6pRY7Lou3L/QFQTzXx79MuThjqJpnWiX+KtlD8HJntDcyJNrzO4GMZy6xq0WwH+XSbd3xNSWTzaqhxQk2vuMsJ4IVnGuvMLXUpsJs3IrcmiyAfnQGR1ykJh5HS+q2RINc/Wv61aJ4JCKKiX4RlDDFs+YxYvkSW8c3NwSyybPylUS1u4l2+hOaOKALZxzh8zPME4YS7Lq/cL/N7mRIoyVr0JcUed8OvMEpUpJ8RSq1ty9WlIlVq867Je32rrQpQpuBRfUc+7pQk05I0GvTjpXPmfZmoIvhajouBaWLIBR8Q2vT7re5CbTzl0teuCkPN/F8kRBeP4VigGOd8MqX7PqSOnWinMsNZQvxe1h0rD7lb0hL7+7scykxYou3U6+K/qsnvgsB1pqWiFIoDZH4axjUVaRMS2QirH6iFASKer0cAQFlCz10bvT/h1YhB6ZDi8C3+dQs/3g9octoTfXL6rKavWUsbHsIn8YJCENRxWz1kPYjfICb+piSAeHnwpNaCErz+5TlMzhyHbJb4CoFznw9Bz6pBc9pmkRUDZ5l8kDqx+uZAutyRT50bQJDQG+HV8P0pFu3/lOdNNKlIIBQPkuL8dsjCsuYPMgqYlzmk7T8tfwULHrYiLaSfF9OFe0aq+2uEU4q3QC62UmYehPNU2mLEQTMNMKK6u5jAmdklNC+GmwTSAK3HN4t1M
 OHhNDF9H
 bg3PyOuNXdRBsjmPk/p9aJlY4AaQ9tGuyUXbqaYAwG9cn6z1BIR4I2m+DuYTXXCaQoQavyrWxMEDFM0YPTM6bNXXF643LH4BBgGysOeepJQIwlQ7hFAMvFtX/V8UQXDL2b4sfBBFVR0s7jaNm8cz14SLcghli+OSOZMoZeM3OOpKchhhWnTVIGVVnZuetmHn22fld+gQsp4ekQCSU15gt4W/dE2wEsMBKSN1iKKz4b4hmnUp5GvKIhGf6e4WOAKfvP93FW/YwqPLmxDXsOEmiU0p5QmTNvVqFdV4xq9qi1n4+Vo1rikccMFoaKnvfW+O5G1lNtdNOgFnARR0ce23KyQSnCJuxL7zCKkYnpQqaVntbUmxQq95uRgVaXyVUfC7u2V3XpJko3SZ9rKyOv2lFNHONoFMWVOR41bu33xmv5hKmZrhA8LR31LCaTca4sNjoPGIqC6zA852JM7C7kgvW+ne4I7ZxZ+sWDsny7BY13SJSlzlQYjYvYzlkVg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Chris Mason <mason@kernel.org>

When slab_debug boot parameter contains the O flag and a list of caches,
two caches can get the same id in /sys/kernel/slab, so sysfs warns about
a duplicate filename and one of them is missing there as a result.

create_unique_id() builds the id of a mergeable cache from its size and
flags, so caches that are mergeable and result in the same unique id
must get merged - otherwise a duplicate id would try to be created.

But find_mergeable() doesn't merge a new cache that has (at that point)
debug flags, and with O do_kmem_cache_create() later drops the flags
that store metadata if they raise the minimum slab order, and the cache
can become mergeable again, but too late. An example with the id:

    slab_debug=OU,sgpool-128

    biovec-max   mergeable                              :0004096
    sgpool-128   has U, so not merged into biovec-max
                 later U dropped, so mergeable          :0004096

sysfs_slab_add() has a check for such caches since commit 11066386efa6
("slub: fix sysfs duplicate filename creation when slub_debug=O") but it
tests only the global slub_debug, and flags given for a list of caches
don't end up there.

The fix used here is to mark the cache unmergeable when its debug flags
are dropped. With that, we can also effectively revert commit
11066386efa6 since the global slub_debug is covered by this fix too.

Ideally we would evaluate mergeability with the O flag precisely
(dropping the U soon enough to merge) but that would be a more involved
change and probably not worth the effort.

[vbabka: revert 11066386efa6, tweak commit message]

Fixes: e17f1dfba37b ("mm, slub: extend slub_debug syntax for multiple blocks")
Cc: <stable@vger.kernel.org>
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Co-developed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/slub.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 20570e4f1795..9bb031f9a41f 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -8864,6 +8864,8 @@ int do_kmem_cache_create(struct kmem_cache *s, const char *name,
 			s->offset = 0;
 			if (!calculate_sizes(args, s))
 				goto out;
+			/* Created as unmergeable, so it has to stay so */
+			s->flags |= SLAB_NO_MERGE;
 		}
 	}
 
@@ -9825,10 +9827,6 @@ static int sysfs_slab_add(struct kmem_cache *s)
 	struct kset *kset = cache_kset(s);
 	int unmergeable = slab_unmergeable(s);
 
-	if (!unmergeable && disable_higher_order_debug &&
-			(slub_debug & DEBUG_METADATA_FLAGS))
-		unmergeable = 1;
-
 	if (unmergeable) {
 		/*
 		 * Slabcache can never be merged so we can use the name proper.

-- 
2.56.1


