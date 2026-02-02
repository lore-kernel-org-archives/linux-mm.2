Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51A7DD172CC
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 05:39:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A7CB6B008A; Mon,  2 Feb 2026 00:39:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 756266B008C; Mon,  2 Feb 2026 00:39:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6579D6B0092; Mon,  2 Feb 2026 00:39:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 511F56B008A
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 00:39:57 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E8ECA8CC26
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 05:39:56 +0000 (UTC)
X-FDA: 84398415192.17.512CD91
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0BB7210000C
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 05:39:54 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=3ZGsXrYv;
	spf=pass (imf14.hostedemail.com: domain of mattbobrowski@google.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=mattbobrowski@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770010795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oQHxYYh/oaSmYIKd15e37VDf14jUNP+IN3jHPHFgtg4=;
	b=8BReHVcf1fafzST4cr9/9KxufIoazrmNGbSkc4Orq29cERmAUSLJCQs5xLy4TR4MHScvst
	quv2Mo+8cuJ2DsmhxIfYPimjkel1Um9ZB5j+Uc5Cqv7zakmo4RLjSnXiOTqRVF+NPnjCAq
	esd/pHikFSbYBncRbhvkKWVa7yKFFYo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=3ZGsXrYv;
	spf=pass (imf14.hostedemail.com: domain of mattbobrowski@google.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=mattbobrowski@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770010795; a=rsa-sha256;
	cv=none;
	b=Uw6mo2EmOVbYgiq1VNlAw2cY0vpeLdOSo+iTXmDDzi5PhKWb1BCwDOBLmVxAtASLGJtw02
	JdV/767fOCbC4bfkF0lOsybZfilaLx8CXJFYayME7yRbA/vD5I+EoOhv8wh1qVYxflfCOi
	G1ad2Azs0QoISdIQvfqz9oVOUo1D1Oc=
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b884d5c787bso709892566b.0
        for <linux-mm@kvack.org>; Sun, 01 Feb 2026 21:39:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770010793; x=1770615593; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oQHxYYh/oaSmYIKd15e37VDf14jUNP+IN3jHPHFgtg4=;
        b=3ZGsXrYvW09OrzGgUsxHhgPwKdqk/DzdW1V7qr4lju0nOTJIVgqL+AHyeToj+w2f/y
         ctuLH0GLj72qdd0LGznVEGzyJGujsd04fXShA7JJwaJT/5AAFod1wFNB0CEbU2WOadw/
         VJEQ+cf8hDm6VmVrzN6QglCoxjrgiQr8XLjTsASo6/3ufXQSouOZjwTLJ4HgAlXJl1e5
         /0l/YsDzOYiz5uGRi7pEtGBZ+hF0F80SQdaOSlJA1V72QNQkaMB20/5jSwI/3q1n1Vog
         pqPWZNcGDBpGOfwmIloHyh83i5ZPpWuzoyiOGgiXBgfDqGX9g+lB8qYbfE1GwmjA1T1e
         r5Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770010793; x=1770615593;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oQHxYYh/oaSmYIKd15e37VDf14jUNP+IN3jHPHFgtg4=;
        b=OYxPPnLLHYE8v2ZPnyITBbdgAd8Wf3N/lS5tz0oHu9PQHUMkxVE28t0HMDa8Y2Ap3u
         x0PDFl4wRTpXymJ33F+wZfPIVqU3YgIH9wAxhSj81PWWLM3Vq8Qjks9Fo0W/JZySWsKR
         y7dI/0D03DPVGIeOOVAMUR91HsF0PSy0Pxnd/b4e56l7B1FRvb+QxU5am8acI7HsldqO
         /hE5tUKwEcFitkiBs9ujiEwnk5CmC5EM8V+xjN2TtDTrEtzvIfnAAnWmHqobtif4fNAc
         LenAMr1x8fo3XXImc11nHnH0YWbbgpnWERhM/s9RaF4FNBMhdMsax9/zlpUTscXWPmZx
         XHBQ==
X-Forwarded-Encrypted: i=1; AJvYcCVvgINnE6DXm8L6XXzKyPKWWrELQ4671KnI+q5GJ9YG03RFfH0sp90Ndb/jbiTShZVsxEVDEHaDFA==@kvack.org
X-Gm-Message-State: AOJu0YyKebtiDJExWsZ0U6jdGOARMEronRrQDPt5ExZEOFMc2XXiJkMd
	HGinOCiih7aA2+5EMAt0YMt6y4kJGgaCUH8ZE7FNhnFnjdZG1TmTIT94xor/7ar89g==
X-Gm-Gg: AZuq6aKnshWt8fX4dK6pCxP9DgdQcZOKXiZqLj/Ymv0pN4a06KQEBAAUYq7ycUisTVW
	EcjcZ56EZwlStXZIQ8R9b8PFKJocQ0TGIqHZJ8ESwudxL9RfGqofMxjt0e104XEffPwdYqHVT+X
	+VsNYQXV26HBDMsO3OZsOQ8gn/Sff7gpT8aCgBjytRu8rjB1RUKW+pukB4ql8xAjloQiiVuEGLw
	WjP3VVX1Licpv2x3dhpBptqlS6XCjnsPszfR58oIOY3JOAjkdYRHFMzIjdUTPf92wmAG4fjEL9N
	myOUv+n9xS2OAmHkjnz1cCxrn9LpMX856qJ2sZNiHGXgU/nplavjgE2pX6MOsZI/NwkB+lHuaCd
	JRmLB5Aq7OX9rBY1OqkXig3R1EUkCNO4zsutWSpY2wxdedv5zXsxwxw9Cy1H252PlAfnqQMWvF7
	gnSFWVekphrsILcpXSZqwl7XTxrtpa+fkTFOMlUMN+ab/w3KK1jIo=
X-Received: by 2002:a17:907:846:b0:b7d:1cbb:5deb with SMTP id a640c23a62f3a-b8dff5bfd66mr624231366b.27.1770010793134;
        Sun, 01 Feb 2026 21:39:53 -0800 (PST)
Received: from google.com (93.50.90.34.bc.googleusercontent.com. [34.90.50.93])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-658b4691d0asm7521455a12.18.2026.02.01.21.39.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Feb 2026 21:39:52 -0800 (PST)
Date: Mon, 2 Feb 2026 05:39:48 +0000
From: Matt Bobrowski <mattbobrowski@google.com>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: bpf@vger.kernel.org, Michal Hocko <mhocko@suse.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	JP Kobryn <inwardvessel@gmail.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Suren Baghdasaryan <surenb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH bpf-next v3 10/17] mm: introduce bpf_task_is_oom_victim()
 kfunc
Message-ID: <aYA4pH_nIBZ-ZhLL@google.com>
References: <20260127024421.494929-1-roman.gushchin@linux.dev>
 <20260127024421.494929-11-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260127024421.494929-11-roman.gushchin@linux.dev>
X-Rspamd-Server: rspam11
X-Stat-Signature: q35bacagk99bf73irefeqj63xisqjrkj
X-Rspam-User: 
X-Rspamd-Queue-Id: 0BB7210000C
X-HE-Tag: 1770010794-739397
X-HE-Meta: U2FsdGVkX18N2C0RJAY70OIcotEksZCkoOBorUbsJVnlCbUJk+7R6Kf6apQAQ/ghSUm1ELgt915wKiigUyHopHh/+xvE77vi9T6D7SC0wa55gQJmtjVdAn2M9/MAyHqeOd+aqy0OUuSXOVyg0AyY84Pn0juYphg4jUAN0+6MtkER0iNumRchQJwE7ukk0z7vabOi6sh1HKbSERNCNrrgafSY4MGU98n9WPZzTDk2a+Pmej7LM6Ohg9u1yIrzImNqTrBJV5YqW2QP2Rw5NFzDgOWjZvemiz/iwJ+9Aia+pL/sDhKbNZg4CPIQjOUth/zVWod1zhnH9xCcIzbA/aNjMEpPNhnsYJ6teY6moFjvgJfpAAQzLj0Ra2kfnLbYMaRG6YaRmW6a8NS4V74iRFx1b3Qbbw2Ai9XXMFyeTV+iJvzcnYehlVdlbrbcGQjVGmrWXX9yLdRjy5RlGWd3nBiogeuyf1kUvny/ryp3cF3D3ibjB8KgU8i+xNez/DYLqZbZdkcWpfsajeMFb5muu5VbbhVZHg7TMIBFHtNGUxZBQG9+msqfZwsNKSWtExKyemTkIz6tZYiMluXIOdlNiD1s24kFQypdo4qkuMoU4U11yOVs+rfNYtYddZbP/ZXqjOA16IAYLEeILOimzuysvJPiLiDFJNf54L/xQazzrx8YlRlls9ddCOSTeU5pwFCEstb0BgiaGJDUIDwYUqnOccqE1UtgvIqXCYwGWeZzmO1YMhbTZAy8JBI03ABLh+vy+lg9bS2dEIvLtNjBU++0FcJ/ZqlUzVqfL94A3zsP3TvFCypGHXevTW4vwRnUZxwF0veAW+kSN0sBStYMIe6QivxlT/TgjKsoltTkKEEM57nFouP8sC8ycEMf6acX/EtufLoOHQGaljivqafC56PGfaDlzq7VR2h/v9/1qkGJAqCvBLX968o+/5eC/w6S18uMi3xB/CYjjzu9IVnxbWZ+DTS
 3pMNcrBm
 US44XUJOxKSgfCupcJU3IQNStR8T/oON4V90tpMDAWhIV8sN9p0940FAg3xJ0jTUQR/tBHpEFEaukC9n+kRTA8A6YuSOtjZfwSdydQLyrdSj4WzkcXGWXh2SkNwTvNu12YYZhiKmrH/xs8n29BBLrZ6ZGIFBkDKx/So2X9AHLk0MGlRR0GnG+ExnfZ9v5PfbpERRnB3B6yLOy+BodBVcMaYrZImEVfDUpZZlhQioXekoQ8mbfGvBUIYcXh0II65+VjBEf0mVYTWqiCW8Kq/80VWucSAMksXD6HClSeOz6jnCumSb5gXr22ug1ln2JzrhIQXrTkqEPvzAg98y3iQ70KTbcmUJD2oHwPZ+GyRCR2Cf/MdWSYI0gJZzKzavFFmpFhQN2NVbf4PX11jKD5xKFtUIsxTLOyV5Ompzo+B5AE/G/LqPXsDve+ewf4u5zE3OOh6HushwaZxW8Wz/PffFOaqT7tY46hDFZ/FWzI39906zP0xHzoeDuLlNJ/3L3cii0BCeU1adFMdjoecHa1dA94BJSMo8SOK+RKaR7lzxazyzPMs0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 26, 2026 at 06:44:13PM -0800, Roman Gushchin wrote:
> Export tsk_is_oom_victim() helper as a BPF kfunc.
> It's very useful to avoid redundant oom kills.
> 
> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
> Suggested-by: Michal Hocko <mhocko@suse.com>
> ---
>  mm/oom_kill.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 8f63a370b8f5..53f9f9674658 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -1381,10 +1381,24 @@ __bpf_kfunc int bpf_out_of_memory(struct mem_cgroup *memcg__nullable,
>  	return ret;
>  }
>  
> +/**
> + * bpf_task_is_oom_victim - Check if the task has been marked as an OOM victim
> + * @task: task to check
> + *
> + * Returns true if the task has been previously selected by the OOM killer
> + * to be killed. It's expected that the task will be destroyed soon and some
> + * memory will be freed, so maybe no additional actions required.
> + */
> +__bpf_kfunc bool bpf_task_is_oom_victim(struct task_struct *task)
> +{
> +	return tsk_is_oom_victim(task);
> +}

Why not just do a direct memory read (i.e., task->signal->oom_mm)
within the BPF program? I'm not quite convinced that a BPF kfunc
wrapper for something like tsk_is_oom_victim() is warranted as you can
literally achieve the same semantics without one.

