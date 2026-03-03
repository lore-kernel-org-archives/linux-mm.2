Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80340E67A8D
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 07:24:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDF9E6B0005; Tue,  3 Mar 2026 02:24:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8D076B0089; Tue,  3 Mar 2026 02:24:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B991D6B008C; Tue,  3 Mar 2026 02:24:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9D64C6B0005
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 02:24:51 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5CCC21B8587
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 07:24:51 +0000 (UTC)
X-FDA: 84503914782.13.B6E7FE4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5B75C40010
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 07:24:49 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=I+A3+IqQ;
	spf=pass (imf27.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772522689;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ByG1NeZklCsEVBCUC3bbFWInfpuSV/3KRGnckCFRoa8=;
	b=dfZPvJPOPzGcvBZVAuH3IjwDTkD2ZIDJPaYTlqrlT3YJg12tX7RMhx/BulKiD0JlZlpVY+
	0sKQymAU7TMgFCNDeTg4tIgGIrN8Wx1ndW8nhzk48BScbwxib9nGbcgz0Hcgo5gbFy0+C4
	igCxRNXE43L7JU33dc6jhZlmV+8vAQ4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772522689; a=rsa-sha256;
	cv=none;
	b=drGMIBJWqcL7BovnmZma9ME/SXBLzbBX+1ft87d9lynN9Db3dt1EbQ/S6iTS31e6kZooAv
	ejeL3ara9SQ5AFCezdEaWILZuOZLc1qRT5fhs5MVcxaQZcpmcJCqCNE+C/+VbvFNWYP0/7
	45tiSlu896nwgFDcV9W++qPn6Ndb7b4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=I+A3+IqQ;
	spf=pass (imf27.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772522688;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ByG1NeZklCsEVBCUC3bbFWInfpuSV/3KRGnckCFRoa8=;
	b=I+A3+IqQxYcjBJhW2Nuox+Ixg9170Bgw5LwRrCSMeNq2EjqGsnR5AN306Dw3U1x02sgpiO
	xw3CbOMlc1qKmxMesKhP8DJmris9Re6u1LFc5Xq3PD2BwzbFEl3Tx9DjI6cCNmdzMkAHfv
	/Tv+hEQKqEmUXQkJ0lcXtTT830GMH40=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-128-bab6XE0aPwmNX2oJWKzrbg-1; Tue,
 03 Mar 2026 02:24:45 -0500
X-MC-Unique: bab6XE0aPwmNX2oJWKzrbg-1
X-Mimecast-MFC-AGG-ID: bab6XE0aPwmNX2oJWKzrbg_1772522684
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 726AA18003FC;
	Tue,  3 Mar 2026 07:24:43 +0000 (UTC)
Received: from localhost (unknown [10.72.112.42])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 450CF1800349;
	Tue,  3 Mar 2026 07:24:40 +0000 (UTC)
Date: Tue, 3 Mar 2026 15:24:35 +0800
From: Baoquan He <bhe@redhat.com>
To: Nhat Pham <nphamcs@gmail.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org,
	kasong@tencent.com, shikemeng@huaweicloud.com, baohua@kernel.org,
	youngjun.park@lge.com
Subject: Re: [PATCH 1/3] mm/swap: rename mm/page_io.c to mm/swap_io.c
Message-ID: <aaaMs-UKi7xbNVXn@MiWiFi-R3L-srv>
References: <20260302104016.163542-1-bhe@redhat.com>
 <20260302104016.163542-2-bhe@redhat.com>
 <CAKEwX=OZwnA4gXGWKMHtby5rTnBAPP3hqFaCEkBKzfFYfaD0VA@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAKEwX=OZwnA4gXGWKMHtby5rTnBAPP3hqFaCEkBKzfFYfaD0VA@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: EOrKEI5AGew3s2W3J1FeIwlB8aJhg_Z9ficaBjCy3G0_1772522684
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5B75C40010
X-Stat-Signature: ynd5gjxmsc3wnxo6w9yrjhg9wbqm655a
X-Rspam-User: 
X-HE-Tag: 1772522689-302354
X-HE-Meta: U2FsdGVkX1+FvKUMPo86NMvGoitMR5FCeRWPL4+LBMMVq6y872Q90Odnm8kiEArw6141HGTCuaKgnXOdKcUygbJmoPQakNYbJtAktIEf+Hj4PBpdD5ONN09Nc4+j8VKQlB8UyUqrN3R8MzcxJE6lRpIqtAEzMQDXDBuafIpU23HgbEr5iS3Y0tF/ENnwdKoF/EkwiHLZYuT6u4ALnQJNyStpREgCMQUaMA2A0kCk0OZs07GH5uKg7rCxMdnus1v6V4dyoXyXAFUx4Q+CkmRo0eo7QwShpGKBh14DPF0F7HBavp4+PFOauedI+GqGFnFKFag3FEK9fdvLzxSnBPY/LxmCRF7ADW6qEib0w8xzMJGcun/sHTDt0NyTqHVqEJSTVcMwthjFOUYNP9o01D/O2SFy+6ODxCDrxfqjzSyuteQzgS1d+JHvKjglP0gXpj24uRMvfdyPIfph2qQizm3jqqWCfNYHkD2VN0gsBycT+Vlfa1GQtoorLZb1KZ+0nLjkhh+ypdli7vTrx9xXdwze3cLbtb2ufqvS2+KnGnkhSUpYvlhA4aOkzIXuo4FUip3EP7StFQJSIQlyeynDVzuYRVduVJO4NvV2Z6XwStQwy9NhP4cwkUhB5xISV0HgApx5KaTS7g8nvCkoEeEcCjmDgt5L1bd98imr8HMtdwHUPciDZpFAhWNTPNCIFZn/MAp2k3oJLdcnJnANQrJ28SB1CHTmyVb3AN4sh8otO763GiAss8zDFYCk7Hkzw50fZCrFg37jisaeud/riH/YW6IIBYS3dUTbYx3jEtoqvc1agF/vPFEXbSXptSDVqrQc4klX/8wQ3a41Ezv7YuHzcXU2MUuhElUvr+dCbz+5mG8QM/DTdgFIZ0gfM0V2UkHbfKNEzNOGwBB9lZDvLzpYGmjJgADaJltCqtpCw+Qe+uw1DR76igzqufimpVwvBobIUOuktHulBUHUYkgTlA8Ab23
 7+3eORa8
 sZtjDGdxtGezfRnsYNboQGzNwGqj/S1vPkC6DS+ZRcoErn/2H8wocKbzCBKOZ0KeVdJ04XayZxKZTW6zlFQQQOLkiQWzqnABdsAP0+r63GA9mOTidbz0yz/8zry+D30ZQlSpFrN0IoOi+bU/FabSmopexqQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 03/02/26 at 01:12pm, Nhat Pham wrote:
> On Mon, Mar 2, 2026 at 2:40 AM Baoquan He <bhe@redhat.com> wrote:
> >
> > Codes in mm/page_io.c are only related to swap io, it has
> > nothing to do with other page io.
> >
> > Rename it to avoid confusion.
> >
> 
> I wonder if there's any historical context here. But regardless:

I traced it to 1.3.57, its name is mm/page_io.c and included only
function rw_swap_page(). Linus named it at that time. No further
historical context.

commit ecda87c064fea1d7322a357b78b99e04594bc6f3 (tag: 1.3.57)
Author: Linus Torvalds <torvalds@linuxfoundation.org>
Date:   Fri Nov 23 15:10:30 2007 -0500

    Import 1.3.57

> 
> Reviewed-by: Nhat Pham <nphamcs@gmail.com>
> 


