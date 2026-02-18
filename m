Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21C13E9A02C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 15:08:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B6A56B0088; Wed, 18 Feb 2026 10:08:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 239FD6B0089; Wed, 18 Feb 2026 10:08:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F20A6B008A; Wed, 18 Feb 2026 10:08:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EEB5C6B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 10:08:32 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7443AC095D
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 15:08:32 +0000 (UTC)
X-FDA: 84457908864.09.07A02E4
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0D3BE80012
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 15:08:29 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.com header.s=susede1 header.b=gldyKQL6;
	dkim=pass header.d=suse.com header.s=susede1 header.b=gldyKQL6;
	spf=pass (imf02.hostedemail.com: domain of petr.pavlu@suse.com designates 195.135.223.131 as permitted sender) smtp.mailfrom=petr.pavlu@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771427310;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5lyt323+HbZYpoX64Rl3vcxfunKzUx7dWbFHruMcR5o=;
	b=JJk3JKyyxEEzsLtMy8ZUbEgrSmu+5No4GZK2NqmUbgwgRy7okJeoVVo1iGZpsrZ6jxEQnB
	8Uo8hlgckGfpzmgV7Ohfw3oMqxZjSA06fA4xjrQfxYtlZqAJF5RN7CqPMSz/1QM8bOMaVP
	d1rU+B3LKNXh5LqLn0bkMjI4mnS7IYY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771427310; a=rsa-sha256;
	cv=none;
	b=1BujZSF+RLWEf0McVtwYVWbcpsAO6BgeR+cho79sXbW+axhDrJmKI4w+Th1Uo92pinBsZZ
	RorvVdYi4pPRBdEyfjzpDJT7dl/43KpSxFsRc19ZAcjrukmTLAKMaPYniT/DZ/A5Syvu6C
	RbE+SLMnAks2jKztuUsnGuK3LhajL4g=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.com header.s=susede1 header.b=gldyKQL6;
	dkim=pass header.d=suse.com header.s=susede1 header.b=gldyKQL6;
	spf=pass (imf02.hostedemail.com: domain of petr.pavlu@suse.com designates 195.135.223.131 as permitted sender) smtp.mailfrom=petr.pavlu@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3458E5BD1E;
	Wed, 18 Feb 2026 15:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1771427308; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5lyt323+HbZYpoX64Rl3vcxfunKzUx7dWbFHruMcR5o=;
	b=gldyKQL6ACDQdncmwMAad+Z99WShbTJgDNbsPhcbC0DQiA3KedeIyVic93hD8vv78dtV5k
	mpXWOEOKQDyHkeA1GRi52v9RwnG2zVxhkBv7o7JMU+8dwRIwmS7XltK2XFgm+L7TqcdAoi
	1nUoIbVbEo1ghf+4y8+Ad7p6+tMf3RI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1771427308; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5lyt323+HbZYpoX64Rl3vcxfunKzUx7dWbFHruMcR5o=;
	b=gldyKQL6ACDQdncmwMAad+Z99WShbTJgDNbsPhcbC0DQiA3KedeIyVic93hD8vv78dtV5k
	mpXWOEOKQDyHkeA1GRi52v9RwnG2zVxhkBv7o7JMU+8dwRIwmS7XltK2XFgm+L7TqcdAoi
	1nUoIbVbEo1ghf+4y8+Ad7p6+tMf3RI=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8B3DA3EA65;
	Wed, 18 Feb 2026 15:08:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4AnNIevVlWkRRwAAD6G6ig
	(envelope-from <petr.pavlu@suse.com>); Wed, 18 Feb 2026 15:08:27 +0000
Message-ID: <7765df86-b08a-4f70-900d-4b4d85c07d49@suse.com>
Date: Wed, 18 Feb 2026 16:08:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 34/42] dept: add module support for struct
 dept_event_site and dept_event_site_dep
