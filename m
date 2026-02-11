Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5D2BECD6F6
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 22:23:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAB026B0005; Wed, 11 Feb 2026 17:23:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E96146B0089; Wed, 11 Feb 2026 17:23:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA6376B008A; Wed, 11 Feb 2026 17:23:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CDD676B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 17:23:55 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7E7FF16052A
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 22:23:55 +0000 (UTC)
X-FDA: 84433604430.05.5809977
Received: from mail-dy1-f177.google.com (mail-dy1-f177.google.com [74.125.82.177])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8FF2F14000D
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 22:23:53 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XCGS3qyH;
	spf=pass (imf09.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.177 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770848633;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2aPMYahgom9IxZ82sjrZyGh+YU8kYPUynbCqDa1XpeU=;
	b=lM51i2++w5aTRMzW22hoQkEMXQmWJgQfVY3D8ZDyz+eC7BJ2pX5BNDVHHPqFU75/prIV8W
	aCySJHGCQAz6hCN55hWQGIRpdmOUpRwCZk20SF/o5SV+dl0b+QhV2XoBIy5GErojF+G1Ri
	nlmZkniqcOpRPlDkoIEQgK9gnMw/+Gs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XCGS3qyH;
	spf=pass (imf09.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.177 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770848633; a=rsa-sha256;
	cv=none;
	b=Q06Gh+3OoEjecSg+YIsod1jYqnVUi0a+mY256v2qUvzuYXX4wPJE+T4xcpuHkQxccumWVO
	NeuMK3n1dH/Hse0lVn5VmQRgZbJK18LSWLXKeI6v5LEx7HDFhENxYaPay4m8sjyL6lp9Cm
	eTbc7/G1JLsf0o3Lg0tavxMBnSP0ECw=
Received: by mail-dy1-f177.google.com with SMTP id 5a478bee46e88-2b86671f87eso689486eec.0
        for <linux-mm@kvack.org>; Wed, 11 Feb 2026 14:23:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770848632; x=1771453432; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2aPMYahgom9IxZ82sjrZyGh+YU8kYPUynbCqDa1XpeU=;
        b=XCGS3qyHuBpT0Qo+WR56YEVEqqqdO4aYYjlAw6fu0Pq0LeDFEl3HYASyI7m0gucYl6
         4zIA+ev2HIVpVLsNnX7thwk2OdM8GKndB4kq7T2TuXVSbkFAnZSjQ5nJAtdOwZ18XRob
         FJUnLXBHoJ8xdYDf+pvZRIoJn4/7x5ryS/6hwJPLUQ7P4rkKGnjaM9S3FoThDDJJhm8p
         iqcThO4UqWIKbfInhiLW5ZtR9vohcCh9XsYQEjG2qUsdcagVQFmihc4hABJjXBEFUKnF
         uqR9OlxqXOWjKW+04SuLwwMLVOCR/hYy5pSoBEh1LGjKmZhUbvPMM3L7ppT/I0DZG1e7
         AMeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770848632; x=1771453432;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2aPMYahgom9IxZ82sjrZyGh+YU8kYPUynbCqDa1XpeU=;
        b=QB9qeQJV3PNvwIUA4CymuwX+DbMQluPNf4FI6kj60bI2RG+cy96Y5VS52jObb2+Nbh
         JogAnB7YVnBlh8K/eQaMoMsn4geUJjw5N3nrOO1+fUSaVXumGLUlMrj0RI+c/Thov9Wt
         UMVm4hZeopdnBMyO074cTG9DfPtzoHhFNkGQUo3fDa5+vwEA7zuUplbrtWYPQCdD0xJU
         1K5c+HEzojSXHbUpgI7AMhkb7ui/N2+JQak/Cx7zmRfRc2RP/a7g2ISKwZvVWjg8NK3W
         r2YL+gseGLrUScNDRqOHzri2bmGT6rDtyUartoVJIB5lzY41q1gfGRR2c507qkSixih+
         KhSQ==
X-Forwarded-Encrypted: i=1; AJvYcCUQGf8MN3HQ8LQkPeoSW077DQvFlNpkfArEiNqA9b9P1lKUey2qUIB9O/O3oKscjsBKT8fifuCRSQ==@kvack.org
X-Gm-Message-State: AOJu0YyS8ComkZbuYcYIYjweb7CeOLZPAAytc8perGmfm3QQlaYMJQGm
	bQbaEYYw29YZ+r1t600kTfAj1sXJo7wzeaChAN0RA7zTTaoJDsv4450X
X-Gm-Gg: AZuq6aLncllEPWGIvGqVhW0MMlD//Oia/Mlu9gF8Y+VvwPYzECYjoroSaUo62H4i2h7
	Xw7Ns9PFWB0vq0OA0VVtC6xQSfh8ZvY2rzb9NSeBPUaRyp4xILZb7cPHNiWuORuUt1t2kD5qDc1
	8sripe1DMw8B6hEcaPiwqWwr8yL204Ic3kVAbeIdSArLrZj6tCHycbbJBuj93MhGLKd7CtZZwuF
	FUPZTSFDVUqQbDEygLmqx/JMuTJIdLtWvOX0fPpza+Y7kMOgIhbPNPvqzN3JVqoGibeX5jcuT83
	OwPyiKCs8oWyQdIh6HcvqzXsFC9MDKwr51MvrEhGGH5pPrc2b1i3lWihyWWnupWk3SdFo/vN3H/
	xYL6bi1Uqk9Gwxft44HsBJRxOJpVoB6lLTCzFr8plskXVnHT+WbFCgZ2hSHxpEC4rrWh08/DOb+
	WhBkOiWGgUGEwfPSG3aEt2dB342KQ33x1E9qN5YCZvQfCV5r0suqtYHSs=
X-Received: by 2002:a05:7300:a887:b0:2b8:66f3:2522 with SMTP id 5a478bee46e88-2baa7f66c67mr448011eec.3.1770848632266;
        Wed, 11 Feb 2026 14:23:52 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2ba9dcead67sm2228631eec.26.2026.02.11.14.23.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 14:23:51 -0800 (PST)
Date: Wed, 11 Feb 2026 14:23:49 -0800
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	akpm@linux-foundation.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v5 2/4] x86/mm/pat: Convert pte code to use ptdescs
Message-ID: <aY0BddJ9Xm6OsC_-@fedora>
References: <20260211195233.368497-1-vishal.moola@gmail.com>
 <20260211195233.368497-3-vishal.moola@gmail.com>
 <aYz65w4TP37_t97o@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYz65w4TP37_t97o@casper.infradead.org>
X-Rspamd-Server: rspam11
X-Stat-Signature: h9que7n3i9fd77cnewnzmdw8e1uom8rr
X-Rspam-User: 
X-Rspamd-Queue-Id: 8FF2F14000D
X-HE-Tag: 1770848633-204113
X-HE-Meta: U2FsdGVkX18UY6Z3ctlgCRdk457U2gnQANAt1crkHPsPJTTV8+apZ1AtMeELQEWAbE+8+guZBngTM3ByoeaE1XQyq8iYkFRs+9qYsQvGy/FTYejkopJQlkRdRE9G3LKkaJBKs0qMySYTxOtHB4Ghj70Bgr/xpo0tV4jO4tulrSrT37sPcC1oafFDifqJsv20baif0cPwJs7WWpbSt7DWery/UxKQVgK2y1TznzjJDBAhV4p4xKWqrR2WYLwFwfHNCrTtu0bzzHWW0mZ7tJLw178dFCwJtoE8WKL/XUufpTlqJ7wp/NQ4IxAMnj7bPJMr7FsPcjtYxE8YUepkTDdBbSVbjaa4efk2vG1LKMr8xPUpvJqQhLQJfuWuqNYwHVPO+CdwMSPM9Hu2+LLakJBNI8a77rOFEAxUJ72OsTgyoYxLQkuerQgnybMzOl0L7gQo6dD0QtIciVB7F9pVtJYpLpsrdoxTCIsDYweJbehLK7+5VT/ffoSCEJ25bSsTC8AaYOvwY8AlV7WTxhdX9b3pxAWguCpiT1x8ElZI/47ysH/hxF87jyTrny3MdvkQ0KN+NXzoWfIp/MBk/xDx7eTGWe2Psb5jsifYNVToq3f18fcrH0MEwVRulj2vEXGMtW/PKaKHaurbWThA1Zrui00K7FP/TCyEPgEc2VnyYhp4kHg7uPX+z9c/I7PsQv+bQPBW+wHjjGO7jroI3YM6Es4i8r1BUrs6mjI5Qsp0hZvCAuUe9rKnzW6aoCa/OI7PMBDXEGR9q7+5e1y9oIE5QF22GU+k7fp+4ffYqL3djSfFr3i2T4MAc496WAJyp9V9tvglq5g9udyaKr2Fb9dMFzOEPRb+yMhgTCVA2B/h/FhZasUHbRvoiZiOwMDuRNw2yelID8uoHO489wfa9087af9xualRE1+r7c/RsT/UrtYpe+3Mbfe5/ks2JV0EbGC6dB8vzLyNfJDq10CSBjdhFir
 boo+a+n8
 C6oUwejxWSJbc4tPrXR7Tw5rRsL6BA305BtgvlXlwr/YvBxe0jRtV0UrH3Lgf2uCaO5kDGIrVN9nV8Va5KNTFr25TjacT45r0W3PxDvLK5R+3LO7fSCEewZb5MGgh0XMSdpXxlgf2X/1bR8XjRdEE6ievtBw7IBQ4sZoR+rLy+/CZ0Hl6MGk3T5Ra+kuMC/CFWoVXFrEIDessDZTBHFRQxLJp3egbOMRlUZmnZgmWmBwQp49ME1fUbWBieAu2T+qbKfyq/W3gKllALm9hDxC0KzGKMDoCJmYV/RViLHgztoe/QKP8zRhETnwFRsOn82ZKML8V4U4bzHavZIUh6OSN0DB+2/ih28D3pDvp5BebjVQDi1JvIoGQ37KYp2HhyKecBVCOE8BKXZvZfGftYZfSXMehh7Q9Kocd4u4B/I+rI1DCsuew3KiUABms9e5jQRlmDeYC/1A8PiROY53i7K0jjwBBY9ArfJ4ogZsLUEd7k9lIqdl9PLmOcbKB6nfDwjHOxowPd3Ci4TRoEujVqzOj4oTFHemyfm3vRivv7qn80v7ol5wouyNiknms5CoeRbkUHC4Wk5PxmeBVVj2uyrb1JQAYpA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 11, 2026 at 09:55:51PM +0000, Matthew Wilcox wrote:
> On Wed, Feb 11, 2026 at 11:52:31AM -0800, Vishal Moola (Oracle) wrote:
> > -static bool try_to_free_pte_page(pte_t *pte)
> > +static bool try_to_free_pte(pte_t *pte)
> 
> I don't like this name though.  You're not freeing a single PTE,
> you're freeing a level of page tables.  How about
> try_to_free_pte_table()?

Ah, right. That would make sense to me.

Dave doesn't want the renaming at all[1], so I'm planning to leave it as
try_to_free_pte_page() though.

[1] https://lore.kernel.org/linux-mm/20260211195233.368497-1-vishal.moola@gmail.com/T/#m72f1d8d91b16f0693cca4271cc8685d2337372d7

