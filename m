Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB303CA9EC5
	for <linux-mm@archiver.kernel.org>; Sun, 11 Oct 2026 01:49:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C6406B0088; Sat, 10 Oct 2026 21:49:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 577596B008A; Sat, 10 Oct 2026 21:49:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43F356B008C; Sat, 10 Oct 2026 21:49:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1BE516B0088
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 21:49:00 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7C0C5140657
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 01:48:59 +0000 (UTC)
X-FDA: 85308661998.15.F6C1F0B
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf20.hostedemail.com (Postfix) with ESMTP id BF0031C0008
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 01:48:57 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Cv/fJepS";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791683337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Uf/gLsH+7+jjl9qmUzOY7AC+tbZ2wzQWhphna1H8Ugs=;
	b=ZmkRDtLH2QcEV1qHfhWy7NjU6jnAVS8A7zSvw/FXoZJy56b4lBg8n4/Wf4IZi8DqnXOG+P
	Lo+OnlmhCPE/CIO+feR3ZWDWueoGKeWZquBSZzC/ySRsMpgk3TduuaUvfljtO0dv1sYyaZ
	YQtFWDbGLshFSERPrwa85m+Qt1jz1aQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Cv/fJepS";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791683337;
	b=ps3FsDY+tHu1ddeGK7ml+TLu8KcP7X43JO7pXHdtkzXzaiFPpsqvmQylGhF3/BoOe1+gRQ
	G6L8PxAaqwh10Wpcj1lVvGVk9YJQDyt7OcoiyALsQaug10h5PTfmFD783Z80ky7VjnfbKn
	/A+dOso3QR1LFuLlkDoAH+uyHTwIhbs=
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-3a7cfe8f761so1866640a91.1
        for <linux-mm@kvack.org>; Sat, 10 Oct 2026 18:48:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791683336; x=1792288136; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Uf/gLsH+7+jjl9qmUzOY7AC+tbZ2wzQWhphna1H8Ugs=;
        b=Cv/fJepSuNvMP5Rcjp94d7y+5k6RQgFWUfSD39kEerax5khaBzJDc/zwPyqFWlDSFY
         vmZ5Yc4d2RuY2H1uontEasnL+HBGuTwjgt4Qs6kALSoBFn+1aeSF8GvEvaE59qJrSRtK
         dQl7TXs3851h/CrWl1x3FKjza2+TFZrRUV+D/NZbI2WqLYrQYWkmR/VZKRrUswJxAYyE
         d4sHKIor5peuHEuePIuaqzvPdvBn3lr3klrSYKOySFkrJX3AENJBtAqdCL2tGp3bY7VR
         XeVBjt4X0llpidspzGPsEHQZtu3dSzb1NwgJoCpOMoFCkgYC10OQcGSdxR7nK3cBMYK4
         DpiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791683336; x=1792288136;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Uf/gLsH+7+jjl9qmUzOY7AC+tbZ2wzQWhphna1H8Ugs=;
        b=DvQcqd9nYragVqpAuj+Qm/o1Y+xOYM/UJTUT4ton1GVsHj1C4lkzL2PK90HZanogaU
         iy4rwhEIVMpVTlKJy95FYWh1c15I3yBXTbc4SbO3Z09q2piOJREpya18z+/bmSSOhbm9
         +xgeg0VW4JS27rhGYUqEIwHum46WHrha7kNsU/3k2QzX4XHOMbtaCzhYwlAr9dj9ynh5
         E+G+WgmNkg68OKN04selEcQMk9Bt3wcH9KNEmuQURzk/+qHad36yN8sd4qeVwgszlAz2
         kM229M/qq4W33klkAJmtQX3qpj7ecy/TnPgHjqOSjHz1r6Q10+jzbncwdI6Rsqb0sSJB
         +NEA==
