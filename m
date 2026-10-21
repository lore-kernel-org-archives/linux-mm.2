Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49AF9606A319
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 02:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=smBs6Cta
Received: by kanga.kvack.org (Postfix)
	id CDCE46B05AE; Tue, 20 Oct 2026 22:39:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8D1C6B05AF; Tue, 20 Oct 2026 22:39:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7BEA6B05B0; Tue, 20 Oct 2026 22:39:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 859466B05AE
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 22:39:52 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E297C40445
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:39:51 +0000 (UTC)
X-FDA: 85345078182.30.E77A9B8
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2FED6120007
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:39:50 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=smBs6Cta;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.174 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792550390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UZtXCeX4FNS8qck5gj1e2IPK+BPL6kr+hoWf2wAHxQg=;
	b=giid7tGZ4PZD1t1p6KcH9CH0ChPDExNjbbBIZf06Px40SLiucHhf6AdEkX6ZDxo0AZtCq7
	IFbC9feYZ3lBCjW6OgLFBbEfDj0uv6XENa27y0c+AYKjYFzmR1GSAoiHYPc2UYo2kYIMUn
	BlPLiZKpRlizCJqFUAXr7fJPXS2pjUc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=smBs6Cta;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.174 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792550390;
	b=JqHmvAZyUFpWLjPH4VxP0UnNRR21ZOLlkFzup15ikpNSneFWFqB91SZ5POlnIFxWoB06H2
	XshSqn0bvVxZS5BkMq3ya9TAScqnjf9kRzvQNr2tuGWdMpiGlvJFFySWbVC7yVBoTSmJTH
	algDOD145WG0kLtH/EmydQa+SNJzzic=
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-93ece7a73b9so33907585a.3
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 19:39:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792550389; x=1793155189; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UZtXCeX4FNS8qck5gj1e2IPK+BPL6kr+hoWf2wAHxQg=;
        b=smBs6CtaM/4tdRfQ8gWg9UAK5g1Rqp2HzLawghSB16io/K5oWQ/Yv3xThDt6ZFJ9iy
         WWM64HKk0UFps8WDAEqSWx4z7thzrgDNjtLjAs48f+GvlDuUFsz0I+ESm4iRHHTnkD5q
         lebke05S390qYXIr+XXvY7g/gwQHTsff/MCZYsKXarYwPU/uJ050s7kAIjwGeZBLI02w
         h65Ozb1d9lszaHscY8Nw5G61TF9biAtmypDmhtHnyfXjj3AlmPH83WCcUHnW2KScpCrX
         m3dx7OQFXJINTa11/GjVgpLYI59j9EH70f3bFLQKJp3QHlZZSqEEYg+GPOiT2M2IqcFD
         dB9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792550389; x=1793155189;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=UZtXCeX4FNS8qck5gj1e2IPK+BPL6kr+hoWf2wAHxQg=;
        b=2BrLV77F+CXV8RHtBC9Ad62BjdOKYZeaajYwEFQxoqgdEGqR5rtlP552kmr/+fpTZV
         P/Ue363ELV2TSqHyUfqAyWkAfLnjaW9OkOZZUEg69tKMS6YJlvSpWGOP3QtIm1qHnPmn
         sJSFPf2czRhpqTlTbCv8HOwsum8XrM/LGrxX9ZyGMl9ed09GvL623HYl+lAsHAH3l0rS
         dfli6jjvQulx2FiZ0Zt3HSgU5fuJjj7OXq1+8dWJQHgBqLKgsYQfAvEQsUCoxvINhoLz
         qnKqE12cNgnaNYeEPyKwBmWO90WUT91BBLu+fgt/dZcfePrzA5pHybcI/aMyToKSjC1X
         XxjQ==
X-Gm-Message-State: AFq9FYKPu319XQDQVclNnhJMjFPtQ8rWiBGAyZQwgRS6EgfgmZSpwolv
	ZTHu29WyMLbwefO7TOe7K8p/agsdT5b0VoOAx7NN8+mLWgLBsECQlCcD11DtO2Qa4AQ/95mCAua
	lj+M+
X-Gm-Gg: AYBFou39dlMYMvwZqOe54m8Y56NN+8+mIJg1N/XHmLrJtQqXYO7s8mgUvhf085v0LPf
	KU68+FWdQgF4KtnTsvGVfNYNDRuLqJpVgtpnUVLaIZB2OPjMzbXabBw9oaIV0dFRuXZCoATrDhS
	U5cYet4nA2HPaG2CfSgGtw3Q69+CTq24v17cFvd2HzyreTA0OfTWCbztD9UdSKGy13s62tQvOtz
	3ZugD0bWBtR/VV2K7NebbkLQTHCudZLKOBDcV5q0QAJPLJVgKTjPTB/4oFW9zrMAqX58UWgymTC
	lDTwLxfvfddJd7f/ixIuvr0XOpFetzDWcUDRVYi4eCjC46pFSTVqabvSYhAqZ6Erb7+f51fhLlM
	mSatWgetE1FweyIgvNuLBVBgVI690fJ09yJaGfQuXEestUOfwd3JVBAgrprq01L5pAHsgY+2SbF
	3+p4JpiLHui1Io4HIxgASB+RVzAuYIfFEJv5nLpc9w82xhi9hpUwaAxKpPYP4sqyfd1+G/K2Hl7
	4wmTPFKVtH6egpfSS22zucgArTtcd5yE8/4LQDcfWBU6hj9XwJBIatbX0dewUl9nahav0SXcK5X
	VT15B7Puvo4NqNrlZPHpWPe2XXCdjfRaEqvxjboEDA==
