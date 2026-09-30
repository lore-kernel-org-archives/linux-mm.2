Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1B48CA5FC7
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 16:09:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4DA76B0088; Wed, 30 Sep 2026 12:09:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEE5C6B008A; Wed, 30 Sep 2026 12:09:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E13A6B0096; Wed, 30 Sep 2026 12:09:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7746D6B0088
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 12:09:35 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E0BBAA3EA0
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 16:09:34 +0000 (UTC)
X-FDA: 85270913868.03.B7A1FBB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 423B1140008
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 16:09:33 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="IGpAu3/b";
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790784573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=egkKq7DBcopH/CfP7k5cRPLfBK4xdy300HzFpQQxnAc=;
	b=1dUgh7QxJq1RnvG9mZSaLPkd7pbM6tr+o6wp9s/o2SjZjmiIE+el0DSi45dprDd4eWZRW+
	jbLaHOrVPNHdh8KrSTiQtd3TGr5aXQ7hq3DN7Mqs0BOCK/Y1edgeA8+rIVkckJPxLCJszH
	Cd4ua7J2P7DU+YTWOcDobFyYXfo+hJ8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790784573;
	b=YD3chBG35e6tAFJovUldyDZ3uw8yKZYjDjgfNRWO1B6qOu/bNeTCYhpl4Y6ZXiEt/jsDtw
	TpNWHda1bpViSrOmS9ZzkhC6Nv4AwoshxhYUnhajlZC88JQFrQVVdzONbPmqREM9+PKVVM
	dfO2ues2TH6JW8nBMJF8Q7Kx3A8w7wM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="IGpAu3/b";
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6B51D413E1;
	Wed, 30 Sep 2026 16:09:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 753191F008A0;
	Wed, 30 Sep 2026 16:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790784572;
	bh=egkKq7DBcopH/CfP7k5cRPLfBK4xdy300HzFpQQxnAc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IGpAu3/bbz/wXi01745K8+qCWOILcLoMAtMht7XGkjTS7fMKDt15jBiRczG7jgq5B
	 oluFc2ExDATT8nfGzvmyKaqmTlNbttYn0nwo98fGD1W+LvMTk6WF0VvVjjdJjisghN
	 QVu+vwX3XGw8ss3Fn/C97lREaTK3NGDQGWQNkym58NOE/ZvRS33VdLVNu5lbuyRb8V
	 RgRG1OcJsycDVVqDdByDvIQ/WwBilRFxvL+3EiBT14nvx8yufnS4VfSeN4RWEz9FTg
	 OnCrY7+XCCL0/TGGvPoZZjcg+7hKEVVyxUB67RIx+yy+JdJxzk2MajUY9iQ471N9uq
	 XzzEsfwLvK7Aw==
Date: Wed, 30 Sep 2026 17:09:26 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: =?utf-8?B?67CV7YOc7ISgL+y7tO2TqO2EsMK3QUntlZnrtoA=?= <ts930@dgu.ac.kr>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/mlock: fix zero-length request normalization and
 integer overflows
Message-ID: <ar00Lx1xB5rvKOdu@gremlin>
References: <179066531783.50175.13377521828379196177@dgu.ac.kr>
 <3a95d0e5-7969-4b0d-988a-ead62b06b6f5@kernel.org>
 <art6x0XpWcT2aUyy@gremlin>
 <CAFPGN2jPGhcWVqa3k16RWMaMR3TwKyhFbYYF4D3L6L85T8E96g@mail.gmail.com>
 <7d120555-0c31-474f-893b-e5ee3466ead4@kernel.org>
 <arz82IHw4MqGTb6l@gremlin>
 <091706d4-96cf-4dbd-8f9f-97ebd3f8d81b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <091706d4-96cf-4dbd-8f9f-97ebd3f8d81b@kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 423B1140008
X-Stat-Signature: mw4pcc87dqn9j58mzum5mz85xp9hfkzy
X-Rspam-User: 
X-HE-Tag: 1790784573-990957
X-HE-Meta: U2FsdGVkX1/QvASsclR62kfai6vDDNIwPRU59YZw/ykcW9z8rNZ/n9ZOcvPBhLqKs+dxXusTbGvKQ7P0shsyVOGNNfVQgjfZzAo7Pwcl/Yr9rYunEHqgRKZFMX5n2YTReXUBNdUXdWbY3pNteLMLZMTcSLlPSyk9ALq1JmyQDJYuyhUURcNSJ6duL2HzYwYAGhawAXO/FeWBMfOJYluysLKtNqCAKXj333a6JFXm+vBlGoEv2zwyOlAi9v0hjZscpAXvoAIimc+OalfNoArINtC3S5zOPLm5HHICZ1rOzZMgoa7EOrtzS2XfCYLxQdd+BABYYre9CUl6uDjdNM4e1iZ/m+U5ieCZk0NJP45qpuMa5dxpA7MHChWpvPbbB3A5hkQQMu8fz9WhA/Dqiagl+BGwJ9QUSoqaWppcj02EMnDLYP1EU/hNV+fYP8lFzzEzoH9TgKPF0yvt7Zgj6xm2BGevUEqEQmr2wa1PAKM0PiXj3W7a4dVhlX8aTkS+7u3MqFm5NXjlf0ejdN8c+FFYQqVWrFJ/Y0LRFCZMjAYgfKO5FEYCRrEtd7Hop8OLHR9TJI8w6I3zw5QTw73UsCi6pD4gDhX39CFleU5kWsXFcPq7SmZVzuNYox+YcXXAQGa/4s179KKk5ReBLKbntJyjghrqypfN4ymhBkL/MjMmqXe+3CrBIBfMoHdI78KUhqfgj2KkX0TThdORYzwV/woZunGtqK5pKCd/4IcdIlsAwLh6XFC33wWnybNJbVQ5TomUkcxRukmxkC1Nknc7grRhhFxCIaEXl4Bi8yLCrD9wLv5GZews0wedmXoTnyDPtXRxKzdPiWk8E59gz7nIBDdEpS8OvrTkBT5fzY80Zncfu3Ej49xINatu1yf7PoBpdIeoMgtwLltk1R/jQcWKJFl9bUrr7tWNFefKzWErSY4s2rtiVLKzks88YW2/s05O3zKKk6+6tUoGhIpuBp3dbsM
 vDiRQhY2
 CwtsQx5j4qPxIs1uyy023ba/OTYaZUyd7LVGBGEr5VDIypa8VUOFeAjR/hL6R0fmAXJqpmm/CDBrqW6PY9tsDurl1lVM18C3DPAnWWxXR9YX6eUxQa9Wdw3BwJ14MienD6c++jW376YMj+Hh609MwYPDb+9H8KVXmAASv87uXX29Z5KUcJdWPisfLueOREWf+LBxKT1itD1wjBpkj7GQpgYAJzYNj6lvktpnhZynkE4Er5NBSjiyZsqQ7Q1OzrRqAJxRk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 30, 2026 at 06:08:15PM +0200, David Hildenbrand (Arm) wrote:
> >> So is this patch doing more harm than good?
> >
> > As above, I think the submitter has decided to drop this patch?
>
> Sure, but I still got CI noise because the patch was apparently not even
> properly tested?
>
> So I really want people that send "fixes" to test stuff first.

Entirely agreed!

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

