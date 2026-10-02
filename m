Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E442CA5FDD
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 23:34:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 583966B008C; Fri,  2 Oct 2026 19:34:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55B8D6B0092; Fri,  2 Oct 2026 19:34:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 498C26B0093; Fri,  2 Oct 2026 19:34:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2C0536B008C
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 19:34:18 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 280621C3BE5
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 23:34:16 +0000 (UTC)
X-FDA: 85279292112.27.DAFDC3E
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5EAA6C0006
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 23:34:14 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jiLtuPS9;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790984054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KlE5oOpiLimhwWokygiFZQE0uDbuSR0YvHVgZE09XfY=;
	b=b5swCqRsKVKw21txCRaFkuvjvqlQvtdQqjMwheJMofASbGU4vZIGsoM+/Hllr1mCaV55+h
	n7MI/BmDk8uOrx6rETblYA8pqgHx5vft3WW+6Oo0tk56kMjv8LzP8FQQdIfFPgkFoneagl
	3IyvwaSaR6nXPQOSVaqEyQBHbxfHtO0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jiLtuPS9;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790984054;
	b=nq9osOS8CiTTZU1cL56/Rwuh5LI4olMd0KYBX985c3903mzuilxe7R4/1mThV62SbLNqwH
	whGFF4WO+QdJgjdwIfXP5MH4Hdv6wLj9mJRX+O/LyesOr+GVUHTqXF8gTp4BD+ciwkAioW
	/z0P3oQMc6rlM6k7tvkkQDfudfmYLH4=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-49ff680331aso3048625e9.3
        for <linux-mm@kvack.org>; Fri, 02 Oct 2026 16:34:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790984053; x=1791588853; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=KlE5oOpiLimhwWokygiFZQE0uDbuSR0YvHVgZE09XfY=;
        b=jiLtuPS97x2gobut/DptGAU6pMRmO7dq0fQPd/lrYwwu4cnF7LYgClrr64hMZKa4T7
         wmmP3/F6ot3CkYfg22ve/PKtPDrkJWTQ+3/gaXiV+snhtaoKOxci1SuTlF3scSBuJi91
         K3zvhdncFm8T5pi8xWvMS4ReCQnF7YjiScwYzmdVUNgIPdwGa4d8u7/9kMAyNut3+5e0
         ZftY5HEsortboaZmnzYj8197uTKfpJQb7R9TZlOU4xKhOjJa0bOivP8ZVeIxt1ia/4yu
         puIh24+10m2IxTTr8wxQamQMekKsWLU9bTfsL+Ivje4pM1l04+hQDVjtuMe1PdQVxUyY
         682Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790984053; x=1791588853;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KlE5oOpiLimhwWokygiFZQE0uDbuSR0YvHVgZE09XfY=;
        b=eWDDttJ6pGvJVmVUXCMJu+nKfty/rsf2gpXqF2MJRRv87HbvEE+IVjtY5Oy++03IAc
         TNfgHT29MobYmLeaerbHyfYPqixRFKyJe3cfkFli8wz7WGkoRdKDxi/E1Y0c0mrFzWHl
         0RSHGDrPi6Zt3tonk7RJDmjqIoYdBpnBthiG8Hnod2zC034Vpou1AmDJMbyi/9hkDMQF
         f9eSDMQW8IrPRgR+6YiJDoZheexvyxFK79Ni95DVSenVn8GIKVChcIVe0Y/Zjtr3acqz
         mBkNWUdDjKCo8xOM2ROb7BP356yAGo7gCIyyF1KoG5oPNLucp5Na18BBMuBWr2jo579W
         d4zw==
X-Forwarded-Encrypted: i=1; AKwUvBxlv6AjKHB0gUVMa2pp956LN/3APOXIiviinit4t/40QPx5WbhFu/pFhlB/HHGWTOs+FeLnnUIwaQ==@kvack.org
X-Gm-Message-State: AFuF++kcTW4wfQkAynKNU+YtLY9bKuVPfcyahXtGbnqL1I/i3+ANEYxZ
	a37uz/cASQJbj0xSPNNu2oVT+TiOtXaBCHLqIeJR9DPAg8wdnAaThqLP
X-Gm-Gg: AYBFou0W61+wMwHd7tDry8ycwq61OYJhcMB3U3lsNpsKnp5dsmKxJzp84VjVBHTjTF5
	9pPTMzOOKLm6flfAa/HW/C8jhldJsLm4ZQTyOSUh0xoeq/eIpkg4o8RDK5U8WH+m1d634a5T/P2
	fmiYCriFY5IU9vpre7ZMYZ8LWIPLm32fFI5cBsYVcYVM0/aQe4KDWRWriXrmG2KL926wAP4Vz/2
	rt7xQoW61JN4AudF6PuXsHmHDw/DCJj59/c30SO83z6eIV/AQPDLJh+eKzVbq9ok9fMev90omex
	mPMjaJPJnNbaEX5RIbInbXqwC9CLdwEXsovdOuBjiPbFl7SkJkWOFdkk+Vg4/w9Z9eI8tAs61FH
	yfFT8EKkx6ePW65IBBRPlRImkYbphCLFLOwzmlD+7R2PFXBVvWq/VHTj3ZpS3tIIS0IaSdwC1gG
	xpa/Vc5y3hPTOjXTDR2bnTdiOowypvz0n0hKfeYAE54rm/3Kc6ZJdQi2rB8NU=
