Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6190C88E75
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 04:57:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AEE26B008A; Fri, 18 Sep 2026 00:57:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5866E6B008C; Fri, 18 Sep 2026 00:57:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49CEF6B0092; Fri, 18 Sep 2026 00:57:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1BAE56B008A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 00:57:16 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 727BC12058C
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 04:57:15 +0000 (UTC)
X-FDA: 85225674030.17.75EEE88
Received: from mail-pz2-f43.google.com (mail-pz2-f43.google.com [74.125.228.43])
	by imf18.hostedemail.com (Postfix) with ESMTP id D5C6A1C0008
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 04:57:12 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=gQxCVvuL;
	spf=pass (imf18.hostedemail.com: domain of sunjunchao@bytedance.com designates 74.125.228.43 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789707433;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BINWNM6rAXczaz/wqYMANaQxaxCeH43keYl+j5zAlsg=;
	b=vopOqmAA3zn7Njl7oL1wpDMZrA05NOjbUUHSa7hA6xKtK8ItJUx1MJRJCmb5y6L9X3LC5T
	/hcwYJ4P61I27lK2R+dNiW9FaKaD4pXhnpQxRSWgvQG4/rpb5P98D6gOyF66qtqvJLCJ9l
	IpzZYTiLnDkiwnUhUQHkqR0WiThynUU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789707433;
	b=gSW7ETuQab4aDlqgmQIgt/ZsKzgbe7tloEwc97swYqvfuCxZ+dGaS9+SgcOLkx8+I4w4A+
	DjtetbUPdf6PdKR/kCwK6hc0LuKbrupyWprJvRrWbrWvzSzYj8J58zBHbxalMmj7L3+wjw
	Vu9FbtKE1OG0VpGlkg9V6nOMKtUsNNY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=gQxCVvuL;
	spf=pass (imf18.hostedemail.com: domain of sunjunchao@bytedance.com designates 74.125.228.43 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pz2-f43.google.com with SMTP id d2e1a72fcca58-85469d249c5so276596b3a.3
        for <linux-mm@kvack.org>; Thu, 17 Sep 2026 21:57:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1789707431; x=1790312231; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=BINWNM6rAXczaz/wqYMANaQxaxCeH43keYl+j5zAlsg=;
        b=gQxCVvuL2Aa4WtitZFUGwLEycWKooAblL1YChzZmhVIWTrj0958QzWQswfr8l6cRAi
         Vb78MSc1rjHF0z4DY1qrobKZkIBelAGjgeLS+pBcXSraq1RCVHvRi/GzWoVcya0A7S9g
         D1GKqKqDeRlWm5AcqEqpnk+jZ001xOxzGR4kupYkxoRhu2qY3itGVi0YmALKUf6UzaiJ
         DE5FgnI/IjWmAZqb2yvVehxrj0yN64JIkUWMt5Xb0J1AtkOQe6OZvvcK3bB1vkZ/BAt5
         YtkWsazr1l7+SH4yEjq4JlMuoJroq9vynFMlCGdbs7T6DHilpOlKCGGQMocC6DXXhjEZ
         J41A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789707431; x=1790312231;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BINWNM6rAXczaz/wqYMANaQxaxCeH43keYl+j5zAlsg=;
        b=yqEGBXvngJWMDzB/BxyYwJwQanXocY2Lhkxq4CLJNuRdqy0+5Pb0J/bHtTXAdz3lsq
         F7PhqPCbUBmvy5pIsMmEOdzkKv7oF95Za9uobBf4J8Thi5zZluBYt28Qz61hzSIeDTtq
         WtAHRKbApeWyNaTxvFYJ5Cte8nsvj+OqEj/aGGcd0Jf2mrE2Q/6Nc3gZNL9m4UKXykJZ
         ugccXYCj9PenhCeYFTgqrzp3k+lwmG/a2WDV9yVhTvny4roQQ8cl0tqCpk1DzMRppbbg
         IEjIupZ4XBeh90yM2HLbLdB1ak9RQCvLH7f8N+OOGzFYGBCE11W4cl0e2ZNToGgI35PF
         ZrmQ==
X-Forwarded-Encrypted: i=1; AKwUvByPL8tg8GTW0p1gI7kqXxXnkBWrgIVztfqVqRA1rZaDHwI/YMnKZiEqeRolRPYpzUZmq8U9tYo+Pw==@kvack.org
X-Gm-Message-State: AFuF++l8JT3klAm2yj8HXfCWZ55v39XhXKltJ4qXU7RORLgfsmdWQLgO
	gAExIimj/AGKOQcbntfQcsBdlMFo2bbKJLXgKWXX79UxJzEenzJc6lXA2zGcwa3TPWg=
X-Gm-Gg: AYBFou29OXpTtB5RmynUuGNDTxZUKwfZwtwzVNPrUrhnEyFM4DOHKjWXk3gJwhAzPb5
	a9tvlul5jHbvsiEdb8RnkM8qA5Bp56cyxVf8uARFfWzd7pt5uMgyOaZ8kG5YR8ZtZeID4rIZ6Kk
	3njctKjYO6ekFaf3d9jWM4mR5Sz2tosG8edFI9pOoqlkSeqYb+9NmhaQ4BHPElkgTEY8J/AC0Df
	cIimgeXsPfpEUyVnUvZsZv+6PdTurizI6NVtUGOLX5dryyVXRZDGCNpdMRcZ+NDgcsoJj0n9BKD
	Fp4mrZex9uLkYaAZfLUWDesu5sogZO9juO6ytdVSoe/r4sLP7C13X1URjlZc/Tx/9IurCgywFVv
	HNGw829pCFrWtCQesSFnRchx4P5NwvPtK/aPd7BDll31dNWWvRKt9fMZPs87ppJKqoTELtscH/N
	XISwVFUkcH6bmxVBDFZpJ/GE4SvlqsuBXVqmrVHvwM+gjWUiZ2WO5Tos0QoSlyUrZ55iseUqs9q
	J4a+spxlRLh/5t2ho7Ize8guofXfA==
X-Received: by 2002:a05:6a20:ce43:b0:3b4:7e2d:a3c2 with SMTP id adf61e73a8af0-3dd8c44e218mr2662348637.18.1789707431275;
        Thu, 17 Sep 2026 21:57:11 -0700 (PDT)
Received: from [10.71.180.110] ([203.208.189.9])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33c287b0293sm1111628eec.24.2026.09.17.21.57.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Sep 2026 21:57:10 -0700 (PDT)
Message-ID: <836b5192-ef11-4f16-8c90-049d570959a2@bytedance.com>
Date: Fri, 18 Sep 2026 12:57:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 0/3] memcg,writeback: flush foreign bdev mappings
 separately
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, axboe@kernel.dk, hannes@cmpxchg.org,
 mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 muchun.song@linux.dev, willy@infradead.org, jack@suse.cz, tj@kernel.org
References: <20260917065759.2643940-1-sunjunchao@bytedance.com>
 <20260917155305.7a63e01ba3ed34ed0aea537f@linux-foundation.org>
From: Julian Sun <sunjunchao@bytedance.com>
In-Reply-To: <20260917155305.7a63e01ba3ed34ed0aea537f@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 1o8tfu3awjrtctynj1qds51ywecicwq1
X-Rspam-User: 
X-Rspamd-Queue-Id: D5C6A1C0008
X-Rspamd-Server: rspam03
X-HE-Tag: 1789707432-1360
X-HE-Meta: U2FsdGVkX18jVFvubLY9WrKPR2jQZu1wD78v501IN7gzB9TPQtPskfpzw2CUJVPnLmSMfCdDYWD+09QkYjKFDlwhRjJcfK31ruCgvh+q42Ke2XP2R5PmRnlNs9q1uoCpY4IsqSdOOE/FyuSD79TfjJdrU68Wq/p0VxnBq8KblavXUXywNfBaWhxB+3HG+aykrybNXDYR20/qcYPlj/mi/ujDFRJs6o2mbSkdfBg7FeX8wvU5a4D0fRSGSinvjFJmxkF2ImVujZdGDMX+M5ugP/g/C9sujz0YtdsC2cySrY4TRA42QMeSJE+QSfCwAMBUoKEsbx071frH+/zSeNkoO4v4R7IHGnW0GjeSNTeECecQuDgy++VrmCX61JZNsnrdhDTGGV3wOuHw5PzC5m35PJ/SBZp1MOjHHOCnzb/HL/yS1U4ZXiyXOXVuaphC5Bsvos1gqO/STsZS3rv6PbyJQ0/DojUh4GoSDAmuvrwPlMm48YfXx3VUNBnp0deEqIo0nDYhPNEEe+h2cwDcpwi14MU43+yBfV/KiEHoOb9FPp2uTkPobeADKlXiLWRFvkXlbaDZgTvva8Nw2qUeTGo9L0EV+EnfbmTRQlILgsrQP9bAyMXOh7fL32lGycjJuyJ3KCzJDBPJKwsD4FwzDBwXlps7WEo2Ul7BPua8BAlp90eUqr9eTTyrU2MEOrIgT+s6xpRzHe0QQChGJJPmsSP2DQlouDZWY8XMQ56Oy6O5uqozYO3feuStp4lNcS5E0WFScLclj6dHEUPvoXUFn6v/6Tb1wGtlmtfHT1e3ca5YLjxg6tyAj1GW/e0EPejI78Eb7yEVTzfdSqXoElR6nvmlbwUyUHeU5p1s2Cceyy3DKi+42GcCmq7e0PtfYYq3VxIcUJ9YXTBLjN43hW+mg8AFUdLEmWq449auOX8IAFuafaMIJDIajKAWulO56fz1Xrc0fSl4WSphFqSYwvNa3hA
 VdJpnk/h
 JeXLEVDtVtaSd6eobvVGvsEAjYLniAq6NATaVcTsp++AOsshLDw4nl2n5s+9+PG+Lxpbk3rTRmsBv/KFVrVM56KrRIuffeJGG/VW6En2SMtNzPZhklH+G2emiHXVd65wkLyfcWcjWhygnqldGVLDAcnUjFPgHm3ttk/nWa40faFZTFoczHhvOZBIWKSH/J+Z9yiIZLXxVVxrfT3NmIwI/rSL/7JfGCmxEoVyNgKeSBwypSWfiU2Rghk/vwsEQ6mZywJApWfEbQ4uTlX9OY6ru2sKtc9SS+/zODGpn4mpsW9218EUCIaFomvLrrTZMTdhjJ8tFMsfFSyF8ggozETIuRCDuI997taJ6v6K+IuNfILWAopM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/18/26 6:53 AM, Andrew Morton wrote:
> On Thu, 17 Sep 2026 14:57:56 +0800 Julian Sun <sunjunchao@bytedance.com> wrote:
> 
>> Hi,
>>
>>
>> Measured impact
>> ===============
>>
>> The synthetic test used a VM with 4 vCPUs, 8 GiB RAM, ext4 and cgroup
>> v2, with device write bandwidth capped at 200 MiB/s. Background fio
>> repeatedly overwrote a 256 MiB file using buffered I/O, while
>> foreground fio performed sequential direct writes. Four memcgs
>> generated metadata and buffered writes to trigger foreign flushes.
>>
>> We measured completed block writes to the background fio file,
>> including final sync, and foreground fio bandwidth, latency and
>> completion time.
>>
>> Across three runs per kernel, mean background file write I/O decreased
>> by 72.7%, foreground bandwidth increased by 23.0%, and completion time
>> decreased by 18.8%.
>>
>> Metric                         Baseline    Patched     Change
>> Background file write I/O (GiB)    6.154      1.680     -72.7%
>> Foreground bandwidth (MiB/s)      150.29     184.81     +23.0%
>> Foreground completion time (s)   109.203     88.652     -18.8%
>> Foreground mean latency (ms)      212.84     172.74     -18.8%
> 
> Thanks.
> 
> As I understand it, this is basically ext4-specific.
> 
> I don't think btrfs or xfs mess with the bdev address_space at all? 
> But google tells me that "roughly 70% to 80% of all Linux machines use
> ext4 as their primary or root file system", so there is that.

Yes, most of our systems still use ext4.
> 
>> Approach
>> ========
>>
>> Following Jan's suggestion, this series records foreign bdev targets
>> separately and flushes their mappings instead of their owner wbs. This
>> preserves a way for dirty throttling to initiate bdev writeback while
>> avoiding owner-wide writeback triggered by these records. The existing
>> foreign-wb mechanism remains unchanged for other inodes.
>>
>> Tracking is best effort: each memcg keeps a bounded set of device
>> numbers without persistent device or inode references. Closed devices
>> and devices with a busy open_mutex are skipped. Device removal and
>> device-number reuse may race with lookup.
> 
> This part looks plain nasty.  Why are we messing with dev_t's and
> risking these races?
> 
> At the very least, this description should explain the reasoning behind
> this decision at some length.
> 
> Surely it's cleaner and safer to grab a ref on something (the bdev
> inode?) and hang onto that object.  Use it for these operations, let it
> go at the appropriate time.  Clearly there's something wrong with that
> approach, but what?

