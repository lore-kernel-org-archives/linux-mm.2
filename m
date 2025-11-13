Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B1A5CCFA18
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 05:54:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3B0A8E0006; Thu, 13 Nov 2025 00:54:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B13578E0003; Thu, 13 Nov 2025 00:54:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A50ED8E0006; Thu, 13 Nov 2025 00:54:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 92FAC8E0003
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:54:00 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 33FB189A19
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 05:54:00 +0000 (UTC)
X-FDA: 84104517840.19.1D03415
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7857E140004
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 05:53:58 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Oj9IjnEP;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763013238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=2UyP0ogKxI9Y1Qsu6mcA+/ZagVf5oyFn5jJYg/5sVy4=;
	b=BXTYtY1slrsG9xK+P9mUj6P9F9cDhaoWJ9uUuNbPgZEGMo/foODkDJkaj9t/Bp2FaHOtd4
	Ac11wcmWD02ec+OaAKQLpnAltxYqulx9HenhWI4lTJ7G0VBIS21EzeeYNBVsF1T58IH9e6
	PxcgGEvy5Ldt2Vk/pMejOOEmWHvA+4A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763013238; a=rsa-sha256;
	cv=none;
	b=cKg/rUqZWqHwCRbzfAJk+ccld/69UlrDvaDBUMZuIsxxeZB6F3W6HLRooHhVYm2o9IJ7Jr
	/SpuYVQ/TDjrB4pyuU2gCcBTPutbk1cvvhhUxc++KEmV3SuOgV0HlxHDAl/NrnwvLITes4
	b0mVm/7iYweVrzxNkr0oqRZPYRqZ6Sc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Oj9IjnEP;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-7a9cdf62d31so475971b3a.3
        for <linux-mm@kvack.org>; Wed, 12 Nov 2025 21:53:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763013237; x=1763618037; darn=kvack.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=2UyP0ogKxI9Y1Qsu6mcA+/ZagVf5oyFn5jJYg/5sVy4=;
        b=Oj9IjnEPW+jeJxAJ7xKzs5xHXp1VgcAjTLmd8SElip51wV47QOqNICH61yk9Qz9cPR
         1VZh5VovVpQTUeyXmMv5hYDbyYbancu/RMmTNfaHAC0pDOjc9kdkUR9Vh1kNZQO2J4sK
         Mb1ZipPxqo2Q6I+281fP4FHKa0Soc0Wy9QcxC3DEdrqdlIRcnjRO1wPi1YQ9IESI727E
         2RYes2jK8tVpNNMfKM367oe91ORjU6p/2TAVBp2/qqN2uJ6PpI6xfcJuXFiSikycb3GP
         ZIWfDvPweI2ZnqCOcqFJBjXVnYqeNiDSE2p0KZ/TLNhfwZNieuaIDrojG3G8fL3xK2+v
         7lfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763013237; x=1763618037;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2UyP0ogKxI9Y1Qsu6mcA+/ZagVf5oyFn5jJYg/5sVy4=;
        b=F9vlZgfcWLVQiGRsy8YFG6o24GQxOjycG2pBBJr06tTaNFxcFuMdFIb6qyoPV/ORrM
         R+yJ4C1v43zmap9UlMtt7JxmoNzHeQHTgQW8YjiM8xiS9OK7SisCGmCroiokNtjy0vQ3
         4G6QdjZcCPk72b9HalrsMIussO5tysVO0OnijHJL8SMyP4r/ImLtzKBm0ie+VJ3oGqDl
         D2nDfJzEX5QaGSYmb3FXZD4gGnorSEHk2LW65IUTyYTQQjRbeo2Q3vsE2UJ3hjYyFFIO
         a/WPBWzdpA+lHoy2gEShxbiMcfc2mMChvxo1JT9o64QEJmsqjXaLCNUcq0TXXKUmQf2y
         C2kA==
