Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10AF2CDE008
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 09:56:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 053736B00E7; Fri, 26 Jun 2026 05:56:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0046D6B00E8; Fri, 26 Jun 2026 05:56:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5CC86B00E9; Fri, 26 Jun 2026 05:56:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BF3876B00E7
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 05:56:52 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 667C3A03F8
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 09:56:52 +0000 (UTC)
X-FDA: 84921609864.24.0C9C4DE
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf28.hostedemail.com (Postfix) with ESMTP id C595EC000D
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 09:56:50 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=YTvn0uMW;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf28.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782467810;
	b=bA7o3VMG5gDbT5J8kZOBSGj2TALoLt1PrttQo7ADvl4RIfPNK7iZzY7eIco9apq/MwTBMU
	wU3Qv046XRXZygvoV1SE5eLLQ6y8rPxGZ67GX7V2+j1Oj5jCkW+JHydDz42gTYcJMrZJHK
	hg7kNjs8Ic0mlJH+wRUYJOkpD1X9KSI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782467810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=PRjTLPlPgo4RP++aNKoyqSFzF5p07vlm/FWH4+ncEtw=;
	b=FeWf2IvoZZi2UhdM+YB58/MN+9EtOihXkvKXN/gb9aYwj1kGK4FCkBb1jOhngScXBR2Zoq
	XgCgnNktuliLSsIXdhjRuzllOi97I0DLejvBI/oF0o5XGmmDohvrP9S1k/Qi8uFfxhlDL5
	YOB6do+SIPq6cs1Lpr3tsMkFDrvf+WM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=YTvn0uMW;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf28.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Content-Type:MIME-Version:Message-ID:
	Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=PRjTLPlPgo4RP++aNKoyqSFzF5p07vlm/FWH4+ncEtw=; b=YTvn0uMWt750zGg234gGUAVN7X
	LWkp3LeykRqkJumToA5aojtkKJSYnrjisD72fARWxKnZaPAJo6g3mnuO1DveLBo7hiNmf/KK7GYSb
	dj+3REQZHHnhx3RzLlznr8PdcGeYv3Bl0nET1BrUnoFNLUu3Xqz4rQLGfsZXNWrJIMZA4sYF03/AZ
	VuY2wx6XtWua6K/LoSD/iz4eG6xMLIVACguZDf0wU4ram5A739/cZKMcEN7axoOt/6oqgBDNATGwa
	D3pCB318HoLQwcmGabF4HWG4WvIKIxLmD9DuLX4Ujt2CLKI4T7W3C7wJs9yi8kXsRBshtRu/Jd0YP
	IPgzfzjg==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wd3Ie-003t3h-3C;
	Fri, 26 Jun 2026 09:56:41 +0000
Date: Fri, 26 Jun 2026 02:56:34 -0700
From: Breno Leitao <leitao@debian.org>
To: linux-acpi@vger.kernel.org, linux-hwmon@vger.kernel.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kernel-team@meta.com, linux-mm@kvack.org
Cc: Breno Leitao <leitao@debian.org>, kerneljasonxing@gmail.com, 
	iipeace5@gmail.com, gavinguo@igalia.com, linux@jordanrome.com, amscanne@meta.com, 
	sj@kernel.org, gpiccoli@igalia.com, Daniel Gomez <da.gomez@kernel.org>, 
	mfo@igalia.com, platform-driver-x86@vger.kernel.org, 
	acpica-devel@lists.linux.dev
Subject: [ANNOUNCEMENT] LPC 2026: System Monitoring and Observability
 Microconference
