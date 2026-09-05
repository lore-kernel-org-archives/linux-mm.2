Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73177C79F82
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 00:32:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AEF46B0088; Fri,  4 Sep 2026 20:32:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85F266B008A; Fri,  4 Sep 2026 20:32:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7754E6B008C; Fri,  4 Sep 2026 20:32:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5726E6B0088
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 20:32:50 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C442E1A0247
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 00:32:49 +0000 (UTC)
X-FDA: 85177833258.13.112EF98
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 398A0120004
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 00:32:48 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kUmtwxlj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788568368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1ZGSo/wx6Gpxvgtz7JFDR5HrEIDwWaXUEU46GxXEPYk=;
	b=dTzFVAME1Bnaps8N0QekbkZpyxe0I3CxiH+8niCYmn7PE9nX40IuA/uHkvVIrlQSY0G+NN
	fWl8XvcL7wc/bPY/OHLI6ws6mjMgqa0Nu89ED7FC/AiTGDf00JpQIGpkN19csNfriij1Fx
	JifMR74k/l5vWkyD+vQEQuG27xR8Feg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788568368;
	b=di0kv+MqoDB4VtAMyF7oTnsu+6jHYoCVcGucvSIxTyeIQHmPiTyZuk2+XKAE4aybhymwsz
	tX8aPM1zxCyn7QmfRGzCoNWcKJGoIWhCebH0rmHe8543UnO8LBnhn718xEd3M82TSx+0vN
	nFpCwLPBo/4uLrbT9dbIB/AhY6Z3Bwo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kUmtwxlj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AA86A40909;
	Sat,  5 Sep 2026 00:32:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FC931F00A3D;
	Sat,  5 Sep 2026 00:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788568366;
	bh=1ZGSo/wx6Gpxvgtz7JFDR5HrEIDwWaXUEU46GxXEPYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kUmtwxljSOu0DtqF3BOYN9BT2IjZ4jJJ+JTLIdMIQMrWWxAoIsxdUZMasEqJVxLLQ
	 mGrQLTrTouiXaN7SBI1hVjNLyHMtJySAI4KmRjBPGXH9PxdgoWcG3rA77atCMa1q4u
	 aW2phhFygK/YqRjEBWxTqrQBHuZuTV+EIn6PnOkvqxo22/aESSlTLw1XJwRyUAcJI3
	 mDAVIXuVyAlSn7sKLuvRie55QZAdRSudmW8BYPD4/wFua5+piTgdYCGpZovg0XRpDI
	 cTLkxKRN6OIWajWIu930OJg71DGZVBLnYdtXnITZzCe8+LLbNfgzlU7E/9Fy/pILtS
	 WMfoahHmzMO2g==
From: SJ Park <sj@kernel.org>
To: Ye Liu <ye.liu@linux.dev>
Cc: SJ Park <sj@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ye Liu <liuye@kylinos.cn>,
	David Rientjes <rientjes@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] mm/oom_kill: convert process/thread iterators to for_each_*_rcu
Date: Fri,  4 Sep 2026 17:32:38 -0700
Message-ID: <20260905003239.68043-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260904083001.553587-3-ye.liu@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 398A0120004
X-Stat-Signature: ph6zi1w118xconbtf7pnqmnwrbao44ph
X-Rspam-User: 
X-HE-Tag: 1788568368-459756
X-HE-Meta: U2FsdGVkX19LDxmZ+RXLVUwHFHlEdDp1L0PmwB2aGn7rfVH8oKRobeC6SQ13f4TeVhaH9ECjQUA+ag4lK/AXmtzyx/Pe4bj94Ty7JAaUvFE546vbnYS02p/IsOURB30BD/LUZcphFWgK/hGc+sadWJPL6u9yU8+jVrJSptAdwKMKrLjQF3gNOSUGRgjHOBD3J4nT4OQyxX0a3Zy7Wr7ZKBG9/huQEXctHJNb+PGrTsl7AR7Gln6WEjpRyEMH8O59bOPTDObsDkuH5FOOS1ulJZhjxHvlJ/46x5gkEYe4PztZf6iVEgX4Tpdn9ub4GeYd8taDojL49Hy1SDVSwO3Xg3GOc0rep9cuw2T7TMV6e3vZX7Zx/Mm5C/qSAEYt17gxOWdxH8tx+OrfpEY3iaZSR24pyAejqh6Sg6f1+PXfKMma+GG08tYBFq7A7UWzgo3eaTix/dIEENIlSwK6jcFbjlGLk/Vsw/Z/DapXVV3fXXCK3/+qqV9I1n6RrbMZ1E/adZ18lPtPWJoPxN7TzxVRroHI4ZkGHWM36FYiVBqTV7tou7VN1r1joUgFKCzEG+A9qzoAi97G5wl9pJEenPXdslWSOg98DUCvFCvPTnD+BUzo3hys3QncSw5LAJWC/U6CYm2nRb7tYd8BirLPaSH3nThZqi3h7cnI9sO4pL34p/UIsHEHv7pFjaMgRsz5LA/6o/CI5uUMuc1G65jEWG9To0TSgFAuH62BMW1SUKZRgVTdkWvIJetw2n6bG7jDv8/VhJ0QXVLE5DS6wyqyWJQ46Zas4NIUgeuAInbFjmEMVJgJdRexNnPX7lhtus4ZeMNQiYHj4/1UWwVMBmgOTsBNmRr81mnqC59X/UFWAF963MXOlHzotzOBHF74qogwGYhqb4me5D2xHHIvSmy8kCkBCTRGqTQJFU1UvWUf/0hW+RuO9POyyzOPQA43LnhXTxLKin9YldVWppfISblbHvO
 HEDiwLn7
 ySC4rKpvXHc6XPcaMNxwY1wKM40CFpX8iK+5qMrI8bamUoVrdXTLwWXWlERNNfzy+2m7rkpDsB5cu0fvAkDwpHxxkEkqeeyMxr/EvBFtC5tzUMt3LMS+NyGj8BdFZnVidA4K5KAO/X1u+ArPqR65+H3oLT2WlQEhddqFrLNyZjCMCsnSP3dlNN40xvBy47bbS1pQ4ZB0J+3C77xTxktrjJVscjX/i3wDSVUpDbVfepFP+cdBheU4rob74+nu4LRncxGFDASC/nIThZLTyuCIfB/1aGg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  4 Sep 2026 16:29:54 +0800 Ye Liu <ye.liu@linux.dev> wrote:

> From: Ye Liu <liuye@kylinos.cn>
> 
> Replace the manual rcu_read_lock()/rcu_read_unlock() pairs wrapping
> for_each_process()/for_each_thread() loops with for_each_process_rcu()
> and for_each_thread_rcu(), so that the RCU read-side critical section
> is scoped to the loop body.

Looks clean to me :)

> 
> No functional change.
> 
> Signed-off-by: Ye Liu <liuye@kylinos.cn>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

