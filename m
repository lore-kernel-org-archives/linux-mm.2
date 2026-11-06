Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB7FC606A326
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 02:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Tphx6Tfi
Received: by kanga.kvack.org (Postfix)
	id 7FAED6B05B5; Thu,  5 Nov 2026 21:06:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7ABB46B05B6; Thu,  5 Nov 2026 21:06:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 589326B05B7; Thu,  5 Nov 2026 21:06:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 363406B05B5
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 21:06:11 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C7657A86BD
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 02:06:10 +0000 (UTC)
X-FDA: 85403054100.28.05048D1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3C2FAA0002
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 02:06:09 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Tphx6Tfi;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793930769;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0n/wDrzFbORfw6YzEg6DroNWO8MgvFUslfYGWlwdzxI=;
	b=6ZtDuCJbYlDCjFHtoq+74G/yulwRdNC/tm5xvXpZ3EasYKTVpd9KyqqR0lpSZxiUXFE33G
	KDcY2xaSwFI6Q+O3mFfs4u8zGFWJTmJktgcCAkKyTkEXxCJOXeJecQWTsvO2so7B6xqQK6
	CTNerSqOIZsR7bB4qr2eSZkUJyQiKu0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793930769;
	b=ZwJLqEPLFbr2UDjaF7TCu3nUSoWm2C2g9u7ooS8TZLSqQEgfqjrqC+WCpqIuIgjkurVPd0
	UKg0oSQCg3LhcFpJcRp9wX7u+2O5gzIkkrDpP2+7KMwgR8Y5YA/5qrRJS+4xWVuEOpFpbp
	M+a8eJLNiqaAaqX4ED0bnb2KCBKBiQg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Tphx6Tfi;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D82B16020F;
	Fri,  6 Nov 2026 02:06:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B2711F008A1;
	Fri,  6 Nov 2026 02:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793930768;
	bh=0n/wDrzFbORfw6YzEg6DroNWO8MgvFUslfYGWlwdzxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tphx6Tfik8E4UtEnOk8Clt/iHUWlHE6k1PWmjL4eJTrPCPcxUwl5+3udkaPcNrUaV
	 3/z9ygt75kQexmfFkoR79CmuIg78I8JbA3mUF9OBg7TCq3NK+BdukJSyeenTWcJd0i
	 H4Z6L5acwe0egZDICo87IHlxCzsuIWcffoLi/GrVvoK9BwcVhfHRwzQGXOYZhedKQg
	 ptMN9VhvdzR+RzuMfCDNoqAgjSjnNW4ig5xRWF7eLHQaye/ax+itiZfHjT/o6PL7BQ
	 LYuErvG7amcFnH+i6tcKiMK4A1uyRZQb0h2FJTDRL/RrJosMEo2Y8Qfw67Xks8bGQ9
	 7IfNSHH0Qo95A==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Aveline Noir <jm5905938@gmail.com>
Subject: [PATCH 4/4] Docs/admin-guide/mm/damon/usage: update for age_ms damos core filter
Date: Thu,  5 Nov 2026 18:05:58 -0800
Message-ID: <20261106020559.98352-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261106020559.98352-1-sj@kernel.org>
References: <20261106020559.98352-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3qaoyaz94ehiu8xiuapdht418385pjxn
X-Rspamd-Queue-Id: 3C2FAA0002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793930769-519028
X-HE-Meta: U2FsdGVkX1/gcdkrVSIOu1tyDyGHWwRM56w4qfVlgNW1nQn0SjUiqLtvcsSgr1+yNzgjOV52vPEqsOmcegAxjNWS40G8vKWFUImgzVAO+tUPlNaZyzsz74bg660b9qrNvgW0Et8Z7a04UUkPEwUUa8VNqEjoCFEtBDkeZ4d+mZtPuXDaCu3hKH0hDVE0ES60GVTPI9cwgUULhGc73p/pMwgR6aoxyx3TQIg4u6tXW91kXmlAc5LBd6+xfqo7SAln/IC3pvD50SjLAKlVe7urqh0cZ9G+4dlTu3BlJpElnFZHwGfN4WSdi+qF0GdsyX7bh5SLvBS5+KYusipYsEXaJcQrAX6pZFIptMImZOtqfKGnevqzqsDCIdf4NGix3SQePpPBXam3h4hnPCvQdS2fmgulF8urbKZ5YDMO3XeGX5A100OxS4gWErmh/4/Ylufi02yAetCFWEshj0DuIhs6lROFKkBWPkJESjGrb0OyaJ98/uo+mfiSnSIYWDJ42QYtgD0ovaOex+FstqR/+Dv57kq9DLlxK61LZYFCxDgoUTokraIzGa3h/oem7lAQAjMeqaXFBTyQW8H/71hfvZrz6COPJu4wIsaakAEB4N9kgfnI7HORbSNcDJ83jHLi4VbTpybwtwMsY1WU1CK2i3IgFtZfm0fx8mQh3z9z9WsQHmfRli/hi7LwTs845nVy/coWa3v/TSF9MxYRQ8h1mYCT0PbViUFYU3FxM0HhZpK8CB3VBABe9Ni6pU+Wt1hxynqKl/k0CMfa596rwsqXntlLaeFgz7l3n45J78tCSCn/mT9EzhjsXPz+qWJ+qlqke8DTojxopdUNxHRjY12Ax/McRhYRhz84KCNNvSAYrkU6PbtjBgsYxDZ8leXAPG4UGK0jpDwIu6fHw2LqpCjB4QvGxvSRfIaEI816enYIJ1gNdEa+iVlh17jSxzb37V8va5WH6lFhRDKDadOBGpZxXKI
 8LMVvtgb
 m/m3xinL78bp1EA02VwH67FBABp5z+Z+KR89WQBnxbcVPJ2DKImgVGxwoYf0Vp4ZFTAuDd5hiyRunVY6u8BBLWLZpz0dN5hqYjzq9s0++YUsGXZKZ9r5vN5e0unrASkdyb0vHcT5F6jvVvH1vdwTHs/HPBJcstBY+aj7DyAmYxftpuDWWvcl4Fhn1q0fA3cS0TlN1Vc6Wd41eakvCC0+YAWOHOFDamzZSdwXv05gTeaumQy3tpWvEQ3JYL//FP0p8+n260PbDg/idLMwfiarDRPoIpB+pEtUgUoh/oAQuBN0Ns2UrMsbZYP8fog==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Update DAMON usage document for the newly added age_ms DAMOS core filter
type.  Add an explanation of how the age range for the filter can be
specified by the user.

Reviewed-by: Aveline Noir <jm5905938@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/usage.rst | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index cc7465251bb6f..6093b1c8fbfd9 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -559,6 +559,9 @@ For ``probe_hits_wsum`` type, you can specify the minimum and maximum probe
 hits weighted sum value for the filter to ``min`` and ``max`` files,
 respectively.
 
+For ``age_ms`` type, you can specify the minimum and maximum age in
+milliseconds for the filter to ``min`` and ``max`` files, respectively.
+
 For ``memcg`` type, you can specify the memory cgroup of the interest by
 writing the path of the memory cgroup from the cgroups mount point to
 ``memcg_path`` file.  For ``addr`` type, you can specify the start and end
-- 
2.47.3

