Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10F3CCD4F4A
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 23:48:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55A1E6B00AC; Mon, 18 May 2026 19:48:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 532156B00AD; Mon, 18 May 2026 19:48:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4210B6B00B2; Mon, 18 May 2026 19:48:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2B5286B00AC
	for <linux-mm@kvack.org>; Mon, 18 May 2026 19:48:33 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D8668120AC7
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:48:32 +0000 (UTC)
X-FDA: 84782182464.26.33E1179
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf19.hostedemail.com (Postfix) with ESMTP id CAECE1A0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:48:30 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=MBQoO7hi;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of abhishekbapat@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=abhishekbapat@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779148110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qITyhY0D78MWVgWOfJpH+CtGmJwy2vENeI+pczv5+/M=;
	b=gXuq+rsExgQZCldELmGLl5Dfuu3+zOmiaiGB0bJeRIVu9kIBPAKQVNc8CTtaFG91cb2Mog
	P+RbKLi/80OO+wnQ2exWw8GkWIVhwMTSOaA+q1kz+cp377oXUpX0NZPYITtJixfegWpneu
	waKJaZDs+5opGxy/+5JXUXgEMOJ4HAY=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779148110; a=rsa-sha256;
	cv=pass;
	b=Dy49TSz9MUxsmaMvK6nY1w0cYJtTwXqL4/xkNa1O6ZVX0y8w3hYnAZEf+KYP9ttINm+iRj
	GZP6RWy24fKZLx8j7mvQ79b7WyLzh4GuyBN0EcVo4p6VgaD3pjz9gFyg96B/AQUUSuoh5p
	Q6WW7KNO+ox8JEXorKbz+AH6xsg4gV8=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=MBQoO7hi;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of abhishekbapat@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=abhishekbapat@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2b2e8b95bdbso1055ad.0
        for <linux-mm@kvack.org>; Mon, 18 May 2026 16:48:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779148110; cv=none;
        d=google.com; s=arc-20240605;
        b=fL0XY6RWE3+cRAoHZMz74oc3enWijJbNSl6AiT7PYVyjRGmG646Hk8dV0CyMKMb/A0
         qFRFMpuNHdunaUfx3q30HFgrtgWYrhyHgcAjPZlZildsKsh4WMRof0c7uM5743SUrDmm
         hmjn5gzfk7VXIPMsQSdIgrnf4nE9662Hq/JFQE1ZKwzOR8e/z54i7QsCYEYwVJfMTY/N
         Vk5Ob5xBQv93lotRP5Gc0lRa7418APtoRe3LkkavnSLcEswREpqQCiMxGltt4U3FmKBK
         V3ZOo+5RfSeIudBvA6JQtnULAoVsG/3BPvewm/lKx4NN8tGKjN09L0CdtC+BXGYeONeI
         VHIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=qITyhY0D78MWVgWOfJpH+CtGmJwy2vENeI+pczv5+/M=;
        fh=artG21QX11D8+DxVNfufhG71jKzIgCQQDdaMvnQzOfA=;
        b=VifYCaB+t2TcICLZXZniiTBVke++3h4dll1w3qkz2m2/nK5tTdBgGRPeq7KPO4qOT2
         aaT129KlGd/hmzdQ9upynXFADaJlYlVAV27VdxHbC+bFDf5fdf/ELlgmYOyI4Ug06cvn
         qjRPbtjWwaFxX8nvqusIiNghVtn1Ut0pnxdz1yWzRaTnsgIRLqGvDxMqf3kVPbwS+xnq
         Q/V377MUQMaVyyAfgHLoIwgQ6dimFQ48miYsQAuPKd0jmR8hGNDnmZUU8o2Ru4DtxZD5
         buV6uxAYPli+IZluM6EfOnK81H1hNpt6nK/IKL3EdD7YG2FJ/fIGsojCOungo961rMgs
         NwWw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779148110; x=1779752910; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qITyhY0D78MWVgWOfJpH+CtGmJwy2vENeI+pczv5+/M=;
        b=MBQoO7hi73uInUSj1So8Bx7v9oiOtr4imu4BCIX3KOqT+klhHwYR3sXgr02xV6LD38
         773DlbdZRexKf92sFGzMADxkaRlvlRV9j05dR+Wqc4AIjn7ooe7BuEDmNMPbYP5GtbS/
         m/PpsgpGbNiGFsEOdQA2iOU7g5GgFC5upvY9QTav0FiDeVFNg2HwIeNCpMRzewQ8QqPK
         eUOPxgQMXYe6B0N9tlUJgF2BsHuiqpheEPpEjhKtJZQQvPxtVaYAmyofQ6P8hKlMYBii
         +izFYcfhUf3bAdNr1uaQs5Cp9+w+52ARaPayO2jLr7ALChac/sZVgSbLB3nZJCjIhCQZ
         NnEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779148110; x=1779752910;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qITyhY0D78MWVgWOfJpH+CtGmJwy2vENeI+pczv5+/M=;
        b=M1YjVV1HrAvvP+Zp1c8PRc32H7EPIVJdLERYxTUwwJRwfasqqUwYegDKDKZ5TGfvBE
         9CNezlkVNpHoRYyVwEmcsdw9pUWIM4Et73Pg9ay89AtDs+HbD1cjETmJsBm0j+RyRdKU
         23P1pUGb7LgFD6HAU+0HQGDZzW7RHmuLeaGgirqQjec0Cu1i3e0xsbnQWtOisas/xdp2
         KaifyLIAoj5+PwTyCX2uDLbKKJJwG8Sv6WDcvig9WCBZyqWFmKYj+0p8Kv5jY9X6C4GK
         Iy5in5OsGTe8zYwG2mMQYvPLLMRmH2Jzdzb/zobBGDvAU3GAOTMPPF++mSTjauL2Mgew
         HdVQ==
