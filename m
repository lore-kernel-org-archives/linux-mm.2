Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E4D1C55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 23:33:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F5E56B008A; Tue,  4 Aug 2026 19:33:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A7EC6B0092; Tue,  4 Aug 2026 19:33:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5968D6B0093; Tue,  4 Aug 2026 19:33:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2C3836B008A
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 19:33:44 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C05A81A034E
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 23:33:43 +0000 (UTC)
X-FDA: 85065191526.06.B498C93
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf20.hostedemail.com (Postfix) with ESMTP id C4A131C000E
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 23:33:40 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=e5vywcvT;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf20.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785886421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9MJn2efyYx+aesbUzNhwwCfbZijkW5RJZCFgDwcElxc=;
	b=xAknCahPgnPhc7TWJI/8xcre6WGlKbXjPXdL51fNWhhK9qe+Sbm0OwnQlGbnrTB9reb0NY
	zL+TP0MdbQbjYXicjAqtPjxHD+sDP/P/sUEW3WzSziF3LlgEiDziRlEGrqL32XiPr2WMD8
	KyP3AftzFLd/rehT2+9Kghe0m81p5KE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=e5vywcvT;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf20.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785886421;
	b=cRrCY5CA0/hoQxBsBIsVfzNwHPd5PBSOIRtskGfgZOu9x+D0AcVPgfd8sAQIvBfk/EQQkK
	0eWL5linueLmbqEeXPcqN7Fjspl63JS3NwTFQxcYVFQfgI2jnepvTojlJzQS+KZtxbk6wW
	hsx99Gazm/Aeg7tHYturZP+ez1etLA0=
