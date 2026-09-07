Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC0F6C79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 13:41:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 955DB6B00A0; Mon,  7 Sep 2026 09:41:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92DC86B00A1; Mon,  7 Sep 2026 09:41:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8434C6B00A2; Mon,  7 Sep 2026 09:41:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 64F216B00A0
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 09:41:32 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 04287C013D
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 13:41:31 +0000 (UTC)
X-FDA: 85187078424.16.6BF7EFB
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf07.hostedemail.com (Postfix) with ESMTP id 38B8540004
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 13:41:30 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DK5t8iwy;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788788490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JdqenWViU/7DdrPY02Ze4qYR4l7SaizSPWmzY+qOqso=;
	b=3qzFgZcOXdE8FW+CHw/pxNZWG0TGx3CTqsay8P8XFJ231kOXRc3wylOV3vZu03Lnt/xyrm
	1HN2Ir1Y04SuPIGzcUOrelQBNecbhWaJ7zygXQQ9KX6V20A8B1shQUTlxEVgDUvalerH0m
	OBT5RJe9ysj8rBZESMIgISUEF3u7crM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DK5t8iwy;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788788490;
	b=4k43oKsNrQpQCD5GGK3D+V5W4kpV+1F1MOaq4WY0SRYh1piYyPHf4M5DzaEAWVTE53Uk+G
	wcoRqQ82gDndgnjgKBAIM0hCX81z+WXMrpJ29JS7AEEjxUqXVgbQnNM6mN9tw8j9Cd1Qva
	II4nvtov6+GDw3OFpDTIyq9XIHBL/og=
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-482e067e908so2949612f8f.2
        for <linux-mm@kvack.org>; Mon, 07 Sep 2026 06:41:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788788489; x=1789393289; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JdqenWViU/7DdrPY02Ze4qYR4l7SaizSPWmzY+qOqso=;
        b=DK5t8iwytzM6iTWD4NgpHIxyJ4F9d7MwOg407fq4BcxioDpSYBYObLP5p/KDebSPU4
         jSFXQkwuEI+Tw7MAVP1+yizdzd2XOo/e/XIiV9d+e3OgMr3An5zX2dAv0VS1z8/NsEqk
         IPIPZ7/e4aGGZxKbJWrLiXCFIgc2XZuLJzp1t67xfqlMqJ9to20mxxBFTCwBfRjCDGnI
         kzRx1RQntMiHwFV+LWHzW5acNNQRlhlH879ZKUwBCkiCquca7tFQnhWgni31Fg3nIamN
         CPaB9PXiOx25Gg1xSFyD317/cYFd7PSIiJi3aUQX2ZSjbwNu+1tSVaVnbRerxA300yUC
         gaJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788788489; x=1789393289;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=JdqenWViU/7DdrPY02Ze4qYR4l7SaizSPWmzY+qOqso=;
        b=Zc4upVqa+y7egXal3rosZgwwIAxk35h3YcTobD5t0GrkCjJm1ffpmVGT9L5dyfm7sp
         GNbANY/QxF1IUWUgjPx4PVNokBV46/x+Gp1R7DCXUm4wSp8aIxfgqWLwrfjhoLKDebnO
         lp3yTYvJhiw2WinZzvmOe8GOch6VVWxHaCOH1AHiIBXdB+tbSkohrDAKuLwTgDl9qAol
         FqHzJC/qp+yOz5V60uSKN7cbMWPLPz8S3ej59dTuNlbJ36Ig8DlVMjzaOtC3Wswa557r
         s8c7O855FBcs/hkIBFATKdY6Tzg/7lh+pHDrKAmNG94ZMNS3cd6CewoTvD6FcmTKnljH
         XfcA==
X-Forwarded-Encrypted: i=1; AKwUvBx8zohVmuc+GZw1uICtIbliFbeEJXmQoPcXW0VsPNjCka5pcOFW5OlraKwlvUFlhopDPFyJ5SwcOA==@kvack.org
X-Gm-Message-State: AFuF++lUGXW4EW0q9Kjv/4i6EwZTchrr4xbKdeBXGoPbcwFhKawu6zpi
	PlFuRniHmceVsroDug1nqlP2dGAeFy1OXcPhhrAu21kGa0ewaoW1XIjJ
