Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29287CCD183
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 07:47:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83C3B8E0069; Thu,  9 Oct 2025 03:47:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8132B8E0002; Thu,  9 Oct 2025 03:47:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 750288E0069; Thu,  9 Oct 2025 03:47:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 63CF58E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 03:47:20 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 361741A06E9
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 07:47:20 +0000 (UTC)
X-FDA: 83977795440.05.9B7A786
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id 366EA40011
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 07:47:18 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=a4bKavl9;
	spf=pass (imf07.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759996038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hJrU1kH+cSMClo3PqqrUhN/o3xmqIZllEcLYKdMP18g=;
	b=EgDYod2iC7Jni3ec/MzBYu+ZiU+TyBPOiORCDBIUmn9xFvrjF0odgEZTdHoUvuz0rPWUUL
	r2dzRDHXCMo+Hyn5WzzKGcXRglr4Zm01Ws18w/Pb09COCmDr3oU7kANCp2oFvKMF9JUfUl
	+i62RcTPXf6tCG9WUW4new8sVEIWxTA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=a4bKavl9;
	spf=pass (imf07.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759996038; a=rsa-sha256;
	cv=none;
	b=ir6cfmnLrAhYbuLtQTzlA7gUMLg/HKYm+cmwBgquNu/S0Yzfp5QjjEuz5qt8+Kw/pYrZ6O
	Grk9s4WmYoW4+RDBypO45db6GABeI34ZDY4DzCo62EZKXs6cvrDrhgFWR3X1yelSpWfSuJ
	VOkM7OUXVqwh38p38UeMbsHPOSyNycw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759996037;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hJrU1kH+cSMClo3PqqrUhN/o3xmqIZllEcLYKdMP18g=;
	b=a4bKavl9q9An2cNLFoavHTkfSdwb3cvN503U2aHHO0t91Aqp8yTa56j8/7GBg4fWhmDqZA
	m6bcNjnERtDP+7wP3OL71dyCWVyMGF7074YIH1FCcJgiEG+uUhuB+8fArY9R2JiZiR/XvS
	+Sx8l0qzCMKw0FlUrr2r/LyUTGwPUrs=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-413-fWfkfZxTP5uGWxTWXDMMEg-1; Thu,
 09 Oct 2025 03:47:14 -0400
X-MC-Unique: fWfkfZxTP5uGWxTWXDMMEg-1
X-Mimecast-MFC-AGG-ID: fWfkfZxTP5uGWxTWXDMMEg_1759996033
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 392C11955F0D;
	Thu,  9 Oct 2025 07:47:12 +0000 (UTC)
Received: from localhost (unknown [10.72.112.98])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 86CEC1800576;
	Thu,  9 Oct 2025 07:47:10 +0000 (UTC)
Date: Thu, 9 Oct 2025 15:47:06 +0800
From: Baoquan He <bhe@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, chrisl@kernel.org, kasong@tencent.com,
	baohua@kernel.org, nphamcs@gmail.com, shikemeng@huaweicloud.com
Subject: Re: [PATCH 3/3] mm/swap: remove unneeded swap_active_head
Message-ID: <aOdoehPH1O2vJnqv@MiWiFi-R3L-srv>
References: <20251001043436.41338-1-bhe@redhat.com>
 <20251001043436.41338-4-bhe@redhat.com>
 <20251008202623.1ef2ac29af9b9c3d53aca4b2@linux-foundation.org>
MIME-Version: 1.0
In-Reply-To: <20251008202623.1ef2ac29af9b9c3d53aca4b2@linux-foundation.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 59o5lfK3ulVf1VBqmAOfdD8spqJ06lETWCS95LYO55o_1759996033
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 366EA40011
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: qosy94i91w4q79ubmgnmk9rri6o4mtu7
X-HE-Tag: 1759996038-263844
X-HE-Meta: U2FsdGVkX18Ni41/tNBtlVaMTyp8BOHZBZLqqnqWyXTAWlSu+bq7+7hcpMyY6XDbMvjC8t/SUR3/2ANhlOkxM43YtiHgYybUPtcVxmI9KZtmMTHyHG4KV+Y0EyO3mE+Nv2fP/htPevcqlMNhXQtIoQGwIFxL7QlPf8itkQhzxRMUqv56sVKW+SRpHXMKWjxCIVb4WdFzUJc0J1JWIeAvaetvKdb0JX/PDcmVJtlRWOaX5ggRR/ycNXU8vvwTCufnO7+ceR2dBzC9DIyW5pwMB9gypRl70/XB8h8O+bMj4tzLLLjXQO7tcrcgymhT8+Iei8F39edXmKXBZKYMVgZ5odcAva4JjP0ErQ/NH2NvQS8hBmKg5iiwIO4oTWqhgWr/9cr7SV1IQ9BbmY2Fz8pbSRE+SdhK43bOpw7YKQPcRMmK0PXr8Rfz/vs/SoW0/qacJdhk4ZHRS38ov/rYgD3+p7xWJAgUs6PJIGI8seDj4MOBp+l0DkoEzBBLwgSMegmnK2gAnhxsBuxtKTbADAiQdTPkp3qru/Drwa0GJAgn0hRLdzgpfHr8nIs/UC0vGcs4TmNxsCF29vkbQyzQtHlHVYz/HkG3drRIfWLgKyTAIYIpprO9opAYrNKKcJA4laour5Bsx1piJTGHpUUx2WY61qRxop3tqnlqxOF+AB71lykCricJHsfvl2P+6/xJGw4i8p7ebY8Ekmkk7WVN7HUehnE8UwcnVc0md35u/ia4jmrQEHcx5PBKJ5dox04mzgae5llRBOq37eEWCSRYbhDCCMEnIZkZO49yIUOSCioCTnSEYRaTb1HfDxyRi98d84q6AKcxf9S7veypesKCOAoIMEz54uxIx8EaxQWx3N5r5yX3XaOf04BFmx1BwyEHoNBGRrREbBmOaOP4lFvr2T9YzPaXVlKThHpDy4QPZt/lwC0qwRi6wLnKkudCYboElik8U7Khz2Rv1poNZd0eyLc
 NzIawwUN
 +2wUKiVZicpyY/8C/k68onsAHEP8Hfd0mBBVbIZA8/QJkG14JiCz/L1KFMJdTQDBrefn6SoEPoyQB8al4KKhknNwJn+Uqrz2KsTcsZ4yan/oDzcbIDYmTXnvSLhg6hzu+VR0vniw3sCPp7HTPuA+mRlPhQDRhiJeaZY6gi+3S934HwdGhuPgp8bbenzj6FTG03TTtnssxMqhhRrVc+Xd1ldVqdgCYsto+NcwxNKz9rRn4wXj2u6ppQoJMRv6S8NQclgLrt+rs+CwtzC4WbKT0Y3Bkq+uuuFPICDBApK8cGkM/SeZNnhfVLr3Gcnpw20FuhsKQck/1zBMahTSqjKKmWKArRPgATrpfUZd0zlThwOWtFlFqrAs701GfRUhU8WCAIBJBb7HiY/7REK7HKinSu5vZ6A628DefD+dWKeA2eaFHSjOC7gHVnFBxLN6oFm5Xx9XVr5N+bQpy1P7y4ZbPp30Gflp0PBwEMc/z5hkc7YoqYm61UDmVAEUmVFkyZgNLwii7uj1o/yYF2m8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/08/25 at 08:26pm, Andrew Morton wrote:
> On Wed,  1 Oct 2025 12:34:36 +0800 Baoquan He <bhe@redhat.com> wrote:
> 
> > There's no user of swap_active_head, remove it now.
> > 
> > ...
> >
> > @@ -2553,8 +2545,6 @@ static void _enable_swap_info(struct swap_info_struct *si)
> >  
> >  	assert_spin_locked(&swap_lock);
> >  
> > -	plist_add(&si->list, &swap_active_head);
> > -
> 
> There's a large comment in _enable_swap_info() which needs to be
> removed or updated?

This patchset depends on below patchset:
[PATCH v3 0/2] mm/swapfile.c: select the swap device with default priority round robin

That large comment in _enable_swap_info() has been removed in
"[PATCH v3 0/2] mm/swapfile.c: select the swap device with default
priority round robin"
> 
> >  	/* Add back to available list */
> >  	add_to_avail_list(si, true);
> >  }
> 
> I fixed the rejects and my swapfile.c still has a couple of references
> to swap_active_head.  Can we please have a redo&resend against mm-new?

not sure if it's caused by the dependency on "[PATCH v3 0/2] mm/swapfile.c:
select the swap device with default priority round robin". I will rebase
it on mm-new to see.

By the way, Chris worried the plist swap_active_head could be reused by
the ongoing swap-tier work and suggested to hold off this patchset till
swap-tier work is clear. Now seems it won't impact swap-tier, I will
send a v2 against mm-new.

Thanks a lot.


