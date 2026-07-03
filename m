Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77F8BC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 12:32:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C2086B00BC; Fri,  3 Jul 2026 08:32:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 573206B00BD; Fri,  3 Jul 2026 08:32:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B0616B00BE; Fri,  3 Jul 2026 08:32:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2650F6B00BC
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 08:32:26 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A520E1C7AF3
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 12:32:25 +0000 (UTC)
X-FDA: 84947403450.28.F35C464
Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	by imf03.hostedemail.com (Postfix) with ESMTP id E915520005
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 12:32:23 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=PTHCBap3;
	spf=pass (imf03.hostedemail.com: domain of 31atHaggKCKQNEGOQERFKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--jackmanb.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=31atHaggKCKQNEGOQERFKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783081943;
	b=7bEa97XKcsMhEqFioLuf2kNCKmY0uYeEXzHeG9Ut2MHt/YLM2KU33sMfz08DUAfKAHJeov
	RgmXnzFZqFzwKT9ETNcCaiWEoDqapFozzHaAGZPrR2+VkoFpSUSW7UsGIAWxd6/9094AkU
	EBnV6mYHHcen9g9H/uhLCKZx9Gje6mA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783081943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g3NbrxmcBD9wRA2EoZZ8V+E4lVFkjGW4tXUzXfNK2+Y=;
	b=6vV8lhvpCSM3qxIgHPMeILxuhW8tl6HJ+oOtkaUdlJaLayM3D3E4t9QLraiTudC/FEsbeP
	UJt4NqiQzyU+Xw4Ce/oFy0Bd8kFySG9Jfpw9L/+AeQIkMsx4IoitGL7ApNN71QKKbnmiBR
	NCwPycAy95YstOUHE6kZI+ewggSLwA4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=PTHCBap3;
	spf=pass (imf03.hostedemail.com: domain of 31atHaggKCKQNEGOQERFKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--jackmanb.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=31atHaggKCKQNEGOQERFKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-c12690ff1fbso39530566b.2
        for <linux-mm@kvack.org>; Fri, 03 Jul 2026 05:32:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783081942; x=1783686742; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=g3NbrxmcBD9wRA2EoZZ8V+E4lVFkjGW4tXUzXfNK2+Y=;
        b=PTHCBap3ifF6sbktX7tcUSxgg9JSSIhQmGcnea/d014rNeHWm/OizSTlYDyI9/kZ8D
         xP7qjMXDks3P1vMbVL67yZsg9FgAeEVuxuXawm/+sqyY0f8nwHsByFcJQ3ZyA2eAm9pf
         liQsH8/mF6Y+t9UnjTphnIjYp0QDvPCX6RwO1ShWuzxMKQBkKlFM8yLwLUIbVlOo6t7Q
         Fnx830K6+8kt9p06CNekG6WXZFxWdkXJfwltjIHZZ75XNeapl+wmmNy9fgtgA0aO3Is9
         SsS3EzikwuAf/D0UTirobnMDP15uJzYWVZBrw/VY1uC5hwHSCLURbsg7tE0MD+ggKoKg
         1r/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783081942; x=1783686742;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g3NbrxmcBD9wRA2EoZZ8V+E4lVFkjGW4tXUzXfNK2+Y=;
        b=iJ5x/WzXqYaIN2HcDoG6GarNLditiGdT2tQsJ06lQxar0YGQfAg2imm/ZD9meVoxa2
         7P4QnPEh249DA2Umv1BSvT3DCNyBvgLGYoaY0Xu21XKc1J+JeMF8wtoC7BLXVEbrpWj8
         ZnZz23Vbs4ZEMEdKGiE5gIIDTdKRXyH02gIWg8Xaf/BxOmn52IuH8qoL7kfy8KDryaHW
         AjE9In7mVqV6zFH2InqAq51UtomEeghSp9hTSFYSDIoE0VKV0dvQ3wnLd6NCp95WkInH
         RALo1Lgd8aCTLLU8c0MrhJF0Tk3OCT/B9IiZssf4p4TnAZ974eFWfOa9z91ZbnBLvao6
         NwTQ==
X-Forwarded-Encrypted: i=1; AHgh+RoGz9xkUVuqNGYC/Qt6QtpHR08lWHXYSra4dyLHrrXHHavG5fPGhLLog+07MBQm9XY2H3ENQU2WWw==@kvack.org
X-Gm-Message-State: AOJu0YxZyvy+hh6tSqMD4RenmnOcAcN/IZ2f6UhJ6JlXVmBJLHAYGCfY
	+j+mrtmh2I1yBzEL7i6h4mmfV5wF+FXIOmwo60/atETx9zmwOtkAwJrgaJeoz5uMf4Unu9vkMQI
	pTlbsdTS9rP9Q7w==
X-Received: from ejcho12.prod.google.com ([2002:a17:907:e8c:b0:c12:70f3:db84])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:906:99c4:b0:c12:b301:13bc with SMTP id a640c23a62f3a-c12b301156cmr388781766b.19.1783081941979;
 Fri, 03 Jul 2026 05:32:21 -0700 (PDT)
Date: Fri, 03 Jul 2026 12:31:43 +0000
In-Reply-To: <20260703-alloc-trylock-v5-0-c87b714e19d3@google.com>
Mime-Version: 1.0
References: <20260703-alloc-trylock-v5-0-c87b714e19d3@google.com>
X-Mailer: b4 0.15.2
Message-ID: <20260703-alloc-trylock-v5-3-c87b714e19d3@google.com>
Subject: [PATCH v5 03/18] mm: name some args in a function declaration
From: Brendan Jackman <jackmanb@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, Gregory Price <gourry@gourry.net>, 
	Johannes Weiner <hannes@cmpxchg.org>, Alexei Starovoitov <ast@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Hao Ge <hao.ge@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, 
	derkling@google.com, reijiw@google.com, Brendan Jackman <jackmanb@google.com>, 
	Yosry Ahmed <yosry@kernel.org>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E915520005
X-Stat-Signature: h7j5sju9yjkix3j919wf6qguzqny773x
X-Rspam-User: 
X-HE-Tag: 1783081943-912602
X-HE-Meta: U2FsdGVkX19WYyRdT4/oxpTZQOEpD3j+xOHk0AV5M5OE1Ca2Dt86Hvlisft5RpirdT9a4osmk5w/5GZj2aFjfvO5k/yjLvIltFGEQxHsajgZfIlpFRtFYqW0CgwGAtJwBjJ/yA737el/Fh/hKceJ9yWucLxhvyjnJtAerdmwiOusMCQ+qScphUHnV+V2/R7Y7tTyAJpVzOBu1VIfjSAcU/ePE7CApg1o+iajNXJhC2WZ38YOQF9Ae/bwU3dGVbPxxHNEfPP8Jwmdit92OnHzg7lR7COV5c5XJmep5p5e3q4EVjf9gzSt5ajUgFytaGTXPL0Dte6uxpuyyedXH52lH2nAYg2Pkz1i3j1iK9XlETgjrnXRSbSWHGagVZ6sXNIkuFO4VGme/coZe43e7J/SoCrccfF5RcNKAkUmccYKgRDIR+ponAd6z5zDEdiGGuoUYp1lKQlzh+rNzEC0JmE/Vd9kAUtPeomGpAtWgiv4S3btDXHBjYn84rC8mGeDtjxSEgV+/C/qg66VSv2znRaCMWMbya9N7bO9SjZFHRvGbrUsov12QZMCrYiB+cWA+j3Qz29GlED+QX93IkZYWu6jl0VPPWw7CcvzEAFS9InClHH+H/jYvqEadMYq1LM12A20yFBpXIr801Wm7aCKFGOPVoayLUfkERGavPhF9ykGPjOf1lnQEWDxyyTmDwrdFyfb2DEDDMaGOV/iiIkCV5GgN8XbI6+jWv28HRuoGM/wc5z+ze2jtvnh+UYXpimAxzNshH4ZHMNs/FmYAVPZQcfkz4loYhfnR5uSu845Lnx9It4z4avgGsKk+cQJzkkedDUus3iFX5GwGHWyH4FZD3f1QjxEYxRfaeAndzoXsDnq787w1ltpp4CPHgHdi/OBfxwDw79bOxgJiErEXaXOg6nhDGOxZLnT8LBTXiGh/eWchBnCrk+Pw1D/rnaRIrAOamW/mW2VBPn2Nyor1MKT71t
 3HCd45zO
 PND27gvIXkyruwmxQwDaEmWvdOv6XYRzOXLGS8Vbw+vIaWkLE34tRbrIaT0Fmz+xpiTejulvs7b9s8F99ME6Rlx/ySQx2aBLet7n6iKdoP9pJB3eaTPNDb+ouUQC/RdkdvQkEkWKNA5Iiy9/xcDqjb+QhJiEnzBvbKir8WvFRu11Z/FyE93zOIsciWQQDJ25zHt22MuXHo6fX2IZ0CiEBwYu2KXvBWohvXbPS3TbIRDxp5PO2M+9ZJoawgQy/mrdEln9Oqd4z3JIS1VFrNGjm7qJGN1C1U2I5FA+a+Yp32TQ+EPe1Nk6OZSLKX6krP/pcaDwK1d6v5fl3PSUEEhQjR68mqwAS1ZraC6E5aWK1s0IQknFjXXrDuJn4+LW5bPaeN6gsZGg5avhLshdFUiF+F6RRIw9tbfWcydohFgKWTAVfHOQMqZHcUaKYEk52sob+YkUJ9l99cBjZCT9L/xXC1Dux5qYaSe5pY0qgs28CF7Y9sVf49+mMzG0pPFPtvyxgDj8c+hYp7W2CawX0hr546t3MOKTPs0z9tKoO92+Y+J9JjO1wAXFPtBFxEqj/21aBOJsHN8ac9UFzEZk2Gu3mLgAdtnZrTOXafJtuZovPgUXQticmiyCqItcDM+kwBMFo0RR3/gmBMoDFM3Or5kNKVFV4QOn9klrzKSmK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Checkpatch complains about this, a later patch will move the code, fix
it so that checkpatch doesn't complain about that patch. Do it in a
separate patch so the "move the code" patch is trivial to review using
Git's diff colouring.

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 mm/internal.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index a2b09a13735bf..1e252678bbc91 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -919,8 +919,8 @@ extern bool free_pages_prepare(struct page *page, unsigned int order);
 
 extern int user_min_free_kbytes;
 
-struct page *__alloc_frozen_pages_noprof(gfp_t, unsigned int order, int nid,
-		nodemask_t *);
+struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order, int nid,
+		nodemask_t *nodemask);
 #define __alloc_frozen_pages(...) \
 	alloc_hooks(__alloc_frozen_pages_noprof(__VA_ARGS__))
 void free_frozen_pages(struct page *page, unsigned int order);

-- 
2.54.0


