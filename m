Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66403CA601E
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 00:21:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAB6D6B008A; Fri,  9 Oct 2026 20:21:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6A336B008C; Fri,  9 Oct 2026 20:21:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B33776B0095; Fri,  9 Oct 2026 20:21:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7D2FA6B008A
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 20:21:13 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F31921A05D9
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 00:21:12 +0000 (UTC)
X-FDA: 85304811984.05.554510B
Received: from mail-dy2-f7.google.com (mail-dy2-f7.google.com [74.125.229.7])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1A6FE120004
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 00:21:10 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="m/IbVI9E";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf29.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.229.7 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791591671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aLhgNbsx0+wXZ0nMHKkwbYkJUXpFXWO/o3bDIihSveI=;
	b=MWHjlS0PHVdw/drTH2Ar3FWFfY+BeW4d7WLj6ygLac/CBt7VcYJwzJwSzGz09ri18JxdqK
	GxLcej8IqOfuH6Fu1tyRB8ejduEkkpm5U1N3mj+n6VkX4BwzmdWQZyqVnG+ZhMekpX9INt
	g3SZSQ1+TSL0Rst5aiAiKIHBcHaLWZM=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="m/IbVI9E";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf29.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.229.7 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791591671;
	b=nPmBIwQ9sl086yFc84BWD2Sb3kgeGNxK2iUSsvOH/nnT6ZAMrpp7+2JNURFFprT4lAqPxe
	fUKuhGC+J+AaqrCD0pkyjMIY5JEWmU7yhpsXe1nHjgLiQGq5LWGmGmdpNOFhPFLlG1koxz
	Rc4ka3ldE3eK7uw2RydH7qkRaPoojOg=
Received: by mail-dy2-f7.google.com with SMTP id 5a478bee46e88-33e5ae86ff2so68623eec.0
        for <linux-mm@kvack.org>; Fri, 09 Oct 2026 17:21:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791591670; cv=none;
        d=google.com; s=arc-20260327;
        b=UET5fgi5DdZAjaBfEP2XnAeK/jtvh63DiGw34QLV/FQUZs40IrKYiCXdotGh8PmI1D
         iVv4+5bCA/LRL7Mcq/iOoyUG4f3HqBVc8I/z3hLnHwHWSA3CkjCm5+dCBNhcaiv2Ikb+
         LoEsN9f2JzvHGitkWNSXuf5D4uBvgaVFL3tlsHw8091gYz0ZQYK2jt8xN/cqceLyHpJd
         b20BBa+YLCOdM45CYjZXTPU0HIymzaJQmkEbXscLasReCB4eUe7SohszRjxvSTt52pfS
         WncI8xo06WpQp9nDj4H0EB3GSv2PPT/xOpLnD1+oGFhCMGG53mqrYOYDrirJ0nRrhNIw
         P/HQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=aLhgNbsx0+wXZ0nMHKkwbYkJUXpFXWO/o3bDIihSveI=;
        fh=Kwo9YVjfx2Bb0G0YzzKoNoz+qF59JLOvoJc7bSygjBU=;
        b=lYNncAalTvozXKbyFP0Byvo4C5T0I2I669q6W9N+TKxSyxDAk1Q9qhVFWs6r/PdJnm
         fGKr7bijQiF+WFCpJxlFZ9lzQuxkaRt7CyLVz7q6sXC1ioIZCz3QuSPZtOUaxs7e0o0r
         rJktYmdGyoSWXB7ybYwHbPfMvWBdwQ5jQJERpskgAIzBJniyl8ptn7R9dJQZ1dfmwQlx
         qjKoFj+3cJ9NShtrNP/ygkgMEYQ3n8wFSVv3TPVXIajSAmsJErC9f9qsCxpuabM/V6ZY
         ll8i3bNjUYBjG3CNrCvknKfmPeuTL8dRavHxb6ly2bjkLF43OysOe77bRBJKD2COICrF
         qttw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791591670; x=1792196470; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=aLhgNbsx0+wXZ0nMHKkwbYkJUXpFXWO/o3bDIihSveI=;
        b=m/IbVI9EHBBY8sVYuIT14cZx1Spx6ukF9bTDQ42/j1+zLphvdMcmkqhOaDJPg0MGXH
         8Eg6vq1iBLjMQO1avPRhLde0LJ6jSwmA1X6aBJUEx/qvKBC0QbxxzdZnASUj4iTcV8/2
         CXHoL8kOejiy4/o1O2ygKlVPriRd0DWIT0PghU9quDIooQ9OTlMTvTNRTqAaDZ1JQ9nx
         XFoqBhZ0Gqb477rsJmkQWi4k86XyOBij5tstL/wxqvUObXdtFmQvOnFrZ2yiobN2TuSc
         SM6O+maOG+YsIQnblj3BnE4sGkdY3ZrfupeYh6Z0TStT9+KgTFh6d22DzvBv73SuLdGP
         F6JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791591670; x=1792196470;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aLhgNbsx0+wXZ0nMHKkwbYkJUXpFXWO/o3bDIihSveI=;
        b=PX79nOBa0zk60y1D+GmI1f4ZofOFtHRA9tIhRlWTN7OGzIX9TJkFkVxQNDvZiUBrDn
         YRTp4SPddNpymJA0fg2SxAFkkqrRPyRJxKKJ3aMNrhcQRCjFFte5M5hlf6ciaraCMNm+
         NS1C2sdTMSAg76oHs55Ffip/7y7yWrHOdCJ47qKWxeFFmrAH7M/gpAdTIBmZZ2L6BqxZ
         8VsiUgqamDFqK6I8SovsKKOx03cNQByYaZ6bxPkd6Ywhk0B4I2q6dkzHYjAYB0RBkT93
         MU3sIBxm24ydDCKfzghMi5uU+rVHaZ/jrwU8YaOxazbmuzVB/Ax6HeS5x1dd40xHgGVp
         ZfmQ==
