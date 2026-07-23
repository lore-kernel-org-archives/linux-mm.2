Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30D6EC531C7
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 08:38:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F4886B00AF; Thu, 23 Jul 2026 04:38:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A5716B014A; Thu, 23 Jul 2026 04:38:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E88566B014B; Thu, 23 Jul 2026 04:38:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B88756B00AF
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 04:38:51 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 320EA160402
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 08:38:51 +0000 (UTC)
X-FDA: 85019390862.28.533FA56
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4FA54180003
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 08:38:49 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EdDtVoZ3;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf24.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784795929;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UL+d8wbRBQJ/jtsj7/n6KOSBmbhT6bVbxdyZXPjFAeQ=;
	b=GMQTxq3/dJVEvzIf/P8dYLpWui+vRPclcS1lkt3IOGzpaZj0rLULnewBr2kyOrw+x89nhY
	QsQVyk5mDCx79lUjEnoF+kSTukfBLZdJrEpHGH4xNT2KmvuIwQGOhIe7FIPLnjd+ajaBoo
	an5FbUCyWUP8qJbrICtWoi7lWk1lyyY=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EdDtVoZ3;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf24.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784795929;
	b=U6TC+maxBvyODspTB30kJEkTWiEpVlFa+LSBQXf+fZ0QlSeFCjm1mGDEIkEN2n38Fd4ZqX
	i3CwRvjn1lNtL4TDaKnKytFSJ6TqRkv22/OB0tQiaQcCAlNK2FyFtpJkc35wnBQ+BtxTxv
	vf/J6X7DEWHniDfdToZQ5jr7qfdbaes=
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c160420289bso56285866b.0
        for <linux-mm@kvack.org>; Thu, 23 Jul 2026 01:38:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784795928; cv=none;
        d=google.com; s=arc-20260327;
        b=VSWyttiHcDlsnC9YwuakOV3bZsO6zS/cX991WAel5h5lDghFwiCntk8sOMt0WamJPL
         rxC7ITKW0/nh3AqShMErFQCatKJMcGTlg8gZkLv8/fsPxgsuFFcnxq16dXgXgKb7d8QL
         JOvSdqokTTAsXVi800fKQMD291douTXj/B739tFLP+zaFK5J7JIybFOfNPnZjCvCPmaN
         7ibvJBuR0I0ESaRoQobt5HZFZljiiD3AD7R8CKXvP/zMSoFtpcGxtHgJyhG1Qbf/1qq6
         +Rh+/TQAeHniffESrPDYq39tF2Na6lq5d3WfUi0osOJEiE0DAzhYFFjB5e+wEOR/V8v6
         ReYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=UL+d8wbRBQJ/jtsj7/n6KOSBmbhT6bVbxdyZXPjFAeQ=;
        fh=EtUcPd1hiphIsqmc/TVVgMwz1sc9Du6SxlM1L312idY=;
        b=qMiC2SPdvLz/A1t7XVkqYzfPus8qGf9GUOd6x08XRFXrJSeN9H2UHQWpce8MTsMgOe
         f4zWO6di4W7US1nDluVKkP/+xRZyEu4tpqvSo4XhpzcO6t14CPrvbiD2G++S4FN3s4TN
         AROaxLm29gFR+7LNnY8TUmewepg/wqylijpvxF2Ow7K7AT03FCLjtQyigHFVkBRGMFK3
         cxa5BnYchfKBEnbXJ5L1nHshQbEgI/Ejq+x6Pc2waZ9ZmdkUDtee4mK73BNXTXmtFSrK
         OF4G1Xx7Yt0SBBDw37V2YFgJzIHhfro7KKlCO3Dyk8hPtr0+Ys0RIiIqFDjQXuQln8Jk
         se5A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784795928; x=1785400728; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=UL+d8wbRBQJ/jtsj7/n6KOSBmbhT6bVbxdyZXPjFAeQ=;
        b=EdDtVoZ3WRlADasG+DBhLXi2GL3IC0L1aa8tw06CSP4Gybu76CrKI/6vhPo6WMkhBa
         rq7YrBbRmCqR7T64727vKyzuDxvfeAQd+r8IgGZKoAOP7rbvXp2ylQMsjPoM2TiUzl9G
         PTDeR7YW1vGkmLGBg20N6MZYZuQwesn/EDlsBZ/ePOPDIqc19iG1SIRlP3tZQUaFR1jZ
         F91EB37zu2jwU4MF9dbVXkXjT+Dz+CU0rdMfRmxqr6UVYdvDS9aXjaglu0yAnFfgKmnB
         XO7NL0t/S8ebnNdtNeQ0WD1jfPVhEn0xxBepYDPTs1mGy/5Pki4p5aHDfLLTleIAIx3c
         5nAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784795928; x=1785400728;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UL+d8wbRBQJ/jtsj7/n6KOSBmbhT6bVbxdyZXPjFAeQ=;
        b=jL9uhi/hOBdBjzhpwT1vE9YlMXyyDtBktOyzQtJLUoyhO5fdr3kf1+iAzVRNS31K6s
         cBaSpIbSM/gwttVC2fo0cNGEzeY3ri9ymI2TZM5oo2ZLsTP7hRf7IzXZRVl5/juzZnUT
         6bXAUiwGn53fczrD/tayCh5MZK6G3OcUS41NWKtH9/RZnrGtOWw5tQE+wQt9J3LU11m5
         c5+6J7BBv5DOuqyMp/sid1nUIRSuuRXcQwmOHIbNPIcf49yWzUhqgbMFAlvVb7K/RThQ
         eVFCQFHaZfGRNDRgvUqdrs01m0DimcyzkHBi3sVvEEEWC+3Uuc2o/bMNiBv+jdEjeyfu
         pdIg==
