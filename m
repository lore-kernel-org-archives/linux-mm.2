Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EA84606A323
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 07:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=dIN9T7VO
Received: by kanga.kvack.org (Postfix)
	id 6A6B96B05BD; Sat, 14 Nov 2026 02:35:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67EED6B05D6; Sat, 14 Nov 2026 02:35:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 595486B05E6; Sat, 14 Nov 2026 02:35:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 346716B05BD
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 02:35:47 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B1637140377
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 07:35:46 +0000 (UTC)
X-FDA: 85432915092.05.256D79F
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	by imf21.hostedemail.com (Postfix) with ESMTP id DA8C71C0004
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 07:35:44 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=dIN9T7VO;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.176 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794641745;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cahiVRSoQzf74nfMrEDmS6N07dyHDuJ9YLLjX1noXVU=;
	b=r9Wk4u5EfA9bDFUM06lYEMEfM6dSpE10qRfstnHjneVlHTUU0isDz3Swl5b194bVJHF0cR
	APb0TjE6nZfvFBnoL37mDyg2uAcss5bJQ8sL+T4IplVkLX2JCiUUUjufBePWH38/GUEcqc
	YOvSZe3izQfqu+fF/ZbVJpxttqSDoEo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794641745;
	b=VjJa1a0qsab0ZB756NIxaE0TXCbmkFZWkmICC0J0AqMlFgJdYsskhBT865HacS6rnN9Ltf
	IgHnXH3rq3xWYzf4Mg/n0veCzUo2SN2z0/+d0ws8++HrFNthZukgiPGmkhS8Cvz5u8AYI7
	2y4S1tmgoSU5TSV5KbzBOUk2zmSHIRw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=dIN9T7VO;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.176 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-93f2f2edb19so226567385a.0
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 23:35:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794641744; x=1795246544; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=cahiVRSoQzf74nfMrEDmS6N07dyHDuJ9YLLjX1noXVU=;
        b=dIN9T7VOvA77Kxi9l/pbbgVNeG0DyQpoi3DR+e3JQFZXs+fU2+B8WvONqivUP7rSTi
         /9DEYfSa+UL4t2DE/sGwYQFPnFXMNaFe5f8CLlDliYmpopDz52r67cSC6apKi2OCceaZ
         UZsKzEiGt0ck5OjycahDW93dZO3I1VptXdYqgnv7/wiyfECq1eBefFwZNIPTZ+GYaNpr
         L3MQQcwDxcgSkcsxhy6Yl3zbUnjHRLu7nvckJlFIhjCPwdZaBMXb827CLFjYIeSoic29
         J+Mp+wSCiSynr0Krlw6K56/snzLS3R5iZVeh+irbDyxLdAhHshhQI95HbmNg3cZC5oQS
         rHUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794641744; x=1795246544;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cahiVRSoQzf74nfMrEDmS6N07dyHDuJ9YLLjX1noXVU=;
        b=uzd1NgO3+egENXK0ToMJp//50+222kR0ofFdV+HabnUJXy9KIWZdwDcgDVs8z8spL0
         9Lycr9dEpufmilRXLMXyaTFpWfqbRZbzL6HaWpyGil8CEgXBU09jaFCmKsbvHc6QrZZY
         fKgz3qlK4fSCdnlKIvHFsFazrvZh4SZ1kwjFgTWBWB0RjUHHFRoROF0WwhFMlzBg9WnW
         tkIVeaS08L6xszA6VFTI342+/3pQvsleKJ4m4LIQZBdTXlFKXAm9iv8jvomxPV3+ZrE1
         E2/MiK0AtgjJd2okjpajS+QQ7tGFzSyL1g+3bTAkg6Kn/byq1BRUtRv2Tif0lVYlSxPd
         iySw==
X-Forwarded-Encrypted: i=1; AL+hErG5cUA+pe1BWXcVZF1N1vFtZvpDS+/Y20Oovy1E2Za6yDeTX8VFhMsFle+HSZgFa2ersMIPnOXVtw==@kvack.org
X-Gm-Message-State: APuU4Z82hw3nTL6OadgSel6RAlQLo89emTvachP7b7fvw01PY+hmIKHT
	HPAy3gA07w1cl/keXMEHady6tXdGAirfQ4+TOWVgwu9gIMM83vghckt1Vsago1W0MD8=
