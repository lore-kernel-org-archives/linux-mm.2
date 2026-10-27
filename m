Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE430606A331
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 09:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=tACtqenh
Received: by kanga.kvack.org (Postfix)
	id 004546B05C6; Tue, 27 Oct 2026 05:39:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF73A6B065F; Tue, 27 Oct 2026 05:39:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0D3B6B0661; Tue, 27 Oct 2026 05:39:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BACCB6B05C6
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 05:39:28 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 501058093C
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:39:28 +0000 (UTC)
X-FDA: 85367908416.17.FF0D2D1
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf02.hostedemail.com (Postfix) with ESMTP id 56A1A80004
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:39:26 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=tACtqenh;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf02.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793093966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FvxARh4T9tI5kdcX4Gm7kudKWLQhzFK8eZWFYxwcQV4=;
	b=CkoRedJqsrQr/8/aFWIW7Xyho4l0QxPoLpOSphtS8GfSalyoazLfHI7CVlb6w/045ccGiJ
	+L6QGoLjjFJJ2Mb9RpfKKz//ARVIEMd9E1DeEyP5unqECdC+pVfZbmylCPt+AcOOzydx7d
	T4R0V2jl7gg9It7vE9M5/fOG4+SLMLw=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=tACtqenh;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf02.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793093966;
	b=moPwpdOEZvqOd1afwceql6GeboNo/+oVjdki2sY3hI/0KCf0lT6Q8y1WLTpcAiBwCTqara
	Bwgp+Gycib2PcJzQ7O8DwrBaFK1MU1rXHcuudOY7+tX4l0me1lfYPYT07zPU8IYZs+erb9
	V/yNJi5kWO56JNIbJI7HNCVTgMH6rK8=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4a215e64962so30695085e9.1
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 02:39:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793093965; cv=none;
        d=google.com; s=arc-20260327;
        b=JMHvCf14N7Nz7PQZvqhkH3+fWuOMzvuBlfgQMKB2c2CgVsuAk/NL7E9a3OW66Zxb0J
         4k9w0EoT/2BB1qnIy7gz0ps7GFuviad1DXsHOT1JtjR2zEwfJ0rMzNyAOs7LrCHP5VcE
         eo1LQMf4/O/QmW+igO2am4/g9GfGQIex+DOsYF4G/lk5mIAjXn4z8A7oPUmsSJiTgUAp
         kCIJjOM3VwqJZE+W3hbLNhJSJ1EQwcVbkVKaT5AiaRlz8ewLHrCWNfXIwpVbl/kBH5/V
         p22IqOghgEYAN85SdDdvHY42HEiKx+SYMMLI/JeMqcs+UntJ7qMqhBFacdWystSSu26k
         TFaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=FvxARh4T9tI5kdcX4Gm7kudKWLQhzFK8eZWFYxwcQV4=;
        fh=koRDsovRpw12qr/eXqRFnULbbfZs4hMlJQ1dI440JvI=;
        b=bPwATpFbXV1Bb/C2j+jlXNvPYINSI+OQnRd+hbLvOlmyYu1mPsjECrG9lwsTnmP8Zh
         7Aj0IGo4EDY/YHUmgZDlq541QdM+1iMBYYaTCcbdC1d+JFw/MNkzhnwe+eEe4DKtv2Dx
         uFmkGV+rwF6dK20f/ljmc3ygz9uLeAIpo0r9pQZS/chykMU5zAJAvrw98/Bv6lJpkxbX
         UURfb04tHEjT7Z0g9fWnvJ3miyDZY1c7Ua7tpVaYfdqaw2nv2kXZ5A04ARL+foHqNi/5
         2OVnegh2OnIYshevDGKzJwPgghIIAqJPEACSz+mV+OEf9MfzoOceW87qvpJ26wn4Pfl0
         rx8g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793093965; x=1793698765; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FvxARh4T9tI5kdcX4Gm7kudKWLQhzFK8eZWFYxwcQV4=;
        b=tACtqenhbOooEVeNCDlARFzF27nhn0iO5fzCSqAvWtDjkGKUboaiTplnOGGCDzTR6+
         aV9kmBsURqPKGTBLoeVF3WFrO8iHfn4PS775sl62XJ5IlqsC7AS2faGecFQglbrcCTGC
         klvVx7+Ai1YlRL/d+8r7w+b1hXpDmvjTCMRrVIn1YwY8FaNamcd0RAbhXFKQv1XCQdq5
         jmjl1zQ2JWUicOqoy49fUEVresFDyuNqv+DjdKfTfJmz86NeqFjMENBylIK13+FdbbRP
         mw8wNGlNrwX+GkfbSzKS235YTvG+KxSYwWxf1kzXR4JL/GZ+Qk3lXup95bSfMlvg79eU
         1UjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793093965; x=1793698765;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FvxARh4T9tI5kdcX4Gm7kudKWLQhzFK8eZWFYxwcQV4=;
        b=otw7v2mUizeDFzYG/oIFUF5tMDHiebBUlu03sUKQum8psRy/n0ceyaax35albOyOTq
         orXKm+vMPSEn1lhTYRtMJL8LkwcXOqtraiQpT0o3I+1PtRkvlUaIX/4b+VsTeiebV6pu
         pvi8k+gxkcKHlewaExTNlefBRY/e2YWIqKsnmyJrl5bTgP6fwVP7iXhfCqreqK9FXvlH
         DxDhHuCff7DE8bxfkHi4CueYHleWKOWfd5NaPWcBkGWoUrgoDa/lOM7dWo3kxg9DF92j
         VWgxMmj0rgf9WXZJPuFeitOKXCN8aXuXbOpEdIl+Ysq4Mq4ojFjsrZ2fmmJ7iogd/Zya
         ejoQ==
