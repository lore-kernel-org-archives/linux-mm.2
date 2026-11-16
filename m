Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2969606A339
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 04:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Jw0iSV5Y
Received: by kanga.kvack.org (Postfix)
	id E8A946B00EF; Sun, 15 Nov 2026 23:19:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E623F6B05B0; Sun, 15 Nov 2026 23:19:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9E9B6B05B5; Sun, 15 Nov 2026 23:19:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BBF2D6B00EF
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 23:19:20 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 426FB1C41FA
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 04:19:20 +0000 (UTC)
X-FDA: 85439677680.22.3A4666E
Received: from mta1.migadu.com (out-128.mta1.migadu.com [95.215.58.128])
	by imf09.hostedemail.com (Postfix) with ESMTP id 22FB9140005
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 04:19:17 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Jw0iSV5Y;
	spf=pass (imf09.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.128 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794802758;
	b=5otady3NKu0km3JpxPpi/NiipIr/W/ypLhox/+GPz9wn7+m2c4rsJeCf2LWqNs1xFdiMrf
	pSl1nZC8dVLxolMIbZ/COtL8j0MiHD9CWzY34kqCLMKLfDWtutOSgyx0Srn9t1fY3W4b56
	pPIlArO93LwzXGzrO3a6SS6j4dnm58c=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Jw0iSV5Y;
	spf=pass (imf09.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.128 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794802758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n4CDV4ziRFU3xddHncpYnLzq3A+HLPidciJ1bfu5cIk=;
	b=8F2cXs16/R+Bj1F61qVvPBzKogSB/KU9cbozEQFm6OtWaTSn0d/Nj2hYf3ulanC3LHD9nh
	ajDWJQWcXTuJHtPFIw5jk07UKLw490+/9XNSwbWw2jkFNoiZ3nSVyMS5zvBIUJ2gEs9+4r
	vX/cDxyLa8gBsLEQ3hPKCNK5mVZtuCo=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=IjpKErh6Re8z+1/3lW8pFvWGsn41vSm3orTI4RjKMEE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794802756; v=1; x=1795407556;
 b=Jw0iSV5Yzt7XlM7CPt8TBpBWyib0JnfRWnaLD39IkMnizBJ8ngyyPVR3ljoABA4N2yRb199j
 8QtSD2okD/RlDSshHDqP5dFxT5xPa9z+H75Hahv9tzUP+lT5D9pCDFtf++YjQ5NFdt6p2PdaPXw
 QtW+ZinnBn3t3hBT/+TzKOmg=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 59a289117738f648;
	Mon, 16 Nov 2026 04:19:16 +0000
X-Mizu-Trace-ID: 59a289117738f648
X-Migadu-Flow: FLOW_OUT
Date: Sun, 15 Nov 2026 20:19:12 -0800
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Yingjie Wang <x-professor@outlook.com>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	Manfred Spraul <manfred@colorfullife.com>, Alexey Gladkov <legion@kernel.org>, 
	"Eric W . Biederman" <ebiederm@xmission.com>, Vasily Averin <vasily.averin@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, 
	Michal Hocko <mhocko@suse.com>, Alejandro Colomar <alx@kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, 
	"linux-man@vger.kernel.org" <linux-man@vger.kernel.org>, 
	"linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v5 1/3] ipc/sem: account dynamically allocated sops
 arrays to memcg
Message-ID: <avqD2Z3KJwPsCcVG@linux.dev>
References: <cover.1793250194.git.x-professor@outlook.com>
 <07d9034ec1fb5b6fd5eed2cf60ef3c84d5149e51.1793250194.git.x-professor@outlook.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <07d9034ec1fb5b6fd5eed2cf60ef3c84d5149e51.1793250194.git.x-professor@outlook.com>
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 22FB9140005
X-Stat-Signature: n6x3i6jotuw1ybr575zuqkttgmocr1eb
X-Rspam-User: 
X-HE-Tag: 1794802757-104772
X-HE-Meta: U2FsdGVkX18ZEXapmOEw7mwu8Glwcsm6/keivgzeZSrN9vDW81C0BNByL8bZhQSPLs5zYERDjmz0ZcDsO+BygvgvSAA0CoZpProPezQ6q/XETBlfIi/BwCEOiD+isNY6mB0XtdznqAwxXxrtPNaLGZNymOJmPkczaI0gojVhJS8tTJKiDnbazFDDDlm4Hg1kIpj34n2ac5XQGTtHDNjMtcftEJVSul4/OScCOIXjd4h7x3iRBxxzLMscwYvuF13yN20jHru55o+mfaPfpM5mP13P5aRuwWge56eexs8D0qN8I//2f6e99kqI8Dvw4L/Tj7epH/rsepQA/Dz4g5mgqjGPPVukIkij4QFOpRwi2+bom4IV1mN49yvPvQ6G4rbwhrrXa27Lpy+IA/HkiC07AC2NQryf0gtS9uM3t7bcSrh8atipCFCrpyhcd0ShdGxCcWcSvO5YUFS6dyfJxD76zN+SCaRpwnaFk5TD57Ia1pIu/E/Sl0cWGBp5zJMRh81gZyWy9i2gAbV5Dcwc9eodZ33HdX4QYliceAV/5F4CopCaBWbskxIvFBm1YSRmUOPyQc/yLTTdLJ44qq1HfakSnYDs+geNIj+lwHX7odTycm1EBe2m5/wSgwV+QeMwPK5VLrYE0kvwWpeutpM9sdb5+mDaldgi3Oyvu0akH+ml6dEVpdI2YnNVGp4I9cgifOfgiQfMu9qbA3Fv/l7DLbhw+BlIvblcVdbXwy7/h9kQ0OKQS+q/2G6/HWMyx39s1Jsjs1AOhhnA4JkrC5Z1qkmn88VXxQeops3QWZi7F9+XfCkbLeLrgQ5DxLRZOeqlKO88TS+qJBRPI8qoVcAbho0v4WePt6JIfLFaKN/ORAwXLRFhV+VYfs336fa7BkqK0UcLEqloa+ZFucKHe5zwRMwRBAMOYPbt+L9UnzVl78L5EWrQ7wTL5Oepn/UDsmr8pfMw+7O6KD0zIfMsFtwI6L/
 0PFsnHd8
 LNfherDRhay1lyHeUlGfRvmrrrnQ4+LNg2Lu3EEtX7apI+ir42l7R2ADLB8BkOCsQF93tacwqi15phfrKrzAM4N5nWk4IH83NQ/BjGmoeQ83ZWx1mV/y8AYH4edLpnKMp+RSfF/4gHIvMzrB65KLKU216oa+jhN8eBAMOTZrh76CDERjiApCwtlXrFOK0CdpLKaSn2PRwASe7yRqsOcvZYmW5TVrddmHLIJ4HN79MdDzycwLh0OSUL02b3kLyr2lXELsPM8iNvAk3hw1qIk99QfJT10YF06wtZ56ES+sTMekH9KzSZ7f4yB+CS3ACaJfzEYVnpuSDyGM31LWkTe0yE4j8ZErJOIUlrsOfKQC0aS4SStM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 29, 2026 at 05:03:25AM +0000, Yingjie Wang wrote:
> Commit 6a4746ba0619 ("ipc: remove memcg accounting for sops objects in
> do_semtimedop()") removed accounting based on the assumption that sops
> arrays would remain small, describing a maximum cost of two pages.
> 
> SEMOPM is a UAPI default that can be changed at build time and through
> the per-namespace sysctl. Commit 50ec499b9a43 ("sysctl: allow change
> system v ipc sysctls inside ipc namespace") made that limit tunable by
> IPC namespace owners without capabilities in the initial user namespace.
> 
> do_semtimedop() keeps up to SEMOPM_FAST operations on the stack. Charge
> every larger, dynamically allocated operation array to the caller's memory
> cgroup. This avoids a second size threshold and prevents a configured
> SEMOPM limit from expanding an unaccounted heap-allocation range.
> 
> In a 4-vCPU KVM guest, with the benchmark pinned to one vCPU in a leaf
> memory cgroup, accounting raised the median time per successful semop()
> call by 2.3% to 3.2% for 65, 500 and 1000 operations, compared with
> unaccounted allocation. An invalid semid, which allocates and copies the
> array before returning EINVAL, rose by 5.6% to 11.9%. The 64-operation
> stack path changed by at most 0.9%, and successful calls in the root
> cgroup by at most 2.3%. Each result used 21 samples from three boots.

There is no kmem accounting in root cgroup, do you know why there is an increase
of 2.3% there? 

> 
> Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
> Link: https://lore.kernel.org/r/20261016152609.2528805-1-x-professor@outlook.com
> Fixes: 6a4746ba0619 ("ipc: remove memcg accounting for sops objects in do_semtimedop()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Yingjie Wang <x-professor@outlook.com>
> ---
>  ipc/sem.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/ipc/sem.c b/ipc/sem.c
> index 5ec41de7e85b2..ea95cca5bb0ec 100644
> --- a/ipc/sem.c
> +++ b/ipc/sem.c
> @@ -2234,7 +2234,7 @@ static long do_semtimedop(int semid, struct sembuf __user *tsops,
>  		return -EINVAL;
>  
>  	if (nsops > SEMOPM_FAST) {
> -		sops = kvmalloc_objs(*sops, nsops);
> +		sops = kvmalloc_objs(*sops, nsops, GFP_KERNEL_ACCOUNT);
>  		if (sops == NULL)
>  			return -ENOMEM;
>  	}
> -- 
> 2.43.0
> 

