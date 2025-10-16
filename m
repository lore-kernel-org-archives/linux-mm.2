Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8106CCD183
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 17:55:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28CB38E0012; Thu, 16 Oct 2025 13:55:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23D828E0002; Thu, 16 Oct 2025 13:55:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17A688E0012; Thu, 16 Oct 2025 13:55:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 07F3D8E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 13:55:06 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9F36458E20
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 17:55:05 +0000 (UTC)
X-FDA: 84004728570.08.301F3B0
Received: from mail-yx1-f50.google.com (mail-yx1-f50.google.com [74.125.224.50])
	by imf22.hostedemail.com (Postfix) with ESMTP id E750AC000F
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 17:55:03 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eM3U7mkj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of abe.wieland@gmail.com designates 74.125.224.50 as permitted sender) smtp.mailfrom=abe.wieland@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760637304; a=rsa-sha256;
	cv=none;
	b=Ujljejqh+HneCYtfc5TUX35rdEiAKHF2DxpIRuA+52x4HalKSOeV1Elma1fv3lbUkkx+g8
	WGXTK2WIWFQsmj9Z8XyUHm1hFdRI0nYOSMMJgYNbQCw0yWgVl4VdbNhzvayUCyPn/aZv97
	zV9+G/hTrY6cD65eBAbPSFynwakTuZQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eM3U7mkj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of abe.wieland@gmail.com designates 74.125.224.50 as permitted sender) smtp.mailfrom=abe.wieland@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760637303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=h5aLjrxgWTpMEhoeUPHka+pmn3lvf4M7nflbv+VTOAE=;
	b=6MX7+apuO+raAYSUWqig5y44A+0BRr74/0PLCzMskp03urze/3BBprd4UGuoX6IQqskhMv
	kS/64z2JwBQwraITDwy2IgCwaQZ7ZdicEWH/anvptpExgJxBYLllMSi/R563lDEEwy1dLT
	r2FSQNDcvnwxSiJlquXh+2rq+qemBho=
Received: by mail-yx1-f50.google.com with SMTP id 956f58d0204a3-63d97bcb898so1404691d50.0
        for <linux-mm@kvack.org>; Thu, 16 Oct 2025 10:55:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760637303; x=1761242103; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=h5aLjrxgWTpMEhoeUPHka+pmn3lvf4M7nflbv+VTOAE=;
        b=eM3U7mkj9NBZGDEwDrrMgjPebPgJPMSexGklT/FFXujl7NTFApJHqpftj82W8jufUk
         6lk2ZVleWwlYNMEpQcx/qEPAJK+CekoTH9jO16Lpl0W9zSQY/37fr6BuzCJ0UPRAWPjG
         rD9+WqASktLv1RxVUGZy9JWzKvaQZ9+LlzvbwSOm1236diQp+OBdmFPvJyW5HK1BQj25
         LYGz9uU+nnADG+1vDDomuYvnNSzynCvEpBEe0k9Iy3TxvLMYCPKnW9CCOa5ZLgHo3nfj
         ijDvM4L06Tr2xIP0UawL6QEpvpBFpB2vUAntWaZ8T7IkRFORm0pK8gmjwx5BR1YELKL/
         ZGeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760637303; x=1761242103;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=h5aLjrxgWTpMEhoeUPHka+pmn3lvf4M7nflbv+VTOAE=;
        b=bVQ/NHBfNjrz9BaxuP2IGcEQbj4HjH3AaCe6/9S8DZT7qi+/L+vC+TRuX2BcXHT6Ie
         5qrEiypB/Uy4dyr6V7oZMhuVD38O7nE6DxtOEmFdVqqEG4JaRc6k1nK0c6bU0J1vaagF
         W+b4hufM6bs/haYM0yR97y8cY6a8zVluJLwQUbfEqb+tOE5l3KuWr/RPCRIH6ZXOQT9+
         z7ow8LjpGzzsdXRrFeTPUds16ZvteJizyjGn50sq+kHXxlEv0fbBYWYwJez1sHlfY2jY
         9kxAxTMdx1fDQnPvwDg/1+bBJxOnTX2r8l35Cz+agMB5zhJvG5KZ2tAfB2UNfFqhd1HJ
         GE1w==
