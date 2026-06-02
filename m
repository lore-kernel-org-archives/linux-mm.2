Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 901E4CD5BD1
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 21:26:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C1286B0088; Tue,  2 Jun 2026 17:26:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 971AB6B008A; Tue,  2 Jun 2026 17:26:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 839936B008C; Tue,  2 Jun 2026 17:26:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7166E6B0088
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 17:26:45 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 02738120161
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 21:26:44 +0000 (UTC)
X-FDA: 84836257170.16.A860C16
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf31.hostedemail.com (Postfix) with ESMTP id 2537A2000C
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 21:26:42 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=b7xOkOeL;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=safinaskar@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780435603;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7X+F9JE3lvSde2aXKa2nn0C2FzfJE3VdMHUXsv8Plio=;
	b=uYDkQoad+kp5YOY01+3nCgiTkjIRPEhgTGeBqTprj3f5VdO0CsjJ0pFSdhLK7kgdQWDVQB
	XwXg2E1LIRSuZz6hIxClR31XxQ2tWfj5+igZiV9c/vv4pT1K6yJ9iiLCJQxGiAC9BL/UnD
	LmwG8lKoFU/ssoj5dN2SVjDsdSm1ufg=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=b7xOkOeL;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=safinaskar@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780435603;
	b=d/iGD6mUJHNERv9/4e4n3btVLDhYcOqtEu+sb0O6lfEbYxDcLFZozJtJMOPttZFQACKEzj
	5HJH3ICpbCXvVnR1LqPgWP3em8DvSjA7mRVfVn58vhQ/IFDL64ory7frwxVRoQTjmhy5X/
	/L6pLuNhChARn+KphxZcfww7Lbng1+8=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-490ae94a89eso20515035e9.1
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 14:26:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780435601; x=1781040401; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7X+F9JE3lvSde2aXKa2nn0C2FzfJE3VdMHUXsv8Plio=;
        b=b7xOkOeL07Cgph9KdLragR3Yn0HQPtEgQu0LQLR8uDdrDtQN56JZP95z2Do1dUbnZJ
         1j5xfDAl9lUL0/7paEOY6mqwyUvBRe7yqNHkvmS+dvXg1TwjRuEVBkO+KF/sKiGux+O/
         ydfe41T9UXFgxa4/mfKx4RSw03wPc/5bxN969Ym+HNlxAdx1Cb5V/mHBteAJk/EEo3F7
         8YOmKvOSGZCLExUJsPAL6LtPuxMIEHa2sMUowBiZ2Guux9uBTmy1t78qExmnksOgZYW2
         EmSM5GpoBHg35Zg808LKEYCFB4J329QEjsruJ1T9Vf/56vvkP+/Lm4tHedvVfSDUlahg
         oR3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780435601; x=1781040401;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7X+F9JE3lvSde2aXKa2nn0C2FzfJE3VdMHUXsv8Plio=;
        b=G7JDGa9ysO/VbCW+vF1vC/zcaHRgI7Zq+Ekjy74Nzf5hT5TI2YqFI1tn/4JLiZhS1q
         xeODyWwIT0zw/YVTGkuUbkF2qsngM+cBVUThn6ORPtjBXMH6hDSPUh1O0LNCFPlZnMql
         9Z4ea+I2GFaktEq8bNb6t/YLUW8mxaGaz51aoEImbqNY3QQSo1NfGUP3iGozlH4g2DwC
         gCJi0fGgoSFeYApiOrWg/pFk7KkEiTyBFsHDw+J9pTanpgtKySpSXnq1574F8AYOITBS
         EtsjhExp5M2GDCIe3lVk2cN1hSYLpdChWA76uF2ChwkWh8mWoQ0Nl5wKPvqy3xsyfvvY
         0kww==
X-Forwarded-Encrypted: i=1; AFNElJ8046e3boQZzT3dIear5dSKleLkdbTOnDIssl7HlGYIYn3LJSazoRepyM5ZwF1u6p8x3Fz/Fl3Gew==@kvack.org
X-Gm-Message-State: AOJu0YyyxpQfEQRarB3DRqB00JJVIyJueZo7sjfbSRYLdVitXc1iOPlM
	/YojTPgVtZums2ivOb0XkDHfYZX3eNe3+nCmvuX42zfC2ae4zbrXIXWn
