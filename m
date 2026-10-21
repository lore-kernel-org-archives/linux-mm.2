Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 454FD606A320
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 21:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=iDAQ2JjN
Received: by kanga.kvack.org (Postfix)
	id 65EA66B025B; Wed, 21 Oct 2026 17:27:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60F786B025F; Wed, 21 Oct 2026 17:27:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 525856B0261; Wed, 21 Oct 2026 17:27:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2B2CC6B025B
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 17:27:43 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B44701206C3
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 21:27:42 +0000 (UTC)
X-FDA: 85347920364.17.5383309
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by imf17.hostedemail.com (Postfix) with ESMTP id D070440007
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 21:27:40 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=iDAQ2JjN;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of 3Sy7ZagoKCGoRbPWcOPbWVOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--jthoughton.bounces.google.com designates 209.85.215.200 as permitted sender) smtp.mailfrom=3Sy7ZagoKCGoRbPWcOPbWVOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--jthoughton.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792618060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4wmdHTAA1AuKVW6+MMratQ3OvnpQ7OBK1Rv6piTCmyQ=;
	b=dWfb8lT0RBvWNyNToT3IhqBny5BrQk99Wc11dwuhcgen1b4FITij2bxlz5XWNUY3IdQ/OB
	C5V+73HfqPZHYM7VqWJdRXxCGg+Ct2dMsXbfWkrnHArys/GNEc0b7PHsBsm7/ykUSNMC7k
	v5Po/xt/JEkYLMR/aoEu8dRlFYUfj8Q=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=iDAQ2JjN;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of 3Sy7ZagoKCGoRbPWcOPbWVOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--jthoughton.bounces.google.com designates 209.85.215.200 as permitted sender) smtp.mailfrom=3Sy7ZagoKCGoRbPWcOPbWVOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--jthoughton.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792618060;
	b=okQmGqnPmV3b4P2jqCvIHJMoOMu0/T7eyldLnNzVFvijj1V9LGCCiOUnn5NDF8nN4l0O0v
	GrnulYj2UYEUo1uJ6CZ1iN4Ud9N87HU0DXpwFNoa8BTMm6cYaygy+aQbwtxm/Ykh0Y6mkh
	tDEnzJLOvEsWz/8vQtn7Plduv0NlizA=
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cc7e0321ec1so1146530a12.0
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 14:27:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792618059; x=1793222859; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=4wmdHTAA1AuKVW6+MMratQ3OvnpQ7OBK1Rv6piTCmyQ=;
        b=iDAQ2JjNBXQu7hsvL5n5BVMfkr8I2/j4x0HeM/LnB6iZuHMVT9LJ+I6IUJ2dP/0JIB
         3uhB/fIR90Cz07xz1xVG+DfpVTETE31naXFct5nS2Qua2MMkDfcOB+sS7fKA9LerUlt8
         cJRQVEoJMG9VhETJ91I1XdQYb/KrdQ6ITF13ou/ubl4UInnhusd1m7HsnWjE1ZuI47BU
         t1A4zkEMO5N/3+QLcxa+Tpah7SouwxxC+phy/E1G0py+lVelxVdfO1fHi/Z7T3tQtUEB
         qDHynX0yoEIlhZ7yL0ZEn3yLDtWw8I93TbqCJo62gzY8zYaH8EqdQLIXNMRWo4wn7Rnz
         6hrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792618059; x=1793222859;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4wmdHTAA1AuKVW6+MMratQ3OvnpQ7OBK1Rv6piTCmyQ=;
        b=waha3LgQPVkdhQog7SyXowky103uslHpu8xTxq0FneEBzEKDwg/Wyr82BvBElE3Bw8
         4u1rGCPeYv2SZLMcs8wcGlmQMyhoWxontO7rSYSgCRBTl/tsW5go5kRQmqiQHOO8Z9ME
         P9V8efC2ZDX8A7UIkCmAQ9JUdLQIkaFZuyiomtqtb2b1K+76kjRFoqs2KI7rPCew+USd
         9cCfomOdWVVBUYllDr1gF//lZBtmC76PpJStc21xdNsCUi13x3+tYRWtHW2GOdT5LHdt
         QH/EBFDGgPmkoVEihUcq5EBGbxS/hb4UhwjNr07p2NS16vdLsr3WFEzp+oDCGr6RLVZL
         36qg==
X-Forwarded-Encrypted: i=1; AKwUvBwidwzf0QALZMkw/TEQxktNrFqzVcHRd7uzYlSWhfxNz9dMZa1nrnr7v0vDYPWw0ZXqkxL6cLu5+Q==@kvack.org
X-Gm-Message-State: AFq9FYLbxD6Ii20imwsT3IATTFpesGbqYujYt959k3WfXmsdL8J5yPiN
	XmSxCNVi9VHYVwNDv1VusVe9trrMl533VNhciqHIO3BCZEwMqkIktTFfUZR4HyMxDghy1Po/mXe
	zoDiZ7fs2X1Wpq5f3P3+KWQ==
