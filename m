Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1881F606D827
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 09:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=dB/PC3KN
Received: by kanga.kvack.org (Postfix)
	id 3A47B6B05D4; Mon,  9 Nov 2026 04:58:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32DF96B05D5; Mon,  9 Nov 2026 04:58:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F5AD6B05D6; Mon,  9 Nov 2026 04:58:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 016226B05D4
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 04:58:55 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8AD011A0641
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 09:58:55 +0000 (UTC)
X-FDA: 85415131830.07.767C1C4
Received: from mail-dl1-f47.google.com (mail-dl1-f47.google.com [74.125.82.47])
	by imf15.hostedemail.com (Postfix) with ESMTP id 91364A0003
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 09:58:53 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="dB/PC3KN";
	spf=pass (imf15.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.47 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794218333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y4ad9iSYAjg8cfVMtDYUd7UWF/8ViTzGKSWLP7GmA/I=;
	b=KpvO4M837Mn9k9+6YIfmmh+bBvNXT63tkNAxqw63j3QKPun0KAUIiAmBqQGRc1727MnC2Q
	5FbhEfLn+mmWdl0yfu60xOVo3gp/LmjDTkxpKx+0XtV9SckQSkPokWkbn5mRm7jQgAqCy5
	Zsa7iWEUiibsfAVMUvCVUkfsX3RiGnk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794218333;
	b=vrR6jN3LdJ69IOBxVhdNEQBi2LOMesQYIHM2xSfgY4U/OfppTzYBwp7XyZLLjXw62QVKsU
	gbSXxKZppQUZflOBvWjxPIu3TlQ+wS5xKgfTmaEoKb1HZQKitw+Knwwxp8zvGFlUnXrQxf
	jYEQGfe5D8x6mL1oCiPyOsoG4BPHvB8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="dB/PC3KN";
	spf=pass (imf15.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.47 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-dl1-f47.google.com with SMTP id a92af1059eb24-1b244fb7fffso753104c88.1
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 01:58:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794218332; x=1794823132; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Y4ad9iSYAjg8cfVMtDYUd7UWF/8ViTzGKSWLP7GmA/I=;
        b=dB/PC3KNxs08Zqd6xmZi/nk2+307it1nmdtv485nyDtTyUhQTIadIZa02g4XiROy6n
         MwakwMMFGOCqucxzN5dt5cfu0dZRPgtiRnnn12cjEbH12eU8yqzCEOnV3kXF1dHJ2E3V
         f4JQIPGmAXfpRdXxZS2bDYAQ9kTs6rCH3i+l6+gWT4+luYpab+yGIhKldsPgw4OcvOgW
         1Z2NPkd/9cXCWl3TPAm9DAWUMCtjuUSLY3zLrOeokiNqjdLn9sBsySvYzYRENp+d1CZc
         0/fwYunebBMkiXsw9ZQIDpHQUVpMX30BIo2aE700DI4FLLkn5ABhugPWXeIVr/KRy8ai
         fCDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794218332; x=1794823132;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Y4ad9iSYAjg8cfVMtDYUd7UWF/8ViTzGKSWLP7GmA/I=;
        b=w3O07PIoBdaUuMBOZo6KnnZ99qKOP5zXQ+ux3n9KeH3UlIPY3SmMeP/dwgFmUMj8/8
         H6UZHgTJf99reMqgm3ufsiSvzSc+NbQazC6X+NvGAoQsr1BPirR5yGvqgNH7KIteGZOs
         Oh21ijnt1sjaZglVM6KoNedS28d3JKoTZvVIETMwfK8+oT38/3DxfTCxHYlcyNk7TpFp
         H+5DkLFIqeE5tBoA/bT74PvuKVewoTiugTY+jV2fNBAeAAUC9Y7Zot+D1ArWuOk/T8IX
         PISK+HB1zT/yOAFIxgCzG5sfUBj7CCPDWIn7z2e50hYcrNcoxjunQ5Ve8xGea4u7fIUT
         naYQ==
X-Forwarded-Encrypted: i=1; AL+hErHRj6iCnyEDMZxQYpw1sj8djkZJBKXuUgI3MxC2GuySoPCgY69I1ppOvS46EPTmcBR+g2msaqX3DA==@kvack.org
X-Gm-Message-State: APuU4Z+tOO25J7yLsSTVcbUl5Izh1i3Dne5x7TGGoEdTDz6Eg921M0u2
	pHekigsYriKSRggXGaQADf8/UO8snqHOtprP3l07kbSwAXkXMEAlkcVVZC4vJqK4X+g=
X-Gm-Gg: AYBFou1P5qPxr3skwdyFjynPcTR/odYP9U7PiUL9N79+83T7qDeVd63pQc5ZgBfSp5B
	BipVjs2GHacizj0XD7TIW1E/l81y2BYWqfx2292vr6+V0NAVcKBHA3peHg2ySIcQqdvh5Xx+XHh
	h3ygrXnXaL24qyOiUM5sj5CFEDr+K7K+K62BXmJvRfnN6ZNLxqobZKvKKoaauUzDJL/WYEGYI9a
	XzTp/zvoFpiXitWpzlXRip+wBuDawUnVoMiDkatUAkwMUvzgx1D6wF8V/yX9m7DkNYGunRLiedb
	iVpXxGd4XMVY4PeVocRN6fLA7evQ/u0zxRIMyQd52TlSIQtFRab24pqBa4z22AG5F3//ISpd3Pp
	b6sDLHvMwuBdOcXoTF/J6qPFZKX15PZpkWZu/wz1WHcmVFQ41AzKGn2DwFuA1fsL5r/7nLOBF1m
	LyQfSFQqCTey09kuNWCerbcefzTnJHgsaiRgdDh6DxtwdzP5ZLNL/MBgQh9N+Ffm632wCSu+BlR
	flZ4PnJIi+a/tkw+E4KKarfnpK2UDCK6FauArqF8vWOD0RHPS8BF0JigJKRSQeE2pBjdqoRlxbM
	4g15OqiG2SIZUuk/p1BjHtsKc8gJdOwLBQuS6S1lCLmv621HckIqKLn28N2Lrg==
X-Received: by 2002:a05:701b:4294:10b0:1b2:6c97:fecd with SMTP id a92af1059eb24-1b39fecea0amr5786944c88.42.1794218332192;
        Mon, 09 Nov 2026 01:58:52 -0800 (PST)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.10])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b3755e8911sm12841684c88.5.2026.11.09.01.58.48
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 09 Nov 2026 01:58:51 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	James Houghton <jthoughton@google.com>,
	Lance Yang <lance.yang@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 08/11] mm/mm_init: make __init_single_page() static
