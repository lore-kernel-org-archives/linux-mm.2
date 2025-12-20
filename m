Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7892E668AF
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 04:01:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C0636B0088; Fri, 19 Dec 2025 23:01:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 193716B0089; Fri, 19 Dec 2025 23:01:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CA1F6B008A; Fri, 19 Dec 2025 23:01:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ECB4A6B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 23:01:16 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8727889277
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 04:01:16 +0000 (UTC)
X-FDA: 84238499352.09.BA2E199
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7026E40002
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 04:01:14 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Laum/7yi";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf17.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766203274; a=rsa-sha256;
	cv=none;
	b=1w5YBBMUSzblM2E/snF60RC9mZX/Z0ClvKWAYil61AdfRl4kzAJfVoXJrAd4l9nyj0H8AG
	0S7/Qjjo8xGduKwlLpSoWZAi343VmTSFKF9Q1MgnL7A1dD8tFYG17I8BjrrOtyOOnQ8ulM
	bAv+7FzZfEI25Lrg6wBi+ieGjbUug14=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Laum/7yi";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf17.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766203274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a0m4ox1XoKOxqK5pNCCILrkroETfrBa5ZoW3DNG7pIY=;
	b=hdeeNJbi2eHp+BKIONkwWf7c9kBVnevXxFCy4l6fKnb92GOUyOEhVZzCyH3KhNX4tUeYO+
	VUpc/AMXOHbZU+fJ7T2pIx1JWP9iy690j6VBE1rDCX9Bbtl24tYjzoRuDPmr4lsJO0LAlE
	JKJmK1ptjwNa8RrgpfMCBO/I2RStKak=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766203273;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a0m4ox1XoKOxqK5pNCCILrkroETfrBa5ZoW3DNG7pIY=;
	b=Laum/7yiSLzFOAax+VUZdjHlhA8aFbPxdnGM1ubXDsiuhQcAWLMebndzNchn0jQfeyAmKh
	xq9XxG8EMaZwTK67qCEZucyhzu6iBapw5/nTq+wRMW7q77s3Y81+i4iW2o41HWvkRJfFlF
	hP7g2Nu1D2wageNISYt/o3HR/BVh914=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-403-SZ3hLAk3Okqg4NMbLRxL2A-1; Fri,
 19 Dec 2025 23:01:10 -0500
X-MC-Unique: SZ3hLAk3Okqg4NMbLRxL2A-1
X-Mimecast-MFC-AGG-ID: SZ3hLAk3Okqg4NMbLRxL2A_1766203268
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6AF171956089;
	Sat, 20 Dec 2025 04:01:06 +0000 (UTC)
Received: from localhost (unknown [10.72.112.41])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9EF0919540DF;
	Sat, 20 Dec 2025 04:01:02 +0000 (UTC)
Date: Sat, 20 Dec 2025 12:00:58 +0800
From: Baoquan He <bhe@redhat.com>
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry.ahmed@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 11/19] mm, swap: split locked entry duplicating into a
 standalone helper
Message-ID: <aUYfem4BPU9iQieE@MiWiFi-R3L-srv>
References: <20251205-swap-table-p2-v4-0-cb7e28a26a40@tencent.com>
 <20251205-swap-table-p2-v4-11-cb7e28a26a40@tencent.com>
 <aUKSgf31kQ+vfbmZ@MiWiFi-R3L-srv>
 <CAMgjq7B85Pv_1XUspypCr3=QaQfkGdJaL+ERvtQ5yQtiQLqRqw@mail.gmail.com>
 <CAMgjq7C3XxHNALturkgpzne6VYTSmsyBMTTG68MMQJaQt=1j6g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMgjq7C3XxHNALturkgpzne6VYTSmsyBMTTG68MMQJaQt=1j6g@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7026E40002
