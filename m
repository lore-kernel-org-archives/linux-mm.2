Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAEDFCC6B03
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 08:40:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D19066B0088; Tue, 13 Oct 2026 04:40:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC9C06B008A; Tue, 13 Oct 2026 04:40:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE0176B008C; Tue, 13 Oct 2026 04:40:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9FCB66B0088
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 04:40:51 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2C01F1A0BF6
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 08:40:51 +0000 (UTC)
X-FDA: 85316957502.08.F92C58D
Received: from mta0.migadu.com (out-163.mta0.migadu.com [91.218.175.163])
	by imf06.hostedemail.com (Postfix) with ESMTP id BABC0180004
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 08:40:47 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pbyf7Z2H;
	spf=pass (imf06.hostedemail.com: domain of pankaj.raghav@linux.dev designates 91.218.175.163 as permitted sender) smtp.mailfrom=pankaj.raghav@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791880849;
	b=I3zKGO6a8SIjxUyxUdqyqepGYq86fZAtI2wQuVPYZKGApX0k6Zauxd8qyL4sOoRm1EztdJ
	TU7Pm3JTboGKg0egUJEsENEEYfrDJe3YWgDjkuoaKZpqZC/nrWp020SwiVRxZAYTXS3e2w
	Ir+6KChl7YzPsIdv/OSB5m26zHCOgZ8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pbyf7Z2H;
	spf=pass (imf06.hostedemail.com: domain of pankaj.raghav@linux.dev designates 91.218.175.163 as permitted sender) smtp.mailfrom=pankaj.raghav@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791880849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eSvokzNFcQ4Noy52y9PgdlSImKqYcqTJLUQSyEWHkOU=;
	b=ZvdjKM+jOqpll4B9+NpTLwTfrVD16lOTra5vnERwRMbCUAFWqV+U4a5MjMVt/PErOfYT13
	wEzBXHSGesPUGrGaYGPe9TN5UPkigNn8oc5KP8kFaxQJWuUavH5HRz4GghjDcRM5DEj/bK
	Ob6ZS/i1wN+wi+2rDkqmatVA+Mk9LNI=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=YOL/7WJfxHmwLvZpmThwvlfPLOa9o0yfUqTDeDDxNdU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791880844; v=1; x=1792485644;
 b=pbyf7Z2HdCVXaoI9fyHQ8ArFBeZoeexs3jGDc3IlAS52lc08Q4dSHhGERHsOnO7IFThEkvRB
 dV4fETr2UBsyEB+9YVSfrxBYwjITjTvcocQJ0NIAqYCGeJC2MiUpnq+MDpz0vUBrBrSjeIjPjE0
 +z+1N6AHKoIoj8v0mZkXU+ns=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 8cf670064a0202ad;
	Tue, 13 Oct 2026 08:40:42 +0000
X-Mizu-Trace-ID: 8cf670064a0202ad
X-Migadu-Flow: FLOW_OUT
Date: Tue, 13 Oct 2026 10:40:32 +0200
From: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org, 
	"Darrick J . Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Ritesh Harjani <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, Christoph Hellwig <hch@lst.de>, 
	Dave Chinner <dchinner@redhat.com>, Daniel Gomez <da.gomez@kernel.org>, Theodore Tso <tytso@mit.edu>, 
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Andres Freund <andres@anarazel.de>
Subject: Re: [RFC PATCH v4 12/12] iomap: Handle deadlock due to repeating
 folios in RWF_WRITETHROUGH
Message-ID: <as3t7j3P3mQhsr7p@quentin>
References: <cover.1790596383.git.ojaswin@linux.ibm.com>
 <5159efdec832e8179e9f689a9292f9bf47d9a0fa.1790596383.git.ojaswin@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5159efdec832e8179e9f689a9292f9bf47d9a0fa.1790596383.git.ojaswin@linux.ibm.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BABC0180004
