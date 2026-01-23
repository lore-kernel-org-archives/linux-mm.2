Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85DC2D6CFBA
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 04:12:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C39196B00F4; Thu, 22 Jan 2026 23:12:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C10BB6B038E; Thu, 22 Jan 2026 23:12:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3D2D6B038F; Thu, 22 Jan 2026 23:12:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BB4D46B00F4
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 23:12:32 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 46C24C5EA3
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 00:34:17 +0000 (UTC)
X-FDA: 84361356954.08.3AB5CDF
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	by imf08.hostedemail.com (Postfix) with ESMTP id 78632160004
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 00:34:15 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="jp/3ZykX";
	spf=pass (imf08.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.44 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769128455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=asBGl1upDPy9EBtcWnpVXAcR6hW540Iv+SjDFfHMW0w=;
	b=4AN+LrwRk4DREs3Q/mAXGsTYVmLuKH4NXudb+efSX1b8jZiw4TAIgyIVmdun+Hr65UupXW
	UJy9fT2Qtqgie9A+EAF5Ew4xq2U2SrmgBP+/i1YcMCm5weZc9i76WR5vFfLXLqdoNfNsnV
	MJn9yStbYMnaL8C4yyjCqRrU1O6V8ys=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="jp/3ZykX";
	spf=pass (imf08.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.44 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769128455; a=rsa-sha256;
	cv=none;
	b=WPMtnNGFqkJg5HIrXHPa93jvYDwL/FGPwOp493eZYkE/byaLoFkm64uBX8aznh3g44ARQT
	8On+JFkls8hugFcS0U59KqLyCH0+wLKbGlqyhxUXVU7OE45cmMUiGmJwNV2udZGHXYHCYc
	0/CqWsmwO0DAiPMYes6cf7KImJ++hZ0=
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-894770e34afso28728066d6.0
        for <linux-mm@kvack.org>; Thu, 22 Jan 2026 16:34:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1769128453; x=1769733253; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=asBGl1upDPy9EBtcWnpVXAcR6hW540Iv+SjDFfHMW0w=;
        b=jp/3ZykXaseg8Rw8Vs/dejIrXNQWxg6MD2ypJRz2SnAiSGK1rEJK1bgXj5xEKZp3gR
         KUuUBWhPFoiiO167w+djea/VyZRJmA2cIX9VQR8aQLQZjHX7o9JVTBqAmZitzxjIKeZQ
         y8ald3OGkXQ7K1NudqvHIQbtQMPmCYBEZlucm7rIGitEDRd4YABdl3N+ZKLdAK0J2oR4
         EPoax64MR81Snv6CqJzJOz43bzE5HgOcuaGPo4ufYHdzTafWnHyDu+KjwwmZzAEyYfHy
         Q8OY/I+d1J4Xho5QoNTdfYiuy0oTMANY7PW7hXyrevEzGdDdcF775uXsEGDxs5Av/AzL
         +8qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769128453; x=1769733253;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=asBGl1upDPy9EBtcWnpVXAcR6hW540Iv+SjDFfHMW0w=;
        b=aMJ2F1FBq2S/Q7C8748gKMJw+RJV1QbDQZbb5+LsgoD2Q2tPKWA7xHaZ0NbRtIo7V6
         vKDfGqzJhVlEGE16SECuyW+fGQoIhI/ShPolMsuRIhJm5qEKFptR4Y18FspRDqwFyrQ2
         To23CWh75fDX+P23cwXdU9v2uK08J59ibX89XA9DriK7lzxXEYIzB1IImvMu/btMSVCG
         62mYjWWxXlH7a8scWXNRqzBJRLzqs1I/8myGA7t/rQa5V+ymuiuAxxYRyh7SEayL9Mcd
         n7bgHMkTs5qGGUQYJCFuR5jE3TDts1E34TAWiHyVZ00ODC9neiSBXEQAqC1ghYRXJ3Bi
         4Fvw==
X-Gm-Message-State: AOJu0Yz7BmnNc9ddiLfi6UoetdzLzz7W8MMKTN1c3TQADPnnkAeNlzgU
	yAI1lD9vBPlCwbay/elqb547wPxqCXxDFiCyns3HWasqq7qJxdq5v7FdYe1NgI0Xbls=
X-Gm-Gg: AZuq6aKAeoEk8qCPugi4kGqdroaRZRHIGYcoUIhleLCFwS7rSQaswJQBXkETtee2xHc
	3xAl5JqS7730s4yc9AU07A6Y2oBzoMO0HJoJjTdETzVuN8hEo42pNl8OZ3/x5m2xRHeeKNZaL/E
	L78DEyJs6FqeGlm18paHAQ2f33dBk1n1Nu0GiaZKFWfNm9VJRpzmQadfhetV2Uie8A+HJbB7o/I
	/KPAW8lh0H5uUpfH///NN8Vkb9RXJHp+yxGmfxDyB5c8WZHAyxCDxWRaOujBsbmlr+22IKhv/wg
	tGaOBsCz2IaA1w9RXksXPJXkRJS8g1VTdt1SHqRAILw6887oFzVB/vOUBMrYcT3awELOfRAYiD6
	z/10L9ONHIT4ajJAlsF9QUvXWdS3I4cRtxX23nGAsD0QJeu9yy3ePwwOBaFEtgxbBc69TltKpWb
	AAb6KuY+TSCwxEM9ig3yC5v4oagBNQkgKVQG+eoHRdz+Hb+L/MXhjMRy9wLIW2sI7QHlgMoQ==
X-Received: by 2002:a05:620a:29c7:b0:8a1:b5ab:bbd6 with SMTP id af79cd13be357-8c6e2e369f0mr170716185a.71.1769128453428;
        Thu, 22 Jan 2026 16:34:13 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c6e37c71f8sm54022985a.5.2026.01.22.16.34.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jan 2026 16:34:12 -0800 (PST)
Date: Thu, 22 Jan 2026 19:34:10 -0500
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
	kernel-team@meta.com, dan.j.williams@intel.com,
	vishal.l.verma@intel.com, dave.jiang@intel.com, mst@redhat.com,
	jasowang@redhat.com, xuanzhuo@linux.alibaba.com,
	eperezma@redhat.com, osalvador@suse.de, akpm@linux-foundation.org
Subject: Re: [PATCH 3/8] mm/memory_hotplug: add APIs for explicit online type
 control
Message-ID: <aXLCAtwMkSMH3DNj@gourry-fedora-PF4VCD3F>
References: <20260114085201.3222597-1-gourry@gourry.net>
 <20260114085201.3222597-4-gourry@gourry.net>
 <b3d435d2-643f-4dad-9928-bc7fb5080181@kernel.org>
 <aWfR86RIKEvyZsh6@gourry-fedora-PF4VCD3F>
 <4520e7b0-8218-404d-8ede-e62d95c50825@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4520e7b0-8218-404d-8ede-e62d95c50825@kernel.org>
X-Stat-Signature: urg6icrhd8b67h1ja4gques38kjjq599
X-Rspamd-Queue-Id: 78632160004
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769128455-811513
X-HE-Meta: U2FsdGVkX18diPxUMhslF4C0PrytRF5Avy+BLshSdX8beqVrHfbpuSCcStEQReHpvUV5rWIDPUytOKAog0oOQPmtqiZn/KdRt9xBpUUn8ySglfQiWfhqLEwzDKqxSv+Q7Q0HhQ6vHksc0VC4S18Asf1I7rXutUxrlSbzsr4ukKdddrH+ikvbm09xlGEwrPNznVabIj95eqsPjF4oZP34zz6vZFtpeG0pentjvGNdMn9njf/qsDrwRJcc4mliqq33Vee7TQWYGsX0xXXKoiH/FDixcT5DIzBRwekrhokc6KKt1AeN4QwhsXxaQtURfaoNDm5wKmJhzZFIlWRcfGg5Wcffq9eo1QjWTf60WEDFl27puzWgPVb2yWwfO042wyrGs+3C9XRqi42k9KJK04EFEg9/lgEmzRuNn2m4W2XXjzIXW03HHUHyuN4LcEOd6vtrQXcTgaC1lijBNQ46GDUU79FJ31J47TsK29mRzNceCu0FmVOkpUaLymTHra28j3DV17/qqOSiBCCjeMKtsw0xOrO1B+5aS0ZuIXagZqQNl9PvGaSJafFTuSqq0jdojQ7genOtRWrzWi2rPCKtgs95QGUlk/pGCJKKCeniTugld2TRW1aOKechiKeN77gTJt5999hPHp8D1ZKqfbX2FvDXNQOyxNGkYUcIItFS8RQPJy1l/BJjIISD90L3y1JQaV2mJvK1XKy5cXxWnIhoXc5gCQo6PbAndN8eYY7k5Fp7LTPCU6ba90BrLB+lvmSwhYkSTvvLFzDiN0W0SZrJ6ng/xY1FncZwH6UPyj6GwygIdA+OSVTK0ttzhqW+Qtwcssx0smhsicHsw9cKeiDS0viGT7cll8qq2OcJOxAzwXu4FDUYYIMhDLb1rGxNmZmFipeHsZakIoCSswCC9aDYsq8uz+dg2JAbRmKSgMb73AblhEH4gWisNexqP49wKnMNO8bldEfaAuREvNGwaDrklp6
 yUO0zXbr
 BWnog3ka8N9Jb3TdsBk8mYWtDolSkenNsHOJrZEY5EYhaHPigZSS7mW7vTREWJdR8E+6xsnricjWJAPmLHXTbw7ZlEhkxkbaph8a8WOuCP8Dd9kZSCZJUygsjZJIFk1oUMO9Sbaxweh4jQl3WZoa7LSaR93DLDfe90wztUCMnbnabCMkvJpcQ/+RQ1xqFfkiF8CdQ4a7VtINxiM5hH545O67YzmXgGHSYMwc/j1ujPpHu72g+7T6IBcz31xjctYkbV3JJgr1gSlvkRhxRCv+kClYSW4AfzaXCI4PtpmgOK/J6OWa4DNeiMeW9CTDx7O0AAASsR1dy3x4AQ1Twd1c+IZ5pr4AQew7ZrGgVCiw/MAHcYOlK6d8giXpENw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 22, 2026 at 11:41:24PM +0100, David Hildenbrand (Red Hat) wrote:
> 
> Right, but I don't want any other OOT kernel module to be able to make use
> of add_memory_driver_managed() to do arbitrary things, because we don't know
> if it's really user space setting the policy for that memory then.
> 

Ah, this was lost on me.

> So either restrict add_memory_driver_managed() to kmem+virtio_mem
> completely, or add another variant that will be kmem-only (or however that
> dax/cxl module is called).

unclear to me how to restrict a function to specific drivers, but i can
add add_and_online_memory_driver_managed() trivially so no big issue.

You'd be ok with with this?

add_and_online_memory_driver_managed(..., online_type) {
   ... existing add_memory_driver_managed() code ...
}

add_memory_driver_managed(...) {
   add_and_online_memory_driver_managed(..., mhp_get_default_policy());
}

~Gregory

