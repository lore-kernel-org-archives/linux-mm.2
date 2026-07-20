Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D9B6C4452A
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 14:27:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CF566B00B6; Mon, 20 Jul 2026 10:27:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8804D6B00B7; Mon, 20 Jul 2026 10:27:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76F8B6B00B8; Mon, 20 Jul 2026 10:27:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 476246B00B6
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 10:27:32 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CE1B48019F
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:27:31 +0000 (UTC)
X-FDA: 85009383102.20.BE6B8F7
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf17.hostedemail.com (Postfix) with ESMTP id E43FE4000A
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:27:29 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Fb+CUhmc;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf17.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784557649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g+l7EyRuOXWPa8YZYb/EpRhfRItCx8XFXQwkJgBuRzE=;
	b=WxXkHpY5extPsyTpVVtFPEZdZ3rgYF7zrLMlwBSL64H8QVy6NMTPeiHBwzXAy7ovDQaQN3
	8CplzGG35otEt9p+R5SVdJTdMUd7MA/Mk7KHoMdhVMThQSKoIHYieiXvNf9doZ3cRLCwQT
	4ZazLg4wfESxXelyNb6YN/sNwkD+5vM=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Fb+CUhmc;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf17.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784557649;
	b=Om9bK3XRfiNHeRmkCUMD941mbOFSxZHgfzdkPl6WJRTbUT9YrgkIzzNHDm2HoAYp7AQ3vI
	mdPPhhQBWCQy/yNh2k7bbRn+IvotmqkkQ3GZjttZhceGqWZThDqZmpOMZoYhNHimHIXVTg
	YA8zTWupdW0ZHhyVgwTxWOL+QR6Qeus=
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c15ba3a2b4bso1258715966b.1
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 07:27:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784557648; cv=none;
        d=google.com; s=arc-20260327;
        b=CbMaFhwHcM7cxH+Wcy4AI7ZGb/SEeEEQOECz8Tefx/Ynf6XujeoBPOjx/oXuB7XFCe
         FmtX4L7mNzdpDBa4hLm1eNrbIdlQU4RbNfy+ZkwNds0/ZmjAjqzc3J3HFJDgswgmB0y0
         WCgcqgbPLmrxRp3vsdZH/H4u5dyLN5/XtXLuPDgW1IPqB5ts1sSnEN7A1kcAWaoIVwMl
         C2deoU3ikg7TsqK3igucgwIrOCkzp8+pC4DQcH3EsSu+I59tzlFJeWm1WA01E5fMhdQJ
         P/nehRMGPBEa3jENRvuaFgoTdFW9UmjqXp0PIiuca5kEKWek5i9k+nOUZxAmY4BsFEiA
         5Lhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=g+l7EyRuOXWPa8YZYb/EpRhfRItCx8XFXQwkJgBuRzE=;
        fh=PQznnSev4CFkHwKLMmuFCve4JJTxqeqb4VsGDV4fKkY=;
        b=DcjmgLfL4m3zMbEgDadCSyT9l0hjgGeeLBgK0F5imaxuvBzpvCZVB5JgBjveT/p696
         TckiKVn+O0XhCvNZ9jgmtj0uldrimHO82oBFhFbQku+BqoRrFS1Fa7xshOgKLQzSjaw5
         jcWl9o1kkvX3f1qcgDHMKxw20wUBpP/siZtkAnGGxdWjnl/q8w9Fuv1vAeVlGsz+OtoT
         SUHKFjdJDVPtiK1xOH9qUXV1Ldn5mkhMKkV+4AUiKnWMU9n9B45WRbv3+b794c93QU71
         3ZFbvDUjEsoAGRhWvAcGV1FBgpZAE9hQectzknoTUAmK7QXa2LpV0a8VfgEM9xyrB5w8
         sF1Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784557648; x=1785162448; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=g+l7EyRuOXWPa8YZYb/EpRhfRItCx8XFXQwkJgBuRzE=;
        b=Fb+CUhmcTQiDjEJ+/dRGT5zWLJmfMEm1LOJnWxKumpnfo0Lfh91VX4i5ZKKlOab2TG
         KGCjx8qTc14/CFuSf0wAecy25pIIX/LUJV693Xlx4FATLVcq0MDq/E1fS2HZ/2FUuzaM
         SagiOA9UB9Wf0GBGZe6OVsjSjJ/v8PnslIYaYt/VwBAd9NeTPciaoms/hSFtbvz5sqeJ
         tu8ApYfz8cvuvyVqbEVkh8NqxB6cKyQhJlzEkzaKCZOc5MNXEG7bgNob+TsTmQdvleLl
         OvLXigoH35FoqN4s/6W0t9a1yec5h4Tce2Ab4pHo+Ea/WhIYI35rjgVTxmtsazMb9EPj
         5zUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784557648; x=1785162448;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=g+l7EyRuOXWPa8YZYb/EpRhfRItCx8XFXQwkJgBuRzE=;
        b=DXBb5YDFASlPy5CE7s2Nl/a245YdUd2RoYdfL3BiU+/+gBd5BwnThJztzPyiL41plC
         EALrhURpAcErxkRHXkAzN3A+XZB5bDT8n4XiEmMTB9PS3X9XNTZKYEawUld9AlDarJzl
         o1BUQ4RDh/xRLqohQeu31Vp0GqFDce7LjMnPAv1RfeD7quVK+wAdKfy3QWQ+67k4HIS7
         au4AMiuWBEXobYfg7GrU+cg0P8PTR+hSOsNDJxG0EzdjHD0gY0m0r59Azmppg49JFywi
         3oy0VBsfdtH/hIZ2GDJWcRwHUmOp3dsq421AqaUJFX+jFgPNyHqZ4AFJ+mY5hLmJe3LV
         euIQ==