X-Forwarded-Encrypted: i=1; AKwUvBy/Xvaj/x0WYQ3ouHzLu5cVqvJqiK1Uc4PuKwS9+33QJO85NxSPDGdixJ+TqRJd+7r/mU/D6rHARA==@kvack.org
X-Gm-Message-State: AFq9FYKlYpO2o3E20tHhWQS+GhW9xleJVgyg/nsDt31GJ9aKJKrNoIJy
	uEZMESABKKZa6ZGa70L+08wl/EZ9Oif0JM2a3VwlXa3pBr/J2ipxIjtg3IeosP0p4au00d/oUGA
	uY08cr78GzCmF+lvrX7CRrNeqbMsgfIA=
X-Gm-Gg: AYBFou3VMEzF0TiePpvg+g4RkBXeoYBJnLMsmWe+fBfrfoQRPKdPJL0AH9V3efXxxCd
	jiG265OxytHEyVmr/8BFbxluL2gdLSSTtvfLqkxhiVfH0iEyzEayV7xsU/MQm7STmfjrJaPu765
	jtKqUopVOzdL3LvMB1sIPQSV0ayeCZfi5o0Q2q07N2Cde6glzpSn+ntlKFscNPqG6k+tU18rodT
	TtUF708k+dwekNKpXenvrRsP0mg4BPG3e+kS/17PnkNqxZ936iB040WjY5js99QREur4w4krxE0
	SvHspxdONtYW17u+0MtryUvGcEcX6YlnZHII5K6neRzQ8umCghH5eJu76RfOqSRah+RtLH4z6yA
	V5wnCLmh5ed2NslQ2Y1+HLyDXco6vVicg/8fIqovkUooSxdj2mmjtgAK0GTb/F316ceLY
X-Received: by 2002:a05:600c:1d01:b0:4a1:ac66:6ac6 with SMTP id
 5b1f17b1804b1-4a35acafdf5mr158312525e9.26.1793093964471; Tue, 27 Oct 2026
 02:39:24 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261022220203.91911-1-baohua@kernel.org> <20261022220203.91911-3-baohua@kernel.org>
