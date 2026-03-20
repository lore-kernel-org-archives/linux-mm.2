Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9856A1098783
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 13:23:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD2CA6B0093; Fri, 20 Mar 2026 09:23:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAA006B0095; Fri, 20 Mar 2026 09:23:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBFEB6B0096; Fri, 20 Mar 2026 09:23:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BC8C56B0093
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:23:01 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8BBE856731
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:23:01 +0000 (UTC)
X-FDA: 84566506962.18.A2534E5
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf03.hostedemail.com (Postfix) with ESMTP id AC29820011
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:22:59 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="Ktc2KFA/";
	spf=pass (imf03.hostedemail.com: domain of 3Mkq9aQgKCBE0rt13r4sx55x2v.t532z4BE-331Crt1.58x@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3Mkq9aQgKCBE0rt13r4sx55x2v.t532z4BE-331Crt1.58x@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774012979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GUDqodDk43yn3drXIlYhMhMKH+w2qm8q4A3+LPiJy1Y=;
	b=fWx2vnzLgezZqJJDm5B4xAu6V/lyiM+7OnfCG7wPco5cYS27pJHASLa9eekowHa1gMtgoD
	9+7VqvBGjww76uG3GmOJV/GCivbQhxExELR7sYk+XxzpyQJQYx4ZsTOHWZ3e518QmFks8f
	HWSurjvX8IxO7RjOGIK284s6qK2TBe8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774012979; a=rsa-sha256;
	cv=none;
	b=DLxlT6BKd2AijhASb7HJJALqfx23kj/S+NawCAF2zVhmOkXvuaPVesf03sZNygHq2WQxwF
	Hg5dZxjHtueyijuJzMQXp974sJhmeIcwDt+6+aoGdmfhwfH/wuSr+MG/SmAe9DcBbHhh5v
	O6yJq2uv2NGTKMG9Y8M2NDr85ghT870=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="Ktc2KFA/";
	spf=pass (imf03.hostedemail.com: domain of 3Mkq9aQgKCBE0rt13r4sx55x2v.t532z4BE-331Crt1.58x@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3Mkq9aQgKCBE0rt13r4sx55x2v.t532z4BE-331Crt1.58x@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-486fa35b005so18600685e9.2
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 06:22:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774012978; x=1774617778; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GUDqodDk43yn3drXIlYhMhMKH+w2qm8q4A3+LPiJy1Y=;
        b=Ktc2KFA/76+Vh27yb2IOgHZqWhGwF6Xldkr59BeItQrzIcmj5hWC8cOj8WOAPyYV3j
         9lfDWEvkScn8H5sBRvTz8C+blvMkKTKs/sWn3R/p/4zPpTNyNi3kp480EhNVE0fUYG6w
         sKLbv06h4BuXdl9QxA9Yav2LyoUGPa5QRab/mT1DcF9g+h56GbSHzGfE+Pp8cWAO7FBv
         NPipyn+kHVRpeFjvRMk5RMVeY+VbnTv5SiSfx6LuFz86city/v91/aXvprgJvygXMy7T
         ljygBPeYibKrmU+Xk9nTPgvFwnl16gJisJXdmWmJFYBdUnwCP1GqoFXg/YJkCvBHtevK
         QnVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774012978; x=1774617778;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GUDqodDk43yn3drXIlYhMhMKH+w2qm8q4A3+LPiJy1Y=;
        b=AX6vd1+r67NUwP9OlSFD6+gY2keOiQwrED9Uw1m3x/2eP/0U087jJBajrrFsrUkSlB
         VFeEbngFabxSysHM2uOQwiMfdL6GLS4mzcsC0TshBP9VOUXi2bJhZFxLJkE2oWDm8UIe
         +NXS5Zk+Pt1Kg2+K9/fTLzT/KLLpA2V74tb0EymJ0gS6Ll5eXigJVMSUlDoQn3ykwjDR
         eb1pJviuC9MTdDhgcJNoBXzmalh93QrKQ+JRAt7SFxPCP2Jc2eyh5/WwXUF5UvtYpnFY
         hOfR4vPBYZoe57eW3ljAPK30L64Zh9YTnilzOtD61oxJUlgazXEi4I9zwl1B/waGUowk
         dL3w==
X-Forwarded-Encrypted: i=1; AJvYcCUqMlC838ZdV4kNCbneVdU2eq051+l8n4ia9Pp2j+egJZeutolrIsFElEeNu8Awv/qE7CDAxLSjZg==@kvack.org
X-Gm-Message-State: AOJu0YyEIOZ+WUWsTOWYtmx2SjNKw4BvC2p3Cheq1AmpsGP6pAAmJ4/c
	fNc63AEgxrcBP4py/IiFRJgPZ8ciRaxsOTveIHIeoTmWeEQ1Nv7D9GM9QmJKmzwcdzqk51PzXrW
	XFXcX6SiM5lKTVA==
X-Received: from wmbdx7.prod.google.com ([2002:a05:600c:63c7:b0:47d:5bef:a379])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:c167:b0:486:fab9:a578 with SMTP id 5b1f17b1804b1-486fedc3843mr45048705e9.11.1774012978000;
 Fri, 20 Mar 2026 06:22:58 -0700 (PDT)
Date: Fri, 20 Mar 2026 13:22:57 +0000
In-Reply-To: <DH7IJRSKJFFH.36UW4MCZXCYWC@google.com>
Mime-Version: 1.0
References: <20260319-gfp64-v1-0-2c73b8d42b7f@google.com> <abwqq28hWXMLqa5P@casper.infradead.org>
 <DH6Z95PTZYVF.3K64RCJC06GEJ@google.com> <abxs9k__wWWLL2hb@casper.infradead.org>
 <DH7IJRSKJFFH.36UW4MCZXCYWC@google.com>
X-Mailer: aerc 0.21.0
Message-ID: <DH7N46W8JRAP.1KOGS4T4NIUGB@google.com>
Subject: Re: [PATCH 0/5] mm: Switch gfp_t to unsigned long
From: Brendan Jackman <jackmanb@google.com>
To: Brendan Jackman <jackmanb@google.com>, Matthew Wilcox <willy@infradead.org>, <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, 
	David Rientjes <rientjes@google.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Suren Baghdasaryan <surenb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Harry Yoo <harry.yoo@oracle.com>, Hao Li <hao.li@linux.dev>, 
	Christoph Lameter <cl@gentwo.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Uladzislau Rezki <urezki@gmail.com>, <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: bkttgwnm1a9ub1pwbe17q7riehtkm83o
X-Rspam-User: 
X-Rspamd-Queue-Id: AC29820011
X-Rspamd-Server: rspam12
X-HE-Tag: 1774012979-47923
X-HE-Meta: U2FsdGVkX1+95/kbXHorUW7kcG5pxp0rh7XwielkLoQJQgyJKh0w6EcJYakcDDNPMVUydPSJVrZnFgDwT4lNxLlyPiTD5KCpu2zJ24aW3TQGLGPQhvQ0cfFygTi3r1IA5tW9veFg3r5BHDvj/uY6JzoyVNj7Uuwf/+8AY2yCOpEOujDY8TzvkgYCUmWAWdJbD0z1v6c7ZoLFjErmEFvHq5dwlGaY9oLnHEmm9IpzPswMB9NLbWgoWzHpCULJ0a3n9+9VMJODZdMUK2p8ONUiyTZVBNlPwzisa8y5ZgOlEgEfZcMTFnuTm2vodEt6YOrWguBNTszCR1jEd+SdrjlLLNpNexCNlQTRgwmZq8I5dUARmlRFEbngzSxSah+oWS3uIZBRG2Z1VsGU/h70HSicQozkLvHcaRZvpKYwHRPJUH24WP6VGYU5GRQfPLB7uUtqpB4G7xqM8aoAfsbuMVL+f6jQQ8To88E6ddH/yTpuXNANaETtYINhGNNVffJM1Ghuch8M+mk0hctpSBsgfpifh5K7DBBlUAuXOc65RbDZ2teJOpAw+24x6vxWrQRL23mQWi0UzcfPxOEO4JyH0v/cDzSLMTh0IgTlZGvF0rebqedLOuITE0yKmgx0FXrXP2zMNkuJ98bGkGC/2svlm5waaqNCM3y/u+N8wWCccWjj1Rugd/SPPN+HnkoPX0j/+UjYiyUKRNcDHpI4/hyNzpZLwZX5ZpsXsBupK4xYfj+ySnk0por7V1baISfugEjXqTAl0l7HREBz8xgzF9nrzvUsxKXpoOpjEPwW8cv8rvj15NClHmaBIH8YU4+fvjb+Go60wsDPBAozL4jD5JbnXP/SjMjfA3MGbnpn6PFbNFaStM3qfVbHEbIDFYUYdBr9bsqlgX49Yl1ISvXyKZ7XtyDTEDHQ3cMtQkCF/pvxohw/ad+wWMUaYnGpTuNC2p/rd6mT5/gmGW96w7rJScIFyv6
 qgWYsJLT
 PnC8t41nxQ1sSPS1T3u//PKdVNlaURt6sNQCjxmbf2tqFry81zGfLYfGMtPe7IegFZS8eS3OqCVXtvv1IpHQRk/5Jiqmhac6mlx+74YygCyRzGyOlCgKiJ5jLdVtm6eC3sELLpmXBWKP/y+tGscytBRBcfda+oXbgitWnhM61ClXjmYI2Mv2uu+TgY94VYgExD6B09SlJ5HywIrGc+vYmPolFMnQOP4v9m05d5v3jSJJ2sRAm+J6XQIEcEhl5NdqUituXb527aF9i88lRTUW6IEK834GPXbXpRt0Oic2JLjLPSn2DZCFzT3gWU7j2m9LF+vTiit0e0oIgQJOX3K3mgPSegcjIsoynjreGb/u7AaLJLHQUDaEd0O4e7FP6tMQK3RP/hR/Y/iG9jywYfWtCB/1IwDuMR7mJrZYcYQJHEaYol7rqaI1BNAi0eWhkR/LPn6XE/KRn5S3pQHXdBYRnJpfSCUADLYwHarjZjcTrfaOVl/tks6ZnQzvAreREIkM/CFaDh3+xw+fObdTV0ve1ucD4vsZGki0NjyoXLP9FVFVTZ+M78JxUkDqZBGAvTY54hRk4P0aZJ/evLUAt2f9zA6iaylkh/Nu21k6aEVUo2TOYjGP5t6Ai5kLKlQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Mar 20, 2026 at 9:48 AM UTC, Brendan Jackman wrote:
> On Thu Mar 19, 2026 at 9:39 PM UTC, Matthew Wilcox wrote:
>> On Thu, Mar 19, 2026 at 06:40:59PM +0000, Brendan Jackman wrote:
>>> I will paste the diff at the bottom. I _think_ all the problematic
>>> expansions are downstream of struct xarray, but it's quite likely my
>>> sense for problematic struct expansions is weak.
>>
>> Urgh, no, it's not all xarray.  There's one in address_space which we're
>> trying to shrink, not grow.  
>
> Oh sorry I just assumed that one was xa_flags.
>
>> There's one in struct sock too.
>
> Huh, I suspect I am embarassing myself with this question, but why are
> we sensitive to the size of struct sock? It's currently 784 bytes in my
> build. Are the adjacent fields very hot, and we need to look up the GFP
> flags from hot paths?
>
>> I don't think this idea is worth it.  There are other projects of greater
>> or lesser churniess which will give us some flags back.  For example,
>> we could finish the GFP_NOFS and GFP_NOIO removal.  We could finish the
>> radix_tree -> XArray removal and get back three bits.  

Oh, but also couldn't we get those 3 back by expanding struct
radix_tree_root as I suggested a few messages back:

-#define radix_tree_root                xarray
+struct radix_tree_root {
+        struct xarray xarray;
+        gfp_t gfp;
+};

That seems to make sense as a way to avoid the xa_flags overload even if
gfp_t doesn't grow.

(_If_ we can tolerate radix_tree_root expansion, which I have no idea
about. Otherwise, yeah seems like finishing the radix-tree migration is
a good path to more GFP flags).

