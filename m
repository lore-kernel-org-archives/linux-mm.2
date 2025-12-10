Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E933D3E77B
	for <linux-mm@archiver.kernel.org>; Wed, 10 Dec 2025 19:51:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27FCD6B0006; Wed, 10 Dec 2025 14:51:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 256D56B0007; Wed, 10 Dec 2025 14:51:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16CEC6B0008; Wed, 10 Dec 2025 14:51:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0581D6B0006
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 14:51:54 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 70D2CBA944
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 19:51:53 +0000 (UTC)
X-FDA: 84204606906.03.908CBA1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 109A2180013
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 19:51:50 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="h16+2q/a";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765396311; a=rsa-sha256;
	cv=none;
	b=ZEesSg+ijOm9+7T9G+lU3SuYPHHcqCMYWkvS76n2fkK9EahQ8l6B6EgpPQUEqEJMRI7oS+
	HXJYcnd4E2Be0znrFQl17gJlsCpESaCC30O5c8OlEnbMw1tzigSgsSEtEk5qYAuTEiWoou
	JuV/TYSeNTKYRDSy0AC71U7PBwV6K1g=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="h16+2q/a";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765396311;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AgTacFvON8EG6QFjOtITInXZzOpTjY+dV5wDUO7hRQw=;
	b=oT/jfCjVcAmRNs6+f5eoyUNlo5yxkKz9lBu3JI/3W3Kn+5IMvk1IEdgC2q7jWzbX+m7Qux
	SluglNvFqUoKHzcidQ2XMjjwhk3U2+FrE9N3wXsrdszkO0sCITGPpPZjpZE772Eh2V+A88
	G83RLJHNqd7o14tC5Hhy9H8ZJdVlVd4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765396310;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AgTacFvON8EG6QFjOtITInXZzOpTjY+dV5wDUO7hRQw=;
	b=h16+2q/axxfiaSH9cAj6FVOs9WU1hvhs9e8PdAsWgNq2wIWQziyMEqqUTTVCKYdpz4iNzw
	RmaXRxVaMN0CA/gSqHmghfwHeuG/cuNkwWN2Es8h//05YWk3j7ALqSENE/ibVMmMdc/mbI
	eDB/u/VGTwTiqH4EJbtnJhbi9TIEZVA=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-56-_NVDj0mINqysJOm46Itd8A-1; Wed, 10 Dec 2025 14:51:49 -0500
X-MC-Unique: _NVDj0mINqysJOm46Itd8A-1
X-Mimecast-MFC-AGG-ID: _NVDj0mINqysJOm46Itd8A_1765396309
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-8b6963d163eso50011685a.3
        for <linux-mm@kvack.org>; Wed, 10 Dec 2025 11:51:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765396309; x=1766001109;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AgTacFvON8EG6QFjOtITInXZzOpTjY+dV5wDUO7hRQw=;
        b=sTO0jp3sgazJe2VQZvZKSrbpT7rD/sDVPmzBZFHFka8xJxmc9W3Zd+tVBzkG8SHBGW
         bMpxZIl4lgV7r6GoKsRmI+2e4MhhCi+X8EwdQpm8KmSAZWCIyIGKlob9cmkkDQ/DgFf+
         dCkhiXJlsPA2r/jAfpYQ0AuDJk8gcL6K5szD1HbkiazzrX3Ht0ZXnxoEsTq92tV49XjM
         Tp5yCdK8Elv7/wWHKUHN9YcfDDVutm9cVEiDtCLAJ7/axvsbvqZ2LaJT/q7Cnka8EmJx
         AuznXXe1yoRlx8YKfOWC7XbVTvK1agKAVTmAQbNmEdAGLzdKQ//fuexLp4N0AOcBdZuM
         mnUg==
X-Forwarded-Encrypted: i=1; AJvYcCV7ok8QZnvSJqx1p4Ipn8J26MX4aMRNa8lKCl1fpd0yKtueoG4Lii9EYjCzhKaJau6ZlObf0R1taw==@kvack.org
X-Gm-Message-State: AOJu0YxRGycvQ+GzkyLA4iIXgo3iiA83Zfx8pHfZS7vT6iJJEibYFfSt
	jrC2Ea1nQd+60MW1naKaVqBgMNRcAVJcs5NqMeY3H9swz7X6+1XXG4W8ruScGO5Kk94q+HmfkA/
	KkTA8l1lP+7wDbVaedmVz9znNf4zjRGxC+fb0P41RrJPjbh9/JdDm
