Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2544C5CFC1
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 22:54:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E47EF6B0326; Fri, 14 Aug 2026 18:54:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD0746B0327; Fri, 14 Aug 2026 18:54:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C98536B0329; Fri, 14 Aug 2026 18:54:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7073F6B0326
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 18:54:38 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9D61FC0252
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 22:35:33 +0000 (UTC)
X-FDA: 85101332946.19.2DDE821
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf30.hostedemail.com (Postfix) with ESMTP id E002C8000A
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 22:35:31 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fKf74bXB;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of thehajime@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=thehajime@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786746931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n2EAblvWDRelmfnXh27a45O70JHPB4giXZ+AN2NzhtQ=;
	b=JQKDuruxtqL1scayCXGDtNBpXOFiCmoDR26iGtLf3WUfve7NVkaP66BjvzVIXsEQL2wYm2
	qgOTq5qp6k2ZQsHDSilg2txNuewXeYhDDXnKZvS2J4UT4tFygwOt5MVW9KPPt2fRarvul2
	4W0/do4gBP/31x7YzgXYGH62e3F2R0c=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fKf74bXB;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of thehajime@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=thehajime@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786746931;
	b=UGa5D7JDpD3lXPUCV2KMc6wirI5zoNN5df+o/Xhpp0e2MsgdeLQvGRfjykNtKwanwFOWdw
	NqbNdoP75mgjUbRJVaNcn1sobibxGnHqKWq/hnaDXrUf6Fgvbc3lsJVXJR2xL7dia+G1sf
	7l78i/7h23gODQBgVACESJAMRNxE/lg=
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-38ea87caafeso1390467a91.3
        for <linux-mm@kvack.org>; Fri, 14 Aug 2026 15:35:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786746931; x=1787351731; darn=kvack.org;
        h=content-type:mime-version:user-agent:references:in-reply-to:subject
         :cc:to:from:message-id:date:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=n2EAblvWDRelmfnXh27a45O70JHPB4giXZ+AN2NzhtQ=;
        b=fKf74bXBM2QLfLozgx9z5jCBjHUFe6D5mUJbOn628ci+AAJDu7lBgB58ysPZgMBICC
         HmnTXjMXBwsEJ1xhFsG0RcUB/I/Hjx5ooa0H9MFBc9kcd1u34OpOSwXECBhSih6u/IBm
         Ng7rCNxgKlYBUFKeXufTqJ/tzXctONxwIt2BCfhNBhtnI5zLVOAMx6jRFIWqYFmSg5Rw
         BEE5upb8abz+FVyUUrXNqunNyuPOZx6YLugiRSGiMJeRjowS3QYin2Hg20mrcB25q2lI
         jJtsj1PG4SttsZwMS1QxIZwodeNKlQKuaQxYa2vX2/HCMldB1PcDvLnJSILvRAqdQQhN
         CtPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786746931; x=1787351731;
        h=content-type:mime-version:user-agent:references:in-reply-to:subject
         :cc:to:from:message-id:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=n2EAblvWDRelmfnXh27a45O70JHPB4giXZ+AN2NzhtQ=;
        b=bSeRwg4H8zUBUUukzHmY7HJUVrYunombd1oNuPm7ZC7+EFVkarWWFG1nDmLZ8xkXeb
         2DZvIAjLdjaO3QfQ5qlBKVLvVnI3GtMVM/5RnP7Dg8SFCcxLDOi2JTK09OnehuHTDDK0
         7kr0+ho7SM8J/ph+BwHz+2+CAVFT9len4ogedzQnbLjfcLaTolQU4VIEkwI79RBMw5s6
         wI/yZUxALbFk7qIwpkkrxz48ebAIpSqPOzfY1snPuumA8MLXPXuem6LN15CuLR1ru4Zq
         rAGJqLZm38CZgKhMi7+CNbpY3gNOaCN34TIXIyNLn0/5F4XvW3+w5VfXg5k9QN1hgfos
         A3QA==
X-Gm-Message-State: AOJu0Yzl4m+3CacrHbFMXbY5x8PRXtddBiRi/eMGRtrYKdQB0OYydKoZ
	EyBue76r6fx6eCuR7BKskrx8ydno84Feb831wWYFVmMz0giRecJ43VFb
X-Gm-Gg: AR+sD10T4IVhxTgo5VCwvJqgE3jaQga1GDa8nCW7WsICD01XzDboeio3MglnwiB0ANu
	AvtVd3H3jntaNldqBRI0tUzB7ZgIMasVPfKBJCuLvhY/uFh1sWtEQjkpfYnZ7XRuNGs3LeIaA53
	LVTFWNGH+zaK1XqCMl2xOx3xbldtZC7JwB6ozg4z5jtOgG6EG8MIQn/pQPmBYHHHS7U8A/a6aDI
	j/j94FasU5J/bXTqpXvrGPYuqEOzVSNsxZckbJJR3kWJeI3UB15SpLwr3zYiqyZUxkeotiOMfN6
	uTDnGqgzG0vglzeXMMzkWrY4gL2wpGtu94l1af51pHC7OuHpwL/fNbzMnH5k+zFtTCAimA9KTs1
	oUBXt6vf6m4H/To3rkkP5jPpSvmCejzhPX0IzibAFRIcKp6RwG1xpx/knXFWyd8KF4ELKSCCgVi
	7tsRqBcgTDyQD3ZgbS92BCMMGh8iIT2gwwkxqe1dAw672Tkm2MORWBFFbDnda8WMLrUAVUkRQis
	159T+PLcyAo59hMI7GN1cfAb36TVz1rPXCqOq6+ErCgXdC9TWGDh3zma1XZFsEBZf1ETJHSVDvH
	TkHB6w==
