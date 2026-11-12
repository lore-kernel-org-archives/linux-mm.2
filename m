Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81F73606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 16:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=BqQLHNlY
Received: by kanga.kvack.org (Postfix)
	id 9FF926B05B7; Thu, 12 Nov 2026 11:24:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AF716B05BF; Thu, 12 Nov 2026 11:24:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C7016B05C0; Thu, 12 Nov 2026 11:24:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 656AB6B05B7
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:24:16 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0120D40630
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 16:24:15 +0000 (UTC)
X-FDA: 85426989312.01.8FF39F5
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id 69C9D1A0006
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 16:24:12 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=BqQLHNlY;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf19.hostedemail.com: domain of alexandru.elisei@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=alexandru.elisei@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794500654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6Xx9ll4KiRlZN5Q7aztt0nmyG6Z2FwPKVYZ86wY/LHw=;
	b=Gm/APK1KevghZvUtNHPpI9idKyMJlVNKhEtgRYbEEAJqi7Do9ti2qMyuTzDDiWxrxDN7BX
	AOaSs8AphbcQeIA1O/wDPQz/gA9n4q0O5LNswQrA+Kdm433QoOTd5pZ2Ix9RLnM8qeQwov
	G1yyZ6ipJtPtZFxgIFk1x6jxr4Zqe60=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794500654;
	b=O+VHnksn+6IfuZgJQdTeDcSgCqPQOEnBVlzzJhrWvn8d545O5EXRm/yqf1lRpMtwOMYdr4
	v5LkV/JUdv3YnDFeFfyxFlFOx+KNZ2BzZpadSah/qFLgbsdB52GyMSW+2q19Fx527j+9h9
	hixrX+UvT/8cov2HIOpnKr4MjVqHFy4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=BqQLHNlY;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf19.hostedemail.com: domain of alexandru.elisei@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=alexandru.elisei@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 69EC11516;
	Thu, 12 Nov 2026 08:24:08 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0F8FA3F673;
	Thu, 12 Nov 2026 08:24:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794500651; bh=1Zrocjmf5KDVgs9C8TWM+FCvnpiEFAfhwrLPqAEVgUs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BqQLHNlYEL+MGcY7ChdyVQ7siuvacMh/KJ7dkXQfKvojNWvmYw/fDWZ9Ui9lqm7F3
	 9jsLTQTkZVACGQn88QQYjBHPS96QiYQAoGd6prS231FJxAvj7b4bc6yFRmNPKYKITA
	 nPX92trHEYqZSAzvnLx+fsCkWZKwWfoOkTWDUUFU=
Date: Thu, 12 Nov 2026 16:24:05 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Mika =?utf-8?B?UGVudHRpbMOk?= <mpenttil@redhat.com>
Cc: linux-mm@kvack.org, dri-devel@lists.freedesktop.org,
	intel-xe@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>, Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Lyude Paul <lyude@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: Re: [PATCH v17 00/12] migrate on fault for device pages
Message-ID: <avXoJSGh5xjGFgod@raptor>
References: <20261103061629.972669-1-mpenttil@redhat.com>
 <avWpWBl1nPcRVmpQ@raptor>
 <79f33ab0-2e43-4efb-94d0-addaf40745ec@redhat.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <79f33ab0-2e43-4efb-94d0-addaf40745ec@redhat.com>
X-Stat-Signature: ggtj1pp3iipj8fadt5urouy7e73n9fxk
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 69C9D1A0006
X-HE-Tag: 1794500652-808669
X-HE-Meta: U2FsdGVkX1+1hYELyu7nu4nias2ClWt8+VyjQgfoBhD213mas4UarRoziNSlVPXGn02il/orpaMCmRdYRWTDE420mJ5xcw4mA8Oh2+WBhhZ8KK0qYDnjj6hJWGFW1V2M2jiZz9INh6eyTEYO0/N0epZ1RY29PgsyyXqydSBjwiSPySg9SreWGsuj4s33lC5piQTzEiarffuoEOlkWrAnn6KPDNkyeCmrN0beSENpZRqp07nJbOwBMC/mBV5rPgEtm5fCUck7Obkx7ofVzx8K/kNAkqpzzbprqg4emzkF5UVEEq+J9APNTOFVamDK4QQ3nB6eC4OB7WFn3xosL6eiWG4NjvtmEzZ2qbHziDZ7YRYaSColDrRJZO+N/+OLjtgatFV8XnTn7FabW06JbeBA1NBc2T3NKPrfl5tuR3ELVsP2pV1A0sALu5LcIuZxcVTRWFQSXdVGbTH6eLumv+AQTjZtZeL/L1GwjhQa/JD/pp8/bWfIgJ+4FOXtwKMVcNJypHrk/ThkVJnYWqHO5E4/1lTxxvCuGr7puR1/YvA6ieQs2H08Mo1xWyvOLYDxHVIpS3qeRej7mTj7b6goJ3QC/fgCIQ4brypOqWZcM8SV5yKuIMuNSVBE+5pkBkTvn45ZA8Y59fiZxOH+sWtdHAiMGhOM1nFLP1R06ZX/erJSb0/1uvk/7B3MrSkcAOe/nbtEto/y3+WQioT4wwoWvxFPUknrHB6tB87pxlbl83AkP1Bqw6IWOUALzJFUHLUkIJTEBN2uP94i7gG10nVXZX9yfKtVeWoGZZfM85f9WJER3uBeZqUkR9RrIOUMvqW+usr3rx5DLgCZqu0cgk6vjPUSHLgYSh0cHNB6XTyoOHwmZoZZWyB8zQHMUeoZbfDcFjoCzepJ4D0mA5IQau5LkuoP8qXZtoqNp63aiXk2TO4cpoJsL7hurlVtRQQVv9nNaojQwyJ46ddtdO7ttGHLFCK
 IXQi1OwX
 Ccs4xUtUHIKPZCj7BsN1Rx3+Dh/3k569ZoS9u85U/NliU3RhyMTSekfswnCe27bb1YZM1UIKKa7feAKH/ZBIh4R2yC7+vZpFJLx6yranYX0S/7WkLIqysoYuOUCw4yuKnfV1QkLNVmu/gj43IP/BD3RaanXaFRUuNecvD4AJyepRRQ8EWD8vhqvy6L5BjXRUm/EbhUbPgM1wii31bmGsjgUCtaCdb2sBXEXI07lOcHLQZypSTnjYuW5UQ59ghpfehlr9q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Mika,

On Thu, Nov 12, 2026 at 04:00:09PM +0200, Mika Penttilä wrote:
> Hi Alexandru!
> 
> On 11/12/26 13:56, Alexandru Elisei wrote:
> > Hi Mika,
> >
> > I want to help getting this series merged, and I've been familiarizing myself
> > with hmm and device migration, please bare with me if the questions I'm asking
> > are obvious or downright silly.
> 
> Thanks for the interest and willing to help! I am preparing a v18 of the
> series and plan to post it early next week.

The series is big, and as far as I can tell the MM people are hard at work
reviewing bug fixes. It might be better to wait a while, to give people a
chance to have a look? I know that if I see a series being reposted often,
I am less inclined to review the patches since probably a new iteration
will be posted soon. But I can only speak for myself, you know best.

> 
> I try to answer your questions, there are quite a bunch of them!

Thanks for your replies, it's going to take me a while to digest them.
Despite the silence, I'm working on it!

Thanks,
Alex

