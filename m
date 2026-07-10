Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1AF7C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 20:20:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E57A26B0099; Fri, 10 Jul 2026 16:20:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E086D6B009B; Fri, 10 Jul 2026 16:20:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD2CE6B009D; Fri, 10 Jul 2026 16:20:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A154D6B0099
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 16:20:07 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2A9BD12057A
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 20:20:07 +0000 (UTC)
X-FDA: 84973983654.10.FC90671
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf23.hostedemail.com (Postfix) with ESMTP id 47B5B14000F
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 20:20:05 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=a1jfQcJA;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.176 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783714805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Atx/vDG1sDwzZEMAHR3NGh72ccSeLTTbFrhohwZH8Yk=;
	b=HwgRHuaxETNifC2Yp5oP2bjax72twXPOpzOkVSeHI+wf3ooQObnjOHt4Kb0yGvOjOcfO/5
	E18TgnG/yA6+4Fl28PR7ihnYvpBxBzdZVuv5vmN6Tbe87RgUjL+tjhCEav8EZ4NTIFwCFc
	/u+Q4N2RiowRJqKb5gykNvt47QZOmy0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=a1jfQcJA;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.176 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783714805;
	b=6iuVvH78vowulPsWTDiL5iOSMsctVaflYxGyq0FrrZ3+DL27N6wmZ3NjGmvfyzluWI2nyz
	xIpp1/8/wgQPyh+x23vpdjcHzXnDe/TESQ53I2nEzZP+iYaMCwVczukf4w3PHAKEcs4Tb4
	mTPys2ViLQB+rdddj+zQr45Hrau+F74=
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-51c2149571dso11631191cf.3
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 13:20:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783714804; x=1784319604; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Atx/vDG1sDwzZEMAHR3NGh72ccSeLTTbFrhohwZH8Yk=;
        b=a1jfQcJAkCwvKNReXZMrTQ1IR4v4Sf5ucDwyktmFaglwKHCZuQX1VPfP07lfpmZJey
         qH2K6KMjmcOkrjzCykMQkFZBMs4kyUuf1ASa1m0pDwyWZz8Oqbc7mqmpEVDkPBnwfoSk
         OVQgq1rb6dU/5KttmazCvK5fmM335F1VXJ5gD7Qukh7HqaiGk8jUi7DC7cQw3UwrTQtd
         oTGnOsHhiFY09S7f74Pzf5e91wwjUxT2Kbzn9B8P3bdDJQMzdi4GaoY9ylnTUW7Kb5Ll
         FkDX4OP6Zpw1pblHoqOXcVhb379TbA6tXmernAIzvwdZjcBTSG+N4Csle/0u9t/7/4Q0
         7ttA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783714804; x=1784319604;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Atx/vDG1sDwzZEMAHR3NGh72ccSeLTTbFrhohwZH8Yk=;
        b=EhsCgF+ByEEVhz7tnRaefGuRo/270uiRUZuRFz4tZfUUnWXWeW+oXwo2A0rvM5t0mC
         4bJp7lCON4nIK3miDuPksJqF4cvL+koWZ+BAST8n/UrtBIrAHPdxKheuof49qlQQ0TTJ
         68fTx0S8+pqIUxbf+8Tq8hxfjQ3CS0EqFmIyfW1c3dNeCeSrUtO4TZ0zMke8mxnHQGPg
         IIOyG7hcUyijzfKMErNlbh6d0J1QSfRvE5CVeIUMHYetEQEChavNqO/PvJcvAiqmVbv7
         0lgil/mNus1kCVaX+4qGKrpOQDUSUZhbSws98KV1wpS8E5oZtGiW277LVkmp3sB8gY1u
         Ce7Q==
X-Forwarded-Encrypted: i=1; AHgh+RqmBg8NVkv3as/9H5w8MfREsjdPJAfdi/Qopyp7w04PX6EmfWOyvslbs02SJxhw7wu2JO9h++hsRg==@kvack.org
X-Gm-Message-State: AOJu0YyeoVFEIioZOff+G8nB43Lg0bykPpiu7e7AdNu2sf3gdd6rdccz
	5+sTa0CapMUahygOUMPjaPfzEWmNjMaLz+lZ3mKqw8dl6asrasKVL58rvRo232XkHIo=
