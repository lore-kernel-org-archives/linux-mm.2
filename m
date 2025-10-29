Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6436BCCF9EE
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 23:53:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F58E8E0119; Wed, 29 Oct 2025 19:53:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CD3C8E0106; Wed, 29 Oct 2025 19:53:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60A4D8E0119; Wed, 29 Oct 2025 19:53:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 50E818E0106
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 19:53:23 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0198A4A237
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 23:53:22 +0000 (UTC)
X-FDA: 84052805886.10.64CD262
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1F0E0C0003
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 23:53:20 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DFfhV5IE;
	spf=pass (imf10.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761782001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tPZgBPK4KYbf0wiRz1OKb0KetLC+LXdJvV1wxFVXEDg=;
	b=Q487KfusZifGaFQwtpnxtbnZm/En0XcRClQxdu5+CvUYG/ORMuvs3Zi2icMAlqv8JeA1jT
	GayYmq1e6eZ65pNR8zy2RFe0CML7azQaELlNrdXSfqPKmV3txr6nXicJZlrzeGkEXqQ/qf
	DW8Ko3XQFY07GRcAbwIA4/9Rtzn2gKI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DFfhV5IE;
	spf=pass (imf10.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761782001; a=rsa-sha256;
	cv=none;
	b=V4iL4ZM+xn0pyuc/s9sARCWAZaWVXOUzWO81thDFMHGHw3zk5u4Z6amiUQyLx8++5DKngj
	Z8mcVaIznDi56Z5mrwhICTh2mG9dmzR4VUM+m9/8TNxU0a6bct2OnqbZT5+8fos13ernEf
	gfYEQKZsXsIiOTHp7/Ut+YYnHBjvRCs=
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-42421b1514fso250297f8f.2
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 16:53:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761781999; x=1762386799; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tPZgBPK4KYbf0wiRz1OKb0KetLC+LXdJvV1wxFVXEDg=;
        b=DFfhV5IEEOrhgXanvypbvrvFgQndP+wTW55xkTckH8Jtfbo6XIf8Er+kjSjHbJiBFZ
         xysrwl8fjy6OnUmYWJ3nnLYNNtnI78gvH3g3kucb+u8lXOvQ3/tNARLfKuhoyQlFWmrJ
         bAc8YMqDZZy/s80oJwso0YQeeN+DMUy5Ki8FS0wjJExkL6UuiGJdIhC4HRWQBn1Mh5Gg
         2CuDhsIJ2bFrP7JSGaqY1o+CzN0IQH45nrwgrQDZyTZNoWCu7lclYgKMRF5rQHUfF6h3
         G49TQTeZWihsKzoYPlBHoI4voxfsSjr26ZnPiqJY0+stHIXGojEaUKUtK3Ip5SVTfyp/
         d2sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761781999; x=1762386799;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tPZgBPK4KYbf0wiRz1OKb0KetLC+LXdJvV1wxFVXEDg=;
        b=oGr87L4lGpjv7CQ23iRsGpjqyfWsaaorEFGTxN2JN33ZL/YWPiyeAWRhFUadh1JwCM
         8Ghx+bXlDUH9bEjhK6P7KLRZN3XBmW5QkoUQ1eCVTi3UYVnHfrJtz/iPN4/8y/2NnQQi
         vDrNjseRxanU4WYwtSzFq1q9VmqDRutzr3Qxk5q70Lz8pHjUT+GXDZN8TTfolHFyIJ/5
         2CFmW/xs0kESt9kkvUQmmh9/7LgAgZEapN0mXXYNZy6eO69UqAcm5ypn+qnrswAbTCZW
         Pf1DZE1ZXhQCevmQNsds3pSvcaT5oJuq38ya85qPN15Ho4WX5yGE/ftma0dZB1nUG4wQ
         kfHA==
X-Forwarded-Encrypted: i=1; AJvYcCX8vYk6rYCla0j+36IC+gjo5j0J6LGdrVfrEqIi2XZcdwva0tFTNxVJw4gli9I6otumJFNURaCOdg==@kvack.org
X-Gm-Message-State: AOJu0Yxs/YqAunOHTLhGKLSa09n6suRisRVDo9zawVi2ML7vYJC5r7NH
	kn5rmEuhqNP3fhIUwJW32vcs2WQcXGuGoQdQUOO1QfgT8Yy8pPsGFq51an7/mZd05zHpXK1UZFJ
	XgaUTq/+leKbkGPa95illUazj5UzfUsU=
X-Gm-Gg: ASbGncsowDuFZIV0cusCXkjsmcjPQDQUl1VpkB6y4o/BZ6Lijn0+cpd9A7QkrtU/gVb
	GpkU6u5oqbP+fCTmx0PZGeDevQhurFiqslMnbqEye4Voi7KD8k7Xf9oY30LuMDa9bHzjESLawWy
	65E0NQF0gHMhgL9EdQH5r+QCkMT6bdElnCv+b0IGwUzAGm0WkY2/LpJHOMPAqfj00bG5cw8KHxX
	ciOc6zGGgv1cjxzSJAW/RWoxYieTjpkavjccRwJlWA/jzAk8xPcXNVJ5RaW5fAmWF567GEBkmE1
	XKxwlvsPxKFB5+EiGA705ioiM8/q04VZbj0ENS0=
X-Google-Smtp-Source: AGHT+IGrKp5MfacnbzNbpqAIhTO7ERG2WHtS4t6jru8KJPhlxG//rUzfqdjALv0fSxc61RpV8oyRKHl4WsT9w4GfLtM=
X-Received: by 2002:a05:6000:2005:b0:425:7e38:419f with SMTP id
 ffacd0b85a97d-429aef82fd5mr3552778f8f.16.1761781999226; Wed, 29 Oct 2025
 16:53:19 -0700 (PDT)
MIME-Version: 1.0
References: <20251027231727.472628-1-roman.gushchin@linux.dev>
 <20251027231727.472628-3-roman.gushchin@linux.dev> <aQJZgd8-xXpK-Af8@slm.duckdns.org>
 <87ldkte9pr.fsf@linux.dev> <aQJ61wC0mvzc7qIU@slm.duckdns.org>
 <CAHzjS_vhk6RM6pkfKNrDNeEC=eObofL=f9FZ51tyqrFFz9tn1w@mail.gmail.com>
 <871pmle5ng.fsf@linux.dev> <CAADnVQJ+4a97bp26BOpD5A9LOzfJ+XxyNt4bdG8n7jaO6+nV3Q@mail.gmail.com>
 <aQKa5L345s-vBJR1@slm.duckdns.org>
In-Reply-To: <aQKa5L345s-vBJR1@slm.duckdns.org>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Wed, 29 Oct 2025 16:53:07 -0700
X-Gm-Features: AWmQ_bmmWr20Sr7nISe9-dxnu7qiuhrtBr-MHR5CpH7Nay8Y8PduHzn8NSxStmM
Message-ID: <CAADnVQJp9FkPDA7oo-+yZ0SKFbE6w7FzARosLgzLmH74Vv+dow@mail.gmail.com>
Subject: Re: [PATCH v2 02/23] bpf: initial support for attaching struct ops to cgroups
To: Tejun Heo <tj@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, Song Liu <song@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, 
	Alexei Starovoitov <ast@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Andrii Nakryiko <andrii@kernel.org>, JP Kobryn <inwardvessel@gmail.com>, 
	linux-mm <linux-mm@kvack.org>, 
	"open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, bpf <bpf@vger.kernel.org>, 
	Martin KaFai Lau <martin.lau@kernel.org>, Kumar Kartikeya Dwivedi <memxor@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1F0E0C0003
X-Stat-Signature: 1zweduj1ddcnpncxq69mfinxu95amtbr
X-Rspam-User: 
X-HE-Tag: 1761782000-115427
X-HE-Meta: U2FsdGVkX19N3wezmujZzIC8a15fysO1S9TUXY1OsyWqWQ4DzK8edHpOW1D7Vtuk1L6En64inYAxlbLu5T2UrbyNxPa+ZQAVToutugTXlZi8LXfG3DKERzPZGhkFg/qowNFi1wBEIeBGsK+kN5rKc1UFa7EykbufekT+Qe6TZa6y97AbzgS8uf0IgbcQ1Vm6nQ4AiV+w2TXxsWWF+b3O1ZWyoGS89jUFqQDlpW+7nnZZcMlrVWfXmiPyPxyXVROAY6y265Kw5OKm7jAuI27LYII5I0MJmNgAC+ZEI6w56T1w6ea5oVd8VruQK8kyg0AbEC6B2oH/u/qVlh4fgfSI3QyJAnQ17kgxRbcoY/nJV/pdaRJi60fxTLG0341djDMgv18matxPOoeJXeRFQHXuoQpPrgtmyaYyaH0CiqZl09EGpWIiaJkeZDbEUp6RWp2cUtXrQDgduyiUToiUHnujr8vpbmP4iwGJE3/woOr76sfwvYVFuBnM+W5psF4ABbJif731qeqAuNdk+da5gXnCy6iTsRVUU/oplTFEz6P20GjpBeMTtp4Om0s9VhKiyxIysQKYbAh8ivchMfYuXi7jNV5hyMJ1UK02w3a0pztqJE+xYRum4rKeOIysdpDm6oTBgWAsy6HD2oaSo0N0BdK3i27B8qkz/Fp5rUY/jC90WVhiiH6RBK+LocAsHm6fDZ1NYDNONWUW/gIoTLqXA+C1hwNzHsW7zUE9+F+hr/hOUgeXLTScq1iojHh7UMql6q/zYbbQBsy3juG4enbOzdU2QuEFXsSYJu08zAwDzNHw0+c0FA0k8B7fqhOzgqy5DIMv/dPPlcPwPzHeKm7bi6/Mm1a6rzNWuoDtaKmmz+aYBveNyd3gAwD6hqlF7JW3IaqpTxB8XGKg+LQfzQ9t1B4AW0D3BhFd5XMcXAYOx8GgaPwvj4PtmHQ7VLY48WgASebwZOCflZU+N2B+VACgXrR
 Nh5Petfa
 SeNzv6cLfbU3barRDlL8iHFmXuVkL5ylWufcJ18VTmKaijDwcVCUc2XRu9BjXV8MZ45MKa4StNDYgAw7fOb2qHbUWm3C6Zxp+YsA4SJvvWez83B//NFcRxA3ARsSXk7VBKn5vZePjT+Sh94uNt5iaIk/7dcrJOdB6bh0UA+tEEit6ZC3fL6e0FEu/x2ccjtPQ8AQMV5C7XylyX5M0WgPJbq+ogSmEBFLAUxP3e9ZDJecBQczIBQgoVatJdZhN/8IstujMu4zxokokokTGYVafwiduvF/14DrgxPWLk6eKWl+1sh5RlfQyNVzGmWUXW92k4Z7UR1pOuncLUmasap3YxqzXXg5EMxlhjpEkmxHJnGWfUzDHihE4WaRq/Fbp0fjVfbOTcRrwAY6Id+8tp287BYY8Mbo+uZJ77uSa
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 3:53=E2=80=AFPM Tejun Heo <tj@kernel.org> wrote:
>
> Hello,
>
> On Wed, Oct 29, 2025 at 03:43:39PM -0700, Alexei Starovoitov wrote:
> ...
> > I think the general bpf philosophy that load and attach are two
> > separate steps. For struct-ops it's almost there, but not quite.
> > struct-ops shouldn't be an exception.
> > The bpf infra should be able to load a set of progs (aka struct-ops)
> > and attach it with a link to different entities. Like cgroups.
> > I think sched-ext should do that too. Even if there is no use case
> > today for the same sched-ext in two different cgroups.
>
> I'm not sure it's just that there's no use case.

I think there will be a use case for sched-ext as well,
just the current way the scheds are written is too specific.
There is cgroup local storage, so scheds can certainly
store whatever state there.
Potentially we can improve UX further by utilizing __thread on bpf.c
side in some way.

> - How would recursion work with private stacks? Aren't those attached to
>   each BPF program?

yes. private stack is per prog, but why does it matter?
I'm not suggesting that the same prog to be attached at different
levels of the cgroup hierarchy, because such configuration
will indeed trigger recursion prevention logic (with or without private
stack).
But having one logical sched-ext prog set to manage tasks
in container A and in container B makes sense as a use case to me
where A and B are different cgroups.
DSQs can be cgroup scoped too.

> - Wouldn't that also complicate attributing kfunc calls to the handle
>   instance?

you mean the whole prog_assoc stuff ?
That's orthogonal. tracing progs are global so there is
no perfect place to associate them with. struct-ops map
is the best we can do today, but ideally it's run_ctx
that should be per-attachment. Like cookie.

> If there is one struct_ops per cgroup, the oom kill kfunc can
>   look that up and then verify that the struct_ops has authority over the
>   target process. Multiple attachments can work too but that'd require
>   iterating all attachments, right?

Are you talking about bpf_oom_kill_process() kfunc from these patch set?
I don't think it needs any changes. oom context is passed into prog
and passed along to kfunc. Doesn't matter the cgroup origin.

