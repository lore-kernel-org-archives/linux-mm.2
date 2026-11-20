Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB04F606A320
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 00:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0stkX8dr
Received: by kanga.kvack.org (Postfix)
	id 9B5AC6B0670; Thu, 19 Nov 2026 19:33:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98E2D6B0708; Thu, 19 Nov 2026 19:33:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A4006B0710; Thu, 19 Nov 2026 19:33:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 565A66B0670
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 19:33:28 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AE51DA8BA1
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 00:33:27 +0000 (UTC)
X-FDA: 85453623654.07.1819B6B
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf28.hostedemail.com (Postfix) with ESMTP id C6F4EC0009
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 00:33:25 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=0stkX8dr;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf28.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795134805;
	b=awjBw7wZ1LA4fkXG+i9LR+6CrEKo1/iqgAH9VkkdMgJy9nWx4vwdy8P+ZntKeXO62nDbBS
	ARyfz/9nxWD2tRZrFyv5H7/+BQ1waEzKB0TtMe0VaZRUu9zWyI1HQWncN205XUvqpxu2Yd
	5E0F03tV9SC1u3Y5iedIQ8x29/iAv0Y=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795134805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q5dwbG3U1cLtbFVF4+FubgVmvLvUVgq9jKjpGQEHC4c=;
	b=TNFkPu9bU+QvDQ8R0GvLywEF/4rZpiehenHw+E2RxB68p8257hKYzXw4hnrUGtk+XJYdzu
	jP9oJA1eozrQ2ma5M6TePW+oCqURMQe+hEV1uMV7tNZbO/aa4GEUTxN8lX+21Tpd4YbLsq
	03jHxEDdUZXWKDWUBih8q430G/U8yGc=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=0stkX8dr;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf28.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-4a7b8abe209so217276f8f.0
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 16:33:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795134804; cv=none;
        d=google.com; s=arc-20260327;
        b=i3pFRFk43R5zS68r0vR6renMuJspz6sxRoMUzd9cIrjlUGIwuXK/cDh8MWsFNzaOgl
         NEzil1uIM7eO5qty6dHFbRXaCprTIa8QNEG78ryxNtNrHTcxhXsoUbdgfR0DEnIycO2g
         AOvFECsFxlC6HdCkqmgxrCKwEf22bYou16QWGx9KUfvnqouSSRjv4oIeDLZXj6/oykI3
         SIaJu6rFdDOFk3zduGckjNSLquBN9LwjK1CFAxq+TXciPOUEtSAHKDj64un8BFk4d7T8
         9K2TR41V3xw4AM/dhFnNcdqv+eE+q01DOqI8XQ58ESPPbETrfsL2cqnYL/qv5+tBOMcR
         wZHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=q5dwbG3U1cLtbFVF4+FubgVmvLvUVgq9jKjpGQEHC4c=;
        fh=yWCJDGlSO2c14/Sh36Sd6E9j7mbP5PAn2tbydqgup7g=;
        b=Zfi4V4rEJ5uTJQJevnzwnMJWrts+sO3nIc8UfCZtV0bkmm+58EpQhJj/8Hfc2HujXE
         wymjR2rBcNRf6OMed55nTKB+JTcaAMxSuE8LOGJmp5a4JtCqYYX+rcyExJxW9aV3bY+l
         YpLzAMG3sweea6ZIfDTRfjGZilJ3OIYsYlvOKwBV+dWmauKqHCZy4bylanh4Y93zY3+8
         0hdNn1XFPW+FoVpBXAhrXbPw7KjMrQj6FxqUqf2aZ4X1LcfVrMSCMuE4lnPxOZVfwE0a
         C9b2S+hdl6gn5sEs3gNBBNRr+YNY1n3zDCUuE6vV4cA63RhhEXOL+of8LjaOm2GanjRC
         Tgig==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795134804; x=1795739604; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=q5dwbG3U1cLtbFVF4+FubgVmvLvUVgq9jKjpGQEHC4c=;
        b=0stkX8drw1Xwxx4JPOiOdYFrcAHhLJor0vbdaEeFW/vS5/NKDYRWj1qWN1XKPxWx2V
         0oOr3aI/8VbZEOkH8kBNPbo25Xa9tdSoD6UhjO4hU9mTLdhPQjp4Z1qeD/ohazU+U2Lc
         W6H4MmDI3s4rqO+9jrf5gqzpFVwoh+sKFxLnNPMR77jVPjUllv9VqIe6Bs8j8/fZcsvN
         CnbYwEDdM4P0rFctaE9V0eGk/0NYaz4RTxmMTdNQ+8unatzYWw39BRtCo1ERIuvbcYba
         yKB2fAROURW2IJlBNBrV43yP2GzdIq15WmwQLg0Jkk4E2TiwZDspkRhAMCZx7p7tuYvK
         1deQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795134804; x=1795739604;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=q5dwbG3U1cLtbFVF4+FubgVmvLvUVgq9jKjpGQEHC4c=;
        b=B5Ru/vnMFbikuqiMc9xXunri2tqNWAk2Fee8/djqo0OTY1DFaQUkPeNSgoDxAs+HJY
         grF05A6w2hktt78CtZ0OhCV+cEB5G11wSM1b87ux0O6wKCVjuWMOBbkaut/CvFO2iIWk
         ddIfZSTHzh8uAkzBRXNY2/ixJOcwNz7i8N13kl6tw+dzpcxv7l1Kr9TS/egCX26KBjHQ
         +dkfocv22BRgNhQTQjnweqnRhDMKj8UI47OtpL+6uW/O7FttU/CdYsdqCs1RNDBYuMwq
         bKvXs8AyxDH1HDuvm/iOu+BZAvWLfYCIlvUjVzJJAjvZEz4ugVsV8b0X84Lwtcp61+Ed
         ggYA==
