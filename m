Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3205FC87FCA
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 16:27:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFAD26B0088; Fri,  1 Aug 2025 12:27:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD2506B0089; Fri,  1 Aug 2025 12:27:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E7FA6B008A; Fri,  1 Aug 2025 12:27:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8FFAA6B0088
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 12:27:30 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3EBE3140255
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 16:27:30 +0000 (UTC)
X-FDA: 83728719060.11.EBAE3CD
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	by imf06.hostedemail.com (Postfix) with ESMTP id 58271180003
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 16:27:28 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=PS7eWkJw;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of kuniyu@google.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=kuniyu@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754065648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KPlDNUMymhsODNFmsd1JRKJrfbGJJsVHVjtAtmZ8nro=;
	b=JGTJPqv3CBel19PbOst3BSysRFGRVgjyRM6xfZDpK49Jt62YvVRsOcRpW8a4Vgrvv7cqpF
	RLSPnD7/YypSZilMDiHzwox7y66UPKrKVVzbm93Ve2MQP76GC9ZEJWZaNoReFaoaB4mTOM
	GDTL6VVHi/+f5CbEBjW5HN0U+88OrCM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754065648; a=rsa-sha256;
	cv=none;
	b=Gt5tX9xBGAWQGVJ0BFTS2s53mb4iAv7700tUqTgK2db40PZnMeASQeV0+cNygB3kHv22Ge
	BzsKb6AYr+qDHGc4U2jJ/Eo4SMxEER8CpJgj1XHHLxGMqcQb+79DJkRUaAXYr7vdwAAQFk
	4swhy82n3vCfItwuSZywqYlWKp178W4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=PS7eWkJw;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of kuniyu@google.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=kuniyu@google.com
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-b3f7404710aso2082300a12.0
        for <linux-mm@kvack.org>; Fri, 01 Aug 2025 09:27:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754065647; x=1754670447; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KPlDNUMymhsODNFmsd1JRKJrfbGJJsVHVjtAtmZ8nro=;
        b=PS7eWkJwsTeF/BNsBG5+/RFZiMy4vpgdBsKl7k4DfnC488kYYo1tF7u0V1RcsUwqpv
         JURtAXQ+1J9tGYFD9y+NkRjHP0aI1yNfv4ZEaw4/ikmiyje6iYloia0DNtd0N+yB1yhJ
         GSl199J4AJqXAgIDlBFf6TtKeze+bPAaGI/Qj1rSHkcHY1D2dSgEEsa7mGsVLQ3EGd49
         /AF4TvY/gPLVDbaNTxNxty1sqzBGX3ghFEpipZeIHrOzjG8NgjjluWJSf+ZaqjN/U5ML
         4Z+D/52si3t3eqRuhBm3QJTCg0yBaXZ6PBNg82y38cJGewQ5IKm6JCoPMh4SX37a508I
         6KbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754065647; x=1754670447;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KPlDNUMymhsODNFmsd1JRKJrfbGJJsVHVjtAtmZ8nro=;
        b=jYJpU/wzoI0c396jko1joPKBfLWHu3Byah0x6aLXJYSNpcBffEp4vG0U6BSBO9BDyv
         tZwsZ5u//X78lK7ofmbvSH+8amx7jPHekhNa+uGCNOI7i3RVtmbIo0gHU4WijRpj7zw2
         jDLtA2vJ/oQ9KzNzFozrR8a9Rt2R7oWZzVD4drrwg//oTyQ57IbtaI2qaHD30hqoctuL
         66YV/Aip7pf8CqWprjLVj7j3n6TYpGwMd2Dx8WUMAczj/QgfVV/Ni5kBu4lCgJ+9nCIo
         Tt3FijNfX1cS8plSCz2BjjugNGZK+15jdGgwFIcfQTDu3GqmjducGJMoKEn/uTpZdXoy
         +GRQ==
X-Forwarded-Encrypted: i=1; AJvYcCUQSXA60QrpV0iMWlRCTdZ5XaTAb/VdB3v8Q5vX34hFBpUWcZemrR2KWtIXTJRvR1sonIbDtr1Btw==@kvack.org
X-Gm-Message-State: AOJu0YwQ3z5T/3zmiluDLqmN4jUoDl65JbCs5CZx8iyt+qrTW1Ba/Rla
	C8ZpU2k/eN3DMPZ23sn0cxwY93X8d5kzfk6lYGqphJa6r57XXlQ2MVY3FLlliQ04ZW7slXruvLS
	WuKk6ERo+LHHl92LwbBvJIWVf6GbP5m7IZCdonxq0
