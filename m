Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4AF9C79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 09:14:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 629AA6B009F; Mon,  7 Sep 2026 05:14:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DA916B00A0; Mon,  7 Sep 2026 05:14:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EFA76B00A3; Mon,  7 Sep 2026 05:14:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2F4C96B009F
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 05:14:09 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7DBC51C2694
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 09:14:08 +0000 (UTC)
X-FDA: 85186404576.12.7B26A82
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf22.hostedemail.com (Postfix) with ESMTP id E5410C0009
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 09:14:04 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	spf=pass (imf22.hostedemail.com: domain of shikemeng@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=shikemeng@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788772446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=0edxMoAFrJJSGDy4MEbK/NNYicxiq975Wc+z/y6EsG8=;
	b=m0BcYtJ4ZiytRJl3NXgtfRNcMgGhviGZ23XnSksZd+f54D5/YixIazfHRF99ExY4Ju1lYO
	WGPPd5M+cbpV62HSqUEwSohuqkqEb5OKWR8wTiikOrg8blHWFutsbR7tmXxLiyfNCybIxL
	hEEM8Sh4azH3C0MteCCpb5CMXCliM3s=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of shikemeng@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=shikemeng@huaweicloud.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788772446;
	b=YTeYXPxnaYZIL/JMUnzgimU+AtHPC7DiacKIkHrcqHKhPIwiUdcrnnmyS6eG6RjBntG7EV
	4Zkz6szeUTAHM/VPqLpaJW8GNXHstGV8p0U3YQ1eqjcHspKxEFtDBIlu+nlMxQmdO82MR+
	NPOvFzROgzebgax7qFw8MCtwnPL9TGA=
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4hdhDr3BfBzKHPQ1
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 17:13:00 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 69FB140561
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 17:14:00 +0800 (CST)
Received: from huaweicloud.com (unknown [10.166.163.161])
	by APP3 (Coremail) with UTF8SMTPA id _Ch0CgCnZbNWgJ5qMElGBA--.7816S2;
	Mon, 07 Sep 2026 17:14:00 +0800 (CST)
From: Kemeng Shi <shikemeng@huaweicloud.com>
To: akpm@linux-foundation.org,
	chrisl@kernel.org,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Kemeng Shi <shikemeng@huaweicloud.com>
Subject: [PATCH v3 0/4] mm, swap: some random fixes and cleanups
Date: Mon,  7 Sep 2026 17:13:52 +0800
Message-Id: <20260907091356.53026-1-shikemeng@huaweicloud.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgCnZbNWgJ5qMElGBA--.7816S2
X-Coremail-Antispam: 1UD129KBjvdXoWrtr4Dtry7Zr4rtrWDXryUtrb_yoW3KFc_GF
	W0yas5JrWjqFy7GFWUKrn5JryrGFWqkF10gF1Sqr4ftr1xXw4fXF9rGay5Zr1fWw48J3Z5
	Ar4DXr1rAwnrGjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbcAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_
	Cr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
	0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
	jxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr
	1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v26r1q
	6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI
	0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y
	0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxV
	WUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1l
	IxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjfUonmRUUUUU
X-CM-SenderInfo: 5vklyvpphqwq5kxd4v5lfo033gof0z/
X-Stat-Signature: epwkz4dbix6o4dzffy1h4q1e5rnhg7ee
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E5410C0009
X-Rspam-User: 
X-HE-Tag: 1788772444-435436
X-HE-Meta: U2FsdGVkX1/jIgAqYVYgmTIOO7BKbq28t7+EcriNXnWDI2CxmIeZbP57N5CN/jD+tnhoCjKZS9L7LlRYIotdE25E+32GGl3n+L5JRspI6my0k46pHfUbPYRcUfsBOrpcVD2z2C9+yuTat+nFhiDnBqqhxmYg7yPmZ2rG+1ZpF4UfUbkQdO1/Op2j3cYvqac16xe0isbWi5XzhVdCu++Vaks0Aj4liPgxGD53q147vkRF02FG65xABwaoLINNcjGwBimC0dcYyTu46/nhzeAp/jAKIBTd4nT6pbWlQvI9Cp5d9M6OTWMzlBulzNZd938pG+ovsXNHFdDFOk4zCKPiFHqreISRRYfhp12TFcxVpHwuST6QbYNTzm/PTNFxnqfvY9/js8e/qIEHWwcazzoeFHXfYGLlsywj54qojBecypDSygcYPoRX8aggWwSCHFfNQMiAyHfZiOotibZ75YFmjl7C34bcI1II9Gl/XgKkS/AH0fof069HcNQhPDy5H8jIVJnKzJFY4hPqgM7sLezM3Z7ty8/WOCnoj/Q2TCAVXE3pL7lyOjn3GKkbXErk/063FWRMAO+6zjdMyeIAD3aOSqpm7BhmoYFLCyj2azc1K+yIF6Ko0sG/VSm6UiIioQG2HdFU573Bx7raf5HMSgvagMacMDEg8gYs5c5G7sREk1Ts/dKRtRhkdq3MbDJTn4OWOGgRQaVKXjfIB7Q7RXeH9RehKWvmyeWdOL+z8BI8l31blNcEqGdUbIpuQbx+hQb7H2iiN0/8tsiOG8fhUUIRu9/amm4Uw5BTZI2yPG72bF5YMBgk6CzbYmRr2flhoOsXFGfn+8q+el4KrirmEnV8D7nblqBtQYFfhFssEb1Qah9+PEcGXX2Sd5F2jyB++tfu7n0WNTD4kN6Gr5sqS9Cu3Que06lh8y21Q0m8ut6UYHnPHbTe+9LXWFVad0VdbOI3kUe7rpKWcho/k7CNONO
 c6657Wt4
 58SaxCi9+s7IbNy+qv9m27QVpMUEBLg4UW4o5XSV5Y9KRfQRf98v302Eb6IJjxwygcgl5EXNqtm0QnZw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello all,

This series contains some random fixes and cleanups. More details
can be found in respective patches.

Thanks!

v1->v2:
- Collect RVB from Youngjun nad Youngjun
- Some minor improvements
v2->v3:
- Address memleak problem in patch 1
- Add description of current memory order guarantee in patch 1
- Collect Ack-by from Kairui


Kemeng Shi (4):
  mm, swap: Fix potential NULL dereference when trying a sleep table
    allocation
  mm, swap: Move setup_swap_clusters_info() after SWP_SOLIDSTATE
    initialization
  mm, swap: return early from swap_extend_table_try_free() on first
    non-zero entry
  mm, swap: Remove unneeded swap_extend_table_try_free() in
    swap_dup_entries_cluster()

 mm/swapfile.c | 53 ++++++++++++++++++++++++++++++---------------------
 1 file changed, 31 insertions(+), 22 deletions(-)

-- 
2.36.1


