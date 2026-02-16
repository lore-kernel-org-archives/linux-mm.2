Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EBE7E81A5D
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 17:50:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0112C6B0088; Mon, 16 Feb 2026 12:50:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED6726B0089; Mon, 16 Feb 2026 12:50:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB8AB6B008A; Mon, 16 Feb 2026 12:50:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C5B8C6B0088
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 12:50:34 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5E8295D4D1
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 17:50:34 +0000 (UTC)
X-FDA: 84451059588.08.DCD7E89
Received: from mail-dy1-f193.google.com (mail-dy1-f193.google.com [74.125.82.193])
	by imf26.hostedemail.com (Postfix) with ESMTP id 69883140008
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 17:50:32 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=C32yGHjk;
	spf=pass (imf26.hostedemail.com: domain of inwardvessel@gmail.com designates 74.125.82.193 as permitted sender) smtp.mailfrom=inwardvessel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771264232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zv95Lg9oAGKyC92FTr/4yJbiWOBA02orWovY9nKn8Ws=;
	b=T12iB3HusKRKSYwVA/qbx4HwfrrwZJchyuqZ1UtF/0Z0JTKS9M39UrbSiidK840nuR7u8T
	KuiaQ0QfyOIsbdG2mld3fGVdqzom+f2nr63UbEYtFVh9EK1T6OG7I/UQOM8jG128Q4s86V
	r5WRKpvxJQckMgeqnPSeWWiK+/VE6Vk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=C32yGHjk;
	spf=pass (imf26.hostedemail.com: domain of inwardvessel@gmail.com designates 74.125.82.193 as permitted sender) smtp.mailfrom=inwardvessel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771264232; a=rsa-sha256;
	cv=none;
	b=nWnJZzHnnOsEEPTZJl8rDCwa/6v/gVDvTruosmeQJBl7MLehLPZhy5joOd+AeVLQlvjwos
	F6zJM3YfKP+kwIzMQXlex0gJ7rmdz/VuteHgx87sDoTnAPHqmmqQroZqFvfDgPG40YSqe0
	qXoQFy+ikRdy+uDOcQyq2arDbVciv+w=
Received: by mail-dy1-f193.google.com with SMTP id 5a478bee46e88-2bd3b0bc201so772899eec.1
        for <linux-mm@kvack.org>; Mon, 16 Feb 2026 09:50:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771264231; x=1771869031; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zv95Lg9oAGKyC92FTr/4yJbiWOBA02orWovY9nKn8Ws=;
        b=C32yGHjk9qJg+lv5u5kzT/cfivphTMu1hO5EzLE5zxcSNbstTx4w2TIUi+wkSQ+s48
         ddjnihHi6kbhYP7ly1vGOUbNgrPrZZx99SnicPYBfTB/DX6s5DSUUIublEFsVp5JN7H0
         e/o1nCUnPSisCDlID8ZRZZt+3Jrt9AQ+ITGbJ3slOFqbReMcmdK2XgXvZDdZpFECSBNB
         p0JC/DlKvIJWJFVoqaR/bvv/lwo9GLpnQWFI9mBxVeu0tmsycSzNQe8Q6oGtGXDf5sgc
         9nzgTSIFvhVdAKmLEN5x/222WJW2p2jT6cgyyew5xQDBKVkJvfaE1JIPcdyALtQ1c3tP
         p8qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771264231; x=1771869031;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zv95Lg9oAGKyC92FTr/4yJbiWOBA02orWovY9nKn8Ws=;
        b=kNZQTHKLjGigKLPLBdwK3W3WxRwIsHEwv13+jIUnTRx/p7GrArXQ5rjl/8h1SCsMtt
         o4X5Zho04YLC0eflNt8Wq8/NAZoaSplcTUQqOoFlZA2iOiKvHKVJCwDRT1WKnMqkv1TO
         yoV6EL4mI6Vd1EDw+Pok9LQ6fOO+E3oTE9QHP4AHH5CrtThUFZDnrzpZLmsMzrfMcWBo
         T+fKt1kWic45fEwwfwJFAb6z71H76sDV0HcBa2ra5sib+LnKjG43sM1y4HSNSYyR+Sao
         wKMUWzX9VzpKnFScpmHnvIS72OsFfD8QhxnOP+vosq/8qrFncxjop8nfOtfTMygJSg21
         jzMQ==
X-Gm-Message-State: AOJu0YwedpBzZP3CAOt8lqQnsD2zjh8UMkZsyRKXeLpIS7VzD8ULz9hP
	ERjdifzR/m0tof7XVqXUCVvTqs6KD2NluOdADVzlGopvSit8l6Q0s/KK
