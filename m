Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDB1DCA600B
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 15:00:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9872F6B008A; Thu,  8 Oct 2026 11:00:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9376A6B008C; Thu,  8 Oct 2026 11:00:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84D2F6B0092; Thu,  8 Oct 2026 11:00:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 616386B008A
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 11:00:51 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D39C8A030A
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 15:00:50 +0000 (UTC)
X-FDA: 85299771060.12.63B4BEA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id ED379140014
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 15:00:48 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GWLVhNs+;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791471649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aswRrxvRLd9s8zPtStkeYzsIwlrO/oVXbFhq2BxeHcs=;
	b=GFLIktzBdWZbn2xJ7C6bvP9+6xE+hUWYoA/3hlFlGYnAMWxBXTR3JARHhNXJbajuTheg/C
	WSODJykusnpwyIEA591ZhWxdtnhXfqzyeBRJ1rRjIP/Cxnh9iT160BqdAT1BabYmWOgFUh
	bA7SqCtI+6jI1WQ+LAKvrTqvPIygGk4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791471649;
	b=VXuoPYtfdueB49/7SH+/0bXe1nkFktcb+uRU5blwF5GjEHcB/SXZ/e4sBHRxjyW3YTcjeu
	rP4GuDVckt3SIWD43Tdx3QOSsCMc1GtE9541d9rpLgwX0yL9E7vQXdG13p9Vor+toN1g/w
	lOUQ5f9OtpdlZ6e9tTgdf1LHeI6FSDg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GWLVhNs+;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 53E4F601DB;
	Thu,  8 Oct 2026 15:00:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07E4D1F000FF;
	Thu,  8 Oct 2026 15:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791471648;
	bh=aswRrxvRLd9s8zPtStkeYzsIwlrO/oVXbFhq2BxeHcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GWLVhNs+5R0A1zVlWzA8DdOF+6uvIgOdLMNDiKNcADdERgRnmqxLD3nU5Z0eamev8
	 SMGsOahpx0r2FU/+fXebfHa321tssU6zn20uVu35aPMoohR5oUYWA+01dhraJrylz8
	 q01Q9IWo+4qrYmOVlOKhDkpOzjiottClwBD68dQn0jcS+Yi0F5h4/1+MgwN5exR60E
	 A5DhTvKlCtUb7ipzqJCBNMLoEwvfCJGqxajVHyEQgXKlJuqDCvnY8VmKaudeZLWkHE
	 sn+CWUFPDOenUer1sacHKYS+ARwmuRlFnGm0RXqByfTvLmSzyDbgl+Yk+rMeA8ak5P
	 XU3YSqmZTiXLQ==
From: SJ Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC] mm/damon/damo: saving damon sysfs configuration
Date: Thu,  8 Oct 2026 08:00:43 -0700
Message-ID: <20261008150043.46530-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261008134442.31243-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: ED379140014
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: cpfcqmiu4tc38kmc5hmwg7if4p4w6sya
X-HE-Tag: 1791471648-246896
X-HE-Meta: U2FsdGVkX18JEpXVhWxdUe3vhuZ4DwLbg1YX9OLB6+e0OyKMMk4L2TeOwB30ePiOcyvlzBcIeANh5I/MdsryKQx2vUB6CX4O1e47gY92YjHAF+muwH0guwwml0NW27ZBGEDumfbd7Ma0S/s4Ul7jIFX8wT7hPQneUXWrn60T9tqJfkQpQ3Ug7V5YsLTv9SaMAyuT8Ya+MHvMSaxiR5jAGCTu8HNJXU973TYPG15HfikA2yb9eEg/VQzhk3HbMirHRvhtdxzFdU323yHZR5HUhR6MOF3usHHqg8tIMLc7QyihjyzXGN9gSCG0PS2hSz0upGwpT03t9LuUxKYw7IP1E8IwQTlmhr3ZQcYf39DKIoRRx/eo/EYwNYJGidXWk62sbaXfbIpY6Vnx/RWJhEcV1VAbOATdoLqJUf5t5tuE8riPsBynd6v5FNjyuwTV+nCKnObw8hpytyK/zeR/ArqUn/7lQkku483jMl4AQNfHQg2pTdI29EwtIZ/nc1LBcpMnr23V/aGu7CL5/qahA4T61gCMbKGaeBWxyCJnDH4xFHtFSyQFR2fL7MGMBMmpxq5E91Lq8KzEWmJSA/OHOn4rWIas1nDGLyaEbOdO6y4yiGGOwe8pDJ1zsIvpZgybNaqOsEi8+Z5DmISs16iB2nT7btlfZdQqelWWpCYnIB3rh2ycqGrdGoeX+8qJc3FXzR8erHPyRsUX2E0yv1WUVEc+4/bBVBabSw9wTqjMQbkuLMETQWGu38dAjfz/5tG1Pjvfb7cBlkYIT5gDfR4HO8KqiXwwgKtyg/HCPhauE2xRyqeM8hoPO4AoI5EIVzQo+2VohIyJsovukLc/VwQyOIdBM5mAiQ7fTaPpJN1sxtkFT+xbUq6zVEUtkNJXIVlDiKWRA2oqPAggoUX89Fxoxt4Oh9i2HX9O1Fecx901f5jY4rD3HTgjMhtmH0EJ75Tf1mw/BDEo+kG2iriHudr9WJd
 XtjaNIQD
 d5QMjrS3yH7eBHJ/j9nfzsgGOvpqZ+0f3prFVlL/isaRpU7Qnavo5VKeCgYVr0v1J8A+iPGLkm2c1r+OiEK4EGQOaihB9FFA3EXwLW3P7E7t4Vzeamvw2XeBtXznGyGty99vEbztQvqI6wXqt2skUrvOBk6xovtdKvr9jpGTAISgB46j9ZVxCiAcD9+tBmqcJAFeYl3AMY9tW+uEctijEdNXjzVkL2B2AFcnaKwpbI4k1NKb9pSwEWz4aowrFHbvMb832
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  8 Oct 2026 21:44:19 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> On Thu, 08 Oct 2026 05:32:31 -0700 SJ Park <sj@kernel.org> wrote:
> 
> > Hi Liew,
> > 
> > On Thu,  8 Oct 2026 20:09:05 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> > 
> > > Hi SJ,
> > > 
> > > Just a reminder, I think you might have missed the question I asked.
> > 
> > Could you please clarify what is the question that is not yet answered?
> 
> It seems I forgot to ask the question, my apologies.

No worry!

> 
> I would like to ask: after reviewing the reproduction, do you still
> think this is a real issue?  If so, I will start working on a fix.

I'm not good at reading the diff in your previous reply.  It makes me difficult
to understand what the issue is.  So I tried the commands on my system.

'''
$ sudo ./damo start
$ sudo ./damo args damon > damo_args_damon.json
$ sudo ./damo report damon --json > damo_report_damon.json
$ sudo ./damo stop
$ sudo ./damo start --kdamonds damo_args_damon.json
$ sudo ./damo report damon --json > damo_report_damon_aftr.json
$ diff -u damo_report_damon.json damo_report_damon_aftr.json
--- damo_report_damon.json      2026-10-08 07:56:04.979178016 -0700
+++ damo_report_damon_aftr.json 2026-10-08 07:56:27.717941609 -0700
@@ -1,7 +1,7 @@
 [
     {
         "state": "on",
-        "pid": "46402",
+        "pid": "46449",
         "refresh_ms": 0,
         "contexts": [
             {
'''

And still it is unclear what is the problem.  Could I ask your elaboration?


Thanks,
SJ

[...]