X-Forwarded-Encrypted: i=1; AHgh+RoKTqDNBcVcW1sr1wYklPCihaoQC866UVbm8PwM3yKQ0nZosJmyaqWXX9IZTWJ4ZJmganUW7D+Eeg==@kvack.org
X-Gm-Message-State: AOJu0Yxg5/yUJHBT2iIdZROs80liqhg9Uph61iE0mapbxtq1+j7fj75J
	yURfo7UPAcwwAHnCVrlnUWJW3DwFWA+FDD3l1abtKTSblvzQ8j0HAAtxt7wpMgwLdnhC6Tzja2w
	upI5fhJ6QHVuKQ1nrvZT7B2OauZbEEBs=
X-Gm-Gg: AfdE7cmNSrnp7fEst3wYEPRb+bofL+Eb41lotBsXUvkMHUS1w6Ti2T+L1wdvzP/Qu2e
	vLP2pPD70Pjf813Mgb8DvPTP10KM6/c9nrXW0fDxzncX2HiDfjuhmFaeKMI/vWANLxN7gPn/ogB
	PVNKaDTpwWTxH9qSiZPu1DwYW8cpBJJN209p8En9yPobCfvtU1PWo2H45xoOXORhS5rMpRwJCdF
	sKAK5FG93MfdHSPuzapSHIXSpvnvVrsLEyUbONODT9LZZvDrW31tqd05aaG9CiXmOgW4YnmJQrC
	weLQVOeb7ndjzh+wgqs=
X-Received: by 2002:a17:907:708:b0:c12:3c96:83a with SMTP id
 a640c23a62f3a-c16b4765b6amr582589066b.38.1784557648120; Mon, 20 Jul 2026
 07:27:28 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1784509721.git.baolin.wang@linux.alibaba.com> <2ee74f9f98ac45a2f0db0ceb018e086bdb671d17.1784509721.git.baolin.wang@linux.alibaba.com>
In-Reply-To: <2ee74f9f98ac45a2f0db0ceb018e086bdb671d17.1784509721.git.baolin.wang@linux.alibaba.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 20 Jul 2026 22:26:51 +0800
X-Gm-Features: AUfX_mzFfuiRH5OF-jWiWVtdb-9juyYCm71i-iIqZI9vqrK7P_CTwddoeN4Pn3o
Message-ID: <CAMgjq7AZp4w2ADdb0LyduPVttrU6rVW0FO+BUotXq3KEgQ-mMQ@mail.gmail.com>
Subject: Re: [PATCH v4 2/3] mm: vmscan: add a helper to identify file-backed
 executable folios
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	hannes@cmpxchg.org, riel@surriel.com, liam@infradead.org, vbabka@kernel.org, 
	harry@kernel.org, jannh@google.com, lance.yang@linux.dev, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, mhocko@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E43FE4000A