X-Gm-Gg: AYBFou3Md3A+aqhjG8S1Y8DBAxXMTN8ZKVVfK5rWJFGEOTdCgu8j8Q4NvJYe50CrCyC
	Fdac63uI7a/FC385fIGm3uCcqrtZ95lirgZFRqCTlrb/7aXpSr4kmFVfEyVo96NkXdWvBi5NHdr
	fs0xj9MsQ72AC2rUJK8SI7rxGJNSTDszJXb34zcu7dDDSytQq6GL0wWPTYdpbTRvGLqDFf3HUBF
	S903uBZCnbbY3E+QxbYf91Cddmkh3xNakunKg4PAsybwKewBtJzFeZNiZRsf0DXOOYnhQnT3Dte
	bppsYh5qk9E45EPXsVPYJyF3h5l/NPi/3MjrqxdmVsVHZZYEEXxvbAURSvO6drjwIAvGBToP+Wo
	01+T8GiwlljgVnzozoXYgp3VuT3T6ghSni5YzfAIRzCk/7i/HCyXTHrXm8BRJc9X74fhwldpNi4
	dA9I6sZScJTeZN/cRDvpAisygm/MyJ9ZUu4ZbfClyvrv/EpwdMnl2sV89WZn3fnXxZ2/vU/Au7z
	g==
X-Received: by 2002:a05:6000:41d3:b0:485:8e90:bf55 with SMTP id ffacd0b85a97d-4858e90c0a6mr18822569f8f.47.1788788488633;
        Mon, 07 Sep 2026 06:41:28 -0700 (PDT)
