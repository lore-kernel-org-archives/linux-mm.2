Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39B42606A32F
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 02:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=kBBsPFlZ
Received: by kanga.kvack.org (Postfix)
	id 655AB6B05B8; Sat, 31 Oct 2026 22:14:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 607696B05B9; Sat, 31 Oct 2026 22:14:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F56E6B05BA; Sat, 31 Oct 2026 22:14:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 214476B05B8
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 22:14:01 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8F37240883
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 02:14:00 +0000 (UTC)
X-FDA: 85384929840.16.12622A5
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	by imf11.hostedemail.com (Postfix) with ESMTP id CE3C340005
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 02:13:58 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=kBBsPFlZ;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.43 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793499238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PsOknrkq/nzec9hQG23km3v2sM//hYMRVRxTHFDDb+s=;
	b=V/djkR2DDRotXKGHZDM+wS/IFio7FV6utD/lmg2c2Uja04x80rgH8T2UzSrs8Wfgk6/274
	BD4JjZ5DNU28ss6tRWihcjc0DXepHfOKicAxg1Vuaxw4oxtb1vNX0u/tfASd/vd3GAq/Ri
	2bJ87RFsJ745kCOSrQRNVAQxgqHqO48=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=kBBsPFlZ;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.43 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793499238;
	b=Rermod+ryW87zI3gV7vtVJaJBNYjXcst8cdOyLAZjl+c0FuwdRYh+jtWnoVeeGlwbJgqV+
	LQr0Eaa6oyEHg6w6dtjKsUrfoKVjbE5JWn5r4/pU2zXwEY+OS5U8qxSUBoU0UXe5W5KRi+
	cTAqkXOTN7G/VV7bnJ12LO35PWTldIQ=
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-91c5e31bea9so33057766d6.1
        for <linux-mm@kvack.org>; Sat, 31 Oct 2026 19:13:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1793499238; x=1794104038; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PsOknrkq/nzec9hQG23km3v2sM//hYMRVRxTHFDDb+s=;
        b=kBBsPFlZf6pKAHjIbyebPEc5Go86Z/rQ2l7edE5eTAMM/m1AlR7M9XAv01DBgtaJd3
         liUjGKIR1X2AvsFevVbDbxvp+56+z+29u2vOZFbI1GlobcHKE2Z8uRFhmco9WAwcbAeF
         gdcFP++rcQOFrsjeSgqH5jBgm02fkFrvQlfRE8rgW6o4CYVnxCgjLUbKksJ9iVYDB+qD
         X9IYLXBQupi1tmkHAkvJY02qAS2hKzA2btmoo3SVcYy8obYaVFjxiOBcUX6wux6Xn4io
         3n59T272HQGcFhaet4Hzy9ljRWl+bUgeV7exK+1tQ5RSF79Sm3Xz1OmYpPoixUgXGszm
         JMxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793499238; x=1794104038;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=PsOknrkq/nzec9hQG23km3v2sM//hYMRVRxTHFDDb+s=;
        b=rQIy/XGqAq3cnwqJp1OZnPzOt9uVI4fJBMUuaI2A+c48sSdhojBj1LGygt67RSn+XI
         qQdEYf7CjJemljw9NP4MwSB+s3TbAg5S2LQXbrXSK9hCbc4MTmCT2e0j9+rFUpwZDxNc
         zh0I3+RCL5iDsURjZRLcO/SKwzV1nuBG6AGTKSBhX0uZTndE0Ma4khC0/ks89kUCuscO
         t5n35swX4oe942KfAUSguz9N9woeyvahGNnhKSt+oVPMmM7mFsw2iWJGC4UhEWhP6SuJ
         62IyWZUTnRRN2rcfm6UopPFQmjXO7XAzQNMGPBm0NOMKxoB0C2rT3RbFNtraOklkKUvD
         pYVw==
X-Gm-Message-State: AFq9FYIOUUH+3sXmCZiCSwpM/OSleIWWjcfQoq9OFDfnCbexUgD5wMfK
	w/DIorUHl6pr+GYVlAXNtpzctgcP7x4kqBHWmsX7cIqggqok4EyGFA3dXIgq9mDs68BaNRSvk+Q
	HT/+B
