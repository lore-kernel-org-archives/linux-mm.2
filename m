Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E339EE7DF11
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 17:30:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E2666B00A7; Mon,  2 Feb 2026 12:30:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28FEC6B00B9; Mon,  2 Feb 2026 12:30:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 171766B00CD; Mon,  2 Feb 2026 12:30:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0727F6B00A7
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 12:30:39 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A0D12140226
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 17:30:38 +0000 (UTC)
X-FDA: 84400206156.12.B722005
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf15.hostedemail.com (Postfix) with ESMTP id A5368A000E
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 17:30:36 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ctkks2fM;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf15.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770053436;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7xld51LHMG18KNiYZotetpk23zS9dV8htqF6ZY/bre0=;
	b=A+WNehTWIul6JPKKzX3An3Sjja07J/yuezLJoimuQiEAkwpabSjpY/EQcs0oDuc5tCFAzv
	y5BOHGmMKhSAFf0v2t6H7N3vV2Totn/fvUlGyJvUXvDViSPOwnv7wYvrJZssA7j9d+2bIK
	uMTWmBucyiBtL0aPWjxLWl0pr+qqxrQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770053436; a=rsa-sha256;
	cv=pass;
	b=nSYQuhtjorvZiUIVz6lKA3+i1WdJmEHA8bKjO4tP7pJIHfkf5erKMxcUQ9dJOvVYMO6hdf
	cG1eW76B51207UoOPC6VSeuRxwC8LKXWhj69ZjP96yy2hgG98XUTF5aquC7ICz7vcl5ktI
	F//TbBC4vedGnPsssO7PJT03QUxa7J4=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ctkks2fM;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf15.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4806d23e9f1so52748975e9.2
        for <linux-mm@kvack.org>; Mon, 02 Feb 2026 09:30:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770053435; cv=none;
        d=google.com; s=arc-20240605;
        b=OiLH33ugFbcUuRLWRmdz0cOrOH0XYZYyzBBgrXI/Cqvb364GcKwb7t+2L1kjODPOYo
         XbcvYLpvLrzN8btIRI7hgqiAFG+fma8s3FAkqHLounNIj4xT33+LE+RVYDIhZkPVSC6f
         3KCGxjvxH0WNUnNCctFUqtg4xtg0jR68YRhwTUr7Pg5nDUUGnRPYpVG2xr+xxg5/SG3a
         jr9eSxa5bfYs23+G/n0yXPDgDmi3qLyNqjldk1k9urOV1QDxxPx37HTnxAFORdtMiJbp
         e4N7nJ6IpeGvPMT3+ze5utfvJt90KMYdWHveqWjN6VU4pIRQxhX34ZnS2cYLSshPjpfZ
         jgCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7xld51LHMG18KNiYZotetpk23zS9dV8htqF6ZY/bre0=;
        fh=WzwgCmzl/OhzrY+DlxqYx/btaJ6MSXYUNKoWvmkOznc=;
        b=MzjTHzuCSudUGeL2OEUs/K05gzGX2FGsd7rUN0apRxbCLfQF7P2F2FrPUYAsIBRiZ3
         BehF6H593a8aqYC0rsU68MeSXddhBTXcHoFvttnlZgNy5UgoR/hShbhhWHy1JeGrZBSW
         Yhn0lLdwegWk3NiQD2tI0pXD/PzZQMSPYXnPZlm+rept8T+ln3TFiQd8pMhwrpTvdpoI
         7oG1Yr/eHneNjxNMZB3KQz4LGeb4PCkDXssqHX9mzkR/8GAZGNlRkojwWYIlBi/eOcZj
         YqOiAP33FFnv78DwE9yGqSyz0CYg8SZliHL16ovtLI01aQKkpdxBiecWqx4Yv8X7R+pv
         VOzg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770053435; x=1770658235; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7xld51LHMG18KNiYZotetpk23zS9dV8htqF6ZY/bre0=;
        b=ctkks2fM2I5M/RNXMo6teIvSE6B2I3Nf3kWLZgCKiyvSqwkIpsB20eQnE+iU0f+dFk
         M/Qq/5ZQVux5JEjcNVjNqSMs8hEfgqhmqDYpVa9LccmD8fyOHLJBVhN+WDRP+Lf/Eno6
         IiNxhFZpRy5uOl7f5+2t0n8mC4ARH0pJOubLWOjiNDFx2+1aQgEaeuibR9qRUMYKI1aN
         4EE5/NeAQN1IoE8T+DfvS+5PUHY/t+RW3OBDuVsRkU2wMe/CBU2D+jrhhxGMp1OMBepu
         iu1/QWx+3vlC82v1jpaTS4vP/el4AcmGmREvqQxJcDSsf7+6OD77KpTUZqsdKf9NlMMG
         F8OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770053435; x=1770658235;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7xld51LHMG18KNiYZotetpk23zS9dV8htqF6ZY/bre0=;
        b=fn4X3c9nrufgtXeZiCzk0fT4XXY1DrFvISEtHkBJ4Q2kndlsx8x3mxMPxPK+AfwqOa
         prpHNQtvBaL+cXWQfw+I/zb6ZVg1QlVg0nhOvLouevj9E3N1FWoM0WJmEeP67lyyM8J5
         5fULVQFqpRB0waZm6T38e5rzuryRc03wRyS42SMxb4/BUcz6w4PkaAiZg5J8qtJaz86H
         4oMU+s1RAwyFdIAIg1wzXSOrJLsP7UtXJL+34d0RczpP/DH07t+/Y7gQ0/4TW0aYCmWs
         4lGGGdzCebLjE27tmQwTyDEQUiVgv1XYUP9BqyIdYq1Ch3VFbMcTSpJ2J5W+mvW0+pxp
         mZbA==
