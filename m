Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54D7ACF6497
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 00:03:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD5CE6B002D; Wed, 19 Nov 2025 19:03:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8B446B009F; Wed, 19 Nov 2025 19:03:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 974D46B00A1; Wed, 19 Nov 2025 19:03:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 80C156B002D
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 19:03:18 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 59BDE1406E8
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 00:03:16 +0000 (UTC)
X-FDA: 84129035592.15.B78C1F8
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5CE5F40013
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 00:03:14 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="ihb8l/As";
	spf=pass (imf27.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763596994;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9t+tZGe9uPMEL6NC2FsGJb7IY/g6VnOK/izDWaDIkV8=;
	b=maA14gGUfMN39auZkMeKQ/8FMuLD5uC7VXTkjPojmn5bYAYX5QFt1hBv3ktvXsgnwJUo6U
	94ZBYef7S2aU0o1BC8zUmy9Bh8E9ExQT/mVJuWbxTo7FvmU4iArJm6ETUKaD/5XJipBW4a
	ycna8zOxSouaF5CR5XVWByUbWDoQ3Ys=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="ihb8l/As";
	spf=pass (imf27.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763596994; a=rsa-sha256;
	cv=none;
	b=ydVkqoHh8lpzXl1Pxa2n5c3bEhTtDrB9n31mJ/+J2C3jbGCk6BYkjecn5RFjAHes88WR4i
	oStyVsdOUhUV+KQAH7W2SBG4YUpwmxnFs7Zi/DmrvPnlhjKX0PE1tDNmnM0EUwZARPDPEx
	UWK0rHLhLNCUF4dVFFnBUKB74LTmcsI=
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-640aaa89697so375904a12.3
        for <linux-mm@kvack.org>; Wed, 19 Nov 2025 16:03:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763596993; x=1764201793; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9t+tZGe9uPMEL6NC2FsGJb7IY/g6VnOK/izDWaDIkV8=;
        b=ihb8l/AshErISZks4ljNhmqBN42/J7216zQCJyObBCC8JnCQAbkjSSzfwNpY/Eiocj
         GTZmtuCABrM9wD09QxKxBIz1Af1+PBgMkSb8kXCYkhSBwoo9/0HPTTdnO6zwqZT5qLTd
         yqNC+z2Cla4FwAD2CB1E4a4rWOI1kqNNvC1qLbPmPWdnEErRZhY+tW1QVBGicF7V5nIe
         pIGZpg5aj7U3odoieqIzoHVgIuK6MZk6EXeWsTRTGVx9IEc1k3/JQYcTwOpHDQ1W6nn1
         x9eMdnxBbLOy5foVvU3CO12eHP5YL+b8m0G8T6KWcP/6SHAZQmCupPcM/qxNJrhqUMLb
         J72A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763596993; x=1764201793;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9t+tZGe9uPMEL6NC2FsGJb7IY/g6VnOK/izDWaDIkV8=;
        b=bvVLwMTELfttjtuZ0ls0JIkuIHapdCIvECT2d+I0SJnhMkLnQ5TkHoycT+a1OABXJO
         pZ6NJHptD7Iat3e4Qp5VTmm05GB2JZHHFvzN1PMmNr4UnikDxEQdsFoIVvG7+RN6D1b0
         Uc2tL6htBBMevvgKZrvFfH2aqEXfpQ1LmH9CJLLL1D71F/LNY4b5cwIdPEHDgeCvla6m
         Il5pICkNz+OxLqxiL9OKfNAm+fJYNWLbmwFNkGBTWQYwWjjBF0whcudQxUmLyHOkALZI
         hVuuYY1Px8eHQFEKjMd83caggE/+1dbVIqfikngkaNHYNlHUpYwpbBwuMywWJq+JCGm/
         IRSw==
X-Forwarded-Encrypted: i=1; AJvYcCXjC8iREdH+lUVAD2iIuZt3bzBM+GKPaYwPwimtBk/V1v92VHC7kftR7ENdH6y82NUdRXyhph8g4A==@kvack.org
X-Gm-Message-State: AOJu0YxBPQnchqcLjuYSwG/6TgqYr6S/SjN4Iq5oSYAoEzAG/YaMidaj
	BPkZCs/x7jNLBM08aNW75OTCan4bJKpkCO/ma2qY513qJXawtbqd0x6v
X-Gm-Gg: ASbGncsYqxcSMhhg1AC+cY9Ki1QOT+nanI0a7n9EnR/cYKc5woqIXjAeDyWgsFq1UZb
	7Nxc6Mv2ywDYVtNjWdqnMr44qNjxmzHyxGgqJHILbg5kxfk2fc6shO6iV3SjkVR65tyJ0ZyjVm7
	8KK2W2rSlXa/fQBHzpzIKFv2x9GRoRbBYBASrUNYacYTJUPb6z0Fy2F1atm8EhAWltjF/aT+U40
	5WeuIZQVpuaPe03rE7Cbf2L6myJVKUR9MURP5Wg6lSLj2KTPB3nAV2gqv6/vHQNhsRB8TUC8SE9
	eLzdgWU6XLPSL+56gsZvo3fLCP4m+tUT3l3ftc2W8wgsvXnANwJjbAvyuUNP2ooC8EY90SvqDKz
	wwr8qaRA2LL5K8/y03huvdsEJaJiUOMOcWgIjWBAzreA9MVTdlYI8Il1HjaSCOQHso4n7rwKP2o
	SHE2zo9K0mLv58Js3h6e3t/HnO
X-Google-Smtp-Source: AGHT+IHT2hZSu74IUohA1zPTQeoQ1iTPEo0hunoIYzaiahhr9utAe+nh50zUj9sCroMbMDw+uYE68g==
X-Received: by 2002:a17:906:ee8d:b0:b73:398c:c5a7 with SMTP id a640c23a62f3a-b7655457881mr99890766b.41.1763596992696;
        Wed, 19 Nov 2025 16:03:12 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b7655050d05sm60811066b.70.2025.11.19.16.03.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 19 Nov 2025 16:03:12 -0800 (PST)
Date: Thu, 20 Nov 2025 00:03:12 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com,
	ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
	pjw@kernel.org, palmer@dabbelt.com, aou@eecs.berkeley.edu,
	alex@ghiti.fr, linux-mm@kvack.org, stable@vger.kernel.org
Subject: Re: [Patch v2] mm/huge_memory: fix NULL pointer deference when
 splitting folio
Message-ID: <20251120000312.xasxdzmmztvp4spa@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251119235302.24773-1-richard.weiyang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251119235302.24773-1-richard.weiyang@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5CE5F40013
X-Stat-Signature: ee3cwnxm8o6zwfmzoxpeusddguw3zsru
X-Rspam-User: 
X-HE-Tag: 1763596994-352037
X-HE-Meta: U2FsdGVkX1+hkp0tYPB1SbPMZM6mSmdY68yqOit0s/1soD4aR7D3lHj60rHoLzCj1hFCNZtyp7IZNQlg7WA9gLdpq9PsbjMkj1oMRS7OwXF8Q7nJvrWFHMVir7czVf/7vZN+h5n8qu8ktq5JE7NLSqFCYV1X+vSvIa8BGqWYuTf+tYih4zYOEzJDw6xHMtBepm3y4mQQUYKyjnKRWESv6DKBN8e7chjOyP51ir15pUUaz5hW7FOc+aeylWpMNy8CAuD57rgpPEZmnJTM1La48RVIJXOTOzg8pPGLlEXzVit34MBkordatnAkHt1av97E2X09HZHJeBtI3gDBhk4Q75ZY5LuXCPlsrQvYxUQDys7fybFAsB65ysIkKErNpYDcex2RRWTC63ATvK1TRP6jAcRfOxvP8a9NhSjQHxwSEgdqYHsbFGJ559Pf5G/nw+NXvhi5VwmLzy/oRW7KzkZQfNMLS2nU+eNnHWjMcscS7aHE1mFqql58TEEeMX2k2uo2OiTdO8Ubp6NPSpxsSr8tZpgX8NS3aNkWaqsT5R8hEUnsuafRrJMKydJ1e4OYgkHmyKOZHfKOVN38VgPV9zHjpsF5zY1D5GwM8yQZWliDJbxjfhriHMJ+O9kLU+vYEaLXG0iYDI3XF8AUx3gpZCbTrZtXireFIFMqljiymGAS1HH1mqmfPimQosL7LQnnfoHAX7xH7oNM4Qc5pZgjQz6mQAPdZnQFhAJdmM7zhtCejDy5XYtb3G9BSD8dXrQn9EbfJKFkvBuRrj4EtzjgEzaosXI72F5oZhPl4BYIbFzpuud29og2kpCkVRShzemM9QgNAlLEgdUK29oiTL0MyRlwsnR2EhNitxbK5DLp/eqW5J5SGNRWcKQY/msm3aFtOfkaE+VcREf/Jwwlgr2rGui5pnMJTEjCgyu1bNu1W357tiN8fCxILCekyy6d1g0GvHRmmTf5m5pycWZTPfIdUUs
 f3aZKyZ1
 2sXNUM9YXqwNNLk8ous9fLcsRsrvNTARHx8Lzo6WJcepTFNBGW1eX7tC9C+d33vas1ImOUPk4DHH2cqEsGudUVAXPa0JhVMBXeURCvd7k/eHlEkmAnfAdebSPGcvLKoLUY6t4mlgcSVaumrj50nDY05ayCc+d+Y2776iGZoDwKMv2uw+fMeHRGSmNRQM4ed+jdbnwfiw8WeGNRJh2SkQys0H2cl9HiZjhbXq3a7eAEQZcEk1Et4+yLLoa5qJ5iTyspVGDCYEyrO4/x7Dl/4S+d5KgSLRKiTkriypUi74EvYTR7EeCIUce/bMgeb/aYT6Xexu0d5xOtJkznq+pGOxaIWfMF55ste3N1KE8wTwaSgkqowKbNcP/zCFgavKf5+WqpVenlQ1BcCcL6DQV8o5fhElhqkWDF3f1PVJtFeXvT0EDKcTcMCpsxS8HDc/mjOAGessivjQe4W1qhh3YGHJ2vevWROi6QXd1EPDiCvfg3e1xngG8UKiX3uaNLqyUL0sDzYi7oLX1R/uUCFBmTflh9jqxcU4qgYbgo2jn70HLI8xIN/BpyazOrC1LvCGi2vhnQUAAzMb5IW24wt8wF0K2nKQ1/3wfdJgJ2zszQQZ2zjFPSQa1o8lwPj1nWY8j/n/K7aEnekq83tlUWJlYxq1CzWw89JiXouVmr7xqrJlHGavnbVtRAgl4Sb4ddBWtLcvuol1V2jgdtbDYvBTFL8X2hHm/N/OJMnwT21UjQOiJ47Q7/F4390GzwZtwTVeAP4WYFmuS519MnpLdieNwYw2rBwB4uwcTuJ1F0YYyZvSU/NjckVrbKq4hMlF5cp8rWmh+o9If
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 19, 2025 at 11:53:02PM +0000, Wei Yang wrote:
>Commit c010d47f107f ("mm: thp: split huge page to any lower order
>pages") introduced an early check on the folio's order via
>mapping->flags before proceeding with the split work.
>
>This check introduced a bug: for shmem folios in the swap cache and
>truncated folios, the mapping pointer can be NULL. Accessing
>mapping->flags in this state leads directly to a NULL pointer
>dereference.
>
>This commit fixes the issue by moving the check for mapping != NULL
>before any attempt to access mapping->flags.
>
>Fixes: c010d47f107f ("mm: thp: split huge page to any lower order pages")
>Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>Cc: Zi Yan <ziy@nvidia.com>
>Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
>Cc: <stable@vger.kernel.org>
>
>---
>This patch is based on current mm-new, latest commit:
>
>    febb34c02328 dt-bindings: riscv: Add Svrsw60t59b extension description
>
>v2:
>  * just move folio->mapping ahead
>---
> mm/huge_memory.c | 22 ++++++++++------------
> 1 file changed, 10 insertions(+), 12 deletions(-)
>
>diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>index efea42d68157..4e9e920f306d 100644
>--- a/mm/huge_memory.c
>+++ b/mm/huge_memory.c
>@@ -3929,6 +3929,16 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
> 	if (folio != page_folio(split_at) || folio != page_folio(lock_at))
> 		return -EINVAL;
> 
>+	/*
>+	 * Folios that just got truncated cannot get split. Signal to the
>+	 * caller that there was a race.
>+	 *
>+	 * TODO: this will also currently refuse shmem folios that are in the
>+	 * swapcache.
>+	 */
>+	if (!is_anon && !folio->mapping)
>+		return -EBUSY;
>+

This one would have a conflict on direct cherry-pick to current master and
mm-stable.

But if I move this code before (folio != page_folio(split_at) ...), it could
be apply to mm-new and master/mm-stable smoothly.

Not sure whether this could make Andrew's life easier.

> 	if (new_order >= old_order)
> 		return -EINVAL;
> 
>@@ -3965,18 +3975,6 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
> 		gfp_t gfp;
> 
> 		mapping = folio->mapping;
>-
>-		/* Truncated ? */
>-		/*
>-		 * TODO: add support for large shmem folio in swap cache.
>-		 * When shmem is in swap cache, mapping is NULL and
>-		 * folio_test_swapcache() is true.
>-		 */
>-		if (!mapping) {
>-			ret = -EBUSY;
>-			goto out;
>-		}
>-
> 		min_order = mapping_min_folio_order(folio->mapping);
> 		if (new_order < min_order) {
> 			ret = -EINVAL;
>-- 
>2.34.1

-- 
Wei Yang
Help you, Help me

