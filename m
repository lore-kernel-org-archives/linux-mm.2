Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E124ECD6E79
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 22:47:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA6FD6B0005; Mon,  8 Jun 2026 18:47:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C58616B0088; Mon,  8 Jun 2026 18:47:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6DC96B008A; Mon,  8 Jun 2026 18:47:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A65736B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 18:47:39 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 38BDC1402D3
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 22:47:39 +0000 (UTC)
X-FDA: 84858233838.30.6F86001
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7468A20006
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 22:47:37 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=yx6LohOh;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780958857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xfqYHZdSV2g90vjfkntECdqiOvsjE2JnYKQaDnDRVtw=;
	b=LkjeV4bU/RYuzHu8RIJSJBHGce08GC9u6JwCOBNvwPHQM3P8KRq2y3028vozzHC2ENSX71
	bvj+dixkJp1ohglml/HQ42EulqCdhvSTMqQI1A5KHiBt4GBnFrsTOKuuw1LbogEApA5Vwx
	j3NtzDR6cDIwIh7nv0L9CyBHWbz7M7c=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=yx6LohOh;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780958857;
	b=JzkarEFEysCRT8CEshB+Bozq1CaA98jcbTCS/vlMj8l0mZtRXhb6EBIPwt9fqHh0axCZHy
	GrmOZ61TAbyfKmqQ6T7DaW/Foiws6uFA5D8ewlz+MiPryvSKKJCzATM7U/fcoTJL6ANSCR
	ZAJ+uL1h25EQumsY13p8JbE/540oFIw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 551DF43B29;
	Mon,  8 Jun 2026 22:47:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 323561F00893;
	Mon,  8 Jun 2026 22:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780958856;
	bh=xfqYHZdSV2g90vjfkntECdqiOvsjE2JnYKQaDnDRVtw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=yx6LohOhCyzEQ9653HoE7Z+miQUqXDnJbsgKOqJCXzNIFYt8Rk57lhYj1v38uLn9K
	 +pMfiJcfnbg+LH8uWJC2LwPnfksKDZGFhcidi6wXi4ZBkqigdWwcjV98EHeklXI6Q6
	 +p/0WSu81awGKaS0GOme2nhoO9VlyuekGLJ6R3L8=
Date: Mon, 8 Jun 2026 15:47:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Gladyshev Ilya" <ilya.gladyshev@linux.dev>
Cc: ivgorbunov@me.com, Liam.Howlett@oracle.com, apopple@nvidia.com,
 artem.kuzin@huawei.com, baolin.wang@linux.alibaba.com, david@kernel.org,
 foxido@foxido.dev, harry.yoo@oracle.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, lorenzo.stoakes@oracle.com, mhocko@suse.com,
 muchun.song@linux.dev, rppt@kernel.org, surenb@google.com,
 torvalds@linuxfoundation.org, vbabka@suse.cz, willy@infradead.org,
 yuzhao@google.com, ziy@nvidia.com, pfalcato@suse.de, kirill@shutemov.name
Subject: Re: [PATCH v4 0/2] mm: improve folio refcount scalability
Message-Id: <20260608154734.8e4115fde4e2e14a3b6892fb@linux-foundation.org>
In-Reply-To: <df26082871b4c65b2bd38d409026237c08572836@linux.dev>
References: <df26082871b4c65b2bd38d409026237c08572836@linux.dev>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 7ok46wgmrfhkgsxei78utf9zytwi1o5h
X-Rspamd-Queue-Id: 7468A20006
X-HE-Tag: 1780958857-337811
X-HE-Meta: U2FsdGVkX19HraLP0Gzkejz1Ftb6E9iaFvceZm1iCk99M7EmRy1PVDpvqbHNpFxOQxoNR6o6lB2aKWlhMYclj29PKIR9hZW4il8NcD/q0KmkXVaG6OOdpB+IXQWKtiiW7hMIA0M7Cg/Tdk2/fRIy6Rq7Co7g6p6veN/4GSbevBXY4vdsUtDO/iVTMDSmj7Fus1cz3f1zgx+ZTEdgcNtWWI2ejBIRZa658ypXXYmBymbHpZwv594VUpb1q80LTBk1smDJ2FxLP6kIRgZ+bqVAjRIzA44/espUh1g/fLuZEpX6nsji/RDskI6t/HQrQL0bVIcfhU1BwM+g/cEmZTd6SLS0+0Ij/zjOXQrakVhc1Fr53NGJmMma/H/v3u0Le6XlCKRX9T0A8xreSmShhr/meX0Wx2cnu1IBzyRwTXDk0w3e7GCCc3iYsjSykboOs2R+yJ6s8ccAdquA+BWAfRF5OqA8TEyj3cCW80JiJtD3svGxgt3hK3zS4KQFvw9WQpICH6rm5wm+Gcn0FedpMawiix8J9jQRNJr7VoqY7RDi0vBF59F313f9tQbML1ep2ZPA4hJHPeSVQymGLakkIfEC8xsB0URJDMKistZYXpv9uIqGl6e7gnaqHajXPaAxOhUHrs8DswLTCzrG98CDBufdBjUOUhLrdbUlxYfzZ1U3p6DFPk7fQd74aACIy09eu8dU+ZBrieJSHXyKMb/m4ynsf4pbLkC7wDRTJ1wIdP+BAzsuom7QHYriEuv1QSLnWrq1yZw7ueo1KuNzExk8gcPPYPo0mvP2AYlwJU0fGRtL+yFOoe6/sUPSbUYOArUmurzsrnmo31HK4c2VLtM9RoyDU9u7MGpeqUkNbkzWAnNmz/wrYGbt8NHKJoxiW3UIPBlUFfHeMqmOns4YPI8MpcTbbQwnS9eKu3I8V+bsPvU0BKliEPVy3WRBSSoCu9ZoYgvnL8doZaizfD47D8LvOjQ
 rKrDIivP
 vJDIQ8KlmiqzhFTpFtKgqrLJK7PYG5fs/V19ciY8IOVicYrb+RNubkcKmDw6aXuaPmiFMssnNViuEc6kVTXIKdBR2FrNVcb+9mRDt5vPCDoVYwjIrKBz31eb10kA+Lnnhxm0fjqGV04HSfc8+X960H1F1szcr+3ho473uY5DnAzZYiLcggXWPk6EVgVmprn0lFLmw06VCOizRnrLxs4zY8QQwuYo150qy+v0i2lfpGwm64lVkfIBSgkDwpZ4YdCuV2DrU0Ax5BSHUZCOGN7ClMFnjlhQP+oyLbPqLHAdWS+DseMFza7tbW3jgfw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 08 Jun 2026 21:53:01 +0000 "Gladyshev Ilya" <ilya.gladyshev@linux.dev> wrote:

> This patch optimizes small file read performance and overall folio refcount
> scalability by refactoring page_ref_add_unless [core of folio_try_get].
> This is alternative approach to previous attempts to fix small read
> performance by avoiding refcount bumps [1][2].

Thanks.  Nice numbers.

AI review had some things to say:
	https://sashiko.dev/#/patchset/df26082871b4c65b2bd38d409026237c08572836@linux.dev

I'm not sure we want all those new VM_BUG_ON_PAGE() calls in the long
term.  They look like development-time assistance.  Perhaps you could
make those a standalone patch at tail-of-series so we can keep it in
linux-next for a couple of months then throw it away before any
upstreaming?

