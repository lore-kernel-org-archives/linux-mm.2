Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04252C88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 08:33:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBA6B6B0092; Tue, 15 Sep 2026 04:33:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E92286B0095; Tue, 15 Sep 2026 04:33:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D82106B0098; Tue, 15 Sep 2026 04:33:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A44416B0092
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 04:33:13 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 94A96C037F
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:33:12 +0000 (UTC)
X-FDA: 85215331824.11.BBFCF62
Received: from mail-yx2-f12.google.com (mail-yx2-f12.google.com [74.125.224.140])
	by imf15.hostedemail.com (Postfix) with ESMTP id D0D3AA0005
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:33:10 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=L80+sdAD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of kuocyclinder@gmail.com designates 74.125.224.140 as permitted sender) smtp.mailfrom=kuocyclinder@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789461190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=fXrZss0Xz8qTUZJIY56JBAj/VAShVNUcWqldnlQTcfw=;
	b=ERwSAPP/4heLihW5SHhYHRW4sBDvwEvP16TchA1SJuD7h4ubpyJjUfsErSs7c7IahrYXH0
	NshJytVOebPgFrXDrhrNGqEbPyJrhpoQkfvCbYLZqCQjSrCy9PC3Yj2MPWTFkds+JfK3FZ
	nxzqd83V5W4MVm7a2Wqpz/MFq+PbKwc=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789461190;
	b=c9HtrtfY6cuQdoSx+aBZTv/4TDOmBbWL7bfDUBYVJYOSDiSHM0AZcfQZv7+KpKYkZSeif0
	1xqmAi24NMW/rRCLGngRetL0IQOjN8yJT/7WcbVgErGOE9Vl9yIpFi84kMLBniSwvwDvKh
	eC4lnnvmAclnFey+C+kokK1IuoRk9ZQ=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=L80+sdAD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of kuocyclinder@gmail.com designates 74.125.224.140 as permitted sender) smtp.mailfrom=kuocyclinder@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-yx2-f12.google.com with SMTP id 00721157ae682-85d43da99easo28991457b3.1
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 01:33:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789461190; cv=none;
        d=google.com; s=arc-20260327;
        b=bOUUcHGpC0w7qQWbiN2mK5kdsNWdaF7Q2Yid90lT+CHxFkABfjFslNKTNmav4jlbH0
         Gf90oqBfGGzuTR8NX+bduyYR1rL2JqaNwXTh3GutuoZbjsHmHsaGPKAk3wgtRFlTN5zJ
         mVwff3QLXlB04MGsdn6Q78Ek3dwCFtEc2UvTbW6sjITIoAAuKf4khV8wlQzLjBqWfk/K
         uj4jehYfreCO1P4zbhAijqtBin/fHE89xM3Ozy84tdCQRZTxgcjHAQAGHc0oIazom4s6
         r/ufcmd7X78A3TeamiQ2xU6KMZSTzUU86zeUJGG9xDoDmbicHjN4o3VNq6LJXYrABZqT
         AnLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=fXrZss0Xz8qTUZJIY56JBAj/VAShVNUcWqldnlQTcfw=;
        fh=GKJ6JCd4i2svkIYptaocrjxsZvydyGlQWPwlcJTz8Ww=;
        b=p7I3oyaS0oM34bCz+ySFogeWh4mMVGtvkteWo+ScTaGs7/ev3Tzj03mg41OuI6Pari
         0ajKhJ9+O2aabSkSt6z9LaQ2eA8P0qSkWiGH2xEj5fodwN1V6QUKZ0PGk7ICgqngC8wC
         Nglvg0clFqsPaRldUcD3ZFrxiV1ZQJw4qIleGZEL2+DM3Wijmyo9U3IN7Ls3QOoayQzT
         lYY9K0L+f3O+p6QKBpPqzV4Hc43StZBEdqYtBV809g9ABGFknAa1cNHsoAH32x0joSZ/
         0rDcr27wWIPZ8x6i/Yyd6DHbPlW+QBChVUYW+5EInbeR/fG1OIFcw0WKoDCFovsexzPK
         GCPQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789461190; x=1790065990; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=fXrZss0Xz8qTUZJIY56JBAj/VAShVNUcWqldnlQTcfw=;
        b=L80+sdADFtLhhdU4lwW82qaCOXXFQijdhE3H12/0SQNcCAuw1DpQcHUSARDMvjI/SX
         US0XoO5SgOtG4PZ0F/jqQ09DcLmWWfvx6r6it8kGMd/1Pn2rNJ0AkWHCXYeMOmq22HVG
         7+684n7vA1ZAKpFdAgpOAOkCL1R/OzO6Ebo1UdqVGeW7ERVLse5wSuEckOtLMySBeN8P
         6gnnfKp5EIeXSa053Bb2ebWCnoWnPVnyUDK+U9dwBDioPzt8sfdWkbOIjmkQnYLJmCBC
         8yC1znc/OgwdOJSZPxEouje4wJ9NGXhv8vsEfJclLYFLdVW+dMpVopFgQo93vPngYgKk
         aS/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789461190; x=1790065990;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=fXrZss0Xz8qTUZJIY56JBAj/VAShVNUcWqldnlQTcfw=;
        b=nJHpGGg8lscwmHDm1hb+6gChyr4djVUN875+SkanRaZBOvEh7DsJifA2GaUuFP4OZT
         GXzI/NkdpF8FYGOfpirsQCengNjw81cXNg61CuKcFtXni8gTxyobub1U6t16FNTxkCWk
         te5rxpD4SICpja+QfFnbMi7meXDxirt9tIPj9fYNK6pnYg8/5mmjaItQZVH0tqKW5lPT
         Y7jEw6u8qtOxb7NvIRJVggPM0+ISEuUiJb6lksPUADcVmBjV0MpCPXD1sdzphkb5+QBm
         c2IsxSdMoxgTP57GrYPEC5OzbZ3QTh4ZWmmx8Oijv0WZaQptwt4AayzYArSERvn446k7
         9TIA==
