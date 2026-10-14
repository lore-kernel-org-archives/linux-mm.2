Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB005CC6B2E
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 19:54:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24C946B0088; Wed, 14 Oct 2026 15:54:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FDDA6B008A; Wed, 14 Oct 2026 15:54:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1147B6B008C; Wed, 14 Oct 2026 15:54:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D97726B0088
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 15:54:00 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5337514079D
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 19:54:00 +0000 (UTC)
X-FDA: 85322282640.23.E5EB5E3
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	by imf28.hostedemail.com (Postfix) with ESMTP id D6EA6C0002
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 19:53:57 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=PMTB3X24;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf28.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.41 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792007638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RjniCqND0NC3kKHSl3wLORt8DVjtH0W0kWfnOSpM6P4=;
	b=HNwj6hPWh3FWpAQrtS0jCV63ojWn4zHREqUEQn7fntCA6R/G8U47r8MT/ZXMxNdUoTNHHK
	pE3C+0B+gD88zTt1Y6WXFXLWCAQR8aqGDDczDRbKkrUmdgqJIoU/9fmlIoj8L1X7DzhixQ
	iE8EHsMIdAYSx9tnyWh7gGguoIOhJSc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=PMTB3X24;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf28.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.41 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792007638;
	b=WAnG1vqq3LYKO8eUQUA8wptuxkQVMlI3b4FW74I/W2JX5BysHF0IjskUnKyQqZXamImjkr
	m8njcuHnDwx7ECtvlM07qsDtHZgEMIERAXQy+nDiY5OWdMNlYrDi58I9HXZM4HWh9zUkPY
	2J++OTaZfR+/mTAg1q7SuDXbwIc+wc0=
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-91b54d1e9cdso7066926d6.1
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 12:53:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1792007637; x=1792612437; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=RjniCqND0NC3kKHSl3wLORt8DVjtH0W0kWfnOSpM6P4=;
        b=PMTB3X24KUdswEQMXQhqM0x1twOvEX87CYbpu6uPcPD5usn+Vjiww9koj/CMSxEJxl
         gT8rBrCNrDc/OZ8XZNMOTHP0evZOjo6lg8/tO8TGyxSKNtWl1cte74QJz042Yo2BOyfj
         Zta/NHuCZeIyBEk8qXVzSwnRk05IZR3er+pGIip+/0JaiMvzavHMt/vnCzFlrePBtK8t
         aIWOtWSDsqR3oFwYDdeA8Y72rtm4BEkv6POR9VJPw/0hj3v9UIkvjEzJMDNpDldIt2kE
         LndKRVu15/LCNuYmYB1dEkl4I9rTjFV7v0fAEKCN/Y8DQsKRxOD+FeHZGItIfwcDHsjO
         0F/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792007637; x=1792612437;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=RjniCqND0NC3kKHSl3wLORt8DVjtH0W0kWfnOSpM6P4=;
        b=zTnbLveHWTDAOjtsW98PNProvvceqbicfGQISW/5/6F1tsrvD2b6R7g0vw0hiaaPl6
         8mkwYO6IiLxB1rOrXlXcGixrmYuIrWPddNSCJPeczd65O8+EZxuHdLJ2GF+EJnmSDCQ7
         r1SPscBCwQ46I46B+/r4avCdOndK2KrDIytyIpP2LkhJlx4Obo+Qm36th7WkeJKTad+T
         MAmv7aP2ta/9CKFE2KXFihfxYX0o/XUvyXp4ZUVBgQFBYGuVf6Z6J1i6rMu0V7PBf1ch
         WLiA9hQV4L+DYenuHEE6NvRPJoAR9y1D3uoQjQRsl0XNqTPdAaFdtmqexhCTAW54jJgA
         91oQ==
X-Forwarded-Encrypted: i=1; AKwUvBwDmF8Ofnjx8v45KfVqmoXVZvs71MBXjIC45ktVOtP6n/8c0Y+gLOZqIRFi4jJiKhEpLDCmF8qT2g==@kvack.org
X-Gm-Message-State: AFq9FYI3pnaV0Wep0Aoi207+MUF9MDyzDeUSy6AXXKZHnCDkelANCWOp
	8hgM/verdBV0L3n/lqXc5nit/nJE5aWTmaRXTPdv9OEKuQ8/0BC9q4+o3GY93z7NgpE=
