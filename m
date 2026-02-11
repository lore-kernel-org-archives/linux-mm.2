Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F1FDEB5954
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 09:39:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0371F6B0005; Wed, 11 Feb 2026 04:39:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F27B36B0089; Wed, 11 Feb 2026 04:39:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E09456B008A; Wed, 11 Feb 2026 04:39:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D0AEE6B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 04:39:42 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 75AB81602E7
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 09:39:42 +0000 (UTC)
X-FDA: 84431678604.13.69EB2F5
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf04.hostedemail.com (Postfix) with ESMTP id 887974000F
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 09:39:40 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ciii+RU3;
	spf=pass (imf04.hostedemail.com: domain of nirjhar.roy.lists@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=nirjhar.roy.lists@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770802780;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CsUDYOX+di7Z7Ep7ACxPObG+oLUZUZhESUJGxSBNSQc=;
	b=wmEQIZKEIGa/hsmglrIZvkY2bKRPxPW5DvfRCPEQ4F7rPzouw+S163lysO/J45zQGHCtUC
	GdNVjTlFoz5cqJ9QqhQCkWT0nnhmBOQ+wkI6UjKiFRCaw+Xir9Pps9D5KI/g5UVP1+Gf3f
	bVz2++jLzPfWuh3PybwazXmGDa3mkHk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ciii+RU3;
	spf=pass (imf04.hostedemail.com: domain of nirjhar.roy.lists@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=nirjhar.roy.lists@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770802780; a=rsa-sha256;
	cv=none;
	b=YztiVC851kwudC9dwYeodepKXnIVLoCAv4sARcLwAmFcfnK9yI+Aza2/G4dTT0E++TNyM5
	OmslP2GgpsLOyOPlDU9rumikd6MlTBUJECNMDZYyDlBaINxygjCeRVb08oaMZ/ZnVuYCh2
	Zo7MrRl1W4Sz6CzaWOCIweWIllz7HW0=
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-82491fbf02cso593843b3a.1
        for <linux-mm@kvack.org>; Wed, 11 Feb 2026 01:39:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770802779; x=1771407579; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CsUDYOX+di7Z7Ep7ACxPObG+oLUZUZhESUJGxSBNSQc=;
        b=ciii+RU3j4Z3JpsNRtz2p+tr2U+hJnkrTGYc7kzBFJbs/4nmEzqxg3X6nYukfr/kwf
         RVKdCvk7NBuOpSWjk1XsvaG8z6WAx8LVIKztpDVfqOb510L7U4BP8Z2W+weKSqdeZtG1
         ZAEc6O52BbAyI7wRKk5iJ3gFkVrQkMcH32BRmrbGIdsV56TO8ApychYBt2jJjN61d9pt
         sU3IEJZMTW9se6B/0UR3QlrvB4OknUbwiF3NgjZmPl2frmYd/Rj8NjAfq4qV/B+j4w/Y
         QsZBmM6XZ78hUAE2O+J7DzP/JdqpJ4+yPiKgwne2L0MYvZ26cJkhwjsbWPyso1d1f3wi
         QkHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770802779; x=1771407579;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CsUDYOX+di7Z7Ep7ACxPObG+oLUZUZhESUJGxSBNSQc=;
        b=gStTJAMEfAS0J0tALVjGBKqxZEZpMcOnlbYRDfwL+XvYLB9PYABlUoK6oc5DhODnKY
         fEF/LkOZYZ+pCdqwyquSsiW9gndPOyZ5sjTkE0Aew5WkCMELwBKedfKC41jcgTs/giyX
         ppzFDS8Pt1FisWtFdhpWuEr3PfVU8LxpJfVqIv0AlUprvh2Rrh59pAYVL8v7rpbkkvjU
         kQvQ1ZoqO0wVmrlrDjB1pt0UXoGvIFKnoivxK4lXirbq+eN0rxy6r9tcCz0HZTC/Z2Iv
         Z601xdmONdaUih7mcrTfYgIG9lUYYUZNjVKYodhlbaayoj81UbiaLFHuMkYhtNge4GTU
         H9mA==
X-Forwarded-Encrypted: i=1; AJvYcCWW936GHK40+Ry18JBl3Q2GACcC0eDUye4CfymhP34HJwzT9f5l51MgTuDxScUBCK2FLIvKwE7k4w==@kvack.org
X-Gm-Message-State: AOJu0YxiKotdEY4c7BnwVpnOGFZ3RtoCPdv1TmkMTxsyVSadLB6bsT0Y
	Yu2qTNrgKDph67p9tytyqIcqp+Vi7chLwyrbE8LozPENwWq57gg2+DOs
X-Gm-Gg: AZuq6aK6LA58CspGOmnmVrnEjDmcrazYZpu/wQK2yfTOfkp/5LnNTa6BZbGqLTD+D+y
	nxMYuNMZozVPKI1VVQSjS3tNvtQUvv1RdM8AweqQiwxBXrbx14VQjMav0VUVAJnrGKZDOwHkZuG
	pnLskkmMDl5lBy/Inhtpj+Orh/U7QXmoyJVq/iv5GW/JujuEZNn/OFeb5dDQgIv5FIK8NbNsnPF
	coiYeqCxPS1M5joqIAxieD3NbJEmMRheL6cq2yJ7kXgADAzDc0AcAhYe7M04RG6jcSRsXqVa6ZS
	Ux+vm3c7WozmtSCfee+GX9fhVDgTpW514wqcd/xuZAQxKg0GjSv/yfBumzwqAlw9w8ykV/9Yvm3
	Gx8m7WosiPWTaBmWkChjVF2CQGm7W/y2eE46mFFj1TB+xPOyt+2uBwNLPU7sFZuJduJc93gLJft
	9gASrJ9xu1g8HSr6cy+fGzQocilMuZl5gZheld4G+/sD4nZwmu+UT8WDuYbSBpsh/QFn/IK3Z5w
	s+5
X-Received: by 2002:a05:6a00:2192:b0:81f:3f8a:4c37 with SMTP id d2e1a72fcca58-8249b0c69ebmr1868834b3a.38.1770802779201;
        Wed, 11 Feb 2026 01:39:39 -0800 (PST)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com ([49.207.226.188])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8249e3bd3bdsm1597023b3a.18.2026.02.11.01.39.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 01:39:38 -0800 (PST)
Message-ID: <e9b10221c42b77050120332b6d3cb3c131e551fe.camel@gmail.com>
Subject: Re: [PATCH v3 6/6] xfs: offload writeback by AG using per-inode
 dirty bitmap and per-AG workers
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: Kundan Kumar <kundan.kumar@samsung.com>, viro@zeniv.linux.org.uk, 
 brauner@kernel.org, jack@suse.cz, willy@infradead.org, mcgrof@kernel.org, 
 clm@meta.com, david@fromorbit.com, amir73il@gmail.com, axboe@kernel.dk,
 hch@lst.de,  ritesh.list@gmail.com, djwong@kernel.org, dave@stgolabs.net,
 cem@kernel.org,  wangyufei@vivo.com
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-xfs@vger.kernel.org, gost.dev@samsung.com, anuj20.g@samsung.com, 
	vishak.g@samsung.com, joshi.k@samsung.com
Date: Wed, 11 Feb 2026 15:09:29 +0530
In-Reply-To: <20260116100818.7576-7-kundan.kumar@samsung.com>
References: <20260116100818.7576-1-kundan.kumar@samsung.com>
	 <CGME20260116101305epcas5p497cd6d9027301853669f1c1aaffbf128@epcas5p4.samsung.com>
	 <20260116100818.7576-7-kundan.kumar@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-27.el8_10) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 8krr1jzi8tt1xda5wz5tmzzbdgd776et
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 887974000F
X-HE-Tag: 1770802780-325341
X-HE-Meta: U2FsdGVkX1+AKjsNbbqoVxlDv49+4Ep+b8koLqICAuXA4RY6AqTWxU0q5jAbZhNJrAUSAOlJeWlWabQRARv+Kr4it+n6NFYTQL6qy7b9aSlfairYAS3ncmPIzoO2XLqcU+tRIso2tyWeGDSBeE6aW55nlgQrMqEeV8bgz0QYKSWj4Ln3BHwY0DuEK13sXRASIenJLIoCSdVK+LoCN0wXkAbhXAiCHfPnr+wgt3YpTTL99IFDY6YxqV2I0XuJU3O0i6tpDJc5do3uEbcvTOKekbrv3w8kD2OH346km/OS3UIEr5Xcn5o+twvHeODKB2EVtN9W/wZ0n52g5rslSxXlrRKDTRqo0WYuG7XizZbhWjar4hNEM9cOuL5YQxjYjkT8jTCyn1byFYRZbGto/k6LUs7+HnNgz9G9tOlvIIZkhDVocMQ4j2hCTzAc0vc3TyWgpzCMSLCjL84HwRco4xcvGsr3jfsO2My/cA8uE3yQUHkp+v0oWKi0HYqTycRRbocUrIfdGxM4ZW2C1ksll/6AIVmZvLCmY894eNOLPbm4f1rWoyv6iZHPvHs/HMlsxDaSDeqOqHqKLlDiQz8PEi8p2E7jCllbgMxNX22GXZ3bqymCA/BDt2C5+D4f7Szg8Jh64ngb69haeMkxQZmVZEgznPgE75gnMTFstIGIio12y+U1m1yfD6CABlOMZZdIBRkkOPhxpK/smXHa9PhApKysAELjBoEnXbO0NwhdaJII2BZ3Qid1u/QLBG6wZmi4LbmLl0aXlYZwO8+5bt5QFHtePR++KMx+FFyyOarWBaYUibK1II/h5nV1xz0q9Mv+VgDdDD79NwK9/IC3HZI0QZ7CxF/x7eZARQZSwpBL2uhmXcnXoOBU5h7bqkcnrR50CW9N4NfNeYWa2j0NuMOJzo3UV5F5BWJCI+MQi4PK2vczrCXtFXWECiHi7nDuOQH5Z7EMc10vOZKhfUNjPwk6MH3
 hDqPXVtF
 ACI70WkLZa+B07xOrHegRAoupAOsdmOWNuOubcBghKTRL+1QiM5j7W5yOOuDt3uG0HNTW3LeCU3+opJcQ9v/E8u1fNuvD65awoChJ6Ms0esCGxl2GfKfYHiN6TQj774goVEP/i/9iswBKu0KpRxYRS6MthG8ORiS3reNKjRCvlT1rBHg4L0ncv63XfU0eb2XNQ+zN2MIEs8eF/JacFZQygXOARzL1hsKvsWtW3BIsmcw4Yel1d5ZLWgkmHUnAtLuKXSpcg8I2IEz01k0B3J/JBmcf1/tQktmFCcA+zi/3fY6Fqy4M7vDl93zKvx6TEe95+pdranTEaCFkaNWQuE1gFFQcuyEhFq117+QMVDTYvj16BL1uTtgg3wLCsdsKc25AmSTF8MEWze50IzsBL5+VPiKss0fW7EwcWPWnOStKS/tyctH/LG1dBcYLQpIjjUHqbdhSXUze98epLeIiO1z2Jk9uPGaQZvyo0wIFPTyM1WpTrCQAvj78YPRdKpYHtlArfp4XFCQlefJpZIEoAyWmDMlsEGKgbM04/SdTuFchHZScxjIdDF1kIbTYMn2h8wD4YlUswC63RFxfIFj8xfpsrdczPQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 2026-01-16 at 15:38 +0530, Kundan Kumar wrote:
> Offload XFS writeback to per-AG workers based on the inode dirty-AG
> bitmap. Each worker scans and submits writeback only for folios
> belonging to its AG.
> 
> Signed-off-by: Kundan Kumar <kundan.kumar@samsung.com>
> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
> ---
>  fs/xfs/xfs_aops.c | 178 ++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 178 insertions(+)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 9d5b65922cd2..55c3154fb2b5 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -678,6 +678,180 @@ xfs_zoned_writeback_submit(
>  	return 0;
>  }
>  
> +static bool xfs_agp_match(struct xfs_inode *ip, pgoff_t index,
> +			  xfs_agnumber_t agno)
> +{
> +	void *ent;
> +	u32 v;
> +	bool match = false;

Similar coding style comments as mentioned in the previous patches in this series - variable
declaration and function prototype style
> +
> +	ent = xa_load(&ip->i_ag_pmap, index);
> +	if (ent && xa_is_value(ent)) {
> +		v = xa_to_value(ent);
> +		if (xfs_agp_valid(v))
> +			match = (xfs_agp_agno(v) == (u32)agno);
> +	}
> +
> +	return match;
> +}
> +
> +static bool xfs_folio_matches_ag(struct folio *folio, xfs_agnumber_t agno)
> +{
> +	struct xfs_inode *ip = XFS_I(folio_mapping(folio)->host);
> +
> +	return xfs_agp_match(ip, folio->index, agno);
> +}
> +
> +static int xfs_writepages_ag(struct xfs_inode *ip,
> +			     struct writeback_control *wbc,
> +			     xfs_agnumber_t agno)
> +{
> +	struct inode *inode = VFS_I(ip);
> +	struct address_space *mapping = inode->i_mapping;
> +	struct folio_batch *fbatch = &wbc->fbatch;
> +	int ret = 0;
> +	pgoff_t index, end;
> +

Coding style ^^
> +	wbc->range_cyclic = 0;
> +
> +	folio_batch_init(fbatch);
> +	index = wbc->range_start >> PAGE_SHIFT;
> +	end = wbc->range_end >> PAGE_SHIFT;
> +
> +	struct xfs_writepage_ctx wpc = {
> +		.ctx = {
> +			.inode = inode,
> +			.wbc = wbc,
> +			.ops = &xfs_writeback_ops,
> +		},
> +	};

Nit: Maybe group all the declarations together? I did get a comment like this in one of my patches.
> +
> +	while (index <= end) {
> +		int i, nr;

Coding style
> +
> +		/* get a batch of DIRTY folios starting at index */
> +		nr = filemap_get_folios_tag(mapping, &index, end,
> +					    PAGECACHE_TAG_DIRTY, fbatch);
2 tabs indentation
> +		if (!nr)
> +			break;
> +
> +		for (i = 0; i < nr; i++) {
> +			struct folio *folio = fbatch->folios[i];
> +
> +			/* Filter BEFORE locking */
> +			if (!xfs_folio_matches_ag(folio, agno))
> +				continue;
> +
> +			folio_lock(folio);
> +
> +			/*
> +			 * Now it's ours: clear dirty and submit.
> +			 * This prevents *this AG worker* from seeing it again
> +			 * next time.
> +			 */
> +			if (!folio_clear_dirty_for_io(folio)) {
> +				folio_unlock(folio);
> +				continue;
> +			}
> +			xa_erase(&ip->i_ag_pmap, folio->index);
> +
> +			ret = iomap_writeback_folio(&wpc.ctx, folio);
> +			folio_unlock(folio);
> +
> +			if (ret) {
> +				folio_batch_release(fbatch);
> +				goto out;
> +			}
> +		}
> +
> +		folio_batch_release(fbatch);
> +		cond_resched();
> +	}
> +
> +out:
> +	if (wpc.ctx.wb_ctx && wpc.ctx.ops && wpc.ctx.ops->writeback_submit)
> +		wpc.ctx.ops->writeback_submit(&wpc.ctx, ret);
> +
> +	return ret;
> +}
> +
> +static void xfs_ag_writeback_work(struct work_struct *work)
> +{
> +	struct xfs_ag_wb *awb = container_of(to_delayed_work(work),
> +					     struct xfs_ag_wb, ag_work);
> +	struct xfs_ag_wb_task *task;
> +	struct xfs_mount *mp;
> +	struct inode *inode;
> +	struct xfs_inode *ip;
> +	int ret;

Coding style issues for variable declarations
> +
> +	for (;;) {
Nit: I am not sure if this is a common practice in XFS to use such infinite for loops. Maybe have
some conditional flag variable or something? Darrick, thoughts? 
> +		spin_lock(&awb->lock);
> +		task = list_first_entry_or_null(&awb->task_list,
> +						struct xfs_ag_wb_task, list);
2 tabs indentation                              ^^
> +		if (task)
> +			list_del_init(&task->list);
> +		spin_unlock(&awb->lock);
> +
> +		if (!task)
> +			break;
> +
> +		ip = task->ip;
> +		mp = ip->i_mount;
> +		inode = VFS_I(ip);
> +
> +		ret = xfs_writepages_ag(ip, &task->wbc, task->agno);
> +
> +		/* If didn't submit everything for this AG, set its bit */
> +		if (ret)
> +			set_bit(task->agno, ip->i_ag_dirty_bitmap);
> +
> +		iput(inode); /* drop igrab */
> +		mempool_free(task, mp->m_ag_task_pool);
> +	}
> +}
> +
> +static int xfs_vm_writepages_offload(struct address_space *mapping,
> +				     struct writeback_control *wbc)
2 tabs indentation                   ^^		 
> +{
> +	struct inode *inode = mapping->host;
> +	struct xfs_inode *ip = XFS_I(inode);
> +	struct xfs_mount *mp = ip->i_mount;
> +	struct xfs_ag_wb *awb;
> +	struct xfs_ag_wb_task *task;
> +	xfs_agnumber_t agno;
> +

Coding style for variable declaration ^^
> +	if (!ip->i_ag_dirty_bits)
> +		return 0;
> +
> +	for_each_set_bit(agno, ip->i_ag_dirty_bitmap, ip->i_ag_dirty_bits) {
> +		if (!test_and_clear_bit(agno, ip->i_ag_dirty_bitmap))
> +			continue;
> +
> +		task =  mempool_alloc(mp->m_ag_task_pool, GFP_NOFS);
> +		if (!task) {
> +			set_bit(agno, ip->i_ag_dirty_bitmap);
> +			continue;
> +		}
> +
> +		INIT_LIST_HEAD(&task->list);
> +		task->ip = ip;
> +		task->agno = agno;
> +		task->wbc = *wbc;
> +		igrab(inode); /* worker owns inode ref */
> +
> +		awb = &mp->m_ag_wb[agno];
> +
> +		spin_lock(&awb->lock);
> +		list_add_tail(&task->list, &awb->task_list);
> +		spin_unlock(&awb->lock);
> +
> +		mod_delayed_work(mp->m_ag_wq, &awb->ag_work, 0);
> +	}
> +
> +	return 0;

It seems that this function always returns zero - maybe in that case use void?
> +}
> +
>  static const struct iomap_writeback_ops xfs_zoned_writeback_ops = {
>  	.writeback_range	= xfs_zoned_writeback_range,
>  	.writeback_submit	= xfs_zoned_writeback_submit,
> @@ -706,6 +880,7 @@ xfs_init_ag_writeback(struct xfs_mount *mp)
>  	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
>  		struct xfs_ag_wb *awb = &mp->m_ag_wb[agno];
>  
> +		INIT_DELAYED_WORK(&awb->ag_work, xfs_ag_writeback_work);
>  		spin_lock_init(&awb->lock);
>  		INIT_LIST_HEAD(&awb->task_list);
>  		awb->agno = agno;
> @@ -769,6 +944,9 @@ xfs_vm_writepages(
>  			xfs_open_zone_put(xc.open_zone);
>  		return error;
>  	} else {
> +		if (wbc->sync_mode != WB_SYNC_ALL)
> +			return xfs_vm_writepages_offload(mapping, wbc);
> +

Since this patch (and the overall patch series) introduces a couple of new data structures and a lot
of new functions, can we please have some concise comments at the beginning of the functions or at
least the functions introduced in this patch - just for a quicker understanding?
--NR
>  		struct xfs_writepage_ctx	wpc = {
>  			.ctx = {
>  				.inode	= mapping->host,