X-Received: by 2002:a17:90b:3c91:b0:380:f85c:94b4 with SMTP id 98e67ed59e1d1-3933b78e3c2mr11247940a91.7.1786746930611;
        Fri, 14 Aug 2026 15:35:30 -0700 (PDT)
Received: from mars.local.gmail.com (221x241x217x81.ap221.ftth.ucom.ne.jp. [221.241.217.81])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3933b699e47sm2074781a91.4.2026.08.14.15.35.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2026 15:35:29 -0700 (PDT)
Date: Sat, 15 Aug 2026 07:35:26 +0900
Message-ID: <m2wltspbyp.wl-thehajime@gmail.com>
From: Hajime Tazaki <thehajime@gmail.com>
To: ljs@kernel.org
Cc: linux-mm@kvack.org,
	geert@linux-m68k.org,
	daniel@thingy.jp,
	akpm@linux-foundation.org,
	david@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-um@lists.infradead.org
Subject: Re: [RFC PATCH 6/6] selftests/mm: add nommu mmap and mremap behavior tests
In-Reply-To: <an8SvW3jv3JuAFc8@lucifer>
References: <20260813063401.1786548-1-thehajime@gmail.com>
	<20260813063401.1786548-7-thehajime@gmail.com>
	<an8SvW3jv3JuAFc8@lucifer>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) Emacs/27.2 Mule/6.0
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Stat-Signature: i6boows8j8gx4g43ymnmyeugnqbksghk
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E002C8000A
X-HE-Tag: 1786746931-402374
X-HE-Meta: U2FsdGVkX1/DzqfJR8oxVI9h3Hh1VfcyGbXkVejzRxOnhI0oAPotxkgKxCCl9exJT6QArbDkLObGgKIim2ZMvRK0SBiaql5H4Jdfe+8DKb98ok/DzrRfPa2DyMZGrPtX4KqfNMTfNqxrhhQVHcYyexykAXdQ+7xWZdGJb9devdOhv5/jIWsH7ui8jTQfjGowzT2evfxeXCeoqOyLDe1Ol1K/xO99lE0pGy0rqPMiAaG4kEuPkXXZKcQfb+tl9ejO+VBZDAGKvmejvgjrxQeI6FA3JWa+KCB/IoSzwaDK1xvqiQtPRXONLbOeOapTxA1N+nVU/3CoAZgHqM2ol5Hf7EDW8G19el3dfbo4huK8VRSZemCj56FfOHAJuJq94TX4l6PG2JcRsh68ecYrt+oqLHNsKNQ0y/l74ffjDeB731q7a7Dvlhr6Dl4SwgK5vXf/Am0FX4edram+z/1Dyd7eXJl23/BqrhpikRQY+o0j2Nw8hNwqqkSFUv2Xy/GHmeeS5gMDC+QrMNhU7u830iY5BVLzfnCx7KBVWYJhwltGXPcvmsNA+uvFwJCeWeRO3ocotigdrrp98kMp9EBCrqqf6iyQpoXgUibhel6etITXpUi2FeMXF0EOqkQJWWQ/jBnQUKaX42r8g+3LlkTTOI+UxTCkC+KUa54Wdhk+OGCQgpVlljbIv2K414nGIumo3RrKqDN5VKKjkRZ+hL71ygpnTjyp9AYLs2BZVtNUsJBRzjzZ6pMnefrwz/QwNsoWJxegPbUvNzTZ4vptjyotBhwCKTt2R/leMKf+u63d1hqJEtUnVS7wEMD1R1HdJzBIXBr4I1aeOKCb85NDZDGLq8yXRWpCCd6QHWaiwAacHz55OHuUehhtR20iiYBbuK9q/Xn812RrWxNQzu1ZHSFfxGw79R1oveNJJu1F72jkXAk5KxxXvTvlwjBQvZ187aCkPawLT/Qf6cGYGK2JmGPWOUJ
 zm7hOapX
 P4cOYnCW5Zh+R8cxggOkrd5uETzRqoX1lN7ONDK5uIlGv9tgP5SKtAV0KeeQai6BERKK5mIvf3k1c2SjFfLUlI+6JR5rVXzljJ5ZZKNY+9f3Ln+c1EimE/jveJNZ7dLjk/8T8K3ZA1go/F9+/sq58QQiFFF7DZ47+TipB58yoWaL4XQIPUC2xYCIMge7/FWnZjXet9I9O78bQnsq8SV6Rx8heD0ROIQF6AyNUwnmDmJ4I91LJshBmc61Ub/6P047hkFVGXS9S9uFsKxzzFCFGhqkh8tJ6n+R37vJFI5SRELlb4yHj1HGNbEkCWKHV9vq24mxlvo9ziZDS7pnQe9t4vP9OL3yc0+WEUI6h942VLEHflx4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Fri, 14 Aug 2026 22:28:53 +0900,
