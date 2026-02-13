Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E39DEEA860
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 16:58:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D26E36B0005; Fri, 13 Feb 2026 11:58:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFEA46B0088; Fri, 13 Feb 2026 11:58:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFDE26B008A; Fri, 13 Feb 2026 11:58:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AF8FE6B0005
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 11:58:46 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0D0CE5971D
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 16:58:46 +0000 (UTC)
X-FDA: 84440042652.13.B757CB4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 51FC980005
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 16:58:44 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=fjWm5zFm;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771001924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HkHt4bwrUg+hwAU42ZEcLF5HyNKdGcOTZ97Zn0pTP/E=;
	b=4umTC3GCZ1to9y/n3yC3QRGM0iOUEqVm7wkX25T3/Y/SUwW1lBuV4A0JWmyguHF35s7oz6
	NWjZ1nMWoBoAjZLf7AizsY2hcA7QRs5la+YaToZ9waa8sAYqZYkSntAGNQjswdALelOfCo
	+5ADVbTO8V5vniCL8ZviSUbIIcez/+U=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=fjWm5zFm;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771001924; a=rsa-sha256;
	cv=none;
	b=BpjL//4EA7Ydjzpfz97+ImfmBE+jLNgjJomIAN+ajjIJ9efSdECbP0I//fPzsMmDBWNjPq
	8vMmLv99cFWMKvOVRExtyQPOIolfXvPuNfFVyKKKr/dVK8VNDhEO+ZJ+UTSx9w48IS9E90
	FD8bs+RuO3rQ3H63VSwmLbs3FF7I2Qk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CABF56001A;
	Fri, 13 Feb 2026 16:58:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E28D1C19421;
	Fri, 13 Feb 2026 16:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771001923;
	bh=r9SFGqR92Fs20HO4JolD+pt0pW/zrKMLfOUDHfwJ95M=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=fjWm5zFmBi+HFOZUFT8lO339NLFh+VE9s/5khZImm3kWAU1wgPW9lvoDfTJuXgqOT
	 uK6JswN6Ym0CLElSIPd8I6Bzjxn/nQ5B0qTUT44fW7nT4U+bXBJIdnEkB0qQiDAPrW
	 ieP/quKnqWB88KmYr7JCaR/FEO/tiwIHPnQVKgPk=
Date: Fri, 13 Feb 2026 08:58:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Arnd Bergmann <arnd@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Axel Rasmussen
 <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Arnd Bergmann
 <arnd@arndb.de>, Wei Xu <weixugc@google.com>, David Hildenbrand
 <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, Qi Zheng
 <zhengqi.arch@bytedance.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Kairui Song <kasong@tencent.com>,
 Davidlohr Bueso <dave@stgolabs.net>, Koichiro Den
 <koichiro.den@canonical.com>, Jiayuan Chen <jiayuan.chen@shopee.com>,
 Bertrand Wlodarczyk <bertrand.wlodarczyk@intel.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/vmscan: avoid false-positive -Wuninitialized warning
