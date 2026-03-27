Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8BFB10F2865
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 18:21:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEC9D6B008C; Fri, 27 Mar 2026 14:21:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC4156B0095; Fri, 27 Mar 2026 14:21:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB2996B0096; Fri, 27 Mar 2026 14:21:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9A1AC6B008C
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 14:21:38 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4624FE12FE
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 18:21:38 +0000 (UTC)
X-FDA: 84592661076.12.BEC1426
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3751E160003
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 18:21:36 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="R/VFugtt";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774635696;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dl8EihU6p9JauLjVIGQ3FmZeCRQoUkK67Awxmso4g1k=;
	b=gUsAl9BRCySUKrvwzQ/wM2W/zVC1xOqFN4sKl5AvQNisbGDMSZFwUBYRdLgkZ5HUbi9uWi
	D4I41f+T4PIkGUoSJ9VZStAsoLIzU6LB9wlvkBUz0JNU1XeORrDz7CgkDfC/nb0hlT2gz6
	uTLtnNf8tOj5/Hyjwm2v+eWj78bv1sg=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774635696; a=rsa-sha256;
	cv=pass;
	b=NH46ntAibp06fNQaCX37wp/xtI06NeXNPpGCxkU4yvttD7+LP3vlDjjfIt+UYnvyn1gkML
	CKKKK9EVjBTiDMuH4cSMLRd6Gx+opzX83fLrfxlrEYnF+0sK1eLcHihYbFwcqi1bVhelP/
	jOZ6ocmBBNckRrPu8SNId4aj0ZSsvQs=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="R/VFugtt";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-43b88b7ca76so1927084f8f.3
        for <linux-mm@kvack.org>; Fri, 27 Mar 2026 11:21:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774635694; cv=none;
        d=google.com; s=arc-20240605;
        b=cJszaXcd6pnjBHZpPWnwWRIFdlqW47QUizxW86FxNvYL/cRT4TnSPlq2fsPgIwjehe
         /zwHY/e+2Klu4m+Qui1jfjRFfzHkBef5ghDN9f8UmU9Kfjvn34wu07oLmWfxzDUK0HUe
         NgJ3ni2yPl7RAL62F6rtWmjQxDQ8uXt5G5Fud8cfwMAERtrxtxJHXBUt59U7SGuxdcl7
         sTjfIahfUG37fbzepxkZCHd8nOl3t44MUovHVrDMW4r/LkCVkws9jwacOfGVQHcTBZrJ
         bOKbvDga7dHj24xYL6si91T8Ft51/fa/7JvV484H8AX/2/+tfvbCbYymAaaS//yooZQj
         Y00A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=dl8EihU6p9JauLjVIGQ3FmZeCRQoUkK67Awxmso4g1k=;
        fh=jKKqcaoogLo8QRTGeIXuxy/ChtRaedYstmgdvck77Yo=;
        b=hPG5u7ktqbM3XoLC5fjANng+s/T9IFvWwhN5FytqIyntAhq9vz9DZkQnvZjxq/gjU7
         vaSqoJ50sRqbgKKYehxQ2+ctSToQg/x4iorv3u7V3c4yKaPG95WJa+WfgcjzJfj5tLWw
         q7IY4tMb2VytBJPkwidfwrQ3omvypg+gNUXSS6kNdhsC/FJjTIsRb8fwuF9DGebXC81h
         oGvhuoqaxtaz8nBi9VyIJNI+kON2y0LcjfHJ+2sI735MF+Ey2MVI9Na7folvNGsSFvBK
         J6lUEyQr7LHIDwYbll3hR0k3Rj11D5w1q84Oe+5QOBdLefRKn/4zkHDcjiT4sY6jsvpe
         7/gw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774635694; x=1775240494; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dl8EihU6p9JauLjVIGQ3FmZeCRQoUkK67Awxmso4g1k=;
        b=R/VFugttFR3kPgIz0ySEvNueXH8jESVfm0giCnH9GCTsqbGVIJqsGtVxxK6h62GdSm
         LdFfFf11qwpqsiPdbYZokHtU6M7BZcrvqBYqDkM9fOtJUW4Z1m70cpt1yzafP2g31I1+
         dpk/14Ye+PrNG5+4vfHCnKGCDZ0jC4SYLQVQd8p4v0edCMhGACC1+yVvmsgV3QbkjicO
         34mzuYAaSA3GyRxORFPSjDiwXprNrvfVxgFqWh/6PJpyZwRZ9kGjDXHf7Ucd0FOockDL
         wqT0f5AOKEPfJ+yM6ZHnGxF8ECvVtXUonWAApBPhNeg4M+5LMtq32b7a1FeV8dEWH9UG
         Rfrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774635694; x=1775240494;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dl8EihU6p9JauLjVIGQ3FmZeCRQoUkK67Awxmso4g1k=;
        b=FqwHA9Hwxeq7A1M8T5uIS6X0MCLqGg7+tzwsBIjdJtf1Xxzh+m4m7LZfzqpdEe4SRL
         /BFD5AveLwRHEdd3eFNXs2oxLrGaL1RPds/ToOZdOYoifctdftAOnkPYNV7Kv95J7s67
         QzLfgGVygEv4AaOX5VsV8nHizsUICj2a/ODoJmZFlDuoeIFYbPctyYNXYCjjZ0JaGcVv
         R4EdAm+RyLojWUjaVA27aE9YAlDmX4MnCV7/Ue/mgZ7Yy6lIArcY0QaFChdg6PU28eUK
         QccFzrdb8FuY1OAuiPcN54HFsv1eUzyXCf7dCZZ5aTztON9AI0ZJblaoIxLgNkPKWdmg
         0n6Q==