X-Rspam-User: 
X-Stat-Signature: idg7iwqt1ehfue3mmt5er5wcfcgf4yx6
X-HE-Tag: 1791880847-415969
X-HE-Meta: U2FsdGVkX18PkONSMrEqBbO0vFxNg5YlEFoxvehHffgoXwwO540wNv5rsPYa5rDaJmnWVVBWd1LJgrWCcEfKxick3Cj3WdoStGDBDnCXWZmoArCrYc8yIODn4McjoIqewRtUU3n12XvRXm/azToTJhIzK00/E/g3KiklCcGB3JT7ivqpjOwh1cV2Oaq8mdFlsGuCV2ks9tNhJSr0ev+dJ8QTfJnJrtN3Dq/I5jWgR1UG/Am7LPpyfsDwlSQbkR4qUtUa6FHB0MbUX4nztwuU+APjlghpDzeLq9Uw4cqDzoKnVnK+hH5S/z4+JzRosrl4XzHCiA0v3IQrEmGwHVTwec6wBFgxfPyPKVs/5Z/vi5IhyVr+Pko3Gqbe7e/Rbd7lBQZT8EDDyn2c75De9PmM7Z6XpQmwcX0zSrFWRvhWl5nPeJ7EgkKD+bJTPq0o+265G6iwkfRcf+7QVzeqhYzwOTSfR9LnCsZ06m068FwMILcQezvmsDBAftC1Ue6vHchU1HH4+dg/cCHrvDtUom7u5XZ24h6DocBqVYr36K7nPNmiHLk5DFefNOsQOUluKz5jQbPeH2g/L7ITyDP5JaJgoXxpiKYNIvCDtNcIn/7aZ/GcWVDRWxNGv6n8qs0U7tmLV550AF5SiQsfazTQiikul77mVajifJelacsTs0oD4IJNmhimsXmGFmPMx/X9HJQGKX8jMVNelUf54znjFqhOwmXCpopGssX/yPt4sywTabZ8bs4YeIzkMW2k3yteC51QxeurQBeRljRDROEpSyOZlFIqLI4+AjtlQVVC6oeWw6NMSSm/z9IcL43gaJ8Bk/kEIjPv7qiQRIMHA9BsooQQSaD5jMvH2ZpTbdjSrDbgXLFaQFPMrmX2Mr3ziZyjuuqA3S9d5VzQ+m90wVpydwzLTxw3FlzzuwO6yrRFwIfYcpOgn/gSuzqOclQxXvbHsbjvFHD7bRQ+nZwUMYccM0u
 2ElgDqEE
 6+rPT5ZToG3QfDLyDyw0UtAuZ3rDzUhc1KscUuwiMCgVczxZaJYUzUVsNMoA1UjSzIXri23skkNQV9FA2nZFId26LhA8bq5j2dx0Sy/5tcCB7T8VBm5Ov0I41epI/Rb8wlQ4VbUpEx8N2Prwb0X2749ez/kZ6o/ozBQNu/uNPZtVl/evxiu9fHQd2OFungpb4d0Fyn0T2PHcg4mQGCtCxVYZ3As10QtdwhjZBPhulPUfe87uFH52+fmA1kTMVGivneLiAeF9Atz+M50YWqHVMaBQbRXmcwKMq5uEVp0givfCY5qxTrsJHR7in9mDz2yRHX7nph/PzZuw+/MeaC4u/XNe9fw6mtCBGE+xGnE2z/7YXQVCrjzsyDo2ymlN7LWaX8aOt8KTvg5qAalA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 28, 2026 at 05:33:13PM +0530, Ojaswin Mujoo wrote:
> In iomap_writethrough_iter() we might encounter repeating folios across
> multiple iterations. Repeating folios can occur if, example,
> copy_folio_from_iter_atomic() does a short copy due to userspace pages
> not faulted in. This is an issue because a previous loop might have
> started writeback on them but not yet issued the IO. In the next
> iteration trying to get the same folio with FGP_STABLE will result in a
> deadlock. Since repeating folios will always be encountered back to
> back, we can just use a simple cur != prev check to detect them.
> 
> Use this to avoid waiting for writeback or starting writeback on folios
> we have already processed. Note that in ->endio() we might end up
> calling folio_end_writethrough() twice on the same folio which can cause
> issues with folio_xor_flags_has_waiters(). For simplicity, just change
> the folio_xor_flags_has_waiters() call to an idempotent variant.

Is this an outdated comment?

> 
> Reported-by: Pankaj Raghav <pankaj.raghav@linux.dev>

Thanks for fixing it. I think I was able to trigger this in a VM with
limited memory where the chances of short copy is probably higher. The
fixes makes sense to me.

I will run some tests this week and report back if there is an issue.

--
Pankaj

