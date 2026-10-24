Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8CFD606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 24 Oct 2026 07:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=C66Wz9GK
Received: by kanga.kvack.org (Postfix)
	id CFF716B015E; Sat, 24 Oct 2026 03:22:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB01B6B0661; Sat, 24 Oct 2026 03:22:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCC8F6B0AE0; Sat, 24 Oct 2026 03:22:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 99FE06B015E
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 03:22:33 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9A4A6120346
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 07:22:32 +0000 (UTC)
X-FDA: 85356676944.22.C349457
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id BDFC9160003
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 07:22:30 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C66Wz9GK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792826550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TkGvhbo8uCfcmT5BQSwIkA1ZNaWITnDyLwroqOawhFA=;
	b=ScQd/bjeACFt4rLKbk1n8wAf+kGPy/LGh1Uu/i35g+VsQ9wCih2NIpIeHk3IBhlmNjhrCF
	DHSERGNkA8AtZwAhm08Z7usJTd8LgNXkyPIT7Add+WWNrR9QySE83nnY6whnxm4uJCJ+mf
	ioWieK1GCnLk7PXpVLof7TMo/Gtyoh8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C66Wz9GK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792826550;
	b=zzaVHlpdy03FfVe+BBEKx+vFVWBvZxfOxkK9fRf+qyZlOCWIYfsyRSDrMAHX+WaKadTrnk
	Tn8sPeiNoDRJuKcN0R5bhH7h/ECkInN7vGV0nv/GpTl0l5WStqlSMKcOxUlAAmBePT/PJV
	6P0rkHXkMBnewb4T9xXz6qG4pVLsZhk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 474F643EED
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 07:22:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27E8B1F031E4
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 07:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792826549;
	bh=TkGvhbo8uCfcmT5BQSwIkA1ZNaWITnDyLwroqOawhFA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=C66Wz9GKMH9eWP3KjPne9n1gdC4LfnIDpgTBj18latoVkXOi5f8/BiwnoQ+pw7Jym
	 9Ugyp50w53PhzBHJjiWK5gPvLwW3lcjB7mZ+FMvTtWxwkUpX/8WRGr2LCXCwRhvrrH
	 hki5q9lJcrQt0yNY8OSjhrztMPEqhUFkY0aW4JZ0oV9VAmRfBNU0v/o7HSNBxbql64
	 7qYTzvgL8jFqSuiSrnxfgM7CDFATdqkG6601ofKjJk+qESWsqs01zXqPh8ksRUEutG
	 gnm2pNyCoGLuIqwU7AkaV9uweRXZfdeHEZTBtMrOENMVC0zaaIBcJ/tEWOFGYmuVY4
	 7uJlMNZ6dw8EQ==
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-93f1ca4132bso132522185a.0
        for <linux-mm@kvack.org>; Sat, 24 Oct 2026 00:22:29 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzOAT5F6bNh4tFLXp5iXG7zvsorE9UHJYyirCqvMGUKv341M6wrao+zKicl757uSGIeCWQbWCSPfQ==@kvack.org
X-Gm-Message-State: AFq9FYIs7yEXmu/E1TCwVQMjbYMNDe6hJXkzyxOCceEMj/HZNVOP+3EN
	Rk5DHbz73jL6ZyxMa5yy4cy+S/fAKFDlX2aAEja2e9CUr83ejg7fikJSHZcvvjWtsFO46MIZE+g
	j1ohmuikDpoSdFrrX+/wpgrEnL31dE9k=
X-Received: by 2002:a05:620a:4385:b0:93f:953:9a1d with SMTP id
 af79cd13be357-940ef9bc448mr169348385a.67.1792826548495; Sat, 24 Oct 2026
 00:22:28 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261019034426.2354049-1-ridong.chen@linux.dev> <20261019035252.2357900-2-ridong.chen@linux.dev>
In-Reply-To: <20261019035252.2357900-2-ridong.chen@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Sat, 24 Oct 2026 15:22:17 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yQrp3kKJfkXPyLN35Zk_O_gBvnPnUmbwxCU2GVzrE-Zw@mail.gmail.com>
X-Gm-Features: AclHuK89s87eEZ3BnSPuNzTPl5Fwn-4GMSCXcuFKmZMlVEBMhQsRB9l0-sHv3zY
Message-ID: <CAGsJ_4yQrp3kKJfkXPyLN35Zk_O_gBvnPnUmbwxCU2GVzrE-Zw@mail.gmail.com>
Subject: Re: [PATCH v4 2/9] mm/vmscan: move vmscan tracepoints to a local header
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Dave Chinner <david@fromorbit.com>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, bpf@vger.kernel.org, 
	Ridong Chen <chenridong@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: BDFC9160003
