Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A01CC61DD6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 04:31:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FEE16B00EB; Tue,  1 Sep 2026 00:31:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AF506B00EC; Tue,  1 Sep 2026 00:31:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79EB66B00ED; Tue,  1 Sep 2026 00:31:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 52DD46B00EB
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 00:31:23 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4539A1C1CEE
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 04:31:21 +0000 (UTC)
X-FDA: 85163919162.15.9BE122D
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5CB0C40006
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 04:31:19 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=MqqzAhWl;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf01.hostedemail.com: domain of pratmal@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=pratmal@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788237079;
	b=FD0WOpJClnrd/g+0pvJ1+mJG0riZMYw8GuN15tWVZBL/pD5zx5NwDreUVp35r4yEpiDi4C
	UQuZJLQMg5XTMj8/df/cZrnB9XDEEqdkcgVP/S4Ad4B87KIQU7yQ/2aUAt6dY7N3NDhz+S
	TnxLhYFciTkCaOogLFUSY8buE74FMsU=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=MqqzAhWl;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf01.hostedemail.com: domain of pratmal@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=pratmal@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788237079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FEJ7OhBX5NB/UHZTgvDkxBk1HpXEXeGzsORVysWiviY=;
	b=NQbV0UiWPtKVExlP7W4VA9uDvGpq0hj206pDGhd65ryFeeLcFTonsfMLI/kczvT6NMEZbk
	lMvwETsJzD+ZBkmdn15W1pS05L5AgHQwKpbqpV+oDw5VqbKGmD7D2g58oIA70NCg9Gfc7m
	dyhh2oQ995zY7t3vzNXNA9gFzMn+Bpw=
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-52faa58bff5so163691cf.0
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 21:31:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788237078; cv=none;
        d=google.com; s=arc-20260327;
        b=YyiYdeTyWIzH3BSp9iAzzDU522INONYlpAHWSBRZT+jMFVeTmGLN4Ouq+j5zW8ck/i
         Jt/wXLoKgTRdsfQ1WXAdjmzbnmjjNUVkBq+pRcrPpuNaz1Ptn/4gxzCqVMzQkIlQXHTQ
         amBdkzgMF6exk0l5vKe8cnJ4piqVG4HiUL9vubMdH/npePqVU8kcGBsLy6t7ROGbtogl
         dm6JaRJNcfm6Ep1jGVx5kMnmJe6Ut4k6S2Mhv+j5bcydEb9Hy+Qv8ruAzNFXkoDs5go9
         6tPpyzbWjgMWill4gXI1L6NraY3+ae2bEpug2nOP6mNhFUrAkmSS+yJYsiY/F9mI8PJJ
         UKFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=FEJ7OhBX5NB/UHZTgvDkxBk1HpXEXeGzsORVysWiviY=;
        fh=3woslBuKfXAPr8NxOdWzJSE0vf2SEyqGVCxWyU1E42E=;
        b=fZaKNPulfwFud02tMwUPuYW/vueVCVp99smsM+4+Ii2CVJNUUwON3MCfgiTxzNEx78
         Q5y7PPtIeobfv+2Z5McCTgq8dhopu2k5TW2JEoFfwOppLQKs/3dpxzbO0lgLZmsobufy
         xgGSHT08NNo1SJ8O+F3xuxxrIYqf/VCLOa2IYngNrIpo154foeDk3lGUSWLvW0jw7mre
         mEr+av6sV+4Op6OE4PzbFBt94oSWDCQccB48QL5/0M9IQCAgufb2BaT/eg/b7UK5CpXe
         VWaIHKKhS8tXD4kXEc4/WOEtiuO2ZGbn9gLHt7/RZc6S4CAoRRfjv1UjxWATpGyeP5Hz
         FK4g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788237078; x=1788841878; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FEJ7OhBX5NB/UHZTgvDkxBk1HpXEXeGzsORVysWiviY=;
        b=MqqzAhWlO/3WdjKsEfKUzelAdhfmDg2SkU1lB9hW9TUKgZ6nZl0sAY6knn2Kd4Q6mO
         7icML6KLOGDFASaKbSlTXvTz1eCZlmEAdORRqyHT252W1/771ZtIFD0S0VCKSRLnyFAB
         7ebXYwVq+IwZHVuYO+vzDI05763a4tfGhAhf3/tMg67bxYZTfHOx3XyLAEnPyDt5JMGi
         MeNP1rvsJ7GDYlJT5TTYz3QOMtMFAjiGQn4zpP2Mard6dSDyXaek0szCYKP9HMn3C8Il
         ia9H7I1tGH/Adb7wvhhBjmfX2WjoLyJktWX3CSA0e46IQMyPhQgdIq2HKP9kL/PeuoN+
         dsnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788237078; x=1788841878;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FEJ7OhBX5NB/UHZTgvDkxBk1HpXEXeGzsORVysWiviY=;
        b=QtRPUt8JbrAIWslsPdc3Sm1jjGiYaWnNFCs7RKS0ml3a5trCs2bhmhXLANj9xv/nBV
         3cc4D2/5rv3y1rj1lM+EGBvP7C0oABb6gj4kRj7u34/AUm0alBpxtT0BeuWdXoqlGZWA
         as0DQw2PenZRAjf0BglHrLjUvJn6GzB0X0gTLeFYFVhIOVpUyak0+RpwoNIWL/YhTQim
         PdPzSv0dyFJKUpcwyk+seXgah4L0ZKXPA3mGCJVtWk2WmYkVXUjrLzQRd2KGnurcOztt
         +srlBV9k9xDixI5+6rBbBIFynlEreLxhkB/vqjskgcwL1m+7cBI19F5taVovf8nlgfGe
         sA1Q==