X-Gm-Gg: AZuq6aKf3DlJi3Z77FriUQ96otg8IJ+HBTwl1zcy6nlPSvwjuOUmFME9/mRYARaophM
	ViApu2KK8Dn5jvUI30SDqbOOmVCaWqozbCgZTg+itJhdGiaxImNIPvEbyfbFewOQqOMsmRMXsN+
	Z1O5BACxTYEhjqnQqSd+DmPkQTXPQnfDmoryCzkqdJkBoK/z3H34o5JYQ64kWG0OofhEOgok1Tk
	BoOaMlfqxl5OecaFmeKrSUmGjwubZ6LKErEdA5KUQBBWbgTekMh+gh4/3xSmdlLAo4uBqwvh0rw
	lIbYdYvwNIyCf7J0YL1DPILt8ZUWARamRw/rBXPEYQ/ihJ5+ths3LlKia5DK1HsyqQG/7h+2cDp
	UdRBwEuStAzAOCdlbrfw1E8jfA4NIlHnZu5Xw/VAJtVJkg6N/MvLKzOEvwzlKlPFijOnvemoHE3
	LT6UilY2kJCWk9MUCUSW8Mw2urznw0LIulgIc3w2xk028=
X-Received: by 2002:a05:7300:23d3:b0:2ba:7606:ace0 with SMTP id 5a478bee46e88-2babc5356bdmr5353650eec.25.1771264230825;
        Mon, 16 Feb 2026 09:50:30 -0800 (PST)
Received: from [192.168.4.196] ([73.222.117.172])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2bacb66c24esm10455308eec.27.2026.02.16.09.50.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Feb 2026 09:50:30 -0800 (PST)
Message-ID: <3fe7c5dd-b184-4421-a21c-bafce6aa7b09@gmail.com>
Date: Mon, 16 Feb 2026 09:50:26 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/mempolicy: track page allocations per mempolicy
To: Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org, apopple@nvidia.com, akpm@linux-foundation.org,
 axelrasmussen@google.com, byungchul@sk.com, cgroups@vger.kernel.org,
 david@kernel.org, eperezma@redhat.com, gourry@gourry.net,
 jasowang@redhat.com, hannes@cmpxchg.org, joshua.hahnjy@gmail.com,
 Liam.Howlett@oracle.com, linux-kernel@vger.kernel.org,
 lorenzo.stoakes@oracle.com, matthew.brost@intel.com, mst@redhat.com,
 rppt@kernel.org, muchun.song@linux.dev, zhengqi.arch@bytedance.com,
 rakie.kim@sk.com, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 surenb@google.com, virtualization@lists.linux.dev, vbabka@suse.cz,
 weixugc@google.com, xuanzhuo@linux.alibaba.com,
 ying.huang@linux.alibaba.com, yuanchu@google.com, ziy@nvidia.com,
 kernel-team@meta.com
References: <20260212045109.255391-1-inwardvessel@gmail.com>
 <20260212045109.255391-2-inwardvessel@gmail.com> <aY2BcIHIARSwwQpo@tiehlicka>
 <eca7a8f9-173d-4cb0-93b3-df082b8d0c08@gmail.com> <aZLUm95Y-dKkdBWI@tiehlicka>
