Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF462C5AC67
	for <linux-mm@archiver.kernel.org>; Sat,  8 Aug 2026 15:33:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6415E6B00C0; Sat,  8 Aug 2026 11:33:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F4256B00C1; Sat,  8 Aug 2026 11:33:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5090C6B00C2; Sat,  8 Aug 2026 11:33:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2F3046B00C0
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 11:33:28 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8B1B1A2376
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 15:33:27 +0000 (UTC)
X-FDA: 85078496454.17.8EE0394
Received: from sender-pp-o91.zoho.in (sender-pp-o91.zoho.in [103.117.158.91])
	by imf01.hostedemail.com (Postfix) with ESMTP id B460840004
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 15:33:24 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b="M10L/EjE";
	spf=pass (imf01.hostedemail.com: domain of shivamkalra98@zohomail.in designates 103.117.158.91 as permitted sender) smtp.mailfrom=shivamkalra98@zohomail.in;
	dmarc=pass (policy=reject) header.from=zohomail.in;
	arc=pass ("zohomail.in:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786203205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vBE9QDMYlEy4hGZLT0RwN5rvyo0b7qG9j+dcATuXzuU=;
	b=Zp4jaI/2h8UsMMM7M61t58NAKt6ut1e57FJK6xQ/msB2zit6oygoRCOPuBYtfcjhEdKnrT
	V1jywPRS1QvwtH6i0NuJD67EQFwUV6EctoBh6TGECpEx+qjUewXqJFwY2kKFYfA457dnrw
	F8S7KSPchMB4eJT3VFhG6bbujDerbFE=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786203205;
	b=DzJ36is61BPA7qVGZoLxLzSLuFapfNJ/72UKCCG17vOHU5NPe63nfvF8lPD1GUE6IBv5if
	mRkY0I1/vA7Y91UHrzPNpz8QYyUXGNnHwZhhDzhhLapVBRj0C42z4Ivh/ZOHib/ZPC2IEl
	Zyg1rqpiF38EpBh1jtn0X8yTSMGs7wA=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b="M10L/EjE";
	spf=pass (imf01.hostedemail.com: domain of shivamkalra98@zohomail.in designates 103.117.158.91 as permitted sender) smtp.mailfrom=shivamkalra98@zohomail.in;
	dmarc=pass (policy=reject) header.from=zohomail.in;
	arc=pass ("zohomail.in:s=zohoarc:i=1")
ARC-Seal: i=1; a=rsa-sha256; t=1786203153; cv=none; 
	d=zohomail.in; s=zohoarc; 
	b=IUWinNYQ6tmUb0p1UpWmaAFZzUrwKtg5Paz9gimUkDNtIdCGYYB3ljb/s/s/BHjWET3XfbyBtI8fIZMsyN+JBtmom/gyC3ShZOv1o9+1arSyG1rPAEhDzgslrGhlC5N8s6OgXz7aHVHkokxg247jC1NeXVlNHXrinAjPj7AaRJI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
	t=1786203153; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=vBE9QDMYlEy4hGZLT0RwN5rvyo0b7qG9j+dcATuXzuU=; 
	b=JtPYisYciEJVTSUHml4xoXxaVZAOO99Oa9aUkmRSsC0mMLhl8DiWzFTg6XCVEk0KAuL3rUUHaG5R3kkurVtQ03w0MeHmruceOeGkwdLahOJESfXUqu/nDrppvfavbwJ+z8jiFy1NVitxrAnjXyyg25/4Qfzkq9Mc65PNKZcrINE=
ARC-Authentication-Results: i=1; mx.zohomail.in;
	dkim=pass  header.i=zohomail.in;
	spf=pass  smtp.mailfrom=shivamkalra98@zohomail.in;
	dmarc=pass header.from=<shivamkalra98@zohomail.in>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1786203153;
	s=zoho; d=zohomail.in; i=shivamkalra98@zohomail.in;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=vBE9QDMYlEy4hGZLT0RwN5rvyo0b7qG9j+dcATuXzuU=;
	b=M10L/EjE3vD42kohUexzJciqpDldPZ0wYTcnLuGjAqfUMacqQRy6kl+ZHVrlWoqB
	WQdC4mwj+1tYvzXg5jpOAGxNm/gslePvE03GzcGKa3C7I0Y/s1osD09uofWJl78lsiU
	H+2qS/THkvJWkrDWypR1EV/ssT4UaXc4tYKdyBuw=
Received: by mx.zoho.in with SMTPS id 178620315259581.6263347714123;
	Sat, 8 Aug 2026 21:02:32 +0530 (IST)
Message-ID: <c0c5f2c0-fd90-4ed8-9c49-7499dc56fcfc@zohomail.in>
Date: Sat, 8 Aug 2026 21:02:31 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] mm: add KUnit coverage for mappingless swapcache
 folios
To: Kairui Song <ryncsn@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, Nico Pache <nico.pache@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org
References: <20260805-b4-mappingless-swapcache-v1-0-b1d78ba257ca@zohomail.in>
 <20260805-b4-mappingless-swapcache-v1-2-b1d78ba257ca@zohomail.in>
 <CAMgjq7BW_n3HpM=mCGn=q90=4+oXcBLWwZewxvEcwqfzjuewOw@mail.gmail.com>
