Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48067606A336
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 19:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=Ho9/rAwK
Received: by kanga.kvack.org (Postfix)
	id AE2416B05C4; Sat, 14 Nov 2026 14:57:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A93EC6B05C5; Sat, 14 Nov 2026 14:57:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A8DD6B05C6; Sat, 14 Nov 2026 14:57:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 70DD46B05C4
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 14:57:18 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F0CD1A79F7
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 19:57:17 +0000 (UTC)
X-FDA: 85434783714.14.2C8DCA5
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1FCC640003
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 19:57:15 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b="Ho9/rAwK";
	spf=pass (imf17.hostedemail.com: domain of chris@chrisdown.name designates 209.85.216.54 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794686236;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f+UcsNuMg4Yueaqy8xslzDAXYJR5HIy/+gngqmLcoZw=;
	b=qyRhhyXyntWX2+suSBf4krlOBfCmmCFOERWR7bccitpUhRkhcU0hNbPqGv7gXxyYD5A2ws
	0F+7bUnR0DNOAhCFc+FKrrnsKYt8/vsroAdNaYVgISg6vHS/BEC7eEkHF57AHCbdDtG6lS
	c+emtARSnGwO2RzeIiS0UDqb6iPkAFQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b="Ho9/rAwK";
	spf=pass (imf17.hostedemail.com: domain of chris@chrisdown.name designates 209.85.216.54 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794686236;
	b=E0nqjYD8tGysOt7jIW/5382ZREc6cd4la19TkrvwnRZV+ux33pQVAROSoG9ugzbZVH1GgV
	RG+hisYMdeZZxObIxVRWCfzXXLYat7K8esGJ4N80Y9oEoG9TMB7KbAacP2dO9RldLkUGI8
	v25tbCHGJBl0evV7iN3bE9Ny61761+k=
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-3b09a65c76dso2356598a91.1
        for <linux-mm@kvack.org>; Sat, 14 Nov 2026 11:57:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794686235; x=1795291035; darn=kvack.org;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=f+UcsNuMg4Yueaqy8xslzDAXYJR5HIy/+gngqmLcoZw=;
        b=Ho9/rAwKxYflrGkNDSw/dNo01S4f1h4m9UXhJO3kq25VmPUsTMURq3AHk9CjBx0NL3
         tKhKvsSTclfU+bS6vQ4C2IdqZALM0UgyAeQL4Ufi8h6qirsakElSQTBkFbAqKqVK8+7T
         tZ89cUevnCWJr7v7t2RaqjW/uvxbMT7tywNOc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794686235; x=1795291035;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=f+UcsNuMg4Yueaqy8xslzDAXYJR5HIy/+gngqmLcoZw=;
        b=L8GMMORJgnsnmbtKF9i3ELbSW1qvhOJO4DvI74/abp0khXVUCYOUL+zHvn0Ram4ske
         GSmm59vDL74zDHxnNQTDCzf7nXcL7hA3XsrO/ODx/IziujEBnUypsuY1sgRBrLAmP5Pm
         eOR6GyABr+t6X1PdTGIeBqI2S9E7hAVRQhhctGKsz/V9YgZtxfdVtJ8nD2AYCf3uDsIL
         hJXsIa1DsYemI76D9wXPuhk9pJxTHADVoJ7GZYdNRczaezi22b4Palr9DlEyWVWTGMt3
         gLWR9g3daxaDKxEQqz0DYQhpfDLTobPmYEc7C0xKVjUrxm3bgW08aGJ81H9TJl1JLWQK
         R3rw==
X-Forwarded-Encrypted: i=1; AL+hErE4lIRPvsA9V9Mu8N0LoNKGtbnFXBn1PCdss2N3Yg1DCAjNb3RHHkW0Tn0zhiRmi0l0Sk1WBbVaWQ==@kvack.org
X-Gm-Message-State: APuU4Z9VKKomFXRku6/aP5rVM+pPGvFsWpWTLcIt3f0MNuAVW8DeH1l/
	2eTIwNi/6+aoT3ZHNkTegaadFLJ689qlkwBeS0dAsYtu6mDVA7SN0r8pFLejGkYC5M8=
X-Gm-Gg: AYBFou2ONzTa7wvuR7kEcAYbq8v44fiNumufJwSTatVX/Ufj/08S+PMBmtuF+beqQFx
	k/YgNJlf3GUJBAi4vKfYsSaQmHSJnOO6TJxo7nzYkum2Xyij01uoCAZu2bC+QmexuTEsCSqllh1
	Ep+qu3XTNFjNjXF3r/bVIS1QMDF6Y220/KAZ5KPc6bnGVeAml/1BUBBaJElmbN3uxkomp6qqHWp
	l8RBwJns7dLZQrHxJCPAR9XoRbAnoqj8ns+BjdltAP/STf/ZUCkTVG7pFnSB5sxgS65qoahxJMV
	sCv3a6rtscEoMmROXIAW/ev9skZ3R+o7WStzGjrdh2YcRXqEZ487jdWq0hzqMqsSmhiVFAinnD1
	wk8rWWIY+be6oTalnLvpsPpcgrR6/XYqLGz5Kzo+Xwplf5sjFcjN5amYeHQPXjoaudU1j7ZtrW6
	LyHWgA0Nt91VO2C+QuQXoT50HE8KAYV0naOWXXunzE3g/JQ8V5N9IlOR8FjTPMrX8MJiN+fdO2h
	KhhlcvpxAQGBJTpvROCeCORTzltvAysgPEVH+lMUsBc+CBTnk0gvVQHGUyiH8yDoRrSE5oayquH
	q4GBhRWYoqoqmmwBVgSD1Fxz1koD6KppKKrtlIpdH1KuFUOXP/81MGKGMjGZXDGSM19p4tOnj8O
	Bh88LfQqZdtcJYUcgovYOrKUfSAA+z7xGx9z/zaZySOBAG3xL5ZH+EnnmidAzKGyRw4FmRqmqBE
	0KV8fQdwa2OOzjlhdK9JuT8ybTnsv3TICSFPLJ2duo6MUrJ5zFbXDbkA==
X-Received: by 2002:a17:90b:586c:b0:3b0:ab34:afc8 with SMTP id 98e67ed59e1d1-3b1b0b67f13mr5551950a91.20.1794686234917;
        Sat, 14 Nov 2026 11:57:14 -0800 (PST)
Received: from [172.22.0.2] ([4.16.0.251])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b197d35ac2sm15010379a91.17.2026.11.14.11.57.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 11:57:14 -0800 (PST)
Date: Sat, 14 Nov 2026 11:57:12 -0800
From: Chris Down <chris@chrisdown.name>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	Nhat Pham <nphamcs@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>, Usama Arif <usama.arif@linux.dev>,
	Kairui Song <kasong@tencent.com>, Balbir Singh <balbirs@nvidia.com>,
	=?utf-8?b?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
	Kiryl Shutsemau <kas@kernel.org>, Yu-cheng Yu <yu-cheng.yu@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>, Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
	Peng Fan <peng.fan@nxp.com>, Josef Bacik <jbacik@fb.com>,
	Chris Mason <mason@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	"Borislav Petkov (AMD)" <bp@alien8.de>, Mark Brown <broonie@kernel.org>,
	"Dennis Zhou (Facebook)" <dennisszhou@gmail.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 12/13] percpu: search the whole reserved chunk
In-Reply-To: <20261113-mason-migrate-et-al-fixes-v2-12-50a2ed382b61@kernel.org>
References: <20261113-mason-migrate-et-al-fixes-v2-0-50a2ed382b61@kernel.org>
	<20261113-mason-migrate-et-al-fixes-v2-12-50a2ed382b61@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Message-ID: <20261114115712.a6d31c964942e1db@chrisdown.name>
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)
X-Stat-Signature: w48xgdjk9yqyg983k84x97tr7xyihjex
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 1FCC640003
X-HE-Tag: 1794686235-324654
X-HE-Meta: U2FsdGVkX1+O80S8QH8ZWQ3a719BqzKCERAQiSqJobT1XxwhkuqwoepbR0jkWuIVs7JKhjLM/9UFSwmeEfy3cyNP4ySk7cvKnkWcptk4FAlfxC4XEKl7i3kryicTMa12+6bSV+N2lX0GH1WlCWoIzIUjgny7qlFwdgZhpGFN6UJwVFHFrOXgeUvuga8HracRU3IDGbFj5YkvRBX9vaDwcxLY++cCNM3h7sR/vzzQ66HfDhaTn2qx920Aj+CKpGA5IgQf4Eb8KkI4Q/MYkC08hnDR9Ph2FpeYN37I6DZbbvQNSuBsGm3t6RbYsl059GYSMnCGAr3G67Sz5HK+L9CHnzpaLlWMLy4HXmEHBrnQKqYUgO5hLansagN/XYt1MhbQ1GebuEp+wJT5T6IvMSoCfFbz25zIps3axaLc0OPLds4SyrfuLBfIBciDG4zA9BzybHho0RAw4gNwqtU80kqnrnDh1qS6tVd2QvFSwk3myc2rFKLVJ0saWlOwEc6Vmu+5QJ4/E+pX5tyLJkaT0HZptIAegqVtZAXHr14A5KreYTb1iodWH2dY3dwsCin5/Gm2poJZoEuAUQrrLksj447Wrq3SjPVTYBW+q9UZdbv8mMejYElCptajyZN6ckfJ+cpuqYGsJSNDjwFollGzZNA4HjQ+VR4caXsfn3a6/omOnUIIZWzybOTvW+qyRN4rZC3oaU6qT3727hMkxGct/SNsHIdqr7dQZsxcvIeN0xrduIaXXdGYn0+ARJe6UIbBDVzDT95oDDKE0jmsgSlPSUo3wRs1zMNpOJfno+izhiUPG69/8i0xUbHsH2Lm/WfkwD7AdYaZ2gazxqe/5ypL9W9YJrGdNXDFnjW+zU09uyuL2oY2vJyDVsD2awHUUfIjDR11dnAbUr/8HXeFDRxqpQ/+J2gVnU7Ta+4tOdv0guhgdWLsOVTphj+WfdWic35/fiu/7fxDXVzIrGPlyMC/raZ
 HKI1XOdz
 Tzprt7guCYo3F4ylt5p48nWmin1fSI1QCjnTrFZOPd6yHgHzDuTleIvns1bzhO4uOmuFWERjcPu0O27qdfy+IiiBh349iuQqyA1swEi8A12t3jCuM4erWpHJkRyLr9VyOAjlYvmiWpQT18203hLLbX6tgwuECwS1b1t1wYd9ePkoiJFkEcaaRh15tXQVIDfFOwx6V4DA6cgPvH1JfMxhGXRJhV8zeKZcx0JJHg0OK6OLTI58pz+5GosGwEn37YTtZjZjiwUvqdII89Bri0kL6X9MCjAIC2g3PmCeEU9PRPzYjCM6t5pz3FQdtgkJJNkKLNINN6tc1CCOw8echnZclOiHiX2Y/8KiW+EC06oEQQkw//LdZbsUyuRYiiuKmLyXx+PKmbPKSU8uo4V37vmgwcoVdGohEkKXjPYF4rK0lC9HUhWp+JSQr1PKs6PHTjAliqz1RNVj3GweUEYZNi/e14D8+1pLzhEF0ZOM86OjDhSs6A/uP7Aixy/BpusgK9CXC4o2xpdAgMHTO8ooSmO6S4CBDNuDqqb2JN6HP/p2C7Q/62sGNtXNptkS8JuTAz7Q55vcE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Reviewed-by: Chris Down <chris@chrisdown.name>

