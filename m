Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E928C79F87
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 12:00:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B38FF6B012E; Mon,  5 Jan 2026 07:00:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1AE16B012F; Mon,  5 Jan 2026 07:00:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9940B6B0130; Mon,  5 Jan 2026 07:00:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7F43A6B012E
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 07:00:05 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E29E9DB539
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 12:00:04 +0000 (UTC)
X-FDA: 84297766728.19.234EDB2
Received: from out203-205-221-205.mail.qq.com (out203-205-221-205.mail.qq.com [203.205.221.205])
	by imf12.hostedemail.com (Postfix) with ESMTP id A50064000C
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 12:00:01 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=ij48lTOs;
	spf=pass (imf12.hostedemail.com: domain of realwujing@qq.com designates 203.205.221.205 as permitted sender) smtp.mailfrom=realwujing@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767614403;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZHsshIjfSqIMQ3XoA6Iibo5+CynohV16uWOFfEhVjRs=;
	b=bHzDf3X+QhhJRLe458m9BCp+ZpS7L2/w6Wqo2U+7xjNffzPJp0A5/yoQzF/KPlZhOTpd/V
	8A3E7JdmIC2EyP4gcVS9VMUy8Y6AheTzatAmPc5L6kGDC7hVk5gHNGnQnkJLdNtr6cXXj5
	VSuUJrsG/j9FGePFnSmw98MFojGfMoE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=ij48lTOs;
	spf=pass (imf12.hostedemail.com: domain of realwujing@qq.com designates 203.205.221.205 as permitted sender) smtp.mailfrom=realwujing@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767614403; a=rsa-sha256;
	cv=none;
	b=GeUPwX3Y5pW4TjRb3723wu95QnMNgrZdVjr4Zjd9joXTRcHSunBWYVuZB20ta4HEsBiXCv
	CIO+drtEHlN1Plel827kBqOKIWfqlT/S/oRNMUy1RCEvkhxkYd5TedOMKIQnRG70QiC4e5
	EOHekxFnU6clXkX1vQD3hpCxl1i4h6k=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1767614392; bh=ZHsshIjfSqIMQ3XoA6Iibo5+CynohV16uWOFfEhVjRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ij48lTOsLKkblyVAztR2FaTuDAuzHsgwF2l7dnWSCk/WxTWOaG1zRgSJ8yofWkP85
	 AaNx4FSlmsm5UeYHuaPrHF57FCaGWPBlmJ+hJc7BWK54yZLTs3jv1wBCsqjwIuwNNB
	 8m8Eweb+6QTi6ftjipWKshFZS1tQZcONmGQH1LHo=
Received: from localhost.localdomain ([61.144.111.35])
	by newxmesmtplogicsvrszb51-1.qq.com (NewEsmtp) with SMTP
	id EF0A8E12; Mon, 05 Jan 2026 19:59:48 +0800
X-QQ-mid: xmsmtpt1767614388trjnbkar0
Message-ID: <tencent_DEB3B993C801A1D507C53976DEA7F6940D05@qq.com>
X-QQ-XMAILINFO: MMwjR1C73eIsPqlrovuwgOgybZRKqow9kNg5BmWF6S7qErNMeqkWu6+VQi28Lv
	 saIyjhbPxM6h4565rvqFl5HQLwuLy0ksvN5/jAk482wP0tf9Sub35FQBgMM7yZmodOpFReXHD0o2
	 u3TpfoOsY+mBedwitU7SouVYxpP9o0HPySkHPzZ80ZVz2BA9/MbYwkgDXsYaUMaCv1NBwNDLIm0s
	 IHWPTaxj7g1w4XGUQx3v0hK/1Y0P517UuqegKUTOSDxE4mGf3SDE9ArfThcJ0T74HaG/8c+EAjj4
	 ekh1Of2iguFcfWIfkWgGC6Xp4Ng8+uQUQOTtif9wZK53gYd0xjYOiy/6vSWpliRH6K/0rHLcpoo9
	 dlbChG0Xs88QmmKiffGx5pYGFIR4kxbi1glMjjy6tNWsOCutgRm34cmHIrNinhvsIhUXs9reDBuJ
	 9qBBUt+0sEUorbyy39MCslk7KKCoJkKvGsG9IlKngzQzwdVo5f1hw63wvYfc1vtG9lFtZ8w5EQlX
	 TBF27PDY28MDKQH7sNr/kDuA9AnRt/iQu9TeofyJluGTffgOGu6JyXfBtW7D1F3w+YEwNXfgV5yo
	 knUhcF2KcjtgLEnt0s0hAPTSsrFqjae0CdP/pPmY78PeqcD5XkgcJXtlXOA0TJXmGtCL9ZCpa2k8
	 ybI38GZSN4JcZVMA5hFDQhnrWnlhjZHVKRELVdigIx8lCROMez9lnpHqmRHhMXTsho3hdCj3aKdT
	 E0NXqEXavO5DBAZVxMLUOJ6aVgAPAQW/t9kEWbWwDa3GfSzmLr/8LUal6O1xVBxH3ISHfpuiXhbu
	 2kUu7rZmoPBIvOADuJDalWeBb3FeUbo6h/JQkHUMrJFy4hJOUtjLsBBWy9QHekp8qCL0rdscWUhA
	 y7GKzAADF5M0zSbV3/Tlw8HFfzJMDt46ZaWvl6YbYdcm6W/qGZY9FAvaNoe2ez4np7GiCAJtF+Uy
	 HWRMDmHktJ76ClJ+75Ca85zHMwG+wJfpovxjETvyAptaEEEpHfv5JGqSCoMtNfb2Vo7vcTLKyfIG
	 L5TFhtiQIV1F6ZhtBffoeD7dLBlMmo7yvn0IT+Zg+tGYiwmCNF
