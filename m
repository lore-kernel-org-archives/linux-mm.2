Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 800E6C88E7F
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 15:51:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 935C16B008C; Tue, 15 Sep 2026 11:51:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E76F6B0092; Tue, 15 Sep 2026 11:51:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FD386B0093; Tue, 15 Sep 2026 11:51:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 535916B008C
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:51:37 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D99C44048D
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 15:51:31 +0000 (UTC)
X-FDA: 85216436382.16.1BF902C
Received: from mail-oo2-f42.google.com (mail-oo2-f42.google.com [74.125.231.170])
	by imf18.hostedemail.com (Postfix) with ESMTP id EA1731C000D
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 15:51:29 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KIkbmrcu;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of kuniyu@google.com designates 74.125.231.170 as permitted sender) smtp.mailfrom=kuniyu@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789487489;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qLaU8Sheaee7OVZT67w7SriDUMjtz6t3Qx6H6/8vnfk=;
	b=tPClatUonm/TW6VbQhZ59JMC+qCi4XQ0rVw0qgt8OP66MTrpHTM9w9TDJw5CUVsdMz4DjF
	u+yq6aqRBOcZiG7tjPvC4PUbYj7W6oMY62Ylls984q3z0tbghgm5lIJnsLt/EqPz8X4DTk
	RJo8c0DAS/ASXdEVjMJNOmhuBvTF60E=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789487489;
	b=sgKd8RcGCMGF+AJr/tPN4nz3CWIfl0Fj/XdRuLhfecEcOfS+cZMK4vSpuxa9ZlNoEuMDIf
	4F8i1de9g87qpYs+qLUR9muPbfTb8eEch72xDdIkezYCBuj43EKG/zO8YXpuDNrfW+TGW1
	9ar+2eXypwUENIQZrfaKbe0w3x+D2BU=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KIkbmrcu;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of kuniyu@google.com designates 74.125.231.170 as permitted sender) smtp.mailfrom=kuniyu@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-oo2-f42.google.com with SMTP id 006d021491bc7-6b1ae6a9960so410956eaf.0
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:51:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789487489; cv=none;
        d=google.com; s=arc-20260327;
        b=g/RpFlO7Z73Z/0m7+T7XDpr+zi2TiWADBWz3zo7yk1I3uk7hknkkTgBP95x3TlGECU
         RwOAdcGrQxAEkRCpH6pQt9BfUNWa0fHEGpPI9KRa5fX6ROqewjjh8sqIpRw3zGmQscSq
         amW/0Dwwpn/B8GXzyy7YVk6Csqt4kwX7ZQAPvjUr7xalEISzA8w4QtjoMNcCMBqbcMVK
         2J2gG+W7srOdMRirpGOWTHy2sXLpC0hyslPPIAdxKOo1DtNyOuEoZZQ5Iai1ArPg1PlK
         Z7o3+TBQf0/4ICuuKvw6wY7Eoll1/ioz/kFecC6Bk1usp9CXPgb3GoUoFwDtB4EepiZb
         GIhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=qLaU8Sheaee7OVZT67w7SriDUMjtz6t3Qx6H6/8vnfk=;
        fh=0p7D/wI6WIH2LS0QkZyyFlsWXGkJ3cdwxMUACnu/01Q=;
        b=sttT/FgeQuObulyQnxC6YEQRT7qwnTsMFtsPz+q6OoVUphtctr2WWTOSu3wsFlKnSb
         f43xrCyvusoturELaV8EEs/eLTtFDLq1Zsx1qRyG8kpMrkciYEfPAWYeIxuxmGPKy4o5
         OsgTe5cvCZlDSBlLHkeL9ZBfLOemxJe+1FtTi6HpBGXSEWMiQYPIvWAH5SoHQOQVz7VI
         eOfTbUkgvbJdlWC8T2DDFjWd6uPaStEM6jytD9o963+yW3xqOMaUN2/4KtI3K2KDPSmA
         CSpUwtm92kaUUMue4nySLDQUk/yIdYJimuUfZ+fTHifo7pQwfX+xCqDTM1DkYSUS3Bc9
         roKw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789487489; x=1790092289; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=qLaU8Sheaee7OVZT67w7SriDUMjtz6t3Qx6H6/8vnfk=;
        b=KIkbmrcuqHx69dtlSG2ZyOBWrr+BRy4hoMMdJl8cvi63yP2CsySrx2JILIgDIGPdmy
         EfK3RcziaG02pBB1PnET6CtlwXuLLbAxfElTVaRWTUYHRbYz0nzt7gJ9S0BiFjqEXXx7
         RsjUBvyT7dSV4OwkMKTyjhRJxnkLtX4MhSPDiQOhWuDRsfmnRh7Ky0ac4sl6K0UTnXo9
         9J17gJDIk6sOQpvZB2RgNKCJ0OVhc+VZqi6R0tIh9kaq5wzqiwIJU0sni7y+NGMMH0vh
         gzPebfcASe6qCyZm2B1V3EfEHVAq/ZnnwJixHW5AtV9OXT/wnZjFx9Ks+gwtUIclIBA0
         2fjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789487489; x=1790092289;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qLaU8Sheaee7OVZT67w7SriDUMjtz6t3Qx6H6/8vnfk=;
        b=K0LCSs9xCd5jtXOwaiVx00iHNkTVLw7EczOGhszc+s5ZWtIyzYmZBxewGATwUU3HsA
         3OwVcEhOHHmqDi7U1AHSwovn3cOrbvrzruetWaUsQF4r7Bkdga0RXsa/mNPi9+BVV6gd
         LPb7j2qVsDin2OVFL+bH5POUTAm28hq1XmykMiKzj+j6k7t+q/f1FREl83oRYAFxsUN5
         C09asiO5DqwH5jtPSaCqcXRRthjH5X9xfkryW8IqUmzDZGF1iYgvMSuIS3Pjfpt/OXAN
         9i6F/vn4f4w/c6JKbMGE4+Ua4/Q6r4SfvLCU21VNc/PQRrDbplIb/reyQHCNSkU2/olr
         RVzA==
