Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3C7BCDB46F
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 11:47:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99E326B008C; Tue, 23 Jun 2026 07:47:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 974AD6B0092; Tue, 23 Jun 2026 07:47:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8657E6B0093; Tue, 23 Jun 2026 07:47:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 583C86B008C
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 07:47:51 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DEACC1C58DA
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 11:47:50 +0000 (UTC)
X-FDA: 84911003100.19.9AB9EE2
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	by imf29.hostedemail.com (Postfix) with ESMTP id 096E4120004
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 11:47:48 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ECgBA3kr;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of igorpetindev@gmail.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=igorpetindev@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782215269;
	b=Cvdlx00xT5agcE2J7+CfuPEvaN6PMVX1lVlvnvOQk+jKf/rtB5D3mob3a7BVaOtIqWRdtz
	NSHWkffGENSqVJG/xJAp1B2BVKAngJKjH9sMmUPvfzn5FMjhVNkYheCnsjtsj5JTGtJfde
	SD18V+OHWznZtQBWqKqzI3P0ZK7BeH8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782215269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=UWO1pnif7wwTSbqZ2zwXL6YIFLc1Uu0qFeb1JG28/To=;
	b=p54hy6fENYoPvJr6eyM27kjwTxfd56fySYtxzwdgPKPLTG/VhgojhIzD4CzkBbwhajyMpG
	CwY7WxQJLfkaFL8mDJRcwf8FQfnndOZoJt+3axuXpQcW5OXdxWvQBI/Mn3dz91kmrHlz0e
	T4mBEPvBVe8vi5ZyzMo9HekwrlgUswE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ECgBA3kr;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of igorpetindev@gmail.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=igorpetindev@gmail.com
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5ad68b30252so1295411e87.2
        for <linux-mm@kvack.org>; Tue, 23 Jun 2026 04:47:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782215267; x=1782820067; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=UWO1pnif7wwTSbqZ2zwXL6YIFLc1Uu0qFeb1JG28/To=;
        b=ECgBA3krKvoH7uBjkalW8vZAYvWCpcdEq+Qqpd7ZWgZ7tzSim1xNAvkwEar2XVjK1t
         PtIadNqTMrHX/GN0MIBkG+Ll0lDi2ogJIpAvf2y2HRDFhQsaM5CYV4VJYtweOvu7BCX0
         ixx32+9uxq/Litl/m0GHZsjwvBUJOgQg6qJgJCRDJOhc3dNhjtf7lMSd0IvdJvR4VjHF
         nycnGAUg3+b4KxPiMeB0+w7CNiDjMUbnETBiGjOOSDHBUWiAqjh7RyC4Z/VK3EHLZtN6
         5ATlxdh6C8s8aD/PXSXf3YB9/bHHk3Q96QPrAVlacJHDfMTo/jvoy27gg9jwg2rdEAO1
         nz2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782215267; x=1782820067;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UWO1pnif7wwTSbqZ2zwXL6YIFLc1Uu0qFeb1JG28/To=;
        b=rzJyk8/wCu5NEv7UyF817mGuUF3mOaOSQHqpGNNopLSXoBXuUVm5UGKA9RFTlrDv1l
         HJ5c2J0c1tLKuvnyr8px1HIJHNkYnYix4OdA4a0IIfVJma7dyRf9MZr1+V/jFQP6xqsj
         tnLxd/zyG7hgHK625MKNIhLWXVO67t7kCRvlCJV6oBmo2VVTQUTYSQUwkcublnSXPHhI
         /A3tf0ndY7ATdw9Ghv5d4nm4scQX1DflZAzVf9xDZW3dJqRayeUHi5caseqZm6a76lep
         tiupFRpWKGFj8/b8j5//JU17scf4DAo/hMHgRN0Nd3Wtq87qE2Y7w2shFxakLs4Z8G6S
         iMgQ==
X-Forwarded-Encrypted: i=1; AFNElJ+1jU/MtR3YPCFpGCxHomVDqFSesW2pBBFanDANefwrf1zdqA5Nb4lvjeuEtKN1WIokqgGV3+qn8w==@kvack.org
X-Gm-Message-State: AOJu0YxoYEBF49CAhNCZlYPxwYenziI76unSOdQ959kyOMG+GY/ErMS9
	uGzDm+HKWTo+33ZF6DU/KQJWuhbb6pnPTIBB49EyMT4HCoKzNZsPS0hW
X-Gm-Gg: AfdE7clcxb1JhS+O6PJmmvUi29Gj4rTe8JI/ujgzzc2TAxUxnABZ1v9L72LqA/zND0M
	rshZDwBKhNZUXCxT5etUqcIvXEbmpb/ZYsW9mnaCD5bq4sSUBAB0klBmLbAw4vZo2UShjeGvakQ
	ALid2h3i190VrKPsSXqT8uXfzkMpnbQQVFaISae8Ry+QKqLk7mLVMq9xFbIhYm5wHdWiEAN/W8R
	39SLMLu4ayE1OiKX6TqXeAL3ZMCKUvnzzsEzg6NUb8OrBymQJAtcV74QVgIsXJjrlKHKY1rWs1t
	uqiDqsOx3q3zbKI6b0FaOR5Tp6x/1gyLSpvLG/0KtlvR8lvmXUpSAygcDbMn7NXhKy3YVXRNQ4N
	Xoae/9kBCFObrTgEja8L/qdFmPdEihC1PFYDhSHXpjtAtRFepMhMod2iDx/ffv+OpJSus8AFs3q
	D3agkofwuar1Xd3DTpHd8B0sog4TNu5yQc8mTReVJHwBwVOwzmJUOAslUVHViM+M7U1YymxBsD5
	xy6r0ADIcY=
