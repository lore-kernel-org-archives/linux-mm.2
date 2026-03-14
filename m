Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14CB910854A6
	for <linux-mm@archiver.kernel.org>; Sat, 14 Mar 2026 20:37:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C7906B0088; Sat, 14 Mar 2026 16:37:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19EED6B0089; Sat, 14 Mar 2026 16:37:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 056816B008A; Sat, 14 Mar 2026 16:37:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E9C8A6B0088
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 16:37:48 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 73B535B75E
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 20:37:48 +0000 (UTC)
X-FDA: 84545829816.30.B6792F8
Received: from mail-yx1-f44.google.com (mail-yx1-f44.google.com [74.125.224.44])
	by imf08.hostedemail.com (Postfix) with ESMTP id 68CD7160004
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 20:37:46 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="aP4Ng/Ll";
	spf=pass (imf08.hostedemail.com: domain of aethernet65535@gmail.com designates 74.125.224.44 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773520666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bw/8E5PGkwuGEntQ14lqvKmLyctBPAI8FASKsqUgF90=;
	b=OAWxPAh8co8a9gEqzeXl6EupteA/LmSIzHUhDXuk/3sKvys8UN/wia3B+MfjRbFkcNX8TI
	FSCenDEC6Oau0UVmFBJPu3ru2XETJBi9uvpVT+/zgew+qw43IGiDJ+eGFDy9oI6PeaOvY3
	Rxgaijaqr3eqa/AObfmv2Frcfb+gd+Q=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="aP4Ng/Ll";
	spf=pass (imf08.hostedemail.com: domain of aethernet65535@gmail.com designates 74.125.224.44 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773520666; a=rsa-sha256;
	cv=pass;
	b=Itcu4T0h5y5nu4mY+uT9Jtdo66JIrq9ChcNyT7jJt6RCCQvx0PKzW/a/dtrHozbjDW6YeS
	R508JuLfF6zIbse8A/q1GlmmpvzwO+vc9TMS2GA0MjkBrseVTIu7LJlwKm4skNHHZCtS9V
	/hhkiwDKKtMxhwDQupr+jihyvHzMSO0=
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-64ad8435f46so3673547d50.1
        for <linux-mm@kvack.org>; Sat, 14 Mar 2026 13:37:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773520665; cv=none;
        d=google.com; s=arc-20240605;
        b=fHlnTOv6+gCwV0SPxpPRhHnAAGfWPNt92ZqjMUxhMZM9ZCi0vuYnZdKrTMRKyELOMJ
         lxUDV0Hp8mZqQ9YzfLyDPtZsjFKk5is16WHcce/Vu478ifc7Mgax+G17C5vBBYvERFXZ
         iwSnrTOlzw9AgWeZB0k/y8bGL6UcnGOWQxNuS+8d69FrLTRRp7ukAAjFmfVFl1wdh+H0
         S+pJEHi9ZJuDE6MwNf/atkqfh6P+KmrBl2XQTc5zyf2zLsS1gbqMK+vPWUo01Nf6/FO2
         aV3tRLpRnugdAJNEE911WjdZ9VMSFOiUxfQlhoO3BUK1a/jHVin3J3h2sITBY1ApX84N
         lb1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bw/8E5PGkwuGEntQ14lqvKmLyctBPAI8FASKsqUgF90=;
        fh=wc3cOnLGDVazRI9GQ40cAzTIaYMqoZQ4jKqPmxRY4vA=;
        b=Ws575osGthYAYDVv3eq6jk6fGIjyL1GApI5OncahrYIexozxKUjdIO89dSn3C5Sjh6
         ryawXjlPf5ZeCl+pBjqnyq9DR7T9zGGbz7ZfsW7vlHtG084dORHYgqtkAn3FaoSQBr23
         tbajB66w/GIry6rrQzfqRY+s/gPy2A7bFe0t7nUfs1jhdL1cVQ2IWERZflBqU0ifjmY8
         LmsLjs2D3QBGt6aF8AlAjkHrXVbC33fHbZviDiDzShjYG2a1Ne8wNtG7m9hJa9+cP1zW
         1Huf9uT9HwJBxLG/cmzoZnvJ7pfhbeKNYa9/5DP5vkl4uxyZbdh0Xit2QzEBDZgzqms7
         mKKA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773520665; x=1774125465; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bw/8E5PGkwuGEntQ14lqvKmLyctBPAI8FASKsqUgF90=;
        b=aP4Ng/LlajABo97+ZH3ykOl6ytsTlxcTPYptGoCL+mnJFh9RjwK/reNCZEtpOmUmf1
         ll6tDU81EieZTCT0Z/0KUVwY7LPrUczz++Kv1SCxNbq6KPOIXDsCziU1Fh1aS+d8NlIt
         DCPDnbq+qDJkJyNA8HTKQ8XDpmbid998RNy6KfwnujkNdMHqk2RWByLKJk5cvsMOTVDk
         9Yd+HZCSBsKC3CWFhcyFzJ4CeXDJw11NZoEvc783Kep9h2+YBObeZ3vzwdGlIECPL4mb
         tyzfFdJd5WaunC1Wxi3lBq0IFyPA+Ka3/NaIjEgEcZp7IV5CVU8DvEkvnXY6nls1ZYqW
         lseQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773520665; x=1774125465;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bw/8E5PGkwuGEntQ14lqvKmLyctBPAI8FASKsqUgF90=;
        b=FOslPNMok5xJfZ2aeKbwSzsbP0Ayv6jvyB4IqP93fKD5hHUX6tnFtwNbvCHdyaICGV
         G+b15Q0seKHtleuY63XgCupfB/Ys0ey1AaIqJO/iM3IAOS1Ei0aph2XkG1hnaWw4UDzg
         yfsiCQGJbPMtYitahgQbUwtUW65VDWsiKNKzYORt2xzWf3YZF8YXGdb3c0NhxQCEr+lE
         ZoZ9C6SKxW3pjjd2PS+yuWWuhiz1VCVnwU7Q+jwZxH5PJ7iSwu5P2irwevKB8pKbHgwI
         AX4OlslZ3f7qfB1j7u5SCFy+mETNcO4oaYl61l70FkSDB1jMc7ziclIcnJDj/mwupySs
         w43A==
X-Forwarded-Encrypted: i=1; AJvYcCUp/guu8ten1NTzuixXOuxi7lmcfQp+RkEOKnR5gjASTzHtW4Da0HTRJ/6MOXuWfg9KeM9kQjnp5A==@kvack.org
X-Gm-Message-State: AOJu0Yxg5kmoTSbSbnoiv41mdop/Ygz61N4RkBu24egVyJIZrQnI77dG
	fF2hLw/ZGMj3glLp6q1nYxy2YI14lyqqChMNeJUElSiuhCdF88tWvg/ISs+bqEbITeBbS5SplNH
	lvfSiidGQIBmnlcXHi0+aPndJ1C16ERs=
X-Gm-Gg: ATEYQzyTzlJvRVrInXA7FJ9fgozueGkYhvmy+L26mPviNUgWj2IpgGYaxdN7WGq/puH
	BraVfrVqq7zpfkx9u0ti6z+OISdd0O57tN/kSg9PrsR5wEygFWXEoBoLkiCLTOR/gj4oFPlR7Oe
	0ahn/7IpOwPv9ZXEWg4pNvQtYlXCmbCPP884Q2gAk59Mygp2SQVdEoHq0JZlLbFnbFbQsn/2lJm
	Ywm/TPDTqzZJ8e/ebzghTMdjHY2qh6Vgl/aX0DBH60rUjMLSQz4z0wGiPstpveRJH6a/33OCSND
	MdKlmas3b8N/tecaOLtYQgcW9Y6l+qmvwnTvO8JAbIEwyb5W8zE=
X-Received: by 2002:a05:690e:4402:b0:64d:6813:6869 with SMTP id
 956f58d0204a3-64e630db1e0mr5468159d50.73.1773520665304; Sat, 14 Mar 2026
 13:37:45 -0700 (PDT)
MIME-Version: 1.0
References: <20260314092145.7496-1-aethernet65535@gmail.com> <20260314162546.86404-1-sj@kernel.org>
In-Reply-To: <20260314162546.86404-1-sj@kernel.org>
From: Liew Rui Yan <aethernet65535@gmail.com>
Date: Sun, 15 Mar 2026 04:37:34 +0800
X-Gm-Features: AaiRm51xL3AUkg6kP6lI9CYOzld0LBeKXax_xM2GzdwD2vIebs67Jc_XwBf8SDw
Message-ID: <CAPLv50rMiS+PBFh6BQ1f1XZAJu=1hMOaSx6ySQgeHxAY=i1mQA@mail.gmail.com>
Subject: Re: [PATCH] Docs/mm/damon: document exclusivity of special-purpose modules
To: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 68CD7160004
X-Rspamd-Server: rspam08
X-Stat-Signature: sqzqf5jy93iqtb3sjn7qzk33keaf3rj4
X-HE-Tag: 1773520666-454286
X-HE-Meta: U2FsdGVkX19G301ngMfzC/olZYaTgKdOP4kfrZ6jI7nJiU7mfKrue0yleIixa5PeUYk7f2lfuEvH3lD/uhzvIpRk5IHeBpa8SaVwGMl+tZ3EP5e4f+tH+yYrRADzSvBHkYzTp55viXF3VPjVmcGkYyd1O9VBoDhHjK+kRwKauumJvv7TFWK7EXReiPKJblMSyyvvtCqIbYg0FAORUMV/Kbi61PzVhSXKlgxDoIso7KQEiGrllMonjVRTZ5Us3KQ6q71kAXRzeNzuvQlZhq1MbCt/vBI1HcrQU6BGwUubV9J4NSA1U9E4hOI2wiRiJhXJXARPXqc+2hhxrR49Q9nzCG2B0pHa940Zs7wa5b+nbKIQbtNyiQsGaToB4B4pQ7c/4UrLYYzmfp332/RrphKlYSyrVpPSmsW1HE5+EqerUJxotIybDdYtLYq2wADxmYWSeTtMgMn3SlMSRwcu/J8Ap5qq3wGlF2KiJXmgqBWrVi7R/J3sU8/oEOySMRxepXMXKgp/A8Gp0vLWorxiRcNXOQtIFpKPFr35d1L+PCcT+ob8e1gKBvobqCsdFXWnWSOSfQ8x7jsjYN+2ghGJAiorR2VGakORF0lM+ZVuM8vpKA6nr9apVrVjn2tDeTqbDl1hBZsqzTy7VtFSFfYlPKVrMhKCH3Hr65U0pszO6mEVwXj/3BxVu9hP4J+WV/TXEWPXapDVcYsGN2F8fNnsyujnevLX326LQhKCw+63wZ+IuzrHlPz0Bu3V4dK/6AL2wv4M1hL5ahrn5CWQLJ4CvHGlcDO9I9D0bt8GkRozJZQdWXUj/MxcX9lGblzAImE3kXXFOAUvPqM1yLzxDVeuybmdPgbJIanQCcP3x0shYxFfQPsDn9/SYBFAzNCf9wYxk2FZro8o1Ousa4sB6WcsHK7JfsdBWfbyDezsMH1kcjsQoIXHy02Crm+uptPoNUm6z6DVtX8t4l/1zKUEkHj66qm
 xVuyFMvj
 iVsRp2sZpUt7/SD1VQTQSrYcHeeHRbDc/pHo3gwdYmR9o0YsOLaVhfdI7XYHqJ4RPObWdeLpm9ErbUWfgMNoT3fnjdTCqR5yHMaRiR1d+2dVde9i/6J7N5AgRG2c/ad9mWZ0FXps8KvLVdH4ww5bGzhn8THcAVwXK5BF2fo3rmUKuaIQ8/OxARosOAza1EglVS1qmaTPUpbqJtC7LkK6p2HRDn0ojLE5bQwOC0NgUeK3UHuGTY6NrwJ/RLBVUPtpzIPYbm2A5hlhK049RZ9HeqH1INfvd9se0b4gB+HONEp7XDWkDktdJBvMvrfFxE6MktcaT8WqaKV9KWAUTSWKUBR1bujuGitz6uxuREMwW6bnHZvzxHotI9CfdOSbRkkHDAK/0VldGGpjOjtZNYBW9x8BfEp4YyT5X8xbOYdNlTdtT2JF7mjCtB46UcE0IKdUeZidFyjev9vBrj1cgP0Krf+Jwok5P7q4DXf4rCOPF1S8rk0rrrOIhE4/Pdu59XX63GShWrT5ZjEy1B5Nc5hK9o7x8eA9CPCIGH9NvqvK/RqFEoXfoqx+P78widWHeNeQM36viSMSonImWO+0msEiKqqD6tb4JXEuFAuJQN7cVkgdtlfc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Mar 15, 2026 at 12:25=E2=80=AFAM SeongJae Park <sj@kernel.org> wrot=
e:
>
> Hello Liew,
>
Hello SeongJae,

>
> And thank you for fixing this!  But, the broken "contents" directive is a=
dded
> by a commit on damon/next tree [1] that not yet planned to be upstreamed.=
  That
> is, seems this patch is based on damon/next tree.  As a result, this patc=
h
> cannot be cleanly applied on mm-new.  We prefer making patches based on m=
m-new
> unless there is a reason.
>
Okay, I will make sure to follow this in my future submissions.

> >
> > Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
> > Link: https://lore.kernel.org/damon/20260314002119.79742-1-sj@kernel.or=
g/T/#t
>
> I think it would be nice to give a context about the link.
>
That makes perfect sense.

>
> Reviewed-by: SeongJae Park <sj@kernel.org>
>
Thank you again, this marks my first contribution to Linux, and I truly
appreciate your guidance!

>
> Assuming you agree to my above suggestions, I added this patch to the top=
 area
> of damon/next after dropping the "contents" directive fix and adding a si=
mple
> sentence describing the context of the link.  The change made to this pat=
ch for
> that is as below.  If you don't mind, I will post it as v2 of this patch =
by
> tomorrow morning in Pacific Time.  Please let me know if you have any com=
ments
> about the plan.
>
The plan sounds great to me. Thank you for taking care of the v2
submission!

Best regards,
Rui Yan

On Sun, Mar 15, 2026 at 12:25=E2=80=AFAM SeongJae Park <sj@kernel.org> wrot=
e:
>
> Hello Liew,
>
> On Sat, 14 Mar 2026 17:20:22 +0800 Liew Rui Yan <aethernet65535@gmail.com=
> wrote:
>
> > Add a section in design.rst to explain that DAMON special-purpose kerne=
l
> > modules (LRU_SORT, RECLAIM, STAT) run in an exclusive manner and return
> > -EBUSY if another is already running.
> >
> > Update lru_sort.rst, reclaim.rst and stat.rst by adding cross-reference=
s
> > to this exclusivity rule at the end of their respective Example
> > sections.
>
> Thank you for doing this!
>
> >
> > While at it, fix a Sphinx syntax error in the "contents" directive in
> > design.rst (missing space after :depth:) that prevents the table of
> > contents from being rendered on docs.kernel.org.
>
> And thank you for fixing this!  But, the broken "contents" directive is a=
dded
> by a commit on damon/next tree [1] that not yet planned to be upstreamed.=
  That
> is, seems this patch is based on damon/next tree.  As a result, this patc=
h
> cannot be cleanly applied on mm-new.  We prefer making patches based on m=
m-new
> unless there is a reason.
>
> >
> > Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
> > Link: https://lore.kernel.org/damon/20260314002119.79742-1-sj@kernel.or=
g/T/#t
>
> I think it would be nice to give a context about the link.
>
> Other than that,
>
> Reviewed-by: SeongJae Park <sj@kernel.org>
>
> Assuming you agree to my above suggestions, I added this patch to the top=
 area
> of damon/next after dropping the "contents" directive fix and adding a si=
mple
> sentence describing the context of the link.  The change made to this pat=
ch for
> that is as below.  If you don't mind, I will post it as v2 of this patch =
by
> tomorrow morning in Pacific Time.  Please let me know if you have any com=
ments
> about the plan.
>
> '''
> diff --git a/Docs-mm-damon-document-exclusivity-of-special-purpos.patch b=
/Docs-mm-damon-document-exclusivity-of-special-purpos.patch
> index 9e74de3b..db466405 100644
> --- a/Docs-mm-damon-document-exclusivity-of-special-purpos.patch
> +++ b/Docs-mm-damon-document-exclusivity-of-special-purpos.patch
> @@ -11,26 +11,31 @@ Update lru_sort.rst, reclaim.rst and stat.rst by addi=
ng cross-references
>  to this exclusivity rule at the end of their respective Example
>  sections.
>
> -While at it, fix a Sphinx syntax error in the "contents" directive in
> -design.rst (missing space after :depth:) that prevents the table of
> -contents from being rendered on docs.kernel.org.
> +This change is motivated from another discussion [1].
> +
> +[1] https://lore.kernel.org/damon/20260314002119.79742-1-sj@kernel.org/T=
/#t
> +
> +TODO: move below changelog to the comment section when posting
> +Change from v1
> +(https://lore.kernel.org/20260314092145.7496-1-aethernet65535@gmail.com)
> +- Drop contents directive fix
> +- Reword description
>
> -Link: https://patch.msgid.link/20260314092145.7496-1-aethernet65535@gmai=
l.com
>  Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
> -Link: https://lore.kernel.org/damon/20260314002119.79742-1-sj@kernel.org=
/T/#t
> +Reviewed-by: SeongJae Park <sj@kernel.org>
>  Signed-off-by: SeongJae Park <sj@kernel.org>
>  ---
>   Documentation/admin-guide/mm/damon/lru_sort.rst | 5 +++++
>   Documentation/admin-guide/mm/damon/reclaim.rst  | 5 +++++
>   Documentation/admin-guide/mm/damon/stat.rst     | 5 +++++
> - Documentation/mm/damon/design.rst               | 6 +++++-
> - 4 files changed, 20 insertions(+), 1 deletion(-)
> + Documentation/mm/damon/design.rst               | 4 ++++
> + 4 files changed, 19 insertions(+)
>
>  diff --git a/Documentation/admin-guide/mm/damon/lru_sort.rst b/Documenta=
tion/admin-guide/mm/damon/lru_sort.rst
> -index 06a46812a728c..0198dfe87f4d5 100644
> +index 73980bacc3a02..56690646cf398 100644
>  --- a/Documentation/admin-guide/mm/damon/lru_sort.rst
>  +++ b/Documentation/admin-guide/mm/damon/lru_sort.rst
> -@@ -353,3 +353,8 @@ the LRU-list based page granularity reclamation. ::
> +@@ -351,3 +351,8 @@ the LRU-list based page granularity reclamation. ::
>       # echo 400 > wmarks_mid
>       # echo 200 > wmarks_low
>       # echo Y > enabled
> @@ -40,10 +45,10 @@ index 06a46812a728c..0198dfe87f4d5 100644
>  +purpose modules exclusivity <damon_design_special_purpose_modules_exclu=
sivity>`
>  +for more details.
>  diff --git a/Documentation/admin-guide/mm/damon/reclaim.rst b/Documentat=
ion/admin-guide/mm/damon/reclaim.rst
> -index c5b4d8a1b0014..a37ce6fdff050 100644
> +index 552a7786b0829..6f580f637134a 100644
>  --- a/Documentation/admin-guide/mm/damon/reclaim.rst
>  +++ b/Documentation/admin-guide/mm/damon/reclaim.rst
> -@@ -331,6 +331,11 @@ granularity reclamation. ::
> +@@ -318,6 +318,11 @@ granularity reclamation. ::
>       # echo 200 > wmarks_low
>       # echo Y > enabled
>
> @@ -56,7 +61,7 @@ index c5b4d8a1b0014..a37ce6fdff050 100644
>   .. [2] https://lwn.net/Articles/787611/
>   .. [3] Documentation/mm/free_page_reporting.rst
>  diff --git a/Documentation/admin-guide/mm/damon/stat.rst b/Documentation=
/admin-guide/mm/damon/stat.rst
> -index 468c122c42594..46c5dd96aa2ed 100644
> +index e5a5a2c4f803a..c4b14daeb2dd6 100644
>  --- a/Documentation/admin-guide/mm/damon/stat.rst
>  +++ b/Documentation/admin-guide/mm/damon/stat.rst
>  @@ -45,6 +45,11 @@ You can enable DAMON_STAT by setting the value of thi=
s parameter as ``Y``.
> @@ -72,19 +77,10 @@ index 468c122c42594..46c5dd96aa2ed 100644
>
>   aggr_interval_us
>  diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/=
design.rst
> -index 0a3b77ec458fe..3694c541e65aa 100644
> +index 29fff20b3c2a9..dc37402c0fee9 100644
>  --- a/Documentation/mm/damon/design.rst
>  +++ b/Documentation/mm/damon/design.rst
> -@@ -5,7 +5,7 @@ Design
> - =3D=3D=3D=3D=3D=3D
> -
> - .. contents:: :local:
> --   :depth:2
> -+   :depth: 2
> -
> - .. _damon_design_execution_model_and_data_structures:
> -
> -@@ -960,6 +960,10 @@ more detail, please read the usage documents for th=
ose
> +@@ -853,6 +853,10 @@ more detail, please read the usage documents for th=
ose
>   (:doc:`/admin-guide/mm/damon/stat`, :doc:`/admin-guide/mm/damon/reclaim=
` and
>   :doc:`/admin-guide/mm/damon/lru_sort`).
> '''
>
> [1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile=
.html#scm-trees
>
>
> Thanks,
> SJ
>
> [...]

