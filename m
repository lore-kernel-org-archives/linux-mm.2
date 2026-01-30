Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7B63E6BF2A
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 16:41:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35BD26B0089; Fri, 30 Jan 2026 11:41:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 309876B008A; Fri, 30 Jan 2026 11:41:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E1B76B008C; Fri, 30 Jan 2026 11:41:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0B2A16B0089
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 11:41:56 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 855341404E4
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 16:41:55 +0000 (UTC)
X-FDA: 84389196990.11.4F1F4FD
Received: from mail-oa1-f69.google.com (mail-oa1-f69.google.com [209.85.160.69])
	by imf05.hostedemail.com (Postfix) with ESMTP id C4D5D100003
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 16:41:53 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf05.hostedemail.com: domain of 3UN98aQkbAFUFLM7x881ExCC50.3BB381HF1EzBAG1AG.zB9@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.160.69 as permitted sender) smtp.mailfrom=3UN98aQkbAFUFLM7x881ExCC50.3BB381HF1EzBAG1AG.zB9@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769791313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=DjcBVY8mJqbGJnCRObWENCx0c6xRt7QNzm9li1dg71c=;
	b=B4n6e0Pig3c3Y2uAjnfMUD97ZOttegVCne4qYsN1dQumiLnBqLmkCE2UIEcM0mKM0+Vl/I
	OxbE97Aa9RO4cEWJ1+kTesmN6+UhWagEoF1gDlPsp0gTSUghgASi8OZnKFN4s6wWHCL4C6
	JmFEGUhVKpK6rMKnv0wG3NG07UA07R8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769791313; a=rsa-sha256;
	cv=none;
	b=EcFG8PvzHFQ49en/ryy7HcAXmGZ8MMGGa3IGydJe8twXU62t3pHm7zsOVxoe7k3641l2mI
	CmaWf71rerGAsHzosvn3ppwt+s1H3V37GEG624wszqlHe/z43FdW/sSwMURoTWLJ8lPqJl
	2LaT31fObVvokzyfP/wEO3HckHPzJrs=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf05.hostedemail.com: domain of 3UN98aQkbAFUFLM7x881ExCC50.3BB381HF1EzBAG1AG.zB9@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.160.69 as permitted sender) smtp.mailfrom=3UN98aQkbAFUFLM7x881ExCC50.3BB381HF1EzBAG1AG.zB9@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-4040acebf22so6078208fac.1
        for <linux-mm@kvack.org>; Fri, 30 Jan 2026 08:41:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769791313; x=1770396113;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DjcBVY8mJqbGJnCRObWENCx0c6xRt7QNzm9li1dg71c=;
        b=nU8anW+AKaU0PscMPMnsENCx0XNYAI1j5QZC26AA+Z3/Oa6tDBhturqFptSLOz4KvH
         nHJN6p/fg69THIkgZ3+LVodJBYherdXBsA/uwRRrT3OrnpqZOgR7yBOX4lGEBO/tOmgs
         B72e+hLIsPf38mfpGTpS706UVsIgtfmCyVcS4ghUJHo/XQ1RIdPnzLo9+yKnSvU4uDAi
         torllCx/JUiW7OHexoL6eEcZ8SC4cXvwnHKRYnYA39eEu0DdwvGC9pyDZEmYVVvDJNi4
         78c/5YyU/si8t284LzsSAodzz/6VPzHVIon8T+V4ZgOb66BfTKQxNAKRD4I1ULXp3euB
         AdDg==
X-Forwarded-Encrypted: i=1; AJvYcCVmxPIQxFmijIY8HU1l+676B++3WjS7cFD6300KEPSt6kdNObMyJnjOCFb2xqw21/sc9enVOdDuxQ==@kvack.org
X-Gm-Message-State: AOJu0Yy4AMJq+AAAlp1JCd3AXjtPpP0oCQWAq3JfuFQFbHiHRWiReSV8
	hR9183Rh637AjfJ4AUZ6R2RyDDCZY4pldzQxnPj5NtL7B5MQxDE0tLi/yolOav9slNuAuuOjasp
	OW84TDW6Hf9JsMSjGwqRGamSgz5lBMZNIjHfXP3VRmuaiwt/7/mCzTezw+6Q=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4613:b0:663:cb2:d67d with SMTP id
 006d021491bc7-6630f04c2bamr1438160eaf.37.1769791312692; Fri, 30 Jan 2026
 08:41:52 -0800 (PST)