X-Forwarded-Encrypted: i=1; AFNElJ9FGSw1kBdfwxgOuXzi9/jh4hYy+HAjjCTgnP9uPioLaxYtfxReLQaY2KFZ8tX47JfES842VKuB8w==@kvack.org
X-Gm-Message-State: AOJu0Yy/wyPp5+kESRgbtwe7SRiqOIxSjcatnhMDx02YNfu6oI5XJSON
	XZf3jW58ikn7rpUHM8E9MXW+By4cIBktQWYq+fVZwqLODPdIKGNxiIgNzwG3pUdPoiXkrmeCp/2
	Wj5sUf2mZudwAPcgqVoTjst6GCVJemdEvUSL3NXIk0ZB7aakKWxJBJJH9z/4=
X-Gm-Gg: Acq92OFh0Bv1Xg9ugp73yQO2YPoWJUP1jIJCPKLHyXmOSxgsC2JGNhnA2ccinyg+XX2
	EfR2zON0qggV9KlUXFrvMvLUV8dhnFuNbg9hVmEUyOIz9rIxluyJNKdT2/7FeI4JJFBDxmyxys4
	wuOE0w4GYkqIucArfIPcGmT8X94QkXfAKCb3472xmKMa2fS1/VTPnxCRZF5Ci6zP+aRjOSl1w0X
	RUYKWb0bHRTVfSbzo45m+giaDplW1nDz0AMKjrpg/5+kk/tLnwFPb7sKsEqYS6ZFy2vwSbk0lCI
	YjVLEsAf5NZbKSQi/I0NWMwLQRWGZitqRPB4GO7j2oZZFA/x
X-Received: by 2002:a17:903:17cf:b0:2b4:60e6:44bc with SMTP id
 d9443c01a7336-2bdb329b5eamr4190365ad.13.1779148108846; Mon, 18 May 2026
 16:48:28 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1777936301.git.abhishekbapat@google.com> <6d8a2059a4625ef638062815d9586f7a083d02ec.1777936301.git.abhishekbapat@google.com>
