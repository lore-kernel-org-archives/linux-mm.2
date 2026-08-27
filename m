Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEFF2C61DC2
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 11:19:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAC586B0098; Thu, 27 Aug 2026 07:19:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5CAE6B0099; Thu, 27 Aug 2026 07:19:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B99D96B009B; Thu, 27 Aug 2026 07:19:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8C1436B0098
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 07:19:16 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 24127803EC
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 11:19:16 +0000 (UTC)
X-FDA: 85146803112.21.2A046AD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 85F7B20008
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 11:19:14 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="J/Ms9sjR";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787829554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XCzE3itXjJUxzC9B+6gmiKda5UI49/xCWZiO/v/Kk0Y=;
	b=XJxB0y7wJSEzkEEVJf8F9YehawVcJcHWU9H3XhLhGl+0uCkQCQl46++YBvsATj0xkG9kkB
	Pm+tKjsChee5v8tfInceJ3wQv/KqNB5oTI4ymsIM1aZkSAE6/sZcVxTujjK6cW9cfsSWJ/
	C+bEAW7j7hODPLgIe+qzWlX1L3nQtno=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="J/Ms9sjR";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787829554;
	b=uAVgUIl4vpkEM69wxdOs25ndx1BEc83K152DGxQIGJ1SxZbvJl7zkFhrqqfz+WTpt0fXBU
	gntb/aa4eWDjb+s1m6zZcqCZeHmwIH9EBK6Z2zbKsa0gw5ZSaSxx39XeHQ5/f/ptUEqwJ5
	etW21Eloq03Z3y8uRv4Wrhao06vziEI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BFC7241705;
	Thu, 27 Aug 2026 11:19:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89C5C1F000E9;
	Thu, 27 Aug 2026 11:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787829553;
	bh=XCzE3itXjJUxzC9B+6gmiKda5UI49/xCWZiO/v/Kk0Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=J/Ms9sjRIBOD4opV5PykseCnOEB0SJWT+HJFd0MvqGaqkJDDkvf0DskfhxvNVSN2s
	 kNOYwcEzbujP0zWdpjbs6Zhqj1nC5485I9R+IcIvO6jraO1Z3NBb0tH6WbbdCDV8Cl
	 ixS3HcqzCFy1rQQK/B1ajjeJSeeolKWuq9h14SeUO/E8Srk9afcX43d64mnxfFvXUI
	 NCu5VPATV3QYISml47k79SJEK6M/HgKU7D0+4zuuURiy0TR9uAL1YP3L9N9k8GhdTd
	 CmbdiVmcsL8FC93t5vcBXKbkYlLR0VGUVO5k8KkyU2zcv0KLdjfBlTs9JWBwhnhhzz
	 DUczcSUJO9dbw==
