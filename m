Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61D12FF8875
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 13:58:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A65E26B008A; Thu, 30 Apr 2026 09:58:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3D336B008C; Thu, 30 Apr 2026 09:58:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 954146B0092; Thu, 30 Apr 2026 09:58:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 832186B008A
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 09:58:57 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2083AC462A
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 13:38:06 +0000 (UTC)
X-FDA: 84715325772.08.6C12706
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 59E7C160003
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 13:38:02 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JK0ZZeQL;
	spf=pass (imf08.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777556283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zvpc3ouiLend2nTOGgnsZ2P9GoiNqqJrDz+MQzcNl04=;
	b=S9l9K3p9bdNPZJnViEnWW1O+ZHB3odd/pYc6Fc+PrZ8itLt1lpodhZnCd/Lbk5HV0MLX3K
	YSchaizFWNPgz8k4wPz3bLhf7qCzqYwg1lMYFTqk9+YmIJK62rGvJ8uQLSMQqsBes+DwiR
	N1V1PeyOW0W1Kp6UnNmnid7mUgykYbs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JK0ZZeQL;
	spf=pass (imf08.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777556283; a=rsa-sha256;
	cv=none;
	b=OUOowwI7sYOHRRwXVf7ZE8bC4RknwRQ0QV7IeWKSaMRxd4i6EB5Ut/oZ00T/MKSVZBWqte
	gpJzxgBeZfYBawPFrOIbL6t/pPW9GWyWH/6Z6tn4PSTdMVuHmT6L+WmOu/hto3svbrLFXs
	cgv3deM+hq9/SW8nMkCRWbSuOMtVzcQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777556281;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Zvpc3ouiLend2nTOGgnsZ2P9GoiNqqJrDz+MQzcNl04=;
	b=JK0ZZeQLimijOfE6lItSVkjM3C6tSXD49T0OUJ7V68sQer1Ea/OpaM7cCku9Y89WE5y91p
	YCXVsA/BCVIGMHSwIP72wLTt+9j0s6MlFTmvkwvr8P5ruN8I1F5/ob1ZKLdXXXtmmsJODB
	BK+DZ9jbZ10wpo33tkHQEbD3f6Yxzok=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-568-yVWh4iHrP_O7YotYRR3e2g-1; Thu, 30 Apr 2026 09:37:57 -0400
X-MC-Unique: yVWh4iHrP_O7YotYRR3e2g-1
X-Mimecast-MFC-AGG-ID: yVWh4iHrP_O7YotYRR3e2g_1777556276
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-50d84b5f73bso26019531cf.0
        for <linux-mm@kvack.org>; Thu, 30 Apr 2026 06:37:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777556276; x=1778161076;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Zvpc3ouiLend2nTOGgnsZ2P9GoiNqqJrDz+MQzcNl04=;
        b=ERAZhTQ546UM/Ig1jS5VCIWB4PHcjOkrdAaEENZn9PBKe9ar+KKE7gFCbq/SMDkJbX
         q5Weso/Sbb2cUCUVognn5+aaJdRQ2vNQH9hmwVb3fv0W1FE/seijXPLAtMtHG9X209Fx
         Qju6dyI7m5zJXa1DR07XsOHJyzyPacI5CqNq/eyHq7H3K6m+aeUhfX/4n/Xz9hvC/0Ez
         uvz4mMACYMbG+dSfW7qQzatjjul6sPHyaFM1eyrX1nXBk14rzmBi2GJGj5LXDj+zobHM
         GnwGNE0CMPHtmUuwcQNHX6WogLqxen8uiSHD0aywLMMRhqlODY5n7YUTrtdg7VkCq/fk
         ibfw==
X-Forwarded-Encrypted: i=1; AFNElJ8kTQle9Ow+lvVBhZ6dTyRwmzSNsXFy7eEtthruMzki5rkWWRsxLOQcob1gKAG5vFpM2phXgfiaww==@kvack.org
X-Gm-Message-State: AOJu0Yyw6fPx540uC1ALcQDhvoqRl9olCm9GrsESKdrRVYiCFXYMvzvY
	yuehMIzh1ubRNPL6K+pSU9dYU/MzBIHtzNsRh9trt+fXJUSLBWgv9QG+y5XoPWwclOGXljEia87
	4bQj0y4VuhIjJrTC6u3RpA+d+qQ9oA+b7E1O6kGrUFHdn+7HKqPgo
X-Gm-Gg: AeBDietJqwpqGWinT0Unk3AMg480Y4N2cs6/Ne+FNbBNgX5aPI3NJWVguXGLrHQj3zz
	zxbG6tUDiBXjqS3DLMSRoAhvHzw/xO3wgli2n9tT9B8f0FJF5YR2PwEHPMhmjksUNXUWJ0tgULQ
	oyXkNmHp6gaFBVjja9z8Z22EKg2owA7M9K1fLMwvFIQgR4PqQYtj2pQ/eC0jOPL8rkWjdqIifMB
	cmBUXWtXemxFBDxi9JORa3GZhgZdLuXyUm0DNboykXOWr769TE+r1r66oeHrjjfhGWdR6UCWNFz
	21D7y62vZq+iKG9a5J+WLpSpynyeXAeWASgEc2yECDXLMzudVb6TR/edwvNXUuzC8dz2qrZuMlt
	YAzkrfSGi6EB/Jc7sGlXQh2VFmhdYIUTFt7o=
X-Received: by 2002:a05:622a:586:b0:509:2b02:c1bd with SMTP id d75a77b69052e-5102aad8a94mr44515981cf.12.1777556276111;
        Thu, 30 Apr 2026 06:37:56 -0700 (PDT)
X-Received: by 2002:a05:622a:586:b0:509:2b02:c1bd with SMTP id d75a77b69052e-5102aad8a94mr44515291cf.12.1777556275587;
        Thu, 30 Apr 2026 06:37:55 -0700 (PDT)
Received: from [192.168.2.110] ([70.53.202.134])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5101aeb58desm48316071cf.29.2026.04.30.06.37.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Apr 2026 06:37:55 -0700 (PDT)
Message-ID: <6b12453b-2683-41cc-bb4c-602eda6bf9d8@redhat.com>
Date: Thu, 30 Apr 2026 09:37:43 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 04/54] selftests/mm: migration: properly cleanup
 fork()ed processes
To: Mike Rapoport <rppt@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
 Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
 Donet Tom <donettom@linux.ibm.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lance Yang <lance.yang@linux.dev>,
 Leon Romanovsky <leon@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Mark Brown <broonie@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Nico Pache <npache@redhat.com>, Peter Xu <peterx@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Sarthak Sharma
 <sarthak.sharma@arm.com>, Shuah Khan <shuah@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org
References: <20260428204240.1924129-1-rppt@kernel.org>
 <20260428204240.1924129-5-rppt@kernel.org>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <20260428204240.1924129-5-rppt@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 4JeY8_bgDk4wklLR94ElfErZiTbiIiPhaK4ZLUXxX1w_1777556276
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: g4cweudwwkrkmjoi5aa7uy57d1orrgfs
X-Rspamd-Queue-Id: 59E7C160003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777556282-663021
X-HE-Meta: U2FsdGVkX1/B5Al3+rPpMEuUbAWPwrJwLWRudJz4HfJTamRNZcqOgvIQSdn42iB9azmW615zmfZnOoVpYoBUrVHLqUejg0k4vuA70Di/zz3B8irto/E83tGv5dnOZiJmHOqQuJjI84cFlK1LYSEOVMY6v7qt5GDJWpSW55RQ4UszXRspNibH9h953mZWh43ljDoCXfWgmeLDyg+u/uK7QGhcE2+oePbG1IZOqaTwUEpqVeh9ZXoKRqQFzDGrQZPNmVC3I6ksTNaGCxvIE8sgbtwJudwNESU1qL0z6GQp7xthFIQRD9YBEXCS8hH7Xtj5UYP1XxhXVtZlFLAQsSfZ5n6bzfNAPLdioMCQ4q286temwWILheqQlSVs4wc1JRE7/C5wIsVsu8asDZaYs78vjICKAgRvys0ro4Qtx1K+bF1YiTZhNPi3nPmKcqNwpZ5KM0N4E7I0FGJRnXyicQ3QQaNdmOK3eyAn0u+NpPcY9vC4LwtCrBrsXGLZM/vXDCkOFXl+/Si7O0bDLpXPjUTDnx4Zjdd9kimTnu+6qSBRwE6PXv2NCh082B6dB87aYWNDLNscuAqlEUs469dGnk23N5eGAnSUKgJYtXrpfX2sBNdglxgJgYzOGCMe0S/8YyWnTk9rBM2Whs3cgE+7uh7Q9rlfi+EFlJa38edGnQB9hmA3VxAalZZ9ROzM4i1xcwpXCWYN2vgZTIbgpzYJziIzdCzfvodsjUr2nJGpv8vSXL3vZuRZUqP/0PFdUitMghej9KQH/8pKnF7W3FT5ZgODQgbDS/QmmHLENsgKKGJn4Btf2Udf24b0Dj/C/AgJYW7WeuvSuRDCOPSGOgSIn2cwxpb0EU9vRKVVOROrKGgDTzZX3K2WDF/NdIMXR4XcaYB0FGlvpSa9Lktu91nAj69Kjyaw3SnKzhjtB35aJsjpIGPC28/0UC5qudoafZQV25bur36dwJtkte/s+/xUUQc
 qb4zdMLE
 uK6p/U+jdW2Xy4PGjdjGoEKPxSt9QsSsdI4Q6oBjxTuQ5P3P0JleNYWQdTmTkUYdME9S6+O7O9mccN9ntYYCu2rOUGjJQHhWIAsnT6mvL/ViVA0x/1/GFHAWK2buwd48KUXVFSl3BePoWoYR2ULC+znk8vtLRd33ZTQFKKIyT1MF6xehC1k+yYjGs/47mzrCtatwKxsnc/fcyVDXHU2SSHlsru3MnS/x3KN8GpKDirjzCp5oVO4eiFG/0ET54hyvm+dXrcEnIVXuCSFT42Yn/RtvximOmCNgMfZGUd3OJdWk+OmvZlNLHbfKNL8HvGNNNKAn3OZW5tENioeb4dnDCIfIvWsewnc94eOzx8NV+NFvQYiDpducRGtp1KZZZ7XefunV1uJZC3+XXXOY1sFu9mn2mczAV0q05SgMkMbZ8ooRGLndpcHn/qfwqgqQlZkwb1NqkCAXZKTHCHObiWDSNzMXvBpcsY8b+kEuQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-04-28 16:41, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Several migration test use fork() to create worker processes. These
> processes are later killed, but nothing collects their exit status and they
> remain as zombies in the system.
> 
> Add a helper function that kills the worker processes, waitpid()s for
> them and verifies the exit status.
> 
> Replace the loops that call kill() for each process with a call to that
> helper.
> 
> The addition of waitpid() calls also makes sure the migrating process never
> exits before the processes accessing the memory, so it's possible to drop
> the call to prctl(PR_SET_PDEATHSIG, SIGHUP).
> 
> Reported-by: Luiz Capitulino <luizcap@redhat.com>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>   tools/testing/selftests/mm/migration.c | 54 +++++++++++++-------------
>   1 file changed, 27 insertions(+), 27 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/migration.c b/tools/testing/selftests/mm/migration.c
> index 3630f2fb0800..76e380b74658 100644
> --- a/tools/testing/selftests/mm/migration.c
> +++ b/tools/testing/selftests/mm/migration.c
> @@ -67,6 +67,24 @@ FIXTURE_TEARDOWN(migration)
>   	free(self->pids);
>   }
>   
> +static bool kill_children(FIXTURE_DATA(migration) * self)
> +{
> +	int i, status;
> +	pid_t pid;
> +
> +	for (i = 0; i < self->nthreads; i++) {
> +		pid = self->pids[i];
> +		if (kill(pid, SIGTERM))
> +			return false;
> +		if (pid != waitpid(pid, &status, 0))
> +			return false;
> +		if (!WIFSIGNALED(status) || WTERMSIG(status) != SIGTERM)
> +			return false;
> +	}

Why do we stop at the first error? Wouldn't it be better to kill &
collect all of them and then return false if at least one fails?

> +
> +	return true;
> +}
> +
>   int migrate(uint64_t *ptr, int n1, int n2)
>   {
>   	int ret, tmp;
> @@ -160,20 +178,14 @@ TEST_F_TIMEOUT(migration, shared_anon, 2*RUNTIME)
>   	memset(ptr, 0xde, TWOMEG);
>   	for (i = 0; i < self->nthreads; i++) {
>   		pid = fork();
> -		if (!pid) {
> -			prctl(PR_SET_PDEATHSIG, SIGHUP);
> -			/* Parent may have died before prctl so check now. */
> -			if (getppid() == 1)
> -				kill(getpid(), SIGHUP);

This goes beyond this series, but I wonder if we should have this check
in access_mem() in case the parent dies in migrate().

> +		if (!pid)
>   			access_mem(ptr);
> -		} else {
> +		else
>   			self->pids[i] = pid;
> -		}
>   	}
>   
>   	ASSERT_EQ(migrate(ptr, self->n1, self->n2), 0);
> -	for (i = 0; i < self->nthreads; i++)
> -		ASSERT_EQ(kill(self->pids[i], SIGTERM), 0);
> +	ASSERT_EQ(kill_children(self), true);
>   }
>   
>   /*
> @@ -236,20 +248,14 @@ TEST_F_TIMEOUT(migration, shared_anon_thp, 2*RUNTIME)
>   	memset(ptr, 0xde, pmdsize);
>   	for (i = 0; i < self->nthreads; i++) {
>   		pid = fork();
> -		if (!pid) {
> -			prctl(PR_SET_PDEATHSIG, SIGHUP);
> -			/* Parent may have died before prctl so check now. */
> -			if (getppid() == 1)
> -				kill(getpid(), SIGHUP);
> +		if (!pid)
>   			access_mem(ptr);
> -		} else {
> +		else
>   			self->pids[i] = pid;
> -		}
>   	}
>   
>   	ASSERT_EQ(migrate(ptr, self->n1, self->n2), 0);
> -	for (i = 0; i < self->nthreads; i++)
> -		ASSERT_EQ(kill(self->pids[i], SIGTERM), 0);
> +	ASSERT_EQ(kill_children(self), true);
>   }
>   
>   /*
> @@ -300,20 +306,14 @@ TEST_F_TIMEOUT(migration, shared_anon_htlb, 2*RUNTIME)
>   	memset(ptr, 0xde, hugepage_size);
>   	for (i = 0; i < self->nthreads; i++) {
>   		pid = fork();
> -		if (!pid) {
> -			prctl(PR_SET_PDEATHSIG, SIGHUP);
> -			/* Parent may have died before prctl so check now. */
> -			if (getppid() == 1)
> -				kill(getpid(), SIGHUP);
> +		if (!pid)
>   			access_mem(ptr);
> -		} else {
> +		else
>   			self->pids[i] = pid;
> -		}
>   	}
>   
>   	ASSERT_EQ(migrate(ptr, self->n1, self->n2), 0);
> -	for (i = 0; i < self->nthreads; i++)
> -		ASSERT_EQ(kill(self->pids[i], SIGTERM), 0);
> +	ASSERT_EQ(kill_children(self), true);
>   }
>   
>   TEST_HARNESS_MAIN


