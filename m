Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0164CD2D11F
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 23:23:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43E816B0088; Tue, 13 Jan 2026 18:23:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3ED366B0089; Tue, 13 Jan 2026 18:23:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F97B6B008A; Tue, 13 Jan 2026 18:23:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1ECD96B0088
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 18:23:00 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D175558333
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 23:22:57 +0000 (UTC)
X-FDA: 84328517994.12.A62D6C8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id EB4DC100004
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 23:22:55 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=jTxaJJ24;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768346576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ODKwm2JN0NEWBWB9q8TKr+KHAe9l0HDUD7amjZNzhT4=;
	b=ffriIArCLbqK7mZ1t1ozBeLIJPCzX1/PupvWxrcDnNgT2h7/prlGrkhwHoa1NBm5lyREmS
	tsAUJlLxVuKvHNReoPTNlpR+QchSNPKLmXNULge8bdGPcG+dM16DyNaofZDu4qJR1j+wNN
	4/GFvrqXFyUbCvz0l/NJy5BWNUxvojo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=jTxaJJ24;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768346576; a=rsa-sha256;
	cv=none;
	b=g/+V9z5PTK10smNOGCUAGCSlPHaenryMjMR6VXWqe4ktw+PFAlNfqot0KW7xTuP43Vn6Cq
	HMKqcf7elNWnOT/78WL9YN8IrNSPbdVC6hfsJyJeS3SEIa7WAoNczB/zC4biRvdUGTr+Lf
	TI3S4WgtUDmY8rlun/SOaKxYFV/L9pY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BBEF3407BB;
	Tue, 13 Jan 2026 23:22:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1926FC116C6;
	Tue, 13 Jan 2026 23:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768346574;
	bh=e71X0tIjU7zryKdUaL1J1tb5+Yoiu6mp6t3H2YfPClA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=jTxaJJ24ijFv/MNlUgUXfxgJFteRrTLE6DQOhP5HrCTGTvow3568VtcsEETBKNG0S
	 c/pRhjcEiBl8+ZWGaHP6IXAFCFAehz28ufYRNvJ4wSmWhTQpnqQj+jwoPlzCSTMVo0
	 I2SDBvXlIJi6GnmE7EO2aj5Z1abNXjU8KYGTlRqU=
Date: Tue, 13 Jan 2026 15:22:53 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jane Chu <jane.chu@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 stable@vger.kernel.org, muchun.song@linux.dev, osalvador@suse.de,
 david@kernel.org, linmiaohe@huawei.com, jiaqiyan@google.com,
 william.roche@oracle.com, rientjes@google.com, lorenzo.stoakes@oracle.com,
 Liam.Howlett@Oracle.com, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, willy@infradead.org
Subject: Re: [PATCH v4 1/2] mm/memory-failure: fix missing ->mf_stats count
 in hugetlb poison
Message-Id: <20260113152253.4438f2eece9d01c64888c25f@linux-foundation.org>
In-Reply-To: <20260113080751.2173497-1-jane.chu@oracle.com>
References: <20260113080751.2173497-1-jane.chu@oracle.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: EB4DC100004
X-Stat-Signature: fatennpsn7iqut85pszg9dudcnm1tmem
X-HE-Tag: 1768346575-302815
X-HE-Meta: U2FsdGVkX1/YMt0l8VBC0HFabFI47sffhsx6ehl2MXzA83CuZF/PH6kY3+A38yNCVAhwTOSoHo/Hi5lmMtHTVtrFRFIGTtOEUX9TvsaZZKLLhPg0UIqkJunLEG0FTemv7AgRDpZPJQhdHl9lvUlwR7ahgjmnA3HdYYgahyqIZY0njJaIxiOuVI2o8CXejXc7YxaYaPYyVyz5xRHHvk6Qv6bybuL7HBkNEd4RaAxXUCytcpGTYB6YOsm65e2bpcvutcVs5cUifmtOGmww7ifinq6aSi/WKvdkHizKaAV9dXvpkTnjnCR6Gz5pt7AdxAiLBJC/CS3pmcu/8b7bakN9r0FEDSWSWhFBfrc0O2ii36E+4OwLxXGSuJKNdkwtpkrTl+imVcuPtLS6lTJHzx4MqpeXs9QwbAxMAks+uCuRMBe1/kAtBKz+D3LasCW6SxKa7vLLPstaon12bWsM2w8VDVSHoqGMFCuVrdnpEOL1PtltBxrT4cVKiwunMENG+9c55v5jEJT+aHIRngsb62F1TPzObF9w9pY7I89QYNDGOA0QH4goQL8YRs7BWoGT7b5lf6umEEBbeVrZDBcDSo0QknMldTL2GGUEgvqNmzTleqb2QtHFwuzvEOmldX7mk2h+wMs79NYKtpD/YM+dlPxdWQgJeMNjFaQukK1NHo0sXFidIfkiRrrbSVgbk+XqQBqXw4QK93Stj81clmm5oggg6iykShxqmmTlM+mgxNN6JNycpqjE0nFKYuhGeUyk8vXDLTODY+Ivd5R1cagRy76Z2sJZwVOKdh0vq6UwZjeq36pOihe0rGCpOBYN8uO0ilIxfqTEJsbeGFoJebjhEL0C3f8uevoOjsWjTizrhkP5cChKgBw961viH8vpxacryicpW7gPa4FV5K4AULe++ptcrdl9erHDYjCXRv3As/0o6wT7l9GclJ9Ipe42tgsBaz5dB5bP0mJJMyhCAj2x6kY
 e9eqD3mX
 TgHQb6H6C7jS/yTpcHygR0i9dOvYcSYFMsbPaJKgi2XFbOtlkc09W8mfFBZcFsllJPg3TDuwqAXeOS1nzv8c0c9FpTab/64mnN1andqcRbRygjtWWS5JajU/sJCQkOtCE0SlHvKlXcTlgoaDGvcURpUtqOrMiOKz5ApQyWC1fKloSL5mMV2li6LhELrTgX5nXPd+Vazh8mNB5R8ElpnVptLMZR2kYEsZ4YSiWwaUIjcS5qOdY/LNnah3j5obUzBJrtiPRqa5+oXegX51mkr7oXDo2TOArFbNTOPqoC1uepG32EWQqjvaNk0RG1U9SzzVocPbI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 13 Jan 2026 01:07:50 -0700 Jane Chu <jane.chu@oracle.com> wrote:

> When a newly poisoned subpage ends up in an already poisoned hugetlb
> folio, 'num_poisoned_pages' is incremented, but the per node ->mf_stats
> is not. Fix the inconsistency by designating action_result() to update
> them both.
> 
> While at it, define __get_huge_page_for_hwpoison() return values in terms
> of symbol names for better readibility. Also rename
> folio_set_hugetlb_hwpoison() to hugetlb_update_hwpoison() since the
> function does more than the conventional bit setting and the fact
> three possible return values are expected.

Thanks.  This looks rather different from the previous version so I
moved it to the tail of the mm-hotfixes queue for additional
test/review time.

