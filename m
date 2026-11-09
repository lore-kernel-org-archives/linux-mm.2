Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C3A0606A331
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 02:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=DjlQzerJ
Received: by kanga.kvack.org (Postfix)
	id 656E46B00EF; Sun,  8 Nov 2026 21:13:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 607CB6B05B0; Sun,  8 Nov 2026 21:13:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F6B66B05B1; Sun,  8 Nov 2026 21:13:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2D4C86B00EF
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 21:13:14 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A0071120575
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 02:13:13 +0000 (UTC)
X-FDA: 85413958266.29.169DB1E
Received: from mta0.migadu.com (out-160.mta0.migadu.com [91.218.175.160])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9D3DE40004
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 02:13:11 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DjlQzerJ;
	spf=pass (imf04.hostedemail.com: domain of xu.xin@linux.dev designates 91.218.175.160 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794190392;
	b=DDaJ9Lk/QMty5bJ1YH+Lbis+f9CnmfWQvo8A3q8avoVo78A+Lz+67whwClzbgpDy1AwT2r
	JJoTjz0P9a7Yt9xIqRZRSotH7oPRmhf6tolMRYJDjv2/H5t2u2XLNteBgMuA6vAZSxNbh4
	PFCB6kg3mJ0W9Zy7YqdXIH7lwSCvuwc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DjlQzerJ;
	spf=pass (imf04.hostedemail.com: domain of xu.xin@linux.dev designates 91.218.175.160 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794190392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2Hrqs/JVKUcbfDET+jPKh8H9v2r5yy3K1PZrEbt8Ns8=;
	b=qlsSQsisY2iXovVbMiqUDe3ZvauJsjxHFE9Xdy60NrndPBn1GEqOeed6zQEfxFJUNt8sY4
	Fw2kP/ESKw8e4wKgw4bV5SEG7zjHop6hm2mfFJVaw3bZXT3wCIqoxi5RVQRLrFWawN5lnT
	sN9CMC/EFwKadVTRfgKzwsugMceh+co=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=nunKtJw2pkzgi9VVF0VjIUIjGkEovgWbt7tbN/jur34=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794190390; v=1; x=1794795190;
 b=DjlQzerJmxVwZSoGIC5wn1fGAYeqaYdb0xmd0166dhd89K63DpTCiFCUxA3JOLHOCISkGpxz
 fCX+oGa3oTiS89WVQew6IaaqXTsUOWLtk7bDqIOQkpuHvSeWoCP0edT4f2oehSpnoOvuvKMuQlP
 dj2HW6m42/B01Se11MWUPnNE=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id f1189d88acb6bb10;
	Mon, 09 Nov 2026 02:13:10 +0000
X-Mizu-Trace-ID: f1189d88acb6bb10
X-Migadu-Flow: FLOW_OUT
Date: Mon, 9 Nov 2026 10:12:51 +0800
From: "Xu Xin (vivo)" <xu.xin@linux.dev>
To: Qiliang Yuan <odys.yuan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Stefan Roesch <shr@devkernel.io>, Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH v4 2/5] docs/mm: ksm: describe how smart scan picks the
 scans to skip
Message-ID: <avEsIwSBUFygAdq4@dgvxl46587.localhost.localdomain>
References: <20261108-bug-mm-ksm-smart-scan-align-skips-v4-0-86be8fe77e7a@gmail.com>
 <20261108-bug-mm-ksm-smart-scan-align-skips-v4-2-86be8fe77e7a@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261108-bug-mm-ksm-smart-scan-align-skips-v4-2-86be8fe77e7a@gmail.com>
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9D3DE40004
X-Stat-Signature: a4b3g3usaqxdk3319roukhjf4oyeohm9
X-Rspam-User: 
X-HE-Tag: 1794190391-164216
X-HE-Meta: U2FsdGVkX1+yuieUWTJX9Xi0URICYOhI/Egf/OKxC49Cui4oExow/lZipOSsw8ahV5pbdKLwUvc1oRRJb2BXrj8ZexSaAlNxR62l3mKZAj+soMEDwKprT37QFFN0MNC+A7+L779i6GtVeBXQdvVwDrGCTxhjN49WLfJr4WH08k+xlReJZj6UeRONk3FIMqrTiK9g9R/zVJA34MDCfPQhQf5e+mz8v+DFQfGZTAOEmDViha4KBjMw9PVZVNC24Vocg+b7vrK+wwJyeBCSzmZN4RH2rScP1VweVSZ+nDK3fX6kqXdCEwPsHb/2q+YVTrdTUpzxdSgCN2z+y6uEWhDUMKjxl5FI/eus7roF30g7d+z68KeigPCQDXpuvRYKDBPaHYtb3Q/7X9vXmK49nZH/45vqthfleRoDv5M+hSAg6MTIi9r75PjTFDd5Kwn7ISc12E9u++3Mx6w2kZZxJTIFjkxLmgXg2/FJVDzHPv89odyZX1Kz138DZQcz1UUmEEY9NfPLuISVq5aGW2lTSB4J2knP1g9L9AL7ZvQLIOK2rShogRBuWJAgxR5o8D5zfdgSXTxemHyB2+rZnMjeF1uWLLPmI4eC8yL5u23BtT03zm6ojRZUsNvVlnHLbQt0LPs11r24+GVsOQGaEvXMSxCCMKkPyiD58jbYSB9dxooyj7XFF4o3+TykBI56Yz804KG37RKnRCDTBHsgJYpaOHKLXeqTMsoVm9Md7SU0a3sYjRJNgTZ+yog12JFZ23fxe0aDUNGVCVi6UqY8UEtLdx1GOLBdlG0QJSkzNDCxmtV0t71JWH5xK1qRkAe4FlgqQVZLjIKRlIp3BRfYB+RB97M3WzLg1Tb01Vy5b65PL6zb/ot1ScFA7RIVDVqkgFaJwcJNtBVW/8l36wfbQFeGY3gDqSKrpQeliYMt6dWkPZh3ZjUHDAXV7Y6rbuPoAZv8dhVpenwhPdwgVEKX7Q6ggFb
 PptGMHPy
 GNC1/NA0Zv+P0wUz1TwEhsDDJEiDvSrFIzTfZTCd5+zT0QOasaCkXVhC7QYy1Ft4duE0Pv5Az8Ds8MhKI549Z8/4SrjurzffTEbuM9oY+GjMNkaSGwjF/g9o0RQSTdy45hZH6zs+jKktWdRyVorA9Psil93GC8kpyV8ZUMIE5YP34xipyLzxrRevhSC/iW60/9SexyFr8BJk8Nv1nVMrHEz3kEfkqesddwRuup0ESMLEb4TQIlq3Ci8s2UtbSLTbs7zjji++V1rkhBUK9eQlYTmyncxURYvQiqrW4qQc7jfrZBcBm4o5+gxBIujhrmNronzv/yesfxwVH9rPHGOW66H39ZHEUhNHVOCpxSi8kUGvsrcKmHjOFivg/tjivoQZwl+qLSV+rA7QvIydjhsaDSFkYKaPmFhH2+NbJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 08, 2026 at 08:22:51PM -0500, Qiliang Yuan wrote:
> Documentation/mm/ksm.rst covers the stable tree and its reverse mapping,
> and Documentation/admin-guide/mm/ksm.rst only says that smart scan skips
> pages KSM has failed to merge before.
> 
> Neither says how often an unmerged page is looked at, or that the scans
> are picked by the global scan number so that identical pages of
> different ages still meet in some scan, which merging through the
> unstable tree depends on.
> 
> Add a section on smart scan that describes both.
> 
> Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
> Tested-by: Andrew Morton <akpm@linux-foundation.org>
> Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  Documentation/mm/ksm.rst | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)

