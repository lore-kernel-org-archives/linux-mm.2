Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADFD7C982D8
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 00:54:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B592D6B00E0; Fri, 18 Sep 2026 20:54:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0A2F6B00E2; Fri, 18 Sep 2026 20:54:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1FC16B00E3; Fri, 18 Sep 2026 20:54:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7B52C6B00E0
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:54:45 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 076CD4015B
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 00:54:45 +0000 (UTC)
X-FDA: 85228691730.12.05F6180
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5FF59140006
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 00:54:43 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gbKXm6GM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789779283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rj4ybuE76WuF89f1n+gXLecWdMn9NDviS9spf9nLa4M=;
	b=Ubu1fph9jFRdrNeAe/bNdSX3AiDcIjBco+qmzMb/sludwYSDGdyyU/k0WO0oKMB210Elw+
	8QG4rbAPHxGlJYOvsWPtP7rJJLkZbYttGNupSRJ/beynERzPkP8huWJIdWbeBVjuWI19Or
	0TDQcS/OpXb3DnW8O+jXRX8Q8197iyU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789779283;
	b=xAz6sto4rOG8NoaJkMc4+P6KL2tLVROowfJmfnSrs4S6PUbiyuQkFlp+w0rApOvxVABoXx
	HHgxMGrd+ajNsctI/twtfCPti6XyhB4GfMK2Wsx+DYc/+SiMZyYmF9m+ma7z3cRB51+99b
	5ZvF+48CVAXxOmfjH0KZ/2RILrHH37Q=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gbKXm6GM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9241C43893;
	Sat, 19 Sep 2026 00:54:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2445B1F000FF;
	Sat, 19 Sep 2026 00:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789779282;
	bh=rj4ybuE76WuF89f1n+gXLecWdMn9NDviS9spf9nLa4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gbKXm6GMPcpzlVpDWfLpRuHsropA3OOvGBk/dC9HOxo9dJIshBc40hoFsxVom6EQh
	 cX0dSOe7uxseZ1viRL9fHJXKX+sKtLgqSgo/UvXHXQBRLToZ904Hov63N3XncL8oIJ
	 oTQDxDWDvz0Kad8zgq4+9b7u9b6DfDL662O8adLCMtTSNzUdO64vcu7LvL6gyeiE3g
	 o2q47THez9vdeDOWen3+xn2E7BGB8qCK+KCB0tDzkJ5oeQhTCAwcTgnXEw3OzEGojz
	 elp8IABXkmM/W/vfVbnxCxoPZ+I8ckrWKtE4zpBboHALfO6iNJOh7EHKDkp/Xi55Xn
	 LLQrpdbz3/sJg==
From: SJ Park <sj@kernel.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Muchun Song <muchun.song@linux.dev>
Subject: Re: [PATCH 1/2] memcg: remove unused page_memcg_check()
Date: Fri, 18 Sep 2026 17:54:34 -0700
Message-ID: <20260919005435.87535-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260918165601.1014666-2-ekffu200098@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5FF59140006
X-Stat-Signature: e8gdn9newdxk4jfgcdi9ukz4yd5rf7as
X-HE-Tag: 1789779283-577320
X-HE-Meta: U2FsdGVkX1/kKJ6m+WAU6JEUBKJ2+7Ks1q03kZp7VLK8NqXtGD2h1UAlHfEOn73+arlmzXlUUSWshnYuL0tL8NMA1b+wBIaHugI3oBlVmT+nacgnbCb/bVVoT2YDyrQZwK3XAO+t9en0gv0qsEqbYID7hXj36ZPOWUQMCnBcTpELtaX5JlAqPcn9yQL/HnkT83W1JsQiews1KbQiSwtTPj/1WHVbpBk3PMrYkLkdhmQI03laHvsW19DnaU1g+82DudwJFvQ8ljLzZwTsQXtOC0SixETfXpD+Q+5+8rvYaSP4LJ/5rV+LD4SAHs75MQdvnS9u0Gne4GYX68Ja4JVRaepKAU4T1BN2Q5izGadjMWc+7zKKujcyWrjPUyfaNIwh5B8QPlaXvBDUuRylrE8TLjXvTKHz+COYaRWoWSIVFRgkZrBWVKKJwCOWsk4lwQcaNDvHUa+2LjJ2i6tBjYOb54JvuFgyiK1ea7KMFMRy2YB60/SJshMIltLfidiB4c4Kfq8MSPZFy9adkN5Y7uENWfQqbpp29D5Sq49UV7/O4IE4usJ+TIwp65cGvIhj0iqAZrLhmbWjEG6j3Ygc7CjHYoniwwlf/vqWArLNnYA5RfsXhrJCQEg+dV7eNw6giQSrTnt6mYKI6qykaS3D6vKW9/OpcQxOEY1nXGrrvy0Pr1dcwVFGTdjqVT7qBx96AEWzSizWT1c0y+AO6/vJ2TKCTftz0zj4mYCqXjfkOncEnAjvVfamayOLT+VxWA6GtS9nEBiXMSbOKyOSmcZeCV7V/dPZT8p2pS3OTIrHVaOa66svHj9XMkppW6v3eCYO/kzRPh2iDGbqf8HNcoE8Yf7bR4uYuEtuihHf1ptvsXoxTN67FTphM3PQb+y6usl4uaMZFoIMHM7Ua6pKBepDuRRcN81zb77Q978x54cXxODYySFTAWyRdbUEwRMMZFgwQtiDpDPjCGANWaL1X8bBL2S
 7z5b1i07
 yAMR9mDvPguh/LXL16Jjw+kALLhC+g2aWYHQqzGzMauQ2X0s9mP3/RDa9NS/moS7OQEJrhmkmu0MrplvK64g1ylGvA+HdycdPrYERak0aJ/HXPJG/vCkl+vY489A9JeJxsy9cmx3zMK5UgfO8oIG2LiPfXj6KAKUUPG6vp23InSXgkzsa7sksg9AiPkJaJKpf6kFB8kVjnGQW+x5srSc8V3Vy0FgB8MeYcYWHxsgyjhMchM5yTyb9vZLjkF96muVGew4v5CfJefJm3UXBDMe7mg3+320k86RfSv/dpnDxcdHEbXVkRCRC9fwnh/ju0932YQFMXVAjc5zC/VQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 19 Sep 2026 01:55:57 +0900 Sang-Heon Jeon <ekffu200098@gmail.com> wrote:

> Since commit 90f095b816e2 ("mm/page_owner: use memcg_data snapshot to
> avoid TOCTOU in print_page_owner_memcg()"), page_memcg_check() has no
> callers.
> 
> So remove it.
> 
> No functional change.

Nice cleanup!

> 
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

