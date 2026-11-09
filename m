Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8AE8606B58A
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 18:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lfsy3Ze4
Received: by kanga.kvack.org (Postfix)
	id E146B6B05E9; Mon,  9 Nov 2026 13:32:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEC256B05EA; Mon,  9 Nov 2026 13:32:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D01A16B05EB; Mon,  9 Nov 2026 13:32:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AE34E6B05E9
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 13:32:14 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 39E2A1C415F
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 18:32:14 +0000 (UTC)
X-FDA: 85416425388.19.B73C8C7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 4D0AA2000C
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 18:32:12 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lfsy3Ze4;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794249132;
	b=GK5iOqf2bRIgeYqeaOYzJ/faCPUmDKl12bU+FislU1HKzrfqU9BZw5Lb70dESKPgs5GfZq
	h8cDOKC3wV3CUYmNP5We77LQ/8WlOnaM8+Gx245P9F6/E/QD+7/T081IIS0Qf2q6jT0gwx
	cmmsU+thcnxOq775GeJ/QPok0GHFjMc=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lfsy3Ze4;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794249132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h/Bd473+Uax1ERBjRspXIJTjnfLx1UaFniL2HymVmOY=;
	b=TqeO8vZyKudfK4PJmMydpDiI9GmSb5EoYuEHKu2DQWRLUVY0cgPhqpSPcwGYYoZTvDO8P6
	RPT9Y6eWhwXjdM1K/WFX3Ce66GXkepe+I0d8Eq4+rLnGiLf4Pcg+9z3rn65F7x4c7CTSOA
	y7gXOc2jWVmZDHbWYmhGgT+ABFLc5hM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9856E45980;
	Mon,  9 Nov 2026 18:32:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 039A81F008A1;
	Mon,  9 Nov 2026 18:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794249131;
	bh=h/Bd473+Uax1ERBjRspXIJTjnfLx1UaFniL2HymVmOY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=lfsy3Ze4pC4fQ8Wju5XXWmBxzswRHlIyyZTxmTosI0btdYkO5uwTmDxGrDBiKgkNc
	 m0HM+iuLsIzOA7K06pAX/SSKIPGqUPhWmZEStxE8e3fnArtQNJAz3zmx2tDHbt5Pv4
	 5JaBlOhpsEXkkhk1nljU703ZLIsgbEiXPhKspk6NRySRH0CVzd1MO1PGGgSqcajd6h
	 Mm/o1hsP9RwCNSu0P9adK4qBtsoTHct1oxVfxrxBuHwhmixPZXXZeExhdkpoZpNiyB
	 inxb5/TzV25jAKbp1ug13oQkov+FcZWVSIubeDtyzYnbvvf8/Y4XB7+Zd75la76Zy1
	 sugxpdzZjYqKA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Mon, 09 Nov 2026 19:31:54 +0100
Subject: [PATCH 2/2] MAINTAINERS: remove myself from MEMORY MANAGEMENT -
 RECLAIM
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261109-maintainers_mglru-v1-2-c25e6de60bcc@kernel.org>
References: <20261109-maintainers_mglru-v1-0-c25e6de60bcc@kernel.org>
In-Reply-To: <20261109-maintainers_mglru-v1-0-c25e6de60bcc@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 Lance Yang <lance.yang@linux.dev>, Ridong Chen <ridong.chen@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=832; i=david@kernel.org;
 h=from:subject:message-id; bh=oEU8IfcwSlE8hn8tOxT+a/rYJs7VL5OhvNpKJq1C9ZE=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLI+Cc725Lr5Xz84ZM6iFU9VFxU0m6gtYp2cE3KVZdvR+
 r8BG2oOdZSyMIhxMMiKKbIEBd83ePlyXW21Gx8zzBxWJpAhDFycAjCR2MMM/wuDDi4sfzBzURjn
 co/qvnC3uwLHNCS1T3/x9b56SDL09jKGfypeTQ0XOouXizF/ET/seiZjt1RHbuVCIc7j+hW5C2d
 1sAAA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4D0AA2000C