X-Gm-Gg: AYBFou1KI4yvgxd/EmawM1YK+bC50t3CETi9+9sFw47RDGgRdSCQtn+QNj4oDfKCg8Y
	GLoZkOwm1a+n1fMyhIqMpfg4lAj5LP02Nj5OTdOQFWB2NXELTpan473JkLcNY8f8WiBxkaAKjAd
	LCtWwBSL6HUg7becoDT8R92NonIIz9ggmVl8B6i66bYZv69C27kS2CvGBlKHOknk1ySYz68OOBI
	Ob8Wf2VuIT95hDgXhZLlr7qayPQon9qqgZz8Rn9Y4YjqivEa2g3EA2Ur6rN9R0yXKj+kB2sMKXT
	0QIb+nwKY6q22NuHiuQo1Glxln0gE4UhFmajl4umw4KCQw17bxtPkEOcR82ZJlozMYyyXXUIBv9
	qNzE/sdyw09r2E+fS02sX3pNsZOgdmcUCtcYQrjHkCjLtTwfGcGOOYC5Z3uIT6fCB3Q0uUXYD90
	eWST7D2fHxL6D0/EgBgN2zYMh0aJsETVGNznw+S97XooFNEdZFoqqo0p9vS+HT1/zd/A9vGLDSl
	IEyripKvmjGz+cVF0lPBWolWDMeZjcSPJgej7wcfNIn7Y98Zct7drtNJvz1NoVDGP7pK9bPVAG3
	PSPnOtdSwnw8aGGWWstFMSWkZUZxPmWtkboBqDhnTb8lbfEfrqmZaUh9yWa0fugsCciULIG46vl
	r5SGSPNc=
X-Received: by 2002:a05:620a:a00c:b0:949:6193:acc5 with SMTP id af79cd13be357-9496193b1f6mr334016685a.74.1794641743958;
        Fri, 13 Nov 2026 23:35:43 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9494c803ad1sm357502785a.12.2026.11.13.23.35.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 23:35:43 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 10/22] mm/khugepaged: restrict collapse to common
 memory
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: sashiko-reviews@lists.linux.dev
Cc: "Gregory Price (Meta)" <gourry@gourry.net>, linux-mm@kvack.org, 
 kernel-team@meta.com, linux-serial@vger.kernel.org, damon@lists.linux.dev, 
 linux-cxl@vger.kernel.org, akpm@linux-foundation.org, david@kernel.org, 
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
 mhocko@suse.com, corbet@lwn.net, skhan@linuxfoundation.org, 
 rdunlap@infradead.org, gregkh@linuxfoundation.org, rafael@kernel.org, 
 dakr@kernel.org, johan@kernel.org, jirislaby@kernel.org, kasong@tencent.com, 
 qi.zheng@linux.dev, shakeel.butt@linux.dev, baohua@kernel.org, 
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
 baoquan.he@linux.dev, baolin.wang@linux.alibaba.com, yury.norov@gmail.com, 
 linux@rasmusvillemoes.dk, pavel@kernel.org, lenb@kernel.org, 
 hannes@cmpxchg.org, brendan.jackman@linux.dev, ziy@nvidia.com, 
 sj@kernel.org, muchun.song@linux.dev, osalvador@suse.de, 
 nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com, 
 lance.yang@linux.dev, usama.arif@linux.dev, kas@kernel.org, 
 xu.xin@linux.dev, chengming.zhou@linux.dev, joshua.hahnjy@gmail.com, 
 rakie.kim@sk.com, ying.huang@linux.alibaba.com, matthew.brost@intel.com, 
 byungchul@sk.com, apopple@nvidia.com, rientjes@google.com
In-Reply-To: <sashiko-outbox-214261@kernel.org>
References: <20261114070959.3490008-1-gourry@gourry.net>
 <20261114070959.3490008-11-gourry@gourry.net>
 <sashiko-outbox-214261@kernel.org>
