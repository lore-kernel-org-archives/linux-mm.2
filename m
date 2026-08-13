Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50789C5CFCF
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 12:18:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3000D6B04D3; Thu, 13 Aug 2026 08:18:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D71E6B04D7; Thu, 13 Aug 2026 08:18:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F4456B04D3; Thu, 13 Aug 2026 08:18:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EEAD16B04D3
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 08:18:53 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 74C4F12013D
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 12:18:53 +0000 (UTC)
X-FDA: 85096150146.27.5478733
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 83CB14000F
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 12:18:51 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JEs2I4+Z;
	spf=pass (imf11.hostedemail.com: domain of joel.granados@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=joel.granados@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786623531;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ofrdos4HRkDuUR+YoiUFpWkzn//vxHsatqCHEiCzJvc=;
	b=DZ5sTHh/iFfBqMlPPDjTk7NOL4IeGiK7Esa3P4bx0tLg8pZoPTZc7haz3ly2bLOrfRdeRK
	yd/x1l1CD66ycaIU+YiH9qZXgZz6Xe/xK4kueZoROD67MOeDJEUMP1zYSzPhAQNh6nzDEF
	ASsERjxqqICRb9ytfCduHX5gbNedwvo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JEs2I4+Z;
	spf=pass (imf11.hostedemail.com: domain of joel.granados@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=joel.granados@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786623531;
	b=qRjOOrjyB2HcXW5QwMNxHtWp65q+V+jSmEY6A/DxGTQnHHu7KOqaC8kpwGFWgWzj6UqS3H
	8/KNyijgRos5WfCEwuFtIpwTWoFO9ZTrIxXw+tB6CiCvv5stjbZEaemVdeHYlKqU2LZTYL
	QJiF8qsdRRmh8jeRJpriqE9vffhBlD0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9CE3740965;
	Thu, 13 Aug 2026 12:18:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 71520C19425;
	Thu, 13 Aug 2026 12:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786623530;
	bh=D5sh1ZrCd0hPEkiCqVMezIB3PdvCVR/dhJ2i/eaqwyo=;
	h=From:Subject:Date:To:Cc:From;
	b=JEs2I4+ZY+cmQWtgDn89XMY+xVrM856WY5S0OIeEr36hTRWGQAF8A5A97fop4cojt
	 rfewltmxIRkwVCeB2W7G8IF3mVFGYlVDsXLA7XLjXPbZaOP6qiA1MxKO+Sq8oi0gtM
	 TQJT9fDyS8nSz+16WGJEeQhYUx8mueuLBNckBz0RozanioqjsKVq1hP+RwX+jFWzmW
	 AUP8F61mNUfzxh+TVGWLQL26lhvfXYYKrJZyYVOQYXyMeNHwOB+SqRPpNFuMJafDQQ
	 fSK/wD1stJy83oIKgxpSylM0z3YD81pYSHtkyN5ymBXIY3Rj0/SgWTtKkuXXi4ZFju
	 /lv2wkvnajSXA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BD8FC5CFEB;
	Thu, 13 Aug 2026 12:18:50 +0000 (UTC)
From: Joel Granados <joel.granados@kernel.org>
Subject: [PATCH 0/4] sysctl: Disallow partial updates of miss-formatted
 sysctl vectors
Date: Thu, 13 Aug 2026 14:18:36 +0200
Message-Id: <20260813-lklm-partial_ctlvec-v1-0-df9e51c13704@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIABy2fWoC/x3MTQqAIBBA4avIrBOsqKSrRIQ/Uw1ZiUYE4d2Tl
 t/ivRciBsIIPXsh4E2RziOjLBiYVR0LcrLZUImqFbKsudvczr0KFyk3mcvdaLi2Urad7oRtDOT
 SB5zp+a/DmNIH/EmjWmUAAAA=
X-Change-ID: 20260813-lklm-partial_ctlvec-bd8867b70d5c
To: Kees Cook <kees@kernel.org>, Shuah Khan <shuah@kernel.org>, 
 linux-mm@kvack.org
Cc: Jianlin Shi <shijianlin11@foxmail.com>, akpm@linux-foundation.org, 
 vbabka@kernel.org, hannes@cmpxchg.org, surenb@google.com, mhocko@suse.com, 
 jackmanb@google.com, ziy@nvidia.com, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Joel Granados <joel.granados@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2062;
 i=joel.granados@kernel.org; h=from:subject:message-id;
 bh=D5sh1ZrCd0hPEkiCqVMezIB3PdvCVR/dhJ2i/eaqwyo=;
 b=owJ4nAHtARL+kA0DAAoBupfNUreWQU8ByyZiAGp9tiYkyITKihVvtdZSvziyOBWU4rrAKyjLo
 7jVUN8XrP5xcokBswQAAQoAHRYhBK5HCVcl5jElzssnkLqXzVK3lkFPBQJqfbYmAAoJELqXzVK3
 lkFPEKQL/3p1GXmI3YjeYKDHQGH/Ku2m6Y8f5aS/ro+V1BnPyrtE1xVVz7A05MULY+5AzoACOvQ
 YKkqXp2+tbVETWOVv+DcyYbx0SjSasHEYz5lpVdJgG7dh0sPgt3hDTXU7z96LHdyPyzR+XJ9dZv
 rAS6Fe4UruLvBC/tPgZDsMesTcBYFYyJYzz5LrhIJ3F1dNvSGzkWFGq5UEelLvzZqY0sCQ5M5fj
 zv8jbjskCi8TqpkYj9TeVvtI1BiR7e72H5Goo/V51fTYKX7rNIg8Nbo6e4M0Qf0vIV1MMWUG8fy
 XTDp7QeroSVp5Pommp9R8tFCrae+ZwUqqQ75Elf/x2YH0cv6lcqJd9yvVDCKXGjywuOQuBD4xM4
 n1YfoQuT5dhRxpFznN5mwB/uwyZeOt7FvJEg7rCULKBWk46AUL1yw2JG6fkbrKlrCdcrCBqecov
 zMwhEJ5DMzEhF9ANzTyHuU51ahqEenLL1QY84uoHxrQrsqNN5+T+mS9/UCRBHQsCX1WRbjFvkO+
 OM=
X-Developer-Key: i=joel.granados@kernel.org; a=openpgp;
 fpr=F1F8E46D30F0F6C4A45FF4465895FAAC338C6E77
X-Endpoint-Received: by B4 Relay for joel.granados@kernel.org/default with
 auth_id=239
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 83CB14000F
X-Stat-Signature: db3wtmhn5hbc4z8dmjzfxqz5ph9mnsyd
X-Rspam-User: 
X-HE-Tag: 1786623531-748393
X-HE-Meta: U2FsdGVkX19poNxZvbLEmS3LzPv3KYc6+0jhRK9LlTGF767xc7RZeiybJf8tL7e1Z1MJE2mvQCJABvHVdV24PkPNGYnQjWUEjkXpUUhDoPNcfVj1j6hUL3qJDB38wcCi9e8qg+k0Bk6g6MSJ4PuuV92DhYAhdaou21qlm6w2YNrvaSpmmgEYcFomZE7bH4XkKCQZRHrZ4R7V5G9BTIrQTOI+0s+m8BSsi6i8CnVWPnZpwABnJmrH9/Yt9cC0niWv1JHCjsqkt9AGR6R7wUVWWJUOqgpIHST7roKgrhu7bpIDcBjd9nOn2aqThXpHd3f/xezyxQBQwApIBA7qdlKt95KsZJz052WUAnQf/0hmp2FiF2horm4t9RWbQMRtZwT0EmUGxZl3VACoAexcV8eKiRo2dLV8lL45jiKpCbqHhBb3dUY6ns0VN1bcubwIZjMbTIq+hz7v50/FtqkBfFjvweHdutrtPNbudz4hzprwtYg/29Co3CB6QvknuwM9J/yhMJRPjnWGclkOO4Z0gNWU5g4kzGnxz4aXYRx0fEgopSwYSQOmlEUhjOfSWJG/Va0wxR+LLDyoKzTfcIajyjhoTQ7rATDTCcdDeOucD1yfl/lKmohPmdLWYLdKEn2Nn0B+m0bmuTOzDvBsPiSlXzxI8EPJFywfdghCAn78JlL61J9ezXv7To7xsUsUMb0Hl2dKS+ga5UGcHCL6ZdeVsq8/9p+oNAqkziUvwEaE5/Chz7UefURfeA0bEvB+4JN1JtN4KClj58gBvI/nO0PXF/JxOXbVrWh1Qutfvw4fXi3f1bZEp7/T+2r7MaFgBZJZBZwGvqkE2CHe14PJKQBnntJgy2o/Q4XyoMPYYzY7vjxberwrkgBLFLCw+paqgXEN34YkjoAjIRWZzH6OTy3LV9REbLStuX9ZJOvYrY3aJUJJuPu+AIZN8YMfUvPcetiEfbt/vZOCt11BXP7N/EhvcaK
 7t9N6Iso
 HrqqwoYb0h7hfQEWGXreA0GUkrLdnHnuWVYbVgBY5D8jIgkrBOdkrMItEmHv09/SAPpte0hY7vaPir0bGVP1Le87fGO+JoFmViN8Glln/VL0PPpEEiyu1oXmvLffav/IyyA/nCXpiSnHhaQnBhsmupZ9L/zU8Kz6EjaVxMkcV0SmFirjIWukoeIjsdDWZ/AekmlQdNsPELsfuQ2iV3cyX5/crbFmRyflpPcCU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

What?
=====

Stage table->data when writing INT & ULONG ctl_tables. Commit staged
data to kernel variable only when all the conversions have succeeded.
This is applicable only to variables that represent a vector; paths
pertaining to scalers are left unchanged. Notice that partial updates
can still happen if less than the size of the vector are passed and
correctly formatted.

This is the behavior we are protecting against:

  # echo "4 4 1 7" > /proc/sys/kernel/printk
  # echo "1 x" > /proc/sys/kernel/printk
  -bash: echo: write error: Invalid argument
  # cat /proc/sys/kernel/printk
  1 4 1 7    <- the write failed, the first element changed anyway

Why?
====
Allowing a partial change to a vector after returning from an erroneous
proc_handler is just plain wrong. This should be handled within sysctl
to avoid users having to do it for themselves [1]. 

Behavioral Changes
==================
1. A failed write will not update the vector
2. Vector writes can now fail with -ENOMEM

Testing
=======
This went through regular sysctl kunit and self test. Also is posted to
0-day.

I always find it difficult to know who wants to receive this. Please let
me know if you want to be removed from the Cc/To.

Best

[1] https://lore.kernel.org/all/tencent_A860C873956A52E26AD8D309A308A241BA08@qq.com/

Signed-off-by: Joel Granados <joel.granados@kernel.org>
---
Joel Granados (4):
      sysctl: Split data conversion and file position handling
      sysctl: Reject uint arrays before calling the general proc_vec
      sysctl: Disallow partial updates for erroneous sysctl vectors
      sysctl: Add 0013 to test partially updated vectors

 kernel/sysctl.c                          | 228 ++++++++++++++++++++-----------
 tools/testing/selftests/sysctl/sysctl.sh |  57 ++++++++
 2 files changed, 205 insertions(+), 80 deletions(-)
---
base-commit: 4c12287001da60f3c022bb25932aa7a5590fc0b1
change-id: 20260813-lklm-partial_ctlvec-bd8867b70d5c

Best regards,
-- 
Joel Granados <joel.granados@kernel.org>