Message-Id: <20260213085842.0654f70a73ec05d88908ec25@linux-foundation.org>
In-Reply-To: <20260213123902.3466040-1-arnd@kernel.org>
References: <20260213123902.3466040-1-arnd@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 51FC980005
X-Stat-Signature: 3nr5tpyer444y4yzad17oecnw77sbs5g
X-Rspam-User: 
X-HE-Tag: 1771001924-671983
X-HE-Meta: U2FsdGVkX19qGfKZSXMHgKBfjrrshTFW/GdAGF6sHM0mnpHabimaQvft7YCabdnz3nj9DKa2oXc/7ekZsMSn3nEyX5a3GSdDTH6EbQpxokDCcteivanEnfIHMlX4nwF7xqpm3n2kgG2TS2kAIokk+EdXFOH65fwBJBYTpb1So8Uu68ELhhkDCCaJlENzzjuG49vCriCUtXseb66S+idGpTC35Ea8sM692f6IkOXDvMzM0D5CuksRMB47x0UTyjPQwZBBpgSsJMWwQSjqvh0tO24HJzfysSTz9t1fipE87hh1rfTjeb8G4nJ37nZ9KnWaY3yx1CfLaP+HcqeVu0fUZmFEObtC2wkovysQ2SnkYhmmcaKBU0fjAU4TjB/hC1YpnoC6H1b1GaSwECbb9FEDH+MBb65IP9OWJ7vzkyg538p0PJn0AueTSjhmIfhRGUNElnu9TxIlivQOv488/hJhsVElCxTELd5A42SRys8uDgIK3JX3mVxD4PDr9J5/ZF5IKyh0uaYqjmUMNIv6gGD+bTpbejDRJzT9VHn0GcoUaPGxUgYgrHza/3E0CvR+iIbemhfyoHwomQP8e5NfEJydX5vXdjvpknU3WrpJgmoTA8c/zPTZv+tvUElBsY56UNDyTsdWWTiRx/y9ydgyOC5uVSGg3XnKoed/ub2NeKOOrMTjMbo1DOpD20jttiDcFcpDYP1oH1OHYU+5oBzyKQCZQ/A7CuAJWtPQfXaWWw0Pkg7mD85pME1Exn6cwZxL1s9SkGl7zg00DHNbB6q8m7C3xlVDtKbfpYtZrbtnbPpp35/djUO+lWtfY56bL6dLtFquBnbkyJHTz3mhppL7Ab99pdl76Jfj8z/Z6q3D8tT5Z2/By0Bl9hSA4O38rMmxzXHVtl28tVTJowTD3iFpvkAkJthSFGG5bTuPod2yYE7QH5xM2YPN08pIJ7JmAzhtyx9yn/EM59ctlexj7MVh2fB
 EKQr87MM
 GamvQliW93hmjJ/6pmaljjoJwCe3J/l3T6fVoLX8ko7dxL9zlx5M5Lb9tbrCkrPNhEzoVieYDUU8DZdQH7bFMZCnzq0MaWXes0vRgkqlloxrvmum/FCDzaNqq7/eWa/4Ney35r6dvSzrS9Ygp20hozlZppcPQWWR1i6cd5AL2gm5rWGKQRqqefbL/VmZi3CH98vhaUY1VlZ6TWiMfk65eiGTOM21qL80u3Avw9Q9bnoqv0Nh9Ur1cvrKqgdqZEJil8N5cCRZDLz4QqD7ijAZ+Qs7VfQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 13 Feb 2026 13:38:56 +0100 Arnd Bergmann <arnd@kernel.org> wrote:

> From: Arnd Bergmann <arnd@arndb.de>
> 
> When the -fsanitize=bounds sanitizer is enabled,

Is this an option in current kernels?

> gcc-16 sometimes runs
> into a corner case in the read_ctrl_pos() pos function, where it sees
> possible undefined behavior from the 'tier' index overflowing, presumably
> in the case that this was called with a negative tier:
> 
> In function 'get_tier_idx',
>     inlined from 'isolate_folios' at mm/vmscan.c:4671:14:
> mm/vmscan.c: In function 'isolate_folios':
> mm/vmscan.c:4645:29: error: 'pv.refaulted' is used uninitialized [-Werror=uninitialized]
> 
> Part of the problem seems to be that read_ctrl_pos() has unusual calling
> conventions since commit 37a260870f2c ("mm/mglru: rework type selection")
> where passing MAX_NR_TIERS makes it accumulate all tiers but passing a
> smaller positive number makes it read a single tier instead.
> 
> Avoid this case by splitting read_ctrl_pos() into two separate helpers
> that each only do one of the two cases. This avoids the warning as far
> as I can tell, and seems a bit easier to understand to me.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> This is currently the only such warning I get from gcc-16.0.1, and
> none from any other version.
> 
> I'm not overly happy about having to work around it with a random
> code chance, but hopefully the version I ended up with makes
> sense regardless.

Seems a large change just to squish a compiler warning.  People might
prefer a simple 

-	struct ctrl_pos sp, pv;
+	struct ctrl_pos sp, pv = {};

?



