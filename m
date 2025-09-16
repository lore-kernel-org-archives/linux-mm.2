Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B00DCAC587
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 04:33:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CD718E000F; Tue, 16 Sep 2025 00:33:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52F708E0003; Tue, 16 Sep 2025 00:33:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F7968E000F; Tue, 16 Sep 2025 00:33:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 30B068E0003
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 00:33:16 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 967A4871FD
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 04:33:15 +0000 (UTC)
X-FDA: 83893843950.26.2D6367A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 229224000A
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 04:33:13 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ffhRuEUS;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757997194;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2HHvZRG2IRMlzZFiZKra782KbSGLNhZmtNIao6482y8=;
	b=Mqlse2tTS3NGZ554FaVW8IQGZ8HwLfIUBpllHA2e0oja29eS46k1f48o1hd7X225fHq9Te
	5ccX/xLVdcnXDX+eFPtuOW0y2c3CZhAY3qq49caTq9MqR0mPQLvsHa01jofuPYd629ha5L
	cAmxMStW+HoZ/wdFkmVwc0CpBZDjbiw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757997194; a=rsa-sha256;
	cv=none;
	b=NNCcUTtiwUGAf1sTzB5LEWyoKmH+HZPOhWzh3YPU0PdL1SgAIVCx+98akpHN+TE7XiqWGL
	P2M1SGLTlA3LtjINRkkDbhkzWqZB6q9o3yU7YHmwZJVwDe0eaJi/jJHQZtOrhpUKYYTv7N
	l/ty3//BgjgRjcDsRLmcPS0/3giTuOw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ffhRuEUS;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6FBA4601AB;
	Tue, 16 Sep 2025 04:33:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB161C4CEF7;
	Tue, 16 Sep 2025 04:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757997193;
	bh=RFJkSWDFhqm9IbEFagXwquv4UPK9KKARrTLze/LmtU8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ffhRuEUSl+esw54iNYqPLjXZkB7pm9/qU6PwF7PfqZ0m7i4oOU94h54q9jAHt/nS4
	 s+f9QUzJNC2ahUAeHoEjZ3N44lirm2epKio2vvbtZatpjoIm0CqJ1pGpaX0G3knn/D
	 6VCEkQjCFe6KZvDs/IDzmvGpZi1wTL3t2fx/haT8=
Date: Mon, 15 Sep 2025 21:33:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev, kernel-team@meta.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 0/7] mm/damon: define and use DAMON initialization check
 function
Message-Id: <20250915213312.12892156442f3a795a0a01f5@linux-foundation.org>
In-Reply-To: <20250916033511.116366-1-sj@kernel.org>
References: <20250916033511.116366-1-sj@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 229224000A
X-Stat-Signature: smh7qtnyzm5p3hfa7twurxs3dhufxqud
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757997193-499821
X-HE-Meta: U2FsdGVkX19HMcDKPg4n1utk9jzSjosKX9Yjp9s0vwzCxTBgFknZD8cDJgnT0t5Uu40sAbzMhTEK+scyA/oi+Rv07AL8cKUehMmpu6Se9icGAOyzUPC/XbuUeD83twPVfdGdFHmTV6H1vNi6VWlJKXPjfMQkYhJhvHJvEqfQJRoGrpzKZDmedDYiKbXT2eVJEuTHGg3cpxcyWEK8UuLYJmPXvibcKsp3ZGPrlDmKa+usRj7uCFN9IKzewtClGZO6LbZr/+zzgAHb8KR7SMSo0UJYPSTNuXMvdFK6HIAgLOCcxHKwqDyf6/a8oL4kzLb7QJNLeW+5NFWrrBZ7VabGxCrNLpMlSrZqD6kq7WgjDoA/KQgdMPV2JNhTikDnVr2WVvxaDc33GBVgK0v6ZM6USBhrCRhQfCWAXxGRxqIEGGCaAuM0A0b+ugvrbhSP3RzKIi1nVt3Hop9h1PtO1EneSHOXke82+MrKQsi9KZDvEzpqlBMCnU4Eb/2qhe3FzD/E7Fa0K3haAQ8241LPnF8RHUGRS23D7H1fMY1PPIFYasjYBDOkQIaIOT+QWHmS7T4ueRgx82ERcrA101HhB3NEY/y9pt/ZrY6IF+83n4EqryYwzVLzIP3zaskAxzYxqQeZtrei8ow3YzwL2Cg9mG8gISJqs0KQ+ZSIiYobSUrJ5oMfpfEQZXaeyWXnLVhU+heRG7+VDt1S1IOd+Mbzj2p336uXQv0tt1ux+wanOjANpl8cSZxtxsqRN4HHjK3OMwGMp9G8fHKEIrwTOt7qeWxbA4OjnlLSg6OXmdr+8ChQmq1IsGuSEBfbkTaO6KWscHkJaIb4Ds8XCbNyjWRZqnYPrzTqC0T+Ga59oePEydTQOwU6MidDen7yAvUOadoCk9WCODuWSb4+tAS1+C1b3Mt7E3aZO1o6mUR7TulzaaJxM4w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 15 Sep 2025 20:35:04 -0700 SeongJae Park <sj@kernel.org> wrote:

> If DAMON is tried to be used by its API callers when it is not yet
> successfully initialized, the callers could be crashed.  Such issues
> actually happened and were fixed [1].  DAMON API callers are therefore
> having their own hacks for seeing if it is safe to use DAMON or not.
> Those built on an untreliable assumption that DAMON should be ready to
> be used on module init time.  DAMON initialization could fail if
> KMEM_CACHE() fails, though.

Wait.  Is there any realistic expectation that KMEM_CACHE() will fail
when DAMON uses it?  We do have the convention of assuming that
__init-time allocations do not fail.  If they do, an oops or panic is
an acceptable response.

Are these problems actually real-world demonstrable things, or has
someone been playing with fault injection or, ...?

> Also those are basically duplications that
> make their maintenance difficult.

Unclear.  This means that the client hacks are no longer necessary after
these changes?


