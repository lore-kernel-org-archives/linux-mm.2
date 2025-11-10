Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DBD7CCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 09:48:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D79178E0012; Mon, 10 Nov 2025 04:48:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D295D8E0002; Mon, 10 Nov 2025 04:48:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF14F8E0012; Mon, 10 Nov 2025 04:48:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A74FD8E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 04:48:54 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4A4181A0C3A
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 09:48:54 +0000 (UTC)
X-FDA: 84094223388.28.42A931E
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6AEAA180010
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 09:48:52 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="R+/B/+zb";
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf24.hostedemail.com: domain of mhocko@suse.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762768132; a=rsa-sha256;
	cv=none;
	b=IKTtUOV5C7OZ75ytwDHCrC9fy72u+qRTL7PNWrnY/+68/ag0kjTH3ww6iGjmwCTxhDthX3
	Ujr/xVV4O5Fri1hI48+is/ewpdo4c6ZKaBpses01OwuXxu7crIi2KSFwV3ige+GXIDa8KA
	hlvuBCREMgIWf9jNteVs574ca+MR4Mg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="R+/B/+zb";
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf24.hostedemail.com: domain of mhocko@suse.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762768132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jhIrfg+ZeGmHHXgRYjIXkWVaO+GMicaDEEBop0R1M78=;
	b=K8zaOcNnudJuZ/Pk2AJoBzOUqKhFiOabfRcEFfRBAGAX39UyJUmJuWcE/5LINYvRtrtPiC
	Z9rCWmEVwZ8fL25qQop8hXediLfvW5DVw5plpmA1sxCI7fCCR3WjjnVQGtmXV26zkzad6x
	DoITrWW6dyzmZ4YRaRGFzf5ihgbpbRo=
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-64166a57f3bso1936944a12.1
        for <linux-mm@kvack.org>; Mon, 10 Nov 2025 01:48:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762768131; x=1763372931; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jhIrfg+ZeGmHHXgRYjIXkWVaO+GMicaDEEBop0R1M78=;
        b=R+/B/+zbxpTHXQheMksiLXBkFek2b14qZGVLmMMjDBsBVwGXyAs4s8tGEXB8NVh8mi
         ZXQ2Q0FhKhAHJ5TBrMbhXWUNdsJPWXcWgGQrJ+8bsBCe5tioSpYP71TVDhYiRXOQPVa6
         ETlmFteQKNl+FHZfoO/8k1K0WWgnFYhrddqLqA3aG98H8VHEzixhV03bPMGsRpxRly3q
         +QSAAmKa4wjgQGVddViKmKqLgQfVOgVdTumi4xLaZCnezw/mIJFofEy4CSPzmd2JpSWL
         3yO1aRFsd8jCjtMfAkWbwnaeSue1/BVIuJQ2hSGI9hjDMRgIbuh5UARQ+XfjIsKgZ/og
         kMWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762768131; x=1763372931;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jhIrfg+ZeGmHHXgRYjIXkWVaO+GMicaDEEBop0R1M78=;
        b=jI/4aihpHzgIx5S+1SNEVGnhvGcpNNPwFymHfOdwUJBl1oKSh4uj7mCSihhG1UDMhg
         0GDOZcLathbRCzfo7rrFoPrOWA5FUI8Qo5Urz+5EXd+dYwXakGTTi/kscXofgvBcx7jq
         KbFFw1V2Bls+V5E97W98j0VlZwmgNATSp8qoaISpF8PlfbWZrFw27C2YOISS4KFW+nvp
         STJx7aDYWxy3PwMiR3CEQhsMZwZzWtngIAaxQcIS5lMbu8bmfa+jqwqZG0fX4RT0DG20
         DBJB5ibpf8RxMro9yW/pEr57Xwuuh7Tht2KVcq8zQPrdn835ie9B9nylfuaScg4rXJVi
         43pg==
X-Forwarded-Encrypted: i=1; AJvYcCWMWguN50wtZ8jXcOu5HJp1VgqsMeZrQdL6tKJW5KV/ldv+wTbrJedW+wR/mZDjLykREgbIbvh0Sw==@kvack.org
X-Gm-Message-State: AOJu0YxWfOPt3nz7nz1lU82QJm86Hl1gLqSPmqGYeAL7qTrD2oxesvFv
	3Z1OPMDAjVX2tH2nmZEy4n7p59ZjJdwTGCtTQffTpVJQcsjf+ZV6SfJyWAu4gtLZm1s=
X-Gm-Gg: ASbGncstWXiw0/4JolsXs1r5o9z/FPjMuKhfocSaSM/qH/SsalOMRN4GKOHJnYC3FfE
	rhfa0wQJCPHOWNdHhc/VxQvJdgh4VgE5fWSOcWkEyVeh2F/IfY68/lnjC9jGxmiQzpRRSmYMtjE
	EXHHnMqCT6uf9/8YoAufW+FZQJDGiTJrCRk0uRmOTQHj1ovmtyE9z6IxTHDrsypDas5c8CVMQJz
	unl7UgBYkiuiuzmC0DuwbmmpvpL8HaWt3FgLxWLntV1avHx6x0m8tWhRR6+64yxkJ/uDQGJwsfL
	cy/RU61vNIKOKVQpNmMFUcrU+GbYYT5fmXynum4sEmP6LLrp8vLjzzyKy2q43s1g4obbmXfQXXi
	F+rJY/YZbLLOJ3ZocFxwNzA5nnkuIT282/IeS7AZIRgSNz+ElqVNKpiNyrGgBxG0MJ3olGsGcp/
	T3P99qsrd6t5xlSnR2TyBSzBTS