Date: Fri, 30 Jan 2026 08:41:52 -0800
In-Reply-To: <2A678D66-2516-4130-A34B-6A0B3549EEA7@nvidia.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <697cdf50.050a0220.371857.00e6.GAE@google.com>
Subject: Re: Re: [syzbot ci] Separate compound page from folio
From: syzbot ci <syzbot@syzkaller.appspotmail.com>
To: ziy@nvidia.com
Cc: akpm@linux-foundation.org, apopple@nvidia.com, axboe@kernel.dk, 
	balbirs@nvidia.com, baohua@kernel.org, baolin.wang@linux.alibaba.com, 
	david@kernel.org, dev.jain@arm.com, hannes@cmpxchg.org, 
	io-uring@vger.kernel.org, jackmanb@google.com, jgg@nvidia.com, 
	lance.yang@linux.dev, liam.howlett@oracle.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lorenzo.stoakes@oracle.com, mhocko@suse.com, 
	muchun.song@linux.dev, npache@redhat.com, osalvador@suse.de, rppt@kernel.org, 
	ryan.roberts@arm.com, surenb@google.com, syzbot@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com, vbabka@suse.cz, willy@infradead.org, 
	ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: C4D5D100003
X-Stat-Signature: 5u7f7sxcd8pd7kigxo7igngiu11m6dy5
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769791313-283886
X-HE-Meta: U2FsdGVkX19dbe9ijxKWmyCA1N5bLwdBzIuExa9cl1WQL1jGZ0c/KYr3P2I1U6YVHrSw8rGrDyM/zz/vQNK0OIzy7RV10lGhioBpXY7ziai4ibJa/jf1nEVgcQWTaw/WCFyF4NMyWIB91muZalbjAlKuoryMdkjZVx7k0MNlVUR6IM0l74ayCM+H0tYTvSRgpQbTo9RcMBfdMc4l4nbJUbpRq2ooIs5345W4HyWPrWknQZt7le2oeDyvF59oMVCkhby+tZwL93c4AJz3+/XPBSZ1RWcpfh8If9KvEjikK6xOHPnYL+pCTBLB66yDThoqtq1ssvK57kD70lACkBOSS/XeBJV5KgrHQZ60czFHsaYQqFJpzSYWRB4itlnoKsNFgnFHHb0Hlb3oU2Fa5epljaEV77HgDA6ikoNkMqKgcnvG9/Ro14BUYJMyWAdr2RWysaFnXdmOaTKaPBMpF3Rq6AJQYpCAOLv79O/B+wuLP8Lg9y3mutY7H16QQWzgYn+xo9PAqn8o7CkVzSlS746Qfc61vKwQBK8sRVoh4m+k83oisK8m5gkpF5YsyRzco//rfC3EtBfO60ntI6Uh6RVAE9SNHvYgwotoTtJtn2+HhbxtWxmKollI3QxolUO5lL3nsIZ361AXbGEmeQD55v6wgutG/+AdhVjjDDTnSk669MhO2Ega6TdBT1XgfQytYwzm0xMNkikKrlbyRqf3n5xofBNOEtNXBSPAgX8gwFipdBtRZ5YNVGqQWCUdifxdvKx5hXWEJ73W5WlPTD97xGKdrdskhdJKQmNz1yepF40wat4eXvVyKyfeQP1DBvCvpm3j315tF3RcpdMEzq+yxRtncghJgHnrVhFeVWfMCp7Et+vvvRaXw6ggwwCnNRCv6FMCQpaToKB7gIfWMkhAc3dooViAqmyFtodNc3FfLdXJoTdE7MLlsWb8AC7Xn/YNaM/2gSL3luRP5gh9VLJOtGl
 G+O/Djf/
 RsCQ8qnIQi6FfH8EKzWCDMaIvHYkoCMcTtm7cVEOa2EZKHwo0U//4DyhUA32YSrl1wwXGvbDTWo0BqQxDtiY9YuzwWCBOCo5gHilepeVff/t7KUi747S7bXwLcgn2+ZXDc+pLor7HTUPikzh1Rmi+c0luk7AG+FX+WZpObDwYHnR+OtoVHo1L0t/QZciBKLmHuUr88QWbrv9ZHXwFeELfH4sdG/9YsEBbIHNIX7a7vHct/m3lJzihS6V7OxhU+kq+wdsgKeLXDcUM4V6MG8/PHQl2ub938GomBS8dIL0wulwU1b8O1byLf99ltNa3PEhcADy+pEor6pst9UYzHvJQkj1jdhe/IGCyMcBwshDglZPihWf+oEPRZKH1NAodwWs9bkrggV1Qkq/VyJj1fGzLBtbfXMr471NUP4dgmq1oqlRjPTgebOg2F105VaLIsM1j9m+GrWdQwLJB7FzFyerC+/KKYWo9IM0yd1+S3Q7vXObWZT71sgjLZKAAhcmYASW4pY/ndBbr9idN7nv67enFXXmFUyuVOLrvYWG26dvJaegpBj++VC9Mtz8E/pdB+j9AEbssWI6ziySZupcJ/LKMZrvWTXIjnvWB1R+bll9klxZLKTTU+bUqFnniLevhA/zQqwr6izsZlyrKbA8mHOGCNUIgFG+zMS3GKidUzT8dD3CJWVVLDc9IEaWGDdJfw0UONlDZSPyvmq/eUyXQmsjTJBUQDSa+s3gzC8uxcRFl/VsdIPfFMqyk2NFZBA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Unknown command


