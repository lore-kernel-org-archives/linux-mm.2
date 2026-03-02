Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFF31EB3632
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 21:04:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2538C6B015C; Mon,  2 Mar 2026 16:04:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FD676B0160; Mon,  2 Mar 2026 16:04:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10D866B0162; Mon,  2 Mar 2026 16:04:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F34FA6B015C
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 16:04:57 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8187E140338
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 21:04:57 +0000 (UTC)
X-FDA: 84502352634.29.556CCF0
Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	by imf05.hostedemail.com (Postfix) with ESMTP id AF21110001B
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 21:04:55 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel-dk.20230601.gappssmtp.com header.s=20230601 header.b=pOHySUla;
	spf=pass (imf05.hostedemail.com: domain of axboe@kernel.dk designates 209.85.167.176 as permitted sender) smtp.mailfrom=axboe@kernel.dk;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772485495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A+IPbqMq77bOpkXLRkjJ3UFsST92OHSHvZuEyO94T9Y=;
	b=a99WRsfJPwWu5wA92E2tqbZIO462PcosvS2BcGK5d2H2G2x6Qd6EwUgs+MLKdIA82yqPTi
	p1+LW9TlBT/QxA7xdukRkr/uWRl9upJioP0M6pCwSByORkjuhemgTD5EFT6FBsD3gurLVH
	BGpEpqAZUMcSX86fBJhuY8WKH+VJxHU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772485495; a=rsa-sha256;
	cv=none;
	b=3J0T16Bi/GXqktGzdEelpAlUi+E5i4iYr9n0bZB1RKDX3uEYErm11NsdvuceSu9QDM7Goi
	CNDHVEIMBzdqSVDIFPGQA5qfJcDVOwbghMt2azoXN6qNrAQfQp5JcLRuhK+XSEEQp3N6lE
	8hx+ewHC5bLxiiMfwljSc2uVN4EjOYU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel-dk.20230601.gappssmtp.com header.s=20230601 header.b=pOHySUla;
	spf=pass (imf05.hostedemail.com: domain of axboe@kernel.dk designates 209.85.167.176 as permitted sender) smtp.mailfrom=axboe@kernel.dk;
	dmarc=none
Received: by mail-oi1-f176.google.com with SMTP id 5614622812f47-463a94f8475so4055626b6e.0
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 13:04:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1772485494; x=1773090294; darn=kvack.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=A+IPbqMq77bOpkXLRkjJ3UFsST92OHSHvZuEyO94T9Y=;
        b=pOHySUlaNPJQ6jVKZ0d8sax4NzA8UAQgOYJA1/N1mU22Xso/E+6VcdDRp4R6JmTT+d
         WtU7vAmBxuvgkm9JXOUwQSr998PPwHaIvgy7he5+RP9rHgWlE8WF5sRe2Lg1xj52zMfr
         zIwANK13dDoXNQQvygWEWs81jzvRXhYqqGUHhbgl7PQjvJAeA5qN7A4DYgWwvHSAwBby
         SxDxnhFHp12SQ1kII/EcTDAiPqNNfOWJJ1L5vHmdIOYsZzpWeLqU9yga80Ml07BxvxYc
         xcs/sks9W2/OcbvkeY3MJccdOM5pvj9IobQBF1J2Vj59GuISxwXo6cFElICgt1lDUMhZ
         kX6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772485494; x=1773090294;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=A+IPbqMq77bOpkXLRkjJ3UFsST92OHSHvZuEyO94T9Y=;
        b=GqPWhBRevs67WJ+3kXliy45NhCtL7t+J2AB2yPqhbh47VOnEX5cTKGGikxuAnuQ1Bd
         a45j+hwPpuMu1hYwZsjxiJQHC2VEXIt9LmkQS/TzfVB3E/fhrgcMtvBkw4qzYEq8Krf5
         1xuUI+Z0osmCZpa7HBvnh0xWPBmdZeVSKltYHjPMMCNuQ574yABps4vJULjJ+rsfDErm
         NwBb+ybs9TdKw8pDa3gAaQ+MDBdqnDcrV4EWIJFOSkLXczcPxfgYRhLCeAkKQuVpqpbF
         GnUqvY+2TTjzaXLWYmHAiOqH2WwCQFY0SOnEd6ByqSWhlS6B926g2YJjJz+ixdjUP8z8
         jnbw==
