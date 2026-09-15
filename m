Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E79AFC88E7F
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 12:02:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FB3C6B00A5; Tue, 15 Sep 2026 08:02:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D4136B00A7; Tue, 15 Sep 2026 08:02:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F29F26B00A9; Tue, 15 Sep 2026 08:02:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D6C666B00A5
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:02:24 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 797E21403DA
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:02:24 +0000 (UTC)
X-FDA: 85215859008.13.83355F9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id C0CBDC0012
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:02:22 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="f/BEG6N0";
	spf=pass (imf28.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789473742;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qcYOVYEeSBwNAHSV3oGOxIoOYP16KGnVjnu+hbqVsEY=;
	b=dKGlzX7PDeHRiWuBqkg6/F6vDdAcDTvDb05ph207YBcjZ9+UgssNMge4CyKtI31aT0TpZj
	P4S2eax42SFijA8a7QoAz6FFZaJC143+xGhjZrH2Ai/M8j0szCvDmUAY7kL7ljb37MWYKn
	X/59ktIrhB473TNqH+43kaUg+wKZ8Gg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789473742;
	b=wFybB6C/aKUlx+P1NM8qIw5Fqv7ze1HkCcEkauQS4tlWN2cbKBxQ7EqHBZPAX8FNTjzeMj
	cvV4ARQYaFVnsNlIWGWwM38dHaAhmCBYPlri0tXgqA2uUCbC9sDRLRGCoXo2H7d1c3a6dm
	1hL/avkmap7AnXcXCs5mAWSXfn2gVxY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="f/BEG6N0";
	spf=pass (imf28.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 196F94141B;
	Tue, 15 Sep 2026 12:02:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B2CE1F000FF;
	Tue, 15 Sep 2026 12:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789473742;
	bh=qcYOVYEeSBwNAHSV3oGOxIoOYP16KGnVjnu+hbqVsEY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=f/BEG6N0RGxUq5W/HXCadDNiWy6mZwl9CV9CowG89trZuBhbvX/vWsAwHcKt0jPgW
	 SJ2ml9rORw02KpW+BBtA/RAwgHeaOMkDEM/bw2FOM3cvOGpK4o5aTZomhO8RUcQ5S/
	 HUGzy85d+v2Rl885i1mtVPRNCYfGq7VMLkzir6Qo74z8OfaWUxRKM2kqLaxvoO35hD
	 g2OjURXxrNOf5LxE5EULxkvtM4dwb4/ru0HDhvJo0tuYkl76FUzGi2h5pCD/fdlSaR
	 IpwMuTLI+Jg1YfgtVCyH+xGpSt50Q2kgFNlZVyEcwXh9ZMIlgJii4H6dAqtEZuqtWP
	 6++8DIfAg5DTg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC POC 20/50] file: warn when the descriptor table is
 unshared with slots
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>, "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: bpf@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-gpio@vger.kernel.org, linux-csky@vger.kernel.org, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, dri-devel@lists.freedesktop.org, "Jan Kara" <jack@suse.cz>, "Jens
 Axboe" <axboe@kernel.dk>, "Michael S. Tsirkin" <mst@redhat.com>, "Jann Horn" <jannh@google.com>, kexec@lists.infradead.org, "Eugenio
 Perez" <eperezma@redhat.com>, linux-mm@kvack.org, linux-hyperv@vger.kernel.org, linux-mips@vger.kernel.org, linux-hexagon@vger.kernel.org, "Peter
 Zijlstra" <peterz@infradead.org>, virtualization@lists.linux.dev, linux-snps-arc@lists.infradead.org, sparclinux@vger.kernel.org, linux-alpha@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, io-uring@vger.kernel.org, "Oleg
 Nesterov" <oleg@redhat.com>, linux-parisc@vger.kernel.org, kvm@vger.kernel.org, linux-sh@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
 =?utf-8?b?Q2hyaXN0aWFuIEJyYXVuZXIgKEFtdXRhYmxlKQ==?= <brauner@kernel.org>, "Ingo
 Molnar" <mingo@redhat.com>, linux-openrisc@vger.kernel.org, linux-um@lists.infradead.org, "David
 Airlie" <airlied@redhat.com>
In-Reply-To: <20260915-work-fd-reserve-unify-folded-v1-20-4d5217d6b246@kernel.org>
References: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
 <20260915-work-fd-reserve-unify-folded-v1-20-4d5217d6b246@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 12:02:19 +0000
Message-Id: <20260915120220.2B2CE1F000FF@smtp.kernel.org>
X-Stat-Signature: u19p9z6nyjh81qwef6e87fqhq6etqeuw
X-Rspam-User: 
X-Rspamd-Queue-Id: C0CBDC0012
X-Rspamd-Server: rspam03
X-HE-Tag: 1789473742-386157
X-HE-Meta: U2FsdGVkX18ScaVdDnncL19ytTZysEAOirLuFHbRwlyznrmLYiAAZAAtPCa+q8dOx63p5PYlUB2Wkin9LMq3gYOQrCQ8L0Zfd1POYUHJF88MtwVHHeJdmX3cmAbLBTt1htAgpbm9qA5nyPidTtfkitoathuPoKvxKfSHbSvHC9y/0bvrgdVuqlqMFLg6IxjjD9XX5XpSkHwz2kYtbpeJ6HcXJTpU16b5Vg9rPPiRlP2AVD74hf8FSGzS010xJYtmeeXmx1yTdjND+0OVxfbjvkzEFStszbeXOF82s1uuE0pF2r4mho98BupSEX5tauEyr0AvdRI0HmWvGwrQbZeuqyd8zPgIyx+D23LGGkhrLgfqP5fm3lkVVrEcMrP0rHgtyTmolYiU1OgoJj+/6aKjyPxQ9tFUh13RVJJQMW0O5bjDcLRw0pvfOjPzX92os+GZhWTA/djtTl+cOTZVSBiY0DMZoZoHndaINY1KAVtaILmj4rLtwqaQ9S8xT0Xfc31mr/bUX649UttIa7e+Eh6zkkVFR5mtFdHmhLBiTj8cWPTrQ65daLxEOpyX11oRITJdKNp0mGU0k+JsyjHPku6C4x+HLxK2pQ8oomYRmrnq8BbxZUJicZTu5c3wA0daGFMIcC/JiszQZBwRSZoGeFi2OQ+RFHZQlh3iI9FMi+TinBRO41SA5PV91ouOMC6kgcAWcMUHVFz0HokmaAXh+JFTzkzv3dZP+CQM8+GOJCTr7u/obbZPJ4vL7BsV6Dp6dOnet+1w0uJ7Z1wn+IWdEFdc9VE68pf92Ad7lfKXMkX+4HZQDFS/5cxWcm5UcW2jjPyXS2GpfeUAoM3y3Qm1/1rbe5zL4RTNemcvuxsT9Kal05BOMORhkyWBT/PHHBdPmBs/5LJIofOHu1XpuCeBqQzyXZFGdeuuo7tScBar05pJXn9JC7ueg9BO3ZbE8kZTUSPs3fy8okazHb1jFprPRqs
 kllyvv/Z
 qrnmkATTXp2jRd39IB3pP++qffhkRbbUwMyNtMbMVA3BOfLlH5d+/HDQ3XxusRmU3XkDYMuKIlFsphC8n3+BdWmS0O8+seXPe7zy3rKatfrF0HvfROmczs7HN2E4G+SfCKpLjDnmNcsnA4tZLOLL/GBdU7o5d1/SrA5C68q+orcUK0/7S5QEkB+YpFN9ndkZNJiPErhZGjt9UUNZbMKcIaoFDBxFBIklzmnXMaw6n/Jt1WLd3EwLQsc9TsUq254WYmberWG7+Q0qp+gsq52LnSjGJsvFlzLnkQBSc9ISsPXwVavZY2fiBnnNxGADHQVMWL1mAev6vgGKhhv2S77mxZsgrC8W6bozs3qhzy95Go7KV7k0smblCB5gHTZ2ia5q2tmwnLL2upMRiIjACyV6PxgqiCQ7WIMql7EMtYWi1BoINIQJOg4C3OnWqpoAjqf+eWW41HfJ4U2V9jBqtljpInN1kjnn5qBl3xS6+nzl71cvrwV17VKdYxEJsv40ecXlRqzp00ZAoV92AoLDNjYyjLtmU23NydL10Lh/2ZZkVYy3Vln4yu1dllX/0PJcxswtVH5IwZYl/kwedoJihITmQeLRC2CnBIMKfKGAoH64JFuLk7H5CQc/fDisFv5p47IVWUlb20syTZj/x5JtuerEOanSqltBeq0qe1xBsbelSu+CJkFA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> If the fdtable is unshared or the task exits we can't install
> reservations. The reserved fd isn't reserved anymore. execve() would
> leak the reservation into the child.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915-work-fd-re=
serve-unify-folded-v1-0-4d5217d6b246@kernel.org?part=3D20


