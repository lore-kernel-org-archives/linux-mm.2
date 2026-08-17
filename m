Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34B96C5DF6D
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 03:27:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED0CA6B038A; Sun, 16 Aug 2026 23:27:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5B556B038D; Sun, 16 Aug 2026 23:27:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D22236B038E; Sun, 16 Aug 2026 23:27:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 954EC6B038A
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 23:27:02 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 103BCA3064
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 03:27:02 +0000 (UTC)
X-FDA: 85109325084.21.2C4E9A4
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4B5FA40004
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 03:26:58 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=o1ClP4Mq;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf27.hostedemail.com: domain of mambaxin@163.com designates 220.197.31.4 as permitted sender) smtp.mailfrom=mambaxin@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786937220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jmUlmtGTb4gVi/IDEHbLDTYOtz1T8CJBO+NBBDn380E=;
	b=3y/T5toJXE8U/cBRBb+pfy1RkWQeVtnkneYgjBPbu3tR9sDw8VReyguk0hiA6uY2ygVRBN
	FXxbgNTmszBan9W3M5Rcc7EgNhQDX8ZXYl7cz+f0ftci05qMrXTCyYI1I63JvJA5420TRQ
	Dg2Io6vMJGEjplYuHweT649Ti0Rw/7Q=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=o1ClP4Mq;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf27.hostedemail.com: domain of mambaxin@163.com designates 220.197.31.4 as permitted sender) smtp.mailfrom=mambaxin@163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786937220;
	b=AJn1htvQK+cDlj80Al5uJGugawS15dYsCfe2qwebtRtkI2TZZoQyty+9yZOf74oU3eLmnF
	TDkbuqE0lnS4uCKM1rGvLda6KdEmFg8uvE0eYj+AnH5Ioxg70/70FvAsV0nlRp7fVPwGMH
	R/958OzgiXMyr2Sfqe0X8x6vTy3NkZ0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=jm
	UlmtGTb4gVi/IDEHbLDTYOtz1T8CJBO+NBBDn380E=; b=o1ClP4Mqj77ZrliAXF
	c2FViRDOp+8kKI798/qcsVA14TvC84/8WHzQQnLrU57h0hnDvQk1wse53UQhRog5
	KsNisreYI3HQQjaezj7RHNReUb6iSMfnadjymBsEvbmjJsSibNGcPtml4IWUqJJx
	gYqYStlMHodZs6YloIAbAfk6w=
Received: from localhost (unknown [])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgD3mfBef4JqlrSwLg--.26496S3;
	Mon, 17 Aug 2026 11:26:23 +0800 (CST)
From: mambaxin@163.com
To: shakeel.butt@linux.dev
Cc: akpm@linux-foundation.org,
	baohua@kernel.org,
	cgroups@vger.kernel.org,
	chenxinxin@xiaomi.com,
	david@kernel.org,
	david@redhat.com,
	gregkh@linuxfoundation.org,
	hannes@cmpxchg.org,
	hughd@google.com,
	jose.fernandez@linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	mambaxin@163.com,
	mhocko@kernel.org,
	muchun.song@linux.dev,
	roman.gushchin@linux.dev,
	ryncsn@gmail.com,
	sashal@kernel.org,
	shakeelb@google.com,
	stable@vger.kernel.org,
	syzbot+e12bd9ca48157add237a@syzkaller.appspotmail.com,
	v-songbaohua@oppo.com
Subject: Re: [PATCH] mm: swap_cgroup: fix NULL deref in lookup_swap_cgroup_id on swapless host
Date: Mon, 17 Aug 2026 11:26:22 +0800
Message-ID: <20260817032622.1135640-1-mambaxin@163.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <an-yt4a6td75VvHw@linux.dev>
References: <an-yt4a6td75VvHw@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-CM-TRANSID:PSgvCgD3mfBef4JqlrSwLg--.26496S3
X-Coremail-Antispam: 1Uf129KBjvJXoW7urW5ZFy8ZFyxCr4UCr4fuFg_yoW8CrWxpF
	yrWas3tF4rJryxtr4I9w1rta4F9a1fW3y5trn5Kry5Zan0vryaqr1xuFyj9F9F9ws3GrW2
	vFnFy34xWr1jvFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0piN6pfUUUUU=
