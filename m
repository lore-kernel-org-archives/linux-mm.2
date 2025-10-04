Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F3BFCAC5B0
	for <linux-mm@archiver.kernel.org>; Sat,  4 Oct 2025 06:22:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69EB18E0005; Sat,  4 Oct 2025 02:22:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64F8B8E0002; Sat,  4 Oct 2025 02:22:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 564AE8E0005; Sat,  4 Oct 2025 02:22:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3F2288E0002
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 02:22:29 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D378F4564E
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 06:22:28 +0000 (UTC)
X-FDA: 83959437576.11.E431084
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf20.hostedemail.com (Postfix) with ESMTP id E48B11C000A
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 06:22:26 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=vnc9BWK+;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf20.hostedemail.com: domain of dan.carpenter@linaro.org designates 209.85.128.51 as permitted sender) smtp.mailfrom=dan.carpenter@linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759558947; a=rsa-sha256;
	cv=none;
	b=lqDMcAPT4za8Cd7/kxQATfh0meeyeUXMytrH9owUXO2+EaeMCAAFuEsXwga+eRZ3NpLHd5
	YXIs7FcCfNSw1QzjjlX7Vl0SJWb5f0pjN3JMtrUG89105T8ARRZXVo49TJp5CpcSYveukB
	0B2G6QqfTBTZiJNg53vMVQR2eL+L0uo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=vnc9BWK+;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf20.hostedemail.com: domain of dan.carpenter@linaro.org designates 209.85.128.51 as permitted sender) smtp.mailfrom=dan.carpenter@linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759558947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=PM2NbKA/cfosFxeqBhbnMTf2R2GJQ2b66czLzCqglMw=;
	b=NAFA3GX1RqciuQp1zjZsiCT3vu4BTwIB+nL/Ccd0jo0hh/Yj8IPuccPNmxuFFkYh4s0/0c
	zaSTKdklXqLVRA0bGHM3ZQHgo1DPz+OsSEUBldvMsJSYPHmz6bF7+Ct+EDHY0mx2n3gTHX
	ncAVaEA1fUAltuQvrQlWAdoLM3i5OtE=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-46e2e6a708fso19228775e9.0
        for <linux-mm@kvack.org>; Fri, 03 Oct 2025 23:22:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759558945; x=1760163745; darn=kvack.org;
        h=content-disposition:mime-version:message-id:subject:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PM2NbKA/cfosFxeqBhbnMTf2R2GJQ2b66czLzCqglMw=;
        b=vnc9BWK+D64fJPduWzJNg1RAjV4FjSXhNc1hiZVOi7TQNWAf/UardJmGFZGGqOALrv
         V+kpos2EfJIxbh1bVN41IEexR5E6O9f3HCfdVhqdVIw9Z5aDaIbJ0gJHrdiICBVSUPLk
         cngG4QYhcs7wWye05Qz2ryoLL338IU6z1GSRfPh/gvEXcgsADVk/6REwiY0HTKe8PRLa
         kpPrMd7aDmrDds1N5RFQfT5tczHqcMqDAREmYq/W6a07//kimUQP+tueqEFbMXokUza3
         K+lweTuasl50jzFnuLbxmefNMnyWl04gmkxkpK9p85l+XQdY2LiHU7/EAlZmJwEha/rW
         fTqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759558945; x=1760163745;
        h=content-disposition:mime-version:message-id:subject:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PM2NbKA/cfosFxeqBhbnMTf2R2GJQ2b66czLzCqglMw=;
        b=Ohhxj0FehjJqiZQqp0EOJfceC2InJcdbqBNabTbXyHCpLiVvgB4blESLnZvO52Z46e
         D4rSGR3EGgCs1WwA3V61VJU6QcFDTEvLlVq9ydQsjksnPzLjHMXEUtUq9JWi/k1go2ji
         z3Aepk0i8tTGt3nQXBZYbhDT5dTDbF7oUsjUafkrYGWz9QFlMeFCG09G/W8Li0pbnVBo
         CCIFYUkIFd2EpdB2uZ37YdRSO10oK0Q318GmQk1SZ6EMvMeQEHBzeH99tn6nXohkDm7d
         ZzCMfnump2mqzTGiYW8HllxBD8g2nHiw93Om66GSUAL9rRdQ4xDO9i+I2WNRzhwYOn77
         4JfA==