X-Gm-Gg: AYBFou3VTIfFjMhWv2Wwuw8AGfCXioPLqZqIN3RnpAsYjxvHc+rCasDP1AeLrNPHQHj
	An8m06IeDnIRlH1PDsTm81dm+63MEiOAiavXpA4sX90mEXbWspdlVshTVL+1ybYcpRD7pkBqVD3
	BilHJuN1psOJXpiRKl0k3Mpm/4S1rES22UqQePZTC0iLc0ma5ov10H2HjDtAWzMIamLeenV9/7l
	sLk7oLdVWTTerWgxkS0p5sJqyuEbRdzerHZHirvtrWa7IYPVL/8JNwzq/NmQ0UiIsbVXtyCdQHo
	RAdv7rXwEZEUQUlNmiOviQnb+e6kWw5cy4KN5fLx46zcT0Geng4fAiLX5W8j7zQjMYLhUBbL1zQ
	x//8YQeNaiO/dv0FfiQCYf34ajOWLV96E5+uCIkpKUt/0vDY1/PryObrgZPpAnqRCwXYQHrlueX
	CL3b4MtCdyY+p8iWrR46AsLNt2/pt8RGABe81AmXBbrLP4TEuqg0o/vLX0i825Vw9FnOWNIEwYa
	3HFD1txVCUC+BQHwyXvs3wAl4MRpiD5chzk9jqzu8WcUiHj7r1KGpqHG3TsYLdrrPcEoDZiDvhW
	vCSSl2VEWFBmUKZQz4YApUDt2APV2gC4tnD/VQUHX031dkYKjChq5k9Y2wh8mF+ZFyVLclIMlf0
	8vqe1PCxd1w==
X-Received: by 2002:a05:620a:45a5:b0:93e:e175:ee92 with SMTP id af79cd13be357-9442175ae0emr1102271485a.39.1793499238054;
        Sat, 31 Oct 2026 19:13:58 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-94425858552sm498131985a.18.2026.10.31.19.13.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2026 19:13:57 -0700 (PDT)
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
Subject: [PATCH v5 07/12] mm/mmzone: read each zoneref slot once when filtering by nodemask
Date: Sat, 31 Oct 2026 22:13:35 -0400
Message-ID: <20261101021340.2251928-8-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261101021340.2251928-1-gourry@gourry.net>
References: <20261101021340.2251928-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CE3C340005
X-Stat-Signature: iye8hqf1aji8mewy57hn1bpa6osiz3mk
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793499238-229029
X-HE-Meta: U2FsdGVkX1879o46EtcDAsgH9Qva32VocHZzDGzTPojyO1ikUMSxcGopvkvxKI/HDSENrYthqwyBcPtqkuPxUx7y9y9M8cJP+Dn458WjvpElkYmANdJEgYmgdSEZWZBxWDBShS0RcdOmB435Zet0HVSwHHg4U0QtQ2HxyEH2qfQC4klCYd/F2USUQdxQOFIPmWi9rNrIgzn6QjD2BThCZsqi7T4VXr/WxWub2l4GqbyrkkgLmqYQ3hc7holRKw+tvMWmOrCJciFQF1YslvnEkuX04ehKfMFfdYYH5tHGQWM07fBuz3KRfyLxmR8MtGeHte7m+bhELVaNcwvWtrebiwEFGmUJNLYh6RkvLu5Wd2BHZAl+IkDwtBA7IokUjwbr5yJWRRYPE1JBh1rjYiS1aGZmSoPl6MsMUuqTeYB9gJxFzHslqtwFBOkma/96k3cHRh84hB+k6hJQKgTr5cCeNh1YmKkgLJVxtVPn0R7F50LNEjrg691ufXyRS501+xpy3DyqGhvKhkLgBR5suxDlXfgpKYOuEIbEw3vbh+f/v2bShGfO+x6PUcmdtJU1nJgi52c5KTsMS2HexNRpzHkdBqb7nsbiBAT6FjM9ruEWVzgg74ia0b3umG5D7Ur+wDQxB8pE5M04O22eprMA7iTtEWTz2v54wxtvk2ylamDddbZIYG9bL6M3PmkHV8Szzd28lbjs48d5tCyJeFiPMkmwC79JsH2EO2C9rWPB46fsctFIN0xhBeqHfXL1YVYsTCPd36zwfPtZsG9CcUZD0sDJKyhxX44U/8Fr0xNKnB34acohXp7KVMA76waqCk+CUegjL2AJJfRouq0G4n8ZnPMQSUhROxVf8nejQrPW6Dd6T8SAVhgC1067PzxdHUyq2ATRu7z9U7KkLhw/JW4eoWKQ05D7qBKOEMJ771wh/FF1Z01OnsaHkXnxKfUSYphh2dt/MkNbvAgHsOq9Mf2iJuv
 WRyzxoNf
 B03Ks/neLflzppnlrGcQpVFgo0SoSwBYMxxJlFF+dvEyuU368CK5/M08kNU0xu6NB/nFtpEkqbuBZlQNr8ETV6vy7jQI27kYHEV6w6vro5zMilkOAvpqLUtpYwq3nf1l/JCHNPqHLFfRW6Jcf7ndioianTj6s6K+0UYCranSyiygCYHt3Ue2rRZ35wXlr4GJEqQoAC72fvWV34wi2tf4DJoXhElt8gcKkJyRmyO0eBXxF9o/0+pvytqtHSzGdP9aVnovKE4PgNU2DPGU1ctMtHNPjb4xKVn17gZ38a/qCYWokgmMTDmJvVyHBh55219sTxZAVxG3XN+zuBnFxh7dEnb8eUxOC1O+9/y2D+CJ2uqhbQxqccPprwEVMgCv09jJHzlbUWGMIrrABrdOL9HST/bKr4Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

