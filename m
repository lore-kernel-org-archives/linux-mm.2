Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8DE8C5B572
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 13:52:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8EA16B0095; Tue, 11 Aug 2026 09:52:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3EEF6B0096; Tue, 11 Aug 2026 09:52:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2F9E6B0098; Tue, 11 Aug 2026 09:52:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 749B26B0095
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 09:52:51 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 64CEEA2716
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 13:52:50 +0000 (UTC)
X-FDA: 85089129300.13.0DE056C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id CCAAA140004
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 13:52:48 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iI8lKPFW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786456368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9Jv8mZDPr/MJb+TNlWFJFke/1QnWZMAtyRHDCHFmtSw=;
	b=CQJOQV9JnyxounHPN206d2Rz6ECS638sZIYQyMHCFwx4USCxtqXN9AUu97Thw/QuX9ZQ+S
	Imw9fVlJ9Qf1328XrFcXiE4fTIPnlebP9xnhhXl2g7luM8D1zRPWnIS/oYBfNaf5ze8axR
	scVLvscWKPw+AMuk53zQvbjcJLU6U1A=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iI8lKPFW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786456368;
	b=Mmq9E0XapUBiPkBGLXqivhU7GGD3mVoF9I2OSxpoBlUH2XPzJZzi3VQQ75gkHqqcZlL50N
	5PaLBmhL7dfZNxfap/0/qgBBrchp/0TXMb1BChvLtKqMYF2S1ebiNBIsIFLmyq/JhGwK3p
	1Ty9qqiPWMbRZerQgKoYhTJIhQpYKSc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AF3B9600AD;
	Tue, 11 Aug 2026 13:52:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 423D81F000E9;
	Tue, 11 Aug 2026 13:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786456367;
	bh=9Jv8mZDPr/MJb+TNlWFJFke/1QnWZMAtyRHDCHFmtSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iI8lKPFWx1KDsgmjcDLPSd1CLv9LAsxlBkP5dLQYcxswuEdXl+cLqYZXwz5KrtiIH
	 8cuIyydv9xDAEC1DUpd2zcintaqUw5QXdzPorw+l9yHayc/Sd6wQm4qJuhMwMvgkHP
	 l8BffRU+gNP9m+yQ659XBztqsvlZ1rSxYByZtwfAiLm17ZAqURNsM1JGqMjzrICRnw
	 V3buT0DVgc1eLXdrwePCBxklB1r5rHiY9kMQMHrV/wi97KJlhI6zDYpR3OqOwS90ii
	 HJNihx2vNv7+nxswspyiFR4SlC1XuofIrfyF3za0AStabc8qimVNVBmLsuze802xxz
	 JL2NWu48OZSug==
From: SJ Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH 3/3] docs/mm/damon/design: fix typo of max_nr_snapshots
Date: Tue, 11 Aug 2026 06:52:39 -0700
Message-ID: <20260811135240.4756-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260811101841.804596-4-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: 7j17w9kpsgeczz13r8updhgap3hmnifb
X-Rspamd-Queue-Id: CCAAA140004
X-HE-Tag: 1786456368-90595
X-HE-Meta: U2FsdGVkX18EGdZ2qjvb2cJlYy5UhtAPo0RsvL7cjo4O+59hfNl4figEgIxkHrc9COP5jSV+y06hM56YpTa8wNomNX1egISXiFmQpycK0yPrBFlQ351AhIf4JdloeaBmcZJU+ebXyJNs2p7Idgp2pm39sQq9TzFBmGi6aN/A/R0tacEpf8c6lYMbz1jURMqSlr5NSYYyDgFmsNEipQS+TSNzp0Z5CguIV5pWVfCUIWQHpSG4x5xG5O5f5eK0jsdQNe8zJf6vE2Qm56jBZMpyhNu0e9mrCX383Tu0rTRbnjebkazwZiZSh/+uNKrkRNBFCj0DLuavNI23TDMyqiSQvyvk2qjaMhcDUTJ/6O/F3leTKy5aJeCjDuoH1weQ42O0gDNt8ggZP0PboLWcsUeNoSCcEvuEon1HuDkCyRoskJ8mHDmR6i8jAOABlbj10XUaWVG6yyB4RUSuWcyHN0eVrqMsMWQ+msI5Vyu4QBqUeAh4UxcGMgg78zfYIXQu6pmCZXQkBpRVLC7pquarRgh4ZJn2zYLlyrKqaQdd6AGFYMxM94OHB/N5sVxW7rVsSDBj7K0O3UOSPiSGgwIr+4vyzHDLhtfsrUXPWnkbj65XAuUr28CcEH5N/DWvoQBPhua+ExNHsFubte5x1ZxX75cSUuw3PMEEEVhwl7Ko23FEtHFXwLJWOHMPizoWlmhHgAP3ehgrd7cpF8IHJvl0wZ3gRQI3Y57M51IZ9pJ/cvdV4DAk4igvnEILyTgmgckgUW2Qx5T7DZlEJwb9s/LnFRm4MoKOHDr20YpVEv+CSpRENTJabtpUxEpTm9wA71y34GPNnCPFW6XyB7Kt/JJGSKIqnGay8GZZOuVukWYws/63iaK2aJFP1dl7fQnIKOd63FZr+8mXIo1brjnFU2Ro21Vgvs6l2LOA86C6413ClhySckgrWLeGJcVS9dCZ0i7CktWu0mLEEj0Uaz7vtKXvkbp
 XBBqTWSs
 mCYDSRqA8oaFVzOvcm5Jw/+mRFmtEPbgSKC1P7BF9OxjFJ/hMGnnXcY9Iz17nZ9VqhXj/2nn7Ln3BMp5l1R+BgNkgFHUN7z4aTsSY4QAUeeZHQX3M8JJKaiOhQ7QG5t4/xoy4/ApAhSN42dRBo/kgqCckLEkrX9A8bJlLQA6a5CqubdNCDh9WwWT9U/NlKVFOAkbATIbk6ZhhQI1LyqHi/h4U6LpPAUvJnf4wQOw1l+libk2ZaBTAUC2882trhnA/RX+GM5HgrFn+LOvFK1D1hkGBffSbapvWuRaBKZPsL9UBwAo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 11 Aug 2026 18:18:41 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> Fixes a typo (nr_snapshots -> max_nr_snapshots) and corrects a grammar
> error.

Looks good to me, thank you for fixing these.

> 
> Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

