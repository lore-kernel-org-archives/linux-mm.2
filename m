Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5000606A33F
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 18:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KipDBXKq
Received: by kanga.kvack.org (Postfix)
	id C22236B0644; Thu, 29 Oct 2026 14:43:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BABB86B0645; Thu, 29 Oct 2026 14:43:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AF696B0646; Thu, 29 Oct 2026 14:43:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7780B6B0644
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 14:43:57 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 01C241C277D
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 18:43:56 +0000 (UTC)
X-FDA: 85376538114.27.BAFF41A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 4C04A160006
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 18:43:55 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KipDBXKq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793299435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CtpDxwIoT1nrTi1nrGQzeAHOqSMBl/MAyoIlA+VWnP0=;
	b=TUKsVqNVTq8kA1tJsgMaRoBEVnwWd9XDu+l6pG75qc1LnmdQ7J/P+BHFCN4eEaI9q4bmIh
	2YWO8oRr4HPtcTBhqHvOZS9vJHbbXyqpsjZWTn4eRxdXXz0Ma9eVDCOWG+LBaJ2gEEc89W
	KjEChzlCi7DTjVD1ST6iN5j93qominU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KipDBXKq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793299435;
	b=Oe5w1mjOaSOgLWEYvbThRtz53f6aXw5/jfJQ83XCNEYWwItgg0HUw1prmRf25z2L+xXL6e
	cE6Zj1BFJkqMq+e68iLUriiqQYlei8ojnrchNt3rrgbTFvfQO/S9YFgdKZbcstiYf+53Sj
	KnpIs6C5AsyJFSKsbmK47GIVZvHN/bM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9D1344389D;
	Thu, 29 Oct 2026 18:43:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9C7C1F031F2;
	Thu, 29 Oct 2026 18:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793299434;
	bh=CtpDxwIoT1nrTi1nrGQzeAHOqSMBl/MAyoIlA+VWnP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KipDBXKqL3PiEjjs0hHts6XbTkKe1GoyzxvHUP4bLeZ/wXx/lL8mFdW7MCCk5ynuk
	 pRhsIAnmUu3ABfkvvj1HAiRbpimojIH6qU86CZQSNrHpPU4Xajlh2pyo2Tes7qxrOu
	 EEKwDpyUb+PCrPqZZ49uG3l8ATnqhZMpuDDtk9ibaaqy28dvICetwAI3STBGLw95gg
	 sF1IFVBYEOXAj41Nffq9ck9wDbMEYg095wJeXK6zuhxxVP/5g+V12sQhwHGBPDDDMk
	 QhqC/rythRBSvt9wfjXr3u4YdLAQ8JxwGQ6amFiuN/70TSpo3QDhMePBCy4zJ4EVcp
	 wO+MUEySOCGUQ==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 6.1.y 0/2] mm/damon/sysfs: fix pid leaks from wrong error handlings
Date: Thu, 29 Oct 2026 14:43:24 -0400
Message-ID: <2026-10-29-1-daily-reply-0017-damon-pid-leaks-6-1@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261028141723.161776-1-sj@kernel.org>
References: <20261028141723.161776-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4C04A160006
X-Stat-Signature: eq3dwtepe88ft537u86ekturjg69heug
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793299435-327695
X-HE-Meta: U2FsdGVkX1/w7jBd6tinvGLPShOfGSm/CUV6E8YQ8dESb4alIaUkL1G07EKbrvaic7z4OVxYFq5xf0rc3cf2Ur7ugdosmr8Qh3wryx2tFt+qZdpNJ6Le+UQeeMxyyr104jR5dijvUCXqrg9nAD7ej5kP5h92nhyJDp/w6da+eVeCTiAIiyHn6yedCi041M2t9Pz5qNcj7V3QT4N16gVJ4RMDv+41/KKorkgZASZ8hev3l4vkS9f+K76s92+2WrCa2dHnBByuArNH0bea2xp5WQS9eFxRZoQgv4yHwkjKURpKpQgBz9o3XDf3SCCpz+vbHjBsAKANXn9my5+dU84+gPwpt6Ay4MLDoeQJGsv7jJACiqJWu2YRy5yFZZCByufMbmNDSIAjyxX5FsXyRnIfNdEO1VJsQCYve9UcJlAiORAElcIUX467W2UINhn/5MDe+I0QE4kQoNVHtjPxrlSI9+s60QQpJh8CXfQKZmgrr4shXAzsY8WtmSEKEI9FRPRJ0S8ExpnjQe+/dAGUqmlNr1Vf6I7q4ckHy+0UNsAtLibEqnmfnQiF00ng1pgfb1nxggkP2ZsaSRWRQd4ysze2ar7PF7eP0wxg7LPY8gSNmwUQyYLuHlcTn3VGfXh2yRxeVJjusgvCiwd6MyzPIQJYDieA8MLeYNh+ckyCzY9t9qCoeAI1rnxwruYbSxsOeLkXwtaC5JNBnls1koG8bh7fxjyoFeF3/bYz6uHMeH/3w5YOfKRh8bN3R4o9lxgPSZ6ExbVRDx3soRY74DwRtK8BJnGdpATfXn+BxC1n0Wii1/InJIrEWTyOUarHxN/+pmkUyiIZep77N+8GC7j6j1P5Qu53hvmWxvr0zZDMVnnbSknvztZd5r2/J03CkCZur788lXPZu1TisBuwMX1ps31lf3BJD/QfFUi4K9Do17U65X7WGNPhGg/NbUUyBj3I3K6w9QkrZOxcrRahZ0fxBw9
 8w4wk1Ml
 9sEliZuWwoIM5e4elKNqaqNqtI8phRCqLzg83cmfgmoUq+cBT+VkQ1ljPoVWvCaW9hA35VNebSBo6kz69YSw0K85ZswosJIPyVKvG2AJjomXP8w9I3ZLUUeyQTD/UUemMq1MiPBRW35c/SVMeU/M6zc4hZNJbZ9krbzLIzDyr+xwTCGmd9SuFdUsIzFpzYa7RjzXMRbMJeKerZ+w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> DAMON sysfs interface can leak pids due to wrong error handlings.  The
> issue in the mainline has been fixed with code refactoring.

Queued the series for 6.1, thanks.

-- 
Thanks,
Sasha

