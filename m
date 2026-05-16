Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5CF7CD4F3C
	for <linux-mm@archiver.kernel.org>; Sat, 16 May 2026 22:04:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 961086B0005; Sat, 16 May 2026 18:04:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 912116B0088; Sat, 16 May 2026 18:04:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 828B06B008C; Sat, 16 May 2026 18:04:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6F21E6B0005
	for <linux-mm@kvack.org>; Sat, 16 May 2026 18:04:17 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A66744044C
	for <linux-mm@kvack.org>; Sat, 16 May 2026 22:04:16 +0000 (UTC)
X-FDA: 84774662112.14.549ABB3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 166C040003
	for <linux-mm@kvack.org>; Sat, 16 May 2026 22:04:14 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="aXDo6/EH";
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778969055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8qKfMlQ30CNioGbh6/z/BbcDiMXjFbijFsn1I8ikRtQ=;
	b=HZYr2EMjkLzfpIS82EmPt8ZZGmb4AAhBITdszTyRZ/tVOnT8clsTr/tgeTLat5MUDsaNma
	SZg25NGxTI6rYn78ytznph0m+44x3HwI5b0UceKLSsI0hWniG871IKe/uvux3+D0Xw24NS
	aA2VbQmSgQQJT/TbmCjuSOSHT+Ugg2A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778969055; a=rsa-sha256;
	cv=none;
	b=UbnU5MinXxei03AU3b5BmJYPvBAODVyPjjFIyCnlVqQK4mG1rubFcQ8Pq7WWZgRlfNPu9Q
	VS/3hBdiX/d0/6HPlyFlKZsOnMqBLX6qYu39jraiU9sZLMDjwpX7QktvDdQ2+auZYlXtR8
	DXiOudObmX3BPPpi2DRRF9VSgiVdavg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="aXDo6/EH";
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 617BB60125;
	Sat, 16 May 2026 22:04:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5B7FC19425;
	Sat, 16 May 2026 22:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778969054;
	bh=jqUJDOVFPnUp4elyBS4bsFweoUttqEpYWejG0EQ9Hc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aXDo6/EHMP7g5zKEG7iKB4Qxz3Lrf3sdPP5zBHOr7Y3UUAL8c43gxrU6tilYE41jC
	 PGIS05HaNt1c1lq39JLyLx7tr1fsaS4GxvX28m0svfsyH9NkRtxbHqZnAN8y5Ve3t1
	 HlD0mwOVEvoKTnYOYUqnHiTCC+xpylEd3rKQU7sdj576eo3TbikY88DaTTWQBv5MdH
	 oO6dwlxNN9jdO0fV8UGwzCWG9H++dAOoL5njpZ+OE6h0xY4GsC2lsx+bEuFrG4EGnu
	 TbM/kd4xFvBR4mbObgv9kexhyiyLNK9QLPvIdM+TO/4qNFO+ScKXoKfXEPvyKzpDpH
	 o7jpPzwCY6BKA==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 00/28] mm/damon: introduce data attributes monitoring
Date: Sat, 16 May 2026 15:03:16 -0700
Message-ID: <20260516220317.4300-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260516183712.81393-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 166C040003
X-Rspam-User: 
X-Stat-Signature: 8aq8kuitq5aw3ihd4wiy3n4o47y7uriw
X-HE-Tag: 1778969054-948612
X-HE-Meta: U2FsdGVkX18f/qhHfTNs0zOfGYChq2iL+SwDH5HAu2ZkrHWYgqKQP8+aQERDPUQuO2qpSTkWc+w/EGyiz/HWa+4PGtMzeXqTVkMTl0yfPgLBYj8JH+rNORAOa0/INhZ40BmXnIIa46h6pTkyiYuaHvOrsnbt6ivgZyagQlCpdg3daISlVTAT/lpSlw7XdxKEoMz4SWahNMH+aInUwR4idN67wj6tapnbRDp7Hp5XcXUmKKXN6stMA1v60PYrnR4fDM5e80Pc6lYOoNQAwqcoyit0NeO5cVBdLDpUS+wupBSx45bkE4qad5tepoo0lefiQayU4lAkIy3yqV7MukdWr9zK+cVNmgNoLFzjJ5Ho28x+d2W+AimT5aDk3tmCOlkGBfbK4isEXH/0sXOLHTtfDsH3uQ2GEnYE1fp/dgQ20hHbR7nth1XDrntzvqzBrEYCos5K3kgnPom1xnbHWDiCLK7MhybfVcp1UbjAXxZQs4r4Uf+Sr7clgKHNPo+CeBcBhNhMeRyU9unvlxnmhGWFJHMW33qk38+L8svuteW+Q+RKxqT3D+/qqc9YUnMxXoVFNfGNUGf38PwzuF1h+Oo16GNzG5EFrhTBgrFrOLU/P91FDuWZeyIw+HPU3DAdiZuyY751JGryRRQftmmzegCj5pIU1WtgEjkDfoMtq8miHjY5G46M1rUO91uciXZuK0jbHHifPDbaEC3QfvZonPE3+GbxU2a3HFfyyzqfU020BLhn9Ts8lV3jIS8j/huU7/LdDlwBhLpTaDnx+mjKbj3sEaJYJzBq3J/lCEeWLjN1GVORtfjUnlqEm1WHJ/Y0qRrJ3euk8atY97H0vxomZoSdHViSPF84xYAPEEOWymNSLpPG/NLfWTMRIKFSJS+aXGTKt6/rXDmGSNfO1stRUKa9Y67hjAyusIiC94sVBBT6B61ZNa0K/ykxsJOrxbCJJ7AzhhNC1x2iWbK58atH4oE
 ilu2pU8q
 fTLBMsYgNMEdcDdUzQx+IFMtUfnt01FCbqgj3H0Q/Wj6S7XqVb9hS7U9mA+K7MKaXTNiFHMsfCqynEndD/RMumeJLjSqqkw+koJFDc4JYOLq/+MJ2n37AC+ZJiNpbPellMCtZTymhpfbWeVCNqsMP0zK4foWbMWOZ4oP9hMhe55EEUkHmh90feBa3VvDpCdQ3nnlMEGWlYa0lGkX/ksPUuduAiO0CcwPL9anzp+ZrZYE9hStG4CBT/hFt/RXTuuEtROV1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 16 May 2026 11:36:41 -0700 SeongJae Park <sj@kernel.org> wrote:

> TL; DR
> ======
> 
> Extend DAMON for monitoring general data attributes other than accesses.
> The short term motivation is lightweight page type (e.g., belonging
> cgroup) aware monitoring.  In long term, this will help extending DAMON
> for multiple access events capture primitives (e.g., page faults and
> PMU) and eventually pivotting DAMON to a "Data Attributes Monitoring and
> Operations eNgine" in long term.

Sashiko found [1] no blocker for this version but a nice document wordsmithing
idea.  Unless I get other opinions, I will drop RFC tag from the next version
of this series.

[1] https://lore.kernel.org/damon/20260516185032.82261-1-sj@kernel.org/


Thanks,
SJ

[...]

