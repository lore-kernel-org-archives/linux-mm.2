Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B0C0CA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 13:02:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D53968E0001; Tue,  2 Sep 2025 09:02:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2B586B0008; Tue,  2 Sep 2025 09:02:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C686D8E0001; Tue,  2 Sep 2025 09:02:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B77CF6B0005
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 09:02:37 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 455BA140168
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 13:02:37 +0000 (UTC)
X-FDA: 83844324354.24.BA00970
Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [80.241.56.161])
	by imf30.hostedemail.com (Postfix) with ESMTP id C046A8001A
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 13:02:34 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=LdjTe6eQ;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com;
	spf=pass (imf30.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.161 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756818155; a=rsa-sha256;
	cv=none;
	b=rzdWHJPEjNrvhB3Qv3bLTSQL9tQyc/MCa4om4cCwK2/xisJt+bqCgXGMkpe6MkczivBqIz
	IqENfBkEIHaaqc/mpft53AZrLo6B9IUfQdhG8Volcli8DtsGRmyG7IXLAntXqX39falGVj
	G+ehaz1akqA0fLO6psjo3TNukkDy0RU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=LdjTe6eQ;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com;
	spf=pass (imf30.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.161 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756818155;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wFPOiy5SLaPexjP9wqrJNssj3bczB/SHav2Qw3Gd9Hc=;
	b=FtjWcQH4kDd6kAR9atvUQyUbySYZo+uUiblG7oPpABfA+6/FctF2L5VjJzI7XyyCZ7uvXR
	LBa1TVHsIH7dkewXwhfyK8e8M0NdfV7dHcyUCINaNDpwornc2aByhkurvIAguVNIicR3Sp
	b8rq0Qft/7xHGkeGTjfX2vCLDI9pbwI=
Received: from smtp102.mailbox.org (smtp102.mailbox.org [10.196.197.102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4cGQrQ2xXhz9srN;
	Tue,  2 Sep 2025 15:02:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1756818150;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wFPOiy5SLaPexjP9wqrJNssj3bczB/SHav2Qw3Gd9Hc=;
	b=LdjTe6eQ/u+OEbOVF2aqH1cKrwUrAA+xgHssRPvaT+dh79FXdjoHji5UbdnAVZPSVPRZpZ
	ErlmF/YLUSmclpw58SsKbH5lWamMhVsALOWeAbMMzXyy3jTRfaLEqj9Qaax06kfyo3IXwd
	ibQ0Kq9VtqPWVptBVb+/IziMhlMhtADe4eYv0T8vWJ2CLvhyFYYZn6kOpxHiz1NT7/m5Ex
	JfHVPUPlRxWD99Jl0OliufXS+hW99o7Rprmmga93tOQg14SbS4fQ+l3jXjUopzuiU3b3HO
	p2aPac5RnXGsCw6rO8rAHYy8y+R39jVP5ylxCi56vqaPE2yM0lWYF23nhzS3KQ==
Message-ID: <519df8fd-b02d-4b4b-bf47-79070e3d2c9e@pankajraghav.com>
Date: Tue, 2 Sep 2025 15:02:23 +0200
MIME-Version: 1.0
Subject: Re: [PATCH] huge_memory: return -EINVAL in folio split functions when
 THP is disabled
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: David Hildenbrand <david@redhat.com>, Ryan Roberts
 <ryan.roberts@arm.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Nico Pache <npache@redhat.com>, Zi Yan <ziy@nvidia.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, willy@infradead.org, mcgrof@kernel.org,
 gost.dev@samsung.com, Pankaj Raghav <p.raghav@samsung.com>
References: <20250902084036.208921-1-kernel@pankajraghav.com>
 <qh7s3j26aac3hyzgnr2ee6byjenstxhjnlwn4qxbvz2l32ohqc@qbhdxvpnuhtp>
 <90cd5be7-cbe6-42c5-b0eb-bf9613047097@pankajraghav.com>
 <6l6f5idkqebpai6qn6n3phbnydz55typdwmvp3eexwnhk4qr54@otcgssegyqke>
Content-Language: en-US
From: Pankaj Raghav <kernel@pankajraghav.com>
In-Reply-To: <6l6f5idkqebpai6qn6n3phbnydz55typdwmvp3eexwnhk4qr54@otcgssegyqke>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: C046A8001A
X-Stat-Signature: s86wyaw5fgei1mm1f65ohbp9b57x45p8
X-HE-Tag: 1756818154-897766
X-HE-Meta: U2FsdGVkX19EwnlfFlo2Gz0837kvGyE0cyLlyl3JDJwCCEWYQ1k0ki1vmSDZ6d3CTu6xvkrYpqwnqHhmZnnahb/R1yYBtfeX+No8ceB+9PHHSgBMKl30H8BunxRCfUI0kdZa4S2Z7nz7cIeTU/RI06Y9wPjK99JtT7yDtXZtiCDMzFyXBwspg+4UTrqK8r9MtHeOWgTp/BwqYw3f5MxVZDaPeJJKQRapsihinyxTMx3uxKNDxXaotNcMmPjS9rccPgv2Kof5ppMzYSjst8M3VolcD9KOghXPFGuNyANaQLurBHNmWRVue/tFZhkwrIPKd+Esj7NDDJBzYW7syPffLqoVBfmFZ2pJVpFAHPUz2MGdwGmP+sxTlLu/gzQyy/52GxUAk5495zmp5fglH+iIY5ArAo45MZAlMFixuOJtqTN5U5DjSIDS7iQaFFkcmG+Veu2y6GByzhy0WY9Rt+rtEbNTmuNyjXWzvGj6Gi+5LiW/j7584TMkGs11WEIa/Q5Ile7bbWWV19l/VETRcLFdYhpIH1et4tkcJrafH6uiyDjaJq9wSET9QgvFQp7J5pljSXfYOPNlOaBldyAXG+wcvcpPnC83iaB4fImXWBIkWNPeXY7dOZ6JmRv8nniOiVnpmyyLpYOK59RrLyJv0E68QEx0bkoGdI946kdZRfZF6bjhAOTxsA7n5O79LPVKVm6CrwA2rps0LiO9zcaEv7e0ExfJHg9aH1PB7P7bIwzXEBt+IS0TuHHYg3j/GQEpNxg/uv4sru0C1q8np79RMNo7PQstwzsfc4D5b5lJ/viX2ekQp4lozz/t1TAk+2AmGchD2EulSHmCzQxdTw9QJ0ClHafIJx3VaPwaUk1sjOJjLLlzzXB/pHyOZ6jfOqgMShjsffRlK8WQygEN0uJb8RHsQZ0E039QK5DEWoVIQIPNNdBwZ+xQe2FdhWwx5NcbWFmjTv5YLc5/dyVhtWkACgI
 QBOfoPNh
 5Ff47libuty9XsknmO93DNdVD5e4NWdy9isao/T7drQPZdY2Ev5wkmheLbCW9JV5SlATpXL7Uoj6LOr8sP8GXwIE6gCFKFLBbb4Xd7uDRNNTbmy6HKq52y3uxFscs0nznbEnUioGKxwT9f5EQ9g876Sg+BbIzeq/NJRahtc2jmWSvBuHmpamxMGm4q59SDq8J+WaJ9zmRQaLuD/wyZry8zZXYS2Y6cKir2Vd80WB31tRzgsinlSB3RQA/MhkHzqWna2lmH2IcNh6gpWt8iwpWwVlbun815Dh+IwSIfWJSF6RMJZUQT7p8osvp8s/Ee3hnI2KcMZ8daNGKSUx3DKz5C4eEa/PIlHbW9JFId30b9GYU9IE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> I was hitting a weird stale content read error and finally ended up with this fix.
>>
>> I thought this is a self-contained patch that can already be upstream. My argument is not that this
>> should not be reachable, but returning -EINVAL will do the right thing instead of returning 0, which
>> means success.
> 
> Okay, makes sense.
> 
> In THP=y case, __folio_split() also returns -EINVAL for !large folios,
> but it is not very explicit:
> 
> 	if (new_order >= folio_order(folio))
> 		return -EINVAL;
> 
> In THP=y, we also issue warning:
> 
> 	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
> 
You mean:

VM_WARN_ON_ONCE_FOLIO(!folio_test_large(folio), folio);

> Makes sense to do the same here for THP=n. It might help to catch cases
> we do not see with THP=y, like getting non-THP large folios here.
> 

Yeah, I think that is a good idea. Something like this:

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 48c4f91c5b13..4ddf9e87db91 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -588,21 +588,29 @@ static inline int
 split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
                unsigned int new_order)
 {
+       struct folio *folio = page_folio(page);
+
+       VM_WARN_ON_ONCE_FOLIO(!folio_test_large(folio), folio);
        return -EINVAL;
 }
 static inline int split_huge_page(struct page *page)
 {
+       struct folio *folio = page_folio(page);
+
+       VM_WARN_ON_ONCE_FOLIO(!folio_test_large(folio), folio);
        return -EINVAL;
 }

 static inline int split_folio_to_list(struct folio *folio, struct list_head *list)
 {
+       VM_WARN_ON_ONCE_FOLIO(!folio_test_large(folio), folio);
        return -EINVAL;
 }

 static inline int try_folio_split(struct folio *folio, struct page *page,
                struct list_head *list)
 {
+       VM_WARN_ON_ONCE_FOLIO(!folio_test_large(folio), folio);
        return -EINVAL;
 }

--
Pankaj



