Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0D5DC5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 04:33:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 649296B0900; Mon, 17 Aug 2026 00:33:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F72A6B0901; Mon, 17 Aug 2026 00:33:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C1526B0902; Mon, 17 Aug 2026 00:33:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 246E46B0900
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 00:33:54 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 92F6A160642
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 04:33:53 +0000 (UTC)
X-FDA: 85109493546.07.253028F
Received: from mta1.migadu.com (out-210.mta1.migadu.com [95.215.58.210])
	by imf02.hostedemail.com (Postfix) with ESMTP id 16AEB80003
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 04:33:49 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JBM1YnnA;
	spf=pass (imf02.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.210 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786941231;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OVHf+C9hypheHTUg0T4L6jqA/swZQ/qniFqO2dkTgRg=;
	b=4ZcnaN9PA88wW9UpkEHGaz2lmiSAA36BGXdvWkQiOSYyMd3fQ91MWzCE3m1f7jn47rCDz0
	kCmVTNWkg9+zGSbLrkBqQ4BFmjqRgA5NmLhEFfVKfrWGUaIcAM+qN/A/Zd2LOnVWWI6FDv
	vNedX0C9x9md5hpysZDkhs2kHhJLG44=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786941231;
	b=KCY2DaQKeDm5LoBjl+tIzPR74483mtDo++IWVUNPqHmP8NmOnK50PTmfuNpwoMpb23qgim
	oDyXLZMLORenGosdo4Pega4+sBPkm9LHNttlJ9gaFOudfLsw0LVlA4EkxXBmrB+fFQw4th
	nGhcDI1XMvdwagiU++ykkhaoXa8F3Eg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JBM1YnnA;
	spf=pass (imf02.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.210 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=OVHf+C9hypheHTUg0T4L6jqA/swZQ/qniFqO2dkTgRg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786941228; v=1; x=1787546028;
 b=JBM1YnnAfAjf03oekWZUucH7Rxj+1/vlipH+ruqz69v5YZ93YzWxDhmIT2pbrhXx9AYS80Nx
 fuZhY1OQwwknJJhGi8YHYQRNs0RDQPe0N/v6A0j+iZAeG/Km+mY8c8c1SslEqCjUxGG03LQ71+F
 nKvFe0IpsDpmtdrC9+okKZ4o=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (2602:fce1:44f:115e::)
	by smtp.migadu.com with ESMTPS id 5407dfe574b6016e;
	Mon, 17 Aug 2026 04:33:48 +0000
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: nico.pache@linux.dev
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH v4 1/7] mm/khugepaged: refactor per-scan state clearing into collapse_control_init_scan()
Date: Mon, 17 Aug 2026 12:33:36 +0800
Message-Id: <20260817043336.81695-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260811-khugepaged_pte_refactor-v4-1-ddac39d61c4a@linux.dev>
References: <20260811-khugepaged_pte_refactor-v4-1-ddac39d61c4a@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 1hag9sxosqybep17aaqhexfindqn76q1
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 16AEB80003
X-HE-Tag: 1786941229-908911
X-HE-Meta: U2FsdGVkX19z6zgpkZQbwyuDNxXLNHLaBr2f1tSy/7muyK8UMI+YAVe8U/bAYv7VZ/lAqIQFh6ZiDji8tfl41rZ/z0uh6bUL36vEL/vtV3ofQ/OwT1ZrlIffyIFnTuX/O0dUpfw1ltW57XQPCxNZetUCcXQ/T5/xd/8kxORxzmYBfe6p74OK6NovvUfoph2NZ57znPiIfWdOd371n5pLFj8vCQwrHEVFB1QuV9OoNj/37oDaoFQzLbsTrFvG/ve9WHin+QKZ2LpN1PPHCTgTJ5WUJyzOV41tVQgH54ehSYeqIqMhhWoo5rB9oiT88FteBsDtoRl6OeZ0m2/Fuwh8WjtGgCTGWVvgKP/osczAeRVhaNZsVecJaQWBoRms8Dv6a2Chv30I158QAwU7koonce/GA/f7dVxtkJt+Qcx7aQamBqbnMxR7H1Ewf/qxaTAOCk0/dkB9xK1Txy9H2bKk2LqwIBcmuMllXYWW8tJ4Bu71xhBHg/uG8ActwdZFpIovCI1mf4YOZ5M8ddVmGQp0244EiFACg8h/uyLKMu6mVwL4KXnk2/xj46iowVCV1t1sPU0frER6VV+nJJ9q4U1cc3XItHlylfUg4CAifZZnHPRWSVHOEgIXoVwEyKprJqk6bdoglRjXuy0dH6tTHMniV+18E9+LUqhjnlPcw3EB/FLwnRfLtU+WWG/hEKQpM9ziXm9+KbL73JGNxqYc1rM4DoRhDa3ByRQpFXXXDm498v3/3X081HG5reIehkSUBTwvWHI5T9VFCarOjApMxuN3Ny3lAUsTjiJVSG4touPG3Vd/hXQHwcKjADBzF98e50QJSYKUCjpYt7CyLX8lnGAud0EZIfAf96DfeCsCJrOQWdB1nrskMNhd9VuiP4dbB6PzBCyzDyaZqo3DWrrjQaLk8xpzZz5jv9/tSy/XA7b1Hs19JZljIH7Veg7vUKrOWW6GMGnQ6mk7VlABdb02O/o
 km0uJTUb
 zi7tPdndQuq5aVFmLaToFLHksfFRr38eyj/V16mYWcqHHBwhC815MyTgM7JvkiGZMtYDryFFxY07xqr9wSrUjtHvp1FWRocqLHwokNIDm/eWSg1dvuB6/VrA8zBeLeT3z/3fX/VIX5e48yY7/SaQV/+EFen2wxwToF8pS8VmvnkrmJDFJsp12aRiHF/v0OAHryw3Ago2tAm63ZU9+FN1vUtppmqk3wkjWacJtvps2vYHjrX0iQFK1b5pd23bdSqNfQHUPNUV4Wm08yB2fede6hbwt+9x4bJ7kpxI8QnAZ/lHnR0zERQMCW2Kjo/phrr+LxRrS8VntnoKOaekUvKzRBLW6InD+xGBIKRUKv3+385pqDnFXkWUvDRa4gA/35jVSp+iTzXfQiWLyWueRbtqvJtEZPQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, Aug 11, 2026 at 06:48:33AM -0600, Nico Pache (Red Hat) wrote:
>Extract the repeated clearing of node_load, alloc_nmask, and
>mthp_present_ptes into a helper to reduce duplication in
>collapse_scan_pmd() and collapse_scan_file(). Althought file scans do not
>current use the bitmap, they will in the future, and clearing it now is
>harmless.
>
>Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>Acked-by: Usama Arif <usama.arif@linux.dev>
>Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>Reviewed-by: Zi Yan <ziy@nvidia.com>
>Signed-off-by: Nico Pache (Red Hat) <nico.pache@linux.dev>
>---

Nice cleanup!

Reviewed-by: Lance Yang <lance.yang@linux.dev>

