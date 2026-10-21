Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44AC4606A319
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 20:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=agM7aTRp
Received: by kanga.kvack.org (Postfix)
	id 4C7DC6B07A7; Wed, 21 Oct 2026 16:39:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 478CC6B07A8; Wed, 21 Oct 2026 16:39:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 399AD6B07A9; Wed, 21 Oct 2026 16:39:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 14DE66B07A7
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 16:39:37 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8DC8180665
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 20:39:36 +0000 (UTC)
X-FDA: 85347799152.19.4BBF4B7
Received: from mta0.migadu.com (out-96.mta0.migadu.com [91.218.175.96])
	by imf21.hostedemail.com (Postfix) with ESMTP id 59BB31C0009
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 20:39:34 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=agM7aTRp;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.96 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792615174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xwh1aSFPGegHIoQoVmZYZJuIasUj9zMikVvUOAaV0Dg=;
	b=7z+AQN7cam5srKen1Qr3UDykBKpI6b+j8VZeBalCs/nKqqKlrMpv2cOKPe2ABK4+lBnjyx
	j19mIwmboPKulatqmAzyG4jxVnmu1+6UOlNchbF8xlgm9hJq+p9CNFLy0j3jsf9y5SFtCl
	igU7uRM/hstAybO1/FtJ2BtFe1h+qWQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=agM7aTRp;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.96 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792615174;
	b=2jxNHbfUw8Se4hM+bRddxqeHpvHhtg7aB6N+9Z5QgEYS0o4nPuDChsR64hlGwn6OBUT8bR
	GfcO5h6c/AaVUkFBG0rpSRsFAClDmRLuxpZGQZ7i89qxnylLr9Hi/hOn4vEz594m11ISqy
	5IbetY9/8aL07/lbk/Eh86/9LbVOWno=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=vClqkVTrJPkFYg5VhfJJpI0t2mCXeKvHhObIxE+Ggik=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792615172; v=1; x=1793219972;
 b=agM7aTRpgrVVNIvEBdzc+AzCrrXGmqKdLwlSSfeBLwT428NEbTqdx1lrTmfBO/DA55bB/jZr
 R/Tr9v6a1G/d0vFNjAmGZou5C4kS65zrPrj0SsoMj0BBtI94l+SJx9nrYw58Fp+R7YK6/A3376F
 jewissj2UA5AW0xN2ZbPV+RY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 7c45c0e98498beff;
	Wed, 21 Oct 2026 20:39:32 +0000
X-Mizu-Trace-ID: 7c45c0e98498beff
X-Migadu-Flow: FLOW_OUT
Date: Wed, 21 Oct 2026 13:39:27 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Yosry Ahmed <yosry@kernel.org>, cgroups@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v1] memcg: fix cacheline contention between lruvec stat
 updates and LRU lists
Message-ID: <atkiieAmMFxImIXI@linux.dev>
References: <20261020200730.250189-1-joannelkoong@gmail.com>
 <atfrhsr6bft4t7SI@linux.dev>
 <atjhiAxEyoP48e0X@linux.dev>
 <CAJnrk1Z=ZqTvfO_VYjG=KnHRvwmhNBfYfxpiZiKWPdMYnsA2qg@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJnrk1Z=ZqTvfO_VYjG=KnHRvwmhNBfYfxpiZiKWPdMYnsA2qg@mail.gmail.com>
X-Rspamd-Queue-Id: 59BB31C0009
X-Stat-Signature: e17cjpnjg5wiygw3ijdfswtbutpw9qwt
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792615174-157457
X-HE-Meta: U2FsdGVkX1+tNAP5+ZN4k58RXter7uRK7f8RMsIDi0oMHElQ3Kahv6PlKRIjwdEd7mZFKjK/SON1keWJrIfoV3MphT5Z0wB0QclRzltUOfss683DIIegFu4Z0q/RpCbLc4TmvysrYhEpk2iftRbqDrV05zZepRDnTF4xRQkjER2WRY/h0FkGOFeydw/HRNZvcIRNr2cFpofkhluvg/zpfCPFhlcY97SMJGpUNwnjP93LAOHMWjKInf0hxWO+1EZ+SmaVExErPAdrUoja/O1krtySRpX/MiObInoWgsoIKkOGtYyoIQF3EhIWFFu496bPChU43NIC0PwKSd25LSLEWmnCLRNgIfWcyZEJJ6QWeFEX0s+kVLxpfoBy/oTOogP9M7rKNhbF5jHflpge82/3a8pNltXU6OfseUkhikDy/nVmBrZBBB1DXkZD5NyZFzOd5J7UCn7lfMLiqTDNK71ZQp10lq/E2taWHJIbT9/38hCuvr/fAQMc5Bjf2JFvghNFPB3ZfMF/5MLc3TLV08NZFD9ULBbEpL3Q8MEriahxLHis4OSPIfDN7RgW08DiGKFe3AWA4/JUzmeWBgsZNSc1lRx8PeM/SsjFrcPmDDbCletrNxARX7B7zjRoQMEuRz95zJs3jPlApIxv1Gc4c5t2iPpujsZ0h1I15nztC2leUoNGajsFTX8hWeY8KsEWDK4jyFyJJs+eUpw0kFSm7+1/sR54koWVn1hyH6P0FCIkxuEb4wD/MpmvQm4vG6C0PJRsH+o9GCxblPYpF7rp62pt5T8ZKdmlO5wUl9nx5I/VrDziN4ruuxB6SbHEP9U1vH3kvBshkt2B5MoAuCcLYQ8DCcQ08InjKsoPemVj59oYsC1xBkzWTSn9WSabxcuwWFcN/xgvBKLv2MBRBwhkgCsS6sTpBX05ixCKTcSvOnkZ1U1ay/hdPBCwGKggNDFeLHJ+XFn4Zrj2df9mkj83hcI
 Tu8t6qFY
 fA/ZdTcfRuh75ktzlAvjggIc2Y8oyEAEL8+w4PGFEgNVzr4XK0FBqycUytS1Cy/NbFpOST6bHZ6xQPmBOrisUUKjYSvm0/7HGUbKmX9j7TQC4Ar0i9SochvdO1KKoY/6ZgKpk9pl6BIfRi3mFNgzUOEBM7NVr6LVJN3z/ZYdLKDCiDko74fVSKgGYf7AYyHfMMY4K7+EhzTRqgfL0lI7xSGJTAgqN4UUPcUqHpZO0Fvmkr4kz/OnX6KRaNnBtlqqZvhO3sd8xpsiGyimvsv/vvMUj6ZfZtEd2sTxz5FI5lPD48Dk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 21, 2026 at 01:04:36PM -0700, Joanne Koong wrote:
> On Wed, Oct 21, 2026 at 9:12 AM Shakeel Butt <shakeel.butt@linux.dev> wrote:
> >
[...]
> 
> Sounds good, I'll go the layout rearranging route then. I verified on
> the Intel machine that rearranging + the pgdat change gives the same
> results as this v1. Do you want me to include your rearrange patch in
> v2 (with your authorship and signed-off-by) or do you prefer to post
> it yourself and I'll send the pgdat change on top?

You can take the patch and the ownership/authorship as well and post both
patches.

Shakeel

