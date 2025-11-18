Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16E9ECEE342
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 17:38:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DBAB6B002B; Tue, 18 Nov 2025 12:38:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68BCB6B002D; Tue, 18 Nov 2025 12:38:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57A796B00A5; Tue, 18 Nov 2025 12:38:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 40D9C6B002B
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 12:38:45 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DEAF112BA22
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 17:38:44 +0000 (UTC)
X-FDA: 84124437768.01.FF1A7E3
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf09.hostedemail.com (Postfix) with ESMTP id 066E714000F
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 17:38:42 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=DjE6QO+m;
	spf=pass (imf09.hostedemail.com: domain of dmatlack@google.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763487523;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+KOpYFcon0iDNFMIs3t+r9Ea1btmn7c7oPi7Nmj2oec=;
	b=Z6u7wJd+oAaWD2+srWtT3SSIjgpQxCvjCB5vZzbGc9ItMWFZXO1vfMeHZR6uLZd3shzuaB
	TqjptR31Secxj9ZPhZ2itVwjFHOJi2UO2bsNMsPoIXxRhGMUufkS9IB4NiSXLgWJYZMBUc
	gVyIdSU/X6+gM5CTozS8txt7/gENIqI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=DjE6QO+m;
	spf=pass (imf09.hostedemail.com: domain of dmatlack@google.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763487523; a=rsa-sha256;
	cv=none;
	b=ZTSd0x5GYTcWMGZBkuRNzqddaFjwB25a2ul3fsBHzgppOghv8KaqveE4r8XWC4xv71PkIn
	sATPiVRjTjNgAP+NEvCi3lC6WpNMZgZ1p1zPmiKJqsobh18Xi3GESTvPJlDWLCIf0ACfqv
	f4VtvDJ3X5SP8lc1EfBcIMEb33fZhVw=
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-7bb3092e4d7so4299602b3a.0
        for <linux-mm@kvack.org>; Tue, 18 Nov 2025 09:38:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763487522; x=1764092322; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+KOpYFcon0iDNFMIs3t+r9Ea1btmn7c7oPi7Nmj2oec=;
        b=DjE6QO+mCaupFsSftvcGwsinjwVxoPlkj39667x+jYM9PfLG0A+prN6BCa6xd0h4j2
         JYTdptzp34H42YPOZisSsQEFG9jQ4op8OyNoefsCwELJ7nNVD9wms1UO4TiSyAGt1gvz
         Ku+JNaF+JhDP0rkd+C/WnzUvzzuuIVhWHz6fqHxxTBlEh+eDh55nNhUFBODYBPc+TVuK
         9rLzunNthEQym6OPijyeOF6QlWQqO8Wh7C5Ps0EOl21zKO9UUDiBrJaRyb8JSdMq4Iy8
         sExFykaT541+SM9U9Df1eG6t8vB/uBWn5PPcC/ouPPOlPGEXHY+RdyrOJfPIBMX3XXby
         goLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763487522; x=1764092322;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+KOpYFcon0iDNFMIs3t+r9Ea1btmn7c7oPi7Nmj2oec=;
        b=xKNkZoXbvgkd83crmYfEKzwhKhgHZ8ZdDmAiIw5dxaNcyNiKZ9kOSioFrxD8mHStsT
         5fiX8xaBafYQWy8oaZJYN3AP2s11kNPVTc/zpZn80G8FrfjhO2fJkY3rbhtmEMc+sZhj
         su1f/YPpsYQU5i7GEg7PZo/JLZdEPitGvL9igXboELHpV1Uo2kIOfFVKsRLHKuZx/6kY
         P/Y/8kEuIXPKAyyBVzZX9RnhLZkEEQsyIOYMKVEZh1SSPahJEJ01E703qZ7aH23AhN4M
         Ex1XZMjllCwilxdFghSd4VGK9H3+P1JfzQ3Mho242gupKvyqGD6U8jwyIVP5buw0CtJm
         gF7w==
X-Forwarded-Encrypted: i=1; AJvYcCXs3/LqIfFlVk74pI+v09ikZhtHGpTiy3iof/Y0GkzS3FC1yIpg06Xd209k771sEIQT+w+vHo7kJA==@kvack.org
X-Gm-Message-State: AOJu0YzatV15DilueirTzn/dB3bi5GVCjnfRz/5M9Fg78MG9mAdGneFZ
	HEX0q+EumuARHUr6IuATTV9w0pX0qcoU5j3wK8HXgcujOTm5FxXAYptg7Iaw+yU9Ow==
X-Gm-Gg: ASbGncssQ2NtIQeKdtJXOWHrwJTon/1O0jGTIz6jS+7/uZIo1sf3Ik7QNeqUhu1bLYI
	39Zh7aSs1gW7HxgdledUzBjy+U1H+Vkh1o3HtzgT7VswtjfJQUtilS7mm1Q7/kJxcq3lxxqdpKt
	kNRc3LqwUHJU5Wkq8KQ2bF4Rq4fS7dsmegoHz0w1o6vgsGcCSzzt4K/rC9Yb5YWKyl6Yd/NhlbG
	uQedXdp3Tsc2fStClKw/52PEPFphrwh0Y6UNORGLH7nu4+R/uvw0ohs61uR5c6GGNMs6tcuMaLk
	77ewqw35UUPQaRxYgoxZtsYdWYxRMX7jPF6nwZMJDYLXXzRwvVv8Gh613vjBl+yQDey/TUqBG8E
	Dy1P/olhK1weS0HgCnLvGMBH5ab7/ghwy8kc8eGuO2njdXVn9UtZUYT3hM81xjGv5zrTKsv1Xf3
	s6KivrybQnOTrzdqF/YhtRYsIkekEDykxTqalmTciKoLEk+GknsbcZ
X-Google-Smtp-Source: AGHT+IFHhg72xm2TGOlgC80Jpbc+gsGTnmY9bbV9Ns7ch2lY+9eWvW41JSseHQ0nLr5q5q73zE6FJQ==
X-Received: by 2002:a05:6a00:9aa:b0:7aa:93d5:822c with SMTP id d2e1a72fcca58-7ba3c27267emr14948626b3a.23.1763487521172;
        Tue, 18 Nov 2025 09:38:41 -0800 (PST)
Received: from google.com (132.200.185.35.bc.googleusercontent.com. [35.185.200.132])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7b92782d390sm17124484b3a.60.2025.11.18.09.38.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Nov 2025 09:38:39 -0800 (PST)
Date: Tue, 18 Nov 2025 17:38:35 +0000
From: David Matlack <dmatlack@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com,
	rppt@kernel.org, rientjes@google.com, corbet@lwn.net,
	rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com,
	kanie@linux.alibaba.com, ojeda@kernel.org, aliceryhl@google.com,
	masahiroy@kernel.org, akpm@linux-foundation.org, tj@kernel.org,
	yoann.congal@smile.fr, mmaurer@google.com, roman.gushchin@linux.dev,
	chenridong@huawei.com, axboe@kernel.dk, mark.rutland@arm.com,
	jannh@google.com, vincent.guittot@linaro.org, hannes@cmpxchg.org,
	dan.j.williams@intel.com, david@redhat.com,
	joel.granados@kernel.org, rostedt@goodmis.org,
	anna.schumaker@oracle.com, song@kernel.org, linux@weissschuh.net,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-mm@kvack.org, gregkh@linuxfoundation.org, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, rafael@kernel.org, dakr@kernel.org,
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com,
	myungjoo.ham@samsung.com, yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com, ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de,
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com,
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net,
	brauner@kernel.org, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, saeedm@nvidia.com,
	ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com,
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com,
	skhawaja@google.com, chrisl@kernel.org
Subject: Re: [PATCH v6 06/20] liveupdate: luo_file: implement file systems
 callbacks
Message-ID: <aRyvG308oNRVzuN7@google.com>
References: <20251115233409.768044-1-pasha.tatashin@soleen.com>
 <20251115233409.768044-7-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251115233409.768044-7-pasha.tatashin@soleen.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 066E714000F
X-Stat-Signature: nagi1xhihm15juskesogu4m4m8qocxbd
X-Rspam-User: 
X-HE-Tag: 1763487522-282740
X-HE-Meta: U2FsdGVkX19l+24CfjNhkXlxk3p5NLUqotlkV4092WFi1KFRf+BB7Y7Jm+VgohCYMjNsOHRzptAc/ulA2wh/O20K1KZafFYdbnV8mTNp9d0BVjipphY+B3v0+jojpLG56z1dyFv78bxMf1CKmpsIOuGQB7htRUGur/i1DNSmqX98oAS7tL9cl1kFP1dDJXl8Rg6zLJ6QeL+ou0IZpDJga6QBQyumyab/Al+KjKRyxYbCbviYrk5d+tn+B6RMg0wFqMTxldT/bXqo5KKYhnc3aiEDCshzWtE9ez2HW3q1tCg4O+T9zfb0cx0LQMEYdl8wWF7m5hKD3LQ9Sij3r6WEBn41aaiBJHRPyxCKAs6qx0MEWYF7cvLHsALns3txOl5ZOUdiJWWFjMxQJa3jlQm748PMjlP/i0mf582ElYjA1A0VxN3XXcahn4HKUI7v3DacV69kgNCQKoScAwHE3ZiQIfG/FKYdqWm665j4CHO9UepN3xf2vWRL7joKVkNuCfNGcpp9arBN+scU1WVJABuuIJAH6NHgKF58awrGU+ZRDUuZVc4GFx74gToIdtut2h7xLPEZiRicffx2KCKnA5UgPMLPpEjBhkVsBE6I0qgLv/6bqqKLqlhaYhJZnvThv8IaHy/oNLl/qyWJpsFm0AjzJ16fYzyEqBn6/uhMdTKMdGtyw0r6CUxRUjRJp1iDP4W6zaZQ7bRba2m1CJBq4qT/QIEbTJv7TIcaQD+Nq4XH/b7X2y5Ht+1ASybQkOPoVcHm/FiHnJq/2dhuHvbezTRGkDgRgGHaqdwPsCiwFMFL9t/eJgmyswIOQK1J6Q7ofXq3Ph6BkokWZMbxngVMxE3vciPMoVIoa6SJYKLMQVzCJtYY1vmCwR22UwJOpoPg2QUpn6R775c72RCtfn+XktecmDVvxp9fx5xmoKeKL8egdxkEUJAsGnd4TJMJz0O7vQFM47Q2+PLjYb+PB3qZiij
 x9haCkkA
 q7hx1Q4I6GZZFnS5rXLp3+aBUcIzEoY0oe/qc+InVI3GobSLGYFSK8eIS475xxE9iJcjiwnVC7hlSPJ0QO7JTJCHPCekAiVVO/kb9w7TJlHhvJ6ckjYx+CJjj4u+fPy9XoGuhk8it88rEB4pGlQK/W4tAcwoDFCoLCGB9RfS3yg38VnDSqSFcEFvMjVuSChpf4B2lUX4emOTzcnAWd7YqwUXxafOA++07gqezxmKkINJ21hL59GTzb/QfV34PMtH1YDZPw/UJv7st+ubjpPIBEAK4R3jdN4DEOtcYQwy4aZKCe8ryYl1OtDt99VNFXRxE/pdhhTs5NPn5frT7JWNqYKhk6E3uvk5Z63rqiZ3tXF+Trku8njv3b/Sb134yrNudr7XEJ4ZikZmP9d8bnXIhoTpo/TjSrK519mYdxAq3kYr380iDm14phP6on8Aw6dPVaTaMP9XKT1TNyTPyStjbyeVELGbBcHiEx7qhKYdSnOd1CaQXUD5zsjhgQEvn56XTmPW3E46+3KvdbAZcGf26BubyTT+TANBWt1RgKaAXOWeD1UcUhaMGUZv4Ow==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-11-15 06:33 PM, Pasha Tatashin wrote:
> This patch implements the core mechanism for managing preserved
> files throughout the live update lifecycle. It provides the logic to
> invoke the file handler callbacks (preserve, unpreserve, freeze,
> unfreeze, retrieve, and finish) at the appropriate stages.
> 
> During the reboot phase, luo_file_freeze() serializes the final
> metadata for each file (handler compatible string, token, and data
> handle) into a memory region preserved by KHO. In the new kernel,
> luo_file_deserialize() reconstructs the in-memory file list from this
> data, preparing the session for retrieval.
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>

> +int liveupdate_register_file_handler(struct liveupdate_file_handler *h);

Should there be a way to unregister a file handler?

If VFIO is built as module then I think it  would need to be able to
unregister its file handler when the module is unloaded to avoid leaking
pointers to its text in LUO.