In-Reply-To: <20261022220203.91911-3-baohua@kernel.org>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Tue, 27 Oct 2026 17:39:13 +0800
X-Gm-Features: AclHuK8LQwtQnfDOAed72citROdISwJfQPWQCA3Tq3i-D2KJ4BqJbqxJeh4RDU8
Message-ID: <CAN_Opa_s-xW27K81UAE-xHyRnPto52bZxnkPaGug+yhG76ArLg@mail.gmail.com>
Subject: Re: [RFC PATCH v5 02/14] mm/mglru: extract lruvec_populated_min_seq() helper
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, hui.zhu@linux.dev, 
	axelrasmussen@google.com, baolin.wang@linux.alibaba.com, david@kernel.org, 
	hannes@cmpxchg.org, linux-kernel@vger.kernel.org, ljs@kernel.org, 
	mhocko@kernel.org, qi.zheng@linux.dev, ryncsn@gmail.com, 
	shakeel.butt@linux.dev, weixugc@google.com, yuanchu@google.com, 
	zhuhui@kylinos.cn, baoquan.he@linux.dev, liuxiang.277@bytedance.com, 
	wangzicheng@honor.com, lianux.mm@gmail.com, kasong@tencent.com, 
	liam@infradead.org, surenb@google.com, mhocko@suse.com, rppt@kernel.org, 
	zhangbo56@xiaomi.com, lyugaofei@xiaomi.com, ridong.chen@linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 56A1A80004
X-Stat-Signature: t9maqy3mdti1scyc78pn391b5shxrobb
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793093966-937008
X-HE-Meta: U2FsdGVkX19T8xcUKtXt+l4k/sUhjSXMExvn/mwEUkKdNswM/GktDyyQKguBo9p4DwtZo9nnt3a+2RBmsqoOBVX9wbKQ9bKPkNL8emGgVzvYagcD404CUg9X6HOeZWeGYIgoPcjAFJ/LrX06WQInABsb6hElDfdCIyml1q498X3tXCj3s4GTZeZWoNLzZpH9NabbdRL2h79sf7SNwntiAOoLJA/5g8ZfYL2INh9WFIvFdyvNHGEdPzER9NeMFB7IkqfuP4ak5L7Zof6pnIAQS4fhD/t24WhhqaoPkP3uHZGZDtx6/aM0cskcZ3d2ulikacQxV5SwC5Fg5cBk8wYMSRziev0POPLlshk4b70AMTcS4aLver3ms6rQeGZkweLE/rFfEd04yXL6k3gMe4wS/NBuNGbl9jnvvdMSGZizOBm0SvO22kJ5ZRIXa5QeKDEaj8crCKifW372dwuzPGuqgqTDCGW3UVbIHzH3jR5hQ10R4TITHlyGcGWoudtm/e9Yz/neIxF/YlnK9e70+zhJnhu9p3m3Lt7bfcMmpD+Nd62zegHTCzCXTuQZ1C8f5IBt640711kpM0wD0G9QZSxkw15H1Bk/lOlwe/ot92AhYQKn9ESgHtblMhER17/i8k1h17gl01+x2HiKgQOBPAr03SRjRUIvP5EAbDIVfb1tKisdhxVoDQcYJD1URXcWH3NpAX0AnhLufSfv3MSULI26bNqfiFzUL4ym+vLA/PnDU81kG2E3SQ+6knZhcgx5Ff030mQgRxIxjeardHUOSyeBW9PePER2ZxcXlR5noIiDP0+bHg7ng/4iD2wVJp92sAHvARz3sJLc+qnViYm50HCx212HN1p5SbYyxn3d80b1wvcnIUPIxNrSBShuknaBomDBxE9wAtFWJwuIuqOhHFEXFRkOl5TpRasuaQf3dlRGgOJt96HdrYX8VZrhIKk0ipc0wRkY5WZMsM249FWv2j3
 E+6P3zs+
 n3EiNaFvwSLqqIGoI8aAbQObtM53LTogtGrdo0G9UJVDC75Ejleg3FRl6cWfby4MsvClq37IhjDo/Rrdc7PUvhtVEjRvsTJOthtA5jjn3BeguEnx2OVGuvJOlbD3RaBLqHw9tp2t53i7S9zfwKGSc89FSlbdjyueq37aJ87TX8KeIKylbb75Z0ZvFpS8gET5snSTEGGNqVnioYxgqKBTHPhYkbzpaly3lVSPPxaMpXMRP8MkFLS0UatubtziGzsGOL/REMOEbDqDYTgxaxNMreftnDoSbLrbaxFoCslurkfY2Mc0GU7eWU2CoaLTul3zdznLXQq26/7soCwrkXInfYqfS/EAXdWSAq2QXvesAsBTeMExaFvgrxoSel7ivJQ83eHE31cCxhvxTouJrsYSCGDTdDixXdDwocuQkXqH2fu/aBoTBwRfesgAaUUqYsyxzk1uk3C4corYZtcf4bAKumBHTpzHiWntAFAhMDcQYX9KarAo9hTgQC+K2IrNb8ka3o6LoOoRaH3GwKNxGpoVEK6t5ANxrl7hDkif6djrESsv9W43yfio/xSn+6WpUAr/3IY0UeFj7PRgVCDxt26LzLdzUzw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 23, 2026 at 6:02=E2=80=AFAM Barry Song (Xiaomi) <baohua@kernel.=
