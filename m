Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA45BCA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 19:27:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 337316B002A; Fri, 22 Aug 2025 15:27:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E6966B002B; Fri, 22 Aug 2025 15:27:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D7126B002C; Fri, 22 Aug 2025 15:27:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 074466B002A
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 15:27:58 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B941382F57
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 19:27:57 +0000 (UTC)
X-FDA: 83805378594.29.8EC70EB
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf26.hostedemail.com (Postfix) with ESMTP id D3D41140008
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 19:27:55 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dLb4CQU1;
	spf=pass (imf26.hostedemail.com: domain of martin.lau@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=martin.lau@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755890876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tYNnmeG0XprxKHduPvXJ3NDXo6LkvZ9PXIZw0+i39Mw=;
	b=XeRTjUlrgbDV0VaCyb6iIuF1ytRG31zp5CXitolN+KL42LD4wzGY9BYd415AZivvhW/nbH
	NkMkP/TpwCnjhMFkl4E5vKlFt+KQodJDaen6zGachMcAHEiBkavxRqjY9Lyg3h52zULc7J
	UZiMOLGPyTHeaf20LcwA9Diu7J1EXdU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755890876; a=rsa-sha256;
	cv=none;
	b=7uYfO42SHLiLo99BN7wYqO7mJnlBq7YOGr85XuR9S/GsgvY83OvfWmwBPpvXUvwFxxiHTg
	Us8Zkl+UWSCjlIpgjcwZsFv5qmUG5vp+L8PGTA4xzMIHohx++Wr/dv1ODFgPDqbole6oup
	eUPsqerwwN02BeN7RRPeKUq/sUhLtGo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dLb4CQU1;
	spf=pass (imf26.hostedemail.com: domain of martin.lau@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=martin.lau@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <1f2711b1-d809-4063-804b-7b2a3c8d933e@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755890874;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tYNnmeG0XprxKHduPvXJ3NDXo6LkvZ9PXIZw0+i39Mw=;
	b=dLb4CQU1hdQ6WGWVNfKCXMj3e0QSc58PFH34wffAKQg7MGYRyXfGhinDJPLodwwg+E8S55
	COiW8FoozWMKc4A3ZD4LpWWcF1hW5y36YziTryHO0lB+0laZ4U6XnMOQAwTsCqEPrHI8+g
	XRL10qKJMbfZKT2pplmVc6EgeVI0VjA=
Date: Fri, 22 Aug 2025 12:27:48 -0700
MIME-Version: 1.0
Subject: Re: [PATCH v1 01/14] mm: introduce bpf struct ops for OOM handling
To: Roman Gushchin <roman.gushchin@linux.dev>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: linux-mm@kvack.org, bpf@vger.kernel.org,
 Suren Baghdasaryan <surenb@google.com>, Johannes Weiner
 <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.com>,
 David Rientjes <rientjes@google.com>,
 Matt Bobrowski <mattbobrowski@google.com>, Song Liu <song@kernel.org>,
 Alexei Starovoitov <ast@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20250818170136.209169-1-roman.gushchin@linux.dev>
 <20250818170136.209169-2-roman.gushchin@linux.dev>
 <CAP01T76AUkN_v425s5DjCyOg_xxFGQ=P1jGBDv6XkbL5wwetHA@mail.gmail.com>
 <87ms7tldwo.fsf@linux.dev>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <87ms7tldwo.fsf@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D3D41140008
X-Stat-Signature: hdsu6ktn8d1zp1nwcu94osxfpn47eoys
X-Rspam-User: 
X-HE-Tag: 1755890875-861649
X-HE-Meta: U2FsdGVkX18IvU4mTxeE9fajqAT4WEhrhWQD8A7RGD+NLbmeFlip7ZEMzme519YMV3F1blY9OetYGry4XF3WbsBFCqOEvBU05uj8g5zN/QjukSnbr7y4VyPByODwWioiAq2HmvdwmZoEAz4cxp+NRTw2So4Oskr4Bpe2dlSQORAnWuCdsXuVCIsbjGANqKEFGqA5H1O8zi0R/8PCYWknaloewh7wbllrQ/tn1kKumnNyKDKvdtAJqK2D47f3FlpqFEgUWQRjAtYuiAVXRebjOPrDfR3ZVpdVWDhOhBHpzKawLY32Ooh/W1lcJjFAPfOX5mKKr2c4SMWAHVDrzcU96o4tpQ1siybCFaWuR4LFOlyNIP5S+uuLZ031O6z1iKqbEH2cHapj8P3gsgrxjk7zRLBJg1kvlP0cVWNfruGqc62+lT8MJGfPCj+8kCh2mUzQ09L5iYcz3hYr+15O6Y7immzXOk8HC1/GaR9fUQrSs75tkAHbO5yHCKM3Z4ERy7fYWgUvAa5cqifeMMZ67qtGb8InhO/IWXRXUkLhLF6LraHgAK9FelgQcHzVDHsPUEmhiH2CqGuydDDH4CHu2Dbqn6ljNP0bINhoKOf6qy4auARaO8DpvjR2jOBnOQaJs2IfGEOiEUZsRRx56QIrJr6w5J6IyRFDqXksIML+X3whJLzymAGz/fuQ9wctSK3nEtswuwuAFkwn632C1OCwtMml2ZvyzkaEGPKaEGRd2UkjdxOrMcmGi8IMT+LN74MuiLeu8c8cYj4DV8WhvKSIWigmBEwWzl94wG8SG530Q8R1Rz62vYngxH306EkdDFYugZ3L7UjE+1PHnjWwMclsZGvbBokhsvKbmoXe7YgycjVb/LuRQagt4ToInrpKIcVy/posh8bBTHDj0janyGV1mOupUqEy+9ab3J7RBXX/Go4LzqHYD1uS0YRuq66vrcesCHh3tFR4lP4zZTTePw+WOQX
 2KDG4aAz
 cO3kK7LRqRTZDyNeHoQBHWekJm/DreThq1mAiCA5YpOkjE5Vlvc8jiaOQK0PJbSEWAuNZ0S5oMu8Io3avuR8lWmOcty+6CvRPFzfWc4eEdPQ7k8+6KPzsEfHKqhM4fntHk+L9ucQX8FH6T1qH5gk7mg2jjpt+H00fK7ugQY5IKggo1xsYDdoqhXfm+adMy4uGLVxbpbW9orYbx3OJR7FXOQAYWiPuJpKOPYbvG/r7QnsnqzFPf13nwjEs9EbZ64gtJjGETuc08WYjtyv7i8jrOMAzdX+5XFHaDgCvpNHSsY4H4z57BeLK1dnWpCDFZv6AtSCx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/20/25 5:24 PM, Roman Gushchin wrote:
>> How is it decided who gets to run before the other? Is it based on
>> order of attachment (which can be non-deterministic)?
> Yeah, now it's the order of attachment.
> 
>> There was a lot of discussion on something similar for tc progs, and
>> we went with specific flags that capture partial ordering constraints
>> (instead of priorities that may collide).
>> https://lore.kernel.org/all/20230719140858.13224-2-daniel@iogearbox.net
>> It would be nice if we can find a way of making this consistent.

+1

The cgroup bpf prog has recently added the mprog api support also. If the simple 
order of attachment is not enough and needs to have specific ordering, we should 
make the bpf struct_ops support the same mprog api instead of asking each 
subsystem creating its own.

fyi, another need for struct_ops ordering is to upgrade the 
BPF_PROG_TYPE_SOCK_OPS api to struct_ops for easier extension in the future. 
Slide 13 in https://drive.google.com/file/d/1wjKZth6T0llLJ_ONPAL_6Q_jbxbAjByp/view

