Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F343606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 22:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=zssZl2lz
Received: by kanga.kvack.org (Postfix)
	id 9F2EE6B0903; Tue, 27 Oct 2026 18:10:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A4426B0905; Tue, 27 Oct 2026 18:10:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B9486B0906; Tue, 27 Oct 2026 18:10:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 683FD6B0903
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 18:10:11 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5CCD7140B19
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 22:10:10 +0000 (UTC)
X-FDA: 85369800180.04.EAA645B
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5FD9080012
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 22:10:08 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=zssZl2lz;
	spf=pass (imf30.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793139008;
	b=FRmW5jpqGsER0G+ZOPMjqrKSqV9Ke6mcPExly6Dt0a3i3BNyKWKHxLnP8DET84LfRan9dI
	Anh3mAdtlk7Ah72MDHeL7GqUA7mjmgAKW0XSPFMkMCUv7GK5GNujJ6eDrQHUrgs3cZOVLU
	iyfrzfz74a+0Llh9M5HXRFtT0/cgSZA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=zssZl2lz;
	spf=pass (imf30.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793139008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fT+qwxtE+A6GcMts/RFwLqPXWbldRP/ojd/gLikqx/o=;
	b=8Vcz63ES2VAlD9TiQ80nmOGcATNFEl7bvmG4M59dzX7NGbvVU9BQ4VONxypSQ1yMq2vo/G
	SOTBEuRaA3GT5jHDT8qQar0DfHbA0pYffFM9izarxJxSTbg93A7BBdqkMMj+wQhXfTkNtV
	dG+9vU6v+8R9sOjXNYpX3R7tSnyRlRQ=
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-48e04773687so133774f8f.2
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:10:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793139007; x=1793743807; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fT+qwxtE+A6GcMts/RFwLqPXWbldRP/ojd/gLikqx/o=;
        b=zssZl2lzLQjqCLzxGosARz4+hsia6rSo9QFsDbti82uRTWAZ7fEEz/aRS0+vnXz9Ko
         kTPO35kKpJEZ5GikTIU7fGANz+nOUkfgLviiq/p8mxEe72ePb1SxusVk67FYJiSIbxGy
         3NRBMSJlOsqOAztZbzXgY0R6U2n8t/blhrFCiHRE8OYsWElN9D2sdDVz1D+Dpat4C/n+
         h7X1RTQIOhJe7rdH6EQqU0VRVe7x7HOsWUciasKi5geuB7uUuB5xPWQs3t2FM2lZrF3U
         N8mLfKw9vs2/mj2HKuiOB2Fh6GBmE5jOCkeNrnf2pZKtECmvBpx166JL26DPG5YfQ1lG
         kJPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793139007; x=1793743807;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fT+qwxtE+A6GcMts/RFwLqPXWbldRP/ojd/gLikqx/o=;
        b=ALQSik0sPMNLHQ3a9OGBDmfy4BCoigkEIs5kyDDbog5+Z1jOP0ih3KvLbqNp7RRz8x
         AdRYdd2vruFRWzS8yzzEmFNoJlX5LvjmOjULBt6teXUwQtAbzWJd4+zxhyaq6vpynpk6
         RBAgSkTS1g2WjNYP0ItLv0SInh29qthLFYGthisa9WOxQrkT3Oh58WAFzakNlX/PMTNY
         ryPd643VyLEKT+6d0FRbdTTfA/gB9/Cl/FQzPIdbCsbXcP2ugH+t4qFGrcRcBXIFT1GJ
         vlTg5IWxodKMQN+pENnJbF7qwnItEBeg6GhdSlNtt8VEW3dm+2yKTtTfNnsOck4+B7N6
         kXWQ==
X-Forwarded-Encrypted: i=1; AKwUvBzTjXnLEFtBw3NJMeNfJEJKodlcycghCXpNZ8mwYYTp3Tt0fcjDYqKtbb3ZKSCO1Qxuz3xw99LtoA==@kvack.org
X-Gm-Message-State: AFq9FYJw0yQ7f4CUbqHC7Y4p055yHQr+U1wvNxpzM1rGKB8Kcy1KZTgh
	wVMDujTdXFSEbmu0rJ+dAa8AssZd+7aa13Kf9nJQOY5F3x4ol9/xfAU2
X-Gm-Gg: AYBFou2RKrt8wm86mlwSjVNyHjZITDwZmJ2rBXl7wodYAF0k+T5hMVGG90Z9I9fakcX
	xQry0e0MM6U8sagxaFYH69E2DM+6ps4epoF4VdcNFx2NCKRfp/exWKsU99tLZ3QuNXLx8t1N7cJ
	CM2NF6OFizhdUqWdfNAutw1R9r57+tyi+rCztha6/KxwueLfse17JKlzWLhW773A6lqwQ5TOdnQ
	w5k0QRgSAUiddjGNlzJNCpSfqn+kEyerKfWaEAVwCQ6YuE/RCFp4FYTZHre3LpPYWJl95wArm7Y
	h7DzjzlMlZT0jH2Vw7BUkNJWAnSRxnsTp4YCNvXALujjnlds0tRlRmvZOoLDbOUH/Y2PjsEG8hR
	2lexm2lZij2+kou96kt/hu7Hy4RcKm1P4p9BaCwqJaVEcLuymFhXaV9C3OX259VKT/a/bHPbor/
	0cwN49h8gT8dzrMvfIUv0EzufuONha4sF740UMipqzeo7UHmwJRk/N3N2npTHbnYuN0j2o4CEHd
	lWn9MJmAFY2v7INFPVemS01Cnz8ZKwu/5slfThguhcFbNjhAzjo
X-Received: by 2002:a05:600c:8b05:b0:4a3:5a55:f454 with SMTP id 5b1f17b1804b1-4a967202925mr5734215e9.19.1793139006789;
        Tue, 27 Oct 2026 15:10:06 -0700 (PDT)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ecd3555sm24526363f8f.42.2026.10.27.15.10.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Oct 2026 15:10:05 -0700 (PDT)
Message-ID: <968e7fce-a027-4c4e-8a3f-79ddf0b2ba9d@gmail.com>
Date: Tue, 27 Oct 2026 23:10:04 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] fs/proc/task_mmu: fix missed VMAs when reading
 /proc/PID/maps and friends
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Suren Baghdasaryan <surenb@google.com>, Shakeel Butt
 <shakeel.butt@linux.dev>, SJ Park <sj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, stable@vger.kernel.org,
 "David Hildenbrand (Arm)" <david@kernel.org>
References: <20261027-fix-proc-pid-maps-missing-vmas-v2-1-2791cc9fc95f@kernel.org>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <20261027-fix-proc-pid-maps-missing-vmas-v2-1-2791cc9fc95f@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 5FD9080012
X-Stat-Signature: 1xzwjdf5ti8cndry9gf4hcyfb9dwbc11
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793139008-320794
X-HE-Meta: U2FsdGVkX19qoaPrasNCGRx0AB8imHQHx9y3GmJQCW9moKwb9VGl/A5cSYvmRM0IR5ak3QqvIy3s5osyrEl636jsa88dPj20VzPtpP5qIyzHwc8a7goozkQQo4sWL+KFuRrM9zNnPq/IvgyxnZ3VRhcJAhaSmvXK6FpFbpEdtTKnIG+42m5j5a/MRxSejnc4XLOHqcT21FOjIpYRx0jF7mPggbnmKM2IqquFS+NRl5IjR8JSKRjBOJl6mBroGs0AenJF4nsH/FgcfSH7E15oUzRKq4ERd1SzBJvZ33aFp33kmLW5hBHTIXx0dWHjXPY2aCS1rb4+PZCPGIOigi3ey6neYtniSqMQSVoD+TMf02eCkjR/T9OskyoKTFfSrdOUJFRaePj8TylI2bzgvIvoaYNFZ14/l5QPzXifeS7zIlzwl5Q5KyqyCf0/U0rxvHvZ993btXrHBBO2hcSP5vcmakRrLdNanxtipizviOBfvjSiOL0UgaqoYVqaHBH4QqzRnpgwDgZmv5GjkREywQRXsfprNySmOrK0SA+xlj+zjdWtzI1J5ID7ypjE84cn3xMC+syenc8iJLhB53Up4H90jXp0HY0So3ZCHUEWH4O3q4u/aAgQjTzvQDDC+gi2oBo4W/Xkp2ujretwoa1iDe+cQfvcvreQdpM3H/xkmyw6hAqhDPC8E5rhqxYwp/vELISO0H2LgPcN/5HOGA8HUHGRBuJUupXDj92I6dP041iYJ0WakDZXgb6RzPH49UnOgp3bGXDg1X5uX9ec3CVJhGtnfM7A4FxYp2VkiVEAaTWICrEjSlyj63/FYi1oqOKuWGkCjlmNTH8fAZdXrFVZ5EH7FSXpNL1EzaJuEojMJHyYg7FrzP5JA3QWpnn/uXyBryOhdv0aAzcL9dvFgOz+4YDvJd8tR+D2FGbHdhR7VffDzG4G/utpGfgRHuaZP8KHIqB1cMJO80TchKJqsPSSbyh
 80kBl6Ub
 wI6tmIGrM9YyUJgajjVZoQfacNvxREMY+5UDhQl+PY+br6ykhWLvrSVb9Hlf0iqLTZNhJRRDyy7EW2iE1j/D9vvNFSwu3Kg2pGIJ6GCHc8ozyDFZV5gdpXma2IWGmZr6iR0wGfhe7nHYq4CJh7f/fDDrsb66egSlAc7qj58iBidWDGA+Q5N5iP32iD9Lt4RH+Sbn4JzUa5KVIqovpavh2X9Q30PhKXUsz0vsjTrtf4W8DCgLn4DeDqXfP00XqFnGE2EfEc+7PGiZ8qip8wwHooeeKbBh2fRw8CLBjlbJ4UC0hzhqmKCarXNgYK12Az281cTx1YBdt4PE8jUAy7dbLbDMBn00OBmDju+3Ob8xn6aY3JsdYyy0ihN/9qCHa/hDUAobBh5P/OJOGWOtOdgzn5EPEp9VXfN95/rN8UiOihXPl11AUpq21smQdVgP0BNWinaCZMIIhfvXIBRr7A5UEC39ejHCqzFSAsaqUT9Eefkf5/UGGP6vrbI/xJksqSGiHWsGu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/27/26 3:08 PM, Lorenzo Stoakes (ARM) wrote:

[snip]

> +	if (from_addr < vma->vm_start &&
> +	    vma_rcu_iter_may_have_skipped(rvmi, from_addr, vma->vm_start - 1))
> +		goto fallback_unlock;

the helpers make this a lot easier to follow than v1 :)

I re-tested v2 on x86_64 in qemu with KASAN, as in v1. So, this LGTM:

Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Tested-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

-- 
cheers,
jose a. p-a