This follows the existing foreign-writeback mechanism's best-effort design:
it records IDs without holding any references and tolerates occasional
stale hints. I followed the same approach for bdev tracking by recording
dev_t.

Taking a device reference would introduce additional lifetime management.
If we acquire a reference during foreign tracking but the memcg does not
enter dirty throttling for a long time, no foreign flush would consume
the record and release the reference, then delaying final device-object
release. A timeout mechanism would only limit this delay, not eliminate it.

There is also a locking issue: dropping a record happens under mapping->i_pages,
but dropping the last reference may sleep. We would therefore need to restructure
the release path, adding concurrency and lifetime-management complexity.

Recording only dev_t follows the existing mechanism's best-effort design.
Device-number reuse may cause a stale record to trigger writeback of the new device's
own mapping. In my view, this occasional unnecessary writeback is an acceptable
trade-off for avoiding the complexity above.
> 
>> Flushes run asynchronously on a dedicated workqueue to isolate these
>> frequently triggered tasks from existing workqueue users. If workqueue
>> allocation fails, the existing foreign-wb mechanism remains in use.
> 
> Unclear what this means.  If a kmalloc/etc fails then we fall back to
> the current (mainline) behavior?  Fair enough, failure of small
> kmallocs are so rare.  The main problem is testing the failure-path
> code!

Yes, if allocation of memcg_bdev_frn_wq in mem_cgroup_init() fails,
foreign writeback falls back to the existing mechanism. The workqueue is 
allocated once during initialization. The new tracking and work-
queueing paths use preallocated per-memcg slots and perform no dynamic
allocation at runtime. please see patch 2 for more details.

I tested this failure path by forcing the workqueue pointer to NULL
and the results were as expected.> 
> 
> Also, and most importantly, what the heck is "frn"?  Would the world
> end if you did s/frn/foreign/g?

Emmm, the naming follows the existing code. I'll rename the new uses
of "frn" to "foreign" in the next version. Renaming the existing code
would be a separate cleanup patch; I'd prefer not to mix that into this
fix series.

Thanks,
-- 
Julian Sun <sunjunchao@bytedance.com>

