Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40B74C55172
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 18:44:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6F796B007B; Sat,  1 Aug 2026 14:44:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF8A16B0088; Sat,  1 Aug 2026 14:44:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE71D6B008A; Sat,  1 Aug 2026 14:44:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 868A46B007B
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 14:44:41 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6A5FA16035D
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 18:44:39 +0000 (UTC)
X-FDA: 85053576678.27.8084FFE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 63B4820003
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 18:44:37 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=tRA+f+uN;
	spf=pass (imf31.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785609877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y8y+bsb9FXo0waSAZ+oBgSFJCMPWDwmDTPmWChj/3nQ=;
	b=VjzP0SuoecacLU9m4amDp4eiOULhRtv5XduWxQ/21mZoE/bGh0YlK/2wbTVIkk54jKrG6Z
	UXR/2IEyUIy99EasOhf2izWLCKWDmPhIiFKpanvDGUXyJd9SXAG3Appo6ekBWtWgSHQ538
	qAe5eFbEAgNEbbbXz2HFLDRwutPvfcw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785609877;
	b=jZVeK25Q3Z1VO0URFVhPZlpFfZmdTQtgZ3LoInlJD6qgGAln1TZ0dXZwq7Tis44K4/Pmtj
	noKGWfH4zbkKkazvIssmKd6Oix0A8W0bK3Q6BzT9jGyh4v4D5fF+xhmDF9NuJb3ZKVPhPW
	OlpwwWjvbOQjzGQMLvbusxQRsEvkN4E=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=tRA+f+uN;
	spf=pass (imf31.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id ADED3600BB;
	Sat,  1 Aug 2026 18:44:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 263DD1F00AC4;
	Sat,  1 Aug 2026 18:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785609875;
	bh=y8y+bsb9FXo0waSAZ+oBgSFJCMPWDwmDTPmWChj/3nQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=tRA+f+uNHWzcq2230xYRE39U26tquDrankE5GTg/qaKx5Mgp0L6CGhZYJW6/csM4x
	 M7VhxWrJ8PFR/7i1J6YayPOiu5px7VzaDNWkn/ssSlnpSmtM/EnAlPQdqnaVHnZNKZ
	 OE+CMyxgu63tZrADobo/7n4/QTvN3QdVwGS95jkc=
Date: Sat, 1 Aug 2026 11:44:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jianlin Shi <shijianlin11@foxmail.com>
Cc: linux-mm@kvack.org, vbabka@kernel.org, hannes@cmpxchg.org,
 surenb@google.com, mhocko@suse.com, jackmanb@google.com, ziy@nvidia.com,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm/page_alloc: only update lowmem_reserve_ratio on
 sysctl write
Message-Id: <20260801114434.232c97a74d9616c43aac2456@linux-foundation.org>
In-Reply-To: <tencent_1BB7A5C4D5EEA67346634417753190E92A09@qq.com>
References: <tencent_FFD4F4D728AAE8A8AE0AF277A59854A29A06@qq.com>
	<tencent_1BB7A5C4D5EEA67346634417753190E92A09@qq.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 63B4820003
X-Stat-Signature: bmn3xwz71zci1idoppztu5m8macy5myq
X-Rspam-User: 
X-HE-Tag: 1785609877-59807
X-HE-Meta: U2FsdGVkX1/pFiZbLkXp2/jlhW/ykT6C1LDgh3dXtCZS8qOmYq319nXGfI9sOuLKJW+w8X0RTp3hDJqpgOMgxbyJp8krXZT0UpIMGayZ2PRwVkPnNE3UmdeOz831gm9yEqyeFQ27esQC6fQ1yb/fZMtOEmpk53grheZCb6gD7jKJNoS3IZ90TzqnqjxMMtrz5tE7ZWZ7tM8ewJSOD3Mzuh5TPz9wkS1V/Vc7hfI2JQiG89G395dknH2yCA47Oegr0BO9u/h25LYz+Nwq7avCA/kfQ8NC5QmqEHCxqEc4jYNYN3NswKb1aF3/2IL/Ffcg9G13ubV8Srzii8cJSpFfVTHX/MiU7aHKVDrK+NkQ7JXNAQrrJqOmbkLvUb5Xvd8LL9Wd+Iwi0I972uISLzkk3oz9p6hOrZxOA/Fih3cT5qryVOqCh23l4YURj9mSzX1TqwlnQO0+Rdbh0U0Mh+zq7Nad2xyd+ZZ7x77JbaAHoushWoSBrSxKq0wQmbP95Ui+5uhJU/TDvC9mob5vAYoOJUHLJ5azHKa8bmH41rfDE8q0E+nIIaZxicHowVGqIdBIdt2/GWXAhgsdG75FhIBjs3OD8S+ZzuKH4PnkXVcR7Bo4Jqcuf3FcEE0zP+M2wiaoNx9bSygKxn4Qa2b5bQWR9v5QL0z+I5mRDOm1p5e5B4ie+BzJPcrzEDKFlIwaBxClF/ShhG+dQGh9TkQBrNb9eWFslMJMRRlGDvwGz1ivb7n4zmTJGX0fSWyKB02wZ/AJ45P5iBfWT7NJEnyKqfFtqrh5dUclGELwIW9+usvdtrzxAR3pD0Tqpr6K7ylR3ZzgAgf+1B6mF83f4aiuJ4eO5KQugT7MzwLEf7rhj3VkRlT8qS/LHggclAw//UF9DBcS5gA5UW6YVa9S4pmkRBJ55AeIfKVh9xy28n+SknmwyJhP4W8o8HB6MsanKcHxVz73XYH00PrmCSoOakuA2Fc
 VNYu3Zlw
 psa/a1MZClEtuPpkzXktvkcb1kf2TwJi+AciTipey+VGBVuX0ThWIWGPuBG2njr7Jonw+nKZ8pXhBOocLei0tOMqG8Vz/Cx++3Miz0G4kbe7j9PY7mBQMMFN/YOFNZ7fLaxZvSMjLeLyu7qBj9AwkooT3KdXjnJXHbFDSl71zKtz14w/gzb0gkbhI1akIZFB7xKpXGqlUXzrkPwRfH8nNZdZCVSbrP0DN2Jxe5NkXQPb6yh+ba+BE1eLS8WUecAvYXxKTKDRhabyeuE5uCKTgpJi+oVeM7NPpvrD9+NUHVAZHlYwJeDNH2L6dNFau2azz8JekBhj32wpTTZLaUm9Apc5pglWXYjoJmmLVRcpf+udtt16huh0QR0A5VR1jBn7O7ThTR0+SkjfZvPwh9PTF9wKCHzPstx0fmQ2Pe23r1eASNbWAOkamR7oNzA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat,  1 Aug 2026 23:11:25 +0800 Jianlin Shi <shijianlin11@foxmail.com> wrote:

> lowmem_reserve_ratio_sysctl_handler() ignores the return value of
> proc_dointvec_minmax() and always calls setup_per_zone_lowmem_reserve(),
> even for read operations.
> 
> Fix two issues:
> 
> 1. Propagate errors from proc_dointvec_minmax() instead of always
>    returning success.  For example, writing non-integer garbage to the
>    sysctl now returns an error instead of silently succeeding with
>    unchanged values.

AI review suggest that this caused a new problem:

	https://sashiko.dev/#/patchset/tencent_1BB7A5C4D5EEA67346634417753190E92A09@qq.com

Not sure what to do here.  Perhaps pass proc_dointvec_minmax() a
temporary then copy that into sysctl_lowmem_reserve_ratio if all
proc_dointvec_minmax() returns "OK".

But really this is a flaw in proc_dointvec_minmax() isn't it?  It
shouldn't update the table data until all the data has been validated.


