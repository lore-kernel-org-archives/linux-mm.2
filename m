Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 925D7CA0FE7
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 17:13:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C61958E005A; Mon, 25 Aug 2025 13:12:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C12678E0038; Mon, 25 Aug 2025 13:12:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B27D08E005A; Mon, 25 Aug 2025 13:12:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A16B18E0038
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 13:12:59 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1A450842B4
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 17:12:59 +0000 (UTC)
X-FDA: 83815924878.07.5355D6D
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4369980010
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 17:12:57 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IFysLxOe;
	spf=pass (imf30.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756141977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OI8ePd7/wKrk/VZQzSRc6TFVQyV9wSort1fWHyPMQ3o=;
	b=5EsuUze2GIlgzccTXKl51pACL08GdySnWd2jAW2yf9PvZhngHczD4bZioKzTQRoDoehb8d
	uO+wUBfVkN90otU9fKAWMpr8wqFQXG7Yejwl1o5UhrTnb3vnn0J1E2v9DujqPh8Piaj7Vx
	4PCGpW0cGprwxzYWM0nLO6v/hXt0Kcc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IFysLxOe;
	spf=pass (imf30.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756141977; a=rsa-sha256;
	cv=none;
	b=EGnGLOm8gXNcmLrpWYAWZDScqjf//nsjprofeO4BGHu4RMLTSs+BKapM0z7xvUeEwNIvE8
	cmbJ/M3Ixxi6L9QqfYUgbWqTJp4BDld1I+LL7DCg+VXg784hd7D1xDj4W4spF6CiQzk2Qy
	8vRRkQO1LIOL9s+DETIJKiq9JP+FTOE=
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-71d71bcac45so37901867b3.0
        for <linux-mm@kvack.org>; Mon, 25 Aug 2025 10:12:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756141976; x=1756746776; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OI8ePd7/wKrk/VZQzSRc6TFVQyV9wSort1fWHyPMQ3o=;
        b=IFysLxOekoiPpZ+EsjOcvvm+/tJOI1XYM+b+jHAvANpjaYK4xjWg7olzNyhLRdFeNB
         HAiASifuMINB1C2fD+99wrCYgH80v/E8Au4sRdXr0REk3i4QBhsgjXtEyfcolzCLj8fa
         2qb2nw4h87EIAxrIcsSw3ed5ErsXa5bodeVGuBNfHI+t0AJDJQ8cXlgF3Vr6vyza6hvw
         mEWzeok9hLFTAGaVxrUfgKCs+6SfbQxwupdTfaRmtMSBXBPX+ry0EP9VqoQpPA8/xKdU
         JJTSz/2RdDw44iA0GWdu8F5JduBfUKYvWDjmPUh5ItLEGz1nt9G9tkyx77Iknm5m6ASw
         qatw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756141976; x=1756746776;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OI8ePd7/wKrk/VZQzSRc6TFVQyV9wSort1fWHyPMQ3o=;
        b=hvM+XU9knrvBjKgBppepIpfw3JFuFnAh62ostXlUI7bsTPorNLEwiBKc1dhSsezkt9
         DOxZLCX7xYfYisha1xcEa20oncsovzylYv2JeszKERomijkpcBxkVZlfrObe3Ityu3c6
         J47Zvxq+XfeK5Bw6XjqlRz4mo0MlKt4Lg8u7FVa3hh6HfWV+qYs9be6PfOnosuqEM88f
         RjzhqHoNLmrQwq8AtMOMpht9/QIzqlt+7mU/DQoB9mKBDiH84LeO03KsDRPgrInDiUT3
         iLOw4LbQP8yIRABNNKA72/B0rAQMo7bEdjxx431AXa3fxEfBE9gZzCWr13kNKdI2PO5I
         TEwQ==
X-Forwarded-Encrypted: i=1; AJvYcCWaTto92OBr3cs8qrNtRgvFJPYgdhHc6IIcqnv6DWw1e3xF9cPPgUvRgyrJRdOq+tfBay/H7oMHyA==@kvack.org
X-Gm-Message-State: AOJu0Ywwn90L4tuMKFM0Xc957P+tQdWA94FPol941qyp8LsP6O0oPW1W
	ytcOP2h7QqEpyiG3xXe87PquIrdlukgTmgbZLhPvF1MguNJQMtBY8S7k
X-Gm-Gg: ASbGncsVyTgoEQe12c/DALsV8c6clIN37ylL7G2BTaCGf9cvye44AkIEbCew8JuQfPY
	aF0fZXxglwZ8v/YSymijS3hwLRJR/tlP1J/Gs4bFJKhVQo3nFphfZDczsLY0KjJ6gSAHXf2XbQH
	+wbtK7CKWlMjmqlSwv6ttYwY6tXLPWLlwNEi0Y6MUB/wcKMfWPNvvozPoqM/Oe5itph16WIkGQ5
	1UrQ+59z9ekBY9rx9cPpOJNQeEcumiVAIFyZ8+Xq9ZTjIs44eeRi24ZGzn5Jkpf4mlk2RkoT3HL
	nOfJK+pdrBLmF+DELvr0oI+K3Wlvbj8MP4v2ZDIXudGGUbGrn9qCRirQGSROqsCnNcrxgSFgEL5
	PSPPwiEsN4UxZ7DR+Txy69REpZHKPC9dR5b/E3UBSymj9iAB6+IuGqQ==
X-Google-Smtp-Source: AGHT+IEyMx/+POVFy3nvyaoGhbSSuohPwjNy61C/fbbRZEpp90mhH3T3/7m4UbJraYSe8qunKF0+Og==
X-Received: by 2002:a05:690c:60c5:b0:71c:3fde:31b6 with SMTP id 00721157ae682-71fdc3d153cmr127223487b3.34.1756141975952;
        Mon, 25 Aug 2025 10:12:55 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:48::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-71ffd8ef450sm14755897b3.71.2025.08.25.10.12.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Aug 2025 10:12:55 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: vbabka@suse.cz,
	akpm@linux-foundation.org,
	cl@gentwo.org,
	rientjes@google.com,
	roman.gushchin@linux.dev,
	harry.yoo@oracle.com,
	glittao@gmail.com,
	jserv@ccns.ncku.edu.tw,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/slub: Fix cmp_loc_by_count() to return 0 when counts are equal
Date: Mon, 25 Aug 2025 10:12:52 -0700
Message-ID: <20250825171254.701321-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <aKyM4jZqy8/G2DGq@visitorckw-System-Product-Name>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6m77kkeacxoqmftx4z5k4tres6pxuk3c
X-Rspam-User: 
X-Rspamd-Queue-Id: 4369980010
X-Rspamd-Server: rspam01
X-HE-Tag: 1756141977-281509
X-HE-Meta: U2FsdGVkX19zlOY/iUgw5PtsL9X2quC3PMpd2o7/QKIQJ6TQ4akttid72vkO0+HhmydmWM1uq4W+0j9cQ3g4p424gT38hhsz8RKKmt3Tjog6kUlU3a7awxdBp8iJ/JYwNpK5kss+ZPFU8f4KwKtS46WscMWoFqtwEUmdrZYg86iLQv+lXkaI5ijysWckaAsqA/NifIZnR5fQUXXujsBH9lRc9h5G6a3cTQbeOoKjT4kZh8TBuGJDYjmpLW5cNZ+ux4JZRZqj4ql+jv55esayLjjC6jXQldU7qV3MbOH4gLuJ81qVEr9UcOQ/jjDItQULOfRwx5OPCuEaX0uNLrJ5MlVd8KZcN/0nM0cub4XGDXlIPD6MWD5ZpuyJUnsKbDC4AS3ulpSCqYmpa6/kraqmV9RPV8B+r/j6iU5LMp2XpSkz932y8ROJ6eWsK3x55h6Zs9+58SNxB6SFdh/OJza/iApzlMuiz+NSFfVNLVGnLUtYsZ8dACRZ2pJKnV+fOGs8UPsqJM+3rtQG08EX6zojdvQO7RxhHKZal5oR8O5hGu2TszjWcDW0CFDGsDrynxwp2deMwfiM+yKuyNf6WF3itY2ndW+LTBEQuQn2EVe+ASn6fcYN/elgzENGcv3BP3tClX/9G2XY+2EvW8jV+cP0ItL9jXf9qkhn98eMbqnKqM0rZRTAIWL3tUKdEw2UI5zEryGEtx3ov6O0fJKud5NlO5Wt1nSqZo1lkYJeilx6dKniMqisGvBFjcwrQy8CWnGsHvpwrU03sOMh2ekePjq4PH/6DfhPmpi/rykr+1QDlRvH60SqPKSW6REkjPHN7289jBczhka255ncFO7aqMUQBlgvridAdkUDu38Ub6Thl3wh0fqrA4eOLlJeoq78mu8KzZO7AfzacdSPrDq79vs7z2RwOeljqIM/kMaZYAlneL16HRjNg0Q2ZocBIBu7vnLXDBEtSNKgVuwkq1AhI//
 zciri19Y
 Romx2KnpZ0eris0ZPGckmBASRPlfpZGHyMbLShTlJyIxD6xmzZmLGRAlParXtATwlpGlFGKnv54CgQAQAdngdmJ98yM3wdV8TwaVISciGKMIJmZi5gTpdA+s8Wmtyf8PUT8Y9hbmDxxnJCbe/zYdaUPZ6ld5u53gey9Vu4/NgPrGj+UDT0wEO9A+z6tqCHkrYrPqG/iN3xLdt7fwSEq7SVjza9nevweeC9COzvxovf9fO7dw7mAPnYr9wirdR95recz8RXCr24U3fCqo6PCQno/lnm6+D42TPa3nHe+pfXGWePJmPNwF/kDshccxI3Q0/H+UOIczJL3Jo/vdxynaPfFLHchZzQ2tKqBF7RPY671P0gD6j/rZN+E32wU2H4zs/jAqVPzTROAoSKxBBxuR3PwK38/44GnIcNkH3OUsuEiPn3yjN4ocRIZxrX9rHzS6i9p1ecWOYWnaW+R7kNAfTqiMbdB2YrUzmkMXBqJHHEAo5UKBe3KkHiFo5DwIWcBUshXrzDtOI/NdJlZVIhZc1qGk0ryRK9yvswyw9JLnPztLgwPMVk/yvvLEgiT837LtqZtv8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 26 Aug 2025 00:18:42 +0800 Kuan-Wei Chiu <visitorckw@gmail.com> wrote:

> Hi Joshua,
> 
> On Mon, Aug 25, 2025 at 07:48:36AM -0700, Joshua Hahn wrote:
> > On Mon, 25 Aug 2025 09:34:18 +0800 Kuan-Wei Chiu <visitorckw@gmail.com> wrote:
> > 
> > > The comparison function cmp_loc_by_count() used for sorting stack trace
> > > locations in debugfs currently returns -1 if a->count > b->count and 1
> > > otherwise. This breaks the antisymmetry property required by sort(),
> > > because when two counts are equal, both cmp(a, b) and cmp(b, a) return
> > > 1.
> > > 
> > > This can lead to undefined or incorrect ordering results. Fix it by
> > > explicitly returning 0 when the counts are equal, ensuring that the
> > > comparison function follows the expected mathematical properties.
> > > 
> > > Fixes: 553c0369b3e1 ("mm/slub: sort debugfs output by frequency of stack traces")
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
> > > ---
> > >  mm/slub.c | 3 ++-
> > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/mm/slub.c b/mm/slub.c
> > > index 30003763d224..c91b3744adbc 100644
> > > --- a/mm/slub.c
> > > +++ b/mm/slub.c
> > > @@ -7718,8 +7718,9 @@ static int cmp_loc_by_count(const void *a, const void *b, const void *data)
> > >  
> > >  	if (loc1->count > loc2->count)
> > >  		return -1;
> > > -	else
> > > +	if (loc1->count < loc2->count)
> > >  		return 1;
> > > +	return 0;
> > >  }
> > 
> > Hello Kuan-Wei,
> > 
> > This is a great catch! I was thinking that in addition to separating out the
> > == case, we can also simplify the behavior by just opting to use the
> > cmp_int macro, which is defined in the <linux/sort.h> header, which is
> > already included in mm/slub.c. For the description, we have:
> > 
> >  * Return: 1 if the left argument is greater than the right one; 0 if the
> >  * arguments are equal; -1 if the left argument is less than the right one.
> > 
> > So in this case, we can replace the entire code block above with:
> > 
> > return cmp_int(loc2->count, loc1->count);
> > 
> > or
> > 
> > return -1 * cmp_int(loc1->count, loc2->count);
> > 
> > if you prefer to keep the position of loc1 and loc2. I guess we do lose
> > some interpretability of what -1 and 1 would refer to here, but I think
> > a comment should be able to take care of that.
> > 
> > Please let me know what you think. I hope you have a great day!
> > Joshua
> 
> Thanks for the suggestion!
> If we're going with the cmp_int() macro, I personally prefer
> return cmp_int(loc2->count, loc1->count);

Makes sense with me, please feel free to add my reviewed-by tag as well!
Have a great day!
Joshua

Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>

