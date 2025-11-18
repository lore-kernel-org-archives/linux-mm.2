Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFEB6CEE342
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 17:31:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 122B86B0024; Tue, 18 Nov 2025 12:31:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D35F6B0029; Tue, 18 Nov 2025 12:31:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F048E6B002B; Tue, 18 Nov 2025 12:31:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DA7AE6B0024
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 12:31:19 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C084756064
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 17:31:18 +0000 (UTC)
X-FDA: 84124419036.25.92CD7EF
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf25.hostedemail.com (Postfix) with ESMTP id EDC51A0015
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 17:31:16 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Hhige1My;
	spf=pass (imf25.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763487077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=jJZHPmpfAYK3kOvAYzdDDouNFc3+GX3mg/4dP4wkGpE=;
	b=GnBiMm9YDSnTHMecu69pTw0ANBYj07Q94y7DeHZOK35WHzWNUiMQgYIKRjpVbbnOVAr4Nz
	Ra5puN1P+CBh1AR40hY8jiC9Vv7fE6o2AtN13teS30fe3mgMvR9m+yjJXO+wVcFDDIFxKr
	Qiz+Sp+LoVUXUAFq8JUBD2jEMXmld/0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763487077; a=rsa-sha256;
	cv=none;
	b=EoN5ZiWwdpQZVwJoGEsmbahUYuSF1Iurwu6KiLB3Yt4WsMjw9VhyKvIvQcd89q8OMX5jVR
	VeeyAMPTpbTkQ82KlLZmIDsScpz9tXMvvWhHbopHVG7CWuPz42SEUjmgXShrY1luEbm1LY
	kNp6zf23kZTmGx3A3jLuol121rA3kII=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Hhige1My;
	spf=pass (imf25.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-7ad1cd0db3bso4931306b3a.1
        for <linux-mm@kvack.org>; Tue, 18 Nov 2025 09:31:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763487076; x=1764091876; darn=kvack.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=jJZHPmpfAYK3kOvAYzdDDouNFc3+GX3mg/4dP4wkGpE=;
        b=Hhige1MyIyDoYSPK4DmbOwU6aNgzSnXn6NR8UqJErAX9zW3juPHDSUwYliE3JS2u9H
         P1yFhlGbLP1Oxy9mprSb8TpgEhOEGC/Cfa22InbfAorwNVfMrBPUqmOk7YHER3j57PtA
         kOnfSrF/Twfm7ET3aYXLOxhkVi+YEhaVkHifZ3HERMXXJ6+Jp1kypTaBtKomEyWZdUkH
         NWuT/Idn8UG+gDl+Gcd0/yep8YvHMe/GADBb/Gjhw4J/K64K4xM1sgtAJ7e43KaE2XM+
         NuyRg6QMOL4Z32Xqo6wzpeLmpb1XEzg2Q0IBT848xvGqpnZXGA+uXAS+LqlCm3ldUQJN
         fD8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763487076; x=1764091876;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jJZHPmpfAYK3kOvAYzdDDouNFc3+GX3mg/4dP4wkGpE=;
        b=TuZga/YE1T9grLPn4tTdiceprLCduD/cxK7LUqvH+e4/cvLjkKit4GS5iwgWoOGIH3
         yIZXy5LRalN4GBpMpTQYzSDXICFLpxBO8Obx7PtOLGuVObq/yVgbXeWtsTT3HL93VCkE
         nhXL7DJZdEO4NS3lARknwFex+Ix7PVKkZXVWQaBIHx6Ftpd56gicjAo3wEhe0epvjA21
         BA7xZ6Empad6cwYqZ3stOD867Otag9ILPzob8jMHkTql8nrnAXobxzL5Y6Wi5jgTXH9H
         WE5frzNtkG7q0u41kN7cvYV5glXtzEtq5SMTWSF8clMbeyez555v3HB0Cfw7vkVgBLXx
         5H1Q==
X-Forwarded-Encrypted: i=1; AJvYcCUAEE+PcbqIHgDi0ZX/gYpFnthMxSAdShTnoPhBF8yTCaKN6JEXPzd5A/y5ni1EuDYvkz1w2d37aQ==@kvack.org
X-Gm-Message-State: AOJu0Yz0llESfocFTaUpDw4mgP0toX4Hm72FlpgWvy55vbZ0IciGQXwI
	tekXDIdbuzEQ/jN/6UfL/LnwxDT/UJqMeplNoP89I1qP7xiw36ZN93iO
X-Gm-Gg: ASbGncvp12V/nmaf/9Z0g/9yAheVPFwvKL2VMb6VhYQWo/oYLdAUk/obu7ioFSv2kMO
	lZZnVwd4a7w4LbKxzRyZiYLtb0BtSsyAIwbEW4yejf+VCUtcF8BWg7HdIptAp4/pHg5f7ecKgYv
	fROc3/4IJpuiKgvlFdpRc/w2IDGLBPxhcoNFFpYKY/JIHuPGOf5Qz5QHm/4xay3ddaVeCq2ZykT
	swWbNB/dG8SirHb+PFRCX8M6zpb+VTVyXkAh0Mmwq4h7p9c432QeiErbg/xFD4dFrN/0qHwfdIG
	SuJ4q2129joGmfLkbGbeB9oY8VhXhifqVNIJFqxmEktJZWIe1F9G4S0efJZpXifSK6cpIDz7Wam
	hbZubXN3uDRmV/0D/Y+khlzPt6IAa68tb/8Gu7rW/c6A4PkUgcudtyJvwxJn/VupxRYWsxEc=
X-Google-Smtp-Source: AGHT+IEQrU5uwPDP3B0D60MQHHmGXSAeXE5fv7FgIePf1xPikPaNbxxiXR2fp/Zl+qVssNoTrpyjFQ==
X-Received: by 2002:a17:90b:3843:b0:330:7a32:3290 with SMTP id 98e67ed59e1d1-343fa751ad3mr18844371a91.37.1763487075532;
        Tue, 18 Nov 2025 09:31:15 -0800 (PST)
Received: from dw-tp ([49.207.232.208])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-345af0fcc0csm1694884a91.0.2025.11.18.09.31.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Nov 2025 09:31:13 -0800 (PST)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: Ojaswin Mujoo <ojaswin@linux.ibm.com>, Christian Brauner <brauner@kernel.org>, djwong@kernel.org, john.g.garry@oracle.com, tytso@mit.edu, dchinner@redhat.com, hch@lst.de, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, jack@suse.cz, nilay@linux.ibm.com, martin.petersen@oracle.com, rostedt@goodmis.org, axboe@kernel.dk, linux-block@vger.kernel.org, linux-trace-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/8] mm: Add PG_atomic
In-Reply-To: <aRcrwgxV6cBu2_RH@casper.infradead.org>
Date: Tue, 18 Nov 2025 21:47:42 +0530
Message-ID: <878qg32u3d.ritesh.list@gmail.com>
References: <cover.1762945505.git.ojaswin@linux.ibm.com> <5f0a7c62a3c787f2011ada10abe3826a94f99e17.1762945505.git.ojaswin@linux.ibm.com> <aRSuH82gM-8BzPCU@casper.infradead.org> <87ecq18azq.ritesh.list@gmail.com> <aRcrwgxV6cBu2_RH@casper.infradead.org>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EDC51A0015
X-Stat-Signature: pojkoq4ztdeg3bodw3qiq8yk3in64nsz
X-Rspam-User: 
X-HE-Tag: 1763487076-67967
X-HE-Meta: U2FsdGVkX18J0jrs+uOBujdv1ippohFJD1s2mmuIlPFS6q6MxAo0lCjdiqwujNYtqAe8m+vvGyLCX/bh9Jn7Hq9SzMqRlDat8nJTe/cuiGOPmMmoNpU3tA/mjLX/0TTJSsXUcQPsXOepFAfYPIwFH3SvNQAPX+ohk679URlac6VBSjluKW9FMlRRVawHDtp/RRPcNcjar5XikIwdPj0yF9s8yJLZ2tMdjEC4O75bpUflmFpyIxX0FxPdrISOV1pshbkQBuW+76zVdKKRHidjZNslbIfP1pmFY3KL3iNVPAZT77BngtWefoCOh0F8RzltYZNUi2zbEYBn5fCb6JZ3888CDpKOTd8om1C4d2PlR2aelITeCQPTHsXZ+O4MYLZ6g9y0n7AA762GGz5guNCJFRTiPsD6tKKbxsI8PN1Q0rJ/Av4Rk97ExM0/umMW/mpTdqLDVm37YS95iWAynQeNrC2j+us6k3keaj/XZB4tqTeQ7Y/6FPBqto/+baGAVgoPS63OGImlL4fbbgiRteb0UDorQZSy7GabN8Nr/5r6sfbOZIKrAUjvq1i/wt2Y3CdecZBje7p4/M7o8w4YQzNL1Ky3HrgLI6SCYuJJ93v6pzs4uFdjfiV4kTByA+KGqDEM/lx+3ytj9o5z+o32N5gxIC08L4znraSpmlvyAD7AHpfbaR8ZdVMUdFz+xQ6z290CAf+L4zGt76tPWt5IXjVi98Qs9lDfRgYTDUDAa8ZAVlDPN0i8lEplAz2POxUCCbfbHInHEIzDZ4D6utaPBKfnr7wR5w+nRSuk3T3h0rf/hi+dnMZxPFRKr3LTq5XtQTWCX73sSZGMMCZF1DT6OE+ERJVTVHClfv4WOP1nYN9R8Y1/3/6WITDCkwy02OPa5TqxU3Er3MJA3zuIKiHaf9UoJNX7vvuPkuIrEj0DCuPAV3FlBU4s3ATB6ijWh2UqP5VVdUoUNwsGbhrDm7qqljS
 5lw7OWsc
 xCWk8Xm50FQhj9KiucDP7JYBhqHV1ay79wNEcrIkxIOZFJvg2zl5ZD8TXh9oSr0NOMCjoubiRbatYnFxzjlX0ByWMRQ29Bxhi9M0FAOnXqUUcawQG/awW/KcFIFcHP51plH1rXaIikpcco7JvP4rm0y+D7Wra21QztvuawQgPYEh+3RLxVNQAcMw3saauQnXxj6DOFPvR2ZxvlCwUBhncfQrQIFaxL1ulRecMWaHzPbyuyBsLoO/wHaJoAF1gVWh91Dg5DfaIFfe1NWB7AeCJvgWKSsMAzWnT1j3Mcdt/gpWGS6vt3CIuWZtwtqXjMBFvP0l9TDkKf+0Bxf/XMVP5C/TYC/6eEEYTurM7NPRb482swpOjZhTmR8TKoWHQYXpUP31xRGVkhSBk1nyHzYTALkVPKU9VAt3Wi3vdN+1EIzIzNw4oPo/xjmljqYEn27H94bvDAfaAELli4E5HSDo7q0tN+SYkKp8DvWHsWyu/zU5Izmk/dsu7A/61FyRsBRQ+ZqxkPHWfpySuqc5pjTdyPn6n9l3jZKxrIgfQ/cPiVEQJOv8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Matthew Wilcox <willy@infradead.org> writes:

> On Fri, Nov 14, 2025 at 10:30:09AM +0530, Ritesh Harjani wrote:
>> Matthew Wilcox <willy@infradead.org> writes:
>> 
>> > On Wed, Nov 12, 2025 at 04:36:05PM +0530, Ojaswin Mujoo wrote:
>> >> From: John Garry <john.g.garry@oracle.com>
>> >> 
>> >> Add page flag PG_atomic, meaning that a folio needs to be written back
>> >> atomically. This will be used by for handling RWF_ATOMIC buffered IO
>> >> in upcoming patches.
>> >
>> > Page flags are a precious resource.  I'm not thrilled about allocating one
>> > to this rather niche usecase.  Wouldn't this be more aptly a flag on the
>> > address_space rather than the folio?  ie if we're doing this kind of write
>> > to a file, aren't most/all of the writes to the file going to be atomic?
>> 
>> As of today the atomic writes functionality works on the per-write
>> basis (given it's a per-write characteristic). 
>> 
>> So, we can have two types of dirty folios sitting in the page cache of
>> an inode. Ones which were done using atomic buffered I/O flag
>> (RWF_ATOMIC) and the other ones which were non-atomic writes. Hence a
>> need of a folio flag to distinguish between the two writes.
>
> I know, but is this useful?  AFAIK, the files where Postgres wants to
> use this functionality are the log files, and all writes to the log
> files will want to use the atomic functionality.  What's the usecase
> for "I want to mix atomic and non-atomic buffered writes to this file"?

Actually this goes back to the design of how we added support of atomic
writes during DIO. So during the initial design phase we decided that
this need not be a per-inode attribute or an open flag, but this is a
per write I/O characteristic.

So as per the current design, we don't have any open flag or a
persistent inode attribute which says kernel should permit _only_ atomic
writes I/O to this file. Instead what we support today is DIO atomic
writes using RWF_ATOMIC flag in pwritev2 syscall.

Having said that there can be several policy decision that could still be
discussed e.g. make sure any previous dirty data is flushed to disk when a
buffered atomic write request is made to an inode. 
Maybe that would allow us to just keep a flag at the address space level
because we would never have a mix of atomic and non-atomic page cache
pages.

IMO, I agree that folio flag is a scarce resource, but I guess the
initial goal of this patch series is mainly to discuss the initial
design of the core feature i.e. how buffered atomic writes should look
in Linux kernel. I agree and point taken that we should be careful with
using folio flags, but let's see how the design shapes up maybe? - that
will help us understand whether a folio flag is really required or maybe
an address space flag would do. 

-ritesh