X-Gm-Message-State: AOJu0YxV7GEhqaTEeCVRYJEujjPDB9seVGFUgNZ/lNArIJ0BE1ywPvbu
	E9cHHJztjbNP6ZmTCbAD5KfvjhvZSjKEsvT4ULTxG+zOJ0R6o1qSKX7gWGUduWZw+Kz0ydC5J1I
	P5yhqBPCYpMhcQ3Bsm3JVvwQwQP7lUss=
X-Gm-Gg: AR+sD10RW+umJdinQFPbCfTUn5oJx1uRXRDZbRsMCPuh/jBw5A20a6t3p/1ncsMABjN
	iaa+m1z8MT7AbywNn6sheawiZ1qCkg5XdZ3WrZEB1w0gPN0NIV8XtPwGCprxmV0c8KluEkhtJAD
	sT7o1rV/EQ/XZVmqWnzJm9o6NUQC+GZ6MaPjPmoACdUIXdBlQvdEI0MpuOG87C+XnUZb9w7+VnG
	EVNi94jyhHjeSx+yA92m/qDnW8NEQSBCncap2zNr+W/FrtcbSffI82a3aqKtSNRC4TEplXyHiFP
	FwDFHlhWOLejQq/5IZA=
X-Received: by 2002:a17:907:c386:b0:c16:46b1:e0c2 with SMTP id
 a640c23a62f3a-c1c50dbe5e7mr91218266b.62.1784795927500; Thu, 23 Jul 2026
 01:38:47 -0700 (PDT)
MIME-Version: 1.0
References: <20260502-mglru-fg-v1-0-913619b014d9@tencent.com>
 <CAJnrk1b-5eQrPtug7i7n0h7=j0gaaGhihf3tbBZLfxz5fABUiw@mail.gmail.com>
 <CAMgjq7CmQjuOgeU5XOEwA532TB0=8U2aDXBz_prKVdFY0uyxWQ@mail.gmail.com> <CAJnrk1YqpLhsbC5m0vL-w3HG8dXGSPOH7Qq3-XAnJYTBdgN9qQ@mail.gmail.com>
