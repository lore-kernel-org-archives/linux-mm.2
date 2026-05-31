Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0AA8CD5BD1
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 05:28:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 879776B00F5; Sun, 31 May 2026 01:28:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82A826B00F6; Sun, 31 May 2026 01:28:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7421A6B00F7; Sun, 31 May 2026 01:28:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 62F1A6B00F5
	for <linux-mm@kvack.org>; Sun, 31 May 2026 01:28:18 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8729FC162E
	for <linux-mm@kvack.org>; Sun, 31 May 2026 05:28:17 +0000 (UTC)
X-FDA: 84826584234.04.028F09E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9E11FA0006
	for <linux-mm@kvack.org>; Sun, 31 May 2026 05:28:15 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ht9a6pvB;
	spf=pass (imf25.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780205295; a=rsa-sha256;
	cv=none;
	b=twsuyWKS5jSyH7L9Xuc2JHQoBUOaNsHfUHiIEvegvQQ/s1vSPpHu2wTxeLTfw0cQmecdK9
	Jqd5vbY3IV2LQyhKyKscdkfLcycu2r4RxJXktbvSkaus2SUUaBvVT1W+egodUouRKsxgPe
	p4aPE9x4aWA8Bin7+Aq+rVEAtlhlEgA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ht9a6pvB;
	spf=pass (imf25.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780205295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oJpSbrXN0X73x5V9/u/EQv8cWOQ13cY7JpP2vdc74R4=;
	b=MpXuj3bvwmx76s7xWrr++hJdcrrkS28oS4QMzHHoAhZO8pOPdeBUM7kCt88LsLMtkqPUcH
	ytByS0vSXEE0+wLm8yP2xrPM6ZKSRuTB7AUY0FN7TeISuZ4R5xFy0Aw2HVrCOb084Sh1Q4
	yOxwMMJ0li/Hejl71/YU34AueqZvrCI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A080A40B41
	for <linux-mm@kvack.org>; Sun, 31 May 2026 05:28:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79EFF1F0089B
	for <linux-mm@kvack.org>; Sun, 31 May 2026 05:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780205294;
	bh=oJpSbrXN0X73x5V9/u/EQv8cWOQ13cY7JpP2vdc74R4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=ht9a6pvBxNc+0tlAIDDDR0zj4rcTGB+EDbqNi92eTgV740lT1WSQzZlB7vynOLMJA
	 AeUzHHhpvp8OD8VOanuLYl/0OdKkwbkUBqwMXAT5XObgLEVEddW5uiR+HUhZzrWtqw
	 NCDSuZeA+oD/9Q7IAsg6B3z/ILYzZ5tXutsM1NWCbkMigYwlBIjvBbijA7K4VRximM
	 tF3vv4S5aDKujJRaIXeOm8ndwcIjVz4lwRujQUJutXUQM10dWmXo8xJw9zIgZZ7Xq+
	 sYfindI5nPK9Q9IcUbwO4gmMRhIfXWcwYST/z1VkMmk2UL9F0ILGrv7kRg15ZjsGz5
	 s+boewmu2sbsA==
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-914b03e42b2so1125870985a.0
        for <linux-mm@kvack.org>; Sat, 30 May 2026 22:28:14 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+w7R1mRexta+lDiSv0bET617MM4jQg2o36Id50HW2vJ9n1rb0tu7zgF81WIw+xq3/1RjhwHCvTRQ==@kvack.org
X-Gm-Message-State: AOJu0YxyY4Hh9OudEyeNmUaSvzk5Nw/s8qjMEaHYInNsNHJ5aA5oD9tP
	1kQ8pgoe/fxlzwD217aAAqHzHpc37qw0adq+neNLRk1DA4mLS88pa9d5t4iMkAv/JD/DqFD4dLX
	rFj/VSSrvtIcNnhly/Mg+KBkMAJfga0Q=
X-Received: by 2002:a05:620a:a2d1:10b0:911:9a7a:8076 with SMTP id
 af79cd13be357-9153d96b5edmr605566585a.8.1780205293922; Sat, 30 May 2026
 22:28:13 -0700 (PDT)
MIME-Version: 1.0
References: <ag_OVwPF49LSZ7rz@google.com> <20260522141115.GA8258@macsyma-wired.lan>
 <ahCNmWbcd_2lAJyk@google.com> <20260522224108.GA18663@macsyma-wired.lan>
 <ahTzHyHBL8t0iNBR@google.com> <ybmbjekuvzmaw4hmlxd7nxs546dqtwmxqxwyali74d6m3u7tat@b4q3japqnhrl>
 <f4e521ac-2381-49ca-8dcc-3cb3cf3ffaea@acm.org> <ahaPDHiXcJoVShPv@infradead.org>
 <ahcU5xbVy7xjps02@google.com> <ahkl52N3RDcusCNd@infradead.org> <aht812OhSPFqIBPK@google.com>
In-Reply-To: <aht812OhSPFqIBPK@google.com>
From: Barry Song <baohua@kernel.org>
Date: Sun, 31 May 2026 13:28:02 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yJihngSY0GNcc+MwPHJjpF1qCnS8-UE1GwYoNDtEm9mQ@mail.gmail.com>
X-Gm-Features: AVHnY4K7tD5FaTjYu7fBuez0V9tZrcHA503rjhBejqB5_6W7Gc8g8vahJmbPfLY
Message-ID: <CAGsJ_4yJihngSY0GNcc+MwPHJjpF1qCnS8-UE1GwYoNDtEm9mQ@mail.gmail.com>
Subject: Re: [f2fs-dev] [PATCH v2] f2fs: another way to set large folio by
 remembering inode number
To: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bvanassche@acm.org>, Theodore Tso <tytso@mit.edu>, 
	linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Matthew Wilcox <willy@infradead.org>, linux-f2fs-devel@lists.sourceforge.net, 
	linux-mm@kvack.org, Akilesh Kailash <akailash@google.com>, linux-fsdevel@vger.kernel.org, 
	Christian Brauner <christian@brauner.io>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9E11FA0006
X-Stat-Signature: m78c7wq3mfmt4p5f69x4z1kj8qixtbkn
X-HE-Tag: 1780205295-369144
X-HE-Meta: U2FsdGVkX18n7os2c0mgaHMJjs5qgsN5WfiK3iJhKSbv6Epy9C5S8iT892DuLCJd6llpRcc1W6tRXb/BVrZet14K/p6tGwFmP+dvzSyRdpqMjvwS8GyF9yCweeT6+C1CAQxQKi/4a0G0Xc0A17MhH69QWNUgFf1ywToq/hsvDq7KfZ6TelVhotemRqSBpwlY5JawGzyhbS5YWCCRaYj59IddFM83frv4TXwsBMfze+33vbosuCacdTH/+6vUx59CMfxGIlUpzMsy/U6ZqjKiGXRLLCNklE+5TS9zjPAS2OpedSYOVzf5J8xA4JoxSR7wNCg6q4GkmvSaRovx3cpScUSQId9nupVfv1Lh0P1KqhmO2dhZXhlCgT4tI9+dvuiemZqigFOpV0WuYOBX7RqEJymDASp8NlLvlxwpFEqhBGRwNuCwD5V3hsPozxj06yVG6txGM9JgjrwHs4FPmrwQA9TJcYLQ77F3GfprHCE/FMvryMucWkzvM86agP6m9Xotd+oYZ9baDju/kNfR/LioOYIm+guQy7SYTUmpnr5LtQwTjjgrioUlduwGYStPuG3d++uCE9+IOZ2Iy0oVXT60/iyNPp7JU4KSClJd7UV1bcSVY1zAU1vTskEw/OEsmvFHp3I+lBSYtG+iDs3jbBdC+k0rdsQuMKNSnyPQha08WXF9us/vr7H7xzHK9g3xMY7cjp/1ilch8v3+tn+tD8mvGtMiv1pqUJ9c63arcRFOWz9sm3WtE/OmwHei8uASTzjcmAlZBrOEOIllDbbpCw0CQAtAjOzpUjAzKMoGws6RuK+QaKQlddWknlkXa1gM5TF1qO0uwYM+6e3+poSOwJMBl9PkxfV+kVC7pr8nmjAGjS0dwSa9+YPXqsaK5kdR0j/0WHlsFAjVuqICp5ZJzG+ehZK1rEyDqKQkI5ybLRr+HkfWzHvGMS4BcqgPbNHjEIVRTFdbJZtMeZGMLPMO8AZ
 zPQ0vyHD
 lKVDQaIEowNe7Q3nYVanxn+Q43QvMFrr587ZBh3ZvIn5QCQr0w2hEzDPrJbNaPZZSNppOIbJSuulWMNiANdHbNs025NeyFaGGoVKjUsl6RSU2HmPjEQ050Oay0GDxaWM0DweRvRvzaeBc7mq3jZkam6u3nyTkg1ra22mdrjlVl6+oB8eIUZ1nu0BeW58rHq++xwjsj0gRF36Y6Q83C1fhdLTjCsHy/clWo3Kohiq5b3bnPRVinG01nrXn+iv5cm635JB6aUlgAiyjBHb4GCuzcRwwHK9xrA+p4oCr9lf5nlBoO+keDKOJA1Ar6g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, May 31, 2026 at 8:12=E2=80=AFAM Jaegeuk Kim <jaegeuk@kernel.org> wr=
ote:
>
> On 05/28, Christoph Hellwig wrote:
> > On Wed, May 27, 2026 at 03:59:35PM +0000, Jaegeuk Kim wrote:
> > > F2FS merges bios before submit_bio, regardless of small or large foli=
os,
> > > since the block addresses are consecutive. So, I think IO subsystem w=
as
> > > working in full speed.
> >
> > As does every other remotely modern file system.  But that merging is
> > surprisingly expensive, which is why using folios gets really major
> > performance improvements.
> >
> > For one doing these checks to merge touch quite a few cache lines.
> > Second, devices are often a lot more efficient if they see fewer SGL
> > entries.  I.e. having a 1MB bio a single SGL tends to work better than
> > having 256 of them.
> > The same is true in the kernel code itself, both in the submission path
> > (dma mapping and co), and even more so in the page cache handling
> > both before submitting and in the completion path.
> >
> > See Bart's patch about how long the walk of the bio_vecs in the f2fs
> > completion path can take.  We had similar issues in XFS even in the
> > workqueue completion path due to lack of rescheduling, and these simply
> > go away when you do the folio manipulation in larger chunks (LAZY_PREEM=
PT
> > would avoid the need to explicit rescheduling these days, but that just
> > papers over the symptoms in this case).
> >
>
> I see. That's also super helpful. Let me kick off the large folio support=
 asap.
> Thanks.

Hi Jaegeuk,

Nanzhe has put significant effort into this work at Xiaomi over
the past several months. Large folios can now be supported on
non-immutable files.

He has conducted extensive testing on the Pixel 6 and fixed a
number of hangs discovered during development. He is still
benchmarking performance, but the implementation appears to be
reasonably stable at this point. We can run Android Monkey for
many hours without observing any hangs.

If you would like to see an RFC, I can ask Nanzhe to send one
as soon as possible after some cleanup and polishing.

Best regards,
Barry