X-QQ-XMRINFO: OD9hHCdaPRBwH5bRRRw8tsiH4UAatJqXfg==
From: wujing <realwujing@qq.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>,
	Lance Yang <lance.yang@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	Qiliang Yuan <yuanql9@chinatelecom.cn>,
	wujing <realwujing@qq.com>
Subject: [PATCH v3 0/1] mm/page_alloc: dynamic watermark boosting
Date: Mon,  5 Jan 2026 19:59:42 +0800
X-OQ-MSGID: <20260105115943.1361645-1-realwujing@qq.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <tencent_C5AD9528AAB1853E24A7DC98A19D700E3808@qq.com>
References: <tencent_C5AD9528AAB1853E24A7DC98A19D700E3808@qq.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A50064000C
X-Stat-Signature: mpxa9guqds4zb9pifp3e318zjapkyew8
X-HE-Tag: 1767614401-988296
X-HE-Meta: U2FsdGVkX18DvDsXBaxB3cu9tuSn1eltEEc3GQY0aNprd4A+r+XkjsAmsXeEqkXLg9xgLHZsy3NSAVKyTgtdrhzvGTa78cX1l5PWqXMLr7vjzqYC3m9T6E5K2mKnka96N/Xi3wQZthxZ2Z+9im8qSt5XXXot3UMliW+B+XuOhBnytkj5YIw42r9f35iQD6/OA++Hgp6TF/lv33l9gFotSxchCEuZoEePUUAb+H0EQN8he+OhW+XqLTiZbjz4NHVrKvz/UvKemPhTbf0tiJbg79mXt15nLBu0JDcrtLUNQGY6SSu8Wq9yEmRa0P9sqbxwZOei6r/OXp4Q+Gd8+kUjZB7YUQteQS8vASQ65NcO1lvrTwhq3KY4i+iWOmP/S+2gQ/Qr4h8TzaWjoLE+3eyBgsKG4d0WJxvHQ1NP0TI1AQa5QyX21SwI5rUMCZPOFk0Hr0W+fRRPUAgh7p5HfEpPwFc9ZIPwerUgD+kDfjFRNeAVFYY8FZilUj+JQAx/l04jkmcXLaGIMLRbsm8GGqMbg/+dzaZC0tfthORWfwZMNQAqgLwliOvr+Zbq1b3BqupCWmia4ZjnVcdpEcHd/9lCeWjQAx+qUfuteaUEJrqW/1KeS5yPULuXxKC8Bfiv6evm6d/QdVUzuVCfqeTWVNtgvIZHGp0dFohkdrrdXam0DhRd65fRvtwxAJA0gfXJYc0+uY5FW3W2f/jReP2kTRMZ3pPjlYs4GiNmCq+CP2rdRKvOJNBvDSQZ00InYOiWxMMcG62DUpTk28eCOjGAgJKg34HqEiSKnrBzByptqnBpk+8S9nM1sI0cWiohNnT2Rlos0BYOQqk8kovyo8gflpawPuFPV6o4yZaQMwEl1RPrF7tkOmP2AdWBFYoXSLL4sIvkNt554OizOQCP3dFp744PtUu9TWDYBrlC5sg/zTHCCp9fAJFUlN9l2/xRTFBhbx/TzoxROsvtUW0Yk4RIe2y
 KOF2XHKb
 TcQlD7vmFKxrB8ZhPBfeC7/gSU1PW1Kg+k0zW49377AufwRDPAPt1fnQmmxapmxPWXamv7oMwsh27+ZjyENkqEaB/lc56KlKKmwtvbrl5FPWiNft4ue28QelWyEU2zm3wazaVfJ1LD5bPSX7AIBrVYf10ckxIccTEnF/H6eQdh+bXYez2MR924mOWhskRz0rzf7oDNu4iTKxj40OyJx4Lobihq/dvCh9TRlXIRHJoT7JJIcR/CP8cXtaAvJkijwOG3B38gxh1J+Nb1NAKuPWXIbpcaZxnUCJBMpgd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is v3 of the auto-tuning patch, addressing feedback from Vlastimil Babka,
Andrew Morton, and Matthew Wilcox.

Major shift in v3:
Following Vlastimil's suggestion, this version abandons the direct modification
of min_free_kbytes. Instead, it leverages the existing watermark_boost
infrastructure. This approach is more idiomatic as it:
- Avoids conflicts with administrative sysctl settings.
- Only affects specific zones experiencing pressure.
- Utilizes standard kswapd logic for natural decay after reclamation.

Responses to Vlastimil Babka's feedback:
> "Were they really packet drops observed? AFAIK the receive is deferred to non-irq 
> context if those atomic allocations fail, it shouldn't mean a drop."
In our high-concurrency production environment, we observed that while the 
network stack tries to defer processing, persistent GFP_ATOMIC failures 
eventually lead to NIC-level drops due to RX buffer exhaustion.

> "As for the implementation I'd rather not be changing min_free_kbytes directly... 
> We already have watermark_boost to dynamically change watermarks"
Agreed and implemented in v3.

Changes in v3:
- Replaced min_free_kbytes modification with watermark_boost calls.
- Removed all complex decay/persistence logic from v2, relying on kswapd's 
  standard behavior.
- Maintained the 10-second debounce mechanism.
- Engaged netdev@ community as requested by Andrew Morton.

Thanks for the thoughtful reviews!

wujing (1):
  mm/page_alloc: auto-tune watermarks on atomic allocation failure

 mm/page_alloc.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

-- 
2.39.5


