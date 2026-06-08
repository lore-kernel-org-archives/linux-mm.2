Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2E73CD8C92
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 08:30:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CACCB6B0088; Mon,  8 Jun 2026 04:30:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5D106B008A; Mon,  8 Jun 2026 04:30:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B73066B008C; Mon,  8 Jun 2026 04:30:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A96FC6B0088
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 04:30:57 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0E9FBA0A4B
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:30:57 +0000 (UTC)
X-FDA: 84856074954.08.C29474B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5A15614000F
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:30:55 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CrE5UV4E;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780907455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ukPsr8AVW223GNDlkOBdESYJcOCBcUm24I0u/yjU+YM=;
	b=ejWjDAjRbBqlBEzSAFWB3AEus5mia24vMHQsNCMcCjt3soSvk3dVeT86gfrYqFW1TwJJtp
	A+5imuUK1vBenVbnoTPnNkWmK5hFQTAvDHu+QNFRJwZZITrNpQLijDN0u/IAOUPiUrXnwK
	EhoxSywVEUg0+kq9s2piHFbPORUrFWM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CrE5UV4E;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780907455;
	b=Jski6NDK2vi82NhlFVsVFGccJnHKpT0Pi3pAfSqjzVjXtEiyRXVU960vKh1wt9g9/XZoCH
	ldeck2315FpWJVBO7K2OPgbHRNOm9cIoGwkiupAEe4EAljs9oqtTh8qgBdc6B0B8nSegEh
	tqbrCTw8M5y392yiJoU2MD23Benn+RY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5581943588;
	Mon,  8 Jun 2026 08:30:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95FE21F00893;
	Mon,  8 Jun 2026 08:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780907454;
	bh=ukPsr8AVW223GNDlkOBdESYJcOCBcUm24I0u/yjU+YM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CrE5UV4E4gtMqWdlDxlwGiualRcpCYsTqtOnl9OQ7iJNffWWhuVEi4pb41/d3BE8H
	 E4PUS6xuWHk5A9OSqwN0It2JZroLsO+GjchxcCMplHnFEz5YXQa3bSj22emTn+NV0p
	 NpTt5uEAnB95OBuAJqNsP3oJdaMJThOc8kQihH+k+Y9S530VGWLSduTH3cZbAmQDY/
	 /mSvxvIv73FBM6REzzzeJ3TWVEr863JMvVqXrdQRIcFr9eGIwpPAJRcJ+3SrymvX+q
	 MdRJWv6j2z0zaMswzhzTqHrC1hwHxLA0ObKhVtN9E20OOsMIB5HrQ5bNc8sgYCzJZM
	 VMSbx6izi2ePA==
Date: Mon, 8 Jun 2026 09:30:51 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "shaikh.kamal" <shaikhkamal2012@gmail.com>
Cc: "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	David Rientjes <rientjes@google.com>, Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-rt-devel@lists.linux.dev, 
	pbonzini@redhat.com, skhan@linuxfoundation.org, me@brighamcampbell.com, 
	syzbot+c3178b6b512446632bac@syzkaller.appspotmail.com
Subject: Re: [PATCH v2 1/1] mm/mmu_notifier: Add async OOM cleanup via
 call_srcu()
Message-ID: <aiZ4-4VVJTjIJB24@lucifer>
References: <ac08V4TaM2yh9SY1@google.com>
 <20260429222548.25475-1-shaikhkamal2012@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260429222548.25475-1-shaikhkamal2012@gmail.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5A15614000F
