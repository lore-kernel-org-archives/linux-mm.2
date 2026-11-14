Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 612D8606A329
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 07:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=CDsB0zl+
Received: by kanga.kvack.org (Postfix)
	id C69E16B05D3; Sat, 14 Nov 2026 02:10:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5A096B05D4; Sat, 14 Nov 2026 02:10:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D3396B05D5; Sat, 14 Nov 2026 02:10:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 685B06B05D3
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 02:10:54 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4C6D5C0373
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 07:10:53 +0000 (UTC)
X-FDA: 85432852386.11.9320194
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8F0CE1C0005
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 07:10:51 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=CDsB0zl+;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.176 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794640251;
	b=OJxRWNaL0q+mkPhVl2kpKfvEgIz4VUHfPUTH264iJiVIokco+Z8Uqaos8EfVcfpATd7Wrz
	TwCQ7AQJ6GvkiLSlZCRp5HF1u3/Lm+7IEEJ7RkJ8gjMnP4hwxFB/5S+23C1cqI6aPsRxNm
	mwt/mLMczzMFFLPKDlANqeo/twqDd3s=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=CDsB0zl+;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.176 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794640251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+HAKXNFyWuVVus4jyGRYSZgEnC6sp/o+JpWnVYJ3k8U=;
	b=4xbMcwExTz6wB+mPrNveDthxumAFNHJ3Tiy2ldM0bYK1Pu5If5lFgXC09V6HapKbO3qbb9
	UaJGMn7euNjS/8WKbQN9kSTya4AnO+rHAgB+fNGsWSVfdoPnFdira8fKw4PIERX7EgfAnG
	CyWgtcfXqFEShvPVS+Q+B9hkJLL7Kd8=
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-55ade1de0b4so27475861cf.3
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 23:10:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794640251; x=1795245051; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+HAKXNFyWuVVus4jyGRYSZgEnC6sp/o+JpWnVYJ3k8U=;
        b=CDsB0zl+CgeJ2JmgJZ62oVSmiCgsB3QulYFvYcahHvkvkP5aXX1i+Nf/QXLSEzHw4F
         Y4bomdBbQxvDJFpgOvrgokE9QVqcVx+i3Z5xeqL2VrWUbmAQxuwX8DmVhhhkFDodLgmb
         6zm0w8HqOafitgjn9xWKGJ0Vi+cD7WpUDRGuP5xR7CKnUvI2ogK1l2f4O6stfLE+w7PE
         lP1FKaV2OPwfZxK5k+ZDuUJyQgqQ9w2by82K1vdVYjymlp0n/f9UxY8H86H6mnWYPRrP
         CmeWWfgVJ9MkCqOurNwyn0uwjI2Rw4eR1Wg2tG5gESl+XtSNgfLVfi9CSYJ55qS3UFz1
         zqWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794640251; x=1795245051;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+HAKXNFyWuVVus4jyGRYSZgEnC6sp/o+JpWnVYJ3k8U=;
        b=XGmKx04OIAViW3S8/lbcOQogPgLnxEaG+pjfr31HG1wtZNvvMk+2HrTjoqrDbLIdO9
         6E6n9pbqn9eDQmB90yOnumgXFnSaVSN7/e174C7Q550HZQT6FAiOuYGfZYQgDs1FpfcE
         Pdqed4YzUxCTSIoNALX7WS4Ueo0NvvWQXbUBdw8//1p3reS+NybS9uzGzPcZzok0anEK
         NPOZItZdlccuxAoBb+TSbuDspHC/99ioUh27fh1uvl33RSdpOxZAb600eaJVLBCKZKL4
         yd5Yr50cokKAMV1b9bzo/SzA5E6/3oTeiJb0cc2WHaR4f7G7ss7XJnluTvi5Tw1zNvTE
         cs5w==
X-Gm-Message-State: APuU4Z91+y4DQ/EXnd+M3Qg3UuGkP09IFqP1oXlhKIT1LCKuAbZUQkai
	sjMa/vIMYtbgbWKUHHGgGXx7qGJYSdsdQwl9nOqaGcqwFzKBkYs1HWP6FkRu9EeW95BMbpcidLM
	Wg/d0