X-Gm-Message-State: AOJu0Yw69Dr3zzxyK87Pr/oAQFoFFPHBn1qmXYCMjc+GUHucPRiDuVIb
	u2AcbvH0rRPxHbtrS+nHssVyXimQzLsgCjIUagSD2ApLqqC0UD+btgFtNBRQpkPDC9oXmtVCp+0
	mbqVVQ07RUiaIbcOJcAXzfmD8Ef6MV9TW8g==
X-Gm-Gg: ASbGnctnoKsodxMS/Wad1ck0sHePrKeC3byKhJO7CmkYJrwxO28FIvXROh98YY4SpAo
	y3IFyiKTD2QFS21H87dcN3raQoLgs9i6OWfMdPU9MDleCS+O1WlwlxNejJTXhhT6XRLb3jJvp4q
	p1GKaiQbLvDC08Ir26RzQLOGNKkel0PCHOw7PF/5IuX+xqzZ4m0BYObuLg1F85FWq3Wdc68jVVb
	shgSNfT72ZdToJR1QanU6Um6lJb35Zn6gONlJXkGSUSry8t+r+sGm+hTRC4Cn6WiBHC3rCDJ7nS
	gyhVh8BQWbk=
X-Google-Smtp-Source: AGHT+IF+2NZFf4J32TSY/XIprqs2WiN4ox1SeeZs8P6BnGTHWtFja5A1abi21C1tD6ZnSCJOt0bGx//U0iNOdSEPG0k=
X-Received: by 2002:a05:690e:108e:b0:636:2079:1879 with SMTP id
 956f58d0204a3-63e08e4c1e9mr3085523d50.10.1760637302712; Thu, 16 Oct 2025
 10:55:02 -0700 (PDT)
