Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B0B6606A326
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 02:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=K6jaWJDt
Received: by kanga.kvack.org (Postfix)
	id 5D97F6B05B1; Sun,  8 Nov 2026 21:29:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 589EE6B05B2; Sun,  8 Nov 2026 21:29:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A0806B05B3; Sun,  8 Nov 2026 21:29:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2D8996B05B1
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 21:29:38 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A0D8E1C3147
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 02:29:37 +0000 (UTC)
X-FDA: 85413999594.19.5F404B1
Received: from mta1.migadu.com (out-88.mta1.migadu.com [95.215.58.88])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8D90A180003
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 02:29:35 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=K6jaWJDt;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of xu.xin@linux.dev designates 95.215.58.88 as permitted sender) smtp.mailfrom=xu.xin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794191376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=izPkdOWGD7c9dnxT4q6ljMe1uQrZM1waWSuUYS9fH7I=;
	b=UaqlTeePtjRf4usUnkd2LTVga8wKafahANYE6ocylpRKnt1Gw9kotvRjwcSQZbb2Eyg3v+
	/JWxy/2LNOto3DD/K2OOdqxxheSuaCjOFtPL7KqZREcY1+esOrYtZi5OJEJFLelfJHkL3S
	mcKvPTa2X1xCHR0E44BlphgvMJq3bvo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=K6jaWJDt;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of xu.xin@linux.dev designates 95.215.58.88 as permitted sender) smtp.mailfrom=xu.xin@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794191376;
	b=Z97kY+oQneEJ4L8efNtYmMDw/eNdJVKEEHITWjO2DpYyZabCu9fD4OsEwpcqjVPg2PZPtw
	wpjIMzvdbPHG1vRRhSpgNEyOubZ+XAOWIDnsrY033i+KaG3idoC0eReH6X3KB+GLzTRYR0
	lFD59fbrzpSyOhxm8+9CvOXNxhCoM6E=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=6Rwe5/vNZe/KK5IEYNJSCqaEF8U9Kcua9SWWSgmnS+o=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794191374; v=1; x=1794796174;
 b=K6jaWJDt6QKiOHiP6LT76nlBNWyXcA+2wK7tlinrhHzsNd/h7WsRGQJHn0LpYR/T7FuXW8Pe
 Uh+Q/nCaaSs9ulCDCza1iXwCURyR2MPFGkTF4E5i72eTmwxsiEVVWiS4eiFC+ndjZYYk1w3Y0Bo
 zlJtCW+yIlExZW/vHxa/ws+Y=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id f32e565902faf312;
	Mon, 09 Nov 2026 02:29:33 +0000
X-Mizu-Trace-ID: f32e565902faf312
X-Migadu-Flow: FLOW_OUT
Date: Mon, 9 Nov 2026 10:29:18 +0800
From: "Xu Xin (vivo)" <xu.xin@linux.dev>
To: Qiliang Yuan <odys.yuan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Stefan Roesch <shr@devkernel.io>, Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH v4 3/5] selftests/mm: fail KSM helpers on short reads and
 writes
Message-ID: <avEv/kARsXK09QB4@dgvxl46587.localhost.localdomain>
References: <20261108-bug-mm-ksm-smart-scan-align-skips-v4-0-86be8fe77e7a@gmail.com>
 <20261108-bug-mm-ksm-smart-scan-align-skips-v4-3-86be8fe77e7a@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261108-bug-mm-ksm-smart-scan-align-skips-v4-3-86be8fe77e7a@gmail.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8D90A180003
