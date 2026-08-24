Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FCC2C5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 14:39:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29D3E6B009B; Mon, 24 Aug 2026 10:39:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24E456B009F; Mon, 24 Aug 2026 10:39:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13CD96B00A0; Mon, 24 Aug 2026 10:39:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DF7946B009B
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 10:39:20 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7B6B916017C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 14:39:20 +0000 (UTC)
X-FDA: 85136420880.09.825692E
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	by imf01.hostedemail.com (Postfix) with ESMTP id B318C40005
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 14:39:18 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="jzZ93V/E";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of hughd@google.com designates 209.85.128.173 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787582358;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2UY30k1UeQzYu1OvDSaJuzIQ8I7z52NjmS+xQ0qJeoY=;
	b=3StY36RgCkvKwh1kw2UeZq37mLno8ed+gnaXuzJ2hI0Mlm05s0dlGiNLMgiPCDCsS5/YV7
	SCxSofeP+zbrumfui/nEzYp02vDa7nwQPe3721S0x8XhY9ZpsB2hVnfdA++5U/AmFkJjgn
	GCmJsDDb+n+vxhNCXQul020AJKgUEFI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="jzZ93V/E";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of hughd@google.com designates 209.85.128.173 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787582358;
	b=eBbTMfHKfae2fjGS87iBdNa6Vcy8UqNOuk0XIcV3S4y+7qgkEwgr9xZ2plSieU3KtthGHN
	eq7Aehr/T2Mbi8r7tUvOsVHRFUTQDleWwwz2oU/YHuu7MY82hVtrcv/+rUXtbcaITvIcsA
	vlfbDNyO29WE+B5A6Is22P7b53iF4Ho=
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-836eac5682bso63495107b3.0
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 07:39:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787582358; x=1788187158; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2UY30k1UeQzYu1OvDSaJuzIQ8I7z52NjmS+xQ0qJeoY=;
        b=jzZ93V/EsgRgsyreczeo515oEKyd6wvwV/sqiaMP3l/1ozC9vQ1AsX0UVlpO+HQCqA
         sQfu/1h68yrW9FGyyHzlvMh0qDHluA1lAQuPKHO8IvWNdqtzeR4i+gCaRhjJ+mDulp5L
         XIn1oEG3HGdmRCIjZjk889n8UvFFQIeSo7fNr+FLC6sT2MUBV5VTom2lfcNyia6Z+ZLR
         Y0+VcuvwOcS0QQcnzMqMh+XZjN8DrTBCoDPJM7LdK9tfiHDdjvLy72yHhboAH+cH3JrZ
         Tef1udHlSNl+wtjf/Nn5MB+k+4fcGPkJb5SUjmq6qQc9yxGQBB0oJomSsJAFdG+OThyF
         Uw2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787582358; x=1788187158;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2UY30k1UeQzYu1OvDSaJuzIQ8I7z52NjmS+xQ0qJeoY=;
        b=meWm/NK+7Hs+usEmVWjNtxAqh0pc96sdAh4haXvN8NndVnhyxzJhCzBe4nTeV5nFit
         TjbIkSF4Ccbkgxa96YiHwHknRiMKVbJ46thN2clDhKraSfZr/Bgw9CaFI97V9udCuEhA
         K3tHyb3+zwfocDQowFDCjkjqW7W/JGWrHzD15734JnIBn8o9LGF5pY6dNfJpvblV8B8g
         EO9MlpgO6pEYlZoW455/YVD8opsSa7ZrQ6JL5e+v1JKsNvmk64tNMf9OaoarCIpaJcWK
         Of5aMTPS4pyIu+IGja+CF13I3ndx4MN1zhbM32i+IGjieMJN8Twr9lYHqENGHYzNIjPd
         ApKw==
X-Forwarded-Encrypted: i=1; AHgh+RqeoecYitRT/VV6MjYbvOpymaTLkvsfgZvwUu2zIAmzdwVFbFC3ohgDL4IweK4Dz89Td/fF3s8aVg==@kvack.org
X-Gm-Message-State: AFuF++njfyqLY0Hl45Pr2NaJ0FRbeVO1pFm9JvKoxxiWO423spVO37B7
	rdBNdDdmV5zimpLA2wWnSnRapFnhMCvG6XqtA5xYRxKRTbdqaygmJA9eQmU9fNvKrA==
