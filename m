Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 325FDD0D150
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 17:46:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FF9E6B0005; Wed,  7 Jan 2026 12:46:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AC956B0093; Wed,  7 Jan 2026 12:46:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B9316B0095; Wed,  7 Jan 2026 12:46:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5E1C86B0005
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 12:46:58 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 176FB1B4C1
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 17:46:58 +0000 (UTC)
X-FDA: 84305898516.15.A5A495E
Received: from mail-yx1-f50.google.com (mail-yx1-f50.google.com [74.125.224.50])
	by imf01.hostedemail.com (Postfix) with ESMTP id 276B340008
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 17:46:55 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NaHQ8qCz;
	spf=pass (imf01.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.50 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767808016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yq+hRv7j5U3La5Im0Ih8VHvIWX+RS+XOn+51KiKPnNc=;
	b=fxCZjTyiQuJyOJAoXXsdhRgmEXpuChd2xPWKZvEJE9rwyzRNeAYRuYEgBccd2FBCZLoOLC
	13vTOXCbknEzb8pG9eibox2NtCQ9x5jXwzXMwYzk+IxKOwUKUH7MyFvbwsCvJAMPKospar
	zIgMoCWBr/YgafbUMU68ofNRiUr2hoE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NaHQ8qCz;
	spf=pass (imf01.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.50 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767808016; a=rsa-sha256;
	cv=none;
	b=MnA06lYYhzsKHiYAEWjS1UNCVL5ZPJQwLLA1tGDL7WgbfOnUki/0FweOUkwt32oJfYd7KF
	06AsDiCpBJj+p98Rwzupob3NJvqSXtZhuHWv9YHz8iYwoSZ6/h+HqCfxFCB30Fsgz8IcJF
	yyxn3k5qJSHl3gFuw42HgtXJsc3o0lE=
Received: by mail-yx1-f50.google.com with SMTP id 956f58d0204a3-6467ac59e16so1865044d50.1
        for <linux-mm@kvack.org>; Wed, 07 Jan 2026 09:46:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767808015; x=1768412815; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Yq+hRv7j5U3La5Im0Ih8VHvIWX+RS+XOn+51KiKPnNc=;
        b=NaHQ8qCzgt7QRGL5m+TTq/Ukg83nI4Ec5DH4ouwmy48/1VxZWeAe8SAkSBWhOEWrwf
         Kr22KzLNLJGA9H4BkBXSJ1Vd+7bz8o28xL4UVMqwZqeBDHs00LzGxbH3EAym/SEtj7JM
         4qa/0XmJ7OsGZ7Y1a4vxaz8K5aNNZbn+wmSWpu/a6EZB9N3pFY1ZtXhXcnIH/VscYzu7
         TZcVsfzceAoCSG7Yuf3AnSqtPJk4O5pdqyrkc6HBMs9AkWJn7w4nWIZPLdKsWsy1oXoo
         pRKhEk8bvJRiPQZPL3Ex34MBBR/ITkHooC8Xm1zKyp7jkYB9JchR/HuTS/6U+8xAZy4P
         8YOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767808015; x=1768412815;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Yq+hRv7j5U3La5Im0Ih8VHvIWX+RS+XOn+51KiKPnNc=;
        b=RQLAh/tu37RRfPbDuLpLosItukQH3KlrgMbUneZCeX4i7hjO/TnXR2QT4Y8cDy/sEX
         uEgl8OGkNA52Cj40S4WfdoaFm8paL4j8M0xVghl/Fv1SSrGtTcrnA7V9uXesxJMhSJ2W
         ie1mHXJHKHatYnkqUoYWGTg9KTo6WX3c+RjJrjCGFlwDZq21UG8E65T+DPY+A17NDpwo
         FkdHNKtfE1+8UPI1V1CVD8VunAYfdd/jVWIXQ4ki/HYgGkx2DuCouoKRiJwqSCMSwVPo
         kw/VOFHhdl5SaHknHNv9vwAF3/+0PCYY75m52y4opb4M4zINlMeQsVAZtkwDbfPaVl+r
         p/RA==
X-Gm-Message-State: AOJu0Yy+NLcCo0K7x4s7Sv0Pt74Ard5rdH3CDKMk3/U50XaPtkk2noUh
	rndaq+bBb8gfsBpqUQjgXxHZpRnZ99cWESV8rfc8HgitKfWlqVayqfqO
X-Gm-Gg: AY/fxX5AQObkVwAKYTnV6RPn3yQJJxCEekrdGzrA2DMy3jxrjppeWMIgtmgoGzNRET+
	43POJUvph1adlQCUv37wM9dvnbPb/WfC1NGHNGft0Q0hB58RSIoSG1pEhcBpfq8CosJRinRAoiU
	APBRbiQ/TnhXFBO4/AgD4oHlQSQ7YDvLS/1w+OccKr8ZEmelNvyUr8ScdV4xOSQVGV0JOAIV0By
	hJDcdvtIq/wXXb6yWebtVaY13wJ5A9iPfeub7P7CuPfM5sT/MCnFaa8WbX4Bd9MkNOs8W48FpP1
	M/Tc5+L79IGwKWLGkkGFgya5nWnPLuwzQy59dQJClD/QZ+BHtW7TQzjzYK8rDhL1gTwUDQPhLUP
	0haZ3+FCAE4+VhA46Je/MLEXfUKWjbexXnI8NpxbL83TLfreTonCYz28nfqWQKwr58Y8nusZwDO
	Zml+i6qFAHN2j1D3TbIhwoKw==
X-Google-Smtp-Source: AGHT+IFKZaI963qI2lfsjYtpouBpGoUt/GmE53ZOTA+tpen6+LZ/djh9xlNgv78cZInX83vFCG3OfQ==
X-Received: by 2002:a05:690e:1248:b0:646:5127:9cde with SMTP id 956f58d0204a3-64716b392c0mr2943407d50.14.1767808014642;
        Wed, 07 Jan 2026 09:46:54 -0800 (PST)
Received: from localhost ([2a03:2880:25ff:5e::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-6470d7f7c04sm2317224d50.2.2026.01.07.09.46.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jan 2026 09:46:54 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Bing Jiao <bingjiao@google.com>
Cc: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 0/2] mm/vmscan: optimize preferred target demotion node selection
Date: Wed,  7 Jan 2026 09:46:52 -0800
Message-ID: <20260107174652.3973445-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260107072814.2324646-1-bingjiao@google.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 276B340008
X-Stat-Signature: xi4kmf6z61eyhpd5651zos4s4deutsk8
X-Rspam-User: 
X-HE-Tag: 1767808015-448459
X-HE-Meta: U2FsdGVkX18Vk9WJ1LJGKUuazyKPm6yyQXCY6Xk/Fa/65OEm5fNdGa9dmzl7mARAEOaC76yWIO7t00hmCnhPUcUmI/PbGkZ/KU+0rpne+odkc5AoTCerh5rWT0Rm0k4ErjkHBGau4wt2TbhkSfglggl0aB/kIkj0e1HvBaBhYssGY1gGc5dHbIuS1rtW1wWrZtzGBO3SfpDyvvw8aoiHtRSFhpQFKLsY7HFYIGAqjd+YDLiDmArZi+bHJ3urZ13wXZMundqkQRKKKSWJlWCWHcMrgIV9MHdkDv7mXtooOLvlI9JYs5t06SVCvwa+smaHOH6ZLbNu/5gelh2VLG2fP1OVlOBdDIoPQfOgk+4uv8bYOlZG7L2Os3nJJsQlY2EbmfiXXUpnTJ4+fLKBwbPbx1poHgh1L9x851fj9VyLD5gYcyzGneNizKfo0eaLvFG/HIv1TUeTtM1EXxoycu9X1WZZtmXnVAMUMSnpIcNPPrNBDXisP3ROAzEWcDRSKB+ohHZOzJsojotEE27f6Df9TrKcBm6oKapzVKCq2aa0RDwckipCY4bkN5MBvD3IXAJpNynZa57xmS5ITud/0ogXBPJO0h6jpbtsJl/qQ63nk1oaRb/wQii0UOwKdsUFEAIDe2/+TCB35scNrpPGIXS52sawZigAkJiqrFMXFE029Bc3UDK5XrioAtG5RJWHKNAhzrD19kPvvYpJdd6OVN65OfjKNxrniPmTxSi9yI3xCRe1/oogWCrAvTj95StBV8bPrLD1w0/Vk2/iOEczPCMLrG2LGgDPIjkS0Jt4fXqjaX0ZEcfyDJOSmdkjWtCWula7jTVFul6Ek6wUHnyv/aT1rjL0IltnhGigd65/eaHSh3lydQ470+N979xRoUAPgb39UpuneIWtUgXCqoWb03zLmzLS9o2WPHudcoaGU2er4XyFiyN1yAYgcm45byFSomnQ6jBz58+as7ffI9SkYWb
 YnF+f0z8
 SJSBKKbUVtlnyecAK/D/hCSq9ob3VzaJlTY56gVNgy0lhHFyVzwtQUlsmQRNOjpaFy4vieTuP11yxsXHpXD4K2OJJuFMvEs80n507QpITomSDxCg1aODEqwMwnEwt57aoYcZMNyMzDxXX59gHxzMNrU4p14p3xd7ypOM7zxR+p2HxEE1DofUmDwjwnmb56lc6vVLMEhNkbbuWKFSbOCMaIL5Oo22be+nXKlLEgXRSD2iyZafYCsE8fTgEnXkJ427uS4fk8Z5fUoJxqoo240poS/RbYgSIJzc8suXR6BE7RMmdttyvWTNYIFWl5REX8O2chhK3/d2Sm4Tr+Vkj4QMtIio931jSIVKpbD+YF2Dp1L5sbXjhjYTQJmq3yi9cPzpXxYOlZ3V/A0E2dd2axkYV+kWCXHdiVcgXqnpfU6D7vweJamfABtGLlhYGebXelGFe8M7uUbvplTrIx5l335irTH24+rqNtDd5yq5uWY0woApdwB7tBX8FuDW2ameCVpS4XzbCxbYg/iKg12l2bDsV3c/HGxPn59dxXiJojf7n3NsAymOSZs2RKPCMiPIbA0ncuGWk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  7 Jan 2026 07:28:12 +0000 Bing Jiao <bingjiao@google.com> wrote:

Hello Bing, thank you for your patch!

I have a few questions about the motivation about this patch.

> In tiered memory systems, the demotion aims to move cold folios to the
> far-tier nodes. To maintain system performance, the demotion target
> should ideally be the node with the shortest NUMA distance from the
> source node.
>
> However, the current implementation has two suboptimal behaviors:
> 
> 1. Unbalanced Fallback: When the primary preferred demotion node is full,
>    the allocator falls back to other nodes in a way that often skews
>    toward zones that closer to the primary preferred node rather than
>    distributing the load evenly across fallback nodes.

I definitely think this is a problem that can exist for some workloads /
machines, and I agree that there should be some mechanism to manage this
in the demotion code as well. In the context of tiered memory, it might be
the case that some far-nodes have more restrited memory bandwidth, so better
distribution of memory across those nodes definitely sounds like something
that should at least be considered (even if it might not be the sole factor).

With that said, I think adding some numbers here to motivate this change could
definitely make the argument more convincing. In particular, I don't think
I am fully convinced that doing a full random selection from the demotion
targets makes the most sense. Maybe there are a few more things to consider,
like the node's capacity, how full it is, bandwidth, etc. For instance,
weighted interleave auto-tuning makes a weighted selection based on each
node's bandwidth.

At least right now, it seems like we're consistent with how the demotion node
gets selected when the preferred node is full.

Do your changes lead to a "better" distribution of memory? And does this
distribution lead to increased performance? I think some numbers here could
help my understanding and convince others as well : -)

> 2. Suboptimal Target Selection: demote_folio_list() randomly select
>    a preferred node from the allowed mask, potentially selecting
>    a very distant node.

Following up, I think it could be helpful to have a unified story about how
demotion nodes should be selected. In particular, I'm not entirely confident
if it makes sense to have a "try on the preferred demotion target, and then
select randomly among all other nodes" story, since these have conflicting
stories of "prefer close nodes" vs "distribute demotions". To put it explicitly,
what makes the first demotion target special? Should we just select randomly
for *all* demotion targets, not just if the preferred node is full?

Sorry if it seems like I am asking too many questions, I just wanted to get
a better understanding of the motivation behind the patch.

Thank you, and I hope you have a great day!
Joshua

