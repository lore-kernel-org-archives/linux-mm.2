Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCF4ECCD193
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 19:59:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE1998E0028; Wed, 15 Oct 2025 15:59:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB95D8E0005; Wed, 15 Oct 2025 15:59:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF5FE8E0028; Wed, 15 Oct 2025 15:59:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9E6698E0005
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 15:59:14 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 13A2F56EDA
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 19:59:14 +0000 (UTC)
X-FDA: 84001412628.24.AD9C5D2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8B3881C000F
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 19:59:12 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Qjt3Df5d;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760558352; a=rsa-sha256;
	cv=none;
	b=ZSJzv7Q9zLSIE+MuLvc+F6iD57Xu9NzXuYaq6RrvAHjJnJBFqPu4ffiVFsURauCNw3AM9e
	zdbwKvltqmnbKOALKMXQ0kJ+VWc9Ezl8hvfW2LsG2d5fdAKzvMEDUPybbZ/ZXDZ+U1XAgN
	M2wOmzdoUWKut5PqB+rPf0muoPSb02Q=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Qjt3Df5d;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760558352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xxihovUvtVnPUMPdBc1/WdgS+CUXbdBYGXJaZYLt/+c=;
	b=n/VTwViCnkCWDFHVKvSy/tu3mQmfbuGfgwMx6r9KG9OpdapiOx8b8+wfsKRSD0dyAfXmOT
	M9E/xZMKgK94nGRre/cTiWcWEiaEBU8iKlSTBTVy3C7OVnhpOS2eIHbrA3WB30g4SAjnhk
	+bcm+o+UVOE4Ob1FWDDZirFSYJpy5fw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C02E162724;
	Wed, 15 Oct 2025 19:59:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A919CC4CEF8;
	Wed, 15 Oct 2025 19:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760558351;
	bh=qWmg0NtlX9VEzTpgvqIlBglFj3zmXkbFtSVVHicvZOg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Qjt3Df5dghFnppzxr1Z54A55GDwmn1BhOWImmYBXkhS00UI0huJ55xgj1k80c9ZCu
	 /mjbrq+At/yTHDeZQp+bSHvshZA9aoGwJ7X+0tUTXv4FG+GvMM8z1DDKrH9VY42TnN
	 9iHcaDGvEo4uwo2agKjlBrNA6kO1bIAE399RxTyg=
Date: Wed, 15 Oct 2025 12:59:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, Kemeng Shi
 <shikemeng@huaweicloud.com>, Kairui Song <kasong@tencent.com>, Nhat Pham
 <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song
 <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, Axel Rasmussen
 <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu
 <weixugc@google.com>, Kiryl Shutsemau <kas@kernel.org>, Usama Arif
 <usamaarif642@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 kernel-team@meta.com, hughd@google.com, yangge1116@126.com,
 david@redhat.com
Subject: Re: [PATCH v2] mm: skip folio_activate() for mlocked folios
Message-Id: <20251015125911.0f0ebf87b278324667c4dfc5@linux-foundation.org>
In-Reply-To: <aOaoD0HQk7YPeLkE@shell.ilvokhin.com>
References: <aOPDRmk2Zd20qxfk@shell.ilvokhin.com>
	<ltvv3v4vibvlglpch6urayotenavpzxc7klbcyowjb4wrv3e7z@pzovtvtbmnsp>
	<aOaoD0HQk7YPeLkE@shell.ilvokhin.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: btb4dhzen6gynqycoyqgg11mtp3cntim
X-Rspamd-Queue-Id: 8B3881C000F
X-Rspamd-Server: rspam09
X-HE-Tag: 1760558352-886639
X-HE-Meta: U2FsdGVkX1/rCA6y3Yi2Pvv8L0EuvvJwg/ZkvMeAdbGX1+OVYjsu71sOgK10e3mzHwRt2KQ0LwJyFWQmCp0zxFHrp+4PS9uCBwaPXPN01kjCY5jZjbzJ5nn3ob2UGOXaBETC2o6UeBmQ5OjRMKuCjxqaNKGbahvqp5APScZ7NSqWAohuh2ofHLrQnoV03zL/n2N6H4rSZAHwLXtX1vY7YcFHoehU+yl5s+QVZuHsOKkNA3o9pVHE9uaeL87Cene4NgeDXTJmFNgxBMAhsJDJZyBAQdLwsXW2evx63ex0zm61Y/5E3RHgTSfUwvl8lfvD7XAZud1MJEN/tIZYF1PdxNKpdCj8QC6rDcW3Fn7ztHPJqgVbp+XA/y0p0RBpdbpp2U23WZCKxebwemQJmgio/CMrT6mbfpov1xbjR8naD6SHJNRJ0Owc1LJ+ao/GoitXBY13R2weHcwMDQj38/PR7ujDKvaSB9Drepz5xa64kjDEqoFvxKr+VzsPRGEGpQcf5WbEWZJ/du/rYQt1Mkmluo4fkH1EkUVPP0nzabGfbEE1MZDY8ESHYi5v2ZAZxL7rktTIsnhPEWIsSDc5A8YIMDJfzY8OHMEkdoeXC54/n2pDxmdY7ft3AzWs/cXZfq5DIoS/rl1zvBP/k5p/HO4sj7WZFiTu7223BocVgfO5RmhNYVAZWbK4CTToQtFk1wHRn99BhdG5Ea4lK9Acp3hLmQayqON2BgVJ5gUzCLwf/it1APoccYeuWpzt4iyqwNx8PuGHVb9Sr0gxycw5I0wutamG/f37/+XLx4oR+V767hEAEnVScQIz4qNQciyDlyWXvG/D1suo6HsZChl1EzCug4J5+sYEpA0I6X3OlqxMulRyjoZIqi1ApEnTGu+7iYYWbw3yPGals+X7IVyvfNmo7betFbcjljI2g+8ugFDfoMUkg3jnTmxRiHR2vDGb+O2yHVyyWXouiK6ZZnOmwwL
 OBTpBGza
 UqrP7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 8 Oct 2025 18:06:07 +0000 Dmitry Ilvokhin <d@ilvokhin.com> wrote:

> > > +		 * They might be still in mlock_fbatch waiting to be processed
> > > +		 * and activating it here might interfere with
> > > +		 * mlock_folio_batch(). __mlock_folio() will fail
> > > +		 * folio_test_clear_lru() check and give up. It happens because
> > > +		 * __folio_batch_add_and_move() clears LRU flag, when adding
> > > +		 * folio to activate batch.
> > > +		 */
> > 
> > This makes sense as activating an mlocked folio should be a noop but I
> > am wondering why we are seeing this now. By this, I mean mlock()ed
> > memory being delayed to get to unevictable LRU. Also I remember Hugh
> > recently [1] removed the difference betwen mlock percpu cache and other
> > percpu caches of clearing LRU bit on entry. Does you repro work even
> > with Hugh's changes or without it?
> >
> 
> Thanks Shakeel for mentioning Hugh's patch, I was not aware of it.
> Indeed, I could not reproduce problem on top of Hugh's patch anymore,
> which totally make sense, because folio_test_clear_lru() is gone from
> __folio_batch_add_and_move().
> 
> Now I wonder does folio_test_mlocked() check still make sense in the
> current codebase?
> 
> > [1] https://lore.kernel.org/all/05905d7b-ed14-68b1-79d8-bdec30367eba@google.com/

So I take it that this patch ("mm: skip folio_activate() for mlocked
folios") is no longer needed?

