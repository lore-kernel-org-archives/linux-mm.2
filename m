Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E5C0606A32D
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 13:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=QtWASRjj
Received: by kanga.kvack.org (Postfix)
	id 785576B0A22; Wed, 25 Nov 2026 08:52:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75A006B0A24; Wed, 25 Nov 2026 08:52:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 671B46B0A25; Wed, 25 Nov 2026 08:52:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 372626B0A22
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 08:52:07 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AEBB1120E4B
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 13:52:06 +0000 (UTC)
X-FDA: 85473780252.02.3210CB4
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	by imf31.hostedemail.com (Postfix) with ESMTP id BEFBD20005
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 13:52:04 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=QtWASRjj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795614724;
	b=7aiCy0cAKjPXVCyl+v7B38j/aa5EkV+4WzbFPTFAPnjRC33TOnznMxOSn9oycboFBu4hpy
	KhpKhmbDdNJxcUtah/i03yVLDkwBolCwckmcgBXf97hcgIl85u2i0kTPvXapZXJAEzAcdJ
	ZSQsGrpTsA2ahKNF8NJSnlFhna4KGe4=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795614724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5FkHuxjNkBWcpazSUQh3/1ocxLfgOD0ATmjtxGIbMcI=;
	b=j1YG+5kww26RUgr9lvgt9Lm6JN7rwJRUOjd2Rd0/haa0qcXd6zbXFCCczsTlgnmvuVrwbn
	19UwDJDOWdocs5s+fygsBlx7ozFIxstflExcuHC+XsVCOvxUptqEuYu6T8KzHNxzQUFUnC
	cGY5st3N6ANEj1VuO9Y+vGM4lJTyiSk=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=QtWASRjj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6b4bd3d98bfso7373549a12.1
        for <linux-mm@kvack.org>; Wed, 25 Nov 2026 05:52:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795614723; cv=none;
        d=google.com; s=arc-20260327;
        b=OBh6iqkw9uXMatReZQEQgVv9MoJzfZ4z/kKUvVpKGpq4B7wDdMOUKBsjHYAlKre10t
         BgXhJKu0VfsbULGVbzPz+EzZ2MoOjjbnpVP2xXAaVAQ5hqvJvVl24DINqk5Wss31b8dV
         Rfju9N0BfTpt63LY+dA52AQYShn/mR0KoDdMNaHSNCnc+oMXFEPkMsWKZ2SMlRUM/7Ec
         HHiDdVXGvGtzN0iq/N6m0gAIwLG9nAtArMqdanmP/PRJp9Lrwhhp7Suvw7sftaxDNja0
         pKY0suWlI6A5rapfPUXVOhqvQEgku8+7GogfpsL9XgMfxTADERcP6InpFGB3ookyHAlG
         2tnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5FkHuxjNkBWcpazSUQh3/1ocxLfgOD0ATmjtxGIbMcI=;
        fh=aeUgo5tO26BOvI+dB15Jx68m9yedj9daZTDU0EM+G5k=;
        b=EfDpo8CJwGFhsYlM1wrihFaX6LhtUcVTq3pgDenq1iSIO36icZV8BZUTxi75NEgjgO
         EkAmAjhJbSxzh4KeTk9SspCE0UPpGg0hubOkT/QxbAjprDFN3d5pFTKTRaMiqpn+GIPZ
         j1HynoG1blF7L7YgkychzlClLlzu0rEK3tPLFWwrpNc+tRQW3nTSP1kTieLc21I6JF6e
         DTS2I3qOXj8rLsh4kbBkhg+tLAIqNsfyVJQBJvQgxcwtHkMuiigqAj4lp9gQI8d9he/J
         NSikLRGIabrMdszdRf/OZR8wtJaUHzo3YJhvPz9HnOnxDcygFjXfp5i3lIRzrjbwMN76
         BPtg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795614723; x=1796219523; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5FkHuxjNkBWcpazSUQh3/1ocxLfgOD0ATmjtxGIbMcI=;
        b=QtWASRjjSqW6xYoVqvGz+n+4Jw+Ylp6YVyaJbwXe35uilxRdUeNs+hNVglC8heh5v8
         HkPyHPeNfEoEO/nGKegrByeRbkxYAAZ+eGENNsV8I7qXyrI10g6XqbB3UdOJVGgdVYL2
         TJNHAtcSCOiwj23iXErKbe33AB2/CgVBiliocG+VkniuxPsGn5snN9mtkTZkWCzqnxdi
         EdVRo0Gfk4hju0OqBVZ5UD5sXL7f8asJabJJKStEaD5X0+755lAoLSFgZ1S6X4ukwvlY
         RQj0wpP994Lc1FjS7ww63LMtIb0gFT03SRG1YfXCH/ZLvv2xi4LzcHHG65RSHYLQ9/Vt
         S8Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795614723; x=1796219523;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5FkHuxjNkBWcpazSUQh3/1ocxLfgOD0ATmjtxGIbMcI=;
        b=l18X6smiKartrytKvWLba1+y/uFZiOFS83UwrRNWaeqarFu99EhONGC1sNmiOnAMOx
         ly9uq7Y/ONq+LiEEdiJIrHHtnXbABvgzdZwg0+Kydu8ayQyTXuyLF0XtSrGe8MqsPGOY
         74nTs2G1f4RgEmIj50BN60qohJDHk7AMW6PxsleWISJXh/IbDODOonQQiW4jUFwMXGy+
         S9lYj9RskVTTdZgsZ5QwHhD2fo9WmxvNuW7jwtgxrJ6vO+mtZztl0XlaM2SMbUnefDay
         8v64bUzl9cG+DzagYqE87CAoDCyNK3BGKZ3J2A4ko4UFN8cO2pyxMvaiOk7IUiPGEQ8J
         X76Q==
