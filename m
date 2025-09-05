Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EF14CA1013
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 23:55:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A53F88E0002; Fri,  5 Sep 2025 19:55:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A030A8E0001; Fri,  5 Sep 2025 19:55:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F21A8E0002; Fri,  5 Sep 2025 19:55:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7B9EA8E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 19:55:03 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F3E93B6E29
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 23:55:02 +0000 (UTC)
X-FDA: 83856854844.12.3CC31E0
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf18.hostedemail.com (Postfix) with ESMTP id 167B71C000B
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 23:55:00 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=VlyNoGPi;
	spf=pass (imf18.hostedemail.com: domain of yepeilin@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=yepeilin@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757116501;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UFjoh0yun9Jt3uWvDF9Z6Ur8uctyhnqqciFXlHuyWmo=;
	b=Tjnb+PVWbiQ5Yb913xf1Jv9FceUZV4MoIC3OqcTa1Hqxw3YXXfyFThT9qEfF6C5Qf4qH+x
	6M+wNf8KmYiMvAmjBrBziIUdy8xz+zDOaP+hf95eKnoPPJKycCcGjQSQfWtiV6hW6Kmwxl
	lAv5i4GRpIDZCUT5dZlqwjGehTpiIsU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=VlyNoGPi;
	spf=pass (imf18.hostedemail.com: domain of yepeilin@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=yepeilin@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757116501; a=rsa-sha256;
	cv=none;
	b=oIhkQ60xDBSKqq4OrHOuOcZ0+jSnEzdc5n9UknSHAzHQCK2cjppk/chdIruNALDqAmEJyv
	kUDqpmAMxsMmvRnb9FezG6mAnchH/hMcO7fvPp6R05Vi7HXEfNx9yzeZIp4uc/Fff1JupU
	ZxVjY+QaWGsdFoEPlM0xZuqQRhLhJdY=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-24cf5bcfb60so61095ad.0
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 16:55:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757116500; x=1757721300; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UFjoh0yun9Jt3uWvDF9Z6Ur8uctyhnqqciFXlHuyWmo=;
        b=VlyNoGPiz0AfMJSTUK5uSw3upMZzZpdkH0cWUWVjaVZ2Df4FPLUcunui0Qan8vRb0m
         mjmLeOmtjVl8nnYO6idfo/UVMSEwQHa0vPs8ZdXo/SH8OGdWZ7XiuH+MgkSYN5cuQjim
         BPv0G2mjR3NP95d4veA3tJbXIV/RuKeY6fG6SpmnQEs9MKfabeXvOU4NupzltAX4bj+R
         6cnUsw+IyLRIJtLXRoicyE+ASH7egs147UoJZzYAUATeJYqLQ508oUaMT/Du4z/mAtmW
         bI7r+JYeDyiK4EmyucQ/4nFtY6IbiM5j6lCioG3SqPiQp/ZbXt/BRr8PlKxxdJ28GazA
         Xlzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757116500; x=1757721300;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UFjoh0yun9Jt3uWvDF9Z6Ur8uctyhnqqciFXlHuyWmo=;
        b=PHGY/TXFs/xl0Wr/YXPHs1ic3YZ/w1b9lnSSzvN8VZgWbynEAsBrJstKe8u6Dprl4n
         rY6rWAFch7GZPX/K2xsh5N5DkEtw6NMCP2Mi2cgGCPvH9e0yhnt+91eoMU37jwnoNZnh
         R9Y1zFusLfFCFMIbGB+16q60exKaxmojtnOKJwwKS3dAknBFCY8GXA53KHbzvynZss2y
         h6aLq+27NoUFzljNg1JcO+NVi80WwlEKcQ0ZiCVXq6TPl9LQIxuCLT144xa1W3R9KVQ1
         qzdEGxRJRptBtrhDqRmMpdb5VLIwdvRcR4VuphwHd0TcS8uKiIHl4M4NsKDOC8UaQu4H
         rtqw==
X-Forwarded-Encrypted: i=1; AJvYcCWsVh5w9FdoUm45JIw1k5qnds+t3F5ytQJJM6MyWazKRD3KZxjXDSZu1FN45zjmAeh3vVZW+WCUiQ==@kvack.org
X-Gm-Message-State: AOJu0YxpLl38+1esYr4JNPdCsfb0WtoxRdiwGeyeoW7nWdjB6x9zTNzz
	lEM1a/Sx8qlVCanTqFMm/X+HJrJql3gs+EiUoeZs9kAlzJWfnsZ2bYCV42p9TWQgOA==
X-Gm-Gg: ASbGnctpCJpYXLB8kvdPEPawUS/6RXEEubZ4Im01HbcOlbI13OZndnn4H+/qYUx/HIA
	fcL8lwEAw1wb/4bQ+kID2uweaIUHkRyq7AvoH8p7ncq+A9dyFua7HLOuYOOtvJQpctiocMyZIUL
	/BdP97f2XdxkVymYLDNqafN71D+xvcN4synCZATJ540NpDk9kGsojtJUgnubUxYEP0siHb/FvQE
	rkikwM+MrJEhVM4++EF79m0pY18b1B8Suac/npBGkYnTBLhuMhg2khp56UH44CA/IUnjUxpgOua
	jObQqHnbhaBzS4cO4iA7dCUTv4dm6q7IIRCUioYaCXKLsWUe+pb8TX+nqajBQLRXJwuEfo+YkQz
	SfoNXU4rfNm0azT39Pwk6nhQnN6V5bQq54ltJyxMb382h+Ouob9fE3NGqgn/9ZGkva/Izr1L97I
	rGug==
X-Google-Smtp-Source: AGHT+IEWOdZEWK6OGKrlJi/++b9kR9pvklbQTGYdOvIZsaWRdSDtHRwHhrXyU2eEfngOzkqrg5CSOA==
X-Received: by 2002:a17:902:cec1:b0:248:79e8:9a3b with SMTP id d9443c01a7336-25119470048mr1579015ad.12.1757116499518;
        Fri, 05 Sep 2025 16:54:59 -0700 (PDT)
Received: from google.com (132.192.16.34.bc.googleusercontent.com. [34.16.192.132])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-329e9fd022dsm11563888a91.3.2025.09.05.16.54.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Sep 2025 16:54:58 -0700 (PDT)
Date: Fri, 5 Sep 2025 23:54:54 +0000
From: Peilin Ye <yepeilin@google.com>
To: bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Eduard Zingerman <eddyz87@gmail.com>, Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	John Fastabend <john.fastabend@gmail.com>,
	KP Singh <kpsingh@kernel.org>, Stanislav Fomichev <sdf@fomichev.me>,
	Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Josh Don <joshdon@google.com>, Barret Rhoden <brho@google.com>,
	linux-mm@kvack.org
Subject: Re: [PATCH bpf] bpf/helpers: Use __GFP_HIGH instead of GFP_ATOMIC in
 __bpf_async_init()
Message-ID: <aLt4TuoFy-83hkt2@google.com>
References: <20250905234547.862249-1-yepeilin@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250905234547.862249-1-yepeilin@google.com>
X-Stat-Signature: h19noyghefm94zn9bw1jm7xgjk8mi99n
X-Rspam-User: 
X-Rspamd-Queue-Id: 167B71C000B
X-Rspamd-Server: rspam01
X-HE-Tag: 1757116500-111496
X-HE-Meta: U2FsdGVkX19jt6ulJ1MYFUjZdKOg5UwYys0wEIYrOtdGVyKXnxdz10K6ZMd+fb773enp+dosFS6BQG6pN3wjO6QOf2XnhouuWdFqLUX3vt7/hZbzqJOKWOOLq7ZlDf4AjobdEiR9N5uvc5ljTYokA/e27UkEhSYlaaWMOWGBym4V9ggxEXEX7iH2pOmdoYF/lkYrWHTdVClOaMT8tyfEBxZ3TIsRFcxTDBlr7KDg+qzIb8HssuQ2/4HiwLLz/GRc0SFszOGFdqVvexT4sdGc+jUicnw42MZJ6Z9a67fJmXMXH9wFSSEjYhakOETgIljLXWNHkWQJEEl+YnxfTvWYsFMP7JouqgmW/kTztX+B53ZCRriXvSI4GMcU18B8GhDRWStXozghWtx8V+uZVcc0el/tQKYUkIU+22ZZc5Vjz5M9tw3wntKl5E0pDC61WAI0GWG15zbAC07xlkMPiZErhzFqHsC+WRy21TASUX7GMGtQRCkhLFOXMjnpZ7MXbMibD0toT4V8v9G0y7ZBWTnHyPLd1zIL06b6f5h3aeVCIj2aKcbJur+dGYM1YFMEhlbxyZnI3wN5Ij8GRJONKsgIB/+2owmGUqtewCFM+W38pu1V9t9DvD9xqTusRE7I5IoZhImqD9U0y64d4ekMbbY7c3IIlejSI9upoDCOXQRupyGxtcuUsbszdVtUXklscUYc+IE6xP6x9xYjGy+o87blvIgqhuvVafAMA7dYT9tbPJ3EeLJSu5W+5Rg/C6rqrI3kmk1o9dQnUqlNT5K/TpK74+A/IZsDXqQXmVhFRm77id2fmbeZBOnrcEJcY+u1tbIvxwtUkcxktbAIQVO5Xf6qOZLWcKU2V7V88IVwGGXWNav8lgj4p5arDLeT14447tNjsLXV9PKG6yUXxVd3PajkSjmBHfQiteaBg76daHxU4tBmqDA1BwExTTYBOF1GSqWB44ekV6p8h8QO4rLsN4q
 of3PcLiU
 r+93aR1jxmh3eXjhjuAhAZH37XtDCSgF3R+67YtCoUm9EZxrxhOg+joV6ncsP4F/8mapjeOKcJ2154OL9Giofi8AnihYf8s19XF2rbepwFWdiIzCTLgfLDNjhcIGADL7qjKyLtyXVu0ZyY20SsyJwr+yr2bp+WUIOXa9sKtSYeTpIJVPWzAP/yBZ7uyMhLYdv9gU+o41PchkKBmS8NnHd1S5Hld5xTPxOPsMFH4M7H7vmpvSZpgDYHuPIlVzxkHiF89rbqjvHqMwdj66zmHaw6aZDlu2+8EkWVz+epv86uFu0lSH0E1YV2EQVIWBxUu93rFvCSPeU+DmYJ0BCk3diZBx5JPbNbkWljukcXDv7QEWETNqXxKlXsfYKJzBbX6hogrGIWnaiVVQNcWvjPYo/qP2qxYPEzlJZYnIplktAwlKN04RTxi6RFqjyKwLffWM8YzLyIdOpKVGTqVsQgM1aTdNPV9eie2ojb2530bkHsKEl8aLk+chquJmLOkhwg+anUXcHerqHjy3d5t6fcbgE044PzQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

On Fri, Sep 05, 2025 at 11:45:46PM +0000, Peilin Ye wrote:
> Depends on mm patch "memcg: skip cgroup_file_notify if spinning is not
> allowed".

For context, currently the above mm patch is pending at:
https://lore.kernel.org/bpf/20250905201606.66198-1-shakeel.butt@linux.dev/

Thanks,
Peilin Ye