Reviewed-by: Xu Xin (vivo) <xu.xin@linux.dev>

> 
> diff --git a/Documentation/mm/ksm.rst b/Documentation/mm/ksm.rst
> index 5a80573162def..f954d221e8017 100644
> --- a/Documentation/mm/ksm.rst
> +++ b/Documentation/mm/ksm.rst
> @@ -75,6 +75,22 @@ The whole list of stable_node "dups" linked in the stable_node
>  The frequency of such scans is defined by
>  ``stable_node_chains_prune_millisecs`` sysfs tunable.
>  
> +Smart scan
> +----------
> +With ``smart_scan`` enabled, ksmd skips pages that it has already tried
> +to merge without success. The ``age`` of a page's ksm_rmap_item counts
> +the scans that went by while the page stayed unmerged. A page younger
> +than three scans is looked at on every scan; after that it is looked at
> +every second scan up to an age of five, every fourth scan up to an age
> +of eight, and every eighth scan from then on.
> +
> +The scans that look at a page are picked by the global scan number
> +``ksm_scan.seqnr``, not counted per page. The unstable tree is rebuilt
> +on every scan, so two identical pages can only be merged in a scan that
> +looks at both. As the periods are powers of two, every page is looked
> +at on each scan whose number is a multiple of eight, so two identical
> +pages meet at least every eighth scan whatever their ages.
> +
>  Reference
>  ---------
>  .. kernel-doc:: mm/ksm.c
> 
> -- 
> 2.43.0
> 

