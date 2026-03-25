Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15B69109C036
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 16:23:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B9676B0092; Wed, 25 Mar 2026 12:23:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 690A46B0093; Wed, 25 Mar 2026 12:23:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CD7F6B0095; Wed, 25 Mar 2026 12:23:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4DDAA6B0092
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 12:23:58 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 191391A0A4E
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 16:23:58 +0000 (UTC)
X-FDA: 84585106956.29.ADF4AEA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id EE03240017
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 16:23:55 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="S5xlII/e";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf11.hostedemail.com: domain of audra@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=audra@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774455836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3wC6baJp6zL608VaSymAAbIsY7ajVAj3x88sWAoRz70=;
	b=JP5Br8y4AtoeJWzgIxvQBVIeU69Z48KvHz0tmveARizUq0Ec60efGaIQYt81jVdDSrmeQF
	Qs/mo3NJAzZGSykSuB6OCeMb5N8cEyKMtELC8wA1bqgNZPrURdjV5g8Ig/+h2Fh/lcpJTk
	DgLmb4BJigq+drC4NI59pGvdOvDGVAQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774455836; a=rsa-sha256;
	cv=none;
	b=nyIsnPxIi6Cj0wsB8hBpM2YhFgPe9BGKoC3XkUu2GKZUqZVt/yn6IpAKlkr/vS/BrzRL9s
	u2BztYLvFg/H7AbbVDjSrYfxHbnAuSfNR5bX+2+XTah5XndQDmiqKOeDbu4qagUq5bY2mz
	sUQCwA6mA3u6HtHWlBQrbDc3HccS6ko=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="S5xlII/e";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf11.hostedemail.com: domain of audra@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=audra@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774455835;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3wC6baJp6zL608VaSymAAbIsY7ajVAj3x88sWAoRz70=;
	b=S5xlII/eeKsZ4+TvzqTFJp9j0+2N2nfZD/sXPDVmXH7OD/Op0m9a0rVhGevnEoxcezfz4d
	yGviXqf1Q7Hew+nKbhJ/vIb61mv3i+bB+7dZtfcHxSm5a7EMJtOVxK34pC9MDucEgMKISP
	skpnI2WFNLO7xJJQVPvBeheofZBgU8E=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-257-g4v1uGoEP_eWbXKoQ_7gpQ-1; Wed,
 25 Mar 2026 12:23:50 -0400
X-MC-Unique: g4v1uGoEP_eWbXKoQ_7gpQ-1
X-Mimecast-MFC-AGG-ID: g4v1uGoEP_eWbXKoQ_7gpQ_1774455828
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 39DAF195608E;
	Wed, 25 Mar 2026 16:23:48 +0000 (UTC)
Received: from fedora (unknown [10.22.81.79])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 87790300019F;
	Wed, 25 Mar 2026 16:23:44 +0000 (UTC)
Date: Wed, 25 Mar 2026 12:23:41 -0400
From: Audra Mitchell <audra@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, ljs@kernel.org,
	Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, shuah@kernel.org,
	usama.anjum@collabora.com, colin.i.king@gmail.com,
	avagin@google.com, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: Fix soft-dirty kselftest supported check
Message-ID: <acQMDW9qM2MtYpkT@fedora>
References: <f7fef55d-4334-4d1d-b6c6-b409fea7e2a1@kernel.org>
 <20260320184010.759461-1-audra@redhat.com>
 <20260320184010.759461-2-audra@redhat.com>
 <a4fb1d56-8c10-46de-acf5-9a00ce0db4ad@kernel.org>
 <20260324162324.6efa49422d145afd4dd37dda@linux-foundation.org>
 <20260324162445.fb353f4d2c85d89bc25be03a@linux-foundation.org>
