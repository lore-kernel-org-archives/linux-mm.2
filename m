Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0A6AF36C26
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 06:43:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 235F86B00FC; Mon, 20 Apr 2026 02:43:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20D716B00FE; Mon, 20 Apr 2026 02:43:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14AD06B0100; Mon, 20 Apr 2026 02:43:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 03ED46B00FC
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 02:43:12 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CE353BB9EA
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 06:43:11 +0000 (UTC)
X-FDA: 84677992182.26.7C311E2
Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	by imf20.hostedemail.com (Postfix) with ESMTP id 15BB01C000C
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 06:43:09 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=msxtn0YP;
	spf=pass (imf20.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net;
	dmarc=pass (policy=none) header.from=lwn.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776667390; a=rsa-sha256;
	cv=none;
	b=8V4qn4mgAYHJ/w0MC3m+geofTu++UasdiRE3H873/bJV2rRmIW3teCA9nrKnf7RG0YdJmz
	Za8u+AMyft1YvJn2R+O5yQG5aWUYLG3ek83eVp+7vOskWXwRHzNg1OzWeGGz6Fw7iviO4T
	tMyp1q8tWwHS4+KiDM9BWJXlqOUIQlk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=msxtn0YP;
	spf=pass (imf20.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net;
	dmarc=pass (policy=none) header.from=lwn.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776667390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V5lG/8qmPRfYfae2xaMBCimH8dzHHT9YQ6vuqn5alsA=;
	b=iT+lmHHmTsD9SXDl5yRbT0YKYjFZAUkSHEHSxAgWXLnVzTIv3M+d6h7wG5n7pIhyPc/rH3
	jTlj9h8+E6YRISO7C1LPTKGldz7B01mUhIDu9hhdu54RG/LuwotUSl33xo53sw0K79I7sI
	udYdbs9DDXonnN66DknvSFMOVdLzM1o=
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net B758840B0C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1776667388; bh=V5lG/8qmPRfYfae2xaMBCimH8dzHHT9YQ6vuqn5alsA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=msxtn0YPMQuEkjC0+TmQ7PhHZeony/csdrctHIRBk19ZSiHKHjDmHa5SO504GoGpd
	 d7bOH1qphYfGLX2JRWeKaY0H7yekdAwV7tbI0M/Jsq4fJ5CWuW5xEkBz25qSJF2fBr
	 kwWHl5n6rdHnNVBybJu2TAyd8SPcphF7PxPQ2HB6f5/VOdp6PjR67pRLdeKg5mFh5D
	 buFt/ED6qTq95DxWFkFKn+VUOSC4MMPrVCMfZh4NQk8GT7Mk6oNoQqJ5Uk2+h3bABG
	 cg9cGKuDm0Hr0w7M2BMgp138sVywE3J94TDR4Y72BJ2FrRwiowWfw3cg670HkTzkcX
	 pGXZecpQ15y7w==
Received: from localhost (mdns.lwn.net [45.79.72.68])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id B758840B0C;
	Mon, 20 Apr 2026 06:43:06 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Nick Huang <sef1548@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Matthew Wilcox
 <willy@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Harry Yoo
 <harry@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Hao Li
 <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, David Rientjes
 <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, "Liam R
 . Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <skhan@linuxfoundation.org>, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] docs: Add overview and SLUB allocator sections to slab
 documentation
In-Reply-To: <CABZAGRHXtjzGJrgR1NAmVHFMP9eL5zZr3DaTAtAvywv_1sOHdw@mail.gmail.com>
References: <20260418000635.17499-1-sef1548@gmail.com>
 <aeNGbNyPxJssnkbO@lucifer> <aeOuCH8ydw_yzdXZ@casper.infradead.org>
 <c113f667-f897-42cc-a0e5-b8a0bbd91be3@kernel.org>
 <aeTTw4gziJigaNbU@lucifer>
 <CABZAGRHXtjzGJrgR1NAmVHFMP9eL5zZr3DaTAtAvywv_1sOHdw@mail.gmail.com>
Date: Mon, 20 Apr 2026 00:43:03 -0600
Message-ID: <87jyu2w2rs.fsf@trenco.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 15BB01C000C
X-Stat-Signature: 6ofsejqt7r8d3xz3tkok718a88jrh74s
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776667389-509692
X-HE-Meta: U2FsdGVkX1/92eMUVvjIQu6BQd+kkP8LZfK40tppU8aunSK4dSBJPh5TIVyvbCC7g2MqxeJ8+okSr67cUBuZuRccUkFF2krO+PgS7u2vskFv30OrYg06gxcXXi+WdGWc9Qk7H0X1YyNrihCCy1q0cPGDgp48Va0Us5neZCDbu7WrcwwqBEIDUtvj9GlrQRemlK+S1wsLcUQZzG1eGln5hcqVOECX4yU6zimCuLxuZU/rs7PpvqSZe9UuhJHo6YP0nJqpXX6iRN2J7uYWnrXAUdOuzJjq+N/sJSCkgCGdwEF+GqPYcr6w4WgNtYs4kVs96n0YDxmpw60yu0WZYPilFFb2g8c/DcvqIPVEnAznZ3djNHkaGoLlvXzs/B4jws4q7lEOOZtUBXKbDy4XWqtUc8JHitBJgDHiy8kyRPHnAe2rjHBdH/LG0SWyKSyOARNAHFes4Dmw6283Mfo/MYxIXaGkBXZENCeHAg+2hoC7ikLlVkfhNDZllTVUs5KrUAE+XFjoFXw8zGQ7ZSgjL0JIr34dAZyBjyP2HcDEWfatNDp0GVq2SjIAbSTxf98imH8FjXCkxpm/AebEDBIFjPsIkS4hdUvqZNMI7H9J0VNYbPnmlg0OdtZPJs04fU1tSKNmXCzxjvf3X5+RP+W9zuCMu9SptNd8j6woq/jnntV7lTsIktWUKQfWt8DG+KO/Z3fy0xhkugMC3/hsFZRDa7IKAhAuJArYZrJAXZoVNCMPvpoZ4lAHoY2xMXeOYZc2uEU8vGwy9HcQdEv9hSV+YEordH9nEUUmRoQakkiMDgdyB0bTdcR76aG/10QxX1Dgr8erYurSRzPN781+H/8AYfNYIiG4DxXlXOyot3AGapBFCJpD/3CRvxtdT2JLK7EUypaD5ahFtIdNQDHiSXCslAol/Mn/g9kNykRnSKz0wbUMwAZJezwrxebZaNKcpUUJDFhjh0nI8kfIx3w9oCXFHdp
 KxDrGlgO
 rc1vqWtQlen0r4WalbY04RRS+NTbwOVhiztd9Gu0Q8HtMwqwiHdTWkmvGLdg6XydL+KEw13Y6ZzDsEV3msl6ZP8Zrd8ZdCavMCjOAuxQzVKzQ0KforXb3TlqYoX9ww3emWxM1AxT8cXh4dcsGFaFpntRxas9BdBWj7JML11iLmXBmnSy7XbWfUp4TTSOu7NF+hIEIIE/pAvIWvsksR1VFH9kf9ATaML9h718oTAJG/i5cQiKz8EH4x/UxGI6KLkZXq8/eLQTlRETQR8t8st9Uctd43jOV0Ts/A2g5eZ3yXEXpoQm2WXOWwF0gu3RVrIrKGSknKr9c1E2JMT2tbNfU//8Uhg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Nick Huang <sef1548@gmail.com> writes:

> I am really sorry for causing trouble for everyone. I would like to
> ask which aspect of mine was disrespectful, so that I can be more
> careful next time.
>
> If I want to make this kind of change, should I send an [RFC patch] to
> ask for everyone's opinion?

If you want to be respectful, start by reading what has been sent to
you; the problems with your submission were well explained, more than
once.

To reiterate:

- Do not send LLM-generated material without marking it as such as
  described in our developer documentation.

- Do not attempt to document systems that you do not, yourself,
  understand; you have no hope of getting it right, and you will only
  succeed in wasting the time of the people who have to review your
  changes.

The point of documentation is to be informative, accurate, and useful;
simply filling in a bunch of words is not helpful to anybody.

Thanks,

jon

