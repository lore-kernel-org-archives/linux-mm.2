Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B239DC624D6
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 02:58:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A33686B0099; Wed,  2 Sep 2026 22:58:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 996436B009D; Wed,  2 Sep 2026 22:58:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 885936B009E; Wed,  2 Sep 2026 22:58:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 63BC36B0099
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 22:58:40 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F0D431403FF
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 02:58:39 +0000 (UTC)
X-FDA: 85170943158.10.6964FDA
Received: from va-1-112.ptr.blmpb.com (va-1-112.ptr.blmpb.com [209.127.230.112])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7794340005
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 02:58:37 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=IFFgYTGw;
	spf=pass (imf04.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788404318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3XGVvSOTCEh6IL41/waks8FQqdiqvKYj9ft+LeKmDH0=;
	b=7ojNswMKbqinbxPVIAFSbZgfS3cGTXiBgeNvYWskPJylA7tZyw5kXzyVX68RYeRLwtENrj
	TheYjariaZSDAQQvvp08ugcXMnSemUT8k6Q2gB2yy+4wByP9SewRMTz+X8fmfT2Tl3mx6a
	8dvwD7dwnQh//J0t5qnkOQJB/aePOLU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788404318;
	b=FDOH7MpWlghyw5GX8+h7mjKXns8spmGcOsbyDLknvDVKmNRinTbN3p0CoEF+GU1mG8SAzc
	tEbQg89Ilq+W4V6wzLV3jfcGyFjpAMnzT4WZdic+Pz14sddUeA5F2HTURY0w0IedzPl7Jy
	PJw2BOvTGz5Ml6JOw7sfyphj+G7iMZ4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=IFFgYTGw;
	spf=pass (imf04.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1788404312; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=3XGVvSOTCEh6IL41/waks8FQqdiqvKYj9ft+LeKmDH0=;
 b=IFFgYTGw5DYv/kcaykFZ8cfkcZ3MA4nRQi+7W2wfmS3xIX1EPmMTc+van106O0uN7AL60Z
 6Og310N6vMdxR9Ik/euR5Xvph6qSJjBKA513TgW8S3ks/zBlBNFQZ9OI9fPyIlNiU8hb5J
 2TeqD5bDIogY8uK2RvSpYxYZj/2WfQuSc1XZQwZHuOheg4dI6QjFJ1vfs4Ad8HMvJm91ad
 tnm+2iFX5JWA2tj/2h27NZjBurCiwDUltq9Q6sWmEdFyQBY2ReczeTkjdFYJsE5S1DTH0t
 rQdAz8ETV2qd9z6TEPS8mrV6/gM88OPFjqqI9R+XMczmKJcg5VvlQeLex3HQCg==
Content-Type: text/plain; charset=UTF-8
Message-Id: <20260903025806.70825-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
Mime-Version: 1.0
References: <apejDEdW95T-tekb@kernel.org>
X-Lms-Return-Path: <lba+26a98e256+60ff96+kvack.org+lizhe.67@bytedance.com>
Subject: Re: [PATCH v11 3/7] mm: add a template-based fast path for zone-device page init
Date: Thu,  3 Sep 2026 10:58:06 +0800
To: <rppt@kernel.org>, <akpm@linux-foundation.org>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
In-Reply-To: <apejDEdW95T-tekb@kernel.org>
Content-Transfer-Encoding: 7bit
Cc: <apopple@nvidia.com>, <arnd@arndb.de>, <balbirs@nvidia.com>, 
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <david@kernel.org>, 
	<kees@kernel.org>, <linux-arch@vger.kernel.org>, 
	<linux-hardening@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>, <lizhe.67@bytedance.com>, <mingo@redhat.com>, 
	<muchun.song@linux.dev>, <tglx@kernel.org>, <x86@kernel.org>
From: "Li Zhe" <lizhe.67@bytedance.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7794340005
X-Stat-Signature: u3zj31aper7hycnkn9mu7ba6bj8k5o41
X-HE-Tag: 1788404317-484416
X-HE-Meta: U2FsdGVkX1/TdNl9roi2CfxwwLStd0gGvYYrtNm3qyrNn4bu5nrvnooSeTnrZQqcktYAe5++sSt59CTriITgfk2wc20suzwIBXYrBgG2U4vhjz629beCb0acS0ZLjghVHKtqhupbNN6TcoadYP4JcrsklOlxwssKE1sZRXeXCrFv220bjdq0g7wPRI1bfegtUbCtJQK74Dfk6A269/QNI0T0NLcJ174GfFdKP/kM1ozjwXj/jd7abXUT0LTIMjQ66TBsGQcPcCn1NyWCbjpWLPOr62DptT47ODB+RJICI8QM2cxhstJcEpXxYoqwBsj2puLeYdQH9dIIYXvTspDPdr/q/V2EgCgrRZXEBnWmD9Ai+31iwKS/mg9DL0zZKpzik0ZWM4wPf/9Me7dS2KKQciHVc7bzQKBgkSA4IW0DYkMqRyLHLBAx3CTTSfkz6/Cprmoa8P2GS5WhDau5og/HgnHer710+5yv/SRKsMWQ/U2jek5XzpGlf5NzG54PrzWz9HdIGFmWUEKeerNCZrV0ugVbtJrZelbdt1PngYdpsMhJHnamRE25mwWZ3wV0fSv8LD7eTmH1YKX69bHxt/dNFSQgbkRLdTTEJZv9O0wPUPGPl+SFL2BZBc1ZWGOVlhTkf/SHNwLGE+2VozXGA5enFVM9XgmEBXjmul7WA3baPNdHv4dGoi7iOGvgQP4SjU2n9Y/YwwyIDLD5V19/Z2aeyOCpRliPtySpNHmO27HvTllEbS5dW4lSP19qqKrO9AcxXGIzgSOVyLO/VpRuFor5b+UtuSJWUvWsdJSgWAlE1ecS8uFa8vRWF/C3DQlx9rT4AXOOoQfKL43XibUrCBHT1PPhkKb066NkiGPvLIJ0Uv0X/kYf7KPDUfS66cglm4c5sQmIJTKfxfUDO/+D43PYWeS88mGLHTXVEysrZ8SegFfJQO8JFDYxKIAiG7On4lhWt78hGtoozmN2faqoOaM
 nOv0Bedo
 VD2Dw9cmhliC+lnfDeOc2m8Gs/xbsywstih90q+q/eQdBkdK1gCYXTp1BkD4c4Ry4BqQ5oF/nF4azj/YeHh7GJ+hqGBNNta0pqrMSQobZGXvqgWjDmck0Vo89gawI13HmSsfmKWBBoWtkUGzTRR97PRo54kffPtsuYWv7EGxcfuC6uXOvOAVVUE4K3rxaKOWZPnGRVU4fzX/czVKYsNrQU3UNJKUOm4sKtHgBri+7CImKoleSs/AnJzhMrFfqe9fPsNZo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 2 Sep 2026 07:16:12 +0300, <rppt@kernel.org> wrote:

> > +	/* Initialize the remaining head pages from template. */
> > +	for (; pfn < end_pfn; pfn += pfns_per_compound) {
> > +		page = pfn_to_page(pfn);
> > +
> > +		zone_device_page_init_from_template(page, pfn,
> > +						    &template);
> 
> Nit: this seems to fit into 80-chars line without wrapping.

Hi Mike,

Thanks for the review. Yes, this fits on one line.

Hi Andrew, could you please squash the following fixup into patch 3?

---
diff --git a/mm/mm_init.c b/mm/mm_init.c
index ba4148de2b28..84fe53633e44 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1127,8 +1127,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
 	for (; pfn < end_pfn; pfn += pfns_per_compound) {
 		page = pfn_to_page(pfn);
 
-		zone_device_page_init_from_template(page, pfn,
-						    &template);
+		zone_device_page_init_from_template(page, pfn, &template);
 
 		if (IS_ALIGNED(pfn, PAGES_PER_SECTION))
 			cond_resched();
---

Thanks,
Zhe

