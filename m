Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12DA4606A330
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 02:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=F2gaGqHO
Received: by kanga.kvack.org (Postfix)
	id 78CBA6B05B2; Sun,  8 Nov 2026 21:33:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73D766B05B3; Sun,  8 Nov 2026 21:33:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62D5C6B05B4; Sun,  8 Nov 2026 21:33:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 43DF86B05B2
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 21:33:00 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B422714059B
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 02:32:59 +0000 (UTC)
X-FDA: 85414008078.20.FF4E7FC
Received: from mta0.migadu.com (out-64.mta0.migadu.com [91.218.175.64])
	by imf02.hostedemail.com (Postfix) with ESMTP id D4C7080005
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 02:32:57 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=F2gaGqHO;
	spf=pass (imf02.hostedemail.com: domain of xu.xin@linux.dev designates 91.218.175.64 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794191578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NTJQRFg4ZLfC+WrQK17Fwq2xbU+TlVAHwMAwagSHegE=;
	b=SsRqtYW4bSSkSbQXz2/qpSZ3TcN81hcV7XEoxH8/uEhfTO/9L4HcOC3BxZlrX8IXbko0fE
	Ri+w2eJEU6AwSPOWwCMkBUOLXc1+fXBmjWoPzdotIMD5upxjKjcKLRhzHQqvh8DPXhDABE
	oTWbaM7/98wwdqIYpxrv887hUSy/itM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794191578;
	b=rHH+144vs3Lp7U5HyoCAfsuMFRPZAGex2OIB4xZIQSdmVOcBKr8d6UZ/ZMIUMXpYdbJzn0
	90CTrQta4OcTZbxqvaquseAvov/sLa9PwoI8kwcSWBeLOJ2vlDoibZ9sys8hcDbN66WFDJ
	Z/VB7oNSeqwUvY8OHoZXjbpOL9WJE/c=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=F2gaGqHO;
	spf=pass (imf02.hostedemail.com: domain of xu.xin@linux.dev designates 91.218.175.64 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=+0SMLJkywubB1aX8z8chXAoTRSPPEPx3GuRAB7UvFQQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794191576; v=1; x=1794796376;
 b=F2gaGqHOZ1AzwzNGFTyHvBkAEUf7G89vTgOoeIwbAckvPxfQhqVMkBB2kH3sUGFDcjEKtIGH
 twNceq0jMlUWbbHmoP6jAGAwuYbnLtgfqPYgo0/JatIYj8+eAiR7KbcPZVs8NZG0Za0JiFI4uze
 3JZQGOjOtF/5i7JjuUMbxc6w=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 87ec61e94bf44d6f;
	Mon, 09 Nov 2026 02:32:56 +0000
X-Mizu-Trace-ID: 87ec61e94bf44d6f
X-Migadu-Flow: FLOW_OUT
Date: Mon, 9 Nov 2026 10:32:45 +0800
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
Subject: Re: [PATCH v4 4/5] selftests/mm: move waiting for KSM full scans
 into a helper
Message-ID: <avEwza7YqonhwgO+@dgvxl46587.localhost.localdomain>
References: <20261108-bug-mm-ksm-smart-scan-align-skips-v4-0-86be8fe77e7a@gmail.com>
 <20261108-bug-mm-ksm-smart-scan-align-skips-v4-4-86be8fe77e7a@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261108-bug-mm-ksm-smart-scan-align-skips-v4-4-86be8fe77e7a@gmail.com>
X-Stat-Signature: e7b317m6dsqasxkmnc1w33bky9i9431x
X-Rspamd-Queue-Id: D4C7080005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794191577-721444
X-HE-Meta: U2FsdGVkX1+kT53pc+itCOP5q+CKszUafhora6k/jX84EjLsiNAV+XpsD5X2SIwIE4jCop3DNQupiKbgk7UimD1gsaZ4zypOQxFQ3hKPFBv4xaezSjm1GIJiRRlG3v3xvDPfSw/iLroe+PZK+nu7gBnbWHQrKwiB/oq8JVPnb/5v/phRiuZYBJJas/hR39Y9GExN4cyUAdYyemOX8xUzzS9RFSf5Uu41RMsi1myvC4ZR25ipA9qJx0kFE8efoM4RP66QdWjGaTNC3JudzLZTcJFp7T7aMEKSwEvOQSkWlvaoW4HUjeDbxlQ85OnRE/RjZ0U2kHP547nM5Qx6JQNsqJ/3DuLD0+Xeq4dFX5x8R3qMVzt5grhb64SjNzlwLM7qWb+uecvnyyPeNfvo2P9xHL4fMVM9qDh7L9+Y84YL3hHS117ninUnaE6bmCC+Ma2uUQkwU00U2NRMVD4+Fb2iYtLpDiL7l/FVXEElvUFkMT9vDaDLoh0bmrMYZKaxBqVWlTnNVdgLxD7p6T8cSd1gKRxwHoE6rc2bAB3LVdPdBrbXd3ppB22un2NA6tVETKMTFhqaWn0XAiyAiGRpI3cAYLr91DDtzISnNvOnAc4clO9nkNKwgWqNqmLWsTB9OBxKpVV/rU6+z7BkGWTI93oTDf/kkOrFmP2nsSyI1ckU4dwbl3szclH3pukFZUyWDCw6oGZR0LSk6P5k0yQebZ6CI2FlyRNwyLI3gBTjcZqFRdHGZ71x0yqT/A1Ig7+YgHYg0QSi/p/dFwzbF8YTIFdWiC0tHXowN/3kQPCANEHRCyfrVNycmtmTYfGDF+rSaarO9sIdlB+s87+SELd2Z/ig/7gzLhCN5xfPDhmHR5lNwqi3ReQExxRiPb69njmQrM8i3eLT8QXx7ZJJUfrt+KagEyhvUWQTNu4c3lS7TdAQjsnbEBlX/YFMJ3rIjeFJyrX3bEZblW9IBhSn+YhWEfW
 vLaWWKKT
 9vtOZuc4y/HsMHcCGWq0YChSUuWE6Ut0mZn+ar3JUdi7qUOqr6C2uP020mxADO+ev9aL8pYUuch+uSXHHepi69CMuaAAic4cVjvbc2UstnJFCv95CgUpAxI1uUjr9dtVXAOXu0fg8s6jfqs4fFHLsp/IddYrqFNoLq013xCyWxa1aJV7uktdXL5J081409TDO7roOZftPjvkPAinc0AHgV+UZNzVHfb1dNpdBZxBTmAaxTf/iYIELcBKvDnPgi2pq3cldDDhTWQObuWc5N9IFfD37L1hMALXIbQ8ITy/ZPOJRk/cQzh0keKkiLa7GWU6K2ybihTI5rHs42Kg0qmwo4so5sYJwfoVzqM8MDXboEwpjbmGTSzhubjZ/rwV4CNdmmivhADxCJFKFoSBju/nOkg7bgWJ7c5BGNQZD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 08, 2026 at 08:22:53PM -0500, Qiliang Yuan wrote:
> ksm_start() enables ksmd and then polls full_scans until two more full
> scans have completed, so that any merging that can happen has happened.
> 
> There is no helper to wait for a number of full scans while ksmd is
> already running, so a test that needs one has to copy that loop.
> 
> Move the loop into ksm_wait_full_scans() and make ksm_start() call it
> after enabling ksmd. The count is now read after ksmd starts rather than
> before, which can only make ksm_start() wait longer.
> 
> Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
> Tested-by: Andrew Morton <akpm@linux-foundation.org>
> Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Xu Xin (vivo) <xu.xin@linux.dev>

> ---
>  tools/testing/selftests/mm/vm_util.c | 31 ++++++++++++++++++-------------
>  tools/testing/selftests/mm/vm_util.h |  1 +
>  2 files changed, 19 insertions(+), 13 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
> index caea045fa7d46..8184691211acc 100644
> --- a/tools/testing/selftests/mm/vm_util.c
> +++ b/tools/testing/selftests/mm/vm_util.c
> @@ -992,35 +992,40 @@ int ksm_use_zero_pages(void)
>  	return ret == 1 ? 0 : -EIO;
>  }
>  
> +int ksm_wait_full_scans(long nr)
> +{
> +	long start_scans, end_scans;
> +
> +	start_scans = ksm_get_full_scans();
> +	if (start_scans < 0)
> +		return start_scans;
> +	do {
> +		end_scans = ksm_get_full_scans();
> +		if (end_scans < 0)
> +			return end_scans;
> +	} while (end_scans < start_scans + nr);
> +
> +	return 0;
> +}
> +
>  int ksm_start(void)
>  {
>  	int ksm_fd;
>  	ssize_t ret;
> -	long start_scans, end_scans;
>  
>  	ksm_fd = open("/sys/kernel/mm/ksm/run", O_RDWR);
>  	if (ksm_fd < 0)
>  		return -errno;
>  
> -	/* Wait for two full scans such that any possible merging happened. */
> -	start_scans = ksm_get_full_scans();
> -	if (start_scans < 0) {
> -		close(ksm_fd);
> -		return start_scans;
> -	}
>  	ret = write(ksm_fd, "1", 1);
>  	close(ksm_fd);
>  	if (ret < 0)
>  		return -errno;
>  	if (ret != 1)
>  		return -EIO;
> -	do {
> -		end_scans = ksm_get_full_scans();
> -		if (end_scans < 0)
> -			return end_scans;
> -	} while (end_scans < start_scans + 2);
>  
> -	return 0;
> +	/* Wait for two full scans such that any possible merging happened. */
> +	return ksm_wait_full_scans(2);
>  }
>  
>  int ksm_stop(void)
> diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
> index b5d59729d4327..7e00030077d2f 100644
> --- a/tools/testing/selftests/mm/vm_util.h
> +++ b/tools/testing/selftests/mm/vm_util.h
> @@ -162,6 +162,7 @@ void *sys_mremap(void *old_address, unsigned long old_size,
>  long ksm_get_self_zero_pages(void);
>  long ksm_get_self_merging_pages(void);
>  long ksm_get_full_scans(void);
> +int ksm_wait_full_scans(long nr);
>  int ksm_use_zero_pages(void);
>  int ksm_start(void);
>  int ksm_stop(void);
> 
> -- 
> 2.43.0
> 

