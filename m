Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A803CCF9E3
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 15:45:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 596298E001F; Wed, 12 Nov 2025 10:45:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56DAC8E001E; Wed, 12 Nov 2025 10:45:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AAAB8E001F; Wed, 12 Nov 2025 10:45:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2D9AE8E001E
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 10:45:06 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EEB591A057D
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 15:45:05 +0000 (UTC)
X-FDA: 84102378570.22.62AC243
Received: from relay.hostedemail.com (unirelay08 [10.200.18.71])
	by imf24.hostedemail.com (Postfix) with ESMTP id 17AE3180020
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 15:45:03 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762962304;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ac37Nrx6rXh3r4cpy5Y0bUxRoGnpSwgkURQws2TSzA0=;
	b=oIzU/0/7vqEsCNxdtRBTuinQdENW5tTdLVh4Pqig7UOHte1yHaBdHrPBrfXdIaJbWfTpVz
	GRfskHv4hcwbxMCdwk5ZEsqUdqBbsvVay9nElcye8ZPsuu/pW1Nz1p/5JSyYxwBTbKCxaU
	dJL8wxvpNC6sfsTABv1f3dgwqKtz9mY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762962304; a=rsa-sha256;
	cv=none;
	b=HgNLQWAWRsm/NoQK6pms4R1nsmSpbvcziRMq5nPIyBInjK3E1JD34ibQQPeqep1isUDWQ9
	7IdR0fE+B7LhNCUeZ4fzCaTmNa2+k1IfkFPuNwUljFPLS/ZB4mKBOxyC6+5x9pHSROCohm
	mrnDpWnHE+5WcqA/jqqKT/o6Qxl4bxU=
Received: from omf18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CDD17140573;
	Wed, 12 Nov 2025 15:45:00 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf18.hostedemail.com (Postfix) with ESMTPA id C85DD32;
	Wed, 12 Nov 2025 15:44:55 +0000 (UTC)
Date: Wed, 12 Nov 2025 10:45:08 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Harry Yoo
 <harry.yoo@oracle.com>, Qi Zheng <qi.zheng@linux.dev>, hannes@cmpxchg.org,
 hughd@google.com, mhocko@suse.com, roman.gushchin@linux.dev,
 muchun.song@linux.dev, david@redhat.com, lorenzo.stoakes@oracle.com,
 ziy@nvidia.com, imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 akpm@linux-foundation.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Muchun Song
 <songmuchun@bytedance.com>, Qi Zheng <zhengqi.arch@bytedance.com>, Clark
 Williams <clrkwllms@kernel.org>, linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH v1 04/26] mm: vmscan: refactor move_folios_to_lru()
Message-ID: <20251112104508.5500ad9b@gandalf.local.home>
In-Reply-To: <jzihvbb6w26d4codfigy2o7b2h26izb4ahihouw54cvuzau54d@jyaa6rgpzuai>
References: <366385a3-ed0e-440b-a08b-9cf14165ee8f@linux.dev>
	<aQ3yLER4C4jY70BH@harry>
	<hfutmuh4g5jtmrgeemq2aqr2tvxz6mnqaxo5l5vddqnjasyagi@gcscu5khrjxm>
	<aRFKY5VGEujVOqBc@hyeyoo>
	<2a68bddf-e6e6-4960-b5bc-1a39d747ea9b@linux.dev>
	<aRF7eYlBKmG3hEFF@hyeyoo>
	<aqdvjyzfk6vpespzcszfkmx522iy7hvddefcjgusrysglpdykt@uqedtngotzmy>
	<8d6655f8-2756-45bb-85c1-223c3a5e656c@linux.dev>
	<aRKqm24Lrg-JnCoh@hyeyoo>
	<20251111084900.babaOj0w@linutronix.de>
	<jzihvbb6w26d4codfigy2o7b2h26izb4ahihouw54cvuzau54d@jyaa6rgpzuai>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/zzJBKVnQjnF7+vD3iE7NPwFKeizQlGh4=