X-Gm-Gg: ASbGncu84OXJTwiZqiHtiAr8ywJVOifqnmdUCLLMIjY6Xn9uknNqfg91tpJ6292+4hB
	f6RyzoR4FF7DfE3sc+omSLPetHDzieTWXuhqajjQpR+NjZoBuTiMn+SlKp3nKH5dJiYPAhL0L/a
	OhZZ8y/ttnX+3OjLLFQXNVW0rmLDQrmkOLMMBX4TAF4Zoz49SzPqDZx9R+k5qt43+gBunMRCL1N
	aRj+KAXqKcjsKZEKOXGPg0WSG6PS63K9PLVIOEy7vRj8GNnvUg=
X-Google-Smtp-Source: AGHT+IGrbCrNLGqTtBuWiAzE0+U3e1NMQB2FNpi+8gjkEuVtCmtDODuiea5OBd3jquswfNAUuJ4/jdmM5dWBSs9hwSU=
X-Received: by 2002:a17:90b:4a02:b0:31f:20a:b54c with SMTP id
 98e67ed59e1d1-32116115530mr791605a91.0.1754065646975; Fri, 01 Aug 2025
 09:27:26 -0700 (PDT)
MIME-Version: 1.0
References: <20250721203624.3807041-1-kuniyu@google.com> <20250721203624.3807041-14-kuniyu@google.com>
 <fq3wlkkedbv6ijj7pgc7haopgafoovd7qem7myccqg2ot43kzk@dui4war55ufk>
 <CAAVpQUAFAsmPPF0gRMqDNWJmktegk6w=s1TPS9hGJpHQzXT-sg@mail.gmail.com> <ekte46qtwawpvdijdmoqhl2pcwtfhxgl6ubxjkgkiitrtfnvpu@5n7kwkj4fs2t>
In-Reply-To: <ekte46qtwawpvdijdmoqhl2pcwtfhxgl6ubxjkgkiitrtfnvpu@5n7kwkj4fs2t>
From: Kuniyuki Iwashima <kuniyu@google.com>
Date: Fri, 1 Aug 2025 09:27:15 -0700
X-Gm-Features: Ac12FXySWBq5tqGpyUdEEo4tML_igvMbcYh9DoXD653V26VGI_HquHEhRn-c55o
Message-ID: <CAAVpQUCf=xHc7nx5Y5rZ4PcPt+PN9kdWvGo5jzRyNkubq-sRYg@mail.gmail.com>
Subject: Re: [PATCH v1 net-next 13/13] net-memcg: Allow decoupling memcg from
 global protocol memory accounting.
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc: "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Neal Cardwell <ncardwell@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Willem de Bruijn <willemb@google.com>, Matthieu Baerts <matttbe@kernel.org>, 
	Mat Martineau <martineau@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Simon Horman <horms@kernel.org>, Geliang Tang <geliang@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org, 
	mptcp@lists.linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 58271180003