X-Gm-Message-State: AFuF++kPvanPqu91vLE+QaVy2/t4Y2/Q3KnSKREY8HOfC9iZ18B7wHnq
	uSI9gL8hwmHGLw5zpPRCq4Vyt8NHFWS7BM2us6GLJovl/feMsvRrfg4RfbqoGMSotoURZro61sd
	Kx/4HcXVaQUyZmgsIONLayc8qZnNE3j4=
X-Gm-Gg: AYBFou30DoaC+qkkbF52OJ7u0Hl+HT8UI5eIbrUC8wvao21VcYIaF7HChN3+kd79Ggk
	mq1knJrMk4KfFSItiH79qo0+/D43HmKQJs4NHa+8b/WLACZeJFWYvlqI8TDqxuVlRI4CmybTNBO
	B7xnR9H+hvEkbnZpHZQZCQLLLfP4BeBL4Pi99dDIKiZpVRjzoYBJi0N1vDGeiExDqp6Ay1uEwLJ
	a/aP9mqTgQrSD6rkgJsQJ+vsEx9gG4OgocEmqaMTVWnC7XOMOxta15xqpqk/vxFKuWI7PNPku9S
	sn79pDIdAIB9FFhHeKCXZnlbhOCL+fQUWsBWnPZV+F3xDnfIT0NaDj8=
X-Received: by 2002:a05:690c:c622:b0:887:1704:be8a with SMTP id
 00721157ae682-88d1f402767mr15603547b3.8.1789461189847; Tue, 15 Sep 2026
 01:33:09 -0700 (PDT)
MIME-Version: 1.0
From: Cyclinder Kuo <kuocyclinder@gmail.com>
Date: Tue, 15 Sep 2026 16:32:57 +0800
X-Gm-Features: AcwNN1UH7RJmSYqpKBhQh9GF5rBUp7XuoO-bdsyk2hBVZtpKtGWSwRHuRqG91WA
Message-ID: <CAL8qZ1bZOyqCFMpT3751qdRyZyBzpLrt3GvF6kT_z+dcpn3gVQ@mail.gmail.com>
Subject: Subject: TCP receive memory accounting before accept() with cgroup v2
To: netdev@vger.kernel.org
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, shakeel.butt@linux.dev, 
	edumazet@google.com, roman.gushchin@linux.dev, kuniyu@google.com
