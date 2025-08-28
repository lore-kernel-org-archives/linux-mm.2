Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BA51CA0FF2
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 04:17:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF0C38E0003; Thu, 28 Aug 2025 00:17:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC8B38E0001; Thu, 28 Aug 2025 00:17:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B04AB8E0003; Thu, 28 Aug 2025 00:17:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9E49F8E0001
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 00:17:08 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 46ED913A435
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 04:17:08 +0000 (UTC)
X-FDA: 83824856136.23.88F8138
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5E77C1C000B
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 04:17:06 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ITR68g3F;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of cmllamas@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=cmllamas@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756354626; a=rsa-sha256;
	cv=none;
	b=2zOaEfd7a2hWQOgW/NBmhqnD/aJxhiDzRRKkS4jejB+c+L8Td3vgblRNxpwvGZsyKjzmBx
	uT6mrdnv/qYu3KnLeR9L8swWZkD1UW3ORzoYgF2n+l9V/N9Lm5TzWzotmK7MOutsTxuMMW
	+7Jrayxw4vg43fgCQHg/aC29QtMdpQY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ITR68g3F;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of cmllamas@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=cmllamas@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756354626;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TMQVn8CrO16DsNUEv8ZI780aElTyTlwevDHE/l6d5V8=;
	b=his4C1giJjp1NBqgjFS4vH2yvYbmwDiaAe1+i68fy6na5wjGksa+VJgjI0IAI8q/mnXlaL
	2u3qPD2V04bL1t0YbxoP3pdPBaCy8NpuJJgRluXLwy2oAmRaydvBnWotK9uFYn48aYaiJx
	ebWot+basrzT7cTDAz+lv8aIoAadd2Y=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-248681b5892so105815ad.0
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 21:17:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756354625; x=1756959425; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TMQVn8CrO16DsNUEv8ZI780aElTyTlwevDHE/l6d5V8=;
        b=ITR68g3FT5uqsvV4Jgg5ZDZvco0BeVdgPSxy5a5VlIEak+xF7t2lM1YwMvv/9eyQPs
         peKmgjKEnaYqusJ0byUYWYXqWxfaFdf9iEANm46DpOuWRh2sxna8EaaWMzTOToye8zhz
         17QxV+JIvjS86EC45T+eDrIV8iVeIPmKO7zDKfVoNacqG2H+gFbOMtdmf64HsYeOruf9
         zkgkC3IUPLJFAnpUZNjL8Z82kU1+tCfsoCDn9U3N2jl8uYJpexxAlBmcc8HaxSFIuy8a
         iMITcygSAA+ODnyPKoqmkg/x6nJbwjUjGjoVAnV4izdNNxRPXrUvOA3dpFhddFmF60fO
         3BZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756354625; x=1756959425;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TMQVn8CrO16DsNUEv8ZI780aElTyTlwevDHE/l6d5V8=;
        b=ZKMii5JWith/b63FhzBONd2dgSSyAWAcNNJE61Q2RMUWfwADkbxXeafVlbtycTyOJr
         Q2HkEWn5gquN8OPCmBp7z7DIIjBNoEFKL9ak0cggbt4F/wpX1RbhH1Okf1Q+A+mklE7/
         kCDd66V+J7BR77X/bstrvpoWsdWS3kA3dR6WfvThANxGHPL9cmck1DAyNb/oAuTFNX2h
         hxBch/s7ANDc7Pju7psfLm4Et8q+RMsdj4Y+stDM+K4+iaqlM3XShzzOfkUcpZOCk4BH
         co+ZFv6Elasgx3SejUfqX3xomU42n4ldWpCSbwcEsaQmi883cbpbRI0bkaSsnl2/tMKc
         E5sg==
X-Forwarded-Encrypted: i=1; AJvYcCWGEiYWXbKN0DLu7nMQ43L+qzS8t4afHnHWcwenSGQIFM4hmtS3sSfvWQ/Dx343zd5KVI830iNhAA==@kvack.org
X-Gm-Message-State: AOJu0YwPtCEbmX8rfpFKODkA+hHP48Mhbc01QwjJN8g5eEkaYMku9m3I
	ONU+H4ZiDNkyZd/YFlLKohWrM/X0iSL/h22kh+zAJJ3ghkIuosE2vxfI0QZrBMVjlg==
