Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAF79CCA476
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 22:20:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EBF98E000A; Tue,  7 Oct 2025 18:20:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19D068E0002; Tue,  7 Oct 2025 18:20:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B2E28E000A; Tue,  7 Oct 2025 18:20:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EF2DC8E0002
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 18:20:40 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 82FF057A6E
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 22:20:40 +0000 (UTC)
X-FDA: 83972738640.26.8B9EFD1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id BEB78C0004
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 22:20:38 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=dKlpeR4t;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759875638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ubKyS9+WOD4ADhorJhZH4YLRDD0ZI9B7NfREm9TBQM4=;
	b=w4rJi2YiDIV8mGzE2pHRVxgAoUWmWgTgNglCzzaOu1WfsPHpHu97tz445QeQxuPDCOY1S1
	JL0LzqrUXtnAm+BS8BiLBlZhEXKgT/9HPuH1HOJVuJPJ5f0AVZk7gvbF6SuaQKjyTH8S4j
	ny5e9v2/+b9u06AMMowQXEqpnV2YbE4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=dKlpeR4t;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759875638; a=rsa-sha256;
	cv=none;
	b=bJjw9LUjo9HxzhTiorz879NtAgmBh6pc2D+KzdUE1+wZs/2xE7L7yCZy777z7fJ4VGbi2H
	wdiqbjk9VK9PPxLVu3UkX0O25fU0mvHjDf/+kbXJDQ9RKmAJ8pMqJHkGXmZxlYq4H8Gh+v
	fDd/jXmabmtPmcje9RIvopbMpFUo0/I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7C9FE4561A;
	Tue,  7 Oct 2025 22:20:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E19A5C4CEF1;
	Tue,  7 Oct 2025 22:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759875637;
	bh=ejqxn+rROfDejbjt7kGS4MM5j0UztDEA1dWFkPHb7eU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=dKlpeR4ttNe0GHtMivevZDFXOzfWLOpqNCrqVdWGYwAs2uNWQ0+g4RGP7XPdg7z6T
	 r+DnAqFDbPLKpCLvA45VdLLiFfpPLvcgTMOHbyRSf2023g9+u6UmyaVEtgbO+SuPfb
	 iz2ejQlf0NHo+U0nuXs9ouZ/vb5fxYGZ8C+y5dbM=
Date: Tue, 7 Oct 2025 15:20:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Kemeng Shi <shikemeng@huaweicloud.com>, Kairui Song
 <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He
 <bhe@redhat.com>, Barry Song <baohua@kernel.org>, Chris Li
 <chrisl@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, David
 Hildenbrand <david@redhat.com>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, Ying Huang <ying.huang@linux.alibaba.com>,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 0/4] mm, swap: misc cleanup and bugfix
Message-Id: <20251007152036.cfbd572d706c40ed79d75642@linux-foundation.org>
In-Reply-To: <20251007-swap-clean-after-swap-table-p1-v1-0-74860ef8ba74@tencent.com>
References: <20251007-swap-clean-after-swap-table-p1-v1-0-74860ef8ba74@tencent.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 4hah61dng4uxg4m8fpzwecbsizeixd47
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BEB78C0004
X-HE-Tag: 1759875638-208882
X-HE-Meta: U2FsdGVkX1+0V7M1rYxXblbdEA+RZavNtvbYzAuYSx+nk2E4FI3yKw8iutV9BUXcNy3Fd11xq2ITAtpNCjNZhPY5yhcCVVwCBTjUSk3FIoSrInsFpSeyUFSWRx8dCZueU/mQZfOzwgoVFgaE/HoDdk9O7ORM30HHm5eAwzbIW0NzrNew9erluQsFTnsFEjlqCHXblxp8IYi1VQ+9d+3Gr+XNKIrUkoc8O3ojQ1kWTPSRlpz+nGnAelN58lfd+Yf7b1L6FV4FbKt1LYmXzezwDSYVn/BfadTLVT80RUX7oDBIQF+qs6FLrjqRxE/ILBuEB6+hqnQN1a3AH19UdFPyLcRZkTjIY7Y3sheCK7K1vTMtmqn5ZqOMCUY1Flm9eHB8ftJt4kqob858xle2gEckGGBziL0A8aNXfbTEIyw+R96k+SjmaJko0hcroXZQ7UF2djWiDXjrzAqhDMyy7CpnZiABIoA3mVNeWwebm1T6WpXK4oTReur87AuvM0JxUz8cxRDDLUgt4Q+Q46jHgURz8ZAFsGJUd6F0lv7R/vvgYd/ubhleRI/iSzITPQz8NdWYfL5MFSjQgCd35BUmoRpGpHNPa10uAXj8lgsowSSF4D2A/nt+eoXSBbvtcHtl7Yob+fAeT4DMXjSpUFvmZtA6Z3DC4T1oEl3nZoj+SjTxz7+0QjXUm9Cdke7gtanJjftarQrtJ+LYdoV1mGK3soiXnjBIfj384WgZ7g15jIpfEQDrrti4R1oGn+6PHliuJEXXRTMdVZP5ZUOGkjLxry1G/EipeRa7RBdBTydtFmbY4C/Wi8OYkdOlbphASLgA1R6kArizRCCAi1w/uKmNNk9uNyhHCVrh12+YyZdMx+zasOxr+K0zULux33J4GOyMdi5iuhU8KcFToO+3a97aMDSZatbavwrKfLx5TlIMfNk6GBPuW/NKlQeHcfbt7YOYWTX+SlipvLhvQ8ymxEvhzjL
 CttkE6G9
 rRQPE3icHP97M/6D+MoQqNksObAjUQH7ipXeE8mKgXF8xNO+htooGVR6Ywd612ZWrqkHpAQIcAApRZ/1lFOTFb7zqAuTkf2Ijhjm8x6KuOdAHSTBu6VNahhwc3MQEq4KzYuxoiQAOOkAuRojdQVqZlxcZZiRp0fs7t0vgaQC6eTvnM5YQOLsy9k9AVOjvx5BFD/TjTcwNjSU6JyL+fED/vGcTh6kCLwLyiahEciihiAdIv+3QoA4lblljgFT6e74gERFeoQk4C8FDwvjeSpbCoyp5yg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 07 Oct 2025 04:02:32 +0800 Kairui Song <ryncsn@gmail.com> wrote:

> A few cleanups and a bugfix that are either suitable after the swap
> table phase I or found during code review.
> 
> Patch 1 is a bugfix and needs to be included in the stable branch,
> the rest have no behavior change.

fyi, the presentation of the series suggests that [1/4] is not a hotfix
- that it won't hit mainline (and then -stable) until after 6.19-rc1.

Which sounds OK given this:

> So far, no issues have been observed or reported with typical SSD setups
> under months of high pressure. This issue was found during my code
> review. But by hacking the kernel a bit: adding a mdelay(100) in the
> async discard path, this issue will be observable with WARNING triggered
> by the wrong GFP and cond_resched in the bio layer.


