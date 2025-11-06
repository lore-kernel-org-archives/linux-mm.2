Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B49DCCFA0D
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 03:27:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A0068E0005; Wed,  5 Nov 2025 22:27:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 650AB8E0002; Wed,  5 Nov 2025 22:27:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5665F8E0005; Wed,  5 Nov 2025 22:27:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 451708E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 22:27:12 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E6BD457E1F
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 03:27:11 +0000 (UTC)
X-FDA: 84078746262.11.28F6A1B
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf26.hostedemail.com (Postfix) with ESMTP id 12107140003
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 03:27:09 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BWkD6Vpt;
	spf=pass (imf26.hostedemail.com: domain of swarajgaikwad1925@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=swarajgaikwad1925@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762399630;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=cQbG73vR/maKnivzNekMCroa15w6TUmZKDia2GDu6EM=;
	b=RvHFr3AysYltpiAwADP+GJJsBv6hr6Ka8FgL6aHNF/c92Aey3BSrAONIaxHtEYLtgKiELx
	mSj4157eIUTgl2/UQBhLyOxMTSAUi8mFj79ahsF/pXyYGnn2W1lIZ3SniRG9oksdPIDX9n
	HUWCzTw767KxXYRf2lJlH55SaCldhb8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BWkD6Vpt;
	spf=pass (imf26.hostedemail.com: domain of swarajgaikwad1925@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=swarajgaikwad1925@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762399630; a=rsa-sha256;
	cv=none;
	b=JeLV0WtQK/+2z9qvQaGDUiLQ6HgX9Fl5k3X+OsnWG1mBXfKtVjY7fcE/JR3RFEsgeXo8Zn
	rwKNIAKP8tGen0x9iBf/3crdICZdwbr759yjjA013YaeKvymaeqzijHcGjLUVQY2e3JJqc
	d3B1HMbS9V9xGzKB1Zj82tOKZUbQaQM=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2951a817541so6552245ad.2
        for <linux-mm@kvack.org>; Wed, 05 Nov 2025 19:27:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762399629; x=1763004429; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cQbG73vR/maKnivzNekMCroa15w6TUmZKDia2GDu6EM=;
        b=BWkD6Vptqogh6Fc2/Z0jSHNIBjNJhBGGjMt00P0sLH2uGqrgGPIJZgpGqZFsHUoJDA
         bfHcpErc73apibNvSGUeMSXd5z0hwegRjTyW5m7br0pcjmBqSto4RR4fdZ4m58Oc2e5U
         RGcJJcm1XDwFcXG9m9/tAhjuJprF+57Y3bDWuuJUcm3nIwJ60LKuS6pHspWEJA+s8oiZ
         Sm0g+Fi4cpluF57feg0fxvnXOvCiOXfKU+533SIAXyCGTZy1iEnBoJuB9Ps8j68uB+hW
         TfYmHjdy9uOax2JAcYV/xC512uzYAM5/B5m2PN/ehDDhqwTIgAjzrSJpEt17iMIEdpAb
         Yxpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762399629; x=1763004429;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cQbG73vR/maKnivzNekMCroa15w6TUmZKDia2GDu6EM=;
        b=ZT0SojNaRT/G6tjKkAdyRmpI7BdNNL51DStqs5fXSum+0farZsxTFQMBN/+fpyQV1q
         cCWyv8XXUV8AsrF5cuoWeOCDsp+o065PCgzSXUdS9oMJ+1t7tUbCEDjXnWyEfRVyCKJ9
         mfY9+fmXm7Plw/TZWTlSOdwGxm8rwQNg8PQEoWvhrQnNv8xCAtD7PQFJnoI6xSbag3dT
         eaVFKD0ntal9hGyhEU6WJWahbWFc0uZ5ht4TLf+uXZwTA65mSqhzfAIzrGDUVQsTIIiC
         ZEy52Umy/C2DV5u5gnrlT2jV1NFFSMIFywclSlCCgTXwni6KtN1tywHfzzW+bi06uO9k
         J/pA==
X-Forwarded-Encrypted: i=1; AJvYcCVzqoPj5BkE/gd/rI47ckb79PMDeEruJw5mtrQZthaganfhLm6KgqAlN72sqWi5IcLWWlAPpW4ung==@kvack.org
X-Gm-Message-State: AOJu0YzFTb675oWuUra2eNxwkBvOTGomF2Ns6YcYU5mo2X0SDxvB8YOg
	GGP7drc8fYdTqVSVP7zlPrWgJa1O4A0690Me7qwtKzsQpxnoE+UMJomm
X-Gm-Gg: ASbGncvNm0MKLCIyJC4wcuaCQ9Bi2CTyrS4PnDOZtOuJ5BaxTJo9qs2iweEVWScIT9W
	DQ7AGkI//ZfQ7pioHvokrGjaOGLAL7YOjgeXMzPozJoBXkUO+lZN5Mih6wo5jzveoSBDDfu2Olr
	YfEre2LSOICraPdR/ry8ncdp2AhyVyan/9lf6JgZVZ9mqv408Oulc7maMKZFL0YqtuMslZSO1wq
	uf5XddgVhB6Wa5KlqagdzxBlc1q1wSjGxZLAK4hfmo6YcFqpyjplXMupnohZ07dPX3SUFfsPRmQ
	hwzQsAX7WgNpAPyRl8T6uwQagcUPxXGENMff0CEuEuflmWMR8CSuCs7YJnrlNLNks9x44+6f3X7
	juX52E7zIIidir6SjaKFThahMu4rRQvj5ipeNj/XN2574f31xFAbVndf61OxknSwLEN53v10VkR
	+iuIf4TCo=
X-Google-Smtp-Source: AGHT+IGvCmdntUY0Q27xoUj/FCIY7RWkXkF33HiosN+JCRvCro1pRY+CM6E9xlPE7AKejK4iJ0oWUQ==
X-Received: by 2002:a17:902:cecd:b0:269:91b2:e9d6 with SMTP id d9443c01a7336-2962adb61b9mr89349615ad.46.1762399628640;
        Wed, 05 Nov 2025 19:27:08 -0800 (PST)
Received: from LilGuy ([2409:40c2:1293:c74c:19a:68a4:cef9:246e])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-29650c5fdb5sm10538845ad.44.2025.11.05.19.27.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Nov 2025 19:27:08 -0800 (PST)
From: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>
To: Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org (open list:HUGETLB SUBSYSTEM),
	linux-kernel@vger.kernel.org (open list)
Cc: skhan@linuxfoundation.org,
	david.hunter.linux@gmail.com,
	Swaraj Gaikwad <swarajgaikwad1925@gmail.com>
Subject: [RFC] hugetlb: add memory-hotplug notifier to only allocate for online nodes
Date: Thu,  6 Nov 2025 08:56:41 +0000
Message-ID: <20251106085645.13607-1-swarajgaikwad1925@gmail.com>
X-Mailer: git-send-email 2.51.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 12107140003
X-Stat-Signature: u6qsy38fbm4dj8iddx8suagkrw7xkiax
X-Rspam-User: 
X-HE-Tag: 1762399629-785397
X-HE-Meta: U2FsdGVkX18gNHHj8M533hbii6v5oyOFYgSvyX1SvTLf00ePzfXkYmVq9KQ1mLaltRl7jxBo/kFA/NNl4IXXWP6TGd6KMKfhgyh6zBkiOEMx5dNFkTA0/Qt2r5BqxvcMgK1k01UOL8C6KFp9Y8EnTRgqNeOpl4BMQnwoVo3l01I3c4AtsKreyFwY87TJgAhThkcF5+cCACHJS9Ri2vcB2uNbB461hOBjQMG/cN001bVtqp3hUEAvwkmtCPefYfLzWYnxcSpnZcoMyc17nCgrTaBOP7JV2IA8oW4EtSiBB6PaEwzu7KSFG6LjuvtbjreUO8PEai6xb8FfyVnHoM2dP8NRKXyk3r93Lwt/CY8eXd23TWOnStwQRHaMFmRQAk9J94//I4+4SAb9eH/HxsXilgIbd2mGe2YBFddrBJCcAqCLNhGMXtblz1Ci+mNJl58O+hl2n0HPjZicmCOrosiBFgnHUjwmyGn0D3pRY8mB0fcNNTXuvVc1Ac/M/lHXBMmCq25VGnHmWv2LmxPIOTQkyqj4Rdt0AMS5/vrBzIeXPnEsrNdXmTOw270b7noIV72spYLsYkoiSyrT9khfPGG4s2og+QdHF6IFOTpVAW3ax6Wvwwng3kjXconrslOFomJEQwQVsakdaWccX02Ox23XgwK7VosyTHrhjI6I0A4wykHYlLTQqQS9BU9bJImkeFQQ5aVdiSPnpD2AhHcvvzr7YEI0OuEkBaOrnhDiLeNAv/WD3BIl5wNsf81l8BC7fJN1xY73FiYKHdzJfsROq/5rclXO3PFBPuPVyk2wR195hJg7lwSiRp8i+gUWUKZJDQmepNl+XkJu3FJUu5LxcbAf3GtyxVZT1LFDEIiEROtv9sm7pkljWdCQ/JpuLg0tXSUOEfeOGt15ELq4hhALa7DO19g++VaRPFmYqS5Od8qA9JS0rmn07IrApChGz0hUSG0va6/4uWG9HiRp8R+YnrO
 uEArdAsU
 TprzPP0MeI7/BJlzb3qb1w89d6KQAxnOKflHsxhhpsJ1vlAJEE7Zjn4ouymVa+Sw3fQX+6O2xo/3vtFKzpukSSPbCi1YvuoZFaDkn/lNE8SVdYE1EuEtSpbXJFP+DWoAbkpjUxzMf2m/KZoBLzNEjNwLqjZI75zNuvNP8ZsyfZWZYHywcnj4KdcRknPpvZNAHHwCj7HJe+xp3caPW31G42+dmaSYhqsjB7qtPzs/a/ZRhb0ZF8vmQSwlk7dgslgjHHqOQUGXewIFuh3xmiZlyOc2ty4Hm6pArtOJB/obRPajz6hFIC28M70QdhSDmNfTK8pMQUpBRTBZ+1GiaZywTqJS5GeavvE1VAUjQaj6mb9fwAjdKm1cpE5KyC8Oxd9HQ9WhK8U60bDE0hLZeQL2072SKzfT2WBHtX3v3UtKopB1FH3oCkvlLKKLhZ4CFIkfJwMtLVkNV/yfrlUoIV2qTIMxzSQGC3jbLqtNV1d3Y6XeabL+Wv1f2kyNatFoSRhJ0sekvSFra5Z4FT1zxk+hGT0FL6TqEwfQxkBgt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch is a RFC on a proposed change to the hugetlb cgroup subsystem’s
css allocation function.

The existing hugetlb_cgroup_css_alloc() uses for_each_node() to allocate
nodeinfo for all nodes, including those which are not online yet
(or never will be). This can waste considerable memory on large-node systems.
The documentation already lists this as a TODO.

Proposed Change:
    Introduce a memory hotplug notifier that listens for MEM_ONLINE
    events. When a node becomes online, we call the same allocation function
    but insted of for_each_node(),using for_each_online_node(). This means
    memory is only allocated for nodes which are online, thus reducing waste.

Feedback Requested:
    - Where in the codebase (which file or section) is it most appropriate to
      implement and register the memory hotplug notifier for this subsystem?
    - Are there best practices or patterns for handling the notifier lifecycle,
      especially for unregistering during cgroup or subsystem teardown?
    - What are the standard methods or tools to test memory hotplug scenarios
      for cgroups? Are there ways to reliably trigger node online/offline events
      in a development environment?
    - Are there existing test cases or utilities in the kernel tree that would help
      to verify correct behavior of this change?
    - Any suggestions for implementation improvements or cleaner API usage?

Thanks,
Swaraj Gaikwad <swarajgaikwad1925@gmail.com>

Signed-off-by: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>