X-Stat-Signature: u4j7a3b8ptw4rtaw7itgtrqgik1gdxq1
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794191375-345931
X-HE-Meta: U2FsdGVkX1/fgj0c8uqUpkIhNPGzdUx/IAI/+9w+jkdihk7ynW8hnwi5q4zcEqgN3r0fzwoZd0PGlMPPyIAOKCIASL5iD2l6inMZLyJVyw7PNRNxkaTb4izhiHzhmOSaxQaaujLOW4beG5o8Iq1+N8hSWr1/PaygSP6B679or7tSqRYB6oqPgxNqaQn6wv27e3Xu3/RvRBgEsQF5suJNL5ubcz7CpyQkxco49L7kZmbe6Jl8bKe1i2GhMoxMMjEt6N17RZpZW667vvttzgxSd2uA5PaPWYsU6pBBvA2wCQHuiD5lzL36J4QYqIhfOPi3BnUvdCX0eXwcCERkiJ+Mle+hesjGU3IJnnFQBqZsxpr2NvVTow1hQGjvtxpsZFtGAunDy+2tt8SCY78QRa0MMxEBPpFxIA7fdzSN5LN2NdWb1H76MUGNLrgpD32fnMzjDfnum7eOVFTNqlwimDH4nPe9BuR5yKNrZgBpGtXS43s90Hwb1o+l+e0uZt738Xdzek5TWrR+/6Enpv/HR9py1706M3QoaSZNwLNLiOLcWmmpP4FFb/G/PEHkOfbXuqBzYIgrD6npcvcAjpBcXGpJ87acOMbVywj2DcQTqSqafBJOJoWuCTZCxeGs24PavFyxNEehuogqm7ehsEmpqAiv5HYiDFLyk619uzBbt40flO1cEuzKAJX9v/NcADAU3McZbuNibyp04C18xrMZNHKE7gCcSx464/8mqdClMZX5VPmLSDDck2SthWzVtB+phRiKibqn2KTK/V7HxSvdO1HMHjjNoPoNPBEVWcIixhY/ke68GieaTIpl3SJgvGpQV2FThQ6MXcldwW0n2aW9/2YOknOhFNNv3zLHMkrBfmoYu10htsRol6KHvR4eMF5PFBMCgVCF6ipk6CYs49sO9m1CEhegSbG/t0MLFJnhS9r6h2dTr0TomFI1io0BLpsi46BNvg4sLu+cmZWR9Tg+RCz
 Kq8T0Rbz
 P3eXklnVxaONPXxS043dG5/91yxt8jtrYNLdcFXQSoUpZ3u2jeNXZ4+Ytcj/x30/k3y2jTZMa5gGbigrkrmYGKYAkZVHNAs2EWiOXWxmzmLhE8V6Rlld8kYUaG4gjmwb7fvzpnA64xzHMPowCQu0TMeqNATHUyivNyPP3ZqZFb+eJOYGePuRYO8E0ldHjQHSfSYsw+KTVq8ImTN2QBEUmq5atB6kwC448CXlnDkXtYqdQQSZkyXgVLX3/++oCg/oHFddjegh43lGcVu2Hca1IfDcsdCWs0C2OKwoz6DCna4pMzfQF3vmYOJ2uc3yAbUQed2IGtFYtf6cyzeg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 08, 2026 at 08:22:52PM -0500, Qiliang Yuan wrote:
> The KSM helpers in vm_util read and write KSM's sysfs and procfs files
> with a single pread() or write(), and return -errno when the call does
> not transfer what they asked for.
> 
> A read of zero bytes or a short write leaves errno at 0, so the helpers
> then return 0, which their callers take as a value of 0 or as a write
> that took effect. A short write of run makes ksm_start() wait for scans
> of a ksmd that never started, a short read of full_scans makes it wait
> for scans that never seem to complete, and short reads of
> ksm_merging_pages or ksm_stat and a short write of use_zero_pages make
> cases fail that should have been skipped.
> 
> Return -errno only when the call fails, and -EIO when it transfers less
> than asked, so that callers skip or fail as they do on other errors.
> Forcing each short read or write with an LD_PRELOAD shim on
> ksm_functional_tests:
> 
>   short read or write of   before                    after
>   run                      cases fail, then hangs    all skipped
>   full_scans               hangs in the first case   all skipped
>   ksm_merging_pages        9 of 11 cases fail        all skipped
>   ksm_stat                 zero page case fails      zero page case skipped
>   use_zero_pages           zero page case fails      zero page case skipped
> 
> Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
> ---
> The checks come from 93fb70aa5904 ("selftests/vm: add KSM unmerge
> tests"), 3d0745e59c84 ("selftest: add a testcase of ksm zero pages")
> and 42096aa24b82 ("selftest/mm: ksm_functional_tests: test in
> mmap_and_merge_range() if anything got merged"), and b27f292de6b1
> ("selftests/mm: put general ksm operation into vm_util") turned the
> use_zero_pages check into one of them. There are no Fixes tags, as
> only short reads and writes forced with the shim hit them, and the
> helpers are in vm_util only since v6.18.
> ---
>  tools/testing/selftests/mm/vm_util.c | 22 +++++++++++++++++-----
>  1 file changed, 17 insertions(+), 5 deletions(-)

Reviewed-by: Xu Xin (vivo) <xu.xin@linux.dev>

> 
> diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
> index 515031b8283da..caea045fa7d46 100644
> --- a/tools/testing/selftests/mm/vm_util.c
> +++ b/tools/testing/selftests/mm/vm_util.c
> @@ -920,6 +920,8 @@ long ksm_get_self_zero_pages(void)
>  	close(proc_self_ksm_stat_fd);
>  	if (read_size < 0)
>  		return -errno;
> +	if (!read_size)
> +		return -EIO;
>  
>  	buf[read_size] = 0;
>  
> @@ -944,8 +946,10 @@ long ksm_get_self_merging_pages(void)
>  
>  	ret = pread(proc_self_ksm_merging_pages_fd, buf, sizeof(buf) - 1, 0);
>  	close(proc_self_ksm_merging_pages_fd);
> -	if (ret <= 0)
> +	if (ret < 0)
>  		return -errno;
> +	if (!ret)
> +		return -EIO;
>  	buf[ret] = 0;
>  
>  	return strtol(buf, NULL, 10);
> @@ -963,8 +967,10 @@ long ksm_get_full_scans(void)
>  
>  	ret = pread(ksm_full_scans_fd, buf, sizeof(buf) - 1, 0);
>  	close(ksm_full_scans_fd);
> -	if (ret <= 0)
> +	if (ret < 0)
>  		return -errno;
> +	if (!ret)
> +		return -EIO;
>  	buf[ret] = 0;
>  
>  	return strtol(buf, NULL, 10);
> @@ -981,7 +987,9 @@ int ksm_use_zero_pages(void)
>  
>  	ret = write(ksm_use_zero_pages_fd, "1", 1);
>  	close(ksm_use_zero_pages_fd);
> -	return ret == 1 ? 0 : -errno;
> +	if (ret < 0)
> +		return -errno;
> +	return ret == 1 ? 0 : -EIO;
>  }
>  
>  int ksm_start(void)
> @@ -1002,8 +1010,10 @@ int ksm_start(void)
>  	}
>  	ret = write(ksm_fd, "1", 1);
>  	close(ksm_fd);
> -	if (ret != 1)
> +	if (ret < 0)
>  		return -errno;
> +	if (ret != 1)
> +		return -EIO;
>  	do {
>  		end_scans = ksm_get_full_scans();
>  		if (end_scans < 0)
> @@ -1024,7 +1034,9 @@ int ksm_stop(void)
>  
>  	ret = write(ksm_fd, "2", 1);
>  	close(ksm_fd);
> -	return ret == 1 ? 0 : -errno;
> +	if (ret < 0)
> +		return -errno;
> +	return ret == 1 ? 0 : -EIO;
>  }
>  
>  int get_hardware_corrupted_size(unsigned long *val)
> 
> -- 
> 2.43.0
> 

