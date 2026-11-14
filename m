Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB40B606A327
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 07:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=HhGmDO5q
Received: by kanga.kvack.org (Postfix)
	id C1E716B05D1; Sat, 14 Nov 2026 02:10:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCF286B05D2; Sat, 14 Nov 2026 02:10:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A712D6B05D3; Sat, 14 Nov 2026 02:10:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 818956B05D1
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 02:10:52 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 63537A026C
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 07:10:51 +0000 (UTC)
X-FDA: 85432852302.27.7E8C13B
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	by imf27.hostedemail.com (Postfix) with ESMTP id A469C40006
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 07:10:49 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=HhGmDO5q;
	spf=pass (imf27.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.47 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794640249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SG9odMntLujN1bfv7U8SkJUk66Dld0t8e7Q+mOyqXTQ=;
	b=kS6hdiw8EGoTNK9xP98ZeyA5TtV/L2H/NjYMcfW/xWeRVvKxgEXQWstMty2mea0MVhiDSq
	rvODvx4kysH6oMkGoQtvmdhBiohqo5fr+xIuc7dS5wSPEx5EhXxntjqUOysXSEhunmKfx7
	mMS7oibdvxgX+5gG5cCkmYX0C5eLrws=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794640249;
	b=6rqD566v0jo1tVR6neh4i0gsCbYu/Icrowa4/vT9mEGFo2zwyGWjlz5ejjDU27rgygcSIB
	Hy7E532nCLsNBa7NYU6VUvCHuCe8aM90zA+78wXfTLP1qjaM5mVUPbyzhGwAGj/EoUy6Nv
	D0+XQnpFFlhgJ0jJnNQMdzikqi1DVCI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=HhGmDO5q;
	spf=pass (imf27.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.47 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-91ea2e29d90so38114976d6.1
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 23:10:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794640249; x=1795245049; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SG9odMntLujN1bfv7U8SkJUk66Dld0t8e7Q+mOyqXTQ=;
        b=HhGmDO5qPSsZxUTlNsbckzbN5hpCTLpNFVLJMd6VMqSK9DSncsa6FJ0dARRKHbFB/A
         y+lq6u9LGAAw5/nBrNW/62zFrMatJ94EvEiPYT/q41FIdsOAqWYBsHW4xTYy76CIv/ad
         G7PzpSgFMKeP/XNaT2K5za/xKi3pySxgghUXPkq78wjoLisSmVy+F6/O2YJEES2uZCBI
         9Wjgm2xKI+akNqp12zwgLquf9lkc2ebR0WuhNWbOF3ym+sFuSCyaHWVKMGhklJ3BASgN
         V6riNpwYCWHPkCVIkozPmjfoQt/V5y9Hjh2ndCMgxPrmbJjWx7cPtpRo9l2CGPix1ILY
         +vmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794640249; x=1795245049;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=SG9odMntLujN1bfv7U8SkJUk66Dld0t8e7Q+mOyqXTQ=;
        b=XnVnN2ARg3aO3ERIxySgcLAGZApdm1q0CDG3Iicf6o2sUmu3D17bB0eSBJEso0dP1S
         YcdMtsyV0TnJITyy+Ce5Yo2RiRaqvyw2Wk77WYir0KGRH35BajvVAd31aX3L9Ge1P7PG
         YecDLgv6c4jgZ1EkezAnouNIHk7ltDhcn+eNp6zmLFKcZTG7PDhj2c2uYfAOHonKdxRq
         aFRVkF8m1eHE+bdiSsqmp6oDKPUs5BbZDP1+T2PxOQpTBuBv6mCrMMqB01fXIMNYVAbK
         qTiHMvlAOCXyd5mAY+AJP4vVUibQKGOHLDvArJM/gL8kmDb8TMOcgIUU+L/eth4pHze8
         F2VQ==
X-Gm-Message-State: APuU4Z8ZjXAR1JZEHHfmtmqBhU4OwRBlpNVUan3ge/YIBDqiH9m4ea98
	aEtUFPJefjgkMboh3BEz9Gx5AeIFR8fJ9ePhr14Fs4iYudeRdlYjPNSQ05RftNRGkpOgecPoiFU
	s2bwB
X-Gm-Gg: AYBFou3jFG+HAHBm+4UaZiAx8MwcAMVM3fR45m+qvzP/7QUy347Q8eo0fH9ZDfRPlsQ
	IUOqHN3V0HZnqtuqyD8Ans9Jm3/2UfjUcZnDMYD2xquT+lH8yjBEKJ/eTt5WS/QZw9okFyFGWIh
	Pgf23nsmpcZrs+PgVepS1Lu4JXS7jh0kY08CNQSwefWH5ycOqhOPv6OH0sRWeuBCJrCTZDZpjRX
	aumedOucdSwjQvk8g3YQ2cCbgqIJxl/U+L0IQBCIiAx4fZM5vZ7wIpw2h5KV9ANZGKaazVOReu7
	Br5tKx3ykYSY7ae9ocgifVa1bMzVTMozAp6lxorOEncRWqIDdp7fVnsy8hEBvXW1+MOgUWKs5yq
	p4X3gxzWip7A65ZWqtMD+86bQTyZLOQ2tx3tFH/zIEZH3NkGqbKCODzP/Hy1UFd9jEbd7hYa/Eu
	/gncbCZAZJnoYTadY99t0PSd8BjxH3ptPe4CO8KtGQDPb/euDr1W27TaeP3ix1r6s08wte8VnmF
	erOy3MGp8xt1Mo0ssdvTXLJu5TrQIJVEPegiHw3AnZ+fusoTIoeSBRnmAp5IkGc6ZwnkZtNP+Yu
	WA/ok7ohK3f9CvlfSFK4qM2DDaLvGPw+nyyfxWaMAyT38fkYv+h08IqK4FzJSUT1ETkjuMIRV9z
	tvWVtTZMbSjh3ObIp
X-Received: by 2002:ad4:574d:0:b0:91c:913:462c with SMTP id 6a1803df08f44-91f23f211e7mr73834306d6.0.1794640248788;
        Fri, 13 Nov 2026 23:10:48 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f23db3a99sm37730986d6.40.2026.11.13.23.10.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 23:10:48 -0800 (PST)
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
Subject: [PATCH 21/22] mm/khugepaged: base the recommended min_free_kbytes on common memory
Date: Sat, 14 Nov 2026 02:09:58 -0500
Message-ID: <20261114070959.3490008-22-gourry@gourry.net>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261114070959.3490008-1-gourry@gourry.net>
References: <20261114070959.3490008-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: kdadtra9sm9r4ka48u4bmxxtft1rxad9
X-Rspamd-Queue-Id: A469C40006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794640249-422295
X-HE-Meta: U2FsdGVkX19as92Ke/yKrIOszRTFaiOMb8mpscDN5/HontEIbHd7qLJnjBWAiujM9gmHc49SU9zsi950fz0ux3VtLEwsjDMTEJYaaPMyEkhp1XCYitlnET6UbDj2oHNvWozXjMC82gSKb2mXIZ8ZBsDeNdXF/fNuHQNuvYV1S7MWIgrd/fO6SkNzvlra1zuv1CypI/AZG5xKXW1+0ECfqLQP970sikkrSB0AL+cyxbf/ir8KDDJZJ2E23/vX+gu5jCGKoaF/ub6BMNKQy7VHOqkg0psMBPw5AQbDHtbBtRILkgnY6fF3EWCVi6C684IjGt8QY4rg2viyu/l20zdUHc+qK2Ea7HpAImcnhwce/3zdu5Q2gqrs2EGl2i0WGwpErZ6HmYvCxy0Vk/4Fu7YEeK1Kmb3vCly2O9TDihET9WJKThYP4w9hBD1ioATOsgCUTrS/yk9RhHVbkdJaVBrysVaLE7E4+aceMLqQUZtYPCsSv3upTYRXJspbIpNsbEau1Gsmt8zyRo6p5fmk7XVlUOZ50CTnLR22Gh6kLrKM1MOSVBnv/DFtB2LjrfksHwUT8pbMzvkz0MkD3LYd0FiKh+ctMB9X6RRxrYkR4FoE1/ju/gitdR+Dt5Mnk9Hc5hfLGvtYOJktoq1cWKjYMEtOqP6ctEwe3Gk20fBwnY0r0F7E2nIcMMRNM6u6cv/73DtsDuw2cGDjC3VRmUg+uTrdukiBNui4DSZNgc/wTysZk5aYEqKVmSZtvJBn4zaLI0D88AGMlJBOUKJ+a2B26KtqO2oMUtu/0ENZV0UuRXTzTzLjK37GOu0A1m8yp2/2kq7R2jW3PuvnXGwmz5glkxc+FuTlGhkwB6PAUVyAKvPt2Ob8i4dUtFbBtni/gyT+4cH/GsFHMPa4TpYgqvjrvb5GTJP5KZjk0775Fytjrbf9P3JQO+OBLH7yx8sWT6+fBl9OcIhLUFLe/N2PwYD1yf8
 bz5OAotD
 QPpVlRid51nVanXjHkHWk1zDzSZqAa8JELdleqgtEIx9t6JtzpjqmT7iKmZWS3oCOi0ogw4n+hA2UQ6wkg5/sB9c9EdCvkrRYJbR7XVb+6l+b1nE8NBgXxKI5xlP+YMsP0RdoVmy0woUnBSuJqZEgUiPrQmfdO+Iok7ex2bc3yAtDCXzbWh8+YWlik5/36EvPdZksk7MSGNQcRaiQZc6ZRcvpI8fPYhQ7l10XUj0a0PM+pMxwXvlED8Yq+ts92aXefR7x1eJ9dFO82SyU2K3zzXb8+Oe3shAjBhdHfSvBmD7Is7+KufkeBm9wxr18y89ab4qeH4fVSIQnHuMfOmFLOy4nQoEb/q2GjnFXCwsx9k8Agip7xKP3cQaMnIt8JUa0KTOhDzMSPX99bDYRcYIC6GWaImx3ZjMIPeK1WZ43roPpFeW4VdJtgfWpHBYJeC7t1fYK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

set_recommended_min_free_kbytes() reserves two pageblocks per populated
zone to help THP allocations avoid fragmentation. The reserve serves
ordinary allocations, which use only common memory, so count only the
zones on N_MEMORY_COMMON nodes.

Every node with memory is common, so the recommendation is unchanged.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/khugepaged.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index b4bd29f25c145..fac314b89a234 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -3149,7 +3149,7 @@ void set_recommended_min_free_kbytes(void)
 		goto update_wmarks;
 	}
 
-	for_each_populated_zone(zone) {
+	for_each_populated_zone_state(zone, N_MEMORY_COMMON) {
 		/*
 		 * We don't need to worry about fragmentation of
 		 * ZONE_MOVABLE since it only has movable pages.
-- 
2.53.1-Meta