X-Gm-Gg: ASbGnctxsliiJwuIGLpDnwsfbMxTWkqr/NK7BAFVFe7Npe66xxXBDhRJ3/ISFSnqDnE
	p7SzsNFrV9+ZYNpFsLYs+18xcO+eGVAT3v8B61ujE5r1t0RYcZwfjtinGgcO2j9iJvKl1EMNoOi
	RBRpkvf+tq8xXmPb0JdrQMJJO71CVIY0yHm+V9fTqsRZNL+jTUGtyw5+KAxbjqXRO75w1vlsigS
	0lGlGWTBoovOh/2p5b30Enok5CdpOVsRmWMlJ5oAECDd0fN2iaxZegEopDglnuKP3UOHGAW7hdv
	tV0F27o9i+XttvTsxvnHdHsN8TDMrnh71ECaHPMQmKB21lpPbTlTtmHJYOHZmV3UGDXki5tOpNd
	Aofo=
X-Received: by 2002:a05:620a:298e:b0:8b2:faa3:4c77 with SMTP id af79cd13be357-8ba38319803mr555740285a.0.1765396308667;
        Wed, 10 Dec 2025 11:51:48 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE8yx8A+CBHx6Z8LCFOIAJuCthOtds6H4ec7oH3JAGsNI6sRNuSA+X8f8s93mX3FffFUDJBGw==
X-Received: by 2002:a05:620a:298e:b0:8b2:faa3:4c77 with SMTP id af79cd13be357-8ba38319803mr555734385a.0.1765396308095;
        Wed, 10 Dec 2025 11:51:48 -0800 (PST)
