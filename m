Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 537E8CD4F25
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 14:09:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC54D6B008C; Tue, 12 May 2026 10:09:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B289F6B0093; Tue, 12 May 2026 10:09:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A67C96B0095; Tue, 12 May 2026 10:09:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 99AE56B008C
	for <linux-mm@kvack.org>; Tue, 12 May 2026 10:09:12 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5155D1604FD
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:09:12 +0000 (UTC)
X-FDA: 84758949744.15.3956CB7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id A9044160018
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:09:10 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YXy7tjHe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778594950;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CtmAVH/fHRTtD+JkmxFCFZ5OoR+7oWP3QexqZth9Y3c=;
	b=ylyynFHG8XLJCX6zLbtT5uhRxRUmDuHzpUYOMRwzuV9tqwlBYBbYr63cTagB0mGmKwjUkj
	K/Uz6pAoJD5ZyDPKR6EqnE2E/zw5fl+sBF0+tJLX3kd/a0Ec9TNf01ibTWKFnzmKygXkve
	nQglzSAMlMRYo77Ib+pEXkQo+7PgW6Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778594950; a=rsa-sha256;
	cv=none;
	b=nM9T5Orma9xINGjcwpb/kqR1jvhuyAPhdb0Ncys1sjhPMwCBg2pEsBN69RnG+aVTiDsURL
	CH5VI8RYkLztLEx59zzeqgl58kMFEKteKrWcQVZ6LJ2xvn3efoLpkbn7yw1rJ+CtSWHoVj
	/oYGAoIPWRrugFuVv0gnZtRRSg5lYpw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YXy7tjHe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 151A462C4A;
	Tue, 12 May 2026 14:09:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEE69C2BCB0;
	Tue, 12 May 2026 14:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778594949;
	bh=kH+DBH602R/NCMQ8TNdgFnfzcA0HQ7TM7TcnLEWnzJc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=YXy7tjHeVafWgkoh9kZB1s2WPWxRJwh4XA7F5ZYdpJ6KoFS3923iDL7eSbj9ghHBy
	 WEnYBAPKilqVYayl34sHEjYVC69JVD9Bigj3GJC2RaIY1ftgbrh9AlP6r+Y5KuxvEH
	 VEBUpDmxRymvetc5ItvkvIldJvreqDWFy2vAt50XQmCaWnM6wZbEIpCBIJ4U4xoS3Q
	 yyMe5OzzolcfMf8q8KL5uKNv69XgqVgX/ToKmTXB6tY/CvMIbeoDm87e/Ey1ZfX7Jh
	 uAYA1JEJPmOrSKV6mCxTYTftUsfm9YswWSYMiyiSiBRTErbDFnidoWtLK6DPSJfBtC
	 8MRuSkpinkQ2w==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-kselftest@vger.kernel.org,  rppt@kernel.org,  shuah@kernel.org,
  akpm@linux-foundation.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org,  dmatlack@google.com,
  kexec@lists.infradead.org,  pratyush@kernel.org,  skhawaja@google.com,
  graf@amazon.com
Subject: Re: [PATCH 4/5] selftests/liveupdate: Add stress-sessions kexec test
In-Reply-To: <20260414200237.444170-5-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Tue, 14 Apr 2026 20:02:36 +0000")
References: <20260414200237.444170-1-pasha.tatashin@soleen.com>
	<20260414200237.444170-5-pasha.tatashin@soleen.com>
