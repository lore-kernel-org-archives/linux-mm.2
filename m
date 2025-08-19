Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D8D1CA0EF5
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 00:36:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 401418E0001; Mon, 18 Aug 2025 20:36:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B2496B00FB; Mon, 18 Aug 2025 20:36:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 167FF8E0001; Mon, 18 Aug 2025 20:36:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F337D6B00FA
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 20:36:28 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A37F38280E
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 00:36:28 +0000 (UTC)
X-FDA: 83791640856.09.6760034
Received: from fout-a2-smtp.messagingengine.com (fout-a2-smtp.messagingengine.com [103.168.172.145])
	by imf10.hostedemail.com (Postfix) with ESMTP id AD21EC0009
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 00:36:26 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=bur.io header.s=fm1 header.b="d 4Nt403";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=m8tmXP1C;
	spf=pass (imf10.hostedemail.com: domain of boris@bur.io designates 103.168.172.145 as permitted sender) smtp.mailfrom=boris@bur.io;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755563786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GPjinPryqKE8wodzlS0UT5WmvwkmRSTuvMPtWRHQfsk=;
	b=ybwCTbl1WQJ/68eOmeVm3Ja5QirIDIiDr1l9uGNz1W5F47jbmu0HIoDxmke8vDrejMFBsi
	TJBE4WqYPj5xdSa9F+h1CmYDdzDc+vF8rEJRlA3KiVGd1HdDvp6SjBklreCia3drRcZq4i
	/BtE0tEOLM7SEqOiEJdklfRTtRbDhAc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=bur.io header.s=fm1 header.b="d 4Nt403";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=m8tmXP1C;
	spf=pass (imf10.hostedemail.com: domain of boris@bur.io designates 103.168.172.145 as permitted sender) smtp.mailfrom=boris@bur.io;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755563786; a=rsa-sha256;
	cv=none;
	b=tdOMSBqAnHosGTPTXkew4GcYK5uc21sUA0WwWA2fzsHY9tgJEGD/H8Dxg75H2J2DrajG4z
	JwTHOPVLkWlhrbunj7s4ydFFkqfX23INpFXnIeS4A6B+W1yEUuiV3heib3eCI/eLHN1ueV
	bGSqcWiXwDyb39nOA8c/PGa5ou7+hXs=
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.phl.internal (Postfix) with ESMTP id 09B30EC0854;
	Mon, 18 Aug 2025 20:36:26 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Mon, 18 Aug 2025 20:36:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1755563786; x=
	1755650186; bh=GPjinPryqKE8wodzlS0UT5WmvwkmRSTuvMPtWRHQfsk=; b=d
	4Nt403Um8onGOK5nba99lUX4pCVianZMMsm2p3xrGwXe1jVwMwD7UkUeWYjWMc52
	uNSgdy8wEIjoJNaEgvDnHOTkNJfsEEEsxqZ4wXIntQtlVeWn28wiud04/Q9axs5Z
	G7Ma3lP9CHE6GLPE9sGKUYe6+cBQ5NZbW93UKoIdOQ1WYb7/gHeMAPGFUAZgi1CX
	jpAxgko7hh1ymCQYIb1vooivsRqvUE22xyeUvrCWvXEoUgXbPVEuTSEWwbsCBrBG
	MJXUyMimcc7JAnT7YPHC3GLr4LDZaQKpUIoTYh5h9uDSP7WhNHDJwoA4jnarZw9l
	UaawLknvaJqb1MfpMpBKw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1755563786; x=1755650186; bh=G
	PjinPryqKE8wodzlS0UT5WmvwkmRSTuvMPtWRHQfsk=; b=m8tmXP1CfMgFj5UuG
	0SJljaKebIRye8Ts8eyYMEr0kclKqkLxCuPld565DH/Ta0wHmVVSYlhAx8Dl6rmZ
	Lg1eXy7WgDWb3vtFCQzLDP/HZKw6wcN3gIrNLmqh0Qf04RcClEAuPhuJBr32J7Fe
	742GiDuAXWIsLpVzGbIlmM544/USBoG3mN0bQg+XWaiDpz62iHC7i+ayMe+m7SvH
	nXb1PjyDDMuelYd6VzXkqNpw/PoeqAUNtsNu+fepP7BfYZXdHQfCjgcqWinlyAML
	Z+viHHRNylKVyPQIMZepWo7OJdurGkP64TMLUlfGPjOeE3xdGgfNFOJ3JXAZ5p1d
	Gp7jQ==
X-ME-Sender: <xms:CcejaDT5s4XZvaF7XhlmgkDqP9LXx2b3EoCNZBY4FOUSZU2aBFzVKg>
    <xme:CcejaKRpALqVGue8uunsTQVPvJtumzzcs0tKEGDLI1rvnM5PhEToGgRAgxPm9Ce8k
    qjew-HQgcyjn0sULKE>