X-Stat-Signature: fnagpcf5b3389czpcbwgwb8n34i54ho5
X-Rspam-User: 
X-HE-Tag: 1766203274-474907
X-HE-Meta: U2FsdGVkX18WGkGv9P+ibK5JtEaEm1iQ8j3huJICU4GoYfMm/Xf0LO/DMBJYzZI/PsEj7gVwxhMFLffgI/CZcW0xYospILoUOhkDmIhX0FKc83XzpHgXsGZLjghoJgWX8YBs3RD74RZYmpjcVwVg/5ttdbguYtZ5eg+ileLx4G3h0b7Vn7jPhsBviEXEcNRZOcVA88GhiecLk1zP7dSWfPcwX5911YCTBbtyIvlvI2CPJKIukoKZYlrDcqH3+xD+tCMZYAtTJkYNf797Sz+p7OdnNcqclIsByWRTFum/qKon+3/6TdN8rMj+cacR4gkv9bOQ9KVciW7YDBlR+29Ct2PD1tAy/cVrVRzBUd8qhEVnUgXjekx4UbULmeQEPYzg6v66OFJiKiiPJCuI6MASQUf5IMOMMdVKGG32Ah5ZMaVZkwL7tcp+cic9OwylP8nWNxvwFNCohXZKXn1pxHk6S7mBF2i8w4S81AQdaRzak9BGXBK3OG3cKTfpsMAVhrNdIqmE3HGMGYIrRdSsSiT8kwtIGN2tfpdYj+vho5Q1P7gj6u6RY/+Dg1/2jY5tqYYx2F6IQDD3KEuwVokt/UXbjMorkDP/3tvtBFLK4flFYLqVUYw6m8Sb5JOmr7a4KgMAq3uStKl/1sHuC0z2ku4x2KsHueBWa4BZcnfWwen3TH7jm5B/Qt0Lrj+vfJk+dsRcjUAtr97gcYUOWQw+yhYPTb317kJhYeO2q40RTNZf9ISAnkTss3kbtQNiR/QBM7ku/KVjUXPwkj6g3QNPABvP9NRBXxzM6NGyJBCaqJWptFjwjP4SuAU50wJ5BXfud6ZT5KwkpVUQqYFC1q7PY7OXmC0NNwRSbdBcaGrQNnQM8fD0R28f8ZggM9iG6iebt0/UmaousAaWxnjkhWFY7Mi/1BVIjjT89gq2ZiAoPIWlNG7nzl9iK+ewU0aWcU3c0SAWZXrJr8ymICF9w/V78u+
 vjd92LR9
 AHxvlffkoj7V+cgzmmNQQrrNbDsj4wV3bsIPeiYEksEOzaW8N7ElWayt6xSyPyS8z2FJhMfq4P56QuaXkHrNGU3gGWENXVVhMITRecoWBqarbnmnjTtYEMH4Wn3hSwv+VmgzniPqNmi68ZkzIeXIj3z0Ae3MUEv16LBY1k7R2IKNY5YTipxdQOcK7U6mZ9RmG8JylRfhzNdVOJWpzOC8iUGW/HEXWy1jf3EScqFvv2SNbXwUiMlsqCeEBCI5a5n2JgpSfgU3t6FEQKklx+bJpjvfO6UygkoI2qiojTCTLqT4F4DwShm3ggb+11Pg/Tzrv2Elhsp7TvMlyIWqS63SGc3EM4P221798c/C3BauBUYB0wwgyhps0sTu2oox+2Zwr20JkeftG0mRMpXxb46d58wXVB4bLUKAUV5Akef7EHFGJvkrAZUsuvCWym+anICyIk0Sj7a4BvRpiu6+tJdqYLTkVDTe6o1sdxS43dbzL+IwGqhvtu+Vuo7pwRA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/20/25 at 01:26am, Kairui Song wrote:
> On Thu, Dec 18, 2025 at 2:37 AM Kairui Song <ryncsn@gmail.com> wrote:
> >
> > On Wed, Dec 17, 2025 at 7:22 PM Baoquan He <bhe@redhat.com> wrote:
> > >
> > > On 12/05/25 at 03:29am, Kairui Song wrote:
> > > > From: Kairui Song <kasong@tencent.com>
> > > >
> > > > No feature change, split the common logic into a stand alone helper to
> > >                                                    ~~~~~~~~~~~
> > >                                                     standalone, typo?
> > > > be reused later.
> > >
> > > In phase 2, I saw the newly added swap_dup_entries() is only called by
> > > __swap_duplicate(). The 'reused later' means?
> > >
> >
> > Ah you are right, this patch belongs to phase 3 I think, I can drop it
> > for now, it's just a code rearrangement. Thanks!
> 
> Hi Baoquan
> 
> While working on V5 I noticed we do need this patch, the patch "mm,
> swap: use swap cache as the swap in synchronize layer" needs this
> splitted helper as an intermediate step. That usage will be dropped by
> the end of this series but I think we can live with this splitted out
> helper. The splitted helper and original help will all be gone in
> phase 3, and there is no behavior change at all.

That's fine to me, thanks for telling. I have some minor concers in
other patches, will add in v5.