X-Forwarded-Encrypted: i=1; AKwUvBzwYhgBQo/cmA4Al4z8gHS97WbnD7I6dN1dYADJSKakSrS/XCh2wQQXLK1TszyS67gy5rCSb0upnw==@kvack.org
X-Gm-Message-State: AFq9FYL9b/jKs7ok3qToHZZZat1I+5sZ2/ES7MQMeDxukh37N+x3lP4f
	ZwOQ/y0fRIrJToTLjmvGAoWpxhbAE275zqIv4ChwAwDfnB7t2iUlt2Z40bW8Fdy7lWWw4XYhvK2
	q32aqRZnVIaIFfjOSqt2fciSnK1zyqw==
X-Gm-Gg: AYBFou03JjwOqOwpikCgtWQxQRyC5YCU6SH6SmuA2Egl7FOAwYPShpP61Et8pLjqttr
	m+3+EiNZ4xvovQ5SUeG29X4ms7bW1JTiepoFr/a3wM1xXUvy7ZXgENSGobaXeaj8gjbkHa68aMg
	MLoEmiqYrWp6lJmC1eZgOX+2hobtVjThQJFrtLuUNq1gpXiupZFiaM77d125vZuBomZSCXeDDnY
	BW8lV+26lFoX0GHCTWGUv1FfTK3wLAnRD4NF4mtcAHre8LLB6qNZ3XkYDp/6RkIOrsidiPm6/pQ
	RcNKuyZBoz3dVq25hEANvoDwV6zd6UDLFSAsWuxfXKGmwAd9q4yKRTmlCj4WyzWV098=
X-Received: by 2002:a05:7022:1584:b0:143:4d12:396d with SMTP id
 a92af1059eb24-16a61a6def5mr6220928c88.26.1791591669725; Fri, 09 Oct 2026
 17:21:09 -0700 (PDT)
MIME-Version: 1.0
References: <20261003202727.3673-1-ravis.opensrc@gmail.com> <20261004051632.71726836@fedora>
In-Reply-To: <20261004051632.71726836@fedora>
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Date: Fri, 9 Oct 2026 17:20:58 -0700
X-Gm-Features: AclHuK9WQbXCtUH8jjgwOQuphF_nuOqJSSeO2P2D0u1Fn7EltapGuD6HQRfN-gs
Message-ID: <CALa+Y14+pGN+ZA90gALy30mvrmkTp21AVFrjfzP1AtYEo-uVPw@mail.gmail.com>
Subject: Re: [PATCH] mm/damon: add damos_node_eligible_mem_bp tracepoint
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, SJ Park <sj@kernel.org>, damon@lists.linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Bijan Tabatabai <bijan311@gmail.com>, Ajay Joshi <ajayjoshi@micron.com>, 
	Honggyu Kim <honggyu.kim@sk.com>, Yunjeong Mun <yunjeong.mun@sk.com>, 
	Akinobu Mita <akinobu.mita@gmail.com>, Lian Wang <lianux.mm@gmail.com>, 
	Kunwu Chan <kunwu.chan@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1A6FE120004
