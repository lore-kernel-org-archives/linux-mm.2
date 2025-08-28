Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39C55C8303F
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 14:13:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1793A8E001F; Thu, 28 Aug 2025 10:13:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 129D08E0006; Thu, 28 Aug 2025 10:13:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F14CB8E001F; Thu, 28 Aug 2025 10:13:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D458D8E0006
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 10:13:22 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 69335B61ED
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 14:13:22 +0000 (UTC)
X-FDA: 83826358644.19.80728B1
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7DF4540014
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 14:13:20 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="P6Dlraf/";
	spf=pass (imf01.hostedemail.com: domain of cmllamas@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=cmllamas@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756390400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JOBy//lE4jaRCcu6vDfY/P6bkD5/OIBvUSQt0XTkAkg=;
	b=Yk00jKP7DreXuY2zpDAgUbvDzFEjMcnzCc7Z66tOYO82EHaPfJVj8yWwYU2fLIcl8MSTNn
	OpcQFkc2irDhpSrpw/OfdvqGs7u5US2H6sp0r4jtlbNOth8DoPmDaTc5H7W2zRtiL30FeU
	wSz7qIFNptg5uhG2rdmdFZ1R+v1/vFw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756390400; a=rsa-sha256;
	cv=none;
	b=2O3/94jhpnkG1p2L3RC/EBNZFvxD/e8kvfAOvipdPnJkp4/r6mMBz0lJe7YEeU4DBYAmMP
	r6ZMG4nv+VR4hM2a90K9N5lsyMQWEdEnnXcdtvSEEpt7UB0zLkXB5koqTF/0pKPJ1H4ei4
	AY5wESkyfRfiyFpIEXyYJ0x/6ihruHo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="P6Dlraf/";
	spf=pass (imf01.hostedemail.com: domain of cmllamas@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=cmllamas@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-248e07d2a0eso96005ad.0
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 07:13:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756390399; x=1756995199; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JOBy//lE4jaRCcu6vDfY/P6bkD5/OIBvUSQt0XTkAkg=;
        b=P6Dlraf/0xewrbUqs9lNhVVPuBziWNSd+7v2RMj10x2wR7j+jNfOmsDf+aWfPoYOdX
         ujuUz0JZM7Pi9aYSjxo9B0WlZpsbllsqOE1C5//Y/xRcvnaFY06EIKSwThXGpN0kDw4l
         VRK+Ayj1L6Ptr/B1NmK7A1fgaJN57fQDk4mM6VD7whei7DfMmhfFIwIjy+HyoIRsQoRd
         fdYZFKGn6ch/PGeqM+AY4JXowTRD+YV7Gus+TP4oHze0PFkMJ7VjTRETIi7XtYeb0NFB
         6OGowpCVXJXCGvPfTpE+eR//qkbhZP3LHdbVU31UBb6IxTATOwgq7h/ZpOMjPo8KQncp
         vn5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756390399; x=1756995199;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JOBy//lE4jaRCcu6vDfY/P6bkD5/OIBvUSQt0XTkAkg=;
        b=Lw3fcEpLyFfMaDFrlbSWFfeUK6uf+YS+qhKAs/aPn/Ba9GLRJGnMVgBnU3GTrlOV8a
         uBHpB6qZWa8pRC6wwcPnGf8brAB7BaY4cZdP9fki0Bn1dPK1R/bACN0i9v4okydfwlMS
         /4SkMJiwvN2GJW4eSf0ioZbE9sceSiK4Ef3OCsQweqNZkNgkhHvZikh9XZMJL5lM/b93
         PqwPCSjhUQtn7rBsAlLU5ZcL81VZZaEAXLwES1CUHGlrB6QeP1RnG6vLeL2rJxK16Mp8
         HvbgAylkoD0K3pyCI7jio2oq3KPWyNf9fbgkI/6oWEaNHqN2tHD3IQ7rkf9YHjQSSm7L
         gJKQ==
X-Forwarded-Encrypted: i=1; AJvYcCUFVg3tbUnaL9CO2UhB/NXaJmx4Y24LuaKPYwEnj6zo4LuDToOerDD5P2NcmCqTyIbamcRUe0THKA==@kvack.org
X-Gm-Message-State: AOJu0Yy1lmaTF4en2X3FYnGvcM+F5B7wpTytR5XGHe7pOJxfjn0/Ctt1
	AJ3oFuFElhlo/wSyL0HOg0APfWdyVItwRvKfvIYRJHzY4hvjHo7Sl3NCAGBfSBIifg==
X-Gm-Gg: ASbGncuGhPPTVVUMQCbCBRlTBjhZo7Y/MiZiWJaHEIQxf6fUvaLHzjMZu/1WkoTgC9o
	sYq5H5W/j0ge0uK0cK2XmX1jNNEQNlxt1paepQQMwdZ8Ry0LjcIP74nqWf8Xxy0UQqLGi2rClcP
	mEsCIbf8sfdaiL4WIKDqLaXX9P5z2mIpLZh7MqtGGV7gch2jKiKqE1iIEs/QLp1HNf3wFJ8v45Q
	nkwk7LGKNqvqWfQ62/2PrteKUufp/2UehRFxTXwMY1KvhDRlA5US49Yr1+NFO01MXsoaiBXcqXo
	YoMWSM7v2W0yILX2fNQdMVie/cz/D25dw1WkBM0ZUCByUp4APe7s692qM3Xw3aze8QWwrrJsj6M
	vk/NpgwAbQwGI+xtC6QoXlJpPz6oRF2yik/Zl8DtxnezNJWJdZjyB7Kx8rTbQ9U6SsLXfFHfE
X-Google-Smtp-Source: AGHT+IEGpiNlcAAPPrz9en6KInijXkRAY7kZe+iB99bFlXYKh+mUpBkPrgcD/Y32o+kDxyb7gRU9rQ==
X-Received: by 2002:a17:902:ce91:b0:248:f76d:2c67 with SMTP id d9443c01a7336-248f76d3d84mr569375ad.4.1756390399061;
        Thu, 28 Aug 2025 07:13:19 -0700 (PDT)
Received: from google.com (3.32.125.34.bc.googleusercontent.com. [34.125.32.3])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7705708b42fsm13251491b3a.80.2025.08.28.07.13.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Aug 2025 07:13:18 -0700 (PDT)
Date: Thu, 28 Aug 2025 14:13:13 +0000
From: Carlos Llamas <cmllamas@google.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>, kernel-team@android.com,
	linux-kernel@vger.kernel.org,
	"open list:MEMORY MAPPING" <linux-mm@kvack.org>
Subject: Re: [PATCH] mm/mremap: fix regression in vrm->new_addr check
Message-ID: <aLBj-UanVYBax9aE@google.com>
References: <20250828032653.521314-1-cmllamas@google.com>
 <8a4dc910-5237-48aa-8abb-a6d5044bc290@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8a4dc910-5237-48aa-8abb-a6d5044bc290@lucifer.local>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7DF4540014
X-Stat-Signature: 6dhj696njmymewngoynyt4bs4rk9yau1
X-Rspam-User: 
X-HE-Tag: 1756390400-108555
X-HE-Meta: U2FsdGVkX1+vCNW2K2ClPN3U0H0xdo7UzIAD3hmYMoeYWSJcfg7WvprjZRyD6JEBvrwR6BLbBTuINVNmOoOzjf9yh0XmCEkdYXi8M031QUBqEQOLULUrDz518Yry1gG8TIA5cgRKH2rKwVc7ZrW8/+dVWBxEP+t8CLq0lAtgIvgnq+f3y2H+V1VznwSuLD+Gb+0kxZ70fU+VB2Q9UjyohBm4y4t2aqpd7viyrPhddLcxi9pZdXsb6fQ57Z+kx4qP69TpBO9tR3yAyKNQ9aHpFh16ubybRa3MOOEQyx9MaevOOllrn6X7OsnBapZjw2rqjEXJ3PNiuUsyyHFaYuQU7/1PzC5XpuZKr811ZsbUf4JZe6YXPw8jhlrfxQSZDY5f3VbNz2eiGDH/o7DGwo51BirtidqiFwWsyItrSoezBgHNXsovyICWapTQLj/4mD1fysoqIYD0MgQMbIxKwPAqWlm2UuDFGWz3E9m7KZEnrJGiM7lMZ3+IXQXEpztvv3AyX9D5wZUuYDE35CbfC80lbN8wEaSpnvZqfFEHPKbaFymuu/EI2a0DPkvrmlfKoc6+34Hpu9IZ4AcfX0kI9T+B+UOPH+JbQzLPPX0n62OAis9J9WVx1C38R67r9GvssZOqqPL/6pMG9RfCJPAqsqMQ3x/t7oAoTxqUoXqsW1jotilN/kjBl/ibAv1CN0ZwxycNru1p6UhCkVggYKLcz/m7aeWF6qfm0VF9HWGQed+iXGvYy7CV/HLlaP+RmKzqov6zVjsD10Bh1EKdB0iKVZTWcOv/2eG3Q+J9bFsja7kTnMu+SaU1RWsnF0uC75zA05XNs3jOMNQoNAgTYkA2W4hASSZc6QOvt8plXPEU77/k5DU3+toIfCfftthlv+ZJPPdXFpekdeYEhO7u0XEy99SQRSuZw38SqceDHTxJPrmR2QSdGL+65q4bThW77yPEC5w9vuhByX+a2ZwhY37kk9i
 2+pEmuDD
 PfQSXU6ANYdL5q+iLnXPdkMo10LsGgKM1KAg4L7gpdoOeeGYRYYDnGcANZ9A2f0wnl9Wq37FD4ixDWTeJ/2OoReabBYlRtvFmhNIMUZZ0tcG6lDAO8uFzHPU6KiXJZN9dBneso91CJFq59GKyXN44XEG9IijpH1zIsVkst+jkCvQPRntrhG5NwN4C+OpxwUjruyumpOmwP0Hj7vfiO6pWk6Sim105rB0D8lYZekNf1Llp9WJspR3fxtTBSSFZMmGBsQ2xOFB+Tcu39h8e26OYsMv/rF1EreZ+49oukPZpMfHeyaomlyTDkIfsXZafx/b3Dx09/8wApFDjuIssgCotWbfaldOAW2M4WTNlf7qSyM5Sn3sRTwiRPFzk6Kv4bE2aXoCG79HFCoFLUeN8QlDoeSofzA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 28, 2025 at 06:38:09AM +0100, Lorenzo Stoakes wrote:
> I'm curious why only you guys have seen it, a theory is bionic is sending random
> stuff to this parameter when unspecified, and glibc is not.

I honestly don't know and it could very well be only with bionic or
clang. I'll try to find out more about this, maybe glibc implementation
zeros out the 'new_addres' register and bionic doesn't.

> 
> But obviously this fix is correct, and the original code needs fixing.
> 
> Please respin a v2 as per above.

Sounds good.

