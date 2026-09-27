Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BEB4C9830E
	for <linux-mm@archiver.kernel.org>; Sun, 27 Sep 2026 08:51:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6F4F6B0088; Sun, 27 Sep 2026 04:51:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1F9C6B008A; Sun, 27 Sep 2026 04:51:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C35B86B008C; Sun, 27 Sep 2026 04:51:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A31846B0088
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 04:51:38 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 87532C08EC
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 08:51:36 +0000 (UTC)
X-FDA: 85258923792.02.E0C0F21
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0711B1C0002
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 08:51:34 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Zwix4i4W;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790499095;
	b=OuJGgUDvzCR/5ytuAnPNdPU8RMjbdIKPlaYijo5ZG65Lpl+mecuSpDF+vLNaWHkoo0o+aq
	szWhn3hKV7tV3iTrHZpVaOxZE1AkO3Kdl/o0GIGC3fAHi/8plF5i0fo1qnDqWpHMIP3vzd
	ncUw7zLEwcdau3rJ99rJhas+EnOUWEo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Zwix4i4W;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790499095;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gkq2TAehQkWrC1lsDaHNR2t/+poWofOsdUGZ4N/x/iM=;
	b=WxzoZWIMg+CKiO4QRq3ZFvQKFiH41zw+/nu7ZjJ2Ikr5oHS/d+WEQ5+/k4OgtVu2vuN+Qw
	GVoWVkB0jibSY1mph4l9oqX3RhCV2NxKtHDxVEwngw1QhPeELoGNEYK5+dY9yYy4RgdUfj
	Mqh364P/WP/1kCCPAQDZ3wUKHXRJ1Qc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 524CF600CB;
	Sun, 27 Sep 2026 08:51:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A0871F000FF;
	Sun, 27 Sep 2026 08:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790499094;
	bh=Gkq2TAehQkWrC1lsDaHNR2t/+poWofOsdUGZ4N/x/iM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zwix4i4W1D6eEI5TVOeTmse+b839RviPXvE+wC26ru4pY26vGh9IvXoofxTrWvEFU
	 iiIqUZ97X3DmQ9Llk7g8IaRZeyEeqDXbJImpX3WqKP7Tgv7PJJdZI8HobbZCQMvCfw
	 wk6+XH6ZA2BeovyoSIg5at1Ov+kHGluIYtwcGgAHzUTRwZP6dZhbxpfvjl3ah/OQOe
	 Tp412R3nZ+0jcird7WnfvWgr1OqJcbJvLo3x9aN3Bc3LEA6CwSJBNP5gpHw2ZtuNm7
	 JvUJlERTFWLwK1IeaSfSrF5RPaWcH9DC6KFqNui+3ZB2B9o7k37hyQWakf+nxRdBes
	 NnTBf/Nh5noWg==
From: SJ Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v2] mm/damon/tests/core-kunit: add test for unconditionally skipping the last region
Date: Sun, 27 Sep 2026 01:51:27 -0700
Message-ID: <20260927085128.41506-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260926210737.8837-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: dk54ays9x5do74s3hqefwqeaud7curr9
X-Rspam-User: 
X-Rspamd-Queue-Id: 0711B1C0002
X-HE-Tag: 1790499094-650711
X-HE-Meta: U2FsdGVkX18ztBfJQWrO7+Q3/k+IBPSKwy3UTi0Am2fvP5AvDUGHgr+qNsJupj8r98OYUpWMV1Nai3SMsJz8QjGYdO2i8vLyfKSyyMRxuBhzzr2UDo1jKFG+lnUqinar+reRGeHmfEJEPjGiAnvxHNJrtAzH92jAW16PXm0A0wZbBqPyKv11MdpdrhkfdY8msSTn6sYqm3HLMOpodFqxsfqiuCpS5rMYyMqr5CpOJJn+8o8vTrAmkDZ3mO+H4HtNpNpqz8vvDHLN2uYARqq5Qh9K78xG4g0JcejR2GEK8/YEFWhixpf0viIPbwHDbk7Mi4UbZ4rkJDF+g4rVp+RVIlDmhW7sZRSXfTTCAY7OOqJ3H0ZnGfSBSRoo/wc7fBM0yDeYDjRI0Fe97Cy7xATD3rw0o0Y1dt5lKJL4lZpFHOAM706FEbyQScqcKUYpqci98jiF2ascMKFU/M/SjmlAAsOQVirzb6KCglJIOIioM1hfMHPq8jop8SBoI2anf6jVKPdgNmmbCv/1PBe1+yD6Fy+k7D+BGyKcNXT0YudQdZMtzIFpoyWDcI9upWpdS4D4wAOl1owk9K+9ZJa5doUujJL8c+23r7Km8BNgImJumtB2P5ktM6S1ae+YWlz0AA4h3fWhfuqUMSCOa9Z7IKGbRlzp6U1LD6/dnRuvpCvT3zNjZg5Ko6nn872+U9/pyI8Ypl50A/vjQTHD09Kigziobt4Z4rNmgwIzQY7Gz4Oj4SATz6qweE6tTd001Q4gEgxv6gqL5keBO5XzRTGeBMqAz3UqinDS6VrufxM0QtudZxOCNCKAIKQtPkY+HrH4lX/XfeXzwP7qBHYr5IkVQkJ3s1UQXML/POuxNnqfJoKYf0tcwn3ASNFvHvto+OcTgJKSoPk9ieZRMIvDe2jkTUJpPvg0FAINlJNE5BWtRJrPkmd7BW5TZX4rXpgYJmkdTnxVkGQx12kA1HSDNS1Kog8
 DDfutI/U
 HNe6AJ3u0k5Jlz9eWcMbTU91rIf+bmRh/XX55kD0g+L8Lg7/8WqU68SHwa3rl20VYuE4XM54gpfrEdGAeZG4bkqG7lo7bf68ibgscpS9y5D7IozvrTbEgQJVCEgatIdmxxa9gM+cdizbXse54aTfFi9P9hPyH1gZTWRl4mVo6fGuAnUHnEUxMMUguPcrr9wYq/sUDWTXddVcL5dQugcFdVMNp97kq+1VRl9R4CoRA2NZm5TU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 27 Sep 2026 05:07:09 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

[...]
> Okay, I will change the commit message in the next revision.
> 
>     Commit b3723b596b54 ("mm/damon/core: fix unconditionally skip last
>     region") fixed a minor bug.
> 
>     Add a KUnit test case to cover this behavior and prevent regressions
>     in the future.

Sounds good, looking forward to the next version of the patch!


Thanks,
SJ

[...]