Message-ID: <aj5KJEIsTl6IK0nX@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Debian-User: leitao
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C595EC000D
X-Rspam-User: 
X-Stat-Signature: qkeuwurgj89szwudw968gm8s4ggq4jck
X-HE-Tag: 1782467810-789881
X-HE-Meta: U2FsdGVkX18hTWm94pxiunpAFRsGTcH5mjXdokg1bXWyOvwXAKv1NFz7hmxRZlZRG7Xw2x6RBEKRy2UPYx09C+Ow5Od2kg0DRs5Mv7ASKRNb7vmacdNsZPBkzt1TylvsxG217dXJtVL/W+ds7eLTAp00fF6CZ1GyRSmOe0it2CB158x5fruh3mpSS/GHXSd+sNHKQaB2Uw5cDDdl5miDQZbGE4Dggp1Cgi9jFsgqVX2YFYgwfS6BhbyyPL1PE0wBGGar6Q34argpe3k32TpbrOccfe6Rj1FTJAgjQprBNOBQ95O2zfqzFM2aJa9mGhF5ZPwnyqBI4ZU0OEqwys8xno/AkRXCTrijgBt1eWqNWOWTZi8y6gQhq5sOkRpsiKHeLRH4chc5yzPS/WbPKrdSs39prWRUFAu2M6M72MPFs1U3PfYSCCDM3GfQ62lume58//pP2TOAo7mUAckv7zpabXAVuA/IwntP8bgPVSg8zqYP+5Kk5Swxj+jJqXiNvwo5UaIoGwqMZEiKE/ITpUMXtgWB2iFlxRNJKKYTyk+dBcLZ1PXiucA6d0ViJ8bWGOvmArnbfl2CFfCP/M6CeqxezkNZq49uq4OiKm7ICQ1PokdkSMU6foQ1tmyuOAIErEzheaPSvVhjxfNYSO+Z8hNbl9RJpfJchmFRFvNk8dCi3gNEt4kW13uXGomHXVxtWTuOg2oK3iczyA16zx6h2AFHrntqjP38bUxoGk040aHJs2dPR//RAef1YcjUQ+2vGZpQD7dKCg391yBBnUSxaArUJ1yF80IEmFBDKURIoxpsEqowpRtEDjY9k9unjRwlWCQ8V19Qu3m0MMEWSSzMj/gXSCph5d18zRLyxvmsIb9HWhx/r5b9jOeBhxMt4BkPApPJE+mrVXEFv2GhdapxMnEgmxTG9y+TTWnvKEuyVJbbXHajzgOTKWGJy6zXQ9EUa+LCXLdJ1Wb3QKugXyzJJyA
 0qF0gJ0Q
 5ZMrqo4fyP5xmUUzhcPfSnlweos+t+RXi/SH7v3WJZcDryfMtwEL9PG0ufmUhKgxO1VkbyujssXsnQDOE4ASYvqi/4kKeCvba+P0b2YWajsHAiV2Uyy/PiBgl96T/tMVS3Xle1oFL7QbpOVrrgIEdvo7gEPzrmDuWRpmrZ4XqzbAA8d5ncLlrMzz8iiHZuQI302qgFotbbqz1kfZzGQdxDmcANdSacuXcl9WZHS0O5ThE78swokW5jzfab+QxPBewu3qiaMHI9IE7xjd02dxx+/Hp+ENEOhk0+j4vqZsYos1MN6Lsc8wwBo53PSu3+498Q6LwMuTZxf39U0435vIVCsefuQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We are pleased to announce the Call for Proposals (CFP) for another
edition of  System Monitoring and Observability Microconference, this
time at the 2026 Linux Plumbers Conference (LPC), taking place in
Prague, Czechia, from Oct 5-7, 2026.

  https://lpc.events/event/20/sessions/262/

This microconference provides a valuable forum for key engineering areas
such as:

   - Kernel Health and Runtime Monitoring
   - Hardware Integration and Error Detection
   - Correlation of Issues (crashes, stalls, bugs)
   - Virtualization Stack Monitoring
   - Memory Management Monitoring and Observability
   - Anomaly Detection Algorithms for System Behavior
   - Automated Analysis, Remediation and post mortem analyzes

The purpose of each talk is to share challenges and discuss potential
improvements. Sessions will last 20 to 30 minutes and aim to encourage
brainstorming and open dialogue about ongoing issues rather than
delivering immediate solutions.

The conference acts as both a knowledge-sharing platform and a strategic
venue for guiding the future of kernel technologies to better meet the
demands of large-scale infrastructure.

We invite you to submit your proposals here:
	https://lpc.events/event/20/abstracts/

Please select track "Linux System Monitoring and Observability MC"

