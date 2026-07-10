Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE413C44506
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 16:27:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80E906B008A; Fri, 10 Jul 2026 12:27:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BF086B008C; Fri, 10 Jul 2026 12:27:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AEFA6B0092; Fri, 10 Jul 2026 12:27:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 42FAB6B008A
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 12:27:54 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C58D01C3C4E
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 16:27:53 +0000 (UTC)
X-FDA: 84973398426.11.1B992B4
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	by imf03.hostedemail.com (Postfix) with ESMTP id CBD9D20009
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 16:27:51 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=ilmKDi0L;
	spf=pass (imf03.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.44 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783700871;
	b=dPl+WPGqFzJBla5n9jUbzRM5gTXgkfQR3snSSbB2FPC+X/Ohxr3rNMiaMNd+iwAg1YcBDJ
	bD1e/fQoi6HICrvngQ7xE02I/T08TrjDjrBTNt6TCdqPteY+eWMrIIiUhNQNru+9EtxbxL
	lhyZflw/CXNnyXlBqKVhWdQA6rfW40c=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=ilmKDi0L;
	spf=pass (imf03.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.44 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783700871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UNIXCm8Zus/z4nQ3xLBTLCwOawMM/+5sDMMsd2dm66E=;
	b=zzPPlaxGwrUILVqI6Ya2i/GxwLSoYDF6F0wFu7gbSPGEo/VsiCsQ7VwLEs27XlUq3VZgu5
	IwrqNtpJwGHYt9XfAJWMs0vvi0N/adNaFUHWLGUvYfldQLYpxAw2ZRGLER59yfRoq1voVX
	gsQd92kOtKqEFmEtqjDR9sx573uW/tw=
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-8ff88549786so10835836d6.3
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:27:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1783700871; x=1784305671; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=UNIXCm8Zus/z4nQ3xLBTLCwOawMM/+5sDMMsd2dm66E=;
        b=ilmKDi0LiVY492j/FuBGvLOGhmE0XHrIN/liU0eSxombFocfxKcZfiYuaAXJtRe/if
         uILGq3oGyBo0kTiRVqBbEBTGqqIY3bra6lWCZY0LwEk7UxwyhAihGlghxcDNI0tIHOBx
         JPNNhJ99J9Fqc2rt9PNb8rWSFPEd4aDw8t3QN/Lo63u1bGEAFDAb4ddeuLl2jiEDnXMb
         noQ7IqmVwKlZ9RqZcwNNCVbR46wegtqk8saxCSdy1Naik4SXh/tEi4qVkmeFA9fgJ1H1
         4ybH/1dyD62u2/4fAbuH/zuvaNVVANLx7ynJnTAS62DN+p4SyhMOgtzalq+wuaNUtDKW
         DaFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783700871; x=1784305671;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UNIXCm8Zus/z4nQ3xLBTLCwOawMM/+5sDMMsd2dm66E=;
        b=P9xYNWG8JQDFSVznRt+GvUL5GCLmm2YMKaJ13RVy0PfCwbztP8iw6rHBl5hbRI/mVj
         4F+gW9b8ZLQ5ZRkVAEFknqHp3p0wDjrrUxHhD3i/03MJCF5KAOyuLc0xYpNunaj67FS8
         EUlybYqOeOZC5uVzqLGykRgCkjTgOgIaeFrxkr4QsVf2/aOqw3LolBbzMO3thCPaKeJ3
         3fy9xF6BujYaFQzERnxUbiWQ2SI+JJIuC67T6vcEwE1DFrM5vQKXFvzKD4dR/+EuNAYJ
         aAFcVOgz2gE0mf3f89Vs7v339KO4mulJV+JKVLEUTyaBQDgGuFIcaf+GPoq3Zg/PlRQh
         Kj6w==
X-Forwarded-Encrypted: i=1; AHgh+RrMWavbiLXN1vpBJQk3aJaxHulgB/hHLSIcRv75dRT8GkUnjzLoztZgA2Y+rvZ+/Chp4lqvEwspNQ==@kvack.org
X-Gm-Message-State: AOJu0YyeDc+5lc1FzY95VhjP1aNoTar1LA3jfuhl5LhMdG/aT3sko6G9
	oCm/EN9dBhx+/uZheJqdzoYRjvYwMsvvfAhAKcDyOl84Lsb9PnA6ZSMg2NuB14Lj2PY=
X-Gm-Gg: AfdE7clNU/Gizp5YyEN++CKDYMHbZ5y01RPeYk3jfYwV6p5Y43Hnmp64zYQeg+9AX+U
	fJjH9S3e0njQajtA8F2meGNTB78pqG2ph6R/lgudHl9Ymu45VpTUw8mBHL3OWC10UYZzjqD9IUl
	Jg9ZRZ+mMLbAsBGwWTwbBuFZLnuPewQ6nNOKhyyabMAKuLPr9Z3lwpR26Yk63hKnqsUmMRi200I
	eDHvU0Ao42SpgmDD/KlBH7ZcsObH5ZSL3aAJY3jGuh7MClXJYu1Mm2kzLroU+CBUKC0cgICih/C
	0INi9TobLnLIrC3WGccCey8p+CjDz9aPKNhKDptoMzGtKq++caDrvrZxL6MFspnbWQQ5V0punG9
	OwWVBICUQs+LiWPhDinhi2rb9K4ehXBIUs3wWvBRFPoFB/vzlTaCsw93IXjnnH7Qy+qXheOw=
X-Received: by 2002:a05:6214:2127:b0:8f5:eea1:6f04 with SMTP id 6a1803df08f44-8fec3522cffmr120531466d6.54.1783700870475;
        Fri, 10 Jul 2026 09:27:50 -0700 (PDT)
Received: from ziepe.ca ([159.2.72.92])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ffd50e081dsm44781476d6.9.2026.07.10.09.27.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 09:27:49 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wiE4r-00000007XPF-1WDC;
	Fri, 10 Jul 2026 13:27:49 -0300
Date: Fri, 10 Jul 2026 13:27:49 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Stanislav Kinsburskii <skinsburskii@gmail.com>
Cc: airlied@gmail.com, akhilesh@ee.iitb.ac.in, akpm@linux-foundation.org,
	corbet@lwn.net, dakr@kernel.org, david@kernel.org,
	decui@microsoft.com, haiyangz@microsoft.com, kees@kernel.org,
	kys@microsoft.com, leon@kernel.org, liam@infradead.org,
	lizhi.hou@amd.com, ljs@kernel.org, longli@microsoft.com,
	lyude@redhat.com, maarten.lankhorst@linux.intel.com,
	mamin506@gmail.com, mhocko@suse.com, mripard@kernel.org,
	nouveau@lists.freedesktop.org, ogabbay@kernel.org, oleg@redhat.com,
	rppt@kernel.org, shuah@kernel.org, simona@ffwll.ch,
	skhan@linuxfoundation.org, surenb@google.com, tzimmermann@suse.de,
	vbabka@kernel.org, wei.liu@kernel.org,
	dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
	linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-rdma@vger.kernel.org
Subject: Re: [PATCH v7 2/8] mm/hmm: add hmm_range_fault_unlocked_timeout()
 for mmap lock-drop support
Message-ID: <20260710162749.GP118978@ziepe.ca>
References: <178345345668.660027.2952911919681614557.stgit@skinsburskii>
 <178345362182.660027.12809852179204464964.stgit@skinsburskii>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178345362182.660027.12809852179204464964.stgit@skinsburskii>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CBD9D20009
X-Stat-Signature: qs71ocikbgkorgyz1jb57uqqgfdn9srd
X-HE-Tag: 1783700871-368474
X-HE-Meta: U2FsdGVkX18+vmkUb0XRqe4QyMxpnWl0flD75Lw4rgUvNGF0v/O2OzSuwsaPoTvHAEHMT9YeXFiVlSqmTEEg2j667j3fsHJfjwo1FJ5NdRgf/789st7T8QNlEDlLbJcnC29x+CvxYTnSqyrvBPXgX0Lp3GHnC7j8blJEnFL2SpFjxQOrLza8xiJOi2rAmj5X1AmcMejf8/JrPvX1DeLEaLrbUlz2AY4lrHwcwykOkV5tpeFTfIaOQ9cPHKGB2RtOrbLJnYaEPtwsTzJHArjci68p4ljHfxZ8w8MGl6m6/PeJMkeljUFJowfM8t4O4w8jlmSTgjj5HeKEbFavx72dvw5pQBNQALFLjI+AA59n4mVzR7nXfREqaQM8Q+J4YKa3MdXTekud8KO+YpLlyXL2aBROS/gn0ZgbmIZ8BpL9iEM8u2ypQUbNInoPBn63dkav4fnzOPWhHApDrog4mMJvbtPZOWNzCQnb593uG4qDaej9ePRgU5t1PqkR0VkwPTEN0XdMHU9ZilseOisftBc9f2Kv7PpbsPmngjtyB7dHj7dBZjvXV0WRQA8ROuDYR850DRQWYXK53kAGOjcCe1vcYQ4YJKBMUEg471OknjXzR3oZnHBNx1cpjcHJdeZ5YvjMYOklcvIQaf0ceUeXCX9o11SKRJXc8sXDtbu2QBSUBg9M/VVDQ+ZYwmVThwW+kcEA1mumcVluxgLFQjN0FI6HNgLxbH7D5DRbcl8VnFMaL+bV5DFkTkG8S1eCDXs6ecLIRYx09kjUrJDD6iDRIWy7l1zkbQmdztqgEMGPgphEro87oUbdWGyduBAI0luyIFH+eBrq/8SqtUXiTkDscdjdMwv1i4h0mcfXIweIO2uLa3OOE1pybpTlipPR+oqV335CkpvPl2g358FNWcfF1z3NLUikFkze4eM57MhhU2x73O4aYejJUY/yL5IXWYyjSz8Hxqa2XRtge34rILl90l3
 OE9VY/UR
 Xdj/Eb0+ZZL/rFcHMFIFm4a0EUvA3iAxcn9R+NTMOzOyS/nl1ZuS7Wd+pxu3X/c6Mz4iS11PP/yHOhC/G15j6xwQ1t8qzjcUKJ/n3LucyNc6EHl9jTpNjftU2SwipYHSif0+F1lHQhgnkkQ8gGSSwjGdjBWQX++Da0agoP5I/wBV5cND3ZLPCFgBUiFMt3DQSQl/3xglLNtpxdZWglMg4w5lr5dsubttwm4eFTLJAnF4paVfRZNLHuhFTclzpH2gbtMuruOIVNJTevOODQJsfSJKh9FCQpsnPCUiFw30dOsB7vRt7Ewj5l6QZ4cWJ4XK6ofTyT4poZspsw1xeIKgQFIT75BSnAxAv6glPk19r9TeX+vw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 07, 2026 at 12:47:01PM -0700, Stanislav Kinsburskii wrote:

> +int hmm_range_fault_unlocked_timeout(struct hmm_range *range,
> +				     unsigned long timeout)
> +{
> +	struct mm_struct *mm = range->notifier->mm;
> +	unsigned long deadline = 0;
> +	int locked, ret;
> +
> +	if (timeout)
> +		deadline = jiffies + timeout;
> +
> +	do {
> +		if (fatal_signal_pending(current))
> +			return -EINTR;
> +
> +		if (timeout && time_after(jiffies, deadline))
> +			return -EBUSY;

I really dislike there is a timeout here, HMM is supposed to be more
deterministic. GUP doesn't have a timeout, what is this about?

Jason

