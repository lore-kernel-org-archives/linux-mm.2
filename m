Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9931BFF8868
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 16:18:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DD0A6B0088; Mon, 27 Apr 2026 12:18:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08DBB6B008A; Mon, 27 Apr 2026 12:18:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBE546B008C; Mon, 27 Apr 2026 12:18:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DADBA6B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 12:18:51 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 71FD3160279
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:58:04 +0000 (UTC)
X-FDA: 84704792088.03.96351DD
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6CA27180016
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:58:02 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xLewC43e;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777305482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tDtbus8CxHrwyQM3OMQxzeKwt9hPmc6cbwSAuU/oDr8=;
	b=DGgZWswgj+Lg+XHF5YVeRml9cXWizt5G4AhgS4SQ/DoCUINgKo2LDJN6mU6nY1V5DzA5dT
	breK/R8pWvOT+58IeHDLO9kyOdX/p2pKs9hS+PVZqJiTinc7Crj4LBaqLxOqlCQ25jQzl5
	UjMnhXDX8FhMEB96q0O1SOt6Qse+LBE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777305482; a=rsa-sha256;
	cv=none;
	b=m9cCORBq5Q82NcoYWgFIxSRCfJ02ZNscZ9/BMIlitMdywcrew0uJQEFeveyWvDJ5bLNItp
	V6NxvUBEQ9edvYEtV2CyBtqPGLyIJkHHOAgCxutldNaCV9puq88LHGrqGP9mAWtVkPiFld
	A5gwMi0bsRx4aFVXOKaM5il9IGs++rw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xLewC43e;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777305480;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tDtbus8CxHrwyQM3OMQxzeKwt9hPmc6cbwSAuU/oDr8=;
	b=xLewC43eXTp7cTNuezMPBEADJ3J7iL+BrYFniYehOCZGgKBxD6ZhQZp07xLW6DCG+UmilV
	IOkePLTdKPAeFsDUqJWTK6ciN34NHPccn51FnevfhPh34nyCSvwRY+ENY2bUVVvl6mVJTS
	i788J1u1a8TuefrI+2Erz7vnZpZ6rU0=
From: Lance Yang <lance.yang@linux.dev>
To: leitao@debian.org
Cc: linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	akpm@linux-foundation.org,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	david@kernel.org,
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kernel-team@meta.com,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH v5 1/4] mm/memory-failure: report MF_MSG_KERNEL for reserved pages
Date: Mon, 27 Apr 2026 23:57:39 +0800
Message-Id: <20260427155739.1643-1-lance.yang@linux.dev>
In-Reply-To: <20260427123330.92847-1-lance.yang@linux.dev>
References: <20260427123330.92847-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6CA27180016
X-Stat-Signature: 9onw5sotwwcia45hniphoa5yb9tinouc
X-Rspam-User: 
X-HE-Tag: 1777305482-449808
X-HE-Meta: U2FsdGVkX18dUIBItlta9LHxC37gJvJd5QkFeLCmy4ikomSnvsIrJIGALkeR/Tf9RaSDYPR5PrN3TWUKT/JYdltIgMEi0Ti+xWHhjKQGC7lx9SOnEbYdMytd7gupHW5fG66Kjb2Zm4CPwPRxKs+8nx3j/R52gZJdrRTagkKrvM6IiWzVAS2NPVs02CL6wWca7q0dceN2Ug4fjH15bCYD8ob1ZWzkeO+quJdCmiOmu9RMEiZE9VcG+Tk0d6EEd9n1KllagfWrGfXKGmYmfFsrDLc5av2ePkzbXHsC+PaudgGZjoFHvm/j1ExAaTu8GiUr3dlrBy7noTXkl3tfejis+kNmqdPzbo5NurwyuXWZ/WiPz/DojJ6ewUpvvdCA1NFVyqe+yAavayX4Ph7tmVl3EW6Sjb3ePAQ5+bxXGV46CRbjf255YOejYd6lr9lLbxPUw7BggwPAPPRM+MsSdymPnzVWWEs06tdti3CrdcKfrJ8SUp/JFGswSlPYfmas0cerfzy0jXtj4wIyCL4prUEZ7grH/MU5uclFhsIduLBuhFR+Cl3hHCR3SEnZFMH6IRxBi/C90OYDRv4XhoMF4nESatD8BNK3jwokyXwoPqcYrVexoIJkoN0Vp1WmHcfaOLNrtDezyTY8VYWbb9RP99Q/hnwVJexxfGhEG2pzgHXN1SH11MFpZMKSMW8QOjojGMi+eWsUUCKzzQwPXDwxMQYum+3zxpscOUyT3sTj4fC92Uxb9n2mdSWMxUdsuBYhEv5fHURc/NGQ8v945yLpb2Eh+8dZyjiayAi/6W65cxzvnc8l6ztkvm3CkfsMqcJN8Apo72f0U9swsFEIMsOYv3oU2pM09DuAkxVpFZHPA07GUCDTh+dX4I8TDcO9FEuYvqrsYzav7qRljb8JUnBococaMVLwl5j2+5kWuWBARWgBDKF7ba23MeeV3Ep0h4ePfFjMCz3CyVSNeU4Vcvkj7mf
 iHjBlRKv
 V39k7DYu501G8LnaSaZDmES+B/faqCpmC7DhNpP7KLuuIX5dtBbst/n3WMGt8B+qA7c6vBdSNFhBfg8wPJbyWrR+I8EOPIoZl/vzAmRrY4fk/JdKlbTrwU3BfXvKimrCIPIZSWjxvwE0G5sc8DMhW1Kt8DnR6cuscmyg/R40ofkApyNaAPHOdu9WuLhV2kG3sQDZm+BHijPGBE7m8W0LBQSbcIgD+sk9A5hCgkL2pPHlXbqghyFcuyQw/aCVboRJvz3YzXnHgVhve2zwwajr83koWbeBwtH/n13swkHAHwjDRQYMOYOvhS7LrgZ9BLuATU6pCCK1IeJI63E0TJazo8MyCE7k1SozKCZ25PkW96u75Gka25LolV4imzUo62qai46LNsm8OPVILleAQl9R2fFYcLcXsF2+fpPAcrgRS944EYJOyO7ptFCNSzg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Mon, Apr 27, 2026 at 08:33:30PM +0800, Lance Yang wrote:
