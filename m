Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C7EDC61DE1
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 08:35:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B75676B0088; Sun, 30 Aug 2026 04:35:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B26A26B008A; Sun, 30 Aug 2026 04:35:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EEBC6B008C; Sun, 30 Aug 2026 04:35:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5F1816B0088
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 04:35:34 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BBC6B12028E
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 08:35:33 +0000 (UTC)
X-FDA: 85157276946.04.D5843DA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id E417040002
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 08:35:31 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b8fTlafw;
	spf=pass (imf01.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788078931;
	b=1+LU8x4gkVd6S0+TmG53kxCWRDh5zXmRXrmiU2PWzCPmTbn6OfJxl/0YFTln7RSncc6pV1
	XSwv7/vYx327fqWYsBmT8BIwRrBOqEahttFI3p+nWvdio3Rmm7gpNIhtxiI94GrNz7GQ3+
	rxfQdZyep1iTIPkmg897hJnUjuMPc9w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788078931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B/BZcM1Q1yyTiL+u2PtZ1N/UUsr6bDlHImpT2ZOZlfs=;
	b=BvJTwwA7qlM0xDKIv/J8YTeThvB0OlfxCReXSY2R7Ujvk0TwZbxk12IzoE4JAyZt8ktIMf
	zV+W1/Kjg9OUh8pnkmFeCxFh6nlPDPC7aNWuIledJHJm/oKcxGbBetCVo11ZWtGkEV8Jzb
	6iIjn5UyDhcXAwNzvq7xzpeWxmMQR8Y=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b8fTlafw;
	spf=pass (imf01.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3315D600AE
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 08:35:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF92D1F000E9
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 08:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788078930;
	bh=B/BZcM1Q1yyTiL+u2PtZ1N/UUsr6bDlHImpT2ZOZlfs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=b8fTlafwH6UFDyGONtyr6rUiXpbbUs62Tm16Rs0gt+kRY7v3OA9AGiyfZnTd+xXwa
	 KYt8tuSu3Icc6epTbfaWFqWfSD98F2MKVe1P47wRi2daLxQd54NMxTsoQYXtO/PKCP
	 aK38K/JkKZOnRUvOELHQt+JlxgSayPDc16QZ/vYz1+2X8EocqN64ewOt+FwLF44haX
	 ydIfae8uixrpGQfOOE6eJg2yT3Rih0K4Lxd7ifB9J0SNy8sJUa5KlhsY7XnyX+vC0z
	 8nZnKmmVxiD/hXAgkEIwn5PJ8y8HAGM3rhNj5NeTlWFw6BD9JsEV4ktJnftU43/PKD
	 3ymWwIbIAbOjw==
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-930f618435cso179576885a.3
        for <linux-mm@kvack.org>; Sun, 30 Aug 2026 01:35:30 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RoBOLt8u5UlxSotZZuAb2r0lM3ARiypjkkGVXguuYA4mKAB1wHpBpTaJyho2k0NiqB/qksF8EwSvw==@kvack.org
X-Gm-Message-State: AFuF++lQLPeeHvBQSJUkFULBtLqfkeXap5gQ2ritjURscfVbcJJYQyLX
	1gf0DhZOLILb5DJzBFtm8cywcBhkr9ay080JZsTl1/jTRmtnYnqHEB5yVZR1vNMm6ehkTK84d7/
	/7RhO/qkFrq+l8l4xSI7JrlbL9uLHDqo=
X-Received: by 2002:a05:620a:40cb:b0:936:cda7:554d with SMTP id
 af79cd13be357-93913798773mr2019122985a.14.1788078930311; Sun, 30 Aug 2026
 01:35:30 -0700 (PDT)
MIME-Version: 1.0
References: <20260820142956.1414337-1-qiwenjie@xiaomi.com> <3fa43eaca792bc0bbde4b82a6c1fcdd3f528b398.1787999152.git.qiwenjie@xiaomi.com>
 <4aba05e1a2c3b61cb337d373eb9b7a8db4ddd822.1788024049.git.qiwenjie@xiaomi.com>
 <20260829111621.41ed2bc9a0e99e3367eb96c3@linux-foundation.org> <ef160933595c365f2c47597b260bc7ecd98ed7ce.1788029516.git.qiwenjie@xiaomi.com>
In-Reply-To: <ef160933595c365f2c47597b260bc7ecd98ed7ce.1788029516.git.qiwenjie@xiaomi.com>
From: Barry Song <baohua@kernel.org>
Date: Sun, 30 Aug 2026 16:35:19 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wpUBOXKd8aGNz76U+87bwDUXZZFSW2UhNcq4qpjVvggQ@mail.gmail.com>
X-Gm-Features: AcwNN1XKAv-WpIMNo6BgbyKwLX6-0pyA1HhQGvJzilWFR4BrtIbEJ34mKKdkwmc
Message-ID: <CAGsJ_4wpUBOXKd8aGNz76U+87bwDUXZZFSW2UhNcq4qpjVvggQ@mail.gmail.com>
Subject: Re: [PATCH v4] mm: filemap: retain mapped dropbehind folios
To: Wenjie Qi <qwjhust@gmail.com>
Cc: willy@infradead.org, jack@suse.cz, akpm@linux-foundation.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org, axboe@kernel.dk, 
	trond.myklebust@hammerspace.com, tz2294@columbia.edu, jaegeuk@kernel.org, 
	chao@kernel.org, qiwenjie@xiaomi.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E417040002
X-Stat-Signature: wwmzyu8c7h8836rbo6bzw411j9k8dpj4
X-HE-Tag: 1788078931-152076
X-HE-Meta: U2FsdGVkX1/k0sZvrxA6kBBCetl4fuooUeYyf385ZAbzowP3cgWEkQcXILamN/N+sv9JwMlGTspYAVRHWcexhti7w5+UazP8y4OTN7/JaLoedKFfoXGLVDdmqTgSOZTf4DZj3XhA2SDAKVUNq0bbqB8DVpS/fBFnT/nEEv8DtRqN5EhJHPp9MgiTmX/rdT08UaDfVZAfKfWkw7hfoTpnA7HRMP3ntMFccWQ16A8ld2siTKI60CiQM0b6mrynb1Be56Z1xEUiiygTMw+fKZEWHoRS7rtU6zjYlXPvU/a5tDkdzGM/YwZjWNStm2fPS8PCogTPHMgzpJLj1MI9aB9nfTogcLiX+Ge0CTXZDzbePYVRQsZtnhI0n7KY+hzsbuAq6cUvfN0+QOxuAKjm4pHa5/5Um8wG6dlhKSlwrxxGo7AnfNnvjmev9xumUT02QdmZmjuYetXMTe7OkhTynCX0k2puMXzUDkiBuKa1RTEMTzebsj6GgJjdmWMmJ/Yi9RloDgjBX80QhKtmzIg54aFUZx3KyudGb64WazcLx13i2GX1Pa/eCh+MVqrnHCC2DTR97WwQoSkJ2t3abN9en+5KjJhvMze7FV+FjpxH8+Cuccq3YyU3KVBHkTlV2Md5gblg7R2MyB+MaWlt3BnQj5m6StNqj8zaMMJsXsOZbtZmeXDTTwr1ub0CrLZR+TJaj7VMoiaeulT7yaz1yddvFoFNAf3WNaHzQ2ItmOYwSbuux6/mPLF9I3mKLnbDZqZitUFqTbwJiGlMTmVR4CTSUGrPaptzkpodvWTE5ZYi8Rah4DQPJvavbylw7Yq2Luwn4/w0mURUWsrYo0sKO+BAXLkM/UVz5ogrn+A3J3k2gAGemScE+86VLtLsXvwQP1k7iwGGZUhCeP0A9v51CGBaZ/qL+DXFCMDm2zzoJgQchybE/jqAR87wgoxR7Jr7PV7G4d1gSIOntEzzGnezfhnxGzG
 p2wc5cFd
 6AiymlJG+pmOnBM8Ca11Sfu+ZHVR4VQXmROs26ho+82bR/OZNcDS39qnxy/itn6Tfq2k04aZ200xU93RZud4aJJah03Wy3FwqWEkUbagj/t/GObvNyxq4fEb89XlK1ZFanJpmNr+X5TXoLYJHYUNIFGu0D3lz2Xepki1GF/oAYNvHtmd5pL1AbkEZgwqA4WmXIRQoI9DO0AHuDcCl7TG4+4YooYaVRRWTrNzsMiWIKJJy0IRFQMInzhYdf/vsWq0RjO9LCfUcbFze4fg+C6f7iAFKhNbJhgRmIcq+EDaCVq2a9xcxPcDYOJ7xJrSbCkRj6r4O8OupVbIjip0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 30, 2026 at 11:25=E2=80=AFAM Wenjie Qi <qwjhust@gmail.com> wrot=
e:
>
> From: Wenjie Qi <qiwenjie@xiaomi.com>
>
> Fault-around can map ready dropbehind folios without going through the
> normal page-cache lookup that clears dropbehind. A mapping represents a
> competing cached user, but writeback completion can currently unmap that
> folio. A later mmap access must then fault it back in.

Andrew is asking for a visible user-facing impact. I think the current
mainline code might result in an extra fault-in and extra I/O. Maybe we
should highlight this?
On the other hand, my gut feeling is that this patch might only be
50% right, rather than 100% right.
Fault-around might just end up mapping data that will never be accessed
at all (fault-around mappings aren't really fault-mapped), while the user
has explicitly requested "dropbehind", which seems like a strong hint
that they don't need it :-)

>
> Retain mapped folios instead. For a mapped folio,
> folio_unmap_invalidate() can call unmap_mapping_folio(), which takes
> i_mmap_rwsem and may sleep. Retaining the folio also avoids this path whe=
n
> folio_end_dropbehind() runs in non-preemptible task context.
>

I'm not quite sure this can be entirely avoided. Somehow,
`folio_launder(mapping, folio)` could also be nasty. For example, NFS
can still be problematic today:

static int nfs_launder_folio(struct folio *folio)
{
        struct inode *inode =3D folio->mapping->host;
        int ret;

        dfprintk(PAGECACHE, "NFS: launder_folio(%llu, %llu)\n",
                inode->i_ino, folio_pos(folio));

        folio_wait_private_2(folio); /* [DEPRECATED] */
        ret =3D nfs_wb_folio(inode, folio);
        trace_nfs_launder_folio_done(inode, folio_pos(folio),
                        folio_size(folio), ret);
        return ret;
}

Best Regards
Barry

