Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2ED1AFD5F80
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 06:11:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 069436B0088; Wed,  8 Apr 2026 02:11:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0199F6B0089; Wed,  8 Apr 2026 02:11:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4A046B008A; Wed,  8 Apr 2026 02:11:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CF0A36B0088
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 02:11:17 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 70D51E2A22
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 06:11:17 +0000 (UTC)
X-FDA: 84634366194.23.A1CC09D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 04342A0012
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 06:11:14 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QgpqSTIE;
	spf=pass (imf25.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775628675; a=rsa-sha256;
	cv=none;
	b=CUDgrLL3El/j1PeNX/LlJykHJwm2GudVSi6KMYqTkFLhEynUaAIWTMh4bJgYJ+PlURQVPI
	rc9GGm8Tw951908ojFar8hbUh/P8EvaEr7iBIIi/fDe2FQMY97mJWjAS+OD9EfSUWm18pE
	83MacFk6G/pJRA4Lz5/BqGSNnb23N1o=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775628675;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nlu9QF2694z5eIp7NFOSYWjTzeADANSAS/DFq4widxs=;
	b=QrQ3xJl9KXjNin+wKP+4fl9q7reMyORr3Pc2zY2J/h0fkPqhjZU71mzWZJAh+9K1pVMH2t
	yM3m8CBA1ot0Y1dGW3vpbbmKeVgaOo4GIYsREZq+L1FYiYIxKCKMS8nFHrHLXrCx0yagr6
	X/0tgXu/Y1NVPr1R9lDmYDAmSiuD0d4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QgpqSTIE;
	spf=pass (imf25.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775628674;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Nlu9QF2694z5eIp7NFOSYWjTzeADANSAS/DFq4widxs=;
	b=QgpqSTIEpnbEzFDQKMsXL4fiY9UtSHNV8CfoUAs1+lvd+laQX0GRxwAIVoGAojU86z1LF/
	VSzr+H0zNY6Nhqc4MNdPMHHftBntMJ24/DjohKB1ag9/J+rKzfdRiOvXIigzs3IOuXntA7
	JnY6nQwazZz4vLBOZaFUv3lO6TMqn9U=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-170-4Sjs1-YKO3-Ff6kAJSAQUA-1; Wed,
 08 Apr 2026 02:11:08 -0400
X-MC-Unique: 4Sjs1-YKO3-Ff6kAJSAQUA-1
X-Mimecast-MFC-AGG-ID: 4Sjs1-YKO3-Ff6kAJSAQUA_1775628667
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8206F1800345;
	Wed,  8 Apr 2026 06:11:06 +0000 (UTC)
Received: from localhost (unknown [10.72.112.14])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0B2951953944;
	Wed,  8 Apr 2026 06:11:04 +0000 (UTC)
Date: Wed, 8 Apr 2026 14:11:00 +0800
From: Baoquan He <bhe@redhat.com>
To: Chris Li <chrisl@kernel.org>
Cc: Barry Song <21cnbao@gmail.com>, akpm@linux-foundation.org,
	linux-mm@kvack.org, baohua@kernel.org, kasong@tencent.com,
	nphamcs@gmail.com, shikemeng@huaweicloud.com, youngjun.park@lge.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] mm/swap: use swap_ops to register swap device's
 methods
Message-ID: <adXxdLSHp2E2k6_5@MiWiFi-R3L-srv>
References: <20260328075812.11060-1-21cnbao@gmail.com>
 <20260328075812.11060-3-21cnbao@gmail.com>
 <CACePvbXVaK0McYSr8O7h2XMpEh1f1JGzLVJQd69V0QnFXr8Evw@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CACePvbXVaK0McYSr8O7h2XMpEh1f1JGzLVJQd69V0QnFXr8Evw@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: ORzVMPBdbqrrkXklE8gvacIQFjBZ71Gc3ZCxta0ps3g_1775628667
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 04342A0012
X-Stat-Signature: 1qsczotj7icd7puwjbuq5351q3oq73xi
X-HE-Tag: 1775628674-891777
X-HE-Meta: U2FsdGVkX1+Na/x4hHKIe4FH9t7Lq8Ky5VWtneYwcgX7JrBhsjQfDomhJSUX0WiLQjy707xKnviZk9hUEcHBMBXrVleBAnbTHicSP8x9FZHGxNXdqcr1+6aJua5/XmznBAVSIruJBjV2JWW9djBJ/GO09/ijhSfZ8xLKT09YGUZQZLmTTEGfaPY3gY7Z5O4u9EhgzYIEPR5HzE8rVCDmCreBQMMv3+tZKhV/p6VMJp3ALioMYGK9Rv3q94i5nS5yKRexmE2z0cTr6O4DArfUdygds9W6bWMo4y3xSx4K6BTSCcSGk6k/IQyzgTl2hul30I+ZE8VkSl7ZqPe/kaOHyJgkc+XTFYL3pVNxkXfT56Pd87mVAqhr9dIIbQykazuNdk40JUdSlQzxTB84N8PxDfgqv0y5KK5upSLv7lotaN9cvt7oW3O8hkDaZfJpg1Q1Ge/IdYz876EoI0qeLsVfIxTMRHv/Fuj+uVQgPoSW0cJvH6Sc7f8UYD3cm8GJnUxynha53RRif1UsS3c2r5SW36YN21YDvJ1D2M0n0VaeinALu+ZSR9AZ1uWpFToIp7+vdn6SaCQGxIkyGZM7kqkb7wQccdAm8rPCcChu0eLz1veEKkmmNtNqFmVmOM7nPuFA70H/FTdIb2P6QM88cSpCqDs5MMvb/MeRmpXtb3ebXvFdL5iU3qC1nUF9nZ/6khc+xHoJGLfzXfdN9valwTeHMtyShdVzs9n9djC5wNI8ob7wQxxtYxpN9uUR0GYpMFxYNxTEGlQKbOLg7haD24quYmju5G6Tj1DEeH+HqazpTDDA7Eqjj0oBLl1cZ1v9V/LuTvr+cB7pavsVMxE3LXVz+RDcd/6lpYZnaGhqVqKbiEaz09TJ3wX9n3X89e20wPtZdEGsgxqIxdHIYbnvLWAbrzbj2qghQ7T5+Qm6U0UfW2Lb2XHUjhce3KuwhzTyA/Jn0NH419Qk8bRWI+rE/xF
 0St822Lu
 sx6bYbkMLiGdKECa1b4rsOQ4gpo2xrkph/PF/V4a+M30TAnmJKoaKpgrg2VZH84szZYS2amZHP6vhyzC6M4HZvPJuokrkmG9SQbJ9PqGYyJEwy2Za/z5qvMaYZ5CcIFRrHphMWaaXGkV8uNjl8a8kuI3b37o5oUq5cMTTekcOoWgUEdjkB91Qh5bDrONBzxG2dblI1f8rWCPNjsPlfqmFmrNYOspXI3EC8G2Poib9JuUsnq9AFO9PZ+o89C2KmyoYHPj5V8R0Nnmi05Cj+w61HCnb2CbDrNGwuQjkqe6a2014hajSptd+rEmjXwnfUwIYyFuguVVr04oeEjO+lmT0O879dL6aZKCtU69rEqlzCZMW//4wt6rb+OhzpAEYwtrLNh3rO/IpIxtc9Xcjwh8zkUA030hMphCuxymiqbeyW48VubG/CCFvuqn5WU51O3H0ygWkqYje2VvYU8g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 03/30/26 at 08:30pm, Chris Li wrote:
......
> > @@ -608,6 +593,39 @@ static void swap_read_folio_bdev_async(struct folio *folio,
> >         submit_bio(bio);
> >  }
> >
> > +static const struct swap_ops bdev_fs_swap_ops = {
> > +       .read_folio = swap_read_folio_fs,
> > +       .write_folio = swap_writepage_fs,
> > +};
> > +
> > +static const struct swap_ops bdev_sync_swap_ops = {
> > +       .read_folio = swap_read_folio_bdev_sync,
> > +       .write_folio = swap_writepage_bdev_sync,
> > +};
> > +
> > +static const struct swap_ops bdev_async_swap_ops = {
> > +       .read_folio = swap_read_folio_bdev_async,
> > +       .write_folio = swap_writepage_bdev_async,
> > +};
> > +
> > +void setup_swap_ops(struct swap_info_struct *sis)
> 
> setup_swap_ops()` needs to return an indication of an error.
> The error is that sis->ops is NULL or op->read_folio == NULL or
> op->write_folio == NULL.
> If there is an error, we should fail the swapon.

Thanks for your comments.

In the current patches, there's no chance any of these happens:
  sis->ops is NULL or
  op->read_folio == NULL or
  op->write_folio == NULL

Because it's a if-else logic in setup_swap_ops(), adding an error
checking looks a little weird. I think it's worth adding the error
checking in setup_swap_ops() later when we have new swap_ops added
and there's potential any of above three cases could happen.

What do you think?

Thanks
Baoquan


