Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96179CCFA18
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 05:58:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2C328E0008; Thu, 13 Nov 2025 00:58:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E05178E0003; Thu, 13 Nov 2025 00:58:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D40F18E0008; Thu, 13 Nov 2025 00:58:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C28858E0003
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:58:06 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8F5F01A07CC
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 05:58:06 +0000 (UTC)
X-FDA: 84104528172.22.8085289
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf15.hostedemail.com (Postfix) with ESMTP id CB27BA0007
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 05:58:04 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf15.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763013485; a=rsa-sha256;
	cv=none;
	b=VEgSO8lRjqrk6Q52cVa5+aIiDRnPh/1lj5Ensa/u/hHM12nSCkXCNIjn31c3ai+z1Xfrti
	WUT/mdWZ3/kLNVX57yXxzHwjBkzFsipauO8hhdMudgErJsdxlNcgRN8q2gAD17aGpdN79r
	yriALHZrQxwvyBOI5n0Yhg8DYbnLbto=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf15.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763013485;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JKWBAyeIxHlTSXPkW7ON9aStxpB/OdKegHS47MxZbSs=;
	b=3hYZ57inVQk1hUoAw+xG2tJzPVpIvs78otNA9xCdJRTA2riqF+wFKHC4PpBuo5U0cPlB/B
	9Rydl2IXLZXc6/hpaKEpbIRpVGyPX0WVe+WvoXAbUersJQMfr6oOkP+S4U04VGFgWdnWbC
	gP3GQ37XbU+BGU4KN+gTBf81I4kStHA=
Received: by verein.lst.de (Postfix, from userid 2407)
	id BAF406732A; Thu, 13 Nov 2025 06:57:58 +0100 (CET)
Date: Thu, 13 Nov 2025 06:57:58 +0100
From: Christoph Hellwig <hch@lst.de>
To: Ritesh Harjani <ritesh.list@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Christian Brauner <brauner@kernel.org>, djwong@kernel.org,
	john.g.garry@oracle.com, tytso@mit.edu, willy@infradead.org,
	dchinner@redhat.com, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, jack@suse.cz,
	nilay@linux.ibm.com, martin.petersen@oracle.com,
	rostedt@goodmis.org, axboe@kernel.dk, linux-block@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/8] xfs: single block atomic writes for buffered IO
Message-ID: <20251113055758.GA29014@lst.de>
References: <cover.1762945505.git.ojaswin@linux.ibm.com> <aRUCqA_UpRftbgce@dread.disaster.area> <20251113052337.GA28533@lst.de> <87frai8p46.ritesh.list@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87frai8p46.ritesh.list@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CB27BA0007
X-Stat-Signature: sm8auwjdhxfa5zped3gotuhiew7apdzs
X-HE-Tag: 1763013484-76990
X-HE-Meta: U2FsdGVkX1+sFfqIkrO+rHinUX9xj7zG7bVJgJ+fYv4LfrnMOLLlYs2WsaaTTZcQJGU7DkUwNkTPoQlZWg1MN69Qn++mIJllJ+e7XV1XCHiDSBa73l4OLgXC1YZcKedRkg4WgDRRwvYwwJhVCYOx3FyD7LLwaA/yoCOF6weXWRZpi++GPyFOBy+AZKxjGIgHk/1zITSCDtDmxXhy6bRcOQL+YLw1q4l10lACOQROJ1wJO0AIfNgUNTyoF2i28Nt9ZlpI34M6o/kTI/Xv3EssB1FKX0mI+9+pv2H6HDuKBXKOQqKb4dBAJ9HaY8YW60GronwxbTaEE14mUu4P/VhqabXTMdrovLu9TFKSL21jXgCWCf1ouujB1mntCdUWHYYwFW6mGbDKPwgCNqtFQPxdj94siNHYRvQo/dQ/+MLUu3JX/CfvfQly6snv9xVbQKyPeZFxPChIoa86RfU+HfUAW4RIwqfopJBbG4Q4VsNC50smqIlVhpkwtnHX3zuWNhlWm9L4L3SIQqGMpIW1SLjpAp3b6TnpNWNUj2OTZ+hS2NjTl0Ske3ei0PNvanSupcWn+rqyEhaR9GBINAmmLWcR9UNqjEItpnSFyGVO8EQdlcFssMlv9OckUrbTstaXOo4+1sTR32Kxu1gOdFtL26c9Vx52upfvtJR/oltYgvNX147ga4cfgRhFfHv2+ypGrAY1bt634+RM8pWRSSOA9aQeUOpVaZUM+FBmpTbVNYZNqWhskIOTF4dnt5De3MmRDozB8dC8R0BD0YBuyA+lKqrfNVD5WtuTouAn0mbtLv7OmiEtEtXaUwLB3YXPme/H25XkCmsCjxZOBvX1SaG1JvUYH6slPRBTMTer683cM6K2UVE96Jv0lJ/22JaYe30eQKjacHrh3C7WxUXjjlB7oOzDhGe6lrYc47Gme3GS9JkOkhmr73atFDzilVbYJ3iCUtLyfRi/PdDh/dKOoiaFkhe
 j6i2Vdbu
 VBHOCm/lWbEnpjGydfVni/NW2NtIjlpWH0VDi6CZT4F0KOYSG2mXob7comsqCIfpVvvrxTO473r9+IjAkrvAupKYhmfUQ3mNTKIA64oc1yzPO+HBoOc/Aw5d89H3qr3bJHgBaNWlg6Qzr2psrnpqJMLIAQcMcmut9SERhpkjbraE+dZGsH8w2dGibbH5ijgZ2nT3uoyIHtq20FYEyUqKR77AbKASbLsFXnYcOQhZgecljhx7Fsspc9Ceje9cdkziwIVsMg2VK5gEUgxb9PIQZpcW7aw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 13, 2025 at 11:12:49AM +0530, Ritesh Harjani wrote:
> For e.g. https://lwn.net/Articles/974578/ goes in depth and talks about
> Postgres folks looking for this, since PostgreSQL databases uses
> buffered I/O for their database writes.

Honestly, a database stubbornly using the wrong I/O path should not be
a reaѕon for adding this complexity.