Received: from dell-desktop ([2a02:587:4b5f:900:ef25:2f4:1792:4e6f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4858d312ca0sm28655087f8f.4.2026.09.07.06.41.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 06:41:28 -0700 (PDT)
From: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
To: david@kernel.org
Cc: akpm@linux-foundation.org,
	andrii@kernel.org,
	ast@kernel.org,
	bpf@vger.kernel.org,
	brauner@kernel.org,
	daniel@iogearbox.net,
	eddyz87@gmail.com,
	kpsingh@kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	matt@bobrowski.net,
	memxor@gmail.com,
	song@kernel.org,
	sun.jian.kdev@gmail.com,
	tasos.papagiannnis@gmail.com,
	utilityemal77@gmail.com,
	viro@zeniv.linux.org.uk
Subject: Re: [PATCH bpf-next v4 1/7] mm: Add copy_remote_mm_str()
Date: Mon,  7 Sep 2026 16:41:01 +0300
Message-ID: <20260907134101.424017-1-tasos.papagiannnis@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <0e4edfd3-0c82-42e0-ad09-19ff8b8d1511@kernel.org>
References: <0e4edfd3-0c82-42e0-ad09-19ff8b8d1511@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 38B8540004
X-Stat-Signature: 7w34mn7c77ypawr7ix61mzy1wjqun8tp
X-Rspam-User: 
X-HE-Tag: 1788788490-673456
X-HE-Meta: U2FsdGVkX1+pBAkHQq4oeZbY5uXFkz8w3L803W2Ep80ujse2j0PP9hzR18BoiXuRYepFih5+lpO+VMTdU8REIqLRC8N/2cHNoTp97TLWGcQvMg2hM8K2qhEyf4KRC9ZIIxtIaJsnTrrxCj2qjfOI+70iw5N2JpGBtGllP711y6VqKpqPpc9CU5/YXLr44gEWPVlXDdLPpTQvBa/HCrVKACR+r48RG456SKPY1QD+bci7ZL83OvBjBJLOVybmUQqIr1c9VfakqA1+xcFt7S85H0bNTVXmg0OAzPdyQjkkji/vvx6Fjvf30vUKzqp7dTIjrIUkZuaMojQxW2LAd1pxbvCeyxIhbLX3AlPl9qF/2LQ2+4OEXKZylc9vYlaZ5+nkZ56awyy8PBfEwE9TaRgVFhGll9vQ9DT48qIFgUBzA356LUzVL3VF73L38sr97vRI9gTBYf8QZEd+VEMUss6BaRDuxO1wXiyfIUH73lWHPUZqTVLwRydrcCK1SpisPozWC3aLDFJZjQ/GPWURa1237j4hqCqFyLffUSr7sFduP6yTuZK2BRt3NLZFvPFqkuyh07L9Y17TY1vLORkuiMTGfJsumRGAF/e3A/RbCgAcNko+FFN2Si7ijRg3rUz34U6wGMa6gXy4IvnYif0xDDv5maBL98HcWRLpew6dIH+w5/Kgm3B1NyMhQddgo/MMseLjNpMbxuUHpxJP/MdsLj47ZJfe3V2rwl6jkR1aDX0m8uxqnKZDJ09WuHKVRyBdcRc8OIL0HTXUGiSkIFgrzYiOkCLUF4pSsLe0gAsaL+pWTEyz+T+1DzfC4ivU/ovZijh6xdSvQ6qFgd5fza0QVfgLLG0xo8PYRvcbUkvWJtoYZTWHbyMFDlYikOv01dHKIfvHTQRYy0PxwMMIx9ZdxHCm1LXblIgNh8ytr1YGt+zdf5WezKDwOadBU4U/uDFmy/5F0BaiLyMb696W9DN2pwn
 i1ALIvnM
 VTxuRazr4uchew7KyzOI0XmOhcqHJg4/0jDo+dQpQsJqSL3Ls4deJFVKLlSYa8Pg7oSa87ID/AZ3QQARwKZtgc5/tCWvwys3jpZ8Qk/FFqm9YK0m2tsk0N2IZbrcaBClsJVsI3u9Qf1enaYsuGO265GfCR+3i3lmDiTUCsOXVYUDRxDkurrmUxUMWoSICs9Cw/aDHjB+hCifvujQbdhD/vCXuCEeAbiAhhY35cQbmRX7TGb29s3V7SBbDG3ogqynxbbUVI5RLuJVjUFO+cU4TO/nW9URQApSPBH8ufKToyxgMslKfeEeK4gagrk5dqnF14lOu1AIypdtR4tVzEbAGon8jQy6ob3BpcoB9PmwBRntDUyk3Hc3KEzhT09cC6HlmI7ew/rHp1l9bJ6n+JIEdJ8f4AlLKS98Zrtz1+OUiuoWv6nKqfVyCutxd4HmnrG9EYxMuKfpZurct2+MvYwjReGa2sIL6Usu1CMCMwWC25VQUQ1J9SXoNKTTbOr+0DDaVcAG0x2usBLhWhUqrE9o3EjxU+HVbNa+EucjGPzHkAMdZ/X3vdWCImidcmA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> We have this check in copy_remote_vm_str(). Why are we performing the check now
> twice?

> It should either go only into __copy_remote_mm_str(), or if there a reason to
> have it before get_task_mm(), it should go into copy_remote_mm_str(). Same
> applies to the memory.c case.

Yes, this makes sense. I will fix that.

> What's more annoying is that both implementations of copy_remote_vm_str() are
> identical, and both implementations of copy_remote_mm_str() are nearly identical
> (just dropping the gup_flags for nommu). I'd like to avoid duplicating code for
> nommu.

> If we could export __copy_remote_vm_str(mm, addr, buf, len, gup_flags) for both
> cases, we could instead provide a single implementation for copy_remote_vm_str()
> and copy_remote_mm_str() e.g., in mm.h? (I'd prefer somewhere else, but we don't
> seem to have a good git for memory.c + nommu.c shared stuff)

Another idea can be:
mm/memory.c: MMU implementation of __copy_remote_mm_str()
mm/nommu.c: NOMMU implementation of __copy_remote_mm_str()
mm/internal.h: declaration of __copy_remote_mm_str()
include/linux/mm.h: declaration of copy_remote_mm_str() and  copy_remote_vm_str()
mm/util.c: shared implementation for copy_remote_mm_str() and copy_remote_vm_str()

This allows us to remove the duplicate code. Does this sound reasonable?

> Now, that's also not completely nice, as I don't want us to EXPORT
> __copy_remote_vm_str() ... given that these functions are "#ifdef
> CONFIG_BPF_SYSCALL" could we EXPORT_SYMBOL_FOR_MODULES?

Now copy_remote_vm_str() is EXPORT_SYMBOL_GPL. In this series, we use
copy_remote_mm_str() without the need to export that. Why do we need to
consider exporting __copy_remote_vm_str()?

--
Thanks,
-Anastasios

