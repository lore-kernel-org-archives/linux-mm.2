Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F60BCAC5AC
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 03:57:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C0618E0006; Thu, 25 Sep 2025 23:57:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66FAD8E0005; Thu, 25 Sep 2025 23:57:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 537908E0006; Thu, 25 Sep 2025 23:57:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3F16A8E0005
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 23:57:42 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E861759635
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 03:57:41 +0000 (UTC)
X-FDA: 83930042322.16.2BD206C
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf11.hostedemail.com (Postfix) with ESMTP id 112EE40005
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 03:57:38 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	spf=pass (imf11.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758859059;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8HqLw36OmyLrgjjvTQwJc8O5+QaeXrDDPeE4+FPdETo=;
	b=Wwfgwne+AnoF2RxtE3qoziv+S7UQiMTrgNBWp0R0dDOQkOGV57VTI/YjzJun+A+/R4rfpa
	Tye0Bir8564LpI93u9KCKiAHipHYIjiM4cKy8EgwJNm1BrkuOhk8DKRsL1tm71KjKwdI1K
	bukHS1LZqA0g2Ya9lY/3LIFgXOSrPhE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758859060; a=rsa-sha256;
	cv=none;
	b=LgZ/pRpS7od+p7bOtVpgPIopuB3csmW8bQhV2cYke53L484dMvRgX9founZMJsPFR4wsG6
	BoDs49Ph2TRPy/zPFmon+dnj8brueZbyfV+AYPLriuLY8SmL0fwZQQwgyvA29rl7wjBAUB
	tVLlYckg+gBV35wpd2JKQCfUxcPRwgw=
X-UUID: ec7d839e9a8c11f08b9f7d2eb6caa7cf-20250926
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.45,REQID:0795890c-1d60-45cb-8aa1-1148bcb44a20,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:-9,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:1
X-CID-INFO: VERSION:1.1.45,REQID:0795890c-1d60-45cb-8aa1-1148bcb44a20,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:-9,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:1
X-CID-META: VersionHash:6493067,CLOUDID:93546f4e7a14b0b32b9ec93c4b6d0983,BulkI
	D:250922191642HKOKC95Z,BulkQuantity:1,Recheck:0,SF:17|19|24|43|64|66|74|78
	|80|81|82|83|102|841|850,TC:nil,Content:0|50,EDM:-3,IP:-2,URL:0,File:nil,R
	T:nil,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP
	:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_FSI,TF_CID_SPAM_SNR
X-UUID: ec7d839e9a8c11f08b9f7d2eb6caa7cf-20250926
X-User: lienze@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lienze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1975977105; Fri, 26 Sep 2025 11:57:30 +0800
From: Enze Li <lienze@kylinos.cn>
To: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
Cc: <sj@kernel.org>,  <akpm@linux-foundation.org>,  <damon@lists.linux.dev>,
  <linux-mm@kvack.org>,  <enze.li@gmx.com>
Subject: Re: [RFC PATCH 1/2] mm/damon/core: introduce priority concept for
 DAMON
In-Reply-To: <5a9dd164-8dca-4852-a6ab-bab752a37810@huawei-partners.com>
	(Gutierrez Asier's message of "Mon, 22 Sep 2025 14:16:31 +0300")
References: <20250922101022.362822-1-lienze@kylinos.cn>
	<20250922101022.362822-2-lienze@kylinos.cn>
	<5a9dd164-8dca-4852-a6ab-bab752a37810@huawei-partners.com>
Date: Fri, 26 Sep 2025 11:57:27 +0800
Message-ID: <87v7l527dk.fsf@>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 112EE40005
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: bddqrg35wkpho1fqjr4n9jjxfbdudxbr
X-HE-Tag: 1758859058-976705
X-HE-Meta: U2FsdGVkX19wQmAmu8cBgTbGVEkGn/jL7c/S/9YnTyEyj+mnh/1R/WUgjM8PU+RW+ScuyXvK2Xmg0Ccs0fT4/t2t4c8kiFywTQffWvkFDmQgWUKjF1e/JJt2MLLBQFxzQ+8lH9cEC9RS3G/Kh+M3kwQeERj6fVLsX3wQv96j9cZTPyYMJAtioNRPc/v2Eehn80ZUgqIjN8AS1FIqv4xo+BW/MCr78jFMELQluVUnfULVEVOqK2+7P32o5dtg9h9YkHV8LoEb0hb3YhdIlOVvi1pm21g+JzVfuBZ6IhXE7o4FSKkegwuNjYd0zk1JakEJ+iKSsJs1XBq9SisTolqGn6vQU+RxI1ZxXEdvqk7wBgs3pdhY2sFA6pvu/Zg+Q1wnZQ4rCup49X08l416Flts59RrksaFwBKtxqmYRJQPWKsZG3/2hw1ANFlGxhF3kNLuHAKJfEItE2RYC2b4tQDmbQo7rrTcuwahpR6IHG4nLn5UEkxssq065VRIA2WhwcyhyT/p+xmsbW6p+OzZaelF+Bo40DPlWpDEnpLD0vwCgNppHSLYWABn9iyeEPN6D+JAJ3vFZnpAB3dC1CqRvTrOXgV+LjuhDqVwLa7jOUY7o1uUl7bdpu6cNiuf3AhBngemzszHqLW2J55ZtWbS2NvV4d62a8T5tOauDfWU1u8HnJZEFJdka83OITkXUiOXpPa5KKuZU3bzkhsPcM5+TRQvtW9QDK2YT7ZsDyz6FLMY10VtQxDbSnpfHstJ+fhz3/OZra5RGt3QpDoPQ8T7E/cLi7HGEjlZ2L+3mCNXbvjvoTi+AE5zgLPHwoml7ioty/Uty4cjsDXoQHZdctDuOjpoNp23d0Eh9gyxhvbBQ5ltnoO772RV/fD4S3vTaEcprQtH1DzUN4BK9WDclNKjvKbxTX2Hp9NW42orXeLSBxdnla4iUGa0am2UZY60z08agSfJ0l1GHyQ3d5bDCJJS99P
 eA7FBu3L
 XNmdKx8b9EuuWPJ4sf6jxXOM7lvRSXuCDwJ68RX+H2GYC33lCe735QNvfLsgNavJa+7tNbbqN2UUo8+w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Gutierrez,

On Mon, Sep 22 2025 at 02:16:31 PM +0300, Gutierrez Asier wrote:

> Hi,
>
> On 9/22/2025 1:10 PM, Enze Li wrote:
>> This patch introduces a priority-based scheme application mechanism to
>> DAMON, enhancing its ability to prioritize memory management operations
>> for specific processes.  Currently, DAMON applies schemes uniformly
>> across all monitored processes without regard to their relative
>> importance.  This change allows users to assign a priority value to each
>> target process, influencing the frequency with which schemes are applied.
>>=20
>> The core implementation modifies kdamond_apply_schemes to track and apply
>> schemes according to user-defined priorities.  For instance, if process A
>> has priority 50 and process B has priority 30, damon_do_apply_schemes
>> will be called 50 times on A for every 30 times on B.  This ratio
>> ensures that higher-priority processes receive more frequent attention
>> from DAMON's operations, which can be critical for performance-sensitive
>> workloads or prioritized tasks.
>>=20
>> The change maintains the overall fairness and non-starvation properties
>> by cycling through targets proportionally.  Existing behavior is
>> preserved for targets without a priority assigned, ensuring backward
>> compatibility.  This provides system administrators with finer control
>> over how DAMON=E2=80=99s memory optimizations are distributed, making the
>> subsystem more adaptable to varied use cases and performance
>> requirements.
>>=20
>> Signed-off-by: Enze Li <lienze@kylinos.cn>
>> ---
>>  include/linux/damon.h |  2 +
>>  mm/damon/core.c       | 91 ++++++++++++++++++++++++++++++++++++++++++-
>>  2 files changed, 91 insertions(+), 2 deletions(-)
>>=20
>> diff --git a/include/linux/damon.h b/include/linux/damon.h
>> index f13664c62ddd..a6d3ce186fdc 100644
>> --- a/include/linux/damon.h
>> +++ b/include/linux/damon.h
>> @@ -102,6 +102,8 @@ struct damon_target {
>>  	unsigned int nr_regions;
>>  	struct list_head regions_list;
>>  	struct list_head list;
>> +	unsigned int priority;
>> +	struct list_head pr_list;
>>  };
>>=20=20
>>  /**
>> diff --git a/mm/damon/core.c b/mm/damon/core.c
>> index 106ee8b0f2d5..c336914d03cc 100644
>> --- a/mm/damon/core.c
>> +++ b/mm/damon/core.c
>> @@ -15,6 +15,7 @@
>>  #include <linux/slab.h>
>>  #include <linux/string.h>
>>  #include <linux/string_choices.h>
>> +#include <linux/list_sort.h>
>>=20=20
>>  #define CREATE_TRACE_POINTS
>>  #include <trace/events/damon.h>
>> @@ -28,6 +29,11 @@ static DEFINE_MUTEX(damon_lock);
>>  static int nr_running_ctxs;
>>  static bool running_exclusive_ctxs;
>>=20=20
>> +static LIST_HEAD(priority_list);
>> +static bool init_priority_list;
>> +static int priority_level;
>> +static int priority_tick;
>
> What would happen if you have 2 kdamond threads running at the same time?=
=20
> I guess that you will end up a data race in priority_tick.

Currently, DAMON operates with just one kdamond thread.  I'm not certain
about the plans for multi-kdamond support, but I agree that it's a
significant limitation for certain use cases.

>
>> +
>>  static DEFINE_MUTEX(damon_ops_lock);
>>  static struct damon_operations damon_registered_ops[NR_DAMON_OPS];
>>=20=20
>> @@ -474,6 +480,7 @@ struct damon_target *damon_new_target(void)
>>  	t->nr_regions =3D 0;
>>  	INIT_LIST_HEAD(&t->regions_list);
>>  	INIT_LIST_HEAD(&t->list);
>> +	t->priority =3D 0;
>>=20=20
>>  	return t;
>>  }
>> @@ -2154,6 +2161,72 @@ static void damos_adjust_quota(struct damon_ctx *=
c, struct damos *s)
>>  	quota->min_score =3D score;
>>  }
>>=20=20
>> +static int damon_priority_head(void)
>> +{
>> +	struct damon_target *t =3D list_first_entry_or_null(&priority_list,
>> +						struct damon_target, pr_list);
>
> Don't we need to check for a null pointer here?

Oh, good catch!  I totally overlooked that validation.  Thanks for
pointing it out.

>
>> +
>> +	return t->priority;
>> +}
>> +
>> +static int damon_priority_find_next(void)
>> +{
>> +	struct damon_target *t;
>> +
>> +	list_for_each_entry(t, &priority_list, pr_list)
>> +		if (priority_level > t->priority) {
>> +			priority_level =3D t->priority;
>> +			return t->priority;
>> +		}
>> +	return damon_priority_head();
>> +}
>> +
>> +static bool kdamond_targets_priority_enabled(struct damon_ctx *c)
>> +{
>> +	struct damon_target *t;
>> +
>> +	damon_for_each_target(t, c)
>> +		if (t->priority > 0)
>> +			return true;
>> +	return false;
>> +}
>> +
>> +static int damon_priority_cmp(void *priv, const struct list_head *a,
>> +			      const struct list_head *b)
>> +{
>> +	struct damon_target *ta =3D container_of(a, struct damon_target, pr_li=
st);
>> +	struct damon_target *tb =3D container_of(b, struct damon_target, pr_li=
st);
>> +
>> +	if (ta->priority < tb->priority)
>> +		return 1;
>> +	else
>> +		return 0;
>> +}
>> +
>> +static bool kdamond_targets_priority_init(struct damon_ctx *c)
>> +{
>> +	struct damon_target *t;
>> +
>> +	damon_for_each_target(t, c)
>> +		list_add_tail(&t->pr_list, &priority_list);
>> +
>> +	list_for_each_entry(t, &priority_list, pr_list)
>> +		pr_debug("damon target priority %d %p\n", t->priority, t->pid);
>> +
>> +	list_sort(NULL, &priority_list, damon_priority_cmp);
>> +
>> +	list_for_each_entry(t, &priority_list, pr_list)
>> +		pr_debug("damon target priority after sort %d %p\n",
>> +			 t->priority, t->pid);
>> +
>> +	init_priority_list =3D true;
>> +	priority_level =3D damon_priority_head();
>> +	priority_tick =3D priority_level;
>> +	pr_debug("damon target priority init level=3D%d tick=3D%d\n",
>> +		 priority_level, priority_tick);
>> +	return true;
>> +}
>> +
>>  static void kdamond_apply_schemes(struct damon_ctx *c)
>>  {
>>  	struct damon_target *t;
>> @@ -2162,6 +2235,7 @@ static void kdamond_apply_schemes(struct damon_ctx=
 *c)
>>  	unsigned long sample_interval =3D c->attrs.sample_interval ?
>>  		c->attrs.sample_interval : 1;
>>  	bool has_schemes_to_apply =3D false;
>> +	bool priority_enabled =3D false;
>>=20=20
>>  	damon_for_each_scheme(s, c) {
>>  		if (c->passed_sample_intervals < s->next_apply_sis)
>> @@ -2178,10 +2252,23 @@ static void kdamond_apply_schemes(struct damon_c=
tx *c)
>>  	if (!has_schemes_to_apply)
>>  		return;
>>=20=20
>> +	priority_enabled =3D kdamond_targets_priority_enabled(c);
>> +	if (priority_enabled && !init_priority_list)
>> +		kdamond_targets_priority_init(c);
>
> What happens if you later add a new target? priority_list is already
> initialized, which means that list sorting will not take place and it wil=
l=20
> break your logic.

My idea is to keep it user-triggered, following DAMON's general
pattern -- Hmm, just a thought.

>
>> +
>>  	mutex_lock(&c->walk_control_lock);
>>  	damon_for_each_target(t, c) {
>> -		damon_for_each_region_safe(r, next_r, t)
>> -			damon_do_apply_schemes(c, t, r);
>> +		if (priority_enabled =3D=3D false ||
>> +		    (priority_enabled =3D=3D true && t->priority =3D=3D priority_leve=
l &&
>> +		     priority_tick-- > 0)) {
>> +			if (priority_enabled =3D=3D true && priority_tick <=3D 0) {
>> +				priority_level =3D damon_priority_find_next();
>> +				priority_tick =3D priority_level;
>> +			}
>> +			pr_debug("tick() %d(%d)\n", priority_level, priority_tick);
>> +			damon_for_each_region_safe(r, next_r, t)
>> +				damon_do_apply_schemes(c, t, r);
>> +		}
>>  	}
>>=20=20
>>  	damon_for_each_scheme(s, c) {

Thank you for your attention to this patch.  This is a quick
proof-of-concept patch intended to discuss whether the idea has merit.
There might be aspects I have overlooked, and I greatly appreciate you
pointing them out.  It's worth noting that similar functionality might
be achievable through a combination of existing schemes and filters.
Thank you once again for your valuable review.

Best Regards,
Enze

