Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B73931088E74
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 17:38:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07AB46B008A; Thu, 19 Mar 2026 13:38:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0532C6B0092; Thu, 19 Mar 2026 13:38:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAA796B0095; Thu, 19 Mar 2026 13:38:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DA4126B008A
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 13:38:39 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A710B1B86A1
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 17:38:39 +0000 (UTC)
X-FDA: 84563522358.22.3B45661
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	by imf25.hostedemail.com (Postfix) with ESMTP id 66EF2A000B
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 17:38:37 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=VAVl+l+b;
	spf=pass (imf25.hostedemail.com: domain of jackmanb@google.com designates 209.85.167.51 as permitted sender) smtp.mailfrom=jackmanb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773941917;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zxmi0b/yz0op9eymPAUdVtUuKPtdgHkFrJ50beg8bvE=;
	b=c8LSf4XYdELrroxICzTPNMucAoawfIDruk5vrwRoCr0xRSpfI/xqZteHEO5V5qlxQt9/rj
	XtcsrUfTaXey3ePjTya53IUAQ186CRa3zgba30ggmeztralPH25FlTBUD9s4Fu5kMrplsB
	OkAOdlWJ2B3n2NVBjfKx/BEGcWRggdM=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773941917; a=rsa-sha256;
	cv=pass;
	b=bhE/GV0uFHakxaCfJOLcIxdKDbI8kjlf0Xhf5oVF2xzuAGxgXd3bOMh2XoW4a2MergMBTr
	ymBtCWkXt/9vvlRN/xU6KYx75RRLJTeOZn5ZjcdhtYAZMuCjAQ6Kgr8OPUAL1qT5c1HCrd
	JKfhHZyI4fStpKEdP08uhmj0bXjo8n4=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=VAVl+l+b;
	spf=pass (imf25.hostedemail.com: domain of jackmanb@google.com designates 209.85.167.51 as permitted sender) smtp.mailfrom=jackmanb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5a12d3f8bb4so514e87.1
        for <linux-mm@kvack.org>; Thu, 19 Mar 2026 10:38:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773941916; cv=none;
        d=google.com; s=arc-20240605;
        b=QcNqoMrGFPZLpw9QcaOm/HJVdJBSoQ4ZI4LUrm1ZQeRe7UNxatkL7ywXu2XSVWoR0N
         v1/+9Q/Wu3vUcAL1LREWjy/gn9x+49MoksqlZ87RKCC2F3FAS8yLsfvTp6+EZ1l3gy7A
         wOx78T7QnkWOEGR6Wzap6g/Vw9pBBsfBneDA10pJ1RKD4VgrojwXK61AUyVpwMHacZcV
         V66udXlX6J+iYrd+2eJFv3kXbaVEbe4f5yNShf/EdJVHlIlN0BZqcpYdYL/ZhNtkwsXQ
         RzNiYfSxxRbIJWxLx7fWQim5IMNSYMSqyUI338sjNWsdul2SbY2QNsupaRRQbKxpXok6
         XR7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=zxmi0b/yz0op9eymPAUdVtUuKPtdgHkFrJ50beg8bvE=;
        fh=BZscXrI4PreZKRQhFvwSTWo8c1Jc7HCX1l46dlkMBHc=;
        b=Ng8cGk0OPpqt13viYSH7+m8rA6YnfjrQ3v1Mognh9bhkmJhlP46zHlXo7Cl68gvmRN
         Ft67qwLo559zn032oNnOKeXTRn8mTNTYxe1Ph4mDwcXHO7lwbmIUHh78o4fHgBhGo62v
         tQDwHEgv6Hee49WjJJzx17teeDHrUAO9e9uCDXuA2bd0U2592ALgOCwO8AUnumrJzP1v
         xU1NtXnrwj31Wj70d5RR1Yzq+W532al+s0p2aCj++tmv/QjHzv2Yn1uRDy2HRgl7Wd5L
         G8GazIlMF+yxXNHFSSD0WGfD8bySrwUF94DaJGoWcWZtg+23VCQWYhkSXN4y8s3TkPY2
         yfrw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773941916; x=1774546716; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=zxmi0b/yz0op9eymPAUdVtUuKPtdgHkFrJ50beg8bvE=;
        b=VAVl+l+bBpWxHq10gGrmFGxZSXlqrW/w5sFrtoiNO3NuxNSQHDal9mS5GjQqv2YQFx
         WrEUnEBGlDPuFI5OJ6Ae52RUfOXKsOISL522cKhA7pAgxd69t8hTKGu+YPsyYwRiXPmQ
         ka8hEU+tCC4+6K94r3CZguFFsYg8OVmTv+hxH06T4xoBx9ElOgX8o5w2wU09cj8+EOWb
         CEoqY2jvjPwMCRrK2uYOh7fx5VrNRsJok+mL5vCqQcDzfLKmjV1pR0GKjCUSiepILHE/
         XO4+7AD+2g6C/PsGAEMCvA1I/S1pVhDFpQHPc2eF0gjPgJuzqQ18IY/oMBfhiteDxpLS
         9dhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773941916; x=1774546716;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zxmi0b/yz0op9eymPAUdVtUuKPtdgHkFrJ50beg8bvE=;
        b=G+boNBY0Z+UZbHqHDGd8V8t6S9OLRxKntBFaS4PHe1tb64YRO3EtseI36KSJVTyFs1
         JqiBxfe5dEnyOilpAYJIxWQM8WH79Jyj8ZdjngouM5JzxVKrcQCCicdTL4cBD103DxIH
         xR6lCMLwlKsPmeQ7G0QEfkVqzQBqRxvRREKdcP9KGPeNiDjjP1B7yTu5hT6Qd3vMpWUa
         2QOXlRCLL3cUwjhlkh2jXzpY+/wwUhqQ8ubOowObW8ukgeQlcsvB006xNj9PR4azVAbW
         5xFCW4escEXlYoM1NytExZ55OI6tDNwQFBQ8aCfB5IWPuaKK1Qsn58rla1FA36X67iC3
         1tMg==