X-Google-Smtp-Source: AGHT+IFxQkylFq2Crr8V5DsL5/o3I3bsVnjZJeM/h5I99Cls23cajzpMg5CawHlhDUEoe8P5BasDOg==
X-Received: by 2002:a05:6402:50cf:b0:640:da69:334c with SMTP id 4fb4d7f45d1cf-6415e80fc71mr5848770a12.35.1762768130923;
        Mon, 10 Nov 2025 01:48:50 -0800 (PST)
Received: from localhost (109-81-31-109.rct.o2.cz. [109.81.31.109])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6411f813eb6sm10864916a12.14.2025.11.10.01.48.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Nov 2025 01:48:50 -0800 (PST)
Date: Mon, 10 Nov 2025 10:48:49 +0100
From: Michal Hocko <mhocko@suse.com>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
	Alexei Starovoitov <ast@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	JP Kobryn <inwardvessel@gmail.com>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, bpf@vger.kernel.org,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Song Liu <song@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 23/23] bpf: selftests: PSI struct ops test
Message-ID: <aRG1AX0tQjAJU6lT@tiehlicka>
References: <20251027232206.473085-1-roman.gushchin@linux.dev>
 <20251027232206.473085-13-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251027232206.473085-13-roman.gushchin@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6AEAA180010
X-Stat-Signature: em3663z49e1jsnfz9dk8uqbjk76ue6wj
X-HE-Tag: 1762768132-829961
X-HE-Meta: U2FsdGVkX1+U+IGF2NSQ7fINx7x0BY7UFgI9t8ym22jmHpy0zXi6LIRp8zDYG4BuuNgadeDMcG4oQCHrNIKjht+89WRU5XkuK23yAgbt5J1HrOs+x+JahR7e8Bq9NXaEIu2MVVizv3hoPbH3MJZKsDEjYKGEIk3FR9K4tKcuvMuclI7a+Gqr8l8xO4ga0mhtt7oHyFf6Tt+7huXj1XQOIStV8lQe0oSJBXvFq9K5AqnVtO2vQiOYsyeebD3OAsop92qXswIyAY00lPAIiJvbTM53bFRBmIdnBANg5LHmyGDScOVH3huOGUiRkIcKfGKunDTrEkcZlmWhjZ+Ry7KUSY7+6XRJKDTObj5QSDQO3qtNZJU9l6BUy+EBpEbeBq2Nu5Jd8byDQWOCeHbx1HikJFPkCbvQh5X3OujDwL2ZemXTvTEcAO/zH9hNagj/2U8BYud4PeEejwh27Hl8ktEyxdkHRKMbC+mF0Co+oMsk4X9rbBucQ4mLOHnvEgui6MKHcuqmGsOk8PCOpmFF1C7j1wAdsaiaHd8DM+JPrUWVYDS7qKDEiJgJqtRTeTIo3APpYjN2nFQ4/pJ1FuWGortwkn0BpbTmNWuvhdIYYC4HiguEpOqs0VzcTtZdfyBYGrLu9WcoDDQg+acGJDb5Zbuj40uc+0gubtLnpUgjtU7UqOUpilb1mP1jTftK9S4ssjdZWCoVt2PJoHNrji+v91+H+8YKQgt9NwQzeXPapVjmcdnJdF9zH968e0Wrf+nSQtI6RYIBqCZY3ojdm9yXy2EOyNXP0Zdo6/00RMc6VHLxrH0i5EqOwDKmGovEpVObmawcGyI6kvqx8TR1dX7f85XBpMMUd4WoWDAzHZ1xJNcSzb6pgiKDYzbkBnLVQ2UkmOmPIapqUTBXMw9vqBWrbMQivh8RRU/i79K2iQW0ZKrXZtIt1AxzidoMjtAfvamp3TbuDyAlUtJVpL0lKWTqxTw
 v5M+Zuz9
 nZTMa7fxSi6tYSiDUUhf5oApzmRR5z3pOadPskA1XdXw+IZktK1s13JIi7RsD22NBE3aHdlQYKuuruWoBtZGhPXEMrn4AccVVMr4OZhXxvCCV9EV3W8OSw7Ub/fqmDbgRq6/g5dFMnnOX8SEPc5LeTrcH4R/JSoEkT8pnECPzzy3jpd1rvy1Nlh2xe1wKsFVs+Pt9ptowo4Ll0H5kYsBUyRMvap0VmwA1234F0KjvwRVY4LrX0GJAjeLlb80X7TJFON2fyYtWzY4WYAQ5YrPZh7bnUwGFCgZuxMc8D3v2KGpxDbcDXXNwD5FPE/H9vdfENtw+22HZXEKZQTLJ8IKbii5M1yyin+EtKQRw5EwOOuA3vbiHIK6wTwGGUnIGshm0IiabYGypmgf2DDGRgew7OJVDFKsvSoOPkooA0nQALWX95LC/RwTNG5VIGZElH5k1G8QM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 27-10-25 16:22:06, Roman Gushchin wrote:
> Add a PSI struct ops test.
> 
> The test creates a cgroup with two child sub-cgroups, sets up
> memory.high for one of those and puts there a memory hungry
> process (initially frozen).
> 
> Then it creates 2 PSI triggers from within a init() BPF callback and
> attaches them to these cgroups.  Then it deletes the first cgroup,
> creates another one and runs the memory hungry task. From the cgroup
> creation callback the test is creating another trigger.
> 
> The memory hungry task is creating a high memory pressure in one
> memory cgroup, which triggers a PSI event. The PSI BPF handler
> declares a memcg oom in the corresponding cgroup. Finally the checks
> that both handle_cgroup_free() and handle_psi_event() handlers were
> executed, the correct process was killed and oom counters were
> updated.

I might be just dense but what is behind that deleted cgroup
(deleted_cgroup_id etc) dance?

-- 
Michal Hocko
SUSE Labs