MIME-Version: 1.0
In-Reply-To: <20260324162445.fb353f4d2c85d89bc25be03a@linux-foundation.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: 2gohf-zrg75sKM8jiBr0HhFC4l3XtpJQhddhdCrOfYc_1774455828
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: EE03240017
X-Stat-Signature: rtgb17n68gq6fksc6xdmtsfb6dc655r3
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774455835-224915
X-HE-Meta: U2FsdGVkX19iy7RUzhifudLnr9GOCyQJ6USA1gwSTXqQxRX8Q7Z+PsHukR18JxIoc5oJWluwRpc5KU7+xwavrWEYOrJngVpVUdVZ2DPcpnGKZcdV/7cJachMxh9DK9t4MsKl+hk/bA9ELhV6ES1AH1HRvn86muZuveIuMzRNCffkz4wH7eOkU0uGpv35ndi6rxFPYzvrgqiEZfrT/j2a1+WkP4FPtwsW/3DePZiP4titQEp1xO1X96xla0a1QM+bv4mbOzIDjP6ZjVGuBRaT+hHvn18AyWumXgJYMwgTWAnEks73Y3F90+eTbHEtVl97YEAokMFq8lmOwEJFHwxZVN0R8oA/iLWw1LjdKmxZ9OKTtpq1s+bDs2jpd9Lf0hCdzZH46HIaqEthT4VW6IW4FeYW3hi23dlPzlQ+JttDwB2cC79htcIWQtU7P4kuUkLOM3SYd4WQX+u/mK4mXiHxdsH3XZCxgEslOsh1eOep75LRHrY0w4geoEkF5XaVVhhqd+dMWFS8B+WkkAb4uth67w8eRzYXLngZRJraq4PdBHX6cwkNi8e3gcRVnj/10WnF+GjRgJz1W99QJv10IixZdXddNGdLL2mkVFMmYqQXUJ82ZDzw13GKIYeEySnjKXXeT7QrtgvYHlMlm0MWGa8trfKVQkMQY5dOGBM0uuHclXj5TAjUm5sj0IS+zcLecQW1Q5EIkhlCWBlfFqyJMMgoS9onK3j8lW+pF+mIipFjoZa3ABrQfmiOFdmcatGnwNhI7Ooabd30xZl6qpctCB1x91GR2+fEJX0d3qCxCDzcdSwvdjj9ashEPOTyLQp9VzlIOMbA6e3gsJRuXMa/j6jDKJcL1UzKOj/j14RK23dAPm1jpEF0Q+0UUywoSB2+/4tHWBtKYRRImf/9oS85GmScZqsPXlTv777fW5IIO0Lx6EVkVtZiYqDaXZGvZSN/4JvPzjv59huxpnKf8uJ4x5X
 PBrg/EMI
 cpNE6zslN9vVTMAD/H1VqmnNz+yfYpEjlKdtsZzsEw145ul9lVzI3xauOBG3nnnQtajKJmqrMi/XJJVuxBP1ryorGDj2bTAgH68GqphOVFH1dbnKiiXAISAGFookbedJhjRKM1etWFLIXUMUzZ/5CPJekR7F14DkOQEcNpzxowLXSNKBPw297UmBrqbzWSSc65TkZQS7Soey0gim4uZ26FNEHanpK3mOxtENCyj85kcOKTALPrD+5lnQ+5kwviYX2UJTCHlQ/dUudi1+LqZKDjWu/JAZHhJJ20vPdrX8L62ofCM85XQF+Sp6WZN6ZOTSrMQCEXB6D2Jk6lB9EuW4HkArrPj3r+Nj5MnN3ATfCwhmclZbiWNiETFg4mP5IKIKtCel+jhfTZUmTxsp+MNNGZjjfXAckK4s9w4qiUDL6TU+d3OXioA4oVq24UVjfRNWObydBVwPZMUtXwCG/yLmK1EGbzA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 24, 2026 at 04:24:45PM -0700, Andrew Morton wrote:
> On Tue, 24 Mar 2026 16:23:24 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Mon, 23 Mar 2026 12:56:33 +0100 "David Hildenbrand (Arm)" <david@kernel.org> wrote:
> > 
> > > > +		supported = __pagemap_scan_get_categories(fd, test_area, &r) >= 0;
> > > 
> > > You have to cast it to a (long) first before comparing, like we do in
> > > pagemap_scan_get_categories().
> > > 
> > > 
> > > Maybe best written as
> > > 
> > > 	long ret = __pagemap_scan_get_categories(fd, test_area, &r);
> > > 
> > > 	if (ret >= 0)
> > > 		supported = 1;
> > > 
> > > > +		ksft_print_msg("errno: %d\n", errno);
> > > 
> > > I guess we should drop that, was mostly for testing.

Wouldn't it be prudent to also update __pagemap_scan_get_categories
return type to a long? Right now its uint64_t, but we expect a long
to be returned from the ioctl:

	static long do_pagemap_cmd(struct file *file, unsigned int cmd,
                           unsigned long arg)

I've made the other changes, but I'll wait to push the next version after
this feedback. Thanks!