X-Stat-Signature: 9o4i476ch8tu4gdieqxh4raz9mnn3okp
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754065648-689787
X-HE-Meta: U2FsdGVkX18Z7/1nP9qXqcZYWjDcR42G2t2O+NNUI9jFQLcP81IAnmvMA5R7F2mI1MRrz1JlIwKwj+R32KYpAwdatvZEVq+pV2WLtk7x/GhG5j6xzdLrouIkjPKQkexDsVBwgYXm/ekyiCt1XfyImGm8sQ/cJmRw7ks8t54kckWQirEZ7XaQ8BQL6KNpt3IzQQ3ulCOYl66Gt/Qcny3izcmjBSk2hrWQ1VIPF1nXewp49WkB2Qrxt/RXVZMVXSgLEZR+NZTKu2Oo2mpWO51qqJ2mnbnWFsMSbcH5Z7ITg3kIGda7zGjR8qtuPJ8wkwnib2MAotjozP9C1Zv9vTHI3HbwQHzxqZtHtQeGeI4N/GBfvXmatbRvClH0rcYk+Pg4Wl75Fd2Yc0cbyTzLxCENG3QjW2AAcXnIMlWDDw0tyoa4QxZ0LxM1h9BizQpKKlNUZh6YCQJZ6emOiOEzi+GNx9pV0rOcw1F5D14yv8yrRSgsgYJGUbQxQelCkvEKSOcqEUrUN+JyIzA/nzQN/7VZU8EBz51GhYDh9Ig21f5zqgSOdLPU9X4MW3RLkV7ToTN75bLw5XNYuKpO+BNkIiKnC4s2wm/dZCmy3ah5IkzTRbVC5kpNOR1asX8sLFKKTptjGH5MqeXzDfwqNXV2LIRFX9UF4BzvCwcNMt73fkVe/Of1S3xv5woFdHyPEiS8rTVVyhdNnM/ApYKBGgjSfM0/DLuQn8II7dliVDHXrNUZ7aGtiQGb7/rIvRNzoOYPI6FSodGFLzop1XlJbYZJ6kkwhSnsMHiBAsaC/Q4ycTEFsFqc6p9P3WGTtIp5lCb5z4vJxm3CHJpJQpY4/FfcrmUrkgMx+khLO+SP4GEwFNnO9V/mKx9egITHG/bkfz7Y42X7qNCteajd9yqrVzuGWPxk7rXiluZhykL7Ir2ejSh7NMXf/IMrjt5pU8RIx7zTHxIYncbLV07mn1BogeCk4bx
 0oLWU2s7
 tcBo3SphoNOove+ypd3xVphvQgo/TFRNot3MV1fUBV4Xl24B2Sbz+S26MhRYwVKMOx9L45MZXz8CJTAIBtwGyf67/hzBndbbkmEluxCtDlF/apf/hWvh7JcqmysjKXnpzbdJZu+ewz5njn3xbqnTZH9tUgydMWcaCRFoyD9U5wpxXGzXVk0Fj37MpdSatR9VCBmrDIlbwFiFPDlqzrpgpGfv6m2mX8vteHcVim8uohTp9erCWftz/eBGCfE7jikLX+W7wtP/mai0YUT6Gp7iGxF69wA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 1, 2025 at 12:00=E2=80=AFAM Michal Koutn=C3=BD <mkoutny@suse.co=
m> wrote:
>
> On Thu, Jul 31, 2025 at 04:51:43PM -0700, Kuniyuki Iwashima <kuniyu@googl=
e.com> wrote:
> > Doesn't that end up implementing another tcp_mem[] which now
> > enforce limits on uncontrolled cgroups (memory.max =3D=3D max) ?
> > Or it will simply end up with the system-wide OOM killer ?
>
> I meant to rely on use the exisiting mem_cgroup_charge_skmem(), i.e.
> there'd be always memory.max < max (ensured by the configuring agent).
> But you're right the OOM _may_ be global if the limit is too loose.
>
> Actually, as I think about it, another configuration option would be to
> reorganize the memcg tree and put all non-isolated memcgs under one
> ancestor and set its memory.max limit (so that it's shared among them
> like the global limit).

Interesting.  Is it still possible if other controllers are configured
differently and form a hierarchy ?  It sounds cgroup-v1-ish.

Or preparing an independent fake memcg for non-isolated socket
and tying it to sk->sk_memcg could be an option ?

The drawback of the option is that socket is not charged to each
memcg and we cannot monitor the usage via memory.stat:sock
and make it a bit difficult to configure memory.max based on it.

Another idea that I have is get rid of the knob and only allow
decoupling memcg from TCP mem accounting only for controlled
cgroup.

This makes it possible to configure memcg by memory.max only
but does not add any change for uncontrolled cgroup from the
current situation.

---8<---
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 85decc4319f9..6d7084a32b12 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5102,7 +5102,8 @@ static void mem_cgroup_sk_set(struct sock *sk,
const struct mem_cgroup *memcg)
 {
        unsigned long val =3D (unsigned long)memcg;

-       val |=3D READ_ONCE(memcg->socket_isolated);
+       if (memcg->memory.max !=3D PAGE_COUNTER_MAX)
+               val |=3D MEMCG_SOCK_ISOLATED;

        sk->sk_memcg =3D (struct mem_cgroup *)val;
 }
---8<---

