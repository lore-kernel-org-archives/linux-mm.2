Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA84DC61DFD
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 23:31:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4A836B0088; Mon, 31 Aug 2026 19:31:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FB866B008A; Mon, 31 Aug 2026 19:31:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 911226B0096; Mon, 31 Aug 2026 19:31:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6FBE66B0088
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 19:31:23 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F318DA30F7
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 23:31:22 +0000 (UTC)
X-FDA: 85163163204.01.D7D4955
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 445472000F
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 23:31:21 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Zg07NLIH;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788219081;
	b=DB5nlDtQIxe3RInSECaA25TMmd2deyDnldRv5LuCTKZkIfpfE7Oun5NYdeBJUsgVtZofP1
	0YV1qO7KqjF5Lo9aRidY7uHQ0Ke4n7VBWbDmjJjNbTWQ/KJdUcZ35tQwNcOGRr/4zSmUOQ
	MSGkP05LpAFL4sjY5aYpAEeIjhnWZts=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Zg07NLIH;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788219081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jizsFETCWcLjtbHiJF9W08hqM5CBVKybdf/GQ2X6ALI=;
	b=xtaU/BMYTC/cK3NxRAF9Sd45n+j7vTlNKSR2SKdb3NKoxnvZSauD/avYyk5nADyi1GxlO0
	hIaXOUVbO29ltYe0ODiihyPc9ZaB5kglF+yOnXUCnzVqPhfwk6wfjYFeH7sdZLJB0JcQrT
	JFkzX/nHzQOW0+zt5+pYV+HOmJGkwcc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 571FF40479;
	Mon, 31 Aug 2026 23:31:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DD351F000E9;
	Mon, 31 Aug 2026 23:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788219080;
	bh=jizsFETCWcLjtbHiJF9W08hqM5CBVKybdf/GQ2X6ALI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Zg07NLIHLvXKjITd2jS6CzCbIu0ABOpMuUX0qsGivAZ6HN5JAgik4Z7hYq3tAXt0L
	 luxyGGooi1iSkwnUYX4fwRzZqNpQ0zh8Ki4dpS5aixZ1hOeYohpKdX3zi68UYMN41b
	 xZJYEbqMSW5Ogq9nhfYJqjW0Ain6xsCNjQPhU1Io=
Date: Mon, 31 Aug 2026 16:31:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: SJ Park <sj@kernel.org>
Cc: damon@lists.linux.dev, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Enze Li <lienze@kylinos.cn>
Subject: Re: [PATCH 2/7] mm/damon/core: introduce damon_set_target_pid()
Message-Id: <20260831163119.66bcfdd8a4ee66b3609be63a@linux-foundation.org>
In-Reply-To: <20260831142611.77572-3-sj@kernel.org>
References: <20260831142611.77572-1-sj@kernel.org>
	<20260831142611.77572-3-sj@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: ebx6fyjqtpiexpqzpts35omthzto8i8r
X-Rspamd-Queue-Id: 445472000F
X-Rspamd-Server: rspam06
X-HE-Tag: 1788219081-170741
X-HE-Meta: U2FsdGVkX1/Yx6JM+NNKlX1/CL+Trbq2vHeCLfAbMd9wIcwcjUY/wA0vbqivY5AmSjfKRIwD6/5AZFFW0jwY/ab5xxA59OzEkvp2jVe1O4+C8qqWW2kFBvxoVvbiHTlyZpHd4OrtEVe+Bk9w6IoTkLwF0L/7Ja8nAV5js8fQ4PHiZsoKNOqK7fllMhbRhJRC9keYEmS0RbvLTFozfii5i43TTm994iq5QKFP0ij9OlwK4pDbnrKgk9aTLhHODE95nHMPAlh6RgRC/ern/t5ngNYDS3Jdx4xZDE3PGL2zS3xI05Rce7jjgOXP3vEa1NWnPPjqVdm500ig/n2Fxl1W5aPFPSpGhGH8MBBqPZBNiUoDb15kznPORGJ4zXZxv6xP8VxzSxfw6iNmD4n67nP6iW6kcUHa0Akbh3EYgBYnh4S/UdTPJCj/zX8fBKsazznuneJ0MtA5pQLPS2DFhFknLvYeIH6c50f7z/JEgjKE2e3tDIaq+zIxeKDcNIZjUAz46/A2LpVo56Ev4cVko5L/ZSfbOei+A+2EWT1V8aaawdN1WfWfsjtUodAttdm3olNI3LFOkGQ5GQPrM08WEiRlF7Jz0xSKYpOSEkhNM0oNTZ1IxUYINEVxe13MD/rLVhbdRu8x6p7I/q6XJv54ezHivLOZASvn9zHLKr59XeVciXm60oNg8IVFQEa5UBLVw5iBEjY0aUf/DKdqlcogg/ifdRsdeamJsjm3XT6SszeIwJ2Lm4eFoBdA4oVwGKhnw7OCTsNMKhh6KvvwyfRi5a4S0+4pKiT8rHU2bpQGtaxGhoa4MgDWqn3s38WHNCir9bPFsd0U4q3TkkR3PWrqHLwOptteRXJmZfoPqmclriWzpYMyxG8JNuHCbPXXLy/qED1fyU+T8q1aMeSa053TIzyTmnD6oyPY+Yq9b2wAa6W4zMzRZRQd+x4eI6kmk26RcBQd9TemG2vvErXlLPCBc0D
 XBgrxqFt
 qRzzyKsBh+6BFsSjghrjWbu0BQXudqm3plTEtV5Bd1HeWboeZLcXfLV5RlnvVsAFRGJcqQzeYkBeQQ/EYFbIh7VVL3gQIdMRIkkb2aBT2Ek+h1b/Mo2ij7nrovmxfpk6vioMP7VdT90i5HUYV4gsXmLFNMBMV6gKMwZ827MfS0wGqZAb/crQl9biiSkipIDiulbMHUv3CO5pBufre45HfymSvMdj3HsWrWnrBajqZcd7U6a/nWA+eV0U4/CdMTUk3FMBiAjTskjrkvoX7Uws0jIi9+dVb1nyE53axzX6H1RTbj4TqdWeasCPDd5CdcRKWrr9o
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 31 Aug 2026 07:26:04 -0700 SJ Park <sj@kernel.org> wrote:

> The logic that finds the struct pid for a given pid number and assigns
> it to a damon_target is duplicated in multiple places.  Including
> damon_sysfs_add_target() of mm/damon/sysfs.c and the start functions
> of the two sample modules, samples/damon/wsse.c and
> samples/damon/prcl.c.  Add a function that does the work, and replace
> the duplicated code in the places with calls to the function.
> 
> Signed-off-by: Enze Li <lienze@kylinos.cn>
> Reviewed-by: SJ Park <sj@kernel.org>
> Signed-off-by: SJ Park <sj@kernel.org>

I assumed that From:Enze was intended here.


