Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9896AC5B572
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 00:38:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C0916B032E; Fri, 14 Aug 2026 20:38:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 771C56B0330; Fri, 14 Aug 2026 20:38:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6887B6B0331; Fri, 14 Aug 2026 20:38:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3C7116B032E
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 20:38:39 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B640FA288A
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 00:38:38 +0000 (UTC)
X-FDA: 85101643116.25.03A011B
Received: from mta0.migadu.com (out-152.mta0.migadu.com [91.218.175.152])
	by imf22.hostedemail.com (Postfix) with ESMTP id AC456C0004
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 00:38:36 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tWfwiQO6;
	spf=pass (imf22.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.152 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786754317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=COZfGlZkA+F8qfY+ts4BzwM7aozbYLRWFXOYMsCiIGQ=;
	b=wY5R1lhUR1m4800C4IabBIo2DGfq2oPvaK3UKyoQ0qHZfLfDL0DBczt4DW03jSGEY3XDlH
	T4j/m/JThxZOEAzflHsQNN42IxXYgSL886LdjctRebtWfdQhllO3UjWA9UbwZcgdLLYtmV
	0ZwcwiV3wBLHneQuwiolfkUcNWWWO94=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tWfwiQO6;
	spf=pass (imf22.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.152 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786754317;
	b=YzHE6SMrLBEpLoyQhOzdZHrVqq1axyFBgOaKCokxmtWes3pxVqiqAk3zLyBKOruJEueKN0
	MKJGg02f9y4jVZuLdLxBXmSVElHBMFCOEU1tVRlq4Z+sZu6Gi7GooNzDWrs/8LaXdtdoUq
	6S60usgsYypvO1E3sYmcw3cwVdmwioQ=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=sM7q98Dlk5XbykTDQiACBDmjl2R/gtu/mzNUYNNIq/w=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786754315; v=1; x=1787359115;
 b=tWfwiQO67aZItcVWXNy4V8/jTq4Mzo8GJnnmRKvlHYY3uLIyOrlbPkSmQDR3nW8jiCLEIkXw
 RQLWjQXBpiWmH62OgXfhGrFBwmYE1k2aZzAiWCQKW5BXOv5zDUI/ndqksUAQcp6SA5kmrwOAyrk
 uBKhbNPMRX4HgZXE+mRhTCAk=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (2a03:2880:10ff:5::)
	by smtp.migadu.com with ESMTPS id de1cbddc7a5009cc;
	Sat, 15 Aug 2026 00:38:35 +0000
X-Migadu-Flow: FLOW_OUT
Date: Fri, 14 Aug 2026 17:38:30 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Muchun Song <muchun.song@linux.dev>, David Finkel <davidf@vimeo.com>, Tejun Heo <tj@kernel.org>, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <linux-mm@kvack.org>, linux-kernel@vger.kernel.org, Tao Cui <cuitao@kylinos.cn>, 
	Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [PATCH v4 2/2] mm, memcg: fix memory.peak reset clobbering other
 fds' watermark
Message-ID: <an-073JtSRWeyhr8@linux.dev>
References: <20260814033005.2481920-1-ridong.chen@linux.dev>
 <20260814033005.2481920-3-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260814033005.2481920-3-ridong.chen@linux.dev>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AC456C0004
X-Stat-Signature: de8c5rqcgaeegbnzp534zgwe1e514m7c
X-Rspam-User: 
X-HE-Tag: 1786754316-804006
X-HE-Meta: U2FsdGVkX1+rq7XFaAckonkFY1PxzQqt0//Zq+naSLpLshu0APHvP+cmwdUyIWZGQQ5mEpvIQwBnP7mC0RIli4/KlHVGSaABqsBDCbI9URlvmcIolqzvdxTaTp7Qb5MOvnPaDFExFNPJMSHl6+phnPVpWibOCSOycrlCEdEZDFCFNXlNnBWa53bVU+jvaGZMBWsGlEq9I+H+VW+gTtTLEF+OE0WRwgYmGXfl53/D4IW/G/+kFBDTl6cJubFJasIv+6BVC1ZSrEHTpFYkQ4yaICTg43/n9YflTwgp46fQGOqw0TkrF5sfZNpSN4Oa2/NA7mBpSNghWWXT9qSXO4+3WUJE77EXlcbnUXpL/7O0gkx9t27WeYjyE6Ct1hWJF5iHbTobBPNIGMZ5LChT5PPaMa/WkJKNCNBcBaz3TB6KNptcU5+popc8iWs2RnZba5Yo2vodBU1ozRHMcnMVZmz+N0aeucFAKBANQUyqe6FpmzdawEQeccYTWkYRXHjx/F7E2yj8IL6pSxDkIMNCZWmTLrcQ0l+9YRTihfDFfk2k6Iv/19cDPTtsJrfHjec4aoGqJe7Iz//jk76WaKT9T83JDFbfCuHWrWfyUuUQvE83UBdBkMw/5fXMI7/JFgfUK9KRLxyEQKoVvgxRoxq4iYaAYfy0FACAGtXToYCjcuuXYRfhkVm3xXN/Ypi8VqspR3LDVL9XH/73WyFWgRJpPhNM6pPJvWebQ/JeAxXk+gjOe4ZauYK5oQqRl7LiVeyI3AMjkn/Wh6DhAbCAhlIKGgT0FfxE5MQU+PLqumwU0dgiJuy4ujVucA2oWct92asRnha7KcEDxjAtk3x/3UOFNrKwu2YbdbhzxAUUsP5XiBm2Fkt2UUq43qp926nFbIOGHZFQ/rImaWDMJy093KgWa0wuR53HWw5cBpc9Z2CQd5RBpKVd3Soya/VDI05Ot7Z9yIdXN3DBs26f1P7UqzCR/8n
 Ir/djLPY
 A2I4iHa7OJpE/T/JpVF2+qZ6+uASzRcaIm08FUvH35uvhClGfxRU0OD1qYQhs/JzLmu0yl8iXMLTlU7U7AQtFpcYW9m3f5/SawvOLz5iyvh7gFQfFcemdIrrd3uhqJvfKhc9wT7olF7SsJnV0cWrzz5by3Z62UlclRRHKwToEypVc0EWhF0CxqlP5AwLXol9hw6F/QA59M1bWhnlJWDXAywQMF4B2xW2nY5OLwzIlS8OLBjdqiXBrr40Qod/r3Szl9ZM8d+/XaW8jnlg/B2RMZd4PfiiUq73bZk4EiUpEUBR6+nnA0e5GI+HQt2slBFof+yy0/9ysvRswa09+quxkb73XWcak5eiUx/KBJdMfB8YYvpmMT/OakdlQkcAV/5aR7aJubcLn57XXifFzElaGSOhv8UmTZR41xyiNNdxmiF/n9bRG74EXypD/G/7ADvtCEuyCWsGT5KaXLgnmXl/45c22aA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 14, 2026 at 11:30:05AM +0800, Ridong Chen wrote:
> From: Ridong Chen <chenridong@xiaomi.com>
> 
> Writing to memory.peak resets the peak for that fd only. Each fd is a
> watcher and reads back max(its own value, the shared local_watermark).
> 
> peak_write() resets by lowering local_watermark to the current usage.
> To keep the other watchers' peaks it then walks the watcher list, but it
> stores the current usage into them instead of the old watermark. So once
> usage has dropped from a peak, a reset on one fd wrongly drags every
> other fd's peak down too, even fds that never reset.
> 
> Reproduced on 7.2.0-rc5-next under QEMU, two fds A and B on one cgroup:
> B sees the peak (410624 KB), usage drops, then A resets -- and B's peak
> collapses to 1060 KB although B never reset. With this patch B keeps
> reading 410624 KB.
> 
> Fix: save the old watermark before lowering it and use that to floor the
> other watchers, so a reset only affects the fd that issued it.
> 
> Fixes: c6f53ed8f213 ("mm, memcg: cg2 memory{.swap,}.peak write handlers")
> Closes: https://sashiko.dev/#/patchset/20260807090000.1532495-1-ridong.chen@linux.dev
> Assisted-by: Claude:claude-opus-4-8
> Acked-by: Tao Cui <cuitao@kylinos.cn>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