X-Forwarded-Encrypted: i=1; AJvYcCVlyBbafzx8G7GPHhgknLWkN1pMxc82SlMYYY2hxE+9fhex05a5XYhPVGEdglWZdW0Q4StOC7RPow==@kvack.org
X-Gm-Message-State: AOJu0YyBKboaHfu4ZQsAzea7QLCU9Aeur5qGlSYgpBjjY/BmDKGGKsy/
	gtxTIiG9IgHAHdZtWoWNmGHvXQwaAXO6V6qSwy5TZDEk6iT3vA8JP+o/uhSvk/UqpqZ3/oM4UcR
	/985QpYVWJuySpJSiiAktjwL1CTiI/Y8=
X-Gm-Gg: AZuq6aKu5k+70BiJAb/ZmgXas+PlJf7GZ1BqcU8DnYvHiEepx9GRnm7s3Yc1llnbh/h
	x7S8CFBlveN3nMGRAPo0LdVzzlKyr/48T52CUc2QTp7Le/a2dnhoSk06KK/xlQ3Mmlu3mJX2t0D
	PBmYWkahvq5YL68jy8XvF+PTSZC7XbbWUZhLFKSMQIMbToGTaO2o8IwLxCR3eNmqyztRgr3POgy
	agP6aF1x3dhYrBMagskFLLMiG/4tkZqCoo93bfVHqDxJM8Zb/Tt3zBOV7PQSJMtgCCFU2rqNzwS
	KZ7XcrZPUTa46QoRN7yxdY5g0jW7PNdCKSMV06wglEe1GQRhlvERDuHrfYaHBMB9t/3qHjQd
X-Received: by 2002:a05:6000:1861:b0:435:dbc4:3af0 with SMTP id
 ffacd0b85a97d-435f3a9181fmr18606086f8f.14.1770053434861; Mon, 02 Feb 2026
 09:30:34 -0800 (PST)
MIME-Version: 1.0
References: <20260127024421.494929-1-roman.gushchin@linux.dev>
 <20260127024421.494929-11-roman.gushchin@linux.dev> <aYA4pH_nIBZ-ZhLL@google.com>
