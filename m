Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A627C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 12:55:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D55866B0088; Mon, 13 Jul 2026 08:55:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D05756B008A; Mon, 13 Jul 2026 08:55:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF50F6B008C; Mon, 13 Jul 2026 08:55:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9760E6B0088
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 08:55:52 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0953E1A0149
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:55:52 +0000 (UTC)
X-FDA: 84983750544.24.0876B90
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1FC3918000A
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:55:49 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Vy6rOfQ3;
	spf=pass (imf24.hostedemail.com: domain of ptesarik@suse.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=ptesarik@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783947350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bY380AWNQSlOibS/srY3yyaxsq2HvIperV8l0Vu7xhw=;
	b=ImZNpcgM/PcAgzlS0EKVhuMGy5bksXh6zGYeu7+g/qZG3u5ulz4t4yA6qyKiawylZQmM2n
	X0H32fuJ+hsYuhnIzZq4rRuUq9kX/MrO2oidUfkBJsMOwJMWtXBAJ8YeYkCW8evIUfOf6z
	CUcQVONX4RjPV/7YmP97MLwqRcvLMuw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Vy6rOfQ3;
	spf=pass (imf24.hostedemail.com: domain of ptesarik@suse.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=ptesarik@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783947350;
	b=7g3lPuIIjvewGVADjLoX/sCNwRXQl59k0M88GzXbmIjYa//4tGjEikeLIi+VXl5CWyt3eH
	1fCQGH19VXBJkPkvYdTUAMoK3g9rWn6h+SaTqHHrsAwHdqiJoiMANUSu+R6mL6gDL0nUAe
	z34RS/vGW5xB7gdgQ0B+EFDmP1OJsnI=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-493c564ed4dso2115095e9.3
        for <linux-mm@kvack.org>; Mon, 13 Jul 2026 05:55:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1783947349; x=1784552149; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bY380AWNQSlOibS/srY3yyaxsq2HvIperV8l0Vu7xhw=;
        b=Vy6rOfQ3ATXsu2JZ7NA06Lw9hn3omVDKJ/4VWHgBmLqtdIKnx7LKB7t3kCnvQWc6hX
         dAnqkNGytWZ1GJaXa+zjPQLTxVwh3rzokSkpf4n6gKUyBeiBM0SXnDHkO/b9pXY/jT+u
         5PVng5uuPHVRcqY4uVvvMCfHVVEjDGZoiHn4MLTd4Ej153JtJhDTA/mkEkHu5WfUtLn0
         X0Sj/MPhM7hPqi4YHWEeuPP2kGYozbJ3L5NypxoNw0BxlYhCCksfo+JUaZLNaeLARYar
         RzZlGeWiEaQ1myFd8f3kj4Sp6IAMD5m2mSeDhTJhkHxUrNOTghlX2t3A64amIU484qwE
         HBgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783947349; x=1784552149;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bY380AWNQSlOibS/srY3yyaxsq2HvIperV8l0Vu7xhw=;
        b=LgsTMqmJ+Jez2C5e6q+4WWPXhvbxcwH43pBwRVCAK/sQ3WnLQSJwXjWCieyC+KI78S
         5csv+fzyknI1WckkFylOeC4GfmCXT76QhGps/Rz0IqOxoanXTa4UPtqx/Lcoeo7zHBbM
         lc4AwnnCsx9e7SAPCxqpDpSNxnUjJzJ1g+Ce7+asAW71BhOyQfgGc4zi4otgXw4En28o
         mQrnssQZnesGmGXwf8frML7bD5kOFm7kFKJR3KjMkl2aiphjJbqEhp1vFPsXAm++RGBR
         QEIAwUuBtjUbuQTXvzVAoebyyJqBpPyGCCVhbRR4+xKtDdvni7DOVhf6/fTrMiLtqKYI
         ELaA==
X-Forwarded-Encrypted: i=1; AHgh+Ro2t3WXImRTZJY5oZxbbSXO4qO/D1OadYD/JpMC2utqGfRdceAth+ootp36k7yrOu7bTk9rGOOawg==@kvack.org
X-Gm-Message-State: AOJu0YxGZ18eiQbNQmPMxS8HQONcwsJO2CkTcCCwL3eAPwV5rqaNSGvz
	GTdsVrl6pznEsFz58QHQjVFoZ9NHcPTbOemDg7Hz8HI4zTF316T5H8sft5PFjyxtHyI=
X-Gm-Gg: AfdE7clZUNvoDjdv6uobAMG+ZdgPEkNEwmmIncLAWKqSEgnXVQE9alWjRCKbrakWqVN
	2RPrsosfaymmHKaJ2U4tr4Lsme+tiYVfkNqwuJeIlvi9rOM1hfWXtiExFNBdRNwXZ2bX0l7mSLY
	ZKqAjsOP2qPdf5JdSFF5AgurfeDd9KydJB8W6AGmxn4XJ/OrtuslFXZ0KA/RQTmGtxeYMP/uZdU
	0RqGTlOCVeMHtCiAtM0x9dDtTp5hcFTYf0aoTj/MqDqNp8TGcfsL1Lwf1IAQFkXYCNJgL+grogz
	JQapbEy04nH0wZg6Wl8vmSQddm/4X0GsBbxEyIiXoavrr8WBEEFf6l39xgTA2fhihOAXeIpexwX
	4wT4HfOO6KsmSEwNE3J/qa728CND0lpWuDM6SlDsN6+Ju28kqplrmRC5jYJ3UttyJVvKXCNYzYm
	DLhuoG9YtBUQLDF0flE7d/75XCdOhBJRsJ88b4Lkotieb7qJ8EtbX2QT2Myt3O6DgvDI2PprBIH
	S/Wpg==
X-Received: by 2002:a05:600c:3e1b:b0:493:bd67:315 with SMTP id 5b1f17b1804b1-493f882fb12mr60707365e9.5.1783947348558;
        Mon, 13 Jul 2026 05:55:48 -0700 (PDT)
Received: from mordecai (dynamic-2a00-1028-83b8-1e7a-3010-3bd6-8521-caf1.ipv6.o2.cz. [2a00:1028:83b8:1e7a:3010:3bd6:8521:caf1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493eb6ff6casm431976995e9.5.2026.07.13.05.55.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 05:55:48 -0700 (PDT)
Date: Mon, 13 Jul 2026 14:55:45 +0200
From: Petr Tesarik <ptesarik@suse.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
 <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, linux-mm@kvack.org, Brendan Jackman
 <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/1] mm: let node_reclaim() return the number of
 pages reclaimed
Message-ID: <20260713145545.1ff1136b@mordecai>
In-Reply-To: <20260713110443.GD276793@cmpxchg.org>
References: <20260710152320.2024283-1-ptesarik@suse.com>
	<20260713110443.GD276793@cmpxchg.org>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1FC3918000A
X-Stat-Signature: q4u613yeyap4hyxumo1fj5ix1uk51jeq
X-HE-Tag: 1783947349-589898
X-HE-Meta: U2FsdGVkX1/p0uwoWlbaY0Xwrpy2T+M87gC1+WL0jR4DKpDeQdflRc2s6KSl5UvM5Ja0yOcSF391iHnX4ZK30yjGEF85MpqvEeMYcDZ8xXUFdUczz02lTLSkvMnrz0JmoY34+yshsQSP3s4dj1ErM+1TeYHj2k+CzFw+UJAT9eV52GtfKz25ybE67FafUJak+hTKrIngGlE5p3XZWpCq38Y+XvyujtmZpVZaBcivo71253oGYM5fB0Jna2zKNn6KcqIy4R+tiNaOymyzTSt4hEQ0A5g4Ii72knPoPZtpt2n1rqSVZEtfbXYodrHhl8uuYgUjMnOsI1PxzM+Dih05xBSmNrxHGT3mFQxEkTOzujUECN0pAC060gJ53GBtAuoqnC9UWJTV99eZqaIqb0aSmU+0Tick6pWYTDh26VVlZPVd654xU5QgYRdKDiOWq1DYaRDkYm6qI8mUocUkcKHLreTKn0QE/GsxV3PBzMGWKlzReLxVVo+U78o9vLg3IfabI5M0jehLmwM9pPpbXRYrHW0albJhU+CxjSsZ+6X9oRuXdq6ga+TTTDub4t4qR7mSyqU9o1vpiYyyuHOhmTfxK87R5AwRG71Yw4n8vJucc+gVln98c3s7yq4Rx8K7xQ/oQ2XN4dDA9UMig7gySyTtaFqtYsTyjiICWNIPEUE0JOw7YGtnCLZ1QhkWx7dLOopxKR363mzz3IAAWp2updVHRU7RYvPm0z7fMqNYt+T02ZxmfeTOWposBQmSW/bS6oNG9eDcathi7KnFR8BS0NrMhqBkXD2PzSBVtkTidgp0F1rChuv5GQsolU3V42iNZo2vwoKuft5dAtdAUAKx8yUoyHrSF212s+hzj60fEMFGbXOaZeOWdvze4yWGNFqN2Hr42xg3YBv2NS1vE1TT/tb9KPc5C/XSxv4hXvHI0DMvqeNfwqDvGDtVem16eXlVLCOZ5H1TUvlbIOBj6gMvJOI
 0p3+1xRJ
 kVcffBXxbVW5VVqo37a3kK8jSKKLMQ5MjVzIZFViyWMWL1E7TPXrbb4LnmqUdVJUPMZtUY0SOqqfnebDeutTOKZYwaOaKDIX2pd0QGldfHD3CIU1fQP8Z5ctBZsiFiy6t+Wog3YkIPiUndeM92nxaTdXbwkxs1r76CQJgc6I2fU7l1YZMx8mV4XX2XgBWd4BkXHYxf+SxDi1SEKHsX0Jcmy6dhv+vNX0zyUVqotddpG8PTeiHj+tC1+JZzCeHmFBfW2V6jjYcK+iVsFXONhN+BDZQJOPiLHA0J7XIfx8EgopcAPNcUBoxslkh31DWxI3wbQIOkYGV74YN9bo/+whLCEiiSCcZUqoB7qSiiqG6A05GbWsriJK9PCctMK2OMjmH1ag0zGtxwTzXPHdW+Pzqn8qs49BQe7YT7nwz5nFXqrpPP7FmpMks7jdwv3WgQJZPeZRU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

V Mon, 13 Jul 2026 07:04:43 -0400
Johannes Weiner <hannes@cmpxchg.org> naps=C3=A1no:

> On Fri, Jul 10, 2026 at 05:23:20PM +0200, Petr Tesarik wrote:
> > There is only one caller, get_page_from_freelist(), and it does not make
> > any use of the reason for skipping the reclaim, nor does it make any
> > distinction between a full and partially successful reclaim.
> >=20
> > Therefore, node_reclaim() can simply return the number of pages that ha=
ve
> > been reclaimed, same as __node_reclaim(), and the NODE_RECLAIM_xxx macr=
os
> > can be removed.
> >=20
> > There is one small change of behavior when __node_reclaim() was attempt=
ed
> > but returned zero. The allocation now skips the zone immediately; before
> > this patch, the zone watermarks were checked first. I believe it was an
> > oversight rather than intention, because the chances that zone watermar=
k is
> > OK after __node_reclaim() did not reclaim any pages are very close to z=
ero.
> >=20
> > Originally, I was looking for occurences of NODE_RECLAIM_SOME and
> > NODE_RECLAIM_SUCCESS, but I couldn't find any. That's because they are
> > typecast from the result of a relational operator. This seemed a bit
> > fragile, so I dug a bit deeper and came up with this proposed cleanup.
> >=20
> > Signed-off-by: Petr Tesarik <ptesarik@suse.com> =20
>=20
> Looks good to me, and agree with the minor change in behavior being
> acceptable. With the macros actually removed,

Uh-oh, I missed that hunk when rebasing, and of course, there's no
compiler warning about unused macros. :-(

> Acked-by: Johannes Weiner <hannes@cmpxchg.org>

Thank you. Shall I resubmit once more to include the hunk that removes
the macros from mm/internal.h?

Petr T

