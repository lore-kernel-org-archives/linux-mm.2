Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56C28CD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 14:38:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE4AF6B00A1; Mon, 11 May 2026 10:38:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBBCC6B00A2; Mon, 11 May 2026 10:38:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD1D06B00A3; Mon, 11 May 2026 10:38:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9CE846B00A1
	for <linux-mm@kvack.org>; Mon, 11 May 2026 10:38:33 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4B7071A014F
	for <linux-mm@kvack.org>; Mon, 11 May 2026 14:38:33 +0000 (UTC)
X-FDA: 84755394906.14.D9ED6E9
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5D4BA1C000D
	for <linux-mm@kvack.org>; Mon, 11 May 2026 14:38:26 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=KiYXOBa8;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.54 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778510306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S32WkBUcsCq+2TVwPDdcG58PySfbGwHzVesMedOyaEc=;
	b=n95DQbxFNTWF5iksef0JSAN0clMnVmMl7pnT3+lBvDEHtiD1jCgQ0SDfVIYnAdWcIdcd4I
	bd3Gw4JiOIMNvXlpSeYxBo+VqpnWjso0ewcYXXTqAQ0BzGm5DAXNXRs4PGvlsbxJbumb8W
	LdtxYbqOXfdhy3RBmRXZ2abTRbuvIwk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=KiYXOBa8;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.54 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778510306; a=rsa-sha256;
	cv=none;
	b=zCJ9VPZkhVP/M7kdJGFMvejPcqSG6N9I8RTgSb7eIrbGOo5BcxtGMzvWciFJSh00m78K8U
	bPk80AEiO7PW6ZZuhu3zWDob77t5n9kwT1Xcods8cYCJJw5RHhATDdYm4MF0AeL5FYJ3ht
	9Z5bBqnv7JuS7N2iKtrP5RG7Jz4rdjo=
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-8acb09ddbf6so70039686d6.2
        for <linux-mm@kvack.org>; Mon, 11 May 2026 07:38:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1778510305; x=1779115105; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=S32WkBUcsCq+2TVwPDdcG58PySfbGwHzVesMedOyaEc=;
        b=KiYXOBa8w92SMfUw1hoX4xA2+eBLWKdJB8MmnI4cbjQDpRlgGDijrUm+pDWDmmrKTx
         kvvm1hOFPet4n/Xvl2U6ll+uNnmZPfoKuJ0sG9r7/BaJKCW4TtFfGwtkef4zvKJO+MAZ
         OocTUgf0fy1Wqa3W5ZK7vg4V54DA1jd7mgFIVfINCwaP5pum7j7cQKv/UmLVrSM8nkxK
         H3oxV+Pg1edfzBDADwRGFSBGcXAK9wQw8T+TZMrHNF44aLWaBoW9u4keGlvcPUcJ+Rrr
         NkgunT2KU7dZ7q5nJVilfMtsiEq3xgq+H4gHu57+01XXgq8CpA7QwQPg3IzkI/qi1z9B
         C3Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778510305; x=1779115105;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S32WkBUcsCq+2TVwPDdcG58PySfbGwHzVesMedOyaEc=;
        b=rgFudwskt9Ep9e+a1DR0pQW1pMLkB3Rz1qGo9wIZkoPoMnuhqTulxxHGsTottO6Kqy
         L1AxLD60Ds3UfSAYi69yPeBDQrHLtgza3hcDKIQR01BKp1HqWEDwX+Ub5a0yFJFFUR4l
         kqgDtT3dFmgUfIhob6CiBZkWXMcHO81OYjRrudLhZiHpGYmaU8Em19+A09c2fnYQuETn
         oX1cUYWTypmdEeUYy1yRj2obQZBKqDGJsF50SOrXPg6S8jmajLJLfc7NisniZNlWFJnb
         v57FZ+Qh07epqeFnigi7Q0kMRZ0YOmC0CWTXfvYuvzl+skAfy9w1UCXM0wsdgiSLFQTQ
         WlWw==
