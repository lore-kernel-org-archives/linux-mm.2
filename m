Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49547CA5FE7
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 21:44:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 159006B009B; Fri,  2 Oct 2026 17:44:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 131626B009D; Fri,  2 Oct 2026 17:44:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3B466B009E; Fri,  2 Oct 2026 17:44:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C720D6B009B
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 17:44:35 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 50FD412086F
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 21:44:35 +0000 (UTC)
X-FDA: 85279015710.01.661FBB6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8B082100007
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 21:44:33 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AE3K2Vl6;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790977473;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OA3SWpmyamGsgLm56ptL6ZZTSR6Zq7plBZES8synHmE=;
	b=Uxv6RIwTjWdoitExuVxU8mAI0OuEMohUFoiEijgkueRSKePZ04uFXta0z21+18Ip8jzBgU
	+wNAGgSCLAjAxddk+Ev6/ZJv7MZTyVS+N0BIg8LkKxOGnkS3oauBH4nsFTYmdu0ckYKNvQ
	cRKqjKzJQmXp8BkV0zIIOYdjzz+Gb6A=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AE3K2Vl6;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790977473;
	b=bPDh3DxSdtCbQCNZ+1Vslv+xWPMvYxQ/QF6g1Sa/d6U2d78bWLKkJtkMrhL9eH5dm1zAFw
	8SLqiVk0je8ZiYCp6q6MTTqw3G9drwtHkAgE2ALYdAtq3fWHiZUf3qD5Te2fhxZ/5lIOTs
	3kI49qcEgs5dPItIz5Le+XnxXsO0R44=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2F1CF60D7E;
	Fri,  2 Oct 2026 21:44:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 796E11F000FF;
	Fri,  2 Oct 2026 21:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790977471;
	bh=OA3SWpmyamGsgLm56ptL6ZZTSR6Zq7plBZES8synHmE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=AE3K2Vl6OU3amVn9J34OyDXo5u1hI3Mgm76Co3njixBfbVl64pXy3KEbB1jH8gRje
	 QzEjOx/ZmPa7dt1h1ln0FZNOs9B5d7jj1GcFevU7BKECR4TXLrzS9x+6/afNqFrGT7
	 yNEKJavEShFhBifEUwBHpczx9wfA7LjwqY6fcQZfjIOxWvWmDdWdPhs8aj0q2SlDQn
	 FYkHpHYM2SXBmscPVtj/tf8Xdi53y05kFVkFgW6wFqz/77U6tWGH7KCPpGkArViUfj
	 tNE9xVruf47GFQGiBY8JlBhcz1AvwBdFtJMDo+bZCZePjO602Qjz/uH3K5WiBZ4yUf
	 +Tq6ReP7g1HxA==
Message-ID: <a202523f-a696-4a8e-be77-7170c3913cdf@kernel.org>
Date: Fri, 2 Oct 2026 23:43:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 31/40] mm/vma: introduce vma[_flags]_is_persistent()
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 Paul Moore <paul@paul-moore.com>,
 Stephen Smalley <stephen.smalley.work@gmail.com>,
 Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Doug Gilbert <dgilbert@interlog.com>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>, Jaya Kumar <jayalk@intworks.biz>,
 Simona Vetter <simona@ffwll.ch>, Helge Deller <deller@gmx.de>,
 Sebastian Reichel <sre@kernel.org>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Masami Hiramatsu <mhiramat@kernel.org>,
 Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 David Airlie <airlied@gmail.com>, Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin
 <npiggin@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>, Anup Patel <anup@brainfault.org>,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 "David S. Miller" <davem@davemloft.net>,
 Andreas Larsson <andreas@gaisler.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Youngjun Park <youngjun.park@lge.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Chengming Zhou <chengming.zhou@linux.dev>,
 Michal Hocko <mhocko@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>,
 Xu Xin <xu.xin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-usb@vger.kernel.org,
 linux-rdma@vger.kernel.org, selinux@vger.kernel.org,
 linux-sound@vger.kernel.org, bpf@vger.kernel.org,
 linux-scsi@vger.kernel.org, linux-fbdev@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-trace-kernel@vger.kernel.org,
 linux-perf-users@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org, sparclinux@vger.kernel.org,
 fuse-devel@lists.linux.dev
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-31-4583d8a23bca@kernel.org>
 <9bbdf4e8-6984-4477-a183-f0b236047381@kernel.org>
 <3557015d-23dd-41ef-9832-78b58587f3f4@kernel.org>
 <81e1e5ae-0aab-4584-81e6-3fc9c2634d07@kernel.org> <ar-b_Ug__TBzIZsb@gremlin>
 <2e5a4e6c-8f9c-4050-8998-454b83f4823b@kernel.org> <ar-luB9QVCRshtIw@gremlin>
 <3387642b-c39f-4f19-ba0c-267bbd2fe91d@kernel.org> <ar-ux41ILjI1Px9S@gremlin>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ar-ux41ILjI1Px9S@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 6t3yguabomhzk31yyo8jcn5s37mzzmkn
