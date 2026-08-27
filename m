Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADAD4C61DC6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 13:00:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C79936B0088; Thu, 27 Aug 2026 09:00:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C51716B0096; Thu, 27 Aug 2026 09:00:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B67066B0098; Thu, 27 Aug 2026 09:00:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9D6BB6B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 09:00:31 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 24B5F1C1CB1
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 13:00:31 +0000 (UTC)
X-FDA: 85147058262.29.64F3D2B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 77B5D180010
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 13:00:29 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iV3Y2Zg9;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787835629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JpxE64pCg/b6rQY2y/7+EWlonBQjtPfHvkUtfZRNnco=;
	b=U6GV5vXj0OSxEPL3EUyv977f8SA1G7BXCooFU3b/lZRFtOzVcFGryPP+ztUSzsRonVhAdB
	Lu1ect3GKIe3o2btZxjx7+CmX1mqleCP30DNqGO4MPzq8Dz6Z+XEP1QA0JEYUIcMTV3B+3
	4T+2p+e+0bk7ZdgBGzWk3IpcjH22gec=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iV3Y2Zg9;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787835629;
	b=j5tEYRU3S7rxPt5gCrbPKNiCzApv2p9vwvKTFCMbgEWma1y3BL+ZO0GHRJHRgFf5+mctFs
	XU4AS8/G0FJll801UzXDb+Q0z/8YuVrOhGwoXbEybVNdjyeJr36KvEgXXj7v2WwFJbT1Zm
	lriB4LEr8CXln2KaubnUgzei2MULyyk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 952FE40064;
	Thu, 27 Aug 2026 13:00:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9289B1F000E9;
	Thu, 27 Aug 2026 13:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787835628;
	bh=JpxE64pCg/b6rQY2y/7+EWlonBQjtPfHvkUtfZRNnco=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iV3Y2Zg9DowDcuXBVS9IXr61ZZtETF747M8Iqyi7kLjfsMvd0YY496Hqa+DSEXpEM
	 1j6Ccq0rLIi/GhogrtbzZYAtlqxuMfB/DYNimp2XpgChMj7UG9maDAQw1Uyvcn5zrp
	 Ie3H0qyA9HYnGBtomZfi4d0mVnsUhJNQNrRtgq25Gdm+N5IPlG3ESnTCqE/WtEaDjG
	 wWBnQbFbO6EP/Lbs/LbrUE4BsIf/DtJB0zXR2QYckh8vIRE7ze/MiPA5PWrQmks3bl
	 LhRdO5ry2lDRrik7rRGLXnO+xIACalVsqdRkw/Jm38zLrUGMZoIKXwSfksum+yUFWf
	 Czy+NLkj4j4SQ==
Date: Thu, 27 Aug 2026 14:00:23 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH] MAINTAINERS: remove myself as THP co-maintainer
Message-ID: <apA0xfguYLQhv7R3@gremlin>
References: <20260826-drop-thp-maintainership-v1-1-3d102748fa17@kernel.org>
 <6293dc55-e69f-498c-8290-b85202db605e@kernel.org>
 <ao69UWWf0awFqIXD@gremlin>
 <DKYY5T6DL56L.312FCMNEL50R5@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DKYY5T6DL56L.312FCMNEL50R5@nvidia.com>
X-Stat-Signature: bh6s6jsua4pu6ancwqp8j5ts96mpi3im
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 77B5D180010
X-Rspam-User: 
X-HE-Tag: 1787835629-103245
X-HE-Meta: U2FsdGVkX18FPQj6ijbv9oQiwyRCSrCY+JMgpW1hyThkTqV1QQCpm95GmW/Av0bIPPCn9VYnM0PkqsRJR9K51JBrF6ViR3m0uEESiP/QzGaD4daVaN9/3po2GdibFoQD1a1TmDcHToDJWd7eNuCXaYB4t/S5Kd9DYwa839+RNiqlbM6tnxz4m9NCSG17vWAPumYlGu+vvr+p5Y3d5chCnKLw+4/4rbdcq1BmaWAbe7SjloRlX1BwR6l4O98wXdB/w4npYsxdubTmbyL+Gq5ZA7pn2Ey0pMnuC4nfWQmFgtxBg4jQCQKY4Rw2kadpKUXTXDGlfxCDC6ISZKbchO2m3QjkZNfSC/9YBdjo0LXhbCI8Ftal4qkL47EjbE98w0jCnrt1TXRZ/xXrkvnwfmqgC6XtHxXsiYpPgiUviZMI+lRpjYOc3i1XeJGBsHrLkzSZx7n6pCZ0yn9kQMagGKE07RJaqsByl3AEcYlNx7E5vGavkM46ccGC2uTbDPfv6gmSBeBUQxXIL2AQ6NV3CaSHmB8oXTxWxLJ7sFXA1sk374Se1Sqtj2x2x4KW09DSS7qMFZjl3QOc6wvW8kSjDDkBMo6SmAFZUdiINyPQqPLJUsH32fY5CBS38HAcjnVCEc/RSMFZnW5X1CsBqFBdKa50ps9PNezfdbC+oAob4IWGeVXL3SlOhH2FHZTJ9jXEu+d0VrX7tLqfDRNH3qnwElGNxiJH4/oGQKuozpTfy9iDt8JdX75lvLFooX5UJWYn3PfmBCWTbJQbjPu2H+c77oEAGOfEWRsu8e12Ph2OaYBOxtN/sFL403czlsFjWKNAB4o1HXDTyPYLQHfzMO3URyFM7q5jdMbhGw3cXOHTDXOVIEagmtCurS8kZR2z68HnabmTYQodrzxaEEigRatPP2jwlfYhrvOcvlElx5NQlc5zhvbOAV61/gkG0RmSMO/yvwGvnCExA1glRp2yb2E6xHq
 236SNNrS
 LmcyUxx1GQrl/8k22dn/nt7jDlO0bqWXdy0r0HR2f0wJtIfPT/Bxolk9cQzB/qRrv4XwOmG0CJjT6oGe0lg2oztjDsIsQgQQ4wKzoHIgNSGxmuR5EaC35aI0DAqL+RJaaB38FTwXRXqmEalkeufnaGR5Pg2JNC2SgEQEeHtAonbmhPej6vc8PMYh7oYxJdkXrCz8peS0UZlgoQ0WbErMlSuaIryz/An1SMEynSryTTeJtn75Q0jQfULWchzMmP+a0DOHK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 26, 2026 at 10:32:10AM -0400, Zi Yan wrote:
> Thank you for the kind words. I really enjoy working with you. Since you
> are still around, I am sure we will keep working together. :)

You're welcome, and absolutely :) and always feel free to ping if you want my
input of course!

--
Cheers, Lorenzo

