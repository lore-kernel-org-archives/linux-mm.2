Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 172B0CCD194
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 05:47:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73B818E0007; Thu, 16 Oct 2025 01:47:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EB6C8E0002; Thu, 16 Oct 2025 01:47:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DAEB8E0007; Thu, 16 Oct 2025 01:47:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 46A048E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 01:47:14 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 507FE1601F8
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 05:47:12 +0000 (UTC)
X-FDA: 84002894304.09.A6059D9
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	by imf06.hostedemail.com (Postfix) with ESMTP id 59D9B180006
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 05:47:10 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=uFm+qEMr;
	spf=pass (imf06.hostedemail.com: domain of kuniyu@google.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=kuniyu@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760593630;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MA6mhhqCrmj7IiS/atA26gzsL8vdKi8INK9aHEVZuHc=;
	b=3QgCk7nMGQcaT7H/EkLOEDCmMzOFlVeGU/7hzfbGkKl5bAlVONSP/V2LDID6UKDwkmxjj+
	CnlNOPF4B9/ku6v5+CTas4r+QFy+5fh+CkgiY6iMkuRT2OwnaYASZNgmzYDhwiqtTliHQU
	Gc+hDAYZ3hWoytOJ6TO7vcKF9swZ4qc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=uFm+qEMr;
	spf=pass (imf06.hostedemail.com: domain of kuniyu@google.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=kuniyu@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760593630; a=rsa-sha256;
	cv=none;
	b=QhwMRZkueWaAfTH/aAHU5LoGOFTGgzzihnpMWZAiR6ktKMCao2Vc2AIKQdqVRsR75sh8/d
	UDPGDaL2yZ6TPXujkfor581UIMQ8GJjBm7b0pUEx3DeoIkuVdOUUA6kIjy2z7vkfE8ogvP
	W92+vh8wiHMyvgi4ndHznDN1DD/dJGE=
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-63b9da57cecso578005a12.0
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 22:47:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760593629; x=1761198429; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MA6mhhqCrmj7IiS/atA26gzsL8vdKi8INK9aHEVZuHc=;
        b=uFm+qEMrdDpQ4YaI5VBbnY+aknGFd7WPuAzl3fBJ4DXfT+Dqy5Twt2XRGm9r5errzJ
         F6nD8njx8rN5kMPcxpgS68zyo8c+d45u2PdiKE4Z9UhPpDp0QCgBSZKdLifZrpE4JDyt
         GWT2fceuWI7cqf2Ut5DcBm0IgU5lNEujZC6x9RqAsijWE0+SPDQZfHu6qQXhUS4SItM2
         0ZW39Gct6rsVGmbP8EA4MBqxbwLdWwMZmVBPCa/gxrcqaXIizfhzXCmvFmjAli/Segme
         3zPd3LgD0ar6LxvMfe6J4odRGuVIePoI7Demy/ID62qEJtEIwRqCU0VxWDyX7m8VZMsp
         QriA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760593629; x=1761198429;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MA6mhhqCrmj7IiS/atA26gzsL8vdKi8INK9aHEVZuHc=;
        b=HcdGaTvrzNQY/g59MLxU2QPdsPgGBJloIZYV8Bm2qydVuKhKiuDghQD4JEAafifpE4
         cl2kgqwlBdTJuBnh9w0ZdG7tA+OI3KV2r+X5bXCO/u5EA78rsSsuoAxCCJBMzcyen282
         swHSGVeZizidhi0QOjg9eSwBEc7mYVslCcI0ePaxFlvyB8p3CwuYfCSSHfXoNDJv4Rz6
         IN5ZnabJyyavKfDo5V8XGcidP8FVx+uAooYbDKrCYKjgD6yvNUBUixiiYaqWVD1EnNdx
         mLsaMxdQLSkK11N5sgam9W5gCBCDkWqQ2zpmfQ9BYEgmyXWpND4mvzgWtvLr9wWNRVrt
         fmQQ==
X-Forwarded-Encrypted: i=1; AJvYcCWJZw7h1iI+Tzkx28Y1E/OxmnW9axkLjkqunSmlfKkAjgxCNPS1SagURF0QCHqjUAUy2DdOfG5Khw==@kvack.org
X-Gm-Message-State: AOJu0YwnT+B+8Rf/TnNmUD9N6QUa+BTFs7TtQVVfosm7yzbjKemJPBB8
	yvOR2mOgm+wQO+ePuZLRR9btnd8ck0XIaPc3jw1fjywuVE38rlmz4A3vMnOdSbO6TVgwDUkMbqB
	Tmp/dsTitPJyqrXq2bnp+PlKE+zchvuoEXavmM4Ay
X-Gm-Gg: ASbGnctgFCVTC9Nadc/OCkFClP8uAIa44RKXEHerIO15umUkUbINI50fTphmwu+tHu5
	qSit20zOE/WTZ+ZR95IMV1ck8jEsVBHlNA/Q+rvepOO/45ReucgJKhLyyHM6bTdRzNKqiAAsnSe
	dodVg2dAh603yPAlmr97LAE9hEE/Upc8+5+8q6+Uxkx+m6OQyFkVKdY9C2n9kfH06nJKN8NkRtz
	CO2cwpic9ly54JQkP949Eenb9b0cuIAKiEluLO9o6w7a31MWHMrPqaIyqjs46KO3oplZKMPwm8B
	+kenwbwZVO3UmkgPdr4HRGN5iydpe4DdVlg=
X-Google-Smtp-Source: AGHT+IFzw+sm9kmi/FXeFTMQBBNhRcBK3NKNkQBYJXmvg92GJWyWk0z/4dzc7vdtFnEF/yXk7jod/id/D4o55kM/p14=
X-Received: by 2002:a05:6402:354b:b0:63c:1171:b8d2 with SMTP id
 4fb4d7f45d1cf-63c1171c22fmr260689a12.32.1760593628477; Wed, 15 Oct 2025
 22:47:08 -0700 (PDT)
MIME-Version: 1.0
References: <20251016013116.3093530-1-shakeel.butt@linux.dev> <87o6q77hfn.fsf@linux.dev>
In-Reply-To: <87o6q77hfn.fsf@linux.dev>
From: Kuniyuki Iwashima <kuniyu@google.com>
Date: Wed, 15 Oct 2025 22:46:54 -0700
X-Gm-Features: AS18NWA5RQWYnfsEWfydqaWHIyqqFuKRjGF0eqaH-MLEpN4EhdsHRHE5mpgYePI
Message-ID: <CAAVpQUBXzBKfbH_iqn78k6d7ys9DNrXTVbnYSD4ecuKwgCwk8A@mail.gmail.com>
Subject: Re: [PATCH] memcg: net: track network throttling due to memcg memory pressure
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>, 
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Willem de Bruijn <willemb@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	"David S . Miller" <davem@davemloft.net>, Matyas Hurtik <matyas.hurtik@cdn77.com>, 
	Daniel Sedlak <daniel.sedlak@cdn77.com>, Simon Horman <horms@kernel.org>, 
	Neal Cardwell <ncardwell@google.com>, Wei Wang <weibunny@meta.com>, netdev@vger.kernel.org, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Meta kernel team <kernel-team@meta.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 8rksfacmdu4nqfkd3dxxgxcjog16asej
X-Rspamd-Queue-Id: 59D9B180006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760593630-938720
X-HE-Meta: U2FsdGVkX1/CcjyJf/9gwEA1/VxOeQx28iWr01Ttf14RG1DhQLEsJkIIGvo7nquCy8qmMt5jZYhd3dbjHjDfYPl6gltjv/HbaJGsnZhZz3PLaO2nkNxnfecCxsnsDMMP/EhooR8j/fuzUKJesMS50TgsE/FoO3AUewiR+awYdE/VTNFlDBjXrKah3s6EmmON3HM6rX51VY6rFEfI+aouOkHjYS40BBrtqx38Vu6bNEuRk+7LiJ/gSK4kTeuErBLcsAhCzFmSKX1oOjPLUXeQV8l+2firakc9ffa2YGW6g8FsVLwHg/e7qQNLXu8HTMzmHCg4RvunLyfils/j+P4VQg1FxLVq6sIpUKXeFZU6DuqoouXUAqLyf9BmNg4js8eIy3LSDhaWSTgeFEt1hhg5z24sF2bslFw6yxXX3PcAVO89iYHT87sFus8+j476jEc6EE5S2Iro3TqqCoWYW+Xk2MUoJ1Rep7QSR+aR3zJLClOKAJAUyKjN/A0ZgxyHK7SgVL7CVnIh4i4mMUsybuzAxgH3BAsJTKyJjWYp/6BbygAXeKup/C0Dwkem3UZpDzQ0EKR+0/hKx3M8mh7Cr79D/ZDx+8VYwH3qdQ0f2fmaigixH16K5rw9n/NyxkTBnpO1Y0dAIlKK00wWpn/QWIYB0i9ZgmYYNjmC8+8xLW7wpkqHvMlz2pIeN0F7+wUI9NG7FhUHtX7osFM/Q8ggz7fAkr1RplRlgk5KRZsxBplwVAK8n6cpfyjdrbjhdkx2Mv+gpIDJ2HhQKahNNujnKK9xko06grChfsCw8GSiW3GToUNTJ1w9FQJ8BLH7VJNivM/1GH6pHCrUZOkHz/OBkTYok4qYXm36kXdU4kOOaZ2jqrOVh4bLwOA3i3X5t+BpmsagJETR8ThJmv3fo7nJSL2eNf4ioL21mufjgYjl+/c7CKokkvASVxirLn7x/r0i6AIkjcskJAlW+gmTub1LVme
 4+9r5fgq
 AMF/wO/Ihz4JRI64sjv7NS0qFmLI2PJjmvd/FUejszjwFuTaZcMrKbmRRPsa/vQ1ckw0Iurm2OshQbSxdCINW5xOmQOzS08nhPpuSPwc4CvVcZM4Ijq2VojF9uuzWNellN1tuG6Q025haj9lwNDTECxfXsOv6MfvRQ9QTKUY2tjoQyEsH/7L25cMBaDoQn2mg9Gi++s212mIS5d/j6BSVfZpBYmCZoGah96mgUdqvQ/voRx3f77lIJMeLOxJ+C/7UKUl2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 6:40=E2=80=AFPM Roman Gushchin <roman.gushchin@linu=
x.dev> wrote:
>
> Shakeel Butt <shakeel.butt@linux.dev> writes:
>
> > The kernel can throttle network sockets if the memory cgroup associated
> > with the corresponding socket is under memory pressure. The throttling
> > actions include clamping the transmit window, failing to expand receive
> > or send buffers, aggressively prune out-of-order receive queue, FIN
> > deferred to a retransmitted packet and more. Let's add memcg metric to
> > indicate track such throttling actions.
> >
> > At the moment memcg memory pressure is defined through vmpressure and i=
n
> > future it may be defined using PSI or we may add more flexible way for
> > the users to define memory pressure, maybe through ebpf. However the
> > potential throttling actions will remain the same, so this newly
> > introduced metric will continue to track throttling actions irrespectiv=
e
> > of how memcg memory pressure is defined.
> >
> > Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> > ---
> >  Documentation/admin-guide/cgroup-v2.rst | 4 ++++
> >  include/linux/memcontrol.h              | 1 +
> >  include/net/sock.h                      | 6 +++++-
> >  kernel/cgroup/cgroup.c                  | 1 +
> >  mm/memcontrol.c                         | 3 +++
> >  5 files changed, 14 insertions(+), 1 deletion(-)
> >
> > diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/ad=
min-guide/cgroup-v2.rst
> > index 0e6c67ac585a..057ee95e43ef 100644
> > --- a/Documentation/admin-guide/cgroup-v2.rst
> > +++ b/Documentation/admin-guide/cgroup-v2.rst
> > @@ -1515,6 +1515,10 @@ The following nested keys are defined.
> >            oom_group_kill
> >                  The number of times a group OOM has occurred.
> >
> > +          socks_throttled
> > +                The number of times network sockets associated with
> > +                this cgroup are throttled.
>
> I'd prefer sockets_throttled or sock_throttled. And same for the
> constant name.
>
> Otherwise,
> Acked-by: Roman Gushchin <roman.gushchin@linux.dev>

+1 for sock_ like "sock" in memory.stat and its MEMCG_SOCK.

Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>

Thanks!

