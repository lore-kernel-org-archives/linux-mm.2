Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 815C6C982E1
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 12:25:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 750276B009F; Sun, 20 Sep 2026 08:24:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 700826B00A0; Sun, 20 Sep 2026 08:24:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C91A6B00A1; Sun, 20 Sep 2026 08:24:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2D5D36B009F
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 08:24:59 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5B265160435
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 12:24:58 +0000 (UTC)
X-FDA: 85234059876.27.4B6270E
Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	by imf21.hostedemail.com (Postfix) with ESMTP id 998071C0004
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 12:24:56 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Vdul9p9W;
	spf=pass (imf21.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789907096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bpdMVsVBLYjzWDTXbQjKSYrSvCe+sMnBTBU+TbdKtJ0=;
	b=Fcgj5mJixu9OpQYZBEvHoKoRRtuPQZb94TEk/9Fm/qquhRvxIkYR9rlcJXhXR1HfT7GXge
	CBATS5DcgJdpjThFEefZ4cPy9Kp3B6f1KL7NxT2FQgHBtVvZTFHIih0NUfqzBEsc8CSkyq
	h0XqrSJhEv0E0qjMzJ7oxN55jhK2ecs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Vdul9p9W;
	spf=pass (imf21.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789907096;
	b=eG8a5pXMLvvpUqwgyiSHh3hwib/sLla3wFncGU0tG0BS2Y1lJ5TsQwlodsptv1qc20WoLi
	fiDxqpowQykZi+DmBxgNL5C9JmayNP6AbxXtAgoemWMRNmXfIQb5XaFLYRSKWvt8kHjjnk
	dvotUOYKYFkm7TG0mYh4Em+mkqhT/VU=
Received: by mail-pj2-f13.google.com with SMTP id 98e67ed59e1d1-396cccbba92so1947332a91.0
        for <linux-mm@kvack.org>; Sun, 20 Sep 2026 05:24:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789907095; x=1790511895; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bpdMVsVBLYjzWDTXbQjKSYrSvCe+sMnBTBU+TbdKtJ0=;
        b=Vdul9p9WIrx0m0Gh/3VrylgoutFxgbRQMacQqmFpNSKHxqjTy5SngzM+//NVhIHehn
         18rFAbXZXlG50IMkTrY3SR3lP1Y4cYR37dLMY6c0zi3bWmoD8XvkAM7MOpyqqZ2J9V4B
         NAxe2DRFQzxDYNwVZfeqr+YAwxGt7VBTDg3SxOGMfBJlr70J8dsjDapvfirq1Xwp15jh
         R89P9ChpO/ps7PBGy7sIuqun+/Q97ok7baQjhGATWM0YEbOMPcGi2QHRVntFP3yrtbN6
         W94OPQ80i1tTcDbYqt/E3jChBtccghJoYU7ef/ajS7zu4rlAQxdP656LePhjJIh6fhWj
         RrBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789907095; x=1790511895;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=bpdMVsVBLYjzWDTXbQjKSYrSvCe+sMnBTBU+TbdKtJ0=;
        b=hn4daSXdMPeWGSVzFeKIpzXsgj2lyEXNoOVd9bL1OSTq+Fg4TRoAtuW0YcbrzLxHH4
         plZwTChf365yCAOMfHHFxfGqTmupbmCqfwIFNc/GVjYYVF/DkbdjPwDv+k8TNJ++M0io
         63GUX5Sb9SrOAwPYfWsHaAVZ1t9dib9Y62RG+QARD2WK8YpUS8eEsQ4d6CzTGRzW64TX
         FBRcURglnYxNPGStB6yHXDETmcPUCv2qWGWcl45AOlEQV4MNOu6rSEsV+8m5eJixtTLX
         lOmJVczYxlx56bpLi83lFLzxA1WqjFr7/N/NGbdbky08+DMn81lmiUC9X8LNn+/J3TA9
         VFqw==
X-Forwarded-Encrypted: i=1; AKwUvByyjDZ+6fetpHHvP36Id2ERzqqyv8BO0ddILxgZpvtXWP7flQEabDd3J3Bo86b2jEw5xaLIBfX4zA==@kvack.org
X-Gm-Message-State: AFuF++kVfjDpy4vtYgGEn5RntsQXu9r24X/GhAQTK4jUGiXhuGTbdwND
	k66QQvfqYjqDA+T5wRT6dQOOUR8tS6j/cBMqaFw1mklBFULwb0hlwSI=
X-Gm-Gg: AYBFou2mXpHqnHhgrXxWzmiCge4yeCX0a883NsaFzxiEGog1woSaKxiyCN39gXJ6WQB
	pmIhrk49NQzkk1IqHm7R/kcj0/QfuMq+n8gqZB9VXrX5CRLCwaFxMr9psxI4Z9+gO8ZMLczyswo
	5z3ZZENHO256pPUb0n23L09HZGyWu1BHnX28QWkWpoch628r2Citf0v4OqZd5qahOXXFBKNZPH6
	6xy/RjL6+z+o3b7oayOVhuoGjoslnP7TmDqMFE3eCJhXmtp/nEYORFt0XCzZ7FwGhsZxMUk6zhA
	5jkGmNOiuRmaTvnBzIPbLC9GrJ8m0fwhZBxkMpn3tsVt8cppfAaCxvHBbFLriiu7TFqF5OBGQ/v
	B1DHuKaLKPwIqQpbdez51mBxHaRFvRi1A7hoRf1iUEYj8p6auVd0M94Q4zTnZetjJiwYjqob8yM
	BYsgBA0EfhPwhyoYNzoxSOt2aBiNn7xEMbsDNBvaO4Z1pyQRwp/HhQ5Kr8bkObW9xR9MVso+YhR
	ZzlkrEkUMYKB8HHVoZ6epz+OzM=
X-Received: by 2002:a17:90a:b82:b0:3a0:42a9:9c82 with SMTP id 98e67ed59e1d1-3a042a9a040mr609569a91.43.1789907095575;
        Sun, 20 Sep 2026 05:24:55 -0700 (PDT)
Received: from ydg-Zenbook-14-UM3406GA ([2001:2d8:7f00:8c85:e0d6:4b87:c472:c9ae])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e6c3145e5sm9445857a91.5.2026.09.20.05.24.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 05:24:54 -0700 (PDT)
From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	rdunlap@infradead.org,
	linux-doc@vger.kernel.org,
	donggeunyoo.kernel@gmail.com
Subject: Re: [PATCH v2 3/3] Docs/admin-guide/mm/damon/usage: document the temporal tuner's quota limit
Date: Sun, 20 Sep 2026 21:24:48 +0900
Message-ID: <20260920122448.610319-1-donggeunyoo.kernel@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260920104921.48065-1-sj@kernel.org>
References: <20260920023111.2466265-1-donggeunyoo.kernel@gmail.com> <20260920023111.2466265-4-donggeunyoo.kernel@gmail.com> <20260920104921.48065-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: theh11t3xagctout9zuoug39rdm7jpc7
X-Rspamd-Queue-Id: 998071C0004
X-Rspamd-Server: rspam07
X-HE-Tag: 1789907096-951604
X-HE-Meta: U2FsdGVkX1+YuhEEorVdcGa+/9mAYfHiuGXL8jv5mokmf/p8DrXI+PSSuSnjnogbFL7rMDulRt41FF8wXKIfvRE+v4K7L9mYJ++V5tWJJYEG4buznP95/J/5ZQ4ZwmbqwHr5FBFa5BxXSu82IXpgYXQF7dx7DNV1qmgHknpxIpFlH/2rzAOCgmdnNyqvLYIYzT9t/icpSuKhtEKQlQnKbFsnOwOOagctSo/RnfRdRChxoqsLQHH+5zqXMWjV3oZbibJuJ+Qie57JnLMhvODgUN14hGOfrPsu0ph4h5N5EldXETY0q3c6jb8PxAiP7QkzBdD5TRRq+RtUcYjMovb5Qn9Ke6Ww3rnWTMt0Kn3GvpwJWPajrNrv25VLrc0xWllDb/Kb8qBI+cOfAsoF1Qcl00DW7vsqj87no+rzhSpR2L5cuELschufuwUAz7F9oIAET6pTCT0mRak5glKL4vlEvnMPXGwJ3y22q3ci6DKAk3EnWqet0C8k2M+Pjpnu+lJDJ9QrM6w6smSQwiRS7a5f14I1JL8japRsvWoP+hheXaoYyeuYVXQfJlMNaBZ48PyNeQvo2JJeORIsOKyv+IrXOr6R8rx9liJIe/0X3ENbH7Qd8fv25whjP3eg5H8CWRgcut0/d8pBr+8k0RdiM2zjGen4WtNAeyommGc8ltDUl9b6KuxHK62CPjzyUtogAasNIQ59ZJvL9irKlfcUhlwh3LI6Su5KZ+LQ14N+YAY0vlo4woTHzdakK3C+DYlyMryzGMf7BbMT3Jcy7QDv50jlQJ6Y9t9F1VH2EcSQ+8W9MNZsrmScB/gpZyB7r5VDWY21v4ot6xQlTWyHSJU1tL8pP/WksSrhzqqW6Fsv1gMDXZkiQXF9YXi8h1Fofj2ch/uF4AeMg5UVVesjYaPUDS2hhgSH1rK8/E+F7ZaZsR//Uixm8/LqKvssb8j2bzGSVZjYutxmvAVDZBiJ+LqsR8X
 8EOSgnm8
 jUL6W1srvHhYvEs03EGFRLa5yZHTApKOYj+0XHGpZkvFW/YkEQupKbGG4A9+IGV5rNVmFzibfsDVCLeE2GhaGMNSlYyHFXK8w4pXox5HgMtsgR1nN51TD5uxzp0B5c6z5cb9S5q9imMEntl4St3fAWg1pGL1dlalpeUsmW3UYG4sV8i9y0ADZX3JK2PkzaLju22U1O8jctDmISA/C8UGgI9srXx5n1Mq3f6j/R79SZw/mNpvsgrGNWpAAU0maLHX5OO1A30uK9nkwHFLwvwHw9NBGUQwUg4JnDbqic+RkrfHLFdb7VBESR0TX+Ru26V9E7APTf3X4fvgUkGZHxgydmZMzoUzKxDUCg0+lqn+M/IqJexurrWj76aKqYvhJDJFeApU8zTFXuUI0aAZ5/XTYpR8eXsrsXbKWaEKXEBSaGeZo64ZgXJFoyrvrh2ody+ZC3XWfXLOjBEiogzac0jmvKHVJgh3MQyw/iNXq0nWe8iIBV51DYzlQfK1tf/2g+m/kNdVJ1j0WFBVcRa/Go3QU8KSIaw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thank you for the review.

On Sun, 20 Sep 2026 03:49:20 -0700 SJ Park <sj@kernel.org> wrote:
> I now think this documentation change is better not to be made.
> Correct me if I'm wrong.  If I'm not incorrect, could we drop this
> patch?

You are not wrong, and I agree.  Dropped in v3.

Thanks,
Donggeun

