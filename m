Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C856ACAC5B0
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 02:18:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19A058E0006; Thu,  2 Oct 2025 22:18:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1713A8E0001; Thu,  2 Oct 2025 22:18:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AE598E0006; Thu,  2 Oct 2025 22:18:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EB1A98E0001
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 22:18:48 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 83F121DF73F
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 02:18:48 +0000 (UTC)
X-FDA: 83955194736.23.CA516E4
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7EABDC000E
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 02:18:46 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bgZsiT04;
	spf=pass (imf22.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759457926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2e/i8EbjlbnXxewfi6hJm/z/4ZP0XZNKcXcN/4b871g=;
	b=smVtcUcOx2Lno3rYGVo+erq+lAMUz0TDCRTxwj2mxHpe6WA83/3bzoDYWr9g9GqwmI2bUk
	zhEchnKHqwiKEIW8z7mWIqz9T5D+9WNibPhIyHIgpRdaWKOczROrrNFeb8R/RvwRzS5slf
	MQZz03q14j3FLiE0qWRJ2H0Ll+nJXgE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bgZsiT04;
	spf=pass (imf22.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759457926; a=rsa-sha256;
	cv=none;
	b=DW26FddrY7lYJ4cD9TRoMt8ZHUl+xmQeUS7/DpHLt3lOz6plg+tetCf/lt2x8UYZpe1FY6
	xqYxwFAhPzQMy2PQzGVYkq8gjP65Q3xINU+MEl5CX4c56ZOCXzBVa3iygd5PkCYxY/k1ez
	trT/sJGvxv38EM3L2nF28xDJtmD9LMg=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-46e5980471eso7980595e9.2
        for <linux-mm@kvack.org>; Thu, 02 Oct 2025 19:18:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759457925; x=1760062725; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2e/i8EbjlbnXxewfi6hJm/z/4ZP0XZNKcXcN/4b871g=;
        b=bgZsiT04PiLqPC1qv39Ek4qANKKf8Fi8puMlQwAwhnpG5Xu889Cw6gGwsEjLSeHWRy
         DIs423czJBBtctlSKR5LzPKpTF37zMSNstH5v5uzwfeAFYFyzclW7X/LWnr3xLb+7Wyl
         wT50WK/tDbdGh6eAajX94pzm1wBN/dlIy0D+aB3k+wyOtoXNaUk7RB4PJrZbNW6bxoMz
         y9VKANKwolRYlb2eLNZuLI7BvBDBs6ioP4SWs+JanyAxDHcQ8poYivuwzYeqDXxheihP
         LJ/1HWHffuWM6m+tFMlMS3oeOyymV3Zm+sYiee2Olts/+cQnc/lbxuEoMN7whdqNa259
         Jk5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759457925; x=1760062725;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2e/i8EbjlbnXxewfi6hJm/z/4ZP0XZNKcXcN/4b871g=;
        b=TlJA2RpqHuc461IS9bDGj7B0ISIInGm3TcqcMZLMBjgn5dSbEu5U1y1+QP99w+7W38
         FV/4x+NwQaAm1IQXrwzHG3MxxLSUgC9pl6xGDg4jey6VzxydGElTs1KJzd052VI5agU+
         XIaMSbm7Fe7qRtc0ebLPylTE6fB1PXj0CQ8bSKbnqKq2Ja0HDfV/wIXXT/j1QlBywMKz
         I/glB2k5pZdUxtomgFcQnh0xcWpL4ix9aSgcl2qxJabD8KqsmXByKCIsaDTIEXk8XIxw
         3vPCW3c/iBq6QjeBeIEKvseIDCq5qMnI4DZ/SMSHo9pxqqRwaJgYM/HorAfX7xqTam15
         OzXg==
X-Forwarded-Encrypted: i=1; AJvYcCW78SrrXk5SVABMLuGFde4OYUEo0qBzKOFH3XQBbWU3NjPTRKC718eKag1YtCWtvAVM+crnZJU7Xw==@kvack.org
X-Gm-Message-State: AOJu0YxqlFWfDQoISMK4gQYABBlRjzolaAff6gqbCYBx9KBE7RFxaCLJ
	UT1/y5qn985p+F+6eGEdlQKEzlRh9uKdkqx+TffSYgCYSuhoQv9lg60m5YpbZtVH5GGcFbRyQMh
	z0TldCnpYCkEPC0/NnrzODVDrXjnuBcc=
X-Gm-Gg: ASbGncsawIAMYso9eWJUrRFTn2tqxKkBLRzkUZk2OtqBp3beOXKUXohYBozrJfdWJow
	oLqv/npDw/7O+DLc7BGoVcmUkVwZ/fHoDR4x13DdsBrSk2Zae5GRlmlVbEWqEg2PGsZ/vdAV85c
	z5yq9+hU43sf1R0i6+McWvr9RPQBv0uNUrX+SRloSDodnbJjah8laXAGCtQV5ahlo3epiHovcqv
	mAedwMH/V2LLquLpwbnh3++S0Nm7CL2dnO48AoWww3QGNqs4TyD7ru9UwXT
X-Google-Smtp-Source: AGHT+IEUdi5h2t7CXTLul7ivkETFz4Fjf+lqMHwgof5CobhAX/VcEKSKvJeht/4smjkDa2Hgzo4fwK0xXe88/EAzHP8=
X-Received: by 2002:a05:600c:8b65:b0:46e:2861:9eb2 with SMTP id
 5b1f17b1804b1-46e711002e7mr8372685e9.8.1759457924865; Thu, 02 Oct 2025
 19:18:44 -0700 (PDT)
MIME-Version: 1.0
References: <20250930055826.9810-1-laoar.shao@gmail.com> <20250930055826.9810-4-laoar.shao@gmail.com>
In-Reply-To: <20250930055826.9810-4-laoar.shao@gmail.com>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Thu, 2 Oct 2025 19:18:33 -0700
X-Gm-Features: AS18NWB-xO-pJI19YtwvzZWDSOLQVewqObSZM817yMkm5nTGr0yasX6RQmgofXI
Message-ID: <CAADnVQJtrJZOCWZKH498GBA8M0mYVztApk54mOEejs8Wr3nSiw@mail.gmail.com>
Subject: Re: [PATCH v9 mm-new 03/11] mm: thp: add support for BPF based THP
 order selection
To: Yafang Shao <laoar.shao@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Liam Howlett <Liam.Howlett@oracle.com>, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, Johannes Weiner <hannes@cmpxchg.org>, usamaarif642@gmail.com, 
	gutierrez.asier@huawei-partners.com, Matthew Wilcox <willy@infradead.org>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Amery Hung <ameryhung@gmail.com>, 
	David Rientjes <rientjes@google.com>, Jonathan Corbet <corbet@lwn.net>, 21cnbao@gmail.com, 
	Shakeel Butt <shakeel.butt@linux.dev>, Tejun Heo <tj@kernel.org>, lance.yang@linux.dev, 
	Randy Dunlap <rdunlap@infradead.org>, bpf <bpf@vger.kernel.org>, 
	linux-mm <linux-mm@kvack.org>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, 
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7EABDC000E
X-Stat-Signature: 9b14e49bcnzqk68xpkq4t7nc6uzc1f9p
X-HE-Tag: 1759457926-82532
X-HE-Meta: U2FsdGVkX1+xY8oWkbGzGkk/J7t2W/RSiO7FvNwSAgSlpcbqco0hbIT8gS5p8VlVwHQAhn3/u+sNCPJzJ65oxFn4PFTr8OXGcL7Ah3mG0JrOqLgy66PtApe+GP9IyhT5oGhFKqMhbgxPXG/aj0KC94/iHT/HbdScA3KRj7IZRfXIqhaakW3vDHXtHc9PHqyF+Prk7CokCqO8ZWaDuRXCtgsNpfo3MnfSO0S4g9+ucQimIJ0ZWP0LuMOcHmKhJaOPd1TwLpsZHEeFvOPMrxI4C/Njey9NQ+ArX0ZMxoIVjb/RgfLCb4DebzAwgnlADOBBy+R9T3RdrOpY6T6hRlFhmlQADTrAElAS45KziEgeNUqmH8+u1rNBUewD6ZkDVIPAHwuT7ioRxxL8ofHiga9JV1fYXMqMWZJXCvigJAGjeZ02cb38YgCGZl8h1GzKKXlKcMGAjE+hC6WIUFLiC61Nbpy6quDwthA9/anQCl3bGSGTMc3VagePq+qqjl5VSk2jmPqeJYGgRkKlA7kKt/e3/NWBoxJgs9F1YxAUeUFR4q5ktV/O8KWtkeDgI62IAN4/A4o7xUXfnqj9rZzDqKunPwanm89HvBpwHgy+H/6515nKtx7UkaWAT19E0eQWOp64hbnR2Y+txba2w1dW8pv/eiIOvj8Tos00p+JHta6oZquyj1G5ypbbPFi9ahIbEHc1qENgCHflwJnx8yfgjJPRaD+UIGITlYW9BMk9EaAV9QTKIT4YYXgCbwCtp1vl4vE5iLXhMe/aVa3CP686UUUZqQgHncWN9nZ2v0jAjxEZzENPNCsvU1GQSH/h2D8qxFy7DGoWBnrZ7ctFiYwDoyy911m3QwrC9ffd0iITrrwgoXBY8h9M4PMOuJw0VhIET2ZL/fVwu5K8ptN0l6P8biOmPs31igcUG8Zzy4d15JWE5uj96xDA0t9NoJ9dAzVWPt2jfBLgYdYOC37eb5SCTv4
 VdIoPHzh
 MKkC4Ekmpym5hL+nWbZPprfl3Py8hUcyoXdaR3TYjio16/DJW2JueZ1ucw3rJUIgqP9778vclduRDkm1HlhHyYiW1UfghGFs8EhhW89Qfyh+Vv/m/kDhRtVZwX4XwqKChrIADN263HFy0R8DNAw0HTOwju6BKXc5GT7HaF/cwPgpqBDZO8iOgPgm19BkTKROWFGNlJUWB4JqvL+fStqB/vSbEvDaRrLYjaP/kLJT7648We2hG1jdpJcbXOYwcL2M5YE8BXfUdkwb83TJ+//lXFT9zcddbMw+4rHRAcdxubw4TcHQtk7R5poO0xedxJt0Bwyu89kRqMIZdDnBl9e/Lzt6vRt1g5di3S2Es3PgptucqgThjWFL8GcjvUMiYxCsYGtm/+PXPYguoggA/H5+eJYWsc/p/eCPleQUOIjnbiVcyUxiYSlVQZEy711SdreYwmb/TMcW2T7Y9On7NCdHC50zrKz58Sw6OgIPV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 29, 2025 at 10:59=E2=80=AFPM Yafang Shao <laoar.shao@gmail.com>=
 wrote:
>
> +unsigned long bpf_hook_thp_get_orders(struct vm_area_struct *vma,
> +                                     enum tva_type type,
> +                                     unsigned long orders)
> +{
> +       thp_order_fn_t *bpf_hook_thp_get_order;
> +       int bpf_order;
> +
> +       /* No BPF program is attached */
> +       if (!test_bit(TRANSPARENT_HUGEPAGE_BPF_ATTACHED,
> +                     &transparent_hugepage_flags))
> +               return orders;
> +
> +       rcu_read_lock();
> +       bpf_hook_thp_get_order =3D rcu_dereference(bpf_thp.thp_get_order)=
;
> +       if (WARN_ON_ONCE(!bpf_hook_thp_get_order))
> +               goto out;
> +
> +       bpf_order =3D bpf_hook_thp_get_order(vma, type, orders);
> +       orders &=3D BIT(bpf_order);
> +
> +out:
> +       rcu_read_unlock();
> +       return orders;
> +}

I thought I explained it earlier.
Nack to a single global prog approach.

The logic must accommodate multiple programs per-container
or any other way from the beginning.
If cgroup based scoping doesn't fit use per process tree scoping.