X-Forwarded-Encrypted: i=1; AJvYcCUMGV4Ke0m1Eri1NNhiyr43ASWLdwvpKQhp56fsviPaFeeSZsNJ5Y2I93ZDQaKZFvY6D0jP57Rkxw==@kvack.org
X-Gm-Message-State: AOJu0YwOV1Ss7WEhxfrr3JNzcNPTvTRLhwUGFgz72pY2dsHAv7/KVfdD
	gw95zmsh7qJOS6SVTv61C5bP9pWFvr7dq22FPFbG1X+IyFYEUY8/KStIEirUInMdPI4=
X-Gm-Gg: ATEYQzwnVTZQkbA9Bo63smkxEoOCptpY0YjS4zwtcKS7p7udwzjLRl2T1RnjPHimhs6
	R7SIQcJyz1JFjY7bI6blKuIpvMt8J9KhAR796WY5jWVtbK9nqiAxyGu3NPQbrE1T7x8qsODD3V+
	+4QbSjqq0bekTw3G0duCidAOMCItJEZSmNSUh0u8j+zuBqdXHlO63lIHQAsZfAmV/mLTNVTGj0F
	9WWNbP8mTk71UE9YQ/npbpvF+oQx3nAqLoRDfb4f7kaD2lOmzx6T09qDzZXYvAgjFvpxM9cv725
	EYygU323u/dfeGSN83yNOXgAZmMfAR6oknFE1HN43wMRF78XzvfY1C7FTF5FCZfCDLokS619eQc
	8l7seLVUyUZR3ifvvYaXfI2uklrBYZBIE8xv7GP3iebLTu3ne0l+tpjom2hXeyBaFnSrdxvcm9I
	D7nsNOa9b8Tl2g4mBigGXEJpsNUe8cQqS8WlgxRGVgA97MrlctM4p5SlqlQqk7EDDRUmO7OX4Rj
	/5T
X-Received: by 2002:a05:6808:16a2:b0:451:4d80:5ab1 with SMTP id 5614622812f47-464a5f0d5e0mr10177242b6e.33.1772485494483;
        Mon, 02 Mar 2026 13:04:54 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4160cff1aacsm12335332fac.9.2026.03.02.13.04.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 13:04:53 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: linux-block@vger.kernel.org, Song Liu <song@kernel.org>, 
 Yu Kuai <yukuai@fnnas.com>, linux-raid@vger.kernel.org, 
 "Martin K . Petersen" <martin.petersen@oracle.com>, 
 linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, 
 David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, 
 Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org, 
 Andreas Dilger <adilger.kernel@dilger.ca>, 
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, linux-mm@kvack.org, 
 Damien Le Moal <dlemoal@kernel.org>