X-HE-Meta: U2FsdGVkX18sZXyIcTgAaFZzEaJim5B3AdsBNcnSuhkN2xVPR14V+jN/a1c5qbKBwiNNEDsYnm/64J4ywfekI1ESXBN6UJspS6OQJv2pFY4ePIxPhNzVl9Rm+8vU67m3SqAyq9LTVgOoNLhlzs0tmR4GFlK36oZ2M//1r6/uqVtRYmW841FrUMVYjYit8fHlXYKbBGeroJSS3BFYTvoXIMH5Z70gftOSU00Kt1bZvIjYFPdOyzv8A9vwq3mX3ifD5SZC3t2J5qSG6sJo6DrZkw5hpFnMuHHE12uSwei8c4W8RtEV9QEVyxIuOx7wSpSY
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 17AE3180020
X-Stat-Signature: 8i46fu3i1uexab3gcai9n6jo5zxtnjew
X-Rspam-User: 
X-HE-Tag-Orig: 1762962295-724363
X-HE-Tag: 1762962303-855634
X-HE-Meta: U2FsdGVkX1+laF/2FOz+G/3BQ4CfNg5GpRu/xDUWthLXNTE8dI7c8ZI1/16ekOpIlH+13xU90tYWewzLzdv2eljS0p5a30rrirJ5uGUhxphZLXGO9l5OzAmLuO+paXDZnrYM5Ey5qAigfCjY8/5SgyXdEKTZ4yHXBtRB91D6Mahr4w17qIiZ6ihpl9rSNQM9MLp82NQTJFDR2WFJNcVL0nrTGe2yelrukcvEh/9DGKpFL1dRMs901LH96Y43dejUHljQkY/b+89vA+xWoczmegetxTh3UfGN9AM6iPqKXSc2lX19wlt5B4xVmhXIS0DpZo4WWcDl6OSFWtIZlRhL340urGF8vX7ZnXstNTjFZ6K56HMtPihaT2tsoXdCWMQdcvsOxJKvJlg0bzhBYTEGJMhezFEAj40cA9oYC3NyyZLlhfO4X7T+csMJ5daBhwheMvTqvfmjpGXavP0Sj3MlUwrwTcolTgUTa3Y7XsdQaI/EudLjp1b9c0DnQZsh4Wk3N3t1zV6bWKlfZLmxhFlDO/ojP0k0MIyYFmpYPH+SS935vwLvgcahnp+RBgHFIIi6CpN33fLZBa/3/+xUydqWeJwZ3PXaNxQmSFKnIw0q8kdGY/6SbQCLF0vvaec3oqqeSHTuw4KIhyhGgs/xHwFUwtCxBvh1YgbYoHgLhECVYXD6ohO7xRAzUSdXr+34zH+MCGILqwUjIlnVXP/iz9L6T/whQLlZK7QOi8xblN6T6XGK/8YLz8whMMcOct2iBDAigvG2SeYxsO++TMjRY8+lmX/QGZp0tZAOHaqOTng2xl4GzOa6CDn1wcl3I2wS6ynvfUPMDH7pHrKYsH/+t8X9yATaf6Y3M/yaWu/xFuOFY6N5nrn50rQmL76GlSnSmhO0eDIONuI4GsKNNESqYRHPButnjMyRlqaB9n7csm8OBQtdDEbRDgxkVMNmEtcZlMuwFXcB1L4b2Uw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 11 Nov 2025 08:44:14 -0800
Shakeel Butt <shakeel.butt@linux.dev> wrote:

> Harry is talking about mod_node_page_state() on
> !CONFIG_HAVE_CMPXCHG_LOCAL which is disabling irqs.
> 
> void mod_node_page_state(struct pglist_data *pgdat, enum node_stat_item item,
> 					long delta)
> {
> 	unsigned long flags;
> 
> 	local_irq_save(flags);
> 	__mod_node_page_state(pgdat, item, delta);
> 	local_irq_restore(flags);
> }
> 
> Is PREEMPT_RT fine with this?

But should be:

void mod_node_page_state(struct pglist_data *pgdat, enum node_stat_item item,
					long delta)
{
	guard(irqsave)();
	__mod_node_page_state(pgdat, item, delta);
}

-- Steve