Received: from pps.filterd (m0499198.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 674Mn2xC3049806
	for <linux-mm@kvack.org>; Tue, 4 Aug 2026 19:33:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=9MJn
	2efyYx+aesbUzNhwwCfbZijkW5RJZCFgDwcElxc=; b=e5vywcvTTA/6436SInVl
	fh4GPAFFlzbh13Di6M3azfwc4Kdd/id49TzXyk8HOp9qbv+kKN7K7uuBjSAb9Mzz
	Ha23tt9rZQKSBR3C3T5yb1OD9dSELc61LwFL/eu3I/xSClWsSkgqdzEOx3wyHxcL
	Y5EJgfBihjsgKa51KjZuNlA2wjZFMMmEgpQucGP8zO8NrljKbNy73K7zVS2EDwiK
	gL3w8hHJTB3fzaEO4+qpiAaySGzAVnaMyZXb5r+ATS7NvscoG68CvqjBI8w4ENLF
	pRDN9f2HObDurJgkVTCojapDlretvOmu2bjD1iWvfj7201eT0BWKxqCBi1A1M45f
	vQ==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4fum1pjhxc-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 04 Aug 2026 19:33:39 -0400 (EDT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-51c12e43b98so4077041cf.1
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 16:33:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785886419; x=1786491219;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9MJn2efyYx+aesbUzNhwwCfbZijkW5RJZCFgDwcElxc=;
        b=E3wPgjkUDqCrakIMlvL+SI7MoutzF7Q/dqwQbfPwvjODzqvjOEMtsLZadlVzBPWRJm
         wtJ/eeWb2rm5RzLhE6tt8xq9vgqtsoJmzNzWH0pqoF9ZBXfsAUskicY3KRejyt5Wm9rd
         T1GJw6gezCtzX7EWb6I+9sCtu7V2J1FHZZB9S2beEL64/ota5s0H/4Sxp/DrS/kRS3rs
         MVExm6m0Syek/WnIDLGONk+zhyY82FE7c9Ko58hIj1Nb1a+0Get6IySaCI4kPCJtkOA1
         bo08/ty91WgjZ3vJqlxYscDwC7inGvqDl/M/yKhnEe9/MIvBtR1CZiC26CZmafv+GNdK
         NyuQ==
X-Forwarded-Encrypted: i=1; AHgh+Rp9AgVttS83wiuF+vpuvIA2u+z1QBymc4lG6PPUjE56G6EV6PzUzpwVJHG52pooWB2Sd04Vo9rboQ==@kvack.org
X-Gm-Message-State: AOJu0YxxhuPza42++MrO8lNClxT4tUWyZAiI7EBeZ2VUav1KXN5m/XCg
	6MuKh/blvPpT3+iWApL9suoiMWSyc7XrWjIhl0BduwI9RcPwNkepMiZdjzPWRSz3e5UY6ISmDQm
	x8xUfYyURtJhCm1ZEZijywyUNaRyibNY/p9KeEFUUPIrIrV9r
X-Gm-Gg: AR+sD11yBYD5CyPr8sty/Uo99LmnIlhleanaPATF2dvYFzJ49+anql/aF4I4bxltDHf
	UsdFLOhMkye11NC9Z2cyzMq56pjnwO7+TypLdDc+QRQXfLCt7f4C9svsY7hoHTpvX+Qo0+DVWJJ
	G3ODhuY0Mgv6kQKWXvft5ghs5eFYgJH7abDAyiHuq1YvoZxAmxwJAqXkSbOYUc3lL/mXDSWb2b0
	/Xhm63O9nHYG0s4Oak2Z5ZV1NhB/hZhshP75QUxeRSbLSy9i9UC+Qxn5ogYPvQ75X/09uiJdK7z
	oRVqjX2mLVEKitczXdY0WN4iOFlh7w85wt2D5jXgvkm91+eJkQT4CV58k8tMaiZf891qSCThVT/
	vh0GE3QpmKWgeaiVMCdleWPr+W/64XABFPT+Igo4S96ZVU4teUkUN38tPituWNs4A
X-Received: by 2002:a05:622a:1650:b0:517:8011:3a4d with SMTP id d75a77b69052e-52ce60d5147mr28750651cf.20.1785886418765;
        Tue, 04 Aug 2026 16:33:38 -0700 (PDT)
X-Received: by 2002:a05:622a:1650:b0:517:8011:3a4d with SMTP id d75a77b69052e-52ce60d5147mr28750181cf.20.1785886418238;
        Tue, 04 Aug 2026 16:33:38 -0700 (PDT)
Received: from ?IPV6:2a00:a040:199:782e:a06d:5a37:92fe:4fac? ([2a00:a040:199:782e:a06d:5a37:92fe:4fac])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fec23e533sm3873005f8f.28.2026.08.04.16.33.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Aug 2026 16:33:36 -0700 (PDT)
Message-ID: <c0cc3539-be7d-47e0-82b7-9d7239c37907@columbia.edu>
Date: Wed, 5 Aug 2026 02:33:34 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 08/10] ceph: convert page cleanup loop in
 writepages_finish() to folios
To: Ilya Dryomov <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>,
        Viacheslav Dubeyko <slava@dubeyko.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Zi Yan <ziy@nvidia.com>
Cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
References: <20260804-remove-wait-on-page-writeback-v2-0-81f0ab065284@columbia.edu>
 <20260804-remove-wait-on-page-writeback-v2-8-81f0ab065284@columbia.edu>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <20260804-remove-wait-on-page-writeback-v2-8-81f0ab065284@columbia.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=PII/P/qC c=1 sm=1 tr=0 ts=6a7276d3 cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Da8U98TiO7q1upZEImrf:22 a=BpGzv1V74M3SfeTrGa8v:22 a=wrtZYR0IVx0RtIOIqSwA:9
 a=QEXdDO2ut3YA:10 a=kacYvNCVWA4VmyqE58fU:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA0MDE5MSBTYWx0ZWRfXylXpnJ/nqdar
 eShYz+Kj7kUNIS+ub9YZq95f57KAWIzedOLt5RR+8RE+8PIp9/e6/QaaasDInQdMK4tMwa/Eqrw
 60rvxtc8MdGS2au3bOqzDunElntTIGN06rCJSg5huCu8zY15v3DqMsKpLY8sI7+4JlqjxZBzAAI
 dE75R5Z1fhQj995Yk9iur+bw6icWBIYkdRU9CHp2qG2zErMKmVhixqijOVHECtUHI1sNiXIYGwn
 8XrsC+NdNU5Obf8aaqu12sPZhXdT1ay1tvV4xxPehPZ++SLStJJPYmWD6c31bKPCC4jwQZEDJmF
 r6VUyApl+s6pQoeF6WA5h0Jipulb25jBbtftZqUJt6a44SvnotEGsCGB+Zst4US+To45Rm88Ww/
 XD42xX1Q7ZKSogivkYpcoDgZxs4kh9Gz5AvC8cMFId65YSTFBWcDVR+P7NPXq4zGVb//7aFeVnf
 QNqY6Stq1PuAfBxKTEQ==
X-Proofpoint-GUID: 5ctW8IPlmCXuynbvGZ0W4fEHMnlk-dF_
X-Proofpoint-ORIG-GUID: 5ctW8IPlmCXuynbvGZ0W4fEHMnlk-dF_
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA0MDE5MSBTYWx0ZWRfX+h9M8okp0bcK
 f0yfJt7SYFsHzM4Dl1YTMmwFghrJFkg8SOsrjWTxB1vlVFrYYEzY048ISzbt7cLAjOiiZ+MHJkF
 wMIPNkRiEI5zPpK6tTIGuIcvn9lHBOp5GoTAdo4MDUbpbrfamBo/
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11865
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 clxscore=1015 malwarescore=0 spamscore=0 bulkscore=10
 impostorscore=10 priorityscore=1501 suspectscore=0 lowpriorityscore=10
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608040191
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C4A131C000E
X-Stat-Signature: xhh1d73ohtf6xik54r449egnbxd1b9bt
X-Rspam-User: 
X-HE-Tag: 1785886420-768100
X-HE-Meta: U2FsdGVkX1/G6HuiXTGCNbUtoH49q3EBQAEmrVD80rRzhT6VYsUbYMn6fAniHmc7IqHf3v4xT5UC9GNKIbwE7CQ++8zig9eEnWLUeiimZr1PMtmCVpWzHeLbHi+jhF6gidaimXjasRdYol+mWoIN+qN4RS+PN+BjYvIw9BjU1pqDhPJywbnRygtDAhT6Ed0xGl3/kqmNmgoCySzMkKaka5HAkuNrUngzcTwaONO2tOV1L5qac/JPZ2dmJ9k0Rqe1BTLaYAH5/ny399ZSG4Qgkz8CxzK35vTG3WVIo6NwAIp7Wc+pnTsEudIKrhIhxn2CKuzdktiQkqiLN0ZVWPsAxasbPV4Hz8ZzhJbDq8qUoMtWGNumUNB5To+TR+yN9ZvSmqETbH1R5PsX3NkHQRkSIchJxtPOEWzl1UStANJJIrvFjycqATnCzEEfdsEOOGAYxPSWN1SBF0iSCbqShN3z6lYUfFp68CJ3esvVFRj6NZengVU1JAB3//+KjZojp+8F1/djNBwy0xBWCQbP1ruwlVXXIEwwqL8xg9CWcZahVFALJhn9XMfIVxi3v/fHmEAy61gStGO2PaaUsZ5aluYSCabiPv2bI/t4TsJIuAIfPWUrz3qxKv4ctxWZ7mq+TBauk43hBUB6PX6fdEIrowYoHv5aPktmmUko5qdKjQXK+OUKFoCqWOK379pp3jtVQc7332F1Q6cvBr4DD4i2A3hFYa1QFxKDJ3xTKcpNL5de6GlWN3OQxJUVqhEPrPP6di6BRrPgmggbxoN1XYeLWIGDiNhiSUn2UO1HO028RSvfRCjETfb668gdX7PungjJV/rTij+V2/vEg7OYkU9SpzkV+S3EMsqDzSkGiHQOXStfqQ9h/cUZ9yajrYa5FHFXrdFXBEEBzY+Q6YAywYWEcX32bG04EIANmanIm3jFRmu2LC30Uz7QDSWyam+HCoYt9NuTWXzVIPeMs7ZtPQiHOSJ
 nJpM39no
 OelwSUe/Fd313VYypQN7ncnhCmsBiYaKprV0pZ3UbE1slic1gWirCtvGs140ANBbafOxrQfY8CdLDa5svYiItIfzS37zphUzXTR3iSY+fBRBC70AdQKrxGH1QJ5XB3LItkxvAbXbv0WEINrs7SWxHzZ4Sj7jGq4lZHG7TAWY684/EANQ9nFxGYRRNWISl5RkBddZM3Ju3r+Byessvp/houe8x27+Kit1wkMrPnkeFtVPa23uGAGmDGfjzRBzkgAHo2fL8tqff4hnMfrH333UiYv7nCvZbZ1zaL90e7AqQe19f0x4X54G1wmCNM/ZbwSDORLhajM5eqCNSy18ETMitoQvx7fJu68a4o9xYaIG5woGOH08YXBacANOtYLYEr01o7o4f7UG+GLHGno5lww3W7ZKGS8xOcCwoozK9POcDbdBWH+WNKvQLarsktaVG2JobNWVYK/hKpTS8NZJevBXziDHXVdC6TjzenUXgk9xkbjzmKC54WaAmpfKVPhOr3Wiyxs+WdLo2ubjf/+s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/4/26 2:52 PM, Tal Zussman wrote:
> Convert the page cleanup loop in writepages_finish() to work on folios,
> resolving the folio directly after fscrypt_finalize_bounce_page() has
> replaced any bounce page with its pagecache page.
> 
> This removes a use of detach_page_private() and five calls to
> compound_head() per page, while adding one back via page_folio().
> 
> No functional change.
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> ---
>  fs/ceph/addr.c | 19 ++++++++++---------
>  1 file changed, 10 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index 59e559bdfdff..eaf5b3f6d13f 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -896,7 +896,6 @@ static void writepages_finish(struct ceph_osd_request *req)
>  	struct ceph_inode_info *ci = ceph_inode(inode);
>  	struct ceph_client *cl = ceph_inode_to_client(inode);
>  	struct ceph_osd_data *osd_data;
> -	struct page *page;
>  	int num_pages, total_pages = 0;
>  	int i, j;
>  	int rc = req->r_result;
> @@ -943,31 +942,33 @@ static void writepages_finish(struct ceph_osd_request *req)
>  					   (u64)osd_data->length);
>  		total_pages += num_pages;
>  		for (j = 0; j < num_pages; j++) {
> +			struct folio *folio;
> +
>  			fscrypt_finalize_bounce_page(&osd_data->pages[j]);
> -			page = osd_data->pages[j];
> -			BUG_ON(!page);
> -			WARN_ON(!PageUptodate(page));
> +			folio = page_folio(osd_data->pages[j]);
> +			BUG_ON(!folio);
> +			WARN_ON(!folio_test_uptodate(folio));

Sashiko complains:

"Since page_folio() invokes _compound_head() which dereferences the page
pointer, won't this cause a NULL pointer dereference before reaching the
BUG_ON(!folio) check if osd_data->pages[j] is actually NULL?
The previous code checked the page pointer before any dereference occurred.
Would it be safer to check the array element for NULL before passing it to
page_folio()?"

The BUG_ON can just be removed, as fscrypt_finalize_bounce_page() cannot take
or set its argument to NULL as constructed, so the check was unnecessary
to begin with.

>  
>  			if (atomic_long_dec_return(&fsc->writeback_count) <
>  			     CONGESTION_OFF_THRESH(
>  					fsc->mount_options->congestion_kb))
>  				fsc->write_congested = false;
>  
> -			ceph_put_snap_context(detach_page_private(page));
> -			end_page_writeback(page);
> +			ceph_put_snap_context(folio_detach_private(folio));
> +			folio_end_writeback(folio);
>  
>  			if (atomic64_dec_return(&mdsc->dirty_folios) <= 0) {
>  				wake_up_all(&mdsc->flush_end_wq);
>  				WARN_ON(atomic64_read(&mdsc->dirty_folios) < 0);
>  			}
>  
> -			doutc(cl, "unlocking %p\n", page);
> +			doutc(cl, "unlocking %p\n", folio);
>  
>  			if (remove_page)
>  				generic_error_remove_folio(inode->i_mapping,
> -							  page_folio(page));
> +							  folio);
>  
> -			unlock_page(page);
> +			folio_unlock(folio);
>  		}
>  		doutc(cl, "%llx.%llx wrote %llu bytes cleaned %d pages\n",
>  		      ceph_vinop(inode), osd_data->length,
> 


