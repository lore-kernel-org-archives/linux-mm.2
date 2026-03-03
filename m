Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF3FFEC1430
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 11:31:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C10E6B0198; Tue,  3 Mar 2026 06:31:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35E746B0199; Tue,  3 Mar 2026 06:31:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2439C6B019A; Tue,  3 Mar 2026 06:31:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 157CA6B0198
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 06:31:47 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C8F911383D3
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:31:46 +0000 (UTC)
X-FDA: 84504537012.16.0AEDA9F
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf24.hostedemail.com (Postfix) with ESMTP id B0061180008
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:31:44 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=TExJYGKG;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf24.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772537505;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8Xf7CcTvWKm0AxjepRjO4S6p746Cx/GbxsbLs1tX+zk=;
	b=CV/tR3VHMLfrHgMPLN0HDFd02fu7aDrHz1eWPXAHX7pR3GgIq8AsDHIJrNUBzPvOTP6uL7
	lhjhDRHYLVyVxAvtOMyrLzto6T3oP9u4xf3wVUEJXU5UfYs8F33emlOtUMelEBaFbxjccV
	takEd7/NxiknCpM7RKRruI1TIXip7uI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772537505; a=rsa-sha256;
	cv=none;
	b=XrkERzJXpa0atANbPi1zafgTbsbnCRXKPvkGflSHPsR91mivTPYm5odaASga/0gRPPhICl
	tf+8IWN0VjJxW7WnJMYLse41CPAMwoA2iAgucrLa9SdJGtHeCF6143qRUVHwUL6qYq99qo
	1zGZlpfH6frkBB0bW3LBebpodP3K1n4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=TExJYGKG;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf24.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=mhocko@suse.com
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-43992e3f9b8so5601507f8f.3
        for <linux-mm@kvack.org>; Tue, 03 Mar 2026 03:31:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1772537503; x=1773142303; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8Xf7CcTvWKm0AxjepRjO4S6p746Cx/GbxsbLs1tX+zk=;
        b=TExJYGKGwicd3LRc5/g9bSUzo+0vRs2PJOqiAOoeiXN0qTrwJH7G2nW0Mo798lp6nN
         z/vZ+Pmsz1SSFW8lQHZ3+8YCfJBu73VxDPF1VBS41bZGXlHtOs87stz9mMNwyXnn+eFc
         twsp9oz6RcMb/+qZO2S86nZpfcQUpuz/p0nnxTzFybm+FvdFBZBAmxggVOb5hfoaQz/q
         yLmzsxWAXGgZz7bUWWEOHN/C7cvczo1+hC6VzgKr9ScpzzYbFECnnoZeSUZYVZ/X9loy
         Vgi9CPZT/coesS1veiUZSMVNzfpIvvIf55Hh4bu3LFmgMJNFi8Z7eBICciQNwEKOAcRf
         juaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772537503; x=1773142303;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8Xf7CcTvWKm0AxjepRjO4S6p746Cx/GbxsbLs1tX+zk=;
        b=urBEDDetiHhTcFk34rlJB41ZBGjH5N2hshsJ5yKS0a6+njE9n5QRP7Rk/zmokL8b+R
         VYH3M+m6hymGqpz043+uMuVuvJf3d8VenjOz53bCh6l4ZZkcQfWlf0MOegETLQy54ucV
         TXf2yLVnUtByR0LbvLFeFTGQJ66k0Jyz2EJ+shIvi3jLo/3DIj26QdmPIUG2wrByCaCk
         5QM1/PDYUiw/B+SWzc0UXYUs/8uIotexbi1LetnZjSP6yZK4dL+7on9olOtSu9SkI3nh
         DAKzr9q3NKwDogUhpn7nzhvSBaiP2owjm7yJSERwRxidYlz5+elZp3fLFiF+iv9N5UwL
         YSSg==
