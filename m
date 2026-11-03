Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E772606A335
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 09:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=KgktLcQ+
Received: by kanga.kvack.org (Postfix)
	id 974B46B05B6; Tue,  3 Nov 2026 04:14:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94AB36B05B7; Tue,  3 Nov 2026 04:14:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83AE36B05B8; Tue,  3 Nov 2026 04:14:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 573C46B05B6
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 04:14:46 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 00A25120360
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 09:14:44 +0000 (UTC)
X-FDA: 85393247730.19.E0A6CB6
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2D2D740008
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 09:14:42 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=KgktLcQ+;
	spf=pass (imf11.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793697282;
	b=tcl7Df0PhaYKHTgWGyTeFyFqBAMsc+9H4cziDuzOty+mO59mYJrn1NjbZ23lFy+TbbJVub
	b41+UeVDzAXmnljMAWV1mgo/BoRBo640VJ599STP1gxE/FQyouV+IQKEsdqPbh2SqegKXG
	SaKD6MtiQmDjGmjtBWsO5WT857Y8ktA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=KgktLcQ+;
	spf=pass (imf11.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793697282;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S1WYfRKraltmcSelSSDtbEGSqHwpRq+KEHeQXK3+6sc=;
	b=d8Pn3yHodQxb+R7WZIjDT+UTXFmFlQT1q1Rx2+dHOMRQkq+yKKKMrF7AqjZf47ILkZF+GG
	K19xrJINa+uaFadDHCSUKKHgAE2dBhgzlQsF/Ur8z0KVjW9zbfxUZLL2pZssk2bmP5Zaa4
	mpbQpfaWjFL2Ce9BTlhRurG2RDwUMSk=
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-48c4d99c32bso2671880f8f.1
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 01:14:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793697281; x=1794302081; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=S1WYfRKraltmcSelSSDtbEGSqHwpRq+KEHeQXK3+6sc=;
        b=KgktLcQ+cmL3E0JGGjcFaH2ByBFi1ZWbRnyRHxsn5itQ5b8OoiX1j7hz1y6wsoC76r
         qq5iJyyZfzXS/dbVRgsdFHL/0POE8HghAZMq+6Yc+xQaPVVlqWPz0eZkR8kygdp/nau6
         qOf8IqfWyGg89VwXQ3qjWDrsgjZKQiQL484Fs538+S2+VGICnqOo3Lu1vjX/YLoKVj3J
         DnL/zk9d+nY9vbeVoZq3BiDtDaF7Kwn1eKyE/ltrs90/rXg/CZdsIQ0U2Ux8lCkcRghg
         6gPzqnGONtO5Pe05ogzA6y6SU5n03Xvt4AHNhs7GXejolHs49/XHKtCB2GOrdzJkrQXF
         75ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793697281; x=1794302081;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=S1WYfRKraltmcSelSSDtbEGSqHwpRq+KEHeQXK3+6sc=;
        b=DTcsNbGYnui1JTmTO24M39lhRb+Mpmn3EwUe/Gi3LYLBn4FDu/dG7PaEdsxvSL5qDb
         s2npSjMY3jXISA8fTuvtMdSXzgfpT4GAl2zin8CiRQ5qdJDELz9IZIWZTTH71Fs8xc+y
         CIedCBwKR6ZRwfgiyqebpL8QEHXc/edB6Q59FsCNMfriZi76kSiHW3/9DXoFnnzZURFo
         cvmTBEU79R2ZzOASOn5Xbv58RwhWGDfQPA4ZbYvdeEiqJpWDgO+YbV/hLImGkH+A2qvz
         yGTs4Ofnwd+n2C7jEjWS5Y2V8g1DESEYPnpz4iQRjgH1j3YzkzHQz99iOEjN8L+4HNTP
         quYw==
X-Forwarded-Encrypted: i=1; AKwUvBz3M75+mHfdn5X5lNsoDNBn80hRLx8N8lFXvnT4x3fvE4ehEzPblQcKBRAN1mrKj2KI0ALRzb4NMg==@kvack.org
X-Gm-Message-State: APuU4Z+zzBYv4JbordJLRtagH38Mg9cBQfipGxd5iIICQo/yqJO+PCya
	bCrlSkddU3To4TSgeLtKF149d7qnfanABXW4Xj8lSAcMXeNJ2ei7eztp
X-Gm-Gg: AYBFou1mQ0VSx/V21zgYQKUUUzzLe/B2VZ0SiBQpZAvs4n9BQujfG7VTt2ItKpGB5Od
	4ej3mZKlNEmlVqP/+tSmfJ+dsYnP6XhjndRurvm2A4z+/BZJLRMzE9uqbqLIfWEh/SsTJ+sJgnj
	JOBGPn096UkfTTPzbrz48I0KVbCsCmnKNolbkNWzFsDrYxjvAg/GMlsedEt7ho1TMXe13ospIAD
	+K0LexHkjuO0mdVy01o6EWVpTIP7KXKifXz0q8U7cRdlNkzovrsYa6bTthvGUUKF+lX8a37EMUu
	HLoKrTV8fU7ErSTErvg6HDWyEV5uJl9zNHywmfiDTqY3o01BDdeCDQjKVyr+qNXJqS8+d/XhHM5
	caa70hCVjSqU5jFyutfQJNqoXwCpNRBwEobjqFoEtbrVcJGsUgvx0MHsLbzxNZV//hr8zRnYcDC
	CYJ5vqZFRNnp5q0jq6dKVOsHWXwwXMsDn8AOV9LI/30SG8crA43JnzfX/xQcexyzOfTiuaQmOKz
	cOjN+pcJBg2AQmZvfSB9q2kMzfGyKDV7jfDO1AT6FObMm5rCiw3XA3o4G+VTMW4gVk9Hk/q6l3s
	WCeJLhGrCNcG66WaJKX4hq8fsqjgB4b8RBaKQbEjDAxulnbkL9kyMPwVUyj7xjudBnvOZo6wuPB
	tqCVHiOdmMBQ=
X-Received: by 2002:a5d:584d:0:b0:488:8525:4979 with SMTP id ffacd0b85a97d-48e6e50b5f4mr26190523f8f.45.1793697280601;
        Tue, 03 Nov 2026 01:14:40 -0800 (PST)
Received: from C422HJQPQG-Fractile ([150.251.170.8])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b9b54dsm23473758f8f.47.2026.11.03.01.14.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 01:14:39 -0800 (PST)
Date: Tue, 3 Nov 2026 09:14:37 +0000
From: "Vishal Moola (Fractile)" <vishal.moola@gmail.com>
To: Tal Zussman <tz2294@columbia.edu>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] mm: remove newly-unused page wrapper APIs
Message-ID: <auml_evm_m2C6zUM@C422HJQPQG-Fractile>
References: <20261102-page-wrappers-v1-0-e7280bdb31f6@columbia.edu>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261102-page-wrappers-v1-0-e7280bdb31f6@columbia.edu>
X-Stat-Signature: ri1zmg6wqbba86gwcq65wi6s6t9eyta5
X-Rspamd-Queue-Id: 2D2D740008
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793697282-919087
X-HE-Meta: U2FsdGVkX1/jsaAVd3u00ziyvXTOx+KQVVde+wpBGC6JxME0q3HgoGgtTxd04Ktks83VYOKCTYxdi8tz0tmU2ID8HGSHpS/f6m0UHuS5gZ3gxDt9FbewZOaR94KoD3ZPn+T9VvqaWtf9TcZVm5mBt12ZD/zMSuzjVhIIP2lFdOpfJUI5J7LQoFqOjL29Si0xb95rfwGbYYvINTWQyhY34yJiraCT1bC37YDdbVkBWtQVy7aoVT1DYnYKOsuHtzT/bGmNvU1OWxefpeGjK7UOxCC01sFyDtd07vZWXXK/IxuRCxlfhsfJwQt6RLlZlxKJwtvZ1/6lxd6Y5UAZLv4rSNiNX7396vewOM4+vW1Hi2N1QiJQt3kENspzZHSuQ4xCF/cnZ+2BHX9jK3jirEH1mbPtartpSsmKpu32C7s5n8UQ0ocU+pCo544JLyCW+1ErgxtbXDLcXvdaNacHNMzHxMaRoz+cHYtdzXD/M3OzuZ4QMvnejMzpengkmJUXuDQwLcx+9QQHIs633Ui8vVF/xhsN3ZwKpKlqi/Gudbty5GgSzHYRSoBtnraRjpB99WRM2Xhqwih8BcyuW1LKPw2ZLigNtiC8NBj536T5oOpftYNSf7pxImCgKWnUn6DitQIowowuA28xzJEVbatAG0MrKGfCTaZEvFPOSFU46RUWyrkzHyhdsSzwiz6shSuYLgdqViE08F7dPt4ftDWQu+ln0Oj9duElMYE4FF2TmXF06uF8wVnVT1DGb2eKfjrZH63wTgsA0Qe9Q5xRWPpDe1SaE/zcfwo0ypnI6ytA06nGhMcH1ROy7rcaC/7aMUzayfX/N+Xmh/hlhAxBxmD2w8FFZ46ReYW4cPvtWSZVSD1GsCJ/FEa4PusTOSggcoQec4cuP5mWEhOeAK0a+WA58zZBGe/OxQeMyNZzMeYxVnwKVafLG6721fUs6/BKiCp8yGX0/JjYK7fXCWQA2OObx0q
 kZO2ENwX
 o9PHth5jWEvrqdLLeo4CFIFdsKNaGXeYWH9WovJ2bjDplGK/aSIFUBKX4EhoW69lXr2LS+HbfLhYhdofWqfUdk6VUgkfgVqzue2sbnr11xOgsKJ1H0Eo46LlbRjub+conikUioMZL7Uawzfm7GB8yG3BEE0aScUcG4rkDNVZAIqpQQ52wkkERXpY811tLlMSoyv9T4loLSUSuZ2WP5j+Ajb47aiAYS15s6lL/HQUEnShEZE4rE45H7BG5mQ90wz/px49essrXkR5+uCWuV59lUG2Z8qTkLcHXUAwa2eljdR+v/sjBEdpW96W/JW+PPpzGYlJz8Mx80WRO3zYC0miz1Av48Enhb42W+0BQ2bxn/uYH4W5+xIKT6T6KMZ9BTs6DoxWDqUeKM+eRkZCNgfurUTdJR95caLzeZD7LKLLFY/QFUN5X/z8XO62EhakhvImbs18qh2y69DrHWAW9HUvn3zDrnr/ENB6PGDh4jWzwvlzfIIMhbjmWG2jUF8Mcag8vIbaFNFrhuk/tQF1VMMfGy49QRDtukIiFVH6TrauHwnkiIn8wGh89M3X2WUBa5bAOjLTcbBt5n1MO/0ELBZaIrF1Pcw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 02, 2026 at 05:54:05PM -0500, Tal Zussman wrote:
> After some folio conversions done last cycle (namely ceph, f2fs, btrfs,
> fuse, and page_io.c), there are a number of newly-unused page APIs.
> Let's remove them and update comments as necessary.
> 
> Patches 1 and 8 are taken from the ceph writeback folio series [1],
> along with tags.
> 
> [1] https://lore.kernel.org/r/20260810-remove-wait-on-page-writeback-v3-0-dd7531704f26@columbia.edu/

For the series:

Reviewed-by: Vishal Moola (Fractile) <vishal.moola@gmail.com>

