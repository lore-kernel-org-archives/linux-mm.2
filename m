Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4800FE9D81F
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 21:01:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F2916B0088; Sun,  5 Apr 2026 17:01:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A3936B0089; Sun,  5 Apr 2026 17:01:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B9E56B008A; Sun,  5 Apr 2026 17:01:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1BDFA6B0088
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 17:01:36 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C33CFB3798
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 21:01:35 +0000 (UTC)
X-FDA: 84625723350.27.15A367F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id EF4F7C000D
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 21:01:33 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=WAiib2j4;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775422894;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xD2ijl6kjU9Jufm4HD2R+RdNN77vrLnwYQ35SAmnE3E=;
	b=7mA1VBAaOc4UtjstsZkspDB5/MC/vx8o4I84FAY4LygQNrIEh4Apqhf8Ij0t0RyUXRM52B
	mHNOuPK+l09pRQlp58jIiuDS47w7nv2PQQKr3Y28OmV4Gl4FIgyAPyfv3BL8CDMxQiyWLA
	qUNstpTI5PsSjRspZEMDheVC/AniSIU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=WAiib2j4;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775422894; a=rsa-sha256;
	cv=none;
	b=UUiunabd/qrndLhqhtsUECUQpS1+Hj7EiarHERR2xm9gUr66f/acJtba0Lbti134g07m0C
	3AUjewqaRtZWo96fSk6c7mlvLvXwJS6B3Z3314agbWfvwZrEvH3fz/UIE6Kr5gWAUsQy3D
	Raq1T/lDg/wsa7/oTA9JImFuwActqeA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5561F600AC;
	Sun,  5 Apr 2026 21:01:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE279C116C6;
	Sun,  5 Apr 2026 21:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775422893;
	bh=oFxLOMzSfEmFuQzpbU2wJsRXZ/L4FJB5kjwFD8u82vI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=WAiib2j4dceJ0uQ6xwL4ELoWHNM3mk0p6lKI3lcYW3qRukS3sgrwt4wlrfBcwN6m+
	 P/uk3Ur9qCeFo29pVB5J9R7WvkGxVPrT6hI/BzSTeXbDNEsvRr+QY5uPinFM5OOaFi
	 uKp6uh+6wiYXfB1ptl0Mr/ddZSHIb1si9yBC9/rs=
Date: Sun, 5 Apr 2026 14:01:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hugh Dickins <hughd@google.com>
Cc: xu.xin16@zte.com.cn, david@kernel.org, chengming.zhou@linux.dev,
 wang.yaxin@zte.com.cn, yang.yang29@zte.com.cn, Michel Lespinasse
 <michel@lespinasse.org>, Lorenzo Stoakes <ljs@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] ksm: Optimize rmap_walk_ksm by passing a
 suitable address range
Message-Id: <20260405140132.3a518740c6c1d68843f44aaf@linux-foundation.org>
In-Reply-To: <02e1b8df-d568-8cbb-b8f6-46d5476d9d75@google.com>
References: <20260212193045556CbzCX8p9gDu73tQ2nvHEI@zte.com.cn>
	<02e1b8df-d568-8cbb-b8f6-46d5476d9d75@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EF4F7C000D
