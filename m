Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43AE0109C036
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 16:29:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADF516B0092; Wed, 25 Mar 2026 12:29:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A90B06B0096; Wed, 25 Mar 2026 12:29:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CD016B0098; Wed, 25 Mar 2026 12:29:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8CDC56B0092
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 12:29:14 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4F37C1B8E5C
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 16:29:14 +0000 (UTC)
X-FDA: 84585120228.19.542A4AD
Received: from sender-of-o55.zoho.eu (sender-of-o55.zoho.eu [136.143.169.55])
	by imf18.hostedemail.com (Postfix) with ESMTP id 250151C000C
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 16:29:11 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=Q+mnHiIz;
	spf=pass (imf18.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774456152;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oeL6ks64Ze/pGwHs2qvXBTZpnyzzF7fV/OGrrVTI+fE=;
	b=ruGtCa/THvErpb1O1rVifKQLjjaOqUqiGnE1kjLn71cKRiHNqgwLo8KHHgdXgg+aUwxHgU
	RS+kYnVAEDoPp1FN63MryHtz3DuVoQHnA8d/PJnvPL1JU3ULCKoCW393faZWuvj6shRgjL
	LMhnEYhfZOn4mykzWUY+DlxLDODuatw=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=Q+mnHiIz;
	spf=pass (imf18.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774456152; a=rsa-sha256;
	cv=pass;
	b=5w/Fc9+qD3t5SKRgPvBAIwd4gh9NbI+zqiWOKtTD1nHHyifWXP+eYOLxWFvYCQOI+sITe7
	gK0V7la2dOkNk1oTUL1xQTjs4KHPRiFxr2d3p0dbXdzZp1GXMjLyIvRVXmS/rbl37iKlSz
	HAQWXReIwUCh1Q2RI0wwD6oumbcaLe0=
ARC-Seal: i=1; a=rsa-sha256; t=1774456141; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=gRsaQRDiy+FmYqh9n3a7FIuikyYTYiHVKE/k8Esol/HJL4rjLIYnazzlJj1jVkcANeODLSkCuTUMbKV4lSBHZOaExZQ/Acz7m7yNWr4VZ7swOGFoZmkZItumamGVph8m15G+1lLwrVCSQHyeZbLUVonXucG16t0TGzWvPjBIi1o=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1774456141; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=oeL6ks64Ze/pGwHs2qvXBTZpnyzzF7fV/OGrrVTI+fE=; 
	b=PA/AZNbOoW+DkhM8Kn1+rOBNBhG0IZSP546CuAiA5hoCeqGK0FVNEGWHWioMGAnfzCFLOcDnd3qtcIySIMo12EKEy0//lcvnjTVi9SBfEs0PzULSv6vgHK6Iy7mDHfD+UuslwpGy2EtvRVxrm2pYMPjVcFEdGodFaAByOKDR5Z0=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=objecting.org;
	spf=pass  smtp.mailfrom=objecting@objecting.org;
	dmarc=pass header.from=<objecting@objecting.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1774456141;
	s=zmail; d=objecting.org; i=objecting@objecting.org;
	h=Date:Date:From:From:To:To:CC:Subject:Subject:In-Reply-To:References:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To:Cc;
	bh=oeL6ks64Ze/pGwHs2qvXBTZpnyzzF7fV/OGrrVTI+fE=;
	b=Q+mnHiIzlSoEzqFyrU/ucAwSjef8B716hAKKXSG/8GaOq5LOaVbGlQqb/DCllA6l
	rXqv+Wpfk088e4oPy4C2dYI+W3YkqgBHp0wu/luNovyRcvGGIwlRLK9osY8oOSC4nIh
	pYZN27RDo/NKdM5R3sQVQ2mvDid+I5H3RSk55RZI=
Received: by mx.zoho.eu with SMTPS id 1774456138981542.036524592639;
	Wed, 25 Mar 2026 17:28:58 +0100 (CET)
Date: Wed, 25 Mar 2026 15:44:46 +0000
From: Josh Law <objecting@objecting.org>
To: SeongJae Park <sj@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, damon@lists.linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: (sashiko status) [PATCH 0/3] mm/damon/core: small cleanups
User-Agent: Thunderbird for Android
In-Reply-To: <20260325145827.88239-1-sj@kernel.org>
References:  <20260325145827.88239-1-sj@kernel.org>
Message-ID: <645AE1AF-0BA6-47C9-9B53-058F21DDB327@objecting.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-ZohoMailClient: External
X-Rspamd-Queue-Id: 250151C000C
X-Stat-Signature: 8ohpnhbt1dhsnyfirepj1wa9y9sw54op
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774456151-216020
X-HE-Meta: U2FsdGVkX18Q+zzlnT0CvuCCrpgnoTvHdPtKEh34McPY8ZB9L3cgUEvXfIfTvsHY79cjDiKVLHMYLU/BDHLbGmSsZgARNLOnDcw05vowl1m2psFBaf4TX0KPuqAwBaG7C9Lj5S7t23Su+2y7bFKNg9t3c2BXRjKF+068GfgS+xIfn+o3+9stZaf+vF5Mg0dZ/ZIohr4oVpUwJQ+XoJSSYl3r228Zq2nqgYAmykCQ3lqtOJmDm10xCXAurFYm2+xFA2+cRK9JIb4dUJJqDtsOsINvStVD86c3XuJKbXm8zStGGBn5G+nAslb3xfQpPxxQ+gdT17IReq8ofsjVl5KTqq3KemepyAG6LEjXCcOCfrWKdoetyxAuyFBoTIRFbNuvQIordHLGrWiutTeIh6vWlqmJNqMWTDjR7iH+nGUnIFiIvB/9gg1RThEIM4wUonEt9M3pzxe6m8yUGNGN7Cii2nTLDBNdNE2S6lkqi7xjopq8QUsobd74QCXpzjMOb4gXqZ4mIlgHxAKvxwKJ3PYuhGEtpN7rmguGWMFTAnNCYRqXQ5UJ9TSe2J8j1UzmMDeqXFZa8gjiki+9Y2WLuNgdoyUe0oi2YVPB8rul7OuzRXNijdBbuGcHYnm5bHjzI9ZhdroKiQ2PBkcYdBc+GNHmuODb9jX2dCn8vDgJW7Lsn41icHXn0QMyHJQ7FhJ2X60um0aF8OD/VXegJsjYrlvvzdvXH3VEImJdpunOwp6dXfuVPX7SSLsvrK8GjyN7d4szPA4nBkqv/ViMHKzx87pOtkaf4ArDll4ezz60SZZmCpV7KyKboFcsM7vWfSuHcEJY/+V78RAGxJKOJT4bX2YbDuHJ+LJITE4O2ZUzwShzUgC9c0jppaZtREFJC6thqaaBs+/FmDGtTpAhl2PGbuduibCahOvm0gZuA3Dpt1sYQNlfeogphXH6e7WOgW31jUAdQxhOEclms0kxeVIkPJ1
 KC2vpMja
 vHeHBoZI/LhfD+xwHO3m8BXJNShCT5oqItnZyw5W+BP1oyBHmTS8zHWzjEaSb0LLdng74gz03w5JVjer00hAz+JeZJVJ+rzWf2zgiP1WrlWxxS6U/vkkBUykVBHc0xT+utgQ0Sgpa5IP0XHIsqbxYz4Dx4+Fa9t8TGNtPCjSx9szSHRrWTKkzokpzv6kyIGf8Od6H1LBkilOm8zfLdbSr8qSt1PLP1TL9o55w0YRo53tXRi0Ox8hTIAhobzG1WH0IXxIBaBw1Apt34eqYtgeTJQnZaaTAhb29NO860yl4oSkPWmPMboiFpN+tLy9jUhwGk0KrLRonXe+Q33HrXNoYs4beHg7OwV6x8nyz2jDX4GpeAGQDH+EdkoFzwPx8Qet5W5HbNthEFinrigVgUOwIf2OlZ1JshBniRqXgWZV+LBYF34cnsv7OPrUKiFYROxkSrn6JbKMYjImux1lwPOjiz524TGkZD2hv3A34KikTiwYbg9DMnhVtKbcf8Oxx5grL50IsDJQFMwbFLNvwQun8WMGJFICs9My4FpTQZcGvF6gpCpQmOQMrPBhUOV0kGrPhYr+8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 25 March 2026 14:58:26 GMT, SeongJae Park <sj@kernel=2Eorg> wrote:
>Forwarding sashiko=2Edev review status for this thread=2E
>
># review url: https://sashiko=2Edev/#/patchset/20260325073800=2E141756-1-=
objecting@objecting=2Eorg
>
>- [PATCH 1/3] mm/damon/core: deduplicate scheme index lookup into helper
>  - status: Reviewed
>  - review: No issues found=2E
>- [PATCH 2/3] mm/damon/core: use damon_nr_regions() in damon_commit_targe=
t_regions()
>  - status: Reviewed
>  - review: No issues found=2E
>- [PATCH 3/3] mm/damon/core: move last_nr_regions from static local to da=
mon_ctx
>  - status: Reviewed
>  - review: No issues found=2E
>
># hkml [1] generated a draft of this mail=2E  It can be regenerated
># using below command:
>#
>#     hkml patch sashiko_dev --thread_status --for_forwarding \
>#             20260325073800=2E141756-1-objecting@objecting=2Eorg
>#
># [1] https://github=2Ecom/sjp38/hackermail
>
>Sent using hkml (https://github=2Ecom/sjp38/hackermail)



Yay! No regressions

