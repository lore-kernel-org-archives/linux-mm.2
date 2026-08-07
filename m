Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B16FEC5ACAB
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 21:43:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A76DD6B009B; Fri,  7 Aug 2026 17:43:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A00866B009E; Fri,  7 Aug 2026 17:43:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EEF26B00A4; Fri,  7 Aug 2026 17:43:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6424A6B009B
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 17:43:01 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E64F8A12F9
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:43:00 +0000 (UTC)
X-FDA: 85075798920.06.42C8C85
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0818D40004
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:42:58 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="wP//6lGK";
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786138979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V5Weo6gzWFeGsLCsHrlTVQmPSXk+S4ozjr38z5Dj6Us=;
	b=BbZY0rIWBTzS4AKnhb20s1dmzUrqGECDfAxofcw7AA3k0xVJTu5y9PPIZWV85K2PzRBLVz
	K/Wn33DHpO7Fx9TuzFaaqm5xr95PhM6rsceDup6meFKDD60RnjgGQe8oZ0/lu5NSGaMqu7
	FXUBYhLsi5PK5kbQC25GaErdUsHTM4I=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="wP//6lGK";
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786138979;
	b=DbYKWfcdniLprIweKXirzpEbDX8i5ATIur/ZqSexBj43hgIVEW1Nx5ima8UQ4feSCPOJK6
	Fytc0F/IswHFddfPXW4gAWmc3rmZMm9nbTe9QBlP4VdDNR41Z6syudr3bzsFDgyNAMyYYY
	wkFbuwjZAgJE1M5Xv4ciF/ruhrZtyG0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DD6A26001A;
	Fri,  7 Aug 2026 21:42:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E1CA1F000E9;
	Fri,  7 Aug 2026 21:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786138977;
	bh=V5Weo6gzWFeGsLCsHrlTVQmPSXk+S4ozjr38z5Dj6Us=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=wP//6lGKsVrokbJLjPmhaKcE7zZRoPqmDXQXP1gb6YhD5KjbQHNQOPEXJWY9zYucb
	 Tg5GDWocjRIPdCaFvIh2uiE8WnSYPq2xQhsVXjl543kl2dwdeoSaba1xeAN9Dd0ABp
	 RQjqdM6wgd5EsHD5fvHWB7j7yA3mpGqYq/jTznyw=
Date: Fri, 7 Aug 2026 14:42:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Baoquan He <baoquan.he@linux.dev>
Cc: Youngjun Park <youngjun.park@lge.com>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>,
 her0gyugyu@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/2] mm/swap: skip empty clusters in the swapoff scan
Message-Id: <20260807144256.6fbdfd15f7ed4f518af7929f@linux-foundation.org>
In-Reply-To: <anWabobwPyAXvRe5@MiWiFi-R3L-srv>
References: <20260806193228.458685-1-youngjun.park@lge.com>
	<20260806130655.420e16bf621b580cc5f08040@linux-foundation.org>
	<anV+EoxWGKdU9da0@yjaykim-PowerEdge-T330>
	<anWabobwPyAXvRe5@MiWiFi-R3L-srv>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0818D40004
X-Stat-Signature: k9ms7in4yipaitk7z5hnwdf7x6nou5kg
X-Rspam-User: 
X-HE-Tag: 1786138978-149363
X-HE-Meta: U2FsdGVkX1+CMNc55xmOIk3kLv9Ms4BisKLRlZxWAoPWLcPqoHFyRiqIEcPgwAzliF7ETUxKSlvbP67hToO9jYQ7vuvw4B0n7DAnXx4nbhTUo9tseQU+gou6n8spIyuXuw39s5SANaaUHjYvOIZ9QsSM7vptlpVe0CyM9AtVfz2Vc1iRpxtFhkLTYv+CefYIc9rc1c/FRDjYb6ptf47w3vjKfn0Dy2hJ2UkBLoARrcViG9ldHu1cnuZXaXafzLFSXYexqGdz+atW+0ibb19Fq7Xuu3zM99H8t8HMstLxBKp3isJF5Itpnfkjh9xEEzpZy2j1ltEsZLLzTqeunJwYnGNyztEIMC46ouYWg2rt2oZPsW0rPjadGKS588OB9siss6O3dVvsrca+QujbXAVgl5WmCAdncd1/T/hiIntrgF1i0Pss0iHVA77spZkpsXMJjTRP32FUcUGEllndcZnBKVAMpYjw4WHDu6vd4ZNs5b9OlR65C5STdDfnc2c5xlbW8Po2k/LAbjNnOLJnOh3h3RUPt3NaQ71X6kepJIw9iIcgW6LjXtbKaWnygO0I6DN8R4/ZY6MwpcBty8AuMsKFhP42Gl9pV2jUoydtLzgwPvY4ka2Ov45F8z9Aqc1vliLv4IZt3OTDX0jXfqN35uSwfZKlHJBFclbgHwjPOw5uKadiEK+OSkiudvsS4EiJipEJunPCXfKiwCQp3kWYoMVP2wWlUMWeh/eagdOn8mSIYkEf8xxlWNa0trR2V2WzZoUjtiPHacuFCHeueu0Gje5EjtiD2GGKufQmYRdtBhiPzdbX5b3Gn+xJVOm/oSndkYCerOPRrzBHIsd3X10pt2esIQZHZXx18rjhz6nFtBpHM6fQJK+ETd+hcMnI6NVw09Q5X94wDJdsg7hXG8AIphoc+p3S3IIpkySYUgG7epAoO5O5vrSsSkFkqGsgUZFNSOFwLq4Z5VDP/XWNbdzJbo3
 6BBpw3Tk
 eJzEe3FL+fTmAKx5QtyVMEHicp/N8O5YclUOYv2kprswn2UYqXFL/htgPIO04Cdd7h9Nnd2f9o9dmo3V6pAEr6SntJG49KJspdFJEyPiL5vE1oKQGVveO9/QXVirTiTeAkI+CUORAZ6T6sqBhyd8wKK96iXKW457AU0aGxJDoZy4+jb8Fm5zWSuA+uxRMmkgnzk+OIP1ukkVOHlPA8EBq2mO+LVhlR6hxh7HpmSIKhBsao1gFVhCvHGnEjQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 7 Aug 2026 16:42:22 +0800 Baoquan He <baoquan.he@linux.dev> wrote:

> > I have no measured times yet, since that case has to be set up on purpose.
> > What I did is the arithmetic for the case that skips best,
> > For example 1T of swap with 256M slots with SWAPFILE_CLUSTER = 512
> > and everything free but the far end:
> > 
> >   - today:          256M table reads
> >   - with the skip:  512K counter reads
> 
> 
> Maybe just use time to measure swapoff time consuming, just like below
> as I did on a kvm guest, I guess a bare metal machine with larger system
> ram could be more obvious?
> 
> root@fedora:~# free -h
>                total        used        free      shared  buff/cache   available
> Mem:           3.8Gi       181Mi       3.6Gi       924Ki        72Mi       3.7Gi
> Swap:          2.0Gi        18Mi       2.0Gi
> root@fedora:~# time swapoff /dev/vdb
> 
> real	0m0.101s
> user	0m0.001s
> sys	0m0.017s
> root@fedora:~# swapon /dev/vdb
> root@fedora:~# time swapoff /dev/vdb
> 
> real	0m0.014s
> user	0m0.003s
> sys	0m0.001s
> 
> Not sure if Andrew is asking for this.

I think it's helpful to include such info.  The audience for changelogs
is more than swap developers!  It's also an MM maintainer and -stable
maintainers and other people who are all wondering "should I backport
this for my users".  Let's give them the means to determine that.

