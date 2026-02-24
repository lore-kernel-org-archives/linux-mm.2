Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5FDEEFB811
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 08:26:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2114F6B0088; Tue, 24 Feb 2026 03:26:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 194A76B0089; Tue, 24 Feb 2026 03:26:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06A296B008A; Tue, 24 Feb 2026 03:26:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E14596B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 03:26:22 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 86859C1DD5
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 08:26:22 +0000 (UTC)
X-FDA: 84478668204.12.83AF6FF
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf22.hostedemail.com (Postfix) with ESMTP id A7E91C0003
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 08:26:20 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=t08puPfz;
	spf=pass (imf22.hostedemail.com: domain of praan@google.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771921580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iUKKSXBfGZuIEKcFLX2f8iJcwGvlTC3YM5y4lXwVnQE=;
	b=etSR6DOtP//Xptxxr/9tHT1MMuTCVB2xS+KGbdIQb9/JxBY6oYgLPaDnFRyQUTUYIPAQFx
	+EtkFJBJP3Z4QEUi1dXicNLgofQh4afYigko53bNy8xUrmvD7k7fuoutDa+MHHTv9P/efO
	WNtV55hlqzq5f6LzdIpbpFjqRyc8WXo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=t08puPfz;
	spf=pass (imf22.hostedemail.com: domain of praan@google.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771921580; a=rsa-sha256;
	cv=none;
	b=DMcPi33P3mjEQpY6kPrU8nqTsJrlDRi8DlGJrIRruYx3o7tl0c0AzKYbeC6IO5v+dmlWji
	obIVC63GN9/4fxBL1xhSCkaeyGE4WckK/haFq4ovuDdbhVRVhXrxF0CiFfNF2FkGZyxXpB
	r6Ahaqcz9Jup+xU/Vig+fVp7fKtJpO0=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2a964077671so69515ad.0
        for <linux-mm@kvack.org>; Tue, 24 Feb 2026 00:26:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771921579; x=1772526379; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=iUKKSXBfGZuIEKcFLX2f8iJcwGvlTC3YM5y4lXwVnQE=;
        b=t08puPfznVg8eOmysf4A21taDg7V8NzcWPoXoVMw/WdOjcptQMM8hGR9b67hHhAJk8
         tWXT7IbyToW8goUM/jwP0bAUBfEBktyzGHEiFk5T3mMw7VHB2B3/umKOiL54G8JeyGqg
         pv5foc6IpxWicly/ni8N5mX6ioexeLCIuHJHj1lAc1aKmkvn8NkE1IaUg7PW0ClXMPUX
         vxrCFwnJ8VpTlIgaOt3whVf0A8V1+241lAgNgykblSZGIvGdDVPgwoN3N4aY6zOJQ5Jc
         6MM48ATC8ZJRDhHMfmPPq9ma76bmnmkgIL7CVUJoVU5FmWLEFEalqLZlbFSMk4vtvpO6
         YneA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771921579; x=1772526379;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iUKKSXBfGZuIEKcFLX2f8iJcwGvlTC3YM5y4lXwVnQE=;
        b=G/47PtlMhjOqTOn99lI/89ODxnG65iI2k/khZ+G/0UCPdTX0ciGZknKx8CroiU2aZ4
         ke7/WZJYpX+S0cqQGH6tT58UnD21ORmuoQ5/gf4X4KwHzM4BaRvy961tByv20vDTBSOa
         yMjNaJomp9kVgamgpKvd0Mzpgs2LCt5m0TMMrW3bh1ZosHyn0YHjSR1XqpohS6yP9NGz
         nWP6WZ7VNt2Rxd2qZqoRs533RhtTPaN6D+1hBPqIVKxjpOi7CL+toNbPDYgBps6Manfl
         RTvgEvcvDQqt/cxZaOck258DISxOkwD7Xsbppo/xvYLYwObK9ZL9FBfSCQ2F9b76swhg
         567g==
X-Forwarded-Encrypted: i=1; AJvYcCU4LesAMmRsqJOVVFWW2ftqHHc07UIM4eM21lpdI1v1sztG8BwiUPxA0sDcUbJu2JUUFxZyNzRdhg==@kvack.org
X-Gm-Message-State: AOJu0Yz4JKeXfR64LxXYpOomvGzQt7NQq7ELQjCEK0hFA+oAZaqUoMNG
	MTq+8Tjho01MP7v5QwH9B5QrGvSDsws9VhyL1ZitPxXPu55wOPfHdNVT4tKIG7XNOA==
X-Gm-Gg: ATEYQzzL356nSFeXEczTMMLQ/NdAhf3jsbhpkUW5aDmN3b+IuHrFU+VAhlvI6mSpvJm
	TDsbRISMjJXFxNLZDS5Q8BYq5MZOZ3bkIiGRxnC+1T1E0qJyCnZFHv+sRDdJCZI1bAFjVb/kUhu
	AMuhL4sCvgy33uLlop5oIDZxAy4iiZmJ9uUvaxTRKPc+w4FGk04Hv9LKfppQ2AUMhuvdbxwyYGn
	6Xe0TJBHg0u6fqN9XEUWBVXcJ+7hw89O1oR7GGX08rhkxzwJSbxMCgXAs4qrfZrqXPtj93f8CR8
	jG+ybSEKi5mj2QEQHACOssfrAhADuH6LKIcg6IKZVUp3qtqm5gv2aQN0nuDn3nO/lHymcWmkIa0
	fq13IABZSO+deZ7/ViszRYXyhXggXq8DoZqGxFEyxXfSmdSng80z4KYzwBORVpcOB5vgO9QtbRv
	oJ57r+CiHdDLlGy+f1QpTYj2J7UbK6krsROxwx6r4Sh4sYpejRjp8M+CzS08PX3QFLgElK62M=
X-Received: by 2002:a17:903:2f04:b0:2a0:7fac:c031 with SMTP id d9443c01a7336-2ad997f5113mr1474945ad.14.1771921579006;
        Tue, 24 Feb 2026 00:26:19 -0800 (PST)
Received: from google.com (222.245.187.35.bc.googleusercontent.com. [35.187.245.222])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ada77cc13bsm13228715ad.47.2026.02.24.00.26.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 00:26:18 -0800 (PST)
Date: Tue, 24 Feb 2026 08:26:08 +0000
From: Pranjal Shrivastava <praan@google.com>
To: David Matlack <dmatlack@google.com>
Cc: Alex Williamson <alex@shazbot.org>,
	Adithya Jayachandran <ajayachandra@nvidia.com>,
	Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>,
	Alistair Popple <apopple@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>,
	Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org,
	kvm@vger.kernel.org, Leon Romanovsky <leon@kernel.org>,
	Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org,
	Lukas Wunner <lukas@wunner.de>,
	=?utf-8?Q?Micha=C5=82?= Winiarski <michal.winiarski@intel.com>,
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>,
	Tomita Moeko <tomitamoeko@gmail.com>,
	Vipin Sharma <vipinsh@google.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>
Subject: Re: [PATCH v2 01/22] liveupdate: Export symbols needed by modules
Message-ID: <aZ1goNCgY8xz9n6K@google.com>
References: <20260129212510.967611-1-dmatlack@google.com>
 <20260129212510.967611-2-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260129212510.967611-2-dmatlack@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A7E91C0003
X-Stat-Signature: uq6z6t8fo5z3g3odgy5oxsmhhp1ugkd9
X-HE-Tag: 1771921580-69851
X-HE-Meta: U2FsdGVkX19pfh2PE4nXWoWdh7p8mNNobupU930XFsTHlu2T9+mqpfBmxCIyAT4HP58kn28BS+I37/Hw0cI0TD+OoTRx448qvUBf8+iZsI3TExFmE+dUDe9Nlq1uAxw52O1Dai2njV9XkkNOCrn9FvVisC49CKMJZ7/cLT7oJhwIlKBcxHCS+S/Mp+8fYX8EM0HEpJjrP1D1Bb08a3AjjiBKvTpjBErgViRDGT/oHef4079cacp7843sKxykQ9GnWCISWu620/nEdfokjnuW0y4QVjOOxCK59ktt3q/uomgjHG7+llaZmEFUbJS8I93bRieLcK4jHjP3Tu2Ho3fWdWfIr+Iq7ZHukG5plkGThHZuztsnATmYGlbq1/XcmrBh18klrvWUvlrUeeAnRBXmU1l99s+/3r3USpQ7vg2jToG/pOPt1sDKU5E6DfWTJUazkauGwJtuFzalAqgHytlWCGHO/P2AXeuUQZerkq4TadhQn6PojnWGVzSj2ZVaqpL/CM+G1mBIczhG9C9POld32DvmOWMFFzvB3UBYGp5wYweDA3F8+LT7GlcdnHMaoOCxTvt3ky5RgUseWybmTXEelpTdjSqsdcPLjrwCwJWPYoDty/2WpuG3y3G34GQoZBKLzzkBOh5JmellZbYw7fUWywIvCeNzCMYR+QhbGeZPmcJmUULxsw+duDNE0rhnjQ49AMtwSrgkhJCs8CRXGpqn7LEQfORwz3qBb2zkD+08KMTNdT67xoBhrquhdntEgJv+cl44SdbHzjDoyCu1VRlzE2uw5lwjLVCVkBjBv6frhi0JKVSGTtGyVL2x9GST/YE9IMP4gyhW4KQrks0M0cbXAUTcli9LztPDG2TuGQ7XM2HPXhA4lDmVKoyqSnFc+NJss6h1gxHJHGC3PL4Uvok0hwHJbG+WVHJs4LQGIMQbjbsHZ30fteQYvouwDn5VLWFm0Cx4v1LWvVMS4tOla07
 sKDxtsXQ
 eLemNXD5pDyOPswKVkdwPjif0ED0ia0k+crB5AZRicwG4XECI8I+nFTrDoGwIJ6e8XFltFoiS37IujxepEdM6A0sOuYZslSvnZQdPsns5Fu10gKFrQoTJfSPPIwPI2N3z4G5RIrt84VGr6Hnw0OG7vB74iCmb3gdPXU89J1Pugaj0vKci564+JqO1VpzkY3mq1H1NKirkmpECZCg+MYEvKhQzA954Ztl3BhWAYQLFc0Fq1/Drquzc953V8qeeYwyST6z05kAgJC7lPGTq62huummFvRm0KSC5EYuP44MwS49sPl45UTuvXhQn+ttViEghig9HB4ET8RAzCH2t4dF8JIgRfP5LulqbH59A
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 29, 2026 at 09:24:48PM +0000, David Matlack wrote:
> Export liveupdate_enabled(), liveupdate_register_file_handler(), and
> liveupdate_unregister_file_handler(). All of these will be used by
> vfio-pci in a subsequent commit, which can be built as a module.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  kernel/liveupdate/luo_core.c | 1 +
>  kernel/liveupdate/luo_file.c | 2 ++
>  2 files changed, 3 insertions(+)
> 

Reviewed-by: Pranjal Shrivastava <praan@google.com>

> diff --git a/kernel/liveupdate/luo_core.c b/kernel/liveupdate/luo_core.c
> index dda7bb57d421..59d7793d9444 100644
> --- a/kernel/liveupdate/luo_core.c
> +++ b/kernel/liveupdate/luo_core.c
> @@ -255,6 +255,7 @@ bool liveupdate_enabled(void)
>  {
>  	return luo_global.enabled;
>  }
> +EXPORT_SYMBOL_GPL(liveupdate_enabled);
>  
>  /**
>   * DOC: LUO ioctl Interface
> diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
> index 35d2a8b1a0df..32759e846bc9 100644
> --- a/kernel/liveupdate/luo_file.c
> +++ b/kernel/liveupdate/luo_file.c
> @@ -872,6 +872,7 @@ int liveupdate_register_file_handler(struct liveupdate_file_handler *fh)
>  	luo_session_resume();
>  	return err;
>  }
> +EXPORT_SYMBOL_GPL(liveupdate_register_file_handler);
>  
>  /**
>   * liveupdate_unregister_file_handler - Unregister a liveupdate file handler
> @@ -917,3 +918,4 @@ int liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh)
>  	liveupdate_test_register(fh);
>  	return err;
>  }
> +EXPORT_SYMBOL_GPL(liveupdate_unregister_file_handler);
> -- 
> 2.53.0.rc1.225.gd81095ad13-goog
> 

