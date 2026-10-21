Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4E8A606A32D
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 02:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=aU8A+0KW
Received: by kanga.kvack.org (Postfix)
	id 33F926B05AA; Tue, 20 Oct 2026 22:39:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 317A56B05AD; Tue, 20 Oct 2026 22:39:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DC4E6B05AA; Tue, 20 Oct 2026 22:39:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D69636B05AA
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 22:39:48 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6B5B2A02DD
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:39:48 +0000 (UTC)
X-FDA: 85345078056.27.F925E1C
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	by imf31.hostedemail.com (Postfix) with ESMTP id 137E720003
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:39:46 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=aU8A+0KW;
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.42 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792550386;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E3Lrkwg+RW4zCfUK1fUmtt4kQ0h3Wr8RlR2Q+IisBWc=;
	b=D4P6Pxai0NtdRSfTeh37AquneFH+UV3ZOqMNBSf5V4QOp5TUgVSWAcw2aTMGBQN99Q4/GR
	lWgtmgnO5Jgn/zGpXAaXPUWK1NzNonDUK3hmwxjF59IAtS+B/kTE7Xipx70E5he6ks1Ids
	mI5gb9kRp/6faBDBLeoPKHrcUD4c7Nw=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=aU8A+0KW;
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.42 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792550386;
	b=Wv1e+xgCITuu+usdS5yKOqU1FtUHJKq/tj3TNl/oNxa0hXpHJCTrtz2ATuCK2kDCndgm7J
	47Cwvq/oaTlQ5D+2i80QFU6Z1mBkPxjC13wWhb2fSzTi6nJ/MygVedL6oL0Wh/eg13zi4/
	G0OZvhRYJ39iwDye8zEUEWd89cyIlFs=
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-917bab38b14so2937576d6.3
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 19:39:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792550386; x=1793155186; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=E3Lrkwg+RW4zCfUK1fUmtt4kQ0h3Wr8RlR2Q+IisBWc=;
        b=aU8A+0KWcqaLUNxlMZo62b+6ycKHnQnm1mlydaPxV5ZlDzrEW06mI8prakerpRzk3l
         hncTEzR1P8ZY5TlDCHFqzU1NR+2su3uRXQRx3dAoi3L/rnhb+E1vIh2M54yN4enjMD7x
         Sz88d8KyA/nG0OCIRSEfBL96t2OGua7V87bM+msPORwRGaWGAVJQ/JHKzBrs9GNmR0g0
         EQrI00oVjAyQId9DaExKvactLHY2T6YcM21evvA2Tf0JaMRNd+AyXCjjdAaJLa3Rn7jl
         DEUEvNoSDE0xbt+UufZhzh/LY4ta5kXYPeZmGUM6zgJMCBXUAwRGNmJ1ta2ULws+OdqX
         erDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792550386; x=1793155186;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=E3Lrkwg+RW4zCfUK1fUmtt4kQ0h3Wr8RlR2Q+IisBWc=;
        b=1BjZFFkLC98eCL8rNynsmXUri4wzFqIL7pmFi2c4ZKEBit3AazUFozo45zYA0rVAWD
         VAMopqM/baBCNNwOjdMu/wRyhI4GSiNs0nxOziViGedrBDBRq/oL3edbIsGRhtvp2GOg
         IwMvpcdnNYgV7JxVB+pHdcQPo9HwQkRTkj+5Xp5Pf96TfQgHj0Iiu5shwxPj0w8EwRJu
         Cem+85a3qnlspXTA3fOBgr8Z3t/BGHGz3bQEhOzIarczKP4vBUSNqJqihoXz4KagH9jD
         gB7tZTFazDWt9FbBcYKicKhluuRrT8oBj7f2/iT6SZeAsFTTS7OY6VjWGZaIVPRVlgdt
         TEGg==
X-Gm-Message-State: AFq9FYIEkj7AKzQN9W10PFr5BxIhtKkKkfuXexU76dgojN9qdP7MBI+Z
	F/w5G1xWGxT0eHaQdPAc4s42J8eU+mvxPAa2Qfdts2pRn4vuuJG84peF24HUdFGb5cWfRAyLPI7
	pGKaW
