Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE9D0E748FC
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 00:16:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30B056B0005; Tue, 23 Dec 2025 19:16:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28E716B0088; Tue, 23 Dec 2025 19:16:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16FFF6B008A; Tue, 23 Dec 2025 19:16:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 03B006B0005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 19:16:31 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9FD41C14DF
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 00:16:30 +0000 (UTC)
X-FDA: 84252448140.11.A68CAE1
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf22.hostedemail.com (Postfix) with ESMTP id B6F3BC0002
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 00:16:28 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AMqOvb9S;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766535388; a=rsa-sha256;
	cv=none;
	b=L1izu2aDSBF9CzIZoG+vhMf0qFwrf4ULt3SSQOpSEh6RcMaZnHel6Ol38Xx29DY/YXhIy5
	zRCityyuN9XWOJR44kdgOsi+WBlkaQNJjTCuo8GTPcQiDrl9cCTvxNYgwF4nWAEEOTJg7C
	q93iheURurTifjYZ0ghHXeyvPMNC7ss=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AMqOvb9S;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766535388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/3as0KK9jiK9MBOY9ErKWGFvvWPWhqUzqXP/S7u5uac=;
	b=QF8qFjoExPnBOfbfFXbWr4ASCqGdRbsVfHs6DkPJou768MvSu9dvaRb9cCAQhdmIUcw9vg
	1ZKZxTCNO5GgiuI/HIIKY76iTW1JIpgJHUEkYttlEYd14W06rEMv/l7AYDw8V3Lt0seFCb
	dSlbLtg8kCtCc19L5fxRzLNJt0T3w3w=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2a137692691so63013445ad.0
        for <linux-mm@kvack.org>; Tue, 23 Dec 2025 16:16:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766535387; x=1767140187; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/3as0KK9jiK9MBOY9ErKWGFvvWPWhqUzqXP/S7u5uac=;
        b=AMqOvb9SzByPrluRxev2hFGubIItha9nToBgAOa3Dw24RL+LeD2GhyEwK/ZRhrPq8O
         k0snO+oNIxLVgztV2MhzM5jcLAZscNmv3zI1UaUMX89SmgYZmuFB761bSvLbYoQTDpKU
         CeGmOCLUfHch3UDsXfSkFzEClOw5IlILebIP+8mufvXJ3tgFZoqwtTO1Eb7vbKWjawlH
         lUrZJm2d9zAB6u89axMLoBxWOeaKf9Vtxq9Y7FVYP2jjdcGLm9CWPgwOrz4vqwVyWirT
         VwONf9IJQOES0mTWqSJJNDXuAhY6TMvGKhn/NTkpqTs4bXd4J67/XT8crGp+TFtkEnpz
         FlRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766535387; x=1767140187;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/3as0KK9jiK9MBOY9ErKWGFvvWPWhqUzqXP/S7u5uac=;
        b=bjl+tPtA2dpcpGIqqWV/snM94f999xlBY4pW/IVE23fNHkVt7zEM3DM2bC0QgQ+AoJ
         el0dH/bZTVxcpONiQ+VJM4XInVAt0KwyB5+y4M+OUltN1KH9pagGOrnpJm+uB5rdkcW6
         Gt75xhY323CsyzBzQcQEe1Ib4FbLinqFq7IexI+iMekMbc/qsraHfjgbhAGpR+G15naa
         UVFCU8IwdO4aX8xWWgsJivqlcGQVTMsk8Zpv68OXkkcWuxHPratfrIoNDPZ2gr+eskt0
         oYzkLXDtZyKfYWYFS0YWDhuk4b9bmRUxVeh9lIjbbQ/QwOfwQbgdl16CfY8UYxE+QUEe
         jC1A==
X-Forwarded-Encrypted: i=1; AJvYcCUgLZcv/9uHksIUTMQ6HfhAInCdj+4GtFOMQawXNkRSwrHjFGXeV0ErLAmsm9AO9rCub5CgOl1Blw==@kvack.org
X-Gm-Message-State: AOJu0YwYk0JWRgv7vG4zmaBWYj1j68mCvJ11lvl52sp1ADlX1LBd798R
	6TC2HPK0/1Y2DIF8RbDyKanr3Q39oK94KnlINAGaifMqE9u2FRjzGKbv
