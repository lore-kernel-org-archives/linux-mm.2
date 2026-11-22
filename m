Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E08DA606A320
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 04:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=cq76QhQA
Received: by kanga.kvack.org (Postfix)
	id 080036B00EF; Sat, 21 Nov 2026 23:05:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 030BE6B05B0; Sat, 21 Nov 2026 23:05:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E64356B05B1; Sat, 21 Nov 2026 23:05:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BD2D86B00EF
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 23:05:09 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 57069A82A8
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 04:05:09 +0000 (UTC)
X-FDA: 85461414738.19.0A88BB2
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf01.hostedemail.com (Postfix) with ESMTP id 575C740004
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 04:05:07 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=cq76QhQA;
	spf=pass (imf01.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795320307;
	b=JzlfwE2kuApp+nULTP+8YB7NrmSbuz0/XvESmIAJ0qTgI8rj4Wwm/Nh/RDyIQY5cLKKW+2
	psOVEVp/x7blrIT8g1Ydr6/GlMuBzA2Um28kcWZRgJz0fKmeMtbtoLD/3meKf6encYV3MJ
	HQgSbvWcgwU+G9VeUf57awkdXmScH+k=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795320307;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EdQh1078VcVl8/I0mQZEP2eKR1ViU5tIGep2uHjM3/I=;
	b=wr4O5zlgw93sYkTiIDUkGkg9QL6LIJUabU7/0lmsrrLA+pnxRkLhhDum4iNldcPh1v5QKF
	CiSkWobKFQKZfHn6c27pIUlJp7+eVA/ZMgHpXJ8Su9caHQ9NYt+5HoynPvTsBCXoBJwCK7
	JyWE08isDefyqF4j90Xjcuncq4JMgfA=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=cq76QhQA;
	spf=pass (imf01.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-533202fe429so208931cf.0
        for <linux-mm@kvack.org>; Sat, 21 Nov 2026 20:05:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795320306; cv=none;
        d=google.com; s=arc-20260327;
        b=PYXs2AxS4UZxO2gDhyyz+iSBFZX5PLfeH6UeIh1fZ+HXodN3EEykEq89+6tp/1cpOX
         Jx8kC3awfwBcnHj98ZK5pUX4FG5Fkp4ZQFNVStB+Kf1qo4IMroiYiiemCxzhdi0M4mN5
         XM2rWk3GRNwdyah1BOFdvkID9oXTZkoPAGRgMT7QGHx3h459ZyUnk4+zP66vaWngQLDn
         U4WRmENVOXMmFPjk5kPsF+ndPdUVjz7FLHgoLJxQDfYWHFXX6N+SH9if0/z/Fxn1d8vH
         wI2ix5AgmUiYrPbkinB/OrLuRh4PuIzbLL49KjLcymCownhhPiAo4GdYMW9cVbg1h8Zx
         AZCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=EdQh1078VcVl8/I0mQZEP2eKR1ViU5tIGep2uHjM3/I=;
        fh=eU0GGUCqGBKo+UyL3pG6PSwD5ZCxldLQTTBGt9/Mjn0=;
        b=hzs0gUlzbauLOq9uA3kd71wo6PrlqmtGen3+4OZExFHwLJLy7Df2yiFCzwxLqmvCiv
         TbK4n2+U4PPYqG3iBc0P6KuF/Z6F9iPMsD3QgNjbIRiUoEdFcgqpXALa82S4RkYWgNOw
         GaDPKmJTj5Am8BkvroCNb2x2tDxVPLT/O+l1aaqZtNi4GBNeCiCJhdOZl+1QuCSpB8M8
         48DU2LN1n2IOKor4W5ObOpVPBAN1nF7Tw8Lt3vRXXiYPRL+yxnmvCNA8fZ8zmJ/K9Tiq
         v0xrdnRS9PNnVkXsx9/MuYu1K834Pb4kz4g3KJ0ha7DfX+qTg+C4e8qoS2yTODZF4zDt
         WE5g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795320306; x=1795925106; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=EdQh1078VcVl8/I0mQZEP2eKR1ViU5tIGep2uHjM3/I=;
        b=cq76QhQAArfPgeXLOUb9yColgBSx1TFOze6rsYBVv/QjiXJa99nKfSnEdedVpUKc26
         UE7kZfwgGBuMf+htfDL52clGJo1vuLICi/t1C/i8+P57KZd53pIhQMl0/x8vpS6h4z51
         A0+Nlm2odpjQsWdtUOBC9tBgKQB3XI9oU/8EGNqory6NWilEUbuI43uRcOSM3Zq92Sbd
         X/QhbuqciN7LRjCaFOXbxFhyfOslqAat7gMB7LTEnX6XwaTS2ufVrjvZ8HT8QBCrEpt/
         7TRDUNnS6e8fUrQFAtfIjYBuBhTjjkzMApWDZ+Ed3FoGVL/K4eOipJ2JKIlUmz+fX2iq
         ATlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795320306; x=1795925106;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EdQh1078VcVl8/I0mQZEP2eKR1ViU5tIGep2uHjM3/I=;
        b=X43KFA5/fu+uhWP/EupmTAYAJNde+5BdF4GOUsz5tRSvhNPg41BlNXovxuuRYhxZuh
         qM+hXck5iZUU82G70R8/+heAUuks6WnwGXibq4pv86+2aGnpRwkJGw0zDsWGuuoM4pui
         p6j1s3U3I4li28NJWlC50GIxJmukrKHHERsFAYFcF9Vn2AVis2/cNtj2vEf5gGW+u2r8
         g3aETMf28JW70hFfyvnBxiKwjnaA4QJ7pu4SlqGwWWB4pOj3XyUkMTuk14PmUxqtSZVv
         Yhi/a2yfoJT7Rx53e02YV8BypFe4xpFbKoNKdBXfkLILxZmcAEQ4eIpKWXv84c6//Htk
         ilkA==
X-Forwarded-Encrypted: i=1; AL+hErHRp+ScJm1bTf/vBRq+MhovV8gBte7L82nLi0iSu6eNPdpZLrJtLnZQ/RlTtVKwiB+8AZZIXBSI3Q==@kvack.org
X-Gm-Message-State: APuU4Z8bCx57tySH+KaDRnK0Hzq7u/imvR5gOMpz7YXrtcAINY5QRluB
	oIu9LtQR0SDuXkUWNQazAfVi+GWWii2It1+zHRLD0ikb/NSfnvdwfDpP0ohBqkhvJgBlyOqtAz/
	g7g7003BWRhparPrmcsh/3ME7oKCmMOFr7PNWKWd9
X-Gm-Gg: AZFdTZfHVM6OAJ7Tssx2C3Dr0VXjP7KkF8QLdg/a/xoUhEHZmlKRC2Revwc/PFbJFBK
	ceMEN4LQ8QrnD+vdbEphCE41WRI/bmAxrafS4/gQPbPxWckEFqVtlN7rs82TEx9aWzkyodVtmmn
	+q3TJQFcv+ejDHCjJyv/4aH9uhBXO541G8qgMwTKsMxz6HYWxlp1qAsxe6yXATuFD5SfKqN+4Dt
	lNPqeTF0eP8eCyLx5S2Ui2y7ecwwe4g4xhHNPKjrYLNrdn9r173k466ftofMS5F3iqkmVKioZo4
	EgR62MrXMREZSlyOlHiIChEgQikIcN2QnRtOTfXlaMCq9+RZeFGafliNxH4Ooobvq20g8+r3HYU
	0+izbHOdOpyChLxUkTK9KlmErPTb5kjekvsZvYptFYWEdUbz7HTlFbtSqOeQHEvytqM1RyzQ=
X-Received: by 2002:a05:622a:2b44:b0:536:934f:7da2 with SMTP id
 d75a77b69052e-55d88013e93mr20693911cf.2.1795320305782; Sat, 21 Nov 2026
 20:05:05 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261116071325.263682-1-hao.ge@linux.dev> <20261116071325.263682-9-hao.ge@linux.dev>
In-Reply-To: <20261116071325.263682-9-hao.ge@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sat, 21 Nov 2026 20:04:54 -0800
X-Gm-Features: Aa3M54rNW-fgq1PCt8XmLDMf2BnWeGOuBPMCOY35tY8eLiMpaqrvJYSsrRzr_ls
Message-ID: <CAJuCfpF==pGi09rnh2ts6VhV6Cj9kjk0rvvkGD3=8TmFKW-VpA@mail.gmail.com>
Subject: Re: [PATCH v5 08/11] mm/vmalloc: drop the KMSAN metadata in
 vmap_pages_range_noflush() on failure
To: Hao Ge <hao.ge@linux.dev>
Cc: Uladzislau Rezki <urezki@gmail.com>, Dev Jain <dev.jain@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
	Shrikanth Hegde <sshegde@linux.ibm.com>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>, Dennis Zhou <dennis@kernel.org>, 
	Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, linuxppc-dev@lists.ozlabs.org, 
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 575C740004
X-Stat-Signature: u8hwyi4ihhddybinp5ogxkixxunax8sx
X-Rspam-User:
X-HE-Tag: 1795320307-990031
X-HE-Meta: U2FsdGVkX18uMAjtGazeolvpKNUDPVhTZ9845L6UqKdjqhqyBJMOvtbcivx2AvCFUpFyAJzF3JOfg7bYvrSlqpH7OI38ZrTmHOkoxWQHXU0fTSUvHSn9WpNdxTVYmvBwZpa6g5ykEfN9ZxrCLfo/NaabGrGiWeo9kuV6EmCwwHFaTShIT5Hyq0sqKFf9J76uWwmhB0b1s1N4cWhsKMTGRqWgd0suo+FnST8DgRQyIP+NXB7K4otbcCNX860MN/c4DiZbM31Nts/mjWMumACMUKpeVXJ6US2DQ8fe0T2V/oW6NY5PANHK57w75q8Lo22B9HEguDbp8t7fQbd/DW/kCkm1ZHxrEnb389FHDQLaqyWs1lpX0BNRR1TFo/lZzndjnyj51z9vWtpsJV8Q7n9E6hJ9BWx9xj+oFjH5+b3KppdvIEX4uXbgnt8swNHNptbHgyNazNSTWAST88cBsJFBgtuB6EKVEBboE20oMkr2onmxwZRkxyloSsZ2rlxejLLhYm0NXcvW6AvhO+6y5vr4yoRQVez1dR8TL2kzNUWwDjoR0ka5xskJa2CTGTonlsS6lFuIh1d487KDHv31src1Ef5cd7BOAWb+ty/YXEaeB1T8SKewBDq9NnbXnq3/5L2W0kWdqFTgHBEiGhWwcR9S+iTi6YC3wVMJGaB+2vOokMIEii1kZqYaa3bhX4NB8Dxn/Uk4J2e8rh8Qpg7B1QG8e8XDBUyrdutOXuP7lGHgcIVOoOmhVgW2tMnscmQZhZPAwzsNTSkP5POogH5+X7SzDtal/82VyIcbZw0Zls4HJKsBG/aLq6hJ6TfOtnBR8/74GAGt/FzQrarYLz6Dy7CDw4l1M3Uvghev0LhNj+HRfUKUqI6kKxxhe0xck8sJKNcV7mKjU3IOehQKUC113dIGoO9fkA+N9ThJaduASIXaZYI9CfnyvfGEFvZiHXguXgaOfOTJKAtPO3FWNo7Kbki
 53GQn4qS
 TJUDoXMxEuvXibIlP1+JJqgIW2Xk1w81++vyYYmlwPEY5a5rHHrIY4e3Dej9lSWBepyXcaxBfmT2gptYe6e7bDPIpwbb2iHq4LEqK7iJCNFAT1gqlmRC8IGiFkwhTylVxljyEkTqbtvVqRbnCKZwyw6Q+BTKngc+KyohOKw0Mi+owsa6w+NvNJznPkA3JtW2H2yIIVoBlqBT/eCdDbePoDd6i0ldzHPmxLMeDJeW+PSBbhZ/gQ8rsbxPirS9A6oUqlcUugp7N2WIHFQ8SJ0I1AA0vr/XRv1K8ybpOsWpnQw3TtLsiNdMAwId84va1gXd6ESomWuCuZebjfa/XWGLeummLxNersIIhvhDXEPD3mzQB0hHAjnN2KCtOjlCv4WaYjZkCwrZfrOEwfz7j6XdcycsjC6OPc2qhdw9ZZqQhUfep0yhCDMcHDAtYyhwvUT4aF+KlR4erMSOu2I/x1rJ451Vd6pws91d/0ROrymQlBxiF9PqWM8xEDujZ/Lph96GvtMzHYS/b4m7GK8XKHrUx1HY8yHiG8Iye31U0NNQlre/98eEqr8DmjGgSOduWl1ZYNRQduZMLScKbg98=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 15, 2026 at 11:14=E2=80=AFPM Hao Ge <hao.ge@linux.dev> wrote:
>
> vmap_pages_range_noflush() sets up the KMSAN metadata for the whole
> range before it starts mapping. If the mapping fails, the page
> tables undo themselves now, but the metadata stays behind, and the
> next attempt to map the same range hits the leftover shadow PTEs.
>
> Tear the metadata down on the error path, it was fully set up before
> the mapping failed. The teardown follows the page tables and skips
> cond_resched() when the caller's gfp mask cannot block.

I think this patch should also be folded into patch 7. Leaving the
metadata after unmapping a failed partial mapping introduces an
inconsistency, which this patch fixes. So, in a sense you are fixing
an inconsistency that you created in the patch 7. Instead of
introducing an issue and then fixing it let's avoid introducing it in
the first place. That's what merging those patches will achieve.

>
> Signed-off-by: Hao Ge <hao.ge@linux.dev>
> ---
>  mm/vmalloc.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
>
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 4f3c320a4849..28e65073624a 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -801,8 +801,18 @@ int vmap_pages_range_noflush(unsigned long addr, uns=
igned long end,
>
>         if (ret)
>                 return ret;
> -       return __vmap_pages_range_noflush(addr, end, prot, pages, page_sh=
ift,
> -                                         gfp_mask);
> +
> +       ret =3D __vmap_pages_range_noflush(addr, end, prot, pages, page_s=
hift,
> +                                        gfp_mask);
> +       /*
> +        * The page tables undo themselves on failure. Tear down the
> +        * metadata that was fully set up before the mapping failed.
> +        */
> +       if (ret)
> +               kmsan_vunmap_range_noflush(addr, end,
> +                                          gfpflags_allow_blocking(gfp_ma=
sk));
> +
> +       return ret;
>  }
>
>  static int __vmap_pages_range(unsigned long addr, unsigned long end,
> --
> 2.25.1
>

