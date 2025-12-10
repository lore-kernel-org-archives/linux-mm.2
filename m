Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C416D3E77A
	for <linux-mm@archiver.kernel.org>; Wed, 10 Dec 2025 20:24:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83E576B0006; Wed, 10 Dec 2025 15:24:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EF716B0007; Wed, 10 Dec 2025 15:24:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DDCD6B0008; Wed, 10 Dec 2025 15:24:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 614C16B0006
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 15:24:16 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 02437BAA28
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 20:24:15 +0000 (UTC)
X-FDA: 84204688512.14.31A3E63
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id 98277100008
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 20:24:13 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=N9OJp2Ej;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf14.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765398253; a=rsa-sha256;
	cv=none;
	b=lrxFS3gftPwuUKU2Eeg49vlVmNBw1qlLR4oO5vpCDF2ADaxTQsLAmT0mzKw0SrTKspW4wi
	04UukzaSLeLw1/efwwncLL9/RneYVBciMGNSj85mgwIi3RyswBjbJd3PcvmahktkC6y3bA
	bHyN/p9CNn9IX51YtUEWmS6smGzNE3s=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=N9OJp2Ej;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf14.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765398253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KxnQ/iEQ1sK58mDVjsOZpAu/QgTIX6mC6WKI+mp0l1A=;
	b=GoEZzz31MF59jyRzP3Obk1kr1lBaPGMNdaWGFTDIC0s5B1qHibJ7Wp99jNIJlTm5Qeu7lQ
	pWzwWHxslamWKr/rTCbGhFQ2HNXAdL7wVZRH9PXoBpzTBUBPT8VUhRx1JIsSgGZOHnPjcu
	FacrGPuQz9tAjfHMjymKGuPFvG7PJ6Q=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765398253;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KxnQ/iEQ1sK58mDVjsOZpAu/QgTIX6mC6WKI+mp0l1A=;
	b=N9OJp2EjGOQNopngZILTcDRiGs7Dd5AXHq7dC8TtbGW6/Nze6RTuAgpYSbKYy3mpiCkEtJ
	6AFGhhFhXCIHtM/Q4AWoh4P5UU5SmBG0e5ZI3ZWGsPaZ+jjIb/MXFCi5Tzr3hRUXxNnDA4
	hMU1dAx0w0oEBGJ5AU8BVstQv6RyZtY=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-611-aov-je5qPIWLmCFUos8STQ-1; Wed, 10 Dec 2025 15:24:12 -0500
X-MC-Unique: aov-je5qPIWLmCFUos8STQ-1
X-Mimecast-MFC-AGG-ID: aov-je5qPIWLmCFUos8STQ_1765398251
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-880444afa2cso4246016d6.1
        for <linux-mm@kvack.org>; Wed, 10 Dec 2025 12:24:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765398251; x=1766003051;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KxnQ/iEQ1sK58mDVjsOZpAu/QgTIX6mC6WKI+mp0l1A=;
        b=KRAY6NCLIDKt0bo8eC9//QbAnTqhfhiAFbAIfunLy+w5Z5mFlk8EHgij0qMKtyJZHm
         5W7e+NUJp0zB8J4dZKksafRNCzKe6w6vKYWoowHwxmXN00hNElKdc+uU/KFZy07i0DVN
         fHvuC3+B6ActXcOyId9yn6O4GrnCgXRqUQWM+YNOV8FRzUFD42PKGiBQYGIMa+ljckZu
         +KzTtRadPyoOV1rL/zS3rg6DuN7SHJOb1fDDX0kZE4NyZLQC6nxPtRWMxpz4yGGicxZu
         9MDzyGwWB7lvm7UQ+GWtiPk9rKWBHtXEp+E1aJKqfuBH2Ms5HGWLd1qvvLSOrwWkYZOx
         Rp8w==