X-Forwarded-Encrypted: i=1; AJvYcCUyqiWx+WMAJexbDGubYC7hc+qa1fpveEjs1A3gZl/HLRPLIqkFOEcDgnA9079um7CCP444eli5Mw==@kvack.org
X-Gm-Message-State: AOJu0YzzsxnKJYVY70U5Oaoz6/69uOKneNh/NoxvTOTIZr31AFLcvNOs
	dCIKO6uSSWCUDAl84PmDhIrcFFK30ILjCuaKg0xjLFhwwT6hKv2ZUZdY
X-Gm-Gg: ASbGnctuVjllc96Tum5gEka/2zFmjUSoT7vJ+snUw6viX1K3s/J7B7DYskvTpC2jPVb
	KJnFPvpB45brM2TjPbaRwyv/8P9YeRJc6zJTkZeZfqoCudEqRr4gbbZfpEOPNTfiamUOnLoLGtK
	IIhaOpgnw/1fkMCSDZfn5RfT12V32Deb8bCzN9Z5uczTwTMfYi6wA0Bsd8tfyieF6EHhzz7Elda
	PdgpwfoXZxt/sgBBdyqsloC2/UYV32mhB05utoEdXQCrelPorLbcb3lGCkC9jQbM0xsju74w9lx
	sUt39brbJnrHosTpJSxoY46tIFIDzUFdfVJJXme0j/idtcrzgo7VykQZ0ZhI/vBdra30nFCJezl
	dJbl4KzqsI4NmvnE/F/5xNuDFS7Yt9Sr3/dsQjpefP1pUvP/7mluYzK/D+Pgxu4cSNJ3Eh0Y=
X-Google-Smtp-Source: AGHT+IFlsnZ0k8muJSrddDRx8GFRERSbeF4nDY6yspGg9WIg4wg50amrL5Z1QtXjRUhp3wNQXmZujQ==
X-Received: by 2002:a05:6a20:3d89:b0:2ef:1d19:3d3 with SMTP id adf61e73a8af0-3590968f3ffmr7213716637.14.1763013237233;
        Wed, 12 Nov 2025 21:53:57 -0800 (PST)