X-Gm-Gg: ASbGncvHxlls6cH/xql9P0HcFj2b2uaHRJ9WqOsL0z1rmt+fYxoRYCbLl0gkD0Jyall
	nwhkI+EAwazcR3HzTegwoIXWSVS2TQYLgaT0g25y7ok/WVMR0K9qWjMIXXQV8W6vLGEya1bCpHY
	VGUm3Hr1kOvgTcCOYOQIuo0LzOpi9CI8KJLh7YI1FG2ECNJwJNNrHBwzTTHAjKLkBC90GBurOZe
	n8nnUmf3TkcAnUKcMxDpKEiKtLmhZ54Fy5MSC0RReT/VDQAcnTxQ0QeWjxJGzYF8pvbhgFeYybJ
	pFIGGeIgrq8a4Kn6MODZ/wp4r9uK8ZvMRSWBJQfoc6LY0p8qi0GjP0SHLw9FzF/sdIIqUT9P7VS
	HoDTzBZoruGqsaGq4RvfLWu440gXNZVZMbzHF0ekRmAWjhMqdMYnLskR7dvrTZw==
X-Google-Smtp-Source: AGHT+IEScvfgJtRVasw57V/0vxqTUB7x4SvVvb5MS9koK0iAGjVijb4Cn9+NhLOy8EhFZ2odTZwOvw==
X-Received: by 2002:a17:903:1ce:b0:248:84b0:3fa7 with SMTP id d9443c01a7336-24884b054ccmr9171285ad.3.1756354624980;
        Wed, 27 Aug 2025 21:17:04 -0700 (PDT)
Received: from google.com (3.32.125.34.bc.googleusercontent.com. [34.125.32.3])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-24668864426sm136937785ad.80.2025.08.27.21.17.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Aug 2025 21:17:04 -0700 (PDT)
Date: Thu, 28 Aug 2025 04:16:59 +0000
From: Carlos Llamas <cmllamas@google.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>, kernel-team@android.com,
	linux-kernel@vger.kernel.org,
	"open list:MEMORY MAPPING" <linux-mm@kvack.org>
Subject: Re: [PATCH] mm/mremap: fix regression in vrm->new_addr check
Message-ID: <aK_YO90AEgow_iQt@google.com>
References: <20250828032653.521314-1-cmllamas@google.com>
 <xpxoxn25fzhahdyvjp2vgmcnek6oot2hhvb5niz3tw7au46eno@cixyid6ywf27>
 <aK_V4sOUOIpEhFC-@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aK_V4sOUOIpEhFC-@google.com>
