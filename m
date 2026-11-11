Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56CA1606A321
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 06:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gCJyviTC
Received: by kanga.kvack.org (Postfix)
	id 7825E6B05B7; Wed, 11 Nov 2026 01:59:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 733406B05B8; Wed, 11 Nov 2026 01:59:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 671B16B05BB; Wed, 11 Nov 2026 01:59:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 469596B05B7
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 01:59:10 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DB9501C283E
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:59:09 +0000 (UTC)
X-FDA: 85421936418.25.70F99C2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id DB6A5180004
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:59:07 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gCJyviTC;
	spf=pass (imf24.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794380348;
	b=GbH7IqrAQTcE1WtQJdVAtCBkfI3EyTlgkwFtPjGaEoAnMV9c/OKd/LEu70EwYXG5jsDhGY
	tXKxjuAJ0GKjTorL79l3XBwc4Se3cRbJ3WIkIlcp78Pnbe9h+sh7aXAhzT3y79TWk35XRa
	gdMt2hCMQ+s8UZ0yCKvXb3xJjcwyf2U=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gCJyviTC;
	spf=pass (imf24.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794380348;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d5je2bEgTZvwiQ37Wn5zgMuS1lbCKpVuZ2yXV8m2vQY=;
	b=rTQEZqiQydMkpJKpLpO/KN7K8TfhWFJAlCibOJrmchdFlsSfAiznJboMc85OKgXDG/vz5r
	VgfyCXOKjfy6FMyOXFqoom7hCzH9s0BhFzDw8/zmvRvfqvxGU+DtvoBCmq14LWmgYHCeXR
	TaX9XQxl9hHgjjrjt6ikuaCsU3SXVew=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5B7DA42D6D
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:59:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E8E11F00A05
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794380346;
	bh=d5je2bEgTZvwiQ37Wn5zgMuS1lbCKpVuZ2yXV8m2vQY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=gCJyviTC/VTOgz2yPFdeRpM4uAhPwK6qDHnBWB3JpDyphxbOvxsICM/lSvmpge0Sh
	 H6If95ud7CDLiL+n+q7jgRc+QuucaTlErcyn6HAupNn994d7JMHq5UnmEy+2DJOwDG
	 fCOMH+qkUnNylCvEVSh/DJcRDTsnoMbTm4ZOh8+r6q+lSOr5JIK2ZiWSoLwvFC/whV
	 XAP+SUK7b/eLJZOcd3r9cieudWFD+EBxRPdXJ1db4g5MZkAo7e+5D4hhgfqofV0Ude
	 Op8BVW8tm4fdR0YGHosZ31IeKuWsRHXHXDWm2KTWKYVBphuycvSOwSLFuIMau00FK7
	 rHu5QJHwpf25Q==
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-945e6d9ceeaso247145885a.0
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 22:59:06 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErHDUGKCJjRqIufqhYHssPsL/cJgzslc5N8qIbXIm6rhN7+FOF8Pu/C0C1b7HQjQlFR/kzPe0Ui5cw==@kvack.org
X-Gm-Message-State: APuU4Z/rf9a6SuZXtnNRT0Dkh0YnkwkLlp53GfpbVSYCeyUhoB0diNcV
	1SaLSFyLVGOH946nlch6YrgyhKwuwTayaThHQniY0n9bElBXScDiE1M0aGSuDgMXXYPKD+Em2m3
	4FG6u0FgPQxilRjw22tec8JL32IA19HM=
X-Received: by 2002:a05:620a:4629:b0:93e:c12c:9dd2 with SMTP id
 af79cd13be357-947b000dc62mr213935485a.82.1794380345632; Tue, 10 Nov 2026
 22:59:05 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261109-maintainers_mglru-v1-0-c25e6de60bcc@kernel.org>
 <20261109-maintainers_mglru-v1-1-c25e6de60bcc@kernel.org> <avLpQhAv8MkaOevD@gremlin>
In-Reply-To: <avLpQhAv8MkaOevD@gremlin>
From: Barry Song <baohua@kernel.org>
Date: Wed, 11 Nov 2026 14:58:54 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4ymA_i+qSoqZ2xa9qgchCcnVU-VZ3Z6V6p-CW5gGDjjbw@mail.gmail.com>
X-Gm-Features: AclHuK_Df4TZaTzk-KvkOfj-hWhsUHF44BTooaU_w5shDLMRNry7F7E-IqGnu4Y
Message-ID: <CAGsJ_4ymA_i+qSoqZ2xa9qgchCcnVU-VZ3Z6V6p-CW5gGDjjbw@mail.gmail.com>
Subject: Re: [PATCH 1/2] MAINTAINERS: MEMORY MANAGEMENT - MGLRU (MULTI-GEN
 LRU) update
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Lance Yang <lance.yang@linux.dev>, 
	Ridong Chen <ridong.chen@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: w71jf3pn8y14pem3q8m64i5fxkfppuzs
X-Rspamd-Queue-Id: DB6A5180004
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794380347-307486
X-HE-Meta: U2FsdGVkX1+f3FIEPZFe6TODNDTLxx7bQZaCj7lEM58LFs3Yb49axDYNrlzdG3iS9b7NkInVpHq36KPi1M5W9V2R5slqAcXU/8s8e6+s4gYZhniVqKLuBD+czWvc4dxct4cczUvj5o3oWu9kAE9nyiH786GJTtT4QoWW2IJJvmoxYOXCAQtAFAWKahTFCeEwPVRFAHf+RBCNLwJzV57v+fdj8j8J7GYNEJm7jJgqpOgfsbmTSqOIQKStIs6GcqyqUVNwbe0jRXkxAx+H5F8zLcPDWIyiFbOXNTsbv6jScV3j5qF8asGlNIwclbJJdlylH7VOqwNpfvO8U7mlf0WnNqEe5c1Ju0vHS1C18KN1N9huRGnqfFrjhuU6aHOT7BLSoo2P4W/3Nws3ErdP7ov98V7ImQhkDe4nTk5Mus/BTqk53RfMif3XAc5IFxuoMgPHqVXYbyfMl6Md1IeCm87bK1wexT9JgBwqaIvmfkVTbMJ1cpiNS/Tqz6W+IhPhauD2GKX0ruYu1hD5xSUMIp73Vim4XoLsfb7twzgEryDUZ+v/kzaY2QDy65aUvoONHIkZ7nfIwaX6lT7iMsqG+wvFJTCaZkZbg2vzrW3kWLV7GNdadbZHV/ia/EC/UYKjDyniIYbkjM51dM/woDAawaJ4/wWzMY05H2umnWMyQQWkyzjKI4WyikTxG3Ezppat2guZKymEesXeSZJAsB6IPeVo/ZdJ/7+etXGjtjBRxonWRsuGciujW8TDB3aDbaZKqhFwnOxZd7hzzh9JM9j2c9BLZYbwLvY7B9oglr8PU+EVMojN4li7MZhZ0gGZLP2XMTL2HmJQBVDYZnsf5xSuX2wEH+dWbhapdQJBL8SPsU9oomflVCIwpQNn+CeAwb5dEgBeilNr8hjnWxdR+J3VjpdEqvuhpZLr4bRPP6Hk9h3vOyJ8KQJb3kB5Ktb9Jnvkgxrq38U4QwdvccBVU8Xg+pq
 trXv1zU2
 qv4Zj2a6G/CgqT5zeZVdT3655StZ9swUqYQqh+qJEDrkoN/NMLalvJvbMg4TEBBLNiP4cwzkYDkxV6bgR34Ot+OKkk3LFA0GCnD/KzLkwKWBQEpbykEk83kDA3l4PRvA9OIp3K0qHveTyaEsjY/HXRmheyBRDYB8zft2U0F5g4Uoh+IOySJu8vtsBNmUto+Vx1wPD2mXHLTGXyc/t9yjcFqifRM06fGBuXfQpwLT0gktQGsqV9WnP7WstaUJIvIC9Pz/MXjWJyOPRISyMPZFeMAjVfgDBnp0reX3yIQKd4oMoUIX7tfZv9EPvDg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 5:53=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kernel.o=
rg> wrote:
>
> On Mon, Nov 09, 2026 at 07:31:53PM +0100, David Hildenbrand (Arm) wrote:
> > MGLRU is currently the only MM component without a dedicated component
> > maintainer. Fortunately, Kairui and Barry have been actively
> > contributing to MGLRU and have volunteered to take on more responsibili=
ty
> > by officially taking care of it.
> >
> > Given that Kairui is already an established MM component maintainer in
> > a related MM component (SWAP), add him as an MGLRU maintainer right awa=
y.
> >
> > For Barry, the idea is to transition him towards a component maintainer
> > role over the coming months, starting by moving him to the top of the
> > reviewer list.
> >
> > Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>
> Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>
> Congrats Kairui and Barry! :)
>
> I am so glad to see the proactive efforts people have made to get MGLRU m=
oving
> forwards again, it's a real success story in mm.
>
> Thanks to everybody for their efforts in making this happen! :)

Thanks very much for your kind words, Lorenzo!

Given your earlier involvement with MGLRU, it's great
to see it continuing to move forward!

Thanks,
Barry

