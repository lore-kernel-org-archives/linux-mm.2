Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5330F589C4
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 12:52:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5D556B0005; Thu, 23 Apr 2026 08:52:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0DE26B008A; Thu, 23 Apr 2026 08:52:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FCB86B008C; Thu, 23 Apr 2026 08:52:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8A20A6B0005
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 08:52:35 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 508CE16011B
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 12:52:35 +0000 (UTC)
X-FDA: 84689809470.23.32F0D48
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8054D40008
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 12:52:33 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FFKbgUMj;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776948753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SZJmbahbJYjm6PyqpxjneG+fiaKk2LDW0iLO0aYlf4o=;
	b=EjcmV79djVCKKoL8118KRUxxNWhVnxbpD77E9Ic7m6g6KFahPtYPJONPzMAGPDmtavMqR+
	2muVoCoLFTCl82FhW4ApzBakdkhZDAH7HbAinK+n3eP/q94A4CA1v8jmAO/vMm0iQXR+Cy
	Zl2264aOE3h5oqAy/v3wjh5J0QS91Vk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776948753; a=rsa-sha256;
	cv=none;
	b=qpuZg6L1B2QvmJTGC6PQwTpFZRXuZLRzPZjEuSUV/gV70k/xQbP9F8sAQpjIv1W1UtiHF0
	vMiAVOGs6Sv2G/Z5DT/SrXqOwDLhczpzsTfuVhxML3hNrmo3dy9nH8k7UrdyqCd1WlydrB
	OoSEPuCTTpJlhhmtvzXzi1aMyNWA/HY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FFKbgUMj;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D2EC26013B;
	Thu, 23 Apr 2026 12:52:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3F01C2BCAF;
	Thu, 23 Apr 2026 12:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776948752;
	bh=h0dIHU98MRwB37l3ilALHGus+i/AMpoovRfTb1CIX6M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=FFKbgUMjMYHXkRXq+vf1uwScuPWl8nWvt95X8tyi94yQanvWYXRUYBMFXWsU3lES+
	 74RIRakc+e95FQ3vjrGnA/8Xh24I1cs3WdqUJXP0vUTvF4FJvlW2SdH/LMAkvQPHTj
	 d+YQyNPF6fJmRy8XDSi1HDSGnwhOMcti85Ib1PPb8KlzRNaL/qtDulb6SirrNUFx/o
	 +b1ihmhRpE0z9LJYLCG/8CNF9dqZL7WjZ8sQ3wkIhxLjUrZWd7z/GOK8Obl1WdxpLJ
	 HXt00hk/IIXS44mZOVexB3w4WBfeF/Gr/0wiJk7uaf566NPpshW/8D+NGBjweSO4Jr
	 HeUq0yG+rW2Ig==
Message-ID: <62d88cde-efc0-48cb-be8d-813eda810343@kernel.org>
Date: Thu, 23 Apr 2026 14:52:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] mm/process_vm_access: pidfd and nowait support for
 process_vm_readv/writev
To: Usama Arif <usama.arif@linux.dev>, Alban Crequy <alban.crequy@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Christian Brauner <brauner@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Alban Crequy <albancrequy@microsoft.com>, Peter Xu <peterx@redhat.com>,
 Willy Tarreau <w@1wt.eu>, linux-kselftest@vger.kernel.org, shuah@kernel.org
References: <20260409142256.131676-1-usama.arif@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260409142256.131676-1-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: mto4qosem1w6nkmxp7jy5t4nb3jyum9o
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8054D40008
X-Rspam-User: 
X-HE-Tag: 1776948753-815672
X-HE-Meta: U2FsdGVkX18HgwwYizph/Sdz5CFjjtYx73HVLu7Nk8E5PGyz5rK6lFSIrj8On5rRTeJ0j59zglJ5ObBqCRvAQejkkFVseUbZD+HKBNiiVnRhR4P7Zv+UrsCqxwP9RE3E+qQ2eyDA3hnYoAPBNjmt9dRt2eB71E8gOKKbcMCtCK5fG4vmYuEhDYd4LrVxot7QA/90VB4Rvr/9k9i8L1hiKDPRW1/j9ko/LIZzTdMvyVyxGyzeMFfdi8+yXPA9+/T0tFmofLA5a54ViBMXvndqvGcOn5xPb3GEfFmJCINe9chizPAmi+PuB3uQXBPO0/SijwWcyLiZVtnDDlwr7+EAjXwtK7y5sTuM6rAhR0kVkjuAVvEusrHZNNnocqAvEdnYIp3HMRuyQqI3RIlLKDtA2ivaxaiJJ3iPLTaZrEnldDMQJosvn6fwuX1JllOlo+kiqOKwnw+87Q2Pvh7EKrcvkdBWMcmVixrD5SXe3Uyih4x6t6GOrjLxkbpMPIiRZJfh1KaJK+eeKdvq0hjcPAO5Mtdg8IS8Fzvmd5qDWdJyGS8QFsXTiZtgBftroNAeEU8F+/RKZdxkbg363GTq9zmzINDeml0qvrd5dhvITpNoIyXDIbaJznz/juXg1gigEJ4sCNbyoZ/aHZi39zn9Rs8nCfgyp8EAGZWU8uTqU11b4JJ5CJLdPfyTVz+qSuoAt1l+mwX+qS/k35SVYl1iiX9+kejaReZ0UpTTfmLMz0MgrAUeX1MmUP3PKy+kOC2USNq73x5ql0u0ArUrw1IyHIcv7swZyO1QGNRQMqXk2tKH/rOoVBgbEUAut8QgJ1yG6yg6K/sglZZnjdtfWeirDiGBSoNmBaWHPHdkd0I+OfMiHdbUChne7w5RmmiaFs0RlhAulQsxGc5C6kpfwjD7Ejx7LjIbfesrogIa0MtTMwSmsAeCqW5SYioC+uB6N06LahWKhJhjUMJKhZQUpnikXzd
 wNG1Rekl
 5Q6h3+TFGAk57b2DvSk3hFYpJ5jamICAZDvvkXOM887ij80ucljj2SkoOxxJi2T4bDTkonnT4O8LopOlJCP3NjIPgBx0DTS+h3R3WjjwUTZAE2KHBwm3HuKKTYBqEbxg7PVGSs9FUqzemDgs8xVJpLwLHqRY1Hx2SfsUajMiDNlLrdMeRJbzdPq7KVoutFjyaT5jBCeb3gH4XuRhuFwX4zhof4s3iKbqoX6UWgDnUYHLqjXeQpt8uo8ps9U9KiiQcKPBwhkz733qHlE/veb5lLnwijcwbvHUZfS+UtK9P0dizNMnf35OcEc5CfffcU0g16gXSYyeyMYcVm/lCSGqpV75Y5zqqC3LQSSWhPVYjXblkLCHyOWU6r9XOIg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>  
>>  	/* Get process information */
>> -	task = find_get_task_by_vpid(pid);
>> +	if (flags & PROCESS_VM_PIDFD)
>> +		task = pidfd_get_task(pid, &f_flags);
>> +	else
>> +		task = find_get_task_by_vpid(pid);
>> +
>>  	if (!task) {
>>  		rc = -ESRCH;
>>  		goto free_proc_pages;
> 
> pidfd_get_task() returns ERR_PTR() on failure (e.g. ERR_PTR(-EBADF)),
> but the code checks "if (!task)" which only catches NULL. An invalid
> pidfd will cause mm_access() and put_task_struct() to dereference an
> error pointer, crashing the kernel.

Yes. Should we add proper selftests that exercise these code paths?

-- 
Cheers,

David

