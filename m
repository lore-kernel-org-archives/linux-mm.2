Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE1D9CA0EFA
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 13:11:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEF298E0021; Mon, 25 Aug 2025 09:11:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC7308E0001; Mon, 25 Aug 2025 09:11:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDD148E0021; Mon, 25 Aug 2025 09:11:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BC34F8E0001
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 09:11:41 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 65EE6C040C
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 13:11:41 +0000 (UTC)
X-FDA: 83815316802.28.D3B53CF
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	by imf22.hostedemail.com (Postfix) with ESMTP id 741CFC0006
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 13:11:39 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=C40dst5v;
	spf=pass (imf22.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756127499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r7uHrtrZhpgZRk0gGbUgDzQJCGEajHuc5dkdvC0IEnM=;
	b=upOaFWIWajcpSeYT71EGwAIqMS5vgUH9CAnz/TFVoiV2nj3XPnJ5hQ+xkjMkhzPtaEjP9P
	UwA9HWrNhEqegpT28bBDYx+Lu7wUpF7G0hVnSFQj5PPK/cGOdDLushO8CZkDjwdVJtMy5G
	Ckb8FTHhKhaijwxVeS3My4b4nfo7cds=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756127499; a=rsa-sha256;
	cv=none;
	b=XSx9sNc2PDXJKUOOPPdUxfMaiflLbh1S5tKM0zVYVyQle2z2KIcJxq4TcdinxrmsmzxAWG
	szKDJVROrWtagmNzgioOEjcimnbRLdtTLJs5EmHBEP/8UCVkHzTJsXsO5HzdmLQRoLqVC8
	Dnvnnp6SQ0fbLpXq5ILbgutnPW0IL9Q=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=C40dst5v;
	spf=pass (imf22.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-b49d3b48d8aso1095895a12.2
        for <linux-mm@kvack.org>; Mon, 25 Aug 2025 06:11:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756127498; x=1756732298; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=r7uHrtrZhpgZRk0gGbUgDzQJCGEajHuc5dkdvC0IEnM=;
        b=C40dst5vbp4iG6qbj2RQEuUT+5Hd8M5AX2RJ+3H6zEQRnA8NJ6ua2xMxna+vHH979H
         kYNXXr7nQpssGKOY33PSlcK73cobmzalFWzfFWzb9rK3KF9hKGww6RDdBaDqb8Q7Lf7G
         DNapN+E8DVd9AD5wKj5Wx/lcRttFxExULcXYc6BV1W9ZkXwRsBpQ5JLEkwrYIe4YdN8v
         fA4cgzmDabEh2BJa2YB/sXQhaTARg2kZQGU+9Zdf30LtuISaPkaZyVG23FON5ZIA7clA
         GTvw9SMnz8fHmiZUaKRgcs7Gb8Esn593vQoIiZfbNyo/2Dd75FkXeEXdeAnoXj3umJI4
         1lZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756127498; x=1756732298;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=r7uHrtrZhpgZRk0gGbUgDzQJCGEajHuc5dkdvC0IEnM=;
        b=DSzRWBMiqoMiYZm6qKf8ltdNbWuQ8U1EQ/JZIG05FkiD0W6csfsLEmwFLY48SNG3kW
         luHpl51iT9BGyCZgKr5DoBuRStmGEuf55S+rMSQfzBxlBA93Pce8Y3388Oi8MxuYT8fr
         Vgqos5QSZk7t7AHuMxS5xZBvtlH1pn8BQ+amxH/8hcWPaUY4T55OwBHbyhGknYs4gee3
         wMlNgd13IGuf1dvRO3KdZtQAB72+bFwnvIvFGglXrM3FSVQKo/RI8xSZYQzixvKt61B1
         CGKHQ8XxIVFuj+AFIAiW6/HQ1Ls7BcUtcvjBH/YFxLooEiWskHWlL2t5jCicA3B0rOLM
         4REw==
X-Forwarded-Encrypted: i=1; AJvYcCXm/frSjjLyDM45w+AdVTbdGpkQ5SOUqcGozv0noIamqNxr0HbeJWFHsLTzwoG8PBTF57EKndESlQ==@kvack.org
X-Gm-Message-State: AOJu0YxwTP0IPgUl6SH0EGcM8SRyXPZaphq3X9OaJYVAmqfVVGm1pIKY
	YcTnaDprGu9MygPk7KqHQ1rysrfQrXV6xuMEj+RwDNaN2Ys7hZQRzYBJ
X-Gm-Gg: ASbGncvWW0F/Jf/KsOADnQ7yExgnCdfG1rQsmFdQJB55GKLi/jKrK4EMU3CBBOEdTRj
	nM6Uo/4ITdEMcgplhqVMEI9ZJySAXHAeUF3Q1m11YdiWbh9bWpGbg/6EMo5rh9ZopNQZRNdmT4Q
	/UupXnWQjYZhfD0Q+EV/iLx6Uu8zZf/TlGDWO0pXSbD+U4kQql1uk3dfwBQM7HGNSc+d2pjt4PS
	1jK8CYQjlZuO6ylXBenn+YTLrGVqhbgvcV+gtMJdnNPZb8UOfv1bx5k89/NI9ZDpOFw5GuT8so6
	dWhxqkTooB5XsJ6nCN4Doqn4WIh5P/+qhzKseNmRF7AiEm3PCA/UeAyeoa4S6z70N5ZMRMy4Iae
	6FUA1qMcTG2OyoQxuCKRGN0bJZg==
X-Google-Smtp-Source: AGHT+IFbVFBJFVzIAzDQKA+W3eY4HXKeve+wc3ajfKtFsEqnzzGcvnDoGfuQcjBfLypQsN30CCxKvQ==
X-Received: by 2002:a17:902:ec88:b0:242:9bbc:3644 with SMTP id d9443c01a7336-2462efacca1mr191818555ad.54.1756127498092;
        Mon, 25 Aug 2025 06:11:38 -0700 (PDT)
Received: from [127.0.0.1] ([2403:2c80:6::3058])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2466885ed8fsm68579725ad.71.2025.08.25.06.11.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Aug 2025 06:11:37 -0700 (PDT)
Message-ID: <abcfe0ce-0c0b-4717-9069-a6798bb13b76@gmail.com>
Date: Mon, 25 Aug 2025 21:11:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 07/13] mm/kstackwatch: Add kprobe and stack watch
 control
Content-Language: en-US
To: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: akpm@linux-foundation.org, naveen@kernel.org, davem@davemloft.net,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org
References: <20250818122720.434981-1-wangjinchao600@gmail.com>
 <20250818122720.434981-2-wangjinchao600@gmail.com>
 <20250818122720.434981-3-wangjinchao600@gmail.com>
 <20250818122720.434981-4-wangjinchao600@gmail.com>
 <20250818122720.434981-5-wangjinchao600@gmail.com>
 <20250818122720.434981-6-wangjinchao600@gmail.com>
 <20250818122720.434981-7-wangjinchao600@gmail.com>
 <20250818122720.434981-8-wangjinchao600@gmail.com>
 <20250825193127.a0acb9831733e0e51a5ef81d@kernel.org>
From: Jinchao Wang <wangjinchao600@gmail.com>
In-Reply-To: <20250825193127.a0acb9831733e0e51a5ef81d@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 741CFC0006
X-Stat-Signature: ieozs16fupf8qyieu6pi856cmwwsnort
X-Rspam-User: 
X-HE-Tag: 1756127499-996501
X-HE-Meta: U2FsdGVkX1+ktZp8ccuJ5Cx1q4rl3UImJye9LsgMZ1v1mXRNTcAhwf+GgGJtNoDjOFxC+1rYFIw4p9sjK8ig2WKy532EGdK/qH/x2puwnm0PSzOho2vwx29GmVtkruebRZckmoLkIQGsAI2iEGvDyFvBCQQQT+JS7xPZiEQTXth4Vynkn9VT4NJ+JU3xmZDw7CIjr4U/Cu4iReMX/xyjjYCNKVyypGgIqa53RQwIS5O4Bv6Z7pHFl9O5ldP6wrGgrEvTj4oVEm2anuSiMyP2EKVJ7PYI7rJKvpKqElV06RcP6Ff9fCLG+t3nQXFfj8oM6kxWiLgz3NlxgL5AfRZxZDHLEbNXgcyIICWB6Yuq28CqOvYTC2Sx7rKaRK72x7whbTfLYoofPJVhmq81/2+o70DgWv67V6B19TSxGeRGLqqp0C4en+XE0gw2UoU77EwFYA62lxRLe6u2ZqkJHcyl4yVmIoGsAOaV0iMl9NCkfc67kDWnhsBVMrEZTHUpTOrSwRZMKC4Tw/gRiko5k/RYAM44hTtWqDEhb9NM4S4QC4lwNXaEU/8j+kLMgxxF/wReiJ68yuqhzl1jkJvVF4r0D8WKc9CUPMhDl7P1KGk4yayleetgh2qjC3jGcPhKqWG+lxXoIJd9tWdEUhmkffPsARFeqabF/f8is77NcXJWJMeZqxqOBbYT9eL6dB0oVmVjOe1Dw4c2CFKmOrB/FAKDL06aL8LIaEuciQSjm61KGalWrEWFMTcoItiUwPLskiHu773Fc7/BANcrxdWK8WznsmW986QeH9DeTCM7lXZtRUuMXAHaAb7RZ9gnLC9C/VO1Vna/5Yzu2MSEEUJlPe5er92xj0GYTB118kvmVcn8pUMi/GS3AYMIqad6cVkIoAQVxr7Pjx8pulHXKpNJnYFx1VMvt1JxCPq6w8JTGum7KECN7ZNz9pK6h9R1EFCki+KrVZ2/B6v/S0zLdOnJJCp
 xhqi9did
 kc58Tbnvv/A+H585jkeX/RB3gJjcq3IVH18P5IJRy/ybP7e0UJk/Kb+R9Vy1RFK4x16WlyhTMm66R8Ov4MSZi2uU1K6KNEIDZtBTd3SqWbAFq1GTq8dldbuYBZicm89r2hxFia1QOu1pgArIdWRCqoqdaFMuQvWwTXKupRwLkxjW6l4BV3jpQhcKDqwRZUpBxLcP1dJJSGOPxPSffDFQ1xPwxtSJghShIpFp/0b2SwQsCFl/pD72hx9tXWMcRKS17HzqvhS3ldQJd46YTVgnVNDBD+/sQjN2zTyRi546MXSBdA1COCKqnft0ZnM7Su214UtWt3ltgsErNeUVptYRDyrL6kttmNdPDmf5M0Rh69OMbGUDkAfEWdBUfhVLABkZQme2+GdQ34WLaiJrg6pYllU0vpJ7WA++Bsfe8d5l94jgatQ+y4eqjZHV8uD/hRdbcxE4W1TQYAH9VTWEVYy5uzwwAeup6qhqMsRLVYyLxmvmsPzs3IU4RDzw55gRG7h8K244oziGVXi5Py7wFwNz+qOlvp2ZHx/A9XiRB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/25/25 18:31, Masami Hiramatsu (Google) wrote:
> On Mon, 18 Aug 2025 20:26:12 +0800
> Jinchao Wang <wangjinchao600@gmail.com> wrote:
> 
>> This patch adds the core logic for controlling the kernel
>> stack watch mechanism using a combination of kprobes and kretprobes.
>>
>> A kprobe is registered at function + ip_offset to turn on
>> the hardware breakpoint that monitors the stack. This allows
>> the tool to begin watching from a specific instruction within
>> the function. At the same time, a kretprobe is registered to be
>> triggered when the function returns. Its handler is responsible
>> for turning off the hardware breakpoint.
> 
> Could you use fprobe instead of kretprobe for hooking function exit?
> kretprobe is an old feature and will be replaced by fprobe.
> 
> You can find an example in samples/fprobe/fprobe_example.c
> 
> Thank you,
Hi Masami,
Thanks for the feedback.
I will respin the patchset and replace the kretprobe with fprobe, as you
advised.

-- 
Best regards,
Jinchao

