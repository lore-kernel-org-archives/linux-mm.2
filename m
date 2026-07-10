Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB00DC44501
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 22:12:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C48E26B00D1; Fri, 10 Jul 2026 18:12:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFA6E6B00D3; Fri, 10 Jul 2026 18:12:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B36A76B00D4; Fri, 10 Jul 2026 18:12:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 94E286B00D1
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 18:12:32 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3CB971C3DDA
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 22:12:32 +0000 (UTC)
X-FDA: 84974266944.07.A49574E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9B566C0009
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 22:12:30 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Tf7EXdr4;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783721550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xkCCHtME3GEINo3S7szVFYlvRYIJypWuhYUEdvTFvPA=;
	b=MU3H0Vplkp0L1IOOaPaGW1CfrjBMBx9qAi2BoMX9W+PjWxumtFy2RTpcaWvDK9RmHctt1L
	3xVtMm9mm4N8WWopo3cuHuOejt7fSl2V0HIw18RV2r9t0xRddfJKUMEN5bbYQcTH9H/hwc
	uJcq/U4Br8qL11vn1gf+DfwGoMROYRM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Tf7EXdr4;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783721550;
	b=ERjwQXrNkz2PN/CxZQXAGObZp+bvfsn4TKg5msIP4YiYBDKnagIGKimAOGUOJmfrGHoyyv
	wSTG6sVqYqC9w1JTklykJ8LF84t7L/mmcNLqSwnjmW51T8wBONVfcHmct9KsnyhcFCnRAd
	exBLB0GAGETENG5LQnjxwFmyHn39Hmc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3AAB8600C3;
	Fri, 10 Jul 2026 22:12:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA4BB1F00A3D;
	Fri, 10 Jul 2026 22:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783721549;
	bh=xkCCHtME3GEINo3S7szVFYlvRYIJypWuhYUEdvTFvPA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Tf7EXdr4fTwcS6bniyj3Vljw2mjizC+AuVuuOhj6bjBU+VQ5B8ncb1aZAHQiXGsR3
	 UJExhUGBEyVaED8iH8HJqi0W+vr6Tz/+3qjlVDYwoFzxOnKf5zVzjI99nkFnZ3/AnG
	 Xc4aywWAj0b21m2YpR5KgM/KdqEwzhHM2gkdlFUg=
Date: Fri, 10 Jul 2026 15:12:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stanislav Kinsburskii <skinsburskii@gmail.com>
Cc: airlied@gmail.com, akhilesh@ee.iitb.ac.in, corbet@lwn.net,
 dakr@kernel.org, david@kernel.org, decui@microsoft.com,
 haiyangz@microsoft.com, jgg@ziepe.ca, kees@kernel.org, kys@microsoft.com,
 leon@kernel.org, liam@infradead.org, lizhi.hou@amd.com, ljs@kernel.org,
 longli@microsoft.com, lyude@redhat.com, maarten.lankhorst@linux.intel.com,
 mamin506@gmail.com, mhocko@suse.com, mripard@kernel.org,
 nouveau@lists.freedesktop.org, ogabbay@kernel.org, oleg@redhat.com,
 rppt@kernel.org, shuah@kernel.org, simona@ffwll.ch,
 skhan@linuxfoundation.org, surenb@google.com, tzimmermann@suse.de,
 vbabka@kernel.org, wei.liu@kernel.org, dri-devel@lists.freedesktop.org,
 linux-mm@kvack.org, linux-doc@vger.kernel.org,
 linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH v8 7/8] accel/amdxdna: Use
 hmm_range_fault_unlocked_timeout() for range population
Message-Id: <20260710151228.ca22e127b93ec5c6d591fb5f@linux-foundation.org>
In-Reply-To: <178371883276.900500.12789147320642521200.stgit@skinsburskii>
References: <178371866223.900500.12312667138651735591.stgit@skinsburskii>
	<178371883276.900500.12789147320642521200.stgit@skinsburskii>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 9B566C0009
