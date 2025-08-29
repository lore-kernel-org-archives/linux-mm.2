Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4ED0ECA0FF0
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 23:37:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 953848E0002; Fri, 29 Aug 2025 19:37:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 902AE8E0001; Fri, 29 Aug 2025 19:37:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F2118E0002; Fri, 29 Aug 2025 19:37:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6C8298E0001
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 19:37:53 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 32E17140908
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 23:37:53 +0000 (UTC)
X-FDA: 83831410026.15.ECFFC08
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf25.hostedemail.com (Postfix) with ESMTP id 55088A0004
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 23:37:51 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NezZH6+g;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756510671; a=rsa-sha256;
	cv=none;
	b=P5K2ZEpC3K0vXpAg4XZnzCXjAr74FkO3TzU7CGBcFjcQ28Vmh+AeXS8R/cJFA2pVqi7AOV
	Ewo7v0IJ+svzEsS2VOrFgXGoptExkbmp7Ra1ttJYoyKirp3Po+GREyRc7GD3FhpgqX3zS0
	tMzQC/fHkWI/yM8Z+6PR3/Qj0yrCJKc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NezZH6+g;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756510671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=00nNOb3Yr2JjftLjYszdKiFKnSXcNfFMIfSlPiSZF2Y=;
	b=xk11FXv5y964VFcG31lI+3IJ1p/GtFOPPvLtaT9ghVNurYR7MoBaFUzIhL0kBdqhpyA0eL
	b6hYwXkNGBga0CMyzpyrGGMUqKPswTS2mJ6CSGg3d2Lh0MNFLSPT3UZ4KA94B95TIisFXX
	S0jK0ERfQIMq1vvnoLGJ66OxcvWZpdg=
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-248a638dbbeso23584445ad.2
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 16:37:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756510670; x=1757115470; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=00nNOb3Yr2JjftLjYszdKiFKnSXcNfFMIfSlPiSZF2Y=;
        b=NezZH6+gnFhYioyBAsCcf01gsoss7HLv3p3LivvybQ6TEqUD5BXU+P+MHaIJbGAQTI
         wEA5Cb8/CVY71TphK5+iJtccCBIx2Iv+0Yh8/NghG5BiuaFgOKFbwQSN8XGm3zV1WDNJ
         rCwzo3qjkHgoj70i6jnrniRlz0P6u0yfZKmlxnfqrGIt0leCgin5uqGMz4HtXAull5Td
         Kf0/tx5omeZIsCoaSm+HtYXwGMrJaHdWpsvN57h+fY+KTBOt6H4ykg+HjqOF3rwG6xd8
         o1/O3vXpxoq7/I9vF9emm1EZK+lGjNTrSeFnCbZ1XUOC/+xZ/IoEG8yW8oRvYjXATXTg
         M8tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756510670; x=1757115470;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=00nNOb3Yr2JjftLjYszdKiFKnSXcNfFMIfSlPiSZF2Y=;
        b=vznkgi090bsrKOQuqh5IvKZo75FOIoNHN0aUnBjK5t9N0K8kjPq9mjngMdl7fhgaSi
         5CfzVRdPOgK66xnTtl+UlQeLRd48IPE22w3JXhbvaQlycKt2+Pi28uVFw6jswnYtwpz/
         ko9Xe1mAs9YuGNsCpneD3zWz0+mdq9h4z2vcciWW+rh2vqjt8U4T7GzYGl6mBqtXWG2h
         B+3jKb7pmqtXftP45VfCJdmlm8DQmMxJt2sY7HKJrsB5ZA9i8lD1v1p1nqofbVc0xHdn
         8aRorptTzKv3xCh+qSxgwARtUFTqV0Uf8BkF0dpBg7Lu2Fr/gTCLydu89XUOC4OKEOc4
         dEHQ==
X-Forwarded-Encrypted: i=1; AJvYcCVqJjOqtzhCK6BJgHRczLtABdr3Ab1IWT5gC9Xqqd8X613W43+Yjak14BL0XgwOrA920V23BIWmTw==@kvack.org
X-Gm-Message-State: AOJu0YyzO8Ofs1P1RMpck5PW4wI+oOpM95J/u9UPl4IVknsnOcf178/S
	fhef3curol9GYCsAmjmoIqzi5DBVR0DpRvsgsOcNYIk2ld5hnJnvUJYo
X-Gm-Gg: ASbGncvQ26NxrYZkQVbFfPb82I6RoDaA6AMQB0AIZ7/ENt6Zkcu1UdAYIvmId5bXtfL
	2bGC7oq60pC6I7BqchYcywy5vEw/8BwO3e5xXDSKj2e8s/4PoYVGkuaOKC5AdlSRaBAxeHacjkp
	5stsKZh/aXAF1nsGfalP4Di+EdOPu5LdDRnWllBfbZlAIaK7FjhD8XLcjlk1UPLsyZzgzu8jGU/
	92ZbPjYCBCiZDS74MACvOm3p6t1HCMqcnxx/mn06QB2W7CnxPS2BsQg5JTgeVIMvZra3pb/TbH+
	knWeN3zjLt3WK9nr0yuDsblp6Dqin5PHCMjx1kWqQpxXqrBlIRZMxLO8yKgPEeh1qYtLnvhuVml
	0iofc3Gw1xEIlfBq3Vasv/r4k4FJdoTMic01V3DLjXPvRe4oNxm601v9gc7LRkXvK
