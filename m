Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DAD2606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 06:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=ooF8CRjx
Received: by kanga.kvack.org (Postfix)
	id 705E36B05FA; Wed, 21 Oct 2026 02:01:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B6FD6B05FC; Wed, 21 Oct 2026 02:01:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A53B6B05FD; Wed, 21 Oct 2026 02:01:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2CE026B05FA
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:01:12 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 980F9C02D6
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 06:01:11 +0000 (UTC)
X-FDA: 85345585542.09.A38ED44
Received: from mail-dy1-f172.google.com (mail-dy1-f172.google.com [74.125.82.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id B69AF40005
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 06:01:09 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ooF8CRjx;
	spf=pass (imf01.hostedemail.com: domain of zhangbo0325@gmail.com designates 74.125.82.172 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792562469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9AgnBFgzwSTx7fvIgDbapaFFdCAQNBedUyXmODA5aYw=;
	b=C9WguNgn41OWPzdrvf9SfSilToNHPNjqnftBGEseD3gm3/Vf3hhB10Au2mku19dSzivgKA
	i3AHHxDb2bJmYFDnCW9I23UJKOEhysZdk2iMhoPSgJBATdpsqvH4qVAH19jGdO55XUXit7
	ESrQ/EwJlS4bDYuiF+dSGg1sK3GznFo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ooF8CRjx;
	spf=pass (imf01.hostedemail.com: domain of zhangbo0325@gmail.com designates 74.125.82.172 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792562469;
	b=zjLFcLeY5ChXijLWLgmw339vxN0w4Gu83lvtWwvr6Ljknzxum1WFOlRMQtuQhLm0oCchEn
	+uHnyxBjPk1Jn1m2qmnyECTveudm5+C4Qxxbmv71gCFz4UDiNZ3COmfRHvHidE1lbR2CMA
	E7ObxtXoMmdnHCVmOlhzdWtznuu3tv4=
Received: by mail-dy1-f172.google.com with SMTP id 5a478bee46e88-33bf40b0c8bso1110870eec.0
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 23:01:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792562468; x=1793167268; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9AgnBFgzwSTx7fvIgDbapaFFdCAQNBedUyXmODA5aYw=;
        b=ooF8CRjxYufXURUDlcNnAWGrfDNM3iniCTuJzgx9laA4NaumC1Cmqjq85cEdfGlc/K
         I9ox4fvMIQ0wNPPKSPIjWtnunPBo+LpjfVvlxD7zITgraJlrttLqy0E8Il2v6tasz18u
         ZYTQTwoDiSs84NySrzMbnlgDK6X6c2or0UTHry/Kzr6PRPjYxspt2GmtDAeZbTBm6avu
         O3y7+o86+FDAf3EBydDwp381Zv8Xp6VgSpckMTvK6Gp2IKd6aYKUwNDTNExpvufuawCY
         NqoDSHV9XuPy0B+IepGlPe0bYCm7EvL9Kuix0RWA/OtH9meE8E4TZYPonPaK5M28F6kL
         fvNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792562468; x=1793167268;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=9AgnBFgzwSTx7fvIgDbapaFFdCAQNBedUyXmODA5aYw=;
        b=N9T+Y94kuQ1Zle9oUmMpLjkrlUJZlBeD8rwZEv59odOxpwLQcRDuSnxBAgNAOi+XHn
         PRQhZLcwi6fBtah+GT3vK2QGdSJ1z+pI7rgBmy0MC7f8BFCBA2QDLWQaw6L2wAbqTxL1
         VBQmpx4UcPKveFcW/V0pNj8mvJDYLrEHSB85vxSRVRd81P4Ae5aSOwrtOxmEhDeK/tEu
         e8a9REn/eArqgzY0QVwk6xiS60kqAO/c6nM6uSBiBEOp/q3b5IvMSl2Unv5lBwynSEqi
         8Y0m51/sekwiHJuZoqTHGGtTD6dXT3683dPwExtMk4+ObOA2E6u5D1Yc0YGG6mjwkX5H
         8TMw==
X-Forwarded-Encrypted: i=1; AKwUvBxqkBq/0uvoNVeMk5TDRu8mu01NGnJF8HT+StRMQi3vV6OQL6hYl61El8w3qqrJUoSAQQ36cbPZBw==@kvack.org
X-Gm-Message-State: AFq9FYLdCpiBbptrWeozvxwFkmu3WILEmR/ISz7WWSwUikG8ORL3V60h
	KpaqLDbd1lZycF56v10beD1RFtbIX+0Kj3RzbJpLybZard8uxas8ShMf
X-Gm-Gg: AYBFou3Y+jrpw6PwX/P6jjo5IMV4iVlkaY0SVj4T7lQqNaYFZdcaOQbQ2zo/JFpJxzP
	GoywX687oO3Y35tpfBggyh1N8i+c/VPMDS9Yzx8ywLV5Ps9bjVCKjQhO1fvAFSuGysCGRQy/I+T
	TT0Qlx45ZjaVC/sa1idWR/PtlJLhn+IHPaKvWsBCLM8gtfureygpJjC5KGESpVvb45MW73rRX+R
	SiTLyWtiw6+yQaUaX0Bbcb+RzpYY6fiydGE/EccwMUa4kzIciILCN12tw1718C0v8rcMzqHk+jU
	eotTwOFEm1ttq9UqQf6kGPCG/hLd8sJV8BZAKPFHhnWx6Pl7sDXYieKCdNfP+csSCZKsNWtwX+f
	oca6B+fDcLQSmUTMqFTf7n/vKRmLdBE+8wqoslcMpUQe1MMZpGxNz91xeY7Sg1Xid8s8cvzrDrH
	lnPggSQrCzfC2iqqm+1N0ACzrfRarlRqb894yJzW4W3BXLsnnzmcWyV84zFYSphWMrQ3TZgI1O8
	08gDcjqjGLUE3VV2MJGZBVO9WfZ0dc08VipwqSmvpeJitOQbTfH+s23re3ibQE3mBhZlzCIsA==
X-Received: by 2002:a05:693c:414c:20b0:358:2e30:8e5 with SMTP id 5a478bee46e88-3674b62ecdbmr2229193eec.1.1792562467921;
        Tue, 20 Oct 2026 23:01:07 -0700 (PDT)
Received: from zhangbo56-PC.mioffice.cn ([43.224.245.235])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36740cc8c6dsm4408666eec.12.2026.10.20.23.01.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 23:01:07 -0700 (PDT)
From: Bo Zhang <zhangbo0325@gmail.com>
X-Google-Original-From: Bo Zhang <zhangbo56@xiaomi.com>
To: vbabka@kernel.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	ljs@kernel.org,
	liam@infradead.org,
	rppt@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	kasong@tencent.com,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	zhaonanzhe@xiaomi.com,
	lipengfei28@xiaomi.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 0/4] mm: compaction: mTHP-friendly memory compaction
Date: Wed, 21 Oct 2026 14:00:59 +0800
Message-Id: <20261021060059.2253219-1-zhangbo56@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <11264869-00ad-44ea-b39c-a78347af0ee1@kernel.org>
References: <11264869-00ad-44ea-b39c-a78347af0ee1@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B69AF40005
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: ekx1nki5pgy3km4kbe3f71qwmsk94kor
X-HE-Tag: 1792562469-611745
X-HE-Meta: U2FsdGVkX18Y01ObQhXCTZUMnB0k+wkLOdaQzNltfIIVekbikNfQXdv+d5BDL61GAdWy90UTN52BdLDu0bSI4gtg9iPfCXDWySiLA1flywPkKTVdr83HVInKQHLvFmNnqoDZzFlhqpikpcUpM2NCnRy5cfK3hf3tQa97s+yRARWpYFSCTl2n8hiNbWm7OZU5wH8+BXnRlhaZ/O7l3Kjq7CntWOmWv3qoY84ZsH7xO8r0mckKyYj8n5Qo/QhpAGOALl+jz1vS7lvs2kV4BqluPTeFOzOJbjGre1F2KEjNFxK0h98aUkMhhjnWLMrLOZ84+6ioJv0ZIGbzUJ4hTPMWkQxgHOgxN6hbicqec3VKZtYxhcZIRHX0ebdydU+BamBrQ6F1CTuYa6qsuTMekcD/7q7G6FCk/6mxb1GUgAnev/Dsi685Kru2ciKrIYyrd3mZrm5ClSkRT2QIG82q8Z4RXFMSMk2oaja5HNK/w5XPxLrBHToUD19dWFjlI2s09NXKwbHdpHgq8JBOtC+lGerH8MPn02Ivx6ZAtqriobdyhR7f0grlgIW53VsQMYs0jM3qw5J8gH8whndThuiJqldai4mRUHIUp9Ywt4D1CgCUbLOEZ0sOZUB7tisSMgNJtWpJxOyQiIz3fkifu7xTETcYhVODsX5ZW8515WOmA8WD2jCLoebrfAP5HoST0JOPEGhiENzBobBNULbwpeOs8DZMr7758xmVLVgPQHgcLStVwGBPcn5MNLc10+IjF+1YAxngSvOfWF/ruain047M3jpiiZ90mq2d0MIpmm9w4/pyldBGnH9A/BlbyN5/h0qmVnfgdqpyL297YS/+rk+5jLnUNlbyRQI5nvnufa6CJrDtpasYdwc0sbJV3rcLsA3YNHUYBJ57r4Z7Enog0RrDIr/13W88fO2/3xP2+45+ukqYL9k7LzSkWo4l1yESVliVPgvTYo8ejy1T2yMqz4rkISJ
 RqrPzumc
 NdlwbRrnC9Ja0UldczVLcpMy6kITCNVaDJlP+iLgMNvp88Yx2M27Ih2kCDWczL98HGCdpwCe4vV9Km/pp8QNVyA1WBOdgKVIGvP7cAFJy1zfIs4ztSiZ4rxLnzZG/QwYnEtyyUpbTgQpJiUpOsWngo9XzvY55eHhg+BuPWwDbFNxNSBJKJUK0PtbfMD8Lg78YyQCq1ggGz6K1lVZcdE+M3+3ocZAF6bXkSDEB7MaDpjlIjinC4bG50j61q4B6VuupZ/AHhgyUNkBvGazu0d3Ek060jr0wmnncR57GIdEh3hefs60uVF+li9f3h2nWS/Ikwd+HVjzgNt4vGZvz9K5QzAAWRHmBgoHJj8pA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/20/26 16:52, Vlastimil Babka (SUSE) wrote:
> Isn't using  struct compact_control clean enough? There's already many
> fields like
>     bool direct_compaction;         /* False from kcompactd or /proc/... */
>     bool proactive_compaction;      /* kcompactd proactive compaction */
>
> Who says is_via_compact_memory() cannot be refactored into something using
> these kinds of fields and not 'order' being -1, which could be then used as
> the target order.

Thanks, that's a much cleaner direction than reading huge_anon_orders_always
and would also address the race I raised in the second open question.

I tried to work out what it takes, and ran into one thing I'd like your
opinion on before committing to an approach.

Today order == -1 (is_via_compact_memory()) covers two callers that both go
through compact_node():

  - proactive compaction         (proactive_compaction = true,  order = -1)
  - /proc/sys/vm/compact_memory  (proactive_compaction = false, order = -1)

and the real order-carrying callers are:

  - direct compaction            (direct_compaction = true,     order > 0)
  - kcompactd normal work        (direct_compaction = false,    order > 0)

The issue is that /proc/sys/vm/compact_memory and kcompactd normal work
differ only in the order value (-1 vs > 0), and both have direct_compaction =
= false and proactive_compaction == false. So with the existing bool fields
aloneI can't reproduce is_via_compact_memory() exactly without adding a new
field, which I'd rather avoid.

If instead I give proactive compaction a real target order (and keep
compact_memory on order == -1), the ambiguity goes away, but giving proactive
a real order is not behaviour-neutral: several paths that proactive currently
skips because order <= -1 would start running. I went through them:

1) skip_isolation_on_order() - currently proactive takes the pageblock_order
   branch, because target_order == -1 short-circuits the first test:

       if (!is_via_compact_memory(target_order) && order >= target_order)
               return true;

   With a real target order the test starts applying and would skip isolating
   folios with order >= target_order. That is close to what patch 3 does, but
   not identical: patch 3 tests order >= compact_hpage_order() and
   additionally gates on mthp_always_enabled(), whereas the native test keys
   off target_order directly. Whether patch 3 can be folded into this depends
   on exactly how the proactive target order is set, so I'd treat that as a
   follow-up rather than a given.

2) fast_isolate_freepages() - currently returns early for proactive:

       /* Full compaction passes in a negative order */
       if (cc->order <= 0)
               return;

   Here the order == -1 is doing something deliberate: it keeps full
   compaction out of the fast freelist search and on the linear free scanner.
   The fast search is meant to grab enough free pages of a specific order
   for direct compaction and stops early, which is at odds with proactive's
   goal of scanning broadly. With a real target order proactive would start
   taking the fast path, so my plan is to preserve the current behaviour with
   an explicit guard:

       if (cc->order <= 0 || cc->proactive_compaction)
               return;

3) suitable_migration_target() - the free-block test changes:

       int order = cc->order > 0 ? cc->order : pageblock_order;

   A free buddy page is rejected as a migration target when its order is
   >= this value. For proactive today the threshold is pageblock_order, so
   only very large free blocks are skipped; with a real target order it drops
   to the mTHP order. To keep proactive's behaviour unchanged here too, I'd
   keep the threshold at pageblock_order for proactive, i.e. gate on
   proactive_compaction rather than let the real order take effect.

