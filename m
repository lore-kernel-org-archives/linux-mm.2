Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3AA9CF2562
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 23:30:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D5426B0006; Tue, 18 Nov 2025 18:30:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 186286B002C; Tue, 18 Nov 2025 18:30:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09C246B009E; Tue, 18 Nov 2025 18:30:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EC3C06B0006
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 18:30:41 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5DC9713A0C5
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 23:30:41 +0000 (UTC)
X-FDA: 84125324682.16.A5A094E
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf26.hostedemail.com (Postfix) with ESMTP id 26E2D140016
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 23:30:38 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=fromorbit-com.20230601.gappssmtp.com header.s=20230601 header.b=X7YtPf0N;
	spf=pass (imf26.hostedemail.com: domain of david@fromorbit.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=david@fromorbit.com;
	dmarc=pass (policy=quarantine) header.from=fromorbit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763508639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MnIQ5czAIlDUTiRSsv9UfW61iWVDuRBQUnVcKZcJB1w=;
	b=YLKwP/RP265cDcckM3cYonh19nG4bwL4w7WxkzyqoXKzyWUIFbjy049CLwcX49FnIBN6tO
	5+fFpF4qnFViPFdoq8jyFIbWYi9V+2p3GykhSCT0aVRutZMfF/tpKTGjs5SuTiJExn9d1M
	nwhFFC9yb7UdJh9AbKVj4Lj8REPTIVQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763508639; a=rsa-sha256;
	cv=none;
	b=X/Vqz6C7D27uqGnNEXtPL0IP0puepbv6emvCiFMSRfev0rl+En7xTlgh+1dWT+ARP8JqDU
	qyTn5ZMRp4TDn9M76CLqtzl6EeC3o6Yx9NxYSlenKA+70wd1NlOfwAFT83isDKEF2O5dYL
	sYhwkOUJSA2hxj0aUgyWYN4prGt7QCc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=fromorbit-com.20230601.gappssmtp.com header.s=20230601 header.b=X7YtPf0N;
	spf=pass (imf26.hostedemail.com: domain of david@fromorbit.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=david@fromorbit.com;
	dmarc=pass (policy=quarantine) header.from=fromorbit.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2981f9ce15cso76062215ad.1
        for <linux-mm@kvack.org>; Tue, 18 Nov 2025 15:30:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1763508638; x=1764113438; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MnIQ5czAIlDUTiRSsv9UfW61iWVDuRBQUnVcKZcJB1w=;
        b=X7YtPf0NzOf4wXtUeMos2yp7IYB0Z3VPycUeozmoIjp07A+TSnHqX2MQRKLCZsJW00
         H1yfhUrPA5icGNbB/NK95b0l2DIK1pSKo4oim60X60jatcyP77+biSoGiwy2VEAvXJH1
         aSbmSKmv+wNn9RDWE0SBdAITtVPg310V+LjdWour+9zFKpRs8gi8/Nu2SOGrstz5CZ8g
         eVr4dvhulbJcIeEnwK+XXFG1QncfN7XpsnD7kIAdCtN+g+qaYYZI41+lv8y5YS7dTDA6
         sJ7KDStgRPAzmYRK1lv2R2wP03Cw4kjZb0B2TYqVW0+gIczY1Ai/aDScsGrJSlfUJt+7
         tj/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763508638; x=1764113438;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MnIQ5czAIlDUTiRSsv9UfW61iWVDuRBQUnVcKZcJB1w=;
        b=mVhIoSIA8eTEetRMBjqAOU0c1auO+YmCBLGori+e6q33fTvYkTKP/KRSF2pwdvucD8
         ui+wr0xqWHVGBtkqUhCpkT58Hm/dPMd/4AVlViuzaHk/98Kp0sOfx+oja7+nqh7T0NC0
         R6LYQ+ITIBePnvp9CDr3tS4bsO/5t2BPB5HdElI7N084P3sy34tm+kaG7tsePk9ByE9T
         2zDgb/FOAA8naBdhq84pxFWHrkx1FgUWSoMrXU8vXyO8No5jYTATU+/ZBfjzP7Xxjgga
         bvC7viRYWA2htoSqrZRe2E5D+18rGKoBvtro1/Cq3X9Pi1QB6fzmtz+5ceEwq72jVLMM
         pJ8A==
X-Forwarded-Encrypted: i=1; AJvYcCWK29C+DyAB3btRSCCB1yRnnAub5vdA+qLbh5XKJLAadGpqRE+PRGmpBtaA0MQalTZhY+gmKnaUXg==@kvack.org
X-Gm-Message-State: AOJu0Yw/hnWUAuMUBNfyfbx0dBbSk9bEg6Al/iZqb3BeVbytluQjyopZ
	NJ8XmUTgw7LM/LjG0vU/E6gz/lVdQX4JoLYkF76V+MS0pX/t/Vn931pXKWB5Xf8Ve6E=
X-Gm-Gg: ASbGncsA9RbGka/MXXkbS5Q69HYvbKalG6OhNPa8qoITIJxhtrCL7maol/oWKnfh1CB
	9wb8KVZ9DmfvCY4AyHAVIfbli9PiisWZZkm4ZMu+QBq0DBFWHfuz3DbWmd5mxftt5Y1svO0Yjrk
	sM8eM0auhHRdxyDVej2vO0DR9wGu+iklpSeVcyftg7q7hU/AeXsdVhSjmzGR2nqVchJFcji2ARd
	OiMiVJMACrAiT6snVWS6Q5+nY3YlShwiHxrZ1+xrcsqJk0m0o7bw4HyAEOPF/++Cmlz+2OQ6i36
	O26RrIh5lO+z0c+98bWZCEgiDiiIeEGlcZXpVRrHhtPl+6SUs975iV76YXESFS7ifyNRvsEsl5B
	efQIiNlJMDm6LQGyy/D/Wt730sGNb+iZx9o33KJt/pgD4Afl5u6HqDoPq4N4iEfD+2gpx/kb14d
	RoGhF3ibgy0SXzaynzJq57GjYO4jYQCTyGr4eZuRYMdSGO8g4RAyrKhK0lTFB21HM6SwlaexdeO
	mmP5TSGan4=
X-Google-Smtp-Source: AGHT+IG0xrV617/K2Q2zctZIX2rlkSw5B1Jp1MywYakVFhxJ0IxXfb/aHGJIAHe675+ap1LI/Djfwg==
X-Received: by 2002:a17:90b:570c:b0:340:cb39:74cd with SMTP id 98e67ed59e1d1-345bd413f51mr358384a91.32.1763508637774;
        Tue, 18 Nov 2025 15:30:37 -0800 (PST)
Received: from dread.disaster.area (pa49-181-58-136.pa.nsw.optusnet.com.au. [49.181.58.136])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-345bc110a6dsm560282a91.14.2025.11.18.15.30.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Nov 2025 15:30:37 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1vLV9e-0000000Ceqh-0jNc;
	Wed, 19 Nov 2025 10:30:34 +1100
Date: Wed, 19 Nov 2025 10:30:34 +1100
From: Dave Chinner <david@fromorbit.com>
To: Ritesh Harjani <ritesh.list@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Christian Brauner <brauner@kernel.org>, djwong@kernel.org,
	john.g.garry@oracle.com, tytso@mit.edu, dchinner@redhat.com,
	hch@lst.de, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, jack@suse.cz, nilay@linux.ibm.com,
	martin.petersen@oracle.com, rostedt@goodmis.org, axboe@kernel.dk,
	linux-block@vger.kernel.org, linux-trace-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/8] mm: Add PG_atomic
Message-ID: <aR0BmpbQe0s4B80S@dread.disaster.area>
References: <cover.1762945505.git.ojaswin@linux.ibm.com>
 <5f0a7c62a3c787f2011ada10abe3826a94f99e17.1762945505.git.ojaswin@linux.ibm.com>
 <aRSuH82gM-8BzPCU@casper.infradead.org>
 <87ecq18azq.ritesh.list@gmail.com>
 <aRcrwgxV6cBu2_RH@casper.infradead.org>
 <878qg32u3d.ritesh.list@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878qg32u3d.ritesh.list@gmail.com>
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 26E2D140016
X-Stat-Signature: 6wb641hnd5hr8y6sehsydit4xjybxa76
X-HE-Tag: 1763508638-749443
X-HE-Meta: U2FsdGVkX189xkUoWZIMR9qW7LMWj9fOhcWM1d6RTxr1bWsojy9Uoy0xq/PQOa6yEyD5rlqyfCHWJgHcDCOyRskvCg4i37QkP2VDQU6GDRdVSWpIZxxpaKOSLcS21JUPlHdGFNcS3ofu2brvih96O6y1ZW17n6FZUTJOBDhvxl4P2f88b2b4WZwCDIpOrYDj4jdqofecRiOJpL83QE1ob+AAHWYqd64QlMJ2GVL1yMJDmJ7u2m3rQWvkMs/BbHQq1g8l5DDaJRe/SIjxoWY8qXyq0+5biWI6WvNqPJmtz1nJuvqRmZfa4FjVFReFI+1rhgbNXLru4JlhOlKQee2GXlBG/xw99bZtqP7DtZt0JH7/wje6XZq6RtMyHuR8vqK4LTxMZlToMGRY+R0QgzCSceD6ndYvUxzjq9goC/oQukKYMIWz9H9gViob1a45iFcQ7KqBbs4Cl/QJsobRL0dHDbIeHIk0aRruueCBF1kmFyLaKPW3qmT3RXioarVeiJPa8t9IR0wiusc6ghU5/4F9LW81nQmKGFBSo3unt2xBwFsQBv5LWKY3BB+euo6IygUPtdSD0mQ+zouSJbpydAyJXo0ESeumA5zEmUCO3NcaKHN7c68D/YNUQ9X/tQzwvbIN4wKJT+BXTjZhgPGJBerbH/1XH3lM0gBpZRdXLYbqkdICl9NcmCmLqWybUppE1Xa5x3pDZQnY11uGbSPof7aTk4ytbjFEoL7Tzd5bWNClqq3P2cG1q62ca2R2XrvhQp1fMrTRxw+yLJI8ieTVs+vgsGbx80A0n1wwbgG8h7RzVL6yVm85eVlw+aBVx4OVxs0uY63S0MBqjyb2/90VtFhn7gcvfwQqF0I1sMiqt+fWhaoSZFyvPKY9v8GbZNHfpW65TXqcHExY2ZZZ9cvpX+yDT6OV64rvjyZ7px/VvcoKaBSa3KwawA5reKkvpYusxRjdIIjymnnqTjiSmutXnUc
 9mKdMVvz
 ZdhVL/9lRU0l5Z0jdGMo451FaWmZnT+Zvv+uiGrmCYkpSqB0VHHyQ5LZlGLyTDlNpJizOrPDEnHlHB5MxVLkDUSKuDzcmLa3oBhVVkHaM/wLt5DOALGJ5uULEQOcZpDqQag9GRIMPnY3s+1e8FJ74CC5n6Pnavo4FPCEEdeJ40LGMy/iq0IkhcwqY/O5UifKZrBjzknSFcq9ZBLcZfsiLhiFxcnEvfjR7sQr0sOIkRTzAC6UD8sWdVh/4irfmgvcnEUZf/7Si9hdsIBAWXvf1Xdin84X1MlARdbJH4whDX7BHQcEq7XZBy8fsZv1GoIh/wDQCsx9JGtaRiERcdhfCH3P6Vka3hQk9RPEHf4shwefzZv6qkhH39HGCH4jFpP2NoKf6DcHRi0rnzBi2RDDUqQgmqascHiHE8ndSmVNaKWXK9WsQNYTjPl6ZdAFiBIYy50E4nKnuOkiMe0br6epmXpbn6EN6hdgcgAf/m5VXY9CWng4xZk18DUBJZQhA2D5Tvy4vtlwqkNWNBvF8TbWAmzlM8waUXtFjOq7Be/dJhcJKumRCM9fwi/pFvFgK3CNgC64Cshnq8/toAXCDwgNHyVn5ZxktHxKukqALTBinYQVF0fSsd5GJWo7LuF/9VbXf8bj04skAIMIA0VHTC4X1AfD+4g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 18, 2025 at 09:47:42PM +0530, Ritesh Harjani wrote:
> Matthew Wilcox <willy@infradead.org> writes:
> 
> > On Fri, Nov 14, 2025 at 10:30:09AM +0530, Ritesh Harjani wrote:
> >> Matthew Wilcox <willy@infradead.org> writes:
> >> 
> >> > On Wed, Nov 12, 2025 at 04:36:05PM +0530, Ojaswin Mujoo wrote:
> >> >> From: John Garry <john.g.garry@oracle.com>
> >> >> 
> >> >> Add page flag PG_atomic, meaning that a folio needs to be written back
> >> >> atomically. This will be used by for handling RWF_ATOMIC buffered IO
> >> >> in upcoming patches.
> >> >
> >> > Page flags are a precious resource.  I'm not thrilled about allocating one
> >> > to this rather niche usecase.  Wouldn't this be more aptly a flag on the
> >> > address_space rather than the folio?  ie if we're doing this kind of write
> >> > to a file, aren't most/all of the writes to the file going to be atomic?
> >> 
> >> As of today the atomic writes functionality works on the per-write
> >> basis (given it's a per-write characteristic). 
> >> 
> >> So, we can have two types of dirty folios sitting in the page cache of
> >> an inode. Ones which were done using atomic buffered I/O flag
> >> (RWF_ATOMIC) and the other ones which were non-atomic writes. Hence a
> >> need of a folio flag to distinguish between the two writes.
> >
> > I know, but is this useful?  AFAIK, the files where Postgres wants to
> > use this functionality are the log files, and all writes to the log
> > files will want to use the atomic functionality.  What's the usecase
> > for "I want to mix atomic and non-atomic buffered writes to this file"?
> 
> Actually this goes back to the design of how we added support of atomic
> writes during DIO. So during the initial design phase we decided that
> this need not be a per-inode attribute or an open flag, but this is a
> per write I/O characteristic.
> 
> So as per the current design, we don't have any open flag or a
> persistent inode attribute which says kernel should permit _only_ atomic
> writes I/O to this file. Instead what we support today is DIO atomic
> writes using RWF_ATOMIC flag in pwritev2 syscall.

Which, if we can't do with REQ_ATOMIC IO, we fall back to the
filesystem COW IO path to provide RWF_ATOMIC semantics without
needing to involve the page cache.

IOWs, DIO REQ_ATOMIC writes are simply a fast path for the atomic
COW IO path inherent in COW-capable filesystems.

This is no different for buffered RWF_ATOMIC writes. We need to
ingest the data into the page cache as a COW operation, then at
writeback time we optimise away the COW operations if REQ_ATOMIC IO
can be performed instead.

Using COW for buffered RWF_ATOMIC writes means don't need to involve
the page caceh at all - this can all be implemented at the
filesystem extent mapping and iomap layers....

> Having said that there can be several policy decision that could still be
> discussed e.g. make sure any previous dirty data is flushed to disk when a
> buffered atomic write request is made to an inode. 

We don't need to care about mixed dirty non-atomic/atomic data on the
same file if REQ_ATOMIC is used as an optimisation for COW-based
atomic IO.  Filesystems like XFS naturally separate COW and non-COW
extents. If we combine non-atomic and atomic data into a single
atomic update at writeback(be it COW or REQ_ATOMIC IO), then we
have still honoured the requested atomic semantics required to
persist the data. It just doesn't matter.

IMO, trying to hack atomic physical IO semantics through the page
cache creates all sorts of issues that simply don't exist when we
use the atomic overwrite paths present in modern COW capable
filesystems....

-Dave.
-- 
Dave Chinner
david@fromorbit.com