X-Google-Smtp-Source: AGHT+IF5vUBxwOQDnV1jhVRxjdOQuWmGB9yjHYlaRmjnxZSBLBzUup5rMuhJQdyVawbFiZopAgbdig==
X-Received: by 2002:a17:903:15ce:b0:246:de62:e0b with SMTP id d9443c01a7336-24944a9baa9mr4866795ad.29.1756510670291;
        Fri, 29 Aug 2025 16:37:50 -0700 (PDT)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2490372734asm36196035ad.42.2025.08.29.16.37.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 16:37:49 -0700 (PDT)
Date: Fri, 29 Aug 2025 16:37:47 -0700
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Max Kellermann <max.kellermann@ionos.com>
Cc: akpm@linux-foundation.org, david@redhat.com, axelrasmussen@google.com,
	yuanchu@google.com, willy@infradead.org, hughd@google.com,
	mhocko@suse.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com
Subject: Re: [PATCH 10/12] include/mm_inline.h: add `const` to lots of
 pointer parameters
Message-ID: <aLI5y3lWdJgfLnhU@fedora>
References: <20250829183159.2223948-1-max.kellermann@ionos.com>
 <20250829183159.2223948-11-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250829183159.2223948-11-max.kellermann@ionos.com>
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 55088A0004
X-Stat-Signature: 3mojafrefjffcgfcz1xt89h374ptsid6
X-HE-Tag: 1756510671-911084
X-HE-Meta: U2FsdGVkX18klK0+yGxxJLkRPtTcOeFhjPRps9x+yxwFF4LP6s/S4n64b0XvGmd5p3CHw1kTpql6w23olcvvsbWuuDPt/4L3YtVnrydDOl3LSm41RxKy6Ls2NlWhKk37VT0ybhxAMMWseA2Q5eSAYLWhxAx8+ssep40G85JZY/RyP/WnsO8J3MDEcfzpHaYBLEZmVM4pQueaBRwpIUkBT2fXBVLzfLIhuwccUkQlpnpRHiHqRc1Z6huHzJEc6b/2RpH7feJODBGC3l8/Z8/ddYGB1S+1axjdcWlrl4jH/URay5OqAycimKyXHStvjRjjrCAVbpjCFVjXllYeK+0KkzEXItBkszYImSRa1QsJrNK6wwmSBkIi/pE63UxYfZk4SbjlUbR3JBa9rd3rEKpcivCDupp94CwBHnK2ua3kcTtY2hP83dLifbdvSSVcfo0PXxcmiNg6ShMMmejo/JTwNQ6yquA4o3gTlYlaLxPiYz9WhnAsyip+zLtls+Z1FukiMUjD8MSpjihs39ULzHIZNnOPfvjkauTb9R6S+OqNDPf2HCAjVCPkVrLqGSUDXEg/g6ff/iMvovZTYXHCI1m8470VpkqR5ESilkd12dliDYvO9G3sVvnWqWBC4HpHW/jnQ+WMBKUEZ5WDYr+KkosBnq1q+hT+cbKLvYPX+CAYF3f/4C/sm5WqS7wi1mQiG7u8zUN9CKovHJBT4kVS8cJDcmLc1DAU9SZJJPdm2/Nv14Pj0i4TcD0sgs2FeFns7f5rSyNdVP4FswqbaQjqJVnREzzBRgbwd/Wn6M+QUzB04bsybmsMlniOrgDrIKKjO0DOeGZerZadbepc2+ztFXCC/NF73+J33aeoODDLvIGfeX8CUdixP/w50M4HSt+SRBobNkAO+uHW2BMDFlNUYD6g2e1TWDJGSQYKlVdGak04GdAavIpqip3J76zZdClyfLfBu9lxI4cI6Hlw4d3TqS7
 syukm072
 OLNUT1ah4Sz12YqSdHqLoqRfMPlA9D/oAg2DP4VYi8gSQtyD+ZLHIRpLcuL9UR3FdcLa3A68DOYA/SM0TKQsDUpcd2693CxNaioJMLdDZuHNU7pV4q39JAUDthk5CqZOcjMxp+uBlx4YlkW3TQCEvRQXqubdj++upMawFraKjFNFkrhOq6cEvsWXqfaz6TrmpoeDTo5hNCRiEj3jnvWJ9r4PLFNExeWP1n7n99S+zGwL1CCjmdVRb8/VG9a0mbGYhya+cCmnAPTVwtc6qWrT11ZwveIZX+5AeVqdCTaZvF+WS95zc9+HALTQuRzzVXwD2YfXwFL31u8UiTh96ZmLHM14nqW3jp/obsNt46DYYgH2mj9PONYQaZBQL9c3msun7yNtXYhNfHbIfllR1ULQxQnJ9fGhkEsVgUnQjnWjSBMJf1+6obEDBlnzk2FMEh9UvjMs1wgG0gcb8mzN4nQ+LEE8fqFrnJShMBDOCmN5RvMswIL8nYKGoujQ/kpDE2Q3CULs669PhzNP0kNPBc33ue/vNsSR9x4YH0KO72zCnyuazRpveOVcFw19tYvmgc5m/ifTtpUJtvGgYP0LTRYIazqrZGIVF11wlKyhIL34VDj5XnnQwS8dZIEdCbw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 29, 2025 at 08:31:57PM +0200, Max Kellermann wrote:
> For improved const-correctness.
> 
> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>

Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>

