Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B69F0CEBF97
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 02:33:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E05BC6B0008; Mon, 17 Nov 2025 21:33:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D91766B0010; Mon, 17 Nov 2025 21:33:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7DEB6B0012; Mon, 17 Nov 2025 21:33:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A720A6B0008
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 21:33:53 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3B0A8C0320
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 02:33:53 +0000 (UTC)
X-FDA: 84122157546.23.ADD4E41
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7586720007
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 02:33:50 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=BcFPJiHo;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf13.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763433231;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kRsqQuTz4oSWisQECbXsOkVKDEe1vgjn0QKhJMMLgXU=;
	b=VHcznzZGovIG73qpALSqE+QxddO8WKoaaDYbZ9OWYuvXefYMvZ+Q/Vy3B+ZYz4/jzbrD6Z
	CLCUHwsB9cHdMmdAIIjZ+7uLUmmcAxdcRH3rbxRZsB9XJ2QOU2/r0Pq00SE10P8W5p7J81
	ffeKx+RN8RcVJJrOcOVf3cW0sth9fyQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763433231; a=rsa-sha256;
	cv=none;
	b=460s8ndJn0R+V2goYWqj9VdZA2lo/OjisurEZyXVxfOWPVcFLzu2JNDGjx8W3dscPL3fqx
	qfmYU3PRA5WOhJIqhq1S/lmA90FmR28PAoSPyNu97DWHAZvMnqeSjZ9Ez5XARqMW5fTqdF
	dteG63F69M3QTb72IszJr2BIZ81NdM4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=BcFPJiHo;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf13.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1763433227; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=kRsqQuTz4oSWisQECbXsOkVKDEe1vgjn0QKhJMMLgXU=;
	b=BcFPJiHoz5Uc0rnY2XCXmpBjE/raIDiEL5x5H9Ars1oyXnfjBMxc1/GV/HdHprfgABLSOyw8MzHaFwGm/ToY3jaJ2ambuR4mMwRIvzMv9mjyiducm1O+4fcfQKYuWJTQbI8i6lHHLURpX4ek8bsEoLkJI5g6zECfxJ5ZXIdoxR0=
Received: from 30.74.144.113(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WshU.lt_1763433224 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 18 Nov 2025 10:33:45 +0800
Message-ID: <c1978ef3-251b-4a57-8244-b047e66b6ab3@linux.alibaba.com>
Date: Tue, 18 Nov 2025 10:33:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] tmpfs: zero post-eof uptodate folios on swapout
To: Brian Foster <bfoster@redhat.com>, linux-mm@kvack.org
Cc: Hugh Dickins <hughd@google.com>
References: <20251112162522.412295-1-bfoster@redhat.com>
 <20251112162522.412295-2-bfoster@redhat.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20251112162522.412295-2-bfoster@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ish5fyot5kj643bcpmnuzgu6go43pi76