Received: from x1.local ([142.188.210.156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8886ef16adcsm4356536d6.46.2025.12.10.11.51.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Dec 2025 11:51:47 -0800 (PST)
Date: Wed, 10 Dec 2025 14:51:46 -0500
From: Peter Xu <peterx@redhat.com>
To: Wake Liu <wakel@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, Shuah Khan <shuah@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev
Subject: Re: [PATCH] selftests/mm: Fix thread state check in uffd-unit-tests
Message-ID: <aTnPUmEMwymsWHyV@x1.local>
References: <20251210091408.3781445-1-wakel@google.com>
MIME-Version: 1.0
In-Reply-To: <20251210091408.3781445-1-wakel@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: tPgDPWIiqQMKwDhQ7H8LUxYGnypDiZaizBPJOqoriNc_1765396309
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Rspamd-Queue-Id: 109A2180013
X-Stat-Signature: 4bai5zf7sbion1uebtkantj9d33row5g
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1765396310-129286
X-HE-Meta: U2FsdGVkX1/5ayV5tuy5gGBbe9KnJlybRLH3Mpjrvc6Y4irSujqoOUz3g4xxGKrE2vEYa3ECpp3bmxVi7hU432fd6d3Pcg84rihbXuIKEUS+7jPRXL4MWdnBrNaVSqPHoSfiIfACBsuPA+ANu32velAy6bmpqOM7a3yW9a8CVHaYeDf9CpksKqVqrwPY4Q3gnZLPLi8f8Js2oqz9YPgHolhcAs9iAdSkkYtJJk9yw0tsS8VmbEmiN7N56AFOHijVx8eeVtUHLj+MtLErefQA7ICHWF1o+HuSJGEk3HigCyh0pvbzFC+fdAsxVCRsFKtVt8c+2CnHWqjuZ88CRzLjHll+Y9aJzpGyI9xsaP/8jTlSU11g8SBU2ify2dei1O2W8xdaGI1DBtF8VwRYbc0JR3VepSHyfBtfVSP5Ke19oa6XgBI5JWocT6V5xK1Q2LwMOYfWpbFMCauxyjK5Mt7ShtEQaEyu/0USk9LjOMf3FctOrS6xu9NYs3MiXUY1rCkQQ6PpRRGS3NGspL2ONgrb4AopRNnUURDLqMqLcDYpDYG0idD7SMApw0hIG+BzYQLkM4/OIi/IODyE/nU4HrtORhtec7r2v9yLIn4q2q8qEuuGdzoMXuUGq/8Yr1AzbS2cDiCDmjdjIvyL6cGPfP3kIFxHXAew5NCTo+VKXnQ/L4LT0treYSaAbLiMY095sWUMOSQoO7WqSTxxJo0KdB+v1KYnXX4vYIFQEmbBX6xrkcYLHg+6iciwYRAoDWnlgapxTqzV/484T4NxGH3RSwjc1Ph/lrQBfmTf28ScjKOcS0L14/1FgjDasmhDei5HXFQOjwazg/hViyWE+vwA/chdk+4o1o6QYK0fp1xiNsovT69vGp9wEd/NFmkHfSinIU+RNqFVPH+71ArKRFfoBDI5xQOXtVP0hOgD9ap9jf6rUYaRO/TIs4pRlI4+Pgk7o4uFM3Mp3Hw27RaqqkHbz+c
 YnwUZiFh
 lsAipv7pIrZjp+L5iRnp3/YMPnrH9TNcMBmgbZLxmOcW1ynKzB4zKGAIcOkqYse5ik6a+AJ0IFWmAb23sVH8goDE6Zwip5Rw3KXPM0WPrqNx09BQFUdxWLegapq9Wa5ivgeC+kipcdpmLQ5QcaSlnAem4XV3IRCxiMrRIC9skcQkf9SQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 10, 2025 at 05:14:08PM +0800, Wake Liu wrote:
> In the thread_state_get() function, the logic to find the thread's state
> character was using `sizeof(header) - 1` to calculate the offset from
> the "State:\t" string.
> 
> The `header` variable is a `const char *` pointer. `sizeof()` on a
> pointer returns the size of the pointer itself, not the length of the
> string literal it points to. This makes the code's behavior dependent
> on the architecture's pointer size.
> 
> This bug was identified on a 32-bit ARM build (`gsi_tv_arm`) for
> Android, running on an ARMv8-based device, compiled with Clang 19.0.1.
> 
> On this 32-bit architecture, `sizeof(char *)` is 4. The expression
> `sizeof(header) - 1` resulted in an incorrect offset of 3, causing the
> test to read the wrong character from `/proc/[tid]/status` and fail.
> 
> On 64-bit architectures, `sizeof(char *)` is 8, so the expression
> coincidentally evaluates to 7, which matches the length of "State:\t".
> This is why the bug likely remained hidden on 64-bit builds.
> 
> To fix this and make the code portable and correct across all
> architectures, this patch replaces `sizeof(header) - 1` with
> `strlen(header)`. The `strlen()` function correctly calculates the
> string's length, ensuring the correct offset is always used.
> 
> Signed-off-by: Wake Liu <wakel@google.com>

Oops, thanks for spotting it.  It was an accident the size of array is 8
here.. What I should have meant was:

	const char header[] = "State:\t";

That should also work with sizeof().  But your fix works, so it's all fine.

Acked-by: Peter Xu <peterx@redhat.com>

Thanks,

> ---
>  tools/testing/selftests/mm/uffd-unit-tests.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/mm/uffd-unit-tests.c b/tools/testing/selftests/mm/uffd-unit-tests.c
> index f4807242c5b2..6f5e404a446c 100644
> --- a/tools/testing/selftests/mm/uffd-unit-tests.c
> +++ b/tools/testing/selftests/mm/uffd-unit-tests.c
> @@ -1317,7 +1317,7 @@ static thread_state thread_state_get(pid_t tid)
>  		p = strstr(tmp, header);
>  		if (p) {
>  			/* For example, "State:\tD (disk sleep)" */
> -			c = *(p + sizeof(header) - 1);
> +			c = *(p + strlen(header));
>  			return c == 'D' ?
>  			    THR_STATE_UNINTERRUPTIBLE : THR_STATE_UNKNOWN;
>  		}
> -- 
> 2.52.0.223.gf5cc29aaa4-goog
> 

-- 
Peter Xu


