Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41F85CAC5B0
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 23:17:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72E968E0008; Fri,  3 Oct 2025 19:17:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DF1B8E0002; Fri,  3 Oct 2025 19:17:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A6B88E0008; Fri,  3 Oct 2025 19:17:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 42E3F8E0002
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 19:17:21 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D940E14093E
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 23:17:20 +0000 (UTC)
X-FDA: 83958366240.18.F7E0E7C
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf22.hostedemail.com (Postfix) with ESMTP id E429EC000C
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 23:17:18 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="vv2s/Gnm";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of vipinsh@google.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=vipinsh@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759533439; a=rsa-sha256;
	cv=none;
	b=sC7pglQISf33xPwqNbdchYIlQVlJ0HJJ70rgAn79yqBjOLNG4M/TuJBv4Rj6SEkeKIn9+E
	k+/9HvGlGk6D23w2y59qf90DzfMPWvn0sl9By+UYUwoRTN6nz181c//ymBL79cTnaG6t7K
	+LIt6PCBAHO39j2ZElg/tYcPCW4YjjE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="vv2s/Gnm";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of vipinsh@google.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=vipinsh@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759533439;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BqNIw1YGmI341uZYGrCWK9ZhHORfzlcwYubDz9DWoW4=;
	b=arlYCYO+y0tYNUzWPuY9K/yLOignD8Y3pRR8F3SzsnS91545FUBkhL/8qHoFhnUZDjvJSy
	IUzUfAq0a9+CpOFJL+0jGBX3FXC2RZiOas9wnZkP37lsb/zeylIlcaQLQOer+PAnQbpBUE
	JwCDoQfwUth9jrWTS2/yEci/Y9T2Yvk=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2731ff54949so31155ad.1
        for <linux-mm@kvack.org>; Fri, 03 Oct 2025 16:17:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759533438; x=1760138238; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BqNIw1YGmI341uZYGrCWK9ZhHORfzlcwYubDz9DWoW4=;
        b=vv2s/GnmpahqtFT7QJjWtFZ25PAfxesHGQvye0d0F9ddzqYmM8SwPfYa1BQ4vzhvaX
         apmJ70XeuxRwZpmhU1YYDhFrvyHBil6tSjWU5Yuay/2nuNOSR2QOEEqR2w/y7ZGAR8hE
         00v5Y1U4FVMNccLpt0KgNJ7ld56+vS80zo6kMAXn67qnMl7EAflLUUKDV6GBdxPaY/b8
         l1ilhYbvNQRirpCfMhj/zHI4S1mDBAVUYEqNy7h6zAj/lqdcO0ijyF6ytP9UsHU7Igx0
         KDlUwCqgxLcLiCrhwvx5TXVa9zEvStuact6ko2V1KvWgh6hILCCZnmEanL0+BZIASUEC
         cfBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759533438; x=1760138238;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BqNIw1YGmI341uZYGrCWK9ZhHORfzlcwYubDz9DWoW4=;
        b=lTM/NySh3CMe+zuBe3KmYWqe2Q2ov/ZqoOgUXy/G2WPVCDkwjaKR9LPO90FO8KxT0J
         xNCepY/5qD1JyEPZvloRIGPimv6MrS+Pme63m/80S4bsFKZa0EtyAKAMqBy85xDDfjmz
         h2ZEjsaRVz7WXIFSMHc0RRw/gwTa/MnxJZOYw88+0eNMperLKNzhOIGC4OHGgGOKBblB
         8UMDzARmx2Ud4MsZ2pWeViue4nVdu2qqtdsi4dmg6t/efoNbQgHZn68TEnVhEJZEHEZv
         +qRgsTthQk/j8PeVTiNbWlBwO/obNoDPx7ykZKqUOsPBa/h0rhoMBYmkURQBXpQXuyCE
         H3uw==
