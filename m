Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD07D109C033
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 16:16:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEA986B0005; Wed, 25 Mar 2026 12:16:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9BE46B0089; Wed, 25 Mar 2026 12:16:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB1F16B008A; Wed, 25 Mar 2026 12:16:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C92B36B0005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 12:16:29 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1859813BF3F
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 16:16:29 +0000 (UTC)
X-FDA: 84585088098.19.FDF34F3
Received: from sender-of-o55.zoho.eu (sender-of-o55.zoho.eu [136.143.169.55])
	by imf25.hostedemail.com (Postfix) with ESMTP id AF4CFA0002
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 16:16:26 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=myZrM+wS;
	spf=pass (imf25.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774455387;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R/nrZmK39p9F4RJ/sZwnZUtTLQN/VBhXeb5KAM1XOdk=;
	b=naA4i0rJpl2w7OBgI6qpkdm6ixQcu8wFqtaHXG2fAHWx1sl6mDZFYo0rSKf6jyT1r8AXS6
	xHAuSfzAKdtjqlOoBztH5lzHtpV7zHj9LDn1eTAcCh1BT559bycK9QYgR3IOOchmbkapvw
	Bg0o70Phxp3JWJ1AkDkSip3bo3tQWWM=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=myZrM+wS;
	spf=pass (imf25.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774455387; a=rsa-sha256;
	cv=pass;
	b=JHGXBD0R7pfGWQEZTz6rDAYtGQ/Ug7SQ34xZddb8tgCoNhtkDnFVEcesuwdmIT+3VrEHfh
	Ckf6/241rorO41RaVnLaNxu0tIKQd5fiiwq1wqpLTzF8aGt/Zf2CamwQNX5htY1mAPpaoE
	Tt3xNycv8ti7U6fu++1IGUcBzCmzaQo=
ARC-Seal: i=1; a=rsa-sha256; t=1774455372; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=Q0mvmx/M/1A/VcQ7qnjKeX7/KR44YhnIrgtDDcTGj3Eawk6qZnldXUPMiolA+2/aJkh0xPqeo70lNX6IvvYVn8flUG53DLynQPszsSO7KhMKH8eUgm4hPcAqEVRn+UgSexg2dFf/snONwQN73Npbw9w8dBaxLrlfAv+mDZiH6h8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1774455372; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=R/nrZmK39p9F4RJ/sZwnZUtTLQN/VBhXeb5KAM1XOdk=; 
	b=ecf1h9vVR/5HP7w1L4rJ6kJvF0JZt4m+Ko7Z/gQhn8cWue7DQ/a/JrV+jJzw9G963hKmz0ZeslDDg8X6leq2ZkCfhuhqWedByKb1uM05on4s6xcBnEE59GNsKvjRaeMqN+cihhR6ZNM88Ai5EWP0jTQCBEyJrGU2t5QU2LXEGww=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=objecting.org;
	spf=pass  smtp.mailfrom=objecting@objecting.org;
	dmarc=pass header.from=<objecting@objecting.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1774455372;
	s=zmail; d=objecting.org; i=objecting@objecting.org;
	h=Date:Date:From:From:To:To:CC:Subject:Subject:In-Reply-To:References:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To:Cc;
	bh=R/nrZmK39p9F4RJ/sZwnZUtTLQN/VBhXeb5KAM1XOdk=;
	b=myZrM+wSJDOyKO8ul1y9lOZHFxcxyxelho03uA0iaUZRIFnYmAbhPyF35JXuHl+c
	S+myA8wDFF47TI89FiIJkogAnqj9xpWaEQNbb+rhHuxCQwM71+nvuPP3OCEDvNPBoLz
	PsKCGN+IxP3kIU//e3wTxSpE8fUN4K2qm7T8LIes=
Received: by mx.zoho.eu with SMTPS id 1774455368916960.7489889559625;
	Wed, 25 Mar 2026 17:16:08 +0100 (CET)
Date: Wed, 25 Mar 2026 15:44:56 +0000
From: Josh Law <objecting@objecting.org>
To: SeongJae Park <sj@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, damon@lists.linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_=28sashiko_review=29_=5BPATCH=5D_mm/damon/core=3A_?=
 =?US-ASCII?Q?validate_goal_nid_before_accessing_node_data?=
User-Agent: Thunderbird for Android
In-Reply-To: <20260325150411.88357-1-sj@kernel.org>
References:  <20260325150411.88357-1-sj@kernel.org>
Message-ID: <EC4DB612-96E6-4BF3-8F46-BEB18FC488D0@objecting.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-ZohoMailClient: External
X-Rspam-User: 
X-Rspamd-Queue-Id: AF4CFA0002
X-Stat-Signature: 1aysycdwa6g8zitwnqh7bocwy58xh6dd
X-Rspamd-Server: rspam06
X-HE-Tag: 1774455386-521164
X-HE-Meta: U2FsdGVkX189vXY+hT9gJIZiN8lsrUX7sUxst2tpp7Advn8KbNuq2UJbDo9KKxqIanP9faTvLAWehf98NmGJDZUH9WHlqQxplxBlPrW7Qw+vFocfAZ2Yhz65siNo/jNM9OwNSGvLyqWLHNGXgxxN28Xdfl6Kwl3mvaRtJ3GkhWA32hwMXMV3C0TEBewAYrLqVASIkHBpcXIE1sdVTO9Gx/mzl5+BDOIv+MKoVgFCvu6ZfO5hoELZDLkZcaMTER/sw4WCGiX+eotYjVcgDFOgsfsGrXLkoX1w9SUNpCYUxXImjzXowfTvnt9NaW+W79iOU56Xn+GqQ4aN2B1Gec1v+VYdieqFm1/AI/wYsUEd2AqwXqY9zcl0zLwhWNoA+l8PgW0mIthYkwit8dqgC66Xqxvg14RYM9m8vumKwQYXrB7x4SddtvAYg2oB6d1A76wHHgyfqh3wleaQJxrIDKZTYkSLbwzyqDsZCzy3brijl4Q75HEekDyKqTGEQ6v8UTKKBe2dUdDw4FZMbaLU3++SXzDLXE2rVA/gH8f3Npl5QNbOcpjCXrvs8HFomHTm1VXwBFEosVB425FtNwhGMxkn3ICpHer71ftOiUpiJ1pL2OPxpCbP48Tamejcnv7XNpHqJE64Kat3tTw1tz9qzEr1jBT0XTyiGJNuUh23WAhSeCbnRKpb/PWUAA0pZI5WO1k+wTyJxl2KlCijuCpIuv1pA7q4DMyQUWPv6FEgosvMtHFEJYnRGEm07ah2laMthfcPmFrq5nk7cyBm2szN9fmKL0O7Bh+Iu5sIYWyPe04+v2caxtOnaFY8JJoltWkkxExiT3eDE+u4wRxhjivEDADOcu/7tmzXthVNoNveqaocdAhafEqUxVf4gA1ypx0AqFPGCcN5ynz6Dadh4bZ0xScJH4YXaViBzs9ePGvGp0wOLnw/5a3LvEZ+KGiZKdXFJIjjo2JGalTLg7tUAN8cgBj
 kyW40aXa
 Ljg5ZdAdK8bPKG7Z5S4v4atx67NqsPL7FXMk3xxoxwsY+2qsIERD7d4cPFtjOUonVwN8H13zYdykNm3BdvC5t+ifen3AAmDd00QrzC3x8suQJ5za1AuqHabNi49htEUPZAj/0VPwYr4YQJqoznZ3d4K+PMm/Ch5daxcNJoPtDDkxbrwi8uShNTbP0dMcq0FjdAdRWwQo9VlLyD3k2lfNNhWxq0oACvRtmPGhjo2YR47MjOIZiRDHxMWntEW5D2n/Ea15eP6MD0yom5BGgrELcZZToPPXob/r60B9UG7Om9q7wWyooTRR081ZkP98gYeCehOLBR8FhZ5l23VVh/MagxTs3zl4psWnCio1mTa1r5Ftff5c3B1lS0zBp61LkgDPiLIjNV8Xlr8HTJgi0ENVEgzBdep6XKqt90VyZhqmERZAKlUSwaHknXvcX6V+dkmI4eBSTWQqKu56SmEYYlSb08Wm7Nasxym6W0iXTCFVZSOBachbkURHXZ5DE6d85NZig+5uR2YMjApSQL7yzYN+W+FeP/uXQ+wcOr40qhVVzzY3peOMLK2rJLLR1H6ONiDEAnZpAKmTsTleojrSTP1VFgJ+Rbxtr+OpN2Y55
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 25 March 2026 15:04:10 GMT, SeongJae Park <sj@kernel=2Eorg> wrote:
>On Wed, 25 Mar 2026 07:37:39 -0700 SeongJae Park <sj@kernel=2Eorg> wrote:
>
>> Forwarding Sashiko review for doing discussions via mails=2E
>>=20
>> # review url: https://sashiko=2Edev/#/patchset/20260325073034=2E140353-=
1-objecting@objecting=2Eorg
>> # start of sashiko=2Edev inline review
>> commit 7e17cbe1dc95a0cd1a1410be38ab6964f78fb15c
>> Author: Josh Law <objecting@objecting=2Eorg>
>>=20
>> mm/damon/core: validate goal nid before accessing node data
>>=20
>> This commit adds bounds checking and node_online() validation for the
>> goal->nid in the DAMON quota metrics=2E It prevents out-of-bounds acces=
ses
>> to NODE_DATA() when an invalid or offline NUMA node is provided by user=
space=2E
>>=20
>> > diff --git a/mm/damon/core=2Ec b/mm/damon/core=2Ec
>> > index db6c67e52d2b=2E=2E81ce27baa1a1 100644
>> > --- a/mm/damon/core=2Ec
>> > +++ b/mm/damon/core=2Ec
>> > @@ -2245,6 +2245,10 @@ static __kernel_ulong_t damos_get_node_mem_bp(
>> >  	struct sysinfo i;
>> >  	__kernel_ulong_t numerator;
>> > =20
>> > +	if (goal->nid < 0 || goal->nid >=3D MAX_NUMNODES ||
>> > +	    !node_online(goal->nid))
>> > +		return 0;
>> > +
>> >  	si_meminfo_node(&i, goal->nid);
>> >  	if (goal->metric =3D=3D DAMOS_QUOTA_NODE_MEM_USED_BP)
>> >  		numerator =3D i=2Etotalram - i=2Efreeram;
>> >  	else	/* DAMOS_QUOTA_NODE_MEM_FREE_BP */
>> >  		numerator =3D i=2Efreeram;
>> >  	return mult_frac(numerator, 10000, i=2Etotalram);
>>=20
>> Could this cause a division by zero if the node is online but memoryles=
s?
>>=20
>> For CPU-only compute nodes or nodes where all memory has been hot-remov=
ed,
>> node_online(goal->nid) will evaluate to true=2E When si_meminfo_node() =
is
>> called for these memoryless nodes, it populates the sysinfo struct with
>> i=2Etotalram =3D 0=2E
>>=20
>> The mult_frac() macro unconditionally performs integer division and mod=
ulo
>> by the third argument, which could trigger a kernel panic when dividing=
 by
>> zero=2E
>>=20
>> Would it be safer to check if i=2Etotalram is zero before returning, or=
 use
>> node_state(goal->nid, N_MEMORY) instead of node_online()?
>>=20
>> [ =2E=2E=2E ]
>>=20
>> > @@ -2261,6 +2265,10 @@ static unsigned long damos_get_node_memcg_used=
_bp(
>> >  	unsigned long used_pages, numerator;
>> >  	struct sysinfo i;
>> > =20
>> > +	if (goal->nid < 0 || goal->nid >=3D MAX_NUMNODES ||
>> > +	    !node_online(goal->nid))
>> > +		return 0;
>> > +
>> >  	memcg =3D mem_cgroup_get_from_id(goal->memcg_id);
>>=20
>> The same division by zero risk exists here when mult_frac() is called a=
t the
>> end of this function=2E
>
>I think sashiko's comments make sense=2E  I also suggested using
>node_state(N_MEMORY)=2E  What do you think, Josh?
>
>
>Thanks,
>SJ
>
>[=2E=2E=2E]


Yep, will do

