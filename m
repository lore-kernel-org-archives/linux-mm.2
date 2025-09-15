Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22AC5CAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 18:44:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F8B68E000E; Mon, 15 Sep 2025 14:44:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AACF8E0001; Mon, 15 Sep 2025 14:44:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 677168E000E; Mon, 15 Sep 2025 14:44:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 51D918E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 14:44:08 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0CD831A0567
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 18:44:08 +0000 (UTC)
X-FDA: 83892359376.05.A17E762
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 75CEF40004
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 18:44:06 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jVXNFqMF;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757961846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=niUI2wHGioGvp26wKDZswnjVQz3NvdQVBKQHeE+u3Qg=;
	b=1AG7pj+zrUKTfSvFPkmm/RD7zbTMnpY2t2CTodU1tqWbGrC/kIZPQXBaI7u9lmEYd3c7lj
	jEcpBPJ/c8dcXsCXLbJbdfiRmdCUN3lLxEE4we/3g16aNskosxUVr8ssscJJKI5FgwfDzQ
	0T0aKANoKAY0vD4ZEEj4RJaIr5im760=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757961846; a=rsa-sha256;
	cv=none;
	b=cQ8eIBHxUIGOn0xJM1u2jecTofCoxdVwObAM+oIHHpvYw2d069hujyYoGpwFI+NtsJwHQi
	/3AaAd/P3pcwglXAeyYVNB9jWC5qeG1rvqdTbrSTX2sj4cP08zLwZRzEibedSwfdiou8fA
	KkIvqgdJfcZVEIxsQHK+//5GnmutD28=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jVXNFqMF;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B093560243;
	Mon, 15 Sep 2025 18:44:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38AAFC4CEF1;
	Mon, 15 Sep 2025 18:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757961845;
	bh=5eM7L2bJi+aIvVJOlm9jGV5Bxc2GCKc2GP0RXo1z1Jg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jVXNFqMFCL2JfcNzfC2tFW0Bo8l5oT6Hep0aT7epPj5WMJQ9pc5s1nAx2sPWTU5MB
	 SQQhBtqrssxO2kWPjuMxdcFu7xDvcA29w5ew3P8MjWv8HoocE0RV0AK2eZp+V2tatT
	 CV2kQ3dUEpSHleg+X7ElNxJhx+u2Bhu7jVo23JufaSwESwaPyhzxWcmFqw33KghvM4
	 dTbYrOhTEzrHNC9z33EUkRxFuvyTQJiIAHK5gw0SEy70JbmMbV16DNGtRrT+0WXkzJ
	 v2wg7l64wFDid4SWurxcD9ka3iS84jdaXKhg3ukxqrcloBKQbGzoe2cJn3BOKClFUz
	 KGwGYby9BtaNg==
From: SeongJae Park <sj@kernel.org>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	David Hildenbrand <david@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 4/6] Docs/mm/damon/maintainer-profile: update community meetup for reservation requirements
Date: Mon, 15 Sep 2025 11:44:02 -0700
Message-Id: <20250915184402.110517-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250915150702.1499965-1-joshua.hahnjy@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: gn3axbzzd1aqmztqrteztxiye3sau36x
X-Rspamd-Queue-Id: 75CEF40004
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757961846-752839
X-HE-Meta: U2FsdGVkX1+uVHquJOEtQd109nxDwOtz5se9Lh+DWr4+w7vJ4G4ALSqDL+olpobx6Js78/uZRIYxHGNMMQT4ylY1fmsn/yHUnE2LAgqWULHahY0/XZ4nbsZ4IQqYWufr58zet0zZKwpuLeyFUGFCg5d/Ol1/AweIp3Vz84ROcrSwyLaoWQHYMM1X1+EV8IGSYRazKJpw2yZm4yz8SDacEmdCaZzdpiYNdlFMvV5lnGxXF5H3UnLQbrETb75J4PJL7qqpxkSzrK4G/k8ZjWR0T7JlPG5krM1+oGsSYHyQJrzNY44pNaPaIgFZBnNGezOEwOdtXgscBI/Xk4ZGmTiwASgVLX66Z8ZewrNHAXjCtixfM9snQM05TrFSH5SHBhENtdostBcUYhpmLrwZGG2zqtRApGc9hXO6gvvrkCZqbpH9qE2pI8ru388SAxDUKNS5RndmwOrPPAzKvKOqhwLrO5SeDg0pOUuojvleuseaFwJvAL5JH5o1dIpUV7ZWt/4oV5xG38tm07ZeUfY2nvMTiHIbgO3p5lLngyJxOqV1I/UYsLIVTcvcqDJrm56vU0cFO0EOBGU/PZR/t0vxinZicwnellAl4Vq0A7aZwnWUYcyLl0UF9W8REeN5twPHo/BRVvwJtj4Y9tea8IPWx7HxC+/swaufQnU12KlXdPqR0bJQ3RkUEWF3vpewecBjpRjMvxrd+Hi3tBy7SmxRqGtxpH4V4qW4dXavntYrdSrfTUHaCIO+Uej5LAslP9RemdA9TV37GeXwgHCPbvKO/d7H5G9PsZTjsaCkeqpNaqQvTONmPkB43P5CJAZQnxuSo/3plCyhbzkxSbASFYXCvqBVT/d2ZPYMq4EsVqxrCxDiDXwecV1t0A3tLo0zYId5nVl/B3/MSUnMVMdeJfXkLvaDxFQ+PflNJwvMdQ4S5kMKZyhZKlIRQ0GdNdPkSbEM0F0/9Pca2i4R0LWZ+0qU+Zp
 NA5zqGsa
 6MGHA7iqf6bB1WbzxGDSfyDbl9fK9yoU7L7PMvFJjFaEmhtpEVo4wjM+vgmzfczIdKFZwP1TM2h/ntox8V7CL49sbvU4HBnxMYbB0MYBtI/CCGAbhltza4au2gAV/xB5TXYvAL4jHhpj4/x2FsfQpmoDF9yymN2eSo40s2YmgMabE3pfUrhxPZNRYbYdj0JDh7Ntyxls10ADBHOo/xB4k0UEfH/ZrO3f8AWMIzGni9Lmz6NYMcvqdIH7uZEVnhV8EjsT79UbyHdJjdFfsCjusZVb5agms7gjR17PuobjP4jM4VTY9AmCuMb/iNUMD9QjG3YHMuIu2yR0FKFA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 15 Sep 2025 08:07:01 -0700 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:

> On Sun, 14 Sep 2025 18:58:05 -0700 SeongJae Park <sj@kernel.org> wrote:
> 
> > DAMON community meetup was having two different kinds of meetups:
> > reservation required ones and unrequired ones.  Now the reservation
> > unrequested one is gone, but the documentation on the maintainer-profile
> > is not updated.  Update.
> 
> LGTM!
> Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>

Thank you!


Thanks,
SJ

[...]

