Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1D93108B8E6
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 09:56:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 521DD6B0005; Fri, 20 Mar 2026 05:56:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D41F6B0088; Fri, 20 Mar 2026 05:56:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C7F16B0089; Fri, 20 Mar 2026 05:56:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2A2566B0005
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 05:56:16 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CA40BB363D
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:56:15 +0000 (UTC)
X-FDA: 84565985910.12.7F9CB88
Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	by imf21.hostedemail.com (Postfix) with ESMTP id 03CC91C000D
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:56:13 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vzXAhZGr;
	spf=pass (imf21.hostedemail.com: domain of 3vBm9aQgKCDkeVXfhViWbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--jackmanb.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=3vBm9aQgKCDkeVXfhViWbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774000574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pKpxV/4cEGHvyDd70zFDmsfBmdYXsgVkPbeROZov/kY=;
	b=er2a0VdKHM5BV/UAL2kapxQWYZzUxQNd84JMPjSIRE5uulimLZ+qON9blbBZwqgH/q3Hc2
	tDwmq1hV8W+7hBfwQ3kqL0vnuvtCCnnosfN093g4qzAU/D8c2JJaxBFZPYYE0CgBQj1P7o
	9ic0I3P1zYlH7mHqQWJT1PsyeQyiG2g=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vzXAhZGr;
	spf=pass (imf21.hostedemail.com: domain of 3vBm9aQgKCDkeVXfhViWbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--jackmanb.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=3vBm9aQgKCDkeVXfhViWbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774000574; a=rsa-sha256;
	cv=none;
	b=K6mKn1T848JAA6L4WKi8w+R+MPvk1XA8/gAgtjiROuy/2Y/U0sjIJW6JFhgo53WKyXSDaI
	Fh7z74hlIK9RgWCy5sN/jUfXm4AAn+Vq7Wm6gy2F+5iJ7SpE/vrfvU/hQiqWjdodvH/Dh7
	bfbYeGTAgJpOPdTiF5+Zq1MqIHVXMFA=
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-b97fb810dddso38464266b.0
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 02:56:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774000572; x=1774605372; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pKpxV/4cEGHvyDd70zFDmsfBmdYXsgVkPbeROZov/kY=;
        b=vzXAhZGr2YfrrzFGc8koA0ErLpawy6IFWvOthPNcIhZz1v6YTNIVXHi61vBaozmPqG
         A6PwywACnNSAQZfxnGEIC227A4GhNBc2+9K3ssp8QbHZT/yh745hsIKGHsBo1P0scap9
         Hra6vwNsFuNeqTewQywq+CMmo0vuK6Vk9ZxpNIc/NJA7cxRK22Zdp0HDGzr055QKUvc3
         NwEgwE3St9hzz7ZQSHCGxpBi6pn4BRssPuwsvK1iuxHAycHb4QuGMcJTN5JOnOdZXFTH
         KQeNCDziUmEJxNVNXBNn2GyfZkiEV57X7d7AzC4l+Af/4k7DOyV30/087SRK42sanA7j
         lOTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774000572; x=1774605372;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pKpxV/4cEGHvyDd70zFDmsfBmdYXsgVkPbeROZov/kY=;
        b=JgF6hgy60QnWmBQCWL6ghC5Sb93gFYcZR7T7XPzxXc/CWi7IV92myBt4yCxp5CEZ0g
         jB8LJJOwD9XZRA5pGIqImTgLqCHSbAaDCgCu2EuTa/WH6zxlsa8CGMrfASTqezanS/hs
         QALnHRuYLvqq/jvAHL6yfZcCdYlhDB5Eel0oRddm1Ruz9Fq5u18iznuA4xZEzRdOybx0
         nILUYAIeAioF4MK7glrATMSqYzUwAb8Vkd7q5Iv5zOkKdKgwU/TjY87jC39Nj6xvkwTN
         /H+5xcd8DVQhtFX0ZuzrtFDMvJVoIbsklqqzMEZuwmskE+w/Fb7fQ0oQOOYo39BliNoY
         So7g==
X-Forwarded-Encrypted: i=1; AJvYcCXdkKOxlQnkecbAsUns+fwrulKExAUZtsoUXM5pu4rysYPU2INyGfsz3ubV20y0YOb9OqjIpuDnDg==@kvack.org
X-Gm-Message-State: AOJu0Yz5YdsWlQYJyzbrL2LClE7eZ1uQJ9NsQ/FcpzF+7VBzv55KGDBb
	TJXCAkTNj+AehVfxG693RiV8HjlvV8LleyF3OBbMxl3hYpiOw+N4kQO3IgL0MWwOGYSu/ATAR0x
	5bNq+I+zosHCO+w==
X-Received: from edsf23.prod.google.com ([2002:aa7:d857:0:b0:665:3ca8:7809])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:906:1d09:b0:b97:87e4:7f40 with SMTP id a640c23a62f3a-b982f37d43dmr149532466b.27.1774000572175;
 Fri, 20 Mar 2026 02:56:12 -0700 (PDT)
Date: Fri, 20 Mar 2026 09:56:11 +0000
In-Reply-To: <6ff14b27-a494-4faa-94ed-ebbf63116125@kernel.org>
Mime-Version: 1.0
References: <20260319-gfp64-v1-0-2c73b8d42b7f@google.com> <215517e5-a49b-4eb7-824c-8c42e4db046e@kernel.org>
 <CA+i-1C1g=3_nK=Xq+OV8KU06YDo18ZaDJqbkfp21Z8G_cnkQww@mail.gmail.com> <6ff14b27-a494-4faa-94ed-ebbf63116125@kernel.org>
X-Mailer: aerc 0.21.0
Message-ID: <DH7IPVQLQVDE.1QELM4MP7O5MB@google.com>
Subject: Re: [PATCH 0/5] mm: Switch gfp_t to unsigned long
From: Brendan Jackman <jackmanb@google.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Brendan Jackman <jackmanb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, 
	David Rientjes <rientjes@google.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Suren Baghdasaryan <surenb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Harry Yoo <harry.yoo@oracle.com>, Hao Li <hao.li@linux.dev>, 
	Christoph Lameter <cl@gentwo.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Uladzislau Rezki <urezki@gmail.com>, Matthew Wilcox <willy@infradead.org>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>, Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 03CC91C000D
X-Stat-Signature: sg4h1taskxj74x6fnms5szhiiqqpxid8
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1774000573-478840
X-HE-Meta: U2FsdGVkX1+49vStQAn5YuPSpR0PbZ8i4iT2VPkNA6XDm/fc+7+oNUuYZk7lYseT1g5jBuHj0q46CTLQT6rH74ZrCTtXgrE6bvSCiOc7DF+L7tzcxuGmK3HUvZVXRlTnNdjRh9xw3FchYyowEn7EL4IxCNnGoDjixg8fTkQZR54UxhQ1DNrqea5wz+7QMrdNk7N16M+T7IXOUKq0QiB9vxfg8i7X810jfbtVL+xynX3JMwtKro5nA2SW0ScH//dMeNomoZ++a5esgguOY06wltqojyALGJx/oZvQ7wNuCsh104F8fzw0GMJgKzn+YttOjr3GfSD9IwMBG4zRtslLd3S6osVTp1v0tEQK11+6IxM57Rv1gqseJ3eb753ionu/+Fpm5KSc8aPxRDiv8B0/wKvyQ6NrOzFiky9vvxjh6hlMyRaLZvjXsBodjo+zCVAp4+jU3LAOwRFezc69rJUx8Qs/AeKFctBW99g1oAXuIdYFzM3JyW+3iWm/G8pYYo9s6BpVrlSwZXehuJp6HE3iZHjP8MVcZ6Rd8B+zsf627L+woVomSkSbJMvjJWFjyMlgo3Fz3HNy3rrIw+9TiXzxwcWk1EG7q8jhJ5Xd8BrsxCI99Sc8o9DB3oLQ4JcEO5Wqnb89hNkuHRQ+4uyqtaKjfAjjMNvo9eUpuXkMpHoR8RgmbJ1cZJg/Q0AHo+DInUQ7THFfhbtIb3+iJ83bx9dRMAyVlN71BPcgJHiwlNoukZN+IWrLb+LeE3WokSxufwZstCOVZZjrA05n+bGKRWuIrokHwdLQbLCpegIpYuLqG1ZKH+x7oMfcf3uwqOBOuj21TrWF7V5TopgYmt9joocaFjsCPaniftOnm5InMysXyl8p7rHvPN2unaDVl1rKZ486yRcMZa9gAgJ3kzWE8mNBdzblQf9S2xeBnj9E96pPVLsOhsyhzFtGbJugYPFgUP6k7yQUDM8rPhghJh+3qkO
 LVe9HfS0
 bhA+6qTWNQBqqR6faS8MhIHKCfOOx/SIIRQDL27BLxiNWkXKKhBuG8hJW9TRngJRoJVxK/JHfZ4/qTB1PIeT7wF2O/FKZpG9hijCyxjYH/OEj2LH5dL7aUftVqZFAc0CHqbamc032BvryD3h7AHykVKcMGiirBU4CHjQZF8fKhmF+0fCHsc+QIZH+MDudW6KRqpTpoWdCWD9qInmPbGxNQHkB7U+HJaurP01r8ctBtg7Xg4WqPXM8C0M3rCpMYfId60OGn7OccnCg+RasCnomXmx8Ji9IQz9MHJf+PXBU1041SBO4JuAUJ1KYWgBVXcYqMs8aE+FV9AHv54IyXtBuOeg3hLspnbRWgOkVsfn9gsYeFjEI5eUdjuD+jIoCmRY4eYbw7aAJBu3eFItbkJR1DMae3euJan5TFL4rFXY7Onyw1n7bsLKMNrex/ar5MP0bN0PsQhurrzDXwMZNtKu3cp8hrlKeTrQmjlvFX2Dxf5JvHaLSq6RhvQbp1NpxEvRpJivIQxITj1IbZkF9m3+LvFqhS65ML3p2PhF917J9sn8VlLb7XnWQ+RRcBIyE9Yl6DElHK9qXL4SChe8lcrP5WX7v0Gg5KddkpSzbGPcC2tD7frgO7Vjw4tiFRiAGnNip4r4K3IFekFv3yd7UVapkEgBu1AY+/ocwLZ4DWVBt5bDJOVJm2bdJUzujnrBP9CkAwyhDNG2hhRiRe1XXiVhi4OjmpDlzi7nQA7bGh1WHekBFAF9KHkbJkkW8Z4CdNV4LP5LVcFc8QGgyEIiobcVsrJtXKZgWMIY+rKgN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Mar 19, 2026 at 7:58 PM UTC, Vlastimil Babka (SUSE) wrote:
> On 3/19/26 18:38, Brendan Jackman wrote:
>> On Thu, 19 Mar 2026 at 18:03, Vlastimil Babka (SUSE) <vbabka@kernel.org> wrote:
>>>
>>> On 3/19/26 17:03, Brendan Jackman wrote:
>>> > As pointed out by Vlastimil in [0], my proposal for __GFP_UNMAPPED is
>>> > probably not needed for 32-bit. This offers a way out of the GFP flag
>>> > scarcity so in preparation for this, flip gfp_t to be 64-bit on 64-bit
>>> > machines, while leaving it 32-bit on 32-bit machines.
>>>
>>> Thanks for tackling this! But now I'm wondering, if we decide to change it,
>>> would it be worth trying to add some type safety too? To help with cases
>>> like the recent kmalloc_objs() footgun discussed in this comment thread
>>> https://lwn.net/Articles/1063356/
>> 
>> Do you mean something similar to pgprot_t?
>
> Yeah, at least I don't know a better way.
>
>> I did that in [0] but I'm rather sheepish about it, I only went for it
>
> Right.
>
>> because I think it's especially needed for the specific "type" due to
>> the migration path creating a high type-unsafety risk. And that was
>> totally local to a few files in mm/.
>> 
>> Are there common issues with gfp_t in particular besides the
>> kmalloc_objs() thing? If so then maybe it could make sense. It's not a
>> problem I've ever run into myself though.
>
> I think it's a hazard in any case where there are multiple arguments to a
> function where one is gfp flags and other some integer, and somebody gets
> the order wrong.

I think this is a C problem rather than a gfp_t problem though. Better
to try and tackle it with treewide efforts like Sparse and Rust IMO.

(Maybe gfp_t is the most common type of arg flags in the kernel? Could
be an argument to be made there I guess).

> But I just verified that at least in the kmalloc_objs() mistake, sparse will
> flag it, thanks to the __bitwise annotation. Would be better if compiler
> did, but it makes the case for changing gfp_t smaller if it was too
> disruptive (it likely would be).

Yeah I think it would be very disruptive indeed.

A thought I'll forward to Roman - we should try having Sashiko[1] run
Sparse and read the output, if it doesn't already. 

[1] https://lwn.net/Articles/1063292/