X-Gm-Gg: AYBFou3exrA0B8h+VShM4gTHMekw7AX2TJcxMiNA4nnPR1Uk135mQ1e/nZxWNF26I7y
	0xRnAFZqDS9+JU109YBLJxhZNHFz0WnEZ07Dt5fi77F/yaEXW1aMN9hS2jEfKtusCVbzAeH0/BH
	bdqTaqEi581UnmsLc6NnBQSIbeo95c6IdzGnxTz1HZmhYT42MOxwoF4Oy8zTlwo3cZKJYTY8Nsn
	s/jAmjOKtFuqWKVF+v3tT4fpb+JRYeZ31bjer1LFbaYIjyde5j6dyrbnQCfHv9YxVugD0NYLSuy
	G+fa+6yfLpAC56hpbvJMDvasElrJiDSAa508tdv+ZbxCEQXR7Th7N3oPSRMXFFwi7hYekxJCdtV
	JI88MXjr7wl9iEoNcedbarL2MqqWYSwjv74yUnnTMdlGA+cNlUFEK3XbZa+XVikOnYWajkRCpML
	w4umOg6C2ccDFzV3Lgu6fWBJygdhRuaK/sMY+qbW+56CvhUB0FQ3GoJj8GrlLb+ZQDQb/XLY0NS
	GdEQeWckcMKq3qlI6AjI/yuP85jIMIYO64D9EMDHWc6XQppahzMRzgPQyihFCBhZ+cznMLGevkE
	l5lzVM8KoiX+kAgEe7cGrDp9jFMRvKZlmAyR4VwM9xxBVKuUpTQqb/Y8IUK9q6LcwhEKPzxH4PE
	4OgEYjad0Gwygz+U=
X-Received: by 2002:a05:622a:191b:b0:535:a5fc:3b58 with SMTP id d75a77b69052e-55ac8b9ba4dmr73074831cf.68.1794640250752;
        Fri, 13 Nov 2026 23:10:50 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f23db3a99sm37730986d6.40.2026.11.13.23.10.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 23:10:50 -0800 (PST)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	linux-doc@vger.kernel.org,
	driver-core@lists.linux.dev,
	linux-serial@vger.kernel.org,
	linux-pm@vger.kernel.org,
	damon@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	rdunlap@infradead.org,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	johan@kernel.org,
	jirislaby@kernel.org,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	pavel@kernel.org,
	lenb@kernel.org,
	hannes@cmpxchg.org,
	brendan.jackman@linux.dev,
	ziy@nvidia.com,
	sj@kernel.org,
	muchun.song@linux.dev,
	osalvador@suse.de,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	xu.xin@linux.dev,
	chengming.zhou@linux.dev,
	gourry@gourry.net,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	matthew.brost@intel.com,
	byungchul@sk.com,
	apopple@nvidia.com,
	rientjes@google.com