X-Stat-Signature: yge5hbdsx83e5yhgnypg9jkuctnsk17g
X-HE-Tag: 1791591670-43682
X-HE-Meta: U2FsdGVkX1/H7s9Bc8ai5x9AGSr93PNVAk2XUwDv1oKAAO5OLooDRueWmaIyfAe8uYrfbs1pk264qMimkoIDRepGGLe6vGLijhay0csEZSo4JFf8jyxmUZoTXdqEnnQY0Ovg9MdpFgHx96cq86FVrAraWsXCxvqXpGqHoOzWf7A85N+n7G0zveXx9LEke9dFsKAhH8SsZZoZXYc/gFmskBvvrkGxXND6w36tmOx4TPHcPX0pczivnAGh9mvNRMXzfBCWYBFxkXDbvWQ7hMxL/5/6BHKVvb6Yf4+u80W7WSTYKeh8auch9flptmlJD4goCaLXxxWcxa6xivUZAZplhxVi6hmjhJe1D+9IlGuuZ2QavumvzMiBoPx7iHL1SXppiHyAuq5WJfNAppvZLZYvjhITyA0EFx/y6AcxmusmTypRodZp+pd+cZPFcMg2kq4ZHXhhctaYactposzpoKKMmqiq8JjAPfeISpI5ayzhRpFd5huGbxqLR9k594QKbnUBrpcG/VtMRJiuQV84qmB/+0BR689v/Do/zWunXyOkUC39EYMYch5mhmyINAuSAwBAT2Gtj1JR1+hd27z/SVuUbBnNHWD57rjJdXLfA8luVmDvrmDXbYQUL5s1PGQgx0jdLAE3LfNR1dbERVUyJ8eZ2TkkJbD3hhkYvLCHAnSJF1Mj5XlEn0ODR8N3iguF55LVMY5nOKDpLOtPKcy7ApWOarJpG/2ln/RhjCKAZndtwIxrrgcW5Mpkp3/Rw4TlEJCA0FC68hpSDSljXSWAiHXWiGPdtyvEZV2nWJYdjfYbb/8r/mpZKZyLmyBXVRMf7xvv+WNX2V20ubUckTGXBIMHYPaGV0mEFkMKcTP7CcRTeaHQ6Big6W66ba6mtidwRzGDTW1OaZ8xr9vvUgUvzAVPFqEwWksvv/qyT59H/FQcNBSH+7apx8fpqk/Z17F8Bwv9sqng4xpjt02uAg7hHNT
 2A9kaTFc
 lVcogIg0vDcTbZMCxtXnQEkWym8DhD+yLIEY0szx0WOLZrf3IuniAI3u9D6jZeo6534Ka5C5Ec1KKrQZHzZLyUOsylU9mT/R4kPBkKBP9FYVn+flLPvJAqmc5+2lVJuAqa7a5vMA4yr/k3WhwhJ7F3Rbsy/F1Qi2Bh/MLp44w/bWJPT1zWI2hahlFEU3n8ptbxWRqFdO9+VCY24xdAPOVLyZ7j1+us0Wduy7lnKy4TsVLQX6W6R9j8wXoRfbtYeWNI4M7SxP7dvVTp6hyFYg+AghbesPDLRIX/Qtq7IIly8Z33GG5oKDwtEp/5PBjUZdpU9HDrLrVo/LNLQu72mVS3irSRCwTZRpUldm9+4I7qdz6F0b6Zz9SZ3GGYIFSo/DLPbHNPd2zZEiBcdGHn+4ADUJkahki3ZdkQf3iuSVCnP1z6SP29L7oCLZ2h/FY7E78fWTIRTmidA/uUHWp94U+zLOKGdr2xBZTrZB2ix7TgPvFIY3WLOzKPlIxUF3rWQAngSjaI5vpeQg9m+Tes89HOTTImlDZnP5wPLgZrOi8Cvmnn84fDAA5xcVONA0xE8zK4zJPESDHsGqdusu03cZU9verwpxdZL0bZDC+dY84FGphq7lMDXP/vGLP1A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Oct 4, 2026 at 2:16=E2=80=AFAM Steven Rostedt <rostedt@goodmis.org>=
 wrote:
>
> On Sat,  3 Oct 2026 13:27:27 -0700
> Ravi Jonnalagadda <ravis.opensrc@gmail.com> wrote:
>
> > Add a tracepoint for DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP quota goal
> > evaluation.  The tracepoint fires once per quota-score computation when
> > the goal metric is DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP, exposing
> > context_idx, scheme_idx, nid, target_value, and current_value.
> > current_value is reported as the quota tuning sees it, after the goal's
> > complement setting is applied.
> >
> > The DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP metric expresses node memory
> > occupancy as basis points of eligible bytes.  This information is not
> > exposed through any existing external interface (perf stat, /proc, or
> > sysfs), so the tracepoint is the only way for userspace to observe the
> > target and current eligible-memory basis point values at quota-scoring
> > time.
> >
> > Link: https://lore.kernel.org/linux-mm/20260428030520.701-1-ravis.opens=
rc@gmail.com/
> > Signed-off-by: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
> > ---
> >  include/trace/events/damon.h | 31 +++++++++++++++++++++++++++++++
> >  mm/damon/core.c              | 16 ++++++++++++++++
> >  2 files changed, 47 insertions(+)
> >
> > diff --git a/include/trace/events/damon.h b/include/trace/events/damon.=
h
> > index 8851727ae162..2c7249cc7c88 100644
> > --- a/include/trace/events/damon.h
> > +++ b/include/trace/events/damon.h
> > @@ -74,6 +74,37 @@ TRACE_EVENT(damos_esz,
> >                       __entry->esz)
> >  );
> >
> > +/* Per-tick DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP goal evaluation. */
> > +TRACE_EVENT(damos_node_eligible_mem_bp,
> > +
> > +     TP_PROTO(unsigned int context_idx, unsigned int scheme_idx,
> > +             int nid,
> > +             unsigned long target_value, unsigned long current_value),
> > +
> > +     TP_ARGS(context_idx, scheme_idx, nid, target_value, current_value=
),
> > +
> > +     TP_STRUCT__entry(
> > +             __field(unsigned int, context_idx)
> > +             __field(unsigned int, scheme_idx)
> > +             __field(int, nid)
>
> Can you move the nid after the two unsigned long values below. This
> creates a structure, and on 64bit machines, this adds a 4 byte padding
> in the middle of the ring buffer.

Hi Steve,

Thank you.  Will do; in the next version the 8-byte fields come first
and nid follows them.

>
> > +             __field(unsigned long, target_value)
> > +             __field(unsigned long, current_value)
> > +     ),
> > +
> > +     TP_fast_assign(
> > +             __entry->context_idx =3D context_idx;
> > +             __entry->scheme_idx =3D scheme_idx;
> > +             __entry->nid =3D nid;
> > +             __entry->target_value =3D target_value;
> > +             __entry->current_value =3D current_value;
> > +     ),
> > +
> > +     TP_printk("ctx_idx=3D%u scheme_idx=3D%u nid=3D%d target_value=3D%=
lu current_value=3D%lu",
> > +                     __entry->context_idx, __entry->scheme_idx,
> > +                     __entry->nid,
> > +                     __entry->target_value, __entry->current_value)
> > +);
> > +
> >  TRACE_EVENT_CONDITION(damos_before_apply,
> >
> >       TP_PROTO(unsigned int context_idx, unsigned int scheme_idx,
> > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > index b63e60ef8990..6ddd15dc4f55 100644
> > --- a/mm/damon/core.c
> > +++ b/mm/damon/core.c
> > @@ -3294,6 +3294,22 @@ static unsigned long damos_quota_score(struct da=
mon_ctx *c, struct damos *s)
> >               highest_score =3D max(highest_score,
> >                               mult_frac(goal->current_value, 10000,
> >                                       goal->target_value));
> > +
> > +             if (goal->metric =3D=3D DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP =
&&
> > +                 trace_damos_node_eligible_mem_bp_enabled()) {
>
> If you move the trace_damos_node_eligible_mem_bp_enabled() before the
> goal->metric check, you will save yourself a branch when tracing is
> off. As the trace_*_enabled() is a static branch (nop or jmp) it has no
> cmp branch, but the above will keep the goal->metric still exposed. By
> swapping the two compares, the goal->metric check will be hidder behind
> the 'nop' when tracing is disabled.
>
> -- Steve

Makes sense; I will put the trace_*_enabled() check first.  SJ asked for
the event to cover every quota goal rather than this metric only, so
the next version may not need the metric check at all, but the enabled
check will lead either way.

Thanks,
Ravi

>
>
> > +                     unsigned int cidx =3D 0, sidx =3D 0;
> > +                     struct damos *siter;
> > +
> > +                     damon_for_each_scheme(siter, c) {
> > +                             if (siter =3D=3D s)
> > +                                     break;
> > +                             sidx++;
> > +                     }
> > +                     trace_damos_node_eligible_mem_bp(cidx, sidx,
> > +                                     goal->nid,
> > +                                     goal->target_value,
> > +                                     goal->current_value);
> > +             }
> >       }
> >
> >       return highest_score;
> >
> > base-commit: 763ad0211c7b587344f03bc4d1299810aeb736f4
>

