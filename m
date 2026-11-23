Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9F1D606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 01:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=zDt5vOnD
Received: by kanga.kvack.org (Postfix)
	id 7F8AC6B00EF; Sun, 22 Nov 2026 20:30:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D0E06B05B0; Sun, 22 Nov 2026 20:30:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BF5D6B05B1; Sun, 22 Nov 2026 20:30:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 33A006B00EF
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 20:30:40 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 756A81C41A7
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 01:30:39 +0000 (UTC)
X-FDA: 85464654198.26.A90A5FB
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8538E4000F
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 01:30:37 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=zDt5vOnD;
	spf=pass (imf04.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795397437;
	b=KKSNM6MZAxu6yNfaYGG+WcdFJspjr9CwPaRBzVHuGkvS+8cZAQVhH1S1FhQD9R5Kntptxx
	Z1bCiq2gki8aVf21R+vVnGlMsV7yxLzpNySsDp2Dy56siy8688JSTBPLnREdnJzvMvnI4/
	oqTWoHLh9V/s84T+H9F1v0tHMtrTwOY=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795397437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PHYlamw7fybYjzeLc3iuK4CS+fPI6wiuuTA9v+wgAMM=;
	b=AZ7c1FxlxAhT1PPh/MTTu3ZLLh3lMtcY3X34Ih63Jmir+f48PHrCSnQwBZbkq9pvtupoMp
	0TzHz9/8jF9w2k6CqVimlBUu4XqtnwVlJy50mLO0xGidun1+3utxy4joIed5qZPel/9ES8
	8y0eW6V9XPSShA5pYNMzTedlFDFa0CI=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=zDt5vOnD;
	spf=pass (imf04.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4bb85e07aadso32951775e9.1
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 17:30:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795397436; cv=none;
        d=google.com; s=arc-20260327;
        b=G5FHXf4ZJnJTtdLCfjUQeWQJobE7Mf/GqOAVqQEPmjUNSNR/t59yLdAu7WXHTD6he7
         DwTxrROxLBCrd/Js/8COZO5KQBdFo9GY9WdGf96xKl65cq6N6tNPVQwS0ByXNzpX13TE
         JyGurDQAmk0D39NtUJ+uHKnnXRG8C1KJDXeoOBXK2bI84dWUwQeQmUDz9FzmjoWMDo+I
         tgHbMJrT0X9C7aRYt6RAH7sUMKYWCTI1apOiNkgf7Hf4cdeYh+8lp2U4OfHgKWsiOXMl
         WTB3beJnrfRlW1UfPQApZzeUUr4p6+FcRlB53tColNK7kABQkd9r8nXX5T1qcDecf1tR
         nNQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=PHYlamw7fybYjzeLc3iuK4CS+fPI6wiuuTA9v+wgAMM=;
        fh=Mi2HYAFSW3BbYu92YTyOIGZ9TixROySXoyr871KKM68=;
        b=gURTwah/FdKFp5TUWA6UqUM2ooW/pce8xHlQz1vQLWVuZHDICSfQ1oC3BxMhfK5cgG
         i6y6xtU8rA92Vf5EnDEY+5wP1cbKYCZdDSNJfTnr+dsoRijm0yYw58iBgnMQY4lOEsG2
         qhwuDMZwptvlcwzHC01zzgCD2jse9aGVKh5KNB7Oh9zyTP9k6iJpV5bVGo99MyidJtDx
         fZ3kYqYovxZinLShNzyAHyZFEJkrz9nbO1Okqp9LrWs+NgIpfAQ3+mH9dLc97NBbowyT
         dYfpO4qNfNww6m+eN7pQGi2yJ6cAPISvPfV3cjNn/3hrElAxqz+UXQd5AdiaTcpP/UuP
         KnKA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795397436; x=1796002236; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=PHYlamw7fybYjzeLc3iuK4CS+fPI6wiuuTA9v+wgAMM=;
        b=zDt5vOnDD2H4qzd/N8dmHIGTUelyXOXmMBHGqgW0PCGUKJYOLdwd2d3kOliiHfgxp9
         FuyThrAnnAeeqzkchp8HYJBst+B7NegooajutUdmwxDoBksQUoZmv7Nnmv4TkhQa/osD
         SFO9YlI0vG2pERyHJpZ1CM+U0ZQnCHK4BtvKSBwE6R1aKQhfnTBSM1ayCTccCeBtIxbc
         iavenGRulpJl4E2nnnzVwrWcyFYJ41L//MOZfR7Yd3ejyMpQnlOG8fst4S9Tk5j54Rft
         5ydOvDx84oCJC4rclDo0+AdgduXoYcjbiGYWwWQiDAsM4YReGO7d+MxYBJ1ecATl9dAl
         ywWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795397436; x=1796002236;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PHYlamw7fybYjzeLc3iuK4CS+fPI6wiuuTA9v+wgAMM=;
        b=aHOnOyTD9g4Ho6yS4pedybV654RAJDDcNyp9srnGqnp1Lhc2G4KhNh4YsLvA43Rw+N
         mnR9xai0KKAdISUQ6MdENRXEpdHmiWggDb/RjACivGg+MA+I6ceyEUhTFhX8bKUk44i+
         0sazw/H32hhLXGaJJDb0t2phMnf7Pil6M94qBFe0qw5nVYih2fiPmapvRbGt0IzHpjT0
         LQy5B4arDoKdFGxS0jmPd/sFH+jTFkRzu5PE1DPeDh+1K1rUktEScBRU1EEbPSOa+B5Q
         oA1edH2VqyqzhCMHAsdXmLiWgyaLqmp4NXrD570Aid+gHBQkjMZeB1XQZF8ntHSJNsHL
         oOMw==
X-Forwarded-Encrypted: i=1; AL+hErFXAM8AovzQ2f0E9vxfcp1PReTBWhaxXzcRozono7hxuEg9/7rgoyyzpwXSMKSub5jeldZt8bBPvg==@kvack.org
X-Gm-Message-State: APuU4Z+RDnaWXRIwvvOeqGitATAG5gmYEWJ9yPHAntJPVmRYzflN33w1
	Xcm4pIQpC0lQKlaalLrOsD/9D1Y9Xa+3FVfHbNGacLQlhEzhTKsCo2vzmYduHaYbq45dCu2WCoc
	Sjw5qg/PrTm+AufRXuEeVIH7vMjyMbbI=
X-Gm-Gg: AZFdTZdFq6PbxOhAiV6zH3f6fnNBuoKt2rQZAs3F9YYVrCUq05AeHSEXw389oNAhwMg
	Apn0q4Cghj+8eeFBrrFysQrBFV+Fm1RpYTp6JXTYQjEjU+ewI8dc3jp9HVH6GtJT7UmYUw4vRcr
	7cDMRHjJM8wkMQg4X9oLpcRemMbrO2U8zmZuitPoLcXoZqMjTPrjU0N0g+K/zhn5glpumoP3fZI
	feL+KQD5xLEj+UKFMNHbOGZjqFqo65iF7tCOc1QQ66EXik1CJ7vt4edqa4ouf14jEfPMeFln/Aq
	Blad+2d46+ZIH5Y79gquD1fEPq62UEBgjp6iWhQMSpJAaFb21V1F8WEQiqKRskWXmsbNU+0qYyk
	yabeL8hilQ8QBg+5hbltyVEfk19RMj86IbmOl6PHeycX44Yern1z1RZj/veEkCEwW6ICOsS85K4
	2GBNgAvzdpYDuYfFg4xGKiXSmg4Pt5v0q5S+MU0ZxETcfv104DclLcqe0jFcKsaPrOF92YM1rK0
	w==
X-Received: by 2002:a05:600c:5395:b0:4b1:4017:c4f4 with SMTP id
 5b1f17b1804b1-4bb8880ca2fmr202326895e9.20.1795397435229; Sun, 22 Nov 2026
 17:30:35 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com>
 <20261119-mglru-fg-v5-17-9eee2fe97a2d@tencent.com> <CAN_Opa9APLNic4cnohrtZ4-HcdoNvSFvnAKiC6nn+C=thbTAAA@mail.gmail.com>
 <awFbU_VGf0hotbyR@KASONG-MC4>
In-Reply-To: <awFbU_VGf0hotbyR@KASONG-MC4>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Mon, 23 Nov 2026 09:30:23 +0800
X-Gm-Features: Aa3M54otUxeoT9sHoHYTq2p_UuIGttJQaGd17GdUT_OXTaZ8k51r48Rl1cQl1ww
Message-ID: <CAN_Opa9ppGsKPhh1jmveYDCwHgZtv0Tm38FB2WoAjTtOPMmpmw@mail.gmail.com>
Subject: Re: [PATCH v5 17/17] mm/mglru: make folio_test_workingset() work
 based on folio LRU refs
To: Kairui Song <ryncsn@gmail.com>
Cc: kasong@tencent.com, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Chris Li <chrisl@kernel.org>, 
	Baoquan He <baoquan.he@linux.dev>, Nico Pache <nico.pache@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Chen Ridong <chenridong@xiaomi.com>, Tal Zussman <tz2294@columbia.edu>, 
	Xiang Liu <liuxiang.277@bytedance.com>, Ehab Ababneh <ehab.ababneh@intel.com>, 
	Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, Lian Wang <lianux.mm@gmail.com>, 
	Joanne Koong <joannelkoong@gmail.com>, Hui Zhu <hui.zhu@linux.dev>, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, damon@lists.linux.dev, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User:
X-Rspamd-Queue-Id: 8538E4000F
X-Stat-Signature: xf4oyxz7p3b395eattzr3awha6db8g4p
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795397437-470645
X-HE-Meta: U2FsdGVkX19jrbwhiC7XtMIlmki0t3uFZAgAPCDNSYokvye4MckJDajKG3a/cg7FEOu9wDIRP3yYT1Nx26x0AkQuXun+KAk62/gN1UbQSppUR3tzNsI+fJ4gaGRfxtikgWGNiV41GZXM2BeHx/WpOd2uUcLpabkhbDt/R6FGMtkWsKLUE0E22dZjuWoeunmLP1uKUvs4xble+bISqn4gbPEItVGTLdNz4DJeCnKtATtwn9YW6Y37lSSnSEK8qojOn1UIBN/V0g6zwR3wxyMV2BwQReQDQRVNCVranU35JUng2KiN4r6AVnGWVXP46lHRVjLn/L/N+0ygWudSdROR3fcMO0UTm3Gc9NkRyiV2NaM2511PNhGTD7mMuwe5W6+eDol+17+gOJpgriroRe2XmYkFNBNfqTYpGHVaWJ6G5kh2HHvjhJ5zBMPtP7jlc6DZCc9agrRx0F1nDUn8Rla1oIRJAq9N+rGX76n+Hi/j9SLbaaumOgCJCoEygs8rna9Dl4jQJbKNzLirh/Om7d/OV7fTe/qoa6q/uHXOi5qDiIFXR0TWG5pNC8QGxMwQ3AavWcP3tXTckYm2fn/51RfSUT31qFQqxFc63FG+SUn6gB1OqrXtOABGQAxcwCq5h5XanchhY1bwdHhH/wDz2aem8Akh4cXFnCOPCNaci6RIDrUf2dVnmZ5uJNWmTyZaLDIn+RgArNFHXByj3dhMq8c6q5zB3iiD5Sx8tkWAvU3sBStLMWWrrH3Fk3Wvxl9ocYd5svAmzNYHCEmszPnP4ErONsCguReXTN4z+am7U3VKvA4LeRZB3jWYAMr8FPdsc4QE9Bmko59qLj7qddLepjd2a5Rq0/s/jm5E1+HYIYDjT3i6CtjwtsLqhXju22fGBkEAZYS8Lr0MskHFQOq88LyXQWF+k9HHEY5/SLYT+YC1KxqwFbfuZpKWrkgJ3evIgRmeRFIUNb4K8FFHyS+xMKT
 FQw4k0fg
 B2RbRsfxGnjGAaSzjbKCNNYxbM5dFm2C0SP33c1hBV0EKcX7X/uZQj9eBDglf3mSuQ/TlmEpaFZAZCpA2Km66yhEn7xVKvJEzbShLgfopk0Z8vwG7hNoeY0fjivjHDUOY9eTZ9YbGyW7NaMTsz2ovAfPsJKddfstCTDma1JqTa6mAu64whYSbDzkBem9e+WpO8spK8ot9BCI2859G5RYZgs4bjk+1N2EmCGwGn1FhGch5O1v2U9FuKEuUpDe7JYZGdl/P/Tvu3lBuBhuPOaNoQbXWU5/F+CwgFhZ1SB9vyhhWJXt4U2by2XMvS9EmbYsQ8oVzW49qJV4/MJzg0X91Se/DQhQIT52QEQ1cwGcfENfGimVhu2SIcYD1qXOeR0L0TNXeC6qrGAouxrMdGLiOv1Pj5vkjj+gIDXwsGBDm5SD8ofsohK2hvpyf76WifFpyxQ7NID3vDsRBgurP4ddKpiRGzSjpOUssrZlsgDylOtUugnl3lRS4FQe+KNzoqfOYHMZ2qB62DuaNfSAmVMXL7TdCu3/yAVPsCSD3JkMPgtUZbN0ty0skRfjQslbK5dlccuFWMhRoR6JhbaB3yHbV2bzRWvxMRd2Vvh/iE0jmM/bOJJL9G+jRDFIMQ9landvTJBOWB9PAUyKeVBEI2URVhq2h3tHMYKUtaJ+6IwyyjIuj4wLACRAV6tBa7AIHMTDycS58klEM3SvlJAYi7/jUnDSFaAYPyHm4sESz8i/WrZ7pFanZIt8dk+VpPGfFJuVy7Y5MOOq7D06u+6/IyhTFkrBZT8GRYubXmtXCU1J47J9SAtu43DLBLwkLQUkAY2a9MDg/vJhUrXhH7qcC6iSyea6WmMR7FLJelGCU5rRxk70Yxiw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 22, 2026 at 4:13=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Fri, Nov 20, 2026 at 05:53:36PM +0800, KunWu Chan wrote:
> > On Thu, Nov 19, 2026 at 5:04=E2=80=AFAM Kairui Song via B4 Relay
> > <devnull+kasong.tencent.com@kernel.org> wrote:
> > >
> > > From: Kairui Song <kasong@tencent.com>
> > >
> > > folio_test_workingset() currently tests the PG_workingset bit, which
> > > is only the second lowest access bit of the folio LRU refs count now.
> > > Folios with refs 4 or 5 carry it in the LRU_REFS_MASK field
> > > and no longer have PG_workingset set, so the bit test misses them.
> > >
> > > folio_set_workingset() currently sets the PG_workingset bit with a
> > > plain set_bit(), which also over-promotes folios at a higher refs
> > > count: e.g. a folio at refs 4 is bumped to refs 6, advancing it
> > > toward LRU_REFS_MAX and an earlier generation promotion.
> > >
> > > Move the test into mm_inline.h as an inline helper based on
> > > folio_lru_refs(), checking refs >=3D LRU_REFS_WORKINGSET.  The set
> > > stays a plain PG_workingset bit operation reserved for the
> > > classical LRU: under MGLRU the refs count is maintained by
> > > folio_inc_lru_refs(), and now triggers a debug WARN when called
> > > while MGLRU is fully on (the switching window is exempt, as the
> > > classical paths legitimately run alongside MGLRU then).  The one
> > > PageWorkingset() user in erofs is converted to the folio helper.
> > >
> > > Under the classical LRU the refs count is not maintained, so the
> > > test is equivalent to the PG_workingset bit test, which is the old
> > > behavior.
> > >
> > > Tested-by: Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>
> > > Signed-off-by: Kairui Song <kasong@tencent.com>
> > > ---
>
> ...
>
> > > +/*
> > > + * For the classical LRU only: with MGLRU the PG_workingset bit is
> > > + * part of the folio refs count maintained by folio_inc_lru_refs(),
> > > + * and a raw set would corrupt it.  The switching window is exempt
> > > + * because the classical paths legitimately run alongside MGLRU then=
.
> > > + */
> > > +static __always_inline void folio_set_workingset(struct folio *folio=
)
> > > +{
> > > +       VM_WARN_ON_ONCE(lru_gen_enabled() && !lru_gen_switching());
> >
> > Could shrink_active_list() still hit this WARN after the switch
> > to MGLRU completes? It can reschedule after isolating folios and
> > reach this setter after lru_switch is cleared.
>
> Hi Kunwu, thanks for the very careful review!
>
> Right I thought a lot about it after your reply, first your concern
> is right, thanks! I should just remove and replace this WARN with
> something else.
>
> And in theory, we should only call this for isolated folio (for CLRU
> it means a folio moving out of active workingset, isolation is always
> the first step), so this helper is fine - except, for the MADV cold
> case, it will call it on for a on-list folio, and will could skew
> the counter and if it raced with switching. Switching is so painful
> I hope we can get rid of it soon :/
>
> But, good thing is it's easy to fix, we just need (part of this belong
> to another patch, a trimmed diff just for reference):
>
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index 4f65867446dc..c936d1fadfbd 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -261,8 +262,9 @@ static inline void __folio_set_lru_refs(struct folio =
*folio, unsigned int refs)
>
>         do {
>                 new_flags =3D old_flags;
> -               VM_WARN_ON_ONCE(lru_get_gen_flags(old_flags) !=3D -1);
>                 lru_set_refs_flags(&new_flags, refs);
> +               if (lru_get_gen_flags(old_flags) !=3D -1)
> +                       break;
>                 if (new_flags =3D=3D old_flags)
>                         break;
>         } while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flag=
s));
> @@ -569,16 +571,16 @@ static inline void folio_clear_lru_refs(struct foli=
o *folio)
>   */
>  static __always_inline void folio_set_workingset(struct folio *folio)
>  {
> -       VM_WARN_ON_ONCE(lru_gen_enabled() && !lru_gen_switching());
> -       set_bit(PG_workingset, folio_flags(folio, FOLIO_HEAD_PAGE));
> +       unsigned long flags;
> +
> +       flags =3D set_mask_bits(folio_flags(folio, 0), BIT(PG_workingset)=
,
> +                             BIT(PG_workingset));
> +       VM_WARN_ON_ONCE(lru_get_gen_flags(flags) !=3D -1);
>  }
>
>  static __always_inline
> diff --git a/mm/madvise.c b/mm/madvise.c
> index bbbb729ed647..a73d89a2ecca 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -374,11 +374,12 @@ static void madvise_cold_prep_folio(struct folio *f=
olio)
>          * as a workingset refault, and the referenced bit always needs t=
o
>          * be cleared even for inactive folios. For MGLRU, MADV_COLD clea=
rs
>          * refs in folio_deactivate(); MADV_PAGEOUT handles refs after is=
olation.
>          */
>         if (!lru_gen_enabled()) {
>                 folio_clear_lru_refs(folio);
>                 if (folio_test_active(folio))
> -                       folio_set_workingset(folio);
> +                       __folio_set_lru_refs(folio, LRU_REFS_WORKINGSET);
>         }
>  }

Thanks, Kairui. That covers the shrink_active_list() case I was
worried about. With these changes folded into v5, feel free to
add my tag to 17/17.

Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>

