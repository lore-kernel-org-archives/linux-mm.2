Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70CDBCC6B30
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 23:59:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F25B6B0099; Wed, 14 Oct 2026 19:59:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CAB06B009B; Wed, 14 Oct 2026 19:59:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E36A6B009D; Wed, 14 Oct 2026 19:59:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 096766B0099
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 19:59:50 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7A147A07F2
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 23:59:49 +0000 (UTC)
X-FDA: 85322902098.25.6F949E1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id CA490140007
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 23:59:47 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bipez7Ht;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792022387;
	b=sCC0tpgK7exfwqo4aITkQBJY50bq0KnytphSgE0LiaTAXet646dJC6hZBrFElyc2PfbaOB
	FDbTkhH3zISSiTqy7vtroKlZ7ak5oRs7sHX58/3JI3MPUle7D7UdkWyVQqKW+JTYlS5i9p
	B9Exn2pD4XZ5G3js92QvEB/vgshq2xw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bipez7Ht;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792022387;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u79nAdAkK0/gGpKFfO0nUzFOj1lq5Wr2kWciwdFQTiE=;
	b=ra+ZsJH3gooSzRCJbIfAMfXkpqB8qEwV87ijkdo0qhDx26MXnvI4+P7E80sBcC/FQq+v9G
	vXpGQf7XfEwk2u8zJjq9tXE+xoXGHhUor5erQi23O/Saqw8r/sdCLmkn/AMbPyn9s2FuhH
	Omkf+lD/q2Ud5hYm4uQSMeiBaUOacNg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5119C6020C;
	Wed, 14 Oct 2026 23:59:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB4CC1F000C4;
	Wed, 14 Oct 2026 23:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792022387;
	bh=u79nAdAkK0/gGpKFfO0nUzFOj1lq5Wr2kWciwdFQTiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bipez7Ht4bxO5601jdtc2fcZcO6bY2C/SWuclR1gQz3fXPfL/ED0fEvKsKH8QHi8V
	 EfWHR5+sqRGDCCQ0nkJAZ/sg1SU2cLrq1d2ZDQpzXx5XA4wbzxCLmos1DAB7j0Bek/
	 tAI/o+f+b/gMV5R1T/nOa9rzq9mkY+46RGbWJl2cYJY5RESbz70p4/HEbvmOcSzpCS
	 nuy8401E1lYan8/hj3lnx3W1F/cNVOp8aasyjdP2EgXEqjdzKpeEmrDPpVmARYkVeg
	 +lJDIynx3l2P7rmIqNgXObASjaFts72hWCoeDp3Rfbmn4Si/1aTIVkilTy8yIfow5m
	 i/Hi/UN85q4SQ==
From: SJ Park <sj@kernel.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: SJ Park <sj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm: memcontrol: remove page_memcg_check()
Date: Wed, 14 Oct 2026 16:59:39 -0700
Message-ID: <20261014235939.3830-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261014-memcg-unused-page-helpers-v1-2-240b37c53831@columbia.edu>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: f9nnpggm5mpr7etumy79eq58pwtere7q
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CA490140007
X-HE-Tag: 1792022387-878033
X-HE-Meta: U2FsdGVkX195CuYNcTzxo1AUhQZ1qtYRzL0q1rNvHcbwcfxGTmfnThQzoHRakAzxk0uCYFlma6kwpIhVp7E99S1XLkX7xr66/SZjNyViahU+yQQyL9LYxqkCyz/bup2qtskaJQeb6M2lXqD8dIiRE4u/rG2zt7NG6LyKT5jDNhs+13ex8HAderJFNrMeVmHj3PAH8UfADA1ELhdByhJQfIxjeonuGVI40QWcnlxzcSh66xy/twcu4n1vUmHcav0LlCSXme79X3Iaqje/4Hv7hcc10YF6bbi3XLg+TpY2m2PjicEWkmFBar97JPyx+dCHRltWrINGOLJczAflBqPkJeifavR1EyUleby8qUBChc9BBnKx/4nkbz/IIwqmVpwTSn55IOxbAUS6SkvbwlaWIRvVMG/96HS2OApDQR9SlP+aYRQjUzNWurJsO82va7ViyYRhJLcIRLnbtH46o1y20t+pgMppqQV6nXkqv5zoFxCI3VbUsRNibWOpC2HiynDmJvfOwuDiDI/8nLEZMXUe+Xlk94Ix8g/lYazBBJMFgMxeJFdQ0Tz+HcqTJWtS27/u2C6ygNNKdkrnWLt7KR92+kJxFD/mlyXUuL0mqk6VWZlkmIbq6Am2OGCVpN1Bvzlg+s1jtZED15bIpArWBX0wo6hLQiL1JIXFVKOHVCc+5pNDO9PLUwSg0iD4R6uif4yxUfMiSOAL1Lyy48XNHyeuYwgGLDfQ/8vn9u5CDkrGX+mwIeuzijgxYgtPSk/O93DwRJeHzkPOX3HkzI3LspVhMXZa8qEds31RIUPXIl3lp6TQHdDjklNAOiCAPxVrsls5Jg7hjPY/YViS3cFV/3O2+AthcGfee1kgw+CFsBhLD8GHg1OldFDuczCe7FD7noKTUXZCKlkI501Nf9crhm/C9Q5HcRP0NtjzGEVMSFjOSInAMgMNWr+VcSG9Olz6jAvOZln0iq/DnE0n7MY854P
 xl+t94Si
 8mCGnXcBvOsNJpQ6b7r+amAFvsaGeONbYcsKQO5u7tqM2L46iU+QyPh84EATg+gXBPbAX974JUMQJKyKztzTFdrsQIZozeQBi295+JiQknTia+FQ61OPrMH1VbswL4RueTCLitwUq+Q8VrrwdS6ZdaFUUHNN+TkHdsiE1pG/9QFinwAmStfYXSRUs+yqEBKwYz62eLEhkm9r5VeX6TqxBPCQ6fk0si5JlqTow24HBTuB9HT5pkWexik6N1VLTalKSMPHlgDWNUWL4lF78YDOvavoC5gJQwWQORUMsKgqnxtCb7Xg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 14 Oct 2026 13:08:21 -0400 Tal Zussman <tz2294@columbia.edu> wrote:

> The last caller was removed in commit 90f095b816e2 ("mm/page_owner: use
> memcg_data snapshot to avoid TOCTOU in print_page_owner_memcg()").
> Remove it.

Makes sense to me.

> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