X-Forwarded-Encrypted: i=1; AJvYcCUsWtMVIYx7Cc3iJqBNPmPHBLt5vYsHJ4o7QOFPMvmfLhS4BMyAZ0xaJc1A6WYHOjz7ANf8w8WCOA==@kvack.org
X-Gm-Message-State: AOJu0YzUjITYF6ULw9pDPmzhFqeSxx1dfHa7+8ytLiWSiP2zBzrwW+XB
	HyPbHL95L8V5k3b6jEUGXjieTXenRpIo4VQyCIt8R49rfGAz5nZS6hekJgHJzuWneyXtBkVN4OX
	KgP12LSXAtZGbC+/RWc0+bPrZZx7wsPpu5JoYjaEm
X-Gm-Gg: ATEYQzyaag8OZr7WBxb2rwSwUS/g9oPDdT27KR3XRqZFHsLQy309ADJIqv1EPgj+55w
	w1jZcLR/KjfOrvzzHAdcZYJgijcLetT8SBx06IY6zBQrx6rM1M14bW4ttN8SfMFC9yt6GFkZU3R
	V7gqewEhQuiSgzQr/YLaSqUXfbE6VxRbclxwAZSruHflZBp/DoyH0Lw3Q8UD4HaflJLrbTkWkfe
	AHVYOwuISumQtZTueR+E3VIXsk7944zg8ycXoZdBKXjWwl0pH+DvmW9XaIW8Nm++bbdR3FKDAnd
	sqqjj4Ay7JiaWmOnNv8buN7TBd+fAf3YpdM01YgBsQ==
X-Received: by 2002:ac2:528a:0:b0:5a1:27d0:73d with SMTP id
 2adb3069b0e04-5a2855f763fmr11330e87.0.1773941915046; Thu, 19 Mar 2026
 10:38:35 -0700 (PDT)
MIME-Version: 1.0
References: <20260319-gfp64-v1-0-2c73b8d42b7f@google.com> <215517e5-a49b-4eb7-824c-8c42e4db046e@kernel.org>
In-Reply-To: <215517e5-a49b-4eb7-824c-8c42e4db046e@kernel.org>
From: Brendan Jackman <jackmanb@google.com>
Date: Thu, 19 Mar 2026 18:38:23 +0100
X-Gm-Features: AaiRm51ReH28GS8eypWtXXz5qbVr-s5lM__ht0Ottf-Wh5rZqfZBVxcZKaXtLNg
Message-ID: <CA+i-1C1g=3_nK=Xq+OV8KU06YDo18ZaDJqbkfp21Z8G_cnkQww@mail.gmail.com>
Subject: Re: [PATCH 0/5] mm: Switch gfp_t to unsigned long
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, 
	David Rientjes <rientjes@google.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Suren Baghdasaryan <surenb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Harry Yoo <harry.yoo@oracle.com>, Hao Li <hao.li@linux.dev>, 
	Christoph Lameter <cl@gentwo.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Uladzislau Rezki <urezki@gmail.com>, Matthew Wilcox <willy@infradead.org>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 66EF2A000B
