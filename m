Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66DE6ECD6F1
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 21:45:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 790906B0005; Wed, 11 Feb 2026 16:45:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 768626B0088; Wed, 11 Feb 2026 16:45:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68AF56B0089; Wed, 11 Feb 2026 16:45:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 565F96B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 16:45:20 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CE94DBA022
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 21:45:19 +0000 (UTC)
X-FDA: 84433507158.17.B86C4E4
Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	by imf09.hostedemail.com (Postfix) with ESMTP id EFC24140008
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 21:45:17 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lIfQE1r7;
	spf=pass (imf09.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.171 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770846318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WbrdtXUZqdG9RbVky/2Xj3vrytI/PZAZDAo/EZQS2SU=;
	b=RGo5V3DyOfHZWxUkJteEUw6LLHYNKmdrFPpHJ/XkvwKOWcs71qGFIhwfMoc10ufmA4LBg1
	67xm+og1mLXp//z+SpR54NJBL6+e8OwiHj8549Jfl9w/B41iBIkIEdcZFTXk3E9QTe2xGZ
	Oo9DDdmCOyc+rYNE/B3hh2OL7VrFwGY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lIfQE1r7;
	spf=pass (imf09.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.171 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770846318; a=rsa-sha256;
	cv=none;
	b=nhlruWHop63fyX0e7Jsd+/IiiIFjYhYpmeiHcJwk58uTnNel1oOlP8UebxcUuzjHeBWaG1
	2i4v9O7hcd7ev0HV3QLkojZayj8TtEjCnFZ1BNkK0E9z5hYX/jBYNV4qT5QIuNtg71+EVv
	XcSsJVg/o7f4LnBwCPFZrOF78vEOwdw=
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-2ba68df3687so6363977eec.1
        for <linux-mm@kvack.org>; Wed, 11 Feb 2026 13:45:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770846317; x=1771451117; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WbrdtXUZqdG9RbVky/2Xj3vrytI/PZAZDAo/EZQS2SU=;
        b=lIfQE1r7WkIRXhGCFe/mqmvfhIRwCTqslhzoAJhRb/CYsPTSYbPD6b4fJFub/0MmIW
         RE6zREHUkDvl2RTQEZk6pJ9pj4IbozGiKU82dpfhk9QANoYdZ+HGhVTN191EE8siMuBk
         C369nX2dLbr2XbTN32CKoK777WQOmD+Wr+Xa7eCU7HJPcs8b+LakB6o/C0ykRkPODnfp
         Jpn1Nhsb4i+ZdZnxFascjyHTL37ZTsHODrlwvnuP1VqIurBjZHlBWFKPq3ZBshBC1ZuZ
         ceqSEo48y8KzaKHf1d7pbwBYK86rXGfTxLjM/iT4Qg2u5xEVhonEIOB0HQxRk8AGesUy
         EIzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770846317; x=1771451117;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WbrdtXUZqdG9RbVky/2Xj3vrytI/PZAZDAo/EZQS2SU=;
        b=skvowi4InmkhzCDgEPFkRRGx5Rtd1WLAWt8YF9f5tAugkPZr9m4QFEnr6amIR7KbvW
         CtzxYYdIowEjeMWjVapwJOtzEPOpZLPSV0eWybBFfS/vCOvjB2kNsjc0kTT33KZT0DtT
         XAV8WpYAWa57/DxSq5B2PAV1/kJVUWfT97fLDP5IslT/MctByfgVXJqtIxhR1LQkSYny
         vHILCo6au/ZvMkFOUuFppdkvAvkU/NcNAN9qUQX/b/tY+mAf/s7wv/h4m8BTssXhBcNH
         msjcXRsWts5KMDMAc8drjr98wz8UTlxRp5kZn8UhMDMiLYEWob9yOPzZiA3/xhjgLjKZ
         R9gQ==
X-Forwarded-Encrypted: i=1; AJvYcCUqEecDC6wobYXZSaJIVPM/t7VRyAUCOHfW2ejrG4AsFteds8kFgqabfZKlmdVNJ6h+qGEpmqH1VQ==@kvack.org
X-Gm-Message-State: AOJu0YyHRzFkSrcW5fa9mGUY+7JbcJCqOuicmkOvnHDkfO+VZd9jna03
	6DDYAxIdbOQzsczvKkHbOqBVn3iHuPbG1oMByYU+A+A/hjffJBfIUZsx
X-Gm-Gg: AZuq6aKPmlalrSC2ex8CoQCm1UtJKBdwTCgu44WzSfV0S/QJK5x4VbIo0uVD7KjTns2
	85pQ+ge3AMKR/U9hoefLwgHnSrSOZmPPbotqAzFPn0d7REAmUX0eeZ1Dzz8bUySo1JhTDLrrfaI
	xnQ3TsMWgAGurD0Sv+4qnpORDoez15mwsuN5C3Qv5Ngi7aFYdjNDCQP+iKD1U/4OaBaNI12HNQD
	fKsGNO7ULiKrw2Osk3Gm6VZGq1gsJyoO4rVz8EyqxnCvXbtOjKszWzZ64JwIZ4k+OpiWVyXiGUi
	4HGRUoshk812Tepvkf+Qz4jV/Ka/d/eusRMDUPhq/pvK7LAHsNH+Gh4CoBjZRHS6lnNIjxXylev
	TOT33KZ9vc9EKFgNqeHBQEVAot40Iq6js0DriO5bVahZoTORgnsB8UObA06EIK4gXbWJkO4NcG/
	FTdP3OgDX2OsZ1ycuDYlKLqqub299d6crtaqgYAxuo2rEyLHhU9uZFkjA=
X-Received: by 2002:a05:693c:3005:b0:2ac:1a21:841d with SMTP id 5a478bee46e88-2baa7fbbf5fmr382130eec.16.1770846316595;
        Wed, 11 Feb 2026 13:45:16 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2ba9dcd03d8sm2123316eec.21.2026.02.11.13.45.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 13:45:16 -0800 (PST)
Date: Wed, 11 Feb 2026 13:45:13 -0800
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	akpm@linux-foundation.org,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v5 3/4] x86/mm/pat: Convert pmd code to use ptdescs
Message-ID: <aYz4ac9cCW3EyhAC@fedora>
References: <20260211195233.368497-1-vishal.moola@gmail.com>
 <20260211195233.368497-4-vishal.moola@gmail.com>
 <29599d4e-c2c7-4f40-a444-28dcc3768ce4@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29599d4e-c2c7-4f40-a444-28dcc3768ce4@intel.com>
X-Rspamd-Server: rspam11
X-Stat-Signature: 7qd57jn8dmykij8k39nj8xowmwt9qx59
X-Rspam-User: 
X-Rspamd-Queue-Id: EFC24140008
X-HE-Tag: 1770846317-85877
X-HE-Meta: U2FsdGVkX1/QCxh28BE1VhrlnVNGAK1rLWqsKvjDGagXmGx1Wywq8IFGlSIHb4l6MmOs9Oa82+ITPfe/vn/SWY0tbRgUASvChDB1wjNRSK/S88t+z3AesYWfLPQYhuwszcHdYy3063K94rXt7Z6HPtbejLk2ZILEE621fhQJJbq0lBVRe68dD5LL4/ce55Smtfo5w44g76HhPYm6qeKPAI6J6gW2M09ASNKqtDFyt/afgw16h2XHBjzM/dc1/1ikQ7YYrdzacmfYbn14Hlf+pgxFOh9oG1OQzIoDnQKpo3t0/har9LD6m9D4zvH5qE4KTl9cw5tGwWPb6vvZZkGmEXWK6oJkhVY7HmYjG3VWzckP6AzShdDIebed14EB9TOloK/DpuNzE/ar/C1y3OzCFgpUMjWZYYdSHwcMktKW3pm8T1UO20gCNR+7DkplKdXb3IJfCyvtyYDx7sjI6ndccpji4RMJieKVKh8dZKtLH+UHBSxCyJtrLoTTcFb9kLWLQkNqGf2UyXBBGfgf7/O+c/DQG7ALNbWinrJAwEmnw9Q5Lk8Jb/MMXtislfwPji7t1cDsDhJECWi3smmDVdFNDUd0S0VYeTaZzyVE7oujln0wjp9QxEUbiHm20y648XxLIyRR9cGc0pzMy5Tj93bAG9AydyOE/PHQsg8LnksyhtkY2Iqxdl7+nDtag949/iJ5hFUnmmj3ggri0/W1l4bXtvEfqI9GZV/NB6PhEEurwbgh24xDQkE85wiPr80WF7VWj6LwwUZmn0wzxLSD4Xj/GkYS5fr2cPcbh9PNsvbCIMrJaYrGUfnBSDttnd31ZHrHtwRFWLQYiYijy+Bx1MSLCm3OAeOg5a1nuEmSHDpBnFhI8XXMf/pPDjGvcTfNkCeN3QzT16pYrUqptKo395p1Xu0B+ZbucAUPYML0fGf9/2PD7rNcTm5IqDn8WTXlZpX2GslNT4i+eC2VgJU3JKI
 XPZi0fKO
 CYCdOHg2ppbzVIjV5LcP83VcqxDuzob25YGDBaIdLB2/nb/LP+nwnO/X6nZySRsLU3g0KnnC0v/Bc9n3x04FrxCCTgKV6Jh9s4itUx8k7Xp96H1hg00YXMXTN8JruFOqGs22+BDBaAiHMe9yA2QZ2CM+/0CU+P6JYl4a3e/e57fF3+IqiYvkkqe6IZfz4kXwdl6KfN1qWnMdIYJpN5aY7/wGOcprJd+6b01HNyajqrm0LGpa8DDRmQSZk5NhrH+qY3U/7ZzCqMc27uv/PcTDQCsFupTWmKmFe79JHFQZxoBNizIA4e5wToO0wUJ33rpE8P3gLuKzp8xICszd1Bc0HaI2vt5EvfnRQv/h/Gpb+JSicWNUJpsd8jRsD89BfG5x5Ae54nkUW6RoCy8aBE7E1rq9Bvrzgf77K6f66/5Q1rCvqOVOWrVEYrOuuhuGpRenil/XtzRtVhkOgXafs8+x71ZMFOnXgwL5RQ9iQF4b8EmJmqUAPjUG8Iq/kdLHUfPRg9bOEbBPuzZRBtzCnrT0GXKKm/U4aLcg0baB9KKdnix3HjhztsZyi/SzbGHI/rpw6YcE6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 11, 2026 at 12:07:05PM -0800, Dave Hansen wrote:
> On 2/11/26 11:52, Vishal Moola (Oracle) wrote:
> > Also, rename *_pmd_page() functions to *_pmd(). Rename them now to avoid
> > any confusion later. Eventually these allocations will be backed by a
> > ptdesc not a page, but that's not important to callers either.
> 
> So, pages are still a thing, whether the API says 'struct page' or not.
> The hardware kinda uses pages for page tables. ;)
>
> Could we please leave out the unnecessary churn from the renames?

Yeah I'll drop the renames. I thought it'd be better for
correctness-sake, as the idea is to "allocate memory for a page table"
rather than "allocate a generic page for a page table."

As long as its using the right APIs the naming doesn't really matter
to me.

