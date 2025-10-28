Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50825CCD1BF
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 17:47:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC0E28019D; Tue, 28 Oct 2025 13:46:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C991F80199; Tue, 28 Oct 2025 13:46:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B87E28019D; Tue, 28 Oct 2025 13:46:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A119880199
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 13:46:04 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4214114050F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 17:46:04 +0000 (UTC)
X-FDA: 84048251448.04.5517F9B
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf09.hostedemail.com (Postfix) with ESMTP id 403AB140012
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 17:46:02 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bOvK8wbY;
	spf=pass (imf09.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761673562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z8o8F76IUU0UbQ0/2SRvS77TkF8M8+mUDrHHUTizJsU=;
	b=3ZDJ6JD4+dqytJQLKqsXtnCrarfUOaiW+bZTY/fKcVbEFqSQUwIw9qOYlrBmtMCjr7itMe
	Z0uLnBZvPg87rlN8xc6KUOTNp366g+6k+sSgNkyj/c9fF7GSoe1mMv0JjVrNb7rPUfUPEj
	KOmp9Jkd0wLVNhtME8sPxCBeq4GNHVk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bOvK8wbY;
	spf=pass (imf09.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761673562; a=rsa-sha256;
	cv=none;
	b=XrCOWRFVsGVNYgC2em0EBCyUniuDY6UXUHTTnQck7CjwA60TolGvcGcgpGv2C6zI4cO4ZP
	heyHTjKZjL5enpVqyJuDBH0xFHsvXZnaTSE2a7jfONsEGK+xlGDNWGGr37HhR2xZVNuqAj
	XQVkG1T83sRTeGTUUdy9UmrBtBGGnL8=
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3ee12807d97so5837226f8f.0
        for <linux-mm@kvack.org>; Tue, 28 Oct 2025 10:46:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761673561; x=1762278361; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z8o8F76IUU0UbQ0/2SRvS77TkF8M8+mUDrHHUTizJsU=;
        b=bOvK8wbYwXeslGr1oRxUTZaxOmtubaR6ApwjKIJ5UQ93L+GLaVXBR9VaMjIJcmXQzt
         B4/HWKs14CmJVA74dCJ7bmxZHo7LiqRGVSd/JwcJ9Qw3PCgEtpKFwPe7RnnHKOKnh44p
         IG8OlW0qaNjcR+Ntxg+mCIrldx7DnUpwy7vwW+G8ALcNDq+25SWQkLiFA/FpaDU/Mz6i
         cKgxhkyLNIGGsrqd7FpiVBEtdRQel/NTu6RGxH/3C/N9//JNt5QhWgfv/42z5yJ4D6i4
         7QGUxjtLF0KSHi2WFIraM1pSysp4IEie1zqCuTMmSprXIwrT69HBaefhfg4ZrXEBb/ah
         Jtxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761673561; x=1762278361;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z8o8F76IUU0UbQ0/2SRvS77TkF8M8+mUDrHHUTizJsU=;
        b=MQonrExeruT8/CJIPWYTWH5r8ZekFMLcPT+s8mbofpeWCWqHoEFOkazhh6DdEe/EUN
         uFSmL7GqdV9ByOanZam04XpopoLrkt+5BM4wWYlI+nRz/mW4opKdB1G0NAI07BAc/nJK
         5rWFF8ZzmxxMzd6UQ4+PgJ7sq4naPdhigdkXld9MivUzajrQ5a/bEFVMw9GjP3RU2v3m
         8/x9gB5nL1/6U51hYlmZ8irYAD+1JNqgQVMP7mWleHBaAq1Pc2IoZsU+tAoKPvoEzDXG
         0WVGiK37LOXHV51oe5lN+AzIF0ylSjZOZe0R49J6eP+XsqfW7X5tSP6tqyHQshnV3CF6
         hWLQ==
X-Forwarded-Encrypted: i=1; AJvYcCXX+20pWOemCJMVRL7UlLXB29KbZQoZvkau6VnvP7SKfrTLubfqEqM3UDrLvyF5Q7a1+IbIPZr1uw==@kvack.org
X-Gm-Message-State: AOJu0YwA/ymd5bOecBSC/pzm+E/pkNDa+3057zp7YXO5egldx6EfUUtE
	Fr5eFyuTZmaW/8WqMSJwQlaSd7eYJBDRtnyrXaIb1vwumebxAD7jM2zNcHJUG59bB39pAYc30P+
	ebF8QZcb+d/p5+6r+bxhkWvg5Uh4bUiM=
X-Gm-Gg: ASbGnctVUt32ZQABi3II8wsSrMI0A0fxosoC8AQMZc/g+pEtLt+QzuWol91R6Qis1KH
	aCpbDDuOcObCl9UOhRWtCSnBcEwDT7mU9u+hhYZF5uzOeQwjEtrHC2FHWMqffrNKz5akcm7u4QI
	qU1eH6JCS0cFBWkBqwbtpwH7nYPQLKI+BvOe2lL7Y5+2RIVUM6J8UPz+tBXo9VOd5MHf+4WB0k1
	jv19PgaJS/xeI2h/aab/9Or7FlXSAZKILzB/xS4pXQ4aRLeo7rCkXPEtrH1hpBHtQjn841dGPRy
X-Google-Smtp-Source: AGHT+IHdC935jXGEIZNQ8BYD/ANRC6JF/uyaxHO8iGt25M0BknomRTBrWpakBaxhp4hLDP8/bFuayzs/ibY+/MUNENI=
X-Received: by 2002:a05:6000:3108:b0:427:6cb:74a4 with SMTP id
 ffacd0b85a97d-429a7e7a1b0mr3757740f8f.39.1761673560565; Tue, 28 Oct 2025
 10:46:00 -0700 (PDT)
MIME-Version: 1.0
References: <20251027231727.472628-1-roman.gushchin@linux.dev> <20251027231727.472628-7-roman.gushchin@linux.dev>
In-Reply-To: <20251027231727.472628-7-roman.gushchin@linux.dev>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Tue, 28 Oct 2025 10:45:47 -0700
X-Gm-Features: AWmQ_bncnJypaBtdt8pXLZmr8dzBy7-unV831zo2gE3qs0GF1C9pXA_M9bOiMqw
Message-ID: <CAADnVQKWskY1ijJtSX=N0QczW_-gtg-X_SpK_GuiYBYQodn5wQ@mail.gmail.com>
Subject: Re: [PATCH v2 06/23] mm: introduce BPF struct ops for OOM handling
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, 
	Alexei Starovoitov <ast@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Andrii Nakryiko <andrii@kernel.org>, JP Kobryn <inwardvessel@gmail.com>, 
	linux-mm <linux-mm@kvack.org>, 
	"open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, bpf <bpf@vger.kernel.org>, 
	Martin KaFai Lau <martin.lau@kernel.org>, Song Liu <song@kernel.org>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: rs3xsc1ffeyf8yu9c9iq7mbkqh8ai715
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 403AB140012
X-HE-Tag: 1761673562-640640
X-HE-Meta: U2FsdGVkX1+ipy8T9saGgOKTHzIMsBxF7/XPx6uhbXWakVrFDHrBX1k/6JHIzOhmRD3th9ywiLfDf1pQQDaPiA5fEeYHE3I6N4r/TQ6swLM/gKBPsYcoYg7LgRpO44IHxfdfLUnKV+xCjJcO/vTbHRcx3/4oeC6i9PwkvfkqVVo2mz9kUaaYEo/u8W6xP+Rm+8a2+wexE06gFYU7Vv/147JLRuR3R4R+rMc4OYKEtOeVmfEHYBMm9JYqeEBx5NRuITHxnx7KGw6JLYH8g/oLsbYqe7yZKXAHA0z9Ph5VB8dordlYO/PqU/RH/gs2mPZLwbxK5jc83KdeKzpM9BXtb0HfXlu/c6ewfu1KwmVB1NWVBb4a41qQrRhVwb/M3hdgc8D/LMBXgH7vG4grl08yYUrh4mYOd6DUBqha40ZrjYKXnzjn4d3IIWzq1F/X56QRlu1kbO7qt8sonYA710SAmvabJ2peTsYfkfHXDxwnWCehzrhvmxWqltJA8uqWhibTJzUjfLXfc/hqnGRzKNOaPJR61ZGI2g68y/RQc1GE6OhTgS+d4KtjxVo2m3pmVC0lCDtGnSXLtanpUbHF0hEf54EJzs7Ma/GaDDWOrKKLbBEhIib8ugD527wqGxRf/vG2w2FiyXnpWd8Io3E2kwT79vXpcYhr7MiHbIvMeEMwOiyxbBtfYgVCeJWPzaJ8HiQtyUKyWITFfoToQpk7LnterLUHTS6J49wZgJaCXprJ0p0IjdQKcLWaSLaF0Tg2HwM5Jt0CFK81pNvqO/MRudisfq4SrSaKacejgbFZIps+AMnPo9G/3O6aa1lmbGbeYLYhktaJ387gS1danaq7QvIJs7dyzYpzwZA1dRUPT1dJlkd+SOcWAu9+cgS5V0uroABAfwnZYc9qW69et1FU78P4hxFW3Uk0004WGiXtcpIDBosS7ipBPcIR1JuSCTrwB8gQGolYv8fki5I0ifpUjrL
 0MgfqMZG
 frAyrK+7vbT843powl5rtEmvo09aCs0TjkpStwnXjHEES9JrlUy7mXczQCHX+nKQEDeR54DOeCkqfeebbvDi+C1NKQFYz2FUQGoDwN09jit9zkJ2cJBMChi7K9Y22Ef2vCOA0F8P2vTWfkWg/kMRuc4S0SgwNpCe1gAGkvsbI3HD9KrXADRxJk1SYdg3ho54Y6rfMA/X9ytKjxB5oljfz6Zzn1Zipw4nRex8l7/Co4yQqqV/NR8/2wCQFJVovod5PwxeNKB/JhW7eQDkd1FsXvSxOS/tYOlvU4r/FCUPweZvLvRWjnPt00AekxuT8wxyryYBx1deLkg3Bc1avzdI8LygV5y8m1MqIbKIPJ+XUWoKW/XKdaKHWjlcu4XEy+HSRSQv2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 27, 2025 at 4:18=E2=80=AFPM Roman Gushchin <roman.gushchin@linu=
x.dev> wrote:
>
> +bool bpf_handle_oom(struct oom_control *oc)
> +{
> +       struct bpf_oom_ops *bpf_oom_ops =3D NULL;
> +       struct mem_cgroup __maybe_unused *memcg;
> +       int idx, ret =3D 0;
> +
> +       /* All bpf_oom_ops structures are protected using bpf_oom_srcu */
> +       idx =3D srcu_read_lock(&bpf_oom_srcu);
> +
> +#ifdef CONFIG_MEMCG
> +       /* Find the nearest bpf_oom_ops traversing the cgroup tree upward=
s */
> +       for (memcg =3D oc->memcg; memcg; memcg =3D parent_mem_cgroup(memc=
g)) {
> +               bpf_oom_ops =3D READ_ONCE(memcg->bpf_oom);
> +               if (!bpf_oom_ops)
> +                       continue;
> +
> +               /* Call BPF OOM handler */
> +               ret =3D bpf_ops_handle_oom(bpf_oom_ops, memcg, oc);
> +               if (ret && oc->bpf_memory_freed)
> +                       goto exit;
> +       }
> +#endif /* CONFIG_MEMCG */
> +
> +       /*
> +        * System-wide OOM or per-memcg BPF OOM handler wasn't successful=
?
> +        * Try system_bpf_oom.
> +        */
> +       bpf_oom_ops =3D READ_ONCE(system_bpf_oom);
> +       if (!bpf_oom_ops)
> +               goto exit;
> +
> +       /* Call BPF OOM handler */
> +       ret =3D bpf_ops_handle_oom(bpf_oom_ops, NULL, oc);
> +exit:
> +       srcu_read_unlock(&bpf_oom_srcu, idx);
> +       return ret && oc->bpf_memory_freed;
> +}

...

> +static int bpf_oom_ops_reg(void *kdata, struct bpf_link *link)
> +{
> +       struct bpf_struct_ops_link *ops_link =3D container_of(link, struc=
t bpf_struct_ops_link, link);
> +       struct bpf_oom_ops **bpf_oom_ops_ptr =3D NULL;
> +       struct bpf_oom_ops *bpf_oom_ops =3D kdata;
> +       struct mem_cgroup *memcg =3D NULL;
> +       int err =3D 0;
> +
> +       if (IS_ENABLED(CONFIG_MEMCG) && ops_link->cgroup_id) {
> +               /* Attach to a memory cgroup? */
> +               memcg =3D mem_cgroup_get_from_ino(ops_link->cgroup_id);
> +               if (IS_ERR_OR_NULL(memcg))
> +                       return PTR_ERR(memcg);
> +               bpf_oom_ops_ptr =3D bpf_oom_memcg_ops_ptr(memcg);
> +       } else {
> +               /* System-wide OOM handler */
> +               bpf_oom_ops_ptr =3D &system_bpf_oom;
> +       }

I don't like the fallback and special case of cgroup_id =3D=3D 0.
imo it would be cleaner to require CONFIG_MEMCG for this feature
and only allow attach to a cgroup.
There is always a root cgroup that can be attached to and that
handler will be acting as "system wide" oom handler.