To: Byungchul Park <byungchul@sk.com>
Cc: kernel_team@skhynix.com, torvalds@linux-foundation.org,
 damien.lemoal@opensource.wdc.com, linux-ide@vger.kernel.org,
 adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org, mingo@redhat.com,
 peterz@infradead.org, will@kernel.org, tglx@linutronix.de,
 rostedt@goodmis.org, joel@joelfernandes.org, sashal@kernel.org,
 daniel.vetter@ffwll.ch, duyuyang@gmail.com, johannes.berg@intel.com,
 tj@kernel.org, tytso@mit.edu, willy@infradead.org, david@fromorbit.com,
 amir73il@gmail.com, gregkh@linuxfoundation.org, kernel-team@lge.com,
 linux-mm@kvack.org, akpm@linux-foundation.org, mhocko@kernel.org,
 minchan@kernel.org, hannes@cmpxchg.org, vdavydov.dev@gmail.com,
 sj@kernel.org, jglisse@redhat.com, dennis@kernel.org, cl@linux.com,
 penberg@kernel.org, rientjes@google.com, vbabka@suse.cz, ngupta@vflare.org,
 linux-block@vger.kernel.org, josef@toxicpanda.com,
 linux-fsdevel@vger.kernel.org, jack@suse.cz, jlayton@kernel.org,
 dan.j.williams@intel.com, hch@infradead.org, djwong@kernel.org,
 dri-devel@lists.freedesktop.org, rodrigosiqueiramelo@gmail.com,
 melissa.srw@gmail.com, hamohammed.sa@gmail.com, harry.yoo@oracle.com,
 chris.p.wilson@intel.com, gwan-gyeong.mun@intel.com,
 max.byungchul.park@gmail.com, boqun.feng@gmail.com, longman@redhat.com,
 yunseong.kim@ericsson.com, ysk@kzalloc.com, yeoreum.yun@arm.com,
 netdev@vger.kernel.org, matthew.brost@intel.com, her0gyugyu@gmail.com,
 corbet@lwn.net, catalin.marinas@arm.com, bp@alien8.de, x86@kernel.org,
 hpa@zytor.com, luto@kernel.org, sumit.semwal@linaro.org,
 gustavo@padovan.org, christian.koenig@amd.com, andi.shyti@kernel.org,
 arnd@arndb.de, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 rppt@kernel.org, surenb@google.com, mcgrof@kernel.org, da.gomez@kernel.org,
 samitolvanen@google.com, paulmck@kernel.org, frederic@kernel.org,
 neeraj.upadhyay@kernel.org, joelagnelf@nvidia.com, josh@joshtriplett.org,
 urezki@gmail.com, mathieu.desnoyers@efficios.com, jiangshanlai@gmail.com,
 qiang.zhang@linux.dev, juri.lelli@redhat.com, vincent.guittot@linaro.org,
 dietmar.eggemann@arm.com, bsegall@google.com, mgorman@suse.de,
 vschneid@redhat.com, chuck.lever@oracle.com, neil@brown.name,
 okorniev@redhat.com, Dai.Ngo@oracle.com, tom@talpey.com, trondmy@kernel.org,
 anna@kernel.org, kees@kernel.org, bigeasy@linutronix.de,
 clrkwllms@kernel.org, mark.rutland@arm.com, ada.coupriediaz@arm.com,
 kristina.martsenko@arm.com, wangkefeng.wang@huawei.com, broonie@kernel.org,
 kevin.brodsky@arm.com, dwmw@amazon.co.uk, shakeel.butt@linux.dev,
 ast@kernel.org, ziy@nvidia.com, yuzhao@google.com,
 baolin.wang@linux.alibaba.com, usamaarif642@gmail.com,
 joel.granados@kernel.org, richard.weiyang@gmail.com,
 geert+renesas@glider.be, tim.c.chen@linux.intel.com, linux@treblig.org,
 alexander.shishkin@linux.intel.com, lillian@star-ark.net,
 chenhuacai@kernel.org, francesco@valla.it, guoweikang.kernel@gmail.com,
 link@vivo.com, jpoimboe@kernel.org, masahiroy@kernel.org,
 brauner@kernel.org, thomas.weissschuh@linutronix.de, oleg@redhat.com,
 mjguzik@gmail.com, andrii@kernel.org, wangfushuai@baidu.com,
 linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
 linux-i2c@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-modules@vger.kernel.org, rcu@vger.kernel.org,
 linux-nfs@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 2407018371@qq.com, dakr@kernel.org, miguel.ojeda.sandonis@gmail.com,
 neilb@ownmail.net, bagasdotme@gmail.com, wsa+renesas@sang-engineering.com,
 dave.hansen@intel.com, geert@linux-m68k.org, ojeda@kernel.org,
 alex.gaynor@gmail.com, gary@garyguo.net, bjorn3_gh@protonmail.com,
 lossin@kernel.org, a.hindborg@kernel.org, aliceryhl@google.com,
 tmgross@umich.edu, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20251205071855.72743-1-byungchul@sk.com>
 <20251205071855.72743-35-byungchul@sk.com>
 <7afb6666-43b6-4d17-b875-e585c7a5ac99@suse.com>
 <20260213055006.GA55430@system.software.com>
