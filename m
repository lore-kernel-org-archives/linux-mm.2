Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FB63C61DCB
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 18:34:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BACD6B008C; Fri, 28 Aug 2026 14:34:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06C416B0092; Fri, 28 Aug 2026 14:34:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC4AC6B0095; Fri, 28 Aug 2026 14:34:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CEE326B008C
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 14:34:29 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 658A38039C
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 18:34:29 +0000 (UTC)
X-FDA: 85151528658.07.839771E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id A288E100003
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 18:34:27 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lRrIQfmm;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787942067;
	b=CgQrd9qvGWsckxvNQibGQdlCtUDoaYdMMYih1kqF1VTNm8l+QnWEn2bgF8h+/FXvO/Mf3y
	w+FCz3pRVy5rlzTaX6D1wNe5eQuFoHkXdTqMJWRSDCyQaEWF5E5/K22lZ1/l+g8u79Hw13
	eWGlLeenuAcYjHUz53MKP1/IvqeyeD8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lRrIQfmm;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787942067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=86nATO2Tu0jZBpxgXv1REoJRi08xat/kpDwIpazzsWU=;
	b=mJzzmn3oVmipBQLd9/5oDf5J3pepCDoX/GNkApQ0ppy7QNwrI5IQUHcXIdusiDVAbIH5It
	TSDxrU/4k93xg8lGotKPQ8zYUvuAHSX6bT2xx7eXwIteeAI8bDd6WIFqFe0RQMGJ67im6t
	Yzb8/o2VMPpDR3qcSukOkPVNTN0MbU0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B9E8F41A92;
	Fri, 28 Aug 2026 18:34:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 285DA1F000E9;
	Fri, 28 Aug 2026 18:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787942066;
	bh=86nATO2Tu0jZBpxgXv1REoJRi08xat/kpDwIpazzsWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lRrIQfmmFNi3qSzFzLyCewXV9zO6hUZ9/OOOVsBgv/mM6fuYWRhmreKto9IJrmla5
	 72ggZXs9XywE0ibXRwVDhsDD6zZZN3w7VXfHYuUKH1AYexz52ME5S/RLiYxIWeldiP
	 teUGn++zmZeGJjfqpoIXBtA5AOYgY9nPlsz5mzphQ66nMlYhNVZvnBX+vRlvtMRq1y
	 len7ZKmo9YL1V8WsZJfdsinMXp1p3iN3UCZiWZ652pCkr92cpNkLkLpb22zSCpOeHr
	 PIKQqXM67MeO05YnS3o9LU2yNJ1rEma5pJZihnu4rVke8dXXkCped0no/iKf5p9mKy
	 hqUfhguEvf2/w==
From: SJ Park <sj@kernel.org>
To: Zenghui Yu <zenghui.yu@linux.dev>
Cc: SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH v3 25/37] Docs/admin-guide/mm/damon/usage: document sample filters dir
Date: Fri, 28 Aug 2026 11:34:17 -0700
Message-ID: <20260828183419.70652-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <88698ac7-3a60-45b7-908a-7f1521c021aa@linux.dev>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: d6u71ct56sgb5k5u37u94hixtnk8m4x7
X-Rspamd-Queue-Id: A288E100003
X-Rspamd-Server: rspam06
X-HE-Tag: 1787942067-325941
X-HE-Meta: U2FsdGVkX19PgKsZcIy1u1yvyKFq1mqwA3BamMvpopIsGSI7kVRoTJn2GqO5iPM0gfiXHFFpTZvVxNkE5znATFULGxYs9agsvqlNPrlPmIpxWzwxL39jIONuuSV7ctNq2+piF50y4ACHfZgaXtYq5iEuwc2rM861VJrAY+ri8a6/X3yUBq/7sVt/3m+AZeSgd950zDRqVnN5hiq2nzh7BmzdPDh+4JVbE/BkCEo9JEwLYTMFlui5aSOnOMlTJZ7Gvxb68AUjzE29EEtxTO2njXYipcmbqbuwGeSkWqvIchZGNGFyARHAxiB07qYQxHde+/iF93/OOPi5QDsAWecyjvh93PkjqCYxUR2+CIa04XKaGzVr9UHb3X/ekajTEykc0N5fLUBTQflNPUSmcURVoRyTitUo+0pufFpj8+PWAZ3h3mMSb2FeMFqdeijKpEiaN8MAOANEkP8ljb6bNUj7oLdTnPiXuX1AkRVGFHJpfWLERJQfhwqTlaZstYrVzEWpk0fmMgYDqUbXxjcDR1JbksCS5Dz92xuAkVxjDOzAybVkEW9PPRb9OecKeuWa4SmaHqeBxaubRTWAhm0RIkhl+9cbdjbPsdLfvSo+0ssBZvo6doa2ACDp1Nom0J33eX00kK83mD3ySWBDWLFdjf8ETBBjZsz4qszdLheDTZOTlE6jXYXYntd2ROFKu/0jH6iZECo9a9BaI8Se/+kidkcnU1ui+NAdeZbs+4Q7S8XVBLXNHrEcOX4YIxdnHeewvan52mQBkSYL4oC285zGl94Cx+Je8raThCAW+he/QMR8PnEMgQE98W29EPGWn3qoup1lFzHYQTUX7YXcXwh1iu7gXWqYAl8nb4ubeggkueH9NAcrW9HzielgTRaApJxZLroGue60m5b07cQ7M6fQFneQAwnHtl3YarpIz6HZ6eZwvXXt9qUYbs1o7YKER6ErMK7Uda1xDr1zx13itGp4r4K
 eNRm3wrh
 CyiKV+dij7BSE6xVUGkUI6oHrGEzp9PwVUm0UBL6pzmyUZ/4LhXTYlg/zrEdd07zcOOhTsjuImCe2gbC8u0JCYVgrk+9l+QVMbYZ1/h1h50O1DzYQpF93jol93I0lzaizD9a5YNQqDP1MFfDLJpNMLD0EkwuQ86la71W5w7T8Bmw3C6tFp4MEKVeCyMieT5DiIHhOoEmDW+SlMEl0tEMQiSSF4/jILBkoKHOAnQBzOEdAutnsnQWoUUjW/k0fzLybzIcE9oB5vrhVR+c1OW3uw9ssfBmxTTOL2UfeRi+cPIGGv4gjHnS04Dw7XFZ5z0vzbeGlVuSpYiD42aPcFnkixUHtdaI3XdDTpZsMUv6+iivoGZK1iscNWp/FFoc8AJeM06Qu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 28 Aug 2026 12:13:20 +0800 Zenghui Yu <zenghui.yu@linux.dev> wrote:

