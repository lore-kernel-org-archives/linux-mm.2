Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D69B1606A835
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 10:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TzS3ULsR
Received: by kanga.kvack.org (Postfix)
	id C8D366B05B1; Tue,  3 Nov 2026 05:00:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6BBF6B05B2; Tue,  3 Nov 2026 05:00:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7AD66B05B3; Tue,  3 Nov 2026 05:00:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 769116B05B1
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 05:00:29 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BE0FC80370
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:00:28 +0000 (UTC)
X-FDA: 85393362936.16.07EBEC5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id D2C0BA000B
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:00:26 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TzS3ULsR;
	spf=pass (imf25.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793700027;
	b=CL2xi3hOsvqnyYt9azPuMd45VRGFg6eU/l3taFGJ2qaTp6X+S6OmXvV5wWb4SYj5yc6/Ey
	o5Qvi8nAPssCPXwXuwvp/7qrvqTzSXGV49n4Dd6LwvjCUJ9LUzBTRFuGyT6u45wBmdz9IK
	xLiB//OU4QkBfcAg/bK8UhbrbU6LrdA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TzS3ULsR;
	spf=pass (imf25.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793700026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5eBsKnOAtib/53cPHq4YDPTfnBHbrb23tyc46Pd1NRs=;
	b=JyeIvavvuq3ztw8WgRm8yV9uNEzSM0zUE68ko0snWeMFXjqq4kURpq1w5cQHq0kRg882MD
	4eL0ne7yXNXWNE3mTkBLqY2R45C58ZUKWh0/F0pxcvLCoo5NRv2AAIgzIVDOqYoqtgIe/F
	0knRCqFRaY5cN0ow3NIgR8GyCxQcsj8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 10DA443FB5
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:00:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E67251F00919
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793700025;
	bh=5eBsKnOAtib/53cPHq4YDPTfnBHbrb23tyc46Pd1NRs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=TzS3ULsRDP7KRAvpEcQctlMxK5EBJUqg+rlJoPQweCYeEIkdQZ7IG8AiIU+wLmhmz
	 G+tw3tFYw502LHa8u3/ecpwHOgXIFpB8IUhapfzI65o0ygcfzGATDiScsCQEo64L5p
	 5CkTsOYvIMMcWi+0y1yuoc0sU/Lv3l4QNh+mSjUAlTbRTTxqv4aqL/fuFVegbIqeAp
	 uhpIx3v6l7vUrWaaVnNIk9gwKHr0x3wPxuVyXM1Um2lV7+hONQMi2W5u1ZPMRiorxf
	 U8U9kGiqubWAR8hvBNPL1HblQ2mBRsDcbXav55dGpY6fdiH5iz8s1OF/evPgHNrvBJ
	 8oRCobYajkUwA==
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-93cc1ab5f6cso477981285a.0
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 02:00:25 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBxqwVr0YA6/lo19Fss16j4tkhTxgFUKeYqTgWIUQQkOIa7+Z8erOTcrNMzPi5zHOGonyhyzFaVnCQ==@kvack.org
X-Gm-Message-State: APuU4Z8n53xAoll+RkoI94ssgksJKwNmSHOynKRkZn575JEn9qtMAiBJ
	ZW73Ft1cTXI1wgKtZQxPHdVaDdnHtlaCeOd/4oJKFm5Md6SbFP+G4CWM7DmJznYzwDnO9JzkwgN
	7qADdLrE03DKJE3kVYhBNUAOEdu3/vbA=
X-Received: by 2002:a05:620a:7303:10b0:945:b101:67c1 with SMTP id
 af79cd13be357-945b10169d1mr751687785a.24.1793700025088; Tue, 03 Nov 2026
 02:00:25 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261103025610.3738894-1-ridong.chen@linux.dev>
 <20261103025610.3738894-8-ridong.chen@linux.dev> <CAGsJ_4xCTSctcPcC7X6Dx4zYaOycaPqs0DG7AaxB55wx1Afwpg@mail.gmail.com>
 <9cabcddf-d807-4a36-84f1-5bb06ea72aac@linux.dev>
In-Reply-To: <9cabcddf-d807-4a36-84f1-5bb06ea72aac@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Tue, 3 Nov 2026 18:00:13 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xXDZjhN+NkvtN+vAp8Bokack_JdNgP=nGPQtHUX8_rqg@mail.gmail.com>
X-Gm-Features: AclHuK-l8OdgfBebeJ7I2lXBHNEFb91IlwAm3Z2gmv4eIjSIYhVp7xL_4GoZss8
Message-ID: <CAGsJ_4xXDZjhN+NkvtN+vAp8Bokack_JdNgP=nGPQtHUX8_rqg@mail.gmail.com>
Subject: Re: [PATCH v6 7/7] mm/mglru: add tracepoint for inc_max_seq()
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
	linux-mm@kvack.org, cgroups@vger.kernel.org, 
	"open list:BPF [MISC]:Keyword:(?:b|_)bpf(?:b|_)" <bpf@vger.kernel.org>, Ridong Chen <chenridong@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: g3bxbkrwiqd6eyzmr78y1uhebe4rmpr1
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D2C0BA000B
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793700026-835624
X-HE-Meta: U2FsdGVkX18qJaD+jtyAtO8nizTaPLbNWJIzRDzisPDpcUSXMdv2Hpk2+Jg3yJTw0OZXdG0I94tSMp+cAJJEnSXcF6FY+VVNDT7bhKM+vvatdomAMKSqz8L/SQXA4zN9CEv659YpBd/2YLK+UEJOKlO245O+Rm5djeFMRU2cHv9Kzv5OZ90Hfd9geyOgQWPc4sE8vnqk/QAIBmR9oxkthXijvYGSGtZOYOMStm8xcofrgSF/TVqcW8eGI9AGBIorQIT28gr7/PCkpYRP8pMouwNaIuSqiycLHjAJolS8jTmgZutrIwaxSqnW/aybzlsw8Z+8q94AFnwaU4FYMOs68+muJxa1eOw7m5NRTD99PwlGcDEfygG1ixkzD93H6CcNv8jBqflYjNoy33WIeWcQxdzFG+9OTKpq2u3v3G1vyl7s/JbdFqvQa3+KqCRRNu1q5xvKhPxI6o6nux+Xlz+f58/Z7sRxxTuA/zIKARbUBHuJ552j7ZRxkbg8G9meb11tn4PPvn+J+GJw6CcW9AZ4DKMcEdHhZOSGb05aH78QbPrtfTtkkf0e9jO5M0PhveN2rUIyQKvEGzvjs22WdfssHBI76Ux/3QH4CJVPLHnETW25A6pQewoFerjcoYj4Of1GrnQ7kkgchp1jE2dD/LjDKnnr7Ra9CFzrKXTbWMnM8jsnWx4VsFfPrx5SPHJEopux5I6dOI8GdRJNGFcpiKbU0MeilDSlPpnNJq3qv4SEFBoZjk7qscF7Rx1GJ9qZJ/yfNDKikfKX5ivMI7awy+TcaPFU2xKivRwQ+zhCF40CvG/w4CbTxOngykl+jqb81Galg1wlTHB8BjhTYg8rS3NsHHnIKOCRsxjEZ3wZIw0ClgSDRgB8QFqSemJp7J+gK2ERQGmLFHTQQpWRYasXcb+TCTYrP8SNpboIkFfL+cRC25NxovV6qqLwxLKyLEWMstQYo22aPaJ8GTwAvdA42m8
 7Bq3DWb1
 4gh2q6/f6I/6iv9jBTLx/5HUVa/DvLoLuk/Okkvbz8M/ccPyf9bGSj5Kjzu6MraJT9VUCl0yaYftO+MKdA4FhsOYoMdMUucAIUFXxNi8YLXwxkf6d01sCt+wivVfpkIx2Z0GYXfAt9IbXeuK8du+BlEsvfcxVO8d2U7Vv1/0YYr1Wvxqvtxl0osjUvekAxv+bnPU7IsP3bmyQKZrZNyNim3gJ/c3dcFcWoSvw67A76Cbo4YwqXpWf/GVcpQykNDxFgWjOrd+th4E31RGu3AmIOqwJugvk259GI6ZHIECR261CDl0+ojYgMDpLivDQD1ApkFBqRSrsAKhIbqcqrB+FcRPE4bzZVScF+gWf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 3, 2026 at 4:39=E2=80=AFPM Ridong Chen <ridong.chen@linux.dev> =
wrote:
>
>
>
> On 11/3/2026 2:48 PM, Barry Song wrote:
> > On Tue, Nov 3, 2026 at 10:58=E2=80=AFAM Ridong Chen <ridong.chen@linux.=
dev> wrote:
> >>
> >> From: Ridong Chen <chenridong@xiaomi.com>
> >>
> >> Aging in MGLRU advances max_seq via inc_max_seq(), creating a new
> >> youngest generation. There is currently no tracepoint on this path, so
> >> the moment a new generation is created, and how the min_seq of each ty=
pe
> >> trails behind it, cannot be observed as it happens.
> >
> > We might be more interested in why aging is triggered rather
> > than the exact moment when max_seq is advanced.
> >
> > With your patch, we get:
> >
> > ~ # cat /sys/kernel/tracing/trace | grep mglru_inc_max_seq
> >             a.out-93      [001] d..1.   278.276539:
> > mm_mglru_inc_max_seq: nid=3D0 memcg_id=3D1 max_seq=3D4 anon_min_seq=3D2
> > file_min_seq=3D1 nr_anon=3D{0x0,0xf016,0x12,0x0}
> > nr_file=3D{0x1886,0xb,0x4c,0x0}
> >           kswapd0-50      [000] d..1.   278.422400:
> > mm_mglru_inc_max_seq: nid=3D0 memcg_id=3D1 max_seq=3D5 anon_min_seq=3D2
> > file_min_seq=3D2 nr_anon=3D{0x5,0xccb6,0x3439,0x0}
> > nr_file=3D{0x4ae,0x4f,0x55,0x0}
> >           kswapd0-50      [000] d..1.   278.508003:
> > mm_mglru_inc_max_seq: nid=3D0 memcg_id=3D1 max_seq=3D6 anon_min_seq=3D3
> > file_min_seq=3D4 nr_anon=3D{0xccb6,0x3d29,0x1,0x0}
> > nr_file=3D{0x0,0x59,0x7,0x0}
> >           kswapd0-50      [000] d..1.   280.046056:
> > mm_mglru_inc_max_seq: nid=3D0 memcg_id=3D1 max_seq=3D7 anon_min_seq=3D4
> > file_min_seq=3D5 nr_anon=3D{0x3bf3,0xcbbd,0x23e,0x0}
> > nr_file=3D{0x0,0xb,0x1,0x0}
> >           kswapd0-50      [000] d..1.   280.124876:
> > mm_mglru_inc_max_seq: nid=3D0 memcg_id=3D1 max_seq=3D8 anon_min_seq=3D5
> > file_min_seq=3D6 nr_anon=3D{0xcafd,0x3e31,0x0,0x0}
> > nr_file=3D{0x0,0x5,0x7,0x0}
> >             a.out-96      [001] d..1.   290.629014:
> > mm_mglru_inc_max_seq: nid=3D0 memcg_id=3D1 max_seq=3D9 anon_min_seq=3D7
> > file_min_seq=3D6 nr_anon=3D{0x0,0x10615,0xb,0x0}
> > nr_file=3D{0x331,0xb,0x9a,0x0}
> >           kswapd0-50      [000] d..1.   290.653098:
> > mm_mglru_inc_max_seq: nid=3D0 memcg_id=3D1 max_seq=3D10 anon_min_seq=3D=
7
> > file_min_seq=3D7 nr_anon=3D{0x15,0xef23,0x18c4,0x0}
> > nr_file=3D{0xb,0xb8,0x55,0x0}
> >             a.out-96      [001] d..1.   290.684875:
> > mm_mglru_inc_max_seq: nid=3D0 memcg_id=3D1 max_seq=3D11 anon_min_seq=3D=
8
> > file_min_seq=3D9 nr_anon=3D{0xeee3,0x1afb,0x2,0x0}
> > nr_file=3D{0x0,0x76,0x4,0x0}
> >
> > You can see that the youngest generation is always zero,
> > because you're just getting the newly added youngest
> > generation :-)
> >
>
> Hi Barry,
>
> Thank you very much for testing and reviewing.
>
> > This somehow suggests that the information is redundant, as
> > there is always a zero there.
> >
> > I suspect we'll need an additional tracepoint to show why
> > aging is triggered and at what sc->priority it happens.
> >
> > But do you know why you trace the moment just after aging
> > is completed, rather than the reason why aging is needed?
> >
> My original goal was to pair it with mm_mglru_scan_folios, to see how
> the aging window of each memcg moves. The per-generation anon/file
> nr_pages were added following your suggestion on v1. I put it at the
> end of inc_max_seq() because of the restart there, as max_seq and
> min_seq are only final after that.

The per-generation anon/file nr_pages are perfectly good, as
they can also help explain why aging is needed, especially
now that we're introducing new code for imbalance-based
aging.

>
> You make a very good point that the reason for aging is also
> important. So I'd like to discuss which way is better:
>
> 1) Keep mm_mglru_inc_max_seq, and add another tracepoint at the aging
>   decision in try_to_shrink_lruvec(), reporting why aging is needed
>   and at what sc->priority.
>
> 2) Replace mm_mglru_inc_max_seq with a single tracepoint in
>   try_to_shrink_lruvec(), right before try_to_inc_max_seq(), reporting
>   the reason, sc->priority, swappiness, max_seq/min_seq and the
>   per-generation nr_pages before aging. The youngest generation is
>   not empty at that point, and the new window after aging can still
>   be seen from the following mm_mglru_scan_folios.
>
> Which one do you prefer?

Maybe we should keep option 2 for now. Understanding why
we are aging and at what priority is much more important,
especially since we're still introducing some
imbalance-based aging code.

It should be quite simple, just a matter of moving the code
around a little.

If we later find a good reason to have option 1, we can
always add it, right?

Best,
Barry