X-Forwarded-Encrypted: i=1; AKwUvByoEFMZ11EdBYT8MhsleEqa59szMO6rEr+7lNtuursiGJ8MycnbTK7JorQk2IZWfJwBXt6gZd8X+Q==@kvack.org
X-Gm-Message-State: AFuF++nQs6w7+RAkNwo6/D+CjfVM/tJNjmNeT51UM6qMu13rCWXkrlwE
	Fop5ABTPbpQcgIC8t4pY6Zo9ola+mz77BvdUID1qWxuPOCAvw6kVdPU1xx47MGF4YaoBU4O0wjM
	NmNaek7O6/pMIQW6t1UMb4b89NLDCArubGx05YpQER5sy/8Udp6w0QTx2D+uaSw==
X-Gm-Gg: AYBFou1/6ehTdRYBjzFQD5CfBAY3CbE8mQ5S+3s5N+tK9g2/0SfIwChO4iQPAcj6b+H
	mEMFhvdVUNQRMp5dcy0+uMOq/s/SfUTyVw/b1HbSz0sRQNMNLBFQY22fS8TE8CHq5usSk//gM9x
	BfTTiIFdAdwZYFXdo5AVDJtA+fkFNXEhQ03pgl2noNZngLvEsrn5b3OOJDdK12VJ1ggA5tHee2R
	lfXvYkVsDBla8tlSUS7VPcNhqsdKr10cGrgDYyox/pCl3juaQ92tI1zZX5lr4pUhHHH4TL+cUVd
	CdhlARxyHwi+NG+IGTM9tHRd2O9lLy+0IBtPhh0euOUCKvrXJ4mNjIz7bVIjtlrzwq1Y9dn2BeS
	6EuoDCs5d0eCgG9LNPiMVZWHa4RI1hjUfioNjvNuGa3aqHfY0nRZ9XMcfVS5V+zKI9SdI
X-Received: by 2002:a05:6820:f036:b0:6c1:d6a4:9268 with SMTP id
 006d021491bc7-6c737b1ca30mr1441282eaf.5.1789487488174; Tue, 15 Sep 2026
 08:51:28 -0700 (PDT)
MIME-Version: 1.0
References: <CAL8qZ1bxzBXReej7M-20HkBwON9L6NZKZP96bs7s-e=j-_Gg8w@mail.gmail.com>
In-Reply-To: <CAL8qZ1bxzBXReej7M-20HkBwON9L6NZKZP96bs7s-e=j-_Gg8w@mail.gmail.com>
From: Kuniyuki Iwashima <kuniyu@google.com>
Date: Tue, 15 Sep 2026 08:51:15 -0700
X-Gm-Features: AcwNN1VZxjUbgSRdsZo-3wXq8QiVHvk8HaQExXuqbOILOADwb7TrgLSgG0x2RqI
Message-ID: <CAAVpQUBWtdDe4dS5Sd6mETpxVdmvSrnQkBdfK=NKgoWzTJUomw@mail.gmail.com>
Subject: Re: Subject: TCP receive memory accounting before accept() with
 cgroup v2