X-Forwarded-Encrypted: i=1; AJvYcCXsjk04ebVLyLauV3X8Ttmd+RERwBEQenBNYiYgwH2CvcgX8xKhntcV/oc1bTTB7ZvA3qdD3IFS7A==@kvack.org
X-Gm-Message-State: AOJu0Ywb41vFYrmFDJJtarTjEiQiq3587epI5Ao2jIVq2rVBWd25aj/D
	256bQkuPX1c0X5xYKNB1l+ThmLHW+0323xrW65QRMUTtCyOJEi7mqvc/oU+kSkkDW5AUKG5BSjR
	+meF8
X-Gm-Gg: ATEYQzyW3/lTnCt4wG18iFXduk5Pil6gpdwtCFJ8RSiHMjciXujNskMLgkqZI2siEk/
	iFwILo0O0f5/uSalAsB1gbgoOZZGlBoL/Hh8jgwdS8r9f54saAwIWUEMpDd+0gKQYO/NHsj+HOP
	iLK9g8/az90AveuULbwlCGICI+HZfzcnCo8MnWAiXDUYVrxBktaODI6KKTGAdGVIpDmZo/G8gKk
	hjrg4N2IaW7s8TCFakyOPMH+hlxO4O46HxjMwa8kN430drBs3a2SPGPmIUcNTsE/eddS7w1+8i3
	wz6YpW8+EwqYIT421nEgQx1wkjYPr35mXibJzOk9+WdunzEQwV37eGqlb+EizW4wLsCth+S65wN
	dlOUdFWvpIG+DxFKo4WpSAOvhYDN5tetqjBBL7OKiMKdALKE1J1SyaNJklt/yrqFVrA9qaLUF3M
	jL/3MHumX9RZAcLD3exKcrhjRyARUvjIZDAZLJ
X-Received: by 2002:a05:600c:8711:b0:47b:de05:aa28 with SMTP id 5b1f17b1804b1-483c9b9701amr320509715e9.2.1772537502910;
        Tue, 03 Mar 2026 03:31:42 -0800 (PST)
Received: from localhost (109-81-20-148.rct.o2.cz. [109.81.20.148])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439b3cc2e65sm18457589f8f.2.2026.03.03.03.31.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2026 03:31:42 -0800 (PST)
Date: Tue, 3 Mar 2026 12:31:41 +0100
From: Michal Hocko <mhocko@suse.com>
To: Maninder Singh <maninder1.s@samsung.com>
Cc: rientjes@google.com, shakeel.butt@linux.dev, akpm@linux-foundation.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] mm/oom_kill.c: simpilfy rcu call with guard(rcu)
Message-ID: <aabGnaO1l9rsbNia@tiehlicka>
References: <CGME20260303102608epcas5p159cd0ad7dfd939c4a67fab3c7ecd7bfd@epcas5p1.samsung.com>
 <20260303102600.105255-1-maninder1.s@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260303102600.105255-1-maninder1.s@samsung.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B0061180008
