Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9B67FB44A4
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 04:43:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E513B6B0005; Fri, 24 Apr 2026 00:42:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E024D6B008A; Fri, 24 Apr 2026 00:42:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D18736B008C; Fri, 24 Apr 2026 00:42:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BAF746B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 00:42:59 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2E72F1408FC
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 04:42:59 +0000 (UTC)
X-FDA: 84692204478.02.F0A5F9F
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf13.hostedemail.com (Postfix) with ESMTP id EF53C20014
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 04:42:56 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Kbiijk54;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf13.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777005777; a=rsa-sha256;
	cv=none;
	b=y68GSzWT1Yg5o5gum2titJamcSCx1UJJXLGvgizmO3YGZ7PghaCb3kSiiW7+OEiSfst0Tw
	A2XyH3OHRiXYf+MhuNS/U9tpd4aSxtFz23ACbdq/Hi3IBrse/vxV6whAxraL2MNpekNk22
	HTjK8G/aYmDHxkJpEelSuSm6CbwEQWk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Kbiijk54;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf13.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777005777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nyj2WsHXFPwctrSxcnhOp/0wk9Vt/byD37DZzhUxKVI=;
	b=m2wkLrfhDuN9DXVecqWw8EFrQ0H39i8PwFFzU9sBjxHBwQC/sqzj3QIR6HueanIucK8jwm
	cs8O11c+JVxuRUDIuYtH3sgnYs/dtZb6bP2CElSkz527PTEDkFAQXDMY6282FNBK59xLIu
	sp05mgsodVfsowkoO5YBqPkiwE8u9dk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Nyj2WsHXFPwctrSxcnhOp/0wk9Vt/byD37DZzhUxKVI=; b=Kbiijk54PXxY9Ic1GyBHL2Yey3
	AnpgsWSdVfsYADBnW798Z0yD9n+uxJcSg81PbynvU29s92MTtg6TKeAIgqSEja5M+jcIv2Ur3Vjly
	PoF+Z7Eryc23YXBnPcjYby9Um6qo2A3z08r5pdO4vOwHS9+ZIPTSKb3FUTvZj74p58u1/3/D3v3gO
	UUe84dT9hpyj3yKPDQV7Jz4iodNoD3kd0UZ22kCwjPPB1hTS6ZYLc9acDa95Zl8byDi5eGyifENq1
	M2KCT7AVDuQwIJmwFJGRFhrMsRDq3h+NwXzdwj3lL7TB5kiGGuUUnYbC3QhwRc5htVUvMTPI/KmGp
	ADYnoHeg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wG8NF-0000000EaFn-2Mtw;
	Fri, 24 Apr 2026 04:42:41 +0000
Date: Fri, 24 Apr 2026 05:42:41 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Ritesh Harjani <ritesh.list@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>,
	lsf-pc@lists.linux-foundation.org, Jan Kara <jack@suse.cz>,
	Amir Goldstein <amir73il@gmail.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Pankaj Raghav <pankaj.raghav@linux.dev>,
	Andres Freund <andres@anarazel.de>, djwong@kernel.org,
	john.g.garry@oracle.com, hch@lst.de,
	Luis Chamberlain <mcgrof@kernel.org>, dchinner@redhat.com,
	Javier Gonzalez <javier.gonz@samsung.com>, gost.dev@samsung.com,
	tytso@mit.edu, p.raghav@samsung.com, vi.shah@samsung.com,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [LSF/MM/BPF TOPIC] Buffered atomic writes
Message-ID: <aer0wd2Ig0hjN3R0@casper.infradead.org>
References: <d0c4d95b-8064-4a7e-996d-7ad40eb4976b@linux.dev>
 <wlxxrx10.ritesh.list@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <wlxxrx10.ritesh.list@gmail.com>
X-Rspamd-Server: rspam10
X-Stat-Signature: kn5s4gjx1u169ghkii3gsyo93fnqdm9h
X-Rspam-User: 
X-Rspamd-Queue-Id: EF53C20014
X-HE-Tag: 1777005776-776952
X-HE-Meta: U2FsdGVkX18P0jcsrrZgd066qtxH/WuIfHUPwmjCZVexoXrtMAB2Zm6HMR3AhPbELvzq2kdLFnG/TQD8yVkUNc+hq3Oo6bDyb23j0lH0hgeqQBocilcQsmyUZglSKkOg/q77DZsAfVKnZnlI3mpSV3iS6PYNXFh78XofYm4BRS7NI/BZ0SVidAIIg7QLm6CXTrVT7ucUt1SxF3JFTvo+7wh/Jt5A39lhrxBS9FkYAabM65GcX6m4om5QVKFcmzNUupiQVbHzUFuk9DEBv1BAFKW91OmzhjC/1VIJbf2Je8LbTZo6JrwVEmv2Qoz23RkeR7AWme5u/vhl6Qmcmout5qqNSu8lw/Z+dpy8OdzCjO54KyrUcrFC5z59vB4rQmt4uAHa2yZs0XM6rK8bOwckbWQ8Oa7Nom1bF1xOGT6bv02wK5tmO8vwb167eHfJmuyRKcRI+2qj0KRvcU4gCqULIGYN5F5rex9fUOwMjTDmwl72wVJyaA+7AlSIfhPwzcAfaESWlPoYhxxSV0RKK/gOr1FDvci/kBROi846RDEyAnLl4b6ReskuogjnoLdvBbYpDBmzRhOuJllt5UOgV/eJ4dgSZAD/TP5CwRYoYLfNllEktULEE7J8vbBzPpntZisLmmek7FYzDbmZ9V7qt3bxnpg0PG0aBgHSlugLbi8cYAj/tRG2rE8Mkw1S7RFryqR+4kbrRZDdULwHm1ZX4qT2KX3boiR+uuHMvnvYB0vltWl25OIQ72yZmNEnHnsEJtZ+qm/gbjA5Wrn5dDW6VQgIsA/JmkxxXoivZuETGm02qK6jE17kdyyuE7tU2QQMnnrnHPDaE3innoB9NHNWcaWcfnIuMNLA4NI2HX6iaDy2ckjBcA7mX6bLaxkJgxv6HFYCjiRxQMVXBfXIX4/ojpOcDRdvXfb4bLoWnCaFBPfut181YDu1xgIGZW5DK5se+ogaxdZr+BlI2brlxjjZfM0
 04wWxYEa
 4z3X3q8p8yJctHqm7Bgh3WPp/nIA25bwavKhy45Tc41xufPOLgIGyxnyMUvxyfp/Z+hflvs9O/U6CMDXMaeFBgaOkFgvf3RC0SWU5E8uFWhru/DVcqAZn0EZwER164xBpZbAuyKfa/glmadCMIJ7qNnr8tRqNrwb/6jVybw3cSMvEy8Gw35DsYSCYXaqR9sZ/eXjQq8YGjzsG7sCqCvX2ummmNPzYmL0mjKb8XvMSS6I7wuvkdSAHzmXZGDkoJ0abYg/+uYVFyU03n5y20fHZQd7C2AGW7yIJJCjXuIO1lpT5Bwp5cHoFUtO8x3/7Aty+m/WBK9R8ctqwbXQgOq2uJkEf37JlH0A3DggI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24, 2026 at 06:32:03AM +0530, Ritesh Harjani wrote:
> We were thinking if it is possible to extend the Buffered Atomic Write
> session into two "continuous" halves of 30mins each (total of 60mins)?

This is painful because you've requested me, plus both Storage and FS.
FS has lots of space, but I don't, and Storage is also pretty full.

Do you need me for the full hour or just half of it?