X-Gm-Gg: AYBFou3d/YP37QgiacP6PONnrYNSKOZI/J58JHazaWIUqO19y1De2Us+FK6ObhU+IX9
	JCNkR7MvtKKfPfsjr194Yoay3SFRzD7491DJDLH7CuRajDSV5n5RrLsZYthPGcgvPOLi11YMXEF
	MlY7EUtVPnkPedf//G8zquwe79IOdZwBknLTPMZ4GJNe19tywZJ6rdoxPm7lWjfbBTBy6l3Ar08
	HMqPKuvCs/GF9+cKD2pTBwllaPiLLIRmOBAS9hrApTgdc4m4HDJc3HfDE0UxW0d33m3BNzAMtN/
	iUaMXCH2oefbMu2Wp/F8wc6T742TnxWmLdpX576lphkcAjoj3LHlQQT8Vu9u50PlzLn/wR2PUYT
	pTo0R02fn+NMk6EvC73PsuK9MYcQSUNcItKbqncLKKwmWg7pk3a7JVDnf4b0XzXuRXv0ySYbA+/
	e51U6clGCHkgvcnOgGyN0eT9P4DEvaHdnmgVht6Ev1JK10G4ImTfLT0vOr7JGoD9o9yvQm35aui
	RcT6QU=
X-Received: by 2002:a05:620a:270d:b0:93c:2c15:e508 with SMTP id af79cd13be357-93ebd20e626mr2844276585a.45.1792007636645;
        Wed, 14 Oct 2026 12:53:56 -0700 (PDT)
Received: from localhost ([2603:7001:f100:5081:9526:3c0:45cc:5ac6])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93ef50080b7sm567630985a.8.2026.10.14.12.53.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 12:53:55 -0700 (PDT)
Date: Wed, 14 Oct 2026 21:53:54 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>, Kairui Song <ryncsn@gmail.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Yosry Ahmed <yosry@kernel.org>, Muchun Song <muchun.song@linux.dev>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Barry Song <baohua@kernel.org>,
	YoungJun Park <youngjun.park@lge.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren =?utf-8?B?QmFnaGRhc2FyeWFu77+8?= <surenb@google.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Rik van Riel <riel@surriel.com>, Gregory Price <gourry@gourry.net>,
	Wenchao Hao <haowenchao22@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Tejun Heo <tj@kernel.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Kunwu Chan <kunwu.chan@linux.dev>,
	Meta kernel team <kernel-team@meta.com>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-doc@vger.kernel.org,
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: Path forward for Virtualized Swap?
Message-ID: <20261014195354.GA371161@cmpxchg.org>
References: <5fdb3777-95a2-48f9-bb38-aa4ba3c96a81@kernel.org>
 <CAKEwX=MuW6q354nB3tyFTM8d3ox7LRaqcSfUxeATR=Sop5mZPw@mail.gmail.com>
 <5ca344de-bc34-4a9b-ab85-f553811a1d9c@kernel.org>
 <CAKEwX=N05iOC4hmiyTt5OxjAsOfU7_V8xGfmK_RgUyrKtuyUTA@mail.gmail.com>
 <CAMgjq7DJwGCHCAchcfi2Kcu+XHx2YnKXDj53e0t2kpG_GSejkQ@mail.gmail.com>
 <aqgMCIOFi0dKx_6L@fedora>
 <CACePvbVMFA9N0nQers=sOnSXGbNhtNE0ewq47AJEH5Cr8imQXA@mail.gmail.com>
 <CAKEwX=OMYhUs3tt7jUzEzxsOW3yA2JmzpwwxVBP2eZuHOFu=vw@mail.gmail.com>
 <CACePvbUMjRgK=dQzLjECgBXaUtQSPdAnBXL1Y4=Kh5d15swYvQ@mail.gmail.com>
 <5c8a2b7b-b76d-4bba-92e1-ec3d66794273@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5c8a2b7b-b76d-4bba-92e1-ec3d66794273@kernel.org>
