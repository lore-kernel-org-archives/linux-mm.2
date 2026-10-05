Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3F91CA5FCE
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 06:30:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD6F16B0093; Mon,  5 Oct 2026 02:30:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D87836B0095; Mon,  5 Oct 2026 02:30:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C506C6B0096; Mon,  5 Oct 2026 02:30:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A23566B0093
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 02:30:52 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3369540159
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 06:30:52 +0000 (UTC)
X-FDA: 85287599544.28.B34D4DA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 569FD40004
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 06:30:50 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TNjA+qqU;
	spf=pass (imf04.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791181850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Go1pW3kqcjzpvNXBPm8wCORyJtiYwbxuEZdhDPXEl4=;
	b=KZnXPGXb6rWRIPPSCbk0BMvyKYujxTZ7KVdNjBItRhWvL+aDwrkMcmZsNMzQl+k2P8PhbX
	RhGM3JPhy+iJzHmSpUmBwQe34JacFIKflUNj618ioA19Lb8Tk6FzvgP/j7gA2eEGK3vPTg
	HmdF/ne2MA+GfpXVl7gKn5HOWx9ZTvs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TNjA+qqU;
	spf=pass (imf04.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791181850;
	b=cgQRR94plqK1VaTZWUpMAIfN8a9DgMRl49OORZOfowyAqDepB3PQDduqc2FyoeIAaV1izp
	69sNpGvwtM8OcyDdNczvZsk1WS/0hSf8p9d6B29uaJSUckDU44r8XU/jNyP5mH1R6QgDVu
	wtHWz4Ct9Z4Stn7uVq/8o6cIzi/E0XU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E4F646022A
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 06:30:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E8E31F000FF
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 06:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791181849;
	bh=7Go1pW3kqcjzpvNXBPm8wCORyJtiYwbxuEZdhDPXEl4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=TNjA+qqUJDRTWZBsH1n3gz7lESCG3bZsRFEaMpgrCq4Y1zuyYxKUk8htOzw1oKCCu
	 SxQ4byo1vq2hBZe0qs24tzuQAhtAb5lf0xUuRB1+6xBsMMoMb17JYdE1AYee2XXB5H
	 Wwq7hAXJUMTvxXnPM5vhVdhu+Cu0CE6FzsfCw8D3vIeELbvZSJLGtBcyoSdtVaOSKE
	 aBNgnjpXxu6w1rhD8xIYlpsubw019cWNaoo6oD3D7W7zNM/+PuWyW/jPidN5aO1kBC
	 5ex7UrZPk+HZM8e47q2LFjdptnhWmGZ1GxC4OJWvJRPKztmFVDM2+AkJns6T6trPQ7
	 7GF0M1i/ySAOA==
Received: by mail-qk2-f41.google.com with SMTP id af79cd13be357-93bfa7b2093so117339585a.1
        for <linux-mm@kvack.org>; Sun, 04 Oct 2026 23:30:49 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxTjsEoHUajl46XEubrTBa6OIlaaSM8pNrmCRyZBLhxglQUzVIjZiBe7rUVpOdAILUR4wAdHRzQWg==@kvack.org
X-Gm-Message-State: AFuF++msHD1UrpzgdNr7NOgp1PmyCnaV0o7t6Ytl3Gdr+DUpc9SZcPv+
	Tqz81QIHCmlx7y3Vda1l6V6KWtMjH62tKQ6aXwveIsJlEbtqipi+X6y21T7LuusPzZB0eLW1Bl/
	mY5yiU0LzNIopgNwUNafm+lPJz9dbTUM=
X-Received: by 2002:a05:620a:2591:b0:93b:ec83:80ee with SMTP id
 af79cd13be357-93cf19daf2fmr1840183185a.57.1791181848984; Sun, 04 Oct 2026
 23:30:48 -0700 (PDT)
MIME-Version: 1.0
References: <20261005062236.564210-1-vernon2gm@gmail.com>
In-Reply-To: <20261005062236.564210-1-vernon2gm@gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Mon, 5 Oct 2026 14:30:36 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yKSoCwcEDhtd=biKoUjUX9eTJJhFJGFAZWc=WsAyXycg@mail.gmail.com>
X-Gm-Features: AclHuK8CRONO2VtLENz3jDK7DYC4CRj5Gx_73AqOwMereSu4SIWXUmZ8CWWfcGc
Message-ID: <CAGsJ_4yKSoCwcEDhtd=biKoUjUX9eTJJhFJGFAZWc=WsAyXycg@mail.gmail.com>
Subject: Re: [PATCH] mm: vmscan: don't count per-node proactive reclaim as
 memory pressure
To: Vernon Yang <vernon2gm@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, kasong@tencent.com, 
	qi.zheng@linux.dev, shakeel.butt@linux.dev, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, baoquan.he@linux.dev, 
	hannes@cmpxchg.org, mhocko@kernel.org, ljs@kernel.org, 
	roman.gushchin@linux.dev, dave@stgolabs.net, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 569FD40004
X-Stat-Signature: kd74ytc35y81cmdy8anzorsfrgsrzfk8
X-Rspam-User: 
X-HE-Tag: 1791181850-219958
X-HE-Meta: U2FsdGVkX1/0SkIxFCE/1Q+GKcahTuZC646RpDFxE/sTCD8KrH4tsbXJYiER6ui9Y9649x+EwrFcEoLeR2ZymqaHssK1DAvyYLWoj81EDCfhZSdYx7l70WfZ9/gSNyNH4ntsGq1HNa3b62eUkHgg7qOYcJcs/Qj/x37juJHXIQpOq2Jd/znw0mbq5BjFgOieZ7KBUVIv9NYI5NJfjjecPJ6g2szavF+XTi/dvUzMcuW/XvfugStrf0RUn1a3uwlCTynZMyxgv7BmUlF77NeltZtrNAOLGJtnDdwH6nnKdniTRK5VVTzdOXgf1luh9n1Y7B6uX6Z0P1RldnGnDplfnh3Gc4apdLRVNgJt3gXhRXDXezAWAHV9v4h4nZe910Dw3C0UCLLXf695dZ/KU9+w1GzM+mFu7/0nRfLiBubgUSfqgKmpX1wwfBo0ut2ezmnqr9ncaFpVIjTVjrcFltZmnUrhuS+y7JOXYuB1SUol1syX/T2SCBcEs4IztZocBXjN7y0UVePsCCWAhO9qBR9KyCd7cxWckd2Y3gah7QI2XsZNqV1OGh/15EyiAK5itktcPj8TFmZep/xb5/nmrlK7phEh1bx9kLhhTVVDqLxlCe4rcTDXahluQKlAAtCJSemIpP6aXMYDwB0grjV8+IRgeSSAfdJnFlny2VId2NGScT7+KmGjEnWVBz+AQ2U+DJ8RpoNEfd6O8+qDGceV8Vn/kITCj8nwKEKUHsDB446B8MZsGqBiFzseKEjdjOesJREujgCf3/GbV6vge6d5Q4/xEkaxS/DmzFlnetYj9eaQnCj921x9o9D1wj1VbutOxx8YjNcFQD1ZzGZRx2K5cN3yGYG8Kf4bWH9VlzOPMy+bYPax6L4Ufcioph0VqaBQv/RdhkGFRd6sWQ5eMkWLJBuC9EePEQxKbZNS/9X5M0LdCLVmpea2kmMInU7MKoHpBSHl/uahKfIw/c7lNAPxsad
 7wYg5V7B
 74QxtabkRRBJQuvoDUhzm+hI6fO94Qr2nblMlnTc6QoSxMJLMcIrBQpy54XpBYjES/hSk5iWkrzWTv6+5yQe/JKjblhZRS9B4IVjX8DIXgd6TGRxkW/FwYs+oChI5kB3Dv6pTvS0PdlhOhkWnTO9v6Sb7h+4pbzhSCHdn6y/7mEk9vcarmJtWYaBpdZPEu6Hw9wWKCjMfhXL3tyuGe0Po5/DqrTKinwwShMQ+q5g7Lp0vUp+9KiDwP5ixYL7m6VA/Hf7yjeXqHi+nN65lxxapEEmGZynzMPnQ7OrL3qPWHEZ9vw3l4H3Ud8RLo29nTDa+CBnqT0uZjxnABTYMxwueufw32+jiyLvABRG6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 5, 2026 at 2:23=E2=80=AFPM Vernon Yang <vernon2gm@gmail.com> wr=
ote:
>
> From: Vernon Yang <yanglincheng@kylinos.cn>
>
> When the cgroup has no memory pressure at all, writing to
> /sys/devices/system/nodeX/reclaim triggers proactive reclaim on
> NUMA node, causing increase in the writer cgroup's memory PSI.
>
> Due to this reclaim is performed in the context of the write(),
> accounted as memory pressure on the writer, like
> commit e22c6ed90aa9 ("mm: memcontrol: don't count limit-setting reclaim
> as memory pressure"). This is unexpected, the phenomenon resembling
> senpai will appear again.
>
> The Documentation/ABI/stable/sysfs-devices-node documentation also
> notes that "This interface is equivalent to the memcg variant."
>
> This patch unifies the semantics of the memcg and node interfaces:
> per-node proactive reclaim is no longer counted as memory pressure,
> and the per-node proactive reclaim interface no longer produces
> phantom pressure.
>
> I ran demo[1] that performs per-node proactive reclaim 10000 times
> in qemu, writer cgroup memory.pressure as follows:
>
> without patch:
>
> some avg10=3D31.53 avg60=3D13.42 avg300=3D3.31 total=3D10602985
> full avg10=3D31.53 avg60=3D13.42 avg300=3D3.31 total=3D10602985
>
> with patch:
>
> some avg10=3D9.59 avg60=3D3.41 avg300=3D0.81 total=3D2686221
> full avg10=3D9.59 avg60=3D3.41 avg300=3D0.81 total=3D2686221
>
> [1] https://github.com/vernon2gh/app_and_module/tree/main/reclaim_node_ps=
i
>
> Fixes: b980077899ea ("mm: introduce per-node proactive reclaim interface"=
)
> Cc: stable@vger.kernel.org
> Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> ---

This seems to be a valid concern. Personally, I don't like
having the code depend on whether `__node_reclaim()` and
`node_reclaim()` are called from proactive reclaim or page
allocation.

Can't we check whether `sc->proactive` is true? Am I missing
something?

Best Regards
Barry

