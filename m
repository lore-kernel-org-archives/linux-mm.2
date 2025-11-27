Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B43FD11183
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 12:14:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05F2A6B0027; Thu, 27 Nov 2025 07:14:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 036D96B002B; Thu, 27 Nov 2025 07:14:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB5F06B002C; Thu, 27 Nov 2025 07:14:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DA29C6B0027
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 07:14:41 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 78CFA140A2B
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 12:14:41 +0000 (UTC)
X-FDA: 84156280362.13.22E65B6
Received: from sg-1-100.ptr.blmpb.com (sg-1-100.ptr.blmpb.com [118.26.132.100])
	by imf23.hostedemail.com (Postfix) with ESMTP id ACD25140004
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 12:14:38 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b="OYTUW7d/";
	spf=pass (imf23.hostedemail.com: domain of guojinhui.liam@bytedance.com designates 118.26.132.100 as permitted sender) smtp.mailfrom=guojinhui.liam@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764245679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CHPGookPXFYQULpo2LQ06D8jqiRXCuxCUU9K/zATqvo=;
	b=alTJMie+7gAhX+sWiwGtkGxf9q7HTDK5ixtsI4vgmCJFyn5ZHMi6UipuyT6edLisfBx8KP
	YdU60JGkD7Qk2QOdYquYl6SoA3/2JQzFWjhWf/zJSeMI0kx+KogL0TTATYgFmM1JLLdzMP
	6+8CWQ+LVKp81GYMaHM7e3aU5w8Fffs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764245679; a=rsa-sha256;
	cv=none;
	b=nQG0ftUl/r6tRT/QFvMtub2tE4daumf08UZ+5KlBthvIgfi0oK8GhMD9SzA62eKmMDxupq
	0WrnEnRRYPdRsBIIaen19bF9ckqVOvy8FN/K+qtGoKo/BXbgviNSYk7zuf9F9d+FawUPgb
	tS17tj1/BYyyseqnHDJJMIMcZDujWgQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b="OYTUW7d/";
	spf=pass (imf23.hostedemail.com: domain of guojinhui.liam@bytedance.com designates 118.26.132.100 as permitted sender) smtp.mailfrom=guojinhui.liam@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1764245667; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=CHPGookPXFYQULpo2LQ06D8jqiRXCuxCUU9K/zATqvo=;
 b=OYTUW7d/CWTTySWM9mPvubnfAEC19vmk4jZNg+734tkRDqV+4SrNn1mF3Lyui/G+pFgvY6
 GJK9jYTuXXYY8YfczN+hsJNQNLmgtyEio37D/SMYTwdOhOd8ku8l/KfeqAzASoRvmc0ywQ
 zxEVlH+BjdpV8v8+i0TxsHKgTYx4j3ZljAm1qnMjUmIfyDUWv5aC3b9eIZD8Q3ckE5ly8U
 sshgZnZot+rIc+ldBkB/93P+K9IZC8X/I1l9cDqj9cjmAsWD4kozk8r6l1Jg0b7zZQPm1u
 R0U+ogWUFujgyls728Cfug0CabII9KOR+e6Q4CpMLIQEC9SOnpmaiM6qSLRL9A==
Mime-Version: 1.0
X-Lms-Return-Path: <lba+2692840a1+5edd79+kvack.org+guojinhui.liam@bytedance.com>
Cc: <Liam.Howlett@oracle.com>, <akpm@linux-foundation.org>, 
	<fvdl@google.com>, <guojinhui.liam@bytedance.com>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	<lorenzo.stoakes@oracle.com>, <mhocko@suse.com>, <rppt@kernel.org>, 
	<surenb@google.com>