X-Forwarded-Encrypted: i=1; AHgh+RqF8/rRNVD33zS+pleYEfza4VUv1MCbxfbnvKDwzMkJN/MtzIbj4GCdzpC7VeUCP9Okti4pdlGRaA==@kvack.org
X-Gm-Message-State: AFuF++nshgfY/X7XJqADx6GXf8IxHD1AaM9f1+/XezjGh0rOYTetqU49
	28pynntxtjSxPNoYNUFAhoKWTIQqi94X33Nhou9pz10ZVlsBQf/9s/wAJWIgnSQNhuSZ2iNqlnN
	RfB07OZ7S8Fyafi+EnIqkSZ6wfmqXgFrc2l8on6oc
X-Gm-Gg: AR+sD10rMoA0NkdVHgO8XtyYe5aQQpGhesngNbLayIt4HsQBd0Fye59/KqjDPExBtIN
	MJoTFS0HLLZv+jYbRjRnzkivpkyBh69t7tVDJNtmuBRgitz+pbeQYYpNBptG6IdlGASWMZNpmXq
	rPGb+vNvcVi7U4wPXiKEKJ07Mv2fZPhXXFnybytYMxH5Mou874v9/kXdGDevfrccUpvCw7JohkJ
	q0GF4hL1PxE1+OHtFbhzG+7DdOw6DPv3vnvgrWnP6HxTs+rK+UtCpIF2E4XokJgJYyBfvR+Be5b
	8I3IrxNgJNKED+sZL5uLFzO24tf7wqswcDx7BG+wFqmQUxq/YGlh87XHQld0vZSe2W0KBa3qeBK
	JUg==
X-Received: by 2002:a05:622a:4d08:b0:517:6010:7c71 with SMTP id
 d75a77b69052e-53024dbfce4mr7950491cf.4.1788237078025; Mon, 31 Aug 2026
 21:31:18 -0700 (PDT)
