Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02183C83F26
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 19:42:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 761698E0002; Wed, 30 Jul 2025 15:42:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7395E8E0001; Wed, 30 Jul 2025 15:42:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64EEA8E0002; Wed, 30 Jul 2025 15:42:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 522E58E0001
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 15:42:10 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E546AC048A
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 19:42:09 +0000 (UTC)
X-FDA: 83721951978.26.2387739
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf10.hostedemail.com (Postfix) with ESMTP id B2022C000A
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 19:42:07 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ItvsT7pN;
	spf=pass (imf10.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753904527;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7tpp67HFXaje+zbq/UUFU2CGWBxgZPwO5Ve5z07q/6c=;
	b=TN8H25xWdeG3uKqXr4ECGHmNjaFFZLDG53b923jtCDxDq3/pU6Lfgt0BrKhs7ItKT0Rvoh
	gtjFRwwWGZSRjYBrA0YwpUBgKn0t3oowcve0iuhr3swRk1CCG7/+CXS5c7g2ksvfDJ38ki
	3M5F6X6upN9folbPPRRk0XJ6wyLGYv0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ItvsT7pN;
	spf=pass (imf10.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753904527; a=rsa-sha256;
	cv=none;
	b=jNsZSS6RBHo/pxI2eeHc0Y+MQStz6RwyIyW0b7CrWtISC7jWaWErIfP5wcUW07qR8T7xlF
	t+SS0lEZ6jwIbAcYxoT5Rbh1MNntgwXY4nsCdxgBysStobbiQIAxQypQsq+uXCOy2DHEV3
	Lxj8v21rd0GHgZpP3ZL+SlyDRW3+Ll4=
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3b782cca9a0so148471f8f.1
        for <linux-mm@kvack.org>; Wed, 30 Jul 2025 12:42:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753904526; x=1754509326; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7tpp67HFXaje+zbq/UUFU2CGWBxgZPwO5Ve5z07q/6c=;
        b=ItvsT7pNGGuUQTjbEFjYioM8FC2+g8EKNxGrqQTPfxlc2q1zmzhnomFY1KEjUbrXy/
         fsdYly87Qzl1oihPVgFz8bLfjPo2UVz/irSgNMczAW+XOBj2SHV/IodJQciydGEVQ79H
         0aFvANbevGP3qYn7I9KQqho9JS5l1khyrcqUFA0/FODyoQznG6eec8PDBOhLwFKuh/dc
         xAxl3uMSKjZgyfKTuhQNc61cVkn/ToW9z3MSiPNUNDxOHqy6icCmaV6Wqu0Z49WzIiHn
         fWOpLTxXA5XG8Ma8ebQjfiT0mHeqZO7eUTHmwJCaL3MG5yr3YERxhaYsXCY9wjHPIS02
         7oww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753904526; x=1754509326;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7tpp67HFXaje+zbq/UUFU2CGWBxgZPwO5Ve5z07q/6c=;
        b=t8xXwajXJiJ/f0z7izNj5rCarH69S+ecnm6uzZgFdBtjiMq6Fn5s3zo8Ay+Vsqrdy8
         LJoNXaCjiX/j6Vvjorn8SWZCrt37AdNrEkqVYXgjKpfZ+DNjdOsHprnKXFddoKs/5L9m
         SgSWwUUBwuAib9+gh31iY1MQnOovvrwOSe3QgwGyaBDALZQ4uTnJrQ37j7R1uhqvsKo8
         GKc8SjtsgEHR6JYbeCedgTjD27wM7HcmCnjuEeoHSYlwuzOoUIr5Yt8WyYc9JBX5lulR
         9FjuycoLgkzBKjYPBxGD9I0wUjl2A9j/0NtDgrG+gJGtWl6ZtYN0I9eQBAheQL58HDa2
         6BbA==
X-Forwarded-Encrypted: i=1; AJvYcCWc+rHU6Yao6vjaEMoKmhtqMAS6q4XU+GpX4NDm/b4LWE0eHj7pRJ+ifjF/qWnHvZYwxFEiBJlrtw==@kvack.org
X-Gm-Message-State: AOJu0YwAKCIHdHm0AWdGQ9W5HpCcD8Ki96Ae/7Sagm45u+YMBzast11+
	y4+aa7uBkc2oZUHAsj02hNVlGu9dpb+DAqSfpKFfSCAffQo44JdwfyPL
X-Gm-Gg: ASbGncuSdh9+zwCe6/Lypn99J+Ebs7eqbonsm5uHTETdIzOMhOfudW/+UG66dezYDqu
	NOyk3v+CTGzabAdxMkPBkIVsNncnDQ8aIG8ex86glDlznzvQvOB3nIq4USJeqLM95pYvjaUHPlT
	2NzOHbeO4x+hNF6XXtbCefmU7czdkmjrY6LhxPPuGQzEORBxPiIuLOBLt9AMTGxnLWmSmeEGzhZ
	46EgkncxrtNes8FXdwZkIedbRiAUyK8ZBBRDyckPKlNbDfkZC98DbsG/TWzayZZ5hzZtbJHRgxl
	raacTy8CFy4btU55S4A2YDHcALPnlCEIbbbdO7SXngAmvHI2aAcUIGvO36C3WYbXPGiSZUb1cV0
	T3ACLYh+plZTmbm46bv3paN8zltwtCjrM+qY3UKeBOmow3XGFhWDyuKd3vEhgGRttlsQcW6Hvrt
	ybauZzkfVXyw==
X-Google-Smtp-Source: AGHT+IGsO0a/g7U9Rcz2FlbWDKJ4AZTN79lLc8ocT/BXod2T3ojj+yGN6+Ym+T6RPVjWMdgLtBXe1A==
X-Received: by 2002:a05:6000:3107:b0:3b7:885e:cd0f with SMTP id ffacd0b85a97d-3b794ffd082mr2757513f8f.31.1753904525724;
        Wed, 30 Jul 2025 12:42:05 -0700 (PDT)
Received: from ?IPV6:2a02:6b6f:e759:7e00:8b4:7c1f:c64:2a4? ([2a02:6b6f:e759:7e00:8b4:7c1f:c64:2a4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458953cfcadsm41231225e9.18.2025.07.30.12.42.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Jul 2025 12:42:05 -0700 (PDT)
Message-ID: <6eab6447-d9cb-4bad-aecc-cc5a5cd192bb@gmail.com>
Date: Wed, 30 Jul 2025 20:42:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/5] prctl: extend PR_SET_THP_DISABLE to optionally
 exclude VM_HUGEPAGE
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@redhat.com,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, corbet@lwn.net,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org,
 baohua@kernel.org, shakeel.butt@linux.dev, riel@surriel.com, ziy@nvidia.com,
 laoar.shao@gmail.com, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, Liam.Howlett@oracle.com, ryan.roberts@arm.com,
 vbabka@suse.cz, jannh@google.com, Arnd Bergmann <arnd@arndb.de>,
 sj@kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 kernel-team@meta.com, Matthew Wilcox <willy@infradead.org>
References: <20250725162258.1043176-1-usamaarif642@gmail.com>
 <20250725162258.1043176-2-usamaarif642@gmail.com>
 <8c5d607d-498e-4a34-a781-faafb3a5fdef@lucifer.local>
Content-Language: en-US
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <8c5d607d-498e-4a34-a781-faafb3a5fdef@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: axiiktq97b5hsgfm3bdm31k8mxoiixhz
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B2022C000A
X-Rspam-User: 
X-HE-Tag: 1753904527-233393
X-HE-Meta: U2FsdGVkX18iPcOZYNJ6JgjuX6s+cRzLU4+/38kajTryOZnT5P+tD413oOTno7yS9/0KHSVn/VJR9tNOFBvuATO1Dpmb07El22aXn3AnYdWsQh2jGaUYZ0wvo/VC9b1mCcixXgG6GABFGvpxV/y58VPO7RfaWeKLSZtUbAGoCmRk76bvU6QHIgnnVoWkDvKVObTTcV3BEqPBcP2xa2t5VbFQZi4VOgtQlKwOS4P7oYBVuh4oLOqDYMsbtwXcx64ugH0b2tT2ly8JTwPDSHECR3Epm7Q3Pkccx2QH393z4wMeJOcNeB9m/X5+bBd8z/VqNxZhJ7QYl9Vcbr0/XqqN03j9VAUU8I9O8LfSzRzG3wWZKD74pLrXFtl818pUeUGOjcBWicOBACrUgGNfeZdP+dExHEENJg80iwNRWjPsqkMpbVbySv0WKT+jX6rUapdnWJNpjeB7NzCZ0ymDZEaVD3q1cCyAZbvWmkXwzHXN9FZ373B47EN6m9ozd9ZTKJsz18YV1CiwurfLFTuFEbWtJSP3+93PyKy8HqZBxknZElCkrmz0iE2k0DxvTbuJbUOkHsbsJ5QfcS6b0eZJgmMgtmBICu708iAnpIuA6cVsp3Vw9I42MGYHyqluyyNSxcYoh80MGO6TvLamkWp+JWTYHrAQttS9ScNUqci5muQJ73emUNaA4clYEysP90c2r5OM9pUe/m/Xxwo8Dvv4Hxs2n3V9cnAh7k4W2z6PdU7xAriSjZuvF9fs3d0Jqncl0O3oJRIIvESbAVTlXrPC/t0z/xlI/FkWi1E/jzWOpIjkMBVfnm60bJXYciThI60NMiyk+c/QoMLqsy+UgbezsoljUZf30lDYBk/EvNFndXmNUhKSIw+1y5nszqsJpcrcL8UZxPCe7izHilGhF7v+P3XlWqJ9drE2I2v7oICLJtCEBYRHYz9nX/3+iNCkY/891jCwrcdAeSOfp45fCSIiSEh
 w23fc+04
 5X7BDoyL8LWeqT0QoDrrLL7CsXkXA04YDaLqNTAw9q6tE9EShxzZJYT8l7i9Ktul13JFWPulQQk4/8SrlXCxuJsPqXbnjwzTaHlFlHSjt5KUGqvl2aaL2x5vIPfwlcY7yBlqy7hNg7PYja1fQ6yXmkIfu9IwdVgmamDhuAJz5QiQ/shzh3h+2bgtERg8HTVeVoCLOCZHuqDF+OGeVbdmqzT6Z1j0f+FkYRx3S+kGX6qfgM66W+y2EcnfG7Mb6mIpaI6nT+xmdcXJhhmdQWTlYFsYmiuJKfhPzkZ9JfTn/tYXG7iN+znTCi7PtIySyN885tG9Lhvt+6i1WR8YnvQZTa3F+vHK+mFuZePT+3poUl0dng5nfCyBSjPWe80TtrPYzjhHUYgAuF0DwvdtUU2ZeAIq3ohpyJkV81ENWZFHubzE7itSfjDB22PcVmhIImNkCqg+F6hkkTh1nmwznzrR5qASFmh5bDE5YdLsfdmQWeaTUfntUUkKdSOXCXJqS5IXJDdEY0/kPlQcRDHavNP5s0Sk/ewv16x18TrqIF1YnBpIM30M4qa/nbO8MG/uep6SMtM51j3WOpcWloqaIUXjnyLg7jRs92U7MXIEN3sgJC30vjEBxburKiIQLE6Wc6lqr11Ug2tBkz5b6w4bNeevNV6vYQjzRGWKLSFZJTHSHZ1sydMKE7dXZ3/rSy7VSTmMMj5rxNny6OIsG76hWBgbe63Is+p2BbJ/ePMy3jIEs5/1pAlmFqcaHs8Sy5sVwpOSd4lZqsZ0AZkPeZNPoU04KYAC1yUy4FsJWBm4UWRAVPe+BGsPPlulgAoRxg5si1SZj5l/SjjGIXpiktfjU3BVcgmyglaa87UZZKr1AC5LKmvdLMkVtQB/VY8VusUCR7/Q+Qfl+yq8mqQTz4ny0nNeF8adE00nYKfywIjUI91+ysvVhnpn5bHFEalJCi1dsMTLq7SGODcjgc9cyqc6r9BgyP6FgHz/0
 sIqYFmDk
 fhqorGaFlQO04FeHrf07Qml8q4z9DSEq6gpjmNODGfaVRAR16KQ/07nSsQ4Qpy416rCCcOdotMWERmjPCDdUVl7orYCFKtSpcPgsPAJynEfZWM62+dQM3g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 30/07/2025 20:31, Lorenzo Stoakes wrote:
> An aside - we should update the man page for this - see
> https://man7.org/linux/man-pages/man2/PR_SET_THP_DISABLE.2const.html
> 
> This has to be done separately from the series I think.
> 
> On Fri, Jul 25, 2025 at 05:22:40PM +0100, Usama Arif wrote:
>> From: David Hildenbrand <david@redhat.com>
>>
>> People want to make use of more THPs, for example, moving from
>> the "never" system policy to "madvise", or from "madvise" to "always".
>>
>> While this is great news for every THP desperately waiting to get
>> allocated out there, apparently there are some workloads that require a
>> bit of care during that transition: individual processes may need to
>> opt-out from this behavior for various reasons, and this should be
>> permitted without needing to make all other workloads on the system
>> similarly opt-out.
>>
>> The following scenarios are imaginable:
>>
>> (1) Switch from "none" system policy to "madvise"/"always", but keep THPs
>>     disabled for selected workloads.
>>
>> (2) Stay at "none" system policy, but enable THPs for selected
>>     workloads, making only these workloads use the "madvise" or "always"
>>     policy.
>>
>> (3) Switch from "madvise" system policy to "always", but keep the
>>     "madvise" policy for selected workloads: allocate THPs only when
>>     advised.
>>
>> (4) Stay at "madvise" system policy, but enable THPs even when not advised
>>     for selected workloads -- "always" policy.
>>
>> Once can emulate (2) through (1), by setting the system policy to
>> "madvise"/"always" while disabling THPs for all processes that don't want
>> THPs. It requires configuring all workloads, but that is a user-space
>> problem to sort out.
>>
>> (4) can be emulated through (3) in a similar way.
>>
>> Back when (1) was relevant in the past, as people started enabling THPs,
>> we added PR_SET_THP_DISABLE, so relevant workloads that were not ready
>> yet (i.e., used by Redis) were able to just disable THPs completely. Redis
>> still implements the option to use this interface to disable THPs
>> completely.
>>
>> With PR_SET_THP_DISABLE, we added a way to force-disable THPs for a
>> workload -- a process, including fork+exec'ed process hierarchy.
>> That essentially made us support (1): simply disable THPs for all workloads
>> that are not ready for THPs yet, while still enabling THPs system-wide.
>>
>> The quest for handling (3) and (4) started, but current approaches
>> (completely new prctl, options to set other policies per process,
>> alternatives to prctl -- mctrl, cgroup handling) don't look particularly
>> promising. Likely, the future will use bpf or something similar to
>> implement better policies, in particular to also make better decisions
>> about THP sizes to use, but this will certainly take a while as that work
>> just started.
>>
>> Long story short: a simple enable/disable is not really suitable for the
>> future, so we're not willing to add completely new toggles.
>>
>> While we could emulate (3)+(4) through (1)+(2) by simply disabling THPs
>> completely for these processes, this is a step backwards, because these
>> processes can no longer allocate THPs in regions where THPs were
>> explicitly advised: regions flagged as VM_HUGEPAGE. Apparently, that
>> imposes a problem for relevant workloads, because "not THPs" is certainly
>> worse than "THPs only when advised".
>>
>> Could we simply relax PR_SET_THP_DISABLE, to "disable THPs unless not
>> explicitly advised by the app through MAD_HUGEPAGE"? *maybe*, but this
>> would change the documented semantics quite a bit, and the versatility
>> to use it for debugging purposes, so I am not 100% sure that is what we
>> want -- although it would certainly be much easier.
>>
>> So instead, as an easy way forward for (3) and (4), add an option to
>> make PR_SET_THP_DISABLE disable *less* THPs for a process.
>>
>> In essence, this patch:
>>
>> (A) Adds PR_THP_DISABLE_EXCEPT_ADVISED, to be used as a flag in arg3
>>     of prctl(PR_SET_THP_DISABLE) when disabling THPs (arg2 != 0).
>>
>>     prctl(PR_SET_THP_DISABLE, 1, PR_THP_DISABLE_EXCEPT_ADVISED).
>>
>> (B) Makes prctl(PR_GET_THP_DISABLE) return 3 if
>>     PR_THP_DISABLE_EXCEPT_ADVISED was set while disabling.
>>
>>     Previously, it would return 1 if THPs were disabled completely. Now
>>     it returns the set flags as well: 3 if PR_THP_DISABLE_EXCEPT_ADVISED
>>     was set.
>>
>> (C) Renames MMF_DISABLE_THP to MMF_DISABLE_THP_COMPLETELY, to express
>>     the semantics clearly.
>>
>>     Fortunately, there are only two instances outside of prctl() code.
>>
>> (D) Adds MMF_DISABLE_THP_EXCEPT_ADVISED to express "no THP except for VMAs
>>     with VM_HUGEPAGE" -- essentially "thp=madvise" behavior
>>
>>     Fortunately, we only have to extend vma_thp_disabled().
>>
>> (E) Indicates "THP_enabled: 0" in /proc/pid/status only if THPs are
>>     disabled completely
>>
>>     Only indicating that THPs are disabled when they are really disabled
>>     completely, not only partially.
>>
>>     For now, we don't add another interface to obtained whether THPs
>>     are disabled partially (PR_THP_DISABLE_EXCEPT_ADVISED was set). If
>>     ever required, we could add a new entry.
>>
>> The documented semantics in the man page for PR_SET_THP_DISABLE
>> "is inherited by a child created via fork(2) and is preserved across
>> execve(2)" is maintained. This behavior, for example, allows for
>> disabling THPs for a workload through the launching process (e.g.,
>> systemd where we fork() a helper process to then exec()).
>>
>> For now, MADV_COLLAPSE will *fail* in regions without VM_HUGEPAGE and
>> VM_NOHUGEPAGE. As MADV_COLLAPSE is a clear advise that user space
>> thinks a THP is a good idea, we'll enable that separately next
>> (requiring a bit of cleanup first).
>>
>> There is currently not way to prevent that a process will not issue
>> PR_SET_THP_DISABLE itself to re-enable THP. There are not really known
>> users for re-enabling it, and it's against the purpose of the original
>> interface. So if ever required, we could investigate just forbidding to
>> re-enable them, or make this somehow configurable.
>>
>> Acked-by: Usama Arif <usamaarif642@gmail.com>
>> Tested-by: Usama Arif <usamaarif642@gmail.com>
>> Cc: Jonathan Corbet <corbet@lwn.net>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>> Cc: Zi Yan <ziy@nvidia.com>
>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
>> Cc: Nico Pache <npache@redhat.com>
>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>> Cc: Dev Jain <dev.jain@arm.com>
>> Cc: Barry Song <baohua@kernel.org>
>> Cc: Vlastimil Babka <vbabka@suse.cz>
>> Cc: Mike Rapoport <rppt@kernel.org>
>> Cc: Suren Baghdasaryan <surenb@google.com>
>> Cc: Michal Hocko <mhocko@suse.com>
>> Cc: Usama Arif <usamaarif642@gmail.com>
>> Cc: SeongJae Park <sj@kernel.org>
>> Cc: Jann Horn <jannh@google.com>
>> Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
>> Cc: Yafang Shao <laoar.shao@gmail.com>
>> Cc: Matthew Wilcox <willy@infradead.org>
>> Signed-off-by: David Hildenbrand <david@redhat.com>
>>
>> ---
>>
>> At first, I thought of "why not simply relax PR_SET_THP_DISABLE", but I
>> think there might be real use cases where we want to disable any THPs --
>> in particular also around debugging THP-related problems, and
>> "never" not meaning ... "never" anymore ever since we add MADV_COLLAPSE.
>> PR_SET_THP_DISABLE will also block MADV_COLLAPSE, which can be very
>> helpful for debugging purposes. Of course, I thought of having a
>> system-wide config option to modify PR_SET_THP_DISABLE behavior, but
>> I just don't like the semantics.
>>
>> "prctl: allow overriding system THP policy to always"[1] proposed
>> "overriding policies to always", which is just the wrong way around: we
>> should not add mechanisms to "enable more" when we already have an
>> interface/mechanism to "disable" them (PR_SET_THP_DISABLE). It all gets
>> weird otherwise.
>>
>> "[PATCH 0/6] prctl: introduce PR_SET/GET_THP_POLICY"[2] proposed
>> setting the default of the VM_HUGEPAGE, which is similarly the wrong way
>> around I think now.
>>
>> The ideas explored by Lorenzo to extend process_madvise()[3] and mctrl()[4]
>> similarly were around the "default for VM_HUGEPAGE" idea, but after the
>> discussion, I think we should better leave VM_HUGEPAGE untouched.
>>
>> Happy to hear naming suggestions for "PR_THP_DISABLE_EXCEPT_ADVISED" where
>> we essentially want to say "leave advised regions alone" -- "keep THP
>> enabled for advised regions",
>>
>> The only thing I really dislike about this is using another MMF_* flag,
>> but well, no way around it -- and seems like we could easily support
>> more than 32 if we want to (most users already treat it like a proper
>> bitmap).
>>
>> I think this here (modifying an existing toggle) is the only prctl()
>> extension that we might be willing to accept. In general, I agree like
>> most others, that prctl() is a very bad interface for that -- but
>> PR_SET_THP_DISABLE is already there and is getting used.
>>
>> Long-term, I think the answer will be something based on bpf[5]. Maybe
>> in that context, I there could still be value in easily disabling THPs for
>> selected workloads (esp. debugging purposes).
>>
>> Jann raised valid concerns[6] about new flags that are persistent across
>> exec[6]. As this here is a relaxation to existing PR_SET_THP_DISABLE I
>> consider it having a similar security risk as our existing
>> PR_SET_THP_DISABLE, but devil is in the detail.
>>
>> [1] https://lore.kernel.org/r/20250507141132.2773275-1-usamaarif642@gmail.com
>> [2] https://lkml.kernel.org/r/20250515133519.2779639-2-usamaarif642@gmail.com
>> [3] https://lore.kernel.org/r/cover.1747686021.git.lorenzo.stoakes@oracle.com
>> [4] https://lkml.kernel.org/r/85778a76-7dc8-4ea8-8827-acb45f74ee05@lucifer.local
>> [5] https://lkml.kernel.org/r/20250608073516.22415-1-laoar.shao@gmail.com
>> [6] https://lore.kernel.org/r/CAG48ez3-7EnBVEjpdoW7z5K0hX41nLQN5Wb65Vg-1p8DdXRnjg@mail.gmail.com
>>
>> Signed-off-by: David Hildenbrand <david@redhat.com>
>> ---
>>  Documentation/filesystems/proc.rst |  5 +--
>>  fs/proc/array.c                    |  2 +-
>>  include/linux/huge_mm.h            | 20 ++++++++---
>>  include/linux/mm_types.h           | 13 +++----
>>  include/uapi/linux/prctl.h         | 10 ++++++
>>  kernel/sys.c                       | 58 +++++++++++++++++++++++-------
>>  mm/khugepaged.c                    |  2 +-
>>  7 files changed, 81 insertions(+), 29 deletions(-)
>>
>> diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
>> index 2971551b7235..915a3e44bc12 100644
>> --- a/Documentation/filesystems/proc.rst
>> +++ b/Documentation/filesystems/proc.rst
>> @@ -291,8 +291,9 @@ It's slow but very precise.
>>   HugetlbPages                size of hugetlb memory portions
>>   CoreDumping                 process's memory is currently being dumped
>>                               (killing the process may lead to a corrupted core)
>> - THP_enabled		     process is allowed to use THP (returns 0 when
>> -			     PR_SET_THP_DISABLE is set on the process
>> + THP_enabled                 process is allowed to use THP (returns 0 when
>> +                             PR_SET_THP_DISABLE is set on the process to disable
>> +                             THP completely, not just partially)
>>   Threads                     number of threads
>>   SigQ                        number of signals queued/max. number for queue
>>   SigPnd                      bitmap of pending signals for the thread
>> diff --git a/fs/proc/array.c b/fs/proc/array.c
>> index d6a0369caa93..c4f91a784104 100644
>> --- a/fs/proc/array.c
>> +++ b/fs/proc/array.c
>> @@ -422,7 +422,7 @@ static inline void task_thp_status(struct seq_file *m, struct mm_struct *mm)
>>  	bool thp_enabled = IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE);
>>
>>  	if (thp_enabled)
>> -		thp_enabled = !test_bit(MMF_DISABLE_THP, &mm->flags);
>> +		thp_enabled = !test_bit(MMF_DISABLE_THP_COMPLETELY, &mm->flags);
>>  	seq_printf(m, "THP_enabled:\t%d\n", thp_enabled);
>>  }
>>
>> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
>> index 7748489fde1b..71db243a002e 100644
>> --- a/include/linux/huge_mm.h
>> +++ b/include/linux/huge_mm.h
>> @@ -318,16 +318,26 @@ struct thpsize {
>>  	(transparent_hugepage_flags &					\
>>  	 (1<<TRANSPARENT_HUGEPAGE_USE_ZERO_PAGE_FLAG))
>>
>> +/*
>> + * Check whether THPs are explicitly disabled for this VMA, for example,
>> + * through madvise or prctl.
>> + */
>>  static inline bool vma_thp_disabled(struct vm_area_struct *vma,
>>  		vm_flags_t vm_flags)
>>  {
>> +	/* Are THPs disabled for this VMA? */
>> +	if (vm_flags & VM_NOHUGEPAGE)
>> +		return true;

VM_NOHUGEPAGE will cause the THP being disabled here.

>> +	/* Are THPs disabled for all VMAs in the whole process? */
>> +	if (test_bit(MMF_DISABLE_THP_COMPLETELY, &vma->vm_mm->flags))
>> +		return true;
>>  	/*
>> -	 * Explicitly disabled through madvise or prctl, or some
>> -	 * architectures may disable THP for some mappings, for
>> -	 * example, s390 kvm.
>> +	 * Are THPs disabled only for VMAs where we didn't get an explicit
>> +	 * advise to use them?
>>  	 */
>> -	return (vm_flags & VM_NOHUGEPAGE) ||
>> -	       test_bit(MMF_DISABLE_THP, &vma->vm_mm->flags);
>> +	if (vm_flags & VM_HUGEPAGE)
>> +		return false;
> 
> Hm is this correct? This means that VM_NOHUGEPAGE no longer results in THP being
> disabled here no?

Lorenzo, pointed to VM_NOHUGEPAGE case above.> 
>> +	return test_bit(MMF_DISABLE_THP_EXCEPT_ADVISED, &vma->vm_mm->flags);
>>  }
>>
>>  static inline bool thp_disabled_by_hw(void)
>> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
>> index 1ec273b06691..123fefaa4b98 100644
>> --- a/include/linux/mm_types.h
>> +++ b/include/linux/mm_types.h
>> @@ -1743,19 +1743,16 @@ enum {
>>  #define MMF_VM_MERGEABLE	16	/* KSM may merge identical pages */
>>  #define MMF_VM_HUGEPAGE		17	/* set when mm is available for khugepaged */
>>
>> -/*
>> - * This one-shot flag is dropped due to necessity of changing exe once again
>> - * on NFS restore
>> - */
>> -//#define MMF_EXE_FILE_CHANGED	18	/* see prctl_set_mm_exe_file() */
>> +#define MMF_HUGE_ZERO_PAGE	18      /* mm has ever used the global huge zero page */
>>
>>  #define MMF_HAS_UPROBES		19	/* has uprobes */
>>  #define MMF_RECALC_UPROBES	20	/* MMF_HAS_UPROBES can be wrong */
>>  #define MMF_OOM_SKIP		21	/* mm is of no interest for the OOM killer */
>>  #define MMF_UNSTABLE		22	/* mm is unstable for copy_from_user */
>> -#define MMF_HUGE_ZERO_PAGE	23      /* mm has ever used the global huge zero page */
>> -#define MMF_DISABLE_THP		24	/* disable THP for all VMAs */
>> -#define MMF_DISABLE_THP_MASK	(1 << MMF_DISABLE_THP)
>> +#define MMF_DISABLE_THP_EXCEPT_ADVISED	23	/* no THP except when advised (e.g., VM_HUGEPAGE) */
>> +#define MMF_DISABLE_THP_COMPLETELY	24	/* no THP for all VMAs */
> 
> It's almost a bit weird to have these as separate flags, since they're distinct
> (of course, I don't think there's necessarily another way).
> 
> Though this makes me think maybe in future we can have a new mode where both
> enabled == something else :P
> 
> But perhaps I've been infected with 'bit packing' disease.
> 
> Anyway as discussed in the THP meeting, I'm going to be (hopefully!) making
> the mm flags a bitmap soon so we'll get more flags available.
> 
>> +#define MMF_DISABLE_THP_MASK	((1 << MMF_DISABLE_THP_COMPLETELY) |\
>> +				 (1 << MMF_DISABLE_THP_EXCEPT_ADVISED))
>>  #define MMF_OOM_REAP_QUEUED	25	/* mm was queued for oom_reaper */
>>  #define MMF_MULTIPROCESS	26	/* mm is shared between processes */
>>  /*
>> diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
>> index 43dec6eed559..9c1d6e49b8a9 100644
>> --- a/include/uapi/linux/prctl.h
>> +++ b/include/uapi/linux/prctl.h
>> @@ -177,7 +177,17 @@ struct prctl_mm_map {
>>
>>  #define PR_GET_TID_ADDRESS	40
>>
>> +/*
>> + * Flags for PR_SET_THP_DISABLE are only applicable when disabling. Bit 0
>> + * is reserved, so PR_GET_THP_DISABLE can return "1 | flags", to effectively
>> + * return "1" when no flags were specified for PR_SET_THP_DISABLE.
>> + */
>>  #define PR_SET_THP_DISABLE	41
>> +/*
>> + * Don't disable THPs when explicitly advised (e.g., MADV_HUGEPAGE /
>> + * VM_HUGEPAGE).
>> + */
>> +# define PR_THP_DISABLE_EXCEPT_ADVISED	(1 << 1)
> 
> NO space after # please.
> 

I think this is following the file convention, the space is there in other flags
all over this file. I dont like the space as well.

>>  #define PR_GET_THP_DISABLE	42
>>
>>  /*
>> diff --git a/kernel/sys.c b/kernel/sys.c
>> index b153fb345ada..b87d0acaab0b 100644
>> --- a/kernel/sys.c
>> +++ b/kernel/sys.c
>> @@ -2423,6 +2423,50 @@ static int prctl_get_auxv(void __user *addr, unsigned long len)
>>  	return sizeof(mm->saved_auxv);
>>  }
>>
>> +static int prctl_get_thp_disable(unsigned long arg2, unsigned long arg3,
>> +				 unsigned long arg4, unsigned long arg5)
>> +{
>> +	unsigned long *mm_flags = &current->mm->flags;
>> +
>> +	if (arg2 || arg3 || arg4 || arg5)
>> +		return -EINVAL;
>> +
> 
> Can we have a comment here about what we're doing below re: the return
> value?
> 

Do you mean add returning 1 for MMF_DISABLE_THP_COMPLETELY and 3 for MMF_DISABLE_THP_EXCEPT_ADVISED?

I will add it in next revision.

>> +	if (test_bit(MMF_DISABLE_THP_COMPLETELY, mm_flags))
>> +		return 1;
>> +	else if (test_bit(MMF_DISABLE_THP_EXCEPT_ADVISED, mm_flags))
>> +		return 1 | PR_THP_DISABLE_EXCEPT_ADVISED;
>> +	return 0;
>> +}
>> +
>> +static int prctl_set_thp_disable(bool thp_disable, unsigned long flags,
>> +				 unsigned long arg4, unsigned long arg5)
>> +{
>> +	unsigned long *mm_flags = &current->mm->flags;
>> +
>> +	if (arg4 || arg5)
>> +		return -EINVAL;
>> +
>> +	/* Flags are only allowed when disabling. */
>> +	if ((!thp_disable && flags) || (flags & ~PR_THP_DISABLE_EXCEPT_ADVISED))
>> +		return -EINVAL;
>> +	if (mmap_write_lock_killable(current->mm))
>> +		return -EINTR;
>> +	if (thp_disable) {
>> +		if (flags & PR_THP_DISABLE_EXCEPT_ADVISED) {
>> +			clear_bit(MMF_DISABLE_THP_COMPLETELY, mm_flags);
>> +			set_bit(MMF_DISABLE_THP_EXCEPT_ADVISED, mm_flags);
>> +		} else {
>> +			set_bit(MMF_DISABLE_THP_COMPLETELY, mm_flags);
>> +			clear_bit(MMF_DISABLE_THP_EXCEPT_ADVISED, mm_flags);
>> +		}
>> +	} else {
>> +		clear_bit(MMF_DISABLE_THP_COMPLETELY, mm_flags);
>> +		clear_bit(MMF_DISABLE_THP_EXCEPT_ADVISED, mm_flags);
>> +	}
>> +	mmap_write_unlock(current->mm);
>> +	return 0;
>> +}
>> +
>>  SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
>>  		unsigned long, arg4, unsigned long, arg5)
>>  {
>> @@ -2596,20 +2640,10 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
>>  			return -EINVAL;
>>  		return task_no_new_privs(current) ? 1 : 0;
>>  	case PR_GET_THP_DISABLE:
>> -		if (arg2 || arg3 || arg4 || arg5)
>> -			return -EINVAL;
>> -		error = !!test_bit(MMF_DISABLE_THP, &me->mm->flags);
>> +		error = prctl_get_thp_disable(arg2, arg3, arg4, arg5);
>>  		break;
>>  	case PR_SET_THP_DISABLE:
>> -		if (arg3 || arg4 || arg5)
>> -			return -EINVAL;
>> -		if (mmap_write_lock_killable(me->mm))
>> -			return -EINTR;
>> -		if (arg2)
>> -			set_bit(MMF_DISABLE_THP, &me->mm->flags);
>> -		else
>> -			clear_bit(MMF_DISABLE_THP, &me->mm->flags);
>> -		mmap_write_unlock(me->mm);
>> +		error = prctl_set_thp_disable(arg2, arg3, arg4, arg5);
>>  		break;
>>  	case PR_MPX_ENABLE_MANAGEMENT:
>>  	case PR_MPX_DISABLE_MANAGEMENT:
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index 1ff0c7dd2be4..2c9008246785 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -410,7 +410,7 @@ static inline int hpage_collapse_test_exit(struct mm_struct *mm)
>>  static inline int hpage_collapse_test_exit_or_disable(struct mm_struct *mm)
>>  {
>>  	return hpage_collapse_test_exit(mm) ||
>> -	       test_bit(MMF_DISABLE_THP, &mm->flags);
>> +	       test_bit(MMF_DISABLE_THP_COMPLETELY, &mm->flags);
>>  }
>>
>>  static bool hugepage_pmd_enabled(void)
>> --
>> 2.47.3
>>