X-ME-Received: <xmr:CcejaH4kRVf4DDxqA4aSi04-ZNe-VHFx6xO9Pn9Kc-7KN-il41E_Q84KBr34aX39Se1hRyKPQIUB_QQP68Yl9IKXuSk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdefgdduheegtdeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpefhvfevufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhi
    oheqnecuggftrfgrthhtvghrnhepgeduteffveeileetueejheevveeugfdttddvgfeije
    fhjeetjeduffehkeelkeehnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehm
    rghilhhfrhhomhepsghorhhishessghurhdrihhopdhnsggprhgtphhtthhopeduvddpmh
    houggvpehsmhhtphhouhhtpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgu
    rghtihhonhdrohhrghdprhgtphhtthhopehlihhnuhigqdgsthhrfhhssehvghgvrhdrkh
    gvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqmhhmsehkvhgrtghkrdhorhhg
    pdhrtghpthhtoheplhhinhhugidqfhhsuggvvhgvlhesvhhgvghrrdhkvghrnhgvlhdroh
    hrghdprhgtphhtthhopehkvghrnhgvlhdqthgvrghmsehfsgdrtghomhdprhgtphhtthho
    pehshhgrkhgvvghlrdgsuhhttheslhhinhhugidruggvvhdprhgtphhtthhopeifqhhuse
    hsuhhsvgdrtghomhdprhgtphhtthhopeifihhllhihsehinhhfrhgruggvrggurdhorhhg
    pdhrtghpthhtohepmhhhohgtkhhosehkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:CcejaHXL-vgrAnbvQvdVKhdPjjaQNGN6OmCDsGg636Idr-jjJ7cuuw>
    <xmx:CcejaF892q2OWHq4GPQl0BhGk-4L97wQ_cH5xC5HmjK4m8EM-vTUCw>
    <xmx:CcejaPqck4v-mwolxwGl0lTkHLnbDEfXTzKSd8XG8WiHnCIdkk-8cg>
    <xmx:CcejaAISyPSg_VXXjMh5HacqgKMwzz7xCePi1UhbNLj7aTJnDwkGww>
    <xmx:CsejaCObtE0SKkeAiP-V413izPbFNaw_RNRmpf5gkr7e0SMv2zIq81f3>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 18 Aug 2025 20:36:25 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: akpm@linux-foundation.org
Cc: linux-btrfs@vger.kernel.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	kernel-team@fb.com,
	shakeel.butt@linux.dev,
	wqu@suse.com,
	willy@infradead.org,
	mhocko@kernel.org,
	muchun.song@linux.dev,
	roman.gushchin@linux.dev,
	hannes@cmpxchg.org
Subject: [PATCH v3 2/4] mm: add vmstat for cgroup uncharged pages
Date: Mon, 18 Aug 2025 17:36:54 -0700
Message-ID: <04b3a5c9944d79072d752c85dac1294ca9bee183.1755562487.git.boris@bur.io>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1755562487.git.boris@bur.io>
References: <cover.1755562487.git.boris@bur.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zq6m4r31o4iu4job444jjbqnfmbxtn85
X-Rspam-User: 
X-Rspamd-Queue-Id: AD21EC0009
X-Rspamd-Server: rspam05
X-HE-Tag: 1755563786-67260
X-HE-Meta: U2FsdGVkX1/6annU5hOfrcdEZy0YuhR4zHR+5YVDSWcPG14W5/qEKCIRzv373bm1IQn72FKqsnIOR8BEloSta2qDI2QPpPn77XXuuONMsrXhGi7DGLuVCrReUNnPePWs7h1TsEuOCVGSEPi7e5hU/JyzoyE7MjZh0oeO42K67/SjglT+ITOFe/i98oDeEdAHok99R32IhuO29h+5aoqo2ZymUz3CSR0JziaU/osyfylyYb2j1VNn6wPIJffLFfU1m6Og/AB8x1xp4ZXaQfElbM4/xCV+Jh8il0CZUhYWpHuO/UroToiu+aeZpH6RLaE+xGv6AE2n+LnCQs43i0NlnfceHwKAYIcU6UGwiyPNnFi63HnQuvFpIhbJfVmEjNCn8P9fY/aNF6Z3+rkDRL8I6LrO0EPnSHGJJCjlTsdEEuuYBvN3yK0B7NxZalD0y2xWupBy4kgRIqfFjMOM5GFcDjX+mto9r3wD0Oz2P1K2uSrTdN/qLYhjimvNmkWThla10Hb9F3IYii3x6xBlhn1MhW0cUj34KvAoSG8a2vDJIfNCihyszPhk1jBqL5AFJSyMuWlQHrD6j7qxBcpiOSHl5GcFucXzrQFwErsV9NqmesSY40Dr5AAImFec+9xGGdPexpgOq99tKP5ugD90+XHEqL+sIXp6hfVwGD/8rahKhyqA/jRvGaiUmnyW2jE5XaE5YbLkxt0rcPgdU3uIJiTNJvIkLBK3n+OI83RbhZz3Ap+pD/sjK3f+yCGoLoj/dc23+VLxUHGE1ZZFXdXtYxn0wokA4ML+ABKaAxbuYhGyJ1eQ56OrgMrCQPenWmRN0aK1d6K55XsX2JiqKufiKSG6+du3i5MKf9rgjQMNf1T4kcxm9Rqn2ExLHdkrv2oMHCzUJ2dPbxGQFORwrGu7TujGmFwK+YJEXLW0O5TaBlMOJRyE+s8SaPAP9l4oNWQT+wWFEyq/kxuLAVT39NY4wAG
 h9tGc6dw
 8c+r1NsvQ+In+1Hog33Z//iO4InuWYsieZcNcKy7UUWOmIBbAJD6gL17oosCmiCio5CCdDVIcaqs1CpXPt9lZhfK4aHvMnA6Y28hlE9SpAYuKW7w0u3R+abshKpgCaK0dz5CW3/PiMtOlLU6xcB57pXntxMUgmRMAfT05nDqRo/mODQyP+N+9tc/akUaHExVUoHOrSrb3xp/f0KJm0GykQ/LIrzmkQCQDLxiXPIyfSRcQnT2btfPB+hvfXhWGcI5Em4hiu7XUbYZS7P+Q2B12EyJ8pVQ7vBSa2tc8xwtaAGAdxvkiPkfnQV5ZGYL6JQm1sV/Zvhbl4RQST6A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Uncharged pages are tricky to track by their essential "uncharged"
