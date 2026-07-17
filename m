Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF91EC44515
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 19:53:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 865C26B009D; Fri, 17 Jul 2026 15:53:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 816BD6B00A4; Fri, 17 Jul 2026 15:53:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 705796B00A6; Fri, 17 Jul 2026 15:53:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 49CC76B00A4
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 15:53:32 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 61584C023B
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 19:53:31 +0000 (UTC)
X-FDA: 84999318222.11.281970D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 99631100004
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 19:53:29 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=A5uBCCgH;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784318009;
	b=jhYBn/BlexkEbQlcvImqfqvLnjZdTTTAZCPSDNan/B0vZlRJ9nC+XV/pfLg/bzJubBhsmz
	ZjMVOdF/PR1VzxdClbuqcTlRE4Efdd+v1LcCYyzuNREH067OZfq557SiruZ8Z8nwZvbRsL
	HDOxgaNbNqIBNaIn+HSs1ByPsTtnk1c=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=A5uBCCgH;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784318009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FzGsMfjy3uVZeOrqXk8AeG/VbsEl/Z0QNXbp+sZJkN0=;
	b=GGJgUcz2av5fbQGB9wzUGUhUOiANqiy8BuJ32AJfMsu/cV70xBIBAHgdsioOWwBbAjfnQf
	JM0vca8r+Bp6ji/X2f4i0wO7ZyWO59U3OfnC9Dm+jTpzfR9y6rCWFBO3qQICe3LbDW8JK3
	wsdcGHP73wtjKJ04Cwgs2Kaij+ldZEA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B27BB413CA;
	Fri, 17 Jul 2026 19:53:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E2991F000E9;
	Fri, 17 Jul 2026 19:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784318008;
	bh=FzGsMfjy3uVZeOrqXk8AeG/VbsEl/Z0QNXbp+sZJkN0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=A5uBCCgHeNQvijKIEyvEb8DXl8uibvUySeNGJwOWcZY5IPzcru1rUI6ytmHrQo4g4
	 i9/WjiT96/xL8Z/CWhjFzhog12yFLy0JR2RKK44H77o3wf8fYQXOH/ePH6HeMR+VEP
	 hn0Rj1a8sWaXrvrwcOVXiEKznVfYgYrdFw8PcfnA=
Date: Fri, 17 Jul 2026 12:53:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ridong <ridong.chen@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Kairui Song <kasong@tencent.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, Barry
 Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, David
 Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, Lorenzo
 Stoakes <ljs@kernel.org>, Zhongkun He <hezhongkun.hzk@bytedance.com>,
 Muchun Song <muchun.song@linux.dev>, Davidlohr Bueso <dave@stgolabs.net>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [PATCH 0/3] mm/vmscan: fix swappiness=max and clean up per-node
 proactive reclaim
Message-Id: <20260717125327.cd3e3cc4e6cc28b0855e6502@linux-foundation.org>
In-Reply-To: <20260717113300.214717-1-ridong.chen@linux.dev>
References: <20260717113300.214717-1-ridong.chen@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 99631100004
X-Stat-Signature: y8nw7ohudzm14z8kdbuow9hjqjukxesq
X-HE-Tag: 1784318009-864558
X-HE-Meta: U2FsdGVkX1/i2OKwmxlZkikfJx30Z6IeF9FONI6wnAxtIXEq5veFGrSKrlU8fqQ3U1JFGIXeNaFHmo/i+Xu3LR2uHp30P0ct0qe8acvLpzim7TRaKTrmvpxwZMsYDyBO8mXDHbN3ceWJhzI74//RPAtP3gOlVgVo6GrkXtEKU/D1aLZAS3EiXXvnMPayQHEiwbYuyYaPzK4DDZBf9hba68maLvhgR+zJS+SviuLIbDMnwOy/0SrrXE20vOZ5+qhzQ0NfArCxIGYgZehZXfOkhGoqk1Gyz7JFeZ0kw+p1XLM8LAepQR4Un7qApOqqlXdKJsG7gA6L5iCbq3vgScYzMa3fttyLwryUFhL8AjPeqKgCc0jz+/alym2qSA0aVrjqxZQXAjhiO3Xfi8PMJ1UnS7q2Ysle8NHk8iSk8n84QlTRguk9IeZdPgDmzgTVDBbH3sAmTffAMlWfVAMyZte7tw00iwEt3l7BaW1I8ed23sGgy0VI4RQLZyYmVkD2k5LVn5xkFf05Njfst30kk23UEhrOo0q5rZfK//CmrO+9sAi/NvXnMW2y9cAL1Si+UP6hBbyKJK77ATwspWnPfH6d+Uuj0E2PNUkErOpf7zEN1O+HaHdTkZTpGWuEp0l5QhT3FDXppb90/OSaJPtANOb3YTZJs5SU69sx+nUmPnrY2Esy7/awxAuIREg+ByLPB4f9zZG07S+l8t36b6iO7/QKgVK+DxNnbuL2FDikKZCNqiHGa40kYa2PgqYlQ1jKu6NtdzeNzvta/94PNcdOX0DlOmRlwypgrD++9cGPAbewh0k61vIk+ycL9ZuQ2GGgatmyXixY0D/RV1xI/ndifUqLx8HAXYS631F1HiO96PHAuIYeyZ6MNOpjh5e/Gq+UTG9V1F6h0horY0tbjcVxyBmdwaeD8ldVTyIqE08j3Ca1v2kMcgsxVfHRrDOR+A/kmjSp4YnJENiZ7xeNWK5CPMa
 efSKeg/g
 bD0ac9PImhLvAhqwrs3aec7ksOhzfKYiG+/sXqqU+FLvnKR5PPjA/r7W+R+sdxoqZQ6xXyl1Cwep30delNEyoWj/WYgM443lbKhSNxtddjKruiF/bQNnQ9gkECEGGJDuaEj7EjAPXIDLjLWYAU5PYUbsblJopSiItAKi6M0jdxhcheCxt1NFivI4Px1ZsFXDTjiK2BsS2yZ6XI0QE1HDNA4NhIvoOxDu2uaTxDDEb9XRSN+pPVho5GGQBhQY/+Kp+K7k/ULkszjF3rpWXZSqdj2KFx4eLy4BWux6Sr2zJROybd336Lt1MWo53I9raNN0hrSJ4gPdAZIQuRVtrCChyDT6CqA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 17 Jul 2026 19:32:57 +0800 Ridong <ridong.chen@linux.dev> wrote:

> From: Ridong Chen <chenridong@xiaomi.com>
> 
> Two fixes and one cleanup.
> 
> Patch 1 fixes "swappiness=max": the anon-only test in get_scan_count()
> sat after the "cannot reclaim anon" check, so when no anon was
> reclaimable the request fell back to SCAN_FILE and evicted page cache
> instead.
> 
> Patch 2 fixes reclaim_store() collapsing every error into -EAGAIN, so
> callers can no longer tell an invalid argument from a busy interface;
> propagate the real error code, matching the memcg path.
> 
> Patch 3 drops the now-unused gfp_mask parameter from __node_reclaim().

Thanks.  Sashiko want to know whether MGLRU should also be fixed:
	https://sashiko.dev/#/patchset/20260717113300.214717-1-ridong.chen@linux.dev