X-Stat-Signature: xeyfyetgop7jzdgkrtjp4mro5pbujid4
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792826550-603217
X-HE-Meta: U2FsdGVkX193vVVdwEaD+NNgYNkN8d3HET44pgQj6V0Z8zA1Q5eM3rgI7y+rO3/kYb71gW1MR4LLPntzZqJurB6Js7GDlo/SyiqP5w1vMcFJELHvc5ec8qou9znecZQEFH47PW/ynqbpUrBGR6Vr95Q0t5MND/DKpiBGxJW9RYQ7Ldns2jo48xMX8Jqa36bkHQg3uPSmhs2TuhwL40yqvKmYLDQWN2GEitrtbrYZ7oncySntqy3feQwOvOW9gH3WHX5dTHXl5QyRuWiTalXWXfIGO+m3khm9I6tECQuSjVP7wVooVn+lo4MI+PkvMsmdb31o+oKwZDWAsRHeYekzJBKbGkRt1ztvDTDIBbeEaaHCzN3Yc+sbluVk0/U2qvlaa9+Dlx5X7Yx1g0W/6c4/ucFmtADUlL60GoxLzuIVFpaLvVPFAB91bDaf5OpBQdwIvHe13KeW/UZXRwne3uMnisQuLMJSyr8oKaES+MTnI+gwB0q9xvgY2VSWmsfjBZFdrD/5z9YmsnhU1PxevUvCT3EmkivXCIdOab1BtTMdCP3Ke5NY27Wofjw63aDkcfYSl3/8dOjU0+iDeBOB9gBRenpdIgoc9hG/jGcax7X28MOHp0JjAPuwIUwXT85k/5Gouebj7Jh0g+SQdidjv+fL1EpAj2durHeuIwthHWMbIQs412afORqWGmq87miFMmNVvWjRanBfVtFsjydmSUNAVfsmRBdvh/u2OE6PH5VL8eVLaIEDzzUPAJJ35iV5BDmR8M9q4ugdQkmCpN7hWZTOruabToe9eRlQ6QvxHTxdXZ/A2xIUEUdsy6Gmf2gxRI8cxFyR355l/rkMDOpneSFyQDGQBjqwA51Zzk+7ReHs4X+QN+NOuf4/OGp55mn3FlN1MOWoezQLSs4HFCrYQJjhMXtfc19Rl28ZlAXKSR7xINCYBRQJerHmQbvPuZC+3Wv4W2W/CB6Cu1AsjHm4xHa
 mtL67x8t
 tqPhRS2OQ9PvvmxodinMwjX8e5Zr/Qd1mjA4GHVGIY5P0gpbLpJH0mpNP3MWs0CCtt8u8xKwfnROgx2Ady2Pyj4outa8NcRzLnrNFmI1Lv43w9ZzWcpSEycSbFA7Q+ONOrR66Wvy08zUkG7mAmz9HzVH06oys2k+CVM0tB/nQ2fZJNzi7USAMzvNbF8AJ15qv/Vit6otbqdR8hleDt4Fy4lR44tE1vyjeGVooPOtzxNqJdSXyVfkNauFOcAsZuLD36FQovbmgKe/J7uImJVnkCftAyquENnbJJq/DzeESgLJcAoQUe6kQdxQJG4J2236i3PRArgqW7q51X+U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 19, 2026 at 11:53=E2=80=AFAM Ridong Chen <ridong.chen@linux.dev=
> wrote:
>
> From: Ridong Chen <chenridong@xiaomi.com>
>
> Move include/trace/events/vmscan.h to mm/trace_vmscan.h so that the
> tracepoints can be extended to reference vmscan-internal structures such
> as struct scan_control, which is not visible outside mm/.  This mirrors
> what several other subsystems already do with their trace headers (e.g.
> fs/fuse/fuse_trace.h, fs/gfs2/trace_gfs2.h, fs/lockd/trace.h).  As they
> do, set TRACE_INCLUDE_PATH to "." and add mm/ to the include path of
> vmscan.o, the only user that defines CREATE_TRACE_POINTS.
>
> No functional change.
>
> Assisted-by: LLM
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---

Reviewed-by: Barry Song <baohua@kernel.org>