Date: Tue, 12 May 2026 16:09:06 +0200
Message-ID: <2vxzlddoafel.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Queue-Id: A9044160018
X-Rspamd-Server: rspam04
X-Stat-Signature: r87hdx5ad1u3xwgdszfookkmh74fkppi
X-HE-Tag: 1778594950-50890
X-HE-Meta: U2FsdGVkX18zwrjMTy0NIzAGMg7VOyg0u3XlRVrDJ7L6wbcmZPfTXltNoMd7kF6W4OLiAXe4JiDwIQaccn+J26D8DLDA/hSP2fB0Ia7Zdh4loCSUfid5K85Kasur1Blc5L8WrbyLWdahkPnrSFBIaQkFGqjnzxzQwfxCXUjCdR975kfosjjr5Htzu7K7O0XG6C0A2TQePfnGs5yfPAeALe+tsla8oKICWUesDdXpVSldrLjRUYbKljqQfk51uKd67RoXGm9/FxwFYrWrQ+8VATrP0qybhyw+tG1PZLfW3ELDIGssmrh2CVT/0g0GdWlO6qn7/Kwu9gmRf9OuwM1uf+GqZadtcRwSRWSrBbLldbqrMehSy4YXJpEsHj7s5PU+Btbl9+VI/Y6SU0LaPFHsHF+0Y5SwqORkaU1BQtBWw0I0hWqzo1fIO+LTxJltT/MZk/YZM4Wm+rLGx0g5W7/5M64n4sv+RgtGTJeuELN5QwofYRk4a7u1uVZnt2RQiVt4kI6Kk1rb6ItR9Dti72kvHHcFXdkiXGeCMhmGhpW8bUpEYDLVQk5Rb1oxq9xImb7vjHq+fdz2ruCDhxmVTfBhb4ANyp7qqFjaxYL0GifXOwVxIMZGtqAU4B/KYI//829I5Z43TC6GIy0njuJO5MkE9jgWg4JYe/MAgjW/f2xSFW4dhXRedgg2SyHD055ARONZFJgjkAIDMj+8hwRygMYs1vWBEgM5wwvuDlbstwOsWsvxpdCaXCcbzDgUVcjgMf7cV63xq7o/cTVwT5ezGQpdJ9qCqc+16hVLvn8x0rW9uaMliC0giI+ynt1vWHX69xW+fiv9EzKhlfgn5kC3FfHFAXVfMaiC30NVW5OXH/Vny4F/v87TV6ZvBkjk2c+b1D6Dn/l+dqwe9G1Qe99k9J6Tb0KlafpJhF9Wep3Td5i0B5NhrRazTk0b3Y1yzZaKe+ZeRJ6OVZycTyPeZPWlta/
 fBvgGuNj
 BK7x56vQKC8KP7YwTFuTk0ORhPfueeTRrnwJO9UNM3crwZxrb7epTsXhKjqBh+2rGq+03x2Jq8soOGyv7/xTHRwA52y/l4tuUyYnwLX5noWdR4PmTyeZJ83llKIu8itdlTBUbqQ0yGW52P4mFqclP+4ouRUSintrx9vOgkQ85RhxgUrERmj0kvu5cL15k4THazfKsKyJS+699Tenrb8+/Nc2/T1DPr5pyRzTzWTcvcMgpw20pc00R8QK+r4YsKyHzSu0NaIgo7V5aRSo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 14 2026, Pasha Tatashin wrote:

> Add a new test that creates 2000 LUO sessions before a kexec
> reboot and verifies their presence after the reboot. This ensures
> that the linked-block serialization mechanism works correctly for
> a large number of sessions.
>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> ---
> diff --git a/tools/testing/selftests/liveupdate/luo_test_utils.c b/tools/testing/selftests/liveupdate/luo_test_utils.c
> index 3c8721c505df..37c330b9bb36 100644
> --- a/tools/testing/selftests/liveupdate/luo_test_utils.c
> +++ b/tools/testing/selftests/liveupdate/luo_test_utils.c
> @@ -20,6 +20,7 @@
>  #include <sys/stat.h>
>  #include <errno.h>
>  #include <stdarg.h>
> +#include <sys/resource.h>
>  
>  #include "luo_test_utils.h"
>  
> @@ -28,6 +29,30 @@ int luo_open_device(void)
>  	return open(LUO_DEVICE, O_RDWR);
>  }
>  
> +void luo_ensure_nofile_limit(long min_limit)

Since you are adding this to luo_test_utils anyway, I think you should
do it in patch 3 and use it there too.

LGTM otherwise.

> +{
> +	struct rlimit hl;
> +
> +	if (getrlimit(RLIMIT_NOFILE, &hl) < 0)
> +		ksft_exit_fail_msg("getrlimit failed: %s\n", strerror(errno));
> +
> +	if (hl.rlim_cur >= min_limit)
> +		return;
> +
> +	hl.rlim_cur = min_limit;
> +	if (hl.rlim_cur > hl.rlim_max)
> +		hl.rlim_max = hl.rlim_cur;
> +
> +	if (setrlimit(RLIMIT_NOFILE, &hl) < 0) {
> +		if (errno == EPERM) {
> +			ksft_exit_skip("Insufficient privileges to set RLIMIT_NOFILE to %ld\n",
> +				       hl.rlim_cur);
> +		}
> +		ksft_exit_fail_msg("setrlimit to %ld failed: %s\n",
> +				   hl.rlim_cur, strerror(errno));
> +	}
> +}
> +
>  int luo_create_session(int luo_fd, const char *name)
>  {
>  	struct liveupdate_ioctl_create_session arg = { .size = sizeof(arg) };

-- 
Regards,
Pratyush Yadav