X-Rspam-User: 
X-Rspamd-Queue-Id: 7586720007
X-Rspamd-Server: rspam10
X-HE-Tag: 1763433230-368494
X-HE-Meta: U2FsdGVkX19t5hyMvASFPhknz6RvFJpnRUnyPcKOYeconesJTn2IgDky7e6Z1Y9zqFEgkerZTPPKXRKxyLymmnVi2FSOIKH7FuwxANhC4BFvqgOxToZYS9ORdNX3CSxqaUhCudTQ6pYB0V4eXjhife419KhGeSIIUA7w3KahNHzzHECB0i1H7bW6bgL4v3c42/0GMEMc8FvsNj4TC2REhKcxURm270FpN8sIlfuPBK3NsD/FUCJTIUJtSs65j1MElqHdTT6faFf4W6ywTSC2FzwuOfw3ezapl5zgP29BD8xDbDuwH/I1Dkgh2jh5dExEw1EQqwnFvuFTWKcFAjnNU2FmkuaOHHjH7hUAiGFNDpQId/l8AB8oFUACtpyuKkg6HyphvqF/Q31aoiMJHgYqtbOYHbIuxO7zwTY2eogOaUgwj87il82+zimsC/SSQi8wPmfVGfC36WnIAbKr7ckehq2xBm9aWG/+0Mm34qSOIN37G2NlXvvU0P+kcIdoVh77g95hBvXTAzWJdH5JFqYXNIZ8+HQcmEea7pGB/d07QOuCmn/GtZt+h1HSXG31Sb1r8C/nze1ZA2JUXtLCNpEs/KaYTNEdJGaEstt2ztiHtX5hrZDscMFUyzQ1Q+/Zt+OtWv4YLZI18Te8YUtNcb76ejNv1cZnoBUqDGAMjDSokvjbMX/w7S8Duk0Ofbm/td7rE8dRMUUavnrkl/L48uEJxebhoHkrPO34vVvz7OPFPQmADv5KXlQQrMQIC5eX2f9gJdO/8jTMkug7zBdEGDDEFQk+S7EWf+s6tiL+EXGM87WWLC4q6k9im6afvGKIUvMrGi5sLdPSHVTIw7TAhBAswVLgkNZeD0SSgcZhVgSdlS/jQSLKk1v5V527vYARe84p4ycPW/jcbJ7as80KVP9Fc4hfPPjqHJpF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/11/13 00:25, Brian Foster wrote:
> As a first step to facilitate efficient post-eof zeroing in tmpfs,
> zero post-eof uptodate folios at swap out time. This ensures that
> post-eof ranges are zeroed "on disk" (i.e. analogous to traditional
> pagecache writeback) and facilitates zeroing on file size changes by
> allowing it to not have to swap in.
> 
> Note that shmem_writeout() already zeroes !uptodate folios so this
> introduces some duplicate logic. We'll clean this up in the next
> patch.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>   mm/shmem.c | 19 +++++++++++++++++--
>   1 file changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 0a25ee095b86..5fb3c911894f 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1577,6 +1577,8 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
>   	struct inode *inode = mapping->host;
>   	struct shmem_inode_info *info = SHMEM_I(inode);
>   	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
> +	loff_t i_size = i_size_read(inode);
> +	pgoff_t end_index = DIV_ROUND_UP(i_size, PAGE_SIZE);
>   	pgoff_t index;
>   	int nr_pages;
>   	bool split = false;
> @@ -1596,8 +1598,7 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
>   	 * (unless fallocate has been used to preallocate beyond EOF).
>   	 */
>   	if (folio_test_large(folio)) {
> -		index = shmem_fallocend(inode,
> -			DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE));
> +		index = shmem_fallocend(inode, end_index);
>   		if ((index > folio->index && index < folio_next_index(folio)) ||
>   		    !IS_ENABLED(CONFIG_THP_SWAP))
>   			split = true;
> @@ -1647,6 +1648,20 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
>   		folio_mark_uptodate(folio);
>   	}
>   
> +	/*
> +	 * Ranges beyond EOF must be zeroed at writeout time. This mirrors
> +	 * traditional writeback behavior and facilitates zeroing on file size
> +	 * changes without having to swap back in.
> +	 */
> +	if (folio_next_index(folio) >= end_index) {
> +		size_t from = offset_in_folio(folio, i_size);
> +
> +		if (index >= end_index) {
> +			folio_zero_segment(folio, 0, folio_size(folio));
> +		} else if (from)
> +			folio_zero_segment(folio, from, folio_size(folio));
> +	}

As I mentioned before[1], if a large folio is beyond EOF, it will be 
split in shmem_writeout(), and those small folios beyond EOF will be 
dropped and freed in __folio_split(). Of course, there's another special 
case as Hugh mentioned: when there's a 'fallocend' beyond i_size (e.g., 
fallocate()), it will keep the pages allocated beyond EOF after the 
split. However, your 'end_index' here does not consider 'fallocend,' so 
it seems to me that this portion of the code doesn't actually take effect.

[1] 
https://lore.kernel.org/linux-mm/097c0b07-1f43-51c3-3591-aaa2015226c2@google.com/