Content-Language: en-US
From: "JP Kobryn (Meta)" <inwardvessel@gmail.com>
In-Reply-To: <aZLUm95Y-dKkdBWI@tiehlicka>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: fpdr6efxqpcb5kgzwbjd9x8gs3g6s84k
X-Rspamd-Queue-Id: 69883140008
X-Rspam-User: 
X-HE-Tag: 1771264232-718045
X-HE-Meta: U2FsdGVkX19G0M8t+Z+UBOCJ6xAWWWEOEZ6S7KPavRSMCi0PFhJH8AoIPJfpf2HlxDkkdJGkcfCpDqtdykUXjwiBQ7WMq0vaiLSWm3/eQyG+WpWZ/PckTmLcsll9aqnTOo5ueha1jScVnkPpYzGmsqyilmUFk6bQUGhO/GmnTaDm0uNqAn0K5DyLnjZGjPRYfBMSoVW6FwIudh735Vrgoey7GuuXBSJN6rCI7WwWOP1NlarRUH08NP0SjCuI6ORE6ysu13zc9pinTf571aWxOMrOaCqalhzo0DhCXy7p/N7xvVl+87k5JmgtoRjwBKsvO7FVQxGHKf+PaipEyIvyJbndByjpnci7Sa2dZJ9q/2XMPwc7hL29ZIiYBLEaoIZFH/T/x7B+N64Pi0U2oPrEDXNTMfLYXE+STGq1tcVQEWZCZ0bsfGqb+ZnVucdfIm+1A+HXGevVPkTFCkQnLN3RvqslhR3X03cEnmw2Hz9tA5S0ZQTjlKeMvTT1CePntZ/r+Uhv6Uz/naFr5f+TnZpj7+zeJeWxrDCZDQaFVPEi/qEfaRemPZTcGAX4JLZIWsWRh/javJoS6y/W+KbrIiESnnaX96kmlOIWPyLMzG8qm2ZfhFrqxmZK9IUgLfqT3KPkg1FBaYHYjBVRKj7MQLFEEV9CMsHGQcdQyfQd8uAKQmB8n69cA5uWMTgciX1e/GLU8QStpt7v0Iax4hCvHTaDpnof8JxrXnE13+pMmWSCOrk2UHHI0YZN+OCggNFTIItfJRpppQgrk/IS59NcLXm5RoWcZ/duXvkDF+AGOM673rRWE0l6jq+jvHEpXKpPsTTlgqI5RIc0QvL6r8O1isEq/TmMsvPiXmrAOlDTY6/w826921gKJH0g5337TotU92QhovXluoHeac0NIyQkaIi6DzXNxjDTvzKeNn3PJ4tgqfwTTlCqaJ9y/AeFHwPPCkCB9pixFpLtKOH7nSD5D59
 5o9eOpxF
 HCwXpI/CRLP9qV9f1t2gor0AOVUgpsKUKN0WXjUBmTNFotFoq0WhCciGkAXGI4A/2rGxkZLo4QyKoHNIAIWbkmwtnpQn5ly6srZH0I4KFCWti279L0+bMVnzq9VhLkAPnBgFD5I8x38F5mvIFk5qAvVe099Cq6kgP59RYKaTsuo7W20IOIB1WcRcqJ7iVS9z5UdvS207nSh/u+mRlGXgvFhQwIsLmVtu9tXWD629dX06KI2GGOE7CrIwYqCUxQG3QJN75CNQK7+DQsdPjJDjAS0ffirRZN3ABvX9PVJUBKulkiOWmbmO9SsEDsbO903gjqNo3ku4XnXBewejXIDTUURNI7eF1/WCJAmr+Lgoa2OmMIxNAwoYGbOw3/B9xsghcod8zKKLADCOo9R7nfh92FSVjSIkIr8aIfu+KsRDvR5XtqzjusKUe4sxbNoWTBEU7stlnH7FBccEdJ5VMZV5qXo08Em+K6MUamz1Ly/LFXeGfMdpXDyTuzd7+Sk94Y1ObjHvFN7qBljZVApPbqm7Qtro72YCmyXbcz9XEnfkbJq2EwXaG1pTVQSAtIoBoXbO4577uHqVocLAoz95ynazZR2NMWQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/16/26 12:26 AM, Michal Hocko wrote:
> On Thu 12-02-26 13:22:56, JP Kobryn wrote:
>> On 2/11/26 11:29 PM, Michal Hocko wrote:
>>> On Wed 11-02-26 20:51:08, JP Kobryn wrote:
>>>> It would be useful to see a breakdown of allocations to understand which
>>>> NUMA policies are driving them. For example, when investigating memory
>>>> pressure, having policy-specific counts could show that allocations were
>>>> bound to the affected node (via MPOL_BIND).
>>>>
>>>> Add per-policy page allocation counters as new node stat items. These
>>>> counters can provide correlation between a mempolicy and pressure on a
>>>> given node.
>>>
>>> Could you be more specific how exactly do you plan to use those
>>> counters?
>>
>> Yes. Patch 2 allows us to find which nodes are undergoing reclaim. Once
>> we identify the affected node(s), the new mpol counters (this patch)
>> allow us correlate the pressure to the mempolicy driving it.
> 
> I would appreciate somehow more specificity. You are adding counters
> that are not really easy to drop once they are in. Sure we have
> precedence of dropping some counters in the past so this is not as hard
> as usual userspace APIs but still...
> 
> How exactly do you tolerate mempolicy allocations to specific nodes?
> While MPOL_MBIND is quite straightforward others are less so.

The design does account for this regardless of the policy. In the call
to __mod_node_page_state(), I'm using page_pgdat(page) so the stat is
attributed to the node where the page actually landed.