Content-Language: en-US
From: Shivam Kalra <shivamkalra98@zohomail.in>
In-Reply-To: <CAMgjq7BW_n3HpM=mCGn=q90=4+oXcBLWwZewxvEcwqfzjuewOw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B460840004
X-Rspam-User: 
X-Stat-Signature: 8y5mnhy79q9yxq9i8qa1qdq1owh7ztb1
X-HE-Tag: 1786203204-561770
X-HE-Meta: U2FsdGVkX1+J6+DJ8YSKP9TCPxqBDhLASDygd1u5qy7wlsY7+bMCzJDFYis4i7xom5hlHUKt29Hc6Fal5cJoKsG4qejQcd/lC698iRhenTcvzUCMTB1okFlc/2dat5/8UsRrouJqQ50dAfJlsUFZD0Wdg7sFlGYKQ7W7KkSt7lnDGsaZ5+57T8DQXkJ1yW6fSkYAJ5jR0PfGA422omcs0SciYWBQwNLWRGSgaqz88gPqPILsCoxTQbBT6xQ0DxIk3adqm0IpeEzd3HEN6ZEE+R+Z6ksO+qpu6rKWEoKpmqK9iOOtZcaEcmljAMJsyXdfEnpMQ3udZ3BtABcD/WFh6l98BwKx2RefAjXjhHNNH2eq8ZZu4EPFqz+MuCu+M3kbMc1zH7W3I5HQADoKQdpQn2kw4h0fPHzHVxebDLRivcj8Ge7l4Rwv1iKVH6zgtsDI8HGKOT3aOD4P9Uw4c/dVLVNecbloKoDdZ7bnGQtRb6rZ3vJN05mv3T8jT9WHdV6bVuaZqyUWrvP6OhGFSdi2VFQW6LS1wYJlUbbQRCm7nNhz9D1wt6UFuunvzU1BLbr82bkE99g3Jkgczc+U/vuWT8qJpIvCbajclc08cgrULuMVxeh7EoVPf9fv5Qq/WA6AltWLyI3YRcWB2d0vimG3Ske4OhisNn71vuCABTxmOJfkYuGOZJt8S4olrRwe1mlGZrehxgvzPvn8ZDZGBfNekmsndD/R/ojQzT/f4XaaKyirHgMrGNRrBObro4T7TeHYbr1KAYv/GBoAyVxH9izEylasDMEak2UdAA4nBK0XwelZSqWo8TjjllkWqdO48Jg7p3wSYXu/TnECGsu1tHpqkog/s6nFhYtChon85AhjtdVjby6W1eNuSpmnN/kZQ0zlRoIL7AgIhQo+Ju8bClF2w2zn8WHUO3pJ93+tAqrztUS19YK0N+Npu3UVUPHx24AasucWYiKmXyBv/Xf2moK
 6iDf3RJ/
 VtlRptnvZHez2AvQt/2SozDdowUGEXw8rvcVsLIsnmrMKx3bh5xaczije+PWz7EHmd1FPCQ4e9iaQu0PWUJkZufU7JXk8bAzlkyFyCJyPIs68L7hJRH0xfmLEMwyfu2rCaEtOp30AjlR4+jJdO5aZp0L9OJCivKhbff5mYdBeqDqm/Bfx0sj8mR14SzqDkQjLX1u0duNKuiLf6fMk2UBx6/pWC7k09hMt5DZPFfcsoE09WFIR9NS72P6rWAWEN9dtGjLVlNn5+NfUrQF6SlYVg2W1hMH1zgH7IbeypMJqCqYEzxgbGZqYnDCPmKoTxe9j01olchRXkWcr++zmRtPbPKTempvhSQK5tYwnajCgmBQLq7I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/08/26 16:40, Kairui Song wrote:
> FOLIO_SPLIT_KUNIT_TEST seems a generic test and not limited to SWAP,
> but it relys on SWAP, looks a bit strange to me.

Fair point, the naming is misleading. FOLIO_SPLIT_SWAPCACHE_KUNIT_TEST
would have been a more honest name given the scope. I'll fix this if
the KUnit patch is kept.

> Faking a swapcache with folio->swap == 0 looks hacky, could go very
> wrong if you do any actual work on it.

Agreed it is fragile. The reason I went with this approach is that
setting up a real swapcache folio in KUnit is quite difficult.

> Hmm... you are just testing the gating, not the actual split, that
> makes the test not very meaningful I think. And we should not block
> non-uniform or high order split for swap cache after sorting things
> out, then this test will be doing nothing :)
Same reason, testing an actual split in KUnit would require the
full swapcache infrastructure that is hard to mock up. The gating
check is what this patch actually changes, so it felt like the right
thing to cover in a unit test. The real end-to-end split coverage is
in patch 3/3 (split_hwpoison_swapcache selftest), which goes through
the full memory_failure() -> split -> swapin path with a real swap
device.
That said, I take your point that once higher-order and non-uniform
splits are unblocked for swapcache, these gating assertions would
become stale. I'm happy to drop this KUnit patch for v2 and send
just patches 1 and 3 if you think the selftest provides sufficient
coverage on its own.
On the broader question, I'd be interested to see your RFC for the
swapcache split cleanup. Would you prefer that I wait for it before
sending a v2, or would you be fine with the smaller two-patch series
(core fix + selftest) going in first to resolve the TODO?

Thanks,
Shivam