X-Forwarded-Encrypted: i=1; AJvYcCXWV22LRhfx5pAPsXhcJlSK0MGzSZApr2x3m3j5HBvOc03jOKE76y1A+IkTFTy6gBrCN1pr10SdHg==@kvack.org
X-Gm-Message-State: AOJu0Yy4nje5rbjLoDM4H8iWtuqVJoeXhQyCu5LU4BBMbKjawJzDziDZ
	+Pqd424AEOoGli+ij+B4XkLgtYxv0iUtVYVybXinTm4It2nu399gdl9voxmsXGUEakc=
X-Gm-Gg: ASbGncvR4PzSpxStvprCSh7pzdCBw0Uii1Jh9i0t7cEHsVPSalMwyJyNVh8OwdkltXz
	/Uw/m0XBmJNfyrrzGXgf28/W4dqzG5iEm/xkk+dzh1/aZQxSJ2mY+gc1IdTZ6/e83yRAQRk2MTh
	w0CSVsNsYiJ7dmHsTIjViflUd4oLIEOIH9sX0AQJCcrL2Ygy/s2DI9JA19TTnaQsP/E4oI5Ainl
	afqYNhePiD13IyVsRnQ3k27wrD2ii0zo5NestTw4yC8JsOu8SpD2uv2JwpHrmxQ7Ww/kh3ptfXw
	dw+Z784lfOJKTeI5SAMJTchgRs3VhqKKH5MR5Fh7zjMU5IVn1M9sdDspg6gthYdYN3XKYtmVaaP
	yvLS5bQzQ+cfVnqbT2xZE7uMJc5q4OimvWc0V7ZCHqDPYKUahp2wOeRMW
X-Google-Smtp-Source: AGHT+IEQfj0KJQxWkakrb/1LhW9gmFVdAtkh37t5QfIA2xVA53gSkrzYmjqt61zneGVS2d8xe1janw==
X-Received: by 2002:a05:600c:4689:b0:46e:440f:144b with SMTP id 5b1f17b1804b1-46e7110a1e8mr33013255e9.14.1759558944839;
        Fri, 03 Oct 2025 23:22:24 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-46e5c3eca22sm97118785e9.4.2025.10.03.23.22.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Oct 2025 23:22:24 -0700 (PDT)
