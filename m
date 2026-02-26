Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB968FC5914
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 09:21:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E13956B0088; Thu, 26 Feb 2026 04:21:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC1456B0089; Thu, 26 Feb 2026 04:21:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA2F76B008A; Thu, 26 Feb 2026 04:21:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B63796B0088
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 04:21:53 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 718A0C3217
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 09:21:53 +0000 (UTC)
X-FDA: 84486065706.17.DB2B6A6
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7759A40002
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 09:21:51 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=rwdVqP9p;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf11.hostedemail.com: domain of chris@chrisdown.name designates 209.85.221.48 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772097711; a=rsa-sha256;
	cv=none;
	b=EKoiaggnGwKvYcihYpMdFiZz69JnnV6QSYeebHF0yGSbAYtrzy/7X/m5e6X8k/kr/K6Fpk
	WbXL1co0m6SXxyhqrci/hun0u3Iq2l62wdJ8zmpgg/blaniMUlnCCN2H8SGezYxx/QrDhp
	ZNdi3QqqNP9mWuwK31MTFTYheuFreNs=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=rwdVqP9p;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf11.hostedemail.com: domain of chris@chrisdown.name designates 209.85.221.48 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772097711;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xFmSiTtF7VcBXcNyOqiPcdSVZdfRx2Ym9rHJPtx/YVs=;
	b=u/IGeLcEX3KegnjX/ZEriHGjfAgSyyoRMQUy+4QCPNy3TvMHiv3JzR6YnxYEKrePnQpm5B
	MWQnCWeMAtDEuRbnXHoHsJONelMZoVtihNUMrkPDn57nyyvnfeYqjDzFEYwGfQ/fVI9hat
	+pA7acNvzSFZKHj8n7nbgFZUey/qJug=
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-436e87589e8so571969f8f.3
        for <linux-mm@kvack.org>; Thu, 26 Feb 2026 01:21:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1772097710; x=1772702510; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xFmSiTtF7VcBXcNyOqiPcdSVZdfRx2Ym9rHJPtx/YVs=;
        b=rwdVqP9pToR9rtLRhh1uMpLTr/zwhuBCL4CNVF+ECM5tczUHOAPDPLJqn2SHePH6Mq
         KfOEZ9+OeOJKZRUzL3O/V7voE6FeNH4jdFj/6UbZcDrOG2LlW4ODh1lVhtR6DCKwI19J
         oSISad96Los1rML2rsH4nQVYVs1JUt2Bc2b8Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772097710; x=1772702510;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xFmSiTtF7VcBXcNyOqiPcdSVZdfRx2Ym9rHJPtx/YVs=;
        b=k/1qm7ppQVTEXc7Jtm4AG591VNfd9rFJWi2u8UgiwGjgKURyvQfV/ITJOMGOj5qWON
         x3XvdLeI2JilcUl3BBYMN6GOIHUfLpNcVEQdRYl4vWSz+nm8hYazYoyYoqtggtO4X7B0
         +dbLA/Z0Ye9xOo2Sjo0/GC7JGmPKeICRtf/Tklqu/iBJs2Td8PxvxhWlwpTQCKp9bp+/
         JauYNiClUGhXA6+2Q9eeyygLd5/d52hcSAoaVmDdt437tYm2I8imwi405EE1t6iEzogg
         vsAAwBfnvUn1DSiYsEt5aORLcDNac9Dlx69Gr3gUK5XkxEb1t7jC/SZDpvQKqB7qdoz8
         IDRQ==
X-Forwarded-Encrypted: i=1; AJvYcCVm7HEADBzPNSKpEYC8X/RZLi45jgs8wqBLLUDjesB4sNWt/csYofoApwNwDUYLCRBAgLKH1zF85A==@kvack.org
X-Gm-Message-State: AOJu0YzV44qkhHkQLWjkAhwPTETpe65kXioOqoxMz28Y7WeyK1CI6ehj
	pvpodFchGvR1ZaOITslCBV/3ac+kQOCFF913TtjHcz8lKz/54/qI3SB2OMNqfwXM2xQ=
X-Gm-Gg: ATEYQzy2zBqVvyPcAy0quJW0PFlwXPjWoLVRxic7Cb7NNqNjYci2gEXRuWltnWVuMeV
	Ilfa7y6l3374D0g4vapULt4BNGEd2OD31tHlKnGdRiiZe77CItNsYLH+Ai//VNGBHANv++9eJ6X
	vC29hNa7QcSOHZY3wi+U8OqkcqAWKI9Tk7Cd1vkYSM6NKIGeoKvqb2hH7QrNKSWKpb0rYRpT+KB
	glRKFU6dbKha7vxGmzL9BN3G4bbAx0CXhrRNVwROBuTSh+h5/1r3JqMsA6Yt3w6JrkPtXDZve4+
	DmlLu/9qJ5CKDz/a9nw4FHYZP7rcNhXfnqr7BVZDi0fj6b0WTAEfrfcyZoYxBWzsLDLIeL3AWzz
	NKCGcGwwK55mIhd8tNsczeBI/iHPRjKM6DWgpfhSSQhxZOXpWwikYli3hZA0tAvoLJAUNgz30Qc
	icrPHBKMw2AUYhtJmVkvo=
