Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23C40FEDA00
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 18:34:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C8A36B009F; Tue, 17 Mar 2026 14:34:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 879D76B00A1; Tue, 17 Mar 2026 14:34:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78F986B00A2; Tue, 17 Mar 2026 14:34:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 64F166B009F
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 14:34:56 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 35F8413A7C2
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 18:34:56 +0000 (UTC)
X-FDA: 84556406592.19.A88CC54
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 78727A000C
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 18:34:54 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=VJmIiWTA;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773772494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kH19adobjrSUO/rzQzyhecHCH2gBA866CXMqGvmtPjU=;
	b=W/c/eI6EU9II4ClaPzWYc7vXvSd708c2ocRq2sHZXSGv4Nlorwy4UAmoicvt4IXGPRDWAU
	wLi9nHTOVWVdlvT9gHsdR8+hVV9yhnFOMMh1fg7LdHtV/QycsqRZHNeJ7Hi6d6xegoTB8s
	eSczXxdtYnK3Oq3rgTQJdwMc4P5LfHY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=VJmIiWTA;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773772494; a=rsa-sha256;
	cv=none;
	b=ATCFyxoXmaRvxRtSRaVSkUBRarUi1Lzn/eqRb0POlSoCyFWkiUW+M5TfGBZM8YvNK7W/DQ
	Oyz9j+brWvbxiH3VwdQBMVoTwGtj6WKc2dI7GDjVk7XfBdnnQRa8Zq2pyB9OIhp0g9vOzu
	5CdXgFeD78LAciT6sM5UXZ2n6Js8e+4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D60D960018;
	Tue, 17 Mar 2026 18:34:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FEFDC4CEF7;
	Tue, 17 Mar 2026 18:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773772493;
	bh=RVsjb7gSf8Tl+ZYDVu7R87RYo7eeBrQ5V3crBd21s4Q=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=VJmIiWTA0SPyUd6NSFdCQFTKb6GeSYwPjILc5D1E8i7ClalIhZ9mdBAqtzS0SHYYU
	 At3POUaIk2b3XJJmmlb19kMgI80FrM9kOY8UrTQuTHQe0p2cmad7gzZMCXbMDHBqqo
	 Cq4rvbeMeBVC4cE8g4+V9vm0ZsVBfhPy9BnerRmI=
Date: Tue, 17 Mar 2026 11:34:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Deepanshu Kartikey <kartikey406@gmail.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH -mm v2] do_notify_parent: sanitize the valid_signal()
 checks
Message-Id: <20260317113452.cede9a514dfed36a1cb0e5a9@linux-foundation.org>
In-Reply-To: <abld-ilvMEZ7VgMw@redhat.com>
References: <20260316151956.563558-1-kartikey406@gmail.com>
	<abld-ilvMEZ7VgMw@redhat.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 78727A000C
X-Rspamd-Server: rspam07
X-Stat-Signature: 4wwfgamn7cpxhr4bk1se14eeyntwoy5m
X-Rspam-User: 
X-HE-Tag: 1773772494-665008
X-HE-Meta: U2FsdGVkX190pljr7lyP/v02hpi1QAgng73uLmHKEAOZ1d4HzC5dqu4bNTqe8STW748NK02+Gk5mjHbmJqY9/BtzrNtpNsRB6mU8I/vw8ak8bVuEZnJuOLNtIGB9mgAdy/zbSnq4ziS5lzak1cxxylFbNN0ly0nNfeU+tF7mYaCTdRd1P8aHAkXGAprFSS8KK+JlsKZlsmTHcnVGOu16ViPZtJpWYqpvP7CuRfzmh/LZx/NLPLUf01ro05JxYiUH30JREFl/Bk+h4x20jH8FkaFMOQ1S3kqj4QAeClmqsfvR6p2VFxIjNLPbA1kgxmBQT0E3TLhp2PIMYaSH6goVrYKIaupcs/dy8eLtpxCC6vHPaGmcuB97iHIP6bSQtvMI2OgVjBqsy9gMFI92+F19ZqEosL1lG9ijdgo5pfEtsljd0QIiS298Zn0cfleB1EKanGUvctD2iobMpxxxJoMRa8UHkJB9p0Uho483OFXdH3SDqDzzyGF9XlRyuu+2e1EG9at9nG+zIslk09BN5TA4coZwYgXnrNPWUQSSDnmS6ziSLvpYZMYLomIVLt3++7M1SHq3z5X0WtDaH3vuJ2gvtb4ABUQmdyBrkDLfmSRbTtG6kOTAItwj901acWCOWvtmoZocs7dabFjesZTffJpy90rnbzSBHudW0yDLIs4eN1U7zlNN65nC+xHELrSTsQYPiX4qQAtWLb1WGhZLSuheXfTXgOPF333yiuke1j+rNq5ZPvTQXGOWXpNUypK1jgFhCcMVVAnmIUSGH9VuS0p14JI5+RUlK9qpYs9+2Z2O6FEg1V3hsodZvcLsStXtjc+ywUAqmmorilwHkLepxhVb9baEvJ2y7xOlIxygqWY9EHvtv8O4lVMPPxsR1poCDuuyJ9gayKmbBOWaYIZB5zvgE2X3ggEWhhS4uJ2EZW/jWBdiv0aEykPam4llXGQB7FG7FXlKOSYsEDE1DeeSkKJ
 Qyrm1EXC
 DiGPfPtp+hkhaSDYzsGcTsm/6H6XnhYon9arYc/hVPFsJe9uvyXc0pjrzEhq7/I04knZ1PysNfDOIDxJKWcd0+rzeZ5r8f9lIvZlowtRD1hwmn1deyScMYGa5vtuOGbMh2ky/9b2SxKZI0Qqne4bhhPPgxrN3XYVJUGVwSgQoWgdKI0nES3y7gWZgcC6h9WVYvBX/994M4o7BMFjrbf2wCXka9Z27YrpEglpZCRCXneRqfkoTZRxcg7Fa8UoBzERgNeBL5Niu+TSa6woOslyuf+uCi5/lETmBmZula+6skxc+NmiSS3dSI/rfdBaF05hAhKPie/Ex/8BZbxcSZGuS8Sgb0szUpHi5k5NYXEBA3alaEg7EWULga9brqK5VSnPYKKEy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 17 Mar 2026 14:58:18 +0100 Oleg Nesterov <oleg@redhat.com> wrote:

> Now that kernel_clone() checks valid_signal(args->exit_signal), the "sig"
> argument of do_notify_parent() must always be valid or we have a bug.
> 
> However, do_notify_parent() only checks that sig != -1 at the start, then
> it does another valid_signal() check before __send_signal_locked().
> 
> This is confusing. Change do_notify_parent() to WARN and return early if
> valid_signal(sig) is false.

Sashiko has a question:
	https://sashiko.dev/#/patchset/abld-ilvMEZ7VgMw%40redhat.com