In-Reply-To: <CAJnrk1YqpLhsbC5m0vL-w3HG8dXGSPOH7Qq3-XAnJYTBdgN9qQ@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Thu, 23 Jul 2026 16:38:09 +0800
X-Gm-Features: AUfX_mzaNTQsi1XDwQlO7quC3skQ69zXkB8eOQxkg2stFXO-m_6gpcWqDBbQWhk
Message-ID: <CAMgjq7A=NB6qJL1WLu6b+EonLKnDjbFG20Fq6OM_Vq=798sDmQ@mail.gmail.com>
Subject: Re: [PATCH RFC 00/32] mm/mglru: MGLRU-FG and refault distance support
To: Joanne Koong <joannelkoong@gmail.com>
Cc: linux-mm <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, SeongJae Park <sj@kernel.org>, 
	David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Chen Ridong <chenridong@huaweicloud.com>, Tal Zussman <tz2294@columbia.edu>, 
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4FA54180003
X-Stat-Signature: pxz9u4i1c5za9a58ebcyq6ax4ts435q8
X-HE-Tag: 1784795929-645447
X-HE-Meta: U2FsdGVkX19FLmV3TekiN6HhgbemdyLw9Tl6JeXcQdxOW4lmZCPQaOdlBb4A4WekMQPr2NGu9BRMcX7AESjhI6tGRh+AtSPn3E2+8em4wEtUU94X4Jk5AQOnnFOZqqmNmdEglpLf7/mZF8yrHKJbJfUzP1cPAamJNoNt1wJM5Qk0nBcAjMV929StOqurLGpZzoPIhVujThvZFG4zKzBgyANdGnxXZ5Zao9z3yW+NBo1xomFSCZA+9KfibmGBoe3ouGQ1y9oCoLfD/bgpj0eJVyoKCjY8JCAumWW76XgRe14K67u+BfAs/o8Ox/PgW9ikA/txHBniYZ/hWYbh3542tl/6uRq27xKF7z3rfbniezY+/YkmrqmN/uGyCxGTq8vzGKgtMY5LEykTbBvs+0frhXMPMkf4E18X9wqoCSM+X+NySkFq/KWL9+q6ixggXfIpbB4i8Fn28TjorvSGqPCSWGNvTZg5phtjkwXSXDlzFfeb2o4mTt5mk03QdqmBMyJgRC398SbySlqNM3jfyXVPgJs1tJPcTfc/o5+8WlFlPrKa/Pzru1S8ivmds3XuvjYjkfO3YwjB4Qh4RULA/0vHi2fXDMHQg0rYdBxYt+2j0J5JPleiEiNNRgLGYB3+Ii3IB7bArV3MjZj2Y3MTJ4L+G3zfaBi7RKY98Y+ugV54wgPTMc9i11wWWjFQM4cOXFe7AsWlzEroAiN5yQJIqH4zKfLsPz5/eeD9zayyiI2hdvYaoYNQ610+47I98V64hi1/Dlsehdr9wqAi5aQBQjHarY1EFTNYtD6WF/vLqmCdOznc0QPp/pKh+8FLRkdvKGConkNnoN2sej8axfjHjtiH+/ktsYhCogHmR+WJbxy2eeRWUa+AfVeCwswmtmvS7cw96H/mMPegcDnsMYo61fcQ+wGcQ0b0eDS9LD555VtWrtvMLyy1Thom+EM4iroHl6uMqKz7+5gVgZBvfKXIrsF
 jK40JH90
 rdbGo0SxCGhFPp2Erq4xSF8foQvDdFLUWtD8J0qA4iF4BO3Ety/hkDoCh4ho2gti/vPiEjRouiaJ+7YwBgFzfSuELZwoFCdVAAKHhQco4vQGdKfWAlYdLh42C4cPVFE0cyccMvUaV9PYVfKzDbO2klCgd9frKShm2+LHnEs9zlT/7Giz0VOXk+ft8a8nwF4Jd2PSc+nwT4NEJhdZtFUuaNRgy+uIxY1CZlNFlslWu5m9EoIYR+kxqn0bFNQFLcY4ZUU59M9E9z4bWq5JkO7rZuX6pWsEyQgwmXUvR2rB+9SrJsMWbHZHkIGWVC3Gb68wwQhse7WIVTV6Ay3Dkq4NbQ2UO41TrdDo7CUU7rhyGt2V+/LPTLarsFJU6Tc3sgZSHMAMAaAI0havQT55X/WLlx9W3WZcIQzjDQgpEULwBfpBnALA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Joanne Koong <joannelkoong@gmail.com> =E4=BA=8E 2026=E5=B9=B47=E6=9C=8823=
=E6=97=A5=E5=91=A8=E5=9B=9B 08:49=E5=86=99=E9=81=93=EF=BC=9A
>
> Gotcha. Can I ask what speaks against having the flags unification
> work ordered first, with the MGLRU-FG patches based on top of that and
> submitted in parallel as a separate series? It seems like the two
> could be reviewed upstream concurrently, and I think that would make
> the MGLRU-FG series easier to review with it on top of the flags
> cleanup, and freeing the two page flags seems like a sweet win on its
> own :) Is your concern that the FG series would then be gated on the
> flag series landing and you anticipate that the flag series would take
> longer to land than the FG series?

Hi,

That's not how it works, though. Without the MGLRU-FG, it takes four
bits for tracking the tier and these two flag bits have special
meanings. After FG, only three bits are needed and these two original
flag bits are just the lower two bits of a three-bit counter now. So,
there is an advantage to rearranging them together and removing the
single-bit (flag) operations to always use them as a whole. Before
that, that conversion will actual make thing more ugly.

BTW will there be any feature change with your splitting plan? If
there is no feature change, that should be easy to review.

