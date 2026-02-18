Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49FA1E9A02C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 21:34:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8190B6B0088; Wed, 18 Feb 2026 16:34:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BF7D6B0089; Wed, 18 Feb 2026 16:34:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C2236B008A; Wed, 18 Feb 2026 16:34:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5AAD16B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 16:34:54 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 699CF1C229
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 21:34:53 +0000 (UTC)
X-FDA: 84458882466.15.900C8BC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3CEDD8000A
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 21:34:51 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YpYuew+r;
	spf=pass (imf02.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771450491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UD658ZwKuP2PF9xMpkydfrRh56szUrbMAmGplK3iBZk=;
	b=YwmvSvSPTEm3P39fgmyav2cxjJLEQTDKxmoX2aZGwX44YH9mqgGFYF2aOhLU/UlsXAfE2/
	ctSpvta3ok2p0pSCWJvKhrFoJ3IDMdcXKyklu5eXlXf1CBfhnCefJszCVBmKrXmN9z40Zg
	brWf6UmCGl30zjpP7Agrhj2ds5nqAzM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771450491; a=rsa-sha256;
	cv=none;
	b=NdC3gObiB69HJ62mM8ESnX88vYOYHvXtvMwui9HxI3XI2rInfQZ7hQqi9uF/9ZyiCPv/m+
	1TPxS8+w1P+fFmtJF5cJLNxjt0iVi7BF9zesBw0i+0T73dfk9gcVZOhVT7sVcfCasR3JP3
	EnjmLhLDI+XU07fYgiLWLaR0nACZ0g0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YpYuew+r;
	spf=pass (imf02.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771450490;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UD658ZwKuP2PF9xMpkydfrRh56szUrbMAmGplK3iBZk=;
	b=YpYuew+rDzq46uW2raPbwug7HFVCU+No6lmG24dlNGbfyGbsJthB/A6Dbt1EsBbKQnlfNw
	y2B2ThsoP51pGBPqV5AXbxgn/NVeAMgJ13tpSWD9i3GcYtyStSt0ohyk8/+5Eu8kCt0B3T
	14jCUcfQAcOzbBviWBgyKOQJq92VCQo=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-344-WLC-t-oRNPy8mXgleNIlcA-1; Wed, 18 Feb 2026 16:34:49 -0500
X-MC-Unique: WLC-t-oRNPy8mXgleNIlcA-1
X-Mimecast-MFC-AGG-ID: WLC-t-oRNPy8mXgleNIlcA_1771450489
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-896fae40578so25822456d6.0
        for <linux-mm@kvack.org>; Wed, 18 Feb 2026 13:34:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771450489; x=1772055289;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UD658ZwKuP2PF9xMpkydfrRh56szUrbMAmGplK3iBZk=;
        b=kwWrpW+WB63/d0dwvUUHWjE6wzWumS8NI/RjnVTQGgCBj/1A7+KkhH0Tc8a+QufyyJ
         015378BxIZiVLUOz79nPWRshjIV5gRJIgo/aDErXqFakLMDnAnAgVMj6vX/dA/HjlX/y
         ZwmcAhA3glOsjDHdaQV0FG8ubxelSPuDAu0vByw7Q5RM3of3hO0E6W+NLARarHxJKgXi
         WP4VwVRZ1j096OOBRunSJRlAozz8wTFT8aZ2MaG/HjVw8KUcJsxGymKObg9RCbFhQPPd
         hB4KfNbq1048Fs6vXgtiy5ESOeW/vfTGw/x4xtQnVZQDj9y8uA8pMd62tyyXM2+BQ7Uy
         KKdg==
X-Gm-Message-State: AOJu0YxKfUsNczogg5y8hVcIqcv3PUfeXxdKN86tTADTTB6/deve4FD3
	DjZLCf7STdLCRik0wpkmizVgMB7cI4uJI7uWmY18+FlR3Kx1KLK1tNbDWdINOs9kIptQqH+TkBK
	dJTbjKxGupa3EENvSlihiY9/QHHSQkzAHgUp0PcfBOejFcEZpsxKO507hWVvM
X-Gm-Gg: AZuq6aJb6M6zdTppIXlaUPzFy3D7lBxj4A+ud5klhyVR7+5t/D4+MI/7P5h4JgjsVjc
	0HhSRgDr1f3IBd676mDW+wiOFnHXOMrpOqSanwPPGDDLJC7G+AVw+Pc5pqxy3h8ZnnFhJUHNHi5
	TPevmkuvghJp5ayTZB6ODAR6e0ZazcxWb8ceuXw2WA7HveeWpqgEJhzNlv4GevK9M/UzMeCEgoU
	ucCxbogBu1o4J8E1lQC/NpSVDGgfeU+pGAe3YcTWXmbdgRrRnLwhOvuxgPVkAAUrL2c/zbj+uHp
	a1ko8mFsVeCBvjkBoX5ur3DdKYBcorDoWaEb0s6PtDDAonkx9ZiATNqdjvQmvoz86zQwQHBsake
	mbQ2A0doFr2Nu6w==
X-Received: by 2002:a05:6214:ccb:b0:896:f588:b2e0 with SMTP id 6a1803df08f44-899580c41a0mr45451426d6.48.1771450488609;
        Wed, 18 Feb 2026 13:34:48 -0800 (PST)
X-Received: by 2002:a05:6214:ccb:b0:896:f588:b2e0 with SMTP id 6a1803df08f44-899580c41a0mr45451066d6.48.1771450488156;
        Wed, 18 Feb 2026 13:34:48 -0800 (PST)
Received: from x1.local ([174.91.117.149])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cb2b218258sm1888631685a.47.2026.02.18.13.34.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Feb 2026 13:34:47 -0800 (PST)
Date: Wed, 18 Feb 2026 16:34:22 -0500
From: Peter Xu <peterx@redhat.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Oscar Salvador <osalvador@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH RFC 07/17] userfaultfd: introduce vm_uffd_ops
Message-ID: <aZYwXq-x8vMSPorg@x1.local>
References: <20260127192936.1250096-1-rppt@kernel.org>
 <20260127192936.1250096-8-rppt@kernel.org>
 <aYEY6PC0Qfu0m5gu@x1.local>
 <aYhh2XzyFsJbohll@kernel.org>
 <aYzZ-zBipYQ2OA_n@x1.local>
 <aZIGp0F7uuS9qYVZ@kernel.org>
MIME-Version: 1.0
In-Reply-To: <aZIGp0F7uuS9qYVZ@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: u0TkLxaeDpVoK5I8w4XynPhBIoNXS12T8v5KWDdXy-Y_1771450489
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Rspamd-Queue-Id: 3CEDD8000A
X-Stat-Signature: hxmfwozsdgenpbsnxu5rok31ybic55cf
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1771450491-446214
X-HE-Meta: U2FsdGVkX19keZ4fhfy05aNQmrTBOKhtHF36V25lv9MKwTrUCB2ioNkL+hcvqYcdssTflqhO5IgSb/5x3jVfKsIZK2FVPs+qpGDTa5mdr3946clJjsL36EGRf3RIiY8v0gHasaaANDKDQquS+/Pwh9JErTCywGoGtpa3UsXN7cMhmV1Yw6F95HjraQZ7MLPpBg5LnUeiuZ2rvb0D/ejxiO1fhkEcT4CYC6h7BUSrhoEc++k71RsqOULXuURzwo7MoxRWN7aONDkdgZtOA0+mEwFCxvgNV1+iN50NJyPMi2kqu8/6UKNZoccVQcX0tBF7orAiUVyVQQUocX3VxREfg0Li9w12PzXO6fsdo8gezV8bh/SP98eXlADy3B2nMplunpxbpxsNOKzX0QGx8YLDIdxtNETxm8hLii6FP7jybXmwwduz7WP/b7LdUm115IMzZVTEdfZCEpgq3d1KcCsD4OyTib8YMeTeuNS7E+AE1oKTE3fiA8woojSTHmmXqoZlppT7qRc3C8c85IUUTRoxiC8jgtBKgTViJjmPhl7Irl3SBSb0SgX9dIdZbNfR/yYB1Q56b+QT9K4YrQIlE+GDsWVdlspRQv5xl+bVzEJQ19aMstcbiFkW7ccqJt8VBQcF32kr/zfyBr4J97fZfLlhoYxkVvVuZ7ex4h3lUtX5LuQxzCohgTOYsI/kDIqMgwbVV/MAvuFyqVMraR4s9xpz7ORV6U39DEFIdij/PLuYnvnF/ZKdBvWUnjo7Xt0KqvGxDiWgIlNvV2+cuGV3ZS54+9mXOHms8UKk60I7sm5WtNXRV8DouLeQ/9ObrsxZzDdfZ8dRG5Ib3m4WNyT6SefJ0IDFe/Xviev44EYXPPfKVAdYdJoAlXPwnaMbvePwwsKgTsXiYbWrXqnM+URMwF50g1MfNUDCJVUDdGUqjiRDUnJsqNLKLD6MwNwBKpHtekArP4nj5ZmPDgY/7hMzLEP
 O5+H+v7k
 lplVIEjKHNbtKHE5HifRlMmJ1KL672MOtBRtyH/U9cl5FtIWEoTenlyYP2H7foUBgv1ZL5n5t+Z8KedsBPjy1Nc3MpNlIDDpfmPxTUcvMZ+GoHJ2/oNJ6osqjFJUHxLTqCaOE3EhybElhNQw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Feb 15, 2026 at 07:47:19PM +0200, Mike Rapoport wrote:
> I agree. Will move the check for the markers back into userfaultfd.c

Thank you!

-- 
Peter Xu