In-Reply-To: <20260226075448.2229655-1-dlemoal@kernel.org>
References: <20260226075448.2229655-1-dlemoal@kernel.org>
Subject: Re: [PATCH] block: remove bdev_nonrot()
Message-Id: <177248549254.151113.14982963467044589269.b4-ty@kernel.dk>
Date: Mon, 02 Mar 2026 14:04:52 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: AF21110001B
X-Stat-Signature: yo753qg33nq5bm74roze5hmiix1kac4h
X-Rspam-User: 
X-HE-Tag: 1772485495-666281
X-HE-Meta: U2FsdGVkX1+cnYeMmHl/oC2bVF9Pt/LNJP7EkCquIogl9kQ+VaV6M+rhUO5zGoW0u/ADUMwqnttKDQYd08ISfqepOfTO3yQ0+nt/m9EFJEgnauVqHocYJ0/IyBfodl8pqyhiyYMzTDawFxqCDnzV8NeWu8AH+wV09fpjbWUi9+eVCE3o+mC/W0uimpOd0H7yy9Sv/mES/BvJ8aXxrJHq/Zx0Lr//eLsCq86Pgp9G069u8am0Gj4yj7fVEZfSPvAKlQjdc1VbQSzXZps7scYGZkbD2jz1WTrnK0C7bSGD/aUojjXFqLgWALRjGMbDnjqa916Zw+eTyM8LmlCeaQKBi5FqutI8kJ5p9to3cEvex8V1qsGYLq5YrUDnSDSC7JNjR9hmv42VRymPjMuH05rbmvNMQxQpmpx93NZ8B2IRTrhkUi5kUe+qypZGs6UEyGWHJ0VP/RMZmW/6yQhUh1mDzN0BujfHMGUNw2JQNS4MRPYAGxG0Zf02BcXIASzV+Vc6K92xnE1nahuVAS2Bkosg4KsjujBkQtCsujG9wPgImcfI+tp04yq4cBA+6em9epdCQAOtxOUI+P5JpTtVX+2cs3Auuhu+IUjMa3EggliY7n/nUiPf6YxM/dEFMyS/0sLbcw7tPFG24EUS0d8LTj73+S7bbftOKZebJEfZztRCixjuHfQRqabAZOvV/Kdt4X1/LX5EwUz0rWQ0m7+iyarguf9eeY7sWcCfG4DPC66DbmVnHOjOzHWoFlweK4VA4s9XwfoLueHiFzwSLubwT60/gvqiY5zTPA+AMQDW0DJbCrd5rM769V3rxRP81ZjfM+2ibDU8165KRztXVsQ9gzWYE/mLG8ZAhDNoMjsSDtIAbmPU+IGUtaAwVirNQ0o2CLNA0owXtGQHJzpbZhH6XTprNZef5fFE8Z7FHYJqruzlm61a1RjFf4sM33C0fK817fZ5fsSvazBVTM030+QS+Tk
 wKdQqrw/
 qQ4nqjmvcvjK16mQW/WQQkPaSA/qNPXEo0Mxg9D4uVA9E25nmbfa8WhMdi0/ZkV57YRPBbmI10UodOY8nbXKlhNX8pcNIbMSszLBAOgAFTiFc0THxtF1vhvRdZQh4yaN8+07zfTZYGeCYe8Sgf8qj9XEuB0izTpA7gO9nVmyGm0LxylQMcqRjiOMdgW6H/XBcoPTd3zkyEpNu7XmaGoL+au3qi1Wbkb0KOIdUqotv8xCYsZyf9mftNAgoS4uHFbJ1qA7P/MxECJQrnYhv1WuB5nC9hjssCYcY6y/5zy5m5nxKt9Jer1ks5iQIQ6wUO5ghbWpemZqJ1oX4l0OGldYALjx3ZgLk98GpP5CAbbQkwRNGmm53NlJ1Pl0xv9AYgNZYXpO1mHnnmOrMTuLqQZgH7ZF1aHadAkpL1ldoadXUUUkPc0FRmmmOJSpFniQTnEDXbeIOqEVvTrGsMgSkq5stcrxqLDrfWWM0lkck
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Thu, 26 Feb 2026 16:54:48 +0900, Damien Le Moal wrote:
> bdev_nonrot() is simply the negative return value of bdev_rot().
> So replace all call sites of bdev_nonrot() with calls to bdev_rot()
> and remove bdev_nonrot().
> 
> 

Applied, thanks!

[1/1] block: remove bdev_nonrot()
      commit: d47f7c173262bbeb09645ec72bf91755eed6b1b3

Best regards,
-- 
Jens Axboe