Date: Mon,  9 Nov 2026 17:58:03 +0800
Message-ID: <20261109095807.41547-9-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261109095807.41547-1-songmuchun@bytedance.com>
References: <20261109095807.41547-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: xhc4a3aacw5imxwr9jzrhray5xhz37o9
X-Rspamd-Queue-Id: 91364A0003
X-Rspam-User: 
X-HE-Tag: 1794218333-233645
X-HE-Meta: U2FsdGVkX19FYP248EIznHe08iHu7JzKLtsJHSFs5pBslklhNnajCVdTF5ews0CIdg0FzqSvVemaN1Vjj7m/MqL6cK6d2dD8EM0r8CbeB8jd4XOtGH9AnNfx/aLiDnRadCQc6HpepjXHwnoFEpdw8G/M+W6TbPidaU0+2Rv6kQqiXR+ghU0deRtod+sCpPYKxmuaB7N9cr5dDFXuRJnPRf/RqOjAlmIKWfXIqgBuZVNKrf/6unG8enFyunXEL1gpYEFeGuLo6h8QI1llVbvFhcHnH5rUSTEiVxh/7EJECVtUXFUb6g3o2MxqbGeXVND7ScARlclVKcN6zvlzKqVbyGGkLpDZk+oErlfDbgtHIPN7n3N/ErWY8l8vQVXHOMOVhNSIfpMuQaDaV/fyUTa3RRvo4BCijgWjsFnVqhtvO+2d97ZlZTiZCf45ccyzj9N82wLwPBaKwMmd52AIN5GmHUSFJKQOmXPOibPOTR9mGnr+BZJ2mXl2xTA++ha6ke63uU4o9fS8atkpN3Y899SLCy2ezQEwPH67XhkgThMilt5Byin2gvEDn3FLYc/3BCbN/ixZeTP+8hSysz9tOqiNOECclNGCyk+iNWIfVbA2xYxcDJ3WNFICFsR1oPfQWFsYQ+islh6djPBPOG13lJSzqp43Bbc+PxoJxi/gvOc7mMP1dwtEZJ+mg2Sn3BXG8EpPE8kjzmUPOl5Tj/U1N/9OSv/tuTvSrJCWStBLGIkEv1h2vFTL9qtK9WSufLWh22+pV52wlGppKPacEBHvRPyOPvzbgcLZPPs2EkTyy4S8OPjDXOBEoOjYPoxIOxxBoHBe2w/jWT+F81aVvbd4KivmpZkPGLu4RKt6r3kZxRn4rFEsuIsxj8deRFSAD6mQzinptBYvk24Okyl/pKeGGzBytDaKnCW3efS2Nk0wabBXRwU9BcqRlarm+yR5N2xuVObnCz8w/d1RgwiC9WcmGVE
 EAvanaQ+
 MxnI5HyCT+0r4xU+sLSk3ATOe34SaUJt1dqA+t5yfq+YAQoaDtfE9rOFTnH33r6BH5Bw/IVs3vD/moElKs2xAsjXtV1kASBYHof2EAJvHs0xyMaugBIOD1SdxLCdasfRWaqwHW/xR6WQSFbO18OsnDU090tOG49GJxGcXzSyR+HJQSpAcS/3UsjO/CCkfZECOpqbgv9l9p7ZLNHA3NouLiCgtq/yMQ4IyZ2Q5Mr+DhsrB9iDcDKi0w2+VEuAfOsCXBbrYNZV+/7MKYH3zZkv8gZ3zO20TRUubQtmtpA1rBLv55ILNoYD8edEjvRCPkyKc3CE16NdXq7Je3aSAqvkRy6tVpywoJtN9Hmk2KtN36MtFMj8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

__init_single_page() is only used within mm/mm_init.c, so make it
static.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/mm_init.c | 2 +-
 mm/mm_init.h | 2 --
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 458496271a44..b719e6f82d66 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -618,7 +618,7 @@ void __meminit memmap_init_page_common(struct page *page,
 #endif
 }
 
-void __meminit __init_single_page(struct page *page, unsigned long pfn,
+static void __meminit __init_single_page(struct page *page, unsigned long pfn,
 		unsigned long zone, int nid)
 {
 	memmap_init_page_common(page, zone, nid);
diff --git a/mm/mm_init.h b/mm/mm_init.h
index 1560ac9e9286..1a1cde5126c3 100644
--- a/mm/mm_init.h
+++ b/mm/mm_init.h
@@ -111,8 +111,6 @@ void memblock_free_all(void);
 
 void __meminit memmap_init_page_common(struct page *page, enum zone_type zone,
 		int nid);
-void __meminit __init_single_page(struct page *page, unsigned long pfn,
-				unsigned long zone, int nid);
 void __meminit memmap_init_compound_page_frozen(struct page *head, unsigned long pfn,
 		const struct zone *zone, unsigned int order);
 
-- 
2.54.0