X-Rspamd-Queue-Id: 5E77C1C000B
X-Stat-Signature: un8xjj4h15ob3c8sqqterpoy4rdk61xn
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756354626-901941
X-HE-Meta: U2FsdGVkX1+o0u3iZqJZmYT6T1B9p8t9WzhyBKYMTHRFC/KJRuImzTRjg2alpXLKorLJhfwaTfUam+cOFTkrnydkFqJFJO3axbC5EOMjFuiQJ6US6nLRUZpelixKh+KqWbjuyR4OWUawj4MJoNiiY6jQotYO7PmKBgMq5gepbOyNzhQcMazBaOuM9hSQiuCIXoxvqUNkHqbzXV8ZxXiZkuOSeF8p6d0eKpF4lA7n9TpEBZI3iv6j4MQ6OVhQuAfEemEyKdMR4MtLLjcXdZa1LzD3HNxBUyCeJOt3C1RvWwP+l6+nBLBqai1f7ZBYSs6Pn8ZGzByxE3+ivyFCOzKQInGbs4/8wyz64Z5WdXZ2zs3gDumPD9ATsfd2uejaMIoptjx50fkxqatgsJBQT3qmyENENKfcpueluXtHWDBGT+MtO5WxzTECoFrPXbX4JVMLQ7cOuNUxQP8CxkwxCY/9silnWYwQGj9p5il5qGZOT336oP5+QVuQ7CohUMqccDB0S6YYg41vOey8lvwoKPC+lwisVB0I9Ss0v3rCYFW9/PUJAH1qvhLWZVRDwYzZS9L67vOVEDTUVRt6Sj5AORON0zjF0CE29NolQC7eIeB7ySL4GzMy6Dde5UAHfrrtij2dCqDxHUkBmLyMmU+BkfJpIuumblkrca6rEtwMAGYsJxjG+7+SkJ6azv7+2ry55qc8FeTqjvEnbPocaTAdgOytGMfFYu3ADsRIMYxJewPCpNoNQM2gg/XKK/lh5o1XrEdkNxUgkU0WT66K9w+8jQDeU1QJNm3HTYCH1yzDzFgjHSA8xqTa2LgkssDOybPs+afJcoT31S84T7EXtkK+sh5FHsyUfoKJTF5OAFIk3Tojf211YpQtGkQq/9YrtEIRzeqhIYZ8dOu5ossFfNtnNdH0cSnwblFkIMNYuC9ShC41Rv04Xex3uLeym6GazTXsIMk6Mvwa9XdYQDQyGMq9Xi+
 BHTzGqM/
 LNa2+nhW/Exeu9m8gnJEcjm3kXQfogRrHewapZh/C1wZnXCfGnjUd+/rO35ZQQ9vFtHctmMgSdPI7BpNXGX+ce7lsdoZ/QZT7h4Hi6ZGzYwvtWDrwUuVzq+MJPmJHW+HF8gvZuRbdKb5rF4I0EcwSWaCSIyYZhlENJ8V8LbMTtI2XyM/5ZVBMuN1ylvv7nsnYhTdFxnre1Vup98GpPqJ+AvxkYiGarUcj1Xz1S7SqS2GWaqfkhdv1xDBdexKiETj7fi1et0SVp06ov2aRIcs13yl2kU9TkKDRDTgSGVMUwe9j/arlF4cbxsh/3nKkXziWcQTsB2mId7HdaA/Au4O7Z4Ksy/duNmXX/7VJ/peZrPnTGSlONaaE1NQ1kjpUcqSLvOP2vd1HwtDAvAQxPM2FCRt5FcUWgWSyjK3J1IEbFocKnfHFu5yFv5p0oKbnpHyEY2iY6MihL9+/vmI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 28, 2025 at 04:06:58AM +0000, Carlos Llamas wrote:
> On Wed, Aug 27, 2025 at 11:43:39PM -0400, Liam R. Howlett wrote:
> > * Carlos Llamas <cmllamas@google.com> [250827 23:27]:
> > > Commit 3215eaceca87 ("mm/mremap: refactor initial parameter sanity
> > > checks") moved the sanity check for vrm->new_addr from mremap_to() to
> > > check_mremap_params().
> > > 
> > > However, this caused a regression as vrm->new_addr is now checked even
> > > when MREMAP_FIXED and MREMAP_DONTUNMAP flags are not specified. In this
> > > case, vrm->new_addr can be garbage and create unexpected failures.
> > > 
> > > Fix this by moving the new_addr check after the vrm_implies_new_addr()
> > > guard. This ensures that the new_addr is only checked when the user has
> > > specified one explicitly.
> > > 
> > > Fixes: 3215eaceca87 ("mm/mremap: refactor initial parameter sanity checks")
> > > Signed-off-by: Carlos Llamas <cmllamas@google.com>
> > 
> > I assume this showed up with clang?
> 
> Right.
> 
> The specific test that broke on our end was this:
> https://android.googlesource.com/platform/bionic/+/HEAD/tests/__cxa_atexit_test.cpp
> Although I'm not exactly sure how __cxa_atexit() implementation uses
> mremap() underneath.

Ok, here is the specific call to mremap() in the test:
https://android.googlesource.com/platform/bionic/+/HEAD/libc/bionic/atexit.cpp#197

