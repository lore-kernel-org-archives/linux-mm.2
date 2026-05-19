Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C0CFCD4F3C
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 02:51:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A88C56B0005; Mon, 18 May 2026 22:51:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A39646B0088; Mon, 18 May 2026 22:51:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94F456B008C; Mon, 18 May 2026 22:51:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 852086B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 22:51:46 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 039C916037B
	for <linux-mm@kvack.org>; Tue, 19 May 2026 02:51:45 +0000 (UTC)
X-FDA: 84782644212.09.610839B
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf03.hostedemail.com (Postfix) with ESMTP id 13FB820007
	for <linux-mm@kvack.org>; Tue, 19 May 2026 02:51:43 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oww3nEln;
	spf=pass (imf03.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779159104;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HUvEeG4/QGY098FJMB5ch64NaoSvyes0bxvJyMtkahY=;
	b=ePkAdY8hORFyro/XqzQG285UzOEpxagaa8v+nxSFkMj2N7DTgpe65UbVg5Unlt0HrV6YNk
	J2JSeilBrvOB18Tx3mswrqE1Ydc/M8YwZIeLAEQLM1Pyl4pCImrdfJkrn3j60BJKqHVKzT
	EephU9zaOMglSMm5iFfuG0ymrDJn7UI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oww3nEln;
	spf=pass (imf03.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779159104; a=rsa-sha256;
	cv=none;
	b=k4HjY3dVxerjiWgZDxva1COclIYOzGQmFRBhqxeHUq+DNKQPkFuXlBwWMHI6BPUqdPsmr5
	cvWkSnLh+G3vVTN2eNI+fGjrCND/36Z/+1ktSJRXlLrBApbovJwG/QcrK8jq4Npz1Wiv7l
	5hTT9gcbErUU3F4BmUca3RPG4lfkdwo=
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-43d75312379so2611175f8f.1
        for <linux-mm@kvack.org>; Mon, 18 May 2026 19:51:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779159102; x=1779763902; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HUvEeG4/QGY098FJMB5ch64NaoSvyes0bxvJyMtkahY=;
        b=oww3nElnSG4Is5kbA2pAI8xl6pq34fofjlFvdIGj0+RhqzhN2PS2LKDByfnblC73do
         EtDH5UYVHk8CAUG4lYi6tMT/9SCLWFBu95P4kfr9ci3pN+4oWIfdnHWuthokn9bCnLkQ
         BRSSc5rrTSTvkZvUbs6Sg0kjKFWkhOAI7Fut460SMNt+yJS8xfbvq0tSo+VwVuLpTZSw
         ekfxQjbgpZDqxcDOds7R0QxolaG6pTc0GE6sJf3b+ohJz2DweT2zgh92tnjsA+SaziuN
         2hc+R3IPGlRggqbA6tMDVCsaCRRqJMDTmRmGGxN5KsxBNVO1NxXQ6RKNEjUuoDm20dp4
         32SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779159102; x=1779763902;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HUvEeG4/QGY098FJMB5ch64NaoSvyes0bxvJyMtkahY=;
        b=e3itYgP8kYX4x/8lQcW36LvkFCVXQ4vggejUpw7HLyLuJpljJ5f3+XJ+tocBN+R9zc
         FoA8Vhm3piHF0+WEgxuOnmgtdTR+iOzBN2EjUfKEeGi+ky/kpqcKoEawJWgJ56C/ehQf
         Ix8u1gSqp3G8G1XJ5QS5hbwHxjzEFLgqEw2ifE47nx+ww9RSs69BPPVrUKhRaYr12lv2
         OHVXHM5PrwYnN+NvuEysj3krgFSXMX8gzcsGrH9SUf936py6Dhljr32BGpANPy8kQZBO
         YYJB8hX3HxxFmOkgIBrU/CH4f2j8LX06pvbJUBFl3WD5IPgYETLIEtbfvcrkfruqIzkn
         qRmg==
X-Forwarded-Encrypted: i=1; AFNElJ8z4q0OXSQ66ZfaQgMOdyIS4E2jbXymwkIQvgD7Ima7gMuaGkk7q7MMkWYt1QswNK5KyIsKmIFrSw==@kvack.org
X-Gm-Message-State: AOJu0Yy9HHAQdFgLmyJLoT0GrHp/tprBbhI+C8lVU9AzlRcM269KCkbO
	qh3H+bpY4KopKg6IwSCkQFVWxUwYV38Y27dDWhJYFprsylflkkG8h3oZ
X-Gm-Gg: Acq92OHTcsSz9eFj+NAxaBhE/iv+KO3Y0T8xIIqVqlHod0PCiSHtZKzMLBbk1GI4ix0
	o3uKmwEWTYj5Q3HQwhCoXt2M3mYLR/nyPq8MZVQNPY6KzotOVFm2rBi1gebYinYNOq/Jd0lD3KJ
	Auml+bRx69IfPwicJFCLYiUNoLMsrtREFkPv1UFsKvGNGpoxEpfahTyax/c2xW0cnS/XiyABx+7
	HsVIEvgsuOduxojlvhHRnV/85xj16uQl8IhymSVrtideM9IF9PGRdg3r1LddbdRz1PyO5QKVybU
	nfrlUdYvIrcf4UeDI/7k5dCD3iau64J7FkQBl4oMyCMVLIPc/e6v6L+NUZ1sNCtzKsq5IT9YThY
	tbfgrz4G4ZsepN9FMGFge3MVk1jddOuiKPwvOxlHqtcgKAyVDO/CpkpK0imXkJOo5zvHvAbI5C1
	oRa+VzXAJTChHHdf0O55CQZA==
X-Received: by 2002:a05:600c:5010:b0:486:faa8:9e4 with SMTP id 5b1f17b1804b1-48fe5388407mr256024315e9.12.1779159102140;
        Mon, 18 May 2026 19:51:42 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fe5ab3977sm319672855e9.9.2026.05.18.19.51.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 18 May 2026 19:51:41 -0700 (PDT)
Date: Tue, 19 May 2026 02:51:41 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wei Yang <richard.weiyang@gmail.com>,
	Vineet Agarwal <agarwal.vineet2006@gmail.com>, david@kernel.org,
	ljs@kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: check file initialization writes in
 split_huge_page_test
Message-ID: <20260519025141.lguv7mrtvqgqpltc@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260512074924.27721-1-agarwal.vineet2006@gmail.com>
 <20260515092211.qkmaxcofxwfdexld@master>
 <20260518163553.447a45c54a3d419b9bb916ca@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260518163553.447a45c54a3d419b9bb916ca@linux-foundation.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 13FB820007
X-Rspam-User: 
X-Stat-Signature: wpeei55uk8hyz5zqr4yw3wgyn79r9si8
X-HE-Tag: 1779159103-31149
X-HE-Meta: U2FsdGVkX1/VmWPo37pKssH1pVTRgH3RZGHJnQUW4KVKifm7/E60IXytrH6X3/yFw1q8NMbSHICgY1y33P4aY0shyPmI2hh1GD2E2h6w9s+Y8Ru+DSZYOyECylm7wrVIhEd3GHmUhbTONGiAoCEBDG/9V4dAEGcfDX/ouKnKuMGTVSIGH5NL0uYnluxNiSGRtROFtK6cTczSmcicqfXun4eyXh3xzelVR2ZXK0ObUJM0rb1lnpNpmdUlr3lKO7cZPyZ2fpxgvOjAF7oQnn1SszKsNAii6NfaFkmIf9QO4m/FdL6q2CtvjgRXqCmyq4qZ7oL/YImQ6LDfbvzBTnGUKuDb3AnYEZgTZ2mE0riImDRQhjPEbrW+5vlWq3Hk98BigHLxaej+tjoApBrjCcSS5Psp/b9xmdj/QqMpRaADG8APaxwQ2BudsHgXykOOyGJKSexeXgGh2QoSMPmXLaM2GHrvarXcdTA8T0Cwm2ECeLcfyr2s8KPvuM0XpWC4hX5VRrc6D/8U6N4h1Z0TEulEGBipxVmwhCAKyAXocZq2BzCAEwV2bdDlfexegaXXbk7oJSgVaMiR55wqjbH3vOkGIhJH216kQaWH2o4LfqQoxYI7/1792zC1iyNostcDzo52uZU15wBnT81tPkLsvIf3fh0cCBkOEREHf0o0SMsfd0cEglSYHsYRe78x9uylGLdJqHGv/TfMUB1YYh2sfRrnZI9YhoD002ecFMEjr3kJAPYgggtHrvq3hbzTFAdi4jhRBXgSuOX23z6LfNaJEvLVsY0iR6WSFjhOyLzPQ5fe/+T7bRKCAO9T/yp7OPPyagznbaaLlH4bH5YH5VAhXnq+i2Q6YVTjLvcQe9ycrtxyw8UJGqk/yuxc4qO5Sqw26REaVMeNlsS9MXwuk3smj0S0McIKOKcOyxsJBni34TbKhdAlIPdmfssFZzqD/BFi9ZfCBzm9kymo1qWxEf40St8
 kym0zlNc
 vAGYUJBdGQBQOsWIM3bv/tkufOooNNmuujhNUte9ImT+nvWm4sF7XRVEEyBaOfvioAN6UeOGgjIeCHNfU0O/6Y4lbftXQRTkKvfGgLLpchkq1oRAUH7yJ6VhfZ0YYk5sar2AiJE9gf21w8lGcmqWIdao394zCi8KswKTleoFu59+Gy8uPZbGczOQEVJugRzlZctTlopOjflpxX24odl8u8sY4jvz5kCHjrqOn4ws+q4nzA4ZX8Lta4Qci6EBp43q2byV975Oi782nTdjzSvky8Q06MFqSOlk66+uYVIYoSPJtoFTL6RX2m4frM5pC0+G4R42VOBrY1IEoInmk+9BtmWPU0OhpSfzmW0GsmW9HTFjy6ui+xLuXu4aV+DpCj8NWAdJ4XetBUNXVhWUpt5hJIytmOo7wbpzwlKKCa583DULdc9cjFszttpdoy3y65LieF3s5s9Azz66AsgOW6AQYP61ERBdrYSiGFuNHT7dcITOgfrUkbHZs8J5hoxpEkKEynK1z+AJWz4hj+tIUiperVsiUQY62bFCvZ6OazA64E8q5cMLiHRVENHIv5EMDMA83xrfo2wWUdafCIQzYbGgUEu28CAS39HP48R/CuLRO3Zhj/bB6fhtBoyJ8y0gpR29YTNkrbttbpm7mIDiV17TmAItH15zc34KBV0ywdRvnvBZSfJt0SQZt371IqYRN9znrMJ+WgGhs/N+NSoTgmaSlWU4ObeCMrAXLoi7xfTCV22pioH4mGKbxlbk9Ax3ckBMNHIz46BweSpeS8myyyQ74I8ZWZmupvO6XYuZ3XWjsehLseawk1ERcvGNnb6tcVPujr9eUekJbqhAjzmo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 18, 2026 at 04:35:53PM -0700, Andrew Morton wrote:
>On Fri, 15 May 2026 09:22:11 +0000 Wei Yang <richard.weiyang@gmail.com> wrote:
>
>> On Tue, May 12, 2026 at 01:19:24PM +0530, Vineet Agarwal wrote:
>> >create_pagecache_thp_and_fd() fills the backing file for the
>> >pagecache THP tests using repeated write() calls, but the return
>> >value is never checked.
>> >
>> >If a write fails or completes only partially, the test may continue
>> >with an incompletely initialized file and produce misleading results.
>> >
>> >Check the result of write() and fail the test if the expected number
>> >of bytes was not written.
>> >
>> >Signed-off-by: Vineet Agarwal <agarwal.vineet2006@gmail.com>
>> >---
>> > tools/testing/selftests/mm/split_huge_page_test.c | 13 ++++++++++---
>> > 1 file changed, 10 insertions(+), 3 deletions(-)
>> >
>> >diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
>> >index 500d07c4938b..eab69b0f59a0 100644
>> >--- a/tools/testing/selftests/mm/split_huge_page_test.c
>> >+++ b/tools/testing/selftests/mm/split_huge_page_test.c
>> >@@ -609,9 +609,16 @@ static int create_pagecache_thp_and_fd(const char *testfile, size_t fd_size,
>> > 	assert(fd_size % sizeof(buf) == 0);
>> > 	for (i = 0; i < sizeof(buf); i++)
>> > 		buf[i] = (unsigned char)i;
>> >-	for (i = 0; i < fd_size; i += sizeof(buf))
>> >-		write(*fd, buf, sizeof(buf));
>> >-
>> >+	for (i = 0; i < fd_size; i += sizeof(buf)) {
>> >+		ssize_t written;
>> >+
>> >+		written = write(*fd, buf, sizeof(buf));
>> >+		if (written != sizeof(buf)) {
>> >+			ksft_perror("write testfile");
>> >+			close(*fd);
>> >+			goto err_out_unlink;
>> 
>> Maybe we can "goto err_out_close" and remove the close() here?
>
>AI review suggested the same:
>	https://sashiko.dev/#/patchset/20260512074924.27721-1-agarwal.vineet2006%40gmail.com
>
>And it complained about the handling of short writes in the added code.
>
>> Apart from this, I found on error writing to /proc/sys/vm/drop_caches in below,
>> it just goto err_out_unlink, which left fd open.
>
>Not understanding - cab you please describe more completely?
>

I mean do this below.

diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
index 460fa1f606fd..f30402ece608 100644
--- a/tools/testing/selftests/mm/split_huge_page_test.c
+++ b/tools/testing/selftests/mm/split_huge_page_test.c
@@ -469,7 +469,7 @@ static int create_pagecache_thp_and_fd(const char *testfile, size_t fd_size,
        }
        if (write(*fd, "3", 1) != 1) {
                ksft_perror("write to drop_caches");
-               goto err_out_unlink;
+               goto err_out_close;
        }
        close(*fd);

On error writing this fd, /proc/sys/vm/drop_caches, we forget to close it.

>> How about fix that at the same time.
>> 
>> Generally, the change look good.
>> 

-- 
Wei Yang
Help you, Help me

