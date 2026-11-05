Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC08C606A330
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 03:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YGjYA7GK
Received: by kanga.kvack.org (Postfix)
	id 12E636B05B0; Wed,  4 Nov 2026 22:34:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DFA16B05B3; Wed,  4 Nov 2026 22:34:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3A1F6B05B4; Wed,  4 Nov 2026 22:34:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D66776B05B0
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 22:34:05 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 74F0EA0930
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 03:34:05 +0000 (UTC)
X-FDA: 85399646850.23.143CCDD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9ECFE1C0005
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 03:34:03 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YGjYA7GK;
	spf=pass (imf20.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793849643;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l+Yp56smGIs8eBVmZ42TlX/QjRgKCo02jmsCVaG2LHM=;
	b=4xlUn8P1IMgj4xnL+cC5oIYp8YenFJsgomwcRySggrR2DR/qWuOCrcBumde82qSZdeKg+d
	HLl4XXEo0iJqdfijryG3wMCbxAE9zEQBkFus04jxvQb6uc+tUXgJDRhlWByLIcEz8ffbyW
	LjeMJmRKnBMtBqTZtiseRK4Lw2Y5W1c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793849643;
	b=Jl1yu2SEBg3dy3W2UIgL9gEzAXfuQMrXcjKItXzm79HpbLxsIkGfaQHzld/IgepKSPZv1Z
	EvGpvP/Es7Y8mfx0iXUQfmdJ3zSLVRXwmA8K0O3hl9v6QeZouR6h5ppcaG6KOLoQTNQQeq
	xu7wSxMnuGbsA70hLQHPOgWIXx3MFII=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YGjYA7GK;
	spf=pass (imf20.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7454B601DE
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 03:34:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 296C61F00919
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 03:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793849642;
	bh=l+Yp56smGIs8eBVmZ42TlX/QjRgKCo02jmsCVaG2LHM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=YGjYA7GK343Pjnrfl3nofa0xcvg8KD1pXJekSNdyyCiTvYVtawW3B5HsQyMsage1F
	 j4Drah6q6VlOF5mqA0cMvykdPH7q2jFJADU1qs4r/jM2c2wVcGsEaOhL6I1NT4r25v
	 yBzXn9kmVUfdGUZMMwIIIWh/2jJPZ7YlCRQ5touqvXt8CASPKZOkADXbUvuBi1p0Xm
	 kVwX0CvQCqnjUwipJd3dRGy/W2npv7BntvX/KM95lwaL0ZMg9D+7JUJbPrtfVAMLsg
	 sBfpQyW4hrdzahpG74ElKjd4UP4l9N09jpRCho70txcS/HaXse5J0hJg4G4jmDAnHS
	 rMVggHotSGVrg==
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-93e635220b4so132438485a.1
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 19:34:02 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBxB9Gt1MaXCpUeErmnQ1KTFT3e1KqYmNgdI6/4IJnUhOXHvXXW7lpJvZsr3BJk8CUeKzmDZycWgyg==@kvack.org
X-Gm-Message-State: APuU4Z+CackBrvtksHXZfzHbi5NkVxUqjxM/p/OaCD7tNy9en4XbpYy4
	fd7KquDboPUmGCtNJnZjvpk+Zw1whAtZ+kQlr22qkkuV8OhRKT2sswwyTbWVS0RTac3C3LtCg4k
	V/EtkglDccmY2sgonKz4CsUs4OS3WV3c=
X-Received: by 2002:a05:620a:3720:b0:93e:fc02:e8d4 with SMTP id
 af79cd13be357-94421630bedmr3380444185a.27.1793849641568; Wed, 04 Nov 2026
 19:34:01 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261104130817.849089-1-ridong.chen@linux.dev>
 <20261104130817.849089-8-ridong.chen@linux.dev> <CAGsJ_4y_Ay0mYO3ic72oepjtW6KYf2sKRXEHb3Ff8uwKrOJZjQ@mail.gmail.com>
 <4f830c30-f99c-4f75-851b-1a3f6d1342b1@linux.dev> <auvisj8NeTJ8FunG@MiWiFi-R3L-srv>
In-Reply-To: <auvisj8NeTJ8FunG@MiWiFi-R3L-srv>
From: Barry Song <baohua@kernel.org>
Date: Thu, 5 Nov 2026 11:33:50 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zVwLMRKOOGycVfnGEjxwy3wO8azyWD4YX6+d7DpAypzQ@mail.gmail.com>
X-Gm-Features: AclHuK95QOPSEjcqkBAiK0QpfFcwI57KNwsmNgJhbn3lT1vePCwCD9VdxFwjbS0
Message-ID: <CAGsJ_4zVwLMRKOOGycVfnGEjxwy3wO8azyWD4YX6+d7DpAypzQ@mail.gmail.com>
Subject: Re: [PATCH v7 7/7] mm/mglru: add tracepoint for aging
To: Baoquan He <baoquan.he@linux.dev>
Cc: Ridong Chen <ridong.chen@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Dave Chinner <david@fromorbit.com>, David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Lorenzo Stoakes <ljs@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Muchun Song <muchun.song@linux.dev>, Kairui Song <kasong@tencent.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, 
	"open list:BPF [MISC]:Keyword:(?:b|_)bpf(?:b|_)" <bpf@vger.kernel.org>, Ridong Chen <chenridong@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9ECFE1C0005
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 436mkcip4zzrqrm3y8p65t1db3whmrdu
X-Rspam-User: 
X-HE-Tag: 1793849643-365635
X-HE-Meta: U2FsdGVkX1+1gNR8vzkvelzc7O0pyrVBMuXqQS+MuAEwBvhz1o5CI45PPeE3QswLMgmlKm/PCaD6zM8JLkLo6PX3vnP/Xqz+Pb3JywHaM/yvsoz3cfAjvuMYkOhWk/bzS83LJ+KbLiNa3IUi5jYewqkDtHUxpenW8VkLP/WoFs2ekuGspIXDYhDeEunb8G3gq2HbaGVF5AeQCgIl4+a8RKxX8DJCOJS78vteB5kWs6eH88gmM024JycP9BnUJ+bhcNDmkDNEm95FdRdyiUh9S4F4kO+Ess5eU50k9M3lm1otRertuA4+CJgJFDkdsRInoKyzRmXLOMelF+ANuBzYxST+Gku1wQ5AOBLo+chDxQBru3o+vV1Auapr3IiEXC7VHy+vlX0BboUkk3NDKGqbIVs4TMdZ0cDGvHFgpmwv6OHPd25kNl5xdWOQqeD3CU5AFnPw6XEdhK8YPVkFeQOWiwGB7dPYWv0jhmI2sdcdkkvCmwsy3n1Ajs1KFXKDP78DC4KBX9E9PVJHNUmz2yJMlEkA1ny1AZQfo5rv6IH0VRmH4yWroIQDHDD/sIEQx+ZlWz4d8UrP/hyKUOaBn6R1k3Bfg5df2SSN0kX2/tQ0BpdZ2lQOk+VRR0FbzkQ3jhu72RteMlsk9RHnylGOo3NcvOXmI/tH1A8cayMkJfCkZpr7598gIt3y7qkZx/x7WnammbouYgRENMvniIRG4pDj4XW8u0XiPS6KaZZWdJSlpNFHVDOugbvC9SYHdEcaV3j9x3JP8b0AjHyRrbUgvNmdaPF3w9roqBJ2H5d69HUha08s1NhOK0Zy4447P+Y18+AydufHL7NzJJoD+QFUi2YfBgHgeXfs0OznabanT/pANJeOBYQpsA9EY12A5E94jmBg8gkKNcSC1gc2vGRByIwe7okDD1NaZCW9GRo5HPk9GRVA2sD0cHDxcVgUyXD+8w0IZWcPTi21rliyOKfpFfW
 oGVCO46P
 Eg7Jyc/Rdgt6d0uxL4d0QleXUYcv7rXa13vNXfLC7N9C64RGOx290mqpJefRG+kGhjJP4iKYO1dOE+kv3vblq3g3qrVMOHyXiRjzMjK5D0YxQymeBN77QXcHWUL45BpviUaXHpazSePw0bwKx3jP6a+FlRdvnVzrIYtvmR25ZbU/d+I91cf8UzTrSozcRSV3r2ManAfKpqSB+i+KBZ82vdlHK6aL+l83tn69pye8jOTs8tavnuxp9iYTbxB2EcyEB7X6PaR/FEVn8gBhEzriyJsJr7tn59pSi8ztrB8XW0ccn2KIHxBbcJvxRlQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 5, 2026 at 9:58=E2=80=AFAM Baoquan He <baoquan.he@linux.dev> wr=
ote:
[...]
> > >
> > > Reviewed-by: Barry Song <baohua@kernel.org>
> >
> > Hi, Barry,
> >
> > Thanks a lot for testing and the Reviewed-by.
> >
> > Updating it would be fine with me, but I'd slightly prefer the current
> > output, to keep it consistent with the debugfs lru_gen_full file. It
> > also prints a fixed window of MAX_NR_GENS generations from the oldest
> > to the newest, marking the ones below min_seq with 'x'. The event
> > reports anon_min_seq and file_min_seq in place of the 'x', so the
> > generations that don't exist can still be told apart, and they always
> > read 0. Keeping the same window and order makes it easy to compare the
> > event with debugfs, e.g. when looking at both while debugging.
> >
> > That said, if others such as Baolin, Baoquan or Kairui also prefer
> > printing only the existing generations from the youngest to the
> > oldest, I'm happy to send another version with that change.
>
> I like oldest -> youngest a little better because when I am thinking
> about MGLRU logic in my mind, I would put min_seq in the left, max_seq
> in the right, then wrap around from right to left.
>

OK. We have both left-handed and right-handed people
in the world. Somehow, I feel like a right-handed person
trying to write with my left hand when reading from
oldest to youngest. But I'm perfectly fine with that!

Thanks for sharing your thoughts, Ridong and Baoquan!

Best,
Barry