org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> The search for the oldest populated generation of a type, previously
> embedded in try_to_inc_min_seq(), is extracted into the new
> lruvec_populated_min_seq() helper. It returns the oldest populated seq
> of a given type, bounded by the given max_seq so the search never goes
> beyond it.
>
> No functional change.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---
>  mm/vmscan.c | 43 +++++++++++++++++++++++++++++--------------
>  1 file changed, 29 insertions(+), 14 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 3be0d6c04a82..500ef23949fd 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4131,30 +4131,45 @@ static bool inc_min_seq(struct lruvec *lruvec, in=
t type, int swappiness)
>         return true;
>  }
>
> +/* Similar to lruvec_evictable_size, return the oldest populated seq of =
the type */
> +static unsigned long lruvec_populated_min_seq(struct lruvec *lruvec, int=
 type,
> +                                             unsigned long max_seq)
> +{
> +       int gen, zone;
> +       unsigned long min_seq;
> +       struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
> +
> +       lockdep_assert_held(&lruvec->lru_lock);
> +
> +       min_seq =3D READ_ONCE(lrugen->min_seq[type]);
> +       while (min_seq <=3D max_seq) {
> +               gen =3D lru_gen_from_seq(min_seq);
> +               for (zone =3D 0; zone < MAX_NR_ZONES; zone++) {
> +                       if (!list_empty(&lrugen->folios[gen][type][zone])=
)
> +                               return min_seq;
> +               }
> +               min_seq++;
> +       }
> +
> +       return max_seq;
> +}
> +
>  static void try_to_inc_min_seq(struct lruvec *lruvec, int swappiness)
>  {
> -       int gen, type, zone;
> +       int type;
>         bool seq_inc_flag =3D false;
>         struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
>         DEFINE_MIN_SEQ(lruvec);
> +       unsigned long seq;
>
>         VM_WARN_ON_ONCE(!seq_is_valid(lruvec));
>
> -       /* find the oldest populated generation */
> +       /* Requires at least MIN_NR_GENS gens for basic functionality */
> +       seq =3D lrugen->max_seq - MIN_NR_GENS;
>         for_each_evictable_type(type, swappiness) {
> -               while (min_seq[type] + MIN_NR_GENS <=3D lrugen->max_seq) =
{
> -                       gen =3D lru_gen_from_seq(min_seq[type]);
> -
> -                       for (zone =3D 0; zone < MAX_NR_ZONES; zone++) {
> -                               if (!list_empty(&lrugen->folios[gen][type=
][zone]))
> -                                       goto next;
> -                       }
> -
> -                       min_seq[type]++;
> +               min_seq[type] =3D lruvec_populated_min_seq(lruvec, type, =
seq + 1);
> +               if (min_seq[type] > lrugen->min_seq[type])
>                         seq_inc_flag =3D true;
> -               }
> -next:
> -               ;
>         }
>
>         /*
> --
> 2.34.1
>

The helper preserves the original search result, including the
terminal sequence when no populated generation is found.

Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>

Thanks,
Kunwu