Content-Type: multipart/alternative; boundary="0000000000008f6e1c065b8166a4"
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D0D3AA0005
X-Stat-Signature: 6bzsfs4ntcurjq5x9qfd4hh1ijd9tyx7
X-HE-Tag: 1789461190-478567
X-HE-Meta: U2FsdGVkX1+nfuPIlii0o/vqOQe5D3ahqU1iMrZJzrhQIF55fH7qe6LuNgZEzN5znqQIHjKbHWT87xl9KthY97DyXE+cQ1g35XzsaZujuTi1iP5i6JwzcbAt8jYZR9/AMr99lVrh9FtFfyAHzlNt+PIxnJyDydSMILdmt6c6KmggjTu9lywwLwIouXkC8R4kLD1zP5PeWQxDaRKYQ+YlWEV76yRVIHxU/KUk2gHW0o0eujcH7+AXtvjwSDN02KosoPr1kJJQZhZV0HLc3N4ZK1obEPXUO/yqwA/nTKefTuHRQnmo7RmNVR0CsWR+Ok12PVDeGzJJmYjhF6mcZF5fO4vuIEzg+EZK5JXjLGJnmdu+dtDmV1chlJ5t80GpR6hfYqD98LOSIPrWeoRO+QKnD0KEtxSdyP1h6+4xYnrHel+6dNj0VuOPCXZSxs6siVypYtYuwQnps58zQUZOZZW3R/ddQLzMfJx71B6YTg0rBFF9ZGOlilFrm/12KjFPgF/PpyiY/L3hch4722XGKyKSJM4wdl5zEKteG4mSmTwb9CZL5CRmVMNju/4itv7roVRXPFot+d5hhF1JpS88bQsNI2raaoF72WaGZLJYBj2bsFyrwfA8GsQyyF58/IR075sGXyJY/MjHLvPscQs2CJt9Tz7Nr9I5cKoQUqVjAYK+uUaOnn3oo3KCY2gF2nQOeUUndlqm8YXIhetGrRfOp/ehqT4PRrRhV+pk1pteJnUq5oXD3MSEky4mznR1x2OJhI7OvTHGW/y1JOV3P2VK5sPhvqM7KlDdlYKdGvhpJ/yc9k78vJ7BkT5D9xFqSFsdEAyYIOipR43d5h4nWv0qSIV5tE1zKXOC5IXm2vw3P9Krze7lmnuURsCA6X0Frt0UsgTfjGFoQ61eizaxMVyO8mSp4FY6C0GMINp8YuDJL1Iw4LmzxkA46+eqr76SToDikHUPY3mHVgrfwZhVrM2z1+s
 +wLivS4A
 jxMA9xMIsHITMUb+2wgVAELVTBi9DGOcogc3wJGOKztkEnal9YZs6MEtG16vk4R75Hnvq0ftalHa9msmhIRjrtMUZ9UfhftN+MCINXdyf1cE8yhmeACmYAVZUPpr1wrG7NsrYVmQIGP27e7dkk5YlK/VvPQZ7qWT6WbZ8qqcA1whXNUwQN2eQ4SZUkOtJ/D5DOEUOwPZi4m8wLUZ3kMUgcNNwKefiHhLh/GHIQr36+0Jt8+hIN1eulsWyy1ss7Cslv7uNx7SzD09hJqo4cYuIGB9wF43KMsrFEV/y0zA2NN2Rv8ssav0p54IZCfelp6/9VkmKmhJsiTVw4btO6ipthARI4h5cIZI7xnP7Zf6/ihrFslcCtXlltFi+n0JpiqjvriXxQqWX3+iCgx2psFCLHCjCOTULZBAS+CV/y0fw5HJvSzKa8jVWVECyube76Gd1pls3dtlD6/2E40GIWk2eZT8o6TvRudYx2lSPgJbxE/1uPz+ZZ4nKDdKQxPwqXzDcPQl+8T0H/jzwcL1yzelbewgf8GOgU5qYED06werwyWdG3oLnTUtQJV/E8lODHO3/QGkX8GxShrfu/h33i3nkV+MV/RjCYcX6/5ElqwDGWS93MXP5l23kbSfwgQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--0000000000008f6e1c065b8166a4
Content-Type: text/plain; charset="UTF-8"

Hi,

While looking into whether Kubernetes can allow net.core.somaxconn
by default on cgroup v2 nodes [1], I tested how receive memory is
accounted for connections waiting in the accept queue.

