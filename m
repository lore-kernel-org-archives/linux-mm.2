Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BCA2C43602
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 08:00:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9C716B00A1; Sun,  5 Jul 2026 04:00:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4D7E6B00A2; Sun,  5 Jul 2026 04:00:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D63686B00A4; Sun,  5 Jul 2026 04:00:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AB37F6B00A1
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 04:00:04 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 29F681C3B63
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 08:00:04 +0000 (UTC)
X-FDA: 84953974728.21.D1442A1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 71EB6180006
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 08:00:02 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Bw38b5kf;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783238402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C+RTSHxP2vSyd8onNRfos1htOyq8aCrQfwRYWC8rhv0=;
	b=OuGVpbnXLPf4tBQYLguGbnGu9fnjCrzep02xgq+SfTrkZwQbIFU2JxaLMwkrnhWllizBE2
	loTqHQANjRvIakXcHT8Nn8rYbG0dvuOAzej+UmgXLX5bmEhc6YQA33yzyzyn+tsJuEIyyR
	odSv5cq4jhi9/PCe5MbBselvsgGQoGk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Bw38b5kf;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783238402;
	b=RXZEEE8B/qqlUuzwphSY4UZi7W6yhWX5AF06pJI4lAyPTc13dYLbg26JUdPO/51fgMtOn7
	lEN8Trfl4Vhv0GUOHM5ITTy6MNAIJ+J7tBNzZNoeapjQUX0inbXbHkl3kol6YRIemEBNuk
	39wJ6xlWb46Qg0eCqwF2+ovtm81hCzE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3ECBC435B7;
	Sun,  5 Jul 2026 08:00:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D14AA1F000E9;
	Sun,  5 Jul 2026 08:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783238401;
	bh=C+RTSHxP2vSyd8onNRfos1htOyq8aCrQfwRYWC8rhv0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Bw38b5kfGJ8hqmEOgHH5FNV548X9MkggalAx/zMvWpGcRMxJXJS+4pY+NUARg01n7
	 +cNe5svEU3+SAubK2jGKIc7Me7FJD2vjPl9yhIJaD9RUVCcDMvKKlpb6RQfiXDdC6y
	 hLI3tSr/Pv2BUlcgxas/bWu7AzTABrzdeHsliiiU=
Date: Sun, 5 Jul 2026 01:00:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: <xu.xin16@zte.com.cn>
Cc: <david@kernel.org>, <chengming.zhou@linux.dev>, <hughd@google.com>,
 <wang.yaxin@zte.com.cn>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, <ljs@kernel.org>
