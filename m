Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C39B1105D991
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 01:43:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 209D96B0088; Tue,  7 Apr 2026 21:43:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BAC96B0089; Tue,  7 Apr 2026 21:43:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A9EE6B008A; Tue,  7 Apr 2026 21:43:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EC8CD6B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 21:43:05 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B5B3813BEFD
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 01:43:05 +0000 (UTC)
X-FDA: 84633690330.25.F901F43
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9CE2010000A
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 01:43:03 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nCARR3XQ;
	spf=pass (imf05.hostedemail.com: domain of huangzhaoyang@gmail.com designates 209.85.208.178 as permitted sender) smtp.mailfrom=huangzhaoyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nCARR3XQ;
	spf=pass (imf05.hostedemail.com: domain of huangzhaoyang@gmail.com designates 209.85.208.178 as permitted sender) smtp.mailfrom=huangzhaoyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775612583; a=rsa-sha256;
	cv=pass;
	b=p+UBMmOHyd769nQwTBDUVq62kBTMDflMuhmXYJP9eCsJcGm3GeVDAgahV96jzt7UJ6A0ug
	5xSdf+ETE7U3eXtyYxfucLws/EamFjlN/koL632FeJNKHLS1SjjrgDilssE4w5z8Vu3NJW
	qz9vw5fx0RuWMtv4+kW5cn5gj3Ab45A=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775612583;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fxC98xPrXRqEsWHoH58ww6cmTyYCIoJK/4CvumIFxvQ=;
	b=EQLNEKwdPHvjxjk1e94VNx748BxQ+Rn2Mkx5kDwRuliWMRhALzRk+5K637BEcBVHau8qkf
	9HScbHLD4hB/EBZIUEoy5bg+AftrglJOOrArsp9t/aeKjlK8eDfYRqVtqQUZf5X8P74nk4
	ICC/wZpYw+vXV+ea0+90eCfHqLUUG3M=
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-38e203fbe14so968351fa.0
        for <linux-mm@kvack.org>; Tue, 07 Apr 2026 18:43:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775612582; cv=none;
        d=google.com; s=arc-20240605;
        b=UG5sYDIZzi4EDxIcrRhVpsLYvfhX5arvmfyCPbPSIAulb6wj4GlyaSHGwjK0HEMJFX
         3oQ4FMwWBF+c9dqLXCAcPyrhnZmt+KpGORt3CGZEVaoT8YJTi38V7+WhWhlfrFGVcUE1
         UFpzqbTClVMRMPU72roqb15SOX3nRyMRvGHCAd/dJMnN9EYvKmlX2Ze1bqon0Npi1DMJ
         f6YGYBFdMYMcdg3R0RvCOTuA8Bjm+PKLQG69mkFa/mUs6+hnU3OVgeqC039tm9Mn10kv
         So3cApqqGwBt1tagjamYgGdMNx45vwGR54eYZFbVdeCEo5JwawjWbapWr4tuh6Titk4t
         86Fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=fxC98xPrXRqEsWHoH58ww6cmTyYCIoJK/4CvumIFxvQ=;
        fh=f/7+n2SX9FTLWe+VZ5foy0/J9ricVYMDAdVb/7ukwaQ=;
        b=JYlm7ti0Wv8nbQ922RcAwGECAadG30614z9+f7SSdESbc0d1VMBt6PrGhrSMldkV64
         cUud/lJX2kqSUwWHX/buVudaGQRfLRYozGgW+QCkyg0PwTPeUhqkoblDz3O/Ve46SRrh
         6QU4zLd8caVYNADVF7M7XP+Blwa2iTwPyC5wKjVluviMQ1kpEo97kvvokwVoqZwShX+1
         NnGmMGK4w5BxnHWr6RIGQIdljdybg8ERS1vVBEJDZUz72GHdkHhqCNp1Wt19UAo/AcXP
         o8v/GOrDL0AzG6WjgVR/q1ptmZJEz6rDQ6KFBcKNAR3/ZQKIJq5FD76j3oWiORHn5mnF
         ncFA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775612582; x=1776217382; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fxC98xPrXRqEsWHoH58ww6cmTyYCIoJK/4CvumIFxvQ=;
        b=nCARR3XQbBGl8hRGnJfXlGyidOh620JzuddeVoyF2c1UUPYP3iemioZ+sTneQSUZ/+
         b6QOyVgOd1yESKPzy9xJPuwjkYkHZ7kmMYoFs/FVu9MdLwmMOi2EeT07wa6VwT+TDFsO
         HcsYEV8bEOEQmsa/gRgwqIPABask19+t47YKckVAzYIaqVwr3oDISpczOMlWbEl7Akv1
         Q6RwoazhRfDlQAiqv2R2L3WThPdXBCTj5nE+BsGSDJltre0ZJZAu1der8UxDJUx4kH7C
         p9grQBTEBGkilckFId/bq1NyncGyRiQdu5e53AAMITaVe9VlEbyxANF7BIomt3r3GrVc
         9wyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775612582; x=1776217382;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fxC98xPrXRqEsWHoH58ww6cmTyYCIoJK/4CvumIFxvQ=;
        b=nI/guyi+IhYC6/GH20ycUGWe6b16VJa2+Klm6zy9lmLuUJfZgm3+fmyAO+bsEF7Ouo
         U1Hw7lGlt4qvjBVQzr690UYO1l7qQqMDW43i366ts6a9huj6qrbGtEA6dV4mREPbBaA1
         1peVwdTT25t/NhtiDpyCwDXkeGspCZn7ehbHSi+tEhlWPUXxa4+MsIBj87IlYhDESUxA
         YFCXmNR8qNcZtBo+jXjeXOE1aFvhd9NSH2DGwFBoSPjnn97Lw2Y2WPJFtTaKbwd4jpNN
         IOXaG+aFiSSXza4PcyguwDdtXGySu64A4iF8390h5Q5XJhwnyEbAqcQL9zuYyMd9Ugp5
         xRTA==