X-Received: from pjboj12.prod.google.com ([2002:a17:90b:4d8c:b0:3a8:645b:da8e])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:35c7:b0:3ab:e588:c29b with SMTP id 98e67ed59e1d1-3ad86dcac60mr3082798a91.5.1792618059129;
 Wed, 21 Oct 2026 14:27:39 -0700 (PDT)
Date: Wed, 21 Oct 2026 21:27:37 +0000
In-Reply-To: <491B482A-8177-447A-8CDB-AF83C13A5DEE@linux.dev>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <491B482A-8177-447A-8CDB-AF83C13A5DEE@linux.dev>
X-Mailer: git-send-email 2.56.0.307.g5fe7bd680c-goog
Message-ID: <20261021212738.321547-1-jthoughton@google.com>
Subject: Re: [PATCH v2 01/20] hugetlb: Don't restore vmemmap of non-HVOed
 folios on bulk restore error
From: James Houghton <jthoughton@google.com>
To: muchun.song@linux.dev
Cc: akpm@linux-foundation.org, catalin.marinas@arm.com, david@kernel.org, 
	fvdl@google.com, jthoughton@google.com, linu.cherian@arm.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, mark.rutland@arm.com, nikos.nikoleris@arm.com, 
	osalvador@suse.de, rientjes@google.com, ryan.roberts@arm.com, 
	sunnanyong@huawei.com, will@kernel.org, yuzhao@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: D070440007
X-Stat-Signature: mynryn3q6si5nhw1z3o1hq11z5gccmq6
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-21.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792618060-983859
X-HE-Meta: U2FsdGVkX19v/xrp54/HPz16jz8C98udAXiYy9ANEOLW7DHOpLDqymVF8ZjTaabc2vP1bpT4yInNT+OitudDMfDk6ace2T/z2j6Syw5Ak8wEBNmNDtGpc9YPB3N7CiIVqFCMABFKmLZxlJtS9KPhI8sIWLpsDAMnZ89FRLHBw6xDqPL2W3aH2cRHvbDqvO8/VMiZxsNoRb3/8UoiLkNY+/I97Ry97WlyOjbulVx2Y8x2N6yBKO9gHivbIi6/pX/QxhKg71UUrtXSVn7LBc1cG9luSP/t6+l4etrOQ50JZNu7/CwG2tFlN2oecJEBVKGy8dwsiQ/s/F0llNy+yTgR5cuYzkqjr69F6lWsTOkImanfsk/aSC08LOagbF9cbFtVwN6t6x04AdEwC1D0E/XrfRhxx07wukuOUgOKLz/DlwLZP0OuGgUvdKsF6h9xd6ozKL2MyqtFKBbZSALPUXDkHQqIibnfE/Uj8LHVhiu21c+cqZyXdrIs9euPWqBZOt9KtJBPxtND+lHZjLmCmtCN1gxtT6uqgVh8nZXMHkm0Ky5gw7mwuB3k8kAMImmV6piboLc6GCSV0zEouIn3txX191fNEFQuZ3vTcoxWZ4UI+cWkwN5UhzGVI30f6M9zD9wRV4OkV5zFuttLVomYKl6U5Abr2H1O17xynFq7wS1WkIuvu/PVr8w5wTHlyb0S7v56AEo5IHz9JnndciEqs45NNnJCIQ8Uexul5UGzve9jX6TG55uKlw4DAHV5ZpJZ++YRt1oJw8i10JIp355UaVa4vw6hdyXcHS4rEcUFr746gxHEAQPPL59BXHgsi2Vgv/m+/w7tgZOoZz5GH+GEYYzKNXuv29Wv9MzGmcpsDWwnceMOWXrfolduWyAxJkR2PiIEfmLdzEcHlMsVapj7bwGXaQSzHL1oKNj/R+MIwy6Uesqr7NMAuk6Ck7l3gE3MSBFf81MpSabzU37iUTq5vdj
 2KPViYkR
 lkL/R8bJupllkfm0AgsZC/97jdAg8SGEuWz2aljiec/Brntn6hA4ZxtXdRzej1ko3D5M/GK2HYU8NtU7arsaijfgIgxPVAOoodrdODPd/634sZWIJadHyauX3osebnqQmDaeXO16gNXuLg6KQACYzqnexnfC9/KP8Nue0vcCILAgBxG+Oe3OJoUKbtxiW15AoLNjlhYqwacS7ttKk2OFlla7+1MHGDokPrPHYO3bh842Lw99duZzlgN++hp3rSqrRdtNxKTKYubmNkMfAEKIJcXoGDLQWDYe6itIQS5XMZXG9NxuPc8do4Xvd/d/zbt4J9Jj65A6Llw1xjpXuK/P4w75fWcPQFisvACX1nq0Lw6zXHT0601Q9oiPNQUntO/giYxZ7hFaDw3CXrx0T9Wm5NEmbYr+W2JsqeSckZR73S1UWLwnBsOm+ii4v4IaPdAESTz7YYn1HUprjjcaUMpnbvTjaM1rj8nG5iw+Ul+8cGaNzcMzDBmz8lCT93Bs76wf0mXuFpolLvleieq6+uhgQuILQk/C7CW5WSRh+/7H1sLGST2I2ySd/DXuX92O9bras2aNQmHddyrO+7Kr/mG49qZuDWDBFVmBPLVpUTudl4IBoi1A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 21, 2026 at 2:33=E2=80=AFAM Muchun Song <muchun.song@linux.dev>=
 wrote:
> > On Oct 3, 2026, at 08:21, James Houghton <jthoughton@google.com> wrote:
> > diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> > index a1b51251103b..4dac7ed1df57 100644
> > --- a/mm/hugetlb.c
> > +++ b/mm/hugetlb.c
> > @@ -1613,9 +1613,14 @@ static void bulk_vmemmap_restore_error(struct hs=
tate *h,
> >               * page is made a surplus page and removed from the list.
> >               * If are able to restore vmemmap and free one hugetlb pag=
e, we
> >               * quit processing the list to retry the bulk operation.
> > +             *
> > +             * Folios whose vmemmap was never optimized (e.g. because =
HVO
> > +             * failed when they were allocated) can be freed right awa=
y;
> > +             * remove_hugetlb_folio() has already cleared their hugetl=
b flag.
>
> Since you mentioned the hugetlb flag is cleared. So it's unnecessary to c=
lear it again.
>
> >               */
> >               list_for_each_entry_safe(folio, t_folio, folio_list, lru)
> > -                     if (hugetlb_vmemmap_restore_folio(h, folio)) {
> > +                     if (folio_test_hugetlb_vmemmap_optimized(folio) &=
&
> > +                         hugetlb_vmemmap_restore_folio(h, folio)) {
> >                               list_del(&folio->lru);
> >                               spin_lock_irq(&hugetlb_lock);
> >                               add_hugetlb_folio(h, folio, true);
>
> Something like following:
>
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 6a011b627986..1ab3e61f4704 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -1616,21 +1616,31 @@ static void bulk_vmemmap_restore_error(struct hst=
ate *h,
>                  * If are able to restore vmemmap and free one hugetlb pa=
ge, we
>                  * quit processing the list to retry the bulk operation.
>                  */
> -               list_for_each_entry_safe(folio, t_folio, folio_list, lru)
> -                       if (hugetlb_vmemmap_restore_folio(h, folio)) {
> -                               list_del(&folio->lru);
> +               list_for_each_entry_safe(folio, t_folio, folio_list, lru)=
 {
> +                       list_del(&folio->lru);
> +
> +                       /*
> +                        * remove_hugetlb_folio() already cleared the hug=
etlb flag
> +                        * for folios whose vmemmap was not optimized, so=
 they can
> +                        * be freed without restoring vmemmap.
> +                        */
> +                       if (folio_test_hugetlb(folio) &&
> +                           hugetlb_vmemmap_restore_folio(h, folio)) {
>                                 spin_lock_irq(&hugetlb_lock);
>                                 add_hugetlb_folio(h, folio, true);
>                                 spin_unlock_irq(&hugetlb_lock);
> -                       } else {
> -                               list_del(&folio->lru);
> +                               continue;
> +                       }
> +
> +                       if (folio_test_hugetlb(folio)) {
>                                 spin_lock_irq(&hugetlb_lock);
>                                 __folio_clear_hugetlb(folio);
>                                 spin_unlock_irq(&hugetlb_lock);
> -                               update_and_free_hugetlb_folio(h, folio, f=
alse);
> -                               cond_resched();
> -                               break;
>                         }
> +                       update_and_free_hugetlb_folio(h, folio, false);
> +                       cond_resched();
> +                       break;
> +               }
>         }
>  }

Thanks, Muchun. :) I think it's slightly easier to read without the second
folio_test_hugetlb(), like this:

	list_for_each_entry_safe(folio, t_folio, folio_list, lru) {
		list_del(&folio->lru);
		/*
		 * remove_hugetlb_folio() already cleared the hugetlb flag
		 * for folios whose vmemmap was not optimized, so they can
		 * be freed without restoring vmemmap.
		 */
		if (folio_test_hugetlb(folio)) {
			if (hugetlb_vmemmap_restore_folio(h, folio)) {
				spin_lock_irq(&hugetlb_lock);
				add_hugetlb_folio(h, folio, true);
				spin_unlock_irq(&hugetlb_lock);
				continue;
			}
			spin_lock_irq(&hugetlb_lock);
			__folio_clear_hugetlb(folio);
			spin_unlock_irq(&hugetlb_lock);
		}
		update_and_free_hugetlb_folio(h, folio, false);
		cond_resched();
		break;
	}

Applied this in the v3.

