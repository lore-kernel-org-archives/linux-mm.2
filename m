Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B5B4CD5BBF
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 08:27:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D3566B0088; Mon, 25 May 2026 04:27:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AA586B008C; Mon, 25 May 2026 04:27:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E6C76B0093; Mon, 25 May 2026 04:27:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4BFD66B0088
	for <linux-mm@kvack.org>; Mon, 25 May 2026 04:27:20 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0BD418F61E
	for <linux-mm@kvack.org>; Mon, 25 May 2026 08:27:20 +0000 (UTC)
X-FDA: 84805262640.26.1E9C24A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 0AF29A0004
	for <linux-mm@kvack.org>; Mon, 25 May 2026 08:27:17 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="G/acjUPw";
	spf=pass (imf25.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779697638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KtamHNuFR28E7fsEP+29LCwcwgDE+8M+BYluFb5uW9M=;
	b=q/A2IJzyWEIdcRoOj/nRMHINnTQAy6j74NblISnSoFZ8jMCmhlTN5IffjryaouHaXaO33U
	bGfZ4Bzt8m2TisYtCeSN6RedScOXE2SeAg2liaBF3D2uq1Pw2KRyflLc6mU0Ha5QVEgTVO
	7Xtxa7FPDkPpgyiQtHmJ+0FzAYXyK5Y=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="G/acjUPw";
	spf=pass (imf25.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779697638; a=rsa-sha256;
	cv=none;
	b=i6lmPwtRFoj7KsF2OVHJq4+5AuRR/1Yk4+J8UF9N9kBxEntvwQ58W111xWlM1OUuGLGFCK
	yel5JRy95rS53Tgw/zlgjpPR6n5ix60aNZq8p4Mxho4l9wp5zh2Ff3pTzDFKBOWiA+pD/p
	09I/wn/YrDzjguiCp9eRgTu9iAtC60Q=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779697637;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KtamHNuFR28E7fsEP+29LCwcwgDE+8M+BYluFb5uW9M=;
	b=G/acjUPwwS2Nkgr3ZCeS/gzEQvkrIzoBrjPRSwLwJBYl6GNNRxtR4wkR5Zw2lONonD6y8q
	aWIM9kllpal+d7Vr8/9L3V8Z2NHZWifCzKrxUNwIkcmeJWZBN8jgbK6dceCPSIVaJ1sH3Z
	CWJ+N/yDheJfSR4r3xi7WxE6n8EMpQ8=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-383-AzJYTmhCNY-eMGQKXHADpA-1; Mon,
 25 May 2026 04:27:15 -0400
X-MC-Unique: AzJYTmhCNY-eMGQKXHADpA-1
X-Mimecast-MFC-AGG-ID: AzJYTmhCNY-eMGQKXHADpA_1779697633
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E1AC51800578;
	Mon, 25 May 2026 08:27:12 +0000 (UTC)
Received: from fedora (unknown [10.44.48.14])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id D807C1681;
	Mon, 25 May 2026 08:27:07 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Mon, 25 May 2026 10:27:12 +0200 (CEST)
Date: Mon, 25 May 2026 10:27:06 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Gregory Price <gourry@gourry.net>
Cc: Alistair Popple <apopple@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Byungchul Park <byungchul@sk.com>,
	David Hildenbrand <david@kernel.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>, Zi Yan <ziy@nvidia.com>,
	Jann Horn <jannh@google.com>, Kees Cook <kees@kernel.org>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] mm/mempolicy: kernel_migrate_pages: simplify the
 usage of put_task_struct()
Message-ID: <ahQH2pLUc0Y4z4rU@redhat.com>
References: <ahMt6xyUNnacZU8-@redhat.com>
 <ahMuF6FC6TIOZ-iZ@redhat.com>
 <ahOx-76r0JvTZHL_@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
In-Reply-To: <ahOx-76r0JvTZHL_@gourry-fedora-PF4VCD3F>
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95
X-Mimecast-MFC-PROC-ID: NC-bmJx80tBKEhgMXokHkol-yKKOwLPU2oePpKWjQVE_1779697633
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: 8jz8sqno5zqjkcjjuoodwi5q3a6xybnk
X-Rspamd-Queue-Id: 0AF29A0004
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779697637-632686
X-HE-Meta: U2FsdGVkX1/k5nYFzUdFmsZnlbAEXON9e3OY2eN8TJ8AaqbFmgv1hSvzGi56s2JLAzQGfPtTQwJAM87MlP/NRaWR/4YovUWLvGUu0LF/orN75hx3PX4/KFPKLJvBr6WSpDkaxsZi+vYEIaoCEB3qcXnbD6l425HtSvhSxwZhvLV3CivuoQ0JkMDHdjDlhxxx+nyZ1+C6FP7NNd87g2vSwnkBPfLFTajuhsjoJk5YpWZMG42ouwgP0VmY3WB5E01Io+6MHycqPoJs3ShmxzcCCNoIHbju5GKyZFySarvumxeUpqTAvnUtt5i4++xX9ZmfNC/GUveq5mDsatI+WAshuGy1xEVE27kEp2ITBVsx0DdtNgapI3GdN+NLYq5javyPzqK1UFwWhs9TelBjm37/ZJl1wu7l0g/CTFwDuU9qY4aRFuOL6aD83twTJTdFq9aJxvSFMTmmvnmWPk2zMnJIiN4/xov8aM+Meln59b5dScHJnTbuHwKuXqZiV8bIEun+6oipfPlJ0FJcTtc/OowlxAOVW6UW3nsr0HGwp4JyQVWPXmNo4q1SaK63T28OnqVs0nAu8x7I8SrfotTY/sYbHXsU7Z+PQQHAvUkOKi6H2deZXo1Nmi4v3HFazlJpP5ZwlOf4oicq5loat25OcgQDvM9wGK0acu7IRmgMs31vHjWTJx1vmZMp2/Tgbz5Os0D/D4jiuQX+BVaLqNuY9b9qA6jpdGGyyEPgyKjIqWnxouwzG1cy2tjuyzcK5hCF2WPTn9l5BcblKAL1z/J8+cHKz6olaKA5fO2bIwkn7Ts8KyEYTSrr4AMgP8Fi6dsMs4hZ3u3a18qlkJmmKJmIA9fHCCm+Dd15Ux4kBS4DJemWL71dnTgGRBCqHKXqMXt9a8msdnOpvbhVCs2xBCk0U53EuYrooT9JPGO9sUGGI9wgjQxqby9kOkBG4+rxFGyAf/w7kCJWh/Ru9aelj5iOdAO
 +L7XsdsS
 emMbRG+Qg6Xs4dYOve+OCQQZ8bBSt/FtVleBqs5IBtGF2TsswEoXPI0TUajP/GJaTQXCSaid31J03LthXycsYexRA+Qtvy2ehak/xKpXu3m3bKORjmDtpi5kIbj8egtOZZh6XBuv2pqo6YDDvKRPd82WFhIxRu/FjbGfQBLAoBHjB25wIA2TRY52oHqq6S95MhyYDHMmR7/m1GHqmnAaL3iWtWe3ro/CSwgafuaqz365Cka6T/Ydu9N8lbRSQNf/mU2UGeoN5KysAwIUL+xkj1NLPpGdmpeS5HPjZR3VRT6e2x7bm+rEd4oAzAi8EicYDpxZijqCpGp4NRtjqoMrAQs2Xy5W0D8HjKm987xchdkNKslBhnUMl2FdOw9d0hQ82QJT7+5hM9IC4LPkcRbzgZZflKb7kTgswjX9ZCgq6wf+1I4G8z1hWQ1Dusx6Uf91y+4sCnCU3svN9gST77uZIi05BuQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05/24, Gregory Price wrote:
>
> On Sun, May 24, 2026 at 06:57:59PM +0200, Oleg Nesterov wrote:
> >
> >  	mm = get_task_mm(task);
> > -	put_task_struct(task);
> > -
>
> Hm, I was a little trigger-happy on that review, I just realized that
> this increases the scope in which there is a task reference held (i.e.
> we're now holding a reference across do_migrate_pages())
>
> I don't *think* that's an issue, but it might we worth looking at the
> changelog to see if this was done intentionally.

I did this to simplify the code and the next changes. We pin this task's
memory across do_migrate_pages(), so I think that delaying put_task_struct()
doesn't add too much.

But of course, this is not necessary, I can rework if you don't like it.

Thanks for review!

Oleg.