X-Forwarded-Encrypted: i=1; AFNElJ/NYZd6Go4TbND6Kr5P9j7oWB1XtEXRokBCR5YwsvCGtSEE0UwRzzvjDBi0P0Nvv63Z+ZInCYTp/g==@kvack.org
X-Gm-Message-State: AOJu0Yw3mhHDQ7s1rcDsfE4VvkNCQY/pp9oKMtEui93Y83l9xsWyZMxL
	VArxfqz+TcJiScJr0FaNV1z0U01JYWtaPo822xehsBrZ77TvJYJ/h/cUiTdd3Ck7pjA=
X-Gm-Gg: Acq92OFpB/QgWncQefj4O7COObsRIS+VpDTCNRhvQsJkq2VagpxT492g8YDKbm7eArG
	1aU1aeUc6OfAX/yDtEaj+XTwYuvfRrKPpzVdzslihP9HiwodtnQFoaanL9PnQsAjeswlBE8SUFE
	9fwl+QUFmq8mNYstBN6JAiHrfIL9CMQy2bhY1Oa5xmZpjRlvECCb2wO5/CAlqV/IMS9rFphBLrB
	Yrfv6UAox9gdlAJQxN9hYySKUkZ4R5E7jrjRAgm4NtNzwKSmNFbqX4dHvQ8oRiedPrbfnKSt3V/
	eiFXqN9zGmvrgjDBvc0HVRCNnvbNtZiNeCtdhPi3Y01ygXAtBl97ygCeEEjZ4Uygw6jnoWtfO5o
	evwwfRuzIyWnB0mh6Wvu7OI8MnPMwvNBWV4pxt60C1bW5KVezMH2KLcMt6NrhnzH+3yYfsqKT5d
	16whZQAgPZzfSyPb3yza/YUR6s6UkiK9UEkyGIOnc00HGB7Pv2wUNkGV3fzBWSf7phQNWOiZGJz
	QH4ZKjxVJRG
X-Received: by 2002:a05:6214:226d:b0:899:fd80:f79f with SMTP id 6a1803df08f44-8bc44f85b34mr359940486d6.23.1778510305293;
        Mon, 11 May 2026 07:38:25 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-100-36-248-188.washdc.fios.verizon.net. [100.36.248.188])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8bf3a33f723sm95071336d6.24.2026.05.11.07.38.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 07:38:24 -0700 (PDT)
Date: Mon, 11 May 2026 10:38:22 -0400
From: Gregory Price <gourry@gourry.net>
To: Bharata B Rao <bharata@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Jonathan.Cameron@huawei.com,
	dave.hansen@intel.com, mgorman@techsingularity.net,
	mingo@redhat.com, peterz@infradead.org, raghavendra.kt@amd.com,
	riel@surriel.com, rientjes@google.com, sj@kernel.org,
	weixugc@google.com, willy@infradead.org,
	ying.huang@linux.alibaba.com, ziy@nvidia.com, dave@stgolabs.net,
	nifan.cxl@gmail.com, xuezhengchu@huawei.com, yiannis@zptcorp.com,
	david@kernel.org, byungchul@sk.com, kinseyho@google.com,
	joshua.hahnjy@gmail.com, yuanchu@google.com, balbirs@nvidia.com,
	alok.rathore@samsung.com, shivankg@amd.com, donettom@linux.ibm.com
Subject: Re: [PATCH v7 0/7] mm: Hot page tracking and promotion infrastructure
Message-ID: <agHp3ltvUba92LZr@gourry-fedora-PF4VCD3F>
References: <20260504060924.344313-1-bharata@amd.com>
 <5110e313-8c1e-4f73-b77f-68d20c2046c8@amd.com>
 <20260508181812.d2ab17b08529f17b330e157c@linux-foundation.org>
 <893081eb-d747-458d-b6c6-86fb04bdd5b9@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <893081eb-d747-458d-b6c6-86fb04bdd5b9@amd.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 5D4BA1C000D
