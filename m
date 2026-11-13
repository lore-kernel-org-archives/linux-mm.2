Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95C53606CB33
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 08:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=PZiWq43m
Received: by kanga.kvack.org (Postfix)
	id 420866B0623; Fri, 13 Nov 2026 03:51:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F7DA6B0625; Fri, 13 Nov 2026 03:51:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30E6D6B0626; Fri, 13 Nov 2026 03:51:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 10FB06B0623
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:51:36 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 94A5380293
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 08:51:35 +0000 (UTC)
X-FDA: 85429477350.02.AC52C59
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf11.hostedemail.com (Postfix) with ESMTP id BC11A40003
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 08:51:33 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=PZiWq43m;
	spf=pass (imf11.hostedemail.com: domain of chris@chrisdown.name designates 209.85.214.174 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794559893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CiBcy7QaND7m5s9DJlixmA3xnrmmNcQJ7o62g9gNxcQ=;
	b=JtPKKxr4QTwNffyLpkvVCQy4+YNmICnrUAGZcinSbGH68eCidtA33Rj22NaMAtStnZgA5R
	2T0BfZcjCEfEm30wTf3gLaR7X2cGYIftMwlZKqYdriLKAd/wRCGhn2fHO0MQD0FwFJrceE
	NZ3Y9/53a46pTwJB015N+q9woMWhFIY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794559893;
	b=TCsHakDhGwz9X4c24hD9eJAjeo+SMS5uri6jMm+qcS5UfpBXdq/3og9Izn3J1FsyvpDzLD
	XVOuF/VKkPgAysGJhwuHnJvjSm82rNm+Jgv7DMpE+tXJ4P7zdc4nP35g80xjsg/dRMEjse
	OqkQpEJ81mZD9HKWcrv1o/R2u/280R0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=PZiWq43m;
	spf=pass (imf11.hostedemail.com: domain of chris@chrisdown.name designates 209.85.214.174 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2e96502e447so11104615ad.1
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 00:51:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794559892; x=1795164692; darn=kvack.org;
        h=user-agent:content-disposition:content-type:mime-version:cc:to
         :subject:from:references:in-reply-to:message-id:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=CiBcy7QaND7m5s9DJlixmA3xnrmmNcQJ7o62g9gNxcQ=;
        b=PZiWq43mWu8wDR5FQCP4C9TJV4mhy7vny5wXdHpesFOB8CnfDMtldth8v5DDv3a+FF
         +2kKdSDEKxAqHoPx/isGXBdVn5p8DVKA0JBI1bctszAEsvbpWKnDmemoACWe74Nc9+JK
         0EtRt8sJ9tIHyuK6UdUrAFK70VeDUQaKPn9zQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794559892; x=1795164692;
        h=user-agent:content-disposition:content-type:mime-version:cc:to
         :subject:from:references:in-reply-to:message-id:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CiBcy7QaND7m5s9DJlixmA3xnrmmNcQJ7o62g9gNxcQ=;
        b=CY+Ozkwy6v1ObtZidDMI1R97H3Dp1L+nwyuVAmANv/bf/ZBQ4H2/taNfezRKkip1Or
         yLmCeSZnu3GIZaAttH/cO6xp602UObxq0pRIZiUdX1SMa8NsYPvU4HjmbGoo4R+1Wiid
         nJnf0ro/IRDcKinW0MUt70cGSOoMrQdFDt+JCo6KWHs4oK0DQWyJbPDL17/GXLdMphMf
         /8NU5D7EVmcUgkZV0FC7YgELSFnoOuyHehM2HN+m87M/dYcrW8GyH8bS/sbRNLONGlkp
         h4r5Qs88R8h3mzh9dO4P80YZKKgJwX/CaKEjBq0lwI2QhTa2CHesTgFsTkJUKWgWYK8B
         ikjg==
X-Forwarded-Encrypted: i=1; AL+hErFr1zvFa3YNO+ML5Hx9azqr+t8zTMPC06tBYJ7yAOaijKJxd255hDBh9wXK8qlyNuk+mKz5BFWXsw==@kvack.org
X-Gm-Message-State: APuU4Z+cJ8tF3wbrPLwNC0CM7bqaq1OoY0fluLn+MSFzYMsFwrJVhMLH
	SVHKbnFD/kOSDLdoFgFkdxS0ME1HR3G3kpdWl/Dsdy1c2cWfmbIguJjQjJ0VWQz2RjE=
X-Gm-Gg: AYBFou1AjookhdTDSKbmpS1xPCgbcE3tLzLFOHQKScqjzu8ljcb1uILJkhgCEx8qELE
	V2k6XCxrQPvnKDQeYlupbV1N2HYR5qhqJ8QtRXFD23upCianGuUkISq6lZ5kqCAiKVlXhJbdUsS
	8TJ5apdTgEh7sWHZZEfNLz0473nP6HZ7QXBf0ZfUFaTq2Hltxv7dhCCHDK3szy4xzige1TXy/gi
	0hF/NSmCOURW9IkDtpn88efuU1lARzgj91ORmIvzOz+9zopaHi15+njbqxyQbUfjHtL75WLYQyu
	pqQQ1Hnuj/jJyY0KCbGYCx3MXVJtv6KN4zS2dGigwxapsL1sdiWa8aa9wQubzCUoadzTGrcxQQ0
	owewxC2rpSFeE9+YLyxfCzMKqTyoig/wTROLtPc9rU/F+X1ig0PZUYgiHCkyv9r5c7CE5f/s2hB
	hddrfgxcLphAxs0ELlxXykpPQ2VDBnp8UjtHZwbJnYfibAqu9zcfvje1+zHQkGe4DO2a2WoA8TB
	Dmhnb9JbqDaesAYcd/NSPhg8PLZHxz1wx8aNRv62oWEKE3L2XoP6UBpGctyie7YDnJx9hSUfqyk
	ceQUU3Q3zpEBNYVAcvSNT+H2KFkdXRkKM9AjjfV4HqQZQf2Uxshy2NISR+n5SmzoC+6ni8wyLeC
	yDzv2hnaTIDSlaOmYsWOKtzNvtUxncO+qtI0XAzDQDDZ9vRDWAp1VBcKxCrktl0LHZzu7nlJiiX
	wGJ6C7xPyu978cjoH2zRVo0oLWlpcuyi9WfGDVigfoNAGDUUG3e9KVDwTeixk=
X-Received: by 2002:a17:902:b414:b0:2ed:e0a:1138 with SMTP id d9443c01a7336-2ee0d66682emr16000605ad.4.1794559892624;
        Fri, 13 Nov 2026 00:51:32 -0800 (PST)
Received: from [172.22.0.2] ([50.175.87.158])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ee0f7e48e2sm6970455ad.36.2026.11.13.00.51.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 00:51:31 -0800 (PST)
Date: Fri, 13 Nov 2026 00:51:28 -0800
Message-ID: <5e66c6e1fb0514242c89504ce624773ad54f50bc.1794506262.git.chris@chrisdown.name>
In-Reply-To: <cover.1794506262.git.chris@chrisdown.name>
References: <cover.1794506262.git.chris@chrisdown.name>
From: Chris Down <chris@chrisdown.name>
Subject: [PATCH v3 2/6] mm/slab: Enable SLAB_FREELIST_RANDOM by default
To: Vlastimil Babka <vbabka@kernel.org>,
    Harry Yoo <harry@kernel.org>,
    Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Li <hao.li@linux.dev>,
    Christoph Lameter <cl@gentwo.org>,
    David Rientjes <rientjes@google.com>,
    Roman Gushchin <roman.gushchin@linux.dev>,
    Kees Cook <kees@kernel.org>,
    Marco Elver <elver@google.com>,
    GONG Ruiqi <gongruiqi@huaweicloud.com>,
    Jonathan Corbet <corbet@lwn.net>,
    linux-mm@kvack.org,
    linux-hardening@vger.kernel.org,
    linux-doc@vger.kernel.org,
    linux-kernel@vger.kernel.org,
    kernel-team@meta.com
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: dm9mq4akzyjus8iuz7pqzp5dstg881ae
X-Rspamd-Queue-Id: BC11A40003
X-Rspam-User: 
X-HE-Tag: 1794559893-66306
X-HE-Meta: U2FsdGVkX190LwmBQRqyf77bxr5k3weWHrJLyrGsgOggI9XPoN56oeX7QHJvdcVffJNFW2qMyHWti5QCiuFl/eDOik5FBY2z9m9COSNDA+nY0HDRvwKvq1bIm0h+KXsrEcbGpxRXj6znt7GKJhTGrCAsuAqmnS8GQ8MldpG4O6cbVpacFuSNRTZf5mNmxRoDPIr35Lh77YNBg4ZNnwlv1Pnh2ohxnxa2X9ZuntgKGgGZGEb2HwQsfvBOBv3mcJc+huaFjy83NdRFECasZ7q7AJapePEXwwXBnkPxnrY+m+2iCQF0JzAhSUaHSBFiPLJx/AVTk++C3kbqkJcJRn5HjoXXA4hyb46V75QB8gy4GP3h1GYuEj/c3pGFFIdzGbSLFgq7eYgnXFQLQbYK5MQCbvVt0o2g6DLcjYny7DuY0pJGyegPqWg+AGPSdv9L5BIWiB3anlXk3TobfVAtLffO8emkfFbaHMpWUIHQNdXZS+RFnQgYZj4NPufgnt/kLTyQ5bSKKBQ8zhaQSQDKvdnnKw9D0GzApvcDBxDkpDm+NC7ihMe4sds9hs/F8HLOKAPuu5bWz3rZFnAEXPgS2LXt/JatkmqS9fxRhbqfxeQVTomcowFJMuqNfu1OEtVFys9rq+PCbUrqMegvAoK1r02G80K46loUxIPv7OZ1JDo3Wc8yfIBPX8CY7fY2SbyGLhC1/U0FowyBXPe1cyrq0hlBnjxIFm9QYKdEA3iWg3yE+ydZwTMKrjGB711ZAR/dvdawWqHNM+rB5Ugis7tI8n3mtwIL1MCvTCEPPDCnX17I1g7Y6KPfADPOkVSn+tc95ydqQ56chOSkFi2R8nb89HF2Z/VlkTv5MKs6i0H4LhDkkjLwQ/EQ8ujmXVV7o496Esr2W6LiVBsv+F6PVD1weeATqFUcbokGyTWAqpXCh1LYNlTpCTLJdy0xKHmMcbFa/iVnEiSd5zK5GrsTYbJ9yUO
 UMCj8HUu
 Mx9t3ZzCWz0N3J1WgdQ34eNsAlJloi02KRmdRz1G3VpKs/npS9DCedBVt9qBzKaVqFmk1n87p5FVgIkJV2HzO0+aZ76kMAoV6+PMl5QBi+EN5E/XE9viaROlHeCM4grkt2T31FiZp/AQIn7w3JGTQ9G1KHgf7PA4kwRd2kgGQHWWGiuNxdDFRYfT1l0WZppJc30rhKm5fmRckOKt27Yp6ZFdINQPQQPh9mccOXpDRBFWrKDxEGVxEZ/bEopMfHpIDYjQJmwlCSMuJe1WqWoWiPlwWDnMWkf2U2ZZEE5ogJJCPRX0S8Wmx/ziFYLnhffUjeEGetdy7wtioL7tm/JoP4/5vCgqRj5kCPSWb6rI85MDphggJ+4OWsintjxeZPxR+mwtcAB/ncaOVWSCCbDvQnG0KBc1T9EOXeumc2I7gArXOePAbAT+xMORp8M00Tqz1//XPE5OHcabdBk/SIGsaz8EcdalAcstfFceNazu+Cj0PfBg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

SLAB_FREELIST_RANDOM randomises the order in which the objects in a new
slab are handed out. Like SLAB_FREELIST_HARDENED, most distros already
enable it, and its cost is only paid when a new slab is set up.

With it on, the same system level benchmarks didn't change measurably.
Allocating from new slabs does get slower, by up to about 30% per object
in a microbenchmark which does little else.

So let's enable it by default too. SHUFFLE_PAGE_ALLOCATOR defaults to
SLAB_FREELIST_RANDOM && ACPI_NUMA, so it's now built in by default on
those systems, but page shuffling itself stays off unless it's enabled
with page_alloc.shuffle.

Suggested-by: Vlastimil Babka <vbabka@kernel.org>
Reviewed-by: Kees Cook <kees@kernel.org>
Signed-off-by: Chris Down <chris@chrisdown.name>
---
 mm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/Kconfig b/mm/Kconfig
index f330c2c29fd2..d174537d941e 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -200,6 +200,7 @@ config SLAB_MERGE_DEFAULT
 config SLAB_FREELIST_RANDOM
 	bool "Randomize slab freelist"
 	depends on !SLUB_TINY
+	default y
 	help
 	  Randomizes the freelist order used on creating new pages. This
 	  security feature reduces the predictability of the kernel slab
-- 
2.56.1


