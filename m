Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A05D6C531C9
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 05:30:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DCC46B007B; Sat, 25 Jul 2026 01:30:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58DFC6B0088; Sat, 25 Jul 2026 01:30:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A5636B008A; Sat, 25 Jul 2026 01:30:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 171606B007B
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 01:30:36 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 82EF61601E2
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 05:30:35 +0000 (UTC)
X-FDA: 85026174030.05.DF6B82A
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf19.hostedemail.com (Postfix) with ESMTP id A80191A0006
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 05:30:33 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=U5H1WfcC;
	spf=pass (imf19.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.174 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784957433;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q9DTVZXLp+TNicZH9cYEyTowjXvC1RszrtcpW4YmnMo=;
	b=0tWptFcOzVfdqHIL+qggp6OZ04nhlLRRaVNcaDnmSuPZWAJiyPDZD6HAFpY8Yu3JMOmVSL
	12ZKq+1S5RDANWE+I/hrZneA0hFnBghzRUDrsmPAEOvXtASg1kqrYgHDBNpU7Qa8rX5ulJ
	LmchV/k3cTtTb8S8fhkGLsw4i1nEBeI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=U5H1WfcC;
	spf=pass (imf19.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.174 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784957433;
	b=8gb8rqVo9ISx1qYdCQNPpIWRwHSG3P5PRmSL/jOag8hDj7LCdh3JoV/xYy9NgMIPvzv/ju
	zOuzs6cqexZWexxq/i3Zsv8d/h2VjBnObCygHxinZ88XDtqnQd5jPYgknLimbZBhftXKy9
	xRreR1/Jy4UljmeA2yTHmb/BPOSnzew=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2ccf2360620so11043725ad.3
        for <linux-mm@kvack.org>; Fri, 24 Jul 2026 22:30:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1784957432; x=1785562232; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Q9DTVZXLp+TNicZH9cYEyTowjXvC1RszrtcpW4YmnMo=;
        b=U5H1WfcCroheQt6n1uS2IBt6fZIOoIAaeLF2JZOh7PiB9zoMdphutCcSS91tuJ6L26
         00rQD1iB0woX21ZOt0VYn22jX3OKeIm3+MjZUcoI4WZzfG4CcNA0DcLMCKsWK9HbkOVj
         Fh1oFOXCzTx4m/pLTlr5oJ8AQDQ4AaoKB3GIk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784957432; x=1785562232;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Q9DTVZXLp+TNicZH9cYEyTowjXvC1RszrtcpW4YmnMo=;
        b=U8qzatoS3D4i1y6J6HrKzzKunIU7p4otiiaYIsOv26PFVymEGibuQturwrsm77ztqa
         YPgtmEylxkJG1WPnOGSforaHoq5CL/BXeGiVvzRuok9ONuRlxPaw62kC2lTzwGR5oe2s
         OSS0xV+DMk6Yjj7DvuRiBjuU5jITXEdluEtbj1JHKDDPDMbZHCllYkKMIZr6T1s25cmz
         inewvG0jgeZcyHk3mJauMtwvWD35qB2QRK7RUYw2fXSPlJTb8sX6lL5SVmhMycRRfUju
         t01n/YoskIZVkCUJGRajUOdhD8bc3g1NlrBIASbRgl0yX35wb7bCP87LqsxWYJ3aLBux
         01GA==
X-Forwarded-Encrypted: i=1; AHgh+RpycVyEBXX7FMh1ceP17LYhUna1EBit5o+XxyIZBdPBXWGRqNCKjDs6oMcVXjxV5aVjY+PMzCQf0A==@kvack.org
X-Gm-Message-State: AOJu0YyPqMEGedMFy1GT69I13F5rd5SDbpRji03hvRtUKbhP4ccXi+46
	y9DxsnaoE5F8Go+7x+OAuAl3iapT44SFmIoIuYwXf1ubj5S9Pe+pCwtbdwgV6A9zQQ==
X-Gm-Gg: AR+sD12sNtR+qBeNpVhfkZl0+tNJ3D7+oWn/t+uvuqswWFmQnG3iTwf06DBhXBlFgu+
	Kss97ARJLuoEzfrhxk02xoRWvlH9dx4EMA45FbkAhAyMPWDmNDffNnjkIVVGJtLFcDPkiyUDgZe
	eoDN5ya6Ld0phqHB2SzZS7LQ2PUD59UrY5AtlTt54KR43brTIKt0paDyAVo/V8pNe1Ca0O+N6Hk
	/eZyJebkVwBHs5bNEMXrlCaRz5SkecduCI1ZeO/a2VYEUgsFv4e4E5Q3r/nPrBYt1vQFtGM7tLL
	y2frXlZWvSOGTbyGd4vdHNyWBEWmZuI7a2FvXnPtMdsqWZfjl/stkAaj0skhBsqm7GhMfxmN5sC
	yYVz9lfyFotZAnTKgDpVOHUFHEW94LMQfmE48Lnw+d0OC3AR5Slt6i9uP5MO7aDuoMZyzyQeoUK
	zPgomIGv/Zd1ZgxM3eIcXcT5+eHSrebIRj8OajxWPkyTxkjWGF8dQq
X-Received: by 2002:a17:902:f689:b0:2ca:3b31:ef4f with SMTP id d9443c01a7336-2cfde881841mr12489805ad.40.1784957432564;
        Fri, 24 Jul 2026 22:30:32 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:fbee:e165:c3f8:38a4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cfde7bbdacsm4958385ad.47.2026.07.24.22.30.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2026 22:30:32 -0700 (PDT)
Date: Sat, 25 Jul 2026 14:30:27 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: senozhatsky@chromium.org, akpm@linux-foundation.org, 
	haowenchao22@gmail.com, haowenchao@xiaomi.com, joshua.hahnjy@gmail.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, minchan@kernel.org, nphamcs@gmail.com
Subject: Re: [PATCH v6 0/4] mm/zsmalloc: reduce lock contention in zs_free()
Message-ID: <amRJ1kbq1-zv64fl@google.com>
References: <akynv_js-5G88rGd@google.com>
 <20260725035733.53241-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260725035733.53241-1-baohua@kernel.org>
X-Rspamd-Queue-Id: A80191A0006
X-Rspam-User: 
X-Stat-Signature: 87zxe6b9er1wym9udsxs7gce5ngdnuoq
X-Rspamd-Server: rspam04
X-HE-Tag: 1784957433-245680
X-HE-Meta: U2FsdGVkX18GGqjyP6p88tRlDity87iC3g9o7pg9Fp7jCt8lHX9SVTZr4LcuSBYftJSzKYgFpJ97EXbA4SvO+yxaKMsyrigQKbk6qeW8/uwGAinUm+u9Zbm1u/iIFLkOJR8GI7qvMoMCT2anH2fgR9hp/CymxWsqPweLuYEsCtZzndUcyF6NmQ3oujDI7n2YqvbIRWgRKMnzJM6Kp3a3E1KJE4ea9+kT/LeMBp9XFZfLNJAT/UFwQhj6AAcKgfEvzIo1II2QK+NF1QU7eNIgCB5VLSfz+ULy7+zI3cdzPWeFt7bCilJhoqiW8q/1D+8o0+FDBm5COIiYO/8C2JGwJsYHhk98Qbi0dISK4Ocihv8D9UJHLcQx8nC+anI6er23N7nbdFZeHFgH8oRHBHPQt7bqQIVta5E/NzJfDnS15RWWevrPH8Q80Lg4ZO6cXhwoTeXmShJbxmP20mosd/m+XBW+c7PfsdgGiScQr9kcGLaChnWGxrL30lrEkmtF14XGM3jForK6H+sDmCWWYMjwD+xSEQItGMmwO9/7H8/rbN2+5EZfvJ6cyX58IxQGZAlK9hGNkhJZw3PvXrcHthlP1S4gCrB9SlR+zCWQoTtPzfwT1afG33SlTBZOoC1fdbzculUlPQtsY+jUqgQliba0QrONn21ScEXZMaivGvJooE+AwTqu/DmEmNxze+5NEjUY5UqNHW7sWETtQm/NoSdsfgzPiEULRPPexEEigZQLuS2czyCC0SNdyyIXFArSSpYpSrecKl/CXpCh59l/hEgP27H8MP+bw2AjkDP8C8ewRWyXiHBxTK8MVwTa4xiCm/qO0eU6bg7c3yp2pIwMaeXfiT1okxX2sHeJ+AWcs9WT9ubDKOfavzYp/iXrGfaI5YOHW34OAztkopNeoRRqCbtsR3uMx69+1dWbEHCjLDxG4ozelVEUboSzKxR6geI7Wu+cMAY2uBr0p09u0ExbHTs
 z3jE9hj5
 /r6NhuCrmPkS6nTWQ32R9LlO4PyLwe/z6qVf6G5jkBUnWSInB+RaU14u8LF2KhwWRUc3BvF02VvVsYY+sn8SfZMbCuasC5kop1PEsQ/JKVDgttEBZcVPDTp8fgKdDi2G7HUBgBu/FbOzPHVIpJS1eHgrfE+7TBztUhTiiaCEh8BWOicLLW5zCxUWvN4n/4N0Zn89Cf1aBOk8gkJ55GyqRRv+xKl+hdrFXOLWZU8RJQ1dDIS3hWqCYm3MbcPE5oT7OITdm4Qg+xe7T2njO5QoOOxyYhZDZTIh0eWdvEUWJuL2uChrbT00fDJt2sk6bYiOdWfiGf2OEx2hmaVFKhX5OYhOjUWz9RoOTv6mlPhdakdCq1HTinQc4qv8OX5OPc9BsK0ujJu7ce+pZEy6Q6htlzM43hLynqcwewxrWP4zjc/ZwMggOJiQSsDJTssj+d7hMJrBmAEt015GcCoPFNimIpUik5bxNv6S+5V/Mkk5fvO+e45XLLQrs0EwIew==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/07/25 11:57), Barry Song (Xiaomi) wrote:
> On Fri, Jul 24, 2026 at 12:55 PM Sergey Senozhatsky <senozhatsky@chromium.org> wrote:
> >
> > Apologies for the delay.
> >
> > On (26/06/27 21:36), Andrew Morton wrote:
> > [..]
> > > > Raspberry Pi 4B (4-core ARM64 Cortex-A72):
> > > >
> > > >   mode        Base       Patched     Speedup
> > > >   single      59.0ms     56.0ms      1.05x
> > > >   multi 2p    94.6ms     66.7ms      1.42x
> > > >   multi 4p    202.9ms    110.6ms     1.83x
> > > >
> > > > x86 (20-core Intel i7-12700, 16 concurrent processes):
> > > >
> > > >   mode        Base       Patched     Speedup
> > > >   single      11.7ms     9.8ms       1.19x
> > > >   multi 2p    24.1ms     17.2ms      1.40x
> > > >   multi 4p    63.0ms     45.3ms      1.39x
> > >
> > > Well that's a nice result.
> >
> > Indeed.
> >
> > > Sashiko AI review said ....  nothing.  I don't recall seeing that
> > > before ;)
> >
> > grep-ing the code, I wonder if we maybe want to tweak some comments.
> > Namely, zs_page_migrate() says:
> >
> >         The pool migrate_lock protects the race between zpage migration
> >         and zs_free
> >
> > which is not entirely true anymore, as zs_free() has a lockless path
> > that doesn't take pool look (when ZS_OBJ_CLASS_BITS permit).
> >
> > Likewise, __zs_compact() says the following about pool migrate_lock:
> >
> >         protect the race between zpage migration and zs_free
> >
> > None of these are critical, very minor.
> 
> Does it look good to you if we squash the below change into patch2/4:

Sure, looks good to me!