X-Forwarded-Encrypted: i=1; AJvYcCXnKCGCB2VBS7XVJK/IUNHIVPc3z+BlxjN/Mtjd+Z6tTKjyYpiK+jZWS+90EAvl14NCK3II9ILsFQ==@kvack.org
X-Gm-Message-State: AOJu0Yx1Y1MGInbfVG+qQc7U65rL1n4DHekGvuN6y+tqFswzh/BuxzP6
	XPhrGiikBaO/TBV9QgTipN93d2/Q6aiyMJdF+4G8ja5gCJcot5u1TeuR3bhDDpWCklHcyV1/DYt
	MOCxD+yyHdS5kVCepQt3rcJalJ1twmu6blF1oy1Fkoz+w2ni9janM
X-Gm-Gg: AY/fxX6WYiuTpVYRD9ZWC30qWCNHEtT3qgCv8xIZUm15l1V7l2LiY4skGwuSAnUpFBt
	NpQNtx3FIyX+yOyOk5vppNMQM2Eee94OHbCvIArmJREYZseHu3tLNf92kFx0d+hkfEp2/mkdSQx
	jlkZJ9Yzh0/266UpDSUShSwh4c8KL1h2/R6QvXVBF3u3LiqOMnfbCspahDFPxtjKWEVRKDgiQfJ
	HVL38Jq8IadLSyW8Ye1VCbD7VEiIBQfwJ6uG8dqjCJxuSQ55u0kY7z6delaPuIWUq85MbXBvwn9
	eYgx2y9yr61/ByGBxc1r+nU9ig0HGstz7z8ZmHlsXdf/+7vi9I+qQugD61skRHECAP4RzVzmO7H
	C1+M=
X-Received: by 2002:a05:6214:768:b0:880:501f:5e8 with SMTP id 6a1803df08f44-88863a2ab3amr50897016d6.13.1765398251249;
        Wed, 10 Dec 2025 12:24:11 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEp/TCjQkjo9IXEU5scwVWKecCDQSTmMb8hfAZZ6nq5cmvChNS/S1r8YuGRQNN9gNusvbUp7Q==
X-Received: by 2002:a05:6214:768:b0:880:501f:5e8 with SMTP id 6a1803df08f44-88863a2ab3amr50896356d6.13.1765398250715;
        Wed, 10 Dec 2025 12:24:10 -0800 (PST)
