Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF036F34C45
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 03:16:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45B4A6B00A5; Thu, 23 Apr 2026 23:16:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40D406B00A7; Thu, 23 Apr 2026 23:16:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34A4C6B00A8; Thu, 23 Apr 2026 23:16:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 259D46B00A5
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 23:16:41 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A93A0140360
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 03:16:40 +0000 (UTC)
X-FDA: 84691986960.08.D1B84A4
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6C33818000C
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 03:16:38 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=J6+VzU43;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777000598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v1NQXyoIZKwnFAlS0+sIC5LZWfMSPAnT8N08Bst9LIk=;
	b=O8Pb+nYvSGaGmh5dksWDEjsyioUrc8Sa1Nv8Hac+xG+HSP5roSXns84hnHP4m5BP8MPRmQ
	D8DH//irxW/bwkzX8Ojh7lwOlMPFx2nqqpN5IYXHJe3F/J5zyFSwWlzu1bGXzdxFS4VYXS
	gbAIuHaULp6sTk0n+boS3ObPII7wqKQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=J6+VzU43;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777000598; a=rsa-sha256;
	cv=none;
	b=dgAng3+gR7Rwf+QrsrWAsPSeS0kxLnIw00XwP0Z/SsgcNyVfQwYxxLXlubgD0FE091JLgv
	uuX+UuY2VCOhnGvXqN6PtHYs7OeVE+LYDsjqXDYrhb+SFcyIx2+/x4NnWoMBKgFwcAWMPa
	R/tEie8kf0x1YRGLq0Os9ZmpAt7bNSE=
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777000596;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v1NQXyoIZKwnFAlS0+sIC5LZWfMSPAnT8N08Bst9LIk=;
	b=J6+VzU431YtV6KyK6MjnabKRLohMOIaMxZHVTh1qt+xXqQCxaqdPmMxOhWOxW/3nuV0mFn
	bUW021+IIBE/5JPiTmpYjbZfrMMG42x+ddheBI5gFygQyX6LpMgH/mytLseIJpAJagjx6H
	tkRtW848Kx9IYSWeGwqBfwP6W4fTjw4=
Date: Fri, 24 Apr 2026 03:16:33 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Shakeel Butt" <shakeel.butt@linux.dev>
Message-ID: <8cd382082ba7f5b9a23e0e6cc99e0fd7b9b663cb@linux.dev>
TLS-Required: No
Subject: Re: [PATCH v2] mm/vmscan: add balance_pgdat begin/end tracepoints
To: "Bunyod Suvonov" <b.suvonov@sjtu.edu.cn>, akpm@linux-foundation.org,
 hannes@cmpxchg.org, rostedt@goodmis.org, mhiramat@kernel.org
Cc: david@kernel.org, mhocko@kernel.org, zhengqi.arch@bytedance.com,
 ljs@kernel.org, mathieu.desnoyers@efficios.com, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, linux-kernel@vger.kernel.org, "Bunyod
 Suvonov" <b.suvonov@sjtu.edu.cn>
In-Reply-To: <20260424031418.174597-1-b.suvonov@sjtu.edu.cn>
References: <20260423103753.546582-1-b.suvonov@sjtu.edu.cn>
 <20260424031418.174597-1-b.suvonov@sjtu.edu.cn>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6C33818000C