X-Gm-Message-State: APuU4Z/UcOmZ6H/+PfzJm6Sry8HV2n3XLlbtb9IHSILvkDY9AE0YiJGJ
	F6hczAOI2gBkrYDlfnYEHhL6Ef4ae+PJh0BFHjFvBbAvikwAMeWEgpNmCBcrFXNEszj5Ku/rRal
	CMgRqOGfcALESi8d/XMKKW3iB2jeyMvs=
X-Gm-Gg: AZFdTZeqXAMRdHUfQNplRMg7EAdTdeXLdM0wztGPKrUbBdfTlV/BYrHUqEdTEjFTY7M
	BsP/xfTn19e0RUqV6DqrXPH02NVhtyJ8asp1UahCf+1CtxAnKw0xaBJK+4Vx6GdVRzSnDA88Utk
	bhs1o2j11kY2EHvi87i4ZOmUFGnuAuwX3AXWvLqaMF3yTLr4vnPIYUmzfZ1PsIz5sNSHTud37GV
	wp9XnuyzQDdsMHTK2gmRrSalGS3ufSwCsmCK71a+u8hKWtNlKA9lJ5H27Roj0twXHDkjFftCY27
	qb6H7NNyAKXwNY8PfXb1IwE6jVX6WbZ7EXM6X2ai1eW57NMjGKz76tY7cT5t8tPKiOqoRQg92Me
	ZsKikc3SNReKoSeUF1XZ45arlD01VHLNmeIaEfC6/O2KSer/AaRW83M2gu+0rGlnb2JiSBw==
X-Received: by 2002:aa7:d355:0:b0:6ba:3867:42c8 with SMTP id
 4fb4d7f45d1cf-6ba38674444mr9425076a12.30.1795614722953; Wed, 25 Nov 2026
 05:52:02 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261124-mglru-fg-v6-0-8ffea39934a6@tencent.com>
 <20261124-mglru-fg-v6-13-8ffea39934a6@tencent.com> <43abc7c4-c435-48a9-8dc2-616095105d45@kernel.org>
