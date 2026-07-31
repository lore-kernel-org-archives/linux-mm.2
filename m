Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECEABC55167
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 06:53:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86F2D6B00A5; Fri, 31 Jul 2026 02:53:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F89D6B00A6; Fri, 31 Jul 2026 02:53:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6990C6B00A7; Fri, 31 Jul 2026 02:53:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 283D16B00A5
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 02:53:54 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0B654C0277
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 06:53:52 +0000 (UTC)
X-FDA: 85048156704.01.C189A03
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf01.hostedemail.com (Postfix) with ESMTP id F1ADA4000B
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 06:53:49 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=gl0DztiY;
	spf=pass (imf01.hostedemail.com: domain of jgross@suse.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=jgross@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785480830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n4H77HhyFq+APQR29K1dkMr3hRDR1FB0yWjCqMMi42Q=;
	b=2SPZ3vElr+NFg03xtrLwKHKbckZyUzPzG73RQD+3ZqJPEFTQZbhg8ksTdAqQf4mIp4LFsG
	shUrWUYPc8ivP0lEsednXkad3uai+whBHqbKfX6F7szaZ677iWNT5cZmx4iH3DDOdCqfta
	3QT8X4In/5lZ5kScKl8yIcZcIZbLgPg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785480830;
	b=qNIRkB5TVc3TCWjd8Ifu6AzJdRgj7ZyVDDNokZIt9lbC232NT6EFUACbI7/rFJWMNLCaCt
	QxgHynFBp+NaayBEjLUvNoOgfYluWO/QQAJo9TfOV5u+MCMuL4janx8tqr0Byd8rf8qUGd
	VLJYSpDyFSqUcl7zXtQuk0a5s3jU8sY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=gl0DztiY;
	spf=pass (imf01.hostedemail.com: domain of jgross@suse.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=jgross@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6a097f5ab95so415141a12.2
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 23:53:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1785480828; x=1786085628; darn=kvack.org;
        h=content-type:in-reply-to:autocrypt:from:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=n4H77HhyFq+APQR29K1dkMr3hRDR1FB0yWjCqMMi42Q=;
        b=gl0DztiYYioB5oyDZtXYuT3saC6yBqaNR5ERgADynrNNCenXQ8Z5g7W3X5XCU+Pc2U
         bbCf/gw3BDlVdz5PYTl/WwVyRuDPAaUvPyy+rIHDY2AOA5AFOBOvwmRbGPUF+QTSN91o
         viTIQDvI+vtFiqc3lQTXqIedNUeFC1EzHW22Xjg+Wi+DjitFszIyzfnj4BpL2WLOo+RL
         GMYHHv//pjWZotrHPHX1PNK2IDNRg5ENtCdpyZvgc7qw2QCpUAY///ioErxGV2qKskQb
         MlVFKLTslg0vTUcTUXCFJmfK3Iy3AfcQp0p8huo557HPndN7Yxj+irjra6mfmeSKtrKE
         G3nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785480828; x=1786085628;
        h=content-type:in-reply-to:autocrypt:from:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=n4H77HhyFq+APQR29K1dkMr3hRDR1FB0yWjCqMMi42Q=;
        b=j5XsAXPnWvQWvZtensFTN9gulxM3wtDSazizPjQ851benQNHvATfUjHVW5ZGWXlPvu
         b1/iOXAXHGskxwDiQ0vmDlxqNmHQS5aayIOJVSupcZqKPk6YAE2ilz6tFrJwq7xaj/Nl
         T+KTJi2O90+ISqKATob5czJYpHJDmNQ79YmV9uFcpn3sELzxqvDOqhYg3m3Q2zJ3HGxL
         auDSaXrPs1POIDIyw6JhhS7Lrt26rPcmZWLZUg6wEMRt38HEyrnJNLGg1R41zbaj2sT4
         uRvE/q2bKHXs9G4JNlm/eC4fWe86dDYiIqr3KsoLUWv+zBUOYHmsumUasKi3IHwg6JeS
         2LJA==
X-Forwarded-Encrypted: i=1; AHgh+RrboVkKO+fXSb51zPhl66/uKi6sErWDB1Hz/W8C8wNiOymcxEem8qkvFiADDlJGvK6vPpROPnoSWw==@kvack.org
X-Gm-Message-State: AOJu0Yw5En5FfdM9kpmeRxfkN/hj17I/CeAdEFti9wSVPSdYqv1lEwDn
	DYap7B+2GtpXHTzW/FSUXy9mexMYD8oTPZPnQ24bcueR6KuWlwq54HYrpmCBz37LeQw=
X-Gm-Gg: AR+sD1133CNuphZBCGzTK43SebYdDN0NFIJASO/t7ytbamm6K/aMGIk1SLwfQElUzf2
	I0w9b6+K3YWe4112vR35v502ck3M8uj9tpkGUxPaHruGbTZIyTvTKCalnjDQydF6PJ2+t3j061H
	0xYKdISxISa0HN/zekj5bR6wafPTJYxvW25v/k+Mb6hl5mzgSwy1/VH6axhJcSQtUz9P5pQ3JL6
	EmjrkvGLL7z+I6BOxEO4eNu4be2soPaVf6zhLXN6cF6ftD3vx/jd2OaJLQKbBZiYHG6UXwlW8TJ
	/vnYU6jaldXL+YDEAjuz47Kpf+VxEk3ZFID6fa+VsWlO+8oA1SyKRTNMGgZqE9Rov8ppD/BkbgQ
	3Mp/w4MhJPMPLe7RUkUkdbUo1zBO/A/Jpa5CEjPT+BNTz/i7sbT/WSRoFj0w+nex5vIDIkyIhXi
	FLG+dSoDVmQiwx/LMmSaukW9yR0BKGKhyvKRSjngSoPC/FY/UnydeBwkSZX1A2L90bp8ajfd+UY
	eW6DfBEG4uPhZTEeYBYufS6ZMic54fBrccT0dw6R6z1emQZWJTTwSfGuUU30sh7TIdRr+0bsJ6U
	wYueaxPL8kZcYuk=
X-Received: by 2002:a05:6402:1598:b0:6a0:4777:dd70 with SMTP id 4fb4d7f45d1cf-6a098d1a47dmr407946a12.38.1785480828368;
        Thu, 30 Jul 2026 23:53:48 -0700 (PDT)
Received: from ?IPV6:2a00:12d0:af5d:ad01:5d3f:14e6:9bcb:5112? (2a00-12d0-af5d-ad01-5d3f-14e6-9bcb-5112.ip.tng.de. [2a00:12d0:af5d:ad01:5d3f:14e6:9bcb:5112])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a09c660f6fsm300735a12.25.2026.07.30.23.53.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jul 2026 23:53:48 -0700 (PDT)
Message-ID: <41414c5b-e98a-4a55-ac87-ca982b248ca3@suse.com>
Date: Fri, 31 Jul 2026 08:53:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 01/11] mm: introduce hw_pte_t for PTE table storage
To: Anshuman Khandual <anshuman.khandual@arm.com>,
 Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin
 <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Dimitri Sivanich
 <dimitri.sivanich@hpe.com>, Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 Helge Deller <deller@gmx.de>, Stefano Stabellini <sstabellini@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Will Deacon <will@kernel.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Nick Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 David Hildenbrand <david@kernel.org>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Uladzislau Rezki <urezki@gmail.com>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>,
 Eduard Zingerman <eddyz87@gmail.com>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, SJ Park <sj@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 Miaohe Lin <linmiaohe@huawei.com>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 Mike Rapoport <rppt@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 ziy@nvidia.com, pfalcato@suse.de, agordeev@linux.ibm.com,
 ryan.roberts@arm.com, linux-kernel@vger.kernel.org,
 intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
 linux-parisc@vger.kernel.org, xen-devel@lists.xenproject.org,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 linux-arch@vger.kernel.org, kasan-dev@googlegroups.com,
 linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org,
 linux-perf-users@vger.kernel.org, damon@lists.linux.dev
References: <20260727164715.2866609-1-usama.anjum@arm.com>
 <20260727164715.2866609-2-usama.anjum@arm.com>
 <6xah74eadjmo2bozyr62wcxo4hhpsiufx2mshh7tztyy2dzzps@63m327m7pl5u>
Content-Language: en-US
From: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
Autocrypt: addr=jgross@suse.com; keydata=
 xsBNBFOMcBYBCACgGjqjoGvbEouQZw/ToiBg9W98AlM2QHV+iNHsEs7kxWhKMjrioyspZKOB
 ycWxw3ie3j9uvg9EOB3aN4xiTv4qbnGiTr3oJhkB1gsb6ToJQZ8uxGq2kaV2KL9650I1SJve
 dYm8Of8Zd621lSmoKOwlNClALZNew72NjJLEzTalU1OdT7/i1TXkH09XSSI8mEQ/ouNcMvIJ
 NwQpd369y9bfIhWUiVXEK7MlRgUG6MvIj6Y3Am/BBLUVbDa4+gmzDC9ezlZkTZG2t14zWPvx
 XP3FAp2pkW0xqG7/377qptDmrk42GlSKN4z76ELnLxussxc7I2hx18NUcbP8+uty4bMxABEB
 AAHNH0p1ZXJnZW4gR3Jvc3MgPGpncm9zc0BzdXNlLmNvbT7CwHkEEwECACMFAlOMcK8CGwMH
 CwkIBwMCAQYVCAIJCgsEFgIDAQIeAQIXgAAKCRCw3p3WKL8TL8eZB/9G0juS/kDY9LhEXseh
 mE9U+iA1VsLhgDqVbsOtZ/S14LRFHczNd/Lqkn7souCSoyWsBs3/wO+OjPvxf7m+Ef+sMtr0
 G5lCWEWa9wa0IXx5HRPW/ScL+e4AVUbL7rurYMfwCzco+7TfjhMEOkC+va5gzi1KrErgNRHH
 kg3PhlnRY0Udyqx++UYkAsN4TQuEhNN32MvN0Np3WlBJOgKcuXpIElmMM5f1BBzJSKBkW0Jc
 Wy3h2Wy912vHKpPV/Xv7ZwVJ27v7KcuZcErtptDevAljxJtE7aJG6WiBzm+v9EswyWxwMCIO
 RoVBYuiocc51872tRGywc03xaQydB+9R7BHPzsBNBFOMcBYBCADLMfoA44MwGOB9YT1V4KCy
 vAfd7E0BTfaAurbG+Olacciz3yd09QOmejFZC6AnoykydyvTFLAWYcSCdISMr88COmmCbJzn
 sHAogjexXiif6ANUUlHpjxlHCCcELmZUzomNDnEOTxZFeWMTFF9Rf2k2F0Tl4E5kmsNGgtSa
 aMO0rNZoOEiD/7UfPP3dfh8JCQ1VtUUsQtT1sxos8Eb/HmriJhnaTZ7Hp3jtgTVkV0ybpgFg
 w6WMaRkrBh17mV0z2ajjmabB7SJxcouSkR0hcpNl4oM74d2/VqoW4BxxxOD1FcNCObCELfIS
 auZx+XT6s+CE7Qi/c44ibBMR7hyjdzWbABEBAAHCwF8EGAECAAkFAlOMcBYCGwwACgkQsN6d
 1ii/Ey9D+Af/WFr3q+bg/8v5tCknCtn92d5lyYTBNt7xgWzDZX8G6/pngzKyWfedArllp0Pn
 fgIXtMNV+3t8Li1Tg843EXkP7+2+CQ98MB8XvvPLYAfW8nNDV85TyVgWlldNcgdv7nn1Sq8g
 HwB2BHdIAkYce3hEoDQXt/mKlgEGsLpzJcnLKimtPXQQy9TxUaLBe9PInPd+Ohix0XOlY+Uk
 QFEx50Ki3rSDl2Zt2tnkNYKUCvTJq7jvOlaPd6d/W0tZqpyy7KVay+K4aMobDsodB3dvEAs6
 ScCnh03dDAFgIq5nsB11j3KPKdVoPlfucX2c7kGNH+LUMbzqV6beIENfNexkOfxHfw==
In-Reply-To: <6xah74eadjmo2bozyr62wcxo4hhpsiufx2mshh7tztyy2dzzps@63m327m7pl5u>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------BRsY7KwrAyVfl7uL5YKoDvH1"
X-Stat-Signature: 9475sosb87t73nzdao6wqugy1w5i7btf
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F1ADA4000B
X-HE-Tag: 1785480829-723742
X-HE-Meta: U2FsdGVkX19Kf8SbRWPY98jcQIBVr+o0f1VauNzsGNsX4q6SbTCFcW6kWNUf0j5yYZNJ6OEtzktpQ6O2oOq7LI1xOcxbluOoTSvQPTYggJ3uiwycZ84DeI3wjcs7tfvJOD+Y//GNKS00VTD69GHR1aoL9/KRHA/N2B8J8eUjhUMnRivbSJfzzRq9+cbpm1AwauLYBSjX/jgl3Hp1QLz2bLoR+g/KDjo80gk00xvZDG4L7NYEVcmakUxJdh88Vrd9maPgJKPvuEJF645gI1gnndsTLCRKk1ofGG0U7YIWNjPcE+oMyvO1ozJP5Wg4AWIEsSdBMQRHIifGcoMwgI118YXH0PxixHYo17F2juv7vxMiaUQyZ0RzmZ8aKZLR36H42p0DdFMbmHIMWv1xU6jfzQNPbokz85XQlqoVmqHfjHAwnMNj7PHugyJJ12oDRT/m9nBf64S9o5L5kjQ2noyqQF2CVzHUAVrlxBn3jZ98sDHj10bJNp22sqH0eWdj8jEsEkDq8QGVYndrc7ttvLf7qtas0U4dp0s/ee52WdGHqPaBzB4QKX2U2aKMCd8Xt3AH/05U/FRF7fKajkX9XMqTF10sULAHrDs1CQjaRGpmclzrsnbn+m4qi25CnGSWiMUv3jH53nVG6VP8foxCR9ljqJwOVwRDb8eMiFaZg6KZMHdizErAtmt0jZGtcsiBqUs/Qhtq7JAxafepEVOubj42i+7EGs/eulqgUCQTuvVtTYILLuoEXe9O5YYxLdafccyGWW6VDk+sjrhC14MpZYBFwcy1A/LKBJlTgRXStbV7CD2DDk90jw8lD3sH0aaFQZBpeezXmvk1DsM2zh4nL0IMp/iNC6tdgIp8RAYhHshkwbmOXtE7OTj4t71OBmj/iiIdAP+hNi4YGj1d+sK43hzpBkd69zPZhQaBvOORXdlm++25qnBaxyfUap1UFiGBi0omSe/8Jw8KGm4wY+Mf/oK
 0bFcKKvK
 Lnx8CSN4teg4B6pdDmq9d/UKn4LSfqvFJPZBVIMLi25rfQRZ8LxgnCuX9+bZWyTUA2Bze+6YCk19raBC/mz5akkZkSIVRQsquM5s9JdBW97fUr6tad/fjPA7eEHbWIxU/S4Cwy4YdXn5c9SPGIxFjTmJr0dMpFPpF+l3KZq9HzNbN5xtQN3M/V1bAUQg7rM2BvVCVhnKKQ72Nv8ZHPfj7BjUuh4878j9Ui8Wnd3Qt6aNRNJgFvpvk9u3kB3DkoNTRaiALbk6DVQhniCEpo3rI35bXtCaS5g6sKPxAhzLDoMbCfBwPpm43xfASEBMxOWBgvgOGJOdC0GoPfaTfVTUbCOK2e3XbU/PakSVQxqGrlEBgzbw/Fy0OFja48SvVFDejqoBHk0OwBVHYnnNsiYI8aaT34T2WsJofA4ZnQ0fGPR5QJI/4XzUG0nLJONUdImRhKfMAwWz5uguaILsM6Wt4Lm48AOpf0q+gD3U1sGImhDYrq4wCT3es9XJYBxjXzZ/uXL2Qw8vyRrrwRddFV0FIgdMOAL7vA69FmlyJ3YfzOvmD1ZRkrarXQKTgtpT7qVn3vwGd1ahWPQByoZmFG8ALDOfkcTC1BXF0TGP5Q/AwDAKQRAdHcwMotQz5idAO6Voa6AuT43R6TFVqL7ad2me7+ZH0mypB2bCmkO+mT+yt6RHOxtv+gLjxNX8YpuYHTP54LuKHODHsqDVidIitkwaThhisfs5mWFeom8cIUVIm8+Vul9IAHKtcahaNDcm0uKBBxgxMFnRed3oZmzF8g+tYZQWOVtEsF0QkPF39y+WVhBT+cJKc9lFyrLOyQQkeQ7TqfKwGf/RMPFm0wHJWEf+rFVlPUmq4trzSdK0Ubj8N9X4ooRseiIGy+Y6pEYIEs8DYNZl9iQOBwRB5MiYOZa0/KJATMl1SA03pYPe/7K/2BiVPi2lzhQV7ckdSlA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------BRsY7KwrAyVfl7uL5YKoDvH1
Content-Type: multipart/mixed; boundary="------------f4U4I64f0aRScntXRDIXzWi4";
 protected-headers="v1"
From: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
To: Anshuman Khandual <anshuman.khandual@arm.com>,
 Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin
 <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Dimitri Sivanich
 <dimitri.sivanich@hpe.com>, Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 Helge Deller <deller@gmx.de>, Stefano Stabellini <sstabellini@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Will Deacon <will@kernel.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Nick Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 David Hildenbrand <david@kernel.org>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Uladzislau Rezki <urezki@gmail.com>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>,
 Eduard Zingerman <eddyz87@gmail.com>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, SJ Park <sj@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 Miaohe Lin <linmiaohe@huawei.com>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 Mike Rapoport <rppt@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 ziy@nvidia.com, pfalcato@suse.de, agordeev@linux.ibm.com,
 ryan.roberts@arm.com, linux-kernel@vger.kernel.org,
 intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
 linux-parisc@vger.kernel.org, xen-devel@lists.xenproject.org,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 linux-arch@vger.kernel.org, kasan-dev@googlegroups.com,
 linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org,
 linux-perf-users@vger.kernel.org, damon@lists.linux.dev
Message-ID: <41414c5b-e98a-4a55-ac87-ca982b248ca3@suse.com>
Subject: Re: [PATCH RFC 01/11] mm: introduce hw_pte_t for PTE table storage
References: <20260727164715.2866609-1-usama.anjum@arm.com>
 <20260727164715.2866609-2-usama.anjum@arm.com>
 <6xah74eadjmo2bozyr62wcxo4hhpsiufx2mshh7tztyy2dzzps@63m327m7pl5u>
In-Reply-To: <6xah74eadjmo2bozyr62wcxo4hhpsiufx2mshh7tztyy2dzzps@63m327m7pl5u>

--------------f4U4I64f0aRScntXRDIXzWi4
Content-Type: multipart/mixed; boundary="------------w4qlMsrvnQhbrwqQH7WX0LG8"

--------------w4qlMsrvnQhbrwqQH7WX0LG8
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMzEuMDcuMjYgMDc6NDksIEFuc2h1bWFuIEtoYW5kdWFsIHdyb3RlOg0KPiBPbiBNb24s
IEp1bCAyNywgMjAyNiBhdCAwNTo0Njo1MlBNICswMTAwLCBNdWhhbW1hZCBVc2FtYSBBbmp1
bSB3cm90ZToNCj4+IHB0ZV90IGlzIHVzZWQgYm90aCBmb3IgbG9naWNhbCBQVEUgdmFsdWVz
IGFuZCBmb3IgZW50cmllcyBzdG9yZWQgaW4gYSBQVEUNCj4+IHRhYmxlLCBzbyBwdGVfdCAq
IGRvZXMgbm90IGRpc3Rpbmd1aXNoIGEgcG9pbnRlciB0byBhIGNvcGllZCB2YWx1ZSBmcm9t
IGENCj4+IHBvaW50ZXIgdG8gdGFibGUgc3RvcmFnZS4NCj4gDQo+IFNob3VsZCB3ZSByYXRo
ZXIgY2FsbCB0aGVtIGFzICJMaW51eCBQVEUiIGFuZCAiSFcgUFRFIiBpbnN0ZWFkID8NCg0K
V2hhdCBhYm91dCAiU1cgUFRFIj8NCg0KDQpKdWVyZ2VuDQo=
--------------w4qlMsrvnQhbrwqQH7WX0LG8
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
kt+z4drzFUyEjLM1vVvIMjkUoJs=3D
=3DeeAB
-----END PGP PUBLIC KEY BLOCK-----

--------------w4qlMsrvnQhbrwqQH7WX0LG8--

--------------f4U4I64f0aRScntXRDIXzWi4--

--------------BRsY7KwrAyVfl7uL5YKoDvH1
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmpsRnoFAwAAAAAACgkQsN6d1ii/Ey/0
+Af+LOETmiWDtYgZgC25DuWMp+4L5NyNITZaMb2C+ABgCkNfzqMcNtWSNk+JJzaB6hI7CZVtXOyx
C1BoB0Fu/IHEX1h7Yg4K1ioAh2SLzQsdlMwc3ccJAAvp9Eo6epm1vOmVDINqjoi4xu61L0M12heD
FLKsZAcd5yhOcg5mGmdZSniMILaMfmcRbzE3nQ1LJcS9mWFe4fFFZJ4OTaOduPMhwV6YQJgVN1Vx
/xWzbtBOPQ9qzjkjyownpcHtHYqI9vaMrG1B2XnHR2zJObPXbM5NT3luR6vqCrMZEq7LIlex4FDe
SDzOyTnt3oU2QGZCcz+k+jU+wOUa3QFM7tihNiQN4w==
=4r2J
-----END PGP SIGNATURE-----

--------------BRsY7KwrAyVfl7uL5YKoDvH1--

