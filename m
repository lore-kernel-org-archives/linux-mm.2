Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CA56C982D2
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 19:30:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F41356B008C; Thu, 17 Sep 2026 15:30:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF0FB6B0092; Thu, 17 Sep 2026 15:30:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB9876B0093; Thu, 17 Sep 2026 15:30:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B49B56B008C
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 15:30:02 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D243812048B
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 19:30:01 +0000 (UTC)
X-FDA: 85224244602.03.457A7E3
Received: from mail-oi2-f29.google.com (mail-oi2-f29.google.com [74.125.231.221])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1394212000A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 19:29:59 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AkzRgN1e;
	spf=pass (imf29.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.231.221 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789673400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SOpmSpu+1kSYFLkQThK4c6ymQH45Iak6v9IcQ+Qt0zg=;
	b=W6EpryNyMF8QndunD1k+wwpasNL8V8TBg/Z1IA8XamIzSLndsCTEK+/sOZ7oKObpi5gpKF
	BjA+f6q0FS7gxCo2oO81xiKT4eFIBXoueXV+JOOVYrno4m3cPKw7K3t8h/zZzWI6X3HOlW
	/4kSH7pDrqfkrUirIXYytg7dMU3BW00=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AkzRgN1e;
	spf=pass (imf29.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.231.221 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789673400;
	b=js62V6nyIzspD0RwmhY4NofW+XhDINOL6RfszgA5/u4cMQQNAL6qQLp34OSNMjwMblEJpN
	71yW7PD0Co82XXyzJyHC5e+NJpux5e83oBn5UuDCRy/VVNTZAwsinlQCTqz42mbsmkflrF
	NqS+GMz+WHoaSy0osLiebEOE422LmL8=
Received: by mail-oi2-f29.google.com with SMTP id 46e09a7af769-7f65ebea805so785356a34.2
        for <linux-mm@kvack.org>; Thu, 17 Sep 2026 12:29:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789673399; x=1790278199; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SOpmSpu+1kSYFLkQThK4c6ymQH45Iak6v9IcQ+Qt0zg=;
        b=AkzRgN1eNZeDMvPorq0vgClsy2KT/5gyhjUMQCCahdDYT6jhZ5NwbXrIMsxSR/2EOl
         T50D/TNM1W5/vYxn78zoyn6rU0B23wiUsCulm9e1DnY2OaFC2Zt5HkQI1R+2o951DihD
         5hEqjpiLQeul452XdvCVSw7wKdK8il9mbCdLyB39GAjuw3BsROFuw1mYp/RlkFBYdbpV
         /n/hwLyW4gMKmpiCO+NXTbQk6ju2FdigDpzwnvndbWnf94p8l6Z0U2AF6WW6RinpTnrt
         zfm6vLdnZPtDwlyknB7B1cM4sBjyXv2E4j7xmkrY2mhaAQ43D5n9bLIaqZTQESE3yNK1
         bD3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789673399; x=1790278199;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=SOpmSpu+1kSYFLkQThK4c6ymQH45Iak6v9IcQ+Qt0zg=;
        b=WFtwZajmGocMhcdRL4GaPDrXNqWi3F3iJPZ2kgLR+tK7W0c0307R8rAWMiIcUbIlxT
         CTp2iIt67iv1hGkRyg/VlWkeOTWFpY7sfm1MoOJtD4ihCbn/FYFag+HFup9Nr8bg/iFn
         DYRgRvhCfBSWzqy+TQBz5sd3Q2o38ZAyFCCrXZ1xlwo+rNrGAHsxSu9yIJ4kpx1jFlfs
         jkhBwK4i0/D9hoVg5BuaP14zOGSay/MCmsiWWZ19Cxg5H+MkVuRp0y1u5NPFkHSDmb5w
         N7IwZHyCOfOU8xlDs8Tmp5N32TRerqrgjpWxXtEFo/XDXF5TBVN1qYkxdpTBgTUVURMO
         PKuw==
X-Forwarded-Encrypted: i=1; AKwUvBxG6NNZnydtY6iaMnn59XKWsumKBwx2A3uFoco+aFQgfooXaOngD2yuGRjbWGtZy0lPC035kkDLzg==@kvack.org
X-Gm-Message-State: AFuF++m5LphdnZ1I1O+jVrt0RmyiKolhB3nHCld2GmXlbZezethbO9tc
	rkOtUhC/4Ao0D2aQhEh7bnCXkkGg0wmBZ5/joRc9LpbSxUKDRE2szSLR
X-Gm-Gg: AYBFou1GrZcI/5F6Hkup1gJrffdLzSqrp7FMTjabckEJQlVCjOuXUC918mfgSHv7tH/
	sHk6JbQDTngd+3Mzm+3xlSWZC7PRKPo+0GDG+db19gHIUJPJG09xjwX3NtGiopEjePQwVNM34Cg
	dudIQ41OhyxJZ12qzNin++z5akVihinlca/nxIhhbtITEhht9w8pt6FBLu2L+LXZamz8C7KyGQ1
	lwC8x/TguEUGtTUN7/0zFc415rmVcflZqVETyin5ik62/yNCfK0AYy1EDY5eGlbTViWoNNX27M4
	CV2VHhp3KXX43NhgJIB9fyqZC7dW23D8MmLNA1jN5ONhEBP6KLb14N5UriCpdQtsH8l0g4TXPme
	UF+gc/ePSk3u5WFoXEOC+vukgUMd/YUv3WprX9vDiuRQJZGGERqc7hLdNBwdFqyBRFwTpYmrhA/
	Fcwz2KT2s7+EwDvOPKen1xalg4r0K2HFsxbNtV+9xfUa//X5lFIiKE0rpEKtNO01ry/Yr207kal
	zEFa9OE16G9ZHgg/xCYRCK7aFnLSHCGLxQcqeiv
X-Received: by 2002:a05:6830:43ac:b0:80c:d30f:974 with SMTP id 46e09a7af769-80de21d1f84mr119151a34.21.1789673398952;
        Thu, 17 Sep 2026 12:29:58 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:5c::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-80c474d1f0asm3732953a34.24.2026.09.17.12.29.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2026 12:29:58 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: ackerleytng@google.com,
	Alex Shi <alexs@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Dongliang Mu <dzm91@hust.edu.cn>,
	Hongxiang Lou <louhongxiang@huawei.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jonathan Corbet <corbet@lwn.net>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Michal Hocko <mhocko@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	Peter Xu <peterx@redhat.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Wupeng Ma <mawupeng1@huawei.com>,
	Yanteng Si <si.yanteng@linux.dev>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	fvdl@google.com,
	jthoughton@google.com,
	rientjes@google.com,
	vannapurve@google.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v3 0/4] Fix HugeTLB subpool used_hpages tracking
Date: Thu, 17 Sep 2026 12:29:56 -0700
Message-ID: <20260917192957.3466978-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260916201307.5618114cbac4af52d98aecfa@linux-foundation.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1394212000A
X-Stat-Signature: gwqudi9kbrg3mp8iaz67nyn9g9j8ak4o
X-Rspam-User: 
X-HE-Tag: 1789673399-196095
X-HE-Meta: U2FsdGVkX1/D9JgilMC/b1Nu038nPKQqZrqJqWDL28ZVkO6ZmbSdTyyP+7n8+lSUaduOkqZgEgCVY+DWIA5Do8NBS4NjkJn00v4tMh8MUdeiPSrtwoi5Q670IZX9rkAnObuiBKkU8TkLEM+5NsOFeS+az1XK7LuHXv54f+fhsCpPopNh8Xny31EVPthWaVzMPIFYQ+DR8D/CorGyWdZ3aUxwI02o5f/Q44QZj6eHcYi2G1w12aUXN0c2QLRr/594QgrH+6g3cVLt6N5JXNV7eypM8guNiJs2NplI64O61phm5WBbt/GXI4TuoaR/SaRILzO6uNcf5oo8IKWDBKEZBWF4wfila9Jv0AoRBmDr/fXzXfw7CEUZMeMCEJdNJGUBrervrpTNeQ1Fe2a9Fh6wAQt6f2T9fde0k3aEOaLhTfdnNvMze0UurcgXtHBzaL2dnu0RTVXMcpJq6LQBCvJdwjB/jVnwF5FB0E2OFEOzykHLoO+oLwH6Z98p1wLJcRiEVHSlBJnq5n2NIZd5syqOVXzqPKeqkbRG1JEmEUfRVHuue1hvXwLSaWg6FPRzLi0FgmNSMV+E5L0HPS4+++oJMQ2fwak4wQ+aQ0/x78Mh4AJW5LKvQdwct7I9a5TGVmnMvnWSBzSnjb6cLR4p3wgXIfKzphyVOfCxdWZnujgE/vwERDFV2pD2fuSi9qb17CMs9z2Yl6oFB0eXgxwfomEE4gEWU27MThC669K2SpmMbqm2p/ETWSbdwYE0XkioEQeg3AYJHNPswAFd7Mp/xVMjKxLN87m/N8uGGTJyoM12IuEBDT0TWw03FJ7BMTegMfI69Lm4GUSeTgPFlG5Nd0K6mb4aUA9Ly2FcG/A0gTRJ7YqHwzlHrACSgjpxGDE5SxYk3tLW56X0B88Vow3nFKA+BFqkYQ9X69fqKmitRyCGgCShwvzWM4UqxI3V2ZTR6QlS6P+ZCZtOkNHF2xeiEAy
 FumwYaxZ
 g6it35Do6QnliHj4On7Z/7wYkCgR3hGpcC/yBXvga3gfUkTz7895mKq/y4f0vLPwcD5UBoWpubb7aX9P1zz1eKjxYPYp+Ltzut7KWpC4/1QGjt4gdPCqniZMAYRju1ZxR5qgOVGyWTy4ml/kutndSodZArKbm5KwBxv9HWrkVb1I2wZeWQtvcToqRUcUEUimckKVZmwkOHX4vvXnJFTi5oxkCzdx0sF4AgIJ2i3kpL/zQh6lConD0iwHwh7OYqJLkE2V8oBRFAta3VpDDdapp6rRG9FFfMfjWcCl2WZiJpJ4InFC4GtH74h+YZP5RWD6MK9Y5j/MQDglQLM6ne09iI+TGE5jISMyarb0EmvCUejOOcZj7f/jARctC5RsDcDPEQRklSarO16sgUZpwLwRvtaFDbh+wNRqGl+lfGZlnRNniuxaswC52PImnXX0uoBu9+MPIGToHsgHAlh0BjUk96kmPDBvQRaJesykRhv2VumTXA+8C/lRJ0SbZYBSbZyM0DqMr2bijmDPi8Ysj8GbFTzaka7anEgx5M/TGx1D0ckrsXxoMFXFy5t3HCs0t8K7hNwOJoBsHp9mzbjhj2uEaB7Dc80yU7ID8upKW7YwfzY/vjS/cAXAmThPlFCo2lUmBt+Bgoq6gAq0lkz6wd6yqEnnLG7IEa5njbxkzf4flaC9J/aFvqSzPJYyNmeRyh9qQ6RdXdGwFdERIuiufx1CJiDzEI4616s2gPsTWw+PsvRxiSwoBpqajea5jvQQWGE9PWMhNMhfneIDSl2k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 16 Sep 2026 20:13:07 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 16 Sep 2026 16:39:00 -0700 Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org> wrote:
> 
> > HugeTLB subpools currently only track used pages (used_hpages) when a
> > maximum size limit (max_hpages) is configured on the mount.
> > 
> > ...
> > 
> > This series addresses three problem areas resulting from untracked usage
> > and asymmetric error handling:
> 
> These are rather serious-sounding problems.
> 
> I'm seeing Fixes: for 10-year-old patches, for one last year and one
> this year.  The fourth patch doesn't identify what to fix.
> 
> So if downstream people (-stable maintainers, others) follow our
> recommendations, some kernels will get two of these patches, other
> kernel versions will get three and some lucky kernels might get all
> four.  Are you confident that the patches can be split apart in this
> fashion and still produce a good result?  After all, we're sending
> downstream some patch combinations which we didn't test.
> 
> Also, can you speculate about why these things took so long to
> discover?

Hi Andrew,

I'll be brave and admit that I knew there were hugetlb accounting issues
for a while because I was seeing them at some ~rare~ frequency, but
I couldn't figure out exactly what was happening and didn't report it. 
In my defense this was before LLMs were doing a good job of finding
bugs in code ; -)

So I'm very grateful that Ackerley took the time to find what was
happening and sent the fixes. 

> Ho hum, complicated.  Let's at least slap a Fixes: on [4/4].  My
> trillion-dollar sidekick suggests a9e443086489 ("hugetlb: disable
> region_add file_region coalescing").

I just reviewed the 4th part, I'm not sure if there are any
userspace-visible changes for this. Maybe just an additional retry for
allocating from the global subpool? 

> Our other little friend is talking to us:
> 	https://sashiko.dev/#/patchset/20260916-hugetlb-subpool-always-track-used-v3-0-38aae9b5ccdd@google.com
> 
> I'd like to queue this up promptly because it fixes things.  But let's
> seek additional review input and argue with Sashiko before taking that
> step.

Agreed, I left my reviewed tag on 2 & 3 but it seems like Sashiko is
raising some concerns. Ackerley, any thoughts on those?

Thank you as always, Andrew!
Joshua

