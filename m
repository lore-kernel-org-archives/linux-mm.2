Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0DCAFA0C3A
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 06:53:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCF346B0092; Wed, 15 Apr 2026 02:53:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7FFC6B0093; Wed, 15 Apr 2026 02:53:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABD046B0095; Wed, 15 Apr 2026 02:53:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9C98C6B0092
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 02:53:24 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 239811A0391
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 06:53:24 +0000 (UTC)
X-FDA: 84659873928.01.5CB2B7D
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5E3264000E
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 06:53:20 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=dIeNDihW;
	spf=pass (imf11.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776236002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UCQ7usOU14shNLTSWEUmhQvpbKphWMoPUYFh990S0rg=;
	b=jrhH1ci/LjNrCaIvEhK0hHc1iUZij2fbc6XgrLUDoCs/C9Lp9MFmbhZy+zYEAYq/kb7Woa
	xsVlaIcWDQoaAecCOJmFIhwFzzsr2FzOlTxFvaMKIhYSG8P0QDgxb9V8SbNw5WJd1T+FMR
	ZlTk1nU8ui45XZBe19l/JDnP8Nzq5Uo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=dIeNDihW;
	spf=pass (imf11.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776236002; a=rsa-sha256;
	cv=none;
	b=MD9euLd+LFj5l4gYBG92UO8CvOcO07v3g6Cpdx/icp9JtSfrVXsY1wm8fQwWU67f0Fej1H
	9H207ZvxczjV5z+vngKpQ0m1YkJqqjd536OjkazA+925fpQabTPzgnYhEK5fP+WDIVshuo
	apJZzHIYvrHoY5vaS3mnGReNMALVoWo=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1776235998; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=UCQ7usOU14shNLTSWEUmhQvpbKphWMoPUYFh990S0rg=;
	b=dIeNDihWPnT3FOfPJY6nab8kDF+BPhtQayJ1mfCq4Q+l0Nx+lZsfFppX3TeuXcsZ6lF2WJvjpnbV40qVH+mqkNihYDbbY9HIz5TffEPzFq3aX+V8LQQx4Y9pNlPGeTzcC9hrFb51kPd7R5EWZ8j8fLGeUoQbop8mXCd4LJIoDCI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R921e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=27;SR=0;TI=SMTPD_---0X13f5NE_1776235996;
Received: from 30.74.144.121(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X13f5NE_1776235996 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 15 Apr 2026 14:53:17 +0800
Message-ID: <85f163b8-9a86-4223-b835-b271a4502b47@linux.alibaba.com>
Date: Wed, 15 Apr 2026 14:53:15 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 v2 06/12] mm: fs: remove filemap_nr_thps*() functions
 and their users
To: Zi Yan <ziy@nvidia.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20260413192030.3275825-1-ziy@nvidia.com>
 <20260413192030.3275825-7-ziy@nvidia.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260413192030.3275825-7-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5E3264000E
X-Stat-Signature: o7hojc69c51kcyddqso3gc4a9kp9gxom
X-HE-Tag: 1776236000-463039
X-HE-Meta: U2FsdGVkX18zLyOYhrnTvjM2/Lg8l/04fuazWqyrJBQkjDbXP5lBNSNrYnwtlvSR+ZAnj3k2oSxAlUAh7GhrsQb51LoFlWrUkntiNi37zSQjl70DYtS1PPe/SOTkKCPo0codaND8VVbchpmx2+gqvdsQn29E2kaOKKTMPbopl2a3okUSbBAFBsIVzHNw0mudsoV62RJ+DOJoOYF+9Gp4EO9HA8yfJFRTD+/XYeQIlXV3LkoRyzgRqU9ksefIbvfCd4sRHh4PTh6lZj/Kn/scdjhhukv5I0DTifQzdTzX90s3ZHOxdw43o2SktFCNiobu9uodXlZrDUKq3g73kJJGRvfS14alQZHOmbAk/jG3F99aWal1Cfadn5cIl6l0uA93GIZEaX8OcuJAlJqODFNfxziKHesTL2PdAL2aCctexT8ZyuCnFIyrftHhchYBbnSCXfADa1nbYh1+Ec4TX6A742wF71LuDyV3ejW/x6dLrc3B/j+VLa2wesrTHJ+iDoLNpykrxKKSrK9PYu+Exems2daqw0XpQTP22olla7FvxYFF+kBrn4t5TffyItlgVgPWQK6QKz/HzH5XY93F2hWBHt1Un9nDoyAhyOJUj5tHyNfKkz4JvkexSl/xtVPThs1qPwVbNceBuHP8wX1+s3tld0iXJlg4BiYFknGETmNDeGocpZ4y71aYXg7FgR+Ht2ldd9k+LR4krcB08LULDfxUsVMBmaS0ffz+HVN5g6UJGeytx5sFj2qiom5QqeNqNYpG23rKSlPEpXJvQTci8XJ+IAorGnYIaprl+fOh1caT1yGKYI+vRibcwbgob6BoyT3Tj+JhLFYU1+4YTL4MvaX+5lwDRT3tXc2DaG5VZ60MztLb2YH5F6DZciir7Roa7Qf80aMajPXnKlVMJAJsZ+cq/JuqdzpamGQQBjaN6nh2+TgBWUfAEMUEqFF3Xprkb5Bho+iJ5jP7Q17sWqFxYjy
 5Hv4Mk8/
 ZSrAj0lXM5h58LrV8yTlzL4HmoeUtcs8JdBQ2QKW8bWEeuNM7yPyNNNzLVa/+658mn6YCj+cbTMIqeDf+uMfR9H2UJKs/DyUKsYi7jDxAvUuqsqpnn5ztYGEyRlcgEBkiczVyvJ76ynK+c8p/8wdj+VKbDhQPvYcE2A84HaNARRfIlFJdBkuEBQUsHPxFeS0mNHSbxDFHslrPJenurZROhmIIvXoiRFnXGfkMcsMc+2zPDFl6OJR5c2cselQb95CO7H9UiOPXFsHag/+8/WbWATajT4t8rV8WGi81lGiL5EtSqPxT662sx+k1/A8euR/iP/krvauhNDkq+7U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/14/26 3:20 AM, Zi Yan wrote:
> They are used by READ_ONLY_THP_FOR_FS to handle writes to FSes without
> large folio support, so that read-only THPs created in these FSes are not
> seen by the FSes when the underlying fd becomes writable. Now read-only PMD
> THPs only appear in a FS with large folio support and the supported orders
> include PMD_ORDRE.
> 
> READ_ONLY_THP_FOR_FS was using mapping->nr_thps, inode->i_writecount, and
> smp_mb() to prevent writes to a read-only THP and collapsing writable
> folios into a THP. In collapse_file(), mapping->nr_thps is increased, then
> smp_mb(), and if inode->i_writecount > 0, collapse is stopped, while
> do_dentry_open() first increases inode->i_writecount, then a full memory
> fence, and if mapping->nr_thps > 0, all read-only THPs are truncated.
> 
> Now this mechanism can be removed along with READ_ONLY_THP_FOR_FS code,
> since a dirty folio check has been added after try_to_unmap() and
> try_to_unmap_flush() in collapse_file() to make sure no writable folio can
> be collapsed.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---

Thanks. LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

