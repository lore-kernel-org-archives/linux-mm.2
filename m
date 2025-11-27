Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D223D11183
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 09:25:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A556E6B0006; Thu, 27 Nov 2025 04:25:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2CB66B0027; Thu, 27 Nov 2025 04:25:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96A056B000C; Thu, 27 Nov 2025 04:25:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7C01E6B0027
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 04:25:56 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 322A1BC044
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 09:25:56 +0000 (UTC)
X-FDA: 84155855112.05.691FD96
Received: from sg-1-104.ptr.blmpb.com (sg-1-104.ptr.blmpb.com [118.26.132.104])
	by imf14.hostedemail.com (Postfix) with ESMTP id A056E100008
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 09:25:53 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=e53yThEc;
	spf=pass (imf14.hostedemail.com: domain of guojinhui.liam@bytedance.com designates 118.26.132.104 as permitted sender) smtp.mailfrom=guojinhui.liam@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764235554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=8Nou/MqkuvKxL9ESIFJy8/4e8vQNge3e0G+s7mmZjGY=;
	b=q+dvlb+g09odAVQ6RlXlekeXWqKZLLjCmaNoW9aMpny2ZXUiKYIbxFuTG6bgOlWTLi/8Oq
	kIjNYl2N9VAaU1zmNZFADBTPQn2Z8IJi104fKdxiFwBwsC1YUIsawRVAia76L9XtjKc1WD
	9sr0moHR9QEiFgkk0lze1kwXxHOOe0U=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=e53yThEc;
	spf=pass (imf14.hostedemail.com: domain of guojinhui.liam@bytedance.com designates 118.26.132.104 as permitted sender) smtp.mailfrom=guojinhui.liam@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764235554; a=rsa-sha256;
	cv=none;
	b=1XH0ih+PSzwZzJDOTF2D50OB5SrtES2e7rLsFj3sOD2lCOHBCp+NO3Tc/LqXOz/PQ0RVFx
	xkyhrzeqSEStaAKkiJQmR3WZvtCD+2IHS7O3osYPF+Az0V87O5zRJhZg1tpqO40va7zau5
	MpQtJaQ77Em22BOipv+TAxrRTQ5PGJQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1764235546; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=8Nou/MqkuvKxL9ESIFJy8/4e8vQNge3e0G+s7mmZjGY=;
 b=e53yThEcEwXNnvkfP3SJRFJKgMoyMC21vqL9r/5ZgFAkwPS6whfU8B0+sixzCBgxeRXrSv
 SL3NgfE5fnPCayUXqlK7gXBtVeobOqyFtvO+hkI2s9F68kBo6edvprZNhZhDFEQ6ybcm4m
 QZ8w0VPaMsPRyuet8T376/pwibJVWMkNzfeMecP1dym0xvwUWWuQ0vSZ8IbqI+F3MI+Oen
 vrGGbztzdPnIVszDMa4wydGS7IzKp1NIcWHzdt2yke2K4byU/DpKphXwtU88foCEd/8BrT
 0dcrbSbv0tRoT+fkLpt0Q9QIzUPgUknLgBTOIaOxOJwYYzr/9ZECM58v8yscBQ==
To: <akpm@linux-foundation.org>, <david@kernel.org>, 
	<lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, 
	<vbabka@suse.cz>, <rppt@kernel.org>, <surenb@google.com>, 
	<mhocko@suse.com>, <fvdl@google.com>
From: "Jinhui Guo" <guojinhui.liam@bytedance.com>
X-Original-From: Jinhui Guo <guojinhui.liam@bytedance.com>
X-Mailer: git-send-email 2.17.1
Mime-Version: 1.0
X-Lms-Return-Path: <lba+269281918+27e7d5+kvack.org+guojinhui.liam@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: <guojinhui.liam@bytedance.com>, <linux-mm@kvack.org>, 
	<linux-kernel@vger.kernel.org>
