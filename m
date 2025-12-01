Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE8DDD116F1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 10:27:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF3D36B0092; Mon,  1 Dec 2025 05:27:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCB226B0093; Mon,  1 Dec 2025 05:27:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D08336B0095; Mon,  1 Dec 2025 05:27:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C002A6B0092
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 05:27:53 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 74788B3178
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 10:27:53 +0000 (UTC)
X-FDA: 84170526426.30.3A57F5C
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4C6AA140005
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 10:27:50 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf09.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764584871; a=rsa-sha256;
	cv=none;
	b=c97y7FAPqHZsNHrdc8K20sSZ0S4o7tO+uMEec/GEdxpoe/xBPCbRuQV5zckwVYrEwLRXgS
	jMkdXrPsOX6XbDGgXRZ4vMlGICUabDOr1aC74xsYSE70TI59f1Ax+Cgg6XWVeF/VTbkwXe
	vUAMJJfjL0HADbo6wqqTp+EwdB3wc84=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf09.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764584871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7NpgV7tiTyP4WS1tv96o5mOZpXjqFwniEFptm43YSLU=;
	b=y3pMbkzg1RAXqKq5pduZ/igUXPG7xMcdBntzcAUQzqwMLnH9a3H4PNsQ+nA1/R8KfM9Y/W
	3QFUObKMvXr3BpKUiD4YizAXPKw9sCiEUexamyUBe45f93AJkt6DYabfBy6UtPhdNIj/FT
	F2eYcgjV9N6+xmCZ4La4mGEcU6TkoHQ=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 1 Dec 2025 19:27:46 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Mon, 1 Dec 2025 19:27:46 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com,
	shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com,
	baohua@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	syzbot+d7bc9ec4a100437aa7a2@syzkaller.appspotmail.com
Subject: Re: [PATCH] mm/swapfile: validate swap offset in unuse_pte_range()
Message-ID: <aS1tojIUgou6eGCh@yjaykim-PowerEdge-T330>
References: <20251201093741.730884-1-kartikey406@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251201093741.730884-1-kartikey406@gmail.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4C6AA140005
X-Stat-Signature: wcc3cxgr83htraxrhzyqfk5uggbrypjg
X-Rspam-User: 
X-HE-Tag: 1764584869-98373
X-HE-Meta: U2FsdGVkX186TkCNRZdgFuu1XsQ28Yo4LAzfWtyxIkbLRbSG04NC9gz/8GySKNpsjssIr3JeQiyOuF8LlOQco3jeZt224JCvQsuCQtcR5MIhq0XXtsBKnGxzgj5TnZkPTHaDS2qBkfbETv7wvnaBaAEzoRZpybXUpSm41RJ/EL24e7tzXBw5VuFk8cfeuZR5Xnlc7MnMN6wLjjCnNcw0HxrXYVM4m+JPK5vPImmTFUDEh5xXNxyOkCF84dm58RaYN3pS2WLslMqfZBRLp2IiP9VIp4avtPkws9YGhsjCFmtzAe3zFAH9RXXgWy8O8HKFBy9Q42Aou35R74x/me1Z8gjl/1ZFH5mrBPV61vKtqPT8MEG/kbYQ7Fdbs19s8gkm87RcgYZljdDgjcWtv6dGZP1ORaStlBqVI5f7ZwQPptl2DQN1xLWebPysZsLhU0CWjDja4WayE+7Eu5tcNfID5PMqGhm1BIdU/SaVQObbtdhERderj+ED41b5uHkN9ACwZJQiEEF7eaQc+FAEmQ1YdYL/oT3+chrNhW2mCcRWSLbN+E7Xvtnz+D44eQoje30LV3rQFArEPXsdQxBa0jZDinzrT+fN4yz91+bpZAXMCWRmg9SFcyboZRAD+eQ10xtgXkQeaXrGZug3RbT5tK6LtLojfSNgV6PGIs6RqSd0giV8kIqjzBmiEfRflK+44QSBMa++Z/5Td+h13l2UmWt6xn8ZvUoxYJCWWraIvWkNbsk4fm88vxAx1G26anB37CHmIcnxkpJDVgJ8PZzObWNKR/YWDpwQS46WL3sfXcT0kxdAPdwf8U8x2G6PO+WZfrlZWypXj8I7/3dxiQowYv4UXu84hrBS8kdDPSWm+AUCykXhE33h8IsGafjJg0DPKxZXXI2429yC1fuz6QufgOaOm2gaBgDYqnuYJuI75YGYiXePwr6br4z0u6OwDklua9YTNtFHMMQh75bzgffhsi0
 abitm1oO
 xWn8M2lJVXkGYbiwasFxPud9qGuv0izUXRs6oML8+CKxnoSLVf7k+Q+9TNbSoFVkCyLdO1QFKIFSHH9mQXkAgrKmEQ14V7DuXjJbYC24V9boJqtOhlfK9DRThV+VO3r+RM/I/lNnuToOcKuY9i9DcduGO2Uh6K7cvCwR3JkYz3HrmdNdu0kcbtuREiroFPx4c+kY+PQafspYbHMKNzofNe73uuun5v8vZVxVevWOIAqEi6PqW6a7JhH0ExAPGw0UQ+IOona9jJwKvcuHzw7oAjkTo6WEu5e35peH686E6Qkogev9c0A2FnD7yA77govs+uGrWN9aBLYw3uF3cbv3sESrHpqlwRKbaaQZBy9yFVtKWxvb971BIXafxdu22h2yFcPeTnbztRClmas7ze/1KXcYL0xHe31UP+xHiueXsr74Q+qVvipZB2l+vMIQzVhXFu0N22JXaCwvUuPamaLTuACyhfjn1Alvc/4DYseofCR0WnC/yZXjcm4QWLw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 01, 2025 at 03:07:41PM +0530, Deepanshu Kartikey wrote:
> syzbot reported a WARNING in __swap_offset_to_cluster() triggered by
> an invalid swap offset during swapoff:
> 
>   WARNING: CPU: 0 PID: 9861 at mm/swap.h:87 swap_cache_get_folio+0x186/0x200
> 
> The issue occurs because unuse_pte_range() extracts a swap entry from
> a PTE and uses the offset without validating it is within bounds of
> the swap area.
> 
> While the existing swp_type() check filters entries for other swap
> areas, it cannot catch cases where the type bits are valid but the
> offset is corrupted or stale - for example, due to a race condition
> during PTE updates or memory corruption.

Since this indicates a system-level issue (race/corruption), simply
avoiding the crash seems to be the goal here.
Should we at least add a WARN_ON or somthing? 
(Unless this corruption is expected 
to be reported elsewhere beforehand, in which case a silent skip is
fine as I think)

And it looks like swap_vma_readahead() share similar logic. 
The differene is intentionally allow entries from different swap
devices (to support vma readahead). 

If the offset is corrupted or invalid in those paths, wouldn't they
suffer from similar issues? Do you think we should add the boundary
check (offset >= si->max) there as well?

Best Regards,
Youngjun Park

> 
> Reported-by: syzbot+d7bc9ec4a100437aa7a2@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=d7bc9ec4a100437aa7a2
> Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
> ---
>  mm/swapfile.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 46d2008e4b99..fdf358df7116 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -2277,6 +2277,8 @@ static int unuse_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
>  			continue;
>  
>  		offset = swp_offset(entry);
> +		if (offset >= si->max)
> +			continue;
>  		pte_unmap(pte);
>  		pte = NULL;
>  
> -- 
> 2.43.0

