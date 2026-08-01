Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2A74C5516F
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 06:58:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8D876B008A; Sat,  1 Aug 2026 02:58:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D642E6B0092; Sat,  1 Aug 2026 02:58:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2CB06B0093; Sat,  1 Aug 2026 02:58:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A01E16B008A
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 02:58:23 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 220BB8020A
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 06:58:23 +0000 (UTC)
X-FDA: 85051796886.07.491095E
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1A30C180002
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 06:58:20 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=Y0O76aZj;
	spf=pass (imf24.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.173 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785567501;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hFZDtRlmAh/lYsw1peIZwBoJQwUYUw/2AfYQGPu/NJo=;
	b=Bv1/eDkEg2xHOt8LhGI36CGs9kkAdHuEjo7az/kD08oYkJE16xrwRJ91T1Htg1LGxX1hik
	LIGewZG86GmcT3zCCZtFiMEZFFhPefyUawhukLdg9dz1xfvzDd0t6npSCXiFF8dyxEMXfB
	3rAwnaNqcJzPFmWPc5yDf8MieO2XPwc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=Y0O76aZj;
	spf=pass (imf24.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.173 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785567501;
	b=zhDXp0kz1mTQ+pqNtCMzHjNcKnML4iwsAFWPMbbVnMAVMPPbbv4hd00hCLmTTtBe4yCJA7
	tpkdZN32I22cBNVnunqxZRIPTgRNbMRjEbHwMTEAz7Uy/aH7bdjM0BQnVb+nW/PDbbUTpF
	Zn+l4TUvTSskj9zdLyw/1E+cnQE8aKo=
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-527e352a167so11387731cf.1
        for <linux-mm@kvack.org>; Fri, 31 Jul 2026 23:58:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1785567500; x=1786172300; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hFZDtRlmAh/lYsw1peIZwBoJQwUYUw/2AfYQGPu/NJo=;
        b=Y0O76aZjgO3IkXUM5vhBDfWFndWso8WjuQGdLvAdwGWQ4eTMmE7tFOVP9AH5Ms5R30
         PcP5oV2GpR1gLn+sKjZkF4up2vu1cPq9QToX8sfM6vSCMjuh0E03OoLSmJNpzzzwSFIb
         8Fc/qgiORsXclZicFDPNSfwqYdI3hheFcmnbW7iJuI7cPX1nwCL/ya5ITsd8CK+4gOOn
         ezwI5gGzoyfu4N6Mb9pzI/FB9tqEfzbqJB+vmOLQwpH6tKXCp9VDUukggui5VKrB4XrV
         m31IBIChSYayRWv/Pjo37CFTtBv5PS30JhlqfpXhlstILNAwTtrcVM69TaJ7jGzMEw4u
         U78w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785567500; x=1786172300;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hFZDtRlmAh/lYsw1peIZwBoJQwUYUw/2AfYQGPu/NJo=;
        b=TaTy4cttNglEiC266xMBlA6QlfDYRLe+FT+fsTPs1Bh8crgI4Y90H1APWW1KCjLh2I
         UA3Wd/oId4/OfLoTIIVTucUw47zfPjXuGtDMwg+87HBArE9XKkdq2bPkLKVAzw+SO531
         z4jQ8X+qoyOYBIFAB81wz+MfnVXSdge7OQUW9UB8Udk0vM72P4hNDtmWJzzikBWYyM+P
         9LmxzofwzPyKkNzZWBPBKERSH0OFbIeJvGrwULQ36f7g/8t6H4uOABxdXryegq06aOUL
         JjRRXHNPdwxn+z0R4lV0SputvGvV+BjAnJnaqLoX7RP1hqfdnNcqtgi4z34kdh/SGsO5
         yxXg==
X-Forwarded-Encrypted: i=1; AHgh+RomQdti/Rt9JN/h2AU6PKGUeqLm7lHht+YaAyole0iB22AvQnpVPT2Ri61yG/idBVhpDPu+YSG3cA==@kvack.org
X-Gm-Message-State: AOJu0Yyak2gDkAGnD85XuyVyz6P9yJHOHOa0XQgjn4JcKnNrgoNST9qr
	R0fL8t+tWbP4HCue3s+XgyNFzk6FvAMYHIlxjq+RPNZtU3ELxhkMWnsizgvusW7igRw=
X-Gm-Gg: AR+sD11kmeZ9IGGfGHNJH/PIPcba1Yq+7A+gdWcfF+O9DvCTgAeotsTgGqbld59icq3
	ol5JoommtJO+elx/1CQYaPVfb80uOia4jhLgpJHchvVMy1BAeheJztaOOu5a8TFhe2bYQU4VQD5
	9iR7qqoqwC3/JVE9HKwuFiAXyuSc2p8Egs++PhEZq95VEndO0TQvQNJrzaqTvsaA07rP+YTfLyb
	c2OmP2Yu7RgMJqeTYZ+9SRlRO0ZQ+//JgIB9GpzPJzARAlbn3Sd/8707f4cc8h9QmkTup7ORTgm
	Gd4unlVVyJCsVZWbESggmwpND7dPT9mq/M6Ktj13o5xcMN3bx2kwMq8AZPgpDNDm+YsdBdwX3+m
	Hz1sGU1gzE8i16kk2n9+DK0jLwvnYhue4M/8v0LXYhUaJZwAUM/q0HyCJa+6XzIsD0xP7meUvE3
	ZjfQlrpAYNYTaUILoYogjMAphaGEEQbq42dJH+JmuQh+zSDXNs7kqBmWUBtlaNdsp3c9KSCg==
X-Received: by 2002:a05:622a:4d04:b0:51c:1532:ae93 with SMTP id d75a77b69052e-52b567dc76bmr61225711cf.26.1785567500235;
        Fri, 31 Jul 2026 23:58:20 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-52b4eb6a862sm23462961cf.16.2026.07.31.23.58.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 23:58:19 -0700 (PDT)
Date: Sat, 1 Aug 2026 02:58:18 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	William Kucharski <william.kucharski@oracle.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 2/2] xarray: honor XA_FLAGS_ACCOUNT in
 xas_split_alloc()
Message-ID: <am2ZCpXRNS7BK1_g@cmpxchg.org>
References: <20260730-add-gfp_account-to-xas_split_alloc-v2-0-5a56c2361d85@nvidia.com>
 <20260730-add-gfp_account-to-xas_split_alloc-v2-2-5a56c2361d85@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260730-add-gfp_account-to-xas_split_alloc-v2-2-5a56c2361d85@nvidia.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 1A30C180002
X-Rspamd-Server: rspam01
X-Stat-Signature: gr6net38bqdieyb9hw6zy5quuzssssmz
X-HE-Tag: 1785567500-830709
X-HE-Meta: U2FsdGVkX1+t+7eRRwMyEnovhDp3MU3SBWkbXQ9ExPMgGT9gyE3ij7gbz65toOElYoBCQOhSpgbBh+AX5YaVOcirWtgaS+P5aPUcc6EMgN/cU1vFjaPUMrV0J+3Cott9dhEDg216EqMBl6RmlqRPtgYd3Uaj84ZjJTStzl6UmMVB+Gn8qs20rdV59jQrnrgBtJ9dvmqtC+9JY1YOypJUTWPaw7mv143AVYrIKmn2vPukUID1qscSfqEcL+eogfNv+qAfweBXErOarnoTEYvrzbaGvH0Mpz1FM+FtwHuY/lDJGZUCLCG2jefQq53VdmaaaL6e+AeDJeo7R1fwNVfNCk488FAvSO8dEvydwt+hlBsf8F6jD7i/SpA4uNmIt0qlAeW5KiWSMenxCW8/ZRXZNYSItk8J66Z46WgYKqg9oOueDwS5BjdTL+JovkvhYi1mr8c2oQTqAML07rNZK+XZhszt/E/9VflhXOlY5kx4DcjrAzX8nTfC6AiASKSbBE3gCKYfAMgw+o5XGfayOmT0FVTjwFmuloAQmz/0UhsCs4D9tNeRxUlhbr6sdvwt+nUj2n189aZf02s0L2V7OZoVrgtxBFcpoFN+scwxGkhGv6u/WiZFPrORhjZjpsmmU3GMGW27V3TEjKwLHrN4pvMyA4g4OsRSooR+VbDyV/8CycEs0r4RmqFqupVUY0aQjnr4d+Ngib6Oj+QBjaOlBJueBYuHr70iJDhvuocO83kPh/IVeMJ34AHvt1Y6XrYe7ttHJyvMiuCJRiaOPTcmUPM2vDq1AaGoMa7Nt+2OK7Hy5oX8QWe+WJVHDlyyhKilfzDLFoyOqiOxAs10ojxZEUStpUZwuKy+Y/ET/1kSdz2X9GqqjbkyN472TzMYE6SFnAmQwtAPz/tJckoKu2qWC46MoY0eXkYZnmGAFn1vFwphAqQH84dawJNvZlFx1KyntSMmECooQ3gb6k3l3ALa0mu
 JOfmnPvT
 t3rw6CT7nVvzwNukgTHv6Hu0ctKC25yMvHLdrbcWCJYgYdaWZZo+PZQtYplAUmsZCOKx/tzJc0CeohnKGYxscIUad/yAq9XnoTpL9THxdLSvnmRgX5pQuPKq76U+QEPrQmLaV3Crq3iBN8NAIuoGl1PqotzOLVDo4zwWVW9iJgjNpGpQq2/NpLRY0f0pN9AzgXUNuccGBizsYVURz3t/HpFISCW6E5c/ieUXkafudncvZQjYJZzfOVVDqPP4P7x9cxpnVMU4/Hh0kE1SHDp6REWb2QVcPl3FLMKyj/KaeV+Ft2xnhFUD/CWoDqSbAxtnm9R6Iz++o5nIuHqXDvxa5yThaZ2RdnvOubujDOJB75qa0jlKa2rC73qpLt1iqqemtKieA0H4IJZjWnCOZvfVIcC+0BxJOA2k0rKSGRbYpLVm5pxHJega/1Uq2VfB03EjF8HQ+mjfW0WUcw2sJLSvKkKpVaQ8xWB1bUM6DLR9s0nMho6G9zuk6akH6MQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 30, 2026 at 10:18:01PM -0400, Zi Yan wrote:
> XArray operations that allocate xa_nodes, such as xas_nomem() and
> xas_alloc(), add __GFP_ACCOUNT when the array has XA_FLAGS_ACCOUNT set.
> This charges the allocated memory and avoids the workingset convergence
> issue described by commit 7b785645e8f13 ("mm: fix page cache convergence
> regression").
> 
> xas_split_alloc() does not have that flag. Add it when necessary.
> 
> Fixes: 6b24ca4a1a8d4 ("mm: Use multi-index entries in the page cache")
> Signed-off-by: Zi Yan <ziy@nvidia.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

