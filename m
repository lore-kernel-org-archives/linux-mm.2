Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35DADC44500
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 11:53:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9470D6B0163; Thu, 22 Jan 2026 06:53:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91E7E6B0164; Thu, 22 Jan 2026 06:53:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 854B46B0165; Thu, 22 Jan 2026 06:53:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7164D6B0163
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 06:53:41 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1E0E1160297
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 11:53:41 +0000 (UTC)
X-FDA: 84359440242.20.166BE5E
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf14.hostedemail.com (Postfix) with ESMTP id A5F2E100009
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 11:53:37 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EmMicMAr;
	spf=pass (imf14.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769082819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nK3lpHbFMGMoogUekcAz2kADIERYkYftxCT2FRmWKLQ=;
	b=zYblgcj8GZkGg1g5sfxX8ZABBbCLmJSEHxQoFX2I1G12ZTO5JsK9D8R8N1JEk2PxYjKZv7
	SU9FpAJfzx6mH16KZ9SemlDv9MZ5y+qcjtPFAR2SOJ9GOsRfAdol9i8APMMQZyd4hfz+vN
	QBlq2Hx3TIukJdWZbBlU9KKLvY5tFM8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EmMicMAr;
	spf=pass (imf14.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769082819; a=rsa-sha256;
	cv=none;
	b=xhYuTiPIp6Vh5wFBSavS53+KE/qiYdkTNakZyh2OlQzZtXnSdEShdvVbe5EgM55YZr7THi
	TZ4HMPpWOBuXnw8Bw76OjH8XtjvgPycigQiK5C6AuBwm2RwQ4uti/As62hs8ZR8J0fl1+L
	ijPKMcNdcvmCuDju+xvbcM7OZW0v23E=
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769082815;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nK3lpHbFMGMoogUekcAz2kADIERYkYftxCT2FRmWKLQ=;
	b=EmMicMArBlyYzb+D+vR715OwkPD0z9nzIGfjpZO5HTCVF4+7K2WAZKp+mM73BuLfQn4Xv4
	22T0gI2wR4WjYujVh24UdlzeogLeCXt+8iHDSTqedMbRe3mTgBVoKxS3n25fpqRQM9r2b5
	oHaf8RsTTbEpjH8slm6r/odSav0G6lk=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.300.41.1.7\))
Subject: Re: [PATCHv4 05/14] mm: Rework compound_head() for power-of-2
 sizeof(struct page)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <aXIKBhHd7IbaJkXg@thinkstation>
Date: Thu, 22 Jan 2026 19:52:52 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Matthew Wilcox <willy@infradead.org>,
 Usama Arif <usamaarif642@gmail.com>,
 Frank van der Linden <fvdl@google.com>,
 Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baoquan He <bhe@redhat.com>,
 Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Jonathan Corbet <corbet@lwn.net>,
 kernel-team@meta.com,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <85016E74-E7D6-4AA1-8754-24B86496CEFE@linux.dev>
References: <20260121162253.2216580-1-kas@kernel.org>
 <20260121162253.2216580-6-kas@kernel.org>
 <EB8941D9-B6E0-41DD-9C44-038D21583E17@nvidia.com>
 <aXIKBhHd7IbaJkXg@thinkstation>
