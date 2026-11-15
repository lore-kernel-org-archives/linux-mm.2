Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88EEA606A32D
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 04:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZvJgXKkb
Received: by kanga.kvack.org (Postfix)
	id 76B536B00EF; Sat, 14 Nov 2026 23:27:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71C7A6B05B0; Sat, 14 Nov 2026 23:27:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60C426B05B1; Sat, 14 Nov 2026 23:27:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 28B276B00EF
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 23:27:54 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8EBF580519
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 04:27:53 +0000 (UTC)
X-FDA: 85436070426.15.BFE7BD8
Received: from mail-dl1-f52.google.com (mail-dl1-f52.google.com [74.125.82.52])
	by imf03.hostedemail.com (Postfix) with ESMTP id BC52520006
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 04:27:51 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ZvJgXKkb;
	spf=pass (imf03.hostedemail.com: domain of ritesh.list@gmail.com designates 74.125.82.52 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794716871;
	b=RcderHDx8rsIksJ022wkEAld3uneKAm9aJKQKEqb4LYDbSztQXS9rjjh0KBjQL828IYUkr
	H/iZfFZhuK34GwTSC1IKwxmk6Nw7A+zkV+hak7pBbIzTz9TdSTwiqCmB89o4rxslYQF+6A
	h6Ud1tlvVWnPJHIoeiudoBBM7UUZsQI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ZvJgXKkb;
	spf=pass (imf03.hostedemail.com: domain of ritesh.list@gmail.com designates 74.125.82.52 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794716871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lBVnC2BKavV2mvXAWvVCtFrvsJ4cH4FcPMsK31plLKI=;
	b=tcDyDq6DPJHQ+IVszcsSQSDPUVfMesvgckzG1ZxWz+tloNIjBO789IN16tEvSGxIAAXHui
	qxxOLhddmJE3BcnAmieIY2C7vZWebEyaXShxCCYfr2qnH3G+TItAMpcATaLToCugVDsl0E
	CHNgtpQYLj/LoFWcfhbWQqOUmqGkpcc=
Received: by mail-dl1-f52.google.com with SMTP id a92af1059eb24-1b3a05f8b5bso2863294c88.1
        for <linux-mm@kvack.org>; Sat, 14 Nov 2026 20:27:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794716870; x=1795321670; darn=kvack.org;
        h=content-type:mime-version:references:message-id:date:in-reply-to
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lBVnC2BKavV2mvXAWvVCtFrvsJ4cH4FcPMsK31plLKI=;
        b=ZvJgXKkbNFVy8aaOWpMU57MZwm1lDmmPvUXZz8PiG7XxfRJdRqPTMqYRpgYBkZWa3G
         6xwT/D7LQNAtF7DwZNzKvygFvF0n42mfTuHb3K59NzZujEfSYvUxctfNAYiZFmeaBDQn
         YlgLBzIqVBFt36LzGML9pwT2DfPw9uI9ZPCbxKI9NdcaogDDRWgxVB6Q+BqV8c8vB7iI
         4tWC4nqzmPG9Q9xDGNh61jMSFwCrRuqq1O8x1yzRaD279Y8nKw1fgvDI1daFuYD8U1gu
         XY7k9bqU0LNRADK3A/aDm948bus5WuR/+hEMjGCCacodmKFXuEqILBCex2iqEygnIqve
         8dEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794716870; x=1795321670;
        h=content-type:mime-version:references:message-id:date:in-reply-to
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=lBVnC2BKavV2mvXAWvVCtFrvsJ4cH4FcPMsK31plLKI=;
        b=136O+/fXRLG43GDGZZ+1hG6MjajXauaokabMUEjCFJXoCotK7R1liMcsoPZ1b/BZ5+
         kYx3sS7TGS/oOa9GTlft/VL4B6dDRf1YnA/DHcMZcNnSf+CBDogpC+JCv8B15qAnpcZA
         ZCpn0xscoWAO9cuJqeWg3zTgTnt8HiIAtcCM161lhqT5FaGmd4h9kuMBLfqr2IqNuJqn
         Q0vY4vWZVCn3aygFjwvhfenxq6KrmMUG5u54aBW0Cmnx8UdVnOMOjREBDnPJ1TPTgJ1u
         AvMCqGrpF/kUK2Ifpkz7VIoZQaCv+sFe7XNOkoLvNi9r2Os9w1weJtCBssXAAA/DgH9j
         iWew==
X-Forwarded-Encrypted: i=1; AL+hErHQoNenHq9nDFCKhA1Q6mL/lUpD0zfoLiGTGSqmC+S90GSf9f2yUCfFmDzCTRMCWNgJGNO9b7W6TA==@kvack.org
X-Gm-Message-State: APuU4Z+5XJ8gLj1Hm70Te95dkoQ8G0GdU4FmFi8eTgO9SCrcnv05d0qs
	CgWDEbhUjtrwc5qMeJEoSrM3+Fcl6AQMxQtdH7A3J4Y/a2voonw1vabx
X-Gm-Gg: AYBFou0anTuE8hK82UpPM+sJJ5PppQR4+7Efyr1njiI6n3a0SZKSxLPY4+pNyeuU6hF
	L7j8zbvNBpC6KMLMI6sX7kZScqIE9H73bQzeIj+ZpMp+NURj5gPu5QIf6cnjS7YvngjzHK2HtFt
	MCmjhYcl16ZApuWN6tYNchp6fJ6VbMRuRSUvV5NeSg5hsg7qjlCqmsUhnAbVfSVz7QcdCOBVKM4
	mwXuwOWScHj+uYfjbNKUbZYuSUZzGM/eC2zsWYGTbvJ9hDEhRR5ZqigfiJPVuAYKmvuERVz7612
	4ZbpOeQ2HGXOTx3pZtVYHYj3RuhXB2T3idvRFp4EDGEeE7EQMWda8qA9+2C38MtbnP9Q492BvhC
	SRUNP/1QAmLxSBh189HPAaxCM0Djl2VxG+lzlEl8cqKKyRaHZ4PZ81k2bI/8xwjleEG8sw+f2Cj
	Ek1iLVFANuAmwzjnodmOmS2IJaHnPI78sYbfeVLjcqwLGigdtDmHiqdef6/K7DOzqxF1oXkZcsX
	1h7AYq+yslj8jIQlkCWOZLvsfrdDMiQlLvtXb83fJDPuoYzpjk3EspLh92T1q4ta8L2COK804gY
	4jYCV7Im5nvF4okEFvWeDBbhfgA=
X-Received: by 2002:a05:7300:ff46:b0:37b:c89d:1d56 with SMTP id 5a478bee46e88-37bc89d354bmr1627673eec.12.1794716870280;
        Sat, 14 Nov 2026 20:27:50 -0800 (PST)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3797f98b9b2sm20640706eec.6.2026.11.14.20.27.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 20:27:49 -0800 (PST)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jason Gunthorpe
 <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, Peter Xu
 <peterx@redhat.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan
 Kara <jack@suse.cz>, Rik van Riel <riel@surriel.com>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Harry Yoo
 <harry@kernel.org>, Jann Horn <jannh@google.com>, Lance Yang
 <lance.yang@linux.dev>, Zi Yan <ziy@nvidia.com>, Matthew Brost
 <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, Ying
 Huang <ying.huang@linux.alibaba.com>, Alistair Popple
 <apopple@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, Nico
 Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev
 Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, Usama Arif
 <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, Xu Xin
 <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, Madhavan
 Srinivasan <maddy@linux.ibm.com>, Nicholas Piggin <npiggin@gmail.com>,
 Michael Ellerman <mpe@ellerman.id.au>, "Christophe Leroy (CS GROUP)"
 <chleroy@kernel.org>, Shrikanth Hegde <sshegde@linux.ibm.com>, Pedro
 Falcato <pfalcato@suse.de>, Kairui Song <kasong@tencent.com>, Qi Zheng
 <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, Axel
 Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal
 Hocko <mhocko@suse.com>, Leon Romanovsky <leon@kernel.org>, SJ Park
 <sj@kernel.org>, Rakie Kim <rakie.kim@sk.com>, David Rientjes
 <rientjes@google.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian
 Brauner <brauner@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Ingo
 Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa
 <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, Adrian Hunter
 <adrian.hunter@intel.com>, James Clark <james.clark@linaro.org>, Masami
 Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, John
 Johansen <john.johansen@canonical.com>, Georgia Garcia
 <georgia.garcia@canonical.com>, Paul Moore <paul@paul-moore.com>, James
 Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, Mimi
 Zohar <zohar@linux.ibm.com>, Roberto Sassu <roberto.sassu@huawei.com>,
 Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, Eric Snowberg
 <eric.snowberg@oracle.com>, Fan Wu <wufan@kernel.org>, Stephen Smalley
 <stephen.smalley.work@gmail.com>, Ondrej =?utf-8?B?TW9zbsOhxI1law==?=
 <omosnacek@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 kvm@vger.kernel.org, damon@lists.linux.dev,
 linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
 apparmor@lists.ubuntu.com, linux-security-module@vger.kernel.org,
 linux-integrity@vger.kernel.org, selinux@vger.kernel.org
Subject: Re: [PATCH 00/13] mm: continue vma_flags_t conversion
In-Reply-To: <au-DXpEi4wHwsz0r@gremlin>
Date: Sun, 15 Nov 2026 09:50:28 +0530
Message-ID: <7bie914j.ritesh.list@gmail.com>
References: <20261105-late-2026-vma-flags-v1-0-0d3cd15ab75f@kernel.org> <d0ea7929-7c12-4245-ba3f-6dd5c0269e6b@kernel.org> <au3r0-geuwtRYPiC@gremlin> <1c0b1368-a381-4b25-bba9-7a4f8e92b764@kernel.org> <au-DXpEi4wHwsz0r@gremlin>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: hxkqf47rnwtpb47fwxzz8aokdhbjpo7y
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BC52520006
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794716871-500942
X-HE-Meta: U2FsdGVkX19zZB8m4zQW+5qMbyw9hPX8r6Ny7IgyM0BCNnT0x1iEP5g0f8dk6ZYuEuLsGWo3BNDLJHJ6YRdYCGDI2N5GMQxBUerDdlE8Iqih87HoFj2cFF9Y1HyHZ7HhBwYdGuskKRFd8Y0S6uEOkIDsWksZPOAH9pRCxCf8ooyGPLE8EJcuH/AdcV4QkELMu2baRsclxx59BPrO+gnoJzdVe/mzJoZZ/lAXqeZCoTSv2Sjd9Gk8VHy8Gn4dPZtfrUf8vHpSVVulswbFMWvLw6DOLkmjbNmJwqOwFlCILR12PQ4D9bON2LvGXAgUkb3PCblThe+CohVIpv6WLnrHAf3QIVOhG66V5RRmYOiUOSnyJlmd9VfeJqhxi8reAujkkA3Va7pX5VqpnDSMHH2MQbyPDyGad0C45Kc27zpZnqVQOdhYZUPvIVaHqxKCvl//bF2gTW6/XAJrUixxzBESp5cvtshQYEXAjfDfB0heMMptqYEBgNmDFs7abXSCcXMB8DEDuoF7gNNMgrLA8nipIQxnpf8/bLlN3J1cZW5qbn3yxH19Z0u8GxH/oLQn60PB7MeGVIYxM7xU8rNiSwlc8DnmSh3SGHGyl9jM83jrsZqtDLx8ntq8CGi3sNzgVIuqhTOJ2e+jeacXAXIiWyAQfXowp3x5wAbKubynoYpfBewb0/kI87wW5vKxuTTDQcHnBopj4ivradowloaq6gjLCfHcoDjUuop8s6ZyFHCgeiLrLUQPHk4pKg4ZAKyHTrgmuyR+8UkoLSaqrUC/NYxM02GKBPCB04PXwkzSyQjXk40kl/ABbpBK8pv/OrBH+ODauC8nPF0PXxHIvBDTkxvyBWh8Xw8rMX9AqQDe+6L7luDCbuudcqx+no4LDcrWItkqQ1wUoMlIajvCCbIYvqbGQhW9N3NJKfaMmgcfOIQpghnoYFV1E4UC/A9ur0/C2uyiqOglGeiXmrK1s9bjWnL
 hCZHuo7c
 Sjfl1cv63MybsASIB4KE/HZbI/5y4ac48tZY+fKhqNFciF4LsJMHcKUbx2q7FHC4/IH9YXMbK98DlBVaxnu3uxMh4X71k8bb4/67CMT0D4NYufrHeIOcLzxuE+6KlCudACp4LYf49d806HEudOgBSvJ9zkW2TgEyYOL+n8WbjcR/7dcA+jN5rZmhryht7P6UAlQeECS/wDDXvyoERMpqOnI9jJWD1se0rvxJubZ0uIi8zV/vO6AubsWLtP+300Mu2zbl/2FuZ80ZpRztdcCAyYH/28zZWBvTPwysH3L9UZ967UhwsusZ6pKTpxRgHf+LJoBTxhiUmCT05vTOcXKSCa+9Y/p0p1BlDh1bOYg5dIIWZu7SOZZE+PATg68fvjiWYIpwhTbTyRiUKALXRHLSKN+oNEJXpPCjtKoWJUp0B3vJewFZ4NZCf/OctTHI3+ebe7D6IXVkioa24sNW3MZwNO8i0XYjKbp8cBDgsX4svb/cJpbsF8TKcedbL2dU+JInz2u2VAVNbn8G9OQi4o3FJ6jY5VgZvx2Ta/ShzYlXMqLaRdtM5wZ6WS4HCjmqHANRRxm+JQAihXy7zHO3IrktcqNVQpA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

"Lorenzo Stoakes (ARM)" <ljs@kernel.org> writes:


>> > It's not really all over the place, it's converting vm_flags_t to
>> > vma_flags_t across madvise.c, which involves changing a few function
>> > signatures, whose callers must be updated.
>>
>> Ah, yeah. What on earth does arch/powerpc/kvm/book3s_hv_uvmem.c do with madvise :(
>
> Yeah it's quite worrying that... :)
>

Thanks David & Lorenzo, for pointing this out. I have changed this to
use ksm_disable() instead [1], which then also removes vm_flags_t usage
from there.

Please take a look at it whenever you can. Since it also removes the
EXPORT of ksm_madvise(), I think we will anyways need an Acked-by there.
(note that: looking at those changes, it seems like it should go via
powerpc tree)

[1]: https://lore.kernel.org/linuxppc-dev/0500fbfbb98776091c89584155368610095b4dd5.1794537345.git.ritesh.list@gmail.com/

-ritesh

