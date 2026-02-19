Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 912AFE9A03B
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 08:24:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 717E16B0088; Thu, 19 Feb 2026 03:24:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C5326B0089; Thu, 19 Feb 2026 03:24:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A71F6B008A; Thu, 19 Feb 2026 03:24:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 44E376B0088
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 03:24:12 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DB5FD8BAD8
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 08:24:11 +0000 (UTC)
X-FDA: 84460518702.04.D9BAC38
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf27.hostedemail.com (Postfix) with ESMTP id EB8654000A
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 08:24:09 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=t6GzZMae;
	spf=pass (imf27.hostedemail.com: domain of dan.carpenter@linaro.org designates 209.85.221.52 as permitted sender) smtp.mailfrom=dan.carpenter@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771489450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0GbbSdysg+YFEUJI01k89ruDtqq8bN+fDTrKedLeRl8=;
	b=JWfL5UU8+7BRzcu6NfgEWykfq0tLK0Naabo+c58PB5J53Z+BoSo3LNebSM9zT384HtpF7U
	NRcsttR9xHAVBeY0QswutRs1wSp9pUv9q8dZvtZ0VgCZhRvTqzQ9sePS3RCcrzJspjCZ1f
	tX8Lq90Rgo5UhMSm6Jhc1rk0gyEPErU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=t6GzZMae;
	spf=pass (imf27.hostedemail.com: domain of dan.carpenter@linaro.org designates 209.85.221.52 as permitted sender) smtp.mailfrom=dan.carpenter@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771489450; a=rsa-sha256;
	cv=none;
	b=PJH1GYWr2O6PpWKCGR8/uiDnP05MaL85dpLCaYWk87NrDtU3Qc0AdwAm34splM9b4FkmlN
	IKu7sNTcZgNVC7H0hM7piRmaiuTDQOVnhGn6qpTHNeExkgqhChSsl0cTfKoWMBdsTD6U3X
	G13p1nvnNfiXv5dCbu5VxCWBemvW/90=
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-4327790c4e9so417281f8f.2
        for <linux-mm@kvack.org>; Thu, 19 Feb 2026 00:24:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1771489448; x=1772094248; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0GbbSdysg+YFEUJI01k89ruDtqq8bN+fDTrKedLeRl8=;
        b=t6GzZMaeRxpWnHhhJQsBK1zCVUUb1iVO885CLz+YcDq+5DI7Bz1UKScGwWFCYEu63H
         3zDrkEpItm+qOmYBEIKCRYok8A6saBGKNj/cRuTcpvXb6urS874A4XyAUhcAL0PLwYd2
         JjSfSVS2WB0inbQqvB2T9DlW6FOIXQo2yghmIJ5ge++GrVYxFbXHi3c6YJnbmI6MYhc9
         dtkjTSb8b7HS3/3WUobDdpfM7td5aNKUtjQDt1KHbwF9N+C3YMCGLDWqHPKK5VuOJmOA
         UYF2QKOV5YjpGNbq1GqgWzDv62PkZibi+hEOZUYMiNxLOu5EL0WkAVblL7rN05vwODIf
         kg8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771489448; x=1772094248;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0GbbSdysg+YFEUJI01k89ruDtqq8bN+fDTrKedLeRl8=;
        b=CBDNU+Xurld5sXYdTx9/OrY+wq0cVRDllo3lnwYE+j2U+QtWTgMAA62E3Fi7tHfodl
         QDnHZt1tQ2415TCEtVt/xZJo6B5SkTqnMwGMbOWIgwMyiRuRzcbHXMVVd//v0SORCgfE
         Qo5aJsrXe3GV3p/DAQdeGNEMFyhyZt4O1nUB/wACvXc7w9U3chK6gB3iT2n0hguliw81
         +WyUmsZImiknisBKu1ioSgo2m0fW6O2xO3Q16Vlh7xRHHCWNBDyCY3/dp3x9QKPkKSif
         sqNURilKMzqyNLgnMBdioY1o1TJn+DjNDO3xp8Qv317/1yxsjJhuXaRoj44AjBjFZbjV
         HgNQ==