To: Cyclinder Kuo <kuocyclinder@gmail.com>
Cc: netdev@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	shakeel.butt@linux.dev, edumazet@google.com, roman.gushchin@linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: EA1731C000D
X-Stat-Signature: 3s9ybxwmbjc6ot5b5ety16ybwo3b883f
X-HE-Tag: 1789487489-335220
X-HE-Meta: U2FsdGVkX1+e23QMq4OQTpfp2BHv09suozcrE6+xOPtlxA/+KgTJYvFE1FxZl2cKZdSzRXgNhOWadVz/gDzl+oUDPlneWn52nwr8TZjJyY+N6RKCJKN9oHQUtk9ixOGmffpVlroioX0DuzChBkh8OU+9Yhy3LxelsMKhToGZ9Z7y/yG4TeQGDVkHpbhsZ51URvpR2BgPEx16vvWlV1BkH1RGBzHogeF26mtmqzn1jM+e2G6Owi3uiQ/SY7DF7ptmjKuymsZ6i7Fkoav2bxcifi6Xr/8DU7fthXuc4D14CHT6ppkfZ2WFLS5bfnzxCXFNK1Wc7b/WggKANxRvDidPqWyRHx4zUGiB/mz4JPOdagwQpXM1MN29K3OZoZE0ZLSjMakXWo2R3qjSHEhEIuNXOvwBFuz/zx8FV8CZrJ12GRpAHYSr+XEbGiaipRmwStsncc3CEhNEbGd6Dh2vezmGsNkw8OCIVjT1vYzAHXKTP+Gi7rbf3elEbXxY0JKljXiaBARyLsQOPC7fnfry6ONahRYin/c+zEBoqAaHtc6JNE5xBKIcTugmCjY3cQ7KmwceB1s5ckRvEhY1rDrwFwp5cwaciSbExH272jddTVgfOr9RQ7g+TMu0DiCQF5jK18a0tcFyA7Ghp0MdQ8ixMS9B6YcgnTboCx7iIIPy1XMkd0Tp8yEWR/tXC1QSAtl598YabkG21A2FEcKssLewEW6I8OOf2W6WxThEPkRD2L11W+VhIrU5Z7eYk/J91nfeouQE12ZzCT8w+6GgXYT4QaKvAOGggpmmMGzx8O/Q5xB4OXUOnlsfl9N7LyI+7g9YzRAzMx6Hej9hKXaG/MteP097IJdWc3j94QvpFuLJrTLpbCumWjC8o3Aqm26/5/70YMcLpgtdaWIRDF6udwzBKvgi5uQFvAsJmFQySUaeEY4DMw1XNffsYqULfiDjA8fKm38/ZMNY1/xi0o03Lrh4NSp
 cVo4KTmu
 Ks78GZTMUi0Hp2RimQXt8OC3amWqcJ8irxWJJ4YzXDy5s/G1Jo7fOcF7ZkoXyNoSaZoca7ngIesD8nGf+x/p4uO+y/bDy8EZu0hGu+37ppxVwHfLSf7UwTlleffOOtYPin93Lg8NmUNgKGV1ETDWFLNfGGWx8kavPpMMj0JbNfnTO97In6pIfIvFE8ddvMew+/iT1o1duYNCtucUVySPsFMyaxF/iejxjNgUDH+1jtno8e66b03p8jPUmZVUuXbNdHWdn6UAR8mefTwPk83O/5Gpt08YuvuCjjjhBtzx6NUeFXny+59F/ZhtzgxRVIwhY4C9KHv+kNv+mO/iuDklYcohDBqHOn9oVeI4MGttwWYhw+1K0iJwFnoZx42w2e6OpZSHM6R2aZAaHSe4xpN2KvER7EffY5ql7DXwd9C2iQ+JvDP4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 15, 2026 at 2:08=E2=80=AFAM Cyclinder Kuo <kuocyclinder@gmail.c=
