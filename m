Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9613CD4F21
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 13:08:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57ED16B00A7; Wed, 13 May 2026 09:08:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52F786B00A9; Wed, 13 May 2026 09:08:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41E466B00AA; Wed, 13 May 2026 09:08:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 30BC56B00A7
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:08:37 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D3D6F1C11B0
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:08:36 +0000 (UTC)
X-FDA: 84762425832.03.63164A9
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf18.hostedemail.com (Postfix) with ESMTP id E404C1C0015
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:08:34 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=FSGBzciU;
	spf=pass (imf18.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778677714;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dehsx8fG7S5ip+vlcPIiCfZ+EzOUnANbQVn1Jj1cBa8=;
	b=CKFRfFH7mVaLQ1zDAMFSgNbZr3QJUAjobJobECKQGDwrDjf07wjDDpKZanlXbi5qFLaYo/
	0dMDTamuUL6v8UHcx3cwILTHZ4U6tFTAg5lg9uFD3xLbFMfQFNTkJ/7ypIoGY/OC+8oOh7
	KLRLPL9l3HO73iIAgWOyMStNrtvf+T0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=FSGBzciU;
	spf=pass (imf18.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778677715; a=rsa-sha256;
	cv=none;
	b=Y7zxcOhraNfGiH2ohHLgqEciF/BmbYr0mKFz6E8tnVUeAT3vlzKGXzNX0bdPxOdbayA89P
	CBJA7teN6qxPEiNhGss9abqRSsFfWubRv0F92Iq97hAjP7pONMcPEqJuqVLs+E+INw4eDF
	HYpW9bMJHr9aYJ0OkcewZ++x6h6eC64=
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2b458ca2296so45019475ad.0
        for <linux-mm@kvack.org>; Wed, 13 May 2026 06:08:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1778677714; x=1779282514; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Dehsx8fG7S5ip+vlcPIiCfZ+EzOUnANbQVn1Jj1cBa8=;
        b=FSGBzciUEhWqrJPsFVnVqpL7s3qA4VhTE9jHF5ktYCp7mX/lYsvivcKJRNmmKzfMnV
         FJ3rvdDb6HBcnEYbtXxxYO77RZioqNCtYTTv1MQ5GamIN8MDKTd5iKVfGsgmTeBuWwCn
         fIphyHBztuvKjPuYCYd41ytz5nADzNzHOARB5ZpzXkfBDHZsilmQPBzJeH0jvbPmgSVW
         xalQERKL352Dfi0qdW+YMFqfzEBlIVx3v91ZCpeVjXA+KLze72H2MlGVdLxsuIIuNz/A
         UUSw8hdynHYBjAVeJL5bfRhvxcJWwwRuSdgGHdz7aAX73zCYiH4vqZDI4v1N4yAqNhQh
         x1CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778677714; x=1779282514;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Dehsx8fG7S5ip+vlcPIiCfZ+EzOUnANbQVn1Jj1cBa8=;
        b=QIXY16eSGSAdvmCJvoHropGLCBAu1ORchwMaBqkk5dzKBmkTDbHV0Geh41z1o+gaRu
         X7vEkGjllLq+Bifzngg94P53TZHKSujzaQa/0uP24hA6o9Fg3tAdve/qe5/I0WVfUEqw
         1EOXxqEQUrZI2XxLFh1YLwF5nAZySeJ/HAswTCYOA0GPhXbaTe+4Bv0tUyABoE/pEZof
         gDdscuxNUQaiBT/6KcQvzwH8JEyEIXpkq9A9jjd72Ne584uoDvcgpdj8edZ6TLynBVMN
         0JdkTLvS0Wv7VH2SowImn6xgmD2RlxrHcQeKHgdlLolRPVvksGU10EMh353CFUu+ZFD8
         zL3w==
X-Forwarded-Encrypted: i=1; AFNElJ+FODLgQ4xDTcKGyGUFzj1yu0pLZgXgocKuX2lzllFlRY2C887deQsDsiIgBphFWh2MzetMMWf39g==@kvack.org
X-Gm-Message-State: AOJu0YyWm0aEpSy4MFpqbwkx78ojxZGerXNDTp9HgTFViSey0J5KThV1
	mP+rDfH8IQCU0CVrRXALJ/my1dq58BGBFRcJoEWFH9XszXH/TSr+TZD2FOKSm+fjV8I=
X-Gm-Gg: Acq92OEEw8hLr7p/TZUMH09EdushospqPRNbK5mKQ0Gcrl7+fmdhlyjni5NB0M6Nt0G
	XkTd1kuGZPuQcJrsqc/W1KxOB8S/4oRaJ1Rk4K2FmFuHrUNX11OI+LCf0fHiM4wn8SAM/PQN2rz
	LjSJDuc+mIuL158PiUTPVimMrvA7EctMGSru5L8Fusd2GK/KihVAVqcAAMA0G84A/6kxx7mjZY0
	g+MsyackAHnXrDBTGKxHrNf5TM4qE4HfKaIe/eY7s/QryMlXxOciXCZjMnVsU5bS4u+TWshn5ei
	9YT1Pd+uhAHCLsKIAQaqRpsfT6lixMfhDyrWdOkhQEAX57PKQpPT7H5BZhhanHwq+3jbF+F1VIl
	xUN95Eq3DPdsEXLcdVmP9H7mJtYbRJOKFkgUBdXuz9/PxGsRFCv5p7Zuki+BW035GnEK2QSM33N
	r/tFyqQxNF3JxfnxEA0CLy8bUQIxjigLGtHwNMjFHT6vVnelpF4QebHPAylFI=
X-Received: by 2002:a17:903:1a68:b0:2ba:5e44:ce8f with SMTP id d9443c01a7336-2bd26f13117mr34896815ad.0.1778677713521;
        Wed, 13 May 2026 06:08:33 -0700 (PDT)
Received: from PXLDJ45XCM.bytedance.net ([61.213.176.6])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1e90854sm166641925ad.66.2026.05.13.06.08.28
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 May 2026 06:08:33 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ackerley Tng <ackerleytng@google.com>,
	Frank van der Linden <fvdl@google.com>,
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v2 11/69] mm/sparse: Move sparse_vmemmap_init_nid_late() into sparse_init_nid()
Date: Wed, 13 May 2026 21:04:39 +0800
Message-ID: <20260513130542.35604-12-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260513130542.35604-1-songmuchun@bytedance.com>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E404C1C0015
X-Rspamd-Server: rspam06
X-Stat-Signature: fi1mxxpbprsaiz7sxwtxpiqidktxs7h3
X-HE-Tag: 1778677714-57538
X-HE-Meta: U2FsdGVkX18jB/+ijce1XVdS+xfV5247tfZdzxwKSqi9wXHa86JWsMXQH6PdnPq1ViiDrToTW5uZG3GBbiffto7DpX9NX/6kEG2Qwj6YdWgmtjsphhDviGlU9qmIswxLH9Y/O1D/ggNHhutgZd5qAriQR4AstCxqY3qBNCwZlBGv9+W9qodnxCQmw3xgL6w51wgHNllcnudWZKJ6y0wEqm4h+DTQl0RvDFO+e8hXpZa193jvK7x6NuR+287u6y5j28o7C+uBd2ZeBecEHa0Ja9rCh1HLPyDCiq6Bh3mOT+CsDML9+VMKaj5A6o/s1NijGk06uXUtLu8zg1Tu+wjWjRmZ0+QuCJMTzaPTE1j/j6iOFBExqLKbRVcVFXNfmg5yNZaaaAAnYVHJKeZldZwOq2KnYwiCPYPzzVzYAhPasUruy2cikaP0ExpH4ajsRQrJxo5qPEszhwxj8zYsaW426lwmL4u3t06jLbaTqoE2h69xJd7plHuUgMlgx9LEaeqxeNC2iFajdDAoG4sDOh0L9jdXmW00tga3+VAL88vX2z07k37bGJulgvloF1jQrMHSWaC8IGzOAilq4PQ0Ed+4Ugsq2lw0P0HpXZcM02rVSGqGB5XGakWekrHJYgFIZT/zPO61TQlzYNq5C1WteYQXF6L7yxPyrGmnQ5LYmL3XGboL9Y3NZitDA5X6LLKSQlEhNXZMSIAbMPTZPanp6OAemLDS6tCZ6Sci61TGUBwgL0J2lNLf3QLWZHq+eOQ/hEm0mHInOI2MIW/xPzeiwSO5Xjn4u52HEvQgObdcUJ/rg/JpxPgqV2qHJ+PMUQ7eHH2GtDYX1+ZPA47tDtKbm50TTjEEnv4Tnftv/XvGPtyeA7uI5DtH8NhIQRvfXdUrlK89Xp3FR1xeibmxsh81JaNkNsObQGM1wRZyPWRSuybyyFmrBMDzDPIWhT8wEIUYmIE8GSDfOr6A1k0rKY/nlbH
 mjLvuW0H
 cA8TSaOYJDihNis/lvkQV63AeGcN14I5ZR/33ZqAssbWAOMw9UBp1noUyXn/aW7FODaPmAKqH3SjOhBDOfT32qHxtEOCFaqgHqnrJ6Ckv8UlDcbKguauCyKhy3xMd5UnEO+HLdUeRdfpcL8Gi5qgWdlk+XrvypeSNKSfM803ovQvDyp7jaxpuGP+li7H9ad3ltBzLx86tbDQlsiD9DYYhokqXUvMy0k0U6xyeZo07bX8AzZF2xyz9oKeI4l+coZeNxeZkwiLmEL9x0cu2N9Zr3i5UB9ve7vfc0jDS+JHYvGz3vCIkdJ8EELJVfA5DGR8a54BaZruF5GalXVvIZ0kZDWRC6/ox60e7rjCtSuc5Usw8dWBg2A7GNqk2L61Sxh8Liyor
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

sparse_vmemmap_init_nid_late() is still called separately from
mm_core_init_early(), away from the rest of the sparse initialization
path.

Now that sparse_init() runs after zone initialization, call
sparse_vmemmap_init_nid_late() from sparse_init_nid() instead. This
keeps both sparse_vmemmap_init_nid_early() and
sparse_vmemmap_init_nid_late() in the sparse setup path.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
v1->v2:
- Add Reviewed-by from Mike Rapoport
---
 mm/mm_init.c | 4 ----
 mm/sparse.c  | 1 +
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 6646d4b47796..165b83c9a9c3 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -2686,16 +2686,12 @@ void __init __weak mem_init(void)
 
 void __init mm_core_init_early(void)
 {
-	int nid;
-
 	free_area_init();
 
 	hugetlb_cma_reserve();
 	hugetlb_bootmem_alloc();
 
 	sparse_init();
-	for_each_node_state(nid, N_MEMORY)
-		sparse_vmemmap_init_nid_late(nid);
 	memmap_init();
 }
 
diff --git a/mm/sparse.c b/mm/sparse.c
index 324213d8bdcb..3917a47153d8 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -320,6 +320,7 @@ static void __init sparse_init_nid(int nid, unsigned long pnum_begin,
 		}
 	}
 	sparse_usage_fini();
+	sparse_vmemmap_init_nid_late(nid);
 }
 
 /*
-- 
2.54.0