X-Gm-Gg: AR+sD10eJ04/Eyrcl9XElWM8v1UEcFKNqhoDM4mIVQmCMper4YgrzgHuzN9qhxsPhnt
	uRq14HF88WgaQbImVgd/q/8BjoVpU0kT7+/jZatxzxw8SM0IIkP+x74LzZjPNBDmqM9Me/PX/mE
	Jxaw12WSQPz4f/s6y5PJkhMzKIH/9sYNk/OR8H7OcU8zrZTO+8DSwwAALUwIr2lK3K6xOLZ3qcW
	F4OFCTArUDv1jbKOeQIlZFHsECvcSvHwWIRMswijFE5SKFeJC4Qsj9BLkPkV1bK5GQNKUFhhcf4
	bKXo2q1X6nSRjb++ZJSm/IFGmS7ke00Z4E5A+5r2rpdQf533l6bXHb82norFvNh6ojr48idQ+/Y
	MxKpA7CNo3OTijlJyAjGkFYb0NA+r9eZjrceHTFiRVQhAv89GqkUOo75H0mJEFK224DOn95iUYD
	wyzrLrZrnaYYQU8NBIRXrKwMzmG6Rpfu1JxQygO5mrVmI9fxG/buyTpbSl+HeSxEwG2l7gto1i+
	HhB5vSEW/wFhGaXk2W0WGB9iQSZOowQXKGbP8Txe3kGoJW7
X-Received: by 2002:a05:690c:c221:b0:81e:a373:47ad with SMTP id 00721157ae682-847073b93fbmr133529677b3.2.1787582357182;
        Mon, 24 Aug 2026 07:39:17 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-84ca5188982sm35471097b3.10.2026.08.24.07.39.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 07:39:16 -0700 (PDT)
Date: Mon, 24 Aug 2026 07:39:12 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Ackerley Tng <ackerleytng@google.com>, 
    Alexander Viro <viro@zeniv.linux.org.uk>, 
    Baolin Wang <baolin.wang@linux.alibaba.com>, 
    Barry Song <baohua@kernel.org>, Binbin Wu <binbin.wu@linux.intel.com>, 
    Christian Brauner <brauner@kernel.org>, Christoph Hellwig <hch@lst.de>, 
    Christoph Lameter <cl@gentwo.org>, 
    Claudio Imbrenda <imbrenda@linux.ibm.com>, 
    David Hildenbrand <david@kernel.org>, JP Kobryn <jp.kobryn@linux.dev>, 
    Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>, 
    Johannes Weiner <hannes@cmpxchg.org>, Kairui Song <ryncsn@gmail.com>, 
    Kiryl Shutsemau <kas@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
    Leonardo Bras <leobras.c@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>, 
    Marcelo Tosatti <mtosatti@redhat.com>, 
    Matthew Wilcox <willy@infradead.org>, 
    Mel Gorman <mgorman@techsingularity.net>, 
    Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@suse.com>, 
    Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
    Oscar Salvador <osalvador@suse.de>, Peter Zijlstra <peterz@infradead.org>, 
    Qi Zheng <qi.zheng@linux.dev>, Rik van Riel <riel@surriel.com>, 
    Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
    Shakeel Butt <shakeel.butt@linux.dev>, 
    Suren Baghdasaryan <surenb@google.com>, 
    Vlastimil Babka <vbabka@kernel.org>, 
    Yang Shi <yang@os.amperecomputing.com>, Yu Zhao <yuzhao@google.com>, 
    Zach O'Keefe <zokeefe@google.com>, Zi Yan <ziy@nvidia.com>, 
    linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
    linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 20/25] s390/fbatch: no lru_add_drain_all() in
 s390_wiggle_split_folio()