om> wrote:
>
> Hi,
>
> "Resending in plain text; the previous message was rejected by netdev
> because it contained an HTML part."
>
> While looking into whether Kubernetes can allow net.core.somaxconn
> by default on cgroup v2 nodes [1], I tested how receive memory is
> accounted for connections waiting in the accept queue.
>
> I understand that d752a4986532 ("net: memcg: late association of sock
> to memcg") deliberately moved memcg association to accept() time.
> The discussion also explicitly covered data queued before accept()
> and charging that memory when the socket is accepted [2].
>
> My question is about memory containment before that happens:
> if an application delays accept() indefinitely, how should the
> receive memory of those pending connections be constrained by the
> service's memcg?

AFAIU, this cannot be constrained by memcg, and you need to
configure some knobs (somaxconn, tcp_rmem, rmem_max)  to
define a sane threshold per connection.

https://lore.kernel.org/netdev/20250707213900.1543248-2-edumazet@google.com=
/


>
> Test setup
> ----------
>
> - Ubuntu 24.04, kernel 6.8.0-53-generic
> - Kubernetes v1.35.0, cgroup v2
> - Server container and Pod cgroups: memory.max =3D 512 MiB
> - Private network namespace, somaxconn =3D 65535
> - Server calls listen(65535), initially without calling accept()
> - Client runs on a different node
>
> The server container was privileged to set somaxconn in its own
> network namespace. The host's somaxconn remained unchanged.
>
> The client established 256 TCP connections, then sent 64 KiB on
> each connection, for a total of 16 MiB. The server subsequently
> accepted all 256 connections without reading any data.
>
> Results
> -------
>
> Phase                                     Pending accepts   Total TCP
>   Container           memcg
>                                                accepts
> Recv-Q       memory.current  sock
> Baseline                                 0
> 0                 8.49 MiB             0
> Connected, no payload          256                        0
>      8.49 MiB             0
> Payload, before accept          256                        16 MiB
>   8.49 MiB             0
> After accept, no reads            0                            16 MiB
>       33.82 MiB          25 MiB
>
> I used ss in the server's network namespace to observe the pending
> accept count and the established sockets' receive queues. I also
> read memory.current and memory.stat in both the container and its
> parent Pod cgroup. Both reported sock=3D0 before accept(), and
> 25 MiB after accept().
>
> The data was already queued on the server, but its receive memory
> was only charged to the server's memcg when accept() was called.
>
> I did not exceed memory.max or test memory exhaustion, so this
> does not demonstrate a node OOM or an absence of other network
> memory limits.
>
> Current implementation
> ----------------------
>
> I also inspected upstream v7.2, although I have not repeated the
> runtime test on that kernel.
>
> sk_clone() still sets newsk->sk_memcg to NULL, with the comment
> "sk->sk_memcg will be populated at accept() time" [3].
> __inet_accept() then calls mem_cgroup_sk_alloc() and
> __sk_charge() [4].
>
> I also found the discussion explaining why simply inheriting the
> listener's sk_memcg is insufficient, particularly when a listener
> is created in the root cgroup and passed to a process in another
> cgroup [5].
>
> Questions
> ---------
>
> Is the pre-accept accounting gap an intentional limitation of
> memcg socket accounting?

I think so.


>
> Has temporarily charging pending connections to the listener's
> memcg, then reconciling ownership at accept(), been considered?

Not sure, maybe Shakeel knows, but I think it would severely degrade
scalability, and the change may surprise current deployments via OOM.


> I realize this would need to handle different listener/accepter
> cgroups and the root-cgroup listener case.
>
> If that is not a suitable approach, is there another mechanism
> that should bound this memory on a per-service or per-memcg basis?
>
> For the Kubernetes change, we are holding off on treating
> somaxconn as safe based solely on cgroup v2 until we understand
> this better. Pointers to previous discussions would be appreciated.
>
> [1] https://github.com/kubernetes/kubernetes/issues/134194
> [2] https://lore.kernel.org/all/20200222010456.40635-1-shakeelb@google.co=
m/T/
> [3] https://github.com/torvalds/linux/blob/v7.2/net/core/sock.c#L2542-L25=
47
> [4] https://github.com/torvalds/linux/blob/v7.2/net/ipv4/af_inet.c#L761-L=
766
> [5] https://lore.kernel.org/all/CAAVpQUDUULCrcTP4AQ31B5bfo-+dtw3H8CQGq9_S=
Q7d28xXSvA@mail.gmail.com/
>
> Thanks,
> Qifeng Guo