__next_zones_zonelist() tests a slot's zone for NULL, then reads the
slot again to look up the zone's node. Offlining a zone's last block
rebuilds the zonelists in place, so the second read can return the
terminator:

  CPU 0                             CPU 1
  __next_zones_zonelist(nodemask)
    zonelist_zone(slot 1) = NORMAL
                                    offline_pages()
                                      build_all_zonelists()
                                        [MOVABLE, NORMAL, NULL]
                                        -> [NORMAL, NULL]
    zref_in_nodemask(slot 1)
      zone_to_nid(NULL)

Current GCC and clang merge the two reads, but nothing requires it.
With mm/mmzone.o built with -fno-inline -fno-ipa-sra, holding a
nodemask allocation between the reads while the node's last movable
block goes offline oopses every time:

  BUG: kernel NULL pointer dereference, address: 0000000000000060
  RIP: 0010:zone_to_nid+0x0/0x10
  Call Trace:
   zref_in_nodemask+0x9/0x20
   __next_zones_zonelist+0x23/0x70
   prepare_alloc_pages.constprop.0+0x16c/0x190
   __alloc_frozen_pages_noprof+0xaf/0x330

Read the slot once and test that zone. A NULL zone still ends the walk.

Fixes: 11cd8638c37f ("mm, page_alloc: remove stop_machine from build_all_zonelists")
Cc: stable@vger.kernel.org
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/mmzone.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/mm/mmzone.c b/mm/mmzone.c
index 9cc9ef588580..65880396f104 100644
--- a/mm/mmzone.c
+++ b/mm/mmzone.c
@@ -43,13 +43,14 @@ struct zone *next_zone(struct zone *zone)
 	return zone;
 }
 
-static inline int zref_in_nodemask(struct zoneref *zref,
-				   const nodemask_t *nodes)
+/* A NULL zone terminates the zonelist, so it ends the search. */
+static inline bool zone_in_nodemask(const struct zone *zone,
+				    const nodemask_t *nodes)
 {
 #ifdef CONFIG_NUMA
-	return node_isset(zonelist_node_idx(zref), *nodes);
+	return !zone || node_isset(zone_to_nid(zone), *nodes);
 #else
-	return 1;
+	return true;
 #endif /* CONFIG_NUMA */
 }
 
@@ -67,7 +68,7 @@ struct zoneref *__next_zones_zonelist(struct zoneref *z,
 			z++;
 	else
 		while (zonelist_zone_idx(z) > highest_zoneidx ||
-				(zonelist_zone(z) && !zref_in_nodemask(z, nodes)))
+		       !zone_in_nodemask(zonelist_zone(z), nodes))
 			z++;
 
 	return z;
-- 
2.56.0


