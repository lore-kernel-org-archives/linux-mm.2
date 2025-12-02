Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF31BCFD376
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 06:32:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEFD76B0008; Tue,  2 Dec 2025 01:32:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA05B6B000A; Tue,  2 Dec 2025 01:32:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98F1C6B000C; Tue,  2 Dec 2025 01:32:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8452B6B0008
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 01:32:07 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CEC5313B0F1
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 06:32:06 +0000 (UTC)
X-FDA: 84173561052.03.FCCC3E0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id C327440006
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 06:32:04 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FBErT8Ew;
	spf=pass (imf04.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764657125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r57F472LqK7kzOJ1Ly7NewGwWzuQUfayvw0ZwezoJDA=;
	b=n+wD3FnQraVkO6QXh3LTH4g3elSp1FbT2Fx+2IUSFqxzQwOgb3QUDNzmKJUTXtSAzVhkj6
	0cYGCL6eAPdBCGvj74snmeJvbOW+qsv/qunelffdnw4OLJrxR6i98B33OZGyOgbuCsLbCE
	nO1AFe0ZC+CwXvLfGonxM6IeVIs/Xw0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764657125; a=rsa-sha256;
	cv=none;
	b=R1z2bJxKBzn4k9ny58cZv0UFlvHkHov0e6WlU+crhMPhcZI58HeGJHQIYGChr/AcijPskB
	/pKTJDXzPBqte88+srDncl3NmDMSqVYgiQYlRwVi+NyLfR8FlzXJp5bTnWUCYjzV/zR6DV
	1XhAkgUREzyxME0IMIQbowR7jhgFhTQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FBErT8Ew;
	spf=pass (imf04.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764657124;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r57F472LqK7kzOJ1Ly7NewGwWzuQUfayvw0ZwezoJDA=;
	b=FBErT8Ew0kY74OWNAJdejFHRjOOQ+bF3+53MC/RMtqOzEmB21ztY9Xb3dXrv6q7rtvZ7V9
	FzDg/6q7SG1+5MGORQsbc4rYx+VbIaeiGvjR3HLtzGhkinrvsDf/+p681yFS//bReanH85
	IVFU56Q7DCs3zkJDpUmPO0y99wEzIi8=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-517-f4qKU_9XPc2hmNaTPXJspQ-1; Tue,
 02 Dec 2025 01:31:58 -0500
X-MC-Unique: f4qKU_9XPc2hmNaTPXJspQ-1
X-Mimecast-MFC-AGG-ID: f4qKU_9XPc2hmNaTPXJspQ_1764657116
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D07A719560B2;
	Tue,  2 Dec 2025 06:31:55 +0000 (UTC)
Received: from localhost (unknown [10.72.112.62])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D749030001A4;
	Tue,  2 Dec 2025 06:31:53 +0000 (UTC)
Date: Tue, 2 Dec 2025 14:31:49 +0800
From: Baoquan He <bhe@redhat.com>
To: Barry Song <21cnbao@gmail.com>
Cc: Kairui Song <ryncsn@gmail.com>, Chris Li <chrisl@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, pratmal@google.com,
	sweettea@google.com, gthelen@google.com, weixugc@google.com
Subject: Re: [PATCH RFC] mm: ghost swapfile support for zswap
Message-ID: <aS6H1b4MHo9HAPHS@MiWiFi-R3L-srv>
References: <20251121-ghost-v1-1-cfc0efcf3855@kernel.org>
 <CAMgjq7BgCocnkJAYd-BBBvzbu9zxmv4QCj+k62kcA3ThZcNv2A@mail.gmail.com>
 <CAGsJ_4xZPPE3TaAYU96srZKe6aKZmV743kQ97E48ZWh3BQ5Z6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4xZPPE3TaAYU96srZKe6aKZmV743kQ97E48ZWh3BQ5Z6Q@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C327440006
X-Stat-Signature: bkg6iru8utc336pwuw1tgrzhepyw3zas
X-HE-Tag: 1764657124-295858
X-HE-Meta: U2FsdGVkX18fPR5FiaSVce7OV1blk7RJxnvHxbHIxLt2RhTiMR/tRb397hv6nmVsvqnZGkQmGOjKPkF1SZ2AfdS5L2ZRcWFJWerH/deJexJTj8EArda1biPeo5tLS4OCNQKQdMYuYxFiV9NIOFYKjUx5zvmEDfCciSf4WSyaZJkW53757YRzFMN4Ele/eo4Ea5a06MqzjCrZ9VEv7NLeePqoV5Bd8M+O3lTD9b5K9p4jOpoVZtLtRAYHZopYXU6XjGCy6wu3o1/+xy3Z5KacvLbWAOqcYR2oQgNye6aPsQKzIByGQ4qk5yEClTyDkQGlLKOSM8tRsNaS6Gq36E36ScKR4Eg91vYQc88rCGhLNxs8z7MDL23Omf6TNxfqLPyr8j62+IzVPB77XmKGbD/KQbKtmAGUFQXIeTYgh0Jwh7WKghe47gQHVqw0bMmetfJUvmYzgjIKP9pD76sD75ZHUtO7cLuwgkWlKmoRZAQ/ORGQWLn7d2L+WZMXZApBsCAZIW9ss0vqPp3IiMleYmX5pX32Q3zm1wBj1nlM8/dFiiNkCOgnuQz1YhN68iWDiX0tFuh1PObXrTKiDtSlqARt43gIc611lHf1eTsGK9TPV/5kNnSFuJdYjMOp093dBGUhgtvVwwozu7djywrsy4I6Qbh1JirUh6hcNX5YqVCii3ZCIn4l02eU413wXO951e3QL2LFeKaTyjeYML92MV7K7x34XbxbU77OgBfub4w5y18VVoAuV3G6lOjH7o2ZCVN90rCp3xSqwt36RlopY1Vbos9l4JmFr5Tw7sCOlR4tnD7aH4/0angxY66l1L0lBnATE/t/M9LUCDvGg9RIyPaL9Zm9dhHGy175ru5S3XsPnpcWnWwbjqX9l54ZON7sTgfaGdGIs8jW7k4NCinM7tzcgrXyHAuH65RYKH2znQ5KZSWynItlljsSHdeArKCCGbwHbKVS7f/1G4x2Jw00Wev
 cL17TFhS
 0VteJydGcqtypnHCPVKy3PNg2CkynWKj/x/Kf5o/xgjyyAr8o3yNu3Oz5BB4516mTV6eEvFekXm59gTkMw2M7eItBhzxS9snfvlvmIpza/LvNoTdrB1GwTzqpZvpAaz69upFA5ipOdw+xVqw/XMPEPYimIb4HjKgUuXKyidXtdvayMPA60qLwUALWrjVi4rCbBgSQn0BiblEAFMKfXwaZXwMyUDR0PtFH4xGfHzeZlP/rLF6lD63QO82ivYqxVGT2RbZlXtKPTOzYNsfy2IDNaScOZg31MnVSPbbKK9NdJMmhnagJ0xQ5/3Cwxorgyx64g9GTNcGtvVhVCvMzlv16cnmgwerLpSn7Rlb7k6fjCytkVI98CGF4A9DVul5lIUv7QbMsaSxPu0Ba/hwD5XYuBMxkNZYRm8VRpHkzvQKYLpwZvGH6/kSCWrfhk5svYyK8nyJ5SDSO79UrVCWl1Q3RHQ5N46HiXSU6O57Q
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/02/25 at 10:56am, Barry Song wrote:
> On Sat, Nov 22, 2025 at 6:00 PM Kairui Song <ryncsn@gmail.com> wrote:
> >
> > On Fri, Nov 21, 2025 at 5:52 PM Chris Li <chrisl@kernel.org> wrote:
> > >
> > > The current zswap requires a backing swapfile. The swap slot used
> > > by zswap is not able to be used by the swapfile. That waste swapfile
> > > space.
> > >
> > > The ghost swapfile is a swapfile that only contains the swapfile header
> > > for zswap. The swapfile header indicate the size of the swapfile. There
> > > is no swap data section in the ghost swapfile, therefore, no waste of
> > > swapfile space.  As such, any write to a ghost swapfile will fail. To
> > > prevents accidental read or write of ghost swapfile, bdev of
> > > swap_info_struct is set to NULL. Ghost swapfile will also set the SSD
> > > flag because there is no rotation disk access when using zswap.
> > >
> > > The zswap write back has been disabled if all swapfiles in the system
> > > are ghost swap files.
> >
> > Thanks for sharing this, I've been hearing about the ghost swapfile
> > design for a long time, glad to see it finally got posted.
> >
> > >
> > > Signed-off-by: Chris Li <chrisl@kernel.org>
> > > ---
> > >  include/linux/swap.h |  2 ++
> > >  mm/page_io.c         | 18 +++++++++++++++---
> > >  mm/swap.h            |  2 +-
> > >  mm/swap_state.c      |  7 +++++++
> > >  mm/swapfile.c        | 42 +++++++++++++++++++++++++++++++++++++-----
> > >  mm/zswap.c           | 17 +++++++++++------
> > >  6 files changed, 73 insertions(+), 15 deletions(-)
> >
> > In general I think this aligns quite well with what I had in mind and
> > an idea that was mention during LSFMM this year (the 3rd one in the
> > "Issues" part, it wasn't clearly described in the cover letter, more
> > details in the slides):
> > https://lore.kernel.org/all/CAMgjq7BvQ0ZXvyLGp2YP96+i+6COCBBJCYmjXHGBnfisCAb8VA@mail.gmail.com/
> >
> > The good part is that we will reuse everything we have with the
> > current swap stack, and stay optional. Everything is a swap device, no
> > special layers required. All other features will be available in a
> > cleaner way.
> >
> > And /etc/fstab just works the same way for the ghost swapfile.
> 
> Apologies — let me raise a question that may be annoying.
> I understand that people may already be feeling tense and sensitive.
> 
> Despite the benefit of compatibility with /etc/fstab, we still need to provide
> a physical file on disk (or elsewhere), even if it contains only a header.
> Personally, this feels a bit odd to me. Is it possible to avoid having a
> “ghost” swap file altogether and instead implement all "ghost" functionality
> entirely within the kernel? Ideally, we wouldn’t need to introduce a new
> “ghost” concept to users at all.
> 
> In short, we provide the functionality of a ghost swap file without actually
> having any file or “ghost” at all.

That's actually what I would like to see. Just to make that we may need
change syscall swapon, to specify the flag to mark it and initial size.
People may complain about adjustment in syscall swapon.


