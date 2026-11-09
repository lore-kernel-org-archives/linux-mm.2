Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E986606EE81
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 16:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HK7HaYQ9
Received: by kanga.kvack.org (Postfix)
	id 473196B05D8; Mon,  9 Nov 2026 11:04:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4244E6B05DA; Mon,  9 Nov 2026 11:04:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 361B16B05DB; Mon,  9 Nov 2026 11:04:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 174586B05D8
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 11:04:52 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B0CE440714
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 16:04:51 +0000 (UTC)
X-FDA: 85416053982.24.380D2E3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2F091100005
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 16:04:50 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HK7HaYQ9;
	spf=pass (imf05.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794240290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=B8e5HKLQPjiewefcw3UmEbt8O+zGd5jVIMRqzWZmXx4=;
	b=ar6A0myttDCMGalzECKtHQObdCOm4XWHKxbELlku4X/159/JdeT/n1rU262HGXch0djsi3
	dKGlGljdTEK/42Nv/Qj6fEw4llO76gCbGc2MkwNthmUPeg/0eWbZ22PaooRS9dcGZGr4dI
	I93TSwlvajSznMhzhNTCKG8CdrpN1Zg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794240290;
	b=CYNvqN2iXVDS6hRPtj3dGly14l412CtHXUUB3N7BIWwqQ10UFbxoj0wPJXKypb/SnYI8tV
	oxO+MOfT+LjSiaXoEBzT2QrrIiISEoBCSnh98FIW+4nJHBdlYN+v9xsGvdxIGPWgU99/dZ
	WTX8jhMYTEnI1XEaR7i8ic4iBbiKnbI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HK7HaYQ9;
	spf=pass (imf05.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A8389633F7;
	Mon,  9 Nov 2026 16:04:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30E461F0089F;
	Mon,  9 Nov 2026 16:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794240289;
	bh=B8e5HKLQPjiewefcw3UmEbt8O+zGd5jVIMRqzWZmXx4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=HK7HaYQ9cr4qa4ccweRAjlbd0uwRGRXknkcWlqbZGuA3kH48Kzlk6mbk6SmZfP49I
	 NZxRTAeUHvNw/oyktGM8GpaTYSWidRIAxZiUmTG2608SpQvc2VKiPf+kVmw7XWe1U6
	 7IjhbEKNyjFePpV5zPbqyW/AEUj2MuSjomR91UzR3LLpMp4k/6zWKz2d+0pIxjFgkL
	 Z6R6kzxVrslOe/ROyncXQ+bPefJmfzuM3bKRRJHKJhgz9VEWLieDBxW22sYJb2oeNG
	 6WtlXWME+dZWiJz2w2bhrkrN54I+fbByJ1Odi3MvSu7EoUXmHC1Byoq2pqWQ0f5MGe
	 1OoTjUBcoAC3g==
Date: Mon, 09 Nov 2026 06:04:48 -1000
Message-ID: <2df6537f1f290e99038cfab7fa36310a@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Wilson Felipe Pereira <wfelipe@google.com>, hannes@cmpxchg.org, mkoutny@suse.com, shuah@kernel.org
Cc: mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev, osalvador@suse.de, david@kernel.org, yosry@kernel.org, nphamcs@gmail.com, chengming.zhou@linux.dev, cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] selftests/cgroup: convert cg_read_*long*() helpers to s64
In-Reply-To: <20261106185520.290139-1-wfelipe@google.com>
References: <20261106185520.290139-1-wfelipe@google.com>
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: fyxgg8yuj6matwnm54n34ahnpj3t1psm
X-Rspamd-Queue-Id: 2F091100005
X-Rspam-User: 
X-HE-Tag: 1794240290-897146
X-HE-Meta: U2FsdGVkX18jU7D4aVEbV+X4cjsZ0NoFUl7NggUMHHmsGyDZ/6RWadX4Qlb17r8+VUjP+8XqmEKYTpA6THO7RnKXpEf534DMi+GwxvbE9/MygGPC7/2elgwqKR9ESlGKt4XFGW9MDDqwD5L9BhSqYl95y8nqdarZiNQfapFx6/GKlMFj2HVtCbBMvCY+rScJCssqLCoP2hcY5wILAbcJkBhV5r9iIeXhmS445WWmYDQAcvMHThY6C2FQrbbjJvFKVW8gdBnbC9uA1QlXcW1rVuGsK6d88gQykHctwq+MeQsPmZC7+Sr68aoyaq31pey/Q4e7gF1pZXqYtFJGLcSbR5JD4w40vZxBxalFOmUm/RiugGlXAcYHmHo8Yf33yTDfGuecIIVNdRsWFBwPrgupkSRZGIrTavCNgZWpOH/DB9tYHpQ+rfwlmCAa7NcCvOyqOWEP8cXn15n3f7RBfJ/mkJhkIly8PQHzruN9KTDoiM6jA3fr7ai2I2ulZDEi4nZ0ldYpMQXEJyXphxY6NimKRnxr51fAu3Nh/XGXavcZUiFe/dhjSWN+0TmGXJm2i5wo87DCOBnfSbcDeEBNvO8zYVdli7EQrwvJmzKSHiojnZutp3OjNmphPv5ixHIX/6ds3nx+aM4J3sAcGm2MTVLhXeiDmD77um8w1LECNATdvn8/4w3YAsyFNfxX6vSpRQLmZ4Wk2ppS9WjLsPiXVTxapyO9iGD1v0IFUatKkaDdbNrZGgqGQdtq7cgVsDME0na4Kf5+k0Wt65akaaoKQgCsLdFr/vRzqqLS1W6T168ugbYaja43BHbRyd/PerhGzZUu5GZtWMI/WoAfOfUcYxtzvIXGwsPKZH/YIHOWooKn2Hw16+x02QPtDCy1YUZDWj4DStPYwJGoqF2K30a46AnjKBqh05Ud47ND1fvA/Ws84Fz+cao3qxBzvUTCfcgfy95iXfmOJx+jH+Cp7FZtZu/
 bo3mKOIA
 f1sYslsf4nwNw8cq4GoKadMQEhFPDfjiBMf4mZo/Azc2CLWq3kx4O4a6b7pQ5oSmezlW1iSa839IgVej/u1jQ1oAgI284BOzVxme7gAtdfSEAxofwIZhauKW+UzFERDOHin3UnrI+DfS+L3d0mBJx61ODELrwamJlFboQX4ZncVbNJUlzpyKDZVvlqP1/6DbM1Y82cCSU6Dc7aHEdBOK1iBO2tNHrc5pBHWKyzT82tKCsFnUT6huC7ATj2hoL6JgYiJCL0VLVyGElHab3iUjTuyT9R3LmkresQsJEMtck6Jhe7p/6tiR06yBW7L0wbSMwiCuJhJT4b6FLYgc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Applied to cgroup/for-7.5.

Thanks.

--
tejun

