Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC0F2EF48DC
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 07:29:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 264006B0005; Fri, 13 Feb 2026 02:29:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FA626B0089; Fri, 13 Feb 2026 02:29:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BD6C6B0096; Fri, 13 Feb 2026 02:29:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E9D1F6B0005
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 02:29:14 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7EA911B3F5C
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 07:29:14 +0000 (UTC)
X-FDA: 84438607428.14.A2BB91D
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf27.hostedemail.com (Postfix) with ESMTP id 992574000E
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 07:29:12 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=I1fiQCId;
	spf=pass (imf27.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770967752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fSwf5ADGpMtIggy35MSUTnrYPRQGw4N4LrsqqQW6yMw=;
	b=x7dAu7rgrccuYhaZHRcoWXjskIvL7LPghfHadtMlJzukBPaslXCQmT8zM+P0psyIXzQuL8
	AczLVYH/inGF3QEVfJMZBWs4MgXEGdm5sQbjbqjxkYqh7KgrsUfal6fiXHWFoOWWHG6kgY
	vcZ5fgKh0e2nCWONMFGEJqlyMacJ28M=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=I1fiQCId;
	spf=pass (imf27.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770967752; a=rsa-sha256;
	cv=none;
	b=5Pfro8WQutJcPQH6A5k8VexC7jPZ5s1nYVTG5TdQrBoc3yWIVnxO2ND9qeiEpgw4B7x16m
	ZyW6ob9StfryY+3MpLdyN1IFGoJi7RlMUeobHFQe6poTr/ziyDaEqgdixOnjqVfdKm9AOh
	tySioikavq93LkybRjRzfMO0Mxh8giM=
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770967750;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fSwf5ADGpMtIggy35MSUTnrYPRQGw4N4LrsqqQW6yMw=;
	b=I1fiQCIdi33AXVqAq540kk3FFgeJgOEnmlXDwjZd933vVw1+sSRvYUJ87b5Yy4QEt0JRgG
	Gtw99BbzPBQoBik4CHYFnqH432Sin748f4ljULf/1rUY/JyNqR3cGsIzoo1rgj7JiHZo4g
	/DYknPckRglXHqMKH36oBIfCO1HJUQQ=
Date: Fri, 13 Feb 2026 07:29:05 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: hui.zhu@linux.dev
Message-ID: <dd404ba15aeabb9f72d187f1045def2c873854bc@linux.dev>
TLS-Required: No
Subject: Re: [PATCH bpf-next 1/3] selftests/bpf: Check
 bpf_mem_cgroup_page_state return value
To: "JP Kobryn" <inwardvessel@gmail.com>, "Johannes Weiner"
 <hannes@cmpxchg.org>, "Michal Hocko" <mhocko@kernel.org>, "Roman
 Gushchin" <roman.gushchin@linux.dev>, "Shakeel Butt"
 <shakeel.butt@linux.dev>, "Muchun Song" <muchun.song@linux.dev>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Alexei Starovoitov"
 <ast@kernel.org>, "Daniel Borkmann" <daniel@iogearbox.net>, "Andrii
 Nakryiko" <andrii@kernel.org>, "Martin KaFai Lau" <martin.lau@linux.dev>,
 "Eduard Zingerman" <eddyz87@gmail.com>, "Song Liu" <song@kernel.org>,
 "Yonghong Song" <yonghong.song@linux.dev>, "John Fastabend"
 <john.fastabend@gmail.com>, "KP Singh" <kpsingh@kernel.org>, "Stanislav
 Fomichev" <sdf@fomichev.me>, "Hao Luo" <haoluo@google.com>, "Jiri Olsa"
 <jolsa@kernel.org>, "Shuah Khan" <shuah@kernel.org>, "Hui Zhu"
 <zhuhui@kylinos.cn>, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
 linux-kselftest@vger.kernel.org
In-Reply-To: <e49fc187-0ef8-4557-abac-0082653fa645@gmail.com>
References: <cover.1770883926.git.zhuhui@kylinos.cn>
 <042df9438d9e78bcd66f1fa0e7043b9ea8cda96c.1770883926.git.zhuhui@kylinos.cn>
 <e49fc187-0ef8-4557-abac-0082653fa645@gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: ffhf51xigkwqzwwrjscof39g6nux1y1d
X-Rspamd-Queue-Id: 992574000E
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770967752-323367
X-HE-Meta: U2FsdGVkX1+BEYB4TWLtlkZnB6tZ3YRlUce4ZyfbOoQp4ScgxSrAi1EMC3F69n1sn2NqSDycxT6zuRyNVgrpHCC39y/QK8dyMSBHUF+4Z7wFQ04DDMaq+cnJVhoi89klKY2ijmIs9C0HO8lxfvlAgx4OQ4fpA+7fF/ODL9zNcejr0WrpQjCyqjDRXINJBdF4aFJsio0FxBaiQ26qHayAw7kxbb/T/KpyH4BEf+Qw2soWXfU4eICeMHhJYpDCsNv4CMVjN4K9Ja/We+gJ3D7BUu/TzI9MjpvzBXoLVdVxsGMHeMQLbuZ9uOaaS7GQpluN0FlnxpwirYLrPM6X7KrsspIqvUpbA1vN1+l05Ims9iZEphmxkOqo24nPddhDbp1wtG4jGNlBBIDV6Pv7UlWz+xwpfqeRwyLimH/gma9ENHyHBQNxUjtsOERa312Wvo2PU+mqTltS8aYulmghg6fSS14C/0L2uK+x3GCammcbIKL37QsirB4FmCmnNU9ujj6Hqa23bkqFOGbDrrFXBws9alvnMAwxiX1khg2+CEMF/j7v/OU48e3ECPnt5jtFZn0JtSeCcb1AmTqLT7repUvTjdS1zuK1nXDyuBQNN3dHG6t9CVXhiUddrQSOOabI9iIXgN0PjYPtdh4r3U+ILTUxqojx3ZL+jBWnEWA2/hYvDxo7BLon3Va1YPzTLF7AtvDjxawFMxFCj1oiw79SzZF1c4fiDI52zkN419mlUdYCIVeIiPg3iNpb/iUMxdkf5OslctygjDRmb7szOci/u+db9Y+WHrz+YrEus1jM0psDTdfPRBVrxTWYhwuTLSg36qWpBLoCzgbGGQvpY9GhIfKYj0Yg2jH+6ZH/i5Af5wZZdSU1Z/sEaCjv07pbxkJ0/fPov88kmbMoEiWbm3Bp05cDEhlL6zTeDfjG/6AG+jFoJjhGRUq21+Fq01dVaeLz7S2MDJRcsiL8fpbUNhY3hSE
 aAEzvaRT
 75znGd5qUx0a2PIzgHlEclewLesrbxmeX8sUgukGE9vlQTiNuFxDRoG2RWBdutD0kZjdbnxn0VbCrebUWsx7+DEZxdCaM4qsD0yeyWc41pLwGgMgz2rsPhXpuKl5UjlJVXkzBSgJNU38oilUuUaAXOrKeriRdB//srpleUksUepk81NmYd7nVEri74C31Jid727jy7+Qc0vww15CTqPmjZJ8agj4oJeSDv46n8BJu09cAIFFe2VmPMacjrW55ti9/m5sQ5Fpqbhn0jA6d4OCQ6Yk9EmREcmFkP89XqI9adR9cjTH1ealiOTsjskUKgwS4rZb//446zhQCt1frZriF1L23Q6poGWgTIDnV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

2026=E5=B9=B42=E6=9C=8813=E6=97=A5 08:14, "JP Kobryn" <inwardvessel@gmail=
.com mailto:inwardvessel@gmail.com?to=3D%22JP%20Kobryn%22%20%3Cinwardvess=
el%40gmail.com%3E > =E5=86=99=E5=88=B0:


>=20
>=20On 2/12/26 12:23 AM, Hui Zhu wrote:
>=20
>=20>=20
>=20> From: Hui Zhu <zhuhui@kylinos.cn>
> >  When back-porting test_progs to different kernel versions, I encount=
ered
> >  an issue where the test_cgroup_iter_memcg test would falsely pass ev=
en
> >  when bpf_mem_cgroup_page_state() failed.
> >  The problem occurs when test_progs compiled on one kernel version is
> >  executed on another kernel with different enum values for memory
> >  statistics (e.g., NR_ANON_MAPPED, NR_FILE_PAGES). [...]
> >=20
>=20This patch looks good but I think to fully solve this cross-kernel is=
sue
> we should use co-re in the bpf program. In your second revision, can yo=
u
> add an additional patch to make use of bpf_core_enum_value()? This way
> instead of relying on enum values in vmlinux.h at compile-time, we use
> the btf info at load-time instead to get the proper value for the given
> kernel.
>

I post v2 according to your comments.
Thanks for your review.

Best,
Hui

