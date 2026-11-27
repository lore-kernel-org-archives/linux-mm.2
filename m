Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04389606A31F
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 15:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Z/knOI+2
Received: by kanga.kvack.org (Postfix)
	id E5BB66B05B0; Fri, 27 Nov 2026 10:38:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E32FE6B05B1; Fri, 27 Nov 2026 10:38:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6FBA6B05B2; Fri, 27 Nov 2026 10:38:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 666686B05B0
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 10:38:24 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C635A40400
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 15:38:23 +0000 (UTC)
X-FDA: 85481305686.11.4598A7B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8BA5940010
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 15:38:21 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Z/knOI+2";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf01.hostedemail.com: domain of harpatil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=harpatil@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795793901;
	b=i0p9XGnvCvh8LJ9jGqcSbWGOzhtaDCRI8mS7uV+SCR6CXxncqHHjS6aWCUeHOAnLENC82h
	F9Rhhe0uk3TMTje+lyotCuY1YxI+j15LCCngWrPtnEE+Hqx4WmVKrRjXleseZKzl6vc8XO
	uepQTEX9wDLlDotqWwYpBgde8lFrmJc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795793901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sjCiUNNZRLhGGd+Th5mIM28JPSgV5FgdpXN9TP7Fv+E=;
	b=upQuBd3HMZVjDbm8KF435Jn0XZ/X8QwQS9WHcqlU4X5tDIFHuHHWH4CchIQdUsIwwSQLyM
	swn+OkWzSJbWOAZybtYtYECQYeEr5IOCJhZNkEbiizHQi7r7yn4Y4g+f9qoN33IsZhtOmq
	ByU3+Et4UrmRSflgBlgUVLCTsDDn5Gw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Z/knOI+2";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf01.hostedemail.com: domain of harpatil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=harpatil@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795793901;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sjCiUNNZRLhGGd+Th5mIM28JPSgV5FgdpXN9TP7Fv+E=;
	b=Z/knOI+2qGQvkx0A2sJxhrzBhcvDZrlSffofJFr+iZJkmRZM+GXt3q7BM2vJeOtQukt4oE
	LLBK3c32VjljwKLRxJvHYFry2Z888ZwR72iH6/HoEzJbdJoTxNNvvtBJU4Mn2kTItC8IV6
	Ibfer+YtAQnX76Lk+ZAdcivKlYl49OE=
X-MC-Rep: binary re single
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-225-GM0yy5oLMpmLSgNp7tRWSw-1; Fri,
 27 Nov 2026 15:38:17 +0000
X-MC-Unique: GM0yy5oLMpmLSgNp7tRWSw-1
X-Mimecast-MFC-AGG-ID: GM0yy5oLMpmLSgNp7tRWSw_1795793895
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 21E541944D3E;
	Fri, 27 Nov 2026 15:38:14 +0000 (UTC)
Received: from harpatil-mac.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 77D3B30001BE;
	Fri, 27 Nov 2026 15:38:09 +0000 (UTC)