X-Rspamd-Server: rspam06
X-Stat-Signature: uukb6u9sefx71mn8j8akymwxckdra836
X-HE-Tag: 1778510306-32529
X-HE-Meta: U2FsdGVkX1/2pXlm6NLo6LRdSGz+Wqt0E0YpVoId+erflRMfitWnhBB/zy9gQYthJ5CK6fhXFkPAmBe5H/yScAIyD1b6J2Va7i0JR+vWMVA0j6pjRpaNnJEBBSbLz/hGxkVPxDtBcXOt6e9zrr2D/q1RzfFzT9jqwR/twSq60UukfStxSoKH6+6DbRuezLn4Y8USQ8ZA5U8t+26UKq04FkDZetS1MuSkS9oQIiPZmRsWNP69Lh+MIIW94c1RDCyhEApUUyeSpZ+OpDvpx2VZPmAMDuYJU1DjfE2Y1HI6ZjI3PDfV2BXJIwiNBXA+5ojutZ45qqJg4r9sRB7o0Josf7JJ2C7AThYKt0Pog5d9ukuuOgsGv43jqMEVC/mPHY8OtdOJ9rzF1akozPK3+iI2Og4mF55b/JRIZH55v1svtbUlGXjhJZ1W2LhX1N6FJ2D54c1Vc3vVfv3S2qITmpAtP5ytTZwrnrgwzSBJIa8PzkUzSlO0dZQKXwgraIsNwwZgSLCVAgxK+G08+SnrjWo14KzL+6EHlF4WNqIsa4Cplhe39wMpNpIuMy1U88c+tU685uJoaTU5t+ur+A7sTpC8x+M+s1vHco/lQ2L3ayMiFSgcmY1VUnkyCvlo6QZszt0nBiYZWMAqi255UEfupkyWG+nK6eHZ5uBVRf17fi1+kS/VRMW70SA9QSerR8Srq8NFcItmVAEWU9GPyya501pJNU2AZ7+ra7ucWmz2tR1F6HdKacdQiCp+zUFEIyLPEFvxBJp0lh6YTtQWbnUPxLLDBv3frldlEbrwz9qzh4LyeIf7Uxij7P7TJkgjOnXpwHVAy2Iwe+f07EhnJmTGMyN+lYwtPv1aj4FiC/1U0x3xnPOgCFOm4TuMYXloh9+QvZHFPy1Juw3wWp1o6TEC337+M4YOBwL3ZStIykP6RTjL0hyT8gb2cae69p+UE3kK0Pn/hGkcwSAujycSfgDmDaC
 6NNnDjr4
 SsRzzdBDBYGpqZXH+9VEF2vU9qG5XzvbBbwXhRxM6TYLCmOt4fv2bvauZ8iHGXCqHE5lT6L8/48C1bSjLOuI6sL+cqXPJs8H2PCglRHHSFq+xZVPuumpYs9j0UgNshr01U9Cwny5XIOmFXdDLVvQGD7A7eFxB9lNm+j4q6ayblxTowrImUxJbzIeCBP9ji71pjiCYHAuNO7Y12833nZfeAq7Fsa0o7WkavKtRmEoFsa1VZJjDoGBW2QmWEmKaXX9BD8xq+Yy4GwGAPTqs2PCTW0R4j43gtB0OCWbHd2LWGiHKxb74KkyDcptLlNh0nsMzCrawAQOydvzy5yZ3mKkjQpqGUmIKN5hF3u1LE+xnZiBL2MgLjmGLTh2M5ys9Hjq1v15wEcyuIz8FiuDebT2eVA2smChDp4PZs7XzRxLqRNCSDh/SUy72SrJyWEnVr9m4ng+7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 04:07:16PM +0530, Bharata B Rao wrote:
> 
> The entire point of this patchset is not just about improving the performance.
> It is mainly about adding a new dedicated infrastructure for detecting and
> promoting hot pages. It is about having a subsystem that can act as a single
> source of truth page hotness in the kernel. Though we aren't there yet, we have
> started by having a minimal infrastructure that centralizes the hot page
> promotion and associated heuristics that currently sits in scheduler so that the
> same can be used with other page hotness sources as well.
> 

The goal of hotness tracking in general is to improve performance.

The goal of PGHot should be a reasonable baseline for the kernel to
course-correct LRU inversions across tiers over time, because LRU
threads only scan invidiual nodes and don't compare across nodes.

I would hazard against trying to wholesale state it "Shall be the single
source of truth", as we will inevitably discover some condition which is
not covered / cannot be captured / we will simply get it wrong.

Plus, intuitively, counter-balancing LRU/MGLRU aging is probably as good
good as we can get without having to inject per-workload information
into the system - at which point the users should use DAMON.

~Gregory