MIME-Version: 1.0
References: <20260831-fix-mm-selftests-gitignore-v1-1-c984bbd4c5e4@kernel.org>
In-Reply-To: <20260831-fix-mm-selftests-gitignore-v1-1-c984bbd4c5e4@kernel.org>
From: Pratyush Mallick <pratmal@google.com>
Date: Mon, 31 Aug 2026 21:31:06 -0700
X-Gm-Features: AcwNN1W-OquKi310z5tOIsz9OK7PtMpaQzdifnWmAOLie0upZ2KKAIgtlk6wDn4
Message-ID: <CALHaPKcyxUMja5-eCcfWq-SOBXzzu_cPOzZa96gewUW-0Xttqg@mail.gmail.com>
Subject: Re: [PATCH] tools/testing/selftests/mm: add missing .gitignore entries
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5CB0C40006
X-Stat-Signature: ca833ubd7wno8ujycogk8bddfi535hca
X-Rspam-User: 
X-HE-Tag: 1788237079-771606
X-HE-Meta: U2FsdGVkX198HTFr+3v2dBpy7KoBY0bQNk4k5UrKQrGLuJwWJ4L17znNYwJk5EiqVdEGUbAnbh/aZkRQOXalOKGK3NspQtUSmZzWenahSjdFhPKmIOpk4eYmqN4kqXS1C6NaYXh+UeP1FMfleZwsAd1iespskjvGK4l163aY2h9wC0rolSdB5K9pHPzLutkX0j/0CbZb/8NqtTuJRwHKsN3TX7WYFks2tm2FBkGvWux5JsUhugcvFW7tvLxEW/8AfubzMvPO5SfrWSfnwCHh5uGQ/jowe4bx3zq0JGUzDV8zRcsgIiCo/fQXN3J+gAbX+viFHg6I9O/TmLW64MnKRppMvvvgAQcx2QcOAsyWnAoYnDiI6XaVZd4cTJkqwgrTHAzFMETR8LjL6BGa8lkWGZ23IBJhCySh/tGuEe4XCK4TbhGDlHiyYAWkQSFMn8Ni4dnT8HP9Lr8ne8N3NXRu8xkUBZFeP1BnprtrSbxWROSHf90FvAJkE6xjn9Ik1gBVs0NyBMpHI/EHYeTa6Fz2kAbIcvvckMfc8BgfIUstOArH8/PelSWyNj8Rx+4lw4CmU6jNlimBzBN145FfyhXERJ3WDTOXX/aeXTYjj25U1/sXnH7teTeCOi+I/HefoJytG9+HG3i2sQqGMdcfAdyw3tWeQ7pdDbL50FO//H9WMWgFaETRRVkpphoGelM6cGF6JfTyejw5QftYPtXv+iOQDZQYgujLxgOAuFFoVe8XIAh2LDOYRgEJrlrUBjmeTLKltH7vOzegYsc5cGuAGMI1a+ZU8r7uAIQOIkjJREwVaHWELmZwgxEFW4xDhg6LPQoqRs70F1Ql/ssbtPuhSuPC3AIjvsaVJgyx56BCU2LPplVsEQbTHLu5OMWSsiV0bWewFlxlU9WTGQDdgxwFSRqmyjFaBTSpraojl2Ghe4S8K9LsgFPMIoxURF6B1+/fISSdghL0J5C9aDpj+wxal0R
 Eler9Q0j
 4D7b1METQ6xS5p8FZ9P39KJHcfXNmyRyE69WWUSYHcTXW8BEjvH+PZa0mqdhG+U/owLsCgeQJJXEZDdvrcM98ZeX7mW2ZByjESxFKCiXUyItDPod2XR/zKZzyc8HJgGDlPPUtz9/eEWoLyh/mt+LA1XEOr1oE25Y69NnaxsqXA50VUPUYLjhmb9H/IXlsnrWFhwrcFspbFNoqXcDC8nalXXy8hF6PBwRGArISw5EiKaxCuyzA9wYQDdIv6vEUO5Fm/EA1Ei+K5zdz7cU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks for the fix and apologies for missing it.

Regards,
Pratyush


On Mon, Aug 31, 2026 at 7:18=E2=80=AFAM Lorenzo Stoakes (ARM) <ljs@kernel.o=
rg> wrote:
>
> Commit 2bee308f3adb ("selftests/mm: use pattern matching in .gitignore")
> switched to a pattern-matching mechanism to reduce churn in .gitignore.
>
> It however accidentally excluded the page_frag test's-generated module
> intermediate C file with .mod.c extension, and also the local_config.h
> header generated if liburing is available locally.
>
> Explicitly fix both the issues, fixing the module-generated C file as a
> general pattern as these are always intermediate files that should be
> ignored.
>
> Since this is a trivial .gitignore change it doesn't seem necessary to
> treat it as a hotfix.
>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  tools/testing/selftests/mm/.gitignore | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/tools/testing/selftests/mm/.gitignore b/tools/testing/selfte=
sts/mm/.gitignore
> index fcd892ed21e3..a306d7754786 100644
> --- a/tools/testing/selftests/mm/.gitignore
> +++ b/tools/testing/selftests/mm/.gitignore
> @@ -2,7 +2,9 @@
>  *
>  !/**/
>  !*.c
> +*.mod.c
>  !*.h
> +local_config.h
>  !*.sh
>  !.gitignore
>  !Makefile
>
> ---
> base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
> change-id: 20260831-fix-mm-selftests-gitignore-dd389da72760
>
> Cheers,
> --
> Lorenzo Stoakes (ARM) <ljs@kernel.org>
>