In-Reply-To: <43abc7c4-c435-48a9-8dc2-616095105d45@kernel.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 25 Nov 2026 21:51:25 +0800
X-Gm-Features: Aa3M54qvnrtyAcMz5ZXrISSFgrUyQOGr2UM6VAg_EqnvxKpfk2xtM5m2ePfgGd4
Message-ID: <CAMgjq7CQkhA94QxVcdHzq=DD-6LCihA+psL1n-K05sxCffBOVg@mail.gmail.com>
Subject: Re: [PATCH v6 13/18] mm/khugepaged: convert to LRU refs based
 operations for MGLRU
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
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
	Tal Zussman <tz2294@columbia.edu>, Xiang Liu <liuxiang.277@bytedance.com>, 
	Ehab Ababneh <ehab.ababneh@intel.com>, Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, 
	Lian Wang <lianux.mm@gmail.com>, Joanne Koong <joannelkoong@gmail.com>, 
	Kunwu Chan <kunwu.chan@gmail.com>, Hui Zhu <hui.zhu@linux.dev>, 
	Maxim Muzafarov <maxmuzaf@gmail.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	damon@lists.linux.dev, linux-doc@vger.kernel.org, Tianyi Chen <hi@tychen.cc>, 
	Ridong Chen <ridong.chen@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: ri687qxzey4p37npp954w5o5mp8pemwf
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BEFBD20005
X-Rspam-User:
X-HE-Tag: 1795614724-280816
X-HE-Meta: U2FsdGVkX1/sKdr1jnEn4RIqT02J9FkOj5shAdyVQXYCVWq8Pimimi3lY9eNGJXacIGEnPWiLHewYjPw4lvNJ0W9aqmWHpr0ySE+w3FuMKx7ZusSwQP9xefSuYvfEofhmplaSWd3TmuvLbuC3tZNwvWRUi7pALSFkYiru4zafcgWA4wlL+1XiDJsrzI09H6k+hqrdHsQ89yagXJqo7zvK7PQMSMwIG6dz8uR4pYt/OVsDa4kr21pkanfgZky9chLE3dAIcL1u+nhxVBQw4T9sq2HWuysRhY0wkJnfRkqJEdprgw08YsrzDKn+ZW6xcpdbrIHlFMPTIa5720SWH7TCYfVEKUGjgkV2uUw7L2MhFjTJYryR/KWS/bmfGPG23KLSFtyRgWItSfh9IpE6tYqf+hkIjIfOiTcy//FKpOmEBtcq/BXfQ/DvQEdrdt8G5+8QbbHwBqnGQr8+kcQ+YUqmLa8gWtaU0dY8EnoZtV3VksF85EsjB37Mas9IZdnNB/OCXM8SDMtxsdefRBAIuknM6jzdrKZYyNLcRbWiahOZwekZBYA+/nCKk259V3fYnVD2E1za0/Rgldkus7WM3taRC9d93fKuKZXBQfVfcjFK+mqoG+mPjW6YqE+mLcBxUyGTw3TX9w3sd1au6gNEInyXJD1OVQ/j1R6zZEJspxrTlhqddNV4DHy7QgtJ/bn8ws52CGosHNaMVVgGvkNJO3CSSY1sYJi9PsIF67JvW+3+YtLWU8MroUI9QCrg3KZbQhZ7kf7GTU0Pq7l7wuGQ1Opb/q3kvN+4S2n93nIEgQt2nnFTzjVRB6qnOG3u1b6t8rp3SzS6eTcSV9WIId/WEee97pIFue/7hpUVbajNnnrXMlQFnNc8dcpkUj6FOgF5xCdzRblR3y9gsp7+5SqErM28+Q5tgq5R5rBDFigVsgdShxH9Bjb1wr0SQ2zssIgDFnxKnNNmEKhXkVZ8LQbA9+
 CT+C2w+H
 gxirzfQQXi5tRTFavQBqjQLNHcAqdTSLKIjUAuZLBPqks2isr7a97MrN8iWzAOCXkWfrteGafZhdzV05ZKMWDiW2azZDriIvJEbU7b3KjTHueqfaCBMVL5H6a59dcVM18n9OEhvpBL4zGTLNxcvWG7mINtIpNJhnrGBVygG3c9uCIZEFP1NWx23KM1aZBB/hChtYe77l0oq7+aL1pid1WL03/ddvBZFHfafkMT97M5xiL+O29bshKmZDdOSnBa6eeziTzE8ERgLZ/WiLHOD+zQyjPxgMWqOlNzq1JG5rjhBS9e38OePfZs4CyU6h+qFbPnew+HQp0sWJfWwMjt+q1FbDtWacLsj4+DNy6Cn6ATLHQ9qU8f3Epei8MCw23P0pKnnJkIBWyBhXeBxvC4SUOAumQ/nyxvUNvKE3xVLQwavAvfu9LOeYBK/C7Tg7t6/aSQjsEGvgtu3dYQNRwCpEqQH5MmMB+Xk17eLX7yha5MGCTeQU3GxlMb806BxB8d4EsYm2wgLXPQ6hct/oPXuEs/iIl5JgycCqobuH/5fBG1uc1CEnPnntmbQXR1mGNQT4/9MnuQOsaPSjwgOUPzM68tqPNNTwiKDU4nd/QkM8KO4V6+NjzArdD9sujgXjeGsOFakNnDYykS3eGypiWphszw89iDYClJhtNnrYa4uWnfdbpMEEmpobEHhoXN7bWYiy/giP6PbaWD+BsQu+EPYHUjlk/9WA67Dn5hpAq0bopJynMhT2TaFuOdoJxSwBSkY1e9cebmPvFMCEZ0y6beSU9VL2P241Ng9t7r6zSKZKajqhi2AQ1PrAEC0Wg1ntFzkLHy7NEbHG0UrpoPIXsC6Ko/0sftaAiRZDGIH8sAD6cDDmdlmALCMym3hR7CdEyJcKkoF8x
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 25, 2026 at 6:11=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 11/23/26 19:53, Kairui Song via B4 Relay wrote:
> > From: Kairui Song <kasong@tencent.com>
> >
> > For MGLRU, PG_referenced is only the lowest bit of the folio LRU refs
> > count, so folios with nonzero even refs no longer have the bit set.
> > folio_pte_referenced() testing the raw bit misses hot folios at
> > refs 2, 4 or 6, under-counting the referenced folios of a candidate ran=
ge
> > and aborting otherwise good collapses with SCAN_LACK_REFERENCED_PAGE.
> >
> > Test the refs count directly when MGLRU is enabled, mirroring the
> > smaps conversion.  The classical LRU keeps the plain bit test.
> >
> > Tested-by: Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>
> > Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
> > Tested-by: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
> >  mm/khugepaged.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index 2dc4245814df..5e768481ac22 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -579,7 +579,9 @@ static bool folio_pte_referenced(struct folio *foli=
o,
> >               struct vm_area_struct *vma, unsigned long addr, pte_t pte=
val)
> >  {
> >       /* The folio was referenced previously ... */
> > -     if (folio_test_young(folio) || folio_test_referenced(folio))
> > +     if (folio_test_young(folio))
> > +             return true;
> > +     if (folio_check_lru_refs(folio))
> >               return true;
>
> Why separate lines?

I thought separating them would make the git log easier to track if we
changed one of them again in the future. I can change it back if it's
not helpful.

> Also, is there some way to abstract this that core-mm has to worry less a=
bout
> the details?

Let's just move folio_test_young into folio_check_lru_refs() then,
PG_young is page idles's hint for LRU, so doing that makes sense.

And with FG, I think we will soon be able to retire PG_young
completely, page idle's feed back can just call
folio_inc_lru_refs(folio, LRU_REF_MAPPED), save one page flag. But
can't do that yet, need to cover the CLRU case.

