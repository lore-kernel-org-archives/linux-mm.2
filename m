Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D95FC54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 00:27:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0FB76B0088; Tue, 28 Jul 2026 20:27:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E6C06B008A; Tue, 28 Jul 2026 20:27:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 926256B008C; Tue, 28 Jul 2026 20:27:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 693876B0088
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:27:16 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CDA4A120575
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:27:15 +0000 (UTC)
X-FDA: 85039924830.11.28F5E60
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0FF2AA000B
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:27:13 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="IWBER/3H";
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785284834;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dyB0Yu4EVdbHNSEPMIzknM0zizNklp7o5QWt0/JKJQs=;
	b=qndiPbyCMB6KVa3ARMiIyZcQiHqYRInXLTcBuV5vqqXT9rnkETqyt/wVX4TLIw5TiOC9+y
	NpSYlc8+MeI0Ewr6JKbZ3uIdqi/Q122v75IJ38P3tMhn/Gyu6Geg6TDvs0IJ7b6vdrihvT
	ZyNzBqo3ZZFA9xPGooKq/9pSmbtOLyo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785284834;
	b=rAlqjXGm+4LPpfTaGLzmP2vsQHGJx9zrSltuCbfeoIv8D9/pnjVA/Y3M6yzE4iqwlPRxlH
	3qBAmBSlIUHSTEwsHLO87CsMR9xlyIjPnlifm0FsxuXiPmg/pudWKXthPHk9RaX5JcxTd2
	zOPf64aIrTNSeepZDSKYkOyL4li5qwE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="IWBER/3H";
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1F34260A5E;
	Wed, 29 Jul 2026 00:27:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B0AC1F000E9;
	Wed, 29 Jul 2026 00:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785284832;
	bh=dyB0Yu4EVdbHNSEPMIzknM0zizNklp7o5QWt0/JKJQs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=IWBER/3HP0xqx+38UtSkIWzxm/kne84BqJKMbyljhzV2s7FqK/UQ7QXBgxLdeiNVu
	 VCK6mSRGkNicgzCMPTGIguGMbHYYZBCSkUNG0Zmf8Kf00+a2mXkGeyR72GpvqPAlMj
	 I+q3PXFp33vOGg3AiIrOPrlo1FDsevMt5y8P5S4c=
Date: Tue, 28 Jul 2026 17:27:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Chris Gellermann <christian.gellermann@codasip.com>, brauner@kernel.org,
 liam@infradead.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org,
 mhocko@suse.com, rppt@kernel.org, shuah@kernel.org, surenb@google.com,
 vbabka@kernel.org
Subject: Re: [PATCH v2 0/2] selftests: Add missing initalization of pointer
 passed to getline
Message-Id: <20260728172712.c21b2959d36f3e2d42cb73a3@linux-foundation.org>
In-Reply-To: <580fc92f-f146-4d76-85ce-6555cc3bc47c@kernel.org>
References: <20260526113848.530105-1-christian.gellermann@codasip.com>
	<20260722130246.2135563-1-christian.gellermann@codasip.com>
	<580fc92f-f146-4d76-85ce-6555cc3bc47c@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0FF2AA000B
X-Stat-Signature: ktxir3x8r1rez61wsf48nngxypjjbjr8
X-HE-Tag: 1785284833-768416
X-HE-Meta: U2FsdGVkX19qGqUl85g1dixl5I6yNen82B101RigrULhc7mQTmMPSrTxgQk5PgYvGw3bqH03jQi0bjleekvKb7Sf8Ojs9idqCtNU4kf5JYh0QPppdrpd9Vv4b2O46jxCYw0M/klBisbb8g6nqlCydiSvJEP1WofS4XmOR3H5nUOQ+wvZm422tpOUUsH+OpmI3v/06+lXqfvx4wT7bbQTrzYPk+svKuh1XoICQVJGzSP/oAz5e8xxUsrZDYXcvaZ7TSixGD/1kxQce/uVK0YM2e39NBQ1+td8hU9JWqVAdfJHFWPCaJ60G+kKIMiWSW/ZZF9zMFEW+Gdt6IySEFIkHBFuQ6kNRSCcflxPNd4zXLgk/wnaWfwLgDQ9dGqqBmDL0iRYZrIoGVrAQsgfRxqMJX38RNh4q3te7cr5HgoMB1OfjMvQSmRslb5/rF8/uuug9mcKKTtykiVxOhrOGGHw47pooqIaPaXt3Kfodiy4fs8hdlPNewLVzwkMB7HhhHkAb0dIE7QlSZ/vssvWCm00zLC2itdvtHwMtyqR456eD4xYszo5b0gI7Y+pIQkoHjGsTApVX9MvNR7xoUhBNykHQQmoyqOgfOof4Bmo05dKFMvA+nvx8Djf9aTo4oUrF/wr+meyqjpj0HmwXel4fLdyfBGms1UQT4fH/YPfm/IquHl17GdZvx2PGKAZNRphgthgbQxCJHlQ+jabZEproQfHIjRpE1og3JffgQupAcL8BYaXZjM80VH7FjDccDqAl29+pRYRpHDSE1cdYucsSkGrOPXz0Eyn+ugA0InRjDtDyvw/ge3OFeqrSQdO2z4zrJUnAoo2F3gA3ErnMHLVsnjNl0WiMVYrluxKYOstuLmfOnuWLSVHSGR5xxoSKl7LZ8NeCdiM5zswkxVo1q4A7qoGy5TnU16cLZujMMCIjwqpfwQ8uXdI67GaIn2J1699pHZ2iYmFUmdy62RZiiNBVIh
 sS4sqR5X
 E7/kvtWJlOVP9QSVuUcr+jdVoTBiojDUOAaRTBfX8EjgpCljvJFCRdeJo7UdYvELuambbg/udCqmSClfADAAQvlc3xbyYabVa86gN7TH2gI3U9KMU+sH9pVHgSuBAcDFadpoTRGuqHMna2zmwO8/jOQ+TedZ4RRDX5ZDYIBcy0tCxIIqxCSipdArXT/mFq5DHDYMXVXjFsFErQ3VUAQaUhU9DxH5+aYRxCoZ7ukHAFQcV1RnxmwNZTnA/zCH/vTp6vOZ14yXJ4PVyK7izoBQIBI0v+w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 28 Jul 2026 21:31:39 +0200 "David Hildenbrand (Arm)" <david@kernel.org> wrote:

> On 7/22/26 15:02, Chris Gellermann wrote:
> > Hi there,
> > 
> > just a gentle ping on these patches. It has received an acked-by from David
> > Hildenbrand (arm) and a reviewed-by from Lorenzo Stoakes.
> > 
> > I'm resending the patches as reply to this cover letter to clean up the previous situation.
> > 
> > Let me know if it needs any further change.
> 
> Have these been picked up in the meantime?

Yup, I added the v2 series to mm-hotfixes-unstable on Jul 22.

