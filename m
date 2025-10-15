Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24E2BCCD185
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 07:30:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E6DA8E0009; Wed, 15 Oct 2025 03:30:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7972E8E0002; Wed, 15 Oct 2025 03:30:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AC598E0009; Wed, 15 Oct 2025 03:30:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5881D8E0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 03:30:24 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 121C8BD445
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 07:30:24 +0000 (UTC)
X-FDA: 83999525568.14.74265B6
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5721A180009
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 07:30:22 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760513422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wwsMcO8kxKDe39xAaR0wfWWvJXHr4ArjIXG9EGSFt8A=;
	b=2Kd9NfNlYhgVM7Vqn8zsJKicVXb9d8d8QxjrakwOhNx7C1k8Mmgv79b7PwtNF4TMq8x08V
	KV3eylugFYqf281Z8n30scrxZtIuRCO79MhSzmbbCifhd2mqRbNOv8OZ4C0+gqu0q9XjaL
	dVaAhC3OQuFkXjS/n3ZTimd49abYB1A=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760513422; a=rsa-sha256;
	cv=none;
	b=OBRa2vSBD29ysS3TVw5ZKLAHQoQRpuvxYV6UMgOjbuilf63vsPKwvsFJunS9fLo2kPpXeR
	R+R4w8onBJNM9qjSfYhjDO6rzSK+dV42xqbUftWLCQMHcG2AUDPpY4WQnWh7Uz8sDR72hP
	KaOlKPKAJtmDWYY68IiRYTc6OjNsnW4=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7A8E9227A8E; Wed, 15 Oct 2025 09:30:18 +0200 (CEST)
Date: Wed, 15 Oct 2025 09:30:17 +0200
From: Christoph Hellwig <hch@lst.de>
To: Kundan Kumar <kundan.kumar@samsung.com>
Cc: jaegeuk@kernel.org, chao@kernel.org, viro@zeniv.linux.org.uk,
	brauner@kernel.org, jack@suse.cz, miklos@szeredi.hu,
	agruenba@redhat.com, trondmy@kernel.org, anna@kernel.org,
	akpm@linux-foundation.org, willy@infradead.org, mcgrof@kernel.org,
	clm@meta.com, david@fromorbit.com, amir73il@gmail.com,
	axboe@kernel.dk, hch@lst.de, ritesh.list@gmail.com,
	djwong@kernel.org, dave@stgolabs.net, wangyufei@vivo.com,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-fsdevel@vger.kernel.org, gfs2@lists.linux.dev,
	linux-nfs@vger.kernel.org, linux-mm@kvack.org, gost.dev@samsung.com,
	anuj20.g@samsung.com, vishak.g@samsung.com, joshi.k@samsung.com
Subject: Re: [PATCH v2 16/16] writeback: added XFS support for matching
 writeback count to allocation group count
Message-ID: <20251015073017.GB11294@lst.de>
References: <20251014120845.2361-1-kundan.kumar@samsung.com> <CGME20251014121135epcas5p2aa801677c0561db10291c51d669873e2@epcas5p2.samsung.com> <20251014120845.2361-17-kundan.kumar@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251014120845.2361-17-kundan.kumar@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5721A180009
X-Stat-Signature: 1oc41s4p1wcbcxqt7cpo45jnyjg6w6jh
X-Rspam-User: 
X-HE-Tag: 1760513422-141626
X-HE-Meta: U2FsdGVkX1+1aP86xKt1D/i/zMRsLiCQf79ogjChgS937QEHrvCwma7Gq6pmFOkrNmS6b5aO7WWsxh7C4LxW3IpL7OEb4lW57b4kdJ1mqMLc2twBDys5/Dcds0mRjhvgOjh56z1mQLiKz9q6CgG5X+RX2D5hksekVtKkWv4Ezn7f0IP4x7WdCsn5eqxfI+aYQ2RgbThX5d39WFO/5yp2GJdg1DX16aL/RRoy1FWXPzLmwKc881UX3cai0cSfAbpiru/X8nzuX5s/gXAqSP636wmrV6hSrMjVA2riAWcnYoHK/lJ1CQUL+X4XBjrJYkvOuJZeAGDkJMTteD2bHPNXWwtWUR0Q2TloaAZLPQ5GQMQyqdizmS4N8igHYrbIVBurq1opwSkkIL8f0y2XVqZkzCv+6S+fgk4qEzRSbESYV13V+eFjG1qEGBMYu0qD3N7E6GQOAqEC+xFSmgYc+wiWXjCIRVXkBXKaUj68GdOnEABqbto6C2gE3XwCIOgG6/ClfnVrUopxwqJ9+EzknbUo0biuXpXYWndJVfV5g2M8SPKaHsIuYWokZICw9mqPIK6eiTF9K2mvO9tS7JzuPaPpipA71G7TOqCaehn3QqU1no5Ix+hHicmoXwp95EdjPqJyZIFclcvGNe6J0TuAUPLPSOIeUn844WGQuZNNGA0s0yEy1Tv/y3gIQg3HczhmA9ousouJOesZkbe3K3ZXXtPSbw1aHvBWpEgmAQrHU54r+npVDaP+SNIeo6EYmn6i2CTJf70iXGQX9cOFslGMU2VCy+J5dAh6bgPBCnmgy8f5INFMy27/OcqVN3Yc/G7Fg61daWlWWa6GX/I6hR+NSmVGCyWCCcNYpLuvWhavHgfsFK5lkoqIGRp1DXZsagnzkDjWf6YIrOYT1qad2MHuYSW55AWdfOzio8yQ9I+zmO0Y8Kr3fjSGXmryX5LjHCPueOHoeuTsoHB8ILmMPNIS94i
 Q2k9N9NJ
 nd0QQcA1lC2CP4m0gIpn6rR4nwFkeQcwTjDHzmOkOPqls8Q9yHExqb9LzrWsf0fjyi8QVjJj1QWrhtWhnmrvH9EwXR4G5wz+oCbMlVjEpzBGGHD58YfBd2eM50rzU6s6OU+ly0CnGm53A1TqUqeqN1eEcT/0Lafpwfr4co/jji0hAb8A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Please split this into the writeback infrastructure and an XFS patch.
Adding infrastructure and the user in the same patch is really annoying
for bisecting, reverting or even just reading commit logs.

