Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 319B3C87FD3
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 21:07:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B018C6B0088; Thu, 31 Jul 2025 17:07:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB11D6B0089; Thu, 31 Jul 2025 17:07:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C64B6B008A; Thu, 31 Jul 2025 17:07:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 830CA6B0088
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 17:07:42 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 34F7180F3E
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 21:07:42 +0000 (UTC)
X-FDA: 83725796364.13.C4E8FD4
Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com [209.85.219.180])
	by imf27.hostedemail.com (Postfix) with ESMTP id 729A140013
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 21:07:40 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MFDAVKdY;
	spf=pass (imf27.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.219.180 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753996060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Ys/9FFyQ9hB8hcspnWH+yLefcO8HOj7bglv0EmfT7S0=;
	b=StOFd/NZF8G+FdsygJYgHv4elPZbgUTp2UhLdz2H633uX497YzdDDD+LvpdNuIAk/P8K52
	ctO4b1pcrEkYeQnLFqV1lglHijwF/dBOJjUjKl9x+vTHzjyq9J3FqEKDf7m0Wi3YjEC2UG
	bIYLI22UMaKk3pMAwxXSzGUbWYnfX2M=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MFDAVKdY;
	spf=pass (imf27.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.219.180 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753996060; a=rsa-sha256;
	cv=none;
	b=K4RA8I0FfQtuMONxiWMG1VmN3j9QXnDk7cBv79vPY3FG8aC8YoHki22GOFIk5yQ45GjiFq
	2mUcm7WPfkIudeaiZ+2gE1sJ/3dfbhV7oWsJpYRE9WadOrgLWDhdzs2jLI4a5gsx8n+V5V
	JY5zVnK62gPGQAam7dQ5qDuPHyNXIJs=
Received: by mail-yb1-f180.google.com with SMTP id 3f1490d57ef6-e8da1fd7b6bso905401276.2
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 14:07:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753996059; x=1754600859; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Ys/9FFyQ9hB8hcspnWH+yLefcO8HOj7bglv0EmfT7S0=;
        b=MFDAVKdY89CbZ/6XyEAZ8lGmlHhyR3aH3vPOJkWGaGEuFNUJtvV9QS2cbHmI5o1BJC
         haUAeFBT2JSeZk8B65J6snE/T9zs/4ZVz9fPPEpYkO4hmQ6P+P17/tPOI3xikWCkgZme
         yXB8n59bJpjGpvWZ/q8a0o8r8qPiyvL4LqcRWUplFF7Pw/U1pH1JWoQznsUc4myTNV3E
         VNarRx8V/rEdiuPm0VUfsC5xQpB3ABMKAWxPY8DDGXhxuKB+LiaCfLjs0WYZUD3uW8bL
         /h6/Jjr56ky+Udbrrgcz3mnAdvsteXVO06x+UquE6ivLABJrV454zRUGsCnz32xuGpRi
         s4UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753996059; x=1754600859;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ys/9FFyQ9hB8hcspnWH+yLefcO8HOj7bglv0EmfT7S0=;
        b=AEI+6cD0vxtUFJv8ka3gZqs05ceD3bh3OV6LhrVinwrHqE6D0Fp5aU2XGFp7xBN2LS
         hbkgtnWe8floU7qjBfw1t/zTPdQCnm1uFNOjOxzXb/lp67Mg5QJq0KEW/H1N4FQAO2z1
         CIMx98twwZgJfPB7WnX4czKvYbyAwXQTVM7Obb3fcC9MOnho/aWfZ5TqGpwwbdeaOFvA
         hwLOEcn/CjGDSl52Wl0wCcadSht7ADraBDdrTZNyAhkelA9XJY8ytdFQ9pKb7Le9vguF
         +LDmjBGg4FdzPO0GKLF6zKSF5H8Nx29yn96DfzmlfDHw3qjmmOYItf3cwlnjAUKEDYjm
         czhA==
X-Forwarded-Encrypted: i=1; AJvYcCVhJAZOsWO5PYOmtpQAkIo4F4sZExG/v7/rn0wJ4IDq5nf2d23hewsCq9yKU9tzAOTn6+C3RT58VA==@kvack.org
X-Gm-Message-State: AOJu0Yw95kBajVrRapa0MUgZ+8Tu/UTY1IMacJkch0/J0VjI0rPzi61+
	31Gtv+0VvHh+ks9ok88weVYELPKmbFixYGiN63ucXgWP6hi98zyP08Zh
X-Gm-Gg: ASbGncvJsWwIIUIna2KPU/UgoMVsw8js9mj45AyqtLNdN6B7RLnbGAAAXwDaMRMG5qn
	gWEz+m9zNcWTG/Wi/KyitvyeLQHk3Y+uhAhfLWL1kuoJN+cw4OhPUNTALNdSjQtw+Z/i/U1C/cD
	iKoo4s/yxlMEQx7OBxP+zAgYvUXkZuXH6lFdMKzs8OLqy3HmCTIkpQqJ02zfg5siWf8zaYNmVXT
	h1s+Fl92RN7CYP85hOXUz+BICniZGZ+hwb3aNV5VkxDNZe1/FpE7ngIc093qAnI7P/nXiB0klXA
	0huEZ18FRJYUk/pN6N0yOPfckE7NSvaCMKONtXyZ3rxEYfWrGuyqT5xSLV2ZmKnOnZJkoHUBxUV
	y4GPm5fO0BnhT2LFY+Ss/Rg==
X-Google-Smtp-Source: AGHT+IEMI4Rge8h7u3jlBR8l6CqYjTTPAtN94om3FOQ2i4u9MwmNuiAviKSmWcF0hf66oLb+CK8DIw==
X-Received: by 2002:a05:690c:3581:b0:70e:1771:c165 with SMTP id 00721157ae682-71b6d7f8699mr2349177b3.29.1753996059192;
        Thu, 31 Jul 2025 14:07:39 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:42::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-71b5a59e009sm5975527b3.53.2025.07.31.14.07.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Jul 2025 14:07:38 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	SeongJae Park <sj@kernel.org>,
	Ying Huang <ying.huang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Alistair Popple <apopple@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: [PATCH v2] mempolicy: Clarify what zone reclaim means
Date: Thu, 31 Jul 2025 14:07:37 -0700
Message-ID: <20250731210738.1451854-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: uns8d8oabddryuq6qxdp6r8mkaqrs4o8
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 729A140013
X-Rspam-User: 
X-HE-Tag: 1753996060-982197
X-HE-Meta: U2FsdGVkX18aR+UM/nsWzxTy36pKuM6QKHG1mzkWW2Ow7kmXg70IY0mS9b3yyKMbCFp7I62aF6zd/kEaW8xCDOL7V5F2hpSK1KMpDYFA9+bz4kMHdWtXlGp6Hs0PWkyZnwuZGzR3Em4C5/KEWUvftoQD652PtXiGqobqWWcpvEC5hYuI4iviWwxw85N3ZIv8HD7YyNqWJI29g2p9Rsxf7SbYQ+YCEiyZ4zWMM1qHsHqZKbSUd/wD4XBPJNylErvqWq7qVKaQy8wPKQMTmSVUzHc8EXkdhCYGVCiFQYpJ4b8if1JdhHUnhYRnI0Orz5yX9oQSgoRQVfglqRzgW7WbwXreqnoyMARYSyBgpwddD2PQ9/XyIgRCgqU/b8PsgFm8Y9PE6l3oJlKhykKoM+5/VSEJ8UplVCjpDzxw0vcn3ZnahtFxNTIMgUxPGhAFYX8PvgAt12itf2lEs3+ewnYZyOkzFf17XxPDfTj5JMdLrHtCC2gSuR8swLGyx44luY4Ggl6MgbT1AVWDHlnNlm1uI18Ssq06Uv9i1qk5ZuUulGr5JIv3cPwPGMKCLogwC3CuwwnTCYcXOmKCqGmx+aGpYdsoo6gliuTMQtvUa7qXC+U7bTec+1/BTjEjP3ibGEJpKf8Vde+TGpdFRM18uvoS+wNwsB9UBV6i8WgwxjywzYO9BwXHtQz1+V+ETUKQGwwoL++Ailr/ChfjxXaKYHhnweZNwM1ARtKeQWl/w3ahQJexCTcYl9reeS8lWkLBeQopI+vjRhUPH3Kl+P3hfNgSOog9lw20GHUvpyfX7EXw8ZjWHjQ0jJVEz8Vzi+8vd1PFVp57b/9dW3f/JvOYs2OzTsxocfeW6HKu5ltxwdlv4hb1aq/JHuGbeIMzubxN6o3unruHaUtGST6wwvi3yk9NPPc83ra6eSPusL3Z2+vvjZIS3e/65HB634SSSrnS8/6djXroFTBLTX0/K3fwX0D
 0/KopKog
 XYsq+XBkwo/S3dzqzX3WlMpFQvDbzQPGTRkIaXZ+20jHD3EeuHU31qtvmY/hlChNGHDcmcI766a8ij/C0nmo7C3H92Q2e2hBrmSrvazfe75PjBJepEAoYTu/gsUwYz9lpPOH/My3e1QmzV1EyAjIBQiVmo1IlBwxcJ6gq4cmExSWvUGAwlCNt2QtT9dfem6vghZnhAJ06F7sl/l+k2CquqbBhlTF9s/sw5ef8AVj8EyfKdvU/zk5MWzWL7eiuIQSRHW0rqUpgJIpj+ZOAUlnFh+TuTT4ijJ36+kcdzZRP8bW2o6zbNry/+CQj2et+M/713KX3pb+MULGQg0KZ94eHLABS4AM1CAc1eXoIlw+qWpnVbOyDfOQ0F5JWQ2m+za4iQo+9SFmHGL/MG31PSDnG/TTjZ1HsQpGEdJdEC4Cwf3ShZwab+9MdHE+P6oG4IR+ifpw3K7cy0fFDf31DKw1h6nPfTnLURy828ncGKNig966h+cWmzdsuTLvFTjkma5q6i4oVY2I/9eg2tIcbygmUo5786JVbf1elCQeT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The zone_reclaim_mode API controls the reclaim behavior when a node runs out of
memory. Contrary to its user-facing name, it is internally referred to as
"node_reclaim_mode".

This can be confusing. But because we cannot change the name of the API since
it has been in place since at least 2.6, let's try to be more explicit about
what the behavior of this API is. 

Change the description to clarify what zone reclaim entails, and be explicit
about the RECLAIM_ZONE bit, whose purpose has led to some confusion in the
past already [1] [2].

[1] https://lore.kernel.org/linux-mm/1579005573-58923-1-git-send-email-alex.shi@linux.alibaba.com/
[2] https://lore.kernel.org/linux-mm/20200626003459.D8E015CA@viggo.jf.intel.com/

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 include/uapi/linux/mempolicy.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/mempolicy.h b/include/uapi/linux/mempolicy.h
index 1f9bb10d1a47..6c9c9385ff89 100644
--- a/include/uapi/linux/mempolicy.h
+++ b/include/uapi/linux/mempolicy.h
@@ -66,10 +66,16 @@ enum {
 #define MPOL_F_MORON	(1 << 4) /* Migrate On protnone Reference On Node */
 
 /*
+ * Enabling zone reclaim means the page allocator will attempt to fulfill
+ * the allocation request on the current node by triggering reclaim and
+ * trying to shrink the current node.
+ * Fallback allocations on the next candidates in the zonelist are considered
+ * zone when reclaim fails to free up enough memory in the current node/zone.
+ *
  * These bit locations are exposed in the vm.zone_reclaim_mode sysctl
  * ABI.  New bits are OK, but existing bits can never change.
  */
-#define RECLAIM_ZONE	(1<<0)	/* Run shrink_inactive_list on the zone */
+#define RECLAIM_ZONE	(1<<0)	/* Enable zone reclaim */
 #define RECLAIM_WRITE	(1<<1)	/* Writeout pages during reclaim */
 #define RECLAIM_UNMAP	(1<<2)	/* Unmap pages during reclaim */
 

base-commit: 260f6f4fda93c8485c8037865c941b42b9cba5d2
-- 
2.47.3

