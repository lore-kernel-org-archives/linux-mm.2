Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0504ECD6F3
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 22:09:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A9A16B0005; Wed, 11 Feb 2026 17:09:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 058336B0089; Wed, 11 Feb 2026 17:09:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7B376B008A; Wed, 11 Feb 2026 17:09:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D29DB6B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 17:09:16 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7B0ADC1F3C
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 22:09:16 +0000 (UTC)
X-FDA: 84433567512.21.2F49957
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7AD5540012
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 22:09:14 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Ky+ScIGn;
	spf=pass (imf27.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770847754;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u2TVXkn8GKJaNCSush/gOYSj2oJpP8vJ7tbUxFj10ak=;
	b=ccqWwq1AqhXzYRLa5iQz+rbb0TAr1Q62vXIaqS52zvk1dxI8dXJVkk9q4mpcu2QhLl58zC
	RRtrM+TTSKC3ZWNoiw52wPdP3XEbFEOiduUNpzf/lDyc2x0iK5rtSBbVEJZvAd0KbXrfeY
	How0VFR/SDOoBECTQM7ZQ99tVI4yRGA=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Ky+ScIGn;
	spf=pass (imf27.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770847754; a=rsa-sha256;
	cv=pass;
	b=7ZJBiIg3X3u3L53WtR1olTVTXaZqWRUjwPf/n8KlomLFAwtCkMkWUgtBoJk4vwO2mOi/5e
	dkGApt8cjGTw+UVeJqKTFSSqmz09rMYZtolXSzUHnLPCpaTiJO9Oe5h4ZdbqKhmr3y+CIb
	RN3tSA3nvU0c3cvEGonipbew9Pi5K84=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-483298ff272so6765e9.1
        for <linux-mm@kvack.org>; Wed, 11 Feb 2026 14:09:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770847753; cv=none;
        d=google.com; s=arc-20240605;
        b=dNhiJkaMwqxPwaA9VU7605/FfVHM7v/mlZRjn9TC8/eXcLsFSYW1LpLuCQe34s81WD
         ciybuxqcKbZVAk7mwRvTXR4y7rLCiSkCxFQPjXc7g53BpC6QWW9tq4XFOIZ7wNn6ky4m
         4DBzQpz8Q00bYYaRtFmam2d3hj631F2E/z9p8IcFj+w8R7VqTyvmJuTL9wQqpzZh/rgE
         ls09rV/1hGEKNH/tu2hzrcQyFdNthzugc0c6/repkaDAb4wstv5eO53wG3VGRYUL9QK7
         SRq446L2hU49IX47McZw1ClQgIQ8z9XutuPIlTHMONXFD46PpnoDS+04huXLWXRVwqNa
         pjAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=u2TVXkn8GKJaNCSush/gOYSj2oJpP8vJ7tbUxFj10ak=;
        fh=KIDw5HYdkZuh6UJdDOHGtrrZTIbLa88fGSQw1qzMxkU=;
        b=jeybg7+jAnLV9lrTn89Z+k9z6x4Cl+f28po6SPVa72x+cX7HynjPfknuFWsBmZOHUc
         +cHUHaOiwNo5YuP5ok9gpSnAvx4pg5JnGAQhaOhHxejzBo6rrJLCOLzU2BgRIsDWYALU
         grjuI9qZUDN3Bulb31lXeOWn9idett5SfXjOGR5isAgzul+/nYRwdfbeZkHOBJgfHnUb
         V8LsLlb3ZkluWoTbKSaPzK85S8kuEc371joXYHMbGjd7y76INw1hsf0NATYR7DD/541G
         w63BbmHVbX+nU+A2zn8wHGey+wvGKQvq+sk1FXi5Mu1nWA9fCKY/ZbWVYSFNFf/9arPP
         dU5g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770847753; x=1771452553; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=u2TVXkn8GKJaNCSush/gOYSj2oJpP8vJ7tbUxFj10ak=;
        b=Ky+ScIGnH8oNKWoWnSSPkRpgO4p0VYxIrFom1IEq5bNzufO7C3ESre2Neocr2thn44
         a0nAR7rA66AOABh7QJnDNpL4CnwRu0cv43XxeOG0f+Mehuj/43jx9PDMow02Qd7hE6hY
         WEYRmDumdpcpLzT1+O8DkfVD0KJdEivbtRFFRyH9fqIY/8dh6vkQ1Ckw0MprE2BAegTo
         ETsUuwasXo5l2ZvkZXOtGxB50kAzNK6buOF86dGvejagBJhV6LhH+quQhE7Lsq1aVUoe
         lRUVEOVVDWFje5TKXpmqKkAxVGVCJ9eZvVP+dUzAzb9iRWg0EeA6ixbVd9ibvIDXhlOn
         0MJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770847753; x=1771452553;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u2TVXkn8GKJaNCSush/gOYSj2oJpP8vJ7tbUxFj10ak=;
        b=MK6Slb/NcMXoELo6C2ieJMMkhaKmVPxvOTANW17QE2oH3DMyrhkPj2+WtnaHW2SAoX
         lDz9zBIyWQYjnZSf0EzIBSMdkl+IbzQedN4KJvP4TLbwAJd5kHYZz3Ulv5lZzlqEiWG7
         ZuRraLqf8FNwDKNVwvdk7oSU1DYAPyRgmlIudVuXnaeSvqv0MgndagzXufn5uihGimrj
         Y2KlUu6glttxxlvbTOPR1exBv0DPyCsDSylkQvtq+NE9c+xFM+OK8+AaOimRUFlrGvfK
         rcNdbX2TUq7+Tp8S7yRw8FRYKVSg82O28sbHnGpLEnteduQKrJoeJInPUMV4E5C2uMdI
         x3/Q==
X-Forwarded-Encrypted: i=1; AJvYcCXvO+0ITJwpWUBsrRaf+Fq68P+Ri1vtXGBUKsxWfTzIPKVdMhfRWcNLz8+xoJC8gHIIGqIGPMrcow==@kvack.org
X-Gm-Message-State: AOJu0YwlX/TUz8ZTPt5bHSAB4N0rJl0vU/84BY13B4zf8rbvZcnFaTVx
	2iimGmLpGSDh+sFbG+9c7X/hIBPMZwVCN+D8r+DMcz/1rWbkTDNCfy1Fr69K7eu3zHF2DZuKWpu
	WkDkiVoLZ1JnSQHUPDKFoxWYhHiOXpCsQcUVy9wlk
X-Gm-Gg: AZuq6aKTgkwlMdfpn0Toq13qTyYbcrjNL/mPUFJbkZoUwUT6x1lSI1JpIgWxi1tzHst
	8W+CLaTNXNzIDdHwXU0SRvBwZSif63ydHrgdd4a2jmcPp16RRIRVOg2Ds/7Z9WkDDnK/bAXgF17
	zrZGl1IE97opr3Rhjk4EwoOIAJG2yAOqIuHU4cHSR4G4tCWtUJzKudzaRBWVvrjRxVJZ2vR9bRo
	qtjmwH/oMewFiiURVcc4kUe0tpnxsyatM4tluXk8w7bjlduD4d/xqbVuZ4J2K84jpu9GPIo02FR
	pGGhy89W/vpliDB7OSQzKPepz22JCTJcJjjv7rKCvQTFBSQbiAq59S/Di8qKJbLc/dAf
X-Received: by 2002:a05:600c:6c47:b0:47e:dc0a:8591 with SMTP id
 5b1f17b1804b1-48365710159mr244695e9.2.1770847752560; Wed, 11 Feb 2026
 14:09:12 -0800 (PST)
MIME-Version: 1.0
References: <20260210054312.303129-1-zhaoyang.huang@unisoc.com>
In-Reply-To: <20260210054312.303129-1-zhaoyang.huang@unisoc.com>
From: "T.J. Mercier" <tjmercier@google.com>
Date: Wed, 11 Feb 2026 14:09:00 -0800
X-Gm-Features: AZwV_QiyMoYSZ3qpAy5Bj4PbrblUWbMWLnYYylNSpCqtABShihCbJ-MW6LW3AiI
Message-ID: <CABdmKX0jUrb0x7M0JymG9fojk_fKO0TKaqMQt9BxrHUz-Y3NfA@mail.gmail.com>
Subject: Re: [RESEND PATCH] mm: bail out from partial cgroup_reclaim inside shrink_lruvec
To: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Yu Zhao <yuzhao@google.com>, 
	Michal Hocko <mhocko@kernel.org>, Rik van Riel <riel@surriel.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Zhaoyang Huang <huangzhaoyang@gmail.com>, steve.kang@unisoc.com
Content-Type: multipart/alternative; boundary="0000000000003edbeb064a939f71"
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7AD5540012
X-Stat-Signature: a9gx94j6ey6p5agtm3wc3y9mogubddup
X-Rspam-User: 
X-HE-Tag: 1770847754-773803
X-HE-Meta: U2FsdGVkX1+mXIR8N7kEll6biWKYJ+CcH9gXygbfAv0wmkKrfNaBLCmO+I3skCEP/pOnavXS6APSpGOtugQFk9jLopjsSRV2sx3lvOFJH6lvOgl5LgzdJcZn90u59Xhl7eDft5+sk9NbtHytsR8BXto8Ycw5W6gjZ+MiyFsP4LYPD/KLIjEK8R6KrTIaqXJLszeikgqPd2+tVjsO0IwSx00ZPzSeDAiT/UGksewsblWjYLxwP5oqKb21gYs3nx5+GhBJiEDPJLwg2Q+0akWyRgiy90Su9/ckkPZrSWEfWJepEkQQk8luZd5w+V8sc7I7Fd65a8jN2oxSaapTl31KY7op46nVkNHdylzgl3QdzOgiYpUW1I8ZwWmyfxBHCSWdCdxSnPRHr1yZtAu00Em8du6lqXACZ9C6TuXiHMbSWc9v//DjiAOs+3vlI6oQqfJRMsnqOh3mF0OjSZQXGB4uGZtgLiUlQJBPKUgez4HOi3fjkA+2jpItpx24WHdjhFkpjxcxAbz7JbEavINZw6wx6veTR2ewlKm61x50C3khjJKkKgIPWgIHboV6QIIbplrEwj2uaNRVtNkRlPTlvZhNnFq0URpxpKx47as6OBJ9owlZjxPOd3MxMyW9aY7uoybB0d5FzjHcVMZK48/KgL4jmPLAIml0aSmvuRcGdIUDwUldzRl9HUblbpYDw++puFaBnrp4+HQdJWSflMAkUuoSVE7Hhg80AAwWdcZzZ2llLMRC4GrsdXEpeGUQ94DsFA1ssbZ6JYDKuZ6A3hvypW13Kf/mbHhw11/PUuI/oMJGB4ifz9KA6RLlXWbwVIxZZT1QRnTKwoon2dRDoXpS0FcOcXlS67soClgVV7DP8X9U5iyw0I2rztBOaCpghjs4JNEeWymNjugKCfrBGk7tqRNSns+PUNKdyRJtpsPVxmCtXDqszlzcsvLuNYBYgOt5uNq3sLkFouWaBhO7ppKAlSG
 aZiDg+KZ
 IwkhQ9akSqaEmJ2j5nP7b88fTJks2y2c3gfrt4HQIOsKY1wkwMWLfRqpM/ZJazDRluD4sO81rb784CAqG9ZMoEqmNkbWCWCWnxJNxCPTa6sKqgiBxX3EuOojV4crjNyveKYGrBZLiYDmz2H95rfVVkXFP5e/QNm5o/ZmGe5vfXR/9QpjaO2mta6NHiFGbyeMveHqPjgO+nL/+EAr9rJEGdhjjjZjB9qGrnqqyH2zZrQmLWLPkKVK94KP9O+t5lBA9nmfWBkd1xnffxfHGaB9C0D3q/TVfSiz1rdfP66pUV1ECVKKbaNBusSLgoAhMGcfRgxtzFifGfLZJpoRNCed3uKDXgOYdKoI8iw6wF0uKIMtyHkiuomM3Tf5ye22q5vZvwjtE/Zht3sqHTh/0j6wOxtr7rL3akEtLBFOqCck9NzUPzdimUDloahoZnxDn+7HFPf6z
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--0000000000003edbeb064a939f71
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 9, 2026 at 9:44=E2=80=AFPM zhaoyang.huang <zhaoyang.huang@uniso=
c.com>
wrote:
>
> From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>

Hi Zhaoyang,

> Nowadays, ANDROID system replaces madivse with memory.reclaim to implemen=
t
> user space memory management which desires to reclaim a certain amount of
> memcg's memory. However, oversized reclaiming and high latency are
observed
> as there is no limitation over nr_reclaimed inside try_to_shrink_lruvec
> when MGLRU enabled. Besides, this could also affect all none root_reclaim
> such as reclaim_high etc.
> The commit 'b82b530740b9' ("mm: vmscan: restore incremental cgroup
> iteration") introduces sc->memcg_full_walk to limit the walk range of
> mem_cgroup_iter. This commit would like to make single memcg's scanning
> more precised by judging if nr_reclaimed reached when sc->memcg_full_walk
> not set.
>
> Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> ---
>  mm/vmscan.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 670fe9fae5ba..03bda1094621 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4832,8 +4832,8 @@ static bool should_abort_scan(struct lruvec
*lruvec, struct scan_control *sc)
>         int i;
>         enum zone_watermarks mark;
>
> -       /* don't abort memcg reclaim to ensure fairness */
> -       if (!root_reclaim(sc))
> +       /* don't abort full walk memcg reclaim to ensure fairness */
> +       if (!root_reclaim(sc) && sc->memcg_full_walk)

Can't we just get rid of this if (!root_reclaim(sc)) check entirely now
that commit 'b82b530740b9' ("mm: vmscan: restore incremental cgroup
iteration") provides eventual fairness for the proactive reclaim case? That
wasn't true when this check was added initially.

Thanks,
T.J.

--0000000000003edbeb064a939f71
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><br><br>On Mon, Feb 9, 2026 at 9:44=E2=80=AFPM zhaoyang.hu=
ang &lt;<a href=3D"mailto:zhaoyang.huang@unisoc.com">zhaoyang.huang@unisoc.=
com</a>&gt; wrote:<br>&gt;<br>&gt; From: Zhaoyang Huang &lt;<a href=3D"mail=
to:zhaoyang.huang@unisoc.com">zhaoyang.huang@unisoc.com</a>&gt;<br><br>Hi Z=
haoyang,<br><br>&gt; Nowadays, ANDROID system replaces madivse with memory.=
reclaim to implement<br>&gt; user space memory management which desires to =
reclaim a certain amount of<br>&gt; memcg&#39;s memory. However, oversized =
reclaiming and high latency are observed<br>&gt; as there is no limitation =
over nr_reclaimed inside try_to_shrink_lruvec<br>&gt; when MGLRU enabled. B=
esides, this could also affect all none root_reclaim<br>&gt; such as reclai=
m_high etc.<br>&gt; The commit &#39;b82b530740b9&#39; (&quot;mm: vmscan: re=
store incremental cgroup<br>&gt; iteration&quot;) introduces sc-&gt;memcg_f=
ull_walk to limit the walk range of<br>&gt; mem_cgroup_iter. This commit wo=
uld like to make single memcg&#39;s scanning<br>&gt; more precised by judgi=
ng if nr_reclaimed reached when sc-&gt;memcg_full_walk<br>&gt; not set.<br>=
&gt;<br>&gt; Signed-off-by: Zhaoyang Huang &lt;<a href=3D"mailto:zhaoyang.h=
uang@unisoc.com">zhaoyang.huang@unisoc.com</a>&gt;<br>&gt; ---<br>&gt; =C2=
=A0mm/vmscan.c | 4 ++--<br>&gt; =C2=A01 file changed, 2 insertions(+), 2 de=
letions(-)<br>&gt;<br>&gt; diff --git a/mm/vmscan.c b/mm/vmscan.c<br>&gt; i=
ndex 670fe9fae5ba..03bda1094621 100644<br>&gt; --- a/mm/vmscan.c<br>&gt; ++=
+ b/mm/vmscan.c<br>&gt; @@ -4832,8 +4832,8 @@ static bool should_abort_scan=
(struct lruvec *lruvec, struct scan_control *sc)<br>&gt; =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 int i;<br>&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 enum zone_watermarks =
mark;<br>&gt;<br>&gt; - =C2=A0 =C2=A0 =C2=A0 /* don&#39;t abort memcg recla=
im to ensure fairness */<br>&gt; - =C2=A0 =C2=A0 =C2=A0 if (!root_reclaim(s=
c))<br>&gt; + =C2=A0 =C2=A0 =C2=A0 /* don&#39;t abort full walk memcg recla=
im to ensure fairness */<br>&gt; + =C2=A0 =C2=A0 =C2=A0 if (!root_reclaim(s=
c) &amp;&amp; sc-&gt;memcg_full_walk)<br><br>Can&#39;t we just get rid of t=
his if (!root_reclaim(sc)) check entirely now that commit &#39;b82b530740b9=
&#39; (&quot;mm: vmscan: restore incremental cgroup<br>iteration&quot;) pro=
vides eventual fairness for the proactive reclaim case? That wasn&#39;t tru=
e when this check was added initially.<div><br></div><div>Thanks,</div><div=
>T.J.</div></div>

--0000000000003edbeb064a939f71--