Subject: Re: [PATCH v11 =?UTF-8?B?MC8zXcKgS1NNOg==?= performance
 optimizations for rmap_walk_ksm
Message-Id: <20260705010000.1f9b63735aa19fbfb5d9c24f@linux-foundation.org>
In-Reply-To: <20260703162253688u8Str9eFLR8TGCmo7nIOF@zte.com.cn>
References: <20260703162253688u8Str9eFLR8TGCmo7nIOF@zte.com.cn>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 71EB6180006
X-Stat-Signature: c5fkzwye69hrg85cmtq1nigkoqhx8if8
X-Rspam-User: 
X-HE-Tag: 1783238402-366061
X-HE-Meta: U2FsdGVkX19Ltjq1cHPHqyjx9GuLZyH2soibSGgUUMGYyPjke1XKPT0UUANZ1KxHJQnlBPbi2OJwzv5kr/zdAqGizMvOGJMdc6syda3cS8zzqVrMcVuslabso3R5SulLYdtGUQtZZF0AD3j3wyeldWuU/qz+g+dII7WobX1uJrYnQktAPJpXCEmba3cEcS4kDgUbDD4/0W8Guln5JRUXJFHPh9oAyDbe3JMTVYGh+rbQLAkIuL+QG8KXyPPkQSxZDjoKlwEY6donmoHKiMjgWW8+Df76gPAI247N5r+CZlCNFTVAGNvO/jJnUSkLGpVXsrViT2yZs9p1wg0H32w7I0DWznP/3Uiey87OsYKB1W2siNNy0xBs++AHV99kqf6EKgNunqaozLm8gVGtSUe+HrPOatX5CJO9aKoXz3vpB1/wvvI6eG5EVSICNZ1TGvx0cDLHVkd9vu5xUJMtQivbLFAaDQOutoZ7/4jZPJgX+BuFhMDzwmI1kC8FVqiOzoyHM5tNihCRhwXPlhKr6p/x0JO5SmMU5N65bTwcoHs25SiHNlhdgHs1rKbRGEoYg2zKdQFrA6YrE2mgsIXy7d2YwYLVI1trqEpTzf0nZv7a2fSoFnki0lyYCwUfHnrw09OeSW2p1o4U4HNX0EWXAYWG/D79MExslO4VJsF5bL/A0qASt4xRy4+PB5J20IH1hg8ocen/g/ohK2jHwOQZhL8qFcu03COAOfYJTHlAYmeGWxFd1qHmTCSf2bdRlJ5DUoyiyK+HSWv/V+qks1+5vb/CatD1+BcLXbtzZAuMmkTrXRVukSNlee3/2Qpu7DRfVKf7TRQ3F5KSH34TBNPiJDu9Oz786sDL3QuFmVUYnUtc9BtyGNri+mIq0c9NY50Nw0tMquYfhf9PyFGWWSsRQsy5EqakW0pFS8uanKBSMtFN0ISalU9w281gz1F8rcbDYfOyBkjFw50fi0fFTXtfyUF
 Yg47UdDR
 QkqVlhH4C0rzUVTB1I4GKceWvJmqYEox3A/l9PbrGFUpgs1sp9NMjOU2YWZ5ExgGRspFCXhMaCPaqSDnkH0ctQ7mmJtE09xvGrfldOtKhYx2QGxiMP65vXGlJUjhJj0Y/InZPGx41/ozh5M6vGZWHLmiq6TmFNbBTDB4UHzIyNsXBXDWO9SrueuSnl5vIpxoj0+UXq7DWF/gRzqRNAaJdYuQ9peZHgKqts7VR2a0gGFaSc96hSMfIIe8m8qvf7JnajfVHj/6jOdtciqEGiDqNX1WKLkRVUM23Gp592Q5F59JqMLmpOaouJhNgk1IV3DHt1lDD8Rma/8kSPmL6zffvxEhHCw+zcGU1u3SprbrbG0pAUgOAGX7zTGzj0+juIQot0JA6G/BjS86JYfrXema+aJDWrnn6UqoubctNIfHgP3SVtVZCKr6rvvDDPSV7N9VcwiVAe7GyxokFJ+kmSDrQE2dWyySJfkvMi4J0JDX7rkrsmAiOV3G0qQvtWG5/qwd7fQsK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 3 Jul 2026 16:22:53 +0800 (CST) <xu.xin16@zte.com.cn> wrote:

> This series fixes a severe KSM reverse-mapping performance problem
> that can freeze applications for hundreds of milliseconds under
> memory pressure especially when a lot of unrelated VMAs sharing a
> single anon_vma.
> 
> Two key highlights:
> 
> 1. Lock hold time drops from >500ms to <2ms
>    - In our benchmark (20,000 VMAs sharing an anon_vma), worst-case
>      anon_vma lock hold time during KSM rmap walk went from 705ms
>      down to 1.67ms (max) and 1.44ms (avg).
> 
> 2. Real user impact
>    - The anon_vma lock is also acquired by page faults, reclaim,
>      migration, compaction, mlock, exit_mmap, and cgroup accounting.
> 
>    - A long hold due to inefficient rmap walks stalls application
>      threads, causing latency spikes, reduced throughput, or even
>      container timeouts.
> 
>    - The problem occurs even without fork() – VMA splitting (e.g.,
>      via mprotect or madvise over time) can create tens of thousands
>      of VMAs all attached to the same anon_vma.
> 
> Real-world examples:

Again, thanks for persisting with this.  Great improvement and I'd love
to see us get this finished off.

Please have a look through the AI review:

	https://sashiko.dev/#/patchset/20260703162253688u8Str9eFLR8TGCmo7nIOF@zte.com.cn

That 32-bit thing looks legit, kinda fatal but easy to address.