> On 12/8/25 2:29 PM, SeongJae Park wrote:
> > Update DAMON usage document for the added DAMON sysfs files for
> > installing and setting the access sample results filtering.
> > 
> > Signed-off-by: SeongJae Park <sj@kernel.org>
> > ---
> >  Documentation/admin-guide/mm/damon/usage.rst | 25 +++++++++++++++++++-
> >  1 file changed, 24 insertions(+), 1 deletion(-)
> > 
> > diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
> > index 897a89950351..365a4548a5ba 100644
> > --- a/Documentation/admin-guide/mm/damon/usage.rst
> > +++ b/Documentation/admin-guide/mm/damon/usage.rst
> > @@ -66,6 +66,8 @@ comma (",").
> >      │ │ │ │ │ │ intervals/sample_us,aggr_us,update_us
> >      │ │ │ │ │ │ │ intervals_goal/access_bp,aggrs,min_sample_us,max_sample_us
> >      │ │ │ │ │ │ sample/primitives/page_table,page_faults
> > +    │ │ │ │ │ │ sample/filters/nr_filters
> > +    │ │ │ │ │ │ │ 0/type,matching,allow,cpumask
> >      │ │ │ │ │ │ nr_regions/min,max
> >      │ │ │ │ │ :ref:`targets <sysfs_targets>`/nr_targets
> >      │ │ │ │ │ │ :ref:`0 <sysfs_target>`/pid_target,obsolete_target
> > @@ -233,7 +235,8 @@ writing to and rading from the files.
> >  For more details about the intervals and monitoring regions range, please refer
> >  to the Design document (:doc:`/mm/damon/design`).
> >  
> > -Under ``sample`` directory, a directory, ``primitives`` exists.
> > +Under ``sample`` directory, two directories, ``primitives`` and ``filters``
> > +exist.
> >  
> >  contexts/<N>/monitoring_attrs/sample/primitives/
> >  ------------------------------------------------
> > @@ -245,6 +248,26 @@ to these files, users can select whether to use the :ref:`page table accessed
> >  bit <damon_design_pte_accessed_bit_access_check>` and :ref:`page fault events
> >  <damon_design_page_fault_access_check>`, respectively.
> >  
> > +contexts/<N>/monitoring_attrs/sample/filters/
> > +---------------------------------------------
> > +
> > +This directory is for control of the :ref:`access sampling results filters
> > +<damon_design_sampling_results_filters>`.  At the beginning, this directory has
> > +only one file, ``nr_filters``.  Writing a positive integer ``<n>`` to the file
> > +generates directories of the number, named ``0`` to ``<n - 1>``.  The generated
> > +directories represent the sampling result filters to install to the DAMON
> > +context, in the order of the directory names.  Writing ``0`` to ``nr_filters``
> > +removes the directories.
> > +
> > +Under the individual filter directory, five files, ``type``, ``matching``,
> 
> nitpick: "four files" in this patch and "five files" in patch #32.

Thank you for reviewing, Zenghui!  I will keep this in my mind when I write a
successor [1] of this.

[1] https://lore.kernel.org/all/20260525225208.1179-1-sj@kernel.org/


Thanks,
SJ

[...]