Subject: [PATCH] mm/sparse: Fix sparse_vmemmap_init_nid_early definition without CONFIG_SPARSEMEM
Date: Thu, 27 Nov 2025 17:25:12 +0800
Message-Id: <20251127092512.278-1-guojinhui.liam@bytedance.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A056E100008
X-Stat-Signature: ggmetskx53hp8kesctjdmy1q8p9wtsmi
X-Rspam-User: 
X-HE-Tag: 1764235553-820671
X-HE-Meta: U2FsdGVkX1+wPtCbN9CeJfI1yGfOCla+esy6GcfyLP2LIN3x4oX5D++73RSNxMmCAHwzqdTNElqmsWlUmeiWP/cy9+iEkyY0shIu8+FOGkJ34TF/bLblVSB87Q+O09VOg8sWQojyLvB3vKW+5rfFfLCdeIrmR+VJSXjmTELCB6nOZhfYCi8T0AjQFON1SF2wOOGQUcwJLMCaHfymXYmmYCv07BHykrFaHUrZduw9zCjXkfkkWG++4y91JkDKnN94SFKsodxXoArBbk6JbL4XVzn+JUpTV2JuWw61nRoItvrX1NMuqAk5Y7pLTYkwXTpw3f6p4hCG7IEjuEIOUbmibUOPEDb3nLvJWlNf+Obv2sxn4EQKfXSdFvxFYyL012Q9xAp/R7rM3iXd4TlUQNrAoLgqnZ/PIWI66342sW+ClpCRDCjluRTEhfvZO10w/vL30n+1stiapACn7ibAEdrgV0ud+GqJk8bd+/+ZQZ4UO0SyieyccquX+0bdki4+GK3DOfdW4Cia4w9ve5pKa2McjYTeOCXvEQPowQZVvrOJ1/u3FsBCsq0pkpWl3UGI6615QM/eHUvie9lJ+ehvVhBvIVrhRP4bR6ToU3HBdbWxxH4Xr2vHR1PvUXU7eNkgS4crTFzaeUfdb1Yo5UAmoP1ZXYZkQIYQSYFUp9apSMaKM327OK1nibfFPGlT7loiifO5yIiEqQ088pTBJJIgHZNtfH4W8qCfK/nFO9b89uOpQO9DiwJTR4j3l+JS1bJUsTYUWy3YybDLV+/E7LcSRJbImOBzcb2OqvAxSvjmzLwlUZZvy+3mgPVZJg2AYGIAqpkHvRfv4Nfcbp8N3NsBenS/VZQF87K4jFNhKK3dU25vseVkiKEi2NqS35Q/JUIcEpRfgzrzfDsFmKiF0RqroIEIY5hzlDiK8bCY/mhfBy9jTTwK3Jktmom1r+pDFlKx3rV+/BZ4IwPossIAi2hMJa3
 VM0V6s8+
 BgIvb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When CONFIG_SPARSEMEM is disabled, the macro
sparse_vmemmap_init_nid_early(_nid, _use) passes
two arguments, while the actual function accepts
only nid. Drop the extra argument _use.

Fixes: d65917c42373 ("mm/sparse: allow for alternate vmemmap section init at boot")
Signed-off-by: Jinhui Guo <guojinhui.liam@bytedance.com>
---
 include/linux/mmzone.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 7fb7331c5725..f6dd181a4821 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -2293,7 +2293,7 @@ void sparse_init(void);
 #else
 #define sparse_init()	do {} while (0)
 #define sparse_index_init(_sec, _nid)  do {} while (0)
-#define sparse_vmemmap_init_nid_early(_nid, _use) do {} while (0)
+#define sparse_vmemmap_init_nid_early(_nid) do {} while (0)
 #define sparse_vmemmap_init_nid_late(_nid) do {} while (0)
 #define pfn_in_present_section pfn_valid
 #define subsection_map_init(_pfn, _nr_pages) do {} while (0)
-- 
2.20.1