X-Forwarded-Encrypted: i=1; AJvYcCWgzpsS8h8XJX7fM3EPF+C0wFBSZv+m65pcyyOLyym6ShvBRovfXg2zgnF+7N9VPzh6ME5jJxTPaw==@kvack.org
X-Gm-Message-State: AOJu0YyJwaivzpDdhgdKGJS2DDUtHkjrwW8nQ6v020TQ4RAeVbeK/ymQ
	LOj14kJX/8ycZe/NzXrmqyb5U3zlRxYxu8lM4vCG68LcxBqH/cVFSGE3nEk5OFGQ3Q==
X-Gm-Gg: ASbGnctly3dulzsEswGIV9fExykCf2NyVTtm6u2PdMcYEppD2Y0XviQIqLc0ouduWZR
	SajB+9LefBsBx9f6rU42NBX0gA2v0mPrb8nyG39d6yg/gU5Vvp8yYdtOh13cHvgfeNzIbLFT+B0
	ZibrMxIIq46LXy6kVmkfRI1C4Zc4Zc8MWgbZaW9CoQmT/GejsYTpurkrLz+AvNxWpBTLQSJc8dW
	zmOYCW7HOOVkvrdS5HJKQ202D1khmcpIgOgB2DZVtbiQETRpscwJ8iK3YBDEIDiskABvNsTDdth
	WbmJar9LOF4kHI5a7nAfNEz06TAx1j5S3BMHiIhXtmXKRQ4z+8ttMgVza/Gv2qv6KdyjgophQFY
	VyHKhYulW7WiLrS6V0m5sJPudoQkYxOvuhvocI40TxSAly4oiGzWR90z1Eqyyce3F5E6+ZwAvM2
	ElFcgjEutM3AQ=
X-Google-Smtp-Source: AGHT+IH2PZQKML2R5n+BBFPUW8xCHC5Y8Kow9Od4wnT5GRTXGwVXHZ46Mp0pjYj0WarzaHWz91nJyA==
X-Received: by 2002:a17:902:f68b:b0:265:e66:6c10 with SMTP id d9443c01a7336-28ea7ebef98mr1733985ad.4.1759533437467;
        Fri, 03 Oct 2025 16:17:17 -0700 (PDT)
Received: from google.com (60.89.247.35.bc.googleusercontent.com. [35.247.89.60])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-28e8d110d91sm60950595ad.5.2025.10.03.16.17.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Oct 2025 16:17:16 -0700 (PDT)
Date: Fri, 3 Oct 2025 16:17:12 -0700
From: Vipin Sharma <vipinsh@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com,
	changyuanl@google.com, rppt@kernel.org, dmatlack@google.com,
	rientjes@google.com, corbet@lwn.net, rdunlap@infradead.org,
	ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com,
	ojeda@kernel.org, aliceryhl@google.com, masahiroy@kernel.org,
	akpm@linux-foundation.org, tj@kernel.org, yoann.congal@smile.fr,
	mmaurer@google.com, roman.gushchin@linux.dev, chenridong@huawei.com,
	axboe@kernel.dk, mark.rutland@arm.com, jannh@google.com,
	vincent.guittot@linaro.org, hannes@cmpxchg.org,
	dan.j.williams@intel.com, david@redhat.com,
	joel.granados@kernel.org, rostedt@goodmis.org,
	anna.schumaker@oracle.com, song@kernel.org, zhangguopeng@kylinos.cn,
	linux@weissschuh.net, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-mm@kvack.org,
	gregkh@linuxfoundation.org, tglx@linutronix.de, mingo@redhat.com,
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
	hpa@zytor.com, rafael@kernel.org, dakr@kernel.org,
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
	skhawaja@google.com, chrisl@kernel.org, steven.sistare@oracle.com
Subject: Re: [PATCH v4 18/30] selftests/liveupdate: add subsystem/state tests
Message-ID: <20251003231712.GA2144931.vipinsh@google.com>
References: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
 <20250929010321.3462457-19-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250929010321.3462457-19-pasha.tatashin@soleen.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E429EC000C
