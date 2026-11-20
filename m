Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47215606A330
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 11:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=NSedN6cw
Received: by kanga.kvack.org (Postfix)
	id 56B3A6B05B2; Fri, 20 Nov 2026 06:16:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 542A96B05B5; Fri, 20 Nov 2026 06:16:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4319C6B05B6; Fri, 20 Nov 2026 06:16:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 146AE6B05B2
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 06:16:54 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9B57DA8DD6
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 11:16:53 +0000 (UTC)
X-FDA: 85455245106.28.2E8E925
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	by imf11.hostedemail.com (Postfix) with ESMTP id 84A4A40002
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 11:16:51 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=NSedN6cw;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf11.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795173411;
	b=E2j4aBug2D0PcVvZk8F7roIiLDa40kFPA0euEGFXWETH/5lWzsxaE/w1MXtCq6dU9p2v6i
	uR6Gla0oWU9oAwY3sAyYCYMgF2Dw6WAp0SqOPQn18US2DQIFzb0Yeyaba9dG2SwGYLB5c0
	9ie3Lq05xXUDWH7OeofQHTw/uxJ3Aa8=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795173411;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0NaMGQ4Owpl3Co7yhqKVZHVr+kTFNUk1Lb3ecw2usVA=;
	b=LjYc/RqCAeYkoudRgCZ7PmohJz486nBB28wakDezabsABP+AU8UIh116WgcvbBiucDIerF
	i424lOjTnO90zZoybph4EWP51eo5sMwdfEPur4NInyhxts+72T/hG5hP4CiDw65UOh2SjP
	Xer+nlELxpeE93/fdd5iN+BjPo2hYCI=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=NSedN6cw;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf11.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c50cc8e0f84so127006266b.1
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 03:16:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795173410; cv=none;
        d=google.com; s=arc-20260327;
        b=U8J/vkhaH3agaO52PCDDmcXVI7HbKycacUduj3ncxAR01VTBdoG0F1cDrQe+FbBRNl
         v75KTnrpkG/+Tj1HPkh9LuFNxmSS/YJXzsSVU2SboRQTLM2Dl3pRzlEVf2ryx1Gnvg05
         tG1wjckVnMk26wJUHRebkO/+mu0+YnMPDAbCoHU7OXWIOeeRUkWYF8xPzW2lwLMyNpFP
         wu1y1IxkOA4RTkrJi31jYZYMMgc5OJ0NaRawbBlOqRNx9C1aU/WPsRHcetUTU9w+pPli
         d61FpD29JfGKfswx7eI/p6ts8aUZV2Ek4J5dINEh2R43ShvA0YgVjxTxm4Pk3eoW8fe8
         vBjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0NaMGQ4Owpl3Co7yhqKVZHVr+kTFNUk1Lb3ecw2usVA=;
        fh=IM0J8HdMkFaLE6G0YeTCo7MucjWIGQxjm/SzcyQUSbo=;
        b=OsmvxXDJMaXUUpQBl8qOPEWHN6pBovhBFbDHmcBNXRsZqz+qFgmuiQvM+l7ZVOGQ97
         2cKZ8Xkj94rOv8+lpDiOXds0ZyQEzZIviW8Obrryn6vZFj5Ic1CjQpJwjWjYjKGg83eh
         YaLZkbjGc4ZzwI4XtPUMmQbvvmu+9R7prnXVwuIYpGZfLXUWwtsQlVY7An7XE2/6IR6B
         gweSVAykD/zETjj+rHgE9ggcfcFxqoUX0/8z02P8N8LhWFW3sTDba1/EL7iE9TlgrdZy
         FIiRd2x/QqnYJItkcVCagaoooZGuw8Tvdjn/7tZ5E8qo5gFDOZq3FSy1oGfHc7f6SvRn
         nMvA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795173410; x=1795778210; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0NaMGQ4Owpl3Co7yhqKVZHVr+kTFNUk1Lb3ecw2usVA=;
        b=NSedN6cwyQ0RplvZSfCJeuN4C8UtaAVXrphiPKMXP38b22kMa1m7IB28v+YqW1Srce
         m7jnHiP/E+d4zFXn/FmaXblO9VZOCSkl7rbYuthimVE6QCCgQ1oDZTboMexwE4Z9mnIG
         awwpbU+MZm+TDz8xn5+vUDlvQGmaNbHhbuNVYb53eCNmNlSODl8AYPBlFhFgwAuAm8MB
         UeI7Hw4CDKQdpIFCOGAjfY3mpNwpmE61Z618+kqx5E3nM5IxaLOGaP0MUU2RHn9FrjZS
         QfvZYsluNiHZDzKR/9aWpe8aarUVsvG/AIDOfHHoOmUXfo5bK1eLEF1fcCXJMBFCv/oE
         M6vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795173410; x=1795778210;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0NaMGQ4Owpl3Co7yhqKVZHVr+kTFNUk1Lb3ecw2usVA=;
        b=HLmH2Aj38PAMm98O8Itvvn/utsZQFYEwgkUibJ3xCjIk4bo1sU5I7Ru/3uvg+z9+w5
         LECCEbEZTA1c8SqpYxG1aKyhXj9dmihfO+ROhf4NYEsKVx5ZOQaEiuZXuEMPlleh74av
         gijHB1jov+JGomVzar3FxF/L7ALtOcSBGpjZ87XrCfqmplXZyI+s3Fv5pmOFp58W8AIA
         81fML9NaXzNuTgt9A0WurYeGGFn/keO6GfOhGnSvsAnEua69+W5/k5atuDtSZEHGrIxJ
         D+MMALN75/yr1k0z+3kCQiyG0q1dQUqIqDEXOyJUZPxI/ImAfaqjJhlxrjsOO2lN6uqa
         j4fw==
