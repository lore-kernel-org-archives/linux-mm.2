Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78CE7F43858
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 16:23:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CE2E6B0005; Wed, 15 Apr 2026 12:23:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97F3E6B0088; Wed, 15 Apr 2026 12:23:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 894C56B0089; Wed, 15 Apr 2026 12:23:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 76C536B0005
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 12:23:43 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0E5D81B80E3
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 16:23:43 +0000 (UTC)
X-FDA: 84661311126.30.8450F7C
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2923D14000E
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 16:23:38 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=I6NToXSy;
	spf=pass (imf26.hostedemail.com: domain of create0818@163.com designates 117.135.210.4 as permitted sender) smtp.mailfrom=create0818@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776270221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F8DGeYEPDbd6uTkQWGQlOL5JIA2NkbZr/DhyV0YRVO0=;
	b=rdkeIYtwjqBmffXpqCpb3UkMPZ5pRl+tWiA3abEn+rfdfJ/j/B9WtXUoZ/dX0E1j7A1t9y
	uy0E8AyDjeBTg2d0xTC+D5TapH7OLX9zFZX8/RozaJdEmgskbfNrP7C2ekBVVDEls5KxJw
	LpaWwIS9tj0JIj0WAM2lRl2Q7laoAAA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=I6NToXSy;
	spf=pass (imf26.hostedemail.com: domain of create0818@163.com designates 117.135.210.4 as permitted sender) smtp.mailfrom=create0818@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776270221; a=rsa-sha256;
	cv=none;
	b=Ez88u/2ABaBaH1dl03XHn+HtDhsGi6bDabunGEYXxMwBHWTOBNR9H6ORaRpY2sJfnzFRm3
	zm1t8NU1min5WNVTJPOzIUnnxblK4ayvhdb43MxnL4aGV/rlkWDp2jzCEBIXBg2uHWKAm1
	I/vsNoLogdOCF7vm29hmOWpyPNeZBOs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:Content-Type:
	MIME-Version; bh=F8DGeYEPDbd6uTkQWGQlOL5JIA2NkbZr/DhyV0YRVO0=;
	b=I6NToXSyUkbGvDwVEBuWToyVpgMro9rCAORifBvQTlucqupmisnv6lbW0e1ryl
	Lvk30r+FMavfCG9luAG0fMam2Kcj8LE/LY/HDEqnq6YcjMWSByGiwaApB4xAl1wZ
	Oeq4MLo90NMcFZZEcCV+n1oQCtXmFlO6krFN6jM6zXITU=
Received: from 229.199.16.172.in-addr.arpa (unknown [])
	by gzga-smtp-mtada-g0-0 (Coremail) with SMTP id _____wB3WoNeu99pgeDOEw--.35537S2;
	Thu, 16 Apr 2026 00:23:01 +0800 (CST)
From: create0818@163.com
To: Vlastimil Babka (SUSE) <vbabka@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Liam R. Howlett <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, cgroups@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 syzbot+1a3353a77896e73a8f53@syzkaller.appspotmail.com
Subject:
 Re: [PATCH] mm/memcontrol: restore irq wrapper for lruvec_stat_mod_folio()
Date: Thu, 16 Apr 2026 00:22:53 +0800
Message-ID: <177627017370.51713.13753959033860067852@163.com>
In-Reply-To: <ef2d8f65-b3b4-4a9c-a77f-78ad1cadff28@kernel.org>
References: <20260413064833.964-1-create0818@163.com>
 <ad0clnEYxf1H4_S1@linux.dev>
 <ef2d8f65-b3b4-4a9c-a77f-78ad1cadff28@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-CM-TRANSID:_____wB3WoNeu99pgeDOEw--.35537S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7Gr1rtr4rZr1UuFW8tFyrJFb_yoWDCFcEvF
	y0krW5Ww4xAr42qa10yF1qyr9aq3WfCr1DAa4jgw4Sv3s2qFn0gaykur12qFn3Ka18tFnx
	Gr47uw17K3yY9jkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUUgo2UUUUUU==
