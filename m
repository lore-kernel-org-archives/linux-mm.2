Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D289C606A325
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 18:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ndhlllkt
Received: by kanga.kvack.org (Postfix)
	id B67D46B0883; Tue, 27 Oct 2026 14:07:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3F6F6B0885; Tue, 27 Oct 2026 14:07:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A56EF6B0886; Tue, 27 Oct 2026 14:07:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8368D6B0883
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 14:07:25 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1253B140A4E
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 18:07:20 +0000 (UTC)
X-FDA: 85369188240.01.218BA97
Received: from mta0.migadu.com (out-106.mta0.migadu.com [91.218.175.106])
	by imf28.hostedemail.com (Postfix) with ESMTP id D295AC0002
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 18:07:17 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ndhlllkt;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.106 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793124438;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dNbDYzLQNCqxlf+4nrYorO8QI+OKRu/K+yOjcsmRS90=;
	b=YUdZvTKLnCNb5oKrBn4k6lUCMAUZPElNumIjyd+LGIQhR8sNow/vvxl+tleaPArQOtLckq
	IOTEoFTRpuNyD3qR62xqYESgUTwlFEASYr2JtlOcjcNd8Xx3WYEKsI4EDTSOr9L+eUsQO8
	Z8LkNZdQ3BKqC+g5ZTBPRFrkOCJZDTI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ndhlllkt;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.106 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793124438;
	b=PSTzytvkzvLs6NyaXkdoqqcHmOfdAicPfknABX41kQwLTiUf4LT/mfw6Ft0Dnd0yTTMQA6
	wxsqFOvPXjTcj3J4d5fLuboNwPNPP5aa9w8/kBkRXe0hNx8dcDst5pjEHxL1ahaiHVwVlS
	+4cc8r7tbxKDOl78LFJnQTFZp4LbgrQ=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=YMm6iQrurkSXVUsqdlGljS4+ElHIs1WT0d+I1Wclx08=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793124435; v=1; x=1793729235;
 b=ndhlllktCb9uCa73MAZ/z7aeLlDPV3RHgnzhw6HB12y6lV5cjD4KgRX7ld9d2go/JErWwPmQ
 quSNjsp1Lbk3qvl8dQOcFisDKghMUmwEHOozZD2l2fmOIA0zHMJviCu0pN/x8TU8DzK/hF4+lrE
 4wysIAO6Qxe0Wymg5DJQI+h8=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 126198f51eccdb92;
	Tue, 27 Oct 2026 18:07:14 +0000
X-Mizu-Trace-ID: 126198f51eccdb92
X-Migadu-Flow: FLOW_OUT
Date: Tue, 27 Oct 2026 11:07:13 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: "T.J. Mercier" <tjmercier@google.com>
Cc: Michal Hocko <mhocko@suse.com>, hannes@cmpxchg.org, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, zhengqi.arch@bytedance.com, 
	akpm@linux-foundation.org, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm: memcontrol: fix NULL pointer deref in
 high_work_func() on dying memcg
Message-ID: <auDno4JDDyhV1Y4Q@linux.dev>
References: <20261023222313.3979455-1-tjmercier@google.com>
 <at9U2HvyUP-iYOCt@tiehlicka>
 <CABdmKX1mLKEJNiecW+meJ=LB_Kb8-ieeWdZDd4T6rNR9gKuq_A@mail.gmail.com>
 <auBxqU34FQYauoQr@tiehlicka>
 <CABdmKX2Hua321nr9vR=Q7-Uu5N6e2JARtUe5RnC3JFu6aGRqhQ@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABdmKX2Hua321nr9vR=Q7-Uu5N6e2JARtUe5RnC3JFu6aGRqhQ@mail.gmail.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D295AC0002
