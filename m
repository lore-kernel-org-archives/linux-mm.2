Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D79CEC1449
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 13:39:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6CBB6B01B3; Tue,  3 Mar 2026 08:39:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A17146B01F1; Tue,  3 Mar 2026 08:39:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9439A6B01F2; Tue,  3 Mar 2026 08:39:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 860856B01B3
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 08:39:47 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 53E45160176
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 13:39:47 +0000 (UTC)
X-FDA: 84504859614.29.352FD72
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3F8CE40004
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 13:39:45 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FMixDZDB;
	spf=pass (imf17.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772545185;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6DevB8G8CqRbuo/6f5OwxCJnI3+MmQoam4A5DcM3fbY=;
	b=qpHQ9MEfYhJegMenTm4+4vytELZiWcBUPlQhs6KXseSd6bOjS8zFmtA9ZVO1pBbIQ3MB27
	QG/CFcR2SkrJHzn4BcxKsg4kgnwIftaLhECdMKWoiZLySnctdrm5n6x1PuM0ksg3Uu9PYz
	AiBnzyhRj9vJg5Du5/dmVbEcy+YzOXs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772545185; a=rsa-sha256;
	cv=none;
	b=Kh7N3Cw/ymFCvs5zrEJexp2oetgqAyFX+7EsEIDut3A4tZHADOEH50tqG7ir+1zbGUF1K5
	4RszTX1WmFf5WkMuAxdSCTrpb1dbG5+641Uiu+KIxrDyY1KnVfb1MWU40IqFutdFUgwu05
	lRySjruyJQwHgteuET3w/DpLG8CQmdk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FMixDZDB;
	spf=pass (imf17.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Tue, 3 Mar 2026 05:39:34 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772545183;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6DevB8G8CqRbuo/6f5OwxCJnI3+MmQoam4A5DcM3fbY=;
	b=FMixDZDB6BDwiveuWiFouNr3OiYKjgJEDGGXCM2Q8eeBPoeF1ikRLe4Do7AnehwdnzruMZ
	5YQHLT6LVedl1i5y5F0/OqMa7HRXUgKGR6PzEedjqLQPesLS7sYQrOc0A7upzBAtdxgE/L
	LxKtV+jG7rKZVN1jRSZYKAnclla4vdM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Axel Rasmussen <axelrasmussen@google.com>
Cc: Matthew Wilcox <willy@infradead.org>, Kairui Song <ryncsn@gmail.com>, 
	lsf-pc@lists.linux-foundation.org, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	linux-mm <linux-mm@kvack.org>, chenridong@huaweicloud.com
Subject: Re: [LSF/MM/BPF TOPIC] Improving MGLRU
Message-ID: <aaZjADxC7amOH7tB@linux.dev>
References: <CAMgjq7BoekNjg-Ra3C8M7=8=75su38w=HD782T5E_cxyeCeH_g@mail.gmail.com>
 <aaBsrrmV25FTIkVX@casper.infradead.org>
 <aaHaSRXNLJNLwvKh@linux.dev>
 <CAJHvVcgU8ZgJAymFfxr1FC_bf6gB0mpr=VTbtSdFqY4iVB-WGg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJHvVcgU8ZgJAymFfxr1FC_bf6gB0mpr=VTbtSdFqY4iVB-WGg@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3F8CE40004
X-Stat-Signature: f9nintipkgaziju1bz6qa33jf4qpox4t
X-HE-Tag: 1772545185-750179
X-HE-Meta: U2FsdGVkX19rVD0CQMFEOjPc9l25TKYwxt5HA1NOOrG35yPNy1cdsv2NQX3AhTO9LZyyXh0qA8OsXXX/CZVuB7I8rHDWMeuFMndjvEIpP+pT5zqi1jG5uCU0tLQs27C9TvRfP5QyHwM/4Wj6S8Iqj04pZEi1f6Vp+g6cbZwEir2E7FS0xoU+5Buy96PuJL5Lfqo2qeUm3nJDFFiy1jK39vTzPOZ1Q2ZIatjuijZF19/YoPbQWHAjnKrxf3jUOuNhyqMeX+q7WZfJ3llHKYZv1G9CPq78fxK3GO8K7EDav8Hrc/79+6NM2O3L7NJSzgSFT7mzdNOljKR4f2XuNX74NjDqweo5KO17YJHFNQEnAy6A/b7msOdFC+yqhBlqAvc0N5Wo/mO8ujW8GPR3DQuIaYDyQtRl2Oe1iORX1vEq7w1sYeBKBnJRGEuKNOD5r7klcE//K5mNEepEcbuvR93+xaGYFtQgbM5BtGvkHG7HuZvHMeWSNGsexdmu5pQqq3z7ISeldUAB7cyCd0YMovYI9PzIttxG5uBqFNW/hTrFQARDLIPbtOwrbzWPhTUFoJ25TBXwwFWphBmMXQbZh71RaG0OQYJLAlJUMNGjPM4I2frjTbKg/t8oK08LDvM5l1T2Qi8MvDCgwdbrAMUMe5OJPx1WmED7FdOXEglFmqoDdnDs6/qIRTOIzuz628HZRL8YIKki6NhkmGnhEGhUqQXHThzEoGxqdXrXvw1pKVgYBZiCIqboEvvNY45gzRFFeKpi9lcNAkjhR3fRceVtVARo8TTYmQ+Q2CPT5M9gs2muzSL+R+opYRD/uCDuXJdWgSfVbe/lhYtqrjpYXvEmCkiCRsHzj9UV3IGw6G5bLZQrEXix9kSSKJDa72EodEvaHYIQruZrj30bXy0a+99HIkqZCkkDRagVlokfaMxihFcU7eyUrhL7Kg+Cnxm5bQkA+yXqqvzKCzf6jkoZe/0Oig6
 54wT6E2x
 urAxWL0oPYtSITMFFFgW8O4UCoNamL4ak89mIWBiufowCTuOGSoVDFW7v3XPgj9SsjjG750XL12uX4TJmQm+puBcllF4eOXof0qXk6jfMMdW3A1mEwixVDGLStPVOjO35PyOMzbsCsXaJVWMqYC9Q0UY9Man6Yuie5qaCdt8cDKKWXKzHRk+XurOpG2L+LTNMMzVUjLpsy560+B1Bk7AkGMjZjROBOcsRZbnccHZXZHR13Yk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 02, 2026 at 05:31:26PM -0800, Axel Rasmussen wrote:
> On Fri, Feb 27, 2026 at 9:56 AM Shakeel Butt <shakeel.butt@linux.dev> wrote:
> >
> > On Thu, Feb 26, 2026 at 03:54:22PM +0000, Matthew Wilcox wrote:
> > > On Fri, Feb 20, 2026 at 01:25:33AM +0800, Kairui Song wrote:
> > > > MGLRU has been introduced in the mainline for years, but we still have two LRUs
> > > > today. There are many reasons MGLRU is still not the only LRU implementation in
> > > > the kernel.
> > >
> > > To my mind, the biggest problem with MGLRU is that Google dumped it on us
> > > and ran away.  Commit 44958000bada claimed that it was now maintained and
> > > added three people as maintainers.  In the six months since that commit,
> > > none of those three people have any commits in mm/!  This is a shameful
> > > state of affairs.
> > >
> > > I say rip it out.
> >
> > I have very similar concerns. Though rather than ripping it out, I would like
> > we put efforts in unifying the two reclaim mechanism (traditional & MGLRU) over
> > improving MGLRU.
> 
> Shakeel, I think this is a great idea. If you have any ideas around
> low hanging fruit here, please share. I'm planning to invest much more
> time here going forward, so I'd be happy to turn some ideas into
> patches. :)

I think we can start with memcg LRU on which Chen (CCed) was working on. Also
why not propose a lsfmm discussion on the topic, I am sure many folks will be
interested.