I understand that d752a4986532 ("net: memcg: late association of sock
to memcg") deliberately moved memcg association to accept() time.
The discussion also explicitly covered data queued before accept()
and charging that memory when the socket is accepted [2].

My question is about memory containment before that happens:
if an application delays accept() indefinitely, how should the
receive memory of those pending connections be constrained by the
service's memcg?

Test setup
----------

- Ubuntu 24.04, kernel 6.8.0-53-generic
- Kubernetes v1.35.0, cgroup v2
- Server container and Pod cgroups: memory.max = 512 MiB
- Private network namespace, somaxconn = 65535
- Server calls listen(65535), initially without calling accept()
- Client runs on a different node

The server container was privileged to set somaxconn in its own
network namespace. The host's somaxconn remained unchanged.

The client established 256 TCP connections, then sent 64 KiB on
each connection, for a total of 16 MiB. The server subsequently
accepted all 256 connections without reading any data.

Results
-------

Phase                                     Pending accepts   Total TCP
 Container           memcg
                                               accepts
 Recv-Q       memory.current  sock
Baseline                                 0                            0
             8.49 MiB             0
Connected, no payload         256                         0
 8.49 MiB             0
Payload, before accept         256                         16 MiB
8.49 MiB             0
After accept, no reads           0                             16 MiB
 33.82 MiB          25 MiB

I used ss in the server's network namespace to observe the pending
accept count and the established sockets' receive queues. I also
read memory.current and memory.stat in both the container and its
parent Pod cgroup. Both reported sock=0 before accept(), and
25 MiB after accept().

The data was already queued on the server, but its receive memory
was only charged to the server's memcg when accept() was called.

I did not exceed memory.max or test memory exhaustion, so this
does not demonstrate a node OOM or an absence of other network
memory limits.

Current implementation
----------------------

I also inspected upstream v7.2, although I have not repeated the
runtime test on that kernel.

sk_clone() still sets newsk->sk_memcg to NULL, with the comment
"sk->sk_memcg will be populated at accept() time" [3].
__inet_accept() then calls mem_cgroup_sk_alloc() and
__sk_charge() [4].

I also found the discussion explaining why simply inheriting the
listener's sk_memcg is insufficient, particularly when a listener
is created in the root cgroup and passed to a process in another
cgroup [5].

Questions
---------

Is the pre-accept accounting gap an intentional limitation of
memcg socket accounting?

Has temporarily charging pending connections to the listener's
memcg, then reconciling ownership at accept(), been considered?
I realize this would need to handle different listener/accepter
cgroups and the root-cgroup listener case.

If that is not a suitable approach, is there another mechanism
that should bound this memory on a per-service or per-memcg basis?

For the Kubernetes change, we are holding off on treating
somaxconn as safe based solely on cgroup v2 until we understand
this better. Pointers to previous discussions would be appreciated.

[1] https://github.com/kubernetes/kubernetes/issues/134194
[2]
https://lore.kernel.org/all/20200222010456.40635-1-shakeelb@google.com/T/
[3] https://github.com/torvalds/linux/blob/v7.2/net/core/sock.c#L2542-L2547
[4] https://github.com/torvalds/linux/blob/v7.2/net/ipv4/af_inet.c#L761-L766
[5]
https://lore.kernel.org/all/CAAVpQUDUULCrcTP4AQ31B5bfo-+dtw3H8CQGq9_SQ7d28xXSvA@mail.gmail.com/

Thanks,
Qifeng Guo

--0000000000008f6e1c065b8166a4
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr">Hi,<br><br>While looking into whether Kub=
ernetes can allow net.core.somaxconn<br>by default on cgroup v2 nodes [1], =
I tested <span aria-invalid=3D"grammar" style=3D"border-style:none;backgrou=
nd:none"><span aria-invalid=3D"grammar" class=3D"Lm ng" style=3D"border-sty=
le:none;background:none">how receive memory</span></span> is<br>accounted f=
or connections waiting in the accept queue.<br><br>I understand that d752a4=
986532 (&quot;net: memcg: late association of sock<br>to memcg&quot;) delib=
erately moved memcg association to accept() time.<br>The discussion also ex=
plicitly covered data queued before accept()<br>and charging that memory wh=
en the socket is accepted [2].<br><br>My question is about memory containme=
nt before that happens:<br>if an application delays accept() indefinitely, =
how should the<br>receive memory of those pending connections be constraine=
d by the<br>service&#39;s memcg?<br><br>Test setup<br>----------<br><br>- U=
buntu 24.04, kernel 6.8.0-53-generic<br>- Kubernetes v1.35.0, cgroup v2<br>=
- Server container and Pod cgroups: memory.max =3D 512 MiB<br>- Private net=
work namespace, somaxconn =3D 65535<br>- Server calls listen(65535), initia=
lly without calling accept()<br>- Client runs on a different node<br><br>Th=
e server container was privileged to set somaxconn in its own<br>network na=
mespace. The host&#39;s somaxconn remained unchanged.<br><br>The client est=
ablished 256 TCP connections, then sent 64 KiB on<br>each connection, for a=
 total of 16 MiB. The server subsequently<br>accepted all 256 connections w=
ithout reading any data.<br><br>Results<br>-------<br><br>Phase=C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Pending accepts=C2=A0=C2=A0=
 Total TCP =C2=A0 =C2=A0Container=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0m=
emcg<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0accepts=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0Recv-Q =C2=A0 =C2=A0 =C2=A0 memory.current=C2=A0 sock<=
br>Baseline=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00=C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A08.49 =
MiB=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00<br>Connected, no paylo=
ad=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0256=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00=C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A08.49 MiB=C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A00<br>Payload, before accept=C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0256=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A016 MiB=C2=A0 =C2=A0 =C2=A0 =C2=A0 8.49 MiB=
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00<br>After accept, no reads=
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A016=
 MiB =C2=A0 =C2=A0 =C2=A0 =C2=A033.82 MiB=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 25 MiB<br><br>I used ss in the server&#39;s network namespace to observe t=
he pending<br>accept count and the established sockets&#39; receive queues.=
 I also<br>read memory.current and memory.stat in both the container and it=
s<br>parent Pod cgroup. Both reported sock=3D0 before accept(), and<br>25 M=
iB after accept().<br><br>The data was already queued on the server, but <s=
pan aria-invalid=3D"grammar" style=3D"border-style:none;background:none"><s=
pan aria-invalid=3D"grammar" class=3D"Lm ng" style=3D"border-style:none;bac=
kground:none">its</span></span> receive memory<br>was only charged to the s=
erver&#39;s memcg when accept() was called.<br><br>I did not exceed memory.=
max or test memory exhaustion, so this<br>does not demonstrate a node OOM o=
r an absence of other network<br>memory limits.<br><br>Current implementati=
on<br>----------------------<br><br>I also inspected upstream v7.2, althoug=
h I have not repeated the<br>runtime test on that kernel.<br><br>sk_clone()=
 still sets newsk-&gt;sk_memcg to NULL, with the comment<br>&quot;sk-&gt;sk=
_memcg will be populated at accept() time&quot; [3].<br>__inet_accept() the=
n calls mem_cgroup_sk_alloc() and<br>__sk_charge() [4].<br><br>I also found=
 the discussion explaining why simply inheriting the<br>listener&#39;s sk_m=
emcg is insufficient, particularly when a listener<br>is created in the roo=
t cgroup and passed to a process in another<br>cgroup [5].<br><br>Questions=
<br>---------<br><br>Is the pre-accept accounting gap an intentional limita=
tion of<br>memcg socket accounting?<br><br>Has temporarily charging pending=
 connections to the listener&#39;s<br>memcg, then reconciling ownership at =
accept(), been considered?<br>I realize this would need to handle different=
 listener/accepter<br>cgroups and the root-cgroup listener case.<br><br>If =
that is not a suitable approach, is there another mechanism<br>that should =
bound this memory on a per-service or per-memcg basis?<br><br>For the Kuber=
netes change, we are holding off on treating<br>somaxconn as safe based sol=
ely on cgroup v2 until we understand<br>this better. Pointers to previous d=
iscussions would be appreciated.<br><br>[1] <a href=3D"https://github.com/k=
ubernetes/kubernetes/issues/134194" target=3D"_blank">https://github.com/ku=
bernetes/kubernetes/issues/134194</a><br>[2] <a href=3D"https://lore.kernel=
.org/all/20200222010456.40635-1-shakeelb@google.com/T/" target=3D"_blank">h=
ttps://lore.kernel.org/all/20200222010456.40635-1-shakeelb@google.com/T/</a=
><br>[3] <a href=3D"https://github.com/torvalds/linux/blob/v7.2/net/core/so=
ck.c#L2542-L2547" target=3D"_blank">https://github.com/torvalds/linux/blob/=
v7.2/net/core/sock.c#L2542-L2547</a><br>[4] <a href=3D"https://github.com/t=
orvalds/linux/blob/v7.2/net/ipv4/af_inet.c#L761-L766" target=3D"_blank">htt=
ps://github.com/torvalds/linux/blob/v7.2/net/ipv4/af_inet.c#L761-L766</a><b=
r>[5] <a href=3D"https://lore.kernel.org/all/CAAVpQUDUULCrcTP4AQ31B5bfo-+dt=
w3H8CQGq9_SQ7d28xXSvA@mail.gmail.com/" target=3D"_blank">https://lore.kerne=
l.org/all/CAAVpQUDUULCrcTP4AQ31B5bfo-+dtw3H8CQGq9_SQ7d28xXSvA@mail.gmail.co=
m/</a><br><br>Thanks,<br>Qifeng Guo</div>
</div>

--0000000000008f6e1c065b8166a4--

