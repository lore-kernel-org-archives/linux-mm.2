Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D418C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 14:27:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48E606B008C; Fri, 10 Jul 2026 10:27:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 465266B0093; Fri, 10 Jul 2026 10:27:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37B686B00A5; Fri, 10 Jul 2026 10:27:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1C2126B008C
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 10:27:21 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AD30416963A
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:27:20 +0000 (UTC)
X-FDA: 84973094640.12.C56BBAF
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf17.hostedemail.com (Postfix) with ESMTP id E02DB40009
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:27:18 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VGzwAx5F;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783693639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9FmCT4DwIHwttEcyHwv/ZZbQpIwis/aYjRLRrseNeWs=;
	b=5TRpsRZzF0uWE8zx6d/HCV5JRmiD1X9d0eu4V3bpTQGcwXBrXNVA8AM0MnunnaMVjMklTR
	h7cbartl6y6xWut2tuin+b0MIo8MnPvMmilBgjD8WPDPtZu2cHz3Bv5GtKPOXWiljghEvn
	UVvHB71MTMwqmmfWYz69tezGmqdJhrw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VGzwAx5F;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783693639;
	b=EN62abzJB+YRxdmFJrNC5HJrkphMn8o204gCIHdDTj4tev7JTgbYYxr1HxuxPRLh2Tga9z
	kCzTuaZdCvVE+psiz9Zi80tquWQhYQhGSO/NftiDMmnfSjQiFtRWzvFJln0f6lDJnI9mvT
	WP0ODgkI4MIkHOZhVYc0xxae2fZKEbQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783693637;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9FmCT4DwIHwttEcyHwv/ZZbQpIwis/aYjRLRrseNeWs=;
	b=VGzwAx5F9rA1F82TQ32/LNbqmDdW9MBXQgFlolv3tLjzikFryo+koLfd4e11Ri6RX/fEgh
	1brQBf25j1rYr6dhlXnxihh8ETSbVbLnRofpN7gQktXR2idUV4BRHOEWcxSnpdhtha7tTO
	B/hXuJPOAPB5A/tIaPSHEyDUkdajXiY=
From: Usama Arif <usama.arif@linux.dev>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Usama Arif <usama.arif@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jane Chu <jane.chu@oracle.com>,
	linux-mm@kvack.org,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v2 01/10] mm: Rename folio_contain_hwpoison_page() to folio_has_hwpoison_page()
Date: Fri, 10 Jul 2026 07:27:09 -0700
Message-ID: <20260710142710.1067864-1-usama.arif@linux.dev>
In-Reply-To: <20260709184740.1286561-2-willy@infradead.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E02DB40009
X-Stat-Signature: kwdbyeqznwh8qwecdua73x7de11qkxiz
X-Rspam-User: 
X-HE-Tag: 1783693638-260788
X-HE-Meta: U2FsdGVkX1/zRFMED5z0kr0ncMmm7KHQJkGn7uvCSjHZhpmax6LHOQaztONyH7Z0sZReCw/jtBbYSCulh7wsYS/Q8hmOeSqGTN6SamyGKP9Idtn08equgW6XsxdfLqZ2UMjF9jYWATEUglt0aQi/l4enJH3IiDnxwRN5ImeWlQw1X/1wvEEOjMJ4pUxotMTwMCJnXL19pUDklgpE9J61sM1mcCnB/v8oD2rN4NGtSOyB3EDUYgUXUEC0HuS10tdvj6c99DzxEJdHtiVx7IDqWxvrAU5iNbmzAVP2O7Tq9anPeJflsLPy36NxgpE1YKzCIRsN9W/wPi+aYGREAAWi/OeBbLHCKrCgRSw58+puf3YkkkS0e92PwMOV3tVDt/xhkVGR5YOpDJloGoNi9luZ2nwXJN+tYScn3ahrEGdTZU/OKph1H2sH5146rrjCpKBWiE5wnjg43apHcsUgNhUdYXNBiGI5KqrjEAjvulZQsMlVodjd7jnRQ5tExNS77dp0n2AaFwmP/sRXYVO/CgUrtCFNmj4kLQOhot5wMq/ryCGEqyxZGFTl/hn27Ev7nFcItq0op8n+gy7nYI88oObyonH/7/SWnaiWlr4mPPMddxEQ9pyfchJLoO9B2s4WtjPNom3iMDWLQHa5FiRhQZQrUqqbl1MYuKV2dzw6khwfPX11uTE96xAIjNc/11bUos+owf25aFwSVY0Pmcdql2AZqnLeQLzeWc04fW7SFWPPWMHFBvdd/lN1J7tACFOVE0SNjLuGpo9b7Z7c4ey24QbZPUpefKNRsNzNk1ycHouwHnn+vmKBYa3Qvi2VjRhQQoYLBN48x2k4IiSx5VTtsgf3SiJDPxL7HCFHTpR819+aSOVxu5IeBp8fmDKOOL1nf9A4SzvbO3fc1JlqKWKOBvh64yAoHhFwugwK1jAUvfhISIjdDAR5n6A1tMEyswnIXJ9RphE2JnZ0PBBAzdq5rH6
 aawImHyV
 7BoyyejLCrHJEhZmZNLwoFjT6JgC5Uxremzn4tjaFzXa+o43am8BqV9w4ImR+uJ5CxSA+yFvixMfcQwECDEmy0o+RBshsnLTP1XQwUiZYpu7UvDdmkDWG4dUIVgsGCy9QXUtw9BGD0A3UexzzEL/Tdfw+P51awXxouNvCBbU9aC/ADOWqtGWdaXo9HY+GjK+QHLeHdiaiEpka9y7Coce7oePjs28gY1Gl8c8Em8RyStWfd3o/u1rWVsBTzLibmWS6aoOo6gPUAnZ4OuBj9fyHWtYrlHP/e6TKRKoduKqIGlSaiHTwp99pyY0JHRYv2jab04GDORtoT3vKX2DAezdv7H1zS3x5KTnB2146Oh6qj5lxxX4bGGENECroF5XLqIHxC7Jo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  9 Jul 2026 19:47:29 +0100 "Matthew Wilcox (Oracle)" <willy@infradead.org> wrote:

> This is a better name for this predicate.  Also make the argument const
> to allow other callers to be made const.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

I find it nice in review if it says No functional change intended.

Acked-by: Usama Arif <usama.arif@linux.dev>