X-Gm-Gg: AYBFou0SSBqvZRpYO3he6uoEQH5tEW+Fk33oELzEjsrUUapIJDNNeMDjVA6wvPGHSWs
	sCKtIJZgGCh2jD5rZwz1PuMKvXUHyJ9T3tCBIQX62yPG8XruNylhNEtRAluuv5TpAah5XC4ZdfM
	9diei1wDGPk5Owz4WalcbQIr3vdWJRfKscKWBLz058mDTHfbdb4bNjcTt9r13dvA5btSDdSx9sN
	UqX6k3LxNN4so5P/v8d/JwlhNG0jG0ISTh/ZndLT+uA/scEEoPi75Ebwy6G+3ASXvvTH+O/zlL3
	thT/JTMEmCjz7WbDXlJAMfqF47aFJ1JwO9e3b6ifyK7+84QOkVMeZlACoh5IqIW+ZvjkI+L3hMo
	YYmXgpjiG2OM+7ufh9bMqTfoHuUwuHgqDYvVdtboF3Tfxgkl0/3KYWVG8TMLsix7CIjCh/HtpgT
	cxkKqhO+Ol7VgslPLxEIBJaegKWtLrY08Oq1KXWqxvvN+s1uspB/iLkS71gKgmP0sIMJ9qu0JP+
	wuYqKcBPZ0UIhDDFxs+ey5HWDaE38Ry1Bice/mAdSwWoHnKBb48YVne3MKTAof87P7JMQRBZi8c
	5nJ8MB3jeG7kWrqc/lFUthjru7LkIArcST7WFa295g==
X-Received: by 2002:ad4:5aaf:0:b0:917:9cd8:f26f with SMTP id 6a1803df08f44-91c12ed7e09mr12120496d6.25.1792550385953;
        Tue, 20 Oct 2026 19:39:45 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c10a45336sm13819426d6.3.2026.10.20.19.39.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 19:39:45 -0700 (PDT)
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
Subject: [PATCH v3 1/8] mm/page_alloc: detect zonelist rebuilds from memory hot-add
Date: Tue, 20 Oct 2026 22:39:33 -0400
Message-ID: <20261021023940.1940971-2-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261021023940.1940971-1-gourry@gourry.net>
References: <20261021023940.1940971-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 137E720003
X-Stat-Signature: fg14u3h9gef3516gaxqcprf441j8dndk
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792550386-385777
X-HE-Meta: U2FsdGVkX19i/swVWn89Dhv27nYNMSoSx6gEU+l8IXRO+Cm/+JWb/VW0CCuWvbNiptqE4CnD+YFPTBQBiXUKoBm8fIWKJtmFzXNVYVBVqKaWHblsx3dMVQCD/AJlh+B644AzRmczZ+OVaSlPBpcvMZFTan3LHP7KiS1Eh2I+Ty5Uig18P6bgQj/kRUpIA1A9mwI4bf86yfvqd/WawgsoNRDMIAFbUy5MEr+PoPEePSWMmebsIL9Q8XtOjXl1xe9fqbf9S+Coey6FWX4wdqt9hB5VWuqSM4I2FaoE5EkoL+v6JrGxSrv0kjWrUc5xT6eBHKPH3kW4R39FbQfoIsQCQ7BwOm2nMosc/gngaHvplHedVVM3//RJqgI6xj1BRjnTK6zIL9lyrkERoQUZByKSE38E1eES1u8NWVE4esR0uzVu1UbFbPloc5vMt1a/nH43mFc/5eE0cxbea0FsEcYS6PRoz8UdSGGdbLDTxNjLCYgv+z5t60SDdS3ZSuAf0kpWiMpZIVRfcCo5DpAKnX6pKIunY1/dfUFxdZpS2HWLIieVX9IY2BzIMjSjGLBio4osrPtNlNj6568/TzF+w1WiuzbH86ho4hDtUFOfWZz3xYjJ20hvrooOhNdVaxU09cbhe+uonXSOFfv0tWantnMwfsLHp2m1qaffwJcISw+OfgF+bi5cp4/HDSBGm0S18SjVIA+iOuz60kS9qKfR4ous5siu8jvKc3D15RL/1y6OL41lJTPiLE1DgFiZtm3w9pdAdwvmv9Wkecgh1hPqYdYPcE1k1Hoa8mCHD/Eo0W75LOFmTzaA1YEVSVPlkaZ80xM+0MS9O61m01nFxkXO/K31AnkYRrIvDbu9UXzXqS4mhUnvrxfV2cZa6ykJcDtspIt9cNAzvGnvaOLilJ6fXo6tO4OcEFYtkXmU8741TvTKKOnknzCau0/IShomXTVXKK0sRuaa7T/o03GgA+QMswN
 4pyTliSn
 +hQ5Sm1ntEmW7rEOqXNFtTuPUaZFYxKPXIpZWjU7/b58sIhWv3Jposi24O/pte5XjcSDNeFwK+OfFwNgkyUfofddrKrM1xDy3j0TJm+YF38Qud1iCfyhWe0ft83N5qjRLY6gu+hlqbRMtIqEVMcnIDv68uk16MMrWxMwKndhXpv+984B+le3NkRRtZ/Mb9VmJM3ZsGWws+oQWFQ+VRqoE5mp3NGRqIhec7Ajd4wlPuwoGgEuft4DfzayjRurasdJw3dUOP6zmeOiASrJcYHIDYrrZSSmhTU17O0HxBukyygbeJHu/V323238iq7UOhQP+8b/S9DEx46tu2lElYAPnoYV2y3ouXT7UpjnsSnkVHWfGSL9JHYaGUhhwYE5q3J06MJXeqnnMHBcEADtnaGzM43e+ewCutU/PDv1B+0rx/PJ6PW1Lic5iNJ2SB55axePQLX/g
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The zonelist_update_seq retry was limited to CONFIG_MEMORY_HOTREMOVE,
presumably because only hot-remove takes zones out of a zonelist.

