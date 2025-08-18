Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16EDBCA0EC0
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 12:28:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADA5F8E003D; Mon, 18 Aug 2025 08:28:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8B2E8E0003; Mon, 18 Aug 2025 08:28:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 979B18E003D; Mon, 18 Aug 2025 08:28:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7E8E58E0003
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 08:28:32 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5462B1608A4
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 12:28:32 +0000 (UTC)
X-FDA: 83789806464.22.3F4D65B
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2F483C0006
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 12:28:30 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=szeredi.hu header.s=google header.b=nTdLy5tx;
	spf=pass (imf22.hostedemail.com: domain of miklos@szeredi.hu designates 209.85.160.178 as permitted sender) smtp.mailfrom=miklos@szeredi.hu;
	dmarc=pass (policy=quarantine) header.from=szeredi.hu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755520110; a=rsa-sha256;
	cv=none;
	b=7Ra9JllYGqPITwYVMRxkmb6e2dqZvF7wayqgft0/CUtNv/N/xDl6vvLHezKe25zCEeJ9OB
	zaxcTlCkkmyr4lZqU3qQazQGdk4b2LVvBn6IdJKCOgKf+Gv3IfW+qETpJd9mYWDCxTT42f
	E4rNXffQCU65ph2gGCmxWyrHOkXT10Q=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=szeredi.hu header.s=google header.b=nTdLy5tx;
	spf=pass (imf22.hostedemail.com: domain of miklos@szeredi.hu designates 209.85.160.178 as permitted sender) smtp.mailfrom=miklos@szeredi.hu;
	dmarc=pass (policy=quarantine) header.from=szeredi.hu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755520110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/tfsHKMqr8nTfKg4Ex6rYrCn/i03jqipVdnJ6D3y+jM=;
	b=e1Shn98C0ueI8paZXAwIc4R4Cii1u4AFac4njloRLVSTklR/oPrSr//9UZViFkNdEvzYal
	en7QoguDgryunRpZc6zxGfyUww/8Kq8B3L85Cp9BGYo+lLnWfvB93vG/yU1QdlGLtyFa8r
	fX9e79a+wHg3hJiQ+g1f7T5Hw4EmmFE=
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4b109bcceb9so48729181cf.2
        for <linux-mm@kvack.org>; Mon, 18 Aug 2025 05:28:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1755520109; x=1756124909; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/tfsHKMqr8nTfKg4Ex6rYrCn/i03jqipVdnJ6D3y+jM=;
        b=nTdLy5tx5X7bp5wPf/IQ0vXJSTqzJ6A8562Lu+Ku+BX3X+J+pcy7uVudOr8S/ByOQa
         vuQfHPdLFxeT06zdJiFLH6j9mXmSda6Y7qhlHoTiuEKyj3yCvFc8poMf7gtr/jD6WV8t
         N4QjEmkZYUPA+BTOH8M9SCodU3xSYYDrhaE9U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755520109; x=1756124909;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/tfsHKMqr8nTfKg4Ex6rYrCn/i03jqipVdnJ6D3y+jM=;
        b=oiFvYvJjhX+Z9FrKy+fStJW9f/TCHpRsSyXLYm+Zo7XjTu3/2wwJ+spEPp1fxGpLEP
         m3nCerrmJH6+JKMxJDpbx98xwYbl7+CvCiKVhsZbR5BOdN1HH4KSFmy1JFVQqtzbQzFc
         jjABGd5YuEhucsT0y7UGaepvlMgYElc8QnR8a6/AA3bMuuykKg8f+BUGDZGUyQ1NmsPl
         MCNqC6qwiV7l5iulywbgMWTz6SBczqiNFyQOflED+7gdyKjnJJRYWnEKGqE662J7qrny
         W15Ku0PXQZ/b2o5ZUuLpbzUVxga6uNfoIWLgpo+FljTNesdCaUsID/Vm0p55Al0X1qmg
         0tzw==
X-Forwarded-Encrypted: i=1; AJvYcCVgR51XrpWMNwQUl3N6+8kOeGy6aFxRav9ZKM4MFY2N91UvsVtkdsk7HQaZtX0W3Tk/p1V3oKw9tw==@kvack.org
X-Gm-Message-State: AOJu0YwlmoNWXZ3SbdkgOH4WEdd+2E2cINmqtt14AQ7P9fqQbO18Xsst
	+KlYagYtS/gdNLM6gNE7sHi/ApHoL9dLjN+nG9e7rhgAneuvOIPkQt45WtCyE5w+z3MCl4Jj60Z
	Bb2oTd+xNqv/G6DtlEUDpHhBdiReRxBsWBJNoq/zQuw==
X-Gm-Gg: ASbGnct9ICzThPlQZg4FoKCJcHrL/8kArH2MLxwoTbYzgIhcBB1co+a3kGFBWmWXwkQ
	nRYqFBdTc+ul1hVjs6HIIId69rjeY4DtkmetPnE6qf7N2gxNNkvNVEh41be71xmaShDC1O9HIpT
	l/kW0b3zf8pMN9Rb6HulmS4xOU3X1cxG/BcBznaKRAm8myHntW+vdnKXYKiPiVVXkvtlzj3IxNt
	FlyR8E9Nw==