X-Stat-Signature: maztwcogi8kmfky7b41egojdr6x6a7tn
X-Rspam-User: 
X-Rspamd-Queue-Id: D6EA6C0002
X-Rspamd-Server: rspam08
X-HE-Tag: 1792007637-490214
X-HE-Meta: U2FsdGVkX185Hr7QzICdKfNium71XBFNYKqirzgin4T1YdSOh3Y6ao5EgYAP+ruDdfjXNgdAHfqwLPROK8PkjYtf7HjEs1vtpPYp02Jg68o7HMlImTl/kb1RYa3F0LeggnZauSfYUZPqGwVN9NOh4McLSVIYWqVjxDobe9aARfxeeYMSZUbnK5Yc9N7d+Yi1SIXFzylT1vHEsyhvjzJ0H2YJN09QhxzowK0X0GZLvPlOEY0Hdn7o3sTQIMUGPssmejlU4Hj6uLNe4RAy1UTGghfrd1uKAw+FgHjSBbVqvKFh46pucikizAn2FEXzMaaKiYVmOtTJ3u5ctr9GED5e8Cz6DIN79o+bzXgoZ/ww+1uUdIhZwCEKY3DQkQrBFEtcr3bWVjVMkzYDM8cwZ6er+rgaG6hLG00UzK4GMYNR7QJuw88nZX7K32aoExdU1njth27aUCoMiOlBH6yRMkSV/KHP6VNkZA5QhxNaD3IW+JcggToO0XpKd99sPjjaLK68zRO2/OBQGc099ZTOoJ9fDeZqHGe+wm8P5eRx6pLxOFXcB0Ijy+IAs7aHQBPWlpAOodIrr243Aq26lwglnMwZBPSg45JG8JdQLHHF31O/dPSiGLI9YNM3QnvgGu4/Io3xkM0kuyp9Pmaw7c/tZzB3r5/Ovw2feXcFzZ83f9MYcJkBUDbwYUl9rRgFg0NiZA1OGIPSMKvx/BcD3DfrUAo3j85x6OAT37F0PDKxR1JdvodxuWg6FQDXhsIV5CQ4fKOE1LErSKVo3uxOhRLw7UuaREihEUv5aXK/AYpuFdhfgrycDa+ZB1rrbzBhNPITXowyAoFAWXnjQOsqCgBGgI1cx6WT42bRE6zU8FOG9lzE8AO4y2LYf8lMGLb3SDh1AvOLApbTFaUPwBR34UNSrQdoleRG0qHR3+6eZl+IQmIYtXSwjplhSpFj5tK6ZVHXCchSKS++PLN3KKEGtWdLmnB
 MLw9KoXg
 o180oDIyBemGDXVBWZZ1lJi5JhMBclIyDfQWx4LzXU0vU9rbU2+wl5yatJtYO1/AJz7KeM6IOfg47YVeC1X51PPTi7qtUykeHnO3u46491f+hEd7UU0Nv81N2Y2qnj/wg1scyw00Pd6lzhTVVB6M3w40pg/tGnA8iXYnBtCcW/CH7eZDXay1kVIkaAsb5ZnEALLzaaw0gxEJFCZdCTacEmj/dPxfO1cV+njZ4qxeTZ+N5X2kNjXmnhc5PiRzki8oiZv/XoqU8c7kcCm2dmDa/4eFWF35/HtFutCFmz9PDtpLDZuKyid9zvOZE+Ehn9774SHsMfRMS5CnS8L8VBYgmb+6hCM83lxZSYR86wDzM1t7bOdvPhTqzHz+jZlE9fqJ3AzRwZl6K+lBUmKUE7hiIzLTcPkHrXBWu8O33EFN1Af/GIr+J/fzlz/aqbkjoTV/QoQvyUPgST104uQrdfTNB2qOxzEf15qID4ca9XlhPkQfGAP33ditpXlLupn9HHnYLPT5qVLq9Eb+7R0Bur2yObL4rN/xmJ696GJuEPxVHv1j7y86qdQhhlkJvv05D3Uqh/pLsE565/pFVGIsRoMkBBVY7D7Mk40i17iut
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 05, 2026 at 01:06:28PM +0200, David Hildenbrand (Arm) wrote:
> On 9/22/26 15:38, Chris Li wrote:
> > On Mon, Sep 21, 2026 at 8:56 AM Nhat Pham <nphamcs@gmail.com> wrote:
> >>
> >> On Fri, Sep 18, 2026 at 11:50 PM Chris Li <chrisl@kernel.org> wrote:
> >>> No that time slot is too late for Asia developers. I don't think we
> >>> should use that time slot for swap alignment.
> >>>
> >>> We should find a time slot more friendly to Asia.
> >>
> >> Any time slot would have that kind of problem. We're spread out across
> >> the globe.
> >>
> >> Let's just use a standardized time slot we have for MM alignment sessions.
> > 
> > There are more swap maintainers in Asia than in the US + Europe, at
> > least based on the maintainer file. Please be more inclusive. If the
> > alignment is done without key stakeholders, it miss the point.
> > 
> > Sigh, we can't even align on a time slot.
> > 
> > In that case, let's keep discussing on the mailing list. At least it
> > is accessible to every one.
> 
> Looking at the mailing list, that approach doesn't seem to work.
> 
> Finding a time slot that makes US, Europe and Asia happy is ... tricky.
> 
> 1 AM is certainly unpleasant.
> 
> US vs. Asia is also tricky, but doable.
> 
> China 8AM vs. US West Coast 5PM?
> 
> China 9AM vs. US West Coast 6PM?
> 
> (Europe is 2AM vs. 3AM, who besides me from Europe would join?)

Either slot works for me. 8pm/9pm on US Eastern.

Apologize as well for the late response. Travel week followed by
post-travel sick week...

