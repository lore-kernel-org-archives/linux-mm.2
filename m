Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 463ABC5DF8C
	for <linux-mm@archiver.kernel.org>; Sun, 23 Aug 2026 19:41:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01AE06B009D; Sun, 23 Aug 2026 15:41:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBE846B009F; Sun, 23 Aug 2026 15:41:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D35D86B00A0; Sun, 23 Aug 2026 15:41:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A4FE46B009D
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 15:41:18 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 20C9214032D
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 19:41:18 +0000 (UTC)
X-FDA: 85133553036.22.CCCCE91
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by imf05.hostedemail.com (Postfix) with ESMTP id 599E8100005
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 19:41:16 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="Q/cjA4Fd";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of 320yLagYKCPw02mlerksskpi.gsqpmry1-qqozego.svk@flex--wyihan.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=320yLagYKCPw02mlerksskpi.gsqpmry1-qqozego.svk@flex--wyihan.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787514076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o+OpOp2FYZHZK1eqhH9cUqizMST4EcGgJtULK4xaToU=;
	b=u36BAbv/GLrJn9ihu/+SAdYgOgkzs0WsDscrnwVGhq3i7AmnQXgSSWua6lWv7tLpPhS8cu
	ozR2Ri517FxuI2VLiUnLiIQSDgnsrKHfOFHjpDr+JDY8nz19GOlKApBw1fdm2Dvdt6Tzii
	db+j++8lpSD+zFao1RK0gFY/MwZwPdw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="Q/cjA4Fd";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of 320yLagYKCPw02mlerksskpi.gsqpmry1-qqozego.svk@flex--wyihan.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=320yLagYKCPw02mlerksskpi.gsqpmry1-qqozego.svk@flex--wyihan.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787514076;
	b=ea6ZUebzbFgPGqaw+gfgw5x6PzI4+NIPWXjNNyVZZUKxNqGQV9wshLvw1AcBL1hOwxkWed
	A8v1tPQdPSTm9I++v/Bw6on82NvXMUVFDVNTlLiPJ8jm4pekdDh8w9RBPx9MQyg0vFnQUL
	yMPikRXyGrMfgeimJuaRDUw66RId590=
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2d63bad3d09so32883195ad.3
        for <linux-mm@kvack.org>; Sun, 23 Aug 2026 12:41:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787514075; x=1788118875; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=o+OpOp2FYZHZK1eqhH9cUqizMST4EcGgJtULK4xaToU=;
        b=Q/cjA4Fd2HvNmfHUH1XrRT7TDMrPXgDo/xkBHuZ7KKFRFLA3cK4UwAU1mRS1bZDv9W
         krLbHLq3d/urxTL+Pk9e8WSmTdJWqSVhSiK0fO/c+m8JR9lRDsF9FvhysJAC/fLrZfXo
         CFSiaEbZOR4DzFEEAy3OGbS2D8644M8SlQjrj3ifou9LSKsJSSCzlFvFXMx1K5P3qTSg
         FUE2A0rG22robhrdWtcGRiMu313I9dF0XdwmqipUKkzFQ6LUqlD1i2MA66RKlzD8YjA5
         iWIr2WsnlaAibMev8gTQSyrfyNiz3FW3ikf3vISbWFbX7OjkAhtUWotr0P9NT9sJOtzS
         61qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787514075; x=1788118875;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=o+OpOp2FYZHZK1eqhH9cUqizMST4EcGgJtULK4xaToU=;
        b=EqWbHz4Uxyb3Eh8f7PaoWGyLKqtOZ+0HNVf7F0fcwJLCWPVP0epR19/rhwpgdm8/ze
         OsvpenqOKfq7vNnTylu5XW1BXS08331jyIBOgU9S7qVYyol0uPyFe+uCeY8/aIQFVOBo
         lSiXje43GZ1e9jd1y6DXVsmGHltedlb+N9fRfX2ktDfe9GmZq0kvqVbqAKrDZrxz8Uk0
         D6XwDnChrsE1GaoWcOZly2cXjXDCTRvit8foxR9P2fBzD/N+obMVmmAyHH68gza8NPsB
         w88m/nZanXeFOjykIzjM21MNColutZeHe0rNNu3+tGfC1SBmNDsccVkRsCtUdhZW7Z9Q
         a2ag==