X-Received: by 2002:a05:600c:6287:b0:49d:1df8:156d with SMTP id 5b1f17b1804b1-4a1680f5050mr9710285e9.18.1790984052936;
        Fri, 02 Oct 2026 16:34:12 -0700 (PDT)
Received: from gmail.com ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48b380fad53sm9737285f8f.19.2026.10.02.16.34.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2026 16:34:11 -0700 (PDT)
Date: Sat, 3 Oct 2026 01:34:09 +0200
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Anshuman Khandual <anshuman.khandual@arm.com>, 
	"Liam R. Howlett" <liam@infradead.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [PATCH v2 2/3] mm/memory: remove the mkwrite argument from
 __vm_insert_mixed()
Message-ID: <asA_Lis9dHNp1xv-@gmail.com>
References: <20261002160535.661399-1-ekffu200098@gmail.com>
 <20261002160535.661399-3-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261002160535.661399-3-ekffu200098@gmail.com>
X-Rspam-User: 
X-Stat-Signature: m8bk46ea9rjcwhuaeu5ogtnbw6rcaape
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5EAA6C0006
X-HE-Tag: 1790984054-165451
X-HE-Meta: U2FsdGVkX1/Z5W5Nj8wNtwSBuGbxfzuEVLXzessTpyONn19y+WEitLuOKD7h88bs33CjzdrIbZzwfQNBsporhvyMB9J4j4PVW0X3JF5ibhibyXCN5FvJQTfqcnZCCQqeGEPxAAcmQlQDdu01UnWZGnaJgntUG2BysZzUXavLa+xSzKzHTI9503cbCebQmwiKNLvGe6mVGu58ibVHZ8FkrVSYEDN+sXx7S+8V31WR5rV3Fk9Fux8lt9zBeN7EJ/H6uQtZmOI+A1ngy9+Ojnbh/ucxtLo3jDdqOclbCEIIt2/V5/cYuCg04j0YVht0cu0HhABaray3eXsUwJTus/v3sRw6evdXianFhGADcaNjkdXRWwCFIDXCEBv1sBjzNaOyFq00LyQT5vk6gHyuTMZO08rSd0tbUtL+To6kgnrA+z4jQqSJ27cp2tTjy6Tb/gE9c/rV05J00BNfRTWPrAL5EOP+S5Z5nCT2p7kr5PfYy89V5a+BRF4TQvfgDSCt6VOC3QDaabfEOvQuIEHg1tmVCbsNLnUPqMbi1lF6dzWY3ucJAVQuFSdK7ZKoqqNH7VVbw3KpWAG1FtvoukQR9lCLY99+OxyHbq6TEXM7UFcdj1avSKLmnUyweQsDGxo4CM5kmyppoO8wWz5lQK4MaCQXOT5D9vISsocKY3KQ1i7X1w/AS51wf4d/zhudCkwIOe3zP3oh9ecPf6nCUoywGQHs8jcR7PsT8r5sFcp003/rZW9j4uJ0pPGtVEjC5gRK7/872WsFS+3mPdWzgqG/KgLjhgj3LBEsCTgoOiBIAQL6yuOlINUEeezFmR3zZISNrQUgMM6BClZr/Pkwg2bQw0g7EEAywclRScZ8QC+n/Y2+HtnkxlBWc+r0HSF7uWXx3n3YXIWm3tu0jbdJTFCQyASPmOHkG5xFOlzRPiCuWYIBXKu/XgEyZ3JBAdWKWRhITaDCSdh3oEm8wJDEykpvfpo
 iCz08wrs
 lEw1md681Keh+SHZWp7Efe56ZoVDNlDZnNQW+htpVxmcntJydv2/kyP3Bd7CHBjkqmdYVPEmcG1P3KEKxX2DHdnzu4hFYKvIaoSaJArn7cS0fTHxS2pZKNE8x9tKn/VzbFUT02zkYyk6Xg1Ynw00uwEjr97sceR3cG876KP+ncfGElccBhPqELK2eQDtUtK0t+SY3kFi7yP9QM0c83w1mMyLgW+Ui9ICsVC+kDZ8Gs1kf+69E+/0tg6s3hKwesMKnFHB+9axYLjZbR7FrPsdPKCSqBJsI4gAY10EiT1poEv5B29ewBEOu2Ut/7i+FjM/Z/DmQAJ5D0Os2gkaWfrec9f2GvTbuu6GfXJULWuENyYnTqfHtGFu9nJPHLudiHfX8YKZlSdmLXXxZvOPiGc9UqGplvM0AnYuWF+t/iEhes4/d5w6oi3Wnf/zM4Pic0CTK1OPfzQyNLQoiMPeApuB2LXt3/Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 03, 2026 at 01:05:33AM +0900, Sang-Heon Jeon wrote:
> __vm_insert_mixed() is only called from vmf_insert_mixed() with
> mkwrite == false, so mkwrite is also always false in vm_mixed_ok()
> and insert_pfn().
> 
> So remove the argument and the unreachable code in insert_pfn().
> 
> No functional change.
> 
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>

Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

-- 
cheers,
jose a. p-a