However, build_zonerefs_node() rewrites the zonelists in place, so
onlining the first block of a zone shifts the entries that follow it
in every zonelist containing that zone.  This can cause a spurious
allocation failure for a __GFP_THISNODE caller.

For a node with only ZONE_NORMAL, onlining its first ZONE_MOVABLE block
rewrites the node's ZONELIST_NOFALLBACK list as:

  [NORMAL, NULL] -> [MOVABLE, NULL] -> [MOVABLE, NORMAL, NULL]

A concurrent GFP_KERNEL | __GFP_THISNODE allocation can observe the
intermediate list, skip ZONE_MOVABLE, and find no eligible zone. With
CONFIG_MEMORY_HOTREMOVE=n, check_retry_zonelist() returns 0 and the
allocation fails even though the node has free ZONE_NORMAL memory.

Gate the sequence checks on CONFIG_MEMORY_HOTPLUG, which covers every
configuration that rebuilds zonelists after boot.

Fixes: 3d36424b3b58 ("mm/page_alloc: fix race condition between build_all_zonelists and page allocation")
Cc: stable@vger.kernel.org
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/page_alloc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 2daf358269ae7..c7125f6693574 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4404,7 +4404,7 @@ static DEFINE_SEQLOCK(zonelist_update_seq);
 
 static unsigned int zonelist_iter_begin(void)
 {
-	if (IS_ENABLED(CONFIG_MEMORY_HOTREMOVE))
+	if (IS_ENABLED(CONFIG_MEMORY_HOTPLUG))
 		return read_seqbegin(&zonelist_update_seq);
 
 	return 0;
@@ -4412,7 +4412,7 @@ static unsigned int zonelist_iter_begin(void)
 
 static unsigned int check_retry_zonelist(unsigned int seq)
 {
-	if (IS_ENABLED(CONFIG_MEMORY_HOTREMOVE))
+	if (IS_ENABLED(CONFIG_MEMORY_HOTPLUG))
 		return read_seqretry(&zonelist_update_seq, seq);
 
 	return seq;
-- 
2.53.0-Meta