X-Forwarded-Encrypted: i=1; AJvYcCUn/Op/Ooe+4ENorsfObGstjW30iLTILh/cS7vBty6kvZUd2idOYlKc6Es7gGaLxr+UGi3l8EOX3A==@kvack.org
X-Gm-Message-State: AOJu0YxbsHVILRlI3laULEW9bHDF3DMXlN43kScBloXbPyDN6jCGTpSS
	AjRu6dIQaqr43AEyPuUOMgDzLM5h/Bzr2CCNOQuyf63ajpayKIymm981jjvcwooaGJk=
X-Gm-Gg: AZuq6aLU2zMifW5PoUwbjSFojfXKpZg05kDSX4KTI0SjLtTdkrX5dC8aAjYm6Hz7oX0
	X9lgvtJKwtEW8I0kCB+LGdtIj6MeveoVM1/cytg44O1LyAoFJrH/61esrPbfansJWXfQqtPgVrF
	Tfcc0P8rLVXyrzvnajP5PFgCV3zNLwyt0mxKknyvaJ3kbeUJQPP53sW+lMEugGOq2GojRqOyA+S
	NASvXtjvbA7UaZYBMgO09I3UBHPKBAYjtvpE7IuBQhUOf3KgKIOr4cpPsPjsucGt8h0C3AXv3g5
	muaYWu7FyokSUdPNyLJgaOJeto/J5A5raJ46C/ocBISURQnC6lBEcAMqoZamXPdO7G1hXdUtcna
	rlV+PoXVVRmfwicUUXxNgTsp7sOKan4G7oejSrhM+5kr8aXDImyf8+79l1NlwptTyYIL97er9q7
	Iy0pZ8J5CO34eDtYZhuYdxdTsr9AQb
X-Received: by 2002:a05:600c:6912:b0:483:456a:5146 with SMTP id 5b1f17b1804b1-4837108fed4mr354407295e9.25.1771489448240;
        Thu, 19 Feb 2026 00:24:08 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4836ff00332sm412241365e9.2.2026.02.19.00.24.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Feb 2026 00:24:07 -0800 (PST)
Date: Thu, 19 Feb 2026 11:24:04 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Kees Cook <kees@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>, Christoph Lameter <cl@linux.com>,
	Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	"Gustavo A . R . Silva" <gustavoars@kernel.org>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, Jann Horn <jannh@google.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Marco Elver <elver@google.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>, linux-mm@kvack.org,
	Randy Dunlap <rdunlap@infradead.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	John Hubbard <jhubbard@nvidia.com>, Joe Perches <joe@perches.com>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>, Jakub Kicinski <kuba@kernel.org>,
	Yafang Shao <laoar.shao@gmail.com>,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Jan Hendrik Farr <kernel@jfarr.cc>,
	Alexander Potapenko <glider@google.com>,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
	linux-doc@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH v6 1/5] slab: Introduce kmalloc_obj() and family
Message-ID: <aZbIpCSuKU45b66t@stanley.mountain>
References: <20251203233029.it.641-kees@kernel.org>
 <20251203233036.3212363-1-kees@kernel.org>
 <aZbDQLeMsHCv32X8@stanley.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZbDQLeMsHCv32X8@stanley.mountain>