Content-Language: en-US
From: Petr Pavlu <petr.pavlu@suse.com>
In-Reply-To: <20260213055006.GA55430@system.software.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspam-User: 
X-Stat-Signature: x7z4b4focw67q59a3hegyzrcttabkp9i
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0D3BE80012
X-HE-Tag: 1771427309-793222
X-HE-Meta: U2FsdGVkX1+nanBfS66Kul82r0HBkwG6EN84344aUvZw9mmI23EaDrAibeJOQlnE5FeEszBGOQccSacgRG7GWu3wViuDE+ET/s3F5CPvmNOzMfdfOebeLL3ioQPiY9stgNpAdTNlF4qZN3X1obtpESz1lr+WwZ4w7VfeldT/xeYopYGlgCTNAS6ABZ+OIjCs00/8qqGxtoC+c6p3IeaS6oRFOEX9iFPZs6lNsfc5cOc/vvAKeDp+3NJ7+xzpm7/7oaRrUzK+FUYtZIYCDnkWRZjdOQs3NBEiWybeCda3IR/xzGy+rUJJbh5cN9IbLAL62WeAdpUQtxmLKuYMIzNowVSTM/+GVMU2DxJxfa3GPkiLKoUX6ET3c60tzM/Ps55Hz/eJYrch8qCLKMM7Soh2D8lw5UGRXQhnkbdWmc8TjYes18dG7UmyReH/onRaQtJCN5NgDYaM8MYEyhODFDXObpm3k3yid7KYMW2vqkPdgNMAkYhzsZhSPa/UjuOddRzYd26HLJdWuPZiLdnybfsFMysVAh+XftyQNVbU14+MxVWsJa9MO9gIpQHsrtyMR58RHxkiQ9FN7hwLWLYKm4HRFXnD8OqhnSdz6eQSAyOPSfOlZGIJx4sKjuhLnfJyBMbM87qGgHeR3ng9trBSePsGp41KTWVObvDkXAiZp6ptJUq0jmA2VNM1nOCbwxm+Go3Z1TGOGVqNDLhTyHFjFGC+eM2waC2wR5K7dno2TpezU7Sv287x8TxmhbjmluIkucScF5r7efF1QHrOlOqmis2pOrZKYdm4lKyE6jJS9n5LBO/2Eh3EP9GOGODLPg6acAIVin809BdriOmjjM0pyNDXIfaFo9s7N+8EtSRtauaWmOEn4AAokdQCQZ48IAa22oABmBOCzBqmxV9dyQHG0zprFTkpnrhkfGKpKZ8IveDnutYKkmaQisD4vHLY3CO82HmRoLPnvh08OZ9NWENOsdH
 rxRfCCUw
 A/rU4gZTF6OE/zWzl5Xg/EEezWppwPOWWBhxkkpZAZbvA8Uef+ydAYEgqOyvR9jBhL75jP0N7LOOnMIMCXE1QD2K43f0N50sagDQX7cIMwEF59uzGT1sTtslqcHFwM7359A4tUqQ/Xpv7xZPsgyYdyhqYD7wH1FSgVWT3oaJadB7J0rCsE13TrV09aitVvMgXyy2WnCf+9TZDAYG7cwBtwYkAL9Wgw6s8vVAwDticDdx2BM4LCnygwMrSe2A9dLaPle0iMH22Y4tDk0rSn5ARDlJ/SECHIU8EeSFv9i1XKDpdKuvTmEQz0RZIuxeEwb3JGfgk9DyDImbLKlCpsolOq6xn7044mhDVFDIbTdNSqIPerHiiDGOZyp/jGbvbZ9mz9FLgok3LxXqYGtLhHhczTOYuJTQVv4h9nY12o9urFc6vdOpjGFghYC0g9ECrh+zAxfQliRsasdbFYXnm8sLBbvZgXg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/13/26 6:50 AM, Byungchul Park wrote:
