Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 650D8CA5FCB
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 13:52:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42ADE6B0092; Thu,  1 Oct 2026 09:52:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DC446B0093; Thu,  1 Oct 2026 09:52:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F2636B0095; Thu,  1 Oct 2026 09:52:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0E1C66B0092
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 09:52:53 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 70C7F120441
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 13:52:52 +0000 (UTC)
X-FDA: 85274198184.10.F98A139
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id CBC4E40006
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 13:52:50 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M88lOybB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790862770;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q/dRH3J5ey76kvRdwTVhhOoQZVelrf6ajc/JT2v5uHY=;
	b=hKMORnyKFIc6KummlMXXwXM+IKnrdfHlsAut0extG/P8GPW77p4JbqVXoDnnUIdVZgKYYX
	rdOHnu3IJ+URMG4BVCNtRICmyLbx0C+4d5u49/nBkQzFwJ5zPNI3wz/4KOL9kLuiA0hT2P
	kxZsKZ5BUTGJPQWugzDyVIDuPg9e4uI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M88lOybB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790862770;
	b=kiLluO0DvnpSjgYrzPK7Jh4yQte9GX+Art433eu9syOnOOWJsNMz73+xFdttg1f4BSIlqZ
	Gpor/OJ/XsIKzb7w681kLIlbj8VNr/euO3eJHze8m61XwdoOoeIbgB4hT0wffqedFqoT59
	NNkYzXu0kdD85cJifU6kbHFF5u/XGPQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EAB5743495;
	Thu,  1 Oct 2026 13:52:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 162861F0089B;
	Thu,  1 Oct 2026 13:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790862769;
	bh=Q/dRH3J5ey76kvRdwTVhhOoQZVelrf6ajc/JT2v5uHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M88lOybB06xf6SoaMF1Ba5D8/68u9I54qfijfvr8ckFOjZLjRbMAic/Jow188uaaw
	 RJDaIZtAA0fPbQKnHDuglsYY4R/RG0/frYveBJdceecZ2C5ju/dolgQzXHnB3TYUeG
	 8ELBuRmkeXCNHGsXxqzX3Bmm/bseUFK7HYkgPXvDotLAyqmDlTehns/ENExDYck2hN
	 Gi5Frz5akCeEsPeq9nbElpEsB9Ywdj7o5ILuwp2rpeH9skX5xGMfoog+WapA3hfESR
	 l2dic5RGb+fbM2Z5iqJ2yFqLU/5t2+LfDLITCfFBCiVMZgjKvyqRR/MqKW+qED+P9m
	 KQq4NSijV9gxg==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	rppt@kernel.org,
	sayalip@linux.ibm.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Luiz Capitulino <luizcap@redhat.com>
Subject: Re: [PATCH v6.18.y v2] selftests/mm: hugepage-mremap: fix mapping alignment
Date: Thu,  1 Oct 2026 09:52:21 -0400
Message-ID: <2026-09-30-1-daily-reply-0017-hugepage-mremap-draft-v3-6-18@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cd4c16d1-d23e-4321-8f2a-6754294b74b1@redhat.com>
References: <20260928130916.231112-1-luizcap@redhat.com> <2026-09-28-2-daily-reply-0006-re-hugepage-mremap-alignment-6-18-v3@kernel.org> <cd4c16d1-d23e-4321-8f2a-6754294b74b1@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CBC4E40006
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: fe37yfuf5s94emhy1jkfphio9j44nhq4
X-HE-Tag: 1790862770-948163
X-HE-Meta: U2FsdGVkX18QbsFc+NGBGBt/9R+AqcmH8/BwlW/D5m0g8YtfyABwmltUni/H0gdTBgZnjpHPJ7sk3cBNGYsTjWJe7pxGCpEc7bFF8H/O/DuZyeNiFv7ehQgJ0HRrqr4FRxxWMtPTfuwPZm2zyfyYtXPF+ZUQFTXFtL4PB/Tc7SuAla+ezEVkt+srnKVJS4AVnGY7Ns05e6K3Fx/OAe1L7MFfOP40/l5pjZvDt4LEsvsH77JKHcyJG5e/3C2xBccuhDGc51LobCZoz9quxk3j4VrFBMqfQY2Ot8CwYJDvUNlLwHKTmEv6hmWVTjJNpJCJONkqQNnx71FcMWTJjC5sV/9TYCm93N5I79nkKuRCEiYFA7Z9KBr4ABoUg41RymMJ8k7vXX7OY8z6xp374luQcSRVg07tebS7OiCu/WkZPY28wysu2Kr77sDafCezqVT5JVQPIp+EiGWa6KNpGH2R5qVgExSHZYe2HX00SuWG9FdYYXEHybG+sdAnavrm0XaWqAZFNS3tcavHmu15AfOZTcfWRhq0LuKKlgOnDvQ76xSHrDz0+rBtOP91gtlJg3fOWxomqQgQlIqa03HF74JrkzkiyHSey0TOHiuBi4uZk0cqxFrXfDkRdU1/S+KQOf6+YYF8Up0BvXsv9qhScEiTq7HKqoGFuWgRUIkkw4V5lJaOu4wafR6q0oI3Mq+97bHsj5xDudS04cD7cZrgx1WZpZzlJpkF3yjURyJcvwZKKNfT2Db7XLlpBOzeqKVQhRWdlwhFUElXITg643cULVQzW7OM8NlFhmfDyNe2G72iWYYsjEly27DKiTPyRbxA5cfzfAtGI8urIMulrZBFYUZdjBrvKBU7vYpqiedJ2BqZtjBhRWdlvGM0aEyATj2MacjBUCo8rqrb5t/ZcErov11MZwoqNqvYy3pU0GaSKehFhSpoD5pnUr1ZjLgIDaVcxflw5o3JrvQ+kW3G7V4r+/e
 sX57AE9T
 0u1zJ1KHAPsb5vbBzNBRMlwBF+9qgG7HvRaYFtM2tgN5Gk3TvpBjWtn8d9eN0ZZN0pPzCRt2HgumBfi6Z24TJD+NE7tV58mhHtbvCuLSq5a7riHCOwn+k5cYZ3+90ZFg2AARycxESmvo66H9kUSROF8EDgBvWY9t5POEdPONE/aGHT5mJfcNa5120zYBDXoX0ibTDAb5WfCUiU1g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> My intent was to explain what was being fixed and why and, as it's a
> partial backport, I decided to author the change. But I'm keeping Mike's
> original changelog & authorship now, can you review it before I post?
> Note that the subject will change as a result.

The draft looks good to me. Please post v3 for both 6.18.y and 6.12.y.

-- 
Thanks,
Sasha

