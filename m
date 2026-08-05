Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B25F1C55182
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 03:59:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 997D46B007B; Tue,  4 Aug 2026 23:59:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 948A46B0088; Tue,  4 Aug 2026 23:59:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85DBF6B008A; Tue,  4 Aug 2026 23:59:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6650B6B007B
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 23:59:05 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 592721A0397
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 03:59:03 +0000 (UTC)
X-FDA: 85065860166.24.13E9FDE
Received: from lobo.ruivo.org (lobo.ruivo.org [173.14.175.98])
	by imf23.hostedemail.com (Postfix) with ESMTP id A2D3814000B
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 03:59:01 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=ruivo.org header.s=mail header.b=FcOaT3T0;
	dkim=pass header.d=ruivo.org header.s=mail header.b=ggvEvA9G;
	dmarc=pass (policy=reject) header.from=ruivo.org;
	spf=pass (imf23.hostedemail.com: domain of aris@ruivo.org designates 173.14.175.98 as permitted sender) smtp.mailfrom=aris@ruivo.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785902341;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=CZB33OF+7+RYKb9QH5N7+1b95vy9tN1gyNx3Zyi6leo=;
	b=FwbDzRCFRiCyP8XxSN93YqJMJD9GcUm3OJhbLMelbhWn3EFm83L9AXh62+Ho7P4JDKXjdF
	6rqZw2LI0GJUz1ZxPgMKRt7Jwtyc4FRxJPrI3YIuo1d0dpcDOn58Lu+VTU7TNiaaxefOBW
	VhNZLVicxTfNJDds5bkcw059Gz8A64U=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=ruivo.org header.s=mail header.b=FcOaT3T0;
	dkim=pass header.d=ruivo.org header.s=mail header.b=ggvEvA9G;
	dmarc=pass (policy=reject) header.from=ruivo.org;
	spf=pass (imf23.hostedemail.com: domain of aris@ruivo.org designates 173.14.175.98 as permitted sender) smtp.mailfrom=aris@ruivo.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785902341;
	b=CYZL5hsJqzLXhgUPvOMaTSl45L1HQdH5Oon9Y0zdoKUjxLVuGirqsQPriaaJpICxb5bjjR
	gb/sEjSKzxORFM+MXc08KnRoCwxCoIvRAMoU3TJqJtU+f/mOIsMt/iPuZyubGUzv0reVRz
	P/mJjLic3R4JzG74gNKn0UctTjyxiEQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ruivo.org; s=mail;
	t=1785902340; bh=h70dQOq/gFQSWafmxeFDI/GYqalaN39ZqNm8d2Sulqg=;
	h=Date:From:To:Cc:Subject:From;
	b=FcOaT3T0Bq5mNGIcJftvBqmUuTcHbeA42Ude5sR25t4YchirqgIm3DNfro0QR+qfR
	 RoJylBXbQtS1SyvH7Li217l/QHx0bD+lvqzr+VQq9xSVFw9P+GWpB1z9r0HqrYuVvJ
	 OKkrhwZwaHwPx7gylmsryGCSEAbQF25r4swHV5yc=
Received: by lobo.ruivo.org (Postfix, from userid 1011)
	id C8A1252E98; Tue, 04 Aug 2026 23:59:00 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ruivo.org; s=mail;
	t=1785902328; bh=h70dQOq/gFQSWafmxeFDI/GYqalaN39ZqNm8d2Sulqg=;
	h=Date:From:To:Cc:Subject:From;
	b=ggvEvA9GPRLjc1KaBbvH1pCCuoV3nY09PlWRBI/PvEXYeEOGvMbnULNnfEqVv1ulf
	 0klciBMFCVJ4IG9TB7X+AivjwL26rk1RfGV5+0om7HlW581SH5NYrjA+HswHJBqGlN
	 NaBiNkWVI5zxg0O2UjRZIJWoapOxag2g9RIX1vT4=
Received: from helbrecht.local (bob.qemu.ruivo [192.168.72.19])
	by lobo.ruivo.org (Postfix) with ESMTPSA id 2EAAC523AA;
	Tue, 04 Aug 2026 23:58:48 -0400 (EDT)
Received: from aris by helbrecht.local with local (Exim 4.99.4)
	(envelope-from <aris@ruivo.org>)
	id 1wrSmG-00000003Qva-03tD;
	Tue, 04 Aug 2026 23:58:48 -0400
