Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79DFCFF886F
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 03:02:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C491E6B009D; Tue, 28 Apr 2026 23:02:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C20646B009E; Tue, 28 Apr 2026 23:02:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5DAE6B009F; Tue, 28 Apr 2026 23:02:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A93336B009D
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:02:32 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2C4008C16A
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 03:02:32 +0000 (UTC)
X-FDA: 84710095344.11.776144E
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf30.hostedemail.com (Postfix) with ESMTP id 51B9780006
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 03:02:30 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nUKX6miB;
	spf=pass (imf30.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777431750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xAptSnBmp9h9N12mhZQEdxJex9G2kRMi+UwodffAKNw=;
	b=BS5sIqJ2sVfqYLsuoegF3pg7giihRXX8g9T68Mev9QLeppSLa2Uj9l09NDT/SWgyXiaAWC
	WLDIRcktXiXiXOLTSxR9mBdk74qOI1fUsGeEFQBuZcaajhqZjNiVP/OOQQNpakPPQa8iyK
	W07aOPSVK+fdsGbf/5QetG0aYWe7VSI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nUKX6miB;
	spf=pass (imf30.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777431750; a=rsa-sha256;
	cv=none;
	b=Z5AcmqtgkbZiyr1fM3Tsw5X23qDbMppYWod48gUSHNcZgRsNsCMdUTP3am+xfv+Jztpf5u
	1R9NcHG1HbdsIz0SkrEtKdCcmWiIQiUxFJWC2QSTe/Ddp+UKf274ZNTUQblxTQB9PkvU9u
	Jzh/8LhoadUtX0v3A+xKw36YWttS3LY=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777431748;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xAptSnBmp9h9N12mhZQEdxJex9G2kRMi+UwodffAKNw=;
	b=nUKX6miBABkPqJTWDSe3nzmfIfQo2Vwx4KnKafK/tN9cODk7otB5prJfru7ieBqJdxxlRV
	8z0o0dwhC7ungjhgBrC8noRgvfZ/g4DM7YVbaKB0AQyBNgeDDmuX9Cg/avGVnCjQE3aiPX
	NFUPD7RRWZxRYLlyVhPJShq70PfUdZI=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.500.181\))
Subject: Re: [PATCH 12/49] mm: make set_pageblock_order() static
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <afBe_CQ0RtmT3xhK@kernel.org>
Date: Wed, 29 Apr 2026 11:01:39 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Oscar Salvador <osalvador@suse.de>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <chleroy@kernel.org>,
 aneesh.kumar@linux.ibm.com,
 joao.m.martins@oracle.com,
 linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <2DE2FBA9-6D7E-4DDA-8B11-E844EB42E574@linux.dev>
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
 <20260405125240.2558577-13-songmuchun@bytedance.com>
 <afBe_CQ0RtmT3xhK@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: z1jhhu9fmij3geue4yafxkw9dt74ygjk
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 51B9780006
X-Rspam-User: 
X-HE-Tag: 1777431750-477367
X-HE-Meta: U2FsdGVkX1/to6PegbimP5XRfK5JoCeunaWaI827TfM8HqyEFQrhgAx4rx/DJ57Xl7QBF5earR5BqMvoWeiqxaaaKFprrQYoa/A5+a/j/KZ90rf4f7c5plcJxdLi65Q5Jz/2mbMg0oiPhM2h8nXAaoalKWeG+4UNbCyPEaHe/kMWW1qZ3l7LWvLIUvNFJRiS+AOOP/WNcdoEKmYJh2VYEDFe4hDm1vdAM7ASM9nsMlbHIyEBW61eDH5os1p8B+bUC60yPBB0trMX1hT948bJc91tsT95hv0BbgoAWdispihZCeRNIQrS/dUyYfqhXOoHgscIMtph8NsXR0ulijQobiSy/QwmrZK5B3WIth5hOam5nnNq9+57FFkD0L1BNvxFo+b2/uIXNcWAJIOPxWJNqgT3Pj+KsSjO8xnB3eX3hv6xG6zFwyT9f1VRchn7+k/V9s0/rWb98mMvn+AOKlLlZ0H9ZvFLTFIz2kxXC7u3SkV/y5bKwfOoyPxOSfvZIJYc8zkJW/nLCckEUXV0Jett6kDUVybIFKxP5nBnb5Vy62QsolzKO46jQZso7NxBpEeBM5CFJDwNkBDmjLNtLNybb3HAZzlT1LRRn4z8nKQQ7/60qFfo6kfbGtc26lKypKCUH7DQWuKFFBykXPsyQDxl7arRlpa6QT0514vd/pNUrozPZ04HaRrUKbUdqheT7EKwHZBkF0vHhizXlUG5MREX1pNrnN4b7eKgSeGW0NON4epKAxS1ACDXvmyGCy7wTvlDZFXp5Ul6nANsyIMgZDeqjqma9FSS8DmKYFQR1EchCyhQNzZdj/KY3X8kuIydhIZv3Az5I9phziWtCOldTLjgbTkqZIYtEPHbFsOZKYEOHyV0HGyS49NpUnosDMSKZX2jjd/qsIBWVpPgeeTLWkpVMd10nPWgts0pSXkvEWosbx7PgaG4r0kP+8ot9Dwku0MGwybQgI217c551nua8Wh
 FDwerLeW
 hhh6wMGIhXh0cZyeMt/MdYv/Xt26IYt9+u+KiYxuWAoFzyavVagqO1xgnzPoRV2KsDayfG+7HgW25YFtMUu190CDhPYA7R3TP4wNwmuYXLyi27nDYvKZtEc6AnHfQH6YuI6Mt1N+NxSHjuhVmmaX8/2VRJ1zW06TBIRZjdmjL62v+Mql/+pSZakKrsIqwCeX8qndnHDMt6Vd+sOTPhrwovTWXMYxhF9cPnu6nSgDnxTpjWJFRN5C2QzGDXFN1wggM8c/B5oy4zzfXqBMprTMhhQ8Qq3uPk7i2ZYxXqV29jpyXMGUcJBJVql0FvonahoIeBs8AUc9g7RBKRLA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Apr 28, 2026, at 15:17, Mike Rapoport <rppt@kernel.org> wrote:
> 
> On Sun, Apr 05, 2026 at 08:52:03PM +0800, Muchun Song wrote:
>> Since set_pageblock_order() is only used in mm/mm_init.c now, make it
>> static and remove its declaration from mm/internal.h.
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> 
> The removal of set_pageblock_order() from sparse.c should be moved here as
> well :)

Will do.

> With that
> 
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Thanks.

> 
>> ---
>> mm/internal.h | 1 -
>> mm/mm_init.c  | 4 ++--
>> 2 files changed, 2 insertions(+), 3 deletions(-)
> 
> -- 
> Sincerely yours,
> Mike.


