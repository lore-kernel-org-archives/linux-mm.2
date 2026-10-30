Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00119606A320
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 06:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=t0v8f46z
Received: by kanga.kvack.org (Postfix)
	id 5F3016B05B2; Fri, 30 Oct 2026 02:06:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A3986B05B3; Fri, 30 Oct 2026 02:06:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B9736B05B4; Fri, 30 Oct 2026 02:06:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2A5BB6B05B2
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 02:06:14 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9833B1C3E4E
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 06:06:13 +0000 (UTC)
X-FDA: 85378257426.30.E2D9931
Received: from mta1.migadu.com (out-213.mta1.migadu.com [95.215.58.213])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6E88080006
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 06:06:11 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=t0v8f46z;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.213 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793340371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fbxoQX/plT7MQ1IcvaeIBbt38pbNjazi3Wk4GqeaYLY=;
	b=VhgCKVFgxNpA0tcRipvkTPOvL1dRoHqOKe9IpoejjtkyK18TSKQIR15TTVu6364ZGDYM7K
	VYOlkJlllEP2K5eYvzY+c2DgapD3YWrkEMLn/lTiGdnZSzvLWJB5wu7dHTnJCqhWU9pKb5
	Vo3DBsxCATnd0jVKtnRnIXsz0MxdE7w=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=t0v8f46z;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.213 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793340371;
	b=dtkTL8PvghFvWN6H+bxuZLl+jTk77hTWSiO6qak9v4hoJjv/zzJyM6+ndO58NM2fmazY8F
	sHPO++4A3rnsDflTgrehGV6tXjtO0RNxK3J0gPCaYsRMmW6M4SKk77R08a3GASk9q/xlsz
	/u+ddXa/IIQQEsUcBzeU0nrsjcMtHKE=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=WkTwqX/0WclNwP9VVkIpT9VytTtOvvnnIOTZf6eqCbs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793340370; v=1; x=1793945170;
 b=t0v8f46z1mKbxTItQepNAtSI47ayWXEAaP+PY8lg8jqxIdr7G3U6RsRtPH6ssB50JfFIw5k2
 Ss7W+Z/NZVb/M4I1vsFrjo4MvRdV2OmuHSK3QQJR45zylFcAnH3PInz9gORBiBQwN7YOUkO5hiO
 d73EuxQdrK+sDU6Vfg+KsyBg=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 70b245d929eee882;
	Fri, 30 Oct 2026 06:06:10 +0000
X-Mizu-Trace-ID: 70b245d929eee882
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (1.0)
Subject: Re: [RFC PATCH 0/3] mm, memcg: isolate deprecated v1 state from struct mem_cgroup
From: Roman Gushchin <roman.gushchin@linux.dev>
In-Reply-To: <b36ab4a7-b692-49e8-92b5-1dc4d76dee00@linux.dev>
Date: Thu, 29 Oct 2026 23:05:53 -0700
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.com>,
 Shakeel Butt <shakeel.butt@linux.dev>, muchun.song@linux.dev,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Tao Cui <cuitao@kylinos.cn>, cui.tao@linux.dev
Message-Id: <0BEF7489-16EC-44EE-847B-A6AA380BE11F@linux.dev>
References: <b36ab4a7-b692-49e8-92b5-1dc4d76dee00@linux.dev>
To: Tao Cui <cui.tao@linux.dev>
X-Mailer: iPad Mail (23G90)
X-Rspamd-Queue-Id: 6E88080006
X-Stat-Signature: xjhohaaks7rc7zzzayufkp4nsfhppdun
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793340371-478867
X-HE-Meta: U2FsdGVkX1/FJ5VoTsFnLZNVcpflKxvrHRMiybENr+YTfui28J3NziTbTbZgkm0setJ/xrIYxMDIXoU5vyUTkhV2iv8nT1dJB2avyTvXtuZTuMNJMsQlgkGY08uWPT5MvA0JYtSviXWFvsQARUrqwFtq44/cho1Py5Kvr5S928cIowsZdKgrso+Lt5jWB64AsDdIdZpht3bwZIrVsPVQyIG+pZmhFey2dCgor++9iZ4BIOQ8UCEqD+mwvswXzzZLMA/LAml65ArbMW7IvltljzNnVfXkoRmvF3J28Pm5khHzk/AfhxAGlot7u++g4qdg2sCoeqdy5FeyubknYXOw1ka2vwqJ4FC2hW7c0HYHQYVdV3ikDyTl75F1tj/ndfJRFh0R0EiwCHvPsLilx85JVr0vy+C/JG/T60fUrayIBd1bgeuCG/zEQh4qHXw4pPHUYzgej79F9cg0Qd5quojG0r02RxgZCx/BiCT3u2UcLaY+2yljD05eOwB31+6V0SQGKfXS0Tp51x11inOv5cFmRM4cYnK+iqwPvfGgfHoE4+0Rr+OmqBy1A6fYamLaqIMY+YPARp2XKnOBZsJRYhcI2FpEoWMjca7ndtguPqfmMG/LLdFL9OZy4H5jwCRKOQ+7TqKPr/LQmDfcFkIDI/g90elkqDT+Uxy7jDpNvBd5/sv/cMnT7OGf5bbBwQa0c7yKY5ktCfuH/7FAGsTPzVIIK29a2NIbifNWiOQMbXUkJiT6BcFAV7T2JQUTu5AsgAelqXoBnSGkNwUyQ3Uwa/1C8Q394Hb0bWyj1lsURR3GxV889eiJwrF5HE7BTDfAigmJaWMsklJAeNns3gvZfldDcZ1gzyJCcT+VYmRKdRNoWAWBQkybC26ubPjfZ63eyRHd4UNH/aIIWuFS15rle6vr2jOPlsOomPRiG5hJ7+7hf8asHzs0KKgSZvCl//Pi9NUUfBE+LokzgZRM30CKaYZ
 yQ8tKFH0
 2iW6DIofvy9vem10k9UlwJBi1qh2dKZJ4OHFe6zk6wkijNwy7gKgIV8sLdCHVlnTHTpjDZfHk/Vyo2EgDeuBTRahsCvAflwQ9MSTp5AP9oapaM48uhjhY5oDIe5J9HMHVI/2uK11lrn9phzw4bc7sKCsWhLtZR95T7Kn0szNah9mURScMHvaLfUGgKpAwD/amKmVhjybURt18WsuajrGZaTydM8PH30GyptocaY/AnfrzYrY+hVxSY2dAhTrtZNEmNmJcv3kvbvxqQaSfN2b+OEAZedb6lLqeNLcrzkqXcR/nQLeNP+z2X9LVB2/esmOlW08/Dc6eo8tyUzFdrDWmXKTUGb27cZaImWHotDAejGRUynpvFusyb+7sqw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