X-Forwarded-Encrypted: i=1; AL+hErHd5i0NStc9rFHMNVP/X4aCnehYmTqxTknmVkN808rMS08oUqfBbgIPO5M8iNXrIKEZ0A4V2H0cSQ==@kvack.org
X-Gm-Message-State: APuU4Z/bCCl2pBb7uE0ws1ybBCebTL3K2FAn1BZsNpJsgPXT+XzPSsR4
	h6f3teEvk+kleo4t9lkjzMEZ5rtY63MGSdBGnRnGqhI22iBfsjRDkRZZtQ9hHvB+WPHNRAsZXYh
	IefdXD28FYfn5BDBWLTZMkAqNmbCh+e4=
X-Gm-Gg: AZFdTZetwt81L6b0IwwcH1cHzcH8T/Abg3RHuLNmQYjvpGRrltcHWIIiO+d0OJw+cUm
	tMBZYVoVWTWDvuyCtpt0JF3dOkCLyRm02hi/kTJXxtK2fdScSD/KY/7f+MDeKCGt9s3E3mu+AKO
	r/42Ot19qA7Zk8NFsNegM1qf6ptd7md/giFSWWDyK4ISuWOy+VPAK8soCdKYVbGy0A9gwieK4Zo
	xwlcjtArsOQCp8M1iz9YwjnuPbYB3yRXiPGKBbCAcbFl04mXQ0+mX2HFLE15TQVbvSG8j5Xn4Ln
	6vHxsAdMqw9lPV24naFEzYMXvm+gSdkRDusxg6stXgIDhDK6YXESfp5o6E+Ny076Z/FDamn5Ypi
	j/A0QrnzOvoiUxcIpwEQQhvnR+5BpDjMhHk8WVAAgoH74JW8MzRr5l7L24kg0c+8ZWAE3Z1Bm+q
	/lwJmWZepun8JC7Oe3TQo=
X-Received: by 2002:adf:e186:0:b0:48e:20ed:d5e7 with SMTP id
 ffacd0b85a97d-4abb3a4d37dmr2109434f8f.34.1795134804351; Thu, 19 Nov 2026
 16:33:24 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261114002822.1043378-1-joannelkoong@gmail.com>
 <20261114002822.1043378-4-joannelkoong@gmail.com> <avvhF41RlOQSYFq6@chrisdown.name>
In-Reply-To: <avvhF41RlOQSYFq6@chrisdown.name>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 19 Nov 2026 16:33:11 -0800
X-Gm-Features: Aa3M54rY2agoJDn4R2X4j9vjOezNYoLRKUGxlNrKNsn9CzkEMvge175LEU0QmY8
Message-ID: <CAJnrk1Y+QpbFhA7NZQYu_enEa9d_dp5ySL=oegeEn4SkkGE_HQ@mail.gmail.com>
Subject: Re: [PATCH v3 3/4] mm: workingset: skip the root memcg flush in workingset_test_recent()
To: Chris Down <chris@chrisdown.name>
Cc: akpm@linux-foundation.org, david@kernel.org, yosry@kernel.org, 
	mkoutny@suse.com, shakeel.butt@linux.dev, hannes@cmpxchg.org, 
	mhocko@kernel.org, roman.gushchin@linux.dev, muchun.song@linux.dev, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, sj@kernel.org, ljs@kernel.org, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, damon@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User:
X-Rspamd-Queue-Id: C6F4EC0009
X-Stat-Signature: 391bgjfgonmnwmajzit6px4eoegouxbf
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-HE-Tag: 1795134805-656949
X-HE-Meta: U2FsdGVkX1+r7RgkODwC6OBkT2tSlG2ARdfBTL/HX/98eu8uecSVxBQGEC00zuyXMurb5UF+H5oTB4OLapzidgBbGeh6oLyu9GR+yUACWLxKg2QceKJN4EglskM74tHGTfrjcAaVttvacCt1BK1xKQlqdr4WWsF5kbw72xlU5A9BcQ98YLHjuGnrmyDFH99kpiWQjxn/syj1+btIupEWOnHD3f7vf7YK7Q/JsyAjj46XpUaxJgcnp2WGUqtcOQftICZSYJ09qt0ZMzcNEYbWtrdYsGx0gDGSGiiUUTTrpuzbzJEtB5qYky1C0E1v9beCWlUQogB98iGuH3Us1i9nxMTcj3wenc5OGTFb4EYQnt2uzvi2nYsHOutZd298B33mexaYyvxPJM/m1A4+h0b+P7roJK1TgisjqPLSq5pKFPg09wsp3f1LRilpilWzv8nZnny8ageL+NdL5WQv8yWI0lDkdEnR8P7bGeV3nz1TatzNcwUgxzo1x/y0kxQHEUExovuIbofRukExMqBxhuI9W76X6wQok6hxWjahcyxFJCG7ATMko3AQbXDoZmxsaIGbkCkv8S01o/dhh6ZN19nK+j/fKGgwpXj1n33Sf03h6W7OkkipA6pYA8AkG5F84wTPIyIAy7jSf+L287CE4MbsDg3IPKQtTEIqug8QSuIQ9WsIlaX/Q1bBWLteow/2B89p7SBGi4FBP+0EdzSZYbUO5I5y5Fba/Ge/0OXp+CMjAHZZ8m1B5d4b3Labq7x1wQYwbW9bolMopVi24V6EGtwoshVzvmHMT3kYcVilP/Q5WdqXGbkg6O2TxMnncb5m470nOWQZ2gp6D0/j+pjAdY0XJD0yQdkADl51GoVCrR5S9nNwTsNtxNYG8Hyn5cZLa3O+WlsujaSgbT5cSMQyvDbprO2+x+fUlZ3KDIg0bkf0PGaBptKaWZHJE9n9TFt+76vqh7UE4jfwYuPWnZYgzud
 P2sLf1Pv
 W4SIN2SX98l+kISOiXLbE4a604ewic2fSGf7XxwVJSaJG+dTbBaMQhxIfLOJDi5LcxJyeiKcYTwEwGPG/N/Ci4GY1kqj10r4bJbRYQ4ZNEqlxPl13wLL6vhZDNf/M5ocg+0sBBvvgDvXRaALAWIfcdiPHvSVhhJKASIuMROoWHsyn1YVuRdnzFBD4tmmQbjgKyaXA+jiELWV9Va/KxIbfr4Vwcz3nfmJFahyHv7H40fH+WoSWYTc5WABxPzo9NxlKZcXWnrmN33FGfdHj0qe+P1p4GGov7Ncrkop5UronmggQKdvlf83V6yKoBBM1zfszWSxfJ42KMi3XKMj3DcfUHdPSZ8JKmeWQkXzR8+SKb3jaPc3Mem0d1fPbs7XXs/Hx3Cxtj0ni/ilrzUc10U9PdIJyRnSQycxNtIGCieibk5hONSVF8q4a7Eh5NsO8Q0BLuB66NqQJhZgx+sI29l/huWgx0SM8hbmhV7hmJQwnJpXrFNsuA5NWTe+Sb3XsRJ3sLRpUFjCp+NyR9Udqv22WdU6yHqDkFpuZo9Dj4gjGU9wfQEExacRnqAcVw7cxgY0PhSt3LRKFysKKLiquV2jFbw94lBG1kC9oPjHT2tn7Xa28AIVIz88ukJBa2JMRlnNy92hdP0a+222wi3NaYChxHghv8ZNv1ZeCiOBK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Chris,

On Mon, Nov 16, 2026 at 9:07=E2=80=AFPM Chris Down <chris@chrisdown.name> w=
rote:
>
> Hi Joanne,
>
> Joanne Koong writes:
> >-      if (flush)
> >+      if (flush && !mem_cgroup_is_root(eviction_memcg))
> >               mem_cgroup_flush_stats_ratelimited(eviction_memcg);
>
> Not a big deal, but in the v2 thread you mentioned you would try a
> mem_cgroup_flush_lru_stats_ratelimited() helper for this, per Michal's
> suggestion. That still seems like a good idea given this skip and the one=
 in
> DAMON rely on everything read after them staying in lruvec_use_node_stat(=
),
> and at least speaking for myself, keeping the root check close to the lis=
t
> in memcontrol.c makes that easier to see. It doesn't need
> to hold this patch up though, and I've tested that refaults in the root
> cgroup no longer flush, so either way:

Thanks for reviewing and testing this series. When I was updating v2
-> v3, I tested out what adding the helper looks like, but found it a
bit overkill. It adds two new api wrappers (one for ratelimited
flushes for workingset, and one for non-ratelimited flushes for
damon), each of which has only one callsite.

Maybe it would be clearest to add a comment directly at the callsites
and above lruvec_use_node_stat() to document the dependency? I'm happy
to add this in, or if you and Michal prefer the helper still, I'm
happy to add the helper APIs.

Thanks,
Joanne

>
> Reviewed-by: Chris Down <chris@chrisdown.name>
> Tested-by: Chris Down <chris@chrisdown.name>
>
> Thanks!
>
> Chris

