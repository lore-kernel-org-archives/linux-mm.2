Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4307AEE0AE0
	for <linux-mm@archiver.kernel.org>; Sat,  7 Feb 2026 15:52:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EA3C6B0089; Sat,  7 Feb 2026 10:52:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5972A6B008A; Sat,  7 Feb 2026 10:52:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 495B56B0093; Sat,  7 Feb 2026 10:52:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 353436B0089
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 10:52:46 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E1722B997F
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 15:52:45 +0000 (UTC)
X-FDA: 84418103490.02.E8ACBD1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3D9DA40006
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 15:52:44 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=xM1CQ1rN;
	spf=pass (imf12.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770479564;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ptiVPel3gSb9+Qa2bMR1sWdbj0LWIQ/YTcM3hn5+38U=;
	b=zbOgQ6ZSEJVN5bTawV7dOdM0p7Tj1BUkdIC2tIvzekN2cjdta+zu2l6Q08xLoy7Fw6/pCg
	G2SJQhO0XTC/dOrJoJjbP91BiVt2P7/beS0AIgOCWwRB9e3y9iqbhGCHHGsGKB+MRGQCHM
	0iWbtFSEukTPRKM3OuA3PxFg7FVviAQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=xM1CQ1rN;
	spf=pass (imf12.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770479564; a=rsa-sha256;
	cv=none;
	b=LDaY0JQ3bYyx3I05Unr9d9DTQ0LzGwEJU7iq9mUu5g5MEdfCpZGE2RObad2gv5Kd2jU6wD
	lvpUiKMox+EULqbtp6FhUNsiGhTMW6fT1uP/v+F4IyuU+AR81hoREzMASC5j4I4cOSJNzi
	cTGQetqpJBLGyAtZcqv7Bbh9yWyirXM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 55C9760008;
	Sat,  7 Feb 2026 15:52:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C912C116D0;
	Sat,  7 Feb 2026 15:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770479563;
	bh=3caPt/SFdYRNTEo+dzqjdrsO13S53h4yikkUh2Rehmo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=xM1CQ1rN5w+BCMNjOxhWt/xsRibe+1dr4kkrdTVWsqr3kymC2TxGJ9jXMjpd3nwVw
	 fcJ9ijERW5U0GBg6rjXZYP8lYikC6eAVig0J6HiUuavTx1SvqOi2tecEPAQJkOGaoE
	 rW0hm4ANXI3jYvp3ptUC5jtIjD/cUEeX5hb3Bl0E=
Date: Sat, 7 Feb 2026 16:52:39 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org,
	Slava.Dubeyko@ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v1 1/4] ml-lib: Introduce Machine Learning (ML)
 library declarations
Message-ID: <2026020756-remarry-declared-9187@gregkh>
References: <20260206191136.2609767-1-slava@dubeyko.com>
 <20260206191136.2609767-2-slava@dubeyko.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260206191136.2609767-2-slava@dubeyko.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 3D9DA40006
X-Rspamd-Server: rspam07
X-Stat-Signature: x8jb9is88855f7o6tqypb4i87rhx9xk7
X-HE-Tag: 1770479564-957566
X-HE-Meta: U2FsdGVkX1+pIDFgSzx7zSRVzY4jcSDNYWOw9WUV3z0KH0gnBIaTiSw7uH280JDKZV1I8qLMdojum+6i7tlXLS1BDrB1EYW9mwVNFGuj9ZTIS2prVdG+eeg8w/92glclgMlJDRJfMSw5aNIasQ4IXHGl+g9dbMjK5GjGX8sqdxVd21cg6xRuj6Pmj3Lg+N1Tt5eyYmRJMjWo2H66cZXCGFvDv9uJeIOyny9Lwlyi8YF2NNVZl4w+rbQqk0H/Nu7lz9TgRJ5zg7T7bAITGSdToZPz7FeldEGCACvvLc+Oh46TF13OIXUzZRzAoC0fRIsWXfg7wbTNkUxuz2Ts9mfPfCZOMsm8kqFPdYARU82oHR+4DCEdFhha0qxrqNB6iqIc0yQdEa2vWMuc3GLuS5GVj2mXjp6EF/n4OKNCMJf4heBMt//ast7YuMw33eXKDM7GUND76WXnfHqJVX5SHX7eQOZcSrPsFwudfAaWwcsFBP+PiGUAylcJ8WHnRAENuucQTt9Tghtk4tBTBe8OWz9Sygx5XUeZQS6eZpFE7KvElzYwQWdVm8dx5ZNI88BT1Y8ioEQxqjVwI/IL8iWZQGAtVlGJzHKF4RFlxH+JGNqbk5PurIB/4FipodJdg2h2lR8v8uSOjkszJFN1IyV6HRDn2dGtBELKBkS2wmHhI5v/8bTonw3wCNQiFOA7yFkk8zUxagvkS49WqiY4WQkfyDtTxDYe7OfCut/pzq/NlHbUm5BwmL9QujWiPoO476yossHmuYbq2v2CWq+O1/fVjtxfiFvWcAqIbX+GHPbT0ccSmCyfyshHHeP4VW9Oc3DKtXCtFYQ2vpTToQr9BA+i1ArTtxOHLr78kBkKvtfHRTJKHzsDJIFpYzyqS4i4PKboX65SpcDBmkPgbaLVFTBF5SBiBIEO25mXx7rxdg/v640ELjD7PVMdbVXat5h1zfDqM7CgsC5BCBWwfqD/ygcJUbo
 bRs9N+sZ
 TZjR1AcGDEF3/oQIlk/5Gc+iW6z+6u55HF5/wj+Kg1tNh9cHw2ZIWYnwCyunk95cfYEWm7XBIM3UzjZia22E0Taw4WnNeX1CARkzLsZPjGWvZvxMl8V+um2UY1MfH24qEMyah62RpRsutJkUeIsiqmn6AtaKpR2S0Y1cNv/JBpL1Cdbb+RzeuRy1/CCQIIpQ3zYksVCVRTtnx0GkhqIYlKSD5qeCkAvkpdfaCQPM+pNBlMTyvhHP3aPjDyJbS2qGHUmqCbm02mR983aKGJ8B4EkeN9GpT9M3ifaY5nyZzu3UZxvn3KM7FGq+zzTMstqMy1TAr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 06, 2026 at 11:11:33AM -0800, Viacheslav Dubeyko wrote:
> + * @kobj: /sys/<subsystem>/<ml_model>/ ML model object
> + * @kobj_unregister: completion state for <ml_model> kernel object
> + */
> +struct ml_lib_model {
> +	atomic_t mode;
> +	atomic_t state;
> +	const char *subsystem_name;
> +	const char *model_name;
> +
> +	struct ml_lib_subsystem *parent;
> +
> +	spinlock_t parent_state_lock;
> +	struct ml_lib_subsystem_state * __rcu parent_state;
> +
> +	spinlock_t options_lock;
> +	struct ml_lib_model_options * __rcu options;
> +
> +	spinlock_t dataset_lock;
> +	struct ml_lib_dataset * __rcu dataset;
> +
> +	struct ml_lib_model_operations *model_ops;
> +	struct ml_lib_subsystem_state_operations *system_state_ops;
> +	struct ml_lib_dataset_operations *dataset_ops;
> +	struct ml_lib_request_config_operations *request_config_ops;
> +
> +	/* /sys/<subsystem>/<ml_model>/ */
> +	struct kobject kobj;
> +	struct completion kobj_unregister;
> +};

Do NOT abuse sysfs for something like this.  Please make your own
filesystem or char device or something else, but this is not what sysfs
is for at all, sorry.

greg k-h

