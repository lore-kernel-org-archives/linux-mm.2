Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD17EC55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 02:11:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A33B96B008A; Mon,  3 Aug 2026 22:11:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0A446B0092; Mon,  3 Aug 2026 22:11:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FA2A6B0093; Mon,  3 Aug 2026 22:11:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 65E356B008A
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 22:11:39 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EAB0EA086A
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 02:11:38 +0000 (UTC)
X-FDA: 85061960676.04.104545F
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf31.hostedemail.com (Postfix) with ESMTP id 1F5E720010
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 02:11:36 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rP1cEJyv;
	spf=pass (imf31.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785809497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8SYycNF3WUCSlS4WaCTVXd7p9H/S1LXP/nnaP+2x+nY=;
	b=k7GnISoSqw1OzmRbxOun/1manjxWYFzCpfxPsBmV3BIDJcL2Tnotxiwy1gNLa3iBtrGHPc
	A4OygZ5r7ngT/CjrM6VtEi3DfGHdwAkuSHLAjPG5gt6FseyyWmN336HtMvR/dAWd38ZUzS
	opjn0nxeqRdifFIZ5tPSEpDwQdKu6dI=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rP1cEJyv;
	spf=pass (imf31.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785809497;
	b=husbCBObff0qNExxqIOZojBjEOj8NXe/WGj4uzk9s+4PkUMA99EKmyfjtC2DriFZRRBS6q
	LaitwyRZgsx/KEu2kijqWQuqT4N4g2D52q5r+mwPomPgmtgJhRXnvUYOAW2J2wFwy3fKFM
	dBk6tGwKb0OUjRUXQdn4dCx8TIsoxP8=
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-381b831d535so4549545a91.0
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 19:11:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785809496; x=1786414296; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8SYycNF3WUCSlS4WaCTVXd7p9H/S1LXP/nnaP+2x+nY=;
        b=rP1cEJyvRjOfqWDRFi6menZ8uX06OyePLiXYhfaEN7PdsQu6gR+70PxwDY67yr5MtZ
         rp4jYgzFGuIv/8CewdUYTQHf7Ii+lPagyxGR20K1NFfc8VTSUt9VrK60rtF5XQu5sc9B
         pL+nE/ZOyViysxpYcucKC/hoj2vxJIIrPgN8VFoXKzqwuYclW9C0feAIiH5mMSY1l24H
         ZkomDFVcMuCP60nb/cb2m6MoNkcxwcVkCau14XtiYYs4rxbH/DDXwevV7OS/6QHVk8KF
         3fPTov3c0rpi2A5CEgq2BYvyVZBOgZHvixPN4Wc8sP6xXAePVblgk7tZ1CSGQfQbX0aG
         n57w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785809496; x=1786414296;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8SYycNF3WUCSlS4WaCTVXd7p9H/S1LXP/nnaP+2x+nY=;
        b=kajrdkVK+9jukmeawYtk1yPuDp9ZsYpBq8hxx/6Af6kNnU/rhU3x+CPWOC9OALYt3g
         lVwnaoT8pkRva3bKglBEqam3DilUoXb3Gl7Qa25a/0lnjTBbTsTwJeR/NnCjqteaGvWf
         yjRqQ81vO6yof6DHCODz4yX2IttekLMG+PGtB4ooTaiDHWVvSggm8mOcNQZpaEiM3pXk
         I61XePqJJ32MQq7/ritUGOU9/6xde0gTGFOVfvw6yEHHT3FAVmPJjaBSo0c5l5KgoiGk
         8EvtiD7ick2tPv9hPFdwiMtRfkK5JYMCv8nM7yswQjbeAtW6gdfcWNLQks+WgFEgXJWl
         l61w==
X-Forwarded-Encrypted: i=1; AHgh+Rpyhj1lvdT+Afro+NW52xoHda29QZCE5ysjwM5t8uep1TXLT4WtPzJmrAc94EfF996pSmuMME22pw==@kvack.org
X-Gm-Message-State: AOJu0Yw8cqxgrIB8Tj41NOh5u3g0j3MYCp7vcDghRgxMYdz/Wo3cEjY6
	0XfncI+M/3FzzJvKOYQ5fiBN80bciaZfjLYbmVkHnzYW1BbQsgCExsJV
X-Gm-Gg: AR+sD12nue/22N0VmOvXMhNl88vmqRmD+UGBmCMI/OM/Sa1HlvWks7FGckgGKTAVF7o
	iIHikX1XgdJaH7lNRrXdSHNu3++Jyhav5Frv2d8q6jwNx0XxVwDCFEUUGuo+3f/r6cQP7s0w5/m
	ry5B4OBh/wv7m0pWu2e4RYz3ym0zWihuIkWnUy48sIGcQRIp/eFvTiNvAj5fgr/DpmpQd7fpg/m
	xBVNlGhJndf6/raA0A7Vd09KiqUjoOFvNW4rGz0PO08+xMftkPAqcKootbc9M2Yhz1JjrjC3Zwh
	pL/2r+jTukp5DhnfkRhZekHCguklF16kHMwZHBVOPhZTp2ozu/ASFwp2mC3YHLDTp4UtoOWtkIw
	qd0J2Fe6xdjBhCjJ1M5pXNdJYMneLy5KxaqeDeRyA3bUpc9R0HHl0jVa2XWTyP9mEslktED67ey
	g+PlHMLrVP1Fr1Tqzy0IPGYedMAV6cX9V5Q1q+xtBtRdFjAN8WQjoLUZk6oT6/rPAZMXfIE183r
	P0rL70bopQfzdC2XxmrVNaX+3MqxXxPVRw=
X-Received: by 2002:a17:90b:4b02:b0:38e:bbf1:de34 with SMTP id 98e67ed59e1d1-38fbc3e7e39mr11745590a91.7.1785809495777;
        Mon, 03 Aug 2026 19:11:35 -0700 (PDT)
Received: from KASONG-MC4 ([43.132.141.21])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38febff7eedsm515509a91.5.2026.08.03.19.11.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 19:11:35 -0700 (PDT)
Date: Tue, 4 Aug 2026 10:11:21 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: kasong@tencent.com, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, Gregory Price <gourry@gourry.net>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, 
	Hugh Dickins <hughd@google.com>, SeongJae Park <sj@kernel.org>, 
	David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Chen Ridong <chenridong@xiaomi.com>, 
	Tal Zussman <tz2294@columbia.edu>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH RFC 12/15] mm/smap: report workingset folios as referenced
Message-ID: <anFJMBI5Q24BEdkn@KASONG-MC4>
References: <20260804-mglru-fg-v1-0-4d8dad39dad6@tencent.com>
 <20260804-mglru-fg-v1-12-4d8dad39dad6@tencent.com>
 <anE-nSqyXcG1g5zQ@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anE-nSqyXcG1g5zQ@cmpxchg.org>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1F5E720010
X-Stat-Signature: m5mkistks4w1ji8ydcz8snm36b71ujkk
X-HE-Tag: 1785809496-784553
X-HE-Meta: U2FsdGVkX19ncjOZ/ESKXA6Ebf+WNKaK7tU5/5HpnYkc5ORdPSYJskS2XRU1O6NbYhhmYjXK8hyev8HmujrrsNYIf9qBiQQPcT60I1ejlf44wuKog/ZQQ3E/CBW1fUrPBdq2bQ5+Qfy0Ilu7pi/N4Q6hP4M4U53YQKd8RYPPKS+iUqepG4qywdyTEL3rxf+GrgkMHRHcWpT+aaVqgevCy5XfQK6YSfjxCBPQZ0kj8HMtswP+/43c+jybEEBfH6x/zUc2PG5EOJVYqtASNUktvyIVytgAxLES+byQBZsIGMYKFGJsT18ZXSngRLF7XWGtspsaNdJI8o9S62Em3AJxv0j/quakpDI8YABOZt3/BkdYJvUBfqABWdmNmkCsSBGUzjzn7EJRfSZvWJnnWZhVv+9jfttcICE0xkrVyAlcV296wdEuF6bn9CyOVhImjc1mzyjN4jAGzKYqH4OiOw2ogb+GmQYQ+BpI0z0tDKQCtQhVKZzgurCRelLlrU6KQkzdmpo7MDVz1VdNh81zr3FgWeBENV+z3a/Fo2K+WziSBjJ0RzoDMxxLDoRAk/moTkGeo++YVOq3V+qsaCm4S9jaI0YZwV4E/tl9KjQIfo7AbNRHYMwA66s04VAyKqLVzItJ1h48v0IWWbrJMN11dEWVFTHJx0P8z24ATv7Qqd7JVptEOZ4uW1ztrQA+bRNnfoi0MF1UaTXuOR9CnZCygz8rRCazaQst3g6yVRU/GRtROw0wClbxDv9/dscVfJ3Me9DU7CDZqmdHpjXY8Oikh3Y/znp2fIroSaxzYgOW2NVs9O+mvyqQa2+lLB7RAYyIWYg02SGBWrA2blyZgcTJOQem5RBwELZPIB58fudSfNiHx2zm9G297WGAl+/fZ+E/P2ZKtFCub6Qsm5qZuc7m7n839uAqe7xNpYRxVR3ILx5TPX7Crjhyn2yaJ6xy81cKpucRtfzJOoWDCw6VJq4tIyO
 zMcPhHcz
 60+NPSsqifKWSMJYMjuGTN/uQuKhXYqHe7kPsYL5WtbBQKAv9WXuZFplFnTUIwTeev1bMtxdjyXGMUdgysWYBXO6/Lg8YR2kJrA1Yt9erRUOuSoS4RdEtvY1ocpAO2FClzsZwLlLQdjK2PEj3HzrFGkp6p4BPKBnkPL6r2vcfmiKsm/aqpkarNZLkFO3sEVleJNcCtF5Pkgw7scQI4uG2LpzuPBcpLzzTQfbKYwK2ruFOlo+2OMewC3jxEY0zxnYRK6HqEAbUsrw2LS1cSsnNQNxzKKG0Yz4ZrG/zE6RkV3FgnDz2eTzF1QYu8ynb6UI482YA24dRrRQF6HyMxb+7HHTSfbA+6vrt3+ANgljpyIXKTAr1yfKCayErcSsTUaNwPgaSpEhM8Zk6P4tPtvSnCZGA74ToFZo8NKIt6EVDlfukQjWpFqid6mWxTJ3C3ZdsGCjhLcYuAMGNz4yJIibgxC9HBWuibrgj+TCEx6T6lO8tfH/viF4LVHbKqix07D2GI+X+qDGe6z/HCgcp2za0dO2Ig4qGohFEe2nbOQ9Nbewtq+7AXehHgWLLp/zZ6vYAZvBiAJShnfG28uc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 03, 2026 at 09:21:33PM +0800, Johannes Weiner wrote:
> On Tue, Aug 04, 2026 at 03:47:08AM +0800, Kairui Song via B4 Relay wrote:
> > @@ -944,6 +944,22 @@ static void smaps_page_accumulate(struct mem_size_stats *mss,
> >  	}
> >  }
> >  
> > +static bool smap_check_folio_referenced(struct folio *folio)
> > +{
> > +	if (lru_gen_enabled())
> > +		return folio_is_referenced(folio);
> > +	else
> > +		return folio_is_referenced_by_bit(folio);
> > +}
> > +
> > +static void smap_clear_folio_referenced(struct folio *folio)
> > +{
> > +	if (lru_gen_enabled())
> > +		folio_set_lru_refs(folio, 0);
> > +	else
> > +		folio_clear_referenced_by_bit(folio);
> > +}
> 
> I don't really understand this and the preceding 2 patches.
> 
> What is the benefit of a "shared" ref/workingset state implementation
> when you then still have separate APIs for querying & modifying?
> 
> Switching some these callers from folio_test_workingset() to
> folio_is_workingset()? But both functions continue to exist?
> 
> Why not make versions of folio_test_workingset(),
> folio_test_referenced(), folio_clear_referenced() etc. that do the
> arbitration (bit ops on classic, refs ops on mglru) and leave callers
> that are only interested in boolean states, like here, alone?
> 
> folio_test_anon(), folio_test_lazyfree(), folio_test_swapcache() -
> there are many examples where they don't just test a raw bit but
> assess more complex, composed state.
> 

Sound good, I just copied the folio_is/mark_workingset helper from
my previous combined RFC, where I tried to drop PG_workingset hence
used a standalone helper to convert the users one by one for easier
audit and tracking.

I think I can just replace the default helpers and have zero effect
for CLRU. There are actually a few more helpers not used but introduced
here, will drop these in V2. Thanks for the review!

