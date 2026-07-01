Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B27CDC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 19:27:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8624E6B00A8; Wed,  1 Jul 2026 15:27:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 814386B00A9; Wed,  1 Jul 2026 15:27:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 729AC6B00AB; Wed,  1 Jul 2026 15:27:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 48EE96B00A8
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 15:27:50 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BBCF040488
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 19:27:49 +0000 (UTC)
X-FDA: 84941192658.12.AAF8299
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 08EF440003
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 19:27:47 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=W27ryESd;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782934068;
	b=sGP7mbOvtFRML2+q6SGHMHgeAKEzR1yRcL50fRIWScxXbeAXtODrWLwFdC2NzjgHdlJOcf
	cDVaNogoyNNNAzN9pD56x65fOvekdIZP6BYVqcYQat+ASiwJjK0qC0M4jC5fW2SICkwu7t
	Kns+pVTwGiGtqNJ9cw6JflzaHH7CtmA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782934068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gt+A1Wr/G1h4kMqCbndYt8VkS1q16uqqs8XxNPh20sI=;
	b=iwNXbSUiiNxqSIy9iArCg9yLBLmH+HEdZ2ppEYz0ObpKBKZl/SbxMFbdHybiL8fwe0QbU+
	bjKTq+k0dRWQSKXzwCB8bR5vmqGMJiJhBDHbkGwRDMsvPLEOPM0mkRQwF7ujF2ivB3CPUW
	71bVjFaBOP9XdaJXTEfo1Fyw7OkOhVU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=W27ryESd;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 561C76001D;
	Wed,  1 Jul 2026 19:27:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8116E1F000E9;
	Wed,  1 Jul 2026 19:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782934067;
	bh=gt+A1Wr/G1h4kMqCbndYt8VkS1q16uqqs8XxNPh20sI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=W27ryESdogM0DUhuoe4CFNiTEnfMsAf7nIapQUhol3l26zWPsJG4QpYAYOUBEeFcT
	 G1oVKlXUp7n7zScO85y5bE2F4oxPbyLSNqtZ+igp1RjLYNby6QRHFtm1l1eV7PZom4
	 5ruolwLIppEy/azavW4HVkC3DXz1+iDieQ3dARC8=
Date: Wed, 1 Jul 2026 12:27:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Usama Arif <usama.arif@linux.dev>, apopple@nvidia.com, byungchul@sk.com,
 david@kernel.org, gourry@gourry.net, joshua.hahnjy@gmail.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, matthew.brost@intel.com,
 rakie.kim@sk.com, ying.huang@linux.alibaba.com, shakeel.butt@linux.dev,
 hannes@cmpxchg.org, kernel-team@meta.com, sashiko-bot
 <sashiko-bot@kernel.org>
Subject: Re: [PATCH] mm/migrate_device: pin large folios before splitting
Message-Id: <20260701122745.2bfab3347691b658fb93f601@linux-foundation.org>
In-Reply-To: <78C557ED-3CF3-4558-9BA4-C43B30E63F67@nvidia.com>
References: <20260701140638.840773-1-usama.arif@linux.dev>
	<78C557ED-3CF3-4558-9BA4-C43B30E63F67@nvidia.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ymg7da5hzntrwzkfi7eseg7xxap7z148
X-Rspam-User: 
X-Rspamd-Queue-Id: 08EF440003
X-Rspamd-Server: rspam02
X-HE-Tag: 1782934067-585356
X-HE-Meta: U2FsdGVkX18L27b07eNhyYU4o/WwquJuOhEiaHK91BbgzzQIXEIRK242WtAgnwUXsUtWkvrARoBTHrS8HsrcjUU3A7JUBSo/G6JeZjo7deiRzrRNRhcLogkXO3NXC8elEoMRRiYT3rdGEs2zk1t5L9kp/Coh+CG6vEmeVIT+FUkVQKPCdDlCjihxKvUEY9OV1j7IBmwZrZHFGPLE2890CPEiRfjFj9kRRJvgHocFof/WXcbjvOQkvjKtOgi0a7O8jaQXZDN8PipcFDkVzV00u8cJCpuUlKUU2Tt7RYGYrsZTCe5r4W7NCFHvBWhLLf/d0q6iIzDVBiaKPmPg6wWsq6Z8AiUTMlQSiBMY/GZME6WTpqrgn3mBcemRcSbyatoYmLhfbe2EIoROFcDivqJd/A4imRM96/tNlv1sMnSPvj7igDR3h4sXDJ5iIj90P8Po1w3EVonEBBeUOBozkA378SDS7dvnO2X6UyVOZE1eUQ+M5OTrcaNuGeb/UAHv20pGEq4YXf0/H4ecV/QWv/gL1kU2p2qKeDEZ3p4UXUQCNRKnac2W705AhVZ2KK5NZ4HKYHFZyLbJxNuwdc2LSMY5agss6KiL8vkyZ6apVPfkRXir1jBRGhtY6eJgFmte/yrngFeYxMyvxb2fL+NjJk8y2cXXJ+H8nwIDMMOTTAzKVbTN4JRuN2DR1mMrBAPmRy3XOvv7wqJssXaaFwHgnGYHdNzWutg2QcWKs2D2mbBnYSyLTc+/bW+Zki/0EXHeUicZInH0+J5Vc3Fx2yOf8KcgGDIufoHx98kzKbPGdJPeCFKmZR0FIjssPc+yXOOLv/5mCYP0nY+ltFkE2HrmcZNdZ9377FAZMk39mwbd4vUD4IG9J4+jeD4y+3xfMjv26ELvkcL9xLnJfAcL9kMBDylj+a2/d4iLnKUol8JX0bpEamH/IOj9nijq4VLFZ/hb6+v25HcH2q87L0vAKLwSNDi
 nCauiBJ2
 XKrcktmQOHev8UrtG+0PoPvqmM/ZUQVh2VUzbRVaE3Eh5h7WZw9Q/o7Pguc/TraHEwTPNW/+pfqosMjlbt9H0Tjg2Czi7H+smHHQu/tVzNjSMvGZe+sbbewF1q4yI3f9XfOK2Tkaj2BJMPwrGXnaRSNO4WQpGJwuXnnjkSQSjzrHooptDrkW9oY4EUhRY2Q0+oYvY6+QZdoAFz+GCbYwT2TlEztHE7Y31qbCDsOlHuvcelbqE61y6gbUEz417/AQa0OHo9GLWrz8q9/qqNNdNB43SJ8DOAkGYwApb/OKu4duCFwqOZwbletUQIr1CVmdvPmASXAGGenO/vdYILTyPr0l3hg4HAfkuWuOIL934rBrXSokI0hGT895v6Sw9j+xSmDD2xtetybTr1nM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 01 Jul 2026 13:02:10 -0400 Zi Yan <ziy@nvidia.com> wrote:

> LGTM. Like David said, the comments might not be needed. Thanks.

I like the comments!  They may be uninteresting to those who are
already familiar with these things, but they aren't the target audience.

How are others to become familiar, if not by this?