X-Gm-Gg: Acq92OHdZnUHdeC1IIH6yC38LWkYFFf7YYiGJ4qVMYagZ71FnDKfbVRKHbrSrif1UDa
	eUIoX1/k/fw72BKY6yixI9Fl2Y2c2fdzQJrPY9XMrN+2hEz/HZ5V6+qF6InkyO6yrxkqNV8JApQ
	5cq0zBmvnUIPskKhyS1NC2zoohlti/pP5fGNB0KTAh7YJQsOFFcpuaEJhjNFqylV15EA6/vCxSZ
	R4fdIHfumUjB9q5u5HOU5H6+YTa56K6IbKKK35yi1ZSuhmbI3ur2AVTl3h7Wzn5zYW4P/gWcUMT
	rZpca16Z4kwQ/lH1EdvDa1iM4D+BKz78rwjvPOvFj3Oqg4W67gzbCRsqrsJ1sc/Mg92+CXrJ89i
	7I0d8dgFaFbdsNuHzCbOif761ZpvnsvT66nte1I8WlKJ8Jn0OEYiqpZko/agFpVgEn/ee9meJTa
	cqMABfGC3UHYhNB8EU4MzsgxR0eply+Q==
X-Received: by 2002:a05:600c:c174:b0:490:b2a6:8c2b with SMTP id 5b1f17b1804b1-490b5eb82b2mr8862715e9.10.1780435601484;
        Tue, 02 Jun 2026 14:26:41 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-490b614261bsm2203845e9.26.2026.06.02.14.26.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Jun 2026 14:26:41 -0700 (PDT)
From: Askar Safin <safinaskar@gmail.com>
To: devnull+ackerleytng.google.com@kernel.org
Cc: ackerleytng@google.com,
	aik@amd.com,
	akpm@linux-foundation.org,
	andrew.jones@linux.dev,
	aneesh.kumar@kernel.org,
	axelrasmussen@google.com,
	baohua@kernel.org,
	bhe@redhat.com,
	binbin.wu@linux.intel.com,
	bp@alien8.de,
	brauner@kernel.org,
	chao.p.peng@linux.intel.com,
	chrisl@kernel.org,
	corbet@lwn.net,
	dave.hansen@linux.intel.com,
	david@kernel.org,
	forkloop@google.com,
	hpa@zytor.com,
	ira.weiny@intel.com,
	jgg@ziepe.ca,
	jmattson@google.com,
	jthoughton@google.com,
	kas@kernel.org,
	kasong@tencent.com,
	kvm@vger.kernel.org,
	liam@infradead.org,
	linux-coco@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	mathieu.desnoyers@efficios.com,
	mhiramat@kernel.org,
	michael.roth@amd.com,
	mingo@redhat.com,
	nphamcs@gmail.com,
	oupton@kernel.org,
	pankaj.gupta@amd.com,
	pbonzini@redhat.com,
	pratyush@kernel.org,
	qi.zheng@linux.dev,
	qperret@google.com,
	rick.p.edgecombe@intel.com,
	rientjes@google.com,
	rostedt@goodmis.org,
	seanjc@google.com,
	shakeel.butt@linux.dev,
	shikemeng@huaweicloud.com,
	shivankg@amd.com,
	shuah@kernel.org,
	skhan@linuxfoundation.org,
	steven.price@arm.com,
	suzuki.poulose@arm.com,
	tabba@google.com,
	tglx@kernel.org,
	vannapurve@google.com,
	vbabka@kernel.org,
	weixugc@google.com,
	willy@infradead.org,
	wyihan@google.com,
	x86@kernel.org,
	yan.y.zhao@intel.com,
	youngjun.park@lge.com,
	yuanchu@google.com