From: Harshal Patil <harpatil@redhat.com>
To: sashiko-bot@kernel.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Tejun Heo <tj@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Frank van der Linden <fvdl@google.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Waiman Long <longman@redhat.com>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH] mm: memcontrol: let a cgroup opt out of HugeTLB accounting
Date: Fri, 27 Nov 2026 10:38:01 -0500
Message-ID: <20261127153801.50171-1-harpatil@redhat.com>
In-Reply-To: <sashiko-outbox-232294@kernel.org>
References: <sashiko-outbox-232294@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: wA_tzyxHgOHeY8YU7f_nJUsFUc0JNECwyhrSozdsqRY_1795793895
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User:
X-Stat-Signature: pgkr9g1z45hqb8rqy11q16oyer9no661
X-Rspamd-Queue-Id: 8BA5940010
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795793901-426491
X-HE-Meta: U2FsdGVkX18ovjQHOZA5mWMlj6RKYeZFCUKrdT7YwCx3yNLECLsWdQN6rTTKG92+YJVFMPn6u9MDR90D+Z/+vTMSxx6XtX45tnu7c7kJJxsMTHbdlRmuVP7IiZ1NB5DpfPSPOqGnII+NsBg5fzwVT1gLU4nuz2GlKh+6BkCMQ4ymIHp8GYW74MCInz2m2hMAjrLLWAgFAtPwgXj5iJo8hIktLLyU+dlivWVVlNGVV3MHFPUX/hdQOfdVQEYB40cSew1tt3N4Ns+5UAfVf7YRQg1+vXIFFpuNaVKpIoKHNiazBuz1cTOsaU98VK+HP7joCdWLE1reoWIInpF7cpsDANZujuhY3lwcU/V41+wJtC8ZbzLmS3efiaTSHRkWfqrNC2wHa+bcelWsMQIvnMIgKeas/1ahLrZ7OHwqfQqfrZp+nbGJdKysHdeCkFzMAHQ8JqPXCw4Qtej6kwjw/evpRoJ/l4auIZNZ/kWjcyfaRWzyhDNxjxg+iYQHBxlaCkxGK6JkZrChwbY4PZI+0Lg4tiDskDoI5CckKNjdqjoWCPd8eFw1lZyEg6PU9tBpe+RZnw3qZKVpgP32GtP4VccHFJh5CAmn+6gDtLc3w8LeyDUCLAs/lz16woWCfj7vQxlwSxecZV4b+LWwYGDOKxZ7EVJHTLE8FkiR279jeau4AWMtvJ/KXACdJE9fGaC2QFPeRH5TS43zdQRQFNBRrj81rSnm6RKbdq3+uYoPlDE65QupsSKUi9yohU2PBkcdzeNLmephvMpFnC+rHw1leAXz1lYq4pGmi1usxmnyGGUrnCLYHyI2Tl9bRoZ/hcqtfjXB0lvM4YnAbsy2d+Ozifeb8HafLGCIpL/fbTLRjcJlrc0BH7eLED+B287v0q4YPi4fgD3HRSCvZn28iPmETbG7CLbJ1RHb54b6yf3bqWFtJ6EZB7/OZjhiVYSVP0cKDUGTRh75/H8v7CBDyPtbYxr
 zRd9LuTb
 tc1owhbaBoH6u2HbczWYIJpnThJ2MnWP39ENmmuDyNFOL8CzOe71o9FCCz2H8bKcHZ+yJkspH8J1DP/YHKl9CXiULJw8XhKSa7bdzNOIOY5c8xWT8uvVJXzXSHlE+reKmcIZLF0VCatrQdbkhR8nK67GlvCaGp8woWm360di8dw1ZYIdeAs1J4diNR/K5N6yEkxY4C7HPmlEM4gUc4MQwy1rKQZSDaMY862LprcblI9y/ldP3ztvBEAJlRCw1QwNcYigfgp0irR4uAT8fu9ibgi9Y3ZoP6KC/9urz7GeauxXlh+ZTjklmJ3jYCPcpDoUjCObb0Q2d7k7DO+wyb5eLpcdY5R677G66n1HZsB7Rr/D4J6SOZTRHN2qeqbkg/OrfcSu/BlqmPQgV4wACXvTk0aYWlNNwNEQpzo/DfT4wloJGlndUfZ+ZDysmgQHfhqG/T0zEqIIVCm6CW7qmWypvX6RmaEJkDW9iCZH3ZsdovuRGNjQ6EgmgKgvtNjXbg+dHJ8Vc/F9I8wtTEOvsBF35qXGYr9X/mSrl2PMaJ87Oszy5UnQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Thanks, both of these are right.

I could reproduce the first one on my 10 CPU VM by mapping one huge page
instead of four. That is small enough that a read of memory.stat does not
flush, and then the test fails most of the time. I have a fix that queues
enough stat updates before each read of the root's memory.stat, the same
way test_memcg_sock() does, and it also checks that the root goes back
down after the unmap. The skip gets a message too.

I will keep these for v2 and send them together with whatever comes out
of the review of the interface itself.

Thanks,
Harshal


