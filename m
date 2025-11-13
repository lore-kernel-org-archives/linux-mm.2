Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9D2ECD5BB8
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 10:32:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23D808E000B; Thu, 13 Nov 2025 05:32:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1ED518E0003; Thu, 13 Nov 2025 05:32:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DD218E000B; Thu, 13 Nov 2025 05:32:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EA89B8E0003
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 05:32:18 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 768DE5BBA0
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 10:32:18 +0000 (UTC)
X-FDA: 84105219156.12.15C0A0C
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf16.hostedemail.com (Postfix) with ESMTP id 70A61180002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 10:32:16 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=fromorbit-com.20230601.gappssmtp.com header.s=20230601 header.b=yvtdwd5b;
	dmarc=pass (policy=quarantine) header.from=fromorbit.com;
	spf=pass (imf16.hostedemail.com: domain of david@fromorbit.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=david@fromorbit.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763029936; a=rsa-sha256;
	cv=none;
	b=pDf0aWuCcZLlyx/uj+dMAo4uCfG8ag8r4uchrzgzPoYiTsBy53aUaon2pwvjkpMr93SSPh
	NS0HnhfUo8N1kNCCa5Gtj19YAcbQHMSE1I5aJe+iiNjJ/3K05uOdEc0XDO/trGg8xmciP6
	jbyYWgblD3bzCi9cbsX15B9Uyp9G+sc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=fromorbit-com.20230601.gappssmtp.com header.s=20230601 header.b=yvtdwd5b;
	dmarc=pass (policy=quarantine) header.from=fromorbit.com;
	spf=pass (imf16.hostedemail.com: domain of david@fromorbit.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=david@fromorbit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763029936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QURbCPhZLgDFuDO50oTy4YxAU/M/cxLF0F1zsVf26eM=;
	b=6MKaPHkcJH3mSdt3Vr60/frhxWCwshhCtUEw88jK0n0dmTjZmP7I/TR/utZX/kFAm1Nicm
	wQQHmBveXLvg6uxny1vzPpNuTcainIN6Wj4rvAy3NEHmkBpyQPpS0WmACxIuap6dZ9H9I6
	asAb5WjLfBr+aVnhU+58usfapXRkxJ0=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-297ec50477aso4456735ad.1
        for <linux-mm@kvack.org>; Thu, 13 Nov 2025 02:32:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1763029935; x=1763634735; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QURbCPhZLgDFuDO50oTy4YxAU/M/cxLF0F1zsVf26eM=;
        b=yvtdwd5bZDnaAmd9WseJguvjh0YzY7FMMtJyPN9zAQav8V+WHtpaqzrnyXqcaDP3Hn
         R8r2KXIIezBS7pSRjyItN0CFnmwg6Gz36cfHHzUd1CXoNx+ZRtnnoub39Ej2JB/D8beS
         N2g/m81wYDfaK2X6XcqAhYNF7GusIUZlG0jamKVM6XwL9COJx+GVuJyyNxgBKwdzs6qO
         R459ABWFob5MH2Zhpk+9vPdT7DIWMLlqzKFU5ya7r/VsBRjUDnnqk5pjY5wIxzASA0tF
         S6A6F1GZa0YCikzdCYZH7ZCnepH6CYP73lKMIhUYRXTKhB05dVNRWMLu9NwnppDXlbbJ
         +XVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763029935; x=1763634735;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QURbCPhZLgDFuDO50oTy4YxAU/M/cxLF0F1zsVf26eM=;
        b=uouHh7BymcDBsTH3MMct1SKS8LLBmjzCi9aEqpwDkyqN2U/upjHbo4ic20wDwm+0Bs
         Zx9JuNMziw9i2Mu88qddV4Qn6+k69RCUpK00YzehqdoKmybbSjBG8TZRArhL152xZ7T4
         zEfRVH5Xo+bZNYRuMbiIHa4+KMkSmY79EQIdqCemz4yzt/gw/hVlwbqvXgoZvBoWLHMN
         7TC88nq9E+gFePhAYveSiGbKYVqlJSzH/Zvt/kNthUbh3m7GXe8Aho3cHhhZo4vp6iCk
         D8QdlXb5gvtYnbaTC1S3jO5QBc34Qnf/Nm/cHVN8/jKn9ikMAKdqWDEcaq2P6qszm0bj
         ByUQ==
X-Forwarded-Encrypted: i=1; AJvYcCU1kzsnZpa83ewo7d4CuuBRRyRKIieNlLdJWEDbDC0WQd2Vuadeq3qrO8b8heHSGU1Ks5dniAHTFQ==@kvack.org
X-Gm-Message-State: AOJu0Yzod41dA5MpddMIV0rnQBWfEs3+W4qBB0t3fh4QtiWGOW3NFM1+
	roLVEArG42etFxaMC7j4Ahh9JJ9Og03A+YqLvYb6/iTdqapFi1bvExbF+MSg/Q2O7E4=
X-Gm-Gg: ASbGnct+NPTOg7SiTiBPXbW9t4m3wuwD1Fxy7zZprRvSuunZ5P6wAoxHB7uELgniPV9
	nXVKL0MubPXUQSdB0/kHTzTAn7LDpknhnyyzRgDpN76e09RctyBm8GoP1BRGLS6F/MlF9tIkB6v
	cQUDe3S7uydAxl2J8h/9a6XXNY0BfZ/7yiqbikK0B/0UwIAZ4O00JEmn+ADt0OASImdxK2islsF
	iNJCqYtI4xjxIR4A/fjVnH2XDMyXR337bd9rGWxu30rO+s4lhU1Lnj+OiB3WSjE5d1Thz6Y9Qkp
	27bn4OcG3gry/svC+jNUFXoUXW77UVPUI1vd/JHqR9iVsrozGEqbfUEKQrrLL8nXopHKN087XF5
	NuDz18CcOBPoQb866uBS7Sxgrm0eUgoPSN6T/b8/kn3Gbr377SX84oI2oylK4blK0qfIl3S6FwS
	7oWf6d4XB04Yy0mEb/ZUp49dx9Am91yEpDFg5IoxpHrIcpBEWvQ2U=
X-Google-Smtp-Source: AGHT+IHZRVqKk3Xf4AoXPh3RQ9USehQ1ClsNRN+oJOsjTDjAvAY9LII/LH2yTXr91VjJoLaVXeTfMQ==
X-Received: by 2002:a17:903:1af0:b0:267:912b:2b36 with SMTP id d9443c01a7336-2985a51863emr28237365ad.23.1763029934984;
        Thu, 13 Nov 2025 02:32:14 -0800 (PST)
Received: from dread.disaster.area (pa49-181-58-136.pa.nsw.optusnet.com.au. [49.181.58.136])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c2b0fe9sm20457965ad.65.2025.11.13.02.32.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Nov 2025 02:32:14 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1vJUcd-0000000ADSS-414B;
	Thu, 13 Nov 2025 21:32:11 +1100
Date: Thu, 13 Nov 2025 21:32:11 +1100
From: Dave Chinner <david@fromorbit.com>
To: Ritesh Harjani <ritesh.list@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Christian Brauner <brauner@kernel.org>, djwong@kernel.org,
	john.g.garry@oracle.com, tytso@mit.edu, willy@infradead.org,
	dchinner@redhat.com, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, jack@suse.cz,
	nilay@linux.ibm.com, martin.petersen@oracle.com,
	rostedt@goodmis.org, axboe@kernel.dk, linux-block@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/8] xfs: single block atomic writes for buffered IO
Message-ID: <aRWzq_LpoJHwfYli@dread.disaster.area>
References: <cover.1762945505.git.ojaswin@linux.ibm.com>
 <aRUCqA_UpRftbgce@dread.disaster.area>
 <20251113052337.GA28533@lst.de>
 <87frai8p46.ritesh.list@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87frai8p46.ritesh.list@gmail.com>
X-Rspamd-Queue-Id: 70A61180002
X-Rspamd-Server: rspam07
X-Stat-Signature: wekjh8cnaaprxi49m7ki88fpu9ifhkh8
X-Rspam-User: 
X-HE-Tag: 1763029936-731353
X-HE-Meta: U2FsdGVkX1802aasyyvEqBIv/FMbO/fAnjyZyTZG3XypP/w1pSEsbSNEZqmEtHRTmXp+3tG5Ga702F3q6pNlzLBPQhGNtT8FiJNUN2SHua9JVVrohtYDlWMm7dGtWjEC4nQHQSEzXmEq7MNcL3JD5/tw1El2Weso7W/xIKT33tuvKAlLn3e7qhuN/vgVhpAkqW8ikfuYBFjh6PnRF4GCvuMHoUGPahQoJ+da2chZ6+LywEMAAQDWiWSW1lyd5vgK+8e4Z//+MTySP5m+BaDeWNrv1aRP8GG2jujdAntr69KNnECnCA0anEgx7jhgr0Ks5Ia63AP9wUv2rOnryesJ2y8xoYEt1f9SzJgqMMecUFj9EJ3ULjj+l1OriXQXtvlp8n1zIzVwvuIbbN5jqRk24F6Rt9aQTY72aAK9EHukylpYu+8WNaJeN5RUSBw45juVCWbmkGLFAQJ4B7CefMEbHFHRBUpEQOeb+2TpzRRCTcXAw4ZkZoLp7p3Yf6TzWWjdWIn48EYdUz4r9y2pwbnvdpDesddnv8zFrTTGgfD1dOPHUV9h7jOp6fENH+uUlgheJiQvtnn5YVUet61AH5krYxAvCFN9SMAkSuZ54N2qcNVWRVoJBRbCmMLRfsrdyu6gJv+kifhmolKifIyeEZTFPYt46Hj2j0Y7PWHDCZFXisimPL3sD8awlbZieZvbHTAeMSCCfTKdItj3aVVBegtAAw34SvDFE9aQKvoTTuD2tbNFz22O1chW6pANrut55ZQYwR55sZDNy34fx6vIFCyMM1Mar52oB2HTGtETkwve+AojfNg0RT51miFPE+hy79nQCHjZNb7YCrnIJtCf0t6OMP/bAItw0MVRLGVl41lkbWkSoqdiyngmcj5uCCTdKjjatNN8GpKnYwmGPn/kAe+3nZu9PnwwoZX0Eq1esG1q9M+V2lPyJHHw4EltybdCC2wNiy3WZvqf+53XkVA1Mts
 XPvPNwOw
 v2qIiyBkRDhMnAcA71ec9cCBh69ugcKDMLPjD3eBCRlCPkjib1y/6eiBhTWRaz3PNMAiW7XjsrDGvW4k0gEi1TMytiA+oioWISsEPsDHku0LBYHBeg0jf7mwJ7WUayIcJUB+yEjUh83bgP4pSZpFFxysw+kSI0zoy2yMtrA/A4VsZCvgrKILE3DravSkKg4ihJ6RdU/OOafpdWBozqhOtzqPuUmoMWBILdDUY6SJvep5vesrfrrqyuvHZ/ysGugyttrMCd8OOjbHuPss+XbIn4wH1QO+w1Tu9WQE5YU0VkZMizqDbBWpLJ4j+NRMgzIbPYYo4FywPyzanhVsnhYKQR7NhKEnIAy4jwlflg7uy5VcoAg1rbJ3cMTrkf/cVDPUjcxWxybYyJ9tqSxhoDLOPRenwmHFryl/PMkhZxxqaQ4MGoPUZtvzWTSLT92UnpVS/0KcAtPrVpeTtMk5+Y7jTcqyBbrNvbqDCr6petgw9KJ0PnrT3lFdsxawRMzfytX+V/nnyny/4ZW/WPDKPFTnItvFGTVa8rnx4i4CyGIF5yTS9pqI8BDWc3rhTxtd8/020dsgRS9r0sN8jnLY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 13, 2025 at 11:12:49AM +0530, Ritesh Harjani wrote:
> Christoph Hellwig <hch@lst.de> writes:
> 
> > On Thu, Nov 13, 2025 at 08:56:56AM +1100, Dave Chinner wrote:
> >> On Wed, Nov 12, 2025 at 04:36:03PM +0530, Ojaswin Mujoo wrote:
> >> > This patch adds support to perform single block RWF_ATOMIC writes for
> >> > iomap xfs buffered IO. This builds upon the inital RFC shared by John
> >> > Garry last year [1]. Most of the details are present in the respective 
> >> > commit messages but I'd mention some of the design points below:
> >> 
> >> What is the use case for this functionality? i.e. what is the
> >> reason for adding all this complexity?
> >
> > Seconded.  The atomic code has a lot of complexity, and further mixing
> > it with buffered I/O makes this even worse.  We'd need a really important
> > use case to even consider it.
> 
> I agree this should have been in the cover letter itself. 
> 
> I believe the reason for adding this functionality was also discussed at
> LSFMM too...  
> 
> For e.g. https://lwn.net/Articles/974578/ goes in depth and talks about
> Postgres folks looking for this, since PostgreSQL databases uses
> buffered I/O for their database writes.

Pointing at a discussion about how "this application has some ideas
on how it can maybe use it someday in the future" isn't a
particularly good justification. This still sounds more like a
research project than something a production system needs right now.

Why didn't you use the existing COW buffered write IO path to
implement atomic semantics for buffered writes? The XFS
functionality is already all there, and it doesn't require any
changes to the page cache or iomap to support...

-Dave.
-- 
Dave Chinner
david@fromorbit.com