X-Stat-Signature: msz69xe8ojkdxo4gpb86y57pr9qeewzj
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: EB8654000A
X-HE-Tag: 1771489449-657411
X-HE-Meta: U2FsdGVkX18luJennvXJrfOFKZUA15SCjNqF2/ii/E4OaSIJZEEMzszd5h7P7DDHqSt0na5QI318tWWpE+oKZDUU9trPEpXIbbjk26DmoZROyhN+sSIh/qWoOhRdGib7W/cNg8xBB7Ubzgj7RdZiNjFdFMHUOyj4fazxwABpFC+p6mBkz+8ryARkF9SCqVJ7pX+K9KOcQB8sHVWxM6xLFsMudDNLPqqwBxgQYASBVs+c+zg7+0fP+0np4KwB6elFh7gfbMxKsiT+wsppt4VuJEzGNadRGAv1O+W9obP6/C/Vv052Inxoh1vNvdW1BqE1onPb7xdKh6W06jtJIk+6cchoKVweoRyyR0eWzFeCn5QdBYwpb3pgK93mnydvZUudGdENEJiP7E7+XgfjkPWf8RGvPxmZ63cZnTGsz/mO6YiO9CJX0f54sROjQgXNUa+dnnfFr8U2i3I1BJTpdOB1qcnKpp9f6ixi8spG2D6RdKNOJojYLr+2bNDUXEvvHFUyULEm1MtlBqGTicU2AcaIABXI4A2R3NUHEtX2w5NK266/aRpatZcj3Jz14A85Hm0qDM+B8Imi5wBPbx3cPX/amOCjZUij9HTjvWbGku4Wl1oD0hFl8Mbid0ISox2lTKrCkx8ZlORjl1OGKXqpfqrmobnFY5MhxuwHdjRWRw4p964PdT4enUOM3MCyGv878228x1HB9L4M9RhlUsdOufYBl8prFOMVS8gDwINFQE22/4jG5cpCovWI7aaBCTk9shk3GCXvfjGbeet6gHyxAhVZUtTBX2naN+5owysWBlKPufpavTGoQvSIG1p7UJzOxLPN3r8snciPbz4bDWOz+JDTQpActOaK7BSZvFld3R7BhFuH5aVo0chPoo6Qiv408k7G3gFSa74kQKcTI76/Wb2yAbbnSnijDQHj9DEumL/FIuemC0sfyGS3LNsGO6qQqUIP2JgdxR9FkvzxwmMxW+B
 Ep+gnxsa
 Mb82IfmzXIDJ3+T4WYRHc/12wKs6GWK9I5DHYV1/cgKjwDj9lGopd4yT7HVBGC4B9LSUPQM+tx6WzYHrN5umNfTXzPuioxjQnSlyJK/Xyksh7rbEswet33g4Mg0+2O2uu2ZgnH5Dfx2F6Bm1Poq1gmF4B7ScA0SYw+2BrK/6XaIfBMmbkApJy4B7uwS6yiuQCb4rzfkiYg+8bIXBgaRwM1+6+Tc0n4cR5BSL0j6PeBWdoUSlPSjNXsYFzn3dvy4eI5lIJoio6pF7JlnD1yTSZIYUcPq3EWG4+NOWQpb/sFrkYNhyNqaEn21koEn/mSqXTMpWh0gdb5VtmxVeWt1lKJ0oZ8TOsEYqMtiDchCd46wPAOB2+jddHFRU5YcMjCIp1G599a8kzj3L5QzhqvlbCMIfQC0lGUvOZPhZAzqlPFiCeFsqQ/+U3aic+jt/Uz7LdTUn0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 19, 2026 at 11:01:04AM +0300, Dan Carpenter wrote:
> On Wed, Dec 03, 2025 at 03:30:31PM -0800, Kees Cook wrote:
> > Introduce type-aware kmalloc-family helpers to replace the common
> > idioms for single object and arrays of objects allocation:
> > 
> > 	ptr = kmalloc(sizeof(*ptr), gfp);
> > 	ptr = kmalloc(sizeof(struct some_obj_name), gfp);
> > 	ptr = kzalloc(sizeof(*ptr), gfp);
> > 	ptr = kmalloc_array(count, sizeof(*ptr), gfp);
> > 	ptr = kcalloc(count, sizeof(*ptr), gfp);
> > 
> > These become, respectively:
> > 
> > 	ptr = kmalloc_obj(*ptr, gfp);
> 
> We are already getting patches that covert these to:
> 
> 	ptr = kmalloc_obj(ptr, gfp);
> 
> (without the *).  This feels like the obvious bug people will introduce
> with this API.  I sort of think that "ptr = kmalloc_obj(ptr, gfp);" is
> more natural, so maybe we could make it work that way instead?

Never mind.  It causes a compile error when people leave out the
asterisk.  Thanks for that.

regards,
dan carpenter


