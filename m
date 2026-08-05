Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DCBAC55822
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 09:13:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CB016B0092; Wed,  5 Aug 2026 05:13:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97BAA6B0093; Wed,  5 Aug 2026 05:13:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86B176B00A6; Wed,  5 Aug 2026 05:13:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5C2056B0092
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 05:13:04 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DE1A1C03EE
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 09:13:03 +0000 (UTC)
X-FDA: 85066651446.23.095FD7A
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf22.hostedemail.com (Postfix) with ESMTP id 243F8C0003
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 09:13:01 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HaxB1M5Y;
	spf=pass (imf22.hostedemail.com: domain of adobriyan@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=adobriyan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785921182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZNd33VOa+JwOWtsPBLxmQElUX5jQqkuPC06k85UshRo=;
	b=aEOee7QKZk9BuXugAWatM6OnHAQS5GNVh5WwAHlcx2luW+yxF0phgUWB3UJcw2/6c2/53f
	OhIKNJmiDIQ/qlh6SC38AQYd27HOoQu6+s/AWnwqA5xrQ/ilDMUQEtuqzOCzQuEROY+56M
	ocS+o/C/VifVW/W8eOAr7u9HLZeJcp4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785921182;
	b=WRZ10Sfj4AIwQCEZrv7iJwSsQGDvC6qJg9NEtiWQdFoRrzZDq3lMMtSbWcDQDoOLOxU+qo
	9DbZkjYiv41vWnbn3ehboCZ0bRq9I2xzctxdHY6NrRTsmhfGRcnaEzlm7ONK/2UyLkHwdx
	JsKYMWj1/Q9eFKuzlWBb+AjK3tCKGVI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HaxB1M5Y;
	spf=pass (imf22.hostedemail.com: domain of adobriyan@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=adobriyan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-47f9ab7ee38so363172f8f.2
        for <linux-mm@kvack.org>; Wed, 05 Aug 2026 02:13:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785921181; x=1786525981; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ZNd33VOa+JwOWtsPBLxmQElUX5jQqkuPC06k85UshRo=;
        b=HaxB1M5YvMBcBgGOOnizm7bSJWl5uWdhYkYfjlj7MmdIfp7Ev/HYVOoA9Lv3Ki/3rf
         rjh468AstxiMyCPpwum6lAT76rp1nrCF3GtEJMp3fTamP9wnmfv4IMlGQwwra5cYqL5T
         fm1fXyEG7o2aRrxmHLB6N3jz+qM8d1PKQL5fgpyZ1Kj9j3mQWPZ05zNaWYsNEGpTLImf
         TMz5Zi4a+U5LNTG0LPtR4C7NsKPDZd/yOBOIMPoVAAM7kW2Qfs1wKeWunfZ6WzpSCwKR
         pVgzrk5+O6IOTAdU6bdD/kVTOy44Lniy9f5L90RvVWsJ0fMk1gp09xfyd68R8vSoCOMZ
         YY3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785921181; x=1786525981;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZNd33VOa+JwOWtsPBLxmQElUX5jQqkuPC06k85UshRo=;
        b=Gk6fqSxN5SYwH1B13CnH6z+6/5aEH94xaQ+f64/WFPRrWSiu+HE/s4vWcX8F/G+IOh
         s6ps8yTnKmX3pgEtRcFNuMYB1pIoGdWbp6Evjn3nvKWF5oca4Z/d4f0AnIRlCyp0CAEs
         hF5kAa47jHr392dhkBVnxULXwSsrjauVmBRyL9yqo9AcXBSd8Pf94Rp/nUTfDAVnApzW
         zaSNbqTfCH4PeszNHqG8KWFzq+oSRrhszmo6X3Q4u3FFzLXZsLAX/HqDzI0vD1Z+/oP2
         +3D2Gz2roJrvTCQl8nWjOre1A+FzNh5uS9aut7VIMZ6LubFnSQA0UiajSf85k7wR65uD
         OmNQ==
X-Forwarded-Encrypted: i=1; AHgh+RoIFYAQZxjzGs4nwGOrixujKW7AptYzBK9va5J+raShdqcVplGzo7C5p8oVYS7tI2P2FYzwnbumcQ==@kvack.org
X-Gm-Message-State: AOJu0Yw4WIR6RllE8ThxjtCn/y2T3Bxw0qOS83X02e3i4LqNJTpnJ+3J
	mRNtJJv4owjenOxOp87rPOR+HUAiAXmkSb/uOu42O5VDLhRDvmNGVl0=
X-Gm-Gg: AR+sD11l/qg0i4rISy/976+AhWRUM0ApHhGws+RIbxy+2PmqZ4w/XAkyujdyAIERUTD
	OARFUcGLQShl8oJESUXb3mevlCcZcWUg2WayGOnnk/cUGwIx2QQmGqKEmJ5egClm7GLv0XDu6t/
	Sf4luf2YKpDn3Urdnm/MBffoI4MieYUhg3VMS9cTg6V3jtRbrbuSUkfPzmIKhZj4eJUEsyl/ygv
	4pK4gYaAeL+cMUFGXnfTPT8GsZuC96Xpba9NQ1zJkFw+YNZXb+7PZuSZaVq9nPmDIbt77hjsXV8
	EBtZ9QTKWsAJ8kUGRpZIokW4pkZ4Gl2dcb1wvyrLDgpCJwtT9+Dcv9MGnr+Bqmp8w2vBlpyuEsO
	agtqYcidKyMSgL5+OoUr+F7FI4E6M+ik/q/X+vxayy2B+mvtCtAxcGxpqqkhL2GmKV3OjSy34o3
	ph/vM0GKKS44Q8T8bUszGSqZusKkbJq7A8N8Bcy/nCkV7D9OW7uZTQq++GNwMHrYjU+VfNXIJnZ
	E3CsspfERaPuUnyt6Sfgg6/myEjtPqFwOHP/X4quNk=
X-Received: by 2002:a05:6000:2995:20b0:47f:959f:f69c with SMTP id ffacd0b85a97d-47fec512853mr7202215f8f.7.1785921180751;
        Wed, 05 Aug 2026 02:13:00 -0700 (PDT)
Received: from p183 (dynamic-vpdn-brest-46-53-134-148.brest.telecom.by. [46.53.134.148])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47febfd9f74sm7450823f8f.4.2026.08.05.02.12.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2026 02:13:00 -0700 (PDT)
Date: Wed, 5 Aug 2026 12:16:41 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org
Subject: Re: [PATCH] slub: print just the function name in
 /sys/kernel/slab/*/ctor
Message-ID: <0a88d330-54fe-4e71-bb92-f8c705c17881@p183>
References: <456c0a37-9074-45b5-9be2-a5f2fe345400@p183>
 <ee600151-85d5-4cd2-922c-d2d8df21878c@kernel.org>
 <73d28cff-77f5-4cd6-888e-5dce5ebae459@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <73d28cff-77f5-4cd6-888e-5dce5ebae459@kernel.org>
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: nf99iang96f1pkyxxu1hkq478cs9iz4k
X-Rspamd-Queue-Id: 243F8C0003
X-HE-Tag: 1785921181-726284
X-HE-Meta: U2FsdGVkX18zREj/doQqUpEpFwiuuDcVdIVrYQey+3+7DXbpJAocmGnAFHW0rioEeRj1h0QXxe4Gq6tE1J/PavjDId4pc0S/Cv2xkjH9UtTU9bDj9x5kR+fWW+yTrvPozErk9ml9sBG7GAUBDLC5FDya1URzqBAOjyMHtVhvkKlCzWAwTJftUekrE7c5UQTlQ/SUnkIDmpmH+aPr0fTFlGVHeiH7uK+QlFja7uqyrOhyZixV2iHeoqTN4yB13gpZ9xrhd5Xf1rpAenkgajAS9MNZCdlef3DRAuC5uvPKPzcnPTtmz3U1jx/ACudypRO1G4SRhdOpxTNuBEbR+Q8VgIpSc3RY/G3C/q52jdHErPJv5riCplPGBrCPEdBqfb+l1H1sEN0Wj3eYG4ov20eE932ifnmpRg7L1WNxvkW0QazUochMnMi7EN537sIEBdU7IcoYRtkWDZlKTNESjYPWjbnLzTcxXB9Q2+ggTFwk++9nT2HUt30AlBqJdVPwzIDHPvH2/OLbAQzScOPoer/wxW0e1tgoUp7qY//j64eV87TwxoCKk5+DB2GfsCTUapLZuska41eiFLMQvyPl9LyH0zwwmausGuYkPKAfFFQRggZEF9fCXAHtNbHJBuSJs5chqmss/s3kdPntZQoOhGCo9a6N7W1eDbOL+snVy5nAnVvuqxXltyv100gTXeh4GszIrK22iGuWYTlnE0wUEu3O2tmnOAK8JNBP9gCFrT15MnuQvk8DXX/830X4FS3aFaY9Sor/V2SgZ6ZpUZUB9mH1nAFPTIsVoeAVlHAke4iQl7XyFB+bUyO9+QtvhHPx/aR9IVqOZ1Vt/2FmgsUSP9GWzzMzsnqqmJg6t4dNu64uyWZOaqY+sEjpqRTotikrwxpt2ZD+uNlPoLUvZdaYvRh1g60JIDt6HZfgUDLaA/GPXysoKYqAkzIyYuVQ6X4OrJ7kBxdNIfAuurbg9L7H2NY
 mVshp4Jm
 NGKr4yijD2W0sDHDaGowlU0olBRd1Lm3OZunQBhfE+MnbRgK24+lrO0FB+2Cl9Td2yeVL6b0CsQCeV5whyJi9sEu7KA5itbQ1ZPKAr2iqe7zPb75KdQP2SM6wBC6P7SU6D7U8jpQIG8yqf3QixSBLj6KlohwJHuuN92Rq882oKHFMwkJp9Dy/18KD6G7RCShvAYju3YHpCypeKfR/Oh2kDQ7KkdXThC6GE0p7mzRqlExJwAOykNXQIpsYoDHOK5fDmHh6JqAw+d3GN46m3MmYDMqemzDdiBo3ED9RUw8GaVlAFu8x94eAS5CHDZ35Za09ZtdMJYsma4pyLvDm+qtaFXpxYtHlKIVueGKFa5VBeXY/9J6EYHU5Do4ff+AASvhK+tDHOCkbqSlXUWmIiNMYRuL2ayx4LuQVEXtQ6MPaIryRcPkTscVEeakWe2fNPTri+zd0PvGWnit8yw4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 30, 2026 at 04:15:26PM +0200, Vlastimil Babka (SUSE) wrote:
> On 7/27/26 07:27, Harry Yoo wrote:
> > 
> > 
> > On 7/25/26 10:28 PM, Alexey Dobriyan wrote:
> >> Sysfs "ctor" file prints offset/length of the cache's ctor function
> >> 
> >> 	$ sudo cat /sys/kernel/slab/bdev_cache/ctor
> >> 	init_once+0x0/0x10
> >> 
> >> This is not useful:
> >> 
> >> Offset will always be 0 because ctor is a function.
> >> 
> >> I'm not sure what ctor function size is doing here, it should be in
> >> /proc/kallsyms
> >> 
> >> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> >> ---
> > 
> > I'm not convinced that changing this (without strong justification)
> > after exposing it to sysfs for 10+ years is worth the trouble.
> 
> Agreed. It's a pity this was exported in the first place. I can't see a
> benefit for anyone knowing what the function is called. Should have been at
> most a flag whether there's ctor or not.
> But possibly a justification is not to leak the function size, which might
> be theoretically (although unlikely) a hint to some attack.

Leaking size is a problem for custom kernels but not a problem
for distro kernels. Original format can be put under CAP_SYS_ADMIN.

> Well at least if somebody complains about getting broken, it's trivial to
> revert and we can hear about their usecase.
> In-tree tools (slabinfo etc) were checked to work properly?

I tried to google and grep my local git collection and found nothing.

> >> -	return sysfs_emit(buf, "%pS\n", s->ctor);
> >> +	return sysfs_emit(buf, "%ps\n", s->ctor);

