Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9161109024C
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 16:08:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 747D76B0534; Thu, 19 Mar 2026 12:08:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65C186B0536; Thu, 19 Mar 2026 12:08:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D5396B0537; Thu, 19 Mar 2026 12:08:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2CB1E6B0536
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 12:08:25 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E9E9F13B628
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 16:08:24 +0000 (UTC)
X-FDA: 84563294928.06.9ADEA7B
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf25.hostedemail.com (Postfix) with ESMTP id 54CF8A000E
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 16:08:23 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mVMdoZEC;
	spf=pass (imf25.hostedemail.com: domain of 3dR-8aQgKCPgofhprfsglttlqj.htrqnsz2-rrp0fhp.twl@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3dR-8aQgKCPgofhprfsglttlqj.htrqnsz2-rrp0fhp.twl@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773936503;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RKVhsGcUMXvCBqpUK2fjK2pDbP3Z82lHVn5dhCQ+Q8s=;
	b=7BpFGhIhGjhc41RYTy8Be52gu8yUh93WF68VN6OdfsWKJV2slgUwhd2+TpYDygyOhBAe0n
	09jGI766AfexLgygu4rUzzrESCvW7THR/QAmvVKQUiPNqDLEKYeeQlxvVYwh9hFQLuUBJw
	zc3m3yZaYPUGvJX+u4CoHPWXr+LBR4s=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mVMdoZEC;
	spf=pass (imf25.hostedemail.com: domain of 3dR-8aQgKCPgofhprfsglttlqj.htrqnsz2-rrp0fhp.twl@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3dR-8aQgKCPgofhprfsglttlqj.htrqnsz2-rrp0fhp.twl@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773936503; a=rsa-sha256;
	cv=none;
	b=vE54bZBA5f6No59036Hfgd1h7Cj85WkaRJRvwV9WBMwEvQD0MhgfTgpkyXI+W4BvygKN0H
	YscyfHsOJ/v5VShcCpLgcemDvhMmU4MO8+7nFHSzuauIbZlSZOMzncQbAzBSyzVF07QRDg
	o8S2tvmcaAUm0SucJh4cWRboefNayQQ=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-486fe3b9441so775675e9.3
        for <linux-mm@kvack.org>; Thu, 19 Mar 2026 09:08:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773936502; x=1774541302; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RKVhsGcUMXvCBqpUK2fjK2pDbP3Z82lHVn5dhCQ+Q8s=;
        b=mVMdoZECCKyMNmq/XsQrwlf/m06wVeRRkcJhgpZPEHkHoLmXwxVUGrFspqkA8LzXYD
         V37Yvj7W1VEmk389XsHcsTLDq+oVqHXySdA7JamyHnGgzhMDXWgqk+6LEKuTmAmKa2EQ
         57gCuELwa/zQmKWfwAW6qM7XT2KBAZNYnKFr7RFIWDNzmZcVXamWYdH/3zH9/+viBVLD
         kxg5IPgB1/ozC3Ai1aNa4Kr822z74LnrugD2KIHecAWpShawcaz6yE9migmT/GnY7IKx
         wG+9PF0UEiq3MJsSpL7jrhOUuN6y45GP72zJIw5NqeQDQzcotQlC5eovnNVcFItPxAd/
         vhHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773936502; x=1774541302;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RKVhsGcUMXvCBqpUK2fjK2pDbP3Z82lHVn5dhCQ+Q8s=;
        b=NGTOqv4uE5bGUVEvFzb4eYFCyNVDkQaIh6TW+mFYG3nvSnBTqJTGynxJ9fDJrBw+l5
         do6kI263BhiOV5L5w6jEQBLN/QL+4WMISJ4mkUAJV7Zgvuwfd+rp/+yom+WB/lYnVuhh
         eTc67v36JraNLkbzRs4YiTqzomy42Lqr7IIY+lDcLN/YunsnqEvUbNvdtW+iyDd+nwJS
         HiAbTbdfI6UAOyNj5P+oIkjkkxYkZe9DX+AdUdqzN69RQhzPogqqHxujbyv+WfEFo7U+
         n8LldqtQAnPyQElB41S+3+2pdPl5sa38BQIDwhNhPjdOYduF3Vb9QUGPkexbEvhPrxsi
         6XmA==
X-Forwarded-Encrypted: i=1; AJvYcCUk3Dv9OKw8TgcT9g4RVF0E7HPQ4GVs4aRAKsJRtnd9F7+VL3AbunydJO+5RMhiniVwR/KKIok6Uw==@kvack.org
X-Gm-Message-State: AOJu0YzeBz24qVlKAGiKeTk3RaGjnRyZwQpP1zy27FGas6xGbtVafNQ6
	VPJ3X2XG/LAtGRoACm0Z9ZW0qqoLLtktSUWOZfftD9bxteYXb2hdiXAOPdsp514/J0uw9eXovou
	yfaKEUUki04sfIw==
X-Received: from wmfv2.prod.google.com ([2002:a05:600c:15c2:b0:47e:dc0c:276f])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:8b31:b0:483:78c5:d743 with SMTP id 5b1f17b1804b1-486f4460539mr130801685e9.28.1773936501670;
 Thu, 19 Mar 2026 09:08:21 -0700 (PDT)
Date: Thu, 19 Mar 2026 16:03:25 +0000
In-Reply-To: <20260319-gfp64-v1-0-2c73b8d42b7f@google.com>
Mime-Version: 1.0
References: <20260319-gfp64-v1-0-2c73b8d42b7f@google.com>
X-Mailer: b4 0.14.3
Message-ID: <20260319-gfp64-v1-2-2c73b8d42b7f@google.com>
Subject: [PATCH 2/5] iwlegacy: 3945-mac: Use special gfp_t format specifier
From: Brendan Jackman <jackmanb@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, 
	David Rientjes <rientjes@google.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Harry Yoo <harry.yoo@oracle.com>, Hao Li <hao.li@linux.dev>, 
	Christoph Lameter <cl@gentwo.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Uladzislau Rezki <urezki@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 54CF8A000E
X-Rspamd-Server: rspam07
X-Stat-Signature: w1z68wimpzqyfr48tdkyuo5o3m9cqfba
X-Rspam-User: 
X-HE-Tag: 1773936503-754603
X-HE-Meta: U2FsdGVkX1/RbJJeyJRpBXKmiI7amMTGjaFqCDgCI2NkD/55Q7JyukdJYJxTz2pshGg8VJn/Wapbfbixo1XeU9ACU43zp456Tx/AvfssUd1iBEkAg4h+eahfnrna320tl1w7SgDs1XUZSv9G0nj+j2SVb0paFzEwzCB0epogmC7t2Hlw9CzUUuZYHRYw7j53HYGFjXlkOVNHYyShYhxEbNYzVD2jS5/khBIjPeAITaBhnUUskMCbrWnAWrest3jJUz9hhnSNnJwgmwnB1dkQni3SneYxrxvh8xyr17x3CWrFRuTl5ClERm5Z31baHP3LVQRWoNsBMtdjtMfueLo1pEhOvMmR8zCugPP6q2nEBYOBpkxi/oA8iClZkLkd3ZLjU68ABp/7aqCC8rKe4ljoZIEELGBvwEE6ko8QXbS+grvtF/vOxza056hzjzvx5iWS9zL7w2rHtJ4BrqVoifV1p1sUY1mvvlVD2BEZe6DZ7P3hOpLtQ30sW3pWPfq10wykGsHGd3DHklXSPavLGyn/kFgrk7Evlah9542fq7VLiwdKbLwpGsmuU8+kHKOZMHwW4ijn5yxQDniE0cu+8VQN/YtapWFPHvpcEi90hiKyyWJMOxFXxPDFVF9/pU8Za2yLBArerSARPTgn56qO0opaHQkoSvLirOd4EaZtspu7m5XUeP4IDwRBtfNiV4zLCJO+NvVCcROv6860rkfd4tMoBg9Ju+y0LJ3zknKlJKVJGXVCJDqJrDbCZRQJbNSh83PDYmbAfy+SoownrUpZSAjur5RLqEEcLbQYOIVmJ/++XG8LNJMNpLuLw1U0rWhs+Q06xoiRY+l/Zii8tXT3vVOefRUcdkfJDBx4SH8RHwnB/94FVs+3vJfUNcYPMWJV5NIhuG1iOVn9HmpVSQ2pI0JEtFOWR30U2r0D5BGw87oVWvFjKriKs6GlxmYgJdDe3r1moKEKOS+FFKvrjYYz7HU
 xEt/FTmO
 D/0T8oCH+GogWoNR/zKz+rTH4ET2M4ejoCbDcMut5WUi6lcJx8tzMf4T+1t3RJjesQ0vjx20yR2Pl0MYDV4stICns6kyK69iiiL7/a4RIfD7iQNtBQDWypl2Qi7CiByy3ho6VW6sVYC0fWLsDOJ2NpVU3K5HgqtOBRpVResCX1IN0RiO4QsjXIfdRiLC9fP6Jdk+d7CuY3cRJB6zfvvamgiYlbgzFS3kjWtTYDTl80B6hEi06PxShDXS1e5/dOKMkIeBuwXyA93kqTgVBvZ0j/dcIUH8bc8JU5RwpXHr78NLRBnyBq/yWmVto9ZgQ80dVlVcT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

%pGg produces nice readable output and decouples the format string from
the size of gfp_t.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 drivers/net/wireless/intel/iwlegacy/3945-mac.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlegacy/3945-mac.c b/drivers/net/wireless/intel/iwlegacy/3945-mac.c
index c148654aa9533..ced85eb7522e9 100644
--- a/drivers/net/wireless/intel/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/intel/iwlegacy/3945-mac.c
@@ -1002,9 +1002,9 @@ il3945_rx_allocate(struct il_priv *il, gfp_t priority)
 				D_INFO("Failed to allocate SKB buffer.\n");
 			if (rxq->free_count <= RX_LOW_WATERMARK &&
 			    net_ratelimit())
-				IL_ERR("Failed to allocate SKB buffer with %0x."
+				IL_ERR("Failed to allocate SKB buffer with %pGg."
 				       "Only %u free buffers remaining.\n",
-				       priority, rxq->free_count);
+				       &priority, rxq->free_count);
 			/* We don't reschedule replenish work here -- we will
 			 * call the restock method and if it still needs
 			 * more buffers it will schedule replenish */

-- 
2.51.2