To: Kiryl Shutsemau <kas@kernel.org>,
 Zi Yan <ziy@nvidia.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: qkipdi7668r6tk8qo36rg8m6gw7sh8jc
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A5F2E100009
X-HE-Tag: 1769082817-578408
X-HE-Meta: U2FsdGVkX18wlakPzqkUIH//EfKZi6/nAmMWqsSTU8/BuI6xFCJUYyKt9IIOPfcDLvGZoyq4ibBrlMdJjqqhsBAvoW+qSYTmO1iBv+zD9Mbvqt/kN0047xd4V5nMEpNk+90PCOUHFXooSOY+WZKVXUW9xkkjB/hJ/+oX4uhP7TQL377rLsAOqTq8nVzbKVUoh7y3LTLTPVOsRVgFof44e1yetCO2TwTiSm4TwkyXRaRu1G88u/3U77hxr0ybA5L3x3C+VqUAoA/9y+x7tQRDseFe5pxYa7rl5pfXDG/mW7WOutSET4bMOi6gC++pKLs+hKpifFLEzonWXcyX3jMEtMuXVC0FNCBsbTR2BgMH1AHTOrqBahAe5C7h1GFBjRaHAyyERlFAo21jI8ziahdRRuhIBW7bPYh4JvyOY2nQL+mN3GxY1YroYPrVw58VIBDGE+NV4VvwP/q/pbeqSISxGTbtzFlJlIx/gcEpK8k4ESHDP0WUinqdFganFKHTXxTP2Bjk6GPi99LtxdQBk4Ip/GefiqmgtsoPutrhcrXN7NR7sup/leBrxV9DO9gDUrFXc8Sqa3idTXSUeOuBDXnwb254aGbnmebkNzh5eKwqcgbyprymLtkuaxT38Bl1VXMld2uYgx64GvaUb+NIAk8J8CRsJpqWx2Zz2TcGESXzZjLh2sDEdvnCpKZ1SJluCSOJe0WrqhRMQvwBIPS1LO7GfY6lD+UDIigdE1wS4rJHP1cVHrq4vGUD/ZdeMbqawJqXjdfpYA1ZcjmETBuRdW/R5u85Y1+qed/T7K3k5Vm99kBrhiwQU1jb1WOzoeIpk+caoMf+j+SlPVi1P6DFUoDFmeLDVtkxmFkeIyZQSo+SvAEQqGfSkFIIxoFBxS2GRZj8RNlY10CmLQFh+nRDenq7zIIiTkM1GQtkxJrIJDV5SlxT26klg0O5/W/EYiwIlSkj4wd8Ls4EFdniHv1aS6i
 c28oxEeC
 kZ0wXvzJ7ab+eRcRxQolsMMCpq+zqnDIFWuUnPrhStKpVkiEUeaojmixUhFixX78DiV3mOV//DPbvpno4CRKI0qkNwLWzkDm67vrc28fkHwIvhBV15CZVo2kcNyUGOeEOZV1W4DVL+vXKDoAxW48W0FmQpXgwgyOXbg9bS9vk+ewyjCGXhOXSttvKJVGok95owwysQcL1fLaMTL6vXarVOEqoUIUw5dOtYFK4Bq6bX3CJ73MdQuntQ8nwZF9NlpE4p/Q1ZDJkEO1mBg8Qbmeao1gTwdJNHgUxSGNdg6szg8yft69I6P8QSzV0fA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jan 22, 2026, at 19:29, Kiryl Shutsemau <kas@kernel.org> wrote:
>=20
> On Wed, Jan 21, 2026 at 12:12:13PM -0500, Zi Yan wrote:
>>> @@ -1244,8 +1244,8 @@ void snapshot_page(struct page_snapshot *ps, =
const struct page *page)
>>> again:
>>> memset(&ps->folio_snapshot, 0, sizeof(struct folio));
>>> memcpy(&ps->page_snapshot, page, sizeof(*page));
>>> - head =3D ps->page_snapshot.compound_info;
>>> - if ((head & 1) =3D=3D 0) {
>>> + info =3D ps->page_snapshot.compound_info;
>>> + if ((info & 1) =3D=3D 0) {
>>=20
>> This could be =E2=80=9Cif (!(info & 1))=E2=80=9D like =
_compound_head(), right?
>=20
> Right. But I don't see why it has to change.

Let me briefly explain my programming habits. I guess this might
be Zi Yan's idea.

When I use a variable as a boolean type, my habit is to use the
"!var" operator to check if it is 0 (false). When I use a variable
as a number (with a value range exceeding 0 and 1), and I need to
check if this variable is 0, I usually use "var =3D=3D 0".

The least significant bit here seems to be used as a boolean type.

>=20
>=20
> --=20
>  Kiryl Shutsemau / Kirill A. Shutemov


