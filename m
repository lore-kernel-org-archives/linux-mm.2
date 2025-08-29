Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C7BECA0FF0
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 18:52:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D86D66B0093; Fri, 29 Aug 2025 14:52:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5F486B0098; Fri, 29 Aug 2025 14:52:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9B7C6B0099; Fri, 29 Aug 2025 14:52:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B426B6B0093
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 14:52:10 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 50D5F13AA9B
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 18:52:10 +0000 (UTC)
X-FDA: 83830690020.29.E55E8E1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id BD365140003
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 18:52:08 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=X2eM0xLc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756493528;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=67l+n1pMiK8FlCYn7fKODIdwbNNJpw0JxR11aekIbJw=;
	b=MX28FB/dCZt6yv6RGrDidTGBoJMYekLsLQrOc8xGWq9k37OpFY5KPzw+CZQqVfILBNDmGF
	hhuGSxewMZhtcNfdUsKGEXflwDKsCMqGOfzttgjTrcvPlsuFjoH10yE1YU0Jyf96t/CkpN
	eg0jkPrXnnyfAYjh2KuL/APPNwUbE6w=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=X2eM0xLc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756493528; a=rsa-sha256;
	cv=none;
	b=mdkARu5jB79IIoBDuFKk3BGXH+JA/hhyZ8QlaaiKn1PHyhfuWjuURTmBJ5TXUueC+oYs1r
	deWjQ67Qhfjlg1ZIwfU2pavjyKCzkwW3UpRzG9cRgqsPRbYxsT+/r1pROeFRYoFLuPKGH3
	Q1gdVb3IKZ2rpeIHmNMIEf123eox/nM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C123A60142;
	Fri, 29 Aug 2025 18:52:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5437EC4CEF0;
	Fri, 29 Aug 2025 18:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756493527;
	bh=qmsHZ6sbjc06Br8Tkud2xTC7GZa7QfX0mo0abZiZJQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X2eM0xLcI+a4qxdxHLf/reNd+V5TipASvEktXH0x4Gmp3M6SozLMCV0qOFTI8xgb9
	 pIlYa6zMBtyZEB8wk8nywv+t2UGS2RUJjAknQPytSERrfS61asfm4Z5GtlZQq3LOfz
	 HOyaWTdpmxf/EIu5D3p3Mkqpwwu6BY1YjH1riEPyY7+7C+zIXyKDv6Jze65Nm4CjWD
	 l98LEnO7gqups0CjXddcL58E+28VH5CV/M5HOqKET3u0QaE43JDlY1Bsm5qNLiDRTW
	 E3hDLtIt9kk+kVVLMLgZbjEKEfd7q4dZcS9kmfd6oOMQlsT4rmS9uIBXjYkjelpa2S
	 iE7/lC2faD37A==
From: SeongJae Park <sj@kernel.org>
To: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] tools/mm/slabinfo: fix buffer overflows in fread operations
Date: Fri, 29 Aug 2025 11:52:05 -0700
Message-Id: <20250829185205.60231-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250829095947.1828094-1-kaushlendra.kumar@intel.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BD365140003
X-Stat-Signature: 15nh9xg4ou84hefoh3fsqiysaiwe84k9
X-Rspam-User: 
X-HE-Tag: 1756493528-72049
X-HE-Meta: U2FsdGVkX19m62josWKysgBjLiG7DuEW11ysLiLmUpq8YZGPFGiomzbg1scEuD0r5FzG0Wm5EPxYuq/c75lKkfRjYg9k3o38Qu/XGmHzZk0ytaLOf1Pb69nVS2zXIgfOnvTyMCcPck9NLh6+Qp92XpfTOvlcdpYUfcENRUDi7LNP3ezTjy7NbrE/nTuhWoVKQ96X1vmrd+IfqrKREv8ARk937W+fsKAXsbEJdyM8YhM3GUdOqLbhdM/vAvijg0DLZpMVEwLAsr+AOmaKBZYhS328KWdPF6+MiwDSZLhd+D6vVr9WZbhMek2sgTjJfxSqbTAFqrSbhIrh3WOIHMyPiBTJw1fUnBv8D2MeYBWVk8vMSVS5/WQd3lNM8UmazDKgog4paLgeSex8LuUplIYKXnU5PXNE4mvc6S9y/cDh4DW/tcky5A7SBagoTtAiMfB5nyvzrjB7cM7ff4x7FWNe/X7e16ZXNNsP9xAX8HqXLt03F7TKr1TlTdkF0ZCSLLQJMFIA9APOTQw8r0hjSw9BtwMbtmSx5DSPo1J0r3THMJGwL90xlFZ88G1a1zJ/NqsAOaQTOPRP1C1Omvj2fms7O3wCZJMBa+y+n2WJ7lbeO26BnVMts7ObuEsJFHH+w13HTpm0al9o9PVtV1XuK+/4BZkrmzF5NnxDWnQIg6WFvEpph+iGHm2P9VSwwxxOVO+OeJferWPTYtMSeLrAVv7l5W3zOjj6RjwjWxcUDMTgj3URwqLeHYez/NvJbw7ZO/H89pJht8bzux1KJCUH3m8z5yqgTLbElWFhx1IBcgLuw4L/mpe0U2zIdzCjLMCJyzr0mo5AJD1VMX8EYlooWp2euAEESF29qnqsIIyNctyvAC3FWdy4ueh34lzkRmJVI4YRzyCl1G+/kNY8qj5yxiiHL3byALCb6k5jTRmQ2VfbVWOqVc9sH/VnmD1+s6vRUx3LjpqKDfV6FRXl5c00lAk
 z99ii3MD
 PCdg1sC9o/W/BGrhzK7OhOmssvGxwoMhkWBm9SHEOiQ5EntujYYmKLRe8jmnNcfFp7KqXjEx5UBDjFM1f7fzQ03OErfhd6intb1XHqvVvUbmtmtLPkYiiWp7BToi8n1YXNC8dU/XXQ/aSb5Gpbgxk1Xb0yydTh8/5YRQ0Ncp6jc9Pslr4ILthZuG3ODlWVc//lGyhzHHBY/ae383XvmvrE1UtcdcPx2bxF05EZjqijbrxIkT3U5MbKuDmS+aTLLHwwhak
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 29 Aug 2025 15:29:47 +0530 Kaushlendra Kumar <kaushlendra.kumar@intel.com> wrote:

> The fread() calls in read_slab_obj() and read_debug_slab_obj() can read
> up to sizeof(buffer) bytes, but then unconditionally write a null
> terminator at buffer[l]. If fread() returns sizeof(buffer), this writes
> beyond the allocated buffer boundaries.
> 
> Fix by limiting reads to sizeof(buffer) - 1 bytes in both functions,
> ensuring space is always reserved for null termination. This prevents
> buffer overflows while maintaining proper string handling.
> 
> Signed-off-by: Kaushlendra Kumar <kaushlendra.kumar@intel.com>

Acked-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