Subject: Re: [PATCH v7 34/42] KVM: selftests: Test conversion with elevated page refcount
Date: Wed,  3 Jun 2026 00:26:30 +0300
Message-ID: <20260602212630.27012-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260522-gmem-inplace-conversion-v7-34-2f0fae496530@google.com>
References: <20260522-gmem-inplace-conversion-v7-34-2f0fae496530@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: ekr6wmx9jubnocq5h9a41w1nnqe5m7yk
X-Rspamd-Queue-Id: 2537A2000C
X-HE-Tag: 1780435602-915015
X-HE-Meta: U2FsdGVkX1+XOPPQ1BwgTvn/SklOlGsDwddvwecJamn9J9+dBbyQLMEMdOtqOiYFMNDgIGmXYKTcu19IVhFlOocpK0vSgFivAhlsw2LUvco3pf9xM41da7e4vgqR3gsfApIsxoXyffu8YTfwKfBma6YPuI08o62rPKH4WLZEqtd25oOpeNDWG913BszXQVfmR7L2s8NeE1XmVtgL1HE8HJfShN4GSNnFZwjT6q4vXNNaE/znPiLQbcNxdipF2bA856I9VomW4k/bkmpHZ+hJ+pOS26WOw/3WZX23oITU0g0Re51pSqrw8JsX8Vx7tcOrA0hHuwQRu5G3AisCb5/Mz6L76fFJlGLBXbT9GwjQ4bOV4Tny8rV4C1tCtIAnYQ6ZxiL0GYLjHju/RZgqePVYmwdrNNOCIsLyn2BziHWq/4ywqqYJl7HB+GS1B3Zq5s4Gqp3e4l7Mh4i5GgFZtEDaIxd9trdDpDM5ZNoHtlUruajk/I8VTtKXLppyXFaDt/R8JmzXsW9JgkSY9UIA6NMN1E5rxzJN2+Acadv24J42bddMQAW3jhT0razU4NsYjLl2WgEL0vLGxgIDsdwh6818/MsL1cwh9AxArgAl6/Qt4QxI2VI8c3eR5QACG+xbs2o7JyHzgrHfLte72ARDV1Sm+G7oBACRtHEc7uDDH2DwlHOakNAeTDoDXzUwnNKxDRvIHKVDGArTHVp9itL8pVBHgpYJCE1PxIsNJsm28gJJrsmqqcV8891jnYlIximGrb0wHLp4pzLUy5t2Spg9remuYYepc0r3FaVAJDd1Kh1jVNhscGn9ZRswW1k3q3s/FtF9LrGLGv5Tv6bzogz5+yDm14ewFd1z/aQzpniUJRmUemjzdqML8QrVe+3em+AIs0PEhAtBJA2s/Lc1bVTaf2vHXjmFxUZ8m4kwd8GH94ZbUBxxTBIo//t8OPRb2nlTpcmgpy+C8he5oiTkiI/wSNC
 b3CLUD9K
 a8VA4/KR7J5dQuWs47g59y6onwVC04NnYqCu4Vz7u8KpGp5c9a8i5pKI91H6Jk5ZLnk/U7kOJAefjoCSDkUOvPIh31bZGaZvvEwegPGjHCpK44MwIf7UXkxW0UwPH3MpUQ+70jfm7+VL+UOX5/P6noFF+4hMskbM95K1BnMjeGsvxWNBcgdC5v8e3E3mWXQdfq2pdOdS17129eFdKKWaFrzNubA21U9H5akCWiVEMz5p12rLzLMvZkD6E9cjJ3tNbUuoDGKGiHzeFcgcB6byZMJoCQCEqH10bd0kkr41RFccS9XQdtsIXCrIJdDTh8FI8UyIaKaUQW9h/NSrYOy7c/TtcTGtOkfHbRENXYKKCMiCYoNYrIbAAbhZxRMKzEucYbAtDqXYf/Qmk7BNhbv7nknIlZ5/8dMAYcoeTcPELDRWfSApqJ8RljxkFcdIR44EjK6we1raxf/4vEqHUJ/TiSs4Zz3FSxepTICXEc7XNnRd3geE/H1q1mQB6WrDEJW8MjRxcreJiomMUcOlmYG54eIeXI2PsujaTaDteQFcyoM/3ggQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>:
> This test uses vmsplice to increment the refcount of a specific page

I recently submitted a patch, which makes vmsplice equivalent to
preadv2/pwritev2, and it was accepted to next.

For now it is just an experiment, it is possible it will be reverted.

https://lore.kernel.org/all/20260601-aufweichen-dissens-ausrechnen-0d9b84728113@brauner/

-- 
Askar Safin