X-Forwarded-Encrypted: i=1; AHgh+RoxVwTFJQThrUPTck5v7aS6/II38JV6IYnnLlzjkNZ0O+qtM3/JZWzZ55W0qsK6QdpQCjgHYnJELw==@kvack.org
X-Gm-Message-State: AFuF++moeOxL7sse6fyphfvvhLmeFVhzNks5DywEt2eAR9Dz9CoahKli
	oHiX+h6RA4ip1Rtx5OGH79JoYpnfi+fskHvz2dRAMxlAvwMqCPmzx/vplWbgWwpuIfwrxz2U+at
	wq6t+QQ==
X-Received: from plml14.prod.google.com ([2002:a17:903:184e:b0:2d3:7166:b1a6])
 (user=wyihan job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:3904:b0:2c7:ebfb:618f
 with SMTP id d9443c01a7336-2d670d299bdmr242569585ad.14.1787514075026; Sun, 23
 Aug 2026 12:41:15 -0700 (PDT)
Date: Sun, 23 Aug 2026 19:40:55 +0000
In-Reply-To: <20260823-memory-failure-mf-delayed-fix-v5-0-d97a5703e45a@google.com>
Mime-Version: 1.0
References: <20260823-memory-failure-mf-delayed-fix-v5-0-d97a5703e45a@google.com>
X-Developer-Key: i=wyihan@google.com; a=ed25519; pk=cRi0fKzS5BMxlHyHY2pJv3w/1zcgfYKr6EYGYppdMYc=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787514072; l=2009;
 i=wyihan@google.com; s=20260319; h=from:subject:message-id;
 bh=DG04WuEmB+N8qtRetaF/4g/eNDjDsfwar1GsdNmj7GI=; b=l3Mv9NFzVojO4X30lik/YxnXTp8odsky55GCF49Ybs0TwqNB3EpJZR4IWtMFjUh+RZrz/DSlr
 kyCzx6aZvHqDNzH3hGWJjzxiWsVRAHFhzpzByW10l57CWxucdyf1HjT
X-Mailer: b4 0.14.3
Message-ID: <20260823-memory-failure-mf-delayed-fix-v5-2-d97a5703e45a@google.com>
Subject: [PATCH v5 2/5] mm: memory_failure: Allow truncate_error_folio to
 return MF_DELAYED
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
X-Rspam-User: 
X-Rspamd-Queue-Id: 599E8100005
X-Rspamd-Server: rspam07
X-Stat-Signature: 1quygknqh4q5amzj4zmtx3qe86f6e1y3
X-HE-Tag: 1787514076-711285
X-HE-Meta: U2FsdGVkX19kw0toxDCQ4qow6b6KC4UZjRGO7aKehgX7olLLYEJTm7iH4f7hrihyMR+rjVQp7sFkhRrp9slyGsy5cFrZKoTWzSyfQHL2f9Ep/euwVosSHlNYZnHnzb17J44A9aoIuXVvUze3YHOhFn7fi4ct36+k37J7nGy9QVZaSDJwcZv/+2TUwIIBiYKCoWS7VZ74ktCRlodWrGdYOXbTo6jh6wwXAuiPG7R0R2sB+YSpsXeDWOeg0/+VQmzoBjiuYxu+4f97qe67hqCydHaHChWFAbPwCKFc0yzelQBGZdqZSiKYyeWphywmeCgkmAYdIQjaaYxDrWRPPDkshqV/4L80Q31Xjhxet6Jm5filJhOEnIQNd6QK9Yus90QzihlSyeL9LDqBK3UMQ5kwPa0UZm0H3mx2TP23GZcG6RQzq22104CEKX9Q1SssUFnLFEilQ5kz4whzqR3FN5XGRads5VQsif3SzHuxfPmmNzphJ+vMZ6eQBspjSoDTeB09oWWaISxqw9IYzwSWuZnCvGDrbCn8HN0O9vyLhbdi5V2a0VM5D0Gjw5ukbgblgq8hp+r0Q8T9ioO1Gj0zH8hVqGDrpRkm47LcjYpjfo55zyBI7ZJSmkv8rmTSYaG3ZtSBpHoB9RjraCnbvWYMkCfMslZN0PyV32xFjPmKnLoDcyHYZ5TXm0iNwxriHak540FcL1Ia1jmCOiQFMDcfCGm2o/3v89QhVcVqVhz4l4p7xs5L82JYh37M15AR/yQnSGHnouh5gKHAmCEfL0bw5lYQn5EwvxMKEboPx4DnTQdan8a/IcChoaC5Xg/8Lggg4d/wp8uCV3FBc/nlyRMBn/5WcHKkTlXbnewIgEIA9T/YVxgmF70jQ2vIsTV/JlDSrf2IFYBwJY8LjTLoJgrOaOUcLAiQE5b+lW0wnCwaenx1feB4yMOXG7SCh+jGurowZAlu1o9MqRi0L8Y73+g3ZUO
 SK1Whnk9
 MRU7z4kqVwMyag+7TGdBhmqFBcFJaruIEO+p4IWhea/vRMyuGeDJlVHcfHwCKIp/oylkTLdTVaicaGGmc1M0CZwAzzBBFkoAA0exDPyMfGsDlYn7ApPP+ScJV8pszzz7VNJ5gWh/R/q5aot/baiq5QaOHhf8jhmU2pVQnZGnNhF0yBWH237/lKiDiZWLfg6LW6n60oUxtMYLNbNXCvAHPh5wjPmLucxOIrhqtNduZEVRHHRL7glzP4XxrNVtsrULxCmRdKlnpLOW91GPawCMF0D2e5Oqk6nH/CZyWJJ7VK4uosxDGeYdZG1j7HglQtVTnJMlKB0x4TrsBTfhGDurWAy/fnP1NqC3tZz+A9JoOHGT2g7msdZCBtGgIgcv6euhjFeXQNl2OBo+Zawz8XL1nLINBeCnAsShHT/yRZ8JdRFCanJv0cyyrm3J1zxbOPEyBzYxoEkkIyLrDByEMVWiqTbHmJmj1Lu2V0pw6wTSCinV6icbg6cmqeWcQeXzzwIpjomwuINIKzxDVYVBP9pWwE5WxJ4IAdgrfdyaFojH5et84kLZtk4CzpwCGX+jwlPII62UdvgpuAJpWfeJL1T+6JeyvjXynrB8vl/EUDFCiqfJwdqZ04yGDjpqHiYYJt2jdCYFOXoeugK/1uIZ4YEt67LuHnLQW2F0LRezgorwttWxmtUgRDDAxy128bRrInTI9eIxjC6RAX6GfAwWWFnm+OGx3jg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The .error_remove_folio a_ops is used by different filesystems to handle
folio truncation upon discovery of a memory failure in the memory
associated with the given folio.

Currently, MF_DELAYED is treated as an error, causing "Failed to punch
page" to be written to the console. MF_DELAYED is then relayed to the
caller of truncate_error_folio() as MF_FAILED. This further causes
memory_failure() to return -EBUSY, which then always causes a SIGBUS.

This is also implies that regardless of whether the thread's memory
corruption kill policy is PR_MCE_KILL_EARLY or PR_MCE_KILL_LATE, a
memory failure with MF_DELAYED will always cause a SIGBUS.

Update truncate_error_folio() to return MF_DELAYED to the caller if the
.error_remove_folio() callback reports MF_DELAYED.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Ackerley Tng <ackerleytng@google.com>
Fixes: 6a46079cf57a ("HWPOISON: The high level memory error handler in the VM v7")
Fixes: a7800aa80ea4 ("KVM: Add KVM_CREATE_GUEST_MEMFD ioctl() for guest-specific backing memory")
Signed-off-by: Lisa Wang <wyihan@google.com>
---
 mm/memory-failure.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index e698d0e9711d..37ea23489b75 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -939,10 +939,12 @@ static int truncate_error_folio(struct folio *folio, unsigned long pfn,
 	if (mapping->a_ops->error_remove_folio) {
 		int err = mapping->a_ops->error_remove_folio(mapping, folio);
 
-		if (err != 0)
+		if (err == MF_DELAYED)
+			ret = err;
+		else if (err != 0)
 			pr_info("%#lx: Failed to punch page: %d\n", pfn, err);
 		else if (!filemap_release_folio(folio, GFP_NOIO))
-			pr_info("%#lx: failed to release buffers\n", pfn);
+			pr_info("%#lx: Failed to release buffers\n", pfn);
 		else
 			ret = MF_RECOVERED;
 	} else {

-- 
2.55.0.766.g2966f0265a-goog