X-Forwarded-Encrypted: i=1; AJvYcCWYeOEJi/+RZhWCp0QzMPB+x+wpqYlAXss5z8PA4dpiVw98P/dT5xcb3RxSgCkrApeIgWstV9Smzw==@kvack.org
X-Gm-Message-State: AOJu0YzOsJKu8esKRivaPtOV5ksKHduqoV3pyG9KMi9C5BYZAROgppEU
	J4TZr3U9/lErOGGQVwFqv6Y4DZw9MNKqYu3VshKAfLTPBoIV0+uLmrttl4d8XS36OIbNGuDSQTN
	N0906NhtYEFPstX9ztof/amwWl4mRjrM=
X-Gm-Gg: AeBDievGLFjBjlm9+Py4NmXRRXNJag/6PS4zBpljU4DnPGI4FVaF4TNW3eQC7fg+YNd
	6B8QnNtomzfypRTn8ZMAKAuAWU9+rTiMu5B7SCI++MqTHXzeX48EOhf59cu60ShW0j7/EAUH3Rn
	lRIveHEBI50d5uYn1Xuf3Opb3ifqofS2NeUFd9d9xvvFuOGlHtA741JYQVg8uUFbcwD8J7vN0Db
	BaHI/YkMjMsC05aCbcPwauP+20GPF2jGSxJcoPD3ATJONlPuDUmm+rlXBa2mmJyRCnmFYlMQrh7
	dXqtvIwEyOhHIsyR5hk=
X-Received: by 2002:a2e:a541:0:b0:38d:f18c:a8d7 with SMTP id
 38308e7fff4ca-38df18cc92fmr20766261fa.1.1775612581370; Tue, 07 Apr 2026
 18:43:01 -0700 (PDT)