Lorenzo Stoakes (ARM) wrote:
> 
> On Thu, Aug 13, 2026 at 03:34:01PM +0900, Hajime Tazaki wrote:
> > Introduce a kselftest utility to validate memory mapping capabilities
> > under nommu kernels, aligned with
> > Documentation/admin-guide/mm/nommu-mmap.rst.
> >
> > The test implements basic checks into a generic architecture-agnostic
> > test matrix applicable across nommu targets. It evaluates:
> >
> > 1. MAP_FIXED allocation rejections.
> > 2. Standard MAP_PRIVATE and MAP_ANONYMOUS allocation resilience.
> > 3. MAP_UNINITIALIZED allocations via optional kernel configurations.
> > 4. Regular file mappings via standard filesystem storage.
> > 5. Memory-backed file mapping with /dev/zero
> > 6. Block device subsystem mappings (gracefully skipping if node is
> >    missing).
> > 7. Shared vs Private backing discrepancies under nommu conditions.
> > 8. mremap limits, ensuring non-expandable restrictions behave properly.
> 
> Thanks for adding these.
> 
> It's horrible to not have the kselftest harness for these, but as established,
> fork() doesn't work for nommu (!)
> 
> A lot of these tests seem to relate to functionality I'm not really happy with
> in the rest of the series so let's see how things pan out with the series
> overall I guess!

(snip)

> > diff --git a/tools/testing/selftests/mm/nommu_mremap_test.c b/tools/testing/selftests/mm/nommu_mremap_test.c
> > new file mode 100644
> > index 000000000000..b1b8a4e64b55
> > --- /dev/null
> > +++ b/tools/testing/selftests/mm/nommu_mremap_test.c
> > @@ -0,0 +1,583 @@
(snip)
> > +
> > +static int get_shared_writable_file_expected_error(const char *path)
> > +{
> > +	if (get_fs_type(path) == RAMFS_MAGIC)
> > +		return EPERM; /* ramfs failed */
> > +
> > +	return 0;
> > +}
> > +
> > +static int pre_conf_trim_page(void)
> > +{
> > +	return set_nr_trim_pages("0\n");
> > +}
> > +
> > +static int post_conf_trim_page(int value)
> > +{
> > +	char buf[32];
> > +
> > +	if (snprintf(buf, sizeof(buf), "%d\n", value) < 0)
> > +		return -EIO;
> > +
> > +	return set_nr_trim_pages(buf);
> > +}
> > +
> > +struct mremap_case_t {
> > +	const char *name;
> > +	const char *pathname;
> > +	int open_flags;
> > +	int mmap_prot;
> > +	int mmap_flags;
> > +	int exp_err;
> > +	int (*resolve_exp_err)(const char *path);
> > +	unsigned int old_pages;
> > +	unsigned int new_pages;
> > +	int (*pre_hook)(void);
> > +	int (*post_hook)(int value);
> > +};
> > +
> > +static struct mremap_case_t mremap_cases[] = {
> > +	{
> > +		.name = "anonymous shrink (r--)",
> > +		.pathname = NULL,
> > +		.open_flags = O_CREAT | O_RDWR | O_EXCL,
> > +		.mmap_prot = PROT_READ,
> > +		.mmap_flags = MAP_ANONYMOUS | MAP_PRIVATE,
> > +		.exp_err = 0,
> > +		.resolve_exp_err = 0,
> > +	},
> > +	{
> > +		.name = "shared file shrink (r--)",
> > +		.pathname = "/tmp/ksft.nommu-remap-XXXXXX",
> > +		.open_flags = O_CREAT | O_RDWR | O_EXCL,
> > +		.mmap_prot = PROT_READ,
> > +		.mmap_flags = MAP_SHARED,
> > +		.exp_err = 0,
> > +#ifdef CONFIG_NOMMU
> > +		.resolve_exp_err = get_shared_writable_file_expected_error,
> > +#else
> 
> Hmm aren't these all nommu tests anyway?

those tests are indeed for nommu but also compare with mmu systems.
actually I was trying to implement test behaviors which are described
in Documentation/admin-guide/mm/nommu-mmap.rst.

this particular case ("shared file shrink (r--)") is not described in
the doc, but test with a conditional error on nommu, and expects
success on mmu kernel, which is interesting (at least for nommu folks)
to validate future regressions.

I think now if I split into several series of this patchset, I would
drop this particular chunk which is needed for other series, and keep
only basic tests for nommu kernel which is described in the doc.

-- Hajime

