Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FAAB606A32D
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 17:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=waFuifm7
Received: by kanga.kvack.org (Postfix)
	id F11B86B00EF; Tue,  3 Nov 2026 12:57:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E99F96B05B1; Tue,  3 Nov 2026 12:57:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAF306B05B2; Tue,  3 Nov 2026 12:57:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A778F6B00EF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 12:57:28 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 24DF61204E1
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 17:57:28 +0000 (UTC)
X-FDA: 85394564976.08.D9CD646
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4E52C180003
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 17:57:26 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=waFuifm7;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793728646;
	b=5PmbqXELRr1v2JtylIIj/jlWfcGn8Lk5ldBmoF9cvw3wD8uNmxCaBu8SBpo1t0Lsa9rkLE
	9jA7lACBef5o7aVK9LQberEgUdILElbPacnhkvSpBVLFMyfSqBgF5LtKwWmk3fuRlTwQWb
	6ltgin/i300wGsnPF1109O/Vplt0mpU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=waFuifm7;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793728646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IGmL+ZljixARqtR0vy4WmzIc1Mkr9YWBmXAFCIeNys4=;
	b=ZlR1OQ89QmgjDQ/TWOQcfqsaAT1U6EwPpaNsTn0dY7JNJ5HU9vY34gdvPkwuYOMho5kWsh
	uw9lBaXK/38nMEtD9bc/jCAU3njutK5lmTdJEBwH3ZFiQL2FRpaVKIBKdevV2MaO4bwtTl
	h7WAGGurF8dCAY/E9X2xaLz3xIxwtKE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7E733601FF;
	Tue,  3 Nov 2026 17:57:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEBC71F00A02;
	Tue,  3 Nov 2026 17:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793728645;
	bh=IGmL+ZljixARqtR0vy4WmzIc1Mkr9YWBmXAFCIeNys4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=waFuifm7N4OvFbskcsoefmRTTV8x8v4OheEyzLyc5+6fzDH8tPZ4p80fqJvi6rdjl
	 NsE741KnL22ypektEwLwemg9xPYUgk7lqmWkN7l5xULzODgMX3eiL85/iIXTdvzLc9
	 gNkyiApQR5T9feyHMFsaOuW8/IBXsa8slAMJk5nI=
Date: Tue, 3 Nov 2026 09:57:24 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Gregory Price (Meta)" <gourry@gourry.net>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com, ziy@nvidia.com,
 joshua.hahnjy@gmail.com, rakie.kim@sk.com, ying.huang@linux.alibaba.com,
 harry@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/mempolicy: recompute automatic interleave weights
 on memory hotplug
Message-Id: <20261103095724.0d7e127da59bf864cb10c156@linux-foundation.org>
In-Reply-To: <bf910739-a85e-44aa-9f13-481e5b6c3336@kernel.org>
References: <20261030161234.1505367-1-gourry@gourry.net>
	<bf910739-a85e-44aa-9f13-481e5b6c3336@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: zyef437uxjdi5j38kdg7xox9mtzjymdg
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4E52C180003
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793728646-94664
X-HE-Meta: U2FsdGVkX1/KShQiTnm0GXAstuO/gHwpBtT8WeMiLJIyMCgsod3zFomJk5DEGEGZLUHtdluxoQio5g1RELjnxHmKZqDl6DuTOXp/FFYONJk7k7L8CwNE4omBZUYuvmusRq5RNkEmp9YymqG0SOVHMq3HLKpBqZDuRHBKmfbKyz8aJOvL0QIOUpW24OviHmIdxhEhLRPP4lvma/56JeBNvITIJOBiElsSc4nNGL9I4IGeaj5n4Nd8WLsOCcdy/vnt8/QcojmVXUmqMqTC+NnEVdtI8/F7CM72bemzhBShqJnbISGbUEzP7xNOmgdU6uqzMu7LX8JZUj4pib4L0HBwl0TPl8L9Ec/zFBbKUhA6c5Tt879cpkxKs79gitMUhrSxIMXshCqiGvdTeU1RaCHaSV2e4OQGSGcyvEDLIAHzt5TokS9ootB9dSK1yivR84rtPr/2QfjEsvkEW3izcvPYAmT0QwRUuBddgDlJc5slVmGt+JS7ajBaoetKDdvm93npQZ9FUVxip1Xh9hMu4Qv6dGvvN+y82xR3GJ44oibenU/9FunuiKf9SD0RZpu2iH6auUO+4G/noaNJTOHRIfTHDUiHdaKia8wOlV0LPl5boZqqnWyOkjlqOZMMi+zxWdcw7zoqWZMqioMYQv0qUfDkHYYrx6zq00hrNScFmnBdxP6I+8hBudHTd6TMaR3e7L01WzeuXFFYP2Y106GhoLyp6HFgjzZCYLjwXedGhlYZvO+F+I0Efkbu55D5p54+OUYDd0Ks3CnyTWAzP/R+PQyNlkwollB04w/TIo6Z1z1Hd2TAhfsIAYdJPSNguw/0z6Yo544zjh3AGUwblikuDBvWBuMxG5KYvtsyl4fuvBSayv3WKyLoiWUv0nOTVMx9q2+r4sK+Q2AbzMdNBM/HtS16i70c+QiDT5ZgT2DblPvRtGEG+3Zk9Kj51+JQg7YeoeNFidyUFPbddueu7HSpIca
 AS+syYqG
 UxCL/wCc4uq2O6mQ39nfzmgGMaSX+vuvPCKQdc5GAVPTAkMPDMbn1WOgS5wKnV3NUsW2fYDKkg4hgXqG/zrxqSoxX8Vl/g9Ixh71pTU2m21FApUmTszQREsbXQqKe+mnJtSkpg1Q4Aqjx/t9l3U+7nJMyYJhay0m5f9ZHPVKMSXCu5V5jVFVJxgooGWzK37WeQ+MjlaEKYLSfWYUSDcfArI/V6+oUgJyIUhDKi8JVJCpi+nvxmlK3zrxWmHqWgLWW1bIQG5TmCVA5YSOJnJcDH4LO8GGu7ILIHTQO6SylpV2jgKfh/CIChr/47vmvVzeDi2ipVgdvSeq29rIGzNmdZ+0fblpKnNMJXyt3MBKgKForMgROyN8+HDr9zUm/AMheLWGIJUnSwwu4QynfEikt2Vjrqg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 3 Nov 2026 17:50:48 +0100 "David Hildenbrand (Arm)" <david@kernel.org> wrote:

> > 
> > Fixes: e341f9c3c841 ("mm/mempolicy: Weighted Interleave Auto-tuning")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> > ---
> 
> It's a good idea to spell out what changed (and why) to make review easier ;)
> 
> @Andrew I can pick this for the next merge window, or do you want to merge this
> through your tree?

Go for it.

I'll drop the mm.git copy now.