X-Received: by 2002:a05:6000:2283:b0:431:32f:314d with SMTP id ffacd0b85a97d-4396f165655mr34727737f8f.25.1772097709632;
        Thu, 26 Feb 2026 01:21:49 -0800 (PST)
Received: from localhost ([85.255.236.51])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43970d4cc81sm39379192f8f.26.2026.02.26.01.21.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Feb 2026 01:21:49 -0800 (PST)
Date: Thu, 26 Feb 2026 17:21:45 +0800
From: Chris Down <chris@chrisdown.name>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>, kernel-team@fb.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/huge_memory: Fix use of NULL folio in
 move_pages_huge_pmd()
Message-ID: <aaAQqS4uHm7Th5lq@chrisdown.name>
References: <aZU1vSmn5aF8xvJj@chrisdown.name>
 <0b653dcd-842b-4360-bc1c-8fe779efbc23@kernel.org>
 <7da49940-e1a4-4018-9db1-208411598e77@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <7da49940-e1a4-4018-9db1-208411598e77@kernel.org>
User-Agent: Mutt/2.2.15 (2b349c5e) (2025-10-02)
X-Stat-Signature: y6yjherggqiei7g9pfkzkt3t6cac6gn6
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7759A40002
X-HE-Tag: 1772097711-99340
X-HE-Meta: U2FsdGVkX18wsoY4q5gqiDpgn7I5t4IxtjR6xsp6LNwkEF7afZ4jNeqAsMTb9LUsVCaXJ+mEoUdaH8QoIy4KzWRyh4+YPYR9T0zkQ2AWQnQXE/yKnD1A3dBDxwMqfEolRmAHFBoUEsOsLsrssYGGEjH6DdXyRerZEycq3nkeBc8X9kAIO1h/qKMXxWWyTrM8DnFngpqolpljDXwh2+uO8No086nHKtzuRlVWJu4yAGgBZjE0UWNUqb5VNQMODDqFXbWbvtGv1rMWgnW6Y50GenDXc/+FTMRsN7lTb7ZKxpiYM2rBzbhwrljyprIMX6tbRR3d4QrMZcsyKDDsMuF/M4Y3Ny0wvSCJt3BHRG+1dcguloJ6ID3gMyeZqLxeITSPv/yBG5ygVUbbv7HSVCCW020y8w511tSudoGDb442GWAvF8z6VeRQjJxU4Mu87AxXwLe9acuORSNTImAQ7NRzwlNHKQ2Gl6kwuIqdYiw0Q7sGWlnNMVGxUaw8BcF2gfkB98J/WPccqtQsY7VRH3v7it3KjK+wX/xRKxtzzYt5kW3Ilq9q5+2/P7iU6dyzORnB5d7DYbT3zgmWqoRE//NHpxMT1ywAon780BEdG2yoFsop8mf2Bh5KyYLY9nq8kDAExJqQN0vVAhl0yXE8qREHeWSzVR7VQ6YnsewnPVys7kHwGNIuOk78N7dCxvJQgyD0n+KQmoXrLDs3qivjFZxlfOwWMYnbhbyFcU+3uKrVFJMHoQ6oIIDZPWU0lMVCgLelC7Lvm94XdnRmwycAKisEYl3IJLIIWcF2dc0tf9um1Q7sYgiAAtu9RG/eHFV1uiRbSGPVJTOB7RhsyvmRJHI5Prm4vGycrN07IxrZ6UEBe+oMlLe+FQgnM+4AHcNkFajvl/qFb7KQQfJ1jm9lAWNH2ot1+WDfcuD+P8DJapaLjg/QbT3wZeOtah7HdPC39MH+wo1m/7naa8lKJvXGJ7d
 mKhwohN5
 gabpVT8tLIvCnbA6Je4e1YrG9pZjK1PHVODdg9qbf5uBFr+dWjgpbEYXQHeESer2sH0s+2jQAJnIF8h1bmTvxOR4A9I67dKUVCWoPWhJLK0GBCM3qa5NnWmMKC0P2+8GPnT3L3h/B5nk2UjmPDhs+KCC+k5oxV1B1RvRSQ8M3fo+0hYKbrIvocqvGD1vmaUz7BzVDcUN4Y4FTPrKwyel/21FMEglrQajN9A7iYY3nsIw9i7eMi1BeTFJevgM+L22oDy+ZYw3KcTKB2q6aMiBS6IAOcT8HdO6kUtIGJVskUttt53xmWjo8YqLU8U3Jakv3AAMdJALlwiRLveZI/NyQrpMtTWxyt630+ehP7OzE7sEVZ+tAakaRUIG8VOAZ2MhzIS14mjbHtrWAZ3AYyUBLoPXwxf7b5VJP7aLUSWGuJ2sHYuI2u0gil/i9lZlC6Fh0t1WCU1Erb5p488ne6ggra2ArISVmOGadbZ6jmRfXPyJf9ivSxEkKWgqqkqwzIwXbV6o2qQng8nYblCM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

David Hildenbrand (Arm) writes:
>Chris, do you have time to follow up, or should I look into it? The
>issue looks quite bad, so we should tackle it ASAP.

Thanks for the poke, I will send v2 today.