Subject: [PATCH 22/22] nodemask: remove the now-unused first_memory_node/next_memory_node
Date: Sat, 14 Nov 2026 02:09:59 -0500
Message-ID: <20261114070959.3490008-23-gourry@gourry.net>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261114070959.3490008-1-gourry@gourry.net>
References: <20261114070959.3490008-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8F0CE1C0005
X-Stat-Signature: g8d6urc948cszfaqz69551otzrazan6m
X-Rspam-User: 
X-HE-Tag: 1794640251-568419
X-HE-Meta: U2FsdGVkX1+AiXX2KRk2NJl2+ZbH8SMslvbbq3pxtbgOQ0oYPY6eT6pG0kgQG94J4F3MtuChruFk72Rs+HRJE/u9800822TUd5hq8uyHGUxA5oO9OMVQrcFOS8zCNA4gqwAZgIu9bripO3svZKOQg9hNNBfgLw85nSX+bk4lvCHtA1J7bAwPvkHxu9L5kfqg42zh41Dycta19njKCKVmJv1HF0iKewfEoPX1N1MqArbNpA4xSYi29gllHcEwXYAByBnQI4F0zFLUK3ldIP11RiovwE96dJKb3mAbxgqgVxYTRWK8imDwbX+ONbObW+Ze/x9u7m9iyntAkGH7fry83pj7egF4O+eHOT2cDW/sTv9Jf7vPzdtj4sOUqXnUSe/EWAMF9SI8plxnw7V9C1ufkcy+Kdl1jZNg1Zjdb83fHcrVLIzUPRW/qYhrU3zP98q/wsGEsb4n1EVdMAAR+RIJ7L7n1yeb08Z8UfGYG7lDIexMDrk9Ogadhsi/KOF/cxzzCtCzdimrUAp8Rjj8zxHbeaLS7LheqknjBiBqX6LquGsWzvSVENrnyUCmTPoFCKlUMXNGkNo1AdB8JKQVwi7wmteutyXD4Z7ti9PAE8S2LsbGg/miwoaXUsMLjNarwphjfig/Y2UOpY76NYDRKyD6//2F6gTjcfTLkzHF9DSFBusov+BDoPub7Meb3fVPu643FrNQLFnFucU/iBC4hRmJ5qFrz6ttTQ9YOf8ikUXbBbIa5w9berHTJRa3z5uZgf7QcVIvdOeYYX4voMNn9BiOkU5i3RCACdqxhn8icVTLDbvfxC00kq7j2mVf9K4+s6yyfzxOAQoCqelKysgVy9/CqyIZiqOa01yZXuhv+0vzyOhmWyNbRVRh+haCSEo8TSU/8thMBeSZ0z9aiH7cAJeOTGSi3KQFU8MW86TfeMXw1qb3MbQrOdvDP3bcWRMKlWu5e5/6aVqiorBSsHB+2vZ
 7waXF3KQ
 5QO2w7R0EE1KSB4aIAMzKV7ikB+gDBxOb40HDyrJvkQxFarohArALquomA+0JG0siCTJK32vQHxv9oYCMZ1RCaaz2HxoDxsFZHA9DXpsh0S2MFD+bLX5CjIXPKfJT+AF9K7FAzKhJIFI4lfRYY2fikU4KvthHLxjWu08cEsxw75A/k/Mbi/itRmdzfkQ0QhteZnDLKcKyB0cP0IWjBpNCGYaE0E09FZ9zHTITWDnd7rS1NEiuilLqcgMD61yAF6VPEU1ZMGwQ1SyoBMDFtwZJNPCrtp/iUti8ZCb13umjeSL3QibLsiqPHezYr0tzkbfrQTHJNTRFGGM2ICoBcIYFwrU1gxSwp1fpAxHCiPpeNHFf1/bA9rxQX0EJ/OkVfYhhAEeVjzTQUY9gxJ9P+5f7pY0x/DHxDu/QYE6FMOqu0Hy+SVo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Both helpers hard-code N_MEMORY, which says only that memory exists.

Every caller now names the state it means, leaving no users of either
helper. Remove them so new code has to pick a node state explicitly
rather than silently getting N_MEMORY.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 include/linux/nodemask.h | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/include/linux/nodemask.h b/include/linux/nodemask.h
index 7ace610bdd654..eea0ff7601303 100644
--- a/include/linux/nodemask.h
+++ b/include/linux/nodemask.h
@@ -457,15 +457,10 @@ static __always_inline unsigned int next_node_state(int nid, enum node_states st
 }
 
 #define first_online_node	first_node_state(N_ONLINE)
-#define first_memory_node	first_node_state(N_MEMORY)
 static __always_inline unsigned int next_online_node(int nid)
 {
 	return next_node_state(nid, N_ONLINE);
 }
-static __always_inline unsigned int next_memory_node(int nid)
-{
-	return next_node_state(nid, N_MEMORY);
-}
 
 static __always_inline void node_set_online(int nid)
 {
@@ -509,9 +504,7 @@ static __always_inline unsigned int next_node_state(int nid, enum node_states st
 }
 
 #define first_online_node	0
-#define first_memory_node	0
 #define next_online_node(nid)	(MAX_NUMNODES)
-#define next_memory_node(nid)	(MAX_NUMNODES)
 
 #define node_set_online(node)	   node_set_state((node), N_ONLINE)
 #define node_set_offline(node)	   node_clear_state((node), N_ONLINE)
-- 
2.53.1-Meta


