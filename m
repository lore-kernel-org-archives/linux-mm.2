Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8B6BCD37AC
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 20:44:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BD206B0005; Thu, 14 May 2026 16:44:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 994276B0088; Thu, 14 May 2026 16:44:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D13A6B008A; Thu, 14 May 2026 16:44:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7E7BB6B0005
	for <linux-mm@kvack.org>; Thu, 14 May 2026 16:44:14 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0611C160329
	for <linux-mm@kvack.org>; Thu, 14 May 2026 20:44:14 +0000 (UTC)
X-FDA: 84767202828.09.2558416
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	by imf28.hostedemail.com (Postfix) with ESMTP id 285B8C0005
	for <linux-mm@kvack.org>; Thu, 14 May 2026 20:44:12 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=R7XboFye;
	dmarc=pass (policy=none) header.from=paul-moore.com;
	spf=pass (imf28.hostedemail.com: domain of paul@paul-moore.com designates 209.85.219.52 as permitted sender) smtp.mailfrom=paul@paul-moore.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778791452;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iIn517qMFa/72Ee/XGTDeeK9Cq6VJiGDpV2GCDJOS7E=;
	b=PF+5BqEjkuhylvLLqWbLEDqxzHd8xsAUJBThyQ1UUwqoUkzmjh+7ZplvkajEAa0A++jzHc
	0KkBIfwhv4FtooOuatI9GhYmIFcmFqRpUF9PxQ1q8MYLG01MdVqckyuvv2e7b8SUXM5XWf
	mIV6aTJvOeC2j9CpQoGlKYE1OCreNh8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778791452; a=rsa-sha256;
	cv=none;
	b=d6JSkA48/9k8CZOLd+oTHHJeGux1XTJ34POE4de+RZYcVK0KSl0D+/MWIDAHxiWyeVdZVY
	EXaqFeBOg9wmF8pggpPhlSIAfrg4haRQ1Y1sVv0KpCueXpAHUyEHSumaVrQs86OpAP++Uk
	aC8k76KME7cm9ej4QCPj7s3OQxjAK+I=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=R7XboFye;
	dmarc=pass (policy=none) header.from=paul-moore.com;
	spf=pass (imf28.hostedemail.com: domain of paul@paul-moore.com designates 209.85.219.52 as permitted sender) smtp.mailfrom=paul@paul-moore.com
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-8c921396e37so14076536d6.2
        for <linux-mm@kvack.org>; Thu, 14 May 2026 13:44:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1778791451; x=1779396251; darn=kvack.org;
        h=in-reply-to:references:subject:cc:to:from:content-transfer-encoding
         :mime-version:message-id:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iIn517qMFa/72Ee/XGTDeeK9Cq6VJiGDpV2GCDJOS7E=;
        b=R7XboFyeLR7p4VQ7piIs3yRQGv+mq3uVK7YodJmJjLsp53GfPeMunnZw8raEcRRYlS
         Acs/Iqgac8Pz2gTUWmtJRMMJTOub2BfWzHoxg3o/3w+eLrjUxC5NXuQgI4HGwdSafcs1
         0OFkhrRIlggyQNdc3UmmLe/YeFoOUvGVWDDLlOk2RZ4iaODn+jaqGaUX52l0aKVnxqA7
         69NOCCKMuTMzwJi6Z+SQLNH0+bstwYYDQ3yfiRglG7w49yilBfyNJAvQk+Z8OCwWxYTZ
         tOdD5FKfKwM+GAcGX4clDC5g9XBRVRmx6HOIYpg9aD3ocsOZJ5JJ1a41zckyMzZkxsXH
         gdzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778791451; x=1779396251;
        h=in-reply-to:references:subject:cc:to:from:content-transfer-encoding
         :mime-version:message-id:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iIn517qMFa/72Ee/XGTDeeK9Cq6VJiGDpV2GCDJOS7E=;
        b=LWK4iddffEyibx0H7OqfurMjIK7qCruALkthGHoKx/TWQqvFMxDNxMBZ4XPdEne0E8
         cmOl+chLNYzfPSd+ZGXUuIKP4Tve5Bu3gvv4DBTgXh4ZpY73XkgLeHu3C89OHx0Er9Yw
         FI1R/gdLE5DSQJgRqtth6ccoFH8A8OHj8M1S7rsZosScvD7PWuLdmgJu9Y5cjuasUV66
         mKZ/UFz/qLJhXvl8on3PgiIHnGMG5sLC7j2GhgpsgnjAQ4LLKCQolcXTjqEUrq63NFfk
         mWJsOB5HoUv99u+Hx4+NLqwabUhXVtrojpKcNlqsMj770TMJfahWC3GR9R4FqJiZuOJZ
         O00Q==