X-Stat-Signature: 98c4dhcbqmng44dbsrifm483kxy5seiz
X-Rspam-User: 
X-HE-Tag: 1759533438-980197
X-HE-Meta: U2FsdGVkX183P+qKlmqjsLT8Ug1Pt8M26DND6c0hmbhHXWLHWpf46E728Fg9hC4iVke63/mStdtdo0BbSVjV+tVuiAs8gjT+kS1Uxq3X33gGeLBDx0eveF4XYnQcfhxp4vlY+WogvcWemKRl8R3aYeXgj2xppCF4gAd3s9ORkyH3YNoaF/loxyVVBe7JMgDHPduQd7RBQqTDARbqX+Vit9OEx/eAmOPXYALNr8PINKjbPCHp5y0lD/Eoqw3d8Ut2vlwJwZSw6rwyiDdJTFQ0ralHEYrydqUYOQTyJeJKziDYaVSnWhzfM04JRANKIwDhL++OfNdlCZqnj0Di/O/jRnLU9oDeZn5B88ApPtWtNA7GN/TEyYUPPRXquo2rbmnqmC26efwBP6EP4IdCT7/jCY4o62NiO077N+miDHLKMR5VEl8v+tiGDZOeW4EC9uw8q1+D5nDKvz+IRg5ePNj6XogcQtCbUO1eNViEv2s9TRHwYwZ7LC7sUmLm2T9Vb7pbn2M/05cA8S3qWdDjv8oMBtXKLJusipJHSTjarIhgzcpL5dl1dkLhS3Yu2I06Bcg6cJlrJYf2LJbAl+pOCXN1li0agkZRUv6ZGRyRcqpo6S59tY9MH6VkmNKrGF8KAkFG1Tw/ohy2l1Xk6yv4Bx+XIc1dgiR+gtxiFi1IxznCU/yjhTa+hSp/wnExsBlh9vgcQCp1V/ynX5+vpW7P4OJu6fZGC+14ESbIMi6tnX3yurQDBcKgZE44cTId66T6myaJFchYKY+2Ygxflww5AkTpUPAIdobVj/MuCMJ8XLQ5ny297d4s9TvQPA0A4Tvvqj2P1r89YOSgXf1qI4Ppeh0rsG4LV+l7jwBXT+ZBMnGatS6HHJ4PMevgfRo/vfUUooFKMp+XUEs6XBTauTJI7pF7bioYJhJOoTlP56u2/luGXKrTQAeqCNkMlHS4Wb5pnk5upWqAdhQkpvEwLU9nk55
 i/EQOoiL
 m8JmwWa3/FRvGxLGKHTq6/jcq8L3ZQieMpi7oykPha2nW4E2ApvKSAGTQ7qryG3lppCIOh2cemU8NXCueVhKeDWUOanviggVpSOIpTDEtz7byzmn7n+hgnowCjvzEMcIwB0m8EFnoYELLkMUShyq5ApHX3FjX/xZsffzgCIpKGhDBpALrMb5ET4R3f94AZvKz2qalmpFih9rtOrcgZFR7tIeGKZ7nRr1+SCDpe6PheXWYgBz+79KI18ImE/z+bsUay8qP/orhaKJeROD03OZuLn+XoThM2MygRb6mY06ZGjzQILwBCeYf4iM/hk9zqAW8Hqy/3nO/2PCaTXcP0dIlLhkpPQY/H640kYi6DJ8plI/Bqe61PpjIgQTK5yeL1uA96/lXf2reEM4LrkHBpvpO0mbdN6rHjOInvzW4daESkVQFQQpS3WvE/F7YOQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-09-29 01:03:09, Pasha Tatashin wrote:
> diff --git a/tools/testing/selftests/liveupdate/config b/tools/testing/selftests/liveupdate/config
> new file mode 100644
> index 000000000000..382c85b89570
> --- /dev/null
> +++ b/tools/testing/selftests/liveupdate/config
> @@ -0,0 +1,6 @@
> +CONFIG_KEXEC_FILE=y
> +CONFIG_KEXEC_HANDOVER=y
> +CONFIG_KEXEC_HANDOVER_DEBUG=y
> +CONFIG_LIVEUPDATE=y
> +CONFIG_LIVEUPDATE_SYSFS_API=y

Where is this one?