X-Forwarded-Encrypted: i=1; AKwUvBzxfF8hDq1YG2nazHqL3yXuC32MtQ0DfNWLtBMTNGlliVXd15qYemhVvij0ybfi1kol9R778iMKPg==@kvack.org
X-Gm-Message-State: AFq9FYL8TIN4aAu1EpCRzo4B4tSy5P1a9qmAQ8J0zbJjpi3J3Ds1UVnk
	S0tQVeKK2k1mpXw0aXdHcEgScnurpYe7Ikdokl66LumaDBcqUY4+6mhQ
X-Gm-Gg: AYBFou26Ay4+TGuJuedzw6oH/JHfLuM/wUrnHMq2GDGIFdBlzljf+mLyqpW+thvu3aj
	TrlMvGBVqBrcsEjTUi+B2jt8g0SxJ9I0nUkJq0BvzEosCyoFhLTMQDhpzPscvMQ7Hta4af7DPR0
	QgLzW/2PJtKUiEiWGczfm5Xj2zBuuSXBeX9xP7bzyC8KKgxYOh9hn85b+BFQV1fw6jlHXy0nZqs
	SjNnD83nRue7+pAymCMtVQknXYloryIW5+bNNTrXXl7VnDmbXIBNU+WKeiGxQ5mumSj1CGsWucl
	XV4iWq0exWjjVH483APRqmgk5iZ9OeiXSwo+nl8/4SrfCz+zaUq3nkLLZxGmnF8Mqt8xgLSI1Hu
	eX8+jz58JOA5U4FFSK6VGaULuEC1C9D7t4TJTXW1H2pAZKs5vufKdPnjFzCmM3Z1KQ9KkxhciYv
	dHzvB/wlV1vz0hpFbMcvTLU3KxFu7o1hPem7+O9sKBkzKeOrHu14UeFgCO02Lu27Th1VngkzZob
	ZKw16Vh1Qd5avCW+xEUH4GpL+d7/9yq2M8=
X-Received: by 2002:a17:90b:384b:b0:3a0:295e:6e61 with SMTP id 98e67ed59e1d1-3ab3a953717mr3090333a91.12.1791683336427;
        Sat, 10 Oct 2026 18:48:56 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab39238608sm10729922a91.17.2026.10.10.18.48.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2026 18:48:55 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Harry Yoo <harry@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>
Cc: Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Hao Li <hao.li@linux.dev>,
	linux-mm@kvack.org,
	Roman Gushchin <roman.gushchin@linux.dev>