X-Stat-Signature: omemu7dqwexm9yq6x1pp8ncyxbts8zpp
X-Rspam-User: 
X-HE-Tag: 1775422893-609963
X-HE-Meta: U2FsdGVkX1+TJpEFG8TJ/HNSx1RvxonYicELmevUukQNQDs4w7ErHB2dEQyPdcHTiWwKK1R6TNrAUhTfLCaghOu9yMHV14ewStC9Nun5t5micD8nniDDcsfemnQLqAeT2HO9XD9SlW9ynC7bL+A9+y6OkZcsnRlnfopRDWR85o+heAMcoq15MZqD3zWI5JXbPAI7tnxuY+wmWy7abfO47N/uSaL4X8ojYBMJ9NzBxKlDLx82THWAUcZY3PP1Q7u+UMnVPzotRxrEx5+DzpL/hAHvSdL7KyK35kgEx8sWMgjgLpmyFeUvXXwQFEes+S/F0ARX8+oKY/GbCf2cNihtK9bO73KUDvN60puxjiLvf6AW1dqwv0fop12+ImBeTZUj+ZGjKsteyc19d5UpjLs903UeUvO1vo0qiPm7iwaQsIO0/fDf42fDDPCwvthtjvhrXZFhuy5n92j07z/lBhkrEqxWhru+X+JCBmX8eXgriyJ31Jo3xriZNy33tbZF7prujU51R39OO/+d7vbnRO3ZNrLtqAwFotLGzLAOd36W7zbc1L/TJ2+tCrktLe/I4f4PE2nSspzMvlBtGAe/1HVqYOxDYErZbFlp8p/KTFaD8viulzxcm9lHpC+RYFYupTNWPS7KBsybTkFZuRjmm0uxmPK1us+Y2gehSuwwXNgNGRMue6e1KQKfmfx6o69ZBZ1C+Fc1E1fVF3bZIYn8zp5SeOw2YjtZRHPnQ7aD0shvc7U9yahkvTZFWWPWA4jb0ayTy834PXXV34dURdvEo46hM/wOFlg3fikUUv4I+/nU69tUxPnhntmqUdmKYKTpAWW84s/APnF6CIfaxGoIbMzSras3kJ7M9gblRhu/UfU8k/GP3Vx0+BkJXsUY6QB5FXWNJah/MjUYvn5KukzoDZ5j08UCnuxhmvZf6aGEOQdyoqYHxUio1EWqP32/OWLgImbCWgD/FGlHDCCxWM2vwc8
 BdBEUhWn
 1BHZK0YSK8ZYDlY0U6LW240hPrd/va8iDd8LvJxYJyVBFKa55V5lzaB9+blkM64yGJ8dgNuhvd2bC9u6reqOzZgQdIOPK2HbBxlmosbSsaePK9ScR1z+jcT+5lc80WpoaRZ2E/M5m0aYjsHkLl6/x6uKcUSfc0KeM6q2P/s6gKr3vUpEIfZzmnqCQxqMai/DxPhbwOdFm/IiKE5kni6aWzNwbg21oStvVhzIPfko8H5xuTWw6poVusaUF9fw7ZhpmL5IVhp1CMbYqkUCsd0c+zzUq8LJsMrG7b2e6gMquxf7DbQ/hTzEQ/ErQmfQjIu+6l3zM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 4 Apr 2026 21:44:14 -0700 (PDT) Hugh Dickins <hughd@google.com> wrote:

> This is a very attractive speedup, but I believe it's flawed: in the
> special case when a range has been mremap-moved, when its anon folio
> indexes and anon_vma pgoff correspond to the original user address,
> not to the current user address.
> 
> In which case, rmap_walk_ksm() will be unable to find all the PTEs
> for that KSM folio, which will consequently be pinned in memory -
> unable to be reclaimed, unable to be migrated, unable to be hotremoved,
> until it's finally unmapped or KSM disabled.
> 
> But it's years since I worked on KSM or on anon_vma, so I may be confused
> and my belief wrong.  I have tried to test it, and my testcase did appear
> to show 7.0-rc6 successfully swapping out even mremap-moved KSM folios,
> but mm.git failing to do so.  However, I say "appear to show" because I
> found swapping out any KSM pages harder than I'd been expecting: so have
> some doubts about my testing.  Let me give more detail on that at the
> bottom of this mail: it's a tangent which had better not distract from
> your speedup.
> 
> If I'm right that your patch is flawed, what to do?

Thanks, Hugh.   Administreevia:

I've removed this patch from the mm-stable branch and I reworked its
[1/2] "ksm: initialize the addr only once in rmap_walk_ksm" to be
presented as a singleton patch.

For now I've restaged this patch ("ksm: optimize rmap_walk_ksm by
passing a suitable address range") at the tail of the mm-unstable
branch and I'll enter wait-and-see mode.


