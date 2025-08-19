Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9746CA0EEB
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 02:50:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DB488E0008; Mon, 18 Aug 2025 22:50:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48C968E0006; Mon, 18 Aug 2025 22:50:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C9958E0008; Mon, 18 Aug 2025 22:50:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2B92F8E0006
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 22:50:54 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 96AAB1401FD
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 02:50:53 +0000 (UTC)
X-FDA: 83791979586.19.8D77B74
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf11.hostedemail.com (Postfix) with ESMTP id 01AAA40002
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 02:50:51 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=me7CRAgI
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755571852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/gNl5UMTbOEoKpJ5CDqWNUpbWwrnu+YVi+0gNZI2EBM=;
	b=LDRnI9LdLqE6tavLg121xx8R3/OLcK0mJbSVB7pighhzD5uhw/zDgDtpyVTOtTJGpnspyV
	g6uACT1KR2io2qNP/1bKLKTQd4bT6dd0VBq6EAWkKq4JDTA464Ay0+KJbJSEgU3Fi0cfMW
	fQ3l6skfNjzCCkdWDuCbX05xxBytPVY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=me7CRAgI;
	spf=none (imf11.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755571852; a=rsa-sha256;
	cv=none;
	b=zkU4ixuiVdYSHA0XiGIVkE0ZLzqF2LBTaSqYtj5hVe58iRgAvpQKBIzDQIcx15vqe7qBOH
	fxO2SSoUVz0cKwBXgSV6I34YJiMWKU6/kJrkUZRo9HzhXrLzBiTfHOiSXxlw6GiiGhrKmt
	QlO2CseURSUZcGT/aGJxulZzY1EB/Sg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=/gNl5UMTbOEoKpJ5CDqWNUpbWwrnu+YVi+0gNZI2EBM=; b=me7CRAgIMphqXVElePHnpdxF3/
	CkZT/+pEf8QMTK7z7b/52AbVyTENK/3LfZAsQjSbECcluP0aSgcQyUYYnxvpccuKWGFVDdQCuGgiN
	CetMk3HG/k0ucOYmXKqsETGV8ndvr1+wYFLiedep5gYB8PvCM0iPAC/Sgh0Q5AbZP6tonhDbrAHNj
	mlJiMevsXi6vlHr/HUBO1yaiBGmi73qJbkLLN3mA70a9E7EOlP2OOOWBabos+SvJu11CXxX/4IL7Y
	CW6rMIz00mAKo/tIZ4gCbh+C9+EevzUlDou4gH7xIwYKe4ddWXjr6aiBRNyqOiyor3MGDanXJuXth
	hNG9h5GQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uoCR0-0000000F3wS-00PC;
	Tue, 19 Aug 2025 02:50:50 +0000
Date: Tue, 19 Aug 2025 03:50:49 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Boris Burkov <boris@bur.io>
Cc: akpm@linux-foundation.org, linux-btrfs@vger.kernel.org,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
	kernel-team@fb.com, shakeel.butt@linux.dev, wqu@suse.com,
	mhocko@kernel.org, muchun.song@linux.dev, roman.gushchin@linux.dev,
	hannes@cmpxchg.org
Subject: Re: [PATCH v3 2/4] mm: add vmstat for cgroup uncharged pages
Message-ID: <aKPmiWAwDPNdNBUA@casper.infradead.org>
References: <cover.1755562487.git.boris@bur.io>
 <04b3a5c9944d79072d752c85dac1294ca9bee183.1755562487.git.boris@bur.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <04b3a5c9944d79072d752c85dac1294ca9bee183.1755562487.git.boris@bur.io>
X-Stat-Signature: ssw1473148pt4fokrg9wrhzwnnf3sdo8
X-Rspam-User: 
X-Rspamd-Queue-Id: 01AAA40002
X-Rspamd-Server: rspam05
X-HE-Tag: 1755571851-889566
X-HE-Meta: U2FsdGVkX18pi48f0L2vXLO8AfeCINgQWpsSrNMbuQH5TO4HkXFivv7XW0pjFcY0h/YicW7hUG94UDizWl9kIpumos9uVww2CvbhBQ5SVCG1OLEvPo1TwCcOnnqUsHkmECi42kVJn30DTjbCf/t1np5tOSrAEtUfWAtF0ZK5lQu2eST1xqBEUyXwNU6cruVHejlXiniwBZcKfANogZ16BS5pnDFGgQoxtFWNxtRp2A3cCRTTCqxWO0iv6loXnum0gqp5QxwPAQJaR6bFMSAfSNqniDUgf47jLnoiKXju2d7gKs9gzOVIhpKqv4h+kTX1WlW3AKs0i1bc18zpcpvzDiPQncrfjgHV3D5Jpk0eUW+VrFS8gB8cKF5DJ8Do96H0ugCZuzhWffOpnS2O33/VjEt7OcOy9Oi5qSbiemtaIf8kGEtfpjKcrPBrcAfE+QIrQ7MqRVWm89xwkvM10Dtt3ALi9Qr/CalFqnbWWuAS/VZc9diuD4bJL7j4UFaMQOcIOp3LPU1Hyn9pqQzXz2hFa/J3aL7O3KKYK1nSILsaCPzs/CmTah2QbSOOVjlC+AYIBfc7v/S+7MzTDlHdTNFHYzzV6LNpdsPIJrl34DDHvDESPZ6ZuDfglK3egFQWJ76nysoNJ0l2Uy35ZFvrfzYBblnSQaZmEX4Uxc5DOt+ltYk4NpybeL4RVV8AOZJTdVd6vYmynz3Af566eRIjE12U4OBaiGySq/J4bj3lqbZlmmaKnU9/S4T4iDl8FAZwfVUFBvsPHsgLJB6V+RS8Ex/Pgw6FQmzoVq1snRVPRt22T90XnIu8FwkThVTuyWEW8I+d4J3UG7KNIDNhr1TVMP7DddowEMRyPK3A1QAOL3zTsOteaxCOCAiJcPqZYyTU6Cb0rL+5OHp/GiSUsTUR/w2ifus0AB0Wy9D6SW2FRc6V/EDM3C+zQCOLiHBdHHCcf53bj+WkVJgKkg+zcpyAWqk
 TWSCjD2f
 80H8I7/HZ4E/ZG2Sh6iKYKKTpy65Qi1haJE3a5OBSNVaumCIVKTdA+Mq4W1ccjI0iNx5CJQHxNgqtb779ppYzmXFDTcHxDiEEbgqWXcNZCtPfxMQZj6AbPmEPmjC3+5+wXlSjULe7Rb3nvOqfdA0BLqCvinS9agz0u9+rB95LcBslcNpKoXI3HKb9DA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 18, 2025 at 05:36:54PM -0700, Boris Burkov wrote:
> Uncharged pages are tricky to track by their essential "uncharged"
> nature. To maintain good accounting, introduce a vmstat counter tracking
> all uncharged pages. Since this is only meaningful when cgroups are
> configured, only expose the counter when CONFIG_MEMCG is set.

I don't understand why this is needed.  Maybe Shakeel had better
reasoning that wasn't captured in the commit message.

If they're unaccounted, then you can get a good estimate of them
just by subtracting the number of accounted pages from the number of
file pages.  Sure there's a small race between the two numbers being
updated, so you migth be off by a bit.