X-Stat-Signature: 8xozhfxxuxry5w68airunhiqmhtjoxpf
X-Rspam-User: 
X-HE-Tag: 1773941917-614716
X-HE-Meta: U2FsdGVkX1+2E0+MLW8O/UJX1EdBzUHx6TAQIme+8P4TPzaJl+LY9oHaGszuRZKJAKhvJGUafZo37CG7j6wO4Tks4GwqTLMGh1ZFdMKPKs7qUrpbK0szFSK6wOSNvD40vFvRthQy+wlBTaLEGWzrBGgUISeQCqj3gbRFMyirqrWkddVTOZFcpQV68aO7zTRZpfJGwYbtwXoaZs8fDFvduQMkVunRPGBpsOZVoMuCUn5JlphZvXK8np5PshwPTuibMxeCKYTuWyE+JiIkAFfkPwMzUMxKGbJgwyJX/rz5KGbxiOJmXjwM+kzrtFOV32SBFWtt0NHc6Lxlbl/ATwhLbfJl1bJ3W93VK+8SIVK0sl88XOjXeLmNhWT9KB21Z+RN9LD4jhjmsJu6EkygRrowkPRQckbpMoLuCltbPyYNq6Gh6egXFGankLTmS5S+sg85SglSFwuA9c70oYDZCweBenTkyuq7Og7eDL8xTOEXX0n3jBcNA4iELOwQ5drSL0vDMGOPArdK6ZvEbgnIggF7dr6+GMNX2NqepH++8lXsBHHq9ZEaDjhNYehbq0MPdSeUMvSc1o0lei+RfaN8SXSXnenlj1TkAOyoT1MqLsS1SLhGloqNP6uNNXE+ktB/u4jR1cvjNCXZjVIVPNoV2KDI/P+UeqqruTan1XdnJ2mr6AAdF2xnJ4QyoEMsznuw/t3XP4UgnDuMt1Ie6Veh9XrmZDRaSZm6KD45JRF+ntnc/w2JPen8Lv2XwjD4VYf3eHpnTPiz7mYIXWHOYLRzlyq6ah1NSFVrXwhbjEaG/zigKM5nbXZRGSERFfWs6+crCQyzJVtS2OppygdKYZb/rHhvSIDCieEesOenVQONhLKQdl90zNPHoim4HRyUG/wXHmWjKf0C9CoeLYMRhxus/jHlXdAPuXoUdtmEaMZRbwAgki2QtrbvXlgjPGXQQ3sSnh6ETFZTKZpUQaQrg+In8Xn
 ljRmODp8
 PC3kqVPRk7/g1tmdNO3yq95xrCoIVhleRh0ZcDE6yzCMJ/gCbOP4jv5yi3kkgEd4cruvjOXNfaGqsbn545ETWtC9tuJc35MLpEmOzkF4vzO14ORMI76o1Mrp8pxXqaKAe+kPjnsvzjqbITjKrclxBp2dEThViTFhVyyie5I3kBTHV0TbyfbPqol9nxFktooyeL7xLjrdGqtABf7TtSpO4XK/lbu3hCFQqORKHnedRv3xJq4RsCAdauySfzyOzit/EB+sAZzyqTsVAQ7SiF7LUCae+RXiUXekKP3wvNg4TMNkJ/3NhQ/JbqzGOWrxbXaLW6ipw+c++CPwIp/5F820ex/ZQRLaRfTLg3wzr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 19 Mar 2026 at 18:03, Vlastimil Babka (SUSE) <vbabka@kernel.org> wrote:
>
> On 3/19/26 17:03, Brendan Jackman wrote:
> > As pointed out by Vlastimil in [0], my proposal for __GFP_UNMAPPED is
> > probably not needed for 32-bit. This offers a way out of the GFP flag
> > scarcity so in preparation for this, flip gfp_t to be 64-bit on 64-bit
> > machines, while leaving it 32-bit on 32-bit machines.
>
> Thanks for tackling this! But now I'm wondering, if we decide to change it,
> would it be worth trying to add some type safety too? To help with cases
> like the recent kmalloc_objs() footgun discussed in this comment thread
> https://lwn.net/Articles/1063356/

Do you mean something similar to pgprot_t?

I did that in [0] but I'm rather sheepish about it, I only went for it
because I think it's especially needed for the specific "type" due to
the migration path creating a high type-unsafety risk. And that was
totally local to a few files in mm/.

Are there common issues with gfp_t in particular besides the
kmalloc_objs() thing? If so then maybe it could make sense. It's not a
problem I've ever run into myself though.

[0] https://lore.kernel.org/all/20260225-page_alloc-unmapped-v1-8-e8808a03cd66@google.com/

