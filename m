Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFAC3C88E64
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 13:27:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC26C6B0096; Mon, 14 Sep 2026 09:27:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B99DF6B0099; Mon, 14 Sep 2026 09:27:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA3E96B009B; Mon, 14 Sep 2026 09:27:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 830E66B0096
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 09:27:10 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D33BC1A0007
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 13:27:09 +0000 (UTC)
X-FDA: 85212443778.27.60E3D74
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1312B2000B
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 13:27:07 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RM84QL+o;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789392428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NpRwt7i/NEaYzQzVZpXNFvHSKbVAP8S8q6HFwAhP4SE=;
	b=c8PpM3eL44coryXW54gccHXJgI5YpvEUojN3O2MR0FoBQ9BM3lOZJwE06V91whr6jeNlVI
	9+97hHbehcC3VA5xAR8DaMKkD4qjfdVegnokRw/WsNm+1Nf2UNIHt7I3+L//8pbjPuDpsm
	M8wdbQB7BtVcrXVUaKepTXizhNvw2Mw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RM84QL+o;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789392428;
	b=KnCYD+XqiMfAqlfjmS0KtyH6wWW+eR5oCCEhVwu/j9eckzyq1Pd38AhfAbN+gDNGvwUDS/
	6HjEaXA1s/hq29lp/pdWdG4fWN80BMJNu5oCM1xuUDrwQL6YVGm/ZbjQvb7YEwfM7v6MON
	1ZUYmfZHMb0gQk5cDV9ImrES1hbx8C8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6778E437B3;
	Mon, 14 Sep 2026 13:27:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4D871F00898;
	Mon, 14 Sep 2026 13:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789392427;
	bh=NpRwt7i/NEaYzQzVZpXNFvHSKbVAP8S8q6HFwAhP4SE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=RM84QL+ofuLT8RnZxRCOTmGDby/HILSF7gI3BLkavXarGVjZVGkZbFv2ZE/xklBzo
	 IYb6n0Yhq4hHj1tpt1f94HTkNr7MoBOPWNBkMKtHJ++0ZB+5IQT1rs1zWQJq1KxoxR
	 w6NzOEsTtrnTfGdk7Os6BO4v4ovEMPVwyyfQoTltJSIoVDYTxMsE+g02X3PQkW3BSp
	 5CVo2Pw2F50LICzm9KMOgLIbHIOVsdd1SnoxT31sj/CFkQpQYp49Ji0qy4zIZhO2zG
	 IYRbL5bWln/utqSRWCr8FWtAjbDMYZaXwce501f9+8Y38DpYHdk1T9EMCCizwdS3cG
	 09xVKy+80x49A==
Message-ID: <29dd1adf-4d5e-4ac2-9df3-9174d4ced02d@kernel.org>
Date: Mon, 14 Sep 2026 15:26:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 12/16] ceph: replace PagePrivate() with page_private()
To: Zi Yan <ziy@nvidia.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Ilya Dryomov <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>,
 Viacheslav Dubeyko <slava@dubeyko.com>, ceph-devel@vger.kernel.org
References: <20260913-remove-pg_private-v4-0-848550f7574e@nvidia.com>
 <20260913-remove-pg_private-v4-12-848550f7574e@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260913-remove-pg_private-v4-12-848550f7574e@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: xeupuaqmgozgazaaohiqft3gmh7fhk6o
X-Rspamd-Queue-Id: 1312B2000B
X-Rspamd-Server: rspam07
X-HE-Tag: 1789392427-545504
X-HE-Meta: U2FsdGVkX19TQjrThKrjHYZ4OX78k5/j7xhDNrlGAVascyHadbgFGly/ena606qrrrwtKMNx/KAKcinBmhhkYv9RbPH2umb2xJKNz+l6MoTJaTLL2ef8hTYEPBIUSQSO/aXLrNxmmKRAr/rZypqwggiNaKU/RTpHAaYjS/AYauBZdP6oBLzUhNkAIMglympGw94DSmtn0a7hwNDf3Zx4YbDYRmB0MwRQR2Z8G7ch/O2JIxBrKnI6YiyNmZuRzOXaXEoHAnSpNHrEdhDTcCvm0EdEvsXpw9Qz9L9O8T2w6FEQ/q94FGtTeg/DsyM9OsYtTgmo5e5Uq9a2mmDfMdgUSiWxyrZB/n2kTzaI/7Hx3PylMBGJP0G/uVnME7QQZjUZPYxFjMW9nLmWTnNw1iKK/Z4PgIfCEONeCJThaWzwsH56KjkxERZDcqhwh8g/CTnOW17rPI3kp/aWhDir+KBHDxdJCvvjHnIQS7lbuAoBd++YJrq04Sx4I0ALujEsJA1tIifFDOsSnkd5d0kfmjQFlhz6FTdHVcKtStdOyBpY6z/Z0cM13fhEs5/IfUKaI5uoSfn4/W2tOPeYOlokoOKbRkR4fDqQLBGQpsAbfNY0roiWp27lsuHze4iNum9Nn2bkG7by55gVlUrVF9JO3rHbfB84Ym2gLV+GwHaSH8TSg1Gkym8/bo/RzwxaCb8KY07DSc6dayxg4G5zdTuWJ4XPU/ro7QTem6v0dIh9H+nFxDA2V4lju5/CGWuWkZspjBqgbm6MbAZ0z+jL60wMChDK4FnqdPi2SCoHvRrbtw2zxOzak62zDtd9JSt2Iy5V0XY89qdWFhRfuZucNi0pWJApQQ4J4OEUHVPBEhJIirpKbK3Ni1CuFwK38jDWrUAZkuac6OyG31o0ppwMPW6RVEdmlrtI2zD5QXTmfvzYVWVX2hUy4YRZIyj/jZJr2iCDC+7+rEMlGIAK7OdhJ9n5lcy
 WtIA8urL
 G10zzfntEBDq8V03COLGHgGrdBIwjm91RjIwwO/0PDYrO7Fxjt9tE1TUitwlyJn5VVa0G0CgQXrF1cWF3b1VChLuumsBCUwnA5TRlZJeAC1aOrky9qgyidvx9Nvj1iHxCdbYF1iHUDEHxC2iqe2SJGl0cHs9bE40jgK3b38JooTR0zthQWQVStfSsFZobkRGcb66A5xlbt4coyP+/sE6bk7N5MrUr0ZZ0u3NsB6pyB3fbSY9Y6W69WCfY5roesADQWxP6hn24sUHTKUYHaXGwKgA5vXWicZUs6FzfVyZtyRuMiYitti8DmPPmCJwhO2NZc7Jg5Cz++oshD+2Zyl3YUhBgEnHgCGcL+N0fza/6l47Cd/o8jVGf0iX1N5fUdkd2ZRQNSkXUGVIycbJCn5uqriH8JbAXZDVGwzDSss0iVSIsP00D1sNCQ0etl0dUHVbBpFGEr8QZX5a2FC8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/14/26 04:24, Zi Yan wrote:
> PagePrivate() is going to be removed along with PG_private and its
> implementation is the same as page_private().
> 
> Assisted-by: LLM
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> To: Ilya Dryomov <idryomov@gmail.com>
> To: Alex Markuze <amarkuze@redhat.com>
> To: Viacheslav Dubeyko <slava@dubeyko.com>
> Cc: ceph-devel@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