In-Reply-To: <14a16945-529b-8bc0-ab38-3ea97e54e223@google.com>
Message-ID: <7bf68e7b-f88c-6ca9-39ab-e9fedab0c8be@google.com>
References: <14a16945-529b-8bc0-ab38-3ea97e54e223@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: ztihbi6rsh3aoktysmsr65sj7wj58g7z
X-Rspamd-Queue-Id: B318C40005
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787582358-922134
X-HE-Meta: U2FsdGVkX18SbWZpHJ06/C9tf89HfuvdoEyi0kzLYAW62l4TM+VJpnd3za7qe+fgyzeIBc0KzPKS5DtjfpEu9SjgjZ5WlP/OW+MS2npRDBWoozpzcbBIqC6VUP8OBO9CWe7XoT+ihi19YCYXXsYvGCqnrDA1DK51Z+mkglVj2HsKbuupXi6lc6yvFb/uOk+aqDv0poiGmbZuKXONjhHrfIqQEt0/j6ku+xNRdmTSWyRSabTkIJXQdxci2B95cBCTSsx8zy/hOY3Eiwb6nndhWyUfsuQVLqtDvLmmL5GLFVJSlU3hLLwmJRZFcr5bP+ICZB133yJtKc49yO0ILF8mwzq4lWF5SiKYskPKIm1/2w05empGvNOxGS/g4YJwZau+v847BIUaio3jyatc70wNACdGOjUdLS/sX4xJCKZqMlGoiMlqrf0lb2GvirdxfwuSGCsiY/LyvP+IHsfxN6M9W9tgZ37SoohI7Z42QNFRCkfi/mgfhF4Z7ElMuQm015m8l+PBGs9vJ+P+K9iT6tK5Y5h/GloICfPpGHxvgtkv51DPcz/WhQ1J0YeY4qQS9/w9mNA0C4H/wE8QDMxC99jw1dy32gQGwAU/LvYh0Ly/WFHBSqvnrA4Mbf84xtLIkOSVopHGRJuroJVVpRhe8fQFZDOh7Orbd2nNO2F397ltgbACI0s0i9PwmYnhmo8C2jXzEtmNb7OyTErsn5K3OM8metRmKtOiujn0JxV35NthsLykTv3NgyjQWaPmSxcTMBruL08faa+Te1hOPftleIL8iy5ndKGxJG2XKl4D3ZglL3NqcDJ/sFpw9NYTRi6vJvhkkpT0E2bjLLavbm46IJOToN0UhmdA+KkYOr25vGQKlFwlSSWQM7Ea1PqJB9Zgm++I+mZsEdKOCLM0ptfdgOAehjV9Bhi3uK/GjDzqHMRxkTJ8Y8aWpBwCbxMsAjqicm/+Ncz3KUtjq1BFwLVpjsG
 C3PMaJ24
 IOQoNbEeRxT+pL9q1Fh7JQWqcjXZ+aG5KJQNxdt6CbnMkF3oT5sOTyCMxg9DaP1Tgr9SJrwf4DivHK8ZK+/kqVaT7yfBKUIRGMtXmoe59iQ5S7YZlDCj21MSkWZpSIOu0Up1TkJ3QXtLGYdFbXh9aJEhKEgaXyn96Nu7iMC9Juf1lVchnwU2oCrvyiyh5iDHSEgKgjXUN2numcQvpPr5olscNRHapL//n7w8YqcpY+vFbL1tBvPMSVFWgru1IjodQbOvAdo8gCQiTcoqZx9K0oIBeeuUbRvjc8T0cTyYjd13JyNFc5t89dAdFpTfkEx97vNGSVwvnn4Dsee/r03tZlKBuMjNmX7AgEe0KA+Delv1FgEOOr/JukPIx1PiGOqp8sbwYrxJlmossW8YOSfr7vnshEnX3Zk4yb4y59tPPKmSAk+FBAIZArd5ckjZ4SUOhLPJNsd5tDtugLSWebvcwEIi+6TtxtJnPBnp7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

s390_wiggle_split_folio() has no good reason to lru_add_drain_all(),
now that the per-cpu fbatch references are gone.

Signed-off-by: Hugh Dickins <hughd@google.com>
---
 arch/s390/kernel/uv.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index dc14ebc0105b..120a467026a5 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -364,7 +364,6 @@ int s390_wiggle_split_folio(struct mm_struct *mm, struct folio *folio)
 
 	lockdep_assert_not_held(&mm->mmap_lock);
 	folio_wait_writeback(folio);
-	lru_add_drain_all();
 
 	if (!folio_test_large(folio))
 		return 0;
-- 
2.51.0


