Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2BA6CDE009
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 20:04:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A82F6B00A2; Thu, 25 Jun 2026 16:04:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 731FB6B00A3; Thu, 25 Jun 2026 16:04:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F9546B00A4; Thu, 25 Jun 2026 16:04:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 324906B00A2
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 16:04:50 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A269B166D83
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 20:04:49 +0000 (UTC)
X-FDA: 84919513098.16.7280EE8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id AB6028000C
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 20:04:47 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=OSPU4nIe;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782417888;
	b=CS8Tp3Tw2pZG3OA5cbxWQ7tVdGlAjYwfO+wcqwIrMF2o4jxHXb/UEI+k5fPvIk6LOhmas8
	aNMUpSW/CTKKDzHQB7kHp/p0v1bB2DQYDRl3c8KNCe0cbAtxa49SwwvKfCZ/+6yInzm7P4
	6pVY15aOsTXW/5rc1DaJDHLsOUDIT1c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782417888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CXGH1UvQbMl2j6fWiW2DtmHdB8JpN1V560SSVMXBRtU=;
	b=7vqz+zd/j8hOqze5GQGKVhK2GZX+Q6XTbhLI4vvq9JUsgyVdRUwN5jSkOj4YboQ7G3qd4z
	ATVEtIRtJVHcgZLK84q6EupXIzI6WRnW/jWyaLMEnniHxqYd/6o6Cpql1sWA4FDAiDSytc
	3D0BlhM14jiXTFWZ+Uls4u0id2HoaA0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=OSPU4nIe;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A917E4407E;
	Thu, 25 Jun 2026 20:04:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 379901F000E9;
	Thu, 25 Jun 2026 20:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782417886;
	bh=CXGH1UvQbMl2j6fWiW2DtmHdB8JpN1V560SSVMXBRtU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=OSPU4nIeZKft2aL4RW4g2m0Z18E5Hxst0IbluKYPXeido+YkxPkI3aelzr0+qy7pJ
	 KcXpGnyD87rwMsWHtaVKMAMcCu9jc++8lfKoKQC+MMXceXt7j96rEjNayM/RR2+2xt
	 wvyq467XDkdifxtGCNp4pyaGIt2S0S8PL+SoLSlk=
Date: Thu, 25 Jun 2026 13:04:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Zi Yan" <ziy@nvidia.com>
Cc: "Zhen Ni" <zhen.ni@easystack.cn>, <vbabka@kernel.org>,
 <surenb@google.com>, <mhocko@suse.com>, <jackmanb@google.com>,
 <hannes@cmpxchg.org>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v11 2/4] mm/page_owner: add NUMA node filter