X-Gm-Message-State: APuU4Z+jePSSeOnkn0/w3hbavb6DWF/d3FdhvwhlhAmSj8l3Jj70s/h4
	qsb1XZ3Z7zslw86x/VMzNwoi6nb/2hdMKOxVG/t79wCKgeBofc8q/h28A4JssrlGKgV/RmMropB
	jLuOsyyhobQSYwsR5ZqIjY8N1DYBI718=
X-Gm-Gg: AYBFou0NIe0UG2Q7hm3DCvUDwcVj45Dr7cGz+i8lAzB24AdNn9npVUxCrypmDc4OH7R
	MzzG+vBHttv7feAbmXcSb8WvqlOEDzSu9eW9pU8f/LVPWxIDCuMI7eFcTS4l8UJpedj6W9BdOd+
	SyRXbUty7Putz6JVY4jiCn7PKaRNs+f/efBEHGdwaj6dpSuvu79U7wLkfdU6mO9oDftqfzxfZmo
	Jb8djRtHCZY1npfJ4n5ixMwUCPcyvfBZteCaTl8CGEwB0Wi+XgB8u/kP1Yhbv7Mr4WyNwOcyjqU
	diqU0R3qxkFkO0KVdN/sNHBFa+k2NaxKkYsssAQQNk+i+1NQe0XlPJdKYKOOoMO9sL/2El6rMuK
	n0JnMGi1sQ60/FVKfL5oQwtEjZE3ZP3ujN6MKaCNhce2bDKHGt3aylKUvtpQ3HjHCx5sDCw==
X-Received: by 2002:a17:907:73cd:b0:c40:38b5:d784 with SMTP id
 a640c23a62f3a-c513a614467mr280155766b.22.1795173409664; Fri, 20 Nov 2026
 03:16:49 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com> <20261119154001.9b9f953136935a09e8a50af6@linux-foundation.org>
In-Reply-To: <20261119154001.9b9f953136935a09e8a50af6@linux-foundation.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 20 Nov 2026 19:16:12 +0800
X-Gm-Features: Aa3M54pc2xETNqoexA8P5jVd0jSnzthhaZdG2Uuuwphbutgg3FiGQAMnp8Ovueo
Message-ID: <CAMgjq7Dd=Y+GekSD9WO5oGdoa+S1eG3T-U=VsCexopvb723zFA@mail.gmail.com>
Subject: Re: [PATCH v5 00/17] mm/mglru: frequency guided promotion (MGLRU-FG)
 and flag cleanup
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>, 
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
	Joanne Koong <joannelkoong@gmail.com>, Kunwu Chan <kunwu.chan@gmail.com>, 
	Hui Zhu <hui.zhu@linux.dev>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	damon@lists.linux.dev, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User:
X-Rspamd-Queue-Id: 84A4A40002
X-Stat-Signature: hbodzx3fdfi5ccq9xdbnie1nwt33ky4x
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-HE-Tag: 1795173411-646900
X-HE-Meta: U2FsdGVkX1/U9o/ek6OzNIglx8slgO0k4XrrvknXW0p5fXQ/JepZi0mbhcw7/Kea9+yweQbQzl40Izjb++rRj6v71X+3oH72imi2BfDphjt+COBJfD1uucBw+r4elvdlE+WyYRzR9v2x+NXoM8wT1mvzH6sC+c8FDto4/a7awNDGxdVvoqo0fDUFop30EeKPwPpBoOyMnpPm4hXcXdyDb78OMmskZm5YZPsI1dcR0qQdpjA52efvIC+7LO/7km2wLaAwVkK8rPiClGKTqgFOlEZtgp8ofga/fTFUnib3Uz2OlDOtTUir9l3cOFtcrIZEUHSAjIoatYqJowi5fCBQTE4xDSP7ZtGLz2lFFoejZNl0Ue2upmvUqIuIOEWShQ92TTP0acgrgv5Lpg07RqlfEh0uxKWufxkGgbBe0NF+CVNrsVg9uOhR6KyUwWWS6zFYio9z4UbzGjmZsbXdB8QHRQmL9nwU4EM3TjM6pz3aHg9WtmsKtL713FcT9BAq+LQRv/8VnNHLNZ6VM8CNZePWg3VRpadB5ejUw4h47gcPAB/uSq/hINFc93mcxPY6gmFrthq2ASWmqFPt0cgXGVSXDw7pdF4MvhicYBPWEuqIDoqK0ok29VnU5tMqL98N79BNo/RaIPWlX6t9q9jmLBnsTU7BI2nZGU+gMRogdV3Az9Gd/j1pmkOeqZuQWUpJRVkUGPQAJFexWT3/Fbjf1fmM8r8Go7ZIEPxb/hGAbk80blHeefcUPP1TBZPP2iiED3tKTP+A7+BbTawogdvLgVj5+HXAFN/tnVWwcI0kPF/joMHCnJaftBT1jCj+UG70mN7aiOrt7ufmIKD6FJ5tC7YazfWpslTQ/NBx/L7AbY0Rm76xQWEb3m+0A1fEJlO9f6EI9deaDAop35xTLXnr4qVJ1Q/gIF0dwjr6WqcU7lvqlrR7zIavELBUvVzn4wZA8QmIzB9rctwB7hDQWvg0YWo
 ly2lmejm
 3ehJZ/4nVcy0XA37xwY/9+DDUlKOyJp87BfKbw1BzKi/Ap1i8Ju5am2rdRNWOffswWGMylzc/CCs5jhjGan307+IWdZl8yZRCEXIccEDOa0J2EJYMngGrUiYKoBhVs7CWbTsV7CearvzE1qvcj5tg5SiwtQ2LH5SkRdTeRzR5fkmCkeqzCzaiQiV8tQeMGsm3DoZ2Smu4bLzGcCCNe4zGiENJ6pdSsAS92g8KibUDVbIqV7m+l5kt8Qh+znJ0iRlFcn327G596BCAAo9DFU39d5JhEuPy4j0egYkcToRMl/hgpF18Et1eOHcUGBz/OLjMJ423PscLvcvujt+I8Ja0kkbpcAUV8nazTPaNtirhw8Tvr5aon6sKqCPwyajRgKhLbOd8KY/0r1+XHI4G0XDmI/guwYjspKKx9gJUDuqK9XIvUj7d/nRVLJLeZh37Ge48vr6Secwy/pRIh4Kwc8KisREQEnpmjAL1Vlvi6FWLZhwAjw5gVZ1v20QD4ZAtPwH5nBFoeRIUXn+r3wQNF9Pl2khA3NrVvcby0JqXpqsKaLaeqMiqCNrOzuxFuoQ5VIlfNvM5XLhl75YizjFe+/NZ5rEfbEHhpijXOH81KyXeY5O4cVDjiiOszx2tU2tuVSLZuAm6+FBiAqf1j+00jYOVB/h06SwGUuVf21qkMnS1WdaZEv84GTSFD69NJjNu0Xm4Z77edgjyMU7B0cFAliheJCQfsm2f3khLA9KL8ZkWdKIVwiS0JiG+WVVPZZLbmsoIuX9y9tLB0oQCxWJNOvGbFWE+Gg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 20, 2026 at 7:40=E2=80=AFAM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Thu, 19 Nov 2026 05:03:32 +0800 Kairui Song <kasong@tencent.com> wrote=
:
>
> > This series implements MGLRU-FG following the idea proposed at LSF/MM/B=
PF
> > this year [1], based on current mm-new. Depending on the workload, it
> > improves the performance or reduces IO by roughly 10% to over 50%,
> > fixes multiple long-standing issues with MGLRU metrics, and drops one
> > page flag.
>
> This is looking really good - great stuff.
>
> Review is thin, so I'll remain in wait-and-see mode for now.  What do
> people think?
>
> I told LLM to put this series through its paces.  The performance gains
> were confirmed (actually muchly exceeded) and it couldn't find a way to
> break anything.  It found a smallish slowdown in writes to clear_refs,
> which doesn't seem very important?

Thanks! Glad to see another positive report. And yeah I think
everything is fine.

The reply below is a bit long (and 99% not LLM generated :-), so
TLDR: We fixed a long standing "bug" here in with a small (IMO)
interface performance drop, and that interface's user was already broken
(which we fixed), and I think the performance can be easily recovered too.

