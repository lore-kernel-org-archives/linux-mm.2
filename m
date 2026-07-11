Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8025FC44501
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 03:16:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 625536B008A; Fri, 10 Jul 2026 23:16:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D6566B008C; Fri, 10 Jul 2026 23:16:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EC696B0092; Fri, 10 Jul 2026 23:16:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 32E726B008A
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 23:16:47 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AFE629080D
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 03:16:46 +0000 (UTC)
X-FDA: 84975033612.08.950F845
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf03.hostedemail.com (Postfix) with ESMTP id DF63320005
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 03:16:44 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=onF4Oy1O;
	spf=pass (imf03.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783739804;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FBlRq40n+WQNoah/jqkKv0Mdb6DSXF7flMHY66vmfak=;
	b=Ek2wRkCE+hORYpe/CqKkqCnnP8bN1iHx3QT99Bt/aZa0psOqiBJ8iSHAI815K3s1HNhEoG
	CkyVdxKPcDVNpiX0X6RXVZB1nf8fp/sVGj3WV0/BSLR7NKsPXYaaOct++yRYruT+U8wZ7r
	e7otbiX8V7Pp3wsdFQTJvxk9XmaeMWk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=onF4Oy1O;
	spf=pass (imf03.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783739804;
	b=6gAtrVz5jBB3TBAWebbGx06VGbYm9hK8jwhlsUcsnw1LOl8mYAbjxP0UoIx0jp4tp3j3Ly
	QEIV435dKhQuYllLZaC0YcqmYrPNfxdO2yXV5tUqm53n9uPAYH0G2H8BRhuZlTAqzLHkHe
	2u3zq5V9kJldmkJIJ6Pw/i1aup+t4Jw=
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-8485fad302bso1581325b3a.3
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 20:16:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783739804; x=1784344604; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FBlRq40n+WQNoah/jqkKv0Mdb6DSXF7flMHY66vmfak=;
        b=onF4Oy1OljMc8XiTdlWHWee9QQU6SJWhZ/Ni+f6AhflCweRHvVpLPLjg+TgE1Xq3JT
         Ih/t02/m8SiOa0c1rg17iePyZpYFHM/N5OYumTz6udRsDMVD6z+bVk9mb4PUiFv6TRwN
         NF9W2aL0221iWt5Ue9RVrTNvPQSf0JfvGXXDnntX484r72FiPgihc85rF4AzlagLghtU
         pDiYDVZAJi4dZ8C3Ns9NSm0ojR1sqtV3r/42ucHsGlCoME8peM6im4dLaXYD15ynkeVQ
         S7+JK1oQpwbw+pwSSaY+DVJgGNpDnQIW035GQnIz6xxGOo29aNog2TyCmxdRYmqnkc8J
         bNZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783739804; x=1784344604;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FBlRq40n+WQNoah/jqkKv0Mdb6DSXF7flMHY66vmfak=;
        b=iLYrGXNN+y+X88wS+N4wMfll3O4+rvOYyVdNm/Sr2fborlh6lf8abI8OmZYJ3guf+z
         em4WsRi8uJ6mgD3Eowj6yWdBvUU+UipOZELIJaQ5jCtnkZ4wjGE4PaWFY5N6vYfyTYoE
         qNue8+byrEIFXnLNErnyIOo4zBEwEqeFX7H0/G7kaoRAxShZm20ENncz5DzWmDxy7kJT
         AVGw9Co3IWql52eDlM0zWPhm/G5GQHOIR/ivQ59DuYHZ/sH6cBZ072FbvQCmhNDTzQcn
         rFWIgYQrU8eT7jTFrkfCafpR3Ad+Ue3U3c7QF65q6EdIUNPyrVoNEqkGCo+5t4Urf9D9
         hc0w==
X-Forwarded-Encrypted: i=1; AHgh+RqXzIcXvGXh5/wgTNAWOKIKvFWDIBMNTdlMxlAe1Y/VlyeTZ7FmZDU4eBUZ2Isheu5VWV6uZu0jNw==@kvack.org
X-Gm-Message-State: AOJu0YxihOM4xSSRW6cvSxitnP/vT0h+F1rgPI9JFy7+wfHCe+ylXU4o
	GxIdPnvCI+X7u8CDCEiyMdvpn6Ote9AkkJ7m2XUtEcBLJ6KfD9cuHtdq
X-Gm-Gg: AfdE7cksZGtvbHRCmxovnGmCcAR5UssBvS6eXTpoOIcWcNgWJOHR4rwC2TsJRvbq9QC
	/x/eKXd5b4+PtVFGreEZBiqNM5cz9PdW5N+yjVQvEMJO0KGN3Bj7r9Jzq4zHjfTkZ6fY3WOBHBr
	W8LTd2f5Y3C1cUo3ZeLBzlfj12OZbaziCXFbn64QjEzBUtCk2FeJN4ussx+Z48SSOSbEnxzIFCI
	U39L4zlbdgkQk9ab04qDb12vEyV4NTGFXXOGUY1oPhUA0bNwDoHONPwuoKB3WyUqFheFHhllbAN
	bOtRIAc4AAziQmDdRWQ3dnvtnSCPlPkSJLU3/EuvNAxdIpq+JkbNo9WA1h+gOXyy9ouIvLV+HfD
	i61phxRus6OFNFGZDWpyqTxwuMxxGDrMq4QFM3Rf2q2rz9e9g6vVBBVqeQ63dYf5y0UUIeOfdtl
	1CEA34l+3+lUGdEXwKRi8stgwePSXsVcy0a9xX4k1ptnLMlyHiwEYhgNA=
X-Received: by 2002:a05:6a00:b4f:b0:848:2f77:e2da with SMTP id d2e1a72fcca58-8488979d33dmr1391764b3a.67.1783739803838;
        Fri, 10 Jul 2026 20:16:43 -0700 (PDT)
Received: from skinsburskii (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84870d76ce7sm2041406b3a.55.2026.07.10.20.16.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 20:16:40 -0700 (PDT)
Date: Fri, 10 Jul 2026 20:16:35 -0700
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: airlied@gmail.com, akhilesh@ee.iitb.ac.in, corbet@lwn.net,
	dakr@kernel.org, david@kernel.org, decui@microsoft.com,
	haiyangz@microsoft.com, jgg@ziepe.ca, kees@kernel.org,
	kys@microsoft.com, leon@kernel.org, liam@infradead.org,
	lizhi.hou@amd.com, ljs@kernel.org, longli@microsoft.com,
	lyude@redhat.com, maarten.lankhorst@linux.intel.com,
	mamin506@gmail.com, mhocko@suse.com, mripard@kernel.org,
	nouveau@lists.freedesktop.org, ogabbay@kernel.org, oleg@redhat.com,
	rppt@kernel.org, shuah@kernel.org, simona@ffwll.ch,
	skhan@linuxfoundation.org, surenb@google.com, tzimmermann@suse.de,
	vbabka@kernel.org, wei.liu@kernel.org,
	dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
	linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-rdma@vger.kernel.org
Subject: Re: [PATCH v8 5/8] drm/nouveau: Use
 hmm_range_fault_unlocked_timeout() for SVM faults
Message-ID: <alG1k3JsoywE2CBM@skinsburskii>
References: <178371866223.900500.12312667138651735591.stgit@skinsburskii>
 <178371881847.900500.8789369230260725500.stgit@skinsburskii>
 <20260710151222.ddb35eab9c81a8720491464a@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710151222.ddb35eab9c81a8720491464a@linux-foundation.org>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DF63320005
X-Stat-Signature: x4gbpnkgdde3q45ss87uowh7z85hzsad
X-HE-Tag: 1783739804-868075
X-HE-Meta: U2FsdGVkX1+5Uye5fZdreRQwY7mZ0xMWie8B1QOOGIaTgDmWc3/11qLQxGlRXLgnrklpX4iFpowayWkHZ/Xv3mtocPjHzZsFu8uieCx505GNSs8AgOmqpAkGSoQeNHsIkm3a5Zqm/6o2/1BrJ1GIwowAYuSQz9X19U/zeHj9UC+rhL+fsBfO/+yY4sV/vvk3twBDv4L5551kSmS3R6XOF9CHHORnjZy2Nsmq9gh0DohAsTuCTT/R7VzISt0w5WxGu2wwivqMtHxKPYzE4HuH4+vS7LB+eHKY4yDIqAD+q1mjn1YOZFetmmLog0ZbmW4vi2VrLI1nWR49W3VsIKigsALEqcHoWlMLSLT25M3gjpJWTEeS9OuuPRpzPLG3i4iPIN5YSJGdKCdcyWHpRUeR2yxDVdykWS6y6H32mse2vz1gvXs1xB24CJ6yqUwzGgWWKyDl6gJdzsHXwN+oqTpRN5s1C1RH7xtBPSEOIzM9wcuSWmu0kAWNtpuzrMTkiWucsPUAfGlV5HpZMwMWOoDNbHvHY+qCbtuIKVSZ/J9xUvr3cX/MkFWq6V4LGV5UORpJ7Gzd9yD4x5BtEPEPnqfdS5fSFP24GVuZsc6JNYpWgwQJvOjP0vo8JZOgchQnYrQ8idtZySf6CJIZrmhqKae3XY8i8X74eUbM41SarFBbEMY3I8tpD9KQkJjtwQhwvcUpZhI77SgW4HHRKp/yPtFsMMkSmrk7DKvnUGp282xdxWcW+6PFfsO207uQ7U/yY+7gLSB9iQeQ5pDA5r6AJ6RsV0EE2LOnzqi50X5X4cV4FOVCLKsRTrvv7gTuvOfhyUBKxiSEo/QhPFDZG5SnyZoWfrXMTdHYvGfKr4ymbF0bZbai5o17eGOw2Qy/qQMLk2ZV9IRCVRgIAWi1R7D11iMf35D60el1p29UhrRIpGz3+F9xeK24zAc77yX7Cn7a+ZH66Mk70zxEhh3YJSPi/1n
 1U3AadsZ
 bCIBgqIgnEvKLOQseVFaPHoBk5MNimS1HK4ahe/hp/OIURrB5uLoHHQm2JsIgI7T6J2+6qUt/2d2kmpoWXlGjdCitZp3jggMkAD3oTGQo6G8jFGQqMYLVYudDgTK3dsh3R3a3f7hKKxVxu118mKVA7OyM15kcIN4TJqEUIysVZiUOCK2kp/iVeO869D0VXn02JB0wSPPii8xXjbuh8CEvEp5MAsP8YwWyfLd07l0cMvM6OW2o9yu8vpFKUIR0oBt10/d/e9Vgqds6WV9ZEfpqSioXalxos0f23RnPEXlHAFrMyrRLqlh3Xu73uEtRT6aiyIscUWJVB98SAQh1Ho8KSIdpSuFyjn7Y5XH6sFxy9Sn0b4zHul07vkxfzuyusBO/CcDXN+9yPufkEXVTqTyr9H2fk3wWqiF5h3skthe4ao0LHNZ0+tjOYNqmAju/3VgVPg2pRTL0A5006MBP3flNHZhKqG6zGONcXDFUhiAj8fx8047LmtxgpL39foUb2e2TdFnthKUKg967hGjaE/rsS/pL/nn4ZLmztKi/+RDv5p/40Oc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 03:12:22PM -0700, Andrew Morton wrote:
> On Fri, 10 Jul 2026 14:26:58 -0700 Stanislav Kinsburskii <skinsburskii@gmail.com> wrote:
> 
> > @@ -683,15 +683,11 @@ static int nouveau_range_fault(struct nouveau_svmm *svmm,
> >  			goto out;
> >  		}
> >  
> > -		range.notifier_seq = mmu_interval_read_begin(range.notifier);
> > -		mmap_read_lock(mm);
> > -		ret = hmm_range_fault(&range);
> > -		mmap_read_unlock(mm);
> > -		if (ret) {
> > -			if (ret == -EBUSY)
> > -				continue;
> > +		ret = hmm_range_fault_unlocked_timeout(&range,
> > +						       max(timeout - jiffies,
> > +							   1L));
> 
> "1UL" here?  I'd have expected min() to warn, as it likes to do.

I'm not sure... The "timeout - jiffies" can become negative.
Won't 1UL convert both of them to "UL" and thus make the comparison
overflow?

Thanks,
Stanislav

