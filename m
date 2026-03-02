Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EDECD58E7E
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 08:56:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B34686B0089; Mon,  2 Mar 2026 03:56:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE1FC6B008A; Mon,  2 Mar 2026 03:56:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E13D6B008C; Mon,  2 Mar 2026 03:56:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8D6CF6B0089
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 03:56:44 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1DDBD1B8FD1
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 08:56:44 +0000 (UTC)
X-FDA: 84500517528.10.E9026A3
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf14.hostedemail.com (Postfix) with ESMTP id 09E6F100005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 08:56:41 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=J74HlAIw;
	spf=pass (imf14.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772441802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zGn2zBBybEEv9ZX44IZlKquE1/3o0xnUGc8fJWCYB9M=;
	b=soSvEYOzzb/8vflDCQkPWixa3H3qlgB9piy64imdnkmiGz80UMgpjGTyM6uH9K84cugW+D
	4dVzsV4sOfYEfRfjRN1EtR6wyLENIgK2RcZYhs6f1UcRZK5cwywyky/mbDLX7+Kcklbn8H
	yv2xU0SJEnalP2ZyQj6UZjeFUwICh5s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772441802; a=rsa-sha256;
	cv=none;
	b=M/qNEX0DLNuSsmTyo24HmfpLclfj0J4aZt7wP3b+vAmZEqK5dGyk8ZseKw63IXA8Yw582G
	zYyELOwvfd8h16rY1oI2ahE3Nts8G/TmF9/Iu7c2cqyMeY4qKSTdCVz3BcCbRHVy8GOB/f
	hgTXIE5FbeKVtCLwgcb59Gf2vQmoT3E=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=J74HlAIw;
	spf=pass (imf14.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-483bd7354efso56811025e9.2
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 00:56:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1772441800; x=1773046600; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zGn2zBBybEEv9ZX44IZlKquE1/3o0xnUGc8fJWCYB9M=;
        b=J74HlAIw4mEiKZzQs/0MNGTQD1Sase+rJII1wYa5z2HINYg0l+Txxwf7Iy4NEYNk4K
         vJnBm4z8ujr2kPkqAqqjU755Z6BJrq7Fir+aukQqmVUsaAGyhxLRC55sGyLor565M7E9
         zX5IaVRxhLPKGIlh+mRtKm3piRIC0WkmYX/nP9nM4M1E0qThB9fUjIGwRLoYa2hEQ0rt
         nLh0l2zIykPiAWQFMv8HrtmvSk0OfBPIlkIzneSMmfa7NpVwhU617AO9CrHUutFtdpMk
         eA83kdM1YhpNswLG+IN28wyATziBfyM0obmeJTaDkzNFMy3Aw90cNMMLOITI+JM0L21W
         F82Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772441800; x=1773046600;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zGn2zBBybEEv9ZX44IZlKquE1/3o0xnUGc8fJWCYB9M=;
        b=LpedjYsdX9moc9TpfloODaJ2lweUBCqcGS7SihFV1133mqxs16bIVxTvcr4MUuW5zh
         13N1zoHfXr8RvqtjoiOyxOsR1ZOCbHclc0ZpCW6ZI1Y1kFD0xZ+d2QngnyNyYLY5PioD
         DJJjPYqITef2uRvmS055T3aDuS+abkKnnlzIplofnlgZARIaOJz+NAAs8xBtD9Dh7ftO
         UltDozf/46f19uuW+H570lxYbRzFsBy7diP6kBZx18vM4r3v1e34SCnDzlfdM2AJZfjU
         3ABIHHyQXQ5/OGlLBRD+Bn7xbQMObspo1qlLhoyJRCqZueJO+hOgsiijTPzQhW98Jh3B
         imog==
X-Forwarded-Encrypted: i=1; AJvYcCU7ghj1lcA3JlWCg1K/v//oPlkPTvbhbw/lsFkX9xRfQyzgNlL98VKKD/9nQhq00IRW7kGDTQgSfg==@kvack.org
X-Gm-Message-State: AOJu0Yz1dVhw6cJ6bvBin67Pz82n1vM7p3gjdeMfbAgb0Gy/tWSlLTO/
	iyBwds1E2vmz9dVm/c+U+QRi9Bj+q9HrdakhsfL1p4NQqnqSzB9U9+4VzNoPshYhoaI=
X-Gm-Gg: ATEYQzx6lKHtmogfsVHJDW+Gb6Mmdp14x716XAZNNi94pMhxeBhEZVxqkqsJ01Cmzc1
	4fORmxdZTMWInXio+dy8A5OsxXI53TdCBQKFRZsyoCmaY4fKoflZAAtZt1TU9SOwLo+LIP5e7IH
	Jhyc2ywDcXNv5BPJUXWAUTQIjlsK9lNpSTmvRdE5LR3gFgrm+kQphFP0CX2N621XJ3F2ESVA1AQ
	RaYUO/ARsa+2AzlQPGzxWhEkYcZQ8P4J4C4e0XGZMPtTgvYxuZ9Hp2pxWDs7FCnhPsgH2MBIlX9
	igVccLNF9hZJeYtw6V8t1iQbJJQGDVht1lS0vsBq0zH/OqzHeJ0wfKbw5UwK3lScHKvuZ+nxzcn
	p22+wOzlZHRRVjUbgxXLM1yDM5bAgxfFYWl7Gz2sLfuI7j+vX+1HvDqHYMT2ZmGezJMK78VfjmJ
	G6+mgPymfF+ktM0R47PAsQrYadhG5cH7f48ZXf
X-Received: by 2002:a05:600c:8711:b0:47b:de05:aa28 with SMTP id 5b1f17b1804b1-483c9b9701amr226732165e9.2.1772441800274;
        Mon, 02 Mar 2026 00:56:40 -0800 (PST)
Received: from localhost (109-81-20-148.rct.o2.cz. [109.81.20.148])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483c3b770c2sm263183375e9.10.2026.03.02.00.56.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 00:56:39 -0800 (PST)
Date: Mon, 2 Mar 2026 09:56:38 +0100
From: Michal Hocko <mhocko@suse.com>
To: Benjamin Lee McQueen <mcq@disroot.org>
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
	surenb@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/vmpressure: scale window size based on machine memory
 and CPU count
Message-ID: <aaVQxnNFcbxKYRaX@tiehlicka>
References: <20260227221555.29969-1-mcq@disroot.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260227221555.29969-1-mcq@disroot.org>
X-Rspam-User: 
X-Stat-Signature: i1pb4hi1jfe36skfdqbynedfmxnstzef
X-Rspamd-Queue-Id: 09E6F100005
X-Rspamd-Server: rspam03
X-HE-Tag: 1772441801-347309
X-HE-Meta: U2FsdGVkX18mhJFSMJrUWVUEwS4/5cDwPUDNo7uk9COIdIC8unCtZ5UkXqisgz2nNh0pr3/JIi70gqTOF9429Gq5raDntBR/tTbxqXsssWIiWl8SRQ9K0r8hgtvpE9+5j/SB3S24aHpiQdOL0pDFP2kKwQ8PpnsOW6BiDz+1QjyZRpjIjIe9tV/kDdjVu7I8By5jEwOnvp/DKslD/9IoxPnGRTKGbuKkOXpRdkQ2E12k2iYAvcyUkaqRGdQLmwf0XD49A7tWJZH7uvwVnw2Daknglt7NdrJjaeh/XsQyldlcgGXqHTZdQhitp1pQV2yk6yZgWoi65Bx1IeT2EPZ2vorw0MY4/nmZ/AhdVzFWYK54im/J9tLr4Q60bchixBA5eaBSIpDdqJv9HESKM/8bAHqCrPa2uXkXiQTRaJskd0lCpD+2AGZMEtdQhVBxHA153VehitfmmTa0tbyi0HjGG4+Xv4hpV93pI/VhBsVz8sD2fM5WawgSFJCGQwzab9Mh9cv4nVCT9Ij0qGoXcbmUrMT1+uc0d7029isf3JnK4am8VmWMLeAvQdVlVVrfwvRrZFGuAL9YGcjINF7WqbrCn8jCgTfaFz+TsAWT7m6qmySQ7uWX897od7Z+jsO4y7qcLbLEFjTTqNj7yV1FNXjXjJCZcKlI9H4C/5304DDR+a0c/adTAGYReILm2Us5RoMeUlbImz3kYhNpmrF1MQ50oetWc9gxTio5Bm74VIq/eL7BYFa8dN9D7OcAn6hVBnNpSR9rlaJl+Yw/f0sSAfdVHfNxUtvBK++mDeAdxeCXQxIBkiSQ3Eav3ohPkGMnv4WGE7wtyiwnslHiS57ORP8fn2njzMpgDoRBK+jJTFVVuszER5fECQj3whmCaABdsLVMzG3cxfnbjwofFdJwd5JOVtWl211o2nVzOgiSgdRSDJGKaXEcNottxPRFkZGUlZVyfksoOxh13l+ILSTvtdp
 D0/lmU+3
 lNJ3guR8D7pB8qas9fjoToRPBhN/+/WQNbt1qo00o13poZYsL+ScYJs/Hi9M1tUKSEOQgUbA7ritxEFXbkDZEqh/6rR0PpE567GgRvjL2DkrN1SdfFlnlOcbF+0oQl7PKOi1Ti1Yhh3DskaLAPs6Z+u8Q1K0UVzP4G4BDJO1R3us+FPqN6WA8Gv38gor/STf+aXIOOGs51Cw117cHO5c4N4yqIbT9Z/FJKIbXxPkzioS3tjnC7oT37QMSySGBsCQnVTa0r/VAbsIVl7LmHJ3qldWxm8mLI6g7pk+bZo0ylU7JjQc8Ino5vJbbxI0ce9ZF8BMPo4gBNlTPmUljKXX6TFclM1wfNokw+2xEe+sDtatsNeTCgHEp8ePEWAVr962lYf0W
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 27-02-26 16:15:55, Benjamin Lee McQueen wrote:
> on systems of different sizes, the fixed 512 page window may not
> be suitable and cause excessive false positive memory pressure
> notifications.

Please be more specific about the issue you are trying to have fixed.
The above is way too generic. How much memory the system has, what do
you consider false positive and why. What is the workload. Etc...

> or should window size be capped to avoid excessive notification
> delays on very large systems?
> 
> v2: better commit msg, also tried to fix the whitespace.

Also please refrain from sending new versions in a quick succession
and wait for more feedback to come.

Last but not lease if this is a more of an idea rather than something
aimed to be merged make the fact explicit by RFC prefix to PATCH.

There is much more you can read about the process in Documentation/process/

Thanks
-- 
Michal Hocko
SUSE Labs

