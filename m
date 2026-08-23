Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE124C5DF81
	for <linux-mm@archiver.kernel.org>; Sun, 23 Aug 2026 19:41:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 571486B00A0; Sun, 23 Aug 2026 15:41:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 549726B00A1; Sun, 23 Aug 2026 15:41:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 486CF6B00A2; Sun, 23 Aug 2026 15:41:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0B3526B00A0
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 15:41:21 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 755FF4035E
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 19:41:21 +0000 (UTC)
X-FDA: 85133553162.19.F0A953C
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by imf03.hostedemail.com (Postfix) with ESMTP id ADB2320002
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 19:41:19 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=FrWV4tyP;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of 33kyLagYKCAExzjibohpphmf.dpnmjovy-nnlwbdl.psh@flex--wyihan.bounces.google.com designates 209.85.210.198 as permitted sender) smtp.mailfrom=33kyLagYKCAExzjibohpphmf.dpnmjovy-nnlwbdl.psh@flex--wyihan.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787514079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vW4yOfIAs8YLh9FZCJuAriQaRtqPfpKolhm3EvkTWjA=;
	b=tpoHhYPodGxRivNYDHm25kixF1rYDvoU4PLRYT5hUAQ9YBBa6gDvF1D06FRoA0pw4fpw++
	84ICRqwIRdTapCE7Wki5ZKhv+GnB/0OZh6Uz5k+7wUZZ46Hu6THDklAjFnjrNHQrGKUC1m
	VFxaBc3NL+8PQ8KjpicXS0IrvUk4WjU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=FrWV4tyP;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of 33kyLagYKCAExzjibohpphmf.dpnmjovy-nnlwbdl.psh@flex--wyihan.bounces.google.com designates 209.85.210.198 as permitted sender) smtp.mailfrom=33kyLagYKCAExzjibohpphmf.dpnmjovy-nnlwbdl.psh@flex--wyihan.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787514079;
	b=n+nDzgic4YXCqSH4saFDSKvvVIbrD0iKhqBE1tMc+HOc+R5piGT+0VcDVpqqn/A0sPJAe4
	nSmiHjrUq9KsYAQ/BDE/MhUqy7UPUKhlL7Oey/AerYXjyXNHq/OpNDDO55Xkvs2Z5mg+nE
	ZD5Z2AxmH0cYAXoe2RYMp3ASjIDsPEA=
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-848662cd2a1so2812991b3a.2
        for <linux-mm@kvack.org>; Sun, 23 Aug 2026 12:41:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787514078; x=1788118878; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vW4yOfIAs8YLh9FZCJuAriQaRtqPfpKolhm3EvkTWjA=;
        b=FrWV4tyPwj62YB4T4HY9yJUlhPbglNmktsqsCG6mYSlPW8QSHHh0QSVxZtyGP7O8T3
         u0cqVwiz30668XrZfqN7vD+8hZPD7oHz27k3dMK7VL+ES9/hjySVduS8TuJVTUPBHfFs
         Vi8/V9pEogt0XSpNsHdnLUY/gHPBzKfI/WbgsheqdPmTIytsoAWg8mbUcKPbP17jz4+p
         upr7Gn1N9V6Me/xHLOPaFvklmNc5FypuNJhMyICNzQX5/rKVA2Be0RAHDTRuCdLAjG8m
         lGvJxjqWKMpSJ1FjKsNXg46N/OkJ/3tCym36I8E+U4Osak0ejB9ucEBZyaLwU2NVEhlM
         7naA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787514078; x=1788118878;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vW4yOfIAs8YLh9FZCJuAriQaRtqPfpKolhm3EvkTWjA=;
        b=UM/1Lw43I/9uze0rehSdJ11maE95kKq3cZkKA7F/Gqig3NC7HATb0iSXv5RsFm4ESF
         hbPOXebhr9E2cJWa9L4flM6oCjjpxmnlGD45fuD+XooNhZ8zXFN9WFuoCgol8UX4pSyS
         2ngP6cb6D4FeD21DXUSnifsdsq6+BVMJo4K0mFe3V7MVDZSOwtAWZWjKIg8QfOlK+55c
         8NAICRM9zUAETsDZ8Un6VRjs+DnpKAjgjBOd9L6EEqgEFzD9uIf+/uDpSVXQXXUxxf6h
         VjtPb0B4CHGbmBuxwVDvPQYhNsCjclptM1KNh42bPXAqTLHojTIL90SXRdBvesg7IcAI
         Na+w==
