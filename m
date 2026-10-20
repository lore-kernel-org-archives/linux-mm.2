Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1882560A2609
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 10:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=UId+OeFc
Received: by kanga.kvack.org (Postfix)
	id 1AA586B047B; Tue, 20 Oct 2026 06:50:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15B686B047C; Tue, 20 Oct 2026 06:50:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 071946B047D; Tue, 20 Oct 2026 06:50:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D59846B047B
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 06:50:55 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 69B6D80113
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 10:50:55 +0000 (UTC)
X-FDA: 85342686870.24.F34F863
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4D386C0003
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 10:50:53 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UId+OeFc;
	spf=pass (imf22.hostedemail.com: domain of bfoster@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792493453;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JANbW0OsMsiIZhYIihCc20hPsaNmoKXg98JEd0I6bjw=;
	b=Vs8CIU0pHZ7VbonwGGzrNRLok/sduBYiGn6TZYe+VtI19WRujG8Tt3HQr2XFnyrbM01evQ
	lg9bOzsAjuQ8V1bFIvrmqUZfReqHkwWipWPXUCkm05YFwAVPmo9pRTC+TatyeA9yXnP3pT
	hmrpdyHzTMj1s0plLJqj+PflkEW5Fk8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UId+OeFc;
	spf=pass (imf22.hostedemail.com: domain of bfoster@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792493453;
	b=LgiVTiOyrGvmiDzB3/JuNZqN0G/Gms930Tz2MQo1jRk5oXaQ8kIhIU70BphSJAE4t6aw71
	GbmPjHnq2yX98N3xr7TdXal9/VxydhPTpVpSV3RirqDU//iDGjHRkF98slgNBrkHAqs0Gc
	fwFsDHhdPqkvnjWPgEs3AM20VuhXEXs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792493452;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JANbW0OsMsiIZhYIihCc20hPsaNmoKXg98JEd0I6bjw=;
	b=UId+OeFcEzpCEWiS/ueuAApr1U/Vfy4ARHh+bCVBhRvDvT3iBJsLOJ/AEw5Z7k26Ygdzt9
	WLUse0L1ohGSarC+t4bpJiAG5BknChdhRT/QtPDyW8N6h518jDatSihNwLmvfD7qP1G39F
	Si0rkvyB2J5vmAqFj6iOifffIZP+0dI=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-503-d1ZaYW2ONtaZUUzoThD6KQ-1; Tue,
 20 Oct 2026 10:50:50 +0000
X-MC-Unique: d1ZaYW2ONtaZUUzoThD6KQ-1
X-Mimecast-MFC-AGG-ID: d1ZaYW2ONtaZUUzoThD6KQ_1792493449
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 513181800655;
	Tue, 20 Oct 2026 10:50:49 +0000 (UTC)
Received: from bfoster (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CEF391956088;
	Tue, 20 Oct 2026 10:50:47 +0000 (UTC)
Date: Tue, 20 Oct 2026 06:50:45 -0400
From: Brian Foster <bfoster@redhat.com>
To: Nickolai Zeldovich <nickolai@csail.mit.edu>
Cc: Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Theodore Ts'o <tytso@mit.edu>, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] mm/truncate: fix the zeroing end of
 pagecache_isize_extended()
Message-ID: <atdHhW7JU8j5pozl@bfoster>
References: <20261016222721.791785-1-nickolai@csail.mit.edu>
 <atZw_gtMIIKXgc1q@bfoster>
 <CADGQE7H91ZwPgUzPHoAJmF3WjzRKxeQkQcV8+BLdGn7+kkEduA@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CADGQE7H91ZwPgUzPHoAJmF3WjzRKxeQkQcV8+BLdGn7+kkEduA@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: NrLbpKeFAIj3FmED5LIe3zI8qh-ua3RfqTfAhilqxrE_1792493449
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4D386C0003
X-Stat-Signature: dhfa8nxoe1x86moid93n4nxy9z1zooc7
X-Rspam-User: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792493453-395993
X-HE-Meta: U2FsdGVkX19scwNILNr5FOH8ogChmYZDiQKdg6NTMnandiyOFKl90Q+aswUeALz2GYm19MT+NIjArATSxvDRB4gXXkRBqD+266rLzDh8r6fB1JJNI/hD517VMCyl/d0ieg+DIicPZaIlZdkXhXXefGJtOeaJ4xt+Jb4ZwVyfvhNN5X4MtUWuZevuPWk08dPxHM+87MsEbW39Xlrqq53ocKInygSXea+GaoXlHJCUCtilDEsUcI2GMZ4sKZsCvneP6NCoz4ARgRFF3+KChisU1Ic6qiggCSTCea02rgy6BXtfYiAjSgWbvxjVgrcORsFTEtuhIJ5MpMm1MTIeZlFY/mGcMvwm2Sk67ZKB8jK32joLWGk0UKbkpoBUUs/nPHVPR+OSbxwOMGJtgms6d0ilduEYiQ0EXTBuNwWfXYXdhS/IlxWXjqrOvkjBiaFLzTwXWthSEm3JZo045mikEOL7LAeG/WpS8P+s9O2b3ZQ4+Bg6NlaYfa59nPqPilJ65LyroB3hTzgA8B2mcd0UqShTQOhN6yl5eGUfLePAnFM8W11j2rL1lSTYIH1D8/PaxuPXaVNmghxqo1owtX/yGW3Bup43KkdUz5Q+NHjy06ulpDyZDs5ON6VdeHxOhUx5+dU4UnVSRch/WnNezqJG74eoaJ/McbeHXsG400Qx18avx9dnjzFxRmDR/Q6XF3ylQ/jO9aVkvTYrr40P0s7wwJHdAAosg4xgFqKMB3tbYZryB3vcFPQIoYpeva9zXCXXxum4bIDh2xP2oUSb74Y43BEBRtz/2PV+AWkV8c/VgORVYYnIaebYuD8t4oZsm/9MRJO6JOEAIFM3/GiOPSTSA6A0yeRXbRUmQPnifLa+giOPZWYIzyR5WEAuFxeJRaNA//EA+WPcLjjNm7Ud7F4IYtW/HuHbZLEHOOX/wAcb3EiQK+d1oYsv48EzBoQWK6NVMmu0hf8vvkqSFSq/pnsSXj9
 kI2RzxGy
 5mt6bDc5CVq9/u/4aLl6m4NuExHRtoEJCezRX5xQPUaiPRhLFZ7gA1GjoXhaNbN8dVUZyx6RaLYEDNIftl3Nyj920wQleS7heK95+kSkMAJ9wti87UTZVzOzl2QpBILn54RrHNpCp1SI8Ipk7CbnWZCN8NGq+Hpd8JpUg6ScUmfCFV8Lr/9obe26t3k6i6jFvVDpXbIMiX2jrdJRutB+CjQj6yUoDWHwMDzEQJ/JvLFjYHDwHp61WDv8s5IihhXLVDD7H1fxwUbyLukUHt/KVLse+5hC1H5N7QIPeGhX+mwk6o+VAjgZcc3mOy90qQSesXWnZzxNZU/8I/cP0t4IjyDt2bOIhcPSKa7zEzVJCYOTxAKhFWoyloVLXB97lZSl/vqO/7PofCxOFLYNBD6p9/w5M7k/4m+/sXSsscHaoJNYLQxRa30PwPJLuaFyRIcQIH/XHqhF6IQiD4po=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 19, 2026 at 03:54:14PM -0400, Nickolai Zeldovich wrote:
> On Mon, Oct 19, 2026 at 3:35 PM Brian Foster <bfoster@redhat.com> wrote:
> > > --- a/mm/truncate.c
> > > +++ b/mm/truncate.c
> > > @@ -878,8 +878,7 @@ void pagecache_isize_extended(struct inode *inode, loff_t from, loff_t to)
> > >               unsigned int offset, end;
> > >
> > >               offset = from - folio_pos(folio);
> > > -             end = min_t(unsigned int, to - folio_pos(folio),
> > > -                         folio_size(folio));
> > > +             end = min_t(loff_t, to - folio_pos(folio), folio_size(folio));
> >
> > Good catch...
> >
> > folio_size() returns size_t and folio_zero_segment() expects size_t for
> > the offset params. Perhaps we should that instead of loff_t?
> 
> size_t is (unsigned int) on 32-bit machines, like i386, which has the
> same issue (reproducer from the patch).
> 

Ah, Ok. So loff_t makes sense for the min_t(). I do still wonder if it
makes sense to switch offset and end to size_t while we're here though.

Brian


