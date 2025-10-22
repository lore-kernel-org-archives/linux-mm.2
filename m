Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CCE2CCD1BF
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 20:31:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EE978E0016; Wed, 22 Oct 2025 16:31:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42BA08E0002; Wed, 22 Oct 2025 16:31:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31C278E0016; Wed, 22 Oct 2025 16:31:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 20F8F8E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 16:31:22 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E1EADC0967
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 20:31:21 +0000 (UTC)
X-FDA: 84026895162.03.0569CDC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 14ABC1C001A
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 20:31:19 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=w9q1klmY;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761165080;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tAMuvv2jJToCU9s5scd4snUpCy6dk/MJTbtSYnHmRbs=;
	b=2Fhy+dTb3ufvjt0ws+QsjkY1906SUjvdwZkQ288zs7vCNVCa6KZ0/sxjYB1l7jUoN4rCf0
	M8JBU3n9yDlg9BJ9UYRY2GsjN2aU3Nira0WTqbkZAS3Z4iOKU546InfcEpziC6pz7T5iB3
	cv7AZsXam8dZedY0Ws2R+2m5GmkX5hY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761165080; a=rsa-sha256;
	cv=none;
	b=zHfNS+DvBgMPpmHqyw3lhgtiqROOA4lgmQJjgn3pD4HkDBAUyZEESykEHk4vvhm6psYrSt
	I+stlv4/HgdmFNvv0Gdnuiyk1ds1bdZHUlxt5xoHcdIyJAh12vh+MjsB4ntKJP3IL5IbQ1
	cEjl1sal4gBgtYAkNfmZm73HDCSmKFs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=w9q1klmY;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D2B0F4049A;
	Wed, 22 Oct 2025 20:31:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83E17C4CEE7;
	Wed, 22 Oct 2025 20:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761165078;
	bh=PYBRJIE2AzLCJIOA5mxGioZu5kRAh7s6KYh05y8hKyw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=w9q1klmYoOXMFEprrdmvg9iJv/FQC1vDPcRutX+/g08xjqg//sOjy6qaMN0GdYz26
	 QQpoF7f9peB70xZ+Mro6WovAMtx9CKgGFjpAl3eZE9iBxM7sgYBXlBDFV3xFAILRP+
	 Eyki8vANrnKq539rP6uzfXklY4/n5U64tvBHC5yQ=
Date: Wed, 22 Oct 2025 13:31:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
Cc: David Hildenbrand <david@redhat.com>, Xu Xin <xu.xin16@zte.com.cn>,
 Chengming Zhou <chengming.zhou@linux.dev>, craftfever
 <craftfever@airmail.cc>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] ksm: use range-walk function to jump over holes in
 scan_get_next_rmap_item