nature. To maintain good accounting, introduce a vmstat counter tracking
all uncharged pages. Since this is only meaningful when cgroups are
configured, only expose the counter when CONFIG_MEMCG is set.

Confirmed that these work as expected at a high level by mounting a
btrfs using AS_UNCHARGED for metadata pages, and seeing the counter rise
with fs usage then go back to a minimal level after drop_caches and
finally down to 0 after unmounting the fs.

Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Tested-by: syzbot@syzkaller.appspotmail.com
Signed-off-by: Boris Burkov <boris@bur.io>
---
 include/linux/mmzone.h |  3 +++
 mm/filemap.c           | 17 +++++++++++++++++
 mm/vmstat.c            |  3 +++
 3 files changed, 23 insertions(+)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index fe13ad175fed..8166dadb6a33 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -259,6 +259,9 @@ enum node_stat_item {
 	NR_HUGETLB,
 #endif
 	NR_BALLOON_PAGES,
+#ifdef CONFIG_MEMCG
+	NR_UNCHARGED_FILE_PAGES,
+#endif
 	NR_VM_NODE_STAT_ITEMS
 };
 
diff --git a/mm/filemap.c b/mm/filemap.c
index 5004a2cfa0cc..514ccf7c8aa3 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -146,6 +146,19 @@ static void page_cache_delete(struct address_space *mapping,
 	mapping->nrpages -= nr;
 }
 
+#ifdef CONFIG_MEMCG
+static void filemap_mod_uncharged_vmstat(struct folio *folio, int sign)
+{
+	long nr = folio_nr_pages(folio) * sign;
+
+	mod_node_page_state(folio_pgdat(folio), NR_UNCHARGED_FILE_PAGES, nr);
+}
+#else
+static void filemap_mod_uncharged_vmstat(struct folio *folio, int sign)
+{
+}
+#endif
+
 static void filemap_unaccount_folio(struct address_space *mapping,
 		struct folio *folio)
 {
@@ -190,6 +203,8 @@ static void filemap_unaccount_folio(struct address_space *mapping,
 		__lruvec_stat_mod_folio(folio, NR_FILE_THPS, -nr);
 		filemap_nr_thps_dec(mapping);
 	}
+	if (test_bit(AS_UNCHARGED, &folio->mapping->flags))
+		filemap_mod_uncharged_vmstat(folio, -1);
 
 	/*
 	 * At this point folio must be either written or cleaned by
@@ -987,6 +1002,8 @@ int filemap_add_folio(struct address_space *mapping, struct folio *folio,
 		if (!(gfp & __GFP_WRITE) && shadow)
 			workingset_refault(folio, shadow);
 		folio_add_lru(folio);
+		if (!charge_mem_cgroup)
+			filemap_mod_uncharged_vmstat(folio, 1);
 	}
 	return ret;
 }
diff --git a/mm/vmstat.c b/mm/vmstat.c
index e74f0b2a1021..135f7bab4de6 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1290,6 +1290,9 @@ const char * const vmstat_text[] = {
 	[I(NR_HUGETLB)]				= "nr_hugetlb",
 #endif
 	[I(NR_BALLOON_PAGES)]			= "nr_balloon_pages",
+#ifdef CONFIG_MEMCG
+	[I(NR_UNCHARGED_FILE_PAGES)]		= "nr_uncharged_file_pages",
+#endif
 #undef I
 
 	/* system-wide enum vm_stat_item counters */
-- 
2.50.1


