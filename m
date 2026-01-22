Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B65DD6CFA1
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 18:18:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D7236B02ED; Thu, 22 Jan 2026 13:18:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AF2D6B02EE; Thu, 22 Jan 2026 13:18:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D1926B02F1; Thu, 22 Jan 2026 13:18:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4DB7D6B02ED
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 13:18:44 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EB6C8C1D5C
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 18:18:43 +0000 (UTC)
X-FDA: 84360410526.08.E967E38
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf05.hostedemail.com (Postfix) with ESMTP id EA2C5100003
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 18:18:41 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="WJhC/SJs";
	spf=pass (imf05.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769105922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rUUSYk75yHSKQkrJ/9Eh/39Gsadu8Q7tI7No8P2IvHA=;
	b=tbxgrtjnDkCqgG8sZ35GyaN1QxbT9d0E9cGHN2+ev1MWFxVz+NtXArQjx59OEETNHy5UqY
	JYpVO24lC7dn7ZHmYt/mv4O+cIwlW1Jlz4/G0+fJMPX8MfSl4rS80sN4HhHlVaD1xPzIob
	EXk8ONW4JambUB8Roalf6ZtqUCPv5PY=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="WJhC/SJs";
	spf=pass (imf05.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769105922; a=rsa-sha256;
	cv=pass;
	b=QTGOZCKDhOUt0YXIx2QzGKM1x1XJKJU4bfXx6QhUG85yKZp3J6d4aNz1m/4AOc4gFvTTgX
	CmAkPwM3rXfhAGKCMegz2W8nFtMkTQ/g5UDrAOB3fLmRWdHxPXvoIunHECiwxt+pGQHS9/
	FS+1/oahVGH4k6oRaDxAQHsaV4gfZJ4=
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-652fdd043f9so2240138a12.1
        for <linux-mm@kvack.org>; Thu, 22 Jan 2026 10:18:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769105920; cv=none;
        d=google.com; s=arc-20240605;
        b=kYuqnxD+RVVDUg8E5us4iMoFKd9ipSzj4c44n/r0qoT3/fS0/5No4S1JTMIWAqx8c9
         qMpOlHuGgildFLQWJxdZQ+kJA/MNA3bV1oKBnuh0qtQvmw+Cmyh7oS438VYUPw0TKXKN
         Q+n/u4Yd4w/9ruDt2615hhl0MXHgppFJtC3/eZ7gK1fT/biEC2VQWumtGSkfiUzfZq4j
         bnh51T9gVm2zeTGjIzW/62d/p8L8LVIRd4jydWh3Qbszhs4XfhxPE1yNLgiAtVXYjClV
         AtoW93YeuY/Rb1NKItnexRnEMlfRK80V+nbeN0uFLEE9MloOb4EIvrEENkg6ut8m0sas
         pWZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rUUSYk75yHSKQkrJ/9Eh/39Gsadu8Q7tI7No8P2IvHA=;
        fh=VybWZuYgI5DQLUYf9DJY985n8ui3sm958GlDFWuc4EA=;
        b=G6UTytP+C8EtizL04s3NjECA03Wm8EkCArplnu1scJ+ax8/b0ysdvEBoJhutBxnuaL
         1r8oURi68tm10qtCyRSYFS9/In9dP6mGChGt9syOyw6Jl5++ZBI3+N3YTxdDhBWIS3Uv
         4X+u4PYtkuNht4caK+vLakMr88/A3V2zxFA7Mv1QimKQYr7eHH1+KQ8DKYrY/8iTfoNG
         IwOKH44fhxNCxmDu7LpVCI83IBFdEmLTF06Bej6hPXFFDQKHYDS4+kpJXxVvOtQ6bwkv
         /4tzzO2ih26SXJ3SwJzyQXrC5ARe0QyoLmFMTQfd8KhxWX1dwS4KHEfkNC6MWH2Ex1TV
         +S2Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1769105920; x=1769710720; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rUUSYk75yHSKQkrJ/9Eh/39Gsadu8Q7tI7No8P2IvHA=;
        b=WJhC/SJsx8ItlPz/th/e+1AHr4+4/m0WnPx8jETFk2H7iRuRjQ/hgzOlTG6KRJG2FI
         yd9NyAtdwFnqWbrmFpfRgjExWFU+DADTx1E41z/72VpQo/03AWj7jFZIPN0+E4dW0Xgl
         cxAJNi8qFSYLYZNLbHTUFwujYk3IK1b+GpZovsKOjIlSrOQjWJG81w/s224sheQeA2uw
         0KWSf/fMBQF1YdfN7DB9kMIOllHT6XG282ahIbjtBbNat2mTv3aToJhlErinYhLoKcOr
         X5bRU7cQ07DBvhZvryDN5apg+//6qIVENIQkowxASRPeUMoDiu4evAXaTBbiY9rl9S2r
         M7hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769105920; x=1769710720;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rUUSYk75yHSKQkrJ/9Eh/39Gsadu8Q7tI7No8P2IvHA=;
        b=rC2MvHeOQw7oZ+FqNbULqK0igq7TGlIFyvN4XEmpZhfJ2FHDlHLH3LmLHMlPjPZchg
         u6bhfU4p9OE33k4lkdGRfD4+Uq6+kj24kK0FuIcQ+HcOdEDaUGaKEY9olLrRRo2qIZ8Y
         aqsh+gP2hOobtXF7cgJL/TPA/bu0aPVDDgy/XlFSa4bZ/b/wnufZ1nqn/dN4q+qNyO6d
         Nf5ms4dQ26OAm1oiEB7hkTMperurGEjrQoxYtqaORn2O0ovAZYOO2YO5iyu3dhE0F5q5
         GlOf4MFlyBmWc+1Xc1blQ56PEzw1OZxRZYl1CX24tCjcIQHwCi3wU7qaO6yQfprfP8Pe
         C4/g==
X-Forwarded-Encrypted: i=1; AJvYcCVtKHwuMPB4fJ3Mx+fSnQo+vdyLB7gzK0WQ3k8rX6TtRD2D/enJVbr+EQIn4L3u4bxKhhWTNftihw==@kvack.org
X-Gm-Message-State: AOJu0YyLlNjmFBTPKP4vLRMptwNWPobikCAi2z4QuRYDb3Dku39JdbAQ
	TF4htBmSLgWX6LaT+4dfQRNo9k8Bq4GDKjoMKiT+QUMEdVB4wh0gdO3bnF3NDMiOk4UjrdHZHoI
	FTMgT7aCEUo3g+IUAhxFiSSwo21uOfAyceKjguZkHZA==
X-Gm-Gg: AZuq6aJJT25gd3IWw2poCNp0wh1HmM282qzlUfmYRo4PaOs6QrneGfKlYeeDLOL+u84
	cij/7Cg+Snt4lbEKukOTZOGy+/dea2FLJC/yFNQV8CX3Vw1TDE0tR3FU3xdNTfN+49dW7Tqjefe
	2MXi6uN6jibZR+D83yBA9xkmTREPa1E19G7+fbUIJ1vZ5vu6YI4PNlV8++H520HwtKgNTf5p2AQ
	vdgLmXpMKjFnGqmYtwiHBpn2zDGYsxCKaeXf1p9hxygbZogJh7RXpj5upWULeZ2M63lwD7AitWx
	uMXDy1dC2o5bs25kcV/YShjb0g==
X-Received: by 2002:a05:6402:2714:b0:64d:498b:aefd with SMTP id
 4fb4d7f45d1cf-6584874e332mr336027a12.5.1769105920515; Thu, 22 Jan 2026
 10:18:40 -0800 (PST)
MIME-Version: 1.0
References: <20260120175913.34368-1-epetron@amazon.de>
In-Reply-To: <20260120175913.34368-1-epetron@amazon.de>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Thu, 22 Jan 2026 13:18:04 -0500
X-Gm-Features: AZwV_QgWHU5xyibFUjuLYel9awdHxBW6MBa7iM3aXogi00k15P2X6oDpylsDrzg
Message-ID: <CA+CK2bA-pzGO83wi63A1QFe=u33HXKTw6Po7j7W0PN4dK7WG9A@mail.gmail.com>
Subject: Re: [PATCH v2] kho: skip memoryless NUMA nodes when reserving scratch areas
To: Evangelos Petrongonas <epetron@amazon.de>
Cc: Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, 
	Alexander Graf <graf@amazon.com>, Jason Miu <jasonmiu@google.com>, linux-kernel@vger.kernel.org, 
	kexec@lists.infradead.org, linux-mm@kvack.org, nh-open-source@amazon.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: EA2C5100003
X-Stat-Signature: 9s74xjemaf7pyxymhy34azmbhge5fctd
X-Rspam-User: 
X-HE-Tag: 1769105921-553718
X-HE-Meta: U2FsdGVkX1/ocncjmnfdUttPBGd3Pj6nS353sA0LJdusBTJiWjbFuXgqp169JuLI6XxCsSQ5d9mY0ndKVaC/N30WtC2J+e3ZDIecJNYfImtTbnv6HKGog7RUrzoGXxjGBHVB6xZuXcjaJmnIe4la0z9wop7K5yslsPZRwG/ZTrMZeXkidWGNbtv6NWAkRN7mNPck4zbT21pZ0TZOihWl0d1wFmzzeuiAM5WuSbREm6+g5aV7U1i4/z79NJMRdWer7qA6BKE0EMrrPPwTNLzKA2rhbXqVdw1asPsLD9cfRERRwvVvFeBmqmcoFRhmPhgXjP28kW46JiTG/urXWVXLoK9iXknss1hPaGM1lAdj9XBJD95LBZFh029H0irazpOyMI0+fnb9PIOm1L7RQgU7LNgFIR5o7eIbRkj75qRllIVSAeFOWAOi2Nw05aAN7PDtukCD5s3udbK/RXvkXuC65o5Cr7vXFxDe6r8ajszTRnSf8dOsBpS9N/R7+AuZPStkR2nL82nP4qq4BaChWV7hYzLxDdydDi6tf3cdfpILR0y96kC2a2owFx9yRwMbstXQ1PPepHx3uSuKgGqEZ3WuHZerQ3RVKFIao78fcyFemuYAmixvxDn3RDCETwdg1DeQfXlMyxUuX4M58ZWUsja0+DBILvd35Xy8mUM/eyBv0l+Ii40e6FwBwu0Ni9GVKckcBBsbzMl2MbUvNblyETvOJkNgaar5kzeuncONyMZVabuu93Qxvsv6j1P6Wq0XVuRz4waE3lDfkYoMQiO5JqtnyMUPT0ZqbQ+/2SwWS8Hncp+gMqsM/GgSlsveG+CBGKTl2tRZbwDOVbJt3ODLQne7+5KB8W5IqerwrwTXE4+Rt20L8SDUUEi8LApy++tV6HpMQChEtQqC+C0Fed2SXWRu2W9JrRKCdpPQD1croGD5z0kFAIjbSbhe6PdGKsfqcp8GE4m/kzaYAetpOtZtK1C
 5paxKPIK
 7EhYjQkT1jUBEjVqRw7IbyKwNs2EEvFcxFp1LYCtqh7+Lf/yM4VbiUI4bVheK6JtUf5959984H8XZU7wTt2LcM13kHNmXMuen/9AJJzxdQzvvDALO3j1ByIOSl+ds6rWm0AYuYE26dl7UIjE5RbMuQPcAR4dXU5MLMKncFS4gCqlbt++0byVR18hrbbsBTWR5ZTFBKKfrBjxJkQQm/JX/g0aBKybp8hetI11x7DJaSGhdTQfutkXH+w48RjBN5dHEkEYF/85ZU31M55n87G2IWklrvboBedSastCbsk86Iwp/yUJGiWHTXvNwf67uc5v4cPWuIlDixtF1jrpiBQvoWA113Izdj22RiTtJb/JMuPV2l5Ed1x1C/rvPkA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 20, 2026 at 12:59=E2=80=AFPM Evangelos Petrongonas
<epetron@amazon.de> wrote:
>
> kho_reserve_scratch() iterates over all online NUMA nodes to allocate
> per-node scratch memory. On systems with memoryless NUMA nodes (nodes
> that have CPUs but no memory), memblock_alloc_range_nid() fails because
> there is no memory available on that node. This causes KHO initialization
> to fail and kho_enable to be set to false.
>
> Some ARM64 systems have NUMA topologies where certain nodes contain only
> CPUs without any associated memory. These configurations are valid and
> should not prevent KHO from functioning.
>
> Fix this by only counting nodes that have memory (N_MEMORY state) and
> skip memoryless nodes in the per-node scratch allocation loop.
>
> Signed-off-by: Evangelos Petrongonas <epetron@amazon.de>
> ---
> v2:
> - Removed kho_mem_nodes_count in favour of nodes_weight(nodes_state[N_MEM=
ORY])
> - Use for_each_node_state(nid, N_MEMORY) to loop over nodes that are both
> online and have memory.
> TIL: Nodes in N_MEMORY are a subset of those that are online. Thanks Mike=
 :)
>
>  kernel/liveupdate/kexec_handover.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec=
_handover.c
> index 9dc51fab604f..979ebaf015bf 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -643,7 +643,7 @@ static void __init kho_reserve_scratch(void)
>         scratch_size_update();
>
>         /* FIXME: deal with node hot-plug/remove */
> -       kho_scratch_cnt =3D num_online_nodes() + 2;
> +       kho_scratch_cnt =3D nodes_weight(node_states[N_MEMORY]) + 2;
>         size =3D kho_scratch_cnt * sizeof(*kho_scratch);
>         kho_scratch =3D memblock_alloc(size, PAGE_SIZE);
>         if (!kho_scratch)
> @@ -673,7 +673,11 @@ static void __init kho_reserve_scratch(void)
>         kho_scratch[i].size =3D size;
>         i++;
>
> -       for_each_online_node(nid) {
> +       /*
> +        * Loop over nodes that have both memory and are online. Skip
> +        * memoryless nodes, as we can not allocate scratch areas there.
> +        */
> +       for_each_node_state(nid, N_MEMORY) {
>                 size =3D scratch_size_node(nid);
>                 addr =3D memblock_alloc_range_nid(size, CMA_MIN_ALIGNMENT=
_BYTES,
>                                                 0, MEMBLOCK_ALLOC_ACCESSI=
BLE,

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>

