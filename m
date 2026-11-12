Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29B49606A881
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 15:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=NfvbNHBF
Received: by kanga.kvack.org (Postfix)
	id 48F5F6B05B5; Thu, 12 Nov 2026 10:50:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4405A6B05B6; Thu, 12 Nov 2026 10:50:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 332726B05B7; Thu, 12 Nov 2026 10:50:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EE7056B05B5
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 10:50:42 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5B60B4025A
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 15:50:42 +0000 (UTC)
X-FDA: 85426904724.23.003E7F5
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf14.hostedemail.com (Postfix) with ESMTP id 58379100009
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 15:50:40 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=NfvbNHBF;
	spf=pass (imf14.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794498640;
	b=mF93S4LV+RdEVNpRvw7zC0uRXJ4LuoWaK+7VVdYYnOlvxtPFZ7lKPRO6eUNZDEls+4wRGN
	La8i0LvuJPdR0+e5V97Qe6u08Uj1NfNNQIdlB5Ter5TPZvbUMRjD13vSzGUcIEA/RZR/U6
	El0cHZv/m02qcI0+/cLZdjSwdIJbaUs=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=NfvbNHBF;
	spf=pass (imf14.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794498640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1J5Kag5a9R9WjXv4Vm2podHkmWJUILcyb3bqAyrnJ/g=;
	b=TkRvaJMjNqfs5cpA7j8b2932I+9q1COWjCCdcmPCp/dpFHnkKr25eUNGgX/uy2yslY2Whe
	WNr+WmaByuPQ7N8TZF2ngfMOeoty5CRhUctnEGfVR6W3YGFaBVRLb7QLpxkBaumSZE7N9W
	9VClOHjG01etDm/LyeHOow1qf1lzYH0=
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-54492d8a988so282531cf.0
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 07:50:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794498639; cv=none;
        d=google.com; s=arc-20260327;
        b=qEHwwwz4/8L5q7NvpfwZpTMzioASkQXwb+fwSMfMCJbLQI5Rf28Y93MPdEh2J7WeZB
         Uk9Ev209Q5iLjAyJLU8TPL/O62q20Fpuo6AbnFexxPIFbxS/wEVas6U5pS69TYoJeulm
         /jEkyN4CumEVykYRS0jK4QXckZEFHL815Ac1WAJiPTdRcrstfB4mEbwYv+1OwYI7MSLh
         ifEG3mJNFUo0uPc0Eltt3yDOIuiZPSacUdbSYjx2cytqWmUBLp1Ii16kdqrzSX6Y5nAZ
         G0tFaahphXAk4cAUuqOuf5qxeSYXBj3Y8UiHnzjBHFWN2KF0aH/DiJ8moFZcZdl87RQN
         evJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1J5Kag5a9R9WjXv4Vm2podHkmWJUILcyb3bqAyrnJ/g=;
        fh=8Is4pOyaHp71+n0+iMoEMGK/Npm5nFitQ5zo6iKHm+k=;
        b=OtgDmkGUliiZcx7PGSxDHYXQuQW+XQBD2GGllGbMMqTR//fNtrV9+1Q+kUgp7ojuBk
         SQsS57bvRPuLhPVo1e/WBFOBXcqtvYHGYK1epRPhqF1y2UA6atGsimjDLNA26+OLGENt
         1bW5YDuOWuRUk4onuY4MZQOjSFr0z5Rgsz1nnfCvKriOt2j4+4bPnsP8RWSgg80yMnTi
         mr8w6LPvFUt9agLDihH5l27zSilRYKM8yAFNBGNbgppMef+oggKWmcvZvS0WsRtv+5FX
         Dg9y6w73GcheEkv1myT7FfZvSAdkRTSLKUpVjMxdBMMtoPUESHiq124BQ6zblrPbUGUI
         cJGw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794498639; x=1795103439; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1J5Kag5a9R9WjXv4Vm2podHkmWJUILcyb3bqAyrnJ/g=;
        b=NfvbNHBF8JWVVqy5Vd1oenLt82/8MLszjCkmA2uV8Qjr0uEf+3qzfb7wijV1FecyHx
         v1swqIDaGPpsZ0e++p7/QcLYawec5ABzRArYqtCY227jcMoO8EWCQv1uqfErYaokrdqB
         D2dV2uxDSm3oRIA538ln+P4iEh0iG9KaEV9mFrKrzRRueVGnWaZV/zBsjqk3sFfsH7dS
         oDR4CR6p+Rlk14/3SMSqYHjtN4VfAlJVhvxx3hX5FsK64G4oqwd+7Mt3VS0q1bY6rpEa
         ttRuL3K9VF6bqV/LZNmkOVJ6Mw11QvK/+6LEEVBV44DjTqtPSrAhTKGh9HI0wdcwDnN6
         5M0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794498639; x=1795103439;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1J5Kag5a9R9WjXv4Vm2podHkmWJUILcyb3bqAyrnJ/g=;
        b=mlMN6niLWf4qikLlDyf3eS6JA0LL2MFjSj+CBz6X9b7RL9Dv51SWLBPpRZElVZvXE2
         uyfJcCNkk6ZSJO2sGrplSl1xOeg4Hpf3xUrjxtQ60kJhYSoWdRwn/PrXp/31C5YlGedl
         rC4MQ7nR8kX2fb8rgQJ9Sm6G7cSuNB+P5lw9Ndpb5dfrY95jVB3ZAwNDHFUVlDFtiNrz
         bVm84QD9RMGq40sSkUDYuKy+nSJtT8HiOxI2HdkIfAe4gW73fUGFVMi9hI5wKNL0S0Ou
         ncH2iH/k0g3Hz8SUAhZZ2aNatExg5O0pNCqvo4dHJnNc2K7rM7EU+B0xxGZFp7T0jXZ6
         SGAw==
X-Forwarded-Encrypted: i=1; AL+hErGnccIA0ZRACrU9DRT7MnuGYfL4OyJQwRjiywGEwp2tnCEUxTsSKVwH1CtMXKvnq/Kvj2SVM0mYug==@kvack.org
X-Gm-Message-State: APuU4Z86cmEhRxtIlqWAuXJ9J8KPuRMEPMcHlgqDpIjaPJR5gKckp4Ui
	a0zdn/DZE3X6tIjL7CXZjxsE/bGG4URp4DZeQxMxJLmsKQJqOFEGkgNK+38AwERUCD8W9fTEkOi
	oJnGsPSj37/CT8rSgumDfyGxtv/deIt/vArJZNgAx
X-Gm-Gg: AYBFou3V1P2fWTZFgZqNhHWFRf0O6dAYU0puYbN022IutGor3utYxd7YdmPva7sEQay
	z4gmzInDKEoZgC168gSg4G50GddIhdnW3kM/j6mifw5S1oOcs41zUW02Ue+p96duLNWkffv8+pK
	C5bFxeB8BYIB+GrgS9X6zSpodr7q7axsaTR/Hrq0vHoUzMk3n2RfyMUvIqL+3jL3UavMkUqJkx4
	0AcdLzdMY08LlhtuMLxto7xwYQiH23coJk62PQlh3en52eVDFJyW2uFUIBS1Hd0Ji4o58e6KlXW
	lwX2toQiDK/Xik6WWvRgWjcIN6JHImHN/wxVBiTFvytncZYgqdiWmFW408eCtVfSamZBKzmVaoZ
	yRoCJmoA7rBic5S41NQ9uTrFXAJ+8hQ6sajEwEbKGyVR+gTyBt1p9113CmLDJT5UCJmbzaf34dj
	Gq7uZBz+EfdHZbOt9mV9h9wkF+bw==
X-Received: by 2002:a05:622a:c14:b0:532:8423:1e78 with SMTP id
 d75a77b69052e-55990231239mr18865281cf.10.1794498638566; Thu, 12 Nov 2026
 07:50:38 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261110112546.261415-1-hao.ge@linux.dev> <20261110112546.261415-2-hao.ge@linux.dev>
 <CAJuCfpHjSZhPPpRudAdrDPzz8dGK=Mx62CYCNoO4MC9OhnGd=A@mail.gmail.com> <aa6caf61-a4a1-4c51-aae7-ebb767f3430c@linux.dev>
In-Reply-To: <aa6caf61-a4a1-4c51-aae7-ebb767f3430c@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 12 Nov 2026 07:50:27 -0800
X-Gm-Features: AclHuK8tTrX5dxrTUPnpF2OR-DhefKyRTvk3c3hlnhcxw9TdWFm-p4sWJVSI-pQ
Message-ID: <CAJuCfpEC-YR7NrX_J4U-eyP-2T=E02OKKEO0eSjFMzja+BFLww@mail.gmail.com>
Subject: Re: [PATCH v4 1/9] mm/kmsan: undo the shadow mapping when the origin
 mapping fails
To: Hao Ge <hao.ge@linux.dev>
Cc: Uladzislau Rezki <urezki@gmail.com>, Dev Jain <dev.jain@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
	Shrikanth Hegde <sshegde@linux.ibm.com>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>, Dennis Zhou <dennis@kernel.org>, 
	Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, linuxppc-dev@lists.ozlabs.org, 
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 58379100009
X-Stat-Signature: 7skapqnj7rquzt8xw6h7riru69w9dwxg
X-Rspam-User: 
X-HE-Tag: 1794498640-757990
X-HE-Meta: U2FsdGVkX18YykHG52XdF4s8K5uoZq6CULwzN63O/XMA4yqt3xxLJ0ud1c6YCVss+r/Ar7Qg7QoojtcEMvY2MICAuTJ+IyXBoJvlpF4KTxG7fwgdduEdTNjH/Dya8ckWHEwKG454TtCwlyNrPxNjpIP6EgzBZYvo2GjXn2p+C6BXKBUNBuBTcAwG85hEs53I0qlsmTty5ATWFXdicZkb+WnoQD0iYA/kUs3YtT2hdq+bj2MPhHjAxqTvYmWcCIUGs6HMNzYsvLiFWHWwT5GhNUk21CO40N5Ox27Ei/ixP/7NgssvQUbAfkgKAFswpOsNruGoPffTyR8v3sxzICHbpi5g/zZyiFy1pD1wvVis2SniZX7W7y8TATMLsCwuriYmCEI4NfQUOJj7cyXFXmpl3M8VcnHga1JwUakGWu2X3U8L1BtpCgJnt+0cF1VN/7rkWJ1qGsaSZNgXGNmn6EYkXOQNjVihlcyvOzILE0fmv90QchyVk3PRZITh7uUJ/iK6iSXWVW3+/xmJ1tu0oy6bJcee+W7Bu4sWj5TdCnfwHeRcABJMVh1It8Or3n4d7aOcGxExyeOCeIDDe+0u/uJhsgQQFgD38FfsheWrxfjbicn6gSkuVw8+GQJ9Bw9mjyaVkhJ+dxQMlHEWwHqX+hQQhEUM/pe1QmGPc6c929/jHdx0q2uL7MYy2V53H1hY3W5G95Ohq+yzeVivAE+9QXwT0JlBpNb6k+TIH0SP4UNgDyVghJAgJd9hi5wBGddWdiH3V17Ipc374REWVv3lHoVcZ4E3XO1CdEIHuhoZjRiIgFEkWXwtlBfOA0mqEkR41ZoiNwlpJEJL3gm9bAwtQz8NrsagfxPkTLftCucFkditS+C+h6C9IS8VPx8vAPF9URlA3eJaiMQqVH4NG6PpvFSq+N+bMDMjdswcg2SuYsN1GMm1QWDlNytD+iQ7F79noE91gJJ1unWJ3hiWdeVQL6j
 uWx7DpSp
 LyBz0DdKC8unb7DZ0vDWNq6jgWZwk2vtGZ/E23JYVIWfsO4rW526lL4N8AQBP6QSvLdtDgJvLR+QMZpYmzec/yem/RYB6w728l1UAmUwUoAki9OV9D1FJY4IuMsIjNvnJ/SNddsC1VGrsCMIpIk8JjigEC8hb1oskcXn0XeVFzyV/43FImTHGWb6iK9H37J3LJp/Pw7GIaqA4u7UL2f9EMV+4uJ2TCRr0bsaN74tV6FOwagm/hw8IUEWQyqo64h+qTfHoPQgcTipTatlCEqX0rCcw3sDLixun3GKgjVX3oAq5z62Fmz2cSzMDO3PIniRNrURooUu9E95jRIF12x3+Qb4Xm9WUAygccjp1vATCc9VWB8VnGfwaG5IAoSBk73o4uL28UzzxmMWkb4DyJtEzvWI7n6B9Rc/GaRrc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 11:49=E2=80=AFPM Hao Ge <hao.ge@linux.dev> wrote:
>
> Hi Suren
>
> On 2026/11/12 05:03, Suren Baghdasaryan wrote:
> > On Tue, Nov 10, 2026 at 11:24=E2=80=AFAM Hao Ge <hao.ge@linux.dev> wrot=
e:
> >>
> >> kmsan_vmap_pages_range_noflush() first maps the shadow pages and then
> >> the origin pages. If the second mapping fails, the first one is left
> >> mapped, and the callers do not roll it back. The next vmap of the
> >> same metadata range hits the stale PTEs again and fails with a
> >> WARN_ON() and -EBUSY in vmap_pages_pte_range().
> >>
> >> Undo the shadow mapping on that error path, the same way
> >> kmsan_ioremap_page_range() cleans up after a partial failure.
> >> __vunmap_range_noflush() only clears the PTEs; nothing has touched
> >> the shadow mapping, so no TLB flush is needed.
> >>
> >> Fixes: 47ebd0310e89 ("mm: kmsan: handle alloc failures in kmsan_vmap_p=
ages_range_noflush()")
> >> Cc: stable@vger.kernel.org
> >> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> >> Reviewed-by: Dev Jain <dev.jain@arm.com>
> >> Signed-off-by: Hao Ge <hao.ge@linux.dev>
> >> ---
> >>  mm/kmsan/shadow.c | 4 ++++
> >>  1 file changed, 4 insertions(+)
> >>
> >> diff --git a/mm/kmsan/shadow.c b/mm/kmsan/shadow.c
> >> index 0c88d89bf0d6..2166086d3dc3 100644
> >> --- a/mm/kmsan/shadow.c
> >> +++ b/mm/kmsan/shadow.c
> >> @@ -258,6 +258,10 @@ int kmsan_vmap_pages_range_noflush(unsigned long =
start, unsigned long end,
> >>                                             o_pages, page_shift);
> >>         kmsan_leave_runtime();
> >>         if (mapped) {
> >> +               /* Undo the shadow mapping set up above. */
> >> +               kmsan_enter_runtime();
> >> +               __vunmap_range_noflush(shadow_start, shadow_end);
> >
> > Sorry, there is a problem here. You introduce "can_resched" check to
> > avoid calling cond_resched() later in the series (in patch #7), but at
> > this point __vunmap_range_noflush() can be called with GFP flags which
> > do not allow blocking. Before recent Ulad's change called "kmsan:
> > remove hard-coded GFP_KERNEL flags" this function was called only with
> > GPF_KERNEL but now that's not the case. I think you can move
> > introduction of can_resched flag into this patch.
>
> Agree. I just went back and looked at Ulad's b186a94227b7 ("kmsan:
> remove hard-coded GFP_KERNEL flags").
>
> So will do next version. But perhaps it is better to make it a separate
> prep patch in the same series? Because besides this call site, the other
> places that call __vunmap_range_noflush() need to be changed as well.

Agree. Moving that into a separate patch at the beginning of the
series with its own changelog and explanation would be cleaner.

>
> Thanks
> Best Regards
> Hao
>
> >
> >> +               kmsan_leave_runtime();
> >>                 err =3D mapped;
> >>                 goto ret;
> >>         }
> >> --
> >> 2.25.1
> >>

