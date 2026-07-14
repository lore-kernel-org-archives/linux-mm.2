Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9216DC44501
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 14:32:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58D3F6B00C4; Tue, 14 Jul 2026 10:32:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5645E6B00C6; Tue, 14 Jul 2026 10:32:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A11D6B00C8; Tue, 14 Jul 2026 10:32:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 234176B00C4
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:32:46 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 95489C03D0
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:32:45 +0000 (UTC)
X-FDA: 84987623490.17.A3FD451
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id F1C391C000D
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:32:43 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ZZ4dqq/N";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784039564;
	b=0UrZAD5e+YVvmwegfLYt7IkR8k6U3XDpt9ecH5shfsSp5AE6ZM9PFe+hQg3FBkB1zOz/kZ
	2vO0ls4xlaeAZkIDHYjZcidZopA0wD1HrvsIncbqGknNe1ZBNQ9BTswbEDzRKyDDhaa5Rl
	xm84QAxDCPwOKhpyyNeds0lwCDXwSEo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ZZ4dqq/N";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784039564;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5/zj5P3kBIK7G1tNe4Uj26Vul5lA6c8YvgqeoVqk8Lk=;
	b=G5kEwMn3Nm/jD2DcXHunh3h203LfrvVI2xpvJ2gc2GCWEKok+HQFjqpFSUwRbYJhjaAX1T
	mxeGmU0URilYU1+Azz2+WvxeZUjQIrpK6WOsMXN1W6bFUV3E6F4CX3T/2Sgu4reQcwJyr+
	aoyq9jBoEhpQy0GCv+MyD/R3eqjA/j0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 03FA74330B;
	Tue, 14 Jul 2026 14:32:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 689B91F000E9;
	Tue, 14 Jul 2026 14:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784039562;
	bh=5/zj5P3kBIK7G1tNe4Uj26Vul5lA6c8YvgqeoVqk8Lk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZZ4dqq/NLYqzSBAfNqEuQPntKdDEgDfavpxCNEIReUT2xcPV9tGz8TIGmXkdJmtmm
	 nyaIZjSVagD1HUrgFxm/UBjbTlNEYIgP3rIl7n0meCQ2szIcUNjZ05f8aKXcZ86S0D
	 7ag9fFiulW78YngOCtCIvNf7WTvqyLFRunseiNJS4CYzTKUeigxoHPJAVrZOVK1Bhy
	 fSu+hxitS/iMtDtvBRaZTd8QJs+aKxwSODjhTa7lxZPi3Z6CdeZoT5d0BH7jEywOa0
	 +Cs5jPEytY5O5UGJ7R28senYzRux/PPPxGzWAJ8i/mDGmX5hcgK4/im3g5oGEeqdAF
	 66QJGXNFmnKxA==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	stable@vger.kernel.org,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	Fernand Sieber <sieberf@amazon.com>,
	Leonard Foerster <foersleo@amazon.de>,
	SeongJae Park <sjpark@amazon.de>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 0/5] mm/damon: unurgent fixes for infinite loop, NULL de-ref and races
Date: Tue, 14 Jul 2026 07:32:34 -0700
Message-ID: <20260714143235.100843-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260714135236.92699-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: F1C391C000D
X-Rspam-User: 
X-Stat-Signature: bmkro9s9zo47oim3yjdutafmwfoampjg
X-Rspamd-Server: rspam03
X-HE-Tag: 1784039563-298787
X-HE-Meta: U2FsdGVkX1/9Z8GKMe3TcipKmHQUJbMxh9mQvxQaHWP26v1630pACqwIB2Ya3PZWerkwDHINwlD+kUaKsGCk6pPhCBmi0ZB+w59XwfnYwnlWJH+QNImGkeTM76x13T2JNHMJwNliRJMelr0rhvhmp100vCpleX9kENuFOMdtc1r0SKubaQfGbxpv94WAHYIRcUdqNyhgil3umIxcAPVrwKpTLxxWpWpn+m+ODqpjda2YT6a7UHN7k+9pK8TOSHGagXORv6AQvG3iGNvfEKm5GOvdVvWGl3vXsDN3QoO04F8Y4rIfj2GonlSqV6CbXwSd7CduQu7zPwtiUHOjTqrbQ8o2DIwqJIQt6rK6dl5BjwwUpiVmOpLfhLQR9GL44ooDp+kVH74G8u7kEh/pqt4lR50LqzkgUZfiW0+xP9P0DdD3p14HfVAev3NjE6HkxxkigI6c2s9vOFMvKPBzIH4cA9efdPLoaENhkjKVp/qFcOXDksZyqi+Yim9TphXSASV4+3Zgn/Z0MgT1uYgjWWSpKjUBmJmjbr1lroBb0B1qGyWOwDv8jFvXS7ksS5cBFUCKvDlax41uIVE01WsdOqzd7q8MO5XSBlAAksZ6fgSUBpybdf8/izAAnVzeeWlDFFmrBPuOdWw0BQJkNN5KcKhFNWmoyBNpzG3Hn9X22yQhoHvSMGCUHC96Y3X8BCQWDkJmE3BoMPUCz+J9Yh4oLNNKG2dmmO18FTfC/HTe5+4ud8VfLoF27MB/Ij3rOe/cemyJB2XzX/BWz8ZbIskDHlsQ4j+LoSQ3qJvRx16U0oEFSIgk0Orzj76keg9ijAWUVeTcXxH6rdybBlwi0izCsbLASjkv3PvBez5uUrNKTqIVUKslY5fhWRBGqnm1u9uuSwCk/ctUXP/r6HsBhbadsN+jhBmbR2mTwZmCX0z8SMK/FCzSogX1wjILdNiTR+fKKcZipE2AstA4tZvGroIpeW3
 u7ZLrSwf
 1hCIpDSsd/KM6lGWmHoeprFVJSDicS8HGRSNuyf/nPuuHmld9rLySUqaukQSSOSE7QiK1ifQTf2CkNbI7S0st5wfTYQ6GaJkzwEq/fWa8wWEB7DhBIikVlp5wK8Xv1amQ8r8XUkw0OvRFWwXE5hHA7+Ruvw1Qn8Zr46w1TGvxZjXuTN7pXDxWelx9B971cgK/qa3IMDSqrAJHQgYYLpsjD0MGkyhPeI0kkojZLmDJYAFfvLc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 14 Jul 2026 06:52:28 -0700 SJ Park <sj@kernel.org> wrote:

> Sashiko found a few issues in DAMON that could cause infinite loop, NULL
> dereference and monitoring results degradation.  The first two sounds
> scary but the infinite loop happens only under unreasonable user setup.
> The NULL dereference is only in a unit test.  Monitoring results
> degradation is trivial since it is only best-effort, and those happens
> from only unlikely races.  Still those are bugs that better to fix if
> possible. Fix those.

Sashiko found one more bug that may better to be fixed together with this
series.  Also patch 5 mistakenly lacks its Fixes: tag.  I will post a new
version of this series with the fixes.  Please don't pick this series into
mm-new for now.


Thanks,
SJ

[...]