X-Received: by 2002:a05:620a:3913:b0:93e:66e6:fa4 with SMTP id af79cd13be357-93f57f05079mr224040885a.16.1792550389393;
        Tue, 20 Oct 2026 19:39:49 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c10a45336sm13819426d6.3.2026.10.20.19.39.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 19:39:48 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-rt-devel@lists.linux.dev,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	mhocko@suse.com,
	rientjes@google.com,
	shakeel.butt@linux.dev,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	muchun.song@linux.dev,
	osalvador@suse.de,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	bigeasy@linutronix.de,
	clrkwllms@kernel.org,
	mgorman@techsingularity.net,
	anshuman.khandual@arm.com,
	Bessel.Wang@huawei.com,
	jiang.liu@huawei.com,
	stable@vger.kernel.org
Subject: [PATCH v3 3/8] mm/mmzone: read each zoneref slot once when filtering by nodemask
Date: Tue, 20 Oct 2026 22:39:35 -0400
Message-ID: <20261021023940.1940971-4-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261021023940.1940971-1-gourry@gourry.net>
References: <20261021023940.1940971-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2FED6120007
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 3phdhee4zxoy7r54im1heneu84ms85qn
X-HE-Tag: 1792550390-815739
X-HE-Meta: U2FsdGVkX1/IvQjs4sUMDsNr3VGepw+Iz8cFDvKi7x/doFPb1hJ+5RTjPHndTNA7aeJukyBzvwr+f7GEbZVQscfolz3L+laI4sZIhbnC6S98cSF4hf9VvDiDl9Ks7j/UI0azSAKK2Fgu6fNacsWOnggByUX0/sQmEdOG7rT/SsLs4dUoDjAmW/VfOp465H8MLqEstKx687H4sHf9imkuuzUPgnQ8fk/u+bAi9FZQ3qOqAZcxrx+2tNJDo1kp7smcoYuNLP3ho5AaLPMPxOU+n15Eu+pwqd/7rBVV7hggfeJdG1chf1Q5lex2DYQ2Oq0Xo1cUUlceLtM8HPAwdYIhz83zXZcnCBtjbZykLIz8lGyKiJcIXqziQuu48ZwtVjtGydEA+DrNJJWq0Vs2s1SolcmIduund1YGJMvKPz0msRaq5QDB+++5JHbgJZhobwDdstqK0WjUMu83hFqbUL7MBCQJwhRamVyXZ18QewafyjSdzh652NII1r77lVO0H/6NtNxSUci9m0w7Ny65kTVdkgmELvUV1Plcl0LIXbx8+v9fiZn3AOAoJQraVLDo9C5FFp8hGEcAkmVqXjA1e7wLElZ7figmrPhI/9T66wprqHBoDuHEZycBctrtsFrGjgMsOpT6HvWDMuNB2KK18YB8cJVic1GW9lcWKSRQ5i9qL9HDH/2GLqunhT93W0PMNX8fPVYWlv5pULx5/wd68zCmUO+mZGERDt8I8c0OaDwmsWVPeXb9ZpkJLdXrnc7hCsq99Xj78C3ZaAIxjdshlAwXWXuKPvqkSf1vqgFJ1tv3vcJvUdunoTNgMGtkCiKtjb+F9xKWo42aWn3/bK5dsTlksqb4lTzuY3px8wFoJOE7QM1knLTd+egM+u+kgdNCEJlwX+mw3vAkJPNHjiE9TBK0NqqfNvWLy28rnHMB0nlPoSOQUuDxzBqRxckGHKDJ3KI+nbx2Evh51UlIc/1DitD
 L1Pwngvr
 csUhqwLR003zem/nmfD7h/cGsoFfUB1KLNAN+hWjY53iOJI3I7GNb51j9ID7mr8XHI8HyA3mYx/qkLmOdMzGCMs6u8Jv3arJ3zaEHKYrtap08J1yapSxZvGdeLDcwdFbmrxOs3x8cjmaD9fFnMNk0p/k6LkRjpALYZ/YVqrmGuOkCD2nNNPWBzZHQxV/d3qRDmvUvjBtHHLQ0hGU3tXVsSQBLDcxtm01lerHWhIOUO6I0ZxV9S5lMBy/i2WNF3Ww0r8xuR/R4kJrVMRrjjFLkQ33xluYoXha7s0ODfQ2D1d6DeY0jOTvZXIHOtk3E9YfDGd2FU3oJovkMdTceH721ZUhRcU48c4pH7ejiAnt9kkdWvOLZ9Wfhk5zQIiw/kybFaQEE8iiRzowUA2xVv3TEa3t+aA==
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

Current GCC and clang merge the two reads, but nothing requires it. With
mm/mmzone.o built with -fno-inline -fno-ipa-sra, holding a nodemask
allocation between the reads while the node's last movable block goes
offline oopses every time:

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
---
 mm/mmzone.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/mm/mmzone.c b/mm/mmzone.c
index 9cc9ef588580d..009f1dd75dde8 100644
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
+		       !zone_in_nodemask(READ_ONCE(z->zone), nodes))
 			z++;
 
 	return z;
-- 
2.53.0-Meta