Date: Thu, 27 Aug 2026 12:19:08 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R . Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: add myself as a THP reviewer
Message-ID: <apAdICpnFIAUi0ny@gremlin>
References: <20260827103435.1371882-1-kas@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260827103435.1371882-1-kas@kernel.org>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 85F7B20008
X-Stat-Signature: 4ta3kow6dwh9i3j9rxctx7614e7hnb14
X-Rspam-User: 
X-HE-Tag: 1787829554-742312
X-HE-Meta: U2FsdGVkX1+Z6UX8NYRUpwPgiGuSy+FRHnZMXf4nn0cg92wJLCwfUhka/l7pifj9XP6Xg78oWwSAejinolx0KkOg1U2dz3ssFOm6lHnBoSJ3fsWYBupL7RNP0hL9z+h17Wa3MILmz/aejpCCqR46NGnVC8+T8lOegHUT1Q98ibrhqPlA4UnSaPuGrBNcZuE4vxZ2cZjQIP925cJEDKJP5v9mMJpHP6Ql6lpbadLMeNl7JTi6aWfphzzhoJsUyYYHpKmLhvWewghe9Je3mLLDyBfX4gJfnnEirTQZO1MVSPIfh+S95/rj+KvsPWYrzkmsC40l6zp50MM1b4gEqTAwVUTdM95y+AAyjLnoPDk1MVOSI/lxPHw0SJ+YKlOB3PUa436+FUDJKI90rHeF/k1na0Rke8WzxHYCV9cy7iihCnKhFs7SywJd/J48uhVLnfXG7yWjWfuobRlLMWxa6RYGeq3dLsvlvfL4zEi7Gvx8zAKK6i7njfvByvvgYkXLc09ri4Etm8UmCPdwN6pqd+oM5tBQu2ATlgjwAGn2L8euUwjG+bmmpwqvKEdatLyMqFlHx+LPbIEu+rcAzdX1y3RoTiwlMVF/8WIJlr6YOKQ4RGtSfhW03vS/NBN/LW1YuhMt2qal58CrWxTQTHYReenhkBAJlsQpDKy55eNYovRivJddSG21K8RilVswfybFBdffE6JwX6d/LuRJ35aH3bOv19rAKFwNtSFNsen6/ZoSYl90tzIk9YrJpPxpX3TRVXdXA74/GuFdu/bQWNJFCfGGHlQ/SQKFWp70rH6kdDUyebk+MAoWGHrlP+e21R7pPfTTXSObWJcQq4JR9lSoLqXMq7shdvC0ZRPGudEOsWXxtiwY2UpF2R/aEVrW3wF6PH9og4oMDc8kW1Cv6tZPPAfpJto7nFoQJHCP4NMo03egZSbX1Q4iQydCHKxu3yoJBHif5D3uNAl2kbamXqpA27A
 NsNlr6G2
 5yErk3mNTQbhOjBnhRhrp8pvyWS3uABKcfUQZn4/s+kPcTzDihqPPyNaQMS7NwF9+ivTEi2ZUjRoQ1cPWJEYaOVfkTrdQfB3w42PCTnZt/PkDi/edihUEJ7m2i86qubXZ6zlL5UK2NIcPlwmJeAIoXnPMgEy4XkXWnWVkwA7svqa47ig2GuQpelCiyEY7xQ9BaBjZwgf3mp8vr6dnDLMfiSVPlTWtaGJkOajfs67OU9uW1oFFeKFhjlZwsQCKzUrPsM6FBwx3BG+nZDLcujzhZdwvq2ieY2lSJq9/c2PKkQ96PJSM0VTnh0lUbTuppItdR9cfyo2z+6W1dqqkpQoEbxCmXZZq4eTDGuSnFj5AYcgUak7qITiAriCU3xI+KsiVTbklzjHnrcPm2Pxxs3xMX4FZL00CU4dAxrIDWNFv5eSxt0s79cVuU5M/N4vpGZ+RcEvD5v5T57s8dC4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 11:34:35AM +0100, Kiryl Shutsemau (Meta) wrote:
> I have been working on transparent hugepages since 2012, starting with
> the huge zero page and file-backed THP.  A lot of the code that causes
> pain now traces back to me.  It is only fair if I share the review load
> for THP.
>
> Add myself to the reviewer list so get_maintainer.pl puts me on Cc: as
> well.  It is also my commitment to be more active in reviewing this
> code.
>
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

Thanks :)

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 1be7da9b6e2e..f5bb29ba41c5 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17264,6 +17264,7 @@ R:	Dev Jain <dev.jain@arm.com>
>  R:	Barry Song <baohua@kernel.org>
>  R:	Lance Yang <lance.yang@linux.dev>
>  R:	Usama Arif <usama.arif@linux.dev>
> +R:	Kiryl Shutsemau <kas@kernel.org>
>  L:	linux-mm@kvack.org
>  S:	Maintained
>  W:	http://www.linux-mm.org
> --
> 2.54.0
>

--
Cheers, Lorenzo