X-Stat-Signature: e5wjcbx6qek7yc3ygupst3byhemwgac9
X-Rspam-User: 
X-HE-Tag: 1772537504-113411
X-HE-Meta: U2FsdGVkX1/2Jwm+vtKRWV+VQYNP6XQv3uNA1yBXZs3K1n1WoyZUO5mjX7rOQOAIlN/3DbMj11ayLR8bgN68jaoAl7Av7VzlVp2P7YyWMH08TEeOkgn00fJhILHRYA9Ub2LXr7bPmvMGqVIAeanOkLopa0WsY9N7eTwzf1ubHsbU72zYE2LpA7OJTf+nID82PyUUx1LGRNNwI26nXK0PfFLlzfDeJsXq+RKtmm4uKpxQRvPquZZQyM91HPK2qNJrW7xEAkAkg1qVBeq+jGfTI7oiTa/Ts8hlIqrFr7caEU+O/2GsqCfLDkn5f8Z1rN4uDbdn7j7sM600/b5cJ9DIRfWJxwCFEa6ZkRQhgnQoumu/HVJLhCFM3qN0Kx9w8+mq5nr3UnrPLNSjq8XJNIu/HyXKeVZLImmDT74l18uzD2H6+as8aUFR7v6/BIGGBFdZTZrx4SqunRjhyI8rzOJESRhwcuJfi3Jxfz4zgCt7+RMUYBFaeoV00ctx/o5UwbvSA/MzkAcSMajfzXN3LMmN/iA1QUBYaa5K3dA0UNv8fJykw+seKVg6y0x6uSBiavm2z1WNRQbeY2eDLRx2sRNM/MZ2OamyBYeGyLI2sIyRsSpTvMs6SngCqfDQYmlyTU/kFEB+gAxx/yhKNV29RCF5A5cYEoVJ8Sp9u4GHiMmgh7pqCaGuNZCj+UnetMRKf3GRmu5fhnmKtXhWVVkPKz3JeRLDK2ZUM5eBm2Vvv0D9dZAJ1zIwpGnzm5T/jyMl1G+sFTF0Pk+LY3ppT17biAbzVhPSjfQW8OFjfkNfrVSxpcYtGK7/djjNN60y4P68EUVpAlmP3X0h58qG1kRSZIcHm/SafyFTW6efsAWbr0eiqX08H9VJx+hmv6CllQ+OLlbjRUUOrcrnY+u2nX4mJpR5cvoTOKYye6H6ctIMo5llhR0Gt5N1d07jev3eCmiUEP4g813uCV+MrR3IIu1cx3N
 8C6VWJQa
 DnivCLNqWO5nO44IrvGPxnzugQW0eQak4WnD7sf1vz3I6tlKv9Nmj9uvODipws9RyS6jFzUimWGfaNG1rVigq/TeV/BCLxWRsdiOBZtqUXLL9hDo5G9h/gwyiMyFaLIFwatEKBIi9AyMmcooWOp370rTXCVZVNaIWnhegq2uSaU32OUbhdJB4aQ/DkgbrG7tzH59Kzn236DBO1iKCYJftcTSJS9YhzPJcuK1sFIVXCjgQjR2VONLB23GoNBWCqiYU3i/5cMJkYgti72tZNMnD1wIQZ6ZtSAtTHocXtVHMBYZqb4K+7Otf9cBIVcjwHNvladDgZztTgOmog5BHmYRX+/9O6mzPDt52v5MOdXfP74ZUSkGFQbhhgIaESHbtZ9VvQhXBwzAWTLocMQFdjnx0XZ0SZtUdzjvJtiJ/KxB543gCzbPtEcZjZ3uF3Yoa0DHO6PfaePpGSxDh+EHXQJtL3HyF5IvR0qPQ883BU63i7Lz+EDs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 03-03-26 15:56:00, Maninder Singh wrote:
> guard(rcu)() simplifies code readability and there is
> no need of extra goto labels.
> 
> Thus replacing rcu_read_lock/unlock with guard(rcu)().
> 
> Signed-off-by: Maninder Singh <maninder1.s@samsung.com>

Yes this simpliefies the code indeed
Acked-by: Michal Hocko <mhocko@suse.com>
Thanks!

> ---
>  mm/oom_kill.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 5c6c95c169ee..9e3e88c06ead 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -135,19 +135,16 @@ struct task_struct *find_lock_task_mm(struct task_struct *p)
>  {
>  	struct task_struct *t;
>  
> -	rcu_read_lock();
> +	guard(rcu)();
>  
>  	for_each_thread(p, t) {
>  		task_lock(t);
>  		if (likely(t->mm))
> -			goto found;
> +			return t;
>  		task_unlock(t);
>  	}
> -	t = NULL;
> -found:
> -	rcu_read_unlock();
>  
> -	return t;
> +	return NULL;
>  }
>  
>  /*
> -- 
> 2.34.1

-- 
Michal Hocko
SUSE Labs