X-Gm-Gg: AfdE7cmXrUl74be7RtpIrmjYi7nS7oWkiN3Ytqk+U0EjQI71WigrakzBT5kUxGMwgA6
	zO6alpo+VlP9nBeMawlwvP3IiC1i+8ahDfbDT20m/5M2su+hnMeFOznldEiTNby4r0N9qE5DvVJ
	oRK/Gk1CbZuANlWbCTWtyTpSHH+lmXGsC9B41Fp0887CeqCQYy0OZyRoZItGKI5us7PYIFGz4FN
	W5Zq5Os7HdahPdM2g4/ko/K5EGBjiCo0AMXG0dRKQb8TEZKghXDbwbhIpRIrucVBq7r1jKmGlGf
	QSh+tqMFXEFs6WAlB2Hcyom3iGPuvBBFIuhW8WJrC+3sFmtCvNrWaSSmQzP2vH/cA0bHyn/0Eky
	WrAWIT/eZrs/AGVyvCtfNRwl5UwSXaqczzxH/XbbNdB+WYw/rXVTmZdGQSZaSj+Bww0R3ZIS9xc
	HuVDNTlt6PYGOvu82iE+lxef2WWx2SH3w3mtITVJUUZ3t4Xde0Z8A8WRcsB5YC+YK6ts35
X-Received: by 2002:ac8:7c56:0:b0:51c:1291:911c with SMTP id d75a77b69052e-51cbf0e0649mr5096251cf.14.1783714804352;
        Fri, 10 Jul 2026 13:20:04 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ffd50e10f4sm49427896d6.1.2026.07.10.13.20.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 13:20:03 -0700 (PDT)
Date: Fri, 10 Jul 2026 16:19:58 -0400
From: Gregory Price <gourry@gourry.net>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Russell King <linux@armlinux.org.uk>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Simon Schuster <schuster.simon@siemens-energy.com>,
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
	Helge Deller <deller@gmx.de>, Jarkko Sakkinen <jarkko@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	Ian Abbott <abbotti@mev.co.uk>,
	H Hartley Sweeten <hsweeten@visionengravers.com>,
	Lucas Stach <l.stach@pengutronix.de>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Dmitry Baryshkov <lumag@kernel.org>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Thierry Reding <thierry.reding@kernel.org>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	Christian Koenig <christian.koenig@amd.com>,
	Huang Rui <ray.huang@amd.com>, Ankit Agrawal <ankita@nvidia.com>,
	Alex Williamson <alex@shazbot.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Dan Williams <djbw@kernel.org>, Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Matthew Wilcox <willy@infradead.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>, SeongJae Park <sj@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>, Hugh Dickins <hughd@google.com>,
	Mike Rapoport <rppt@kernel.org>, Kees Cook <kees@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org,
	linux-sgx@vger.kernel.org, etnaviv@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
	freedreno@lists.freedesktop.org, linux-tegra@vger.kernel.org,
	kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-mm@kvack.org, iommu@lists.linux.dev,
	linux-perf-users@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
	damon@lists.linux.dev, Pedro Falcato <pfalcato@suse.de>,
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
	Jann Horn <jannh@google.com>
Subject: Re: [PATCH 29/30] tools/testing/vma: default VMA flag bits to 64-bit
Message-ID: <alFT7lx8F04rN01D@gourry-fedora-PF4VCD3F>
References: <cover.1782735110.git.ljs@kernel.org>
 <27cd07f6dd862d92410cf9db03f7c11e5f66854d.1782735110.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27cd07f6dd862d92410cf9db03f7c11e5f66854d.1782735110.git.ljs@kernel.org>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 47B5B14000F