Subject: [PATCH v2] mm/slub: clamp slab_min_order to MAX_PAGE_ORDER
Date: Sun, 11 Oct 2026 10:48:26 +0900
Message-ID: <20261011014841.405327-1-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 75wt1w9zt6fm4wmupufkd4zmrrafwmq8
X-Rspam-User: 
X-Rspamd-Queue-Id: BF0031C0008
X-Rspamd-Server: rspam08
X-HE-Tag: 1791683337-487572
X-HE-Meta: U2FsdGVkX1+zFdxGjF8tVy/A9Pzgog4VHq5vVErkM+iMZd00TSWd9E3GEfKeFHHNT2aDi6kx9dG+VcMjUT88R67Eg+69VAitZAkOOphb+ZL9Tq0znsI498L4fEVwyq5RjhVuRQ8FGqP8dg0BKrvlLG/vWmNlt9FliWJTBXNFfSqBgQJ2bwGCRW+lFdWI/GSOTrJoigEPfJfwoLxWRQG9KLtQtb4KjrUm+daRDggmT2CJPAN1LuNSgQUvzCIH8W6nRks4MAvjKKt257iHvwdJziWrz4xkP61p2xJnBx9OJTLmkPS7mEYekwnDo7mo65QDzPUmt6CJTBRPPHV/G4RBOAbh9dgG8PImrGcjHHjKt2yzmgkItTjqsodx3ttRfWsCmJuYtnrEO4bWSO9g0i7A/XYVDSnhHGJ2882nKexjy7OfyALAQp6N+q7y0jM3VQI7payG0qghqPJuwEpKbM5SqO2xoVyLJQEbZDQE4r32q7+iqiaKcHL3kseQp8Ypo+k4AZaUxUYO9aOZQxdWUS0DRWJx7j6fTMoHi69sz2skB4bFWbBUh1drYwLyl91LILt1Cd28BfM7W4hhY7ssrVZMEn0IhIENimIJ6MiPE5N7Vq7IhrWmNOakTaqglohtVnP+hcUmaqXThRz2N7hwbtvmQR/3JaVhkWIuyqlM31iBHM4VZrV5v4CL+Haeni9GH1EiPH/+Mb33BPoe9xOv0HaOa0INVHmJo22krbJS5jN24zq18329QVDzNwy6mSqBqpr6qnjlZnwj2IBEzzxBhD9GT7vIZyYFK5y3yDaEHvXKZmSPYtrNM4iUzj8NBCSLdjcaEqm6tb3VNmjx1MZRBQDNJW1MwDmZIiX0K6RJ3emlGw4mb9cK5MKOgfNCv2D6BAomaCnygW0eg8TcO7RXfLJnAgpo+5Hiz3GgL4P1azQprcSHlADgKpQ50romIASdEsqKWvIvSUgHE7zhFCSlgwG
 8rBXgEUn
 ShBSuFzDtk+mjx9B3r/hvDVGA2j7LM34V+wjEK91HwsGdW0wo3m+HazzBy5E/9lecnsSz3oMAecPTy/fMZYkbCKtf438I/goHlI9dxvKOQAOCB6CCzW32Rnq/WLY/97uMrsFo3//bupOjzIAnrIMyv84pZ4geh3TOAJsvChoFhe2pmq56u/nCA1Ecl2oh4IhgMBvt3OQ91AqqaDMVkyygRc1hfyE+KiQaNPa9dQFrWrBSDWlf8GOgCnHrDvJAoJQkG2Q+FFSpkEB/zejHEQAN/UjZc7fCpE4WfTiP5L08iaeiTrK94FXpJfOSFhBh/EmfkMmoZbWFsOwJjatRBSadgcVI+NshCLVEfJouryfFs5mzDBzU4IX9ZsMHBsDfrFKGWiMAwI6ermA7b9n+ALmKs6co8+0JD0qQT+wegQEtvHMwpxhUx4lP+lEuVKzLXBoF6KJHAyEu+y3YT36dciXFSEsX6wcAFCvDLyeZ+D/MhwDNJiY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

setup_slub_max_order() clamps slab_max_order to MAX_PAGE_ORDER, but
setup_slub_min_order() has no such clamp.

The buddy allocator cannot allocate more than 2^MAX_PAGE_ORDER pages
at once, so slab_min_order above it makes no sense.

If slab_min_order is set above MAX_PAGE_ORDER, it can even panic at
boot or invoke undefined behavior in order_objects().

So clamp slab_min_order to MAX_PAGE_ORDER as well.

Fixes: 81819f0fc828 ("SLUB core")
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
Changes from v1 [1]
- Change fixes tag to 81819f0fc828 ("SLUB core")
- Remove stable tag

[1] https://lore.kernel.org/all/20261007163403.1643768-1-ekffu200098@gmail.com/#t
---
 mm/slub.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/slub.c b/mm/slub.c
index 1559cbace469..8400df7c222e 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -8354,6 +8354,8 @@ static int __init setup_slub_min_order(const char *str, const struct kernel_para
 	if (ret)
 		return ret;
 
+	slub_min_order = min_t(unsigned int, slub_min_order, MAX_PAGE_ORDER);
+
 	if (slub_min_order > slub_max_order)
 		slub_max_order = slub_min_order;
 

base-commit: d755441b7672c74f29d1241ffdd2b067ecab1ca0
-- 
2.43.0


