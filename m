Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAFF5CCFA1A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 05:16:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F07F38E0005; Wed, 12 Nov 2025 00:16:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB7C18E0002; Wed, 12 Nov 2025 00:16:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA9758E0005; Wed, 12 Nov 2025 00:16:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C577F8E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 00:16:29 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7F8B3B8721
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 05:16:29 +0000 (UTC)
X-FDA: 84100794498.20.69DA057
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9083440006
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 05:16:27 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=AQBVX+p1;
	spf=pass (imf01.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.169 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762924587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nhp9WztXVzcfj91SAG1PnTJUC4+cBVLBbRZgiqHWwK0=;
	b=4soiuhOlLoazlCRu9U58j2zifKxTiubt2uoQf9Xg6bhnSMk3zapdcOwvRpVu113mIRMtPF
	eWddyGlePYitHpBr2m9DMc+O6FQjipzpc84xIjSPgLJD81bT0YIFlT5ZiFQeIVPW5E0zNN
	j2OuPI0sKICCvd0H7/WjbHVTBpZ/DIA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=AQBVX+p1;
	spf=pass (imf01.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.169 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762924587; a=rsa-sha256;
	cv=none;
	b=jFG4n/uUiI6YFxiRe+IK/SdQWHGHOSrlsrX22qRHKNePYlGxve4hnXm3Fg1Zoba2xLfUKO
	Uq0EX6cOlIRQBGMZd+6USKHPmjNOLIGJmaJe48aNaCn/CDS10tKEyPxma0qa1oXd2HG82F
	1XBm4lW94be8JDLvUETnjoHi35mwVQU=
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-b4755f37c3eso319468a12.3
        for <linux-mm@kvack.org>; Tue, 11 Nov 2025 21:16:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1762924586; x=1763529386; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nhp9WztXVzcfj91SAG1PnTJUC4+cBVLBbRZgiqHWwK0=;
        b=AQBVX+p1eUY899o74NiQumJ79XxlW3LARiOcTddNimtbcbW1P7O1BAbhMTOo4PB7pO
         xGxkh9F4/WivE1S/QEgyYdzZnqAtpVF0KJ8LnUDsQGcmHsD/JcXco7pfHsm9ve/YYcyp
         BOKY0Th+Po8nwn3zt/f+pO/Liem12GLoJTeLg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762924586; x=1763529386;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nhp9WztXVzcfj91SAG1PnTJUC4+cBVLBbRZgiqHWwK0=;
        b=BWyq9oXWvvdo1E7XcJUviSZJ/5x/JexsCS5ic4rMqcHzN7E+PTdQYhRxu8M8cZU57i
         0mX86JfIkDB3D5avKPusMkPPzNDd/mfjOW8c8kAdlpn+V8A/CHBgdLs5tgIqWmxp714N
         ixRX/werFW/k8HBGVcTD68oL1Ro2KFm3UrVP7vOdnSuOcf8VetKRDqGcNG+BqfSkSypR
         Dyc/PSdbuOtzvGZ5DRysoEXLnUREjEzSxOa3eDwHbZcnCQMxjDHOGVmhfKxvno+u2SNI
         5xWy2w4hHfffadXeG/M2KSxjRk45Dc9wqctf1zc4UrxwVLjjqK0wc6uij8NgRNx8UmbP
         Kfag==
X-Forwarded-Encrypted: i=1; AJvYcCW7hvdjwEYWfkC5q5HQW3BvSJwpwk+RBcrOsgiPVG60lemmSgPgZFk5vlI//32gB3qmqIS9WhzXgQ==@kvack.org
X-Gm-Message-State: AOJu0YwscM8ldefxOXFyhDSNZN2t3ib7AXyFADgq1NEozjnvlM0I6i4A
	qE5qaWSrTuDfHe9Wf0SlnBFXpHAWyZfptua9dCFMUFCbmUl49Tfu9xG56EnkTtgtEA==
X-Gm-Gg: ASbGncvi8AEPy8Hrn6omsrF6z+P3xcWdFt+KzuXoFCzKJtmZV8QoFLIm6vgxms76Z31
	qXIWbySz69NJn0cyLH2lEyax5Jrm4SDfLZvZTc6felf0EIVCR+VqmuFaQJbHgakTF79K5XJ8X9O
	6Jt5BI5rVpsyZzFbSifVZ7lVG3BeQdesf+SmCwIA4Je7UQ5qbseBibRLF5pXE/sX2iA7uhCnzCC
	iD953b0NvqeoMNh8nCGq2zjNoFySkSAjdjw4iFW+ooUbWz6X+iSfnt1+Qcl15YyuiyJy9fy+z9S
	ikod554WEZnLxrVnIS526Qgc7cqXx00EjiWEVCAC/giYRw+j08uELwDNoXU5+ZhyX0ktwDYdY5B
	S8yGKR3B8rlUlhAscfj1Lk6m6LSb123vlqDv5D75WtU68mL5/S5P6IPs4pfAlQd1njlK0DMJNW1
	1ISpPi
X-Google-Smtp-Source: AGHT+IFho98A44dYQmBzRJFEzURybon+j1FaW7jn0iPAop/8QKKhvf7Z8/ur2Ft8vMS29vyNafxipQ==
X-Received: by 2002:a17:903:22d2:b0:295:7f1d:b02d with SMTP id d9443c01a7336-2984ed496ccmr24732195ad.22.1762924586274;
        Tue, 11 Nov 2025 21:16:26 -0800 (PST)
Received: from google.com ([2401:fa00:8f:203:2495:f9c3:243d:2a7e])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2984dca17ffsm15788105ad.71.2025.11.11.21.16.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Nov 2025 21:16:25 -0800 (PST)
Date: Wed, 12 Nov 2025 14:16:20 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Yuwen Chen <ywen.chen@foxmail.com>
Cc: senozhatsky@chromium.org, akpm@linux-foundation.org, axboe@kernel.dk, 
	bgeffon@google.com, licayy@outlook.com, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, liumartin@google.com, minchan@kernel.org, 
	richardycc@google.com
Subject: Re: [PATCH v4] zram: Implement multi-page write-back
Message-ID: <3enjvepoexpm567kfyz3bxwr4md7xvsrehgt4hoc54pynuhisu@75nxt6b5cmkb>
References: <yv2ktkwwu3hadzkw6wb4inqzihndfpwb42svuu25ngmn6eb7c4@hclvcrnsmvvk>
 <tencent_B2DC37E3A2AED0E7F179365FCB5D82455B08@qq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_B2DC37E3A2AED0E7F179365FCB5D82455B08@qq.com>
X-Rspamd-Queue-Id: 9083440006
X-Stat-Signature: xwb7xe15ksjqj1jrwhbxcq49xg6aes4n
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762924587-799068
X-HE-Meta: U2FsdGVkX1+Xj4x1mghU/Cyx456Weww/ApjqyUNK+4KXfb/MKdAdbIsO6AXa8XHmfPUJBLXhlnC41wWvxWCnpgyCNqaje/A5tP5YRql12drI7YEu6YRLZt40EthewA7+OOeSYIuW9PUcp3E7rR1MV+uJnewPScOiTU0VvFUeN3TahAAJ2RMvNjH/HHp51cLiUbwqbCNbNFynjzlgDL+f+ehNUVURwm+vEaAEmVGj/KbDqem4HRDAt41ceIkeP7lxS+TNr+LzdW9qGTKWKmnzOSUuwwZjnNliBFydiyk8QbFty6OFyi/hzUqHRbt7rbNVodAM9+ELZv2buRlY1u8yENsmEX12DOO+5C2hj+oAG0P+FWuwmTniqmJzE50LMN6fRqv9KmxNPrnZacrsBjGmfeBUX0p+mPsNnKQ8yBy604Hule3ORbXmxAX4lwf/+kbky1UYHUgbuOzZz+mNFvnQSB9ONzmgRNNpi1WYRvNZzsDO3HE5OZb0qqFy2n5m92WKlxFEC93P6kI3cqhMOohxdfcdaJYUcLLKzdHF0Z5/JU/DHKxURFwTEtlZzxFNa7FND8nSHZzdzmAsWoVvKERY8cpbf2O0J46oLWzhLZHNTdWwx5pyeEGN7I9KAavHdz6XOMC4Jq8684ZHpO/99VkKxU7RpqZgPoWsRpKGcxfxVmu3N8y5zi/7GHaX45hf10wBNkGNAjfPQpoVCOO7VmC7ppSa5M8BZnmFJBIeeXU1x3YyNdzyo3k78Jv/n15rfBh8S7gclEziFxq34f5k+aCtpChfMx0zSjNCHLKztzCyrAblyGxUd5nDJ3MtwfbjxcPuI/wbjDqfigqcptIcxmHQjIlu3KpejSo/NLyeF3iuu4lhWrnree3cowz3lHHCzeOJ/DC1ECnWH5Lt50FcqCEyX6aPhk5+A7TN0Gjd80oe005z17R6kDfiMxoM6qW+kSaPwkqDgAAgr7pJo4vE+1W
 +7cuu481
 61xGCUy4iW6n9JuPezLIA6KFpJ8zIhEnUlfS4nX7ikr0wupjGrMhK5a4jvffwFX5M7k1l1afAmWx+GcOh82ewMXC6eIIM81cQNtKRpEPb97wlQf+vmfkd5iaNgTttsoqmP9cFt8eaxmNTts1eJ/WHGgRXZcIfZxjcU7t1Bl4r+MgJrguEnSdOfZSevfbuJxOb9c7B86jHXzOZg+ZnfaSgrCGkOQXjbmCpudnLUCt6KtpK55aGdIT33cG+AVFzxcAMp5LPArL57zR7SQ0csfPcGUaWX9zRLjWruxXgfb55Z0gCKp2c8S+4udplRsCqdiBhRa0kHoUP+PMua29ZqYrTsHFVdYPlS3jq7teaxfd5MSxIMEw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (25/11/10 15:16), Yuwen Chen wrote:
> On 10 Nov 2025 13:49:26 +0900, Sergey Senozhatsky wrote:
> > As a side note:
> > You almost never do sequential writes to the backing device. The
> > thing is, e.g. when zram is used as swap, page faults happen randomly
> > and free up (slot-free) random page-size chunks (so random bits in
> > zram->bitmap become clear), which then get overwritten (zram simply
> > picks the first available bit from zram->bitmap) during next writeback.
> > There is nothing sequential about that, in systems with sufficiently
> > large uptime and sufficiently frequent writeback/readback events
> > writeback bitmap becomes sparse, which results in random IO, so your
> > test tests an ideal case that almost never happens in practice.
> 
> Thank you very much for your reply.
> As you mentioned, the current test data was measured under the condition
> that all writes were sequential writes. In a normal user environment,
> there are a large number of random writes. However, the multiple
> concurrent submissions implemented in this submission still have performance
> advantages for storage devices. I artificially created the worst - case
> scenario (all writes are random writes) with the following code:
> 
> for (int i = 0; i < nr_pages; i++)
>     alloc_block_bdev(zram);
> 
> for (int i = 0; i < nr_pages; i += 2)
>     free_block_bdev(zram, i);

Well, technically, I guess that's not the worst case.  The worst case
is when writeback races with page-faults/slot-free events, which happen
on opposite sides of the writeback device and which clear ->bitmap bits
on the opposite sides, so for writeback you alternate all the time and
pick either head or tail slots (->bitmap bits).  But you don't need to
test it, it's just a note.

The thing that I'm curious about is why does it help for flash storage?
It's not a spinning disk, where seek times dominate the IO time.

> On the physical machine, the measured data is as follows:
> before modification:
> real	0m0.624s
> user	0m0.000s
> sys	0m0.347s
> 
> real	0m0.663s
> user	0m0.001s
> sys	0m0.354s
> 
> real	0m0.635s
> user	0m0.000s
> sys	0m0.335s
> 
> after modification:
> real	0m0.340s
> user	0m0.000s
> sys	0m0.239s
> 
> real	0m0.326s
> user	0m0.000s
> sys	0m0.230s
> 
> real	0m0.313s
> user	0m0.000s
> sys	0m0.223s

Thanks for testing.

My next question is: what problem do you solve with this?  I mean,
do you use it production (somewhere).  If so, do you have a rough
number of how many MiBs you writeback and how often, and what's the
performance impact of this patch.  Again, if you use it in production.