In-Reply-To: <6d8a2059a4625ef638062815d9586f7a083d02ec.1777936301.git.abhishekbapat@google.com>
From: Abhishek Bapat <abhishekbapat@google.com>
Date: Mon, 18 May 2026 16:48:17 -0700
X-Gm-Features: AVHnY4K5suSSdtsEAUibGv7Q5I4g9-dyjhnPXdy6-fVf8_5c9_292nNmx9n22cc
Message-ID: <CAL41Mv59qrcvM3=qqjfurb0kq2RsSRELgKU6JGjZva+NxDMw_w@mail.gmail.com>
Subject: Re: [PATCH 5/6] kselftest: alloc_tag: add kselftest for ioctl interface
To: Suren Baghdasaryan <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>
Cc: Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Sourav Panda <souravpanda@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: CAECE1A0005
X-Rspamd-Server: rspam04
X-Stat-Signature: c5wxtq3nec86zu3g7f6jh5s5gtqpduw7
X-HE-Tag: 1779148110-97104
X-HE-Meta: U2FsdGVkX18FaCwmqJrFgN7vJOdIxTsz8ZeviAV9FK4XVvxYT87VzRgi3oKhDzCx/4gY87Z8vWLOcxEIAn+n5JONEMEKBEjxHMBAOqgmGspAcla4Vnq+zZzajWf2Wq9qhUO+BxMXklf7npTUbxiKycnNdZVfiiwi9esAcZYa/j2sPKx7AywP/8vcZSy+DvpvWfQ0pcwA15sjOdPBKBqgpO9G42WC4FxwqNlAXxY7mTBKda7MLcM1jyenHJ800MtVEAJ6W39htDlmxyDueJ5DbCBlpsjsGorgr3dF3Y21Q6HtJLmjO8PlWcyKo4qBSxxgxKUZZtfCc0J8ssLqcuKQjRoxee3186RMYYeb3QglXk/vAPEPwKLLXJgfHUoDpYQlAaNOMoFvdYqytJSf9asiNaRn9BYA2NSxn0HXllo7Ib2z/LW30VBFQf4XBQZEzPHFifXpt0Rkk/M4YhnJAS9Mz4YfkvzUWbGY5K1z9tIu72fctGAVecwiEP6cjfFceo6P6imbE0d1tB2DnAgNTppqKw7/+rpxLlAYLjHR+9G6CTchlpgumtHRnlOrYGtCS5kIv4ibO37D0rgl3XVCZyh5/XqWqrdIHOzlNYQw3K5vCZiF3urTaKJTZh4DYaTgCGPYUBDnw+Xy8vNKYBI++AYlb7lEDIOmXgmbeFvDlxFW9n8JgshxS8bjbv4EHqkq1c/JtlbI+Cr5UdBnljNKpkWSCvoHt9gg6KrOgBjn1hA7qf8nRD7NS5LVng1wvps5TOHEZCGvZ5pt55dnGcD4tOzXzjYYhm+MBdQhBhs6C5Rn5GI91oV6GHE/TkfEjwsN8u3FHOcttTuMqT3UDlbKDjJ1V8wuuBdC7sR039+q80jfGG118yf8XUjavJOFP6XGyx/vz3xF5owFyW6q3zXKuWgUybavcQa5pAnaz0ryG1gegchWSEfHgZ8QB3TAVjqwBADPbXVueA3A2T4zCpgk7Ra
 bZnxTmMC
 hYr/4Lhei60dV3FgMyoEr1UzDjAZxhRT7KVYS0lXiXrXruxHxFg+/0NkuBbXrTtzIps5hKZrbB78gi7RWxBMveSdxb+x25TSGbuU3PtYnnd5lM52WZLZLGmO/kWkrjOA8zDnk2Xk/qxjf7SsZYHmvclgNzE6HRfuPlPjerF0ucquy1/TZihRHYOxyyC0nYcPy1IuUu1VM6qUW1QyWEGSIeNHVGENLGkaOfAQl/GsmOxj/kSQE1yAjHDaz6P0FZBwgUL7Z3v/GMQcCYXRAbXIL6cky4JwKo2kGOKKkkP58tlLF6asc8k4MPUDg0Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 4, 2026 at 4:36=E2=80=AFPM Abhishek Bapat <abhishekbapat@google=