X-Stat-Signature: fuh954w64r6nq967jat96srw6bpotkbj
X-Rspam-User: 
X-HE-Tag: 1780907455-299695
X-HE-Meta: U2FsdGVkX18aacKYvI4WAVCv5Fd4n4Q/ks7K+9XA73L6PCRAv3+58NuQtkhm9xWIoisb5zs3zANFaXuR/N2j+5ZfinYs/2aK/4QfFPV1sBetoE2tyWR5PrVpYA4o58EEKYi9k1z3ggIJUqezurFISnjzEc3n1CSYaPSxLt0o1wwwKDnF7d4TwzclwsI/YkgJNY7ZwOLDeZgZ3GO3e0Yx11X4JNQPrqYd2Zt5eyNZYjZXwssw2w+Qv9ZpJs3yGaZ8MniFudrF51l/aMnVtDxrB3Qjje6ZBTfdqiv7BdUM/QmKXU1VF5c6Eol5tZDO1Ac3398PI/EpAWzMlafinFxrBu2Rbmmi0EZe6SBnhsu2WkOGYqx6jed2l4l7S/f3uwGafIduGgSAr/HD3av1ScM/FOpNHmoL24RzU59xXDNnDZVcf99ocD/kyHXF7UmvT9TwDsoo2BaIqaiIt8JrzTus7/HEMbBSsQ/YKFOnWxXJPAso/fSHrl6DP/g8gs+D1JnKJ8NuzgJxIYsqHwfb+axBtNgijmUnCOIoG7b7jPVLsL8SBCal+CsGytOreJlxahG8UPYzb+YccAadJdpjdH0UlI5NhZ8JvH5EAvIWfP1xG20DdMBC71o/m9THEbnXlpHHkpD7wjjWMTnzu236CeMbbh9scPL51TNUS/dpH19HrgmiXc+ugAY3xcW7uTvdNXkYM5WuX5H01EUKaFUXkXySgOyU3X8ac3t1RTzq7JrRD2O6e6VQ23LwRtpJA6WTzQmJpF4TojTSSL4UhuI2aWHQSf/Sk1LJX4FrcMO9PKksB/cfKZcWcaAipa4c7N5MmLApXrkrVu84nuD9vWZSQTUjePOQ4GRa6PLmf99jJIs0Y9ZIqLEATg5Dg3/VatIOd+6f44rhDyaUY7g4t3h+oh8JB1jh6Ku4bxFypcZeMqhZGrWNNrNge4xBhrWt9tjoerZ9aFCZQet5V67PG8Twb5k
 RSyFWmFk
 x60oCzX271rHwYUZVOaP1hKqZMFxAW92NM3E7jaVQ3dKGlmlgtooELXgEeKmsd/4DA3BoNXORAcHbykVXZLJ39vnhLM+k8DkMWYFc23YvLioEIyShGQ+QvGLGHlRu/7uX2svTtwYgBSrBm7B4L9WL1vPp5Mn2sGZH6iBat8dhyzndZS8FecifBFKsWMpD1uvsCJ9E/wOI7VUuOrfj5wB3LnEp//wptVpqH8EO9k02Av3Je8y4qZCT7D+12kkMIJkrFkt+FWTDwvQMiDbumPRDiIOBshDt/xAvoqhpPYhWGrIju702BHfW8OQCEIlNyBW1eXq+o92GQWk6K97VlJKo3bVS44pU55iou6DKvPun4Wu00RsI/eITbOiF/BWIJfOo2eUqbNHjHWSwBZ5yyIffol/Jn1BKQodq52vvWgIe6XHjzJHMDhfMTME2QhfHmXJuuwSICsaWfdpeCXxNXsdttx9D7wsArTVQkLyM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

-cc my + Liam's incorrect email addresses, +cc Liam's correct one.

Hi Shaikh,

I'm assuming you're fairly new to the kernel so some feedback here, as
there's quite a bit wrong with these patches.

Firstly, please check MAINTAINERS to ensure you have the right email addresses.

Also please don't send mm patches in-reply-to another series, send them as
separate series.

Send patch series such that they're in-reply-to the cover letter. Do not
send a cover letter if there's only one patch in the series.

Do not send follow up series in-reply-to the previous version. Send a new
patch or patch series.

If you get an issue like a build failure, do not reply-to the patch that
failed with a fix, instead send a new version of that patch with the fix.

When you fix things, add a brief changelog under the '---' line if a single
patch, or at the bottom before the diffstat if a cover letter. Ideally with
lore links to previous versions.

For patch series use:

$ git format-patch --cover-letter --thread FIRST_PATCH_HASH~1

For v2, v3 etc. use:

$ git format-patch -v2 --cover-letter --thread FIRST_PATCH_HASH~1
$ git format-patch -v3 --cover-letter --thread FIRST_PATCH_HASH~1
etc.

More useful tips here:

https://docs.kernel.org/process/submitting-patches.html

An example of a series with these traits:

https://lore.kernel.org/all/cover.1774029655.git.ljs@kernel.org/

Thanks, Lorenzo