("bug": it's just messed up metrics readings, there is no leak or
race, just these values are just no longer meaningful in anyway and
are breaking real world usage, see appendix)

A slightly (~10% end to end, that one interface only) clear_refs
writer slow down is expected, smap is the only user for that (maybe
DAMON too but it works differently and won't cause this many calls).
However, the thing is smap reading was almost broken for MGLRU in
mainline, just like K8s users have to disable MGLRU by default for
years because it keeps giving gibberish readings (See Link [20],  the
refs and workingset are tangled in PID controller / aging in a
hard-to-describe way so we see seeing unrealistic values).

This series fixed that, metric readings are now sane, stable and
accurate, close to CLRU and provide useful data for workingset
estimation, so the trivial slowdown of a lessly used interface seems
very reasonable, and we only slow down the even colder hard reset
part, readers are good as before. (We'll also need to update the tools
ABI part later, but that's too long for now, and I think we can live
with it for a little longer considering it has been broken for so long
time...)

Meanwhile, if we want better smap reset performance (I'm not sure if
we really need that, since it is costly by itself already, a whole VMA
locked walk & PTE update per page, and ruins the hotness info), we can
do this:

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index a2442e49aca2..45808f7ae50c 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -562,10 +562,12 @@ static inline bool folio_check_lru_refs(const
struct folio *folio)
  */
 static inline void folio_clear_lru_refs(struct folio *folio)
 {
-       if (lru_gen_enabled())
-               folio_reset_lru_refs(folio);
-       else
+       if (lru_gen_enabled()) {
+               if (folio_lru_refs(folio))
+                       folio_reset_lru_refs(folio);
+       } else {
                folio_clear_referenced(folio);
+       }
 }

It should speed it up instead for most cases, I didn't include it just
to keep the code a little bit simpler. Smap and DAMON are the only two
users, so it's safe to squash this into Patch 10 "convert to LRU refs
based operations for MGLRU" directly.

In fact, if we really care about smap performance we should start
batching it instead of doing things page by page like right now, I
think that may bring a much larger speed up.

And a Appendix: Measuring the smap Referenced, and active / inactive
reading during a build test (LLM did help on this :-D ):

      =E2=94=82 smaps Referenced/Rss % min/med/max =E2=94=82 span =E2=94=82=
 stdev
CLRU  =E2=94=82  99.4 / 100.0 / 100.0              =E2=94=82  0.6 =E2=94=82=
  0.0
MGLRU =E2=94=82  38.0 /  99.6 / 100.0              =E2=94=82 62.0 =E2=94=82=
 12.3 - erratic and unstable
FG    =E2=94=82  99.9 / 100.0 / 100.0              =E2=94=82  0.1 =E2=94=82=
  0.0 - matches CLRU

      =E2=94=82 active_anon % min/med/max =E2=94=82 span =E2=94=82 stdev
CLRU  =E2=94=82   0.0 /   1.1 /  24.9     =E2=94=82 24.8 =E2=94=82  4.5
MGLRU =E2=94=82   3.7 /  96.4 / 100.0     =E2=94=82 96.3 =E2=94=82 23.7 * c=
haotic, almost random
FG    =E2=94=82   0.0 /   0.9 /  12.3     =E2=94=82 12.2 =E2=94=82  1.9 - m=
atches CLRU

      =E2=94=82 active_file % min/med/max =E2=94=82 span =E2=94=82 stdev
CLRU  =E2=94=82  34.1 / 43.8 / 52.2      =E2=94=82 18.1 =E2=94=82  4.7
MGLRU =E2=94=82   0.0 /  0.1 /  0.1      =E2=94=82  0.1 =E2=94=82  0.0 * en=
tirely wrong, always ~0
FG    =E2=94=82  24.3 / 33.5 / 42.2      =E2=94=82 18.0 =E2=94=82  5.7 - ma=
tches CLRU

Pool over 3 test run with make -j48, defconfig, ZRAM as swap, 3G memory.

It can be seen clearly that the metrics readings before FG were almost
gibberish, FG fixed that just fine. These are causing issues that
describe in the Link [20] above, and many other components. And they
don't write to clear_refs, they just read meminfo, smap is also
included here but less used.

The active anon reading for both CLRU and FG seems a bit low, mostly
because this task is under heavy pressure and aging/reclaming fast,
and FG also provides the way to tweak it in the future
(LRU_REFS_ACTIVE). And FG reporting a bit lower is somewhat reasonable
since it does reclaim better.

Note, the goal here is not to match CLRU, but CLRU was clearly doing
much better on this, so using that as an reference shows the
reworked readings are indeed normal and reliable.

