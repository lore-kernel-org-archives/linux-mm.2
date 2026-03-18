Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3258FCD0CE
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 08:00:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FDB86B0117; Wed, 18 Mar 2026 04:00:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D4F16B0119; Wed, 18 Mar 2026 04:00:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EA526B011A; Wed, 18 Mar 2026 04:00:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2D6B16B0117
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 04:00:55 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C478F8BFFE
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 08:00:54 +0000 (UTC)
X-FDA: 84558437628.18.6C2934E
Received: from sender-pp-o93.zoho.in (sender-pp-o93.zoho.in [103.117.158.93])
	by imf15.hostedemail.com (Postfix) with ESMTP id 58107A000E
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 08:00:51 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=MpZeDk72;
	spf=pass (imf15.hostedemail.com: domain of shivamkalra98@zohomail.in designates 103.117.158.93 as permitted sender) smtp.mailfrom=shivamkalra98@zohomail.in;
	dmarc=pass (policy=reject) header.from=zohomail.in;
	arc=pass ("zohomail.in:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773820852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UilG0Kn2TFWgSp6woEE/NFCFkjSyupPzRMtqI4OVI+o=;
	b=RBewk2vC+yUtMLN3xgH6Iu1UJcbGX8ySFgcO4F14SL+qm1eYpM8XbZZnVTEIOR6MwkL53I
	DlE07VuF1Ouywl5bV2bfDDYVNCKcZirej6Ag6RZvPEwWinHNmJ2a7jZ+B/jF5eAP88yr+0
	BqnIgbaNwPqDFiBwz523J47Aq3Rx4bY=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=MpZeDk72;
	spf=pass (imf15.hostedemail.com: domain of shivamkalra98@zohomail.in designates 103.117.158.93 as permitted sender) smtp.mailfrom=shivamkalra98@zohomail.in;
	dmarc=pass (policy=reject) header.from=zohomail.in;
	arc=pass ("zohomail.in:s=zohoarc:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773820852; a=rsa-sha256;
	cv=pass;
	b=xJViFV1icsUIE0aE2buZdT5J6wiRO/e4TkEDWv4nOq1bQQ5RiOiHhTxI8pka4oowkPFOiU
	9C+h6vhW/SOu7hdskHSUmTJRS8l4a2LjCKjFKKnf//ASdXjD3zfomcne6yIxvKgzGwKxpu
	owo/qVajzHEnJUfUz/7pkS0rf6J+jGc=
ARC-Seal: i=1; a=rsa-sha256; t=1773820828; cv=none; 
	d=zohomail.in; s=zohoarc; 
	b=Gcbb3/Y4mEkkVBR3KM0WlKeL5ASrDa3jklumh2rQTQy7QljFqKzERPVKyb6HThWUwmfoFeDxzlMzgAK/58AOGDqS9nOtSnFO8xFSTcdgDiRE53cyHE5YfRXWix6RkID3vDgDDe3ZFzAmU/fyx5AN4ifq+BQsRivihs3Bq+13z/4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
	t=1773820828; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=UilG0Kn2TFWgSp6woEE/NFCFkjSyupPzRMtqI4OVI+o=; 
	b=Ig+2GioJGYxd+ymcQ61lFp+vungCH9zSx1izOpluq047/xToRvnHEwfqLLZhULGRVmUqNqqIa+yeshdENOePtIGN3EkkDChz1OVTuiJMf5hcxcVQkYAb4rnRV/dhjn3v7bKI11AAOH9UJqyClvOuH4bFEtxYK/RQOfHO8nep50M=
ARC-Authentication-Results: i=1; mx.zohomail.in;
	dkim=pass  header.i=zohomail.in;
	spf=pass  smtp.mailfrom=shivamkalra98@zohomail.in;
	dmarc=pass header.from=<shivamkalra98@zohomail.in>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1773820828;
	s=zoho; d=zohomail.in; i=shivamkalra98@zohomail.in;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=UilG0Kn2TFWgSp6woEE/NFCFkjSyupPzRMtqI4OVI+o=;
	b=MpZeDk72634c3zdO6D0kHCnz92VeBMnYvccedA/J979TbgAo6sFmT16IPtenLc2w
	HCbah641wDv15XFrELC48zc/Gki06SH7MxyYmLePjPXTIZ9WtSXoL1QaqWWPC1fkcd1
	hONG7V8yZnc/q3DATA+cdfKoN6OdJnd1zG6t7ib4=
Received: by mx.zoho.in with SMTPS id 1773820826456999.2247798495597;
	Wed, 18 Mar 2026 13:30:26 +0530 (IST)
Message-ID: <bda928ed-6268-4b50-9fdc-64c09b3c8310@zohomail.in>
Date: Wed, 18 Mar 2026 13:30:22 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 0/3] mm/vmalloc: free unused pages on vrealloc() shrink
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org>,
 Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Alice Ryhl <aliceryhl@google.com>,
 Danilo Krummrich <dakr@kernel.org>
References: <20260317-vmalloc-shrink-v5-0-bbfbf54c5265@zohomail.in>
 <20260317141151.6ef2a2bedb74fcaf2883c0ed@linux-foundation.org>
Content-Language: en-US
From: Shivam Kalra <shivamkalra98@zohomail.in>
In-Reply-To: <20260317141151.6ef2a2bedb74fcaf2883c0ed@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
X-Rspamd-Queue-Id: 58107A000E
X-Stat-Signature: bxmo9u1p7p6dduaw1krwdoxiq5zbht1s
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773820851-295423
X-HE-Meta: U2FsdGVkX1/B8mUV6Pb2pwo+UTmcBnVUAkGg9Cll9n0GGgjrLG0ArbFiD2rzlwh7bI/YrUHoH4+FdENcx+fCVt7OCwkUzxilwUu/tLrEw55Hc6ssPqf/Lb2cbNS5v7sHpEsquCP2S++NoYE+p3o6gi2dlYckbEupSHZS8SFxnoVIw7hUnYjAI2As2Rl6H1vCYhmsUrjhtMY+Jjc2VN526WP7Qf2WamRQHegE70jVJMAUDjv52S+O+b/IMdFHdBWEeUde/ImCpvSZ9oRYk8UhJ5OecfLbd9IpQZFZRGQug+sY+6UCYWGE29EQUQE2rGIBTcDNdv1zOkPi35rLaNYPHdHEqH1lVAGqPF0tS6Z1oYZ0k4Qh67CPCJPwlzWU/67uart2FP8mbEX8N+mIJiPVvTVHTxqGW4nt5xX9r4IQYl9zCvaIIU0BHKiNcr2i4yhzYiKm0lDn1ks5VGaqjOlPQ3J8pIYv2zStCeHQzUv/xhWGtqF3BuEKnRWFN0+UECIPwbbtABSWPi03g49z/UaqgaARpepuPXtZ3/NEgbFTLfX1y1hCCPmOOG8i6XKhJCkglXJyFmCOag6cmYmISWuCCFXNFoV1ZcH73mo7UXWFp87M+S+SViuk6Df7rXMH6GyHiYFKK/BH6nKzGANQvlhGPAla7wk2GEcOZlYH5vyaBC9GAz5xLBFKP9VojD6lLj57SY3aSdahHeAT9kBzph4ezvXl1e0BT6bfYT0Jq865Ql0rQ5Rym548viDiBcaDVqWm/gF17O/j/8gzZeKfc6FI89cfVwNb+JM3tbuVGZLo6ImxTitdKMqvMHXpMReIs4vxcD+BAme46S27C3WtXKbbXXgR1Ag7nQcnLV5dIQEXDaA3xhcud7TK1pJlwHHIhL4cEShxoQTf7tP/qUt1/xLYdDUbtiC0v9Vqu4PpxWvrPg/xT5i4PxAdgI3dnIOhBf0DFyzC4VJuHjRktfh2QDe
 30eXNZlF
 5exns24SKuTKixSf3O3AHAg+4BA9GtKvuiTDu3lcNxiEdMqZQR0lHv9yQJSPneBsbbsBmLufNruqb5M+63h7QgsATcoiCdSU1lz708m3q9h4+NJvmIDFdhw2yexORbjAEkg0FXlL73zZbq/4z+fQPTEo99jYbCsF4dqY8sV4Tvwx7mo1Ui2lLGYSwT1VWIVh7qehU9ZVRWkdcnR/Pa01xDGUcbRKHM4Lv7h8fn1O6k+DtqQSdHh+7pxpSWPgyaApTgmaOE1uusMNqE9lffu/zurEI/KdYWJagqL+uRwc2AJYPfvbcb1FMGbiV4cAUcvr4hPlDg4rWFu93wj/c1r3cxj8iUyIm2DFmS3FYc63VdHZ2OlO7zuIqA8NReU/al08wY6O+J3OYd5KQLU5fmMt6ngFLcfyT/9KW8h+DrZdfaLTc6fZPro7V8/ZIw5uaD25AxNGUGJAwSh7sZwjrZKM5tHd7sQKg53QOydl6lGRTOp1mhjYgMXdaeZ+8LKue7B3zEN93RGxo9Og9ucmUYGq1MUyy8WkZZfOzEYI2N8Huzxuwp4E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18/03/26 02:41, Andrew Morton wrote:
> On Tue, 17 Mar 2026 13:47:32 +0530 Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org> wrote:
> 
>> This series implements the TODO in vrealloc() to unmap and free unused
>> pages when shrinking across a page boundary.
> 
> Lots of questions have been posed by AI review:
> 
> https://sashiko.dev/#/patchset/20260317-vmalloc-shrink-v5-0-bbfbf54c5265@zohomail.in
These seem like valid concerns. I will revisit the patch series,
and post a new improved version of it. Allow me some time.