X-Forwarded-Encrypted: i=1; AFNElJ8nk9tUms9pU3N6mUY/AUAUiThP/wrhJhGmLICljxIFoziqGQQz6lqwC6vA0rD2A2pL63JUMYh/Aw==@kvack.org
X-Gm-Message-State: AOJu0Yz6TYr8vOvgyps0MgYZ9rU8EygCt6DhkzAuSaPq1qUdaM+iK5IC
	pvtn6AOvpVJoSSrbdM9Mv6s47tRfxfpnqwNh3CoLcQaQJg+CT1f0Fc5iHe5Y2Hs3jg==
X-Gm-Gg: Acq92OEFHnn+43IFSOIErC2MXa4tHcm5pMZaqeygSUxx4yZz9fENhwbHTpg+JFOnySY
	6lJPsv4dGYZ5840M0pQ8OApcNuzYI/l4ciqEk5DbSbpQs+aZv5RZC9h8OVrpUEL1zmz0AEiIWB4
	9MM0kF8yitohnLuo/CbWG5wDiSwQo2heukF5LnxLURLt79cc0fLgHF4rPDs4dbUG8/pqhoP4i80
	9cAGru0jGEFAvTWsUWvP9QXEdTYlN5YDlFbrvy/+thioUuJPOZ0V8vUmggTx7qz2R/WBeeoBm+A
	JNi6V5dxZYJsZE5SzUFFj9sgA+PpklUe+p7zrh2OrnZKNYkhHTbIt4Un8soGznByA5tkRhAvgh6
	H8/r6rocQP1olS+R8BB85L6N9Ynl29fy71GzjVoJxA9OcazqerCNkEu9pfkY506H2A8qZFvbchy
	b+w+kYbD9xgTfD93qCmHdtvtI0DUcFH9YpvxWwpy/dUCWf3zcYPmTag+kx93F0VM9+LVCSKMbDi
	DyN8as=
X-Received: by 2002:ad4:5e88:0:b0:8ac:b70c:8a9b with SMTP id 6a1803df08f44-8ca0f70f697mr20146116d6.44.1778791451056;
        Thu, 14 May 2026 13:44:11 -0700 (PDT)