In-Reply-To: <aYA4pH_nIBZ-ZhLL@google.com>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Mon, 2 Feb 2026 09:30:23 -0800
X-Gm-Features: AZwV_QhcSxBOzKmir8YnJuWGB8mK-DNJ9JY3HMjEXt_lprjX8IPmESFpgJWBbyM
Message-ID: <CAADnVQL5g8imKNGbHGQ4HA8_qNT4MYwM8P3aCTFUG7uwiuTeuw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 10/17] mm: introduce bpf_task_is_oom_victim() kfunc
To: Matt Bobrowski <mattbobrowski@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, bpf <bpf@vger.kernel.org>, 
	Michal Hocko <mhocko@suse.com>, Alexei Starovoitov <ast@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	JP Kobryn <inwardvessel@gmail.com>, LKML <linux-kernel@vger.kernel.org>, 
	linux-mm <linux-mm@kvack.org>, Suren Baghdasaryan <surenb@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: A5368A000E
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: ob53b11493x13msr1hfwacdrnfkitsqy
X-HE-Tag: 1770053436-626730
X-HE-Meta: U2FsdGVkX1+wl1V5KVeFaiMwuRaIw2Y689mPHTEftvaswyCjbSiXASIY5XXC78FLmH9A5nbEwxlQMSymZapALf1VW4mRShypF7MtEjWPp83yDjuiRvGIvJb+Fye29SWY4w70pczRY5CmAreWJFqh2a1Ui6XrYL+z6Xx7rFN/iQtJveJjsWHmEI4w9MaOz1FSCTxElxSZqbIf7wKA3S7lPVArbl9uCsb/1Ul7vtYsRLQUUuTmIlHOTogvL9smOgJSb2F6jgx4u5R+1zvVBo00MxJvf9rYaC+f6cvWnZcN/URdDfaLcnn6ekKXV4ew2NkVZn46cdsHt4CIvL4UasGhInkRq2ivubcBblUMEIhXuL7ILGH1pbmdqOnxzi4p8V7FvBy4GoBCHtJCVLAa+2b5uG5bbqPVXjldu/9FEs5alHE3hNRaOjuyFJID6dzw7oHKgmnZ5VdGGoT5VhV3ZhpxH/aNgxZJEjbCOuJP3pdAMPYmEVwSn5pxhPNakg26ipNwYNQMV5maW0oVUrcDrxT1/wn9Fyd4GqiQHAJFHkAJF44U/5J2B/cM6velT1PgT+cxMIrXB+gb0P/rn/4zMYGmnQZWYZ9HHPPom8Z1pkv8iQIfy6U6qHv6VXIQxDGtpRNhu0mbJq7Ei/q3Ug6f2lGRBMgdcTfQMc9vgvLaahCU1jceSwyb+IeK1UlE86oSMjHNN1q45qXCxKxx+sppVyIBhfEEFc8AubutTHMV3/D9QHEECh8nj7ILooUiREjvajqjX+ESssCGng2WoCWxIZQwlmC5GEFgqlT9A96ufTbzZNR6j54zek1aCoSnzLIQhTEl7nPkePPN/uI7ag1b0z8u2ZOFasl2IL8WtmvCEy728B9FbpGdw0qhmk2Is42BTQhHBUBpjQaKeqqjH9DgSgjeFOmoXvz6B+EMX6HXIlx9SnfHfW+PcVQX7LSxdGMuHRaXaQCkWz4diHyVtiTzp9x
 1RHM6NtC
 kSxPVREE4cXvqRT7r/UQxBxJbpW0GSrDS8AYsdgaGuPaG28cCcf/HbnLr66+4/QGO3reQxJmGZYGQGwsq0V78KxDf8olVC85wKRVa7mzFNJe+fkoQy1P2bFx6XleKSANBcnqrSkkaLza62eUOKtUlWYGoYP5G2FVjoSGHbyKLbttpRarEyZN+GC0JUXyIlY0ojvbuCL6g5bOSxceU1gDDbKXKsXp0ldHn4oEt+CIxZJr9RSrlmwkEJhaXEjE34s+3huphfpDi/q//9NbGQKHi2JuoEPDhetbWewt43EwZhGyPoDnFQP2ZEAPGnU4mo+6hJdKE53Uodw1tJF1UIQNaoaidXnUCbjBlUWUpcZ215/HNIw4UKfZDbbSR2z0rBp9Mdiv+t3+SpITB1wFxWFahbUiHMv0KaHE0ntQuuIBLL5hhltt5JzcpC9cQ7rwWkFiewS9B7BuZtZck3RyJJh4vJf6EPOCY3mH7XNGOkRz4lWm9cfWl94/0FxIjtRgSlpXt7P1B+Bv7FA5CqTVVezE1LzMWdWdFKSotdCmPZFTtrMeIpAtQUKqa/DJtew==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Feb 1, 2026 at 9:39=E2=80=AFPM Matt Bobrowski <mattbobrowski@google=
.com> wrote:
>
> On Mon, Jan 26, 2026 at 06:44:13PM -0800, Roman Gushchin wrote:
> > Export tsk_is_oom_victim() helper as a BPF kfunc.
> > It's very useful to avoid redundant oom kills.
> >
> > Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
> > Suggested-by: Michal Hocko <mhocko@suse.com>
> > ---
> >  mm/oom_kill.c | 14 ++++++++++++++
> >  1 file changed, 14 insertions(+)
> >
> > diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> > index 8f63a370b8f5..53f9f9674658 100644
> > --- a/mm/oom_kill.c
> > +++ b/mm/oom_kill.c
> > @@ -1381,10 +1381,24 @@ __bpf_kfunc int bpf_out_of_memory(struct mem_cg=
roup *memcg__nullable,
> >       return ret;
> >  }
> >
> > +/**
> > + * bpf_task_is_oom_victim - Check if the task has been marked as an OO=
M victim
> > + * @task: task to check
> > + *
> > + * Returns true if the task has been previously selected by the OOM ki=
ller
> > + * to be killed. It's expected that the task will be destroyed soon an=
d some
> > + * memory will be freed, so maybe no additional actions required.
> > + */
> > +__bpf_kfunc bool bpf_task_is_oom_victim(struct task_struct *task)
> > +{
> > +     return tsk_is_oom_victim(task);
> > +}
>
> Why not just do a direct memory read (i.e., task->signal->oom_mm)
> within the BPF program? I'm not quite convinced that a BPF kfunc
> wrapper for something like tsk_is_oom_victim() is warranted as you can
> literally achieve the same semantics without one.

+1
there is no need for this kfunc.

