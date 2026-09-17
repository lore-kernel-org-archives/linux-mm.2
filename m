Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FF89C982D1
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 12:22:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFDD16B008A; Thu, 17 Sep 2026 08:22:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAE456B008C; Thu, 17 Sep 2026 08:22:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9DC16B0093; Thu, 17 Sep 2026 08:22:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A27756B008A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 08:22:42 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 45A23A547A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 12:22:40 +0000 (UTC)
X-FDA: 85223167680.16.251D744
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6A45880002
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 12:22:38 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rdIUclBr;
	spf=pass (imf02.hostedemail.com: domain of david.laight.linux@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789647758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p0zmU2W+3BnffNO8O4v0JPRgPOvlhktXL05mpLnU1xo=;
	b=75K0V9SQEnR9sxTnQtQehE9oW5W5iUaTVUxjGd7zs71PpJsJh+CnscJG8Oh0izeLlSEeSe
	dRtNwuZbeDkucF/hKu/93fR8jFVTiZL156f8qAyHaFV0FUYBIJ+DsGtVfA48D8MtDDgXKa
	emocNUlX2WJkYGnYiXlOL0r/cFgEeGU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789647758;
	b=rgiEiq/FYZknfa5pNVo/coWpZ2KzJYxFHH7dtSRL1arj1hO4KdiUQaeZjsCP+hZJzIoyw+
	MKECMrCIn+GEjPdopZuas9s+C4adzUmxEIT/dhOyNjkknb3Xen2LjTfD8HQDj5OQaTymfX
	6eqO81flfcbG682XaB2eDGoUQG/Lkiw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rdIUclBr;
	spf=pass (imf02.hostedemail.com: domain of david.laight.linux@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49ccfd61ecaso7274965e9.3
        for <linux-mm@kvack.org>; Thu, 17 Sep 2026 05:22:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789647757; x=1790252557; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=p0zmU2W+3BnffNO8O4v0JPRgPOvlhktXL05mpLnU1xo=;
        b=rdIUclBrPiSaNA87HnowJ1kRNKD+DAzNcvdkD3Yj6r6dFWucpfaBXvh9V0AnVULC1t
         rulyBvN5NkwOldbgWwIyTXjWqREOny9ogE+eHxBmGz+S113o2WphjCqRaWYbKy0zvNFi
         Tl1cNwP1DQj2WPXMZ2dnWYKZtvlkKEn+TGZQnsQ55f7GgyGk5LpxrJsWi+hkbCvHXYrM
         kgHxfknhdkV+Ktm9U2sDOHnhaFiJiMC99IxcRKnkKKDSFGPqNZcovAKsFdCBhRuD+QID
         N1flWkvZDNWxpzWvqW0bFLxxsApfRXDryihmGjBjBNppazZa4Q6oWqf3aALbnQh887xj
         Fx5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789647757; x=1790252557;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=p0zmU2W+3BnffNO8O4v0JPRgPOvlhktXL05mpLnU1xo=;
        b=AgtXrGchw3ZOgi8kxexqydZJVRbYO3EqSoYel+H4bW8+1JZJlVgAX+JHwOVBZAHbgR
         v/hctlNI+hh8xcTnqO/HugKBhVPA+irmrZLqkey2fbxy2nuvZUQhjFB1Efo/QZSQjMMM
         aHA54/Y9i6VeNz7CqieH7yEfDPbxRnNTC/3trI+9q+dVRe8qHRqcLYnabHRqWjVRPzlu
         fWiLSkd+ayfiYH4WAAcarsXY9Ls55Txie+OjVhzUhBSNozuyE2fz+zQYP9cETRWLK+Db
         sMeA1oh+bdIBIYSPfLcoFQtT4bKwwQHIfjCLtuXfj/ZYws41Qzlq4TwL78ZyAOqHicbb
         HXOA==
X-Forwarded-Encrypted: i=1; AKwUvBzCpNJ27PD/CJqJCxT0cL9kUEMLo3nx6A5Qa7nM9q3vfzQ5F98uV3bWdS1lauebm0YSxaAWnzkXPw==@kvack.org
X-Gm-Message-State: AFuF++lUAMZgweQcIM2NTTL/ZatfQkNbeP7r7WncBoNoNWAqQOhH0LgR
	3G1TeZ2pDrC6eQe2UldWXeIflrymQBxMvkJHNWOF3q/2f0HQnmqFoQem
X-Gm-Gg: AYBFou2ux4SAYdEQMra3C8ZH3/HxaRTiN5KHoRV4Gp5uyw/9HG3uP2EnUf8cAaFOMdw
	JRMeOa9aJ7pYKwLtlEkfjBVtMZIhZPL3YAoK505PWlTO9fujRrTFuha/7xTP+JvKc6vT1mPaNR1
	a0kRxWTgn24T0DkCG2hz/PATCnU7NVh0BLnZGdzfhBCjnhr0rUi+odroU0h9VVV9djGEu0+qj9j
	PklcA1Xoh3y3KrZYcK56a4Wny6yl9W2XN9yL8cFsAIWiL1DIOp8SXgjDT/+1eYCpoHtGrVdWsDm
	AL0SgpI3P/xOR7Aj0q88GcLpmmiUWsLtsi6PWjr7cQXY2+cNBtjTplE4g/czAOFE/XXmv6lRbqJ
	5pyNuVIxRHmG0ALVqYnJZuMyzwOQFeQj/Q0tet6rtzSC3Hdgetp3DzePjbNHOnVv9a/x3Vn+NgP
	GOvWDiYAmb2wenp3W28jMywL/TP0RO0hhFFalacAjDmSHg++jhhQFlZpFl8uvXDBgoBR0HRrOyV
	xiI/s1uz73IqOopME+ald86Xlb5OJxlQ1Ri
X-Received: by 2002:a05:600c:4ed4:b0:49c:de80:b833 with SMTP id 5b1f17b1804b1-49eac462571mr73688225e9.2.1789647756735;
        Thu, 17 Sep 2026 05:22:36 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4870bef7678sm15969081f8f.2.2026.09.17.05.22.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2026 05:22:36 -0700 (PDT)
Date: Thu, 17 Sep 2026 13:22:31 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
 Jan Kara <jack@suse.cz>, linuxppc-dev@lists.ozlabs.org,
 linux-gpio@vger.kernel.org, linux-arm-msm@vger.kernel.org,
 dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org,
 linux-media@vger.kernel.org, wine-devel@list.winehq.org,
 linux-xfs@vger.kernel.org, io-uring@vger.kernel.org, bpf@vger.kernel.org,
 linux-mm@kvack.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] file: declare the FD_PREPARE() variable with
 __cleanup() directly
Message-ID: <20260917132231.26314015@pumpkin>
In-Reply-To: <20260917-work-file-fd_prepare-v1-2-b87534ca49f3@kernel.org>
References: <20260917-work-file-fd_prepare-v1-0-b87534ca49f3@kernel.org>
	<20260917-work-file-fd_prepare-v1-2-b87534ca49f3@kernel.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: sjg6w8d5tiug4phhksyeaqkdcis69rqr
X-Rspamd-Queue-Id: 6A45880002
X-HE-Tag: 1789647758-482072
X-HE-Meta: U2FsdGVkX19XTNV9pVR4RcVmvU9ue/ZUI7XuC8DE1k+3lbovmTHTvUMwAQqs2HAAMSmQOWFkO7L7MvAS3McJH18IM0HIk/6hmPAzjWLYHblYLG0fzBszkEXHYGOVm8dBbVAHTyBhhYERkseCu1b4m/NeSHeQc/Bf8tTEPw1eoAD0kRdt45I5ryGDWEpB0mhpfPQ6OQp6ShhobpD5Hv7VN+xdMN/kWdjZ/jsl0OzQ+pSqzliaHyJZQzPEEKoB74PrI3EiONyhpHwzrUydfrm03rjwnoE8D+7UNTZZJTE3ZC96N2UyywoNPXVlw4vV1zX2BzuvSQJ6HHPK3QXe8FM6e7Flh3kcTmTG04zhqh0IxrTOREMTAlWs7ZL5yTltPG5+HzVLZM9BY/lEXn7njiLAOFP2iX5atJQ2S0n3IdMYtzucKLXu6YexXQsgCSKe8dxAqXucR0pZd4NhhasPql0+Rd2oYjszzjH5aihRcYuwcilQFlf84ejoEvC8efU0ji4xbkhZ+AROf4LymhM8tAU75HBM3t2Z/JMogXSBAJ+VG6dwOu4GXGwG/ka68pdtpE6sAB4HfxqtyRkgpxE0WDW3014fUruvp72nhgiVdyGMtThRwFUp69bfc9u2LIZmkRYTzgXUPPAckkrvtWPYjsVtdoddTDGXv4mn6hk/zNvDmEGJ7sQfpJJg0tHJIfDZnrqpVX9yJ0EkcTziiQJer0Oz0q95sDm06O6tn55mfEo8goQmJyATXpyJxQykutXPst5qEA2j2v5BqwTun472vcToCsuQizyWIpk9hRFjuqJyWZ2TPUOAm/alQkxqOQkn+heSuR5/ZXJfqcz8dxiUXdoMCQiZlZSXBJvH5PIfgXEfGhdAVAX6MZcRRGOruyxjMBU7xqqQsgHaErw3H/xrffiO8rInU1i5SxYs3qyBlHphGn5lY26qrhyra7cyJbiHjGHCzdh8PblvB1XSWMxZkFU
 KnhhnOw5
 xBN39esov53hhGKZQar9sZBG93w24gH0nT5jZJu88ujob8pYPnMD7Y7K3WS0rTWAyWaHyo1FeD3f8lBHBo9TZoefwMFIhYTkMIjEFImRJduo4T3CNWSYoG7U6lHaZQZIqPQK6Ypt0jGHlHIN+bNXazpUXVyaLRqTyT6adhUF7cjnaj9+lagq7RXgBPU+2WUQ69EvlUuUiIy2aGWYreWRxUplUERc2lCA1QWjb9JQqv3tghI3HWVEQlgSOT1QCOzNNVVLeirgNb4Y23Bscob1AVY2LM40lhtB4ZBihBmZVhs9SvWhZFE2woZWkA2WH3/S1V1VArL4mfL0SPJS0fRd2TpOrD7LTDsO9GTZ6l75EEZJKSvtJoEzziNofd6uq0Ui9Wpmrwf4lVIuMp5kWku9Y2H4G9BgKOAD0tGfMJQg0KRo0AiTvwAVBJuZQptiU02w91B+namPXrX7z4FPAQSp1bTRyjpLMOF9PaYYt3ESf97/8LlP/OiklnxFGDWIouB4uxHxg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 17 Sep 2026 11:09:43 +0200
Christian Brauner <brauner@kernel.org> wrote:

> The whole CLASS_INIT() detour isn't needed. Use __cleanup() directly and
> give the destructor a private name.

It also makes the code enormously easier to read.

David

> 
> No functional changes.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
>  include/linux/file.h | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/file.h b/include/linux/file.h
> index 2b864f457211..926cc58d0b7f 100644
> --- a/include/linux/file.h
> +++ b/include/linux/file.h
> @@ -146,9 +146,6 @@ struct fd_prepare {
>  	struct file *__file; /* do not access directly */
>  };
>  
> -/* Typedef for fd_prepare cleanup guards. */
> -typedef struct fd_prepare class_fd_prepare_t;
> -
>  /*
>   * Accessors for fd_prepare class members.
>   * _Generic() is used for zero-cost type safety.
> @@ -160,7 +157,7 @@ typedef struct fd_prepare class_fd_prepare_t;
>  	(_Generic((_fdf), struct fd_prepare: (_fdf).__file))
>  
>  /* Do not use directly. */
> -static __always_inline void class_fd_prepare_destructor(const struct fd_prepare *fdf)
> +static __always_inline void __fd_prepare_cleanup(const struct fd_prepare *fdf)
>  {
>  	if (unlikely(fdf->__fd >= 0)) {
>  		put_unused_fd(fdf->__fd);
> @@ -199,10 +196,10 @@ static __always_inline struct fd_prepare __fd_prepare(int fd, struct file *file)
>   * @_file_owned: struct file to take ownership of (can be expression)
>   */
>  #define FD_PREPARE(_fdf, _fd_flags, _file_owned)			\
> -	CLASS_INIT(fd_prepare, _fdf, ({					\
> +	struct fd_prepare _fdf __cleanup(__fd_prepare_cleanup) = ({	\
>  		int __fd = get_unused_fd_flags(_fd_flags);		\
>  		__fd_prepare(__fd, __fd < 0 ? NULL : (_file_owned));	\
> -	}))
> +	})
>  
>  /* Do not use directly. */
>  static __always_inline int __fd_publish(struct fd_prepare *fdf)
> 