Received: from x1.local ([142.188.210.156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8886ef0d241sm5052596d6.42.2025.12.10.12.24.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Dec 2025 12:24:10 -0800 (PST)
Date: Wed, 10 Dec 2025 15:24:08 -0500
From: Peter Xu <peterx@redhat.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Jason Gunthorpe <jgg@nvidia.com>, Nico Pache <npache@redhat.com>,
	Zi Yan <ziy@nvidia.com>, Alex Mastro <amastro@fb.com>,
	David Hildenbrand <david@redhat.com>,
	Alex Williamson <alex@shazbot.org>, Zhi Wang <zhiw@nvidia.com>,
	David Laight <david.laight.linux@gmail.com>,
	Yi Liu <yi.l.liu@intel.com>, Ankit Agrawal <ankita@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-fsdevel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH v2 2/4] mm: Add file_operations.get_mapping_order()
Message-ID: <aTnW6OorSRmn1SqI@x1.local>
References: <20251204151003.171039-1-peterx@redhat.com>
 <20251204151003.171039-3-peterx@redhat.com>
 <aTGmkHsRSsnneW0G@x1.local>
 <aTaYtlTdhxKx2R24@casper.infradead.org>
MIME-Version: 1.0
In-Reply-To: <aTaYtlTdhxKx2R24@casper.infradead.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: DVKxhWWRkzGrD81-O8IPmUWKbP9hW9enyfPRQKp1UTY_1765398251
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Stat-Signature: ewu393qfsibwtzwk94ooq6ehk67m5ne9
X-Rspam-User: 
X-Rspamd-Queue-Id: 98277100008
X-Rspamd-Server: rspam01
X-HE-Tag: 1765398253-290468
X-HE-Meta: U2FsdGVkX19Hol4AV9gqT/VWC0hDycTpTJphq/WjI9BVEcg9XYxkiXjDZiBb2R2wNv5nUR99TWLS6hwS0lOtLfMxdLLIllmgHiGdGSJyJPeAYzmpbma5VxlUCtkfImXsvdvuXeZP97egiLt7k1l5DCSjtOiFVhNl7P7oGbxH2PmBkSBWGxjZOC9Qy0S5aDuWQdNL6XbQiKnnSoSRBPz20YyeR4fzWndtUSHtAov/j3NF1cdMPO5vnzDZgdLIp+zoOEQItKMKy1sMjJmd9q12+vrryhlyZ+xD5Dj/mqcMj1rglSI2qVndE5JzBjlDsTBV36SoVIDkGufFtJYwkT/AZjdhO0Hea0LdgGuqELtYLnoxj4R7SBjlHHv5LpTRogNj6v22G80SDJHXTkwVjiaySRh0rs6t5H3WC2BtCyqNc5kKaLzu7dzhVox7L/mj0pP7oWlawkM9YFuFSIL/W0k77hLCHzXhmctVeLWTHQsqjL1Q3cT4B8rh4cCeKA0lnfw13K5mDwWN5YMKG+ncNLKFeYi777g17yc9hEiKkwY9TusaJuvu+CZwiDlx8COB82b2512TJ6PQDRHu4jIU1XNCt674f2JKJ4ReTr49DDIJ9HK2k82vGhorb4RXSJkjTu490JAQDF9UcFsnk7bJcMbWwtsT7DDSfg8GdyiDxcl5AfKtbJ+ox2Y/wjou2PJxyonmLqc9xWNR+T8/UdRq8BD7CPlXbwidyH6OrsFNfbIFg9Q+ge1EsVJjlYfcUSuh39pAahlZfGK459nc9ieWBw/IoI/SBgC4ZOMuDBg/CPXlEOlbvvXpaC0fGzMPHh14b/NrKufTUmrq0ZaoU221xABPOD5F3yVh7T4stAP8lNqHqwO3BlAbcFcHP8Nfdzi+PKT/1yMLHZS5J7dPOu6PuqesELRvdl6+FWdVHm1Q1+5/3kMFU2F9kBRZstssKu0MwaBDGg5iG+Ok8/20C2/yIsv
 FAQGQPOF
 Ia81EqnCKsyPnvTw6bAeWojwUsy72yoQzC8BlDOV0y7HH7UeVQ+EEyR/rkOfaX+MPEPnu6nBXg6jBhGOZ57YhrRmMjnNy84uFclHODYNFYDt+QG7RofpgPJ1QRiPbQNThNWmKajV8lE/TXKI/42xfCQO+XkuImVjBD9Hzd6zzg4bsKCLk6gjl14IXp2KZSpgaqZBDMQjexzKGwp2Qh5TzK/yAFCQh7TwrvSyYzk6oEB/cmuYjaCAT9r5h8WvR4g/DDlQICBp8CZOwQvgZoAgj/ALhzLs0X5Hcewxroobbbj6kjbq6ogMne/ti76rnQmkXxAnyBgoqPNinMs26Lpo2dBrM+mo12l8rqPMfbDj7AmMZ4S3pkejEpM9SOWUyUbLmeNq4Wt6SLQoYSZoM3+9IoVLVqWubHAKhWVB8Kk04jjc33Rfq3sEGr7pRgOMrh3LSkeY8dfQswtdaXVFCkEaSmCuv48clWvyrngP+KmIfzASRmEC5q45SNte14Qlo4iHOCJqd1dHNChh9w+wQyrHq0ldn0I0h84FC5J3I9Fdgd+inMab4rTEx+fGU+WgURQZFHIaGQ4ceV4Hb3AY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 08, 2025 at 09:21:58AM +0000, Matthew Wilcox wrote:
> On Thu, Dec 04, 2025 at 10:19:44AM -0500, Peter Xu wrote:
> > > Add one new file operation, get_mapping_order().  It can be used by file
> > > backends to report mapping order hints.
> 
> This seems like a terrible idea.  I'll look at it after Plumbers.

Sure, no rush, please feel free to go through discussion in v1 when it
comes, that's where we landed to this API based on suggestions from Jason.

I'm open to other suggestions.

-- 
Peter Xu


