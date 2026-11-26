Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEE88606A338
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 20:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=gCx1ydR4
Received: by kanga.kvack.org (Postfix)
	id E6FDB6B05B0; Thu, 26 Nov 2026 15:39:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E488E6B05B1; Thu, 26 Nov 2026 15:39:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D361E6B05B2; Thu, 26 Nov 2026 15:39:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A4D646B05B0
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 15:39:45 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 02D2DA405C
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 20:39:43 +0000 (UTC)
X-FDA: 85478436288.23.3EEA795
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf29.hostedemail.com (Postfix) with ESMTP id 36BCB120005
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 20:39:42 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=gCx1ydR4;
	spf=pass (imf29.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795725582;
	b=JBaX1F6as4PDFVZvdd2NjdvzrO2fuzPT8Napiqq/fekIi66WY1a54+sOqBISLBYMA3Lgzg
	6qS0ZYvV7Fcq3/AWVJuNE1Pp5Ju4f0+PSsNAkpEi6APQ8ZOqGb/NiegvdqdJdwvH5XtfFw
	drKb1ZrNiLqXB5Ulv4wR0FmhFt4GK0w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795725582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1ULurqX3SBBqjAdy7fFaPWDUCghKvLpjXthTQufVgQQ=;
	b=MhDoKV1dVoDRkS0MMjFCfbJrn6q3bUmUwwH+uTxbOpZbGM6X15nDxSRrGJge5bLe1ookwK
	vH1ije8w/I52HY5KB1/mkRwzs+khoKwnBq1pKf63dWWPCK9XlWpdh0esGd7DUNRX6GscFJ
	6ItsII+SMEpGUDH9LUa9TDu4uadMSrI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=gCx1ydR4;
	spf=pass (imf29.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-3ac78f4c10bso3474770a91.1
        for <linux-mm@kvack.org>; Thu, 26 Nov 2026 12:39:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795725581; x=1796330381; darn=kvack.org;
        h=mime-version:content-transfer-encoding:references:in-reply-to:to
         :from:subject:cc:message-id:date:content-type:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1ULurqX3SBBqjAdy7fFaPWDUCghKvLpjXthTQufVgQQ=;
        b=gCx1ydR4cW0rw9Nm7qsp1rnR1j/rXXQvcsRKtDoxtjAS/2LOG98vzQPHJYmx3mKwm9
         2vJj13bXKlf3siaMAAmiWusgxQ/2941iRYC9YLHOXCgbmr7q+CTGyphe6d+fGTMqops3
         BbjgHfLvmfPwr5lZgxnd4AgJuxIAItonsaMHS5aFc1CYkBodQxiH/UBCfmll1rO9lsCj
         AbsC9gfoybKjKVje2SIgzsNCCPfBuCwRB5WB9O/j57HgpG1/gs0aNauCt2h2h+BdQvKR
         d6F7DaSOiQjFN72u0l0TXNAnaNTwcqO2ahlbgAxJCjJkFO2UbDiDFh6g5STA4s/fHmm0
         i/gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795725581; x=1796330381;
        h=mime-version:content-transfer-encoding:references:in-reply-to:to
         :from:subject:cc:message-id:date:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1ULurqX3SBBqjAdy7fFaPWDUCghKvLpjXthTQufVgQQ=;
        b=VHDJ83spK5uaMnHiacuepnYj5ENqpjelPWyxhD0oyzi+u3GXZV6xuEcmFhhFV1HZUC
         xoRiVPhKe1jJztWLNizWKkB+1OxCaz89LFrELVSNRSm0vVUAM9AfGrLfTUiQpnas1Gwy
         GHTSPFx1Br7Kor3IzPQUICxjOop2uZjwrKeE+GsOOz7gz7zOaj7FRFMIcg6OV/a7xbtB
         a+OkXsQu/ixdYUj0Ei1q/L03ltPDPH+Pv6LmwJCiP4h8qoQw0TiSLAqx1BfNdIsgXUfT
         BSwpyVOJSlfzHI8v8Yb75swSE4Z7g2uJAtayw8XoeBUS7oW1yrY47tLbLXltUntWCPDB
         RzJQ==
X-Forwarded-Encrypted: i=1; AL+hErEkGLmbYq7zl1YJeeoVjuS0uipRt2wQkLXCjnkP+7OugKZo6cWlRq6p7gSLQQF01OG0EmvCTac4Og==@kvack.org
X-Gm-Message-State: APuU4Z8+xafrcRZAYeYSq063UDhk8JBeS/+2qV64EPGULzwbZxRa3uo/
	KuovP5Jw5VTzGJGmyIHlD24E2l7uhonmekIvV/JTbsfylquJ0w/yySJP
X-Gm-Gg: AZFdTZeBr75x60H1W9VYuNvzmSeewHEsy4yTosYcx0Nyhbq9ct7pNbghBJm9JHtCjvU
	QHsCrEu1zYwysUJrq6/CPlOihA4vsqXnmYfY1pkD+hCkUCWTDwpJD1xcrmP/mbLtY4ZNcKyNGb7
	sS0vDjakxXuRrPAz8ovoDIVR8lMbUpe9IkYI07kjIKVburwtw4803kNHnYB5P1hxA5lu15YhLy1
	wD520L189zi3s4lknATaQIUZhuk37WapvXd3tfj4SL49c4YzDvxxDThblWS2bauoe+qKYNP/Kti
	JOlHAhAiUrPkpmQqC0jc/z3kylnBiRBEy/J0Iovj4ELAcBsQ0Hv619MynH+9woBrumca627wz6N
	NmoxMP6sFMxd69TAWfBVSANp1SSW7tbf9ocd4SUmLgypk+aZMGW0IYiNDVm4MNibrtm+uTIZMtb
	QDq1WmpWFkG2xcAlimWSSZ8zC9d10h047EEqz6NrlKFIBiD9ySJcnQ6mKVhSnJZrenCuobm2UuD
	5sQkYwx8pvNvmsZVs7YlrkSZ3D1pJ6n+XilbU2VZvkH7kjYv2bhHEDYZdtpwWHSb2/ZuJnTKwqi
	ykZzUSnq2fAwS0e0blX6RrkvsbYolusDFpriJN+TsvF22gbfb5npVg+SLHKXtmwMXLa75OiRslK
	qGTXPwYRwErkDHxeaGK89pSJLwRbCQBPTng==
X-Received: by 2002:a17:90a:da88:b0:3ac:a11a:7c84 with SMTP id 98e67ed59e1d1-3b41c982dafmr20430646a91.65.1795725580807;
        Thu, 26 Nov 2026 12:39:40 -0800 (PST)
Received: from localhost ([153.61.198.246])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cde6d026d6fsm11352777a12.19.2026.11.26.12.39.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Nov 2026 12:39:40 -0800 (PST)
Content-Type: text/plain; charset=UTF-8
Date: Thu, 26 Nov 2026 20:39:39 +0000
Message-Id: <DN5FLAUM107A.TFWY9O1V23F3@gmail.com>
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
 "David Hildenbrand" <david@kernel.org>, "Ingo Molnar" <mingo@redhat.com>,
 "Will Deacon" <will@kernel.org>, "Boqun Feng" <boqun@kernel.org>, "Waiman
 Long" <longman@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH bpf-next v1 1/4] bpf: Add call for selecting kmalloc or
 kmalloc_nolock at call time
From: "Alexei Starovoitov" <alexei.starovoitov@gmail.com>
To: "Peter Zijlstra" <peterz@infradead.org>
In-Reply-To: <20261126094403.GA49833@noisy.programming.kicks-ass.net>
References: <20261124060357.11700-1-emil@etsalapatis.com> <20261124060357.11700-2-emil@etsalapatis.com> <DN38HGVL8JHQ.2ZVZQCKFXVA9T@gmail.com> <awWRZ9xCzWLnj_R6@thinkstation> <20261125140902.GE2668804@noisy.programming.kicks-ass.net> <DN4QLI2XAGO1.2DDIFJ49PNRPS@gmail.com> <20261126094403.GA49833@noisy.programming.kicks-ass.net>
Content-Transfer-Encoding: 8bit
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 36BCB120005
X-Rspam-User:
X-Stat-Signature: ff4mxzmqj3a6zdm43pkr9oe493ijkh1g
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795725582-137929
X-HE-Meta: U2FsdGVkX18Z1r9vAim/y7OhteRJh0SigJpO0+X7Sxuf+XgqptXC/yOLUDe4Y38fxb0B1Y+UA404TNPLM8+48CU74EIXU+uKVLBCdxhTHOr1QKtE55k0ZTSfvidbB9rmkO5T1URNNKT4DkaI+rxNcCqsAFGB9UPvccnGa2cNQH4+iqZYbmgPkhEmtzYsLDm2FP1JJ9KK09NwYqm7/9aX0RngwmbSoNmnjd0lQKyQUqm/h4OizKk5PkhJQf2hOd5mttJRqdy7kn9MemyJ3rbO55XyOPnlSm13KH5DnNueIqttthZDnZI43Z9z+4YuR63uXGRsla4/yQkw9OVoLEvsaPHSRCQUths9PwtrR3Dfb4ghkXnE56BlMbS/4ilUpWSo54evAA6qwq75kEBkZppXu7l/oTjd3tn5eFr5VVDxb8kDoMQB8obCKtZ0kFbR+gZMEeFW+mbQSIVl7GpPNMQbjJGrtqxX6xmOXDdSIrBy0SYyhq9rd/S10FPMWer7QW84hrhNBqd2RhA1fwZ9TyYlGUmfxqTT30OEO08tUtR/BjcUpc446bq1UyD1L7OBnXa73HtXHepJaNqYIzVGE2sREIfYLzVMR6g2uYSEfIL1it+esTv1LaPhH0ASrYuaFlbJjpbgn8jPzQTfUN7TOmohBljJGr3pCFyCkq9MwAGBWSUsC26o8S1k2rHX27uw4jkDmWpYC+IhwaGmRmYVctkqlOykuFLYohMUPaDtNlncfvoNPwBpUX2fZMShbtYz3uSIWPtVtnJkKsuF8Yhxwtb9F53Uhqsa6JnU9+8MiyxnI1l4MzxhRkzPrM5QmEpTcV2gO4xokM8SSpRDHmgwitYYHMQm59IlDDgpJq05pCv9a9d4vinpqThrQXjy8goySO77kaBlPf3mSgQglQoqoRRXa2hB0k6lXm0Fe1kvJ69ub9Q0aJ7+yWOdwc5HRRd9Ta9wCrrcYdSk5AxYvBV2zi8
 qZAeoW0Y
 cCs0ZzUMK9h/HbIC8zrn4T8ZGXRkPhjvhKe9lt58DpxCOLz8lxAgQv9n09fF8PMzveB283a9nP1u5Ch+l12xoPS6pyZpKw4jkz78ylReG9jIl1x8M4yygy/8+JPD/VEuSwfp7FT3Btdf81fzDVCTwkuXwtdnNE1tHhXECtqYDIqzfdm852WCNkqRgcqnG8hZVrvZfL4EEt/wevCRH7j3aqCOeZNVBUZ5oLLa8Z8/YyGJzZepE7W6j6DbpMYc0LLEd1heeLu/D+aqCg2RrW03sWbjWlv16cvvrrdPJuea5BTaur7g9XjPgBEeXvEMW86O9Oa2ar9pwTsle8XgswwOTopK+Sf9c4i+KH3trEo+ZVwDFl3HyR392LRqFDLT8iLrUjU9D/6w510d899zK2uMIb1SEyAmJ1QsasPlC8nX8EsD78Yd8ZbIATllwuIQdrXLTUoRPSCjmV3V28ZgGqeXR1xtuVa6CoChmaRs9bM9h4Sazr7LDcDizCL8wF8+8Gkqlg3JeKXeI9HsT5RAOT1N2/If78sNM55XlZsaAyMDi+hdNMltEeQIsdisTZ5uTqXtSpJiNJDyJ52cOS+u2uQvJNH+MKITg5Tm8xbsSBlwU5PXX133aSa7Q7eQIHEs2t+BhB+ZfCuO0gSixcfFGV+SIz0AnX2P52w0dgKf6M9Iof6o7rAngOLjXKSGmcIAftgv5fgqsk42LIszwLrX9tdV9F4zOCG54BZMuHTznLMzMyYeEWOhEHQDeUWCSck+fJiLDQy7n9lb/sm5uGj8O9cQOeBCyD0T5nouJICTIr8OTEjPLtvuLsnwwZjFWNQmUrEePqRSR2c+UQ5g63XJ9HPnjWbmCyQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 26, 2026 at 01:44 AM Peter Zijlstra <peterz@infradead.org> wrote:
> Allowing this on !RT makes people think this is 'OK' and then the RT
> people get to fix endless crap again :-(
...
> You're actively creating something that doesn't and cannot work on RT.

There is nothing for RT people to follow up or to fix.
The diff doesn't introduce any new failure mode or a path.
alloc_pages_nolock() works this way since v6.15.
On RT it returns NULL in NMI and in hard IRQ.
It allocates in all other contexts.

The API that people call is kmalloc_nolock() or alloc_pages_nolock()
and the contract is the same in every config:
any context, and NULL is a normal result.
The caller's code is the same on RT and on !RT.

> Locking constructs should behave identical across the configurations to
> avoid divergence and create problems.

Conceptually I agree, but my bot points out plenty of practical
RT vs !RT differences which are way bigger than
this internals of kmalloc_nolock():

  where                      !RT                        RT
  -------------------------  -------------------------  ------------------
  debug_objects_fill_pool()  allocates in any context   preemptible() only
  printk(), legacy console   spinlock_t under raw lock  printer thread
  vmbus_isr()                spinlock_t in hard IRQ     irq thread
  kvfree_call_rcu()          uses kfree_rcu_sheaf()     skips it
  local_trylock()            works in NMI and hard IRQ  fails there