X-Stat-Signature: njxz9sfifdij9hbirgmfkgfrcpmsi8es
X-Rspam-User: 
X-HE-Tag: 1783721550-338827
X-HE-Meta: U2FsdGVkX19TBKH9e8syMYpZpPpvtF98OaeiSikZZqIII3e0z77hkJCnitMUCBB9DqWuWQsK+O+vDDGhZjzqaJ7UDFUpMZue3gyPKGS4TmCQBRHo4jqMepP7keayskWE333EW6R61plxV8cz2X68vNH8ObRUXxuJMfY3IGjfwpcfU2TZiU/PCqHh6VQdl1bVwrIEC91si83GHnH9FR+ZGnH7fAgulQ1V5jSwowBLJTaC2tkWWeCD4WqhpcC4f+GCh8EL8stLthYmpHeE1uf3/ocd/M9MLzwz0MLF1yHwVpwsij5lGJDd7DV/vgDRP7j2YrM0yJ0SulgBsu5ocLz4PHlWgTyfvtzlzASj26xS67XtbGdy/0gRtc963tL56YWdvwV49d0XpI08JlrIJ8EDugX8C0886MH3w1DPVRq0Yq0FyCXQDCQ6ypEkoWxNIW+nvQwnDPWDw88+41nHzYVi+2ebGNbWYVGAr4PRo1zgO1xle2t1xccbqRePgzjbMe9v3SwXPE5qH554OQ2kUt+PY8IpAvjNgyiKNFvbPU8UyD1JG5g2TB6jr9ly/oIQFKxRlW5pM5BDl55rt4v6qJrvnSKbaire9mYiPYuIXCf88h+AMWtKU4cgng564LTw84dDtAiIHEtwjhaUu5sPw6nilgznK8IaD7nHhUUdC4sKDbqNYqWwzAZu3lg1kcGAq43FoDKI/Z8JU8yx+RsM5LRD6WbhFXaEbexeMF/7doKa6l5WiKV9d2st6dUsYrEym/nGlCY40z929Jm/R6UHSDc1GkV44vft7x5ZCYx+FcPZx1Cdif9UDsoFbwo9lt9la4c/R2vhZLPF7NPmnOpPlrWORP9ZGIPAnlM+oI5Hn5mFHU1x1mo7a4xevGbY/GCQVrRKwI76wHREhgiN8ngfZ5p6pxEFMpSAR8jzRUCprlXpUxct8jyejObsjxYI0bWckkVoYEgXjK6S3Vj3OsY2hSj
 gw+1NLWv
 BbChNTQzD5IK5DIdEnASO1sK/DGWCODcY9OXUiH57OuwCxzbYBP2XutvPNyDo4Fgdt8w2cxISmplYJqCck+mh7JtZjOnE53tptssJ9Lkn2AXbH0K0ApK0I/L4b5Jdil+XFsyPAYfZ7JsO9KESCjoJuhqJGh9QykSmjPtW9UYdiiEjVL7PDuDzQ9hfCG3yJ2JzGMluH97FW80b+qJFWQVCE6IPc9WkkurdYA32fCOQcWzZua4m9eJIu0KJbNEog7RAy8b5B53EulJpBa0NOj0TaheyeTWEOA0oWegA32gYGhyMmNWT9UHVDHh6e5ZWeGNoPGPx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 10 Jul 2026 14:27:12 -0700 Stanislav Kinsburskii <skinsburskii@gmail.com> wrote:

> --- a/drivers/accel/amdxdna/aie2_ctx.c
> +++ b/drivers/accel/amdxdna/aie2_ctx.c
> @@ -1061,22 +1061,11 @@ static int aie2_populate_range(struct amdxdna_gem_obj *abo)
>  		return -EFAULT;
>  	}
>  
> -	mapp->range.notifier_seq = mmu_interval_read_begin(&mapp->notifier);
> -	mmap_read_lock(mm);
> -	ret = hmm_range_fault(&mapp->range);
> -	mmap_read_unlock(mm);
> +	ret = hmm_range_fault_unlocked_timeout(&mapp->range,
> +			max_t(long, timeout - jiffies, 1));

max(timeout - jiffies, 1UL)?

