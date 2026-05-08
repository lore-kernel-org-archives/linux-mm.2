Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA682CD343F
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 02:52:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E532D6B00D4; Thu,  7 May 2026 22:52:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E039D6B00D6; Thu,  7 May 2026 22:52:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF37B6B00D8; Thu,  7 May 2026 22:52:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B93CF6B00D4
	for <linux-mm@kvack.org>; Thu,  7 May 2026 22:52:45 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6A3A61603E2
	for <linux-mm@kvack.org>; Fri,  8 May 2026 02:52:45 +0000 (UTC)
X-FDA: 84742729890.11.94D5C54
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7687916000B
	for <linux-mm@kvack.org>; Fri,  8 May 2026 02:52:43 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jMAUim3+;
	spf=pass (imf08.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778208763;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GXo8YRKGAQ0gGQsS3CnfFEP5ggHykysOGobJBcjxhWg=;
	b=ME7FCGkOo0QoWf6mqMn+DiDODGsGxutPyL8kW8wG9cQoAVfXTo/fGR2/recx4mZVugKZ/W
	pEtl4YMTMCbdP2JJcj1oZgYTwhlcrXsj/zGBcvEAFpUQFoDkjrCZuxkDsnjnBG+Qw6hLhR
	hzh/f3VCDtpvZrvjd6noCZOb0cmUdZs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778208763; a=rsa-sha256;
	cv=none;
	b=K1vGBc1Kd4W00sJdb7EA20z8ylnKJbIRTxgZnnIV3tPZE/VhLk0mpG5o+STU9HdcYDw1Bf
	xQcdGBpt6FMAEWhmG1IGALrL8NwZFbcB9b49ksEfQ13iG1To4F8xWQlVOJ41pZ1XIuAOnr
	hYLRn3g+V2aAQz2bvOq87iHQGGgKeJM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jMAUim3+;
	spf=pass (imf08.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6746d0b2b4aso2345413a12.3
        for <linux-mm@kvack.org>; Thu, 07 May 2026 19:52:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778208762; x=1778813562; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GXo8YRKGAQ0gGQsS3CnfFEP5ggHykysOGobJBcjxhWg=;
        b=jMAUim3+0BlJV9c13YaD01tUfnb+SPcKX8hh1WRbhXby27poeaHcaZmi8lo7nOQHCZ
         rmdLQG/7MFmzbL516HvjFrq7BCOrlWJqHNhXlUgOhuyEzWSROimh08Msq+GzHNJUVkrr
         nQdhHkx00EvwS4sFVoOyPwmlHrqEMfmO21GHdTulqjnOSnQdXJTFwzMY53qQKLjvI8gd
         FuXVFVHUyHvdP/KP3X+HHTb1hUCjVAZYv+Ku8CMJAuWZcF6Qlr7XmxtgI6vQdEyUF5/E
         n9tehbSp88g1vXUJuvlU/Jwd1mU5vj8QrOQ4/4qRMrcPKHVJZ0x0wwabWhNObuSqLlsk
         8CAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778208762; x=1778813562;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GXo8YRKGAQ0gGQsS3CnfFEP5ggHykysOGobJBcjxhWg=;
        b=MxwSH24Zz4a7JrJ5NXXd2Whg6hCO6PfXJ5oWe7iq1BmiZftU2gsTmaXA+wfS6d+RTm
         ksFhjIZkZo+UhTD6Fanr24M7OrAuhVOMvJUW+/BIcC8DkJW32sFRuIN/16hXdhiEZtpv
         1TIKzc6byIIE/4PtfDZpvbUZQsaYElSgMvGh1u8QT7e+E9LKZxcEd6spTr6+xUj1jFGs
         +aqn5HWdiJ4yH2USJFhrkkWuhdsk6uh/2FZNqtzKR5HiKMTfEMP2fcskd1ulWO9RFmyz
         QykyPDvwM1I4s8TC7Vbu9rvcwDikA2zxn6x2cAemCdxWCtrPJKrmqSN0ANNpDAFToXKJ
         yuwA==
X-Forwarded-Encrypted: i=1; AFNElJ+yso2rm0nxEI6xqxinhmkFZxJKqburSfAtT9ObZjpro68ey8MUdmCwFBYkXef4v6VyO4d1yAtVhg==@kvack.org
X-Gm-Message-State: AOJu0Yzk9kr4ByT8S+w+4tEWbEGG7yEOoty5yW7NqV7IgkV5g+KyAjqx
	ZuAN/MbPxqJ6vPuX1PE5EyTG6YUrH8o2V0fb9mjPmdHvN/LGEsyHwKHx
X-Gm-Gg: Acq92OFVd0yXFA6gFzE3ktbDLD/3rjFR4/pIArrpdr/eTfurpxhWKdNLGs/AVzBMwp3
	zCQr4snjwcoQTMYvdhi5OqDxB2b40i9yiR+FjnvXTpbzuvv0b22YWqiaLeSWrP2WUEb2WnybgAm
	CYjaYOr3Vsv7bzR/8jvzZyJD+ZluiChD8Oe1iKyYadXW8GCv7OOp2LZuufIg0cEsHv9ZOV6F4kt
	U2BBVkb3uRdEiHoJzWWokZnXj8Yuz3WXeVgr9I1tnVQQRj4AGQZbNrONcmB9xTt9h1wt+SZ64sd
	7dDNl2vPN6WF2RY/jzYH0qbXkfct9XzEZPMqnAriRzmUQMqdi5tM05aGJwS3xR3DXJ4fDXcpp3E
	d1vC5YEAxoTPF8/2KnVZZGZuP6EVnhn2dAV6nAlhL1giEKh0a5MByfwpi8EwE4IgRxHj2PGEtgz
	0om4S3m78l5mpZCNV/WeNCDM5KhqS6ncuo
X-Received: by 2002:a50:fa8d:0:b0:676:988e:8eb6 with SMTP id 4fb4d7f45d1cf-67d648a9ed2mr3977298a12.26.1778208761525;
        Thu, 07 May 2026 19:52:41 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-67ef0e1a221sm102651a12.24.2026.05.07.19.52.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 07 May 2026 19:52:40 -0700 (PDT)
Date: Fri, 8 May 2026 02:52:39 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v5 05/14] mm: remove READ_ONLY_THP_FOR_FS Kconfig option
Message-ID: <20260508025239.ooz5kc5a3n372ebb@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260429152924.727124-1-ziy@nvidia.com>
 <20260429153538.727855-1-ziy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260429153538.727855-1-ziy@nvidia.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7687916000B
X-Rspam-User: 
X-Stat-Signature: ju419gq81317ufyb49cmk96ia7m5oyp7
X-HE-Tag: 1778208763-923391
X-HE-Meta: U2FsdGVkX1/3cC0Lu5FjjycygLM1GzfvBq2IyPDF8huWaScY5y5WN7i0C26Mt1caXZuqk1tW2WyyPBwNfL0N4osKZB6Md5j8g5eSIcyak3hMCyV/QG7HeY98j9V3oo1i7HH0IUaK5P4AoFJYUp0G4g9lRUbj/soyp1qtz1RqmoR+Y5kdJAAOooWSJDgNJ/w1989BByWU6MV7+z+ckf8JXHGwSR3NrUAqqWV2hP/JvApIoZbtMNUckSBfn19vMfPlhBDPO9gsL4DFWPwlfd71s7twfEV11r11Xj7ZuGFpZs0jVct0Z3qn5v2JPubH7U87hFRznE8Q51Dl7QAnNqjgEXH2DN1/PHQpsD7lzodDLvu2xmxsEsPu3ERsaXdgXpr9tsFzz8D+JAGZBebS25H7gzXUkLI5LjMdmaEvekknlN1+cdXfgUUQU7RDbi2ByGb656d7M6b6lH1QCXtVJ4DIWpnyvSZW4dSG6/7+rb/Kw8eSfPjQiCmAV52rADWnVHKvpqvTGvOKG6PH4UtAhxgKn5p2DoR5aW99qij61lC2/CzmaL0QfH4WJ4iAJ0bIaAN1j1RK1ClJM1ZT9RtBhNF6Qnhp3lVcAtwooPpFn0ZBPhqfx/smNo0ReEufT1wSEYo8GWla5zpG2yPUTX2PP6Z4dMiQflna8em++GrqF7n1rlC+IMXTDuvxkzHZRzPP20OhhYwl9e3pT2RdV9SzooOhWClLcrcF3FKkUDwHeVl7oybDNtmpkUW1+6mGLZvj+HHwiNz81wQcuhREdB66tobujAJvZ2o7R2O/lZyLBbxKYOch6NrwQSBVpvHiK4whLENBvYltQiWud95cU3CEnFtbJhYMX/Xa9KJLbtn0VA+7U6W9XI9Oiy/5MODRhlzHNt638HgP0JRmMQaUh5fbiMnZj6D7bYfKYHOCg8EEWZOKilzu30mvvEMJb5hrvVtqsZm6dBSaSqhr05Jc+cUkiEt
 XaJbsXlK
 5+PP4qr4h5PLY1fd26OVlFNQJtLkwh+gI3IG1VVR6xdHRDoHegVv/aaHjZ2Mbq45k4tj20SNwt7Iiz+4F5DADSzft1Awrmz1llPYZ9VTyLanFHgxtQYU8EuYzLKi183lmYtSY0LmH+kyzscA+RBauo5acpSpwa+8gTZBZX4okcDaxKJzp4VK4aH7RiWpe8wql/efZP4aVBWf273Oo+9SXYblX/pDqhD8Df3Pwn66TefdPUjqIpLc3qPCMo3/bT5An2QyuKpOVejI9uVcrZngYDfT1gSHgyb9x3S38JMIO20SThIm7/3V0LKMVyujkyp+SDrFiQUCp395ctMhFw6Xy7ffaLS+Bi6gs3l8t/5cs23wetFbbtb+AhvREiQpnKNwRfR5fJl4lZUi13Nv8+yx2rKAsB9exdyp73zGv36N6GbOvA6evHSvt28zuc+zOBnDHPVYvS1PIYqBCCRVYZZW/qdY0rU1fiugEj3Wp4h6mgrYWN5Lr1Sy8GZ+fWd1rD9TFv1tubQ4h8XdYIBBrBMhGmXcKMHa03+xTWVgGjnLXwflXniHWfiFc4JlOAlHk/t7WABiguwBoI1t8CrkIXw1eN+6mMqNYbKjdxu5/8w1hlBm5MJPTyIyePNDgBAjYvzfyOt+lJCxpQp3z43BQc72EIqXgS1a4P86vg/mm8YoCSk7mecS61LXy1WHeiqbNI7sW6o87ZphD0A9LB0CB/JjqR8uoCpa8j6GOl4Qbv46z4G5v3+53RES7ER2LzswmpGbhDSmJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 29, 2026 at 11:35:28AM -0400, Zi Yan wrote:
>After removing READ_ONLY_THP_FOR_FS check in file_thp_enabled(),
>khugepaged and MADV_COLLAPSE can run on FSes with PMD THP pagecache
>support even without READ_ONLY_THP_FOR_FS enabled. Remove the Kconfig first
>so that no one can use READ_ONLY_THP_FOR_FS as upcoming commits remove
>mapping->nr_thps, which its safe guard mechanism relies on.
>
>Signed-off-by: Zi Yan <ziy@nvidia.com>
>Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
>Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>---
> mm/Kconfig | 11 -----------
> 1 file changed, 11 deletions(-)
>
>diff --git a/mm/Kconfig b/mm/Kconfig
>index e221fa1dc54d0..27dc5b0139ba6 100644
>--- a/mm/Kconfig
>+++ b/mm/Kconfig
>@@ -936,17 +936,6 @@ config THP_SWAP
> 
> 	  For selection by architectures with reasonable THP sizes.
> 
>-config READ_ONLY_THP_FOR_FS
>-	bool "Read-only THP for filesystems (EXPERIMENTAL)"
>-	depends on TRANSPARENT_HUGEPAGE
>-
>-	help
>-	  Allow khugepaged to put read-only file-backed pages in THP.
>-
>-	  This is marked experimental because it is a new feature. Write
>-	  support of file THPs will be developed in the next few release
>-	  cycles.
>-

Hi,

I see hugepage_enabled() in khugepaged.c still use READ_ONLY_THP_FOR_FS.

> config NO_PAGE_MAPCOUNT
> 	bool "No per-page mapcount (EXPERIMENTAL)"
> 	help
>-- 
>2.53.0
>

-- 
Wei Yang
Help you, Help me