X-Forwarded-Encrypted: i=1; AJvYcCU9YhlEmSNa0afR1L6YWYcPVwRteGo8jPbvXHaVXLgJciCrzy4wU6VuBye4nj/Kn28K8rrs+7hYrA==@kvack.org
X-Gm-Message-State: AOJu0YxIQTmz6fZozY7ri+5FyETIuED4z2Su3pyMMab/sjz+O/zvEiYf
	d9GtMDg1hP7z3X21df+pGAG+b4fYcXdS09QPVRCuh9+X+rUFa4CMGbP337D5GcxyX8qy6UJu83s
	YyqLcgZrnh31/SZLKTQH/RhnVExl09ZM=
X-Gm-Gg: ATEYQzwEgKKgiM6U+6LUzhsrNYaEU5/RIfmpELg9eQsiBGK81kq39HkrL9uU5f93qPW
	/qit4lbBOZmaoSDYUu0jTRydpFhtPfIjCEGbcl8+pj5IwtVsJXAFf9sWGGB0Q7QNFjt34+5mqZL
	ZtUOFdh05lKmIsjfOBWvIFJtq5P93aM+qdX8c9ujAAS2zt9kWeGmzgagt8gOlrKrrTF4bC88aK3
	LGoYIc1kIbo06jfkWZFi38Yab7CtgYLdw9nOnLBI8y53j6+kQHQ8Uz7KEPrNhRUCk7RALHXHeXP
	9TCV5LNmhc+kPqMn0ylfp7UFGKAQSCmd51Ii9RaK/Y02MDNflA==
X-Received: by 2002:a5d:588f:0:b0:439:b8b2:fabc with SMTP id
 ffacd0b85a97d-43b9e99a4c5mr6367455f8f.21.1774635694352; Fri, 27 Mar 2026
 11:21:34 -0700 (PDT)
MIME-Version: 1.0
References: <20260322061038.156146-1-liwang@redhat.com> <20260322061038.156146-2-liwang@redhat.com>
In-Reply-To: <20260322061038.156146-2-liwang@redhat.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 27 Mar 2026 14:21:23 -0400
X-Gm-Features: AQROBzC6_QXwgzEAdnMpmbOLSkY8-818jdTVCtG_0kiFBuwZJE_Ctmrxq0GGihs
Message-ID: <CAKEwX=OFj-etKFrz+wu0QYfUkVC+Q6sMUvQwcGRgtyuyJPSm3Q@mail.gmail.com>
Subject: Re: [PATCH v4 1/7] selftests/cgroup: skip test_zswap if zswap is
 globally disabled