> On Wed, Jan 07, 2026 at 01:19:00PM +0100, Petr Pavlu wrote:
>> On 12/5/25 8:18 AM, Byungchul Park wrote:
>>> struct dept_event_site and struct dept_event_site_dep have been
>>> introduced to track dependencies between multi event sites for a single
>>> wait, that will be loaded to data segment.  Plus, a custom section,
>>> '.dept.event_sites', also has been introduced to keep pointers to the
>>> objects to make sure all the event sites defined exist in code.
>>>
>>> dept should work with the section and segment of module.  Add the
>>> support to handle the section and segment properly whenever modules are
>>> loaded and unloaded.
>>>
>>> Signed-off-by: Byungchul Park <byungchul@sk.com>
>>
>> Below are a few comments from the module loader perspective.
> 
> Sorry about the late reply.  I've been going through some major life
> changes lately. :(
> 
> Thank you sooooo~ much for your helpful feedback.  I will leave my
> opinion below.
> 
[...]
>>> diff --git a/kernel/dependency/dept.c b/kernel/dependency/dept.c
>>> index b14400c4f83b..07d883579269 100644
>>> --- a/kernel/dependency/dept.c
>>> +++ b/kernel/dependency/dept.c
>>> @@ -984,6 +984,9 @@ static void bfs(void *root, struct bfs_ops *ops, void *in, void **out)
>>>   * event sites.
>>>   */
>>>
>>> +static LIST_HEAD(dept_event_sites);
>>> +static LIST_HEAD(dept_event_site_deps);
>>> +
>>>  /*
>>>   * Print all events in the circle.
>>>   */
>>> @@ -2043,6 +2046,33 @@ static void del_dep_rcu(struct rcu_head *rh)
>>>       preempt_enable();
>>>  }
>>>
>>> +/*
>>> + * NOTE: Must be called with dept_lock held.
>>> + */
>>> +static void disconnect_event_site_dep(struct dept_event_site_dep *esd)
>>> +{
>>> +     list_del_rcu(&esd->dep_node);
>>> +     list_del_rcu(&esd->dep_rev_node);
>>> +}
>>> +
>>> +/*
>>> + * NOTE: Must be called with dept_lock held.
>>> + */
>>> +static void disconnect_event_site(struct dept_event_site *es)
>>> +{
>>> +     struct dept_event_site_dep *esd, *next_esd;
>>> +
>>> +     list_for_each_entry_safe(esd, next_esd, &es->dep_head, dep_node) {
>>> +             list_del_rcu(&esd->dep_node);
>>> +             list_del_rcu(&esd->dep_rev_node);
>>> +     }
>>> +
>>> +     list_for_each_entry_safe(esd, next_esd, &es->dep_rev_head, dep_rev_node) {
>>> +             list_del_rcu(&esd->dep_node);
>>> +             list_del_rcu(&esd->dep_rev_node);
>>> +     }
>>> +}
>>> +
>>>  /*
>>>   * NOTE: Must be called with dept_lock held.
>>>   */
>>> @@ -2384,6 +2414,8 @@ void dept_free_range(void *start, unsigned int sz)
>>>  {
>>>       struct dept_task *dt = dept_task();
>>>       struct dept_class *c, *n;
>>> +     struct dept_event_site_dep *esd, *next_esd;
>>> +     struct dept_event_site *es, *next_es;
>>>       unsigned long flags;
>>>
>>>       if (unlikely(!dept_working()))
>>> @@ -2405,6 +2437,24 @@ void dept_free_range(void *start, unsigned int sz)
>>>       while (unlikely(!dept_lock()))
>>>               cpu_relax();
>>>
>>> +     list_for_each_entry_safe(esd, next_esd, &dept_event_site_deps, all_node) {
>>> +             if (!within((void *)esd, start, sz))
>>> +                     continue;
>>> +
>>> +             disconnect_event_site_dep(esd);
>>> +             list_del(&esd->all_node);
>>> +     }
>>> +
>>> +     list_for_each_entry_safe(es, next_es, &dept_event_sites, all_node) {
>>> +             if (!within((void *)es, start, sz) &&
>>> +                 !within(es->name, start, sz) &&
>>> +                 !within(es->func_name, start, sz))
>>> +                     continue;
>>> +
>>> +             disconnect_event_site(es);
>>> +             list_del(&es->all_node);
>>> +     }
>>> +
>>>       list_for_each_entry_safe(c, n, &dept_classes, all_node) {
>>>               if (!within((void *)c->key, start, sz) &&
>>>                   !within(c->name, start, sz))
>>> @@ -3337,6 +3387,7 @@ void __dept_recover_event(struct dept_event_site_dep *esd,
>>>
>>>       list_add(&esd->dep_node, &es->dep_head);
>>>       list_add(&esd->dep_rev_node, &rs->dep_rev_head);
>>> +     list_add(&esd->all_node, &dept_event_site_deps);
>>>       check_recover_dl_bfs(esd);
>>>  unlock:
>>>       dept_unlock();
>>> @@ -3347,6 +3398,23 @@ EXPORT_SYMBOL_GPL(__dept_recover_event);
>>>
>>>  #define B2KB(B) ((B) / 1024)
>>>
>>> +void dept_mark_event_site_used(void *start, void *end)
>>
>> Nit: I suggest that dept_mark_event_site_used() take pointers to
>> dept_event_site_init, which would catch the type mismatch with
> 
> IMO, this is the easiest way to get all the pointers from start to the
> end, or I can't get the number of the pointers.  It's similar to the
> initcalls section for device drivers.

This was a minor suggestion.. The idea is to simply change the function
signature to:

void dept_mark_event_site_used(struct dept_event_site_init **start,
			       struct dept_event_site_init **end))

This way, the compiler can provide proper type checking to ensure that
correct pointers are passed to dept_mark_event_site_used(). It would
catch the type mismatch with module::dept_event_sites.

> 
>> module::dept_event_sites.
>>
>>> +{
>>> +     struct dept_event_site_init **evtinitpp;
>>> +
>>> +     for (evtinitpp = (struct dept_event_site_init **)start;
>>> +          evtinitpp < (struct dept_event_site_init **)end;
>>> +          evtinitpp++) {
>>> +             (*evtinitpp)->evt_site->used = true;
>>> +             (*evtinitpp)->evt_site->func_name = (*evtinitpp)->func_name;
>>> +             list_add(&(*evtinitpp)->evt_site->all_node, &dept_event_sites);
>>> +
>>> +             pr_info("dept_event_site %s@%s is initialized.\n",
>>> +                             (*evtinitpp)->evt_site->name,
>>> +                             (*evtinitpp)->evt_site->func_name);
>>> +     }
>>> +}
>>> +
>>>  extern char __dept_event_sites_start[], __dept_event_sites_end[];
>>
>> Related to the above, __dept_event_sites_start and
>> __dept_event_sites_end can already be properly typed here.
> 
> How can I get the number of the pointers?

Similarly here, changing the code to:

extern struct dept_event_site_init *__dept_event_sites_start[], *__dept_event_sites_end[];

It is the same for the initcalls you mentioned. The declarations of
their start/end symbols are also already properly typed as
initcall_entry_t[] in include/linux/init.h.

-- 
Thanks,
Petr

