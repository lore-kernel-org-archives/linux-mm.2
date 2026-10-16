Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44258CCA462
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 13:48:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54B1A6B0088; Fri, 16 Oct 2026 09:48:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E56B6B008A; Fri, 16 Oct 2026 09:48:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FB686B008C; Fri, 16 Oct 2026 09:48:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1557C6B0088
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 09:48:46 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 821E31604DA
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 13:48:45 +0000 (UTC)
X-FDA: 85328619810.01.E90704E
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9BAF840007
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 13:48:43 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=DlzIDRfB;
	spf=pass (imf12.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.44 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792158523;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0/H2zWOxTS0O6iCKkUCp+Yb9Q6oHYUrnCIj0DP3Fsx0=;
	b=Sf37Hejtwe1+xr+K3r7Qzd6NRuS4NeDcxiZxc5r5W8tIAIBik51yHwC24dklZtW9adWi0R
	hhdw633Gl3VE4dILpaTsD7zKQ9UnSP5jCBnzSjJY8+tEBmtgNUCJJnfQgavvhEJaeQVN2W
	w6cjnFQ57h0HvZNkk6UaO1nAwoMpmgI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=DlzIDRfB;
	spf=pass (imf12.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.44 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792158523;
	b=0cHZG98jKBUlyrivYjfuUwdMSpgEXcjK5BIjV+BzMlb/REnZnMB4y5bD7oLWXMT3lvjvAI
	fyMCylWx6/T4eD1vLnVnFpTGDsgyws/t8X7nR0G/hFvJ5FGGDATi1WuVuz0himtdSx5yvk
	HB+S7w3GiJyzRciuri0+oD1VZjpQENg=
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-91b89c6caffso20266d6.2
        for <linux-mm@kvack.org>; Fri, 16 Oct 2026 06:48:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792158523; x=1792763323; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0/H2zWOxTS0O6iCKkUCp+Yb9Q6oHYUrnCIj0DP3Fsx0=;
        b=DlzIDRfBgX0ArBQ/3W0f12X+904UYlmczsTP2FmUW8+8+7BCqRwWlo/aVM3/tBbU/C
         TbkiLJGgcZ3K51UGKaE4oey4TuIevEdS/qMj5D6tSEAslrGusZjEQ+WIKbAimX0ypYgM
         vDS5vRbmlj6zuqth26WB3TJEpa5tHLOCPO2XWdDy5oel4ZujQWS9HaTNkgaGDBv34DrV
         W8mXi0Ji2xKDAyIec82ycA4wr3SJ4f8dbO0A822SbxiQNRU4ctySZIpix4zW4ZTdER8+
         bKkG6XCHz9o/hGdtZh+bEiJQbvxLT8LkWguI3WWpvxZsGieTIqjH1eX1x5yxCzu5q4xa
         Eljg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792158523; x=1792763323;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0/H2zWOxTS0O6iCKkUCp+Yb9Q6oHYUrnCIj0DP3Fsx0=;
        b=2MVVJsC54JfHgNlKig8mThDK/ZyUPvPrabNKezyi7/VPCFW8MlSE42wMQyQVeVH/LI
         5D8eLZCqs9f365EVH1yn5WaEevGkqEZ/izIJLh5UaPxqHR+3kESwVGE8J97wQ8Xnu49v
         4m79NHdklOGmPWlzQX3Iztj7GelWh4OVlcI92baV9uDKKAWFEIGg84LbSSiI+nlinlad
         +HuUODf3JtxAM7lDH/LKjsTCGd4xGXsLmfD4Er/fJi7yorCifWh3JUczqG89uQqicE3O
         GRrDsHXphM4Anrlj5iIDkBmihGQuewyy1tYEIAnIiEANt2i2bHVqLc+bR7hZY1aOydf7
         zkiA==
X-Forwarded-Encrypted: i=1; AKwUvBwtN6QHb3WDJqllYSC2PNcPGNYdMGU/1q+GgA4VtwQUb3QGQPZjlhYTHmLIS9ze8rnAaNzmFHzIkw==@kvack.org
X-Gm-Message-State: AFq9FYKeluyY3W89QcUOLNzrwd9ViVv1LpgECOne7vkUTNZ3bC1GRzxW
	+QVT/1VS9BRgsCQY96m/h/raYsI+mPbMetYi0q8Nye9bH1H68Al2S4SYhlsb3phqP9Q=
X-Gm-Gg: AYBFou2Nzyb0+Fu6BjQQA3y5oSPOpJgV1goZ6cJHuEmhM00Lo9C4xyP/qEo4J4wu3dt
	MM7CozT1slP0A6mFl+GuMbr1H1rQELm+vuqVbF3yOvToGN/gc2hl+21hKayTfnQcVHetPlyYfh4
	vv05LPH+UYLsQ5ZU6VuaFWEjteEcNpRAi1TZN3JW+h7QYT/4ux3IIhALvSUq6n8iKPg/zu28k8R
	+pt2zJvgPe2T9fWBhVb6VrTGT3YkjgTZriXnsiENNQuILcFYNlpOpLl9LPPGgMm0M/aSWnJbSY0
	heZyvm85YDIwho1F0eOcR6E83Yw/EIZoJCfDT/gyUpuT2B6FHsS8l71lxNOZqsm/PQ0d/KSXXgl
	s9oisRgJ2v7xTrl5VHdouEI7A2slrpMAWExLAMPK/rPq7h+pHNK2yVTjrOmDzhbnnXnWnDNv1gA
	HD9ROH+9jPhUElpLWlNpxR2kKyMRW8gLsGGzwSL47GWnJYjVADyix2SJvn0pwnHL3b7JhFh7nyJ
	r/PRARolFJoFomQwXVZGbvSpP3Z3auMwCQx8AjJyo3FzB06I21l2F4=
X-Received: by 2002:a05:6214:3013:b0:919:b4fb:eec with SMTP id 6a1803df08f44-91b5578517bmr396695716d6.36.1792158522383;
        Fri, 16 Oct 2026 06:48:42 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91bcbaae645sm23369576d6.21.2026.10.16.06.48.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 06:48:41 -0700 (PDT)
Date: Fri, 16 Oct 2026 09:48:40 -0400
From: Gregory Price <gourry@gourry.net>
To: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com, akpm@linux-foundation.org, 
	david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, shuah@kernel.org
Subject: Re: [PATCH 7/8] selftests/mm: check MADV_PAGEOUT file permissions
Message-ID: <atImwW1ONQQ9Hv7p@gourry-fedora-PF4VCD3F>
References: <20261014175756.2035176-1-gourry@gourry.net>
 <20261014175756.2035176-8-gourry@gourry.net>
 <cba2a01d-630c-42d3-b6e4-b498f10c4b45@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cba2a01d-630c-42d3-b6e4-b498f10c4b45@arm.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 9BAF840007
X-Rspam-User: 
X-Stat-Signature: f13sgb1bm634ijro1ermmk5wh4ky7w3y
X-HE-Tag: 1792158523-928476
X-HE-Meta: U2FsdGVkX1+qFrR5ZucJghQGTz7S4LSFVqNi1xz1tGT+o7hy8aH6K/Ww5L9c2Bv3ZnHrZcIrEzVQnxbEi8DR79yvd+l4dXnnWA/VMAEa9JouzTTIYmIm/SZ7d0JbvnM+QfujFRnCVXYCFdmTIEOvdnRJLLzM0qMRYYVfS7jJGT2KPbJzE0xRmkrmIw2O40k7uF+wPKaJALwmxLA9mZj2hSMXKGSbMqAbBumrtXCwrPNCKAAP2NYhH9h9w78DrsX/i6Tngx9P+yOSHFJYXt7uPE6tS4UjuESo1QyXhdekA3PPq2+mlf9GxsQuek5ANxQMzv1s1kPM5cMMObzjErvCM5rYAvgB5ZLq6hU6VYNEVLcA0zWoLBA/AH9rweqlcUHuPgR6AzFR77rZpYE4riUTc8GlK05EGpjgtluSUweOYfbc6K0tpSo0yqbeaGJMgzc2EOtL59g2Qub+u/1RFczT9xDsLycttCoKDdvsKxNtpVuLrt8hyLG30ChdtaLnRJcFnYWmEirr/GrXXJ0uirXXOMVjDtDAE9sBlzlKy7R0OTSHKBA6s7Z7T7zWE05hi0j1mY/RRrWY0hYXrPo6SWLYhodqwAAKIFmRXvp3u9MsXhlz3ZRo6mc27gS6D03w2pF576tcARImQjhkRpb7pEXB4q06YfYMj2RQQSLVqLRultQN0lQKQoU0XzNtfnbTjYRlAZpnKHF/kr6elNb0cY19zBP0EOSj2mgLHyRsILSXLP9++necxtdd9wCVk8v3zkOkFbRx5b+fGi4qKAtLMrC1A8rpk+J2wqCG31EqoCHfvs7IUrJioba6lAELc5OxH2ZcYC87EwpLPe8txz9OG5w8d+NSpsphTWzcoEU+1MwK4qWbir61qUYZeG+sz8mffyUu/lJHvHT8kptKY4c6KxkqluaiBmT9vi4NMD6FMBDKYTmxRMyVfBkzYQV5rcSIcU7PWXYrGBEgxdlbUmQPn6N
 QT6XeSgC
 niDnR/8QANW6msphiCqTApRWz9Eo+YrF8LxBVkHyUuWirwp5jxfJBt4TRB9RnAAF2jU5x3Ac1Dd3akSjxDw6iMr+IOMmgkC6DrMrpzmKKpdoVsNipbNvSAIMvynNr/6mBdslmyFaC1EBMTGhdbvXncMQrKCa3wqlkuu14Vj4IZDnUnIkQKzCCRNVaFPFBqeeWbsWnf4a2zKKje2fKMod5CHfraY/nuhQFWqojDchvoYKNJ37wQCJy0ACP2I2S9ePPDNtqqa/rnwYcroUYciUol5deb3tXdjCR4ATnLnzGUiuOQeQsccMmDbHRIp+yIAqrGsnya/CifMnGtXW7oCyVNakxKfU2pAW+qp8bmWw+ACccvGTbGyTx3TeDy/TKzGOU2Ykz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 16, 2026 at 05:48:11PM +0530, Sarthak Sharma wrote:
> > +/*
> > + * The owner of a file may page out its clean page-cache pages. Run as an
> > + * unprivileged owner, so that capabilities cannot stand in for ownership.
> > + */
> > +TEST_F(madvise, pageout_evicts_owned_file_page)
> > +{
> > +   char *mapping, *control;
> > +
> > +   if (!geteuid() && !drop_privileges())
> > +      SKIP(return, "could not drop privileges");
> > +   pin_to_current_cpu(_metadata);
> 
> Is there a reason why we are pinning to the current CPU here and not in
> the next two tests?

Oversight on my part.  I added it where i got a failure, but didn't
carry it forward to the other tests.

> > +   ASSERT_EQ(mapping[0], 0);
> > +   ASSERT_EQ(mapping[page_size], 0);
> > +   mapping[0] = 1;
> 
> If both pages are on CPU 1's per CPU LRU batch here and then hte task
> migrates to CPU 2 here
> 
> > +
> > +   ASSERT_EQ(madvise(mapping, 2 * page_size, MADV_PAGEOUT), 0);
> 
> Then this can cause lru_add_drain() on CPU 2, and therefore both pages
> do not reach the main LRU list. Thus they won't be reclaimed and the
> test can skip here since the CoW page wasn't swapped.

I think there are other corner cases here as well. So yes i'll set up
thei pinning - probably worth it to just pin the entire suite of tests.

My original set had a bunch of this tested more explicitly, but this is
really implementation details that are not worth the additional test
complexity.  I think we can just rid ourselves of that and just pin
every test and make sure it does what we expect in that case.

> 
> > +   ASSERT_TRUE(pagemap_is_populated(self->pagemap_fd,
> > +                mapping + page_size));
> > +   swapped = pagemap_is_swapped(self->pagemap_fd, mapping);
> > +   ASSERT_EQ(mapping[0], 1);
> > +   ASSERT_EQ(mapping[page_size], 0);
> > +   if (!swapped)
> > +      SKIP(return, "MADV_PAGEOUT did not swap the COW page");
> 
> Also, here we skip if we couldn't swap out the CoW page. Won't it make
> more sense to check with pageout_until_swapped() first if pages can be
> skipped, and then fail here if the CoW page wasn't skipped after all the
> retries, similar to how some other tests implement it?
> 

Ah yeah good catch.  I'll adjust like this:

   /* Ensure pageout-swap actually works first with a control page */
   control[0] = 1;
   if (!pageout_until_swapped(_metadata, control, page_size,
                              self->pagemap_fd))
      SKIP(return, "MADV_PAGEOUT did not swap the control page");

   /* Run the actual test */
   ASSERT_EQ(mapping[0], 0);  
   ASSERT_EQ(mapping[page_size], 0);
   mapping[0] = 1;

   ASSERT_TRUE(pageout_until_swapped(_metadata, mapping, 2 * page_size,
                                     self->pagemap_fd));
   ASSERT_TRUE(pagemap_is_populated(self->pagemap_fd,
                                    mapping + page_size));
   ASSERT_EQ(mapping[0], 1);         
   ASSERT_EQ(mapping[page_size], 0);

~Gregory