>
>On Fri, Apr 24, 2026 at 05:23:59AM -0700, Breno Leitao wrote:
>>When get_hwpoison_page() returns a negative value, distinguish
>>reserved pages from other failure cases by reporting MF_MSG_KERNEL
>>instead of MF_MSG_GET_HWPOISON. Reserved pages belong to the kernel
>>and should be classified accordingly for proper handling.
>>
>>Acked-by: Miaohe Lin <linmiaohe@huawei.com>
>>Signed-off-by: Breno Leitao <leitao@debian.org>
>>---
>> mm/memory-failure.c | 11 ++++++++++-
>> 1 file changed, 10 insertions(+), 1 deletion(-)
>>
>>diff --git a/mm/memory-failure.c b/mm/memory-failure.c
>>index ee42d43613097..7b67e43dafbd1 100644
>>--- a/mm/memory-failure.c
>>+++ b/mm/memory-failure.c
>>@@ -2432,7 +2432,16 @@ int memory_failure(unsigned long pfn, int flags)
>> 		}
>> 		goto unlock_mutex;
>> 	} else if (res < 0) {
>>-		res = action_result(pfn, MF_MSG_GET_HWPOISON, MF_IGNORED);
>>+		/*
>>+		 * PageReserved is stable here: reserved pages have
>>+		 * PG_reserved set at boot or by drivers and are never
>>+		 * freed through the page allocator.
>>+		 */
>
>Not necessarily. PG_reserved is not a permanent lifetime property for
>every page that has carried it.
>
>page-flags.h says early reserved pages may later have PG_reserved
>cleared and then be given to the page allocator :)
>
>At least some drivers also clear PG_reserved when releasing pages they
>marked reserved.
>
>Would it be clearer to say that pages with PG_reserved set are not
>currently managed by the page allocator, rather than saying reserved
>pages are never freed through the page allocator?
>
>Otherwise, LGTM.

Ouch, I missed one more thing ...

Sashiko pointed out that[1]

> +		if (PageReserved(p))

"Can this introduce a use-after-free risk on the struct page?"

get_any_page() may put the page before returning -EIO. After that ref is
dropped, PageReserved(p) is not safe, IIUC :(

Maybe just cache it before the call?

is_reserved = PageReserved(p);
res = get_hwpoison_page(p, flags);

[1] https://sashiko.dev/#/patchset/20260424-ecc_panic-v5-0-a35f4b50425c@debian.org