.com> wrote:
>
> Introduce a kselftest to verify the new IOCTL-based interface for
> /proc/allocinfo. The test covers:
>
> 1. Validation of the filename filter.
> 2. Validation of the function filter.
>
> The first test validates the functionality of the filename filter. Using
> "mm/memory.c" as the candidate filename filter, it retrieves filtered
> entries from both procfs and ioctl and matches the first VEC_MAX_ENTRIES
> entries.
>
> The second test validates the functionality of the function filter.
> It uses "dup_mm" as the candidate function as we do not expect this
> function name to change frequently and hence won't be needing to modify
> this test often.
>
> Note that both the tests match line no, function name and file name
> fields. Bytes allocated and calls are not matched as those values may
> change in the time when the data is being read from procfs and ioctl and
> hence can lead to false negatives.
>
> Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
> ---
>  tools/testing/selftests/alloc_tag/Makefile    |   9 +
>  .../alloc_tag/allocinfo_ioctl_test.c          | 316 ++++++++++++++++++
>  2 files changed, 325 insertions(+)
>  create mode 100644 tools/testing/selftests/alloc_tag/Makefile
>  create mode 100644 tools/testing/selftests/alloc_tag/allocinfo_ioctl_tes=
t.c
>
> diff --git a/tools/testing/selftests/alloc_tag/Makefile b/tools/testing/s=
elftests/alloc_tag/Makefile
> new file mode 100644
> index 000000000000..f2b8fc022c3b
> --- /dev/null
> +++ b/tools/testing/selftests/alloc_tag/Makefile
> @@ -0,0 +1,9 @@
> +# SPDX-License-Identifier: GPL-2.0
> +
> +TEST_GEN_PROGS :=3D allocinfo_ioctl_test
> +
> +CFLAGS +=3D -Wall
> +CFLAGS +=3D -I../../../../usr/include
> +
> +include ../lib.mk
> +
> diff --git a/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c b/t=
ools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
> new file mode 100644
> index 000000000000..543023ca3d27
> --- /dev/null
> +++ b/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
> @@ -0,0 +1,316 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +
> +/* kselftest for allocinfo ioctl
> + * allocinfo ioctl retrives allocinfo data through ioctl
> + * Copyright (C) 2026 Google, Inc.
> + */
> +
> +#include <errno.h>
> +#include <fcntl.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <stdbool.h>
> +#include <unistd.h>
> +#include <sys/ioctl.h>
> +#include <linux/types.h>
> +#include <linux/alloc_tag.h>
> +#include "../kselftest.h"
> +
> +#define MAX_LINE_LEN           512
> +#define ALLOCINFO_PROC         "/proc/allocinfo"
> +
> +enum ioctl_ret {
> +       IOCTL_SUCCESS =3D 0,
> +       IOCTL_FAILURE =3D 1,
> +       IOCTL_INVALID_DATA =3D 2,
> +};
> +
> +#define VEC_MAX_ENTRIES 32
> +
> +struct allocinfo_tag_data_vec {
> +       struct allocinfo_tag_data tag[VEC_MAX_ENTRIES];
> +       __u64 count;
> +};
> +
> +static inline int __allocinfo_get_content_id(int dev_fd, struct allocinf=
o_content_id *params)
> +{
> +       return ioctl(dev_fd, ALLOCINFO_IOC_CONTENT_ID, params);
> +}
> +
> +static inline int __allocinfo_get_at(int dev_fd, struct allocinfo_get_at=
 *params)