X-Originating-IP: [153.3.251.220]
X-CM-SenderInfo: xpdputx0lqqiywtou0bp/xtbCwR8yPGqCf186cQAA3T
X-Rspam-User: 
X-Rspamd-Queue-Id: 4B5FA40004
X-Rspamd-Server: rspam07
X-Stat-Signature: 8rwbpq7dszkar5c5hppqwattkwiypua4
X-HE-Tag: 1786937218-466370
X-HE-Meta: U2FsdGVkX1/Jzqpuk1ZL0V6PyXCfEQupVRC6IBTOJ61gRMFEk45x8kcrJW+N1Aroi620MmAuoTuSNn9JROcPg3RHZqWP+nklqd12BCNySi8ms759Shrx06ijU+8GQuwVSkvJDxrCK4GJYsciMPKvD0wC+fzuw6BR+SkOq6E552PeP+7KQGq6reSg7aP2ltFF05eGXEpZbYVnFxSLxPiC+r5TwRotEy9kMQoRbF4TdbxvYBoE5qguxGEoUCVg/9pQynbrehwccTcDtRVhzTXy3zjQ86WUhsvE8yVYbvH+qjEgpi4BapIUw8mbQL1A7tLJbJ9Y4CAxjwplSJJsB2k34GeaRf6Mc6qm7/PJJNF5jgg2ge7wAQYqVX9+9KWymDTk0Mu4StIjLFqxDr+qqGfstePwH0d2TaONTmHFd4qwMHB8OUkJ6Cm4XA2iX23mI5ql5EsDtt6uR3zsZvA/1P9o1tw9c4UUjYzMCPMSLM1f5ASUco+W6pc58it8+iCFSpAmGivIoz/PTXfuZKmErDes+dvx+PGVJQB08AbVaUEsfluncOhWPBpC++8r1YC4m/Tglr/uZdtw0jwYUifHwFJz0q+DrkWUtcc6qPYuhetu66RgdMpgr06Gi7sIioJyhxDp3h7eyYingkYtGXpTYyGwf00b7TJxXqSu+rTssyc5UCA7Sqp0k41hHkUwypVi3dj5nVp7R4T7CiH7j9iZZc9xq7b6gIz1svsJhqPqD0QukXCG+qI8CtsrpJ0KIy6sg3eySjsigYXKSbXH3ulgk2+FEAEGh7PX7iCLNPOUstArtH7cMfPn+SIFNI4W8llMFMqFAzp5MbNYrIFw3Bxd3KDJpOdO2oMKiswbdyuozUAqdDCLnrHpNdZ4/IjKRmBeK0f1p+tGDIHy1kS7yACo/vlKvONTLPX/hLz6Gq6hABAISvxl6hWvnodXK8w0saLMStsdpwuRvjw0k62gQzRL0cQ
 HiLi18Y6
 jBDgp8gkf4Xw9ikgnI4vxFStBILUc+51r5sfsizElXoT07oF+r6dRUi6SkcdZJxXKTJzLH/IhfXgBWnXGGSyypb0PDSwXHl1nvoROVmAn7eyN0Ym8R+l5zwbTH+bAYCCk0kNFn80ucdwrxMwYBO1Jagop8cO3u1X/ePSZthJV3uq+eJcixwvCOen042NJ9SkP5GmJxqYTwgwMlEsYXH8ATydj2CUuSfBg/PIN71jHbq5yo4JVeNVHoXVFZeigcVIXaxh1jwK3WdEE05CBKqV8w0M5RIMzBT/2kJvTT9/4OtQo4YzHuCSPcJL1/3zxjiHxCv+f5rMbYCJITEK4rtZEBGq01xfJe6HAJpEjuHLrw3V0jW4AR/c+j00vznixd7qYWGXiBsn22aT9t3n7E6e2rnIpieDi/5vIL3GdHoySUwFSD3H/hAFSDKfjkBjm0ge2R/G+wS6slwi3rR66PuWrKGaf5/gfxqWj25wosqGwOsMDtWfRNBEgOCTOVFoAQjmblcTgvr3y27HsKRvmX6xlvQIOjM7cQEEi6wArQMxiHEh3BJA6486MYTe2tPJ8avpFTd2gdvmbSNHVI/h3s0cdXZU3iw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> On Fri, Aug 14, 2026 at 07:23:41PM +0800, Barry Song wrote:=0D
> > On Fri, Aug 14, 2026 at 3:48=E2=80=AFPM <mambaxin@163.com> wrote:=0D
> > >=0D
> > > From: "Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>=0D
> > >=0D
> > > [ Upstream commit 63b02a9409cb5180398491b093e48bcb5315f5fb ]=0D
> > >=0D
> > > lookup_swap_cgroup_id() passes swap_cgroup_ctrl[type].map to=0D
> > > __swap_cgroup_id_lookup() without checking that the type was ever=0D
> > > registered via swap_cgroup_swapon().  On a swapless host every ctrl->=
map=0D
> > > is NULL, so __swap_cgroup_id_lookup() dereferences NULL + a scaled=0D
> > > swp_offset().=0D
> > >=0D
> > > Since commit bea67dcc5eea ("mm: attempt to batch free swap entries fo=
r=0D
> > > zap_pte_range()"), zap_pte_range() -> swap_pte_batch() calls=0D
> > > lookup_swap_cgroup_id() on any non-present, non-none PTE that decodes=
 as a=0D
> > > real swap entry, without first validating it against swap_info[].  A=
=0D
> > > single PTE corrupted into a type-0 swap entry takes the host down at=
=0D
> > > process exit.=0D
> > =0D
> > Thanks for the patch. However, we have a strict check to ensure that=0D
> > this is only done for valid swap entries:=0D
> =0D
> This patch is already in the upstream linus tree.=0D
> =0D
> Mambaxin, what do you want to do with this patch? Are you requesting to b=
ackport=0D
> this to stable tree? Which one? It already had stable CCed, so I would ex=
pect=0D
> the stable tree maintainers would pick this up automatically.=0D
=0D
Hi Shakeel,Yes, we would like to backport this patch to the 6.6.y stable tr=
ee. =0D
We have encountered the same issue on a product running the Android GKI 6.6=
 kernel. =0D
We are still investigating the underlying PTE corruption using various debu=
gging approaches, =0D
but the reproduction rate is low. Given the constraints of our product rele=
ase schedule, =0D
we would like to first bring in this fix from upstream so that we can subse=
quently pull it into the Android GKI kernel.=0D