X-Forwarded-Encrypted: i=1; AHgh+Roa9i9yWEQFp3IzsblAkXZnBX1wDRbBxq1ovR9inKr4aPkUO0UTe74OdTeMVszfQ5P9hN2NE7b3UQ==@kvack.org
X-Gm-Message-State: AFuF++k3YQiN6PHINu9mUz2is3gZm7g3dJPMhNa/RCZ9DdANDlt44pei
	uR/hWbS9z0oPQZ9jEdngbjQyLHhb0gZ90tuj2h+vpV3s9BDhrKTJK1iZoZ8MM9vWRuO5hNQ3AEn
	XSi+8zg==
X-Received: from pgby19-n1.prod.google.com ([2002:a05:6a02:6513:10b0:cc1:960c:15b1])
 (user=wyihan job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:2d28:b0:845:e8b5:8c49
 with SMTP id d2e1a72fcca58-851f9f39cd1mr32509544b3a.10.1787514078336; Sun, 23
 Aug 2026 12:41:18 -0700 (PDT)
Date: Sun, 23 Aug 2026 19:40:57 +0000
In-Reply-To: <20260823-memory-failure-mf-delayed-fix-v5-0-d97a5703e45a@google.com>
Mime-Version: 1.0
References: <20260823-memory-failure-mf-delayed-fix-v5-0-d97a5703e45a@google.com>
X-Developer-Key: i=wyihan@google.com; a=ed25519; pk=cRi0fKzS5BMxlHyHY2pJv3w/1zcgfYKr6EYGYppdMYc=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787514072; l=1693;
 i=wyihan@google.com; s=20260319; h=from:subject:message-id;
 bh=M2qr6lCxGvnWbypTSRZIOkbIWHxFsLVgiK9mM+E8odY=; b=bd+N1aGdqQ3cc8pEFS9Y7bF9mKDfVbYMU2k/ThMMa54u9kS1Z3odwN1SSgUef8uc2QmPWF/Sl
 WVWnSzs0S3YCNF3JkKpTzl9HEIlQBvjr3CCKD4lyyX1EO4Ea75pfji3
X-Mailer: b4 0.14.3
Message-ID: <20260823-memory-failure-mf-delayed-fix-v5-4-d97a5703e45a@google.com>
Subject: [PATCH v5 4/5] mm: memory_failure: Generalize extra_pins handling to
 all MF_DELAYED cases
From: Lisa Wang <wyihan@google.com>
To: Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Andi Kleen <andi@firstfloor.org>, 
	Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>, Rik van Riel <riel@redhat.com>, 
	Yu Zhang <yu.c.zhang@linux.intel.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>
Cc: rientjes@google.com, seanjc@google.com, ackerleytng@google.com, 
	vannapurve@google.com, michael.roth@amd.com, jiaqiyan@google.com, 
	tabba@google.com, dave.hansen@linux.intel.com, Lisa Wang <wyihan@google.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>
Content-Type: text/plain; charset="utf-8"
X-Stat-Signature: 6pz4dh8dtp7ftwunkph86bzrsqx5hbab
X-Rspamd-Queue-Id: ADB2320002
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787514079-503867
X-HE-Meta: U2FsdGVkX18OsWDBuReWayNxYguOVtKKuHZ3jJtZNNM3rPlsFx2rg+juQ5YrGvqg4Hg4Av2RSKr1La+TMnQsr4A7hBT2JA1VO9zzQPWEdXGleRV4QB41XEZqAGr2Hnf9TG8BWUQ/uDm1PUJQkE6USUVOIoOQhKbzfVkp+G8GLvt8FilSCly9Io7C0Q4gily1FSUqtoslY0kcUb9qqYolf22aUx/cRZV4gcUOd88OtWTClvNvAN3MlIKHGeQtWFrUdznHuc3u7WwZjm9ICdxToEOpMIbizmW6se1zcb6b4yMCqZawmKw+3Aicm0PvMdFIPP/go3bZTu/19vjqXcR6tFGaOTawO43UAaxTGidwEkBUk814uUkU4kmv0ahjFoC6OaEmPU66hettpHnEJcGMTVnqaBO+n+ybTWFFp0xNGCltrTTfIwJVaO8wg3yhUeMP/sMD89A5zliqb1BkUed0Wj7e3wrQJn6IBTMmsYb268dEM9C6Shli6zXnN9iKJHZIkKQoYEddJE2mw9V0cfTcv3dowMt5zE1EhM7/dNUULQwF4FuOnPENandPzd3q3FL9p+fuBRUJqYA0K2ZWT/uCiv2vFwNqz9WGOdqxCfD2WLS4x6WF1cr6nsRinc3mvD9X5+23s7Yl6OpgtgrUMHb0+JFB5ul+mGehkdf+MNvdx7vA1Du1w21VDqafbI8hk/2fVONUKZ4Agcuw+Q3N33X/BK0E3uO3pdg5pmBrL5+y+juuzi9DUZUe18snBmtifXDOc3LWyCnvgcF88vGLggVQgz8fjXoTShYmr1/4C4cVL5Sh2Tqq/tC3Ab919muQ2R3BE8b96H45UE7oF3dsGE5F0qk75uNtfnlioQJ406M7kBI6LTs9JmEHsWevPCX+4K0R8+VyhoPEq/hmE2pVkk7GVXlMQ0RYUGWtR/+jSvcr+ilSGpNIIUEJXjy/IfwJKTRh+cNM2dYwgJmBQBxv/8X
 jVWqAF5x
 9UQytSid29y2DxAt0eqBJI2/36yIPZQd9elvwv9q1VzZtxntp6DqLxDvWXpvXiZ94eDFgzWj3KY47HtdjPezq2xuR0qAaBrp9HMJvObX1xMTg6ewVKPJyxZVV0anBx2gnGuteSuo2tNOOnGQ3oee0DBE9ChOWWwsWW5Sw5nzLdLiThKBhoOs8uRM0+GDGlnPvo/sFSs5wzWZifn6YQI71RaJ30MtYV97Om/uY19lmNGwryUIHHN/URFfVGPFvTSt7Zm51J3eXwSkrTL2zV8Q+L4F07Rvji8zQEYcu8ovh7UJCBd8otjBea854/44w+13KC/IAKkx6LRx1xtHSfbqTAaRsJwa7uRNE1Om5I6OYNqaRDBafkCP8qyO4FvBfqRKL5zwPawn+yWiN9Iug5UVdV+JNBoqrZie4QOLY3xQfh9L6kezeHZOwhUTYQY6Ira7iRy5b2nMTk8xbL+7e4bRjFEe54CCcAKxMOWT8SwkKktxI+tiGldb/N6dY3FtIWkhO/l9b6oSfBv+ynWU6mw2fUyz4vVaPsVZluU8Wd8kh5l0JFafRfSpsRxSWoiASvVIQXnSuJpeHeR+82NLULyTwMZLRdchy8gD4Dzqib+Qp5W4KAeJVCpmPg8OaO2yM1Ou3AHh/ukso1r1yOrgQbZoZi3G0HEf95mJzGYtDFvByyvESjhJ0h4LfXgQFIQxICHntEpy33X+9jaCRMerKAFVVIIlyrQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Generalize extra_pins handling to all MF_DELAYED cases not only
shmem_mapping.

If MF_DELAYED is returned, the filemap continues to hold refcounts on the
folio. Hence, take that into account when checking for extra refcounts.

As clarified in an earlier patch, a return value of MF_DELAYED implies that
the page still has elevated refcounts. Hence, set extra_pins to true if the
return value is MF_DELAYED. This is aligned with the implementation in
me_swapcache_dirty(), where, if a folio is still in the swap cache, ret is
set to MF_DELAYED and extra_pins is set to true.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Lisa Wang <wyihan@google.com>
---
 mm/memory-failure.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 37ea23489b75..c7a00c7be368 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1039,18 +1039,14 @@ static int me_pagecache_clean(struct page_state *ps, struct page *p)
 		goto out;
 	}
 
-	/*
-	 * The shmem page is kept in page cache instead of truncating
-	 * so is expected to have an extra refcount after error-handling.
-	 */
-	extra_pins = shmem_mapping(mapping);
-
 	/*
 	 * Truncation is a bit tricky. Enable it per file system for now.
 	 *
 	 * Open: to take i_rwsem or not for this? Right now we don't.
 	 */
 	ret = truncate_error_folio(folio, page_to_pfn(p), mapping);
+
+	extra_pins = ret == MF_DELAYED;
 	if (has_extra_refcount(ps, p, extra_pins))
 		ret = MF_FAILED;
 

-- 
2.55.0.766.g2966f0265a-goog


