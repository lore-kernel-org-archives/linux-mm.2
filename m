Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 173F8606A32F
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 21:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=zcaBePJb
Received: by kanga.kvack.org (Postfix)
	id A8B066B05B0; Thu, 26 Nov 2026 16:04:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3B126B05B1; Thu, 26 Nov 2026 16:04:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9290A6B05B2; Thu, 26 Nov 2026 16:04:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6B0F26B05B0
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 16:04:10 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0ADC01A00C5
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 21:04:10 +0000 (UTC)
X-FDA: 85478497860.01.9AC4BDE
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	by imf18.hostedemail.com (Postfix) with ESMTP id 297651C0004
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 21:04:07 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=zcaBePJb;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795727048;
	b=js1D7fFnjr1Q/5dIPjRocAku+FsfrBWB5aQC/6eI9voj03C3MA1c/3XFIjGMVrXJhIMNWn
	Pq4GZzZBPCQHPXnv8ccIe2tfZK0djS0MZdhKmZYF6pxzRJ4ScUwQ0GQY81kB/x5O4B0yay
	32Bqcgc/JqQ4ef5PDqMhPQP0e0M4Kos=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795727048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NzQpi5zLFt48IXOc9gm2YIA1Vaa4QZ9J+BdHMrNcKwo=;
	b=uEDlkNN+/LrN64i8Noanuz922xrlZ2clLORAyZ8/GGLZ60EDvs8gZH1t8LdRsaOlI+HpO/
	dwQ87uT2XLMVISk3lro4HWVX9Cb/dHeXn3hbtXU5n/EWhSXknBczSgu0gaofS5nTJ9J67g
	y83ZOo4pnIlZao+BQNFiSF9NljWdtE4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=zcaBePJb;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-cdb2893531bso3888474a12.1
        for <linux-mm@kvack.org>; Thu, 26 Nov 2026 13:04:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795727047; x=1796331847; darn=kvack.org;
        h=mime-version:content-transfer-encoding:references:in-reply-to:to
         :from:subject:cc:message-id:date:content-type:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=NzQpi5zLFt48IXOc9gm2YIA1Vaa4QZ9J+BdHMrNcKwo=;
        b=zcaBePJbhLg/Wi3zE6nfRSngwZtT5rVsUKHJnNhG6+KA9H8x3pmtvnDGK0qcyimwMh
         La0kGQzrFycWhBN+Zhu2K8WlDaiydO/Uuhs4jdqfepWruYAJ/0OMr7WjN8pQP2JtvB2V
         2XOnHypKv+pVUaT7wj73A2ft60KJL/OeXabIc3edXJ4nesx0VbId54Y89YPBAYXVv8+G
         A8eFomMv+hb6B3zZxhlTsXzNdvTy6dq/LNiPnZbem46wj4a9FjYvfQZE9f2WQoZiNN/u
         +e0RZckZk2mjrO3t6yr8o9SWRgapFWuFOjP9JCrWfmGAyp7ltnRSU3LzBh3xUCRSe2cR
         Nbow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795727047; x=1796331847;
        h=mime-version:content-transfer-encoding:references:in-reply-to:to
         :from:subject:cc:message-id:date:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NzQpi5zLFt48IXOc9gm2YIA1Vaa4QZ9J+BdHMrNcKwo=;
        b=ofIesD43ef4hfXd8xRzrFJqbOFQv3RPbFseqOrfG9w08xtB6MFs9wBMqRCyZniq2At
         1Lf2EMpUWKivHYN0GzWBV0AAqivU/XyXiybz4XG4tvb7h1uVfm/5t84BQysROqd5dAXr
         boBr3XKL9kMIrJGkRX5ENjjHKJUV+LAsBZq33rMO0i4wkjqtHldHLRv31kC8RQ7vVwiM
         70vXyFalXJaaB7Xk+3IIwRw/ykUU4+C+z5yWccSED/OhOMQs72mC4rJyFItOed8Xe9Z3
         n8xEfxNruShyEwo6OuQ5GlmPiFu2mrcm2IajlOpCUr/EQ6rPWmXMGegr70f4QM2TTLl0
         RlKQ==
X-Forwarded-Encrypted: i=1; AL+hErEnm8oQH8s7CFw3IT6FxHtFNTHSrggmXWBgfd4tnlTeBhhG1qYcmCGxG/XYdac8EFpuYPMpcuQT8w==@kvack.org
X-Gm-Message-State: APuU4Z9qk48uj0MGkOFEHOHKj4MfCU95nf+QmBeFdx+rzUF99HbBC2xO
	Ht0EjkiGStOCuoN0BhwYtTR6uCYPoFnpV5rj3C2OmzbRvIC/8iTV0C/R
