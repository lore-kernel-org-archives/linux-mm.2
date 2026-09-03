Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D327C624D6
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 15:15:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 440C16B0088; Thu,  3 Sep 2026 11:15:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F18F6B008A; Thu,  3 Sep 2026 11:15:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 308046B008C; Thu,  3 Sep 2026 11:15:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EDB6F6B0088
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 11:15:31 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 572D8A0597
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 15:15:31 +0000 (UTC)
X-FDA: 85172800062.29.9742C08
Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9291720006
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 15:15:29 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=XdYhm8LE;
	spf=pass (imf13.hostedemail.com: domain of hughd@google.com designates 209.85.128.178 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788448529;
	b=CzZd9WdrflLu+iAWOpXEWybnoOVI1pacnFly2Gre2i42q1bdiioi8l5u+/SzDiMNq8+lSn
	37HPibQUTV0JPz2nyH4AH8e4DKozfX6D50/PSNO2v4CZgUhReaBzLTJBq9IRFqotbanr4+
	YW9TKL23qwnMxK1elEC1hFGLLjOTZbs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=XdYhm8LE;
	spf=pass (imf13.hostedemail.com: domain of hughd@google.com designates 209.85.128.178 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788448529;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mf2cMzcJB7ZgyTGSGNOkCh7zEnrruRaHuarVNveDD7w=;
	b=4hsooGjECzkXgJ0Ae3SDkRAHvuT6kRi2tNHF7IvYhXC36n6qRwRBIkLDzcmeOfp8I/Fvd1
	LEi4UPKWObntxnvPv+2Btlh5A3xZ1lvgCggGs6RWm/tja0UzE+eTMW/MTYqbUVnftaJ0pO
	3NVSWiRWX4bgoNLO56+xQ/63qblR8es=
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-86cba60d4f2so17355747b3.1
        for <linux-mm@kvack.org>; Thu, 03 Sep 2026 08:15:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788448529; x=1789053329; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Mf2cMzcJB7ZgyTGSGNOkCh7zEnrruRaHuarVNveDD7w=;
        b=XdYhm8LEy/NfCrAVgYyqIGZ3Oqp/LkIBGZ6GHTdUFXqMV9ScHuGVUmvdmGolrcuSwq
         aOGQl09tZsBJv/7ITx6apRO5R6dtBHNCEf8YnK2sBJv32I8IUhiQ+tyHVal+E2qx553p
         I//Jy7yy/YJrsiHAmHQaUIIeB40ip3BoeXdwJ4au6hpaSQMSqWDVEsxkdvMhRPewoz7d
         NE87NQwrGL5VyNxbKxoo9fWIWV89r0wO8gV+r7HQfLOxvKwmkJSN0te/ApFv43W0Qvf/
         xSjY0VKTvmjkwmoKuhODp9xOpgo7ed/8Ug2JTOb6PGJAEvzBUkYeEhht9SysU7KuysUq
         LXPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788448529; x=1789053329;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Mf2cMzcJB7ZgyTGSGNOkCh7zEnrruRaHuarVNveDD7w=;
        b=hgGE96Alegzsb1ef8Ai5FSO3wv8+9W5reQdArGl45ENjJuHnqm6ThcaJX+Hk8JxkUE
         4tPZOzlJ7jEy+GtdHMZQl8i2yPQ+k3K01DQ5XXahRTQbBE5G1K1KhhkKDv+P9ofTG0dh
         D6H+mSVdyfApQiYC9lCHxEcLStsfajVXkDF26H/Y6LNKEKiCrijTPHPqaQSsH4DNjOFh
         wlBm8c4F3eq4m4DG7e7v2DbsR58CSmBmD/vfbJ7WQrHj8VdBbyQSpy8K6TXFLz2kDr/f
         0Y8CajM/HOZnWJj5i6XIfGPu7J3K9uou2TWWKJ3NGvdmXiULNxxAxLEFeLIvwi2k1VfK
         IVPw==
X-Forwarded-Encrypted: i=1; AKwUvBwIDdL4Qu4afOWCqU/Dwk6TvyM7ZBZ/bvufL6jm+pC16QCHajDW5qmPCuKrlbsJ6dOE/9TVe6tdBg==@kvack.org
X-Gm-Message-State: AFuF++lFzj1WRcDT2+ZhzP7oEGbQF0FU9Jm6clkv4ImQ8v2h9x8MkcBx
	cUH8kIrjONx7i5sUXRr9TBI4DmtdWB4nz5rYw6jIVUdeb7qDiCNKNmYWT9SMe6p+hFij3X1lNrH
	xh0hM1e4l
X-Gm-Gg: AYBFou225y3qiCdRK7xU5tcnvdC0dpFBSojjQ+GwKE+xq1WchgEx1YkUJn94FgH3B7a
	l80Ek+SyIu+7P57vVntgjLrUdUw4GrbaAnsq1oTF4ReenWVPY9G4O+7RyOBXL6CCnGfJbBZKinu
	yy63DUULlaMTm0iJjrlNrLRcsL4eTWQUQnx6Ljwnen4FEDgtgyAIxRJWRBrM/9MKf6cMLAWA1GC
	UvyAsK2dieSpnbnUwzhsiEw6Uov/xB5aDHfaRtkH8ydfNTB8ixtZWp96njS4gH7O7ei/7CooRoy
	ybUDskQHuIFP+2N5Wp6q4yW5qypkUsdQ65MBnRcDYXbZ1fL8DGxdQDjRDFned51mkmjDtYWThs0
	ELZSE7OiRTfsE+j7KpdO7ERlFtSZEitqy6sMdtmYhgsAeBU8Q9LDRx7d2PgisD55VQbOX4sey1+
	Kr/VXOyP3sViOCfFrXiaKMxpXVHiAZ/XcDhdzzVis8kQ4oLeXwDfmbQxQ2gXt8g9SHkxbAaWg2u
	V/MkuPIUpBBF6y+z6kMbfTpaZJ8HSW1L/mwQulBlbnKH2pE
X-Received: by 2002:a05:690c:30a:b0:858:def3:3422 with SMTP id 00721157ae682-86c53989a23mr76445507b3.27.1788448527781;
        Thu, 03 Sep 2026 08:15:27 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-86c10c9461esm43081537b3.7.2026.09.03.08.15.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 08:15:27 -0700 (PDT)
Date: Thu, 3 Sep 2026 08:15:14 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Jan Kara <jack@suse.cz>
cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
    ocfs2-devel@lists.linux.dev, Joseph Qi <joseph.qi@linux.alibaba.com>, 
    Hugh Dickins <hughd@google.com>, 
    Baolin Wang <baolin.wang@linux.alibaba.com>, 
    Farhad Alemi <farhad.alemi@berkeley.edu>
Subject: Re: [PATCH v2 2/2] shmem: Refuse to enable tmpfs format for another
 filesystem
In-Reply-To: <20260903090508.1360863-4-jack@suse.cz>
Message-ID: <3b119174-7b10-6eb6-7aff-462949fcb49a@google.com>
References: <20260903090053.13120-1-jack@suse.cz> <20260903090508.1360863-4-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9291720006
X-Stat-Signature: z3pa5e9wfjj9apc9tm9zez8jawzbofq3
X-HE-Tag: 1788448529-341280
X-HE-Meta: U2FsdGVkX1/l9TwIIgD2KyEwjkL7r/7SdmLQbg70qLUEJdtcj3YkGUs6OcS73hPiXuGJQLZnyQW1nE5NXVCD7FNigApqGjGwqgDL90iBeXLMsqzKwk148eA8q8w72sJKIWV7BV0pOQYq47bOmW4lzETFsZfoG1T1/S8xt9IxGDAJWDUNBiQjskdXlz+6OzkIJpjHZKcGNxSSt56bX2gJBtcZ9grL9z7Nw/dQVqMCJ+zdTvwV/emvPxpnVrvDI4WYWHLmdiBMfRZXKz5Jrvq9Y1PiXtVVtFOM2zjZ63IpbTfs9ojKKu+rcwfrmub005VrxO3kT7pN860ipeiD3LjnnKiNVhM4frVKcxJvne/PYMDBwlGGoNf0HrDXtrkSLXoLzOuHskwT31kGvRys2MeMHX5FJa44CF5lypwHIzVQJE5nFnZMOQAB2A0FX0XRGaPILSkdvl0zr5vBuRVeoQbo6rNJHOI3qsseA6bPygvSxVgokK7kwJKXAcim3RQYMUUDeStVPJy5tfl2yX3rwGDE4b8H1vjU7GjaGg0mT1gMCUltvke+bVZFDyRJ2kddmT1/0u7y1iY22SV+6IkBVvvBBynFb4Po6xPEQyHigAsaJ7AUBO9Ijl7ci4W17/qTvbstf68ryHwE6dE6ufScW3QbIvSOG8iK24DCg0sZyXescTMHicWD2iQw8nM0nUnQmoFAB0cgzZ3IIm/Kspho3dfAoDE92p7iXZIfYOcZovYnofHnNi6UQaU8HLPciHxIBAZ2Q6BDkGr7MTSQ8vnaym1aFLAcTDqFG+fNwRZ7U9n6WSR7AfR8RyOiHK6aMYHK4x0d8Su5KTvjPo70i9uTBhy09X9+iNokNJ4fS3+L4LYyEXLRYJINt9/S6pYhiDHMMMXQekGOm+GXmnjpwpR8MXICIze5SQAc9OXZfU2TS58Ol3wKh/wsm8mx8/XBqGNd0YjGfGY0h7Jdnv8PF4W3fDP
 jrNIy3ar
 XGUoweJv5E+I2NhsHmPea/ThsqD5QGtqSwR0ID+usRmtsRthyRwIAItzNpQ94gqb5JZGISlGTZXLjPP4xFj60KtNQ3DD5PzSJqel64aONjzqYd0cAunB3ZPXh4nxtYsIvOxbbaQQ3S2XNfrI2Nb4LkBG0nv11CX45TGWPHr4LKIXwHPBtftLuqwj4jVfn5LnHs8FbOW1Sd8OmXHol/yiezVtVNHuGXmuOLPHXj+jH80cZmcEaFcOPs0vUXMxwp7OxpybDgVpCl4C6lpIoj0rFu1ox+2Qdn8qt+WJbA9YdO4bwQHhyWkO7uDp98ZGmJZN5pVpYM5H97johTwcfhXwiikO4SmNbo66XTYmFCE6spAqd5C93/ryXjvrL3CaZCGLLDaFY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 3 Sep 2026, Jan Kara wrote:

> It is possible to issue Q_QUOTAON quotactl(2) e.g. for ext4 filesystem
> requesting to enable quota using tmpfs quota format. With suitable
> passed arguments this can actually succeed in enabling tmpfs quota
> format on top of ext4 filesystem which leads to crashes later in
> dquot_acquire().  As tmpfs quota format is intended for tmpfs
> filesystems only, verify we are indeed enabling quotas there.
> 
> Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
> Signed-off-by: Jan Kara <jack@suse.cz>

Acked-by: Hugh Dickins <hughd@google.com>

Thanks: yes, please do route it through your tree.

> ---
>  mm/shmem_quota.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/mm/shmem_quota.c b/mm/shmem_quota.c
> index d0b92d6da50f..a3fa4bd93e75 100644
> --- a/mm/shmem_quota.c
> +++ b/mm/shmem_quota.c
> @@ -30,6 +30,7 @@
>  #include <linux/slab.h>
>  #include <linux/rbtree.h>
>  #include <linux/shmem_fs.h>
> +#include <linux/magic.h>
>  
>  #include <linux/quotaops.h>
>  #include <linux/quota.h>
> @@ -54,6 +55,10 @@ struct quota_id {
>  
>  static int shmem_check_quota_file(struct super_block *sb, int type)
>  {
> +	/* Verify enabling happens on tmpfs superblock */
> +	if (sb->s_magic != TMPFS_MAGIC)
> +		return 0;
> +
>  	/* There is no real quota file, nothing to do */
>  	return 1;
>  }
> -- 
> 2.51.0