MIME-Version: 1.0
From: Abraham Wieland <abe.wieland@gmail.com>
Date: Thu, 16 Oct 2025 10:54:51 -0700
X-Gm-Features: AS18NWDnu2YJSlj5YnAHcBeOc5CcAga0e5rokOSu1P8eBY1vx_y_tSUt3mtIYrA
Message-ID: <CAJcU4VTXw-vfRoq1VVfy7qW+zGUZxTaaXCQrRfeNuVUx30XtMw@mail.gmail.com>
Subject: mm, shm: Question about hugetlb_shm_group sysctl
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 9dn6ynh83o4kg7s5865grqjnmrsbysgx
X-Rspamd-Queue-Id: E750AC000F
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760637303-292706
X-HE-Meta: U2FsdGVkX1+ssM01n9YZzrWxbsVCpVjeLJiLxhPvX7MXWI61wqMyJI3KpEUO6XC5CQWT7CZTHw+F+1S3SeNMAyJjKaubaKNiDiAU9TYETZK85pA40KaKCK+sHTuMDLCIb2tCQ5oWtU0VvoXRqw1wQCe3G534PtEs4S4WWKJ3jTmOmLXvtC54i+T11TyGNBBYSGLct9o3Wt5cci4QUf7hh9znfB3zAwPhosHA+1j4/Xr9NS5YOPsvpeiEXABLfoQw0PkUQi98GoETEBnNfk634B1SKlG/QLf3g8YFY6Bvkz7a7eGsbQlOzQ10ngjygOYuS0zBmJPHo0oTCxZtvi1TFd7sw4nr9EtYS2tKP9RsSiVrGaBnYoQPf/U82ygntcRl1SEXMSpYl9H70Y+CxhpTJX8GIO8TpJ2tvpPm3Ncpm8YdL3jAwwZKz2D2ynjE3lwtRX3Nwr1F7dAAi0cQwW5EV1MeArUSBfr3q1B5U9Kp2gah4n94JxOsICNc0pqGshv/tf6OYQwp3ydik9pADzbrCyWzqBkfYxGBt2Tkwuw2cnrDlGdMISknSJd0aEqgWjiZlAXgLcRxkigDoUMUH+mqBzWX4uBinDyr4rLUOgyCjx5tTz6BnnF8rrssuDwxdGQxA9gjJEmKG/VbPEfOE3u8F7e/AWUoU8kIeu6ARWmxtnqyzxi7Hkbr7htVpOCwHD7Hw4etkje7yaA0fGxsEI0DoQVtTJFc/COeKRMZwlqKSSWRAD6P2cPVQq7WT1GGwov5Ftx767WAGJzV1rAUSv4wvVP1NMha1Mp6dyd8sDUKF7Lcf7t/qoSgef7tuKjEk51qC0VE+67EAwfnxNYvtj2/BsTcdmbXn9dpJChgZy6QTx6SyD4TOS+bU+H07IHvi1pXT5Pi9IES8hduMGpUdWK8NI1EDj7nKuwnOS/S522S8UDq72XSXfN1rG26n83OISDMVmm9XBCx0CuAP9pPjON
 nEIz7e63
 TQFjey+YnOPRwRoL1C9aVbYYQ/CUL4NAsbpckGTJquj5efyOOKw0EyoMf2HF75bv2yCqa/MIhbMdfiOQ58Avnf7Vvq3xc2tRPW4kZwLbRQlSRBbcumsKHM871Fdd7HtScb1l6l9jNentf/G1XsoL34FiBzb7cS5TdmbuXzDZqS9izQn6LwhoR9KiPOjrpXcX7OAfLB50TJbl6RTbJxOkT2sGK54MR76sw4OHIF/sqi01Tq+aGiLKlblItYAFZ+agy+szz5cSpZ2HcSJvws2YT/+vKQJAMKkG0pDG69H7tTZzMuUz1u/5le6vyjmeqs6puMAhYmdgmqJQFSl6yChmMpyY3jPWbHORxLUQwYc3kvyonU7wsEqf/mO7N0vqmZoqzyIhz6WgN+mjjV2kXW1FUbMD970f28ubUbwimscUaiHxT88U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I apologize if this is not the right place to ask this; please point
me in the right direction if so.

I understand the intention of /proc/sys/vm/hugetlb_shm_group is to
only allow users of that group to create shared memory segments backed
by hugepages. However, I found that users not in that group can still
share a region (albeit not a SysV segment) backed by hugepages,
through at least two means:
1. They can make an fd with memfd_create and the MFD_HUGETLB flag,
then pass the fd (via SCM_RIGHTS or pidfd_getfd). According to the
manpage for memfd_create, MFD_HUGETLB is supposed to also honor
hugetlb_shm_group, but it doesn't; it calls hugetlb_file_setup with
HUGETLB_ANONHUGE_INODE (just like mmap does), so sidesteps that check
(which only occurs for HUGETLB_SHMFS_INODE).
2. They can mmap a region with MAP_SHARED | MAP_ANONYMOUS |
MAP_HUGETLB, then fork. Naturally this is more restrictive than
memfd_create or shmget, but it still allows for shared mappings backed
by hugepages (depending on your definition of shared).
3. Of course they could open a file in a hugetlbfs mount or a tmpfs
mount with the huge option, though these also require administrative
support.

Neither of the first two options have the persistence of a SysV
segment, but otherwise they still allow shared hugepages without a
separate mount. With this in mind, I wonder why we have the additional
restriction on SysV segments backed by hugepages; it seems like a very
specific case (as it doesn't affect the above options, nor segments
backed by normal pages).

Thanks in advance for any insights!
Abe Wieland

