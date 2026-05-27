Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CC35CD5BC9
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 03:38:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2F126B0092; Tue, 26 May 2026 23:38:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADE716B0093; Tue, 26 May 2026 23:38:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F4FF6B0095; Tue, 26 May 2026 23:38:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8FADB6B0092
	for <linux-mm@kvack.org>; Tue, 26 May 2026 23:38:25 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2EA2EC0680
	for <linux-mm@kvack.org>; Wed, 27 May 2026 03:38:25 +0000 (UTC)
X-FDA: 84811792170.24.6DACEDF
Received: from va-1-114.ptr.blmpb.com (va-1-114.ptr.blmpb.com [209.127.230.114])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4E2364000A
	for <linux-mm@kvack.org>; Wed, 27 May 2026 03:38:23 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=DF8GYFSG;
	spf=pass (imf11.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779853103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g/rmtPD1MKrWC7BjiewTdsAoLxWW7dzbcFZmhvRKNSg=;
	b=H7PyMnaeHfVVpbFz/0cxY5PkqDH+O88aFGrYLHd6onrwwHG/TbJOxK7hUO4tZTpllm3T0i
	gmTY2rI0Si2kctJJdvlQH3+yghkE+dleFPbqtRUYjDKizaJdP9orOggH+0yTiqpuHBpSZ6
	SUbHTPbNiu4ddAKh5W4qIK2Nd7F5zks=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=DF8GYFSG;
	spf=pass (imf11.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779853103; a=rsa-sha256;
	cv=none;
	b=X6ySFDG29iCtMQwv6psu6gK0n9BGkqi+LLzWuIeB6PvQEKZMkOVFBSj7H+veRnrSvJsfK8
	gwnovTne1f/GG6AVlGKKwm8iQP2hrAgCZdCIroVucFV/jX5YFM6ZL6jl4XYv7cMPcaKKai
	imqHDlvGATVENEW2A9Skl+WFvOVzVTw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1779853098; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=g/rmtPD1MKrWC7BjiewTdsAoLxWW7dzbcFZmhvRKNSg=;
 b=DF8GYFSG36lQNp3etCvNQwV+MLzas0UlhaS4SMYJRKA8c1VEcZC5GelEe/BjyDeV6kIUgp
 g3ylYPnjU59k5bnlRI6Y23Fm+AwC4Nqr4WyBufR22nGhL2Xyd7EEZ2eRvEZoVmhVuhzEBy
 oQgMMNZJ/DEecfsd5lAm5jhnIaJi93ExDdtzMMHoGCgJMzAhaBjM1uAErui6reMmeD7KCX
 /2bamP9NYkU2rzrMNXfg1A2pe5kdu9Vj4ad9+NBfJ4Ts9zI70Exv4yKvu+l5ueiPxcuDvs
 flvvW8fx+8GEskknjZj3SaVPj8MvebD91j0T3jr/f2+egZgzPL8O07xVA6yFNQ==
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>, 
	"Li Zhe" <lizhe.67@bytedance.com>
Message-Id: <20260527033636.28231-2-lizhe.67@bytedance.com>
In-Reply-To: <20260527033636.28231-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <david@kernel.org>, 
	<kees@kernel.org>, <mingo@redhat.com>, <rppt@kernel.org>, 
	<tglx@kernel.org>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26a166728+a13d15+kvack.org+lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
From: "Li Zhe" <lizhe.67@bytedance.com>
Date: Wed, 27 May 2026 11:36:29 +0800
References: <20260527033636.28231-1-lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
Subject: [PATCH v3 1/8] mm: fix stale ZONE_DEVICE refcount comment
X-Stat-Signature: an73p9pys5ep7rj1dsknxd6zy57gkaei
X-Rspamd-Queue-Id: 4E2364000A
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779853103-896625
X-HE-Meta: U2FsdGVkX1+zb991lNUcpnHYIRmRMTa09mkgKzvrLTUX9GwSjE2dK0S4sJxuzEtzq7eKw69f79QgZvWKLRaLYoMgg2grPGhBmw11rXoOaSvCtiLlzCRFuoYEr9TtagvzEb5lgwp3A+beHkraTVpomAQk3OOr8Vj41FN9PtRCyTq+DS7BfO6+21S0FY6BRm89VlFpQ/CFUfCAH2OeVFtX74IGj0msvvkJhD3oALBGMCQuHj23UnsYi+HSJNGU7Ow2p0tIy8Z+tI2MkbiRPhqUvtmiJjGPeRIo5cUXAuj9hOtdfsPxCKjmXfJ6ypByFNaerKAQPiiRpPYmJhowBmB6mNfSOeawf5iEnjpLSx8AGy9X9mqRoUJYPOu20wQYjlyXpqo+G2H15O7/7C2DQ1Ck2EUsFb0YYLqE/onKtnazRK6aKqOmsvNw00+RnWUTXRnv2rJ33rIMsax2XK1LMYwGe30xswUqlGyLSMjqduO1FtXhQvNfCAXasrFgMXdgn6OvGT7WhGn7DO6oQIa8o5YJT0W2JpSeRD/ikD3W6gUT+gysn4gsf91d0/rzmxfMLoQahxSb1tdAf+zfyeZ2v2Z2UaMHgJXciz3/QrIS3M3+lsodj1cbrdxouIfRAAhdg9NyhfbvYfumScUjj14qAfVnMWDxZ0GcfpvNvEGvf/uKeitWWl8vnuWhWbjcfcDP3eunm6YeSah5kUIoC5rjd6XkqthI9EMbqX1Korf7x4OYjz0JAb7F9JRVyezZ7x+K8I1F8fvT860U0+lNYzGV2RohC+R6GwzYXw+H/xGgzyRuBKHKOm0qFlgcP0pb1N/HaXvwgzmdvO2tkR4Ij6VtJ3qVj4LNmT4FMlQoUXvzr8CprP0zb0w/fxbqOFatQAQMI/MLRmygpoIniOAi9lyiEhMw9lbNWGciOL2CDT0nSknUr3bPDAR+ylEQQ5//T0ZU7CdkZwjZ60OdbY7Jth9SSkD
 9YpfgzXC
 PObPzax9MMtsF3f7fkVsp0uVQStio5KNFONUeBELkcwMlgD24JOtbSQScu1NZB+5mocXQyWIPcL6Rf3QpI7hI1G1PP91escKUSxGr9tmsjBrNiWCHxW7jaoj49LKki76lKlQhubh0JaP/WoWR4d3V8wNyDsVSxazDqYZSq3Pitlr0blHvcmYeg7XkO1ACDeR35hTsDn98MWFqaHLjGmDFM7hyHC7Zkw4C25vygRKHTAKp0tTR5lGoJ1dU/zVggVrg/VylKN9VP6An7rJtIp2wDWjookdB96pRD+lKl0rc68r7+GYYAbCMCIzZqQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The comment in __init_zone_device_page() still uses the old
MEMORY_TYPE_* names and implies that FS_DAX pages regain a
refcount of 1 in the free path. That no longer matches the code.

Update the comment to describe the current policy correctly:
MEMORY_DEVICE_GENERIC pages regain a refcount of 1 in the free path,
while the remaining ZONE_DEVICE types start from 0 here and raise the
count again when the allocator or driver hands the page out.

No functional change intended.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 mm/mm_init.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index f9f8e1af921c..35de3b6a186d 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1027,13 +1027,9 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
 	}
 
 	/*
-	 * ZONE_DEVICE pages other than MEMORY_TYPE_GENERIC are released
-	 * directly to the driver page allocator which will set the page count
-	 * to 1 when allocating the page.
-	 *
-	 * MEMORY_TYPE_GENERIC and MEMORY_TYPE_FS_DAX pages automatically have
-	 * their refcount reset to one whenever they are freed (ie. after
-	 * their refcount drops to 0).
+	 * MEMORY_DEVICE_GENERIC pages regain a refcount of 1 in the free
+	 * path. The remaining ZONE_DEVICE types start from 0 here and raise
+	 * the count again when the allocator or driver hands the page out.
 	 */
 	switch (pgmap->type) {
 	case MEMORY_DEVICE_FS_DAX:
-- 
2.20.1