X-Stat-Signature: 635sfcc55dkweghfpqun9nyppc9rpiat
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793124437-133632
X-HE-Meta: U2FsdGVkX1+MEWXJTfUEvAhN9NHWJ+XXrjYhzNGu8bXnliJnytwo9Hxva0z0HxmpbmPzXxCbIQZuq51upvxmXDAQn4FSIUVSmmA8Zct9MPh5CNPWNqwNC9bhoPmWeJurpAreeJHBf0k9qF97vmS+4BlKtvuGcLfSjt0ZZHVkYChUKpCeOgJ+wuT72DTde43b62vKw+J9oTZXZ+MUIr2tQYF+t3oavBtTr7KMl5yTJRK3AvdRayOn7XjD3cLijA9JlnzjLAZKwW6IbMjvobYRXquMthoIxnJ2fEHDfL7/KjAjwT/4H75mX+jroFgnQDkk9wXPDrFB5WyDuJylmxqKbt/IoWnyo3Nh0RiyF20cIqNRGB6helZioT7hJPlGsLU5u8ghvHmpkWaIRlg/cO1W9+cmMyRMwLwVYQVvrjNkwTSud5EPUtJLDLOnBQxfDwDrb8v0FXoHNbfy48BZr9WyWvjiG9Jqt0lkwHPaORu6sWz3Qj7Ft21PRCjYfYNMfTZE6/OEzBA+S+tXI0eOyK9Apy1Flj6FGUn0wNDa0EPT1f8ZknRTdDzzmNOXLcp3RdJt5QwgK6TONk46Kv8giEqzxJu7ersjWZiWZSZSm2Bz2mhoN9ypZhAgV7Ae70DaWQdfGymJzM1dMiTBszGFzHeQXSsQ1epYU8sLI8U0xiULg6h2pZK/AzEm0KIEY3Wgeghm0+WigWRHe22Ogf6uocer+b9xlIMm0o1V1rGH1K7459dll6nRudeUTRgSUrntwBJOqSy8OysIOxXa7GHWEmSs2i0V44Xz9V+rPRlDUmdLiCfmAUjPf+0DkqEXMnMUGBEkYMDgTGWO2KOdCebzRbuSCZcH+0OJ1AstiO1JwKqUdQmQ2iapDeaVoajJNwI1K2T+195jOT/hcwioe0tiUlS74hYHu3MUMbIaxzkOy7cZho9JpG9zBSzsj2zlfTchTHYJlXo2ZwRqKWYxZsRTe/I
 kQzlbLOE
 LDVQruN3QR7qmjRXQFX/8RuYA1c8dCmneQtyQQuF491ZJNakYxmZDYzJf9VM/5tCVKB4HjAzhX5gtVcgXvYZ6ezUCVJXRNzqYSdaRQUf2WkaNWdW7XluaMXMjvt5f0lRRA6rxYSA391oWQLZVWrtOoRdXXIjkJiTxvMcOaYpwdiaG12rpmMEBRaL6keENweayQRmmEASw/Evfr8j+KG0EV0UeXCSiQlnaRTiMs/pVFcoiITSuUU5mVkdmDzi4k6kzgqm5slsvSX+jdZ1M7PHAkUk3Ld3zlo2ioEjM0nfmbr2Z03MPF1zSMETre2BvBqCY6hq10AZYe854lSSQsD8+MkU3MiCOCp5L9XfuMdBX889DtG9iWIm5voFFusU20RUbzuYSSgER7+g+ANnOfCDNxBbDUA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 10:28:22AM -0700, T.J. Mercier wrote:
> On Tue, Oct 27, 2026 at 2:41 AM Michal Hocko <mhocko@suse.com> wrote:
> >
> > On Mon 26-10-26 11:01:51, T.J. Mercier wrote:
> > > On Mon, Oct 26, 2026 at 6:25 AM Michal Hocko <mhocko@suse.com> wrote:
> > > >
[...]
> > > > On Fri 23-10-26 15:23:13, T.J. Mercier wrote:
> > I must be missing something really obvious here because I really do not
> > follow you here too. So we are offlining a memcg. We need to coordinate
> > memory reclaim with the memcg tear down, right? For the high reclaim we
> > can achieve this synchronization through disable_work_sync in
> > mem_cgroup_css_offline.
> 
> We could call disable_work_sync() in mem_cgroup_css_offline(), but
> that waits until high_work_func() is done and it could be performing
> reclaim. mem_cgroup_css_offline() runs under the cgroup_mutex, and
> cgroup_mutex contention is already bad enough. I don't want to add to
> it. It would also block the rest of the cgroup_offline_wq.

+1, let's not add more potential contention sources for cgroup_mutex.