X-Gm-Gg: AZFdTZcxvs6dihqVAa+wav6DVhlsf35DRhwnKbZUh/CGceUKr2kW91y4SKjdgInJ4Ym
	QibhAC1UlQRXyacVuU5cgmAdzRIP304OrGiMFMty6SBfyQAaojD5vi6ObZ4zEc5AXNmu+fAYeJi
	cEkyjzDFToDEwfWxQQi9U9uokKfinsIz2Dk6E+1Fw0wbd++8nEXtIU48HIm7GRSc41UAcS2iZKJ
	nL68fXZK/7Slchn3eld7J8uAOf0n/Ytsx0sLUGh0xeOfndepCSIvlZb0Q1/ZIyGuzn2jztfRBDQ
	0lmZ/5QzqdRXDWEJz2zoPLscKPsGap2E6FXr7lfT+2BPgtEZWO14CsiRrzFNJSyw1vWfcSSjXsR
	X0fsuYPbgjoo7m8NysfKI39zSZ9NOMckxZ95Z50sijVm/ZIR94cc1ryG4evkLSxiCc8lWhLA8Rl
	LOLv7V+5tH3XlIa4A6jFB52GIhlXiY/tihihwY5aWWQj9oLqDdzytCS7rxyYo40D0RyljWensvB
	oUtKiYR/V0U5Zv/yz7AWAMAeXMvj30pqnD2YNwiw28i5t9mR29wryMAwdpeWe4zI+nIVZ74r9Vj
	xnr1wOzF3q8ham0mhuw49HhdPoWccCUpeSJoYktEkIXcI0RHMUX4oUXG8CHSQO/wTnhdP5m9cUy
	evY6uAV40UN+MiXHTtDbVId/qzXXAqTDIPQk=
X-Received: by 2002:a05:6a20:430d:b0:3fb:1640:c525 with SMTP id adf61e73a8af0-4014dd5bab0mr24693403637.67.1795727046733;
        Thu, 26 Nov 2026 13:04:06 -0800 (PST)
Received: from localhost ([153.61.198.246])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c872e4af1fsm11430391b3a.28.2026.11.26.13.04.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Nov 2026 13:04:06 -0800 (PST)
Content-Type: text/plain; charset=UTF-8
Date: Thu, 26 Nov 2026 21:04:05 +0000
Message-Id: <DN5G409Y1VV6.FWWRMP1I8IB1@gmail.com>
Cc: "Harry Yoo" <harry@kernel.org>, "Emil Tsalapatis"
 <emil@etsalapatis.com>, <bpf@vger.kernel.org>, <andrii@kernel.org>,
 <eddyz87@gmail.com>, <memxor@gmail.com>, <daniel@iogearbox.net>, "Sebastian
 Andrzej Siewior" <bigeasy@linutronix.de>, "Clark Williams"
 <clrkwllms@kernel.org>, "Steven Rostedt" <rostedt@goodmis.org>,
 <linux-rt-devel@lists.linux.dev>, "Vlastimil Babka" <vbabka@kernel.org>,
 "Hao Li" <hao.li@linux.dev>, "Andrew Morton" <akpm@linux-foundation.org>,
 "Suren Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>,
 "Brendan Jackman" <brendan.jackman@linux.dev>, "Johannes Weiner"
 <hannes@cmpxchg.org>, "Zi Yan" <ziy@nvidia.com>, <linux-mm@kvack.org>,
 "Ingo Molnar" <mingo@redhat.com>, "Will Deacon" <will@kernel.org>, "Boqun
 Feng" <boqun@kernel.org>, "Waiman Long" <longman@redhat.com>,
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH bpf-next v1 1/4] bpf: Add call for selecting kmalloc or
 kmalloc_nolock at call time
From: "Alexei Starovoitov" <alexei.starovoitov@gmail.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, "Peter Zijlstra"
 <peterz@infradead.org>