Message-Id: <20251022133118.f13f924348e8cdc6d49ef268@linux-foundation.org>
In-Reply-To: <20251022153059.22763-1-pedrodemargomes@gmail.com>
References: <20251022153059.22763-1-pedrodemargomes@gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Stat-Signature: jqdxhqb7jxbrqfsak1afbrm15pn1mec4
X-Rspam-User: 
X-Rspamd-Queue-Id: 14ABC1C001A
X-HE-Tag: 1761165079-801837
X-HE-Meta: U2FsdGVkX1/5kxQFmhKYMTiGh7WUKi9a5eWD34Qrpe7iig/F9Fbq83nQR9EQ8qzzbgDdpsBUCB3g9THTjeIBAyBHSOEhLu+pcnhBo2skSsZNO+vkFSS9fEhOAybqrNROSn67h6WCPpXCnRZ7QX6vOIei4AWk4IJTUbkdIyLkLsG2bY8sNqgLS7gKvqeeNbWN2B/Uw1RIHCyaefcP5l96JxAaByW3xsYdeSS67yDAUOweCQNJXgpqxzhxrK6GiVBeQlfFQf6rVyshJRYAyfS3+sYcXu/k3sMUTqMZOv0JLm/FmGzC4D4MSsUMtxfUV9zUHFVo7MY/b5n5YOH2AwXBKjHmBSnA7PVd+fkxwqeasglj4XQI8J20wkl4Tc+3H88BROyFvZ+Fgkb9WAhRYyX3QeNDZgoMQiG1fdR8Hcx1IV6+NBhSNLqYozlVIDR1Cyt29XK1DQiwJLxOerzSP8LDX3+hjiPmiMa6/jPByypZhp/Zzb8qWWEmafq746kcP8qFQfo72XQky5NE3VWFPOjla8YXMyB5vPqOiv13oiJCMjMxtZ6JEjbaJcJiNX8RAQNUL2ZvaagdxkEENTWkp29L2fbXM3AoohGCpiM8DfAZqqW557dLcPqmgYItWnlfv08QiqU48cgWZ81TvQloeWafkEYrMuHCCAwRgWTz5fqEC/PWuzzxHUGqMEI2sZk6/M0VQO+3TeoLvL/RIBkXSUIOh35WCUvElUdZRBUlOezULXSYEpc5eu04xdXqtmMgyvyQ+ClakJO1pwnQv/1nCqcdvTjvSeYZbc+mGMfaY4p/pI7ZU/fT65L7Umjt0r3mh5YrfB7Qww0sIm+yjBO3QQQKcB7FyBrwqTHS4NUi3cznAff80tBUbMRc5pctMq1NbCFe/BoRYTt3npxbBwMky8It/2irFz0A0CPwbUQsMUqmxspKwZigBlHjDOaT4zgMR+A0TGeN+/iZSoBWAFAx1Ck
 EwD2+ov+
 KTA8mdEykE8UvGu/pXPgpV+38XQb8nnVEyqANB66cvA6hbzYbLebb6EJrN2fsR1GKSOyHojXgxTHQt3T/U/MBDCk4DpneCEMQUgClBp02+mUvfHFZ0x8kC/DtassatPoaKLkd6J2P1/3o6yElfKqjUc9ZdJzhQ1RDWhjmOdAy8vvIbqLaUeLs/0NCn7KSD933K21gVPNbBBz4V/2AFr7KWiUIvaqeTUXEXRrdcfBO63Ep8VNZ19aPOU1N7sfcOflGr4VY+ZOZwLLd4Sm4sjBnGpVM7h2oeTPD9Jwj3runNw1HKhEP1dwyM5reR31/QkDr/Yh/1uiuynxDsDM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 22 Oct 2025 12:30:59 -0300 Pedro Demarchi Gomes <pedrodemargomes@gmail.com> wrote:

> Currently, scan_get_next_rmap_item() walks every page address in a VMA
> to locate mergeable pages. This becomes highly inefficient when scanning
> large virtual memory areas that contain mostly unmapped regions.
> 
> This patch replaces the per-address lookup with a range walk using
> walk_page_range(). The range walker allows KSM to skip over entire
> unmapped holes in a VMA, avoiding unnecessary lookups.
> This problem was previously discussed in [1].
> 
> [1] https://lore.kernel.org/linux-mm/423de7a3-1c62-4e72-8e79-19a6413e420c@redhat.com/
> 

Thanks.  It would be helpful of the changelog were to tell people how
significant this change is for our users.

> Reported-by: craftfever <craftfever@airmail.cc>
> Closes: https://lkml.kernel.org/r/020cf8de6e773bb78ba7614ef250129f11a63781@murena.io

Buried in here is a claim that large amount of CPU are being used, but
nothing quantitative.

So is there something we can tell people who are looking at this patch
in Feb 2026 and wondering "hm, should I add that to our kernel"?

> Suggested-by: David Hildenbrand <david@redhat.com>
> Co-developed-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> Fixes: 31dbd01f3143 ("ksm: Kernel SamePage Merging")

If the observed runtime problem is bad enough then a cc:stable might be
justified.  But a description of that observed runtime behavior would
be needed for that, please.


