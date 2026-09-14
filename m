Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85B54C88E70
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 11:43:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FC7C6B0093; Mon, 14 Sep 2026 07:42:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D4CF6B0096; Mon, 14 Sep 2026 07:42:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E9AF6B0098; Mon, 14 Sep 2026 07:42:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2FE666B0093
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 07:42:59 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4BEBA120360
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:42:58 +0000 (UTC)
X-FDA: 85212181236.18.670E028
Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	by imf16.hostedemail.com (Postfix) with ESMTP id 83A6A180003
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:42:56 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LNvkTpVB;
	spf=pass (imf16.hostedemail.com: domain of aa9736195201@gmail.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=aa9736195201@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789386176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o4McCO5QA5RDLTkl/ISRPyM2FuR98SEf9b6QSmXRjYA=;
	b=Bd5weNzvZ81TxXRyAUg4FpR/98PVQmK6qCjYbsSb/7R9cHW/+5OsgF9vUgL/738YGWMBw1
	XEzOeO3oPJiFblROFDpUaay8nx1AXnvwD3xhpBTWmIQA4DdFq+PjL5KNUOAXcRnOT3BB/A
	Vt9ukhtw/EgW7sGHZEg8eekYHHccIqc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789386176;
	b=OTCpkOlf3R4InPvJ6t1fYI3sZKtA0i96QYniikQvAzK6Ku30lXB2nUUY6SfJJzN9lkrQcN
	frq+n8Ayse0Ym4V0/Moq8xBOhd7WIrse1AAMkk1Hrehgt/HBXfUkEMmob1i0YYXlJFmEGa
	AUyCNxTYWLa1scYqZlMVfvWRxiabZwY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LNvkTpVB;
	spf=pass (imf16.hostedemail.com: domain of aa9736195201@gmail.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=aa9736195201@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj2-f13.google.com with SMTP id d9443c01a7336-2d8fb334e72so18766895ad.1
        for <linux-mm@kvack.org>; Mon, 14 Sep 2026 04:42:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789386175; x=1789990975; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=o4McCO5QA5RDLTkl/ISRPyM2FuR98SEf9b6QSmXRjYA=;
        b=LNvkTpVBVLtnmmEXCtcMjxSmvw7Zm2wtcBoFNXXltnML/6vsL4BTXv2dp5PGbvPZ2q
         jXMs9HnzOLWNwngFRtxwgyJJp3gKzS+3nZ2jFYLHXWYSqf7VVXqsjtQuYyk1IuK4tH8Y
         NQDSc5Dx/kLx6QNjD1knkyQ3JxJpDKZLxrbG3W3MoHDhYVy716uZNszmn+iQxgW3vLD/
         u1CIUV/6kSvIE8ITW28aPhcndZoWsztOtrRQ54iytj4ukdJ7aiTiyULk6iMzQ8c0Ac+m
         Q2UE5b54/Vc4eLOt4tL+YsAwL1IfbWwgymBqq9LCO5TB9RdnEs5s6Zb5polDXG/oEf9d
         m9zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789386175; x=1789990975;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=o4McCO5QA5RDLTkl/ISRPyM2FuR98SEf9b6QSmXRjYA=;
        b=fHB/1A0pMvZ0A1r7sYCxwYUkPvIb1rxOF3luXHQA2ahSpDuc18oa+ke7xI49s+g/EQ
         YYugRY2elM+riUkFvrCiGrnsie2LmZxSXXQoet6EvmW7AmG56yukZC51eBKis/7WN9K2
         01+cFFKSiQvzXkFws7cocQqoqPf6EGYTpi88rKSvOCH4uGjfyAWXoS0M6yikzlMql64x
         JrsCD03HFLH2V9rvzJSuiwVXAtZkMJyw8dtPSwd1CAjHNp808T4Xdi6IuwPxiIy/JSn5
         sOvCTOIdld/C2R0TkgGRFYOzegBuA6mjLuyMMvMwztcpiAxrNxf/bvy+QUaADutBaM2i
         l9mQ==
X-Forwarded-Encrypted: i=1; AKwUvBwSKuvFH6Rwuoy/QBwL2V0ZFxZ8GIcpv1IDePdehG2g2XqTqouyI1P3Kkg5Sr5JJB6IjjmdecrmGQ==@kvack.org
X-Gm-Message-State: AFuF++mb+yH7efB8QaA+3RedFXZgcJttap75e/jBUzP81mROTimolcCl
	Zg6il/w/YaIp5FwYclHSr11VF2722jvLr+Eqt/bHSil00FO6nYDXsQdn
X-Gm-Gg: AYBFou1PBE5QQ950nddiix6zxgFXBoC5sQBCS3VpQ2sDuikiZZtUDjz2uhb58KL8631
	BLqqNAKc9CTivbM8f/OvCuc5aRdc18Bdv704W1IdIRqSU0cznQioiL1z7j6pQ0uySuvGJqSx3Hu
	rWSP+bXpIKNKpq66HIcm4pqG8MBzErcKx4VE7CWPYBVwk5M1iszNnPs6jsOdYRRItaMnpf/G6XZ
	EdcOpwjKUTXbVutdS48Fe5m+zuzM60RFE3Q39ObCVn4yaqwmHahwPMs/up3KpgCozI7KMwCw7GW
	A259svNNMQ7udCTtHqA/NbY7NvRclDoQzkQc5sc/3QFmeVocfD/TAnmC4kXXf64W75dLRemJKDM
	ikZ4hB4CdoxSwNo8tVqF51Z4oqWIb/u1z3y17gRL0IM5OY/BBGTour1PQSdBGPVM2sLHc0+20YC
	Lu8O7GjkmKewcKZEzudVdn4dSgZV7zTlW+aNHV0rlTQNGRpMJ40OSekua9xs6qFIa2mn97BUWqh
	AlHC+cpVpmlcGNYSiLQivRQRqI/b1v+fsiFLL4qJJ9qQSU1fr8g/4N5QtIrEgBwOx0PYPjFKpS9
	Y53gYxFxgePHgNoW6aMbu0EzyA==
X-Received: by 2002:a17:903:240d:b0:2d8:d4cc:be68 with SMTP id d9443c01a7336-2dd6c75858dmr51731475ad.21.1789386175200;
        Mon, 14 Sep 2026 04:42:55 -0700 (PDT)
Received: from DESKTOP-TJS95SS.tail460ce2.ts.net (114-38-150-193.dynamic-ip.hinet.net. [114.38.150.193])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dd34c7f976sm44032275ad.81.2026.09.14.04.42.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 04:42:54 -0700 (PDT)
From: Yuan-Hao Hsu <aa9736195201@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Matthew Wilcox <willy@infradead.org>,
	Amir Goldstein <amir73il@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Jann Horn <jannh@google.com>,
	David Hildenbrand <david@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Zhang Yi <yi.zhang@huawei.com>,
	Jinjiang Tu <tujinjiang@huawei.com>,
	linux-unionfs@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ovl: implement ->get_unmapped_area()
Date: Mon, 14 Sep 2026 19:42:49 +0800
Message-ID: <20260914114249.663-1-aa9736195201@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <CAJfpeguhxCEs3pZuqAZ-gpG5gm7NV-TuzniSkCCrgAQ-TV6ZpA@mail.gmail.com>
References: <20260827170718.497-1-aa9736195201@gmail.com> <CAOQ4uxjxDV0U9yrDA_StN968P_6cpjRAN2mBCx1c_RYd7BF4Og@mail.gmail.com> <apGCDtf-gE1osJqE@casper.infradead.org> <CAJfpeguhxCEs3pZuqAZ-gpG5gm7NV-TuzniSkCCrgAQ-TV6ZpA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 83A6A180003
X-Stat-Signature: toxssd45gr5c3xa9gxzdwp9r3na94gg8
X-Rspam-User: 
X-HE-Tag: 1789386176-863274
X-HE-Meta: U2FsdGVkX19NoIXZ+2NjiH2zJ8UXCSMmZ/7Ss4SNUoAbXlFjjfEi0lMvnaVRMmpZpyDxlqVPA5fkmkWd0S3aPEnQniClMrfV/Cnj28gvwDGtnu1UYyt8hpEejh5iKGMfgsQaexxa8RNU8KpOLX6pSibwDLGePUHZbkfIikCU/C0ZEpZOksoS4n/E4MmzdB3uigOHu798JBciOXGGKwtBJSjEjTzd1eV8gwtNFcm7iu/H5uHzovn562HuVCxBFRyEanTiHR3+PfzFFz1o52TOdq94pli5e3Rc3a10CI33V+H9RtPxYhbBIga1ItV9zpQCc7tNPIyFL3qS/QrgfStC7N2qZAB13Dy5/LtDcXWDPXMP4WXSQUdmqCD0gh658nYFPvnU18KFXuhZUZKQNRoMMPVMVEViEb41iLGbrFs3aQI/ByAVImPcfEJeYfPn8PGxu6dkke206u0pk/PBS7i6IJe4uGMnCLchRgTPqbQHZcILPJ2Sv/k/K+V3B9plkyMShUANVqUNGsVFll6ISdNWf/OA02RHaW+4vLrmhgpZWXaUR0DQ1PDWYU9sNPT2RdvbSKyhklppO59CaZvJoX7QPnfbbFN/c+5FLfc3xTtRVpXnsCfsLnjJQ8pXOk/akGjSHUO5kMDYU/o6vsG0M2nH8XDRv4qyHJhsvpuJZXvPj3msFRHGpScF6sm/r9o6GbJOvYr7yWafxoBvRHRNksd+O0xkh5wWQNS/SKMzTJYhPiTR/m1Fj+dKKoV616EjLVuyY0gwi/i4SkrJOzjEecSICmi9H2wm6qh5kelN2c+cFizbx5ag7odYzLlD1UvkfYNRqRjDFweCZvJ+4fJptCG5BxI96rhf2v67RtX+voJ72NtiTAnsF0uSWxJB8J73IOHsP6RSSUa+r+dy6HzgP4djbBFCYR6gimaThSojPQSIZ7sQwkdZLnNNjyb+zkbLhn+SXevE7GPvNEAQRdMgeZD
 AKfOu0zl
 eenFsK3eKGOSz98FOPRQSNsMnUH697jUoqkVXgQJJYxoQb2JqliXcJqScsZDcKPTZv4L/x9oIZNUKqL7OFJZjIUKhbuIqaj0DNigavjaf5x2ffq0FnygP65Ij83KsdoHUjJDOW8fL2V/AvHXgcj73lHR1tjSSnCAGk251WXQ3a1aM6SWr+VDzJd6g33YbAw1jzuJG8IzaF0OIOBBYbLn1Gd7rPsJ/6x2T8IOlYKdBqPoNR5qdxaWFMTxu9QXQnpkrT6lhJsGenSOz+q4oku98ZJv9w38EQDvsytX8jURn1e06lNRA/B3X+99hgTt51JjCoSxwCEEDJU3f7Z5n+em9dr426sR89fdUUl19haQlw4IwPpBzzcVLprsNuoHVbBxu45R93EjTqrdE83C1VX2Y8hf2CeyOavNde0F1dLtSyAOt05PhvigwY+mJXQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 31 Aug 2026 at 16:18, Miklos Szeredi <miklos@szeredi.hu> wrote:
> There seems to be a logical fallacy in saying thp_get_unmapepd_area is
> the most suitable value, yet not making it the default for all
> filesystems.
>
> Saying this without any understanding of the subtle difference between
> setting .get_unmapepd_area to NULL and to thp_get_unmapepd_area.   All
> I can see that the difference is indeed subtle.
>
> Can you please explain?

I had a look at this.  thp_get_unmapped_area() aligns anything with
room for a whole PMD in it; nothing asks whether the file can use it.
NULL means no alignment at all, and 34d7cf637c43 kept files there to
avoid "unnecessary VMA fragmentation and potentially worse performance
on filesystems that do not actually support THPs".  The case where
that matters is a lower without large folios.  32 x 3M files,
mmap(NULL, ...):

                          ovl over ext4           ovl over squashfs
  NULL (today)          16/32 aligned, no gaps  16/32 aligned, no gaps
  delegate (v1)         32/32, 31744K of gaps   16/32, no gaps
  thp_get_unmapped_area 32/32, 31744K of gaps   32/32, 31744K of gaps

squashfs has no large folios, so the alignment buys nothing there
(fault counts were identical) and costs 1M of address space per
mapping.  v1 only avoids that by inheriting the lower's choice.  fuse
passthrough already pays the same, as Jann noted in the 2024 thread.

Hope this helps.

Thanks,
Yuan-Hao Hsu