X-Received: by 2002:a05:6512:6711:b0:5ad:5456:8eff with SMTP id 2adb3069b0e04-5ad577242acmr5297882e87.50.1782215266849;
        Tue, 23 Jun 2026 04:47:46 -0700 (PDT)
Received: from g.localdomain (95-25-158-125.broadband.corbina.ru. [95.25.158.125])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5ad69555981sm712083e87.34.2026.06.23.04.47.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2026 04:47:46 -0700 (PDT)
From: Igor Putko <igorpetindev@gmail.com>
To: ryabinin.a.a@gmail.com,
	glider@google.com,
	andreyknvl@gmail.com,
	dvyukov@google.com,
	vincenzo.frascino@arm.com,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com
Cc: akpm@linux-foundation.org,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Igor Putko <igorpetindev@gmail.com>
Subject: [PATCH 0/2] mm: remove redundant static variable initializations
Date: Tue, 23 Jun 2026 14:47:41 +0300
Message-Id: <20260623114743.4565-1-igorpetindev@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 096E4120004
X-Stat-Signature: g974sgmau9m8p4fe7jjz711wr9xcm4cc
X-HE-Tag: 1782215268-294121
X-HE-Meta: U2FsdGVkX19VAE+1pBl3EpDKrbVeknrB0CAEdkErCsJ6GN/SxyGneK/6KUnwkTlcOJ2yGKZ17w2I/nJuBcP+ivK2u2H1PziBEpfYRUTtykv93f1zdr8GsEFaou0Keh2oCk+Z+l2xbWouLLYc4vsCg68lLbq+m6956JGPHpfOr6dkGD1wv924cupxoxhGtjvyNzoQogGt3E83eMAJfY7TNyH46p0J/L5v64u0aW1Ig89koPFEdGsNVzXDq4av1Tjr1T9iD36Ug8hlzQRVgPPKp9bNtIF1ughwZh+dXeNxsqdB5IfciWrVvYm0YDKnecBo8TESk+Kj37L79wu8bXmS/MmVLNAFt7urZynd8o+hd5BTH5O73GQ07kBvoXnMXXh7Ev3KzAg9rJAsv1GG1ai3vwwOUM6klMRt/ye0MCuinzlPSG8F7I0CyeIKybggKVcU8H95/lGBWBsbj4FYwZ2vweyiCm9pyEdk4XOfgKf234UOPUZ6RolouQiRB/dmwqSBWAenKMSNPzvy8HQCh2Zpo0JvHgiqrfBkCna9bWc4Fw/FfiJ471XprA2jr12hxtdwydweMJuNI6/xzGSfRAL503jwjxUlPCuh4Z+yCvA4OCCiaLEIwsfeEkz0hxI56MZj7Np0ujpgnEqpId1FxIFjZdnEeSHzjdmhzk2dCJpGnwmj01s8Jc6Tp9Pr1aV0OJYViJMd5H+5Df6phN6N0aWyQRi0bCt8/rNVgZfufki307zJyVgzYSWFErg/Roh/LSOo6cmNx/Va7S2UutlaoS9F/6be/WV6I2SBpZkp+213BANts286Rk2JBcLgTqVfsfQWgf3nNP6zqhqmlsCB9IGYhn2AoH+9bckFAdeC7VgCbdCBsuUu6NEpaiW50pN/RSzVQWP+hW8gSdQQCt+wGjkwXgF6iyvf65gttsPPhh3xrmVC8E579Nh7k7TDLZrgxI44COw/MTzBlnCclxLWw8y
 clpd8lTV
 cTYG8PT27O5ZZdeE9INnVlKpb4DEzeray6E853zrMy6QZ7MjVrxFIdbKYQS6oxXlMQ00RF5Z5S6S3UOwJ2LC0PFZ+RKabrqfhy1Wk88iSeNeO0g4wU74QRSxeaVImxfp/fWb6r5bcm3px8obIk0g16SfVIwBTf6aCSyGX+lKUBpeIwpG4Ude+Zmq9cA1NVB2CAOqsTVbFOLo51d5jyYJpJb+Whd8dZNr0MtgNWqP0OF++PC7gF+ZaFayKr3R1A15jeIFsjaP5Ujj9Wftr3cKPBagLVStkG83Y1Hz8hwAQeWxjLq/rTNLTBh512kP7aY65c1Ozk9FOXr8b2KrU5YmLj2gL1emKr3myraDdYDt2BTTY60bGbp3Yu0rE92ZdGnY0L+zNiuzSXXxRmPuNFYXQSxQ0LYkW6IXGEX2WHjXNPL97zHffe8pVvlVOgtYiMS+vp2mOgKzIF3yL3ro5Gsma2YVFBmm1lges8rcP/BQNV5tffpzAnJMRPN6NwAR6mHJIV2/E5jkABfvc+V8hnvczf/e7YAlS+DiPOydI5YTo9D+EK1U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series removes explicit initializations of static bool variables to
false within the mm/ subsystem. In C, static variables without explicit
initialization are implicitly placed in the .bss section and initialized
to zero/false by default. Removing these explicit initializations follows
the Linux kernel coding style and avoids cluttering the data section.

Igor Putko (2):
  mm/kasan: remove redundant initialization for kasan_flag_write_only
  mm/memory-failure: remove redundant initialization for
    hw_memory_failure

 mm/kasan/hw_tags.c  | 2 +-
 mm/memory-failure.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

-- 
2.34.1