To: Li Wang <liwang@redhat.com>
Cc: akpm@linux-foundation.org, yosry@kernel.org, yosryahmed@google.com, 
	hannes@cmpxchg.org, mhocko@kernel.org, mkoutny@suse.com, 
	muchun.song@linux.dev, tj@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, longman@redhat.com, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 3751E160003
X-Stat-Signature: 1abey8ybsab8x6cku71tr5mir36dteer
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774635695-559753
X-HE-Meta: U2FsdGVkX1/kQ9pXyqONyl1eeTILgxofpKly569PTDKA5cfWw4DWgas3MHKeq9MtkX/k2c1MHakc/wD8yHE9Oyhz14ptsLlePwUq0LCuNSui0fyja76TXkomD4szhYh1kFkTUIczju5yWstipLfylW36NW4IrGkJOrvni9F3EwkoJJcCzmhiJhX6iOOxEpYJ3+4g5cJDa7UOufheyyOrlsmhg3RS2XIOQ9QwdPJjDMUPc7QkKxQBIeRfnKNZ7HlL/qPd+6eM9kRVZQiggvy5KThzohuG6U2nPmwU1uQIdK3eVNK8xrid676YqLzT/yAgZIms+Ru/p1dVdmmUO3MqN7FkwhopXqaXAf/O6/qhFozpemw3DUbgyvVl6ADhT49CNLIwoax8Sg62/S1JTbMst1dYCgPe8LYwo/ndfXtO8P556dpZWWMjcwRudHs/XrhZC+wNIIfG4tgU8WX86Kg7Ouix2V0KUqFkpMVYPfXkAUHmqPEz1Mcj3REaNNHEKBvuwuAlnydHJ+QolKVIMG0Xr367tdn6/lBw8MkF22woO45iI51TSXR7SSHwYC3hE/jnC3HFwu/q0vyRodKIYyHU1Ac7mMkMayNlF7+kMIPupE3QGvpdoU+cvb3f85xKAfSnM0wdESHyzNV4DGLtaRSSzYITJN7DMNpHRG27B+CSJzFDsBbraRT8rxRLaovsUzV/feNKMpPZ2RFj2a/GZEBm+gs6cX+FzFMybl8YZwrgxbsz47HkjCy+e94rf5p88OtDRzM74PRXvHay/F9SKL+h/qqpCCqlF2VAVnMaz+QjdtTxdwLJlROkxORV98QuoTPrhENJB3GEtt+sEiVi71NppOJWhz8cPY8diEKPwifKkuVNwRj/nmm9gAyAWMmNgcnUJ74JFzK7AtLP5+Oxw0DUNfFp1fKjGVEVXw9rJaitxmgkJYcOcGHZ5yzOVPFVQ9+EEujWv3OhkmqVSBGW1rL
 oJjI0th8
 wSvEFseksjnwDQLBip3O9Y7RJOuk8Z4Sd0yyLVcReeZKXgLfdpqHzNT/bNuSU6KFqi69NDqY3123jmHLsE1va5WiQgY30QgaZcLD3+n7Fck5plgyuXgIzH/C0Bkqqr1LwGsn8X+HhlXuqUJ5vuYqk36Vz/afJo3Gm5f383Lvi1hPToEGzRzYzHBTssX5GHLcAvqWQKXZlavxi+2GpWGn6OdSXSCzpN/sG+TbALDZTNKuLuSQJ9pyNbJAfQPvyyl2Q+dCMFLKymXCVZha6D6YbewQA6SVi4K36X7Y5x8eQAWQT0gsVOmAQXPFfNScccK5BdqM516r7hLGzdycmGGwkJcQMIvwwW6h7Fn+sz+wSP1hVrJqgInM3SxLWEmax1EHQ6c5mSEr2C/5/0Z+EdT2a6HR8ICcHe+CRuv8rqOtu/5nXN+dQXGS8iHu4gQFUa95kQQOymU1Kb60pd4ao6DzKvQ3CqJKnl4r2Y+AQIP/uPG3X/RZeSDOLfRkG7QPhPhmmHHiW4+qKi8tfDkD+zpyOAxN+le1cr7orC+DZCgpmRf/iYMu/Kt5+YDvjF1J4Kzm/OR3rC10LGoumT1oqxRvKPEwCJFg/tZeX6kGxArxJk4f3ZoMk8/B7uclkzYa6tUboRHCFtOZILYL23KwjFJ+OxMilvc7hCWKv9FY0txMkj9D82/rjDTkX5VIhKUTZMe+2nExvKNsaY6lD0QJokaY+REt+yOicjF0Z7w/a8P5JS/1r3kKoSkkZLZZvqg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Mar 22, 2026 at 2:11=E2=80=AFAM Li Wang <liwang@redhat.com> wrote:
>
> test_zswap currently only checks whether zswap is present by testing
> /sys/module/zswap. This misses the runtime global state exposed in
> /sys/module/zswap/parameters/enabled.
>
> When zswap is built/loaded but globally disabled, the zswap cgroup
> selftests run in an invalid environment and may fail spuriously.
>
> Check the runtime enabled state before running the tests:
>   - skip if zswap is not configured,
>   - fail if the enabled knob cannot be read,
>   - skip if zswap is globally disabled.
>
> Also print a hint in the skip message on how to enable zswap.
>
> Signed-off-by: Li Wang <liwang@redhat.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Michal Koutn=C3=BD <mkoutny@suse.com>
> Cc: Muchun Song <muchun.song@linux.dev>
> Cc: Nhat Pham <nphamcs@gmail.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Roman Gushchin <roman.gushchin@linux.dev>
> Cc: Shakeel Butt <shakeel.butt@linux.dev>
> Cc: Yosry Ahmed <yosryahmed@google.com>
> Acked-by: Yosry Ahmed <yosry@kernel.org>
> ---
>
> Notes:
>     v4:
>          - No changes.
>
>     v3:
>          - Replace tri-state zswap_enabled() with check_zswap_enabled() f=
or clearer flow.
>          - Move skip/fail decisions into the helper instead of branching =
in main().
>          - Make read failure reporting more explicit by naming
>            `/sys/module/zswap/parameters/enabled`.
>          - Keep skip hint for enabling zswap:
>            `echo 1 > /sys/module/zswap/parameters/enabled`.
>
>      v2:
>          - remove enable/disable_zswap functions
>          - skip the test if zswap is not enabled
>          - reporting fail when zswap_enabled return -1
>
>  tools/testing/selftests/cgroup/test_zswap.c | 19 +++++++++++++++----
>  1 file changed, 15 insertions(+), 4 deletions(-)
>
> diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/=
selftests/cgroup/test_zswap.c
> index 64ebc3f3f203..e69d845d3592 100644
> --- a/tools/testing/selftests/cgroup/test_zswap.c
> +++ b/tools/testing/selftests/cgroup/test_zswap.c
> @@ -589,9 +589,21 @@ struct zswap_test {
>  };
>  #undef T
>
> -static bool zswap_configured(void)
> +static void check_zswap_enabled(void)
>  {
> -       return access("/sys/module/zswap", F_OK) =3D=3D 0;
> +       char value[2];
> +
> +       if (access("/sys/module/zswap", F_OK))
> +               ksft_exit_skip("zswap isn't configured\n");
> +
> +       if (read_text("/sys/module/zswap/parameters/enabled", value,
> +                                               sizeof(value)) <=3D 0)
> +               ksft_exit_fail_msg("Failed to read "
> +                               "/sys/module/zswap/parameters/enabled\n")=
;
> +
> +       if (value[0] =3D=3D 'N')
> +               ksft_exit_skip("zswap is disabled (hint: echo 1 > "
> +                               "/sys/module/zswap/parameters/enabled)\n"=
);
>  }
>
>  int main(int argc, char **argv)
> @@ -604,8 +616,7 @@ int main(int argc, char **argv)
>         if (cg_find_unified_root(root, sizeof(root), NULL))
>                 ksft_exit_skip("cgroup v2 isn't mounted\n");
>
> -       if (!zswap_configured())
> -               ksft_exit_skip("zswap isn't configured\n");
> +       check_zswap_enabled();
>
>         /*
>          * Check that memory controller is available:
> --
> 2.53.0
>

LGTM with Yosry's suggestion. If there's no other change you can also
submit a fixlet I guess?

With that:

Acked-by: Nhat Pham <nphamcs@gmail.com>

