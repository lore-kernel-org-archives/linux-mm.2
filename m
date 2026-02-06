Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4227CEE6B4D
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 20:09:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BC886B0089; Fri,  6 Feb 2026 15:09:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66AC06B0092; Fri,  6 Feb 2026 15:09:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54BA36B0093; Fri,  6 Feb 2026 15:09:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 44E576B0089
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 15:09:38 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E46A88B2D4
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 20:09:37 +0000 (UTC)
X-FDA: 84415121994.05.676BD9D
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	by imf26.hostedemail.com (Postfix) with ESMTP id CF96514000C
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 20:09:35 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=e40wVuHx;
	spf=pass (imf26.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770408575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KNkzI7/n94xGAZIGiTH3Axn/jOrvmAt6C/cefa5sLOQ=;
	b=iHt82Bbhi2q9tvjVPOYIvMSZmVNodG4sbPt+M48COjXYASabP/pjI6nJX1enQuUyEuWWyq
	MAVqC+9awJ4S40wRRwCHo0GlF1jYu0yYqMrVPtltwhzbpjrVLX/LVx6102allUkXZ9GvFW
	qf+N2i/YQE6/bWXHwlkLU21npSpSpVQ=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=e40wVuHx;
	spf=pass (imf26.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770408575; a=rsa-sha256;
	cv=pass;
	b=cvF2GqAmT2AjNwK4o7w5r/67jcmlmATibQqbtjsxgo9yoKKO/QENhXOkG7IFBnGH0uApAJ
	GrPw84EcrQyO1V1qKvH+uaQfu8mTDybLA8+VzYv63OjcE9PAHheznKfm+3gAZb+9eG9QfF
	ip39saqrMJOhsdeOSKYFrjETOxc6ti4=
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-436234ef0f0so1362615f8f.1
        for <linux-mm@kvack.org>; Fri, 06 Feb 2026 12:09:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770408574; cv=none;
        d=google.com; s=arc-20240605;
        b=I/6uO5Ni5P/Ch30xLVyHeCGYqMG6WAuIYd/HReuCeksfZCdj6wpYDfljQyjaxuhg8H
         Nn8wWZSDmlponDnbq9GW+HnF4WmxoL6PcpN4hluXUgXMkZHLLTVxDbewn78kb7RFsGHl
         7GCKRxew1sadc3wpvLhKd9gFnjU7a+gNSjpZVweE2jtJAwcQHivb28hN6IJI9SBQAvoN
         cjO7HPsOIF74kxBEZqudOWODsiYpY4rcWRclf7twihx4tX4yrhTEGg1Aixm/TofVvQLh
         TmKfBqEIjd9rYsSGEWql+7Zff3gFvVDbhH2VcjVR51leNorD/hc5wAKFuqyv+FBgFSSk
         E40g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=KNkzI7/n94xGAZIGiTH3Axn/jOrvmAt6C/cefa5sLOQ=;
        fh=BpifxnHVTTWqZVbh+zL3wF43+y+XFjQhIoWCXZ8h0vM=;
        b=DD0d/LLeh7wr5rHbAnKIBEuyaL2PY8b1z9vfIzVxQbLP7YwYrqCJRU1Z8F2XbZUqlC
         k670nRs/hzt55RD7dVsPXDTVlOKpogSIMT7uQ9cZDzi9mWA/DhBtaqoDuZBgw5fNB0dV
         IZ8JSxUdDG6CPUwOqRyy2hGmUGM2LIovboPVgcwB3tkYDkd/jTGagPOmb+NuqXocYEsf
         duFq05CDggsb+ySa3ynnfPlP9b2djM+KpMgxk9bEXRySYow2tYO8kBpQ+KM099q7XYyV
         glUuRWWdYHyCZJWbhDsuCm9Z3hcPavx2LrSSVWOk5A66ffTVbpHIxoqjgFztD5sIB1x/
         A6jg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770408574; x=1771013374; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KNkzI7/n94xGAZIGiTH3Axn/jOrvmAt6C/cefa5sLOQ=;
        b=e40wVuHxB89suHzTb2GLGXQlfI45B1Ro1YfbmpQ73s86PVo0+kcXZgsPnLXnD78x13
         aZwfrvX3q2pG4muM7zRCjKhNh7A874jtX8KG/rGh4CS4iTkfBK4ENLbFgovIbXSTLOC4
         BII4IaL3pP39GB6aoeotH9FDUlFwTeCkeRp6dS+6uHd08F0gjLWAH/RpVLxcaBNMYXPO
         AZvl+ziCR1eDDyuU6ld1N7CfL9eHbeU6nHLYwwOOhHw2HHeqR9eSQRi0IPlhMqOKHLWw
         aBYaKBzjuQlvYtELDAbhSW+dYTPhKXNoZBsi4ruKY9BPoA92EDMt8p3pZfqa/oXJbl6/
         bZng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770408574; x=1771013374;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KNkzI7/n94xGAZIGiTH3Axn/jOrvmAt6C/cefa5sLOQ=;
        b=vYAtsWcRP2sT/u7+W34mwyYLlXygDthyWaS0xL2H23mN97PNFxnasBd7tbG/r+t/Sl
         b9Thyb+l0VPuwqtKLw/O9dKXWTAwU66iswIf25o0EveQtwydjgF131rosx5fCwFH9tt+
         Ez4Bzz/XBG72tg2FR4EQDaeIroFDrWdeysLqoZHf0A1zfaYvj9kzzzXNFC8WRbOcBSjx
         t/XeUQPG0lbnij3roYdd6wvmMCr3ypLaxVbG6wTF/tqLB5+mtmstPlYETPAE1dHRfFEh
         sJ752KbVKgOQdw6JtX6syT/Ht6mTOy2WWKnaOvi2liRu4rcdyjIlgscd74aqjIOWGSLJ
         5+yA==
X-Forwarded-Encrypted: i=1; AJvYcCVViQNxavX7FI6lktyhofY57lj7AhYrozz0FcZ8L1AmrlawKRw5TbZ3JvPuWuhc94Fn+ZAkIoNqeA==@kvack.org
X-Gm-Message-State: AOJu0Yy6RvKruWk0XwPoOvh7p6m1m7GAq9fHP+T4VhFrxe6/F2v0kyDn
	sFJkFW0AWe0zuU+9ZPJ6Vw8d68Caweay65tRp6FkGIwvHiXInnDcyn8FjeGgT+buoNlVgncrjoH
	x+wAU37QO2U+GFHfmw25R+IjgbhMJUoE=
X-Gm-Gg: AZuq6aKaqYS9I9AlYEpzaBclYb4jIPsGcd02Pmx8hAwdlI4DqOxJtKYixp2v0Ylgx1M
	rltS+KHFgXOIxmrX9EP6Tw1VFcFtNereAKeQSHvy/mub4hKKzZ4MCjAFiH9bDuvFvYTWINmLLJR
	/b5+3pMzqq3Vl7ZpDu1c0h1SImHqyJPY3OnwV4FEbD+GQSQ6AQc83Y3pnYY4ngW1Q1qsacv88mO
	/ILWu6JiQAvtLwbcG0arZ1G6mklto82rSZtDu60LEbN1FdFxvC0X04Pv3hGVWoEOY5i5U6yKa65
	CVPI8O+xqJxHuLqY80sJu3j74UrvfB+k+jhO1Zx9TlvaGzByvPjcDzf0uriRhzygzB9fLwXQB57
	qef4S8bok/VZRqQ==
X-Received: by 2002:a5d:5887:0:b0:436:184b:4148 with SMTP id
 ffacd0b85a97d-4362965207dmr5961241f8f.3.1770408574080; Fri, 06 Feb 2026
 12:09:34 -0800 (PST)
MIME-Version: 1.0
References: <20260206093410.160622-1-harry.yoo@oracle.com> <20260206093410.160622-5-harry.yoo@oracle.com>
In-Reply-To: <20260206093410.160622-5-harry.yoo@oracle.com>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Fri, 6 Feb 2026 12:09:22 -0800
X-Gm-Features: AZwV_QhYNWBSDD-nTmAfJUx6ToEdVRJ7ZfLrAjTMeLBCvJJlvn_ysojVswF6Q_k
Message-ID: <CAADnVQ+rNYeb5Pu2aHRVc+hYDeAF5t19MVwzXsyn2HkOuLPNLg@mail.gmail.com>
Subject: Re: [RFC PATCH 4/7] mm/slab: free a bit in enum objexts_flags
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Michal Hocko <mhocko@kernel.org>, Hao Li <hao.li@linux.dev>, 
	Alexei Starovoitov <ast@kernel.org>, Puranjay Mohan <puranjay@kernel.org>, 
	Andrii Nakryiko <andrii@kernel.org>, Amery Hung <ameryhung@gmail.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, "Paul E . McKenney" <paulmck@kernel.org>, 
	Frederic Weisbecker <frederic@kernel.org>, Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
	Joel Fernandes <joelagnelf@nvidia.com>, Josh Triplett <josh@joshtriplett.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Uladzislau Rezki <urezki@gmail.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>, 
	Dave Chinner <david@fromorbit.com>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Muchun Song <muchun.song@linux.dev>, rcu@vger.kernel.org, linux-mm <linux-mm@kvack.org>, 
	bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: CF96514000C
X-Stat-Signature: zjntciafy4z4q5phz9mmnyk8jpx4weu7
X-Rspam-User: 
X-HE-Tag: 1770408575-65293
X-HE-Meta: U2FsdGVkX18FdajKfzS5d1oDv8ObQVbUQSHk+zwnonRt6SJMcaydGZwcT/YV1BUF42/KrnkD4L1fVbyniv3KZtqRmnD89/rgs/Ep46GgUEVI0GCsVsZljWKlw9Y0LbPQDXZlgeFYOfJq31AlnRu7jRrE8LEpN4hkDX9kXGEZLa9XvYOEilpKnlo6l5M/dWO1A8C64tzZpANPAI+VW/jFQ59u0KlU+TQ52cEvsc/CmbEkvE2uxQ9tqZKunVdHlTL8R4PgoMfDZwRxIRQrcAuMkznlqBYZC9/yK0Wp08ItcaXa1A1f3AQb91UGxP4+mVqWPsyZ/dQbgIH5d84ik01RJAeAO2coS8FVOvwR2tPiRzorML3XwVKcEhewnMkHgVpfYyyZjWaCYF5ZGysBSOKD6rQ6BJejnnijS2CMRNZ9Lj3Mw8QqOR3XolAEH8ddrE6otfHpy5KOeuQwKeeaB4KIyMjmjyZHFBarOwJU1zhPPuk5fHmW/tXFTYGzsi1XmI3jQSHJDz8Mqr46R2h/4uOiEtZWorfTz1ob59dC+A+xOCCFmXuIS/02r4Qa3xSfKO6eDh86uXbFQP/ab3DtfsfnRdSr9guj7RHEk0E/CDV9M1mkJK10pmCH5rdqt49SoH/QLjfx1n95whJPfqhnTmzyfDsj45lRciAPCagOenZBvurjw/S3dktGGhOc1XZvmIs4peHnrWEOGWruuwj4GxKx2o7tP7OcGW1hcAVNm0N9Q/hwM9I3ZaBGLH7PoAiMyy4MezF758XTbo30GuudrPGuk3mg3Iu93y+0ahYtntxNY2eyPS4tW0wJypzc4LlYff9oHi2GPh6DpyDenzNPOK7LTLBKTgo8aCBTafw/UH0id3P/fjPRN9Hk+pclLckzoAufTJcRten4xmuvcuDaHQSNaTFBS8ICBuT/cESqu0S2m4aEDjvJbXNh3e63ZH31Eg9Us0P1ylVRc75Go0d8Glc
 9kSgdGYA
 AyBDXYRgi7/8hxp6iYseRZbTXmHfExZTyPuw6t+ugMG3urYsJuIZFqdorG22aV2/YKhcQ603wL5u8qMSZj7wm3SAtQhXRLcwfaJIo+3LDp/eaVIful6L2spAu4rOUhDoG78L195zBDySnrNblu2K3RrWkOYZFlS2vo6ObvnRce/HlfBzAkgqwJVCeeOn+Y63aF1NQ8SaJKVaAg9PvgnHy4c9G94Sm780KOQfMSU8JhcYVHkkjdijcQ++hT9XPNwRs+mwoWhD+Gl6SLODB4VH7N4x1KwK5vmt3GnuBcfIVmO0EiOWX+w5wOeSTT87S0xiDdK7b3BlQmcuKyP+Zh18iE3BM5YmcnP6mESkxEckMhnVeja6dOlSbFPw1RZYDhx5ie9s6Il5vdIAZrzHYjINcTxdfNUZwDpt8SfLOi7/b/mzZJcBKT+ZXXRi4XidoI06OUjHCHwMugNPtGtHm26it4e7DrDmsZObmcllGdKy45edkh5Q3byQLU4SKvQLQ58GLrv4lA70D26MRg0mvVa2TD0YAD9BgfGE4dK/ghdFRo5LUAZsjRhhlid8HM7RTVzA7tU9SfPVrVt0rTyNbCmssnv8E4L0yjChwzRT2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 6, 2026 at 1:35=E2=80=AFAM Harry Yoo <harry.yoo@oracle.com> wro=
te:
>
> Since kfree() now supports freeing objects allocated with
> kmalloc_nolock(), free one bit in enum object_flags.
>
> Signed-off-by: Harry Yoo <harry.yoo@oracle.com>

For patches 3 and 4:

Acked-by: Alexei Starovoitov <ast@kernel.org>

I think patches 3 and 4 are ready.
Would be great to land them for this merge window
(if Vlastimil agrees).

Patch 3 is tiny, but the impact is huge and
patch 4 is a very nice cleanup.
If we land it now we can start using kfree_rcu() on bpf side
in the next release cycle. That will help us a lot.

