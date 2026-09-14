Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCE49C88E73
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 19:42:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9312C6B0088; Mon, 14 Sep 2026 15:42:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DAA86B008C; Mon, 14 Sep 2026 15:42:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F1206B0092; Mon, 14 Sep 2026 15:42:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 572926B0088
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:42:27 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E0C131A017D
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 19:42:26 +0000 (UTC)
X-FDA: 85213389492.10.D9428AA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2287D18000B
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 19:42:24 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=u5Mc5qUb;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789414945;
	b=8AcDufhQX0DMjU8THieakCi8HvX1/rpfhuEko/xJeYpzclWDn2LnOlNsPLZCUbpYpEnKMb
	41ZJwdGjvQmYDGaYVnaXTbG/GB+Hz9Gya8/AwTfD0zK1niZfQKmwktfHlpRJfWnbrBrZJA
	EwO+E/JD9lZtqhajadtILICn+d5uJHk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=u5Mc5qUb;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789414945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VZHyHjs3xvsqS461wD6jqghAtUtS45zyAmLcgUkikgk=;
	b=wd820UibuaQnLtILz7XMjdgJAGVT34DD9vRk5h/wV7bmueoKvefu8X2flDlIq5+RevvZHR
	0v+tLzjkfmzK8yfvdXEfbGrrDc7Ge8c2Ig7wmVMOlzNZX1sdYtl9gTu2C74nXRlnze3iSs
	r4KbysS3LxWZa6mwKcCrwVpGI6Y2GWE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3526A40291;
	Mon, 14 Sep 2026 19:42:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D04D81F000FF;
	Mon, 14 Sep 2026 19:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789414944;
	bh=VZHyHjs3xvsqS461wD6jqghAtUtS45zyAmLcgUkikgk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=u5Mc5qUbS7NEhe8bppXdcDc7XkhOtoFC4dcsb/+c8qJGJhcaFjZ8kEE5dxQYvMRgh
	 V1dbnfQ1u50rxYcOVWMdWHxS21HBYSrOpS1c9dP9/n2LPiUKIriz/1hiAwgomg1leh
	 SHE9anYXYz7Kyzcu6E0b4pDNo7nrHzKK9jpyRZuU=
Date: Mon, 14 Sep 2026 12:42:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: david@kernel.org, liam@infradead.org, ljs@kernel.org,
 linux-mm@kvack.org, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH 1/1] proc/task_mmu: remove unnecessary inlines in
 function definitions
Message-Id: <20260914124223.3ce35057f35313d7c2a6254d@linux-foundation.org>
In-Reply-To: <20260914190631.3167420-1-surenb@google.com>
References: <20260914190631.3167420-1-surenb@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2287D18000B
X-Stat-Signature: me9kyjeyc87uuh53nczkgjfrcs13s3oz
X-HE-Tag: 1789414944-237599
X-HE-Meta: U2FsdGVkX18Kh8+OBLAJZe/th89KQwsswl72/rDsKQvJhHtMmQvOwrdNljgxFhbYB/sfR5L3UTseTaEc8/E2/+nVhMCgvStNpjNSn6FVHX/2syiIh4/rijZzjgvmRKdKpH7cPk71lNSe4FDB58fQdeDgj6IF/PyuNhr5hHnIyPWDzAiLbhY2DO1XpxXgAjYwd2eMv2TBrB7y55B7k7hNNqPtd+vnCPPm2Q+iNNOMKsHuqCmBWeNqONzP6tCYpnUQ2qFKatoyWr/MBzvI9I0K44rojuyo95rXXP+2H1ZfUULMP7KIRCbqOGbUw71HvLA+BVlogmc2n6OeF4wZnZbdO2ggvWhDw7DLrtHlTQN+xXrFs3oUGuACEAHpkWZTCwrXySuKTLQ42H8iumtnTkyDR0AGskDCt7ov/qmakYuegnVmd0nBNe2erL+jP3GXPk+ySQnCvW2dbdNPmPjuwWCPxKJ6K7pC/7zjc/X4yv8avbR2lVsqanBjms4KNuL31M5AkYJlpOh+gQfCtgUYpwe5kyQS69vFPfKwSax2d/Xitii+TRd899u9UdC1+g8/JR6z/EAs+jGQXfcd+TTQIOFQisMuHE+HEj22qp2/8OxrLPNfdqGBm9BuxU3pD06xJgInoIeVd1WMdMP2oEDxnzN1Q+/R7hhB0M4+QHPsUU7+xYDlhNEBSa02bYvzbZcKChbsbfqjbN5Zzq571hrhyXNrAAnNQffyOcTGnf5MA7eWdPdSDvTToFdZWU3EkCsDX3pMG0SLAi5t/R/y3sQ2AHkbVAcW2PNe9q63/zeZt6YWjV1q41XeZclEaCH3txeBKW2GaxvLjGmUknpKkZ46iJETwzUb7wnm3qkr3T4o/XhQd1ZXUTBPcYSbmWGxexfuXWRpSuuma4PyamU7QL0MKmhKY7ZlIeK/XabthV0/HHj+9+6VQYW5OG94fWejqpClr/P62PEp8kxOdrqumicWMko
 myTRfYt0
 A099RCIIPpUxQkKEu+ssxEblZimIAll0FQ/L5Ql5jd/impbKSk1dsgBEQj5YwcePz7bWiZzi7rebPN0SHIA1eAwTR9oAY6rheQ9IJepSyrhOQDP6grSV4r4OPBkoR0drQ8i2VDIERGjfJjsNYtsynt7rctpFsTug0Ilid9VwDLM052R3NlfthaZUEbGDfeyagrWoGZ1tpwuvjd6IC6bQFMRz1pGJL23GiJPeH31kVHAmN3znwbhu/5EMOC8IuNMrHp1e5tT4Dqx/xkHXgJmwiX1U5IJc4/OpGeSQDLE77kF/gFkck821yakPJ7pYOO3HvMbBw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 14 Sep 2026 12:06:31 -0700 Suren Baghdasaryan <surenb@google.com> wrote:

> Uninlined drop_rcu() and reacquire_rcu() functions are not used when
> CONFIG_PROC_PAGE_MONITOR=n. Exclure them in this configuration.
> 

But there's also

fs/proc/task_mmu.c:133:12: warning: 'lock_ctx_mm' defined but not used [-Wunused-function]
  133 | static int lock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
      |            ^~~~~~~~~~~


