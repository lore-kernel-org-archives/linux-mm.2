Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1FC9C47BC4
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 07:50:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 163A66B0088; Tue,  6 Jan 2026 02:50:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 111716B008A; Tue,  6 Jan 2026 02:50:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F294A6B0093; Tue,  6 Jan 2026 02:50:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DB39A6B0088
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 02:50:27 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 885FD1B1E6
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 07:50:27 +0000 (UTC)
X-FDA: 84300766494.22.F876C1B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id 291ECA0009
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 07:50:24 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UYKQflH1;
	spf=pass (imf15.hostedemail.com: domain of coxu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=coxu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767685825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iJIbYSfSK52lKhhoL+Hqgsx6BnLJaDz2mdyD5+Wu3vQ=;
	b=o10OUT79kqUoB2gOmKZ3rjLyhS02RpWE8mj6vglVKsjVCu8h8bkk+K2ttm6iLc/aUgU4rQ
	S/vwp+rkShVZnVcDhy/K51jOs1yZ1jLgb4CHMW/xnVJ3WzeZgbmLqAiMev45rSl3azuwre
	g0jp5bmTv8qT6x2uaSRn1h3zWvTz6tM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UYKQflH1;
	spf=pass (imf15.hostedemail.com: domain of coxu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=coxu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767685825; a=rsa-sha256;
	cv=none;
	b=ZI0xS06XvYkBZHySRs3y2eabdDznXqxv1Oia2AB2E0DjjqCVY+fVrGU1sYXL6NyLosm7PX
	HSdXJUqHlcYCTFfX3//2arqKv1g3jHTyIqI9eh4+nroPgAPNTKHe3f/IZ/htcqtqak+jXy
	HPt2bu74w34z3dU3pOlVNwq/Dk2e4wA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767685824;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iJIbYSfSK52lKhhoL+Hqgsx6BnLJaDz2mdyD5+Wu3vQ=;
	b=UYKQflH1BcelkAhgGHtc4xMkD9EvXMsO0CA9heSHIv8bh1jxpzXDP65Qhx4YorgeRu0Qnz
	o9C1EcZY34WWB+rL/5v11nrli3AoH11VWsJY8MtMIYGATC//iXCMnPJWxpa+sGFFOHMl8K
	uf/VGTU6ne2YjQI94+tKZYPkMKmVico=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-287-uhK6bPv5One1iN7yhLV8pQ-1; Tue, 06 Jan 2026 02:50:23 -0500
X-MC-Unique: uhK6bPv5One1iN7yhLV8pQ-1
X-Mimecast-MFC-AGG-ID: uhK6bPv5One1iN7yhLV8pQ_1767685822
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-7ae3e3e0d06so675682b3a.0
        for <linux-mm@kvack.org>; Mon, 05 Jan 2026 23:50:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767685822; x=1768290622;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iJIbYSfSK52lKhhoL+Hqgsx6BnLJaDz2mdyD5+Wu3vQ=;
        b=M33UYAm5s/EpPqyK00ijvFu4PmpqekvrkGynPHlKgvVl/CVumkoda4ebE5fYyPzhTq
         vsk9XSDspbh4E0BN9fbtsandSZvbr2PQH1ntPu6Nv/hYiCdltaAgQnQasLnI44BNh+OG
         o1MpCYuTeVZhQxKhGDmRjDGNHrqZz/wrM2GIie5d9wqMp+V3flbtGG9Ftj/ha1q2vi5v
         s/8KgJ4PtWQ6BIDLp3dJtCXs5jqksESuo4Xl7V2eQycirKkrEAALFaD252WNWMUgJ4UC
         2zPyVE7ab7jCM0/Vr6HqRmqSwg9KKbNUIqNB2Q/koyYPSbId8I10pa0yuINKeDMuAB4A
         l7fg==
X-Forwarded-Encrypted: i=1; AJvYcCWuBbNwbBcWBEF1eaFfR3b6pkfwGpRrwc1CQNHdOkHgVJVdrVh9CvLTvrpAi92tpDxqjccX9m2goQ==@kvack.org
X-Gm-Message-State: AOJu0YzKiDuVlN5o3iGlx8me4gtQnd+fLndASHCZIrLesonb1Mf/lNKQ
	gK8SOAUSBAWkJxU4Yhz51AExfIvG7blsKfqNCcWO6y4UAGEkDvj88jFQByuAD3K88RINBolKGzg
	6xbFKACl4DdNsZyPD4sGjUOCiD+l2WZBbrL7BMWHojL/COK+xcsEw
X-Gm-Gg: AY/fxX4REpmVI3ecdS+BWthndRAg7SJfJBkw+6VoMed4p0Sy0crRwJW2RWGsuOURNDn
	6sRVt0/EvJh6/yF64lWJCH5mzs4L1EVuIZNBt9X+62MWuZgcxzcJN7C5pf9FsLNpeBhzdkg6gQD
	zlmhb6uKccD7DEeteXLtMwuXEBDBTaR3BUchJ1yzvIimQkeYBrGnea8/dar5yUC8PvHvXQ9pbYC
	UaKfk7e1MryDRPYxZtw4QP4eHY3zucnOUtDZRq+tlhb0GoxQsXW1snDTLtGID7GBDFplAJdKsWL
	8jmIqWBKlkds5rFlZ2r+O7snx+GG3zoos/j35tt//KzrAUlLgX6uh1jh1I8gXz3HfFWXVG9TYV5
	p
X-Received: by 2002:a05:6a00:1d25:b0:7e8:4471:8de with SMTP id d2e1a72fcca58-81882ddd7c3mr1845194b3a.63.1767685821884;
        Mon, 05 Jan 2026 23:50:21 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFDKsDXMRpPACVaN2GdRV6l0Fy6KDBpzSzhtqSYzxT7W76UAFruKAKNIbDHoNo+0oE4mtloEg==
X-Received: by 2002:a05:6a00:1d25:b0:7e8:4471:8de with SMTP id d2e1a72fcca58-81882ddd7c3mr1845179b3a.63.1767685821335;
        Mon, 05 Jan 2026 23:50:21 -0800 (PST)
Received: from localhost ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-819bb0ddf97sm1263404b3a.19.2026.01.05.23.50.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jan 2026 23:50:20 -0800 (PST)
Date: Tue, 6 Jan 2026 15:46:57 +0800
From: Coiby Xu <coxu@redhat.com>
To: kernel test robot <lkp@intel.com>
Cc: kexec@lists.infradead.org, linuxppc-dev@lists.ozlabs.org, 
	llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, 
	Thomas Staudt <tstaudt@de.ibm.com>, Arnaud Lefebvre <arnaud.lefebvre@clever-cloud.com>, 
	Baoquan he <bhe@redhat.com>, Dave Young <dyoung@redhat.com>, Kairui Song <ryncsn@gmail.com>, 
	Pingfan Liu <kernelfans@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Linux Memory Management List <linux-mm@kvack.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc/kdump: pass dm-crypt keys to kdump kernel
Message-ID: <aVy9qfeSDZyKybIC@Rk>
References: <20251226140636.1378505-1-coxu@redhat.com>
 <202512272218.ghBaSjzO-lkp@intel.com>
MIME-Version: 1.0
In-Reply-To: <202512272218.ghBaSjzO-lkp@intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: zY-BfWb9-j4ftFbK7KPOh4kQ-a5Fd4MFSbS4mAE4V6Q_1767685822
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
X-Rspamd-Server: rspam02
X-Stat-Signature: 85ehy6bfhjysqyof5cf7qqh1hasntuof
X-Rspam-User: 
X-Rspamd-Queue-Id: 291ECA0009
X-HE-Tag: 1767685824-605387
X-HE-Meta: U2FsdGVkX18ELvW1MJW5DxBWn3Dq/s0LIFAUu7seDSpS8ALfHX5Qd5fmibFO8ZEgR1lU/G2QgAuT9JqLpEtQDepHZBD/0GcoTfKw4cZjcBfco9Q7E95+UmqWZ+grjJTH6ogv9cz9mZr/Unp2Y8CuW1jnFd6UvSuw3t3+jklV3Ur8Ckx3PVawAIHHRupBfjPrOHViLUItPQi3b3gxG9x/fP04mogUiuOv1d8XpSTclI8N0x8tMjaeb9no/EVnhQc8vgWgRBNphfS3rB28D26m74tcQ2mLfmSJw+WVUnXGNsUjcdFHyN69+vKw/fnk+p8pFg8SCHHE2bM45Co24tu2qH4XZXep7D5MwQtDK6pFmxY2MwJ4Zx07jyG+VBldbADwRfCNW/7+Lo+bPFjCKhnWycUA/ZYq8gpQ8yp/i05fcTgwdozdfu8Nimt5TMkUhfPd1cCrpf3o1s3mL6UsH+uNvNGJQBz8a66hxkUFv8a3fCP6FfFN+lVbZ0fbGpc0OWkrBGIKXIlkDs0avlEHCCkVrM8gNxhpb9eswZzKLi/bd0JaAPy/3Cbg4JEiEa98wcYV4dcIGgh2S/S5UF4rrkkl7BhECJpv+e9Zf91rTIi/AlhJj+UsC0CbIXl8YhsCMh7r0viqpIOmT3b2kym618mggy0xasNZACb+v7mgvA69i3Ca/w2/pqvQ49UWZXLQYcQSBdyswvIzqiTHyjogWaSODgyBKQM3TbCuCoesW1rre26KUd9TciJubkyGm0J8d5dEqedEwYjsYaYr3WWafvd26x/Z79FB5auuGHN53R7x/nXZqpbgS2zHAprZUj6AZVM7speH84DF0s4eI+ADJgcblHoxHdmz6j5FMhSMcKOCiIaoJ0euPKYyB7txfa2jxjgpOeDNODZhicJc8uQUwPV7KkvBxaXlcC6MKKXXHzvW5gzyzO8Ha6Awc2+lf0/3AJhyY1XEHfPSkRBOwyW9vtU
 O9EEnEeQ
 +vfU36B5+3ittTBAG63yJGC3ZSEwFHcpJ0/4p7W4Fo2VzDqt9trZfWOp11xE4Y/YHFYLcxBnwb95ebz7y+t5r0awc9NrCSy2cVvfp2zlBb03Y8Vp0ztmaZ5jlJo+sAV7KcW3BDq0Cg2Z5GGLl85K6pyQWorDq+W8Vax5DOip3Bg5UghDhvj1mshWVXPEGXj1Gew1ck19ASiTZLK1flGlcj5Y+G9yHPFVBN6E56UG+2lvSc4fbdwoK1HPuF1huiVhlsK3lhamv908i3KQXeTM7kZhaaUslBxxyWEfVSUdT3XNURGSX0Rk6FaqUdP4NOsg8KlX085EuUb+Jx/OhfZkmsHOqXqH5+uW8l4SO2++V+TgdvZ+rW7c+4mt35ur0k38NbtZ5fFWM5/05VcsxUoF/QVITbUzN9aiC4ftTBEnMECOIvyCS698LSzOhdAZC2HRlMZ9DwoU49zDKSl/oFFtr+2g69fOJzh64TwmDQQ9e2KvxvYoCf9VIrjZ0h82eOWqk8bZ6ZaaxPOhwka2NJ+rPE87sLwar2hN5bql5SpCawv365rQ56H4WLUUrWIhW5EW8yPz5rgwlIzKcUhxLY8suwm5U2OhOXajGhPbxULQIbwgqt6HkdqggSjuEObjvmFOFJ3Uh6iZBMJQyF3fqv34kEd+ha9bdIIDDMu+cmURvLfidsZD8M6NJyWnNWllbucoxLS+yi9lhpjat9/I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Dec 27, 2025 at 10:35:11PM +0800, kernel test robot wrote:
>Hi Coiby,
>
>kernel test robot noticed the following build errors:
>
>[auto build test ERROR on ccd1cdca5cd433c8a5dff78b69a79b31d9b77ee1]
>
>url:    https://github.com/intel-lab-lkp/linux/commits/Coiby-Xu/powerpc-kdump-pass-dm-crypt-keys-to-kdump-kernel/20251226-220726
>base:   ccd1cdca5cd433c8a5dff78b69a79b31d9b77ee1
>patch link:    https://lore.kernel.org/r/20251226140636.1378505-1-coxu%40redhat.com
>patch subject: [PATCH] powerpc/kdump: pass dm-crypt keys to kdump kernel
>config: powerpc64-randconfig-001-20251227 (https://download.01.org/0day-ci/archive/20251227/202512272218.ghBaSjzO-lkp@intel.com/config)
>compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 4ef602d446057dabf5f61fb221669ecbeda49279)
>reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251227/202512272218.ghBaSjzO-lkp@intel.com/reproduce)
>
>If you fix the issue in a separate patch/commit (i.e. not just a new version of
>the same patch/commit), kindly add following tags
>| Reported-by: kernel test robot <lkp@intel.com>
>| Closes: https://lore.kernel.org/oe-kbuild-all/202512272218.ghBaSjzO-lkp@intel.com/
>
>All errors (new ones prefixed by >>):
>
>>> arch/powerpc/kexec/elf_64.c:95:9: error: call to undeclared function 'crash_load_dm_crypt_keys'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
>      95 |                 ret = crash_load_dm_crypt_keys(image);
>         |                       ^
>   1 error generated.

This issue has been addressed in v2
https://lore.kernel.org/all/20260106074039.564707-1-coxu@redhat.com/

Thanks!

-- 
Best regards,
Coiby