X-Stat-Signature: spxp5b6wkmfntsxrs1xrs4i7u9fmtqiw
X-Rspam-User: 
X-HE-Tag: 1777000598-89276
X-HE-Meta: U2FsdGVkX18/GAr354qxSdUfHtp3xzviaVRtCQruWgyTWEwBwT1kYjIJsRKfpax4oaji2VlLYZLutA8k4RZR0LWzJhOcgmsuDMW6itrIEDe8tuew04X5Lwr3lVPIE9YosiTipcOReTibRPgX/z6Ww54dWJdsoO3Q5gPDA/Iz9DVhpbjXS2eINOzVAW6VEhoM1/rbpTi5l9Tmq6LTALMl1cpRNmjGSWFYENzlQ7y2EeZgQTjHbpTjG/cY2ehXgb4XM9sn5qQzlBMb1MZqqCBpQuS8eZb6cw3KRaDsZ+zJaonue6yTyY3hEEGtlh5zNAYVhQnYxIxTwxEO3ANeLBOKCa5pPf9eTOMR/GIB5fN4BZLsrhIQdCunLdsL1nEZGfimV4YWOkRKY+GVTGrqAFNMK9hteFTDnoKtiEpU3jlyauo9sXnvIS+B0kkNbtI8h8snDhxY4SEsbqfi8JyEi2+b1hdoL6AMxClgzTtpcC1Mw8viH86wkjFAalimifATlHUW+IfFlBR/H7kLZq9/BySQDeBcPhuPEt7BfwBrtV7lx4uSeF/qcG7XyhgJUsz0eietkGWxZqNNqhPiSUDAyPwNH/yqaKvCPe0QQLSPVNzizQ7dCvlgRs8loScvWzXi6WNYDDiBr8kZZFj1mfi5JsMqZqaOqvOwO8TqVfe8A3PK9w68WcIqR61A2uYFy6kvQ2g6aecFGclCb94tLJJlJtMCnUt2ww1qkdCQZxAZTJW53RWbjJ1cVAGMnh6EH5DOYIzBdVeyVmYAW+NnQh9aSS6GOhcEBxucN3WMlunRx+NsCdgID7ZQlWVt8irutCuza6zbQRg8aW/NlayXzhhsruNSf5tWIw2w0blPaTfweST8zedqpPsyLexBZbWtHgo9YvRNvyNbikbM6MoRKk7+hnxbKFjZyVCx/ZseANVOYVGf8e+Jg6ndnT697VZXVN3CFR96dTHeamnuo6fJNfFTIis
 PLPsDXyS
 rLjPDNltPbIOupDHmTwW6Yga02ffm9AbGK3v0jZDca31FaOw0rV5DTBtrsE7XKXHsBzbInETZjTv2Mv3cZBE/w7d1z4xHCm3Kh9q1CukNIcMzhhEauWN74ecpMFosNYQ0Xy5VOuHL+98Yif1EVGCDL71uQnvsXzqy6ZN1uxW337mtlJ9zlyeKNgHAOX2zUgQsIkG1GckOhvjk0eU/48UYoYPaNGIt+yxgdymMklxPNHxc3UNlCeFvVLHVvsED77FhPjaX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

April 23, 2026 at 8:14 PM, "Bunyod Suvonov" <b.suvonov@sjtu.edu.cn mailto=
:b.suvonov@sjtu.edu.cn?to=3D%22Bunyod%20Suvonov%22%20%3Cb.suvonov%40sjtu.=
edu.cn%3E > wrote:


>=20
>=20Vmscan has six main reclaim entry points: try_to_free_pages() for
> direct reclaim, try_to_free_mem_cgroup_pages() for memcg reclaim,
> mem_cgroup_shrink_node() for memcg soft limit reclaim, node_reclaim()
> for node reclaim, shrink_all_memory() for hibernation reclaim, and
> balance_pgdat() for kswapd reclaim.
>=20
>=20All of them, except for shrink_all_memory() and balance_pgdat(), alre=
ady
> have begin/end tracepoints. This makes it harder to trace which reclaim
> path is responsible for memory reclaim activity, because kswapd reclaim
> cannot be identified as cleanly as other reclaim entry points, even
> though it is the main background reclaim path under memory pressure.
> There may be no need to trace shrink_all_memory() as it is primarily
> used during hibernation. So this patch adds the missing tracepoint pair
> for balance_pgdat().
>=20
>=20The begin tracepoint records the node id, requested reclaim order, an=
d
> the requested classzone bound (highest_zoneidx). The end tracepoint
> records the node id, the reclaim order that balance_pgdat() finished
> with, the requested classzone bound, and nr_reclaimed. Together, they
> show the requested reclaim order and classzone bound, whether reclaim
> fell back to a lower order, and how much reclaim work was done.
>=20
>=20The end tracepoint also records highest_zoneidx even though it does n=
ot
> change within a balance_pgdat() invocation. This keeps the end event
> self-contained, so users can analyze reclaim results directly from end
> events without depending on begin/end correlation, which is less
> convenient when tracing is filtered or records are dropped. It also
> makes it straightforward to relate nr_reclaimed and the final reclaim
> order to the requested classzone bound.
>=20
>=20Signed-off-by: Bunyod Suvonov <b.suvonov@sjtu.edu.cn>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