> +{
> +       return ioctl(dev_fd, ALLOCINFO_IOC_GET_AT, params);
> +}
> +
> +static inline int __allocinfo_get_next(int dev_fd, struct allocinfo_tag_=
data *params)
> +{
> +       return ioctl(dev_fd, ALLOCINFO_IOC_GET_NEXT, params);
> +}
> +
> +static bool match_entry(const struct allocinfo_tag_data *procfs_entry,
> +                       const struct allocinfo_tag_data *tag_data,
> +                       bool match_bytes, bool match_calls, bool match_li=
neno,
> +                       bool match_function, bool match_filename)
> +{
> +       if (match_bytes && tag_data->counter.bytes !=3D procfs_entry->cou=
nter.bytes) {
> +               ksft_print_msg("size retrieved through ioctl does not mat=
ch procfs\n");
> +               return false;
> +       }
> +
> +       if (match_calls && tag_data->counter.calls !=3D procfs_entry->cou=
nter.calls) {
> +               ksft_print_msg("call count retrieved through ioctl does n=
ot match procfs\n");
> +               return false;
> +       }
> +
> +       if (match_lineno && tag_data->tag.lineno !=3D procfs_entry->tag.l=
ineno) {
> +               ksft_print_msg("lineno retrieved through ioctl does not m=
atch procfs\n");
> +               return false;
> +       }
> +
> +       if (match_function &&
> +           strncmp(tag_data->tag.function, procfs_entry->tag.function, A=
LLOCINFO_STR_SIZE)) {
> +               ksft_print_msg("function retrieved through ioctl does not=
 match procfs\n");
> +               return false;
> +       }
> +
> +       if (match_filename &&
> +           strncmp(tag_data->tag.filename, procfs_entry->tag.filename, A=
LLOCINFO_STR_SIZE)) {
> +               ksft_print_msg("filename retrieved through ioctl does not=
 match procfs\n");
> +               return false;
> +       }
> +       return true;
> +}
> +
> +static bool match_entries(const struct allocinfo_tag_data_vec *procfs_en=
tries,
> +                         const struct allocinfo_tag_data_vec *tags,
> +                         bool match_bytes, bool match_calls, bool match_=
lineno,
> +                         bool match_function, bool match_filename)
> +{
> +       __u64 i;
> +
> +       if (procfs_entries->count !=3D tags->count) {
> +               ksft_print_msg("Entry count mismatch. ioctl entries: %llu=
, proc entries: %llu\n",
> +                              tags->count, procfs_entries->count);
> +               return false;
> +       }
> +       for (i =3D 0; i < procfs_entries->count; i++) {
> +               if (!match_entry(&procfs_entries->tag[i], &tags->tag[i],
> +                                match_bytes, match_calls, match_lineno,
> +                                match_function, match_filename)) {
> +                       ksft_print_msg("%lluth entry does not match.\n", =
i);
> +                       return false;
> +               }
> +       }
> +       return true;
> +}
> +
> +static int get_filtered_procfs_entries(struct allocinfo_tag_data_vec *pr=
ocfs_entries,
> +                                      const struct allocinfo_filter *fil=
ter, int fd)
> +{
> +       FILE *fp =3D fdopen(fd, "r");
> +       char line[MAX_LINE_LEN];
> +       int matches, skip_lines =3D 2;
> +       struct allocinfo_tag_data procfs_entry;
> +
> +       if (!fp) {
> +               ksft_print_msg("Failed to open " ALLOCINFO_PROC " for rea=
ding\n");
> +               return 1;
> +       }
> +       memset(procfs_entries, 0, sizeof(*procfs_entries));
> +       while (fgets(line, sizeof(line), fp) && procfs_entries->count < V=
EC_MAX_ENTRIES) {
> +               /*The first two procfs entries are for the header, so we =
skip them.*/
> +               if (skip_lines-- > 0)
> +                       continue;
This logic will change slightly in the v2 patch set. Currently, the
test skips first two lines from /proc/allocinfo as they're not actual
entries. However, the number of lines to skip might change. Therefore,
the v2 patch set will contain logic that checks for the first line
that matches expected format and will start parsing from that line.
> +
> +               memset(&procfs_entry, 0, sizeof(procfs_entry));
> +               matches =3D sscanf(line, "%llu %llu %[^:]:%llu func:%s",
> +                                &procfs_entry.counter.bytes,
> +                                &procfs_entry.counter.calls,
> +                                procfs_entry.tag.filename,
> +                                &procfs_entry.tag.lineno,
> +                                procfs_entry.tag.function);
> +
> +               if (matches !=3D 5)
> +                       continue;
> +
> +               if (filter->mask & ALLOCINFO_FILTER_MASK_FILENAME) {
> +                       if (strncmp(procfs_entry.tag.filename,
> +                                   filter->fields.filename, ALLOCINFO_ST=
R_SIZE))
> +                               continue;
> +               }
> +               if (filter->mask & ALLOCINFO_FILTER_MASK_FUNCTION) {
> +                       if (strncmp(procfs_entry.tag.function,
> +                                   filter->fields.function, ALLOCINFO_ST=
R_SIZE))
> +                               continue;
> +               }
> +               if (filter->mask & ALLOCINFO_FILTER_MASK_LINENO) {
> +                       if (procfs_entry.tag.lineno !=3D filter->fields.l=
ineno)
> +                               continue;
> +               }
> +               if (filter->mask & ALLOCINFO_FILTER_MASK_MIN_SIZE) {
> +                       if (procfs_entry.counter.bytes < filter->fields.m=
in_size)
> +                               continue;
> +               }
> +               if (filter->mask & ALLOCINFO_FILTER_MASK_MAX_SIZE) {
> +                       if (procfs_entry.counter.bytes > filter->fields.m=
ax_size)
> +                               continue;
> +               }
> +
> +               memcpy(&procfs_entries->tag[procfs_entries->count++], &pr=
ocfs_entry,
> +                      sizeof(procfs_entry));
> +       }
> +       return 0;
> +}
> +
> +static enum ioctl_ret get_filtered_ioctl_entries(struct allocinfo_tag_da=
ta_vec *tags,
> +                                                const struct allocinfo_f=
ilter *filter, int fd,
> +                                                __u64 start_pos)
> +{
> +       struct allocinfo_content_id start_cont_id, end_cont_id;
> +       struct allocinfo_get_at get_at_params;
> +       const int max_retries =3D 10;
> +       int retry_count =3D 0;
> +       int status;
> +
> +       /*
> +        * __allocinfo_get_content_id may return different values if a ke=
rnel module was loaded
> +        * between the two calls. If that happens, the data gathered cann=
ot be considered consistent
> +        * and hence needs to be fetched again to avoid flakiness.
> +        */
> +       do {
> +               if (__allocinfo_get_content_id(fd, &start_cont_id)) {
> +                       ksft_print_msg("allocinfo_get_content_id failed\n=
");
> +                       return IOCTL_FAILURE;
> +               }
> +
> +               memset(tags, 0, sizeof(*tags));
> +               memset(&get_at_params, 0, sizeof(get_at_params));
> +               memcpy(&get_at_params.filter, filter, sizeof(*filter));
> +               get_at_params.pos =3D start_pos;
> +               if (__allocinfo_get_at(fd, &get_at_params)) {
> +                       ksft_print_msg("allocinfo_get_at failed\n");
> +                       return IOCTL_FAILURE;
> +               }
> +               memcpy(&tags->tag[tags->count++], &get_at_params.data, si=
zeof(get_at_params.data));
> +
> +               while (tags->count < VEC_MAX_ENTRIES &&
> +                      __allocinfo_get_next(fd, &tags->tag[tags->count]) =
=3D=3D 0)
> +                       tags->count++;
> +
> +               if (__allocinfo_get_content_id(fd, &end_cont_id)) {
> +                       ksft_print_msg("allocinfo_get_content_id failed\n=
");
> +                       return IOCTL_FAILURE;
> +               }
> +
> +               if (start_cont_id.id =3D=3D end_cont_id.id) {
> +                       status =3D IOCTL_SUCCESS;
> +               } else {
> +                       ksft_print_msg("allocinfo_get_content_id mismatch=
, retrying...\n");
> +                       status =3D IOCTL_INVALID_DATA;
> +               }
> +       } while (status =3D=3D IOCTL_INVALID_DATA && retry_count++ < max_=
retries);
> +
> +       return status;
> +}
> +
> +static int run_filter_test(const struct allocinfo_filter *filter)
> +{
> +       int fd;
> +       struct allocinfo_tag_data_vec *tags =3D malloc(sizeof(*tags));
> +       struct allocinfo_tag_data_vec *procfs_entries =3D malloc(sizeof(*=
procfs_entries));
> +       int ioctl_status;
> +       int ret =3D KSFT_PASS;
> +
> +       if (!tags || !procfs_entries) {
> +               ksft_print_msg("Memory allocation failed.\n");
> +               ret =3D KSFT_FAIL;
> +               goto freemem;
> +       }
> +
> +       fd =3D open(ALLOCINFO_PROC, O_RDONLY);
> +       if (fd < 0) {
> +               ksft_exit_skip("Failed to open " ALLOCINFO_PROC ": %s\n",=
 strerror(errno));
> +               ret =3D KSFT_FAIL;
> +               goto freemem;
> +       }
> +
> +       if (get_filtered_procfs_entries(procfs_entries, filter, fd)) {
> +               ksft_print_msg("Error retrieving entries from " ALLOCINFO=
_PROC "\n");
> +               ret =3D KSFT_FAIL;
> +               goto exit;
> +       }
> +
> +       if (procfs_entries->count =3D=3D 0) {
> +               ksft_print_msg("No entries found in " ALLOCINFO_PROC ", s=
kipping test\n");
> +               ret =3D KSFT_SKIP;
> +               goto exit;
> +       }
> +
> +       ioctl_status =3D get_filtered_ioctl_entries(tags, filter, fd, 0);
> +       if (ioctl_status =3D=3D IOCTL_INVALID_DATA) {
> +               ksft_print_msg("Trouble retrieving valid IOCTL entries, s=
kipping.\n");
> +               ret =3D KSFT_SKIP;
> +               goto exit;
> +       }
> +       if (ioctl_status =3D=3D IOCTL_FAILURE) {
> +               ksft_print_msg("Error retrieving IOCTL entries.\n");
> +               ret =3D KSFT_FAIL;
> +               goto exit;
> +       }
> +
> +       if (!match_entries(procfs_entries, tags, false, false, true, true=
, true))
> +               ret =3D KSFT_FAIL;
> +
> +exit:
> +       close(fd);
> +freemem:
> +       free(tags);
> +       free(procfs_entries);
> +       return ret;
> +}
> +
> +static int test_filename_filter(void)
> +{
> +       struct allocinfo_filter filter;
> +       const char *target_filename =3D "mm/memory.c";
> +
> +       memset(&filter, 0, sizeof(filter));
> +       filter.mask |=3D ALLOCINFO_FILTER_MASK_FILENAME;
> +       strncpy(filter.fields.filename, target_filename, ALLOCINFO_STR_SI=
ZE);
> +
> +       return run_filter_test(&filter);
> +}
> +
> +static int test_function_filter(void)
> +{
> +       struct allocinfo_filter filter;
> +       const char *target_function =3D "dup_mm";
> +
> +       memset(&filter, 0, sizeof(filter));
> +       filter.mask |=3D ALLOCINFO_FILTER_MASK_FUNCTION;
> +       strncpy(filter.fields.function, target_function, ALLOCINFO_STR_SI=
ZE);
> +
> +       return run_filter_test(&filter);
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +       int ret;
> +
> +       ksft_set_plan(2);
> +
> +       ret =3D test_filename_filter();
> +       if (ret =3D=3D KSFT_SKIP)
> +               ksft_test_result_skip("Skipping test_filename_filter\n");
> +       else
> +               ksft_test_result(ret =3D=3D KSFT_PASS, "test_filename_fil=
ter\n");
> +
> +       ret =3D test_function_filter();
> +       if (ret =3D=3D KSFT_SKIP)
> +               ksft_test_result_skip("Skipping test_function_filter\n");
> +       else
> +               ksft_test_result(ret =3D=3D KSFT_PASS, "test_function_fil=
ter\n");
> +
> +       ksft_finished();
> +}
> --
> 2.54.0.545.g6539524ca2-goog
>

