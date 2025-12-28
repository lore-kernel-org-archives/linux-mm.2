Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56368E784BE
	for <linux-mm@archiver.kernel.org>; Sun, 28 Dec 2025 04:30:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14F956B0005; Sat, 27 Dec 2025 23:30:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FD7C6B0089; Sat, 27 Dec 2025 23:30:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0097A6B008A; Sat, 27 Dec 2025 23:30:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E4CC86B0005
	for <linux-mm@kvack.org>; Sat, 27 Dec 2025 23:30:03 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E791F140C89
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 04:30:02 +0000 (UTC)
X-FDA: 84267602244.22.22C635A
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4E9B3140007
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 04:30:01 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=obfBILue;
	spf=none (imf23.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766896201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=guYBHUk/ndUNWh1unmJUqc4oNCVqRI+bMw9D/2jhg0I=;
	b=oqvL8jJozcqho5uBvHDFFp5o+EzgZOIjXg/W8voWMomTmM/4OBwai7susdnKI9MKY3yn5v
	1doANVti+LNz6xo/IdFrvqC+5NgVH3SQGz4lH2g7nHl8hCLz4R2BCCSK7yafRrVJ68RZD7
	ZNLNhVheNpgbsqdhyd+ATEzWEcLYw3I=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=obfBILue;
	spf=none (imf23.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766896201; a=rsa-sha256;
	cv=none;
	b=zjc7gXeAxXXogVgtVpDBBrSeEYk03JJjiwH+IRlBYRbRSQrMcjBVEIWgCoACGn6PNOng+Y
	5WO+HMoCAsHtpQT/6z4UvwxahuMG7QfiXYqLymDYWdCkytIlthZYgvWCjFWZaXwYfj43f0
	le9agdW7cJKreyziPHX1uEGMUprV2PI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=guYBHUk/ndUNWh1unmJUqc4oNCVqRI+bMw9D/2jhg0I=; b=obfBILuenXzX3+gnVzwNfLnTav
	tXVWryAsSLp9oLJQtxRCpaYetM/bEEAPaNmKc4x7ms/f9rgcX6xEU9kd2KlKB2OdlhjMjODpRf/Ye
	h3wzr3lOmNTSBt5Nazqs4OXcNARVMO2G1tio7MraN5un6UQ2cihzu4eXGMH5KiTc/wi+WK0qIsuZa
	YWPkjSaIpivUavbqzcOQ+Bn9YnsJt9X+ImIN1i/h44FR26hIc0nSuQ4mdoMVg26amf92TBoL8/MeU
	W+yuh9rkobZsdcEbJP/KhY15HV6UxEuBXFKhD5kd/GFZfoJNadWoo3W8OXSh+ZgipO5PyUA0rxH4+
	b8TDRCuw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vZiPk-00000000SDO-25lI;
	Sun, 28 Dec 2025 04:29:56 +0000
Date: Sun, 28 Dec 2025 04:29:56 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Barry Song <21cnbao@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	syzbot+178fff6149127421c2cc@syzkaller.appspotmail.com
Subject: Re: [PATCH] mm/shmem: fix uninitialized folio in shmem_symlink
Message-ID: <aVCyRNQ37oGVu4Lj@casper.infradead.org>
References: <20251224094027.65842-1-21cnbao@gmail.com>
 <aUwcV2HhtdiXXxfJ@casper.infradead.org>
 <CAGsJ_4whKLWiw6LNexFPHTFWB1QbSrAwrBtspuc=c8fM2=WnvQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4whKLWiw6LNexFPHTFWB1QbSrAwrBtspuc=c8fM2=WnvQ@mail.gmail.com>
X-Rspamd-Server: rspam02
X-Stat-Signature: mn3rxkbq9746ia9ebjje5r1ewx3ee5nq
X-Rspam-User: 
X-Rspamd-Queue-Id: 4E9B3140007
X-HE-Tag: 1766896201-374935
X-HE-Meta: U2FsdGVkX1+mhRTcdQHdGHT+Kc+b4yHMIEtrjYaJRRvzk+yPvTRa8yJY+ELqyYYJpb9rFKGAwug7Lk9HmtNM8y9ZdJvosqt7A09dsaJ2bjp/Ww5FQUmEkQ5ss3JgRdvwC3HoJsV6jj5ke1OqhJ4p4eEByB9JSB7irMfR7TMeroNIOoKayOxNPxJ1krWFyEjfbqyu2wmIH0xIP+9etkdj2LteBu2CbBi76ZdbvFr8bLkRt7xpOSTIHY7JJDwsUApt26csI2O6bngsd7RJ9hTlhUmp9eo3MNF0wq5g1LQkFlxD1erhkn4ITY4uvCL/QqORJGgTFhMBCwU5joxLulwXP8zfV1YCnld1wmJ1AblaOBdHeoFC205o8l9jc1A9UoP3m7PizHJozLe+4+hFrhMWOHqz2w6D2PsD72JEZdQY+FCcjkjhpQ8r6ncCUm+TTTu0nj49Au9f42qN4kMM6BeR/FH5GGs1uqAb0DGjkhdZyXIjdBleG06iayySRvZUOMpwZaPbCwPgp9CmpvHSD2wev/E6kWXGNEMYpkIp/0HPGwRh14chkn3saLFXiLGnsecQTy4QY01taf4UedigejuLkBHB8aX22VG6D9UkYrpYyr//I4+g9kryXnyFoQcLPEG8da//bmeHYc3AoTfMnz/VB0tKpUAo16SSFebsq/gC1WpE3AG72OKSqIN+xtxFEuR0ghET4N905EhB9eHarXI1HcFm1PWU7CFHZfMMqj4r9tjjxQgLiDafxcMgn8QWxkUjMyppCzdQeGLS3O1HfY+pM1Mv2EG8bGwCq2TjSn88bRunZ97rYvwxABYhTbsSw6bDDi4zLNZpK2yKcmjEoyL7CHvvloLjcQPT23UXSxPImQPo3cxqO418gbs7cd3Ge2Su2gwWogZdIxBGEZg5whr33Dkc+tM236f8zvZpf6v28ohfkXYkBcc+C5LB0MjOu4D+rJV4KJ7xzHfBxTtJnnZ
 EZBh8vPd
 8Amb7DZcsr1RGmy6iAIq9T9JJP8DIhx7OEleJoKccdHr6DOirI4dICd40t4FaTeIUQv273wEv64oZuIa0AZlTt4e8xNF/Z/L9ryg1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 25, 2025 at 05:04:38PM +1300, Barry Song wrote:
> On Thu, Dec 25, 2025 at 6:01 AM Matthew Wilcox <willy@infradead.org> wrote:
> >
> > On Wed, Dec 24, 2025 at 10:40:27PM +1300, Barry Song wrote:
> > > From: Barry Song <baohua@kernel.org>
> > >
> > > Uninitialized folio allocated in shmem_symlink() may be accessed
> > > during swap-out, causing KMSAN BUG:
> >
> > This would be an unfortunate way to fix it.  The vast majority of
> > symlinks are short, and we'll never access past the \0 in normal
> > operation, so we'll be dirtying a lot of cachelines essentially to (1)
> > shut up an automated tool and (2) optimise a corner case.
> >
> > How about this instead which delays zeroing to swapout?
> 
> Matthew, thank you very much for your review, even during Christmas.
> I would like to wish you a happy holiday!

Heh, thanks.  My mailserver is actually in a different timezone from me,
so it was still the 24th when I sent it ;-)

> I am not quite sure, as shm symlinks do not seem very common. Since
> allocating a folio requires a symname longer than 128 bytes (where
> 128 == SHORT_SYMLINK_LEN), such cases appear even rarer.

Fair enough.  I hadn't noticed the SHORT_SYMLINK_LEN case when I
wrote this.  That does change things somewhat, but still for a 160 byte
symlink, we have 5 cachelines of data and 59 cachelines of zeroes.

> BTW, do we need to migrate the owner_2 flag in folio_migrate_flags()?
> If so, I am not quite sure it is worth changing the hotpath to
> accommodate this.

It already happens, it's just camouflaged.  owner_2 is the same bit as
mappedtodisk.


