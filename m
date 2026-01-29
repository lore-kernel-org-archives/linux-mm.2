Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE64FD73E9E
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 22:49:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 595B06B00A0; Thu, 29 Jan 2026 17:49:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53FA66B00A3; Thu, 29 Jan 2026 17:49:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 417BE6B00A4; Thu, 29 Jan 2026 17:49:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 337BA6B00A0
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 17:49:32 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C24BC140397
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 22:49:31 +0000 (UTC)
X-FDA: 84386494542.28.6BC5187
Received: from mail-wr1-f65.google.com (mail-wr1-f65.google.com [209.85.221.65])
	by imf01.hostedemail.com (Postfix) with ESMTP id AF9DA4000B
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 22:49:29 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cgVc50Ch;
	spf=pass (imf01.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.221.65 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769726969;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MHnhQSU7iuKe1wvcKkKvWgrmHsO0QtdxT1/2Mr9iW+U=;
	b=L9TOQ/fIAIcKQjWanNemS9yB3sF9FgoBk7i2JQfOr3EQWsm/5WzoyLZtN8assVVwTJXfTN
	9/CcAAg93awRnbSyLjysIhbX5ZtWxeK4IXH3CyzI8OcKSeP9yUeplhAk2d+ByG6HXbK+93
	HOi5qcaXVnGAWTUm5pMJb4xrEvpUJfI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cgVc50Ch;
	spf=pass (imf01.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.221.65 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769726969; a=rsa-sha256;
	cv=none;
	b=f6U9PJDJMcbS5VqOM6G56rGtZv4LZL5J0jkaGwUHKNRp3eN02WTiUpZD29tRjuiQQSHzy3
	W95OYTj5b8hhw5veJFtGVX/HhENEy1GDW0wgz9TP8mk//4EhlfcvTh5RMof47fWuQuTuAv
	SvERuMd01zolwI7+ZQKRBKnF42dgPBE=
Received: by mail-wr1-f65.google.com with SMTP id ffacd0b85a97d-42fb2314f52so906493f8f.0
        for <linux-mm@kvack.org>; Thu, 29 Jan 2026 14:49:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769726968; x=1770331768; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MHnhQSU7iuKe1wvcKkKvWgrmHsO0QtdxT1/2Mr9iW+U=;
        b=cgVc50ChHZ2F4C2gQqpP4o/m7Ox5utbUhXgmWWrx2WTgnNF05oZaNU856nt02qLLhy
         uiL2Gyj5NXoLBJj9TrKDG5hexeDktgGGDBFtZ4rA9uZ97Vbh7e0X2yvldffYGnw31Rt2
         vR1/QutqRFEsBVGsOZjdEVUXna1o7RrxnizWYS/V/Km3Ysg4mAHA2mmQs4kEewKc8A+w
         BgVz8uBTv5Oo8x0viCuBGs0jZ/ndX53FT58CW80v6wWh2/jvUYTkqp3i/p+ap38abz2o
         boiscc6+oRExjKhoGAh3L2//ORFIfWQ5d4wv5dH+ZOs67qedbZfx4VcdWTeFg6QT19DT
         Nhrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769726968; x=1770331768;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MHnhQSU7iuKe1wvcKkKvWgrmHsO0QtdxT1/2Mr9iW+U=;
        b=Iop27n8g7mHLeYiTwAbloI2TDAGedIL9m+QhyXyR8WK5te6/fu7muT9pyyOtnD0wf4
         MXwiLJ5k20d16X62ZgVwJkTpx6zZpOdSUXliXMZBmX9IBezmBtXgF0bieNz4RPOkZwa5
         mTLVnaDsD8UdhuRdgKXNvfZRhw7lohpp2YENId1WW4U8t1nRxeaiV3PLZU/ffbJe4tNT
         BR1U9qH7Q34jiE951ABUmPFaOzqiyMbK65KfxBdu503iOe0MrAd3h7HGvlFuwe8zWuBt
         EcixE2YXD9DlBw8YPMEOYV/jGQzKkrbLqUwanUYMzy6/k2k6E4lSCCSdKL7119WlDTFY
         FE+w==
X-Forwarded-Encrypted: i=1; AJvYcCUN3/D4btwzeW9mvAKfVkDQSrOyHNWUObzjHZwiewRwUI9xvTW5isQocPMUxPJM3rUUmV03dSqJ6w==@kvack.org
X-Gm-Message-State: AOJu0Yxv1OLsxbV5FmawcGOrVZKW+MpHz7D7vXOTWG6L8S+Fcn1po76o
	c5UPJ6LzAdYUAXDY9svsBrcbq4DU5rzwKLZXE3IUW34mKvC3BxvFehb8
X-Gm-Gg: AZuq6aJtHAV8yWxjCgy3xtrKL47UwKaDApRi6nsZcnTI1/LWuxUBym8fc1TTt1faSEa
	KY/OS6fK6bTp8d/GgWL+sPpMAsOUjZDjQCiD1XcgPbLr2sAfz03nBBaZ738IDsY8avgc+2vm/SO
	I6zbVieNFS5RdL+nug12GaRBiq1Tu2+P8rw8sxp3gMLAJ6P/Lt+B0+9A7DqXoEcg26r02CSiQij
	r6/7rOfAEwbA2Skn0ShQOTJXyCy9IWjg+Up7pl9gLD5iGuwoGzMELKImatgcjs1bjUVpNcOVhzm
	wKICHvp1MY8MsFlJr/5JBx5IapWiFfbQPWG3y0kQy2ihA1Ch6FF3T9iIglX2Tg4pvMtMRzs28jy
	bvDMc+aiU4o8MRio49gKUCHwfrfZrOlJMbdP7xYAS8T6GDwEldETsJrYhT1wGQ/McOcB+7Dn9/w
	vtWrrPpi8m7tD4scvtrjMyrZLMzqF5RMcEHeo39nzQjCM3o1TfGlY0Vsl269/hjQIRFwkDv2ikj
	0/L33d60JxGRXo=
X-Received: by 2002:a05:6000:26c9:b0:435:9756:d4c4 with SMTP id ffacd0b85a97d-435f3a7bcd0mr1743299f8f.17.1769726967582;
        Thu, 29 Jan 2026 14:49:27 -0800 (PST)
Received: from ?IPV6:2a02:6b6f:e752:5600:1cf6:3834:b349:c738? ([2a02:6b6f:e752:5600:1cf6:3834:b349:c738])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-435e1353ac2sm19060165f8f.38.2026.01.29.14.49.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Jan 2026 14:49:26 -0800 (PST)
Message-ID: <fd9d20c3-1bc0-4bad-bc5e-7d9549ddf8fa@gmail.com>
Date: Thu, 29 Jan 2026 22:49:26 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: khugepaged: fix NR_FILE_PAGES accounting in
 collapse_file()
Content-Language: en-GB
To: Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@surriel.com>,
 Song Liu <songliubraving@fb.com>, Kiryl Shutsemau <kas@kernel.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Meta kernel team <kernel-team@meta.com>,
 linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260129184054.910897-1-shakeel.butt@linux.dev>
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <20260129184054.910897-1-shakeel.butt@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: fco4xehts3jqgctna6y39tq1aaouax13
X-Rspamd-Queue-Id: AF9DA4000B
X-Rspam-User: 
X-HE-Tag: 1769726969-868401
X-HE-Meta: U2FsdGVkX19pKFlR329UjVk5EBN3XziCBDgcgrVvS7bwI5DVais5tPPeWiPYZqnV03rTd36Qvy5T3cVu293ifSDZUxwsk9jroXy5nZ1yk5X1Wr1P2+o6d0VWdSZcGs3ruqfKT8WtHQfB4g4/3XBuJhK6rK3sanGzmaMPdltsQ6gbxmULTBpD1byuDPbd1lHbCE4sY9jrzGze5olN25jEEYIdCYWDrBShsCoRoq1ByKcv9seFrkhjdNXHuz6dmlFBUmps0GfhOvz6gDcVfBA+3lCHfPFvr+JWLcE90zw5xnJj3lBRM33WQUSvWe+nm+Z9aFm0DUMPlRENNmB8j9dxagobTCgwjnNp9dtuvR/F9LqwilxNVyMJY7Gn1sqqkpHxXY7dqLrSGWkWz0SE3q67A4ZAPhPEkYfelKrnSkFh9Glstyt7efXkEwnuYjXkxrSYY8jgyg95ETqdCOHZ/bg8xs2tk2nm7HDjSMn8OyWO5e/O6Qc7sNaDvQ30whk+ExX8n8Lw97djBP17ZfWpHRj7DX8d0HOLojDqm6T7KyiUKm8W+CkM9sy8aeBfutDZBQClcL2bL+uP+F4B/dLVH6ubxzUM1fNzzQYdefbDwGx7BykzZz/ynN56gdJPMMf1aqiSx0oqK4vjqeAFs1N1+iZuiVCIcIGdLSATdP9EFDyznH/kIud+d7jBgbsxzWrCbbDqEz9xMdJaSBr97AvzoSXPB3QhQkQ1a6WT6NErp8pZNaH3XB4MLnerWgSZSArXcJ0Wdl3YrQm10EgVHcrYOvbxtIPI3cXE2XnRihytp05tijEyF42lEM/tEYdWI911Fu0+MSxEan88+Frn4FmxZ7lr5aCA0hAj9CvKJL0Cf+vruj5ewzAwi8QCtSGB2ideTf6F+UzYRcHhLFFvEEr5rf2hSyoua80p2gptON/rIxlkolQJSSoNWvLTpYbNYXy/6W8XibmE6JFeuuz/Z++1wdJ
 CP9XD2p4
 J2g2oXXToJbkMbV2UjQWMRYHSdxowwKdOtCV9lobaUnCKQteNL/7OeMC9XwgY6bUes7/ZrqTDYw5s/03zdnIHne79MxwBCjAJB+sWJUCPtbFtTrUb34N+F4cW0nYT355pc+kfu9jdJJ+EQN7rvUe0XOm8TP8a+XEui8BcMywZN7OqPipCEmiCmvQuKqWGfeEgKGCrT3zsPudzZoCzj5hE7CamoXgDyrRCitIDM5uIIKi2WzGfGGI0vxvbh1X0DQM/Yc0gABs0Pa2dXuxurh+4MZeWltCldeCA6KzLsJP+beUQNInfdJDxRcwpSlMFAQMDqOCFWlvDif5SR8gL0CojDZIPirHP2xAjdppQOyEp4iG93Cr3QH2j8xhT35QMPxJFYAZRetux0W4uVIMywCpvG5yeoCViiLbNZUAst/vjn7p7L2HXsKgweiuhK+aDtz00SVukyXvuUnOIosw0OMccvMeH6hzaBd8ZgfHiCmYkzhE3ItVHc1nl1ZbxUln1bUZrPhC0OJfb3iJy8Iz5bL9XRU6zc0fkjEcL/0DA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 29/01/2026 18:40, Shakeel Butt wrote:
> In META's fleet, we are seeing high level cgroups with zero file memcg
> stat but their descendants have non-zero file stat. This should not be
> possible. On further inspection by looking at kernel data structures
> though drgn, it was revealed that the high level cgroups have negative
> file stat which was aggregated from their children.
> 
> Another interesting point was that this specific issue start happening
> more often as we started deploying thp-always more widely which
> indicates some correlation between file memory and THPs and indeed it
> was found that file memcg stat accounting is buggy in the collapse code
> path from the start.
> 
> When collapse_file() replaces small folios with a large THP, it fails to
> properly update the NR_FILE_PAGES memcg stat for both the old folios
> being freed and the new THP being added. It assumes the old and new
> folios belong to the same cgroup. However this assumption breaks in
> couple of scenarios:
> 
> 1. Binary (executable) package downloader running in a different cgroup
>    than the actual job executing the downloaded package.
> 
> 2. File shared and mapped by processes running in different cgroups. One
>    process read-in the file and the second process either through
>    madvise(COLLAPSE) or khugepaged on behalf of second process
>    collapsing the file.
> 
> So, the current code has two bugs:
> 
> 1. For non-shmem files, NR_FILE_PAGES is never incremented for the new
>    THP because nr_none is always 0 for non-shmem, and the stat update is
>    inside the "if (nr_none)" block.
> 
> 2. When freeing old folios, NR_FILE_PAGES is never decremented because
>    folio->mapping is set to NULL directly without calling
>    filemap_unaccount_folio().
> 
> These bugs cause incorrect per-memcg accounting when the process
> triggering the collapse (MADV_COLLAPSE or khugepaged) belongs to a
> different memcg than the process that originally faulted in the pages:
> 
>   - Process A (memcg X) reads file, creating 512 small page cache folios
>     charged to memcg X (NR_FILE_PAGES += 512 for memcg X)
> 
>   - Process B (memcg Y) triggers collapse via MADV_COLLAPSE or khugepaged
>     scans B's mm. The new THP is charged to memcg Y.
> 
>   - Old folios freed: NR_FILE_PAGES not decremented (bug)
>     New THP added: NR_FILE_PAGES not incremented (bug)
> 
>   - Later, THP removed from page cache: NR_FILE_PAGES -= 512 for memcg Y
> 
> Result: memcg X has +512 inflated pages, memcg Y has -512 (negative!)
> 
> Fix this by:
> 1. Always incrementing NR_FILE_PAGES by HPAGE_PMD_NR for the new THP
> 2. Decrementing NR_FILE_PAGES for each old folio before clearing its
>    mapping pointer
> 
> For shmem with holes (nr_none > 0), the net change is still +nr_none
> since we decrement (HPAGE_PMD_NR - nr_none) old pages and increment
> HPAGE_PMD_NR new pages.
> 
> Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev

Acked-by: Usama Arif <usamaarif642@gmail.com> 

