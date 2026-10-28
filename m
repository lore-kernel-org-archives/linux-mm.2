Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44799606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 15:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=ZQZL0HWt
Received: by kanga.kvack.org (Postfix)
	id 5616E6B05B0; Wed, 28 Oct 2026 11:27:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 511E46B05B3; Wed, 28 Oct 2026 11:27:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 400916B05B4; Wed, 28 Oct 2026 11:27:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 193576B05B0
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:27:49 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DA7A48013D
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 15:27:45 +0000 (UTC)
X-FDA: 85372414890.10.0E03B1D
Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
	by imf23.hostedemail.com (Postfix) with ESMTP id D0D2E140004
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 15:27:43 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=ZQZL0HWt;
	spf=pass (imf23.hostedemail.com: domain of chris@chrisdown.name designates 209.85.161.54 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793201263;
	b=jK5E9mZ5GiQpLx4DltPe5hddDjGxyJPKfceAcrOV0XIhzoKD0wCVGklYxmRkYEWjzPxWDZ
	Vv5e2P8lH3tYULDx936Vv1AlCXbwso8W440cYMb/czY5/f1VAf5g5LHvEqNC115DdCogA8
	yld19a0hVlYRbSbFvj2JJDuC1oO6XYQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=ZQZL0HWt;
	spf=pass (imf23.hostedemail.com: domain of chris@chrisdown.name designates 209.85.161.54 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793201263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RvKduUdpqvn57pENoGLB6F2PlOffkxBgVZHDYg1GsYI=;
	b=Db10wMSuDShcxOKr0nwomreCzhDNlMyxdlH7/G0jTjf3xXai3EvolZ0zGn03AP3fcCt5wP
	99MZ+JRx9JS8Q/4q4rGUJJEP0VhZoxQQnEdU96VG/S+0eRn6PTFSTUnZQPUoed1HDNfV47
	S2ICUZvw0BhuOwKesAo8Ki7SP7bUSQ0=
Received: by mail-oo1-f54.google.com with SMTP id 006d021491bc7-6d290b10a35so560733eaf.2
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 08:27:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1793201263; x=1793806063; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=RvKduUdpqvn57pENoGLB6F2PlOffkxBgVZHDYg1GsYI=;
        b=ZQZL0HWtooaGrrROzWTjK+vKCa5B2l7bgOW2Bg3ilBrSXejuTdbdBv1Dl9ncE3BCBv
         Lz+jiLTq9PuFncgSzxqxTHUwZDXP+jOqsSXA5vRBr/IFzWy8c53+1y6y3stGZoZo+UNu
         StO4RravJX0rBI1WFcOoXXVcXQjXuJKUx2L90=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793201263; x=1793806063;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RvKduUdpqvn57pENoGLB6F2PlOffkxBgVZHDYg1GsYI=;
        b=kUTsUFkaYPh3v1kaYI8Os+/0gwWWi25e3i3BF6OpKh2R+QPTW3javjVszTibs+janF
         JovekUfPUNjuhg5MGvBnty+2iQaTep83y01w4t1SxoHJcNzJaRCkB8kZnSIjXUr4BCMu
         cL2qLhxXuOPQRcSds6Uv/zeDjPMReK8BcfYOpnoRJgU3YzP9brwArP2nVwvJjBa3+pUj
         9tCKlNO1x2dREw+8cGgiXCgLjL7PhxKzNFMi78apB4PT3pskUpue6aahCLPKq+uTaJOC
         B4V0NdSCsAhC+jtm65T0Lt2D0L06bmPFOgQ3TAjk+NHx50UwEbAkCErqc64gtPtYa8lI
         6U/A==
X-Forwarded-Encrypted: i=1; AKwUvBxP9VwKO7SdvCCRfjhtbcplyduq0+vnb9p60TVgxdIdvkqKLTO4qNJs+YNYQhW7XWhqLjU20cKobQ==@kvack.org
X-Gm-Message-State: AFq9FYLb2S3d25cNiZ9awA6tB3xB0fgkykezp/EyVTI7bGpBQKRHVd/v
	z4LVeosWhhUF+DZXfZ8D2bUWR2SsGZ+awOpDYjlh2IlCPEfVCuqzWoSV7GgDtEbPo14=
X-Gm-Gg: AYBFou3iueN6m2UHM5no6dbMquI3U6KNAg0KaJ0+T4C29kdwCKQ1fyHngTebg8xLkoe
	2qpKiU20U5ioPiKvEdMtqiubWxZAba44WRZ5+puSr2+r8bsGPUz22Ex5MY4iUHzEEnFfeZ5XpUK
	WMX0DoMzqX0CXgxyqqeGxNMDxHph7glFSf6iUiBFc3v9cdNyj87tKRxCIW2/HQTqwvs1F46nwRP
	DHepGX1wgi2KCsR3kkZxkvXg1rD1FJrqJ4ADYotUqMWiSMrM0GWWekGa/ohw4TVUV7+/Y/C7n7P
	NcMW+Xmp8RICtRFHz5sfM2V0cw8tKv10JuybCpN0vJf3GfSy0VK+krjMt786OqXpasfDfEqYEg3
	k2cz4CHI3NtOWlZEkCEuqZW0D/cDCJaHxCvZ7h0w5XvMilLQDGIXOgXEwIlgXy1EnecfSrhvE8s
	anItreorMpV2dvByPdsNimam3YjjhCpOTGUfCCSYxMQBIFJf8sbWl+gK5b6YNbYfW5JkHOubP76
	iwDoTEjDpjlsgAWMwY6ot6LRpK6/achvd37ZLmpOJjvu3HQ1wqzhXT7yhP31rQXUbuTyKKAVpTs
	jI+pSNbLi3GXkOH+ozjwoqVvlmUR/z8z9aUhp2N3X71iY9i/XiHsZZvYGZ/J5/bSFPwKXNbzolF
	bB47Q1dAMACxQI/HPRo2cL6NmTIUVHhxsuU4w2w0aSM59Z03UmxjkUm+MjiWoFn3bejQK8PmVai
	rOj2bu8ogDraZ5tVvUaQ==
X-Received: by 2002:a05:6820:5718:20b0:6f4:d9d4:3948 with SMTP id 006d021491bc7-713ee7665afmr996593eaf.45.1793201262701;
        Wed, 28 Oct 2026 08:27:42 -0700 (PDT)
Received: from localhost ([116.86.153.182])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-71429e7b7basm1517856eaf.1.2026.10.28.08.27.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 08:27:41 -0700 (PDT)
Date: Wed, 28 Oct 2026 23:27:37 +0800
From: Chris Down <chris@chrisdown.name>
To: Harry Yoo <harry@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Kees Cook <kees@kernel.org>, Marco Elver <elver@google.com>,
	GONG Ruiqi <gongruiqi@huaweicloud.com>,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Kieran Bingham <kbingham@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org,
	linux-hardening@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 0/8] mm/slab: Support selecting slab hardening features
 at boot
Message-ID: <auIUaT6LyEI2cXpj@chrisdown.name>
References: <cover.1793086056.git.chris@chrisdown.name>
 <auIN44CnAyzvR_Ll@thinkstation>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <auIN44CnAyzvR_Ll@thinkstation>
User-Agent: Mutt/2.3.3 (9073d26d) (2026-06-12)
X-Stat-Signature: swd3ks8ggco9boip349qs9xczkxgndpi
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D0D2E140004
X-Rspam-User: 
X-HE-Tag: 1793201263-755684
X-HE-Meta: U2FsdGVkX1/HhJ8r13/J45YE8h2QZxRXJRX0E4q8tl+CHaNxorSo1224SMmJL0/ILHusu5Ha8PL5vjPSfwziz7xBFwgOlpnTveDjr521yuLQ29D6QxFF0HwiCp6fmsSP2QQlxHmlPAEe3MzJsiE7ByOmm3q+Qlwfk1GYzldgIGQ1cC2ur++A61KWYo5LHqa6J2rFdY/1nfxUWvj7HsdZMcIW5mqJkUTJAki/PlNatn9gaF6JTwew/6xhuYKwvHE5dWHuyComcjxA/WYWG0aA4RDS26dwVCpZ98wCcCt01uMwxMDQMGRaOf3FlYYxSeJz0UJFmTZhQn+XMrXY1Y7T19jZ47UIU2U/wDRLA82KSApyfLEgf/EQTwbzG90J/ocBg4ZyLMUmlBXXW/Ln31UHFRXjPhuFxxmLFVGrirABKQOKy+eqORFifXq66NWXU5efqFWqqrr28XfYUjhSaxFtAqMRwUj+iCw6R1ew/7L3tVSI0A0C1VV+VG2D0zN+zAeoIf/FmTar7ay22KEX1OMATPkhlU0WjzRqcXMrn2zwLxoWZDIHLW+Hs/5U60MjwVmUZW/xASuaSnIakuBgKBlb7LXl64DcTYb8x4IFYul0rrnmOrBmGLWo0MSFoK36WkKjtiBCCObZz1KnGNKCJi6bvB++i/OXQduf2nIRiN/XxPPNnhQKM6FVUE4YXle/CPXn1jgei6mVG1NQ1UwZJkPh0BqE0xEH4sqqJUqM65DgirG25p1BQafZnuR+uAw06le+sxKvqvwPHTZuBIuzu1lP3H+m6aGbK0PXc0Ot47HG7E8iILvg82PZXhJc133t67q6MAwkUTiI9/aa0qOc1xTCm/FLFHs60/TvZUkZAKtvEUAg4YLfcfmb8VlLHXu7w/hVn1hQwbNBnIPcWaMsncNuxRoNEoKdEWka/rWoMWcAXprgKFsQjPaumPEvtlHyGx9DHpH5yn6E286G14V0jKe
 d1I3IP8h
 2QCUaLDin0ptYqIx7nqQlrujtzt/rvflcARrv2jssC3b1dMAHzkmapgEGf9uNVkrh0TJtqOwXY5nmYjoSJrV4uh4x4qel4y9Qd5tJ69mQhssOaUGyBHSwITAdKkgY4lCJOeLOcB60KxEwD7GzxV2gRBhSBT4u0S3AqoJ2ZluyW4O54bSIE+EE+drcUSDyMQB5F7UsAI1dKzv2RMDgxyYBQt87kb4uk6dOAQQWbUqRWG63Xu1RvXG+2ND5hTJE2W6dOWZ4t8Oit3SjTKH4XZKS7sfBkqj1UXRjjs6w5LD4JtELIqjIt2LGVAcwJTVPZLcEJC3qNSMa3SnbnQ5+Zo3FgZnnnuBI0+9x/YId9IVBg2aSuk3wJhqSznMjm8wsQy4lo2Vna6ygZKpeeuPes0q7tODIZitVHn3AEVrDLCFOouLCngPM/in2mCQTtIHyIqc/4bqrOjEYYq2cjd9CBluhKsr+IC1jyYYwVCkurIDa0G9ggZnhgKKS0jzEuw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Harry,

Harry Yoo writes:
>If we end up supporting boot-time parameters for hardening,
>I think it should be all enabled (or disabled) by:
>
>  slab_hardening=none|light|full
>  # please feel free to suggest bertter names
>
>none: "Turn of all of them to maximize performance"
>
>light: "I'm willying to sacrifice _some_ memory and CPU for security"
>
>full: "I'm willying to sacrifice more overhead for security
>
>IMHO more fine-grained knob for each feature doesn't make much sense.

I think if we did the 4 knobs that is a good idea. Given now it's two, I think 
it seems reasonable to keep it as two separate knobs unless you object?  
Otherwise I think given it will only cover the latter two, it should be 
something like kmalloc_isolation= instead. Let me know what you think.

Thanks!