X-Stat-Signature: s3n74o3h44gs55aaio5q4q7qak1dh47w
X-Rspam-User: 
X-HE-Tag: 1794249132-431002
X-HE-Meta: U2FsdGVkX18maHH3VsNgBVFCWIqvHjOeGTkMdZAzt8v5RZ9mg/D6pPB+VVDQafSiRIyoLFM6JaX9DY4KgnNaDLIXSG8fXnjA8VRa9gRK8aTMbS4Sxz4+g8NR7WdDhBoUVg3O5oimwpWWUMmtrbT/fk6jWngdLeSEvAb+9FvCjjOUCfLEdLs3DOCoOcay+EgQtCMkn2ASyzQghn34WP/WgmaBzwSapsgC1s7Lm3hH0XKqIQ49GEsHQpvplGoAtmslZs5O5erK/rEy0VKnenaPqLPH71Idrfy5YgJjQOLIzYhLzeiPEDDQFjpiZh8Bn6rJmGlHDTsci8U723lOOA1Bc3NVud1HEaruPdSGcQ10PDRPln8+OH+iq/BuxTlkhCvb6G2bAiXMWHKB/yoODYHHstxTE57vgRjw80O0cl8BzOT8mxnWhGwoMNhI892HH2PgTM1DT6r2WEiXAvxkkUikL+BR/sflbQRy3FoSXLwmF9UVVEtpV4q+MAx7VZvAgFtzg5oxBq6+UEWivzlTkgSGbeGjouJ+bcakDwhTqxMiSntLzLlziVS5iCczk//Wv+bajOQcBBaUnmZz5S7Hm4nhF2vqlE3I5JlMQVQ+aQ6FVfzdkIfXNYxglFqfEvuDtrYZXpHjp/QZIFFLwg0hfBEYv6DViERv2dwRGiBRgHIPxR4acxYGZEhr053TTW1TGu7Pbv+IKXJKp9+DabKrSfy3+fB3NPBkm5Y+x2/PIwCWdMcXfyKt5f3MVm0CDzMsrx+el2pxVOaxiOK70YEQSrnej16xNTJl4d+IGIO2uW0Fr+dnjf2baDdQcrpB+zPGl75SnXij8vHPAjuNAPa5YUfS0/Cic0Om2SfYtPlKppBE8ruvLEUGkFc7ofdWWw1Jb+bpt/kQk7dlQR9Gk13fhAVrux2p7rD5ZJtxW6sOf/69V2HOyHj49YPGIzVtpHIUB82zrjBG3KqfzNm960iFYF9
 SxZ3xS+r
 4MvKFTLGKUegEHDn2LtKtwYZJcvk75PaX39JqoEUhRjnllEGa8PHlheh37EjqXZmFfNUItNx7e9Khh3eE3NDjxCal8+uRsHjHcH3BDq80WN/HErVQHGeWbCAqqMzMi4kQ2Cy64kJXNRLVDfGGc6Zf/53l7r6yoO+gkaqZEk1mydHcLAB9EIjfskWZEYYJqK7tDubO0w9CBYGpsZIVyeJsp7TKqo4sAfHIWlIjMuJKqIcM4BMj52eitjXF7VgxH5Y+WYReZWUUA9ppbvqD1etKEqdeMdk9wKKbrLPgrD1itlgu+i9P90rKUK/qRcC0aJuuvKlsjgXujNPPW2GT95SmeJPeUr7/oIJtyDb6P/lhljvRh+U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

I don't really get to look at most reclaim related stuff. For things
that are actually relevant for me, I'm sure people will CC me.

So remove myself from the MEMORY MANAGEMENT - RECLAIM section for now
to have a bit less noise in my inbox.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index e7ac319a570c..7dc8548236b9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17808,7 +17808,6 @@ F:	tools/mm/page_owner_sort.c
 MEMORY MANAGEMENT - RECLAIM
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Johannes Weiner <hannes@cmpxchg.org>
-R:	David Hildenbrand <david@kernel.org>
 R:	Michal Hocko <mhocko@kernel.org>
 R:	Qi Zheng <qi.zheng@linux.dev>
 R:	Shakeel Butt <shakeel.butt@linux.dev>

-- 
2.43.0