X-Gm-Gg: AY/fxX60EgdrIl7NtvhpDbkvD5c3UfFKV8f4ruFrgAfp+itBUQku804JIL83oZ8Raq7
	85K2Pbec4QntXy72gPReuwcp6C3zF3EgpUnPHOjn+6KBXN/abeTX3AqHeZHXmW9rZw3Cj3tZdRw
	2rixvPcvjupM3+D1RJZc140+qaFbGgoRbuuBc2lEYIBqjWofQxwz0TxjYFV6TzBaFobx/mryP+F
	i+cEcmdhTO4ko1kI/ZhxxueIWpAk7ekvqYtgeUNAveCV4MBDkRE89HPyQFznLXOrZOfhNcP1H6T
	n/W1Uw0YIiHPjSJvjgHiFK/j9AxfZUJgjLZuLwuCWThepolvv402LRBZm+THaIu/5BU0ZCEci0c
	WktKEx5nFc9KSClg+IqFa0UhfcCO1bmKk3Xyab43MP0k7fH3VkMo1vNacWKPZdLTA6kz+7ldngO
	biXYS0eBOasoHR
X-Google-Smtp-Source: AGHT+IGx+27QTffUYdLS3J+w0/bNQA8s35EwyjT+BuL3pLFC3ge5l6vQiYv7HpHnMcjPR2qm/DaA9A==
X-Received: by 2002:a17:903:2441:b0:2a0:941a:6b08 with SMTP id d9443c01a7336-2a2f2231aa1mr157311945ad.21.1766535387372;
        Tue, 23 Dec 2025 16:16:27 -0800 (PST)
Received: from barry-desktop.hub ([47.72.129.29])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ff7e797787sm14756538b3a.60.2025.12.23.16.16.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Dec 2025 16:16:26 -0800 (PST)
From: Barry Song <21cnbao@gmail.com>
To: pfalcato@suse.de
Cc: 21cnbao@gmail.com,
	akpm@linux-foundation.org,
	baolin.wang@linux.alibaba.com,
	bhe@redhat.com,
	chrisl@kernel.org,
	hughd@google.com,
	kasong@tencent.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	syzbot+178fff6149127421c2cc@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [mm?] KMSAN: uninit-value in swap_writeout
Date: Wed, 24 Dec 2025 13:16:16 +1300
Message-ID: <20251224001617.45293-1-21cnbao@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <7ng6tntadu62ls32r54aetyevgbghta4oufyzxtq5ym6bprjai@hc2ozb2mbcyb>
References: <7ng6tntadu62ls32r54aetyevgbghta4oufyzxtq5ym6bprjai@hc2ozb2mbcyb>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B6F3BC0002
X-Stat-Signature: 7ju7kwxsgdwm6p7odkrydtyikxo4po87
X-Rspam-User: 
X-HE-Tag: 1766535388-906855
X-HE-Meta: U2FsdGVkX18dQ4fj7TBrcckzLs+shz3diZZDR372INjhTytX+IipYSVI+2a1HxLKR0uM+4qvjXDK/We5kyRQ7NrTSyHG1AJS95TCXOfMhV3t0Yl5+06rroPP6kjGOmlZZbvp3kRknYR2QVWFTPgPfiOitC3gh4EJKrY4AlDA2i30ySj/bpFfZVQUeZljmr9PPI+RUyXm0eyRoT1nq9o0cWIV7asd5qmSgQxSXH0i9R+OHgI42hlccHB7wIK86/J3btoVF41lh6H+reoY60+SnsU6NDE19Ge+nfuHzNzTSePNv2GxR1sp7LWyUHCmm1nBc3zBbV2I0ICmAS96RFB8Em2c+TgptwdSb+1nJ41h1g8F2e3hhovN8ggwAEMCKI+pS1KcLSfuESNOBmSGUhoZ80eg9QkqhLKqTUkm1yby/m25T+TKqFsxZgcWeURnB+F1lubH3oExq3rgWyO9HKK7TI8GZsObR5PWr8uTiM4MNClSgwZ4O5hOKsTFlcxqT/FCt8RwocSTSVT8CgX2a1SJih2Vc+MeTj+Sf2u3fW5fzNIrMg1JKiONrcJGTIomjH4zfFyHgfpyil0PRqVojuo/qGZUw5vJbOwC4kNFERtdYhnvAegiQJGNcm49yOXSKxeEqY/uoKhMmu8rvL8065oR8+jJJ0miB5JDC45mU3jTl/3DMxbN0mCEFNLxBArrg+K6tjFK9qJQKFZMIUIo15u33w8DoL3z5ZA+r/uyI38707GpKREiU36DVisrQc1loeoPdeItaROirpEIR6OYNeJSLF1+ODhyTB9Oe5ijjkfBWNvkr/3l1T9aR0FMfkGh8+ZZm2tjI1Nt8u+G09sy8ujEwx0Nkdegceo7KL5w7DLtlofO42vuYTYjoLiNU99dKfGMeyr1ssucfTOuWe4p3LWUycwt7kHiJ088i9lunm7aifN/6N4J2CSDNgWOQwFnChFkn4gY4M4btVEkxGe99D5
 XJhE48im
 n3lf/499byShMdDLxxYPUWVVwMzpZKKfWQbq34bfCAOlIHr3M9Yy3A93Y0SMEHbZeRFeUP0kJn+L29RXpMC/vi7ux7qEROLtPGLkMbfhG66Io0qb0Fiu1QFqgkmgR762/AJg+IfN1FY7IXRabJ2IgoCS30Lw3uyR/pusM1yfOJydcvIAfPHYuNFkTITmJmNR78G0p5z+wCjQm5ffTlcJSAMvZM7ynErD5GTQAHE9AvGnjq2206f2erRNhkKRtDSzAehIakKF+jGmK2FfnNY5woTS9g8N1FUiw7ySOC7VjMfQBNYTN0nPW4SvuwcuE384r+bbE+M+zD4jOEl/Ic7GqHFfR+JoBk8WBmB4tp8QVbYx7mhtTgHapnYe/kXBBOvvY5BrfOgoThJ//3m470VqT5PuFLIWv31BLWcwfYh+t2NUBw2IpbWudRK4pXqTFmxAGb44+oPDzEToYsHxRFAQDCMT6UiAWWXUm2Wb/sbvxwLY3Iumhox6CPOvzUWQGAq79uyEq8V2YHC8nEEAW1H1nu0My5q4wTDO2Di3HnSPUT93VFWj9KzQ/fhtsgCLxTmZnHtJ3ll0FvDSbkm4MhDxiEFV51shV8bND2g0L8HRlK9Oy/VI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 24, 2025 at 12:43 PM Pedro Falcato <pfalcato@suse.de> wrote:
>
> On Wed, Dec 24, 2025 at 11:46:44AM +1300, Barry Song wrote:
> > >
> > > Uninit was created at:
> > >  __alloc_frozen_pages_noprof+0x421/0xab0 mm/page_alloc.c:5233
> > >  alloc_pages_mpol+0x328/0x860 mm/mempolicy.c:2486
> > >  folio_alloc_mpol_noprof+0x56/0x1d0 mm/mempolicy.c:2505
> > >  shmem_alloc_folio mm/shmem.c:1890 [inline]
> > >  shmem_alloc_and_add_folio+0xc56/0x1bd0 mm/shmem.c:1932
> > >  shmem_get_folio_gfp+0xad3/0x1fc0 mm/shmem.c:2556
> > >  shmem_get_folio mm/shmem.c:2662 [inline]
> > >  shmem_symlink+0x562/0xad0 mm/shmem.c:4129
> > >  vfs_symlink+0x42f/0x4c0 fs/namei.c:5514
> > >  do_symlinkat+0x2ae/0xbb0 fs/namei.c:5541
> >
> > +Hugh and Baolin.
> >
> > This happens in the shmem symlink path, where newly allocated
> > folios are not cleared for some reason. As a result,
> > is_folio_zero_filled() ends up reading uninitialized data.
> >
>
> I'm not Hugh nor Baolin, but I would guess that letting
> is_folio_zero_filled() skip/disable KMSAN would also work. Since all we want
> is to skip writeout if the folio is zero, whether it is incidentally zero, or not,
> does not really matter, I think.

Hi Pedro, thanks! You’re always welcome to chime in.

You are probably right. However, I still prefer the remaining
data to be zeroed, as it may be more compression-friendly.

Random data could potentially lead to larger compressed output,
whereas a large area of zeros would likely result in much smaller
compressed data.

Not quite sure if the below can fix the issue:

diff --git a/mm/shmem.c b/mm/shmem.c
index ec6c01378e9d..0ca2d4bffdb4 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -4131,6 +4131,7 @@ static int shmem_symlink(struct mnt_idmap *idmap, struct inode *dir,
 			goto out_remove_offset;
 		inode->i_op = &shmem_symlink_inode_operations;
 		memcpy(folio_address(folio), symname, len);
+		memset(folio_address(folio) + len, 0, folio_size(folio) - len);
 		folio_mark_uptodate(folio);
 		folio_mark_dirty(folio);
 		folio_unlock(folio);

>
> --
> Pedro

Thanks
Barry