Received: from localhost (pool-71-126-255-178.bstnma.fios.verizon.net. [71.126.255.178])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8c90c358539sm32474826d6.41.2026.05.14.13.44.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 13:44:10 -0700 (PDT)
Date: Thu, 14 May 2026 16:44:09 -0400
Message-ID: <16093a0278a6d7d1a0a8bc055c228bed@paul-moore.com>
MIME-Version: 1.0 
Content-Type: text/plain; charset=UTF-8 
Content-Transfer-Encoding: 8bit 
X-Mailer: pstg-pwork:20260514_1634/pstg-lib:20260514_1359/pstg-pwork:20260514_1634
From: Paul Moore <paul@paul-moore.com>
To: Albert Esteve <aesteve@redhat.com>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, Sumit Semwal <sumit.semwal@linaro.org>, =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, Benjamin Gaignard <benjamin.gaignard@collabora.com>, Brian Starkey <Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>, "T.J. Mercier" <tjmercier@google.com>, Christian Brauner <brauner@kernel.org>, James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, Stephen Smalley <stephen.smalley.work@gmail.com>, Ondrej Mosnacek <omosnace@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org, linux-security-module@vger.kernel.org, selinux@vger.kernel.org, linux-kselftest@vger.kernel.org, Albert Esteve <aesteve@redhat.com>, mripard@kernel.org, echanude@redhat.com
Subject: Re: [PATCH RFC 4/5] selinux: Restrict cross-cgroup dma-heap charging
References: <20260512-v2_20230123_tjmercier_google_com-v1-4-6326701c3691@redhat.com>
In-Reply-To: <20260512-v2_20230123_tjmercier_google_com-v1-4-6326701c3691@redhat.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 285B8C0005
X-Rspamd-Server: rspam04
X-Stat-Signature: 9nk6bdf9tuzxcje7mtezgrfato7ccbqy
X-HE-Tag: 1778791452-558171
X-HE-Meta: U2FsdGVkX19JsNrczOuBHd+zhmIEKEydsW6GlTGuwDFRrDNHbCKeRqfGWtgRMpbFvavMxHgAKRYoKd6BGna0VlAU903VnMYe83En40ziPydHAfoUmaPLdoq3eGYtItw4Qx+d8oIV/nO2k2LNogttwTTDEtzveBrOb4Y3fc8jvC4yuOX0AtDdYfwfGLStyHPfFSBLCn6XDxlzoqRrr+2GUyptUBZhGQlEZa460b1y9BipJtlZ+Ozt+NDDOthlPwBxwjLygC4r7gzn9jOBac5ZPEzbzA7DshTepmn2QyZRDVNoceja5lBMg8nLv39+pG0rZyvGZNSV5VfwrR/j/JOvun/ccJduEkV39gnw8suBKfK1ZFvLKITfhPBSmDzcmWxpTorev7Ff11IF5hhOVsbJ/zJQUCvw8vxzazq7eAQsta0R4Mwy2TCWyBA2C7v9/juwHN7yCGpH1tnqdv0q2rUhHeliRyI4FbG6g0NUZdus8gEgKMOPc1R3gH25pKqZva9omn1Xs4KDk1IDvDS59yuZAk591JUCm1kKYR4vOjrR1y/zZ9J49E9cqbBi7zG5HJZdWFd5bfAv4m/2jCBPDp3W30LGJxN+86pgW9hSRwkxzGhE4RxihTDzlPi/vf/ug6hu1bbsOq0X3LP3LS9GMS7C//AY6OrOSqvjwBjS7xv/Uh/H5moTr0Q2XobUGfTDiJDlsBFGLeKuhPqlaoKXAE3SlAvPF3mUE9mxH8SCpXnpUsfZaIa82uCJoG8lNZsrXzDsuxw7Mb+f9bRIoUOk78o8smb2tHDK/lRX25V4sl5TAflFpnd1KVUyFhf9aPjm9I1xriqcKC1wX3RbaxNqP+Rd0Iyuo+T0EOLGoQMWnOLpmXUm+DYBbACwE1SVs5eR22nad6owWsYCv+uZc/HTwhqbJ5zhV+fSydpILpo1Exz4CjGMjP1c23PjS/VzWIsSxD1YPSx5LFbXKv+uaX/QRG1
 JcqYYjMM
 EZZQFFeNJFawcJzxUFFUJEDCoStbCe0AqDPEr42CZlFOfT8mQUnuw+ns0ULTCazpmCjVPTYgct6cO0jMPvXJJZ+tA9uC/LIZJKpzpOzVs7foYN4n/M1y7+a1JiMTTBGf5uSRjvOfs7kvFoLuUmVUpucKszGoOl51yluCMPa0kEE7yp2Haqfskct4mRyF3KqNSGH2GyYeruH0SDLlRLyQRwxHwONesVgWDxPu9K+pPfV2QgN53VzrfsKLoWAK4fLztCyYMvmjUv54q1arQEFrBlcLAnL0eq9vW19myYHvm5pYFrBIUXlrdcRRWZ/XzOAdrym7whus6Xv6TwgYYkz5z/ewAl3JC9Fvf1CXROinxWPJFJyujr+XngB5eh9QUbC9+RB5gHWnUBxuDJPfmupbXGbrjE/kNExymDenZjKirQEbpEe6AU+TGRy375vmc8fAPqOj6hio4BbgXvG+KYmiSdLr2GuwecjxRZZp8VTviK+2HfH7fvsFgcgMGA/1oigreQb9K+60cigeHjsA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On May 12, 2026 Albert Esteve <aesteve@redhat.com> wrote:
> 
> The security_dma_heap_alloc() hook allows security modules
> to control which processes may charge dma-buf allocations
> to another process's cgroup via the charge_pid_fd field of
> DMA_HEAP_IOCTL_ALLOC. Without a policy implementation, the
> hook is a no-op and the restriction is not enforced.
> 
> On SELinux-managed systems any domain with access to a
> dma-heap device node can therefore exhaust another cgroup's
> memory budget without restriction.
> 
> Implement selinux_dma_heap_alloc() using avc_has_perm() with
> a new dma_heap object class and a charge_to permission. Policy
> authors can then grant cross-cgroup charging selectively,
> for example:
> 
>   allow allocator_app_t client_app_t:dma_heap charge_to;
> 
> Signed-off-by: Albert Esteve <aesteve@redhat.com>
> ---
>  security/selinux/hooks.c            | 7 +++++++
>  security/selinux/include/classmap.h | 1 +
>  2 files changed, 8 insertions(+)
> 
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index 0f704380a8c81..ea1f410b9f619 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -2189,6 +2189,12 @@ static int selinux_capable(const struct cred *cred, struct user_namespace *ns,
>  	return cred_has_capability(cred, cap, opts, ns == &init_user_ns);
>  }
>  
> +static int selinux_dma_heap_alloc(const struct cred *from, const struct cred *to)
> +{
> +	return avc_has_perm(cred_sid(from), cred_sid(to),
> +			    SECCLASS_DMA_HEAP, DMA_HEAP__CHARGE_TO, NULL);
> +}
> +
>  static int selinux_quotactl(int cmds, int type, int id, const struct super_block *sb)
>  {
>  	const struct cred *cred = current_cred();
> @@ -7541,6 +7547,7 @@ static struct security_hook_list selinux_hooks[] __ro_after_init = {
>  	LSM_HOOK_INIT(capget, selinux_capget),
>  	LSM_HOOK_INIT(capset, selinux_capset),
>  	LSM_HOOK_INIT(capable, selinux_capable),
> +	LSM_HOOK_INIT(dma_heap_alloc, selinux_dma_heap_alloc),
>  	LSM_HOOK_INIT(quotactl, selinux_quotactl),
>  	LSM_HOOK_INIT(quota_on, selinux_quota_on),
>  	LSM_HOOK_INIT(syslog, selinux_syslog),
> diff --git a/security/selinux/include/classmap.h b/security/selinux/include/classmap.h
> index 90cb61b164256..d232f7808f6b8 100644
> --- a/security/selinux/include/classmap.h
> +++ b/security/selinux/include/classmap.h
> @@ -181,6 +181,7 @@ const struct security_class_mapping secclass_map[] = {
>  	{ "user_namespace", { "create", NULL } },
>  	{ "memfd_file",
>  	  { COMMON_FILE_PERMS, "execute_no_trans", "entrypoint", NULL } },
> +	{ "dma_heap", { "charge_to", NULL } },
>  	/* last one */ { NULL, {} }
>  };

While we have seen some one-off patches to add specific resource/cgroups
controls in the past, much like this one, we've yet to see a patchset
that provides a more comprehensive set of resource/cgroup access controls
for SELinux.

I'm not opposed to a patch like this, but I would like to see it as part
of a larger effort to introduce access controls across all of the
existing cgroup control points where it makes sense.  In other words,
let's see a design for cgroup access controls so that we can ensure we
have something that is meaningful and makes sense from a policy
developer's perspective.

--
paul-moore.com