MIME-Version: 1.0
References: <20260318011558.1696310-1-zhaoyang.huang@unisoc.com> <CAMgjq7DWkURifMhR8HG4nZRz6=G+Pk7kz9OGdEuL=VvZ7vWDTw@mail.gmail.com>
In-Reply-To: <CAMgjq7DWkURifMhR8HG4nZRz6=G+Pk7kz9OGdEuL=VvZ7vWDTw@mail.gmail.com>
From: Zhaoyang Huang <huangzhaoyang@gmail.com>
Date: Wed, 8 Apr 2026 09:42:48 +0800
X-Gm-Features: AQROBzBUHg_Em7QzqowrnsecjX6CiRCG-Ek9DSeqq2r1soPC22myVEb7HMx0EOg
Message-ID: <CAGWkznGoZEukGhwV7JLdvWEmZHtv_Pu=tBSvsWdFMhNyqW+azA@mail.gmail.com>
Subject: Re: [PATCHv3] mm: remove '!root_reclaim' checking in should_abort_scan()
To: Kairui Song <ryncsn@gmail.com>
Cc: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Michal Hocko <mhocko@kernel.org>, "T . J . Mercier" <tjmercier@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, steve.kang@unisoc.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9CE2010000A
X-Stat-Signature: epo9wi4htuog8xdru5it8isazprgkozt
X-Rspam-User: 
X-HE-Tag: 1775612583-779577
X-HE-Meta: U2FsdGVkX191jO9u5wReGj3Hgv814vZVTMNyroeyPCffsX+5rPWZTZElU5XtrpGIGqSQFMEAD74iMj+xUCmAuCFlDpDdlyVOp24ybDUWdmiEQjeAZQ1Pd0PTS5m8fahXMBYFsAvvdjH16Pp8vvXHvSKt64U2xzIqOLxMLgXBQZ6mXfDUNTGJX7xjbB2RzNvrOjiCuNlnI4wjH3oB8oNVe396Xu/hccjpk/em4u0VX4VuZPr8LToGwgvI85qdDAMC3vQjWmgL6ZpOPp3nLFcHql68HXkt828iNJunUoRJ+eN5qLcWrOA5CCSTpfju/piaE80kutcRGQBtIOkzwyOu/bDBfG1DBPMbDB/iPmyODRxa89tGHEfK/Qai5kf4+sBC9mnvDb1rarHf4LAwuvVtC+b5tK6nGA814XY+6JqPHUyCaxljLGragtBJqNBosFypDw8uCfCEF+EwRNPPkX36kCDgUOXcW/AlySEMi9bnCrYHyukdeqEa7bxnHGJjEcamu7wUhkEmo7WRP3CvmA4lbrpw7kDZWeODy4dzq02rFayWdDwOvq7peR1zz7P2K/kVQ7+r9tMtD1BpEtm8CeGJ6TsARHQl+1px64Hbr6JmDQraus4ZPqnpcneFADcgP1l3fMEvv4vaIzvlzq8FXruk6Py1EpP5ZobnXBg78OQ1c2iYj7HB75YzHT+pkwHh1jdsCvTnlL3fgg3leGYG6rlqbKgYk4zVdaXwVpziLHhqlqOPUkKVtObawtTqfFUfuuVqUQT22I1oEu4wJoe5whQliXjsS5qkiKSVQQ1VI3jRo2kv+HMjLgtB0gf0fSoy0VUvYvZpGdy7+6WdQqzl3Gn+U5eawae4iCrixcZ9/AqvB/NQ238X6L9+az49UL14gwLcnXHtP8LxmPtUk4s5NmMEF9BwZhhM4XBE+/nF/lAKKvA4LBK3FM7j45Nrct85q+W8sR3loF+QtQl9NIHpRdU
 nmjqtioQ
 TT7GsTXutBM7mwaIjQ7ZzVthD8xoBJNShnruVrl4M1UmRtxMEBsx7XuLsdtV/hmlEec1/MBk0uiUIcUewtIsi9WiAWRqxkz3+E09l5wuzYI5BFmhpXHvt3dr6v0n4qxYBEY9mfsjaY67sXaRBYA7SQAgnW7vz9/l4TzbJC1+1JCD+Cwf2Ltkj3++BmJ1UcleDBPnP3Xs3f9MI9+4vgbbanzCGD1F/hurQN0yq9YEaRf19qY3x4anPqJ34AjAiw9JsZrfAPegq7AMUIVVHfU4seVtdqYzTc6OyL6oRk2FgzdHFyZOjc2oGAV0S9I9LaS36jnuOzdNYy7juNGLkPUtMLI8VujoI4H+sanrVH749sdLkVCv5RGz9h8zqDnPfHgLSRdEv5oaBrKkZ2YqTwU/sH+E4vgDSSJK/M7EKIjnuYl4FgsPcrf5U4IyUtoamiZW4m+TAK5FWIm38NnylEnD+fgWPWDADYo92MtNrFttGkVdZfVuwjZob3dSBP1mmQTyVlnbr+JDfO0gjw0uuZaqHwnW1xuxk9rmY12a7x3pKrFBldqUTsteSqHrNdO1c2+H2/5sZBOzOeAABgGE6vrgTVr51aflcQ7eGSvq6UTbEpE5Ny/I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 7, 2026 at 10:27=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Wed, Mar 18, 2026 at 9:17=E2=80=AFAM zhaoyang.huang
