Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3FB8606A339
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 19:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=colorfullife-com.20251104.gappssmtp.com header.i=@colorfullife-com.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=wGl1C3d6
Received: by kanga.kvack.org (Postfix)
	id E39316B03DC; Fri, 23 Oct 2026 15:32:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEA546B03DD; Fri, 23 Oct 2026 15:32:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD84D6B03DE; Fri, 23 Oct 2026 15:32:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 971986B03DC
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 15:32:31 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ECC9A401F7
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 19:32:30 +0000 (UTC)
X-FDA: 85354887660.26.84AE856
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf16.hostedemail.com (Postfix) with ESMTP id E8B24180006
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 19:32:28 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=colorfullife-com.20251104.gappssmtp.com header.s=20251104 header.b=wGl1C3d6;
	spf=pass (imf16.hostedemail.com: domain of manfred@colorfullife.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=manfred@colorfullife.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792783949;
	b=KZdp5ZYj3MAFFpd5n01QwO/3U2npawlkaVuLNYng7s/M7culwQFToKO8DKF6VvkqpVYshC
	ew/00g7R2hbLeaatkvgiYAAbz7UgrjGEr59HxTcGuaOkHOuA8nWkkoHpUZeAEK9GiBg0bj
	TOYHWM1f6rMuCwjLwD/TOoHhu7iLFko=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=colorfullife-com.20251104.gappssmtp.com header.s=20251104 header.b=wGl1C3d6;
	spf=pass (imf16.hostedemail.com: domain of manfred@colorfullife.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=manfred@colorfullife.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792783949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xQ0ZY845r5Du+UUOa8gVSKQGxBME1IJCKr0CS/df4CI=;
	b=mSMM51vZY2QBWmBXYPpA/FCWuO8ZbnClNfolXNoqzncdf/Upng9HpkZF4buWVS7C16Aa/E
	jzqCxGcEyyBEGCIy117p9l/ksbZnpD44pogCqgD3xlXtm273J06kAUWG68iLFfSLdKmKqx
	bMcc3jQYbhAv+Rk4A4XxXhtjuDB0Djk=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4a3517554f7so2169855e9.2
        for <linux-mm@kvack.org>; Fri, 23 Oct 2026 12:32:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorfullife-com.20251104.gappssmtp.com; s=20251104; t=1792783947; x=1793388747; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xQ0ZY845r5Du+UUOa8gVSKQGxBME1IJCKr0CS/df4CI=;
        b=wGl1C3d6tlO6G4q9BbcNP6z8xhOznzUAF7xPDT6u0VSugnM2Ked4X4zbxCiINeL35P
         HyN4uI5MIAenzk/2lwHyUewMvYfNi1jKv+ZWizb28vK4muL0Mbw0gmiIDmpMgo32cI/3
         SGpSRtQncEQ9W1AWTRluX9JTMYzaMJY8MttKLRmqS69wMLf2jIFINAlb9yMLv3GyD+gM
         vdM7kEB6pJlBAmrK/1gsVOZBMq0kKqqlRLwwmQFLtEzdZjPqjeB764xEGlOrfoTvtCAw
         yMUmp0Z5LGKT+476Z1PqoUhG6dp9kkOUYJVlDfMB8F4SF2tbhoT2eHAOi/7g+3gDtTbR
         1k5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792783947; x=1793388747;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xQ0ZY845r5Du+UUOa8gVSKQGxBME1IJCKr0CS/df4CI=;
        b=Qz6PfTl8D6ycGBNwBVouak+Z+I/d/+GyPheoxCI4UCJ9dE7Qp53uTF4DmyWIkQQPzw
         TqCpi8sIVhCeg/idRyr4AP9tIVgDbK8X/jl5L+P+f9gUpZNbnuTix2RnkBpuJOnbk5Rh
         EjYHlqm4EKfxLvZ6UVQPgb8jlOZ+WjtuIhTqg3D/4f/L3qX9fmIDoZmG73pfmlR705f2
         J+Y1h+rNpak57pvW8S2DWXedrw8yDPNMV4lDcB+CS9dCOTbIpLRgNx1zmsRM3eUkRHtd
         ne64Mm27a9LfRZoUbXfq2mfDoTZqjl/3k0b40k2cUsqf12yNivwm7AUAFYHCz44qFGyL
         ifPw==
X-Forwarded-Encrypted: i=1; AKwUvByktFf2AasnaT+eVO+5PFQaDDKeToEhbvri+nSAHOYo1w6DSbm8wdWHseTRPstVKFnIQdlu+HfBaQ==@kvack.org
X-Gm-Message-State: AFq9FYIuPc6GJoPiQvfgyrAEB84wtrQnfEiBkqkbr19P3HnAEiJCoMwV
	mV7E/oGIxi2/Rrr74SFFWVk9WROCgBcBvO1IhC30vWA1OTnS4DWSUuciyRsKpTsEcQ==
X-Gm-Gg: AYBFou0kNxHEpX9gpMe7MRELH8DdK7erYimdsBe5Ta3Tp2gCA+gCZemZnV+7SoIX8gN
	NQbqQqiqZC4xM1hgyH7PZS/T432YI0afoHPb3H+NlMhbKOh0JDznvoJOQKTq0mt3aXFzjjxLNYS
	LMrXGSwO7acMkYLlqF+D6OicB/rw2a7aAwqCuKaA0+lkGXyElZSwvQGw6ioQStgZeqCma1gP6Fs
	QPXidGBJEGLNWq5AXrPzuWwYBzU400YDLTQQv4q/oXwKEzu3ef8XEGK6zObGpKqA8btsA57wJMp
	+rnKK+5wWkyJjHlaVIhZ81+u+uv8gb39OOLgwhjFVHgBrHtibBAkb+hQMVsuvOjuYLO+fqMfYya
	kJiJrz9wP3IlAMYRM5KTuGMz+TjC8cljaDfsG5RoMIEY2Mbipu74cwMrIv00pzBAh0+XWiHgysj
	m2ea5tEyMZ/bv5xMv/08VL7KzIWU8/UdjfzFRhOjvg4XFW/pBKoVTX1cZ1qiU3lAucMQ2xb9wQ1
	/4IN5npZSGOTd1O9OmzgCjPwkh8P9NUSI+dR6sXL7qYCh46oxx1JpriqT2+Hd1CAoVbFxbqrWIs
	2t79Rvu7XsZaF4+8ovRhc2ByqAQmriI3JPJKpjc5FCp2uRn0Vd5H2u+Zr7vAG0Hxk6JOp7umu3A
	M0MgH6h8GTw01vmk=
X-Received: by 2002:a05:600c:630c:b0:4a2:5ca:767f with SMTP id 5b1f17b1804b1-4a211c64f9emr57232995e9.4.1792783947346;
        Fri, 23 Oct 2026 12:32:27 -0700 (PDT)
Received: from ?IPV6:2003:d9:9707:8b00:3fa:3a3e:198d:ab69? (p200300d997078b0003fa3a3e198dab69.dip0.t-ipconnect.de. [2003:d9:9707:8b00:3fa:3a3e:198d:ab69])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a359fb08d5sm14180055e9.1.2026.10.23.12.32.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Oct 2026 12:32:26 -0700 (PDT)
Message-ID: <9a3aa73c-7b62-4f1e-983d-cf22d45ad86b@colorfullife.com>
Date: Fri, 23 Oct 2026 21:32:25 +0200
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] ipc/sem: remove obsolete SEMOPM fragmentation
 warning
To: Yingjie Wang <x-professor@outlook.com>,
 Andrew Morton <akpm@linux-foundation.org>, Alexey Gladkov
 <legion@kernel.org>, "Eric W . Biederman" <ebiederm@xmission.com>
Cc: Vasily Averin <vasily.averin@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeel.butt@linux.dev>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Michal Hocko <mhocko@suse.com>, Alejandro Colomar <alx@kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
 "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
 "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>
References: <cover.1792724953.git.x-professor@outlook.com>
 <cbd5dc183943d2177e5564f6e8ec92499836c7e5.1792724953.git.x-professor@outlook.com>
Content-Language: en-US
From: Manfred Spraul <manfred@colorfullife.com>
In-Reply-To: <cbd5dc183943d2177e5564f6e8ec92499836c7e5.1792724953.git.x-professor@outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E8B24180006
X-Stat-Signature: odqxbcm39xa8m3dmr15h7mute6mdm4yq
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792783948-593046
X-HE-Meta: U2FsdGVkX1+PbrXFxqUAA+5iM2V5yszTu8GPcnWKz73Jthsnbr5Ai5Pt0FC60X+7WDsi9n9Gvteok2u5YzQB5DdZR9O754Xm/yPrhYUp5quIZQ6PHj4divo+1Pp4q8ubJLJfNiltv1wHSnQXWPHJrxtmeM4URx77r0ZKClptCoJTFWqGCYUyIwBQDvI88iQA1kJh7iF5QV9MQKlprNkeokRHUrS3n3qISQe4+jOEmOEb3BW7ICK2x7PJf1pccH9Ar+F+y3MCJzLo/CG/g7A5qJB91ASWwAU/yQB3Khf1+Nv0PeCJMrLfTs/h2Sl8NDvjIHYGEv4tY8FSlbo7N9J6y4BL9MLMIQp2v2bTOm3oN8X0H/ikOe4YauBtxV1O65eVUHVOyMdw0WKKHwe1A1Jqe7znYl6w+OMe8ZK8ivv8iqtbT6PFhT/OspM4OidwioYmV5APIGgD3SbaSFVJGLa24Xj/VMJakOoEKvTWE7ItPpVgEnPWlFy6AKJnucG9JcVaGDa6jtPwlTzcGTbYIuvIAHDJW1XqBHPKt8XFzTO4O/mL801q8xVEXB5tfTRQ7vTHMjChMtOpPwZQsmKMyKqZSwPVnwPt8ysNHpKsI0MJFZw+VPn7GS2/zoDuAYwJeDjNbSO2V0EG7Fi/NxlWLueLN8RQ0a0bZZgDy78yGShzHu7HVAZkGsX/hPZOMKtOZcFkNITQbDo1WCUgufYq3fhGNb3fvnF5nBmqFrQG8ueY62yYHGQgIdNs8VJcJkLAj7fKAm/K42phD/g+S4UYeSjBsg+6/6UXuCNaEAV9TcNIZfa442k9+klUPJBNjzUQLXEieFW0maUAnVsK1duDsXKSi2qhqgPc2mFkBbTiQrWBfIE0FDcWNFbTT2709bLwB6zPEfKGdf0upF9s4CgFNeLP0H1kPTA/J+ipu921gx4ggOFmsX/frMFSQvwax5D8pSQAz3c/ZDSIlU/bH/zw4MN
 JnKDF+cc
 g9P99HASNB7W5Vl0uPtlTRJMyevVfD/2OZM8xW65MmCSdOXrE0T3aG/9Cv4BJfhkPAVjkxP6+RcytPpfyWyXcvgAkKJTis80HLD3/AxZAOm0aIgOK+tcUGzdRy4g22VF1ZNl7eFdEW93d5DoiECQIceEpQ35ZI/xZKQK+Afi5hOjwIzGpeCgkFLR9fGh5qgQnbWzDi6JYdsA9um6kXvF1qnrrLapvuGdLwW6mBtmTcjLTuKDt24aLe66HTAqEw14pENIQCgBCDRKKXL2LVYtqoz0jtOJt7KeWI47xLl7vTluCVDl9C4fB6vt+YLq5x+M/A9iwE0X3+UuKhPJPPuj+7IsjVtu9+wMZF443BlLGsW9cP+V1Dbjextx/XEeaWHvJ2S1yQUEV4p/Dpl0Vzb5xjHmZP2+kGLOUJo2A3NZR5kFKaqRXP/gZ2eAdmxFSvH4998hbEoaHRaa7QQRatc/Gnm18kl4+FfyyFjz3V7NostCIcxdzCms4rv4jp6yw8mMsBQ4V0fm1bq4gAaKdXaLiVyt1YA9d/MIAaxpwtMmRRzpfPJeGUVpRiuLMqg1/Xx8DAbkXn1ujYPsE2kxnMfeVL1zGdYOmQ6fvDTfOz8PFph/9CZo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Yingjie,

On 10/23/26 5:19 AM, Yingjie Wang wrote:
> The UAPI comment advises keeping SEMOPM at or below 1000 because a larger
> operation array may fail due to physical memory fragmentation.
>
> Commit e4243b8062c1 ("ipc/sem: play nicer with large nsops allocations")
> changed the operation array to kvmalloc() specifically to support larger
> configured limits, with vmalloc fallback when a physically contiguous
> allocation is unavailable.
>
> Replace the obsolete warning with a description of the compiled-in
> default and the runtime sysctl.
>
> Signed-off-by: Yingjie Wang <x-professor@outlook.com>
> ---
>   include/uapi/linux/sem.h | 7 +++----
>   1 file changed, 3 insertions(+), 4 deletions(-)
>
> diff --git a/include/uapi/linux/sem.h b/include/uapi/linux/sem.h
> index 75aa3b273cd99..cfd772f4c3396 100644
> --- a/include/uapi/linux/sem.h
> +++ b/include/uapi/linux/sem.h
> @@ -71,16 +71,15 @@ struct  seminfo {
>    * The values has been chosen to be larger than necessary for any
>    * known configuration.
>    *
> - * SEMOPM should not be increased beyond 1000, otherwise there is the
> - * risk that semop()/semtimedop() fails due to kernel memory fragmentation when
> - * allocating the sop array.
> + * SEMOPM is the default maximum number of operations per semop() call. The
> + * runtime limit can be changed through /proc/sys/kernel/sem.
>    */
>   
>   
>   #define SEMMNI  32000           /* <= IPCMNI  max # of semaphore identifiers */
>   #define SEMMSL  32000           /* <= INT_MAX max num of semaphores per id */
>   #define SEMMNS  (SEMMNI*SEMMSL) /* <= INT_MAX max # of semaphores in system */
> -#define SEMOPM  500	        /* <= 1 000 max num of ops per semop call */
> +#define SEMOPM  500	        /* default max num of ops per semop call */
>   #define SEMVMX  32767           /* <= 32767 semaphore maximum value */
>   #define SEMAEM  SEMVMX          /* adjust on exit max value */
>   

I think there is a conceptual issue, but perhaps it is today not 
relevant anymore:

The values in uapi/linux/{sem,shm,msg}.h can be adapted as needed: Just 
change the values to what you need, compile a new kernel and you have a 
suitable system, even without sysctl compiled in.

Your change breaks this: SEMOPM is both the compiled in value, and the 
implied limit when _ACCOUNT is used. If someone increases SEMOPM in the 
header file - suddenly more unaccounted memory can be allocated.
Perhaps there should be two defines: SEMOPM and e.g. SEMOPM_NOACCOUNT?

SEPMOPM_NOACCOUNT defined in ipc/sem.c, perhaps 500 or 1000.

And SEMOPM remains in the uapi header file.

Minor point: So far, the format of all limits is identical. Could we 
keep this?

#define VALUE 1234 /* <= 4321, due to whatever reason */

Perhaps something like:

> -#define SEMOPM  500            /* <= 1 000 max num of ops per semop 
> call */
> +#define SEMOPM  500            /* <= INT_MAX max num of ops per semop 
> call */
>
Reviewed-By: Manfred Spraul <manfred@colorfullife.com>
--

     Manfred


