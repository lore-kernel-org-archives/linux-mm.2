Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CFC5CCD184
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 17:25:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73D208E009F; Thu,  9 Oct 2025 13:25:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 714928E002C; Thu,  9 Oct 2025 13:25:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DC598E009F; Thu,  9 Oct 2025 13:25:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 34DE28E002C
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 13:25:04 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DB79E1A067B
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 17:25:03 +0000 (UTC)
X-FDA: 83979251286.16.17129C6
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0B92CC000B
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 17:25:01 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=W7IhF4XX;
	spf=pass (imf22.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760030702; a=rsa-sha256;
	cv=none;
	b=gvlk+LTVI4QgLy+IksCaXpCJ7LdIQoLO0q8GwUjTmqEBrRq/xrO03IOw+oUj00tP1YYjB7
	7MmTnMhXR5HdbwmdRnVz7ryC8sauDjP1IJVEDa/0NvmHa9FFjorhGBCGFXuxxApTRKeRiv
	cEAZ50D9VgjjgLc7TUsjcXtV0542/Uw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=W7IhF4XX;
	spf=pass (imf22.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760030702;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nHs3vTEzsqX/lrSosRYA6lDBYTRtFs3F8Lz2Rdvx8rc=;
	b=QlS8TlbKLpi4T+w4PDWt+QZG7Ev+ZckT2/VDYuzKS99BTZRWHZyhzBCsQ6I8tvBYdODs7U
	zkD9uaUlbZLd7CtD4wgDj/baXBvsBitPrDJSiap9punq+dUMdkyLz35j4kg85TW8bNwgm3
	kEchz0WIYIgHTx+coljLYpQcG5JKa60=
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-780fe73e337so8855017b3.1
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 10:25:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760030701; x=1760635501; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nHs3vTEzsqX/lrSosRYA6lDBYTRtFs3F8Lz2Rdvx8rc=;
        b=W7IhF4XXGz7C9CeCIiD6rTZi1G9OtfWRZL8Z35dKZhaTNT+lysGrRfM7w1c0gAnCal
         O5jRJYE/IxQ6S5c8Nbj68qlBHPTDXgBPNW7O2jd9xZ3AVJ3tJQzE1M3ybrVMCw0hftq4
         SfQwgFAEeP+o04ZOMzRU/BqHRIoNURivH25xVkFhsBC0ZR6eXVAAXGUPc/zW2szFu1eJ
         ABMuZOr1nWeqxxLJHeuoc8uQp4jEMEYqBLQ0bBb3RTLz63MgcOnbICfdjvXm/0+Vc9Fe
         IFoci5A8coEaK6fDDe1orOKBGyD9YonPyNXAncbMpv/eySa8Ey25+rAbBv//zRp8210P
         ptbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760030701; x=1760635501;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nHs3vTEzsqX/lrSosRYA6lDBYTRtFs3F8Lz2Rdvx8rc=;
        b=nAFVvROPhXZ3Ma43RmiohEH/wWs8O9kouFY4hrVGeCf3dGbGkWKQgr0UIr1oYj+WRT
         RMhexd0e7OY7DLKtHbD388zosknMyngWUb0Bw6c6kWY5R3mmdl6+08sLNsm55NoFpqCl
         r8oyWnu0pgU0Fzy9fJHMmbYIF4DFmaQ6SpdH+DXxqrELKknIlzcqTQb+nmRlntCv9i4N
         lTJ9yjZladcXKwMvYO6ZAYXMsxuaww7NZkMWM9e+7mRZNqWsjIrgktpRAIj2fRvGWy5f
         wJ85/tOM8gjQGMiDxs2N3uav3Z705OZYcEQkYHaINUds4lnXUbufMWorTmecHr67IhT5
         4m9Q==
X-Forwarded-Encrypted: i=1; AJvYcCW0h1LJJju6+rQqS79NgaBPtPBv3bIxXvRRBj8AdZdJSm9XdxjqvF5+gKv6igRKKxpwTd4R8qhCvQ==@kvack.org
X-Gm-Message-State: AOJu0Yzets4RtfZDrRmF98Fns1SF8wY0y4ZiqOJUXW04M7uDcLEZ3LUf
	WeEeqCQbqV/Ji8ae+wXOox+6WGG710s2OSUZaxHErjAZmg/qQpah/snQ
X-Gm-Gg: ASbGncsz/hXRUQdM+vcsWpHzAdKx1L7h0ugdr2J53Gsat8Dy+MDEt8MC6nZkeQNv76P
	Q7KBbVgoU+IzYaAKmYFOqyOWxriqBcLvEfolg2v0nxYGVHlkfHH+WVATT7xpEY0ZoWdoFALOFUA
	g6Ko6e5cZ40M8yj10GAkhppEl+gcgw3f5AnunA9Ku/7lVrcPjDXmMIqDHvHOxygeLDa5pB+WnGS
	wgSvlltXT06tOnAlDaPbr2WSgUUdJbn2yGRYW8prVyn59I8Rh4oHVURAHK8NA59cTvemMxf5p76
	0/YrjsIns9YsnTqgFea9tO2U9cV67VJRNMbds6GEzUUHf9MgmTxLSprNHgrAZwRIATiKF1XdErU
	yOyEq7oYed2weYUkcPz7YVNQiDoWL2pIi1oLdwjXKZgkEN7MSF8p7iAJLVRmoeLmlk4c=
X-Google-Smtp-Source: AGHT+IFbZgedcNYqQke+1OXZPO57fV833IqHejgnCHT1x/Sq25k96WuYViPRYem6oJhVnlQqCgXoAg==
X-Received: by 2002:a53:de52:0:b0:62f:c634:4b3f with SMTP id 956f58d0204a3-63ccb7ea499mr5757999d50.7.1760030700990;
        Thu, 09 Oct 2025 10:25:00 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:53::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-63cd952e09bsm1029933d50.11.2025.10.09.10.25.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Oct 2025 10:25:00 -0700 (PDT)
From: Usama Arif <usamaarif642@gmail.com>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	david@redhat.com,
	Andrew Morton <akpm@linux-foundation.org>
Cc: shakeel.butt@linux.dev,
	linux-mm@kvack.org,
	hannes@cmpxchg.org,
	riel@surriel.com,
	kas@kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Usama Arif <usamaarif642@gmail.com>
Subject: [PATCH v2 2/2] mm/hugetlb: allow overcommitting gigantic hugepages
Date: Thu,  9 Oct 2025 18:24:31 +0100
Message-ID: <20251009172433.4158118-2-usamaarif642@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251009172433.4158118-1-usamaarif642@gmail.com>
References: <20251009172433.4158118-1-usamaarif642@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 8ux1e3n88pjy4shg58sr63dcguxiy1ck
X-Rspamd-Queue-Id: 0B92CC000B
X-Rspamd-Server: rspam09
X-HE-Tag: 1760030701-348524
X-HE-Meta: U2FsdGVkX1/DKhrSPpTn9C8x7zmv+SmMEvRbAPjmRNb5aAgXodkikNcSB0Gk+lzHJqzzrJh2R3D3vx7FGDJlNSRpTG5EQNG8fxG5TizZpGNTcTMlMMCjkTC04HkDPrJyJHTEDZn8GE23mnbrXSIZKtYMe/Ps4ErUe/itlXU/pbv9gPZToFoo/zt3edvekAC446Nh8DW3PpDsIasK0xc2UZDX4ReIWBZjKrJTHhp/u/G9m7eHokmQNRZrhsMx3b95OiBgjQfFJ86fehF6WUiWQB3/Zxocsh6gxpqj4+0j7Nsp/XXaS86H0E5AFbMFD24KPY9boPvDrbNzLw9UOsGL6jT20pMRoMg45JXrjv0vk+CtBZy/kxOHPQY2B4o8INvMEcHKZbfspotCzwQWNgYAlK/9yB/w5nrB0ZfdaM1q9QoDcEgcIo1tHy4Li3m/O2lt27Z40YVhl43ctF6Y2gkS9CXPQRFJ9pO0Hpo3Ody9d8zJtJyF0drDI2rqkPCjeQnuOIABMzL4R21nL6/R+o/VKlVpUYqaAqwp1KNMtKKioG+PU+8iN5rWlFmMEti0WfFUOz/EB6QcTYuq8UtZQd8ZwvlTIGCt7Wgcf3l2rSnRus9xWwdQWvBkH5DzpU9By8qV0+SHFSuwT95PH8raQhBXxYKA/i4uRA592mbolfWCpxaU93z8wWZOH/0Ya26gw70+JEiH+YxIdCkkNYc16T6NauS05NwXje7ZYBYi6MFpMj1z9N7JqVLD0Tr563p9k7e8sBRPO7Rj4mj21Q885dirsjrQqLtP8qOiBRQS3dRod5yWp63nH1cB4A1kp3X/MI6HWFG/9Jd+0+ArWciDsiKE37bkRSGjvWiz+7gvNOS+FSVQjjjSSziDFUtc9QKtudaikw5B56Q4RdE8C3lNcX+W5dDHkMxMN2cDgp8eXGjoxzkoYcUHn/2JtbYnYVrd7vkZhBwLoTn9vp6io5rcv40
 nFXUQeJs
 bCwLMFOvs65EYGqOE3c3tsbb/mfZoT5aDYh88ZzPD7ndnJKdxthADY9oLmXFkmDh8oBHozi48wC1xW0//W3ODT73JrJRaq1XGVvm+WrLcwezpHRS0yFZGsDhmUy/gXB8X7VqGXkRoseorzQueK0sD/XmhMbhvjru8cbYbld6/FLUVvkNhdP30VYdI1vMtWlQXArD7OywPlxjYfEDI/H7Nf2UTlzH3cBInWcPzoebkLhm5dn7vhPaqeEF2Bk3TcmVEgrzgh0PCaFZZAPU2xEYRFlCrtL7kBEBeK5cn67sd/FLOhuFboofeAEhInfumux1mTzJlt3uiJ52iPkBNgquepPztkbVXKKEWYxOzZ7Jw1NfwKV14r1dCdz/uH7Q5t9s7v8afV0QsDs+O3vIzZYwTibKM8uaitmsopNLGGMwuStgmq18JSMtFNPnnnlIFcpmjU3+EUja4B2M9E8vmnH2NWPG5qkfFScPx9ZNitxwo4LJeTXHl5PZiSNkjPSNQwz+zKEdEpwspyv6BNxGVV7JsxNty1eDhDnfXkeB4U4oQSE2Q5K4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, gigantic hugepages cannot use the overcommit mechanism
(nr_overcommit_hugepages), forcing users to permanently reserve memory via
nr_hugepages even when pages might not be actively used.

The restriction was added in 2011 [1], which was before there was support
for reserving 1G hugepages at runtime.
Remove this blanket restriction on gigantic hugepage overcommit.
This will bring the same benefits to gigantic pages as hugepages:

- Memory is only taken out of regular use when actually needed
- Unused surplus pages can be returned to the system
- Better memory utilization, especially with CMA backing which can
  significantly increase the changes of hugepage allocation

Without this patch:
echo 3 > /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_overcommit_hugepages
bash: echo: write error: Invalid argument

With this patch:
echo 3 > /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_overcommit_hugepages
./mmap_hugetlb_test
Successfully allocated huge pages at address: 0x7f9d40000000

cat mmap_hugetlb_test.c
...
    unsigned long ALLOC_SIZE = 3 * (unsigned long) HUGE_PAGE_SIZE;
    addr = mmap(NULL,
                ALLOC_SIZE, // 3GB
                PROT_READ | PROT_WRITE,
                MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB | MAP_HUGE_1GB,
                -1,
                0);

    if (addr == MAP_FAILED) {
        fprintf(stderr, "mmap failed: %s\n", strerror(errno));
        return 1;
    }
    printf("Successfully allocated huge pages at address: %p\n", addr);
...

[1] https://git.zx2c4.com/linux-rng/commit/mm/hugetlb.c?id=adbe8726dc2a3805630d517270db17e3af86e526

Signed-off-by: Usama Arif <usamaarif642@gmail.com>
---
 mm/hugetlb.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index e74e41386b100..c0036c0775d75 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2243,7 +2243,7 @@ static struct folio *alloc_surplus_hugetlb_folio(struct hstate *h,
 {
 	struct folio *folio = NULL;
 
-	if (hstate_is_gigantic(h))
+	if (hstate_is_gigantic_no_runtime(h))
 		return NULL;
 
 	spin_lock_irq(&hugetlb_lock);
@@ -4305,7 +4305,7 @@ static ssize_t nr_overcommit_hugepages_store(struct kobject *kobj,
 	unsigned long input;
 	struct hstate *h = kobj_to_hstate(kobj, NULL);
 
-	if (hstate_is_gigantic(h))
+	if (hstate_is_gigantic_no_runtime(h))
 		return -EINVAL;
 
 	err = kstrtoul(buf, 10, &input);
@@ -5192,7 +5192,7 @@ static int hugetlb_overcommit_handler(const struct ctl_table *table, int write,
 
 	tmp = h->nr_overcommit_huge_pages;
 
-	if (write && hstate_is_gigantic(h))
+	if (write && hstate_is_gigantic_no_runtime(h))
 		return -EINVAL;
 
 	ret = proc_hugetlb_doulongvec_minmax(table, write, buffer, length, ppos,
-- 
2.47.3


