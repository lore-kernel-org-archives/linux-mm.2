Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6477DCD3424
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 05:17:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FAC76B008A; Wed,  6 May 2026 01:17:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AA2F6B0092; Wed,  6 May 2026 01:17:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 799936B0093; Wed,  6 May 2026 01:17:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 658B96B008A
	for <linux-mm@kvack.org>; Wed,  6 May 2026 01:17:38 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F35CC1A074E
	for <linux-mm@kvack.org>; Wed,  6 May 2026 05:17:37 +0000 (UTC)
X-FDA: 84735837354.15.A4FAB93
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4EA5F1C000F
	for <linux-mm@kvack.org>; Wed,  6 May 2026 05:17:34 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=gPOBWIOv;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf21.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778044656; a=rsa-sha256;
	cv=none;
	b=sX622kiBQ6KRFcrIEVjkeBWzXW7sTc7wqGCgqRyUbVvWM15jq/cGlv0oSYCviHu3mXeBzm
	GB7Lzo7D+qLkUi/aCizi5pQfFEE7ojTpPWiQyGUtd8DqPgzbDHbZ+rJHK1lZcr8C6KnmcO
	KDi93eHgG4IA28usRwMRl8S0b26gdhM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=gPOBWIOv;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf21.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778044656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gffulxOArRAipIgbJlt1HnidYx/4fODZLq6S9dioK+E=;
	b=Mx3NYVnOZU4OoutvdclhD82fsTl0V9DBlJgAW5zDiNK597lXcqJ2cRzbClCEBhAcyMXu95
	/TN/87D583P+uDt0uPJLsQcldaQeaMxXEtfbLSQ97fID95paOyH6N8L+w+/7jGQJHyuWy/
	QprWOzNNGZUpTPWUkeBcRSTs1rCR1tk=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1778044652; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=gffulxOArRAipIgbJlt1HnidYx/4fODZLq6S9dioK+E=;
	b=gPOBWIOvz1DyTwUgHIuveSW4DjWnn46rztCC6TtMg/J7ju7Y+neBF45CM8QDZUluOsS2LC4VRvpFbKndbAn45pLJftcewkfk5+ro2FVuRi3Ic0cIsnQI5UsPQ48xgZVgc0DT+DAp+0mrkp6mkj3u3q4UyJN9oUIMAA3V7CjvUb0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0X2L3DDf_1778044649;
Received: from 30.221.149.158(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X2L3DDf_1778044649 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 06 May 2026 13:17:30 +0800
Message-ID: <8fa3ddff-b717-4804-b524-9b2c0447c60c@linux.alibaba.com>
Date: Wed, 6 May 2026 13:17:29 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/khugepaged: clear MMF_VM_HUGEPAGE on
 mm_slot_alloc() failure
To: Ye Liu <ye.liu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Xin Hao <xhao@linux.alibaba.com>
Cc: Ye Liu <liuye@kylinos.cn>, Zi Yan <ziy@nvidia.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Andrew Morton <akpm@linux-foudation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260506012130.9306-1-ye.liu@linux.dev>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260506012130.9306-1-ye.liu@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ww8pf11ckf6b7wxf6mksqix5yh3p9r7k
X-Rspam-User: 
X-Rspamd-Queue-Id: 4EA5F1C000F
X-Rspamd-Server: rspam07
X-HE-Tag: 1778044654-432304
X-HE-Meta: U2FsdGVkX19mSQdzW3KAPFSXZMKJIjrB95ikqeN288qJCt434Q59IwHAYANAELE6uvV989xbwIKC9U0/vslXZB4+oTxEyJORNqISN59clFaA5PF6OYpZwT2sGLjIDJh/5yMTeQn5+aS4pHAD5MY7+/yeVfF6cpOghRlA05M0QB3HYpZE4/MWUvhLADcejN05xO8hbtQNuT/176dX/4Mkf+3twJZ3ZPHwuPfxMgQCm1QmWFSzMYYUTXf+gECkyW/WhaR+zM1bqEcaL+hlkiaXWUNuwVD3kLSV12gSs0Ern4cyUSeO9/mkJrVyhnIx3jQUkWh/KefayUM5TtCvq5oT4Rv+EIpA3picEmwMPMWfRqF72RoI0AQlyNIeztO/lh0A+TQyLNpv1phe6psCP1xj25um4++/pGDrcVXR3mNYRePjvwwlNbAbesv9Q0s+dFHs3HY1Qiv/ZMPh1GuF9CPgQGWpPJveMn77NQ9F4SQVvfoblZCh2JvwT6JDIvF39rzskn2+5oFBa5uKhy2qGD1iNhB8fVLjH9zxXeZqOym3vPgMgjZA9/jpMu8Q9E+Ll5W2PnWXAq78yls5C96Ai5JxpnhO+yESIBtAbshnkIH8govCSRQw88YIwLtrR26EzXlZhsB06e7YsDsPMiQvey2W92RmywqmGRLhc4TigEOJ/c0QkgkuRgiR9Qn1xOxbFRWkfYXna9lIQyfx/G1TZfvBuCbl5fz26sWnaLYeKTORXYFsXRhy4iIvjlnWXEoMLNBUjNChR/Q+lzuWWBa5e6N38L4Y5B7vqNp8PVuBLcIBtym8gOgR6wMpOSR0shcV9FmWp3BV09EePiwHUSzQtf7/rIxgsAj9eeTHuY8zMEfb6+Mm2QdPQYNDRTipBKRM9aTeiHnv0poMo+c0xwRx8lMg75tBGB7oGSGIF48/cjOSJkA4tu7EZfLQ5We5ZDCt4cp5tCeVfYwGqib19k3dq3Q
 CbnyWDLz
 QJKMFAs02vriYkgnoW1G8l+IiJsP1k1hPeSC719nuae53yPX/0N2WWhk77uRvJ+jU8kj+4Sdfd7i20zLdVtayaQZMWvEmRvoZl+4Lnva4yLZ41LToCw0A+XNpJOJb/PCms2RInJntAUVWq0YcNGb45vcvrpPgDIBkC2V5fKgY32CBbBmGMCEQXqccMBgFZ1fk5Y2f8rJpRjk4riFZOn1DbnPVLPIisFtkHukW1lC9K/lbjS6om2CgfRQ2ZL7QTuQQAdYi2U68yU+qOuvQ3nwNYGSR4tiLwJ+aPu/5x9mCIcj5JFzCzj2yZJukYoHPJjdsnBGJcGR6C9zwG9ml8ao4tVlSgRhtzXdmEQ66Z1tuhHDqtbgivas5K4n9RQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/6/26 9:21 AM, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
> 
> __khugepaged_enter() sets MMF_VM_HUGEPAGE before allocating the
> corresponding mm_slot.  If mm_slot_alloc() fails, the function
> returns with the flag set but without inserting the mm into the
> khugepaged tracking structures.
> 
> This leaves the mm in an inconsistent state: it is marked as
> registered (MMF_VM_HUGEPAGE set), but will never be scanned by
> khugepaged.  Future attempts to register the mm are skipped since
> khugepaged_enter_vma() checks the flag and returns early.
> 
> Fix this by clearing MMF_VM_HUGEPAGE when mm_slot_alloc() fails,
> restoring the ability to retry registration later.
> 
> Fixes: 16618670276a ("mm: khugepaged: avoid pointless allocation for struct mm_slot")
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> ---

Good catch. Feel free to add:
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

