Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04E7FC4450A
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 01:05:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A05986B00A2; Thu, 16 Jul 2026 21:05:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DD676B00A3; Thu, 16 Jul 2026 21:05:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91B2B6B00A4; Thu, 16 Jul 2026 21:05:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6610C6B00A2
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 21:05:46 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C4198403BA
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 01:05:45 +0000 (UTC)
X-FDA: 84996476250.27.21FA6B8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 340D41C000C
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 01:05:44 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Tt9MXMZ7;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784250344;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ogjg6JXEwNAVi6wkR63GVRchcCh3t5yDoHZWaPgOSMg=;
	b=BjmL3SehXmIQLIs6FUtkw75FFUBOK+qBwYFTNc7qL4LukdKHSpG2JjSMbXGpG42y6OegyW
	UMtj5Pn8/OQ7syWReu/3891SbiOT0WAGp2hYhWnwBVvONsjbJxWZF4U+2iZePfdkInX4+B
	Hygz5+kLTJqXd5WOtp+E5U3nLp3Anuc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Tt9MXMZ7;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784250344;
	b=2zB4USDPScoJ0lE+1aNdI9Tr3X1PCRS3lfCOWcirHXEJUGz1PyVGIpKPeeGt7TCAYmaatr
	+mP0fzS94vedRc9TeEdbrkHU4jlajpNsLksKw1LoLgX5o7zyAAd2K76Vh3fRkHgSchMzp3
	ZYngpjd7oPFdlQTJCErLpoAOxDGrWw0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5F8674046D;
	Fri, 17 Jul 2026 01:05:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7B5D1F000E9;
	Fri, 17 Jul 2026 01:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784250343;
	bh=ogjg6JXEwNAVi6wkR63GVRchcCh3t5yDoHZWaPgOSMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tt9MXMZ7UaIQGJ5YgFFiAgmg2HPQANPh9gIj501W+lsWeY7HACMtll2wRe9RlReY7
	 JHu55b86htSwk3a+v1v5/nG1uMmHEBKPRBdbZkpuJLt4shx4k4U2VEiduNlz8iNsmT
	 5rgEfgeaSvwRyVsqn0OP2HpYJEpJFM0NEDzqQChuouYDmnUA4FBM1sxl5MVq35ZPGs
	 Or6EwYTPig2K3jjoyMi9dg3ZqgbsGzbFVtWQb+uN1h7DRJhft1uUINxh2F9XfjRXEv
	 znJS85XcHauSiqhyoVtN+EsyDHdKF1bsifEmQWQrSMQ163T2124iN+dgTkNMRYZA4G
	 6lKb9XC4myPEw==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	SeongJae Park <sjpark@amazon.de>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 0/7] mm/damon: fix uninitialized DAMOS field and kunit exec expectation bugs
Date: Thu, 16 Jul 2026 18:05:33 -0700
Message-ID: <20260717010533.120368-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260717003022.119437-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7krr1gr33gyec1r614ama1i78zzda6n4
X-Rspamd-Queue-Id: 340D41C000C
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784250344-554774
X-HE-Meta: U2FsdGVkX19qa1aXlb5DSqcVuH5X/S+LSZre/NxwC5ITkgbhpBIn/ReRmmp9pWdCi0ivyljhCqjvA/ka5ib50wdaX+YLQDooAZu55eFZ7WDj28ohTHk6oQYdf7kk1oq7aW7eF6kKb1CVD+QkqEAHuCch37RiwVBTqKpwHNreTpsX41uNPGLy6Y+yWf3nA211nJ6tauUwBuny6ULAmqNxDSD6SnZkgdoHzFGdH69yRDNxTPKCusYcxdPR0yvasIpSoZGfZ6z4Pp560hUzxeTecBI8Qj4p/U95K3Vql83/WEglYFH3PTRes9CkWYjYRLgqiX2Op1EEGshC3IBGRVkllB5wksQsHG8p/tADO8AxGaIPyZf5ttXE68UlqOXsnVKZwEgnDAfVQhDELNbJl/s1TzyQ5fOnSqBmY+dKvoFiPyVpTeDmwbRpRjUukOkfuCiz6FA2X3/e9BCYfRnZHsfrT72IPaE8wTFNgifWaPe05Ty1mA8AqGZVM2Jez8SIJ6XE9CS4S2Jp/wN1Z+zZfOFOzvdOeyTbVa5YsVVxxkvv+63vj9y8EIbkbYdDfi05FYjRPvtt2yjUPuWbWi+rmTshcXqmRtKbxBpvIKntYtWCs3+EIvTQXHQVxx0JZ1Z5OIIXhmoxx+4VEUJZRX6ir8PngyCF7SheHcxdmiHDxZNl+YlrwYCRJn04Pmot1OSHO+nwLl/PlkXwn4CDnwqN1M2v06haX++Wa5qZiI50zaCayNTrrG1ql4WYFHQjENw9Qm+OEEnA0Xf6Ax+KX6AZpjMMI8uY8u3KH5Ulqua7WgxZepk7OAv1OVZWs0Qiw3OzGqAsrBuqxb6eMwYYenCH6a3VNCZ9xCATacWGBY+uV08D0nKRW3HjgXBcacw1zsNbA5OHYnC0TzKsTlZYYelPoC5X7jhVU3rS7ZrQszj+TuaYdzKc38A4YKUjAj6mWnuSYry5mYZFJ7Ntxj/96/ZYrHv
 YrTlZs4l
 S8QKu+p1pHg3uhrhvWGi8gt9H9s+BADWPaWBo49FOG7zaqM2aGZ3x8YGUJkWEoDXpvQzxDaTDZdWBdJzGOKr3IJ9KtWfP7bo2EujNd5mr5yJAfadvY5OIxSP0zCwvlrWEz/bf6YlI4cBSJLXkrtyvezl54sB46Fmg50LmVS8FeFZD70l45wUfRSLxHMiJqe3UadzcQD6PU6QkF735vVy5OR5k67t4bPC7dwLVyt+E3zuXHc9F1rwRk+jUplf8LTClVebclHVdkQQsRy2WfTc6vu7+BQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 16 Jul 2026 17:30:14 -0700 SJ Park <sj@kernel.org> wrote:

> Fix a few Sashiko-found unurgent bugs.  Patch 1 fixes use of
> uninitialized damos->last_applied field.  Patches 2-7 fix DAMON kunit
> tests that do invalid memory access under test failures.

This was meant to be RFC, but I forgot adding the tag.  Andrew, please don't
merge this as is.  Sorry for confusing people.


Thanks,
SJ

[...]