Message-ID: <20260805035847.936054733@ruivo.org>
User-Agent: quilt/0.69
Date: Tue, 04 Aug 2026 23:58:47 -0400
From: Aristeu Rozanski <aris@ruivo.org>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>
Subject: [PATCH v2 0/2] mm: gup: cleanup gup_fast call chain
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A2D3814000B
X-Stat-Signature: nbq3ni13y1zkgeyfn4n3718m577ky3wd
X-Rspam-User: 
X-HE-Tag: 1785902341-821437
X-HE-Meta: U2FsdGVkX189a8jUkuZUG+1jJsL/1TF238NlNp3mUFR+p+JtqeB5rA9vKMxlGI/NnoT078VWSm869zSwQwCIReSeEW+EeGM2vKuNXYSmZ55kgIHvgl6h0LIqWk0JjKX8WjhwQQTLnYDbaybUvr7UuWlSpMSEWWvweBV6blUMmkeN+QXLbDuMcCHBR7AxmZSEmHc/bWoJgETalGzSEyhAKWEB6KFdj/rtrxvyKKpDKplxw6c2EDkzYMI39PFxMPSU1XffQ9SI9kVLCkLEtlT9aZJLxWcBJ6KhL/JNU092AE9Up43A40dIhdDzDcFnr5AuICTBrrSXk2qzprbalOxr9dNne/Ejvowpp7BiJMlBmVnTbctxvW/rKKmxpqpEb6ngNCcIORXq9JvwIsxsnCQXfUlx/rCWC7fTmQ3z7yVrrZrMNImC2hu6zSlSDpkTVeEBDou2pjOSlliHHAFFAT48o5fEzafi56mELwUMHLCydEWWA+muzvpidr+NKxfyq2Degxv9ytHQYJk84Am5LsVRK1mYL4w+ATS7Me087iI5beSOVDqzIKQiPM1Hrf6ooLP/9yi91FBJk9lzHOuw3vcARIFaMWAnD4h0wGBICSvs20O3y0gEW0JPTwIko2reAw4FXt1mGXhq2epodJ2CMf8BN+AJvBMksDcGcOoRvHKRIhzo/VeS3pBP9TzspXJ9FURrRiNB/cWF18TWHSyHq3YcbsoBoXk7LXfdazprI+TPRVL7O2i4TY7w/Se5eRzJhj5dJTpea2vpM7z5YFZk+TqEqLhRKRd7GTPl4GDG8iiaRNG9af6RvwtuZqyo6wtrLT9EMBmqvBM8bFviN2SgtGVVtK5T+38bDtWGp8QSgc8TYvANF02C2YnUzcWLc9XcQfdiOYU0yq1HN5xueXzGqvYNDoy/3QMp9a3Z67XxMxoH9f7QJJdnT9nv9yBTpLOw7dp+bD62zUQIdJ9WLO2dXpk
 +CEPxKmO
 nikmvQ6chravdbhLVdubqWEMPksp/Ic5GWYr0ruV/yjA69QYdUskx4bVPGjH9OPZ1lu1/JWAMWdeYHSiJASWiqBFHKxC2wAVn6mJjVeczccTpgKGZ+vQcBBESCdqvoB5HpDYhjuLVChtkDTQHqU6YgWP8uPPv2KYUVwN7tsc4FzQuaw47FCxcO8cSpo5viBre/QLLAqbRXhx72ohZOeYOKGDZ+XIShsLlYJjDFN1h28bbmz4PIG8hNkWSJZAinv/MBJ12BXjy4rF6iQRJmvrLIl4no+hP1/f9KF0jWMqx+O6ljI/OlQZ+WuI8Eu7/W7DgkzvltK7YI1ZsBSXhWtmHux8cuwX8kIzOODQxkmXewr5WqxmdFlPrWhvTiLZUgGKeE9LI0DAbm+fWDoRCjl8gc4+6XSSnpQbNBM8nDmdHZEeVKq4dmkof356M3sNOJYoAuFWhLOq5tsvhtJeBa2yQ851MdA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

These two patches implement the refactor in gup_fast call chain David
Hildenbrand mentioned in

	https://lore.kernel.org/all/85e760cf-b994-40db-8d13-221feee55c60@redhat.com/T/#u

v2: removed unneeded initializations on the second patch as pointed by David

Suggested-by: David Hildenbrand <david@kernel.org>
Link: https://lore.kernel.org/all/85e760cf-b994-40db-8d13-221feee55c60@redhat.com/T/#u
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Aristeu Rozanski <aris@ruivo.org>

-- 
Aristeu