X-Originating-IP: [39.156.194.234]
X-CM-SenderInfo: pfuht3jhqyimi6rwjhhfrp/xtbC6AVak2nfu2XCbAAA3i
X-Stat-Signature: freqeakrur8e1rxrzygoqxqk7n9m39mi
X-Rspamd-Queue-Id: 2923D14000E
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776270218-889359
X-HE-Meta: U2FsdGVkX1/J/LtidWTp+DScuP0eI+8nUvwiBB8E7Fjf83xv4vFineY4T1qCPk6marOrOU0UQ/ia5eXaGQpphlH/J1s42fSSaNqUdzA78dP15gs/Hd1V1y1FZ6FFZK41L9odhFoGifhuh3FQvzfD5q1L/FOcexXzbHV8i22tKiFekUDYdnz+Fy6FcWoukQX2tZuuIhzK1Lebp5/QohmCGOGKt76z94xOBZpaRIFQx7D0j84C/+yPr5OBuiGl4Hr1JzraJcFf25r3d0pUDIsB8Jpv0YNomVUqm8tmXO3z4GF1GWPvLrlDdy7kCto96h3pU3HwH2XelXRvOmbXciKrlyD06hyoYd2G/0MyQGRXe9uQO4El3N5Bd3NxlYWL4g3Js60en2nVylOmXORNxC6VyMosFea/X/7lV8lm3b5buteszD0JyxnxsrrVdLtOETz2iZu3t6+JAHURKdvaMLaVAf9p2V8Qd/zrOjLDJM5k6erLX2ir1QPs8FNJ/TxI+ISwcAfBM5PGIQN2ZripNXfHOqCszpLKGz22gy8s3P0LyHY9f3cM7ZufOBse0XqHM7UL7MKDTw2+rqrosxmjDbHnXNlh5r1WZ4s5tcESNO3GcU1mWfsiFQVrpCmuYqmoY1PpShW9w+68/CuO7r9+yAzCgGlxvHmv530y4KvSidtYCtQKlfQLH9u5E36f8x5aKNtMOEa4Zviyvf26accT29T2Y4AvKMGot4SOXuplNEtGYdQQqmLsZC4flbs8VA6l6aYX/RrlYJTd101kEtI6cgaPFRSDZrLZKY4c/ZH8jprqqgJHlgFIxrcmgyan87i5HL9sRNJz4Aeapx7ulo4NlyjaUo0gYiNwjFZTjYSkJNiK90cP2+ns/Mkm4/GYLntcUQnVuB++/tBLdx3eCqecJ6z0x1OOkBTTLOe/tRrOrBAFZlWDNs6yJ+Ru2t5Tr02S7KAlB32luGHWPdaFPKoc9I0
 pG5xNXFi
 Mh3r1fTZ+njoBMJFWO9VL5OwprO83AnQNyPetYdSoUnEyvwOQJxQh+XdKhyhhFF3TgJIMWHuchshkvYHGDCMwlnYQ0CGSPAHaNRsPLKijenKP8xl5ZuV8Ns2LrnHNOW4nlGN0nEDtUZ2GvVWDTJkWUxnwRlYIDZ0Ql8k8IeCEOJATBN+1n+QMKhrDcKHQ2TmX2+9IuDINL9P6y+lBszQ/k2Ga9X23MDxhajBcNoBzlEoIWaZ03Jt6zCCiXf7gaYC0Fx1I/CHGLxjfl3tlK6iPJt9AgL4jUieu5MgWDC/PFAE8Z1dh6dEOelpa9hspjCUJVgqjXyVDF8I+AmkpN9legD1jKVaYXKcRlNsdjgm5rVH9eyRiuE+BO3tmJMBR2SjcLkGhEb/Tp7O3KjtbnkYCJq26pK4F+2tasUS1tLtiNyNMJj+ecohKVJBe4+jm30eAB5onggSB+H1gbW3fKySQY9vS39Wam34lNVgOMQyRH5VSUGFGdoUWmxmTzjzYqvmU1d+w/aBoVYO+YWAkNdj/d/QdXA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

Sorry for the noise and for sending an insufficiently validated conclusion ea=
rlier. I rechecked this more carefully, and my earlier conclusion was not wel=
l founded.

I can no longer justify

  memcg_validate_race: fixed start/end mismatch (1 -> 0)

as evidence for this patch.

I rebuilt an apples-to-apples baseline/fixed pair from the same source base a=
nd reran the QEMU validation. The result is:

- baseline and fixed both reproduce the warning under the original remount-ba=
sed harness
- baseline and fixed both stop reproducing it under a no-remount harness
- the validation workers still start in the no-remount case

So this warning does not distinguish the wrapper patch from baseline behavior=
. At this point it appears to be induced by the remount/rebind test harness i=
tself, not evidence of a wrapper-specific regression.

I do not have a reproducer that distinguishes baseline from the patched kerne=
l, so I am dropping this patch from this line of argument.

Assisted-by: OpenAI Codex: GPT-5.4 [shell] [qemu]