Message-Id: <20260625130445.347e3fcc6d271b988fceacd4@linux-foundation.org>
In-Reply-To: <DJIDMIBR7QP0.14KBT460GECAV@nvidia.com>
References: <20260625043101.338794-1-zhen.ni@easystack.cn>
	<20260625043101.338794-3-zhen.ni@easystack.cn>
	<DJIDMIBR7QP0.14KBT460GECAV@nvidia.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: z8amwjqz8i9ob57cfjhy5cgam1zgj8zw
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AB6028000C
X-HE-Tag: 1782417887-347365
X-HE-Meta: U2FsdGVkX1+Xkr8utoUzSjCnpRMtfdUMNjFzOJ5kx9CUaKXW5RL9tnE9QkjhG4aoWFUPqzKwnmIlV5vrcay8o1JD+d+Qt+8LUXKEH71OCTghahd8oTeY/BWwhBK9xmhh0/a618+BK9QO4lTuGCBZ+sPYP8IidHKZDTYatVqGqriF012tR0CFtMUD/6ED9i+jgH7tTItHMuBN0TeYAaJUwek0dnM4xaWCFTTdUJPARQvq3b7s+ZpHXgUdYxnu6q6JyeqS0H1tJcSOW5tHORXkm3igMZECKGuQ102oAxDodJHARmXpvF1i4HQP4TLMRAe2h7VayY4ei36tn84hVyzOax7u6zINOh62MsdD5vn9jkrzBEjr/yUC84RX9b517CCtnlxnndgbrXEptxKDe28i6lhwes3+B4I1S6+tjo+z3OWLazlww/dCnI53V3ouf307fhnGIl3Qfr7MQ0AKb7vzwo6zp447bq2OuoxpM0fcVIT+NqEbO8J45wcbG6knNMerSaBdp5Qq8EbZP+Gz2rAvDArmDo7wUUOMd5JA4Gx4/RaGIRzAoitTdERecWh8f/CNc3njENYCehsG7oV8YvdfCWQJpaMIur/ks+pIvY7UOiIfNVl8dLpqaEGVWiF6hVUuY/8MnBLdybEG8kBkADorpde16Fz4iN2I181jU+nE0MlKFe5PXJV9/jQvAPH7T+wPO+2m77QfbE74WW0cK+c4G7avmiFhFwtXI9PONqkCfVsmDcjLLSWB/WpPTguG4MAPRIFvaOUnAKY95dCnSN5MxU4NZsGgvEbieunXZDK9+KFiUdAu+2lTfAOQk4HCt6XdgboZVCe8H1am0ocFGu4JX1h3uj2CwYjcAnSfvklfQlhXmWUg1mogdZpv7biSu9Xa3KIxEPKWhrv+CGUWMjFhPyW2r8RJa3t7gEHcgII0CAb10QAlsOADYLAsbwB3Mdb7mNFiGXizwaECftY3gCt
 nif62Kdt
 KMCo/PgctYe0NSzlUC0n/QGaDtpnrTxmws/RWPcTu5zaKgWhWvwh3AYT1t8ok7jqAysqurw6SiGLd9//r8ER3NS7K8JHK5RNRySesPmftjyHkDYHBWoLmxkpt/2bEM4sEJxIGaRVFwVbMDCWI94vHl5s+QPzaqgysdoBLS6PC0uc6ZhLbR3Gw9Gz6DwDFkHc/9Zaf1DlgsQFz6Ka57/5RC9MT/cfPdj0hOxHdwnU0fDtmGSLblB41EBukT7estemm4w/+W5HKhIOgcwTYZy1wdU/SieR57HpU7tjWDRv8bLzCuemQ76g5HFajgmqwU2Rxvp7N
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 25 Jun 2026 15:27:57 -0400 "Zi Yan" <ziy@nvidia.com> wrote:

> >  
> >  	/*
> >  	 * Maximum input length for filter commands:
> > -	 * 32: print_mode command max length is 17 ("mode=stack_handle").
> > +	 * - 32: print_mode command max length is 17 ("mode=stack_handle")
> > +	 *        with sufficient buffer
> > +	 * - 6 * MAX_NUMNODES: worst case for nid list
> > +	 *   Worst case per node: ",NNNNN" (comma + 5-digit node number) = 6 bytes
> >  	 */
> > -	max_input_len = 32;
> > +	max_input_len = 32 + 6 * MAX_NUMNODES;
> >  
> >  	if (count > max_input_len)
> >  		return -EINVAL;
> 
> Hi Andrew,
> 
> This needs to be fixed as well.

yep, I did that in the obvious way:

@@ -934,14 +961,20 @@ static ssize_t page_owner_write(struct f
 	char *token;
 	int ret;
 	struct page_owner_filter_state *state = file->private_data;
+	nodemask_t new_nid_filter;
+	bool new_nid_filter_enabled;
 	enum page_owner_print_mode new_print_mode;
 	unsigned long flags;
 
 	/*
 	 * Maximum input length for filter commands:
-	 * 32: print_mode command max length is 17 ("mode=stack_handle").
+	 * - 32: print_mode command max length is 17 ("mode=stack_handle")
+	 *        with sufficient buffer
+	 * - 6 * MAX_NUMNODES: worst case for nid list
+	 *   Worst case per node: ",NNNNN" (comma + 5-digit node number) = 6
+	 *   bytes
 	 */
-	if (count > 32)
+	if (count > 32 + 6 * MAX_NUMNODES)
 		return -EINVAL;
 
 	kbuf = memdup_user_nul(buf, count);