X-Stat-Signature: s51o6n7jjtyhp67ximtfz8oy3kpgy9jc
X-HE-Tag: 1784557649-972797
X-HE-Meta: U2FsdGVkX19eNpEzcLOriXuS7o7PJ6GdSR7M4006FnOM057M1Ung/9MrNR57wh7lmLhy0WcVKJKpH2ZYTomJIpm9v3yWscyLXaPx8LfqZkYHKql/3+w6hEw+jfb5WaTtsspFFE/u3/BoXmXhVryxPuhNTrKuNUgv3Cv/6q9ti2mZ6FAaVGucF6FgFpB/oCEIYwXowb8tdkf2kF47hylvkITPe3lNoCzwODTrMCcZ/121wl3+pi6xfqr7S5XRtRbb5io8cCAaDzQb/sr4bNUD9ConAXeO/o+MKErxqzJAr9BcpiyIGK7JoiTDVjkIrCuX/eb+G36WRqPXLeAFbTFzAkCJmFwe3HepN8W/q4UQqVk2e+PO3RGWAWT/wS2lZM2HM0+78mPKVjWUlws/KHfxLp4ibO5Zi5JXzp9tPuEgarVKbmRBgAVZYelPpA21Re9PTakTpMyfGIRy8Dh6kNKdDoApfjTAc5e5Ybymvoj8HadBNlpSZa/34mt0Fxww2E4Z1UWYzmsLVkFJFSx0lmpDiqMgm1beyYC/4V2/aeb+pFm/EuCUC+R2pf9XCsZuefyx8IzntcUzI4CHLpcZL4eYHwUFD4l+cBAggVGF35INFc7TgK05MWI9RZxnq8i5HhGtnktRQpGGbhaVB//G4ocQl5FVr1PlZ/hGdF/z0/diFKRb7jUpUDgdhSkdeOwzeWcnkTz+OfbQPiKeLYqHnYe16smD2bDz0E+qPqInp92BXuWZwB/KiBFSzoD4kbiYd/xKh1ma0Y/6cOlJoxEoiNPZWWu5cVPhAodRkqHfo5gzWMb/vctP1Ju2+jvC4h2GNByumgnOhsNXSt0yjKNMxzBlTYhVMijqt/Gp/X5tCLLvoCIQxEe08rMZWd97IGgkTXoA3P48y5rppzGz7Pf/EO0ovEUqnDQBnStOZxQzYy7wrIuzMuvprQsUnmWAUPk9CkVHIie9CS9evlr01kLrHf/
 ZdFF2N32
 I7/5UH3SuXCHi4VQCR65b35hoWtGCGhaN1hZE6hHqnTcHwSpO+iRHZGXE7IzedENKb5XXGphbdfKX0YEIBqhSKGxihyTVHiduWWU2kg4GgJw9Y8HneyfZCcNJyCCksLUOLjHgQZBkWNOTpizIQz+pM7NYGPF9oYSZMMq42vVdzpYltYPtq68NsIAYoiVb1puc7Gflz6tetNCjA/OcOdi6sK5ycUFYfud4U23QJOzNh2VMhPEjNz6Evj7zpyTPym0A4Vy4a2bETNnEI1MiXAfWtmtXzsFSDfK33TDxbLbke8BwCk87S/YugharGnix332XKlu4K4buQe1g1lnl1Clzb/qaxEC6W+ubGB63+xL0Qdanuv50BwcjBeygG6kIWg1qDAUEC3K39I3qSPEKKwtY8K5KzksHkwzRDaTlmZ+V+LVDi8vxfJ/GQtgyolH2TA55P3pAytmfmu8gAtdYIwKAT2W85BdklnyNv0hH5PUpj90E2DkM2Ke7eG3NRs1HrWtmKt1xg3xDL9UN01oozEcZwkAvWLjLTQtRC4OHXdNMh9oudCIsBS87bNdTNw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 20, 2026 at 7:13=E2=80=AFPM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
>
> Add a helper to identify file-backed executable folios to avoid
> duplicate code.
>
> No functional changes.
>
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
> ---
>  mm/vmscan.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
>

Reviewed-by: Kairui Song <kasong@tencent.com>

