Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65541F34C61
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 04:53:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1EA26B0096; Tue, 14 Apr 2026 00:53:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA8A06B0098; Tue, 14 Apr 2026 00:53:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A70526B0099; Tue, 14 Apr 2026 00:53:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8F60A6B0096
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 00:53:01 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4CEEB8B5BF
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 04:53:01 +0000 (UTC)
X-FDA: 84655941762.06.AD6082E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id B9665C000A
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 04:52:59 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nDrjrILD;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776142379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=NHIuDIccXYmO6SuakkBT1UMvOolCzWUAJ58HF66zBuU=;
	b=VvSWwqHC3T9Mp3HvJoX8goM7Si7W9IakF6w62cF24LLuJf3vWtObOI12dqRGv7mCvADg+S
	P7mLTQ4DzvYkhUvmvzuzN5RHzZ5cCwQajWp0lgdwTufqNsodjBlSW/mc4ZAn+k6Bw1VIhQ
	jZeq50ORWMlhU+sXKfvisNw5d4nPM8w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776142379; a=rsa-sha256;
	cv=none;
	b=vZc2ptjRKXpPHfJve3iEul06mAUTW+gSau9B+mjsWS3z0bUPv7vErWdSkY2UyN+xg8eEqh
	tvHroJbu7xxhcMFPK/BwYsobRxDRB0PfOPY86YLRgKAIItAH7wp/KDu0glqpHllAufFciR
	QmCa2TOx2TLATFCfpgdEGrysBZghHl0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nDrjrILD;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B0A9E439BF;
	Tue, 14 Apr 2026 04:52:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07293C19425;
	Tue, 14 Apr 2026 04:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776142378;
	bh=XFDfAH8hl/rMT3opER9N2QufMR6JcD32h69OYGzgzeM=;
	h=From:To:Cc:Subject:Date:From;
	b=nDrjrILDP4rHksPC6RwjPAn524ADLrsUsXjqEaGTIk8pf2gBW9l3fl2pacUs7maby
	 4pvYqbVKpnRPbKhNESPPkDoPFxW4hnQeHEVh4/vr3+SInAjjBVC1NGJWkCMcAB/AAA
	 1rVKNQEY3iA46yIx+gAVVsziQHgT31aZekIhyoX3HfvsQ8g2jjpIOVP159Rs8T6Zsl
	 xWZvDbiPZPb+eknG9T3wplPTnoZRp/G5WlQsPuZvU+v3dj/YwXwuOPPvpySMlPbN+Z
	 SiE26TNCgfZm4RtjvRz0XxF5JjwB2IhwWdmvtwLJbgA/MvAjSH66JvQOOq/3dnhhyF
	 oiVJNVZ+L38uw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 0/2] mm/damon/reclaim: support monitoring intervals auto-tuning
Date: Mon, 13 Apr 2026 21:52:49 -0700
Message-ID: <20260414045253.88529-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: ufc3y4d7dwfkszboicoi8grd858jsnra
X-Rspamd-Queue-Id: B9665C000A
X-Rspam-User: 
X-HE-Tag: 1776142379-857230
X-HE-Meta: U2FsdGVkX18mCyCZviWAl5B2oqwHgnEsjMrKuVuHg0dGoEur2wN485lTPl55SWebaMrkdAIng4TnxEokiTLaBzZovkdX1e8DVXd8zaWr+T2A+pbjLGcEtZYsXk+yXHNRWo6dpaWsqWLnDIL0UORCAIo4oYcYDHDxvq2Saqetgr0LCNsispQ3f1760yMmQbmMeUHvMLMhiT1Ngh4ls1AKwiaL3H7ygFlCLOKwHmNNljRhmabBR7wHlgPxLni62PhmuVPrMkPWfsMapgCaK8ws7pl1/w+um3eIuF/tZYHq0W+K8/V/dhD3yWoqtb/O4asuaqkXu0xpEGkteoTXYRvmbToGELWobLpraNs/q3ELvYUol/xAvjWaDIgdBaw0MQ+mghG6YRnhE9F1Uz0XxkDuvqVP82+IokPCsaGZe568qz6pKUZ4QotV4v1z+7k0lJry3ncn2P5UpW9k8bBZuoS9EIs91ByDymkIpgEOKfugqGOCbGiclhFMvmW/zUPz/ge9Nz5dfALwrWCrZqkbZpaoECQ5Nc2kCVQ3hkoEdKOj1ggqwGQalGEHAU63BAvmx3oSE7eAuYewH3FuAfJlZDzH+1v1pM0Wowt04LYcBGcz3XddgIqqmiHY/wM9lX3TPVz+NPGiDvbVX8jrhptLLjrAcOJCKzth+42YO+JdSEc4aLG84bBGCmzRNPClmTfOKeJerFmqlTTkfOWCYa/PLBbJ0nHvvMQV1KxhFVi8MVrzbvMI6I8q7IRPdN5bNw0yZV4K0Mwe1M14eYW0KKNu0V/qQG8hva0/BajkthHHSF/D6xW19f50wOWp3dnvDbU5Hw+pNuV+bOXqVA5T6eMqHrhgL0orRR+9McftNVjsVIisDN+1XbnlfSNQlfwTmfqVrdJ73hRcoQm4ca5l0qEnfX/dKuiYmJygVHJI/0OT/TYrvRF6ZjGXrlEHf1l4cLAf011vP+V79TY/wUd2W1oMY85
 FrFHFEFt
 PN46osJP8CNrhl0kZkETgR8BqdspJ8DHekdQeXKFAaTlpIBgL+59KxqmyAGtTIpnwNfJNZSKR7MEY0oC3RsSgkYE0fY496Xtbey2/czU9qXxe5IrSh4R0jNz7XBnXyG2SELgCwlHvs4XSOqIZmO+DOwkMsYmnbjvxmmBpp0MRxRWDid7ykYUX0aFrdoJJSUAM61nEpT1exmGyT08=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The monitoring intervals auto-tuning feature of DAMON has proven to be
useful in multiple environments.  Add a new DAMON_RECLAIM parameter for
supporting the feature, and update the document for the new parameter.

SeongJae Park (2):
  mm/damon/reclaim: add autotune_monitoring_intervals parameter
  Docs/admin-guide/mm/damon/reclaim: update for
    autotune_monitoring_intervals

 .../admin-guide/mm/damon/reclaim.rst          | 11 +++++++
 mm/damon/reclaim.c                            | 33 ++++++++++++++++---
 2 files changed, 39 insertions(+), 5 deletions(-)


base-commit: 02f9b1619307bbcf7028704a50f6b31909f360ce
-- 
2.47.3

