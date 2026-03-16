Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13AEBF013FA
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 21:55:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 551D96B03AD; Mon, 16 Mar 2026 17:55:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 500056B03AE; Mon, 16 Mar 2026 17:55:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D7906B03AF; Mon, 16 Mar 2026 17:55:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2DFCF6B03AD
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 17:55:35 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0130B59C91
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 21:55:34 +0000 (UTC)
X-FDA: 84553283430.26.A481494
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2D25E140008
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 21:55:32 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Mkth0e1h;
	spf=pass (imf23.hostedemail.com: domain of vipinsh@google.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=vipinsh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773698133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OzZGe5xJiZCdI8yLv+9J6duKMFuSxCgV09Lwr9FRsuY=;
	b=KmU0ER1ztWRqjOko0+EKdhHP88TdLoBxmwu5LGEsYd7avjL6qZK5S99GCW3FacgGvlwaVn
	SVg7vmU8N/ieXQivm0Ms5zBRvcv14FvxOPrXxuZElepDIFk92XevGicdJcT2wf4tq38qIP
	d4QHKsIjeMolRLH84hMqcA3dOorcLfI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Mkth0e1h;
	spf=pass (imf23.hostedemail.com: domain of vipinsh@google.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=vipinsh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773698133; a=rsa-sha256;
	cv=none;
	b=2uR7Nz4Pwwt8h8W+6JHDGtWxNS7cdSBJKbn4wVrs0KRWLh//dV3xWW0b8UKT+PNgWqsyD7
	UFsoVfcbcCmT1GlJvppLxDlWVMGgMs8UjQGdkxWDR/Xe6waqMgPWTh6VUASiAbr06XrOJU
	WcaQS/3a5fVahReacshLGbSZMcnU8C4=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2b052ec7176so13785ad.1
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 14:55:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773698132; x=1774302932; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OzZGe5xJiZCdI8yLv+9J6duKMFuSxCgV09Lwr9FRsuY=;
        b=Mkth0e1hC/avynEQzkQNj17sutzPyTyIdhfCWGW08ntdAqiV7/p3rHkX41judi1uE5
         okUBtkG9KkE2y1MyBcrD5bpDo9M61zidfI199pmTqOPZGGKeWSbr9xCeJ2QLYKlHVhfH
         gVmpHbmeoV3uGFQUvtqMllikZrt3SJMkScQkhGkqqKunryBWeUkPWseHPn/bk37gAnfW
         Dl6Tobe42PS52eNi5MQamb/yW0LtgL7JL5qbpG9BRudhaRjxUB3ChIdXTs6zkfs0p+O+
         I8WjcKE77WGAy7tx6ig2ex9by85RE3rKNleroqj5uWVSWeGfoXO5gsE78PY5Lbu1kdwW
         0iew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773698132; x=1774302932;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OzZGe5xJiZCdI8yLv+9J6duKMFuSxCgV09Lwr9FRsuY=;
        b=OmZSnQ+1lOnXLWqUdNsBbEyfZ9C1raXDQgbyFQIX9GX7lQj0v5SqqY4FsZDWLP0GzV
         X9VlasyH5fzu7k7OmYJUY+RadAm6RbfXg5VrV7jNARPUR0d9baeg6eMR4nUE3itkmB06
         0Ty9Xy3fpKgCprip/Pbsl9l7XmVn1n+LlpSNrhA6bKTfndtyirXodqjGdeCkvQQJvq60
         4hMU/Zg1fJ+fsW9N5XreOsSQp999byMuIfPawcqTwEVrw74Pc+7ci9KhfZXTmZ9gUYLe
         GWFrdzlwaRBL0K/RAdzcbt3NjaPXFzdBoRBJ+W5veVLae9ftbM1As/oV6p+q6u5tFdqx
         XHeQ==
X-Forwarded-Encrypted: i=1; AJvYcCXvj/8+lgj2KetQ2nEq93eK9ik19f15erRy8GWpolQrQbzMwG5UHTzjOwb3SYswl7EUMzWOB3JrrQ==@kvack.org
X-Gm-Message-State: AOJu0YzWfOnNsfywR6gd/lyyVhNzkw8PFoCPARFvaCth39BbqAXapLd4
	PR0dMzy7NogIiZcby/Jd7e1CxP/w9o0h6pOfnEj7aKYIJhPMYtOJrB8hTMsjla5Z/g==
X-Gm-Gg: ATEYQzxW3idqqpEEnMp1/YKojD7y6qxlUOjE6x7ORSBUKpf7yH+kgHKwNw8sn+IJ0U0
	R2MjCJHUtDK5R6M+8my1NhZhnp5BKIArsKF2qywL/aBKqN0jUwWQquBpgdFXrG+bOX5JY/3+sxG
	wMUc0lncpG8b5AEx7B4UuGDJTgQowmQy63P9MG7hhG4Ho7Tt/j7eAdZgGAMJuvo5eSXrmfUqeqF
	CagjmW4NzahZFq75Czt55v6F/DzMnk72cr/0CmkmyS6wZyVZuUFMfX7aqykuAf8fPH+02c9gAwB
	DDX/2KFZvgQp5IYuG9bpxN4y0c7Ml0kHVqQcy1bibEZb0+xvik1dx47DZGI/f1taDjb9RR0eiyJ
	zt/6s/SgOACZgp7aNhVa1vGedtiWdlMOxNsldjQX/CFWpvPmZ9sAA7G3Iwuvk8OJ2g5fTUlrQIm
	fneUre6dBGSp0YgG9uxko2SVaU8eOsWjlietIxZzm3sWkAf8SmF/jQdGK23A==
X-Received: by 2002:a17:902:e885:b0:2ae:4e8e:954e with SMTP id d9443c01a7336-2b06599f6camr431285ad.5.1773698131381;
        Mon, 16 Mar 2026 14:55:31 -0700 (PDT)
Received: from google.com (60.89.247.35.bc.googleusercontent.com. [35.247.89.60])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aece7edd14sm155239485ad.50.2026.03.16.14.55.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2026 14:55:30 -0700 (PDT)
Date: Mon, 16 Mar 2026 14:55:26 -0700
From: Vipin Sharma <vipinsh@google.com>
To: David Matlack <dmatlack@google.com>
Cc: Alex Williamson <alex@shazbot.org>, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>, 
	Alistair Popple <apopple@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Ankit Agrawal <ankita@nvidia.com>, Bjorn Helgaas <bhelgaas@google.com>, 
	Chris Li <chrisl@kernel.org>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
	Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org, kvm@vger.kernel.org, 
	Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-pci@vger.kernel.org, Lukas Wunner <lukas@wunner.de>, 
	=?utf-8?Q?Micha=C5=82?= Winiarski <michal.winiarski@intel.com>, Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Raghavendra Rao Ananta <rananta@google.com>, 
	Rodrigo Vivi <rodrigo.vivi@intel.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, Tomita Moeko <tomitamoeko@gmail.com>, 
	Vivek Kasireddy <vivek.kasireddy@intel.com>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, 
	Zhu Yanjun <yanjun.zhu@linux.dev>
Subject: Re: [PATCH v2 11/22] docs: liveupdate: Document VFIO device file
 preservation
Message-ID: <20260316215056.GC1846904.vipinsh@google.com>
References: <20260129212510.967611-1-dmatlack@google.com>
 <20260129212510.967611-12-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260129212510.967611-12-dmatlack@google.com>
X-Rspamd-Queue-Id: 2D25E140008
X-Stat-Signature: okt911rpe1ycjseooqibex6cj3onuk99
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773698132-501437
X-HE-Meta: U2FsdGVkX1+FhJazXpR/szPhOLsD2+N9/uCgNtoFWSYA5PNF61kRtK4jn/BuDKZZHPxnDbcQIYM9eGSPzBRV+sMMeDbOoH17MxNU20EZSnPl9oEETtXAFKdS7TxbeBJ5wWOgWnM3B/s9cVV4ZrpStNpf5GoFMK7LAHdAZH0rdgvwERoCv8FWDOV738gpYws2TFhWRqvZMHI7KtPjZgQ4o+U3frfuP0s0CtNsuq/aYykdXcYiZ6C2mv8p0PS3/pw/xag5n67FW7axUN7A3vEmguSz1avrhDjfleuHkfZrQdLciTcLHbvMqDZ4aQKMi8WZiNtLBHQKS/7HtMy59PdTZIpoFxlX/dXRlaL5fHMxv7UafN5M6d7ArPkiWqywED1jkcMZx7rVuxI0TU5Ec9O+We3eq7he5/o/6fWsw/h+YRYMDkTa+XCyYb9J/D1Sh6NqBkWFPT6IJn1eY5UgnY8TnqyeA8MuHb279ytzPJQz/PD7gE9Khqua4alBnyCFn4hMezH64CRmyuL4X+0bCBNjKl6oAOk0bZQihsijp1z0UQr0XQZzCbScYAURBibh/nKNcS5kQdAhAqpclrWm4ZSWKfkywqTJhKRRi+RggZWa+YhzyGxthwbXawsthfw9j4utp1ObRaTCHKCeblfupxKXPCT5bSqlwF1DIsyQ6MLkNtq+MekHLG6hdhNwHg7usxzfGFJc4TmC4XZckUuxidxWM+we4wee8LeHK4u36Yi8NNUKV2plzR20iwjx/+E+wXiKXISp4w+83crmRg7dh9Eb44fnwDs89BRrvL8vkTy18dRQCSIB9eAGOXZk+JSJu3WLptlNxudSZLPZ23QqXOHr566BOh4g9qOsc+Rf5YP04dlyVLvnZiWldt+NZSyg7y5j95tnUr5lSAYYLTbjt2pyqJFvB4zq86ZehEkyFhlSPcYoATthbUGfu5dQua85+/9FciAIW5VpNj9LJ0z4iuY
 p3S9vBpD
 WPysUceYoZ9d8xNOSY3GHJb9lo4vrE2cZL/V469WmUp3u8hdIScJH/dZnvWtY2910zNklPsH+T3MpGv+EofOwPB61xcVEp9C1BeP/Xuj0nm1KF4NiMFd8RhY/EY7pr54aTn3JfyjFUPRbL+O6TcZeCO87fUsXch8Di57bh44KthyYjPjkMXBRqDpbb80O1nhH2ayKctmAKqJ6YpMJueu2Cbb6bFeUlyzT4iEFlpV3GFedPT0uVLThgwdff5GN/mslwU4jwFQvSvbFZTsvKPvT9scx0fF7Pzo9h2GnhSmUvm04muJBstjXvc0bHFrJu7gZyQgYYtNNEmmvScJ8fBU78vivom8ZVq7RXC0v
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 29, 2026 at 09:24:58PM +0000, David Matlack wrote:
> Add documentation for preserving VFIO device files across a Live Update,
> as well as some generic file preservation documentation. This
> documentation will be extended in the future as new types of files are
> supported and new dependency/ordering requirements are added.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  Documentation/userspace-api/liveupdate.rst | 144 +++++++++++++++++++++
>  1 file changed, 144 insertions(+)
> 
> diff --git a/Documentation/userspace-api/liveupdate.rst b/Documentation/userspace-api/liveupdate.rst
> index 41c0473e4f16..dbf1e4aeddd7 100644
> --- a/Documentation/userspace-api/liveupdate.rst
> +++ b/Documentation/userspace-api/liveupdate.rst
> @@ -14,6 +14,150 @@ ioctl uAPI
>  ===========
>  .. kernel-doc:: include/uapi/linux/liveupdate.h
>  
> +File Preservation
> +=================

Should we use the existing way where documentation is written in code
files and referenced here? Maybe luo_file.c for this?

> +
> +File Retrieval
> +==============

Same as above.

> +
> +
> +VFIO Character Device (cdev) Files
> +==================================
> +

vfio_pci_liveupdate.c