X-Google-Smtp-Source: AGHT+IETaYzj9o6mi8HTSIHcmGZ4YAGl4BNS9GKIhc6/SFw9vhRuJ8/nuysjKePoxZ+D12kQMPCu9H/2WXb1Kiwz20w=
X-Received: by 2002:ac8:7f91:0:b0:4ab:b1d5:3b77 with SMTP id
 d75a77b69052e-4b11e2b399amr170728641cf.45.1755520108954; Mon, 18 Aug 2025
 05:28:28 -0700 (PDT)
MIME-Version: 1.0
References: <20250707234606.2300149-1-joannelkoong@gmail.com>
In-Reply-To: <20250707234606.2300149-1-joannelkoong@gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 18 Aug 2025 14:28:18 +0200
X-Gm-Features: Ac12FXymHDCzlIMnSJnWCmYUd9R25CB8Q82pVKBYoFceyuXw-_2IvffVHMZ-N18
Message-ID: <CAJfpegtgiwNMpjw9vv+Bveht4f==E+HNBpoTVVM0BXQ5PjDx5g@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] fuse/mm: remove BDI_CAP_WRITEBACK_ACCT
To: Joanne Koong <joannelkoong@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, david@redhat.com, willy@infradead.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2F483C0006
X-Stat-Signature: khnn7cfuftxzqzpmeud58e8nopdb6x79
X-Rspam-User: 
X-HE-Tag: 1755520110-682020
X-HE-Meta: U2FsdGVkX1+sF/NWgcQdfq8MhZDy1ZdPdqd3PoVFUSk+ddpo+liig4JjwLOkgsiM5a4KBjta0B4XUSIfnQGpBxVAFktQBtU/YTLTgu3d6cHu1yFPCDxxXUDfrbcYUoVY+ciqn+lL5rJ/UFG6H9rZ6K8Xr/O/Zrg8UAFJfOE0jN+VQmm2kFLiF1rDxVIB7NprMUUj48kZFfNEC2Y28aMmspcRUGwE91psr6PepkZE+rS0l9ex8hD235r/iD0UlCsqdF5STD4akcSDipbrJTu1i1rTLnXamEsTRyZDBBH381qKfwo1ZvwE0ulQR5aQmpWcSrkNfQkAPXQzVqIzGEjEt5ayYgmwxaR4z9Mb3R909Tu1gu6jScx6mP8LdNpK1iJDkaKrt0M4RoEDgENdKYxiSnA17Vyo4JxFvkEjF8ewkIv3s1aqxgYM4g4TJT+3m1pVSEcdHVWUMro2UYN0oc5ZrihsIj7AiRqcwICD9+sSVy8tSV1NrlaWDR8vreWUlZwro5nQJpel7HFQcO9mDkPhq03qotHH1bfotuCkIImx3sZnN6vb+bvpLRWf7HEAC18CCoQqalH+Q5PxgCSWeDiMkzvvgV1FcMXh0tg23bZKce6ftvxmnAIxDq81R0kBnhr4v/VZ04eDdSILrkehdCWj81rcv5tct1Ogam103vO+PAftI5yJKwvss+5DNosALg67v0038R1nIUCo8jw1ZYHC8yADbiD+mDbLzazi5JJFj5Jc38caaC+8E+mf8OKLw+4dVDHXWBSe1cemnqCGiGdb+qSYxuM6iUevtzeC0HuSv+h4v4u7byMSvuHWFNcqBjnJKXmCPhfKGfp1IiPqaRMBDwKBbnGw0Tbyt9+jOCJFHkpxv3JikQ3LAbywijsUxnCw72l2JPGposkTQ4bwJALEzlHVwZ1CySXq1+FfngoFNCN1+H7YuUTRzud13sWspFsh+I0/mtw7Xry/BjlUNAj
 GWAlhgca
 MSOKOw+z4honGb6qBM4CvG78PKO9t5D82FO14KqYx7HkmcgRVA5ezkwOYirz7k2qNQLFFsHacW077kgd/DQjC0Sb761Nfe7vDax8Q10ZFqsGcQ99t1r7oRfc+BQKCGXgrn/PZBcjEgesZB9xEPd/QJpvYYNlUGlI+hh4OzJcuJNxy4DUZdibGV4fTjeqjHTABUwbxf1GW4SoTwK6Y9uAlLM7QXUjwBNotuG6t
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 8 Jul 2025 at 01:46, Joanne Koong <joannelkoong@gmail.com> wrote:
>
> With the changes in commit 0c58a97f919c ("fuse: remove tmp folio for
> writebacks and internal rb tree") which removed using temp folios for dirty
> page writeback, fuse can now use the default writeback accounting instead of
> doing its own accounting. This allows us to get rid of BDI_CAP_WRITEBACK_ACCT
> altogether.

Applied, thanks.

Miklos