In-Reply-To: <3a44dbfb-265f-4749-b411-9491a0bcf8c0@kernel.org>
References: <20261124060357.11700-1-emil@etsalapatis.com> <20261124060357.11700-2-emil@etsalapatis.com> <DN38HGVL8JHQ.2ZVZQCKFXVA9T@gmail.com> <awWRZ9xCzWLnj_R6@thinkstation> <20261125140902.GE2668804@noisy.programming.kicks-ass.net> <DN4QLI2XAGO1.2DDIFJ49PNRPS@gmail.com> <20261126094403.GA49833@noisy.programming.kicks-ass.net> <aecebb39-47c9-4b0f-a076-ac0ddc7724d9@kernel.org> <DN5FM9P3X2P0.2IFD5DFBRELP1@gmail.com> <3a44dbfb-265f-4749-b411-9491a0bcf8c0@kernel.org>
Content-Transfer-Encoding: 8bit
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 297651C0004
X-Stat-Signature: adtn3zjgaegx5zo1pzyigxognmxfa6pi
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795727047-368074
X-HE-Meta: U2FsdGVkX18gbfOKX08Lk4hx7CQ35F0lYTCDSOCP1UqD9FcJa7vYAZ7atsfKswT23/tsfzPMCIHyscSxEWaYv/PCDkI+KJp6ewilnoJxXCmSzq+BmTENp5amoMtL/GpfPLUi+8NXwM+947cR+bb1g+M8rNff+1o3eUpuWYSZel0t4M2dmi2qPR8A47TI7NLqgFDToHqeOmhBPRwPmADClerMphZ7ieJPc7bh5eVkGQJDQip35xd8magMBwNOY8bDVlDtCbA7aIpsP+/3iljC7QVeJjM5gPm+/asXTdNXZ9lY/6nojFxSK6r5fInIOil1F8XwWPxyXPUOsTHfu11OBZWw+B9+qXdIzEDjO4QAAJxJ4X/aO1oIA7NJ+05HUGKUTU72eBDXkN1D6CZniRLrIVv0/HaK5+poUXolTXLJOREzzKyX63FPr+dTUjb+fasxp5yYb9U7KGg3VzkMcoKp6flTTYNvm9lMSRfNxmWPQatAnYjiZ7cro4VccKcJG9rFxpgG4GtAG/+lIICxTqjqU4Mo0n8qNWHEiJPzovzxdTplsojMmlSblDjNTqzjYAPQCZJfYf19zP035wqk6/7GrzlmgvMmGaPWbIgjRKv79djbO7JRUTzyJlf4sElnIA+b8PRx0+ABwGbgWuBNb/U+VZEtJz1mE42EGXw6HrO+TKT/sJYnqShkdPjOLQg8aKB4W+cdxBS7snnN+QDAHu28g5ILU4XVV6scOtgJPlKfRVwV1zISEUQq5ZJlA74C8VPuvCAnvsH401yNOGlSLYd99IbCbQIZEuFK2ZCEC7LCux6w1Cdh+YqpLPOlaRH+RM1q5u0tE8ejAtijeMQ7G7zCX8h5zH/Rj1YCUiLK6X60PcgVkDxgePmFEouzr2u8NM5rNSKr8BcTaQdl5sdSOc2DImfXjkfs2Nk26jajHPfCLw5ger7UxlQcHVqotrf5rW7zhJ+KaKEm3Va2DL8ufwl
 1aq/rmZq
 Bej9kuk8KJqyCyOO+oEYq8/xm2+YYp2z+51uw5T2YxuHfkGHO6e7LF5Gi23AV3Cl6oEXh1k9SrHQ/WS1sKUOfC0z4KInfCz5s1J98ilA7hNQMX9SbprGptBEShj33LmgTPz594h5i47v1G3keux188OszgwpecSZL5eV2h7lyp/YXEvDqgm603Se0iLt7djqwfKavkfws/BVX8UTZUT0U7tz2A6yycYgnO6JJirgcm3DWnkZIczKliG8FK2vPTz8EJQijGOPuVTkVp9ldY0BFok6faYwLcrTGx5Zkpuq/DtUlft0V47FfTn2nggpHdy/pcvT1znCZ+1RiTNd6ulllgu1ZQnCJLIWgJB4wJZ83p1YUjiwNRJQBtXBCCMKNZ1662WMiM4DeqZm5Qqg53y3tdH4gVsCUlUXun4crrnLMyDrhHOrBxdZlong2OZAsPiFGay8Qd4tuB3O6Flfj+U445OLb84XqpYG3P5Cc1vzXOwC5BLQKeXtZcmFh+vaSJdfMDOis1uHh5TxyN8PR0zdLgDXlsV56GH8pnVFAuDcFOq/iFOMvTM04D8T2f5Ouj9ojJL2E5jVF91dprFhU/s/fAvzTbJOmhUmFqvtfzI5NzXxvLvpSfAfuJsyPoO7/NyKR20XrviWnZr762omD1F/s/JaN7P2NpcggrVSiIgFcOLI24YhqAqaQOcnqiCufPoayFqUWhodnD/8hX7UfazJFCLQUM79H5rbXcP+e9hYtEd6BqBfo4PJQ6gTetZUQDmDakRhhULqwZXKmIKWI3VpAs+r+EIQMAZWHusxnjn8n+bDxsVWuIDWrXKYiIQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 26, 2026 at 12:45 PM David Hildenbrand (Arm) <david@kernel.org> wrote:
>> Which part?
>
> kmalloc_nolock :)

lol. Agree. I guess it is in some ways :)

>> I don't see any new concepts of failure modes vs existing code.
>
> I hope we can sort out the rough edges.

100%
That's the goal of this diff. It removes one of this rough edges
for user's of kmalloc_nolock().
Today it can return NULL when another CPU holds zone->lock
or n->list_lock. It took long time to debug in production,
since it didn't look like lock contention at all.
With this short diff that rouge edge/corner case goes away
and spurious NULL returns disappear.