I believe we want to delete this code sooner than later, why would we rewrit=
e it before that?

> On Oct 29, 2026, at 10:40=E2=80=AFPM, Tao Cui <cui.tao@linux.dev> wrote:
>=20
> =EF=BB=BFHi Johannes, Shakeel, Michal,
>=20
>> =E5=9C=A8 2026/9/19 00:24, Johannes Weiner =E5=86=99=E9=81=93:
>>> On Fri, Sep 18, 2026 at 11:41:09AM +0200, Michal Hocko wrote:
>>> On Thu 17-09-26 13:26:40, Shakeel Butt wrote:
>>>> On Wed, Sep 16, 2026 at 08:57:34PM +0800, Tao Cui wrote:
>>>>> From: Tao Cui <cuitao@kylinos.cn>
>>>>>=20
>>>>> The legacy cgroup v1 memory controller has already been moved out of
>>>>> the shared implementation at the file level (mm/memcontrol-v1.c) and a=
t
>>>>> the Kconfig level (CONFIG_MEMCG_V1, default n since 6.11).  Its
>>>>> per-cgroup state, however, still sits as individual members inside
>>>>> struct mem_cgroup, guarded by #ifdefs.
>>>>>=20
>>>>> This series isolates the deprecated implementation from the shared hot=

>>>>> structure: all v1-only members are grouped into a dedicated
>>>>> struct mem_cgroup_v1, and every access goes through memcg->v1.X.
>>>>>=20
>>>>> With this in place the v1 implementation is self-contained: its
>>>>> interface in mm/memcontrol-v1.c, its state in struct mem_cgroup_v1, an=
d
>>>>> its eventual removal becomes a localized deletion of this struct
>>>>> together with mm/memcontrol-v1.c, instead of unwinding
>>>>> ifdef-scattered members across the shared header.
>>>>=20
>>>> Sorry I don't see any benefit of this code churn. The code is already b=
ehind
>>>> config. What exactly this code churn is giving us?
>>>=20
>>> The only arguable upside is that this would make it ever so slightly
>>> easier to track v1 specific stuff (once that s@v1@memcg1@ or similar).
>>=20
>> I had the same thought. It's kiiind of nice to see which members are
>> completely specific to memcg1.
>>=20
>>> I am not convinced this is sufficient to justify the churn either.
>>=20
>> IMO it helps that it's mostly in memcontrol-v1.c where the chances of
>> interfering with other work are pretty slim.
>>=20
>> The patch 1 + patch 2 split is a bit bothersome: indenting everything
>> into a union, only to then move it out in the next patch.
>>=20
>> Tao, if you folded these two patches to make it one clean extraction
>> and changed over the sites at the same time, I would probably lean
>> supportive on this.
>=20
> Sorry for the late reply.
>=20
> Thanks for the feedback.  Looking back, I think Johannes' point about
> the patch split is fair.  I split the first two patches to keep the
> initial step semantically neutral, but it also made the series look
> like churn for the sake of churn.
>=20
> I'll fold the first two patches into a single extraction in the next
> revision.  That should present the change more directly and hopefully
> make it easier to judge whether the resulting boundary is worthwhile.
>=20
> Thanks,
> Tao
>=20
>=20

