Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E0EFEF99FF
	for <linux-mm@archiver.kernel.org>; Sat, 14 Feb 2026 08:06:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5E4D6B0005; Sat, 14 Feb 2026 03:06:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A15B46B0088; Sat, 14 Feb 2026 03:06:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 941F16B008A; Sat, 14 Feb 2026 03:06:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 819836B0005
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 03:06:30 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ADA815B035
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 08:06:29 +0000 (UTC)
X-FDA: 84442330098.25.036396C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0753C120007
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 08:06:27 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RiqnQ0Yw;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771056388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2YziY45ZIETh1B/5AgrUx9l5mRr0pOb7diz8bzU5+Ks=;
	b=wPUNc2gjGILnKLDXwcI+PaYQvGlXBVewbq5n4xV97+UaaPSSm8mi45QMQ1aEt7twSIUInq
	qec51lp7a/+4jauRjtN9sCRqNcZzT1L1vhDzqDA60XXlnJmLugdewPLP6t1BSX2ffzuAp3
	ek462IB/PcJNRwJXMv5icsSne1ugiPA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RiqnQ0Yw;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771056388; a=rsa-sha256;
	cv=none;
	b=aFJ61071hHhkrTJ3KBTe5CJROmVhouWOvql8cJ+oap/WLrRgDE1p/aWHN9egA7NuizKJ38
	4V8P0f3mpbu7iDO3qDo2XCyP9JqrE7oR1maYnBnA0+9IMnwDsbqJtKyX6bJpphLm4+KlQc
	SisL9QfSAekodb/+4VuwiJXAOxxyRCo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 16B1440377;
	Sat, 14 Feb 2026 08:06:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A3D1C19421;
	Sat, 14 Feb 2026 08:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771056387;
	bh=fdgtcRtwikKxnqnTtahBc6VNdcurB3e7aq8Qt62VdnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RiqnQ0YwbFCmi/UgGdKaC5NuHtK4q4fmvHnp6zwfakKnIrTXKPn2h1x6z8dFWKyLb
	 PEt7yimS//1tDzC6x3kpVkTQfk/yUAh8L92tzn3AbRDRcCfsuPqw5acK7RMu+cj5Eo
	 Dy8FlD5IDH7FUXYEoV2dghFKJxwfHIEHU5weAfcxKLOw9xm1CB3GfFeYRiaKP8ggkU
	 arF2YL7/7hqPfLy2pQu6c8uxy31g2LOFrLEgheR/Lev9YbysToxBPv8oytFYEajUYG
	 S9k6Mqamqns9rBP2+cewdf54gI006+24Zef53jzpiTixwES9gzV11Oj+vtFXbSWK8c
	 qGnfjy+qqYDOA==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Cui Chao <cuichao1753@phytium.com.cn>
Cc: Mike Rapoport <rppt@kernel.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Wang Yinfeng <wangyinfeng@phytium.com.cn>,
	dan.j.williams@intel.com,
	Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>,
	Gregory Price <gourry@gourry.net>,
	David Hildenbrand <david@kernel.org>,
	linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	qemu-devel@nongnu.org
Subject: Re: [PATCH v4 0/1] Identify the accurate NUMA ID of CFMW
Date: Sat, 14 Feb 2026 10:06:07 +0200
Message-ID: <177105633005.4117909.8876622423781862717.b4-ty@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260213060347.2389818-1-cuichao1753@phytium.com.cn>
References: <20260213060347.2389818-1-cuichao1753@phytium.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0753C120007
X-Stat-Signature: n5ofkqdp4njuofemrwjdofmdo4h5y81u
X-Rspam-User: 
X-HE-Tag: 1771056387-804391
X-HE-Meta: U2FsdGVkX1+YRH4mw8HQ4FRYnHWlLLv8iyhtZiiRZcXxoU0F8EyN91UD6KT+9z5xGK2oTkkASUe6TOJr8UmYvFcEAnH4P9Q9OxLeeeWju8vsMfbdOJagIabWAT2JO50ChQ/xEXparsyFe91WxA+frxJR4qTZ+0NB1lHhbwQmGVhmXwK/JFv/ebEzaiZ6RxOWHZVTa+ewEDtHQABdQac+wBKw2Qs9kBYXLjHm9YyLySdkaJVLBZGGjDUHsobh//teLG+Ax+q3ajHOSVZ6yc6hjSdREGtKl8eYCPHauNOlhayVfBVgmA6sGJHn2zALzewlKMbBetT4Yb9CE2tHxv9/w1OH8akUYGzYbcZcXnPINCT9Cdxiq2Ikjv5eMndTU8mC869yeIVzM3BMAUKFiHbbDHMKhmpduEZKivDHC8IcP8cEww8O1gPFzs5r1a1ZVBE9TY8Nx+bBy94096ZQSbsBmqOD4K2t64S8z78hyTUO1NOOYgrk6iidSUPP/vx0bPwaG9AX8pPi7ezA6zAGkIowBV6++zL7wQ+ZXYlKLlFVxRmrG+LWcXc+9s+lkr28hIwj3DP7vbM3f/NLaObPehCydQy2gfJRz/s4to82kGjg9Dys4lob7rgYpG/AOxj+8gLRFTgavLBhGpm4oLCiCmEJ270e24Sbax/l7MrBUjW5GUayNtzXHYoAU87LN1cy0KNCm5fnh/T0aEMLh/pw0quS4ZcDVkNOQfXQRqsQc4xkAuUxMNvKcnYiG5yH6ulrsOL3MxIyN2ioKnxe3k8/xUP36u510OEYTTd4C7Il/ngyAdiy1Ytbe9QcOb1Xmer7BgZj+hrAvH/CrtkxPxW8QFCKrI+pXY0iN8mCOiKC1aQkhHjn/gf2AfvPsk1yuMv0GzEdFs9zrF6RNbQzJkuJn8inaRNn3PqsF09lClzgtGXr0G35To2Fmgz9zxlKBdBrA/BpZTij1l3wExnVIoYULWe
 dbG1IvRI
 ExNw2+XGE9YaSv0XJIf/G0SIiUsRxF6B7kZUaxesGUwMp6IfxQA+g3O+EWvvd/OtX7YIsnHGG0UqybjbbnygoM+sDXy5LXP/kPGwO+qsixTqQl4Eebroxhb2yarjJcSQ3j+AeD1+S9NXUj9GL4GCsoUqabqeAr21kBM2fSbRLJs01KYE9RoetisjjsnWOnjFL27PJe1IbuDUosYXELBWQakpwCX2Vk4sJNW+HhU+wuqN2HAsA4quedaZfuw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 13 Feb 2026 14:03:46 +0800, Cui Chao wrote:
> Changes in v4:
> - Condensed the impact description in changelog.
> - Added Gregory's Reviewed-by tag.
> - Added Dan's Reviewed-by tag.
> - Added Cc: <stable@vger.kernel.org> tag
> 
> Cui Chao (1):
>   mm: numa_memblks: Identify the accurate NUMA ID of CFMW
> 
> [...]

Applied to fixes branch of memblock.git tree, thanks!

[1/1] mm: numa_memblks: Identify the accurate NUMA ID of CFMW
      commit: f043a93fff9e3e3e648b6525483f59104b0819fa

tree: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock
branch: fixes

--
Sincerely yours,
Mike.