Received: from dw-tp ([49.207.219.162])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-bc365da0191sm937384a12.0.2025.11.12.21.53.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 21:53:56 -0800 (PST)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>
Cc: Ojaswin Mujoo <ojaswin@linux.ibm.com>, Christian Brauner <brauner@kernel.org>, djwong@kernel.org, john.g.garry@oracle.com, tytso@mit.edu, willy@infradead.org, dchinner@redhat.com, hch@lst.de, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, jack@suse.cz, nilay@linux.ibm.com, martin.petersen@oracle.com, rostedt@goodmis.org, axboe@kernel.dk, linux-block@vger.kernel.org, linux-trace-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/8] xfs: single block atomic writes for buffered IO
In-Reply-To: <20251113052337.GA28533@lst.de>
Date: Thu, 13 Nov 2025 11:12:49 +0530
Message-ID: <87frai8p46.ritesh.list@gmail.com>
References: <cover.1762945505.git.ojaswin@linux.ibm.com> <aRUCqA_UpRftbgce@dread.disaster.area> <20251113052337.GA28533@lst.de>
X-Stat-Signature: sh48k6h43hr8ssizjt9ggoombhyp6r6w
X-Rspam-User: 
X-Rspamd-Queue-Id: 7857E140004
X-Rspamd-Server: rspam10
X-HE-Tag: 1763013238-707155
X-HE-Meta: U2FsdGVkX1+2vQ4OSwsJ0AJs1gLLjIxtHUlsUp1uI2kN3p/WM+g2c03gwJEVaKp8HNtzbxh2VWMiDPLGaCp2/1RyyF8Wt6gMz3CHLoVB4gBQeuUloln36dmgobwWExOuQXizsSnGxBecKS5yNmhiWBnIpQ8JRuwNS69xirTEwMBBQ479l40OExU/IkC/E7dcd+ZGPLJwPiqYZyuVtND1xELC+PL/Vyui9W+7amsddeL9wQD6odf/YA84/VBK5xc41Fh4BJR+wiu8HXlyDp4RqHyYuXyCp+ppJQ+kXuwrhmsMwYpQaiT6bJLW+U0Voqkl6VqLEjHs2pJSnrXBKVgPIztbp+dgdCnAjfQeMQvDznY411F42AbEKPsBLHAQZjEoJjVW3QCDil/Ne9QC2qLsxd7qWn5wEC+fTr1JUsUfNe1aPrvo7sRE2EWpnRLDmgWLgmLLwvSmx2/SpwZlaO6TwxxKYzLv3u9FB8vFAVBfh6bZWVyLX3KhoorK7xEOlGN/toF493RWnSZRw2nbtl/imi8FdYBUw325V6GStNAO1b1yiJs+AYqqF/mnNHBT3x2IP+lc0Ig2izm6GGvQ9MortiMnr7lVsVe2ZefNH45mv0uBYwT7fxDBHVPrdjbvQVAv7p5nxWGpI+XNrXGsQqlUghH8xQp2weblx2D8X7LSj/mWisdsot64E5dNgpScIyAsLEe9CLRSpUpMQNBhkBoPCKClmPE64GWFWtVcG9toNtl/37e886IbtCo383gf3l0+xoQxShlmtgETty8yx2JYLiBpMjz1iPrO+eAUsRiOg1H/1JBesvgQjmWS9IC0Z5/mKhCIGmjU+y6IKQJBuiZ3PFfxjWALEGHehx94xH/Bf8Ovl6N39NxyErQbMMue2yXfv52X/X8LMkwWG7TANPq6A4IBVriR42VtOiUIwsGBSkDKdSBC8q3YIRDTw5U99Lcz1gQzxEgap+mV+PY+O7I
 qKWUUtmO
 0S1cduy5E3qp5sCehDCninP6JyYf9DmaxC5mvYQie032NLiMOHQ+SRjgQiF3Hq3ZVCngAnxiiKD8nLNBr8OJlcpiH2zsh6WhwaRrlwCShEHVnJaTD+XxNJ4E9fcy2w9M0T9M7BOjT1ycDY/vzJfbUCa711YQtnJ+P9KDDvv23nMb042tYpO6T6yXNkYn/h1abEpqKVaVITJSPAfAcIBoywu9dc9aTPMmFL08yVV+5Kpv/+MiK2QLIcLDZ2cDbU7YpmZrkpSYDjTqGLIA86YJdTSzCIgKnl6Ur6VbiS3kmIL2CtNhkr9nNh7BxdY4tvcGH1pkWBBlI1WfnF5avkn7FbBcSWFz1d+01TSQBr3EOtDJmsRUSWeNsAZBY8w3UC1Gsrz33jZTMJKyLyV/HWYZdzY8u6lreih2mwdqUR+jeV2OMiwHfXgWCuxTRZfpMZj46LC9vEauKdo6sz9fu/U/MUSSl7KbRPnLoe3pF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Christoph Hellwig <hch@lst.de> writes:

> On Thu, Nov 13, 2025 at 08:56:56AM +1100, Dave Chinner wrote:
>> On Wed, Nov 12, 2025 at 04:36:03PM +0530, Ojaswin Mujoo wrote:
>> > This patch adds support to perform single block RWF_ATOMIC writes for
>> > iomap xfs buffered IO. This builds upon the inital RFC shared by John
>> > Garry last year [1]. Most of the details are present in the respective 
>> > commit messages but I'd mention some of the design points below:
>> 
>> What is the use case for this functionality? i.e. what is the
>> reason for adding all this complexity?
>
> Seconded.  The atomic code has a lot of complexity, and further mixing
> it with buffered I/O makes this even worse.  We'd need a really important
> use case to even consider it.

I agree this should have been in the cover letter itself. 

I believe the reason for adding this functionality was also discussed at
LSFMM too...  

For e.g. https://lwn.net/Articles/974578/ goes in depth and talks about
Postgres folks looking for this, since PostgreSQL databases uses
buffered I/O for their database writes.

-ritesh

