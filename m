Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16995C5DF7D
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 19:14:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5ECE6B008A; Fri, 21 Aug 2026 15:14:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C37616B008C; Fri, 21 Aug 2026 15:14:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B74986B0092; Fri, 21 Aug 2026 15:14:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8E41B6B008A
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 15:14:50 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0F8BB4023D
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 19:14:50 +0000 (UTC)
X-FDA: 85126228740.24.DE8BF5B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 9ED55C0003
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 19:14:48 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="RXaZ/gSt";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787339688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=AHZ78J/jdqJKDRZZX0e5eRNA+CX3Mqn2fRrhkMhXnVY=;
	b=R7sEaxVXNIieSuwbPFKTsI4mzu0pbTwLC4Te293eoKRt0sDXC+YAlzjgxk5xCRnDzagz9l
	IQa0OFVWrxoi1y3DYy7Lo+poqefDmq3/jFPupXZHmU6pS9tgTIIN4rgCmBcvpbzUbsqzmv
	TD1VqWOrfh65seGm/mH1hbUARjO4tLY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="RXaZ/gSt";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787339688;
	b=a2LpZbewzps8x1KPd9BhurbOulL5tffEsJTYQE6IKjyl8tI8x6DXtof+4Ua3wwaJEsxlGx
	f9DYebkaHfN/koHoYTNkMOnCe3ZXH+qwG8hv9H8mplCPamtLtdOeO+eVUmBDQ+/FJGIcHR
	lNFKM7Y/tZeCw9koPaf7GjghbitwvyU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 36F7C61879;
	Fri, 21 Aug 2026 19:14:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD8001F000E9;
	Fri, 21 Aug 2026 19:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787339686;
	bh=AHZ78J/jdqJKDRZZX0e5eRNA+CX3Mqn2fRrhkMhXnVY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=RXaZ/gStHdGcS4pps/13zxlpsYLmiX59pSek/ap95VIeGmzZC8vIzCxpIblqicyVa
	 EUb7R9Es4XuM3WLfTKWPAJ+ho2ac2AJMmRD0LB/XprR0qErvRBOBNE+oF5HxQBp1ZT
	 J0dvCJ6Oab3otKsri2V/VGX/5eSVSxzOprAET9KujjOKk0KEDQe/xHTskRI4S2QmFD
	 ZWlLrQsK+ZoVQxWmj7yT6Q4v2xGyrIdj6tCxn1IdgNLE4gn4gidV8GkY4dFY9cIeFM
	 vVdpsH5cI/mxrDnhtofdreKr9KUrwWWisOUZ6JEPjWvYabPQ+ZAeXPKC3jheTvi8Vk
	 jBitfWypOFW4A==
Date: Fri, 21 Aug 2026 09:14:46 -1000
Message-ID: <85217eefcd770d6e4e0ffc6048e14a9a@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Hongfu Li <hongfu.li@linux.dev>
Cc: hannes@cmpxchg.org,
 mhocko@kernel.org,
 roman.gushchin@linux.dev,
 shakeel.butt@linux.dev,
 muchun.song@linux.dev,
 mkoutny@suse.com,
 shuah@kernel.org,
 akpm@linux-foundation.org,
 cgroups@vger.kernel.org,
 linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 Hongfu Li <lihongfu@kylinos.cn>
Subject: Re: [PATCH] selftests/cgroup: Fix cg_run_in_subcgroups ignoring arg
 parameter
In-Reply-To: <20260820070944.31451-1-hongfu.li@linux.dev>
References: <20260820070944.31451-1-hongfu.li@linux.dev>
X-Rspam-User: 
X-Rspamd-Queue-Id: 9ED55C0003
X-Rspamd-Server: rspam07
X-Stat-Signature: t7igz4qyhs89u9u7ycq9uuuqk6aiihud
X-HE-Tag: 1787339688-504336
X-HE-Meta: U2FsdGVkX1+QRph+iBC3y8GgiQSQxgIYxnw6ug4nhlRDoaiBFN+aa1jRB7nyoYCaoMQX4d6zVLyIpaPZFVCCeSk+B0ZWN4I5ykLe7XNMo45vja3B6xM2jFL4DhvjuUPIVW0U5w0rsfeZtxHNjamLJlfAnZnv4lwJYhuR0vZVDHL9ScUdXuYJs0pyoeRDtCbzCBcOIzgPPWOMnxIKLJgzSKSRDC9xvYwRPX++WV/ltxKXaZ2n6kvkpunIT7k4UUrhyLFDPKlVJzkFKRHdQ+CL7+oNhSoTcxwtnGaPpbiFu0/c3faG58e8DC1fieJH19Ja7RlTbfMpMBhC/X/oU9AhKA4KEGbB3BXMzRCg3+YpmWflTZKTJ9k50K9qQlP/dk/6i8uvfwKXKQdP10oeD4lWvX0u9yxp1Btb73c4bL3PzUqa33SgCVIqsUHYkIwiu7P/jVbmQlIShfsdmNvhgnLtNbxq9RV0Md/CMwWEJXMdNfS9maJa5ARUaU9PRXdxDn/rhjK3lI7SFI9EUTeAVxTgGI57rzmaJ5rH+iPwFpalMgztO+15ntU9NyGtbEX6DjiKxXU3mcolA+lx/OjEJpK91TMhtLKhB93UcmXzsNx211pmFqS0pL6J0FkS7X+bRKFcgZ0g9o/SJuRwP/cMSyC0pg1/GLJwt0E1KP1Dvrjsa5ahpsTzKeb74B+9U27JdmYGCqXjkoX5N0fZeEqByVi7Q+31iIcrqp7Xn+q2Qxb+895Qc3WJeG7ufBVqvEOuKlCdCafU9lOyTrYU9dUWeuWieT+QAWjyzb8kKdOX8xGJwg0SqWAWbhi3TVmD1wM04fnTQfhZ7ZTj0v/9uZNRN0inec6kwy4kqfhuSojJO/q0BlBhFpJ1CKDAu4+uG9+VfrDe6rjnrNikdcprZ/AS6DS0JAsAZIAYGzDeOiwyQq+LcQG8puYFkI0PHQGNo3SmAR1s/wJMZlxxgZyh9eL8jW6
 z6FhF1DR
 e2dJbpAep0mx11GW8nquRt3d8KoENbbmHPCRDHqWPmvU4QXv1CjEKwAhg6TWlGp8q/rnz4JjM+EUOM10sZKMjfGnVqJkURvbQavXaHKvvrWwzk4j5wTDKep3fCoM7wVWHXL+sM1uu+c0QGDkVnZuF2xylrRnfIWpcCbahOnbwi8O7dHPzEyTfLRubWQzDkDt7iDDO9Mij1Zc3uEeyIV1w6On1NlLTgoI77PYsINrS+grKBr4AAckAm2wfoCcG8enfmcrALSG9BaV44sJDL/CzRSzl6GKuqjRjWTm+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Applied to cgroup/for-7.3-fixes with Michal's Reviewed-by added.

Thanks.

--
tejun