Date: Thu, 27 Nov 2025 20:14:10 +0800
Message-Id: <20251127121410.357-1-guojinhui.liam@bytedance.com>
X-Original-From: Jinhui Guo <guojinhui.liam@bytedance.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain; charset=UTF-8
To: <david@kernel.org>
From: "Jinhui Guo" <guojinhui.liam@bytedance.com>
In-Reply-To: <3cdc6bd6-f0c4-410f-b2a2-8cc2b5d1c522@kernel.org>
Subject: Re: [PATCH] mm/sparse: Fix sparse_vmemmap_init_nid_early definition without CONFIG_SPARSEMEM
References: <3cdc6bd6-f0c4-410f-b2a2-8cc2b5d1c522@kernel.org>
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: ACD25140004
X-Stat-Signature: u4iiwyzoszmgfu38611fqabtyxrtxkdz
X-HE-Tag: 1764245678-407448
X-HE-Meta: U2FsdGVkX1/1Mm427pPMZsBEdm0R/G4PLgoty/1GUCk5eDoDVqjcZ/dqhjYrDIZ7xy5ZtZFA8FT/Bq9gMwKQeJZKr2+qlSudWR6pDtUI2KPY/07PlCEl3KVfJErgHf1B0zjn0lko3mleHn7E/Ay8HgJ+ptLCWQuKYgx5LmvFua3QEPRFGH9tqvlINLIymeztCEkKWCkvK8lrPEdhN1JZC0Gkjd06bhmEGg56h7YeCRi7wJSixTTs5v00nq7zlvItLDx5nDFG752/9ci1PqlXr3LxpeanunWLgkzWTQizgN1viENBlzc7Grb6y+RMSOgDgHIVSTaFr8mWIt6EIwhesdilrRbkOs7gTTxUEJ1Jy2f7itlIpMmwB0EIswl4gkru6pdoPRLuEiJ0okrFNxZzpkuR3cHS5TvbjkuPyPlNN9PHejGIivFetDesrb9Wmp2Bv6gQsbzpEUjEry/PUA6tOxJJaub10t8yy9G3vHgHTUNDzydpEbM8khe7GLHCBx9yjRspsA9NTYgYZeClE9/6qmsCxaagK9ff80hYFTAQbwGtEr0jD+H9mrXfRPfHOZZwUZp1mzOET5U7HixhLumiAwGlODkfF7TrMpT9xC6eq9OljV2gy3Cdw/LuZnyihoE+qUCDsuDHh8EB1JqX3Iosg2vzhO0Zp7OQog4nO2epSTDwqkgt//xfYcVDOw1XTGj+O2ERu3zu7cY8rjYEGTzX8pl9pGQ4Qoqhj9X+cXVzvonGYUfUFFCbjYV+xIReA13Pyz8N4rJRin1m66sQ4MMG+jD8eDE8FOr5l3f9A0l1XRiikNk4I+cfDZ8BHvhYwxlES25n9lJIMUwcd+jZtO01UIizkOIeL8PbwPX4nF27qLA8w95iXHeW8440oKqO8mex2nDm35usogy/2MEsPIHWBZLuXQ85aGuzPhG7dw2JwQ/yh/bBEi8G6+z5GBKXg6Vq9nJwm13EBqzu2LbauFD
 dihdeugp
 BE0O9+efmfvOLVX4ivakF7w1GfqXTQl9i6YBcqmwmuJzO7JqhNwQzfr7t57IDwR3CYxObRMRLSxo5A9gw2Qol9PK5Yjdcf5qmfhAEBXhTrzzij4jtTjcLoEIcI7m/QG1S5KsiQzRaEGc7QvCYUKORdULe1dxaDlazMGCr7dTPBE/h3nl98za80XXr9V8CQl5BY3HcVRPD0YbX8Hl8OYBmS9tGhJPbmhn1CdY9FJczM0RdMKUlh5L2QbBGj0RK15s9bExGWGu8NhGxiFnzBm3prqruC4u+USeWnU3cnDtPAoSet8L/sEt51W3xgzDplx9SEyNYZ2ucBrzD9NBnNZH0YZ6EiMalliy6zf/6EqCmCZGfujN+EmgmePRzL3sNWxSFHAyW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, David

On Thu, Nov 27, 2025 at 10:46:54AM +0100, David Hildenbrand (Red Hat) wrote=
:
> On 11/27/25 10:25, Jinhui Guo wrote:
> > When CONFIG_SPARSEMEM is disabled, the macro
> > sparse_vmemmap_init_nid_early(_nid, _use) passes
> > two arguments, while the actual function accepts
> > only nid. Drop the extra argument _use.
> >=20
> > Fixes: d65917c42373 ("mm/sparse: allow for alternate vmemmap section in=
it at boot")
> > Signed-off-by: Jinhui Guo <guojinhui.liam@bytedance.com>
> > ---
> >   include/linux/mmzone.h | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> > index 7fb7331c5725..f6dd181a4821 100644
> > --- a/include/linux/mmzone.h
> > +++ b/include/linux/mmzone.h
> > @@ -2293,7 +2293,7 @@ void sparse_init(void);
> >   #else
> >   #define sparse_init()	do {} while (0)
> >   #define sparse_index_init(_sec, _nid)  do {} while (0)
> > -#define sparse_vmemmap_init_nid_early(_nid, _use) do {} while (0)
> > +#define sparse_vmemmap_init_nid_early(_nid) do {} while (0)
> >   #define sparse_vmemmap_init_nid_late(_nid) do {} while (0)
> >   #define pfn_in_present_section pfn_valid
> >   #define subsection_map_init(_pfn, _nr_pages) do {} while (0)
>=20
> That commit is from early 2025.
>=20
> So what are the symptoms we are fixing? I would have assumed a compile-ti=
me
> problem, but no built bot caught that?

I spotted the issue while porting the patches. It=E2=80=99s harmless. Both
sparse_index_init() and sparse_vmemmap_init_nid_early() are only
referenced in mm/sparse.c and mm/sparse-vmemmap.c. So they can simply
be deleted from include/linux/mmzone.h when CONFIG_SPARSEMEM is disabled.

> --=20
> Cheers
> David

--
Best regards,
Jinhui

