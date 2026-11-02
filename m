Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0265560D3C8A
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ckVzeATP
Received: by kanga.kvack.org (Postfix)
	id 262826B062A; Mon,  2 Nov 2026 10:30:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23A516B062B; Mon,  2 Nov 2026 10:30:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 150776B062C; Mon,  2 Nov 2026 10:30:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E1D076B062A
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:29:59 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 879A1120159
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:29:59 +0000 (UTC)
X-FDA: 85390564518.20.B50E60F
Received: from mail-vs1-f46.google.com (mail-vs1-f46.google.com [209.85.217.46])
	by imf09.hostedemail.com (Postfix) with ESMTP id 96FF3140002
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:29:57 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ckVzeATP;
	spf=pass (imf09.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.217.46 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793633397;
	b=q1Cwbg/3Cof3L6JcgZyRR3iOv1KPcN+aADlKiho3G0PzhXKaElx3zFY9r/2ztqk/CSSTov
	lX9SroKXCNktGCFmAI994wPhFyBJNuFVC+PqAgQ/KvMkNWT4UUsdYF+eoDwEuU9OMufiqr
	TCk6wxoYAjaL/LNAjuHG/uCVjKcExRw=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ckVzeATP;
	spf=pass (imf09.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.217.46 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793633397;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P7oHHMkIM1swADUlplUIw0AliwJNApZ8BZBXp6ze1xc=;
	b=n0hzw58EKyil8cgo72S/7HF3p+eHqDWGBey+a9CiTH95Sp2HkRHLWwpK3XJOvV4753+t5O
	zZRCsWyHxOBiwmNRFAb1QPRorRdYGHEJJBWwTp/fzaPEdcfQ4iK/22koFcor+1O3AApm+r
	zXlQTpJfwcycT3ww3JVed6r8h0Mo3xE=
Received: by mail-vs1-f46.google.com with SMTP id ada2fe7eead31-78fb1fb9508so3547805137.1
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 07:29:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793633397; cv=none;
        d=google.com; s=arc-20260327;
        b=exmwB1UkBNKcgUov2AOBiWJKog9UzdtgziM6a6p3EAFCeL1RqSXK4QpkOHrqMEsQBi
         78Laao9WJraUUN+Mlf43is9npLGO8AHWEVqHd5qAgaeHaD6adzvrhM7j/RR0s+sEEDxl
         BbSXNu8NPwodrmn5okmRIg66AtAoQB84iQmHMepLq0KDRYmmoyUChByTz8FLuShLcz+k
         xl4JlDK7rlZHvpwewJ9ZJLEVjstVczeiie8ZmvoKn5QUaHAj3ln9+xfGvFfB7h9iEVeo
         8AO+30/IqrK92OSYqpug8o3QGYIQAmSA+xtjUDYtSq1FAQTy3auMGREWp1lbPO+sgpFk
         Qnlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=P7oHHMkIM1swADUlplUIw0AliwJNApZ8BZBXp6ze1xc=;
        fh=KfPbj3K0mT/tCN+Wskksu7An6Bc4mmvCzRB90CCyW3Q=;
        b=SIJrN5P/dL95XzSUHTLHBxzgi0rqAEFardaVJ0GJoa6KWNeCk39aYNvA/U+pR7qqjd
         MJjONpb1/wRKQQgJ6eZD7jsB2fEYNjQjt0tAfjpvwBK5VXR3soT4y5WwquTJAxcc4XPe
         XwUPdj6H9eOzpDBB0cxBjzg6UClEnzVg2m2+21m9VhIRBKUV1wLvYOzH03SA+D7+JtGp
         62wY1d2LlkkK1cxP+r3yD2jCWXmxS+uLPCwJtbhZhT3ywxjWgYh2mAlB+AsAyljKNO1O
         tYy6tSEVzHCC6u8QbJ4FkJcbiBio9di23bYaEbV6u1pKDgkd2AWhi2EzmsoX639SIKIC
         L7Ug==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793633397; x=1794238197; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=P7oHHMkIM1swADUlplUIw0AliwJNApZ8BZBXp6ze1xc=;
        b=ckVzeATPndApHHOnBvN6j8wpAmEaTc5omN/by8wQ7z3X852FyxQNDZyBABOh7OfpaW
         t4VAdHE/o+KLYgXZ1wCQXwJnIOpWoPU0R3t3n7RC6goMpQVBhdqnhn6w/TRazp0te5ad
         WhIPD/YFVGkwpj8OmWqNm9JkaSeUVhuLL9RuPK0f1vAJWmt24dWzsvTMQm23Feo9a7tF
         JGK2BQ3jfLd54RbwvYjNObVG6eK2IsiTKBA/pCTSah7oOldlCllQg8+yE7NO5HLtWwOV
         dKQJZvgQSvF/b8r3HwWBMzDntP/JB2t0ge23EDzH/6Thr8tnSI/wyhcPy2Trz4vfEOCl
         zaZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793633397; x=1794238197;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=P7oHHMkIM1swADUlplUIw0AliwJNApZ8BZBXp6ze1xc=;
        b=eJyXAKNsLgGFZ6gF1jbzK/idrKwyUFrbK6A+BwHyvopXx662J1qcknTSCyNtF8JSLd
         uuUja2YpXMJrIvtZ+zgN+XkZ6dumjPdWgUa39WWX4DZFuqgW1jqSXvvJYpiq56DWqFQr
         6lEXInXTceBs3am6fcATcNQowsqs1RzWkITr3lhDafIUn52dICcCpX9HN3NRItSZaZVY
         9/+7rLDOaWhqatSgOlqL2TyrY3DYLKEPm8jH7nHsCnJzJW9PZUC87HTXDQEOjADupjP2
         ZZ+dkZ3ML4Z6iL8vPL/OyP9trjGDmMKa6gMsBRoEiBLqLmzA4lQp0z8iye7I1Lm1vkzL
         qvgg==
X-Forwarded-Encrypted: i=1; AKwUvBxo/0JbzGqTFHntXqtaKITdrUfjkLUSmi0oMH/KYLrxZ4ZlCQoLQo5yuwOa4FKvUFXlPD5FUFYaIw==@kvack.org
X-Gm-Message-State: APuU4Z+3a5G58PPvWcUcEE2ch+89/XqTGvf9fltLSwFuDnQWvwkhqi+u
	qeSlSO8ZeTiG/3Jtg5/tpm8CLkviPR3hKDgW5G71UWvjFIOxMMa1Nf9K+Hc7YFfAe309tu16pjz
	ItCsb+W8J01cKfzRK+ApX/MvpkAmzQqc=
X-Gm-Gg: AYBFou0C43+9GXUTWBvUNxiZ+BBnNy0FOoEyDUhuHBDc/HspdKHEF//fO8y4Q2ux6/1
	51vxqxHaWiKKGZLkrZY1r2sRxCSq2020CyBr50VQw5N42qC28ehbaidJZq4gRQXP5BTHZFbQOND
	m+n0YZRdSiGvrOpi9uk4YOOs5tMfIKInW8iAaH3GKYRSkpySi5ka6MkiPiM/dF/5IsNMHZ7sCYE
	/Fvp63znlkjHOuNQJWiLuoG0Qh8JZ1DeIjWy9WIecwuDmH60FENvnmF/1lznWBGT9n5a2LRMgzY
	ivBBIj/2lzWioqE7Y71xIDefxJUeSWOz6jIxQizo0H8dnQwIl0odQNyvhJiIPtK82/8tuntAxJG
	OSpr9NMYkzwwi8vaeQ9IVx56vXAEEjxnXBe85aaiAeCxJL1rdg1enHn382BLX2jchBRf0znZAx1
	CXELA54b0e
X-Received: by 2002:a05:6102:5cc8:b0:7c3:874d:60bb with SMTP id
 ada2fe7eead31-7d072bc027emr2842138137.5.1793633396723; Mon, 02 Nov 2026
 07:29:56 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261030161234.1505367-1-gourry@gourry.net> <CAN+CAwN+OPMPpVdBA+XtQvFpDy+EOY2TAiusxMjYR+r0F+MPhw@mail.gmail.com>
 <20261030164303.02c5cce0521c3d6fd4ddf015@linux-foundation.org>
In-Reply-To: <20261030164303.02c5cce0521c3d6fd4ddf015@linux-foundation.org>
From: Joshua Hahn <joshua.hahnjy@gmail.com>
Date: Mon, 2 Nov 2026 10:29:45 -0500
X-Gm-Features: AclHuK-onw5mfffqhDCdUvG-akV0FfaPCDY7vf1GKDjU7CU-jXjuRXPuiw8F_m8
Message-ID: <CAN+CAwOSz7BuPyd+u8KOitbDNFiDa0iNv+oFnQwbbt6kUw21PA@mail.gmail.com>
Subject: Re: [PATCH v2] mm/mempolicy: recompute automatic interleave weights
 on memory hotplug
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Gregory Price (Meta)" <gourry@gourry.net>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com, david@kernel.org, ziy@nvidia.com, rakie.kim@sk.com, 
	ying.huang@linux.alibaba.com, harry@kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 96FF3140002
X-Stat-Signature: ut7ik8m7b786do5rmb6uexypy87stao9
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793633397-238407
X-HE-Meta: U2FsdGVkX19UekFY0Dn2qb4tZTRKFnyFWiEIFbR4w1N85qzS7opa3IrsLjEWWW7R1Ld+hCvLsL9C2DpHrs28eILdWTCvqLKe8mGzvhfq0bqTbABOQweqawPDpve1+PBZdy63Lhro3H1RiaCxlQ9AzwwhlFmdkWMgDTXUiCec1rg5iRY5qJjj7fXH3gL9LDDdf1C9brvrxz9Nl0gOpwiVgQZQMEeGyo98XAHFK1xrk+8eZRE39gp8FrOfYqhHTtJkCIrku5y2Z4ofJhqJtb0V1SjbWZCsbP+ce+1zzbsiJycexP0fS/62fet1UJsjSuf3f97FTtMX8epApcT2vayfqGN/6rAHBuGVyWVJmtNj70xu0O6D1nwTZ/Dzv3J7b0++hV9Z0A0gdsXZQYaAw5uj7zIkhOkdJN9mSs/w+EJ+8n4tcpTitLDNHO2g8oOi5fK/hXPoIgiumhK8xayIDbJAU1bVLdoVfHfUSUhKsLo/mTDZgpx0t6SImctfv4q8APbdN0iWoCjED1JFWk8qClsX4iJPWsI9PmJ+TLdohrGYmf8ZrdU8tH9R1lCo0XNxqztQsAzbGdCqghCasGjI4NCqjWilvDTsqBE3XN/iTS9jcgkxDaa76nGsEMaXYElMsp1kBXRnIEhawc/4zBIeilThqSl+DAFOlKnylwsoFBGgY+qCYtDhxi/BU6hU6IACLQ20rkPzsrE/enN+DiGtuW+TWRXY3YqtRm4cH1A/PUbPFJA8siDr3Pqe5IdNGyznxG5lpwx1K7tVfkXhw+7LKFUaTXmGkxhjvVde717pJg/Ns4MIOtfKqwFcjWtRz6jDq0lkIlTWvMAujLCqicMOHRyT0eFvse4v2ZujuwujeysMhCAH1sakGGvShz83U2CmXB7SeAfRFoAAr2IXVjx8viaOqAXAdvZ6gvT4I8qe5MxV7++XoKb8/NhNRv/gNnGyi6JYuFZ2HaO05NVi97/8kvB
 ryJjtuJh
 oFkbDnGhgs8ha8wnuI/I6wnGpH3Jq4KhWsgmFSkwGOZV+bap3kJv1Cv0xYOKEQ2IOcgRaKG2onRdkI2hG0/hRzKWmLCJRqyPqQMVGFPWldf4fz6HLWsIacS0+yB+5K9Y1xMk12vvnYK7G5nPjH2jjAUKmLL/HVzNVBolMujjMEDJjIJuvW7D6zaX6YT6RGLvxQyhKVXb2QHn280ckEkPEioD+o3DWdlVxiW4Dq+dZo/eSGo3KilFQOr2b/wgSa2e3Jdil7xUPGe7Z3WrWPFqwOl9Sqs2xU7wT7AIh3R0NmHDdcFojxpBE13SdLUcRJeBmmMBEnYl/yPkUfLxvXZvLcVB+DZO3OieueOhAf2SqBGwMgdH55nMP0aP3jUWQHJzbAX1Awz7+mfrhnsZ881B6fivEaf54iWX+PxgQI1YVyh0s6W9/+aE6uDbRGkTdqlJtcNbJ9Xvn/g8g0Z9E0HCytKinnJ8rD60hlBunt7ZCszaLZFoSskg5DOYH0zzqcYKi7Dv/T3Mjl6uUxlDQooODHPPFoKewcfQ+e6o8exNL0+MbOXGVJSP9ZrVyDwUx9QeVO91aB9DLnxWp0l8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 30, 2026 at 7:43=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Fri, 30 Oct 2026 12:35:38 -0400 Joshua Hahn <joshua.hahnjy@gmail.com> =
wrote:
>
> > On Fri, Oct 30, 2026 at 12:12=E2=80=AFPM Gregory Price (Meta) <gourry@g=
ourry.net> wrote:
> > >
> > > In auto mode, weighted interleave derives each node's weight from its
> > > bandwidth, reduced over the nodes in N_MEMORY. HMAT and CXL report a
> > > node's bandwidth once, when the node first gains memory, and nothing
> > > else on the hotplug path recomputes the weights.
> > >
> > > This can result in a major skew in distribution and overload tiers
> > > with more data than their respective bandwidth can support, resulting
> > > in a performance regression.
> >
> > ...
> >
> > I think you may have dropped my review tag from the previous
> > version!!! I believe the only thing that changes is the warn, so
> > please feel free to add:
> > Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
>
> Actually, quite a lot changed, so dropping the v1 tags seems
> appropriate.

Hi Andrew,
Ah, thank you for the catch. Looking through the code again, I think
it still looks good to me so my review tag should stil stay. I'll be
more careful about stuff like this in the future!

> v1->v2:
>
>  mm/mempolicy.c |   36 ++++++++++++++++++++++++++++--------
>  1 file changed, 28 insertions(+), 8 deletions(-)
>
> --- a/mm/mempolicy.c~mm-mempolicy-recompute-automatic-interleave-weights-=
on-memory-hotplug-v2
> +++ a/mm/mempolicy.c
> @@ -261,7 +261,11 @@ static int wi_state_refresh(void)
>         mutex_lock(&wi_state_lock);
>         old_wi_state =3D rcu_dereference_protected(wi_state,
>                                         lockdep_is_held(&wi_state_lock));
> -       /* NULL wi_state assumes auto=3Dtrue */
> +       /*
> +        * Hotplug events can arrive before any node reported its bandwid=
th,
> +        * leaving nothing to compute weights from. NULL wi_state assumes
> +        * auto=3Dtrue.
> +        */
>         if (!node_bw_table || (old_wi_state && !old_wi_state->mode_auto))=
 {
>                 mutex_unlock(&wi_state_lock);
>                 kfree(new_wi_state);
> @@ -302,6 +306,28 @@ int mempolicy_set_node_perf(unsigned int
>         return wi_state_refresh();
>  }
>
> +/*
> + * HMAT and CXL report a node's bandwidth only when it first gains memor=
y, so
> + * recompute the weights whenever N_MEMORY changes.
> + */
> +static int wi_state_node_notifier(struct notifier_block *nb,
> +                                 unsigned long action, void *data)
> +{
> +       struct node_notify *nn =3D data;
> +       int err;
> +
> +       if (action !=3D NODE_ADDED_FIRST_MEMORY &&
> +           action !=3D NODE_REMOVED_LAST_MEMORY)
> +               return NOTIFY_OK;
> +
> +       /* The hotplug is done, failing the notification would not undo i=
t */
> +       err =3D wi_state_refresh();
> +       if (err)
> +               pr_warn_once("failed to recompute weighted interleave wei=
ghts for node%d: %d\n",
> +                            nn->nid, err);
> +       return NOTIFY_OK;
> +}
> +
>  /**
>   * numa_nearest_node - Find nearest node by state
>   * @node: Node id to start the search
> @@ -3424,6 +3450,7 @@ void __init numa_policy_init(void)
>         if (do_set_mempolicy(MPOL_INTERLEAVE, 0, &interleave_nodes))
>                 pr_err("%s: interleaving failed\n", __func__);
>
> +       hotplug_node_notifier(wi_state_node_notifier, DEFAULT_CALLBACK_PR=
I);
>         check_numabalancing_enable();
>  }
>
> @@ -3910,15 +3937,8 @@ static int wi_node_notifier(struct notif
>         case NODE_REMOVED_LAST_MEMORY:
>                 sysfs_wi_node_delete(nid);
>                 break;
> -       default:
> -               return NOTIFY_OK;
>         }
>
> -       /*
> -        * HMAT and CXL report a node's bandwidth only when it first gain=
s
> -        * memory, so recompute the weights whenever N_MEMORY changes.
> -        */
> -       wi_state_refresh();
>         return NOTIFY_OK;
>  }
>
> _
>