> <zhaoyang.huang@unisoc.com> wrote:
> >
> > From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> >
> > Android systems usually use memory.reclaim interface to implement user
> > space memory management which expects that the requested reclaim target
> > and actually reclaimed amount memory are not diverging by too much. Wit=
h
> > the current MGRLU implementation there is, however, no bail out when th=
e
> > reclaim target is reached and this could lead to an excessive reclaim
> > that scales with the reclaim hierarchy size.For example, we can get a
> > nr_reclaimed=3D394/nr_to_reclaim=3D32 proactive reclaim under a common =
1-N
> > cgroup hierarchy.
> > This defect arised from the goal of keeping fairness among memcgs that
> > is, for try_to_free_mem_cgroup_pages -> shrink_node_memcgs ->
> > shrink_lruvec -> lru_gen_shrink_lruvec -> try_to_shrink_lruvec, the
> > !root_reclaim(sc) check was there for reclaim fairness, which was
> > necessary before commit 'b82b530740b9' ("mm: vmscan: restore
> > incremental cgroup iteration") because the fairness depended on
> > attempted proportional reclaim from every memcg under the target
> > memcg. However after commit 'b82b530740b9' there is no longer a need
>
> Hi Zhaoyang,
>
> A nitpick here, this is triggering an error with checkpatch.pl:
> ./scripts/checkpatch.pl
> 0001-mm-remove-root_reclaim-checking-in-should_abort_scan.patch
> ERROR: Please use git commit description style 'commit <12+ chars of
> sha1> ("<title line>")' - ie: 'commit b82b530740b9 ("mm: vmscan:
> restore incremental cgroup iteration")'
> #23:
> under the target memcg.  However after commit b82b530740b9 there is no
Hi Kairui,

Thanks for heads up. It is weird that I got the result as Yes/Err/Err
by latest checkpatch.pl for the following three styles as <after
commit 'b82b530740b9' there / after commit b82b530740b9 there / after
'commit b82b530740b9' there>. Is it possible that the result depends
on the local environment?

> total: 1 errors, 0 warnings, 10 lines checked
>
> A lot of auto tools recognize that commit message format and print
> warning, Better to follow the rule unless necessary.
>
> > to visit every memcg to ensure fairness. Let's have try_to_shrink_lruve=
c
> > bail out when the nr_reclaimed achieved.
> >
> > Suggested-by: T.J.Mercier <tjmercier@google.com>
> > Reviewed-by: T.J.Mercier <tjmercier@google.com>
> > Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> > ---
> > Patchv2,v3: update commit message
> > ---
> > ---
> >  mm/vmscan.c | 4 ----
> >  1 file changed, 4 deletions(-)
> >
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 0fc9373e8251..10f1e7d716ca 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -4839,10 +4839,6 @@ static bool should_abort_scan(struct lruvec *lru=
vec, struct scan_control *sc)
> >         int i;
> >         enum zone_watermarks mark;
> >
> > -       /* don't abort memcg reclaim to ensure fairness */
> > -       if (!root_reclaim(sc))
> > -               return false;
> > -
>
> Makes sense to me combined with b82b530740b9. I've been testing on top
> of your commit and it seems all good:
>
> Reviewed-by: Kairui Song <kasong@tencent.com>

