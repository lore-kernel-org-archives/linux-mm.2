Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABB00CCA462
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 00:00:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A5DF6B0095; Thu, 15 Oct 2026 20:00:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77DE86B0096; Thu, 15 Oct 2026 20:00:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BB8B6B0098; Thu, 15 Oct 2026 20:00:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4CF6B6B0095
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 20:00:17 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BD4E21A020B
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 00:00:16 +0000 (UTC)
X-FDA: 85326532032.29.FAFE9E8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 07D80A000C
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 00:00:14 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iQLV5NhH;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792108815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uxYyInMrHnqPkah88WKwwT/87RgbFDAoJpgskmZyYkU=;
	b=tIxqL4GD0Y4ElFGYoEJF4pMHsJJJcKThmmIb+8LQyKKde9KQpsyMIjJmZCZ8nzLo9p22de
	uW55vssw81oo/h6WuXXgwwWzhdjHHMD9YQ34lSFMUOBIj7Fqiw617Xd1f3p5DBgqi7We80
	JMcy5iecS/p/oLPhz17QJNBn2pV8nRk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792108815;
	b=RMpqG6igyPEAILkP2nJKvuVmvgqp0EXrfe1/6T4LiEhUzNoYVltYmVJal//zDnmdyRD+0d
	nuqFsnTK46MxXyPs8dM0m9L6qgiqZS3N1/w+Rf1Ty1mFqOaVOQ27+16OD1lgjNWhx+jb5f
	wQRgNh4xcKu78Xx4F7AaRfbNFTeqHuk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iQLV5NhH;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2AE3B444F3;
	Fri, 16 Oct 2026 00:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82AC51F000C5;
	Fri, 16 Oct 2026 00:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792108814;
	bh=uxYyInMrHnqPkah88WKwwT/87RgbFDAoJpgskmZyYkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iQLV5NhHAXTYNg7fDwLNWKJrpd0kg5Ngwn4DyEuKGMScurqHk2xDIoChC6xIsmgm4
	 05b2wbwwR76Z4w5NgwDHiJSmrfpZaX1LuzXxrHzTIQxpr1LufBMxi077Sx6Ph1k+VI
	 m6CfSIZyV0siHZAcNa/zEkGIJ8/ecCXUJB4tnOCoQ2KbwJrVHiSPNEAXiprZjE2aha
	 sV09C15br4Ph75W5LL4QhCfe9hjSIEbe2OK8RLkvVygPvnYxL5NgHUdDswD3Tb1a9y
	 Bh/uAiHmlR68i/ERQz5YTzhYpZFzDLQHo6f848u65OsR0h44PTNbb+OxYOIrzMbbsP
	 qr3yGN5w49Lkw==
From: SJ Park <sj@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: exclude DAMON docs from MEMORY MANAGEMENT - MISC
Date: Thu, 15 Oct 2026 17:00:06 -0700
Message-ID: <20261016000006.113338-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261015-maint-mm-core-x-doc-damon-v1-1-226decb5cd0d@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 07D80A000C
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 69yg4fq756f6bse7nawre8kjrfbwa43q
X-HE-Tag: 1792108814-520777
X-HE-Meta: U2FsdGVkX181O3vEoQAOEDg+OwO9XqIxGv2Ndf6UmDDcYkXNrrunMq1EVMpb9spGdjaqxZ/l0IDerfjuiieFWq+qU6Va/gWVfLQ7I9KfVQUY2gmHQwM9Zak6hgyI54OMGgYyzbk4Ev4Hue+Apz/Wsh2zBwgygR3x5aJWwRkxJqU0ISjZMMMnMMv/3SVuvsJdNveFXbRJsym46bcmyp7TeaFm24yTo9CQ1R7QT00v3vK1uSHVtrGqtMXo+6oxrqmD5JFgjxoFs7AzU2TC/t6Oo9FDfja05B273HZvccsDJa4N2xQXCq+Pxe9w7Z6tI/okwyu+liXga2dbXa+lW3erxi0KJDK2dOgj6dN2rZEXQcQl2h7x+YFC+sxa5UPNyMge2vjOSEYXquw2hyhnTd6A+ZJRYR/K54axV0tI88NOtyuWpbKRK0hCQEGPvoal+zVr7nhIKuUlxCDs+baejtFbO3ceBdEQX6ctqo1BWnO/AE/CceR+E5ZPddfB1rPqigJMNQLT19IzQZmgUfRbJgvpZ2Mah6SehABDmWLFnXmjsU1ImIeb+Umo9vTbLHSHTnbLv7389kNi/HDAp30uvODrQkvLLyjEPKhjurAt3xgPizztC8gaydbqdForAjQQ3ewbXNwU8cuu/+5ZdH6JZpEHJpiXbt3sZGpD60LZWmix5T36dm4zZ43g5w4Hl/Pv3YQuP/AzJxXoW0udW9BTT8fhX7nM4stEcG0AXHosxl6yr5oW66kEKhlxX9cGWVmIucn9wMJ+nqJ70CTi6IKN6ZM7UzApy99+CiD0pknWLOfIsTn0IB/PX4zbr1Z3OzCkTycxmy7o4NgZcoJwrcj5RlQboCtwIRaBKgfUfsfCS/D/c66sHA/hdSL/WbvpAzLGhBzHeRS5LjlUGZ1HE8fEpeGlOtWoW6fT7a2rNUiOw5KHQul10IZuErXtRkBpG7P1KlnWKeGcHLiNamgOBt/Ctwk
 5kTzt28/
 gHn+EG59yrlAdf75Rg+gciW+dF5leQfflwhTznGMTHAhVwsenXcAmmPvAKICUNJHx1QEh5oSTsl79+k+4E3kaO7UpHz+cQdfHMSuGr1U4w3sntpXPFB9TNblvZAHKQpNwbAqzR7CgY8z+xxSRh4a/winscxGvl/fG2Az/9mwdPp2pzLQltOp2TNurc8d8/l9sR0P8AchveBziSazzPEaDJeeFrjbx8Oh3ufO9ckiNgLbcHn0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 15 Oct 2026 18:31:46 +0200 "Vlastimil Babka (SUSE)" <vbabka@kernel.org> wrote:

> MEMORY MANAGEMENT - MISC is a list of misc mm sources and also acts as
> catch-all for the mm Documentation subdirectories. Documentation for
> DAMON is well maintained within its own subsystem and also actively
> updated, so there's no need to Cc all MISC maintainers for them as well.
> Thus add exclusion entries for them.

Makes sense and sounds right to me.  I was also feeling maybe I'm Cc-ing too
many people and considering doing this.  Thank you for this patch, Vlastimil.

> 
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Acked-by: SJ Park <sj@kernel.org>

> ---
> I'd love to have the time to check the DAMON documentation changes, but
> it's simply not happening, so this will save some mail traffic for me,
> if others agree.

DAMON release newsletter [1] could be a lighter weight alternative :)

[1] https://lore.kernel.org/all/20260830235014.64406-1-sj@kernel.org/


Thanks,
SJ

[...]