Date: Sat, 4 Oct 2025 09:22:20 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: intel-xe@lists.freedesktop.org, linux-mm@kvack.org
Subject: [bug report] bad error return in walk_hugetlb_range()
Message-ID: <aOC9HP6nB0C45QnS@stanley.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E48B11C000A
X-Stat-Signature: mk87mr9u6m9fgfukehuwiaq7gaf716zi
X-Rspam-User: 
X-HE-Tag: 1759558946-162929
X-HE-Meta: U2FsdGVkX1/fJxZbJzsj5B7IH71lsmzUrJ9UridXEH/bcYL/Eu9pY+FXi4uK+YnEBHBJZFPatlazIpyl292g5EQSeTfB4Ofs0alikK3sBqOT/PViVVAyDzFxngZQWz6mhxQ8/sHdANED8/COXIW349Mk9nOlu8PnKmaI7Sw9dRALlijaXVGUKHV/RvthG+mzM0nfMx7oVBvYenLPnR7I7zDtrFhFr5wcKbUdS41xOhRBVRVL8WxyAmviRpR8Eh5tAMapcOvbNz+3JZFaBthbsYEnE5Yoyv+BeOXghN/LeAU5d5kwaypKT+/NXfiQ9otcEP0NlwR1ZuvLKqk6ujgjk51Vu4ts3pbJatf21TMtNmaMetcyGzQGMceeSLPqChq/0n5SvmA9gZJGIT2oM42WaPe7jiu73Gq82tOp35/hAdxCGw/pvIG0mnI2o3XJOViimGtLiZUZr9kp9oTqIDYQDaj+sn1cEZnvTM/MDrQOam0nKVQ+6I2F521kRlX18C++h9JnyNBRUmvEG4W0iGpgUh5ln85kMxKZ1c7soi0IlWGy97BezhX9aP6+ckASf0psL9vQulZ1/S/LTzfIppab/tMqPXi2UQIGoYWpnXix1XVvBwt32mYTWc4hwFCqj29OHEV0sxDd39W53mLHGhSjWPK/b1mLaXFLEV7iHz2VgjoOwqqfa1tDrqAviIgEKa1WHHlnutKDLJ0yWPimsj8l095bNGpc0Ts6GeF1Sj2pUXcfywSwE+pRN+hW0+HIdnahWB4Su41FP0NXhnQE/fI1ew+gay7GDlGwFAf14PLEi7FRcQz0nESOAFZEeAuTgDxFFp6b2MY/Kp/VgNcXe/+b2XibvG2HHFAcyNMuZ9GauGnr1AQMLqboRaXgSUY4ztHgxss53Sw/ep9GsKmRXnU971RjdjaJ2qWGlQVZQJjK8UHChlFgDoeu/eccgZOBjEjCVD8gOBbLmUhspSUlUtx
 19p8o/ff
 CWN2cY51E9w48+yOl5zKCAqSHC33//m+U4XgNskseqrQP+Or7g5zF84+FEeU/vd22oboegQ4ZRj9PNzyi/OBibDy8bxNDx4nB8eGqHb15OdUlfp9GjiYwdJUEyC5UQnIoFFNtrFGA6XxmvFYT19i+t3POtJuwZ7CztKqN8Y8GIiUGEB5P7WIuSFELi5ruCgikegf05W2EOCeOXPsp8eQ9mD2iMOh3D3h5TeFMhxPCUKO+1TYXYJe5UhyWVeEwVFPMcF61E1LoPIVLqEDxoR5+tUYhvKhAmgtvi+/I63bXSWS6rvJ62KLYjZCRsrqYV/MuMDY3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is really old code.  I think it's a bug in hugetlb.

	drivers/gpu/drm/xe/xe_gt_pagefault.c:353 pf_queue_work_func()
	warn: passing positive error code 's32min-(-12),(-10)-(-1),1' to 'ERR_PTR'

mm/pagewalk.c
   319  static int walk_hugetlb_range(unsigned long addr, unsigned long end,
   320                                struct mm_walk *walk)
   321  {
   322          struct vm_area_struct *vma = walk->vma;
   323          struct hstate *h = hstate_vma(vma);
   324          unsigned long next;
   325          unsigned long hmask = huge_page_mask(h);
   326          unsigned long sz = huge_page_size(h);
   327          pte_t *pte;
   328          const struct mm_walk_ops *ops = walk->ops;
   329          int err = 0;
   330  
   331          hugetlb_vma_lock_read(vma);
   332          do {
   333                  next = hugetlb_entry_end(h, addr, end);
   334                  pte = hugetlb_walk(vma, addr & hmask, sz);
   335                  if (pte)
   336                          err = ops->hugetlb_entry(pte, hmask, addr, next, walk);

The ->hugetlb_entry() is implemented by two functions which return
true/false instead of error codes.  Smatch thinks this 1 value gets
propagated back to pf_queue_work_func() and results an an Oops.

The two problem functions are hwpoison_hugetlb_range() and
pagemap_hugetlb_range() which returns PM_END_OF_BUFFER from
add_to_pagemap().

   337                  else if (ops->pte_hole)
   338                          err = ops->pte_hole(addr, next, -1, walk);
   339                  if (err)
   340                          break;
   341          } while (addr = next, addr != end);
   342          hugetlb_vma_unlock_read(vma);
   343  
   344          return err;
   345  }

regards,
dan carpenter