X-Rspamd-Queue-Id: 8B082100007
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790977473-422017
X-HE-Meta: U2FsdGVkX1+cKWB8urkM0mh0euobBygqE04F/AQ91A/NFSJY0MQJ84gowpK6oLB/LfHrHpP56VaFaEs/EaMxvnLnEFmN+qcRdi0IPH07wEy6f0DTGPwS73rBL3ZjQFm5kbqQwOGdH7Df4TVCtfGrNgXp490b1wj06eVlxBa0tkx6F4Ski20jdFdIImFXTgRHQyIXmftXgg3ojX3kZ9LrK5VxMvj+PoInbw/nfDuc/N8GF60D/CEzPxdmLWKXz7nxS2TBxd2p+5/Ji3l0lmJeZedYoNKI3Nw+uf7fprCemvDVRLswxq/2BtIvX0Zgsluy+xT9Iaw+UgQHGwq5fvL7k4ZoY+hwNuIZopc8soCzEHWPx71fIW81Ymuq4MnND5rh0J0g+/xTR85tzHbkV7Mo236bzrTuevHAg8j5XC2EL7Mwg/mP2AqZKLN1i46qODfF6a+e/CVlN8ZpfZFZTg3RyN7mPZH7KsFHCaE5piyfORc6pIMZAxm4mIkXNEqsBf5fymSbkf72R+Sol/4fXMa1FM3olq+7PPWI5ZHJ1MnK5KbL6hccRBPL+hXAQfHMSEpufyCAAyIwKAstAm/TqdITKzim9wHKzi9HNx+Y1alViRaF9Y6qWi1Stmk+1TrnpsyHDkJGduYs4hDL5JUbYDmYCPONNAhWqz5kdxupD3GOfqNthQnCeWtIFqbbMiBiJ+RN1CRGlEPRsmds2Fut8uBv5sjwT6j9V0s0QeVt7bF5c0zfJ1Wm6z4uJfkhR08CojlU4IYwql92DFnVw0tOf1gtEZPKLYc0i45/y0fB2QFM3HsxehCHOD/FtFQbcYZ/7qCQzM7BuO4LEfdPom7Cnv/OZJKy6TQGTAjZZu9DY3De5dRFEMZBtYIynfctl7hiqyHibhL9IS2smiLoNlJq8zU3NYS1BEbrCQIl54Bzy5G/dqhVzOfTvkVQf0wEyoGhtHfxOh0RN58IaSmkpxFqKPQ
 ZlJLb6K8
 hEbEsrZlbC7Su8yVvltWufWPT9VDHvXBxFd5oUgV8isGggXruMjkES3PCNnKpjXU2f8CA583Emv+/TFHdshHLRxedg0UuUEiu9gMLuGmGyOlnhZM4f4oMEVnsYUuSbMYclsXxnUOiRrTN9wQRLYWHkNouoJZ5mY8pvolchyBgud8AxHIyVTPFv4hz/RaL031DLCtEwmNOUdf8pCYoZNVNYyOUplMV9QKdnjiOO6TgzMtaHFKEgbRCvDDkB8ll5CymuIqPIc9XtS085D+c5yxEtlb+BpdZ8WRu5EiXUO2B4tpiqfL2tVYBjSnEjXyXW86GLtQ/NJ56W7qqjgYMQc3/LN7uHLAwB1t0s8v1eO9IBu1P/tMYDPaIOiFd1iEXSLbFyJWJOH7XE1rQ7BHP9UJJZn09DUlLl1JRWGYJOm0kLBdrZekV+iZFz01TYY0vDPsaic5iXUj7P47VOqYG8EDGDPLk/EQhkUpRPjB367a6BuuiaKApdLSnTdYYJY/FaEnB3vMJilEgwuGg3NbpcGFU4+ppFsY5ubYfob4Fp3dwoI7qBtFUIG1DYlJg+kA5ZSCVUXl2BMdGNg7yxnfy+sHXgONsQeI1rZLU1ZaJy1G3AYV5NloXXNKwh2NkUfEPp49UmVtV57HkUKIUSsJZeLY58oJA/qTnsBKEPjN+f5rG44XXuXv9UVADnHrbtw1IxVyQmdJPuC74zJoVnfIjfeVAJPE/E/UscXIvuf+q1Gl1zCh7cV+t1oe/9uJYqgd36d2xiiTpIDIiDDMcdgygR+i3OW9BBInEsxHeM7VP6tot26E5nq5ykHXNdmPADRostmdcCgOhPF4+w4ZLsqlPS/SbTqpqruHdBvOX+3u5rSHQjpqBmNkJBa+ftbtrwdtH7dbOFEMe6R72CLaHITmaK7X8wCvj4ARCHs8obRhLTyOFxeHTXe0LzAWcjKSwJLKnstM0REtwDpJGyEu8kyb3GWnkPJqcUsVx
 1GwCZu6Z
 56GZGas3S3Q7v7/ebA5LFdCckSF17xFh3xKDi9vdKNEl6RLPchT2dakMDw9PLJjBaDJNY36T2WlP21/LqqPS6SSeBRz8tIakQvfDemfXx+dRfVAJmfGAPnHX5KiUgZyG5wbeKe0jsYJWmMzFv989DgxhrxMwF2cEn1XhJ3OGGnFfa5ds7+9iHdnLor0sGF/2fkl9O2POJLIeS/GClfna8hVm4g2KrD8Z8u/xuws5uSathUGKAH0UH4TRJFXUABlgdzhVkJwpyP2MKScjlzLOb7sWYSQojzkgSqs21VmUaEgMPVQKftvxNyVMhbd0G+9NRmrtVyYR9uPo9TApglF/f2ZPUZGQO/NNFRKw8fvfPYyQJs8vu5inA1leVz+zIGp9e2Uc10PmjObl+f51RMBHOoqh22Xduuy3RepRC/29YVvQ3qqgM1HKSj/K361Q4QWaEjXOQgGKgYulUic3cN+RR0UwdpM4pSvTYtUp0pje8n4UsD3coeVTB6q+1YA7hwyjv6AES3XS/8taN0hyaArobkV7fP9L5SU32jUPiirYwlocFZnADaTy0c39XZ738v0HS4jDkHpkQXKswS8eryDV3xnc9TqSH4is10f55k2JYn49WaDSieUvD2fFIVMwfO5UJKdrAv2zkZEf4xuxEQXitABOIe01oaBGPcpYxk9+mti9urQWBqUVtOD+nx6k+kQLL/hOl3wwUzV0+BWVklY+wo7THe0Tc5+LMjZmVHnKmfptpz/VseHcdeW3LpMhWjzAmncm6LWQHkcZQm0boshdOGLV094qdSCj0tTd14C9sG2ZCegbr1ZNws1f0D8BGueY/fAAqcZD7xAZkMT6jWNbuAcM+Ap0d5sKdzTtC27KzTohWp3dP661Jm3NLTIHCpeS7SttPu/AM864ZHAasAEOB7+fYoqXcF/43OTTnQCtevhMP1ucU4V0iSw3MFrdRR5Q9r6TuVxfLs2Yut2OSt6uf/bJY0U9w
 /iLkAejk
 jxkC8Nd9+aJEWEMRq3OcjLbdf7nB5R6BPfPyty8w7Wj+9aeWmAA5dOGB3GPzuMPhAGVAcTOzpZP1BeoCq4kg5MWk1KzUcoIeKqd9qcLdkRcnYHbJSfwEeDQT9Id2tqXSZMgJa7XCyXGDb8zL57iBbygTPr/DCsQ73nR3RvmCM9/BHF8aUR2n2l6QsM+ndrtVPYesaRFve5vezJSulSh9XYZxRfdXyL7oC3okz9/wS08ovzXoI16750VhTQcPafhyD7XpaEfTlIg0IZu8Ka2jKXuC9nn9YB9S/k84hQdJqEH34esUQB6JKLMLCOXQpB2utidgnTvFEnbJEJwt64v4xTMVoeYsZVSLWkj8qkm9wQuxHJvpYJ0byvHL+UDtDkYv/pLHLzICYCI4FOm2Bx+jjTizmIvLr8l2V2KAO/YFQW2NW+hsF/vQOkJiaIrVdW2zztTNtWr0oKxzmoqkl9uKXWawM6s+4MTw6dTgtv8MZtFPAJipQZVdqxmeJ2w0QWQQI8bPPb2ylgcx6oW/AqN/40C9+AtIZBmL6P5pu8G5DN3k+Rqn6DCQhnKl2TGWcPVYTB0P+gA/QWjnV9opJIcDZ086gkYZYw34wTJRpskgo6l+vtvcIBbG1SUZ78EAcjTyO+QVCvwFmFTshxAqc7xoXv/4XuCoel2T/bPa0XGhaQ+J8mRVwCksogFxg6ylGrbGgbh0nF+C9gLH/Da3/G3Gcnjmt1rbbnsohTdHhWM1NbwlsVACIjFKVmKDCEAEwrUFVzKlwyKeeByBuiqB33+Hgx+UV5M5v3Px1bkIIt49AI8/ulkK3QrinktfIZhFbG7NVW/3jS3DIZ2gTaeQUuSj2l9gKUA8bNtjZeo4sZhrqurSY+Amw1Q5hGu4gu7C4aZ95kPzARYquUzrcmu1mcighcthWPAtba6slWPekrVIPp6DeTZ12kWzqOlD3wChHaoomkd16LLEguRmiED4w5yDayzkcBtRs
 Y54VcyUv
 W2+mz70oGAba0x7Ap1gKqZmEd2T8fftdQVhkAi9g3eM5KHWdExNDrriqm1oTeg38Ih+CxrffP3d+wvoIdN3E2BhAkGsXohgitWuvXVJitPTZOJZ9IC8+1uqOvoMr85IY6pIzFZytgfVjEpVXV3s2Ra7j/h878vmRJmOuWOC5RASP10lOqOXPiGskmsv/LuBwtKg0UR1V2OsjQBmPdubxR4i7r9yGdSv02CvO+uAxq0MZcrrI0myCZ9SqGRJ4Ih4WCG5JI0D+jm5raJk/O6NfewNn45i+Vpd40HDI8W6xfRtDnxKLf4ZDR9OZ1CPlTb9Kl1+GUNXlcpNbyO0vC38oEneIe2wukfR+U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/2/26 15:59, Lorenzo Stoakes (ARM) wrote:
> On Fri, Oct 02, 2026 at 03:11:27PM +0200, David Hildenbrand (Arm) wrote:
>> I'd be very happy if we could find a clear way to describe "this is what we call
>> user memory: anon+pagecache", if that could come handy in such a context.
> 
> Rather than arguing about it, how about shifting things to 'what backs the
> mapping' and something like:
> 
> /* big long kdoc... */
> static inline bool vma_flags_is_mm_backed(const vma_flags_t *flags)
> {
> 	/* hugetlb is a fixed mapping, but the mm owns it entirely. */
> 	if (vma_flags_is_hugetlb(flags))
> 		return true;
> 
> 	/*
> 	 * Kernel-owned mappings are populated by their owner, and fixed mappings
> 	 * have a layout the mm cannot assume ordinary fault semantics over.
> 	 */
> 	if (vma_flags_is_kernel_owned(flags) ||
> 	    vma_flags_is_fixed_mapping(flags))
> 		return false;
> 
> 	/* The mm has promised it may discard droppable memory at any time. */
> 	return !vma_flags_test_single_mask(flags, VMA_DROPPABLE);
> }

In my other mail I was wondering whether we could use vma_is_mm_managed() to
express !vma_is_kernel_owned(). Maybe vma_is_mm_backed() could fit into that
picture.

Reading above I am still confused why something that expresses "backed" talks
about "fixed mappings and ownership", sorry :(

It's late here, and this is a hard nut to crack.

What we have here is:

1) Is this an ordinary MM-managed VMA. So far so good, I understand that. (with
   a twist what I just learned about things that map random allocated pages
   through -> fault, but so far so good)

2) Is this MM "fixed" that makes expand/merge tricky, except if it's hugetlb
   where we can still handle it.

I think VM_DONTEXPAND is also rather misnamed :( I assume it really means, using
sel_mmap_policy_ops() as an example: the MM manages the things that are getting
mapped in here (->fault), but the pages are not really pagecache/anon, but some
other shit. So we cannot expand the mapping.

Gah, so complicated.

3) Can the MM drop the pages at any time.


I still think that 3) does not quite fit into that picture. Using something like

"vma_is_mm_backed" to say "this is mm-managed, but all things in there come from
core-mm and not some other random shit people punch into ->fault" would work for me.

(not sure if there is still some other way how someone could get random pages
into a VMA ... or how to catch someone not setting the DONTEXPAND flag)

God, this is all such a confusing mess with so many ways of getting stuff messed
up by other parts of the system. Thanks for working on cleaning that up.

-- 
Cheers,

David