4) compact_zone() end-of-loop drain - this becomes active:

       if (cc->order > 0 && last_migrated_pfn) { ... lru drain ... }

   (capture is not a concern here, proactive passes capc == NULL.) This one
   is harmless, but for consistency I'd keep it gated off for proactive along
   with (2) and (3), so the order change does not alter the proactive path.

5) compact_zone() start - this watermark check starts running for proactive:

       if (!is_via_compact_memory(cc->order)) {
               ret = compaction_suit_allocation_order(cc->zone, cc->order, ...);
               if (ret != COMPACT_CONTINUE)
                       return ret;
       }

   This one is different from (2)-(4): it may actually be worth having for
   proactive, so I've left it for discussion below rather than gating it off.

A couple of paths are not affected, since proactive already diverges there
via existing flags: __compact_finished() handles proactive earlier through
cc->proactive_compaction, and fast_find_migrateblock() returns early because
proactive sets ignore_skip_hint.

So my plan would be to let cc->order carry the real target order, but gate
(2), (3) and (4) on cc->proactive_compaction so the proactive path keeps its
current broad-scan behaviour - i.e. the order change is purely about the
target, not about switching on direct-compaction paths.

The one I'd genuinely like your opinion on is (5): the
compaction_suit_allocation_order() watermark check. Unlike the others, this
one might actually be desirable for proactive - it would stop proactive from
compacting when the order is already satisfied by the watermark, which is
close to the "don't compact when memory is already sufficient" point Dev
raised on the sibling thread. But it layers a watermark gate on top of the
fragmentation-score logic that drives proactive today, and I'm not sure the
two should be mixed. Would you let this one take effect for proactive, or
keep it gated off like the rest?

The other open point is the one you raised: compact_memory and
kcompactd-normal work can only be told apart by the order today (both have
direct_compaction == false, proactive_compaction == false). So a fully
behaviour-neutral "bool instead of order == -1" cleanup isn't quite possible
without a new field. Do you see adding a field as off the table, or is it
acceptable here?

Thanks,
Bo