Date: Sat, 14 Nov 2026 02:35:42 -0500
Message-Id: <179464174225.482102.14033958474429517565.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Stat-Signature: anb4456utwz4efoydsdjkjkwyeoi9t3k
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DA8C71C0004
X-HE-Tag: 1794641744-960483
X-HE-Meta: U2FsdGVkX1/tCSaQrSk1as47efLyPkqG3Ucojx3RajzkjPWQuTPm7xybLlh0F73nHWkT+9mLOdZHil0okYGdxLV2lZHJavPCnJvhjbK5LvDEi9w/bO8iE786gqW+Rmc2EggSYawaLxPDGFCGcqwv3s7q/nxPAZ7eG6g/edvX3uqFQ0kwmKfGvX6VhoHfp85lQkXp4oHPzRdF7hgRR5Yu/2valjsPnzr9+N/7miRwd7vrK8Ot+I/ggTnQZlNoBj371qHtoSjJnu8W7yTgzKiHwAlhO9I1WopJcfezJcnSGexn2JPlWYo9MQMaX9OWPkrlN+xVyhz2eF9QZDamizz+X5V0ykUeTar6CIGLG+udrPQWmRNFcY8BwjS/gHYI69reW/KCdrkGdwAET3yllkzYFGE/hMF8mYUmmW9xXa0OLMDPFV+qXIoDRHR8beMnQa1dCNaccC7aMHziRH1w+hxGjLNdbeJlundFj5G7oyUw60nTNKUisaQ2het/Brt8/WNT5mycIMVsNsdGOlqK2UEB4Tt3Dno0CcLWnIvMYaY5cJrJxd4HGnDXtee1XnVAcn1uK2O2DXjZ5ySPd1vXelqcc8nq/OgGAMWrXxXVhCqREszsf5FWzuMFA++4yfdcre6dYjRaNZRsrSsQsmuwWhPFbHyJB+7Szk1+jhkFpVK1Sh8s0+1JBv1xQD28ae0LbBW3ITxGIBM8VMsne6CTg+WBe95662sRRN8A+/QhSo4VEXTrKLmg9HQKvZE/t/QzhjjfbTR3R1PNyPcEkk0pUbL5DSBi2hhY9rwkycKZ0M1ZlPofXH/759f76Yh6CVfZnL36Xm8w5Hvn3oIonEm4SWKyLDxst89iMONbbUNd1kPdDRs8oEqBui2NxF8fOgwxkzd4IoeDphfomGuLkyY6cwWkHwHzrZ04fNoi0faHDx0ofcVNSdzXmCvtb4m0zLPwytBGX+plB9ZUFO0i4BNKKqq
 qYNn28Uu
 rCYj3DJ+I4r9iPjhzZqepQaDkVtX1ZcvfvrUwQieLdcyyflrmVSWG7yDQlpDHtjkAUsktqqd7f85cygG+Jlta4FArdHsfNVVEPoIchplxjtuUfOG92GMP9DJg5o9Q2I0KiraPKC+D/+ux0FGTdt98JNi9gcIXBpcHzwfqgCGsBUvQrrvS9kzXm6fmBd6r7CBxCpnlddhs5UDj1DYxiT4X2W4C8yzvMtHd3PClQWyYWymd4VaxN/Qv240clJPwB2x10suANVA17XT3OK8XaU2cNxG5TcrJxYHcibMzUhlCFyFI6iSxTVKge4HktULsMVtv4LyreuOAwBYKjUxL1j+wnLQZhxRVvuR9FHEN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-14 07:21 +0000, sashiko-bot@kernel.org wrote:
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index 4bbe319ef86fa..b4bd29f25c145 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> 
> [ ... ]
> 
> > @@ -2741,6 +2741,12 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
> >  			break;
> >  		}
> >  
> > +		if (unlikely(!folio_is_common_memory(folio))) {
> > +			result = SCAN_PAGE_NULL;
> > +			failed_pfn = folio_pfn(folio);
> > +			folio_put(folio);
> > +			break;
> > +		}
> >  		node = folio_nid(folio);
> >  		if (collapse_scan_abort(node, cc)) {
> >  			result = SCAN_SCAN_ABORT;
> 
> [Severity: Medium]
> Should collapse_file() also check folio_is_common_memory(folio) after
> locking each folio, matching __collapse_huge_page_isolate()?
> 
> collapse_scan_file() drops its folio reference on each iteration and
> skips missing page-cache indices and swapped-out shmem entries, and
> collapse_single_pmd() drops mmap_read_lock() before calling
> collapse_pmd() -> collapse_file().  Folios that are faulted into holes,
> migrated, or instantiated by shmem_get_folio() or
> page_cache_sync_readahead() on a node outside N_MEMORY_COMMON after the
> pre-scan will still be isolated and collapsed by collapse_file().


Ah, this is technically a pre-mature report, as this is an unreachable
condition at this state in the series.

I do already have this handled in a phase 3 commit where private memory
becomes migratable, but i suppose this check could be moved ahead just
for cleanliness.

--

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index fac314b89a234..7a69d6e9b42bb 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2390,6 +2390,12 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
                        goto out_unlock;
                }

+               /* Migration may have moved the folio since the scan. */
+               if (unlikely(!folio_is_common_memory(folio))) {
+                       result = SCAN_PAGE_NULL;
+                       goto out_unlock;
+               }
+
                if (!is_shmem && (folio_test_dirty(folio) ||
                                  folio_test_writeback(folio))) {
                        /*

-- 
~Gregory


