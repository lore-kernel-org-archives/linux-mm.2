Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0EFD109E55C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 07:03:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41BBA6B0005; Thu, 26 Mar 2026 03:03:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CC206B0088; Thu, 26 Mar 2026 03:03:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BABA6B0089; Thu, 26 Mar 2026 03:03:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 157946B0005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 03:03:40 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A0483160BE8
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 07:03:39 +0000 (UTC)
X-FDA: 84587323758.04.EF903F9
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8B7EB10000B
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 07:03:37 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=D6pXo0qq;
	spf=pass (imf05.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774508617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lEkg49JXBlYRGRAlbz2ESpWLIMYJu5dEQ6CVQd0qq8c=;
	b=jKou77OkdRtDjVhNkuIBNIEZ/UTfRm9IbmHTTUDxHSL+kMhTf6+TotnOTpVKttg86l9Qh5
	mB1DqViBmkrnLZbcWRDvBZxbRiGIKGAMRlyPFc8m0JbflpXqVYWSndnodeUWhzY9iy1xyj
	d+RCIcra+iXfifduFq7KzPaHspG+Qak=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=D6pXo0qq;
	spf=pass (imf05.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774508617; a=rsa-sha256;
	cv=none;
	b=cRv8ioyfuR0YMy6TBcHa7R79emTtY8NkJzx3h0jSgFjIlyRuV5OqllQguY1xwgMwp3Mbo3
	Uj2WzP8xPm2MTyCf/4HXiYD9i+AP4XrKdFST6wohmcBgqnhh19YXotl6CdJSkslSVHhn5P
	ggN0mCpF+csr6xPRKxn4dG3eGg5g2zQ=
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-439b7c2788dso333571f8f.1
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 00:03:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1774508616; x=1775113416; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lEkg49JXBlYRGRAlbz2ESpWLIMYJu5dEQ6CVQd0qq8c=;
        b=D6pXo0qq+nyM8LmOZMd5C/WqDQ3SKXD7BemU93gz9BbsCNs7RJZ3CKtnQqQV4DDRyw
         oxjzktVku1o9VpKx28/PfUOFAqIw8idCzThj/qublT6HEMbiipibRaXpXmQQsXxPLK+E
         9/I3Eu78quoWppeP7xIOJm227O3zCo28+s+gZaDt1wUWAhHsiesTA8KWBJwnB0diD4iu
         5yJAewQfDbIwq1yt+ZqWQtM4wGWzzFu5Ter2JkHIZO5ftFcvxgGV2Xfhvyfg57NZ/b0I
         NrMOdi+/eDnmTL2S/gHUmnUkmgEWHUyXO+4je8HtKVN/fVAScUNqiFqMMQl8ji/vmd/I
         gBSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774508616; x=1775113416;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lEkg49JXBlYRGRAlbz2ESpWLIMYJu5dEQ6CVQd0qq8c=;
        b=T2kTbnReo8cl/ZdXbCrGzNWdoPfARiWhHSmA0WtfzmHr1sN/GAJz41Jmr1xlX8M1W+
         3lNA/JEoWc3CxR1LBEejHQFeXEMLg4DQhuGSbe0FmTa371sl+Lamp53CGndM/Aq9qMH9
         iVNQNifSv7LcVFysCyqnCmUHWU7pW17ZT8MlUoHXRts/MDH2a6gULxxUWNSEdagstzBr
         2feTDP4LwtcPV5l601rymHaKPiwg3Xgpb0yZL5PyWu7ukKp2vbO/rfPICMDsW/Tr/rD+
         xW8o+Ojvwm0EuaMR/urx1UDHANnwqfZUhIDyFG3sdCsvF42AW8bGVbJm+UB3JD9i0G4r
         og2A==
X-Forwarded-Encrypted: i=1; AJvYcCUbebr33tOHVAPE0L3xX5wINFI5exPZ15zNtoKYGr3bJAOi6ofGWgOupOo48ae8XYJ69KZCuBNQtA==@kvack.org
X-Gm-Message-State: AOJu0Yz6q6ZN94i/8sqsSCrRiOzxaAR2mM/TDss2ThlKUR4fvO6mFeeo
	RSQGrE0h6/HydWKWmN7UK+FM8jgysqtaieimSIQx+IfGPZVLTgBqLPSHG5Hp2aKSGu0=
X-Gm-Gg: ATEYQzxCRANMP7QgF/bczdXXOt025z/JptrOWXQa9EN61o5YX6yfd00j+tAacGlphi6
	3qZzjnJu1gUHCRQSk58PUirsoQVITOqsnN19oiLqfmX7uabutHry0X+RO99BYTo1FKdb86FZvHy
	PIBtO008vE+mOuOxPb+uxSVjXv5NleOHPh8ph5nwAP7cDj7MedcsOGZdK4i19UF1c7/AIeF10f0
	m8Kw2V7r/qzeU5/UoCor3NAFn97RcawHEXi/PCUZQODht2WDW8ZvJtM/IVStwx9vWffPEO8Ch+f
	HZQctjxf9ileytDqXPMUo9Mwrr1SAw3kTTXCRBuWt6yofCgB5UzKMv0bLHauHbCcpFElAUi1gAL
	rvtmoidOg68b6gYBFVTBtaMNE3pWNa7WefVgIapVKixvL155ngzY+PnaHU8Tccu1S9dHvcvZXi7
	NqRkqRU4M6N6gj9yUbZQuJjqC1SLXvcc7WHPqb
X-Received: by 2002:a05:6000:400b:b0:43b:4ef0:e13 with SMTP id ffacd0b85a97d-43b889a49eemr9597969f8f.12.1774508615797;
        Thu, 26 Mar 2026 00:03:35 -0700 (PDT)
Received: from localhost (109-81-31-149.rct.o2.cz. [109.81.31.149])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b919df903sm6070863f8f.30.2026.03.26.00.03.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2026 00:03:35 -0700 (PDT)
Date: Thu, 26 Mar 2026 08:03:34 +0100
From: Michal Hocko <mhocko@suse.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>,
	lsf-pc@lists.linux-foundation.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Chen Ridong <chenridong@huaweicloud.com>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Kairui Song <ryncsn@gmail.com>,
	Matthew Wilcox <willy@infradead.org>, Nhat Pham <nphamcs@gmail.com>,
	Gregory Price <gourry@gourry.net>, Barry Song <21cnbao@gmail.com>,
	David Stevens <stevensd@google.com>,
	Vernon Yang <vernon2gm@gmail.com>,
	David Rientjes <rientjes@google.com>,
	Kalesh Singh <kaleshsingh@google.com>,
	wangzicheng <wangzicheng@honor.com>,
	"T . J . Mercier" <tjmercier@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Meta kernel team <kernel-team@meta.com>, bpf@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [LSF/MM/BPF TOPIC] Towards Unified and Extensible Memory Reclaim
 (reclaim_ext)
Message-ID: <acTaRgusrxfCoKqe@tiehlicka>
References: <20260325210637.3704220-1-shakeel.butt@linux.dev>
 <20260325190547.abb7309fb63473b57b7a90a0@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260325190547.abb7309fb63473b57b7a90a0@linux-foundation.org>
X-Rspamd-Queue-Id: 8B7EB10000B
X-Stat-Signature: x7zqqnfjygsg3jis7yhty4sox8111ygx
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774508617-755703
X-HE-Meta: U2FsdGVkX1+lX4zeboiJqUfgwF0ZqXkFESWDCWxu4zD+SyllK+T/RjrESKHtJKhfeSpWXr/VWYK02yezu/ETqiF1Tt+j2TUYUmYVuI1omASwtNcr2NyoT6seT6mXxtot6YdH2BgebsXYG2RLCO3tZdvrGG6VJRa/ryTNHVrNPwuaCHBxwAlo8ZNvs50UsxXlYnOpdqC3wbKfVPPuna/mNlHLqVMU6QbSfKId0OxodxRE0lIXJn5ix+Bq6O3dZuImiAXRCS2N9ogD5dpBuOJ1wJu74OELLIEJi1mwIDiq3Za0CRQ4JCM6aICVc9bH4ezEuzgUaEIGZXLGJc9fzW8Wy0aGWZ0+5d/5DLvCBsOb5B2j2Otm0l1WENJZK/jd37vYtBQhrpFe9MyCpnwXFbr95YQDmQ/rpGwP4Gz9i67ER7/jbDHPhKdNsORm3m04GV9rwTzUFOGDD+YObUwFzIguU7OrI0gjbLtpg4HcpluKixBKHLTvOBTvdnC2YNGCT9AhVwQ/ypokkn5PKmld4Cz6yCjZ9mfr4SQZsnjdigZpB8I1y9H6fjNTMuWntoyEE+mZYzBvHBuVhUaVQlpu8/RyOTlrA0Zf/rjZWC9+TjV/Zbj9w5AnvEJ5CFhXWRFBEuf1wSsF1AqtzdqoJa8oTl0Q4Rts6k0LDiBLNB5743AUJVsaq+4J9J2hOiKr7SJCKRzWDO1RN0AmHNo56oijByzObWv5UzfIQEULHCl7WGs8phjAaNWmpUtvQkIpI8F63gqeil1KzNhPS0Pycoq4WQBpOhj5T7Km7eKcVdck5aALJeX4CiNyaq5qoHxuBmxhE+DU0B+TOq7jfjJqV/lNi4dNbbZDTQAI5wuJC7Q3TGwlCI3YMjwQ+j6KODQFp/s44nm9Ve7hqHFtEWr37zxvvI3OAwu20hQKPigbbPky4p6v6a/z7R8ONZenDcSdpVjk1HZjKfcAZUB6/5fZ2D5Myiy
 OgrnRoP0
 NzEJ8kytsBDIdKGt4Vzg39UpVFhzRZstqtvndrC/dPJKL4XC1vqLSYHo3jLrZK3W/Ddx7go8jhEi27ATdAXebIpn/06u01Nbt2sb2JuWfueY+LIORxcbsTYXXyNEC0/ZakXzvh6ScNznXz6VorPWwWBPah3LKA/mbhyqzdha2TB6TMYKV9tY7JaGzCD5vpHXtTLPN5gwTVqvmj4kWesLO6KFsiMWl0vt+PYhnOwd+TXkprEQbewnQuAuTW565EFVmanKLFH+4ANFxeR4XL1csXx3Ov9GkKREaCI0xL6IT+lPGCBBDGcyiI48MvWtv3lFknxEcQcrvtokPdPpaV25k9/pdj7htlU/cSqEprdmPMpx8xNYu749A337VH79vGHK05xev441TGOQOPJHFyW2wt6vP7q5pUP70YLw6RcQytyexZis4sv3jW8yEuQUlvB0hj61r
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 25-03-26 19:05:47, Andrew Morton wrote:
> On Wed, 25 Mar 2026 14:06:37 -0700 Shakeel Butt <shakeel.butt@linux.dev> wrote:
> 
> > We should unify both algorithms into a single code path. 
> 
> I'm here to ask the questions which others fear will sound dumb.

Not dumb at all and recently discussed here https://lore.kernel.org/all/CAMgjq7AkYOtUL2HuZjBu5dJw=RTL7W2L1+zVv=SCOyHKYwc3AA@mail.gmail.com/T/#u

> Is it indeed the plan to maintain both implementations?  I thought the
> long-term ambition was to knock MGLRU into shape and to drop the legacy LRU?

Yes, but MGLRU is not there yet and with development pace last year or
so we are not much closer than at the time MGLRU has been merged
unfortunatelly.
-- 
Michal Hocko
SUSE Labs

