Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D1CBCAC592
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 15:07:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEC9D8E001C; Mon, 15 Sep 2025 11:07:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC42A8E0001; Mon, 15 Sep 2025 11:07:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C01B38E001C; Mon, 15 Sep 2025 11:07:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AF8578E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 11:07:07 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 66A74BA207
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 15:07:07 +0000 (UTC)
X-FDA: 83891812494.24.309757D
Received: from mail-yx1-f54.google.com (mail-yx1-f54.google.com [74.125.224.54])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6F449A000A
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 15:07:05 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gOecaxZd;
	spf=pass (imf25.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.54 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757948825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nDVeU4L3YG1TiJ1MEpll75Z/ltEov2CndLJiRR2rTQE=;
	b=M03+xo2CoEcCdgvqv1/wFF4tXhqMEOcv+3OSRdGeaAWY44jQ5TmZu90RRFWp81BVdVg07Z
	90JKO8zXkxV5p2O8lA84wN0mqw3B73QgMdV5Z9C3p331h6dpHKqBGO4WhPPDhIugZIuDHn
	Q/m+nVgaHxIlBrWLUD+6I9baklPqOP8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gOecaxZd;
	spf=pass (imf25.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.54 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757948825; a=rsa-sha256;
	cv=none;
	b=D1gSu9ORgIfsTQO3s435L34NwwPScDITITbLXDK5nalW2EEYY1FruYLxgIyA327yihQrE6
	WktdYDru4yCMyJWHjTf80nuZuAW976ZlAacHHHK/iOCOuyVhExPhMvcvks+KFY7zgO2Jyf
	FYrsQcTfEufTtU9XWDU7VBRgj63vZ6A=
Received: by mail-yx1-f54.google.com with SMTP id 956f58d0204a3-62f9c2df5a3so572906d50.1
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 08:07:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757948824; x=1758553624; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nDVeU4L3YG1TiJ1MEpll75Z/ltEov2CndLJiRR2rTQE=;
        b=gOecaxZdRBG85GtWuu4OK4Y4d8lgtekwpmCEuw8gtBGPNdgcS48euYlh/YNh+E6tJc
         wrY7b/Rv90Ip33BTMzydeJWqfrJkbCAedEIrEbCnrrpwaRWyvZTaFhotOJUCWzTjDkFl
         wlDg7WK9HRfZH2YtD1D/Vj1N2X6/Shk3dmHoa3tpzcO3PGSQNNnJ6MvYEpF7V70TDjNf
         joaN+Q7kb6GPG8GjehB5zcmQxmay8pPlwFl9xpz8ynkqdRM+VbI5yMCU0TG3mbHo+46L
         K4A6/+jmnE1WRNM3m3FjqxCoktnmNB49XDzd+ek7Fd0a0WZH5sGgQpocWLCgEmr8YYyD
         jM9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757948824; x=1758553624;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nDVeU4L3YG1TiJ1MEpll75Z/ltEov2CndLJiRR2rTQE=;
        b=bpgEdCVwlNS09wYI9NcEYH3bjr9FYYAIyhDbgM+IV8IUW7dgQFt1HkbTusUCGuoEpi
         O08j7qHQBwvQ92Q/RBJ+F5PvG1SlOkwpzL3U5VrSXqhmgSKkP7VzhCszhsyLvM0/5Kll
         0REqkX5V4u29bGM+YlwENBRCztMPDYmN5I3D4DWZsEjBTpnSpNWyqi4CGCE7KRms6bLI
         9YrGJb/H30kV/JszuSQ/MHBrrLm4aCY4M5BaAVCtGtcEFuYiIw0UTI4dDK6pdPA2Z02k
         yLUWSG2io+BLeb1Goe7JbFsBeMUk2IyMjxCLDlwrf09w2AbR5Hsh0tn+OiFR/FZ3pIPC
         8g6A==
X-Forwarded-Encrypted: i=1; AJvYcCU78IIegWNEIQfeckDHq64TZ0SHMi1QRkZv2aRXh3sypagISCkBJcewWyqTAu8r5yNYaelMuxNcZg==@kvack.org
X-Gm-Message-State: AOJu0YzMsqbz/1NnFoBUQHxCVeiwbQu0V2mM3eUOIAe5B0UvpwJJS4hI
	VC5R+4gDCdwVHKYdFLLGyXdES5FP4OPWJ2vL0IV5MVGAhw6Y74Hzll5R
X-Gm-Gg: ASbGncu7X7oRbENEkPxN/IRjeLXwW3yUZKlELNbsPsFFKRrM74TOW+Bfbadvjha2LXj
	h+Sydxv8MR5Cyu0dCEaSNuqVe2YCEXrelQVUH+c81dSlUkYQrWyWeJRzFMGKK+B2caf31HDJhc6
	YmAM/jrpe8WAwERdOKlYOHwInhkugNfRTUN/YCYbhJCcQcBBK9Zlfa6j/SClsbYCNscAriWPX0n
	HerRD1qqqapPdQUWTD88DbceyBCaTH3Xz+HN5Cuk3f9Xb06uMtXJpfNmMLhnRHKoarvmysYvWhQ
	KLlmA2YxRki/23lFdgdZNcgGJ7UaHGByChsfyPaN4zQDdXe82Z+EI8yqDqrVb9lO1zmbOIRYiN6
	v/jGephgQtxhshbRlKJZkQTU/D+aeHJXWUdhzxkk4zU30+ECK2rKh10T1NMgwk3n0
X-Google-Smtp-Source: AGHT+IH7pt4IX2Xw7+CU3ZHlHQK6hR4lJhRz8r+4QNMMkKKZ9nkGgDixZer0GbSaS8MxEPVoUip+3w==
X-Received: by 2002:a05:690c:3388:b0:721:5b31:54be with SMTP id 00721157ae682-730650e0036mr114848797b3.39.1757948824149;
        Mon, 15 Sep 2025 08:07:04 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:5c::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-72f76238392sm32913737b3.1.2025.09.15.08.07.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Sep 2025 08:07:03 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	David Hildenbrand <david@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 4/6] Docs/mm/damon/maintainer-profile: update community meetup for reservation requirements
Date: Mon, 15 Sep 2025 08:07:01 -0700
Message-ID: <20250915150702.1499965-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250915015807.101505-5-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6F449A000A
X-Stat-Signature: edwdg7x6j9j1gqp9yw7mibu54o6ewoax
X-HE-Tag: 1757948825-455912
X-HE-Meta: U2FsdGVkX1/lFOSaXc4W/kZwKHULZ3sYdm0Im5UddCYBnblKamhh46b2C3WYs19oveRfkaHrmKRAozQQO7bhP9okO+KDMSpC+0D9tM2nB+wbwbIrRYVOZXp8jOk/c0Y4YXHJUPWkE7hSnjwBCi4+VmVkAXYuOjf2e87XC832dsxTXdJlsABGH3O+ZkEc1r7Xcx9IgOlSQGMnBw6t2gTMmRcC6s4PTRNY6AMnYi0S4DwuG1AABtP0068Z0/P4q5QYS1vy37ZXTyLb7UVYaKYJMv2sVCjy1jph9KRuLp/KAxu1eXVXF+pybVdtuqs7FlpSGPE45TidfAtAwZA4CwXdNu8hhQwP+r9xaQsFARlZLA2Q7IVv88yCqu7r2k/nM20dwCmg5qQSFCi143ewMV1vdxWpEIrX6tN9/89bA8jXyFMsbJBeQ8QU9lvDAQNgiwOkndRBEhir0qVfuWVeU/PY+erisv9CS1Oxpu5km3mboO7SPnrKRXj6vPctjY0Jg37idXHtxp+Vh7olSXYFXVWpmeKl9SvcPu3JvvDi5siMW+j6bmR3GYdQKYjP8NynxmNGnkdF5F5jCnDUn2xJTKf755lTqIy4c+BE/Ed9tOnOYXaXqHer7HkOFtuyuPjU9RWXWIcA/YWMafeoyoVgPGe6R+y4aS7eUEAq2cmjbbUyXDbfkEhdQymjb0+OtfVPa7KrC3v35/DSjxl/iAMXhEQTSz9wnaEWk3qeyF+VQiJDWQwse0wmgriVKvBQQfl26fwHb2Y3D2ENgczKGyn+qVJAxODIfULgnjh2x5z9gtI7mx/cXFLQO6LYbmfaz5JOUz6DdZhyMtUqwYoWX8t5xRXcV0TbfpP3OzV3duIziuo94W9waHOO4iXtqUiADIhPicnFkPi6y9XeP1sASeYbuRkHk4qUNrXIAG5kMasXeJQGIae7P73PiVL6h+LsK7B4RSrTTXOUPnplBauld6SEvW6
 sskJNVB0
 zoZuJF5ubZsexWrlRFzfI59RJqb1W92voyc4jUMVf2pZzSz39ry+r7YB5N2RasZJAmYL72QP8s+i+ejjnNhRwdKSKep/T6AlCpEyLt2fB0pBDjWoD2PTL0qMxpmPEzT8fmaXHk0BWiDViMwxbrl8pw7XdcosLCNxoqjwZSZ9X7MzDDRILBQI9WK0OJCH3IsshxnxGg43bloUdIcENxpI0PqSqgwiRy9vVvRSHsXdSBoxEBc/RRBDUeTEW5tVO9Gs/ks8+2wmWgKaAOD9GBNPFBARI3PEvZGUtwcoXSgjWVlxZjhrPhr95ftJd72IXWYpPTc6wz66kvaaNwqHCbTE1nl/W7OSlXZ7i1XzmeWq1hGPGA1GmrlMI2SBtHoE88JhciGG0UfhEggW4/ltiY4Sn74zCC/IKZI2WlO7iNzj7kCBXP4WBnmH1c06Ro5ZF7jhuT323fsj2BlX23Y6TOlFnwztwZhhzv3VK5olbSp0smX2bv1/aJXt6s6fY7Zr2oN1OqVGhtmv0TYO3+98253lDyIsd8QPrrjTX3LXbIKZPmYtzr1M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 14 Sep 2025 18:58:05 -0700 SeongJae Park <sj@kernel.org> wrote:

> DAMON community meetup was having two different kinds of meetups:
> reservation required ones and unrequired ones.  Now the reservation
> unrequested one is gone, but the documentation on the maintainer-profile
> is not updated.  Update.

LGTM!
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>

> Signed-off-by: SeongJae Park <sj@kernel.org>
> ---
>  Documentation/mm/damon/maintainer-profile.rst | 17 ++++++-----------
>  1 file changed, 6 insertions(+), 11 deletions(-)
> 
> diff --git a/Documentation/mm/damon/maintainer-profile.rst b/Documentation/mm/damon/maintainer-profile.rst
> index 5cd07905a193..58a3fb3c5762 100644
> --- a/Documentation/mm/damon/maintainer-profile.rst
> +++ b/Documentation/mm/damon/maintainer-profile.rst
> @@ -89,18 +89,13 @@ the maintainer.
>  Community meetup
>  ----------------
>  
> -DAMON community is maintaining two bi-weekly meetup series for community
> -members who prefer synchronous conversations over mails.
> +DAMON community has a bi-weekly meetup series for members who prefer
> +synchronous conversations over mails.  It is for discussions on specific topics
> +between a group of members including the maintainer.  The maintainer shares the
> +available time slots, and attendees should reserve one of those at least 24
> +hours before the time slot, by reaching out to the maintainer.
>  
> -The first one is for any discussion between every community member.  No
> -reservation is needed.
> -
> -The seconds one is for discussions on specific topics between restricted
> -members including the maintainer.  The maintainer shares the available time
> -slots, and attendees should reserve one of those at least 24 hours before the
> -time slot, by reaching out to the maintainer.
> -
> -Schedules and available reservation time slots are available at the Google `doc
> +Schedules and reservation status are available at the Google `doc
>  <https://docs.google.com/document/d/1v43Kcj3ly4CYqmAkMaZzLiM2GEnWfgdGbZAH3mi2vpM/edit?usp=sharing>`_.
>  There is also a public Google `calendar
>  <https://calendar.google.com/calendar/u/0?cid=ZDIwOTA4YTMxNjc2MDQ3NTIyMmUzYTM5ZmQyM2U4NDA0ZGIwZjBiYmJlZGQxNDM0MmY4ZTRjOTE0NjdhZDRiY0Bncm91cC5jYWxlbmRhci5nb29nbGUuY29t>`_
> -- 
> 2.39.5

Sent using hkml (https://github.com/sjp38/hackermail)

