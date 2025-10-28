Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF29DCCD1BF
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 17:40:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7B2580198; Tue, 28 Oct 2025 13:40:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B52A48013F; Tue, 28 Oct 2025 13:40:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A68E180198; Tue, 28 Oct 2025 13:40:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 95A558013F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 13:40:12 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 61ED14969B
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 17:40:12 +0000 (UTC)
X-FDA: 84048236664.21.15BAEC2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 061551C0005
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 17:40:10 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mhpWFvXh;
	spf=pass (imf20.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761673211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=78JNME3ocTmqdunMgHk2vOZJZvQANLQG00gxEsWnGRk=;
	b=rN+4O/QxaRYPo7CiZMn+W3Dv+oG8sLhTL7TdHNqBIcpxCFJRdHO8+20D+F7png5wI84Ou/
	oL3zznhH4wQqyG4Paksp7stXPmAZbODDr9eQvU14xFoupj8bNEllxT7JileSqub2cEymTq
	DJsx3V/3iget889W7LU9tiKdPYIiXT4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mhpWFvXh;
	spf=pass (imf20.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761673211; a=rsa-sha256;
	cv=none;
	b=NByhzxam1FAw0Rj3/Wmi0f+qm5WN3xvfsT1KVhhIaYAhaBLb3/cbzDQwcppaQWJeYskerB
	LVHN8QN+g5tW7Kq0tFbnnXkddlxAfEhneQIQuhEJT8Fyp1/I0y4B75b9nSAQvP3Gg/IacO
	5b3EcqkaHyHoNRj8Ru21olY6LpJM5vE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7082C61D94;
	Tue, 28 Oct 2025 17:40:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F375AC4CEE7;
	Tue, 28 Oct 2025 17:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761673210;
	bh=JEQpfJ799L7UkBwPLShI6fWI+pURiMoySEUTMZTFRT4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mhpWFvXhSdhhVyXCw3aXi6KEYWQg1ikLqpo0HnL4cew9t+lTIWD+gF7HEotjTuYwI
	 0w7GVQJ1gVdHBiaAXuG2T1zPY9/By4Ca4Y/icS160SpZUfei2UgWqXX5BOvV/Pi2e2
	 6+KGBg48l1wCKPXkG1m0yGhqDCxlhlqsSTQL/a5/sNSBmXgjd7ziNPqCM9pajV00pw
	 gsEQ58uwgI5MolbjvLP4xJSuIoWc9Di9UtG/sE2bSj54qs42DqVODrwG08jVgqeziS
	 yqofkwVvCpqLd1FX94DT8PM2dQyITMIglG4QoM0zGOSOUV+T83udKEI2EeJdncbp0k
	 FQKYKTGUn6hiQ==
Date: Tue, 28 Oct 2025 07:40:09 -1000
From: Tejun Heo <tj@kernel.org>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
	Alexei Starovoitov <ast@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	JP Kobryn <inwardvessel@gmail.com>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, bpf@vger.kernel.org,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Song Liu <song@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>
Subject: Re: [PATCH v2 20/23] sched: psi: implement bpf_psi struct ops
Message-ID: <aQD_-a8oWHfRKcrX@slm.duckdns.org>
References: <20251027232206.473085-1-roman.gushchin@linux.dev>
 <20251027232206.473085-10-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251027232206.473085-10-roman.gushchin@linux.dev>
X-Stat-Signature: 187wnjdjmbpzh33ypn663yqojujyx9s4
X-Rspamd-Queue-Id: 061551C0005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761673210-892181
X-HE-Meta: U2FsdGVkX190raBhXmFAgsTFz0x1oJBEZu09ORxe0On1C+3AHPpp+8ovBp1TlTIqbPk/Ei1MBzq6idhuwjCHfoKhRfRbLHs3bG9nNmT0M7IG+Wv9iPOErqzLcQ4evhQOCL345vyvMkjZiWqyWpCQmyUPniU7dRifpIEzP1A2+yq4Gqa+/mZdSgBKY5G9LvTZNRUvZojPp4s0G3gNvyILQ4xWSshwOUczf/1tjKodT/sV7So0Khaui/oDT2s0AHaqCT3+9tda5N9E/bwyouj+93u9W7HkEi+E9bLgV4VhaMl43sJI9tp/snm4cwsYPSBKJzs0iR1l6n8qwrvhhjFGmkLMT5Sp90wLX/3WdiGwAr1NygnPY8233hdIselzCESD3llr0DgM9S1OvFidqNKYvI3tRKtfQtw6aSGROux7hNuVLRCZPpmdxuC7xHIz9tMMykzEdO+Dj/RLDwQdGxN13UxtYNQvuve5jiZFaR0qlFX7hi1NhpArVrvcKeanHOjBMSejMajZ8x0YLwYChvefnsV2dzYomhQQT5mPCbCDowFYR8tidJf4goBZo57rrSBoavf2A7JjoY37Hxx1NE4ZzX02qoVo3JH1259V4pGkkiC6ShKdWg2tmbHzpglbF/BXF3Izsn4iua8JrAIdaBi2l2LtahupMBnfgJ9XExMbuXo99seX518T0NZbIH5w3b+HXEhIcz4BEU+0BAA9X3DHuKeUfNrJnyitLHhTKvQheqnn4+H7Q9g2zv8PvkCljXAlC+r7w17h+JEKrm+suqVA1geOecn89p/h5xDsrAGIJRifBfWjEciVsmW8f7Ofu2gih6Rt0179tHK0PjIN3sHYqi/mvAjgoXeWczRXhm/kQFyoUw8jktwDBLSSz4jr8QFmurWqO68eegkTU4wCa8zZV1pYE4Sj597iDTtvqJKGQjsR4xyk1Za9tQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

On Mon, Oct 27, 2025 at 04:22:03PM -0700, Roman Gushchin wrote:
> This patch implements a BPF struct ops-based mechanism to create
> PSI triggers, attach them to cgroups or system wide and handle
> PSI events in BPF.
> 
> The struct ops provides 3 callbacks:
>   - init() called once at load, handy for creating PSI triggers
>   - handle_psi_event() called every time a PSI trigger fires
>   - handle_cgroup_online() called when a new cgroup is created
>   - handle_cgroup_offline() called if a cgroup with an attached
>     trigger is deleted
> 
> A single struct ops can create a number of PSI triggers, both
> cgroup-scoped and system-wide.
> 
> All 4 struct ops callbacks can be sleepable. handle_psi_event()
> handlers are executed using a separate workqueue, so it won't
> affect the latency of other PSI triggers.

Here, too, I wonder whether it's necessary to build a hard-coded
infrastructure to hook into PSI's triggers. psi_avgs_work() is what triggers
these events and it's not that hot. Wouldn't a fexit attachment to that
function that reads the updated values be enough? We can also easily add a
TP there if a more structured access is desirable.

Thanks.

-- 
tejun

