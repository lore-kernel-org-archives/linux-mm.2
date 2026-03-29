Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB3F3F3D5FB
	for <linux-mm@archiver.kernel.org>; Sun, 29 Mar 2026 15:48:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52DEF6B0095; Sun, 29 Mar 2026 11:48:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DEC36B0096; Sun, 29 Mar 2026 11:48:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F55A6B0098; Sun, 29 Mar 2026 11:48:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2E5376B0095
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 11:48:59 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C32E9C1E23
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 15:48:58 +0000 (UTC)
X-FDA: 84599533956.06.4229054
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1AD3A1A0004
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 15:48:56 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JHSN4DXX;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774799337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DatqHcGsaWsve9hXl2tTisxabugJeiUVHF4L+o6Bz9I=;
	b=bnLC37b+4fLST/ZMFeFpmsJrV1yOnELW9DGZXveGOJETaUq1s2LRTFaNkq0sf9lOJJNk7T
	Nk/iZrxawspV0ZhNzXzUeI2lL01+2ZPypZ8LAAQXEOMEQBGOusgUSngpo14PsoDPijj/P3
	V41qvaXWIgRFSK8qsjOJdpUHIEI76rQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JHSN4DXX;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774799337; a=rsa-sha256;
	cv=none;
	b=AvPp4LHsK9EpY0AZ9tm0qVA/VEHE66sF1mHEJkaSbIkG74D9I29bOQ2OUlRmXBKon+ELqC
	X3Arxypp3Z0hmMmU/t5arCucs/g4hnCjzISYALCHvwE+l2PL+O/guF01+kPQAYyT/NvFah
	oh5lF1ctUmO6bwlJtm4aq2+aXno1CC8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D1D4243453;
	Sun, 29 Mar 2026 15:48:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C242C116C6;
	Sun, 29 Mar 2026 15:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774799335;
	bh=uFlnHGPshtBX5FJk/XUTu+B080pyjwAI0haVlLOs8bk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JHSN4DXX1Ydb153rJVr5YkooYmk3omfxJ38GMHeu1nGuFR+PKTrjKGUR0PJCXb9pq
	 9aI13xBG9NHGk5FhU7ki1+sAKCC5ZYaKcBE+v0ZbrGRyxGxiXGf1sft73TN2CM5IlX
	 bnUwkiby6AXiz4HYnKYh2bb2JbU70rfqlkKfjQUAwYjv2SlwEG8wfjKDQixV7ZJLW+
	 OkLJp/JRs1UNnQngFV2UIpGRSExFdSKn4TSwfFs4Mh+QMeXI82zDToHqJmouaLKWv2
	 +SuGk28kRSV4BMph7m2AxhKzbsY9SY4KQaKFtatSTWSorOaGfJlpa7w5l+8p/EZXe9
	 IIHxVl+tt9bCw==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"# 5 . 16 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko status) [PATCH] mm/damon/core: use time_in_range_open() for damos quota window start
Date: Sun, 29 Mar 2026 08:48:53 -0700
Message-ID: <20260329154854.47490-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260329152306.45796-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1AD3A1A0004
X-Stat-Signature: upirds4bpxc1dc6664mktpez59exgbj9
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774799336-855973
X-HE-Meta: U2FsdGVkX18bDQZmCIQiCyOTNJ8GEgvhRu/sgiqf8wfNHq3XW0j4T++hkSCDxThKtENO39pB98ixElcuSCRaaZ1TEC2SvA3iPsuhz3Z3xH4urdi379a07zn4XJar/+PjGTqhHdraxtD5DDCXGy31Xl9khjyM3iEDpdTq3kjAl26pahhzNRCDIXdkatoqweY4fdDfbly7bjZ2jDqrfmR5CZ4e1OZ8J8pJivqRTpal44njgSw1DVRp5pJkePdPD5whWA8/FXG5+f8AsVp5rsm1b6JBWvmVmFhi+fVOLOpAAwHVoBVRzxeztrLt85uaPSILDK66bt4SmUuAsXE9XbF2q62txCeb+e+eCdES+SdzPlFPlKZZg5+LtwKCGsTkWYxNJEyG6Bpi6idcPcdHbf/vTkVWc8WwgD4R+HpON6qEOqTIHAZ1IPA2X0m7KjLwoEoWCWyO1xdF0uoWjr/Q1Bdd6KmRVX8FYUtIhvGM1J+fTtRKQvIniCIaQsBqtC7U9zhBGwmX/bcJ6UMwyIdktgwbfIpZdEB4JONsfZNC1rQWpuguMsUfOvye2jcqBfRJQEgL8rSSIz6ARvwVuvhbwjie0AKsyWnYk4G3yBJ5Yn/8oXyci6EvaBb1HLACfHAUbp70A6pIxSvy7soKFq1+IYZXnlog70o1FhRdloOiajJeshw1qGHVYJKhsfdX/xT7YGf3rm/WpiFzbs+ZnCKjRzT7rWs2Fa0RP6vRVK6y7lklFNce3y/bx3PVF2UBsBc0pbdEaiMHHSxNpVSDjI/9Nj2zPirQWQWBtUQY6lz3hx02qGG5LvyN82LRr8Bgz0aEcW5khitOrRRSXoiWTFCngPPP9ommjpMqed0zGUQcHS1xOpfX96KklQTDOYjIjJ213g2qrxMDp3oP/3Xr1LJnSi6KY0z3ak42Yey986YiwXpxuRskLZAO5E+XQZyYbO0EB8OgCyHJFbmUs1z/4/fuqDq
 kI2QrX1b
 dx9plqDLYLMBaspijMsrblMUpC1eHDnOFw2/LXWs3ITk6kcROAbFSaJ6FBx2oUhv+tLRlZvXVxcZjJdZjUcGam2ymCx0nFxzX0Lcltp03iW/Eh5i/ow/gRXfXzMsgj44770C/+dqJtxzwjVEF9PSo4u48QmFiM8perutqF7nfKxm1B95d2d/0kYCzGlpV/vJB4sJJvdlRFi2MgXR8mOZEdJhYbSzyDlx8dkoJxRsaF8cHFGdJ2QTNX11gYIRiSDrZ8ixO0M0n2C4eZOxEe/8XHHrks2hGGGDp07y27QiQduwNsJoeg5PyPhd6ac5K8dT4KKm/sadMZXTzuI8FIizt4midLqHlV1UVIs/Rvir5NyPlfgA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Forwarding sashiko.dev review status for this thread.

# review url: https://sashiko.dev/#/patchset/20260329152306.45796-1-sj@kernel.org

- [PATCH] mm/damon/core: use time_in_range_open() for damos quota window start
  - status: Reviewed
  - review: No issues found.

# hkml [1] generated a draft of this mail.  It can be regenerated
# using below command:
#
#     hkml patch sashiko_dev --thread_status --for_forwarding \
#             20260329152306.45796-1-sj@kernel.org
#
# [1] https://github.com/sjp38/hackermail

Sent using hkml (https://github.com/sjp38/hackermail)