X-Stat-Signature: m3y93ijnj5kotcbneg95phdsusstefa3
X-Rspam-User: 
X-HE-Tag: 1783714805-436286
X-HE-Meta: U2FsdGVkX1/wtE+fx+DwU5zf3JXCHwxXCe9BcsrKSbWkqEB4XXUt2ZRWVa/WLBN/2N9BGwgIBwDrQqVempMSPs25ofAfEIWzySMmYLsYXfY3LUZWhscoWCDOADkry5DKBP815vNdQQwCXjTnlvFk66b0PdcRQLdj982ggSRwexxU62dV/8wvSLKy8So0F7dwgyeB0MKPkvAl6uDdLJaQAmXay3RxdAmgdvNXFwh2Lrz0+h2u1nKX6KyhbjVBTeze7jl7n2QWuwjsXcs5NmshAh1hfxquEUcukJSrcVt1EwlpIS3xZ3yhRws5KUeLldUdelPwnsOoxjZr0g6Mk7QI/jXdmWnSKsjvxxRS4pL+NlmKBZA2M9BYTjidHXNOHwWp3Pkg+rYqgGJ8rrRDKSyjpOX3lM1tK7N5LTX4Wm40hElbaSrzgA8Q9d4O7ftx088vhs8YscenjPg4cIHEFpOtfkih+a83nZ8zbLLCpSc72wZZMjhX+7T2djeuSfPtQtsGO/ePQQagcjly0hP6XHVkM2shtx2xd0JqcOvc2qqcMYc243B01ytCcdUUHG9ZLfPuczbEJ4bjsydfeP4BzYV2fxeW2E1beaD0rS3xboUu2oZd1JzPJlTC98ghQjMITIgY3i88RC8An3PLJmP+fS+ZW9pFv7266iTY5ens4KhrPyVO97PBxgMk8yaZ9zTKiFLrxgjFY0m/XjJcNDdNJkqKVcJK6AqsmGPzg746/sIt7dVE6V6hYVNbTpYsFvkwqldCqvGb5vVYt0O+pAFkdjrksaMY+xJ8K1LHQO5yWhsUUFBGOKZYGoOgjmcqwbJWvueyMW5Q3mp2Wyfj2xw1Fw39GanUXvFnka0FCH6GQ0lHIG6JF8ZaHOPnPpK4bsIMy7bI5d4V2G8hiDUqSOMXSib+s23/f9nUmeVXyhmEFnTAOfUggLXnhrBcBQ91mnU0897mupEvQn+NigARbs4EvfL
 2lWOKImW
 uK0NXLFqs4HSLvll/fYHebp+H9X2fAkGrIB2sgyUFGutuBgXr7xbaDOx8rbxqiqwqY9aBk6qGdgVoz00IsUY+JoQyXfaN/getsLvbWUMXsmSrk246P1x7gMOj6Bsp7r+iVzgRtEqZkEU301nYEEo/r1CSXY1nGoZ43iik7lT62238FiYT2Up7SAAoTtmzo7f+m9jQYyU4NXV6usnyJws3KykwFJRLDCLD45x5VrtyvVmuEhPGaM6rsfCqHza7Tk9499c63AtYlkm3Ot3K2PM5ZTprV2tvSj1W7HvCvG9DC/mbcVjll1q97qWCLSo39/b93FiOjgf73MIgr7c9Rq7YxPT91oLUq4zHyRr/laTupmsyiTnhTCsqQprlQQ7nt2BPvUF1cCrzzD9B+qmQIjHpMG1DbKFER1w20Srwy0hmYRJLFVO6TsoiI5W+IZQ+INKlzva2j+QhLmaM9OjVgpVa+PQGxT5buZXRJ+wQX9xXuaeqXVo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 01:23:40PM +0100, Lorenzo Stoakes wrote:
> With all of the sanitisers turned on, setting the VMA flag bits depth to
> 128 by default results in overly long build times.
> 
> Reduce this to 64 - we can always manipulate these later for testing of
> larger bitmaps as needed.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Seems like this causes instrumented inlining to go crazy.

static inline void bitmap_or(...) {
	if (small_const_nbits(nbits))
		*dst = *src1 | *src2;
	else
		__bitmap_or(dst, src1, src2, nbits);
	        ^^^^ this branch is being hit ^^^^
}

tl;dr: __bitmap_or() gets emitted and then the sanitizers have to
instrument a ton of inlined functions instead of the compiler simply
injecting a couple 'or' instructions.

if you wanted to keep the coverage you could do something like

# These can be varied to test different sizes.
NUM_VMA_FLAG_BITS ?= 64
NUM_MM_FLAG_BITS  ?= 64
CFLAGS += -DNUM_VMA_FLAG_BITS=$(NUM_VMA_FLAG_BITS) -DNUM_MM_FLAG_BITS=$(NUM_MM_FLAG_BITS)

w/ 

make NUM_VMA_FLAG_BITS=128

would let you still test the branch but not by default.

anyway:

Reviewed-by: Gregory Price <gourry@gourry.net>

~Gregory

